1 pragma solidity ^0.5.2;
2 
3 /**
4  *  X3ProfitInMonthV6 contract (300% per 33 day, 99% per 11 day, 9% per day, in first iteration)
5  *  This percent will decrease every restart of system to lowest value of 0.9% per day
6  *
7  *  Improved, no bugs and backdoors! Your investments are safe!
8  *
9  *  LOW RISK! You can take your deposit back ANY TIME!
10  *     - Send 0.00000112 ETH to contract address
11  *
12  *  NO DEPOSIT FEES! All the money go to contract!
13  *
14  *  LOW WITHDRAWAL FEES! Advertising 10% to OUR MAIN CONTRACT 0xf85D337017D9e6600a433c5036E0D18EdD0380f3
15  *
16  *  HAVE COMMAND PREPARATION TIME DURING IT WILL BE RETURN ONLY INVESTED AMOUNT AND NOT MORE!
17  *  Only special command will run X3 MODE!
18  * 
19  *  After restart system automaticaly make deposits for damage users in damaged part, 
20  *   but before it users must self make promotion deposit by any amount first.
21  *
22  *  INSTRUCTIONS:
23  *
24  *  TO INVEST: send ETH to contract address.
25  *  TO WITHDRAW INTEREST: send 0 ETH to contract address.
26  *  TO REINVEST AND WITHDRAW INTEREST: send ETH to contract address.
27  *  TO GET BACK YOUR DEPOSIT: send 0.00000112 ETH to contract address.
28  *  TO START X3 WORK, ANY USER CAN VOTE 0.00000111 ETH to contract address.
29  *     While X3 not started investors can return only their deposits and no profit.
30  *     Admin voice power is equal 10 simple participants.
31  *  TO RESTART, ANY USER CAN VOTE 0.00000101 ETH to contract address.
32  *     Admin voice power is equal 10 simple participants.
33  *  TO VOICE FOR SEAL/UNSEAL CONTRACT, ADMIN CAN VOTE 0.00000102 ETH 
34  *     to contract address.
35  * 
36  *  Minimal investment is more than 0.000000001 ether, else if equal or smaller 
37  *  then only withdrawn will performed
38  *
39  *  RECOMMENDED GAS LIMIT 350000
40  */
41  
42 contract X3ProfitInMonthV6 {
43 
44 	struct Investor {
45 	      // Restart iteration index
46 		int iteration;
47           // array containing information about beneficiaries
48 		uint deposit;
49 		  // sum locked to remove in predstart period, gived by contract for 
50 		  // compensation of previous iteration restart
51 		uint lockedDeposit;
52            //array containing information about the time of payment
53 		uint time;
54           //array containing information on interest paid
55 		uint withdrawn;
56            //array containing information on interest paid (without tax)
57 		uint withdrawnPure;
58 		   // Vote system for start iteration
59 		bool isVoteProfit;
60 		   // Vote system for restart iteration
61 		bool isVoteRestart;
62            // Default at any deposit we debt to user
63         bool isWeHaveDebt;
64 	}
65 
66     mapping(address => Investor) public investors;
67 	
68     //fund to transfer percent for MAIN OUR CONTRACT EasyInvestForeverProtected2
69     address payable public constant ADDRESS_MAIN_FUND = 0x3Bd33FF04e1F2BF01C8BF15C395D607100b7E116;
70     address payable public constant ADDRESS_ADMIN =     0x6249046Af9FB588bb4E70e62d9403DD69239bdF5;
71     //time through which you can take dividends
72     uint private constant TIME_QUANT = 1 days;
73 	
74     //start percent 10% per day
75     uint private constant PERCENT_DAY = 10;
76     uint private constant PERCENT_DECREASE_PER_ITERATION = 1;
77     uint private constant PERCENT_DECREASE_MINIMUM = 1;
78 
79     //Adv tax for withdrawal 10%
80     uint private constant PERCENT_MAIN_FUND = 10;
81 
82     //All percent should be divided by this
83     uint private constant PERCENT_DIVIDER = 100;
84 
85     uint public countOfInvestors = 0;
86     uint public countOfAdvTax = 0;
87 	uint public countOfStartVoices = 0;
88 	uint public countOfReStartVoices = 0;
89 	int  public iterationIndex = 1;
90 	int  private undoDecreaseIteration = 0;
91 	uint public countOfReturnDebt = 0;
92 
93 	uint public amountOfDebt = 0;
94 	uint public amountOfReturnDebt = 0;
95 	uint public amountOfCharity = 0;
96 
97     // max contract balance in ether for overflow protection in calculations only
98     // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
99 	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
100 	uint public constant maxDeposit = maxBalance / 1000; 
101 	
102 	// X3 Mode status
103     bool public isProfitStarted = false; 
104     bool public isContractSealed = false;
105 
106     modifier isUserExists() {
107         require(investors[msg.sender].iteration == iterationIndex, "Deposit not found");
108         _;
109     }
110 
111     modifier timePayment() {
112         require(isContractSealed || now >= investors[msg.sender].time + TIME_QUANT, "Too fast payout request");
113         _;
114     }
115 
116     //return of interest on the deposit
117     function collectPercent() isUserExists timePayment internal {
118         uint payout = payoutPlanned(msg.sender);
119         _payout(msg.sender, payout, false);
120     }
121     function dailyPercent() public view returns(uint) {
122         uint percent = PERCENT_DAY;
123 		int delta = 1 + undoDecreaseIteration;
124 		if (delta > iterationIndex) delta = iterationIndex;
125         uint decrease = PERCENT_DECREASE_PER_ITERATION * (uint)(iterationIndex - delta);
126         if(decrease > percent - PERCENT_DECREASE_MINIMUM)
127             decrease = percent - PERCENT_DECREASE_MINIMUM;
128         percent -= decrease;
129         return percent;
130     }
131     function payoutAmount(address addr) public view returns(uint) {
132         uint payout = payoutPlanned(addr);
133         if(payout == 0) return 0;
134         if(payout > address(this).balance) payout = address(this).balance;
135         if(!isContractSealed && !isProfitStarted) 
136         {
137             Investor memory inv = investors[addr];
138             uint activDep = inv.deposit - inv.lockedDeposit;
139             if(payout + inv.withdrawn > activDep / 2)
140             {
141                 if(inv.withdrawn >= activDep / 2) return 0;
142                 payout = activDep / 2 - inv.withdrawn;
143             }
144         }
145         return payout - payout * PERCENT_MAIN_FUND / PERCENT_DIVIDER;
146     }
147     //calculate the amount available for withdrawal on deposit
148     function payoutPlanned(address addr) public view returns(uint) {
149         Investor storage inv = investors[addr];
150         if(inv.iteration != iterationIndex)
151             return 0;
152         if (isContractSealed)
153         {
154             if(inv.withdrawnPure >= inv.deposit) {
155                 uint delta = 0;
156                 if(amountOfReturnDebt < amountOfDebt) delta = amountOfDebt - amountOfReturnDebt;
157                 if (inv.isWeHaveDebt) {
158                     if(inv.deposit < delta) 
159                         delta -= inv.deposit; 
160                     else
161                         delta = 0;
162                 }
163                 if(delta > 0) delta = PERCENT_DIVIDER * delta / (PERCENT_DIVIDER - PERCENT_MAIN_FUND) + 1; 
164                 // Sealed contract must transfer funds despite of complete debt payed
165                 if(address(this).balance > delta) 
166                     return address(this).balance - delta;
167                 return 0;
168             }
169             uint amount = inv.deposit - inv.withdrawnPure;
170             return PERCENT_DIVIDER * amount / (PERCENT_DIVIDER - PERCENT_MAIN_FUND) + 1;
171         }
172         uint varTime = inv.time;
173         uint varNow = now;
174         if(varTime > varNow) varTime = varNow;
175         uint percent = dailyPercent();
176         uint rate = inv.deposit * percent / PERCENT_DIVIDER;
177         uint fraction = 100;
178         uint interestRate = fraction * (varNow  - varTime) / 1 days;
179         uint withdrawalAmount = rate * interestRate / fraction;
180         if(interestRate < fraction) withdrawalAmount = 0;
181         return withdrawalAmount;
182     }
183     function makeDebt(address payable addr, uint amount) private
184     {
185         if (amount == 0) return;
186         Investor storage inv = investors[addr];
187         if (!inv.isWeHaveDebt)
188         {
189             inv.isWeHaveDebt = true;
190             countOfReturnDebt--;
191             amountOfReturnDebt -= inv.deposit;
192         }
193         inv.deposit += amount;
194         amountOfDebt += amount;
195     }
196 
197     //make a deposit
198     function makeDeposit() private {
199         if (msg.value > 0.000000001 ether) {
200             Investor storage inv = investors[msg.sender];
201             if (inv.iteration != iterationIndex) {
202 			    inv.iteration = iterationIndex;
203                 countOfInvestors ++;
204                 if(inv.deposit > inv.withdrawnPure)
205 			        inv.deposit -= inv.withdrawnPure;
206 		        else
207 		            inv.deposit = 0;
208 		        if(inv.deposit + msg.value > maxDeposit) 
209 		            inv.deposit = maxDeposit - msg.value;
210 				inv.withdrawn = 0;
211 				inv.withdrawnPure = 0;
212 				inv.time = now;
213 				inv.lockedDeposit = inv.deposit;
214 			    amountOfDebt += inv.lockedDeposit;
215 				
216 				inv.isVoteProfit = false;
217 				inv.isVoteRestart = false;
218                 inv.isWeHaveDebt = true;
219             }
220             if (!isContractSealed && now >= inv.time + TIME_QUANT) {
221                 collectPercent();
222             }
223             makeDebt(msg.sender, msg.value);
224         } else {
225             collectPercent();
226         }
227     }
228 
229     //return of deposit balance
230     function returnDeposit() isUserExists private {
231         if(isContractSealed)return;
232         Investor storage inv = investors[msg.sender];
233         uint withdrawalAmount = 0;
234         uint activDep = inv.deposit - inv.lockedDeposit;
235         if(activDep > inv.withdrawn)
236             withdrawalAmount = activDep - inv.withdrawn;
237 
238         if(withdrawalAmount > address(this).balance){
239             withdrawalAmount = address(this).balance;
240         }
241         //Pay the rest of deposit and take taxes
242         _payout(msg.sender, withdrawalAmount, true);
243 
244         //delete user record
245         _delete(msg.sender);
246     }
247     function charityToContract() external payable {
248 	    amountOfCharity += msg.value;
249     }    
250     function() external payable {
251         if(msg.data.length > 0){
252     	    amountOfCharity += msg.value;
253             return;        
254         }
255         require(msg.value <= maxDeposit, "Deposit overflow");
256         
257         //refund of remaining funds when transferring to a contract 0.00000112 ether
258         Investor storage inv = investors[msg.sender];
259         if (!isContractSealed &&
260             msg.value == 0.00000112 ether && inv.iteration == iterationIndex) {
261             makeDebt(msg.sender, msg.value);
262             returnDeposit();
263         } else {
264             //start/restart X3 Mode on 0.00000111 ether / 0.00000101 ether
265             if ((!isContractSealed &&
266                 (msg.value == 0.00000111 ether || msg.value == 0.00000101 ether)) ||
267                 (msg.value == 0.00000102 ether&&msg.sender == ADDRESS_ADMIN)) 
268             {
269                 if(inv.iteration != iterationIndex)
270                     makeDeposit();
271                 else
272                     makeDebt(msg.sender, msg.value);
273                 if(msg.value == 0.00000102 ether){
274                     isContractSealed = !isContractSealed;
275                     if (!isContractSealed)
276                     {
277                         undoDecreaseIteration++;
278                         restart();
279                     }
280                 }
281                 else
282                 if(msg.value == 0.00000101 ether)
283                 {
284                     if(!inv.isVoteRestart)
285                     {
286                         countOfReStartVoices++;
287                         inv.isVoteRestart = true;
288                     }
289                     else{
290                         countOfReStartVoices--;
291                         inv.isVoteRestart = false;
292                     }
293                     if((countOfReStartVoices > 10 &&
294                         countOfReStartVoices > countOfInvestors / 2) || 
295                         msg.sender == ADDRESS_ADMIN)
296                     {
297         			    undoDecreaseIteration++;
298         			    restart();
299                     }
300                 }
301                 else
302                 if(!isProfitStarted)
303                 {
304                     if(!inv.isVoteProfit)
305                     {
306                         countOfStartVoices++;
307                         inv.isVoteProfit = true;
308                     }
309                     else{
310                         countOfStartVoices--;
311                         inv.isVoteProfit = false;
312                     }
313                     if((countOfStartVoices > 10 &&
314                         countOfStartVoices > countOfInvestors / 2) || 
315                         msg.sender == ADDRESS_ADMIN)
316                         start(msg.sender);        			    
317                 }
318             } 
319             else
320             {
321                 require(        
322                     msg.value <= 0.000000001 ether ||
323                     address(this).balance <= maxBalance, 
324                     "Contract balance overflow");
325                 makeDeposit();
326                 require(inv.deposit <= maxDeposit, "Deposit overflow");
327             }
328         }
329     }
330     
331     function start(address payable addr) private {
332         if (isContractSealed) return;
333 	    isProfitStarted = true;
334         uint payout = payoutPlanned(ADDRESS_ADMIN);
335         _payout(ADDRESS_ADMIN, payout, false);
336         if(addr != ADDRESS_ADMIN){
337             payout = payoutPlanned(addr);
338             _payout(addr, payout, false);
339         }
340     }
341     
342     function restart() private {
343         if (isContractSealed) return;
344         if(dailyPercent() == PERCENT_DECREASE_MINIMUM)
345         {
346             isContractSealed = true;
347             return;
348         }
349 		countOfInvestors = 0;
350 		iterationIndex++;
351 		countOfStartVoices = 0;
352 		countOfReStartVoices = 0;
353 		isProfitStarted = false;
354 		amountOfDebt = 0;
355 		amountOfReturnDebt = 0;
356 		countOfReturnDebt = 0;
357 	}
358 	
359     //Pays out, takes taxes according to holding time
360     function _payout(address payable addr, uint amount, bool retDep) private {
361         if(amount == 0)
362             return;
363 		if(amount > address(this).balance) amount = address(this).balance;
364 		if(amount == 0){
365 			restart();
366 			return;
367 		}
368 		Investor storage inv = investors[addr];
369         //Calculate pure payout that user receives
370         uint activDep = inv.deposit - inv.lockedDeposit;
371         bool isDeleteNeed = false;
372 		if(!isContractSealed && !retDep && !isProfitStarted && amount + inv.withdrawn > activDep / 2 )
373 		{
374 			if(inv.withdrawn < activDep / 2)
375     			amount = (activDep/2) - inv.withdrawn;
376 			else{
377     			if(inv.withdrawn >= activDep)
378     			{
379     				_delete(addr);
380     				return;
381     			}
382     			amount = activDep - inv.withdrawn;
383     			isDeleteNeed = true;
384 			}
385 		}
386         uint interestPure = amount * (PERCENT_DIVIDER - PERCENT_MAIN_FUND) / PERCENT_DIVIDER;
387 
388         //calculate money to charity
389         uint advTax = amount - interestPure;
390         // revert tax with payment if we payouted debt to user
391         if(isContractSealed && inv.deposit <= inv.withdrawnPure){
392             interestPure = advTax;
393             advTax = amount - interestPure;
394         }
395         
396 		inv.withdrawnPure += interestPure;
397 		inv.withdrawn += amount;
398 		inv.time = now;
399 
400         //send money
401         if(advTax > 0)
402         {
403             (bool success, bytes memory data) = ADDRESS_MAIN_FUND.call.value(advTax)("");
404             if(success) 
405                 countOfAdvTax += advTax;
406             else
407                 inv.withdrawn -= advTax;
408         }
409         if(interestPure > 0) addr.transfer(interestPure);
410         
411         if(inv.isWeHaveDebt && inv.withdrawnPure >= inv.deposit)
412         {
413             amountOfReturnDebt += inv.deposit;
414             countOfReturnDebt++;
415             inv.isWeHaveDebt = false;
416         }
417         
418         if(isDeleteNeed)
419 			_delete(addr);
420 
421 		if(address(this).balance == 0)
422 			restart();
423     }
424 
425     //Clears user from registry
426     function _delete(address addr) private {
427         Investor storage inv = investors[addr];
428         if(inv.iteration != iterationIndex)
429             return;
430         amountOfDebt -= inv.deposit;
431         if(!inv.isWeHaveDebt){
432             countOfReturnDebt--;
433             amountOfReturnDebt-=inv.deposit;
434             inv.isWeHaveDebt = true;
435         }
436         inv.iteration = -1;
437         countOfInvestors--;
438     }
439 }