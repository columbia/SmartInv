1 //  the azimuth data store
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
74 ////////////////////////////////////////////////////////////////////////////////
75 //  Azimuth
76 ////////////////////////////////////////////////////////////////////////////////
77 
78 //  Azimuth: point state data contract
79 //
80 //    This contract is used for storing all data related to Azimuth points
81 //    and their ownership. Consider this contract the Azimuth ledger.
82 //
83 //    It also contains permissions data, which ties in to ERC721
84 //    functionality. Operators of an address are allowed to transfer
85 //    ownership of all points owned by their associated address
86 //    (ERC721's approveAll()). A transfer proxy is allowed to transfer
87 //    ownership of a single point (ERC721's approve()).
88 //    Separate from ERC721 are managers, assigned per point. They are
89 //    allowed to perform "low-impact" operations on the owner's points,
90 //    like configuring public keys and making escape requests.
91 //
92 //    Since data stores are difficult to upgrade, this contract contains
93 //    as little actual business logic as possible. Instead, the data stored
94 //    herein can only be modified by this contract's owner, which can be
95 //    changed and is thus upgradable/replaceable.
96 //
97 //    This contract will be owned by the Ecliptic contract.
98 //
99 contract Azimuth is Ownable
100 {
101 //
102 //  Events
103 //
104 
105   //  OwnerChanged: :point is now owned by :owner
106   //
107   event OwnerChanged(uint32 indexed point, address indexed owner);
108 
109   //  Activated: :point is now active
110   //
111   event Activated(uint32 indexed point);
112 
113   //  Spawned: :prefix has spawned :child
114   //
115   event Spawned(uint32 indexed prefix, uint32 indexed child);
116 
117   //  EscapeRequested: :point has requested a new :sponsor
118   //
119   event EscapeRequested(uint32 indexed point, uint32 indexed sponsor);
120 
121   //  EscapeCanceled: :point's :sponsor request was canceled or rejected
122   //
123   event EscapeCanceled(uint32 indexed point, uint32 indexed sponsor);
124 
125   //  EscapeAccepted: :point confirmed with a new :sponsor
126   //
127   event EscapeAccepted(uint32 indexed point, uint32 indexed sponsor);
128 
129   //  LostSponsor: :point's :sponsor is now refusing it service
130   //
131   event LostSponsor(uint32 indexed point, uint32 indexed sponsor);
132 
133   //  ChangedKeys: :point has new network public keys
134   //
135   event ChangedKeys( uint32 indexed point,
136                      bytes32 encryptionKey,
137                      bytes32 authenticationKey,
138                      uint32 cryptoSuiteVersion,
139                      uint32 keyRevisionNumber );
140 
141   //  BrokeContinuity: :point has a new continuity number, :number
142   //
143   event BrokeContinuity(uint32 indexed point, uint32 number);
144 
145   //  ChangedSpawnProxy: :spawnProxy can now spawn using :point
146   //
147   event ChangedSpawnProxy(uint32 indexed point, address indexed spawnProxy);
148 
149   //  ChangedTransferProxy: :transferProxy can now transfer ownership of :point
150   //
151   event ChangedTransferProxy( uint32 indexed point,
152                               address indexed transferProxy );
153 
154   //  ChangedManagementProxy: :managementProxy can now manage :point
155   //
156   event ChangedManagementProxy( uint32 indexed point,
157                                 address indexed managementProxy );
158 
159   //  ChangedVotingProxy: :votingProxy can now vote using :point
160   //
161   event ChangedVotingProxy(uint32 indexed point, address indexed votingProxy);
162 
163   //  ChangedDns: dnsDomains have been updated
164   //
165   event ChangedDns(string primary, string secondary, string tertiary);
166 
167 //
168 //  Structures
169 //
170 
171   //  Size: kinds of points registered on-chain
172   //
173   //    NOTE: the order matters, because of Solidity enum numbering
174   //
175   enum Size
176   {
177     Galaxy, // = 0
178     Star,   // = 1
179     Planet  // = 2
180   }
181 
182   //  Point: state of a point
183   //
184   //    While the ordering of the struct members is semantically chaotic,
185   //    they are ordered to tightly pack them into Ethereum's 32-byte storage
186   //    slots, which reduces gas costs for some function calls.
187   //    The comment ticks indicate assumed slot boundaries.
188   //
189   struct Point
190   {
191     //  encryptionKey: (curve25519) encryption public key, or 0 for none
192     //
193     bytes32 encryptionKey;
194   //
195     //  authenticationKey: (ed25519) authentication public key, or 0 for none
196     //
197     bytes32 authenticationKey;
198   //
199     //  spawned: for stars and galaxies, all :active children
200     //
201     uint32[] spawned;
202   //
203     //  hasSponsor: true if the sponsor still supports the point
204     //
205     bool hasSponsor;
206 
207     //  active: whether point can be linked
208     //
209     //    false: point belongs to prefix, cannot be configured or linked
210     //    true: point no longer belongs to prefix, can be configured and linked
211     //
212     bool active;
213 
214     //  escapeRequested: true if the point has requested to change sponsors
215     //
216     bool escapeRequested;
217 
218     //  sponsor: the point that supports this one on the network, or,
219     //           if :hasSponsor is false, the last point that supported it.
220     //           (by default, the point's half-width prefix)
221     //
222     uint32 sponsor;
223 
224     //  escapeRequestedTo: if :escapeRequested is true, new sponsor requested
225     //
226     uint32 escapeRequestedTo;
227 
228     //  cryptoSuiteVersion: version of the crypto suite used for the pubkeys
229     //
230     uint32 cryptoSuiteVersion;
231 
232     //  keyRevisionNumber: incremented every time the public keys change
233     //
234     uint32 keyRevisionNumber;
235 
236     //  continuityNumber: incremented to indicate network-side state loss
237     //
238     uint32 continuityNumber;
239   }
240 
241   //  Deed: permissions for a point
242   //
243   struct Deed
244   {
245     //  owner: address that owns this point
246     //
247     address owner;
248 
249     //  managementProxy: 0, or another address with the right to perform
250     //                   low-impact, managerial operations on this point
251     //
252     address managementProxy;
253 
254     //  spawnProxy: 0, or another address with the right to spawn children
255     //              of this point
256     //
257     address spawnProxy;
258 
259     //  votingProxy: 0, or another address with the right to vote as this point
260     //
261     address votingProxy;
262 
263     //  transferProxy: 0, or another address with the right to transfer
264     //                 ownership of this point
265     //
266     address transferProxy;
267   }
268 
269 //
270 //  General state
271 //
272 
273   //  points: per point, general network-relevant point state
274   //
275   mapping(uint32 => Point) public points;
276 
277   //  rights: per point, on-chain ownership and permissions
278   //
279   mapping(uint32 => Deed) public rights;
280 
281   //  operators: per owner, per address, has the right to transfer ownership
282   //             of all the owner's points (ERC721)
283   //
284   mapping(address => mapping(address => bool)) public operators;
285 
286   //  dnsDomains: base domains for contacting galaxies
287   //
288   //    dnsDomains[0] is primary, the others are used as fallbacks
289   //
290   string[3] public dnsDomains;
291 
292 //
293 //  Lookups
294 //
295 
296   //  sponsoring: per point, the points they are sponsoring
297   //
298   mapping(uint32 => uint32[]) public sponsoring;
299 
300   //  sponsoringIndexes: per point, per point, (index + 1) in
301   //                     the sponsoring array
302   //
303   mapping(uint32 => mapping(uint32 => uint256)) public sponsoringIndexes;
304 
305   //  escapeRequests: per point, the points they have open escape requests from
306   //
307   mapping(uint32 => uint32[]) public escapeRequests;
308 
309   //  escapeRequestsIndexes: per point, per point, (index + 1) in
310   //                         the escapeRequests array
311   //
312   mapping(uint32 => mapping(uint32 => uint256)) public escapeRequestsIndexes;
313 
314   //  pointsOwnedBy: per address, the points they own
315   //
316   mapping(address => uint32[]) public pointsOwnedBy;
317 
318   //  pointOwnerIndexes: per owner, per point, (index + 1) in
319   //                     the pointsOwnedBy array
320   //
321   //    We delete owners by moving the last entry in the array to the
322   //    newly emptied slot, which is (n - 1) where n is the value of
323   //    pointOwnerIndexes[owner][point].
324   //
325   mapping(address => mapping(uint32 => uint256)) public pointOwnerIndexes;
326 
327   //  managerFor: per address, the points they are the management proxy for
328   //
329   mapping(address => uint32[]) public managerFor;
330 
331   //  managerForIndexes: per address, per point, (index + 1) in
332   //                     the managerFor array
333   //
334   mapping(address => mapping(uint32 => uint256)) public managerForIndexes;
335 
336   //  spawningFor: per address, the points they can spawn with
337   //
338   mapping(address => uint32[]) public spawningFor;
339 
340   //  spawningForIndexes: per address, per point, (index + 1) in
341   //                      the spawningFor array
342   //
343   mapping(address => mapping(uint32 => uint256)) public spawningForIndexes;
344 
345   //  votingFor: per address, the points they can vote with
346   //
347   mapping(address => uint32[]) public votingFor;
348 
349   //  votingForIndexes: per address, per point, (index + 1) in
350   //                    the votingFor array
351   //
352   mapping(address => mapping(uint32 => uint256)) public votingForIndexes;
353 
354   //  transferringFor: per address, the points they can transfer
355   //
356   mapping(address => uint32[]) public transferringFor;
357 
358   //  transferringForIndexes: per address, per point, (index + 1) in
359   //                          the transferringFor array
360   //
361   mapping(address => mapping(uint32 => uint256)) public transferringForIndexes;
362 
363 //
364 //  Logic
365 //
366 
367   //  constructor(): configure default dns domains
368   //
369   constructor()
370     public
371   {
372     setDnsDomains("example.com", "example.com", "example.com");
373   }
374 
375   //  setDnsDomains(): set the base domains used for contacting galaxies
376   //
377   //    Note: since a string is really just a byte[], and Solidity can't
378   //    work with two-dimensional arrays yet, we pass in the three
379   //    domains as individual strings.
380   //
381   function setDnsDomains(string _primary, string _secondary, string _tertiary)
382     onlyOwner
383     public
384   {
385     dnsDomains[0] = _primary;
386     dnsDomains[1] = _secondary;
387     dnsDomains[2] = _tertiary;
388     emit ChangedDns(_primary, _secondary, _tertiary);
389   }
390 
391   //
392   //  Point reading
393   //
394 
395     //  isActive(): return true if _point is active
396     //
397     function isActive(uint32 _point)
398       view
399       external
400       returns (bool equals)
401     {
402       return points[_point].active;
403     }
404 
405     //  getKeys(): returns the public keys and their details, as currently
406     //             registered for _point
407     //
408     function getKeys(uint32 _point)
409       view
410       external
411       returns (bytes32 crypt, bytes32 auth, uint32 suite, uint32 revision)
412     {
413       Point storage point = points[_point];
414       return (point.encryptionKey,
415               point.authenticationKey,
416               point.cryptoSuiteVersion,
417               point.keyRevisionNumber);
418     }
419 
420     //  getKeyRevisionNumber(): gets the revision number of _point's current
421     //                          public keys
422     //
423     function getKeyRevisionNumber(uint32 _point)
424       view
425       external
426       returns (uint32 revision)
427     {
428       return points[_point].keyRevisionNumber;
429     }
430 
431     //  hasBeenLinked(): returns true if the point has ever been assigned keys
432     //
433     function hasBeenLinked(uint32 _point)
434       view
435       external
436       returns (bool result)
437     {
438       return ( points[_point].keyRevisionNumber > 0 );
439     }
440 
441     //  isLive(): returns true if _point currently has keys properly configured
442     //
443     function isLive(uint32 _point)
444       view
445       external
446       returns (bool result)
447     {
448       Point storage point = points[_point];
449       return ( point.encryptionKey != 0 &&
450                point.authenticationKey != 0 &&
451                point.cryptoSuiteVersion != 0 );
452     }
453 
454     //  getContinuityNumber(): returns _point's current continuity number
455     //
456     function getContinuityNumber(uint32 _point)
457       view
458       external
459       returns (uint32 continuityNumber)
460     {
461       return points[_point].continuityNumber;
462     }
463 
464     //  getSpawnCount(): return the number of children spawned by _point
465     //
466     function getSpawnCount(uint32 _point)
467       view
468       external
469       returns (uint32 spawnCount)
470     {
471       uint256 len = points[_point].spawned.length;
472       assert(len < 2**32);
473       return uint32(len);
474     }
475 
476     //  getSpawned(): return array of points created under _point
477     //
478     //    Note: only useful for clients, as Solidity does not currently
479     //    support returning dynamic arrays.
480     //
481     function getSpawned(uint32 _point)
482       view
483       external
484       returns (uint32[] spawned)
485     {
486       return points[_point].spawned;
487     }
488 
489     //  hasSponsor(): returns true if _point's sponsor is providing it service
490     //
491     function hasSponsor(uint32 _point)
492       view
493       external
494       returns (bool has)
495     {
496       return points[_point].hasSponsor;
497     }
498 
499     //  getSponsor(): returns _point's current (or most recent) sponsor
500     //
501     function getSponsor(uint32 _point)
502       view
503       external
504       returns (uint32 sponsor)
505     {
506       return points[_point].sponsor;
507     }
508 
509     //  isSponsor(): returns true if _sponsor is currently providing service
510     //               to _point
511     //
512     function isSponsor(uint32 _point, uint32 _sponsor)
513       view
514       external
515       returns (bool result)
516     {
517       Point storage point = points[_point];
518       return ( point.hasSponsor &&
519                (point.sponsor == _sponsor) );
520     }
521 
522     //  getSponsoringCount(): returns the number of points _sponsor is
523     //                        providing service to
524     //
525     function getSponsoringCount(uint32 _sponsor)
526       view
527       external
528       returns (uint256 count)
529     {
530       return sponsoring[_sponsor].length;
531     }
532 
533     //  getSponsoring(): returns a list of points _sponsor is providing
534     //                   service to
535     //
536     //    Note: only useful for clients, as Solidity does not currently
537     //    support returning dynamic arrays.
538     //
539     function getSponsoring(uint32 _sponsor)
540       view
541       external
542       returns (uint32[] sponsees)
543     {
544       return sponsoring[_sponsor];
545     }
546 
547     //  escaping
548 
549     //  isEscaping(): returns true if _point has an outstanding escape request
550     //
551     function isEscaping(uint32 _point)
552       view
553       external
554       returns (bool escaping)
555     {
556       return points[_point].escapeRequested;
557     }
558 
559     //  getEscapeRequest(): returns _point's current escape request
560     //
561     //    the returned escape request is only valid as long as isEscaping()
562     //    returns true
563     //
564     function getEscapeRequest(uint32 _point)
565       view
566       external
567       returns (uint32 escape)
568     {
569       return points[_point].escapeRequestedTo;
570     }
571 
572     //  isRequestingEscapeTo(): returns true if _point has an outstanding
573     //                          escape request targetting _sponsor
574     //
575     function isRequestingEscapeTo(uint32 _point, uint32 _sponsor)
576       view
577       public
578       returns (bool equals)
579     {
580       Point storage point = points[_point];
581       return (point.escapeRequested && (point.escapeRequestedTo == _sponsor));
582     }
583 
584     //  getEscapeRequestsCount(): returns the number of points _sponsor
585     //                            is providing service to
586     //
587     function getEscapeRequestsCount(uint32 _sponsor)
588       view
589       external
590       returns (uint256 count)
591     {
592       return escapeRequests[_sponsor].length;
593     }
594 
595     //  getEscapeRequests(): get the points _sponsor has received escape
596     //                       requests from
597     //
598     //    Note: only useful for clients, as Solidity does not currently
599     //    support returning dynamic arrays.
600     //
601     function getEscapeRequests(uint32 _sponsor)
602       view
603       external
604       returns (uint32[] requests)
605     {
606       return escapeRequests[_sponsor];
607     }
608 
609   //
610   //  Point writing
611   //
612 
613     //  activatePoint(): activate a point, register it as spawned by its prefix
614     //
615     function activatePoint(uint32 _point)
616       onlyOwner
617       external
618     {
619       //  make a point active, setting its sponsor to its prefix
620       //
621       Point storage point = points[_point];
622       require(!point.active);
623       point.active = true;
624       registerSponsor(_point, true, getPrefix(_point));
625       emit Activated(_point);
626     }
627 
628     //  setKeys(): set network public keys of _point to _encryptionKey and
629     //            _authenticationKey, with the specified _cryptoSuiteVersion
630     //
631     function setKeys(uint32 _point,
632                      bytes32 _encryptionKey,
633                      bytes32 _authenticationKey,
634                      uint32 _cryptoSuiteVersion)
635       onlyOwner
636       external
637     {
638       Point storage point = points[_point];
639       if ( point.encryptionKey == _encryptionKey &&
640            point.authenticationKey == _authenticationKey &&
641            point.cryptoSuiteVersion == _cryptoSuiteVersion )
642       {
643         return;
644       }
645 
646       point.encryptionKey = _encryptionKey;
647       point.authenticationKey = _authenticationKey;
648       point.cryptoSuiteVersion = _cryptoSuiteVersion;
649       point.keyRevisionNumber++;
650 
651       emit ChangedKeys(_point,
652                        _encryptionKey,
653                        _authenticationKey,
654                        _cryptoSuiteVersion,
655                        point.keyRevisionNumber);
656     }
657 
658     //  incrementContinuityNumber(): break continuity for _point
659     //
660     function incrementContinuityNumber(uint32 _point)
661       onlyOwner
662       external
663     {
664       Point storage point = points[_point];
665       point.continuityNumber++;
666       emit BrokeContinuity(_point, point.continuityNumber);
667     }
668 
669     //  registerSpawn(): add a point to its prefix's list of spawned points
670     //
671     function registerSpawned(uint32 _point)
672       onlyOwner
673       external
674     {
675       //  if a point is its own prefix (a galaxy) then don't register it
676       //
677       uint32 prefix = getPrefix(_point);
678       if (prefix == _point)
679       {
680         return;
681       }
682 
683       //  register a new spawned point for the prefix
684       //
685       points[prefix].spawned.push(_point);
686       emit Spawned(prefix, _point);
687     }
688 
689     //  loseSponsor(): indicates that _point's sponsor is no longer providing
690     //                 it service
691     //
692     function loseSponsor(uint32 _point)
693       onlyOwner
694       external
695     {
696       Point storage point = points[_point];
697       if (!point.hasSponsor)
698       {
699         return;
700       }
701       registerSponsor(_point, false, point.sponsor);
702       emit LostSponsor(_point, point.sponsor);
703     }
704 
705     //  setEscapeRequest(): for _point, start an escape request to _sponsor
706     //
707     function setEscapeRequest(uint32 _point, uint32 _sponsor)
708       onlyOwner
709       external
710     {
711       if (isRequestingEscapeTo(_point, _sponsor))
712       {
713         return;
714       }
715       registerEscapeRequest(_point, true, _sponsor);
716       emit EscapeRequested(_point, _sponsor);
717     }
718 
719     //  cancelEscape(): for _point, stop the current escape request, if any
720     //
721     function cancelEscape(uint32 _point)
722       onlyOwner
723       external
724     {
725       Point storage point = points[_point];
726       if (!point.escapeRequested)
727       {
728         return;
729       }
730       uint32 request = point.escapeRequestedTo;
731       registerEscapeRequest(_point, false, 0);
732       emit EscapeCanceled(_point, request);
733     }
734 
735     //  doEscape(): perform the requested escape
736     //
737     function doEscape(uint32 _point)
738       onlyOwner
739       external
740     {
741       Point storage point = points[_point];
742       require(point.escapeRequested);
743       registerSponsor(_point, true, point.escapeRequestedTo);
744       registerEscapeRequest(_point, false, 0);
745       emit EscapeAccepted(_point, point.sponsor);
746     }
747 
748   //
749   //  Point utils
750   //
751 
752     //  getPrefix(): compute prefix ("parent") of _point
753     //
754     function getPrefix(uint32 _point)
755       pure
756       public
757       returns (uint16 prefix)
758     {
759       if (_point < 0x10000)
760       {
761         return uint16(_point % 0x100);
762       }
763       return uint16(_point % 0x10000);
764     }
765 
766     //  getPointSize(): return the size of _point
767     //
768     function getPointSize(uint32 _point)
769       external
770       pure
771       returns (Size _size)
772     {
773       if (_point < 0x100) return Size.Galaxy;
774       if (_point < 0x10000) return Size.Star;
775       return Size.Planet;
776     }
777 
778     //  internal use
779 
780     //  registerSponsor(): set the sponsorship state of _point and update the
781     //                     reverse lookup for sponsors
782     //
783     function registerSponsor(uint32 _point, bool _hasSponsor, uint32 _sponsor)
784       internal
785     {
786       Point storage point = points[_point];
787       bool had = point.hasSponsor;
788       uint32 prev = point.sponsor;
789 
790       //  if we didn't have a sponsor, and won't get one,
791       //  or if we get the sponsor we already have,
792       //  nothing will change, so jump out early.
793       //
794       if ( (!had && !_hasSponsor) ||
795            (had && _hasSponsor && prev == _sponsor) )
796       {
797         return;
798       }
799 
800       //  if the point used to have a different sponsor, do some gymnastics
801       //  to keep the reverse lookup gapless.  delete the point from the old
802       //  sponsor's list, then fill that gap with the list tail.
803       //
804       if (had)
805       {
806         //  i: current index in previous sponsor's list of sponsored points
807         //
808         uint256 i = sponsoringIndexes[prev][_point];
809 
810         //  we store index + 1, because 0 is the solidity default value
811         //
812         assert(i > 0);
813         i--;
814 
815         //  copy the last item in the list into the now-unused slot,
816         //  making sure to update its :sponsoringIndexes reference
817         //
818         uint32[] storage prevSponsoring = sponsoring[prev];
819         uint256 last = prevSponsoring.length - 1;
820         uint32 moved = prevSponsoring[last];
821         prevSponsoring[i] = moved;
822         sponsoringIndexes[prev][moved] = i + 1;
823 
824         //  delete the last item
825         //
826         delete(prevSponsoring[last]);
827         prevSponsoring.length = last;
828         sponsoringIndexes[prev][_point] = 0;
829       }
830 
831       if (_hasSponsor)
832       {
833         uint32[] storage newSponsoring = sponsoring[_sponsor];
834         newSponsoring.push(_point);
835         sponsoringIndexes[_sponsor][_point] = newSponsoring.length;
836       }
837 
838       point.sponsor = _sponsor;
839       point.hasSponsor = _hasSponsor;
840     }
841 
842     //  registerEscapeRequest(): set the escape state of _point and update the
843     //                           reverse lookup for sponsors
844     //
845     function registerEscapeRequest( uint32 _point,
846                                     bool _isEscaping, uint32 _sponsor )
847       internal
848     {
849       Point storage point = points[_point];
850       bool was = point.escapeRequested;
851       uint32 prev = point.escapeRequestedTo;
852 
853       //  if we weren't escaping, and won't be,
854       //  or if we were escaping, and the new target is the same,
855       //  nothing will change, so jump out early.
856       //
857       if ( (!was && !_isEscaping) ||
858            (was && _isEscaping && prev == _sponsor) )
859       {
860         return;
861       }
862 
863       //  if the point used to have a different request, do some gymnastics
864       //  to keep the reverse lookup gapless.  delete the point from the old
865       //  sponsor's list, then fill that gap with the list tail.
866       //
867       if (was)
868       {
869         //  i: current index in previous sponsor's list of sponsored points
870         //
871         uint256 i = escapeRequestsIndexes[prev][_point];
872 
873         //  we store index + 1, because 0 is the solidity default value
874         //
875         assert(i > 0);
876         i--;
877 
878         //  copy the last item in the list into the now-unused slot,
879         //  making sure to update its :escapeRequestsIndexes reference
880         //
881         uint32[] storage prevRequests = escapeRequests[prev];
882         uint256 last = prevRequests.length - 1;
883         uint32 moved = prevRequests[last];
884         prevRequests[i] = moved;
885         escapeRequestsIndexes[prev][moved] = i + 1;
886 
887         //  delete the last item
888         //
889         delete(prevRequests[last]);
890         prevRequests.length = last;
891         escapeRequestsIndexes[prev][_point] = 0;
892       }
893 
894       if (_isEscaping)
895       {
896         uint32[] storage newRequests = escapeRequests[_sponsor];
897         newRequests.push(_point);
898         escapeRequestsIndexes[_sponsor][_point] = newRequests.length;
899       }
900 
901       point.escapeRequestedTo = _sponsor;
902       point.escapeRequested = _isEscaping;
903     }
904 
905   //
906   //  Deed reading
907   //
908 
909     //  owner
910 
911     //  getOwner(): return owner of _point
912     //
913     function getOwner(uint32 _point)
914       view
915       external
916       returns (address owner)
917     {
918       return rights[_point].owner;
919     }
920 
921     //  isOwner(): true if _point is owned by _address
922     //
923     function isOwner(uint32 _point, address _address)
924       view
925       external
926       returns (bool result)
927     {
928       return (rights[_point].owner == _address);
929     }
930 
931     //  getOwnedPointCount(): return length of array of points that _whose owns
932     //
933     function getOwnedPointCount(address _whose)
934       view
935       external
936       returns (uint256 count)
937     {
938       return pointsOwnedBy[_whose].length;
939     }
940 
941     //  getOwnedPoints(): return array of points that _whose owns
942     //
943     //    Note: only useful for clients, as Solidity does not currently
944     //    support returning dynamic arrays.
945     //
946     function getOwnedPoints(address _whose)
947       view
948       external
949       returns (uint32[] ownedPoints)
950     {
951       return pointsOwnedBy[_whose];
952     }
953 
954     //  getOwnedPointAtIndex(): get point at _index from array of points that
955     //                         _whose owns
956     //
957     function getOwnedPointAtIndex(address _whose, uint256 _index)
958       view
959       external
960       returns (uint32 point)
961     {
962       uint32[] storage owned = pointsOwnedBy[_whose];
963       require(_index < owned.length);
964       return owned[_index];
965     }
966 
967     //  management proxy
968 
969     //  getManagementProxy(): returns _point's current management proxy
970     //
971     function getManagementProxy(uint32 _point)
972       view
973       external
974       returns (address manager)
975     {
976       return rights[_point].managementProxy;
977     }
978 
979     //  isManagementProxy(): returns true if _proxy is _point's management proxy
980     //
981     function isManagementProxy(uint32 _point, address _proxy)
982       view
983       external
984       returns (bool result)
985     {
986       return (rights[_point].managementProxy == _proxy);
987     }
988 
989     //  canManage(): true if _who is the owner or manager of _point
990     //
991     function canManage(uint32 _point, address _who)
992       view
993       external
994       returns (bool result)
995     {
996       Deed storage deed = rights[_point];
997       return ( (0x0 != _who) &&
998                ( (_who == deed.owner) ||
999                  (_who == deed.managementProxy) ) );
1000     }
1001 
1002     //  getManagerForCount(): returns the amount of points _proxy can manage
1003     //
1004     function getManagerForCount(address _proxy)
1005       view
1006       external
1007       returns (uint256 count)
1008     {
1009       return managerFor[_proxy].length;
1010     }
1011 
1012     //  getManagerFor(): returns the points _proxy can manage
1013     //
1014     //    Note: only useful for clients, as Solidity does not currently
1015     //    support returning dynamic arrays.
1016     //
1017     function getManagerFor(address _proxy)
1018       view
1019       external
1020       returns (uint32[] mfor)
1021     {
1022       return managerFor[_proxy];
1023     }
1024 
1025     //  spawn proxy
1026 
1027     //  getSpawnProxy(): returns _point's current spawn proxy
1028     //
1029     function getSpawnProxy(uint32 _point)
1030       view
1031       external
1032       returns (address spawnProxy)
1033     {
1034       return rights[_point].spawnProxy;
1035     }
1036 
1037     //  isSpawnProxy(): returns true if _proxy is _point's spawn proxy
1038     //
1039     function isSpawnProxy(uint32 _point, address _proxy)
1040       view
1041       external
1042       returns (bool result)
1043     {
1044       return (rights[_point].spawnProxy == _proxy);
1045     }
1046 
1047     //  canSpawnAs(): true if _who is the owner or spawn proxy of _point
1048     //
1049     function canSpawnAs(uint32 _point, address _who)
1050       view
1051       external
1052       returns (bool result)
1053     {
1054       Deed storage deed = rights[_point];
1055       return ( (0x0 != _who) &&
1056                ( (_who == deed.owner) ||
1057                  (_who == deed.spawnProxy) ) );
1058     }
1059 
1060     //  getSpawningForCount(): returns the amount of points _proxy
1061     //                         can spawn with
1062     //
1063     function getSpawningForCount(address _proxy)
1064       view
1065       external
1066       returns (uint256 count)
1067     {
1068       return spawningFor[_proxy].length;
1069     }
1070 
1071     //  getSpawningFor(): get the points _proxy can spawn with
1072     //
1073     //    Note: only useful for clients, as Solidity does not currently
1074     //    support returning dynamic arrays.
1075     //
1076     function getSpawningFor(address _proxy)
1077       view
1078       external
1079       returns (uint32[] sfor)
1080     {
1081       return spawningFor[_proxy];
1082     }
1083 
1084     //  voting proxy
1085 
1086     //  getVotingProxy(): returns _point's current voting proxy
1087     //
1088     function getVotingProxy(uint32 _point)
1089       view
1090       external
1091       returns (address voter)
1092     {
1093       return rights[_point].votingProxy;
1094     }
1095 
1096     //  isVotingProxy(): returns true if _proxy is _point's voting proxy
1097     //
1098     function isVotingProxy(uint32 _point, address _proxy)
1099       view
1100       external
1101       returns (bool result)
1102     {
1103       return (rights[_point].votingProxy == _proxy);
1104     }
1105 
1106     //  canVoteAs(): true if _who is the owner of _point,
1107     //               or the voting proxy of _point's owner
1108     //
1109     function canVoteAs(uint32 _point, address _who)
1110       view
1111       external
1112       returns (bool result)
1113     {
1114       Deed storage deed = rights[_point];
1115       return ( (0x0 != _who) &&
1116                ( (_who == deed.owner) ||
1117                  (_who == deed.votingProxy) ) );
1118     }
1119 
1120     //  getVotingForCount(): returns the amount of points _proxy can vote as
1121     //
1122     function getVotingForCount(address _proxy)
1123       view
1124       external
1125       returns (uint256 count)
1126     {
1127       return votingFor[_proxy].length;
1128     }
1129 
1130     //  getVotingFor(): returns the points _proxy can vote as
1131     //
1132     //    Note: only useful for clients, as Solidity does not currently
1133     //    support returning dynamic arrays.
1134     //
1135     function getVotingFor(address _proxy)
1136       view
1137       external
1138       returns (uint32[] vfor)
1139     {
1140       return votingFor[_proxy];
1141     }
1142 
1143     //  transfer proxy
1144 
1145     //  getTransferProxy(): returns _point's current transfer proxy
1146     //
1147     function getTransferProxy(uint32 _point)
1148       view
1149       external
1150       returns (address transferProxy)
1151     {
1152       return rights[_point].transferProxy;
1153     }
1154 
1155     //  isTransferProxy(): returns true if _proxy is _point's transfer proxy
1156     //
1157     function isTransferProxy(uint32 _point, address _proxy)
1158       view
1159       external
1160       returns (bool result)
1161     {
1162       return (rights[_point].transferProxy == _proxy);
1163     }
1164 
1165     //  canTransfer(): true if _who is the owner or transfer proxy of _point,
1166     //                 or is an operator for _point's current owner
1167     //
1168     function canTransfer(uint32 _point, address _who)
1169       view
1170       external
1171       returns (bool result)
1172     {
1173       Deed storage deed = rights[_point];
1174       return ( (0x0 != _who) &&
1175                ( (_who == deed.owner) ||
1176                  (_who == deed.transferProxy) ||
1177                  operators[deed.owner][_who] ) );
1178     }
1179 
1180     //  getTransferringForCount(): returns the amount of points _proxy
1181     //                             can transfer
1182     //
1183     function getTransferringForCount(address _proxy)
1184       view
1185       external
1186       returns (uint256 count)
1187     {
1188       return transferringFor[_proxy].length;
1189     }
1190 
1191     //  getTransferringFor(): get the points _proxy can transfer
1192     //
1193     //    Note: only useful for clients, as Solidity does not currently
1194     //    support returning dynamic arrays.
1195     //
1196     function getTransferringFor(address _proxy)
1197       view
1198       external
1199       returns (uint32[] tfor)
1200     {
1201       return transferringFor[_proxy];
1202     }
1203 
1204     //  isOperator(): returns true if _operator is allowed to transfer
1205     //                ownership of _owner's points
1206     //
1207     function isOperator(address _owner, address _operator)
1208       view
1209       external
1210       returns (bool result)
1211     {
1212       return operators[_owner][_operator];
1213     }
1214 
1215   //
1216   //  Deed writing
1217   //
1218 
1219     //  setOwner(): set owner of _point to _owner
1220     //
1221     //    Note: setOwner() only implements the minimal data storage
1222     //    logic for a transfer; the full transfer is implemented in
1223     //    Ecliptic.
1224     //
1225     //    Note: _owner must not be the zero address.
1226     //
1227     function setOwner(uint32 _point, address _owner)
1228       onlyOwner
1229       external
1230     {
1231       //  prevent burning of points by making zero the owner
1232       //
1233       require(0x0 != _owner);
1234 
1235       //  prev: previous owner, if any
1236       //
1237       address prev = rights[_point].owner;
1238 
1239       if (prev == _owner)
1240       {
1241         return;
1242       }
1243 
1244       //  if the point used to have a different owner, do some gymnastics to
1245       //  keep the list of owned points gapless.  delete this point from the
1246       //  list, then fill that gap with the list tail.
1247       //
1248       if (0x0 != prev)
1249       {
1250         //  i: current index in previous owner's list of owned points
1251         //
1252         uint256 i = pointOwnerIndexes[prev][_point];
1253 
1254         //  we store index + 1, because 0 is the solidity default value
1255         //
1256         assert(i > 0);
1257         i--;
1258 
1259         //  copy the last item in the list into the now-unused slot,
1260         //  making sure to update its :pointOwnerIndexes reference
1261         //
1262         uint32[] storage owner = pointsOwnedBy[prev];
1263         uint256 last = owner.length - 1;
1264         uint32 moved = owner[last];
1265         owner[i] = moved;
1266         pointOwnerIndexes[prev][moved] = i + 1;
1267 
1268         //  delete the last item
1269         //
1270         delete(owner[last]);
1271         owner.length = last;
1272         pointOwnerIndexes[prev][_point] = 0;
1273       }
1274 
1275       //  update the owner list and the owner's index list
1276       //
1277       rights[_point].owner = _owner;
1278       pointsOwnedBy[_owner].push(_point);
1279       pointOwnerIndexes[_owner][_point] = pointsOwnedBy[_owner].length;
1280       emit OwnerChanged(_point, _owner);
1281     }
1282 
1283     //  setManagementProxy(): makes _proxy _point's management proxy
1284     //
1285     function setManagementProxy(uint32 _point, address _proxy)
1286       onlyOwner
1287       external
1288     {
1289       Deed storage deed = rights[_point];
1290       address prev = deed.managementProxy;
1291       if (prev == _proxy)
1292       {
1293         return;
1294       }
1295 
1296       //  if the point used to have a different manager, do some gymnastics
1297       //  to keep the reverse lookup gapless.  delete the point from the
1298       //  old manager's list, then fill that gap with the list tail.
1299       //
1300       if (0x0 != prev)
1301       {
1302         //  i: current index in previous manager's list of managed points
1303         //
1304         uint256 i = managerForIndexes[prev][_point];
1305 
1306         //  we store index + 1, because 0 is the solidity default value
1307         //
1308         assert(i > 0);
1309         i--;
1310 
1311         //  copy the last item in the list into the now-unused slot,
1312         //  making sure to update its :managerForIndexes reference
1313         //
1314         uint32[] storage prevMfor = managerFor[prev];
1315         uint256 last = prevMfor.length - 1;
1316         uint32 moved = prevMfor[last];
1317         prevMfor[i] = moved;
1318         managerForIndexes[prev][moved] = i + 1;
1319 
1320         //  delete the last item
1321         //
1322         delete(prevMfor[last]);
1323         prevMfor.length = last;
1324         managerForIndexes[prev][_point] = 0;
1325       }
1326 
1327       if (0x0 != _proxy)
1328       {
1329         uint32[] storage mfor = managerFor[_proxy];
1330         mfor.push(_point);
1331         managerForIndexes[_proxy][_point] = mfor.length;
1332       }
1333 
1334       deed.managementProxy = _proxy;
1335       emit ChangedManagementProxy(_point, _proxy);
1336     }
1337 
1338     //  setSpawnProxy(): makes _proxy _point's spawn proxy
1339     //
1340     function setSpawnProxy(uint32 _point, address _proxy)
1341       onlyOwner
1342       external
1343     {
1344       Deed storage deed = rights[_point];
1345       address prev = deed.spawnProxy;
1346       if (prev == _proxy)
1347       {
1348         return;
1349       }
1350 
1351       //  if the point used to have a different spawn proxy, do some
1352       //  gymnastics to keep the reverse lookup gapless.  delete the point
1353       //  from the old proxy's list, then fill that gap with the list tail.
1354       //
1355       if (0x0 != prev)
1356       {
1357         //  i: current index in previous proxy's list of spawning points
1358         //
1359         uint256 i = spawningForIndexes[prev][_point];
1360 
1361         //  we store index + 1, because 0 is the solidity default value
1362         //
1363         assert(i > 0);
1364         i--;
1365 
1366         //  copy the last item in the list into the now-unused slot,
1367         //  making sure to update its :spawningForIndexes reference
1368         //
1369         uint32[] storage prevSfor = spawningFor[prev];
1370         uint256 last = prevSfor.length - 1;
1371         uint32 moved = prevSfor[last];
1372         prevSfor[i] = moved;
1373         spawningForIndexes[prev][moved] = i + 1;
1374 
1375         //  delete the last item
1376         //
1377         delete(prevSfor[last]);
1378         prevSfor.length = last;
1379         spawningForIndexes[prev][_point] = 0;
1380       }
1381 
1382       if (0x0 != _proxy)
1383       {
1384         uint32[] storage sfor = spawningFor[_proxy];
1385         sfor.push(_point);
1386         spawningForIndexes[_proxy][_point] = sfor.length;
1387       }
1388 
1389       deed.spawnProxy = _proxy;
1390       emit ChangedSpawnProxy(_point, _proxy);
1391     }
1392 
1393     //  setVotingProxy(): makes _proxy _point's voting proxy
1394     //
1395     function setVotingProxy(uint32 _point, address _proxy)
1396       onlyOwner
1397       external
1398     {
1399       Deed storage deed = rights[_point];
1400       address prev = deed.votingProxy;
1401       if (prev == _proxy)
1402       {
1403         return;
1404       }
1405 
1406       //  if the point used to have a different voter, do some gymnastics
1407       //  to keep the reverse lookup gapless.  delete the point from the
1408       //  old voter's list, then fill that gap with the list tail.
1409       //
1410       if (0x0 != prev)
1411       {
1412         //  i: current index in previous voter's list of points it was
1413         //     voting for
1414         //
1415         uint256 i = votingForIndexes[prev][_point];
1416 
1417         //  we store index + 1, because 0 is the solidity default value
1418         //
1419         assert(i > 0);
1420         i--;
1421 
1422         //  copy the last item in the list into the now-unused slot,
1423         //  making sure to update its :votingForIndexes reference
1424         //
1425         uint32[] storage prevVfor = votingFor[prev];
1426         uint256 last = prevVfor.length - 1;
1427         uint32 moved = prevVfor[last];
1428         prevVfor[i] = moved;
1429         votingForIndexes[prev][moved] = i + 1;
1430 
1431         //  delete the last item
1432         //
1433         delete(prevVfor[last]);
1434         prevVfor.length = last;
1435         votingForIndexes[prev][_point] = 0;
1436       }
1437 
1438       if (0x0 != _proxy)
1439       {
1440         uint32[] storage vfor = votingFor[_proxy];
1441         vfor.push(_point);
1442         votingForIndexes[_proxy][_point] = vfor.length;
1443       }
1444 
1445       deed.votingProxy = _proxy;
1446       emit ChangedVotingProxy(_point, _proxy);
1447     }
1448 
1449     //  setManagementProxy(): makes _proxy _point's transfer proxy
1450     //
1451     function setTransferProxy(uint32 _point, address _proxy)
1452       onlyOwner
1453       external
1454     {
1455       Deed storage deed = rights[_point];
1456       address prev = deed.transferProxy;
1457       if (prev == _proxy)
1458       {
1459         return;
1460       }
1461 
1462       //  if the point used to have a different transfer proxy, do some
1463       //  gymnastics to keep the reverse lookup gapless.  delete the point
1464       //  from the old proxy's list, then fill that gap with the list tail.
1465       //
1466       if (0x0 != prev)
1467       {
1468         //  i: current index in previous proxy's list of transferable points
1469         //
1470         uint256 i = transferringForIndexes[prev][_point];
1471 
1472         //  we store index + 1, because 0 is the solidity default value
1473         //
1474         assert(i > 0);
1475         i--;
1476 
1477         //  copy the last item in the list into the now-unused slot,
1478         //  making sure to update its :transferringForIndexes reference
1479         //
1480         uint32[] storage prevTfor = transferringFor[prev];
1481         uint256 last = prevTfor.length - 1;
1482         uint32 moved = prevTfor[last];
1483         prevTfor[i] = moved;
1484         transferringForIndexes[prev][moved] = i + 1;
1485 
1486         //  delete the last item
1487         //
1488         delete(prevTfor[last]);
1489         prevTfor.length = last;
1490         transferringForIndexes[prev][_point] = 0;
1491       }
1492 
1493       if (0x0 != _proxy)
1494       {
1495         uint32[] storage tfor = transferringFor[_proxy];
1496         tfor.push(_point);
1497         transferringForIndexes[_proxy][_point] = tfor.length;
1498       }
1499 
1500       deed.transferProxy = _proxy;
1501       emit ChangedTransferProxy(_point, _proxy);
1502     }
1503 
1504     //  setOperator(): dis/allow _operator to transfer ownership of all points
1505     //                 owned by _owner
1506     //
1507     //    operators are part of the ERC721 standard
1508     //
1509     function setOperator(address _owner, address _operator, bool _approved)
1510       onlyOwner
1511       external
1512     {
1513       operators[_owner][_operator] = _approved;
1514     }
1515 }