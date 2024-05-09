1 pragma experimental "v0.5.0";
2 
3 ////////////////////
4 //   HOURLY PAY   //
5 //    CONTRACT    //
6 //    v 0.2.1     //
7 ////////////////////
8 
9 // The Hourly Pay Contract allows you to track your time and get paid a hourly wage for tracked time.
10 //
11 // HOW IT WORKS:
12 //
13 //  1. Client creates the contract, making himself the owner of the contract.
14 //
15 //  2. Client can fund the contract with ETH by simply sending money to the contract (via payable fallback function).
16 //
17 //  3. Before hiring someone, client can change additional parameters, such as:
18 //
19 //      - setContractDurationInDays(days) - The duration of the contract (default is 365 days).
20 //
21 //      - setDailyHourLimit(hours) - How much hours the Employee can work per day (default is 8 hours).
22 //
23 //      - setPaydayFrequencyInDays(days) - How often the Employee can withdraw the earnings (default is every 3 days).
24 //
25 //      - setBeginTimeTS(utcTimestamp) - Work on contract can be started after this timestamp (default is contract creation time).
26 //                                       Also defines the start of Day and Week for accounting and daily limits.
27 //                                       Day transition time should be convenient for the employee (like 4am),
28 //                                       so that work doesn't cross between days,
29 //                                       The excess won't be transferred to the next day.
30 //
31 //  4. Client hires the Employee by invoking hire(addressOfEmployee, ratePerHourInWei)
32 //     This starts the project and puts the contract in a workable state.
33 //     Before hiring, contract should be loaded with enough ETH to provide at least one day of work at specified ratePerHourInWei
34 // 
35 //  5. To start work and earn ETH the Employee should:
36 //
37 //      invoke startWork() when he starts working to run the timer.
38 //
39 //      invoke stopWork() when he finishes working to stop the timer.
40 //
41 //    After the timer is stopped - the ETH earnings are calculated and recorded on Employee's internal balance.
42 //    If the stopWork() is invoked after more hours had passed than dailyLimit - the excess is ignored
43 //    and only the dailyLimit is added to the internal balance.
44 //
45 //  6. Employee can withdraw earnings from internal balance after paydayFrequencyInDays days have passed after BeginTimeTS:
46 //      by invoking withdraw()
47 //
48 //    After each withdrawal the paydayFrequencyInDays is reset and starts counting itself from the TS of the first startWork() after withdrawal.
49 //
50 //    This delay is implemented as a safety mechanism, so the Client can have time to check the work and
51 //    cancel the earnings if something goes wrong.
52 //    That way only money earned during the last paydayFrequencyInDays is at risk.
53 //
54 //  7. Client can fire() the Employee after his services are no longer needed.
55 //    That would stop any ongoing work by terminating the timer and won't allow to start the work again.
56 //
57 //  8. If anything in the relationship or hour counting goes wrong, there are safety functions:
58 //      - refundAll() - terminates all unwithdrawn earnings.
59 //      - refund(amount) - terminates the (amount) of unwithdrawn earnings.
60 //    Can be only called if not working.
61 //    Both of these can be called by Client or Employee.
62 //      * TODO: Still need to think if allowing Client to do that won't hurt the Employee.
63 //      * TODO: SecondsWorkedToday don't reset after refund, so dailyLimit still affects
64 //      * TODO: Think of a better name. ClearEarnings?
65 //
66 //  9. Client can withdraw any excess ETH from the contract via:
67 //      - clientWithdrawAll() - withdraws all funds minus locked in earnings.
68 //      - clientWithdraw(amount) - withdraws (amount), not locked in earnings.
69 //     Can be invoked only if Employee isn't hired or has been fired.
70 //
71 // 10. Client and Contract Ownership can be made "Public"/"None" by calling:
72 //      - releaseOwnership()
73 //     It simply sets the Owner (Client) to 0x0, so no one is in control of the contract anymore.
74 //     That way the contract can be used on projects as Hourly-Wage Donations.
75 //
76 ///////////////////////////////////////////////////////////////////////////////////////////////////
77 
78 contract HourlyPay { 
79 
80     ////////////////////////////////
81     // Addresses
82 
83     address public owner;           // Client and owner address
84     address public employeeAddress = 0x0;  // Employee address
85 
86 
87     /////////////////////////////////
88     // Contract business properties
89     
90     uint public beginTimeTS;               // When the contract work can be started. Also TS of day transition.
91     uint public ratePerHourInWei;          // Employee rate in wei
92     uint public earnings = 0;              // Earnings of employee
93     bool public hired = false;             // If the employee is hired and approved to perform work
94     bool public working = false;           // Is employee currently working with timer on?
95     uint public startedWorkTS;             // Timestamp of when the timer started counting time
96     uint public workedTodayInSeconds = 0;  // How many seconds worked today
97     uint public currentDayTS;
98     uint public lastPaydayTS;
99     string public contractName = "Hourly Pay Contract";
100 
101     ////////////////////////////////
102     // Contract Limits and maximums
103     
104     uint16 public contractDurationInDays = 365;  // Overall contract duration in days, default is 365 and it's also maximum for safety reasons
105     uint8 public dailyHourLimit = 8;               // Limits the hours per day, max 24 hours
106     uint8 public paydayFrequencyInDays = 3;       // How often can Withdraw be called, default is every 3 days
107 
108     uint8 constant hoursInWeek = 168;
109     uint8 constant maxDaysInFrequency = 30; // every 30 days is a wise maximum
110 
111 
112     ////////////////
113     // Constructor
114 
115     constructor() public {
116         owner = msg.sender;
117         beginTimeTS = now;
118         currentDayTS = beginTimeTS;
119         lastPaydayTS = beginTimeTS;
120     }
121 
122 
123     //////////////
124     // Modifiers
125 
126     modifier onlyOwner {
127         require(msg.sender == owner);
128         _;
129     }
130 
131     modifier onlyEmployee {
132         require(msg.sender == employeeAddress);
133         _;
134     }
135     
136     modifier onlyOwnerOrEmployee {
137         require((msg.sender == employeeAddress) || (msg.sender == owner));
138         _;
139     }
140 
141     modifier beforeHire {
142         require(employeeAddress == 0x0);                        // Contract can hire someone only once
143         require(hired == false);                                // Shouldn't be already hired
144         _;
145     }
146 
147 
148     ///////////
149     // Events
150     
151     event GotFunds(address sender, uint amount);
152     event ContractDurationInDaysChanged(uint16 contractDurationInDays);
153     event DailyHourLimitChanged(uint8 dailyHourLimit);
154     event PaydayFrequencyInDaysChanged(uint32 paydayFrequencyInDays);
155     event BeginTimeTSChanged(uint beginTimeTS);
156     event Hired(address employeeAddress, uint ratePerHourInWei, uint hiredTS);
157     event NewDay(uint currentDayTS, uint16 contractDaysLeft);
158     event StartedWork(uint startedWorkTS, uint workedTodayInSeconds, string comment);
159     event StoppedWork(uint stoppedWorkTS, uint workedInSeconds, uint earned);
160     event Withdrawal(uint amount, address employeeAddress, uint withdrawalTS);
161     event Fired(address employeeAddress, uint firedTS);
162     event Refunded(uint amount, address whoInitiatedRefund, uint refundTS);
163     event ClientWithdrawal(uint amount, uint clientWithdrawalTS);
164     event ContractNameChanged(string contractName);
165     
166     ////////////////////////////////////////////////
167     // Fallback function to fund contract with ETH
168     
169     function () external payable {
170         emit GotFunds(msg.sender, msg.value);
171     }
172     
173     
174     ///////////////////////////
175     // Main Setters
176 
177     function setContractName(string newContractName) external onlyOwner beforeHire {
178         contractName = newContractName;
179         emit ContractNameChanged(contractName);
180     }
181 
182     function setContractDurationInDays(uint16 newContractDurationInDays) external onlyOwner beforeHire {
183         require(newContractDurationInDays <= 365);
184         contractDurationInDays = newContractDurationInDays;
185         emit ContractDurationInDaysChanged(contractDurationInDays);
186     }
187     
188     function setDailyHourLimit(uint8 newDailyHourLimit) external onlyOwner beforeHire {
189         require(newDailyHourLimit <= 24);
190         dailyHourLimit = newDailyHourLimit;
191         emit DailyHourLimitChanged(dailyHourLimit);
192     }
193 
194     function setPaydayFrequencyInDays(uint8 newPaydayFrequencyInDays) external onlyOwner beforeHire {
195         require(newPaydayFrequencyInDays < maxDaysInFrequency);
196         paydayFrequencyInDays = newPaydayFrequencyInDays;
197         emit PaydayFrequencyInDaysChanged(paydayFrequencyInDays);
198     }
199     
200     function setBeginTimeTS(uint newBeginTimeTS) external onlyOwner beforeHire {
201         beginTimeTS = newBeginTimeTS;
202         currentDayTS = beginTimeTS;
203         lastPaydayTS = beginTimeTS;
204         emit BeginTimeTSChanged(beginTimeTS);
205     }
206     
207     ///////////////////
208     // Helper getters
209     
210     function getWorkSecondsInProgress() public view returns(uint) {
211         if (!working) return 0;
212         return now - startedWorkTS;
213     }
214     
215     function isOvertime() external view returns(bool) {
216         if (workedTodayInSeconds + getWorkSecondsInProgress() > dailyHourLimit * 1 hours) return true;
217         return false;
218     }
219     
220     function hasEnoughFundsToStart() public view returns(bool) {
221         return ((address(this).balance > earnings) &&
222                 (address(this).balance - earnings >= ratePerHourInWei * (dailyHourLimit * 1 hours - (isNewDay() ? 0 : workedTodayInSeconds)) / 1 hours));
223     }
224     
225     function isNewDay() public view returns(bool) {
226         return (now - currentDayTS > 1 days);
227     }
228     
229     function canStartWork() public view returns(bool) {
230         return (hired
231             && !working
232             && (now > beginTimeTS)
233             && (now < beginTimeTS + (contractDurationInDays * 1 days))
234             && hasEnoughFundsToStart()
235             && ((workedTodayInSeconds < dailyHourLimit * 1 hours) || isNewDay()));
236     }
237 
238     function canStopWork() external view returns(bool) {
239         return (working
240             && hired
241             && (now > startedWorkTS));
242     }
243 
244     function currentTime() external view returns(uint) {
245         return now;
246     }
247 
248     function getBalance() external view returns(uint) {
249         return address(this).balance;
250     }
251 
252     ////////////////////////////
253     // Main workflow functions
254 
255     function releaseOwnership() external onlyOwner {
256         owner = 0x0;
257     }
258 
259     function hire(address newEmployeeAddress, uint newRatePerHourInWei) external onlyOwner beforeHire {
260         require(newEmployeeAddress != 0x0);                     // Protection from burning the ETH
261 
262         // Contract should be loaded with ETH for a minimum one day balance to perform Hire:
263         require(address(this).balance >= newRatePerHourInWei * dailyHourLimit);
264         employeeAddress = newEmployeeAddress;
265         ratePerHourInWei = newRatePerHourInWei;
266         
267         hired = true;
268         emit Hired(employeeAddress, ratePerHourInWei, now);
269     }
270 
271     function startWork(string comment) external onlyEmployee {
272         require(hired == true);
273         require(working == false);
274         
275         require(now > beginTimeTS); // can start working only after contract beginTimeTS
276         require(now < beginTimeTS + (contractDurationInDays * 1 days)); // can't start after contractDurationInDays has passed since beginTimeTS
277         
278         checkForNewDay();
279         
280         require(workedTodayInSeconds < dailyHourLimit * 1 hours); // can't start if already approached dailyHourLimit
281 
282         require(address(this).balance > earnings); // balance must be greater than earnings        
283 
284         // balance minus earnings must be sufficient for at least 1 day of work minus workedTodayInSeconds:
285         require(address(this).balance - earnings >= ratePerHourInWei * (dailyHourLimit * 1 hours - workedTodayInSeconds) / 1 hours);
286         
287         if (earnings == 0) lastPaydayTS = now; // reset the payday timer TS if this is the first time work starts after last payday
288 
289         startedWorkTS = now;
290         working = true;
291         
292         emit StartedWork(startedWorkTS, workedTodayInSeconds, comment);
293     }
294     
295     function checkForNewDay() internal {
296         if (now - currentDayTS > 1 days) { // new day
297             while (currentDayTS < now) {
298                 currentDayTS += 1 days;
299             }
300             currentDayTS -= 1 days;
301             workedTodayInSeconds = 0;
302             emit NewDay(currentDayTS, uint16 ((beginTimeTS + (contractDurationInDays * 1 days) - currentDayTS) / 1 days));
303         }
304     }
305     
306     function stopWork() external onlyEmployee {
307         stopWorkInternal();
308     }
309     
310     function stopWorkInternal() internal {
311         require(hired == true);
312         require(working == true);
313     
314         require(now > startedWorkTS); // just a temporary overflow check, in case of miners manipulate time
315         
316         
317         uint newWorkedTodayInSeconds = workedTodayInSeconds + (now - startedWorkTS);
318         if (newWorkedTodayInSeconds > dailyHourLimit * 1 hours) { // check for overflow
319             newWorkedTodayInSeconds = dailyHourLimit * 1 hours;   // and assign max dailyHourLimit if there is an overflow
320         }
321         
322         uint earned = (newWorkedTodayInSeconds - workedTodayInSeconds) * ratePerHourInWei / 1 hours;
323         earnings += earned; // add new earned ETH to earnings
324         
325         emit StoppedWork(now, newWorkedTodayInSeconds - workedTodayInSeconds, earned);
326 
327         workedTodayInSeconds = newWorkedTodayInSeconds; // updated todays works in seconds
328         working = false;
329 
330         checkForNewDay();
331     }
332 
333     function withdraw() external onlyEmployee {
334         require(working == false);
335         require(earnings > 0);
336         require(earnings <= address(this).balance);
337         
338         require(now - lastPaydayTS > paydayFrequencyInDays * 1 days); // check if payday frequency days passed after last withdrawal
339         
340         lastPaydayTS = now;
341         uint amountToWithdraw = earnings;
342         earnings = 0;
343         
344         employeeAddress.transfer(amountToWithdraw);
345         
346         emit Withdrawal(amountToWithdraw, employeeAddress, now);
347     }
348     
349     function withdrawAfterEnd() external onlyEmployee {
350         require(owner == 0x0); // only if there's no owner
351         require(now > beginTimeTS + (contractDurationInDays * 1 days)); // only after contract end
352         require(address(this).balance > 0); // only if there's balance
353 
354         employeeAddress.transfer(address(this).balance);
355         emit Withdrawal(address(this).balance, employeeAddress, now);
356     }
357     
358     function fire() external onlyOwner {
359         if (working) stopWorkInternal(); // cease all motor functions if working
360         
361         hired = false; // fire
362         
363         emit Fired(employeeAddress, now);
364     }
365 
366     function refundAll() external onlyOwnerOrEmployee {    // terminates all unwithdrawn earnings.
367         require(working == false);
368         require(earnings > 0);
369         uint amount = earnings;
370         earnings = 0;
371 
372         emit Refunded(amount, msg.sender, now);
373     }
374     
375     function refund(uint amount) external onlyOwnerOrEmployee {  // terminates the (amount) of unwithdrawn earnings.
376         require(working == false);
377         require(amount < earnings);
378         earnings -= amount;
379 
380         emit Refunded(amount, msg.sender, now);
381     }
382 
383     function clientWithdrawAll() external onlyOwner { // withdraws all funds minus locked in earnings.
384         require(hired == false);
385         require(address(this).balance > earnings);
386         uint amount = address(this).balance - earnings;
387         
388         owner.transfer(amount);
389         
390         emit ClientWithdrawal(amount, now);
391     }
392     
393     function clientWithdraw(uint amount) external onlyOwner { // withdraws (amount), if not locked in earnings.
394         require(hired == false);
395         require(address(this).balance > earnings);
396         require(amount < address(this).balance);
397         require(address(this).balance - amount > earnings);
398         
399         owner.transfer(amount);
400 
401         emit ClientWithdrawal(amount, now);
402     }
403 }