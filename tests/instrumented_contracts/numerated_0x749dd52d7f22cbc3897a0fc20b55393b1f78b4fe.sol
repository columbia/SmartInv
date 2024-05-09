1 pragma solidity 0.4.18;
2 
3 interface SanityRatesInterface {
4     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
5 }
6 
7 contract PermissionGroups {
8 
9     address public admin;
10     address public pendingAdmin;
11     mapping(address=>bool) internal operators;
12     mapping(address=>bool) internal alerters;
13     address[] internal operatorsGroup;
14     address[] internal alertersGroup;
15 
16     function PermissionGroups() public {
17         admin = msg.sender;
18     }
19 
20     modifier onlyAdmin() {
21         require(msg.sender == admin);
22         _;
23     }
24 
25     modifier onlyOperator() {
26         require(operators[msg.sender]);
27         _;
28     }
29 
30     modifier onlyAlerter() {
31         require(alerters[msg.sender]);
32         _;
33     }
34 
35     function getOperators () external view returns(address[]) {
36         return operatorsGroup;
37     }
38 
39     function getAlerters () external view returns(address[]) {
40         return alertersGroup;
41     }
42 
43     event TransferAdminPending(address pendingAdmin);
44 
45     /**
46      * @dev Allows the current admin to set the pendingAdmin address.
47      * @param newAdmin The address to transfer ownership to.
48      */
49     function transferAdmin(address newAdmin) public onlyAdmin {
50         require(newAdmin != address(0));
51         TransferAdminPending(pendingAdmin);
52         pendingAdmin = newAdmin;
53     }
54 
55     event AdminClaimed( address newAdmin, address previousAdmin);
56 
57     /**
58      * @dev Allows the pendingAdmin address to finalize the change admin process.
59      */
60     function claimAdmin() public {
61         require(pendingAdmin == msg.sender);
62         AdminClaimed(pendingAdmin, admin);
63         admin = pendingAdmin;
64         pendingAdmin = address(0);
65     }
66 
67     event AlerterAdded (address newAlerter, bool isAdd);
68 
69     function addAlerter(address newAlerter) public onlyAdmin {
70         require(!alerters[newAlerter]); // prevent duplicates.
71         AlerterAdded(newAlerter, true);
72         alerters[newAlerter] = true;
73         alertersGroup.push(newAlerter);
74     }
75 
76     function removeAlerter (address alerter) public onlyAdmin {
77         require(alerters[alerter]);
78         alerters[alerter] = false;
79 
80         for (uint i = 0; i < alertersGroup.length; ++i) {
81             if (alertersGroup[i] == alerter) {
82                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
83                 alertersGroup.length--;
84                 AlerterAdded(alerter, false);
85                 break;
86             }
87         }
88     }
89 
90     event OperatorAdded(address newOperator, bool isAdd);
91 
92     function addOperator(address newOperator) public onlyAdmin {
93         require(!operators[newOperator]); // prevent duplicates.
94         OperatorAdded(newOperator, true);
95         operators[newOperator] = true;
96         operatorsGroup.push(newOperator);
97     }
98 
99     function removeOperator (address operator) public onlyAdmin {
100         require(operators[operator]);
101         operators[operator] = false;
102 
103         for (uint i = 0; i < operatorsGroup.length; ++i) {
104             if (operatorsGroup[i] == operator) {
105                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
106                 operatorsGroup.length -= 1;
107                 OperatorAdded(operator, false);
108                 break;
109             }
110         }
111     }
112 }
113 
114 contract Withdrawable is PermissionGroups {
115 
116     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
117 
118     /**
119      * @dev Withdraw all ERC20 compatible tokens
120      * @param token ERC20 The address of the token contract
121      */
122     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
123         require(token.transfer(sendTo, amount));
124         TokenWithdraw(token, amount, sendTo);
125     }
126 
127     event EtherWithdraw(uint amount, address sendTo);
128 
129     /**
130      * @dev Withdraw Ethers
131      */
132     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
133         sendTo.transfer(amount);
134         EtherWithdraw(amount, sendTo);
135     }
136 }
137 
138 contract VolumeImbalanceRecorder is Withdrawable {
139 
140     uint constant internal SLIDING_WINDOW_SIZE = 5;
141     uint constant internal POW_2_64 = 2 ** 64;
142 
143     struct TokenControlInfo {
144         uint minimalRecordResolution; // can be roughly 1 cent
145         uint maxPerBlockImbalance; // in twei resolution
146         uint maxTotalImbalance; // max total imbalance (between rate updates)
147                             // before halting trade
148     }
149 
150     mapping(address => TokenControlInfo) internal tokenControlInfo;
151 
152     struct TokenImbalanceData {
153         int  lastBlockBuyUnitsImbalance;
154         uint lastBlock;
155 
156         int  totalBuyUnitsImbalance;
157         uint lastRateUpdateBlock;
158     }
159 
160     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
161 
162     function VolumeImbalanceRecorder(address _admin) public {
163         require(_admin != address(0));
164         admin = _admin;
165     }
166 
167     function setTokenControlInfo(
168         ERC20 token,
169         uint minimalRecordResolution,
170         uint maxPerBlockImbalance,
171         uint maxTotalImbalance
172     )
173         public
174         onlyAdmin
175     {
176         tokenControlInfo[token] =
177             TokenControlInfo(
178                 minimalRecordResolution,
179                 maxPerBlockImbalance,
180                 maxTotalImbalance
181             );
182     }
183 
184     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
185         return (tokenControlInfo[token].minimalRecordResolution,
186                 tokenControlInfo[token].maxPerBlockImbalance,
187                 tokenControlInfo[token].maxTotalImbalance);
188     }
189 
190     function addImbalance(
191         ERC20 token,
192         int buyAmount,
193         uint rateUpdateBlock,
194         uint currentBlock
195     )
196         internal
197     {
198         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
199         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
200 
201         int prevImbalance = 0;
202 
203         TokenImbalanceData memory currentBlockData =
204             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
205 
206         // first scenario - this is not the first tx in the current block
207         if (currentBlockData.lastBlock == currentBlock) {
208             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
209                 // just increase imbalance
210                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
211                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
212             } else {
213                 // imbalance was changed in the middle of the block
214                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
215                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
216                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
217                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
218             }
219         } else {
220             // first tx in the current block
221             int currentBlockImbalance;
222             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
223 
224             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
225             currentBlockData.lastBlock = uint(currentBlock);
226             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
227             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
228         }
229 
230         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
231     }
232 
233     function setGarbageToVolumeRecorder(ERC20 token) internal {
234         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
235             tokenImbalanceData[token][i] = 0x1;
236         }
237     }
238 
239     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
240         // check the imbalance in the sliding window
241         require(startBlock <= endBlock);
242 
243         buyImbalance = 0;
244 
245         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
246             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
247 
248             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
249                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
250             }
251         }
252     }
253 
254     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
255         internal view
256         returns(int buyImbalance, int currentBlockImbalance)
257     {
258         buyImbalance = 0;
259         currentBlockImbalance = 0;
260         uint latestBlock = 0;
261         int imbalanceInRange = 0;
262         uint startBlock = rateUpdateBlock;
263         uint endBlock = currentBlock;
264 
265         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
266             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
267 
268             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
269                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
270             }
271 
272             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
273             if (perBlockData.lastBlock < latestBlock) continue;
274 
275             latestBlock = perBlockData.lastBlock;
276             buyImbalance = perBlockData.totalBuyUnitsImbalance;
277             if (uint(perBlockData.lastBlock) == currentBlock) {
278                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
279             }
280         }
281 
282         if (buyImbalance == 0) {
283             buyImbalance = imbalanceInRange;
284         }
285     }
286 
287     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
288         internal view
289         returns(int totalImbalance, int currentBlockImbalance)
290     {
291 
292         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
293 
294         (totalImbalance, currentBlockImbalance) =
295             getImbalanceSinceRateUpdate(
296                 token,
297                 rateUpdateBlock,
298                 currentBlock);
299 
300         totalImbalance *= resolution;
301         currentBlockImbalance *= resolution;
302     }
303 
304     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
305         return tokenControlInfo[token].maxPerBlockImbalance;
306     }
307 
308     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
309         return tokenControlInfo[token].maxTotalImbalance;
310     }
311 
312     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
313         // check for overflows
314         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
315         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
316         require(data.lastBlock < POW_2_64);
317         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
318         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
319         require(data.lastRateUpdateBlock < POW_2_64);
320 
321         // do encoding
322         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
323         result |= data.lastBlock * POW_2_64;
324         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
325         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
326 
327         return result;
328     }
329 
330     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
331         TokenImbalanceData memory data;
332 
333         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
334         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
335         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
336         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
337 
338         return data;
339     }
340 }
341 
342 contract Utils {
343 
344     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
345     uint  constant internal PRECISION = (10**18);
346     uint  constant internal MAX_QTY   = (10**28); // 1B tokens
347     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
348     uint  constant internal MAX_DECIMALS = 18;
349 
350     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
351         if (dstDecimals >= srcDecimals) {
352             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
353             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
354         } else {
355             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
356             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
357         }
358     }
359 
360     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
361         //source quantity is rounded up. to avoid dest quantity being too low.
362         uint numerator;
363         uint denominator;
364         if (srcDecimals >= dstDecimals) {
365             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
366             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
367             denominator = rate;
368         } else {
369             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
370             numerator = (PRECISION * dstQty);
371             denominator = (rate * (10**(dstDecimals - srcDecimals)));
372         }
373         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
374     }
375 }
376 
377 contract ConversionRates is VolumeImbalanceRecorder, Utils {
378 
379     // bps - basic rate steps. one step is 1 / 10000 of the rate.
380     struct StepFunction {
381         int[] x; // quantity for each step. Quantity of each step includes previous steps.
382         int[] y; // rate change per quantity step  in bps.
383     }
384 
385     struct TokenData {
386         bool listed;  // was added to reserve
387         bool enabled; // whether trade is enabled
388 
389         // position in the compact data
390         uint compactDataArrayIndex;
391         uint compactDataFieldIndex;
392 
393         // rate data. base and changes according to quantity and reserve balance.
394         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
395         uint baseBuyRate;  // in PRECISION units. see KyberConstants
396         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
397         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
398         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
399         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
400         StepFunction sellRateImbalanceStepFunction;
401     }
402 
403     /*
404     this is the data for tokenRatesCompactData
405     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
406     so we represent it as bytes32 and do the byte tricks ourselves.
407     struct TokenRatesCompactData {
408         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
409         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
410 
411         uint32 blockNumber;
412     } */
413     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
414     ERC20[] internal listedTokens;
415     mapping(address=>TokenData) internal tokenData;
416     bytes32[] internal tokenRatesCompactData;
417     uint public numTokensInCurrentCompactData = 0;
418     address public reserveContract;
419     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
420     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
421 
422     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
423         { } // solhint-disable-line no-empty-blocks
424 
425     function addToken(ERC20 token) public onlyAdmin {
426 
427         require(!tokenData[token].listed);
428         tokenData[token].listed = true;
429         listedTokens.push(token);
430 
431         if (numTokensInCurrentCompactData == 0) {
432             tokenRatesCompactData.length++; // add new structure
433         }
434 
435         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
436         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
437 
438         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
439 
440         setGarbageToVolumeRecorder(token);
441     }
442 
443     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
444 
445         require(buy.length == sell.length);
446         require(indices.length == buy.length);
447         require(blockNumber <= 0xFFFFFFFF);
448 
449         uint bytes14Offset = BYTES_14_OFFSET;
450 
451         for (uint i = 0; i < indices.length; i++) {
452             require(indices[i] < tokenRatesCompactData.length);
453             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
454             tokenRatesCompactData[indices[i]] = bytes32(data);
455         }
456     }
457 
458     function setBaseRate(
459         ERC20[] tokens,
460         uint[] baseBuy,
461         uint[] baseSell,
462         bytes14[] buy,
463         bytes14[] sell,
464         uint blockNumber,
465         uint[] indices
466     )
467         public
468         onlyOperator
469     {
470         require(tokens.length == baseBuy.length);
471         require(tokens.length == baseSell.length);
472         require(sell.length == buy.length);
473         require(sell.length == indices.length);
474 
475         for (uint ind = 0; ind < tokens.length; ind++) {
476             require(tokenData[tokens[ind]].listed);
477             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
478             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
479         }
480 
481         setCompactData(buy, sell, blockNumber, indices);
482     }
483 
484     function setQtyStepFunction(
485         ERC20 token,
486         int[] xBuy,
487         int[] yBuy,
488         int[] xSell,
489         int[] ySell
490     )
491         public
492         onlyOperator
493     {
494         require(xBuy.length == yBuy.length);
495         require(xSell.length == ySell.length);
496         require(tokenData[token].listed);
497 
498         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
499         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
500     }
501 
502     function setImbalanceStepFunction(
503         ERC20 token,
504         int[] xBuy,
505         int[] yBuy,
506         int[] xSell,
507         int[] ySell
508     )
509         public
510         onlyOperator
511     {
512         require(xBuy.length == yBuy.length);
513         require(xSell.length == ySell.length);
514         require(tokenData[token].listed);
515 
516         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
517         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
518     }
519 
520     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
521         validRateDurationInBlocks = duration;
522     }
523 
524     function enableTokenTrade(ERC20 token) public onlyAdmin {
525         require(tokenData[token].listed);
526         require(tokenControlInfo[token].minimalRecordResolution != 0);
527         tokenData[token].enabled = true;
528     }
529 
530     function disableTokenTrade(ERC20 token) public onlyAlerter {
531         require(tokenData[token].listed);
532         tokenData[token].enabled = false;
533     }
534 
535     function setReserveAddress(address reserve) public onlyAdmin {
536         reserveContract = reserve;
537     }
538 
539     function recordImbalance(
540         ERC20 token,
541         int buyAmount,
542         uint rateUpdateBlock,
543         uint currentBlock
544     )
545         public
546     {
547         require(msg.sender == reserveContract);
548 
549         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
550 
551         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
552     }
553 
554     /* solhint-disable function-max-lines */
555     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
556         // check if trade is enabled
557         if (!tokenData[token].enabled) return 0;
558         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
559 
560         // get rate update block
561         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
562 
563         uint updateRateBlock = getLast4Bytes(compactData);
564         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
565         // check imbalance
566         int totalImbalance;
567         int blockImbalance;
568         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
569 
570         // calculate actual rate
571         int imbalanceQty;
572         int extraBps;
573         int8 rateUpdate;
574         uint rate;
575 
576         if (buy) {
577             // start with base rate
578             rate = tokenData[token].baseBuyRate;
579 
580             // add rate update
581             rateUpdate = getRateByteFromCompactData(compactData, token, true);
582             extraBps = int(rateUpdate) * 10;
583             rate = addBps(rate, extraBps);
584 
585             // compute token qty
586             qty = getTokenQty(token, rate, qty);
587             imbalanceQty = int(qty);
588             totalImbalance += imbalanceQty;
589 
590             // add qty overhead
591             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
592             rate = addBps(rate, extraBps);
593 
594             // add imbalance overhead
595             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
596             rate = addBps(rate, extraBps);
597         } else {
598             // start with base rate
599             rate = tokenData[token].baseSellRate;
600 
601             // add rate update
602             rateUpdate = getRateByteFromCompactData(compactData, token, false);
603             extraBps = int(rateUpdate) * 10;
604             rate = addBps(rate, extraBps);
605 
606             // compute token qty
607             imbalanceQty = -1 * int(qty);
608             totalImbalance += imbalanceQty;
609 
610             // add qty overhead
611             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
612             rate = addBps(rate, extraBps);
613 
614             // add imbalance overhead
615             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
616             rate = addBps(rate, extraBps);
617         }
618 
619         if (abs(totalImbalance + imbalanceQty) >= getMaxTotalImbalance(token)) return 0;
620         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
621 
622         return rate;
623     }
624     /* solhint-enable function-max-lines */
625 
626     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
627         if (buy)
628             return tokenData[token].baseBuyRate;
629         else
630             return tokenData[token].baseSellRate;
631     }
632 
633     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
634         uint arrayIndex = tokenData[token].compactDataArrayIndex;
635         uint fieldOffset = tokenData[token].compactDataFieldIndex;
636 
637         return (
638             arrayIndex,
639             fieldOffset,
640             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
641             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
642         );
643     }
644 
645     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
646         return (tokenData[token].listed, tokenData[token].enabled);
647     }
648 
649     /* solhint-disable code-complexity */
650     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
651         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
652         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
653         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
654         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
655 
656         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
657         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
658         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
659         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
660 
661         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
662         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
663         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
664         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
665 
666         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
667         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
668         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
669         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
670 
671         revert();
672     }
673     /* solhint-enable code-complexity */
674 
675     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
676         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
677         return getLast4Bytes(compactData);
678     }
679 
680     function getListedTokens() public view returns(ERC20[]) {
681         return listedTokens;
682     }
683 
684     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
685         uint dstDecimals = token.decimals();
686         uint srcDecimals = 18;
687 
688         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
689     }
690 
691     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
692         // cannot trust compiler with not turning bit operations into EXP opcode
693         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
694     }
695 
696     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
697         uint fieldOffset = tokenData[token].compactDataFieldIndex;
698         uint byteOffset;
699         if (buy)
700             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
701         else
702             byteOffset = 4 + fieldOffset;
703 
704         return int8(data[byteOffset]);
705     }
706 
707     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
708         uint len = f.y.length;
709         for (uint ind = 0; ind < len; ind++) {
710             if (x <= f.x[ind]) return f.y[ind];
711         }
712 
713         return f.y[len-1];
714     }
715 
716     function addBps(uint rate, int bps) internal pure returns(uint) {
717         uint maxBps = 100 * 100;
718         return (rate * uint(int(maxBps) + bps)) / maxBps;
719     }
720 
721     function abs(int x) internal pure returns(uint) {
722         if (x < 0)
723             return uint(-1 * x);
724         else
725             return uint(x);
726     }
727 }
728 
729 contract KyberReserve is Withdrawable, Utils {
730 
731     address public kyberNetwork;
732     bool public tradeEnabled;
733     ConversionRates public conversionRatesContract;
734     SanityRatesInterface public sanityRatesContract;
735     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
736 
737     function KyberReserve(address _kyberNetwork, ConversionRates _ratesContract, address _admin) public {
738         require(_admin != address(0));
739         require(_ratesContract != address(0));
740         require(_kyberNetwork != address(0));
741         kyberNetwork = _kyberNetwork;
742         conversionRatesContract = _ratesContract;
743         admin = _admin;
744         tradeEnabled = true;
745     }
746 
747     event DepositToken(ERC20 token, uint amount);
748 
749     function() public payable {
750         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
751     }
752 
753     event TradeExecute(
754         address indexed origin,
755         address src,
756         uint srcAmount,
757         address destToken,
758         uint destAmount,
759         address destAddress
760     );
761 
762     function trade(
763         ERC20 srcToken,
764         uint srcAmount,
765         ERC20 destToken,
766         address destAddress,
767         uint conversionRate,
768         bool validate
769     )
770         public
771         payable
772         returns(bool)
773     {
774         require(tradeEnabled);
775         require(msg.sender == kyberNetwork);
776 
777         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
778 
779         return true;
780     }
781 
782     event TradeEnabled(bool enable);
783 
784     function enableTrade() public onlyAdmin returns(bool) {
785         tradeEnabled = true;
786         TradeEnabled(true);
787 
788         return true;
789     }
790 
791     function disableTrade() public onlyAlerter returns(bool) {
792         tradeEnabled = false;
793         TradeEnabled(false);
794 
795         return true;
796     }
797 
798     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
799 
800     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
801         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
802         WithdrawAddressApproved(token, addr, approve);
803     }
804 
805     event WithdrawFunds(ERC20 token, uint amount, address destination);
806 
807     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
808         require(approvedWithdrawAddresses[keccak256(token, destination)]);
809 
810         if (token == ETH_TOKEN_ADDRESS) {
811             destination.transfer(amount);
812         } else {
813             require(token.transfer(destination, amount));
814         }
815 
816         WithdrawFunds(token, amount, destination);
817 
818         return true;
819     }
820 
821     event SetContractAddresses(address network, address rate, address sanity);
822 
823     function setContracts(address _kyberNetwork, ConversionRates _conversionRates, SanityRatesInterface _sanityRates)
824         public
825         onlyAdmin
826     {
827         require(_kyberNetwork != address(0));
828         require(_conversionRates != address(0));
829 
830         kyberNetwork = _kyberNetwork;
831         conversionRatesContract = _conversionRates;
832         sanityRatesContract = _sanityRates;
833 
834         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
835     }
836 
837     ////////////////////////////////////////////////////////////////////////////
838     /// status functions ///////////////////////////////////////////////////////
839     ////////////////////////////////////////////////////////////////////////////
840     function getBalance(ERC20 token) public view returns(uint) {
841         if (token == ETH_TOKEN_ADDRESS)
842             return this.balance;
843         else
844             return token.balanceOf(this);
845     }
846 
847     function getDecimals(ERC20 token) public view returns(uint) {
848         if (token == ETH_TOKEN_ADDRESS) return 18;
849         return token.decimals();
850     }
851 
852     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
853         uint dstDecimals = getDecimals(dest);
854         uint srcDecimals = getDecimals(src);
855 
856         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
857     }
858 
859     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
860         uint dstDecimals = getDecimals(dest);
861         uint srcDecimals = getDecimals(src);
862 
863         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
864     }
865 
866     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
867         ERC20 token;
868         bool  buy;
869 
870         if (!tradeEnabled) return 0;
871 
872         if (ETH_TOKEN_ADDRESS == src) {
873             buy = true;
874             token = dest;
875         } else if (ETH_TOKEN_ADDRESS == dest) {
876             buy = false;
877             token = src;
878         } else {
879             return 0; // pair is not listed
880         }
881 
882         uint rate = conversionRatesContract.getRate(token, blockNumber, buy, srcQty);
883         uint destQty = getDestQty(src, dest, srcQty, rate);
884 
885         if (getBalance(dest) < destQty) return 0;
886 
887         if (sanityRatesContract != address(0)) {
888             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
889             if (rate > sanityRate) return 0;
890         }
891 
892         return rate;
893     }
894 
895     /// @dev do a trade
896     /// @param srcToken Src token
897     /// @param srcAmount Amount of src token
898     /// @param destToken Destination token
899     /// @param destAddress Destination address to send tokens to
900     /// @param validate If true, additional validations are applicable
901     /// @return true iff trade is successful
902     function doTrade(
903         ERC20 srcToken,
904         uint srcAmount,
905         ERC20 destToken,
906         address destAddress,
907         uint conversionRate,
908         bool validate
909     )
910         internal
911         returns(bool)
912     {
913         // can skip validation if done at kyber network level
914         if (validate) {
915             require(conversionRate > 0);
916             if (srcToken == ETH_TOKEN_ADDRESS)
917                 require(msg.value == srcAmount);
918             else
919                 require(msg.value == 0);
920         }
921 
922         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
923         // sanity check
924         require(destAmount > 0);
925 
926         // add to imbalance
927         ERC20 token;
928         int buy;
929         if (srcToken == ETH_TOKEN_ADDRESS) {
930             buy = int(destAmount);
931             token = destToken;
932         } else {
933             buy = -1 * int(srcAmount);
934             token = srcToken;
935         }
936 
937         conversionRatesContract.recordImbalance(
938             token,
939             buy,
940             0,
941             block.number
942         );
943 
944         // collect src tokens
945         if (srcToken != ETH_TOKEN_ADDRESS) {
946             require(srcToken.transferFrom(msg.sender, this, srcAmount));
947         }
948 
949         // send dest tokens
950         if (destToken == ETH_TOKEN_ADDRESS) {
951             destAddress.transfer(destAmount);
952         } else {
953             require(destToken.transfer(destAddress, destAmount));
954         }
955 
956         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
957 
958         return true;
959     }
960 }
961 
962 interface ERC20 {
963     function totalSupply() public view returns (uint supply);
964     function balanceOf(address _owner) public view returns (uint balance);
965     function transfer(address _to, uint _value) public returns (bool success);
966     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
967     function approve(address _spender, uint _value) public returns (bool success);
968     function allowance(address _owner, address _spender) public view returns (uint remaining);
969     function decimals() public view returns(uint digits);
970     event Approval(address indexed _owner, address indexed _spender, uint _value);
971 }
972 
973 contract SanityRates is SanityRatesInterface, Withdrawable, Utils {
974     mapping(address=>uint) public tokenRate;
975     mapping(address=>uint) public reasonableDiffInBps;
976 
977     function SanityRates(address _admin) public {
978         require(_admin != address(0));
979         admin = _admin;
980     }
981 
982     function setReasonableDiff(ERC20[] srcs, uint[] diff) public onlyAdmin {
983         require(srcs.length == diff.length);
984         for (uint i = 0; i < srcs.length; i++) {
985             reasonableDiffInBps[srcs[i]] = diff[i];
986         }
987     }
988 
989     function setSanityRates(ERC20[] srcs, uint[] rates) public onlyOperator {
990         require(srcs.length == rates.length);
991 
992         for (uint i = 0; i < srcs.length; i++) {
993             tokenRate[srcs[i]] = rates[i];
994         }
995     }
996 
997     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint) {
998         if (src != ETH_TOKEN_ADDRESS && dest != ETH_TOKEN_ADDRESS) return 0;
999 
1000         uint rate;
1001         address token;
1002         if (src == ETH_TOKEN_ADDRESS) {
1003             rate = (PRECISION*PRECISION)/tokenRate[dest];
1004             token = dest;
1005         } else {
1006             rate = tokenRate[src];
1007             token = src;
1008         }
1009 
1010         return rate * (10000 + reasonableDiffInBps[token])/10000;
1011     }
1012 }