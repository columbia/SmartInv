1 pragma solidity ^0.4.25;
2 
3 /**
4  *  BoostPro contract
5  *
6  *	PERCENTS: 	 
7  * 		0.125% - 0.208% per hour (3.0% - 5.0% per day)
8  *
9  *  	Contract balance          		Percent per day
10  *       	 < 1000                   	~3.0%		(0.125% per hour)		
11  *    	1000 - 1500                 	~3.5%		(0.146% per hour)
12  *    	1500 - 2000                 	~4.0%		(0.167% per hour)
13  *    	2000 - 2500                 	~4.5%		(0.188% per hour)
14  *      	>= 2500                   	~5.0%		(0.208% per hour)
15  *
16  * 	BONUS PERCENT:
17  *		
18  *		Investor number					Percent per day
19  *			 1-10						~5.0%		(0.208% per hour)
20  *		    11-20						~4.5%		(0.188% per hour)
21  *		    21-30						~4.0%		(0.167% per hour)
22  *		    31-60						~3.5%		(0.146% per hour)
23  *		   61-100						~3.0%		(0.125% per hour)
24  *		  101-150						~2.5%		(0.104% per hour)
25  *		  151-300						~2.0%		(0.083% per hour)
26  *		  301-500						~1.5%		(0.063% per hour)
27  *		    >=501						~1.0%		(0.042% per hour)
28  *
29  *
30  *	PR & SERVICE: 10%
31  *
32  *  MAXIMUM RETURN IS BOUNDED BY X2.
33  *
34  *	REFERRERS:
35  *		3% of your deposit - bonus for referrer
36  *		2% cashback if referrer is specified
37  *
38  *  INSTRUCTIONS:
39  *
40  *  TO INVEST: send ETH to contract address
41  *  TO WITHDRAW INTEREST: send 0 ETH to contract address
42  *  TO REINVEST AND WITHDRAW INTEREST: send ETH to contract address
43  *
44  */
45  
46  contract BoostPro {
47     
48 	// For safe math operations
49     using SafeMath for uint;
50 	
51 	// Investor structure
52 	struct Investor
53     {
54         uint deposit;						// Total user investment
55 		uint datetime;						// Datetime last payment
56 		uint paid;							// Interest paid to Investor
57 		uint bonus;							// Bonus rate
58         address referrer;					// Referrer address
59     }
60 
61     // Array of investors
62     mapping(address => Investor) public investors;
63 
64     // Fund to transfer percent for PR & service
65 	address private constant ADDRESS_PR = 0x16C223B0Fd0c1090E5273eEBFb672FbF97C3D790;
66 	
67 	// Percent for a PR & service foundation
68     uint private constant PERCENT_PR_FUND = 10000;
69 	
70 	// Peferral cashback percent
71 	uint private constant REFERRAL_CASHBACK = 2000;
72 	// Peferrer bonus percent
73 	uint private constant REFERRER_BONUS = 3000;
74     
75 	// Time through which you can take dividends
76     uint private constant DIVIDENDS_TIME = 1 hours;
77     // All percent should be divided by this
78     uint private constant PERCENT_DIVIDER = 100000;
79 	
80 	// Users ranges for bonus rate
81 	uint private constant RANGE_1 = 10;
82 	uint private constant RANGE_2 = 20;
83 	uint private constant RANGE_3 = 30;
84 	uint private constant RANGE_4 = 60;
85 	uint private constant RANGE_5 = 100;
86 	uint private constant RANGE_6 = 150;
87 	uint private constant RANGE_7 = 300;
88 	uint private constant RANGE_8 = 500;
89 	
90 	uint private constant BONUS_1 = 208;
91 	uint private constant BONUS_2 = 188;
92 	uint private constant BONUS_3 = 167;
93 	uint private constant BONUS_4 = 146;
94 	uint private constant BONUS_5 = 125;
95 	uint private constant BONUS_6 = 104;
96 	uint private constant BONUS_7 = 83;
97 	uint private constant BONUS_8 = 63;
98 	
99     uint public investors_count = 0;
100 	uint public transaction_count = 0;
101 	uint public last_payment_date = 0;
102 	uint public paid_by_fund = 0;
103 
104     modifier isIssetUser() {
105         require(investors[msg.sender].deposit > 0, "Deposit not found");
106         _;
107     }
108 
109     modifier timePayment() {
110         require(now >= investors[msg.sender].datetime.add(DIVIDENDS_TIME), "Too fast payout request");
111         _;
112     }
113 
114 	// Entry point
115 	function() external payable {
116 
117 		processDeposit();
118 
119     }
120 	
121 	
122 	// Start process
123 	function processDeposit() private {
124         
125 		if (msg.value > 0) {
126 			
127 			if (investors[msg.sender].deposit == 0) {
128                 
129 				// Increase investors count
130 				investors_count += 1;
131 				investors[msg.sender].bonus = getBonusPercentRate();
132 				
133 				// For Referrers bonus & Referrals cashback
134 				address referrer = bytesToAddress(msg.data);
135 				if (investors[referrer].deposit > 0 && referrer != msg.sender && investors[msg.sender].referrer == 0x0) {
136 					_payoutReferr(msg.sender, referrer);
137 				}
138 								
139             }
140 			
141 			if (investors[msg.sender].deposit > 0 && now >= investors[msg.sender].datetime.add(DIVIDENDS_TIME)) {
142                 processPayout();
143             }
144 
145 			investors[msg.sender].deposit += msg.value;
146             investors[msg.sender].datetime = now;
147 			transaction_count += 1;
148 		} else {
149             processPayout();
150         }
151 		
152     }
153 	
154 	// For Referrers bonus & Referrals cashback
155 	function _payoutReferr(address referral, address referrer) private {
156 		investors[referral].referrer = referrer;
157 		uint r_cashback = msg.value.mul(REFERRAL_CASHBACK).div(PERCENT_DIVIDER);
158 		uint r_bonus = msg.value.mul(REFERRER_BONUS).div(PERCENT_DIVIDER);
159 		referral.transfer(r_cashback);
160 		referrer.transfer(r_bonus);
161 	}
162 	
163     // Return of interest on the deposit
164     function processPayout() isIssetUser timePayment internal {
165         if (investors[msg.sender].deposit.mul(2) <= investors[msg.sender].paid) {
166             _delete(msg.sender);
167 		} else {
168             uint payout = getTotalInterestAmount(msg.sender);
169             _payout(msg.sender, payout);
170         }
171     }
172 	
173 	// Calculation total amount to transfer
174     function getTotalInterestAmount(address addr) public view returns(uint) {
175 		
176 		uint balance_percent = getBalancePercentRate();
177 		uint amount_per_period = investors[addr].deposit.mul(balance_percent + investors[addr].bonus).div(PERCENT_DIVIDER);
178 		uint period_count = now.sub(investors[addr].datetime).div(DIVIDENDS_TIME);
179 		uint total_amount = amount_per_period.mul(period_count);
180 		
181 		// Subtract the extra bonus amount
182 		total_amount = subtractAmount(addr, amount_per_period, period_count, total_amount);
183 		
184 		return total_amount;
185     }
186 	
187 	// Subtract the extra bonus amount
188 	function subtractAmount(address addr, uint amount_per_period, uint period_count, uint total_amount) public view returns(uint) {
189 		
190 		if (investors[addr].paid.add(total_amount) > investors[addr].deposit && investors[addr].bonus > 0) {
191 			
192 			uint delta_amount = investors[addr].deposit - investors[addr].paid;
193 			uint delta_period = delta_amount.div(amount_per_period);
194 			
195 			uint subtract_period = period_count - delta_period;
196 			uint subtract_amount_per_period = investors[addr].deposit.mul(investors[addr].bonus).div(PERCENT_DIVIDER);
197 			uint subtract_amount = subtract_amount_per_period.mul(subtract_period);
198 			
199 			total_amount -= subtract_amount;
200 			
201 		}
202 		
203 		return total_amount;
204 	}
205 	
206 	// Calculation transfer amounts for every address
207     function _payout(address addr, uint amount) private {
208 		
209 		// If the amount of payments exceeded the deposit
210 		if (investors[addr].paid.add(amount) > investors[addr].deposit && investors[addr].bonus > 0) {
211 			investors[addr].bonus = 0;
212 		}
213 
214         // To Investor (w/o tax)
215         uint investor_amount = amount.mul(PERCENT_DIVIDER - PERCENT_PR_FUND).div(PERCENT_DIVIDER);
216 		
217 		if(investors[addr].paid.add(investor_amount) > investors[addr].deposit.mul(2)) {
218 			investor_amount = investors[addr].deposit.mul(2) - investors[addr].paid;
219 			amount = investor_amount.mul(PERCENT_DIVIDER).div(PERCENT_DIVIDER - PERCENT_PR_FUND);
220 		}
221 		
222 		investors[addr].paid += investor_amount;
223         investors[addr].datetime = now;
224 		
225 		// To Advertising
226         uint pr_amount = amount.sub(investor_amount);
227         
228         paid_by_fund += amount;
229 		last_payment_date = now;
230 		
231 		// Send money
232         ADDRESS_PR.transfer(pr_amount);
233         addr.transfer(investor_amount);
234 		
235     }
236 	
237     // Calculation of the current interest rate on the deposit
238     function getBalancePercentRate() public view returns(uint) {
239         
240 		// Current contract balance
241         uint balance = getBalance();
242 
243         //calculate percent rate
244         if (balance < 1000 ether) {
245             return 125;
246         }
247         if (balance < 1500 ether) {
248             return 146;
249         }
250 		if (balance < 2000 ether) {
251             return 167;
252         }
253 		if (balance < 2500 ether) {
254             return 188;
255         }
256 
257         return 208;
258     }
259 	
260 	// Calculation of the current interest rate on the deposit
261     function getBonusPercentRate() public view returns(uint) {
262         
263 		if (investors_count <= RANGE_1) {
264 			return BONUS_1;
265 		}
266 		if (investors_count <= RANGE_2) {
267 			return BONUS_2;
268 		}
269 		if (investors_count <= RANGE_3) {
270 			return BONUS_3;
271 		}
272 		if (investors_count <= RANGE_4) {
273 			return BONUS_4;
274 		}
275 		if (investors_count <= RANGE_5) {
276 			return BONUS_5;
277 		}
278 		if (investors_count <= RANGE_6) {
279 			return BONUS_6;
280 		}
281 		if (investors_count <= RANGE_7) {
282 			return BONUS_7;
283 		}
284 		if (investors_count <= RANGE_8) {
285 			return BONUS_8;
286 		}
287 		
288 		return 42;
289     }
290 	
291 	// Return current contract balance
292     function getBalance() public view returns(uint) {
293         uint balance = address(this).balance;
294 		return balance;
295 	}
296 	
297     // Reset Investor data
298     function _delete(address addr) private {
299         investors[addr].deposit = 0;
300 		investors[addr].datetime = 0;
301 		investors[addr].paid = 0;
302 		investors[addr].bonus = 0;
303     }
304 	
305 	function bytesToAddress(bytes bys) private pure returns (address addr) {
306         assembly {
307             addr := mload(add(bys, 20))
308         }
309     }
310 	
311 }
312 
313 /**
314  * @title SafeMath
315  * @dev Math operations with safety checks that throw on error
316  */
317 library SafeMath {
318 
319     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
320         uint256 c = a * b;
321         assert(a == 0 || c / a == b);
322         return c;
323     }
324 
325     function div(uint256 a, uint256 b) internal pure returns(uint256) {
326         // assert(b > 0); // Solidity automatically throws when dividing by 0
327         uint256 c = a / b;
328         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
329         return c;
330     }
331 
332     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
333         assert(b <= a);
334         return a - b;
335     }
336 
337     function add(uint256 a, uint256 b) internal pure returns(uint256) {
338         uint256 c = a + b;
339         assert(c >= a);
340         return c;
341     }
342 
343 }