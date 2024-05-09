1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC165
6  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
7  */
8 interface ERC165 {
9 
10   /**
11    * @notice Query if a contract implements an interface
12    * @param _interfaceId The interface identifier, as specified in ERC-165
13    * @dev Interface identification is specified in ERC-165. This function
14    * uses less than 30,000 gas.
15    */
16   function supportsInterface(bytes4 _interfaceId)
17     external
18     view
19     returns (bool);
20 }
21 //  contract that uses the Azimuth data contract
22 
23 /**
24  * @title Ownable
25  * @dev The Ownable contract has an owner address, and provides basic authorization control
26  * functions, this simplifies the implementation of "user permissions".
27  */
28 contract Ownable {
29   address public owner;
30 
31 
32   event OwnershipRenounced(address indexed previousOwner);
33   event OwnershipTransferred(
34     address indexed previousOwner,
35     address indexed newOwner
36   );
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to relinquish control of the contract.
57    * @notice Renouncing to ownership will leave the contract without an owner.
58    * It will not be possible to call the functions with the `onlyOwner`
59    * modifier anymore.
60    */
61   function renounceOwnership() public onlyOwner {
62     emit OwnershipRenounced(owner);
63     owner = address(0);
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address _newOwner) public onlyOwner {
71     _transferOwnership(_newOwner);
72   }
73 
74   /**
75    * @dev Transfers control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function _transferOwnership(address _newOwner) internal {
79     require(_newOwner != address(0));
80     emit OwnershipTransferred(owner, _newOwner);
81     owner = _newOwner;
82   }
83 }
84 
85 
86 
87 //  the azimuth data store
88 //  https://azimuth.network
89 
90 
91 
92 
93 
94 //  Azimuth: point state data contract
95 //
96 //    This contract is used for storing all data related to Azimuth points
97 //    and their ownership. Consider this contract the Azimuth ledger.
98 //
99 //    It also contains permissions data, which ties in to ERC721
100 //    functionality. Operators of an address are allowed to transfer
101 //    ownership of all points owned by their associated address
102 //    (ERC721's approveAll()). A transfer proxy is allowed to transfer
103 //    ownership of a single point (ERC721's approve()).
104 //    Separate from ERC721 are managers, assigned per point. They are
105 //    allowed to perform "low-impact" operations on the owner's points,
106 //    like configuring public keys and making escape requests.
107 //
108 //    Since data stores are difficult to upgrade, this contract contains
109 //    as little actual business logic as possible. Instead, the data stored
110 //    herein can only be modified by this contract's owner, which can be
111 //    changed and is thus upgradable/replaceable.
112 //
113 //    This contract will be owned by the Ecliptic contract.
114 //
115 contract Azimuth is Ownable
116 {
117 //
118 //  Events
119 //
120 
121   //  OwnerChanged: :point is now owned by :owner
122   //
123   event OwnerChanged(uint32 indexed point, address indexed owner);
124 
125   //  Activated: :point is now active
126   //
127   event Activated(uint32 indexed point);
128 
129   //  Spawned: :prefix has spawned :child
130   //
131   event Spawned(uint32 indexed prefix, uint32 indexed child);
132 
133   //  EscapeRequested: :point has requested a new :sponsor
134   //
135   event EscapeRequested(uint32 indexed point, uint32 indexed sponsor);
136 
137   //  EscapeCanceled: :point's :sponsor request was canceled or rejected
138   //
139   event EscapeCanceled(uint32 indexed point, uint32 indexed sponsor);
140 
141   //  EscapeAccepted: :point confirmed with a new :sponsor
142   //
143   event EscapeAccepted(uint32 indexed point, uint32 indexed sponsor);
144 
145   //  LostSponsor: :point's :sponsor is now refusing it service
146   //
147   event LostSponsor(uint32 indexed point, uint32 indexed sponsor);
148 
149   //  ChangedKeys: :point has new network public keys
150   //
151   event ChangedKeys( uint32 indexed point,
152                      bytes32 encryptionKey,
153                      bytes32 authenticationKey,
154                      uint32 cryptoSuiteVersion,
155                      uint32 keyRevisionNumber );
156 
157   //  BrokeContinuity: :point has a new continuity number, :number
158   //
159   event BrokeContinuity(uint32 indexed point, uint32 number);
160 
161   //  ChangedSpawnProxy: :spawnProxy can now spawn using :point
162   //
163   event ChangedSpawnProxy(uint32 indexed point, address indexed spawnProxy);
164 
165   //  ChangedTransferProxy: :transferProxy can now transfer ownership of :point
166   //
167   event ChangedTransferProxy( uint32 indexed point,
168                               address indexed transferProxy );
169 
170   //  ChangedManagementProxy: :managementProxy can now manage :point
171   //
172   event ChangedManagementProxy( uint32 indexed point,
173                                 address indexed managementProxy );
174 
175   //  ChangedVotingProxy: :votingProxy can now vote using :point
176   //
177   event ChangedVotingProxy(uint32 indexed point, address indexed votingProxy);
178 
179   //  ChangedDns: dnsDomains have been updated
180   //
181   event ChangedDns(string primary, string secondary, string tertiary);
182 
183 //
184 //  Structures
185 //
186 
187   //  Size: kinds of points registered on-chain
188   //
189   //    NOTE: the order matters, because of Solidity enum numbering
190   //
191   enum Size
192   {
193     Galaxy, // = 0
194     Star,   // = 1
195     Planet  // = 2
196   }
197 
198   //  Point: state of a point
199   //
200   //    While the ordering of the struct members is semantically chaotic,
201   //    they are ordered to tightly pack them into Ethereum's 32-byte storage
202   //    slots, which reduces gas costs for some function calls.
203   //    The comment ticks indicate assumed slot boundaries.
204   //
205   struct Point
206   {
207     //  encryptionKey: (curve25519) encryption public key, or 0 for none
208     //
209     bytes32 encryptionKey;
210   //
211     //  authenticationKey: (ed25519) authentication public key, or 0 for none
212     //
213     bytes32 authenticationKey;
214   //
215     //  spawned: for stars and galaxies, all :active children
216     //
217     uint32[] spawned;
218   //
219     //  hasSponsor: true if the sponsor still supports the point
220     //
221     bool hasSponsor;
222 
223     //  active: whether point can be linked
224     //
225     //    false: point belongs to prefix, cannot be configured or linked
226     //    true: point no longer belongs to prefix, can be configured and linked
227     //
228     bool active;
229 
230     //  escapeRequested: true if the point has requested to change sponsors
231     //
232     bool escapeRequested;
233 
234     //  sponsor: the point that supports this one on the network, or,
235     //           if :hasSponsor is false, the last point that supported it.
236     //           (by default, the point's half-width prefix)
237     //
238     uint32 sponsor;
239 
240     //  escapeRequestedTo: if :escapeRequested is true, new sponsor requested
241     //
242     uint32 escapeRequestedTo;
243 
244     //  cryptoSuiteVersion: version of the crypto suite used for the pubkeys
245     //
246     uint32 cryptoSuiteVersion;
247 
248     //  keyRevisionNumber: incremented every time the public keys change
249     //
250     uint32 keyRevisionNumber;
251 
252     //  continuityNumber: incremented to indicate network-side state loss
253     //
254     uint32 continuityNumber;
255   }
256 
257   //  Deed: permissions for a point
258   //
259   struct Deed
260   {
261     //  owner: address that owns this point
262     //
263     address owner;
264 
265     //  managementProxy: 0, or another address with the right to perform
266     //                   low-impact, managerial operations on this point
267     //
268     address managementProxy;
269 
270     //  spawnProxy: 0, or another address with the right to spawn children
271     //              of this point
272     //
273     address spawnProxy;
274 
275     //  votingProxy: 0, or another address with the right to vote as this point
276     //
277     address votingProxy;
278 
279     //  transferProxy: 0, or another address with the right to transfer
280     //                 ownership of this point
281     //
282     address transferProxy;
283   }
284 
285 //
286 //  General state
287 //
288 
289   //  points: per point, general network-relevant point state
290   //
291   mapping(uint32 => Point) public points;
292 
293   //  rights: per point, on-chain ownership and permissions
294   //
295   mapping(uint32 => Deed) public rights;
296 
297   //  operators: per owner, per address, has the right to transfer ownership
298   //             of all the owner's points (ERC721)
299   //
300   mapping(address => mapping(address => bool)) public operators;
301 
302   //  dnsDomains: base domains for contacting galaxies
303   //
304   //    dnsDomains[0] is primary, the others are used as fallbacks
305   //
306   string[3] public dnsDomains;
307 
308 //
309 //  Lookups
310 //
311 
312   //  sponsoring: per point, the points they are sponsoring
313   //
314   mapping(uint32 => uint32[]) public sponsoring;
315 
316   //  sponsoringIndexes: per point, per point, (index + 1) in
317   //                     the sponsoring array
318   //
319   mapping(uint32 => mapping(uint32 => uint256)) public sponsoringIndexes;
320 
321   //  escapeRequests: per point, the points they have open escape requests from
322   //
323   mapping(uint32 => uint32[]) public escapeRequests;
324 
325   //  escapeRequestsIndexes: per point, per point, (index + 1) in
326   //                         the escapeRequests array
327   //
328   mapping(uint32 => mapping(uint32 => uint256)) public escapeRequestsIndexes;
329 
330   //  pointsOwnedBy: per address, the points they own
331   //
332   mapping(address => uint32[]) public pointsOwnedBy;
333 
334   //  pointOwnerIndexes: per owner, per point, (index + 1) in
335   //                     the pointsOwnedBy array
336   //
337   //    We delete owners by moving the last entry in the array to the
338   //    newly emptied slot, which is (n - 1) where n is the value of
339   //    pointOwnerIndexes[owner][point].
340   //
341   mapping(address => mapping(uint32 => uint256)) public pointOwnerIndexes;
342 
343   //  managerFor: per address, the points they are the management proxy for
344   //
345   mapping(address => uint32[]) public managerFor;
346 
347   //  managerForIndexes: per address, per point, (index + 1) in
348   //                     the managerFor array
349   //
350   mapping(address => mapping(uint32 => uint256)) public managerForIndexes;
351 
352   //  spawningFor: per address, the points they can spawn with
353   //
354   mapping(address => uint32[]) public spawningFor;
355 
356   //  spawningForIndexes: per address, per point, (index + 1) in
357   //                      the spawningFor array
358   //
359   mapping(address => mapping(uint32 => uint256)) public spawningForIndexes;
360 
361   //  votingFor: per address, the points they can vote with
362   //
363   mapping(address => uint32[]) public votingFor;
364 
365   //  votingForIndexes: per address, per point, (index + 1) in
366   //                    the votingFor array
367   //
368   mapping(address => mapping(uint32 => uint256)) public votingForIndexes;
369 
370   //  transferringFor: per address, the points they can transfer
371   //
372   mapping(address => uint32[]) public transferringFor;
373 
374   //  transferringForIndexes: per address, per point, (index + 1) in
375   //                          the transferringFor array
376   //
377   mapping(address => mapping(uint32 => uint256)) public transferringForIndexes;
378 
379 //
380 //  Logic
381 //
382 
383   //  constructor(): configure default dns domains
384   //
385   constructor()
386     public
387   {
388     setDnsDomains("example.com", "example.com", "example.com");
389   }
390 
391   //  setDnsDomains(): set the base domains used for contacting galaxies
392   //
393   //    Note: since a string is really just a byte[], and Solidity can't
394   //    work with two-dimensional arrays yet, we pass in the three
395   //    domains as individual strings.
396   //
397   function setDnsDomains(string _primary, string _secondary, string _tertiary)
398     onlyOwner
399     public
400   {
401     dnsDomains[0] = _primary;
402     dnsDomains[1] = _secondary;
403     dnsDomains[2] = _tertiary;
404     emit ChangedDns(_primary, _secondary, _tertiary);
405   }
406 
407   //
408   //  Point reading
409   //
410 
411     //  isActive(): return true if _point is active
412     //
413     function isActive(uint32 _point)
414       view
415       external
416       returns (bool equals)
417     {
418       return points[_point].active;
419     }
420 
421     //  getKeys(): returns the public keys and their details, as currently
422     //             registered for _point
423     //
424     function getKeys(uint32 _point)
425       view
426       external
427       returns (bytes32 crypt, bytes32 auth, uint32 suite, uint32 revision)
428     {
429       Point storage point = points[_point];
430       return (point.encryptionKey,
431               point.authenticationKey,
432               point.cryptoSuiteVersion,
433               point.keyRevisionNumber);
434     }
435 
436     //  getKeyRevisionNumber(): gets the revision number of _point's current
437     //                          public keys
438     //
439     function getKeyRevisionNumber(uint32 _point)
440       view
441       external
442       returns (uint32 revision)
443     {
444       return points[_point].keyRevisionNumber;
445     }
446 
447     //  hasBeenLinked(): returns true if the point has ever been assigned keys
448     //
449     function hasBeenLinked(uint32 _point)
450       view
451       external
452       returns (bool result)
453     {
454       return ( points[_point].keyRevisionNumber > 0 );
455     }
456 
457     //  isLive(): returns true if _point currently has keys properly configured
458     //
459     function isLive(uint32 _point)
460       view
461       external
462       returns (bool result)
463     {
464       Point storage point = points[_point];
465       return ( point.encryptionKey != 0 &&
466                point.authenticationKey != 0 &&
467                point.cryptoSuiteVersion != 0 );
468     }
469 
470     //  getContinuityNumber(): returns _point's current continuity number
471     //
472     function getContinuityNumber(uint32 _point)
473       view
474       external
475       returns (uint32 continuityNumber)
476     {
477       return points[_point].continuityNumber;
478     }
479 
480     //  getSpawnCount(): return the number of children spawned by _point
481     //
482     function getSpawnCount(uint32 _point)
483       view
484       external
485       returns (uint32 spawnCount)
486     {
487       uint256 len = points[_point].spawned.length;
488       assert(len < 2**32);
489       return uint32(len);
490     }
491 
492     //  getSpawned(): return array of points created under _point
493     //
494     //    Note: only useful for clients, as Solidity does not currently
495     //    support returning dynamic arrays.
496     //
497     function getSpawned(uint32 _point)
498       view
499       external
500       returns (uint32[] spawned)
501     {
502       return points[_point].spawned;
503     }
504 
505     //  hasSponsor(): returns true if _point's sponsor is providing it service
506     //
507     function hasSponsor(uint32 _point)
508       view
509       external
510       returns (bool has)
511     {
512       return points[_point].hasSponsor;
513     }
514 
515     //  getSponsor(): returns _point's current (or most recent) sponsor
516     //
517     function getSponsor(uint32 _point)
518       view
519       external
520       returns (uint32 sponsor)
521     {
522       return points[_point].sponsor;
523     }
524 
525     //  isSponsor(): returns true if _sponsor is currently providing service
526     //               to _point
527     //
528     function isSponsor(uint32 _point, uint32 _sponsor)
529       view
530       external
531       returns (bool result)
532     {
533       Point storage point = points[_point];
534       return ( point.hasSponsor &&
535                (point.sponsor == _sponsor) );
536     }
537 
538     //  getSponsoringCount(): returns the number of points _sponsor is
539     //                        providing service to
540     //
541     function getSponsoringCount(uint32 _sponsor)
542       view
543       external
544       returns (uint256 count)
545     {
546       return sponsoring[_sponsor].length;
547     }
548 
549     //  getSponsoring(): returns a list of points _sponsor is providing
550     //                   service to
551     //
552     //    Note: only useful for clients, as Solidity does not currently
553     //    support returning dynamic arrays.
554     //
555     function getSponsoring(uint32 _sponsor)
556       view
557       external
558       returns (uint32[] sponsees)
559     {
560       return sponsoring[_sponsor];
561     }
562 
563     //  escaping
564 
565     //  isEscaping(): returns true if _point has an outstanding escape request
566     //
567     function isEscaping(uint32 _point)
568       view
569       external
570       returns (bool escaping)
571     {
572       return points[_point].escapeRequested;
573     }
574 
575     //  getEscapeRequest(): returns _point's current escape request
576     //
577     //    the returned escape request is only valid as long as isEscaping()
578     //    returns true
579     //
580     function getEscapeRequest(uint32 _point)
581       view
582       external
583       returns (uint32 escape)
584     {
585       return points[_point].escapeRequestedTo;
586     }
587 
588     //  isRequestingEscapeTo(): returns true if _point has an outstanding
589     //                          escape request targetting _sponsor
590     //
591     function isRequestingEscapeTo(uint32 _point, uint32 _sponsor)
592       view
593       public
594       returns (bool equals)
595     {
596       Point storage point = points[_point];
597       return (point.escapeRequested && (point.escapeRequestedTo == _sponsor));
598     }
599 
600     //  getEscapeRequestsCount(): returns the number of points _sponsor
601     //                            is providing service to
602     //
603     function getEscapeRequestsCount(uint32 _sponsor)
604       view
605       external
606       returns (uint256 count)
607     {
608       return escapeRequests[_sponsor].length;
609     }
610 
611     //  getEscapeRequests(): get the points _sponsor has received escape
612     //                       requests from
613     //
614     //    Note: only useful for clients, as Solidity does not currently
615     //    support returning dynamic arrays.
616     //
617     function getEscapeRequests(uint32 _sponsor)
618       view
619       external
620       returns (uint32[] requests)
621     {
622       return escapeRequests[_sponsor];
623     }
624 
625   //
626   //  Point writing
627   //
628 
629     //  activatePoint(): activate a point, register it as spawned by its prefix
630     //
631     function activatePoint(uint32 _point)
632       onlyOwner
633       external
634     {
635       //  make a point active, setting its sponsor to its prefix
636       //
637       Point storage point = points[_point];
638       require(!point.active);
639       point.active = true;
640       registerSponsor(_point, true, getPrefix(_point));
641       emit Activated(_point);
642     }
643 
644     //  setKeys(): set network public keys of _point to _encryptionKey and
645     //            _authenticationKey, with the specified _cryptoSuiteVersion
646     //
647     function setKeys(uint32 _point,
648                      bytes32 _encryptionKey,
649                      bytes32 _authenticationKey,
650                      uint32 _cryptoSuiteVersion)
651       onlyOwner
652       external
653     {
654       Point storage point = points[_point];
655       if ( point.encryptionKey == _encryptionKey &&
656            point.authenticationKey == _authenticationKey &&
657            point.cryptoSuiteVersion == _cryptoSuiteVersion )
658       {
659         return;
660       }
661 
662       point.encryptionKey = _encryptionKey;
663       point.authenticationKey = _authenticationKey;
664       point.cryptoSuiteVersion = _cryptoSuiteVersion;
665       point.keyRevisionNumber++;
666 
667       emit ChangedKeys(_point,
668                        _encryptionKey,
669                        _authenticationKey,
670                        _cryptoSuiteVersion,
671                        point.keyRevisionNumber);
672     }
673 
674     //  incrementContinuityNumber(): break continuity for _point
675     //
676     function incrementContinuityNumber(uint32 _point)
677       onlyOwner
678       external
679     {
680       Point storage point = points[_point];
681       point.continuityNumber++;
682       emit BrokeContinuity(_point, point.continuityNumber);
683     }
684 
685     //  registerSpawn(): add a point to its prefix's list of spawned points
686     //
687     function registerSpawned(uint32 _point)
688       onlyOwner
689       external
690     {
691       //  if a point is its own prefix (a galaxy) then don't register it
692       //
693       uint32 prefix = getPrefix(_point);
694       if (prefix == _point)
695       {
696         return;
697       }
698 
699       //  register a new spawned point for the prefix
700       //
701       points[prefix].spawned.push(_point);
702       emit Spawned(prefix, _point);
703     }
704 
705     //  loseSponsor(): indicates that _point's sponsor is no longer providing
706     //                 it service
707     //
708     function loseSponsor(uint32 _point)
709       onlyOwner
710       external
711     {
712       Point storage point = points[_point];
713       if (!point.hasSponsor)
714       {
715         return;
716       }
717       registerSponsor(_point, false, point.sponsor);
718       emit LostSponsor(_point, point.sponsor);
719     }
720 
721     //  setEscapeRequest(): for _point, start an escape request to _sponsor
722     //
723     function setEscapeRequest(uint32 _point, uint32 _sponsor)
724       onlyOwner
725       external
726     {
727       if (isRequestingEscapeTo(_point, _sponsor))
728       {
729         return;
730       }
731       registerEscapeRequest(_point, true, _sponsor);
732       emit EscapeRequested(_point, _sponsor);
733     }
734 
735     //  cancelEscape(): for _point, stop the current escape request, if any
736     //
737     function cancelEscape(uint32 _point)
738       onlyOwner
739       external
740     {
741       Point storage point = points[_point];
742       if (!point.escapeRequested)
743       {
744         return;
745       }
746       uint32 request = point.escapeRequestedTo;
747       registerEscapeRequest(_point, false, 0);
748       emit EscapeCanceled(_point, request);
749     }
750 
751     //  doEscape(): perform the requested escape
752     //
753     function doEscape(uint32 _point)
754       onlyOwner
755       external
756     {
757       Point storage point = points[_point];
758       require(point.escapeRequested);
759       registerSponsor(_point, true, point.escapeRequestedTo);
760       registerEscapeRequest(_point, false, 0);
761       emit EscapeAccepted(_point, point.sponsor);
762     }
763 
764   //
765   //  Point utils
766   //
767 
768     //  getPrefix(): compute prefix ("parent") of _point
769     //
770     function getPrefix(uint32 _point)
771       pure
772       public
773       returns (uint16 prefix)
774     {
775       if (_point < 0x10000)
776       {
777         return uint16(_point % 0x100);
778       }
779       return uint16(_point % 0x10000);
780     }
781 
782     //  getPointSize(): return the size of _point
783     //
784     function getPointSize(uint32 _point)
785       external
786       pure
787       returns (Size _size)
788     {
789       if (_point < 0x100) return Size.Galaxy;
790       if (_point < 0x10000) return Size.Star;
791       return Size.Planet;
792     }
793 
794     //  internal use
795 
796     //  registerSponsor(): set the sponsorship state of _point and update the
797     //                     reverse lookup for sponsors
798     //
799     function registerSponsor(uint32 _point, bool _hasSponsor, uint32 _sponsor)
800       internal
801     {
802       Point storage point = points[_point];
803       bool had = point.hasSponsor;
804       uint32 prev = point.sponsor;
805 
806       //  if we didn't have a sponsor, and won't get one,
807       //  or if we get the sponsor we already have,
808       //  nothing will change, so jump out early.
809       //
810       if ( (!had && !_hasSponsor) ||
811            (had && _hasSponsor && prev == _sponsor) )
812       {
813         return;
814       }
815 
816       //  if the point used to have a different sponsor, do some gymnastics
817       //  to keep the reverse lookup gapless.  delete the point from the old
818       //  sponsor's list, then fill that gap with the list tail.
819       //
820       if (had)
821       {
822         //  i: current index in previous sponsor's list of sponsored points
823         //
824         uint256 i = sponsoringIndexes[prev][_point];
825 
826         //  we store index + 1, because 0 is the solidity default value
827         //
828         assert(i > 0);
829         i--;
830 
831         //  copy the last item in the list into the now-unused slot,
832         //  making sure to update its :sponsoringIndexes reference
833         //
834         uint32[] storage prevSponsoring = sponsoring[prev];
835         uint256 last = prevSponsoring.length - 1;
836         uint32 moved = prevSponsoring[last];
837         prevSponsoring[i] = moved;
838         sponsoringIndexes[prev][moved] = i + 1;
839 
840         //  delete the last item
841         //
842         delete(prevSponsoring[last]);
843         prevSponsoring.length = last;
844         sponsoringIndexes[prev][_point] = 0;
845       }
846 
847       if (_hasSponsor)
848       {
849         uint32[] storage newSponsoring = sponsoring[_sponsor];
850         newSponsoring.push(_point);
851         sponsoringIndexes[_sponsor][_point] = newSponsoring.length;
852       }
853 
854       point.sponsor = _sponsor;
855       point.hasSponsor = _hasSponsor;
856     }
857 
858     //  registerEscapeRequest(): set the escape state of _point and update the
859     //                           reverse lookup for sponsors
860     //
861     function registerEscapeRequest( uint32 _point,
862                                     bool _isEscaping, uint32 _sponsor )
863       internal
864     {
865       Point storage point = points[_point];
866       bool was = point.escapeRequested;
867       uint32 prev = point.escapeRequestedTo;
868 
869       //  if we weren't escaping, and won't be,
870       //  or if we were escaping, and the new target is the same,
871       //  nothing will change, so jump out early.
872       //
873       if ( (!was && !_isEscaping) ||
874            (was && _isEscaping && prev == _sponsor) )
875       {
876         return;
877       }
878 
879       //  if the point used to have a different request, do some gymnastics
880       //  to keep the reverse lookup gapless.  delete the point from the old
881       //  sponsor's list, then fill that gap with the list tail.
882       //
883       if (was)
884       {
885         //  i: current index in previous sponsor's list of sponsored points
886         //
887         uint256 i = escapeRequestsIndexes[prev][_point];
888 
889         //  we store index + 1, because 0 is the solidity default value
890         //
891         assert(i > 0);
892         i--;
893 
894         //  copy the last item in the list into the now-unused slot,
895         //  making sure to update its :escapeRequestsIndexes reference
896         //
897         uint32[] storage prevRequests = escapeRequests[prev];
898         uint256 last = prevRequests.length - 1;
899         uint32 moved = prevRequests[last];
900         prevRequests[i] = moved;
901         escapeRequestsIndexes[prev][moved] = i + 1;
902 
903         //  delete the last item
904         //
905         delete(prevRequests[last]);
906         prevRequests.length = last;
907         escapeRequestsIndexes[prev][_point] = 0;
908       }
909 
910       if (_isEscaping)
911       {
912         uint32[] storage newRequests = escapeRequests[_sponsor];
913         newRequests.push(_point);
914         escapeRequestsIndexes[_sponsor][_point] = newRequests.length;
915       }
916 
917       point.escapeRequestedTo = _sponsor;
918       point.escapeRequested = _isEscaping;
919     }
920 
921   //
922   //  Deed reading
923   //
924 
925     //  owner
926 
927     //  getOwner(): return owner of _point
928     //
929     function getOwner(uint32 _point)
930       view
931       external
932       returns (address owner)
933     {
934       return rights[_point].owner;
935     }
936 
937     //  isOwner(): true if _point is owned by _address
938     //
939     function isOwner(uint32 _point, address _address)
940       view
941       external
942       returns (bool result)
943     {
944       return (rights[_point].owner == _address);
945     }
946 
947     //  getOwnedPointCount(): return length of array of points that _whose owns
948     //
949     function getOwnedPointCount(address _whose)
950       view
951       external
952       returns (uint256 count)
953     {
954       return pointsOwnedBy[_whose].length;
955     }
956 
957     //  getOwnedPoints(): return array of points that _whose owns
958     //
959     //    Note: only useful for clients, as Solidity does not currently
960     //    support returning dynamic arrays.
961     //
962     function getOwnedPoints(address _whose)
963       view
964       external
965       returns (uint32[] ownedPoints)
966     {
967       return pointsOwnedBy[_whose];
968     }
969 
970     //  getOwnedPointAtIndex(): get point at _index from array of points that
971     //                         _whose owns
972     //
973     function getOwnedPointAtIndex(address _whose, uint256 _index)
974       view
975       external
976       returns (uint32 point)
977     {
978       uint32[] storage owned = pointsOwnedBy[_whose];
979       require(_index < owned.length);
980       return owned[_index];
981     }
982 
983     //  management proxy
984 
985     //  getManagementProxy(): returns _point's current management proxy
986     //
987     function getManagementProxy(uint32 _point)
988       view
989       external
990       returns (address manager)
991     {
992       return rights[_point].managementProxy;
993     }
994 
995     //  isManagementProxy(): returns true if _proxy is _point's management proxy
996     //
997     function isManagementProxy(uint32 _point, address _proxy)
998       view
999       external
1000       returns (bool result)
1001     {
1002       return (rights[_point].managementProxy == _proxy);
1003     }
1004 
1005     //  canManage(): true if _who is the owner or manager of _point
1006     //
1007     function canManage(uint32 _point, address _who)
1008       view
1009       external
1010       returns (bool result)
1011     {
1012       Deed storage deed = rights[_point];
1013       return ( (0x0 != _who) &&
1014                ( (_who == deed.owner) ||
1015                  (_who == deed.managementProxy) ) );
1016     }
1017 
1018     //  getManagerForCount(): returns the amount of points _proxy can manage
1019     //
1020     function getManagerForCount(address _proxy)
1021       view
1022       external
1023       returns (uint256 count)
1024     {
1025       return managerFor[_proxy].length;
1026     }
1027 
1028     //  getManagerFor(): returns the points _proxy can manage
1029     //
1030     //    Note: only useful for clients, as Solidity does not currently
1031     //    support returning dynamic arrays.
1032     //
1033     function getManagerFor(address _proxy)
1034       view
1035       external
1036       returns (uint32[] mfor)
1037     {
1038       return managerFor[_proxy];
1039     }
1040 
1041     //  spawn proxy
1042 
1043     //  getSpawnProxy(): returns _point's current spawn proxy
1044     //
1045     function getSpawnProxy(uint32 _point)
1046       view
1047       external
1048       returns (address spawnProxy)
1049     {
1050       return rights[_point].spawnProxy;
1051     }
1052 
1053     //  isSpawnProxy(): returns true if _proxy is _point's spawn proxy
1054     //
1055     function isSpawnProxy(uint32 _point, address _proxy)
1056       view
1057       external
1058       returns (bool result)
1059     {
1060       return (rights[_point].spawnProxy == _proxy);
1061     }
1062 
1063     //  canSpawnAs(): true if _who is the owner or spawn proxy of _point
1064     //
1065     function canSpawnAs(uint32 _point, address _who)
1066       view
1067       external
1068       returns (bool result)
1069     {
1070       Deed storage deed = rights[_point];
1071       return ( (0x0 != _who) &&
1072                ( (_who == deed.owner) ||
1073                  (_who == deed.spawnProxy) ) );
1074     }
1075 
1076     //  getSpawningForCount(): returns the amount of points _proxy
1077     //                         can spawn with
1078     //
1079     function getSpawningForCount(address _proxy)
1080       view
1081       external
1082       returns (uint256 count)
1083     {
1084       return spawningFor[_proxy].length;
1085     }
1086 
1087     //  getSpawningFor(): get the points _proxy can spawn with
1088     //
1089     //    Note: only useful for clients, as Solidity does not currently
1090     //    support returning dynamic arrays.
1091     //
1092     function getSpawningFor(address _proxy)
1093       view
1094       external
1095       returns (uint32[] sfor)
1096     {
1097       return spawningFor[_proxy];
1098     }
1099 
1100     //  voting proxy
1101 
1102     //  getVotingProxy(): returns _point's current voting proxy
1103     //
1104     function getVotingProxy(uint32 _point)
1105       view
1106       external
1107       returns (address voter)
1108     {
1109       return rights[_point].votingProxy;
1110     }
1111 
1112     //  isVotingProxy(): returns true if _proxy is _point's voting proxy
1113     //
1114     function isVotingProxy(uint32 _point, address _proxy)
1115       view
1116       external
1117       returns (bool result)
1118     {
1119       return (rights[_point].votingProxy == _proxy);
1120     }
1121 
1122     //  canVoteAs(): true if _who is the owner of _point,
1123     //               or the voting proxy of _point's owner
1124     //
1125     function canVoteAs(uint32 _point, address _who)
1126       view
1127       external
1128       returns (bool result)
1129     {
1130       Deed storage deed = rights[_point];
1131       return ( (0x0 != _who) &&
1132                ( (_who == deed.owner) ||
1133                  (_who == deed.votingProxy) ) );
1134     }
1135 
1136     //  getVotingForCount(): returns the amount of points _proxy can vote as
1137     //
1138     function getVotingForCount(address _proxy)
1139       view
1140       external
1141       returns (uint256 count)
1142     {
1143       return votingFor[_proxy].length;
1144     }
1145 
1146     //  getVotingFor(): returns the points _proxy can vote as
1147     //
1148     //    Note: only useful for clients, as Solidity does not currently
1149     //    support returning dynamic arrays.
1150     //
1151     function getVotingFor(address _proxy)
1152       view
1153       external
1154       returns (uint32[] vfor)
1155     {
1156       return votingFor[_proxy];
1157     }
1158 
1159     //  transfer proxy
1160 
1161     //  getTransferProxy(): returns _point's current transfer proxy
1162     //
1163     function getTransferProxy(uint32 _point)
1164       view
1165       external
1166       returns (address transferProxy)
1167     {
1168       return rights[_point].transferProxy;
1169     }
1170 
1171     //  isTransferProxy(): returns true if _proxy is _point's transfer proxy
1172     //
1173     function isTransferProxy(uint32 _point, address _proxy)
1174       view
1175       external
1176       returns (bool result)
1177     {
1178       return (rights[_point].transferProxy == _proxy);
1179     }
1180 
1181     //  canTransfer(): true if _who is the owner or transfer proxy of _point,
1182     //                 or is an operator for _point's current owner
1183     //
1184     function canTransfer(uint32 _point, address _who)
1185       view
1186       external
1187       returns (bool result)
1188     {
1189       Deed storage deed = rights[_point];
1190       return ( (0x0 != _who) &&
1191                ( (_who == deed.owner) ||
1192                  (_who == deed.transferProxy) ||
1193                  operators[deed.owner][_who] ) );
1194     }
1195 
1196     //  getTransferringForCount(): returns the amount of points _proxy
1197     //                             can transfer
1198     //
1199     function getTransferringForCount(address _proxy)
1200       view
1201       external
1202       returns (uint256 count)
1203     {
1204       return transferringFor[_proxy].length;
1205     }
1206 
1207     //  getTransferringFor(): get the points _proxy can transfer
1208     //
1209     //    Note: only useful for clients, as Solidity does not currently
1210     //    support returning dynamic arrays.
1211     //
1212     function getTransferringFor(address _proxy)
1213       view
1214       external
1215       returns (uint32[] tfor)
1216     {
1217       return transferringFor[_proxy];
1218     }
1219 
1220     //  isOperator(): returns true if _operator is allowed to transfer
1221     //                ownership of _owner's points
1222     //
1223     function isOperator(address _owner, address _operator)
1224       view
1225       external
1226       returns (bool result)
1227     {
1228       return operators[_owner][_operator];
1229     }
1230 
1231   //
1232   //  Deed writing
1233   //
1234 
1235     //  setOwner(): set owner of _point to _owner
1236     //
1237     //    Note: setOwner() only implements the minimal data storage
1238     //    logic for a transfer; the full transfer is implemented in
1239     //    Ecliptic.
1240     //
1241     //    Note: _owner must not be the zero address.
1242     //
1243     function setOwner(uint32 _point, address _owner)
1244       onlyOwner
1245       external
1246     {
1247       //  prevent burning of points by making zero the owner
1248       //
1249       require(0x0 != _owner);
1250 
1251       //  prev: previous owner, if any
1252       //
1253       address prev = rights[_point].owner;
1254 
1255       if (prev == _owner)
1256       {
1257         return;
1258       }
1259 
1260       //  if the point used to have a different owner, do some gymnastics to
1261       //  keep the list of owned points gapless.  delete this point from the
1262       //  list, then fill that gap with the list tail.
1263       //
1264       if (0x0 != prev)
1265       {
1266         //  i: current index in previous owner's list of owned points
1267         //
1268         uint256 i = pointOwnerIndexes[prev][_point];
1269 
1270         //  we store index + 1, because 0 is the solidity default value
1271         //
1272         assert(i > 0);
1273         i--;
1274 
1275         //  copy the last item in the list into the now-unused slot,
1276         //  making sure to update its :pointOwnerIndexes reference
1277         //
1278         uint32[] storage owner = pointsOwnedBy[prev];
1279         uint256 last = owner.length - 1;
1280         uint32 moved = owner[last];
1281         owner[i] = moved;
1282         pointOwnerIndexes[prev][moved] = i + 1;
1283 
1284         //  delete the last item
1285         //
1286         delete(owner[last]);
1287         owner.length = last;
1288         pointOwnerIndexes[prev][_point] = 0;
1289       }
1290 
1291       //  update the owner list and the owner's index list
1292       //
1293       rights[_point].owner = _owner;
1294       pointsOwnedBy[_owner].push(_point);
1295       pointOwnerIndexes[_owner][_point] = pointsOwnedBy[_owner].length;
1296       emit OwnerChanged(_point, _owner);
1297     }
1298 
1299     //  setManagementProxy(): makes _proxy _point's management proxy
1300     //
1301     function setManagementProxy(uint32 _point, address _proxy)
1302       onlyOwner
1303       external
1304     {
1305       Deed storage deed = rights[_point];
1306       address prev = deed.managementProxy;
1307       if (prev == _proxy)
1308       {
1309         return;
1310       }
1311 
1312       //  if the point used to have a different manager, do some gymnastics
1313       //  to keep the reverse lookup gapless.  delete the point from the
1314       //  old manager's list, then fill that gap with the list tail.
1315       //
1316       if (0x0 != prev)
1317       {
1318         //  i: current index in previous manager's list of managed points
1319         //
1320         uint256 i = managerForIndexes[prev][_point];
1321 
1322         //  we store index + 1, because 0 is the solidity default value
1323         //
1324         assert(i > 0);
1325         i--;
1326 
1327         //  copy the last item in the list into the now-unused slot,
1328         //  making sure to update its :managerForIndexes reference
1329         //
1330         uint32[] storage prevMfor = managerFor[prev];
1331         uint256 last = prevMfor.length - 1;
1332         uint32 moved = prevMfor[last];
1333         prevMfor[i] = moved;
1334         managerForIndexes[prev][moved] = i + 1;
1335 
1336         //  delete the last item
1337         //
1338         delete(prevMfor[last]);
1339         prevMfor.length = last;
1340         managerForIndexes[prev][_point] = 0;
1341       }
1342 
1343       if (0x0 != _proxy)
1344       {
1345         uint32[] storage mfor = managerFor[_proxy];
1346         mfor.push(_point);
1347         managerForIndexes[_proxy][_point] = mfor.length;
1348       }
1349 
1350       deed.managementProxy = _proxy;
1351       emit ChangedManagementProxy(_point, _proxy);
1352     }
1353 
1354     //  setSpawnProxy(): makes _proxy _point's spawn proxy
1355     //
1356     function setSpawnProxy(uint32 _point, address _proxy)
1357       onlyOwner
1358       external
1359     {
1360       Deed storage deed = rights[_point];
1361       address prev = deed.spawnProxy;
1362       if (prev == _proxy)
1363       {
1364         return;
1365       }
1366 
1367       //  if the point used to have a different spawn proxy, do some
1368       //  gymnastics to keep the reverse lookup gapless.  delete the point
1369       //  from the old proxy's list, then fill that gap with the list tail.
1370       //
1371       if (0x0 != prev)
1372       {
1373         //  i: current index in previous proxy's list of spawning points
1374         //
1375         uint256 i = spawningForIndexes[prev][_point];
1376 
1377         //  we store index + 1, because 0 is the solidity default value
1378         //
1379         assert(i > 0);
1380         i--;
1381 
1382         //  copy the last item in the list into the now-unused slot,
1383         //  making sure to update its :spawningForIndexes reference
1384         //
1385         uint32[] storage prevSfor = spawningFor[prev];
1386         uint256 last = prevSfor.length - 1;
1387         uint32 moved = prevSfor[last];
1388         prevSfor[i] = moved;
1389         spawningForIndexes[prev][moved] = i + 1;
1390 
1391         //  delete the last item
1392         //
1393         delete(prevSfor[last]);
1394         prevSfor.length = last;
1395         spawningForIndexes[prev][_point] = 0;
1396       }
1397 
1398       if (0x0 != _proxy)
1399       {
1400         uint32[] storage sfor = spawningFor[_proxy];
1401         sfor.push(_point);
1402         spawningForIndexes[_proxy][_point] = sfor.length;
1403       }
1404 
1405       deed.spawnProxy = _proxy;
1406       emit ChangedSpawnProxy(_point, _proxy);
1407     }
1408 
1409     //  setVotingProxy(): makes _proxy _point's voting proxy
1410     //
1411     function setVotingProxy(uint32 _point, address _proxy)
1412       onlyOwner
1413       external
1414     {
1415       Deed storage deed = rights[_point];
1416       address prev = deed.votingProxy;
1417       if (prev == _proxy)
1418       {
1419         return;
1420       }
1421 
1422       //  if the point used to have a different voter, do some gymnastics
1423       //  to keep the reverse lookup gapless.  delete the point from the
1424       //  old voter's list, then fill that gap with the list tail.
1425       //
1426       if (0x0 != prev)
1427       {
1428         //  i: current index in previous voter's list of points it was
1429         //     voting for
1430         //
1431         uint256 i = votingForIndexes[prev][_point];
1432 
1433         //  we store index + 1, because 0 is the solidity default value
1434         //
1435         assert(i > 0);
1436         i--;
1437 
1438         //  copy the last item in the list into the now-unused slot,
1439         //  making sure to update its :votingForIndexes reference
1440         //
1441         uint32[] storage prevVfor = votingFor[prev];
1442         uint256 last = prevVfor.length - 1;
1443         uint32 moved = prevVfor[last];
1444         prevVfor[i] = moved;
1445         votingForIndexes[prev][moved] = i + 1;
1446 
1447         //  delete the last item
1448         //
1449         delete(prevVfor[last]);
1450         prevVfor.length = last;
1451         votingForIndexes[prev][_point] = 0;
1452       }
1453 
1454       if (0x0 != _proxy)
1455       {
1456         uint32[] storage vfor = votingFor[_proxy];
1457         vfor.push(_point);
1458         votingForIndexes[_proxy][_point] = vfor.length;
1459       }
1460 
1461       deed.votingProxy = _proxy;
1462       emit ChangedVotingProxy(_point, _proxy);
1463     }
1464 
1465     //  setManagementProxy(): makes _proxy _point's transfer proxy
1466     //
1467     function setTransferProxy(uint32 _point, address _proxy)
1468       onlyOwner
1469       external
1470     {
1471       Deed storage deed = rights[_point];
1472       address prev = deed.transferProxy;
1473       if (prev == _proxy)
1474       {
1475         return;
1476       }
1477 
1478       //  if the point used to have a different transfer proxy, do some
1479       //  gymnastics to keep the reverse lookup gapless.  delete the point
1480       //  from the old proxy's list, then fill that gap with the list tail.
1481       //
1482       if (0x0 != prev)
1483       {
1484         //  i: current index in previous proxy's list of transferable points
1485         //
1486         uint256 i = transferringForIndexes[prev][_point];
1487 
1488         //  we store index + 1, because 0 is the solidity default value
1489         //
1490         assert(i > 0);
1491         i--;
1492 
1493         //  copy the last item in the list into the now-unused slot,
1494         //  making sure to update its :transferringForIndexes reference
1495         //
1496         uint32[] storage prevTfor = transferringFor[prev];
1497         uint256 last = prevTfor.length - 1;
1498         uint32 moved = prevTfor[last];
1499         prevTfor[i] = moved;
1500         transferringForIndexes[prev][moved] = i + 1;
1501 
1502         //  delete the last item
1503         //
1504         delete(prevTfor[last]);
1505         prevTfor.length = last;
1506         transferringForIndexes[prev][_point] = 0;
1507       }
1508 
1509       if (0x0 != _proxy)
1510       {
1511         uint32[] storage tfor = transferringFor[_proxy];
1512         tfor.push(_point);
1513         transferringForIndexes[_proxy][_point] = tfor.length;
1514       }
1515 
1516       deed.transferProxy = _proxy;
1517       emit ChangedTransferProxy(_point, _proxy);
1518     }
1519 
1520     //  setOperator(): dis/allow _operator to transfer ownership of all points
1521     //                 owned by _owner
1522     //
1523     //    operators are part of the ERC721 standard
1524     //
1525     function setOperator(address _owner, address _operator, bool _approved)
1526       onlyOwner
1527       external
1528     {
1529       operators[_owner][_operator] = _approved;
1530     }
1531 }
1532 
1533 
1534 //  ReadsAzimuth: referring to and testing against the Azimuth
1535 //                data contract
1536 //
1537 //    To avoid needless repetition, this contract provides common
1538 //    checks and operations using the Azimuth contract.
1539 //
1540 contract ReadsAzimuth
1541 {
1542   //  azimuth: points data storage contract.
1543   //
1544   Azimuth public azimuth;
1545 
1546   //  constructor(): set the Azimuth data contract's address
1547   //
1548   constructor(Azimuth _azimuth)
1549     public
1550   {
1551     azimuth = _azimuth;
1552   }
1553 
1554   //  activePointOwner(): require that :msg.sender is the owner of _point,
1555   //                      and that _point is active
1556   //
1557   modifier activePointOwner(uint32 _point)
1558   {
1559     require( azimuth.isOwner(_point, msg.sender) &&
1560              azimuth.isActive(_point) );
1561     _;
1562   }
1563 
1564   //  activePointManager(): require that :msg.sender can manage _point,
1565   //                        and that _point is active
1566   //
1567   modifier activePointManager(uint32 _point)
1568   {
1569     require( azimuth.canManage(_point, msg.sender) &&
1570              azimuth.isActive(_point) );
1571     _;
1572   }
1573 }
1574 //  bare-bones sample planet sale contract
1575 
1576 
1577 
1578 //  the azimuth logic contract
1579 //  https://azimuth.network
1580 
1581 
1582 
1583 //  base contract for the azimuth logic contract
1584 //  encapsulates dependencies all ecliptics need.
1585 
1586 
1587 
1588 
1589 //  the azimuth polls data store
1590 //  https://azimuth.network
1591 
1592 
1593 
1594 
1595 
1596 /**
1597  * @title SafeMath8
1598  * @dev Math operations for uint8 with safety checks that throw on error
1599  */
1600 library SafeMath8 {
1601   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
1602     uint8 c = a * b;
1603     assert(a == 0 || c / a == b);
1604     return c;
1605   }
1606 
1607   function div(uint8 a, uint8 b) internal pure returns (uint8) {
1608     // assert(b > 0); // Solidity automatically throws when dividing by 0
1609     uint8 c = a / b;
1610     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1611     return c;
1612   }
1613 
1614   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
1615     assert(b <= a);
1616     return a - b;
1617   }
1618 
1619   function add(uint8 a, uint8 b) internal pure returns (uint8) {
1620     uint8 c = a + b;
1621     assert(c >= a);
1622     return c;
1623   }
1624 }
1625 
1626 
1627 
1628 /**
1629  * @title SafeMath16
1630  * @dev Math operations for uint16 with safety checks that throw on error
1631  */
1632 library SafeMath16 {
1633   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
1634     uint16 c = a * b;
1635     assert(a == 0 || c / a == b);
1636     return c;
1637   }
1638 
1639   function div(uint16 a, uint16 b) internal pure returns (uint16) {
1640     // assert(b > 0); // Solidity automatically throws when dividing by 0
1641     uint16 c = a / b;
1642     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1643     return c;
1644   }
1645 
1646   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
1647     assert(b <= a);
1648     return a - b;
1649   }
1650 
1651   function add(uint16 a, uint16 b) internal pure returns (uint16) {
1652     uint16 c = a + b;
1653     assert(c >= a);
1654     return c;
1655   }
1656 }
1657 
1658 
1659 
1660 
1661 //  Polls: proposals & votes data contract
1662 //
1663 //    This contract is used for storing all data related to the proposals
1664 //    of the senate (galaxy owners) and their votes on those proposals.
1665 //    It keeps track of votes and uses them to calculate whether a majority
1666 //    is in favor of a proposal.
1667 //
1668 //    Every galaxy can only vote on a proposal exactly once. Votes cannot
1669 //    be changed. If a proposal fails to achieve majority within its
1670 //    duration, it can be restarted after its cooldown period has passed.
1671 //
1672 //    The requirements for a proposal to achieve majority are as follows:
1673 //    - At least 1/4 of the currently active voters (rounded down) must have
1674 //      voted in favor of the proposal,
1675 //    - More than half of the votes cast must be in favor of the proposal,
1676 //      and this can no longer change, either because
1677 //      - the poll duration has passed, or
1678 //      - not enough voters remain to take away the in-favor majority.
1679 //    As soon as these conditions are met, no further interaction with
1680 //    the proposal is possible. Achieving majority is permanent.
1681 //
1682 //    Since data stores are difficult to upgrade, all of the logic unrelated
1683 //    to the voting itself (that is, determining who is eligible to vote)
1684 //    is expected to be implemented by this contract's owner.
1685 //
1686 //    This contract will be owned by the Ecliptic contract.
1687 //
1688 contract Polls is Ownable
1689 {
1690   using SafeMath for uint256;
1691   using SafeMath16 for uint16;
1692   using SafeMath8 for uint8;
1693 
1694   //  UpgradePollStarted: a poll on :proposal has opened
1695   //
1696   event UpgradePollStarted(address proposal);
1697 
1698   //  DocumentPollStarted: a poll on :proposal has opened
1699   //
1700   event DocumentPollStarted(bytes32 proposal);
1701 
1702   //  UpgradeMajority: :proposal has achieved majority
1703   //
1704   event UpgradeMajority(address proposal);
1705 
1706   //  DocumentMajority: :proposal has achieved majority
1707   //
1708   event DocumentMajority(bytes32 proposal);
1709 
1710   //  Poll: full poll state
1711   //
1712   struct Poll
1713   {
1714     //  start: the timestamp at which the poll was started
1715     //
1716     uint256 start;
1717 
1718     //  voted: per galaxy, whether they have voted on this poll
1719     //
1720     bool[256] voted;
1721 
1722     //  yesVotes: amount of votes in favor of the proposal
1723     //
1724     uint16 yesVotes;
1725 
1726     //  noVotes: amount of votes against the proposal
1727     //
1728     uint16 noVotes;
1729 
1730     //  duration: amount of time during which the poll can be voted on
1731     //
1732     uint256 duration;
1733 
1734     //  cooldown: amount of time before the (non-majority) poll can be reopened
1735     //
1736     uint256 cooldown;
1737   }
1738 
1739   //  pollDuration: duration set for new polls. see also Poll.duration above
1740   //
1741   uint256 public pollDuration;
1742 
1743   //  pollCooldown: cooldown set for new polls. see also Poll.cooldown above
1744   //
1745   uint256 public pollCooldown;
1746 
1747   //  totalVoters: amount of active galaxies
1748   //
1749   uint16 public totalVoters;
1750 
1751   //  upgradeProposals: list of all upgrades ever proposed
1752   //
1753   //    this allows clients to discover the existence of polls.
1754   //    from there, they can do liveness checks on the polls themselves.
1755   //
1756   address[] public upgradeProposals;
1757 
1758   //  upgradePolls: per address, poll held to determine if that address
1759   //                will become the new ecliptic
1760   //
1761   mapping(address => Poll) public upgradePolls;
1762 
1763   //  upgradeHasAchievedMajority: per address, whether that address
1764   //                              has ever achieved majority
1765   //
1766   //    If we did not store this, we would have to look at old poll data
1767   //    to see whether or not a proposal has ever achieved majority.
1768   //    Since the outcome of a poll is calculated based on :totalVoters,
1769   //    which may not be consistent across time, we need to store outcomes
1770   //    explicitly instead of re-calculating them. This allows us to always
1771   //    tell with certainty whether or not a majority was achieved,
1772   //    regardless of the current :totalVoters.
1773   //
1774   mapping(address => bool) public upgradeHasAchievedMajority;
1775 
1776   //  documentProposals: list of all documents ever proposed
1777   //
1778   //    this allows clients to discover the existence of polls.
1779   //    from there, they can do liveness checks on the polls themselves.
1780   //
1781   bytes32[] public documentProposals;
1782 
1783   //  documentPolls: per hash, poll held to determine if the corresponding
1784   //                 document is accepted by the galactic senate
1785   //
1786   mapping(bytes32 => Poll) public documentPolls;
1787 
1788   //  documentHasAchievedMajority: per hash, whether that hash has ever
1789   //                               achieved majority
1790   //
1791   //    the note for upgradeHasAchievedMajority above applies here as well
1792   //
1793   mapping(bytes32 => bool) public documentHasAchievedMajority;
1794 
1795   //  documentMajorities: all hashes that have achieved majority
1796   //
1797   bytes32[] public documentMajorities;
1798 
1799   //  constructor(): initial contract configuration
1800   //
1801   constructor(uint256 _pollDuration, uint256 _pollCooldown)
1802     public
1803   {
1804     reconfigure(_pollDuration, _pollCooldown);
1805   }
1806 
1807   //  reconfigure(): change poll duration and cooldown
1808   //
1809   function reconfigure(uint256 _pollDuration, uint256 _pollCooldown)
1810     public
1811     onlyOwner
1812   {
1813     require( (5 days <= _pollDuration) && (_pollDuration <= 90 days) &&
1814              (5 days <= _pollCooldown) && (_pollCooldown <= 90 days) );
1815     pollDuration = _pollDuration;
1816     pollCooldown = _pollCooldown;
1817   }
1818 
1819   //  incrementTotalVoters(): increase the amount of registered voters
1820   //
1821   function incrementTotalVoters()
1822     external
1823     onlyOwner
1824   {
1825     require(totalVoters < 256);
1826     totalVoters = totalVoters.add(1);
1827   }
1828 
1829   //  getAllUpgradeProposals(): return array of all upgrade proposals ever made
1830   //
1831   //    Note: only useful for clients, as Solidity does not currently
1832   //    support returning dynamic arrays.
1833   //
1834   function getUpgradeProposals()
1835     external
1836     view
1837     returns (address[] proposals)
1838   {
1839     return upgradeProposals;
1840   }
1841 
1842   //  getUpgradeProposalCount(): get the number of unique proposed upgrades
1843   //
1844   function getUpgradeProposalCount()
1845     external
1846     view
1847     returns (uint256 count)
1848   {
1849     return upgradeProposals.length;
1850   }
1851 
1852   //  getAllDocumentProposals(): return array of all upgrade proposals ever made
1853   //
1854   //    Note: only useful for clients, as Solidity does not currently
1855   //    support returning dynamic arrays.
1856   //
1857   function getDocumentProposals()
1858     external
1859     view
1860     returns (bytes32[] proposals)
1861   {
1862     return documentProposals;
1863   }
1864 
1865   //  getDocumentProposalCount(): get the number of unique proposed upgrades
1866   //
1867   function getDocumentProposalCount()
1868     external
1869     view
1870     returns (uint256 count)
1871   {
1872     return documentProposals.length;
1873   }
1874 
1875   //  getDocumentMajorities(): return array of all document majorities
1876   //
1877   //    Note: only useful for clients, as Solidity does not currently
1878   //    support returning dynamic arrays.
1879   //
1880   function getDocumentMajorities()
1881     external
1882     view
1883     returns (bytes32[] majorities)
1884   {
1885     return documentMajorities;
1886   }
1887 
1888   //  hasVotedOnUpgradePoll(): returns true if _galaxy has voted
1889   //                           on the _proposal
1890   //
1891   function hasVotedOnUpgradePoll(uint8 _galaxy, address _proposal)
1892     external
1893     view
1894     returns (bool result)
1895   {
1896     return upgradePolls[_proposal].voted[_galaxy];
1897   }
1898 
1899   //  hasVotedOnDocumentPoll(): returns true if _galaxy has voted
1900   //                            on the _proposal
1901   //
1902   function hasVotedOnDocumentPoll(uint8 _galaxy, bytes32 _proposal)
1903     external
1904     view
1905     returns (bool result)
1906   {
1907     return documentPolls[_proposal].voted[_galaxy];
1908   }
1909 
1910   //  startUpgradePoll(): open a poll on making _proposal the new ecliptic
1911   //
1912   function startUpgradePoll(address _proposal)
1913     external
1914     onlyOwner
1915   {
1916     //  _proposal must not have achieved majority before
1917     //
1918     require(!upgradeHasAchievedMajority[_proposal]);
1919 
1920     Poll storage poll = upgradePolls[_proposal];
1921 
1922     //  if the proposal is being made for the first time, register it.
1923     //
1924     if (0 == poll.start)
1925     {
1926       upgradeProposals.push(_proposal);
1927     }
1928 
1929     startPoll(poll);
1930     emit UpgradePollStarted(_proposal);
1931   }
1932 
1933   //  startDocumentPoll(): open a poll on accepting the document
1934   //                       whose hash is _proposal
1935   //
1936   function startDocumentPoll(bytes32 _proposal)
1937     external
1938     onlyOwner
1939   {
1940     //  _proposal must not have achieved majority before
1941     //
1942     require(!documentHasAchievedMajority[_proposal]);
1943 
1944     Poll storage poll = documentPolls[_proposal];
1945 
1946     //  if the proposal is being made for the first time, register it.
1947     //
1948     if (0 == poll.start)
1949     {
1950       documentProposals.push(_proposal);
1951     }
1952 
1953     startPoll(poll);
1954     emit DocumentPollStarted(_proposal);
1955   }
1956 
1957   //  startPoll(): open a new poll, or re-open an old one
1958   //
1959   function startPoll(Poll storage _poll)
1960     internal
1961   {
1962     //  check that the poll has cooled down enough to be started again
1963     //
1964     //    for completely new polls, the values used will be zero
1965     //
1966     require( block.timestamp > ( _poll.start.add(
1967                                  _poll.duration.add(
1968                                  _poll.cooldown )) ) );
1969 
1970     //  set started poll state
1971     //
1972     _poll.start = block.timestamp;
1973     delete _poll.voted;
1974     _poll.yesVotes = 0;
1975     _poll.noVotes = 0;
1976     _poll.duration = pollDuration;
1977     _poll.cooldown = pollCooldown;
1978   }
1979 
1980   //  castUpgradeVote(): as galaxy _as, cast a vote on the _proposal
1981   //
1982   //    _vote is true when in favor of the proposal, false otherwise
1983   //
1984   function castUpgradeVote(uint8 _as, address _proposal, bool _vote)
1985     external
1986     onlyOwner
1987     returns (bool majority)
1988   {
1989     Poll storage poll = upgradePolls[_proposal];
1990     processVote(poll, _as, _vote);
1991     return updateUpgradePoll(_proposal);
1992   }
1993 
1994   //  castDocumentVote(): as galaxy _as, cast a vote on the _proposal
1995   //
1996   //    _vote is true when in favor of the proposal, false otherwise
1997   //
1998   function castDocumentVote(uint8 _as, bytes32 _proposal, bool _vote)
1999     external
2000     onlyOwner
2001     returns (bool majority)
2002   {
2003     Poll storage poll = documentPolls[_proposal];
2004     processVote(poll, _as, _vote);
2005     return updateDocumentPoll(_proposal);
2006   }
2007 
2008   //  processVote(): record a vote from _as on the _poll
2009   //
2010   function processVote(Poll storage _poll, uint8 _as, bool _vote)
2011     internal
2012   {
2013     //  assist symbolic execution tools
2014     //
2015     assert(block.timestamp >= _poll.start);
2016 
2017     require( //  may only vote once
2018              //
2019              !_poll.voted[_as] &&
2020              //
2021              //  may only vote when the poll is open
2022              //
2023              (block.timestamp < _poll.start.add(_poll.duration)) );
2024 
2025     //  update poll state to account for the new vote
2026     //
2027     _poll.voted[_as] = true;
2028     if (_vote)
2029     {
2030       _poll.yesVotes = _poll.yesVotes.add(1);
2031     }
2032     else
2033     {
2034       _poll.noVotes = _poll.noVotes.add(1);
2035     }
2036   }
2037 
2038   //  updateUpgradePoll(): check whether the _proposal has achieved
2039   //                            majority, updating state, sending an event,
2040   //                            and returning true if it has
2041   //
2042   function updateUpgradePoll(address _proposal)
2043     public
2044     onlyOwner
2045     returns (bool majority)
2046   {
2047     //  _proposal must not have achieved majority before
2048     //
2049     require(!upgradeHasAchievedMajority[_proposal]);
2050 
2051     //  check for majority in the poll
2052     //
2053     Poll storage poll = upgradePolls[_proposal];
2054     majority = checkPollMajority(poll);
2055 
2056     //  if majority was achieved, update the state and send an event
2057     //
2058     if (majority)
2059     {
2060       upgradeHasAchievedMajority[_proposal] = true;
2061       emit UpgradeMajority(_proposal);
2062     }
2063     return majority;
2064   }
2065 
2066   //  updateDocumentPoll(): check whether the _proposal has achieved majority,
2067   //                        updating the state and sending an event if it has
2068   //
2069   //    this can be called by anyone, because the ecliptic does not
2070   //    need to be aware of the result
2071   //
2072   function updateDocumentPoll(bytes32 _proposal)
2073     public
2074     returns (bool majority)
2075   {
2076     //  _proposal must not have achieved majority before
2077     //
2078     require(!documentHasAchievedMajority[_proposal]);
2079 
2080     //  check for majority in the poll
2081     //
2082     Poll storage poll = documentPolls[_proposal];
2083     majority = checkPollMajority(poll);
2084 
2085     //  if majority was achieved, update state and send an event
2086     //
2087     if (majority)
2088     {
2089       documentHasAchievedMajority[_proposal] = true;
2090       documentMajorities.push(_proposal);
2091       emit DocumentMajority(_proposal);
2092     }
2093     return majority;
2094   }
2095 
2096   //  checkPollMajority(): returns true if the majority is in favor of
2097   //                       the subject of the poll
2098   //
2099   function checkPollMajority(Poll _poll)
2100     internal
2101     view
2102     returns (bool majority)
2103   {
2104     return ( //  poll must have at least the minimum required yes-votes
2105              //
2106              (_poll.yesVotes >= (totalVoters / 4)) &&
2107              //
2108              //  and have a majority...
2109              //
2110              (_poll.yesVotes > _poll.noVotes) &&
2111              //
2112              //  ...that is indisputable
2113              //
2114              ( //  either because the poll has ended
2115                //
2116                (block.timestamp > _poll.start.add(_poll.duration)) ||
2117                //
2118                //  or there are more yes votes than there can be no votes
2119                //
2120                ( _poll.yesVotes > totalVoters.sub(_poll.yesVotes) ) ) );
2121   }
2122 }
2123 
2124 
2125 
2126 
2127 //  EclipticBase: upgradable ecliptic
2128 //
2129 //    This contract implements the upgrade logic for the Ecliptic.
2130 //    Newer versions of the Ecliptic are expected to provide at least
2131 //    the onUpgrade() function. If they don't, upgrading to them will
2132 //    fail.
2133 //
2134 //    Note that even though this contract doesn't specify any required
2135 //    interface members aside from upgrade() and onUpgrade(), contracts
2136 //    and clients may still rely on the presence of certain functions
2137 //    provided by the Ecliptic proper. Keep this in mind when writing
2138 //    new versions of it.
2139 //
2140 contract EclipticBase is Ownable, ReadsAzimuth
2141 {
2142   //  Upgraded: _to is the new canonical Ecliptic
2143   //
2144   event Upgraded(address to);
2145 
2146   //  polls: senate voting contract
2147   //
2148   Polls public polls;
2149 
2150   //  previousEcliptic: address of the previous ecliptic this
2151   //                    instance expects to upgrade from, stored and
2152   //                    checked for to prevent unexpected upgrade paths
2153   //
2154   address public previousEcliptic;
2155 
2156   constructor( address _previous,
2157                Azimuth _azimuth,
2158                Polls _polls )
2159     ReadsAzimuth(_azimuth)
2160     internal
2161   {
2162     previousEcliptic = _previous;
2163     polls = _polls;
2164   }
2165 
2166   //  onUpgrade(): called by previous ecliptic when upgrading
2167   //
2168   //    in future ecliptics, this might perform more logic than
2169   //    just simple checks and verifications.
2170   //    when overriding this, make sure to call this original as well.
2171   //
2172   function onUpgrade()
2173     external
2174   {
2175     //  make sure this is the expected upgrade path,
2176     //  and that we have gotten the ownership we require
2177     //
2178     require( msg.sender == previousEcliptic &&
2179              this == azimuth.owner() &&
2180              this == polls.owner() );
2181   }
2182 
2183   //  upgrade(): transfer ownership of the ecliptic data to the new
2184   //             ecliptic contract, notify it, then self-destruct.
2185   //
2186   //    Note: any eth that have somehow ended up in this contract
2187   //          are also sent to the new ecliptic.
2188   //
2189   function upgrade(EclipticBase _new)
2190     internal
2191   {
2192     //  transfer ownership of the data contracts
2193     //
2194     azimuth.transferOwnership(_new);
2195     polls.transferOwnership(_new);
2196 
2197     //  trigger upgrade logic on the target contract
2198     //
2199     _new.onUpgrade();
2200 
2201     //  emit event and destroy this contract
2202     //
2203     emit Upgraded(_new);
2204     selfdestruct(_new);
2205   }
2206 }
2207 
2208 //  simple claims store
2209 //  https://azimuth.network
2210 
2211 
2212 
2213 
2214 
2215 //  Claims: simple identity management
2216 //
2217 //    This contract allows points to document claims about their owner.
2218 //    Most commonly, these are about identity, with a claim's protocol
2219 //    defining the context or platform of the claim, and its dossier
2220 //    containing proof of its validity.
2221 //    Points are limited to a maximum of 16 claims.
2222 //
2223 //    For existing claims, the dossier can be updated, or the claim can
2224 //    be removed entirely. It is recommended to remove any claims associated
2225 //    with a point when it is about to be transferred to a new owner.
2226 //    For convenience, the owner of the Azimuth contract (the Ecliptic)
2227 //    is allowed to clear claims for any point, allowing it to do this for
2228 //    you on-transfer.
2229 //
2230 contract Claims is ReadsAzimuth
2231 {
2232   //  ClaimAdded: a claim was added by :by
2233   //
2234   event ClaimAdded( uint32 indexed by,
2235                     string _protocol,
2236                     string _claim,
2237                     bytes _dossier );
2238 
2239   //  ClaimRemoved: a claim was removed by :by
2240   //
2241   event ClaimRemoved(uint32 indexed by, string _protocol, string _claim);
2242 
2243   //  maxClaims: the amount of claims that can be registered per point
2244   //
2245   uint8 constant maxClaims = 16;
2246 
2247   //  Claim: claim details
2248   //
2249   struct Claim
2250   {
2251     //  protocol: context of the claim
2252     //
2253     string protocol;
2254 
2255     //  claim: the claim itself
2256     //
2257     string claim;
2258 
2259     //  dossier: data relating to the claim, as proof
2260     //
2261     bytes dossier;
2262   }
2263 
2264   //  per point, list of claims
2265   //
2266   mapping(uint32 => Claim[maxClaims]) public claims;
2267 
2268   //  constructor(): register the azimuth contract.
2269   //
2270   constructor(Azimuth _azimuth)
2271     ReadsAzimuth(_azimuth)
2272     public
2273   {
2274     //
2275   }
2276 
2277   //  addClaim(): register a claim as _point
2278   //
2279   function addClaim(uint32 _point,
2280                     string _protocol,
2281                     string _claim,
2282                     bytes _dossier)
2283     external
2284     activePointManager(_point)
2285   {
2286     //  cur: index + 1 of the claim if it already exists, 0 otherwise
2287     //
2288     uint8 cur = findClaim(_point, _protocol, _claim);
2289 
2290     //  if the claim doesn't yet exist, store it in state
2291     //
2292     if (cur == 0)
2293     {
2294       //  if there are no empty slots left, this throws
2295       //
2296       uint8 empty = findEmptySlot(_point);
2297       claims[_point][empty] = Claim(_protocol, _claim, _dossier);
2298     }
2299     //
2300     //  if the claim has been made before, update the version in state
2301     //
2302     else
2303     {
2304       claims[_point][cur-1] = Claim(_protocol, _claim, _dossier);
2305     }
2306     emit ClaimAdded(_point, _protocol, _claim, _dossier);
2307   }
2308 
2309   //  removeClaim(): unregister a claim as _point
2310   //
2311   function removeClaim(uint32 _point, string _protocol, string _claim)
2312     external
2313     activePointManager(_point)
2314   {
2315     //  i: current index + 1 in _point's list of claims
2316     //
2317     uint256 i = findClaim(_point, _protocol, _claim);
2318 
2319     //  we store index + 1, because 0 is the eth default value
2320     //  can only delete an existing claim
2321     //
2322     require(i > 0);
2323     i--;
2324 
2325     //  clear out the claim
2326     //
2327     delete claims[_point][i];
2328 
2329     emit ClaimRemoved(_point, _protocol, _claim);
2330   }
2331 
2332   //  clearClaims(): unregister all of _point's claims
2333   //
2334   //    can also be called by the ecliptic during point transfer
2335   //
2336   function clearClaims(uint32 _point)
2337     external
2338   {
2339     //  both point owner and ecliptic may do this
2340     //
2341     //    We do not necessarily need to check for _point's active flag here,
2342     //    since inactive points cannot have claims set. Doing the check
2343     //    anyway would make this function slightly harder to think about due
2344     //    to its relation to Ecliptic's transferPoint().
2345     //
2346     require( azimuth.canManage(_point, msg.sender) ||
2347              ( msg.sender == azimuth.owner() ) );
2348 
2349     Claim[maxClaims] storage currClaims = claims[_point];
2350 
2351     //  clear out all claims
2352     //
2353     for (uint8 i = 0; i < maxClaims; i++)
2354     {
2355       delete currClaims[i];
2356     }
2357   }
2358 
2359   //  findClaim(): find the index of the specified claim
2360   //
2361   //    returns 0 if not found, index + 1 otherwise
2362   //
2363   function findClaim(uint32 _whose, string _protocol, string _claim)
2364     public
2365     view
2366     returns (uint8 index)
2367   {
2368     //  we use hashes of the string because solidity can't do string
2369     //  comparison yet
2370     //
2371     bytes32 protocolHash = keccak256(bytes(_protocol));
2372     bytes32 claimHash = keccak256(bytes(_claim));
2373     Claim[maxClaims] storage theirClaims = claims[_whose];
2374     for (uint8 i = 0; i < maxClaims; i++)
2375     {
2376       Claim storage thisClaim = theirClaims[i];
2377       if ( ( protocolHash == keccak256(bytes(thisClaim.protocol)) ) &&
2378            ( claimHash == keccak256(bytes(thisClaim.claim)) ) )
2379       {
2380         return i+1;
2381       }
2382     }
2383     return 0;
2384   }
2385 
2386   //  findEmptySlot(): find the index of the first empty claim slot
2387   //
2388   //    returns the index of the slot, throws if there are no empty slots
2389   //
2390   function findEmptySlot(uint32 _whose)
2391     internal
2392     view
2393     returns (uint8 index)
2394   {
2395     Claim[maxClaims] storage theirClaims = claims[_whose];
2396     for (uint8 i = 0; i < maxClaims; i++)
2397     {
2398       Claim storage thisClaim = theirClaims[i];
2399       if ( (0 == bytes(thisClaim.protocol).length) &&
2400            (0 == bytes(thisClaim.claim).length) )
2401       {
2402         return i;
2403       }
2404     }
2405     revert();
2406   }
2407 }
2408 
2409 
2410 
2411 
2412 
2413 
2414 
2415 /**
2416  * @title SupportsInterfaceWithLookup
2417  * @author Matt Condon (@shrugs)
2418  * @dev Implements ERC165 using a lookup table.
2419  */
2420 contract SupportsInterfaceWithLookup is ERC165 {
2421 
2422   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
2423   /**
2424    * 0x01ffc9a7 ===
2425    *   bytes4(keccak256('supportsInterface(bytes4)'))
2426    */
2427 
2428   /**
2429    * @dev a mapping of interface id to whether or not it's supported
2430    */
2431   mapping(bytes4 => bool) internal supportedInterfaces;
2432 
2433   /**
2434    * @dev A contract implementing SupportsInterfaceWithLookup
2435    * implement ERC165 itself
2436    */
2437   constructor()
2438     public
2439   {
2440     _registerInterface(InterfaceId_ERC165);
2441   }
2442 
2443   /**
2444    * @dev implement supportsInterface(bytes4) using a lookup table
2445    */
2446   function supportsInterface(bytes4 _interfaceId)
2447     external
2448     view
2449     returns (bool)
2450   {
2451     return supportedInterfaces[_interfaceId];
2452   }
2453 
2454   /**
2455    * @dev private method for registering an interface
2456    */
2457   function _registerInterface(bytes4 _interfaceId)
2458     internal
2459   {
2460     require(_interfaceId != 0xffffffff);
2461     supportedInterfaces[_interfaceId] = true;
2462   }
2463 }
2464 
2465 
2466 
2467 
2468 
2469 
2470 
2471 
2472 /**
2473  * @title ERC721 Non-Fungible Token Standard basic interface
2474  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
2475  */
2476 contract ERC721Basic is ERC165 {
2477 
2478   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
2479   /*
2480    * 0x80ac58cd ===
2481    *   bytes4(keccak256('balanceOf(address)')) ^
2482    *   bytes4(keccak256('ownerOf(uint256)')) ^
2483    *   bytes4(keccak256('approve(address,uint256)')) ^
2484    *   bytes4(keccak256('getApproved(uint256)')) ^
2485    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
2486    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
2487    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
2488    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
2489    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
2490    */
2491 
2492   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
2493   /*
2494    * 0x4f558e79 ===
2495    *   bytes4(keccak256('exists(uint256)'))
2496    */
2497 
2498   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
2499   /**
2500    * 0x780e9d63 ===
2501    *   bytes4(keccak256('totalSupply()')) ^
2502    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
2503    *   bytes4(keccak256('tokenByIndex(uint256)'))
2504    */
2505 
2506   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
2507   /**
2508    * 0x5b5e139f ===
2509    *   bytes4(keccak256('name()')) ^
2510    *   bytes4(keccak256('symbol()')) ^
2511    *   bytes4(keccak256('tokenURI(uint256)'))
2512    */
2513 
2514   event Transfer(
2515     address indexed _from,
2516     address indexed _to,
2517     uint256 indexed _tokenId
2518   );
2519   event Approval(
2520     address indexed _owner,
2521     address indexed _approved,
2522     uint256 indexed _tokenId
2523   );
2524   event ApprovalForAll(
2525     address indexed _owner,
2526     address indexed _operator,
2527     bool _approved
2528   );
2529 
2530   function balanceOf(address _owner) public view returns (uint256 _balance);
2531   function ownerOf(uint256 _tokenId) public view returns (address _owner);
2532   function exists(uint256 _tokenId) public view returns (bool _exists);
2533 
2534   function approve(address _to, uint256 _tokenId) public;
2535   function getApproved(uint256 _tokenId)
2536     public view returns (address _operator);
2537 
2538   function setApprovalForAll(address _operator, bool _approved) public;
2539   function isApprovedForAll(address _owner, address _operator)
2540     public view returns (bool);
2541 
2542   function transferFrom(address _from, address _to, uint256 _tokenId) public;
2543   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
2544     public;
2545 
2546   function safeTransferFrom(
2547     address _from,
2548     address _to,
2549     uint256 _tokenId,
2550     bytes _data
2551   )
2552     public;
2553 }
2554 
2555 
2556 
2557 /**
2558  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2559  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
2560  */
2561 contract ERC721Enumerable is ERC721Basic {
2562   function totalSupply() public view returns (uint256);
2563   function tokenOfOwnerByIndex(
2564     address _owner,
2565     uint256 _index
2566   )
2567     public
2568     view
2569     returns (uint256 _tokenId);
2570 
2571   function tokenByIndex(uint256 _index) public view returns (uint256);
2572 }
2573 
2574 
2575 /**
2576  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2577  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
2578  */
2579 contract ERC721Metadata is ERC721Basic {
2580   function name() external view returns (string _name);
2581   function symbol() external view returns (string _symbol);
2582   function tokenURI(uint256 _tokenId) public view returns (string);
2583 }
2584 
2585 
2586 /**
2587  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
2588  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
2589  */
2590 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
2591 }
2592 
2593 
2594 
2595 
2596 /**
2597  * @title ERC721 token receiver interface
2598  * @dev Interface for any contract that wants to support safeTransfers
2599  * from ERC721 asset contracts.
2600  */
2601 contract ERC721Receiver {
2602   /**
2603    * @dev Magic value to be returned upon successful reception of an NFT
2604    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
2605    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
2606    */
2607   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
2608 
2609   /**
2610    * @notice Handle the receipt of an NFT
2611    * @dev The ERC721 smart contract calls this function on the recipient
2612    * after a `safetransfer`. This function MAY throw to revert and reject the
2613    * transfer. Return of other than the magic value MUST result in the
2614    * transaction being reverted.
2615    * Note: the contract address is always the message sender.
2616    * @param _operator The address which called `safeTransferFrom` function
2617    * @param _from The address which previously owned the token
2618    * @param _tokenId The NFT identifier which is being transferred
2619    * @param _data Additional data with no specified format
2620    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
2621    */
2622   function onERC721Received(
2623     address _operator,
2624     address _from,
2625     uint256 _tokenId,
2626     bytes _data
2627   )
2628     public
2629     returns(bytes4);
2630 }
2631 
2632 
2633 
2634 
2635 /**
2636  * Utility library of inline functions on addresses
2637  */
2638 library AddressUtils {
2639 
2640   /**
2641    * Returns whether the target address is a contract
2642    * @dev This function will return false if invoked during the constructor of a contract,
2643    * as the code is not actually created until after the constructor finishes.
2644    * @param _addr address to check
2645    * @return whether the target address is a contract
2646    */
2647   function isContract(address _addr) internal view returns (bool) {
2648     uint256 size;
2649     // XXX Currently there is no better way to check if there is a contract in an address
2650     // than to check the size of the code at that address.
2651     // See https://ethereum.stackexchange.com/a/14016/36603
2652     // for more details about how this works.
2653     // TODO Check this again before the Serenity release, because all addresses will be
2654     // contracts then.
2655     // solium-disable-next-line security/no-inline-assembly
2656     assembly { size := extcodesize(_addr) }
2657     return size > 0;
2658   }
2659 
2660 }
2661 
2662 
2663 
2664 
2665 /**
2666  * @title SafeMath
2667  * @dev Math operations with safety checks that throw on error
2668  */
2669 library SafeMath {
2670 
2671   /**
2672   * @dev Multiplies two numbers, throws on overflow.
2673   */
2674   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
2675     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
2676     // benefit is lost if 'b' is also tested.
2677     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2678     if (_a == 0) {
2679       return 0;
2680     }
2681 
2682     c = _a * _b;
2683     assert(c / _a == _b);
2684     return c;
2685   }
2686 
2687   /**
2688   * @dev Integer division of two numbers, truncating the quotient.
2689   */
2690   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
2691     // assert(_b > 0); // Solidity automatically throws when dividing by 0
2692     // uint256 c = _a / _b;
2693     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
2694     return _a / _b;
2695   }
2696 
2697   /**
2698   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2699   */
2700   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
2701     assert(_b <= _a);
2702     return _a - _b;
2703   }
2704 
2705   /**
2706   * @dev Adds two numbers, throws on overflow.
2707   */
2708   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
2709     c = _a + _b;
2710     assert(c >= _a);
2711     return c;
2712   }
2713 }
2714 
2715 
2716 //  Ecliptic: logic for interacting with the Azimuth ledger
2717 //
2718 //    This contract is the point of entry for all operations on the Azimuth
2719 //    ledger as stored in the Azimuth data contract. The functions herein
2720 //    are responsible for performing all necessary business logic.
2721 //    Examples of such logic include verifying permissions of the caller
2722 //    and ensuring a requested change is actually valid.
2723 //    Point owners can always operate on their own points. Ethereum addresses
2724 //    can also perform specific operations if they've been given the
2725 //    appropriate permissions. (For example, managers for general management,
2726 //    spawn proxies for spawning child points, etc.)
2727 //
2728 //    This contract uses external contracts (Azimuth, Polls) for data storage
2729 //    so that it itself can easily be replaced in case its logic needs to
2730 //    be changed. In other words, it can be upgraded. It does this by passing
2731 //    ownership of the data contracts to a new Ecliptic contract.
2732 //
2733 //    Because of this, it is advised for clients to not store this contract's
2734 //    address directly, but rather ask the Azimuth contract for its owner
2735 //    attribute to ensure transactions get sent to the latest Ecliptic.
2736 //    Alternatively, the ENS name ecliptic.eth will resolve to the latest
2737 //    Ecliptic as well.
2738 //
2739 //    Upgrading happens based on polls held by the senate (galaxy owners).
2740 //    Through this contract, the senate can submit proposals, opening polls
2741 //    for the senate to cast votes on. These proposals can be either hashes
2742 //    of documents or addresses of new Ecliptics.
2743 //    If an ecliptic proposal gains majority, this contract will transfer
2744 //    ownership of the data storage contracts to that address, so that it may
2745 //    operate on the data they contain. This contract will selfdestruct at
2746 //    the end of the upgrade process.
2747 //
2748 //    This contract implements the ERC721 interface for non-fungible tokens,
2749 //    allowing points to be managed using generic clients that support the
2750 //    standard. It also implements ERC165 to allow this to be discovered.
2751 //
2752 contract Ecliptic is EclipticBase, SupportsInterfaceWithLookup, ERC721Metadata
2753 {
2754   using SafeMath for uint256;
2755   using AddressUtils for address;
2756 
2757   //  Transfer: This emits when ownership of any NFT changes by any mechanism.
2758   //            This event emits when NFTs are created (`from` == 0) and
2759   //            destroyed (`to` == 0). At the time of any transfer, the
2760   //            approved address for that NFT (if any) is reset to none.
2761   //
2762   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
2763 
2764   //  Approval: This emits when the approved address for an NFT is changed or
2765   //            reaffirmed. The zero address indicates there is no approved
2766   //            address. When a Transfer event emits, this also indicates that
2767   //            the approved address for that NFT (if any) is reset to none.
2768   //
2769   event Approval(address indexed _owner, address indexed _approved,
2770                  uint256 _tokenId);
2771 
2772   //  ApprovalForAll: This emits when an operator is enabled or disabled for an
2773   //                  owner. The operator can manage all NFTs of the owner.
2774   //
2775   event ApprovalForAll(address indexed _owner, address indexed _operator,
2776                        bool _approved);
2777 
2778   // erc721Received: equal to:
2779   //        bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
2780   //                 which can be also obtained as:
2781   //        ERC721Receiver(0).onERC721Received.selector`
2782   bytes4 constant erc721Received = 0x150b7a02;
2783 
2784   //  claims: contract reference, for clearing claims on-transfer
2785   //
2786   Claims public claims;
2787 
2788   //  constructor(): set data contract addresses and signal interface support
2789   //
2790   //    Note: during first deploy, ownership of these data contracts must
2791   //    be manually transferred to this contract.
2792   //
2793   constructor(address _previous,
2794               Azimuth _azimuth,
2795               Polls _polls,
2796               Claims _claims)
2797     EclipticBase(_previous, _azimuth, _polls)
2798     public
2799   {
2800     claims = _claims;
2801 
2802     //  register supported interfaces for ERC165
2803     //
2804     _registerInterface(0x80ac58cd); // ERC721
2805     _registerInterface(0x5b5e139f); // ERC721Metadata
2806     _registerInterface(0x7f5828d0); // ERC173 (ownership)
2807   }
2808 
2809   //
2810   //  ERC721 interface
2811   //
2812 
2813     //  balanceOf(): get the amount of points owned by _owner
2814     //
2815     function balanceOf(address _owner)
2816       public
2817       view
2818       returns (uint256 balance)
2819     {
2820       require(0x0 != _owner);
2821       return azimuth.getOwnedPointCount(_owner);
2822     }
2823 
2824     //  ownerOf(): get the current owner of point _tokenId
2825     //
2826     function ownerOf(uint256 _tokenId)
2827       public
2828       view
2829       validPointId(_tokenId)
2830       returns (address owner)
2831     {
2832       uint32 id = uint32(_tokenId);
2833 
2834       //  this will throw if the owner is the zero address,
2835       //  active points always have a valid owner.
2836       //
2837       require(azimuth.isActive(id));
2838 
2839       return azimuth.getOwner(id);
2840     }
2841 
2842     //  exists(): returns true if point _tokenId is active
2843     //
2844     function exists(uint256 _tokenId)
2845       public
2846       view
2847       returns (bool doesExist)
2848     {
2849       return ( (_tokenId < 0x100000000) &&
2850                azimuth.isActive(uint32(_tokenId)) );
2851     }
2852 
2853     //  safeTransferFrom(): transfer point _tokenId from _from to _to
2854     //
2855     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
2856       public
2857     {
2858       //  transfer with empty data
2859       //
2860       safeTransferFrom(_from, _to, _tokenId, "");
2861     }
2862 
2863     //  safeTransferFrom(): transfer point _tokenId from _from to _to,
2864     //                      and call recipient if it's a contract
2865     //
2866     function safeTransferFrom(address _from, address _to, uint256 _tokenId,
2867                               bytes _data)
2868       public
2869     {
2870       //  perform raw transfer
2871       //
2872       transferFrom(_from, _to, _tokenId);
2873 
2874       //  do the callback last to avoid re-entrancy
2875       //
2876       if (_to.isContract())
2877       {
2878         bytes4 retval = ERC721Receiver(_to)
2879                         .onERC721Received(msg.sender, _from, _tokenId, _data);
2880         //
2881         //  standard return idiom to confirm contract semantics
2882         //
2883         require(retval == erc721Received);
2884       }
2885     }
2886 
2887     //  transferFrom(): transfer point _tokenId from _from to _to,
2888     //                  WITHOUT notifying recipient contract
2889     //
2890     function transferFrom(address _from, address _to, uint256 _tokenId)
2891       public
2892       validPointId(_tokenId)
2893     {
2894       uint32 id = uint32(_tokenId);
2895       require(azimuth.isOwner(id, _from));
2896 
2897       //  the ERC721 operator/approved address (if any) is
2898       //  accounted for in transferPoint()
2899       //
2900       transferPoint(id, _to, true);
2901     }
2902 
2903     //  approve(): allow _approved to transfer ownership of point
2904     //             _tokenId
2905     //
2906     function approve(address _approved, uint256 _tokenId)
2907       public
2908       validPointId(_tokenId)
2909     {
2910       setTransferProxy(uint32(_tokenId), _approved);
2911     }
2912 
2913     //  setApprovalForAll(): allow or disallow _operator to
2914     //                       transfer ownership of ALL points
2915     //                       owned by :msg.sender
2916     //
2917     function setApprovalForAll(address _operator, bool _approved)
2918       public
2919     {
2920       require(0x0 != _operator);
2921       azimuth.setOperator(msg.sender, _operator, _approved);
2922       emit ApprovalForAll(msg.sender, _operator, _approved);
2923     }
2924 
2925     //  getApproved(): get the approved address for point _tokenId
2926     //
2927     function getApproved(uint256 _tokenId)
2928       public
2929       view
2930       validPointId(_tokenId)
2931       returns (address approved)
2932     {
2933       //NOTE  redundant, transfer proxy cannot be set for
2934       //      inactive points
2935       //
2936       require(azimuth.isActive(uint32(_tokenId)));
2937       return azimuth.getTransferProxy(uint32(_tokenId));
2938     }
2939 
2940     //  isApprovedForAll(): returns true if _operator is an
2941     //                      operator for _owner
2942     //
2943     function isApprovedForAll(address _owner, address _operator)
2944       public
2945       view
2946       returns (bool result)
2947     {
2948       return azimuth.isOperator(_owner, _operator);
2949     }
2950 
2951   //
2952   //  ERC721Metadata interface
2953   //
2954 
2955     //  name(): returns the name of a collection of points
2956     //
2957     function name()
2958       external
2959       view
2960       returns (string)
2961     {
2962       return "Azimuth Points";
2963     }
2964 
2965     //  symbol(): returns an abbreviates name for points
2966     //
2967     function symbol()
2968       external
2969       view
2970       returns (string)
2971     {
2972       return "AZP";
2973     }
2974 
2975     //  tokenURI(): returns a URL to an ERC-721 standard JSON file
2976     //
2977     function tokenURI(uint256 _tokenId)
2978       public
2979       view
2980       validPointId(_tokenId)
2981       returns (string _tokenURI)
2982     {
2983       _tokenURI = "https://azimuth.network/erc721/0000000000.json";
2984       bytes memory _tokenURIBytes = bytes(_tokenURI);
2985       _tokenURIBytes[31] = byte(48+(_tokenId / 1000000000) % 10);
2986       _tokenURIBytes[32] = byte(48+(_tokenId / 100000000) % 10);
2987       _tokenURIBytes[33] = byte(48+(_tokenId / 10000000) % 10);
2988       _tokenURIBytes[34] = byte(48+(_tokenId / 1000000) % 10);
2989       _tokenURIBytes[35] = byte(48+(_tokenId / 100000) % 10);
2990       _tokenURIBytes[36] = byte(48+(_tokenId / 10000) % 10);
2991       _tokenURIBytes[37] = byte(48+(_tokenId / 1000) % 10);
2992       _tokenURIBytes[38] = byte(48+(_tokenId / 100) % 10);
2993       _tokenURIBytes[39] = byte(48+(_tokenId / 10) % 10);
2994       _tokenURIBytes[40] = byte(48+(_tokenId / 1) % 10);
2995     }
2996 
2997   //
2998   //  Points interface
2999   //
3000 
3001     //  configureKeys(): configure _point with network public keys
3002     //                   _encryptionKey, _authenticationKey,
3003     //                   and corresponding _cryptoSuiteVersion,
3004     //                   incrementing the point's continuity number if needed
3005     //
3006     function configureKeys(uint32 _point,
3007                            bytes32 _encryptionKey,
3008                            bytes32 _authenticationKey,
3009                            uint32 _cryptoSuiteVersion,
3010                            bool _discontinuous)
3011       external
3012       activePointManager(_point)
3013     {
3014       if (_discontinuous)
3015       {
3016         azimuth.incrementContinuityNumber(_point);
3017       }
3018       azimuth.setKeys(_point,
3019                       _encryptionKey,
3020                       _authenticationKey,
3021                       _cryptoSuiteVersion);
3022     }
3023 
3024     //  spawn(): spawn _point, then either give, or allow _target to take,
3025     //           ownership of _point
3026     //
3027     //    if _target is the :msg.sender, _targets owns the _point right away.
3028     //    otherwise, _target becomes the transfer proxy of _point.
3029     //
3030     //    Requirements:
3031     //    - _point must not be active
3032     //    - _point must not be a planet with a galaxy prefix
3033     //    - _point's prefix must be linked and under its spawn limit
3034     //    - :msg.sender must be either the owner of _point's prefix,
3035     //      or an authorized spawn proxy for it
3036     //
3037     function spawn(uint32 _point, address _target)
3038       external
3039     {
3040       //  only currently unowned (and thus also inactive) points can be spawned
3041       //
3042       require(azimuth.isOwner(_point, 0x0));
3043 
3044       //  prefix: half-width prefix of _point
3045       //
3046       uint16 prefix = azimuth.getPrefix(_point);
3047 
3048       //  only allow spawning of points of the size directly below the prefix
3049       //
3050       //    this is possible because of how the address space works,
3051       //    but supporting it introduces complexity through broken assumptions.
3052       //
3053       //    example:
3054       //    0x0000.0000 - galaxy zero
3055       //    0x0000.0100 - the first star of galaxy zero
3056       //    0x0001.0100 - the first planet of the first star
3057       //    0x0001.0000 - the first planet of galaxy zero
3058       //
3059       require( (uint8(azimuth.getPointSize(prefix)) + 1) ==
3060                uint8(azimuth.getPointSize(_point)) );
3061 
3062       //  prefix point must be linked and able to spawn
3063       //
3064       require( (azimuth.hasBeenLinked(prefix)) &&
3065                ( azimuth.getSpawnCount(prefix) <
3066                  getSpawnLimit(prefix, block.timestamp) ) );
3067 
3068       //  the owner of a prefix can always spawn its children;
3069       //  other addresses need explicit permission (the role
3070       //  of "spawnProxy" in the Azimuth contract)
3071       //
3072       require( azimuth.canSpawnAs(prefix, msg.sender) );
3073 
3074       //  if the caller is spawning the point to themselves,
3075       //  assume it knows what it's doing and resolve right away
3076       //
3077       if (msg.sender == _target)
3078       {
3079         doSpawn(_point, _target, true, 0x0);
3080       }
3081       //
3082       //  when sending to a "foreign" address, enforce a withdraw pattern
3083       //  making the _point prefix's owner the _point owner in the mean time
3084       //
3085       else
3086       {
3087         doSpawn(_point, _target, false, azimuth.getOwner(prefix));
3088       }
3089     }
3090 
3091     //  doSpawn(): actual spawning logic, used in spawn(). creates _point,
3092     //             making the _target its owner if _direct, or making the
3093     //             _holder the owner and the _target the transfer proxy
3094     //             if not _direct.
3095     //
3096     function doSpawn( uint32 _point,
3097                       address _target,
3098                       bool _direct,
3099                       address _holder )
3100       internal
3101     {
3102       //  register the spawn for _point's prefix, incrementing spawn count
3103       //
3104       azimuth.registerSpawned(_point);
3105 
3106       //  if the spawn is _direct, assume _target knows what they're doing
3107       //  and resolve right away
3108       //
3109       if (_direct)
3110       {
3111         //  make the point active and set its new owner
3112         //
3113         azimuth.activatePoint(_point);
3114         azimuth.setOwner(_point, _target);
3115 
3116         emit Transfer(0x0, _target, uint256(_point));
3117       }
3118       //
3119       //  when spawning indirectly, enforce a withdraw pattern by approving
3120       //  the _target for transfer of the _point instead.
3121       //  we make the _holder the owner of this _point in the mean time,
3122       //  so that it may cancel the transfer (un-approve) if _target flakes.
3123       //  we don't make _point active yet, because it still doesn't really
3124       //  belong to anyone.
3125       //
3126       else
3127       {
3128         //  have _holder hold on to the _point while _target gets to transfer
3129         //  ownership of it
3130         //
3131         azimuth.setOwner(_point, _holder);
3132         azimuth.setTransferProxy(_point, _target);
3133 
3134         emit Transfer(0x0, _holder, uint256(_point));
3135         emit Approval(_holder, _target, uint256(_point));
3136       }
3137     }
3138 
3139     //  transferPoint(): transfer _point to _target, clearing all permissions
3140     //                   data and keys if _reset is true
3141     //
3142     //    Note: the _reset flag is useful when transferring the point to
3143     //    a recipient who doesn't trust the previous owner.
3144     //
3145     //    Requirements:
3146     //    - :msg.sender must be either _point's current owner, authorized
3147     //      to transfer _point, or authorized to transfer the current
3148     //      owner's points (as in ERC721's operator)
3149     //    - _target must not be the zero address
3150     //
3151     function transferPoint(uint32 _point, address _target, bool _reset)
3152       public
3153     {
3154       //  transfer is legitimate if the caller is the current owner, or
3155       //  an operator for the current owner, or the _point's transfer proxy
3156       //
3157       require(azimuth.canTransfer(_point, msg.sender));
3158 
3159       //  if the point wasn't active yet, that means transferring it
3160       //  is part of the "spawn" flow, so we need to activate it
3161       //
3162       if ( !azimuth.isActive(_point) )
3163       {
3164         azimuth.activatePoint(_point);
3165       }
3166 
3167       //  if the owner would actually change, change it
3168       //
3169       //    the only time this deliberately wouldn't be the case is when a
3170       //    prefix owner wants to activate a spawned but untransferred child.
3171       //
3172       if ( !azimuth.isOwner(_point, _target) )
3173       {
3174         //  remember the previous owner, to be included in the Transfer event
3175         //
3176         address old = azimuth.getOwner(_point);
3177 
3178         azimuth.setOwner(_point, _target);
3179 
3180         //  according to ERC721, the approved address (here, transfer proxy)
3181         //  gets cleared during every Transfer event
3182         //
3183         azimuth.setTransferProxy(_point, 0);
3184 
3185         emit Transfer(old, _target, uint256(_point));
3186       }
3187 
3188       //  reset sensitive data
3189       //  used when transferring the point to a new owner
3190       //
3191       if ( _reset )
3192       {
3193         //  clear the network public keys and break continuity,
3194         //  but only if the point has already been linked
3195         //
3196         if ( azimuth.hasBeenLinked(_point) )
3197         {
3198           azimuth.incrementContinuityNumber(_point);
3199           azimuth.setKeys(_point, 0, 0, 0);
3200         }
3201 
3202         //  clear management proxy
3203         //
3204         azimuth.setManagementProxy(_point, 0);
3205 
3206         //  clear voting proxy
3207         //
3208         azimuth.setVotingProxy(_point, 0);
3209 
3210         //  clear transfer proxy
3211         //
3212         //    in most cases this is done above, during the ownership transfer,
3213         //    but we might not hit that and still be expected to reset the
3214         //    transfer proxy.
3215         //    doing it a second time is a no-op in Azimuth.
3216         //
3217         azimuth.setTransferProxy(_point, 0);
3218 
3219         //  clear spawning proxy
3220         //
3221         azimuth.setSpawnProxy(_point, 0);
3222 
3223         //  clear claims
3224         //
3225         claims.clearClaims(_point);
3226       }
3227     }
3228 
3229     //  escape(): request escape as _point to _sponsor
3230     //
3231     //    if an escape request is already active, this overwrites
3232     //    the existing request
3233     //
3234     //    Requirements:
3235     //    - :msg.sender must be the owner or manager of _point,
3236     //    - _point must be able to escape to _sponsor as per to canEscapeTo()
3237     //
3238     function escape(uint32 _point, uint32 _sponsor)
3239       external
3240       activePointManager(_point)
3241     {
3242       require(canEscapeTo(_point, _sponsor));
3243       azimuth.setEscapeRequest(_point, _sponsor);
3244     }
3245 
3246     //  cancelEscape(): cancel the currently set escape for _point
3247     //
3248     function cancelEscape(uint32 _point)
3249       external
3250       activePointManager(_point)
3251     {
3252       azimuth.cancelEscape(_point);
3253     }
3254 
3255     //  adopt(): as the relevant sponsor, accept the _point
3256     //
3257     //    Requirements:
3258     //    - :msg.sender must be the owner or management proxy
3259     //      of _point's requested sponsor
3260     //
3261     function adopt(uint32 _point)
3262       external
3263     {
3264       require( azimuth.isEscaping(_point) &&
3265                azimuth.canManage( azimuth.getEscapeRequest(_point),
3266                                   msg.sender ) );
3267 
3268       //  _sponsor becomes _point's sponsor
3269       //  its escape request is reset to "not escaping"
3270       //
3271       azimuth.doEscape(_point);
3272     }
3273 
3274     //  reject(): as the relevant sponsor, deny the _point's request
3275     //
3276     //    Requirements:
3277     //    - :msg.sender must be the owner or management proxy
3278     //      of _point's requested sponsor
3279     //
3280     function reject(uint32 _point)
3281       external
3282     {
3283       require( azimuth.isEscaping(_point) &&
3284                azimuth.canManage( azimuth.getEscapeRequest(_point),
3285                                   msg.sender ) );
3286 
3287       //  reset the _point's escape request to "not escaping"
3288       //
3289       azimuth.cancelEscape(_point);
3290     }
3291 
3292     //  detach(): as the _sponsor, stop sponsoring the _point
3293     //
3294     //    Requirements:
3295     //    - :msg.sender must be the owner or management proxy
3296     //      of _point's current sponsor
3297     //
3298     function detach(uint32 _point)
3299       external
3300     {
3301       require( azimuth.hasSponsor(_point) &&
3302                azimuth.canManage(azimuth.getSponsor(_point), msg.sender) );
3303 
3304       //  signal that its sponsor no longer supports _point
3305       //
3306       azimuth.loseSponsor(_point);
3307     }
3308 
3309   //
3310   //  Point rules
3311   //
3312 
3313     //  getSpawnLimit(): returns the total number of children the _point
3314     //                   is allowed to spawn at _time.
3315     //
3316     function getSpawnLimit(uint32 _point, uint256 _time)
3317       public
3318       view
3319       returns (uint32 limit)
3320     {
3321       Azimuth.Size size = azimuth.getPointSize(_point);
3322 
3323       if ( size == Azimuth.Size.Galaxy )
3324       {
3325         return 255;
3326       }
3327       else if ( size == Azimuth.Size.Star )
3328       {
3329         //  in 2019, stars may spawn at most 1024 planets. this limit doubles
3330         //  for every subsequent year.
3331         //
3332         //    Note: 1546300800 corresponds to 2019-01-01
3333         //
3334         uint256 yearsSince2019 = (_time - 1546300800) / 365 days;
3335         if (yearsSince2019 < 6)
3336         {
3337           limit = uint32( 1024 * (2 ** yearsSince2019) );
3338         }
3339         else
3340         {
3341           limit = 65535;
3342         }
3343         return limit;
3344       }
3345       else  //  size == Azimuth.Size.Planet
3346       {
3347         //  planets can create moons, but moons aren't on the chain
3348         //
3349         return 0;
3350       }
3351     }
3352 
3353     //  canEscapeTo(): true if _point could try to escape to _sponsor
3354     //
3355     function canEscapeTo(uint32 _point, uint32 _sponsor)
3356       public
3357       view
3358       returns (bool canEscape)
3359     {
3360       //  can't escape to a sponsor that hasn't been linked
3361       //
3362       if ( !azimuth.hasBeenLinked(_sponsor) ) return false;
3363 
3364       //  Can only escape to a point one size higher than ourselves,
3365       //  except in the special case where the escaping point hasn't
3366       //  been linked yet -- in that case we may escape to points of
3367       //  the same size, to support lightweight invitation chains.
3368       //
3369       //  The use case for lightweight invitations is that a planet
3370       //  owner should be able to invite their friends onto an
3371       //  Azimuth network in a two-party transaction, without a new
3372       //  star relationship.
3373       //  The lightweight invitation process works by escaping your
3374       //  own active (but never linked) point to one of your own
3375       //  points, then transferring the point to your friend.
3376       //
3377       //  These planets can, in turn, sponsor other unlinked planets,
3378       //  so the "planet sponsorship chain" can grow to arbitrary
3379       //  length. Most users, especially deep down the chain, will
3380       //  want to improve their performance by switching to direct
3381       //  star sponsors eventually.
3382       //
3383       Azimuth.Size pointSize = azimuth.getPointSize(_point);
3384       Azimuth.Size sponsorSize = azimuth.getPointSize(_sponsor);
3385       return ( //  normal hierarchical escape structure
3386                //
3387                ( (uint8(sponsorSize) + 1) == uint8(pointSize) ) ||
3388                //
3389                //  special peer escape
3390                //
3391                ( (sponsorSize == pointSize) &&
3392                  //
3393                  //  peer escape is only for points that haven't been linked
3394                  //  yet, because it's only for lightweight invitation chains
3395                  //
3396                  !azimuth.hasBeenLinked(_point) ) );
3397     }
3398 
3399   //
3400   //  Permission management
3401   //
3402 
3403     //  setManagementProxy(): configure the management proxy for _point
3404     //
3405     //    The management proxy may perform "reversible" operations on
3406     //    behalf of the owner. This includes public key configuration and
3407     //    operations relating to sponsorship.
3408     //
3409     function setManagementProxy(uint32 _point, address _manager)
3410       external
3411       activePointOwner(_point)
3412     {
3413       azimuth.setManagementProxy(_point, _manager);
3414     }
3415 
3416     //  setSpawnProxy(): give _spawnProxy the right to spawn points
3417     //                   with the prefix _prefix
3418     //
3419     function setSpawnProxy(uint16 _prefix, address _spawnProxy)
3420       external
3421       activePointOwner(_prefix)
3422     {
3423       azimuth.setSpawnProxy(_prefix, _spawnProxy);
3424     }
3425 
3426     //  setVotingProxy(): configure the voting proxy for _galaxy
3427     //
3428     //    the voting proxy is allowed to start polls and cast votes
3429     //    on the point's behalf.
3430     //
3431     function setVotingProxy(uint8 _galaxy, address _voter)
3432       external
3433       activePointOwner(_galaxy)
3434     {
3435       azimuth.setVotingProxy(_galaxy, _voter);
3436     }
3437 
3438     //  setTransferProxy(): give _transferProxy the right to transfer _point
3439     //
3440     //    Requirements:
3441     //    - :msg.sender must be either _point's current owner,
3442     //      or be an operator for the current owner
3443     //
3444     function setTransferProxy(uint32 _point, address _transferProxy)
3445       public
3446     {
3447       //  owner: owner of _point
3448       //
3449       address owner = azimuth.getOwner(_point);
3450 
3451       //  caller must be :owner, or an operator designated by the owner.
3452       //
3453       require((owner == msg.sender) || azimuth.isOperator(owner, msg.sender));
3454 
3455       //  set transfer proxy field in Azimuth contract
3456       //
3457       azimuth.setTransferProxy(_point, _transferProxy);
3458 
3459       //  emit Approval event
3460       //
3461       emit Approval(owner, _transferProxy, uint256(_point));
3462     }
3463 
3464   //
3465   //  Poll actions
3466   //
3467 
3468     //  startUpgradePoll(): as _galaxy, start a poll for the ecliptic
3469     //                      upgrade _proposal
3470     //
3471     //    Requirements:
3472     //    - :msg.sender must be the owner or voting proxy of _galaxy,
3473     //    - the _proposal must expect to be upgraded from this specific
3474     //      contract, as indicated by its previousEcliptic attribute
3475     //
3476     function startUpgradePoll(uint8 _galaxy, EclipticBase _proposal)
3477       external
3478       activePointVoter(_galaxy)
3479     {
3480       //  ensure that the upgrade target expects this contract as the source
3481       //
3482       require(_proposal.previousEcliptic() == address(this));
3483       polls.startUpgradePoll(_proposal);
3484     }
3485 
3486     //  startDocumentPoll(): as _galaxy, start a poll for the _proposal
3487     //
3488     //    the _proposal argument is the keccak-256 hash of any arbitrary
3489     //    document or string of text
3490     //
3491     function startDocumentPoll(uint8 _galaxy, bytes32 _proposal)
3492       external
3493       activePointVoter(_galaxy)
3494     {
3495       polls.startDocumentPoll(_proposal);
3496     }
3497 
3498     //  castUpgradeVote(): as _galaxy, cast a _vote on the ecliptic
3499     //                     upgrade _proposal
3500     //
3501     //    _vote is true when in favor of the proposal, false otherwise
3502     //
3503     //    If this vote results in a majority for the _proposal, it will
3504     //    be upgraded to immediately.
3505     //
3506     function castUpgradeVote(uint8 _galaxy,
3507                               EclipticBase _proposal,
3508                               bool _vote)
3509       external
3510       activePointVoter(_galaxy)
3511     {
3512       //  majority: true if the vote resulted in a majority, false otherwise
3513       //
3514       bool majority = polls.castUpgradeVote(_galaxy, _proposal, _vote);
3515 
3516       //  if a majority is in favor of the upgrade, it happens as defined
3517       //  in the ecliptic base contract
3518       //
3519       if (majority)
3520       {
3521         upgrade(_proposal);
3522       }
3523     }
3524 
3525     //  castDocumentVote(): as _galaxy, cast a _vote on the _proposal
3526     //
3527     //    _vote is true when in favor of the proposal, false otherwise
3528     //
3529     function castDocumentVote(uint8 _galaxy, bytes32 _proposal, bool _vote)
3530       external
3531       activePointVoter(_galaxy)
3532     {
3533       polls.castDocumentVote(_galaxy, _proposal, _vote);
3534     }
3535 
3536     //  updateUpgradePoll(): check whether the _proposal has achieved
3537     //                      majority, upgrading to it if it has
3538     //
3539     function updateUpgradePoll(EclipticBase _proposal)
3540       external
3541     {
3542       //  majority: true if the poll ended in a majority, false otherwise
3543       //
3544       bool majority = polls.updateUpgradePoll(_proposal);
3545 
3546       //  if a majority is in favor of the upgrade, it happens as defined
3547       //  in the ecliptic base contract
3548       //
3549       if (majority)
3550       {
3551         upgrade(_proposal);
3552       }
3553     }
3554 
3555     //  updateDocumentPoll(): check whether the _proposal has achieved majority
3556     //
3557     //    Note: the polls contract publicly exposes the function this calls,
3558     //    but we offer it in the ecliptic interface as a convenience
3559     //
3560     function updateDocumentPoll(bytes32 _proposal)
3561       external
3562     {
3563       polls.updateDocumentPoll(_proposal);
3564     }
3565 
3566   //
3567   //  Contract owner operations
3568   //
3569 
3570     //  createGalaxy(): grant _target ownership of the _galaxy and register
3571     //                  it for voting
3572     //
3573     function createGalaxy(uint8 _galaxy, address _target)
3574       external
3575       onlyOwner
3576     {
3577       //  only currently unowned (and thus also inactive) galaxies can be
3578       //  created, and only to non-zero addresses
3579       //
3580       require( azimuth.isOwner(_galaxy, 0x0) &&
3581                0x0 != _target );
3582 
3583       //  new galaxy means a new registered voter
3584       //
3585       polls.incrementTotalVoters();
3586 
3587       //  if the caller is sending the galaxy to themselves,
3588       //  assume it knows what it's doing and resolve right away
3589       //
3590       if (msg.sender == _target)
3591       {
3592         doSpawn(_galaxy, _target, true, 0x0);
3593       }
3594       //
3595       //  when sending to a "foreign" address, enforce a withdraw pattern,
3596       //  making the caller the owner in the mean time
3597       //
3598       else
3599       {
3600         doSpawn(_galaxy, _target, false, msg.sender);
3601       }
3602     }
3603 
3604     function setDnsDomains(string _primary, string _secondary, string _tertiary)
3605       external
3606       onlyOwner
3607     {
3608       azimuth.setDnsDomains(_primary, _secondary, _tertiary);
3609     }
3610 
3611   //
3612   //  Function modifiers for this contract
3613   //
3614 
3615     //  validPointId(): require that _id is a valid point
3616     //
3617     modifier validPointId(uint256 _id)
3618     {
3619       require(_id < 0x100000000);
3620       _;
3621     }
3622 
3623     //  activePointVoter(): require that :msg.sender can vote as _point,
3624     //                      and that _point is active
3625     //
3626     modifier activePointVoter(uint32 _point)
3627     {
3628       require( azimuth.canVoteAs(_point, msg.sender) &&
3629                azimuth.isActive(_point) );
3630       _;
3631     }
3632 }
3633 
3634 
3635 
3636 
3637 //  PlanetSale: a practically stateless point sale contract
3638 //
3639 //    This contract facilitates the sale of points (most commonly planets).
3640 //    Instead of "depositing" points into this contract, points are
3641 //    available for sale when this contract is able to spawn them.
3642 //    This is the case when the point is inactive and its prefix has
3643 //    allowed this contract to spawn for it.
3644 //
3645 //    The contract owner can determine the price per point, withdraw funds
3646 //    that have been sent to this contract, and shut down the contract
3647 //    to prevent further sales.
3648 //
3649 //    This contract is intended to be deployed by star owners that want
3650 //    to sell their planets on-chain.
3651 //
3652 contract PlanetSale is Ownable
3653 {
3654   //  PlanetSold: _planet has been sold
3655   //
3656   event PlanetSold(uint32 indexed prefix, uint32 indexed planet);
3657 
3658   //  azimuth: points state data store
3659   //
3660   Azimuth public azimuth;
3661 
3662   //  price: ether per planet, in wei
3663   //
3664   uint256 public price;
3665 
3666   //  constructor(): configure the points data store and initial sale price
3667   //
3668   constructor(Azimuth _azimuth, uint256 _price)
3669     public
3670   {
3671     require(0 < _price);
3672     azimuth = _azimuth;
3673     setPrice(_price);
3674   }
3675 
3676   //
3677   //  Buyer operations
3678   //
3679 
3680     //  available(): returns true if the _planet is available for purchase
3681     //
3682     function available(uint32 _planet)
3683       public
3684       view
3685       returns (bool result)
3686     {
3687       uint16 prefix = azimuth.getPrefix(_planet);
3688 
3689       return ( //  planet must not have an owner yet
3690                //
3691                azimuth.isOwner(_planet, 0x0) &&
3692                //
3693                //  this contract must be allowed to spawn for the prefix
3694                //
3695                azimuth.isSpawnProxy(prefix, this) &&
3696                //
3697                //  prefix must be linked
3698                //
3699                azimuth.hasBeenLinked(prefix) );
3700     }
3701 
3702     //  purchase(): pay the :price, acquire ownership of the _planet
3703     //
3704     //    discovery of available planets can be done off-chain
3705     //
3706     function purchase(uint32 _planet)
3707       external
3708       payable
3709     {
3710       require( //  caller must pay exactly the price of a planet
3711                //
3712                (msg.value == price) &&
3713                //
3714                //  the planet must be available for purchase
3715                //
3716                available(_planet) );
3717 
3718       //  spawn the planet to us, then immediately transfer to the caller
3719       //
3720       //    spawning to the caller would give the point's prefix's owner
3721       //    a window of opportunity to cancel the transfer
3722       //
3723       Ecliptic ecliptic = Ecliptic(azimuth.owner());
3724       ecliptic.spawn(_planet, this);
3725       ecliptic.transferPoint(_planet, msg.sender, false);
3726       emit PlanetSold(azimuth.getPrefix(_planet), _planet);
3727     }
3728 
3729   //
3730   //  Seller operations
3731   //
3732 
3733     //  setPrice(): configure the price in wei per planet
3734     //
3735     function setPrice(uint256 _price)
3736       public
3737       onlyOwner
3738     {
3739       require(0 < _price);
3740       price = _price;
3741     }
3742 
3743     //  withdraw(): withdraw ether funds held by this contract to _target
3744     //
3745     function withdraw(address _target)
3746       external
3747       onlyOwner
3748     {
3749       require(0x0 != _target);
3750       _target.transfer(address(this).balance);
3751     }
3752 
3753     //  close(): end the sale by destroying this contract and transferring
3754     //           remaining funds to _target
3755     //
3756     function close(address _target)
3757       external
3758       onlyOwner
3759     {
3760       require(0x0 != _target);
3761       selfdestruct(_target);
3762     }
3763 }