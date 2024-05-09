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
16 contract PermissionGroups {
17 
18     address public admin;
19     address public pendingAdmin;
20     mapping(address=>bool) internal operators;
21     mapping(address=>bool) internal alerters;
22     address[] internal operatorsGroup;
23     address[] internal alertersGroup;
24 
25     function PermissionGroups() public {
26         admin = msg.sender;
27     }
28 
29     modifier onlyAdmin() {
30         require(msg.sender == admin);
31         _;
32     }
33 
34     modifier onlyOperator() {
35         require(operators[msg.sender]);
36         _;
37     }
38 
39     modifier onlyAlerter() {
40         require(alerters[msg.sender]);
41         _;
42     }
43 
44     function getOperators () external view returns(address[]) {
45         return operatorsGroup;
46     }
47 
48     function getAlerters () external view returns(address[]) {
49         return alertersGroup;
50     }
51 
52     event TransferAdminPending(address pendingAdmin);
53 
54     /**
55      * @dev Allows the current admin to set the pendingAdmin address.
56      * @param newAdmin The address to transfer ownership to.
57      */
58     function transferAdmin(address newAdmin) public onlyAdmin {
59         require(newAdmin != address(0));
60         TransferAdminPending(pendingAdmin);
61         pendingAdmin = newAdmin;
62     }
63 
64     event AdminClaimed( address newAdmin, address previousAdmin);
65 
66     /**
67      * @dev Allows the pendingAdmin address to finalize the change admin process.
68      */
69     function claimAdmin() public {
70         require(pendingAdmin == msg.sender);
71         AdminClaimed(pendingAdmin, admin);
72         admin = pendingAdmin;
73         pendingAdmin = address(0);
74     }
75 
76     event AlerterAdded (address newAlerter, bool isAdd);
77 
78     function addAlerter(address newAlerter) public onlyAdmin {
79         require(!alerters[newAlerter]); // prevent duplicates.
80         AlerterAdded(newAlerter, true);
81         alerters[newAlerter] = true;
82         alertersGroup.push(newAlerter);
83     }
84 
85     function removeAlerter (address alerter) public onlyAdmin {
86         require(alerters[alerter]);
87         alerters[alerter] = false;
88 
89         for (uint i = 0; i < alertersGroup.length; ++i) {
90             if (alertersGroup[i] == alerter) {
91                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
92                 alertersGroup.length--;
93                 AlerterAdded(alerter, false);
94                 break;
95             }
96         }
97     }
98 
99     event OperatorAdded(address newOperator, bool isAdd);
100 
101     function addOperator(address newOperator) public onlyAdmin {
102         require(!operators[newOperator]); // prevent duplicates.
103         OperatorAdded(newOperator, true);
104         operators[newOperator] = true;
105         operatorsGroup.push(newOperator);
106     }
107 
108     function removeOperator (address operator) public onlyAdmin {
109         require(operators[operator]);
110         operators[operator] = false;
111 
112         for (uint i = 0; i < operatorsGroup.length; ++i) {
113             if (operatorsGroup[i] == operator) {
114                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
115                 operatorsGroup.length -= 1;
116                 OperatorAdded(operator, false);
117                 break;
118             }
119         }
120     }
121 }
122 
123 interface KyberReserveInterface {
124 
125     function trade(
126         ERC20 srcToken,
127         uint srcAmount,
128         ERC20 destToken,
129         address destAddress,
130         uint conversionRate,
131         bool validate
132     )
133         public
134         payable
135         returns(bool);
136 
137     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
138 }
139 
140 contract Utils {
141 
142     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
143     uint  constant internal PRECISION = (10**18);
144     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
145     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
146     uint  constant internal MAX_DECIMALS = 18;
147     uint  constant internal ETH_DECIMALS = 18;
148     mapping(address=>uint) internal decimals;
149 
150     function setDecimals(ERC20 token) internal {
151         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
152         else decimals[token] = token.decimals();
153     }
154 
155     function getDecimals(ERC20 token) internal view returns(uint) {
156         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
157         uint tokenDecimals = decimals[token];
158         // technically, there might be token with decimals 0
159         // moreover, very possible that old tokens have decimals 0
160         // these tokens will just have higher gas fees.
161         if(tokenDecimals == 0) return token.decimals();
162 
163         return tokenDecimals;
164     }
165 
166     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
167         require(srcQty <= MAX_QTY);
168         require(rate <= MAX_RATE);
169 
170         if (dstDecimals >= srcDecimals) {
171             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
172             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
173         } else {
174             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
175             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
176         }
177     }
178 
179     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
180         require(dstQty <= MAX_QTY);
181         require(rate <= MAX_RATE);
182 
183         //source quantity is rounded up. to avoid dest quantity being too low.
184         uint numerator;
185         uint denominator;
186         if (srcDecimals >= dstDecimals) {
187             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
188             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
189             denominator = rate;
190         } else {
191             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
192             numerator = (PRECISION * dstQty);
193             denominator = (rate * (10**(dstDecimals - srcDecimals)));
194         }
195         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
196     }
197 }
198 
199 interface SanityRatesInterface {
200     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
201 }
202 
203 contract Withdrawable is PermissionGroups {
204 
205     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
206 
207     /**
208      * @dev Withdraw all ERC20 compatible tokens
209      * @param token ERC20 The address of the token contract
210      */
211     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
212         require(token.transfer(sendTo, amount));
213         TokenWithdraw(token, amount, sendTo);
214     }
215 
216     event EtherWithdraw(uint amount, address sendTo);
217 
218     /**
219      * @dev Withdraw Ethers
220      */
221     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
222         sendTo.transfer(amount);
223         EtherWithdraw(amount, sendTo);
224     }
225 }
226 
227 contract KyberReserve is KyberReserveInterface, Withdrawable, Utils {
228 
229     address public kyberNetwork;
230     bool public tradeEnabled;
231     ConversionRatesInterface public conversionRatesContract;
232     SanityRatesInterface public sanityRatesContract;
233     mapping(bytes32=>bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
234 
235     function KyberReserve(address _kyberNetwork, ConversionRatesInterface _ratesContract, address _admin) public {
236         require(_admin != address(0));
237         require(_ratesContract != address(0));
238         require(_kyberNetwork != address(0));
239         kyberNetwork = _kyberNetwork;
240         conversionRatesContract = _ratesContract;
241         admin = _admin;
242         tradeEnabled = true;
243     }
244 
245     event DepositToken(ERC20 token, uint amount);
246 
247     function() public payable {
248         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
249     }
250 
251     event TradeExecute(
252         address indexed origin,
253         address src,
254         uint srcAmount,
255         address destToken,
256         uint destAmount,
257         address destAddress
258     );
259 
260     function trade(
261         ERC20 srcToken,
262         uint srcAmount,
263         ERC20 destToken,
264         address destAddress,
265         uint conversionRate,
266         bool validate
267     )
268         public
269         payable
270         returns(bool)
271     {
272         require(tradeEnabled);
273         require(msg.sender == kyberNetwork);
274 
275         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
276 
277         return true;
278     }
279 
280     event TradeEnabled(bool enable);
281 
282     function enableTrade() public onlyAdmin returns(bool) {
283         tradeEnabled = true;
284         TradeEnabled(true);
285 
286         return true;
287     }
288 
289     function disableTrade() public onlyAlerter returns(bool) {
290         tradeEnabled = false;
291         TradeEnabled(false);
292 
293         return true;
294     }
295 
296     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
297 
298     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
299         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
300         WithdrawAddressApproved(token, addr, approve);
301 
302         setDecimals(token);
303     }
304 
305     event WithdrawFunds(ERC20 token, uint amount, address destination);
306 
307     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
308         require(approvedWithdrawAddresses[keccak256(token, destination)]);
309 
310         if (token == ETH_TOKEN_ADDRESS) {
311             destination.transfer(amount);
312         } else {
313             require(token.transfer(destination, amount));
314         }
315 
316         WithdrawFunds(token, amount, destination);
317 
318         return true;
319     }
320 
321     event SetContractAddresses(address network, address rate, address sanity);
322 
323     function setContracts(address _kyberNetwork, ConversionRatesInterface _conversionRates, SanityRatesInterface _sanityRates)
324         public
325         onlyAdmin
326     {
327         require(_kyberNetwork != address(0));
328         require(_conversionRates != address(0));
329 
330         kyberNetwork = _kyberNetwork;
331         conversionRatesContract = _conversionRates;
332         sanityRatesContract = _sanityRates;
333 
334         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
335     }
336 
337     ////////////////////////////////////////////////////////////////////////////
338     /// status functions ///////////////////////////////////////////////////////
339     ////////////////////////////////////////////////////////////////////////////
340     function getBalance(ERC20 token) public view returns(uint) {
341         if (token == ETH_TOKEN_ADDRESS)
342             return this.balance;
343         else
344             return token.balanceOf(this);
345     }
346 
347     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
348         uint dstDecimals = getDecimals(dest);
349         uint srcDecimals = getDecimals(src);
350 
351         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
352     }
353 
354     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
355         uint dstDecimals = getDecimals(dest);
356         uint srcDecimals = getDecimals(src);
357 
358         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
359     }
360 
361     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
362         ERC20 token;
363         bool  buy;
364 
365         if (!tradeEnabled) return 0;
366 
367         if (ETH_TOKEN_ADDRESS == src) {
368             buy = true;
369             token = dest;
370         } else if (ETH_TOKEN_ADDRESS == dest) {
371             buy = false;
372             token = src;
373         } else {
374             return 0; // pair is not listed
375         }
376 
377         uint rate = conversionRatesContract.getRate(token, blockNumber, buy, srcQty);
378         uint destQty = getDestQty(src, dest, srcQty, rate);
379 
380         if (getBalance(dest) < destQty) return 0;
381 
382         if (sanityRatesContract != address(0)) {
383             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
384             if (rate > sanityRate) return 0;
385         }
386 
387         return rate;
388     }
389 
390     /// @dev do a trade
391     /// @param srcToken Src token
392     /// @param srcAmount Amount of src token
393     /// @param destToken Destination token
394     /// @param destAddress Destination address to send tokens to
395     /// @param validate If true, additional validations are applicable
396     /// @return true iff trade is successful
397     function doTrade(
398         ERC20 srcToken,
399         uint srcAmount,
400         ERC20 destToken,
401         address destAddress,
402         uint conversionRate,
403         bool validate
404     )
405         internal
406         returns(bool)
407     {
408         // can skip validation if done at kyber network level
409         if (validate) {
410             require(conversionRate > 0);
411             if (srcToken == ETH_TOKEN_ADDRESS)
412                 require(msg.value == srcAmount);
413             else
414                 require(msg.value == 0);
415         }
416 
417         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
418         // sanity check
419         require(destAmount > 0);
420 
421         // add to imbalance
422         ERC20 token;
423         int buy;
424         if (srcToken == ETH_TOKEN_ADDRESS) {
425             buy = int(destAmount);
426             token = destToken;
427         } else {
428             buy = -1 * int(srcAmount);
429             token = srcToken;
430         }
431 
432         conversionRatesContract.recordImbalance(
433             token,
434             buy,
435             0,
436             block.number
437         );
438 
439         // collect src tokens
440         if (srcToken != ETH_TOKEN_ADDRESS) {
441             require(srcToken.transferFrom(msg.sender, this, srcAmount));
442         }
443 
444         // send dest tokens
445         if (destToken == ETH_TOKEN_ADDRESS) {
446             destAddress.transfer(destAmount);
447         } else {
448             require(destToken.transfer(destAddress, destAmount));
449         }
450 
451         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
452 
453         return true;
454     }
455 }
456 
457 interface ERC20 {
458     function totalSupply() public view returns (uint supply);
459     function balanceOf(address _owner) public view returns (uint balance);
460     function transfer(address _to, uint _value) public returns (bool success);
461     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
462     function approve(address _spender, uint _value) public returns (bool success);
463     function allowance(address _owner, address _spender) public view returns (uint remaining);
464     function decimals() public view returns(uint digits);
465     event Approval(address indexed _owner, address indexed _spender, uint _value);
466 }