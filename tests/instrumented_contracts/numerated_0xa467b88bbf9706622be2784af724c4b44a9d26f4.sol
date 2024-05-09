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
17 // File: contracts/Utils.sol
18 
19 /// @title Kyber constants contract
20 contract Utils {
21 
22     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
23     uint  constant internal PRECISION = (10**18);
24     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
25     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
26     uint  constant internal MAX_DECIMALS = 18;
27     uint  constant internal ETH_DECIMALS = 18;
28     mapping(address=>uint) internal decimals;
29 
30     function setDecimals(ERC20 token) internal {
31         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
32         else decimals[token] = token.decimals();
33     }
34 
35     function getDecimals(ERC20 token) internal view returns(uint) {
36         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
37         uint tokenDecimals = decimals[token];
38         // technically, there might be token with decimals 0
39         // moreover, very possible that old tokens have decimals 0
40         // these tokens will just have higher gas fees.
41         if(tokenDecimals == 0) return token.decimals();
42 
43         return tokenDecimals;
44     }
45 
46     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
47         require(srcQty <= MAX_QTY);
48         require(rate <= MAX_RATE);
49 
50         if (dstDecimals >= srcDecimals) {
51             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
52             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
53         } else {
54             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
55             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
56         }
57     }
58 
59     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
60         require(dstQty <= MAX_QTY);
61         require(rate <= MAX_RATE);
62         
63         //source quantity is rounded up. to avoid dest quantity being too low.
64         uint numerator;
65         uint denominator;
66         if (srcDecimals >= dstDecimals) {
67             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
68             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
69             denominator = rate;
70         } else {
71             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
72             numerator = (PRECISION * dstQty);
73             denominator = (rate * (10**(dstDecimals - srcDecimals)));
74         }
75         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
76     }
77 }
78 
79 // File: contracts/PermissionGroups.sol
80 
81 contract PermissionGroups {
82 
83     address public admin;
84     address public pendingAdmin;
85     mapping(address=>bool) internal operators;
86     mapping(address=>bool) internal alerters;
87     address[] internal operatorsGroup;
88     address[] internal alertersGroup;
89     uint constant internal MAX_GROUP_SIZE = 50;
90 
91     function PermissionGroups() public {
92         admin = msg.sender;
93     }
94 
95     modifier onlyAdmin() {
96         require(msg.sender == admin);
97         _;
98     }
99 
100     modifier onlyOperator() {
101         require(operators[msg.sender]);
102         _;
103     }
104 
105     modifier onlyAlerter() {
106         require(alerters[msg.sender]);
107         _;
108     }
109 
110     function getOperators () external view returns(address[]) {
111         return operatorsGroup;
112     }
113 
114     function getAlerters () external view returns(address[]) {
115         return alertersGroup;
116     }
117 
118     event TransferAdminPending(address pendingAdmin);
119 
120     /**
121      * @dev Allows the current admin to set the pendingAdmin address.
122      * @param newAdmin The address to transfer ownership to.
123      */
124     function transferAdmin(address newAdmin) public onlyAdmin {
125         require(newAdmin != address(0));
126         TransferAdminPending(pendingAdmin);
127         pendingAdmin = newAdmin;
128     }
129 
130     /**
131      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
132      * @param newAdmin The address to transfer ownership to.
133      */
134     function transferAdminQuickly(address newAdmin) public onlyAdmin {
135         require(newAdmin != address(0));
136         TransferAdminPending(newAdmin);
137         AdminClaimed(newAdmin, admin);
138         admin = newAdmin;
139     }
140 
141     event AdminClaimed( address newAdmin, address previousAdmin);
142 
143     /**
144      * @dev Allows the pendingAdmin address to finalize the change admin process.
145      */
146     function claimAdmin() public {
147         require(pendingAdmin == msg.sender);
148         AdminClaimed(pendingAdmin, admin);
149         admin = pendingAdmin;
150         pendingAdmin = address(0);
151     }
152 
153     event AlerterAdded (address newAlerter, bool isAdd);
154 
155     function addAlerter(address newAlerter) public onlyAdmin {
156         require(!alerters[newAlerter]); // prevent duplicates.
157         require(alertersGroup.length < MAX_GROUP_SIZE);
158 
159         AlerterAdded(newAlerter, true);
160         alerters[newAlerter] = true;
161         alertersGroup.push(newAlerter);
162     }
163 
164     function removeAlerter (address alerter) public onlyAdmin {
165         require(alerters[alerter]);
166         alerters[alerter] = false;
167 
168         for (uint i = 0; i < alertersGroup.length; ++i) {
169             if (alertersGroup[i] == alerter) {
170                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
171                 alertersGroup.length--;
172                 AlerterAdded(alerter, false);
173                 break;
174             }
175         }
176     }
177 
178     event OperatorAdded(address newOperator, bool isAdd);
179 
180     function addOperator(address newOperator) public onlyAdmin {
181         require(!operators[newOperator]); // prevent duplicates.
182         require(operatorsGroup.length < MAX_GROUP_SIZE);
183 
184         OperatorAdded(newOperator, true);
185         operators[newOperator] = true;
186         operatorsGroup.push(newOperator);
187     }
188 
189     function removeOperator (address operator) public onlyAdmin {
190         require(operators[operator]);
191         operators[operator] = false;
192 
193         for (uint i = 0; i < operatorsGroup.length; ++i) {
194             if (operatorsGroup[i] == operator) {
195                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
196                 operatorsGroup.length -= 1;
197                 OperatorAdded(operator, false);
198                 break;
199             }
200         }
201     }
202 }
203 
204 // File: contracts/Withdrawable.sol
205 
206 /**
207  * @title Contracts that should be able to recover tokens or ethers
208  * @author Ilan Doron
209  * @dev This allows to recover any tokens or Ethers received in a contract.
210  * This will prevent any accidental loss of tokens.
211  */
212 contract Withdrawable is PermissionGroups {
213 
214     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
215 
216     /**
217      * @dev Withdraw all ERC20 compatible tokens
218      * @param token ERC20 The address of the token contract
219      */
220     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
221         require(token.transfer(sendTo, amount));
222         TokenWithdraw(token, amount, sendTo);
223     }
224 
225     event EtherWithdraw(uint amount, address sendTo);
226 
227     /**
228      * @dev Withdraw Ethers
229      */
230     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
231         sendTo.transfer(amount);
232         EtherWithdraw(amount, sendTo);
233     }
234 }
235 
236 // File: contracts/ConversionRatesInterface.sol
237 
238 interface ConversionRatesInterface {
239 
240     function recordImbalance(
241         ERC20 token,
242         int buyAmount,
243         uint rateUpdateBlock,
244         uint currentBlock
245     )
246         public;
247 
248     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
249 }
250 
251 // File: contracts/SanityRatesInterface.sol
252 
253 interface SanityRatesInterface {
254     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
255 }
256 
257 // File: contracts/KyberReserveInterface.sol
258 
259 /// @title Kyber Reserve contract
260 interface KyberReserveInterface {
261 
262     function trade(
263         ERC20 srcToken,
264         uint srcAmount,
265         ERC20 destToken,
266         address destAddress,
267         uint conversionRate,
268         bool validate
269     )
270         public
271         payable
272         returns(bool);
273 
274     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
275 }
276 
277 // File: contracts/KyberReserve.sol
278 
279 /// @title Kyber Reserve contract
280 contract KyberReserve is KyberReserveInterface, Withdrawable, Utils {
281 
282     address public kyberNetwork;
283     bool public tradeEnabled;
284     ConversionRatesInterface public conversionRatesContract;
285     SanityRatesInterface public sanityRatesContract;
286     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
287     mapping(address=>address) public tokenWallet;
288 
289     function KyberReserve(address _kyberNetwork, ConversionRatesInterface _ratesContract, address _admin) public {
290         require(_admin != address(0));
291         require(_ratesContract != address(0));
292         require(_kyberNetwork != address(0));
293         kyberNetwork = _kyberNetwork;
294         conversionRatesContract = _ratesContract;
295         admin = _admin;
296         tradeEnabled = true;
297     }
298 
299     event DepositToken(ERC20 token, uint amount);
300 
301     function() public payable {
302         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
303     }
304 
305     event TradeExecute(
306         address indexed origin,
307         address src,
308         uint srcAmount,
309         address destToken,
310         uint destAmount,
311         address destAddress
312     );
313 
314     function trade(
315         ERC20 srcToken,
316         uint srcAmount,
317         ERC20 destToken,
318         address destAddress,
319         uint conversionRate,
320         bool validate
321     )
322         public
323         payable
324         returns(bool)
325     {
326         require(tradeEnabled);
327         require(msg.sender == kyberNetwork);
328 
329         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
330 
331         return true;
332     }
333 
334     event TradeEnabled(bool enable);
335 
336     function enableTrade() public onlyAdmin returns(bool) {
337         tradeEnabled = true;
338         TradeEnabled(true);
339 
340         return true;
341     }
342 
343     function disableTrade() public onlyAlerter returns(bool) {
344         tradeEnabled = false;
345         TradeEnabled(false);
346 
347         return true;
348     }
349 
350     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
351 
352     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
353         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
354         WithdrawAddressApproved(token, addr, approve);
355 
356         setDecimals(token);
357         if ((tokenWallet[token] == address(0x0)) && (token != ETH_TOKEN_ADDRESS)) {
358             tokenWallet[token] = this; // by default
359             require(token.approve(this, 2 ** 255));
360         }
361     }
362 
363     event NewTokenWallet(ERC20 token, address wallet);
364 
365     function setTokenWallet(ERC20 token, address wallet) public onlyAdmin {
366         require(wallet != address(0x0));
367         tokenWallet[token] = wallet;
368         NewTokenWallet(token, wallet);
369     }
370 
371     event WithdrawFunds(ERC20 token, uint amount, address destination);
372 
373     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
374         require(approvedWithdrawAddresses[keccak256(token, destination)]);
375 
376         if (token == ETH_TOKEN_ADDRESS) {
377             destination.transfer(amount);
378         } else {
379             require(token.transferFrom(tokenWallet[token], destination, amount));
380         }
381 
382         WithdrawFunds(token, amount, destination);
383 
384         return true;
385     }
386 
387     event SetContractAddresses(address network, address rate, address sanity);
388 
389     function setContracts(
390         address _kyberNetwork,
391         ConversionRatesInterface _conversionRates,
392         SanityRatesInterface _sanityRates
393     )
394         public
395         onlyAdmin
396     {
397         require(_kyberNetwork != address(0));
398         require(_conversionRates != address(0));
399 
400         kyberNetwork = _kyberNetwork;
401         conversionRatesContract = _conversionRates;
402         sanityRatesContract = _sanityRates;
403 
404         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
405     }
406 
407     ////////////////////////////////////////////////////////////////////////////
408     /// status functions ///////////////////////////////////////////////////////
409     ////////////////////////////////////////////////////////////////////////////
410     function getBalance(ERC20 token) public view returns(uint) {
411         if (token == ETH_TOKEN_ADDRESS)
412             return this.balance;
413         else {
414             address wallet = tokenWallet[token];
415             uint balanceOfWallet = token.balanceOf(wallet);
416             uint allowanceOfWallet = token.allowance(wallet, this);
417 
418             return (balanceOfWallet < allowanceOfWallet) ? balanceOfWallet : allowanceOfWallet;
419         }
420     }
421 
422     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
423         uint dstDecimals = getDecimals(dest);
424         uint srcDecimals = getDecimals(src);
425 
426         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
427     }
428 
429     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
430         uint dstDecimals = getDecimals(dest);
431         uint srcDecimals = getDecimals(src);
432 
433         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
434     }
435 
436     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
437         ERC20 token;
438         bool  isBuy;
439 
440         if (!tradeEnabled) return 0;
441 
442         if (ETH_TOKEN_ADDRESS == src) {
443             isBuy = true;
444             token = dest;
445         } else if (ETH_TOKEN_ADDRESS == dest) {
446             isBuy = false;
447             token = src;
448         } else {
449             return 0; // pair is not listed
450         }
451 
452         uint rate = conversionRatesContract.getRate(token, blockNumber, isBuy, srcQty);
453         uint destQty = getDestQty(src, dest, srcQty, rate);
454 
455         if (getBalance(dest) < destQty) return 0;
456 
457         if (sanityRatesContract != address(0)) {
458             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
459             if (rate > sanityRate) return 0;
460         }
461 
462         return rate;
463     }
464 
465     /// @dev do a trade
466     /// @param srcToken Src token
467     /// @param srcAmount Amount of src token
468     /// @param destToken Destination token
469     /// @param destAddress Destination address to send tokens to
470     /// @param validate If true, additional validations are applicable
471     /// @return true iff trade is successful
472     function doTrade(
473         ERC20 srcToken,
474         uint srcAmount,
475         ERC20 destToken,
476         address destAddress,
477         uint conversionRate,
478         bool validate
479     )
480         internal
481         returns(bool)
482     {
483         // can skip validation if done at kyber network level
484         if (validate) {
485             require(conversionRate > 0);
486             if (srcToken == ETH_TOKEN_ADDRESS)
487                 require(msg.value == srcAmount);
488             else
489                 require(msg.value == 0);
490         }
491 
492         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
493         // sanity check
494         require(destAmount > 0);
495 
496         // add to imbalance
497         ERC20 token;
498         int tradeAmount;
499         if (srcToken == ETH_TOKEN_ADDRESS) {
500             tradeAmount = int(destAmount);
501             token = destToken;
502         } else {
503             tradeAmount = -1 * int(srcAmount);
504             token = srcToken;
505         }
506 
507         conversionRatesContract.recordImbalance(
508             token,
509             tradeAmount,
510             0,
511             block.number
512         );
513 
514         // collect src tokens
515         if (srcToken != ETH_TOKEN_ADDRESS) {
516             require(srcToken.transferFrom(msg.sender, tokenWallet[srcToken], srcAmount));
517         }
518 
519         // send dest tokens
520         if (destToken == ETH_TOKEN_ADDRESS) {
521             destAddress.transfer(destAmount);
522         } else {
523             require(destToken.transferFrom(tokenWallet[destToken], destAddress, destAmount));
524         }
525 
526         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
527 
528         return true;
529     }
530 }