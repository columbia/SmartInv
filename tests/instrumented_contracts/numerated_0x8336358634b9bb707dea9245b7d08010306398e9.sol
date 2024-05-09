1 pragma solidity ^0.4.21;
2 
3 contract LockRequestable {
4 
5     uint256 public lockRequestCount;
6 
7     function LockRequestable() public {
8         lockRequestCount = 0;
9     }
10 
11     function generateLockId() internal returns (bytes32 lockId) {
12         return keccak256(block.blockhash(block.number - 1), address(this), ++lockRequestCount);
13     }
14 }
15 
16 contract CustodianUpgradeable is LockRequestable {
17 
18     struct CustodianChangeRequest {
19         address proposedNew;
20     }
21 
22     address public custodian;
23 
24     mapping(bytes32 => CustodianChangeRequest) public custodianChangeReqs;
25 
26     function CustodianUpgradeable(
27         address _custodian
28     )
29     LockRequestable()
30     public
31     {
32         custodian = _custodian;
33     }
34 
35     modifier onlyCustodian {
36         require(msg.sender == custodian);
37         _;
38     }
39 
40     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
41         require(_proposedCustodian != address(0));
42 
43         lockId = generateLockId();
44 
45         custodianChangeReqs[lockId] = CustodianChangeRequest({
46             proposedNew : _proposedCustodian
47             });
48 
49         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
50     }
51 
52     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
53         custodian = getCustodianChangeReq(_lockId);
54         delete custodianChangeReqs[_lockId];
55         emit CustodianChangeConfirmed(_lockId, custodian);
56     }
57 
58     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
59         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
60         require(changeRequest.proposedNew != 0);
61         return changeRequest.proposedNew;
62     }
63 
64     event CustodianChangeRequested(
65         bytes32 _lockId,
66         address _msgSender,
67         address _proposedCustodian
68     );
69 
70     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
71 }
72 
73 contract ERC20ImplUpgradeable is CustodianUpgradeable {
74 
75     struct ImplChangeRequest {
76         address proposedNew;
77     }
78 
79     ERC20Impl public erc20Impl;
80 
81     mapping(bytes32 => ImplChangeRequest) public implChangeReqs;
82 
83     function ERC20ImplUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
84         erc20Impl = ERC20Impl(0x0);
85     }
86 
87     modifier onlyImpl {
88         require(msg.sender == address(erc20Impl));
89         _;
90     }
91 
92     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
93         require(_proposedImpl != address(0));
94         lockId = generateLockId();
95         implChangeReqs[lockId] = ImplChangeRequest({
96             proposedNew : _proposedImpl
97             });
98         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
99     }
100 
101     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
102         erc20Impl = getImplChangeReq(_lockId);
103         delete implChangeReqs[_lockId];
104         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
105     }
106 
107     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
108         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
109         require(changeRequest.proposedNew != address(0));
110         return ERC20Impl(changeRequest.proposedNew);
111     }
112 
113     event ImplChangeRequested(
114         bytes32 _lockId,
115         address _msgSender,
116         address _proposedImpl
117     );
118 
119     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
120 }
121 
122 
123 contract NianLunServiceUpgradeable is CustodianUpgradeable {
124 
125     struct NianLunServiceChangeRequest {
126         address proposedNew;
127     }
128 
129     NianLunService public nianLunService;
130 
131     mapping(bytes32 => NianLunServiceChangeRequest) public nianLunServiceChangeReqs;
132 
133     function NianLunServiceUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
134         nianLunService = NianLunService(0x0);
135     }
136 
137     modifier onlyNianLunService {
138         require(msg.sender == address(nianLunService));
139         _;
140     }
141 
142     function requestNianLunServiceChange(address _proposedNianLunService) public returns (bytes32 lockId) {
143         require(_proposedNianLunService != address(0));
144         lockId = generateLockId();
145         nianLunServiceChangeReqs[lockId] = NianLunServiceChangeRequest({
146             proposedNew : _proposedNianLunService
147             });
148         emit NianLunServiceChangeRequested(lockId, msg.sender, _proposedNianLunService);
149     }
150 
151     function confirmNianLunServiceChange(bytes32 _lockId) public onlyCustodian {
152         nianLunService = getNianLunServiceChangeReq(_lockId);
153         delete nianLunServiceChangeReqs[_lockId];
154         emit NianLunServiceChangeConfirmed(_lockId, address(nianLunService));
155     }
156 
157     function getNianLunServiceChangeReq(bytes32 _lockId) private view returns (NianLunService _proposedNew) {
158         NianLunServiceChangeRequest storage changeRequest = nianLunServiceChangeReqs[_lockId];
159         require(changeRequest.proposedNew != address(0));
160         return NianLunService(changeRequest.proposedNew);
161     }
162 
163     event NianLunServiceChangeRequested(
164         bytes32 _lockId,
165         address _msgSender,
166         address _proposedNianLunService
167     );
168 
169     event NianLunServiceChangeConfirmed(bytes32 _lockId, address _newNianLunService);
170 }
171 
172 contract ERC20Interface {
173     // METHODS
174     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
175     function totalSupply() public view returns (uint256);
176 
177     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#balanceof
178     function balanceOf(address _owner) public view returns (uint256 balance);
179 
180     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer
181     function transfer(address _to, uint256 _value) public returns (bool success);
182 
183     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transferfrom
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
185 
186     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
187     function approve(address _spender, uint256 _value) public returns (bool success);
188 
189     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#allowance
190     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
191 
192     // EVENTS
193     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
194     event Transfer(address indexed _from, address indexed _to, uint256 _value);
195 
196     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approval
197     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
198 }
199 
200 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable, NianLunServiceUpgradeable {
201 
202     string public name;
203 
204     string public symbol;
205 
206     uint8 public decimals;
207 
208     function ERC20Proxy(
209         string _name,
210         string _symbol,
211         uint8 _decimals,
212         address _custodian
213     )
214     ERC20ImplUpgradeable(_custodian) NianLunServiceUpgradeable(_custodian)
215     public
216     {
217         name = _name;
218         symbol = _symbol;
219         decimals = _decimals;
220     }
221 
222     modifier onlyPermitted() {
223         require(
224             msg.sender == address(nianLunService) ||
225             msg.sender == address(erc20Impl)
226         );
227         _;
228     }
229 
230     function totalSupply() public view returns (uint256) {
231         return erc20Impl.totalSupply();
232     }
233 
234     function balanceOf(address _owner) public view returns (uint256 balance) {
235         return erc20Impl.balanceOf(_owner);
236     }
237 
238     function emitTransfer(address _from, address _to, uint256 _value) public onlyPermitted {
239         emit Transfer(_from, _to, _value);
240     }
241 
242     function transfer(address _to, uint256 _value) public returns (bool success) {
243         return erc20Impl.transferWithSender(msg.sender, _to, _value);
244     }
245 
246     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
247         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
248     }
249 
250     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
251         emit Approval(_owner, _spender, _value);
252     }
253 
254     function approve(address _spender, uint256 _value) public returns (bool success) {
255         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
256     }
257 
258     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
259         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
260     }
261 
262     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
263         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
264     }
265 
266     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
267         return erc20Impl.allowance(_owner, _spender);
268     }
269 }
270 
271 contract ERC20Impl {
272 
273     ERC20Proxy public erc20Proxy;
274 
275     ERC20Store public erc20Store;
276 
277     function ERC20Impl(
278         address _erc20Proxy,
279         address _erc20Store
280     )
281     public
282     {
283         erc20Proxy = ERC20Proxy(_erc20Proxy);
284         erc20Store = ERC20Store(_erc20Store);
285     }
286 
287     modifier onlyProxy {
288         require(msg.sender == address(erc20Proxy));
289         _;
290     }
291 
292     modifier onlyPayloadSize(uint size) {
293         assert(msg.data.length == size + 4);
294         _;
295     }
296 
297     function approveWithSender(
298         address _sender,
299         address _spender,
300         uint256 _value
301     )
302     public
303     onlyProxy
304     returns (bool success)
305     {
306         require(_spender != address(0));
307         // disallow unspendable approvals
308         erc20Store.setAllowance(_sender, _spender, _value);
309         erc20Proxy.emitApproval(_sender, _spender, _value);
310         return true;
311     }
312 
313     function increaseApprovalWithSender(
314         address _sender,
315         address _spender,
316         uint256 _addedValue
317     )
318     public
319     onlyProxy
320     returns (bool success)
321     {
322         require(_spender != address(0));
323         // disallow unspendable approvals
324         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
325         uint256 newAllowance = currentAllowance + _addedValue;
326 
327         require(newAllowance >= currentAllowance);
328 
329         erc20Store.setAllowance(_sender, _spender, newAllowance);
330         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
331         return true;
332     }
333 
334     function decreaseApprovalWithSender(
335         address _sender,
336         address _spender,
337         uint256 _subtractedValue
338     )
339     public
340     onlyProxy
341     returns (bool success)
342     {
343         require(_spender != address(0));
344         // disallow unspendable approvals
345         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
346         uint256 newAllowance = currentAllowance - _subtractedValue;
347 
348         require(newAllowance <= currentAllowance);
349 
350         erc20Store.setAllowance(_sender, _spender, newAllowance);
351         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
352         return true;
353     }
354 
355     function transferFromWithSender(
356         address _sender,
357         address _from,
358         address _to,
359         uint256 _value
360     )
361     public
362     onlyProxy onlyPayloadSize(4 * 32)
363     returns (bool success)
364     {
365         require(_to != address(0));
366 
367         uint256 balanceOfFrom = erc20Store.balances(_from);
368         require(_value <= balanceOfFrom);
369 
370         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
371         require(_value <= senderAllowance);
372 
373         erc20Store.setBalance(_from, balanceOfFrom - _value);
374         erc20Store.addBalance(_to, _value);
375         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
376         erc20Proxy.emitTransfer(_from, _to, _value);
377 
378         return true;
379     }
380 
381     function transferWithSender(
382         address _sender,
383         address _to,
384         uint256 _value
385     )
386     public onlyProxy onlyPayloadSize(3 * 32)
387     returns (bool success)
388     {
389         require(_to != address(0));
390 
391         uint256 balanceOfSender = erc20Store.balances(_sender);
392         require(_value <= balanceOfSender);
393 
394         erc20Store.setBalance(_sender, balanceOfSender - _value);
395         erc20Store.addBalance(_to, _value);
396 
397         erc20Proxy.emitTransfer(_sender, _to, _value);
398 
399         return true;
400     }
401 
402     function totalSupply() public view returns (uint256) {
403         return erc20Store.totalSupply();
404     }
405 
406     function balanceOf(address _owner) public view returns (uint256 balance) {
407         return erc20Store.balances(_owner);
408     }
409 
410     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
411         return erc20Store.allowed(_owner, _spender);
412     }
413 
414 }
415 
416 contract ERC20Store is ERC20ImplUpgradeable, NianLunServiceUpgradeable {
417 
418     uint256 public totalSupply;
419     uint256 public createDate;
420 
421     address public foundation;
422     address public team;
423     address public partner;
424     address public transit;
425 
426     mapping(address => uint256) public balances;
427 
428     mapping(address => mapping(address => uint256)) public allowed;
429 
430     mapping(address => uint256) public availableMap;
431 
432     function ERC20Store(address _custodian, address _foundation, address _team, address _partner, address _transit)
433     ERC20ImplUpgradeable(_custodian) NianLunServiceUpgradeable(_custodian)
434     public
435     {
436         createDate = now;
437         foundation = _foundation;
438         partner = _partner;
439         team = _team;
440         transit = _transit;
441         availableMap[foundation] = 15120000000000000;
442         availableMap[partner] = 3360000000000000;
443         availableMap[team] = 2520000000000000;
444     }
445 
446     modifier onlyPermitted
447     {
448         require(
449             msg.sender == address(nianLunService) ||
450             msg.sender == address(erc20Impl)
451         );
452         _;
453     }
454 
455     function setTotalSupply(uint256 _newTotalSupply)
456     public onlyPermitted
457     {
458         totalSupply = _newTotalSupply;
459     }
460 
461     function setAllowance(address _owner, address _spender, uint256 _value)
462     public onlyImpl
463     {
464         allowed[_owner][_spender] = _value;
465     }
466 
467     function setBalance(address _owner, uint256 _newBalance)
468     public onlyPermitted
469     {
470         balances[_owner] = _newBalance;
471     }
472 
473     function addBalance(address _owner, uint256 _balanceIncrease)
474     public onlyPermitted
475     {
476         balances[_owner] = balances[_owner] + _balanceIncrease;
477     }
478 
479     function reduceAvailable(address _owner, uint256 _value)
480     public onlyNianLunService
481     {
482         availableMap[_owner] = availableMap[_owner] - _value;
483     }
484 
485 }
486 
487 contract NianLunService is LockRequestable, CustodianUpgradeable {
488 
489     struct PendingService {
490         address sender;
491         uint256 value;
492         bool isPrint;
493     }
494 
495     ERC20Proxy public erc20Proxy;
496 
497     ERC20Store public erc20Store;
498 
499     mapping(address => bool) public primaryBank;
500 
501     mapping(bytes32 => PendingService) public pendingServiceMap;
502 
503     function NianLunService(address _erc20Proxy, address _erc20Store, address _custodian)
504     CustodianUpgradeable(_custodian)
505     public
506     {
507         erc20Proxy = ERC20Proxy(_erc20Proxy);
508         erc20Store = ERC20Store(_erc20Store);
509     }
510 
511     modifier onlyPrimary
512     {
513         require(primaryBank[address(msg.sender)]);
514         _;
515     }
516 
517     modifier onlyPayloadSize(uint size) {
518         assert(msg.data.length == size + 4);
519         _;
520     }
521 
522     function addPrimary(address _newPrimary)
523     public onlyCustodian
524     {
525         primaryBank[_newPrimary] = true;
526         emit PrimaryChanged(_newPrimary, true);
527     }
528 
529     function removePrimary(address _removePrimary)
530     public onlyCustodian
531     {
532         delete primaryBank[_removePrimary];
533         emit PrimaryChanged(_removePrimary, false);
534     }
535 
536     function authTransfer(address _from, address _to, uint256 _value)
537     public onlyPrimary onlyPayloadSize(3 * 32)
538     returns (bool success)
539     {
540         require(_to != address(0));
541         uint256 balanceOfFrom = erc20Store.balances(_from);
542         require(_value <= balanceOfFrom);
543 
544         erc20Store.setBalance(_from, balanceOfFrom - _value);
545         erc20Store.addBalance(_to, _value);
546 
547         erc20Proxy.emitTransfer(_from, _to, _value);
548         return true;
549     }
550 
551     function batchPublishService(address[] _senders, uint256[] _values, bool[] _isPrints)
552     public onlyPrimary
553     returns (bool success)
554     {
555         require(_senders.length == _values.length);
556         require(_isPrints.length == _values.length);
557 
558         uint256 numPublish = _senders.length;
559         for (uint256 i = 0; i < numPublish; i++) {
560             publishService(_senders[i], _values[i], _isPrints[i]);
561         }
562         return true;
563     }
564 
565     function publishService(address _sender, uint256 _value, bool _isPrint)
566     public onlyPrimary onlyPayloadSize(3 * 32)
567     {
568         require(_sender != address(0));
569 
570         bytes32 lockId = generateLockId();
571 
572         pendingServiceMap[lockId] = PendingService({
573             sender : _sender,
574             value : _value,
575             isPrint : _isPrint
576             });
577 
578         if (_isPrint) {
579             // print value to transit;
580             erc20Store.setTotalSupply(erc20Store.totalSupply() + _value);
581             erc20Proxy.emitTransfer(address(0), erc20Store.transit(), _value);
582         } else {
583             // transfer value from sender to transit
584             uint256 balanceOfSender = erc20Store.balances(_sender);
585             if (_value > balanceOfSender) {
586                 delete pendingServiceMap[lockId];
587                 emit ServicePublished(lockId, _sender, _value, false);
588                 return;
589             }
590             erc20Store.setBalance(_sender, balanceOfSender - _value);
591             erc20Proxy.emitTransfer(_sender, erc20Store.transit(), _value);
592         }
593         erc20Store.addBalance(erc20Store.transit(), _value);
594         emit ServicePublished(lockId, _sender, _value, true);
595     }
596 
597     function batchConfirmService(bytes32[] _lockIds, uint256[] _values, address[] _tos)
598     public onlyPrimary
599     returns (bool result)
600     {
601         require(_lockIds.length == _values.length);
602         require(_lockIds.length == _tos.length);
603 
604         uint256 numConfirms = _lockIds.length;
605         for (uint256 i = 0; i < numConfirms; i++) {
606             confirmService(_lockIds[i], _values[i], _tos[i]);
607         }
608         return true;
609     }
610 
611     function confirmService(bytes32 _lockId, uint256 _value, address _to)
612     public onlyPrimary
613     {
614         PendingService storage service = pendingServiceMap[_lockId];
615 
616         address _sender = service.sender;
617         uint256 _availableValue = service.value;
618         bool _isPrint = service.isPrint;
619 
620         if (_value > _availableValue) {
621             emit ServiceConfirmed(_lockId, _sender, _to, _value, false);
622             return;
623         }
624 
625         uint256 _restValue = _availableValue - _value;
626 
627         if (_restValue == 0) {
628             delete pendingServiceMap[_lockId];
629         } else {
630             service.value = _restValue;
631         }
632 
633         if (_isPrint) {
634             releaseFoundation(_value);
635         }
636 
637         uint256 balanceOfTransit = erc20Store.balances(erc20Store.transit());
638         erc20Store.setBalance(erc20Store.transit(), balanceOfTransit - _value);
639         erc20Store.addBalance(_to, _value);
640         erc20Proxy.emitTransfer(erc20Store.transit(), _to, _value);
641         emit ServiceConfirmed(_lockId, _sender, _to, _value, true);
642     }
643 
644     function releaseFoundation(uint256 _value)
645     private
646     {
647         uint256 foundationAvailable = erc20Store.availableMap(erc20Store.foundation());
648         if (foundationAvailable <= 0) {
649             return;
650         }
651         if (foundationAvailable < _value) {
652             _value = foundationAvailable;
653         }
654         erc20Store.addBalance(erc20Store.foundation(), _value);
655         erc20Store.setTotalSupply(erc20Store.totalSupply() + _value);
656         erc20Store.reduceAvailable(erc20Store.foundation(), _value);
657         erc20Proxy.emitTransfer(address(0), erc20Store.foundation(), _value);
658     }
659 
660     function batchCancelService(bytes32[] _lockIds)
661     public onlyPrimary
662     returns (bool result)
663     {
664         uint256 numCancels = _lockIds.length;
665         for (uint256 i = 0; i < numCancels; i++) {
666             cancelService(_lockIds[i]);
667         }
668         return true;
669     }
670 
671     function cancelService(bytes32 _lockId)
672     public onlyPrimary
673     {
674         PendingService storage service = pendingServiceMap[_lockId];
675         address _sender = service.sender;
676         uint256 _value = service.value;
677         bool _isPrint = service.isPrint;
678 
679         delete pendingServiceMap[_lockId];
680 
681         if (_isPrint) {
682             // burn
683             erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
684             erc20Proxy.emitTransfer(erc20Store.transit(), address(0), _value);
685         } else {
686             // send back
687             erc20Store.addBalance(_sender, _value);
688             erc20Proxy.emitTransfer(erc20Store.transit(), _sender, _value);
689         }
690         uint256 balanceOfTransit = erc20Store.balances(erc20Store.transit());
691         erc20Store.setBalance(erc20Store.transit(), balanceOfTransit - _value);
692         emit ServiceCanceled(_lockId, _sender, _value);
693     }
694 
695     function queryService(bytes32 _lockId)
696     public view
697     returns (address _sender, uint256 _value, bool _isPrint)
698     {
699         PendingService storage service = pendingServiceMap[_lockId];
700         _sender = service.sender;
701         _value = service.value;
702         _isPrint = service.isPrint;
703     }
704 
705     function releaseTeam()
706     public
707     returns (bool success)
708     {
709         uint256 teamAvailable = erc20Store.availableMap(erc20Store.team());
710         if (teamAvailable > 0 && now > erc20Store.createDate() + 3 * 1 years) {
711             erc20Store.addBalance(erc20Store.team(), teamAvailable);
712             erc20Store.setTotalSupply(erc20Store.totalSupply() + teamAvailable);
713             erc20Store.reduceAvailable(erc20Store.team(), teamAvailable);
714             erc20Proxy.emitTransfer(address(0), erc20Store.team(), teamAvailable);
715             return true;
716         }
717         return false;
718     }
719 
720     function releasePartner()
721     public
722     returns (bool success)
723     {
724         uint256 partnerAvailable = erc20Store.availableMap(erc20Store.partner());
725         if (partnerAvailable > 0) {
726             erc20Store.addBalance(erc20Store.partner(), partnerAvailable);
727             erc20Store.setTotalSupply(erc20Store.totalSupply() + partnerAvailable);
728             erc20Store.reduceAvailable(erc20Store.partner(), partnerAvailable);
729             erc20Proxy.emitTransfer(address(0), erc20Store.partner(), partnerAvailable);
730             return true;
731         }
732         return false;
733     }
734 
735     event ServicePublished(bytes32 _lockId, address _sender, uint256 _value, bool _result);
736 
737     event ServiceConfirmed(bytes32 _lockId, address _sender, address _to, uint256 _value, bool _result);
738 
739     event ServiceCanceled(bytes32 _lockId, address _sender, uint256 _value);
740 
741     event PrimaryChanged(address _primary, bool opt);
742 
743 }