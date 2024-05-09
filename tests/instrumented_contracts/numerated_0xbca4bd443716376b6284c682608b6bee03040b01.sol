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
27 interface KyberReserveInterface {
28 
29     function trade(
30         ERC20 srcToken,
31         uint srcAmount,
32         ERC20 destToken,
33         address destAddress,
34         uint conversionRate,
35         bool validate
36     )
37         public
38         payable
39         returns(bool);
40 
41     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
42 }
43 
44 contract PermissionGroups {
45 
46     address public admin;
47     address public pendingAdmin;
48     mapping(address=>bool) internal operators;
49     mapping(address=>bool) internal alerters;
50     address[] internal operatorsGroup;
51     address[] internal alertersGroup;
52     uint constant internal MAX_GROUP_SIZE = 50;
53 
54     function PermissionGroups() public {
55         admin = msg.sender;
56     }
57 
58     modifier onlyAdmin() {
59         require(msg.sender == admin);
60         _;
61     }
62 
63     modifier onlyOperator() {
64         require(operators[msg.sender]);
65         _;
66     }
67 
68     modifier onlyAlerter() {
69         require(alerters[msg.sender]);
70         _;
71     }
72 
73     function getOperators () external view returns(address[]) {
74         return operatorsGroup;
75     }
76 
77     function getAlerters () external view returns(address[]) {
78         return alertersGroup;
79     }
80 
81     event TransferAdminPending(address pendingAdmin);
82 
83     /**
84      * @dev Allows the current admin to set the pendingAdmin address.
85      * @param newAdmin The address to transfer ownership to.
86      */
87     function transferAdmin(address newAdmin) public onlyAdmin {
88         require(newAdmin != address(0));
89         TransferAdminPending(pendingAdmin);
90         pendingAdmin = newAdmin;
91     }
92 
93     /**
94      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
95      * @param newAdmin The address to transfer ownership to.
96      */
97     function transferAdminQuickly(address newAdmin) public onlyAdmin {
98         require(newAdmin != address(0));
99         TransferAdminPending(newAdmin);
100         AdminClaimed(newAdmin, admin);
101         admin = newAdmin;
102     }
103 
104     event AdminClaimed( address newAdmin, address previousAdmin);
105 
106     /**
107      * @dev Allows the pendingAdmin address to finalize the change admin process.
108      */
109     function claimAdmin() public {
110         require(pendingAdmin == msg.sender);
111         AdminClaimed(pendingAdmin, admin);
112         admin = pendingAdmin;
113         pendingAdmin = address(0);
114     }
115 
116     event AlerterAdded (address newAlerter, bool isAdd);
117 
118     function addAlerter(address newAlerter) public onlyAdmin {
119         require(!alerters[newAlerter]); // prevent duplicates.
120         require(alertersGroup.length < MAX_GROUP_SIZE);
121 
122         AlerterAdded(newAlerter, true);
123         alerters[newAlerter] = true;
124         alertersGroup.push(newAlerter);
125     }
126 
127     function removeAlerter (address alerter) public onlyAdmin {
128         require(alerters[alerter]);
129         alerters[alerter] = false;
130 
131         for (uint i = 0; i < alertersGroup.length; ++i) {
132             if (alertersGroup[i] == alerter) {
133                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
134                 alertersGroup.length--;
135                 AlerterAdded(alerter, false);
136                 break;
137             }
138         }
139     }
140 
141     event OperatorAdded(address newOperator, bool isAdd);
142 
143     function addOperator(address newOperator) public onlyAdmin {
144         require(!operators[newOperator]); // prevent duplicates.
145         require(operatorsGroup.length < MAX_GROUP_SIZE);
146 
147         OperatorAdded(newOperator, true);
148         operators[newOperator] = true;
149         operatorsGroup.push(newOperator);
150     }
151 
152     function removeOperator (address operator) public onlyAdmin {
153         require(operators[operator]);
154         operators[operator] = false;
155 
156         for (uint i = 0; i < operatorsGroup.length; ++i) {
157             if (operatorsGroup[i] == operator) {
158                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
159                 operatorsGroup.length -= 1;
160                 OperatorAdded(operator, false);
161                 break;
162             }
163         }
164     }
165 }
166 
167 interface SanityRatesInterface {
168     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
169 }
170 
171 contract Utils {
172 
173     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
174     uint  constant internal PRECISION = (10**18);
175     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
176     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
177     uint  constant internal MAX_DECIMALS = 18;
178     uint  constant internal ETH_DECIMALS = 18;
179     mapping(address=>uint) internal decimals;
180 
181     function setDecimals(ERC20 token) internal {
182         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
183         else decimals[token] = token.decimals();
184     }
185 
186     function getDecimals(ERC20 token) internal view returns(uint) {
187         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
188         uint tokenDecimals = decimals[token];
189         // technically, there might be token with decimals 0
190         // moreover, very possible that old tokens have decimals 0
191         // these tokens will just have higher gas fees.
192         if(tokenDecimals == 0) return token.decimals();
193 
194         return tokenDecimals;
195     }
196 
197     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
198         require(srcQty <= MAX_QTY);
199         require(rate <= MAX_RATE);
200 
201         if (dstDecimals >= srcDecimals) {
202             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
203             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
204         } else {
205             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
206             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
207         }
208     }
209 
210     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
211         require(dstQty <= MAX_QTY);
212         require(rate <= MAX_RATE);
213         
214         //source quantity is rounded up. to avoid dest quantity being too low.
215         uint numerator;
216         uint denominator;
217         if (srcDecimals >= dstDecimals) {
218             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
219             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
220             denominator = rate;
221         } else {
222             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
223             numerator = (PRECISION * dstQty);
224             denominator = (rate * (10**(dstDecimals - srcDecimals)));
225         }
226         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
227     }
228 }
229 
230 contract Withdrawable is PermissionGroups {
231 
232     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
233 
234     /**
235      * @dev Withdraw all ERC20 compatible tokens
236      * @param token ERC20 The address of the token contract
237      */
238     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
239         require(token.transfer(sendTo, amount));
240         TokenWithdraw(token, amount, sendTo);
241     }
242 
243     event EtherWithdraw(uint amount, address sendTo);
244 
245     /**
246      * @dev Withdraw Ethers
247      */
248     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
249         sendTo.transfer(amount);
250         EtherWithdraw(amount, sendTo);
251     }
252 }
253 
254 interface FundWalletInterface {
255     function() public payable;
256     function pullToken(ERC20 token, uint amount) external returns (bool);
257     function pullEther(uint amount) external returns (bool);
258     function checkBalance(ERC20 token) public view returns (uint);
259 }
260 
261 /// @title Kyber Fund Reserve contract
262 contract KyberFundReserve is KyberReserveInterface, Withdrawable, Utils {
263 
264     address public kyberNetwork;
265     bool public tradeEnabled;
266     ConversionRatesInterface public conversionRatesContract;
267     SanityRatesInterface public sanityRatesContract;
268     FundWalletInterface public fundWalletContract;
269     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
270 
271     function KyberFundReserve(address _kyberNetwork, ConversionRatesInterface _ratesContract, FundWalletInterface _fundWallet, address _admin) public {
272         require(_admin != address(0));
273         require(_ratesContract != address(0));
274         require(_kyberNetwork != address(0));
275         require(_fundWallet != address(0));
276         kyberNetwork = _kyberNetwork;
277         conversionRatesContract = _ratesContract;
278         fundWalletContract = _fundWallet;
279         admin = _admin;
280         tradeEnabled = true;
281     }
282 
283     event DepositToken(ERC20 token, uint amount);
284 
285     function() public payable {
286         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
287     }
288 
289     event TradeExecute(
290         address indexed origin,
291         address src,
292         uint srcAmount,
293         address destToken,
294         uint destAmount,
295         address destAddress
296     );
297 
298     function trade(
299         ERC20 srcToken,
300         uint srcAmount,
301         ERC20 destToken,
302         address destAddress,
303         uint conversionRate,
304         bool validate
305     )
306         public
307         payable
308         returns(bool)
309     {
310         require(tradeEnabled);
311         require(msg.sender == kyberNetwork);
312 
313         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
314 
315         return true;
316     }
317 
318     event TradeEnabled(bool enable);
319 
320     function enableTrade() public onlyAdmin returns(bool) {
321         tradeEnabled = true;
322         TradeEnabled(true);
323 
324         return true;
325     }
326 
327     function disableTrade() public onlyAlerter returns(bool) {
328         tradeEnabled = false;
329         TradeEnabled(false);
330 
331         return true;
332     }
333 
334     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
335 
336     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
337         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
338         WithdrawAddressApproved(token, addr, approve);
339 
340         setDecimals(token);
341     }
342 
343     function setFundWallet(FundWalletInterface _fundWallet) public onlyAdmin {
344         require(_fundWallet != address(0x0));
345         fundWalletContract = _fundWallet;
346     }
347 
348     event WithdrawFunds(ERC20 token, uint amount, address destination);
349 
350     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
351         require(approvedWithdrawAddresses[keccak256(token, destination)]);
352 
353         if (token == ETH_TOKEN_ADDRESS) {
354             require(ethPuller(amount));
355             destination.transfer(amount);
356         } else {
357             require(tokenPuller(token, amount));
358             require(token.transfer(destination, amount));
359         }
360 
361         WithdrawFunds(token, amount, destination);
362 
363         return true;
364     }
365 
366     event SetContractAddresses(address network, address rate, address sanity);
367 
368     function setContracts(
369         address _kyberNetwork,
370         ConversionRatesInterface _conversionRates,
371         SanityRatesInterface _sanityRates
372     )
373         public
374         onlyAdmin
375     {
376         require(_kyberNetwork != address(0));
377         require(_conversionRates != address(0));
378 
379         kyberNetwork = _kyberNetwork;
380         conversionRatesContract = _conversionRates;
381         sanityRatesContract = _sanityRates;
382 
383         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
384     }
385 
386     ////////////////////////////////////////////////////////////////////////////
387     /// status functions ///////////////////////////////////////////////////////
388     ////////////////////////////////////////////////////////////////////////////
389     function getBalance(ERC20 token) public view returns(uint) {
390         return fetchBalance(token);
391     }
392 
393     function fetchBalance(ERC20 token) public view returns(uint) {
394         return fundWalletContract.checkBalance(token);
395     }
396 
397     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
398         uint dstDecimals = getDecimals(dest);
399         uint srcDecimals = getDecimals(src);
400 
401         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
402     }
403 
404     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
405         uint dstDecimals = getDecimals(dest);
406         uint srcDecimals = getDecimals(src);
407 
408         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
409     }
410 
411     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
412         ERC20 token;
413         bool  isBuy;
414 
415         if (!tradeEnabled) return 0;
416 
417         if (ETH_TOKEN_ADDRESS == src) {
418             isBuy = true;
419             token = dest;
420         } else if (ETH_TOKEN_ADDRESS == dest) {
421             isBuy = false;
422             token = src;
423         } else {
424             return 0; // pair is not listed
425         }
426 
427         uint rate = conversionRatesContract.getRate(token, blockNumber, isBuy, srcQty);
428         uint destQty = getDestQty(src, dest, srcQty, rate);
429 
430         if (getBalance(dest) < destQty) return 0;
431 
432         if (sanityRatesContract != address(0)) {
433             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
434             if (rate > sanityRate) return 0;
435         }
436 
437         return rate;
438     }
439 
440     /// @dev do a trade
441     /// @param srcToken Src token
442     /// @param srcAmount Amount of src token
443     /// @param destToken Destination token
444     /// @param destAddress Destination address to send tokens to
445     /// @param validate If true, additional validations are applicable
446     /// @return true iff trade is successful
447     function doTrade(
448         ERC20 srcToken,
449         uint srcAmount,
450         ERC20 destToken,
451         address destAddress,
452         uint conversionRate,
453         bool validate
454     )
455         internal
456         returns(bool)
457     {
458         // can skip validation if done at kyber network level
459         if (validate) {
460             require(conversionRate > 0);
461             if (srcToken == ETH_TOKEN_ADDRESS)
462                 require(msg.value == srcAmount);
463             else
464                 require(msg.value == 0);
465         }
466 
467         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
468         // sanity check
469         require(destAmount > 0);
470 
471         // add to imbalance
472         ERC20 token;
473         int tradeAmount;
474         if (srcToken == ETH_TOKEN_ADDRESS) {
475             tradeAmount = int(destAmount);
476             token = destToken;
477         } else {
478             tradeAmount = -1 * int(srcAmount);
479             token = srcToken;
480         }
481 
482         conversionRatesContract.recordImbalance(
483             token,
484             tradeAmount,
485             0,
486             block.number
487         );
488 
489 
490         // collect src tokens (if eth forward to fund Wallet)
491         if (srcToken == ETH_TOKEN_ADDRESS) {
492             //require push eth function
493             require(ethPusher(srcAmount));
494         } else {
495             require(srcToken.transferFrom(msg.sender, fundWalletContract, srcAmount));
496         }
497 
498         // send dest tokens
499         if (destToken == ETH_TOKEN_ADDRESS) {
500           //require pull eth function then send eth to dest address;
501           require(ethPuller(destAmount));
502           destAddress.transfer(destAmount);
503         } else {
504           //require pull token function then send token to dest address;
505           require(tokenPuller(destToken, destAmount));
506           require(destToken.transfer(destAddress, destAmount));
507         }
508 
509         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
510 
511         return true;
512     }
513 
514     //push eth function
515     function ethPusher(uint srcAmount) internal returns(bool) {
516         fundWalletContract.transfer(srcAmount);
517         return true;
518     }
519 
520     //pull eth functions
521     function ethPuller(uint destAmount) internal returns(bool) {
522         require(fundWalletContract.pullEther(destAmount));
523         return true;
524     }
525 
526     //pull token function
527     function tokenPuller(ERC20 token, uint destAmount) internal returns(bool) {
528         require(fundWalletContract.pullToken(token, destAmount));
529         return true;
530     }
531 }