1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function transfer(address _to, uint256 _value) public returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6 }
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         require(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a);
31         return c;
32     }
33 
34     function min(uint a, uint b) internal pure returns (uint) {
35         if (a >= b)
36             return b;
37         return a;
38     }
39 
40     function max(uint a, uint b) internal pure returns (uint) {
41         if (a >= b)
42             return a;
43         return b;
44     }
45 }
46 
47 contract DSAuthority {
48     function canCall(
49         address src,
50         address dst,
51         bytes4 sig
52         ) public view returns (bool);
53 }
54 
55 contract DSAuthEvents {
56     event LogSetAuthority (address indexed authority);
57     event LogSetOwner     (address indexed owner);
58 }
59 
60 contract DSAuth is DSAuthEvents {
61     DSAuthority  public  authority;
62     address      public  owner;
63 
64     constructor() public {
65         owner = msg.sender;
66         emit LogSetOwner(msg.sender);
67     }
68 
69     function setOwner(address owner_)
70         public
71         auth
72     {
73         owner = owner_;
74         emit LogSetOwner(owner);
75     }
76 
77     function setAuthority(DSAuthority authority_)
78         public
79         auth
80     {
81         authority = authority_;
82         emit LogSetAuthority(authority);
83     }
84 
85     modifier auth {
86         require(isAuthorized(msg.sender, msg.sig));
87         _;
88     }
89 
90     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
91         if (src == address(this)) {
92             return true;
93         } else if (src == owner) {
94             return true;
95         } else if (authority == DSAuthority(0)) {
96             return false;
97         } else {
98             return authority.canCall(src, this, sig);
99         }
100     }
101 }
102 
103 contract Exchange is DSAuth {
104 
105     using SafeMath for uint;
106 
107     ERC20 public daiToken;
108     mapping(address => uint) public dai;
109     mapping(address => uint) public eth;
110 
111     mapping(address => uint) public totalEth;
112     mapping(address => uint) public totalDai;
113 
114     mapping(bytes32 => mapping(address => uint)) public callsOwned;
115     mapping(bytes32 => mapping(address => uint)) public putsOwned;
116     mapping(bytes32 => mapping(address => uint)) public callsSold;
117     mapping(bytes32 => mapping(address => uint)) public putsSold;
118 
119     mapping(bytes32 => uint) public callsAssigned;
120     mapping(bytes32 => uint) public putsAssigned;
121     mapping(bytes32 => uint) public callsExercised;
122     mapping(bytes32 => uint) public putsExercised;
123 
124     mapping(address => mapping(bytes32 => bool)) public cancelled;
125     mapping(address => mapping(bytes32 => uint)) public filled;
126 
127     mapping(address => uint) public feeRebates;
128     mapping(bytes32 => bool) public claimedFeeRebate;
129 
130     // fee values are actually in DAI, ether is just a keyword
131     uint public flatFee       = 7 ether;
132     uint public contractFee   = 1 ether;
133     uint public exerciseFee   = 20 ether;
134     uint public settlementFee = 20 ether;
135     uint public feesCollected = 0;
136     uint public feesWithdrawn = 0;
137 
138     string precisionError = "Precision";
139 
140     constructor(address daiAddress) public {
141         require(daiAddress != 0x0);
142         daiToken = ERC20(daiAddress);
143     }
144 
145     function() public payable {
146         revert();
147     }
148 
149     event Deposit(address indexed account, uint amount);
150     event Withdraw(address indexed account, uint amount, address to);
151     event DepositDai(address indexed account, uint amount);
152     event WithdrawDai(address indexed account, uint amount, address to);
153 
154     function deposit() public payable {
155         _addEth(msg.value, msg.sender);
156         emit Deposit(msg.sender, msg.value);
157     }
158 
159     function depositDai(uint amount) public {
160         require(daiToken.transferFrom(msg.sender, this, amount));
161         _addDai(amount, msg.sender);
162         emit DepositDai(msg.sender, amount);
163     }
164 
165     function withdraw(uint amount, address to) public {
166         require(to != 0x0);
167         _subEth(amount, msg.sender);
168         to.transfer(amount);
169         emit Withdraw(msg.sender, amount, to);
170     }
171 
172     function withdrawDai(uint amount, address to) public {
173         require(to != 0x0);
174         _subDai(amount, msg.sender);
175         daiToken.transfer(to, amount);
176         emit WithdrawDai(msg.sender, amount, to);
177     }
178 
179     function depositDaiFor(uint amount, address account) public {
180         require(account != 0x0);
181         require(daiToken.transferFrom(msg.sender, this, amount));
182         _addDai(amount, account);
183         emit DepositDai(account, amount);
184     }
185 
186     function _addEth(uint amount, address account) private {
187         eth[account] = eth[account].add(amount);
188         totalEth[account] = totalEth[account].add(amount);
189     }
190 
191     function _subEth(uint amount, address account) private {
192         eth[account] = eth[account].sub(amount);
193         totalEth[account] = totalEth[account].sub(amount);
194     }
195 
196     function _addDai(uint amount, address account) private {
197         dai[account] = dai[account].add(amount);
198         totalDai[account] = totalDai[account].add(amount);
199     }
200 
201     function _subDai(uint amount, address account) private {
202         dai[account] = dai[account].sub(amount);
203         totalDai[account] = totalDai[account].sub(amount);
204     }
205 
206     // ===== Admin functions ===== //
207 
208     function setFeeSchedule(
209         uint _flatFee,
210         uint _contractFee,
211         uint _exerciseFee,
212         uint _settlementFee
213     ) public auth {
214         flatFee = _flatFee;
215         contractFee = _contractFee;
216         exerciseFee = _exerciseFee;
217         settlementFee = _settlementFee;
218 
219         require(contractFee < 5 ether);
220         require(flatFee < 6.95 ether);
221         require(exerciseFee < 20 ether);
222         require(settlementFee < 20 ether);
223     }
224 
225     function withdrawFees(address to) public auth {
226         require(to != 0x0);
227         uint amount = feesCollected.sub(feesWithdrawn);
228         feesWithdrawn = feesCollected;
229         require(daiToken.transfer(to, amount));
230     }
231 
232     // ===== End Admin Functions ===== //
233 
234     modifier hasFee(uint amount) {
235         _;
236         _collectFee(msg.sender, calculateFee(amount));
237     }
238 
239     enum Action {
240         BuyCallToOpen,
241         BuyCallToClose,
242         SellCallToOpen,
243         SellCallToClose,
244         BuyPutToOpen,
245         BuyPutToClose,
246         SellPutToOpen,
247         SellPutToClose
248     }
249 
250     event CancelOrder(address indexed account, bytes32 h);
251     function cancelOrder(bytes32 h) public {
252         cancelled[msg.sender][h] = true;
253         emit CancelOrder(msg.sender, h);
254     }
255 
256     function callBtoWithSto(
257         uint    amount,
258         uint    expiration,
259         bytes32 nonce,
260         uint    price,
261         uint    size,
262         uint    strike,
263         uint    validUntil,
264         bytes32 r,
265         bytes32 s,
266         uint8   v
267     ) public hasFee(amount) {
268         bytes32 h = keccak256(Action.SellCallToOpen, expiration, nonce, price, size, strike, validUntil, this);
269         address maker = _getMaker(h, v, r, s);
270 
271         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
272         _buyCallToOpen(amount, expiration, price, strike, msg.sender);
273         _sellCallToOpen(amount, expiration, price, strike, maker);
274     }
275 
276     function callBtoWithStc(
277         uint    amount,
278         uint    expiration,
279         bytes32 nonce,
280         uint    price,
281         uint    size,
282         uint    strike,
283         uint    validUntil,
284         bytes32 r,
285         bytes32 s,
286         uint8   v
287     ) public hasFee(amount) {
288         bytes32 h = keccak256(Action.SellCallToClose, expiration, nonce, price, size, strike, validUntil, this);
289         address maker = _getMaker(h, v, r, s);
290 
291         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
292         _buyCallToOpen(amount, expiration, price, strike, msg.sender);
293         _sellCallToClose(amount, expiration, price, strike, maker);
294     }
295 
296     function callBtcWithSto(
297         uint    amount,
298         uint    expiration,
299         bytes32 nonce,
300         uint    price,
301         uint    size,
302         uint    strike,
303         uint    validUntil,
304         bytes32 r,
305         bytes32 s,
306         uint8   v
307     ) public hasFee(amount) {
308         bytes32 h = keccak256(Action.SellCallToOpen, expiration, nonce, price, size, strike, validUntil, this);
309         address maker = _getMaker(h, v, r, s);
310 
311         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
312         _buyCallToClose(amount, expiration, price, strike, msg.sender);
313         _sellCallToOpen(amount, expiration, price, strike, maker);
314     }
315 
316     function callBtcWithStc(
317         uint    amount,
318         uint    expiration,
319         bytes32 nonce,
320         uint    price,
321         uint    size,
322         uint    strike,
323         uint    validUntil,
324         bytes32 r,
325         bytes32 s,
326         uint8   v
327     ) public hasFee(amount) {
328         bytes32 h = keccak256(Action.SellCallToClose, expiration, nonce, price, size, strike, validUntil, this);
329         address maker = _getMaker(h, v, r, s);
330 
331         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
332         _buyCallToClose(amount, expiration, price, strike, msg.sender);
333         _sellCallToClose(amount, expiration, price, strike, maker);
334     }
335 
336     function callStoWithBto(
337         uint    amount,
338         uint    expiration,
339         bytes32 nonce,
340         uint    price,
341         uint    size,
342         uint    strike,
343         uint    validUntil,
344         bytes32 r,
345         bytes32 s,
346         uint8   v
347     ) public hasFee(amount) {
348         bytes32 h = keccak256(Action.BuyCallToOpen, expiration, nonce, price, size, strike, validUntil, this);
349         address maker = _getMaker(h, v, r, s);
350 
351         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
352         _sellCallToOpen(amount, expiration, price, strike, msg.sender);
353         _buyCallToOpen(amount, expiration, price, strike, maker);
354     }
355 
356     function callStoWithBtc(
357         uint    amount,
358         uint    expiration,
359         bytes32 nonce,
360         uint    price,
361         uint    size,
362         uint    strike,
363         uint    validUntil,
364         bytes32 r,
365         bytes32 s,
366         uint8   v
367     ) public hasFee(amount) {
368         bytes32 h = keccak256(Action.BuyCallToClose, expiration, nonce, price, size, strike, validUntil, this);
369         address maker = _getMaker(h, v, r, s);
370 
371         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
372         _sellCallToOpen(amount, expiration, price, strike, msg.sender);
373         _buyCallToClose(amount, expiration, price, strike, maker);
374     }
375 
376     function callStcWithBto(
377         uint    amount,
378         uint    expiration,
379         bytes32 nonce,
380         uint    price,
381         uint    size,
382         uint    strike,
383         uint    validUntil,
384         bytes32 r,
385         bytes32 s,
386         uint8   v
387     ) public hasFee(amount) {
388         bytes32 h = keccak256(Action.BuyCallToOpen, expiration, nonce, price, size, strike, validUntil, this);
389         address maker = _getMaker(h, v, r, s);
390 
391         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
392         _sellCallToClose(amount, expiration, price, strike, msg.sender);
393         _buyCallToOpen(amount, expiration, price, strike, maker);
394     }
395 
396     function callStcWithBtc(
397         uint    amount,
398         uint    expiration,
399         bytes32 nonce,
400         uint    price,
401         uint    size,
402         uint    strike,
403         uint    validUntil,
404         bytes32 r,
405         bytes32 s,
406         uint8   v
407     ) public hasFee(amount) {
408         bytes32 h = keccak256(Action.BuyCallToClose, expiration, nonce, price, size, strike, validUntil, this);
409         address maker = _getMaker(h, v, r, s);
410 
411         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
412         _sellCallToClose(amount, expiration, price, strike, msg.sender);
413         _buyCallToClose(amount, expiration, price, strike, maker);
414     }
415 
416     event BuyCallToOpen(address indexed account, uint amount, uint expiration, uint price, uint strike);
417     event SellCallToOpen(address indexed account, uint amount, uint expiration, uint price, uint strike);
418     event BuyCallToClose(address indexed account, uint amount, uint expiration, uint price, uint strike);
419     event SellCallToClose(address indexed account, uint amount, uint expiration, uint price, uint strike);
420 
421     function _buyCallToOpen(uint amount, uint expiration, uint price, uint strike, address buyer) private {
422         bytes32 series = keccak256(expiration, strike);
423         uint premium = amount.mul(price).div(1 ether);
424 
425         _subDai(premium, buyer);
426         callsOwned[series][buyer] = callsOwned[series][buyer].add(amount);
427         emit BuyCallToOpen(buyer, amount, expiration, price, strike);
428     }
429 
430     function _buyCallToClose(uint amount, uint expiration, uint price, uint strike, address buyer) private {
431         bytes32 series = keccak256(expiration, strike);
432         uint premium = amount.mul(price).div(1 ether);
433 
434         _subDai(premium, buyer);
435         eth[buyer] = eth[buyer].add(amount);
436         callsSold[series][buyer] = callsSold[series][buyer].sub(amount);
437         emit BuyCallToClose(buyer, amount, expiration, price, strike);
438     }
439 
440     function _sellCallToOpen(uint amount, uint expiration, uint price, uint strike, address seller) private {
441         bytes32 series = keccak256(expiration, strike);
442         uint premium = amount.mul(price).div(1 ether);
443 
444         _addDai(premium, seller);
445         eth[seller] = eth[seller].sub(amount);
446         callsSold[series][seller] = callsSold[series][seller].add(amount);
447         emit SellCallToOpen(seller, amount, expiration, price, strike);
448     }
449 
450     function _sellCallToClose(uint amount, uint expiration, uint price, uint strike, address seller) private {
451         bytes32 series = keccak256(expiration, strike);
452         uint premium = amount.mul(price).div(1 ether);
453 
454         _addDai(premium, seller);
455         callsOwned[series][seller] = callsOwned[series][seller].sub(amount);
456         emit SellCallToClose(seller, amount, expiration, price, strike);
457     }
458 
459     event ExerciseCall(address indexed account, uint amount, uint expiration, uint strike);
460     function exerciseCall(
461         uint amount,
462         uint expiration,
463         uint strike
464     ) public {
465         require(now < expiration, "Expired");
466         require(amount % 1 finney == 0, precisionError);
467         uint cost = amount.mul(strike).div(1 ether);
468         bytes32 series = keccak256(expiration, strike);
469 
470         require(callsOwned[series][msg.sender] > 0);
471         callsOwned[series][msg.sender] = callsOwned[series][msg.sender].sub(amount);
472         callsExercised[series] = callsExercised[series].add(amount);
473 
474         _collectFee(msg.sender, exerciseFee);
475         _subDai(cost, msg.sender);
476         _addEth(amount, msg.sender);
477         emit ExerciseCall(msg.sender, amount, expiration, strike);
478     }
479 
480     event AssignCall(address indexed account, uint amount, uint expiration, uint strike);
481     event SettleCall(address indexed account, uint expiration, uint strike);
482     function settleCall(uint expiration, uint strike, address writer) public {
483         require(msg.sender == writer || isAuthorized(msg.sender, msg.sig), "Unauthorized");
484         require(now > expiration, "Expired");
485 
486         bytes32 series = keccak256(expiration, strike);
487         require(callsSold[series][writer] > 0);
488 
489         if (callsAssigned[series] < callsExercised[series]) {
490             uint maximum = callsSold[series][writer];
491             uint needed = callsExercised[series].sub(callsAssigned[series]);
492             uint assignment = needed.min(maximum);
493 
494             totalEth[writer] = totalEth[writer].sub(assignment);
495             callsAssigned[series] = callsAssigned[series].add(assignment);
496             callsSold[series][writer] = callsSold[series][writer].sub(assignment);
497 
498             uint value = strike.mul(assignment).div(1 ether);
499             _addDai(value, writer);
500             emit AssignCall(msg.sender, assignment, expiration, strike);
501         }
502 
503         _collectFee(writer, settlementFee);
504         eth[writer] = eth[writer].add(callsSold[series][writer]);
505         callsSold[series][writer] = 0;
506         emit SettleCall(writer, expiration, strike);
507     }
508 
509 
510     // ========== PUT OPTIONS EXCHANGE ========== //
511 
512     function putBtoWithSto(
513         uint    amount,
514         uint    expiration,
515         bytes32 nonce,
516         uint    price,
517         uint    size,
518         uint    strike,
519         uint    validUntil,
520         bytes32 r,
521         bytes32 s,
522         uint8   v
523     ) public hasFee(amount) {
524         bytes32 h = keccak256(Action.SellPutToOpen, expiration, nonce, price, size, strike, validUntil, this);
525         address maker = _getMaker(h, v, r, s);
526 
527         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
528         _buyPutToOpen(amount, expiration, price, strike, msg.sender);
529         _sellPutToOpen(amount, expiration, price, strike, maker);
530     }
531 
532     function putBtoWithStc(
533         uint    amount,
534         uint    expiration,
535         bytes32 nonce,
536         uint    price,
537         uint    size,
538         uint    strike,
539         uint    validUntil,
540         bytes32 r,
541         bytes32 s,
542         uint8   v
543     ) public hasFee(amount) {
544         bytes32 h = keccak256(Action.SellPutToClose, expiration, nonce, price, size, strike, validUntil, this);
545         address maker = _getMaker(h, v, r, s);
546 
547         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
548         _buyPutToOpen(amount, expiration, price, strike, msg.sender);
549         _sellPutToClose(amount, expiration, price, strike, maker);
550     }
551 
552     function putBtcWithSto(
553         uint    amount,
554         uint    expiration,
555         bytes32 nonce,
556         uint    price,
557         uint    size,
558         uint    strike,
559         uint    validUntil,
560         bytes32 r,
561         bytes32 s,
562         uint8   v
563     ) public hasFee(amount) {
564         bytes32 h = keccak256(Action.SellPutToOpen, expiration, nonce, price, size, strike, validUntil, this);
565         address maker = _getMaker(h, v, r, s);
566 
567         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
568         _buyPutToClose(amount, expiration, price, strike, msg.sender);
569         _sellPutToOpen(amount, expiration, price, strike, maker);
570     }
571 
572     function putBtcWithStc(
573         uint    amount,
574         uint    expiration,
575         bytes32 nonce,
576         uint    price,
577         uint    size,
578         uint    strike,
579         uint    validUntil,
580         bytes32 r,
581         bytes32 s,
582         uint8   v
583     ) public hasFee(amount) {
584         bytes32 h = keccak256(Action.SellPutToClose, expiration, nonce, price, size, strike, validUntil, this);
585         address maker = _getMaker(h, v, r, s);
586 
587         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
588         _buyPutToClose(amount, expiration, price, strike, msg.sender);
589         _sellPutToClose(amount, expiration, price, strike, maker);
590     }
591 
592     function putStoWithBto(
593         uint    amount,
594         uint    expiration,
595         bytes32 nonce,
596         uint    price,
597         uint    size,
598         uint    strike,
599         uint    validUntil,
600         bytes32 r,
601         bytes32 s,
602         uint8   v
603     ) public hasFee(amount) {
604         bytes32 h = keccak256(Action.BuyPutToOpen, expiration, nonce, price, size, strike, validUntil, this);
605         address maker = _getMaker(h, v, r, s);
606 
607         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
608         _sellPutToOpen(amount, expiration, price, strike, msg.sender);
609         _buyPutToOpen(amount, expiration, price, strike, maker);
610     }
611 
612     function putStoWithBtc(
613         uint    amount,
614         uint    expiration,
615         bytes32 nonce,
616         uint    price,
617         uint    size,
618         uint    strike,
619         uint    validUntil,
620         bytes32 r,
621         bytes32 s,
622         uint8   v
623     ) public hasFee(amount) {
624         bytes32 h = keccak256(Action.BuyPutToClose, expiration, nonce, price, size, strike, validUntil, this);
625         address maker = _getMaker(h, v, r, s);
626 
627         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
628         _sellPutToOpen(amount, expiration, price, strike, msg.sender);
629         _buyPutToClose(amount, expiration, price, strike, maker);
630     }
631 
632     function putStcWithBto(
633         uint    amount,
634         uint    expiration,
635         bytes32 nonce,
636         uint    price,
637         uint    size,
638         uint    strike,
639         uint    validUntil,
640         bytes32 r,
641         bytes32 s,
642         uint8   v
643     ) public hasFee(amount) {
644         bytes32 h = keccak256(Action.BuyPutToOpen, expiration, nonce, price, size, strike, validUntil, this);
645         address maker = _getMaker(h, v, r, s);
646 
647         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
648         _sellPutToClose(amount, expiration, price, strike, msg.sender);
649         _buyPutToOpen(amount, expiration, price, strike, maker);
650     }
651 
652     function putStcWithBtc(
653         uint    amount,
654         uint    expiration,
655         bytes32 nonce,
656         uint    price,
657         uint    size,
658         uint    strike,
659         uint    validUntil,
660         bytes32 r,
661         bytes32 s,
662         uint8   v
663     ) public hasFee(amount) {
664         bytes32 h = keccak256(Action.BuyPutToClose, expiration, nonce, price, size, strike, validUntil, this);
665         address maker = _getMaker(h, v, r, s);
666 
667         _validateOrder(amount, expiration, h, maker, price, validUntil, size, strike);
668         _sellPutToClose(amount, expiration, price, strike, msg.sender);
669         _buyPutToClose(amount, expiration, price, strike, maker);
670     }
671 
672     event BuyPutToOpen(address indexed account, uint amount, uint expiration, uint price, uint strike);
673     event SellPutToOpen(address indexed account, uint amount, uint expiration, uint price, uint strike);
674     event BuyPutToClose(address indexed account, uint amount, uint expiration, uint price, uint strike);
675     event SellPutToClose(address indexed account, uint amount, uint expiration, uint price, uint strike);
676 
677     function _buyPutToOpen(uint amount, uint expiration, uint price, uint strike, address buyer) private {
678         bytes32 series = keccak256(expiration, strike);
679         uint premium = amount.mul(price).div(1 ether);
680 
681         _subDai(premium, buyer);
682         putsOwned[series][buyer] = putsOwned[series][buyer].add(amount);
683         emit BuyPutToOpen(buyer, amount, expiration, price, strike);
684     }
685 
686     function _buyPutToClose(uint amount, uint expiration, uint price, uint strike, address buyer) private {
687         bytes32 series = keccak256(expiration, strike);
688         uint premium = amount.mul(price).div(1 ether);
689 
690         dai[buyer] = dai[buyer].add(strike.mul(amount).div(1 ether));
691         _subDai(premium, buyer);
692         putsSold[series][buyer] = putsSold[series][buyer].sub(amount);
693         emit BuyPutToClose(buyer, amount, expiration, price, strike);
694     }
695 
696     function _sellPutToOpen(uint amount, uint expiration, uint price, uint strike, address seller) private {
697         bytes32 series = keccak256(expiration, strike);
698         uint premium = amount.mul(price).div(1 ether);
699         uint cost = strike.mul(amount).div(1 ether);
700 
701         _addDai(premium, seller);
702         dai[seller] = dai[seller].sub(cost);
703         putsSold[series][seller] = putsSold[series][seller].add(amount);
704         emit SellPutToOpen(seller, amount, expiration, price, strike);
705     }
706 
707     function _sellPutToClose(uint amount, uint expiration, uint price, uint strike, address seller) private {
708         bytes32 series = keccak256(expiration, strike);
709         uint premium = amount.mul(price).div(1 ether);
710 
711         _addDai(premium, seller);
712         putsOwned[series][seller] = putsOwned[series][seller].sub(amount);
713         emit SellPutToClose(seller, amount, expiration, price, strike);
714     }
715 
716     event ExercisePut(address indexed account, uint amount, uint expiration, uint strike);
717     function exercisePut(
718         uint amount,
719         uint expiration,
720         uint strike
721     ) public {
722         require(now < expiration, "Expired");
723         require(amount % 1 finney == 0, precisionError);
724         uint yield = amount.mul(strike).div(1 ether);
725         bytes32 series = keccak256(expiration, strike);
726 
727         require(putsOwned[series][msg.sender] > 0);
728         
729         putsOwned[series][msg.sender] = putsOwned[series][msg.sender].sub(amount);
730         putsExercised[series] = putsExercised[series].add(amount);
731 
732         _subEth(amount, msg.sender);
733         _addDai(yield, msg.sender);
734         _collectFee(msg.sender, exerciseFee);
735         emit ExercisePut(msg.sender, amount, expiration, strike);
736     }
737 
738     event AssignPut(address indexed account, uint amount, uint expiration, uint strike);
739     event SettlePut(address indexed account, uint expiration, uint strike);
740     function settlePut(uint expiration, uint strike, address writer) public {
741         require(msg.sender == writer || isAuthorized(msg.sender, msg.sig), "Unauthorized");
742         require(now > expiration, "Expired");
743 
744         bytes32 series = keccak256(expiration, strike);
745         require(putsSold[series][writer] > 0);
746 
747         if (putsAssigned[series] < putsExercised[series]) {
748             uint maximum = putsSold[series][writer];
749             uint needed = putsExercised[series].sub(putsAssigned[series]);
750             uint assignment = maximum.min(needed);
751 
752             totalDai[writer] = totalDai[writer].sub(assignment.mul(strike).div(1 ether));
753             putsSold[series][writer] = putsSold[series][writer].sub(assignment);
754             putsAssigned[series] = putsAssigned[series].add(assignment);
755 
756             _addEth(assignment, writer);
757             emit AssignPut(writer, assignment, expiration, strike);
758         }
759 
760         uint yield = putsSold[series][writer].mul(strike).div(1 ether);
761         _collectFee(writer, settlementFee);
762         dai[writer] = dai[writer].add(yield);
763         putsSold[series][writer] = 0;
764         emit SettlePut(writer, expiration, strike);
765     }
766 
767     function calculateFee(uint amount) public view returns (uint) {
768         return amount.mul(contractFee).div(1 ether).add(flatFee);
769     }
770 
771     function claimFeeRebate(uint amount, bytes32 nonce, bytes32 r, bytes32 s, uint8 v) public {
772         bytes32 h = keccak256(amount, nonce, msg.sender);
773         h = keccak256("\x19Ethereum Signed Message:\n32", h);
774         address signer = ecrecover(h, v, r, s);
775         require(amount <= 1000);
776         require(isAuthorized(signer, msg.sig));
777         require(claimedFeeRebate[nonce] == false);
778         feeRebates[msg.sender] = feeRebates[msg.sender].add(amount);
779         claimedFeeRebate[nonce] = true;
780     }
781 
782     event TakeOrder(address indexed account, address maker, uint amount, bytes32 h);
783     function _validateOrder(uint amount, uint expiration, bytes32 h, address maker, uint price, uint validUntil, uint size, uint strike) private {
784         require(strike % 1 ether == 0, precisionError);
785         require(amount % 1 finney == 0, precisionError);
786         require(price % 1 finney == 0, precisionError);
787         require(expiration % 86400 == 0, "Expiration");
788 
789         require(cancelled[maker][h] == false, "Cancelled");
790         require(amount <= size.sub(filled[maker][h]), "Filled");
791         require(now < validUntil, "OrderExpired");
792         require(now < expiration, "Expired");
793 
794         filled[maker][h] = filled[maker][h].add(amount);
795         emit TakeOrder(msg.sender, maker, amount, h);
796     }
797 
798     function _collectFee(address account, uint amount) private {
799         if (feeRebates[msg.sender] > 0) {
800             feeRebates[msg.sender] = feeRebates[msg.sender].sub(1);
801         } else {
802             _subDai(amount, account);
803             feesCollected = feesCollected.add(amount);
804         }
805     }
806 
807     function _getMaker(bytes32 h, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
808         return ecrecover(keccak256("\x19Ethereum Signed Message:\n32", h), v, r, s);
809     }
810 }