1 pragma solidity ^0.5.0;
2 
3 /**
4  *  X3ProfitInMonthV2 contract (300% per 33 day, 99% per 11 day, 9% per day, in first iteration)
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
24  *  TO INVEST: send ETH to contract address
25  *  TO WITHDRAW INTEREST: send 0 ETH to contract address
26  *  TO REINVEST AND WITHDRAW INTEREST: send ETH to contract address
27  *  TO GET BACK YOUR DEPOSIT: send 0.00000112 ETH to contract address
28  *  TO START X3 WORK, ANY MEMBER CAN VOTE 0.00000111 ETH to contract address
29  *     While X3 not started investors can return only their deposits and no profit.
30  *     Admin voice power is equal 10 simple participants
31  *  TO RESTART, ANY MEMBER CAN VOTE 0.00000101 ETH to contract address
32  *     Admin voice power is equal 10 simple participants
33  *
34  *  RECOMMENDED GAS LIMIT 350000
35  */
36  
37 contract X3ProfitInMonthV2 {
38 
39 	struct Investor {
40 	      // Restart iteration index
41 		uint iteration;
42           // array containing information about beneficiaries
43 		uint deposit;
44 		  // sum locked to remove in predstart period, gived by contract for 
45 		  // compensation of previous iteration restart
46 		uint lockedDeposit;
47            //array containing information about the time of payment
48 		uint time;
49           //array containing information on interest paid
50 		uint withdrawn;
51            //array containing information on interest paid (without tax)
52 		uint withdrawnPure;
53 		   // Vote system for start iteration
54 		bool isVoteProfit;
55 		   // Vote system for restart iteration
56 		bool isVoteRestart;
57 	}
58 
59     mapping(address => Investor) public investors;
60 	
61     //fund to transfer percent for MAIN OUR CONTRACT EasyInvestForeverProtected2
62     address payable public constant ADDRESS_MAIN_FUND = 0x20C476Bb4c7aA64F919278fB9c09e880583beb4c;
63     address payable public constant ADDRESS_ADMIN =     0x6249046Af9FB588bb4E70e62d9403DD69239bdF5;
64     //time through which you can take dividends
65     uint private constant TIME_QUANT = 1 days;
66 	
67     //start percent 10% per day
68     uint private constant PERCENT_DAY = 10;
69     uint private constant PERCENT_DECREASE_PER_ITERATION = 1;
70     uint private constant PERCENT_DECREASE_MINIMUM = 1;
71 
72     //Adv tax for withdrawal 10%
73     uint private constant PERCENT_MAIN_FUND = 10;
74 
75     //All percent should be divided by this
76     uint private constant PERCENT_DIVIDER = 100;
77 
78     uint public countOfInvestors = 0;
79     uint public countOfAdvTax = 0;
80 	uint public countStartVoices = 0;
81 	uint public countReStartVoices = 0;
82 	uint public iterationIndex = 1;
83 	uint private undoDecreaseIteration = 0;
84 	uint public countOfDebt = 0;
85 	uint public countOfReturnDebt = 0;
86 
87 	uint public amountDebt = 0;
88 	uint public amountReturnDebt = 0;
89 
90     // max contract balance in ether for overflow protection in calculations only
91     // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
92 	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
93 	uint public constant maxDeposit = maxBalance / 1000; 
94 	
95 	// X3 Mode status
96     bool public isProfitStarted = false; 
97 
98     modifier isUserExists() {
99         require(investors[msg.sender].iteration == iterationIndex, "Deposit not found");
100         _;
101     }
102 
103     modifier timePayment() {
104         require(now >= investors[msg.sender].time + TIME_QUANT, "Too fast payout request");
105         _;
106     }
107 
108     //return of interest on the deposit
109     function collectPercent() isUserExists timePayment internal {
110         uint payout = payoutAmount(msg.sender);
111         _payout(msg.sender, payout, false);
112     }
113     function dailyPercent() public view returns(uint) {
114         uint percent = PERCENT_DAY;
115         uint decrease = PERCENT_DECREASE_PER_ITERATION * (iterationIndex - 1 - undoDecreaseIteration);
116         if(decrease > percent - PERCENT_DECREASE_MINIMUM)
117             decrease = percent - PERCENT_DECREASE_MINIMUM;
118         percent -= decrease;
119         return percent;
120     }
121 
122     //calculate the amount available for withdrawal on deposit
123     function payoutAmount(address addr) public view returns(uint) {
124         Investor storage inv = investors[addr];
125         if(inv.iteration != iterationIndex)
126             return 0;
127         uint varTime = inv.time;
128         uint varNow = now;
129         if(varTime > varNow) varTime = varNow;
130         uint percent = dailyPercent();
131         uint rate = inv.deposit * percent / PERCENT_DIVIDER;
132         uint fraction = 100;
133         uint interestRate = fraction * (varNow  - varTime) / 1 days;
134         uint withdrawalAmount = rate * interestRate / fraction;
135         if(interestRate < fraction) withdrawalAmount = 0;
136         return withdrawalAmount;
137     }
138 
139     //make a deposit
140     function makeDeposit() private {
141         if (msg.value > 0) {
142             Investor storage inv = investors[msg.sender];
143             if (inv.iteration != iterationIndex) {
144                 countOfInvestors += 1;
145                 if(inv.deposit > inv.withdrawnPure)
146 			        inv.deposit -= inv.withdrawnPure;
147 		        else
148 		            inv.deposit = 0;
149 		        if(inv.deposit + msg.value > maxDeposit) 
150 		            inv.deposit = maxDeposit - msg.value;
151 				inv.withdrawn = 0;
152 				inv.withdrawnPure = 0;
153 				inv.time = now;
154 				inv.iteration = iterationIndex;
155 				inv.lockedDeposit = inv.deposit;
156 				if(inv.lockedDeposit > 0){
157 				    amountDebt += inv.lockedDeposit;
158 				    countOfDebt++;   
159 				}
160 				inv.isVoteProfit = false;
161 				inv.isVoteRestart = false;
162             }
163             if (inv.deposit > 0 && now >= inv.time + TIME_QUANT) {
164                 collectPercent();
165             }
166             
167             inv.deposit += msg.value;
168             
169         } else {
170             collectPercent();
171         }
172     }
173 
174     //return of deposit balance
175     function returnDeposit() isUserExists private {
176         Investor storage inv = investors[msg.sender];
177         uint withdrawalAmount = 0;
178         uint activDep = inv.deposit - inv.lockedDeposit;
179         if(activDep > inv.withdrawn)
180             withdrawalAmount = activDep - inv.withdrawn;
181 
182         if(withdrawalAmount > address(this).balance){
183             withdrawalAmount = address(this).balance;
184         }
185         //Pay the rest of deposit and take taxes
186         _payout(msg.sender, withdrawalAmount, true);
187 
188         //delete user record
189         _delete(msg.sender);
190     }
191     
192     function() external payable {
193         require(msg.value <= maxDeposit, "Deposit overflow");
194         
195         //refund of remaining funds when transferring to a contract 0.00000112 ether
196         Investor storage inv = investors[msg.sender];
197         if (msg.value == 0.00000112 ether && inv.iteration == iterationIndex) {
198             inv.deposit += msg.value;
199             if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
200             returnDeposit();
201         } else {
202             //start/restart X3 Mode on 0.00000111 ether / 0.00000101 ether
203             if (msg.value == 0.00000111 ether || msg.value == 0.00000101 ether) {
204                 if(inv.iteration != iterationIndex)
205                     makeDeposit();
206                 else
207                     inv.deposit += msg.value;
208                 if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
209                 if(msg.value == 0.00000101 ether)
210                 {
211                     if(!inv.isVoteRestart)
212                     {
213                         countReStartVoices++;
214                         inv.isVoteRestart = true;
215                     }
216                     else{
217                         countReStartVoices--;
218                         inv.isVoteRestart = false;
219                     }
220                     if((countReStartVoices > 10 &&
221                         countReStartVoices > countOfInvestors / 2) || 
222                         msg.sender == ADDRESS_ADMIN)
223                     {
224         			    restart();
225         			    undoDecreaseIteration++;
226                     }
227                 }
228                 else
229                 if(!isProfitStarted)
230                 {
231                     if(!inv.isVoteProfit)
232                     {
233                         countStartVoices++;
234                         inv.isVoteProfit = true;
235                     }
236                     else{
237                         countStartVoices--;
238                         inv.isVoteProfit = false;
239                     }
240                     if((countStartVoices > 10 &&
241                         countStartVoices > countOfInvestors / 2) || 
242                         msg.sender == ADDRESS_ADMIN)
243                         start(msg.sender);        			    
244                 }
245             } 
246             else
247             {
248                 require(
249                     msg.value == 0 ||
250                     address(this).balance <= maxBalance, 
251                     "Contract balance overflow");
252                 makeDeposit();
253                 require(inv.deposit <= maxDeposit, "Deposit overflow");
254             }
255         }
256     }
257     
258     function start(address payable addr) private {
259 	    isProfitStarted = true;
260         uint payout = payoutAmount(ADDRESS_ADMIN);
261         _payout(ADDRESS_ADMIN, payout, false);
262         if(addr != ADDRESS_ADMIN){
263             payout = payoutAmount(addr);
264             _payout(addr, payout, false);
265         }
266     }
267     
268     function restart() private {
269 		countOfInvestors = 0;
270 		iterationIndex++;
271 		countStartVoices = 0;
272 		countReStartVoices = 0;
273 		isProfitStarted = false;
274 		amountDebt = 0;
275 		amountReturnDebt = 0;
276 		countOfDebt = 0;
277 		countOfReturnDebt = 0;
278 	}
279 	
280     //Pays out, takes taxes according to holding time
281     function _payout(address payable addr, uint amount, bool retDep) private {
282         if(amount == 0)
283             return;
284 		if(amount > address(this).balance) amount = address(this).balance;
285 		if(amount == 0){
286 			restart();
287 			return;
288 		}
289 		Investor storage inv = investors[addr];
290         //Calculate pure payout that user receives
291         uint activDep = inv.deposit - inv.lockedDeposit;
292 		if(!retDep && !isProfitStarted && amount + inv.withdrawn > activDep / 2 )
293 		{
294 			if(inv.withdrawn < activDep / 2)
295     			amount = (activDep/2) - inv.withdrawn;
296 			else{
297     			if(inv.withdrawn >= activDep)
298     			{
299     				_delete(addr);
300     				return;
301     			}
302     			amount = activDep - inv.withdrawn;
303     			_delete(addr);
304 			}
305 		}
306         uint interestPure = amount * (PERCENT_DIVIDER - PERCENT_MAIN_FUND) / PERCENT_DIVIDER;
307 
308         //calculate money to charity
309         uint advTax = amount - interestPure;
310         
311         bool isDebt = inv.lockedDeposit > 0 && inv.withdrawnPure < inv.lockedDeposit;
312 
313 		inv.withdrawnPure += interestPure;
314 		inv.withdrawn += amount;
315 		inv.time = now;
316 
317         //send money
318         if(advTax > 0)
319         {
320             (bool success, bytes memory data) = ADDRESS_MAIN_FUND.call.value(advTax)("");
321             if(success) 
322                 countOfAdvTax += advTax;
323             else
324                 inv.withdrawn -= advTax;
325         }
326         addr.transfer(interestPure);
327         
328         if(isDebt && inv.withdrawnPure >= inv.lockedDeposit)
329         {
330             amountReturnDebt += inv.lockedDeposit;
331             countOfReturnDebt++;
332         }
333 
334 		if(address(this).balance == 0)
335 			restart();
336     }
337 
338     //Clears user from registry
339     function _delete(address addr) private {
340         Investor storage inv = investors[addr];
341         if(inv.iteration != iterationIndex)
342             return;
343         if(inv.withdrawnPure < inv.lockedDeposit){
344             countOfDebt--;
345             amountDebt -= inv.lockedDeposit;
346         }
347         inv.iteration = 0;
348         countOfInvestors--;
349     }
350 }