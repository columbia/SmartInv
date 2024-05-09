1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-13
3 */
4 
5 pragma solidity 0.5.8;
6 
7 interface DateTimeAPI {
8     function getYear(uint timestamp) external pure returns (uint16);
9 
10     function getMonth(uint timestamp) external pure returns (uint8);
11 
12     function getDay(uint timestamp) external pure returns (uint8);
13 
14     function getHour(uint timestamp) external pure returns (uint8);
15 
16     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) external pure returns (uint);
17 }
18 
19 contract Ownable {
20     address public owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26      * account.
27      */
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(msg.sender == owner, "Called by unknown account");
37         _;
38     }
39 
40     /**
41      * @dev Allows the current owner to transfer control of the contract to a newOwner.
42      * @param newOwner The address to transfer ownership to.
43      */
44     function transferOwnership(address newOwner) onlyOwner public {
45         require(newOwner != address(0));
46         emit OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 }
50 
51 contract DateTime {
52     /*
53      *  Date and Time utilities for ethereum contracts
54      *
55      */
56     struct _DateTime {
57         uint16 year;
58         uint8 month;
59         uint8 day;
60         uint8 hour;
61         uint8 minute;
62         uint8 second;
63         uint8 weekday;
64     }
65 
66     uint constant DAY_IN_SECONDS = 86400;
67     uint constant YEAR_IN_SECONDS = 31536000;
68     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
69 
70     uint constant HOUR_IN_SECONDS = 3600;
71     uint constant MINUTE_IN_SECONDS = 60;
72 
73     uint16 constant ORIGIN_YEAR = 1970;
74 
75     function isLeapYear(uint16 year) public pure returns (bool) {
76         if (year % 4 != 0) {
77             return false;
78         }
79         if (year % 100 != 0) {
80             return true;
81         }
82         if (year % 400 != 0) {
83             return false;
84         }
85         return true;
86     }
87 
88     function leapYearsBefore(uint year) public pure returns (uint) {
89         year -= 1;
90         return year / 4 - year / 100 + year / 400;
91     }
92 
93     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
94         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
95             return 31;
96         }
97         else if (month == 4 || month == 6 || month == 9 || month == 11) {
98             return 30;
99         }
100         else if (isLeapYear(year)) {
101             return 29;
102         }
103         else {
104             return 28;
105         }
106     }
107 
108     function parseTimestamp(uint timestamp) internal pure returns (_DateTime memory dt) {
109         uint secondsAccountedFor = 0;
110         uint buf;
111         uint8 i;
112 
113         // Year
114         dt.year = getYear(timestamp);
115         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
116 
117         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
118         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
119 
120         // Month
121         uint secondsInMonth;
122         for (i = 1; i <= 12; i++) {
123             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
124             if (secondsInMonth + secondsAccountedFor > timestamp) {
125                 dt.month = i;
126                 break;
127             }
128             secondsAccountedFor += secondsInMonth;
129         }
130 
131         // Day
132         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
133             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
134                 dt.day = i;
135                 break;
136             }
137             secondsAccountedFor += DAY_IN_SECONDS;
138         }
139 
140         // Hour
141         dt.hour = getHour(timestamp);
142 
143         // Minute
144         dt.minute = getMinute(timestamp);
145 
146         // Second
147         dt.second = getSecond(timestamp);
148 
149         // Day of week.
150         dt.weekday = getWeekday(timestamp);
151     }
152 
153     function getYear(uint timestamp) public pure returns (uint16) {
154         uint secondsAccountedFor = 0;
155         uint16 year;
156         uint numLeapYears;
157 
158         // Year
159         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
160         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
161 
162         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
163         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
164 
165         while (secondsAccountedFor > timestamp) {
166             if (isLeapYear(uint16(year - 1))) {
167                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
168             }
169             else {
170                 secondsAccountedFor -= YEAR_IN_SECONDS;
171             }
172             year -= 1;
173         }
174         return year;
175     }
176 
177     function getMonth(uint timestamp) public pure returns (uint8) {
178         return parseTimestamp(timestamp).month;
179     }
180 
181     function getDay(uint timestamp) public pure returns (uint8) {
182         return parseTimestamp(timestamp).day;
183     }
184 
185     function getHour(uint timestamp) public pure returns (uint8) {
186         return uint8((timestamp / 60 / 60) % 24);
187     }
188 
189     function getMinute(uint timestamp) public pure returns (uint8) {
190         return uint8((timestamp / 60) % 60);
191     }
192 
193     function getSecond(uint timestamp) public pure returns (uint8) {
194         return uint8(timestamp % 60);
195     }
196 
197     function getWeekday(uint timestamp) public pure returns (uint8) {
198         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
199     }
200 
201     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
202         return toTimestamp(year, month, day, 0, 0, 0);
203     }
204 
205     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
206         return toTimestamp(year, month, day, hour, 0, 0);
207     }
208 
209     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
210         return toTimestamp(year, month, day, hour, minute, 0);
211     }
212 
213     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
214         uint16 i;
215 
216         // Year
217         for (i = ORIGIN_YEAR; i < year; i++) {
218             if (isLeapYear(i)) {
219                 timestamp += LEAP_YEAR_IN_SECONDS;
220             }
221             else {
222                 timestamp += YEAR_IN_SECONDS;
223             }
224         }
225 
226         // Month
227         uint8[12] memory monthDayCounts;
228         monthDayCounts[0] = 31;
229         if (isLeapYear(year)) {
230             monthDayCounts[1] = 29;
231         }
232         else {
233             monthDayCounts[1] = 28;
234         }
235         monthDayCounts[2] = 31;
236         monthDayCounts[3] = 30;
237         monthDayCounts[4] = 31;
238         monthDayCounts[5] = 30;
239         monthDayCounts[6] = 31;
240         monthDayCounts[7] = 31;
241         monthDayCounts[8] = 30;
242         monthDayCounts[9] = 31;
243         monthDayCounts[10] = 30;
244         monthDayCounts[11] = 31;
245 
246         for (i = 1; i < month; i++) {
247             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
248         }
249 
250         // Day
251         timestamp += DAY_IN_SECONDS * (day - 1);
252 
253         // Hour
254         timestamp += HOUR_IN_SECONDS * (hour);
255 
256         // Minute
257         timestamp += MINUTE_IN_SECONDS * (minute);
258 
259         // Second
260         timestamp += second;
261 
262         return timestamp;
263     }
264 }
265 
266 contract EJackpot is Ownable {
267     event CaseOpened(
268         uint amount,
269         uint prize,
270         address indexed user,
271         uint indexed timestamp
272     );
273 
274     struct ReferralStat {
275         uint profit;
276         uint count;
277     }
278 
279     struct Probability {
280         uint from;
281         uint to;
282     }
283 
284     uint public usersCount = 0;
285     uint public openedCases = 0;
286     uint public totalWins = 0;
287     Probability[11] public probabilities;
288     mapping(uint => uint[11]) public betsPrizes;
289     mapping(uint => bool) public cases;
290     uint[1/*9*/] public casesArr = [
291     5 * 10 ** 16/*,
292     10 ** 17,
293     2 * 10 ** 17,
294     3 * 10 ** 17,
295     5 * 10 ** 17,
296     7 * 10 ** 17,
297     10 ** 18,
298     15 * 10 ** 17,
299     2 * 10 ** 18*/
300     ];
301     mapping(uint => uint) public caseWins;
302     mapping(uint => uint) public caseOpenings;
303     mapping(address => bool) private users;
304     mapping(address => uint) private userCasesCount;
305     mapping(address => address payable) private referrals;
306     mapping(address => mapping(address => bool)) private usedReferrals;
307     mapping(address => ReferralStat) public referralStats;
308     uint private constant multiplier = 1 ether / 10000;
309     DateTimeAPI private dateTimeAPI;
310 
311     /**
312     * @dev The EJackpot constructor sets the default cases that are available for opening.
313     * @param _dateTimeAPI address of deployed DateTime contract
314     */
315     constructor(address _dateTimeAPI) public Ownable() {
316         dateTimeAPI = DateTimeAPI(_dateTimeAPI);
317         for (uint i = 0; i < 1/*9*/; i++) cases[casesArr[i]] = true;
318         probabilities[0] = Probability(1, 6);
319         probabilities[1] = Probability(7, 18);
320         probabilities[2] = Probability(19, 30);
321         probabilities[3] = Probability(31, 44);
322         probabilities[4] = Probability(45, 58);
323         probabilities[5] = Probability(59, 72);
324         probabilities[6] = Probability(73, 83);
325         probabilities[7] = Probability(84, 92);
326         probabilities[8] = Probability(93, 97);
327         probabilities[9] = Probability(98, 99);
328         probabilities[10] = Probability(100, 100);
329 
330         betsPrizes[5 * 10 ** 16] = [65, 100, 130, 170, 230, 333, 500, 666, 1350, 2000, 2500];
331 //        betsPrizes[10 ** 17] = [130, 200, 265, 333, 450, 666, 1000, 1350, 2650, 4000, 5000];
332 //        betsPrizes[2 * 10 ** 17] = [265, 400, 530, 666, 930, 1330, 2000, 2665, 5300, 8000, 10000];
333 //        betsPrizes[3 * 10 ** 17] = [400, 600, 800, 1000, 1400, 2000, 3000, 4000, 8000, 12000, 15000];
334 //        betsPrizes[5 * 10 ** 17] = [666, 1000, 1330, 1665, 2330, 3333, 5000, 6666, 13330, 20000, 25000];
335 //        betsPrizes[7 * 10 ** 17] = [950, 1400, 1850, 2330, 3265, 4665, 7000, 9330, 18665, 28000, 35000];
336 //        betsPrizes[10 ** 18] = [1330, 2000, 2665, 3333, 4666, 6666, 10000, 13330, 26660, 40000, 50000];
337 //        betsPrizes[15 * 10 ** 17] = [2000, 3000, 4000, 5000, 7000, 10000, 15000, 20000, 40000, 60000, 75000];
338 //        betsPrizes[2 * 10 ** 18] = [2665, 4000, 5330, 6666, 9350, 13330, 20000, 26665, 53330, 80000, 100000];
339     }
340 
341     /**
342      * @dev Shows the average winning rate in% with a normal distribution. For example, 10,000 = 100% or 7621 == 76.21%
343      */
344     function showCoefs() external view returns (uint[1/*9*/] memory result){
345         uint d = 10000;
346 
347         for (uint casesIndex = 0; casesIndex < casesArr.length; casesIndex++) {
348             uint sum = 0;
349             uint casesVal = casesArr[casesIndex];
350 
351             for (uint i = 0; i < probabilities.length; i++) {
352                 sum += multiplier * betsPrizes[casesVal][i] * (probabilities[i].to - probabilities[i].from + 1);
353             }
354 
355             result[casesIndex] = ((d * sum) / (casesVal * 100));
356         }
357     }
358 
359     /**
360      * @dev Allows the user to open case and win one of the available prizes.
361      */
362     function play(address payable referrer) external payable notContract(msg.sender, false) notContract(referrer, true) {
363         if (msg.sender == owner) return;
364         uint maxPrize = betsPrizes[msg.value][betsPrizes[msg.value].length - 1] * multiplier;
365         require(cases[msg.value] && address(this).balance >= maxPrize, "Contract balance is not enough");
366         openedCases++;
367         userCasesCount[msg.sender]++;
368         if (!users[msg.sender]) {
369             users[msg.sender] = true;
370             usersCount++;
371         }
372         uint prize = determinePrize();
373         caseWins[msg.value] += prize;
374         caseOpenings[msg.value]++;
375         totalWins += prize;
376         increaseDailyStat(prize);
377         msg.sender.transfer(prize);
378 
379         if (referrer == address(0x0) && referrals[msg.sender] == address(0x0)) return;
380 
381         int casinoProfit = int(msg.value) - int(prize);
382         if (referrer != address(0x0)) {
383             if (referrals[msg.sender] != address(0x0) && referrer != referrals[msg.sender]) referralStats[referrals[msg.sender]].count -= 1;
384             referrals[msg.sender] = referrer;
385         }
386         if (!usedReferrals[referrals[msg.sender]][msg.sender]) {
387             referralStats[referrals[msg.sender]].count++;
388             usedReferrals[referrals[msg.sender]][msg.sender] = true;
389         }
390         if (casinoProfit <= 0) return;
391         uint referrerProfit = uint(casinoProfit * 10 / 100);
392         referralStats[referrals[msg.sender]].profit += referrerProfit;
393         referrals[msg.sender].transfer(referrerProfit);
394     }
395 
396     /**
397      * @dev Determines which prize will be given to user by lottery.
398      * @return uint Amount of wei won by the user.
399      */
400     function determinePrize() private returns (uint) {
401         uint8 chance = random();
402         uint[11] memory prizes = betsPrizes[msg.value];
403         uint prize = 0;
404         for (uint i = 0; i < 11; i++) {
405             if (chance >= probabilities[i].from && chance <= probabilities[i].to) {
406                 prize = prizes[i] * multiplier;
407                 break;
408             }
409         }
410 
411         return prize;
412     }
413 
414     /**
415      * @dev Updates statistics for current date.
416      * @param prize Prize that was won by user.
417      */
418     function increaseDailyStat(uint prize) private {
419         uint16 year = dateTimeAPI.getYear(now);
420         uint8 month = dateTimeAPI.getMonth(now);
421         uint8 day = dateTimeAPI.getDay(now);
422         uint8 hour = dateTimeAPI.getHour(now);
423         uint timestamp = dateTimeAPI.toTimestamp(year, month, day, hour);
424 
425         emit CaseOpened(msg.value, prize, msg.sender, timestamp);
426     }
427 
428     /**
429      * @dev Allows the current owner to withdraw certain amount of ether from the contract.
430      * @param amount Amount of wei that needs to be withdrawn.
431      */
432     function withdraw(uint amount) external onlyOwner {
433         require(address(this).balance >= amount);
434         msg.sender.transfer(amount);
435     }
436 
437     function random() private view returns (uint8) {
438         return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, userCasesCount[msg.sender]))) % 100) + 1;
439     }
440 
441     modifier notContract(address addr, bool referrer) {
442         if (addr != address(0x0)) {
443             uint size;
444             assembly {size := extcodesize(addr)}
445             require(size <= 0, "Called by contract");
446             if (!referrer) require(tx.origin == addr, "Called by contract");
447         }
448         _;
449     }
450 }