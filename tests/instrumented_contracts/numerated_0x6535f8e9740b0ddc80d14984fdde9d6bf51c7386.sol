1 pragma solidity 0.4.23;
2 
3 contract AssetInterface {
4     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) public returns(bool);
5     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
6     function _performApprove(address _spender, uint _value, address _sender) public returns(bool);
7     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
8     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
9     function _performGeneric(bytes, address) public payable {
10         revert();
11     }
12 }
13 
14 contract ERC20Interface {
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed from, address indexed spender, uint256 value);
17 
18     function totalSupply() public view returns(uint256 supply);
19     function balanceOf(address _owner) public view returns(uint256 balance);
20     function transfer(address _to, uint256 _value) public returns(bool success);
21     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
22     function approve(address _spender, uint256 _value) public returns(bool success);
23     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
24 
25     function decimals() public view returns(uint8);
26 }
27 
28 contract AssetProxy is ERC20Interface {
29     function _forwardApprove(address _spender, uint _value, address _sender) public returns(bool);
30     function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
31     function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
32 }
33 
34 contract Bytes32 {
35     function _bytes32(string _input) internal pure returns(bytes32 result) {
36         assembly {
37             result := mload(add(_input, 32))
38         }
39     }
40 }
41 
42 contract ReturnData {
43     function _returnReturnData(bool _success) internal pure {
44         assembly {
45             let returndatastart := 0
46             returndatacopy(returndatastart, 0, returndatasize)
47             switch _success case 0 { revert(returndatastart, returndatasize) } default { return(returndatastart, returndatasize) }
48         }
49     }
50 
51     function _assemblyCall(address _destination, uint _value, bytes _data) internal returns(bool success) {
52         assembly {
53             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
54         }
55     }
56 }
57 
58 /**
59  * @title EToken2 Asset implementation contract.
60  *
61  * Basic asset implementation contract, without any additional logic.
62  * Every other asset implementation contracts should derive from this one.
63  * Receives calls from the proxy, and calls back immediately without arguments modification.
64  *
65  * Note: all the non constant functions return false instead of throwing in case if state change
66  * didn't happen yet.
67  */
68 contract Asset is AssetInterface, Bytes32, ReturnData {
69     // Assigned asset proxy contract, immutable.
70     AssetProxy public proxy;
71 
72     /**
73      * Only assigned proxy is allowed to call.
74      */
75     modifier onlyProxy() {
76         if (proxy == msg.sender) {
77             _;
78         }
79     }
80 
81     /**
82      * Sets asset proxy address.
83      *
84      * Can be set only once.
85      *
86      * @param _proxy asset proxy contract address.
87      *
88      * @return success.
89      * @dev function is final, and must not be overridden.
90      */
91     function init(AssetProxy _proxy) public returns(bool) {
92         if (address(proxy) != 0x0) {
93             return false;
94         }
95         proxy = _proxy;
96         return true;
97     }
98 
99     /**
100      * Passes execution into virtual function.
101      *
102      * Can only be called by assigned asset proxy.
103      *
104      * @return success.
105      * @dev function is final, and must not be overridden.
106      */
107     function _performTransferWithReference(address _to, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
108         if (isICAP(_to)) {
109             return _transferToICAPWithReference(bytes32(_to) << 96, _value, _reference, _sender);
110         }
111         return _transferWithReference(_to, _value, _reference, _sender);
112     }
113 
114     /**
115      * Calls back without modifications.
116      *
117      * @return success.
118      * @dev function is virtual, and meant to be overridden.
119      */
120     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
121         return proxy._forwardTransferFromWithReference(_sender, _to, _value, _reference, _sender);
122     }
123 
124     /**
125      * Passes execution into virtual function.
126      *
127      * Can only be called by assigned asset proxy.
128      *
129      * @return success.
130      * @dev function is final, and must not be overridden.
131      */
132     function _performTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
133         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
134     }
135 
136     /**
137      * Calls back without modifications.
138      *
139      * @return success.
140      * @dev function is virtual, and meant to be overridden.
141      */
142     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
143         return proxy._forwardTransferFromToICAPWithReference(_sender, _icap, _value, _reference, _sender);
144     }
145 
146     /**
147      * Passes execution into virtual function.
148      *
149      * Can only be called by assigned asset proxy.
150      *
151      * @return success.
152      * @dev function is final, and must not be overridden.
153      */
154     function _performTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
155         if (isICAP(_to)) {
156             return _transferFromToICAPWithReference(_from, bytes32(_to) << 96, _value, _reference, _sender);
157         }
158         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
159     }
160 
161     /**
162      * Calls back without modifications.
163      *
164      * @return success.
165      * @dev function is virtual, and meant to be overridden.
166      */
167     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
168         return proxy._forwardTransferFromWithReference(_from, _to, _value, _reference, _sender);
169     }
170 
171     /**
172      * Passes execution into virtual function.
173      *
174      * Can only be called by assigned asset proxy.
175      *
176      * @return success.
177      * @dev function is final, and must not be overridden.
178      */
179     function _performTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public onlyProxy() returns(bool) {
180         return _transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
181     }
182 
183     /**
184      * Calls back without modifications.
185      *
186      * @return success.
187      * @dev function is virtual, and meant to be overridden.
188      */
189     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) internal returns(bool) {
190         return proxy._forwardTransferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
191     }
192 
193     /**
194      * Passes execution into virtual function.
195      *
196      * Can only be called by assigned asset proxy.
197      *
198      * @return success.
199      * @dev function is final, and must not be overridden.
200      */
201     function _performApprove(address _spender, uint _value, address _sender) public onlyProxy() returns(bool) {
202         return _approve(_spender, _value, _sender);
203     }
204 
205     /**
206      * Calls back without modifications.
207      *
208      * @return success.
209      * @dev function is virtual, and meant to be overridden.
210      */
211     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
212         return proxy._forwardApprove(_spender, _value, _sender);
213     }
214 
215     /**
216      * Passes execution into virtual function.
217      *
218      * Can only be called by assigned asset proxy.
219      *
220      * @return bytes32 result.
221      * @dev function is final, and must not be overridden.
222      */
223     function _performGeneric(bytes _data, address _sender) public payable onlyProxy() {
224         _generic(_data, msg.value, _sender);
225     }
226 
227     modifier onlyMe() {
228         if (this == msg.sender) {
229             _;
230         }
231     }
232 
233     // Most probably the following should never be redefined in child contracts.
234     address public genericSender;
235     function _generic(bytes _data, uint _value, address _msgSender) internal {
236         // Restrict reentrancy.
237         require(genericSender == 0x0);
238         genericSender = _msgSender;
239         bool success = _assemblyCall(address(this), _value, _data);
240         delete genericSender;
241         _returnReturnData(success);
242     }
243 
244     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
245     function _sender() internal view returns(address) {
246         return this == msg.sender ? genericSender : msg.sender;
247     }
248 
249     // Interface functions to allow specifying ICAP addresses as strings.
250     function transferToICAP(string _icap, uint _value) public returns(bool) {
251         return transferToICAPWithReference(_icap, _value, '');
252     }
253 
254     function transferToICAPWithReference(string _icap, uint _value, string _reference) public returns(bool) {
255         return _transferToICAPWithReference(_bytes32(_icap), _value, _reference, _sender());
256     }
257 
258     function transferFromToICAP(address _from, string _icap, uint _value) public returns(bool) {
259         return transferFromToICAPWithReference(_from, _icap, _value, '');
260     }
261 
262     function transferFromToICAPWithReference(address _from, string _icap, uint _value, string _reference) public returns(bool) {
263         return _transferFromToICAPWithReference(_from, _bytes32(_icap), _value, _reference, _sender());
264     }
265 
266     function isICAP(address _address) public pure returns(bool) {
267         bytes32 a = bytes32(_address) << 96;
268         if (a[0] != 'X' || a[1] != 'E') {
269             return false;
270         }
271         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
272             return false;
273         }
274         for (uint i = 4; i < 20; i++) {
275             uint char = uint(a[i]);
276             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
277                 return false;
278             }
279         }
280         return true;
281     }
282 }
283 
284 contract Ambi2 {
285     function claimFor(address _address, address _owner) public returns(bool);
286     function hasRole(address _from, bytes32 _role, address _to) public view returns(bool);
287     function isOwner(address _node, address _owner) public view returns(bool);
288 }
289 
290 contract Ambi2Enabled {
291     Ambi2 ambi2;
292 
293     modifier onlyRole(bytes32 _role) {
294         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
295             _;
296         }
297     }
298 
299     // Perform only after claiming the node, or claim in the same tx.
300     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
301         if (address(ambi2) != 0x0) {
302             return false;
303         }
304 
305         ambi2 = _ambi2;
306         return true;
307     }
308 }
309 
310 contract Ambi2EnabledFull is Ambi2Enabled {
311     // Setup and claim atomically.
312     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
313         if (address(ambi2) != 0x0) {
314             return false;
315         }
316         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
317             return false;
318         }
319 
320         ambi2 = _ambi2;
321         return true;
322     }
323 }
324 
325 contract AssetWithAmbi is Asset, Ambi2EnabledFull {
326     modifier onlyRole(bytes32 _role) {
327         if (address(ambi2) != 0x0 && (ambi2.hasRole(this, _role, _sender()))) {
328             _;
329         }
330     }
331 }
332 
333 /**
334  * @title EToken2 Asset with whitelist implementation contract.
335  */
336 contract AssetWithWhitelist is AssetWithAmbi {
337     mapping(address => bool) public whitelist;
338     uint public restrictionExpiraton;
339     bool public restrictionRemoved;
340 
341     event Error(bytes32 _errorText);
342 
343     function allowTransferFrom(address _from) public onlyRole('admin') returns(bool) {
344         whitelist[_from] = true;
345         return true;
346     }
347 
348     function blockTransferFrom(address _from) public onlyRole('admin') returns(bool) {
349         whitelist[_from] = false;
350         return true;
351     }
352 
353     function transferIsAllowed(address _from) public view returns(bool) {
354         return restrictionRemoved || whitelist[_from] || (now >= restrictionExpiraton);
355     }
356 
357     function removeRestriction() public onlyRole('admin') returns(bool) {
358         restrictionRemoved = true;
359         return true;
360     }
361 
362     modifier transferAllowed(address _sender) {
363         if (!transferIsAllowed(_sender)) {
364             emit Error('Transfer not allowed');
365             return;
366         }
367         _;
368     }
369 
370     function setExpiration(uint _time) public onlyRole('admin') returns(bool) {
371         if (restrictionExpiraton != 0) {
372             emit Error('Expiration time already set');
373             return false;
374         }
375         if (_time < now) {
376             emit Error('Expiration time invalid');
377             return false;
378         }
379         restrictionExpiraton = _time;
380         return true;
381     }
382 
383     // Transfers
384     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
385         transferAllowed(_sender)
386         internal
387         returns(bool)
388     {
389         return super._transferWithReference(_to, _value, _reference, _sender);
390     }
391 
392     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender)
393         transferAllowed(_sender)
394         internal
395         returns(bool)
396     {
397         return super._transferToICAPWithReference(_icap, _value, _reference, _sender);
398     }
399 
400     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender)
401         transferAllowed(_from)
402         internal
403         returns(bool)
404     {
405         return super._transferFromWithReference(_from, _to, _value, _reference, _sender);
406     }
407 
408     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender)
409         transferAllowed(_from)
410         internal
411         returns(bool)
412     {
413         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
414     }
415 }
416 
417 /**
418  * @title EToken2 Asset with per holder timelock implementation contract.
419  *
420  * Locks can only be set by the sender with 'locker' role and to the
421  * recepients who allowed to set locks on them.
422  *
423  * Once the lock is set, it cannot be changed, and all the tokens on the locked address
424  * will become available when unlock date comes.
425  */
426 contract AssetWithTimelock is AssetWithAmbi {
427     mapping(address => uint) public unlockDate;
428 
429     event Error(bytes32 message);
430     event TimelockAllowed(address addr);
431     event Timelocked(address addr, uint unlockDate);
432 
433     function isTimelockAllowed(address _address) public view returns(bool) {
434         return unlockDate[_address] > 0;
435     }
436 
437     function isTimelocked(address _address) public view returns(bool) {
438         return unlockDate[_address] > 1;
439     }
440 
441     function isTransferAllowed(address _from) public view returns(bool) {
442         return now > unlockDate[_from];
443     }
444 
445     function allowTimelock() public returns(bool) {
446         _allowTimelock(_sender());
447         return true;
448     }
449 
450     function _allowTimelock(address _address) internal {
451         if (isTimelockAllowed(_address)) {
452             return;
453         }
454         unlockDate[_address] = 1;
455         emit TimelockAllowed(_address);
456     }
457 
458     function () public {
459         require(msg.data.length == 0);
460         allowTimelock();
461     }
462 
463     function transferWithLock(address _to, uint _value, uint _unlockDate) onlyRole('locker') public returns(bool) {
464         address sender = _sender();
465         if (_unlockDate == 0) {
466             emit Error('Invalid unlock date');
467             return false;
468         }
469         if (not(isTimelockAllowed(_to))) {
470             emit Error('Timelock not allowed');
471             return false;
472         }
473         if (not(_transferWithReference(_to, _value, 'Timelocked', sender))) {
474             emit Error('Failed transfer with lock');
475             return false;
476         }
477         if (not(isTimelocked(_to))) {
478             unlockDate[_to] = _unlockDate;
479             emit Timelocked(_to, _unlockDate);
480         }
481         return true;
482     }
483 
484     modifier onlyUnlocked(address _from) {
485         if (not(isTransferAllowed(_from))) {
486             emit Error('Sender is timelocked');
487             return;
488         }
489         _;
490     }
491 
492     function not(bool _condition) internal pure returns(bool) {
493         return !_condition;
494     }
495 
496     // Transfers
497     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
498         onlyUnlocked(_sender)
499         internal
500         returns(bool)
501     {
502         if (_value == 0) {
503             _allowTimelock(_sender);
504             return true;
505         }
506         return super._transferWithReference(_to, _value, _reference, _sender);
507     }
508 
509     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference, address _sender)
510         onlyUnlocked(_sender)
511         internal
512         returns(bool)
513     {
514         return super._transferToICAPWithReference(_icap, _value, _reference, _sender);
515     }
516 
517     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender)
518         onlyUnlocked(_from)
519         internal
520         returns(bool)
521     {
522         return super._transferFromWithReference(_from, _to, _value, _reference, _sender);
523     }
524 
525     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender)
526         onlyUnlocked(_from)
527         internal
528         returns(bool)
529     {
530         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
531     }
532 }
533 
534 contract AssetWithTimelockAndWhitelist is AssetWithWhitelist, AssetWithTimelock {}