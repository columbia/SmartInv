1 pragma solidity 0.4.18;
2 
3 // File: ../../wrapConvRate/smart-contracts/contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 contract ERC20 {
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
17 // File: ../../wrapConvRate/smart-contracts/contracts/ConversionRatesInterface.sol
18 
19 contract ConversionRatesInterface {
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
32 // File: ../../wrapConvRate/smart-contracts/contracts/Utils.sol
33 
34 /// @title Kyber constants contract
35 contract Utils {
36 
37     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
38     uint  constant internal PRECISION = (10**18);
39     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
40     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
41     uint  constant internal MAX_DECIMALS = 18;
42     uint  constant internal ETH_DECIMALS = 18;
43     mapping(address=>uint) internal decimals;
44 
45     function setDecimals(ERC20 token) internal {
46         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
47         else decimals[token] = token.decimals();
48     }
49 
50     function getDecimals(ERC20 token) internal view returns(uint) {
51         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
52         uint tokenDecimals = decimals[token];
53         // technically, there might be token with decimals 0
54         // moreover, very possible that old tokens have decimals 0
55         // these tokens will just have higher gas fees.
56         if(tokenDecimals == 0) return token.decimals();
57 
58         return tokenDecimals;
59     }
60 
61     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
62         require(srcQty <= MAX_QTY);
63         require(rate <= MAX_RATE);
64 
65         if (dstDecimals >= srcDecimals) {
66             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
67             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
68         } else {
69             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
70             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
71         }
72     }
73 
74     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
75         require(dstQty <= MAX_QTY);
76         require(rate <= MAX_RATE);
77         
78         //source quantity is rounded up. to avoid dest quantity being too low.
79         uint numerator;
80         uint denominator;
81         if (srcDecimals >= dstDecimals) {
82             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
83             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
84             denominator = rate;
85         } else {
86             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
87             numerator = (PRECISION * dstQty);
88             denominator = (rate * (10**(dstDecimals - srcDecimals)));
89         }
90         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
91     }
92 }
93 
94 // File: ../../wrapConvRate/smart-contracts/contracts/PermissionGroups.sol
95 
96 contract PermissionGroups {
97 
98     address public admin;
99     address public pendingAdmin;
100     mapping(address=>bool) internal operators;
101     mapping(address=>bool) internal alerters;
102     address[] internal operatorsGroup;
103     address[] internal alertersGroup;
104     uint constant internal MAX_GROUP_SIZE = 50;
105 
106     function PermissionGroups() public {
107         admin = msg.sender;
108     }
109 
110     modifier onlyAdmin() {
111         require(msg.sender == admin);
112         _;
113     }
114 
115     modifier onlyOperator() {
116         require(operators[msg.sender]);
117         _;
118     }
119 
120     modifier onlyAlerter() {
121         require(alerters[msg.sender]);
122         _;
123     }
124 
125     function getOperators () external view returns(address[]) {
126         return operatorsGroup;
127     }
128 
129     function getAlerters () external view returns(address[]) {
130         return alertersGroup;
131     }
132 
133     event TransferAdminPending(address pendingAdmin);
134 
135     /**
136      * @dev Allows the current admin to set the pendingAdmin address.
137      * @param newAdmin The address to transfer ownership to.
138      */
139     function transferAdmin(address newAdmin) public onlyAdmin {
140         require(newAdmin != address(0));
141         TransferAdminPending(pendingAdmin);
142         pendingAdmin = newAdmin;
143     }
144 
145     /**
146      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
147      * @param newAdmin The address to transfer ownership to.
148      */
149     function transferAdminQuickly(address newAdmin) public onlyAdmin {
150         require(newAdmin != address(0));
151         TransferAdminPending(newAdmin);
152         AdminClaimed(newAdmin, admin);
153         admin = newAdmin;
154     }
155 
156     event AdminClaimed( address newAdmin, address previousAdmin);
157 
158     /**
159      * @dev Allows the pendingAdmin address to finalize the change admin process.
160      */
161     function claimAdmin() public {
162         require(pendingAdmin == msg.sender);
163         AdminClaimed(pendingAdmin, admin);
164         admin = pendingAdmin;
165         pendingAdmin = address(0);
166     }
167 
168     event AlerterAdded (address newAlerter, bool isAdd);
169 
170     function addAlerter(address newAlerter) public onlyAdmin {
171         require(!alerters[newAlerter]); // prevent duplicates.
172         require(alertersGroup.length < MAX_GROUP_SIZE);
173 
174         AlerterAdded(newAlerter, true);
175         alerters[newAlerter] = true;
176         alertersGroup.push(newAlerter);
177     }
178 
179     function removeAlerter (address alerter) public onlyAdmin {
180         require(alerters[alerter]);
181         alerters[alerter] = false;
182 
183         for (uint i = 0; i < alertersGroup.length; ++i) {
184             if (alertersGroup[i] == alerter) {
185                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
186                 alertersGroup.length--;
187                 AlerterAdded(alerter, false);
188                 break;
189             }
190         }
191     }
192 
193     event OperatorAdded(address newOperator, bool isAdd);
194 
195     function addOperator(address newOperator) public onlyAdmin {
196         require(!operators[newOperator]); // prevent duplicates.
197         require(operatorsGroup.length < MAX_GROUP_SIZE);
198 
199         OperatorAdded(newOperator, true);
200         operators[newOperator] = true;
201         operatorsGroup.push(newOperator);
202     }
203 
204     function removeOperator (address operator) public onlyAdmin {
205         require(operators[operator]);
206         operators[operator] = false;
207 
208         for (uint i = 0; i < operatorsGroup.length; ++i) {
209             if (operatorsGroup[i] == operator) {
210                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
211                 operatorsGroup.length -= 1;
212                 OperatorAdded(operator, false);
213                 break;
214             }
215         }
216     }
217 }
218 
219 // File: ../../wrapConvRate/smart-contracts/contracts/Withdrawable.sol
220 
221 /**
222  * @title Contracts that should be able to recover tokens or ethers
223  * @author Ilan Doron
224  * @dev This allows to recover any tokens or Ethers received in a contract.
225  * This will prevent any accidental loss of tokens.
226  */
227 contract Withdrawable is PermissionGroups {
228 
229     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
230 
231     /**
232      * @dev Withdraw all ERC20 compatible tokens
233      * @param token ERC20 The address of the token contract
234      */
235     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
236         require(token.transfer(sendTo, amount));
237         TokenWithdraw(token, amount, sendTo);
238     }
239 
240     event EtherWithdraw(uint amount, address sendTo);
241 
242     /**
243      * @dev Withdraw Ethers
244      */
245     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
246         sendTo.transfer(amount);
247         EtherWithdraw(amount, sendTo);
248     }
249 }
250 
251 // File: ../../wrapConvRate/smart-contracts/contracts/VolumeImbalanceRecorder.sol
252 
253 contract VolumeImbalanceRecorder is Withdrawable {
254 
255     uint constant internal SLIDING_WINDOW_SIZE = 5;
256     uint constant internal POW_2_64 = 2 ** 64;
257 
258     struct TokenControlInfo {
259         uint minimalRecordResolution; // can be roughly 1 cent
260         uint maxPerBlockImbalance; // in twei resolution
261         uint maxTotalImbalance; // max total imbalance (between rate updates)
262                             // before halting trade
263     }
264 
265     mapping(address => TokenControlInfo) internal tokenControlInfo;
266 
267     struct TokenImbalanceData {
268         int  lastBlockBuyUnitsImbalance;
269         uint lastBlock;
270 
271         int  totalBuyUnitsImbalance;
272         uint lastRateUpdateBlock;
273     }
274 
275     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
276 
277     function VolumeImbalanceRecorder(address _admin) public {
278         require(_admin != address(0));
279         admin = _admin;
280     }
281 
282     function setTokenControlInfo(
283         ERC20 token,
284         uint minimalRecordResolution,
285         uint maxPerBlockImbalance,
286         uint maxTotalImbalance
287     )
288         public
289         onlyAdmin
290     {
291         tokenControlInfo[token] =
292             TokenControlInfo(
293                 minimalRecordResolution,
294                 maxPerBlockImbalance,
295                 maxTotalImbalance
296             );
297     }
298 
299     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
300         return (tokenControlInfo[token].minimalRecordResolution,
301                 tokenControlInfo[token].maxPerBlockImbalance,
302                 tokenControlInfo[token].maxTotalImbalance);
303     }
304 
305     function addImbalance(
306         ERC20 token,
307         int buyAmount,
308         uint rateUpdateBlock,
309         uint currentBlock
310     )
311         internal
312     {
313         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
314         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
315 
316         int prevImbalance = 0;
317 
318         TokenImbalanceData memory currentBlockData =
319             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
320 
321         // first scenario - this is not the first tx in the current block
322         if (currentBlockData.lastBlock == currentBlock) {
323             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
324                 // just increase imbalance
325                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
326                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
327             } else {
328                 // imbalance was changed in the middle of the block
329                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
330                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
331                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
332                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
333             }
334         } else {
335             // first tx in the current block
336             int currentBlockImbalance;
337             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
338 
339             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
340             currentBlockData.lastBlock = uint(currentBlock);
341             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
342             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
343         }
344 
345         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
346     }
347 
348     function setGarbageToVolumeRecorder(ERC20 token) internal {
349         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
350             tokenImbalanceData[token][i] = 0x1;
351         }
352     }
353 
354     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
355         // check the imbalance in the sliding window
356         require(startBlock <= endBlock);
357 
358         buyImbalance = 0;
359 
360         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
361             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
362 
363             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
364                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
365             }
366         }
367     }
368 
369     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
370         internal view
371         returns(int buyImbalance, int currentBlockImbalance)
372     {
373         buyImbalance = 0;
374         currentBlockImbalance = 0;
375         uint latestBlock = 0;
376         int imbalanceInRange = 0;
377         uint startBlock = rateUpdateBlock;
378         uint endBlock = currentBlock;
379 
380         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
381             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
382 
383             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
384                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
385             }
386 
387             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
388             if (perBlockData.lastBlock < latestBlock) continue;
389 
390             latestBlock = perBlockData.lastBlock;
391             buyImbalance = perBlockData.totalBuyUnitsImbalance;
392             if (uint(perBlockData.lastBlock) == currentBlock) {
393                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
394             }
395         }
396 
397         if (buyImbalance == 0) {
398             buyImbalance = imbalanceInRange;
399         }
400     }
401 
402     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
403         internal view
404         returns(int totalImbalance, int currentBlockImbalance)
405     {
406 
407         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
408 
409         (totalImbalance, currentBlockImbalance) =
410             getImbalanceSinceRateUpdate(
411                 token,
412                 rateUpdateBlock,
413                 currentBlock);
414 
415         totalImbalance *= resolution;
416         currentBlockImbalance *= resolution;
417     }
418 
419     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
420         return tokenControlInfo[token].maxPerBlockImbalance;
421     }
422 
423     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
424         return tokenControlInfo[token].maxTotalImbalance;
425     }
426 
427     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
428         // check for overflows
429         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
430         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
431         require(data.lastBlock < POW_2_64);
432         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
433         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
434         require(data.lastRateUpdateBlock < POW_2_64);
435 
436         // do encoding
437         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
438         result |= data.lastBlock * POW_2_64;
439         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
440         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
441 
442         return result;
443     }
444 
445     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
446         TokenImbalanceData memory data;
447 
448         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
449         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
450         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
451         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
452 
453         return data;
454     }
455 }
456 
457 // File: ../../wrapConvRate/smart-contracts/contracts/ConversionRates.sol
458 
459 contract ConversionRates is ConversionRatesInterface, VolumeImbalanceRecorder, Utils {
460 
461     // bps - basic rate steps. one step is 1 / 10000 of the rate.
462     struct StepFunction {
463         int[] x; // quantity for each step. Quantity of each step includes previous steps.
464         int[] y; // rate change per quantity step  in bps.
465     }
466 
467     struct TokenData {
468         bool listed;  // was added to reserve
469         bool enabled; // whether trade is enabled
470 
471         // position in the compact data
472         uint compactDataArrayIndex;
473         uint compactDataFieldIndex;
474 
475         // rate data. base and changes according to quantity and reserve balance.
476         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
477         uint baseBuyRate;  // in PRECISION units. see KyberConstants
478         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
479         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
480         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
481         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
482         StepFunction sellRateImbalanceStepFunction;
483     }
484 
485     /*
486     this is the data for tokenRatesCompactData
487     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
488     so we represent it as bytes32 and do the byte tricks ourselves.
489     struct TokenRatesCompactData {
490         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
491         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
492 
493         uint32 blockNumber;
494     } */
495     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
496     ERC20[] internal listedTokens;
497     mapping(address=>TokenData) internal tokenData;
498     bytes32[] internal tokenRatesCompactData;
499     uint public numTokensInCurrentCompactData = 0;
500     address public reserveContract;
501     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
502     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
503     uint constant internal MAX_STEPS_IN_FUNCTION = 10;
504     int  constant internal MAX_BPS_ADJUSTMENT = 10 ** 11; // 1B %
505     int  constant internal MIN_BPS_ADJUSTMENT = -100 * 100; // cannot go down by more than 100%
506 
507     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
508         { } // solhint-disable-line no-empty-blocks
509 
510     function addToken(ERC20 token) public onlyAdmin {
511 
512         require(!tokenData[token].listed);
513         tokenData[token].listed = true;
514         listedTokens.push(token);
515 
516         if (numTokensInCurrentCompactData == 0) {
517             tokenRatesCompactData.length++; // add new structure
518         }
519 
520         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
521         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
522 
523         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
524 
525         setGarbageToVolumeRecorder(token);
526 
527         setDecimals(token);
528     }
529 
530     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
531 
532         require(buy.length == sell.length);
533         require(indices.length == buy.length);
534         require(blockNumber <= 0xFFFFFFFF);
535 
536         uint bytes14Offset = BYTES_14_OFFSET;
537 
538         for (uint i = 0; i < indices.length; i++) {
539             require(indices[i] < tokenRatesCompactData.length);
540             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
541             tokenRatesCompactData[indices[i]] = bytes32(data);
542         }
543     }
544 
545     function setBaseRate(
546         ERC20[] tokens,
547         uint[] baseBuy,
548         uint[] baseSell,
549         bytes14[] buy,
550         bytes14[] sell,
551         uint blockNumber,
552         uint[] indices
553     )
554         public
555         onlyOperator
556     {
557         require(tokens.length == baseBuy.length);
558         require(tokens.length == baseSell.length);
559         require(sell.length == buy.length);
560         require(sell.length == indices.length);
561 
562         for (uint ind = 0; ind < tokens.length; ind++) {
563             require(tokenData[tokens[ind]].listed);
564             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
565             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
566         }
567 
568         setCompactData(buy, sell, blockNumber, indices);
569     }
570 
571     function setQtyStepFunction(
572         ERC20 token,
573         int[] xBuy,
574         int[] yBuy,
575         int[] xSell,
576         int[] ySell
577     )
578         public
579         onlyOperator
580     {
581         require(xBuy.length == yBuy.length);
582         require(xSell.length == ySell.length);
583         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
584         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
585         require(tokenData[token].listed);
586 
587         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
588         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
589     }
590 
591     function setImbalanceStepFunction(
592         ERC20 token,
593         int[] xBuy,
594         int[] yBuy,
595         int[] xSell,
596         int[] ySell
597     )
598         public
599         onlyOperator
600     {
601         require(xBuy.length == yBuy.length);
602         require(xSell.length == ySell.length);
603         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
604         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
605         require(tokenData[token].listed);
606 
607         tokenData[token].buyRateImbalanceStepFunction = StepFunction(xBuy, yBuy);
608         tokenData[token].sellRateImbalanceStepFunction = StepFunction(xSell, ySell);
609     }
610 
611     function setValidRateDurationInBlocks(uint duration) public onlyAdmin {
612         validRateDurationInBlocks = duration;
613     }
614 
615     function enableTokenTrade(ERC20 token) public onlyAdmin {
616         require(tokenData[token].listed);
617         require(tokenControlInfo[token].minimalRecordResolution != 0);
618         tokenData[token].enabled = true;
619     }
620 
621     function disableTokenTrade(ERC20 token) public onlyAlerter {
622         require(tokenData[token].listed);
623         tokenData[token].enabled = false;
624     }
625 
626     function setReserveAddress(address reserve) public onlyAdmin {
627         reserveContract = reserve;
628     }
629 
630     function recordImbalance(
631         ERC20 token,
632         int buyAmount,
633         uint rateUpdateBlock,
634         uint currentBlock
635     )
636         public
637     {
638         require(msg.sender == reserveContract);
639 
640         if (rateUpdateBlock == 0) rateUpdateBlock = getRateUpdateBlock(token);
641 
642         return addImbalance(token, buyAmount, rateUpdateBlock, currentBlock);
643     }
644 
645     /* solhint-disable function-max-lines */
646     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint) {
647         // check if trade is enabled
648         if (!tokenData[token].enabled) return 0;
649         if (tokenControlInfo[token].minimalRecordResolution == 0) return 0; // token control info not set
650 
651         // get rate update block
652         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
653 
654         uint updateRateBlock = getLast4Bytes(compactData);
655         if (currentBlockNumber >= updateRateBlock + validRateDurationInBlocks) return 0; // rate is expired
656         // check imbalance
657         int totalImbalance;
658         int blockImbalance;
659         (totalImbalance, blockImbalance) = getImbalance(token, updateRateBlock, currentBlockNumber);
660 
661         // calculate actual rate
662         int imbalanceQty;
663         int extraBps;
664         int8 rateUpdate;
665         uint rate;
666 
667         if (buy) {
668             // start with base rate
669             rate = tokenData[token].baseBuyRate;
670 
671             // add rate update
672             rateUpdate = getRateByteFromCompactData(compactData, token, true);
673             extraBps = int(rateUpdate) * 10;
674             rate = addBps(rate, extraBps);
675 
676             // compute token qty
677             qty = getTokenQty(token, rate, qty);
678             imbalanceQty = int(qty);
679             totalImbalance += imbalanceQty;
680 
681             // add qty overhead
682             extraBps = executeStepFunction(tokenData[token].buyRateQtyStepFunction, int(qty));
683             rate = addBps(rate, extraBps);
684 
685             // add imbalance overhead
686             extraBps = executeStepFunction(tokenData[token].buyRateImbalanceStepFunction, totalImbalance);
687             rate = addBps(rate, extraBps);
688         } else {
689             // start with base rate
690             rate = tokenData[token].baseSellRate;
691 
692             // add rate update
693             rateUpdate = getRateByteFromCompactData(compactData, token, false);
694             extraBps = int(rateUpdate) * 10;
695             rate = addBps(rate, extraBps);
696 
697             // compute token qty
698             imbalanceQty = -1 * int(qty);
699             totalImbalance += imbalanceQty;
700 
701             // add qty overhead
702             extraBps = executeStepFunction(tokenData[token].sellRateQtyStepFunction, int(qty));
703             rate = addBps(rate, extraBps);
704 
705             // add imbalance overhead
706             extraBps = executeStepFunction(tokenData[token].sellRateImbalanceStepFunction, totalImbalance);
707             rate = addBps(rate, extraBps);
708         }
709 
710         if (abs(totalImbalance) >= getMaxTotalImbalance(token)) return 0;
711         if (abs(blockImbalance + imbalanceQty) >= getMaxPerBlockImbalance(token)) return 0;
712 
713         return rate;
714     }
715     /* solhint-enable function-max-lines */
716 
717     function getBasicRate(ERC20 token, bool buy) public view returns(uint) {
718         if (buy)
719             return tokenData[token].baseBuyRate;
720         else
721             return tokenData[token].baseSellRate;
722     }
723 
724     function getCompactData(ERC20 token) public view returns(uint, uint, byte, byte) {
725         require(tokenData[token].listed);
726 
727         uint arrayIndex = tokenData[token].compactDataArrayIndex;
728         uint fieldOffset = tokenData[token].compactDataFieldIndex;
729 
730         return (
731             arrayIndex,
732             fieldOffset,
733             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
734             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
735         );
736     }
737 
738     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
739         return (tokenData[token].listed, tokenData[token].enabled);
740     }
741 
742     /* solhint-disable code-complexity */
743     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
744         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
745         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
746         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
747         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
748 
749         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
750         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
751         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
752         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
753 
754         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
755         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
756         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
757         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
758 
759         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
760         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
761         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
762         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
763 
764         revert();
765     }
766     /* solhint-enable code-complexity */
767 
768     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
769         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
770         return getLast4Bytes(compactData);
771     }
772 
773     function getListedTokens() public view returns(ERC20[]) {
774         return listedTokens;
775     }
776 
777     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
778         uint dstDecimals = getDecimals(token);
779         uint srcDecimals = ETH_DECIMALS;
780 
781         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
782     }
783 
784     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
785         // cannot trust compiler with not turning bit operations into EXP opcode
786         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
787     }
788 
789     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
790         uint fieldOffset = tokenData[token].compactDataFieldIndex;
791         uint byteOffset;
792         if (buy)
793             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
794         else
795             byteOffset = 4 + fieldOffset;
796 
797         return int8(data[byteOffset]);
798     }
799 
800     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
801         uint len = f.y.length;
802         for (uint ind = 0; ind < len; ind++) {
803             if (x <= f.x[ind]) return f.y[ind];
804         }
805 
806         return f.y[len-1];
807     }
808 
809     function addBps(uint rate, int bps) internal pure returns(uint) {
810         require(rate <= MAX_RATE);
811         require(bps >= MIN_BPS_ADJUSTMENT);
812         require(bps <= MAX_BPS_ADJUSTMENT);
813 
814         uint maxBps = 100 * 100;
815         return (rate * uint(int(maxBps) + bps)) / maxBps;
816     }
817 
818     function abs(int x) internal pure returns(uint) {
819         if (x < 0)
820             return uint(-1 * x);
821         else
822             return uint(x);
823     }
824 }
825 
826 // File: ../../wrapConvRate/smart-contracts/contracts/wrapperContracts/WrapperBase.sol
827 
828 contract WrapperBase is Withdrawable {
829 
830     PermissionGroups public wrappedContract;
831 
832     struct DataTracker {
833         address [] approveSignatureArray;
834         uint lastSetNonce;
835     }
836 
837     DataTracker[] internal dataInstances;
838 
839     function WrapperBase(PermissionGroups _wrappedContract, address _admin, uint _numDataInstances) public {
840         require(_wrappedContract != address(0));
841         require(_admin != address(0));
842         wrappedContract = _wrappedContract;
843         admin = _admin;
844 
845         for (uint i = 0; i < _numDataInstances; i++){
846             addDataInstance();
847         }
848     }
849 
850     function claimWrappedContractAdmin() public onlyOperator {
851         wrappedContract.claimAdmin();
852     }
853 
854     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
855         wrappedContract.transferAdmin(newAdmin);
856     }
857 
858     function addDataInstance() internal {
859         address[] memory add = new address[](0);
860         dataInstances.push(DataTracker(add, 0));
861     }
862 
863     function setNewData(uint dataIndex) internal {
864         require(dataIndex < dataInstances.length);
865         dataInstances[dataIndex].lastSetNonce++;
866         dataInstances[dataIndex].approveSignatureArray.length = 0;
867     }
868 
869     function addSignature(uint dataIndex, uint signedNonce, address signer) internal returns(bool allSigned) {
870         require(dataIndex < dataInstances.length);
871         require(dataInstances[dataIndex].lastSetNonce == signedNonce);
872 
873         for(uint i = 0; i < dataInstances[dataIndex].approveSignatureArray.length; i++) {
874             if (signer == dataInstances[dataIndex].approveSignatureArray[i]) revert();
875         }
876         dataInstances[dataIndex].approveSignatureArray.push(signer);
877 
878         if (dataInstances[dataIndex].approveSignatureArray.length == operatorsGroup.length) {
879             allSigned = true;
880         } else {
881             allSigned = false;
882         }
883     }
884 
885     function getDataTrackingParameters(uint index) internal view returns (address[], uint) {
886         require(index < dataInstances.length);
887         return(dataInstances[index].approveSignatureArray, dataInstances[index].lastSetNonce);
888     }
889 }
890 
891 // File: ../../wrapConvRate/smart-contracts/contracts/wrapperContracts/WrapConversionRate.sol
892 
893 contract WrapConversionRate is WrapperBase {
894 
895     ConversionRates internal conversionRates;
896 
897     //add token parameters
898     struct AddTokenData {
899         ERC20     token;
900         uint      minimalResolution; // can be roughly 1 cent
901         uint      maxPerBlockImbalance; // in twei resolution
902         uint      maxTotalImbalance;
903     }
904 
905     AddTokenData internal addTokenData;
906 
907     //set token control info parameters.
908     struct TokenControlInfoData {
909         ERC20[] tokens;
910         uint[] perBlockImbalance; // in twei resolution
911         uint[] maxTotalImbalance;
912     }
913 
914     TokenControlInfoData internal tokenControlInfoData;
915 
916     //valid duration
917     struct ValidDurationData {
918         uint durationInBlocks;
919     }
920 
921     ValidDurationData internal validDurationData;
922 
923     //data indexes
924     uint constant internal ADD_TOKEN_DATA_INDEX = 0;
925     uint constant internal TOKEN_INFO_DATA_INDEX = 1;
926     uint constant internal VALID_DURATION_DATA_INDEX = 2;
927     uint constant internal NUM_DATA_INDEX = 3;
928 
929     //general functions
930     function WrapConversionRate(ConversionRates _conversionRates, address _admin) public
931         WrapperBase(PermissionGroups(address(_conversionRates)), _admin, NUM_DATA_INDEX)
932     {
933         require(_conversionRates != address(0));
934         conversionRates = _conversionRates;
935     }
936 
937     // add token functions
938     //////////////////////
939     function setAddTokenData(
940         ERC20 token,
941         uint minRecordResolution,
942         uint maxPerBlockImbalance,
943         uint maxTotalImbalance
944         ) public onlyOperator
945     {
946         require(token != address(0));
947         require(minRecordResolution != 0);
948         require(maxPerBlockImbalance != 0);
949         require(maxTotalImbalance != 0);
950 
951         //update data tracking
952         setNewData(ADD_TOKEN_DATA_INDEX);
953 
954         addTokenData.token = token;
955         addTokenData.minimalResolution = minRecordResolution; // can be roughly 1 cent
956         addTokenData.maxPerBlockImbalance = maxPerBlockImbalance; // in twei resolution
957         addTokenData.maxTotalImbalance = maxTotalImbalance;
958     }
959 
960     function approveAddTokenData(uint nonce) public onlyOperator {
961         if (addSignature(ADD_TOKEN_DATA_INDEX, nonce, msg.sender)) {
962             // can perform operation.
963             performAddToken();
964         }
965     }
966 
967     function getAddTokenData() public view
968         returns(uint nonce, ERC20 token, uint minRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance)
969     {
970         address[] memory signatures;
971         (signatures, nonce) = getDataTrackingParameters(ADD_TOKEN_DATA_INDEX);
972         token = addTokenData.token;
973         minRecordResolution = addTokenData.minimalResolution;
974         maxPerBlockImbalance = addTokenData.maxPerBlockImbalance; // in twei resolution
975         maxTotalImbalance = addTokenData.maxTotalImbalance;
976         return(nonce, token, minRecordResolution, maxPerBlockImbalance, maxTotalImbalance);
977     }
978 
979     function getAddTokenSignatures() public view returns (address[] memory signatures) {
980         uint nonce;
981         (signatures, nonce) = getDataTrackingParameters(ADD_TOKEN_DATA_INDEX);
982         return(signatures);
983     }
984 
985     //set token control info
986     ////////////////////////
987     function setTokenInfoData(ERC20[] tokens, uint[] maxPerBlockImbalanceValues, uint[] maxTotalImbalanceValues)
988         public
989         onlyOperator
990     {
991         require(maxPerBlockImbalanceValues.length == tokens.length);
992         require(maxTotalImbalanceValues.length == tokens.length);
993 
994         //update data tracking
995         setNewData(TOKEN_INFO_DATA_INDEX);
996 
997         tokenControlInfoData.tokens = tokens;
998         tokenControlInfoData.perBlockImbalance = maxPerBlockImbalanceValues;
999         tokenControlInfoData.maxTotalImbalance = maxTotalImbalanceValues;
1000     }
1001 
1002     function approveTokenControlInfo(uint nonce) public onlyOperator {
1003         if (addSignature(TOKEN_INFO_DATA_INDEX, nonce, msg.sender)) {
1004             // can perform operation.
1005             performSetTokenControlInfo();
1006         }
1007     }
1008 
1009     function getControlInfoPerToken (uint index) public view
1010         returns(ERC20 token, uint _maxPerBlockImbalance, uint _maxTotalImbalance, uint nonce)
1011     {
1012         require(tokenControlInfoData.tokens.length > index);
1013         require(tokenControlInfoData.perBlockImbalance.length > index);
1014         require(tokenControlInfoData.maxTotalImbalance.length > index);
1015         address[] memory signatures;
1016         (signatures, nonce) = getDataTrackingParameters(TOKEN_INFO_DATA_INDEX);
1017 
1018         return(
1019             tokenControlInfoData.tokens[index],
1020             tokenControlInfoData.perBlockImbalance[index],
1021             tokenControlInfoData.maxTotalImbalance[index],
1022             nonce
1023         );
1024     }
1025 
1026     function getTokenInfoNumToknes() public view returns(uint numSetTokens) {
1027         return tokenControlInfoData.tokens.length;
1028     }
1029 
1030     function getTokenInfoData() public view
1031         returns(uint nonce, uint numSetTokens, ERC20[] tokenAddress, uint[] maxPerBlock, uint[] maxTotal)
1032     {
1033         address[] memory signatures;
1034         (signatures, nonce) = getDataTrackingParameters(TOKEN_INFO_DATA_INDEX);
1035 
1036         return(
1037             nonce,
1038             tokenControlInfoData.tokens.length,
1039             tokenControlInfoData.tokens,
1040             tokenControlInfoData.perBlockImbalance,
1041             tokenControlInfoData.maxTotalImbalance);
1042     }
1043 
1044     function getTokenInfoSignatures() public view returns (address[] memory signatures) {
1045         uint nonce;
1046         (signatures, nonce) = getDataTrackingParameters(TOKEN_INFO_DATA_INDEX);
1047         return(signatures);
1048     }
1049 
1050     function getTokenInfoNonce() public view returns(uint nonce) {
1051         address[] memory signatures;
1052         (signatures, nonce) = getDataTrackingParameters(TOKEN_INFO_DATA_INDEX);
1053         return nonce;
1054     }
1055 
1056     //valid duration blocks
1057     ///////////////////////
1058     function setValidDurationData(uint validDurationBlocks) public onlyOperator {
1059         require(validDurationBlocks > 5);
1060 
1061         //update data tracking
1062         setNewData(VALID_DURATION_DATA_INDEX);
1063 
1064         validDurationData.durationInBlocks = validDurationBlocks;
1065     }
1066 
1067     function approveValidDurationData(uint nonce) public onlyOperator {
1068         if (addSignature(VALID_DURATION_DATA_INDEX, nonce, msg.sender)) {
1069             // can perform operation.
1070             conversionRates.setValidRateDurationInBlocks(validDurationData.durationInBlocks);
1071         }
1072     }
1073 
1074     function getValidDurationBlocksData() public view returns(uint validDuration, uint nonce) {
1075         address[] memory signatures;
1076         (signatures, nonce) = getDataTrackingParameters(VALID_DURATION_DATA_INDEX);
1077         return(nonce, validDurationData.durationInBlocks);
1078     }
1079 
1080     function getValidDurationSignatures() public view returns (address[] memory signatures) {
1081         uint nonce;
1082         (signatures, nonce) = getDataTrackingParameters(VALID_DURATION_DATA_INDEX);
1083         return(signatures);
1084     }
1085 
1086     function performAddToken() internal {
1087         conversionRates.addToken(addTokenData.token);
1088 
1089         conversionRates.addOperator(this);
1090 
1091         //token control info
1092         conversionRates.setTokenControlInfo(
1093             addTokenData.token,
1094             addTokenData.minimalResolution,
1095             addTokenData.maxPerBlockImbalance,
1096             addTokenData.maxTotalImbalance
1097         );
1098 
1099         //step functions
1100         int[] memory zeroArr = new int[](1);
1101         zeroArr[0] = 0;
1102 
1103         conversionRates.setQtyStepFunction(addTokenData.token, zeroArr, zeroArr, zeroArr, zeroArr);
1104         conversionRates.setImbalanceStepFunction(addTokenData.token, zeroArr, zeroArr, zeroArr, zeroArr);
1105 
1106         conversionRates.enableTokenTrade(addTokenData.token);
1107 
1108         conversionRates.removeOperator(this);
1109     }
1110 
1111     function performSetTokenControlInfo() internal {
1112         require(tokenControlInfoData.tokens.length == tokenControlInfoData.perBlockImbalance.length);
1113         require(tokenControlInfoData.tokens.length == tokenControlInfoData.maxTotalImbalance.length);
1114 
1115         uint minRecordResolution;
1116 
1117         for (uint i = 0; i < tokenControlInfoData.tokens.length; i++) {
1118             uint maxPerBlock;
1119             uint maxTotal;
1120             (minRecordResolution, maxPerBlock, maxTotal) =
1121                 conversionRates.getTokenControlInfo(tokenControlInfoData.tokens[i]);
1122             require(minRecordResolution != 0);
1123 
1124             conversionRates.setTokenControlInfo(tokenControlInfoData.tokens[i],
1125                 minRecordResolution,
1126                 tokenControlInfoData.perBlockImbalance[i],
1127                 tokenControlInfoData.maxTotalImbalance[i]);
1128         }
1129     }
1130 }