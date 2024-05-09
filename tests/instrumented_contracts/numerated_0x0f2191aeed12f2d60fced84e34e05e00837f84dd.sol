1 /*
2  * Just Price Protocol Smart Contract.
3  * Copyright © 2018 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 pragma solidity ^0.4.20;
7 
8 //import "./SafeMath.sol";
9 //import "./OrgonToken.sol";
10 //import "./OrisSpace.sol";
11 contract SafeMath {
12   uint256 constant private MAX_UINT256 =
13     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
14 
15   /**
16    * Add two uint256 values, throw in case of overflow.
17    *
18    * @param x first value to add
19    * @param y second value to add
20    * @return x + y
21    */
22   function safeAdd (uint256 x, uint256 y)
23   pure internal
24   returns (uint256 z) {
25     assert (x <= MAX_UINT256 - y);
26     return x + y;
27   }
28 
29   /**
30    * Subtract one uint256 value from another, throw in case of underflow.
31    *
32    * @param x value to subtract from
33    * @param y value to subtract
34    * @return x - y
35    */
36   function safeSub (uint256 x, uint256 y)
37   pure internal
38   returns (uint256 z) {
39     assert (x >= y);
40     return x - y;
41   }
42 
43   /**
44    * Multiply two uint256 values, throw in case of overflow.
45    *
46    * @param x first value to multiply
47    * @param y second value to multiply
48    * @return x * y
49    */
50   function safeMul (uint256 x, uint256 y)
51   pure internal
52   returns (uint256 z) {
53     if (y == 0) return 0; // Prevent division by zero at the next line
54     assert (x <= MAX_UINT256 / y);
55     return x * y;
56   }
57 }
58 
59 contract Token {
60   /**
61    * Get total number of tokens in circulation.
62    *
63    * @return total number of tokens in circulation
64    */
65   function totalSupply () public view returns (uint256 supply);
66 
67   /**
68    * Get number of tokens currently belonging to given owner.
69    *
70    * @param _owner address to get number of tokens currently belonging to the
71    *        owner of
72    * @return number of tokens currently belonging to the owner of given address
73    */
74   function balanceOf (address _owner) public view returns (uint256 balance);
75 
76   /**
77    * Transfer given number of tokens from message sender to given recipient.
78    *
79    * @param _to address to transfer tokens to the owner of
80    * @param _value number of tokens to transfer to the owner of given address
81    * @return true if tokens were transferred successfully, false otherwise
82    */
83   function transfer (address _to, uint256 _value)
84   public returns (bool success);
85 
86   /**
87    * Transfer given number of tokens from given owner to given recipient.
88    *
89    * @param _from address to transfer tokens from the owner of
90    * @param _to address to transfer tokens to the owner of
91    * @param _value number of tokens to transfer from given owner to given
92    *        recipient
93    * @return true if tokens were transferred successfully, false otherwise
94    */
95   function transferFrom (address _from, address _to, uint256 _value)
96   public returns (bool success);
97 
98   /**
99    * Allow given spender to transfer given number of tokens from message sender.
100    *
101    * @param _spender address to allow the owner of to transfer tokens from
102    *        message sender
103    * @param _value number of tokens to allow to transfer
104    * @return true if token transfer was successfully approved, false otherwise
105    */
106   function approve (address _spender, uint256 _value)
107   public returns (bool success);
108 
109   /**
110    * Tell how many tokens given spender is currently allowed to transfer from
111    * given owner.
112    *
113    * @param _owner address to get number of tokens allowed to be transferred
114    *        from the owner of
115    * @param _spender address to get number of tokens allowed to be transferred
116    *        by the owner of
117    * @return number of tokens given spender is currently allowed to transfer
118    *         from given owner
119    */
120   function allowance (address _owner, address _spender)
121   public view returns (uint256 remaining);
122 
123   /**
124    * Logged when tokens were transferred from one owner to another.
125    *
126    * @param _from address of the owner, tokens were transferred from
127    * @param _to address of the owner, tokens were transferred to
128    * @param _value number of tokens transferred
129    */
130   event Transfer (address indexed _from, address indexed _to, uint256 _value);
131 
132   /**
133    * Logged when owner approved his tokens to be transferred by some spender.
134    *
135    * @param _owner owner who approved his tokens to be transferred
136    * @param _spender spender who were allowed to transfer the tokens belonging
137    *        to the owner
138    * @param _value number of tokens belonging to the owner, approved to be
139    *        transferred by the spender
140    */
141   event Approval (
142     address indexed _owner, address indexed _spender, uint256 _value);
143 }
144 
145 contract OrisSpace {
146   /**
147    * Start Oris Space smart contract.
148    *
149    * @param _returnAmount amount of tokens to return to message sender.
150    */
151   function start (uint256 _returnAmount) public;
152 }
153 
154 contract OrgonToken is Token {
155   /**
156    * Create _value new tokens and give new created tokens to msg.sender.
157    * May only be called by smart contract owner.
158    *
159    * @param _value number of tokens to create
160    * @return true if tokens were created successfully, false otherwise
161    */
162   function createTokens (uint256 _value) public returns (bool);
163 
164   /**
165    * Burn given number of tokens belonging to message sender.
166    * May only be called by smart contract owner.
167    *
168    * @param _value number of tokens to burn
169    * @return true on success, false on error
170    */
171   function burnTokens (uint256 _value) public returns (bool);
172 }
173 
174 /**
175  * Just Price Protocol Smart Contract that serves as market maker for Orgon
176  * tokens.
177  */
178 contract JustPriceProtocol is SafeMath {
179   /**
180    * 2^128.
181    */
182   uint256 internal constant TWO_128 = 0x100000000000000000000000000000000;
183 
184   /**
185    * Sale start time (2018-04-19 06:00:00 UTC)
186    */
187   uint256 internal constant SALE_START_TIME = 1524117600;
188 
189   /**
190    * "Reserve" stage deadline (2018-07-08 00:00:00 UTC)
191    */
192   uint256 internal constant RESERVE_DEADLINE = 1531008000;
193 
194   /**
195    * Maximum amount to be collected during "reserve" stage.
196    */
197   uint256 internal constant RESERVE_MAX_AMOUNT = 72500 ether;
198 
199   /**
200    * Minimum amount to be collected during "reserve" stage.
201    */
202   uint256 internal constant RESERVE_MIN_AMOUNT = 30000 ether;
203 
204   /**
205    * Maximum number of tokens to be sold during "reserve" stage.
206    */
207   uint256 internal constant RESERVE_MAX_TOKENS = 82881476.72e9;
208 
209   /**
210    * ORNG/ETH ratio after "reserve" stage in Wei per ORGN unit.
211    */
212   uint256 internal constant RESERVE_RATIO = 72500 ether / 725000000e9;
213 
214   /**
215    * Maximum amount of ETH to collect at price 1.
216    */
217   uint256 internal constant RESERVE_THRESHOLD_1 = 10000 ether;
218 
219   /**
220    * Price 1 in Wei per ORGN unit.
221    */
222   uint256 internal constant RESERVE_PRICE_1 = 0.00080 ether / 1e9;
223 
224   /**
225    * Maximum amount of ETH to collect at price 2.
226    */
227   uint256 internal constant RESERVE_THRESHOLD_2 = 20000 ether;
228 
229   /**
230    * Price 2 in Wei per ORGN unit.
231    */
232   uint256 internal constant RESERVE_PRICE_2 = 0.00082 ether / 1e9;
233 
234   /**
235    * Maximum amount of ETH to collect at price 3.
236    */
237   uint256 internal constant RESERVE_THRESHOLD_3 = 30000 ether;
238 
239   /**
240    * Price 3 in Wei per ORGN unit.
241    */
242   uint256 internal constant RESERVE_PRICE_3 = 0.00085 ether / 1e9;
243 
244   /**
245    * Maximum amount of ETH to collect at price 4.
246    */
247   uint256 internal constant RESERVE_THRESHOLD_4 = 40000 ether;
248 
249   /**
250    * Price 4 in Wei per ORGN unit.
251    */
252   uint256 internal constant RESERVE_PRICE_4 = 0.00088 ether / 1e9;
253 
254   /**
255    * Maximum amount of ETH to collect at price 5.
256    */
257   uint256 internal constant RESERVE_THRESHOLD_5 = 50000 ether;
258 
259   /**
260    * Price 5 in Wei per ORGN unit.
261    */
262   uint256 internal constant RESERVE_PRICE_5 = 0.00090 ether / 1e9;
263 
264   /**
265    * Maximum amount of ETH to collect at price 6.
266    */
267   uint256 internal constant RESERVE_THRESHOLD_6 = 60000 ether;
268 
269   /**
270    * Price 6 in Wei per ORGN unit.
271    */
272   uint256 internal constant RESERVE_PRICE_6 = 0.00092 ether / 1e9;
273 
274   /**
275    * Maximum amount of ETH to collect at price 7.
276    */
277   uint256 internal constant RESERVE_THRESHOLD_7 = 70000 ether;
278 
279   /**
280    * Price 7 in Wei per ORGN unit.
281    */
282   uint256 internal constant RESERVE_PRICE_7 = 0.00095 ether / 1e9;
283 
284   /**
285    * Maximum amount of ETH to collect at price 8.
286    */
287   uint256 internal constant RESERVE_THRESHOLD_8 = 72500 ether;
288 
289   /**
290    * Price 8 in Wei per ORGN unit.
291    */
292   uint256 internal constant RESERVE_PRICE_8 = 0.00098 ether / 1e9;
293 
294   /**
295    * "Growth" stage ends once this many tokens were issued.
296    */
297   uint256 internal constant GROWTH_MAX_TOKENS = 1000000000e9;
298 
299   /**
300    * Maximum duration of "growth" stage.
301    */
302   uint256 internal constant GROWTH_MAX_DURATION = 285 days;
303 
304   /**
305    * Numerator of fraction of tokens bought at "reserve" stage to be delivered
306    * before "growth" stage start.
307    */
308   uint256 internal constant GROWTH_MIN_DELIVERED_NUMERATOR = 75;
309 
310   /**
311    * Denominator of fraction of tokens bought at "reserve" stage to be delivered
312    * before "growth" stage start.
313    */
314   uint256 internal constant GROWTH_MIN_DELIVERED_DENOMINATIOR = 100;
315 
316   /**
317    * Numerator of fraction of total votes to be given to a new K1 address for
318    * vote to succeed.
319    */
320   uint256 internal constant REQUIRED_VOTES_NUMERATIOR = 51;
321 
322   /**
323    * Denominator of fraction of total votes to be given to a new K1 address for
324    * vote to succeed.
325    */
326   uint256 internal constant REQUIRED_VOTES_DENOMINATOR = 100;
327 
328   /**
329    * Fee denominator (1 / 20000 = 0.00005).
330    */
331   uint256 internal constant FEE_DENOMINATOR = 20000;
332 
333   /**
334    * Delay after start of "growth" stage before fee may be changed.
335    */
336   uint256 internal constant FEE_CHANGE_DELAY = 650 days;
337 
338   /**
339    * Minimum fee (1 / 20000 = 0.0005).
340    */
341   uint256 internal constant MIN_FEE = 1;
342 
343   /**
344    * Maximum fee (2000 / 20000 = 0.1).
345    */
346   uint256 internal constant MAX_FEE = 2000;
347 
348   /**
349    * Deploy Just Price Protocol smart contract with given Orgon Token,
350    * Oris Space, and K1 wallet.
351    *
352    * @param _orgonToken Orgon Token to use
353    * @param _orisSpace Oris Space to use
354    * @param _k1 address of K1 wallet
355    */
356   function JustPriceProtocol (
357     OrgonToken _orgonToken, OrisSpace _orisSpace, address _k1)
358   public {
359     orgonToken = _orgonToken;
360     orisSpace = _orisSpace;
361     k1 = _k1;
362   }
363 
364   /**
365    * When called with no data does the same as buyTokens ().
366    */
367   function () public payable {
368     require (msg.data.length == 0);
369 
370     buyTokens ();
371   }
372 
373   /**
374    * Buy tokens.
375    */
376   function buyTokens () public payable {
377     require (msg.value > 0);
378 
379     updateStage ();
380 
381     if (stage == Stage.RESERVE)
382       buyTokensReserve ();
383     else if (stage == Stage.GROWTH || stage == Stage.LIFE)
384       buyTokensGrowthLife ();
385     else revert (); // No buying in current stage
386   }
387 
388   /**
389    * Sell tokens.
390    *
391    * @param _value number of tokens to sell
392    */
393   function sellTokens (uint256 _value) public {
394     require (_value > 0);
395     require (_value < TWO_128);
396 
397     updateStage ();
398     require (stage == Stage.LIFE);
399 
400     assert (reserveAmount < TWO_128);
401     uint256 totalSupply = orgonToken.totalSupply ();
402     require (totalSupply < TWO_128);
403 
404     require (_value <= totalSupply);
405 
406     uint256 toPay = safeMul (
407       reserveAmount,
408       safeSub (
409         TWO_128,
410         pow_10 (safeSub (TWO_128, (_value << 128) / totalSupply)))) >> 128;
411 
412     require (orgonToken.transferFrom (msg.sender, this, _value));
413     require (orgonToken.burnTokens (_value));
414 
415     reserveAmount = safeSub (reserveAmount, toPay);
416 
417     msg.sender.transfer (toPay);
418   }
419 
420   /**
421    * Deliver tokens sold during "reserve" stage to corresponding investors.
422    *
423    * @param _investors addresses of investors to deliver tokens to
424    */
425   function deliver (address [] _investors) public {
426     updateStage ();
427     require (
428       stage == Stage.BEFORE_GROWTH ||
429       stage == Stage.GROWTH ||
430       stage == Stage.LIFE);
431 
432     for (uint256 i = 0; i < _investors.length; i++) {
433       address investorAddress = _investors [i];
434       Investor storage investor = investors [investorAddress];
435 
436       uint256 toDeliver = investor.tokensBought;
437       investor.tokensBought = 0;
438       investor.etherInvested = 0;
439 
440       if (toDeliver > 0) {
441         require (orgonToken.transfer (investorAddress, toDeliver));
442         reserveTokensDelivered = safeAdd (reserveTokensDelivered, toDeliver);
443 
444         Delivery (investorAddress, toDeliver);
445       }
446     }
447 
448     if (stage == Stage.BEFORE_GROWTH &&
449       safeMul (reserveTokensDelivered, GROWTH_MIN_DELIVERED_DENOMINATIOR) >=
450         safeMul (reserveTokensSold, GROWTH_MIN_DELIVERED_NUMERATOR)) {
451       stage = Stage.GROWTH;
452       growthDeadline = currentTime () + GROWTH_MAX_DURATION;
453       feeChangeEnableTime = currentTime () + FEE_CHANGE_DELAY;
454     }
455   }
456 
457   /**
458    * Refund investors who bought tokens during "reserve" stage.
459    *
460    * @param _investors addresses of investors to refund
461    */
462   function refund (address [] _investors) public {
463     updateStage ();
464     require (stage == Stage.REFUND);
465 
466     for (uint256 i = 0; i < _investors.length; i++) {
467       address investorAddress = _investors [i];
468       Investor storage investor = investors [investorAddress];
469 
470       uint256 toBurn = investor.tokensBought;
471       uint256 toRefund = investor.etherInvested;
472 
473       investor.tokensBought = 0;
474       investor.etherInvested = 0;
475 
476       if (toBurn > 0)
477         require (orgonToken.burnTokens (toBurn));
478 
479       if (toRefund > 0) {
480         investorAddress.transfer (toRefund);
481 
482         Refund (investorAddress, toRefund);
483       }
484     }
485   }
486 
487   function vote (address _newK1) public {
488     updateStage ();
489 
490     require (stage == Stage.LIFE);
491     require (!k1Changed);
492 
493     uint256 votesCount = voteNumbers [msg.sender];
494     if (votesCount > 0) {
495       address oldK1 = votes [msg.sender];
496       if (_newK1 != oldK1) {
497         if (oldK1 != address (0)) {
498           voteResults [oldK1] = safeSub (voteResults [oldK1], votesCount);
499 
500           VoteRevocation (msg.sender, oldK1, votesCount);
501         }
502 
503         votes [msg.sender] = _newK1;
504 
505         if (_newK1 != address (0)) {
506           voteResults [_newK1] = safeAdd (voteResults [_newK1], votesCount);
507           Vote (msg.sender, _newK1, votesCount);
508 
509           if (safeMul (voteResults [_newK1], REQUIRED_VOTES_DENOMINATOR) >=
510             safeMul (totalVotesNumber, REQUIRED_VOTES_NUMERATIOR)) {
511             k1 = _newK1;
512             k1Changed = true;
513 
514             K1Change (_newK1);
515           }
516         }
517       }
518     }
519   }
520 
521   /**
522    * Set new fee numerator.
523    *
524    * @param _fee new fee numerator.
525    */
526   function setFee (uint256 _fee) public {
527     require (msg.sender == k1);
528 
529     require (_fee >= MIN_FEE);
530     require (_fee <= MAX_FEE);
531 
532     updateStage ();
533 
534     require (stage == Stage.GROWTH || stage == Stage.LIFE);
535     require (currentTime () >= feeChangeEnableTime);
536 
537     require (safeSub (_fee, 1) <= fee);
538     require (safeAdd (_fee, 1) >= fee);
539 
540     if (fee != _fee) {
541       fee = _fee;
542 
543       FeeChange (_fee);
544     }
545   }
546 
547   /**
548    * Get number of tokens bought by given investor during reserve stage that are
549    * not yet delivered to him.
550    *
551    * @param _investor address of investor to get number of outstanding tokens
552    *       for
553    * @return number of non-delivered tokens given investor bought during reserve
554    *         stage
555    */
556   function outstandingTokens (address _investor) public view returns (uint256) {
557     return investors [_investor].tokensBought;
558   }
559 
560   /**
561    * Get current stage of Just Price Protocol.
562    *
563    * @param _currentTime current time in seconds since epoch
564    * @return current stage of Just Price Protocol
565    */
566   function getStage (uint256 _currentTime) public view returns (Stage) {
567     Stage currentStage = stage;
568 
569     if (currentStage == Stage.BEFORE_RESERVE) {
570       if (_currentTime >= SALE_START_TIME)
571         currentStage = Stage.RESERVE;
572       else return currentStage;
573     }
574 
575     if (currentStage == Stage.RESERVE) {
576       if (_currentTime >= RESERVE_DEADLINE) {
577         if (reserveAmount >= RESERVE_MIN_AMOUNT)
578           currentStage = Stage.BEFORE_GROWTH;
579         else currentStage = Stage.REFUND;
580       }
581 
582       return currentStage;
583     }
584 
585     if (currentStage == Stage.GROWTH) {
586       if (_currentTime >= growthDeadline) {
587         currentStage = Stage.LIFE;
588       }
589     }
590 
591     return currentStage;
592   }
593 
594   /**
595    * Return total number of votes eligible for choosing new K1 address.
596    *
597    * @return total number of votes eligible for choosing new K1 address
598    */
599   function totalEligibleVotes () public view returns (uint256) {
600     return totalVotesNumber;
601   }
602 
603   /**
604    * Return number of votes eligible for choosing new K1 address given investor
605    * has.
606    *
607    * @param _investor address of investor to get number of eligible votes of
608    * @return Number of eligible votes given investor has
609    */
610   function eligibleVotes (address _investor) public view returns (uint256) {
611     return voteNumbers [_investor];
612   }
613 
614   /**
615    * Get number of votes for the given new K1 address.
616    *
617    * @param _newK1 new K1 address to get number of votes for
618    * @return number of votes for the given new K1 address
619    */
620   function votesFor (address _newK1) public view returns (uint256) {
621     return voteResults [_newK1];
622   }
623 
624   /**
625    * Buy tokens during "reserve" stage.
626    */
627   function buyTokensReserve () internal {
628     require (stage == Stage.RESERVE);
629 
630     uint256 toBuy = 0;
631     uint256 toRefund = msg.value;
632     uint256 etherInvested = 0;
633     uint256 tokens;
634     uint256 tokensValue;
635 
636     if (reserveAmount < RESERVE_THRESHOLD_1) {
637       tokens = min (
638         toRefund,
639         safeSub (RESERVE_THRESHOLD_1, reserveAmount)) /
640         RESERVE_PRICE_1;
641 
642       if (tokens > 0) {
643         tokensValue = safeMul (tokens, RESERVE_PRICE_1);
644 
645         toBuy = safeAdd (toBuy, tokens);
646         toRefund = safeSub (toRefund, tokensValue);
647         etherInvested = safeAdd (etherInvested, tokensValue);
648         reserveAmount = safeAdd (reserveAmount, tokensValue);
649       }
650     }
651 
652     if (reserveAmount < RESERVE_THRESHOLD_2) {
653       tokens = min (
654         toRefund,
655         safeSub (RESERVE_THRESHOLD_2, reserveAmount)) /
656         RESERVE_PRICE_2;
657 
658       if (tokens > 0) {
659         tokensValue = safeMul (tokens, RESERVE_PRICE_2);
660 
661         toBuy = safeAdd (toBuy, tokens);
662         toRefund = safeSub (toRefund, tokensValue);
663         etherInvested = safeAdd (etherInvested, tokensValue);
664         reserveAmount = safeAdd (reserveAmount, tokensValue);
665       }
666     }
667 
668     if (reserveAmount < RESERVE_THRESHOLD_3) {
669       tokens = min (
670         toRefund,
671         safeSub (RESERVE_THRESHOLD_3, reserveAmount)) /
672         RESERVE_PRICE_3;
673 
674       if (tokens > 0) {
675         tokensValue = safeMul (tokens, RESERVE_PRICE_3);
676 
677         toBuy = safeAdd (toBuy, tokens);
678         toRefund = safeSub (toRefund, tokensValue);
679         etherInvested = safeAdd (etherInvested, tokensValue);
680         reserveAmount = safeAdd (reserveAmount, tokensValue);
681       }
682     }
683 
684     if (reserveAmount < RESERVE_THRESHOLD_4) {
685       tokens = min (
686         toRefund,
687         safeSub (RESERVE_THRESHOLD_4, reserveAmount)) /
688         RESERVE_PRICE_4;
689 
690       if (tokens > 0) {
691         tokensValue = safeMul (tokens, RESERVE_PRICE_4);
692 
693         toBuy = safeAdd (toBuy, tokens);
694         toRefund = safeSub (toRefund, tokensValue);
695         etherInvested = safeAdd (etherInvested, tokensValue);
696         reserveAmount = safeAdd (reserveAmount, tokensValue);
697       }
698     }
699 
700     if (reserveAmount < RESERVE_THRESHOLD_5) {
701       tokens = min (
702         toRefund,
703         safeSub (RESERVE_THRESHOLD_5, reserveAmount)) /
704         RESERVE_PRICE_5;
705 
706       if (tokens > 0) {
707         tokensValue = safeMul (tokens, RESERVE_PRICE_5);
708 
709         toBuy = safeAdd (toBuy, tokens);
710         toRefund = safeSub (toRefund, tokensValue);
711         etherInvested = safeAdd (etherInvested, tokensValue);
712         reserveAmount = safeAdd (reserveAmount, tokensValue);
713       }
714     }
715 
716     if (reserveAmount < RESERVE_THRESHOLD_6) {
717       tokens = min (
718         toRefund,
719         safeSub (RESERVE_THRESHOLD_6, reserveAmount)) /
720         RESERVE_PRICE_6;
721 
722       if (tokens > 0) {
723         tokensValue = safeMul (tokens, RESERVE_PRICE_6);
724 
725         toBuy = safeAdd (toBuy, tokens);
726         toRefund = safeSub (toRefund, tokensValue);
727         etherInvested = safeAdd (etherInvested, tokensValue);
728         reserveAmount = safeAdd (reserveAmount, tokensValue);
729       }
730     }
731 
732     if (reserveAmount < RESERVE_THRESHOLD_7) {
733       tokens = min (
734         toRefund,
735         safeSub (RESERVE_THRESHOLD_7, reserveAmount)) /
736         RESERVE_PRICE_7;
737 
738       if (tokens > 0) {
739         tokensValue = safeMul (tokens, RESERVE_PRICE_7);
740 
741         toBuy = safeAdd (toBuy, tokens);
742         toRefund = safeSub (toRefund, tokensValue);
743         etherInvested = safeAdd (etherInvested, tokensValue);
744         reserveAmount = safeAdd (reserveAmount, tokensValue);
745       }
746     }
747 
748     if (reserveAmount < RESERVE_THRESHOLD_8) {
749       tokens = min (
750         toRefund,
751         safeSub (RESERVE_THRESHOLD_8, reserveAmount)) /
752         RESERVE_PRICE_8;
753 
754       if (tokens > 0) {
755         tokensValue = safeMul (tokens, RESERVE_PRICE_8);
756 
757         toBuy = safeAdd (toBuy, tokens);
758         toRefund = safeSub (toRefund, tokensValue);
759         etherInvested = safeAdd (etherInvested, tokensValue);
760         reserveAmount = safeAdd (reserveAmount, tokensValue);
761       }
762     }
763 
764     if (toBuy > 0) {
765       Investor storage investor = investors [msg.sender];
766 
767       investor.tokensBought = safeAdd (
768         investor.tokensBought, toBuy);
769 
770       investor.etherInvested = safeAdd (
771         investor.etherInvested, etherInvested);
772 
773       reserveTokensSold = safeAdd (reserveTokensSold, toBuy);
774 
775       require (orgonToken.createTokens (toBuy));
776 
777       voteNumbers [msg.sender] = safeAdd (voteNumbers [msg.sender], toBuy);
778       totalVotesNumber = safeAdd (totalVotesNumber, toBuy);
779 
780       Investment (msg.sender, etherInvested, toBuy);
781 
782       if (safeSub (RESERVE_THRESHOLD_8, reserveAmount) <
783         RESERVE_PRICE_8) {
784 
785         orisSpace.start (0);
786 
787         stage = Stage.BEFORE_GROWTH;
788       }
789     }
790 
791     if (toRefund > 0)
792       msg.sender.transfer (toRefund);
793   }
794 
795   /**
796    * Buy tokens during "growth" or "life" stage.
797    */
798   function buyTokensGrowthLife () internal {
799     require (stage == Stage.GROWTH || stage == Stage.LIFE);
800 
801     require (msg.value < TWO_128);
802 
803     uint256 totalSupply = orgonToken.totalSupply ();
804     assert (totalSupply < TWO_128);
805 
806     uint256 toBuy = safeMul (
807       totalSupply,
808       safeSub (
809         root_10 (safeAdd (TWO_128, (msg.value << 128) / reserveAmount)),
810         TWO_128)) >> 128;
811 
812     reserveAmount = safeAdd (reserveAmount, msg.value);
813     require (reserveAmount < TWO_128);
814 
815     if (toBuy > 0) {
816       require (orgonToken.createTokens (toBuy));
817       require (orgonToken.totalSupply () < TWO_128);
818 
819       uint256 feeAmount = safeMul (toBuy, fee) / FEE_DENOMINATOR;
820 
821       require (orgonToken.transfer (msg.sender, safeSub (toBuy, feeAmount)));
822 
823       if (feeAmount > 0)
824         require (orgonToken.transfer (k1, feeAmount));
825 
826       if (stage == Stage.GROWTH) {
827         uint256 votesCount = toBuy;
828 
829         totalSupply = orgonToken.totalSupply ();
830         if (totalSupply >= GROWTH_MAX_TOKENS) {
831           stage = Stage.LIFE;
832           votesCount = safeSub (
833             votesCount,
834             safeSub (totalSupply, GROWTH_MAX_TOKENS));
835         }
836 
837         voteNumbers [msg.sender] =
838           safeAdd (voteNumbers [msg.sender], votesCount);
839         totalVotesNumber = safeAdd (totalVotesNumber, votesCount);
840       }
841     }
842   }
843 
844   /**
845    * Update stage of Just Price Protocol and return updated stage.
846    *
847    * @return updated stage of Just Price Protocol
848    */
849   function updateStage () internal returns (Stage) {
850     Stage currentStage = getStage (currentTime ());
851     if (stage != currentStage) {
852       if (currentStage == Stage.BEFORE_GROWTH) {
853         // "Reserve" stage deadline reached and minimum amount collected
854         uint256 tokensToBurn =
855           safeSub (
856             safeAdd (
857               safeAdd (
858                 safeSub (RESERVE_MAX_AMOUNT, reserveAmount),
859                 safeSub (RESERVE_RATIO, 1)) /
860                 RESERVE_RATIO,
861               reserveTokensSold),
862             RESERVE_MAX_TOKENS);
863 
864         orisSpace.start (tokensToBurn);
865         if (tokensToBurn > 0)
866           require (orgonToken.burnTokens (tokensToBurn));
867       }
868 
869       stage = currentStage;
870     }
871   }
872 
873   /**
874    * Get minimum of two values.
875    *
876    * @param x first value
877    * @param y second value
878    * @return minimum of two values
879    */
880   function min (uint256 x, uint256 y) internal pure returns (uint256) {
881     return x < y ? x : y;
882   }
883 
884   /**
885    * Calculate 2^128 * (x / 2^128)^(1/10).
886    *
887    * @param x parameter x
888    * @return 2^128 * (x / 2^128)^(1/10)
889    */
890   function root_10 (uint256 x) internal pure returns (uint256 y) {
891     uint256 shift = 0;
892 
893     while (x > TWO_128) {
894       x >>= 10;
895       shift += 1;
896     }
897 
898     if (x == TWO_128 || x == 0) y = x;
899     else {
900       uint256 x128 = x << 128;
901       y = TWO_128;
902 
903       uint256 t = x;
904       while (true) {
905         t <<= 10;
906         if (t < TWO_128) y >>= 1;
907         else break;
908       }
909 
910       for (uint256 i = 0; i < 16; i++) {
911         uint256 y9;
912 
913         if (y == TWO_128) y9 = y;
914         else {
915           uint256 y2 = (y * y) >> 128;
916           uint256 y4 = (y2 * y2) >> 128;
917           uint256 y8 = (y4 * y4) >> 128;
918           y9 = (y * y8) >> 128;
919         }
920 
921         y = (9 * y + x128 / y9) / 10;
922 
923         assert (y <= TWO_128);
924       }
925     }
926 
927     y <<= shift;
928   }
929 
930   /**
931    * Calculate 2^128 * (x / 2^128)^10.
932    *
933    * @param x parameter x
934    * @return 2^128 * (x / 2^128)^10
935    */
936   function pow_10 (uint256 x) internal pure returns (uint256) {
937     require (x <= TWO_128);
938 
939     if (x == TWO_128) return x;
940     else {
941       uint256 x2 = (x * x) >> 128;
942       uint256 x4 = (x2 * x2) >> 128;
943       uint256 x8 = (x4 * x4) >> 128;
944       return (x2 * x8) >> 128;
945     }
946   }
947 
948   /**
949    * Get current time in seconds since epoch.
950    *
951    * @return current time in seconds since epoch
952    */
953   function currentTime () internal view returns (uint256) {
954     return block.timestamp;
955   }
956 
957   /**
958    * Just Price Protocol stages.
959    * +----------------+
960    * | BEFORE_RESERVE |
961    * +----------------+
962    *         |
963    *         | Sale start time reached
964    *         V
965    *    +---------+   Reserve deadline reached
966    *    | RESERVE |-------------------------------+
967    *    +---------+                               |
968    *         |                                    |
969    *         | 72500 ETH collected                |
970    *         V                                    |
971    * +---------------+ 39013,174672 ETH collected |
972    * | BEFORE_GROWTH |<---------------------------O
973    * +---------------+                            |
974    *         |                                    | 39013,174672 ETH not collected
975    *         | 80% of tokens delivered            |
976    *         V                                    V
977    *  +------------+                         +--------+
978    *  |   GROWTH   |                         | REFUND |
979    *  +------------+                         +--------+
980    *         |
981    *         | 1,500,000,000 tokens issued or 365 days passed since start of "GROWTH" stage
982    *         V
983    *     +------+
984    *     | LIFE |
985    *     +------+
986    */
987   enum Stage {
988     BEFORE_RESERVE, // Before start of "Reserve" stage
989     RESERVE, // "Reserve" stage
990     BEFORE_GROWTH, // Between "Reserve" and "Growth" stages
991     GROWTH, // "Grows" stage
992     LIFE, // "Life" stage
993     REFUND // "Refund" stage
994   }
995 
996   /**
997    * Orgon Token smart contract.
998    */
999   OrgonToken internal orgonToken;
1000 
1001   /**
1002    * Oris Space spart contract.
1003    */
1004   OrisSpace internal orisSpace;
1005 
1006   /**
1007    * Address of K1 smart contract.
1008    */
1009   address internal k1;
1010 
1011   /**
1012    * Last known stage of Just Price Protocol
1013    */
1014   Stage internal stage = Stage.BEFORE_RESERVE;
1015 
1016   /**
1017    * Amount of ether in reserve.
1018    */
1019   uint256 internal reserveAmount;
1020 
1021   /**
1022    * Number of tokens sold during "reserve" stage.
1023    */
1024   uint256 internal reserveTokensSold;
1025 
1026   /**
1027    * Number of tokens sold during "reserve" stage that were already delivered to
1028    * investors.
1029    */
1030   uint256 internal reserveTokensDelivered;
1031 
1032   /**
1033    * "Growth" stage deadline.
1034    */
1035   uint256 internal growthDeadline;
1036 
1037   /**
1038    * Mapping from address of a person who bought some tokens during "reserve"
1039    * stage to information about how many tokens he bought to how much ether
1040    * invested.
1041    */
1042   mapping (address => Investor) internal investors;
1043 
1044   /**
1045    * Mapping from address of an investor to the number of votes this investor
1046    * has.
1047    */
1048   mapping (address => uint256) internal voteNumbers;
1049 
1050   /**
1051    * Mapping from address of an investor to the new K1 address this investor
1052    * voted for.
1053    */
1054   mapping (address => address) internal votes;
1055 
1056   /**
1057    * Mapping from suggested new K1 address to the number of votes for this
1058    * address.
1059    */
1060   mapping (address => uint256) internal voteResults;
1061 
1062   /**
1063    * Total number of eligible votes.
1064    */
1065   uint256 internal totalVotesNumber;
1066 
1067   /**
1068    * Whether K1 address was already changed via voting.
1069    */
1070   bool internal k1Changed = false;
1071 
1072   /**
1073    * Fee enumerator.  (2 / 20000 = 0.0001);
1074    */
1075   uint256 internal fee = 2;
1076 
1077   /**
1078    * Time when fee changing is enabled.
1079    */
1080   uint256 internal feeChangeEnableTime;
1081 
1082   /**
1083    * Encapsulates information about a person who bought some tokens during
1084    * "reserve" stage.
1085    */
1086   struct Investor {
1087     /**
1088      * Number of tokens bought during reserve stage.
1089      */
1090     uint256 tokensBought;
1091 
1092     /**
1093      * Ether invested during reserve stage.
1094      */
1095     uint256 etherInvested;
1096   }
1097 
1098   /**
1099    * Logged when investor invested some ether during "reserve" stage.
1100    *
1101    * @param investor address of investor
1102    * @param value amount of ether invested
1103    * @param amount number of tokens issued for investor
1104    */
1105   event Investment (address indexed investor, uint256 value, uint256 amount);
1106 
1107   /**
1108    * Logged when tokens bought at "reserve" stage were delivered to investor.
1109    *
1110    * @param investor address of investor whom tokens were delivered to
1111    * @param amount number of tokens delivered
1112    */
1113   event Delivery (address indexed investor, uint256 amount);
1114 
1115   /**
1116    * Logged when investment was refunded.
1117    *
1118    * @param investor address of investor whose investment was refunded
1119    * @param value amount of ether refunded
1120    */
1121   event Refund (address indexed investor, uint256 value);
1122 
1123   /**
1124    * Logged when K1 address was changed.
1125    *
1126    * @param k1 new K1 address
1127    */
1128   event K1Change (address k1);
1129 
1130   /**
1131    * Logged when investor voted for new K1 address.
1132    * 
1133    * @param investor investor who voted for new K1 address
1134    * @param newK1 new K1 address investor voted for
1135    * @param votes number of votes investor has
1136    */
1137   event Vote (address indexed investor, address indexed newK1, uint256 votes);
1138 
1139   /**
1140    * Logged when investor revoked vote for new K1 address.
1141    * 
1142    * @param investor investor who revoked vote for new K1 address
1143    * @param newK1 new K1 address investor revoked vote for
1144    * @param votes number of votes investor has
1145    */
1146   event VoteRevocation (
1147     address indexed investor, address indexed newK1, uint256 votes);
1148 
1149   /**
1150    * Logged when fee was changed.
1151    *
1152    * @param fee new fee numerator
1153    */
1154   event FeeChange (uint256 fee);
1155 }