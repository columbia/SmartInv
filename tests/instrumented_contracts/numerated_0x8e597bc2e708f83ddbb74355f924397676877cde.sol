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
110 contract Asset is Safe {
111     event Transfer(address indexed from, address indexed to, uint value);
112     event Approve(address indexed from, address indexed spender, uint value);
113 
114     MultiAsset public multiAsset;
115     bytes32 public symbol;
116 
117     function init(address _multiAsset, bytes32 _symbol) noValue() immutable(address(multiAsset)) returns(bool) {
118         MultiAsset ma = MultiAsset(_multiAsset);
119         if (!ma.isCreated(_symbol)) {
120             return false;
121         }
122         multiAsset = ma;
123         symbol = _symbol;
124         return true;
125     }
126 
127     modifier onlyMultiAsset() {
128         if (msg.sender == address(multiAsset)) {
129             _
130         }
131     }
132 
133     function totalSupply() constant returns(uint) {
134         return multiAsset.totalSupply(symbol);
135     }
136 
137     function balanceOf(address _owner) constant returns(uint) {
138         return multiAsset.balanceOf(_owner, symbol);
139     }
140 
141     function allowance(address _from, address _spender) constant returns(uint) {
142         return multiAsset.allowance(_from, _spender, symbol);
143     }
144 
145     function transfer(address _to, uint _value) returns(bool) {
146         return __transferWithReference(_to, _value, "");
147     }
148 
149     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
150         return __transferWithReference(_to, _value, _reference);
151     }
152 
153     function __transferWithReference(address _to, uint _value, string _reference) private noValue() returns(bool) {
154         return _isHuman() ?
155             multiAsset.proxyTransferWithReference(_to, _value, symbol, _reference) :
156             multiAsset.transferFromWithReference(msg.sender, _to, _value, symbol, _reference);
157     }
158 
159     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
160         return __transferToICAPWithReference(_icap, _value, "");
161     }
162 
163     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
164         return __transferToICAPWithReference(_icap, _value, _reference);
165     }
166 
167     function __transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) private noValue() returns(bool) {
168         return _isHuman() ?
169             multiAsset.proxyTransferToICAPWithReference(_icap, _value, _reference) :
170             multiAsset.transferFromToICAPWithReference(msg.sender, _icap, _value, _reference);
171     }
172     
173     function transferFrom(address _from, address _to, uint _value) returns(bool) {
174         return __transferFromWithReference(_from, _to, _value, "");
175     }
176 
177     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
178         return __transferFromWithReference(_from, _to, _value, _reference);
179     }
180 
181     function __transferFromWithReference(address _from, address _to, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
182         return multiAsset.proxyTransferFromWithReference(_from, _to, _value, symbol, _reference);
183     }
184 
185     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
186         return __transferFromToICAPWithReference(_from, _icap, _value, "");
187     }
188 
189     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
190         return __transferFromToICAPWithReference(_from, _icap, _value, _reference);
191     }
192 
193     function __transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
194         return multiAsset.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference);
195     }
196 
197     function approve(address _spender, uint _value) noValue() onlyHuman() returns(bool) {
198         return multiAsset.proxyApprove(_spender, _value, symbol);
199     }
200 
201     function setCosignerAddress(address _cosigner) noValue() onlyHuman() returns(bool) {
202         return multiAsset.proxySetCosignerAddress(_cosigner, symbol);
203     }
204 
205     function emitTransfer(address _from, address _to, uint _value) onlyMultiAsset() {
206         Transfer(_from, _to, _value);
207     }
208 
209     function emitApprove(address _from, address _spender, uint _value) onlyMultiAsset() {
210         Approve(_from, _spender, _value);
211     }
212 
213     function sendToOwner() noValue() returns(bool) {
214         address owner = multiAsset.owner(symbol);
215         uint balance = this.balance;
216         bool success = true;
217         if (balance > 0) {
218             success = _unsafeSend(owner, balance);
219         }
220         return multiAsset.transfer(owner, balanceOf(owner), symbol) && success;
221     }
222 }
223 
224 contract AmbiEnabled {
225     Ambi public ambiC;
226     bool public isImmortal;
227     bytes32 public name;
228 
229     modifier checkAccess(bytes32 _role) {
230         if(address(ambiC) != 0x0 && ambiC.hasRelation(name, _role, msg.sender)){
231             _
232         }
233     }
234     
235     function getAddress(bytes32 _name) constant returns (address) {
236         return ambiC.getNodeAddress(_name);
237     }
238 
239     function setAmbiAddress(address _ambi, bytes32 _name) returns (bool){
240         if(address(ambiC) != 0x0){
241             return false;
242         }
243         Ambi ambiContract = Ambi(_ambi);
244         if(ambiContract.getNodeAddress(_name)!=address(this)) {
245             if (!ambiContract.addNode(_name, address(this))){
246                 return false;
247             }
248         }
249         name = _name;
250         ambiC = ambiContract;
251         return true;
252     }
253 
254     function immortality() checkAccess("owner") returns(bool) {
255         isImmortal = true;
256         return true;
257     }
258 
259     function remove() checkAccess("owner") returns(bool) {
260         if (isImmortal) {
261             return false;
262         }
263         selfdestruct(msg.sender);
264         return true;
265     }
266 }
267 
268 contract CryptoCarbon is Asset, AmbiEnabled {
269     uint public txGasPriceLimit = 21000000000;
270     uint public refundGas = 40000;
271     uint public transferCallGas = 21000;
272     uint public transferWithReferenceCallGas = 21000;
273     uint public transferFromCallGas = 21000;
274     uint public transferFromWithReferenceCallGas = 21000;
275     uint public transferToICAPCallGas = 21000;
276     uint public transferToICAPWithReferenceCallGas = 21000;
277     uint public transferFromToICAPCallGas = 21000;
278     uint public transferFromToICAPWithReferenceCallGas = 21000;
279     uint public approveCallGas = 21000;
280     uint public forwardCallGas = 21000;
281     uint public setCosignerCallGas = 21000;
282     uint public absMinFee;
283     uint public feePercent; // set up in 1/100 of percent, 10 is 0.1%
284     uint public absMaxFee;
285     EtherTreasuryInterface public treasury;
286     address public feeAddress;
287     bool private __isAllowed;
288     mapping(bytes32 => address) public allowedForwards;
289 
290     function setFeeStructure(uint _absMinFee, uint _feePercent, uint _absMaxFee) noValue() checkAccess("cron") returns (bool) {
291         if(_feePercent > 10000 || _absMaxFee < _absMinFee) {
292             return false;
293         }
294         absMinFee = _absMinFee;
295         feePercent = _feePercent;
296         absMaxFee = _absMaxFee;
297         return true;
298     }
299 
300     function setupFee(address _feeAddress) noValue() checkAccess("admin") returns(bool) {
301         feeAddress = _feeAddress;
302         return true;
303     }
304 
305     function updateRefundGas() noValue() checkAccess("setup") returns(uint) {
306         uint startGas = msg.gas;
307         // just to simulate calculations
308         uint refund = (startGas - msg.gas + refundGas) * tx.gasprice;
309         if (tx.gasprice > txGasPriceLimit) {
310             return 0;
311         }
312         // end
313         if (!_refund(5000000000000000)) {
314             return 0;
315         }
316         refundGas = startGas - msg.gas;
317         return refundGas;
318     }
319 
320     function setOperationsCallGas(
321         uint _transfer,
322         uint _transferFrom,
323         uint _transferToICAP,
324         uint _transferFromToICAP,
325         uint _transferWithReference,
326         uint _transferFromWithReference,
327         uint _transferToICAPWithReference,
328         uint _transferFromToICAPWithReference,
329         uint _approve,
330         uint _forward,
331         uint _setCosigner
332     )
333         noValue()
334         checkAccess("setup")
335         returns(bool)
336     {
337         transferCallGas = _transfer;
338         transferFromCallGas = _transferFrom;
339         transferToICAPCallGas = _transferToICAP;
340         transferFromToICAPCallGas = _transferFromToICAP;
341         transferWithReferenceCallGas = _transferWithReference;
342         transferFromWithReferenceCallGas = _transferFromWithReference;
343         transferToICAPWithReferenceCallGas = _transferToICAPWithReference;
344         transferFromToICAPWithReferenceCallGas = _transferFromToICAPWithReference;
345         approveCallGas = _approve;
346         forwardCallGas = _forward;
347         setCosignerCallGas = _setCosigner;
348         return true;
349     }
350 
351     function setupTreasury(address _treasury, uint _txGasPriceLimit) checkAccess("admin") returns(bool) {
352         if (_txGasPriceLimit == 0) {
353             return _safeFalse();
354         }
355         treasury = EtherTreasuryInterface(_treasury);
356         txGasPriceLimit = _txGasPriceLimit;
357         if (msg.value > 0) {
358             _safeSend(_treasury, msg.value);
359         }
360         return true;
361     }
362 
363     function setForward(bytes4 _msgSig, address _forward) noValue() checkAccess("admin") returns(bool) {
364         allowedForwards[sha3(_msgSig)] = _forward;
365         return true;
366     }
367 
368     function _stringGas(string _string) constant internal returns(uint) {
369         return bytes(_string).length * 75; // ~75 gas per byte, empirical shown 68-72.
370     }
371 
372     function _transferFee(address _feeFrom, uint _value, string _reference) internal returns(bool) {
373         if (feeAddress == 0x0 || feeAddress == _feeFrom || _value == 0) {
374             return true;
375         }
376         return multiAsset.transferFromWithReference(_feeFrom, feeAddress, _value, symbol, _reference);
377     }
378 
379     function _returnFee(address _to, uint _value) internal returns(bool, bool) {
380         if (feeAddress == 0x0 || feeAddress == _to || _value == 0) {
381             return (false, true);
382         }
383         if (!multiAsset.transferFromWithReference(feeAddress, _to, _value, symbol, "Fee return")) {
384             throw;
385         }
386         return (false, true);
387     }
388 
389     function _applyRefund(uint _startGas) internal returns(bool) {
390         uint refund = (_startGas - msg.gas + refundGas) * tx.gasprice;
391         return _refund(refund);
392     }
393 
394     function _refund(uint _value) internal returns(bool) {
395         if (tx.gasprice > txGasPriceLimit) {
396             return false;
397         }
398         return treasury.withdraw(tx.origin, _value);
399     }
400 
401     function _allow() internal {
402         __isAllowed = true;
403     }
404 
405     function _disallow() internal {
406         __isAllowed = false;
407     }
408 
409     function calculateFee(uint _value) constant returns(uint) {
410         uint fee = (_value * feePercent) / 10000;
411         if (fee < absMinFee) {
412             return absMinFee;
413         }
414         if (fee > absMaxFee) {
415             return absMaxFee;
416         }
417         return fee;
418     }
419 
420     function calculateFeeDynamic(uint _value, uint _additionalGas) constant returns(uint) {
421         uint fee = calculateFee(_value);
422         if (_additionalGas <= 7500) {
423             return fee;
424         }
425         // Assuming that absMinFee covers at least 100000 gas refund, let's add another absMinFee
426         // for every other 100000 additional gas.
427         uint additionalFee = ((_additionalGas / 100000) + 1) * absMinFee;
428         return fee + additionalFee;
429     }
430 
431     function takeFee(address _feeFrom, uint _value, string _reference) noValue() checkAccess("fee") returns(bool) {
432         return _transferFee(_feeFrom, _value, _reference);
433     }
434 
435     function _transfer(address _to, uint _value) internal returns(bool, bool) {
436         uint startGas = msg.gas + transferCallGas;
437         uint fee = calculateFee(_value);
438         if (!_transferFee(msg.sender, fee, "Transfer fee")) {
439             return (false, false);
440         }
441         _allow();
442         bool success = super.transfer(_to, _value);
443         _disallow();
444         if (!success) {
445             return _returnFee(msg.sender, fee);
446         }
447         return (true, _applyRefund(startGas));
448     }
449 
450     function _transferFrom(address _from, address _to, uint _value) internal returns(bool, bool) {
451         uint startGas = msg.gas + transferFromCallGas;
452         _allow();
453         uint fee = calculateFee(_value);
454         if (!_transferFee(_from, fee, "Transfer fee")) {
455             return (false, false);
456         }
457         _allow();
458         bool success = super.transferFrom(_from, _to, _value);
459         _disallow();
460         if (!success) {
461             return _returnFee(_from, fee);
462         }
463         return (true, _applyRefund(startGas));
464     }
465 
466     function _transferToICAP(bytes32 _icap, uint _value) internal returns(bool, bool) {
467         uint startGas = msg.gas + transferToICAPCallGas;
468         uint fee = calculateFee(_value);
469         if (!_transferFee(msg.sender, fee, "Transfer fee")) {
470             return (false, false);
471         }
472         _allow();
473         bool success = super.transferToICAP(_icap, _value);
474         _disallow();
475         if (!success) {
476             return _returnFee(msg.sender, fee);
477         }
478         return (true, _applyRefund(startGas));
479     }
480 
481     function _transferFromToICAP(address _from, bytes32 _icap, uint _value) internal returns(bool, bool) {
482         uint startGas = msg.gas + transferFromToICAPCallGas;
483         uint fee = calculateFee(_value);
484         if (!_transferFee(_from, fee, "Transfer fee")) {
485             return (false, false);
486         }
487         _allow();
488         bool success = super.transferFromToICAP(_from, _icap, _value);
489         _disallow();
490         if (!success) {
491             return _returnFee(_from, fee);
492         }
493         return (true, _applyRefund(startGas));
494     }
495 
496     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool, bool) {
497         uint startGas = msg.gas + transferWithReferenceCallGas;
498         uint additionalGas = _stringGas(_reference);
499         uint fee = calculateFeeDynamic(_value, additionalGas);
500         if (!_transferFee(msg.sender, fee, "Transfer fee")) {
501             return (false, false);
502         }
503         _allow();
504         bool success = super.transferWithReference(_to, _value, _reference);
505         _disallow();
506         if (!success) {
507             return _returnFee(msg.sender, fee);
508         }
509         return (true, _applyRefund(startGas + additionalGas));
510     }
511 
512     function _transferFromWithReference(address _from, address _to, uint _value, string _reference) internal returns(bool, bool) {
513         uint startGas = msg.gas + transferFromWithReferenceCallGas;
514         uint additionalGas = _stringGas(_reference);
515         uint fee = calculateFeeDynamic(_value, additionalGas);
516         if (!_transferFee(_from, fee, "Transfer fee")) {
517             return (false, false);
518         }
519         _allow();
520         bool success = super.transferFromWithReference(_from, _to, _value, _reference);
521         _disallow();
522         if (!success) {
523             return _returnFee(_from, fee);
524         }
525         return (true, _applyRefund(startGas + additionalGas));
526     }
527 
528     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) internal returns(bool, bool) {
529         uint startGas = msg.gas + transferToICAPWithReferenceCallGas;
530         uint additionalGas = _stringGas(_reference);
531         uint fee = calculateFeeDynamic(_value, additionalGas);
532         if (!_transferFee(msg.sender, fee, "Transfer fee")) {
533             return (false, false);
534         }
535         _allow();
536         bool success = super.transferToICAPWithReference(_icap, _value, _reference);
537         _disallow();
538         if (!success) {
539             return _returnFee(msg.sender, fee);
540         }
541         return (true, _applyRefund(startGas + additionalGas));
542     }
543 
544     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) internal returns(bool, bool) {
545         uint startGas = msg.gas + transferFromToICAPWithReferenceCallGas;
546         uint additionalGas = _stringGas(_reference);
547         uint fee = calculateFeeDynamic(_value, additionalGas);
548         if (!_transferFee(_from, fee, "Transfer fee")) {
549             return (false, false);
550         }
551         _allow();
552         bool success = super.transferFromToICAPWithReference(_from, _icap, _value, _reference);
553         _disallow();
554         if (!success) {
555             return _returnFee(_from, fee);
556         }
557         return (true, _applyRefund(startGas + additionalGas));
558     }
559 
560     function _approve(address _spender, uint _value) internal returns(bool, bool) {
561         uint startGas = msg.gas + approveCallGas;
562         // Don't take fee when enabling fee taking.
563         // Don't refund either.
564         if (_spender == address(this)) {
565             return (super.approve(_spender, _value), false);
566         }
567         uint fee = calculateFee(0);
568         if (!_transferFee(msg.sender, fee, "Approve fee")) {
569             return (false, false);
570         }
571         _allow();
572         bool success = super.approve(_spender, _value);
573         _disallow();
574         if (!success) {
575             return _returnFee(msg.sender, fee);
576         }
577         return (true, _applyRefund(startGas));
578     }
579 
580     function _setCosignerAddress(address _cosigner) internal returns(bool, bool) {
581         uint startGas = msg.gas + setCosignerCallGas;
582         uint fee = calculateFee(0);
583         if (!_transferFee(msg.sender, fee, "Cosigner fee")) {
584             return (false, false);
585         }
586         if (!super.setCosignerAddress(_cosigner)) {
587             return _returnFee(msg.sender, fee);
588         }
589         return (true, _applyRefund(startGas));
590     }
591 
592     function transfer(address _to, uint _value) returns(bool) {
593         bool success;
594         (success,) = _transfer(_to, _value);
595         return success;
596     }
597 
598     function transferFrom(address _from, address _to, uint _value) returns(bool) {
599         bool success;
600         (success,) = _transferFrom(_from, _to, _value);
601         return success;
602     }
603 
604     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
605         bool success;
606         (success,) = _transferToICAP(_icap, _value);
607         return success;
608     }
609 
610     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
611         bool success;
612         (success,) = _transferFromToICAP(_from, _icap, _value);
613         return success;
614     }
615 
616     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
617         bool success;
618         (success,) = _transferWithReference(_to, _value, _reference);
619         return success;
620     }
621 
622     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
623         bool success;
624         (success,) = _transferFromWithReference(_from, _to, _value, _reference);
625         return success;
626     }
627 
628     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
629         bool success;
630         (success,) = _transferToICAPWithReference(_icap, _value, _reference);
631         return success;
632     }
633 
634     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
635         bool success;
636         (success,) = _transferFromToICAPWithReference(_from, _icap, _value, _reference);
637         return success;
638     }
639 
640     function approve(address _spender, uint _value) returns(bool) {
641         bool success;
642         (success,) = _approve(_spender, _value);
643         return success;
644     }
645 
646     function setCosignerAddress(address _cosigner) returns(bool) {
647         bool success;
648         (success,) = _setCosignerAddress(_cosigner);
649         return success;
650     }
651 
652     function checkTransfer(address _to, uint _value) constant returns(bool, bool) {
653         return _transfer(_to, _value);
654     }
655 
656     function checkTransferFrom(address _from, address _to, uint _value) constant returns(bool, bool) {
657         return _transferFrom(_from, _to, _value);
658     }
659 
660     function checkTransferToICAP(bytes32 _icap, uint _value) constant returns(bool, bool) {
661         return _transferToICAP(_icap, _value);
662     }
663 
664     function checkTransferFromToICAP(address _from, bytes32 _icap, uint _value) constant returns(bool, bool) {
665         return _transferFromToICAP(_from, _icap, _value);
666     }
667 
668     function checkTransferWithReference(address _to, uint _value, string _reference) constant returns(bool, bool) {
669         return _transferWithReference(_to, _value, _reference);
670     }
671 
672     function checkTransferFromWithReference(address _from, address _to, uint _value, string _reference) constant returns(bool, bool) {
673         return _transferFromWithReference(_from, _to, _value, _reference);
674     }
675 
676     function checkTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) constant returns(bool, bool) {
677         return _transferToICAPWithReference(_icap, _value, _reference);
678     }
679 
680     function checkTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) constant returns(bool, bool) {
681         return _transferFromToICAPWithReference(_from, _icap, _value, _reference);
682     }
683 
684     function checkApprove(address _spender, uint _value) constant returns(bool, bool) {
685         return _approve(_spender, _value);
686     }
687 
688     function checkSetCosignerAddress(address _cosigner) constant returns(bool, bool) {
689         return _setCosignerAddress(_cosigner);
690     }
691 
692     function checkForward(bytes _data) constant returns(bool, bool) {
693         return _forward(allowedForwards[sha3(_data[0], _data[1], _data[2], _data[3])], _data);
694     }
695 
696     function _forward(address _to, bytes _data) internal returns(bool, bool) {
697         uint startGas = msg.gas + forwardCallGas;
698         uint additionalGas = (_data.length * 50);  // 50 gas per byte;
699         if (_to == 0x0) {
700             return (false, _safeFalse());
701         }
702         uint fee = calculateFeeDynamic(0, additionalGas);
703         if (!_transferFee(msg.sender, fee, "Forward fee")) {
704             return (false, false);
705         }
706         if (!_to.call.value(msg.value)(_data)) {
707             _returnFee(msg.sender, fee);
708             return (false, _safeFalse());
709         }
710         return (true, _applyRefund(startGas + additionalGas));
711     }
712 
713     function () returns(bool) {
714         bool success;
715         (success,) = _forward(allowedForwards[sha3(msg.sig)], msg.data);
716         return success;
717     }
718 
719     function emitTransfer(address _from, address _to, uint _value) onlyMultiAsset() {
720         Transfer(_from, _to, _value);
721         if (__isAllowed) {
722             return;
723         }
724         if (feeAddress == 0x0 || _to == feeAddress || _from == feeAddress) {
725             return;
726         }
727         if (_transferFee(_from, calculateFee(_value), "Transfer fee")) {
728             return;
729         }
730         throw;
731     }
732 
733     function emitApprove(address _from, address _spender, uint _value) onlyMultiAsset() {
734         Approve(_from, _spender, _value);
735         if (__isAllowed) {
736             return;
737         }
738         if (feeAddress == 0x0 || _spender == address(this)) {
739             return;
740         }
741         if (_transferFee(_from, calculateFee(0), "Approve fee")) {
742             return;
743         }
744         throw;
745     }
746 }