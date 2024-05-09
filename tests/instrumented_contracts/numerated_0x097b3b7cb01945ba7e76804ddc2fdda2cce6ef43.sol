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
16 interface ERC20 {
17     function totalSupply() public view returns (uint supply);
18     function balanceOf(address _owner) public view returns (uint balance);
19     function transfer(address _to, uint _value) public returns (bool success);
20     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
21     function approve(address _spender, uint _value) public returns (bool success);
22     function allowance(address _owner, address _spender) public view returns (uint remaining);
23     function decimals() public view returns(uint digits);
24     event Approval(address indexed _owner, address indexed _spender, uint _value);
25 }
26 
27 contract PermissionGroups {
28 
29     address public admin;
30     address public pendingAdmin;
31     mapping(address=>bool) internal operators;
32     mapping(address=>bool) internal alerters;
33     address[] internal operatorsGroup;
34     address[] internal alertersGroup;
35     uint constant internal MAX_GROUP_SIZE = 50;
36 
37     function PermissionGroups() public {
38         admin = msg.sender;
39     }
40 
41     modifier onlyAdmin() {
42         require(msg.sender == admin);
43         _;
44     }
45 
46     modifier onlyOperator() {
47         require(operators[msg.sender]);
48         _;
49     }
50 
51     modifier onlyAlerter() {
52         require(alerters[msg.sender]);
53         _;
54     }
55 
56     function getOperators () external view returns(address[]) {
57         return operatorsGroup;
58     }
59 
60     function getAlerters () external view returns(address[]) {
61         return alertersGroup;
62     }
63 
64     event TransferAdminPending(address pendingAdmin);
65 
66     /**
67      * @dev Allows the current admin to set the pendingAdmin address.
68      * @param newAdmin The address to transfer ownership to.
69      */
70     function transferAdmin(address newAdmin) public onlyAdmin {
71         require(newAdmin != address(0));
72         TransferAdminPending(pendingAdmin);
73         pendingAdmin = newAdmin;
74     }
75 
76     /**
77      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
78      * @param newAdmin The address to transfer ownership to.
79      */
80     function transferAdminQuickly(address newAdmin) public onlyAdmin {
81         require(newAdmin != address(0));
82         TransferAdminPending(newAdmin);
83         AdminClaimed(newAdmin, admin);
84         admin = newAdmin;
85     }
86 
87     event AdminClaimed( address newAdmin, address previousAdmin);
88 
89     /**
90      * @dev Allows the pendingAdmin address to finalize the change admin process.
91      */
92     function claimAdmin() public {
93         require(pendingAdmin == msg.sender);
94         AdminClaimed(pendingAdmin, admin);
95         admin = pendingAdmin;
96         pendingAdmin = address(0);
97     }
98 
99     event AlerterAdded (address newAlerter, bool isAdd);
100 
101     function addAlerter(address newAlerter) public onlyAdmin {
102         require(!alerters[newAlerter]); // prevent duplicates.
103         require(alertersGroup.length < MAX_GROUP_SIZE);
104 
105         AlerterAdded(newAlerter, true);
106         alerters[newAlerter] = true;
107         alertersGroup.push(newAlerter);
108     }
109 
110     function removeAlerter (address alerter) public onlyAdmin {
111         require(alerters[alerter]);
112         alerters[alerter] = false;
113 
114         for (uint i = 0; i < alertersGroup.length; ++i) {
115             if (alertersGroup[i] == alerter) {
116                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
117                 alertersGroup.length--;
118                 AlerterAdded(alerter, false);
119                 break;
120             }
121         }
122     }
123 
124     event OperatorAdded(address newOperator, bool isAdd);
125 
126     function addOperator(address newOperator) public onlyAdmin {
127         require(!operators[newOperator]); // prevent duplicates.
128         require(operatorsGroup.length < MAX_GROUP_SIZE);
129 
130         OperatorAdded(newOperator, true);
131         operators[newOperator] = true;
132         operatorsGroup.push(newOperator);
133     }
134 
135     function removeOperator (address operator) public onlyAdmin {
136         require(operators[operator]);
137         operators[operator] = false;
138 
139         for (uint i = 0; i < operatorsGroup.length; ++i) {
140             if (operatorsGroup[i] == operator) {
141                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
142                 operatorsGroup.length -= 1;
143                 OperatorAdded(operator, false);
144                 break;
145             }
146         }
147     }
148 }
149 
150 contract Withdrawable is PermissionGroups {
151 
152     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
153 
154     /**
155      * @dev Withdraw all ERC20 compatible tokens
156      * @param token ERC20 The address of the token contract
157      */
158     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
159         require(token.transfer(sendTo, amount));
160         TokenWithdraw(token, amount, sendTo);
161     }
162 
163     event EtherWithdraw(uint amount, address sendTo);
164 
165     /**
166      * @dev Withdraw Ethers
167      */
168     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
169         sendTo.transfer(amount);
170         EtherWithdraw(amount, sendTo);
171     }
172 }
173 
174 contract VolumeImbalanceRecorder is Withdrawable {
175 
176     uint constant internal SLIDING_WINDOW_SIZE = 5;
177     uint constant internal POW_2_64 = 2 ** 64;
178 
179     struct TokenControlInfo {
180         uint minimalRecordResolution; // can be roughly 1 cent
181         uint maxPerBlockImbalance; // in twei resolution
182         uint maxTotalImbalance; // max total imbalance (between rate updates)
183                             // before halting trade
184     }
185 
186     mapping(address => TokenControlInfo) internal tokenControlInfo;
187 
188     struct TokenImbalanceData {
189         int  lastBlockBuyUnitsImbalance;
190         uint lastBlock;
191 
192         int  totalBuyUnitsImbalance;
193         uint lastRateUpdateBlock;
194     }
195 
196     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
197 
198     function VolumeImbalanceRecorder(address _admin) public {
199         require(_admin != address(0));
200         admin = _admin;
201     }
202 
203     function setTokenControlInfo(
204         ERC20 token,
205         uint minimalRecordResolution,
206         uint maxPerBlockImbalance,
207         uint maxTotalImbalance
208     )
209         public
210         onlyAdmin
211     {
212         tokenControlInfo[token] =
213             TokenControlInfo(
214                 minimalRecordResolution,
215                 maxPerBlockImbalance,
216                 maxTotalImbalance
217             );
218     }
219 
220     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
221         return (tokenControlInfo[token].minimalRecordResolution,
222                 tokenControlInfo[token].maxPerBlockImbalance,
223                 tokenControlInfo[token].maxTotalImbalance);
224     }
225 
226     function addImbalance(
227         ERC20 token,
228         int buyAmount,
229         uint rateUpdateBlock,
230         uint currentBlock
231     )
232         internal
233     {
234         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
235         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
236 
237         int prevImbalance = 0;
238 
239         TokenImbalanceData memory currentBlockData =
240             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
241 
242         // first scenario - this is not the first tx in the current block
243         if (currentBlockData.lastBlock == currentBlock) {
244             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
245                 // just increase imbalance
246                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
247                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
248             } else {
249                 // imbalance was changed in the middle of the block
250                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
251                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
252                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
253                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
254             }
255         } else {
256             // first tx in the current block
257             int currentBlockImbalance;
258             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
259 
260             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
261             currentBlockData.lastBlock = uint(currentBlock);
262             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
263             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
264         }
265 
266         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
267     }
268 
269     function setGarbageToVolumeRecorder(ERC20 token) internal {
270         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
271             tokenImbalanceData[token][i] = 0x1;
272         }
273     }
274 
275     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
276         // check the imbalance in the sliding window
277         require(startBlock <= endBlock);
278 
279         buyImbalance = 0;
280 
281         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
282             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
283 
284             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
285                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
286             }
287         }
288     }
289 
290     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
291         internal view
292         returns(int buyImbalance, int currentBlockImbalance)
293     {
294         buyImbalance = 0;
295         currentBlockImbalance = 0;
296         uint latestBlock = 0;
297         int imbalanceInRange = 0;
298         uint startBlock = rateUpdateBlock;
299         uint endBlock = currentBlock;
300 
301         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
302             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
303 
304             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
305                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
306             }
307 
308             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
309             if (perBlockData.lastBlock < latestBlock) continue;
310 
311             latestBlock = perBlockData.lastBlock;
312             buyImbalance = perBlockData.totalBuyUnitsImbalance;
313             if (uint(perBlockData.lastBlock) == currentBlock) {
314                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
315             }
316         }
317 
318         if (buyImbalance == 0) {
319             buyImbalance = imbalanceInRange;
320         }
321     }
322 
323     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
324         internal view
325         returns(int totalImbalance, int currentBlockImbalance)
326     {
327 
328         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
329 
330         (totalImbalance, currentBlockImbalance) =
331             getImbalanceSinceRateUpdate(
332                 token,
333                 rateUpdateBlock,
334                 currentBlock);
335 
336         totalImbalance *= resolution;
337         currentBlockImbalance *= resolution;
338     }
339 
340     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
341         return tokenControlInfo[token].maxPerBlockImbalance;
342     }
343 
344     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
345         return tokenControlInfo[token].maxTotalImbalance;
346     }
347 
348     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
349         // check for overflows
350         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
351         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
352         require(data.lastBlock < POW_2_64);
353         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
354         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
355         require(data.lastRateUpdateBlock < POW_2_64);
356 
357         // do encoding
358         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
359         result |= data.lastBlock * POW_2_64;
360         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
361         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
362 
363         return result;
364     }
365 
366     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
367         TokenImbalanceData memory data;
368 
369         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
370         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
371         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
372         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
373 
374         return data;
375     }
376 }
377 
378 contract Utils {
379 
380     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
381     uint  constant internal PRECISION = (10**18);
382     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
383     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
384     uint  constant internal MAX_DECIMALS = 18;
385     uint  constant internal ETH_DECIMALS = 18;
386     mapping(address=>uint) internal decimals;
387 
388     function setDecimals(ERC20 token) internal {
389         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
390         else decimals[token] = token.decimals();
391     }
392 
393     function getDecimals(ERC20 token) internal view returns(uint) {
394         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
395         uint tokenDecimals = decimals[token];
396         // technically, there might be token with decimals 0
397         // moreover, very possible that old tokens have decimals 0
398         // these tokens will just have higher gas fees.
399         if(tokenDecimals == 0) return token.decimals();
400 
401         return tokenDecimals;
402     }
403 
404     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
405         require(srcQty <= MAX_QTY);
406         require(rate <= MAX_RATE);
407 
408         if (dstDecimals >= srcDecimals) {
409             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
410             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
411         } else {
412             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
413             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
414         }
415     }
416 
417     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
418         require(dstQty <= MAX_QTY);
419         require(rate <= MAX_RATE);
420 
421         //source quantity is rounded up. to avoid dest quantity being too low.
422         uint numerator;
423         uint denominator;
424         if (srcDecimals >= dstDecimals) {
425             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
426             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
427             denominator = rate;
428         } else {
429             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
430             numerator = (PRECISION * dstQty);
431             denominator = (rate * (10**(dstDecimals - srcDecimals)));
432         }
433         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
434     }
435 }
436 
437 contract ConversionRates is ConversionRatesInterface, VolumeImbalanceRecorder, Utils {
438 
439     // bps - basic rate steps. one step is 1 / 10000 of the rate.
440     struct StepFunction {
441         int[] x; // quantity for each step. Quantity of each step includes previous steps.
442         int[] y; // rate change per quantity step  in bps.
443     }
444 
445     struct TokenData {
446         bool listed;  // was added to reserve
447         bool enabled; // whether trade is enabled
448 
449         // position in the compact data
450         uint compactDataArrayIndex;
451         uint compactDataFieldIndex;
452 
453         // rate data. base and changes according to quantity and reserve balance.
454         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
455         uint baseBuyRate;  // in PRECISION units. see KyberConstants
456         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
457         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
458         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
459         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
460         StepFunction sellRateImbalanceStepFunction;
461     }
462 
463     /*
464     this is the data for tokenRatesCompactData
465     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
466     so we represent it as bytes32 and do the byte tricks ourselves.
467     struct TokenRatesCompactData {
468         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
469         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
470 
471         uint32 blockNumber;
472     } */
473     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
474     ERC20[] internal listedTokens;
475     mapping(address=>TokenData) internal tokenData;
476     bytes32[] internal tokenRatesCompactData;
477     uint public numTokensInCurrentCompactData = 0;
478     address public reserveContract;
479     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
480     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
481     uint constant internal MAX_STEPS_IN_FUNCTION = 10;
482     int  constant internal MAX_BPS_ADJUSTMENT = 10 ** 11; // 1B %
483     int  constant internal MIN_BPS_ADJUSTMENT = -100 * 100; // cannot go down by more than 100%
484 
485     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
486         { } // solhint-disable-line no-empty-blocks
487 
488     function addToken(ERC20 token) public onlyAdmin {
489 
490         require(!tokenData[token].listed);
491         tokenData[token].listed = true;
492         listedTokens.push(token);
493 
494         if (numTokensInCurrentCompactData == 0) {
495             tokenRatesCompactData.length++; // add new structure
496         }
497 
498         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
499         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
500 
501         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
502 
503         setGarbageToVolumeRecorder(token);
504 
505         setDecimals(token);
506     }
507 
508     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
509 
510         require(buy.length == sell.length);
511         require(indices.length == buy.length);
512         require(blockNumber <= 0xFFFFFFFF);
513 
514         uint bytes14Offset = BYTES_14_OFFSET;
515 
516         for (uint i = 0; i < indices.length; i++) {
517             require(indices[i] < tokenRatesCompactData.length);
518             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
519             tokenRatesCompactData[indices[i]] = bytes32(data);
520         }
521     }
522 
523     function setBaseRate(
524         ERC20[] tokens,
525         uint[] baseBuy,
526         uint[] baseSell,
527         bytes14[] buy,
528         bytes14[] sell,
529         uint blockNumber,
530         uint[] indices
531     )
532         public
533         onlyOperator
534     {
535         require(tokens.length == baseBuy.length);
536         require(tokens.length == baseSell.length);
537         require(sell.length == buy.length);
538         require(sell.length == indices.length);
539 
540         for (uint ind = 0; ind < tokens.length; ind++) {
541             require(tokenData[tokens[ind]].listed);
542             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
543             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
544         }
545 
546         setCompactData(buy, sell, blockNumber, indices);
547     }
548 
549     function setQtyStepFunction(
550         ERC20 token,
551         int[] xBuy,
552         int[] yBuy,
553         int[] xSell,
554         int[] ySell
555     )
556         public
557         onlyOperator
558     {
559         require(xBuy.length == yBuy.length);
560         require(xSell.length == ySell.length);
561         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
562         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
563         require(tokenData[token].listed);
564 
565         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
566         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
567     }
568 
569     function setImbalanceStepFunction(
570         ERC20 token,
571         int[] xBuy,
572         int[] yBuy,
573         int[] xSell,
574         int[] ySell
575     )
576         public
577         onlyOperator
578     {
579         require(xBuy.length == yBuy.length);
580         require(xSell.length == ySell.length);
581         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
582         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
583         require(tokenData[token].listed);
584 
585         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
586         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
587     }
588 
589     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
590         validRateDurationInBlocks = duration;
591     }
592 
593     function enableTokenTrade(ERC20 token) public onlyAdmin {
594         require(tokenData[token].listed);
595         require(tokenControlInfo[token].minimalRecordResolution != 0);
596         tokenData[token].enabled = true;
597     }
598 
599     function disableTokenTrade(ERC20 token) public onlyAlerter {
600         require(tokenData[token].listed);
601         tokenData[token].enabled = false;
602     }
603 
604     function setReserveAddress(address reserve) public onlyAdmin {
605         reserveContract = reserve;
606     }
607 
608     function recordImbalance(
609         ERC20 token,
610         int buyAmount,
611         uint rateUpdateBlock,
612         uint currentBlock
613     )
614         public
615     {
616         require(msg.sender == reserveContract);
617 
618         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
619 
620         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
621     }
622 
623     /* solhint-disable function-max-lines */
624     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
625         // check if trade is enabled
626         if (!tokenData[token].enabled) return 0;
627         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
628 
629         // get rate update block
630         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
631 
632         uint updateRateBlock = getLast4Bytes(compactData);
633         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
634         // check imbalance
635         int totalImbalance;
636         int blockImbalance;
637         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
638 
639         // calculate actual rate
640         int imbalanceQty;
641         int extraBps;
642         int8 rateUpdate;
643         uint rate;
644 
645         if (buy) {
646             // start with base rate
647             rate = tokenData[token].baseBuyRate;
648 
649             // add rate update
650             rateUpdate = getRateByteFromCompactData(compactData, token, true);
651             extraBps = int(rateUpdate) * 10;
652             rate = addBps(rate, extraBps);
653 
654             // compute token qty
655             qty = getTokenQty(token, rate, qty);
656             imbalanceQty = int(qty);
657             totalImbalance += imbalanceQty;
658 
659             // add qty overhead
660             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
661             rate = addBps(rate, extraBps);
662 
663             // add imbalance overhead
664             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
665             rate = addBps(rate, extraBps);
666         } else {
667             // start with base rate
668             rate = tokenData[token].baseSellRate;
669 
670             // add rate update
671             rateUpdate = getRateByteFromCompactData(compactData, token, false);
672             extraBps = int(rateUpdate) * 10;
673             rate = addBps(rate, extraBps);
674 
675             // compute token qty
676             imbalanceQty = -1 * int(qty);
677             totalImbalance += imbalanceQty;
678 
679             // add qty overhead
680             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
681             rate = addBps(rate, extraBps);
682 
683             // add imbalance overhead
684             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
685             rate = addBps(rate, extraBps);
686         }
687 
688         if (abs(totalImbalance) >= getMaxTotalImbalance(token)) return 0;
689         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
690 
691         return rate;
692     }
693     /* solhint-enable function-max-lines */
694 
695     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
696         if (buy)
697             return tokenData[token].baseBuyRate;
698         else
699             return tokenData[token].baseSellRate;
700     }
701 
702     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
703         require(tokenData[token].listed);
704 
705         uint arrayIndex = tokenData[token].compactDataArrayIndex;
706         uint fieldOffset = tokenData[token].compactDataFieldIndex;
707 
708         return (
709             arrayIndex,
710             fieldOffset,
711             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
712             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
713         );
714     }
715 
716     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
717         return (tokenData[token].listed, tokenData[token].enabled);
718     }
719 
720     /* solhint-disable code-complexity */
721     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
722         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
723         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
724         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
725         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
726 
727         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
728         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
729         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
730         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
731 
732         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
733         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
734         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
735         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
736 
737         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
738         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
739         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
740         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
741 
742         revert();
743     }
744     /* solhint-enable code-complexity */
745 
746     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
747         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
748         return getLast4Bytes(compactData);
749     }
750 
751     function getListedTokens() public view returns(ERC20[]) {
752         return listedTokens;
753     }
754 
755     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
756         uint dstDecimals = getDecimals(token);
757         uint srcDecimals = ETH_DECIMALS;
758 
759         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
760     }
761 
762     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
763         // cannot trust compiler with not turning bit operations into EXP opcode
764         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
765     }
766 
767     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
768         uint fieldOffset = tokenData[token].compactDataFieldIndex;
769         uint byteOffset;
770         if (buy)
771             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
772         else
773             byteOffset = 4 + fieldOffset;
774 
775         return int8(data[byteOffset]);
776     }
777 
778     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
779         uint len = f.y.length;
780         for (uint ind = 0; ind < len; ind++) {
781             if (x <= f.x[ind]) return f.y[ind];
782         }
783 
784         return f.y[len-1];
785     }
786 
787     function addBps(uint rate, int bps) internal pure returns(uint) {
788         require(rate <= MAX_RATE);
789         require(bps >= MIN_BPS_ADJUSTMENT);
790         require(bps <= MAX_BPS_ADJUSTMENT);
791 
792         uint maxBps = 100 * 100;
793         return (rate * uint(int(maxBps) + bps)) / maxBps;
794     }
795 
796     function abs(int x) internal pure returns(uint) {
797         if (x < 0)
798             return uint(-1 * x);
799         else
800             return uint(x);
801     }
802 }