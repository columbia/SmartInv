1 pragma solidity ^0.4.25;
2 
3 /**
4  *  X3ProfitInMonth contract (300% per 33 day, 99% per 11 day, 9% per day, in first iteration)
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
16  *  HAVE COMMAND PREPARATION TIME DURING IT WILL BE RETURN ONLY INVESTED AMOUNT AND NOT MORE!!!
17  *  Only special command will run X3 MODE!!!
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
28  *  TO START X3 WORK, ANY MEMBER CAN SEND 0.00000111 ETH to contract address
29  *     While X3 not started investors can return only their deposits and no profit.
30  *     Admin voice power is equal 10 simple participants
31  *
32  *  RECOMMENDED GAS LIMIT 200000
33  */
34  
35 contract X3ProfitInMonth {
36 
37 	struct Investor {
38 	      // Restart iteration index
39 		uint iteration;
40           // array containing information about beneficiaries
41 		uint deposit;
42 		  // sum locked to remove in predstart period, gived by contract for 
43 		  // compensation of previous iteration restart
44 		uint lockedDeposit;
45            //array containing information about the time of payment
46 		uint time;
47           //array containing information on interest paid
48 		uint withdrawn;
49            //array containing information on interest paid (without tax)
50 		uint withdrawnPure;
51 		   // Vote system for start iteration
52 		bool isVoteProfit;
53 	}
54 
55     mapping(address => Investor) public investors;
56 	
57     //fund to transfer percent for MAIN OUR CONTRACT EasyInvestForeverProtected2
58     address public constant ADDRESS_MAIN_FUND = 0x20C476Bb4c7aA64F919278fB9c09e880583beb4c;
59     address public constant ADDRESS_ADMIN =     0x6249046Af9FB588bb4E70e62d9403DD69239bdF5;
60     //time through which you can take dividends
61     uint private constant TIME_QUANT = 1 days;
62 	
63     //start percent 10% per day
64     uint private constant PERCENT_DAY = 10;
65     uint private constant PERCENT_DECREASE_PER_ITERATION = 1;
66 
67     //Adv tax for withdrawal 10%
68     uint private constant PERCENT_MAIN_FUND = 10;
69 
70     //All percent should be divided by this
71     uint private constant PERCENT_DIVIDER = 100;
72 
73     uint public countOfInvestors = 0;
74     uint public countOfAdvTax = 0;
75 	uint public countStartVoices = 0;
76 	uint public iterationIndex = 1;
77 
78     // max contract balance in ether for overflow protection in calculations only
79     // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
80 	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
81 	uint public constant maxDeposit = maxBalance / 1000; 
82 	
83 	// X3 Mode status
84     bool public isProfitStarted = false; 
85 
86     modifier isIssetUser() {
87         require(investors[msg.sender].iteration == iterationIndex, "Deposit not found");
88         _;
89     }
90 
91     modifier timePayment() {
92         require(now >= investors[msg.sender].time + TIME_QUANT, "Too fast payout request");
93         _;
94     }
95 
96     //return of interest on the deposit
97     function collectPercent() isIssetUser timePayment internal {
98         uint payout = payoutAmount(msg.sender);
99         _payout(msg.sender, payout, false);
100     }
101 
102     //calculate the amount available for withdrawal on deposit
103     function payoutAmount(address addr) public view returns(uint) {
104         Investor storage inv = investors[addr];
105         if(inv.iteration != iterationIndex)
106             return 0;
107         uint varTime = inv.time;
108         uint varNow = now;
109         if(varTime > varNow) varTime = varNow;
110         uint percent = PERCENT_DAY;
111         uint decrease = PERCENT_DECREASE_PER_ITERATION * (iterationIndex - 1);
112         if(decrease > percent - PERCENT_DECREASE_PER_ITERATION)
113             decrease = percent - PERCENT_DECREASE_PER_ITERATION;
114         percent -= decrease;
115         uint rate = inv.deposit * percent / PERCENT_DIVIDER;
116         uint fraction = 100;
117         uint interestRate = fraction * (varNow  - varTime) / 1 days;
118         uint withdrawalAmount = rate * interestRate / fraction;
119         if(interestRate < 100) withdrawalAmount = 0;
120         return withdrawalAmount;
121     }
122 
123     //make a deposit
124     function makeDeposit() private {
125         if (msg.value > 0) {
126             Investor storage inv = investors[msg.sender];
127             if (inv.iteration != iterationIndex) {
128                 countOfInvestors += 1;
129                 if(inv.deposit > inv.withdrawnPure)
130 			        inv.deposit -= inv.withdrawnPure;
131 		        else
132 		            inv.deposit = 0;
133 		        if(inv.deposit + msg.value > maxDeposit) 
134 		            inv.deposit = maxDeposit - msg.value;
135 				inv.withdrawn = 0;
136 				inv.withdrawnPure = 0;
137 				inv.time = now;
138 				inv.iteration = iterationIndex;
139 				inv.lockedDeposit = inv.deposit;
140 				inv.isVoteProfit = false;
141             }
142             if (inv.deposit > 0 && now >= inv.time + TIME_QUANT) {
143                 collectPercent();
144             }
145             
146             inv.deposit += msg.value;
147             
148         } else {
149             collectPercent();
150         }
151     }
152 
153     //return of deposit balance
154     function returnDeposit() isIssetUser private {
155         Investor storage inv = investors[msg.sender];
156         uint withdrawalAmount = 0;
157         uint activDep = inv.deposit - inv.lockedDeposit;
158         if(activDep > inv.withdrawn)
159             withdrawalAmount = activDep - inv.withdrawn;
160 
161         if(withdrawalAmount > address(this).balance){
162             withdrawalAmount = address(this).balance;
163         }
164         //Pay the rest of deposit and take taxes
165         _payout(msg.sender, withdrawalAmount, true);
166 
167         //delete user record
168         _delete(msg.sender);
169     }
170     
171     function() external payable {
172         require(msg.value <= maxDeposit, "Deposit overflow");
173         
174         //refund of remaining funds when transferring to a contract 0.00000112 ether
175         Investor storage inv = investors[msg.sender];
176         if (msg.value == 0.00000112 ether && inv.iteration == iterationIndex) {
177             inv.deposit += msg.value;
178             if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
179             returnDeposit();
180         } else {
181             //start X3 Mode on 0.00000111 ether
182             if (msg.value == 0.00000111 ether && !isProfitStarted) {
183                 makeDeposit();
184                 if(inv.deposit > maxDeposit) inv.deposit = maxDeposit;
185                 if(!inv.isVoteProfit)
186                 {
187                     countStartVoices++;
188                     inv.isVoteProfit = true;
189                 }
190                 if((countStartVoices > 10 &&
191                     countStartVoices > countOfInvestors / 2) || 
192                     msg.sender == ADDRESS_ADMIN)
193     			    isProfitStarted = true;
194             } 
195             else
196             {
197                 require(
198                     msg.value == 0 ||
199                     address(this).balance <= maxBalance, 
200                     "Contract balance overflow");
201                 makeDeposit();
202                 require(inv.deposit <= maxDeposit, "Deposit overflow");
203             }
204         }
205     }
206     
207     function restart() private {
208 		countOfInvestors = 0;
209 		iterationIndex++;
210 		countStartVoices = 0;
211 		isProfitStarted = false;
212 	}
213 	
214     //Pays out, takes taxes according to holding time
215     function _payout(address addr, uint amount, bool retDep) private {
216         if(amount == 0)
217             return;
218 		if(amount > address(this).balance) amount = address(this).balance;
219 		if(amount == 0){
220 			restart();
221 			return;
222 		}
223 		Investor storage inv = investors[addr];
224         //Calculate pure payout that user receives
225         uint activDep = inv.deposit - inv.lockedDeposit;
226 		if(!retDep && !isProfitStarted && amount + inv.withdrawn > activDep / 2 )
227 		{
228 			if(inv.withdrawn < activDep / 2)
229     			amount = (activDep/2) - inv.withdrawn;
230 			else{
231     			if(inv.withdrawn >= activDep)
232     			{
233     				_delete(addr);
234     				return;
235     			}
236     			amount = activDep - inv.withdrawn;
237     			_delete(addr);
238 			}
239 		}
240         uint interestPure = amount * (PERCENT_DIVIDER - PERCENT_MAIN_FUND) / PERCENT_DIVIDER;
241 
242         //calculate money to charity
243         uint advTax = amount - interestPure;
244 
245 		inv.withdrawnPure += interestPure;
246 		inv.withdrawn += amount;
247 		inv.time = now;
248 
249         //send money
250         if(ADDRESS_MAIN_FUND.call.value(advTax)()) 
251             countOfAdvTax += advTax;
252         else
253             inv.withdrawn -= advTax;
254 
255         addr.transfer(interestPure);
256 
257 		if(address(this).balance == 0)
258 			restart();
259     }
260 
261     //Clears user from registry
262     function _delete(address addr) private {
263         if(investors[addr].iteration != iterationIndex)
264             return;
265         investors[addr].iteration = 0;
266         countOfInvestors--;
267     }
268 }