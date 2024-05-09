1 pragma solidity ^0.4.24;
2 
3 
4 contract DoubleProfit {
5     using SafeMath for uint256;
6     struct Investor {
7         uint256 deposit;
8         uint256 paymentTime;
9         uint256 withdrawals;
10         bool insured;
11     }
12     uint public countOfInvestors;
13     mapping (address => Investor) public investors;
14 
15     uint256 public minimum = 0.01 ether;
16     uint step = 5 minutes;
17     uint ownerPercent = 2;
18     uint promotionPercent = 8;
19     uint insurancePercent = 2;
20     bool public closed = false;
21 
22     address public ownerAddress = 0x8462372F80b8f1230E2de9e29D173607b8EE6F99;
23     address public promotionAddress = 0xefa08884C1e9f7A4A3F87F5134E9D8fe5309Fb59;
24     address public insuranceFundAddress;
25 
26     DPInsuranceFund IFContract;
27 
28     event Invest(address indexed investor, uint256 amount);
29     event Withdraw(address indexed investor, uint256 amount);
30     event UserDelete(address indexed investor);
31     event ReturnOfDeposit(address indexed investor, uint256 difference);
32 
33     /**
34     * @dev Modifier for access from the InsuranceFund
35     */
36     modifier onlyIF() {
37         require(insuranceFundAddress == msg.sender, "access denied");
38         _;
39     }
40 
41     /**
42     * @dev  Setter the InsuranceFund address. Address can be set only once.
43     * @param _insuranceFundAddress Address of the InsuranceFund
44     */
45     function setInsuranceFundAddress(address _insuranceFundAddress) public{
46         require(insuranceFundAddress == address(0x0));
47         insuranceFundAddress = _insuranceFundAddress;
48         IFContract = DPInsuranceFund(insuranceFundAddress);
49     }
50 
51     /**
52     * @dev  Set insured from the InsuranceFund.
53     * @param _address Investor's address
54     * @return Object of investor's information
55     */
56     function setInsured(address _address) public onlyIF returns(uint256, uint256, bool){
57         Investor storage investor = investors[_address];
58         investor.insured = true;
59         return (investor.deposit, investor.withdrawals, investor.insured);
60     }
61 
62     /**
63     * @dev  Function for close entrance.
64     */
65     function closeEntrance() public {
66         require(address(this).balance < 0.1 ether && !closed);
67         closed = true;
68     }
69 
70     /**
71     * @dev Get percent depends on balance of contract
72     * @return Percent
73     */
74     function getPhasePercent() view public returns (uint){
75         uint contractBalance = address(this).balance;
76 
77         if (contractBalance >= 5000 ether) {
78             return(88);
79         }
80         if (contractBalance >= 2500 ether) {
81             return(75);
82         }
83         if (contractBalance >= 1000 ether) {
84             return(60);
85         }
86         if (contractBalance >= 500 ether) {
87             return(50);
88         }
89         if (contractBalance >= 100 ether) {
90             return(42);
91         } else {
92             return(35);
93         }
94 
95     }
96 
97     /**
98     * @dev Allocation budgets
99     */
100     function allocation() private{
101         ownerAddress.transfer(msg.value.mul(ownerPercent).div(100));
102         promotionAddress.transfer(msg.value.mul(promotionPercent).div(100));
103         insuranceFundAddress.transfer(msg.value.mul(insurancePercent).div(100));
104     }
105 
106     /**
107     * @dev Evaluate current balance
108     * @param _address Address of investor
109     * @return Payout amount
110     */
111     function getUserBalance(address _address) view public returns (uint256) {
112         Investor storage investor = investors[_address];
113         uint percent = getPhasePercent();
114         uint256 differentTime = now.sub(investor.paymentTime).div(step);
115         uint256 differentPercent = investor.deposit.mul(percent).div(1000);
116         uint256 payout = differentPercent.mul(differentTime).div(288);
117 
118         return payout;
119     }
120 
121     /**
122     * @dev Withdraw profit from contract. Investor will be deleted if he will try withdraw after received x2
123     */
124     function withdraw() private {
125         Investor storage investor = investors[msg.sender];
126         uint256 balance = getUserBalance(msg.sender);
127         if (investor.deposit > 0 && address(this).balance > balance && balance > 0) {
128             uint256 tempWithdrawals = investor.withdrawals;
129 
130             investor.withdrawals = investor.withdrawals.add(balance);
131             investor.paymentTime = now;
132 
133             if (investor.withdrawals >= investor.deposit.mul(2)){
134                 investor.deposit = 0;
135                 investor.paymentTime = 0;
136                 investor.withdrawals = 0;
137                 countOfInvestors--;
138                 if (investor.insured)
139                     IFContract.deleteInsured(msg.sender);
140                 investor.insured = false;
141                 emit UserDelete(msg.sender);
142             } else {
143                 if (investor.insured && tempWithdrawals < investor.deposit){
144                     IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
145                 }
146             }
147             msg.sender.transfer(balance);
148             emit Withdraw(msg.sender, balance);
149         }
150 
151     }
152 
153     /**
154     * @dev  Payable function for
155     * - receive funds (send minimum 0.01 ETH),
156     * - calm your profit (send 0 ETH)
157     * - withdraw deposit (send 0.00000112 ether)
158     */
159     function () external payable {
160         require(!closed);
161         Investor storage investor = investors[msg.sender];
162         if (msg.value >= minimum){
163 
164             if (investor.deposit == 0){
165                 countOfInvestors++;
166             } else {
167                 withdraw();
168             }
169 
170             investor.deposit = investor.deposit.add(msg.value);
171             investor.paymentTime = now;
172 
173             if (investor.insured){
174                 IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
175             }
176             allocation();
177             emit Invest(msg.sender, msg.value);
178         } else if (msg.value == 0.00000112 ether) {
179             returnDeposit();
180         } else {
181             withdraw();
182         }
183     }
184 
185     /**
186     * @dev  Withdraw your deposit from the project
187     */
188     function returnDeposit() private {
189         Investor storage investor = investors[msg.sender];
190         require(investor.deposit > 0);
191         withdraw();
192         uint withdrawalAmount = investor.deposit.sub(investor.withdrawals).sub(investor.deposit.mul(ownerPercent + promotionPercent + insurancePercent).div(100));
193         investor.deposit = 0;
194         investor.paymentTime = 0;
195         investor.withdrawals = 0;
196         countOfInvestors--;
197         if (investor.insured)
198             IFContract.deleteInsured(msg.sender);
199         investor.insured = false;
200         emit UserDelete(msg.sender);
201         msg.sender.transfer(withdrawalAmount);
202         emit ReturnOfDeposit(msg.sender, withdrawalAmount);
203     }
204 }
205 
206 
207 /**
208  * Math operations with safety checks
209  */
210  library SafeMath {
211 
212      function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
213          if (_a == 0) {
214              return 0;
215          }
216 
217          uint256 c = _a * _b;
218          require(c / _a == _b);
219 
220          return c;
221      }
222 
223      function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
224          require(_b > 0);
225          uint256 c = _a / _b;
226 
227          return c;
228      }
229 
230      function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
231          require(_b <= _a);
232          uint256 c = _a - _b;
233 
234          return c;
235      }
236 
237      function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
238          uint256 c = _a + _b;
239          require(c >= _a);
240 
241          return c;
242      }
243 
244      function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245          require(b != 0);
246          return a % b;
247      }
248  }
249 
250 
251 /**
252 * It is insurance smart-contract for the DoubleProfit.
253 * You can buy insurance for 10% and if you do not take 100% profit when balance of
254 * the DoubleProfit will be lesser then 0.01 you can receive part of insurance fund depend on your not received money.
255 *
256 * To buy insurance:
257 * Send to the contract address 10% of your deposit, and you will be accounted to.
258 *
259 * To receive insurance payout:
260 * Send to the contract address 0 ETH, and you will receive part of insurance depend on your not received money.
261 * If you already received 100% from your deposit, you will take error.
262 */
263 contract DPInsuranceFund {
264     using SafeMath for uint256;
265 
266     /**
267     * @dev Structure for evaluating payout
268     * @param deposit Duplicated from DoubleProfit deposit
269     * @param withdrawals Duplicated from DoubleProfit withdrawals
270     * @param insured Flag for available payout
271     */
272     struct Investor {
273         uint256 deposit;
274         uint256 withdrawals;
275         bool insured;
276     }
277     mapping (address => Investor) public investors;
278     uint public countOfInvestors;
279 
280     bool public startOfPayments = false;
281     uint256 public totalSupply;
282 
283     uint256 public totalNotReceived;
284     address public DPAddress;
285 
286     DoubleProfit DPContract;
287 
288     event Paid(address investor, uint256 amount, uint256  notRecieve, uint256  partOfNotReceived);
289     event SetInfo(address investor, uint256  notRecieve, uint256 deposit, uint256 withdrawals);
290 
291     /**
292     * @dev  Modifier for access from the DoubleProfit
293     */
294     modifier onlyDP() {
295         require(msg.sender == DPAddress, "access denied");
296         _;
297     }
298 
299     /**
300     * @dev  Setter the DoubleProfit address. Address can be set only once.
301     * @param _DPAddress Address of the DoubleProfit
302     */
303     function setDPAddress(address _DPAddress) public {
304         require(DPAddress == address(0x0));
305         DPAddress = _DPAddress;
306         DPContract = DoubleProfit(DPAddress);
307     }
308 
309     /**
310     * @dev  Private setter info about investor. Can be call if payouts not started.
311     * Needing for evaluating not received total amount without loops.
312     * @param _address Investor's address
313     * @param deposit Investor's deposit
314     * @param withdrawals Investor's withdrawals
315     */
316     function privateSetInfo(address _address, uint256 deposit, uint256 withdrawals) private{
317         if (!startOfPayments) {
318             Investor storage investor = investors[_address];
319 
320             if (investor.deposit != deposit){
321                 totalNotReceived = totalNotReceived.add(deposit.sub(investor.deposit));
322                 investor.deposit = deposit;
323             }
324 
325             if (investor.withdrawals != withdrawals){
326                 uint256 different;
327 
328                 if (investor.deposit <= withdrawals){
329                     different = investor.deposit.sub(investor.withdrawals);
330                     if (totalNotReceived >= different && different != 0)
331                         totalNotReceived = totalNotReceived.sub(different);
332                     else
333                         totalNotReceived = 0;
334                     withdrawals = investor.deposit;
335                 } else {
336                     different = withdrawals.sub(investor.withdrawals);
337                     if (totalNotReceived >= different)
338                         totalNotReceived = totalNotReceived.sub(different);
339                     else
340                         totalNotReceived = 0;
341 
342                 }
343             }
344             investor.withdrawals = withdrawals;
345             emit SetInfo(_address, totalNotReceived, investor.deposit, investor.withdrawals);
346         }
347     }
348 
349     /**
350     * @dev  Setter info about investor from the DoubleProfit.
351     * @param _address Investor's address
352     * @param deposit Investor's deposit
353     * @param withdrawals Investor's withdrawals
354     */
355     function setInfo(address _address, uint256 deposit, uint256 withdrawals) public onlyDP {
356         privateSetInfo(_address, deposit, withdrawals);
357     }
358 
359     /**
360     * @dev  Delete insured from the DoubleProfit.
361     * @param _address Investor's address
362     */
363     function deleteInsured(address _address) public onlyDP {
364         Investor storage investor = investors[_address];
365         investor.deposit = 0;
366         investor.withdrawals = 0;
367         investor.insured = false;
368         countOfInvestors--;
369     }
370 
371     /**
372     * @dev  Function for starting payouts and stopping receive funds.
373     */
374     function beginOfPayments() public {
375         require(address(DPAddress).balance < 0.1 ether && !startOfPayments);
376         startOfPayments = true;
377         totalSupply = address(this).balance;
378     }
379 
380     /**
381     * @dev  Payable function for receive funds, buying insurance and receive insurance payouts .
382     */
383     function () external payable {
384         Investor storage investor = investors[msg.sender];
385         if (msg.value > 0){
386             require(!startOfPayments);
387             if (msg.sender != DPAddress && msg.value >= 0.1 ether) {
388                 require(countOfInvestors.add(1) <= DPContract.countOfInvestors().mul(32).div(100));
389                 uint256 deposit;
390                 uint256 withdrawals;
391                 (deposit, withdrawals, investor.insured) = DPContract.setInsured(msg.sender);
392                 require(msg.value >= deposit.div(10) && deposit > 0);
393                 if (msg.value > deposit.div(10)) {
394                     msg.sender.transfer(msg.value - deposit.div(10));
395                 }
396                 countOfInvestors++;
397                 privateSetInfo(msg.sender, deposit, withdrawals);
398             }
399         } else if (msg.value == 0){
400             uint256 notReceived = investor.deposit.sub(investor.withdrawals);
401             uint256 partOfNotReceived = notReceived.mul(100).div(totalNotReceived);
402             uint256 payAmount = totalSupply.div(100).mul(partOfNotReceived);
403             require(startOfPayments && investor.insured && notReceived > 0);
404             investor.insured = false;
405             msg.sender.transfer(payAmount);
406             emit Paid(msg.sender, payAmount, notReceived, partOfNotReceived);
407         }
408     }
409 }