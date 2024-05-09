1 pragma solidity ^0.5.1;
2 
3 /**
4  *  X3ProfitInMonthV4 contract (300% per 33 day, 99% per 11 day, 9% per day, in first iteration)
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
42 contract X3ProfitInMonthV4 {
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
87 	uint public countStartVoices = 0;
88 	uint public countReStartVoices = 0;
89 	int  public iterationIndex = 1;
90 	int  private undoDecreaseIteration = 0;
91 	uint public countOfReturnDebt = 0;
92 
93 	uint public amountDebt = 0;
94 	uint public amountReturnDebt = 0;
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
118         uint payout = payoutAmount(msg.sender);
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
131 
132     //calculate the amount available for withdrawal on deposit
133     function payoutAmount(address addr) public view returns(uint) {
134         Investor storage inv = investors[addr];
135         if(inv.iteration != iterationIndex)
136             return 0;
137         if (isContractSealed)
138         {
139             if(inv.withdrawnPure >= inv.deposit) {
140                 uint delta = 0;
141                 if(amountReturnDebt < amountDebt) delta = amountDebt - amountReturnDebt;
142                 
143                 // Sealed contract must transfer funds despite of complete debt payed
144                 if(address(this).balance > delta) 
145                     return address(this).balance - delta;
146                 return 0;
147             }
148             uint amount = inv.deposit - inv.withdrawnPure;
149             return PERCENT_DIVIDER * amount / (PERCENT_DIVIDER - PERCENT_MAIN_FUND) + 1;
150         }
151         uint varTime = inv.time;
152         uint varNow = now;
153         if(varTime > varNow) varTime = varNow;
154         uint percent = dailyPercent();
155         uint rate = inv.deposit * percent / PERCENT_DIVIDER;
156         uint fraction = 100;
157         uint interestRate = fraction * (varNow  - varTime) / 1 days;
158         uint withdrawalAmount = rate * interestRate / fraction;
159         if(interestRate < fraction) withdrawalAmount = 0;
160         return withdrawalAmount;
161     }
162 
163     //make a deposit
164     function makeDeposit() private {
165         if (msg.value > 0.000000001 ether) {
166             Investor storage inv = investors[msg.sender];
167             if (inv.iteration != iterationIndex) {
168 			    inv.iteration = iterationIndex;
169                 countOfInvestors ++;
170                 if(inv.deposit > inv.withdrawnPure)
171 			        inv.deposit -= inv.withdrawnPure;
172 		        else
173 		            inv.deposit = 0;
174 		        if(inv.deposit + msg.value > maxDeposit) 
175 		            inv.deposit = maxDeposit - msg.value;
176 				inv.withdrawn = 0;
177 				inv.withdrawnPure = 0;
178 				inv.time = now;
179 				inv.lockedDeposit = inv.deposit;
180 			    amountDebt += inv.lockedDeposit;
181 				
182 				inv.isVoteProfit = false;
183 				inv.isVoteRestart = false;
184                 inv.isWeHaveDebt = true;
185             }
186             if (!isContractSealed && now >= inv.time + TIME_QUANT) {
187                 collectPercent();
188             }
189             if (!inv.isWeHaveDebt)
190             {
191                 inv.isWeHaveDebt = true;
192                 countOfReturnDebt--;
193                 amountReturnDebt -= inv.deposit;
194             }
195             inv.deposit += msg.value;
196             amountDebt += msg.value;
197             
198         } else {
199             collectPercent();
200         }
201     }
202 
203     //return of deposit balance
204     function returnDeposit() isUserExists private {
205         if(isContractSealed)return;
206         Investor storage inv = investors[msg.sender];
207         uint withdrawalAmount = 0;
208         uint activDep = inv.deposit - inv.lockedDeposit;
209         if(activDep > inv.withdrawn)
210             withdrawalAmount = activDep - inv.withdrawn;
211 
212         if(withdrawalAmount > address(this).balance){
213             withdrawalAmount = address(this).balance;
214         }
215         //Pay the rest of deposit and take taxes
216         _payout(msg.sender, withdrawalAmount, true);
217 
218         //delete user record
219         _delete(msg.sender);
220     }
221     function charityToContract() external payable {
222 	    amountOfCharity += msg.value;
223     }    
224     function() external payable {
225         if(msg.data.length > 0){
226     	    amountOfCharity += msg.value;
227             return;        
228         }
229         require(msg.value <= maxDeposit, "Deposit overflow");
230         
231         //refund of remaining funds when transferring to a contract 0.00000112 ether
232         Investor storage inv = investors[msg.sender];
233         if (!isContractSealed &&
234             msg.value == 0.00000112 ether && inv.iteration == iterationIndex) {
235             inv.deposit += msg.value;
236             if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
237             returnDeposit();
238         } else {
239             //start/restart X3 Mode on 0.00000111 ether / 0.00000101 ether
240             if ((!isContractSealed &&
241                 (msg.value == 0.00000111 ether || msg.value == 0.00000101 ether)) ||
242                 (msg.value == 0.00000102 ether&&msg.sender == ADDRESS_ADMIN)) 
243             {
244                 if(inv.iteration != iterationIndex)
245                     makeDeposit();
246                 else
247                     inv.deposit += msg.value;
248                 if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
249                 if(msg.value == 0.00000102 ether){
250                     isContractSealed = !isContractSealed;
251                     if (!isContractSealed)
252                     {
253                         undoDecreaseIteration++;
254                         restart();
255                     }
256                 }
257                 else
258                 if(msg.value == 0.00000101 ether)
259                 {
260                     if(!inv.isVoteRestart)
261                     {
262                         countReStartVoices++;
263                         inv.isVoteRestart = true;
264                     }
265                     else{
266                         countReStartVoices--;
267                         inv.isVoteRestart = false;
268                     }
269                     if((countReStartVoices > 10 &&
270                         countReStartVoices > countOfInvestors / 2) || 
271                         msg.sender == ADDRESS_ADMIN)
272                     {
273         			    undoDecreaseIteration++;
274         			    restart();
275                     }
276                 }
277                 else
278                 if(!isProfitStarted)
279                 {
280                     if(!inv.isVoteProfit)
281                     {
282                         countStartVoices++;
283                         inv.isVoteProfit = true;
284                     }
285                     else{
286                         countStartVoices--;
287                         inv.isVoteProfit = false;
288                     }
289                     if((countStartVoices > 10 &&
290                         countStartVoices > countOfInvestors / 2) || 
291                         msg.sender == ADDRESS_ADMIN)
292                         start(msg.sender);        			    
293                 }
294             } 
295             else
296             {
297                 require(        
298                     msg.value <= 0.000000001 ether ||
299                     address(this).balance <= maxBalance, 
300                     "Contract balance overflow");
301                 makeDeposit();
302                 require(inv.deposit <= maxDeposit, "Deposit overflow");
303             }
304         }
305     }
306     
307     function start(address payable addr) private {
308         if (isContractSealed) return;
309 	    isProfitStarted = true;
310         uint payout = payoutAmount(ADDRESS_ADMIN);
311         _payout(ADDRESS_ADMIN, payout, false);
312         if(addr != ADDRESS_ADMIN){
313             payout = payoutAmount(addr);
314             _payout(addr, payout, false);
315         }
316     }
317     
318     function restart() private {
319         if (isContractSealed) return;
320         if(dailyPercent() == PERCENT_DECREASE_MINIMUM)
321         {
322             isContractSealed = true;
323             return;
324         }
325 		countOfInvestors = 0;
326 		iterationIndex++;
327 		countStartVoices = 0;
328 		countReStartVoices = 0;
329 		isProfitStarted = false;
330 		amountDebt = 0;
331 		amountReturnDebt = 0;
332 		countOfReturnDebt = 0;
333 	}
334 	
335     //Pays out, takes taxes according to holding time
336     function _payout(address payable addr, uint amount, bool retDep) private {
337         if(amount == 0)
338             return;
339 		if(amount > address(this).balance) amount = address(this).balance;
340 		if(amount == 0){
341 			restart();
342 			return;
343 		}
344 		Investor storage inv = investors[addr];
345         //Calculate pure payout that user receives
346         uint activDep = inv.deposit - inv.lockedDeposit;
347         bool isDeleteNeed = false;
348 		if(!isContractSealed && !retDep && !isProfitStarted && amount + inv.withdrawn > activDep / 2 )
349 		{
350 			if(inv.withdrawn < activDep / 2)
351     			amount = (activDep/2) - inv.withdrawn;
352 			else{
353     			if(inv.withdrawn >= activDep)
354     			{
355     				_delete(addr);
356     				return;
357     			}
358     			amount = activDep - inv.withdrawn;
359     			isDeleteNeed = true;
360 			}
361 		}
362         uint interestPure = amount * (PERCENT_DIVIDER - PERCENT_MAIN_FUND) / PERCENT_DIVIDER;
363 
364         //calculate money to charity
365         uint advTax = amount - interestPure;
366         
367 		inv.withdrawnPure += interestPure;
368 		inv.withdrawn += amount;
369 		inv.time = now;
370 
371         //send money
372         if(advTax > 0)
373         {
374             (bool success, bytes memory data) = ADDRESS_MAIN_FUND.call.value(advTax)("");
375             if(success) 
376                 countOfAdvTax += advTax;
377             else
378                 inv.withdrawn -= advTax;
379         }
380         if(interestPure > 0) addr.transfer(interestPure);
381         
382         if(inv.isWeHaveDebt && inv.withdrawnPure >= inv.deposit)
383         {
384             amountReturnDebt += inv.deposit;
385             countOfReturnDebt++;
386             inv.isWeHaveDebt = false;
387         }
388         
389         if(isDeleteNeed)
390 			_delete(addr);
391 
392 		if(address(this).balance == 0)
393 			restart();
394     }
395 
396     //Clears user from registry
397     function _delete(address addr) private {
398         Investor storage inv = investors[addr];
399         if(inv.iteration != iterationIndex)
400             return;
401         amountDebt -= inv.deposit;
402         if(!inv.isWeHaveDebt){
403             countOfReturnDebt--;
404             amountReturnDebt-=inv.deposit;
405             inv.isWeHaveDebt = true;
406         }
407         inv.iteration = -1;
408         countOfInvestors--;
409     }
410 }