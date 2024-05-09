1 pragma solidity ^0.4.24;
2 /***
3  * @title -ETH4 v0.1.0
4  * 
5  *
6  * .----------------.  .----------------.  .----------------.  .----------------. 
7  * | .--------------. || .--------------. || .--------------. || .--------------. |
8  * | |  _________   | || |  _________   | || |  ____  ____  | || |   _    _     | |
9  * | | |_   ___  |  | || | |  _   _  |  | || | |_   ||   _| | || |  | |  | |    | |
10  * | |   | |_  \_|  | || | |_/ | | \_|  | || |   | |__| |   | || |  | |__| |_   | |
11  * | |   |  _|  _   | || |     | |      | || |   |  __  |   | || |  |____   _|  | |
12  * | |  _| |___/ |  | || |    _| |_     | || |  _| |  | |_  | || |      _| |_   | |
13  * | | |_________|  | || |   |_____|    | || | |____||____| | || |     |_____|  | |
14  * | |              | || |              | || |              | || |              | |
15  * | '--------------' || '--------------' || '--------------' || '--------------' |
16  * '----------------'  '----------------'  '----------------'  '----------------' 
17  *                                  ┌───────────────────────────────────────┐  
18  *                                  │   Website:  http://Eth4.club          │
19  *                                  │   Discord:  https://discord.gg/Uj72bZR│  
20  *                                  │   Telegram: https://t.me/eth4_club    │
21  *                                  │CN Telegram: https://t.me/eth4_club_CN │
22  *                                  │RU Telegram: https://t.me/Eth4_Club_RU │
23  *                                  └───────────────────────────────────────┘  
24  *
25  * This product is provided for public use without any guarantee or recourse to appeal
26  * 
27  * Payouts are collectible daily after 00:00 UTC
28  * Referral rewards are distributed automatically.
29  * The last 5 in before 00:00 UTC win the midnight prize.
30  * 
31  * By sending ETH to this contract you are agreeing to the terms set out in the logic listed below.
32  *
33  * WARNING1:  Do not invest more than you can afford. 
34  * WARNING2:  You can earn. 
35  */
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address private _owner;
45 
46   event OwnershipRenounced(address indexed previousOwner);
47   event OwnershipTransferred(
48     address indexed previousOwner,
49     address indexed newOwner
50   );
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57     _owner = msg.sender;
58   }
59 
60   /**
61    * @return the address of the owner.
62    */
63   function owner() public view returns(address) {
64     return _owner;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(isOwner());
72     _;
73   }
74 
75   /**
76    * @return true if `msg.sender` is the owner of the contract.
77    */
78   function isOwner() public view returns(bool) {
79     return msg.sender == _owner;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     _transferOwnership(newOwner);
88   }
89 
90   /**
91    * @dev Transfers control of the contract to a newOwner.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function _transferOwnership(address newOwner) internal {
95     require(newOwner != address(0));
96     emit OwnershipTransferred(_owner, newOwner);
97     _owner = newOwner;
98   }
99 }
100 
101 
102 /***
103  *     __ __  __  _ __  _    ___ __  __  _ _____ ___  __   ________
104  *    |  V  |/  \| |  \| |  / _//__\|  \| |_   _| _ \/  \ / _/_   _|
105  *    | \_/ | /\ | | | ' | | \_| \/ | | ' | | | | v / /\ | \__ | |
106  *    |_| |_|_||_|_|_|\__|  \__/\__/|_|\__| |_| |_|_\_||_|\__/ |_|
107  */
108 contract ETH4CLUB is Ownable {
109   using SafeMath
110   for uint;
111 
112   modifier isHuman() {
113     uint32 size;
114     address investor = msg.sender;
115     assembly {
116       size: = extcodesize(investor)
117     }
118     if (size > 0) {
119       revert("Inhuman");
120     }
121     _;
122   }
123 
124   event DailyDividendPayout(address indexed _address, uint value, uint periodCount, uint percent, uint time);
125   event ReferralPayout(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time);
126   event MidnightRunPayout(address indexed _address, uint value, uint totalValue, uint userValue, uint time);
127 
128   uint public period = 24 hours;
129   uint public startTime = 1538186400; //  Fri, 29 Sep 2018 02:00:00 +0000 UTC
130 
131   uint public dailyDividendPercent = 300; //3%
132   uint public referredDividendPercent = 400; //4%
133 
134   uint public referrerPercent = 300; //3%
135   uint public minBetLevel = 0.01 ether;
136 
137   uint public referrerAndOwnerPercent = 2000; //20%
138   uint public currentStakeID = 1;
139 
140   struct DepositInfo {
141     uint value;
142     uint firstBetTime;
143     uint lastBetTime;
144     uint lastPaymentTime;
145     uint nextPayAfterTime;
146     bool isExist;
147     uint id;
148     uint referrerID;
149   }
150 
151   mapping(address => DepositInfo) public investorToDepostIndex;
152   mapping(uint => address) public idToAddressIndex;
153 
154   // Jackpot
155   uint public midnightPrizePercent = 1000; //10%
156   uint public midnightPrize = 0;
157   uint public nextPrizeTime = startTime + period;
158 
159   uint public currentPrizeStakeID = 0;
160 
161   struct MidnightRunDeposit {
162     uint value;
163     address user;
164   }
165   mapping(uint => MidnightRunDeposit) public stakeIDToDepositIndex;
166 
167  /**
168   * Constructor no need for unnecessary work in here.
169   */
170   constructor() public {
171   }
172 
173   /**
174    * Fallback and entrypoint for deposits.
175    */
176   function() public payable isHuman {
177     if (msg.value == 0) {
178       collectPayoutForAddress(msg.sender);
179     } else {
180       uint refId = 1;
181       address referrer = bytesToAddress(msg.data);
182       if (investorToDepostIndex[referrer].isExist) {
183         refId = investorToDepostIndex[referrer].id;
184       }
185       deposit(refId);
186     }
187   }
188 
189 /**
190  * Reads the given bytes into an addtress
191  */
192   function bytesToAddress(bytes bys) private pure returns(address addr) {
193     assembly {
194       addr: = mload(add(bys, 20))
195     }
196   }
197 
198 /**
199  * Put some funds into the contract for the prize
200  */
201   function addToMidnightPrize() public payable onlyOwner {
202     midnightPrize += msg.value;
203   }
204 
205 /**
206  * Get the time of the next payout - calculated
207  */
208   function getNextPayoutTime() public view returns(uint) {
209     if (now<startTime) return startTime + period;
210     return startTime + ((now.sub(startTime)).div(period)).mul(period) + period;
211   }
212 
213 /**
214  * Make a deposit into the contract
215  */
216   function deposit(uint _referrerID) public payable isHuman {
217     require(_referrerID <= currentStakeID, "Who referred you?");
218     require(msg.value >= minBetLevel, "Doesn't meet minimum stake.");
219 
220     // when is next midnight ?
221     uint nextPayAfterTime = getNextPayoutTime();
222 
223     if (investorToDepostIndex[msg.sender].isExist) {
224       if (investorToDepostIndex[msg.sender].nextPayAfterTime < now) {
225         collectPayoutForAddress(msg.sender);
226       }
227       investorToDepostIndex[msg.sender].value += msg.value;
228       investorToDepostIndex[msg.sender].lastBetTime = now;
229     } else {
230       DepositInfo memory newDeposit;
231 
232       newDeposit = DepositInfo({
233         value: msg.value,
234         firstBetTime: now,
235         lastBetTime: now,
236         lastPaymentTime: 0,
237         nextPayAfterTime: nextPayAfterTime,
238         isExist: true,
239         id: currentStakeID,
240         referrerID: _referrerID
241       });
242 
243       investorToDepostIndex[msg.sender] = newDeposit;
244       idToAddressIndex[currentStakeID] = msg.sender;
245 
246       currentStakeID++;
247     }
248 
249     if (now > nextPrizeTime) {
250       doMidnightRun();
251     }
252 
253     currentPrizeStakeID++;
254 
255     MidnightRunDeposit memory midnitrunDeposit;
256     midnitrunDeposit.user = msg.sender;
257     midnitrunDeposit.value = msg.value;
258 
259     stakeIDToDepositIndex[currentPrizeStakeID] = midnitrunDeposit;
260 
261     // contribute to the Midnight Run Prize
262     midnightPrize += msg.value.mul(midnightPrizePercent).div(10000);
263     // Is there a referrer to be paid?
264     if (investorToDepostIndex[msg.sender].referrerID != 0) {
265 
266       uint refToPay = msg.value.mul(referrerPercent).div(10000);
267       // Referral Fee
268       idToAddressIndex[investorToDepostIndex[msg.sender].referrerID].transfer(refToPay);
269       // Team and advertising fee
270       owner().transfer(msg.value.mul(referrerAndOwnerPercent - referrerPercent).div(10000));
271       emit ReferralPayout(msg.sender, idToAddressIndex[investorToDepostIndex[msg.sender].referrerID], refToPay, referrerPercent, now);
272     } else {
273       // Team and advertising fee
274       owner().transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));
275     }
276   }
277 
278 
279 
280 /**
281  * Collect payout for the msg.sender
282  */
283   function collectPayout() public isHuman {
284     collectPayoutForAddress(msg.sender);
285   }
286 
287 /**
288  * Collect payout for the given address
289  */
290   function getRewardForAddress(address _address) public onlyOwner {
291     collectPayoutForAddress(_address);
292   }
293 
294 /**
295  *
296  */
297   function collectPayoutForAddress(address _address) internal {
298     require(investorToDepostIndex[_address].isExist == true, "Who are you?");
299     require(investorToDepostIndex[_address].nextPayAfterTime < now, "Not yet.");
300 
301     uint periodCount = now.sub(investorToDepostIndex[_address].nextPayAfterTime).div(period).add(1);
302     uint percent = dailyDividendPercent;
303 
304     if (investorToDepostIndex[_address].referrerID > 0) {
305       percent = referredDividendPercent;
306     }
307 
308     uint toPay = periodCount.mul(investorToDepostIndex[_address].value).div(10000).mul(percent);
309 
310     investorToDepostIndex[_address].lastPaymentTime = now;
311     investorToDepostIndex[_address].nextPayAfterTime += periodCount.mul(period);
312 
313     // protect contract - this could result in some bad luck - but not much
314     if (toPay.add(midnightPrize) < address(this).balance.sub(msg.value))
315     {
316       _address.transfer(toPay);
317       emit DailyDividendPayout(_address, toPay, periodCount, percent, now);
318     }
319   }
320 
321 /**
322  * Perform the Midnight Run
323  */
324   function doMidnightRun() public isHuman {
325     require(now>nextPrizeTime , "Not yet");
326 
327     // set the next prize time to the next payout time (MidnightRun)
328     nextPrizeTime = getNextPayoutTime();
329 
330     if (currentPrizeStakeID > 5) {
331       uint toPay = midnightPrize;
332       midnightPrize = 0;
333 
334       if (toPay > address(this).balance){
335         toPay = address(this).balance;
336       }
337 
338       uint totalValue = stakeIDToDepositIndex[currentPrizeStakeID].value + stakeIDToDepositIndex[currentPrizeStakeID - 1].value + stakeIDToDepositIndex[currentPrizeStakeID - 2].value + stakeIDToDepositIndex[currentPrizeStakeID - 3].value + stakeIDToDepositIndex[currentPrizeStakeID - 4].value;
339 
340       stakeIDToDepositIndex[currentPrizeStakeID].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue));
341       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID].value, now);
342 
343       stakeIDToDepositIndex[currentPrizeStakeID - 1].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue));
344       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 1].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 1].value, now);
345 
346       stakeIDToDepositIndex[currentPrizeStakeID - 2].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue));
347       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 2].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 2].value, now);
348 
349       stakeIDToDepositIndex[currentPrizeStakeID - 3].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue));
350       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 3].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 3].value, now);
351 
352       stakeIDToDepositIndex[currentPrizeStakeID - 4].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue));
353       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 4].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 4].value, now);
354     }
355   }
356 }
357 
358 /**
359  * @title SafeMath
360  * @dev Math operations with safety checks that revert on error
361  */
362 library SafeMath {
363 
364   /**
365   * @dev Multiplies two numbers, reverts on overflow.
366   */
367   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
368     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
369     // benefit is lost if 'b' is also tested.
370     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
371     if (a == 0) {
372       return 0;
373     }
374 
375     uint256 c = a * b;
376     require(c / a == b);
377 
378     return c;
379   }
380 
381   /**
382   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
383   */
384   function div(uint256 a, uint256 b) internal pure returns (uint256) {
385     require(b > 0); // Solidity only automatically asserts when dividing by 0
386     uint256 c = a / b;
387     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
388 
389     return c;
390   }
391 
392   /**
393   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
394   */
395   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
396     require(b <= a);
397     uint256 c = a - b;
398 
399     return c;
400   }
401 
402   /**
403   * @dev Adds two numbers, reverts on overflow.
404   */
405   function add(uint256 a, uint256 b) internal pure returns (uint256) {
406     uint256 c = a + b;
407     require(c >= a);
408 
409     return c;
410   }
411 
412   /**
413   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
414   * reverts when dividing by zero.
415   */
416   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
417     require(b != 0);
418     return a % b;
419   }
420 }