1 pragma solidity ^0.4.13;
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
254 contract KyberReserve is KyberReserveInterface, Withdrawable, Utils {
255 
256     address public kyberNetwork;
257     bool public tradeEnabled;
258     ConversionRatesInterface public conversionRatesContract;
259     SanityRatesInterface public sanityRatesContract;
260     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
261     mapping(address=>address) public tokenWallet;
262 
263     function KyberReserve(address _kyberNetwork, ConversionRatesInterface _ratesContract, address _admin) public {
264         require(_admin != address(0));
265         require(_ratesContract != address(0));
266         require(_kyberNetwork != address(0));
267         kyberNetwork = _kyberNetwork;
268         conversionRatesContract = _ratesContract;
269         admin = _admin;
270         tradeEnabled = true;
271     }
272 
273     event DepositToken(ERC20 token, uint amount);
274 
275     function() public payable {
276         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
277     }
278 
279     event TradeExecute(
280         address indexed origin,
281         address src,
282         uint srcAmount,
283         address destToken,
284         uint destAmount,
285         address destAddress
286     );
287 
288     function trade(
289         ERC20 srcToken,
290         uint srcAmount,
291         ERC20 destToken,
292         address destAddress,
293         uint conversionRate,
294         bool validate
295     )
296         public
297         payable
298         returns(bool)
299     {
300         require(tradeEnabled);
301         require(msg.sender == kyberNetwork);
302 
303         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
304 
305         return true;
306     }
307 
308     event TradeEnabled(bool enable);
309 
310     function enableTrade() public onlyAdmin returns(bool) {
311         tradeEnabled = true;
312         TradeEnabled(true);
313 
314         return true;
315     }
316 
317     function disableTrade() public onlyAlerter returns(bool) {
318         tradeEnabled = false;
319         TradeEnabled(false);
320 
321         return true;
322     }
323 
324     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
325 
326     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
327         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
328         WithdrawAddressApproved(token, addr, approve);
329 
330         setDecimals(token);
331         if ((tokenWallet[token] == address(0x0)) && (token != ETH_TOKEN_ADDRESS)) {
332             tokenWallet[token] = this; // by default
333             require(token.approve(this, 2 ** 255));
334         }
335     }
336 
337     event NewTokenWallet(ERC20 token, address wallet);
338 
339     function setTokenWallet(ERC20 token, address wallet) public onlyAdmin {
340         require(wallet != address(0x0));
341         tokenWallet[token] = wallet;
342         NewTokenWallet(token, wallet);
343     }
344 
345     event WithdrawFunds(ERC20 token, uint amount, address destination);
346 
347     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
348         require(approvedWithdrawAddresses[keccak256(token, destination)]);
349 
350         if (token == ETH_TOKEN_ADDRESS) {
351             destination.transfer(amount);
352         } else {
353             require(token.transferFrom(tokenWallet[token], destination, amount));
354         }
355 
356         WithdrawFunds(token, amount, destination);
357 
358         return true;
359     }
360 
361     event SetContractAddresses(address network, address rate, address sanity);
362 
363     function setContracts(
364         address _kyberNetwork,
365         ConversionRatesInterface _conversionRates,
366         SanityRatesInterface _sanityRates
367     )
368         public
369         onlyAdmin
370     {
371         require(_kyberNetwork != address(0));
372         require(_conversionRates != address(0));
373 
374         kyberNetwork = _kyberNetwork;
375         conversionRatesContract = _conversionRates;
376         sanityRatesContract = _sanityRates;
377 
378         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
379     }
380 
381     ////////////////////////////////////////////////////////////////////////////
382     /// status functions ///////////////////////////////////////////////////////
383     ////////////////////////////////////////////////////////////////////////////
384     function getBalance(ERC20 token) public view returns(uint) {
385         if (token == ETH_TOKEN_ADDRESS)
386             return this.balance;
387         else {
388             address wallet = tokenWallet[token];
389             uint balanceOfWallet = token.balanceOf(wallet);
390             uint allowanceOfWallet = token.allowance(wallet, this);
391 
392             return (balanceOfWallet < allowanceOfWallet) ? balanceOfWallet : allowanceOfWallet;
393         }
394     }
395 
396     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
397         uint dstDecimals = getDecimals(dest);
398         uint srcDecimals = getDecimals(src);
399 
400         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
401     }
402 
403     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
404         uint dstDecimals = getDecimals(dest);
405         uint srcDecimals = getDecimals(src);
406 
407         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
408     }
409 
410     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
411         ERC20 token;
412         bool  isBuy;
413 
414         if (!tradeEnabled) return 0;
415 
416         if (ETH_TOKEN_ADDRESS == src) {
417             isBuy = true;
418             token = dest;
419         } else if (ETH_TOKEN_ADDRESS == dest) {
420             isBuy = false;
421             token = src;
422         } else {
423             return 0; // pair is not listed
424         }
425 
426         uint rate = conversionRatesContract.getRate(token, blockNumber, isBuy, srcQty);
427         uint destQty = getDestQty(src, dest, srcQty, rate);
428 
429         if (getBalance(dest) < destQty) return 0;
430 
431         if (sanityRatesContract != address(0)) {
432             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
433             if (rate > sanityRate) return 0;
434         }
435 
436         return rate;
437     }
438 
439     /// @dev do a trade
440     /// @param srcToken Src token
441     /// @param srcAmount Amount of src token
442     /// @param destToken Destination token
443     /// @param destAddress Destination address to send tokens to
444     /// @param validate If true, additional validations are applicable
445     /// @return true iff trade is successful
446     function doTrade(
447         ERC20 srcToken,
448         uint srcAmount,
449         ERC20 destToken,
450         address destAddress,
451         uint conversionRate,
452         bool validate
453     )
454         internal
455         returns(bool)
456     {
457         // can skip validation if done at kyber network level
458         if (validate) {
459             require(conversionRate > 0);
460             if (srcToken == ETH_TOKEN_ADDRESS)
461                 require(msg.value == srcAmount);
462             else
463                 require(msg.value == 0);
464         }
465 
466         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
467         // sanity check
468         require(destAmount > 0);
469 
470         // add to imbalance
471         ERC20 token;
472         int tradeAmount;
473         if (srcToken == ETH_TOKEN_ADDRESS) {
474             tradeAmount = int(destAmount);
475             token = destToken;
476         } else {
477             tradeAmount = -1 * int(srcAmount);
478             token = srcToken;
479         }
480 
481         conversionRatesContract.recordImbalance(
482             token,
483             tradeAmount,
484             0,
485             block.number
486         );
487 
488         // collect src tokens
489         if (srcToken != ETH_TOKEN_ADDRESS) {
490             require(srcToken.transferFrom(msg.sender, tokenWallet[srcToken], srcAmount));
491         }
492 
493         // send dest tokens
494         if (destToken == ETH_TOKEN_ADDRESS) {
495             destAddress.transfer(destAmount);
496         } else {
497             require(destToken.transferFrom(tokenWallet[destToken], destAddress, destAmount));
498         }
499 
500         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
501 
502         return true;
503     }
504 }