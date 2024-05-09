1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/Onigiri.sol
70 
71 pragma solidity ^0.5.0;
72 
73 
74 contract Onigiri {
75     using SafeMath for uint256;
76 
77     struct InvestorInfo {
78         uint256 invested;
79         uint256 lockbox;
80         uint256 withdrawn;
81         uint256 lastInvestmentTime;
82     }
83     
84     mapping (address => InvestorInfo) public investors;
85     mapping (address => uint256) public affiliateCommission;
86     mapping (address => uint256) public devCommission;
87 
88     uint256 public investorsCount;
89     uint256 public lockboxTotal;
90     uint256 public withdrawnProfitTotal;
91     uint256 public affiliateCommissionWithdrawnTotal;
92     
93     uint256 public donatedTotal;
94     uint256 public gamesIncomeTotal;
95     
96     address private constant dev_0_master = 0x6a5D9648381b90AF0e6881c26739efA4379c19B2;
97     address private constant dev_1_master = 0xDBd32Ef31Fcd7fc1EF028A7471a7A9BFC39ab609;
98     address private dev_0_escrow = 0xF57924672D6dBF0336c618fDa50E284E02715000;
99     address private dev_1_escrow = 0xE4Cf94e5D30FB4406A2B139CD0e872a1C8012dEf;
100 
101     uint256 public constant minInvest = 0.025 ether;
102 
103     event Invested(address investor, uint256 amount);
104     event Renvested(address investor, uint256 amount);
105     event WithdrawnAffiliateCommission(address affiliate, uint256 amount);
106     event WithdrawnProfit(address investor, uint256 amount);
107     event WithdrawnLockbox(address investor, uint256 amount);
108 
109     /**
110      * PUBLIC
111      */
112 
113      /**
114      * @dev Donation for Onigiry ecosystem.
115      * TESTED
116      */
117     function() external payable {
118         //  2% - to developers
119         uint256 devFee = msg.value.div(100);
120         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
121         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
122         
123         donatedTotal = donatedTotal.add(msg.value);
124     }
125 
126     /**
127      * @dev Accepts income from games for Onigiry ecosystem.
128      * TESTED
129      */
130     function fromGame() external payable {
131         //  4% - to developers
132         uint256 devFee = msg.value.div(100).mul(2);
133         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
134         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
135         
136         gamesIncomeTotal = gamesIncomeTotal.add(msg.value);
137     }
138 
139     /**
140      * @dev Returns invested amount for investor.
141      * @param _address Investor address.
142      * @return invested amount.
143      * TESTED
144      */
145     function getInvested(address _address) public view returns(uint256) {
146         return investors[_address].invested;
147     }
148 
149     /**
150      * @dev Returns lockbox amount for investor.
151      * @param _address Investor address.
152      * @return lockbox amount.
153      * TESTED
154      */
155     function getLockBox(address _address) public view returns(uint256) {
156         return investors[_address].lockbox;
157     }
158 
159     /**
160      * @dev Returns withdrawn amount for investor.
161      * @param _address Investor address.
162      * @return withdrawn amount.
163      * TESTED
164      */
165     function getWithdrawn(address _address) public view returns(uint256) {
166         return investors[_address].withdrawn;
167     }
168 
169     /**
170      * @dev Returns last investment time amount for investor.
171      * @param _address Investor address.
172      * @return last investment time.
173      * TESTED
174      */
175     function getLastInvestmentTime(address _address) public view returns(uint256) {
176         return investors[_address].lastInvestmentTime;
177     }
178 
179     /**
180      * @dev Gets balance for current contract.
181      * @return balance for current contract.
182      * TESTED
183      */
184     function getBalance() public view returns(uint256){
185         return address(this).balance;
186     }
187 
188     /**
189      * @dev Calculates sum for lockboxes and dev fees.
190      * @return Amount of guaranteed balance by constract.
191      * TESTED
192      */
193     function guaranteedBalance() public view returns(uint256) {
194         return lockboxTotal.add(devCommission[dev_0_escrow]).add(devCommission[dev_1_escrow]);
195     }
196 
197     /**
198      * @dev User invests funds.
199      * @param _affiliate affiliate address.
200      * TESTED
201      */
202     function invest(address _affiliate) public payable {
203         require(msg.value >= minInvest, "min 0.025 eth");
204 
205         uint256 profit = calculateProfit(msg.sender);
206         if(profit > 0){
207             msg.sender.transfer(profit);
208         }
209 
210         //  1% - to affiliateCommission
211         if(_affiliate != msg.sender && _affiliate != address(0)) {
212             uint256 commission = msg.value.div(100);
213             affiliateCommission[_affiliate] = affiliateCommission[_affiliate].add(commission);
214         }
215 
216         if(getLastInvestmentTime(msg.sender) == 0) {
217             investorsCount = investorsCount.add(1);
218         }
219 
220         uint256 lockboxAmount = msg.value.div(100).mul(84);
221         investors[msg.sender].lockbox = investors[msg.sender].lockbox.add(lockboxAmount);
222         investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
223         investors[msg.sender].lastInvestmentTime = now;
224         delete investors[msg.sender].withdrawn;
225         
226         lockboxTotal = lockboxTotal.add(lockboxAmount);
227         
228         //  4% - to developers
229         uint256 devFee = msg.value.div(100).mul(2);
230         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
231         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
232 
233         emit Invested(msg.sender, msg.value);
234     }
235 
236     /**
237      * @dev Updates escrow address for developer.
238      * @param _address Address of escrow to be used.
239      * TESTED
240      */
241     function updateDevEscrow(address _address) public {
242         require(msg.sender == dev_0_master || msg.sender == dev_1_master, "not dev");
243         (msg.sender == dev_0_master) ? dev_0_escrow = _address : dev_1_escrow = _address;
244     }
245 
246     /**
247      * @dev Allows developer to withdraw commission.
248      * TESTED
249      */
250     function withdrawDevCommission() public {
251         uint256 commission = devCommission[msg.sender];
252         require(commission > 0, "no dev commission");
253         require(address(this).balance.sub(commission) >= lockboxTotal, "not enough funds");
254 
255         delete devCommission[msg.sender];
256         msg.sender.transfer(commission);
257     }
258     
259     /**
260      * @dev Withdraws affiliate commission for current address.
261      * TESTED
262      */
263     function withdrawAffiliateCommission() public {
264         uint256 commission = affiliateCommission[msg.sender];
265         require(commission > 0, "no commission");
266         require(address(this).balance.sub(commission) >= guaranteedBalance(), "not enough funds");
267 
268         delete affiliateCommission[msg.sender];
269         affiliateCommissionWithdrawnTotal = affiliateCommissionWithdrawnTotal.add(commission);
270 
271         msg.sender.transfer(commission);
272 
273         emit WithdrawnAffiliateCommission(msg.sender, commission);
274     }
275 
276     /**
277      * @dev Allows investor to withdraw profit.
278      * TESTED
279      */
280     function withdrawProfit() public {
281         uint256 profit = calculateProfit(msg.sender);
282         require(profit > 0, "no profit");
283         require(address(this).balance.sub(profit) >= guaranteedBalance(), "not enough funds");
284 
285         investors[msg.sender].lastInvestmentTime = now;
286         investors[msg.sender].withdrawn = investors[msg.sender].withdrawn.add(profit);
287 
288         withdrawnProfitTotal = withdrawnProfitTotal.add(profit);
289         
290         //  2% - to developers
291         uint256 devFee = profit.div(100);
292         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
293         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
294         
295         //  3% - stay in contract
296         msg.sender.transfer(profit.div(100).mul(95));
297 
298         emit WithdrawnProfit(msg.sender, profit);
299     }
300 
301     /**
302      * @dev Allows investor to withdraw lockbox funds, close deposit and clear all data.
303      * @notice Pending profit stays in contract.
304      * TESTED
305      */
306     function withdrawLockBoxAndClose() public {
307         uint256 lockboxAmount = getLockBox(msg.sender);
308         require(lockboxAmount > 0, "no investments");
309 
310         delete investors[msg.sender];
311         investorsCount = investorsCount.sub(1);
312         lockboxTotal = lockboxTotal.sub(lockboxAmount);
313 
314         msg.sender.transfer(lockboxAmount);
315 
316         emit WithdrawnLockbox(msg.sender, lockboxAmount);
317     }
318     
319     /**
320      * @dev Reinvests pending profit.
321      * TESTED
322      */
323     function reinvestProfit() public {
324         uint256 profit = calculateProfit(msg.sender);
325         require(profit > 0, "no profit");
326         require(address(this).balance.sub(profit) >= guaranteedBalance(), "not enough funds");
327         
328         uint256 lockboxFromProfit = profit.div(100).mul(84);
329         investors[msg.sender].lockbox = investors[msg.sender].lockbox.add(lockboxFromProfit);
330         investors[msg.sender].lastInvestmentTime = now;
331         investors[msg.sender].invested = investors[msg.sender].invested.add(profit);
332 
333         lockboxTotal = lockboxTotal.add(lockboxFromProfit);
334 
335         emit Renvested(msg.sender, profit);
336     }
337 
338     /**
339      * @dev Calculates pending profit for provided customer.
340      * @param _investor Address of investor.
341      * @return pending profit.
342      * TESTED
343      */
344     function calculateProfit(address _investor) public view returns(uint256){
345         uint256 hourDifference = now.sub(investors[_investor].lastInvestmentTime).div(3600);
346         uint256 rate = percentRateInternal(investors[_investor].lockbox);
347         uint256 calculatedPercent = hourDifference.mul(rate);
348         return investors[_investor].lockbox.div(100000).mul(calculatedPercent);
349     }
350 
351     /**
352      * @dev Calculates rate for lockbox balance for msg.sender.
353      * @param _balance Balance to calculate percentage.
354      * @return rate for lockbox balance.
355      * TESTED
356      */
357     function percentRateInternal(uint256 _balance) public pure returns(uint256) {
358         /**
359             ~ .99 -    - 0.6%
360             1 ~ 50     - 0.96% 
361             51 ~ 100   - 1.2% 
362             100 ~ 250  - 1.44% 
363             250 ~      - 1.8% 
364          */
365         uint256 step_1 = .99 ether;
366         uint256 step_2 = 50 ether;
367         uint256 step_3 = 100 ether;
368         uint256 step_4 = 250 ether;
369 
370         uint256 dailyPercent_0 = 25;   //  0.6%
371         uint256 dailyPercent_1 = 40;   //  0.96%
372         uint256 dailyPercent_2 = 50;   //  1.2%
373         uint256 dailyPercent_3 = 60;   //  1.44%
374         uint256 dailyPercent_4 = 75;   //  1.8%
375 
376         if (_balance >= step_4) {
377             return dailyPercent_4;
378         } else if (_balance >= step_3 && _balance < step_4) {
379             return dailyPercent_3;
380         } else if (_balance >= step_2 && _balance < step_3) {
381             return dailyPercent_2;
382         } else if (_balance >= step_1 && _balance < step_2) {
383             return dailyPercent_1;
384         }
385 
386         return dailyPercent_0;
387     }
388 
389     /**
390      * @dev Calculates rate for lockbox balance for msg.sender. User for public
391      * @param _balance Balance to calculate percentage.
392      * @return rate for lockbox balance.
393      * TESTED
394      */
395     function percentRatePublic(uint256 _balance) public pure returns(uint256) {
396         /**
397             ~ .99 -    - 0.6%
398             1 ~ 50     - 0.96% 
399             51 ~ 100   - 1.2% 
400             100 ~ 250  - 1.44% 
401             250 ~      - 1.8% 
402          */
403         uint256 step_1 = .99 ether;
404         uint256 step_2 = 50 ether;
405         uint256 step_3 = 100 ether;
406         uint256 step_4 = 250 ether;
407 
408         uint256 dailyPercent_0 = 60;   //  0.6%
409         uint256 dailyPercent_1 = 96;   //  0.96%
410         uint256 dailyPercent_2 = 120;   //  1.2%
411         uint256 dailyPercent_3 = 144;   //  1.44%
412         uint256 dailyPercent_4 = 180;   //  1.8%
413 
414         if (_balance >= step_4) {
415             return dailyPercent_4;
416         } else if (_balance >= step_3 && _balance < step_4) {
417             return dailyPercent_3;
418         } else if (_balance >= step_2 && _balance < step_3) {
419             return dailyPercent_2;
420         } else if (_balance >= step_1 && _balance < step_2) {
421             return dailyPercent_1;
422         }
423 
424         return dailyPercent_0;
425     }
426 }