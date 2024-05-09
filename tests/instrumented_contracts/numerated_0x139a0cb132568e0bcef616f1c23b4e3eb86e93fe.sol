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
30     function setQtyStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
31     function setImbalanceStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
32     function claimAdmin() public;
33     function addOperator(address newOperator) public;
34     function transferAdmin(address newAdmin) public;
35     function addToken(ERC20 token) public;
36     function setTokenControlInfo(
37         ERC20 token,
38         uint minimalRecordResolution,
39         uint maxPerBlockImbalance,
40         uint maxTotalImbalance
41     ) public;
42     function enableTokenTrade(ERC20 token) public;
43     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint);
44 }
45 
46 // File: contracts/Utils.sol
47 
48 /// @title Kyber constants contract
49 contract Utils {
50 
51     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
52     uint  constant internal PRECISION = (10**18);
53     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
54     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
55     uint  constant internal MAX_DECIMALS = 18;
56     uint  constant internal ETH_DECIMALS = 18;
57     mapping(address=>uint) internal decimals;
58 
59     function setDecimals(ERC20 token) internal {
60         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
61         else decimals[token] = token.decimals();
62     }
63 
64     function getDecimals(ERC20 token) internal view returns(uint) {
65         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
66         uint tokenDecimals = decimals[token];
67         // technically, there might be token with decimals 0
68         // moreover, very possible that old tokens have decimals 0
69         // these tokens will just have higher gas fees.
70         if(tokenDecimals == 0) return token.decimals();
71 
72         return tokenDecimals;
73     }
74 
75     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
76         require(srcQty <= MAX_QTY);
77         require(rate <= MAX_RATE);
78 
79         if (dstDecimals >= srcDecimals) {
80             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
81             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
82         } else {
83             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
84             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
85         }
86     }
87 
88     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
89         require(dstQty <= MAX_QTY);
90         require(rate <= MAX_RATE);
91         
92         //source quantity is rounded up. to avoid dest quantity being too low.
93         uint numerator;
94         uint denominator;
95         if (srcDecimals >= dstDecimals) {
96             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
97             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
98             denominator = rate;
99         } else {
100             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
101             numerator = (PRECISION * dstQty);
102             denominator = (rate * (10**(dstDecimals - srcDecimals)));
103         }
104         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
105     }
106 }
107 
108 // File: contracts/PermissionGroups.sol
109 
110 contract PermissionGroups {
111 
112     address public admin;
113     address public pendingAdmin;
114     mapping(address=>bool) internal operators;
115     mapping(address=>bool) internal alerters;
116     address[] internal operatorsGroup;
117     address[] internal alertersGroup;
118     uint constant internal MAX_GROUP_SIZE = 50;
119 
120     function PermissionGroups() public {
121         admin = msg.sender;
122     }
123 
124     modifier onlyAdmin() {
125         require(msg.sender == admin);
126         _;
127     }
128 
129     modifier onlyOperator() {
130         require(operators[msg.sender]);
131         _;
132     }
133 
134     modifier onlyAlerter() {
135         require(alerters[msg.sender]);
136         _;
137     }
138 
139     function getOperators () external view returns(address[]) {
140         return operatorsGroup;
141     }
142 
143     function getAlerters () external view returns(address[]) {
144         return alertersGroup;
145     }
146 
147     event TransferAdminPending(address pendingAdmin);
148 
149     /**
150      * @dev Allows the current admin to set the pendingAdmin address.
151      * @param newAdmin The address to transfer ownership to.
152      */
153     function transferAdmin(address newAdmin) public onlyAdmin {
154         require(newAdmin != address(0));
155         TransferAdminPending(pendingAdmin);
156         pendingAdmin = newAdmin;
157     }
158 
159     /**
160      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
161      * @param newAdmin The address to transfer ownership to.
162      */
163     function transferAdminQuickly(address newAdmin) public onlyAdmin {
164         require(newAdmin != address(0));
165         TransferAdminPending(newAdmin);
166         AdminClaimed(newAdmin, admin);
167         admin = newAdmin;
168     }
169 
170     event AdminClaimed( address newAdmin, address previousAdmin);
171 
172     /**
173      * @dev Allows the pendingAdmin address to finalize the change admin process.
174      */
175     function claimAdmin() public {
176         require(pendingAdmin == msg.sender);
177         AdminClaimed(pendingAdmin, admin);
178         admin = pendingAdmin;
179         pendingAdmin = address(0);
180     }
181 
182     event AlerterAdded (address newAlerter, bool isAdd);
183 
184     function addAlerter(address newAlerter) public onlyAdmin {
185         require(!alerters[newAlerter]); // prevent duplicates.
186         require(alertersGroup.length < MAX_GROUP_SIZE);
187 
188         AlerterAdded(newAlerter, true);
189         alerters[newAlerter] = true;
190         alertersGroup.push(newAlerter);
191     }
192 
193     function removeAlerter (address alerter) public onlyAdmin {
194         require(alerters[alerter]);
195         alerters[alerter] = false;
196 
197         for (uint i = 0; i < alertersGroup.length; ++i) {
198             if (alertersGroup[i] == alerter) {
199                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
200                 alertersGroup.length--;
201                 AlerterAdded(alerter, false);
202                 break;
203             }
204         }
205     }
206 
207     event OperatorAdded(address newOperator, bool isAdd);
208 
209     function addOperator(address newOperator) public onlyAdmin {
210         require(!operators[newOperator]); // prevent duplicates.
211         require(operatorsGroup.length < MAX_GROUP_SIZE);
212 
213         OperatorAdded(newOperator, true);
214         operators[newOperator] = true;
215         operatorsGroup.push(newOperator);
216     }
217 
218     function removeOperator (address operator) public onlyAdmin {
219         require(operators[operator]);
220         operators[operator] = false;
221 
222         for (uint i = 0; i < operatorsGroup.length; ++i) {
223             if (operatorsGroup[i] == operator) {
224                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
225                 operatorsGroup.length -= 1;
226                 OperatorAdded(operator, false);
227                 break;
228             }
229         }
230     }
231 }
232 
233 // File: contracts/Withdrawable.sol
234 
235 /**
236  * @title Contracts that should be able to recover tokens or ethers
237  * @author Ilan Doron
238  * @dev This allows to recover any tokens or Ethers received in a contract.
239  * This will prevent any accidental loss of tokens.
240  */
241 contract Withdrawable is PermissionGroups {
242 
243     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
244 
245     /**
246      * @dev Withdraw all ERC20 compatible tokens
247      * @param token ERC20 The address of the token contract
248      */
249     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
250         require(token.transfer(sendTo, amount));
251         TokenWithdraw(token, amount, sendTo);
252     }
253 
254     event EtherWithdraw(uint amount, address sendTo);
255 
256     /**
257      * @dev Withdraw Ethers
258      */
259     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
260         sendTo.transfer(amount);
261         EtherWithdraw(amount, sendTo);
262     }
263 }
264 
265 // File: contracts/VolumeImbalanceRecorder.sol
266 
267 contract VolumeImbalanceRecorder is Withdrawable {
268 
269     uint constant internal SLIDING_WINDOW_SIZE = 5;
270     uint constant internal POW_2_64 = 2 ** 64;
271 
272     struct TokenControlInfo {
273         uint minimalRecordResolution; // can be roughly 1 cent
274         uint maxPerBlockImbalance; // in twei resolution
275         uint maxTotalImbalance; // max total imbalance (between rate updates)
276                             // before halting trade
277     }
278 
279     mapping(address => TokenControlInfo) internal tokenControlInfo;
280 
281     struct TokenImbalanceData {
282         int  lastBlockBuyUnitsImbalance;
283         uint lastBlock;
284 
285         int  totalBuyUnitsImbalance;
286         uint lastRateUpdateBlock;
287     }
288 
289     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
290 
291     function VolumeImbalanceRecorder(address _admin) public {
292         require(_admin != address(0));
293         admin = _admin;
294     }
295 
296     function setTokenControlInfo(
297         ERC20 token,
298         uint minimalRecordResolution,
299         uint maxPerBlockImbalance,
300         uint maxTotalImbalance
301     )
302         public
303         onlyAdmin
304     {
305         tokenControlInfo[token] =
306             TokenControlInfo(
307                 minimalRecordResolution,
308                 maxPerBlockImbalance,
309                 maxTotalImbalance
310             );
311     }
312 
313     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
314         return (tokenControlInfo[token].minimalRecordResolution,
315                 tokenControlInfo[token].maxPerBlockImbalance,
316                 tokenControlInfo[token].maxTotalImbalance);
317     }
318 
319     function addImbalance(
320         ERC20 token,
321         int buyAmount,
322         uint rateUpdateBlock,
323         uint currentBlock
324     )
325         internal
326     {
327         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
328         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
329 
330         int prevImbalance = 0;
331 
332         TokenImbalanceData memory currentBlockData =
333             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
334 
335         // first scenario - this is not the first tx in the current block
336         if (currentBlockData.lastBlock == currentBlock) {
337             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
338                 // just increase imbalance
339                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
340                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
341             } else {
342                 // imbalance was changed in the middle of the block
343                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
344                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
345                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
346                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
347             }
348         } else {
349             // first tx in the current block
350             int currentBlockImbalance;
351             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
352 
353             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
354             currentBlockData.lastBlock = uint(currentBlock);
355             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
356             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
357         }
358 
359         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
360     }
361 
362     function setGarbageToVolumeRecorder(ERC20 token) internal {
363         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
364             tokenImbalanceData[token][i] = 0x1;
365         }
366     }
367 
368     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
369         // check the imbalance in the sliding window
370         require(startBlock <= endBlock);
371 
372         buyImbalance = 0;
373 
374         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
375             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
376 
377             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
378                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
379             }
380         }
381     }
382 
383     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
384         internal view
385         returns(int buyImbalance, int currentBlockImbalance)
386     {
387         buyImbalance = 0;
388         currentBlockImbalance = 0;
389         uint latestBlock = 0;
390         int imbalanceInRange = 0;
391         uint startBlock = rateUpdateBlock;
392         uint endBlock = currentBlock;
393 
394         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
395             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
396 
397             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
398                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
399             }
400 
401             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
402             if (perBlockData.lastBlock < latestBlock) continue;
403 
404             latestBlock = perBlockData.lastBlock;
405             buyImbalance = perBlockData.totalBuyUnitsImbalance;
406             if (uint(perBlockData.lastBlock) == currentBlock) {
407                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
408             }
409         }
410 
411         if (buyImbalance == 0) {
412             buyImbalance = imbalanceInRange;
413         }
414     }
415 
416     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
417         internal view
418         returns(int totalImbalance, int currentBlockImbalance)
419     {
420 
421         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
422 
423         (totalImbalance, currentBlockImbalance) =
424             getImbalanceSinceRateUpdate(
425                 token,
426                 rateUpdateBlock,
427                 currentBlock);
428 
429         totalImbalance *= resolution;
430         currentBlockImbalance *= resolution;
431     }
432 
433     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
434         return tokenControlInfo[token].maxPerBlockImbalance;
435     }
436 
437     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
438         return tokenControlInfo[token].maxTotalImbalance;
439     }
440 
441     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
442         // check for overflows
443         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
444         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
445         require(data.lastBlock < POW_2_64);
446         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
447         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
448         require(data.lastRateUpdateBlock < POW_2_64);
449 
450         // do encoding
451         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
452         result |= data.lastBlock * POW_2_64;
453         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
454         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
455 
456         return result;
457     }
458 
459     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
460         TokenImbalanceData memory data;
461 
462         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
463         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
464         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
465         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
466 
467         return data;
468     }
469 }
470 
471 // File: contracts/ConversionRates.sol
472 
473 contract ConversionRates is ConversionRatesInterface, VolumeImbalanceRecorder, Utils {
474 
475     // bps - basic rate steps. one step is 1 / 10000 of the rate.
476     struct StepFunction {
477         int[] x; // quantity for each step. Quantity of each step includes previous steps.
478         int[] y; // rate change per quantity step  in bps.
479     }
480 
481     struct TokenData {
482         bool listed;  // was added to reserve
483         bool enabled; // whether trade is enabled
484 
485         // position in the compact data
486         uint compactDataArrayIndex;
487         uint compactDataFieldIndex;
488 
489         // rate data. base and changes according to quantity and reserve balance.
490         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
491         uint baseBuyRate;  // in PRECISION units. see KyberConstants
492         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
493         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
494         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
495         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
496         StepFunction sellRateImbalanceStepFunction;
497     }
498 
499     /*
500     this is the data for tokenRatesCompactData
501     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
502     so we represent it as bytes32 and do the byte tricks ourselves.
503     struct TokenRatesCompactData {
504         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
505         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
506 
507         uint32 blockNumber;
508     } */
509     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
510     ERC20[] internal listedTokens;
511     mapping(address=>TokenData) internal tokenData;
512     bytes32[] internal tokenRatesCompactData;
513     uint public numTokensInCurrentCompactData = 0;
514     address public reserveContract;
515     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
516     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
517     uint constant internal MAX_STEPS_IN_FUNCTION = 10;
518     int  constant internal MAX_BPS_ADJUSTMENT = 10 ** 11; // 1B %
519     int  constant internal MIN_BPS_ADJUSTMENT = -100 * 100; // cannot go down by more than 100%
520 
521     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
522         { } // solhint-disable-line no-empty-blocks
523 
524     function addToken(ERC20 token) public onlyAdmin {
525 
526         require(!tokenData[token].listed);
527         tokenData[token].listed = true;
528         listedTokens.push(token);
529 
530         if (numTokensInCurrentCompactData == 0) {
531             tokenRatesCompactData.length++; // add new structure
532         }
533 
534         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
535         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
536 
537         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
538 
539         setGarbageToVolumeRecorder(token);
540 
541         setDecimals(token);
542     }
543 
544     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
545 
546         require(buy.length == sell.length);
547         require(indices.length == buy.length);
548         require(blockNumber <= 0xFFFFFFFF);
549 
550         uint bytes14Offset = BYTES_14_OFFSET;
551 
552         for (uint i = 0; i < indices.length; i++) {
553             require(indices[i] < tokenRatesCompactData.length);
554             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
555             tokenRatesCompactData[indices[i]] = bytes32(data);
556         }
557     }
558 
559     function setBaseRate(
560         ERC20[] tokens,
561         uint[] baseBuy,
562         uint[] baseSell,
563         bytes14[] buy,
564         bytes14[] sell,
565         uint blockNumber,
566         uint[] indices
567     )
568         public
569         onlyOperator
570     {
571         require(tokens.length == baseBuy.length);
572         require(tokens.length == baseSell.length);
573         require(sell.length == buy.length);
574         require(sell.length == indices.length);
575 
576         for (uint ind = 0; ind < tokens.length; ind++) {
577             require(tokenData[tokens[ind]].listed);
578             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
579             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
580         }
581 
582         setCompactData(buy, sell, blockNumber, indices);
583     }
584 
585     function setQtyStepFunction(
586         ERC20 token,
587         int[] xBuy,
588         int[] yBuy,
589         int[] xSell,
590         int[] ySell
591     )
592         public
593         onlyOperator
594     {
595         require(xBuy.length == yBuy.length);
596         require(xSell.length == ySell.length);
597         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
598         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
599         require(tokenData[token].listed);
600 
601         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
602         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
603     }
604 
605     function setImbalanceStepFunction(
606         ERC20 token,
607         int[] xBuy,
608         int[] yBuy,
609         int[] xSell,
610         int[] ySell
611     )
612         public
613         onlyOperator
614     {
615         require(xBuy.length == yBuy.length);
616         require(xSell.length == ySell.length);
617         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
618         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
619         require(tokenData[token].listed);
620 
621         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
622         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
623     }
624 
625     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
626         validRateDurationInBlocks = duration;
627     }
628 
629     function enableTokenTrade(ERC20 token) public onlyAdmin {
630         require(tokenData[token].listed);
631         require(tokenControlInfo[token].minimalRecordResolution != 0);
632         tokenData[token].enabled = true;
633     }
634 
635     function disableTokenTrade(ERC20 token) public onlyAlerter {
636         require(tokenData[token].listed);
637         tokenData[token].enabled = false;
638     }
639 
640     function setReserveAddress(address reserve) public onlyAdmin {
641         reserveContract = reserve;
642     }
643 
644     function recordImbalance(
645         ERC20 token,
646         int buyAmount,
647         uint rateUpdateBlock,
648         uint currentBlock
649     )
650         public
651     {
652         require(msg.sender == reserveContract);
653 
654         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
655 
656         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
657     }
658 
659     /* solhint-disable function-max-lines */
660     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
661         // check if trade is enabled
662         if (!tokenData[token].enabled) return 0;
663         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
664 
665         // get rate update block
666         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
667 
668         uint updateRateBlock = getLast4Bytes(compactData);
669         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
670         // check imbalance
671         int totalImbalance;
672         int blockImbalance;
673         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
674 
675         // calculate actual rate
676         int imbalanceQty;
677         int extraBps;
678         int8 rateUpdate;
679         uint rate;
680 
681         if (buy) {
682             // start with base rate
683             rate = tokenData[token].baseBuyRate;
684 
685             // add rate update
686             rateUpdate = getRateByteFromCompactData(compactData, token, true);
687             extraBps = int(rateUpdate) * 10;
688             rate = addBps(rate, extraBps);
689 
690             // compute token qty
691             qty = getTokenQty(token, rate, qty);
692             imbalanceQty = int(qty);
693             totalImbalance += imbalanceQty;
694 
695             // add qty overhead
696             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
697             rate = addBps(rate, extraBps);
698 
699             // add imbalance overhead
700             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
701             rate = addBps(rate, extraBps);
702         } else {
703             // start with base rate
704             rate = tokenData[token].baseSellRate;
705 
706             // add rate update
707             rateUpdate = getRateByteFromCompactData(compactData, token, false);
708             extraBps = int(rateUpdate) * 10;
709             rate = addBps(rate, extraBps);
710 
711             // compute token qty
712             imbalanceQty = -1 * int(qty);
713             totalImbalance += imbalanceQty;
714 
715             // add qty overhead
716             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
717             rate = addBps(rate, extraBps);
718 
719             // add imbalance overhead
720             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
721             rate = addBps(rate, extraBps);
722         }
723 
724         if (abs(totalImbalance) >= getMaxTotalImbalance(token)) return 0;
725         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
726 
727         return rate;
728     }
729     /* solhint-enable function-max-lines */
730 
731     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
732         if (buy)
733             return tokenData[token].baseBuyRate;
734         else
735             return tokenData[token].baseSellRate;
736     }
737 
738     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
739         require(tokenData[token].listed);
740 
741         uint arrayIndex = tokenData[token].compactDataArrayIndex;
742         uint fieldOffset = tokenData[token].compactDataFieldIndex;
743 
744         return (
745             arrayIndex,
746             fieldOffset,
747             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
748             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
749         );
750     }
751 
752     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
753         return (tokenData[token].listed, tokenData[token].enabled);
754     }
755 
756     /* solhint-disable code-complexity */
757     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
758         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
759         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
760         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
761         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
762 
763         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
764         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
765         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
766         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
767 
768         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
769         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
770         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
771         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
772 
773         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
774         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
775         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
776         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
777 
778         revert();
779     }
780     /* solhint-enable code-complexity */
781 
782     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
783         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
784         return getLast4Bytes(compactData);
785     }
786 
787     function getListedTokens() public view returns(ERC20[]) {
788         return listedTokens;
789     }
790 
791     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
792         uint dstDecimals = getDecimals(token);
793         uint srcDecimals = ETH_DECIMALS;
794 
795         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
796     }
797 
798     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
799         // cannot trust compiler with not turning bit operations into EXP opcode
800         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
801     }
802 
803     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
804         uint fieldOffset = tokenData[token].compactDataFieldIndex;
805         uint byteOffset;
806         if (buy)
807             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
808         else
809             byteOffset = 4 + fieldOffset;
810 
811         return int8(data[byteOffset]);
812     }
813 
814     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
815         uint len = f.y.length;
816         for (uint ind = 0; ind < len; ind++) {
817             if (x <= f.x[ind]) return f.y[ind];
818         }
819 
820         return f.y[len-1];
821     }
822 
823     function addBps(uint rate, int bps) internal pure returns(uint) {
824         require(rate <= MAX_RATE);
825         require(bps >= MIN_BPS_ADJUSTMENT);
826         require(bps <= MAX_BPS_ADJUSTMENT);
827 
828         uint maxBps = 100 * 100;
829         return (rate * uint(int(maxBps) + bps)) / maxBps;
830     }
831 
832     function abs(int x) internal pure returns(uint) {
833         if (x < 0)
834             return uint(-1 * x);
835         else
836             return uint(x);
837     }
838 }
839 
840 // File: contracts/wrapperContracts/WrapperBase.sol
841 
842 contract WrapperBase is Withdrawable {
843 
844     PermissionGroups wrappedContract;
845 
846     struct DataTracker {
847         address [] approveSignatureArray;
848         uint lastSetNonce;
849     }
850 
851     DataTracker[] internal dataInstances;
852 
853     function WrapperBase(PermissionGroups _wrappedContract, address _admin, uint _numDataInstances) public {
854         require(_wrappedContract != address(0));
855         require(_admin != address(0));
856         wrappedContract = _wrappedContract;
857         admin = _admin;
858 
859         for (uint i = 0; i < _numDataInstances; i++){
860             addDataInstance();
861         }
862     }
863 
864     function claimWrappedContractAdmin() public onlyOperator {
865         wrappedContract.claimAdmin();
866     }
867 
868     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
869         wrappedContract.transferAdmin(newAdmin);
870     }
871 
872     function addDataInstance() internal {
873         address[] memory add = new address[](0);
874         dataInstances.push(DataTracker(add, 0));
875     }
876 
877     function setNewData(uint dataIndex) internal {
878         require(dataIndex < dataInstances.length);
879         dataInstances[dataIndex].lastSetNonce++;
880         dataInstances[dataIndex].approveSignatureArray.length = 0;
881     }
882 
883     function addSignature(uint dataIndex, uint signedNonce, address signer) internal returns(bool allSigned) {
884         require(dataIndex < dataInstances.length);
885         require(dataInstances[dataIndex].lastSetNonce == signedNonce);
886 
887         for(uint i = 0; i < dataInstances[dataIndex].approveSignatureArray.length; i++) {
888             if (signer == dataInstances[dataIndex].approveSignatureArray[i]) revert();
889         }
890         dataInstances[dataIndex].approveSignatureArray.push(signer);
891 
892         if (dataInstances[dataIndex].approveSignatureArray.length == operatorsGroup.length) {
893             allSigned = true;
894         } else {
895             allSigned = false;
896         }
897     }
898 
899     function getWrappedContract() public view returns (PermissionGroups _wrappedContract) {
900         return(wrappedContract);
901     }
902 
903     function getDataTrackingParameters(uint index) internal view returns (address[], uint) {
904         require(index < dataInstances.length);
905         return(dataInstances[index].approveSignatureArray, dataInstances[index].lastSetNonce);
906     }
907 }
908 
909 // File: contracts/wrapperContracts/WrapConversionRate.sol
910 
911 contract WrapConversionRate is WrapperBase {
912 
913     ConversionRates conversionRates;
914 
915     //add token parameters
916     ERC20     addTokenToken;
917     uint      addTokenMinimalResolution; // can be roughly 1 cent
918     uint      addTokenMaxPerBlockImbalance; // in twei resolution
919     uint      addTokenMaxTotalImbalance;
920 
921     //set token control info parameters.
922     ERC20[]     tokenInfoTokenList;
923     uint[]      tokenInfoPerBlockImbalance; // in twei resolution
924     uint[]      tokenInfoMaxTotalImbalance;
925 
926     //valid duration
927     uint pendingValidDurationBlocks;
928 
929     //data indexes
930     uint constant addTokenDataIndex = 0;
931     uint constant tokenInfoDataIndex = 1;
932     uint constant validDurationIndex = 2;
933     uint constant numDataInstances = 3;
934 
935     //general functions
936     function WrapConversionRate(ConversionRates _conversionRates, address _admin) public
937         WrapperBase(PermissionGroups(address(_conversionRates)), _admin, numDataInstances)
938     {
939         require (_conversionRates != address(0));
940         conversionRates = _conversionRates;
941     }
942 
943     // add token functions
944     //////////////////////
945     function setAddTokenData(ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance) public onlyOperator {
946         require(minimalRecordResolution != 0);
947         require(maxPerBlockImbalance != 0);
948         require(maxTotalImbalance != 0);
949 
950         //update data tracking
951         setNewData(addTokenDataIndex);
952 
953         addTokenToken = token;
954         addTokenMinimalResolution = minimalRecordResolution; // can be roughly 1 cent
955         addTokenMaxPerBlockImbalance = maxPerBlockImbalance; // in twei resolution
956         addTokenMaxTotalImbalance = maxTotalImbalance;
957     }
958 
959     function approveAddTokenData(uint nonce) public onlyOperator {
960         if(addSignature(addTokenDataIndex, nonce, msg.sender)) {
961             // can perform operation.
962             performAddToken();
963         }
964     }
965 
966     function performAddToken() internal {
967         conversionRates.addToken(addTokenToken);
968 
969         conversionRates.addOperator(this);
970 
971         //token control info
972         conversionRates.setTokenControlInfo(
973             addTokenToken,
974             addTokenMinimalResolution,
975             addTokenMaxPerBlockImbalance,
976             addTokenMaxTotalImbalance
977         );
978 
979         //step functions
980         int[] memory zeroArr = new int[](1);
981         zeroArr[0] = 0;
982 
983         conversionRates.setQtyStepFunction(addTokenToken, zeroArr, zeroArr, zeroArr, zeroArr);
984         conversionRates.setImbalanceStepFunction(addTokenToken, zeroArr, zeroArr, zeroArr, zeroArr);
985 
986         conversionRates.enableTokenTrade(addTokenToken);
987 
988         conversionRates.removeOperator(this);
989     }
990 
991     function getAddTokenParameters() public view
992         returns(uint nonce, ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance)
993     {
994         (, nonce) = getDataTrackingParameters(addTokenDataIndex);
995         token = addTokenToken;
996         minimalRecordResolution = addTokenMinimalResolution;
997         maxPerBlockImbalance = addTokenMaxPerBlockImbalance; // in twei resolution
998         maxTotalImbalance = addTokenMaxTotalImbalance;
999         return(nonce, token, minimalRecordResolution, maxPerBlockImbalance, maxTotalImbalance);
1000     }
1001 
1002     function getAddTokenSignatures() public view returns (address[] signatures) {
1003         uint nonce;
1004         (signatures, nonce) = getDataTrackingParameters(addTokenDataIndex);
1005         return(signatures);
1006     }
1007 
1008     function getAddTokenNonce() public view returns (uint nonce) {
1009         address[] memory signatures;
1010         (signatures, nonce) = getDataTrackingParameters(addTokenDataIndex);
1011         return(nonce);
1012     }
1013 
1014     //set token control info
1015     ////////////////////////
1016     function setTokenInfoData(ERC20 [] tokens, uint[] maxPerBlockImbalanceValues, uint[] maxTotalImbalanceValues)
1017         public
1018         onlyOperator
1019     {
1020         require(maxPerBlockImbalanceValues.length == tokens.length);
1021         require(maxTotalImbalanceValues.length == tokens.length);
1022 
1023         //update data tracking
1024         setNewData(tokenInfoDataIndex);
1025 
1026         tokenInfoTokenList = tokens;
1027         tokenInfoPerBlockImbalance = maxPerBlockImbalanceValues;
1028         tokenInfoMaxTotalImbalance = maxTotalImbalanceValues;
1029     }
1030 
1031     function approveTokenControlInfo(uint nonce) public onlyOperator {
1032         if(addSignature(tokenInfoDataIndex, nonce, msg.sender)) {
1033             // can perform operation.
1034             performSetTokenControlInfo();
1035         }
1036     }
1037 
1038     function performSetTokenControlInfo() internal {
1039         require(tokenInfoTokenList.length == tokenInfoPerBlockImbalance.length);
1040         require(tokenInfoTokenList.length == tokenInfoMaxTotalImbalance.length);
1041 
1042         uint minimalRecordResolution;
1043 
1044         for (uint i = 0; i < tokenInfoTokenList.length; i++) {
1045             (minimalRecordResolution, , ) =
1046                 conversionRates.getTokenControlInfo(tokenInfoTokenList[i]);
1047             require(minimalRecordResolution != 0);
1048 
1049             conversionRates.setTokenControlInfo(tokenInfoTokenList[i],
1050                                                 minimalRecordResolution,
1051                                                 tokenInfoPerBlockImbalance[i],
1052                                                 tokenInfoMaxTotalImbalance[i]);
1053         }
1054     }
1055 
1056     function getControlInfoPerToken (uint index) public view returns(ERC20 token, uint _maxPerBlockImbalance, uint _maxTotalImbalance) {
1057         require (tokenInfoTokenList.length > index);
1058         require (tokenInfoPerBlockImbalance.length > index);
1059         require (tokenInfoMaxTotalImbalance.length > index);
1060 
1061         return(tokenInfoTokenList[index], tokenInfoPerBlockImbalance[index], tokenInfoMaxTotalImbalance[index]);
1062     }
1063 
1064 
1065 
1066     function getTokenInfoData() public view returns(uint nonce, uint numSetTokens, ERC20[] tokenAddress, uint[] maxPerBlock, uint[] maxTotal) {
1067         (, nonce) = getDataTrackingParameters(tokenInfoDataIndex);
1068         return(nonce, tokenInfoTokenList.length, tokenInfoTokenList, tokenInfoPerBlockImbalance, tokenInfoMaxTotalImbalance);
1069     }
1070 
1071     function getTokenInfoSignatures() public view returns (address[] signatures) {
1072         uint nonce;
1073         (signatures, nonce) = getDataTrackingParameters(tokenInfoDataIndex);
1074         return(signatures);
1075     }
1076 
1077     function getTokenInfoNonce() public view returns(uint nonce) {
1078         address[] memory signatures;
1079         (signatures, nonce) = getDataTrackingParameters(tokenInfoDataIndex);
1080         return nonce;
1081     }
1082 
1083     //valid duration blocks
1084     ///////////////////////
1085     function setValidDurationData(uint validDurationBlocks) public onlyOperator {
1086         require(validDurationBlocks > 5);
1087 
1088         //update data tracking
1089         setNewData(validDurationIndex);
1090 
1091         pendingValidDurationBlocks = validDurationBlocks;
1092     }
1093 
1094     function approveValidDurationData(uint nonce) public onlyOperator {
1095         if(addSignature(validDurationIndex, nonce, msg.sender)) {
1096             // can perform operation.
1097             conversionRates.setValidRateDurationInBlocks(pendingValidDurationBlocks);
1098         }
1099     }
1100 
1101     function getValidDurationBlocksData() public view returns(uint validDuration, uint nonce) {
1102         (, nonce) = getDataTrackingParameters(validDurationIndex);
1103         return(nonce, pendingValidDurationBlocks);
1104     }
1105 
1106     function getValidDurationSignatures() public view returns (address[] signatures) {
1107         uint nonce;
1108         (signatures, nonce) = getDataTrackingParameters(validDurationIndex);
1109         return(signatures);
1110     }
1111 
1112     function getValidDurationNonce() public view returns (uint nonce) {
1113         address[] memory signatures;
1114         (signatures, nonce) = getDataTrackingParameters(validDurationIndex);
1115         return(nonce);
1116     }
1117 }