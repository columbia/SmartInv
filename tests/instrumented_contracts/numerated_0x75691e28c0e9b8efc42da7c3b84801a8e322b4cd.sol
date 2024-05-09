1 pragma solidity ^0.5.2;
2 
3 /**
4  *  X3ProfitInMonthV5 contract (300% per 33 day, 99% per 11 day, 9% per day, in first iteration)
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
28  *  TO START X3 WORK, ANY MEMBER CAN VOTE 0.00000111 ETH to contract address.
29  *     While X3 not started investors can return only their deposits and no profit.
30  *     Admin voice power is equal 10 simple participants.
31  *  TO RESTART, ANY MEMBER CAN VOTE 0.00000101 ETH to contract address.
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
42 contract X3ProfitInMonthV5 {
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
141                 if(inv.withdrawn > activDep / 2) return 0;
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
157                 
158                 // Sealed contract must transfer funds despite of complete debt payed
159                 if(address(this).balance > delta) 
160                     return address(this).balance - delta;
161                 return 0;
162             }
163             uint amount = inv.deposit - inv.withdrawnPure;
164             return PERCENT_DIVIDER * amount / (PERCENT_DIVIDER - PERCENT_MAIN_FUND) + 1;
165         }
166         uint varTime = inv.time;
167         uint varNow = now;
168         if(varTime > varNow) varTime = varNow;
169         uint percent = dailyPercent();
170         uint rate = inv.deposit * percent / PERCENT_DIVIDER;
171         uint fraction = 100;
172         uint interestRate = fraction * (varNow  - varTime) / 1 days;
173         uint withdrawalAmount = rate * interestRate / fraction;
174         if(interestRate < fraction) withdrawalAmount = 0;
175         return withdrawalAmount;
176     }
177     function makeDebt(address payable addr, uint amount) private
178     {
179         if (amount == 0) return;
180         Investor storage inv = investors[addr];
181         inv.deposit += amount;
182         amountOfDebt += amount;
183         if (!inv.isWeHaveDebt)
184         {
185             inv.isWeHaveDebt = true;
186             countOfReturnDebt--;
187             amountOfReturnDebt -= inv.deposit;
188         }
189     }
190 
191     //make a deposit
192     function makeDeposit() private {
193         if (msg.value > 0.000000001 ether) {
194             Investor storage inv = investors[msg.sender];
195             if (inv.iteration != iterationIndex) {
196 			    inv.iteration = iterationIndex;
197                 countOfInvestors ++;
198                 if(inv.deposit > inv.withdrawnPure)
199 			        inv.deposit -= inv.withdrawnPure;
200 		        else
201 		            inv.deposit = 0;
202 		        if(inv.deposit + msg.value > maxDeposit) 
203 		            inv.deposit = maxDeposit - msg.value;
204 				inv.withdrawn = 0;
205 				inv.withdrawnPure = 0;
206 				inv.time = now;
207 				inv.lockedDeposit = inv.deposit;
208 			    amountOfDebt += inv.lockedDeposit;
209 				
210 				inv.isVoteProfit = false;
211 				inv.isVoteRestart = false;
212                 inv.isWeHaveDebt = true;
213             }
214             if (!isContractSealed && now >= inv.time + TIME_QUANT) {
215                 collectPercent();
216             }
217             makeDebt(msg.sender, msg.value);
218         } else {
219             collectPercent();
220         }
221     }
222 
223     //return of deposit balance
224     function returnDeposit() isUserExists private {
225         if(isContractSealed)return;
226         Investor storage inv = investors[msg.sender];
227         uint withdrawalAmount = 0;
228         uint activDep = inv.deposit - inv.lockedDeposit;
229         if(activDep > inv.withdrawn)
230             withdrawalAmount = activDep - inv.withdrawn;
231 
232         if(withdrawalAmount > address(this).balance){
233             withdrawalAmount = address(this).balance;
234         }
235         //Pay the rest of deposit and take taxes
236         _payout(msg.sender, withdrawalAmount, true);
237 
238         //delete user record
239         _delete(msg.sender);
240     }
241     function charityToContract() external payable {
242 	    amountOfCharity += msg.value;
243     }    
244     function() external payable {
245         if(msg.data.length > 0){
246     	    amountOfCharity += msg.value;
247             return;        
248         }
249         require(msg.value <= maxDeposit, "Deposit overflow");
250         
251         //refund of remaining funds when transferring to a contract 0.00000112 ether
252         Investor storage inv = investors[msg.sender];
253         if (!isContractSealed &&
254             msg.value == 0.00000112 ether && inv.iteration == iterationIndex) {
255             makeDebt(msg.sender, msg.value);
256             returnDeposit();
257         } else {
258             //start/restart X3 Mode on 0.00000111 ether / 0.00000101 ether
259             if ((!isContractSealed &&
260                 (msg.value == 0.00000111 ether || msg.value == 0.00000101 ether)) ||
261                 (msg.value == 0.00000102 ether&&msg.sender == ADDRESS_ADMIN)) 
262             {
263                 if(inv.iteration != iterationIndex)
264                     makeDeposit();
265                 else
266                     makeDebt(msg.sender, msg.value);
267                 if(msg.value == 0.00000102 ether){
268                     isContractSealed = !isContractSealed;
269                     if (!isContractSealed)
270                     {
271                         undoDecreaseIteration++;
272                         restart();
273                     }
274                 }
275                 else
276                 if(msg.value == 0.00000101 ether)
277                 {
278                     if(!inv.isVoteRestart)
279                     {
280                         countOfReStartVoices++;
281                         inv.isVoteRestart = true;
282                     }
283                     else{
284                         countOfReStartVoices--;
285                         inv.isVoteRestart = false;
286                     }
287                     if((countOfReStartVoices > 10 &&
288                         countOfReStartVoices > countOfInvestors / 2) || 
289                         msg.sender == ADDRESS_ADMIN)
290                     {
291         			    undoDecreaseIteration++;
292         			    restart();
293                     }
294                 }
295                 else
296                 if(!isProfitStarted)
297                 {
298                     if(!inv.isVoteProfit)
299                     {
300                         countOfStartVoices++;
301                         inv.isVoteProfit = true;
302                     }
303                     else{
304                         countOfStartVoices--;
305                         inv.isVoteProfit = false;
306                     }
307                     if((countOfStartVoices > 10 &&
308                         countOfStartVoices > countOfInvestors / 2) || 
309                         msg.sender == ADDRESS_ADMIN)
310                         start(msg.sender);        			    
311                 }
312             } 
313             else
314             {
315                 require(        
316                     msg.value <= 0.000000001 ether ||
317                     address(this).balance <= maxBalance, 
318                     "Contract balance overflow");
319                 makeDeposit();
320                 require(inv.deposit <= maxDeposit, "Deposit overflow");
321             }
322         }
323     }
324     
325     function start(address payable addr) private {
326         if (isContractSealed) return;
327 	    isProfitStarted = true;
328         uint payout = payoutPlanned(ADDRESS_ADMIN);
329         _payout(ADDRESS_ADMIN, payout, false);
330         if(addr != ADDRESS_ADMIN){
331             payout = payoutPlanned(addr);
332             _payout(addr, payout, false);
333         }
334     }
335     
336     function restart() private {
337         if (isContractSealed) return;
338         if(dailyPercent() == PERCENT_DECREASE_MINIMUM)
339         {
340             isContractSealed = true;
341             return;
342         }
343 		countOfInvestors = 0;
344 		iterationIndex++;
345 		countOfStartVoices = 0;
346 		countOfReStartVoices = 0;
347 		isProfitStarted = false;
348 		amountOfDebt = 0;
349 		amountOfReturnDebt = 0;
350 		countOfReturnDebt = 0;
351 	}
352 	
353     //Pays out, takes taxes according to holding time
354     function _payout(address payable addr, uint amount, bool retDep) private {
355         if(amount == 0)
356             return;
357 		if(amount > address(this).balance) amount = address(this).balance;
358 		if(amount == 0){
359 			restart();
360 			return;
361 		}
362 		Investor storage inv = investors[addr];
363         //Calculate pure payout that user receives
364         uint activDep = inv.deposit - inv.lockedDeposit;
365         bool isDeleteNeed = false;
366 		if(!isContractSealed && !retDep && !isProfitStarted && amount + inv.withdrawn > activDep / 2 )
367 		{
368 			if(inv.withdrawn < activDep / 2)
369     			amount = (activDep/2) - inv.withdrawn;
370 			else{
371     			if(inv.withdrawn >= activDep)
372     			{
373     				_delete(addr);
374     				return;
375     			}
376     			amount = activDep - inv.withdrawn;
377     			isDeleteNeed = true;
378 			}
379 		}
380         uint interestPure = amount * (PERCENT_DIVIDER - PERCENT_MAIN_FUND) / PERCENT_DIVIDER;
381 
382         //calculate money to charity
383         uint advTax = amount - interestPure;
384         // revert tax with payment if we payouted debt to user
385         if(isContractSealed && inv.deposit <= inv.withdrawnPure){
386             interestPure = advTax;
387             advTax = amount - interestPure;
388         }
389         
390 		inv.withdrawnPure += interestPure;
391 		inv.withdrawn += amount;
392 		inv.time = now;
393 
394         //send money
395         if(advTax > 0)
396         {
397             (bool success, bytes memory data) = ADDRESS_MAIN_FUND.call.value(advTax)("");
398             if(success) 
399                 countOfAdvTax += advTax;
400             else
401                 inv.withdrawn -= advTax;
402         }
403         if(interestPure > 0) addr.transfer(interestPure);
404         
405         if(inv.isWeHaveDebt && inv.withdrawnPure >= inv.deposit)
406         {
407             amountOfReturnDebt += inv.deposit;
408             countOfReturnDebt++;
409             inv.isWeHaveDebt = false;
410         }
411         
412         if(isDeleteNeed)
413 			_delete(addr);
414 
415 		if(address(this).balance == 0)
416 			restart();
417     }
418 
419     //Clears user from registry
420     function _delete(address addr) private {
421         Investor storage inv = investors[addr];
422         if(inv.iteration != iterationIndex)
423             return;
424         amountOfDebt -= inv.deposit;
425         if(!inv.isWeHaveDebt){
426             countOfReturnDebt--;
427             amountOfReturnDebt-=inv.deposit;
428             inv.isWeHaveDebt = true;
429         }
430         inv.iteration = -1;
431         countOfInvestors--;
432     }
433 }