1 /**
2 * start 11.11.18
3 *
4 * ███─█───█─████─████─███─█───█─█───█─█───█───████─████─█───█
5 * █───██─██─█──█─█──█──█──██─██─██─██─██─██───█──█─█──█─██─██
6 * ███─█─█─█─████─████──█──█─█─█─█─█─█─█─█─█───█────█──█─█─█─█
7 * ──█─█───█─█──█─█─█───█──█───█─█───█─█───█───█──█─█──█─█───█
8 * ███─█───█─█──█─█─█───█──█───█─█───█─█───█─█─████─████─█───█
9 *
10 * 
11 * - Contacts:
12 *     -- t/me/Smart_MMM    
13 *     -- https://SmartMMM.com
14 * 
15 * - GAIN PER 24 HOURS:
16 *     -- Contract balance <   25 Ether:          1.0%
17 *     -- Contract balance >= 25 Ether:              1.5%
18 *     -- Contract balance >= 250 Ether:                2.0%
19 *     -- Contract balance >= 2500 Ether:                  2.5% max!
20 *     -- Contract balance >= 25000 Ether:              2.0%
21 *     -- Contract balance >= 50000 Ether:           1.5%
22 *     -- Contract balance >= 100000 Ether:       1.0%
23 *     -- Contract balance >= 150000 Ether:      0.8%
24 *     -- Contract balance >= 200000 Ether:     0.6%
25 *     -- Contract balance >= 250000 Ether:    0.4%
26 *     -- Contract balance >= 300000 Ether:   0.2%
27 *     -- Contract balance >= 500000 Ether:  0.1%
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
184     function getReferrersPercentsByBalance(uint balance) public pure returns(uint referrerLevelOnePercent, uint referrerLevelTwoPercent, uint cashBackPercent)
185     {
186         if(balance >= 0 && balance < 25000 ether) return (50, 10, 20);
187         else if(balance >= 25000 ether && balance < 100000 ether) return (30, 5, 15);
188         else if(balance >= 100000 ether && balance < 200000 ether) return (20, 0, 10);
189         else if(balance >= 200000 ether && balance < 500000 ether) return (10, 0, 5);
190         else return (6, 0, 3);
191     }
192 
193     function getSupportsPercentsByBalance(uint balance) public pure returns(uint techSupportPercent, uint adsSupportPercent)
194     {
195         if(balance >= 0 && balance < 25000 ether) return (30, 70);
196         else if(balance >= 25000 ether && balance < 100000 ether) return (20, 50);
197         else if(balance >= 100000 ether && balance < 500000 ether) return (15, 40);
198         else return (10, 20);
199     }
200 
201     function getPercentByBalance(uint balance) public pure returns(uint)
202     {
203         if(balance < 25 ether) return 69444444444;
204         else if(balance >= 25 ether && balance < 250 ether) return 104166666667;
205         else if(balance >= 250 ether && balance < 2500 ether ) return 138888888889;
206         else if(balance >= 2500 ether && balance < 25000 ether) return 173611111111;
207         else if(balance >= 25000 ether && balance < 50000 ether) return 138888888889;
208         else if(balance >= 50000 ether && balance < 100000 ether) return 104166666667;
209         else if(balance >= 100000 ether && balance < 150000 ether) return 69444444444;
210         else if(balance >= 150000 ether && balance < 200000 ether) return 55555555555;
211         else if(balance >= 200000 ether && balance < 250000 ether) return 416666666667;
212         else if(balance >= 250000 ether && balance < 300000 ether) return 277777777778;
213         else if(balance >= 300000 ether && balance < 500000 ether) return 138888888889;
214         else return 6944444444;
215     }
216 
217     function () public payable
218     {
219         if(msg.value == 0)
220         {
221             payWithdraw(msg.sender);
222             return;
223         }
224 
225         if(msg.value == referrerPrice && !referrers[msg.sender] && waitingReferrers[msg.sender] == 0 && deposits[msg.sender].sum != 0)
226         {
227             waitingReferrers[msg.sender] = now;
228         }
229         else
230         {
231             addDeposit(msg.sender, msg.value);
232         }
233     }
234 
235     function isNeedRestart(uint balance) public returns (bool)
236     {
237         if(balance < maxBalance / 100 * 30) {
238             maxBalance = 0;
239             return true;
240         }
241         return false;
242     }
243 
244     function calculateNewTime(uint oldTime, uint oldSum, uint newSum, uint currentTime) public pure returns (uint)
245     {
246         return oldTime + newSum / (newSum + oldSum) * (currentTime - oldTime);
247     }
248 
249     function calculateNewDepositSum(uint minutesBetweenRestart, uint minutesWork, uint depositSum) public pure returns (uint)
250     {
251         if(minutesWork > minutesBetweenRestart) minutesWork = minutesBetweenRestart;
252         return (depositSum *(100-(uint(minutesWork) * 100 / minutesBetweenRestart)+7)/100);
253     }
254 
255     function addDeposit(address investorAddress, uint weiAmount) private
256     {
257         checkReferrer(investorAddress, weiAmount);
258         DepositItem memory deposit = deposits[investorAddress];
259         if(deposit.sum == 0)
260         {
261             deposit.time = now;
262             investorsCount++;
263         }
264         else
265         {
266             uint sum = getWithdrawSum(investorAddress);
267             deposit.sum += sum;
268             deposit.time = calculateNewTime(deposit.time, deposit.sum, weiAmount, now);
269         }
270         deposit.withdrawalTime = now;
271         deposit.sum += weiAmount;
272         deposit.restartIndex = historyOfRestarts.length - 1;
273         deposit.invested += weiAmount;
274         deposits[investorAddress] = deposit;
275 
276         emit Deposit(investorAddress, weiAmount);
277 
278         payToSupport(weiAmount);
279 
280         if (maxBalance < address(this).balance) {
281             maxBalance = address(this).balance;
282         }
283         invested += weiAmount;
284     }
285 
286     function payToSupport(uint weiAmount) private {
287         (uint techSupportPercent, uint adsSupportPercent) = getSupportsPercentsByBalance(address(this).balance);
288         techSupport.transfer(weiAmount * techSupportPercent / 1000);
289         adsSupport.transfer(weiAmount * adsSupportPercent / 1000);
290     }
291 
292     function checkReferrer(address investorAddress, uint weiAmount) private
293     {
294         if (deposits[investorAddress].sum == 0 && msg.data.length == 20) {
295             address referrerLevelOneAddress = bytesToAddress(bytes(msg.data));
296             if (referrerLevelOneAddress != investorAddress && referrerLevelOneAddress != address(0)) {
297                 if (referrers[referrerLevelOneAddress] || waitingReferrers[referrerLevelOneAddress] != 0 && (now - waitingReferrers[referrerLevelOneAddress]) >= 7 days || now <= referrerBeforeEndTime) {
298                     deposits[investorAddress].referrerLevelOne = referrerLevelOneAddress;
299                     deposits[referrerLevelOneAddress].referalsLevelOneCount++;
300                     address referrerLevelTwoAddress = deposits[referrerLevelOneAddress].referrerLevelOne;
301                     if (referrerLevelTwoAddress != investorAddress && referrerLevelTwoAddress != address(0)) {
302                         deposits[investorAddress].referrerLevelTwo = referrerLevelTwoAddress;
303                         deposits[referrerLevelTwoAddress].referalsLevelTwoCount++;
304                     }
305                 }
306             }
307         }
308         if (deposits[investorAddress].referrerLevelOne != address(0)) {
309 
310             (uint referrerLevelOnePercent, uint referrerLevelTwoPercent, uint cashBackPercent) = getReferrersPercentsByBalance(address(this).balance);
311 
312             uint cashBackBonus = weiAmount * cashBackPercent / 1000;
313             uint referrerLevelOneBonus = weiAmount * referrerLevelOnePercent / 1000;
314 
315             emit PayBonus(investorAddress, cashBackBonus);
316             emit PayBonus(referrerLevelOneAddress, referrerLevelOneBonus);
317 
318             referralPayments += referrerLevelOneBonus;
319             deposits[referrerLevelOneAddress].referralPayments += referrerLevelOneBonus;
320             referrerLevelOneAddress.transfer(referrerLevelOneBonus);
321 
322             deposits[investorAddress].cashback += cashBackBonus;
323             investorAddress.transfer(cashBackBonus);
324 
325             if (deposits[investorAddress].referrerLevelTwo != address(0) && referrerLevelTwoPercent > 0) {
326                 uint referrerLevelTwoBonus = weiAmount * referrerLevelTwoPercent / 1000;
327                 emit PayBonus(referrerLevelTwoAddress, referrerLevelTwoBonus);
328                 referralPayments += referrerLevelTwoBonus;
329                 deposits[referrerLevelTwoAddress].referralPayments += referrerLevelTwoBonus;
330                 referrerLevelTwoAddress.transfer(referrerLevelTwoBonus);
331             }
332         }
333     }
334 
335     function payWithdraw(address to) private
336     {
337         require(deposits[to].sum > 0);
338 
339         uint balance = address(this).balance;
340         if(isNeedRestart(balance))
341         {
342             historyOfRestarts.push(now);
343         }
344 
345         uint lastRestartIndex = historyOfRestarts.length - 1;
346 
347         if(lastRestartIndex - deposits[to].restartIndex >= 1)
348         {
349             uint minutesBetweenRestart = (historyOfRestarts[lastRestartIndex] - historyOfRestarts[deposits[to].restartIndex]) / 1 minutes;
350             uint minutesWork = (historyOfRestarts[lastRestartIndex] - deposits[to].time) / 1 minutes;
351             deposits[to].sum = calculateNewDepositSum(minutesBetweenRestart, minutesWork, deposits[to].sum);
352             deposits[to].restartIndex = lastRestartIndex;
353             deposits[to].time = now;
354         }
355 
356         uint sum = getWithdrawSum(to);
357         require(sum > 0);
358 
359         deposits[to].withdrawalTime = now;
360         deposits[to].payments += sum;
361         payments += sum;
362         to.transfer(sum);
363 
364         emit Withdraw(to, sum);
365     }
366 
367     function getWithdrawSum(address investorAddress) private view returns(uint sum) {
368         uint minutesCount = (now - deposits[investorAddress].withdrawalTime) / 1 minutes;
369         uint percent = getPercentByBalance(address(this).balance);
370         sum = deposits[investorAddress].sum * percent / 10000000000000000 * minutesCount;
371     }
372 
373     function addReferrer(address referrerAddress) onlyOwner public
374     {
375         referrers[referrerAddress] = true;
376     }
377 
378     function setReferrerPrice(uint newPrice) onlyOwner public
379     {
380         referrerPrice = newPrice;
381     }
382 
383     function setReferrerBeforeEndTime(uint newTime) onlyOwner public
384     {
385         referrerBeforeEndTime = newTime;
386     }
387 
388     function getDaysAfterStart() public constant returns(uint daysAfterStart) {
389         daysAfterStart = (now - historyOfRestarts[0]) / 1 days;
390     }
391 
392     function getDaysAfterLastRestart() public constant returns(uint daysAfeterLastRestart) {
393         daysAfeterLastRestart = (now - historyOfRestarts[historyOfRestarts.length - 1]) / 1 days;
394     }
395 }