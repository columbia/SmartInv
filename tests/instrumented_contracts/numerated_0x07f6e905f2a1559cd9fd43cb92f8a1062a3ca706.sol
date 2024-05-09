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
17 // File: contracts/FeeBurnerInterface.sol
18 
19 interface FeeBurnerInterface {
20     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
21 }
22 
23 // File: contracts/Utils.sol
24 
25 /// @title Kyber constants contract
26 contract Utils {
27 
28     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
29     uint  constant internal PRECISION = (10**18);
30     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
31     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
32     uint  constant internal MAX_DECIMALS = 18;
33     uint  constant internal ETH_DECIMALS = 18;
34     mapping(address=>uint) internal decimals;
35 
36     function setDecimals(ERC20 token) internal {
37         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
38         else decimals[token] = token.decimals();
39     }
40 
41     function getDecimals(ERC20 token) internal view returns(uint) {
42         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
43         uint tokenDecimals = decimals[token];
44         // technically, there might be token with decimals 0
45         // moreover, very possible that old tokens have decimals 0
46         // these tokens will just have higher gas fees.
47         if(tokenDecimals == 0) return token.decimals();
48 
49         return tokenDecimals;
50     }
51 
52     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
53         require(srcQty <= MAX_QTY);
54         require(rate <= MAX_RATE);
55 
56         if (dstDecimals >= srcDecimals) {
57             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
58             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
59         } else {
60             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
61             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
62         }
63     }
64 
65     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
66         require(dstQty <= MAX_QTY);
67         require(rate <= MAX_RATE);
68         
69         //source quantity is rounded up. to avoid dest quantity being too low.
70         uint numerator;
71         uint denominator;
72         if (srcDecimals >= dstDecimals) {
73             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
74             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
75             denominator = rate;
76         } else {
77             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
78             numerator = (PRECISION * dstQty);
79             denominator = (rate * (10**(dstDecimals - srcDecimals)));
80         }
81         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
82     }
83 }
84 
85 // File: contracts/PermissionGroups.sol
86 
87 contract PermissionGroups {
88 
89     address public admin;
90     address public pendingAdmin;
91     mapping(address=>bool) internal operators;
92     mapping(address=>bool) internal alerters;
93     address[] internal operatorsGroup;
94     address[] internal alertersGroup;
95     uint constant internal MAX_GROUP_SIZE = 50;
96 
97     function PermissionGroups() public {
98         admin = msg.sender;
99     }
100 
101     modifier onlyAdmin() {
102         require(msg.sender == admin);
103         _;
104     }
105 
106     modifier onlyOperator() {
107         require(operators[msg.sender]);
108         _;
109     }
110 
111     modifier onlyAlerter() {
112         require(alerters[msg.sender]);
113         _;
114     }
115 
116     function getOperators () external view returns(address[]) {
117         return operatorsGroup;
118     }
119 
120     function getAlerters () external view returns(address[]) {
121         return alertersGroup;
122     }
123 
124     event TransferAdminPending(address pendingAdmin);
125 
126     /**
127      * @dev Allows the current admin to set the pendingAdmin address.
128      * @param newAdmin The address to transfer ownership to.
129      */
130     function transferAdmin(address newAdmin) public onlyAdmin {
131         require(newAdmin != address(0));
132         TransferAdminPending(pendingAdmin);
133         pendingAdmin = newAdmin;
134     }
135 
136     /**
137      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
138      * @param newAdmin The address to transfer ownership to.
139      */
140     function transferAdminQuickly(address newAdmin) public onlyAdmin {
141         require(newAdmin != address(0));
142         TransferAdminPending(newAdmin);
143         AdminClaimed(newAdmin, admin);
144         admin = newAdmin;
145     }
146 
147     event AdminClaimed( address newAdmin, address previousAdmin);
148 
149     /**
150      * @dev Allows the pendingAdmin address to finalize the change admin process.
151      */
152     function claimAdmin() public {
153         require(pendingAdmin == msg.sender);
154         AdminClaimed(pendingAdmin, admin);
155         admin = pendingAdmin;
156         pendingAdmin = address(0);
157     }
158 
159     event AlerterAdded (address newAlerter, bool isAdd);
160 
161     function addAlerter(address newAlerter) public onlyAdmin {
162         require(!alerters[newAlerter]); // prevent duplicates.
163         require(alertersGroup.length < MAX_GROUP_SIZE);
164 
165         AlerterAdded(newAlerter, true);
166         alerters[newAlerter] = true;
167         alertersGroup.push(newAlerter);
168     }
169 
170     function removeAlerter (address alerter) public onlyAdmin {
171         require(alerters[alerter]);
172         alerters[alerter] = false;
173 
174         for (uint i = 0; i < alertersGroup.length; ++i) {
175             if (alertersGroup[i] == alerter) {
176                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
177                 alertersGroup.length--;
178                 AlerterAdded(alerter, false);
179                 break;
180             }
181         }
182     }
183 
184     event OperatorAdded(address newOperator, bool isAdd);
185 
186     function addOperator(address newOperator) public onlyAdmin {
187         require(!operators[newOperator]); // prevent duplicates.
188         require(operatorsGroup.length < MAX_GROUP_SIZE);
189 
190         OperatorAdded(newOperator, true);
191         operators[newOperator] = true;
192         operatorsGroup.push(newOperator);
193     }
194 
195     function removeOperator (address operator) public onlyAdmin {
196         require(operators[operator]);
197         operators[operator] = false;
198 
199         for (uint i = 0; i < operatorsGroup.length; ++i) {
200             if (operatorsGroup[i] == operator) {
201                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
202                 operatorsGroup.length -= 1;
203                 OperatorAdded(operator, false);
204                 break;
205             }
206         }
207     }
208 }
209 
210 // File: contracts/Withdrawable.sol
211 
212 /**
213  * @title Contracts that should be able to recover tokens or ethers
214  * @author Ilan Doron
215  * @dev This allows to recover any tokens or Ethers received in a contract.
216  * This will prevent any accidental loss of tokens.
217  */
218 contract Withdrawable is PermissionGroups {
219 
220     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
221 
222     /**
223      * @dev Withdraw all ERC20 compatible tokens
224      * @param token ERC20 The address of the token contract
225      */
226     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
227         require(token.transfer(sendTo, amount));
228         TokenWithdraw(token, amount, sendTo);
229     }
230 
231     event EtherWithdraw(uint amount, address sendTo);
232 
233     /**
234      * @dev Withdraw Ethers
235      */
236     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
237         sendTo.transfer(amount);
238         EtherWithdraw(amount, sendTo);
239     }
240 }
241 
242 // File: contracts/FeeBurner.sol
243 
244 interface BurnableToken {
245     function transferFrom(address _from, address _to, uint _value) public returns (bool);
246     function burnFrom(address _from, uint256 _value) public returns (bool);
247 }
248 
249 
250 contract FeeBurner is Withdrawable, FeeBurnerInterface, Utils {
251 
252     mapping(address=>uint) public reserveFeesInBps;
253     mapping(address=>address) public reserveKNCWallet; //wallet holding knc per reserve. from here burn and send fees.
254     mapping(address=>uint) public walletFeesInBps; // wallet that is the source of tx is entitled so some fees.
255     mapping(address=>uint) public reserveFeeToBurn;
256     mapping(address=>uint) public feePayedPerReserve; // track burned fees and sent wallet fees per reserve.
257     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
258     address public taxWallet;
259     uint public taxFeeBps = 0; // burned fees are taxed. % out of burned fees.
260 
261     BurnableToken public knc;
262     address public kyberNetwork;
263     uint public kncPerETHRate = 300;
264 
265     function FeeBurner(address _admin, BurnableToken kncToken, address _kyberNetwork) public {
266         require(_admin != address(0));
267         require(kncToken != address(0));
268         require(_kyberNetwork != address(0));
269         kyberNetwork = _kyberNetwork;
270         admin = _admin;
271         knc = kncToken;
272     }
273 
274     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
275         require(feesInBps < 100); // make sure it is always < 1%
276         require(kncWallet != address(0));
277         reserveFeesInBps[reserve] = feesInBps;
278         reserveKNCWallet[reserve] = kncWallet;
279     }
280 
281     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
282         require(feesInBps < 10000); // under 100%
283         walletFeesInBps[wallet] = feesInBps;
284     }
285 
286     function setTaxInBps(uint _taxFeeBps) public onlyAdmin {
287         require(_taxFeeBps < 10000); // under 100%
288         taxFeeBps = _taxFeeBps;
289     }
290 
291     function setTaxWallet(address _taxWallet) public onlyAdmin {
292         require(_taxWallet != address(0));
293         taxWallet = _taxWallet;
294     }
295 
296     function setKNCRate(uint rate) public onlyAdmin {
297         require(rate <= MAX_RATE);
298         kncPerETHRate = rate;
299     }
300 
301     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
302     event AssignBurnFees(address reserve, uint burnFee);
303 
304     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
305         require(msg.sender == kyberNetwork);
306         require(tradeWeiAmount <= MAX_QTY);
307         require(kncPerETHRate <= MAX_RATE);
308 
309         uint kncAmount = tradeWeiAmount * kncPerETHRate;
310         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
311 
312         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
313         require(fee >= walletFee);
314         uint feeToBurn = fee - walletFee;
315 
316         if (walletFee > 0) {
317             reserveFeeToWallet[reserve][wallet] += walletFee;
318             AssignFeeToWallet(reserve, wallet, walletFee);
319         }
320 
321         if (feeToBurn > 0) {
322             AssignBurnFees(reserve, feeToBurn);
323             reserveFeeToBurn[reserve] += feeToBurn;
324         }
325 
326         return true;
327     }
328 
329 
330     // this function is callable by anyone
331     event BurnAssignedFees(address indexed reserve, address sender, uint quantity);
332     event SendTaxFee(address indexed reserve, address sender, address taxWallet, uint quantity);
333 
334     function burnReserveFees(address reserve) public {
335         uint burnAmount = reserveFeeToBurn[reserve];
336         uint taxToSend = 0;
337         require(burnAmount > 2);
338         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
339         if (taxWallet != address(0) && taxFeeBps != 0) {
340             taxToSend = (burnAmount - 1) * taxFeeBps / 10000;
341             require(burnAmount - 1 > taxToSend);
342             burnAmount -= taxToSend;
343             if (taxToSend > 0) {
344                 require (knc.transferFrom(reserveKNCWallet[reserve], taxWallet, taxToSend));
345                 SendTaxFee(reserve, msg.sender, taxWallet, taxToSend);
346             }
347         }
348         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
349 
350         //update reserve "payments" so far
351         feePayedPerReserve[reserve] += (taxToSend + burnAmount - 1);
352 
353         BurnAssignedFees(reserve, msg.sender, (burnAmount - 1));
354     }
355 
356     event SendWalletFees(address indexed wallet, address reserve, address sender);
357 
358     // this function is callable by anyone
359     function sendFeeToWallet(address wallet, address reserve) public {
360         uint feeAmount = reserveFeeToWallet[reserve][wallet];
361         require(feeAmount > 1);
362         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
363         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
364 
365         feePayedPerReserve[reserve] += (feeAmount - 1);
366         SendWalletFees(wallet, reserve, msg.sender);
367     }
368 }