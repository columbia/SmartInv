1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, July 5, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.13;
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
31 interface KyberReserveInterface {
32 
33     function trade(
34         ERC20 srcToken,
35         uint srcAmount,
36         ERC20 destToken,
37         address destAddress,
38         uint conversionRate,
39         bool validate
40     )
41         public
42         payable
43         returns(bool);
44 
45     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
46 }
47 
48 contract PermissionGroups {
49 
50     address public admin;
51     address public pendingAdmin;
52     mapping(address=>bool) internal operators;
53     mapping(address=>bool) internal alerters;
54     address[] internal operatorsGroup;
55     address[] internal alertersGroup;
56     uint constant internal MAX_GROUP_SIZE = 50;
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
97     /**
98      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
99      * @param newAdmin The address to transfer ownership to.
100      */
101     function transferAdminQuickly(address newAdmin) public onlyAdmin {
102         require(newAdmin != address(0));
103         TransferAdminPending(newAdmin);
104         AdminClaimed(newAdmin, admin);
105         admin = newAdmin;
106     }
107 
108     event AdminClaimed( address newAdmin, address previousAdmin);
109 
110     /**
111      * @dev Allows the pendingAdmin address to finalize the change admin process.
112      */
113     function claimAdmin() public {
114         require(pendingAdmin == msg.sender);
115         AdminClaimed(pendingAdmin, admin);
116         admin = pendingAdmin;
117         pendingAdmin = address(0);
118     }
119 
120     event AlerterAdded (address newAlerter, bool isAdd);
121 
122     function addAlerter(address newAlerter) public onlyAdmin {
123         require(!alerters[newAlerter]); // prevent duplicates.
124         require(alertersGroup.length < MAX_GROUP_SIZE);
125 
126         AlerterAdded(newAlerter, true);
127         alerters[newAlerter] = true;
128         alertersGroup.push(newAlerter);
129     }
130 
131     function removeAlerter (address alerter) public onlyAdmin {
132         require(alerters[alerter]);
133         alerters[alerter] = false;
134 
135         for (uint i = 0; i < alertersGroup.length; ++i) {
136             if (alertersGroup[i] == alerter) {
137                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
138                 alertersGroup.length--;
139                 AlerterAdded(alerter, false);
140                 break;
141             }
142         }
143     }
144 
145     event OperatorAdded(address newOperator, bool isAdd);
146 
147     function addOperator(address newOperator) public onlyAdmin {
148         require(!operators[newOperator]); // prevent duplicates.
149         require(operatorsGroup.length < MAX_GROUP_SIZE);
150 
151         OperatorAdded(newOperator, true);
152         operators[newOperator] = true;
153         operatorsGroup.push(newOperator);
154     }
155 
156     function removeOperator (address operator) public onlyAdmin {
157         require(operators[operator]);
158         operators[operator] = false;
159 
160         for (uint i = 0; i < operatorsGroup.length; ++i) {
161             if (operatorsGroup[i] == operator) {
162                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
163                 operatorsGroup.length -= 1;
164                 OperatorAdded(operator, false);
165                 break;
166             }
167         }
168     }
169 }
170 
171 interface SanityRatesInterface {
172     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
173 }
174 
175 contract Utils {
176 
177     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
178     uint  constant internal PRECISION = (10**18);
179     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
180     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
181     uint  constant internal MAX_DECIMALS = 18;
182     uint  constant internal ETH_DECIMALS = 18;
183     mapping(address=>uint) internal decimals;
184 
185     function setDecimals(ERC20 token) internal {
186         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
187         else decimals[token] = token.decimals();
188     }
189 
190     function getDecimals(ERC20 token) internal view returns(uint) {
191         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
192         uint tokenDecimals = decimals[token];
193         // technically, there might be token with decimals 0
194         // moreover, very possible that old tokens have decimals 0
195         // these tokens will just have higher gas fees.
196         if(tokenDecimals == 0) return token.decimals();
197 
198         return tokenDecimals;
199     }
200 
201     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
202         require(srcQty <= MAX_QTY);
203         require(rate <= MAX_RATE);
204 
205         if (dstDecimals >= srcDecimals) {
206             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
207             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
208         } else {
209             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
210             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
211         }
212     }
213 
214     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
215         require(dstQty <= MAX_QTY);
216         require(rate <= MAX_RATE);
217         
218         //source quantity is rounded up. to avoid dest quantity being too low.
219         uint numerator;
220         uint denominator;
221         if (srcDecimals >= dstDecimals) {
222             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
223             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
224             denominator = rate;
225         } else {
226             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
227             numerator = (PRECISION * dstQty);
228             denominator = (rate * (10**(dstDecimals - srcDecimals)));
229         }
230         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
231     }
232 }
233 
234 contract Withdrawable is PermissionGroups {
235 
236     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
237 
238     /**
239      * @dev Withdraw all ERC20 compatible tokens
240      * @param token ERC20 The address of the token contract
241      */
242     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
243         require(token.transfer(sendTo, amount));
244         TokenWithdraw(token, amount, sendTo);
245     }
246 
247     event EtherWithdraw(uint amount, address sendTo);
248 
249     /**
250      * @dev Withdraw Ethers
251      */
252     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
253         sendTo.transfer(amount);
254         EtherWithdraw(amount, sendTo);
255     }
256 }
257 
258 contract KyberReserve is KyberReserveInterface, Withdrawable, Utils {
259 
260     address public kyberNetwork;
261     bool public tradeEnabled;
262     ConversionRatesInterface public conversionRatesContract;
263     SanityRatesInterface public sanityRatesContract;
264     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
265     mapping(address=>address) public tokenWallet;
266 
267     function KyberReserve(address _kyberNetwork, ConversionRatesInterface _ratesContract, address _admin) public {
268         require(_admin != address(0));
269         require(_ratesContract != address(0));
270         require(_kyberNetwork != address(0));
271         kyberNetwork = _kyberNetwork;
272         conversionRatesContract = _ratesContract;
273         admin = _admin;
274         tradeEnabled = true;
275     }
276 
277     event DepositToken(ERC20 token, uint amount);
278 
279     function() public payable {
280         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
281     }
282 
283     event TradeExecute(
284         address indexed origin,
285         address src,
286         uint srcAmount,
287         address destToken,
288         uint destAmount,
289         address destAddress
290     );
291 
292     function trade(
293         ERC20 srcToken,
294         uint srcAmount,
295         ERC20 destToken,
296         address destAddress,
297         uint conversionRate,
298         bool validate
299     )
300         public
301         payable
302         returns(bool)
303     {
304         require(tradeEnabled);
305         require(msg.sender == kyberNetwork);
306 
307         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
308 
309         return true;
310     }
311 
312     event TradeEnabled(bool enable);
313 
314     function enableTrade() public onlyAdmin returns(bool) {
315         tradeEnabled = true;
316         TradeEnabled(true);
317 
318         return true;
319     }
320 
321     function disableTrade() public onlyAlerter returns(bool) {
322         tradeEnabled = false;
323         TradeEnabled(false);
324 
325         return true;
326     }
327 
328     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
329 
330     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
331         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
332         WithdrawAddressApproved(token, addr, approve);
333 
334         setDecimals(token);
335         if ((tokenWallet[token] == address(0x0)) && (token != ETH_TOKEN_ADDRESS)) {
336             tokenWallet[token] = this; // by default
337             require(token.approve(this, 2 ** 255));
338         }
339     }
340 
341     event NewTokenWallet(ERC20 token, address wallet);
342 
343     function setTokenWallet(ERC20 token, address wallet) public onlyAdmin {
344         require(wallet != address(0x0));
345         tokenWallet[token] = wallet;
346         NewTokenWallet(token, wallet);
347     }
348 
349     event WithdrawFunds(ERC20 token, uint amount, address destination);
350 
351     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
352         require(approvedWithdrawAddresses[keccak256(token, destination)]);
353 
354         if (token == ETH_TOKEN_ADDRESS) {
355             destination.transfer(amount);
356         } else {
357             require(token.transferFrom(tokenWallet[token], destination, amount));
358         }
359 
360         WithdrawFunds(token, amount, destination);
361 
362         return true;
363     }
364 
365     event SetContractAddresses(address network, address rate, address sanity);
366 
367     function setContracts(
368         address _kyberNetwork,
369         ConversionRatesInterface _conversionRates,
370         SanityRatesInterface _sanityRates
371     )
372         public
373         onlyAdmin
374     {
375         require(_kyberNetwork != address(0));
376         require(_conversionRates != address(0));
377 
378         kyberNetwork = _kyberNetwork;
379         conversionRatesContract = _conversionRates;
380         sanityRatesContract = _sanityRates;
381 
382         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
383     }
384 
385     ////////////////////////////////////////////////////////////////////////////
386     /// status functions ///////////////////////////////////////////////////////
387     ////////////////////////////////////////////////////////////////////////////
388     function getBalance(ERC20 token) public view returns(uint) {
389         if (token == ETH_TOKEN_ADDRESS)
390             return this.balance;
391         else {
392             address wallet = tokenWallet[token];
393             uint balanceOfWallet = token.balanceOf(wallet);
394             uint allowanceOfWallet = token.allowance(wallet, this);
395 
396             return (balanceOfWallet < allowanceOfWallet) ? balanceOfWallet : allowanceOfWallet;
397         }
398     }
399 
400     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
401         uint dstDecimals = getDecimals(dest);
402         uint srcDecimals = getDecimals(src);
403 
404         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
405     }
406 
407     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
408         uint dstDecimals = getDecimals(dest);
409         uint srcDecimals = getDecimals(src);
410 
411         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
412     }
413 
414     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
415         ERC20 token;
416         bool  isBuy;
417 
418         if (!tradeEnabled) return 0;
419 
420         if (ETH_TOKEN_ADDRESS == src) {
421             isBuy = true;
422             token = dest;
423         } else if (ETH_TOKEN_ADDRESS == dest) {
424             isBuy = false;
425             token = src;
426         } else {
427             return 0; // pair is not listed
428         }
429 
430         uint rate = conversionRatesContract.getRate(token, blockNumber, isBuy, srcQty);
431         uint destQty = getDestQty(src, dest, srcQty, rate);
432 
433         if (getBalance(dest) < destQty) return 0;
434 
435         if (sanityRatesContract != address(0)) {
436             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
437             if (rate > sanityRate) return 0;
438         }
439 
440         return rate;
441     }
442 
443     /// @dev do a trade
444     /// @param srcToken Src token
445     /// @param srcAmount Amount of src token
446     /// @param destToken Destination token
447     /// @param destAddress Destination address to send tokens to
448     /// @param validate If true, additional validations are applicable
449     /// @return true iff trade is successful
450     function doTrade(
451         ERC20 srcToken,
452         uint srcAmount,
453         ERC20 destToken,
454         address destAddress,
455         uint conversionRate,
456         bool validate
457     )
458         internal
459         returns(bool)
460     {
461         // can skip validation if done at kyber network level
462         if (validate) {
463             require(conversionRate > 0);
464             if (srcToken == ETH_TOKEN_ADDRESS)
465                 require(msg.value == srcAmount);
466             else
467                 require(msg.value == 0);
468         }
469 
470         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
471         // sanity check
472         require(destAmount > 0);
473 
474         // add to imbalance
475         ERC20 token;
476         int tradeAmount;
477         if (srcToken == ETH_TOKEN_ADDRESS) {
478             tradeAmount = int(destAmount);
479             token = destToken;
480         } else {
481             tradeAmount = -1 * int(srcAmount);
482             token = srcToken;
483         }
484 
485         conversionRatesContract.recordImbalance(
486             token,
487             tradeAmount,
488             0,
489             block.number
490         );
491 
492         // collect src tokens
493         if (srcToken != ETH_TOKEN_ADDRESS) {
494             require(srcToken.transferFrom(msg.sender, tokenWallet[srcToken], srcAmount));
495         }
496 
497         // send dest tokens
498         if (destToken == ETH_TOKEN_ADDRESS) {
499             destAddress.transfer(destAmount);
500         } else {
501             require(destToken.transferFrom(tokenWallet[destToken], destAddress, destAmount));
502         }
503 
504         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
505 
506         return true;
507     }
508 }