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
342 
343 
344 /// @title Abstract token contract - Functions to be implemented by token contracts
345 contract Token {
346 
347     /*
348      *  Events
349      */
350     event Transfer(address indexed from, address indexed to, uint value);
351     event Approval(address indexed owner, address indexed spender, uint value);
352 
353     /*
354      *  Public functions
355      */
356     function transfer(address to, uint value) public returns (bool);
357     function transferFrom(address from, address to, uint value) public returns (bool);
358     function approve(address spender, uint value) public returns (bool);
359     function balanceOf(address owner) public constant returns (uint);
360     function allowance(address owner, address spender) public constant returns (uint);
361     function totalSupply() public constant returns (uint);
362 }
363 
364 
365 
366 /// @title Standard token contract with overflow protection
367 contract StandardToken is Token {
368     using Math for *;
369 
370     /*
371      *  Storage
372      */
373     mapping (address => uint) balances;
374     mapping (address => mapping (address => uint)) allowances;
375     uint totalTokens;
376 
377     /*
378      *  Public functions
379      */
380     /// @dev Transfers sender's tokens to a given address. Returns success
381     /// @param to Address of token receiver
382     /// @param value Number of tokens to transfer
383     /// @return Was transfer successful?
384     function transfer(address to, uint value)
385         public
386         returns (bool)
387     {
388         if (   !balances[msg.sender].safeToSub(value)
389             || !balances[to].safeToAdd(value))
390             return false;
391         balances[msg.sender] -= value;
392         balances[to] += value;
393         Transfer(msg.sender, to, value);
394         return true;
395     }
396 
397     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
398     /// @param from Address from where tokens are withdrawn
399     /// @param to Address to where tokens are sent
400     /// @param value Number of tokens to transfer
401     /// @return Was transfer successful?
402     function transferFrom(address from, address to, uint value)
403         public
404         returns (bool)
405     {
406         if (   !balances[from].safeToSub(value)
407             || !allowances[from][msg.sender].safeToSub(value)
408             || !balances[to].safeToAdd(value))
409             return false;
410         balances[from] -= value;
411         allowances[from][msg.sender] -= value;
412         balances[to] += value;
413         Transfer(from, to, value);
414         return true;
415     }
416 
417     /// @dev Sets approved amount of tokens for spender. Returns success
418     /// @param spender Address of allowed account
419     /// @param value Number of approved tokens
420     /// @return Was approval successful?
421     function approve(address spender, uint value)
422         public
423         returns (bool)
424     {
425         allowances[msg.sender][spender] = value;
426         Approval(msg.sender, spender, value);
427         return true;
428     }
429 
430     /// @dev Returns number of allowed tokens for given address
431     /// @param owner Address of token owner
432     /// @param spender Address of token spender
433     /// @return Remaining allowance for spender
434     function allowance(address owner, address spender)
435         public
436         constant
437         returns (uint)
438     {
439         return allowances[owner][spender];
440     }
441 
442     /// @dev Returns number of tokens owned by given address
443     /// @param owner Address of token owner
444     /// @return Balance of owner
445     function balanceOf(address owner)
446         public
447         constant
448         returns (uint)
449     {
450         return balances[owner];
451     }
452 
453     /// @dev Returns total supply of tokens
454     /// @return Total supply
455     function totalSupply()
456         public
457         constant
458         returns (uint)
459     {
460         return totalTokens;
461     }
462 }
463 
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
662 /// @title Categorical event contract - Categorical events resolve to an outcome from a set of outcomes
663 /// @author Stefan George - <stefan@gnosis.pm>
664 contract CategoricalEvent is Event {
665 
666     /*
667      *  Public functions
668      */
669     /// @dev Contract constructor validates and sets basic event properties
670     /// @param _collateralToken Tokens used as collateral in exchange for outcome tokens
671     /// @param _oracle Oracle contract used to resolve the event
672     /// @param outcomeCount Number of event outcomes
673     function CategoricalEvent(
674         Token _collateralToken,
675         Oracle _oracle,
676         uint8 outcomeCount
677     )
678         public
679         Event(_collateralToken, _oracle, outcomeCount)
680     {
681 
682     }
683 
684     /// @dev Exchanges sender's winning outcome tokens for collateral tokens
685     /// @return Sender's winnings
686     function redeemWinnings()
687         public
688         returns (uint winnings)
689     {
690         // Winning outcome has to be set
691         require(isOutcomeSet);
692         // Calculate winnings
693         winnings = outcomeTokens[uint(outcome)].balanceOf(msg.sender);
694         // Revoke tokens from winning outcome
695         outcomeTokens[uint(outcome)].revoke(msg.sender, winnings);
696         // Payout winnings
697         require(collateralToken.transfer(msg.sender, winnings));
698         WinningsRedemption(msg.sender, winnings);
699     }
700 
701     /// @dev Calculates and returns event hash
702     /// @return Event hash
703     function getEventHash()
704         public
705         constant
706         returns (bytes32)
707     {
708         return keccak256(collateralToken, oracle, outcomeTokens.length);
709     }
710 }
711 
712 
713 
714 /// @title Scalar event contract - Scalar events resolve to a number within a range
715 /// @author Stefan George - <stefan@gnosis.pm>
716 contract ScalarEvent is Event {
717     using Math for *;
718 
719     /*
720      *  Constants
721      */
722     uint8 public constant SHORT = 0;
723     uint8 public constant LONG = 1;
724     uint24 public constant OUTCOME_RANGE = 1000000;
725 
726     /*
727      *  Storage
728      */
729     int public lowerBound;
730     int public upperBound;
731 
732     /*
733      *  Public functions
734      */
735     /// @dev Contract constructor validates and sets basic event properties
736     /// @param _collateralToken Tokens used as collateral in exchange for outcome tokens
737     /// @param _oracle Oracle contract used to resolve the event
738     /// @param _lowerBound Lower bound for event outcome
739     /// @param _upperBound Lower bound for event outcome
740     function ScalarEvent(
741         Token _collateralToken,
742         Oracle _oracle,
743         int _lowerBound,
744         int _upperBound
745     )
746         public
747         Event(_collateralToken, _oracle, 2)
748     {
749         // Validate bounds
750         require(_upperBound > _lowerBound);
751         lowerBound = _lowerBound;
752         upperBound = _upperBound;
753     }
754 
755     /// @dev Exchanges sender's winning outcome tokens for collateral tokens
756     /// @return Sender's winnings
757     function redeemWinnings()
758         public
759         returns (uint winnings)
760     {
761         // Winning outcome has to be set
762         require(isOutcomeSet);
763         // Calculate winnings
764         uint24 convertedWinningOutcome;
765         // Outcome is lower than defined lower bound
766         if (outcome < lowerBound)
767             convertedWinningOutcome = 0;
768         // Outcome is higher than defined upper bound
769         else if (outcome > upperBound)
770             convertedWinningOutcome = OUTCOME_RANGE;
771         // Map outcome to outcome range
772         else
773             convertedWinningOutcome = uint24(OUTCOME_RANGE * (outcome - lowerBound) / (upperBound - lowerBound));
774         uint factorShort = OUTCOME_RANGE - convertedWinningOutcome;
775         uint factorLong = OUTCOME_RANGE - factorShort;
776         uint shortOutcomeTokenCount = outcomeTokens[SHORT].balanceOf(msg.sender);
777         uint longOutcomeTokenCount = outcomeTokens[LONG].balanceOf(msg.sender);
778         winnings = shortOutcomeTokenCount.mul(factorShort).add(longOutcomeTokenCount.mul(factorLong)) / OUTCOME_RANGE;
779         // Revoke all outcome tokens
780         outcomeTokens[SHORT].revoke(msg.sender, shortOutcomeTokenCount);
781         outcomeTokens[LONG].revoke(msg.sender, longOutcomeTokenCount);
782         // Payout winnings to sender
783         require(collateralToken.transfer(msg.sender, winnings));
784         WinningsRedemption(msg.sender, winnings);
785     }
786 
787     /// @dev Calculates and returns event hash
788     /// @return Event hash
789     function getEventHash()
790         public
791         constant
792         returns (bytes32)
793     {
794         return keccak256(collateralToken, oracle, lowerBound, upperBound);
795     }
796 }
797 
798 
799 
800 /// @title Event factory contract - Allows creation of categorical and scalar events
801 /// @author Stefan George - <stefan@gnosis.pm>
802 contract EventFactory {
803 
804     /*
805      *  Events
806      */
807     event CategoricalEventCreation(address indexed creator, CategoricalEvent categoricalEvent, Token collateralToken, Oracle oracle, uint8 outcomeCount);
808     event ScalarEventCreation(address indexed creator, ScalarEvent scalarEvent, Token collateralToken, Oracle oracle, int lowerBound, int upperBound);
809 
810     /*
811      *  Storage
812      */
813     mapping (bytes32 => CategoricalEvent) public categoricalEvents;
814     mapping (bytes32 => ScalarEvent) public scalarEvents;
815 
816     /*
817      *  Public functions
818      */
819     /// @dev Creates a new categorical event and adds it to the event mapping
820     /// @param collateralToken Tokens used as collateral in exchange for outcome tokens
821     /// @param oracle Oracle contract used to resolve the event
822     /// @param outcomeCount Number of event outcomes
823     /// @return Event contract
824     function createCategoricalEvent(
825         Token collateralToken,
826         Oracle oracle,
827         uint8 outcomeCount
828     )
829         public
830         returns (CategoricalEvent eventContract)
831     {
832         bytes32 eventHash = keccak256(collateralToken, oracle, outcomeCount);
833         // Event should not exist yet
834         require(address(categoricalEvents[eventHash]) == 0);
835         // Create event
836         eventContract = new CategoricalEvent(
837             collateralToken,
838             oracle,
839             outcomeCount
840         );
841         categoricalEvents[eventHash] = eventContract;
842         CategoricalEventCreation(msg.sender, eventContract, collateralToken, oracle, outcomeCount);
843     }
844 
845     /// @dev Creates a new scalar event and adds it to the event mapping
846     /// @param collateralToken Tokens used as collateral in exchange for outcome tokens
847     /// @param oracle Oracle contract used to resolve the event
848     /// @param lowerBound Lower bound for event outcome
849     /// @param upperBound Lower bound for event outcome
850     /// @return Event contract
851     function createScalarEvent(
852         Token collateralToken,
853         Oracle oracle,
854         int lowerBound,
855         int upperBound
856     )
857         public
858         returns (ScalarEvent eventContract)
859     {
860         bytes32 eventHash = keccak256(collateralToken, oracle, lowerBound, upperBound);
861         // Event should not exist yet
862         require(address(scalarEvents[eventHash]) == 0);
863         // Create event
864         eventContract = new ScalarEvent(
865             collateralToken,
866             oracle,
867             lowerBound,
868             upperBound
869         );
870         scalarEvents[eventHash] = eventContract;
871         ScalarEventCreation(msg.sender, eventContract, collateralToken, oracle, lowerBound, upperBound);
872     }
873 }