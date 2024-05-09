1 pragma solidity 0.4.18;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     function totalSupply() public view returns (uint supply);
8     function balanceOf(address _owner) public view returns (uint balance);
9     function transfer(address _to, uint _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
11     function approve(address _spender, uint _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public view returns (uint remaining);
13     function decimals() public view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 // File: contracts/ConversionRatesInterface.sol
18 
19 interface ConversionRatesInterface {
20 
21     function recordImbalance(
22         ERC20 token,
23         int buyAmount,
24         uint rateUpdateBlock,
25         uint currentBlock
26     )
27         public;
28 
29     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
30 }
31 
32 // File: contracts/LiquidityFormula.sol
33 
34 contract UtilMath {
35     uint public constant BIG_NUMBER = (uint(1)<<uint(200));
36 
37     function checkMultOverflow(uint x, uint y) public pure returns(bool) {
38         if (y == 0) return false;
39         return (((x*y) / y) != x);
40     }
41 
42     function compactFraction(uint p, uint q, uint precision) public pure returns (uint, uint) {
43         if (q < precision * precision) return (p, q);
44         return compactFraction(p/precision, q/precision, precision);
45     }
46 
47     /* solhint-disable code-complexity */
48     function exp(uint p, uint q, uint precision) public pure returns (uint) {
49         uint n = 0;
50         uint nFact = 1;
51         uint currentP = 1;
52         uint currentQ = 1;
53 
54         uint sum = 0;
55         uint prevSum = 0;
56 
57         while (true) {
58             if (checkMultOverflow(currentP, precision)) return sum;
59             if (checkMultOverflow(currentQ, nFact)) return sum;
60 
61             sum += (currentP * precision) / (currentQ * nFact);
62 
63             if (sum == prevSum) return sum;
64             prevSum = sum;
65 
66             n++;
67 
68             if (checkMultOverflow(currentP, p)) return sum;
69             if (checkMultOverflow(currentQ, q)) return sum;
70             if (checkMultOverflow(nFact, n)) return sum;
71 
72             currentP *= p;
73             currentQ *= q;
74             nFact *= n;
75 
76             (currentP, currentQ) = compactFraction(currentP, currentQ, precision);
77         }
78     }
79     /* solhint-enable code-complexity */
80 
81     function countLeadingZeros(uint p, uint q) public pure returns (uint) {
82         uint denomator = (uint(1)<<255);
83         for (int i = 255; i >= 0; i--) {
84             if ((q*denomator)/denomator != q) {
85                 // overflow
86                 denomator = denomator/2;
87                 continue;
88             }
89             if (p/(q*denomator) > 0) return uint(i);
90             denomator = denomator/2;
91         }
92 
93         return uint(-1);
94     }
95 
96     // log2 for a number that it in [1,2)
97     function log2ForSmallNumber(uint x, uint numPrecisionBits) public pure returns (uint) {
98         uint res = 0;
99         uint one = (uint(1)<<numPrecisionBits);
100         uint two = 2 * one;
101         uint addition = one;
102 
103         require((x >= one) && (x <= two));
104         require(numPrecisionBits < 125);
105 
106         for (uint i = numPrecisionBits; i > 0; i--) {
107             x = (x*x) / one;
108             addition = addition/2;
109             if (x >= two) {
110                 x = x/2;
111                 res += addition;
112             }
113         }
114 
115         return res;
116     }
117 
118     function logBase2 (uint p, uint q, uint numPrecisionBits) public pure returns (uint) {
119         uint n = 0;
120         uint precision = (uint(1)<<numPrecisionBits);
121 
122         if (p > q) {
123             n = countLeadingZeros(p, q);
124         }
125 
126         require(!checkMultOverflow(p, precision));
127         require(!checkMultOverflow(n, precision));
128         require(!checkMultOverflow(uint(1)<<n, q));
129 
130         uint y = p * precision / (q * (uint(1)<<n));
131         uint log2Small = log2ForSmallNumber(y, numPrecisionBits);
132 
133         require(n*precision <= BIG_NUMBER);
134         require(log2Small <= BIG_NUMBER);
135 
136         return n * precision + log2Small;
137     }
138 
139     function ln(uint p, uint q, uint numPrecisionBits) public pure returns (uint) {
140         uint ln2Numerator   = 6931471805599453094172;
141         uint ln2Denomerator = 10000000000000000000000;
142 
143         uint log2x = logBase2(p, q, numPrecisionBits);
144 
145         require(!checkMultOverflow(ln2Numerator, log2x));
146 
147         return ln2Numerator * log2x / ln2Denomerator;
148     }
149 }
150 
151 
152 contract LiquidityFormula is UtilMath {
153     function pE(uint r, uint pMIn, uint e, uint precision) public pure returns (uint) {
154         uint expRE = exp(r*e, precision*precision, precision);
155         require(!checkMultOverflow(expRE, pMIn));
156         return pMIn*expRE / precision;
157     }
158 
159     function deltaTFunc(uint r, uint pMIn, uint e, uint deltaE, uint precision) public pure returns (uint) {
160         uint pe = pE(r, pMIn, e, precision);
161         uint rpe = r * pe;
162         uint erdeltaE = exp(r*deltaE, precision*precision, precision);
163 
164         require(erdeltaE >= precision);
165         require(!checkMultOverflow(erdeltaE - precision, precision));
166         require(!checkMultOverflow((erdeltaE - precision)*precision, precision));
167         require(!checkMultOverflow((erdeltaE - precision)*precision*precision, precision));
168         require(!checkMultOverflow(rpe, erdeltaE));
169         require(!checkMultOverflow(r, pe));
170 
171         return (erdeltaE - precision) * precision * precision * precision / (rpe*erdeltaE);
172     }
173 
174     function deltaEFunc(uint r, uint pMIn, uint e, uint deltaT, uint precision, uint numPrecisionBits)
175         public pure
176         returns (uint)
177     {
178         uint pe = pE(r, pMIn, e, precision);
179         uint rpe = r * pe;
180         uint lnPart = ln(precision*precision + rpe*deltaT/precision, precision*precision, numPrecisionBits);
181 
182         require(!checkMultOverflow(r, pe));
183         require(!checkMultOverflow(precision, precision));
184         require(!checkMultOverflow(rpe, deltaT));
185         require(!checkMultOverflow(lnPart, precision));
186 
187         return lnPart * precision / r;
188     }
189 }
190 
191 // File: contracts/PermissionGroups.sol
192 
193 contract PermissionGroups {
194 
195     address public admin;
196     address public pendingAdmin;
197     mapping(address=>bool) internal operators;
198     mapping(address=>bool) internal alerters;
199     address[] internal operatorsGroup;
200     address[] internal alertersGroup;
201     uint constant internal MAX_GROUP_SIZE = 50;
202 
203     function PermissionGroups() public {
204         admin = msg.sender;
205     }
206 
207     modifier onlyAdmin() {
208         require(msg.sender == admin);
209         _;
210     }
211 
212     modifier onlyOperator() {
213         require(operators[msg.sender]);
214         _;
215     }
216 
217     modifier onlyAlerter() {
218         require(alerters[msg.sender]);
219         _;
220     }
221 
222     function getOperators () external view returns(address[]) {
223         return operatorsGroup;
224     }
225 
226     function getAlerters () external view returns(address[]) {
227         return alertersGroup;
228     }
229 
230     event TransferAdminPending(address pendingAdmin);
231 
232     /**
233      * @dev Allows the current admin to set the pendingAdmin address.
234      * @param newAdmin The address to transfer ownership to.
235      */
236     function transferAdmin(address newAdmin) public onlyAdmin {
237         require(newAdmin != address(0));
238         TransferAdminPending(pendingAdmin);
239         pendingAdmin = newAdmin;
240     }
241 
242     /**
243      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
244      * @param newAdmin The address to transfer ownership to.
245      */
246     function transferAdminQuickly(address newAdmin) public onlyAdmin {
247         require(newAdmin != address(0));
248         TransferAdminPending(newAdmin);
249         AdminClaimed(newAdmin, admin);
250         admin = newAdmin;
251     }
252 
253     event AdminClaimed( address newAdmin, address previousAdmin);
254 
255     /**
256      * @dev Allows the pendingAdmin address to finalize the change admin process.
257      */
258     function claimAdmin() public {
259         require(pendingAdmin == msg.sender);
260         AdminClaimed(pendingAdmin, admin);
261         admin = pendingAdmin;
262         pendingAdmin = address(0);
263     }
264 
265     event AlerterAdded (address newAlerter, bool isAdd);
266 
267     function addAlerter(address newAlerter) public onlyAdmin {
268         require(!alerters[newAlerter]); // prevent duplicates.
269         require(alertersGroup.length < MAX_GROUP_SIZE);
270 
271         AlerterAdded(newAlerter, true);
272         alerters[newAlerter] = true;
273         alertersGroup.push(newAlerter);
274     }
275 
276     function removeAlerter (address alerter) public onlyAdmin {
277         require(alerters[alerter]);
278         alerters[alerter] = false;
279 
280         for (uint i = 0; i < alertersGroup.length; ++i) {
281             if (alertersGroup[i] == alerter) {
282                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
283                 alertersGroup.length--;
284                 AlerterAdded(alerter, false);
285                 break;
286             }
287         }
288     }
289 
290     event OperatorAdded(address newOperator, bool isAdd);
291 
292     function addOperator(address newOperator) public onlyAdmin {
293         require(!operators[newOperator]); // prevent duplicates.
294         require(operatorsGroup.length < MAX_GROUP_SIZE);
295 
296         OperatorAdded(newOperator, true);
297         operators[newOperator] = true;
298         operatorsGroup.push(newOperator);
299     }
300 
301     function removeOperator (address operator) public onlyAdmin {
302         require(operators[operator]);
303         operators[operator] = false;
304 
305         for (uint i = 0; i < operatorsGroup.length; ++i) {
306             if (operatorsGroup[i] == operator) {
307                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
308                 operatorsGroup.length -= 1;
309                 OperatorAdded(operator, false);
310                 break;
311             }
312         }
313     }
314 }
315 
316 // File: contracts/Withdrawable.sol
317 
318 /**
319  * @title Contracts that should be able to recover tokens or ethers
320  * @author Ilan Doron
321  * @dev This allows to recover any tokens or Ethers received in a contract.
322  * This will prevent any accidental loss of tokens.
323  */
324 contract Withdrawable is PermissionGroups {
325 
326     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
327 
328     /**
329      * @dev Withdraw all ERC20 compatible tokens
330      * @param token ERC20 The address of the token contract
331      */
332     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
333         require(token.transfer(sendTo, amount));
334         TokenWithdraw(token, amount, sendTo);
335     }
336 
337     event EtherWithdraw(uint amount, address sendTo);
338 
339     /**
340      * @dev Withdraw Ethers
341      */
342     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
343         sendTo.transfer(amount);
344         EtherWithdraw(amount, sendTo);
345     }
346 }
347 
348 // File: contracts/Utils.sol
349 
350 /// @title Kyber constants contract
351 contract Utils {
352 
353     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
354     uint  constant internal PRECISION = (10**18);
355     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
356     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
357     uint  constant internal MAX_DECIMALS = 18;
358     uint  constant internal ETH_DECIMALS = 18;
359     mapping(address=>uint) internal decimals;
360 
361     function setDecimals(ERC20 token) internal {
362         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
363         else decimals[token] = token.decimals();
364     }
365 
366     function getDecimals(ERC20 token) internal view returns(uint) {
367         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
368         uint tokenDecimals = decimals[token];
369         // technically, there might be token with decimals 0
370         // moreover, very possible that old tokens have decimals 0
371         // these tokens will just have higher gas fees.
372         if(tokenDecimals == 0) return token.decimals();
373 
374         return tokenDecimals;
375     }
376 
377     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
378         require(srcQty <= MAX_QTY);
379         require(rate <= MAX_RATE);
380 
381         if (dstDecimals >= srcDecimals) {
382             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
383             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
384         } else {
385             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
386             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
387         }
388     }
389 
390     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
391         require(dstQty <= MAX_QTY);
392         require(rate <= MAX_RATE);
393         
394         //source quantity is rounded up. to avoid dest quantity being too low.
395         uint numerator;
396         uint denominator;
397         if (srcDecimals >= dstDecimals) {
398             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
399             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
400             denominator = rate;
401         } else {
402             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
403             numerator = (PRECISION * dstQty);
404             denominator = (rate * (10**(dstDecimals - srcDecimals)));
405         }
406         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
407     }
408 }
409 
410 // File: contracts/LiquidityConversionRates.sol
411 
412 contract LiquidityConversionRates is ConversionRatesInterface, LiquidityFormula, Withdrawable, Utils {
413     ERC20 public token;
414     address public reserveContract;
415 
416     uint public numFpBits;
417     uint public formulaPrecision;
418 
419     uint public rInFp;
420     uint public pMinInFp;
421 
422     uint public maxEthCapBuyInFp;
423     uint public maxEthCapSellInFp;
424     uint public maxQtyInFp;
425 
426     uint public feeInBps;
427     uint public collectedFeesInTwei = 0;
428 
429     uint public maxBuyRateInPrecision;
430     uint public minBuyRateInPrecision;
431     uint public maxSellRateInPrecision;
432     uint public minSellRateInPrecision;
433 
434     function LiquidityConversionRates(address _admin, ERC20 _token) public {
435         transferAdminQuickly(_admin);
436         token = _token;
437         setDecimals(token);
438         require(getDecimals(token) <= MAX_DECIMALS);
439     }
440 
441     event ReserveAddressSet(address reserve);
442 
443     function setReserveAddress(address reserve) public onlyAdmin {
444         reserveContract = reserve;
445         ReserveAddressSet(reserve);
446     }
447 
448     event LiquidityParamsSet(
449         uint rInFp,
450         uint pMinInFp,
451         uint numFpBits,
452         uint maxCapBuyInFp,
453         uint maxEthCapSellInFp,
454         uint feeInBps,
455         uint formulaPrecision,
456         uint maxQtyInFp,
457         uint maxBuyRateInPrecision,
458         uint minBuyRateInPrecision,
459         uint maxSellRateInPrecision,
460         uint minSellRateInPrecision
461     );
462 
463     function setLiquidityParams(
464         uint _rInFp,
465         uint _pMinInFp,
466         uint _numFpBits,
467         uint _maxCapBuyInWei,
468         uint _maxCapSellInWei,
469         uint _feeInBps,
470         uint _maxTokenToEthRateInPrecision,
471         uint _minTokenToEthRateInPrecision
472     ) public onlyAdmin {
473 
474         require(_numFpBits < 256);
475         require(formulaPrecision <= MAX_QTY);
476         require(_feeInBps < 10000);
477         require(_minTokenToEthRateInPrecision < _maxTokenToEthRateInPrecision);
478 
479         rInFp = _rInFp;
480         pMinInFp = _pMinInFp;
481         formulaPrecision = uint(1)<<_numFpBits;
482         maxQtyInFp = fromWeiToFp(MAX_QTY);
483         numFpBits = _numFpBits;
484         maxEthCapBuyInFp = fromWeiToFp(_maxCapBuyInWei);
485         maxEthCapSellInFp = fromWeiToFp(_maxCapSellInWei);
486         feeInBps = _feeInBps;
487         maxBuyRateInPrecision = PRECISION * PRECISION / _minTokenToEthRateInPrecision;
488         minBuyRateInPrecision = PRECISION * PRECISION / _maxTokenToEthRateInPrecision;
489         maxSellRateInPrecision = _maxTokenToEthRateInPrecision;
490         minSellRateInPrecision = _minTokenToEthRateInPrecision;
491 
492         LiquidityParamsSet(
493             rInFp,
494             pMinInFp,
495             numFpBits,
496             maxEthCapBuyInFp,
497             maxEthCapSellInFp,
498             feeInBps,
499             formulaPrecision,
500             maxQtyInFp,
501             maxBuyRateInPrecision,
502             minBuyRateInPrecision,
503             maxSellRateInPrecision,
504             minSellRateInPrecision
505         );
506     }
507 
508     function recordImbalance(
509         ERC20 conversionToken,
510         int buyAmountInTwei,
511         uint rateUpdateBlock,
512         uint currentBlock
513     )
514         public
515     {
516         conversionToken;
517         rateUpdateBlock;
518         currentBlock;
519 
520         require(msg.sender == reserveContract);
521         if (buyAmountInTwei > 0) {
522             // Buy case
523             collectedFeesInTwei += calcCollectedFee(abs(buyAmountInTwei));
524         } else {
525             // Sell case
526             collectedFeesInTwei += abs(buyAmountInTwei) * feeInBps / 10000;
527         }
528     }
529 
530     event CollectedFeesReset(uint resetFeesInTwei);
531 
532     function resetCollectedFees() public onlyAdmin {
533         uint resetFeesInTwei = collectedFeesInTwei;
534         collectedFeesInTwei = 0;
535 
536         CollectedFeesReset(resetFeesInTwei);
537     }
538 
539     function getRate(
540             ERC20 conversionToken,
541             uint currentBlockNumber,
542             bool buy,
543             uint qtyInSrcWei
544     ) public view returns(uint) {
545 
546         currentBlockNumber;
547 
548         require(qtyInSrcWei <= MAX_QTY);
549         uint eInFp = fromWeiToFp(reserveContract.balance);
550         uint rateInPrecision = getRateWithE(conversionToken, buy, qtyInSrcWei, eInFp);
551         require(rateInPrecision <= MAX_RATE);
552         return rateInPrecision;
553     }
554 
555     function getRateWithE(ERC20 conversionToken, bool buy, uint qtyInSrcWei, uint eInFp) public view returns(uint) {
556         uint deltaEInFp;
557         uint sellInputTokenQtyInFp;
558         uint deltaTInFp;
559         uint rateInPrecision;
560 
561         require(qtyInSrcWei <= MAX_QTY);
562         require(eInFp <= maxQtyInFp);
563         if (conversionToken != token) return 0;
564 
565         if (buy) {
566             // ETH goes in, token goes out
567             deltaEInFp = fromWeiToFp(qtyInSrcWei);
568             if (deltaEInFp > maxEthCapBuyInFp) return 0;
569 
570             if (deltaEInFp == 0) {
571                 rateInPrecision = buyRateZeroQuantity(eInFp);
572             } else {
573                 rateInPrecision = buyRate(eInFp, deltaEInFp);
574             }
575         } else {
576             sellInputTokenQtyInFp = fromTweiToFp(qtyInSrcWei);
577             deltaTInFp = valueAfterReducingFee(sellInputTokenQtyInFp);
578             if (deltaTInFp == 0) {
579                 rateInPrecision = sellRateZeroQuantity(eInFp);
580                 deltaEInFp = 0;
581             } else {
582                 (rateInPrecision, deltaEInFp) = sellRate(eInFp, sellInputTokenQtyInFp, deltaTInFp);
583             }
584 
585             if (deltaEInFp > maxEthCapSellInFp) return 0;
586         }
587 
588         rateInPrecision = rateAfterValidation(rateInPrecision, buy);
589         return rateInPrecision;
590     }
591 
592     function rateAfterValidation(uint rateInPrecision, bool buy) public view returns(uint) {
593         uint minAllowRateInPrecision;
594         uint maxAllowedRateInPrecision;
595 
596         if (buy) {
597             minAllowRateInPrecision = minBuyRateInPrecision;
598             maxAllowedRateInPrecision = maxBuyRateInPrecision;
599         } else {
600             minAllowRateInPrecision = minSellRateInPrecision;
601             maxAllowedRateInPrecision = maxSellRateInPrecision;
602         }
603 
604         if ((rateInPrecision > maxAllowedRateInPrecision) || (rateInPrecision < minAllowRateInPrecision)) {
605             return 0;
606         } else if (rateInPrecision > MAX_RATE) {
607             return 0;
608         } else {
609             return rateInPrecision;
610         }
611     }
612 
613     function buyRate(uint eInFp, uint deltaEInFp) public view returns(uint) {
614         uint deltaTInFp = deltaTFunc(rInFp, pMinInFp, eInFp, deltaEInFp, formulaPrecision);
615         require(deltaTInFp <= maxQtyInFp);
616         deltaTInFp = valueAfterReducingFee(deltaTInFp);
617         return deltaTInFp * PRECISION / deltaEInFp;
618     }
619 
620     function buyRateZeroQuantity(uint eInFp) public view returns(uint) {
621         uint ratePreReductionInPrecision = formulaPrecision * PRECISION / pE(rInFp, pMinInFp, eInFp, formulaPrecision);
622         return valueAfterReducingFee(ratePreReductionInPrecision);
623     }
624 
625     function sellRate(
626         uint eInFp,
627         uint sellInputTokenQtyInFp,
628         uint deltaTInFp
629     ) public view returns(uint rateInPrecision, uint deltaEInFp) {
630         deltaEInFp = deltaEFunc(rInFp, pMinInFp, eInFp, deltaTInFp, formulaPrecision, numFpBits);
631         require(deltaEInFp <= maxQtyInFp);
632         rateInPrecision = deltaEInFp * PRECISION / sellInputTokenQtyInFp;
633     }
634 
635     function sellRateZeroQuantity(uint eInFp) public view returns(uint) {
636         uint ratePreReductionInPrecision = pE(rInFp, pMinInFp, eInFp, formulaPrecision) * PRECISION / formulaPrecision;
637         return valueAfterReducingFee(ratePreReductionInPrecision);
638     }
639 
640     function fromTweiToFp(uint qtyInTwei) public view returns(uint) {
641         require(qtyInTwei <= MAX_QTY);
642         return qtyInTwei * formulaPrecision / (10 ** getDecimals(token));
643     }
644 
645     function fromWeiToFp(uint qtyInwei) public view returns(uint) {
646         require(qtyInwei <= MAX_QTY);
647         return qtyInwei * formulaPrecision / (10 ** ETH_DECIMALS);
648     }
649 
650     function valueAfterReducingFee(uint val) public view returns(uint) {
651         require(val <= BIG_NUMBER);
652         return ((10000 - feeInBps) * val) / 10000;
653     }
654 
655     function calcCollectedFee(uint val) public view returns(uint) {
656         require(val <= MAX_QTY);
657         return val * feeInBps / (10000 - feeInBps);
658     }
659 
660     function abs(int val) public pure returns(uint) {
661         if (val < 0) {
662             return uint(val * (-1));
663         } else {
664             return uint(val);
665         }
666     }
667 
668 }