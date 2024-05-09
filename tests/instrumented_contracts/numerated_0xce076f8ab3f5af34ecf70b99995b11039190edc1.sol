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
30 }
31 
32 // File: contracts/KyberReserveInterface.sol
33 
34 /// @title Kyber Reserve contract
35 interface KyberReserveInterface {
36 
37     function trade(
38         ERC20 srcToken,
39         uint srcAmount,
40         ERC20 destToken,
41         address destAddress,
42         uint conversionRate,
43         bool validate
44     )
45         public
46         payable
47         returns(bool);
48 
49     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
50 }
51 
52 // File: contracts/SanityRatesInterface.sol
53 
54 interface SanityRatesInterface {
55     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
56 }
57 
58 // File: contracts/Utils.sol
59 
60 /// @title Kyber constants contract
61 contract Utils {
62 
63     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
64     uint  constant internal PRECISION = (10**18);
65     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
66     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
67     uint  constant internal MAX_DECIMALS = 18;
68     uint  constant internal ETH_DECIMALS = 18;
69     mapping(address=>uint) internal decimals;
70 
71     function setDecimals(ERC20 token) internal {
72         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
73         else decimals[token] = token.decimals();
74     }
75 
76     function getDecimals(ERC20 token) internal view returns(uint) {
77         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
78         uint tokenDecimals = decimals[token];
79         // technically, there might be token with decimals 0
80         // moreover, very possible that old tokens have decimals 0
81         // these tokens will just have higher gas fees.
82         if(tokenDecimals == 0) return token.decimals();
83 
84         return tokenDecimals;
85     }
86 
87     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
88         require(srcQty <= MAX_QTY);
89         require(rate <= MAX_RATE);
90 
91         if (dstDecimals >= srcDecimals) {
92             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
93             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
94         } else {
95             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
96             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
97         }
98     }
99 
100     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
101         require(dstQty <= MAX_QTY);
102         require(rate <= MAX_RATE);
103         
104         //source quantity is rounded up. to avoid dest quantity being too low.
105         uint numerator;
106         uint denominator;
107         if (srcDecimals >= dstDecimals) {
108             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
109             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
110             denominator = rate;
111         } else {
112             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
113             numerator = (PRECISION * dstQty);
114             denominator = (rate * (10**(dstDecimals - srcDecimals)));
115         }
116         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
117     }
118 }
119 
120 // File: contracts/PermissionGroups.sol
121 
122 contract PermissionGroups {
123 
124     address public admin;
125     address public pendingAdmin;
126     mapping(address=>bool) internal operators;
127     mapping(address=>bool) internal alerters;
128     address[] internal operatorsGroup;
129     address[] internal alertersGroup;
130     uint constant internal MAX_GROUP_SIZE = 50;
131 
132     function PermissionGroups() public {
133         admin = msg.sender;
134     }
135 
136     modifier onlyAdmin() {
137         require(msg.sender == admin);
138         _;
139     }
140 
141     modifier onlyOperator() {
142         require(operators[msg.sender]);
143         _;
144     }
145 
146     modifier onlyAlerter() {
147         require(alerters[msg.sender]);
148         _;
149     }
150 
151     function getOperators () external view returns(address[]) {
152         return operatorsGroup;
153     }
154 
155     function getAlerters () external view returns(address[]) {
156         return alertersGroup;
157     }
158 
159     event TransferAdminPending(address pendingAdmin);
160 
161     /**
162      * @dev Allows the current admin to set the pendingAdmin address.
163      * @param newAdmin The address to transfer ownership to.
164      */
165     function transferAdmin(address newAdmin) public onlyAdmin {
166         require(newAdmin != address(0));
167         TransferAdminPending(pendingAdmin);
168         pendingAdmin = newAdmin;
169     }
170 
171     /**
172      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
173      * @param newAdmin The address to transfer ownership to.
174      */
175     function transferAdminQuickly(address newAdmin) public onlyAdmin {
176         require(newAdmin != address(0));
177         TransferAdminPending(newAdmin);
178         AdminClaimed(newAdmin, admin);
179         admin = newAdmin;
180     }
181 
182     event AdminClaimed( address newAdmin, address previousAdmin);
183 
184     /**
185      * @dev Allows the pendingAdmin address to finalize the change admin process.
186      */
187     function claimAdmin() public {
188         require(pendingAdmin == msg.sender);
189         AdminClaimed(pendingAdmin, admin);
190         admin = pendingAdmin;
191         pendingAdmin = address(0);
192     }
193 
194     event AlerterAdded (address newAlerter, bool isAdd);
195 
196     function addAlerter(address newAlerter) public onlyAdmin {
197         require(!alerters[newAlerter]); // prevent duplicates.
198         require(alertersGroup.length < MAX_GROUP_SIZE);
199 
200         AlerterAdded(newAlerter, true);
201         alerters[newAlerter] = true;
202         alertersGroup.push(newAlerter);
203     }
204 
205     function removeAlerter (address alerter) public onlyAdmin {
206         require(alerters[alerter]);
207         alerters[alerter] = false;
208 
209         for (uint i = 0; i < alertersGroup.length; ++i) {
210             if (alertersGroup[i] == alerter) {
211                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
212                 alertersGroup.length--;
213                 AlerterAdded(alerter, false);
214                 break;
215             }
216         }
217     }
218 
219     event OperatorAdded(address newOperator, bool isAdd);
220 
221     function addOperator(address newOperator) public onlyAdmin {
222         require(!operators[newOperator]); // prevent duplicates.
223         require(operatorsGroup.length < MAX_GROUP_SIZE);
224 
225         OperatorAdded(newOperator, true);
226         operators[newOperator] = true;
227         operatorsGroup.push(newOperator);
228     }
229 
230     function removeOperator (address operator) public onlyAdmin {
231         require(operators[operator]);
232         operators[operator] = false;
233 
234         for (uint i = 0; i < operatorsGroup.length; ++i) {
235             if (operatorsGroup[i] == operator) {
236                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
237                 operatorsGroup.length -= 1;
238                 OperatorAdded(operator, false);
239                 break;
240             }
241         }
242     }
243 }
244 
245 // File: contracts/Withdrawable.sol
246 
247 /**
248  * @title Contracts that should be able to recover tokens or ethers
249  * @author Ilan Doron
250  * @dev This allows to recover any tokens or Ethers received in a contract.
251  * This will prevent any accidental loss of tokens.
252  */
253 contract Withdrawable is PermissionGroups {
254 
255     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
256 
257     /**
258      * @dev Withdraw all ERC20 compatible tokens
259      * @param token ERC20 The address of the token contract
260      */
261     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
262         require(token.transfer(sendTo, amount));
263         TokenWithdraw(token, amount, sendTo);
264     }
265 
266     event EtherWithdraw(uint amount, address sendTo);
267 
268     /**
269      * @dev Withdraw Ethers
270      */
271     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
272         sendTo.transfer(amount);
273         EtherWithdraw(amount, sendTo);
274     }
275 }
276 
277 // File: contracts/DigixReserve.sol
278 
279 interface MakerDao {
280     function peek() public view returns (bytes32, bool);
281 }
282 
283 
284 contract DigixReserve is KyberReserveInterface, Withdrawable, Utils {
285 
286     ERC20 public digix;
287     MakerDao public makerDaoContract;
288     ConversionRatesInterface public conversionRatesContract;
289     SanityRatesInterface public sanityRatesContract;
290     address public kyberNetwork;
291     uint public maxBlockDrift = 300; //Max drift from block that price feed was received till we can't use it.
292     bool public tradeEnabled;
293     uint public buyTransferFee = 13; //Digix token has transaction fees we should compensate for our flow to work
294     uint public sellTransferFee = 13;
295     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
296     uint public priceFeed;  //all price feed data squinted to one uint256
297     uint constant internal POW_2_64 = 2 ** 64;
298 
299     function DigixReserve(address _admin, address _kyberNetwork, ERC20 _digix) public {
300         require(_admin != address(0));
301         require(_digix != address(0));
302         require(_kyberNetwork != address(0));
303         admin = _admin;
304         digix = _digix;
305         setDecimals(digix);
306         kyberNetwork = _kyberNetwork;
307         sanityRatesContract = SanityRatesInterface(0);
308         conversionRatesContract = ConversionRatesInterface(0x901d);
309         tradeEnabled = true;
310     }
311 
312     function () public payable {} // solhint-disable-line no-empty-blocks
313 
314     /// @dev Add digix price feed. Valid for @maxBlockDrift blocks
315     /// @param blockNumber the block this price feed was signed.
316     /// @param nonce the nonce with which this block was signed.
317     /// @param ask1KDigix ask price dollars per Kg gold == 1000 digix
318     /// @param bid1KDigix bid price dollars per KG gold == 1000 digix
319     /// @param v - v part of signature of keccak 256 hash of (block, nonce, ask, bid)
320     /// @param r - r part of signature of keccak 256 hash of (block, nonce, ask, bid)
321     /// @param s - s part of signature of keccak 256 hash of (block, nonce, ask, bid)
322     function setPriceFeed(
323         uint blockNumber,
324         uint nonce,
325         uint ask1KDigix,
326         uint bid1KDigix,
327         uint8 v,
328         bytes32 r,
329         bytes32 s
330         ) public
331     {
332         uint prevFeedBlock;
333         uint prevNonce;
334         uint prevAsk;
335         uint prevBid;
336 
337         (prevFeedBlock, prevNonce, prevAsk, prevBid) = getPriceFeed();
338         require(nonce > prevNonce);
339         require(blockNumber + maxBlockDrift > block.number);
340         require(blockNumber <= block.number);
341 
342         require(verifySignature(keccak256(blockNumber, nonce, ask1KDigix, bid1KDigix), v, r, s));
343 
344         priceFeed = encodePriceFeed(blockNumber, nonce, ask1KDigix, bid1KDigix);
345     }
346 
347     /* solhint-disable code-complexity */
348     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
349         if (!tradeEnabled) return 0;
350         if (makerDaoContract == MakerDao(0)) return 0;
351         uint feedBlock;
352         uint nonce;
353         uint ask1KDigix;
354         uint bid1KDigix;
355         blockNumber;
356 
357         (feedBlock, nonce, ask1KDigix, bid1KDigix) = getPriceFeed();
358         if (feedBlock + maxBlockDrift <= block.number) return 0;
359 
360         // wei per dollar from makerDao
361         bool isRateValid;
362         bytes32 dollarsPerEtherWei; //price in dollars of 1 Ether * 10**18
363         (dollarsPerEtherWei, isRateValid) = makerDaoContract.peek();
364         if (!isRateValid || uint(dollarsPerEtherWei) > MAX_RATE) return 0;
365 
366         uint rate;
367         if (ETH_TOKEN_ADDRESS == src && digix == dest) {
368             //buy digix with ether == sell ether
369             if (ask1KDigix == 0) return 0;
370             //rate = (ether $ price / digix $ price) * precision
371             //rate = ((dollarsPerEtherWei / etherwei == 10**18) / (bid1KDigix / 1000)) * PRECISION
372             rate = 1000 * uint(dollarsPerEtherWei) / ask1KDigix;
373         } else if (digix == src && ETH_TOKEN_ADDRESS == dest) {
374             //sell digix == buy ether with digix
375             //rate = (digix $ price / ether $ price) * precision
376             //rate = ((bid1KDigix / 1000) / (dollarsPerEtherWei / etherwei == 10**18)) * PRECISION
377             rate = bid1KDigix * PRECISION * PRECISION / uint(dollarsPerEtherWei) / 1000;
378         } else {
379             return 0;
380         }
381 
382         if (rate > MAX_RATE) return 0;
383 
384         uint destQty = getDestQty(src, dest, srcQty, rate);
385         if (dest == digix) destQty = recalcAmountWithFees(destQty, true);
386 
387         if (getBalance(dest) < destQty) return 0;
388 
389         return rate;
390     }
391     /* solhint-enable code-complexity */
392 
393     function getPriceFeed() public view returns(uint feedBlock, uint nonce, uint ask1KDigix, uint bid1KDigix) {
394         (feedBlock, nonce, ask1KDigix, bid1KDigix) = decodePriceFeed(priceFeed);
395     }
396 
397     event TradeExecute(
398         address indexed origin,
399         address src,
400         uint srcAmount,
401         address destToken,
402         uint destAmount,
403         address destAddress
404     );
405 
406     function trade(
407         ERC20 srcToken,
408         uint srcAmount,
409         ERC20 destToken,
410         address destAddress,
411         uint conversionRate,
412         bool validate
413     )
414         public
415         payable
416         returns(bool)
417     {
418         require(tradeEnabled);
419         require(msg.sender == kyberNetwork);
420 
421         // can skip validation if done at kyber network level
422         if (validate) {
423             require(conversionRate > 0);
424             if (srcToken == ETH_TOKEN_ADDRESS) {
425                 require(msg.value == srcAmount);
426                 require(ERC20(destToken) == digix);
427             } else {
428                 require(ERC20(srcToken) == digix);
429                 require(msg.value == 0);
430             }
431         }
432 
433         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
434         // sanity check
435         require(destAmount > 0);
436 
437         uint adjustedAmount;
438 
439         // collect src tokens
440         if (srcToken != ETH_TOKEN_ADDRESS) {
441             //due to fee network has less tokens. take amount less the fee.
442             adjustedAmount = recalcAmountWithFees(srcAmount, false);
443             require(adjustedAmount > 0);
444             require(srcToken.transferFrom(msg.sender, this, adjustedAmount));
445         }
446 
447         // send dest tokens
448         if (destToken == ETH_TOKEN_ADDRESS) {
449             destAddress.transfer(destAmount);
450         } else {
451             //add 1 to compensate for rounding errors.
452             adjustedAmount = recalcAmountWithFees(destAmount, true);
453             require(destToken.transfer(destAddress, adjustedAmount));
454         }
455 
456         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
457 
458         return true;
459     }
460 
461     event TradeEnabled(bool enable);
462 
463     function enableTrade() public onlyAdmin returns(bool) {
464         tradeEnabled = true;
465         TradeEnabled(true);
466 
467         return true;
468     }
469 
470     function disableTrade() public onlyAlerter returns(bool) {
471         tradeEnabled = false;
472         TradeEnabled(false);
473 
474         return true;
475     }
476 
477     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
478 
479     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
480         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
481         WithdrawAddressApproved(token, addr, approve);
482 
483         setDecimals(token);
484     }
485 
486     event WithdrawFunds(ERC20 token, uint amount, address destination);
487 
488     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
489         require(approvedWithdrawAddresses[keccak256(token, destination)]);
490 
491         if (token == ETH_TOKEN_ADDRESS) {
492             destination.transfer(amount);
493         } else {
494             require(token.transfer(destination, amount));
495         }
496 
497         WithdrawFunds(token, amount, destination);
498 
499         return true;
500     }
501 
502     function setMakerDaoContract(MakerDao daoContract) public onlyAdmin {
503         require(daoContract != address(0));
504         makerDaoContract = daoContract;
505     }
506 
507     function setKyberNetworkAddress(address _kyberNetwork) public onlyAdmin {
508         require(_kyberNetwork != address(0));
509         kyberNetwork = _kyberNetwork;
510     }
511 
512     function setMaxBlockDrift(uint numBlocks) public onlyAdmin {
513         require(numBlocks > 1);
514         maxBlockDrift = numBlocks;
515     }
516 
517     function setBuyFeeBps(uint fee) public onlyAdmin {
518         require(fee < 10000);
519         buyTransferFee = fee;
520     }
521 
522     function setSellFeeBps(uint fee) public onlyAdmin {
523         require(fee < 10000);
524         sellTransferFee = fee;
525     }
526 
527     function getBalance(ERC20 token) public view returns(uint) {
528         if (token == ETH_TOKEN_ADDRESS)
529             return this.balance;
530         else
531             return token.balanceOf(this);
532     }
533 
534     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
535         uint dstDecimals = getDecimals(dest);
536         uint srcDecimals = getDecimals(src);
537         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
538     }
539 
540     function decodePriceFeed(uint input) internal pure returns(uint blockNumber, uint nonce, uint ask, uint bid) {
541         blockNumber = uint(uint64(input));
542         nonce = uint(uint64(input / POW_2_64));
543         ask = uint(uint64(input / (POW_2_64 * POW_2_64)));
544         bid = uint(uint64(input / (POW_2_64 * POW_2_64 * POW_2_64)));
545     }
546 
547     function encodePriceFeed(uint blockNumber, uint nonce, uint ask, uint bid) internal pure returns(uint) {
548         // check overflows
549         require(blockNumber < POW_2_64);
550         require(nonce < POW_2_64);
551         require(ask < POW_2_64);
552         require(bid < POW_2_64);
553 
554         // do encoding
555         uint result = blockNumber;
556         result |= nonce * POW_2_64;
557         result |= ask * POW_2_64 * POW_2_64;
558         result |= bid * POW_2_64 * POW_2_64 * POW_2_64;
559 
560         return result;
561     }
562 
563     function verifySignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal view returns(bool) {
564         address signer = ecrecover(hash, v, r, s);
565         return operators[signer];
566     }
567 
568     function recalcAmountWithFees(uint amount, bool isEtherToDigix) internal view returns(uint adjustedAmount) {
569         if (isEtherToDigix) {
570             //when sending Digix to kyberNetwork fee will be reduced and received amount will be less then expected.
571             adjustedAmount = (amount * 10000 / (10000 - buyTransferFee)) + 1;
572         } else {
573             adjustedAmount = (amount * (10000 - sellTransferFee) / 10000);
574             if (adjustedAmount == 0) return 0;
575             // reduce 1 to avoid rounding errors on above calculation.
576             adjustedAmount -= 1;
577         }
578     }
579 }