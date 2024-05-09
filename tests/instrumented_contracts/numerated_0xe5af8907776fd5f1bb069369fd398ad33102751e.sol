1 pragma solidity 0.4.25;
2 
3 /**
4  * 
5  *                                  ╔╗╔╗╔╗╔══╗╔╗──╔╗──╔══╗╔═══╗──╔╗──╔╗╔═══╗
6  *                                  ║║║║║║║╔╗║║║──║║──╚╗╔╝║╔══╝──║║──║║║╔══╝
7  *                                  ║║║║║║║╚╝║║║──║║───║║─║╚══╗──║╚╗╔╝║║╚══╗
8  *                                  ║║║║║║║╔╗║║║──║║───║║─║╔══╝──║╔╗╔╗║║╔══╝
9  *                                  ║╚╝╚╝║║║║║║╚═╗║╚═╗╔╝╚╗║╚══╗╔╗║║╚╝║║║╚══╗
10  *                                  ╚═╝╚═╝╚╝╚╝╚══╝╚══╝╚══╝╚═══╝╚╝╚╝──╚╝╚═══╝
11  *                                  ┌──────────────────────────────────────┐  
12  *                                  │      Website:  http://wallie.me      │
13  *                                  │                                      │  
14  *                                  │  CN Telegram: https://t.me/WallieCH  │
15  *                                  │  RU Telegram: https://t.me/wallieRU  |
16  *                                  │  *  Telegram: https://t.me/WallieNews|
17  *                                  |Twitter: https://twitter.com/Wallie_me|
18  *                                  └──────────────────────────────────────┘ 
19  *                    | Youtube – https://www.youtube.com/channel/UC1q3sPOlXsaJGrT8k-BZuyw |
20  *
21  *                                     * WALLIE - distribution contract *
22  * 
23  *  - Growth before 2000 ETH 1.1% and after 2000 ETH 1.2% in 24 hours
24  * 
25  * Distribution: *
26  * - 10% Advertising, promotion
27  * - 5% for developers and technical support
28  * 
29  * - Referral program:
30  *   5% Level 1
31  *   3% Level 2
32  *   1% Level 3
33  * 
34  * - 3% Cashback
35  * 
36  *
37  *
38  * Usage rules *
39  *  Holding:
40  *   1. Send any amount of ether but not less than 0.01 ETH to make a contribution.
41  *   2. Send 0 ETH at any time to get profit from the Deposit.
42  *  
43  *  - You can make a profit at any time. Consider your transaction costs (GAS).
44  *  
45  * Affiliate program *
46  * - You have access to a multy-level referral system for additional profit (5%, 3%, 1% of the referral's contribution).
47  * - Affiliate fees will come from each referral's Deposit as long as it doesn't change your wallet address Ethereum on the other.
48  * 
49  *  
50  * 
51  *
52  * RECOMMENDED GAS LIMIT: 300000
53  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
54  *
55  * The contract has been tested for vulnerabilities!
56  *
57  */
58 
59 contract Wallie
60 {
61     //Investor
62 	mapping (address => Investor) public investors;
63 
64 	//Event the new investor
65 	event NewInvestor(address _addr, uint256 _amount);
66 
67 	//Event of the accrual of cashback bonus
68 	event CashbackBonus(address _addr, uint256 _amount, uint256 _revenue);
69 
70 	//Referral bonus accrual event
71 	event RefererBonus(address _from, address _to, uint256 _amount, uint256 _revenue, uint256 _level);
72 
73 	//New contribution event
74 	event NewInvestment(address _addr, uint256 _amount);
75 
76 	//The event of the new withdrawal
77 	event NewWithdraw(address _addr, uint256 _amount);
78 
79 	//The event of changes in the balance of the smart contract
80 	event ChangeBalance(uint256 _balance);
81 
82 	struct Investor {
83 		//Member address
84 		address addr;
85 		//The address of the inviter
86 		address referer;
87 		//Deposit amount
88 		uint256 investment;
89 		//The time of the last contribution
90 		uint256 investment_time;
91 		//The time of the first contribution to the daily limit
92 		uint256 investment_first_time_in_day;
93 		//Deposit amount per day
94 		uint256 investments_daily;
95 		//Deposit income
96 		uint256 investment_profit;
97 		//Referral income
98 		uint256 referals_profit;
99 		//Cashback income
100 		uint256 cashback_profit;
101 		//Available balance income contributions
102 		uint256 investment_profit_balance;
103 		//Available referral income balance
104 		uint256 referals_profit_balance;
105 		//Available cashback income balance
106 		uint256 cashback_profit_balance;
107 	}
108 
109 	//Percentage of daily charges before reaching the balance of 2000 ETH
110 	uint256 private constant dividends_perc_before_2000eth = 11;        // 1.1%
111 	//Percentage of daily charges after reaching the balance of 2000 ETH
112 	uint256 private constant dividends_perc_after_2000eth = 12;         // 1.2%
113 	//The percentage of the referral bonus of the first line
114 	uint256 public constant ref_bonus_level_1 = 5;                      // 5%
115 	//Second line referral bonus percentage
116 	uint256 public constant ref_bonus_level_2 = 3;                      // 3%
117 	//The percentage of referral bonus is the third line
118 	uint256 public constant ref_bonus_level_3 = 1;                      // 1%
119 	//Cashback bonus percentage
120 	uint256 public constant cashback_bonus = 3;                         // 3%
121 	//Minimum payment
122 	uint256 public constant min_invesment = 10 finney;                  // 0.01 eth
123 	//Deduction for advertising
124 	uint256 public constant advertising_fees = 15;                      // 15%
125 	//Limit to receive funds on the same day
126 	uint256 public constant contract_daily_limit = 100 ether;
127 	//Lock entry tools
128 	bool public block_investments = true;
129 	//The mode of payment
130 	bool public compensation = true;
131 
132 	//Address smart contract first draft Wallie
133 	address first_project_addr = 0xC0B52b76055C392D67392622AE7737cdb6D42133;
134 
135 	//Start time
136 	uint256 public start_time;
137 	//Current day
138 	uint256 current_day;
139 	//Launch day
140 	uint256 start_day;
141 	//Deposit amount per day
142 	uint256 daily_invest_to_contract;
143 	//The address of the owner
144 	address private adm_addr;
145 	//Starting block
146 	uint256 public start_block;
147 	//Project started
148 	bool public is_started = false;
149 	
150 	//Statistics
151 	//All investors
152 	uint256 private all_invest_users_count = 0;
153 	//Just introduced to the fund
154 	uint256 private all_invest = 0;
155 	//Total withdrawn from the fund
156 	uint256 private all_payments = 0;
157 	//The last address of the depositor
158 	address private last_invest_addr = 0;
159 	//The amount of the last contribution
160 	uint256 private last_invest_amount = 0;
161 
162 	using SafeMath for uint;
163     using ToAddress for *;
164     using Zero for *;
165 
166 constructor() public {
167 		adm_addr = msg.sender;
168 		current_day = 0;
169 		daily_invest_to_contract = 0;
170 	}
171 
172 	//Current time
173 	function getTime() public view returns (uint256) {
174 		return (now);
175 	}
176 
177 	//The creation of the account of the investor
178 	function createInvestor(address addr,address referer) private {
179 		investors[addr].addr = addr;
180 		if (investors[addr].referer.isZero()) {
181 			investors[addr].referer = referer;
182 		}
183 		all_invest_users_count++;
184 		emit NewInvestor(addr, msg.value);
185 	}
186 
187 	//Check if there is an investor account
188 	function checkInvestor(address addr) public view returns (bool) {
189 		if (investors[addr].addr.isZero()) {
190 			return false;
191 		}
192 		else {
193 			return true;
194 		}
195 	}
196 
197 	//Accrual of referral bonuses to the participant
198 	function setRefererBonus(address addr, uint256 amount, uint256 level_percent, uint256 level_num) private {
199 		if (addr.notZero()) {
200 			uint256 revenue = amount.mul(level_percent).div(100);
201 
202 			if (!checkInvestor(addr)) {
203 				createInvestor(addr, address(0));
204 			}
205 
206 			investors[addr].referals_profit = investors[addr].referals_profit.add(revenue);
207 			investors[addr].referals_profit_balance = investors[addr].referals_profit_balance.add(revenue);
208 			emit RefererBonus(msg.sender, addr, amount, revenue, level_num);
209 		}
210 	}
211 
212 	//Accrual of referral bonuses to participants
213 	function setAllRefererBonus(address addr, uint256 amount) private {
214 
215 		address ref_addr_level_1 = investors[addr].referer;
216 		address ref_addr_level_2 = investors[ref_addr_level_1].referer;
217 		address ref_addr_level_3 = investors[ref_addr_level_2].referer;
218 
219 		setRefererBonus (ref_addr_level_1, amount, ref_bonus_level_1, 1);
220 		setRefererBonus (ref_addr_level_2, amount, ref_bonus_level_2, 2);
221 		setRefererBonus (ref_addr_level_3, amount, ref_bonus_level_3, 3);
222 	}
223 
224 	//Get the number of dividends
225 	function calcDivedents (address addr) public view returns (uint256) {
226 		uint256 current_perc = 0;
227 		if (address(this).balance < 2000 ether) {
228 			current_perc = dividends_perc_before_2000eth;
229 		}
230 		else {
231 			current_perc = dividends_perc_after_2000eth;
232 		}
233 
234 		return investors[addr].investment.mul(current_perc).div(1000).mul(now.sub(investors[addr].investment_time)).div(1 days);
235 	}
236 
237 	//We transfer dividends to the participant's account
238 	function setDivedents(address addr) private returns (uint256) {
239 		investors[addr].investment_profit_balance = investors[addr].investment_profit_balance.add(calcDivedents(addr));
240 	}
241 
242 	//We enroll the deposit
243 	function setAmount(address addr, uint256 amount) private {
244 		investors[addr].investment = investors[addr].investment.add(amount);
245 		investors[addr].investment_time = now;
246 		all_invest = all_invest.add(amount);
247 		last_invest_addr = addr;
248 		last_invest_amount = amount;
249 		emit NewInvestment(addr,amount);
250 	}
251 
252 	//Cashback enrollment
253 	function setCashBackBonus(address addr, uint256 amount) private {
254 		if (investors[addr].referer.notZero() && investors[addr].investment == 0) {
255 			investors[addr].cashback_profit_balance = amount.mul(cashback_bonus).div(100);
256 			investors[addr].cashback_profit = investors[addr].cashback_profit.add(investors[addr].cashback_profit_balance);
257 			emit CashbackBonus(addr, amount, investors[addr].cashback_profit_balance);
258 		}
259 	}
260 
261 	//Income payment
262 	function withdraw_revenue(address addr) private {
263 		uint256 withdraw_amount = calcDivedents(addr);
264 		
265 		if (check_x2_profit(addr,withdraw_amount) == true) {
266 		   withdraw_amount = 0; 
267 		}
268 		
269 		if (withdraw_amount > 0) {
270 		   investors[addr].investment_profit = investors[addr].investment_profit.add(withdraw_amount); 
271 		}
272 		
273 		withdraw_amount = withdraw_amount.add(investors[addr].investment_profit_balance).add(investors[addr].referals_profit_balance).add(investors[addr].cashback_profit_balance);
274 		
275 
276 		if (withdraw_amount > 0) {
277 			clear_balance(addr);
278 			all_payments = all_payments.add(withdraw_amount);
279 			emit NewWithdraw(addr, withdraw_amount);
280 			emit ChangeBalance(address(this).balance.sub(withdraw_amount));
281 			addr.transfer(withdraw_amount);
282 		}
283 	}
284 
285 	//Reset user balances
286 	function clear_balance(address addr) private {
287 		investors[addr].investment_profit_balance = 0;
288 		investors[addr].referals_profit_balance = 0;
289 		investors[addr].cashback_profit_balance = 0;
290 		investors[addr].investment_time = now;
291 	}
292 
293 	//Checking the x2 profit
294 	function check_x2_profit(address addr, uint256 dividends) private returns(bool) {
295 		if (investors[addr].investment_profit.add(dividends) > investors[addr].investment.mul(2)) {
296 		    investors[addr].investment_profit_balance = investors[addr].investment.mul(2).sub(investors[addr].investment_profit);
297 			investors[addr].investment = 0;
298 			investors[addr].investment_profit = 0;
299 			investors[addr].investment_first_time_in_day = 0;
300 			investors[addr].investment_time = 0;
301 			return true;
302 		}
303 		else {
304 		    return false;
305 		}
306 	}
307 
308 	function() public payable
309 	isStarted
310 	rerfererVerification
311 	isBlockInvestments
312 	minInvest
313 	allowInvestFirstThreeDays
314 	setDailyInvestContract
315 	setDailyInvest
316 	maxInvestPerUser
317 	maxDailyInvestPerContract
318 	setAdvertisingComiss {
319 
320 		if (msg.value == 0) {
321 			//Request available payment
322 			withdraw_revenue(msg.sender);
323 		}
324 		else
325 		{
326 			//Contribution
327 			address ref_addr = msg.data.toAddr();
328 
329 			//Check if there is an account
330 			if (!checkInvestor(msg.sender)) {
331 				//Создаем аккаунт пользователя
332 				createInvestor(msg.sender,ref_addr);
333 			}
334 
335 			//Transfer of dividends on Deposit
336 			setDivedents(msg.sender);
337 
338 			//Accrual of cashback
339 			setCashBackBonus(msg.sender, msg.value);
340 
341 			//Deposit enrollment
342 			setAmount(msg.sender, msg.value);
343 
344 			//Crediting bonuses to referrers
345 			setAllRefererBonus(msg.sender, msg.value);
346 		}
347 	}
348 
349 	//Current day
350 	function today() public view returns (uint256) {
351 		return now.div(1 days);
352 	}
353 
354 	//Prevent accepting deposits
355 	function BlockInvestments() public onlyOwner {
356 		block_investments = true;
357 	}
358 
359 	//To accept deposits
360 	function AllowInvestments() public onlyOwner {
361 		block_investments = false;
362 	}
363 	
364 	//Disable compensation mode
365 	function DisableCompensation() public onlyOwner {
366 		compensation = false;
367 	}
368 
369 	//Run the project
370 	function StartProject() public onlyOwner {
371 		require(is_started == false, "Project is started");
372 		block_investments = false;
373 		start_block = block.number;
374 		start_time = now;
375 		start_day = today();
376 		is_started = true;
377 	}
378 	
379 	//Investor account statistics
380 	function getInvestorInfo(address addr) public view returns (address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
381 		Investor memory investor_info = investors[addr];
382 		return (investor_info.referer,
383 		investor_info.investment,
384 		investor_info.investment_time,
385 		investor_info.investment_first_time_in_day,
386 		investor_info.investments_daily,
387 		investor_info.investment_profit,
388 		investor_info.referals_profit,
389 		investor_info.cashback_profit,
390 		investor_info.investment_profit_balance,
391 		investor_info.referals_profit_balance,
392 		investor_info.cashback_profit_balance);
393 	}
394 	
395 	//The stats for the site
396     function getWebStats() public view returns (uint256,uint256,uint256,uint256,address,uint256){
397     return (all_invest_users_count,address(this).balance,all_invest,all_payments,last_invest_addr,last_invest_amount); 
398     }
399 
400 	//Check the start of the project
401 	modifier isStarted() {
402 		require(is_started == true, "Project not started");
403 		_;
404 	}
405 
406 	//Checking deposit block
407 	modifier isBlockInvestments()
408 	{
409 		if (msg.value > 0) {
410 			require(block_investments == false, "investments is blocked");
411 		}
412 		_;
413 	}
414 
415 	//Counting the number of user deposits per day
416 	modifier setDailyInvest() {
417 		if (now.sub(investors[msg.sender].investment_first_time_in_day) < 1 days) {
418 			investors[msg.sender].investments_daily = investors[msg.sender].investments_daily.add(msg.value);
419 		}
420 		else {
421 			investors[msg.sender].investments_daily = msg.value;
422 			investors[msg.sender].investment_first_time_in_day = now;
423 		}
424 		_;
425 	}
426 
427 	//The maximum amount of contributions a user per day
428 	modifier maxInvestPerUser() {
429 		if (now.sub(start_time) <= 30 days) {
430 			require(investors[msg.sender].investments_daily <= 20 ether, "max payment must be <= 20 ETH");
431 		}
432 		else{
433 			require(investors[msg.sender].investments_daily <= 50 ether, "max payment must be <= 50 ETH");
434 		}
435 		_;
436 	}
437 
438 	//Maximum amount of all deposits per day
439 	modifier maxDailyInvestPerContract() {
440 		if (now.sub(start_time) <= 30 days) {
441 			require(daily_invest_to_contract <= contract_daily_limit, "all daily invest to contract must be <= 100 ETH");
442 		}
443 		_;
444 	}
445 
446 	//Minimum deposit amount
447 	modifier minInvest() {
448 		require(msg.value == 0 || msg.value >= min_invesment, "amount must be = 0 ETH or > 0.01 ETH");
449 		_;
450 	}
451 
452 	//Calculation of the total number of deposits per day
453 	modifier setDailyInvestContract() {
454 		uint256 day = today();
455 		if (current_day == day) {
456 			daily_invest_to_contract = daily_invest_to_contract.add(msg.value);
457 		}
458 		else {
459 			daily_invest_to_contract = msg.value;
460 			current_day = day;
461 		}
462 		_;
463 	}
464 
465 	//Permission for users of the previous project whose payments were <= 30% to make a contribution in the first 3 days
466 	modifier allowInvestFirstThreeDays() {
467 		if (now.sub(start_time) <= 3 days && compensation == true) {
468 			uint256 invested = WallieFirstProject(first_project_addr).invested(msg.sender);
469 
470 			require(invested > 0, "invested first contract must be > 0");
471 
472 			uint256 payments = WallieFirstProject(first_project_addr).payments(msg.sender);
473 
474 			uint256 payments_perc = payments.mul(100).div(invested);
475 
476 			require(payments_perc <= 30, "payments first contract must be <= 30%");
477 		}
478 		_;
479 	}
480 
481 	//Verify the date field
482 	modifier rerfererVerification() {
483 		address ref_addr = msg.data.toAddr();
484 		if (ref_addr.notZero()) {
485 			require(msg.sender != ref_addr, "referer must be != msg.sender");
486 			require(investors[ref_addr].referer != msg.sender, "referer must be != msg.sender");
487 		}
488 		_;
489 	}
490 
491 	//Only the owner
492 	modifier onlyOwner() {
493 		require(msg.sender == adm_addr,"onlyOwner!");
494 		_;
495 	}
496 
497 	//Payment of remuneration for advertising
498 	modifier setAdvertisingComiss() {
499 		if (msg.sender != adm_addr && msg.value > 0) {
500 			investors[adm_addr].referals_profit_balance = investors[adm_addr].referals_profit_balance.add(msg.value.mul(advertising_fees).div(100));
501 		}
502 		_;
503 	}
504 
505 }
506 
507 //The interface of the first draft (the amount of deposits and amount of payments)
508 contract WallieFirstProject {
509 
510 	mapping (address => uint256) public invested;
511 
512 	mapping (address => uint256) public payments;
513 }
514 
515 library SafeMath {
516 
517 	/**
518 	  * @dev Multiplies two numbers, reverts on overflow.
519 	  */
520 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522 		// benefit is lost if 'b' is also tested.
523 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
524 		if (a == 0) {
525 			return 0;
526 		}
527 
528 		uint256 c = a * b;
529 		require(c / a == b);
530 
531 		return c;
532 	}
533 
534 	/**
535 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
536 	*/
537 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
538 		require(b > 0); // Solidity only automatically asserts when dividing by 0
539 		uint256 c = a / b;
540 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
541 
542 		return c;
543 	}
544 
545 	/**
546 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
547 	*/
548 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
549 		require(b <= a);
550 		uint256 c = a - b;
551 
552 		return c;
553 	}
554 
555 	/**
556 	* @dev Adds two numbers, reverts on overflow.
557 	*/
558 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
559 		uint256 c = a + b;
560 		require(c >= a);
561 
562 		return c;
563 	}
564 
565 	/**
566 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
567 	* reverts when dividing by zero.
568 	*/
569 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
570 		require(b != 0);
571 		return a % b;
572 	}
573 }
574 
575 library ToAddress
576 {
577 	function toAddr(uint source) internal pure returns(address) {
578 		return address(source);
579 	}
580 
581 	function toAddr(bytes source) internal pure returns(address addr) {
582 		assembly { addr := mload(add(source,0x14)) }
583 		return addr;
584 	}
585 }
586 
587 library Zero
588 {
589 	function requireNotZero(uint a) internal pure {
590 		require(a != 0, "require not zero");
591 	}
592 
593 	function requireNotZero(address addr) internal pure {
594 		require(addr != address(0), "require not zero address");
595 	}
596 
597 	function notZero(address addr) internal pure returns(bool) {
598 		return !(addr == address(0));
599 	}
600 
601 	function isZero(address addr) internal pure returns(bool) {
602 		return addr == address(0);
603 	}
604 }