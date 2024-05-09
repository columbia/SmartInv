1 pragma solidity 0.4.18;
2 
3 contract Utils {
4 
5     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
6     uint  constant internal PRECISION = (10**18);
7     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
8     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
9     uint  constant internal MAX_DECIMALS = 18;
10     uint  constant internal ETH_DECIMALS = 18;
11     mapping(address=>uint) internal decimals;
12 
13     function setDecimals(ERC20 token) internal {
14         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
15         else decimals[token] = token.decimals();
16     }
17 
18     function getDecimals(ERC20 token) internal view returns(uint) {
19         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
20         uint tokenDecimals = decimals[token];
21         // technically, there might be token with decimals 0
22         // moreover, very possible that old tokens have decimals 0
23         // these tokens will just have higher gas fees.
24         if(tokenDecimals == 0) return token.decimals();
25 
26         return tokenDecimals;
27     }
28 
29     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
30         require(srcQty <= MAX_QTY);
31         require(rate <= MAX_RATE);
32 
33         if (dstDecimals >= srcDecimals) {
34             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
35             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
36         } else {
37             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
38             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
39         }
40     }
41 
42     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
43         require(dstQty <= MAX_QTY);
44         require(rate <= MAX_RATE);
45 
46         //source quantity is rounded up. to avoid dest quantity being too low.
47         uint numerator;
48         uint denominator;
49         if (srcDecimals >= dstDecimals) {
50             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
51             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
52             denominator = rate;
53         } else {
54             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
55             numerator = (PRECISION * dstQty);
56             denominator = (rate * (10**(dstDecimals - srcDecimals)));
57         }
58         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
59     }
60 }
61 
62 contract PermissionGroups {
63 
64     address public admin;
65     address public pendingAdmin;
66     mapping(address=>bool) internal operators;
67     mapping(address=>bool) internal alerters;
68     address[] internal operatorsGroup;
69     address[] internal alertersGroup;
70     uint constant internal MAX_GROUP_SIZE = 50;
71 
72     function PermissionGroups() public {
73         admin = msg.sender;
74     }
75 
76     modifier onlyAdmin() {
77         require(msg.sender == admin);
78         _;
79     }
80 
81     modifier onlyOperator() {
82         require(operators[msg.sender]);
83         _;
84     }
85 
86     modifier onlyAlerter() {
87         require(alerters[msg.sender]);
88         _;
89     }
90 
91     function getOperators () external view returns(address[]) {
92         return operatorsGroup;
93     }
94 
95     function getAlerters () external view returns(address[]) {
96         return alertersGroup;
97     }
98 
99     event TransferAdminPending(address pendingAdmin);
100 
101     /**
102      * @dev Allows the current admin to set the pendingAdmin address.
103      * @param newAdmin The address to transfer ownership to.
104      */
105     function transferAdmin(address newAdmin) public onlyAdmin {
106         require(newAdmin != address(0));
107         TransferAdminPending(pendingAdmin);
108         pendingAdmin = newAdmin;
109     }
110 
111     /**
112      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
113      * @param newAdmin The address to transfer ownership to.
114      */
115     function transferAdminQuickly(address newAdmin) public onlyAdmin {
116         require(newAdmin != address(0));
117         TransferAdminPending(newAdmin);
118         AdminClaimed(newAdmin, admin);
119         admin = newAdmin;
120     }
121 
122     event AdminClaimed( address newAdmin, address previousAdmin);
123 
124     /**
125      * @dev Allows the pendingAdmin address to finalize the change admin process.
126      */
127     function claimAdmin() public {
128         require(pendingAdmin == msg.sender);
129         AdminClaimed(pendingAdmin, admin);
130         admin = pendingAdmin;
131         pendingAdmin = address(0);
132     }
133 
134     event AlerterAdded (address newAlerter, bool isAdd);
135 
136     function addAlerter(address newAlerter) public onlyAdmin {
137         require(!alerters[newAlerter]); // prevent duplicates.
138         require(alertersGroup.length < MAX_GROUP_SIZE);
139 
140         AlerterAdded(newAlerter, true);
141         alerters[newAlerter] = true;
142         alertersGroup.push(newAlerter);
143     }
144 
145     function removeAlerter (address alerter) public onlyAdmin {
146         require(alerters[alerter]);
147         alerters[alerter] = false;
148 
149         for (uint i = 0; i < alertersGroup.length; ++i) {
150             if (alertersGroup[i] == alerter) {
151                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
152                 alertersGroup.length--;
153                 AlerterAdded(alerter, false);
154                 break;
155             }
156         }
157     }
158 
159     event OperatorAdded(address newOperator, bool isAdd);
160 
161     function addOperator(address newOperator) public onlyAdmin {
162         require(!operators[newOperator]); // prevent duplicates.
163         require(operatorsGroup.length < MAX_GROUP_SIZE);
164 
165         OperatorAdded(newOperator, true);
166         operators[newOperator] = true;
167         operatorsGroup.push(newOperator);
168     }
169 
170     function removeOperator (address operator) public onlyAdmin {
171         require(operators[operator]);
172         operators[operator] = false;
173 
174         for (uint i = 0; i < operatorsGroup.length; ++i) {
175             if (operatorsGroup[i] == operator) {
176                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
177                 operatorsGroup.length -= 1;
178                 OperatorAdded(operator, false);
179                 break;
180             }
181         }
182     }
183 }
184 
185 interface ConversionRatesInterface {
186 
187     function recordImbalance(
188         ERC20 token,
189         int buyAmount,
190         uint rateUpdateBlock,
191         uint currentBlock
192     )
193         public;
194 
195     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
196 }
197 
198 interface ERC20 {
199     function totalSupply() public view returns (uint supply);
200     function balanceOf(address _owner) public view returns (uint balance);
201     function transfer(address _to, uint _value) public returns (bool success);
202     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
203     function approve(address _spender, uint _value) public returns (bool success);
204     function allowance(address _owner, address _spender) public view returns (uint remaining);
205     function decimals() public view returns(uint digits);
206     event Approval(address indexed _owner, address indexed _spender, uint _value);
207 }
208 
209 interface KyberReserveInterface {
210 
211     function trade(
212         ERC20 srcToken,
213         uint srcAmount,
214         ERC20 destToken,
215         address destAddress,
216         uint conversionRate,
217         bool validate
218     )
219         public
220         payable
221         returns(bool);
222 
223     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint);
224 }
225 
226 interface SanityRatesInterface {
227     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
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
261 
262     function KyberReserve(address _kyberNetwork, ConversionRatesInterface _ratesContract, address _admin) public {
263         require(_admin != address(0));
264         require(_ratesContract != address(0));
265         require(_kyberNetwork != address(0));
266         kyberNetwork = _kyberNetwork;
267         conversionRatesContract = _ratesContract;
268         admin = _admin;
269         tradeEnabled = true;
270     }
271 
272     event DepositToken(ERC20 token, uint amount);
273 
274     function() public payable {
275         DepositToken(ETH_TOKEN_ADDRESS, msg.value);
276     }
277 
278     event TradeExecute(
279         address indexed origin,
280         address src,
281         uint srcAmount,
282         address destToken,
283         uint destAmount,
284         address destAddress
285     );
286 
287     function trade(
288         ERC20 srcToken,
289         uint srcAmount,
290         ERC20 destToken,
291         address destAddress,
292         uint conversionRate,
293         bool validate
294     )
295         public
296         payable
297         returns(bool)
298     {
299         require(tradeEnabled);
300         require(msg.sender == kyberNetwork);
301 
302         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
303 
304         return true;
305     }
306 
307     event TradeEnabled(bool enable);
308 
309     function enableTrade() public onlyAdmin returns(bool) {
310         tradeEnabled = true;
311         TradeEnabled(true);
312 
313         return true;
314     }
315 
316     function disableTrade() public onlyAlerter returns(bool) {
317         tradeEnabled = false;
318         TradeEnabled(false);
319 
320         return true;
321     }
322 
323     event WithdrawAddressApproved(ERC20 token, address addr, bool approve);
324 
325     function approveWithdrawAddress(ERC20 token, address addr, bool approve) public onlyAdmin {
326         approvedWithdrawAddresses[keccak256(token, addr)] = approve;
327         WithdrawAddressApproved(token, addr, approve);
328 
329         setDecimals(token);
330     }
331 
332     event WithdrawFunds(ERC20 token, uint amount, address destination);
333 
334     function withdraw(ERC20 token, uint amount, address destination) public onlyOperator returns(bool) {
335         require(approvedWithdrawAddresses[keccak256(token, destination)]);
336 
337         if (token == ETH_TOKEN_ADDRESS) {
338             destination.transfer(amount);
339         } else {
340             require(token.transfer(destination, amount));
341         }
342 
343         WithdrawFunds(token, amount, destination);
344 
345         return true;
346     }
347 
348     event SetContractAddresses(address network, address rate, address sanity);
349 
350     function setContracts(address _kyberNetwork, ConversionRatesInterface _conversionRates, SanityRatesInterface _sanityRates)
351         public
352         onlyAdmin
353     {
354         require(_kyberNetwork != address(0));
355         require(_conversionRates != address(0));
356 
357         kyberNetwork = _kyberNetwork;
358         conversionRatesContract = _conversionRates;
359         sanityRatesContract = _sanityRates;
360 
361         SetContractAddresses(kyberNetwork, conversionRatesContract, sanityRatesContract);
362     }
363 
364     ////////////////////////////////////////////////////////////////////////////
365     /// status functions ///////////////////////////////////////////////////////
366     ////////////////////////////////////////////////////////////////////////////
367     function getBalance(ERC20 token) public view returns(uint) {
368         if (token == ETH_TOKEN_ADDRESS)
369             return this.balance;
370         else
371             return token.balanceOf(this);
372     }
373 
374     function getDestQty(ERC20 src, ERC20 dest, uint srcQty, uint rate) public view returns(uint) {
375         uint dstDecimals = getDecimals(dest);
376         uint srcDecimals = getDecimals(src);
377 
378         return calcDstQty(srcQty, srcDecimals, dstDecimals, rate);
379     }
380 
381     function getSrcQty(ERC20 src, ERC20 dest, uint dstQty, uint rate) public view returns(uint) {
382         uint dstDecimals = getDecimals(dest);
383         uint srcDecimals = getDecimals(src);
384 
385         return calcSrcQty(dstQty, srcDecimals, dstDecimals, rate);
386     }
387 
388     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
389         ERC20 token;
390         bool  buy;
391 
392         if (!tradeEnabled) return 0;
393 
394         if (ETH_TOKEN_ADDRESS == src) {
395             buy = true;
396             token = dest;
397         } else if (ETH_TOKEN_ADDRESS == dest) {
398             buy = false;
399             token = src;
400         } else {
401             return 0; // pair is not listed
402         }
403 
404         uint rate = conversionRatesContract.getRate(token, blockNumber, buy, srcQty);
405         uint destQty = getDestQty(src, dest, srcQty, rate);
406 
407         if (getBalance(dest) < destQty) return 0;
408 
409         if (sanityRatesContract != address(0)) {
410             uint sanityRate = sanityRatesContract.getSanityRate(src, dest);
411             if (rate > sanityRate) return 0;
412         }
413 
414         return rate;
415     }
416 
417     /// @dev do a trade
418     /// @param srcToken Src token
419     /// @param srcAmount Amount of src token
420     /// @param destToken Destination token
421     /// @param destAddress Destination address to send tokens to
422     /// @param validate If true, additional validations are applicable
423     /// @return true iff trade is successful
424     function doTrade(
425         ERC20 srcToken,
426         uint srcAmount,
427         ERC20 destToken,
428         address destAddress,
429         uint conversionRate,
430         bool validate
431     )
432         internal
433         returns(bool)
434     {
435         // can skip validation if done at kyber network level
436         if (validate) {
437             require(conversionRate > 0);
438             if (srcToken == ETH_TOKEN_ADDRESS)
439                 require(msg.value == srcAmount);
440             else
441                 require(msg.value == 0);
442         }
443 
444         uint destAmount = getDestQty(srcToken, destToken, srcAmount, conversionRate);
445         // sanity check
446         require(destAmount > 0);
447 
448         // add to imbalance
449         ERC20 token;
450         int buy;
451         if (srcToken == ETH_TOKEN_ADDRESS) {
452             buy = int(destAmount);
453             token = destToken;
454         } else {
455             buy = -1 * int(srcAmount);
456             token = srcToken;
457         }
458 
459         conversionRatesContract.recordImbalance(
460             token,
461             buy,
462             0,
463             block.number
464         );
465 
466         // collect src tokens
467         if (srcToken != ETH_TOKEN_ADDRESS) {
468             require(srcToken.transferFrom(msg.sender, this, srcAmount));
469         }
470 
471         // send dest tokens
472         if (destToken == ETH_TOKEN_ADDRESS) {
473             destAddress.transfer(destAmount);
474         } else {
475             require(destToken.transfer(destAddress, destAmount));
476         }
477 
478         TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
479 
480         return true;
481     }
482 }