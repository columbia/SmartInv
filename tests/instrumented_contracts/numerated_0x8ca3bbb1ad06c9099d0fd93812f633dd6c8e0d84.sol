1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 pragma solidity ^0.5.0;
68 
69 
70 contract FUJIBank {
71     using SafeMath for uint256;
72 
73     struct InvestorInfo {
74         uint256 invested;
75         uint256 lockbox;
76         uint256 withdrawn;
77         uint256 lastInvestmentTime;
78     }
79     
80     mapping (address => InvestorInfo) public investors;
81     mapping (address => uint256) public affiliateCommission;
82     mapping (address => uint256) public devCommission;
83 
84     uint256 public investorsCount;
85     uint256 public lockboxTotal;
86     uint256 public withdrawnProfitTotal;
87     uint256 public affiliateCommissionWithdrawnTotal;
88     
89     uint256 public donatedTotal;
90     uint256 public gamesIncomeTotal;
91     
92     address private constant dev_0_master = 0x8345dfc331c020446cE8C123ea802d8562261eab;
93     address private constant dev_1_master = 0x70F5B907d743AD845F987b14a373C436Ba1E9059;
94     address private dev_0_escrow = 0x8345dfc331c020446cE8C123ea802d8562261eab;
95     address private dev_1_escrow = 0x70F5B907d743AD845F987b14a373C436Ba1E9059;
96 
97     uint256 public constant minInvest = 0.025 ether;
98 
99     event Invested(address investor, uint256 amount);
100     event Renvested(address investor, uint256 amount);
101     event WithdrawnAffiliateCommission(address affiliate, uint256 amount);
102     event WithdrawnProfit(address investor, uint256 amount);
103     event WithdrawnLockbox(address investor, uint256 amount);
104 
105     /**
106      * PUBLIC
107      */
108 
109      /**
110      * @dev Donation for FUJI ecosystem.
111      * TESTED
112      */
113     function() external payable {
114         //  5% - to developers
115         uint256 devFee = msg.value.div(40);
116         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
117         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
118         
119         donatedTotal = donatedTotal.add(msg.value);
120     }
121 
122     /**
123      * @dev Accepts income from games for Onigiry ecosystem.
124      * TESTED
125      */
126     function fromGame() external payable {
127         //  8% - to developers
128         uint256 devFee = msg.value.div(50).mul(2);
129         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
130         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
131         
132         gamesIncomeTotal = gamesIncomeTotal.add(msg.value);
133     }
134 
135     /**
136      * @dev Returns invested amount for investor.
137      * @param _address Investor address.
138      * @return invested amount.
139      * TESTED
140      */
141     function getInvested(address _address) public view returns(uint256) {
142         return investors[_address].invested;
143     }
144 
145     /**
146      * @dev Returns lockbox amount for investor.
147      * @param _address Investor address.
148      * @return lockbox amount.
149      * TESTED
150      */
151     function getLockBox(address _address) public view returns(uint256) {
152         return investors[_address].lockbox;
153     }
154 
155     /**
156      * @dev Returns withdrawn amount for investor.
157      * @param _address Investor address.
158      * @return withdrawn amount.
159      * TESTED
160      */
161     function getWithdrawn(address _address) public view returns(uint256) {
162         return investors[_address].withdrawn;
163     }
164 
165     /**
166      * @dev Returns last investment time amount for investor.
167      * @param _address Investor address.
168      * @return last investment time.
169      * TESTED
170      */
171     function getLastInvestmentTime(address _address) public view returns(uint256) {
172         return investors[_address].lastInvestmentTime;
173     }
174 
175     /**
176      * @dev Gets balance for current contract.
177      * @return balance for current contract.
178      * TESTED
179      */
180     function getBalance() public view returns(uint256){
181         return address(this).balance;
182     }
183 
184     /**
185      * @dev Calculates sum for lockboxes and dev fees.
186      * @return Amount of guaranteed balance by constract.
187      * TESTED
188      */
189     function guaranteedBalance() public view returns(uint256) {
190         return lockboxTotal.add(devCommission[dev_0_escrow]).add(devCommission[dev_1_escrow]);
191     }
192 
193     /**
194      * @dev User invests funds.
195      * @param _affiliate affiliate address.
196      * TESTED
197      */
198     function invest(address _affiliate) public payable {
199         require(msg.value >= minInvest, "min 0.025 eth");
200 
201         uint256 profit = calculateProfit(msg.sender);
202         if(profit > 0){
203             msg.sender.transfer(profit);
204         }
205 
206         //  1% - to affiliateCommission
207         if(_affiliate != msg.sender && _affiliate != address(0)) {
208             uint256 commission = msg.value.div(100);
209             affiliateCommission[_affiliate] = affiliateCommission[_affiliate].add(commission);
210         }
211 
212         if(getLastInvestmentTime(msg.sender) == 0) {
213             investorsCount = investorsCount.add(1);
214         }
215 
216         uint256 lockboxAmount = msg.value.div(100).mul(84);
217         investors[msg.sender].lockbox = investors[msg.sender].lockbox.add(lockboxAmount);
218         investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
219         investors[msg.sender].lastInvestmentTime = now;
220         delete investors[msg.sender].withdrawn;
221         
222         lockboxTotal = lockboxTotal.add(lockboxAmount);
223         
224         //  8% - to developers
225         uint256 devFee = msg.value.div(50).mul(2);
226         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
227         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
228 
229         emit Invested(msg.sender, msg.value);
230     }
231 
232     /**
233      * @dev Updates escrow address for developer.
234      * @param _address Address of escrow to be used.
235      * TESTED
236      */
237     function updateDevEscrow(address _address) public {
238         require(msg.sender == dev_0_master || msg.sender == dev_1_master, "not dev");
239         (msg.sender == dev_0_master) ? dev_0_escrow = _address : dev_1_escrow = _address;
240     }
241 
242     /**
243      * @dev Allows developer to withdraw commission.
244      * TESTED
245      */
246     function withdrawDevCommission() public {
247         uint256 commission = devCommission[msg.sender];
248         require(commission > 0, "no dev commission");
249         require(address(this).balance.sub(commission) >= lockboxTotal, "not enough funds");
250 
251         delete devCommission[msg.sender];
252         msg.sender.transfer(commission);
253     }
254     
255     /**
256      * @dev Withdraws affiliate commission for current address.
257      * TESTED
258      */
259     function withdrawAffiliateCommission() public {
260         uint256 commission = affiliateCommission[msg.sender];
261         require(commission > 0, "no commission");
262         require(address(this).balance.sub(commission) >= guaranteedBalance(), "not enough funds");
263 
264         delete affiliateCommission[msg.sender];
265         affiliateCommissionWithdrawnTotal = affiliateCommissionWithdrawnTotal.add(commission);
266 
267         msg.sender.transfer(commission);
268 
269         emit WithdrawnAffiliateCommission(msg.sender, commission);
270     }
271 
272     /**
273      * @dev Allows investor to withdraw profit.
274      * TESTED
275      */
276     function withdrawProfit() public {
277         uint256 profit = calculateProfit(msg.sender);
278         require(profit > 0, "no profit");
279         require(address(this).balance.sub(profit) >= guaranteedBalance(), "not enough funds");
280 
281         investors[msg.sender].lastInvestmentTime = now;
282         investors[msg.sender].withdrawn = investors[msg.sender].withdrawn.add(profit);
283 
284         withdrawnProfitTotal = withdrawnProfitTotal.add(profit);
285         
286         //  4% - to developers
287         uint256 devFee = profit.div(50);
288         devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
289         devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
290         
291         //  3% - stay in contract
292         msg.sender.transfer(profit.div(100).mul(93));
293 
294         emit WithdrawnProfit(msg.sender, profit);
295     }
296 
297     /**
298      * @dev Allows investor to withdraw lockbox funds, close deposit and clear all data.
299      * @notice Pending profit stays in contract.
300      * TESTED
301      */
302     function withdrawLockBoxAndClose() public {
303         uint256 lockboxAmount = getLockBox(msg.sender);
304         require(lockboxAmount > 0, "no investments");
305 
306         delete investors[msg.sender];
307         investorsCount = investorsCount.sub(1);
308         lockboxTotal = lockboxTotal.sub(lockboxAmount);
309 
310         msg.sender.transfer(lockboxAmount);
311 
312         emit WithdrawnLockbox(msg.sender, lockboxAmount);
313     }
314     
315     /**
316      * @dev Reinvests pending profit.
317      * TESTED
318      */
319     function reinvestProfit() public {
320         uint256 profit = calculateProfit(msg.sender);
321         require(profit > 0, "no profit");
322         require(address(this).balance.sub(profit) >= guaranteedBalance(), "not enough funds");
323         
324         uint256 lockboxFromProfit = profit.div(100).mul(84);
325         investors[msg.sender].lockbox = investors[msg.sender].lockbox.add(lockboxFromProfit);
326         investors[msg.sender].lastInvestmentTime = now;
327         investors[msg.sender].invested = investors[msg.sender].invested.add(profit);
328 
329         lockboxTotal = lockboxTotal.add(lockboxFromProfit);
330 
331         emit Renvested(msg.sender, profit);
332     }
333 
334     /**
335      * @dev Calculates pending profit for provided customer.
336      * @param _investor Address of investor.
337      * @return pending profit.
338      * TESTED
339      */
340     function calculateProfit(address _investor) public view returns(uint256){
341         uint256 hourDifference = now.sub(investors[_investor].lastInvestmentTime).div(3600);
342         uint256 rate = percentRateInternal(investors[_investor].lockbox);
343         uint256 calculatedPercent = hourDifference.mul(rate);
344         return investors[_investor].lockbox.div(100000).mul(calculatedPercent);
345     }
346 
347     /**
348      * @dev Calculates rate for lockbox balance for msg.sender.
349      * @param _balance Balance to calculate percentage.
350      * @return rate for lockbox balance.
351      * TESTED
352      */
353     function percentRateInternal(uint256 _balance) public pure returns(uint256) {
354         /**
355             ~ .99 -    - 0.6%
356             1 ~ 50     - 0.96% 
357             51 ~ 100   - 1.2% 
358             100 ~ 250  - 1.44% 
359             250 ~      - 1.8% 
360          */
361         uint256 step_1 = .99 ether;
362         uint256 step_2 = 50 ether;
363         uint256 step_3 = 100 ether;
364         uint256 step_4 = 250 ether;
365 
366         uint256 dailyPercent_0 = 25;   //  0.6%
367         uint256 dailyPercent_1 = 40;   //  0.96%
368         uint256 dailyPercent_2 = 50;   //  1.2%
369         uint256 dailyPercent_3 = 60;   //  1.44%
370         uint256 dailyPercent_4 = 75;   //  1.8%
371 
372         if (_balance >= step_4) {
373             return dailyPercent_4;
374         } else if (_balance >= step_3 && _balance < step_4) {
375             return dailyPercent_3;
376         } else if (_balance >= step_2 && _balance < step_3) {
377             return dailyPercent_2;
378         } else if (_balance >= step_1 && _balance < step_2) {
379             return dailyPercent_1;
380         }
381 
382         return dailyPercent_0;
383     }
384 
385     /**
386      * @dev Calculates rate for lockbox balance for msg.sender. User for public
387      * @param _balance Balance to calculate percentage.
388      * @return rate for lockbox balance.
389      * TESTED
390      */
391     function percentRatePublic(uint256 _balance) public pure returns(uint256) {
392         /**
393             ~ .99 -    - 0.6%
394             1 ~ 50     - 0.96% 
395             51 ~ 100   - 1.2% 
396             100 ~ 250  - 1.44% 
397             250 ~      - 1.8% 
398          */
399         uint256 step_1 = .99 ether;
400         uint256 step_2 = 50 ether;
401         uint256 step_3 = 100 ether;
402         uint256 step_4 = 250 ether;
403 
404         uint256 dailyPercent_0 = 60;   //  0.6%
405         uint256 dailyPercent_1 = 96;   //  0.96%
406         uint256 dailyPercent_2 = 120;   //  1.2%
407         uint256 dailyPercent_3 = 144;   //  1.44%
408         uint256 dailyPercent_4 = 180;   //  1.8%
409 
410         if (_balance >= step_4) {
411             return dailyPercent_4;
412         } else if (_balance >= step_3 && _balance < step_4) {
413             return dailyPercent_3;
414         } else if (_balance >= step_2 && _balance < step_3) {
415             return dailyPercent_2;
416         } else if (_balance >= step_1 && _balance < step_2) {
417             return dailyPercent_1;
418         }
419 
420         return dailyPercent_0;
421     }
422 }