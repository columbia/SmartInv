1 pragma solidity ^0.4.18;
2 
3 contract DateTime {
4         /*
5          *  Date and Time utilities for ethereum contracts
6          *
7          */
8         struct _DateTime {
9                 uint16 year;
10                 uint8 month;
11                 uint8 day;
12                 uint8 hour;
13                 uint8 minute;
14                 uint8 second;
15                 uint8 weekday;
16         }
17 
18         uint constant DAY_IN_SECONDS = 86400;
19         uint constant YEAR_IN_SECONDS = 31536000;
20         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
21 
22         uint constant HOUR_IN_SECONDS = 3600;
23         uint constant MINUTE_IN_SECONDS = 60;
24 
25         uint16 constant ORIGIN_YEAR = 1970;
26 
27         function isLeapYear(uint16 year) public pure returns (bool) {
28                 if (year % 4 != 0) {
29                         return false;
30                 }
31                 if (year % 100 != 0) {
32                         return true;
33                 }
34                 if (year % 400 != 0) {
35                         return false;
36                 }
37                 return true;
38         }
39 
40         function leapYearsBefore(uint year) public pure returns (uint) {
41                 year -= 1;
42                 return year / 4 - year / 100 + year / 400;
43         }
44 
45         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
46                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
47                         return 31;
48                 }
49                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
50                         return 30;
51                 }
52                 else if (isLeapYear(year)) {
53                         return 29;
54                 }
55                 else {
56                         return 28;
57                 }
58         }
59 
60         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
61                 uint secondsAccountedFor = 0;
62                 uint buf;
63                 uint8 i;
64 
65                 // Year
66                 dt.year = getYear(timestamp);
67                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
68 
69                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
70                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
71 
72                 // Month
73                 uint secondsInMonth;
74                 for (i = 1; i <= 12; i++) {
75                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
76                         if (secondsInMonth + secondsAccountedFor > timestamp) {
77                                 dt.month = i;
78                                 break;
79                         }
80                         secondsAccountedFor += secondsInMonth;
81                 }
82 
83                 // Day
84                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
85                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
86                                 dt.day = i;
87                                 break;
88                         }
89                         secondsAccountedFor += DAY_IN_SECONDS;
90                 }
91 
92                 // Hour
93                 dt.hour = getHour(timestamp);
94 
95                 // Minute
96                 dt.minute = getMinute(timestamp);
97 
98                 // Second
99                 dt.second = getSecond(timestamp);
100 
101                 // Day of week.
102                 dt.weekday = getWeekday(timestamp);
103         }
104 
105         function getYear(uint timestamp) public pure returns (uint16) {
106                 uint secondsAccountedFor = 0;
107                 uint16 year;
108                 uint numLeapYears;
109 
110                 // Year
111                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
112                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
113 
114                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
115                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
116 
117                 while (secondsAccountedFor > timestamp) {
118                         if (isLeapYear(uint16(year - 1))) {
119                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
120                         }
121                         else {
122                                 secondsAccountedFor -= YEAR_IN_SECONDS;
123                         }
124                         year -= 1;
125                 }
126                 return year;
127         }
128 
129         function getMonth(uint timestamp) public pure returns (uint8) {
130                 return parseTimestamp(timestamp).month;
131         }
132 
133         function getDay(uint timestamp) public pure returns (uint8) {
134                 return parseTimestamp(timestamp).day;
135         }
136 
137         function getHour(uint timestamp) public pure returns (uint8) {
138                 return uint8((timestamp / 60 / 60) % 24);
139         }
140 
141         function getMinute(uint timestamp) public pure returns (uint8) {
142                 return uint8((timestamp / 60) % 60);
143         }
144 
145         function getSecond(uint timestamp) public pure returns (uint8) {
146                 return uint8(timestamp % 60);
147         }
148 
149         function getWeekday(uint timestamp) public pure returns (uint8) {
150                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
151         }
152 
153         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
154                 return toTimestamp(year, month, day, 0, 0, 0);
155         }
156 
157         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
158                 return toTimestamp(year, month, day, hour, 0, 0);
159         }
160 
161         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
162                 return toTimestamp(year, month, day, hour, minute, 0);
163         }
164 
165         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
166                 uint16 i;
167 
168                 // Year
169                 for (i = ORIGIN_YEAR; i < year; i++) {
170                         if (isLeapYear(i)) {
171                                 timestamp += LEAP_YEAR_IN_SECONDS;
172                         }
173                         else {
174                                 timestamp += YEAR_IN_SECONDS;
175                         }
176                 }
177 
178                 // Month
179                 uint8[12] memory monthDayCounts;
180                 monthDayCounts[0] = 31;
181                 if (isLeapYear(year)) {
182                         monthDayCounts[1] = 29;
183                 }
184                 else {
185                         monthDayCounts[1] = 28;
186                 }
187                 monthDayCounts[2] = 31;
188                 monthDayCounts[3] = 30;
189                 monthDayCounts[4] = 31;
190                 monthDayCounts[5] = 30;
191                 monthDayCounts[6] = 31;
192                 monthDayCounts[7] = 31;
193                 monthDayCounts[8] = 30;
194                 monthDayCounts[9] = 31;
195                 monthDayCounts[10] = 30;
196                 monthDayCounts[11] = 31;
197 
198                 for (i = 1; i < month; i++) {
199                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
200                 }
201 
202                 // Day
203                 timestamp += DAY_IN_SECONDS * (day - 1);
204 
205                 // Hour
206                 timestamp += HOUR_IN_SECONDS * (hour);
207 
208                 // Minute
209                 timestamp += MINUTE_IN_SECONDS * (minute);
210 
211                 // Second
212                 timestamp += second;
213 
214                 return timestamp;
215         }
216 }
217 
218 /**
219  * @title Ownable
220  * @dev The Ownable contract has an owner address, and provides basic authorization control
221  * functions, this simplifies the implementation of "user permissions".
222  */
223 contract Ownable {
224   address public owner;
225 
226   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228   /**
229    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
230    * account.
231    */
232   function Ownable() public {
233     owner = msg.sender;
234   }
235 
236   /**
237    * @dev Throws if called by any account other than the owner.
238    */
239   modifier onlyOwner() {
240     require(msg.sender == owner);
241     _;
242   }
243 
244   /**
245    * @dev Allows the current owner to transfer control of the contract to a newOwner.
246    * @param newOwner The address to transfer ownership to.
247    */
248   function transferOwnership(address newOwner) public onlyOwner {
249     require(newOwner != address(0));
250     OwnershipTransferred(owner, newOwner);
251     owner = newOwner;
252   }
253 
254 }
255 
256 /**
257  * @title SafeMath
258  * @dev Math operations with safety checks that throw on error
259  */
260 library SafeMath {
261   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262     if (a == 0) {
263       return 0;
264     }
265     uint256 c = a * b;
266     assert(c / a == b);
267     return c;
268   }
269 
270   function div(uint256 a, uint256 b) internal pure returns (uint256) {
271     // assert(b > 0); // Solidity automatically throws when dividing by 0
272     uint256 c = a / b;
273     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
274     return c;
275   }
276 
277   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278     assert(b <= a);
279     return a - b;
280   }
281 
282   function add(uint256 a, uint256 b) internal pure returns (uint256) {
283     uint256 c = a + b;
284     assert(c >= a);
285     return c;
286   }
287 }
288 
289 /**
290  * @title Destructible
291  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
292  */
293 contract Destructible is Ownable {
294     function Destructible() public payable { }
295 
296     /**
297      * @dev Transfers the current balance to the owner and terminates the contract.
298      */
299     function destroy() onlyOwner public {
300         selfdestruct(owner);
301     }
302 
303     function destroyAndSend(address _recipient) onlyOwner public {
304         selfdestruct(_recipient);
305     }
306 }
307 
308 /**
309  * @title Pausable
310  * @dev Base contract which allows children to implement an emergency stop mechanism.
311  */
312 contract Pausable is Ownable {
313     event Pause();
314     event Unpause();
315     bool public paused = false;
316 
317     /**
318      * @dev Modifier to make a function callable only when the contract is not paused.
319      */
320     modifier whenNotPaused() {
321         require(!paused);
322         _;
323     }
324 
325     /**
326      * @dev Modifier to make a function callable only when the contract is paused.
327      */
328     modifier whenPaused() {
329         require(paused);
330         _;
331     }
332 
333     /**
334      * @dev called by the owner to pause, triggers stopped state
335      */
336     function pause() onlyOwner whenNotPaused public {
337         paused = true;
338         Pause();
339     }
340 
341     /**
342      * @dev called by the owner to unpause, returns to normal state
343      */
344     function unpause() onlyOwner whenPaused public {
345         paused = false;
346         Unpause();
347     }
348 }
349 
350 interface ABAToken {
351     function transfer(address _to, uint256 _value) public returns (bool);
352 }
353 
354 contract FundCrowdsale is Ownable, Pausable, Destructible {
355 		using SafeMath for uint;
356     address public beneficiary;  // 募资成功后的收款方
357     address public fundAddress;	 // 机构钱包地址
358     uint public fundingGoal;     // 募资目标，单位是ether
359     uint public amountRaised;    // 已筹集金额数量， 单位是wei
360     uint8 public decimals = 18;
361     
362     uint public numTokenPerEth;           // token与以太坊的汇率, 一个eth可以兑换多少个Token
363     uint public maxTokenNum;     // 机构可以购买最大的Token数量
364     ABAToken public tokenAddress;    // 要卖的token合约地址
365     
366     DateTime public dateTime;
367     
368     mapping(address => uint256) public balanceOf; //保存募资地址
369    
370     //记录已接收的ether通知
371     event GoalReached(address recipient, uint totalAmountRaised);
372     
373     //转帐通知
374     event FundTransfer(address backer, uint amount, bool isContribution);
375     
376     /**
377      * 构造函数, 设置相关属性
378      */
379     function FundCrowdsale(){
380             beneficiary = 0x63759be273413954Ea91778a720E51c3d7Bc1F7F;	// 募资成功后的收款方
381             fundAddress = 0x00f60Dd7De6689b07095a922043aF529cd6A817d;	// 机构钱包地址
382             fundingGoal = 3000 * 1 ether;		// 私募ETH数量
383             numTokenPerEth = 2833;					// 兑换比例
384             maxTokenNum = fundingGoal*numTokenPerEth * 10 ** uint256(decimals);		//兑换ABA总数
385             tokenAddress = ABAToken(0x7C2AF3a86B4bf47E6Ee63AD9bde7B3B0ba7F95da);   // 传入已发布的 token 合约的地址来创建实例
386             
387             dateTime = new DateTime();
388     }
389     
390 
391     /**
392      * 无函数名的Fallback函数，
393      * 
394      * 在向合约转账时，这个函数会被调用
395      */
396     function () payable public {
397         require(fundAddress == msg.sender);
398         require(msg.value <= fundingGoal);
399         require(msg.value > 0);
400         
401         uint amount = msg.value;
402 
403         // 机构的金额累加
404         balanceOf[msg.sender] += amount;
405 
406         // 机构总额累加
407         amountRaised += amount;
408 
409         uint numToken = amount * numTokenPerEth;
410         if (numToken >= maxTokenNum)
411         {
412         		numToken = maxTokenNum;
413         }
414         
415         maxTokenNum = maxTokenNum - numToken;
416         tokenAddress.transfer(msg.sender, numToken);
417         FundTransfer(msg.sender, amount, true);
418     }
419 
420     /**
421      * 将合约中剩余的ABA转到指定账户
422      */
423     function moveTokenToAccount(address adrrSendTo, uint numToken) onlyOwner whenNotPaused public {
424         if (now < dateTime.toTimestamp(2018,7,7)) throw;
425     		tokenAddress.transfer(adrrSendTo, numToken* 10 ** uint256(decimals));
426     }
427 
428     /**
429      * 判断募资是否完成融资目标
430      */
431     function checkGoalReached() onlyOwner whenNotPaused public {
432         if (amountRaised >= fundingGoal) {
433             GoalReached(beneficiary, amountRaised);
434         }
435     }
436     
437     /**
438      * 融资款发送到收款方
439      */
440     function safeWithdrawal(uint amount) onlyOwner whenNotPaused public {
441         if (beneficiary.send(amount)) {
442             FundTransfer(beneficiary, amount, false);
443         }
444     }
445 }