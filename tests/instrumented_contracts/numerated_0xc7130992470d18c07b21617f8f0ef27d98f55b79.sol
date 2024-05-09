1 pragma solidity 0.4.18;
2 
3 interface ERC20 {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf(address _owner) public view returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint remaining);
10     function decimals() public view returns(uint digits);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 interface ConversionRatesInterface {
15 
16     function recordImbalance(
17         ERC20 token,
18         int buyAmount,
19         uint rateUpdateBlock,
20         uint currentBlock
21     )
22         public;
23 
24     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
25 }
26 
27 contract Utils {
28 
29     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
30     uint  constant internal PRECISION = (10**18);
31     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
32     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
33     uint  constant internal MAX_DECIMALS = 18;
34     uint  constant internal ETH_DECIMALS = 18;
35     mapping(address=>uint) internal decimals;
36 
37     function setDecimals(ERC20 token) internal {
38         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
39         else decimals[token] = token.decimals();
40     }
41 
42     function getDecimals(ERC20 token) internal view returns(uint) {
43         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
44         uint tokenDecimals = decimals[token];
45         // technically, there might be token with decimals 0
46         // moreover, very possible that old tokens have decimals 0
47         // these tokens will just have higher gas fees.
48         if(tokenDecimals == 0) return token.decimals();
49 
50         return tokenDecimals;
51     }
52 
53     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
54         require(srcQty <= MAX_QTY);
55         require(rate <= MAX_RATE);
56 
57         if (dstDecimals >= srcDecimals) {
58             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
59             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
60         } else {
61             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
62             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
63         }
64     }
65 
66     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
67         require(dstQty <= MAX_QTY);
68         require(rate <= MAX_RATE);
69 
70         //source quantity is rounded up. to avoid dest quantity being too low.
71         uint numerator;
72         uint denominator;
73         if (srcDecimals >= dstDecimals) {
74             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
75             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
76             denominator = rate;
77         } else {
78             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
79             numerator = (PRECISION * dstQty);
80             denominator = (rate * (10**(dstDecimals - srcDecimals)));
81         }
82         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
83     }
84 }
85 
86 contract PermissionGroups {
87 
88     address public admin;
89     address public pendingAdmin;
90     mapping(address=>bool) internal operators;
91     mapping(address=>bool) internal alerters;
92     address[] internal operatorsGroup;
93     address[] internal alertersGroup;
94 
95     function PermissionGroups() public {
96         admin = msg.sender;
97     }
98 
99     modifier onlyAdmin() {
100         require(msg.sender == admin);
101         _;
102     }
103 
104     modifier onlyOperator() {
105         require(operators[msg.sender]);
106         _;
107     }
108 
109     modifier onlyAlerter() {
110         require(alerters[msg.sender]);
111         _;
112     }
113 
114     function getOperators () external view returns(address[]) {
115         return operatorsGroup;
116     }
117 
118     function getAlerters () external view returns(address[]) {
119         return alertersGroup;
120     }
121 
122     event TransferAdminPending(address pendingAdmin);
123 
124     /**
125      * @dev Allows the current admin to set the pendingAdmin address.
126      * @param newAdmin The address to transfer ownership to.
127      */
128     function transferAdmin(address newAdmin) public onlyAdmin {
129         require(newAdmin != address(0));
130         TransferAdminPending(pendingAdmin);
131         pendingAdmin = newAdmin;
132     }
133 
134     event AdminClaimed( address newAdmin, address previousAdmin);
135 
136     /**
137      * @dev Allows the pendingAdmin address to finalize the change admin process.
138      */
139     function claimAdmin() public {
140         require(pendingAdmin == msg.sender);
141         AdminClaimed(pendingAdmin, admin);
142         admin = pendingAdmin;
143         pendingAdmin = address(0);
144     }
145 
146     event AlerterAdded (address newAlerter, bool isAdd);
147 
148     function addAlerter(address newAlerter) public onlyAdmin {
149         require(!alerters[newAlerter]); // prevent duplicates.
150         AlerterAdded(newAlerter, true);
151         alerters[newAlerter] = true;
152         alertersGroup.push(newAlerter);
153     }
154 
155     function removeAlerter (address alerter) public onlyAdmin {
156         require(alerters[alerter]);
157         alerters[alerter] = false;
158 
159         for (uint i = 0; i < alertersGroup.length; ++i) {
160             if (alertersGroup[i] == alerter) {
161                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
162                 alertersGroup.length--;
163                 AlerterAdded(alerter, false);
164                 break;
165             }
166         }
167     }
168 
169     event OperatorAdded(address newOperator, bool isAdd);
170 
171     function addOperator(address newOperator) public onlyAdmin {
172         require(!operators[newOperator]); // prevent duplicates.
173         OperatorAdded(newOperator, true);
174         operators[newOperator] = true;
175         operatorsGroup.push(newOperator);
176     }
177 
178     function removeOperator (address operator) public onlyAdmin {
179         require(operators[operator]);
180         operators[operator] = false;
181 
182         for (uint i = 0; i < operatorsGroup.length; ++i) {
183             if (operatorsGroup[i] == operator) {
184                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
185                 operatorsGroup.length -= 1;
186                 OperatorAdded(operator, false);
187                 break;
188             }
189         }
190     }
191 }
192 
193 contract Withdrawable is PermissionGroups {
194 
195     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
196 
197     /**
198      * @dev Withdraw all ERC20 compatible tokens
199      * @param token ERC20 The address of the token contract
200      */
201     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
202         require(token.transfer(sendTo, amount));
203         TokenWithdraw(token, amount, sendTo);
204     }
205 
206     event EtherWithdraw(uint amount, address sendTo);
207 
208     /**
209      * @dev Withdraw Ethers
210      */
211     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
212         sendTo.transfer(amount);
213         EtherWithdraw(amount, sendTo);
214     }
215 }
216 
217 contract VolumeImbalanceRecorder is Withdrawable {
218 
219     uint constant internal SLIDING_WINDOW_SIZE = 5;
220     uint constant internal POW_2_64 = 2 ** 64;
221 
222     struct TokenControlInfo {
223         uint minimalRecordResolution; // can be roughly 1 cent
224         uint maxPerBlockImbalance; // in twei resolution
225         uint maxTotalImbalance; // max total imbalance (between rate updates)
226                             // before halting trade
227     }
228 
229     mapping(address => TokenControlInfo) internal tokenControlInfo;
230 
231     struct TokenImbalanceData {
232         int  lastBlockBuyUnitsImbalance;
233         uint lastBlock;
234 
235         int  totalBuyUnitsImbalance;
236         uint lastRateUpdateBlock;
237     }
238 
239     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
240 
241     function VolumeImbalanceRecorder(address _admin) public {
242         require(_admin != address(0));
243         admin = _admin;
244     }
245 
246     function setTokenControlInfo(
247         ERC20 token,
248         uint minimalRecordResolution,
249         uint maxPerBlockImbalance,
250         uint maxTotalImbalance
251     )
252         public
253         onlyAdmin
254     {
255         tokenControlInfo[token] =
256             TokenControlInfo(
257                 minimalRecordResolution,
258                 maxPerBlockImbalance,
259                 maxTotalImbalance
260             );
261     }
262 
263     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
264         return (tokenControlInfo[token].minimalRecordResolution,
265                 tokenControlInfo[token].maxPerBlockImbalance,
266                 tokenControlInfo[token].maxTotalImbalance);
267     }
268 
269     function addImbalance(
270         ERC20 token,
271         int buyAmount,
272         uint rateUpdateBlock,
273         uint currentBlock
274     )
275         internal
276     {
277         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
278         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
279 
280         int prevImbalance = 0;
281 
282         TokenImbalanceData memory currentBlockData =
283             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
284 
285         // first scenario - this is not the first tx in the current block
286         if (currentBlockData.lastBlock == currentBlock) {
287             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
288                 // just increase imbalance
289                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
290                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
291             } else {
292                 // imbalance was changed in the middle of the block
293                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
294                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
295                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
296                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
297             }
298         } else {
299             // first tx in the current block
300             int currentBlockImbalance;
301             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
302 
303             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
304             currentBlockData.lastBlock = uint(currentBlock);
305             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
306             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
307         }
308 
309         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
310     }
311 
312     function setGarbageToVolumeRecorder(ERC20 token) internal {
313         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
314             tokenImbalanceData[token][i] = 0x1;
315         }
316     }
317 
318     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
319         // check the imbalance in the sliding window
320         require(startBlock <= endBlock);
321 
322         buyImbalance = 0;
323 
324         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
325             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
326 
327             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
328                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
329             }
330         }
331     }
332 
333     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
334         internal view
335         returns(int buyImbalance, int currentBlockImbalance)
336     {
337         buyImbalance = 0;
338         currentBlockImbalance = 0;
339         uint latestBlock = 0;
340         int imbalanceInRange = 0;
341         uint startBlock = rateUpdateBlock;
342         uint endBlock = currentBlock;
343 
344         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
345             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
346 
347             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
348                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
349             }
350 
351             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
352             if (perBlockData.lastBlock < latestBlock) continue;
353 
354             latestBlock = perBlockData.lastBlock;
355             buyImbalance = perBlockData.totalBuyUnitsImbalance;
356             if (uint(perBlockData.lastBlock) == currentBlock) {
357                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
358             }
359         }
360 
361         if (buyImbalance == 0) {
362             buyImbalance = imbalanceInRange;
363         }
364     }
365 
366     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
367         internal view
368         returns(int totalImbalance, int currentBlockImbalance)
369     {
370 
371         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
372 
373         (totalImbalance, currentBlockImbalance) =
374             getImbalanceSinceRateUpdate(
375                 token,
376                 rateUpdateBlock,
377                 currentBlock);
378 
379         totalImbalance *= resolution;
380         currentBlockImbalance *= resolution;
381     }
382 
383     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
384         return tokenControlInfo[token].maxPerBlockImbalance;
385     }
386 
387     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
388         return tokenControlInfo[token].maxTotalImbalance;
389     }
390 
391     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
392         // check for overflows
393         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
394         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
395         require(data.lastBlock < POW_2_64);
396         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
397         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
398         require(data.lastRateUpdateBlock < POW_2_64);
399 
400         // do encoding
401         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
402         result |= data.lastBlock * POW_2_64;
403         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
404         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
405 
406         return result;
407     }
408 
409     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
410         TokenImbalanceData memory data;
411 
412         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
413         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
414         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
415         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
416 
417         return data;
418     }
419 }
420 
421 contract ConversionRates is ConversionRatesInterface, VolumeImbalanceRecorder, Utils {
422 
423     // bps - basic rate steps. one step is 1 / 10000 of the rate.
424     struct StepFunction {
425         int[] x; // quantity for each step. Quantity of each step includes previous steps.
426         int[] y; // rate change per quantity step  in bps.
427     }
428 
429     struct TokenData {
430         bool listed;  // was added to reserve
431         bool enabled; // whether trade is enabled
432 
433         // position in the compact data
434         uint compactDataArrayIndex;
435         uint compactDataFieldIndex;
436 
437         // rate data. base and changes according to quantity and reserve balance.
438         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
439         uint baseBuyRate;  // in PRECISION units. see KyberConstants
440         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
441         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
442         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
443         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
444         StepFunction sellRateImbalanceStepFunction;
445     }
446 
447     /*
448     this is the data for tokenRatesCompactData
449     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
450     so we represent it as bytes32 and do the byte tricks ourselves.
451     struct TokenRatesCompactData {
452         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
453         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
454 
455         uint32 blockNumber;
456     } */
457     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
458     ERC20[] internal listedTokens;
459     mapping(address=>TokenData) internal tokenData;
460     bytes32[] internal tokenRatesCompactData;
461     uint public numTokensInCurrentCompactData = 0;
462     address public reserveContract;
463     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
464     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
465 
466     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
467         { } // solhint-disable-line no-empty-blocks
468 
469     function addToken(ERC20 token) public onlyAdmin {
470 
471         require(!tokenData[token].listed);
472         tokenData[token].listed = true;
473         listedTokens.push(token);
474 
475         if (numTokensInCurrentCompactData == 0) {
476             tokenRatesCompactData.length++; // add new structure
477         }
478 
479         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
480         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
481 
482         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
483 
484         setGarbageToVolumeRecorder(token);
485 
486         setDecimals(token);
487     }
488 
489     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
490 
491         require(buy.length == sell.length);
492         require(indices.length == buy.length);
493         require(blockNumber <= 0xFFFFFFFF);
494 
495         uint bytes14Offset = BYTES_14_OFFSET;
496 
497         for (uint i = 0; i < indices.length; i++) {
498             require(indices[i] < tokenRatesCompactData.length);
499             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
500             tokenRatesCompactData[indices[i]] = bytes32(data);
501         }
502     }
503 
504     function setBaseRate(
505         ERC20[] tokens,
506         uint[] baseBuy,
507         uint[] baseSell,
508         bytes14[] buy,
509         bytes14[] sell,
510         uint blockNumber,
511         uint[] indices
512     )
513         public
514         onlyOperator
515     {
516         require(tokens.length == baseBuy.length);
517         require(tokens.length == baseSell.length);
518         require(sell.length == buy.length);
519         require(sell.length == indices.length);
520 
521         for (uint ind = 0; ind < tokens.length; ind++) {
522             require(tokenData[tokens[ind]].listed);
523             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
524             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
525         }
526 
527         setCompactData(buy, sell, blockNumber, indices);
528     }
529 
530     function setQtyStepFunction(
531         ERC20 token,
532         int[] xBuy,
533         int[] yBuy,
534         int[] xSell,
535         int[] ySell
536     )
537         public
538         onlyOperator
539     {
540         require(xBuy.length == yBuy.length);
541         require(xSell.length == ySell.length);
542         require(tokenData[token].listed);
543 
544         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
545         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
546     }
547 
548     function setImbalanceStepFunction(
549         ERC20 token,
550         int[] xBuy,
551         int[] yBuy,
552         int[] xSell,
553         int[] ySell
554     )
555         public
556         onlyOperator
557     {
558         require(xBuy.length == yBuy.length);
559         require(xSell.length == ySell.length);
560         require(tokenData[token].listed);
561 
562         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
563         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
564     }
565 
566     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
567         validRateDurationInBlocks = duration;
568     }
569 
570     function enableTokenTrade(ERC20 token) public onlyAdmin {
571         require(tokenData[token].listed);
572         require(tokenControlInfo[token].minimalRecordResolution != 0);
573         tokenData[token].enabled = true;
574     }
575 
576     function disableTokenTrade(ERC20 token) public onlyAlerter {
577         require(tokenData[token].listed);
578         tokenData[token].enabled = false;
579     }
580 
581     function setReserveAddress(address reserve) public onlyAdmin {
582         reserveContract = reserve;
583     }
584 
585     function recordImbalance(
586         ERC20 token,
587         int buyAmount,
588         uint rateUpdateBlock,
589         uint currentBlock
590     )
591         public
592     {
593         require(msg.sender == reserveContract);
594 
595         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
596 
597         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
598     }
599 
600     /* solhint-disable function-max-lines */
601     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
602         // check if trade is enabled
603         if (!tokenData[token].enabled) return 0;
604         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
605 
606         // get rate update block
607         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
608 
609         uint updateRateBlock = getLast4Bytes(compactData);
610         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
611         // check imbalance
612         int totalImbalance;
613         int blockImbalance;
614         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
615 
616         // calculate actual rate
617         int imbalanceQty;
618         int extraBps;
619         int8 rateUpdate;
620         uint rate;
621 
622         if (buy) {
623             // start with base rate
624             rate = tokenData[token].baseBuyRate;
625 
626             // add rate update
627             rateUpdate = getRateByteFromCompactData(compactData, token, true);
628             extraBps = int(rateUpdate) * 10;
629             rate = addBps(rate, extraBps);
630 
631             // compute token qty
632             qty = getTokenQty(token, rate, qty);
633             imbalanceQty = int(qty);
634             totalImbalance += imbalanceQty;
635 
636             // add qty overhead
637             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
638             rate = addBps(rate, extraBps);
639 
640             // add imbalance overhead
641             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
642             rate = addBps(rate, extraBps);
643         } else {
644             // start with base rate
645             rate = tokenData[token].baseSellRate;
646 
647             // add rate update
648             rateUpdate = getRateByteFromCompactData(compactData, token, false);
649             extraBps = int(rateUpdate) * 10;
650             rate = addBps(rate, extraBps);
651 
652             // compute token qty
653             imbalanceQty = -1 * int(qty);
654             totalImbalance += imbalanceQty;
655 
656             // add qty overhead
657             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
658             rate = addBps(rate, extraBps);
659 
660             // add imbalance overhead
661             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
662             rate = addBps(rate, extraBps);
663         }
664 
665         if (abs(totalImbalance + imbalanceQty) >= getMaxTotalImbalance(token)) return 0;
666         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
667 
668         return rate;
669     }
670     /* solhint-enable function-max-lines */
671 
672     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
673         if (buy)
674             return tokenData[token].baseBuyRate;
675         else
676             return tokenData[token].baseSellRate;
677     }
678 
679     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
680         require(tokenData[token].listed);
681 
682         uint arrayIndex = tokenData[token].compactDataArrayIndex;
683         uint fieldOffset = tokenData[token].compactDataFieldIndex;
684 
685         return (
686             arrayIndex,
687             fieldOffset,
688             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
689             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
690         );
691     }
692 
693     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
694         return (tokenData[token].listed, tokenData[token].enabled);
695     }
696 
697     /* solhint-disable code-complexity */
698     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
699         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
700         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
701         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
702         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
703 
704         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
705         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
706         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
707         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
708 
709         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
710         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
711         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
712         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
713 
714         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
715         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
716         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
717         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
718 
719         revert();
720     }
721     /* solhint-enable code-complexity */
722 
723     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
724         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
725         return getLast4Bytes(compactData);
726     }
727 
728     function getListedTokens() public view returns(ERC20[]) {
729         return listedTokens;
730     }
731 
732     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
733         uint dstDecimals = getDecimals(token);
734         uint srcDecimals = ETH_DECIMALS;
735 
736         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
737     }
738 
739     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
740         // cannot trust compiler with not turning bit operations into EXP opcode
741         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
742     }
743 
744     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
745         uint fieldOffset = tokenData[token].compactDataFieldIndex;
746         uint byteOffset;
747         if (buy)
748             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
749         else
750             byteOffset = 4 + fieldOffset;
751 
752         return int8(data[byteOffset]);
753     }
754 
755     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
756         uint len = f.y.length;
757         for (uint ind = 0; ind < len; ind++) {
758             if (x <= f.x[ind]) return f.y[ind];
759         }
760 
761         return f.y[len-1];
762     }
763 
764     function addBps(uint rate, int bps) internal pure returns(uint) {
765         uint maxBps = 100 * 100;
766         return (rate * uint(int(maxBps) + bps)) / maxBps;
767     }
768 
769     function abs(int x) internal pure returns(uint) {
770         if (x < 0)
771             return uint(-1 * x);
772         else
773             return uint(x);
774     }
775 }