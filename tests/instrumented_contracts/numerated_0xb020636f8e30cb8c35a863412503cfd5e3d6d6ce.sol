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
99 // File: contracts/Utils2.sol
100 
101 contract Utils2 is Utils {
102 
103     /// @dev get the balance of a user.
104     /// @param token The token type
105     /// @return The balance
106     function getBalance(ERC20 token, address user) public view returns(uint) {
107         if (token == ETH_TOKEN_ADDRESS)
108             return user.balance;
109         else
110             return token.balanceOf(user);
111     }
112 
113     function getDecimalsSafe(ERC20 token) internal returns(uint) {
114 
115         if (decimals[token] == 0) {
116             setDecimals(token);
117         }
118 
119         return decimals[token];
120     }
121 
122     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
123         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
124     }
125 
126     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
127         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
128     }
129 
130     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
131         internal pure returns(uint)
132     {
133         require(srcAmount <= MAX_QTY);
134         require(destAmount <= MAX_QTY);
135 
136         if (dstDecimals >= srcDecimals) {
137             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
138             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
139         } else {
140             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
141             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
142         }
143     }
144 }
145 
146 // File: contracts/PermissionGroups.sol
147 
148 contract PermissionGroups {
149 
150     address public admin;
151     address public pendingAdmin;
152     mapping(address=>bool) internal operators;
153     mapping(address=>bool) internal alerters;
154     address[] internal operatorsGroup;
155     address[] internal alertersGroup;
156     uint constant internal MAX_GROUP_SIZE = 50;
157 
158     function PermissionGroups() public {
159         admin = msg.sender;
160     }
161 
162     modifier onlyAdmin() {
163         require(msg.sender == admin);
164         _;
165     }
166 
167     modifier onlyOperator() {
168         require(operators[msg.sender]);
169         _;
170     }
171 
172     modifier onlyAlerter() {
173         require(alerters[msg.sender]);
174         _;
175     }
176 
177     function getOperators () external view returns(address[]) {
178         return operatorsGroup;
179     }
180 
181     function getAlerters () external view returns(address[]) {
182         return alertersGroup;
183     }
184 
185     event TransferAdminPending(address pendingAdmin);
186 
187     /**
188      * @dev Allows the current admin to set the pendingAdmin address.
189      * @param newAdmin The address to transfer ownership to.
190      */
191     function transferAdmin(address newAdmin) public onlyAdmin {
192         require(newAdmin != address(0));
193         TransferAdminPending(pendingAdmin);
194         pendingAdmin = newAdmin;
195     }
196 
197     /**
198      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
199      * @param newAdmin The address to transfer ownership to.
200      */
201     function transferAdminQuickly(address newAdmin) public onlyAdmin {
202         require(newAdmin != address(0));
203         TransferAdminPending(newAdmin);
204         AdminClaimed(newAdmin, admin);
205         admin = newAdmin;
206     }
207 
208     event AdminClaimed( address newAdmin, address previousAdmin);
209 
210     /**
211      * @dev Allows the pendingAdmin address to finalize the change admin process.
212      */
213     function claimAdmin() public {
214         require(pendingAdmin == msg.sender);
215         AdminClaimed(pendingAdmin, admin);
216         admin = pendingAdmin;
217         pendingAdmin = address(0);
218     }
219 
220     event AlerterAdded (address newAlerter, bool isAdd);
221 
222     function addAlerter(address newAlerter) public onlyAdmin {
223         require(!alerters[newAlerter]); // prevent duplicates.
224         require(alertersGroup.length < MAX_GROUP_SIZE);
225 
226         AlerterAdded(newAlerter, true);
227         alerters[newAlerter] = true;
228         alertersGroup.push(newAlerter);
229     }
230 
231     function removeAlerter (address alerter) public onlyAdmin {
232         require(alerters[alerter]);
233         alerters[alerter] = false;
234 
235         for (uint i = 0; i < alertersGroup.length; ++i) {
236             if (alertersGroup[i] == alerter) {
237                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
238                 alertersGroup.length--;
239                 AlerterAdded(alerter, false);
240                 break;
241             }
242         }
243     }
244 
245     event OperatorAdded(address newOperator, bool isAdd);
246 
247     function addOperator(address newOperator) public onlyAdmin {
248         require(!operators[newOperator]); // prevent duplicates.
249         require(operatorsGroup.length < MAX_GROUP_SIZE);
250 
251         OperatorAdded(newOperator, true);
252         operators[newOperator] = true;
253         operatorsGroup.push(newOperator);
254     }
255 
256     function removeOperator (address operator) public onlyAdmin {
257         require(operators[operator]);
258         operators[operator] = false;
259 
260         for (uint i = 0; i < operatorsGroup.length; ++i) {
261             if (operatorsGroup[i] == operator) {
262                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
263                 operatorsGroup.length -= 1;
264                 OperatorAdded(operator, false);
265                 break;
266             }
267         }
268     }
269 }
270 
271 // File: contracts/Withdrawable.sol
272 
273 /**
274  * @title Contracts that should be able to recover tokens or ethers
275  * @author Ilan Doron
276  * @dev This allows to recover any tokens or Ethers received in a contract.
277  * This will prevent any accidental loss of tokens.
278  */
279 contract Withdrawable is PermissionGroups {
280 
281     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
282 
283     /**
284      * @dev Withdraw all ERC20 compatible tokens
285      * @param token ERC20 The address of the token contract
286      */
287     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
288         require(token.transfer(sendTo, amount));
289         TokenWithdraw(token, amount, sendTo);
290     }
291 
292     event EtherWithdraw(uint amount, address sendTo);
293 
294     /**
295      * @dev Withdraw Ethers
296      */
297     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
298         sendTo.transfer(amount);
299         EtherWithdraw(amount, sendTo);
300     }
301 }
302 
303 // File: contracts/oasisContracts/KyberBancorReserve.sol
304 
305 contract IBancorConverter {
306     function getReturn(ERC20 _fromToken, ERC20 _toToken, uint _amount) public view returns (uint256, uint256);
307 }
308 
309 contract KyberBancorReserve is KyberReserveInterface, Withdrawable, Utils2 {
310 
311     address public sanityRatesContract = 0;
312     address public kyberNetwork;
313     IBancorConverter public bancor;
314     ERC20 public token;
315     ERC20 public constant BANCOR_ETH = ERC20(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);
316     bool public tradeEnabled;
317     int public premiumInBps;
318 
319     function KyberBancorReserve(
320         /*IBancorConverter _bancor,
321         address _kyberNetwork,
322         ERC20 _token,
323         address _admin,
324         int _PremiumBps*/
325     )
326         public
327     {
328     /*
329         require(_bancor != address(0));
330         require(_kyberNetwork != address(0));
331         require(_token != address(0));
332         require(_PremiumBps >= -10000);
333         require(_PremiumBps <= int(MAX_QTY));*/
334 
335         kyberNetwork = address(0x65897aDCBa42dcCA5DD162c647b1cC3E31238490);
336         bancor = IBancorConverter(0xb89570f6AD742CB1fd440A930D6c2A2eA29c51eE);
337         token = ERC20(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);
338         admin = address(0xd0643BC0D0C879F175556509dbcEe9373379D5C3);
339         premiumInBps = 0;
340 
341         setDecimals(token);
342         setDecimals(ETH_TOKEN_ADDRESS);
343     }
344 
345     function() public payable {
346         // anyone can deposit ether
347     }
348 
349     function setPremium(int newPremium) public onlyAdmin {
350         require(newPremium >= -10000);
351         require(newPremium <= int(MAX_QTY));
352 
353         premiumInBps = newPremium;
354     }
355 
356     event TradeExecute(
357         address indexed sender,
358         address src,
359         uint srcAmount,
360         address destToken,
361         uint destAmount,
362         address destAddress
363     );
364 
365     function trade(
366         ERC20 srcToken,
367         uint srcAmount,
368         ERC20 destToken,
369         address destAddress,
370         uint conversionRate,
371         bool validate
372     )
373         public
374         payable
375         returns(bool)
376     {
377 
378         require(tradeEnabled);
379         require(msg.sender == kyberNetwork);
380 
381         require(doTrade(srcToken, srcAmount, destToken, destAddress, conversionRate, validate));
382 
383         return true;
384     }
385 
386     event TradeEnabled(bool enable);
387 
388     function enableTrade() public onlyAdmin returns(bool) {
389         tradeEnabled = true;
390         TradeEnabled(true);
391 
392         return true;
393     }
394 
395     function disableTrade() public onlyAlerter returns(bool) {
396         tradeEnabled = false;
397         TradeEnabled(false);
398 
399         return true;
400     }
401 
402     event KyberNetworkSet(address kyberNetwork);
403 
404     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
405         require(_kyberNetwork != address(0));
406 
407         kyberNetwork = _kyberNetwork;
408         KyberNetworkSet(kyberNetwork);
409     }
410 
411     function valueAfterAddingPremium(uint val) public view returns(uint) {
412         require(val <= MAX_QTY);
413 
414         return val * uint(10000 + premiumInBps) / 10000;
415     }
416     function shouldUseInternalInventory(uint val,
417                                         ERC20 dest) public view returns(bool) {
418         if (dest == token) {
419             return val <= token.balanceOf(this);
420         }
421         else {
422             return val <= this.balance;
423         }
424     }
425 
426     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) public view returns(uint) {
427         uint  expectedReturn;
428         ERC20 actualSrc;
429         ERC20 actualDest;
430 
431         blockNumber;
432 
433         if (!tradeEnabled) return 0;
434         if (!validTokens(src, dest)) return 0;
435 
436         if (src == ETH_TOKEN_ADDRESS) {
437             actualSrc = BANCOR_ETH;
438             actualDest = dest;
439         } else if (dest == ETH_TOKEN_ADDRESS) {
440             actualSrc = src;
441             actualDest = BANCOR_ETH;
442         } else {
443             return 0;
444         }
445 
446         // zelda
447         (expectedReturn,) = bancor.getReturn(actualSrc, actualDest, srcQty);
448         expectedReturn = valueAfterAddingPremium(expectedReturn);
449 
450         if(! shouldUseInternalInventory(expectedReturn,dest)) return 0;
451         else return calcRateFromQty(srcQty, expectedReturn, getDecimals(src), getDecimals(dest));
452     }
453 
454     function doTrade(
455         ERC20 srcToken,
456         uint srcAmount,
457         ERC20 destToken,
458         address destAddress,
459         uint conversionRate,
460         bool validate
461     )
462         internal
463         returns(bool)
464     {
465         require(validTokens(srcToken, destToken));
466 
467         // can skip validation if done at kyber network level
468         if (validate) {
469             require(conversionRate > 0);
470             if (srcToken == ETH_TOKEN_ADDRESS)
471                 require(msg.value == srcAmount);
472             else
473                 require(msg.value == 0);
474         }
475 
476         uint userExpectedDestAmount = calcDstQty(srcAmount, getDecimals(srcToken), getDecimals(destToken), conversionRate);
477         if(destToken == ETH_TOKEN_ADDRESS) destAddress.transfer(userExpectedDestAmount);
478         else require(destToken.transfer(destAddress, userExpectedDestAmount));
479 
480         TradeExecute(msg.sender, srcToken, srcAmount, destToken, userExpectedDestAmount, destAddress);
481 
482         return true;
483     }
484 
485     function validTokens(ERC20 src, ERC20 dest) internal view returns (bool valid) {
486         return ((token == src && ETH_TOKEN_ADDRESS == dest) ||
487                 (token == dest && ETH_TOKEN_ADDRESS == src));
488     }
489 }