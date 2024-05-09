1 pragma solidity ^0.4.21;
2 
3 /** @title  KRWT contract
4   *
5   * @author  Hansung Future Co.,Ltd
6   */
7 contract LockRequestable {
8 
9     uint256 public lockRequestCount;
10 
11     function LockRequestable() public {
12         lockRequestCount = 0;
13     }
14 
15     function generateLockId() internal returns (bytes32 lockId) {
16         return keccak256(block.blockhash(block.number - 1), address(this), ++lockRequestCount);
17     }
18 }
19 
20 
21 /** @title  KRWT contract
22   *
23   * @author  Hansung Future Co.,Ltd
24   */
25 contract CustodianUpgradeable is LockRequestable {
26 
27     struct CustodianChangeRequest {
28         address proposedNew;
29     }
30 
31     address public custodian;
32 
33     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
34 
35     function CustodianUpgradeable(
36         address _custodian
37     )
38       LockRequestable()
39       public
40     {
41         custodian = _custodian;
42     }
43 
44     modifier onlyCustodian {
45         require(msg.sender == custodian);
46         _;
47     }
48 
49     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
50         require(_proposedCustodian != address(0));
51 
52         lockId = generateLockId();
53 
54         custodianChangeReqs[lockId] = CustodianChangeRequest({
55             proposedNew: _proposedCustodian
56         });
57 
58         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
59     }
60 
61     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
62         custodian = getCustodianChangeReq(_lockId);
63 
64         delete custodianChangeReqs[_lockId];
65 
66         emit CustodianChangeConfirmed(_lockId, custodian);
67     }
68 
69     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
70         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
71 
72         require(changeRequest.proposedNew != 0);
73 
74         return changeRequest.proposedNew;
75     }
76 
77     event CustodianChangeRequested(
78         bytes32 _lockId,
79         address _msgSender,
80         address _proposedCustodian
81     );
82 
83     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
84 }
85 
86 
87 /** @title  KRWT contract
88   *
89   * @author  Hansung Future Co.,Ltd
90   */
91 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
92 
93     struct ImplChangeRequest {
94         address proposedNew;
95     }
96 
97     ERC20Impl public erc20Impl;
98 
99     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
100 
101     function ERC20ImplUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
102         erc20Impl = ERC20Impl(0x0);
103     }
104 
105     modifier onlyImpl {
106         require(msg.sender == address(erc20Impl));
107         _;
108     }
109 
110     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
111         require(_proposedImpl != address(0));
112 
113         lockId = generateLockId();
114 
115         implChangeReqs[lockId] = ImplChangeRequest({
116             proposedNew: _proposedImpl
117         });
118 
119         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
120     }
121 
122     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
123         erc20Impl = getImplChangeReq(_lockId);
124 
125         delete implChangeReqs[_lockId];
126 
127         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
128     }
129 
130     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
131         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
132 
133         require(changeRequest.proposedNew != address(0));
134 
135         return ERC20Impl(changeRequest.proposedNew);
136     }
137 
138     event ImplChangeRequested(
139         bytes32 _lockId,
140         address _msgSender,
141         address _proposedImpl
142     );
143 
144     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
145 }
146 
147 /** @title  KRWT contract
148   *
149   * @author  Hansung Future Co.,Ltd
150   */
151 contract ERC20Interface {
152   function totalSupply() public view returns (uint256);
153 
154   function balanceOf(address _owner) public view returns (uint256 balance);
155 
156   function transfer(address _to, uint256 _value) public returns (bool success);
157 
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
159 
160   function approve(address _spender, uint256 _value) public returns (bool success);
161 
162   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
163 
164   event Transfer(address indexed _from, address indexed _to, uint256 _value);
165 
166   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
167 }
168 
169 /** @title  KRWT contract
170   *
171   * @author  Hansung Future Co.,Ltd
172   */
173 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
174 
175     string public name;
176 
177     string public symbol;
178 
179     uint8 public decimals;
180 
181     function ERC20Proxy(
182         string _name,
183         string _symbol,
184         uint8 _decimals,
185         address _custodian
186     )
187         ERC20ImplUpgradeable(_custodian)
188         public
189     {
190         name = _name;
191         symbol = _symbol;
192         decimals = _decimals;
193     }
194 
195     function totalSupply() public view returns (uint256) {
196         return erc20Impl.totalSupply();
197     }
198 
199     function balanceOf(address _owner) public view returns (uint256 balance) {
200         return erc20Impl.balanceOf(_owner);
201     }
202 
203     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
204         emit Transfer(_from, _to, _value);
205     }
206 
207     function transfer(address _to, uint256 _value) public returns (bool success) {
208         return erc20Impl.transferWithSender(msg.sender, _to, _value);
209     }
210 
211     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
212         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
213     }
214 
215     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
216         emit Approval(_owner, _spender, _value);
217     }
218 
219     function approve(address _spender, uint256 _value) public returns (bool success) {
220         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
221     }
222 
223     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
224         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
225     }
226 
227     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
228         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
229     }
230 
231     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
232         return erc20Impl.allowance(_owner, _spender);
233     }
234 }
235 
236 /** @title  KRWT contract
237   *
238   * @author  Hansung Future Co.,Ltd
239   */
240 contract ERC20Impl is CustodianUpgradeable {
241 
242     struct PendingPrint {
243         address receiver;
244         uint256 value;
245     }
246 
247     ERC20Proxy public erc20Proxy;
248 
249     ERC20Store public erc20Store;
250 
251     address public sweeper;
252 
253     bytes32 public sweepMsg;
254 
255     mapping (address => bool) public sweptSet;
256 
257     mapping (bytes32 => PendingPrint) public pendingPrintMap;
258 
259     function ERC20Impl(
260           address _erc20Proxy,
261           address _erc20Store,
262           address _custodian,
263           address _sweeper
264     )
265         CustodianUpgradeable(_custodian)
266         public
267     {
268         require(_sweeper != 0);
269         erc20Proxy = ERC20Proxy(_erc20Proxy);
270         erc20Store = ERC20Store(_erc20Store);
271 
272         sweeper = _sweeper;
273         sweepMsg = keccak256(address(this), "sweep");
274     }
275 
276     modifier onlyProxy {
277         require(msg.sender == address(erc20Proxy));
278         _;
279     }
280     modifier onlySweeper {
281         require(msg.sender == sweeper);
282         _;
283     }
284 
285 
286     function approveWithSender(
287         address _sender,
288         address _spender,
289         uint256 _value
290     )
291         public
292         onlyProxy
293         returns (bool success)
294     {
295         require(_spender != address(0));
296         erc20Store.setAllowance(_sender, _spender, _value);
297         erc20Proxy.emitApproval(_sender, _spender, _value);
298         return true;
299     }
300 
301     function increaseApprovalWithSender(
302         address _sender,
303         address _spender,
304         uint256 _addedValue
305     )
306         public
307         onlyProxy
308         returns (bool success)
309     {
310         require(_spender != address(0));
311         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
312         uint256 newAllowance = currentAllowance + _addedValue;
313 
314         require(newAllowance >= currentAllowance);
315 
316         erc20Store.setAllowance(_sender, _spender, newAllowance);
317         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
318         return true;
319     }
320 
321     function decreaseApprovalWithSender(
322         address _sender,
323         address _spender,
324         uint256 _subtractedValue
325     )
326         public
327         onlyProxy
328         returns (bool success)
329     {
330         require(_spender != address(0));
331         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
332         uint256 newAllowance = currentAllowance - _subtractedValue;
333 
334         require(newAllowance <= currentAllowance);
335 
336         erc20Store.setAllowance(_sender, _spender, newAllowance);
337         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
338         return true;
339     }
340 
341     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
342         require(_receiver != address(0));
343 
344         lockId = generateLockId();
345 
346         pendingPrintMap[lockId] = PendingPrint({
347             receiver: _receiver,
348             value: _value
349         });
350 
351         emit PrintingLocked(lockId, _receiver, _value);
352     }
353 
354     function confirmPrint(bytes32 _lockId) public onlyCustodian {
355         PendingPrint storage print = pendingPrintMap[_lockId];
356 
357         address receiver = print.receiver;
358         require (receiver != address(0));
359         uint256 value = print.value;
360 
361         delete pendingPrintMap[_lockId];
362 
363         uint256 supply = erc20Store.totalSupply();
364         uint256 newSupply = supply + value;
365         if (newSupply >= supply) {
366           erc20Store.setTotalSupply(newSupply);
367           erc20Store.addBalance(receiver, value);
368 
369           emit PrintingConfirmed(_lockId, receiver, value);
370           erc20Proxy.emitTransfer(address(0), receiver, value);
371         }
372     }
373 
374     function burn(uint256 _value) public returns (bool success) {
375         uint256 balanceOfSender = erc20Store.balances(msg.sender);
376         require(_value <= balanceOfSender);
377 
378         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
379         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
380 
381         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
382 
383         return true;
384     }
385 
386     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool success) {
387         require(_tos.length == _values.length);
388 
389         uint256 numTransfers = _tos.length;
390         uint256 senderBalance = erc20Store.balances(msg.sender);
391 
392         for (uint256 i = 0; i < numTransfers; i++) {
393           address to = _tos[i];
394           require(to != address(0));
395           uint256 v = _values[i];
396           require(senderBalance >= v);
397 
398           if (msg.sender != to) {
399             senderBalance -= v;
400             erc20Store.addBalance(to, v);
401           }
402           erc20Proxy.emitTransfer(msg.sender, to, v);
403         }
404 
405         erc20Store.setBalance(msg.sender, senderBalance);
406 
407         return true;
408     }
409 
410     function enableSweep(uint8[] _vs, bytes32[] _rs, bytes32[] _ss, address _to) public onlySweeper {
411         require(_to != address(0));
412         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
413 
414         uint256 numSignatures = _vs.length;
415         uint256 sweptBalance = 0;
416 
417         for (uint256 i=0; i<numSignatures; ++i) {
418           address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
419 
420           if (from != address(0)) {
421             sweptSet[from] = true;
422 
423             uint256 fromBalance = erc20Store.balances(from);
424 
425             if (fromBalance > 0) {
426               sweptBalance += fromBalance;
427 
428               erc20Store.setBalance(from, 0);
429 
430               erc20Proxy.emitTransfer(from, _to, fromBalance);
431             }
432           }
433         }
434 
435         if (sweptBalance > 0) {
436           erc20Store.addBalance(_to, sweptBalance);
437         }
438     }
439 
440     function replaySweep(address[] _froms, address _to) public onlySweeper {
441         require(_to != address(0));
442         uint256 lenFroms = _froms.length;
443         uint256 sweptBalance = 0;
444 
445         for (uint256 i=0; i<lenFroms; ++i) {
446             address from = _froms[i];
447 
448             if (sweptSet[from]) {
449                 uint256 fromBalance = erc20Store.balances(from);
450 
451                 if (fromBalance > 0) {
452                     sweptBalance += fromBalance;
453 
454                     erc20Store.setBalance(from, 0);
455 
456                     erc20Proxy.emitTransfer(from, _to, fromBalance);
457                 }
458             }
459         }
460 
461         if (sweptBalance > 0) {
462             erc20Store.addBalance(_to, sweptBalance);
463         }
464     }
465 
466     function transferFromWithSender(
467         address _sender,
468         address _from,
469         address _to,
470         uint256 _value
471     )
472         public
473         onlyProxy
474         returns (bool success)
475     {
476         require(_to != address(0));
477 
478         uint256 balanceOfFrom = erc20Store.balances(_from);
479         require(_value <= balanceOfFrom);
480 
481         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
482         require(_value <= senderAllowance);
483 
484         erc20Store.setBalance(_from, balanceOfFrom - _value);
485         erc20Store.addBalance(_to, _value);
486 
487         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
488 
489         erc20Proxy.emitTransfer(_from, _to, _value);
490 
491         return true;
492     }
493 
494     function transferWithSender(
495         address _sender,
496         address _to,
497         uint256 _value
498     )
499         public
500         onlyProxy
501         returns (bool success)
502     {
503         require(_to != address(0));
504 
505         uint256 balanceOfSender = erc20Store.balances(_sender);
506         require(_value <= balanceOfSender);
507 
508         erc20Store.setBalance(_sender, balanceOfSender - _value);
509         erc20Store.addBalance(_to, _value);
510 
511         erc20Proxy.emitTransfer(_sender, _to, _value);
512 
513         return true;
514     }
515 
516     function totalSupply() public view returns (uint256) {
517         return erc20Store.totalSupply();
518     }
519 
520     function balanceOf(address _owner) public view returns (uint256 balance) {
521         return erc20Store.balances(_owner);
522     }
523 
524     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
525         return erc20Store.allowed(_owner, _spender);
526     }
527 
528     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
529     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
530 }
531 
532 
533 /** @title  KRWT contract
534   *
535   * @author  Hansung Future Co.,Ltd
536   */
537 contract ERC20Store is ERC20ImplUpgradeable {
538 
539     uint256 public totalSupply;
540 
541     mapping (address => uint256) public balances;
542 
543     mapping (address => mapping (address => uint256)) public allowed;
544 
545     function ERC20Store(address _custodian) ERC20ImplUpgradeable(_custodian) public {
546         totalSupply = 0;
547     }
548 
549     function setTotalSupply(
550         uint256 _newTotalSupply
551     )
552         public
553         onlyImpl
554     {
555         totalSupply = _newTotalSupply;
556     }
557 
558     function setAllowance(
559         address _owner,
560         address _spender,
561         uint256 _value
562     )
563         public
564         onlyImpl
565     {
566         allowed[_owner][_spender] = _value;
567     }
568 
569     function setBalance(
570         address _owner,
571         uint256 _newBalance
572     )
573         public
574         onlyImpl
575     {
576         balances[_owner] = _newBalance;
577     }
578 
579     function addBalance(
580         address _owner,
581         uint256 _balanceIncrease
582     )
583         public
584         onlyImpl
585     {
586         balances[_owner] = balances[_owner] + _balanceIncrease;
587     }
588 }