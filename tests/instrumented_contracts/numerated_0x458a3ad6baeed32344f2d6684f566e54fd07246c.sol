1 pragma solidity ^0.4.21;
2 contract LockRequestable {
3     uint256 public lockRequestCount;
4     function LockRequestable() public {
5         lockRequestCount = 0;
6     }
7     function generateLockId() internal returns (bytes32 lockId) {
8         return keccak256(block.blockhash(block.number - 1), address(this), ++lockRequestCount);
9     }
10 }
11 contract CustodianUpgradeable is LockRequestable {
12     struct CustodianChangeRequest {
13         address proposedNew;
14     }
15     address public custodian;
16     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
17     function CustodianUpgradeable(
18         address _custodian
19     )
20       LockRequestable()
21       public
22     {
23         custodian = _custodian;
24     }
25     modifier onlyCustodian {
26         require(msg.sender == custodian);
27         _;
28     }
29     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
30         require(_proposedCustodian != address(0));
31         lockId = generateLockId();
32         custodianChangeReqs[lockId] = CustodianChangeRequest({
33             proposedNew: _proposedCustodian
34         });
35         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
36     }
37     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
38         custodian = getCustodianChangeReq(_lockId);
39         delete custodianChangeReqs[_lockId];
40         emit CustodianChangeConfirmed(_lockId, custodian);
41     }
42     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
43         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
44         require(changeRequest.proposedNew != 0);
45         return changeRequest.proposedNew;
46     }
47     event CustodianChangeRequested(
48         bytes32 _lockId,
49         address _msgSender,
50         address _proposedCustodian
51     );
52     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
53 }
54 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
55     struct ImplChangeRequest {
56         address proposedNew;
57     }
58     ERC20Impl public erc20Impl;
59     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
60     function ERC20ImplUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
61         erc20Impl = ERC20Impl(0x0);
62     }
63     modifier onlyImpl {
64         require(msg.sender == address(erc20Impl));
65         _;
66     }
67     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
68         require(_proposedImpl != address(0));
69         lockId = generateLockId();
70         implChangeReqs[lockId] = ImplChangeRequest({
71             proposedNew: _proposedImpl
72         });
73         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
74     }
75     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
76         erc20Impl = getImplChangeReq(_lockId);
77         delete implChangeReqs[_lockId];
78         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
79     }
80     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
81         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
82         require(changeRequest.proposedNew != address(0));
83         return ERC20Impl(changeRequest.proposedNew);
84     }
85     event ImplChangeRequested(
86         bytes32 _lockId,
87         address _msgSender,
88         address _proposedImpl
89     );
90     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
91 }
92 contract ERC20Interface {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address _owner) public view returns (uint256 balance);
95   function transfer(address _to, uint256 _value) public returns (bool success);
96   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
97   function approve(address _spender, uint256 _value) public returns (bool success);
98   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99   event Transfer(address indexed _from, address indexed _to, uint256 _value);
100   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101 }
102 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
103     string public name;
104     string public symbol;
105     uint8 public decimals;
106     function ERC20Proxy(
107         string _name,
108         string _symbol,
109         uint8 _decimals,
110         address _custodian
111     )
112         ERC20ImplUpgradeable(_custodian)
113         public
114     {
115         name = _name;
116         symbol = _symbol;
117         decimals = _decimals;
118     }
119     function totalSupply() public view returns (uint256) {
120         return erc20Impl.totalSupply();
121     }
122     function balanceOf(address _owner) public view returns (uint256 balance) {
123         return erc20Impl.balanceOf(_owner);
124     }
125     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
126         emit Transfer(_from, _to, _value);
127     }
128     function transfer(address _to, uint256 _value) public returns (bool success) {
129         return erc20Impl.transferWithSender(msg.sender, _to, _value);
130     }
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
133     }
134     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
135         emit Approval(_owner, _spender, _value);
136     }
137     function approve(address _spender, uint256 _value) public returns (bool success) {
138         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
139     }
140     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
141         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
142     }
143     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
144         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
145     }
146     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
147         return erc20Impl.allowance(_owner, _spender);
148     }
149     function burn(uint256 _value) public returns (bool success) {
150       return erc20Impl.burnWithSender(msg.sender, _value);
151     }
152 }
153 contract ERC20Impl is CustodianUpgradeable {
154     struct PendingPrint {
155         address receiver;
156         uint256 value;
157     }
158     ERC20Proxy public erc20Proxy;
159     ERC20Store public erc20Store;
160     address public sweeper;
161     bytes32 public sweepMsg;
162     mapping (address => bool) public sweptSet;
163     mapping (bytes32 => PendingPrint) public pendingPrintMap;
164     function ERC20Impl(
165           address _erc20Proxy,
166           address _erc20Store,
167           address _custodian,
168           address _sweeper
169     )
170         CustodianUpgradeable(_custodian)
171         public
172     {
173         require(_sweeper != 0);
174         erc20Proxy = ERC20Proxy(_erc20Proxy);
175         erc20Store = ERC20Store(_erc20Store);
176         sweeper = _sweeper;
177         sweepMsg = keccak256(address(this), "sweep");
178     }
179     modifier onlyProxy {
180         require(msg.sender == address(erc20Proxy));
181         _;
182     }
183     modifier onlySweeper {
184         require(msg.sender == sweeper);
185         _;
186     }
187     function approveWithSender(
188         address _sender,
189         address _spender,
190         uint256 _value
191     )
192         public
193         onlyProxy
194         returns (bool success)
195     {
196         require(_spender != address(0));
197         erc20Store.setAllowance(_sender, _spender, _value);
198         erc20Proxy.emitApproval(_sender, _spender, _value);
199         return true;
200     }
201     function increaseApprovalWithSender(
202         address _sender,
203         address _spender,
204         uint256 _addedValue
205     )
206         public
207         onlyProxy
208         returns (bool success)
209     {
210         require(_spender != address(0));
211         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
212         uint256 newAllowance = currentAllowance + _addedValue;
213         require(newAllowance >= currentAllowance);
214         erc20Store.setAllowance(_sender, _spender, newAllowance);
215         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
216         return true;
217     }
218     function decreaseApprovalWithSender(
219         address _sender,
220         address _spender,
221         uint256 _subtractedValue
222     )
223         public
224         onlyProxy
225         returns (bool success)
226     {
227         require(_spender != address(0));
228         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
229         uint256 newAllowance = currentAllowance - _subtractedValue;
230         require(newAllowance <= currentAllowance);
231         erc20Store.setAllowance(_sender, _spender, newAllowance);
232         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
233         return true;
234     }
235     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
236         require(_receiver != address(0));
237         lockId = generateLockId();
238         pendingPrintMap[lockId] = PendingPrint({
239             receiver: _receiver,
240             value: _value
241         });
242         emit PrintingLocked(lockId, _receiver, _value);
243     }
244     function confirmPrint(bytes32 _lockId) public onlyCustodian {
245         PendingPrint storage print = pendingPrintMap[_lockId];
246         address receiver = print.receiver;
247         require (receiver != address(0));
248         uint256 value = print.value;
249         delete pendingPrintMap[_lockId];
250         uint256 supply = erc20Store.totalSupply();
251         uint256 newSupply = supply + value;
252         if (newSupply >= supply) {
253           erc20Store.setTotalSupply(newSupply);
254           erc20Store.addBalance(receiver, value);
255           emit PrintingConfirmed(_lockId, receiver, value);
256           erc20Proxy.emitTransfer(address(0), receiver, value);
257         }
258     }
259     function burn(uint256 _value) public returns (bool success) {
260         uint256 balanceOfSender = erc20Store.balances(msg.sender);
261         require(_value <= balanceOfSender);
262         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
263         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
264         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
265         return true;
266     }
267     function burnWithSender(address _sender, uint256 _value) public onlyProxy returns (bool success) {
268         uint256 balanceOfSender = erc20Store.balances(_sender);
269         require(_value <= balanceOfSender);
270         erc20Store.setBalance(_sender, balanceOfSender - _value);
271         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
272         erc20Proxy.emitTransfer(_sender, address(0), _value);
273         return true;
274     }
275     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool success) {
276         require(_tos.length == _values.length);
277         uint256 numTransfers = _tos.length;
278         uint256 senderBalance = erc20Store.balances(msg.sender);
279         for (uint256 i = 0; i < numTransfers; i++) {
280           address to = _tos[i];
281           require(to != address(0));
282           uint256 v = _values[i];
283           require(senderBalance >= v);
284           if (msg.sender != to) {
285             senderBalance -= v;
286             erc20Store.addBalance(to, v);
287           }
288           erc20Proxy.emitTransfer(msg.sender, to, v);
289         }
290         erc20Store.setBalance(msg.sender, senderBalance);
291         return true;
292     }
293     function enableSweep(uint8[] _vs, bytes32[] _rs, bytes32[] _ss, address _to) public onlySweeper {
294         require(_to != address(0));
295         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
296         uint256 numSignatures = _vs.length;
297         uint256 sweptBalance = 0;
298         for (uint256 i=0; i<numSignatures; ++i) {
299           address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
300           if (from != address(0)) {
301             sweptSet[from] = true;
302             uint256 fromBalance = erc20Store.balances(from);
303             if (fromBalance > 0) {
304               sweptBalance += fromBalance;
305               erc20Store.setBalance(from, 0);
306               erc20Proxy.emitTransfer(from, _to, fromBalance);
307             }
308           }
309         }
310         if (sweptBalance > 0) {
311           erc20Store.addBalance(_to, sweptBalance);
312         }
313     }
314     function replaySweep(address[] _froms, address _to) public onlySweeper {
315         require(_to != address(0));
316         uint256 lenFroms = _froms.length;
317         uint256 sweptBalance = 0;
318         for (uint256 i=0; i<lenFroms; ++i) {
319             address from = _froms[i];
320             if (sweptSet[from]) {
321                 uint256 fromBalance = erc20Store.balances(from);
322                 if (fromBalance > 0) {
323                     sweptBalance += fromBalance;
324                     erc20Store.setBalance(from, 0);
325                     erc20Proxy.emitTransfer(from, _to, fromBalance);
326                 }
327             }
328         }
329         if (sweptBalance > 0) {
330             erc20Store.addBalance(_to, sweptBalance);
331         }
332     }
333     function transferFromWithSender(
334         address _sender,
335         address _from,
336         address _to,
337         uint256 _value
338     )
339         public
340         onlyProxy
341         returns (bool success)
342     {
343         require(_to != address(0));
344         uint256 balanceOfFrom = erc20Store.balances(_from);
345         require(_value <= balanceOfFrom);
346         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
347         require(_value <= senderAllowance);
348         erc20Store.setBalance(_from, balanceOfFrom - _value);
349         erc20Store.addBalance(_to, _value);
350         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
351         erc20Proxy.emitTransfer(_from, _to, _value);
352         return true;
353     }
354     function transferWithSender(
355         address _sender,
356         address _to,
357         uint256 _value
358     )
359         public
360         onlyProxy
361         returns (bool success)
362     {
363         require(_to != address(0));
364         uint256 balanceOfSender = erc20Store.balances(_sender);
365         require(_value <= balanceOfSender);
366         erc20Store.setBalance(_sender, balanceOfSender - _value);
367         erc20Store.addBalance(_to, _value);
368         erc20Proxy.emitTransfer(_sender, _to, _value);
369         return true;
370     }
371     function totalSupply() public view returns (uint256) {
372         return erc20Store.totalSupply();
373     }
374     function balanceOf(address _owner) public view returns (uint256 balance) {
375         return erc20Store.balances(_owner);
376     }
377     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
378         return erc20Store.allowed(_owner, _spender);
379     }
380     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
381     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
382 }
383 contract ERC20Store is ERC20ImplUpgradeable {
384     uint256 public totalSupply;
385     mapping (address => uint256) public balances;
386     mapping (address => mapping (address => uint256)) public allowed;
387     function ERC20Store(address _custodian) ERC20ImplUpgradeable(_custodian) public {
388         totalSupply = 0;
389     }
390     function setTotalSupply(
391         uint256 _newTotalSupply
392     )
393         public
394         onlyImpl
395     {
396         totalSupply = _newTotalSupply;
397     }
398     function setAllowance(
399         address _owner,
400         address _spender,
401         uint256 _value
402     )
403         public
404         onlyImpl
405     {
406         allowed[_owner][_spender] = _value;
407     }
408     function setBalance(
409         address _owner,
410         uint256 _newBalance
411     )
412         public
413         onlyImpl
414     {
415         balances[_owner] = _newBalance;
416     }
417     function addBalance(
418         address _owner,
419         uint256 _balanceIncrease
420     )
421         public
422         onlyImpl
423     {
424         balances[_owner] = balances[_owner] + _balanceIncrease;
425     }
426 }
427 contract PrintLimiter is LockRequestable {
428     struct PendingCeilingRaise {
429         uint256 raiseBy;
430     }
431     ERC20Impl public erc20Impl;
432     address public custodian;
433     address public limitedPrinter;
434     uint256 public totalSupplyCeiling;
435     mapping (bytes32 => PendingCeilingRaise) public pendingRaiseMap;
436     function PrintLimiter(
437         address _erc20Impl,
438         address _custodian,
439         address _limitedPrinter,
440         uint256 _initialCeiling
441     )
442         public
443     {
444         erc20Impl = ERC20Impl(_erc20Impl);
445         custodian = _custodian;
446         limitedPrinter = _limitedPrinter;
447         totalSupplyCeiling = _initialCeiling;
448     }
449     modifier onlyCustodian {
450         require(msg.sender == custodian);
451         _;
452     }
453     modifier onlyLimitedPrinter {
454         require(msg.sender == limitedPrinter);
455         _;
456     }
457     function limitedPrint(address _receiver, uint256 _value) public onlyLimitedPrinter {
458         uint256 totalSupply = erc20Impl.totalSupply();
459         uint256 newTotalSupply = totalSupply + _value;
460         require(newTotalSupply >= totalSupply);
461         require(newTotalSupply <= totalSupplyCeiling);
462         erc20Impl.confirmPrint(erc20Impl.requestPrint(_receiver, _value));
463     }
464     function requestCeilingRaise(uint256 _raiseBy) public returns (bytes32 lockId) {
465         require(_raiseBy != 0);
466         lockId = generateLockId();
467         pendingRaiseMap[lockId] = PendingCeilingRaise({
468             raiseBy: _raiseBy
469         });
470         emit CeilingRaiseLocked(lockId, _raiseBy);
471     }
472     function confirmCeilingRaise(bytes32 _lockId) public onlyCustodian {
473         PendingCeilingRaise storage pendingRaise = pendingRaiseMap[_lockId];
474         uint256 raiseBy = pendingRaise.raiseBy;
475         require(raiseBy != 0);
476         delete pendingRaiseMap[_lockId];
477         uint256 newCeiling = totalSupplyCeiling + raiseBy;
478         if (newCeiling >= totalSupplyCeiling) {
479             totalSupplyCeiling = newCeiling;
480             emit CeilingRaiseConfirmed(_lockId, raiseBy, newCeiling);
481         }
482     }
483     function lowerCeiling(uint256 _lowerBy) public onlyLimitedPrinter {
484         uint256 newCeiling = totalSupplyCeiling - _lowerBy;
485         require(newCeiling <= totalSupplyCeiling);
486         totalSupplyCeiling = newCeiling;
487         emit CeilingLowered(_lowerBy, newCeiling);
488     }
489     function confirmPrintProxy(bytes32 _lockId) public onlyCustodian {
490         erc20Impl.confirmPrint(_lockId);
491     }
492     function confirmCustodianChangeProxy(bytes32 _lockId) public onlyCustodian {
493         erc20Impl.confirmCustodianChange(_lockId);
494     }
495     event CeilingRaiseLocked(bytes32 _lockId, uint256 _raiseBy);
496     event CeilingRaiseConfirmed(bytes32 _lockId, uint256 _raiseBy, uint256 _newCeiling);
497     event CeilingLowered(uint256 _lowerBy, uint256 _newCeiling);
498 }