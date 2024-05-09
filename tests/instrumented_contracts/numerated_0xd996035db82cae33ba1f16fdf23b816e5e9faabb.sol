1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7         return c;
8     }
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");
12     }
13 
14     function sub(
15         uint256 a,
16         uint256 b,
17         string memory errorMessage
18     ) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21         return c;
22     }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(
38         uint256 a,
39         uint256 b,
40         string memory errorMessage
41     ) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return c;
47     }
48 
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         return mod(a, b, "SafeMath: modulo by zero");
51     }
52 
53     function mod(
54         uint256 a,
55         uint256 b,
56         string memory errorMessage
57     ) internal pure returns (uint256) {
58         require(b != 0, errorMessage);
59         return a % b;
60     }
61 }
62 
63 contract TradeEngine {
64     function balanceOf(address, address) public view returns (uint256) {}
65 
66     function orderBNS(
67         address,
68         uint256,
69         address,
70         uint256,
71         uint256,
72         uint256,
73         address
74     ) public returns (bool) {}
75 
76     function deductFee(
77         address,
78         address,
79         uint256
80     ) public returns (bool) {}
81 }
82 
83 contract Token {
84     function tokenBalanceOf(address, address) public view returns (uint256) {}
85 
86     function balanceOf(address) public view returns (uint256) {}
87 
88     function transfer(address, uint256) public returns (bool) {}
89 
90     function transferFrom(
91         address,
92         address,
93         uint256
94     ) public returns (bool) {}
95 
96     function frozenBalanceOf(address) public returns (uint256) {}
97 
98     function issueMulti(
99         address[],
100         uint256[],
101         uint256,
102         uint256
103     ) public returns (bool) {}
104 
105     function lockTime(address) public view returns (uint256) {}
106 
107     function subscribe(
108         address,
109         address,
110         address,
111         uint256,
112         uint256
113     ) public returns (uint256) {}
114 
115     function charge(uint256) public returns (bool) {}
116 
117     function subscribeToSpp(
118         address,
119         uint256,
120         uint256,
121         address,
122         address
123     ) public returns (uint256) {}
124 
125     function closeSpp(uint256) public returns (bool) {}
126 
127     function getSppIdFromHash(bytes32) public returns (uint256) {}
128 
129     function setLastPaidAt(bytes32) public returns (bool) {}
130 
131     function setRemainingToBeFulfilled(bytes32, uint256)
132         public
133         returns (bool)
134     {}
135 
136     function getRemainingToBeFulfilledByHash(bytes32)
137         public
138         returns (uint256)
139     {}
140 
141     function getlistOfSubscriptions(address) public view returns (uint256[]) {}
142 
143     function getlistOfSppSubscriptions(address)
144         public
145         view
146         returns (uint256[])
147     {}
148 
149     function getcurrentTokenAmounts(uint256)
150         public
151         view
152         returns (uint256[2] memory)
153     {}
154 
155     function getTokenStats(uint256) public view returns (address[2] memory) {}
156 
157     function setcurrentTokenStats(
158         bytes32,
159         uint256,
160         uint256
161     ) public returns (bool) {}
162 
163     function getRemainingToBeFulfilledBySppID(uint256)
164         public
165         view
166         returns (uint256)
167     {}
168 }
169 
170 contract BNSToken is Token {
171     using SafeMath for uint256;
172 
173     event Subscribe(
174         uint256 indexed orderId,
175         address indexed merchantAddress,
176         address indexed customerAddress,
177         address token,
178         uint256 value,
179         uint256 period
180     );
181     event Charge(uint256 orderId);
182     event SubscribeToSpp(
183         uint256 indexed sppID,
184         address indexed customerAddress,
185         uint256 value,
186         uint256 period,
187         address indexed tokenGet,
188         address tokenGive
189     );
190     event ChargeSpp(uint256 sppID, uint256 expires, uint256 nonce);
191     event Deposit(
192         address indexed token,
193         address indexed user,
194         uint256 amount,
195         uint256 balance
196     );
197     event Withdraw(
198         address indexed token,
199         address indexed user,
200         uint256 amount,
201         uint256 balance
202     );
203     event CloseSpp(uint256 sppID);
204     event Transfer(address indexed from, address indexed to, uint256 value);
205     event Approval(
206         address indexed owner,
207         address indexed spender,
208         uint256 value
209     );
210     event Mint(string hash, address indexed account, uint256 value);
211     event SetCurrentTokenStats(
212         uint256 indexed sppID,
213         uint256 amountGotten,
214         uint256 amountGiven
215     );
216 
217     modifier _ownerOnly() {
218         require(msg.sender == owner);
219         _;
220     }
221 
222     modifier _tradeEngineOnly() {
223         require(msg.sender == TradeEngineAddress);
224         _;
225     }
226 
227     bool public scLock = false;
228 
229     modifier _ifNotLocked() {
230         require(scLock == false);
231         _;
232     }
233 
234     function setLock() public _ownerOnly {
235         scLock = !scLock;
236     }
237 
238     function changeOwner(address owner_) public _ownerOnly {
239         potentialAdmin = owner_;
240     }
241 
242     function becomeOwner() public {
243         if (potentialAdmin == msg.sender) owner = msg.sender;
244     }
245 
246     function mint(
247         string hash,
248         address account,
249         uint256 value
250     ) public _ownerOnly {
251         require(account != address(0));
252         require(
253             SafeMath.add(totalSupply, value) <= totalPossibleSupply,
254             "totalSupply can't be more than the totalPossibleSupply"
255         );
256         totalSupply = SafeMath.add(totalSupply, value);
257         balances[account] = SafeMath.add(balances[account], value);
258         emit Mint(hash, account, value);
259     }
260 
261     function burn(uint256 value) public _ownerOnly {
262         totalSupply = totalSupply.sub(value);
263         balances[msg.sender] = balances[msg.sender].sub(value);
264         emit Transfer(msg.sender, address(0), value);
265     }
266 
267     function transfer(address _to, uint256 _value)
268         public
269         returns (bool success)
270     {
271         if (
272             balances[msg.sender] >= _value &&
273             _value >= 0 &&
274             userdata[msg.sender].exists == false
275         ) {
276             balances[msg.sender] = balances[msg.sender].sub(_value);
277             balances[_to] = balances[_to].add(_value);
278             emit Transfer(msg.sender, _to, _value);
279             return true;
280         } else {
281             return false;
282         }
283     }
284 
285     function issueMulti(
286         address[] _to,
287         uint256[] _value,
288         uint256 ldays,
289         uint256 period
290     ) public _ownerOnly returns (bool success) {
291         require(_value.length <= 20, "too long array");
292         require(_value.length == _to.length, "array size misatch");
293         uint256 sum = 0;
294         userstats memory _oldData;
295         uint256 _oldFrozen = 0;
296         for (uint256 i = 0; i < _value.length; i++) {
297             sum = sum.add(_value[i]);
298         }
299         if (balances[msg.sender] >= sum && sum > 0) {
300             balances[msg.sender] = balances[msg.sender].sub(sum);
301             for (uint256 j = 0; j < _to.length; j++) {
302                 balances[_to[j]] = balances[_to[j]].add(_value[j]);
303                 _oldData = userdata[_to[j]];
304                 _oldFrozen = _oldData.frozen_balance;
305 
306                 userdata[_to[j]] = userstats({
307                     exists: true,
308                     frozen_balance: _oldFrozen.add(_value[j]),
309                     lock_till: now.add((ldays.mul(86400))),
310                     time_period: (period.mul(86400)),
311                     per_tp_release_amt: SafeMath.div(
312                         SafeMath.add(_value[j], _oldFrozen),
313                         (ldays.div(period))
314                     )
315                 });
316                 emit Transfer(msg.sender, _to[j], _value[j]);
317             }
318             return true;
319         } else {
320             return false;
321         }
322     }
323 
324     function approve(address _spender, uint256 _value) public returns (bool) {
325         allowed[msg.sender][_spender] = _value;
326         emit Approval(msg.sender, _spender, _value);
327         return true;
328     }
329 
330     function transferFrom(
331         address _from,
332         address _to,
333         uint256 _value
334     ) public returns (bool success) {
335         if (
336             balances[_from] >= _value &&
337             _value >= 0 &&
338             (allowed[_from][msg.sender] >= _value || _from == msg.sender)
339         ) {
340             userstats memory _userData = userdata[_from];
341 
342             if (_userData.exists == false) {
343                 _transfer(_from, _to, _value);
344                 return true;
345             }
346 
347             uint256 lock = _userData.lock_till;
348 
349             if (now >= lock) {
350                 _userData.frozen_balance = 0;
351                 _userData.exists = false;
352                 userdata[_from] = _userData;
353                 _transfer(_from, _to, _value);
354                 return true;
355             }
356 
357             uint256 a = (lock - now);
358             uint256 b = _userData.time_period;
359             uint256 should_be_frozen = SafeMath.mul(
360                 (SafeMath.div(a, b) + 1),
361                 _userData.per_tp_release_amt
362             );
363 
364             if (_userData.frozen_balance > should_be_frozen) {
365                 _userData.frozen_balance = should_be_frozen;
366                 userdata[_from] = _userData;
367             }
368 
369             if (balances[_from].sub(_value) >= _userData.frozen_balance) {
370                 _transfer(_from, _to, _value);
371                 return true;
372             }
373 
374             return false;
375         } else {
376             return false;
377         }
378     }
379 
380     function _transfer(
381         address _from,
382         address _to,
383         uint256 _value
384     ) internal {
385         balances[_to] = balances[_to].add(_value);
386         if (_from != msg.sender)
387             allowed[_from][msg.sender] = SafeMath.sub(
388                 allowed[_from][msg.sender],
389                 _value
390             );
391         balances[_from] = balances[_from].sub(_value);
392         emit Transfer(_from, _to, _value);
393     }
394 
395     function balanceOf(address _from) public view returns (uint256 balance) {
396         return balances[_from];
397     }
398 
399     function frozenBalanceOf(address _from) public returns (uint256 balance) {
400         userstats memory _userData = userdata[_from];
401         if (_userData.exists == false) return;
402 
403         uint256 lock = _userData.lock_till;
404 
405         if (now >= lock) {
406             _userData.frozen_balance = 0;
407             _userData.exists = false;
408             userdata[_from] = _userData;
409             return 0;
410         }
411 
412         uint256 a = (lock - now);
413         uint256 b = _userData.time_period;
414         uint256 should_be_frozen = SafeMath.mul(
415             (SafeMath.div(a, b) + 1),
416             _userData.per_tp_release_amt
417         );
418 
419         if (_userData.frozen_balance > should_be_frozen) {
420             _userData.frozen_balance = should_be_frozen;
421             userdata[_from] = _userData;
422         }
423 
424         return _userData.frozen_balance;
425     }
426 
427     function lockTime(address _from) public view returns (uint256 time) {
428         if (userdata[_from].exists == false) revert();
429         return userdata[_from].lock_till;
430     }
431 
432     function deposit() public payable {
433         tokens[0][msg.sender] = SafeMath.add(tokens[0][msg.sender], msg.value);
434         emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
435     }
436 
437     function withdraw(uint256 amount) public {
438         if (tokens[0][msg.sender] < amount) revert();
439         tokens[0][msg.sender] = SafeMath.sub(tokens[0][msg.sender], amount);
440         if (!msg.sender.call.value(amount)()) revert();
441         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
442     }
443 
444     function depositToken(address token, uint256 amount) public {
445         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
446         if (token == 0) revert();
447         if (!Token(token).transferFrom(msg.sender, this, amount)) revert();
448         tokens[token][msg.sender] = SafeMath.add(
449             tokens[token][msg.sender],
450             amount
451         );
452         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
453     }
454 
455     function withdrawToken(address token, uint256 amount) public {
456         if (token == 0) revert();
457         if (tokens[token][msg.sender] < amount) revert();
458         tokens[token][msg.sender] = SafeMath.sub(
459             tokens[token][msg.sender],
460             amount
461         );
462         if (!Token(token).transfer(msg.sender, amount)) revert();
463         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
464     }
465 
466     function tokenBalanceOf(address token, address user)
467         public
468         view
469         returns (uint256 balance)
470     {
471         return tokens[token][user];
472     }
473 
474     function subscribe(
475         address merchantAddress,
476         address customerAddress,
477         address token,
478         uint256 value,
479         uint256 period
480     ) public _ifNotLocked returns (uint256 oID) {
481         if (customerAddress != msg.sender || period < minPeriod) {
482             return 0;
483         }
484         if (tokens[token][msg.sender] >= value && value > 0) {
485             orderId += 1;
486             subscriptiondata[orderId] = subscriptionstats({
487                 exists: true,
488                 value: value,
489                 period: period,
490                 lastPaidAt: now.sub(period),
491                 merchantAddress: merchantAddress,
492                 customerAddress: customerAddress,
493                 tokenType: token
494             });
495             subList[customerAddress].arr.push(orderId);
496             emit Subscribe(
497                 orderId,
498                 merchantAddress,
499                 customerAddress,
500                 token,
501                 value,
502                 period
503             );
504             return orderId;
505         }
506     }
507 
508     function charge(uint256 orderId)
509         public
510         _ifNotLocked
511         returns (bool success)
512     {
513         subscriptionstats memory _orderData = subscriptiondata[orderId];
514         require(
515             _orderData.exists == true,
516             "This subscription does not exist, wrong orderId"
517         );
518         require(
519             _orderData.merchantAddress == msg.sender,
520             "You are not the real merchant"
521         );
522         require(
523             (_orderData.lastPaidAt).add(_orderData.period) <= now,
524             "charged too early"
525         );
526         address token = _orderData.tokenType;
527         tokens[token][_orderData.customerAddress] = tokens[token][_orderData
528             .customerAddress]
529             .sub(_orderData.value);
530         uint256 fee = ((_orderData.value).mul(25)).div(10000);
531         tokens[token][feeAccount] = SafeMath.add(
532             tokens[token][feeAccount],
533             fee
534         );
535         tokens[token][_orderData.merchantAddress] = tokens[token][_orderData
536             .merchantAddress]
537             .add((_orderData.value.sub(fee)));
538         _orderData.lastPaidAt = SafeMath.add(
539             _orderData.lastPaidAt,
540             _orderData.period
541         );
542         subscriptiondata[orderId] = _orderData;
543         emit Charge(orderId);
544         return true;
545     }
546 
547     function closeSubscription(uint256 orderId) public returns (bool success) {
548         subscriptionstats memory _orderData = subscriptiondata[orderId];
549         require(
550             _orderData.exists == true,
551             "This subscription does not exist, wrong orderId OR already closed"
552         );
553         require(
554             _orderData.customerAddress == msg.sender,
555             "You are not the customer of this orderId"
556         );
557         subscriptiondata[orderId].exists = false;
558         return true;
559     }
560 
561     function subscribeToSpp(
562         address customerAddress,
563         uint256 value,
564         uint256 period,
565         address tokenGet,
566         address tokenGive
567     ) public _ifNotLocked returns (uint256 sID) {
568         if (customerAddress != msg.sender || period < 86400) {
569             return 0;
570         }
571         if (
572             TradeEngine(TradeEngineAddress).balanceOf(
573                 tokenGive,
574                 customerAddress
575             ) >= value
576         ) {
577             require(
578                 TradeEngine(TradeEngineAddress).deductFee(
579                     customerAddress,
580                     usdt,
581                     uint256(2 * (10**usdtDecimal))
582                 ),
583                 "fee not able to charge"
584             );
585             sppID += 1;
586             sppSubscriptionStats[sppID] = sppSubscribers({
587                 exists: true,
588                 customerAddress: customerAddress,
589                 tokenGet: tokenGet,
590                 tokenGive: tokenGive,
591                 value: value,
592                 remainingToBeFulfilled: value,
593                 period: period,
594                 lastPaidAt: now - period
595             });
596             tokenStats[sppID] = currentTokenStats({
597                 TokenToGet: tokenGet,
598                 TokenToGive: tokenGive,
599                 amountGotten: 0,
600                 amountGiven: 0
601             });
602             sppSubList[customerAddress].arr.push(sppID);
603             emit SubscribeToSpp(
604                 sppID,
605                 customerAddress,
606                 value,
607                 period,
608                 tokenGet,
609                 tokenGive
610             );
611             return sppID;
612         }
613     }
614 
615     function chargeSpp(
616         uint256 sppID,
617         uint256 amountGet,
618         uint256 amountGive,
619         uint256 expires
620     ) public _ownerOnly _ifNotLocked {
621         sppSubscribers memory _subscriptionData = sppSubscriptionStats[sppID];
622         require(
623             amountGive == _subscriptionData.remainingToBeFulfilled,
624             "check"
625         );
626         require(
627             onGoing[sppID] < block.number,
628             "chargeSpp is already onGoing for this sppId"
629         );
630         require(
631             _subscriptionData.exists == true,
632             "This SPP does not exist, wrong SPP ID"
633         );
634         require(
635             (_subscriptionData.lastPaidAt).add(_subscriptionData.period) <= now,
636             "Charged too early"
637         );
638         require(
639             TradeEngine(TradeEngineAddress).deductFee(
640                 _subscriptionData.customerAddress,
641                 usdt,
642                 uint256(15 * rateEthUsdt/1000)
643             ),
644             "fee unable to charge"
645         ); // need to multiply with 10^8??
646         nonce += 1;
647         bytes32 hash = sha256(
648             abi.encodePacked(
649                 TradeEngineAddress,
650                 _subscriptionData.tokenGet,
651                 amountGet,
652                 _subscriptionData.tokenGive,
653                 amountGive,
654                 block.number + expires,
655                 nonce
656             )
657         );
658         hash2sppId[hash] = sppID;
659         onGoing[sppID] = block.number + expires;
660         TradeEngine(TradeEngineAddress).orderBNS(
661             _subscriptionData.tokenGet,
662             amountGet,
663             _subscriptionData.tokenGive,
664             amountGive,
665             block.number + expires,
666             nonce,
667             _subscriptionData.customerAddress
668         );
669         emit ChargeSpp(sppID, (block.number + expires), nonce);
670     }
671 
672     function closeSpp(uint256 sppID) public returns (bool success) {
673         if (msg.sender != sppSubscriptionStats[sppID].customerAddress)
674             return false;
675         sppSubscriptionStats[sppID].exists = false;
676         emit CloseSpp(sppID);
677         return true;
678     }
679 
680     function setrateEthUsdt(uint256 _value) public _ownerOnly {
681         rateEthUsdt = _value;
682     }
683 
684     function setAddresses(address usdt1, address feeAccount1)
685         public
686         _ownerOnly
687     {
688         usdt = usdt1;
689         feeAccount = feeAccount1;
690     }
691 
692     function setUsdtDecimal(uint256 decimal) public _ownerOnly {
693         usdtDecimal = decimal;
694     }
695 
696     function setMinPeriod(uint256 p) public _ownerOnly {
697         minPeriod = p;
698     }
699 
700     function setTradeEngineAddress(address _add) public _ownerOnly {
701         TradeEngineAddress = _add;
702     }
703 
704     function setLastPaidAt(bytes32 hash) public returns (bool success) {
705         if (msg.sender != TradeEngineAddress) return false;
706         uint256 sppID = hash2sppId[hash];
707         sppSubscribers memory _subscriptionData = sppSubscriptionStats[sppID];
708         if (
709             (now - (_subscriptionData.lastPaidAt + _subscriptionData.period)) <
710             14400
711         ) {
712             sppSubscriptionStats[hash2sppId[hash]]
713                 .lastPaidAt = _subscriptionData.lastPaidAt.add(
714                 _subscriptionData.period
715             );
716         } else {
717             sppSubscriptionStats[hash2sppId[hash]].lastPaidAt = now;
718         }
719         return true;
720     }
721 
722     function setRemainingToBeFulfilled(bytes32 hash, uint256 amt)
723         public
724         returns (bool success)
725     {
726         if (msg.sender != TradeEngineAddress) return false;
727         uint256 sppID = hash2sppId[hash];
728         sppSubscribers memory _subscriptionData = sppSubscriptionStats[sppID];
729         if ((_subscriptionData.remainingToBeFulfilled == amt))
730             sppSubscriptionStats[hash2sppId[hash]]
731                 .remainingToBeFulfilled = _subscriptionData.value;
732         else {
733             sppSubscriptionStats[hash2sppId[hash]]
734                 .remainingToBeFulfilled = _subscriptionData
735                 .remainingToBeFulfilled
736                 .sub(amt);
737         }
738         return true;
739     }
740 
741     function setcurrentTokenStats(
742         bytes32 hash,
743         uint256 amountGotten,
744         uint256 amountGiven
745     ) public returns (bool success) {
746         if (msg.sender != TradeEngineAddress) return false;
747         uint256 sppID = hash2sppId[hash];
748         currentTokenStats memory _tokenStats = tokenStats[sppID];
749         tokenStats[sppID].amountGotten = _tokenStats.amountGotten.add(
750             amountGotten
751         );
752         tokenStats[sppID].amountGiven = _tokenStats.amountGiven.add(
753             amountGiven
754         );
755         emit SetCurrentTokenStats(sppID, amountGotten, amountGiven);
756         return true;
757     }
758 
759     function isActiveSpp(uint256 sppID) public view returns (bool res) {
760         return sppSubscriptionStats[sppID].exists;
761     }
762 
763     function getSppIdFromHash(bytes32 hash) public returns (uint256 sppID) {
764         return hash2sppId[hash];
765     }
766 
767     function getLatestOrderId() public view returns (uint256 oId) {
768         return orderId;
769     }
770 
771     function getRemainingToBeFulfilledByHash(bytes32 hash)
772         public
773         _tradeEngineOnly
774         returns (uint256 res)
775     {
776         return sppSubscriptionStats[hash2sppId[hash]].remainingToBeFulfilled;
777     }
778 
779     function getRemainingToBeFulfilledBySppID(uint256 sppID)
780         public
781         view
782         returns (uint256 res)
783     {
784         return sppSubscriptionStats[sppID].remainingToBeFulfilled;
785     }
786 
787     function getlistOfSubscriptions(address _from)
788         public
789         view
790         returns (uint256[] arr)
791     {
792         return subList[_from].arr;
793     }
794 
795     function getlistOfSppSubscriptions(address _from)
796         public
797         view
798         returns (uint256[] arr)
799     {
800         return sppSubList[_from].arr;
801     }
802 
803     function getcurrentTokenAmounts(uint256 sppID)
804         public
805         view
806         returns (uint256[2] memory arr)
807     {
808         arr[0] = tokenStats[sppID].amountGotten;
809         arr[1] = tokenStats[sppID].amountGiven;
810         return arr;
811     }
812 
813     function getTokenStats(uint256 sppID)
814         public
815         view
816         returns (address[2] memory arr)
817     {
818         arr[0] = tokenStats[sppID].TokenToGet;
819         arr[1] = tokenStats[sppID].TokenToGive;
820         return arr;
821     }
822 
823     function getLatestSppId() public view returns (uint256 sppId) {
824         return sppID;
825     }
826 
827     function getTimeRemainingToCharge(uint256 sppID)
828         public
829         view
830         returns (uint256 time)
831     {
832         return ((sppSubscriptionStats[sppID].lastPaidAt).add(sppSubscriptionStats[sppID].period) - now);
833     }
834 
835     struct sppSubscribers {
836         bool exists;
837         address customerAddress;
838         address tokenGive;
839         address tokenGet;
840         uint256 value;
841         uint256 period;
842         uint256 lastPaidAt;
843         uint256 remainingToBeFulfilled;
844     }
845 
846     struct currentTokenStats {
847         address TokenToGet;
848         uint256 amountGotten;
849         address TokenToGive;
850         uint256 amountGiven;
851     }
852 
853     struct listOfSubscriptions {
854         uint256[] arr;
855     }
856 
857     struct listOfSppByAddress {
858         uint256[] arr;
859     }
860 
861     mapping(uint256 => currentTokenStats) tokenStats;
862     mapping(address => listOfSppByAddress) sppSubList;
863     mapping(address => listOfSubscriptions) subList;
864     mapping(bytes32 => uint256) public hash2sppId;
865     mapping(uint256 => uint256) public onGoing;
866     mapping(uint256 => sppSubscribers) public sppSubscriptionStats;
867     mapping(address => mapping(address => uint256)) internal allowed;
868     mapping(address => mapping(address => uint256)) public tokens;
869     mapping(address => userstats) public userdata;
870     mapping(address => uint256) public balances;
871     mapping(uint256 => subscriptionstats) public subscriptiondata;
872 
873     struct userstats {
874         uint256 per_tp_release_amt;
875         uint256 time_period;
876         uint256 frozen_balance;
877         uint256 lock_till;
878         bool exists;
879     }
880 
881     struct subscriptionstats {
882         uint256 value;
883         uint256 period;
884         uint256 lastPaidAt;
885         address merchantAddress;
886         address customerAddress;
887         address tokenType;
888         bool exists;
889     }
890 
891     uint256 public totalSupply;
892     uint256 public totalPossibleSupply;
893     uint256 public orderId;
894     address public owner;
895     address private potentialAdmin;
896     address public TradeEngineAddress;
897     uint256 sppID;
898     address public usdt;
899     uint256 public usdtDecimal;
900     uint256 public rateEthUsdt;
901     uint256 nonce;
902     address public feeAccount;
903     uint256 public minPeriod;
904 }
905 
906 contract CoinBNS is BNSToken {
907     function() public {
908         revert();
909     }
910 
911     string public name;
912     uint8 public decimals;
913     string public symbol;
914     string public version = "H1.0";
915 
916     constructor() public {
917         owner = msg.sender;
918         balances[msg.sender] = 250000000000000000;
919         totalSupply = 250000000000000000;
920         totalPossibleSupply = 250000000000000000;
921         name = "BNS Token";
922         decimals = 8;
923         symbol = "BNS";
924     }
925 }