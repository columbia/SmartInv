1 
2 // File: contracts/AssetInterface.sol
3 
4 pragma solidity 0.4.23;
5 
6 
7 contract AssetInterface {
8     function _performTransferWithReference(
9         address _to,
10         uint _value,
11         string _reference,
12         address _sender)
13     public returns(bool);
14 
15     function _performTransferToICAPWithReference(
16         bytes32 _icap,
17         uint _value,
18         string _reference,
19         address _sender)
20     public returns(bool);
21 
22     function _performApprove(address _spender, uint _value, address _sender)
23     public returns(bool);
24 
25     function _performTransferFromWithReference(
26         address _from,
27         address _to,
28         uint _value,
29         string _reference,
30         address _sender)
31     public returns(bool);
32 
33     function _performTransferFromToICAPWithReference(
34         address _from,
35         bytes32 _icap,
36         uint _value,
37         string _reference,
38         address _sender)
39     public returns(bool);
40 
41     function _performGeneric(bytes, address) public payable {
42         revert();
43     }
44 }
45 
46 // File: contracts/ERC20Interface.sol
47 
48 pragma solidity 0.4.23;
49 
50 
51 contract ERC20Interface {
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed from, address indexed spender, uint256 value);
54 
55     function totalSupply() public view returns(uint256 supply);
56     function balanceOf(address _owner) public view returns(uint256 balance);
57     // solhint-disable-next-line no-simple-event-func-name
58     function transfer(address _to, uint256 _value) public returns(bool success);
59     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
60     function approve(address _spender, uint256 _value) public returns(bool success);
61     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
62 
63     // function symbol() constant returns(string);
64     function decimals() public view returns(uint8);
65     // function name() constant returns(string);
66 }
67 
68 // File: contracts/AssetProxyInterface.sol
69 
70 pragma solidity 0.4.23;
71 
72 
73 
74 contract AssetProxyInterface is ERC20Interface {
75     function _forwardApprove(address _spender, uint _value, address _sender)
76     public returns(bool);
77 
78     function _forwardTransferFromWithReference(
79         address _from,
80         address _to,
81         uint _value,
82         string _reference,
83         address _sender)
84     public returns(bool);
85 
86     function _forwardTransferFromToICAPWithReference(
87         address _from,
88         bytes32 _icap,
89         uint _value,
90         string _reference,
91         address _sender)
92     public returns(bool);
93 
94     function recoverTokens(ERC20Interface _asset, address _receiver, uint _value)
95     public returns(bool);
96 
97     // solhint-disable-next-line no-empty-blocks
98     function etoken2() public pure returns(address) {} // To be replaced by the implicit getter;
99 
100     // To be replaced by the implicit getter;
101     // solhint-disable-next-line no-empty-blocks
102     function etoken2Symbol() public pure returns(bytes32) {}
103 }
104 
105 // File: contracts/helpers/Bytes32.sol
106 
107 pragma solidity 0.4.23;
108 
109 
110 contract Bytes32 {
111     function _bytes32(string _input) internal pure returns(bytes32 result) {
112         assembly {
113             result := mload(add(_input, 32))
114         }
115     }
116 }
117 
118 // File: contracts/helpers/ReturnData.sol
119 
120 pragma solidity 0.4.23;
121 
122 
123 contract ReturnData {
124     function _returnReturnData(bool _success) internal pure {
125         assembly {
126             let returndatastart := 0
127             returndatacopy(returndatastart, 0, returndatasize)
128             switch _success case 0 { revert(returndatastart, returndatasize) }
129                 default { return(returndatastart, returndatasize) }
130         }
131     }
132 
133     function _assemblyCall(address _destination, uint _value, bytes _data)
134     internal returns(bool success) {
135         assembly {
136             success := call(gas, _destination, _value, add(_data, 32), mload(_data), 0, 0)
137         }
138     }
139 }
140 
141 // File: contracts/Asset.sol
142 
143 pragma solidity 0.4.23;
144 
145 
146 
147 
148 
149 
150 /**
151  * @title EToken2 Asset implementation contract.
152  *
153  * Basic asset implementation contract, without any additional logic.
154  * Every other asset implementation contracts should derive from this one.
155  * Receives calls from the proxy, and calls back immediately without arguments modification.
156  *
157  * Note: all the non constant functions return false instead of throwing in case if state change
158  * didn't happen yet.
159  */
160 contract Asset is AssetInterface, Bytes32, ReturnData {
161     // Assigned asset proxy contract, immutable.
162     AssetProxyInterface public proxy;
163 
164     /**
165      * Only assigned proxy is allowed to call.
166      */
167     modifier onlyProxy() {
168         if (proxy == msg.sender) {
169             _;
170         }
171     }
172 
173     /**
174      * Sets asset proxy address.
175      *
176      * Can be set only once.
177      *
178      * @param _proxy asset proxy contract address.
179      *
180      * @return success.
181      * @dev function is final, and must not be overridden.
182      */
183     function init(AssetProxyInterface _proxy) public returns(bool) {
184         if (address(proxy) != 0x0) {
185             return false;
186         }
187         proxy = _proxy;
188         return true;
189     }
190 
191     /**
192      * Passes execution into virtual function.
193      *
194      * Can only be called by assigned asset proxy.
195      *
196      * @return success.
197      * @dev function is final, and must not be overridden.
198      */
199     function _performTransferWithReference(
200         address _to,
201         uint _value,
202         string _reference,
203         address _sender)
204     public onlyProxy() returns(bool) {
205         if (isICAP(_to)) {
206             return _transferToICAPWithReference(
207                 bytes32(_to) << 96, _value, _reference, _sender);
208         }
209         return _transferWithReference(_to, _value, _reference, _sender);
210     }
211 
212     /**
213      * Calls back without modifications.
214      *
215      * @return success.
216      * @dev function is virtual, and meant to be overridden.
217      */
218     function _transferWithReference(
219         address _to,
220         uint _value,
221         string _reference,
222         address _sender)
223     internal returns(bool) {
224         return proxy._forwardTransferFromWithReference(
225             _sender, _to, _value, _reference, _sender);
226     }
227 
228     /**
229      * Passes execution into virtual function.
230      *
231      * Can only be called by assigned asset proxy.
232      *
233      * @return success.
234      * @dev function is final, and must not be overridden.
235      */
236     function _performTransferToICAPWithReference(
237         bytes32 _icap,
238         uint _value,
239         string _reference,
240         address _sender)
241     public onlyProxy() returns(bool) {
242         return _transferToICAPWithReference(_icap, _value, _reference, _sender);
243     }
244 
245     /**
246      * Calls back without modifications.
247      *
248      * @return success.
249      * @dev function is virtual, and meant to be overridden.
250      */
251     function _transferToICAPWithReference(
252         bytes32 _icap,
253         uint _value,
254         string _reference,
255         address _sender)
256     internal returns(bool) {
257         return proxy._forwardTransferFromToICAPWithReference(
258             _sender, _icap, _value, _reference, _sender);
259     }
260 
261     /**
262      * Passes execution into virtual function.
263      *
264      * Can only be called by assigned asset proxy.
265      *
266      * @return success.
267      * @dev function is final, and must not be overridden.
268      */
269     function _performTransferFromWithReference(
270         address _from,
271         address _to,
272         uint _value,
273         string _reference,
274         address _sender)
275     public onlyProxy() returns(bool) {
276         if (isICAP(_to)) {
277             return _transferFromToICAPWithReference(
278                 _from, bytes32(_to) << 96, _value, _reference, _sender);
279         }
280         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
281     }
282 
283     /**
284      * Calls back without modifications.
285      *
286      * @return success.
287      * @dev function is virtual, and meant to be overridden.
288      */
289     function _transferFromWithReference(
290         address _from,
291         address _to,
292         uint _value,
293         string _reference,
294         address _sender)
295     internal returns(bool) {
296         return proxy._forwardTransferFromWithReference(
297             _from, _to, _value, _reference, _sender);
298     }
299 
300     /**
301      * Passes execution into virtual function.
302      *
303      * Can only be called by assigned asset proxy.
304      *
305      * @return success.
306      * @dev function is final, and must not be overridden.
307      */
308     function _performTransferFromToICAPWithReference(
309         address _from,
310         bytes32 _icap,
311         uint _value,
312         string _reference,
313         address _sender)
314     public onlyProxy() returns(bool) {
315         return _transferFromToICAPWithReference(
316             _from, _icap, _value, _reference, _sender);
317     }
318 
319     /**
320      * Calls back without modifications.
321      *
322      * @return success.
323      * @dev function is virtual, and meant to be overridden.
324      */
325     function _transferFromToICAPWithReference(
326         address _from,
327         bytes32 _icap,
328         uint _value,
329         string _reference,
330         address _sender)
331     internal returns(bool) {
332         return proxy._forwardTransferFromToICAPWithReference(
333             _from, _icap, _value, _reference, _sender);
334     }
335 
336     /**
337      * Passes execution into virtual function.
338      *
339      * Can only be called by assigned asset proxy.
340      *
341      * @return success.
342      * @dev function is final, and must not be overridden.
343      */
344     function _performApprove(address _spender, uint _value, address _sender)
345     public onlyProxy() returns(bool) {
346         return _approve(_spender, _value, _sender);
347     }
348 
349     /**
350      * Calls back without modifications.
351      *
352      * @return success.
353      * @dev function is virtual, and meant to be overridden.
354      */
355     function _approve(address _spender, uint _value, address _sender) 
356     internal returns(bool) {
357         return proxy._forwardApprove(_spender, _value, _sender);
358     }
359 
360     /**
361      * Passes execution into virtual function.
362      *
363      * Can only be called by assigned asset proxy.
364      *
365      * @return bytes32 result.
366      * @dev function is final, and must not be overridden.
367      */
368     function _performGeneric(bytes _data, address _sender)
369     public payable onlyProxy() {
370         _generic(_data, msg.value, _sender);
371     }
372 
373     modifier onlyMe() {
374         if (this == msg.sender) {
375             _;
376         }
377     }
378 
379     // Most probably the following should never be redefined in child contracts.
380     address public genericSender;
381 
382     function _generic(bytes _data, uint _value, address _msgSender) internal {
383         // Restrict reentrancy.
384         require(genericSender == 0x0);
385         genericSender = _msgSender;
386         bool success = _assemblyCall(address(this), _value, _data);
387         delete genericSender;
388         _returnReturnData(success);
389     }
390 
391     // Decsendants should use _sender() instead of msg.sender to properly process proxied calls.
392     function _sender() internal view returns(address) {
393         return this == msg.sender ? genericSender : msg.sender;
394     }
395 
396     // Interface functions to allow specifying ICAP addresses as strings.
397     function transferToICAP(string _icap, uint _value) public returns(bool) {
398         return transferToICAPWithReference(_icap, _value, '');
399     }
400 
401     function transferToICAPWithReference(string _icap, uint _value, string _reference)
402     public returns(bool) {
403         return _transferToICAPWithReference(
404             _bytes32(_icap), _value, _reference, _sender());
405     }
406 
407     function transferFromToICAP(address _from, string _icap, uint _value)
408     public returns(bool) {
409         return transferFromToICAPWithReference(_from, _icap, _value, '');
410     }
411 
412     function transferFromToICAPWithReference(
413         address _from,
414         string _icap,
415         uint _value,
416         string _reference)
417     public returns(bool) {
418         return _transferFromToICAPWithReference(
419             _from, _bytes32(_icap), _value, _reference, _sender());
420     }
421 
422     function isICAP(address _address) public pure returns(bool) {
423         bytes32 a = bytes32(_address) << 96;
424         if (a[0] != 'X' || a[1] != 'E') {
425             return false;
426         }
427         if (a[2] < 48 || a[2] > 57 || a[3] < 48 || a[3] > 57) {
428             return false;
429         }
430         for (uint i = 4; i < 20; i++) {
431             uint char = uint(a[i]);
432             if (char < 48 || char > 90 || (char > 57 && char < 65)) {
433                 return false;
434             }
435         }
436         return true;
437     }
438 }
439 
440 // File: contracts/Ambi2Enabled.sol
441 
442 pragma solidity 0.4.23;
443 
444 
445 contract Ambi2 {
446     function claimFor(address _address, address _owner) public returns(bool);
447     function hasRole(address _from, bytes32 _role, address _to) public view returns(bool);
448     function isOwner(address _node, address _owner) public view returns(bool);
449 }
450 
451 
452 contract Ambi2Enabled {
453     Ambi2 public ambi2;
454 
455     modifier onlyRole(bytes32 _role) {
456         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
457             _;
458         }
459     }
460 
461     // Perform only after claiming the node, or claim in the same tx.
462     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
463         if (address(ambi2) != 0x0) {
464             return false;
465         }
466 
467         ambi2 = _ambi2;
468         return true;
469     }
470 }
471 
472 // File: contracts/Ambi2EnabledFull.sol
473 
474 pragma solidity 0.4.23;
475 
476 
477 
478 contract Ambi2EnabledFull is Ambi2Enabled {
479     // Setup and claim atomically.
480     function setupAmbi2(Ambi2 _ambi2) public returns(bool) {
481         if (address(ambi2) != 0x0) {
482             return false;
483         }
484         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
485             return false;
486         }
487 
488         ambi2 = _ambi2;
489         return true;
490     }
491 }
492 
493 // File: contracts/AssetWithAmbi.sol
494 
495 pragma solidity 0.4.23;
496 
497 
498 
499 
500 contract AssetWithAmbi is Asset, Ambi2EnabledFull {
501     modifier onlyRole(bytes32 _role) {
502         if (address(ambi2) != 0x0 && (ambi2.hasRole(this, _role, _sender()))) {
503             _;
504         }
505     }
506 }
507 
508 // File: contracts/AssetWithWhitelist.sol
509 
510 pragma solidity 0.4.23;
511 
512 
513 
514 /**
515  * @title EToken2 Asset with whitelist implementation contract.
516  */
517 contract AssetWithWhitelist is AssetWithAmbi {
518     mapping(address => bool) public whitelist;
519     uint public restrictionExpiraton;
520     bool public restrictionRemoved;
521 
522     event Error(bytes32 _errorText);
523 
524     function allowTransferFrom(address _from) public onlyRole('admin') returns(bool) {
525         whitelist[_from] = true;
526         return true;
527     }
528 
529     function blockTransferFrom(address _from) public onlyRole('admin') returns(bool) {
530         whitelist[_from] = false;
531         return true;
532     }
533 
534     function transferIsAllowed(address _from) public view returns(bool) {
535         // solhint-disable-next-line not-rely-on-time
536         return restrictionRemoved || whitelist[_from] || (now >= restrictionExpiraton);
537     }
538 
539     function removeRestriction() public onlyRole('admin') returns(bool) {
540         restrictionRemoved = true;
541         return true;
542     }
543 
544     modifier transferAllowed(address _sender) {
545         if (!transferIsAllowed(_sender)) {
546             emit Error('Transfer not allowed');
547             return;
548         }
549         _;
550     }
551 
552     function setExpiration(uint _time) public onlyRole('admin') returns(bool) {
553         if (restrictionExpiraton != 0) {
554             emit Error('Expiration time already set');
555             return false;
556         }
557         // solhint-disable-next-line not-rely-on-time
558         if (_time < now) {
559             emit Error('Expiration time invalid');
560             return false;
561         }
562         restrictionExpiraton = _time;
563         return true;
564     }
565 
566     // Transfers
567     function _transferWithReference(address _to, uint _value, string _reference, address _sender)
568         internal
569         transferAllowed(_sender)
570         returns(bool)
571     {
572         return super._transferWithReference(_to, _value, _reference, _sender);
573     }
574 
575     function _transferToICAPWithReference(
576         bytes32 _icap,
577         uint _value,
578         string _reference,
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
589         string _reference,
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
600         string _reference,
601         address _sender)
602     internal transferAllowed(_from) returns(bool)
603     {
604         return super._transferFromToICAPWithReference(_from, _icap, _value, _reference, _sender);
605     }
606 }
