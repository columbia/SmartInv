1 pragma solidity 0.4.15;
2 
3 
4 /// @title Math library - Allows calculation of logarithmic and exponential functions
5 /// @author Alan Lu - <alan.lu@gnosis.pm>
6 /// @author Stefan George - <stefan@gnosis.pm>
7 library Math {
8 
9     /*
10      *  Constants
11      */
12     // This is equal to 1 in our calculations
13     uint public constant ONE =  0x10000000000000000;
14     uint public constant LN2 = 0xb17217f7d1cf79ac;
15     uint public constant LOG2_E = 0x171547652b82fe177;
16 
17     /*
18      *  Public functions
19      */
20     /// @dev Returns natural exponential function value of given x
21     /// @param x x
22     /// @return e**x
23     function exp(int x)
24         public
25         constant
26         returns (uint)
27     {
28         // revert if x is > MAX_POWER, where
29         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
30         require(x <= 2454971259878909886679);
31         // return 0 if exp(x) is tiny, using
32         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
33         if (x < -818323753292969962227)
34             return 0;
35         // Transform so that e^x -> 2^x
36         x = x * int(ONE) / int(LN2);
37         // 2^x = 2^whole(x) * 2^frac(x)
38         //       ^^^^^^^^^^ is a bit shift
39         // so Taylor expand on z = frac(x)
40         int shift;
41         uint z;
42         if (x >= 0) {
43             shift = x / int(ONE);
44             z = uint(x % int(ONE));
45         }
46         else {
47             shift = x / int(ONE) - 1;
48             z = ONE - uint(-x % int(ONE));
49         }
50         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
51         //
52         // Can generate the z coefficients using mpmath and the following lines
53         // >>> from mpmath import mp
54         // >>> mp.dps = 100
55         // >>> ONE =  0x10000000000000000
56         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
57         // 0xb17217f7d1cf79ab
58         // 0x3d7f7bff058b1d50
59         // 0xe35846b82505fc5
60         // 0x276556df749cee5
61         // 0x5761ff9e299cc4
62         // 0xa184897c363c3
63         uint zpow = z;
64         uint result = ONE;
65         result += 0xb17217f7d1cf79ab * zpow / ONE;
66         zpow = zpow * z / ONE;
67         result += 0x3d7f7bff058b1d50 * zpow / ONE;
68         zpow = zpow * z / ONE;
69         result += 0xe35846b82505fc5 * zpow / ONE;
70         zpow = zpow * z / ONE;
71         result += 0x276556df749cee5 * zpow / ONE;
72         zpow = zpow * z / ONE;
73         result += 0x5761ff9e299cc4 * zpow / ONE;
74         zpow = zpow * z / ONE;
75         result += 0xa184897c363c3 * zpow / ONE;
76         zpow = zpow * z / ONE;
77         result += 0xffe5fe2c4586 * zpow / ONE;
78         zpow = zpow * z / ONE;
79         result += 0x162c0223a5c8 * zpow / ONE;
80         zpow = zpow * z / ONE;
81         result += 0x1b5253d395e * zpow / ONE;
82         zpow = zpow * z / ONE;
83         result += 0x1e4cf5158b * zpow / ONE;
84         zpow = zpow * z / ONE;
85         result += 0x1e8cac735 * zpow / ONE;
86         zpow = zpow * z / ONE;
87         result += 0x1c3bd650 * zpow / ONE;
88         zpow = zpow * z / ONE;
89         result += 0x1816193 * zpow / ONE;
90         zpow = zpow * z / ONE;
91         result += 0x131496 * zpow / ONE;
92         zpow = zpow * z / ONE;
93         result += 0xe1b7 * zpow / ONE;
94         zpow = zpow * z / ONE;
95         result += 0x9c7 * zpow / ONE;
96         if (shift >= 0) {
97             if (result >> (256-shift) > 0)
98                 return (2**256-1);
99             return result << shift;
100         }
101         else
102             return result >> (-shift);
103     }
104 
105     /// @dev Returns natural logarithm value of given x
106     /// @param x x
107     /// @return ln(x)
108     function ln(uint x)
109         public
110         constant
111         returns (int)
112     {
113         require(x > 0);
114         // binary search for floor(log2(x))
115         int ilog2 = floorLog2(x);
116         int z;
117         if (ilog2 < 0)
118             z = int(x << uint(-ilog2));
119         else
120             z = int(x >> uint(ilog2));
121         // z = x * 2^-⌊log₂x⌋
122         // so 1 <= z < 2
123         // and ln z = ln x - ⌊log₂x⌋/log₂e
124         // so just compute ln z using artanh series
125         // and calculate ln x from that
126         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
127         int halflnz = term;
128         int termpow = term * term / int(ONE) * term / int(ONE);
129         halflnz += termpow / 3;
130         termpow = termpow * term / int(ONE) * term / int(ONE);
131         halflnz += termpow / 5;
132         termpow = termpow * term / int(ONE) * term / int(ONE);
133         halflnz += termpow / 7;
134         termpow = termpow * term / int(ONE) * term / int(ONE);
135         halflnz += termpow / 9;
136         termpow = termpow * term / int(ONE) * term / int(ONE);
137         halflnz += termpow / 11;
138         termpow = termpow * term / int(ONE) * term / int(ONE);
139         halflnz += termpow / 13;
140         termpow = termpow * term / int(ONE) * term / int(ONE);
141         halflnz += termpow / 15;
142         termpow = termpow * term / int(ONE) * term / int(ONE);
143         halflnz += termpow / 17;
144         termpow = termpow * term / int(ONE) * term / int(ONE);
145         halflnz += termpow / 19;
146         termpow = termpow * term / int(ONE) * term / int(ONE);
147         halflnz += termpow / 21;
148         termpow = termpow * term / int(ONE) * term / int(ONE);
149         halflnz += termpow / 23;
150         termpow = termpow * term / int(ONE) * term / int(ONE);
151         halflnz += termpow / 25;
152         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
153     }
154 
155     /// @dev Returns base 2 logarithm value of given x
156     /// @param x x
157     /// @return logarithmic value
158     function floorLog2(uint x)
159         public
160         constant
161         returns (int lo)
162     {
163         lo = -64;
164         int hi = 193;
165         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
166         int mid = (hi + lo) >> 1;
167         while((lo + 1) < hi) {
168             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE)
169                 hi = mid;
170             else
171                 lo = mid;
172             mid = (hi + lo) >> 1;
173         }
174     }
175 
176     /// @dev Returns maximum of an array
177     /// @param nums Numbers to look through
178     /// @return Maximum number
179     function max(int[] nums)
180         public
181         constant
182         returns (int max)
183     {
184         require(nums.length > 0);
185         max = -2**255;
186         for (uint i = 0; i < nums.length; i++)
187             if (nums[i] > max)
188                 max = nums[i];
189     }
190 
191     /// @dev Returns whether an add operation causes an overflow
192     /// @param a First addend
193     /// @param b Second addend
194     /// @return Did no overflow occur?
195     function safeToAdd(uint a, uint b)
196         public
197         constant
198         returns (bool)
199     {
200         return a + b >= a;
201     }
202 
203     /// @dev Returns whether a subtraction operation causes an underflow
204     /// @param a Minuend
205     /// @param b Subtrahend
206     /// @return Did no underflow occur?
207     function safeToSub(uint a, uint b)
208         public
209         constant
210         returns (bool)
211     {
212         return a >= b;
213     }
214 
215     /// @dev Returns whether a multiply operation causes an overflow
216     /// @param a First factor
217     /// @param b Second factor
218     /// @return Did no overflow occur?
219     function safeToMul(uint a, uint b)
220         public
221         constant
222         returns (bool)
223     {
224         return b == 0 || a * b / b == a;
225     }
226 
227     /// @dev Returns sum if no overflow occurred
228     /// @param a First addend
229     /// @param b Second addend
230     /// @return Sum
231     function add(uint a, uint b)
232         public
233         constant
234         returns (uint)
235     {
236         require(safeToAdd(a, b));
237         return a + b;
238     }
239 
240     /// @dev Returns difference if no overflow occurred
241     /// @param a Minuend
242     /// @param b Subtrahend
243     /// @return Difference
244     function sub(uint a, uint b)
245         public
246         constant
247         returns (uint)
248     {
249         require(safeToSub(a, b));
250         return a - b;
251     }
252 
253     /// @dev Returns product if no overflow occurred
254     /// @param a First factor
255     /// @param b Second factor
256     /// @return Product
257     function mul(uint a, uint b)
258         public
259         constant
260         returns (uint)
261     {
262         require(safeToMul(a, b));
263         return a * b;
264     }
265 
266     /// @dev Returns whether an add operation causes an overflow
267     /// @param a First addend
268     /// @param b Second addend
269     /// @return Did no overflow occur?
270     function safeToAdd(int a, int b)
271         public
272         constant
273         returns (bool)
274     {
275         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
276     }
277 
278     /// @dev Returns whether a subtraction operation causes an underflow
279     /// @param a Minuend
280     /// @param b Subtrahend
281     /// @return Did no underflow occur?
282     function safeToSub(int a, int b)
283         public
284         constant
285         returns (bool)
286     {
287         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
288     }
289 
290     /// @dev Returns whether a multiply operation causes an overflow
291     /// @param a First factor
292     /// @param b Second factor
293     /// @return Did no overflow occur?
294     function safeToMul(int a, int b)
295         public
296         constant
297         returns (bool)
298     {
299         return (b == 0) || (a * b / b == a);
300     }
301 
302     /// @dev Returns sum if no overflow occurred
303     /// @param a First addend
304     /// @param b Second addend
305     /// @return Sum
306     function add(int a, int b)
307         public
308         constant
309         returns (int)
310     {
311         require(safeToAdd(a, b));
312         return a + b;
313     }
314 
315     /// @dev Returns difference if no overflow occurred
316     /// @param a Minuend
317     /// @param b Subtrahend
318     /// @return Difference
319     function sub(int a, int b)
320         public
321         constant
322         returns (int)
323     {
324         require(safeToSub(a, b));
325         return a - b;
326     }
327 
328     /// @dev Returns product if no overflow occurred
329     /// @param a First factor
330     /// @param b Second factor
331     /// @return Product
332     function mul(int a, int b)
333         public
334         constant
335         returns (int)
336     {
337         require(safeToMul(a, b));
338         return a * b;
339     }
340 }
341 
342 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
343 
344 
345 /// @title Abstract token contract - Functions to be implemented by token contracts
346 contract Token {
347 
348     /*
349      *  Events
350      */
351     event Transfer(address indexed from, address indexed to, uint value);
352     event Approval(address indexed owner, address indexed spender, uint value);
353 
354     /*
355      *  Public functions
356      */
357     function transfer(address to, uint value) public returns (bool);
358     function transferFrom(address from, address to, uint value) public returns (bool);
359     function approve(address spender, uint value) public returns (bool);
360     function balanceOf(address owner) public constant returns (uint);
361     function allowance(address owner, address spender) public constant returns (uint);
362     function totalSupply() public constant returns (uint);
363 }
364 
365 
366 
367 /// @title Standard token contract with overflow protection
368 contract StandardToken is Token {
369     using Math for *;
370 
371     /*
372      *  Storage
373      */
374     mapping (address => uint) balances;
375     mapping (address => mapping (address => uint)) allowances;
376     uint totalTokens;
377 
378     /*
379      *  Public functions
380      */
381     /// @dev Transfers sender's tokens to a given address. Returns success
382     /// @param to Address of token receiver
383     /// @param value Number of tokens to transfer
384     /// @return Was transfer successful?
385     function transfer(address to, uint value)
386         public
387         returns (bool)
388     {
389         if (   !balances[msg.sender].safeToSub(value)
390             || !balances[to].safeToAdd(value))
391             return false;
392         balances[msg.sender] -= value;
393         balances[to] += value;
394         Transfer(msg.sender, to, value);
395         return true;
396     }
397 
398     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
399     /// @param from Address from where tokens are withdrawn
400     /// @param to Address to where tokens are sent
401     /// @param value Number of tokens to transfer
402     /// @return Was transfer successful?
403     function transferFrom(address from, address to, uint value)
404         public
405         returns (bool)
406     {
407         if (   !balances[from].safeToSub(value)
408             || !allowances[from][msg.sender].safeToSub(value)
409             || !balances[to].safeToAdd(value))
410             return false;
411         balances[from] -= value;
412         allowances[from][msg.sender] -= value;
413         balances[to] += value;
414         Transfer(from, to, value);
415         return true;
416     }
417 
418     /// @dev Sets approved amount of tokens for spender. Returns success
419     /// @param spender Address of allowed account
420     /// @param value Number of approved tokens
421     /// @return Was approval successful?
422     function approve(address spender, uint value)
423         public
424         returns (bool)
425     {
426         allowances[msg.sender][spender] = value;
427         Approval(msg.sender, spender, value);
428         return true;
429     }
430 
431     /// @dev Returns number of allowed tokens for given address
432     /// @param owner Address of token owner
433     /// @param spender Address of token spender
434     /// @return Remaining allowance for spender
435     function allowance(address owner, address spender)
436         public
437         constant
438         returns (uint)
439     {
440         return allowances[owner][spender];
441     }
442 
443     /// @dev Returns number of tokens owned by given address
444     /// @param owner Address of token owner
445     /// @return Balance of owner
446     function balanceOf(address owner)
447         public
448         constant
449         returns (uint)
450     {
451         return balances[owner];
452     }
453 
454     /// @dev Returns total supply of tokens
455     /// @return Total supply
456     function totalSupply()
457         public
458         constant
459         returns (uint)
460     {
461         return totalTokens;
462     }
463 }
464 
465 
466 /// @title Outcome token contract - Issuing and revoking outcome tokens
467 /// @author Stefan George - <stefan@gnosis.pm>
468 contract OutcomeToken is StandardToken {
469     using Math for *;
470 
471     /*
472      *  Events
473      */
474     event Issuance(address indexed owner, uint amount);
475     event Revocation(address indexed owner, uint amount);
476 
477     /*
478      *  Storage
479      */
480     address public eventContract;
481 
482     /*
483      *  Modifiers
484      */
485     modifier isEventContract () {
486         // Only event contract is allowed to proceed
487         require(msg.sender == eventContract);
488         _;
489     }
490 
491     /*
492      *  Public functions
493      */
494     /// @dev Constructor sets events contract address
495     function OutcomeToken()
496         public
497     {
498         eventContract = msg.sender;
499     }
500     
501     /// @dev Events contract issues new tokens for address. Returns success
502     /// @param _for Address of receiver
503     /// @param outcomeTokenCount Number of tokens to issue
504     function issue(address _for, uint outcomeTokenCount)
505         public
506         isEventContract
507     {
508         balances[_for] = balances[_for].add(outcomeTokenCount);
509         totalTokens = totalTokens.add(outcomeTokenCount);
510         Issuance(_for, outcomeTokenCount);
511     }
512 
513     /// @dev Events contract revokes tokens for address. Returns success
514     /// @param _for Address of token holder
515     /// @param outcomeTokenCount Number of tokens to revoke
516     function revoke(address _for, uint outcomeTokenCount)
517         public
518         isEventContract
519     {
520         balances[_for] = balances[_for].sub(outcomeTokenCount);
521         totalTokens = totalTokens.sub(outcomeTokenCount);
522         Revocation(_for, outcomeTokenCount);
523     }
524 }
525 
526 
527 
528 /// @title Abstract oracle contract - Functions to be implemented by oracles
529 contract Oracle {
530 
531     function isOutcomeSet() public constant returns (bool);
532     function getOutcome() public constant returns (int);
533 }
534 
535 
536 
537 /// @title Event contract - Provide basic functionality required by different event types
538 /// @author Stefan George - <stefan@gnosis.pm>
539 contract Event {
540 
541     /*
542      *  Events
543      */
544     event OutcomeTokenCreation(OutcomeToken outcomeToken, uint8 index);
545     event OutcomeTokenSetIssuance(address indexed buyer, uint collateralTokenCount);
546     event OutcomeTokenSetRevocation(address indexed seller, uint outcomeTokenCount);
547     event OutcomeAssignment(int outcome);
548     event WinningsRedemption(address indexed receiver, uint winnings);
549 
550     /*
551      *  Storage
552      */
553     Token public collateralToken;
554     Oracle public oracle;
555     bool public isOutcomeSet;
556     int public outcome;
557     OutcomeToken[] public outcomeTokens;
558 
559     /*
560      *  Public functions
561      */
562     /// @dev Contract constructor validates and sets basic event properties
563     /// @param _collateralToken Tokens used as collateral in exchange for outcome tokens
564     /// @param _oracle Oracle contract used to resolve the event
565     /// @param outcomeCount Number of event outcomes
566     function Event(Token _collateralToken, Oracle _oracle, uint8 outcomeCount)
567         public
568     {
569         // Validate input
570         require(address(_collateralToken) != 0 && address(_oracle) != 0 && outcomeCount >= 2);
571         collateralToken = _collateralToken;
572         oracle = _oracle;
573         // Create an outcome token for each outcome
574         for (uint8 i = 0; i < outcomeCount; i++) {
575             OutcomeToken outcomeToken = new OutcomeToken();
576             outcomeTokens.push(outcomeToken);
577             OutcomeTokenCreation(outcomeToken, i);
578         }
579     }
580 
581     /// @dev Buys equal number of tokens of all outcomes, exchanging collateral tokens and sets of outcome tokens 1:1
582     /// @param collateralTokenCount Number of collateral tokens
583     function buyAllOutcomes(uint collateralTokenCount)
584         public
585     {
586         // Transfer collateral tokens to events contract
587         require(collateralToken.transferFrom(msg.sender, this, collateralTokenCount));
588         // Issue new outcome tokens to sender
589         for (uint8 i = 0; i < outcomeTokens.length; i++)
590             outcomeTokens[i].issue(msg.sender, collateralTokenCount);
591         OutcomeTokenSetIssuance(msg.sender, collateralTokenCount);
592     }
593 
594     /// @dev Sells equal number of tokens of all outcomes, exchanging collateral tokens and sets of outcome tokens 1:1
595     /// @param outcomeTokenCount Number of outcome tokens
596     function sellAllOutcomes(uint outcomeTokenCount)
597         public
598     {
599         // Revoke sender's outcome tokens of all outcomes
600         for (uint8 i = 0; i < outcomeTokens.length; i++)
601             outcomeTokens[i].revoke(msg.sender, outcomeTokenCount);
602         // Transfer collateral tokens to sender
603         require(collateralToken.transfer(msg.sender, outcomeTokenCount));
604         OutcomeTokenSetRevocation(msg.sender, outcomeTokenCount);
605     }
606 
607     /// @dev Sets winning event outcome
608     function setOutcome()
609         public
610     {
611         // Winning outcome is not set yet in event contract but in oracle contract
612         require(!isOutcomeSet && oracle.isOutcomeSet());
613         // Set winning outcome
614         outcome = oracle.getOutcome();
615         isOutcomeSet = true;
616         OutcomeAssignment(outcome);
617     }
618 
619     /// @dev Returns outcome count
620     /// @return Outcome count
621     function getOutcomeCount()
622         public
623         constant
624         returns (uint8)
625     {
626         return uint8(outcomeTokens.length);
627     }
628 
629     /// @dev Returns outcome tokens array
630     /// @return Outcome tokens
631     function getOutcomeTokens()
632         public
633         constant
634         returns (OutcomeToken[])
635     {
636         return outcomeTokens;
637     }
638 
639     /// @dev Returns the amount of outcome tokens held by owner
640     /// @return Outcome token distribution
641     function getOutcomeTokenDistribution(address owner)
642         public
643         constant
644         returns (uint[] outcomeTokenDistribution)
645     {
646         outcomeTokenDistribution = new uint[](outcomeTokens.length);
647         for (uint8 i = 0; i < outcomeTokenDistribution.length; i++)
648             outcomeTokenDistribution[i] = outcomeTokens[i].balanceOf(owner);
649     }
650 
651     /// @dev Calculates and returns event hash
652     /// @return Event hash
653     function getEventHash() public constant returns (bytes32);
654 
655     /// @dev Exchanges sender's winning outcome tokens for collateral tokens
656     /// @return Sender's winnings
657     function redeemWinnings() public returns (uint);
658 }
659 
660 
661 
662 /// @title Abstract market maker contract - Functions to be implemented by market maker contracts
663 contract MarketMaker {
664 
665     /*
666      *  Public functions
667      */
668     function calcCost(Market market, uint8 outcomeTokenIndex, uint outcomeTokenCount) public constant returns (uint);
669     function calcProfit(Market market, uint8 outcomeTokenIndex, uint outcomeTokenCount) public constant returns (uint);
670     function calcMarginalPrice(Market market, uint8 outcomeTokenIndex) public constant returns (uint);
671 }
672 
673 
674 
675 /// @title Abstract market contract - Functions to be implemented by market contracts
676 contract Market {
677 
678     /*
679      *  Events
680      */
681     event MarketFunding(uint funding);
682     event MarketClosing();
683     event FeeWithdrawal(uint fees);
684     event OutcomeTokenPurchase(address indexed buyer, uint8 outcomeTokenIndex, uint outcomeTokenCount, uint outcomeTokenCost, uint marketFees);
685     event OutcomeTokenSale(address indexed seller, uint8 outcomeTokenIndex, uint outcomeTokenCount, uint outcomeTokenProfit, uint marketFees);
686     event OutcomeTokenShortSale(address indexed buyer, uint8 outcomeTokenIndex, uint outcomeTokenCount, uint cost);
687 
688     /*
689      *  Storage
690      */
691     address public creator;
692     uint public createdAtBlock;
693     Event public eventContract;
694     MarketMaker public marketMaker;
695     uint24 public fee;
696     uint public funding;
697     int[] public netOutcomeTokensSold;
698     Stages public stage;
699 
700     enum Stages {
701         MarketCreated,
702         MarketFunded,
703         MarketClosed
704     }
705 
706     /*
707      *  Public functions
708      */
709     function fund(uint _funding) public;
710     function close() public;
711     function withdrawFees() public returns (uint);
712     function buy(uint8 outcomeTokenIndex, uint outcomeTokenCount, uint maxCost) public returns (uint);
713     function sell(uint8 outcomeTokenIndex, uint outcomeTokenCount, uint minProfit) public returns (uint);
714     function shortSell(uint8 outcomeTokenIndex, uint outcomeTokenCount, uint minProfit) public returns (uint);
715     function calcMarketFee(uint outcomeTokenCost) public constant returns (uint);
716 }
717 
718 
719 /// @title Market factory contract - Allows to create market contracts
720 /// @author Stefan George - <stefan@gnosis.pm>
721 contract StandardMarket is Market {
722     using Math for *;
723 
724     /*
725      *  Constants
726      */
727     uint24 public constant FEE_RANGE = 1000000; // 100%
728 
729     /*
730      *  Modifiers
731      */
732     modifier isCreator() {
733         // Only creator is allowed to proceed
734         require(msg.sender == creator);
735         _;
736     }
737 
738     modifier atStage(Stages _stage) {
739         // Contract has to be in given stage
740         require(stage == _stage);
741         _;
742     }
743 
744     /*
745      *  Public functions
746      */
747     /// @dev Constructor validates and sets market properties
748     /// @param _creator Market creator
749     /// @param _eventContract Event contract
750     /// @param _marketMaker Market maker contract
751     /// @param _fee Market fee
752     function StandardMarket(address _creator, Event _eventContract, MarketMaker _marketMaker, uint24 _fee)
753         public
754     {
755         // Validate inputs
756         require(address(_eventContract) != 0 && address(_marketMaker) != 0 && _fee < FEE_RANGE);
757         creator = _creator;
758         createdAtBlock = block.number;
759         eventContract = _eventContract;
760         netOutcomeTokensSold = new int[](eventContract.getOutcomeCount());
761         fee = _fee;
762         marketMaker = _marketMaker;
763         stage = Stages.MarketCreated;
764     }
765 
766     /// @dev Allows to fund the market with collateral tokens converting them into outcome tokens
767     /// @param _funding Funding amount
768     function fund(uint _funding)
769         public
770         isCreator
771         atStage(Stages.MarketCreated)
772     {
773         // Request collateral tokens and allow event contract to transfer them to buy all outcomes
774         require(   eventContract.collateralToken().transferFrom(msg.sender, this, _funding)
775                 && eventContract.collateralToken().approve(eventContract, _funding));
776         eventContract.buyAllOutcomes(_funding);
777         funding = _funding;
778         stage = Stages.MarketFunded;
779         MarketFunding(funding);
780     }
781 
782     /// @dev Allows market creator to close the markets by transferring all remaining outcome tokens to the creator
783     function close()
784         public
785         isCreator
786         atStage(Stages.MarketFunded)
787     {
788         uint8 outcomeCount = eventContract.getOutcomeCount();
789         for (uint8 i = 0; i < outcomeCount; i++)
790             require(eventContract.outcomeTokens(i).transfer(creator, eventContract.outcomeTokens(i).balanceOf(this)));
791         stage = Stages.MarketClosed;
792         MarketClosing();
793     }
794 
795     /// @dev Allows market creator to withdraw fees generated by trades
796     /// @return Fee amount
797     function withdrawFees()
798         public
799         isCreator
800         returns (uint fees)
801     {
802         fees = eventContract.collateralToken().balanceOf(this);
803         // Transfer fees
804         require(eventContract.collateralToken().transfer(creator, fees));
805         FeeWithdrawal(fees);
806     }
807 
808     /// @dev Allows to buy outcome tokens from market maker
809     /// @param outcomeTokenIndex Index of the outcome token to buy
810     /// @param outcomeTokenCount Amount of outcome tokens to buy
811     /// @param maxCost The maximum cost in collateral tokens to pay for outcome tokens
812     /// @return Cost in collateral tokens
813     function buy(uint8 outcomeTokenIndex, uint outcomeTokenCount, uint maxCost)
814         public
815         atStage(Stages.MarketFunded)
816         returns (uint cost)
817     {
818         // Calculate cost to buy outcome tokens
819         uint outcomeTokenCost = marketMaker.calcCost(this, outcomeTokenIndex, outcomeTokenCount);
820         // Calculate fees charged by market
821         uint fees = calcMarketFee(outcomeTokenCost);
822         cost = outcomeTokenCost.add(fees);
823         // Check cost doesn't exceed max cost
824         require(cost > 0 && cost <= maxCost);
825         // Transfer tokens to markets contract and buy all outcomes
826         require(   eventContract.collateralToken().transferFrom(msg.sender, this, cost)
827                 && eventContract.collateralToken().approve(eventContract, outcomeTokenCost));
828         // Buy all outcomes
829         eventContract.buyAllOutcomes(outcomeTokenCost);
830         // Transfer outcome tokens to buyer
831         require(eventContract.outcomeTokens(outcomeTokenIndex).transfer(msg.sender, outcomeTokenCount));
832         // Add outcome token count to market maker net balance
833         require(int(outcomeTokenCount) >= 0);
834         netOutcomeTokensSold[outcomeTokenIndex] = netOutcomeTokensSold[outcomeTokenIndex].add(int(outcomeTokenCount));
835         OutcomeTokenPurchase(msg.sender, outcomeTokenIndex, outcomeTokenCount, outcomeTokenCost, fees);
836     }
837 
838     /// @dev Allows to sell outcome tokens to market maker
839     /// @param outcomeTokenIndex Index of the outcome token to sell
840     /// @param outcomeTokenCount Amount of outcome tokens to sell
841     /// @param minProfit The minimum profit in collateral tokens to earn for outcome tokens
842     /// @return Profit in collateral tokens
843     function sell(uint8 outcomeTokenIndex, uint outcomeTokenCount, uint minProfit)
844         public
845         atStage(Stages.MarketFunded)
846         returns (uint profit)
847     {
848         // Calculate profit for selling outcome tokens
849         uint outcomeTokenProfit = marketMaker.calcProfit(this, outcomeTokenIndex, outcomeTokenCount);
850         // Calculate fee charged by market
851         uint fees = calcMarketFee(outcomeTokenProfit);
852         profit = outcomeTokenProfit.sub(fees);
853         // Check profit is not too low
854         require(profit > 0 && profit >= minProfit);
855         // Transfer outcome tokens to markets contract to sell all outcomes
856         require(eventContract.outcomeTokens(outcomeTokenIndex).transferFrom(msg.sender, this, outcomeTokenCount));
857         // Sell all outcomes
858         eventContract.sellAllOutcomes(outcomeTokenProfit);
859         // Transfer profit to seller
860         require(eventContract.collateralToken().transfer(msg.sender, profit));
861         // Subtract outcome token count from market maker net balance
862         require(int(outcomeTokenCount) >= 0);
863         netOutcomeTokensSold[outcomeTokenIndex] = netOutcomeTokensSold[outcomeTokenIndex].sub(int(outcomeTokenCount));
864         OutcomeTokenSale(msg.sender, outcomeTokenIndex, outcomeTokenCount, outcomeTokenProfit, fees);
865     }
866 
867     /// @dev Buys all outcomes, then sells all shares of selected outcome which were bought, keeping
868     ///      shares of all other outcome tokens.
869     /// @param outcomeTokenIndex Index of the outcome token to short sell
870     /// @param outcomeTokenCount Amount of outcome tokens to short sell
871     /// @param minProfit The minimum profit in collateral tokens to earn for short sold outcome tokens
872     /// @return Cost to short sell outcome in collateral tokens
873     function shortSell(uint8 outcomeTokenIndex, uint outcomeTokenCount, uint minProfit)
874         public
875         returns (uint cost)
876     {
877         // Buy all outcomes
878         require(   eventContract.collateralToken().transferFrom(msg.sender, this, outcomeTokenCount)
879                 && eventContract.collateralToken().approve(eventContract, outcomeTokenCount));
880         eventContract.buyAllOutcomes(outcomeTokenCount);
881         // Short sell selected outcome
882         eventContract.outcomeTokens(outcomeTokenIndex).approve(this, outcomeTokenCount);
883         uint profit = this.sell(outcomeTokenIndex, outcomeTokenCount, minProfit);
884         cost = outcomeTokenCount - profit;
885         // Transfer outcome tokens to buyer
886         uint8 outcomeCount = eventContract.getOutcomeCount();
887         for (uint8 i = 0; i < outcomeCount; i++)
888             if (i != outcomeTokenIndex)
889                 require(eventContract.outcomeTokens(i).transfer(msg.sender, outcomeTokenCount));
890         // Send change back to buyer
891         require(eventContract.collateralToken().transfer(msg.sender, profit));
892         OutcomeTokenShortSale(msg.sender, outcomeTokenIndex, outcomeTokenCount, cost);
893     }
894 
895     /// @dev Calculates fee to be paid to market maker
896     /// @param outcomeTokenCost Cost for buying outcome tokens
897     /// @return Fee for trade
898     function calcMarketFee(uint outcomeTokenCost)
899         public
900         constant
901         returns (uint)
902     {
903         return outcomeTokenCost * fee / FEE_RANGE;
904     }
905 }
906 
907 
908 
909 /// @title Market factory contract - Allows to create market contracts
910 /// @author Stefan George - <stefan@gnosis.pm>
911 contract StandardMarketFactory {
912 
913     /*
914      *  Events
915      */
916     event StandardMarketCreation(address indexed creator, Market market, Event eventContract, MarketMaker marketMaker, uint24 fee);
917 
918     /*
919      *  Public functions
920      */
921     /// @dev Creates a new market contract
922     /// @param eventContract Event contract
923     /// @param marketMaker Market maker contract
924     /// @param fee Market fee
925     /// @return Market contract
926     function createMarket(Event eventContract, MarketMaker marketMaker, uint24 fee)
927         public
928         returns (StandardMarket market)
929     {
930         market = new StandardMarket(msg.sender, eventContract, marketMaker, fee);
931         StandardMarketCreation(msg.sender, market, eventContract, marketMaker, fee);
932     }
933 }