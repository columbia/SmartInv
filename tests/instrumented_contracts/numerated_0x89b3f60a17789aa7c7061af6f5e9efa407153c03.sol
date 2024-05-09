1 // File: contracts/ERC20Interface.sol
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
18 // File: contracts/Utils.sol
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
84 // File: contracts/PermissionGroups.sol
85 
86 pragma solidity 0.4.18;
87 
88 
89 contract PermissionGroups {
90 
91     address public admin;
92     address public pendingAdmin;
93     mapping(address=>bool) internal operators;
94     mapping(address=>bool) internal alerters;
95     address[] internal operatorsGroup;
96     address[] internal alertersGroup;
97     uint constant internal MAX_GROUP_SIZE = 50;
98 
99     function PermissionGroups() public {
100         admin = msg.sender;
101     }
102 
103     modifier onlyAdmin() {
104         require(msg.sender == admin);
105         _;
106     }
107 
108     modifier onlyOperator() {
109         require(operators[msg.sender]);
110         _;
111     }
112 
113     modifier onlyAlerter() {
114         require(alerters[msg.sender]);
115         _;
116     }
117 
118     function getOperators () external view returns(address[]) {
119         return operatorsGroup;
120     }
121 
122     function getAlerters () external view returns(address[]) {
123         return alertersGroup;
124     }
125 
126     event TransferAdminPending(address pendingAdmin);
127 
128     /**
129      * @dev Allows the current admin to set the pendingAdmin address.
130      * @param newAdmin The address to transfer ownership to.
131      */
132     function transferAdmin(address newAdmin) public onlyAdmin {
133         require(newAdmin != address(0));
134         TransferAdminPending(pendingAdmin);
135         pendingAdmin = newAdmin;
136     }
137 
138     /**
139      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
140      * @param newAdmin The address to transfer ownership to.
141      */
142     function transferAdminQuickly(address newAdmin) public onlyAdmin {
143         require(newAdmin != address(0));
144         TransferAdminPending(newAdmin);
145         AdminClaimed(newAdmin, admin);
146         admin = newAdmin;
147     }
148 
149     event AdminClaimed( address newAdmin, address previousAdmin);
150 
151     /**
152      * @dev Allows the pendingAdmin address to finalize the change admin process.
153      */
154     function claimAdmin() public {
155         require(pendingAdmin == msg.sender);
156         AdminClaimed(pendingAdmin, admin);
157         admin = pendingAdmin;
158         pendingAdmin = address(0);
159     }
160 
161     event AlerterAdded (address newAlerter, bool isAdd);
162 
163     function addAlerter(address newAlerter) public onlyAdmin {
164         require(!alerters[newAlerter]); // prevent duplicates.
165         require(alertersGroup.length < MAX_GROUP_SIZE);
166 
167         AlerterAdded(newAlerter, true);
168         alerters[newAlerter] = true;
169         alertersGroup.push(newAlerter);
170     }
171 
172     function removeAlerter (address alerter) public onlyAdmin {
173         require(alerters[alerter]);
174         alerters[alerter] = false;
175 
176         for (uint i = 0; i < alertersGroup.length; ++i) {
177             if (alertersGroup[i] == alerter) {
178                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
179                 alertersGroup.length--;
180                 AlerterAdded(alerter, false);
181                 break;
182             }
183         }
184     }
185 
186     event OperatorAdded(address newOperator, bool isAdd);
187 
188     function addOperator(address newOperator) public onlyAdmin {
189         require(!operators[newOperator]); // prevent duplicates.
190         require(operatorsGroup.length < MAX_GROUP_SIZE);
191 
192         OperatorAdded(newOperator, true);
193         operators[newOperator] = true;
194         operatorsGroup.push(newOperator);
195     }
196 
197     function removeOperator (address operator) public onlyAdmin {
198         require(operators[operator]);
199         operators[operator] = false;
200 
201         for (uint i = 0; i < operatorsGroup.length; ++i) {
202             if (operatorsGroup[i] == operator) {
203                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
204                 operatorsGroup.length -= 1;
205                 OperatorAdded(operator, false);
206                 break;
207             }
208         }
209     }
210 }
211 
212 // File: contracts/Withdrawable.sol
213 
214 pragma solidity 0.4.18;
215 
216 
217 
218 
219 /**
220  * @title Contracts that should be able to recover tokens or ethers
221  * @author Ilan Doron
222  * @dev This allows to recover any tokens or Ethers received in a contract.
223  * This will prevent any accidental loss of tokens.
224  */
225 contract Withdrawable is PermissionGroups {
226 
227     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
228 
229     /**
230      * @dev Withdraw all ERC20 compatible tokens
231      * @param token ERC20 The address of the token contract
232      */
233     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
234         require(token.transfer(sendTo, amount));
235         TokenWithdraw(token, amount, sendTo);
236     }
237 
238     event EtherWithdraw(uint amount, address sendTo);
239 
240     /**
241      * @dev Withdraw Ethers
242      */
243     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
244         sendTo.transfer(amount);
245         EtherWithdraw(amount, sendTo);
246     }
247 }
248 
249 // File: contracts/ConversionRatesInterface.sol
250 
251 pragma solidity 0.4.18;
252 
253 
254 
255 interface ConversionRatesInterface {
256 
257     function recordImbalance(
258         ERC20 token,
259         int buyAmount,
260         uint rateUpdateBlock,
261         uint currentBlock
262     )
263         public;
264 
265     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
266 }
267 
268 // File: contracts/SanityRatesInterface.sol
269 
270 pragma solidity 0.4.18;
271 
272 
273 interface SanityRatesInterface {
274     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
275 }
276 
277 // File: contracts/KyberReserveInterface.sol
278 
279 pragma solidity 0.4.18;
280 
281 
282 /// @title Kyber Reserve contract
283 interface KyberReserveInterface {
284 
285     function trade(
286         ERC20 srcToken,
287         uint srcAmount,
288         ERC20 destToken,
289         address destAddress,
290         uint conversionRate,
291         bool validate
292     )
293         public
294         payable
295         returns(bool);
296 
297     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
298 }
299 
300 // File: contracts/reserves/KyberReserve.sol
301 
302 pragma solidity 0.4.18;
303 
304 
305 
306 
307 
308 
309 
310 
311 /// @title Kyber Reserve contract
312 contract KyberReserve is KyberReserveInterface, Withdrawable, Utils {
313 
314     address public kyberNetwork;
315     bool public tradeEnabled;
316     ConversionRatesInterface public conversionRatesContract;
317     SanityRatesInterface public sanityRatesContract;
318     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
319     mapping(address=>address) public tokenWallet;
320 
321     function KyberReserve(address _kyberNetwork, ConversionRatesInterface _ratesContract, address _admin) public {
322         require(_admin != address(0));
323         require(_ratesContract != address(0));
324         require(_kyberNetwork != address(0));
325         kyberNetwork = _kyberNetwork;
326         conversionRatesContract = _ratesContract;
327         admin = _admin;
328         tradeEnabled = true;
329     }
330 
331     event DepositToken(ERC20 token, uint amount);
332 
333     function() public payable {
334         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
335     }
336 
337     event TradeExecute(
338         address indexed origin,
339         address src,
340         uint srcAmount,
341         address destToken,
342         uint destAmount,
343         address destAddress
344     );
345 
346     function trade(
347         ERC20 srcToken,
348         uint srcAmount,
349         ERC20 destToken,
350         address destAddress,
351         uint conversionRate,
352         bool validate
353     )
354         public
355         payable
356         returns(bool)
357     {
358         require(tradeEnabled);
359         require(msg.sender == kyberNetwork);
360 
361         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
362 
363         return true;
364     }
365 
366     event TradeEnabled(bool enable);
367 
368     function enableTrade() public onlyAdmin returns(bool) {
369         tradeEnabled = true;
370         TradeEnabled(true);
371 
372         return true;
373     }
374 
375     function disableTrade() public onlyAlerter returns(bool) {
376         tradeEnabled = false;
377         TradeEnabled(false);
378 
379         return true;
380     }
381 
382     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
383 
384     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
385         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
386         WithdrawAddressApproved(token, addr, approve);
387 
388         setDecimals(token);
389         if ((tokenWallet[token] == address(0x0)) && (token != ETH_TOKEN_ADDRESS)) {
390             tokenWallet[token] = this; // by default
391             require(token.approve(this, 2 ** 255));
392         }
393     }
394 
395     event NewTokenWallet(ERC20 token, address wallet);
396 
397     function setTokenWallet(ERC20 token, address wallet) public onlyAdmin {
398         require(wallet != address(0x0));
399         tokenWallet[token] = wallet;
400         NewTokenWallet(token, wallet);
401     }
402 
403     event WithdrawFunds(ERC20 token, uint amount, address destination);
404 
405     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
406         require(approvedWithdrawAddresses[keccak256(token, destination)]);
407 
408         if (token == ETH_TOKEN_ADDRESS) {
409             destination.transfer(amount);
410         } else {
411             require(token.transferFrom(tokenWallet[token], destination, amount));
412         }
413 
414         WithdrawFunds(token, amount, destination);
415 
416         return true;
417     }
418 
419     event SetContractAddresses(address network, address rate, address sanity);
420 
421     function setContracts(
422         address _kyberNetwork,
423         ConversionRatesInterface _conversionRates,
424         SanityRatesInterface _sanityRates
425     )
426         public
427         onlyAdmin
428     {
429         require(_kyberNetwork != address(0));
430         require(_conversionRates != address(0));
431 
432         kyberNetwork = _kyberNetwork;
433         conversionRatesContract = _conversionRates;
434         sanityRatesContract = _sanityRates;
435 
436         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
437     }
438 
439     ////////////////////////////////////////////////////////////////////////////
440     /// status functions ///////////////////////////////////////////////////////
441     ////////////////////////////////////////////////////////////////////////////
442     function getBalance(ERC20 token) public view returns(uint) {
443         if (token == ETH_TOKEN_ADDRESS)
444             return this.balance;
445         else {
446             address wallet = tokenWallet[token];
447             uint balanceOfWallet = token.balanceOf(wallet);
448             uint allowanceOfWallet = token.allowance(wallet, this);
449 
450             return (balanceOfWallet < allowanceOfWallet) ? balanceOfWallet : allowanceOfWallet;
451         }
452     }
453 
454     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
455         uint dstDecimals = getDecimals(dest);
456         uint srcDecimals = getDecimals(src);
457 
458         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
459     }
460 
461     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
462         uint dstDecimals = getDecimals(dest);
463         uint srcDecimals = getDecimals(src);
464 
465         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
466     }
467 
468     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
469         ERC20 token;
470         bool  isBuy;
471 
472         if (!tradeEnabled) return 0;
473 
474         if (ETH_TOKEN_ADDRESS == src) {
475             isBuy = true;
476             token = dest;
477         } else if (ETH_TOKEN_ADDRESS == dest) {
478             isBuy = false;
479             token = src;
480         } else {
481             return 0; // pair is not listed
482         }
483 
484         uint rate = conversionRatesContract.getRate(token, blockNumber, isBuy, srcQty);
485         uint destQty = getDestQty(src, dest, srcQty, rate);
486 
487         if (getBalance(dest) < destQty) return 0;
488 
489         if (sanityRatesContract != address(0)) {
490             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
491             if (rate > sanityRate) return 0;
492         }
493 
494         return rate;
495     }
496 
497     /// @dev do a trade
498     /// @param srcToken Src token
499     /// @param srcAmount Amount of src token
500     /// @param destToken Destination token
501     /// @param destAddress Destination address to send tokens to
502     /// @param validate If true, additional validations are applicable
503     /// @return true iff trade is successful
504     function doTrade(
505         ERC20 srcToken,
506         uint srcAmount,
507         ERC20 destToken,
508         address destAddress,
509         uint conversionRate,
510         bool validate
511     )
512         internal
513         returns(bool)
514     {
515         // can skip validation if done at kyber network level
516         if (validate) {
517             require(conversionRate > 0);
518             if (srcToken == ETH_TOKEN_ADDRESS)
519                 require(msg.value == srcAmount);
520             else
521                 require(msg.value == 0);
522         }
523 
524         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
525         // sanity check
526         require(destAmount > 0);
527 
528         // add to imbalance
529         ERC20 token;
530         int tradeAmount;
531         if (srcToken == ETH_TOKEN_ADDRESS) {
532             tradeAmount = int(destAmount);
533             token = destToken;
534         } else {
535             tradeAmount = -1 * int(srcAmount);
536             token = srcToken;
537         }
538 
539         conversionRatesContract.recordImbalance(
540             token,
541             tradeAmount,
542             0,
543             block.number
544         );
545 
546         // collect src tokens
547         if (srcToken != ETH_TOKEN_ADDRESS) {
548             require(srcToken.transferFrom(msg.sender, tokenWallet[srcToken], srcAmount));
549         }
550 
551         // send dest tokens
552         if (destToken == ETH_TOKEN_ADDRESS) {
553             destAddress.transfer(destAmount);
554         } else {
555             require(destToken.transferFrom(tokenWallet[destToken], destAddress, destAmount));
556         }
557 
558         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
559 
560         return true;
561     }
562 }