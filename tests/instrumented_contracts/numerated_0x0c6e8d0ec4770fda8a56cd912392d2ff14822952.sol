1 pragma solidity >=0.5.0 <0.6.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library Roles {
22     struct Role {
23         mapping (address => bool) bearer;
24     }
25 
26     /**
27      * @dev give an account access to this role
28      */
29     function add(Role storage role, address account) internal {
30         require(account != address(0));
31         require(!has(role, account));
32 
33         role.bearer[account] = true;
34     }
35 
36     /**
37      * @dev remove an account's access to this role
38      */
39     function remove(Role storage role, address account) internal {
40         require(account != address(0));
41         require(has(role, account));
42 
43         role.bearer[account] = false;
44     }
45 
46     /**
47      * @dev check if an account has this role
48      * @return bool
49      */
50     function has(Role storage role, address account) internal view returns (bool) {
51         require(account != address(0));
52         return role.bearer[account];
53     }
54 }
55 
56 contract PauserRole {
57     using Roles for Roles.Role;
58 
59     event PauserAdded(address indexed account);
60     event PauserRemoved(address indexed account);
61 
62     Roles.Role private _pausers;
63 
64     constructor () internal {
65         _addPauser(msg.sender);
66     }
67 
68     modifier onlyPauser() {
69         require(isPauser(msg.sender));
70         _;
71     }
72 
73     function isPauser(address account) public view returns (bool) {
74         return _pausers.has(account);
75     }
76 
77     function addPauser(address account) public onlyPauser {
78         _addPauser(account);
79     }
80 
81     function renouncePauser() public {
82         _removePauser(msg.sender);
83     }
84 
85     function _addPauser(address account) internal {
86         _pausers.add(account);
87         emit PauserAdded(account);
88     }
89 
90     function _removePauser(address account) internal {
91         _pausers.remove(account);
92         emit PauserRemoved(account);
93     }
94 }
95 
96 contract Pausable is PauserRole {
97     event Paused(address account);
98     event Unpaused(address account);
99 
100     bool private _paused;
101 
102     constructor () internal {
103         _paused = false;
104     }
105 
106     /**
107      * @return true if the contract is paused, false otherwise.
108      */
109     function paused() public view returns (bool) {
110         return _paused;
111     }
112 
113     /**
114      * @dev Modifier to make a function callable only when the contract is not paused.
115      */
116     modifier whenNotPaused() {
117         require(!_paused);
118         _;
119     }
120 
121     /**
122      * @dev Modifier to make a function callable only when the contract is paused.
123      */
124     modifier whenPaused() {
125         require(_paused);
126         _;
127     }
128 
129     /**
130      * @dev called by the owner to pause, triggers stopped state
131      */
132     function pause() public onlyPauser whenNotPaused {
133         _paused = true;
134         emit Paused(msg.sender);
135     }
136 
137     /**
138      * @dev called by the owner to unpause, returns to normal state
139      */
140     function unpause() public onlyPauser whenPaused {
141         _paused = false;
142         emit Unpaused(msg.sender);
143     }
144 }
145 
146 contract Ownable {
147     address private _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     /**
152      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153      * account.
154      */
155     constructor () internal {
156         _owner = msg.sender;
157         emit OwnershipTransferred(address(0), _owner);
158     }
159 
160     /**
161      * @return the address of the owner.
162      */
163     function owner() public view returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         require(isOwner());
172         _;
173     }
174 
175     /**
176      * @return true if `msg.sender` is the owner of the contract.
177      */
178     function isOwner() public view returns (bool) {
179         return msg.sender == _owner;
180     }
181 
182     /**
183      * @dev Allows the current owner to relinquish control of the contract.
184      * @notice Renouncing to ownership will leave the contract without an owner.
185      * It will not be possible to call the functions with the `onlyOwner`
186      * modifier anymore.
187      */
188     function renounceOwnership() public onlyOwner {
189         emit OwnershipTransferred(_owner, address(0));
190         _owner = address(0);
191     }
192 
193     /**
194      * @dev Allows the current owner to transfer control of the contract to a newOwner.
195      * @param newOwner The address to transfer ownership to.
196      */
197     function transferOwnership(address newOwner) public onlyOwner {
198         _transferOwnership(newOwner);
199     }
200 
201     /**
202      * @dev Transfers control of the contract to a newOwner.
203      * @param newOwner The address to transfer ownership to.
204      */
205     function _transferOwnership(address newOwner) internal {
206         require(newOwner != address(0));
207         emit OwnershipTransferred(_owner, newOwner);
208         _owner = newOwner;
209     }
210 }
211 
212 library BytesUtils {
213   function isZero(bytes memory b) internal pure returns (bool) {
214     if (b.length == 0) {
215       return true;
216     }
217     bytes memory zero = new bytes(b.length);
218     return keccak256(b) == keccak256(zero);
219   }
220 }
221 
222 library DnsUtils {
223   function isDomainName(bytes memory s) internal pure returns (bool) {
224     byte last = '.';
225     bool ok = false;
226     uint partlen = 0;
227 
228     for (uint i = 0; i < s.length; i++) {
229       byte c = s[i];
230       if (c >= 'a' && c <= 'z' || c == '_') {
231         ok = true;
232         partlen++;
233       } else if (c >= '0' && c <= '9') {
234         partlen++;
235       } else if (c == '-') {
236         // byte before dash cannot be dot.
237         if (last == '.') {
238           return false;
239         }
240         partlen++;
241       } else if (c == '.') {
242         // byte before dot cannot be dot, dash.
243         if (last == '.' || last == '-') {
244           return false;
245         }
246         if (partlen > 63 || partlen == 0) {
247           return false;
248         }
249         partlen = 0;
250       } else {
251         return false;
252       }
253       last = c;
254     }
255     if (last == '-' || partlen > 63) {
256       return false;
257     }
258     return ok;
259   }
260 }
261 
262 contract Marketplace is Ownable, Pausable {
263   using BytesUtils for bytes;
264   using DnsUtils for bytes;
265 
266   /**
267     Structures
268    */
269 
270   struct Service {
271     uint256 createTime;
272     address owner;
273     bytes sid;
274 
275     mapping(bytes32 => Version) versions; // version hash => Version
276     bytes32[] versionsList;
277 
278     Offer[] offers;
279 
280     mapping(address => Purchase) purchases; // purchaser's address => Purchase
281     address[] purchasesList;
282   }
283 
284   struct Purchase {
285     uint256 createTime;
286     uint expire;
287   }
288 
289   struct Version {
290     uint256 createTime;
291     bytes manifest;
292     bytes manifestProtocol;
293   }
294 
295   struct Offer {
296     uint256 createTime;
297     uint price;
298     uint duration;
299     bool active;
300   }
301 
302   /**
303     Constant
304    */
305 
306   uint constant INFINITY = ~uint256(0);
307   uint constant SID_MIN_LEN = 1;
308   uint constant SID_MAX_LEN = 63;
309 
310   /**
311     Errors
312   */
313 
314   string constant private ERR_ADDRESS_ZERO = "address is zero";
315 
316   string constant private ERR_SID_LEN = "sid must be between 1 and 63 characters";
317   string constant private ERR_SID_INVALID = "sid must be a valid dns name";
318 
319   string constant private ERR_SERVICE_EXIST = "service with given sid already exists";
320   string constant private ERR_SERVICE_NOT_EXIST = "service with given sid does not exist";
321   string constant private ERR_SERVICE_NOT_OWNER = "sender is not the service owner";
322 
323   string constant private ERR_VERSION_EXIST = "version with given hash already exists";
324   string constant private ERR_VERSION_MANIFEST_LEN = "version manifest must have at least 1 character";
325   string constant private ERR_VERSION_MANIFEST_PROTOCOL_LEN = "version manifest protocol must have at least 1 character";
326 
327   string constant private ERR_OFFER_NOT_EXIST = "offer dose not exist";
328   string constant private ERR_OFFER_NO_VERSION = "offer must be created with at least 1 version";
329   string constant private ERR_OFFER_NOT_ACTIVE = "offer must be active";
330   string constant private ERR_OFFER_DURATION_MIN = "offer duration must be greater than 0";
331 
332   string constant private ERR_PURCHASE_OWNER = "sender cannot purchase his own service";
333   string constant private ERR_PURCHASE_INFINITY = "service already purchase for infinity";
334   string constant private ERR_PURCHASE_TOKEN_BALANCE = "token balance must be greater to purchase the service";
335   string constant private ERR_PURCHASE_TOKEN_APPROVE = "sender must approve the marketplace to spend token";
336 
337   /**
338     State variables
339    */
340 
341   IERC20 public token;
342 
343   mapping(bytes32 => Service) public services; // service hashed sid => Service
344   bytes32[] public servicesList;
345 
346   mapping(bytes32 => bytes32) public versionHashToService; // version hash => service hashed sid
347 
348   /**
349     Constructor
350    */
351 
352   constructor(IERC20 _token) public {
353     token = _token;
354   }
355 
356   /**
357     Events
358    */
359 
360   event ServiceCreated(
361     bytes sid,
362     address indexed owner
363   );
364 
365   event ServiceOwnershipTransferred(
366     bytes sid,
367     address indexed previousOwner,
368     address indexed newOwner
369   );
370 
371   event ServiceVersionCreated(
372     bytes sid,
373     bytes32 indexed versionHash,
374     bytes manifest,
375     bytes manifestProtocol
376   );
377 
378   event ServiceOfferCreated(
379     bytes sid,
380     uint indexed offerIndex,
381     uint price,
382     uint duration
383   );
384 
385   event ServiceOfferDisabled(
386     bytes sid,
387     uint indexed offerIndex
388   );
389 
390   event ServicePurchased(
391     bytes sid,
392     uint indexed offerIndex,
393     address indexed purchaser,
394     uint price,
395     uint duration,
396     uint expire
397   );
398 
399   /**
400     Modifiers
401    */
402 
403   modifier whenAddressNotZero(address a) {
404     require(a != address(0), ERR_ADDRESS_ZERO);
405     _;
406   }
407 
408   modifier whenManifestNotEmpty(bytes memory manifest) {
409     require(!manifest.isZero(), ERR_VERSION_MANIFEST_LEN);
410     _;
411   }
412 
413   modifier whenManifestProtocolNotEmpty(bytes memory manifestProtocol) {
414     require(!manifestProtocol.isZero(), ERR_VERSION_MANIFEST_PROTOCOL_LEN);
415     _;
416   }
417 
418   modifier whenDurationNotZero(uint duration) {
419     require(duration > 0, ERR_OFFER_DURATION_MIN);
420     _;
421   }
422 
423   /**
424     Internals
425    */
426 
427   function _service(bytes memory sid)
428     internal view
429     returns (Service storage service, bytes32 sidHash)
430   {
431     sidHash = keccak256(sid);
432     require(_isServiceExist(sidHash), ERR_SERVICE_NOT_EXIST);
433     return (services[sidHash], sidHash);
434   }
435 
436   function _isServiceExist(bytes32 sidHash)
437     internal view
438     returns (bool exist)
439   {
440     return services[sidHash].owner != address(0);
441   }
442 
443   function _isServiceOwner(bytes32 sidHash, address owner)
444     internal view
445     returns (bool isOwner)
446   {
447     return services[sidHash].owner == owner;
448   }
449 
450   function _isServiceOfferExist(bytes32 sidHash, uint offerIndex)
451     internal view
452     returns (bool exist)
453   {
454     return offerIndex < services[sidHash].offers.length;
455   }
456 
457   function _isServicesPurchaseExist(bytes32 sidHash, address purchaser)
458     internal view
459     returns (bool exist)
460   {
461     return services[sidHash].purchases[purchaser].createTime > 0;
462   }
463 
464   /**
465     External and public functions
466    */
467 
468   function createService(bytes memory sid)
469     public
470     whenNotPaused
471   {
472     require(SID_MIN_LEN <= sid.length && sid.length <= SID_MAX_LEN, ERR_SID_LEN);
473     require(sid.isDomainName(), ERR_SID_INVALID);
474     bytes32 sidHash = keccak256(sid);
475     require(!_isServiceExist(sidHash), ERR_SERVICE_EXIST);
476     services[sidHash].owner = msg.sender;
477     services[sidHash].sid = sid;
478     services[sidHash].createTime = now;
479     servicesList.push(sidHash);
480     emit ServiceCreated(sid, msg.sender);
481   }
482 
483   function transferServiceOwnership(bytes calldata sid, address newOwner)
484     external
485     whenNotPaused
486     whenAddressNotZero(newOwner)
487   {
488     (Service storage service, bytes32 sidHash) = _service(sid);
489     require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);
490     emit ServiceOwnershipTransferred(sid, service.owner, newOwner);
491     service.owner = newOwner;
492   }
493 
494   function createServiceVersion(
495     bytes memory sid,
496     bytes memory manifest,
497     bytes memory manifestProtocol
498   )
499     public
500     whenNotPaused
501     whenManifestNotEmpty(manifest)
502     whenManifestProtocolNotEmpty(manifestProtocol)
503   {
504     (Service storage service, bytes32 sidHash) = _service(sid);
505     require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);
506     bytes32 versionHash = keccak256(abi.encodePacked(msg.sender, sid, manifest, manifestProtocol));
507     require(!isServiceVersionExist(versionHash), ERR_VERSION_EXIST);
508     Version storage version = service.versions[versionHash];
509     version.manifest = manifest;
510     version.manifestProtocol = manifestProtocol;
511     version.createTime = now;
512     services[sidHash].versionsList.push(versionHash);
513     versionHashToService[versionHash] = sidHash;
514     emit ServiceVersionCreated(sid, versionHash, manifest, manifestProtocol);
515   }
516 
517   function publishServiceVersion(
518     bytes calldata sid,
519     bytes calldata manifest,
520     bytes calldata manifestProtocol
521   )
522     external
523     whenNotPaused
524   {
525     if (!isServiceExist(sid)) {
526       createService(sid);
527     }
528     createServiceVersion(sid, manifest, manifestProtocol);
529   }
530 
531   function createServiceOffer(bytes calldata sid, uint price, uint duration)
532     external
533     whenNotPaused
534     whenDurationNotZero(duration)
535     returns (uint offerIndex)
536   {
537     (Service storage service, bytes32 sidHash) = _service(sid);
538     require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);
539     require(service.versionsList.length > 0, ERR_OFFER_NO_VERSION);
540     Offer[] storage offers = services[sidHash].offers;
541     offers.push(Offer({
542       createTime: now,
543       price: price,
544       duration: duration,
545       active: true
546     }));
547     emit ServiceOfferCreated(sid, offers.length - 1, price, duration);
548     return offers.length - 1;
549   }
550 
551   function disableServiceOffer(bytes calldata sid, uint offerIndex)
552     external
553     whenNotPaused
554   {
555     (Service storage service, bytes32 sidHash) = _service(sid);
556     require(_isServiceOwner(sidHash, msg.sender), ERR_SERVICE_NOT_OWNER);
557     require(_isServiceOfferExist(sidHash, offerIndex), ERR_OFFER_NOT_EXIST);
558     service.offers[offerIndex].active = false;
559     emit ServiceOfferDisabled(sid, offerIndex);
560   }
561 
562   function purchase(bytes calldata sid, uint offerIndex)
563     external
564     whenNotPaused
565   {
566     (Service storage service, bytes32 sidHash) = _service(sid);
567     require(!_isServiceOwner(sidHash, msg.sender), ERR_PURCHASE_OWNER);
568     require(_isServiceOfferExist(sidHash, offerIndex), ERR_OFFER_NOT_EXIST);
569     require(service.offers[offerIndex].active, ERR_OFFER_NOT_ACTIVE);
570 
571     Offer storage offer = service.offers[offerIndex];
572 
573     // if offer has been purchased for infinity then return
574     require(service.purchases[msg.sender].expire != INFINITY, ERR_PURCHASE_INFINITY);
575 
576     // Check if offer is active, sender has enough balance and approved the transform
577     require(token.balanceOf(msg.sender) >= offer.price, ERR_PURCHASE_TOKEN_BALANCE);
578     require(token.allowance(msg.sender, address(this)) >= offer.price, ERR_PURCHASE_TOKEN_APPROVE);
579 
580     // Transfer the token from sender to service owner
581     token.transferFrom(msg.sender, service.owner, offer.price);
582 
583     // max(service.purchases[msg.sender].expire,  now)
584     uint expire = service.purchases[msg.sender].expire <= now ?
585                      now : service.purchases[msg.sender].expire;
586 
587     // set expire + duration or INFINITY on overflow
588     expire = expire + offer.duration < expire ?
589                INFINITY : expire + offer.duration;
590 
591     // if given address purchase service
592     // 1st time add it to purchases list and set create time
593     if (service.purchases[msg.sender].expire == 0) {
594       service.purchases[msg.sender].createTime = now;
595       service.purchasesList.push(msg.sender);
596     }
597 
598     // set new expire time
599     service.purchases[msg.sender].expire = expire;
600     emit ServicePurchased(
601       sid,
602       offerIndex,
603       msg.sender,
604       offer.price,
605       offer.duration,
606       expire
607     );
608   }
609 
610   function destroy() public onlyOwner {
611     selfdestruct(msg.sender);
612   }
613 
614   /**
615     External views
616    */
617 
618   function servicesLength()
619     external view
620     returns (uint length)
621   {
622     return servicesList.length;
623   }
624 
625   function service(bytes calldata _sid)
626     external view
627     returns (uint256 createTime, address owner, bytes memory sid)
628   {
629     bytes32 sidHash = keccak256(_sid);
630     Service storage s = services[sidHash];
631     return (s.createTime, s.owner, s.sid);
632   }
633 
634   function serviceVersionsLength(bytes calldata sid)
635     external view
636     returns (uint length)
637   {
638     (Service storage s,) = _service(sid);
639     return s.versionsList.length;
640   }
641 
642   function serviceVersionHash(bytes calldata sid, uint versionIndex)
643     external view
644     returns (bytes32 versionHash)
645   {
646     (Service storage s,) = _service(sid);
647     return s.versionsList[versionIndex];
648   }
649 
650   function serviceVersion(bytes32 versionHash)
651     external view
652     returns (
653       uint256 createTime,
654       bytes memory manifest,
655       bytes memory manifestProtocol
656     )
657   {
658     bytes32 sidHash = versionHashToService[versionHash];
659     require(_isServiceExist(sidHash), ERR_SERVICE_NOT_EXIST);
660     Version storage version = services[sidHash].versions[versionHash];
661     return (version.createTime, version.manifest, version.manifestProtocol);
662   }
663 
664   function serviceOffersLength(bytes calldata sid)
665     external view
666     returns (uint length)
667   {
668     (Service storage s,) = _service(sid);
669     return s.offers.length;
670   }
671 
672   function serviceOffer(bytes calldata sid, uint offerIndex)
673     external view
674     returns (uint256 createTime, uint price, uint duration, bool active)
675   {
676     (Service storage s,) = _service(sid);
677     Offer storage offer = s.offers[offerIndex];
678     return (offer.createTime, offer.price, offer.duration, offer.active);
679   }
680 
681   function servicePurchasesLength(bytes calldata sid)
682     external view
683     returns (uint length)
684   {
685     (Service storage s,) = _service(sid);
686     return s.purchasesList.length;
687   }
688 
689   function servicePurchaseAddress(bytes calldata sid, uint purchaseIndex)
690     external view
691     returns (address purchaser)
692   {
693     (Service storage s,) = _service(sid);
694     return s.purchasesList[purchaseIndex];
695   }
696 
697   function servicePurchase(bytes calldata sid, address purchaser)
698     external view
699     returns (uint256 createTime, uint expire)
700   {
701     (Service storage s,) = _service(sid);
702     Purchase storage p = s.purchases[purchaser];
703     return (p.createTime, p.expire);
704   }
705 
706   function isAuthorized(bytes calldata sid, address purchaser)
707     external view
708     returns (bool authorized)
709   {
710     (Service storage s,) = _service(sid);
711     if (s.owner == purchaser || s.purchases[purchaser].expire >= now) {
712       return true;
713     }
714 
715     for (uint i = 0; i < s.offers.length; i++) {
716       if (s.offers[i].active && s.offers[i].price == 0) {
717         return true;
718       }
719     }
720 
721     return false;
722   }
723 
724   /**
725     Public views
726    */
727 
728   function isServiceExist(bytes memory sid)
729     public view
730     returns (bool exist)
731   {
732     bytes32 sidHash = keccak256(sid);
733     return _isServiceExist(sidHash);
734   }
735 
736   function isServiceOwner(bytes memory sid, address owner)
737     public view
738     returns (bool isOwner)
739   {
740     bytes32 sidHash = keccak256(sid);
741     return _isServiceOwner(sidHash, owner);
742   }
743 
744   function isServiceVersionExist(bytes32 versionHash)
745     public view
746     returns (bool exist)
747   {
748     return _isServiceExist(versionHashToService[versionHash]);
749   }
750 
751   function isServiceOfferExist(bytes memory sid, uint offerIndex)
752     public view
753     returns (bool exist)
754   {
755     bytes32 sidHash = keccak256(sid);
756     return _isServiceOfferExist(sidHash, offerIndex);
757   }
758 
759   function isServicesPurchaseExist(bytes memory sid, address purchaser)
760     public view
761   returns (bool exist) {
762     bytes32 sidHash = keccak256(sid);
763     return _isServicesPurchaseExist(sidHash, purchaser);
764   }
765 
766 }