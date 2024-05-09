1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-15
3 */
4 
5 pragma solidity 0.4.18;
6 
7 interface ConversionRatesInterface {
8 
9     function recordImbalance(
10         ERC20 token,
11         int buyAmount,
12         uint rateUpdateBlock,
13         uint currentBlock
14     )
15         public;
16 
17     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
18 }
19 
20 interface ERC20 {
21     function totalSupply() public view returns (uint supply);
22     function balanceOf(address _owner) public view returns (uint balance);
23     function transfer(address _to, uint _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
25     function approve(address _spender, uint _value) public returns (bool success);
26     function allowance(address _owner, address _spender) public view returns (uint remaining);
27     function decimals() public view returns(uint digits);
28     event Approval(address indexed _owner, address indexed _spender, uint _value);
29 }
30 
31 contract PermissionGroups {
32 
33     address public admin;
34     address public pendingAdmin;
35     mapping(address=>bool) internal operators;
36     mapping(address=>bool) internal alerters;
37     address[] internal operatorsGroup;
38     address[] internal alertersGroup;
39     uint constant internal MAX_GROUP_SIZE = 50;
40 
41     function PermissionGroups() public {
42         admin = msg.sender;
43     }
44 
45     modifier onlyAdmin() {
46         require(msg.sender == admin);
47         _;
48     }
49 
50     modifier onlyOperator() {
51         require(operators[msg.sender]);
52         _;
53     }
54 
55     modifier onlyAlerter() {
56         require(alerters[msg.sender]);
57         _;
58     }
59 
60     function getOperators () external view returns(address[]) {
61         return operatorsGroup;
62     }
63 
64     function getAlerters () external view returns(address[]) {
65         return alertersGroup;
66     }
67 
68     event TransferAdminPending(address pendingAdmin);
69 
70     /**
71      * @dev Allows the current admin to set the pendingAdmin address.
72      * @param newAdmin The address to transfer ownership to.
73      */
74     function transferAdmin(address newAdmin) public onlyAdmin {
75         require(newAdmin != address(0));
76         TransferAdminPending(pendingAdmin);
77         pendingAdmin = newAdmin;
78     }
79 
80     /**
81      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
82      * @param newAdmin The address to transfer ownership to.
83      */
84     function transferAdminQuickly(address newAdmin) public onlyAdmin {
85         require(newAdmin != address(0));
86         TransferAdminPending(newAdmin);
87         AdminClaimed(newAdmin, admin);
88         admin = newAdmin;
89     }
90 
91     event AdminClaimed( address newAdmin, address previousAdmin);
92 
93     /**
94      * @dev Allows the pendingAdmin address to finalize the change admin process.
95      */
96     function claimAdmin() public {
97         require(pendingAdmin == msg.sender);
98         AdminClaimed(pendingAdmin, admin);
99         admin = pendingAdmin;
100         pendingAdmin = address(0);
101     }
102 
103     event AlerterAdded (address newAlerter, bool isAdd);
104 
105     function addAlerter(address newAlerter) public onlyAdmin {
106         require(!alerters[newAlerter]); // prevent duplicates.
107         require(alertersGroup.length < MAX_GROUP_SIZE);
108 
109         AlerterAdded(newAlerter, true);
110         alerters[newAlerter] = true;
111         alertersGroup.push(newAlerter);
112     }
113 
114     function removeAlerter (address alerter) public onlyAdmin {
115         require(alerters[alerter]);
116         alerters[alerter] = false;
117 
118         for (uint i = 0; i < alertersGroup.length; ++i) {
119             if (alertersGroup[i] == alerter) {
120                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
121                 alertersGroup.length--;
122                 AlerterAdded(alerter, false);
123                 break;
124             }
125         }
126     }
127 
128     event OperatorAdded(address newOperator, bool isAdd);
129 
130     function addOperator(address newOperator) public onlyAdmin {
131         require(!operators[newOperator]); // prevent duplicates.
132         require(operatorsGroup.length < MAX_GROUP_SIZE);
133 
134         OperatorAdded(newOperator, true);
135         operators[newOperator] = true;
136         operatorsGroup.push(newOperator);
137     }
138 
139     function removeOperator (address operator) public onlyAdmin {
140         require(operators[operator]);
141         operators[operator] = false;
142 
143         for (uint i = 0; i < operatorsGroup.length; ++i) {
144             if (operatorsGroup[i] == operator) {
145                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
146                 operatorsGroup.length -= 1;
147                 OperatorAdded(operator, false);
148                 break;
149             }
150         }
151     }
152 }
153 
154 contract Withdrawable is PermissionGroups {
155 
156     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
157 
158     /**
159      * @dev Withdraw all ERC20 compatible tokens
160      * @param token ERC20 The address of the token contract
161      */
162     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
163         require(token.transfer(sendTo, amount));
164         TokenWithdraw(token, amount, sendTo);
165     }
166 
167     event EtherWithdraw(uint amount, address sendTo);
168 
169     /**
170      * @dev Withdraw Ethers
171      */
172     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
173         sendTo.transfer(amount);
174         EtherWithdraw(amount, sendTo);
175     }
176 }
177 
178 contract VolumeImbalanceRecorder is Withdrawable {
179 
180     uint constant internal SLIDING_WINDOW_SIZE = 5;
181     uint constant internal POW_2_64 = 2 ** 64;
182 
183     struct TokenControlInfo {
184         uint minimalRecordResolution; // can be roughly 1 cent
185         uint maxPerBlockImbalance; // in twei resolution
186         uint maxTotalImbalance; // max total imbalance (between rate updates)
187                             // before halting trade
188     }
189 
190     mapping(address => TokenControlInfo) internal tokenControlInfo;
191 
192     struct TokenImbalanceData {
193         int  lastBlockBuyUnitsImbalance;
194         uint lastBlock;
195 
196         int  totalBuyUnitsImbalance;
197         uint lastRateUpdateBlock;
198     }
199 
200     mapping(address => mapping(uint=>uint)) public tokenImbalanceData;
201 
202     function VolumeImbalanceRecorder(address _admin) public {
203         require(_admin != address(0));
204         admin = _admin;
205     }
206 
207     function setTokenControlInfo(
208         ERC20 token,
209         uint minimalRecordResolution,
210         uint maxPerBlockImbalance,
211         uint maxTotalImbalance
212     )
213         public
214         onlyAdmin
215     {
216         tokenControlInfo[token] =
217             TokenControlInfo(
218                 minimalRecordResolution,
219                 maxPerBlockImbalance,
220                 maxTotalImbalance
221             );
222     }
223 
224     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint) {
225         return (tokenControlInfo[token].minimalRecordResolution,
226                 tokenControlInfo[token].maxPerBlockImbalance,
227                 tokenControlInfo[token].maxTotalImbalance);
228     }
229 
230     function addImbalance(
231         ERC20 token,
232         int buyAmount,
233         uint rateUpdateBlock,
234         uint currentBlock
235     )
236         internal
237     {
238         uint currentBlockIndex = currentBlock % SLIDING_WINDOW_SIZE;
239         int recordedBuyAmount = int(buyAmount / int(tokenControlInfo[token].minimalRecordResolution));
240 
241         int prevImbalance = 0;
242 
243         TokenImbalanceData memory currentBlockData =
244             decodeTokenImbalanceData(tokenImbalanceData[token][currentBlockIndex]);
245 
246         // first scenario - this is not the first tx in the current block
247         if (currentBlockData.lastBlock == currentBlock) {
248             if (uint(currentBlockData.lastRateUpdateBlock) == rateUpdateBlock) {
249                 // just increase imbalance
250                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
251                 currentBlockData.totalBuyUnitsImbalance += recordedBuyAmount;
252             } else {
253                 // imbalance was changed in the middle of the block
254                 prevImbalance = getImbalanceInRange(token, rateUpdateBlock, currentBlock);
255                 currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
256                 currentBlockData.lastBlockBuyUnitsImbalance += recordedBuyAmount;
257                 currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
258             }
259         } else {
260             // first tx in the current block
261             int currentBlockImbalance;
262             (prevImbalance, currentBlockImbalance) = getImbalanceSinceRateUpdate(token, rateUpdateBlock, currentBlock);
263 
264             currentBlockData.lastBlockBuyUnitsImbalance = recordedBuyAmount;
265             currentBlockData.lastBlock = uint(currentBlock);
266             currentBlockData.lastRateUpdateBlock = uint(rateUpdateBlock);
267             currentBlockData.totalBuyUnitsImbalance = int(prevImbalance) + recordedBuyAmount;
268         }
269 
270         tokenImbalanceData[token][currentBlockIndex] = encodeTokenImbalanceData(currentBlockData);
271     }
272 
273     function setGarbageToVolumeRecorder(ERC20 token) internal {
274         for (uint i = 0; i < SLIDING_WINDOW_SIZE; i++) {
275             tokenImbalanceData[token][i] = 0x1;
276         }
277     }
278 
279     function getImbalanceInRange(ERC20 token, uint startBlock, uint endBlock) internal view returns(int buyImbalance) {
280         // check the imbalance in the sliding window
281         require(startBlock <= endBlock);
282 
283         buyImbalance = 0;
284 
285         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
286             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
287 
288             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
289                 buyImbalance += int(perBlockData.lastBlockBuyUnitsImbalance);
290             }
291         }
292     }
293 
294     function getImbalanceSinceRateUpdate(ERC20 token, uint rateUpdateBlock, uint currentBlock)
295         internal view
296         returns(int buyImbalance, int currentBlockImbalance)
297     {
298         buyImbalance = 0;
299         currentBlockImbalance = 0;
300         uint latestBlock = 0;
301         int imbalanceInRange = 0;
302         uint startBlock = rateUpdateBlock;
303         uint endBlock = currentBlock;
304 
305         for (uint windowInd = 0; windowInd < SLIDING_WINDOW_SIZE; windowInd++) {
306             TokenImbalanceData memory perBlockData = decodeTokenImbalanceData(tokenImbalanceData[token][windowInd]);
307 
308             if (perBlockData.lastBlock <= endBlock && perBlockData.lastBlock >= startBlock) {
309                 imbalanceInRange += perBlockData.lastBlockBuyUnitsImbalance;
310             }
311 
312             if (perBlockData.lastRateUpdateBlock != rateUpdateBlock) continue;
313             if (perBlockData.lastBlock < latestBlock) continue;
314 
315             latestBlock = perBlockData.lastBlock;
316             buyImbalance = perBlockData.totalBuyUnitsImbalance;
317             if (uint(perBlockData.lastBlock) == currentBlock) {
318                 currentBlockImbalance = perBlockData.lastBlockBuyUnitsImbalance;
319             }
320         }
321 
322         if (buyImbalance == 0) {
323             buyImbalance = imbalanceInRange;
324         }
325     }
326 
327     function getImbalance(ERC20 token, uint rateUpdateBlock, uint currentBlock)
328         internal view
329         returns(int totalImbalance, int currentBlockImbalance)
330     {
331 
332         int resolution = int(tokenControlInfo[token].minimalRecordResolution);
333 
334         (totalImbalance, currentBlockImbalance) =
335             getImbalanceSinceRateUpdate(
336                 token,
337                 rateUpdateBlock,
338                 currentBlock);
339 
340         totalImbalance *= resolution;
341         currentBlockImbalance *= resolution;
342     }
343 
344     function getMaxPerBlockImbalance(ERC20 token) internal view returns(uint) {
345         return tokenControlInfo[token].maxPerBlockImbalance;
346     }
347 
348     function getMaxTotalImbalance(ERC20 token) internal view returns(uint) {
349         return tokenControlInfo[token].maxTotalImbalance;
350     }
351 
352     function encodeTokenImbalanceData(TokenImbalanceData data) internal pure returns(uint) {
353         // check for overflows
354         require(data.lastBlockBuyUnitsImbalance < int(POW_2_64 / 2));
355         require(data.lastBlockBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
356         require(data.lastBlock < POW_2_64);
357         require(data.totalBuyUnitsImbalance < int(POW_2_64 / 2));
358         require(data.totalBuyUnitsImbalance > int(-1 * int(POW_2_64) / 2));
359         require(data.lastRateUpdateBlock < POW_2_64);
360 
361         // do encoding
362         uint result = uint(data.lastBlockBuyUnitsImbalance) & (POW_2_64 - 1);
363         result |= data.lastBlock * POW_2_64;
364         result |= (uint(data.totalBuyUnitsImbalance) & (POW_2_64 - 1)) * POW_2_64 * POW_2_64;
365         result |= data.lastRateUpdateBlock * POW_2_64 * POW_2_64 * POW_2_64;
366 
367         return result;
368     }
369 
370     function decodeTokenImbalanceData(uint input) internal pure returns(TokenImbalanceData) {
371         TokenImbalanceData memory data;
372 
373         data.lastBlockBuyUnitsImbalance = int(int64(input & (POW_2_64 - 1)));
374         data.lastBlock = uint(uint64((input / POW_2_64) & (POW_2_64 - 1)));
375         data.totalBuyUnitsImbalance = int(int64((input / (POW_2_64 * POW_2_64)) & (POW_2_64 - 1)));
376         data.lastRateUpdateBlock = uint(uint64((input / (POW_2_64 * POW_2_64 * POW_2_64))));
377 
378         return data;
379     }
380 }
381 
382 contract Utils {
383 
384     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
385     uint  constant internal PRECISION = (10**18);
386     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
387     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
388     uint  constant internal MAX_DECIMALS = 18;
389     uint  constant internal ETH_DECIMALS = 18;
390     mapping(address=>uint) internal decimals;
391 
392     function setDecimals(ERC20 token) internal {
393         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
394         else decimals[token] = token.decimals();
395     }
396 
397     function getDecimals(ERC20 token) internal view returns(uint) {
398         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
399         uint tokenDecimals = decimals[token];
400         // technically, there might be token with decimals 0
401         // moreover, very possible that old tokens have decimals 0
402         // these tokens will just have higher gas fees.
403         if(tokenDecimals == 0) return token.decimals();
404 
405         return tokenDecimals;
406     }
407 
408     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
409         require(srcQty <= MAX_QTY);
410         require(rate <= MAX_RATE);
411 
412         if (dstDecimals >= srcDecimals) {
413             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
414             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
415         } else {
416             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
417             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
418         }
419     }
420 
421     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
422         require(dstQty <= MAX_QTY);
423         require(rate <= MAX_RATE);
424 
425         //source quantity is rounded up. to avoid dest quantity being too low.
426         uint numerator;
427         uint denominator;
428         if (srcDecimals >= dstDecimals) {
429             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
430             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
431             denominator = rate;
432         } else {
433             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
434             numerator = (PRECISION * dstQty);
435             denominator = (rate * (10**(dstDecimals - srcDecimals)));
436         }
437         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
438     }
439 }
440 
441 contract ConversionRates is ConversionRatesInterface, VolumeImbalanceRecorder, Utils {
442 
443     // bps - basic rate steps. one step is 1 / 10000 of the rate.
444     struct StepFunction {
445         int[] x; // quantity for each step. Quantity of each step includes previous steps.
446         int[] y; // rate change per quantity step  in bps.
447     }
448 
449     struct TokenData {
450         bool listed;  // was added to reserve
451         bool enabled; // whether trade is enabled
452 
453         // position in the compact data
454         uint compactDataArrayIndex;
455         uint compactDataFieldIndex;
456 
457         // rate data. base and changes according to quantity and reserve balance.
458         // generally speaking. Sell rate is 1 / buy rate i.e. the buy in the other direction.
459         uint baseBuyRate;  // in PRECISION units. see KyberConstants
460         uint baseSellRate; // PRECISION units. without (sell / buy) spread it is 1 / baseBuyRate
461         StepFunction buyRateQtyStepFunction; // in bps. higher quantity - bigger the rate.
462         StepFunction sellRateQtyStepFunction;// in bps. higher the qua
463         StepFunction buyRateImbalanceStepFunction; // in BPS. higher reserve imbalance - bigger the rate.
464         StepFunction sellRateImbalanceStepFunction;
465     }
466 
467     /*
468     this is the data for tokenRatesCompactData
469     but solidity compiler optimizer is sub-optimal, and cannot write this structure in a single storage write
470     so we represent it as bytes32 and do the byte tricks ourselves.
471     struct TokenRatesCompactData {
472         bytes14 buy;  // change buy rate of token from baseBuyRate in 10 bps
473         bytes14 sell; // change sell rate of token from baseSellRate in 10 bps
474 
475         uint32 blockNumber;
476     } */
477     uint public validRateDurationInBlocks = 10; // rates are valid for this amount of blocks
478     ERC20[] internal listedTokens;
479     mapping(address=>TokenData) internal tokenData;
480     bytes32[] internal tokenRatesCompactData;
481     uint public numTokensInCurrentCompactData = 0;
482     address public reserveContract;
483     uint constant internal NUM_TOKENS_IN_COMPACT_DATA = 14;
484     uint constant internal BYTES_14_OFFSET = (2 ** (8 * NUM_TOKENS_IN_COMPACT_DATA));
485     uint constant internal MAX_STEPS_IN_FUNCTION = 10;
486     int  constant internal MAX_BPS_ADJUSTMENT = 10 ** 11; // 1B %
487     int  constant internal MIN_BPS_ADJUSTMENT = -100 * 100; // cannot go down by more than 100%
488 
489     function ConversionRates(address _admin) public VolumeImbalanceRecorder(_admin)
490         { } // solhint-disable-line no-empty-blocks
491 
492     function addToken(ERC20 token) public onlyAdmin {
493 
494         require(!tokenData[token].listed);
495         tokenData[token].listed = true;
496         listedTokens.push(token);
497 
498         if (numTokensInCurrentCompactData == 0) {
499             tokenRatesCompactData.length++; // add new structure
500         }
501 
502         tokenData[token].compactDataArrayIndex = tokenRatesCompactData.length - 1;
503         tokenData[token].compactDataFieldIndex = numTokensInCurrentCompactData;
504 
505         numTokensInCurrentCompactData = (numTokensInCurrentCompactData + 1) % NUM_TOKENS_IN_COMPACT_DATA;
506 
507         setGarbageToVolumeRecorder(token);
508 
509         setDecimals(token);
510     }
511 
512     function setCompactData(bytes14[] buy, bytes14[] sell, uint blockNumber, uint[] indices) public onlyOperator {
513 
514         require(buy.length == sell.length);
515         require(indices.length == buy.length);
516         require(blockNumber <= 0xFFFFFFFF);
517 
518         uint bytes14Offset = BYTES_14_OFFSET;
519 
520         for (uint i = 0; i < indices.length; i++) {
521             require(indices[i] < tokenRatesCompactData.length);
522             uint data = uint(buy[i]) | uint(sell[i]) * bytes14Offset | (blockNumber * (bytes14Offset * bytes14Offset));
523             tokenRatesCompactData[indices[i]] = bytes32(data);
524         }
525     }
526 
527     function setBaseRate(
528         ERC20[] tokens,
529         uint[] baseBuy,
530         uint[] baseSell,
531         bytes14[] buy,
532         bytes14[] sell,
533         uint blockNumber,
534         uint[] indices
535     )
536         public
537         onlyOperator
538     {
539         require(tokens.length == baseBuy.length);
540         require(tokens.length == baseSell.length);
541         require(sell.length == buy.length);
542         require(sell.length == indices.length);
543 
544         for (uint ind = 0; ind < tokens.length; ind++) {
545             require(tokenData[tokens[ind]].listed);
546             tokenData[tokens[ind]].baseBuyRate = baseBuy[ind];
547             tokenData[tokens[ind]].baseSellRate = baseSell[ind];
548         }
549 
550         setCompactData(buy, sell, blockNumber, indices);
551     }
552 
553     function setQtyStepFunction(
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
565         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
566         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
567         require(tokenData[token].listed);
568 
569         tokenData[token].buyRateQtyStepFunction = StepFunction(xBuy, yBuy);
570         tokenData[token].sellRateQtyStepFunction = StepFunction(xSell, ySell);
571     }
572 
573     function setImbalanceStepFunction(
574         ERC20 token,
575         int[] xBuy,
576         int[] yBuy,
577         int[] xSell,
578         int[] ySell
579     )
580         public
581         onlyOperator
582     {
583         require(xBuy.length == yBuy.length);
584         require(xSell.length == ySell.length);
585         require(xBuy.length <= MAX_STEPS_IN_FUNCTION);
586         require(xSell.length <= MAX_STEPS_IN_FUNCTION);
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
692         if (abs(totalImbalance) >= getMaxTotalImbalance(token)) return 0;
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
707         require(tokenData[token].listed);
708 
709         uint arrayIndex = tokenData[token].compactDataArrayIndex;
710         uint fieldOffset = tokenData[token].compactDataFieldIndex;
711 
712         return (
713             arrayIndex,
714             fieldOffset,
715             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, true)),
716             byte(getRateByteFromCompactData(tokenRatesCompactData[arrayIndex], token, false))
717         );
718     }
719 
720     function getTokenBasicData(ERC20 token) public view returns(bool, bool) {
721         return (tokenData[token].listed, tokenData[token].enabled);
722     }
723 
724     /* solhint-disable code-complexity */
725     function getStepFunctionData(ERC20 token, uint command, uint param) public view returns(int) {
726         if (command == 0) return int(tokenData[token].buyRateQtyStepFunction.x.length);
727         if (command == 1) return tokenData[token].buyRateQtyStepFunction.x[param];
728         if (command == 2) return int(tokenData[token].buyRateQtyStepFunction.y.length);
729         if (command == 3) return tokenData[token].buyRateQtyStepFunction.y[param];
730 
731         if (command == 4) return int(tokenData[token].sellRateQtyStepFunction.x.length);
732         if (command == 5) return tokenData[token].sellRateQtyStepFunction.x[param];
733         if (command == 6) return int(tokenData[token].sellRateQtyStepFunction.y.length);
734         if (command == 7) return tokenData[token].sellRateQtyStepFunction.y[param];
735 
736         if (command == 8) return int(tokenData[token].buyRateImbalanceStepFunction.x.length);
737         if (command == 9) return tokenData[token].buyRateImbalanceStepFunction.x[param];
738         if (command == 10) return int(tokenData[token].buyRateImbalanceStepFunction.y.length);
739         if (command == 11) return tokenData[token].buyRateImbalanceStepFunction.y[param];
740 
741         if (command == 12) return int(tokenData[token].sellRateImbalanceStepFunction.x.length);
742         if (command == 13) return tokenData[token].sellRateImbalanceStepFunction.x[param];
743         if (command == 14) return int(tokenData[token].sellRateImbalanceStepFunction.y.length);
744         if (command == 15) return tokenData[token].sellRateImbalanceStepFunction.y[param];
745 
746         revert();
747     }
748     /* solhint-enable code-complexity */
749 
750     function getRateUpdateBlock(ERC20 token) public view returns(uint) {
751         bytes32 compactData = tokenRatesCompactData[tokenData[token].compactDataArrayIndex];
752         return getLast4Bytes(compactData);
753     }
754 
755     function getListedTokens() public view returns(ERC20[]) {
756         return listedTokens;
757     }
758 
759     function getTokenQty(ERC20 token, uint ethQty, uint rate) internal view returns(uint) {
760         uint dstDecimals = getDecimals(token);
761         uint srcDecimals = ETH_DECIMALS;
762 
763         return calcDstQty(ethQty, srcDecimals, dstDecimals, rate);
764     }
765 
766     function getLast4Bytes(bytes32 b) internal pure returns(uint) {
767         // cannot trust compiler with not turning bit operations into EXP opcode
768         return uint(b) / (BYTES_14_OFFSET * BYTES_14_OFFSET);
769     }
770 
771     function getRateByteFromCompactData(bytes32 data, ERC20 token, bool buy) internal view returns(int8) {
772         uint fieldOffset = tokenData[token].compactDataFieldIndex;
773         uint byteOffset;
774         if (buy)
775             byteOffset = 32 - NUM_TOKENS_IN_COMPACT_DATA + fieldOffset;
776         else
777             byteOffset = 4 + fieldOffset;
778 
779         return int8(data[byteOffset]);
780     }
781 
782     function executeStepFunction(StepFunction f, int x) internal pure returns(int) {
783         uint len = f.y.length;
784         for (uint ind = 0; ind < len; ind++) {
785             if (x <= f.x[ind]) return f.y[ind];
786         }
787 
788         return f.y[len-1];
789     }
790 
791     function addBps(uint rate, int bps) internal pure returns(uint) {
792         require(rate <= MAX_RATE);
793         require(bps >= MIN_BPS_ADJUSTMENT);
794         require(bps <= MAX_BPS_ADJUSTMENT);
795 
796         uint maxBps = 100 * 100;
797         return (rate * uint(int(maxBps) + bps)) / maxBps;
798     }
799 
800     function abs(int x) internal pure returns(uint) {
801         if (x < 0)
802             return uint(-1 * x);
803         else
804             return uint(x);
805     }
806 }