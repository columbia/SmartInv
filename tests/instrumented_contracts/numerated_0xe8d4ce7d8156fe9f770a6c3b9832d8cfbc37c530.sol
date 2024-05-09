1 // File: contracts/AssetInterface.sol
2 
3 pragma solidity 0.5.8;
4 
5 
6 contract AssetInterface {
7     function _performTransferWithReference(
8         address _to,
9         uint _value,
10         string memory _reference,
11         address _sender)
12     public returns(bool);
13 
14     function _performTransferToICAPWithReference(
15         bytes32 _icap,
16         uint _value,
17         string memory _reference,
18         address _sender)
19     public returns(bool);
20 
21     function _performApprove(address _spender, uint _value, address _sender)
22     public returns(bool);
23 
24     function _performTransferFromWithReference(
25         address _from,
26         address _to,
27         uint _value,
28         string memory _reference,
29         address _sender)
30     public returns(bool);
31 
32     function _performTransferFromToICAPWithReference(
33         address _from,
34         bytes32 _icap,
35         uint _value,
36         string memory _reference,
37         address _sender)
38     public returns(bool);
39 
40     function _performGeneric(bytes memory, address) public payable {
41         revert();
42     }
43 }
44 
45 // File: contracts/ERC20Interface.sol
46 
47 pragma solidity 0.5.8;
48 
49 
50 contract ERC20Interface {
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed from, address indexed spender, uint256 value);
53 
54     function totalSupply() public view returns(uint256 supply);
55     function balanceOf(address _owner) public view returns(uint256 balance);
56     // solhint-disable-next-line no-simple-event-func-name
57     function transfer(address _to, uint256 _value) public returns(bool success);
58     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
59     function approve(address _spender, uint256 _value) public returns(bool success);
60     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
61 
62     // function symbol() constant returns(string);
63     function decimals() public view returns(uint8);
64     // function name() constant returns(string);
65 }
66 
67 // File: contracts/AssetProxyInterface.sol
68 
69 pragma solidity 0.5.8;
70 
71 
72 
73 contract AssetProxyInterface is ERC20Interface {
74     function _forwardApprove(address _spender, uint _value, address _sender)
75     public returns(bool);
76 
77     function _forwardTransferFromWithReference(
78         address _from,
79         address _to,
80         uint _value,
81         string memory _reference,
82         address _sender)
83     public returns(bool);
84 
85     function _forwardTransferFromToICAPWithReference(
86         address _from,
87         bytes32 _icap,
88         uint _value,
89         string memory _reference,
90         address _sender)
91     public returns(bool);
92 
93     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
94     public returns(bool);
95 
96     function etoken2() external view returns(address); // To be replaced by the implicit getter;
97 
98     // To be replaced by the implicit getter;
99     function etoken2Symbol() external view returns(bytes32);
100 }
101 
102 // File: smart-contracts-common/contracts/Bytes32.sol
103 
104 pragma solidity 0.5.8;
105 
106 
107 contract Bytes32 {
108     function _bytes32(string memory _input) internal pure returns(bytes32 result) {
109         assembly {
110             result := mload(add(_input, 32))
111         }
112     }
113 }
114 
115 // File: smart-contracts-common/contracts/ReturnData.sol
116 
117 pragma solidity 0.5.8;
118 
119 
120 contract ReturnData {
121     function _returnReturnData(bool _success) internal pure {
122         assembly {
123             let returndatastart := 0
124             returndatacopy(returndatastart, 0, returndatasize)
125             switch _success case 0 { revert(returndatastart, returndatasize) }
126                 default { return(returndatastart, returndatasize) }
127         }
128     }
129 
130     function _assemblyCall(address _destination, uint _value, bytes memory _data)
131     internal returns(bool success) {
132         assembly {
133             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
134         }
135     }
136 }
137 
138 // File: contracts/Asset.sol
139 
140 pragma solidity 0.5.8;
141 
142 
143 
144 
145 
146 
147 /**
148  * @title EToken2 Asset implementation contract.
149  *
150  * Basic asset implementation contract, without any additional logic.
151  * Every other asset implementation contracts should derive from this one.
152  * Receives calls from the proxy, and calls back immediately without arguments modification.
153  *
154  * Note: all the non constant functions return false instead of throwing in case if state change
155  * didn't happen yet.
156  */
157 contract Asset is AssetInterface, Bytes32, ReturnData {
158     // Assigned asset proxy contract, immutable.
159     AssetProxyInterface public proxy;
160 
161     /**
162      * Only assigned proxy is allowed to call.
163      */
164     modifier onlyProxy() {
165         if (address(proxy) == msg.sender) {
166             _;
167         }
168     }
169 
170     /**
171      * Sets asset proxy address.
172      *
173      * Can be set only once.
174      *
175      * @param _proxy asset proxy contract address.
176      *
177      * @return success.
178      * @dev function is final, and must not be overridden.
179      */
180     function init(AssetProxyInterface _proxy) public returns(bool) {
181         if (address(proxy) != address(0)) {
182             return false;
183         }
184         proxy = _proxy;
185         return true;
186     }
187 
188     /**
189      * Passes execution into virtual function.
190      *
191      * Can only be called by assigned asset proxy.
192      *
193      * @return success.
194      * @dev function is final, and must not be overridden.
195      */
196     function _performTransferWithReference(
197         address _to,
198         uint _value,
199         string memory _reference,
200         address _sender)
201     public onlyProxy() returns(bool) {
202         if (isICAP(_to)) {
203             return _transferToICAPWithReference(
204                 bytes20(_to), _value, _reference, _sender);
205         }
206         return _transferWithReference(_to, _value, _reference, _sender);
207     }
208 
209     /**
210      * Calls back without modifications.
211      *
212      * @return success.
213      * @dev function is virtual, and meant to be overridden.
214      */
215     function _transferWithReference(
216         address _to,
217         uint _value,
218         string memory _reference,
219         address _sender)
220     internal returns(bool) {
221         return proxy._forwardTransferFromWithReference(
222             _sender, _to, _value, _reference, _sender);
223     }
224 
225     /**
226      * Passes execution into virtual function.
227      *
228      * Can only be called by assigned asset proxy.
229      *
230      * @return success.
231      * @dev function is final, and must not be overridden.
232      */
233     function _performTransferToICAPWithReference(
234         bytes32 _icap,
235         uint _value,
236         string memory _reference,
237         address _sender)
238     public onlyProxy() returns(bool) {
239         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
240     }
241 
242     /**
243      * Calls back without modifications.
244      *
245      * @return success.
246      * @dev function is virtual, and meant to be overridden.
247      */
248     function _transferToICAPWithReference(
249         bytes32 _icap,
250         uint _value,
251         string memory _reference,
252         address _sender)
253     internal returns(bool) {
254         return proxy._forwardTransferFromToICAPWithReference(
255             _sender, _icap, _value, _reference, _sender);
256     }
257 
258     /**
259      * Passes execution into virtual function.
260      *
261      * Can only be called by assigned asset proxy.
262      *
263      * @return success.
264      * @dev function is final, and must not be overridden.
265      */
266     function _performTransferFromWithReference(
267         address _from,
268         address _to,
269         uint _value,
270         string memory _reference,
271         address _sender)
272     public onlyProxy() returns(bool) {
273         if (isICAP(_to)) {
274             return _transferFromToICAPWithReference(
275                 _from, bytes20(_to), _value, _reference, _sender);
276         }
277         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
278     }
279 
280     /**
281      * Calls back without modifications.
282      *
283      * @return success.
284      * @dev function is virtual, and meant to be overridden.
285      */
286     function _transferFromWithReference(
287         address _from,
288         address _to,
289         uint _value,
290         string memory _reference,
291         address _sender)
292     internal returns(bool) {
293         return proxy._forwardTransferFromWithReference(
294             _from, _to, _value, _reference, _sender);
295     }
296 
297     /**
298      * Passes execution into virtual function.
299      *
300      * Can only be called by assigned asset proxy.
301      *
302      * @return success.
303      * @dev function is final, and must not be overridden.
304      */
305     function _performTransferFromToICAPWithReference(
306         address _from,
307         bytes32 _icap,
308         uint _value,
309         string memory _reference,
310         address _sender)
311     public onlyProxy() returns(bool) {
312         return _transferFromToICAPWithReference(
313             _from, _icap, _value, _reference, _sender);
314     }
315 
316     /**
317      * Calls back without modifications.
318      *
319      * @return success.
320      * @dev function is virtual, and meant to be overridden.
321      */
322     function _transferFromToICAPWithReference(
323         address _from,
324         bytes32 _icap,
325         uint _value,
326         string memory _reference,
327         address _sender)
328     internal returns(bool) {
329         return proxy._forwardTransferFromToICAPWithReference(
330             _from, _icap, _value, _reference, _sender);
331     }
332 
333     /**
334      * Passes execution into virtual function.
335      *
336      * Can only be called by assigned asset proxy.
337      *
338      * @return success.
339      * @dev function is final, and must not be overridden.
340      */
341     function _performApprove(address _spender, uint _value, address _sender)
342     public onlyProxy() returns(bool) {
343         return _approve(_spender, _value, _sender);
344     }
345 
346     /**
347      * Calls back without modifications.
348      *
349      * @return success.
350      * @dev function is virtual, and meant to be overridden.
351      */
352     function _approve(address _spender, uint _value, address _sender)
353     internal returns(bool) {
354         return proxy._forwardApprove(_spender, _value, _sender);
355     }
356 
357     /**
358      * Passes execution into virtual function.
359      *
360      * Can only be called by assigned asset proxy.
361      *
362      * @return bytes32 result.
363      * @dev function is final, and must not be overridden.
364      */
365     function _performGeneric(bytes memory _data, address _sender)
366     public payable onlyProxy() {
367         _generic(_data, msg.value, _sender);
368     }
369 
370     modifier onlyMe() {
371         if (address(this) == msg.sender) {
372             _;
373         }
374     }
375 
376     // Most probably the following should never be redefined in child contracts.
377     address public genericSender;
378 
379     function _generic(bytes memory _data, uint _value, address _msgSender) internal {
380         // Restrict reentrancy.
381         require(genericSender == address(0));
382         genericSender = _msgSender;
383         bool success = _assemblyCall(address(this), _value, _data);
384         delete genericSender;
385         _returnReturnData(success);
386     }
387 
388     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
389     function _sender() internal view returns(address) {
390         return address(this) == msg.sender ? genericSender : msg.sender;
391     }
392 
393     // Interface functions to allow specifying ICAP addresses as strings.
394     function transferToICAP(string memory _icap, uint _value) public returns(bool) {
395         return transferToICAPWithReference(_icap, _value, '');
396     }
397 
398     function transferToICAPWithReference(string memory _icap, uint _value, string memory _reference)
399     public returns(bool) {
400         return _transferToICAPWithReference(
401             _bytes32(_icap), _value, _reference, _sender());
402     }
403 
404     function transferFromToICAP(address _from, string memory _icap, uint _value)
405     public returns(bool) {
406         return transferFromToICAPWithReference(_from, _icap, _value, '');
407     }
408 
409     function transferFromToICAPWithReference(
410         address _from,
411         string memory _icap,
412         uint _value,
413         string memory _reference)
414     public returns(bool) {
415         return _transferFromToICAPWithReference(
416             _from, _bytes32(_icap), _value, _reference, _sender());
417     }
418 
419     function isICAP(address _address) public pure returns(bool) {
420         bytes20 a = bytes20(_address);
421         if (a[0] != 'X' || a[1] != 'E') {
422             return false;
423         }
424         if (uint8(a[2]) < 48 || uint8(a[2]) > 57 || uint8(a[3]) < 48 || uint8(a[3]) > 57) {
425             return false;
426         }
427         for (uint i = 4; i < 20; i++) {
428             uint char = uint8(a[i]);
429             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
430                 return false;
431             }
432         }
433         return true;
434     }
435 }
436 
437 // File: contracts/Ambi2Enabled.sol
438 
439 pragma solidity 0.5.8;
440 
441 
442 contract Ambi2 {
443     function claimFor(address _address, address _owner) public returns(bool);
444     function hasRole(address _from, bytes32 _role, address _to) public view returns(bool);
445     function isOwner(address _node, address _owner) public view returns(bool);
446 }
447 
448 
449 contract Ambi2Enabled {
450     Ambi2 public ambi2;
451 
452     modifier onlyRole(bytes32 _role) {
453         if (address(ambi2) != address(0) && ambi2.hasRole(address(this), _role, msg.sender)) {
454             _;
455         }
456     }
457 
458     // Perform only after claiming the node, or claim in the same tx.
459     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
460         if (address(ambi2) != address(0)) {
461             return false;
462         }
463 
464         ambi2 = _ambi2;
465         return true;
466     }
467 }
468 
469 // File: contracts/Ambi2EnabledFull.sol
470 
471 pragma solidity 0.5.8;
472 
473 
474 
475 contract Ambi2EnabledFull is Ambi2Enabled {
476     // Setup and claim atomically.
477     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
478         if (address(ambi2) != address(0)) {
479             return false;
480         }
481         if (!_ambi2.claimFor(address(this), msg.sender) &&
482             !_ambi2.isOwner(address(this), msg.sender)) {
483             return false;
484         }
485 
486         ambi2 = _ambi2;
487         return true;
488     }
489 }
490 
491 // File: contracts/AssetWithAmbi.sol
492 
493 pragma solidity 0.5.8;
494 
495 
496 
497 
498 contract AssetWithAmbi is Asset, Ambi2EnabledFull {
499     modifier onlyRole(bytes32 _role) {
500         if (address(ambi2) != address(0) && (ambi2.hasRole(address(this), _role, _sender()))) {
501             _;
502         }
503     }
504 }
505 
506 // File: contracts/AssetWithWhitelist.sol
507 
508 pragma solidity 0.5.8;
509 
510 
511 
512 /**
513  * @title EToken2 Asset with whitelist implementation contract.
514  */
515 contract AssetWithWhitelist is AssetWithAmbi {
516     mapping(address => bool) public whitelist;
517     uint public restrictionExpiraton;
518     bool public restrictionRemoved;
519 
520     event Error(bytes32 _errorText);
521 
522     function allowTransferFrom(address _from) public onlyRole('admin') returns(bool) {
523         whitelist[_from] = true;
524         return true;
525     }
526 
527     function blockTransferFrom(address _from) public onlyRole('admin') returns(bool) {
528         whitelist[_from] = false;
529         return true;
530     }
531 
532     function transferIsAllowed(address _from) public view returns(bool) {
533         // solhint-disable-next-line not-rely-on-time
534         return restrictionRemoved || whitelist[_from] || (now >= restrictionExpiraton);
535     }
536 
537     function removeRestriction() public onlyRole('admin') returns(bool) {
538         restrictionRemoved = true;
539         return true;
540     }
541 
542     modifier transferAllowed(address _sender) {
543         if (!transferIsAllowed(_sender)) {
544             emit Error('Transfer not allowed');
545             return;
546         }
547         _;
548     }
549 
550     function setExpiration(uint _time) public onlyRole('admin') returns(bool) {
551         if (restrictionExpiraton != 0) {
552             emit Error('Expiration time already set');
553             return false;
554         }
555         // solhint-disable-next-line not-rely-on-time
556         if (_time < now) {
557             emit Error('Expiration time invalid');
558             return false;
559         }
560         restrictionExpiraton = _time;
561         return true;
562     }
563 
564     // Transfers
565     function _transferWithReference(
566         address _to,
567         uint _value,
568         string memory _reference,
569         address _sender)
570     internal transferAllowed(_sender) returns(bool)
571     {
572         return super._transferWithReference(_to, _value, _reference, _sender);
573     }
574 
575     function _transferToICAPWithReference(
576         bytes32 _icap,
577         uint _value,
578         string memory _reference,
579         address _sender)
580     internal transferAllowed(_sender) returns(bool)
581     {
582         return super._transferToICAPWithReference(_icap, _value, _reference, _sender);
583     }
584 
585     function _transferFromWithReference(
586         address _from,
587         address _to,
588         uint _value,
589         string memory _reference,
590         address _sender)
591     internal transferAllowed(_from) returns(bool)
592     {
593         return super._transferFromWithReference(_from, _to, _value, _reference, _sender);
594     }
595 
596     function _transferFromToICAPWithReference(
597         address _from,
598         bytes32 _icap,
599         uint _value,
600         string memory _reference,
601         address _sender)
602     internal transferAllowed(_from) returns(bool)
603     {
604         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
605     }
606 }