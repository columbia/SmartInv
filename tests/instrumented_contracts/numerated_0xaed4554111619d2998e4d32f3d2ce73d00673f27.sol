1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title SafeMath32
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath32 {
56 
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
61     if (a == 0) {
62       return 0;
63     }
64     uint32 c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint32 a, uint32 b) internal pure returns (uint32) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint32 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint32 a, uint32 b) internal pure returns (uint32) {
91     uint32 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 
98 /**
99  * @title Ether Habits
100  * @dev Implements the logic behind Ether Habits
101  */
102 contract Habits {
103     
104     using SafeMath for uint256;
105     using SafeMath32 for uint32;
106 
107     // owner is only set on contract initialization, this cannot be changed
108     address internal owner;
109     mapping (address => bool) internal adminPermission;
110     
111     uint256 constant REGISTRATION_FEE = 0.005 ether;  // deposit for a single day
112     uint32 constant NUM_REGISTER_DAYS = 10;  // default number of days for registration
113     uint32 constant NINETY_DAYS = 90 days;
114     uint32 constant WITHDRAW_BUFFER = 129600;  // time before user can withdraw deposit
115     uint32 constant MAY_FIRST_2018 = 1525132800;
116     uint32 constant DAY = 86400;
117 
118     enum UserEntryStatus {
119         NULL,
120         REGISTERED,
121         COMPLETED,
122         WITHDRAWN
123     }
124 
125     struct DailyContestStatus {
126         uint256 numRegistered;
127         uint256 numCompleted;
128         bool operationFeeWithdrawn;
129     }
130 
131     mapping (address => uint32[]) internal userToDates;
132     mapping (uint32 => address[]) internal dateToUsers;
133     mapping (address => mapping (uint32 => UserEntryStatus)) internal userDateToStatus;
134     mapping (uint32 => DailyContestStatus) internal dateToContestStatus;
135 
136     event LogWithdraw(address user, uint256 amount);
137     event LogOperationFeeWithdraw(address user, uint256 amount);
138 
139     /**
140      * @dev Sets the contract creator as the owner. Owner can't be changed in the future
141      */
142     function Habits() public {
143         owner = msg.sender;
144         adminPermission[owner] = true;
145     }
146 
147     /**
148      * @dev Registers a user for NUM_REGISTER_DAYS days
149      * @notice Changes state
150      * @param _expectedStartDate (unix time: uint32) Start date the user had in mind when submitting the transaction
151      */
152     function register(uint32 _expectedStartDate) external payable {
153         // throw if sent ether doesn't match the total registration fee
154         require(REGISTRATION_FEE.mul(NUM_REGISTER_DAYS) == msg.value);
155 
156         // can't register more than 100 days in advance
157         require(_expectedStartDate <= getDate(uint32(now)).add(NINETY_DAYS));
158 
159         uint32 startDate = getStartDate();
160         // throw if actual start day doesn't match the user's expectation
161         // may happen if a transaction takes a while to get mined
162         require(startDate == _expectedStartDate);
163 
164         for (uint32 i = 0; i < NUM_REGISTER_DAYS; i++) {
165             uint32 date = startDate.add(i.mul(DAY));
166 
167             // double check that user already hasn't been registered
168             require(userDateToStatus[msg.sender][date] == UserEntryStatus.NULL);
169 
170             userDateToStatus[msg.sender][date] = UserEntryStatus.REGISTERED;
171             userToDates[msg.sender].push(date);
172             dateToUsers[date].push(msg.sender);
173             dateToContestStatus[date].numRegistered += 1;
174         }
175     }
176 
177     /**
178      * @dev Checks-in a user for a given day
179      * @notice Changes state
180      */
181     function checkIn() external {
182         uint32 nowDate = getDate(uint32(now));
183 
184         // throw if user entry status isn't registered
185         require(userDateToStatus[msg.sender][nowDate] == UserEntryStatus.REGISTERED);
186         userDateToStatus[msg.sender][nowDate] = UserEntryStatus.COMPLETED;
187         dateToContestStatus[nowDate].numCompleted += 1;
188     }
189 
190     /**
191      * @dev Allow users to withdraw deposit and bonus for checked-in dates
192      * @notice Changes state
193      * @param _dates Array of dates user wishes to withdraw for, this is
194      * calculated beforehand and verified in this method to reduce gas costs
195      */
196     function withdraw(uint32[] _dates) external {
197         uint256 withdrawAmount = 0;
198         uint256 datesLength = _dates.length;
199         uint32 now32 = uint32(now);
200         for (uint256 i = 0; i < datesLength; i++) {
201             uint32 date = _dates[i];
202             // if it hasn't been more than 1.5 days since the entry, skip
203             if (now32 <= date.add(WITHDRAW_BUFFER)) {
204                 continue;
205             }
206             // if the entry status is anything other than COMPLETED, skip
207             if (userDateToStatus[msg.sender][date] != UserEntryStatus.COMPLETED) {
208                 continue;
209             }
210 
211             // set status to WITHDRAWN to prevent re-entry
212             userDateToStatus[msg.sender][date] = UserEntryStatus.WITHDRAWN;
213             withdrawAmount = withdrawAmount.add(REGISTRATION_FEE).add(calculateBonus(date));
214         }
215 
216         if (withdrawAmount > 0) {
217            msg.sender.transfer(withdrawAmount);
218         }
219         LogWithdraw(msg.sender, withdrawAmount);
220     }
221 
222     /**
223      * @dev Calculate current withdrawable amount for a user
224      * @notice Doesn't change state
225      * @return Amount of withdrawable Wei
226      */
227     function calculateWithdrawableAmount() external view returns (uint256) {
228         uint32[] memory dates = userToDates[msg.sender];
229         uint256 datesLength = dates.length;
230         uint256 withdrawAmount = 0;
231         uint32 now32 = uint32(now);
232         for (uint256 i = 0; i < datesLength; i++) {
233             uint32 date = dates[i];
234             // if it hasn't been more than 1.5 days since the entry, skip
235             if (now32 <= date.add(WITHDRAW_BUFFER)) {
236                 continue;
237             }
238             // if the entry status is anything other than COMPLETED, skip
239             if (userDateToStatus[msg.sender][date] != UserEntryStatus.COMPLETED) {
240                 continue;
241             }
242             withdrawAmount = withdrawAmount.add(REGISTRATION_FEE).add(calculateBonus(date));
243         }
244 
245         return withdrawAmount;
246     }
247 
248     /**
249      * @dev Calculate dates that a user can withdraw his/her deposit
250      * array may contain zeros so those need to be filtered out by the client
251      * @notice Doesn't change state
252      * @return Array of dates (unix time: uint32)
253      */
254     function getWithdrawableDates() external view returns(uint32[]) {
255         uint32[] memory dates = userToDates[msg.sender];
256         uint256 datesLength = dates.length;
257         // We can't initialize a mutable array in memory, so creating an array
258         // with length set as the number of regsitered days
259         uint32[] memory withdrawableDates = new uint32[](datesLength);
260         uint256 index = 0;
261         uint32 now32 = uint32(now);
262 
263         for (uint256 i = 0; i < datesLength; i++) {
264             uint32 date = dates[i];
265             // if it hasn't been more than 1.5 days since the entry, skip
266             if (now32 <= date.add(WITHDRAW_BUFFER)) {
267                 continue;
268             }
269             // if the entry status is anything other than COMPLETED, skip
270             if (userDateToStatus[msg.sender][date] != UserEntryStatus.COMPLETED) {
271                 continue;
272             }
273             withdrawableDates[index] = date;
274             index += 1;
275         }
276 
277         // this array may contain zeroes at the end of the array
278         return withdrawableDates;
279     }
280 
281     /**
282      * @dev Return registered days and statuses for a user
283      * @notice Doesn't change state
284      * @return Tupple of two arrays (dates registered, statuses)
285      */
286     function getUserEntryStatuses() external view returns (uint32[], uint32[]) {
287         uint32[] memory dates = userToDates[msg.sender];
288         uint256 datesLength = dates.length;
289         uint32[] memory statuses = new uint32[](datesLength);
290 
291         for (uint256 i = 0; i < datesLength; i++) {
292             statuses[i] = uint32(userDateToStatus[msg.sender][dates[i]]);
293         }
294         return (dates, statuses);
295     }
296 
297     /**
298      * @dev Withdraw operation fees for a list of dates
299      * @notice Changes state, owner only
300      * @param _dates Array of dates to withdraw operation fee
301      */
302     function withdrawOperationFees(uint32[] _dates) external {
303         // throw if sender isn't contract owner
304         require(msg.sender == owner);
305 
306         uint256 withdrawAmount = 0;
307         uint256 datesLength = _dates.length;
308         uint32 now32 = uint32(now);
309 
310         for (uint256 i = 0; i < datesLength; i++) {
311             uint32 date = _dates[i];
312             // if it hasn't been more than 1.5 days since the entry, skip
313             if (now32 <= date.add(WITHDRAW_BUFFER)) {
314                 continue;
315             }
316             // if already withdrawn for given date, skip
317             if (dateToContestStatus[date].operationFeeWithdrawn) {
318                 continue;
319             }
320             // set operationFeeWithdrawn to true to prevent re-entry
321             dateToContestStatus[date].operationFeeWithdrawn = true;
322             withdrawAmount = withdrawAmount.add(calculateOperationFee(date));
323         }
324 
325         if (withdrawAmount > 0) {
326             msg.sender.transfer(withdrawAmount);
327         }
328         LogOperationFeeWithdraw(msg.sender, withdrawAmount);
329     }
330 
331     /**
332      * @dev Get total withdrawable operation fee amount and dates, owner only
333      * array may contain zeros so those need to be filtered out by the client
334      * @notice Doesn't change state
335      * @return Tuple(Array of dates (unix time: uint32), amount)
336      */
337     function getWithdrawableOperationFeeDatesAndAmount() external view returns (uint32[], uint256) {
338         // throw if sender isn't contract owner
339         if (msg.sender != owner) {
340             return (new uint32[](0), 0);
341         }
342 
343         uint32 cutoffTime = uint32(now).sub(WITHDRAW_BUFFER);
344         uint32 maxLength = cutoffTime.sub(MAY_FIRST_2018).div(DAY).add(1);
345         uint32[] memory withdrawableDates = new uint32[](maxLength);
346         uint256 index = 0;
347         uint256 withdrawAmount = 0;
348         uint32 date = MAY_FIRST_2018;
349 
350         while(date < cutoffTime) {
351             if (!dateToContestStatus[date].operationFeeWithdrawn) {
352                 uint256 amount = calculateOperationFee(date);
353                 if (amount > 0) {
354                     withdrawableDates[index] = date;
355                     withdrawAmount = withdrawAmount.add(amount);
356                     index += 1;
357                 }
358             }
359             date = date.add(DAY);
360         } 
361         return (withdrawableDates, withdrawAmount);
362     }
363 
364     /**
365      * @dev Get contest status, only return complete and bonus numbers if it's been past the withdraw buffer
366      * Return -1 for complete and bonus numbers if still before withdraw buffer
367      * @notice Doesn't change state
368      * @param _date Date to get DailyContestStatus for
369      * @return Tuple(numRegistered, numCompleted, bonus)
370      */
371     function getContestStatusForDate(uint32 _date) external view returns (int256, int256, int256) {
372         DailyContestStatus memory dailyContestStatus = dateToContestStatus[_date];
373         int256 numRegistered = int256(dailyContestStatus.numRegistered);
374         int256 numCompleted = int256(dailyContestStatus.numCompleted);
375         int256 bonus = int256(calculateBonus(_date));
376 
377         if (uint32(now) <= _date.add(WITHDRAW_BUFFER)) {
378             numCompleted = -1;
379             bonus = -1;
380         }
381         return (numRegistered, numCompleted, bonus);
382     }
383 
384     /**
385      * @dev Get next valid start date.
386      * Tomorrow or the next non-registered date is the next start date
387      * @notice Doesn't change state
388      * @return Next start date (unix time: uint32)
389      */
390     function getStartDate() public view returns (uint32) {
391         uint32 startDate = getNextDate(uint32(now));
392         uint32 lastRegisterDate = getLastRegisterDate();
393         if (startDate <= lastRegisterDate) {
394             startDate = getNextDate(lastRegisterDate);
395         }
396         return startDate;
397     }
398 
399     /**
400      * @dev Get the next UTC midnight date
401      * @notice Doesn't change state
402      * @param _timestamp (unix time: uint32)
403      * @return Next date (unix time: uint32)
404      */
405     function getNextDate(uint32 _timestamp) internal pure returns (uint32) {
406         return getDate(_timestamp.add(DAY));
407     }
408 
409     /**
410      * @dev Get the date floor (UTC midnight) for a given timestamp
411      * @notice Doesn't change state
412      * @param _timestamp (unix time: uint32)
413      * @return UTC midnight date (unix time: uint32)
414      */
415     function getDate(uint32 _timestamp) internal pure returns (uint32) {
416         return _timestamp.sub(_timestamp % DAY);
417     }
418 
419     /**
420      * @dev Get the last registered date for a user
421      * @notice Doesn't change state
422      * @return Last registered date (unix time: uint32), 0 if user has never registered
423      */
424     function getLastRegisterDate() internal view returns (uint32) {
425         uint32[] memory dates = userToDates[msg.sender];
426         uint256 pastRegisterCount = dates.length;
427 
428         if(pastRegisterCount == 0) {
429             return 0;
430         }
431         return dates[pastRegisterCount.sub(1)];
432     }
433 
434     /**
435      * @dev Calculate the bonus for a given day
436      * @notice Doesn't change state
437      * @param _date Date to calculate the bonus for (unix time: uint32)
438      * @return Bonus amount (unit256)
439      */ 
440     function calculateBonus(uint32 _date) internal view returns (uint256) {
441         DailyContestStatus memory status = dateToContestStatus[_date];
442         if (status.numCompleted == 0) {
443             return 0;
444         }
445         uint256 numFailed = status.numRegistered.sub(status.numCompleted);
446         // Split 90% of the forfeited deposits between completed users
447         return numFailed.mul(REGISTRATION_FEE).mul(9).div(
448             status.numCompleted.mul(10)
449         );
450     }
451 
452     /**
453      * @dev Calculate the operation fee for a given day
454      * @notice Doesn't change state
455      * @param _date Date to calculate the operation fee for (unix time: uint32)
456      * @return Operation fee amount (unit256)
457      */ 
458     function calculateOperationFee(uint32 _date) internal view returns (uint256) {
459         DailyContestStatus memory status = dateToContestStatus[_date];
460         // if no one has completed, take all as operation fee
461         if (status.numCompleted == 0) {
462             return status.numRegistered.mul(REGISTRATION_FEE);
463         }
464         uint256 numFailed = status.numRegistered.sub(status.numCompleted);
465         // 10% of forefeited deposits 
466         return numFailed.mul(REGISTRATION_FEE).div(10);
467     }
468 
469     /********************
470      * Admin only methods
471      ********************/
472 
473     /**
474      * @dev Adding an admin, owner only
475      * @notice Changes state
476      * @param _newAdmin Address of new admin
477      */ 
478     function addAdmin(address _newAdmin) external {
479         require(msg.sender == owner);
480         adminPermission[_newAdmin] = true;
481     }
482 
483     /**
484      * @dev Return all registered dates for a user, admin only
485      * @notice Doesn't change state
486      * @param _user User to get dates for
487      * @return All dates(uint32[]) the user registered for
488      */ 
489     function getDatesForUser(address _user) external view returns (uint32[]) {
490         if (!adminPermission[msg.sender]) {
491            return new uint32[](0); 
492         }
493         return userToDates[_user];
494     }
495 
496     /**
497      * @dev Return all registered users for a date, admin only
498      * @notice Doesn't change state
499      * @param _date Date to get users for
500      * @return All users(address[]) registered on a given date
501      */ 
502     function getUsersForDate(uint32 _date) external view returns (address[]) {
503         if (!adminPermission[msg.sender]) {
504            return new address[](0); 
505         }
506         return dateToUsers[_date];
507     }
508 
509     /**
510      * @dev Return entry status for a user and date, admin only
511      * @notice Doesn't change state
512      * @param _user User to get EntryStatus for
513      * @param _date (unix time: uint32) Date to get EntryStatus for
514      * @return UserEntryStatus
515      */ 
516     function getEntryStatus(address _user, uint32 _date)
517     external view returns (UserEntryStatus) {
518         if (!adminPermission[msg.sender]) {
519             return UserEntryStatus.NULL;
520         }
521         return userDateToStatus[_user][_date];
522     }
523 
524     /**
525      * @dev Get daily contest status, admin only
526      * @notice Doesn't change state
527      * @param _date Date to get DailyContestStatus for
528      * @return Tuple(uint256, uint256, bool)
529      */
530     function getContestStatusForDateAdmin(uint32 _date)
531     external view returns (uint256, uint256, bool) {
532         if (!adminPermission[msg.sender]) {
533             return (0, 0, false);
534         }
535         DailyContestStatus memory dailyContestStatus = dateToContestStatus[_date];
536         return (
537             dailyContestStatus.numRegistered,
538             dailyContestStatus.numCompleted,
539             dailyContestStatus.operationFeeWithdrawn
540         );
541     }
542 }