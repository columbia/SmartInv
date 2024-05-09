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
17 // File: contracts/KyberReserveInterface.sol
18 
19 /// @title Kyber Reserve contract
20 interface KyberReserveInterface {
21 
22     function trade(
23         ERC20 srcToken,
24         uint srcAmount,
25         ERC20 destToken,
26         address destAddress,
27         uint conversionRate,
28         bool validate
29     )
30         public
31         payable
32         returns(bool);
33 
34     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
35 }
36 
37 // File: contracts/Utils.sol
38 
39 /// @title Kyber constants contract
40 contract Utils {
41 
42     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
43     uint  constant internal PRECISION = (10**18);
44     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
45     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
46     uint  constant internal MAX_DECIMALS = 18;
47     uint  constant internal ETH_DECIMALS = 18;
48     mapping(address=>uint) internal decimals;
49 
50     function setDecimals(ERC20 token) internal {
51         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
52         else decimals[token] = token.decimals();
53     }
54 
55     function getDecimals(ERC20 token) internal view returns(uint) {
56         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
57         uint tokenDecimals = decimals[token];
58         // technically, there might be token with decimals 0
59         // moreover, very possible that old tokens have decimals 0
60         // these tokens will just have higher gas fees.
61         if(tokenDecimals == 0) return token.decimals();
62 
63         return tokenDecimals;
64     }
65 
66     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
67         require(srcQty <= MAX_QTY);
68         require(rate <= MAX_RATE);
69 
70         if (dstDecimals >= srcDecimals) {
71             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
72             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
73         } else {
74             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
75             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
76         }
77     }
78 
79     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
80         require(dstQty <= MAX_QTY);
81         require(rate <= MAX_RATE);
82         
83         //source quantity is rounded up. to avoid dest quantity being too low.
84         uint numerator;
85         uint denominator;
86         if (srcDecimals >= dstDecimals) {
87             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
88             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
89             denominator = rate;
90         } else {
91             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
92             numerator = (PRECISION * dstQty);
93             denominator = (rate * (10**(dstDecimals - srcDecimals)));
94         }
95         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
96     }
97 }
98 
99 // File: contracts/PermissionGroups.sol
100 
101 contract PermissionGroups {
102 
103     address public admin;
104     address public pendingAdmin;
105     mapping(address=>bool) internal operators;
106     mapping(address=>bool) internal alerters;
107     address[] internal operatorsGroup;
108     address[] internal alertersGroup;
109     uint constant internal MAX_GROUP_SIZE = 50;
110 
111     function PermissionGroups() public {
112         admin = msg.sender;
113     }
114 
115     modifier onlyAdmin() {
116         require(msg.sender == admin);
117         _;
118     }
119 
120     modifier onlyOperator() {
121         require(operators[msg.sender]);
122         _;
123     }
124 
125     modifier onlyAlerter() {
126         require(alerters[msg.sender]);
127         _;
128     }
129 
130     function getOperators () external view returns(address[]) {
131         return operatorsGroup;
132     }
133 
134     function getAlerters () external view returns(address[]) {
135         return alertersGroup;
136     }
137 
138     event TransferAdminPending(address pendingAdmin);
139 
140     /**
141      * @dev Allows the current admin to set the pendingAdmin address.
142      * @param newAdmin The address to transfer ownership to.
143      */
144     function transferAdmin(address newAdmin) public onlyAdmin {
145         require(newAdmin != address(0));
146         TransferAdminPending(pendingAdmin);
147         pendingAdmin = newAdmin;
148     }
149 
150     /**
151      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
152      * @param newAdmin The address to transfer ownership to.
153      */
154     function transferAdminQuickly(address newAdmin) public onlyAdmin {
155         require(newAdmin != address(0));
156         TransferAdminPending(newAdmin);
157         AdminClaimed(newAdmin, admin);
158         admin = newAdmin;
159     }
160 
161     event AdminClaimed( address newAdmin, address previousAdmin);
162 
163     /**
164      * @dev Allows the pendingAdmin address to finalize the change admin process.
165      */
166     function claimAdmin() public {
167         require(pendingAdmin == msg.sender);
168         AdminClaimed(pendingAdmin, admin);
169         admin = pendingAdmin;
170         pendingAdmin = address(0);
171     }
172 
173     event AlerterAdded (address newAlerter, bool isAdd);
174 
175     function addAlerter(address newAlerter) public onlyAdmin {
176         require(!alerters[newAlerter]); // prevent duplicates.
177         require(alertersGroup.length < MAX_GROUP_SIZE);
178 
179         AlerterAdded(newAlerter, true);
180         alerters[newAlerter] = true;
181         alertersGroup.push(newAlerter);
182     }
183 
184     function removeAlerter (address alerter) public onlyAdmin {
185         require(alerters[alerter]);
186         alerters[alerter] = false;
187 
188         for (uint i = 0; i < alertersGroup.length; ++i) {
189             if (alertersGroup[i] == alerter) {
190                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
191                 alertersGroup.length--;
192                 AlerterAdded(alerter, false);
193                 break;
194             }
195         }
196     }
197 
198     event OperatorAdded(address newOperator, bool isAdd);
199 
200     function addOperator(address newOperator) public onlyAdmin {
201         require(!operators[newOperator]); // prevent duplicates.
202         require(operatorsGroup.length < MAX_GROUP_SIZE);
203 
204         OperatorAdded(newOperator, true);
205         operators[newOperator] = true;
206         operatorsGroup.push(newOperator);
207     }
208 
209     function removeOperator (address operator) public onlyAdmin {
210         require(operators[operator]);
211         operators[operator] = false;
212 
213         for (uint i = 0; i < operatorsGroup.length; ++i) {
214             if (operatorsGroup[i] == operator) {
215                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
216                 operatorsGroup.length -= 1;
217                 OperatorAdded(operator, false);
218                 break;
219             }
220         }
221     }
222 }
223 
224 // File: contracts/Withdrawable.sol
225 
226 /**
227  * @title Contracts that should be able to recover tokens or ethers
228  * @author Ilan Doron
229  * @dev This allows to recover any tokens or Ethers received in a contract.
230  * This will prevent any accidental loss of tokens.
231  */
232 contract Withdrawable is PermissionGroups {
233 
234     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
235 
236     /**
237      * @dev Withdraw all ERC20 compatible tokens
238      * @param token ERC20 The address of the token contract
239      */
240     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
241         require(token.transfer(sendTo, amount));
242         TokenWithdraw(token, amount, sendTo);
243     }
244 
245     event EtherWithdraw(uint amount, address sendTo);
246 
247     /**
248      * @dev Withdraw Ethers
249      */
250     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
251         sendTo.transfer(amount);
252         EtherWithdraw(amount, sendTo);
253     }
254 }
255 
256 // File: contracts/DigixReserve.sol
257 
258 interface MakerDao {
259     function peek() public view returns (bytes32, bool);
260 }
261 
262 contract DigixReserve is KyberReserveInterface, Withdrawable, Utils {
263 
264     ERC20 public digix;
265     MakerDao public makerDaoContract;
266     uint maxBlockDrift = 300;
267     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
268     address public kyberNetwork;
269     uint public lastPriceFeed;
270     bool public tradeEnabled;
271     uint constant internal POW_2_64 = 2 ** 64;
272     uint constant digixDecimals = 9;
273     uint buyCommissionBps = 13;
274     uint sellCommissionBps = 13;
275 
276 
277     function DigixReserve(address _admin, address _kyberNetwork, ERC20 _digix) public{
278         require(_admin != address(0));
279         require(_digix != address(0));
280         require(_kyberNetwork != address(0));
281         admin = _admin;
282         digix = _digix;
283         setDecimals(digix);
284         kyberNetwork = _kyberNetwork;
285         tradeEnabled = true;
286     }
287 
288     function () public payable {}
289 
290     /// @dev Add digix price feed. Valid for @maxBlockDrift blocks
291     /// @param blockNumber - the block this price feed was signed.
292     /// @param nonce - the nonce with which this block was signed.
293     /// @param ask ask price dollars per Kg gold == 1000 digix
294     /// @param bid bid price dollars per KG gold == 1000 digix
295     /// @param signature signature of keccak 256 hash of (block, nonce, ask, bid)
296     function addPriceFeed(uint blockNumber, uint nonce, uint ask, uint bid, bytes signature) public {
297         uint prevFeedBlock;
298         uint prevNonce;
299         uint prevAsk;
300         uint prevBid;
301 
302         (prevFeedBlock, prevNonce, prevAsk, prevBid) = getLastPriceFeedValues();
303         require(nonce > prevNonce);
304 
305         signature;
306         //        address signer =
307 //        bool isValidSigner = false;
308 //        for (uint i = 0; i < operatorsGroup.length; i++) {
309 //            if (operatorsGroup[i] == signer){
310 //                isValidSigner = true;
311 //                break;
312 //            }
313 //        }
314 //        require(isValidSigner);
315 
316         lastPriceFeed = encodePriceFeed(blockNumber, nonce, ask, bid);
317     }
318 
319     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
320         if (!tradeEnabled) return 0;
321         if (makerDaoContract == MakerDao(0)) return 0;
322         uint feedBlock;
323         uint nonce;
324         uint ask;
325         uint bid;
326         blockNumber;
327 
328         (feedBlock, nonce, ask, bid) = getLastPriceFeedValues();
329         if (feedBlock + maxBlockDrift < block.number) return 0;
330 
331         uint rate1000Digix;
332 
333         if (ETH_TOKEN_ADDRESS == src) {
334             rate1000Digix = ask;
335         } else if (ETH_TOKEN_ADDRESS == dest) {
336             rate1000Digix = bid;
337         } else {
338             return 0;
339         }
340 
341         // wei per dollar from makerDao
342         bool isRateValid;
343         bytes32 weiPerDoller;
344         (weiPerDoller, isRateValid) = makerDaoContract.peek();
345         if (!isRateValid) return 0;
346 
347         uint rate = rate1000Digix * (10 ** 18) * PRECISION / uint(weiPerDoller) / 1000;
348 
349         uint destQty = getDestQty(src, dest, srcQty, rate);
350 
351         if (getBalance(dest) < destQty) return 0;
352 
353 //        if (sanityRatesContract != address(0)) {
354 //            uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
355 //            if (rate > sanityRate) return 0;
356 //        }
357         return rate;
358     }
359 
360     function getLastPriceFeedValues() public view returns(uint feedBlock, uint nonce, uint ask, uint bid) {
361         (feedBlock, nonce, ask, bid) = decodePriceFeed(lastPriceFeed);
362     }
363 
364     event TradeExecute(
365         address indexed origin,
366         address src,
367         uint srcAmount,
368         address destToken,
369         uint destAmount,
370         address destAddress
371     );
372 
373     function trade(
374         ERC20 srcToken,
375         uint srcAmount,
376         ERC20 destToken,
377         address destAddress,
378         uint conversionRate,
379         bool validate
380     )
381         public
382         payable
383         returns(bool)
384     {
385         require(tradeEnabled);
386         require(msg.sender == kyberNetwork);
387 
388         // can skip validation if done at kyber network level
389         if (validate) {
390             require(conversionRate > 0);
391             if (srcToken == ETH_TOKEN_ADDRESS)
392                 require(msg.value == srcAmount);
393             else
394                 require(msg.value == 0);
395         }
396 
397         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
398         uint adjustedAmount;
399         // sanity check
400         require(destAmount > 0);
401 
402         // collect src tokens
403         if (srcToken != ETH_TOKEN_ADDRESS) {
404             //due to commission network has less tokens. take amount less commission
405             adjustedAmount = srcAmount * (10000 - sellCommissionBps) / 10000;
406             require(srcToken.transferFrom(msg.sender, this, adjustedAmount));
407         }
408 
409         // send dest tokens
410         if (destToken == ETH_TOKEN_ADDRESS) {
411             destAddress.transfer(destAmount);
412         } else {
413             adjustedAmount = destAmount * 10000 / (10000 - buyCommissionBps);
414             require(destToken.transfer(destAddress, adjustedAmount));
415         }
416 
417         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
418 
419         return true;
420     }
421 
422     event TradeEnabled(bool enable);
423 
424     function enableTrade() public onlyAdmin returns(bool) {
425         tradeEnabled = true;
426         TradeEnabled(true);
427 
428         return true;
429     }
430 
431     function disableTrade() public onlyAlerter returns(bool) {
432         tradeEnabled = false;
433         TradeEnabled(false);
434 
435         return true;
436     }
437 
438     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
439 
440     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
441         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
442         WithdrawAddressApproved(token, addr, approve);
443 
444         setDecimals(token);
445     }
446 
447     event WithdrawFunds(ERC20 token, uint amount, address destination);
448 
449     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
450         require(approvedWithdrawAddresses[keccak256(token, destination)]);
451 
452         if (token == ETH_TOKEN_ADDRESS) {
453             destination.transfer(amount);
454         } else {
455             require(token.transfer(destination, amount));
456         }
457 
458         WithdrawFunds(token, amount, destination);
459 
460         return true;
461     }
462 
463     function setMakerDaoContract(MakerDao daoContract) public onlyAdmin{
464         require(daoContract != address(0));
465         makerDaoContract = daoContract;
466     }
467 
468     function setKyberNetworkAddress(address _kyberNetwork) public onlyAdmin{
469         require(_kyberNetwork != address(0));
470         kyberNetwork = _kyberNetwork;
471     }
472 
473     function setMaxBlockDrift(uint numBlocks) public onlyAdmin {
474         require(numBlocks > 1);
475         maxBlockDrift = numBlocks;
476     }
477 
478     function setBuyCommissionBps(uint commission) public onlyAdmin {
479         require(commission < 10000);
480         buyCommissionBps = commission;
481     }
482 
483     function setSellCommissionBps(uint commission) public onlyAdmin {
484         require(commission < 10000);
485         sellCommissionBps = commission;
486     }
487 
488     function encodePriceFeed(uint blockNumber, uint nonce, uint ask, uint bid) internal pure returns(uint) {
489         // check overflows
490         require(blockNumber < POW_2_64);
491         require(nonce < POW_2_64);
492         require(ask < POW_2_64);
493         require(bid < POW_2_64);
494 
495         // do encoding
496         uint result = blockNumber;
497         result |= nonce * POW_2_64;
498         result |= ask * POW_2_64 * POW_2_64;
499         result |= bid * POW_2_64 * POW_2_64 * POW_2_64;
500 
501         return result;
502     }
503 
504     function decodePriceFeed(uint input) internal pure returns(uint blockNumber, uint nonce, uint ask, uint bid) {
505         blockNumber = uint(uint64(input));
506         nonce = uint(uint64(input / POW_2_64));
507         ask = uint(uint64(input / (POW_2_64 * POW_2_64)));
508         bid = uint(uint64(input / (POW_2_64 * POW_2_64 * POW_2_64)));
509     }
510 
511     function getBalance(ERC20 token) public view returns(uint) {
512         if (token == ETH_TOKEN_ADDRESS)
513             return this.balance;
514         else
515             return token.balanceOf(this);
516     }
517 
518     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
519         uint dstDecimals = getDecimals(dest);
520         uint srcDecimals = getDecimals(src);
521         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
522     }
523 }