1 pragma solidity 0.4.18;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     function totalSupply() external view returns (uint supply);
8     function balanceOf(address _owner) external view returns (uint balance);
9     function transfer(address _to, uint _value) external returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
11     function approve(address _spender, uint _value) external returns (bool success);
12     function allowance(address _owner, address _spender) external view returns (uint remaining);
13     function decimals() external view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 // File: contracts/ReentrancyGuard.sol
18 
19 /**
20  * @title Helps contracts guard against reentrancy attacks.
21  */
22 contract ReentrancyGuard {
23 
24     /// @dev counter to allow mutex lock with only one SSTORE operation
25     uint256 private guardCounter = 1;
26 
27     /**
28      * @dev Prevents a function from calling itself, directly or indirectly.
29      * Calling one `nonReentrant` function from
30      * another is not supported. Instead, you can implement a
31      * `private` function doing the actual work, and an `external`
32      * wrapper marked as `nonReentrant`.
33      */
34     modifier nonReentrant() {
35         guardCounter += 1;
36         uint256 localCounter = guardCounter;
37         _;
38         require(localCounter == guardCounter);
39     }
40 
41 }
42 
43 // File: contracts/PermissionGroups.sol
44 
45 contract PermissionGroups {
46 
47     address public admin;
48     address public pendingAdmin;
49     mapping(address=>bool) internal operators;
50     mapping(address=>bool) internal alerters;
51     address[] internal operatorsGroup;
52     address[] internal alertersGroup;
53     uint constant internal MAX_GROUP_SIZE = 50;
54 
55     function PermissionGroups() public {
56         admin = msg.sender;
57     }
58 
59     modifier onlyAdmin() {
60         require(msg.sender == admin);
61         _;
62     }
63 
64     modifier onlyOperator() {
65         require(operators[msg.sender]);
66         _;
67     }
68 
69     modifier onlyAlerter() {
70         require(alerters[msg.sender]);
71         _;
72     }
73 
74     function getOperators () external view returns(address[]) {
75         return operatorsGroup;
76     }
77 
78     function getAlerters () external view returns(address[]) {
79         return alertersGroup;
80     }
81 
82     event TransferAdminPending(address pendingAdmin);
83 
84     /**
85      * @dev Allows the current admin to set the pendingAdmin address.
86      * @param newAdmin The address to transfer ownership to.
87      */
88     function transferAdmin(address newAdmin) public onlyAdmin {
89         require(newAdmin != address(0));
90         TransferAdminPending(pendingAdmin);
91         pendingAdmin = newAdmin;
92     }
93 
94     /**
95      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
96      * @param newAdmin The address to transfer ownership to.
97      */
98     function transferAdminQuickly(address newAdmin) public onlyAdmin {
99         require(newAdmin != address(0));
100         TransferAdminPending(newAdmin);
101         AdminClaimed(newAdmin, admin);
102         admin = newAdmin;
103     }
104 
105     event AdminClaimed( address newAdmin, address previousAdmin);
106 
107     /**
108      * @dev Allows the pendingAdmin address to finalize the change admin process.
109      */
110     function claimAdmin() public {
111         require(pendingAdmin == msg.sender);
112         AdminClaimed(pendingAdmin, admin);
113         admin = pendingAdmin;
114         pendingAdmin = address(0);
115     }
116 
117     event AlerterAdded (address newAlerter, bool isAdd);
118 
119     function addAlerter(address newAlerter) public onlyAdmin {
120         require(!alerters[newAlerter]); // prevent duplicates.
121         require(alertersGroup.length < MAX_GROUP_SIZE);
122 
123         AlerterAdded(newAlerter, true);
124         alerters[newAlerter] = true;
125         alertersGroup.push(newAlerter);
126     }
127 
128     function removeAlerter (address alerter) public onlyAdmin {
129         require(alerters[alerter]);
130         alerters[alerter] = false;
131 
132         for (uint i = 0; i < alertersGroup.length; ++i) {
133             if (alertersGroup[i] == alerter) {
134                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
135                 alertersGroup.length--;
136                 AlerterAdded(alerter, false);
137                 break;
138             }
139         }
140     }
141 
142     event OperatorAdded(address newOperator, bool isAdd);
143 
144     function addOperator(address newOperator) public onlyAdmin {
145         require(!operators[newOperator]); // prevent duplicates.
146         require(operatorsGroup.length < MAX_GROUP_SIZE);
147 
148         OperatorAdded(newOperator, true);
149         operators[newOperator] = true;
150         operatorsGroup.push(newOperator);
151     }
152 
153     function removeOperator (address operator) public onlyAdmin {
154         require(operators[operator]);
155         operators[operator] = false;
156 
157         for (uint i = 0; i < operatorsGroup.length; ++i) {
158             if (operatorsGroup[i] == operator) {
159                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
160                 operatorsGroup.length -= 1;
161                 OperatorAdded(operator, false);
162                 break;
163             }
164         }
165     }
166 }
167 
168 // File: contracts/Withdrawable.sol
169 
170 /**
171  * @title Contracts that should be able to recover tokens or ethers
172  * @author Ilan Doron
173  * @dev This allows to recover any tokens or Ethers received in a contract.
174  * This will prevent any accidental loss of tokens.
175  */
176 contract Withdrawable is PermissionGroups {
177 
178     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
179 
180     /**
181      * @dev Withdraw all ERC20 compatible tokens
182      * @param token ERC20 The address of the token contract
183      */
184     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
185         require(token.transfer(sendTo, amount));
186         TokenWithdraw(token, amount, sendTo);
187     }
188 
189     event EtherWithdraw(uint amount, address sendTo);
190 
191     /**
192      * @dev Withdraw Ethers
193      */
194     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
195         sendTo.transfer(amount);
196         EtherWithdraw(amount, sendTo);
197     }
198 }
199 
200 // File: contracts/KyberPayWrapper.sol
201 
202 interface KyberNetwork {
203     function tradeWithHint(
204         ERC20 src,
205         uint srcAmount,
206         ERC20 dest,
207         address destAddress,
208         uint maxDestAmount,
209         uint minConversionRate,
210         address walletId,
211         bytes hint)
212     external
213     payable
214     returns(uint);
215 }
216 
217 
218 contract KyberPayWrapper is Withdrawable, ReentrancyGuard {
219     ERC20 constant public ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
220 
221     struct PayData {
222         ERC20 src;
223         uint srcAmount;
224         ERC20 dest;
225         address destAddress;
226         uint maxDestAmount;
227         uint minConversionRate;
228         address walletId;
229         bytes paymentData;
230         bytes hint;
231         KyberNetwork kyberNetworkProxy;
232     }
233 
234     function () public payable {} /* solhint-disable-line no-empty-blocks */
235 
236     event ProofOfPayment(address indexed _payer, address indexed _payee, address _token, uint _amount, bytes _data);
237 
238     function pay(
239         ERC20 src,
240         uint srcAmount,
241         ERC20 dest,
242         address destAddress,
243         uint maxDestAmount,
244         uint minConversionRate,
245         address walletId,
246         bytes paymentData,
247         bytes hint,
248         KyberNetwork kyberNetworkProxy
249     ) public nonReentrant payable
250     {
251 
252         require(src != address(0));
253         require(dest != address(0));
254         require(destAddress != address(0));
255 
256         if (src == ETH_TOKEN_ADDRESS) require(srcAmount == msg.value);
257 
258         PayData memory payData = PayData({
259             src:src,
260             srcAmount:srcAmount,
261             dest:dest,
262             destAddress:destAddress,
263             maxDestAmount:maxDestAmount,
264             minConversionRate:minConversionRate,
265             walletId:walletId,
266             paymentData:paymentData,
267             hint:hint,
268             kyberNetworkProxy:kyberNetworkProxy
269         });
270 
271         uint paidAmount = (src == dest) ? doPayWithoutKyber(payData) : doPayWithKyber(payData);
272 
273         // log as event
274         ProofOfPayment(msg.sender ,destAddress, dest, paidAmount, paymentData);
275     }
276 
277     function doPayWithoutKyber(PayData memory payData) internal returns (uint paidAmount) {
278 
279         uint returnAmount;
280 
281         if (payData.srcAmount > payData.maxDestAmount) {
282             paidAmount = payData.maxDestAmount;
283             returnAmount = payData.srcAmount - payData.maxDestAmount;
284         } else {
285             paidAmount = payData.srcAmount;
286             returnAmount = 0;
287         }
288 
289         if (payData.src == ETH_TOKEN_ADDRESS) {
290             payData.destAddress.transfer(paidAmount);
291 
292             // return change
293             if (returnAmount > 0) msg.sender.transfer(returnAmount);
294         } else {
295             require(payData.src.transferFrom(msg.sender, payData.destAddress, paidAmount));
296         }
297     }
298 
299     function doPayWithKyber(PayData memory payData) internal returns (uint paidAmount) {
300 
301         uint returnAmount;
302         uint wrapperSrcBalanceBefore;
303         uint destAddressBalanceBefore;
304         uint wrapperSrcBalanceAfter;
305         uint destAddressBalanceAfter;
306         uint srcAmountUsed;
307 
308         if (payData.src != ETH_TOKEN_ADDRESS) {
309             require(payData.src.transferFrom(msg.sender, address(this), payData.srcAmount));
310             require(payData.src.approve(payData.kyberNetworkProxy, 0));
311             require(payData.src.approve(payData.kyberNetworkProxy, payData.srcAmount));
312         }
313 
314         (wrapperSrcBalanceBefore, destAddressBalanceBefore) = getBalances(
315             payData.src,
316             payData.dest,
317             payData.destAddress
318         );
319 
320         paidAmount = doTradeWithHint(payData);
321         if (payData.src != ETH_TOKEN_ADDRESS) require(payData.src.approve(payData.kyberNetworkProxy, 0));
322 
323         (wrapperSrcBalanceAfter, destAddressBalanceAfter) = getBalances(payData.src, payData.dest, payData.destAddress);
324 
325         // verify the amount the user got is same as returned from Kyber Network
326         require(destAddressBalanceAfter > destAddressBalanceBefore);
327         require(paidAmount == (destAddressBalanceAfter - destAddressBalanceBefore));
328 
329         // calculate the returned change amount
330         require(wrapperSrcBalanceBefore >= wrapperSrcBalanceAfter);
331         srcAmountUsed = wrapperSrcBalanceBefore - wrapperSrcBalanceAfter;
332 
333         require(payData.srcAmount >= srcAmountUsed);
334         returnAmount = payData.srcAmount - srcAmountUsed;
335 
336         // return to sender the returned change
337         if (returnAmount > 0) {
338             if (payData.src == ETH_TOKEN_ADDRESS) {
339                 msg.sender.transfer(returnAmount);
340             } else {
341                 require(payData.src.transfer(msg.sender, returnAmount));
342             }
343         }
344     }
345 
346     function doTradeWithHint(PayData memory payData) internal returns (uint paidAmount) {
347         paidAmount = payData.kyberNetworkProxy.tradeWithHint.value(msg.value)({
348             src:payData.src,
349             srcAmount:payData.srcAmount,
350             dest:payData.dest,
351             destAddress:payData.destAddress,
352             maxDestAmount:payData.maxDestAmount,
353             minConversionRate:payData.minConversionRate,
354             walletId:payData.walletId,
355             hint:payData.hint
356         });
357     }
358 
359     function getBalances (ERC20 src, ERC20 dest, address destAddress)
360         internal
361         view
362         returns (uint wrapperSrcBalance, uint destAddressBalance)
363     {
364         if (src == ETH_TOKEN_ADDRESS) {
365             wrapperSrcBalance = address(this).balance;
366         } else {
367             wrapperSrcBalance = src.balanceOf(address(this));
368         }
369 
370         if (dest == ETH_TOKEN_ADDRESS) {
371             destAddressBalance = destAddress.balance;
372         } else {
373             destAddressBalance = dest.balanceOf(destAddress);
374         }
375     } 
376 }