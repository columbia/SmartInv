1 pragma solidity 0.4.18;
2 
3 contract Utils {
4 
5     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
6     uint  constant internal PRECISION = (10**18);
7     uint  constant internal MAX_QTY   = (10**28); // 1B tokens
8     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
9     uint  constant internal MAX_DECIMALS = 18;
10 
11     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
12         if (dstDecimals >= srcDecimals) {
13             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
14             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
15         } else {
16             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
17             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
18         }
19     }
20 
21     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
22         //source quantity is rounded up. to avoid dest quantity being too low.
23         uint numerator;
24         uint denominator;
25         if (srcDecimals >= dstDecimals) {
26             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
27             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
28             denominator = rate;
29         } else {
30             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
31             numerator = (PRECISION * dstQty);
32             denominator = (rate * (10**(dstDecimals - srcDecimals)));
33         }
34         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
35     }
36 }
37 
38 interface ERC20 {
39     function totalSupply() public view returns (uint supply);
40     function balanceOf(address _owner) public view returns (uint balance);
41     function transfer(address _to, uint _value) public returns (bool success);
42     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
43     function approve(address _spender, uint _value) public returns (bool success);
44     function allowance(address _owner, address _spender) public view returns (uint remaining);
45     function decimals() public view returns(uint digits);
46     event Approval(address indexed _owner, address indexed _spender, uint _value);
47 }
48 
49 contract PermissionGroups {
50 
51     address public admin;
52     address public pendingAdmin;
53     mapping(address=>bool) internal operators;
54     mapping(address=>bool) internal alerters;
55     address[] internal operatorsGroup;
56     address[] internal alertersGroup;
57 
58     function PermissionGroups() public {
59         admin = msg.sender;
60     }
61 
62     modifier onlyAdmin() {
63         require(msg.sender == admin);
64         _;
65     }
66 
67     modifier onlyOperator() {
68         require(operators[msg.sender]);
69         _;
70     }
71 
72     modifier onlyAlerter() {
73         require(alerters[msg.sender]);
74         _;
75     }
76 
77     function getOperators () external view returns(address[]) {
78         return operatorsGroup;
79     }
80 
81     function getAlerters () external view returns(address[]) {
82         return alertersGroup;
83     }
84 
85     event TransferAdminPending(address pendingAdmin);
86 
87     /**
88      * @dev Allows the current admin to set the pendingAdmin address.
89      * @param newAdmin The address to transfer ownership to.
90      */
91     function transferAdmin(address newAdmin) public onlyAdmin {
92         require(newAdmin != address(0));
93         TransferAdminPending(pendingAdmin);
94         pendingAdmin = newAdmin;
95     }
96 
97     event AdminClaimed( address newAdmin, address previousAdmin);
98 
99     /**
100      * @dev Allows the pendingAdmin address to finalize the change admin process.
101      */
102     function claimAdmin() public {
103         require(pendingAdmin == msg.sender);
104         AdminClaimed(pendingAdmin, admin);
105         admin = pendingAdmin;
106         pendingAdmin = address(0);
107     }
108 
109     event AlerterAdded (address newAlerter, bool isAdd);
110 
111     function addAlerter(address newAlerter) public onlyAdmin {
112         require(!alerters[newAlerter]); // prevent duplicates.
113         AlerterAdded(newAlerter, true);
114         alerters[newAlerter] = true;
115         alertersGroup.push(newAlerter);
116     }
117 
118     function removeAlerter (address alerter) public onlyAdmin {
119         require(alerters[alerter]);
120         alerters[alerter] = false;
121 
122         for (uint i = 0; i < alertersGroup.length; ++i) {
123             if (alertersGroup[i] == alerter) {
124                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
125                 alertersGroup.length--;
126                 AlerterAdded(alerter, false);
127                 break;
128             }
129         }
130     }
131 
132     event OperatorAdded(address newOperator, bool isAdd);
133 
134     function addOperator(address newOperator) public onlyAdmin {
135         require(!operators[newOperator]); // prevent duplicates.
136         OperatorAdded(newOperator, true);
137         operators[newOperator] = true;
138         operatorsGroup.push(newOperator);
139     }
140 
141     function removeOperator (address operator) public onlyAdmin {
142         require(operators[operator]);
143         operators[operator] = false;
144 
145         for (uint i = 0; i < operatorsGroup.length; ++i) {
146             if (operatorsGroup[i] == operator) {
147                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
148                 operatorsGroup.length -= 1;
149                 OperatorAdded(operator, false);
150                 break;
151             }
152         }
153     }
154 }
155 
156 contract Withdrawable is PermissionGroups {
157 
158     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
159 
160     /**
161      * @dev Withdraw all ERC20 compatible tokens
162      * @param token ERC20 The address of the token contract
163      */
164     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
165         require(token.transfer(sendTo, amount));
166         TokenWithdraw(token, amount, sendTo);
167     }
168 
169     event EtherWithdraw(uint amount, address sendTo);
170 
171     /**
172      * @dev Withdraw Ethers
173      */
174     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
175         sendTo.transfer(amount);
176         EtherWithdraw(amount, sendTo);
177     }
178 }
179 
180 contract VolumeImbalanceRecorder is Withdrawable {
181 
182     uint constant internal SLIDING_WINDOW_SIZE = 5;
183     uint constant internal POW_2_64 = 2 ** 64;
184 
185     struct TokenControlInfo {
186         uint minimalRecordResolution; // can be roughly 1 cent
187         uint maxPerBlockImbalance; // in twei resolution
188         uint maxTotalImbalance; // max total imbalance (between rate updates)
189                             // before halting trade
190     }
191 
192     mapping(address => TokenControlInfo) internal tokenControlInfo;
193 
194     struct TokenImbalanceData {
195         int  lastBlockBuyUnitsImbalance;
196         uint lastBlock;
197 
198         int  totalBuyUnitsImbalance;
199         uint lastRateUpdateBlock;
200     }
201 
202     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
203 
204     function VolumeImbalanceRecorder(address _admin) public {
205         require(_admin != address(0));
206         admin = _admin;
207     }
208 
209     function setTokenControlInfo(
210         ERC20 token,
211         uint minimalRecordResolution,
212         uint maxPerBlockImbalance,
213         uint maxTotalImbalance
214     )
215         public
216         onlyAdmin
217     {
218         tokenControlInfo[token] =
219             TokenControlInfo(
220                 minimalRecordResolution,
221                 maxPerBlockImbalance,
222                 maxTotalImbalance
223             );
224     }
225 
226     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
227         return (tokenControlInfo[token].minimalRecordResolution,
228                 tokenControlInfo[token].maxPerBlockImbalance,
229                 tokenControlInfo[token].maxTotalImbalance);
230     }
231 
232     function addImbalance(
233         ERC20 token,
234         int buyAmount,
235         uint rateUpdateBlock,
236         uint currentBlock
237     )
238         internal
239     {
240         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
241         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
242 
243         int prevImbalance = 0;
244 
245         TokenImbalanceData memory currentBlockData =
246             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
247 
248         // first scenario - this is not the first tx in the current block
249         if (currentBlockData.lastBlock == currentBlock) {
250             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
251                 // just increase imbalance
252                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
253                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
254             } else {
255                 // imbalance was changed in the middle of the block
256                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
257                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
258                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
259                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
260             }
261         } else {
262             // first tx in the current block
263             int currentBlockImbalance;
264             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
265 
266             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
267             currentBlockData.lastBlock = uint(currentBlock);
268             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
269             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
270         }
271 
272         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
273     }
274 
275     function setGarbageToVolumeRecorder(ERC20 token) internal {
276         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
277             tokenImbalanceData[token][i] = 0x1;
278         }
279     }
280 
281     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
282         // check the imbalance in the sliding window
283         require(startBlock <= endBlock);
284 
285         buyImbalance = 0;
286 
287         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
288             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
289 
290             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
291                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
292             }
293         }
294     }
295 
296     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
297         internal view
298         returns(int buyImbalance, int currentBlockImbalance)
299     {
300         buyImbalance = 0;
301         currentBlockImbalance = 0;
302         uint latestBlock = 0;
303         int imbalanceInRange = 0;
304         uint startBlock = rateUpdateBlock;
305         uint endBlock = currentBlock;
306 
307         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
308             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
309 
310             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
311                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
312             }
313 
314             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
315             if (perBlockData.lastBlock < latestBlock) continue;
316 
317             latestBlock = perBlockData.lastBlock;
318             buyImbalance = perBlockData.totalBuyUnitsImbalance;
319             if (uint(perBlockData.lastBlock) == currentBlock) {
320                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
321             }
322         }
323 
324         if (buyImbalance == 0) {
325             buyImbalance = imbalanceInRange;
326         }
327     }
328 
329     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
330         internal view
331         returns(int totalImbalance, int currentBlockImbalance)
332     {
333 
334         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
335 
336         (totalImbalance, currentBlockImbalance) =
337             getImbalanceSinceRateUpdate(
338                 token,
339                 rateUpdateBlock,
340                 currentBlock);
341 
342         totalImbalance *= resolution;
343         currentBlockImbalance *= resolution;
344     }
345 
346     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
347         return tokenControlInfo[token].maxPerBlockImbalance;
348     }
349 
350     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
351         return tokenControlInfo[token].maxTotalImbalance;
352     }
353 
354     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
355         // check for overflows
356         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
357         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
358         require(data.lastBlock < POW_2_64);
359         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
360         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
361         require(data.lastRateUpdateBlock < POW_2_64);
362 
363         // do encoding
364         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
365         result |= data.lastBlock * POW_2_64;
366         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
367         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
368 
369         return result;
370     }
371 
372     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
373         TokenImbalanceData memory data;
374 
375         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
376         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
377         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
378         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
379 
380         return data;
381     }
382 }
383 
384 contract ConversionRates is VolumeImbalanceRecorder, Utils {
385 
386     // bps - basic rate steps. one step is 1 / 10000 of the rate.
387     struct StepFunction {
388         int[] x; // quantity for each step. Quantity of each step includes previous steps.
389         int[] y; // rate change per quantity step  in bps.
390     }
391 
392     struct TokenData {
393         bool listed;  // was added to reserve
394         bool enabled; // whether trade is enabled
395 
396         // position in the compact data
397         uint compactDataArrayIndex;
398         uint compactDataFieldIndex;
399 
400         // rate data. base and changes according to quantity and reserve balance.
401         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
402         uint baseBuyRate;  // in PRECISION units. see KyberConstants
403         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
404         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
405         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
406         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
407         StepFunction sellRateImbalanceStepFunction;
408     }
409 
410     /*
411     this is the data for tokenRatesCompactData
412     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
413     so we represent it as bytes32 and do the byte tricks ourselves.
414     struct TokenRatesCompactData {
415         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
416         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
417 
418         uint32 blockNumber;
419     } */
420     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
421     ERC20[] internal listedTokens;
422     mapping(address=>TokenData) internal tokenData;
423     bytes32[] internal tokenRatesCompactData;
424     uint public numTokensInCurrentCompactData = 0;
425     address public reserveContract;
426     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
427     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
428 
429     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
430         { } // solhint-disable-line no-empty-blocks
431 
432     function addToken(ERC20 token) public onlyAdmin {
433 
434         require(!tokenData[token].listed);
435         tokenData[token].listed = true;
436         listedTokens.push(token);
437 
438         if (numTokensInCurrentCompactData == 0) {
439             tokenRatesCompactData.length++; // add new structure
440         }
441 
442         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
443         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
444 
445         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
446 
447         setGarbageToVolumeRecorder(token);
448     }
449 
450     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
451 
452         require(buy.length == sell.length);
453         require(indices.length == buy.length);
454         require(blockNumber <= 0xFFFFFFFF);
455 
456         uint bytes14Offset = BYTES_14_OFFSET;
457 
458         for (uint i = 0; i < indices.length; i++) {
459             require(indices[i] < tokenRatesCompactData.length);
460             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
461             tokenRatesCompactData[indices[i]] = bytes32(data);
462         }
463     }
464 
465     function setBaseRate(
466         ERC20[] tokens,
467         uint[] baseBuy,
468         uint[] baseSell,
469         bytes14[] buy,
470         bytes14[] sell,
471         uint blockNumber,
472         uint[] indices
473     )
474         public
475         onlyOperator
476     {
477         require(tokens.length == baseBuy.length);
478         require(tokens.length == baseSell.length);
479         require(sell.length == buy.length);
480         require(sell.length == indices.length);
481 
482         for (uint ind = 0; ind < tokens.length; ind++) {
483             require(tokenData[tokens[ind]].listed);
484             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
485             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
486         }
487 
488         setCompactData(buy, sell, blockNumber, indices);
489     }
490 
491     function setQtyStepFunction(
492         ERC20 token,
493         int[] xBuy,
494         int[] yBuy,
495         int[] xSell,
496         int[] ySell
497     )
498         public
499         onlyOperator
500     {
501         require(xBuy.length == yBuy.length);
502         require(xSell.length == ySell.length);
503         require(tokenData[token].listed);
504 
505         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
506         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
507     }
508 
509     function setImbalanceStepFunction(
510         ERC20 token,
511         int[] xBuy,
512         int[] yBuy,
513         int[] xSell,
514         int[] ySell
515     )
516         public
517         onlyOperator
518     {
519         require(xBuy.length == yBuy.length);
520         require(xSell.length == ySell.length);
521         require(tokenData[token].listed);
522 
523         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
524         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
525     }
526 
527     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
528         validRateDurationInBlocks = duration;
529     }
530 
531     function enableTokenTrade(ERC20 token) public onlyAdmin {
532         require(tokenData[token].listed);
533         require(tokenControlInfo[token].minimalRecordResolution != 0);
534         tokenData[token].enabled = true;
535     }
536 
537     function disableTokenTrade(ERC20 token) public onlyAlerter {
538         require(tokenData[token].listed);
539         tokenData[token].enabled = false;
540     }
541 
542     function setReserveAddress(address reserve) public onlyAdmin {
543         reserveContract = reserve;
544     }
545 
546     function recordImbalance(
547         ERC20 token,
548         int buyAmount,
549         uint rateUpdateBlock,
550         uint currentBlock
551     )
552         public
553     {
554         require(msg.sender == reserveContract);
555 
556         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
557 
558         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
559     }
560 
561     /* solhint-disable function-max-lines */
562     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
563         // check if trade is enabled
564         if (!tokenData[token].enabled) return 0;
565         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
566 
567         // get rate update block
568         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
569 
570         uint updateRateBlock = getLast4Bytes(compactData);
571         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
572         // check imbalance
573         int totalImbalance;
574         int blockImbalance;
575         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
576 
577         // calculate actual rate
578         int imbalanceQty;
579         int extraBps;
580         int8 rateUpdate;
581         uint rate;
582 
583         if (buy) {
584             // start with base rate
585             rate = tokenData[token].baseBuyRate;
586 
587             // add rate update
588             rateUpdate = getRateByteFromCompactData(compactData, token, true);
589             extraBps = int(rateUpdate) * 10;
590             rate = addBps(rate, extraBps);
591 
592             // compute token qty
593             qty = getTokenQty(token, rate, qty);
594             imbalanceQty = int(qty);
595             totalImbalance += imbalanceQty;
596 
597             // add qty overhead
598             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
599             rate = addBps(rate, extraBps);
600 
601             // add imbalance overhead
602             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
603             rate = addBps(rate, extraBps);
604         } else {
605             // start with base rate
606             rate = tokenData[token].baseSellRate;
607 
608             // add rate update
609             rateUpdate = getRateByteFromCompactData(compactData, token, false);
610             extraBps = int(rateUpdate) * 10;
611             rate = addBps(rate, extraBps);
612 
613             // compute token qty
614             imbalanceQty = -1 * int(qty);
615             totalImbalance += imbalanceQty;
616 
617             // add qty overhead
618             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
619             rate = addBps(rate, extraBps);
620 
621             // add imbalance overhead
622             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
623             rate = addBps(rate, extraBps);
624         }
625 
626         if (abs(totalImbalance + imbalanceQty) >= getMaxTotalImbalance(token)) return 0;
627         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
628 
629         return rate;
630     }
631     /* solhint-enable function-max-lines */
632 
633     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
634         if (buy)
635             return tokenData[token].baseBuyRate;
636         else
637             return tokenData[token].baseSellRate;
638     }
639 
640     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
641         uint arrayIndex = tokenData[token].compactDataArrayIndex;
642         uint fieldOffset = tokenData[token].compactDataFieldIndex;
643 
644         return (
645             arrayIndex,
646             fieldOffset,
647             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
648             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
649         );
650     }
651 
652     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
653         return (tokenData[token].listed, tokenData[token].enabled);
654     }
655 
656     /* solhint-disable code-complexity */
657     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
658         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
659         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
660         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
661         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
662 
663         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
664         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
665         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
666         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
667 
668         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
669         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
670         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
671         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
672 
673         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
674         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
675         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
676         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
677 
678         revert();
679     }
680     /* solhint-enable code-complexity */
681 
682     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
683         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
684         return getLast4Bytes(compactData);
685     }
686 
687     function getListedTokens() public view returns(ERC20[]) {
688         return listedTokens;
689     }
690 
691     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
692         uint dstDecimals = token.decimals();
693         uint srcDecimals = 18;
694 
695         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
696     }
697 
698     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
699         // cannot trust compiler with not turning bit operations into EXP opcode
700         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
701     }
702 
703     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
704         uint fieldOffset = tokenData[token].compactDataFieldIndex;
705         uint byteOffset;
706         if (buy)
707             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
708         else
709             byteOffset = 4 + fieldOffset;
710 
711         return int8(data[byteOffset]);
712     }
713 
714     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
715         uint len = f.y.length;
716         for (uint ind = 0; ind < len; ind++) {
717             if (x <= f.x[ind]) return f.y[ind];
718         }
719 
720         return f.y[len-1];
721     }
722 
723     function addBps(uint rate, int bps) internal pure returns(uint) {
724         uint maxBps = 100 * 100;
725         return (rate * uint(int(maxBps) + bps)) / maxBps;
726     }
727 
728     function abs(int x) internal pure returns(uint) {
729         if (x < 0)
730             return uint(-1 * x);
731         else
732             return uint(x);
733     }
734 }