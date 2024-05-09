1 // File: contracts/sol4/ERC20Interface.sol
2 
3 pragma solidity 0.4.18;
4 
5 
6 // https://github.com/ethereum/EIPs/issues/20
7 interface ERC20 {
8     function totalSupply() public view returns (uint supply);
9     function balanceOf(address _owner) public view returns (uint balance);
10     function transfer(address _to, uint _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
12     function approve(address _spender, uint _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint remaining);
14     function decimals() public view returns(uint digits);
15     event Approval(address indexed _owner, address indexed _spender, uint _value);
16 }
17 
18 // File: contracts/sol4/Utils.sol
19 
20 pragma solidity 0.4.18;
21 
22 
23 
24 /// @title Kyber constants contract
25 contract Utils {
26 
27     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
28     uint  constant internal PRECISION = (10**18);
29     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
30     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
31     uint  constant internal MAX_DECIMALS = 18;
32     uint  constant internal ETH_DECIMALS = 18;
33     mapping(address=>uint) internal decimals;
34 
35     function setDecimals(ERC20 token) internal {
36         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
37         else decimals[token] = token.decimals();
38     }
39 
40     function getDecimals(ERC20 token) internal view returns(uint) {
41         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
42         uint tokenDecimals = decimals[token];
43         // technically, there might be token with decimals 0
44         // moreover, very possible that old tokens have decimals 0
45         // these tokens will just have higher gas fees.
46         if(tokenDecimals == 0) return token.decimals();
47 
48         return tokenDecimals;
49     }
50 
51     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
52         require(srcQty <= MAX_QTY);
53         require(rate <= MAX_RATE);
54 
55         if (dstDecimals >= srcDecimals) {
56             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
57             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
58         } else {
59             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
60             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
61         }
62     }
63 
64     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
65         require(dstQty <= MAX_QTY);
66         require(rate <= MAX_RATE);
67         
68         //source quantity is rounded up. to avoid dest quantity being too low.
69         uint numerator;
70         uint denominator;
71         if (srcDecimals >= dstDecimals) {
72             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
73             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
74             denominator = rate;
75         } else {
76             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
77             numerator = (PRECISION * dstQty);
78             denominator = (rate * (10**(dstDecimals - srcDecimals)));
79         }
80         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
81     }
82 }
83 
84 // File: contracts/sol4/ConversionRatesInterface.sol
85 
86 pragma solidity 0.4.18;
87 
88 
89 
90 interface ConversionRatesInterface {
91 
92     function recordImbalance(
93         ERC20 token,
94         int buyAmount,
95         uint rateUpdateBlock,
96         uint currentBlock
97     )
98         public;
99 
100     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
101 }
102 
103 // File: contracts/sol4/PermissionGroups.sol
104 
105 pragma solidity 0.4.18;
106 
107 
108 contract PermissionGroups {
109 
110     address public admin;
111     address public pendingAdmin;
112     mapping(address=>bool) internal operators;
113     mapping(address=>bool) internal alerters;
114     address[] internal operatorsGroup;
115     address[] internal alertersGroup;
116     uint constant internal MAX_GROUP_SIZE = 50;
117 
118     function PermissionGroups() public {
119         admin = msg.sender;
120     }
121 
122     modifier onlyAdmin() {
123         require(msg.sender == admin);
124         _;
125     }
126 
127     modifier onlyOperator() {
128         require(operators[msg.sender]);
129         _;
130     }
131 
132     modifier onlyAlerter() {
133         require(alerters[msg.sender]);
134         _;
135     }
136 
137     function getOperators () external view returns(address[]) {
138         return operatorsGroup;
139     }
140 
141     function getAlerters () external view returns(address[]) {
142         return alertersGroup;
143     }
144 
145     event TransferAdminPending(address pendingAdmin);
146 
147     /**
148      * @dev Allows the current admin to set the pendingAdmin address.
149      * @param newAdmin The address to transfer ownership to.
150      */
151     function transferAdmin(address newAdmin) public onlyAdmin {
152         require(newAdmin != address(0));
153         TransferAdminPending(pendingAdmin);
154         pendingAdmin = newAdmin;
155     }
156 
157     /**
158      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
159      * @param newAdmin The address to transfer ownership to.
160      */
161     function transferAdminQuickly(address newAdmin) public onlyAdmin {
162         require(newAdmin != address(0));
163         TransferAdminPending(newAdmin);
164         AdminClaimed(newAdmin, admin);
165         admin = newAdmin;
166     }
167 
168     event AdminClaimed( address newAdmin, address previousAdmin);
169 
170     /**
171      * @dev Allows the pendingAdmin address to finalize the change admin process.
172      */
173     function claimAdmin() public {
174         require(pendingAdmin == msg.sender);
175         AdminClaimed(pendingAdmin, admin);
176         admin = pendingAdmin;
177         pendingAdmin = address(0);
178     }
179 
180     event AlerterAdded (address newAlerter, bool isAdd);
181 
182     function addAlerter(address newAlerter) public onlyAdmin {
183         require(!alerters[newAlerter]); // prevent duplicates.
184         require(alertersGroup.length < MAX_GROUP_SIZE);
185 
186         AlerterAdded(newAlerter, true);
187         alerters[newAlerter] = true;
188         alertersGroup.push(newAlerter);
189     }
190 
191     function removeAlerter (address alerter) public onlyAdmin {
192         require(alerters[alerter]);
193         alerters[alerter] = false;
194 
195         for (uint i = 0; i < alertersGroup.length; ++i) {
196             if (alertersGroup[i] == alerter) {
197                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
198                 alertersGroup.length--;
199                 AlerterAdded(alerter, false);
200                 break;
201             }
202         }
203     }
204 
205     event OperatorAdded(address newOperator, bool isAdd);
206 
207     function addOperator(address newOperator) public onlyAdmin {
208         require(!operators[newOperator]); // prevent duplicates.
209         require(operatorsGroup.length < MAX_GROUP_SIZE);
210 
211         OperatorAdded(newOperator, true);
212         operators[newOperator] = true;
213         operatorsGroup.push(newOperator);
214     }
215 
216     function removeOperator (address operator) public onlyAdmin {
217         require(operators[operator]);
218         operators[operator] = false;
219 
220         for (uint i = 0; i < operatorsGroup.length; ++i) {
221             if (operatorsGroup[i] == operator) {
222                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
223                 operatorsGroup.length -= 1;
224                 OperatorAdded(operator, false);
225                 break;
226             }
227         }
228     }
229 }
230 
231 // File: contracts/sol4/Withdrawable.sol
232 
233 pragma solidity 0.4.18;
234 
235 
236 
237 
238 /**
239  * @title Contracts that should be able to recover tokens or ethers
240  * @author Ilan Doron
241  * @dev This allows to recover any tokens or Ethers received in a contract.
242  * This will prevent any accidental loss of tokens.
243  */
244 contract Withdrawable is PermissionGroups {
245 
246     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
247 
248     /**
249      * @dev Withdraw all ERC20 compatible tokens
250      * @param token ERC20 The address of the token contract
251      */
252     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
253         require(token.transfer(sendTo, amount));
254         TokenWithdraw(token, amount, sendTo);
255     }
256 
257     event EtherWithdraw(uint amount, address sendTo);
258 
259     /**
260      * @dev Withdraw Ethers
261      */
262     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
263         sendTo.transfer(amount);
264         EtherWithdraw(amount, sendTo);
265     }
266 }
267 
268 // File: contracts/sol4/reserves/VolumeImbalanceRecorder.sol
269 
270 pragma solidity 0.4.18;
271 
272 
273 
274 
275 contract VolumeImbalanceRecorder is Withdrawable {
276 
277     uint constant internal SLIDING_WINDOW_SIZE = 5;
278     uint constant internal POW_2_64 = 2 ** 64;
279 
280     struct TokenControlInfo {
281         uint minimalRecordResolution; // can be roughly 1 cent
282         uint maxPerBlockImbalance; // in twei resolution
283         uint maxTotalImbalance; // max total imbalance (between rate updates)
284                             // before halting trade
285     }
286 
287     mapping(address => TokenControlInfo) internal tokenControlInfo;
288 
289     struct TokenImbalanceData {
290         int  lastBlockBuyUnitsImbalance;
291         uint lastBlock;
292 
293         int  totalBuyUnitsImbalance;
294         uint lastRateUpdateBlock;
295     }
296 
297     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
298 
299     function VolumeImbalanceRecorder(address _admin) public {
300         require(_admin != address(0));
301         admin = _admin;
302     }
303 
304     function setTokenControlInfo(
305         ERC20 token,
306         uint minimalRecordResolution,
307         uint maxPerBlockImbalance,
308         uint maxTotalImbalance
309     )
310         public
311         onlyAdmin
312     {
313         tokenControlInfo[token] =
314             TokenControlInfo(
315                 minimalRecordResolution,
316                 maxPerBlockImbalance,
317                 maxTotalImbalance
318             );
319     }
320 
321     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
322         return (tokenControlInfo[token].minimalRecordResolution,
323                 tokenControlInfo[token].maxPerBlockImbalance,
324                 tokenControlInfo[token].maxTotalImbalance);
325     }
326 
327     function addImbalance(
328         ERC20 token,
329         int buyAmount,
330         uint rateUpdateBlock,
331         uint currentBlock
332     )
333         internal
334     {
335         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
336         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
337 
338         int prevImbalance = 0;
339 
340         TokenImbalanceData memory currentBlockData =
341             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
342 
343         // first scenario - this is not the first tx in the current block
344         if (currentBlockData.lastBlock == currentBlock) {
345             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
346                 // just increase imbalance
347                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
348                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
349             } else {
350                 // imbalance was changed in the middle of the block
351                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
352                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
353                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
354                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
355             }
356         } else {
357             // first tx in the current block
358             int currentBlockImbalance;
359             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
360 
361             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
362             currentBlockData.lastBlock = uint(currentBlock);
363             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
364             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
365         }
366 
367         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
368     }
369 
370     function setGarbageToVolumeRecorder(ERC20 token) internal {
371         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
372             tokenImbalanceData[token][i] = 0x1;
373         }
374     }
375 
376     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
377         // check the imbalance in the sliding window
378         require(startBlock <= endBlock);
379 
380         buyImbalance = 0;
381 
382         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
383             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
384 
385             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
386                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
387             }
388         }
389     }
390 
391     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
392         internal view
393         returns(int buyImbalance, int currentBlockImbalance)
394     {
395         buyImbalance = 0;
396         currentBlockImbalance = 0;
397         uint latestBlock = 0;
398         int imbalanceInRange = 0;
399         uint startBlock = rateUpdateBlock;
400         uint endBlock = currentBlock;
401 
402         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
403             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
404 
405             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
406                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
407             }
408 
409             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
410             if (perBlockData.lastBlock < latestBlock) continue;
411 
412             latestBlock = perBlockData.lastBlock;
413             buyImbalance = perBlockData.totalBuyUnitsImbalance;
414             if (uint(perBlockData.lastBlock) == currentBlock) {
415                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
416             }
417         }
418 
419         if (buyImbalance == 0) {
420             buyImbalance = imbalanceInRange;
421         }
422     }
423 
424     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
425         internal view
426         returns(int totalImbalance, int currentBlockImbalance)
427     {
428 
429         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
430 
431         (totalImbalance, currentBlockImbalance) =
432             getImbalanceSinceRateUpdate(
433                 token,
434                 rateUpdateBlock,
435                 currentBlock);
436 
437         totalImbalance *= resolution;
438         currentBlockImbalance *= resolution;
439     }
440 
441     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
442         return tokenControlInfo[token].maxPerBlockImbalance;
443     }
444 
445     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
446         return tokenControlInfo[token].maxTotalImbalance;
447     }
448 
449     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
450         // check for overflows
451         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
452         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
453         require(data.lastBlock < POW_2_64);
454         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
455         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
456         require(data.lastRateUpdateBlock < POW_2_64);
457 
458         // do encoding
459         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
460         result |= data.lastBlock * POW_2_64;
461         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
462         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
463 
464         return result;
465     }
466 
467     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
468         TokenImbalanceData memory data;
469 
470         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
471         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
472         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
473         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
474 
475         return data;
476     }
477 }
478 
479 // File: contracts/sol4/reserves/fprConversionRate/ConversionRates.sol
480 
481 pragma solidity 0.4.18;
482 
483 
484 
485 
486 
487 
488 contract ConversionRates is ConversionRatesInterface, VolumeImbalanceRecorder, Utils {
489 
490     // bps - basic rate steps. one step is 1 / 10000 of the rate.
491     struct StepFunction {
492         int[] x; // quantity for each step. Quantity of each step includes previous steps.
493         int[] y; // rate change per quantity step  in bps.
494     }
495 
496     struct TokenData {
497         bool listed;  // was added to reserve
498         bool enabled; // whether trade is enabled
499 
500         // position in the compact data
501         uint compactDataArrayIndex;
502         uint compactDataFieldIndex;
503 
504         // rate data. base and changes according to quantity and reserve balance.
505         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
506         uint baseBuyRate;  // in PRECISION units. see KyberConstants
507         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
508         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
509         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
510         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
511         StepFunction sellRateImbalanceStepFunction;
512     }
513 
514     /*
515     this is the data for tokenRatesCompactData
516     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
517     so we represent it as bytes32 and do the byte tricks ourselves.
518     struct TokenRatesCompactData {
519         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
520         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
521 
522         uint32 blockNumber;
523     } */
524     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
525     ERC20[] internal listedTokens;
526     mapping(address=>TokenData) internal tokenData;
527     bytes32[] internal tokenRatesCompactData;
528     uint public numTokensInCurrentCompactData = 0;
529     address public reserveContract;
530     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
531     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
532     uint constant internal MAX_STEPS_IN_FUNCTION = 10;
533     int  constant internal MAX_BPS_ADJUSTMENT = 10 ** 11; // 1B %
534     int  constant internal MIN_BPS_ADJUSTMENT = -100 * 100; // cannot go down by more than 100%
535 
536     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
537         { } // solhint-disable-line no-empty-blocks
538 
539     function addToken(ERC20 token) public onlyAdmin {
540 
541         require(!tokenData[token].listed);
542         tokenData[token].listed = true;
543         listedTokens.push(token);
544 
545         if (numTokensInCurrentCompactData == 0) {
546             tokenRatesCompactData.length++; // add new structure
547         }
548 
549         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
550         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
551 
552         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
553 
554         setGarbageToVolumeRecorder(token);
555 
556         setDecimals(token);
557     }
558 
559     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
560 
561         require(buy.length == sell.length);
562         require(indices.length == buy.length);
563         require(blockNumber <= 0xFFFFFFFF);
564 
565         uint bytes14Offset = BYTES_14_OFFSET;
566 
567         for (uint i = 0; i < indices.length; i++) {
568             require(indices[i] < tokenRatesCompactData.length);
569             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
570             tokenRatesCompactData[indices[i]] = bytes32(data);
571         }
572     }
573 
574     function setBaseRate(
575         ERC20[] tokens,
576         uint[] baseBuy,
577         uint[] baseSell,
578         bytes14[] buy,
579         bytes14[] sell,
580         uint blockNumber,
581         uint[] indices
582     )
583         public
584         onlyOperator
585     {
586         require(tokens.length == baseBuy.length);
587         require(tokens.length == baseSell.length);
588         require(sell.length == buy.length);
589         require(sell.length == indices.length);
590 
591         for (uint ind = 0; ind < tokens.length; ind++) {
592             require(tokenData[tokens[ind]].listed);
593             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
594             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
595         }
596 
597         setCompactData(buy, sell, blockNumber, indices);
598     }
599 
600     function setQtyStepFunction(
601         ERC20 token,
602         int[] xBuy,
603         int[] yBuy,
604         int[] xSell,
605         int[] ySell
606     )
607         public
608         onlyOperator
609     {
610         require(xBuy.length == yBuy.length);
611         require(xSell.length == ySell.length);
612         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
613         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
614         require(tokenData[token].listed);
615 
616         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
617         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
618     }
619 
620     function setImbalanceStepFunction(
621         ERC20 token,
622         int[] xBuy,
623         int[] yBuy,
624         int[] xSell,
625         int[] ySell
626     )
627         public
628         onlyOperator
629     {
630         require(xBuy.length == yBuy.length);
631         require(xSell.length == ySell.length);
632         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
633         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
634         require(tokenData[token].listed);
635 
636         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
637         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
638     }
639 
640     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
641         validRateDurationInBlocks = duration;
642     }
643 
644     function enableTokenTrade(ERC20 token) public onlyAdmin {
645         require(tokenData[token].listed);
646         require(tokenControlInfo[token].minimalRecordResolution != 0);
647         tokenData[token].enabled = true;
648     }
649 
650     function disableTokenTrade(ERC20 token) public onlyAlerter {
651         require(tokenData[token].listed);
652         tokenData[token].enabled = false;
653     }
654 
655     function setReserveAddress(address reserve) public onlyAdmin {
656         reserveContract = reserve;
657     }
658 
659     function recordImbalance(
660         ERC20 token,
661         int buyAmount,
662         uint rateUpdateBlock,
663         uint currentBlock
664     )
665         public
666     {
667         require(msg.sender == reserveContract);
668 
669         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
670 
671         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
672     }
673 
674     /* solhint-disable function-max-lines */
675     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
676         // check if trade is enabled
677         if (!tokenData[token].enabled) return 0;
678         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
679 
680         // get rate update block
681         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
682 
683         uint updateRateBlock = getLast4Bytes(compactData);
684         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
685         // check imbalance
686         int totalImbalance;
687         int blockImbalance;
688         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
689 
690         // calculate actual rate
691         int imbalanceQty;
692         int extraBps;
693         int8 rateUpdate;
694         uint rate;
695 
696         if (buy) {
697             // start with base rate
698             rate = tokenData[token].baseBuyRate;
699 
700             // add rate update
701             rateUpdate = getRateByteFromCompactData(compactData, token, true);
702             extraBps = int(rateUpdate) * 10;
703             rate = addBps(rate, extraBps);
704 
705             // compute token qty
706             qty = getTokenQty(token, rate, qty);
707             imbalanceQty = int(qty);
708             totalImbalance += imbalanceQty;
709 
710             // add qty overhead
711             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
712             rate = addBps(rate, extraBps);
713 
714             // add imbalance overhead
715             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
716             rate = addBps(rate, extraBps);
717         } else {
718             // start with base rate
719             rate = tokenData[token].baseSellRate;
720 
721             // add rate update
722             rateUpdate = getRateByteFromCompactData(compactData, token, false);
723             extraBps = int(rateUpdate) * 10;
724             rate = addBps(rate, extraBps);
725 
726             // compute token qty
727             imbalanceQty = -1 * int(qty);
728             totalImbalance += imbalanceQty;
729 
730             // add qty overhead
731             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
732             rate = addBps(rate, extraBps);
733 
734             // add imbalance overhead
735             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
736             rate = addBps(rate, extraBps);
737         }
738 
739         if (abs(totalImbalance) >= getMaxTotalImbalance(token)) return 0;
740         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
741 
742         return rate;
743     }
744     /* solhint-enable function-max-lines */
745 
746     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
747         if (buy)
748             return tokenData[token].baseBuyRate;
749         else
750             return tokenData[token].baseSellRate;
751     }
752 
753     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
754         require(tokenData[token].listed);
755 
756         uint arrayIndex = tokenData[token].compactDataArrayIndex;
757         uint fieldOffset = tokenData[token].compactDataFieldIndex;
758 
759         return (
760             arrayIndex,
761             fieldOffset,
762             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
763             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
764         );
765     }
766 
767     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
768         return (tokenData[token].listed, tokenData[token].enabled);
769     }
770 
771     /* solhint-disable code-complexity */
772     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
773         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
774         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
775         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
776         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
777 
778         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
779         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
780         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
781         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
782 
783         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
784         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
785         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
786         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
787 
788         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
789         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
790         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
791         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
792 
793         revert();
794     }
795     /* solhint-enable code-complexity */
796 
797     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
798         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
799         return getLast4Bytes(compactData);
800     }
801 
802     function getListedTokens() public view returns(ERC20[]) {
803         return listedTokens;
804     }
805 
806     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
807         uint dstDecimals = getDecimals(token);
808         uint srcDecimals = ETH_DECIMALS;
809 
810         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
811     }
812 
813     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
814         // cannot trust compiler with not turning bit operations into EXP opcode
815         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
816     }
817 
818     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
819         uint fieldOffset = tokenData[token].compactDataFieldIndex;
820         uint byteOffset;
821         if (buy)
822             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
823         else
824             byteOffset = 4 + fieldOffset;
825 
826         return int8(data[byteOffset]);
827     }
828 
829     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
830         uint len = f.y.length;
831         for (uint ind = 0; ind < len; ind++) {
832             if (x <= f.x[ind]) return f.y[ind];
833         }
834 
835         return f.y[len-1];
836     }
837 
838     function addBps(uint rate, int bps) internal pure returns(uint) {
839         require(rate <= MAX_RATE);
840         require(bps >= MIN_BPS_ADJUSTMENT);
841         require(bps <= MAX_BPS_ADJUSTMENT);
842 
843         uint maxBps = 100 * 100;
844         return (rate * uint(int(maxBps) + bps)) / maxBps;
845     }
846 
847     function abs(int x) internal pure returns(uint) {
848         if (x < 0)
849             return uint(-1 * x);
850         else
851             return uint(x);
852     }
853 }