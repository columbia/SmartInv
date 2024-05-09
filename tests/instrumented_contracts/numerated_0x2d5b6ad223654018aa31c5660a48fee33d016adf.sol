1 contract MultiAsset {
2     function isCreated(bytes32 _symbol) constant returns(bool);
3     function owner(bytes32 _symbol) constant returns(address);
4     function totalSupply(bytes32 _symbol) constant returns(uint);
5     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
6     function transfer(address _to, uint _value, bytes32 _symbol) returns(bool);
7     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
8     function proxyTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool);
9     function proxyApprove(address _spender, uint _value, bytes32 _symbol) returns(bool);
10     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
11     function transferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
12     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
13     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
14     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
15     function proxySetCosignerAddress(address _address, bytes32 _symbol) returns(bool);
16 }
17 
18 contract Ambi {
19     function getNodeAddress(bytes32 _name) constant returns (address);
20     function addNode(bytes32 _name, address _addr) external returns (bool);
21     function hasRelation(bytes32 _from, bytes32 _role, address _to) constant returns (bool);
22 }
23 
24 contract EtherTreasuryInterface {
25     function withdraw(address _to, uint _value) returns(bool);
26 }
27 
28 contract Safe {
29     // Should always be placed as first modifier!
30     modifier noValue {
31         if (msg.value > 0) {
32             // Internal Out Of Gas/Throw: revert this transaction too;
33             // Call Stack Depth Limit reached: revert this transaction too;
34             // Recursive Call: safe, no any changes applied yet, we are inside of modifier.
35             _safeSend(msg.sender, msg.value);
36         }
37         _
38     }
39 
40     modifier onlyHuman {
41         if (_isHuman()) {
42             _
43         }
44     }
45 
46     modifier noCallback {
47         if (!isCall) {
48             _
49         }
50     }
51 
52     modifier immutable(address _address) {
53         if (_address == 0) {
54             _
55         }
56     }
57 
58     address stackDepthLib;
59     function setupStackDepthLib(address _stackDepthLib) immutable(address(stackDepthLib)) returns(bool) {
60         stackDepthLib = _stackDepthLib;
61         return true;
62     }
63 
64     modifier requireStackDepth(uint16 _depth) {
65         if (stackDepthLib == 0x0) {
66             throw;
67         }
68         if (_depth > 1023) {
69             throw;
70         }
71         if (!stackDepthLib.delegatecall(0x32921690, stackDepthLib, _depth)) {
72             throw;
73         }
74         _
75     }
76 
77     // Must not be used inside the functions that have noValue() modifier!
78     function _safeFalse() internal noValue() returns(bool) {
79         return false;
80     }
81 
82     function _safeSend(address _to, uint _value) internal {
83         if (!_unsafeSend(_to, _value)) {
84             throw;
85         }
86     }
87 
88     function _unsafeSend(address _to, uint _value) internal returns(bool) {
89         return _to.call.value(_value)();
90     }
91 
92     function _isContract() constant internal returns(bool) {
93         return msg.sender != tx.origin;
94     }
95 
96     function _isHuman() constant internal returns(bool) {
97         return !_isContract();
98     }
99 
100     bool private isCall = false;
101     function _setupNoCallback() internal {
102         isCall = true;
103     }
104 
105     function _finishNoCallback() internal {
106         isCall = false;
107     }
108 }
109 
110 contract AmbiEnabled {
111     Ambi ambiC;
112     bytes32 public name;
113 
114     modifier checkAccess(bytes32 _role) {
115         if(address(ambiC) != 0x0 && ambiC.hasRelation(name, _role, msg.sender)){
116             _
117         }
118     }
119     
120     function getAddress(bytes32 _name) constant returns (address) {
121         return ambiC.getNodeAddress(_name);
122     }
123 
124     function setAmbiAddress(address _ambi, bytes32 _name) returns (bool){
125         if(address(ambiC) != 0x0){
126             return false;
127         }
128         Ambi ambiContract = Ambi(_ambi);
129         if(ambiContract.getNodeAddress(_name)!=address(this)) {
130             bool isNode = ambiContract.addNode(_name, address(this));
131             if (!isNode){
132                 return false;
133             }   
134         }
135         name = _name;
136         ambiC = ambiContract;
137         return true;
138     }
139 
140     function remove() checkAccess("owner") {
141         suicide(msg.sender);
142     }
143 }
144 
145 contract Asset is Safe, AmbiEnabled {
146     event Transfer(address indexed from, address indexed to, uint value);
147     event Approve(address indexed from, address indexed spender, uint value);
148 
149     MultiAsset public multiAsset;
150     bytes32 public symbol;
151 
152     function init(address _multiAsset, bytes32 _symbol) noValue() returns(bool) {
153         MultiAsset ma = MultiAsset(_multiAsset);
154         if (address(multiAsset) != 0x0 || !ma.isCreated(_symbol)) {
155             return false;
156         }
157         multiAsset = ma;
158         symbol = _symbol;
159         return true;
160     }
161 
162     modifier onlyMultiAsset() {
163         if (msg.sender == address(multiAsset)) {
164             _
165         }
166     }
167 
168     function totalSupply() constant returns(uint) {
169         return multiAsset.totalSupply(symbol);
170     }
171 
172     function balanceOf(address _owner) constant returns(uint) {
173         return multiAsset.balanceOf(_owner, symbol);
174     }
175 
176     function allowance(address _from, address _spender) constant returns(uint) {
177         return multiAsset.allowance(_from, _spender, symbol);
178     }
179 
180     function transfer(address _to, uint _value) returns(bool) {
181         return __transferWithReference(_to, _value, "");
182     }
183 
184     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
185         return __transferWithReference(_to, _value, _reference);
186     }
187 
188     function __transferWithReference(address _to, uint _value, string _reference) private noValue() returns(bool) {
189         return _isHuman() ?
190             multiAsset.proxyTransferWithReference(_to, _value, symbol, _reference) :
191             multiAsset.transferFromWithReference(msg.sender, _to, _value, symbol, _reference);
192     }
193 
194     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
195         return __transferToICAPWithReference(_icap, _value, "");
196     }
197 
198     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
199         return __transferToICAPWithReference(_icap, _value, _reference);
200     }
201 
202     function __transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) private noValue() returns(bool) {
203         return _isHuman() ?
204             multiAsset.proxyTransferToICAPWithReference(_icap, _value, _reference) :
205             multiAsset.transferFromToICAPWithReference(msg.sender, _icap, _value, _reference);
206     }
207     
208     function transferFrom(address _from, address _to, uint _value) returns(bool) {
209         return __transferFromWithReference(_from, _to, _value, "");
210     }
211 
212     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
213         return __transferFromWithReference(_from, _to, _value, _reference);
214     }
215 
216     function __transferFromWithReference(address _from, address _to, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
217         return multiAsset.proxyTransferFromWithReference(_from, _to, _value, symbol, _reference);
218     }
219 
220     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
221         return __transferFromToICAPWithReference(_from, _icap, _value, "");
222     }
223 
224     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
225         return __transferFromToICAPWithReference(_from, _icap, _value, _reference);
226     }
227 
228     function __transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
229         return multiAsset.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference);
230     }
231 
232     function approve(address _spender, uint _value) noValue() onlyHuman() returns(bool) {
233         return multiAsset.proxyApprove(_spender, _value, symbol);
234     }
235 
236     function setCosignerAddress(address _cosigner) noValue() onlyHuman() returns(bool) {
237         return multiAsset.proxySetCosignerAddress(_cosigner, symbol);
238     }
239 
240     function emitTransfer(address _from, address _to, uint _value) onlyMultiAsset() {
241         Transfer(_from, _to, _value);
242     }
243 
244     function emitApprove(address _from, address _spender, uint _value) onlyMultiAsset() {
245         Approve(_from, _spender, _value);
246     }
247 
248     function sendToOwner() noValue() returns(bool) {
249         address owner = multiAsset.owner(symbol);
250         uint balance = this.balance;
251         bool success = true;
252         if (balance > 0) {
253             success = _unsafeSend(owner, balance);
254         }
255         return multiAsset.transfer(owner, balanceOf(owner), symbol) && success;
256     }
257 }
258 
259 contract HayekGold is Asset {
260     uint public txGasPriceLimit = 21000000000;
261     uint public refundGas = 40000;
262     uint public transferCallGas = 21000;
263     uint public transferWithReferenceCallGas = 21000;
264     uint public transferFromCallGas = 21000;
265     uint public transferFromWithReferenceCallGas = 21000;
266     uint public transferToICAPCallGas = 21000;
267     uint public transferToICAPWithReferenceCallGas = 21000;
268     uint public transferFromToICAPCallGas = 21000;
269     uint public transferFromToICAPWithReferenceCallGas = 21000;
270     uint public approveCallGas = 21000;
271     uint public forwardCallGas = 21000;
272     uint public setCosignerCallGas = 21000;
273     EtherTreasuryInterface public treasury;
274     mapping(bytes32 => address) public allowedForwards;
275 
276     function updateRefundGas() noValue() checkAccess("setup") returns(uint) {
277         uint startGas = msg.gas;
278         // just to simulate calculations
279         uint refund = (startGas - msg.gas + refundGas) * tx.gasprice;
280         if (tx.gasprice > txGasPriceLimit) {
281             return 0;
282         }
283         // end.
284         if (!_refund(1)) {
285             return 0;
286         }
287         refundGas = startGas - msg.gas;
288         return refundGas;
289     }
290 
291     function setOperationsCallGas
292         (
293             uint _transfer,
294             uint _transferFrom,
295             uint _transferToICAP,
296             uint _transferFromToICAP,
297             uint _transferWithReference,
298             uint _transferFromWithReference,
299             uint _transferToICAPWithReference,
300             uint _transferFromToICAPWithReference,
301             uint _approve,
302             uint _forward,
303             uint _setCosigner
304         ) noValue() checkAccess("setup") returns(bool)
305     {
306         transferCallGas = _transfer;
307         transferFromCallGas = _transferFrom;
308         transferToICAPCallGas = _transferToICAP;
309         transferFromToICAPCallGas = _transferFromToICAP;
310         transferWithReferenceCallGas = _transferWithReference;
311         transferFromWithReferenceCallGas = _transferFromWithReference;
312         transferToICAPWithReferenceCallGas = _transferToICAPWithReference;
313         transferFromToICAPWithReferenceCallGas = _transferFromToICAPWithReference;
314         approveCallGas = _approve;
315         forwardCallGas = _forward;
316         setCosignerCallGas = _setCosigner;
317         return true;
318     }
319 
320     function setupTreasury(address _treasury, uint _txGasPriceLimit) checkAccess("admin") returns(bool) {
321         if (_txGasPriceLimit == 0) {
322             return false;
323         }
324         treasury = EtherTreasuryInterface(_treasury);
325         txGasPriceLimit = _txGasPriceLimit;
326         if (msg.value > 0) {
327             _safeSend(_treasury, msg.value);
328         }
329         return true;
330     }
331 
332     function setForward(bytes4 _msgSig, address _forward) noValue() checkAccess("admin") returns(bool) {
333         allowedForwards[sha3(_msgSig)] = _forward;
334         return true;
335     }
336 
337     function _stringGas(string _string) constant internal returns(uint) {
338         return bytes(_string).length * 75; // ~75 gas per byte, empirical shown 68-72.
339     }
340 
341     function _applyRefund(uint _startGas) internal returns(bool) {
342         if (tx.gasprice > txGasPriceLimit) {
343             return false;
344         }
345         uint refund = (_startGas - msg.gas + refundGas) * tx.gasprice;
346         return _refund(refund);
347     }
348 
349     function _refund(uint _value) internal returns(bool) {
350         return treasury.withdraw(tx.origin, _value);
351     }
352 
353     function _transfer(address _to, uint _value) internal returns(bool, bool) {
354         uint startGas = msg.gas + transferCallGas;
355         if (!super.transfer(_to, _value)) {
356             return (false, false);
357         }
358         return (true, _applyRefund(startGas));
359     }
360 
361     function _transferFrom(address _from, address _to, uint _value) internal returns(bool, bool) {
362         uint startGas = msg.gas + transferFromCallGas;
363         if (!super.transferFrom(_from, _to, _value)) {
364             return (false, false);
365         }
366         return (true, _applyRefund(startGas));
367     }
368 
369     function _transferToICAP(bytes32 _icap, uint _value) internal returns(bool, bool) {
370         uint startGas = msg.gas + transferToICAPCallGas;
371         if (!super.transferToICAP(_icap, _value)) {
372             return (false, false);
373         }
374         return (true, _applyRefund(startGas));
375     }
376 
377     function _transferFromToICAP(address _from, bytes32 _icap, uint _value) internal returns(bool, bool) {
378         uint startGas = msg.gas + transferFromToICAPCallGas;
379         if (!super.transferFromToICAP(_from, _icap, _value)) {
380             return (false, false);
381         }
382         return (true, _applyRefund(startGas));
383     }
384 
385     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool, bool) {
386         uint startGas = msg.gas + transferWithReferenceCallGas + _stringGas(_reference);
387         if (!super.transferWithReference(_to, _value, _reference)) {
388             return (false, false);
389         }
390         return (true, _applyRefund(startGas));
391     }
392 
393     function _transferFromWithReference(address _from, address _to, uint _value, string _reference) internal returns(bool, bool) {
394         uint startGas = msg.gas + transferFromWithReferenceCallGas + _stringGas(_reference);
395         if (!super.transferFromWithReference(_from, _to, _value, _reference)) {
396             return (false, false);
397         }
398         return (true, _applyRefund(startGas));
399     }
400 
401     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) internal returns(bool, bool) {
402         uint startGas = msg.gas + transferToICAPWithReferenceCallGas + _stringGas(_reference);
403         if (!super.transferToICAPWithReference(_icap, _value, _reference)) {
404             return (false, false);
405         }
406         return (true, _applyRefund(startGas));
407     }
408 
409     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) internal returns(bool, bool) {
410         uint startGas = msg.gas + transferFromToICAPWithReferenceCallGas + _stringGas(_reference);
411         if (!super.transferFromToICAPWithReference(_from, _icap, _value, _reference)) {
412             return (false, false);
413         }
414         return (true, _applyRefund(startGas));
415     }
416 
417     function _approve(address _spender, uint _value) internal returns(bool, bool) {
418         uint startGas = msg.gas + approveCallGas;
419         if (!super.approve(_spender, _value)) {
420             return (false, false);
421         }
422         return (true, _applyRefund(startGas));
423     }
424 
425     function _setCosignerAddress(address _cosigner) internal returns(bool, bool) {
426         uint startGas = msg.gas + setCosignerCallGas;
427         if (!super.setCosignerAddress(_cosigner)) {
428             return (false, false);
429         }
430         return (true, _applyRefund(startGas));
431     }
432 
433     function transfer(address _to, uint _value) returns(bool) {
434         bool success;
435         (success,) = _transfer(_to, _value);
436         return success;
437     }
438 
439     function transferFrom(address _from, address _to, uint _value) returns(bool) {
440         bool success;
441         (success,) = _transferFrom(_from, _to, _value);
442         return success;
443     }
444 
445     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
446         bool success;
447         (success,) = _transferToICAP(_icap, _value);
448         return success;
449     }
450 
451     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
452         bool success;
453         (success,) = _transferFromToICAP(_from, _icap, _value);
454         return success;
455     }
456 
457     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
458         bool success;
459         (success,) = _transferWithReference(_to, _value, _reference);
460         return success;
461     }
462 
463     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
464         bool success;
465         (success,) = _transferFromWithReference(_from, _to, _value, _reference);
466         return success;
467     }
468 
469     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
470         bool success;
471         (success,) = _transferToICAPWithReference(_icap, _value, _reference);
472         return success;
473     }
474 
475     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
476         bool success;
477         (success,) = _transferFromToICAPWithReference(_from, _icap, _value, _reference);
478         return success;
479     }
480 
481     function approve(address _spender, uint _value) returns(bool) {
482         bool success;
483         (success,) = _approve(_spender, _value);
484         return success;
485     }
486 
487     function setCosignerAddress(address _cosigner) returns(bool) {
488         bool success;
489         (success,) = _setCosignerAddress(_cosigner);
490         return success;
491     }
492 
493     function checkTransfer(address _to, uint _value) constant returns(bool, bool) {
494         return _transfer(_to, _value);
495     }
496 
497     function checkTransferFrom(address _from, address _to, uint _value) constant returns(bool, bool) {
498         return _transferFrom(_from, _to, _value);
499     }
500 
501     function checkTransferToICAP(bytes32 _icap, uint _value) constant returns(bool, bool) {
502         return _transferToICAP(_icap, _value);
503     }
504 
505     function checkTransferFromToICAP(address _from, bytes32 _icap, uint _value) constant returns(bool, bool) {
506         return _transferFromToICAP(_from, _icap, _value);
507     }
508 
509     function checkTransferWithReference(address _to, uint _value, string _reference) constant returns(bool, bool) {
510         return _transferWithReference(_to, _value, _reference);
511     }
512 
513     function checkTransferFromWithReference(address _from, address _to, uint _value, string _reference) constant returns(bool, bool) {
514         return _transferFromWithReference(_from, _to, _value, _reference);
515     }
516 
517     function checkTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) constant returns(bool, bool) {
518         return _transferToICAPWithReference(_icap, _value, _reference);
519     }
520 
521     function checkTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) constant returns(bool, bool) {
522         return _transferFromToICAPWithReference(_from, _icap, _value, _reference);
523     }
524 
525     function checkApprove(address _spender, uint _value) constant returns(bool, bool) {
526         return _approve(_spender, _value);
527     }
528 
529     function checkSetCosignerAddress(address _cosigner) constant returns(bool, bool) {
530         return _setCosignerAddress(_cosigner);
531     }
532 
533     function checkForward(bytes _data) constant returns(bool, bool) {
534         bytes memory sig = new bytes(4);
535         sig[0] = _data[0];
536         sig[1] = _data[1];
537         sig[2] = _data[2];
538         sig[3] = _data[3];
539         return _forward(allowedForwards[sha3(sig)], _data);
540     }
541 
542     function _forward(address _to, bytes _data) internal returns(bool, bool) {
543         uint startGas = msg.gas + forwardCallGas + (_data.length * 50); // 50 gas per byte;
544         if (_to == 0x0) {
545             return (false, _safeFalse());
546         }
547         if (!_to.call.value(msg.value)(_data)) {
548             return (false, _safeFalse());
549         }
550         return (true, _applyRefund(startGas));
551     }
552 
553     function () returns(bool) {
554         bool success;
555         (success,) = _forward(allowedForwards[sha3(msg.sig)], msg.data);
556         return success;
557     }
558 }