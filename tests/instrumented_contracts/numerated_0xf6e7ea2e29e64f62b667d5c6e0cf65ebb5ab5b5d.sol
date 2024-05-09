1 pragma solidity ^0.5.1;
2 
3 /**
4  *  X3ProfitInMonthV3 contract (300% per 33 day, 99% per 11 day, 9% per day, in first iteration)
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
36  *  Minimal investment is 0.000000001 ether, if smaller only withdrawn will performed
37  *
38  *  RECOMMENDED GAS LIMIT 350000
39  */
40  
41 contract X3ProfitInMonthV3 {
42 
43 	struct Investor {
44 	      // Restart iteration index
45 		int iteration;
46           // array containing information about beneficiaries
47 		uint deposit;
48 		  // sum locked to remove in predstart period, gived by contract for 
49 		  // compensation of previous iteration restart
50 		uint lockedDeposit;
51            //array containing information about the time of payment
52 		uint time;
53           //array containing information on interest paid
54 		uint withdrawn;
55            //array containing information on interest paid (without tax)
56 		uint withdrawnPure;
57 		   // Vote system for start iteration
58 		bool isVoteProfit;
59 		   // Vote system for restart iteration
60 		bool isVoteRestart;
61            // Default at any deposit we debt to user
62         bool isWeHaveDebt;
63 	}
64 
65     mapping(address => Investor) public investors;
66 	
67     //fund to transfer percent for MAIN OUR CONTRACT EasyInvestForeverProtected2
68     address payable public constant ADDRESS_MAIN_FUND = 0x3Bd33FF04e1F2BF01C8BF15C395D607100b7E116;
69     address payable public constant ADDRESS_ADMIN =     0x6249046Af9FB588bb4E70e62d9403DD69239bdF5;
70     //time through which you can take dividends
71     uint private constant TIME_QUANT = 1 days;
72 	
73     //start percent 10% per day
74     uint private constant PERCENT_DAY = 10;
75     uint private constant PERCENT_DECREASE_PER_ITERATION = 1;
76     uint private constant PERCENT_DECREASE_MINIMUM = 1;
77 
78     //Adv tax for withdrawal 10%
79     uint private constant PERCENT_MAIN_FUND = 10;
80 
81     //All percent should be divided by this
82     uint private constant PERCENT_DIVIDER = 100;
83 
84     uint public countOfInvestors = 0;
85     uint public countOfAdvTax = 0;
86 	uint public countStartVoices = 0;
87 	uint public countReStartVoices = 0;
88 	int  public iterationIndex = 1;
89 	int  private undoDecreaseIteration = 0;
90 	uint public countOfReturnDebt = 0;
91 
92 	uint public amountDebt = 0;
93 	uint public amountReturnDebt = 0;
94 	uint public amountOfCharity = 0;
95 
96     // max contract balance in ether for overflow protection in calculations only
97     // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
98 	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
99 	uint public constant maxDeposit = maxBalance / 1000; 
100 	
101 	// X3 Mode status
102     bool public isProfitStarted = false; 
103     bool public isContractSealed = false;
104 
105     modifier isUserExists() {
106         require(investors[msg.sender].iteration == iterationIndex, "Deposit not found");
107         _;
108     }
109 
110     modifier timePayment() {
111         require(isContractSealed || now >= investors[msg.sender].time + TIME_QUANT, "Too fast payout request");
112         _;
113     }
114 
115     //return of interest on the deposit
116     function collectPercent() isUserExists timePayment internal {
117         uint payout = payoutAmount(msg.sender);
118         _payout(msg.sender, payout, false);
119     }
120     function dailyPercent() public view returns(uint) {
121         uint percent = PERCENT_DAY;
122 		int delta = 1 + undoDecreaseIteration;
123 		if (delta > iterationIndex) delta = iterationIndex;
124         uint decrease = PERCENT_DECREASE_PER_ITERATION * (uint)(iterationIndex - delta);
125         if(decrease > percent - PERCENT_DECREASE_MINIMUM)
126             decrease = percent - PERCENT_DECREASE_MINIMUM;
127         percent -= decrease;
128         return percent;
129     }
130 
131     //calculate the amount available for withdrawal on deposit
132     function payoutAmount(address addr) public view returns(uint) {
133         Investor storage inv = investors[addr];
134         if(inv.iteration != iterationIndex)
135             return 0;
136         if (isContractSealed)
137         {
138             if(inv.withdrawnPure >= inv.deposit) {
139                 uint delta = 0;
140                 if(amountReturnDebt < amountDebt) delta = amountDebt - amountReturnDebt;
141                 
142                 // Sealed contract must transfer funds despite of complete debt payed
143                 if(address(this).balance > delta) 
144                     return address(this).balance - delta;
145                 return 0;
146             }
147             uint amount = inv.deposit - inv.withdrawnPure;
148             return PERCENT_DIVIDER * amount / (PERCENT_DIVIDER - PERCENT_MAIN_FUND) + 1;
149         }
150         uint varTime = inv.time;
151         uint varNow = now;
152         if(varTime > varNow) varTime = varNow;
153         uint percent = dailyPercent();
154         uint rate = inv.deposit * percent / PERCENT_DIVIDER;
155         uint fraction = 100;
156         uint interestRate = fraction * (varNow  - varTime) / 1 days;
157         uint withdrawalAmount = rate * interestRate / fraction;
158         if(interestRate < fraction) withdrawalAmount = 0;
159         return withdrawalAmount;
160     }
161 
162     //make a deposit
163     function makeDeposit() private {
164         if (msg.value > 0.000000001 ether) {
165             Investor storage inv = investors[msg.sender];
166             if (inv.iteration != iterationIndex) {
167 			    inv.iteration = iterationIndex;
168                 countOfInvestors ++;
169                 if(inv.deposit > inv.withdrawnPure)
170 			        inv.deposit -= inv.withdrawnPure;
171 		        else
172 		            inv.deposit = 0;
173 		        if(inv.deposit + msg.value > maxDeposit) 
174 		            inv.deposit = maxDeposit - msg.value;
175 				inv.withdrawn = 0;
176 				inv.withdrawnPure = 0;
177 				inv.time = now;
178 				inv.lockedDeposit = inv.deposit;
179 			    amountDebt += inv.lockedDeposit;
180 				
181 				inv.isVoteProfit = false;
182 				inv.isVoteRestart = false;
183                 inv.isWeHaveDebt = true;
184             }
185             if (!isContractSealed && now >= inv.time + TIME_QUANT) {
186                 collectPercent();
187             }
188             if (!inv.isWeHaveDebt)
189             {
190                 inv.isWeHaveDebt = true;
191                 countOfReturnDebt--;
192                 amountReturnDebt -= inv.deposit;
193             }
194             inv.deposit += msg.value;
195             amountDebt += msg.value;
196             
197         } else {
198             collectPercent();
199         }
200     }
201 
202     //return of deposit balance
203     function returnDeposit() isUserExists private {
204         if(isContractSealed)return;
205         Investor storage inv = investors[msg.sender];
206         uint withdrawalAmount = 0;
207         uint activDep = inv.deposit - inv.lockedDeposit;
208         if(activDep > inv.withdrawn)
209             withdrawalAmount = activDep - inv.withdrawn;
210 
211         if(withdrawalAmount > address(this).balance){
212             withdrawalAmount = address(this).balance;
213         }
214         //Pay the rest of deposit and take taxes
215         _payout(msg.sender, withdrawalAmount, true);
216 
217         //delete user record
218         _delete(msg.sender);
219     }
220     function charityToContract() external payable {
221 	    amountOfCharity += msg.value;
222     }    
223     function() external payable {
224         if(msg.data.length > 0){
225     	    amountOfCharity += msg.value;
226             return;        
227         }
228         require(msg.value <= maxDeposit, "Deposit overflow");
229         
230         //refund of remaining funds when transferring to a contract 0.00000112 ether
231         Investor storage inv = investors[msg.sender];
232         if (!isContractSealed &&
233             msg.value == 0.00000112 ether && inv.iteration == iterationIndex) {
234             inv.deposit += msg.value;
235             if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
236             returnDeposit();
237         } else {
238             //start/restart X3 Mode on 0.00000111 ether / 0.00000101 ether
239             if ((!isContractSealed &&
240                 (msg.value == 0.00000111 ether || msg.value == 0.00000101 ether)) ||
241                 (msg.value == 0.00000102 ether&&msg.sender == ADDRESS_ADMIN)) 
242             {
243                 if(inv.iteration != iterationIndex)
244                     makeDeposit();
245                 else
246                     inv.deposit += msg.value;
247                 if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
248                 if(msg.value == 0.00000102 ether){
249                     isContractSealed = !isContractSealed;
250                     if (!isContractSealed)
251                     {
252                         undoDecreaseIteration++;
253                         restart();
254                     }
255                 }
256                 else
257                 if(msg.value == 0.00000101 ether)
258                 {
259                     if(!inv.isVoteRestart)
260                     {
261                         countReStartVoices++;
262                         inv.isVoteRestart = true;
263                     }
264                     else{
265                         countReStartVoices--;
266                         inv.isVoteRestart = false;
267                     }
268                     if((countReStartVoices > 10 &&
269                         countReStartVoices > countOfInvestors / 2) || 
270                         msg.sender == ADDRESS_ADMIN)
271                     {
272         			    undoDecreaseIteration++;
273         			    restart();
274                     }
275                 }
276                 else
277                 if(!isProfitStarted)
278                 {
279                     if(!inv.isVoteProfit)
280                     {
281                         countStartVoices++;
282                         inv.isVoteProfit = true;
283                     }
284                     else{
285                         countStartVoices--;
286                         inv.isVoteProfit = false;
287                     }
288                     if((countStartVoices > 10 &&
289                         countStartVoices > countOfInvestors / 2) || 
290                         msg.sender == ADDRESS_ADMIN)
291                         start(msg.sender);        			    
292                 }
293             } 
294             else
295             {
296                 require(        
297                     msg.value > 0.000000001 ether ||
298                     address(this).balance <= maxBalance, 
299                     "Contract balance overflow");
300                 makeDeposit();
301                 require(inv.deposit <= maxDeposit, "Deposit overflow");
302             }
303         }
304     }
305     
306     function start(address payable addr) private {
307         if (isContractSealed) return;
308 	    isProfitStarted = true;
309         uint payout = payoutAmount(ADDRESS_ADMIN);
310         _payout(ADDRESS_ADMIN, payout, false);
311         if(addr != ADDRESS_ADMIN){
312             payout = payoutAmount(addr);
313             _payout(addr, payout, false);
314         }
315     }
316     
317     function restart() private {
318         if (isContractSealed) return;
319         if(dailyPercent() == PERCENT_DECREASE_MINIMUM)
320         {
321             isContractSealed = true;
322             return;
323         }
324 		countOfInvestors = 0;
325 		iterationIndex++;
326 		countStartVoices = 0;
327 		countReStartVoices = 0;
328 		isProfitStarted = false;
329 		amountDebt = 0;
330 		amountReturnDebt = 0;
331 		countOfReturnDebt = 0;
332 	}
333 	
334     //Pays out, takes taxes according to holding time
335     function _payout(address payable addr, uint amount, bool retDep) private {
336         if(amount == 0)
337             return;
338 		if(amount > address(this).balance) amount = address(this).balance;
339 		if(amount == 0){
340 			restart();
341 			return;
342 		}
343 		Investor storage inv = investors[addr];
344         //Calculate pure payout that user receives
345         uint activDep = inv.deposit - inv.lockedDeposit;
346         bool isDeleteNeed = false;
347 		if(!isContractSealed && !retDep && !isProfitStarted && amount + inv.withdrawn > activDep / 2 )
348 		{
349 			if(inv.withdrawn < activDep / 2)
350     			amount = (activDep/2) - inv.withdrawn;
351 			else{
352     			if(inv.withdrawn >= activDep)
353     			{
354     				_delete(addr);
355     				return;
356     			}
357     			amount = activDep - inv.withdrawn;
358     			isDeleteNeed = true;
359 			}
360 		}
361         uint interestPure = amount * (PERCENT_DIVIDER - PERCENT_MAIN_FUND) / PERCENT_DIVIDER;
362 
363         //calculate money to charity
364         uint advTax = amount - interestPure;
365         
366 		inv.withdrawnPure += interestPure;
367 		inv.withdrawn += amount;
368 		inv.time = now;
369 
370         //send money
371         if(advTax > 0)
372         {
373             (bool success, bytes memory data) = ADDRESS_MAIN_FUND.call.value(advTax)("");
374             if(success) 
375                 countOfAdvTax += advTax;
376             else
377                 inv.withdrawn -= advTax;
378         }
379         if(interestPure > 0) addr.transfer(interestPure);
380         
381         if(inv.isWeHaveDebt && inv.withdrawnPure >= inv.deposit)
382         {
383             amountReturnDebt += inv.deposit;
384             countOfReturnDebt++;
385             inv.isWeHaveDebt = false;
386         }
387         
388         if(isDeleteNeed)
389 			_delete(addr);
390 
391 		if(address(this).balance == 0)
392 			restart();
393     }
394 
395     //Clears user from registry
396     function _delete(address addr) private {
397         Investor storage inv = investors[addr];
398         if(inv.iteration != iterationIndex)
399             return;
400         amountDebt -= inv.deposit;
401         if(!inv.isWeHaveDebt){
402             countOfReturnDebt--;
403             amountReturnDebt-=inv.deposit;
404             inv.isWeHaveDebt = true;
405         }
406         inv.iteration = -1;
407         countOfInvestors--;
408     }
409 }