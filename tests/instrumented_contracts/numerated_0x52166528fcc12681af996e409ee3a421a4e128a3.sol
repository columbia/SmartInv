1 pragma solidity 0.4.18;
2 
3 // File: contracts/FeeBurnerInterface.sol
4 
5 interface FeeBurnerInterface {
6     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
7     function setReserveData(address reserve, uint feesInBps, address kncWallet) public;
8 }
9 
10 // File: contracts/ERC20Interface.sol
11 
12 // https://github.com/ethereum/EIPs/issues/20
13 interface ERC20 {
14     function totalSupply() public view returns (uint supply);
15     function balanceOf(address _owner) public view returns (uint balance);
16     function transfer(address _to, uint _value) public returns (bool success);
17     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
18     function approve(address _spender, uint _value) public returns (bool success);
19     function allowance(address _owner, address _spender) public view returns (uint remaining);
20     function decimals() public view returns(uint digits);
21     event Approval(address indexed _owner, address indexed _spender, uint _value);
22 }
23 
24 // File: contracts/PermissionGroups.sol
25 
26 contract PermissionGroups {
27 
28     address public admin;
29     address public pendingAdmin;
30     mapping(address=>bool) internal operators;
31     mapping(address=>bool) internal alerters;
32     address[] internal operatorsGroup;
33     address[] internal alertersGroup;
34     uint constant internal MAX_GROUP_SIZE = 50;
35 
36     function PermissionGroups() public {
37         admin = msg.sender;
38     }
39 
40     modifier onlyAdmin() {
41         require(msg.sender == admin);
42         _;
43     }
44 
45     modifier onlyOperator() {
46         require(operators[msg.sender]);
47         _;
48     }
49 
50     modifier onlyAlerter() {
51         require(alerters[msg.sender]);
52         _;
53     }
54 
55     function getOperators () external view returns(address[]) {
56         return operatorsGroup;
57     }
58 
59     function getAlerters () external view returns(address[]) {
60         return alertersGroup;
61     }
62 
63     event TransferAdminPending(address pendingAdmin);
64 
65     /**
66      * @dev Allows the current admin to set the pendingAdmin address.
67      * @param newAdmin The address to transfer ownership to.
68      */
69     function transferAdmin(address newAdmin) public onlyAdmin {
70         require(newAdmin != address(0));
71         TransferAdminPending(pendingAdmin);
72         pendingAdmin = newAdmin;
73     }
74 
75     /**
76      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
77      * @param newAdmin The address to transfer ownership to.
78      */
79     function transferAdminQuickly(address newAdmin) public onlyAdmin {
80         require(newAdmin != address(0));
81         TransferAdminPending(newAdmin);
82         AdminClaimed(newAdmin, admin);
83         admin = newAdmin;
84     }
85 
86     event AdminClaimed( address newAdmin, address previousAdmin);
87 
88     /**
89      * @dev Allows the pendingAdmin address to finalize the change admin process.
90      */
91     function claimAdmin() public {
92         require(pendingAdmin == msg.sender);
93         AdminClaimed(pendingAdmin, admin);
94         admin = pendingAdmin;
95         pendingAdmin = address(0);
96     }
97 
98     event AlerterAdded (address newAlerter, bool isAdd);
99 
100     function addAlerter(address newAlerter) public onlyAdmin {
101         require(!alerters[newAlerter]); // prevent duplicates.
102         require(alertersGroup.length < MAX_GROUP_SIZE);
103 
104         AlerterAdded(newAlerter, true);
105         alerters[newAlerter] = true;
106         alertersGroup.push(newAlerter);
107     }
108 
109     function removeAlerter (address alerter) public onlyAdmin {
110         require(alerters[alerter]);
111         alerters[alerter] = false;
112 
113         for (uint i = 0; i < alertersGroup.length; ++i) {
114             if (alertersGroup[i] == alerter) {
115                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
116                 alertersGroup.length--;
117                 AlerterAdded(alerter, false);
118                 break;
119             }
120         }
121     }
122 
123     event OperatorAdded(address newOperator, bool isAdd);
124 
125     function addOperator(address newOperator) public onlyAdmin {
126         require(!operators[newOperator]); // prevent duplicates.
127         require(operatorsGroup.length < MAX_GROUP_SIZE);
128 
129         OperatorAdded(newOperator, true);
130         operators[newOperator] = true;
131         operatorsGroup.push(newOperator);
132     }
133 
134     function removeOperator (address operator) public onlyAdmin {
135         require(operators[operator]);
136         operators[operator] = false;
137 
138         for (uint i = 0; i < operatorsGroup.length; ++i) {
139             if (operatorsGroup[i] == operator) {
140                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
141                 operatorsGroup.length -= 1;
142                 OperatorAdded(operator, false);
143                 break;
144             }
145         }
146     }
147 }
148 
149 // File: contracts/Withdrawable.sol
150 
151 /**
152  * @title Contracts that should be able to recover tokens or ethers
153  * @author Ilan Doron
154  * @dev This allows to recover any tokens or Ethers received in a contract.
155  * This will prevent any accidental loss of tokens.
156  */
157 contract Withdrawable is PermissionGroups {
158 
159     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
160 
161     /**
162      * @dev Withdraw all ERC20 compatible tokens
163      * @param token ERC20 The address of the token contract
164      */
165     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
166         require(token.transfer(sendTo, amount));
167         TokenWithdraw(token, amount, sendTo);
168     }
169 
170     event EtherWithdraw(uint amount, address sendTo);
171 
172     /**
173      * @dev Withdraw Ethers
174      */
175     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
176         sendTo.transfer(amount);
177         EtherWithdraw(amount, sendTo);
178     }
179 }
180 
181 // File: contracts/Utils.sol
182 
183 /// @title Kyber constants contract
184 contract Utils {
185 
186     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
187     uint  constant internal PRECISION = (10**18);
188     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
189     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
190     uint  constant internal MAX_DECIMALS = 18;
191     uint  constant internal ETH_DECIMALS = 18;
192     mapping(address=>uint) internal decimals;
193 
194     function setDecimals(ERC20 token) internal {
195         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
196         else decimals[token] = token.decimals();
197     }
198 
199     function getDecimals(ERC20 token) internal view returns(uint) {
200         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
201         uint tokenDecimals = decimals[token];
202         // technically, there might be token with decimals 0
203         // moreover, very possible that old tokens have decimals 0
204         // these tokens will just have higher gas fees.
205         if(tokenDecimals == 0) return token.decimals();
206 
207         return tokenDecimals;
208     }
209 
210     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
211         require(srcQty <= MAX_QTY);
212         require(rate <= MAX_RATE);
213 
214         if (dstDecimals >= srcDecimals) {
215             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
216             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
217         } else {
218             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
219             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
220         }
221     }
222 
223     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
224         require(dstQty <= MAX_QTY);
225         require(rate <= MAX_RATE);
226         
227         //source quantity is rounded up. to avoid dest quantity being too low.
228         uint numerator;
229         uint denominator;
230         if (srcDecimals >= dstDecimals) {
231             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
232             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
233             denominator = rate;
234         } else {
235             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
236             numerator = (PRECISION * dstQty);
237             denominator = (rate * (10**(dstDecimals - srcDecimals)));
238         }
239         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
240     }
241 }
242 
243 // File: contracts/Utils2.sol
244 
245 contract Utils2 is Utils {
246 
247     /// @dev get the balance of a user.
248     /// @param token The token type
249     /// @return The balance
250     function getBalance(ERC20 token, address user) public view returns(uint) {
251         if (token == ETH_TOKEN_ADDRESS)
252             return user.balance;
253         else
254             return token.balanceOf(user);
255     }
256 
257     function getDecimalsSafe(ERC20 token) internal returns(uint) {
258 
259         if (decimals[token] == 0) {
260             setDecimals(token);
261         }
262 
263         return decimals[token];
264     }
265 
266     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns(uint) {
267         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
268     }
269 
270     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns(uint) {
271         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
272     }
273 
274     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
275         internal pure returns(uint)
276     {
277         require(srcAmount <= MAX_QTY);
278         require(destAmount <= MAX_QTY);
279 
280         if (dstDecimals >= srcDecimals) {
281             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
282             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
283         } else {
284             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
285             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
286         }
287     }
288 }
289 
290 // File: contracts/KyberNetworkInterface.sol
291 
292 /// @title Kyber Network interface
293 interface KyberNetworkInterface {
294     function maxGasPrice() public view returns(uint);
295     function getUserCapInWei(address user) public view returns(uint);
296     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
297     function enabled() public view returns(bool);
298     function info(bytes32 id) public view returns(uint);
299 
300     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
301         returns (uint expectedRate, uint slippageRate);
302 
303     function tradeWithHint(address trader, ERC20 src, uint srcAmount, ERC20 dest, address destAddress,
304         uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
305 }
306 
307 // File: contracts/FeeBurner.sol
308 
309 interface BurnableToken {
310     function transferFrom(address _from, address _to, uint _value) public returns (bool);
311     function burnFrom(address _from, uint256 _value) public returns (bool);
312 }
313 
314 
315 contract FeeBurner is Withdrawable, FeeBurnerInterface, Utils2 {
316 
317     mapping(address=>uint) public reserveFeesInBps;
318     mapping(address=>address) public reserveKNCWallet; //wallet holding knc per reserve. from here burn and send fees.
319     mapping(address=>uint) public walletFeesInBps; // wallet that is the source of tx is entitled so some fees.
320     mapping(address=>uint) public reserveFeeToBurn;
321     mapping(address=>uint) public feePayedPerReserve; // track burned fees and sent wallet fees per reserve.
322     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
323     address public taxWallet;
324     uint public taxFeeBps = 0; // burned fees are taxed. % out of burned fees.
325 
326     BurnableToken public knc;
327     KyberNetworkInterface public kyberNetwork;
328     uint public kncPerEthRatePrecision = 600 * PRECISION; //--> 1 ether = 600 knc tokens
329 
330     function FeeBurner(
331         address _admin,
332         BurnableToken _kncToken,
333         KyberNetworkInterface _kyberNetwork,
334         uint _initialKncToEthRatePrecision
335     )
336         public
337     {
338         require(_admin != address(0));
339         require(_kncToken != address(0));
340         require(_kyberNetwork != address(0));
341         require(_initialKncToEthRatePrecision != 0);
342 
343         kyberNetwork = _kyberNetwork;
344         admin = _admin;
345         knc = _kncToken;
346         kncPerEthRatePrecision = _initialKncToEthRatePrecision;
347     }
348 
349     event ReserveDataSet(address reserve, uint feeInBps, address kncWallet);
350 
351     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyOperator {
352         require(feesInBps < 100); // make sure it is always < 1%
353         require(kncWallet != address(0));
354         reserveFeesInBps[reserve] = feesInBps;
355         reserveKNCWallet[reserve] = kncWallet;
356         ReserveDataSet(reserve, feesInBps, kncWallet);
357     }
358 
359     event WalletFeesSet(address wallet, uint feesInBps);
360 
361     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
362         require(feesInBps < 10000); // under 100%
363         walletFeesInBps[wallet] = feesInBps;
364         WalletFeesSet(wallet, feesInBps);
365     }
366 
367     event TaxFeesSet(uint feesInBps);
368 
369     function setTaxInBps(uint _taxFeeBps) public onlyAdmin {
370         require(_taxFeeBps < 10000); // under 100%
371         taxFeeBps = _taxFeeBps;
372         TaxFeesSet(_taxFeeBps);
373     }
374 
375     event TaxWalletSet(address taxWallet);
376 
377     function setTaxWallet(address _taxWallet) public onlyAdmin {
378         require(_taxWallet != address(0));
379         taxWallet = _taxWallet;
380         TaxWalletSet(_taxWallet);
381     }
382 
383     event KNCRateSet(uint ethToKncRatePrecision, uint kyberEthKnc, uint kyberKncEth, address updater);
384 
385     function setKNCRate() public {
386         //query kyber for knc rate sell and buy
387         uint kyberEthKncRate;
388         uint kyberKncEthRate;
389         (kyberEthKncRate, ) = kyberNetwork.getExpectedRate(ETH_TOKEN_ADDRESS, ERC20(knc), (10 ** 18));
390         (kyberKncEthRate, ) = kyberNetwork.getExpectedRate(ERC20(knc), ETH_TOKEN_ADDRESS, (10 ** 18));
391 
392         //check "reasonable" spread == diff not too big. rate wasn't tampered.
393         require(kyberEthKncRate * kyberKncEthRate < PRECISION ** 2 * 2);
394         require(kyberEthKncRate * kyberKncEthRate > PRECISION ** 2 / 2);
395 
396         require(kyberEthKncRate <= MAX_RATE);
397         kncPerEthRatePrecision = kyberEthKncRate;
398         KNCRateSet(kncPerEthRatePrecision, kyberEthKncRate, kyberKncEthRate, msg.sender);
399     }
400 
401     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
402     event AssignBurnFees(address reserve, uint burnFee);
403 
404     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
405         require(msg.sender == address(kyberNetwork));
406         require(tradeWeiAmount <= MAX_QTY);
407 
408         uint kncAmount = calcDestAmount(ETH_TOKEN_ADDRESS, ERC20(knc), tradeWeiAmount, kncPerEthRatePrecision);
409         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
410 
411         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
412         require(fee >= walletFee);
413         uint feeToBurn = fee - walletFee;
414 
415         if (walletFee > 0) {
416             reserveFeeToWallet[reserve][wallet] += walletFee;
417             AssignFeeToWallet(reserve, wallet, walletFee);
418         }
419 
420         if (feeToBurn > 0) {
421             AssignBurnFees(reserve, feeToBurn);
422             reserveFeeToBurn[reserve] += feeToBurn;
423         }
424 
425         return true;
426     }
427 
428     event BurnAssignedFees(address indexed reserve, address sender, uint quantity);
429 
430     event SendTaxFee(address indexed reserve, address sender, address taxWallet, uint quantity);
431 
432     // this function is callable by anyone
433     function burnReserveFees(address reserve) public {
434         uint burnAmount = reserveFeeToBurn[reserve];
435         uint taxToSend = 0;
436         require(burnAmount > 2);
437         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
438         if (taxWallet != address(0) && taxFeeBps != 0) {
439             taxToSend = (burnAmount - 1) * taxFeeBps / 10000;
440             require(burnAmount - 1 > taxToSend);
441             burnAmount -= taxToSend;
442             if (taxToSend > 0) {
443                 require(knc.transferFrom(reserveKNCWallet[reserve], taxWallet, taxToSend));
444                 SendTaxFee(reserve, msg.sender, taxWallet, taxToSend);
445             }
446         }
447         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
448 
449         //update reserve "payments" so far
450         feePayedPerReserve[reserve] += (taxToSend + burnAmount - 1);
451 
452         BurnAssignedFees(reserve, msg.sender, (burnAmount - 1));
453     }
454 
455     event SendWalletFees(address indexed wallet, address reserve, address sender);
456 
457     // this function is callable by anyone
458     function sendFeeToWallet(address wallet, address reserve) public {
459         uint feeAmount = reserveFeeToWallet[reserve][wallet];
460         require(feeAmount > 1);
461         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
462         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
463 
464         feePayedPerReserve[reserve] += (feeAmount - 1);
465         SendWalletFees(wallet, reserve, msg.sender);
466     }
467 }