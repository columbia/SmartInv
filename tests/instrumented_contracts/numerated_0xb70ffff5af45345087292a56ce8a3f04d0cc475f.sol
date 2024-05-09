1 pragma solidity ^0.4.21;
2 
3 contract Zamok {
4 
5     // MEMBERS
6     uint256 public zamokCount;
7 
8     // CONSTRUCTOR
9     function Zamok() public {
10         zamokCount = 0;
11     }
12 
13     // FUNCTIONS
14     function generateZamokId() internal returns (bytes32 zamokId) {
15         return keccak256(block.blockhash(block.number - 1), address(this), ++zamokCount);
16     }
17 }
18 
19 
20 contract CustodianCanBeReplaced is Zamok {
21 
22     // TYPES
23     struct CustodianChangeRequest {
24         address proposedNew;
25     }
26 
27     // MEMBERS
28     address public custodian;
29 
30     mapping (bytes32 => CustodianChangeRequest) public custodianChangeRequests;
31 
32     // CONSTRUCTOR
33     function CustodianCanBeReplaced(
34         address _custodian
35     )
36     
37 	Zamok() public
38     {
39         custodian = _custodian;
40     }
41 
42     // MODIFIERS
43     modifier onlyCustodian {
44         require(msg.sender == custodian);
45         _;
46     }
47 
48     // PUBLIC FUNCTIONS
49     // (UPGRADE)
50 
51     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 zamokId) {
52         require(_proposedCustodian != address(0));
53 
54         zamokId = generateZamokId();
55 
56         custodianChangeRequests[zamokId] = CustodianChangeRequest({
57             proposedNew: _proposedCustodian
58         });
59 
60         emit CustodianChangeRequested(zamokId, msg.sender, _proposedCustodian);
61     }
62 
63     function confirmCustodianChange(bytes32 _zamokId) public onlyCustodian {
64         custodian = getCustodianChangeRequest(_zamokId);
65 
66         delete custodianChangeRequests[_zamokId];
67 
68         emit CustodianChangeConfirmed(_zamokId, custodian);
69     }
70 
71     // PRIVATE FUNCTIONS
72     function getCustodianChangeRequest(bytes32 _zamokId) private view returns (address _proposedNew) {
73         CustodianChangeRequest storage changeRequest = custodianChangeRequests[_zamokId];
74 
75         // reject ‘null’ results from the map lookup
76         // this can only be the case if an unknown `_zamokId` is received
77         require(changeRequest.proposedNew != 0);
78 
79         return changeRequest.proposedNew;
80     }
81 
82     event CustodianChangeRequested(
83         bytes32 _zamokId,
84         address _msgSender,
85         address _proposedCustodian
86     );
87 
88     event CustodianChangeConfirmed(bytes32 _zamokId, address _newCustodian);
89 }
90 
91 
92 contract DeloCanBeReplaced is CustodianCanBeReplaced  {
93 
94     // TYPES
95     struct DeloChangeRequest {
96         address proposedNew;
97     }
98 
99     // MEMBERS
100     // @dev  The reference to the active token implementation.
101     Delo public delo;
102 
103     mapping (bytes32 => DeloChangeRequest) public deloChangeRequests;
104 
105     // CONSTRUCTOR
106     function DeloCanBeReplaced(address _custodian) CustodianCanBeReplaced(_custodian) public {
107         delo = Delo(0x0);
108     }
109 
110     // MODIFIERS
111     modifier onlyDelo {
112         require(msg.sender == address(delo));
113         _;
114     }
115 
116     // PUBLIC FUNCTIONS
117     // (UPGRADE)
118     function requestDeloChange(address _proposedDelo) public returns (bytes32 zamokId) {
119         require(_proposedDelo != address(0));
120 
121         zamokId = generateZamokId();
122 
123         deloChangeRequests[zamokId] = DeloChangeRequest({
124             proposedNew: _proposedDelo
125         });
126 
127         emit DeloChangeRequested(zamokId, msg.sender, _proposedDelo);
128     }
129 
130     function confirmDeloChange(bytes32 _zamokId) public onlyCustodian {
131         delo = getDeloChangeRequest(_zamokId);
132 
133         delete deloChangeRequests[_zamokId];
134 
135         emit DeloChangeConfirmed(_zamokId, address(delo));
136     }
137 
138     // PRIVATE FUNCTIONS
139     function getDeloChangeRequest(bytes32 _zamokId) private view returns (Delo _proposedNew) {
140         DeloChangeRequest storage changeRequest = deloChangeRequests[_zamokId];
141 
142         // reject ‘null’ results from the map lookup
143         // this can only be the case if an unknown `_zamokId` is received
144         require(changeRequest.proposedNew != address(0));
145 
146         return Delo(changeRequest.proposedNew);
147     }
148 
149     event DeloChangeRequested(
150         bytes32 _zamokId,
151         address _msgSender,
152         address _proposedDelo
153     );
154 
155     event DeloChangeConfirmed(bytes32 _zamokId, address _newImpl);
156 }
157 
158 
159 contract ERC20Interface {
160   // METHODS
161 
162   // NOTE:
163   //   public getter functions are not currently recognised as an
164   //   implementation of the matching abstract function by the compiler.
165 
166   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name
167   // function name() public view returns (string);
168 
169   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#symbol
170   // function symbol() public view returns (string);
171 
172   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
173   // function decimals() public view returns (uint8);
174 
175   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
176   function totalSupply() public view returns (uint256);
177 
178   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#balanceof
179   function balanceOf(address _owner) public view returns (uint256 balance);
180 
181   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer
182   function transfer(address _to, uint256 _value) public returns (bool success);
183 
184   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transferfrom
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
186 
187   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
188   function approve(address _spender, uint256 _value) public returns (bool success);
189 
190   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#allowance
191   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
192 
193   // EVENTS
194   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
195   event Transfer(address indexed _from, address indexed _to, uint256 _value);
196 
197   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approval
198   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
199 }
200 
201 
202 contract Front is ERC20Interface, DeloCanBeReplaced {
203 
204     // MEMBERS
205     string public name;
206 
207     string public symbol;
208 
209     uint8 public decimals;
210 
211     // CONSTRUCTOR
212     function Front(
213         string _name,
214         string _symbol,
215         uint8 _decimals,
216         address _custodian
217     )
218         DeloCanBeReplaced(_custodian)
219         public
220     {
221         name = _name;
222         symbol = _symbol;
223         decimals = _decimals;
224     }
225 
226     // PUBLIC FUNCTIONS
227     // (ERC20Interface)
228     function totalSupply() public view returns (uint256) {
229         return delo.totalSupply();
230     }
231 
232     function balanceOf(address _owner) public view returns (uint256 balance) {
233         return delo.balanceOf(_owner);
234     }
235 
236     function emitTransfer(address _from, address _to, uint256 _value) public onlyDelo {
237         emit Transfer(_from, _to, _value);
238     }
239 
240     function transfer(address _to, uint256 _value) public returns (bool success) {
241         return delo.transferWithSender(msg.sender, _to, _value);
242     }
243 
244     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
245         return delo.transferFromWithSender(msg.sender, _from, _to, _value);
246     }
247 
248     function emitApproval(address _owner, address _spender, uint256 _value) public onlyDelo {
249         emit Approval(_owner, _spender, _value);
250     }
251 
252     function approve(address _spender, uint256 _value) public returns (bool success) {
253         return delo.approveWithSender(msg.sender, _spender, _value);
254     }
255 
256     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
257         return delo.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
258     }
259 
260     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
261         return delo.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
262     }
263 
264     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
265         return delo.allowance(_owner, _spender);
266     }
267 }
268 
269 
270 contract Delo is CustodianCanBeReplaced {
271 
272     // TYPES
273     struct PendingPrint {
274         address receiver;
275         uint256 value;
276     }
277 
278     // MEMBERS
279     Front public front;
280 
281     Grossbuch public grossbuch;
282 
283     address public sweeper;
284 
285     bytes32 public sweepMsg;
286 
287     mapping (address => bool) public sweptSet;
288 
289     mapping (bytes32 => PendingPrint) public pendingPrintMap;
290 
291     // CONSTRUCTOR
292     function Delo(
293           address _front,
294           address _grossbuch,
295           address _custodian,
296           address _sweeper
297     )
298         CustodianCanBeReplaced(_custodian)
299         public
300     {
301         require(_sweeper != 0);
302         front = Front(_front);
303         grossbuch = Grossbuch(_grossbuch);
304 
305         sweeper = _sweeper;
306         sweepMsg = keccak256(address(this), "sweep");
307     }
308 
309     // MODIFIERS
310     modifier onlyFront {
311         require(msg.sender == address(front));
312         _;
313     }
314     modifier onlySweeper {
315         require(msg.sender == sweeper);
316         _;
317     }
318 
319 
320     function approveWithSender(
321         address _sender,
322         address _spender,
323         uint256 _value
324     )
325         public
326         onlyFront
327         returns (bool success)
328     {
329         require(_spender != address(0)); // disallow unspendable approvals
330         grossbuch.setAllowance(_sender, _spender, _value);
331         front.emitApproval(_sender, _spender, _value);
332         return true;
333     }
334 
335     function increaseApprovalWithSender(
336         address _sender,
337         address _spender,
338         uint256 _addedValue
339     )
340         public
341         onlyFront
342         returns (bool success)
343     {
344         require(_spender != address(0)); // disallow unspendable approvals
345         uint256 currentAllowance = grossbuch.allowed(_sender, _spender);
346         uint256 newAllowance = currentAllowance + _addedValue;
347 
348         require(newAllowance >= currentAllowance);
349 
350         grossbuch.setAllowance(_sender, _spender, newAllowance);
351         front.emitApproval(_sender, _spender, newAllowance);
352         return true;
353     }
354 
355     function decreaseApprovalWithSender(
356         address _sender,
357         address _spender,
358         uint256 _subtractedValue
359     )
360         public
361         onlyFront
362         returns (bool success)
363     {
364         require(_spender != address(0)); // disallow unspendable approvals
365         uint256 currentAllowance = grossbuch.allowed(_sender, _spender);
366         uint256 newAllowance = currentAllowance - _subtractedValue;
367 
368         require(newAllowance <= currentAllowance);
369 
370         grossbuch.setAllowance(_sender, _spender, newAllowance);
371         front.emitApproval(_sender, _spender, newAllowance);
372         return true;
373     }
374 
375 
376     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 zamokId) {
377         require(_receiver != address(0));
378 
379         zamokId = generateZamokId();
380 
381         pendingPrintMap[zamokId] = PendingPrint({
382             receiver: _receiver,
383             value: _value
384         });
385 
386         emit PrintingLocked(zamokId, _receiver, _value);
387     }
388 
389 
390     function confirmPrint(bytes32 _zamokId) public onlyCustodian {
391         PendingPrint storage print = pendingPrintMap[_zamokId];
392 
393         // reject ‘null’ results from the map lookup
394         // this can only be the case if an unknown `_zamokId` is received
395         address receiver = print.receiver;
396         require (receiver != address(0));
397         uint256 value = print.value;
398 
399         delete pendingPrintMap[_zamokId];
400 
401         uint256 supply = grossbuch.totalSupply();
402         uint256 newSupply = supply + value;
403         if (newSupply >= supply) {
404           grossbuch.setTotalSupply(newSupply);
405           grossbuch.addBalance(receiver, value);
406 
407           emit PrintingConfirmed(_zamokId, receiver, value);
408           front.emitTransfer(address(0), receiver, value);
409         }
410     }
411 
412 
413     function burn(uint256 _value) public returns (bool success) {
414         uint256 balanceOfSender = grossbuch.balances(msg.sender);
415         require(_value <= balanceOfSender);
416 
417         grossbuch.setBalance(msg.sender, balanceOfSender - _value);
418         grossbuch.setTotalSupply(grossbuch.totalSupply() - _value);
419 
420         front.emitTransfer(msg.sender, address(0), _value);
421 
422         return true;
423     }
424 
425 
426     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool success) {
427         require(_tos.length == _values.length);
428 
429         uint256 numTransfers = _tos.length;
430         uint256 senderBalance = grossbuch.balances(msg.sender);
431 
432         for (uint256 i = 0; i < numTransfers; i++) {
433           address to = _tos[i];
434           require(to != address(0));
435           uint256 v = _values[i];
436           require(senderBalance >= v);
437 
438           if (msg.sender != to) {
439             senderBalance -= v;
440             grossbuch.addBalance(to, v);
441           }
442           front.emitTransfer(msg.sender, to, v);
443         }
444 
445         grossbuch.setBalance(msg.sender, senderBalance);
446 
447         return true;
448     }
449 
450     function enableSweep(uint8[] _vs, bytes32[] _rs, bytes32[] _ss, address _to) public onlySweeper {
451         require(_to != address(0));
452         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
453 
454         uint256 numSignatures = _vs.length;
455         uint256 sweptBalance = 0;
456 
457         for (uint256 i=0; i<numSignatures; ++i) {
458           address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
459 
460           // ecrecover returns 0 on malformed input
461           if (from != address(0)) {
462             sweptSet[from] = true;
463 
464             uint256 fromBalance = grossbuch.balances(from);
465 
466             if (fromBalance > 0) {
467               sweptBalance += fromBalance;
468 
469               grossbuch.setBalance(from, 0);
470 
471               front.emitTransfer(from, _to, fromBalance);
472             }
473           }
474         }
475 
476         if (sweptBalance > 0) {
477           grossbuch.addBalance(_to, sweptBalance);
478         }
479     }
480 
481     function replaySweep(address[] _froms, address _to) public onlySweeper {
482         require(_to != address(0));
483         uint256 lenFroms = _froms.length;
484         uint256 sweptBalance = 0;
485 
486         for (uint256 i=0; i<lenFroms; ++i) {
487             address from = _froms[i];
488 
489             if (sweptSet[from]) {
490                 uint256 fromBalance = grossbuch.balances(from);
491 
492                 if (fromBalance > 0) {
493                     sweptBalance += fromBalance;
494 
495                     grossbuch.setBalance(from, 0);
496 
497                     front.emitTransfer(from, _to, fromBalance);
498                 }
499             }
500         }
501 
502         if (sweptBalance > 0) {
503             grossbuch.addBalance(_to, sweptBalance);
504         }
505     }
506 
507     function transferFromWithSender(
508         address _sender,
509         address _from,
510         address _to,
511         uint256 _value
512     )
513         public
514         onlyFront
515         returns (bool success)
516     {
517         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
518 
519         uint256 balanceOfFrom = grossbuch.balances(_from);
520         require(_value <= balanceOfFrom);
521 
522         uint256 senderAllowance = grossbuch.allowed(_from, _sender);
523         require(_value <= senderAllowance);
524 
525         grossbuch.setBalance(_from, balanceOfFrom - _value);
526         grossbuch.addBalance(_to, _value);
527 
528         grossbuch.setAllowance(_from, _sender, senderAllowance - _value);
529 
530         front.emitTransfer(_from, _to, _value);
531 
532         return true;
533     }
534 
535     function transferWithSender(
536         address _sender,
537         address _to,
538         uint256 _value
539     )
540         public
541         onlyFront
542         returns (bool success)
543     {
544         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
545 
546         uint256 balanceOfSender = grossbuch.balances(_sender);
547         require(_value <= balanceOfSender);
548 
549         grossbuch.setBalance(_sender, balanceOfSender - _value);
550         grossbuch.addBalance(_to, _value);
551 
552         front.emitTransfer(_sender, _to, _value);
553 
554         return true;
555     }
556 
557     // METHODS (ERC20 sub interface impl.)
558     function totalSupply() public view returns (uint256) {
559         return grossbuch.totalSupply();
560     }
561 
562     function balanceOf(address _owner) public view returns (uint256 balance) {
563         return grossbuch.balances(_owner);
564     }
565 
566     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
567         return grossbuch.allowed(_owner, _spender);
568     }
569 
570     // EVENTS
571     event PrintingLocked(bytes32 _zamokId, address _receiver, uint256 _value);
572 
573     event PrintingConfirmed(bytes32 _zamokId, address _receiver, uint256 _value);
574 }
575 
576 
577 
578 contract Grossbuch is DeloCanBeReplaced {
579 
580     // MEMBERS
581     uint256 public totalSupply;
582 
583     mapping (address => uint256) public balances;
584 
585     mapping (address => mapping (address => uint256)) public allowed;
586 
587     // CONSTRUCTOR
588     function Grossbuch(address _custodian) DeloCanBeReplaced(_custodian) public {
589         totalSupply = 0;
590     }
591 
592 
593     // PUBLIC FUNCTIONS
594 
595     function setTotalSupply(
596         uint256 _newTotalSupply
597     )
598         public
599         onlyDelo
600     {
601         totalSupply = _newTotalSupply;
602     }
603 
604 
605     function setAllowance(
606         address _owner,
607         address _spender,
608         uint256 _value
609     )
610         public
611         onlyDelo
612     {
613         allowed[_owner][_spender] = _value;
614     }
615 
616 
617     function setBalance(
618         address _owner,
619         uint256 _newBalance
620     )
621         public
622         onlyDelo
623     {
624         balances[_owner] = _newBalance;
625     }
626 
627 
628     function addBalance(
629         address _owner,
630         uint256 _balanceIncrease
631     )
632         public
633         onlyDelo
634     {
635         balances[_owner] = balances[_owner] + _balanceIncrease;
636     }
637 }