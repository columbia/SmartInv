1 pragma solidity ^0.5.1;
2 
3 interface TokenRecipient {
4 
5     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
6 }
7 
8 contract ERC20Interface {
9 
10     function totalSupply() public view returns (uint256);
11     
12     function balanceOf(address _owner) public view returns (uint256 balance);
13     
14     function transfer(address _to, uint256 _value) public returns (bool success);
15     
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17     
18     function approve(address _spender, uint256 _value) public returns (bool success);
19     
20     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success);
21     
22     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
23     
24     function burn(uint256 _value, string memory _note) public returns (bool success);
25     
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27 
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 
30     event Burn(address indexed _burner, uint256 _value, string _note);
31 }
32 
33 contract LockRequestable {
34 
35     uint256 public lockRequestCount;
36 
37     constructor() public {
38         lockRequestCount = 0;
39     }
40 
41     function generateLockId() internal returns (bytes32 lockId) {
42         return keccak256(
43         abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
44         );
45     }
46 }
47 
48 contract CustodianUpgradeable is LockRequestable {
49 
50     struct CustodianChangeRequest {
51         address proposedNew;
52     }
53 
54     address public custodian;
55 
56     
57     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
58 
59     constructor(address _custodian) public LockRequestable() {
60         custodian = _custodian;
61     }
62     
63     modifier onlyCustodian {
64         require(msg.sender == custodian);
65         _;
66     }
67 
68     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
69         require(_proposedCustodian != address(0));
70 
71         lockId = generateLockId();
72 
73         custodianChangeReqs[lockId] = CustodianChangeRequest({
74             proposedNew: _proposedCustodian
75         });
76 
77         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
78     }
79 
80     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
81         custodian = getCustodianChangeReq(_lockId);
82 
83         delete custodianChangeReqs[_lockId];
84 
85         emit CustodianChangeConfirmed(_lockId, custodian);
86     }
87     
88     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
89         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
90 
91         require(changeRequest.proposedNew != address(0));
92 
93         return changeRequest.proposedNew;
94     }
95 
96     event CustodianChangeRequested(
97         bytes32 _lockId,
98         address _msgSender,
99         address _proposedCustodian
100     );
101     
102     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
103 }
104 
105 contract ERC20Impl is CustodianUpgradeable {
106 
107     struct PendingPrint {
108         address receiver;
109         uint256 value;
110     }
111 
112     struct PendingBurnLimits {
113         uint256 min;
114         uint256 max;
115         bool isSet;
116     }
117     
118     ERC20Proxy public erc20Proxy;
119     ERC20Store public erc20Store;
120 
121     uint256 public burnMin = 0;
122     uint256 public burnMax = 0;
123 
124     address public sweeper;
125     bytes32 public sweepMsg;
126 
127     mapping (address => bool) public sweptSet;
128     mapping (bytes32 => PendingPrint) public pendingPrintMap;
129     mapping (bytes32 => PendingBurnLimits) public pendingBurnLimitsMap;
130 
131     constructor(
132     address _erc20Proxy,
133     address _erc20Store,
134     address _custodian,
135     address _sweeper
136     ) public CustodianUpgradeable(_custodian) {
137         require(_sweeper != address(0));
138         erc20Proxy = ERC20Proxy(_erc20Proxy);
139         erc20Store = ERC20Store(_erc20Store);
140 
141         sweeper = _sweeper;
142         sweepMsg = keccak256(
143         abi.encodePacked(address(this), "sweep")
144         );
145     }
146     
147     modifier onlyProxy {
148         require(msg.sender == address(erc20Proxy));
149         _;
150     }
151 
152     modifier onlySweeper {
153         require(msg.sender == sweeper);
154         _;
155     }
156 
157     function approveWithSender(
158         address _sender,
159         address _spender,
160         uint256 _value
161     )
162         public
163         onlyProxy
164         returns (bool success)
165     {
166         require(_spender != address(0)); 
167         erc20Store.setAllowance(_sender, _spender, _value);
168         erc20Proxy.emitApproval(_sender, _spender, _value);
169         return true;
170     }
171 
172     
173     function approveAndCallWithSender(
174         address _sender,
175         address _spender,
176         uint256 _value,
177         bytes memory _extraData
178     )
179         public
180         onlyProxy
181         returns (bool success)
182     {
183         TokenRecipient spender = TokenRecipient(_spender);
184         if (approveWithSender(_sender, _spender, _value)) {
185             spender.receiveApproval(_sender, _value, msg.sender, _extraData);
186             return true;
187         }
188     }
189 
190     function increaseApprovalWithSender(
191         address _sender,
192         address _spender,
193         uint256 _addedValue
194     )
195         public
196         onlyProxy
197         returns (bool success)
198     {
199         require(_spender != address(0)); 
200         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
201         uint256 newAllowance = currentAllowance + _addedValue;
202 
203         require(newAllowance >= currentAllowance);
204 
205         erc20Store.setAllowance(_sender, _spender, newAllowance);
206         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
207         return true;
208     }
209 
210     function decreaseApprovalWithSender(
211         address _sender,
212         address _spender,
213         uint256 _subtractedValue
214     )
215         public
216         onlyProxy
217         returns (bool success)
218     {
219         require(_spender != address(0)); 
220         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
221         uint256 newAllowance = currentAllowance - _subtractedValue;
222 
223         require(newAllowance <= currentAllowance);
224 
225         erc20Store.setAllowance(_sender, _spender, newAllowance);
226         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
227         return true;
228     }
229 
230     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
231         require(_receiver != address(0));
232 
233         lockId = generateLockId();
234 
235         pendingPrintMap[lockId] = PendingPrint({
236             receiver: _receiver,
237             value: _value
238         });
239 
240         emit PrintingLocked(lockId, _receiver, _value);
241     }
242 
243     function confirmPrint(bytes32 _lockId) public onlyCustodian {
244         PendingPrint storage print = pendingPrintMap[_lockId];
245 
246         
247         
248         address receiver = print.receiver;
249         require(receiver != address(0));
250         uint256 value = print.value;
251 
252         delete pendingPrintMap[_lockId];
253 
254         uint256 supply = erc20Store.totalSupply();
255         uint256 newSupply = supply + value;
256         if (newSupply >= supply) {
257             erc20Store.setTotalSupply(newSupply);
258             erc20Store.addBalance(receiver, value);
259 
260             emit PrintingConfirmed(_lockId, receiver, value);
261             erc20Proxy.emitTransfer(address(0), receiver, value);
262         }
263     }
264 
265     function print(address _receiver, uint256 _value) public onlyCustodian {
266         require(_receiver != address(0));
267         uint256 supply = erc20Store.totalSupply();
268         uint256 newSupply = supply + _value;
269         if (newSupply >= supply) {
270             erc20Store.setTotalSupply(newSupply);
271             erc20Store.addBalance(_receiver, _value);
272             erc20Proxy.emitTransfer(address(0), _receiver, _value);
273         }
274     }
275 
276     function requestBurnLimitsChange(uint256 _newMin, uint256 _newMax) public returns (bytes32 lockId) {
277         require(_newMin <= _newMax, "min > max");
278 
279         lockId = generateLockId();
280         pendingBurnLimitsMap[lockId] = PendingBurnLimits({
281             min: _newMin,
282             max: _newMax,
283             isSet: true
284         });
285 
286         emit BurnLimitsChangeLocked(lockId, _newMin, _newMax);
287     }
288 
289     function confirmBurnLimitsChange(bytes32 _lockId) public onlyCustodian {
290         PendingBurnLimits storage limits = pendingBurnLimitsMap[_lockId];
291 
292         
293         
294         bool isSet = limits.isSet;
295         require(isSet == true, "not such lockId");
296         delete pendingBurnLimitsMap[_lockId];
297 
298         emit BurnLimitsChangeConfirmed(_lockId, limits.min, limits.max);
299         burnMin = limits.min;
300         burnMax = limits.max;   
301     }
302 
303     function burnWithNote(address _burner, uint256 _value, string memory _note) public onlyProxy returns (bool success) {
304         if (burnMin > 0) {
305             require(_value >= burnMin, "below min burn limit");
306         }
307         if (burnMax > 0) {
308             require(_value <= burnMax, "exceeds max burn limit");
309         }
310 
311         uint256 balanceOfSender = erc20Store.balances(_burner);
312         require(_value <= balanceOfSender);
313 
314         erc20Store.setBalance(_burner, balanceOfSender - _value);
315         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
316 
317         erc20Proxy.emitBurn(_burner, _value, _note);
318         erc20Proxy.emitTransfer(_burner, address(0), _value);
319         return true;
320     }
321 
322     function batchTransfer(address[] memory _tos, uint256[] memory _values) public returns (bool success) {
323         require(_tos.length == _values.length);
324 
325         uint256 numTransfers = _tos.length;
326         uint256 senderBalance = erc20Store.balances(msg.sender);
327 
328         for (uint256 i = 0; i < numTransfers; i++) {
329             address to = _tos[i];
330             require(to != address(0));
331             uint256 v = _values[i];
332             require(senderBalance >= v);
333 
334             if (msg.sender != to) {
335                 senderBalance -= v;
336                 erc20Store.addBalance(to, v);
337             }
338             erc20Proxy.emitTransfer(msg.sender, to, v);
339         }
340 
341         erc20Store.setBalance(msg.sender, senderBalance);
342 
343         return true;
344     }
345 
346     function enableSweep(uint8[] memory _vs, bytes32[] memory _rs,
347     bytes32[] memory _ss, address _to) public onlySweeper {
348         require(_to != address(0));
349         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
350 
351         uint256 numSignatures = _vs.length;
352         uint256 sweptBalance = 0;
353 
354         for (uint256 i = 0; i < numSignatures; ++i) {
355             address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
356 
357             
358             if (from != address(0)) {
359                 sweptSet[from] = true;
360                
361                 uint256 fromBalance = erc20Store.balances(from);
362 
363                 if (fromBalance > 0) {
364                     sweptBalance += fromBalance;
365                     erc20Store.setBalance(from, 0);
366                     erc20Proxy.emitTransfer(from, _to, fromBalance);
367                 }
368             }
369         }
370 
371         if (sweptBalance > 0) {
372             erc20Store.addBalance(_to, sweptBalance);
373         }
374     }
375 
376     function replaySweep(address[] memory _froms, address _to) public onlySweeper {
377         require(_to != address(0));
378         uint256 lenFroms = _froms.length;
379         uint256 sweptBalance = 0;
380 
381         for (uint256 i = 0; i < lenFroms; ++i) {
382             address from = _froms[i];
383 
384             if (sweptSet[from]) {
385                 uint256 fromBalance = erc20Store.balances(from);
386 
387                 if (fromBalance > 0) {
388                     sweptBalance += fromBalance;
389 
390                     erc20Store.setBalance(from, 0);
391 
392                     erc20Proxy.emitTransfer(from, _to, fromBalance);
393                 }
394             }
395         }
396 
397         if (sweptBalance > 0) {
398             erc20Store.addBalance(_to, sweptBalance);
399         }
400     }
401 
402     function transferFromWithSender(
403         address _sender,
404         address _from,
405         address _to,
406         uint256 _value
407     )
408         public
409         onlyProxy
410         returns (bool success)
411     {
412         require(_to != address(0)); 
413 
414         uint256 balanceOfFrom = erc20Store.balances(_from);
415         require(_value <= balanceOfFrom);
416 
417         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
418         require(_value <= senderAllowance);
419 
420         erc20Store.setBalance(_from, balanceOfFrom - _value);
421         erc20Store.addBalance(_to, _value);
422 
423         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
424 
425         erc20Proxy.emitTransfer(_from, _to, _value);
426 
427         return true;
428     }
429 
430     function transferWithSender(
431         address _sender,
432         address _to,
433         uint256 _value
434     )
435         public
436         onlyProxy
437         returns (bool success)
438     {
439         require(_to != address(0));
440 
441         uint256 balanceOfSender = erc20Store.balances(_sender);
442         require(_value <= balanceOfSender);
443 
444         erc20Store.setBalance(_sender, balanceOfSender - _value);
445         erc20Store.addBalance(_to, _value);
446 
447         erc20Proxy.emitTransfer(_sender, _to, _value);
448 
449         return true;
450     }
451     
452     function totalSupply() public view returns (uint256) {
453         return erc20Store.totalSupply();
454     }
455 
456     function balanceOf(address _owner) public view returns (uint256 balance) {
457         return erc20Store.balances(_owner);
458     }
459 
460     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
461         return erc20Store.allowed(_owner, _spender);
462     }
463 
464     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
465 
466     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
467 
468     event BurnLimitsChangeLocked(bytes32 _lockId, uint256 _newMin, uint256 _newMax);
469     
470     event BurnLimitsChangeConfirmed(bytes32 _lockId, uint256 _newMin, uint256 _newMax);
471 }
472 
473 contract ERC20ImplUpgradeable is CustodianUpgradeable {
474 
475     struct ImplChangeRequest {
476         address proposedNew;
477     }
478 
479     ERC20Impl public erc20Impl;
480 
481     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
482 
483     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
484         erc20Impl = ERC20Impl(0x0);
485     }
486 
487     modifier onlyImpl {
488         require(msg.sender == address(erc20Impl));
489         _;
490     }
491 
492     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
493         require(_proposedImpl != address(0));
494 
495         lockId = generateLockId();
496 
497         implChangeReqs[lockId] = ImplChangeRequest({
498             proposedNew: _proposedImpl
499         });
500 
501         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
502     }
503 
504     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
505         erc20Impl = getImplChangeReq(_lockId);
506 
507         delete implChangeReqs[_lockId];
508 
509         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
510     }
511 
512     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
513         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
514 
515         require(changeRequest.proposedNew != address(0));
516 
517         return ERC20Impl(changeRequest.proposedNew);
518     }
519 
520     event ImplChangeRequested(
521         bytes32 _lockId,
522         address _msgSender,
523         address _proposedImpl
524     );
525 
526     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
527 }
528 
529 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
530 
531     string public name;
532     string public symbol;
533     uint8 public decimals;
534 
535     constructor(
536         string memory _name,
537         string memory _symbol,
538         uint8 _decimals,
539         address _custodian
540     ) public ERC20ImplUpgradeable(_custodian) {
541         name = _name;
542         symbol = _symbol;
543         decimals = _decimals;
544     }
545 
546     function totalSupply() public view returns (uint256) {
547         return erc20Impl.totalSupply();
548     }
549 
550     function balanceOf(address _owner) public view returns (uint256 balance) {
551         return erc20Impl.balanceOf(_owner);
552     }
553 
554     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
555         emit Transfer(_from, _to, _value);
556     }
557 
558     function transfer(address _to, uint256 _value) public returns (bool success) {
559         return erc20Impl.transferWithSender(msg.sender, _to, _value);
560     }
561 
562     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
563         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
564     }
565 
566     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
567         emit Approval(_owner, _spender, _value);
568     }
569 
570     function approve(address _spender, uint256 _value) public returns (bool success) {
571         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
572     }
573 
574     
575     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
576         return erc20Impl.approveAndCallWithSender(msg.sender, _spender, _value, _extraData);
577     }
578 
579     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
580         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
581     }
582 
583     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
584         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
585     }
586 
587     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
588         return erc20Impl.allowance(_owner, _spender);
589     }
590 
591     function emitBurn(address _burner, uint256 _value, string memory _note) public onlyImpl {
592         emit Burn(_burner, _value, _note);
593     }
594 
595     function burn(uint256 _value, string memory _note) public returns (bool success) {
596         return erc20Impl.burnWithNote(msg.sender, _value, _note);
597     }
598 }
599 
600 contract ERC20Store is ERC20ImplUpgradeable {
601 
602     uint256 public totalSupply;
603 
604     mapping (address => uint256) public balances;
605     mapping (address => mapping (address => uint256)) public allowed;
606 
607     constructor(address _custodian) public ERC20ImplUpgradeable(_custodian) {
608         totalSupply = 0;
609     }
610 
611     function setTotalSupply(
612         uint256 _newTotalSupply
613     )
614         public
615         onlyImpl
616     {
617         totalSupply = _newTotalSupply;
618     }
619 
620     function setAllowance(
621         address _owner,
622         address _spender,
623         uint256 _value
624     )
625         public
626         onlyImpl
627     {
628         allowed[_owner][_spender] = _value;
629     }
630 
631     function setBalance(
632         address _owner,
633         uint256 _newBalance
634     )
635         public
636         onlyImpl
637     {
638         balances[_owner] = _newBalance;
639     }
640 
641     function addBalance(
642         address _owner,
643         uint256 _balanceIncrease
644     )
645         public
646         onlyImpl
647     {
648         balances[_owner] = balances[_owner] + _balanceIncrease;
649     }
650 }