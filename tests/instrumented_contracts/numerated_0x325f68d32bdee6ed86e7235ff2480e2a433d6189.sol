1 //  simple reputations store
2 //  https://azimuth.network
3 
4 pragma solidity 0.4.24;
5 
6 ////////////////////////////////////////////////////////////////////////////////
7 //  Imports
8 ////////////////////////////////////////////////////////////////////////////////
9 
10 // OpenZeppelin's Owneable.sol
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
74 // Azimuth's Azimuth.sol
75 
76 //  Azimuth: point state data contract
77 //
78 //    This contract is used for storing all data related to Azimuth points
79 //    and their ownership. Consider this contract the Azimuth ledger.
80 //
81 //    It also contains permissions data, which ties in to ERC721
82 //    functionality. Operators of an address are allowed to transfer
83 //    ownership of all points owned by their associated address
84 //    (ERC721's approveAll()). A transfer proxy is allowed to transfer
85 //    ownership of a single point (ERC721's approve()).
86 //    Separate from ERC721 are managers, assigned per point. They are
87 //    allowed to perform "low-impact" operations on the owner's points,
88 //    like configuring public keys and making escape requests.
89 //
90 //    Since data stores are difficult to upgrade, this contract contains
91 //    as little actual business logic as possible. Instead, the data stored
92 //    herein can only be modified by this contract's owner, which can be
93 //    changed and is thus upgradable/replaceable.
94 //
95 //    This contract will be owned by the Ecliptic contract.
96 //
97 contract Azimuth is Ownable
98 {
99 //
100 //  Events
101 //
102 
103   //  OwnerChanged: :point is now owned by :owner
104   //
105   event OwnerChanged(uint32 indexed point, address indexed owner);
106 
107   //  Activated: :point is now active
108   //
109   event Activated(uint32 indexed point);
110 
111   //  Spawned: :prefix has spawned :child
112   //
113   event Spawned(uint32 indexed prefix, uint32 indexed child);
114 
115   //  EscapeRequested: :point has requested a new :sponsor
116   //
117   event EscapeRequested(uint32 indexed point, uint32 indexed sponsor);
118 
119   //  EscapeCanceled: :point's :sponsor request was canceled or rejected
120   //
121   event EscapeCanceled(uint32 indexed point, uint32 indexed sponsor);
122 
123   //  EscapeAccepted: :point confirmed with a new :sponsor
124   //
125   event EscapeAccepted(uint32 indexed point, uint32 indexed sponsor);
126 
127   //  LostSponsor: :point's :sponsor is now refusing it service
128   //
129   event LostSponsor(uint32 indexed point, uint32 indexed sponsor);
130 
131   //  ChangedKeys: :point has new network public keys
132   //
133   event ChangedKeys( uint32 indexed point,
134                      bytes32 encryptionKey,
135                      bytes32 authenticationKey,
136                      uint32 cryptoSuiteVersion,
137                      uint32 keyRevisionNumber );
138 
139   //  BrokeContinuity: :point has a new continuity number, :number
140   //
141   event BrokeContinuity(uint32 indexed point, uint32 number);
142 
143   //  ChangedSpawnProxy: :spawnProxy can now spawn using :point
144   //
145   event ChangedSpawnProxy(uint32 indexed point, address indexed spawnProxy);
146 
147   //  ChangedTransferProxy: :transferProxy can now transfer ownership of :point
148   //
149   event ChangedTransferProxy( uint32 indexed point,
150                               address indexed transferProxy );
151 
152   //  ChangedManagementProxy: :managementProxy can now manage :point
153   //
154   event ChangedManagementProxy( uint32 indexed point,
155                                 address indexed managementProxy );
156 
157   //  ChangedVotingProxy: :votingProxy can now vote using :point
158   //
159   event ChangedVotingProxy(uint32 indexed point, address indexed votingProxy);
160 
161   //  ChangedDns: dnsDomains have been updated
162   //
163   event ChangedDns(string primary, string secondary, string tertiary);
164 
165 //
166 //  Structures
167 //
168 
169   //  Size: kinds of points registered on-chain
170   //
171   //    NOTE: the order matters, because of Solidity enum numbering
172   //
173   enum Size
174   {
175     Galaxy, // = 0
176     Star,   // = 1
177     Planet  // = 2
178   }
179 
180   //  Point: state of a point
181   //
182   //    While the ordering of the struct members is semantically chaotic,
183   //    they are ordered to tightly pack them into Ethereum's 32-byte storage
184   //    slots, which reduces gas costs for some function calls.
185   //    The comment ticks indicate assumed slot boundaries.
186   //
187   struct Point
188   {
189     //  encryptionKey: (curve25519) encryption public key, or 0 for none
190     //
191     bytes32 encryptionKey;
192   //
193     //  authenticationKey: (ed25519) authentication public key, or 0 for none
194     //
195     bytes32 authenticationKey;
196   //
197     //  spawned: for stars and galaxies, all :active children
198     //
199     uint32[] spawned;
200   //
201     //  hasSponsor: true if the sponsor still supports the point
202     //
203     bool hasSponsor;
204 
205     //  active: whether point can be linked
206     //
207     //    false: point belongs to prefix, cannot be configured or linked
208     //    true: point no longer belongs to prefix, can be configured and linked
209     //
210     bool active;
211 
212     //  escapeRequested: true if the point has requested to change sponsors
213     //
214     bool escapeRequested;
215 
216     //  sponsor: the point that supports this one on the network, or,
217     //           if :hasSponsor is false, the last point that supported it.
218     //           (by default, the point's half-width prefix)
219     //
220     uint32 sponsor;
221 
222     //  escapeRequestedTo: if :escapeRequested is true, new sponsor requested
223     //
224     uint32 escapeRequestedTo;
225 
226     //  cryptoSuiteVersion: version of the crypto suite used for the pubkeys
227     //
228     uint32 cryptoSuiteVersion;
229 
230     //  keyRevisionNumber: incremented every time the public keys change
231     //
232     uint32 keyRevisionNumber;
233 
234     //  continuityNumber: incremented to indicate network-side state loss
235     //
236     uint32 continuityNumber;
237   }
238 
239   //  Deed: permissions for a point
240   //
241   struct Deed
242   {
243     //  owner: address that owns this point
244     //
245     address owner;
246 
247     //  managementProxy: 0, or another address with the right to perform
248     //                   low-impact, managerial operations on this point
249     //
250     address managementProxy;
251 
252     //  spawnProxy: 0, or another address with the right to spawn children
253     //              of this point
254     //
255     address spawnProxy;
256 
257     //  votingProxy: 0, or another address with the right to vote as this point
258     //
259     address votingProxy;
260 
261     //  transferProxy: 0, or another address with the right to transfer
262     //                 ownership of this point
263     //
264     address transferProxy;
265   }
266 
267 //
268 //  General state
269 //
270 
271   //  points: per point, general network-relevant point state
272   //
273   mapping(uint32 => Point) public points;
274 
275   //  rights: per point, on-chain ownership and permissions
276   //
277   mapping(uint32 => Deed) public rights;
278 
279   //  operators: per owner, per address, has the right to transfer ownership
280   //             of all the owner's points (ERC721)
281   //
282   mapping(address => mapping(address => bool)) public operators;
283 
284   //  dnsDomains: base domains for contacting galaxies
285   //
286   //    dnsDomains[0] is primary, the others are used as fallbacks
287   //
288   string[3] public dnsDomains;
289 
290 //
291 //  Lookups
292 //
293 
294   //  sponsoring: per point, the points they are sponsoring
295   //
296   mapping(uint32 => uint32[]) public sponsoring;
297 
298   //  sponsoringIndexes: per point, per point, (index + 1) in
299   //                     the sponsoring array
300   //
301   mapping(uint32 => mapping(uint32 => uint256)) public sponsoringIndexes;
302 
303   //  escapeRequests: per point, the points they have open escape requests from
304   //
305   mapping(uint32 => uint32[]) public escapeRequests;
306 
307   //  escapeRequestsIndexes: per point, per point, (index + 1) in
308   //                         the escapeRequests array
309   //
310   mapping(uint32 => mapping(uint32 => uint256)) public escapeRequestsIndexes;
311 
312   //  pointsOwnedBy: per address, the points they own
313   //
314   mapping(address => uint32[]) public pointsOwnedBy;
315 
316   //  pointOwnerIndexes: per owner, per point, (index + 1) in
317   //                     the pointsOwnedBy array
318   //
319   //    We delete owners by moving the last entry in the array to the
320   //    newly emptied slot, which is (n - 1) where n is the value of
321   //    pointOwnerIndexes[owner][point].
322   //
323   mapping(address => mapping(uint32 => uint256)) public pointOwnerIndexes;
324 
325   //  managerFor: per address, the points they are the management proxy for
326   //
327   mapping(address => uint32[]) public managerFor;
328 
329   //  managerForIndexes: per address, per point, (index + 1) in
330   //                     the managerFor array
331   //
332   mapping(address => mapping(uint32 => uint256)) public managerForIndexes;
333 
334   //  spawningFor: per address, the points they can spawn with
335   //
336   mapping(address => uint32[]) public spawningFor;
337 
338   //  spawningForIndexes: per address, per point, (index + 1) in
339   //                      the spawningFor array
340   //
341   mapping(address => mapping(uint32 => uint256)) public spawningForIndexes;
342 
343   //  votingFor: per address, the points they can vote with
344   //
345   mapping(address => uint32[]) public votingFor;
346 
347   //  votingForIndexes: per address, per point, (index + 1) in
348   //                    the votingFor array
349   //
350   mapping(address => mapping(uint32 => uint256)) public votingForIndexes;
351 
352   //  transferringFor: per address, the points they can transfer
353   //
354   mapping(address => uint32[]) public transferringFor;
355 
356   //  transferringForIndexes: per address, per point, (index + 1) in
357   //                          the transferringFor array
358   //
359   mapping(address => mapping(uint32 => uint256)) public transferringForIndexes;
360 
361 //
362 //  Logic
363 //
364 
365   //  constructor(): configure default dns domains
366   //
367   constructor()
368     public
369   {
370     setDnsDomains("example.com", "example.com", "example.com");
371   }
372 
373   //  setDnsDomains(): set the base domains used for contacting galaxies
374   //
375   //    Note: since a string is really just a byte[], and Solidity can't
376   //    work with two-dimensional arrays yet, we pass in the three
377   //    domains as individual strings.
378   //
379   function setDnsDomains(string _primary, string _secondary, string _tertiary)
380     onlyOwner
381     public
382   {
383     dnsDomains[0] = _primary;
384     dnsDomains[1] = _secondary;
385     dnsDomains[2] = _tertiary;
386     emit ChangedDns(_primary, _secondary, _tertiary);
387   }
388 
389   //
390   //  Point reading
391   //
392 
393     //  isActive(): return true if _point is active
394     //
395     function isActive(uint32 _point)
396       view
397       external
398       returns (bool equals)
399     {
400       return points[_point].active;
401     }
402 
403     //  getKeys(): returns the public keys and their details, as currently
404     //             registered for _point
405     //
406     function getKeys(uint32 _point)
407       view
408       external
409       returns (bytes32 crypt, bytes32 auth, uint32 suite, uint32 revision)
410     {
411       Point storage point = points[_point];
412       return (point.encryptionKey,
413               point.authenticationKey,
414               point.cryptoSuiteVersion,
415               point.keyRevisionNumber);
416     }
417 
418     //  getKeyRevisionNumber(): gets the revision number of _point's current
419     //                          public keys
420     //
421     function getKeyRevisionNumber(uint32 _point)
422       view
423       external
424       returns (uint32 revision)
425     {
426       return points[_point].keyRevisionNumber;
427     }
428 
429     //  hasBeenLinked(): returns true if the point has ever been assigned keys
430     //
431     function hasBeenLinked(uint32 _point)
432       view
433       external
434       returns (bool result)
435     {
436       return ( points[_point].keyRevisionNumber > 0 );
437     }
438 
439     //  isLive(): returns true if _point currently has keys properly configured
440     //
441     function isLive(uint32 _point)
442       view
443       external
444       returns (bool result)
445     {
446       Point storage point = points[_point];
447       return ( point.encryptionKey != 0 &&
448                point.authenticationKey != 0 &&
449                point.cryptoSuiteVersion != 0 );
450     }
451 
452     //  getContinuityNumber(): returns _point's current continuity number
453     //
454     function getContinuityNumber(uint32 _point)
455       view
456       external
457       returns (uint32 continuityNumber)
458     {
459       return points[_point].continuityNumber;
460     }
461 
462     //  getSpawnCount(): return the number of children spawned by _point
463     //
464     function getSpawnCount(uint32 _point)
465       view
466       external
467       returns (uint32 spawnCount)
468     {
469       uint256 len = points[_point].spawned.length;
470       assert(len < 2**32);
471       return uint32(len);
472     }
473 
474     //  getSpawned(): return array of points created under _point
475     //
476     //    Note: only useful for clients, as Solidity does not currently
477     //    support returning dynamic arrays.
478     //
479     function getSpawned(uint32 _point)
480       view
481       external
482       returns (uint32[] spawned)
483     {
484       return points[_point].spawned;
485     }
486 
487     //  hasSponsor(): returns true if _point's sponsor is providing it service
488     //
489     function hasSponsor(uint32 _point)
490       view
491       external
492       returns (bool has)
493     {
494       return points[_point].hasSponsor;
495     }
496 
497     //  getSponsor(): returns _point's current (or most recent) sponsor
498     //
499     function getSponsor(uint32 _point)
500       view
501       external
502       returns (uint32 sponsor)
503     {
504       return points[_point].sponsor;
505     }
506 
507     //  isSponsor(): returns true if _sponsor is currently providing service
508     //               to _point
509     //
510     function isSponsor(uint32 _point, uint32 _sponsor)
511       view
512       external
513       returns (bool result)
514     {
515       Point storage point = points[_point];
516       return ( point.hasSponsor &&
517                (point.sponsor == _sponsor) );
518     }
519 
520     //  getSponsoringCount(): returns the number of points _sponsor is
521     //                        providing service to
522     //
523     function getSponsoringCount(uint32 _sponsor)
524       view
525       external
526       returns (uint256 count)
527     {
528       return sponsoring[_sponsor].length;
529     }
530 
531     //  getSponsoring(): returns a list of points _sponsor is providing
532     //                   service to
533     //
534     //    Note: only useful for clients, as Solidity does not currently
535     //    support returning dynamic arrays.
536     //
537     function getSponsoring(uint32 _sponsor)
538       view
539       external
540       returns (uint32[] sponsees)
541     {
542       return sponsoring[_sponsor];
543     }
544 
545     //  escaping
546 
547     //  isEscaping(): returns true if _point has an outstanding escape request
548     //
549     function isEscaping(uint32 _point)
550       view
551       external
552       returns (bool escaping)
553     {
554       return points[_point].escapeRequested;
555     }
556 
557     //  getEscapeRequest(): returns _point's current escape request
558     //
559     //    the returned escape request is only valid as long as isEscaping()
560     //    returns true
561     //
562     function getEscapeRequest(uint32 _point)
563       view
564       external
565       returns (uint32 escape)
566     {
567       return points[_point].escapeRequestedTo;
568     }
569 
570     //  isRequestingEscapeTo(): returns true if _point has an outstanding
571     //                          escape request targetting _sponsor
572     //
573     function isRequestingEscapeTo(uint32 _point, uint32 _sponsor)
574       view
575       public
576       returns (bool equals)
577     {
578       Point storage point = points[_point];
579       return (point.escapeRequested && (point.escapeRequestedTo == _sponsor));
580     }
581 
582     //  getEscapeRequestsCount(): returns the number of points _sponsor
583     //                            is providing service to
584     //
585     function getEscapeRequestsCount(uint32 _sponsor)
586       view
587       external
588       returns (uint256 count)
589     {
590       return escapeRequests[_sponsor].length;
591     }
592 
593     //  getEscapeRequests(): get the points _sponsor has received escape
594     //                       requests from
595     //
596     //    Note: only useful for clients, as Solidity does not currently
597     //    support returning dynamic arrays.
598     //
599     function getEscapeRequests(uint32 _sponsor)
600       view
601       external
602       returns (uint32[] requests)
603     {
604       return escapeRequests[_sponsor];
605     }
606 
607   //
608   //  Point writing
609   //
610 
611     //  activatePoint(): activate a point, register it as spawned by its prefix
612     //
613     function activatePoint(uint32 _point)
614       onlyOwner
615       external
616     {
617       //  make a point active, setting its sponsor to its prefix
618       //
619       Point storage point = points[_point];
620       require(!point.active);
621       point.active = true;
622       registerSponsor(_point, true, getPrefix(_point));
623       emit Activated(_point);
624     }
625 
626     //  setKeys(): set network public keys of _point to _encryptionKey and
627     //            _authenticationKey, with the specified _cryptoSuiteVersion
628     //
629     function setKeys(uint32 _point,
630                      bytes32 _encryptionKey,
631                      bytes32 _authenticationKey,
632                      uint32 _cryptoSuiteVersion)
633       onlyOwner
634       external
635     {
636       Point storage point = points[_point];
637       if ( point.encryptionKey == _encryptionKey &&
638            point.authenticationKey == _authenticationKey &&
639            point.cryptoSuiteVersion == _cryptoSuiteVersion )
640       {
641         return;
642       }
643 
644       point.encryptionKey = _encryptionKey;
645       point.authenticationKey = _authenticationKey;
646       point.cryptoSuiteVersion = _cryptoSuiteVersion;
647       point.keyRevisionNumber++;
648 
649       emit ChangedKeys(_point,
650                        _encryptionKey,
651                        _authenticationKey,
652                        _cryptoSuiteVersion,
653                        point.keyRevisionNumber);
654     }
655 
656     //  incrementContinuityNumber(): break continuity for _point
657     //
658     function incrementContinuityNumber(uint32 _point)
659       onlyOwner
660       external
661     {
662       Point storage point = points[_point];
663       point.continuityNumber++;
664       emit BrokeContinuity(_point, point.continuityNumber);
665     }
666 
667     //  registerSpawn(): add a point to its prefix's list of spawned points
668     //
669     function registerSpawned(uint32 _point)
670       onlyOwner
671       external
672     {
673       //  if a point is its own prefix (a galaxy) then don't register it
674       //
675       uint32 prefix = getPrefix(_point);
676       if (prefix == _point)
677       {
678         return;
679       }
680 
681       //  register a new spawned point for the prefix
682       //
683       points[prefix].spawned.push(_point);
684       emit Spawned(prefix, _point);
685     }
686 
687     //  loseSponsor(): indicates that _point's sponsor is no longer providing
688     //                 it service
689     //
690     function loseSponsor(uint32 _point)
691       onlyOwner
692       external
693     {
694       Point storage point = points[_point];
695       if (!point.hasSponsor)
696       {
697         return;
698       }
699       registerSponsor(_point, false, point.sponsor);
700       emit LostSponsor(_point, point.sponsor);
701     }
702 
703     //  setEscapeRequest(): for _point, start an escape request to _sponsor
704     //
705     function setEscapeRequest(uint32 _point, uint32 _sponsor)
706       onlyOwner
707       external
708     {
709       if (isRequestingEscapeTo(_point, _sponsor))
710       {
711         return;
712       }
713       registerEscapeRequest(_point, true, _sponsor);
714       emit EscapeRequested(_point, _sponsor);
715     }
716 
717     //  cancelEscape(): for _point, stop the current escape request, if any
718     //
719     function cancelEscape(uint32 _point)
720       onlyOwner
721       external
722     {
723       Point storage point = points[_point];
724       if (!point.escapeRequested)
725       {
726         return;
727       }
728       uint32 request = point.escapeRequestedTo;
729       registerEscapeRequest(_point, false, 0);
730       emit EscapeCanceled(_point, request);
731     }
732 
733     //  doEscape(): perform the requested escape
734     //
735     function doEscape(uint32 _point)
736       onlyOwner
737       external
738     {
739       Point storage point = points[_point];
740       require(point.escapeRequested);
741       registerSponsor(_point, true, point.escapeRequestedTo);
742       registerEscapeRequest(_point, false, 0);
743       emit EscapeAccepted(_point, point.sponsor);
744     }
745 
746   //
747   //  Point utils
748   //
749 
750     //  getPrefix(): compute prefix ("parent") of _point
751     //
752     function getPrefix(uint32 _point)
753       pure
754       public
755       returns (uint16 prefix)
756     {
757       if (_point < 0x10000)
758       {
759         return uint16(_point % 0x100);
760       }
761       return uint16(_point % 0x10000);
762     }
763 
764     //  getPointSize(): return the size of _point
765     //
766     function getPointSize(uint32 _point)
767       external
768       pure
769       returns (Size _size)
770     {
771       if (_point < 0x100) return Size.Galaxy;
772       if (_point < 0x10000) return Size.Star;
773       return Size.Planet;
774     }
775 
776     //  internal use
777 
778     //  registerSponsor(): set the sponsorship state of _point and update the
779     //                     reverse lookup for sponsors
780     //
781     function registerSponsor(uint32 _point, bool _hasSponsor, uint32 _sponsor)
782       internal
783     {
784       Point storage point = points[_point];
785       bool had = point.hasSponsor;
786       uint32 prev = point.sponsor;
787 
788       //  if we didn't have a sponsor, and won't get one,
789       //  or if we get the sponsor we already have,
790       //  nothing will change, so jump out early.
791       //
792       if ( (!had && !_hasSponsor) ||
793            (had && _hasSponsor && prev == _sponsor) )
794       {
795         return;
796       }
797 
798       //  if the point used to have a different sponsor, do some gymnastics
799       //  to keep the reverse lookup gapless.  delete the point from the old
800       //  sponsor's list, then fill that gap with the list tail.
801       //
802       if (had)
803       {
804         //  i: current index in previous sponsor's list of sponsored points
805         //
806         uint256 i = sponsoringIndexes[prev][_point];
807 
808         //  we store index + 1, because 0 is the solidity default value
809         //
810         assert(i > 0);
811         i--;
812 
813         //  copy the last item in the list into the now-unused slot,
814         //  making sure to update its :sponsoringIndexes reference
815         //
816         uint32[] storage prevSponsoring = sponsoring[prev];
817         uint256 last = prevSponsoring.length - 1;
818         uint32 moved = prevSponsoring[last];
819         prevSponsoring[i] = moved;
820         sponsoringIndexes[prev][moved] = i + 1;
821 
822         //  delete the last item
823         //
824         delete(prevSponsoring[last]);
825         prevSponsoring.length = last;
826         sponsoringIndexes[prev][_point] = 0;
827       }
828 
829       if (_hasSponsor)
830       {
831         uint32[] storage newSponsoring = sponsoring[_sponsor];
832         newSponsoring.push(_point);
833         sponsoringIndexes[_sponsor][_point] = newSponsoring.length;
834       }
835 
836       point.sponsor = _sponsor;
837       point.hasSponsor = _hasSponsor;
838     }
839 
840     //  registerEscapeRequest(): set the escape state of _point and update the
841     //                           reverse lookup for sponsors
842     //
843     function registerEscapeRequest( uint32 _point,
844                                     bool _isEscaping, uint32 _sponsor )
845       internal
846     {
847       Point storage point = points[_point];
848       bool was = point.escapeRequested;
849       uint32 prev = point.escapeRequestedTo;
850 
851       //  if we weren't escaping, and won't be,
852       //  or if we were escaping, and the new target is the same,
853       //  nothing will change, so jump out early.
854       //
855       if ( (!was && !_isEscaping) ||
856            (was && _isEscaping && prev == _sponsor) )
857       {
858         return;
859       }
860 
861       //  if the point used to have a different request, do some gymnastics
862       //  to keep the reverse lookup gapless.  delete the point from the old
863       //  sponsor's list, then fill that gap with the list tail.
864       //
865       if (was)
866       {
867         //  i: current index in previous sponsor's list of sponsored points
868         //
869         uint256 i = escapeRequestsIndexes[prev][_point];
870 
871         //  we store index + 1, because 0 is the solidity default value
872         //
873         assert(i > 0);
874         i--;
875 
876         //  copy the last item in the list into the now-unused slot,
877         //  making sure to update its :escapeRequestsIndexes reference
878         //
879         uint32[] storage prevRequests = escapeRequests[prev];
880         uint256 last = prevRequests.length - 1;
881         uint32 moved = prevRequests[last];
882         prevRequests[i] = moved;
883         escapeRequestsIndexes[prev][moved] = i + 1;
884 
885         //  delete the last item
886         //
887         delete(prevRequests[last]);
888         prevRequests.length = last;
889         escapeRequestsIndexes[prev][_point] = 0;
890       }
891 
892       if (_isEscaping)
893       {
894         uint32[] storage newRequests = escapeRequests[_sponsor];
895         newRequests.push(_point);
896         escapeRequestsIndexes[_sponsor][_point] = newRequests.length;
897       }
898 
899       point.escapeRequestedTo = _sponsor;
900       point.escapeRequested = _isEscaping;
901     }
902 
903   //
904   //  Deed reading
905   //
906 
907     //  owner
908 
909     //  getOwner(): return owner of _point
910     //
911     function getOwner(uint32 _point)
912       view
913       external
914       returns (address owner)
915     {
916       return rights[_point].owner;
917     }
918 
919     //  isOwner(): true if _point is owned by _address
920     //
921     function isOwner(uint32 _point, address _address)
922       view
923       external
924       returns (bool result)
925     {
926       return (rights[_point].owner == _address);
927     }
928 
929     //  getOwnedPointCount(): return length of array of points that _whose owns
930     //
931     function getOwnedPointCount(address _whose)
932       view
933       external
934       returns (uint256 count)
935     {
936       return pointsOwnedBy[_whose].length;
937     }
938 
939     //  getOwnedPoints(): return array of points that _whose owns
940     //
941     //    Note: only useful for clients, as Solidity does not currently
942     //    support returning dynamic arrays.
943     //
944     function getOwnedPoints(address _whose)
945       view
946       external
947       returns (uint32[] ownedPoints)
948     {
949       return pointsOwnedBy[_whose];
950     }
951 
952     //  getOwnedPointAtIndex(): get point at _index from array of points that
953     //                         _whose owns
954     //
955     function getOwnedPointAtIndex(address _whose, uint256 _index)
956       view
957       external
958       returns (uint32 point)
959     {
960       uint32[] storage owned = pointsOwnedBy[_whose];
961       require(_index < owned.length);
962       return owned[_index];
963     }
964 
965     //  management proxy
966 
967     //  getManagementProxy(): returns _point's current management proxy
968     //
969     function getManagementProxy(uint32 _point)
970       view
971       external
972       returns (address manager)
973     {
974       return rights[_point].managementProxy;
975     }
976 
977     //  isManagementProxy(): returns true if _proxy is _point's management proxy
978     //
979     function isManagementProxy(uint32 _point, address _proxy)
980       view
981       external
982       returns (bool result)
983     {
984       return (rights[_point].managementProxy == _proxy);
985     }
986 
987     //  canManage(): true if _who is the owner or manager of _point
988     //
989     function canManage(uint32 _point, address _who)
990       view
991       external
992       returns (bool result)
993     {
994       Deed storage deed = rights[_point];
995       return ( (0x0 != _who) &&
996                ( (_who == deed.owner) ||
997                  (_who == deed.managementProxy) ) );
998     }
999 
1000     //  getManagerForCount(): returns the amount of points _proxy can manage
1001     //
1002     function getManagerForCount(address _proxy)
1003       view
1004       external
1005       returns (uint256 count)
1006     {
1007       return managerFor[_proxy].length;
1008     }
1009 
1010     //  getManagerFor(): returns the points _proxy can manage
1011     //
1012     //    Note: only useful for clients, as Solidity does not currently
1013     //    support returning dynamic arrays.
1014     //
1015     function getManagerFor(address _proxy)
1016       view
1017       external
1018       returns (uint32[] mfor)
1019     {
1020       return managerFor[_proxy];
1021     }
1022 
1023     //  spawn proxy
1024 
1025     //  getSpawnProxy(): returns _point's current spawn proxy
1026     //
1027     function getSpawnProxy(uint32 _point)
1028       view
1029       external
1030       returns (address spawnProxy)
1031     {
1032       return rights[_point].spawnProxy;
1033     }
1034 
1035     //  isSpawnProxy(): returns true if _proxy is _point's spawn proxy
1036     //
1037     function isSpawnProxy(uint32 _point, address _proxy)
1038       view
1039       external
1040       returns (bool result)
1041     {
1042       return (rights[_point].spawnProxy == _proxy);
1043     }
1044 
1045     //  canSpawnAs(): true if _who is the owner or spawn proxy of _point
1046     //
1047     function canSpawnAs(uint32 _point, address _who)
1048       view
1049       external
1050       returns (bool result)
1051     {
1052       Deed storage deed = rights[_point];
1053       return ( (0x0 != _who) &&
1054                ( (_who == deed.owner) ||
1055                  (_who == deed.spawnProxy) ) );
1056     }
1057 
1058     //  getSpawningForCount(): returns the amount of points _proxy
1059     //                         can spawn with
1060     //
1061     function getSpawningForCount(address _proxy)
1062       view
1063       external
1064       returns (uint256 count)
1065     {
1066       return spawningFor[_proxy].length;
1067     }
1068 
1069     //  getSpawningFor(): get the points _proxy can spawn with
1070     //
1071     //    Note: only useful for clients, as Solidity does not currently
1072     //    support returning dynamic arrays.
1073     //
1074     function getSpawningFor(address _proxy)
1075       view
1076       external
1077       returns (uint32[] sfor)
1078     {
1079       return spawningFor[_proxy];
1080     }
1081 
1082     //  voting proxy
1083 
1084     //  getVotingProxy(): returns _point's current voting proxy
1085     //
1086     function getVotingProxy(uint32 _point)
1087       view
1088       external
1089       returns (address voter)
1090     {
1091       return rights[_point].votingProxy;
1092     }
1093 
1094     //  isVotingProxy(): returns true if _proxy is _point's voting proxy
1095     //
1096     function isVotingProxy(uint32 _point, address _proxy)
1097       view
1098       external
1099       returns (bool result)
1100     {
1101       return (rights[_point].votingProxy == _proxy);
1102     }
1103 
1104     //  canVoteAs(): true if _who is the owner of _point,
1105     //               or the voting proxy of _point's owner
1106     //
1107     function canVoteAs(uint32 _point, address _who)
1108       view
1109       external
1110       returns (bool result)
1111     {
1112       Deed storage deed = rights[_point];
1113       return ( (0x0 != _who) &&
1114                ( (_who == deed.owner) ||
1115                  (_who == deed.votingProxy) ) );
1116     }
1117 
1118     //  getVotingForCount(): returns the amount of points _proxy can vote as
1119     //
1120     function getVotingForCount(address _proxy)
1121       view
1122       external
1123       returns (uint256 count)
1124     {
1125       return votingFor[_proxy].length;
1126     }
1127 
1128     //  getVotingFor(): returns the points _proxy can vote as
1129     //
1130     //    Note: only useful for clients, as Solidity does not currently
1131     //    support returning dynamic arrays.
1132     //
1133     function getVotingFor(address _proxy)
1134       view
1135       external
1136       returns (uint32[] vfor)
1137     {
1138       return votingFor[_proxy];
1139     }
1140 
1141     //  transfer proxy
1142 
1143     //  getTransferProxy(): returns _point's current transfer proxy
1144     //
1145     function getTransferProxy(uint32 _point)
1146       view
1147       external
1148       returns (address transferProxy)
1149     {
1150       return rights[_point].transferProxy;
1151     }
1152 
1153     //  isTransferProxy(): returns true if _proxy is _point's transfer proxy
1154     //
1155     function isTransferProxy(uint32 _point, address _proxy)
1156       view
1157       external
1158       returns (bool result)
1159     {
1160       return (rights[_point].transferProxy == _proxy);
1161     }
1162 
1163     //  canTransfer(): true if _who is the owner or transfer proxy of _point,
1164     //                 or is an operator for _point's current owner
1165     //
1166     function canTransfer(uint32 _point, address _who)
1167       view
1168       external
1169       returns (bool result)
1170     {
1171       Deed storage deed = rights[_point];
1172       return ( (0x0 != _who) &&
1173                ( (_who == deed.owner) ||
1174                  (_who == deed.transferProxy) ||
1175                  operators[deed.owner][_who] ) );
1176     }
1177 
1178     //  getTransferringForCount(): returns the amount of points _proxy
1179     //                             can transfer
1180     //
1181     function getTransferringForCount(address _proxy)
1182       view
1183       external
1184       returns (uint256 count)
1185     {
1186       return transferringFor[_proxy].length;
1187     }
1188 
1189     //  getTransferringFor(): get the points _proxy can transfer
1190     //
1191     //    Note: only useful for clients, as Solidity does not currently
1192     //    support returning dynamic arrays.
1193     //
1194     function getTransferringFor(address _proxy)
1195       view
1196       external
1197       returns (uint32[] tfor)
1198     {
1199       return transferringFor[_proxy];
1200     }
1201 
1202     //  isOperator(): returns true if _operator is allowed to transfer
1203     //                ownership of _owner's points
1204     //
1205     function isOperator(address _owner, address _operator)
1206       view
1207       external
1208       returns (bool result)
1209     {
1210       return operators[_owner][_operator];
1211     }
1212 
1213   //
1214   //  Deed writing
1215   //
1216 
1217     //  setOwner(): set owner of _point to _owner
1218     //
1219     //    Note: setOwner() only implements the minimal data storage
1220     //    logic for a transfer; the full transfer is implemented in
1221     //    Ecliptic.
1222     //
1223     //    Note: _owner must not be the zero address.
1224     //
1225     function setOwner(uint32 _point, address _owner)
1226       onlyOwner
1227       external
1228     {
1229       //  prevent burning of points by making zero the owner
1230       //
1231       require(0x0 != _owner);
1232 
1233       //  prev: previous owner, if any
1234       //
1235       address prev = rights[_point].owner;
1236 
1237       if (prev == _owner)
1238       {
1239         return;
1240       }
1241 
1242       //  if the point used to have a different owner, do some gymnastics to
1243       //  keep the list of owned points gapless.  delete this point from the
1244       //  list, then fill that gap with the list tail.
1245       //
1246       if (0x0 != prev)
1247       {
1248         //  i: current index in previous owner's list of owned points
1249         //
1250         uint256 i = pointOwnerIndexes[prev][_point];
1251 
1252         //  we store index + 1, because 0 is the solidity default value
1253         //
1254         assert(i > 0);
1255         i--;
1256 
1257         //  copy the last item in the list into the now-unused slot,
1258         //  making sure to update its :pointOwnerIndexes reference
1259         //
1260         uint32[] storage owner = pointsOwnedBy[prev];
1261         uint256 last = owner.length - 1;
1262         uint32 moved = owner[last];
1263         owner[i] = moved;
1264         pointOwnerIndexes[prev][moved] = i + 1;
1265 
1266         //  delete the last item
1267         //
1268         delete(owner[last]);
1269         owner.length = last;
1270         pointOwnerIndexes[prev][_point] = 0;
1271       }
1272 
1273       //  update the owner list and the owner's index list
1274       //
1275       rights[_point].owner = _owner;
1276       pointsOwnedBy[_owner].push(_point);
1277       pointOwnerIndexes[_owner][_point] = pointsOwnedBy[_owner].length;
1278       emit OwnerChanged(_point, _owner);
1279     }
1280 
1281     //  setManagementProxy(): makes _proxy _point's management proxy
1282     //
1283     function setManagementProxy(uint32 _point, address _proxy)
1284       onlyOwner
1285       external
1286     {
1287       Deed storage deed = rights[_point];
1288       address prev = deed.managementProxy;
1289       if (prev == _proxy)
1290       {
1291         return;
1292       }
1293 
1294       //  if the point used to have a different manager, do some gymnastics
1295       //  to keep the reverse lookup gapless.  delete the point from the
1296       //  old manager's list, then fill that gap with the list tail.
1297       //
1298       if (0x0 != prev)
1299       {
1300         //  i: current index in previous manager's list of managed points
1301         //
1302         uint256 i = managerForIndexes[prev][_point];
1303 
1304         //  we store index + 1, because 0 is the solidity default value
1305         //
1306         assert(i > 0);
1307         i--;
1308 
1309         //  copy the last item in the list into the now-unused slot,
1310         //  making sure to update its :managerForIndexes reference
1311         //
1312         uint32[] storage prevMfor = managerFor[prev];
1313         uint256 last = prevMfor.length - 1;
1314         uint32 moved = prevMfor[last];
1315         prevMfor[i] = moved;
1316         managerForIndexes[prev][moved] = i + 1;
1317 
1318         //  delete the last item
1319         //
1320         delete(prevMfor[last]);
1321         prevMfor.length = last;
1322         managerForIndexes[prev][_point] = 0;
1323       }
1324 
1325       if (0x0 != _proxy)
1326       {
1327         uint32[] storage mfor = managerFor[_proxy];
1328         mfor.push(_point);
1329         managerForIndexes[_proxy][_point] = mfor.length;
1330       }
1331 
1332       deed.managementProxy = _proxy;
1333       emit ChangedManagementProxy(_point, _proxy);
1334     }
1335 
1336     //  setSpawnProxy(): makes _proxy _point's spawn proxy
1337     //
1338     function setSpawnProxy(uint32 _point, address _proxy)
1339       onlyOwner
1340       external
1341     {
1342       Deed storage deed = rights[_point];
1343       address prev = deed.spawnProxy;
1344       if (prev == _proxy)
1345       {
1346         return;
1347       }
1348 
1349       //  if the point used to have a different spawn proxy, do some
1350       //  gymnastics to keep the reverse lookup gapless.  delete the point
1351       //  from the old proxy's list, then fill that gap with the list tail.
1352       //
1353       if (0x0 != prev)
1354       {
1355         //  i: current index in previous proxy's list of spawning points
1356         //
1357         uint256 i = spawningForIndexes[prev][_point];
1358 
1359         //  we store index + 1, because 0 is the solidity default value
1360         //
1361         assert(i > 0);
1362         i--;
1363 
1364         //  copy the last item in the list into the now-unused slot,
1365         //  making sure to update its :spawningForIndexes reference
1366         //
1367         uint32[] storage prevSfor = spawningFor[prev];
1368         uint256 last = prevSfor.length - 1;
1369         uint32 moved = prevSfor[last];
1370         prevSfor[i] = moved;
1371         spawningForIndexes[prev][moved] = i + 1;
1372 
1373         //  delete the last item
1374         //
1375         delete(prevSfor[last]);
1376         prevSfor.length = last;
1377         spawningForIndexes[prev][_point] = 0;
1378       }
1379 
1380       if (0x0 != _proxy)
1381       {
1382         uint32[] storage sfor = spawningFor[_proxy];
1383         sfor.push(_point);
1384         spawningForIndexes[_proxy][_point] = sfor.length;
1385       }
1386 
1387       deed.spawnProxy = _proxy;
1388       emit ChangedSpawnProxy(_point, _proxy);
1389     }
1390 
1391     //  setVotingProxy(): makes _proxy _point's voting proxy
1392     //
1393     function setVotingProxy(uint32 _point, address _proxy)
1394       onlyOwner
1395       external
1396     {
1397       Deed storage deed = rights[_point];
1398       address prev = deed.votingProxy;
1399       if (prev == _proxy)
1400       {
1401         return;
1402       }
1403 
1404       //  if the point used to have a different voter, do some gymnastics
1405       //  to keep the reverse lookup gapless.  delete the point from the
1406       //  old voter's list, then fill that gap with the list tail.
1407       //
1408       if (0x0 != prev)
1409       {
1410         //  i: current index in previous voter's list of points it was
1411         //     voting for
1412         //
1413         uint256 i = votingForIndexes[prev][_point];
1414 
1415         //  we store index + 1, because 0 is the solidity default value
1416         //
1417         assert(i > 0);
1418         i--;
1419 
1420         //  copy the last item in the list into the now-unused slot,
1421         //  making sure to update its :votingForIndexes reference
1422         //
1423         uint32[] storage prevVfor = votingFor[prev];
1424         uint256 last = prevVfor.length - 1;
1425         uint32 moved = prevVfor[last];
1426         prevVfor[i] = moved;
1427         votingForIndexes[prev][moved] = i + 1;
1428 
1429         //  delete the last item
1430         //
1431         delete(prevVfor[last]);
1432         prevVfor.length = last;
1433         votingForIndexes[prev][_point] = 0;
1434       }
1435 
1436       if (0x0 != _proxy)
1437       {
1438         uint32[] storage vfor = votingFor[_proxy];
1439         vfor.push(_point);
1440         votingForIndexes[_proxy][_point] = vfor.length;
1441       }
1442 
1443       deed.votingProxy = _proxy;
1444       emit ChangedVotingProxy(_point, _proxy);
1445     }
1446 
1447     //  setManagementProxy(): makes _proxy _point's transfer proxy
1448     //
1449     function setTransferProxy(uint32 _point, address _proxy)
1450       onlyOwner
1451       external
1452     {
1453       Deed storage deed = rights[_point];
1454       address prev = deed.transferProxy;
1455       if (prev == _proxy)
1456       {
1457         return;
1458       }
1459 
1460       //  if the point used to have a different transfer proxy, do some
1461       //  gymnastics to keep the reverse lookup gapless.  delete the point
1462       //  from the old proxy's list, then fill that gap with the list tail.
1463       //
1464       if (0x0 != prev)
1465       {
1466         //  i: current index in previous proxy's list of transferable points
1467         //
1468         uint256 i = transferringForIndexes[prev][_point];
1469 
1470         //  we store index + 1, because 0 is the solidity default value
1471         //
1472         assert(i > 0);
1473         i--;
1474 
1475         //  copy the last item in the list into the now-unused slot,
1476         //  making sure to update its :transferringForIndexes reference
1477         //
1478         uint32[] storage prevTfor = transferringFor[prev];
1479         uint256 last = prevTfor.length - 1;
1480         uint32 moved = prevTfor[last];
1481         prevTfor[i] = moved;
1482         transferringForIndexes[prev][moved] = i + 1;
1483 
1484         //  delete the last item
1485         //
1486         delete(prevTfor[last]);
1487         prevTfor.length = last;
1488         transferringForIndexes[prev][_point] = 0;
1489       }
1490 
1491       if (0x0 != _proxy)
1492       {
1493         uint32[] storage tfor = transferringFor[_proxy];
1494         tfor.push(_point);
1495         transferringForIndexes[_proxy][_point] = tfor.length;
1496       }
1497 
1498       deed.transferProxy = _proxy;
1499       emit ChangedTransferProxy(_point, _proxy);
1500     }
1501 
1502     //  setOperator(): dis/allow _operator to transfer ownership of all points
1503     //                 owned by _owner
1504     //
1505     //    operators are part of the ERC721 standard
1506     //
1507     function setOperator(address _owner, address _operator, bool _approved)
1508       onlyOwner
1509       external
1510     {
1511       operators[_owner][_operator] = _approved;
1512     }
1513 }
1514 
1515 // Azimuth's ReadsAzimuth.sol
1516 
1517 //  ReadsAzimuth: referring to and testing against the Azimuth
1518 //                data contract
1519 //
1520 //    To avoid needless repetition, this contract provides common
1521 //    checks and operations using the Azimuth contract.
1522 //
1523 contract ReadsAzimuth
1524 {
1525   //  azimuth: points data storage contract.
1526   //
1527   Azimuth public azimuth;
1528 
1529   //  constructor(): set the Azimuth data contract's address
1530   //
1531   constructor(Azimuth _azimuth)
1532     public
1533   {
1534     azimuth = _azimuth;
1535   }
1536 
1537   //  activePointOwner(): require that :msg.sender is the owner of _point,
1538   //                      and that _point is active
1539   //
1540   modifier activePointOwner(uint32 _point)
1541   {
1542     require( azimuth.isOwner(_point, msg.sender) &&
1543              azimuth.isActive(_point) );
1544     _;
1545   }
1546 
1547   //  activePointManager(): require that :msg.sender can manage _point,
1548   //                        and that _point is active
1549   //
1550   modifier activePointManager(uint32 _point)
1551   {
1552     require( azimuth.canManage(_point, msg.sender) &&
1553              azimuth.isActive(_point) );
1554     _;
1555   }
1556 }
1557 
1558 ////////////////////////////////////////////////////////////////////////////////
1559 //  Censures
1560 ////////////////////////////////////////////////////////////////////////////////
1561 
1562 //  Censures: simple reputation management
1563 //
1564 //    This contract allows stars and galaxies to assign a negative
1565 //    reputation (censure) to other points of the same or lower rank.
1566 //    These censures are not permanent, they can be forgiven.
1567 //
1568 //    Since Azimuth-based networks provide incentives for good behavior,
1569 //    making bad behavior the exception rather than the rule, this
1570 //    contract only provides registration of negative reputation.
1571 //
1572 contract Censures is ReadsAzimuth
1573 {
1574   //  Censured: :who got censured by :by
1575   //
1576   event Censured(uint16 indexed by, uint32 indexed who);
1577 
1578   //  Forgiven: :who is no longer censured by :by
1579   //
1580   event Forgiven(uint16 indexed by, uint32 indexed who);
1581 
1582   //  censuring: per point, the points they're censuring
1583   //
1584   mapping(uint16 => uint32[]) public censuring;
1585 
1586   //  censuredBy: per point, those who have censured them
1587   //
1588   mapping(uint32 => uint16[]) public censuredBy;
1589 
1590   //  censuringIndexes: per point per censure, (index + 1) in censures array
1591   //
1592   //    We delete censures by moving the last entry in the array to the
1593   //    newly emptied slot, which is (n - 1) where n is the value of
1594   //    indexes[point][censure].
1595   //
1596   mapping(uint16 => mapping(uint32 => uint256)) public censuringIndexes;
1597 
1598   //  censuredByIndexes: per censure per point, (index + 1) in censured array
1599   //
1600   //    see also explanation for indexes_censures above
1601   //
1602   mapping(uint32 => mapping(uint16 => uint256)) public censuredByIndexes;
1603 
1604   //  constructor(): register the azimuth contract
1605   //
1606   constructor(Azimuth _azimuth)
1607     ReadsAzimuth(_azimuth)
1608     public
1609   {
1610     //
1611   }
1612 
1613   //  getCensuringCount(): return length of array of censures made by _whose
1614   //
1615   function getCensuringCount(uint16 _whose)
1616     view
1617     public
1618     returns (uint256 count)
1619   {
1620     return censuring[_whose].length;
1621   }
1622 
1623   //  getCensuring(): return array of censures made by _whose
1624   //
1625   //    Note: only useful for clients, as Solidity does not currently
1626   //    support returning dynamic arrays.
1627   //
1628   function getCensuring(uint16 _whose)
1629     view
1630     public
1631     returns (uint32[] cens)
1632   {
1633     return censuring[_whose];
1634   }
1635 
1636   //  getCensuredByCount(): return length of array of censures made against _who
1637   //
1638   function getCensuredByCount(uint16 _who)
1639     view
1640     public
1641     returns (uint256 count)
1642   {
1643     return censuredBy[_who].length;
1644   }
1645 
1646   //  getCensuredBy(): return array of censures made against _who
1647   //
1648   //    Note: only useful for clients, as Solidity does not currently
1649   //    support returning dynamic arrays.
1650   //
1651   function getCensuredBy(uint16 _who)
1652     view
1653     public
1654     returns (uint16[] cens)
1655   {
1656     return censuredBy[_who];
1657   }
1658 
1659   //  censure(): register a censure of _who as _as
1660   //
1661   function censure(uint16 _as, uint32 _who)
1662     external
1663     activePointManager(_as)
1664   {
1665     require( //  can't censure self
1666              //
1667              (_as != _who) &&
1668              //
1669              //  must not haven censured _who already
1670              //
1671              (censuringIndexes[_as][_who] == 0) );
1672 
1673     //  only stars and galaxies may censure, and only galaxies may censure
1674     //  other galaxies. (enum gets smaller for higher point sizes)
1675     //  this function's signature makes sure planets cannot censure.
1676     //
1677     Azimuth.Size asSize = azimuth.getPointSize(_as);
1678     Azimuth.Size whoSize = azimuth.getPointSize(_who);
1679     require( whoSize >= asSize );
1680 
1681     //  update contract state with the new censure
1682     //
1683     censuring[_as].push(_who);
1684     censuringIndexes[_as][_who] = censuring[_as].length;
1685 
1686     //  and update the reverse lookup
1687     //
1688     censuredBy[_who].push(_as);
1689     censuredByIndexes[_who][_as] = censuredBy[_who].length;
1690 
1691     emit Censured(_as, _who);
1692   }
1693 
1694   //  forgive(): unregister a censure of _who as _as
1695   //
1696   function forgive(uint16 _as, uint32 _who)
1697     external
1698     activePointManager(_as)
1699   {
1700     //  below, we perform the same logic twice: once on the canonical data,
1701     //  and once on the reverse lookup
1702     //
1703     //  i: current index in _as's list of censures
1704     //  j: current index in _who's list of points that have censured it
1705     //
1706     uint256 i = censuringIndexes[_as][_who];
1707     uint256 j = censuredByIndexes[_who][_as];
1708 
1709     //  we store index + 1, because 0 is the eth default value
1710     //  can only delete an existing censure
1711     //
1712     require( (i > 0) && (j > 0) );
1713     i--;
1714     j--;
1715 
1716     //  copy last item in the list into the now-unused slot,
1717     //  making sure to update the :indexes_ references
1718     //
1719     uint32[] storage cens = censuring[_as];
1720     uint16[] storage cend = censuredBy[_who];
1721     uint256 lastCens = cens.length - 1;
1722     uint256 lastCend = cend.length - 1;
1723     uint32 movedCens = cens[lastCens];
1724     uint16 movedCend = cend[lastCend];
1725     cens[i] = movedCens;
1726     cend[j] = movedCend;
1727     censuringIndexes[_as][movedCens] = i + 1;
1728     censuredByIndexes[_who][movedCend] = j + 1;
1729 
1730     //  delete the last item
1731     //
1732     cens.length = lastCens;
1733     cend.length = lastCend;
1734     censuringIndexes[_as][_who] = 0;
1735     censuredByIndexes[_who][_as] = 0;
1736 
1737     emit Forgiven(_as, _who);
1738   }
1739 }