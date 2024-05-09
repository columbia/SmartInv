1 pragma solidity ^0.4.24;
2 /***
3  * @title -Midnight Run v0.1.0
4  * 
5  *
6  *    ███╗   ███╗██╗██████╗ ███╗   ██╗██╗ ██████╗ ██╗  ██╗████████╗    ██████╗ ██╗   ██╗███╗   ██╗
7  *    ████╗ ████║██║██╔══██╗████╗  ██║██║██╔════╝ ██║  ██║╚══██╔══╝    ██╔══██╗██║   ██║████╗  ██║
8  *    ██╔████╔██║██║██║  ██║██╔██╗ ██║██║██║  ███╗███████║   ██║       ██████╔╝██║   ██║██╔██╗ ██║
9  *    ██║╚██╔╝██║██║██║  ██║██║╚██╗██║██║██║   ██║██╔══██║   ██║       ██╔══██╗██║   ██║██║╚██╗██║
10  *    ██║ ╚═╝ ██║██║██████╔╝██║ ╚████║██║╚██████╔╝██║  ██║   ██║       ██║  ██║╚██████╔╝██║ ╚████║
11  *    ╚═╝     ╚═╝╚═╝╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
12  *                                  ┌─────────────────────────┐  
13  *                                  │https://midnightrun.live │  
14  *                                  └─────────────────────────┘  
15  *
16  * This product is provided for public use without any guarantee or recourse to appeal
17  * 
18  * Payouts are collectible daily after 00:00 UTC
19  * Referral rewards are distributed automatically.
20  * The last 5 in before 00:00 UTC win the midnight prize.
21  * 
22  * By sending ETH to this contract you are agreeing to the terms set out in the logic listed below.
23  *
24  * WARNING1:  Do not invest more than you can afford. 
25  * WARNING2:  You can earn. 
26  */
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address private _owner;
36 
37   event OwnershipRenounced(address indexed previousOwner);
38   event OwnershipTransferred(
39     address indexed previousOwner,
40     address indexed newOwner
41   );
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   constructor() public {
48     _owner = msg.sender;
49   }
50 
51   /**
52    * @return the address of the owner.
53    */
54   function owner() public view returns(address) {
55     return _owner;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(isOwner());
63     _;
64   }
65 
66   /**
67    * @return true if `msg.sender` is the owner of the contract.
68    */
69   function isOwner() public view returns(bool) {
70     return msg.sender == _owner;
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     _transferOwnership(newOwner);
79   }
80 
81   /**
82    * @dev Transfers control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function _transferOwnership(address newOwner) internal {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(_owner, newOwner);
88     _owner = newOwner;
89   }
90 }
91 
92 
93 /***
94  *     __ __  __  _ __  _    ___ __  __  _ _____ ___  __   ________
95  *    |  V  |/  \| |  \| |  / _//__\|  \| |_   _| _ \/  \ / _/_   _|
96  *    | \_/ | /\ | | | ' | | \_| \/ | | ' | | | | v / /\ | \__ | |
97  *    |_| |_|_||_|_|_|\__|  \__/\__/|_|\__| |_| |_|_\_||_|\__/ |_|
98  */
99 contract MidnightRun is Ownable {
100   using SafeMath
101   for uint;
102 
103   modifier isHuman() {
104     uint32 size;
105     address investor = msg.sender;
106     assembly {
107       size: = extcodesize(investor)
108     }
109     if (size > 0) {
110       revert("Inhuman");
111     }
112     _;
113   }
114 
115   event DailyDividendPayout(address indexed _address, uint value, uint periodCount, uint percent, uint time);
116   event ReferralPayout(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time);
117   event MidnightRunPayout(address indexed _address, uint value, uint totalValue, uint userValue, uint time);
118 
119   uint public period = 24 hours;
120   uint public startTime = 1537833600; //  Tue, 25 Sep 2018 00:00:00 +0000 UTC
121 
122   uint public dailyDividendPercent = 300; //3%
123   uint public referredDividendPercent = 330; //3.3%
124 
125   uint public referrerPercent = 250; //2.5%
126   uint public minBetLevel = 0.01 ether;
127 
128   uint public referrerAndOwnerPercent = 2000; //20%
129   uint public currentStakeID = 1;
130 
131   struct DepositInfo {
132     uint value;
133     uint firstBetTime;
134     uint lastBetTime;
135     uint lastPaymentTime;
136     uint nextPayAfterTime;
137     bool isExist;
138     uint id;
139     uint referrerID;
140   }
141 
142   mapping(address => DepositInfo) public investorToDepostIndex;
143   mapping(uint => address) public idToAddressIndex;
144 
145   // Jackpot
146   uint public midnightPrizePercent = 1000; //10%
147   uint public midnightPrize = 0;
148   uint public nextPrizeTime = startTime + period;
149 
150   uint public currentPrizeStakeID = 0;
151 
152   struct MidnightRunDeposit {
153     uint value;
154     address user;
155   }
156   mapping(uint => MidnightRunDeposit) public stakeIDToDepositIndex;
157 
158  /**
159   * Constructor no need for unnecessary work in here.
160   */
161   constructor() public {
162   }
163 
164   /**
165    * Fallback and entrypoint for deposits.
166    */
167   function() public payable isHuman {
168     if (msg.value == 0) {
169       collectPayoutForAddress(msg.sender);
170     } else {
171       uint refId = 1;
172       address referrer = bytesToAddress(msg.data);
173       if (investorToDepostIndex[referrer].isExist) {
174         refId = investorToDepostIndex[referrer].id;
175       }
176       deposit(refId);
177     }
178   }
179 
180 /**
181  * Reads the given bytes into an addtress
182  */
183   function bytesToAddress(bytes bys) private pure returns(address addr) {
184     assembly {
185       addr: = mload(add(bys, 20))
186     }
187   }
188 
189 /**
190  * Put some funds into the contract for the prize
191  */
192   function addToMidnightPrize() public payable onlyOwner {
193     midnightPrize += msg.value;
194   }
195 
196 /**
197  * Get the time of the next payout - calculated
198  */
199   function getNextPayoutTime() public view returns(uint) {
200     if (now<startTime) return startTime + period;
201     return startTime + ((now.sub(startTime)).div(period)).mul(period) + period;
202   }
203 
204 /**
205  * Make a deposit into the contract
206  */
207   function deposit(uint _referrerID) public payable isHuman {
208     require(_referrerID <= currentStakeID, "Who referred you?");
209     require(msg.value >= minBetLevel, "Doesn't meet minimum stake.");
210 
211     // when is next midnight ?
212     uint nextPayAfterTime = getNextPayoutTime();
213 
214     if (investorToDepostIndex[msg.sender].isExist) {
215       if (investorToDepostIndex[msg.sender].nextPayAfterTime < now) {
216         collectPayoutForAddress(msg.sender);
217       }
218       investorToDepostIndex[msg.sender].value += msg.value;
219       investorToDepostIndex[msg.sender].lastBetTime = now;
220     } else {
221       DepositInfo memory newDeposit;
222 
223       newDeposit = DepositInfo({
224         value: msg.value,
225         firstBetTime: now,
226         lastBetTime: now,
227         lastPaymentTime: 0,
228         nextPayAfterTime: nextPayAfterTime,
229         isExist: true,
230         id: currentStakeID,
231         referrerID: _referrerID
232       });
233 
234       investorToDepostIndex[msg.sender] = newDeposit;
235       idToAddressIndex[currentStakeID] = msg.sender;
236 
237       currentStakeID++;
238     }
239 
240     if (now > nextPrizeTime) {
241       doMidnightRun();
242     }
243 
244     currentPrizeStakeID++;
245 
246     MidnightRunDeposit memory midnitrunDeposit;
247     midnitrunDeposit.user = msg.sender;
248     midnitrunDeposit.value = msg.value;
249 
250     stakeIDToDepositIndex[currentPrizeStakeID] = midnitrunDeposit;
251 
252     // contribute to the Midnight Run Prize
253     midnightPrize += msg.value.mul(midnightPrizePercent).div(10000);
254     // Is there a referrer to be paid?
255     if (investorToDepostIndex[msg.sender].referrerID != 0) {
256 
257       uint refToPay = msg.value.mul(referrerPercent).div(10000);
258       // Referral Fee
259       idToAddressIndex[investorToDepostIndex[msg.sender].referrerID].transfer(refToPay);
260       // Team and advertising fee
261       owner().transfer(msg.value.mul(referrerAndOwnerPercent - referrerPercent).div(10000));
262       emit ReferralPayout(msg.sender, idToAddressIndex[investorToDepostIndex[msg.sender].referrerID], refToPay, referrerPercent, now);
263     } else {
264       // Team and advertising fee
265       owner().transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));
266     }
267   }
268 
269 
270 
271 /**
272  * Collect payout for the msg.sender
273  */
274   function collectPayout() public isHuman {
275     collectPayoutForAddress(msg.sender);
276   }
277 
278 /**
279  * Collect payout for the given address
280  */
281   function getRewardForAddress(address _address) public onlyOwner {
282     collectPayoutForAddress(_address);
283   }
284 
285 /**
286  *
287  */
288   function collectPayoutForAddress(address _address) internal {
289     require(investorToDepostIndex[_address].isExist == true, "Who are you?");
290     require(investorToDepostIndex[_address].nextPayAfterTime < now, "Not yet.");
291 
292     uint periodCount = now.sub(investorToDepostIndex[_address].nextPayAfterTime).div(period).add(1);
293     uint percent = dailyDividendPercent;
294 
295     if (investorToDepostIndex[_address].referrerID > 0) {
296       percent = referredDividendPercent;
297     }
298 
299     uint toPay = periodCount.mul(investorToDepostIndex[_address].value).div(10000).mul(percent);
300 
301     investorToDepostIndex[_address].lastPaymentTime = now;
302     investorToDepostIndex[_address].nextPayAfterTime += periodCount.mul(period);
303 
304     // protect contract - this could result in some bad luck - but not much
305     if (toPay.add(midnightPrize) < address(this).balance.sub(msg.value))
306     {
307       _address.transfer(toPay);
308       emit DailyDividendPayout(_address, toPay, periodCount, percent, now);
309     }
310   }
311 
312 /**
313  * Perform the Midnight Run
314  */
315   function doMidnightRun() public isHuman {
316     require(now>nextPrizeTime , "Not yet");
317 
318     // set the next prize time to the next payout time (MidnightRun)
319     nextPrizeTime = getNextPayoutTime();
320 
321     if (currentPrizeStakeID > 5) {
322       uint toPay = midnightPrize;
323       midnightPrize = 0;
324 
325       if (toPay > address(this).balance){
326         toPay = address(this).balance;
327       }
328 
329       uint totalValue = stakeIDToDepositIndex[currentPrizeStakeID].value + stakeIDToDepositIndex[currentPrizeStakeID - 1].value + stakeIDToDepositIndex[currentPrizeStakeID - 2].value + stakeIDToDepositIndex[currentPrizeStakeID - 3].value + stakeIDToDepositIndex[currentPrizeStakeID - 4].value;
330 
331       stakeIDToDepositIndex[currentPrizeStakeID].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue));
332       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID].value, now);
333 
334       stakeIDToDepositIndex[currentPrizeStakeID - 1].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue));
335       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 1].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 1].value, now);
336 
337       stakeIDToDepositIndex[currentPrizeStakeID - 2].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue));
338       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 2].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 2].value, now);
339 
340       stakeIDToDepositIndex[currentPrizeStakeID - 3].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue));
341       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 3].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 3].value, now);
342 
343       stakeIDToDepositIndex[currentPrizeStakeID - 4].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue));
344       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 4].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 4].value, now);
345     }
346   }
347 }
348 
349 /**
350  * @title SafeMath
351  * @dev Math operations with safety checks that revert on error
352  */
353 library SafeMath {
354 
355   /**
356   * @dev Multiplies two numbers, reverts on overflow.
357   */
358   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
359     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
360     // benefit is lost if 'b' is also tested.
361     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
362     if (a == 0) {
363       return 0;
364     }
365 
366     uint256 c = a * b;
367     require(c / a == b);
368 
369     return c;
370   }
371 
372   /**
373   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
374   */
375   function div(uint256 a, uint256 b) internal pure returns (uint256) {
376     require(b > 0); // Solidity only automatically asserts when dividing by 0
377     uint256 c = a / b;
378     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
379 
380     return c;
381   }
382 
383   /**
384   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
385   */
386   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387     require(b <= a);
388     uint256 c = a - b;
389 
390     return c;
391   }
392 
393   /**
394   * @dev Adds two numbers, reverts on overflow.
395   */
396   function add(uint256 a, uint256 b) internal pure returns (uint256) {
397     uint256 c = a + b;
398     require(c >= a);
399 
400     return c;
401   }
402 
403   /**
404   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
405   * reverts when dividing by zero.
406   */
407   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
408     require(b != 0);
409     return a % b;
410   }
411 }