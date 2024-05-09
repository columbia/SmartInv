1 pragma solidity ^0.4.21;
2 
3 contract LockRequestable {
4 
5     // MEMBERS
6     uint256 public lockRequestCount;
7 
8     // CONSTRUCTOR
9     function LockRequestable() public {
10         lockRequestCount = 0;
11     }
12 
13     // FUNCTIONS
14     function generateLockId() internal returns (bytes32 lockId) {
15         return keccak256(block.blockhash(block.number - 1), address(this), ++lockRequestCount);
16     }
17 }
18 
19 contract CustodianUpgradeable is LockRequestable {
20 
21     // TYPES
22     struct CustodianChangeRequest {
23         address proposedNew;
24     }
25 
26     // MEMBERS
27     address public custodian;
28 
29     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
30 
31     // CONSTRUCTOR
32     function CustodianUpgradeable(address _custodian)LockRequestable()
33       public
34     {
35         custodian = _custodian;
36     }
37 
38     // MODIFIERS
39     modifier onlyCustodian {
40         require(msg.sender == custodian);
41         _;
42     }
43 
44     // PUBLIC FUNCTIONS
45     // (UPGRADE)
46 
47     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
48         require(_proposedCustodian != address(0));
49 
50         lockId = generateLockId();
51 
52         custodianChangeReqs[lockId] = CustodianChangeRequest({
53             proposedNew: _proposedCustodian
54         });
55 
56         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
57     }
58 
59     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
60         custodian = getCustodianChangeReq(_lockId);
61 
62         delete custodianChangeReqs[_lockId];
63 
64         emit CustodianChangeConfirmed(_lockId, custodian);
65     }
66 
67     // PRIVATE FUNCTIONS
68     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
69         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
70 
71         // reject ‘null’ results from the map lookup
72         // this can only be the case if an unknown `_lockId` is received
73         require(changeRequest.proposedNew != 0);
74 
75         return changeRequest.proposedNew;
76     }
77 
78     event CustodianChangeRequested(
79         bytes32 _lockId,
80         address _msgSender,
81         address _proposedCustodian
82     );
83 
84     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
85 }
86 
87 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
88 
89     // TYPES
90     struct ImplChangeRequest {
91         address proposedNew;
92     }
93 
94     // MEMBERS
95     // @dev  The reference to the active token implementation.
96     ERC20Impl public erc20Impl;
97 
98     /// @dev  The map of lock ids to pending implementation changes.
99     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
100 
101     // CONSTRUCTOR
102     function ERC20ImplUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
103         erc20Impl = ERC20Impl(0x0);
104     }
105 
106     // MODIFIERS
107     modifier onlyImpl {
108         require(msg.sender == address(erc20Impl));
109         _;
110     }
111 
112     // PUBLIC FUNCTIONS
113     // (UPGRADE)
114     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
115         require(_proposedImpl != address(0));
116 
117         lockId = generateLockId();
118 
119         implChangeReqs[lockId] = ImplChangeRequest({
120             proposedNew: _proposedImpl
121         });
122 
123         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
124     }
125     
126     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
127         erc20Impl = getImplChangeReq(_lockId);
128 
129         delete implChangeReqs[_lockId];
130 
131         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
132     }
133 
134     // PRIVATE FUNCTIONS
135     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
136         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
137 
138         // reject ‘null’ results from the map lookup
139         // this can only be the case if an unknown `_lockId` is received
140         require(changeRequest.proposedNew != address(0));
141 
142         return ERC20Impl(changeRequest.proposedNew);
143     }
144 
145     event ImplChangeRequested(
146         bytes32 _lockId,
147         address _msgSender,
148         address _proposedImpl
149     );
150 
151     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
152 }
153 
154 
155 contract ERC20Interface {
156   // METHODS
157 
158   // NOTE:
159   //   public getter functions are not currently recognised as an
160   //   implementation of the matching abstract function by the compiler.
161 
162   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name
163   // function name() public view returns (string);
164 
165   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#symbol
166   // function symbol() public view returns (string);
167 
168   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
169   // function decimals() public view returns (uint8);
170 
171   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
172   function totalSupply() public view returns (uint256);
173 
174   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#balanceof
175   function balanceOf(address _owner) public view returns (uint256 balance);
176 
177   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer
178   function transfer(address _to, uint256 _value) public returns (bool success);
179 
180   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transferfrom
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
182 
183   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
184   function approve(address _spender, uint256 _value) public returns (bool success);
185 
186   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#allowance
187   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
188 
189   // EVENTS
190   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
191   event Transfer(address indexed _from, address indexed _to, uint256 _value);
192 
193   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approval
194   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
195 }
196 
197 
198 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
199 
200     // MEMBERS
201     string public name;
202 
203     string public symbol;
204 
205     uint8 public decimals;
206 
207     // CONSTRUCTOR
208     function ERC20Proxy(
209         string _name,
210         string _symbol,
211         uint8 _decimals,
212         address _custodian
213     )
214         ERC20ImplUpgradeable(_custodian)
215         public
216     {
217         name = _name;
218         symbol = _symbol;
219         decimals = _decimals;
220     }
221 
222     // PUBLIC FUNCTIONS
223     // (ERC20Interface)
224     function totalSupply() public view returns (uint256) {
225         return erc20Impl.totalSupply();
226     }
227 
228     function balanceOf(address _owner) public view returns (uint256 balance) {
229         return erc20Impl.balanceOf(_owner);
230     }
231 
232     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
233         emit Transfer(_from, _to, _value);
234     }
235 
236     function transfer(address _to, uint256 _value) public returns (bool success) {
237         return erc20Impl.transferWithSender(msg.sender, _to, _value);
238     }
239 
240     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
241         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
242     }
243 
244     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
245         emit Approval(_owner, _spender, _value);
246     }
247 
248     function approve(address _spender, uint256 _value) public returns (bool success) {
249         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
250     }
251 
252     
253     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
254         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
255     }
256 
257     
258     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
259         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
260     }
261     
262     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
263         return erc20Impl.allowance(_owner, _spender);
264     }
265 }
266 
267 
268 
269 contract ERC20Impl is CustodianUpgradeable {
270 
271     // TYPES
272     struct PendingPrint {
273         address receiver;
274         uint256 value;
275     }
276 
277     // MEMBERS
278     ERC20Proxy public erc20Proxy;
279 
280     ERC20Store public erc20Store;
281 
282     address public sweeper;
283 
284     
285     bytes32 public sweepMsg;
286 
287     
288     mapping (address => bool) public sweptSet;
289 
290     /// @dev  The map of lock ids to pending token increases.
291     mapping (bytes32 => PendingPrint) public pendingPrintMap;
292 
293     // CONSTRUCTOR
294     function ERC20Impl(
295           address _erc20Proxy,
296           address _erc20Store,
297           address _custodian,
298           address _sweeper
299     )
300         CustodianUpgradeable(_custodian)
301         public
302     {
303         require(_sweeper != 0);
304         erc20Proxy = ERC20Proxy(_erc20Proxy);
305         erc20Store = ERC20Store(_erc20Store);
306 
307         sweeper = _sweeper;
308         sweepMsg = keccak256(address(this), "sweep");
309     }
310 
311     // MODIFIERS
312     modifier onlyProxy {
313         require(msg.sender == address(erc20Proxy));
314         _;
315     }
316     modifier onlySweeper {
317         require(msg.sender == sweeper);
318         _;
319     }
320 
321 
322     
323     function approveWithSender(
324         address _sender,
325         address _spender,
326         uint256 _value
327     )
328         public
329         onlyProxy
330         returns (bool success)
331     {
332         require(_spender != address(0)); // disallow unspendable approvals
333         erc20Store.setAllowance(_sender, _spender, _value);
334         erc20Proxy.emitApproval(_sender, _spender, _value);
335         return true;
336     }
337 
338     
339     function increaseApprovalWithSender(
340         address _sender,
341         address _spender,
342         uint256 _addedValue
343     )
344         public
345         onlyProxy
346         returns (bool success)
347     {
348         require(_spender != address(0)); // disallow unspendable approvals
349         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
350         uint256 newAllowance = currentAllowance + _addedValue;
351 
352         require(newAllowance >= currentAllowance);
353 
354         erc20Store.setAllowance(_sender, _spender, newAllowance);
355         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
356         return true;
357     }
358 
359     
360     function decreaseApprovalWithSender(
361         address _sender,
362         address _spender,
363         uint256 _subtractedValue
364     )
365         public
366         onlyProxy
367         returns (bool success)
368     {
369         require(_spender != address(0)); // disallow unspendable approvals
370         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
371         uint256 newAllowance = currentAllowance - _subtractedValue;
372 
373         require(newAllowance <= currentAllowance);
374 
375         erc20Store.setAllowance(_sender, _spender, newAllowance);
376         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
377         return true;
378     }
379 
380     
381     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
382         require(_receiver != address(0));
383 
384         lockId = generateLockId();
385 
386         pendingPrintMap[lockId] = PendingPrint({
387             receiver: _receiver,
388             value: _value
389         });
390 
391         emit PrintingLocked(lockId, _receiver, _value);
392     }
393 
394     
395     function confirmPrint(bytes32 _lockId) public onlyCustodian {
396         PendingPrint storage print = pendingPrintMap[_lockId];
397 
398         // reject ‘null’ results from the map lookup
399         // this can only be the case if an unknown `_lockId` is received
400         address receiver = print.receiver;
401         require (receiver != address(0));
402         uint256 value = print.value;
403 
404         delete pendingPrintMap[_lockId];
405 
406         uint256 supply = erc20Store.totalSupply();
407         uint256 newSupply = supply + value;
408         if (newSupply >= supply) {
409           erc20Store.setTotalSupply(newSupply);
410           erc20Store.addBalance(receiver, value);
411 
412           emit PrintingConfirmed(_lockId, receiver, value);
413           erc20Proxy.emitTransfer(address(0), receiver, value);
414         }
415     }
416 
417     
418     function burn(uint256 _value) public returns (bool success) {
419         uint256 balanceOfSender = erc20Store.balances(msg.sender);
420         require(_value <= balanceOfSender);
421 
422         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
423         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
424 
425         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
426 
427         return true;
428     }
429 
430     
431     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool success) {
432         require(_tos.length == _values.length);
433 
434         uint256 numTransfers = _tos.length;
435         uint256 senderBalance = erc20Store.balances(msg.sender);
436 
437         for (uint256 i = 0; i < numTransfers; i++) {
438           address to = _tos[i];
439           require(to != address(0));
440           uint256 v = _values[i];
441           require(senderBalance >= v);
442 
443           if (msg.sender != to) {
444             senderBalance -= v;
445             erc20Store.addBalance(to, v);
446           }
447           erc20Proxy.emitTransfer(msg.sender, to, v);
448         }
449 
450         erc20Store.setBalance(msg.sender, senderBalance);
451 
452         return true;
453     }
454 
455     function enableSweep(uint8[] _vs, bytes32[] _rs, bytes32[] _ss, address _to) public onlySweeper {
456         require(_to != address(0));
457         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
458 
459         uint256 numSignatures = _vs.length;
460         uint256 sweptBalance = 0;
461 
462         for (uint256 i=0; i<numSignatures; ++i) {
463           address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
464 
465           // ecrecover returns 0 on malformed input
466           if (from != address(0)) {
467             sweptSet[from] = true;
468 
469             uint256 fromBalance = erc20Store.balances(from);
470 
471             if (fromBalance > 0) {
472               sweptBalance += fromBalance;
473 
474               erc20Store.setBalance(from, 0);
475 
476               erc20Proxy.emitTransfer(from, _to, fromBalance);
477             }
478           }
479         }
480 
481         if (sweptBalance > 0) {
482           erc20Store.addBalance(_to, sweptBalance);
483         }
484     }
485 
486     function replaySweep(address[] _froms, address _to) public onlySweeper {
487         require(_to != address(0));
488         uint256 lenFroms = _froms.length;
489         uint256 sweptBalance = 0;
490 
491         for (uint256 i=0; i<lenFroms; ++i) {
492             address from = _froms[i];
493 
494             if (sweptSet[from]) {
495                 uint256 fromBalance = erc20Store.balances(from);
496 
497                 if (fromBalance > 0) {
498                     sweptBalance += fromBalance;
499 
500                     erc20Store.setBalance(from, 0);
501 
502                     erc20Proxy.emitTransfer(from, _to, fromBalance);
503                 }
504             }
505         }
506 
507         if (sweptBalance > 0) {
508             erc20Store.addBalance(_to, sweptBalance);
509         }
510     }
511 
512     function transferFromWithSender(
513         address _sender,
514         address _from,
515         address _to,
516         uint256 _value
517     )
518         public
519         onlyProxy
520         returns (bool success)
521     {
522         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
523 
524         uint256 balanceOfFrom = erc20Store.balances(_from);
525         require(_value <= balanceOfFrom);
526 
527         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
528         require(_value <= senderAllowance);
529 
530         erc20Store.setBalance(_from, balanceOfFrom - _value);
531         erc20Store.addBalance(_to, _value);
532 
533         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
534 
535         erc20Proxy.emitTransfer(_from, _to, _value);
536 
537         return true;
538     }
539 
540     function transferWithSender(
541         address _sender,
542         address _to,
543         uint256 _value
544     )
545         public
546         onlyProxy
547         returns (bool success)
548     {
549         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
550 
551         uint256 balanceOfSender = erc20Store.balances(_sender);
552         require(_value <= balanceOfSender);
553 
554         erc20Store.setBalance(_sender, balanceOfSender - _value);
555         erc20Store.addBalance(_to, _value);
556 
557         erc20Proxy.emitTransfer(_sender, _to, _value);
558 
559         return true;
560     }
561 
562     // METHODS (ERC20 sub interface impl.)
563     function totalSupply() public view returns (uint256) {
564         return erc20Store.totalSupply();
565     }
566 
567     function balanceOf(address _owner) public view returns (uint256 balance) {
568         return erc20Store.balances(_owner);
569     }
570 
571     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
572         return erc20Store.allowed(_owner, _spender);
573     }
574 
575     // EVENTS
576     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
577     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
578 }
579 
580 
581 contract ERC20Store is ERC20ImplUpgradeable {
582 
583     // MEMBERS
584     uint256 public totalSupply;
585 
586     mapping (address => uint256) public balances;
587 
588     mapping (address => mapping (address => uint256)) public allowed;
589 
590     // CONSTRUCTOR
591     function ERC20Store(address _custodian) ERC20ImplUpgradeable(_custodian) public {
592         totalSupply = 1000000;
593     }
594 
595 
596     // PUBLIC FUNCTIONS
597     // (ERC20 Ledger)
598 
599     function setTotalSupply(
600         uint256 _newTotalSupply
601     )
602         public
603         onlyImpl
604     {
605         totalSupply = _newTotalSupply;
606     }
607 
608     function setAllowance(
609         address _owner,
610         address _spender,
611         uint256 _value
612     )
613         public
614         onlyImpl
615     {
616         allowed[_owner][_spender] = _value;
617     }
618 
619     function setBalance(
620         address _owner,
621         uint256 _newBalance
622     )
623         public
624         onlyImpl
625     {
626         balances[_owner] = _newBalance;
627     }
628 
629     function addBalance(
630         address _owner,
631         uint256 _balanceIncrease
632     )
633         public
634         onlyImpl
635     {
636         balances[_owner] = balances[_owner] + _balanceIncrease;
637     }
638 }