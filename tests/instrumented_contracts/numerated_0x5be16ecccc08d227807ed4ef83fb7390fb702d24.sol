1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address private _owner;
5 
6   event OwnershipRenounced(address indexed previousOwner);
7   event OwnershipTransferred(
8     address indexed previousOwner,
9     address indexed newOwner
10   );
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   constructor() public {
17     _owner = msg.sender;
18   }
19 
20   /**
21    * @return the address of the owner.
22    */
23   function owner() public view returns(address) {
24     return _owner;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(isOwner());
32     _;
33   }
34 
35   /**
36    * @return true if `msg.sender` is the owner of the contract.
37    */
38   function isOwner() public view returns(bool) {
39     return msg.sender == _owner;
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     _transferOwnership(newOwner);
48   }
49 
50   /**
51    * @dev Transfers control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function _transferOwnership(address newOwner) internal {
55     require(newOwner != address(0));
56     emit OwnershipTransferred(_owner, newOwner);
57     _owner = newOwner;
58   }
59 }
60 
61 
62 
63 contract MidnightRun is Ownable {
64   using SafeMath
65   for uint;
66 
67   modifier isHuman() {
68     uint32 size;
69     address investor = msg.sender;
70     assembly {
71       size: = extcodesize(investor)
72     }
73     if (size > 0) {
74       revert("Inhuman");
75     }
76     _;
77   }
78 
79   event DailyDividendPayout(address indexed _address, uint value, uint periodCount, uint percent, uint time);
80   event ReferralPayout(address indexed _addressFrom, address indexed _addressTo, uint value, uint percent, uint time);
81   event MidnightRunPayout(address indexed _address, uint value, uint totalValue, uint userValue, uint time);
82 
83   uint public period = 24 hours;
84   uint public startTime = 1538089200; //  TH, 27 Sep 2018 23:00:00 +0000 UTC
85 
86   uint public dailyDividendPercent = 3000; //30%
87   uint public referredDividendPercent = 3300; //33%
88 
89   uint public referrerPercent = 250; //2.5%
90   uint public minBetLevel = 0.01 ether;
91 
92   uint public referrerAndOwnerPercent = 2000; //20%
93   uint public currentStakeID = 1;
94 
95   struct DepositInfo {
96     uint value;
97     uint firstBetTime;
98     uint lastBetTime;
99     uint lastPaymentTime;
100     uint nextPayAfterTime;
101     bool isExist;
102     uint id;
103     uint referrerID;
104   }
105 
106   mapping(address => DepositInfo) public investorToDepostIndex;
107   mapping(uint => address) public idToAddressIndex;
108 
109   // Jackpot
110   uint public midnightPrizePercent = 1000; //10%
111   uint public midnightPrize = 0;
112   uint public nextPrizeTime = startTime + period;
113 
114   uint public currentPrizeStakeID = 0;
115 
116   struct MidnightRunDeposit {
117     uint value;
118     address user;
119   }
120   mapping(uint => MidnightRunDeposit) public stakeIDToDepositIndex;
121 
122  /**
123   * Constructor no need for unnecessary work in here.
124   */
125   constructor() public {
126   }
127 
128   /**
129    * Fallback and entrypoint for deposits.
130    */
131   function() public payable isHuman {
132     if (msg.value == 0) {
133       collectPayoutForAddress(msg.sender);
134     } else {
135       uint refId = 1;
136       address referrer = bytesToAddress(msg.data);
137       if (investorToDepostIndex[referrer].isExist) {
138         refId = investorToDepostIndex[referrer].id;
139       }
140       deposit(refId);
141     }
142   }
143 
144 /**
145  * Reads the given bytes into an addtress
146  */
147   function bytesToAddress(bytes bys) private pure returns(address addr) {
148     assembly {
149       addr: = mload(add(bys, 20))
150     }
151   }
152 
153 /**
154  * Put some funds into the contract for the prize
155  */
156   function addToMidnightPrize() public payable onlyOwner {
157     midnightPrize += msg.value;
158   }
159 
160 /**
161  * Get the time of the next payout - calculated
162  */
163   function getNextPayoutTime() public view returns(uint) {
164     if (now<startTime) return startTime + period;
165     return startTime + ((now.sub(startTime)).div(period)).mul(period) + period;
166   }
167 
168 /**
169  * Make a deposit into the contract
170  */
171   function deposit(uint _referrerID) public payable isHuman {
172     require(_referrerID <= currentStakeID, "Who referred you?");
173     require(msg.value >= minBetLevel, "Doesn't meet minimum stake.");
174 
175     // when is next midnight ?
176     uint nextPayAfterTime = getNextPayoutTime();
177 
178     if (investorToDepostIndex[msg.sender].isExist) {
179       if (investorToDepostIndex[msg.sender].nextPayAfterTime < now) {
180         collectPayoutForAddress(msg.sender);
181       }
182       investorToDepostIndex[msg.sender].value += msg.value;
183       investorToDepostIndex[msg.sender].lastBetTime = now;
184     } else {
185       DepositInfo memory newDeposit;
186 
187       newDeposit = DepositInfo({
188         value: msg.value,
189         firstBetTime: now,
190         lastBetTime: now,
191         lastPaymentTime: 0,
192         nextPayAfterTime: nextPayAfterTime,
193         isExist: true,
194         id: currentStakeID,
195         referrerID: _referrerID
196       });
197 
198       investorToDepostIndex[msg.sender] = newDeposit;
199       idToAddressIndex[currentStakeID] = msg.sender;
200 
201       currentStakeID++;
202     }
203 
204     if (now > nextPrizeTime) {
205       doMidnightRun();
206     }
207 
208     currentPrizeStakeID++;
209 
210     MidnightRunDeposit memory midnitrunDeposit;
211     midnitrunDeposit.user = msg.sender;
212     midnitrunDeposit.value = msg.value;
213 
214     stakeIDToDepositIndex[currentPrizeStakeID] = midnitrunDeposit;
215 
216     // contribute to the Midnight Run Prize
217     midnightPrize += msg.value.mul(midnightPrizePercent).div(10000);
218     // Is there a referrer to be paid?
219     if (investorToDepostIndex[msg.sender].referrerID != 0) {
220 
221       uint refToPay = msg.value.mul(referrerPercent).div(10000);
222       // Referral Fee
223       idToAddressIndex[investorToDepostIndex[msg.sender].referrerID].transfer(refToPay);
224       // Team and advertising fee
225       owner().transfer(msg.value.mul(referrerAndOwnerPercent - referrerPercent).div(10000));
226       emit ReferralPayout(msg.sender, idToAddressIndex[investorToDepostIndex[msg.sender].referrerID], refToPay, referrerPercent, now);
227     } else {
228       // Team and advertising fee
229       owner().transfer(msg.value.mul(referrerAndOwnerPercent).div(10000));
230     }
231   }
232 
233 
234 
235 /**
236  * Collect payout for the msg.sender
237  */
238   function collectPayout() public isHuman {
239     collectPayoutForAddress(msg.sender);
240   }
241 
242 /**
243  * Collect payout for the given address
244  */
245   function getRewardForAddress(address _address) public onlyOwner {
246     collectPayoutForAddress(_address);
247   }
248 
249 /**
250  *
251  */
252   function collectPayoutForAddress(address _address) internal {
253     require(investorToDepostIndex[_address].isExist == true, "Who are you?");
254     require(investorToDepostIndex[_address].nextPayAfterTime < now, "Not yet.");
255 
256     uint periodCount = now.sub(investorToDepostIndex[_address].nextPayAfterTime).div(period).add(1);
257     uint percent = dailyDividendPercent;
258 
259     if (investorToDepostIndex[_address].referrerID > 0) {
260       percent = referredDividendPercent;
261     }
262 
263     uint toPay = periodCount.mul(investorToDepostIndex[_address].value).div(10000).mul(percent);
264 
265     investorToDepostIndex[_address].lastPaymentTime = now;
266     investorToDepostIndex[_address].nextPayAfterTime += periodCount.mul(period);
267 
268     // protect contract - this could result in some bad luck - but not much
269     if (toPay.add(midnightPrize) < address(this).balance.sub(msg.value))
270     {
271       _address.transfer(toPay);
272       emit DailyDividendPayout(_address, toPay, periodCount, percent, now);
273     }
274   }
275 
276 /**
277  * Perform the Midnight Run
278  */
279   function doMidnightRun() public isHuman {
280     require(now>nextPrizeTime , "Not yet");
281 
282     // set the next prize time to the next payout time (MidnightRun)
283     nextPrizeTime = getNextPayoutTime();
284 
285     if (currentPrizeStakeID > 5) {
286       uint toPay = midnightPrize;
287       midnightPrize = 0;
288 
289       if (toPay > address(this).balance){
290         toPay = address(this).balance;
291       }
292 
293       uint totalValue = stakeIDToDepositIndex[currentPrizeStakeID].value + stakeIDToDepositIndex[currentPrizeStakeID - 1].value + stakeIDToDepositIndex[currentPrizeStakeID - 2].value + stakeIDToDepositIndex[currentPrizeStakeID - 3].value + stakeIDToDepositIndex[currentPrizeStakeID - 4].value;
294 
295       stakeIDToDepositIndex[currentPrizeStakeID].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue));
296       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID].value, now);
297 
298       stakeIDToDepositIndex[currentPrizeStakeID - 1].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue));
299       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 1].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 1].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 1].value, now);
300 
301       stakeIDToDepositIndex[currentPrizeStakeID - 2].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue));
302       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 2].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 2].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 2].value, now);
303 
304       stakeIDToDepositIndex[currentPrizeStakeID - 3].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue));
305       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 3].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 3].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 3].value, now);
306 
307       stakeIDToDepositIndex[currentPrizeStakeID - 4].user.transfer(toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue));
308       emit MidnightRunPayout(stakeIDToDepositIndex[currentPrizeStakeID - 4].user, toPay.mul(stakeIDToDepositIndex[currentPrizeStakeID - 4].value).div(totalValue), totalValue, stakeIDToDepositIndex[currentPrizeStakeID - 4].value, now);
309     }
310   }
311 }
312 
313 /**
314  * @title SafeMath
315  * @dev Math operations with safety checks that revert on error
316  */
317 library SafeMath {
318 
319   /**
320   * @dev Multiplies two numbers, reverts on overflow.
321   */
322   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
323     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
324     // benefit is lost if 'b' is also tested.
325     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
326     if (a == 0) {
327       return 0;
328     }
329 
330     uint256 c = a * b;
331     require(c / a == b);
332 
333     return c;
334   }
335 
336   /**
337   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
338   */
339   function div(uint256 a, uint256 b) internal pure returns (uint256) {
340     require(b > 0); // Solidity only automatically asserts when dividing by 0
341     uint256 c = a / b;
342     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
343 
344     return c;
345   }
346 
347   /**
348   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
349   */
350   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
351     require(b <= a);
352     uint256 c = a - b;
353 
354     return c;
355   }
356 
357   /**
358   * @dev Adds two numbers, reverts on overflow.
359   */
360   function add(uint256 a, uint256 b) internal pure returns (uint256) {
361     uint256 c = a + b;
362     require(c >= a);
363 
364     return c;
365   }
366 
367   /**
368   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
369   * reverts when dividing by zero.
370   */
371   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
372     require(b != 0);
373     return a % b;
374   }
375 }