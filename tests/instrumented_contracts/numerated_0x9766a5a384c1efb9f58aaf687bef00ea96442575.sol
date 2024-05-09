1 /**
2 * start 21.11.18
3 *
4 * ███─█───█─████─████─███─█───█─█───█─█───█───████─████─█───█
5 * █───██─██─█──█─█──█──█──██─██─██─██─██─██───█──█─█──█─██─██
6 * ███─█─█─█─████─████──█──█─█─█─█─█─█─█─█─█───█────█──█─█─█─█
7 * ──█─█───█─█──█─█─█───█──█───█─█───█─█───█───█──█─█──█─█───█
8 * ███─█───█─█──█─█─█───█──█───█─█───█─█───█─█─████─████─█───█
9 *
10 *
11 * - Contacts:
12 *     -- t.me/Smart_MMM
13 *     -- https://SmartMMM.com
14 *
15 * - GAIN PER 24 HOURS:
16 *     -- Contract balance <   25 Ether:          1.0%
17 *     -- Contract balance >= 25 Ether:              1.5%
18 *     -- Contract balance >= 250 Ether:                2.0%
19 *     -- Contract balance >= 2500 Ether:                  2.5% max!
20 *     -- Contract balance >= 10000 Ether:              2.0%
21 *     -- Contract balance >= 20000 Ether:           1.5%
22 *     -- Contract balance >= 30000 Ether:       1.0%
23 *     -- Contract balance >= 40000 Ether:      0.8%
24 *     -- Contract balance >= 50000 Ether:     0.6%
25 *     -- Contract balance >= 60000 Ether:    0.4%
26 *     -- Contract balance >= 70000 Ether:   0.2%
27 *     -- Contract balance >= 100000 Ether:  0.1%
28 *
29 *     -- Contract balance < 30% max Balance: "soft restart"
30 *
31 * - Minimal contribution 0.01 eth
32 *
33 * - Contribution allocation schemes:
34 *    -- 90-95% payments to depositors and partners
35 *    -- 1-3% technical support team
36 *    -- 3-7% promotion
37 *   depends on the contract balance. more on the website SmartMMM.com
38 *
39 * - How to use:
40 *  1. Send from your personal ETH wallet to the smart-contract address any amount more than or equal to 0.01 ETH
41 *  2. Add your refferer's wallet to a HEX data in your transaction to
42 *      get a bonus amount back to your wallet
43 *      if there is no referrer, you will not get any bonuses
44 *  3. Use etherscan.io to verify your transaction
45 *  4. Claim your dividents by sending 0 ether transaction (available anytime)
46 *  5. You can reinvest anytime you want
47 *
48 * Smart contract has a "soft restart" function, details on smartMMM.com
49 *
50 * If you want to check your dividends, you can use etherscan.io site I / o by following the" internal Txns " tab of your wallet
51 * Attention: do not use wallets exchanges - you will lose your money. Use your personal wallet only for transactions
52 *
53 * RECOMMENDED GAS LIMIT: 300000
54 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
55 */
56 
57 pragma solidity ^0.4.24;
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address private _owner;
66 
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() internal {
77     _owner = msg.sender;
78     emit OwnershipTransferred(address(0), _owner);
79   }
80 
81   /**
82    * @return the address of the owner.
83    */
84   function owner() public view returns(address) {
85     return _owner;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(isOwner());
93     _;
94   }
95 
96   /**
97    * @return true if `msg.sender` is the owner of the contract.
98    */
99   function isOwner() public view returns(bool) {
100     return msg.sender == _owner;
101   }
102 
103   /**
104    * @dev Allows the current owner to relinquish control of the contract.
105    * @notice Renouncing to ownership will leave the contract without an owner.
106    * It will not be possible to call the functions with the `onlyOwner`
107    * modifier anymore.
108    */
109   function renounceOwnership() public onlyOwner {
110     emit OwnershipTransferred(_owner, address(0));
111     _owner = address(0);
112   }
113 
114   /**
115    * @dev Allows the current owner to transfer control of the contract to a newOwner.
116    * @param newOwner The address to transfer ownership to.
117    */
118   function transferOwnership(address newOwner) public onlyOwner {
119     _transferOwnership(newOwner);
120   }
121 
122   /**
123    * @dev Transfers control of the contract to a newOwner.
124    * @param newOwner The address to transfer ownership to.
125    */
126   function _transferOwnership(address newOwner) internal {
127     require(newOwner != address(0));
128     emit OwnershipTransferred(_owner, newOwner);
129     _owner = newOwner;
130   }
131 }
132 
133 contract SmartMMM is Ownable
134 {
135     struct DepositItem {
136         uint time;
137         uint sum;
138         uint withdrawalTime;
139         uint restartIndex;
140         uint invested;
141         uint payments;
142         uint referralPayments;
143         uint cashback;
144         uint referalsLevelOneCount;
145         uint referalsLevelTwoCount;
146         address referrerLevelOne;
147         address referrerLevelTwo;
148     }
149 
150     address public techSupport = 0x799358af628240603A1ce05b7D9ea211b9D64304;
151     address public adsSupport = 0x8Fa6E56c844be9B96C30B72cC2a8ccF6465a99F9;
152 
153     mapping(address => DepositItem) public deposits;
154     mapping(address => bool) public referrers;
155     mapping(address => uint) public waitingReferrers;
156 
157     uint public referrerPrice = 70700000000000000; // 0.0707 ether
158     uint public referrerBeforeEndTime = 0;
159     uint public maxBalance = 0;
160     uint public invested;
161     uint public payments;
162     uint public referralPayments;
163     uint public investorsCount;
164     uint[] public historyOfRestarts;
165 
166     event Deposit(address indexed from, uint256 value);
167     event Withdraw(address indexed to, uint256 value);
168     event PayBonus(address indexed to, uint256 value);
169 
170     constructor () public
171     {
172         historyOfRestarts.push(now);
173     }
174 
175 
176     function bytesToAddress(bytes source) private pure returns(address parsedAddress)
177     {
178         assembly {
179             parsedAddress := mload(add(source,0x14))
180         }
181         return parsedAddress;
182     }
183 
184     function getPercents(uint balance) public pure returns(uint depositPercent, uint referrerLevelOnePercent, uint referrerLevelTwoPercent, uint cashBackPercent, uint techSupportPercent, uint adsSupportPercent)
185     {
186         if(balance < 25 ether) return (69444444444, 90, 10, 20, 30, 60);
187         else if(balance >= 25 ether && balance < 250 ether) return (104166666667, 80, 10, 20, 30, 60);
188         else if(balance >= 250 ether && balance < 2500 ether ) return (138888888889, 70, 10, 20, 30, 60);
189         else if(balance >= 2500 ether && balance < 10000 ether) return (173611111111, 60, 10, 20, 30, 60);
190         else if(balance >= 10000 ether && balance < 20000 ether) return (138888888889, 50, 10, 15, 25, 50);
191         else if(balance >= 20000 ether && balance < 30000 ether) return (104166666667, 40, 5, 15, 25, 50);
192         else if(balance >= 30000 ether && balance < 40000 ether) return (69444444444, 30, 5, 10, 20, 40);
193         else if(balance >= 40000 ether && balance < 50000 ether) return (55555555555, 20, 5, 5, 20, 40);
194         else if(balance >= 50000 ether && balance < 60000 ether) return (416666666667, 10, 5, 5, 15, 30);
195         else if(balance >= 60000 ether && balance < 70000 ether) return (277777777778, 8, 3, 3, 10, 20);
196         else if(balance >= 70000 ether && balance < 100000 ether) return (138888888889, 5, 2, 2, 10, 20);
197         else return (6944444444, 0, 0, 0, 10, 10);
198     }
199 
200     function () public payable
201     {
202         uint balance = address(this).balance;
203         (uint depositPercent, uint referrerLevelOnePercent, uint referrerLevelTwoPercent, uint cashBackPercent, uint techSupportPercent, uint adsSupportPercent) = getPercents(balance);
204 
205         if(msg.value == 0)
206         {
207             payWithdraw(msg.sender, balance, depositPercent);
208             return;
209         }
210 
211         if(msg.value == referrerPrice && !referrers[msg.sender] && waitingReferrers[msg.sender] == 0 && deposits[msg.sender].sum != 0)
212         {
213             waitingReferrers[msg.sender] = now;
214         }
215         else
216         {
217             addDeposit(msg.sender, msg.value, balance, referrerLevelOnePercent, referrerLevelTwoPercent, cashBackPercent, depositPercent, techSupportPercent, adsSupportPercent);
218         }
219     }
220 
221     function isNeedRestart(uint balance) public returns (bool)
222     {
223         if(balance < maxBalance / 100 * 30) {
224             maxBalance = 0;
225             return true;
226         }
227         return false;
228     }
229 
230     function calculateNewTime(uint oldTime, uint oldSum, uint newSum, uint currentTime) public pure returns (uint)
231     {
232         return oldTime + newSum / (newSum + oldSum) * (currentTime - oldTime);
233     }
234 
235     function calculateNewDepositSum(uint minutesBetweenRestart, uint minutesWork, uint depositSum) public pure returns (uint)
236     {
237         if(minutesWork > minutesBetweenRestart) minutesWork = minutesBetweenRestart;
238         return (depositSum *(100-(uint(minutesWork) * 100 / minutesBetweenRestart)+7)/100);
239     }
240 
241     function addDeposit(address investorAddress, uint weiAmount, uint balance, uint referrerLevelOnePercent, uint referrerLevelTwoPercent, uint cashBackPercent, uint depositPercent, uint techSupportPercent, uint adsSupportPercent) private
242     {
243         checkReferrer(investorAddress, weiAmount, referrerLevelOnePercent, referrerLevelTwoPercent, cashBackPercent);
244         DepositItem memory deposit = deposits[investorAddress];
245         if(deposit.sum == 0)
246         {
247             deposit.time = now;
248             investorsCount++;
249         }
250         else
251         {
252             uint sum = getWithdrawSum(investorAddress, depositPercent);
253             deposit.sum += sum;
254             deposit.time = calculateNewTime(deposit.time, deposit.sum, weiAmount, now);
255         }
256         deposit.withdrawalTime = now;
257         deposit.sum += weiAmount;
258         deposit.restartIndex = historyOfRestarts.length - 1;
259         deposit.invested += weiAmount;
260         deposits[investorAddress] = deposit;
261 
262         emit Deposit(investorAddress, weiAmount);
263 
264         payToSupport(weiAmount, techSupportPercent, adsSupportPercent);
265 
266         if (maxBalance < balance) {
267             maxBalance = balance;
268         }
269         invested += weiAmount;
270     }
271 
272     function payToSupport(uint weiAmount, uint techSupportPercent, uint adsSupportPercent) private {
273         techSupport.transfer(weiAmount * techSupportPercent / 1000);
274         adsSupport.transfer(weiAmount * adsSupportPercent / 1000);
275     }
276 
277     function checkReferrer(address investorAddress, uint weiAmount, uint referrerLevelOnePercent, uint referrerLevelTwoPercent, uint cashBackPercent) private
278     {
279         address referrerLevelOneAddress = deposits[investorAddress].referrerLevelOne;
280         address referrerLevelTwoAddress = deposits[investorAddress].referrerLevelTwo;
281         if (deposits[investorAddress].sum == 0 && msg.data.length == 20) {
282             referrerLevelOneAddress = bytesToAddress(bytes(msg.data));
283             if (referrerLevelOneAddress != investorAddress && referrerLevelOneAddress != address(0)) {
284                 if (referrers[referrerLevelOneAddress] || waitingReferrers[referrerLevelOneAddress] != 0 && (now - waitingReferrers[referrerLevelOneAddress]) >= 7 days || now <= referrerBeforeEndTime) {
285                     deposits[investorAddress].referrerLevelOne = referrerLevelOneAddress;
286                     deposits[referrerLevelOneAddress].referalsLevelOneCount++;
287                     referrerLevelTwoAddress = deposits[referrerLevelOneAddress].referrerLevelOne;
288                     if (referrerLevelTwoAddress != investorAddress && referrerLevelTwoAddress != address(0)) {
289                         deposits[investorAddress].referrerLevelTwo = referrerLevelTwoAddress;
290                         deposits[referrerLevelTwoAddress].referalsLevelTwoCount++;
291                     }
292                 }
293             }
294         }
295         if (referrerLevelOneAddress != address(0)) {
296             uint cashBackBonus = weiAmount * cashBackPercent / 1000;
297             uint referrerLevelOneBonus = weiAmount * referrerLevelOnePercent / 1000;
298 
299             emit PayBonus(investorAddress, cashBackBonus);
300             emit PayBonus(referrerLevelOneAddress, referrerLevelOneBonus);
301 
302             referralPayments += referrerLevelOneBonus;
303             deposits[referrerLevelOneAddress].referralPayments += referrerLevelOneBonus;
304             referrerLevelOneAddress.transfer(referrerLevelOneBonus);
305 
306             deposits[investorAddress].cashback += cashBackBonus;
307             investorAddress.transfer(cashBackBonus);
308 
309             if (referrerLevelTwoAddress != address(0)) {
310                 uint referrerLevelTwoBonus = weiAmount * referrerLevelTwoPercent / 1000;
311                 emit PayBonus(referrerLevelTwoAddress, referrerLevelTwoBonus);
312                 referralPayments += referrerLevelTwoBonus;
313                 deposits[referrerLevelTwoAddress].referralPayments += referrerLevelTwoBonus;
314                 referrerLevelTwoAddress.transfer(referrerLevelTwoBonus);
315             }
316         }
317     }
318 
319     function payWithdraw(address to, uint balance, uint percent) private
320     {
321         require(deposits[to].sum > 0);
322 
323         if(isNeedRestart(balance))
324         {
325             historyOfRestarts.push(now);
326         }
327 
328         uint lastRestartIndex = historyOfRestarts.length - 1;
329 
330         if(lastRestartIndex - deposits[to].restartIndex >= 1)
331         {
332             uint minutesBetweenRestart = (historyOfRestarts[lastRestartIndex] - historyOfRestarts[deposits[to].restartIndex]) / 1 minutes;
333             uint minutesWork = (historyOfRestarts[lastRestartIndex] - deposits[to].time) / 1 minutes;
334             deposits[to].sum = calculateNewDepositSum(minutesBetweenRestart, minutesWork, deposits[to].sum);
335             deposits[to].restartIndex = lastRestartIndex;
336             deposits[to].time = now;
337         }
338 
339         uint sum = getWithdrawSum(to, percent);
340         require(sum > 0);
341 
342         deposits[to].withdrawalTime = now;
343         deposits[to].payments += sum;
344         payments += sum;
345         to.transfer(sum);
346 
347         emit Withdraw(to, sum);
348     }
349 
350     function getWithdrawSum(address investorAddress, uint percent) private view returns(uint sum) {
351         uint minutesCount = (now - deposits[investorAddress].withdrawalTime) / 1 minutes;
352         sum = deposits[investorAddress].sum * percent / 10000000000000000 * minutesCount;
353     }
354 
355     function addReferrer(address referrerAddress) onlyOwner public
356     {
357         referrers[referrerAddress] = true;
358     }
359 
360     function setReferrerPrice(uint newPrice) onlyOwner public
361     {
362         referrerPrice = newPrice;
363     }
364 
365     function setReferrerBeforeEndTime(uint newTime) onlyOwner public
366     {
367         referrerBeforeEndTime = newTime;
368     }
369 
370     function getDaysAfterStart() public constant returns(uint daysAfterStart) {
371         daysAfterStart = (now - historyOfRestarts[0]) / 1 days;
372     }
373 
374     function getDaysAfterLastRestart() public constant returns(uint daysAfeterLastRestart) {
375         daysAfeterLastRestart = (now - historyOfRestarts[historyOfRestarts.length - 1]) / 1 days;
376     }
377 }