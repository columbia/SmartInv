1 pragma solidity 0.4.25;
2 
3 /* ETH7.IO - MADE FOR PEOPLE
4 * ETHEREUM ACCUMULATIVE SMARTCONTRACT
5 * Web  - https://eth7.io
6 * - GAIN 1.85% OF YOUR DEPOSIT  PER 12 HOURS (3.7% PER DAY)
7 * - A UNIQUE SYSTEM DAYS OF CASHBACK DEVELOPED BY A TEAM ETH7
8 * - Affiliate program 4% from each Deposit Of your partner 
9 * - Minimal contribution is 0.01 eth
10 * - Currency and payment – ETH
11 * - Transfer funds only from Your personal ETH wallet
12 * - Contribution allocation schemes:
13 *    -- 89% payments
14 *    -- 11% Marketing + Operating Expenses
15 
16 * ---How to use:
17 *  1. Send from ETH wallet to the smart contract address "0xC18D73FAfc36cEc96c9C8a05309662605840826d"
18 *     any amount above 0.01 ETH.
19 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
20  of your wallet.
21 *   Claim your profit by sending 0 ether transaction 
22 * Get your profit every 12 hours by sending 0 ether transaction to  smart contract address
23 * RECOMMENDED GAS LIMIT: 200000
24 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
25 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
26 *
27 * 
28 * The contract has passed several security audits and has been approved by professionals 
29 ETH7.IO - MADE FOR PEOPLE
30 */
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
39         uint256 c = a * b;
40         assert(a == 0 || c / a == b);
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns(uint256) {
45         // assert(b > 0); // Solidity automatically throws when dividing by 0
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     function add(uint256 a, uint256 b) internal pure returns(uint256) {
57         uint256 c = a + b;
58         assert(c >= a);
59         return c;
60     }
61 }
62 
63 /**
64  * @title Helps contracts guard against reentrancy attacks.
65  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
66  * @dev If you mark a function `nonReentrant`, you should also
67  * mark it `external`.
68  */
69 contract ReentrancyGuard {
70 
71     /// @dev counter to allow mutex lock with only one SSTORE operation
72     uint256 private _guardCounter;
73 
74     constructor() internal {
75         // The counter starts at one to prevent changing it from zero to a non-zero
76         // value, which is a more expensive operation.
77         _guardCounter = 1;
78     }
79 
80     /**
81      * @dev Prevents a contract from calling itself, directly or indirectly.
82      * Calling a `nonReentrant` function from another `nonReentrant`
83      * function is not supported. It is possible to prevent this from happening
84      * by making the `nonReentrant` function external, and make it call a
85      * `private` function that does the actual work.
86      */
87     modifier nonReentrant() {
88         _guardCounter += 1;
89         uint256 localCounter = _guardCounter;
90         _;
91         require(localCounter == _guardCounter);
92     }
93 
94 }
95 
96 /**
97 The development of the contract is entirely owned by the ETH7 campaign, any copying of the source code is not legal.
98 */
99 contract Eth7 is ReentrancyGuard {
100     //use of library of safe mathematical operations    
101     using SafeMath for uint;
102     // array containing information about beneficiaries
103     mapping(address => uint) public userDeposit;
104     // array of refferels
105     mapping(address => address) public userReferral;
106     // collected from refferal system
107     mapping(address => uint) public refferalCollected;
108     // array containing information about users cashback
109     mapping(address => uint) public usersCashback;
110     //array containing information about the time of payment
111     mapping(address => uint) public userTime;
112     //array containing information on interest paid
113     mapping(address => uint) public persentWithdraw;
114     // users already deposited
115     mapping(address => bool) public alreadyDeposited;
116     //fund fo transfer marceting percent 
117     address public marketingFund = 0xFEfF6b5811AEa737E03f526fD8C4E72924fdEA54;
118     //wallet for a dev foundation
119     address public devFund = 0x03e08ce26C93F6403C84365FF58498feA6c88A6a;
120     //percentage deducted to the advertising fund
121     uint marketingPercent = 8;
122     //percent for a charitable foundation
123     uint public devPercent = 3;
124     // refferal percent
125     uint public refPercent = 4;
126     //time through which you can take dividends
127     //uint public chargingTime = 12 hours;
128     uint public chargingTime = 12 hours;
129     
130     //start persent 1.85% per 12 hours
131     uint public persent = 1850;
132 
133     uint public countOfInvestors = 0;
134     uint public countOfDev = 0;
135     
136     // information about cashback actions
137     uint public minDepCashBackLevel1 = 100 finney;
138     uint public maxDepCashBackLevel1 = 3 ether;
139     uint public maxDepCashBackLevel2 = 7 ether;
140     uint public maxDepCashBackLevel3 = 10000 ether;
141     
142     // 1st action
143     uint public beginCashBackTime1 = 1541462399;     // begin of the action 05.11.2018 
144     uint public endCashBackTime1 = 1541548799;       // end of the action 06.11.2018
145     uint public cashbackPercent1level1 = 25;       // cashback persent 25 = 2.5%
146     uint public cashbackPercent1level2 = 35;       // cashback persent 35 = 3.5%
147     uint public cashbackPercent1level3 = 50;       // cashback persent 50 = 5%
148 
149     // 2 action
150     uint public beginCashBackTime2 = 1542326399;     // begin of the action 15.11.2018
151     uint public endCashBackTime2 = 1542499199;       // end of the action 17.11.2018
152     uint public cashbackPercent2level1 = 30;       
153     uint public cashbackPercent2level2 = 50;       
154     uint public cashbackPercent2level3 = 70;       
155 
156     // 3 action
157     uint public beginCashBackTime3 = 1543363199;     // begin of the action 27.11.2018 
158     uint public endCashBackTime3 = 1543535999;       // end of the action 29.11.2018
159     uint public cashbackPercent3level1 = 50;       
160     uint public cashbackPercent3level2 = 80;       
161     uint public cashbackPercent3level3 = 100;      
162 
163     // 4 action
164     uint public beginCashBackTime4 = 1544399999;     // begin of the action 9.12.2018
165     uint public endCashBackTime4 = 1544572799;       // end of the action 11.12.2018 
166     uint public cashbackPercent4level1 = 70;       
167     uint public cashbackPercent4level2 = 100;       
168     uint public cashbackPercent4level3 = 150;      
169 
170     // 5 action
171     uint public beginCashBackTime5 = 1545436799;     // begin of the action 21.12.2018
172     uint public endCashBackTime5 = 1545523199;       // end of the action 22.12.2018 
173     uint public cashbackPercent5level1 = 25;       
174     uint public cashbackPercent5level2 = 35;       
175     uint public cashbackPercent5level3 = 50;      
176 
177     // 6 action
178     uint public beginCashBackTime6 = 1546473599;     // begin of the action 02.01.2019 
179     uint public endCashBackTime6 = 1546646399;       // end of the action 04.01.2019
180     uint public cashbackPercent6level1 = 30;       
181     uint public cashbackPercent6level2 = 50;       
182     uint public cashbackPercent6level3 = 70;      
183 
184     // 7 action
185     uint public beginCashBackTime7 = 1547510399;     // begin of the action 14.01.2019
186     uint public endCashBackTime7 = 1547683199;       // end of the action 16.01.2019
187     uint public cashbackPercent7level1 = 50;       
188     uint public cashbackPercent7level2 = 80;       
189     uint public cashbackPercent7level3 = 100;      
190 
191     // 8 action
192     uint public beginCashBackTime8 = 1548547199;     // begin of the action 26.01.2019
193     uint public endCashBackTime8 = 1548719999;       // end of the action 28.01.2019
194     uint public cashbackPercent8level1 = 70;       
195     uint public cashbackPercent8level2 = 100;       
196     uint public cashbackPercent8level3 = 150;      
197 
198 
199     modifier isIssetUser() {
200         require(userDeposit[msg.sender] > 0, "Deposit not found");
201         _;
202     }
203 
204     modifier timePayment() {
205         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
206         _;
207     }
208 
209     function() external payable {
210         require (msg.sender != marketingFund && msg.sender != devFund);
211         makeDeposit();
212     }
213 
214 
215     //make a contribution to the system
216     function makeDeposit() nonReentrant private {
217         if (usersCashback[msg.sender] > 0) collectCashback();
218         if (msg.value > 0) {
219 
220             if (!alreadyDeposited[msg.sender]) {
221                 countOfInvestors += 1;
222                 address referrer = bytesToAddress(msg.data);
223                 if (referrer != msg.sender) userReferral[msg.sender] = referrer;
224                 alreadyDeposited[msg.sender] = true;
225             }
226 
227             if (userReferral[msg.sender] != address(0)) {
228                 uint refAmount = msg.value.mul(refPercent).div(100);
229                 userReferral[msg.sender].transfer(refAmount);
230                 refferalCollected[userReferral[msg.sender]] = refferalCollected[userReferral[msg.sender]].add(refAmount);
231             }
232 
233             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
234                 collectPercent();
235             }
236 
237             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
238             userTime[msg.sender] = now;
239             chargeCashBack();
240 
241             //sending money for marketing
242             marketingFund.transfer(msg.value.mul(marketingPercent).div(100));
243             //sending money to dev team
244             uint devMoney = msg.value.mul(devPercent).div(100);
245             countOfDev = countOfDev.add(devMoney);
246             devFund.transfer(devMoney);
247 
248         } else {
249             collectPercent();
250         }
251     }
252 
253     function collectCashback() private {
254         uint val = usersCashback[msg.sender];
255         usersCashback[msg.sender] = 0;
256         msg.sender.transfer(val);
257     }
258 
259     // check cashback action and cashback accrual
260     function chargeCashBack() private {
261         uint cashbackValue = 0;
262         // action 1
263         if ( (now >= beginCashBackTime1) && (now<=endCashBackTime1) ){
264             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent1level1).div(1000);
265             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent1level2).div(1000);
266             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent1level3).div(1000);
267         }
268         // action 2
269         if ( (now >= beginCashBackTime2) && (now<=endCashBackTime2) ){
270             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent2level1).div(1000);
271             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent2level2).div(1000);
272             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent2level3).div(1000);
273         }
274         // action 3
275         if ( (now >= beginCashBackTime3) && (now<=endCashBackTime3) ){
276             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent3level1).div(1000);
277             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent3level2).div(1000);
278             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent3level3).div(1000);
279         }
280         // action 4
281         if ( (now >= beginCashBackTime4) && (now<=endCashBackTime4) ){
282             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent4level1).div(1000);
283             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent4level2).div(1000);
284             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent4level3).div(1000);
285         }
286         // action 5
287         if ( (now >= beginCashBackTime5) && (now<=endCashBackTime5) ){
288             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent5level1).div(1000);
289             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent5level2).div(1000);
290             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent5level3).div(1000);
291         }
292         // action 6
293         if ( (now >= beginCashBackTime6) && (now<=endCashBackTime6) ){
294             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent6level1).div(1000);
295             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent6level2).div(1000);
296             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent6level3).div(1000);
297         }
298         // action 7
299         if ( (now >= beginCashBackTime7) && (now<=endCashBackTime7) ){
300             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent7level1).div(1000);
301             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent7level2).div(1000);
302             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent7level3).div(1000);
303         }
304         // action 8
305         if ( (now >= beginCashBackTime8) && (now<=endCashBackTime8) ){
306             if ( (msg.value >= minDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel1) ) cashbackValue = msg.value.mul(cashbackPercent8level1).div(1000);
307             if ( (msg.value > maxDepCashBackLevel1) && (msg.value <= maxDepCashBackLevel2) ) cashbackValue = msg.value.mul(cashbackPercent8level2).div(1000);
308             if ( (msg.value > maxDepCashBackLevel2) && (msg.value <= maxDepCashBackLevel3) ) cashbackValue = msg.value.mul(cashbackPercent8level3).div(1000);
309         }
310 
311         usersCashback[msg.sender] = usersCashback[msg.sender].add(cashbackValue);
312     }
313     
314     //return of interest on the deposit
315     function collectPercent() isIssetUser timePayment internal {
316         //if the user received 150% or more of his contribution, delete the user
317         if ((userDeposit[msg.sender].mul(15).div(10)) <= persentWithdraw[msg.sender]) {
318             userDeposit[msg.sender] = 0;
319             userTime[msg.sender] = 0;
320             persentWithdraw[msg.sender] = 0;
321         } else {
322             uint payout = payoutAmount();
323             userTime[msg.sender] = now;
324             persentWithdraw[msg.sender] += payout;
325             msg.sender.transfer(payout);
326         }
327     }
328 
329 
330     function bytesToAddress(bytes bys) private pure returns (address addr) {
331         assembly {
332             addr := mload(add(bys, 20))
333         }
334     }
335 
336     //refund of the amount available for withdrawal on deposit
337     function payoutAmount() public view returns(uint) {
338         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
339         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
340         uint withdrawalAmount = rate.mul(interestRate).add(usersCashback[msg.sender]);
341         return (withdrawalAmount);
342     }
343 
344     function userPayoutAmount(address _user) public view returns(uint) {
345         uint rate = userDeposit[_user].mul(persent).div(100000);
346         uint interestRate = now.sub(userTime[_user]).div(chargingTime);
347         uint withdrawalAmount = rate.mul(interestRate).add(usersCashback[_user]);
348         return (withdrawalAmount);
349     }
350 
351     function getInvestedAmount(address investor) public view returns(uint) {
352         return userDeposit[investor];
353     }
354     
355     function getLastDepositeTime(address investor) public view returns(uint) {
356         return userTime[investor];
357     }
358     
359     function getPercentWitdraw(address investor) public view returns(uint) {
360         return persentWithdraw[investor];
361     }
362     
363     function getRefferalsCollected(address refferal) public view returns(uint) {
364         return refferalCollected[refferal];
365     }
366     
367 }