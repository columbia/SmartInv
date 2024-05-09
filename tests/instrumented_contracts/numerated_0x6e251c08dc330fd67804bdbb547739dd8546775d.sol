1 /**
2  *Submitted for verification at Etherscan.io on 2018-06-12
3 */
4 
5 pragma solidity 0.4.18;
6 
7 // File: contracts/ERC20Interface.sol
8 
9 // https://github.com/ethereum/EIPs/issues/20
10 interface ERC20 {
11     function totalSupply() public view returns (uint supply);
12     function balanceOf(address _owner) public view returns (uint balance);
13     function transfer(address _to, uint _value) public returns (bool success);
14     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
15     function approve(address _spender, uint _value) public returns (bool success);
16     function allowance(address _owner, address _spender) public view returns (uint remaining);
17     function decimals() public view returns(uint digits);
18     event Approval(address indexed _owner, address indexed _spender, uint _value);
19 }
20 
21 // File: contracts/ConversionRatesInterface.sol
22 
23 interface ConversionRatesInterface {
24 
25     function recordImbalance(
26         ERC20 token,
27         int buyAmount,
28         uint rateUpdateBlock,
29         uint currentBlock
30     )
31         public;
32 
33     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
34 }
35 
36 // File: contracts/LiquidityFormula.sol
37 
38 contract UtilMath {
39     uint public constant BIG_NUMBER = (uint(1)<<uint(200));
40 
41     function checkMultOverflow(uint x, uint y) public pure returns(bool) {
42         if (y == 0) return false;
43         return (((x*y) / y) != x);
44     }
45 
46     function compactFraction(uint p, uint q, uint precision) public pure returns (uint, uint) {
47         if (q < precision * precision) return (p, q);
48         return compactFraction(p/precision, q/precision, precision);
49     }
50 
51     /* solhint-disable code-complexity */
52     function exp(uint p, uint q, uint precision) public pure returns (uint) {
53         uint n = 0;
54         uint nFact = 1;
55         uint currentP = 1;
56         uint currentQ = 1;
57 
58         uint sum = 0;
59         uint prevSum = 0;
60 
61         while (true) {
62             if (checkMultOverflow(currentP, precision)) return sum;
63             if (checkMultOverflow(currentQ, nFact)) return sum;
64 
65             sum += (currentP * precision) / (currentQ * nFact);
66 
67             if (sum == prevSum) return sum;
68             prevSum = sum;
69 
70             n++;
71 
72             if (checkMultOverflow(currentP, p)) return sum;
73             if (checkMultOverflow(currentQ, q)) return sum;
74             if (checkMultOverflow(nFact, n)) return sum;
75 
76             currentP *= p;
77             currentQ *= q;
78             nFact *= n;
79 
80             (currentP, currentQ) = compactFraction(currentP, currentQ, precision);
81         }
82     }
83     /* solhint-enable code-complexity */
84 
85     function countLeadingZeros(uint p, uint q) public pure returns (uint) {
86         uint denomator = (uint(1)<<255);
87         for (int i = 255; i >= 0; i--) {
88             if ((q*denomator)/denomator != q) {
89                 // overflow
90                 denomator = denomator/2;
91                 continue;
92             }
93             if (p/(q*denomator) > 0) return uint(i);
94             denomator = denomator/2;
95         }
96 
97         return uint(-1);
98     }
99 
100     // log2 for a number that it in [1,2)
101     function log2ForSmallNumber(uint x, uint numPrecisionBits) public pure returns (uint) {
102         uint res = 0;
103         uint one = (uint(1)<<numPrecisionBits);
104         uint two = 2 * one;
105         uint addition = one;
106 
107         require((x >= one) && (x <= two));
108         require(numPrecisionBits < 125);
109 
110         for (uint i = numPrecisionBits; i > 0; i--) {
111             x = (x*x) / one;
112             addition = addition/2;
113             if (x >= two) {
114                 x = x/2;
115                 res += addition;
116             }
117         }
118 
119         return res;
120     }
121 
122     function logBase2 (uint p, uint q, uint numPrecisionBits) public pure returns (uint) {
123         uint n = 0;
124         uint precision = (uint(1)<<numPrecisionBits);
125 
126         if (p > q) {
127             n = countLeadingZeros(p, q);
128         }
129 
130         require(!checkMultOverflow(p, precision));
131         require(!checkMultOverflow(n, precision));
132         require(!checkMultOverflow(uint(1)<<n, q));
133 
134         uint y = p * precision / (q * (uint(1)<<n));
135         uint log2Small = log2ForSmallNumber(y, numPrecisionBits);
136 
137         require(n*precision <= BIG_NUMBER);
138         require(log2Small <= BIG_NUMBER);
139 
140         return n * precision + log2Small;
141     }
142 
143     function ln(uint p, uint q, uint numPrecisionBits) public pure returns (uint) {
144         uint ln2Numerator   = 6931471805599453094172;
145         uint ln2Denomerator = 10000000000000000000000;
146 
147         uint log2x = logBase2(p, q, numPrecisionBits);
148 
149         require(!checkMultOverflow(ln2Numerator, log2x));
150 
151         return ln2Numerator * log2x / ln2Denomerator;
152     }
153 }
154 
155 
156 contract LiquidityFormula is UtilMath {
157     function pE(uint r, uint pMIn, uint e, uint precision) public pure returns (uint) {
158         uint expRE = exp(r*e, precision*precision, precision);
159         require(!checkMultOverflow(expRE, pMIn));
160         return pMIn*expRE / precision;
161     }
162 
163     function deltaTFunc(uint r, uint pMIn, uint e, uint deltaE, uint precision) public pure returns (uint) {
164         uint pe = pE(r, pMIn, e, precision);
165         uint rpe = r * pe;
166         uint erdeltaE = exp(r*deltaE, precision*precision, precision);
167 
168         require(erdeltaE >= precision);
169         require(!checkMultOverflow(erdeltaE - precision, precision));
170         require(!checkMultOverflow((erdeltaE - precision)*precision, precision));
171         require(!checkMultOverflow((erdeltaE - precision)*precision*precision, precision));
172         require(!checkMultOverflow(rpe, erdeltaE));
173         require(!checkMultOverflow(r, pe));
174 
175         return (erdeltaE - precision) * precision * precision * precision / (rpe*erdeltaE);
176     }
177 
178     function deltaEFunc(uint r, uint pMIn, uint e, uint deltaT, uint precision, uint numPrecisionBits)
179         public pure
180         returns (uint)
181     {
182         uint pe = pE(r, pMIn, e, precision);
183         uint rpe = r * pe;
184         uint lnPart = ln(precision*precision + rpe*deltaT/precision, precision*precision, numPrecisionBits);
185 
186         require(!checkMultOverflow(r, pe));
187         require(!checkMultOverflow(precision, precision));
188         require(!checkMultOverflow(rpe, deltaT));
189         require(!checkMultOverflow(lnPart, precision));
190 
191         return lnPart * precision / r;
192     }
193 }
194 
195 // File: contracts/Utils.sol
196 
197 /// @title Kyber constants contract
198 contract Utils {
199 
200     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
201     uint  constant internal PRECISION = (10**18);
202     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
203     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
204     uint  constant internal MAX_DECIMALS = 18;
205     uint  constant internal ETH_DECIMALS = 18;
206     mapping(address=>uint) internal decimals;
207 
208     function setDecimals(ERC20 token) internal {
209         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
210         else decimals[token] = token.decimals();
211     }
212 
213     function getDecimals(ERC20 token) internal view returns(uint) {
214         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
215         uint tokenDecimals = decimals[token];
216         // technically, there might be token with decimals 0
217         // moreover, very possible that old tokens have decimals 0
218         // these tokens will just have higher gas fees.
219         if(tokenDecimals == 0) return token.decimals();
220 
221         return tokenDecimals;
222     }
223 
224     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
225         require(srcQty <= MAX_QTY);
226         require(rate <= MAX_RATE);
227 
228         if (dstDecimals >= srcDecimals) {
229             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
230             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
231         } else {
232             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
233             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
234         }
235     }
236 
237     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
238         require(dstQty <= MAX_QTY);
239         require(rate <= MAX_RATE);
240         
241         //source quantity is rounded up. to avoid dest quantity being too low.
242         uint numerator;
243         uint denominator;
244         if (srcDecimals >= dstDecimals) {
245             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
246             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
247             denominator = rate;
248         } else {
249             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
250             numerator = (PRECISION * dstQty);
251             denominator = (rate * (10**(dstDecimals - srcDecimals)));
252         }
253         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
254     }
255 }
256 
257 // File: contracts/PermissionGroups.sol
258 
259 contract PermissionGroups {
260 
261     address public admin;
262     address public pendingAdmin;
263     mapping(address=>bool) internal operators;
264     mapping(address=>bool) internal alerters;
265     address[] internal operatorsGroup;
266     address[] internal alertersGroup;
267     uint constant internal MAX_GROUP_SIZE = 50;
268 
269     function PermissionGroups() public {
270         admin = msg.sender;
271     }
272 
273     modifier onlyAdmin() {
274         require(msg.sender == admin);
275         _;
276     }
277 
278     modifier onlyOperator() {
279         require(operators[msg.sender]);
280         _;
281     }
282 
283     modifier onlyAlerter() {
284         require(alerters[msg.sender]);
285         _;
286     }
287 
288     function getOperators () external view returns(address[]) {
289         return operatorsGroup;
290     }
291 
292     function getAlerters () external view returns(address[]) {
293         return alertersGroup;
294     }
295 
296     event TransferAdminPending(address pendingAdmin);
297 
298     /**
299      * @dev Allows the current admin to set the pendingAdmin address.
300      * @param newAdmin The address to transfer ownership to.
301      */
302     function transferAdmin(address newAdmin) public onlyAdmin {
303         require(newAdmin != address(0));
304         TransferAdminPending(pendingAdmin);
305         pendingAdmin = newAdmin;
306     }
307 
308     /**
309      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
310      * @param newAdmin The address to transfer ownership to.
311      */
312     function transferAdminQuickly(address newAdmin) public onlyAdmin {
313         require(newAdmin != address(0));
314         TransferAdminPending(newAdmin);
315         AdminClaimed(newAdmin, admin);
316         admin = newAdmin;
317     }
318 
319     event AdminClaimed( address newAdmin, address previousAdmin);
320 
321     /**
322      * @dev Allows the pendingAdmin address to finalize the change admin process.
323      */
324     function claimAdmin() public {
325         require(pendingAdmin == msg.sender);
326         AdminClaimed(pendingAdmin, admin);
327         admin = pendingAdmin;
328         pendingAdmin = address(0);
329     }
330 
331     event AlerterAdded (address newAlerter, bool isAdd);
332 
333     function addAlerter(address newAlerter) public onlyAdmin {
334         require(!alerters[newAlerter]); // prevent duplicates.
335         require(alertersGroup.length < MAX_GROUP_SIZE);
336 
337         AlerterAdded(newAlerter, true);
338         alerters[newAlerter] = true;
339         alertersGroup.push(newAlerter);
340     }
341 
342     function removeAlerter (address alerter) public onlyAdmin {
343         require(alerters[alerter]);
344         alerters[alerter] = false;
345 
346         for (uint i = 0; i < alertersGroup.length; ++i) {
347             if (alertersGroup[i] == alerter) {
348                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
349                 alertersGroup.length--;
350                 AlerterAdded(alerter, false);
351                 break;
352             }
353         }
354     }
355 
356     event OperatorAdded(address newOperator, bool isAdd);
357 
358     function addOperator(address newOperator) public onlyAdmin {
359         require(!operators[newOperator]); // prevent duplicates.
360         require(operatorsGroup.length < MAX_GROUP_SIZE);
361 
362         OperatorAdded(newOperator, true);
363         operators[newOperator] = true;
364         operatorsGroup.push(newOperator);
365     }
366 
367     function removeOperator (address operator) public onlyAdmin {
368         require(operators[operator]);
369         operators[operator] = false;
370 
371         for (uint i = 0; i < operatorsGroup.length; ++i) {
372             if (operatorsGroup[i] == operator) {
373                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
374                 operatorsGroup.length -= 1;
375                 OperatorAdded(operator, false);
376                 break;
377             }
378         }
379     }
380 }
381 
382 // File: contracts/Withdrawable.sol
383 
384 /**
385  * @title Contracts that should be able to recover tokens or ethers
386  * @author Ilan Doron
387  * @dev This allows to recover any tokens or Ethers received in a contract.
388  * This will prevent any accidental loss of tokens.
389  */
390 contract Withdrawable is PermissionGroups {
391 
392     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
393 
394     /**
395      * @dev Withdraw all ERC20 compatible tokens
396      * @param token ERC20 The address of the token contract
397      */
398     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
399         require(token.transfer(sendTo, amount));
400         TokenWithdraw(token, amount, sendTo);
401     }
402 
403     event EtherWithdraw(uint amount, address sendTo);
404 
405     /**
406      * @dev Withdraw Ethers
407      */
408     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
409         sendTo.transfer(amount);
410         EtherWithdraw(amount, sendTo);
411     }
412 }
413 
414 // File: contracts/LiquidityConversionRates.sol
415 
416 contract LiquidityConversionRates is ConversionRatesInterface, LiquidityFormula, Withdrawable, Utils {
417     ERC20 public token;
418     address public reserveContract;
419 
420     uint public numFpBits;
421     uint public formulaPrecision;
422 
423     uint public rInFp;
424     uint public pMinInFp;
425 
426     uint public maxEthCapBuyInFp;
427     uint public maxEthCapSellInFp;
428     uint public maxQtyInFp;
429 
430     uint public feeInBps;
431     uint public collectedFeesInTwei = 0;
432 
433     uint public maxBuyRateInPrecision;
434     uint public minBuyRateInPrecision;
435     uint public maxSellRateInPrecision;
436     uint public minSellRateInPrecision;
437 
438     function LiquidityConversionRates(address _admin, ERC20 _token) public {
439         transferAdminQuickly(_admin);
440         token = _token;
441         setDecimals(token);
442         require(getDecimals(token) <= MAX_DECIMALS);
443     }
444 
445     event ReserveAddressSet(address reserve);
446 
447     function setReserveAddress(address reserve) public onlyAdmin {
448         reserveContract = reserve;
449         ReserveAddressSet(reserve);
450     }
451 
452     event LiquidityParamsSet(
453         uint rInFp,
454         uint pMinInFp,
455         uint numFpBits,
456         uint maxCapBuyInFp,
457         uint maxEthCapSellInFp,
458         uint feeInBps,
459         uint formulaPrecision,
460         uint maxQtyInFp,
461         uint maxBuyRateInPrecision,
462         uint minBuyRateInPrecision,
463         uint maxSellRateInPrecision,
464         uint minSellRateInPrecision
465     );
466 
467     function setLiquidityParams(
468         uint _rInFp,
469         uint _pMinInFp,
470         uint _numFpBits,
471         uint _maxCapBuyInWei,
472         uint _maxCapSellInWei,
473         uint _feeInBps,
474         uint _maxTokenToEthRateInPrecision,
475         uint _minTokenToEthRateInPrecision
476     ) public onlyAdmin {
477 
478         require(_numFpBits < 256);
479         require(formulaPrecision <= MAX_QTY);
480         require(_feeInBps < 10000);
481         require(_minTokenToEthRateInPrecision < _maxTokenToEthRateInPrecision);
482 
483         rInFp = _rInFp;
484         pMinInFp = _pMinInFp;
485         formulaPrecision = uint(1)<<_numFpBits;
486         maxQtyInFp = fromWeiToFp(MAX_QTY);
487         numFpBits = _numFpBits;
488         maxEthCapBuyInFp = fromWeiToFp(_maxCapBuyInWei);
489         maxEthCapSellInFp = fromWeiToFp(_maxCapSellInWei);
490         feeInBps = _feeInBps;
491         maxBuyRateInPrecision = PRECISION * PRECISION / _minTokenToEthRateInPrecision;
492         minBuyRateInPrecision = PRECISION * PRECISION / _maxTokenToEthRateInPrecision;
493         maxSellRateInPrecision = _maxTokenToEthRateInPrecision;
494         minSellRateInPrecision = _minTokenToEthRateInPrecision;
495 
496         LiquidityParamsSet(
497             rInFp,
498             pMinInFp,
499             numFpBits,
500             maxEthCapBuyInFp,
501             maxEthCapSellInFp,
502             feeInBps,
503             formulaPrecision,
504             maxQtyInFp,
505             maxBuyRateInPrecision,
506             minBuyRateInPrecision,
507             maxSellRateInPrecision,
508             minSellRateInPrecision
509         );
510     }
511 
512     function recordImbalance(
513         ERC20 conversionToken,
514         int buyAmountInTwei,
515         uint rateUpdateBlock,
516         uint currentBlock
517     )
518         public
519     {
520         conversionToken;
521         rateUpdateBlock;
522         currentBlock;
523 
524         require(msg.sender == reserveContract);
525         if (buyAmountInTwei > 0) {
526             // Buy case
527             collectedFeesInTwei += calcCollectedFee(abs(buyAmountInTwei));
528         } else {
529             // Sell case
530             collectedFeesInTwei += abs(buyAmountInTwei) * feeInBps / 10000;
531         }
532     }
533 
534     event CollectedFeesReset(uint resetFeesInTwei);
535 
536     function resetCollectedFees() public onlyAdmin {
537         uint resetFeesInTwei = collectedFeesInTwei;
538         collectedFeesInTwei = 0;
539 
540         CollectedFeesReset(resetFeesInTwei);
541     }
542 
543     function getRate(
544             ERC20 conversionToken,
545             uint currentBlockNumber,
546             bool buy,
547             uint qtyInSrcWei
548     ) public view returns(uint) {
549 
550         currentBlockNumber;
551 
552         require(qtyInSrcWei <= MAX_QTY);
553         uint eInFp = fromWeiToFp(reserveContract.balance);
554         uint rateInPrecision = getRateWithE(conversionToken, buy, qtyInSrcWei, eInFp);
555         require(rateInPrecision <= MAX_RATE);
556         return rateInPrecision;
557     }
558 
559     function getRateWithE(ERC20 conversionToken, bool buy, uint qtyInSrcWei, uint eInFp) public view returns(uint) {
560         uint deltaEInFp;
561         uint sellInputTokenQtyInFp;
562         uint deltaTInFp;
563         uint rateInPrecision;
564 
565         require(qtyInSrcWei <= MAX_QTY);
566         require(eInFp <= maxQtyInFp);
567         if (conversionToken != token) return 0;
568 
569         if (buy) {
570             // ETH goes in, token goes out
571             deltaEInFp = fromWeiToFp(qtyInSrcWei);
572             if (deltaEInFp > maxEthCapBuyInFp) return 0;
573 
574             if (deltaEInFp == 0) {
575                 rateInPrecision = buyRateZeroQuantity(eInFp);
576             } else {
577                 rateInPrecision = buyRate(eInFp, deltaEInFp);
578             }
579         } else {
580             sellInputTokenQtyInFp = fromTweiToFp(qtyInSrcWei);
581             deltaTInFp = valueAfterReducingFee(sellInputTokenQtyInFp);
582             if (deltaTInFp == 0) {
583                 rateInPrecision = sellRateZeroQuantity(eInFp);
584                 deltaEInFp = 0;
585             } else {
586                 (rateInPrecision, deltaEInFp) = sellRate(eInFp, sellInputTokenQtyInFp, deltaTInFp);
587             }
588 
589             if (deltaEInFp > maxEthCapSellInFp) return 0;
590         }
591 
592         rateInPrecision = rateAfterValidation(rateInPrecision, buy);
593         return rateInPrecision;
594     }
595 
596     function rateAfterValidation(uint rateInPrecision, bool buy) public view returns(uint) {
597         uint minAllowRateInPrecision;
598         uint maxAllowedRateInPrecision;
599 
600         if (buy) {
601             minAllowRateInPrecision = minBuyRateInPrecision;
602             maxAllowedRateInPrecision = maxBuyRateInPrecision;
603         } else {
604             minAllowRateInPrecision = minSellRateInPrecision;
605             maxAllowedRateInPrecision = maxSellRateInPrecision;
606         }
607 
608         if ((rateInPrecision > maxAllowedRateInPrecision) || (rateInPrecision < minAllowRateInPrecision)) {
609             return 0;
610         } else if (rateInPrecision > MAX_RATE) {
611             return 0;
612         } else {
613             return rateInPrecision;
614         }
615     }
616 
617     function buyRate(uint eInFp, uint deltaEInFp) public view returns(uint) {
618         uint deltaTInFp = deltaTFunc(rInFp, pMinInFp, eInFp, deltaEInFp, formulaPrecision);
619         require(deltaTInFp <= maxQtyInFp);
620         deltaTInFp = valueAfterReducingFee(deltaTInFp);
621         return deltaTInFp * PRECISION / deltaEInFp;
622     }
623 
624     function buyRateZeroQuantity(uint eInFp) public view returns(uint) {
625         uint ratePreReductionInPrecision = formulaPrecision * PRECISION / pE(rInFp, pMinInFp, eInFp, formulaPrecision);
626         return valueAfterReducingFee(ratePreReductionInPrecision);
627     }
628 
629     function sellRate(
630         uint eInFp,
631         uint sellInputTokenQtyInFp,
632         uint deltaTInFp
633     ) public view returns(uint rateInPrecision, uint deltaEInFp) {
634         deltaEInFp = deltaEFunc(rInFp, pMinInFp, eInFp, deltaTInFp, formulaPrecision, numFpBits);
635         require(deltaEInFp <= maxQtyInFp);
636         rateInPrecision = deltaEInFp * PRECISION / sellInputTokenQtyInFp;
637     }
638 
639     function sellRateZeroQuantity(uint eInFp) public view returns(uint) {
640         uint ratePreReductionInPrecision = pE(rInFp, pMinInFp, eInFp, formulaPrecision) * PRECISION / formulaPrecision;
641         return valueAfterReducingFee(ratePreReductionInPrecision);
642     }
643 
644     function fromTweiToFp(uint qtyInTwei) public view returns(uint) {
645         require(qtyInTwei <= MAX_QTY);
646         return qtyInTwei * formulaPrecision / (10 ** getDecimals(token));
647     }
648 
649     function fromWeiToFp(uint qtyInwei) public view returns(uint) {
650         require(qtyInwei <= MAX_QTY);
651         return qtyInwei * formulaPrecision / (10 ** ETH_DECIMALS);
652     }
653 
654     function valueAfterReducingFee(uint val) public view returns(uint) {
655         require(val <= BIG_NUMBER);
656         return ((10000 - feeInBps) * val) / 10000;
657     }
658 
659     function calcCollectedFee(uint val) public view returns(uint) {
660         require(val <= MAX_QTY);
661         return val * feeInBps / (10000 - feeInBps);
662     }
663 
664     function abs(int val) public pure returns(uint) {
665         if (val < 0) {
666             return uint(val * (-1));
667         } else {
668             return uint(val);
669         }
670     }
671 
672 }