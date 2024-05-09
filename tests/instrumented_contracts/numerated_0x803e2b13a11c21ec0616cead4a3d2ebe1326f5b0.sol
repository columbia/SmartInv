1 pragma solidity 0.4.18;
2 
3 interface BurnableToken {
4     function transferFrom(address _from, address _to, uint _value) public returns (bool);
5     function burnFrom(address _from, uint256 _value) public returns (bool);
6 }
7 
8 interface ERC20 {
9     function totalSupply() public view returns (uint supply);
10     function balanceOf(address _owner) public view returns (uint balance);
11     function transfer(address _to, uint _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
13     function approve(address _spender, uint _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public view returns (uint remaining);
15     function decimals() public view returns(uint digits);
16     event Approval(address indexed _owner, address indexed _spender, uint _value);
17 }
18 
19 interface SanityRatesInterface {
20     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
21 }
22 
23 contract Utils {
24 
25     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
26     uint  constant internal PRECISION = (10**18);
27     uint  constant internal MAX_QTY   = (10**28); // 1B tokens
28     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
29     uint  constant internal MAX_DECIMALS = 18;
30 
31     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
32         if (dstDecimals >= srcDecimals) {
33             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
34             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
35         } else {
36             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
37             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
38         }
39     }
40 
41     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
42         //source quantity is rounded up. to avoid dest quantity being too low.
43         uint numerator;
44         uint denominator;
45         if (srcDecimals >= dstDecimals) {
46             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
47             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
48             denominator = rate;
49         } else {
50             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
51             numerator = (PRECISION * dstQty);
52             denominator = (rate * (10**(dstDecimals - srcDecimals)));
53         }
54         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
55     }
56 }
57 
58 interface FeeBurnerInterface {
59     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
60 }
61 
62 interface ExpectedRateInterface {
63     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
64         returns (uint expectedRate, uint slippageRate);
65 }
66 
67 contract PermissionGroups {
68 
69     address public admin;
70     address public pendingAdmin;
71     mapping(address=>bool) internal operators;
72     mapping(address=>bool) internal alerters;
73     address[] internal operatorsGroup;
74     address[] internal alertersGroup;
75 
76     function PermissionGroups() public {
77         admin = msg.sender;
78     }
79 
80     modifier onlyAdmin() {
81         require(msg.sender == admin);
82         _;
83     }
84 
85     modifier onlyOperator() {
86         require(operators[msg.sender]);
87         _;
88     }
89 
90     modifier onlyAlerter() {
91         require(alerters[msg.sender]);
92         _;
93     }
94 
95     function getOperators () external view returns(address[]) {
96         return operatorsGroup;
97     }
98 
99     function getAlerters () external view returns(address[]) {
100         return alertersGroup;
101     }
102 
103     event TransferAdminPending(address pendingAdmin);
104 
105     /**
106      * @dev Allows the current admin to set the pendingAdmin address.
107      * @param newAdmin The address to transfer ownership to.
108      */
109     function transferAdmin(address newAdmin) public onlyAdmin {
110         require(newAdmin != address(0));
111         TransferAdminPending(pendingAdmin);
112         pendingAdmin = newAdmin;
113     }
114 
115     event AdminClaimed( address newAdmin, address previousAdmin);
116 
117     /**
118      * @dev Allows the pendingAdmin address to finalize the change admin process.
119      */
120     function claimAdmin() public {
121         require(pendingAdmin == msg.sender);
122         AdminClaimed(pendingAdmin, admin);
123         admin = pendingAdmin;
124         pendingAdmin = address(0);
125     }
126 
127     event AlerterAdded (address newAlerter, bool isAdd);
128 
129     function addAlerter(address newAlerter) public onlyAdmin {
130         require(!alerters[newAlerter]); // prevent duplicates.
131         AlerterAdded(newAlerter, true);
132         alerters[newAlerter] = true;
133         alertersGroup.push(newAlerter);
134     }
135 
136     function removeAlerter (address alerter) public onlyAdmin {
137         require(alerters[alerter]);
138         alerters[alerter] = false;
139 
140         for (uint i = 0; i < alertersGroup.length; ++i) {
141             if (alertersGroup[i] == alerter) {
142                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
143                 alertersGroup.length--;
144                 AlerterAdded(alerter, false);
145                 break;
146             }
147         }
148     }
149 
150     event OperatorAdded(address newOperator, bool isAdd);
151 
152     function addOperator(address newOperator) public onlyAdmin {
153         require(!operators[newOperator]); // prevent duplicates.
154         OperatorAdded(newOperator, true);
155         operators[newOperator] = true;
156         operatorsGroup.push(newOperator);
157     }
158 
159     function removeOperator (address operator) public onlyAdmin {
160         require(operators[operator]);
161         operators[operator] = false;
162 
163         for (uint i = 0; i < operatorsGroup.length; ++i) {
164             if (operatorsGroup[i] == operator) {
165                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
166                 operatorsGroup.length -= 1;
167                 OperatorAdded(operator, false);
168                 break;
169             }
170         }
171     }
172 }
173 
174 contract Withdrawable is PermissionGroups {
175 
176     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
177 
178     /**
179      * @dev Withdraw all ERC20 compatible tokens
180      * @param token ERC20 The address of the token contract
181      */
182     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
183         require(token.transfer(sendTo, amount));
184         TokenWithdraw(token, amount, sendTo);
185     }
186 
187     event EtherWithdraw(uint amount, address sendTo);
188 
189     /**
190      * @dev Withdraw Ethers
191      */
192     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
193         sendTo.transfer(amount);
194         EtherWithdraw(amount, sendTo);
195     }
196 }
197 
198 contract ExpectedRate is Withdrawable, ExpectedRateInterface {
199 
200     KyberNetwork internal kyberNetwork;
201     uint public quantityFactor = 2;
202     uint public minSlippageFactorInBps = 50;
203 
204     function ExpectedRate(KyberNetwork _kyberNetwork, address _admin) public {
205         require(_admin != address(0));
206         require(_kyberNetwork != address(0));
207         kyberNetwork = _kyberNetwork;
208         admin = _admin;
209     }
210 
211     event QuantityFactorSet (uint newFactor, uint oldFactor, address sender);
212 
213     function setQuantityFactor(uint newFactor) public onlyOperator {
214         QuantityFactorSet(quantityFactor, newFactor, msg.sender);
215         quantityFactor = newFactor;
216     }
217 
218     event MinSlippageFactorSet (uint newMin, uint oldMin, address sender);
219 
220     function setMinSlippageFactor(uint bps) public onlyOperator {
221         MinSlippageFactorSet(bps, minSlippageFactorInBps, msg.sender);
222         minSlippageFactorInBps = bps;
223     }
224 
225     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
226         public view
227         returns (uint expectedRate, uint slippageRate)
228     {
229         require(quantityFactor != 0);
230 
231         uint bestReserve;
232         uint minSlippage;
233 
234         (bestReserve, expectedRate) = kyberNetwork.findBestRate(src, dest, srcQty);
235         (bestReserve, slippageRate) = kyberNetwork.findBestRate(src, dest, (srcQty * quantityFactor));
236 
237         minSlippage = ((10000 - minSlippageFactorInBps) * expectedRate) / 10000;
238         if (slippageRate >= minSlippage) {
239             slippageRate = minSlippage;
240         }
241 
242         return (expectedRate, slippageRate);
243     }
244 }
245 
246 contract VolumeImbalanceRecorder is Withdrawable {
247 
248     uint constant internal SLIDING_WINDOW_SIZE = 5;
249     uint constant internal POW_2_64 = 2 ** 64;
250 
251     struct TokenControlInfo {
252         uint minimalRecordResolution; // can be roughly 1 cent
253         uint maxPerBlockImbalance; // in twei resolution
254         uint maxTotalImbalance; // max total imbalance (between rate updates)
255                             // before halting trade
256     }
257 
258     mapping(address => TokenControlInfo) internal tokenControlInfo;
259 
260     struct TokenImbalanceData {
261         int  lastBlockBuyUnitsImbalance;
262         uint lastBlock;
263 
264         int  totalBuyUnitsImbalance;
265         uint lastRateUpdateBlock;
266     }
267 
268     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
269 
270     function VolumeImbalanceRecorder(address _admin) public {
271         require(_admin != address(0));
272         admin = _admin;
273     }
274 
275     function setTokenControlInfo(
276         ERC20 token,
277         uint minimalRecordResolution,
278         uint maxPerBlockImbalance,
279         uint maxTotalImbalance
280     )
281         public
282         onlyAdmin
283     {
284         tokenControlInfo[token] =
285             TokenControlInfo(
286                 minimalRecordResolution,
287                 maxPerBlockImbalance,
288                 maxTotalImbalance
289             );
290     }
291 
292     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
293         return (tokenControlInfo[token].minimalRecordResolution,
294                 tokenControlInfo[token].maxPerBlockImbalance,
295                 tokenControlInfo[token].maxTotalImbalance);
296     }
297 
298     function addImbalance(
299         ERC20 token,
300         int buyAmount,
301         uint rateUpdateBlock,
302         uint currentBlock
303     )
304         internal
305     {
306         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
307         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
308 
309         int prevImbalance = 0;
310 
311         TokenImbalanceData memory currentBlockData =
312             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
313 
314         // first scenario - this is not the first tx in the current block
315         if (currentBlockData.lastBlock == currentBlock) {
316             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
317                 // just increase imbalance
318                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
319                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
320             } else {
321                 // imbalance was changed in the middle of the block
322                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
323                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
324                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
325                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
326             }
327         } else {
328             // first tx in the current block
329             int currentBlockImbalance;
330             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
331 
332             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
333             currentBlockData.lastBlock = uint(currentBlock);
334             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
335             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
336         }
337 
338         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
339     }
340 
341     function setGarbageToVolumeRecorder(ERC20 token) internal {
342         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
343             tokenImbalanceData[token][i] = 0x1;
344         }
345     }
346 
347     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
348         // check the imbalance in the sliding window
349         require(startBlock <= endBlock);
350 
351         buyImbalance = 0;
352 
353         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
354             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
355 
356             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
357                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
358             }
359         }
360     }
361 
362     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
363         internal view
364         returns(int buyImbalance, int currentBlockImbalance)
365     {
366         buyImbalance = 0;
367         currentBlockImbalance = 0;
368         uint latestBlock = 0;
369         int imbalanceInRange = 0;
370         uint startBlock = rateUpdateBlock;
371         uint endBlock = currentBlock;
372 
373         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
374             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
375 
376             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
377                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
378             }
379 
380             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
381             if (perBlockData.lastBlock < latestBlock) continue;
382 
383             latestBlock = perBlockData.lastBlock;
384             buyImbalance = perBlockData.totalBuyUnitsImbalance;
385             if (uint(perBlockData.lastBlock) == currentBlock) {
386                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
387             }
388         }
389 
390         if (buyImbalance == 0) {
391             buyImbalance = imbalanceInRange;
392         }
393     }
394 
395     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
396         internal view
397         returns(int totalImbalance, int currentBlockImbalance)
398     {
399 
400         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
401 
402         (totalImbalance, currentBlockImbalance) =
403             getImbalanceSinceRateUpdate(
404                 token,
405                 rateUpdateBlock,
406                 currentBlock);
407 
408         totalImbalance *= resolution;
409         currentBlockImbalance *= resolution;
410     }
411 
412     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
413         return tokenControlInfo[token].maxPerBlockImbalance;
414     }
415 
416     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
417         return tokenControlInfo[token].maxTotalImbalance;
418     }
419 
420     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
421         // check for overflows
422         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
423         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
424         require(data.lastBlock < POW_2_64);
425         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
426         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
427         require(data.lastRateUpdateBlock < POW_2_64);
428 
429         // do encoding
430         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
431         result |= data.lastBlock * POW_2_64;
432         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
433         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
434 
435         return result;
436     }
437 
438     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
439         TokenImbalanceData memory data;
440 
441         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
442         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
443         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
444         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
445 
446         return data;
447     }
448 }
449 
450 contract ConversionRates is VolumeImbalanceRecorder, Utils {
451 
452     // bps - basic rate steps. one step is 1 / 10000 of the rate.
453     struct StepFunction {
454         int[] x; // quantity for each step. Quantity of each step includes previous steps.
455         int[] y; // rate change per quantity step  in bps.
456     }
457 
458     struct TokenData {
459         bool listed;  // was added to reserve
460         bool enabled; // whether trade is enabled
461 
462         // position in the compact data
463         uint compactDataArrayIndex;
464         uint compactDataFieldIndex;
465 
466         // rate data. base and changes according to quantity and reserve balance.
467         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
468         uint baseBuyRate;  // in PRECISION units. see KyberConstants
469         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
470         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
471         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
472         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
473         StepFunction sellRateImbalanceStepFunction;
474     }
475 
476     /*
477     this is the data for tokenRatesCompactData
478     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
479     so we represent it as bytes32 and do the byte tricks ourselves.
480     struct TokenRatesCompactData {
481         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
482         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
483 
484         uint32 blockNumber;
485     } */
486     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
487     ERC20[] internal listedTokens;
488     mapping(address=>TokenData) internal tokenData;
489     bytes32[] internal tokenRatesCompactData;
490     uint public numTokensInCurrentCompactData = 0;
491     address public reserveContract;
492     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
493     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
494 
495     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
496         { } // solhint-disable-line no-empty-blocks
497 
498     function addToken(ERC20 token) public onlyAdmin {
499 
500         require(!tokenData[token].listed);
501         tokenData[token].listed = true;
502         listedTokens.push(token);
503 
504         if (numTokensInCurrentCompactData == 0) {
505             tokenRatesCompactData.length++; // add new structure
506         }
507 
508         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
509         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
510 
511         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
512 
513         setGarbageToVolumeRecorder(token);
514     }
515 
516     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
517 
518         require(buy.length == sell.length);
519         require(indices.length == buy.length);
520         require(blockNumber <= 0xFFFFFFFF);
521 
522         uint bytes14Offset = BYTES_14_OFFSET;
523 
524         for (uint i = 0; i < indices.length; i++) {
525             require(indices[i] < tokenRatesCompactData.length);
526             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
527             tokenRatesCompactData[indices[i]] = bytes32(data);
528         }
529     }
530 
531     function setBaseRate(
532         ERC20[] tokens,
533         uint[] baseBuy,
534         uint[] baseSell,
535         bytes14[] buy,
536         bytes14[] sell,
537         uint blockNumber,
538         uint[] indices
539     )
540         public
541         onlyOperator
542     {
543         require(tokens.length == baseBuy.length);
544         require(tokens.length == baseSell.length);
545         require(sell.length == buy.length);
546         require(sell.length == indices.length);
547 
548         for (uint ind = 0; ind < tokens.length; ind++) {
549             require(tokenData[tokens[ind]].listed);
550             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
551             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
552         }
553 
554         setCompactData(buy, sell, blockNumber, indices);
555     }
556 
557     function setQtyStepFunction(
558         ERC20 token,
559         int[] xBuy,
560         int[] yBuy,
561         int[] xSell,
562         int[] ySell
563     )
564         public
565         onlyOperator
566     {
567         require(xBuy.length == yBuy.length);
568         require(xSell.length == ySell.length);
569         require(tokenData[token].listed);
570 
571         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
572         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
573     }
574 
575     function setImbalanceStepFunction(
576         ERC20 token,
577         int[] xBuy,
578         int[] yBuy,
579         int[] xSell,
580         int[] ySell
581     )
582         public
583         onlyOperator
584     {
585         require(xBuy.length == yBuy.length);
586         require(xSell.length == ySell.length);
587         require(tokenData[token].listed);
588 
589         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
590         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
591     }
592 
593     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
594         validRateDurationInBlocks = duration;
595     }
596 
597     function enableTokenTrade(ERC20 token) public onlyAdmin {
598         require(tokenData[token].listed);
599         require(tokenControlInfo[token].minimalRecordResolution != 0);
600         tokenData[token].enabled = true;
601     }
602 
603     function disableTokenTrade(ERC20 token) public onlyAlerter {
604         require(tokenData[token].listed);
605         tokenData[token].enabled = false;
606     }
607 
608     function setReserveAddress(address reserve) public onlyAdmin {
609         reserveContract = reserve;
610     }
611 
612     function recordImbalance(
613         ERC20 token,
614         int buyAmount,
615         uint rateUpdateBlock,
616         uint currentBlock
617     )
618         public
619     {
620         require(msg.sender == reserveContract);
621 
622         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
623 
624         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
625     }
626 
627     /* solhint-disable function-max-lines */
628     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
629         // check if trade is enabled
630         if (!tokenData[token].enabled) return 0;
631         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
632 
633         // get rate update block
634         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
635 
636         uint updateRateBlock = getLast4Bytes(compactData);
637         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
638         // check imbalance
639         int totalImbalance;
640         int blockImbalance;
641         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
642 
643         // calculate actual rate
644         int imbalanceQty;
645         int extraBps;
646         int8 rateUpdate;
647         uint rate;
648 
649         if (buy) {
650             // start with base rate
651             rate = tokenData[token].baseBuyRate;
652 
653             // add rate update
654             rateUpdate = getRateByteFromCompactData(compactData, token, true);
655             extraBps = int(rateUpdate) * 10;
656             rate = addBps(rate, extraBps);
657 
658             // compute token qty
659             qty = getTokenQty(token, rate, qty);
660             imbalanceQty = int(qty);
661             totalImbalance += imbalanceQty;
662 
663             // add qty overhead
664             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
665             rate = addBps(rate, extraBps);
666 
667             // add imbalance overhead
668             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
669             rate = addBps(rate, extraBps);
670         } else {
671             // start with base rate
672             rate = tokenData[token].baseSellRate;
673 
674             // add rate update
675             rateUpdate = getRateByteFromCompactData(compactData, token, false);
676             extraBps = int(rateUpdate) * 10;
677             rate = addBps(rate, extraBps);
678 
679             // compute token qty
680             imbalanceQty = -1 * int(qty);
681             totalImbalance += imbalanceQty;
682 
683             // add qty overhead
684             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
685             rate = addBps(rate, extraBps);
686 
687             // add imbalance overhead
688             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
689             rate = addBps(rate, extraBps);
690         }
691 
692         if (abs(totalImbalance + imbalanceQty) >= getMaxTotalImbalance(token)) return 0;
693         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
694 
695         return rate;
696     }
697     /* solhint-enable function-max-lines */
698 
699     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
700         if (buy)
701             return tokenData[token].baseBuyRate;
702         else
703             return tokenData[token].baseSellRate;
704     }
705 
706     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
707         uint arrayIndex = tokenData[token].compactDataArrayIndex;
708         uint fieldOffset = tokenData[token].compactDataFieldIndex;
709 
710         return (
711             arrayIndex,
712             fieldOffset,
713             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
714             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
715         );
716     }
717 
718     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
719         return (tokenData[token].listed, tokenData[token].enabled);
720     }
721 
722     /* solhint-disable code-complexity */
723     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
724         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
725         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
726         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
727         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
728 
729         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
730         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
731         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
732         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
733 
734         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
735         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
736         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
737         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
738 
739         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
740         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
741         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
742         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
743 
744         revert();
745     }
746     /* solhint-enable code-complexity */
747 
748     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
749         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
750         return getLast4Bytes(compactData);
751     }
752 
753     function getListedTokens() public view returns(ERC20[]) {
754         return listedTokens;
755     }
756 
757     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
758         uint dstDecimals = token.decimals();
759         uint srcDecimals = 18;
760 
761         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
762     }
763 
764     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
765         // cannot trust compiler with not turning bit operations into EXP opcode
766         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
767     }
768 
769     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
770         uint fieldOffset = tokenData[token].compactDataFieldIndex;
771         uint byteOffset;
772         if (buy)
773             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
774         else
775             byteOffset = 4 + fieldOffset;
776 
777         return int8(data[byteOffset]);
778     }
779 
780     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
781         uint len = f.y.length;
782         for (uint ind = 0; ind < len; ind++) {
783             if (x <= f.x[ind]) return f.y[ind];
784         }
785 
786         return f.y[len-1];
787     }
788 
789     function addBps(uint rate, int bps) internal pure returns(uint) {
790         uint maxBps = 100 * 100;
791         return (rate * uint(int(maxBps) + bps)) / maxBps;
792     }
793 
794     function abs(int x) internal pure returns(uint) {
795         if (x < 0)
796             return uint(-1 * x);
797         else
798             return uint(x);
799     }
800 }
801 
802 contract KyberNetwork is Withdrawable, Utils {
803 
804     uint public negligibleRateDiff = 10; // basic rate steps will be in 0.01%
805     KyberReserve[] public reserves;
806     mapping(address=>bool) public isReserve;
807     WhiteList public whiteListContract;
808     ExpectedRateInterface public expectedRateContract;
809     FeeBurnerInterface    public feeBurnerContract;
810     uint                  public maxGasPrice = 50 * 1000 * 1000 * 1000; // 50 gwei
811     bool                  public enabled = false; // network is enabled
812     mapping(address=>mapping(bytes32=>bool)) public perReserveListedPairs;
813 
814     function KyberNetwork(address _admin) public {
815         require(_admin != address(0));
816         admin = _admin;
817     }
818 
819     event EtherReceival(address indexed sender, uint amount);
820 
821     /* solhint-disable no-complex-fallback */
822     function() public payable {
823         require(isReserve[msg.sender]);
824         EtherReceival(msg.sender, msg.value);
825     }
826     /* solhint-enable no-complex-fallback */
827 
828     event ExecuteTrade(address indexed sender, ERC20 src, ERC20 dest, uint actualSrcAmount, uint actualDestAmount);
829 
830     /// @notice use token address ETH_TOKEN_ADDRESS for ether
831     /// @dev makes a trade between src and dest token and send dest token to destAddress
832     /// @param src Src token
833     /// @param srcAmount amount of src tokens
834     /// @param dest   Destination token
835     /// @param destAddress Address to send tokens to
836     /// @param maxDestAmount A limit on the amount of dest tokens
837     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
838     /// @param walletId is the wallet ID to send part of the fees
839     /// @return amount of actual dest tokens
840     function trade(
841         ERC20 src,
842         uint srcAmount,
843         ERC20 dest,
844         address destAddress,
845         uint maxDestAmount,
846         uint minConversionRate,
847         address walletId
848     )
849         public
850         payable
851         returns(uint)
852     {
853         require(enabled);
854 
855         uint userSrcBalanceBefore;
856         uint userSrcBalanceAfter;
857         uint userDestBalanceBefore;
858         uint userDestBalanceAfter;
859 
860         userSrcBalanceBefore = getBalance(src, msg.sender);
861         if (src == ETH_TOKEN_ADDRESS)
862             userSrcBalanceBefore += msg.value;
863         userDestBalanceBefore = getBalance(dest, destAddress);
864 
865         uint actualDestAmount = doTrade(src,
866                                         srcAmount,
867                                         dest,
868                                         destAddress,
869                                         maxDestAmount,
870                                         minConversionRate,
871                                         walletId
872                                         );
873         require(actualDestAmount > 0);
874 
875         userSrcBalanceAfter = getBalance(src, msg.sender);
876         userDestBalanceAfter = getBalance(dest, destAddress);
877 
878         require(userSrcBalanceAfter <= userSrcBalanceBefore);
879         require(userDestBalanceAfter >= userDestBalanceBefore);
880 
881         require((userDestBalanceAfter - userDestBalanceBefore) >=
882             calcDstQty((userSrcBalanceBefore - userSrcBalanceAfter), getDecimals(src), getDecimals(dest),
883                 minConversionRate));
884 
885         return actualDestAmount;
886     }
887 
888     event AddReserveToNetwork(KyberReserve reserve, bool add);
889 
890     /// @notice can be called only by admin
891     /// @dev add or deletes a reserve to/from the network.
892     /// @param reserve The reserve address.
893     /// @param add If true, the add reserve. Otherwise delete reserve.
894     function addReserve(KyberReserve reserve, bool add) public onlyAdmin {
895 
896         if (add) {
897             require(!isReserve[reserve]);
898             reserves.push(reserve);
899             isReserve[reserve] = true;
900             AddReserveToNetwork(reserve, true);
901         } else {
902             isReserve[reserve] = false;
903             // will have trouble if more than 50k reserves...
904             for (uint i = 0; i < reserves.length; i++) {
905                 if (reserves[i] == reserve) {
906                     reserves[i] = reserves[reserves.length - 1];
907                     reserves.length--;
908                     AddReserveToNetwork(reserve, false);
909                     break;
910                 }
911             }
912         }
913     }
914 
915     event ListReservePairs(address reserve, ERC20 src, ERC20 dest, bool add);
916 
917     /// @notice can be called only by admin
918     /// @dev allow or prevent a specific reserve to trade a pair of tokens
919     /// @param reserve The reserve address.
920     /// @param src Src token
921     /// @param dest Destination token
922     /// @param add If true then enable trade, otherwise delist pair.
923     function listPairForReserve(address reserve, ERC20 src, ERC20 dest, bool add) public onlyAdmin {
924         (perReserveListedPairs[reserve])[keccak256(src, dest)] = add;
925 
926         if (src != ETH_TOKEN_ADDRESS) {
927             if (add) {
928                 src.approve(reserve, 2**255); // approve infinity
929             } else {
930                 src.approve(reserve, 0);
931             }
932         }
933 
934         ListReservePairs(reserve, src, dest, add);
935     }
936 
937     function setParams(
938         WhiteList _whiteList,
939         ExpectedRateInterface _expectedRate,
940         FeeBurnerInterface    _feeBurner,
941         uint                  _maxGasPrice,
942         uint                  _negligibleRateDiff
943     )
944         public
945         onlyAdmin
946     {
947         require(_whiteList != address(0));
948         require(_feeBurner != address(0));
949         require(_expectedRate != address(0));
950         whiteListContract = _whiteList;
951         expectedRateContract = _expectedRate;
952         feeBurnerContract = _feeBurner;
953         maxGasPrice = _maxGasPrice;
954         negligibleRateDiff = _negligibleRateDiff;
955     }
956 
957     function setEnable(bool _enable) public onlyAdmin {
958         if (_enable) {
959             require(whiteListContract != address(0));
960             require(feeBurnerContract != address(0));
961             require(expectedRateContract != address(0));
962         }
963         enabled = _enable;
964     }
965 
966     /// @dev returns number of reserves
967     /// @return number of reserves
968     function getNumReserves() public view returns(uint) {
969         return reserves.length;
970     }
971 
972     /// @notice should be called off chain with as much gas as needed
973     /// @dev get an array of all reserves
974     /// @return An array of all reserves
975     function getReserves() public view returns(KyberReserve[]) {
976         return reserves;
977     }
978 
979     /// @dev get the balance of a user.
980     /// @param token The token type
981     /// @return The balance
982     function getBalance(ERC20 token, address user) public view returns(uint) {
983         if (token == ETH_TOKEN_ADDRESS)
984             return user.balance;
985         else
986             return token.balanceOf(user);
987     }
988 
989     /// @notice use token address ETH_TOKEN_ADDRESS for ether
990     /// @dev best conversion rate for a pair of tokens, if number of reserves have small differences. randomize
991     /// @param src Src token
992     /// @param dest Destination token
993     /* solhint-disable code-complexity */
994     function findBestRate(ERC20 src, ERC20 dest, uint srcQty) public view returns(uint, uint) {
995         uint bestRate = 0;
996         uint bestReserve = 0;
997         uint numRelevantReserves = 0;
998         uint numReserves = reserves.length;
999         uint[] memory rates = new uint[](numReserves);
1000         uint[] memory reserveCandidates = new uint[](numReserves);
1001 
1002         for (uint i = 0; i < numReserves; i++) {
1003             //list all reserves that have this token.
1004             if (!(perReserveListedPairs[reserves[i]])[keccak256(src, dest)]) continue;
1005 
1006             rates[i] = reserves[i].getConversionRate(src, dest, srcQty, block.number);
1007 
1008             if (rates[i] > bestRate) {
1009                 //best rate is highest rate
1010                 bestRate = rates[i];
1011             }
1012         }
1013 
1014         if (bestRate > 0) {
1015             uint random = 0;
1016             uint smallestRelevantRate = (bestRate * 10000) / (10000 + negligibleRateDiff);
1017 
1018             for (i = 0; i < numReserves; i++) {
1019                 if (rates[i] >= smallestRelevantRate) {
1020                     reserveCandidates[numRelevantReserves++] = i;
1021                 }
1022             }
1023 
1024             if (numRelevantReserves > 1) {
1025                 //when encountering small rate diff from bestRate. draw from relevant reserves
1026                 random = uint(block.blockhash(block.number-1)) % numRelevantReserves;
1027             }
1028 
1029             bestReserve = reserveCandidates[random];
1030             bestRate = rates[bestReserve];
1031         }
1032 
1033         return (bestReserve, bestRate);
1034     }
1035     /* solhint-enable code-complexity */
1036 
1037     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
1038         public view
1039         returns (uint expectedRate, uint slippageRate)
1040     {
1041         require(expectedRateContract != address(0));
1042         return expectedRateContract.getExpectedRate(src, dest, srcQty);
1043     }
1044 
1045     function getUserCapInWei(address user) public view returns(uint) {
1046         return whiteListContract.getUserCapInWei(user);
1047     }
1048 
1049     function doTrade(
1050         ERC20 src,
1051         uint srcAmount,
1052         ERC20 dest,
1053         address destAddress,
1054         uint maxDestAmount,
1055         uint minConversionRate,
1056         address walletId
1057     )
1058         internal
1059         returns(uint)
1060     {
1061         require(tx.gasprice <= maxGasPrice);
1062         require(validateTradeInput(src, srcAmount, destAddress));
1063 
1064         uint reserveInd;
1065         uint rate;
1066 
1067         (reserveInd, rate) = findBestRate(src, dest, srcAmount);
1068         KyberReserve theReserve = reserves[reserveInd];
1069         require(rate > 0);
1070         require(rate < MAX_RATE);
1071         require(rate >= minConversionRate);
1072 
1073         uint actualSrcAmount = srcAmount;
1074         uint actualDestAmount = calcDestAmount(src, dest, actualSrcAmount, rate);
1075         if (actualDestAmount > maxDestAmount) {
1076             actualDestAmount = maxDestAmount;
1077             actualSrcAmount = calcSrcAmount(src, dest, actualDestAmount, rate);
1078             require(actualSrcAmount <= srcAmount);
1079         }
1080 
1081         // do the trade
1082         // verify trade size is smaller than user cap
1083         uint ethAmount;
1084         if (src == ETH_TOKEN_ADDRESS) {
1085             ethAmount = actualSrcAmount;
1086         } else {
1087             ethAmount = actualDestAmount;
1088         }
1089 
1090         require(ethAmount <= getUserCapInWei(msg.sender));
1091         require(doReserveTrade(
1092                 src,
1093                 actualSrcAmount,
1094                 dest,
1095                 destAddress,
1096                 actualDestAmount,
1097                 theReserve,
1098                 rate,
1099                 true));
1100 
1101         if ((actualSrcAmount < srcAmount) && (src == ETH_TOKEN_ADDRESS)) {
1102             msg.sender.transfer(srcAmount - actualSrcAmount);
1103         }
1104 
1105         require(feeBurnerContract.handleFees(ethAmount, theReserve, walletId));
1106 
1107         ExecuteTrade(msg.sender, src, dest, actualSrcAmount, actualDestAmount);
1108         return actualDestAmount;
1109     }
1110 
1111     /// @notice use token address ETH_TOKEN_ADDRESS for ether
1112     /// @dev do one trade with a reserve
1113     /// @param src Src token
1114     /// @param amount amount of src tokens
1115     /// @param dest   Destination token
1116     /// @param destAddress Address to send tokens to
1117     /// @param reserve Reserve to use
1118     /// @param validate If true, additional validations are applicable
1119     /// @return true if trade is successful
1120     function doReserveTrade(
1121         ERC20 src,
1122         uint amount,
1123         ERC20 dest,
1124         address destAddress,
1125         uint expectedDestAmount,
1126         KyberReserve reserve,
1127         uint conversionRate,
1128         bool validate
1129     )
1130         internal
1131         returns(bool)
1132     {
1133         uint callValue = 0;
1134 
1135         if (src == ETH_TOKEN_ADDRESS) {
1136             callValue = amount;
1137         } else {
1138             // take src tokens to this contract
1139             src.transferFrom(msg.sender, this, amount);
1140         }
1141 
1142         // reserve sends tokens/eth to network. network sends it to destination
1143         require(reserve.trade.value(callValue)(src, amount, dest, this, conversionRate, validate));
1144 
1145         if (dest == ETH_TOKEN_ADDRESS) {
1146             destAddress.transfer(expectedDestAmount);
1147         } else {
1148             require(dest.transfer(destAddress, expectedDestAmount));
1149         }
1150 
1151         return true;
1152     }
1153 
1154     function getDecimals(ERC20 token) internal view returns(uint) {
1155         if (token == ETH_TOKEN_ADDRESS) return 18;
1156         return token.decimals();
1157     }
1158 
1159     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
1160         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
1161     }
1162 
1163     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
1164         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
1165     }
1166 
1167     /// @notice use token address ETH_TOKEN_ADDRESS for ether
1168     /// @dev checks that user sent ether/tokens to contract before trade
1169     /// @param src Src token
1170     /// @param srcAmount amount of src tokens
1171     /// @return true if input is valid
1172     function validateTradeInput(ERC20 src, uint srcAmount, address destAddress) internal view returns(bool) {
1173         if ((srcAmount >= MAX_QTY) || (srcAmount == 0) || (destAddress == 0))
1174             return false;
1175 
1176         if (src == ETH_TOKEN_ADDRESS) {
1177             if (msg.value != srcAmount)
1178                 return false;
1179         } else {
1180             if ((msg.value != 0) || (src.allowance(msg.sender, this) < srcAmount))
1181                 return false;
1182         }
1183 
1184         return true;
1185     }
1186 }
1187 
1188 contract KyberReserve is Withdrawable, Utils {
1189 
1190     address public kyberNetwork;
1191     bool public tradeEnabled;
1192     ConversionRates public conversionRatesContract;
1193     SanityRatesInterface public sanityRatesContract;
1194     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
1195 
1196     function KyberReserve(address _kyberNetwork, ConversionRates _ratesContract, address _admin) public {
1197         require(_admin != address(0));
1198         require(_ratesContract != address(0));
1199         require(_kyberNetwork != address(0));
1200         kyberNetwork = _kyberNetwork;
1201         conversionRatesContract = _ratesContract;
1202         admin = _admin;
1203         tradeEnabled = true;
1204     }
1205 
1206     event DepositToken(ERC20 token, uint amount);
1207 
1208     function() public payable {
1209         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
1210     }
1211 
1212     event TradeExecute(
1213         address indexed origin,
1214         address src,
1215         uint srcAmount,
1216         address destToken,
1217         uint destAmount,
1218         address destAddress
1219     );
1220 
1221     function trade(
1222         ERC20 srcToken,
1223         uint srcAmount,
1224         ERC20 destToken,
1225         address destAddress,
1226         uint conversionRate,
1227         bool validate
1228     )
1229         public
1230         payable
1231         returns(bool)
1232     {
1233         require(tradeEnabled);
1234         require(msg.sender == kyberNetwork);
1235 
1236         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
1237 
1238         return true;
1239     }
1240 
1241     event TradeEnabled(bool enable);
1242 
1243     function enableTrade() public onlyAdmin returns(bool) {
1244         tradeEnabled = true;
1245         TradeEnabled(true);
1246 
1247         return true;
1248     }
1249 
1250     function disableTrade() public onlyAlerter returns(bool) {
1251         tradeEnabled = false;
1252         TradeEnabled(false);
1253 
1254         return true;
1255     }
1256 
1257     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
1258 
1259     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
1260         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
1261         WithdrawAddressApproved(token, addr, approve);
1262     }
1263 
1264     event WithdrawFunds(ERC20 token, uint amount, address destination);
1265 
1266     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
1267         require(approvedWithdrawAddresses[keccak256(token, destination)]);
1268 
1269         if (token == ETH_TOKEN_ADDRESS) {
1270             destination.transfer(amount);
1271         } else {
1272             require(token.transfer(destination, amount));
1273         }
1274 
1275         WithdrawFunds(token, amount, destination);
1276 
1277         return true;
1278     }
1279 
1280     event SetContractAddresses(address network, address rate, address sanity);
1281 
1282     function setContracts(address _kyberNetwork, ConversionRates _conversionRates, SanityRatesInterface _sanityRates)
1283         public
1284         onlyAdmin
1285     {
1286         require(_kyberNetwork != address(0));
1287         require(_conversionRates != address(0));
1288 
1289         kyberNetwork = _kyberNetwork;
1290         conversionRatesContract = _conversionRates;
1291         sanityRatesContract = _sanityRates;
1292 
1293         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
1294     }
1295 
1296     ////////////////////////////////////////////////////////////////////////////
1297     /// status functions ///////////////////////////////////////////////////////
1298     ////////////////////////////////////////////////////////////////////////////
1299     function getBalance(ERC20 token) public view returns(uint) {
1300         if (token == ETH_TOKEN_ADDRESS)
1301             return this.balance;
1302         else
1303             return token.balanceOf(this);
1304     }
1305 
1306     function getDecimals(ERC20 token) public view returns(uint) {
1307         if (token == ETH_TOKEN_ADDRESS) return 18;
1308         return token.decimals();
1309     }
1310 
1311     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
1312         uint dstDecimals = getDecimals(dest);
1313         uint srcDecimals = getDecimals(src);
1314 
1315         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
1316     }
1317 
1318     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
1319         uint dstDecimals = getDecimals(dest);
1320         uint srcDecimals = getDecimals(src);
1321 
1322         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
1323     }
1324 
1325     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
1326         ERC20 token;
1327         bool  buy;
1328 
1329         if (!tradeEnabled) return 0;
1330 
1331         if (ETH_TOKEN_ADDRESS == src) {
1332             buy = true;
1333             token = dest;
1334         } else if (ETH_TOKEN_ADDRESS == dest) {
1335             buy = false;
1336             token = src;
1337         } else {
1338             return 0; // pair is not listed
1339         }
1340 
1341         uint rate = conversionRatesContract.getRate(token, blockNumber, buy, srcQty);
1342         uint destQty = getDestQty(src, dest, srcQty, rate);
1343 
1344         if (getBalance(dest) < destQty) return 0;
1345 
1346         if (sanityRatesContract != address(0)) {
1347             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
1348             if (rate > sanityRate) return 0;
1349         }
1350 
1351         return rate;
1352     }
1353 
1354     /// @dev do a trade
1355     /// @param srcToken Src token
1356     /// @param srcAmount Amount of src token
1357     /// @param destToken Destination token
1358     /// @param destAddress Destination address to send tokens to
1359     /// @param validate If true, additional validations are applicable
1360     /// @return true iff trade is successful
1361     function doTrade(
1362         ERC20 srcToken,
1363         uint srcAmount,
1364         ERC20 destToken,
1365         address destAddress,
1366         uint conversionRate,
1367         bool validate
1368     )
1369         internal
1370         returns(bool)
1371     {
1372         // can skip validation if done at kyber network level
1373         if (validate) {
1374             require(conversionRate > 0);
1375             if (srcToken == ETH_TOKEN_ADDRESS)
1376                 require(msg.value == srcAmount);
1377             else
1378                 require(msg.value == 0);
1379         }
1380 
1381         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
1382         // sanity check
1383         require(destAmount > 0);
1384 
1385         // add to imbalance
1386         ERC20 token;
1387         int buy;
1388         if (srcToken == ETH_TOKEN_ADDRESS) {
1389             buy = int(destAmount);
1390             token = destToken;
1391         } else {
1392             buy = -1 * int(srcAmount);
1393             token = srcToken;
1394         }
1395 
1396         conversionRatesContract.recordImbalance(
1397             token,
1398             buy,
1399             0,
1400             block.number
1401         );
1402 
1403         // collect src tokens
1404         if (srcToken != ETH_TOKEN_ADDRESS) {
1405             require(srcToken.transferFrom(msg.sender, this, srcAmount));
1406         }
1407 
1408         // send dest tokens
1409         if (destToken == ETH_TOKEN_ADDRESS) {
1410             destAddress.transfer(destAmount);
1411         } else {
1412             require(destToken.transfer(destAddress, destAmount));
1413         }
1414 
1415         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
1416 
1417         return true;
1418     }
1419 }
1420 
1421 contract WhiteList is Withdrawable {
1422 
1423     uint public weiPerSgd; // amount of weis in 1 singapore dollar
1424     mapping (address=>uint) public userCategory; // each user has a category defining cap on trade. 0 for standard.
1425     mapping (uint=>uint)    public categoryCap;  // will define cap on trade amount per category in singapore Dollar.
1426 
1427     function WhiteList(address _admin) public {
1428         require(_admin != address(0));
1429         admin = _admin;
1430     }
1431 
1432     function getUserCapInWei(address user) external view returns (uint userCapWei) {
1433         uint category = userCategory[user];
1434         return (categoryCap[category] * weiPerSgd);
1435     }
1436 
1437     event UserCategorySet(address user, uint category);
1438 
1439     function setUserCategory(address user, uint category) public onlyOperator {
1440         userCategory[user] = category;
1441         UserCategorySet(user, category);
1442     }
1443 
1444     event CategoryCapSet (uint category, uint sgdCap);
1445 
1446     function setCategoryCap(uint category, uint sgdCap) public onlyOperator {
1447         categoryCap[category] = sgdCap;
1448         CategoryCapSet(category, sgdCap);
1449     }
1450 
1451     event SgdToWeiRateSet (uint rate);
1452 
1453     function setSgdToEthRate(uint _sgdToWeiRate) public onlyOperator {
1454         weiPerSgd = _sgdToWeiRate;
1455         SgdToWeiRateSet(_sgdToWeiRate);
1456     }
1457 }
1458 
1459 contract FeeBurner is Withdrawable, FeeBurnerInterface {
1460 
1461     mapping(address=>uint) public reserveFeesInBps;
1462     mapping(address=>address) public reserveKNCWallet;
1463     mapping(address=>uint) public walletFeesInBps;
1464     mapping(address=>uint) public reserveFeeToBurn;
1465     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
1466 
1467     BurnableToken public knc;
1468     address public kyberNetwork;
1469     uint public kncPerETHRate = 300;
1470 
1471     function FeeBurner(address _admin, BurnableToken kncToken) public {
1472         require(_admin != address(0));
1473         require(kncToken != address(0));
1474         admin = _admin;
1475         knc = kncToken;
1476     }
1477 
1478     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
1479         require(feesInBps < 100); // make sure it is always < 1%
1480         require(kncWallet != address(0));
1481         reserveFeesInBps[reserve] = feesInBps;
1482         reserveKNCWallet[reserve] = kncWallet;
1483     }
1484 
1485     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
1486         require(feesInBps < 10000); // under 100%
1487         walletFeesInBps[wallet] = feesInBps;
1488     }
1489 
1490     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
1491         require(_kyberNetwork != address(0));
1492         kyberNetwork = _kyberNetwork;
1493     }
1494 
1495     function setKNCRate(uint rate) public onlyAdmin {
1496         kncPerETHRate = rate;
1497     }
1498 
1499     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
1500     event AssignBurnFees(address reserve, uint burnFee);
1501 
1502     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
1503         require(msg.sender == kyberNetwork);
1504 
1505         uint kncAmount = tradeWeiAmount * kncPerETHRate;
1506         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
1507 
1508         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
1509         require(fee >= walletFee);
1510         uint feeToBurn = fee - walletFee;
1511 
1512         if (walletFee > 0) {
1513             reserveFeeToWallet[reserve][wallet] += walletFee;
1514             AssignFeeToWallet(reserve, wallet, walletFee);
1515         }
1516 
1517         if (feeToBurn > 0) {
1518             AssignBurnFees(reserve, feeToBurn);
1519             reserveFeeToBurn[reserve] += feeToBurn;
1520         }
1521 
1522         return true;
1523     }
1524 
1525     // this function is callable by anyone
1526     event BurnAssignedFees(address indexed reserve, address sender);
1527 
1528     function burnReserveFees(address reserve) public {
1529         uint burnAmount = reserveFeeToBurn[reserve];
1530         require(burnAmount > 1);
1531         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
1532         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
1533 
1534         BurnAssignedFees(reserve, msg.sender);
1535     }
1536 
1537     event SendWalletFees(address indexed wallet, address reserve, address sender);
1538 
1539     // this function is callable by anyone
1540     function sendFeeToWallet(address wallet, address reserve) public {
1541         uint feeAmount = reserveFeeToWallet[reserve][wallet];
1542         require(feeAmount > 1);
1543         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
1544         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
1545 
1546         SendWalletFees(wallet, reserve, msg.sender);
1547     }
1548 }
1549 
1550 contract SanityRates is SanityRatesInterface, Withdrawable, Utils {
1551     mapping(address=>uint) public tokenRate;
1552     mapping(address=>uint) public reasonableDiffInBps;
1553 
1554     function SanityRates(address _admin) public {
1555         require(_admin != address(0));
1556         admin = _admin;
1557     }
1558 
1559     function setReasonableDiff(ERC20[] srcs, uint[] diff) public onlyAdmin {
1560         require(srcs.length == diff.length);
1561         for (uint i = 0; i < srcs.length; i++) {
1562             reasonableDiffInBps[srcs[i]] = diff[i];
1563         }
1564     }
1565 
1566     function setSanityRates(ERC20[] srcs, uint[] rates) public onlyOperator {
1567         require(srcs.length == rates.length);
1568 
1569         for (uint i = 0; i < srcs.length; i++) {
1570             tokenRate[srcs[i]] = rates[i];
1571         }
1572     }
1573 
1574     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint) {
1575         if (src != ETH_TOKEN_ADDRESS && dest != ETH_TOKEN_ADDRESS) return 0;
1576 
1577         uint rate;
1578         address token;
1579         if (src == ETH_TOKEN_ADDRESS) {
1580             rate = (PRECISION*PRECISION)/tokenRate[dest];
1581             token = dest;
1582         } else {
1583             rate = tokenRate[src];
1584             token = src;
1585         }
1586 
1587         return rate * (10000 + reasonableDiffInBps[token])/10000;
1588     }
1589 }