1 pragma solidity 0.4.18;
2 
3 interface ConversionRatesInterface {
4 
5     function recordImbalance(
6         ERC20 token,
7         int buyAmount,
8         uint rateUpdateBlock,
9         uint currentBlock
10     )
11         public;
12 
13     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
14 }
15 
16 contract Utils {
17 
18     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
19     uint  constant internal PRECISION = (10**18);
20     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
21     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
22     uint  constant internal MAX_DECIMALS = 18;
23     uint  constant internal ETH_DECIMALS = 18;
24     mapping(address=>uint) internal decimals;
25 
26     function setDecimals(ERC20 token) internal {
27         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
28         else decimals[token] = token.decimals();
29     }
30 
31     function getDecimals(ERC20 token) internal view returns(uint) {
32         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
33         uint tokenDecimals = decimals[token];
34         // technically, there might be token with decimals 0
35         // moreover, very possible that old tokens have decimals 0
36         // these tokens will just have higher gas fees.
37         if(tokenDecimals == 0) return token.decimals();
38 
39         return tokenDecimals;
40     }
41 
42     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
43         require(srcQty <= MAX_QTY);
44         require(rate <= MAX_RATE);
45 
46         if (dstDecimals >= srcDecimals) {
47             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
48             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
49         } else {
50             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
51             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
52         }
53     }
54 
55     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
56         require(dstQty <= MAX_QTY);
57         require(rate <= MAX_RATE);
58 
59         //source quantity is rounded up. to avoid dest quantity being too low.
60         uint numerator;
61         uint denominator;
62         if (srcDecimals >= dstDecimals) {
63             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
64             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
65             denominator = rate;
66         } else {
67             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
68             numerator = (PRECISION * dstQty);
69             denominator = (rate * (10**(dstDecimals - srcDecimals)));
70         }
71         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
72     }
73 }
74 
75 contract PermissionGroups {
76 
77     address public admin;
78     address public pendingAdmin;
79     mapping(address=>bool) internal operators;
80     mapping(address=>bool) internal alerters;
81     address[] internal operatorsGroup;
82     address[] internal alertersGroup;
83     uint constant internal MAX_GROUP_SIZE = 50;
84 
85     function PermissionGroups() public {
86         admin = msg.sender;
87     }
88 
89     modifier onlyAdmin() {
90         require(msg.sender == admin);
91         _;
92     }
93 
94     modifier onlyOperator() {
95         require(operators[msg.sender]);
96         _;
97     }
98 
99     modifier onlyAlerter() {
100         require(alerters[msg.sender]);
101         _;
102     }
103 
104     function getOperators () external view returns(address[]) {
105         return operatorsGroup;
106     }
107 
108     function getAlerters () external view returns(address[]) {
109         return alertersGroup;
110     }
111 
112     event TransferAdminPending(address pendingAdmin);
113 
114     /**
115      * @dev Allows the current admin to set the pendingAdmin address.
116      * @param newAdmin The address to transfer ownership to.
117      */
118     function transferAdmin(address newAdmin) public onlyAdmin {
119         require(newAdmin != address(0));
120         TransferAdminPending(pendingAdmin);
121         pendingAdmin = newAdmin;
122     }
123 
124     /**
125      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
126      * @param newAdmin The address to transfer ownership to.
127      */
128     function transferAdminQuickly(address newAdmin) public onlyAdmin {
129         require(newAdmin != address(0));
130         TransferAdminPending(newAdmin);
131         AdminClaimed(newAdmin, admin);
132         admin = newAdmin;
133     }
134 
135     event AdminClaimed( address newAdmin, address previousAdmin);
136 
137     /**
138      * @dev Allows the pendingAdmin address to finalize the change admin process.
139      */
140     function claimAdmin() public {
141         require(pendingAdmin == msg.sender);
142         AdminClaimed(pendingAdmin, admin);
143         admin = pendingAdmin;
144         pendingAdmin = address(0);
145     }
146 
147     event AlerterAdded (address newAlerter, bool isAdd);
148 
149     function addAlerter(address newAlerter) public onlyAdmin {
150         require(!alerters[newAlerter]); // prevent duplicates.
151         require(alertersGroup.length < MAX_GROUP_SIZE);
152 
153         AlerterAdded(newAlerter, true);
154         alerters[newAlerter] = true;
155         alertersGroup.push(newAlerter);
156     }
157 
158     function removeAlerter (address alerter) public onlyAdmin {
159         require(alerters[alerter]);
160         alerters[alerter] = false;
161 
162         for (uint i = 0; i < alertersGroup.length; ++i) {
163             if (alertersGroup[i] == alerter) {
164                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
165                 alertersGroup.length--;
166                 AlerterAdded(alerter, false);
167                 break;
168             }
169         }
170     }
171 
172     event OperatorAdded(address newOperator, bool isAdd);
173 
174     function addOperator(address newOperator) public onlyAdmin {
175         require(!operators[newOperator]); // prevent duplicates.
176         require(operatorsGroup.length < MAX_GROUP_SIZE);
177 
178         OperatorAdded(newOperator, true);
179         operators[newOperator] = true;
180         operatorsGroup.push(newOperator);
181     }
182 
183     function removeOperator (address operator) public onlyAdmin {
184         require(operators[operator]);
185         operators[operator] = false;
186 
187         for (uint i = 0; i < operatorsGroup.length; ++i) {
188             if (operatorsGroup[i] == operator) {
189                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
190                 operatorsGroup.length -= 1;
191                 OperatorAdded(operator, false);
192                 break;
193             }
194         }
195     }
196 }
197 
198 contract Withdrawable is PermissionGroups {
199 
200     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
201 
202     /**
203      * @dev Withdraw all ERC20 compatible tokens
204      * @param token ERC20 The address of the token contract
205      */
206     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
207         require(token.transfer(sendTo, amount));
208         TokenWithdraw(token, amount, sendTo);
209     }
210 
211     event EtherWithdraw(uint amount, address sendTo);
212 
213     /**
214      * @dev Withdraw Ethers
215      */
216     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
217         sendTo.transfer(amount);
218         EtherWithdraw(amount, sendTo);
219     }
220 }
221 
222 contract VolumeImbalanceRecorder is Withdrawable {
223 
224     uint constant internal SLIDING_WINDOW_SIZE = 5;
225     uint constant internal POW_2_64 = 2 ** 64;
226 
227     struct TokenControlInfo {
228         uint minimalRecordResolution; // can be roughly 1 cent
229         uint maxPerBlockImbalance; // in twei resolution
230         uint maxTotalImbalance; // max total imbalance (between rate updates)
231                             // before halting trade
232     }
233 
234     mapping(address => TokenControlInfo) internal tokenControlInfo;
235 
236     struct TokenImbalanceData {
237         int  lastBlockBuyUnitsImbalance;
238         uint lastBlock;
239 
240         int  totalBuyUnitsImbalance;
241         uint lastRateUpdateBlock;
242     }
243 
244     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
245 
246     function VolumeImbalanceRecorder(address _admin) public {
247         require(_admin != address(0));
248         admin = _admin;
249     }
250 
251     function setTokenControlInfo(
252         ERC20 token,
253         uint minimalRecordResolution,
254         uint maxPerBlockImbalance,
255         uint maxTotalImbalance
256     )
257         public
258         onlyAdmin
259     {
260         tokenControlInfo[token] =
261             TokenControlInfo(
262                 minimalRecordResolution,
263                 maxPerBlockImbalance,
264                 maxTotalImbalance
265             );
266     }
267 
268     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
269         return (tokenControlInfo[token].minimalRecordResolution,
270                 tokenControlInfo[token].maxPerBlockImbalance,
271                 tokenControlInfo[token].maxTotalImbalance);
272     }
273 
274     function addImbalance(
275         ERC20 token,
276         int buyAmount,
277         uint rateUpdateBlock,
278         uint currentBlock
279     )
280         internal
281     {
282         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
283         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
284 
285         int prevImbalance = 0;
286 
287         TokenImbalanceData memory currentBlockData =
288             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
289 
290         // first scenario - this is not the first tx in the current block
291         if (currentBlockData.lastBlock == currentBlock) {
292             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
293                 // just increase imbalance
294                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
295                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
296             } else {
297                 // imbalance was changed in the middle of the block
298                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
299                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
300                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
301                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
302             }
303         } else {
304             // first tx in the current block
305             int currentBlockImbalance;
306             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
307 
308             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
309             currentBlockData.lastBlock = uint(currentBlock);
310             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
311             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
312         }
313 
314         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
315     }
316 
317     function setGarbageToVolumeRecorder(ERC20 token) internal {
318         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
319             tokenImbalanceData[token][i] = 0x1;
320         }
321     }
322 
323     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
324         // check the imbalance in the sliding window
325         require(startBlock <= endBlock);
326 
327         buyImbalance = 0;
328 
329         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
330             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
331 
332             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
333                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
334             }
335         }
336     }
337 
338     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
339         internal view
340         returns(int buyImbalance, int currentBlockImbalance)
341     {
342         buyImbalance = 0;
343         currentBlockImbalance = 0;
344         uint latestBlock = 0;
345         int imbalanceInRange = 0;
346         uint startBlock = rateUpdateBlock;
347         uint endBlock = currentBlock;
348 
349         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
350             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
351 
352             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
353                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
354             }
355 
356             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
357             if (perBlockData.lastBlock < latestBlock) continue;
358 
359             latestBlock = perBlockData.lastBlock;
360             buyImbalance = perBlockData.totalBuyUnitsImbalance;
361             if (uint(perBlockData.lastBlock) == currentBlock) {
362                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
363             }
364         }
365 
366         if (buyImbalance == 0) {
367             buyImbalance = imbalanceInRange;
368         }
369     }
370 
371     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
372         internal view
373         returns(int totalImbalance, int currentBlockImbalance)
374     {
375 
376         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
377 
378         (totalImbalance, currentBlockImbalance) =
379             getImbalanceSinceRateUpdate(
380                 token,
381                 rateUpdateBlock,
382                 currentBlock);
383 
384         totalImbalance *= resolution;
385         currentBlockImbalance *= resolution;
386     }
387 
388     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
389         return tokenControlInfo[token].maxPerBlockImbalance;
390     }
391 
392     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
393         return tokenControlInfo[token].maxTotalImbalance;
394     }
395 
396     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
397         // check for overflows
398         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
399         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
400         require(data.lastBlock < POW_2_64);
401         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
402         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
403         require(data.lastRateUpdateBlock < POW_2_64);
404 
405         // do encoding
406         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
407         result |= data.lastBlock * POW_2_64;
408         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
409         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
410 
411         return result;
412     }
413 
414     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
415         TokenImbalanceData memory data;
416 
417         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
418         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
419         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
420         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
421 
422         return data;
423     }
424 }
425 
426 contract ConversionRates is ConversionRatesInterface, VolumeImbalanceRecorder, Utils {
427 
428     // bps - basic rate steps. one step is 1 / 10000 of the rate.
429     struct StepFunction {
430         int[] x; // quantity for each step. Quantity of each step includes previous steps.
431         int[] y; // rate change per quantity step  in bps.
432     }
433 
434     struct TokenData {
435         bool listed;  // was added to reserve
436         bool enabled; // whether trade is enabled
437 
438         // position in the compact data
439         uint compactDataArrayIndex;
440         uint compactDataFieldIndex;
441 
442         // rate data. base and changes according to quantity and reserve balance.
443         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
444         uint baseBuyRate;  // in PRECISION units. see KyberConstants
445         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
446         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
447         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
448         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
449         StepFunction sellRateImbalanceStepFunction;
450     }
451 
452     /*
453     this is the data for tokenRatesCompactData
454     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
455     so we represent it as bytes32 and do the byte tricks ourselves.
456     struct TokenRatesCompactData {
457         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
458         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
459 
460         uint32 blockNumber;
461     } */
462     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
463     ERC20[] internal listedTokens;
464     mapping(address=>TokenData) internal tokenData;
465     bytes32[] internal tokenRatesCompactData;
466     uint public numTokensInCurrentCompactData = 0;
467     address public reserveContract;
468     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
469     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
470 
471     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
472         { } // solhint-disable-line no-empty-blocks
473 
474     function addToken(ERC20 token) public onlyAdmin {
475 
476         require(!tokenData[token].listed);
477         tokenData[token].listed = true;
478         listedTokens.push(token);
479 
480         if (numTokensInCurrentCompactData == 0) {
481             tokenRatesCompactData.length++; // add new structure
482         }
483 
484         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
485         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
486 
487         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
488 
489         setGarbageToVolumeRecorder(token);
490 
491         setDecimals(token);
492     }
493 
494     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
495 
496         require(buy.length == sell.length);
497         require(indices.length == buy.length);
498         require(blockNumber <= 0xFFFFFFFF);
499 
500         uint bytes14Offset = BYTES_14_OFFSET;
501 
502         for (uint i = 0; i < indices.length; i++) {
503             require(indices[i] < tokenRatesCompactData.length);
504             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
505             tokenRatesCompactData[indices[i]] = bytes32(data);
506         }
507     }
508 
509     function setBaseRate(
510         ERC20[] tokens,
511         uint[] baseBuy,
512         uint[] baseSell,
513         bytes14[] buy,
514         bytes14[] sell,
515         uint blockNumber,
516         uint[] indices
517     )
518         public
519         onlyOperator
520     {
521         require(tokens.length == baseBuy.length);
522         require(tokens.length == baseSell.length);
523         require(sell.length == buy.length);
524         require(sell.length == indices.length);
525 
526         for (uint ind = 0; ind < tokens.length; ind++) {
527             require(tokenData[tokens[ind]].listed);
528             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
529             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
530         }
531 
532         setCompactData(buy, sell, blockNumber, indices);
533     }
534 
535     function setQtyStepFunction(
536         ERC20 token,
537         int[] xBuy,
538         int[] yBuy,
539         int[] xSell,
540         int[] ySell
541     )
542         public
543         onlyOperator
544     {
545         require(xBuy.length == yBuy.length);
546         require(xSell.length == ySell.length);
547         require(tokenData[token].listed);
548 
549         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
550         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
551     }
552 
553     function setImbalanceStepFunction(
554         ERC20 token,
555         int[] xBuy,
556         int[] yBuy,
557         int[] xSell,
558         int[] ySell
559     )
560         public
561         onlyOperator
562     {
563         require(xBuy.length == yBuy.length);
564         require(xSell.length == ySell.length);
565         require(tokenData[token].listed);
566 
567         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
568         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
569     }
570 
571     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
572         validRateDurationInBlocks = duration;
573     }
574 
575     function enableTokenTrade(ERC20 token) public onlyAdmin {
576         require(tokenData[token].listed);
577         require(tokenControlInfo[token].minimalRecordResolution != 0);
578         tokenData[token].enabled = true;
579     }
580 
581     function disableTokenTrade(ERC20 token) public onlyAlerter {
582         require(tokenData[token].listed);
583         tokenData[token].enabled = false;
584     }
585 
586     function setReserveAddress(address reserve) public onlyAdmin {
587         reserveContract = reserve;
588     }
589 
590     function recordImbalance(
591         ERC20 token,
592         int buyAmount,
593         uint rateUpdateBlock,
594         uint currentBlock
595     )
596         public
597     {
598         require(msg.sender == reserveContract);
599 
600         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
601 
602         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
603     }
604 
605     /* solhint-disable function-max-lines */
606     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
607         // check if trade is enabled
608         if (!tokenData[token].enabled) return 0;
609         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
610 
611         // get rate update block
612         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
613 
614         uint updateRateBlock = getLast4Bytes(compactData);
615         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
616         // check imbalance
617         int totalImbalance;
618         int blockImbalance;
619         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
620 
621         // calculate actual rate
622         int imbalanceQty;
623         int extraBps;
624         int8 rateUpdate;
625         uint rate;
626 
627         if (buy) {
628             // start with base rate
629             rate = tokenData[token].baseBuyRate;
630 
631             // add rate update
632             rateUpdate = getRateByteFromCompactData(compactData, token, true);
633             extraBps = int(rateUpdate) * 10;
634             rate = addBps(rate, extraBps);
635 
636             // compute token qty
637             qty = getTokenQty(token, rate, qty);
638             imbalanceQty = int(qty);
639             totalImbalance += imbalanceQty;
640 
641             // add qty overhead
642             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
643             rate = addBps(rate, extraBps);
644 
645             // add imbalance overhead
646             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
647             rate = addBps(rate, extraBps);
648         } else {
649             // start with base rate
650             rate = tokenData[token].baseSellRate;
651 
652             // add rate update
653             rateUpdate = getRateByteFromCompactData(compactData, token, false);
654             extraBps = int(rateUpdate) * 10;
655             rate = addBps(rate, extraBps);
656 
657             // compute token qty
658             imbalanceQty = -1 * int(qty);
659             totalImbalance += imbalanceQty;
660 
661             // add qty overhead
662             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
663             rate = addBps(rate, extraBps);
664 
665             // add imbalance overhead
666             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
667             rate = addBps(rate, extraBps);
668         }
669 
670         if (abs(totalImbalance) >= getMaxTotalImbalance(token)) return 0;
671         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
672 
673         return rate;
674     }
675     /* solhint-enable function-max-lines */
676 
677     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
678         if (buy)
679             return tokenData[token].baseBuyRate;
680         else
681             return tokenData[token].baseSellRate;
682     }
683 
684     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
685         require(tokenData[token].listed);
686 
687         uint arrayIndex = tokenData[token].compactDataArrayIndex;
688         uint fieldOffset = tokenData[token].compactDataFieldIndex;
689 
690         return (
691             arrayIndex,
692             fieldOffset,
693             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
694             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
695         );
696     }
697 
698     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
699         return (tokenData[token].listed, tokenData[token].enabled);
700     }
701 
702     /* solhint-disable code-complexity */
703     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
704         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
705         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
706         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
707         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
708 
709         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
710         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
711         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
712         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
713 
714         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
715         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
716         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
717         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
718 
719         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
720         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
721         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
722         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
723 
724         revert();
725     }
726     /* solhint-enable code-complexity */
727 
728     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
729         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
730         return getLast4Bytes(compactData);
731     }
732 
733     function getListedTokens() public view returns(ERC20[]) {
734         return listedTokens;
735     }
736 
737     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
738         uint dstDecimals = getDecimals(token);
739         uint srcDecimals = ETH_DECIMALS;
740 
741         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
742     }
743 
744     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
745         // cannot trust compiler with not turning bit operations into EXP opcode
746         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
747     }
748 
749     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
750         uint fieldOffset = tokenData[token].compactDataFieldIndex;
751         uint byteOffset;
752         if (buy)
753             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
754         else
755             byteOffset = 4 + fieldOffset;
756 
757         return int8(data[byteOffset]);
758     }
759 
760     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
761         uint len = f.y.length;
762         for (uint ind = 0; ind < len; ind++) {
763             if (x <= f.x[ind]) return f.y[ind];
764         }
765 
766         return f.y[len-1];
767     }
768 
769     function addBps(uint rate, int bps) internal pure returns(uint) {
770         uint maxBps = 100 * 100;
771         return (rate * uint(int(maxBps) + bps)) / maxBps;
772     }
773 
774     function abs(int x) internal pure returns(uint) {
775         if (x < 0)
776             return uint(-1 * x);
777         else
778             return uint(x);
779     }
780 }
781 
782 interface ERC20 {
783     function totalSupply() public view returns (uint supply);
784     function balanceOf(address _owner) public view returns (uint balance);
785     function transfer(address _to, uint _value) public returns (bool success);
786     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
787     function approve(address _spender, uint _value) public returns (bool success);
788     function allowance(address _owner, address _spender) public view returns (uint remaining);
789     function decimals() public view returns(uint digits);
790     event Approval(address indexed _owner, address indexed _spender, uint _value);
791 }