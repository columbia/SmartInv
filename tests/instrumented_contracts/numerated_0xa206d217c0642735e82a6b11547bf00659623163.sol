1 pragma solidity ^0.4.25;
2 
3 /*
4 ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗████████╗ █████╗ ██╗  ██╗███████╗
5 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██║ ██╔╝██╔════╝
6 ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝███████╗   ██║   ███████║█████╔╝ █████╗  
7 ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║   ██║   ██╔══██║██╔═██╗ ██╔══╝  
8 ██║  ██║   ██║   ██║     ███████╗██║  ██║███████║   ██║   ██║  ██║██║  ██╗███████╗
9 ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
10 */
11 
12 
13 contract HyperETH {
14 	
15 	/**
16      * Transfer tokens from the caller to a new holder.
17      * Remember, there's 0% fee here.
18      */
19     function transfer(address _toAddress, uint256 _amountOfTokens) public returns(bool);
20 	
21 	/**
22      * Retrieve the tokens owned by the caller.
23      */
24 	function myTokens() public view returns(uint256);
25 	
26 	/**
27      * Retrieve the dividends owned by the caller.
28      * If `_includeReferralBonus` is 1/true, the referral bonus will be included in the calculations.
29      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
30      * But in the internal calculations, we want them separate. 
31      */ 
32     function myDividends(bool _includeReferralBonus) public view returns(uint256);
33 	
34 	/**
35      * Converts all incoming ethereum to tokens for the caller, and passes down the referral
36      */
37     function buy(address _referredBy) public payable returns(uint256);
38 	
39 	/**
40      * Withdraws all of the callers earnings.
41      */
42     function withdraw() public;
43 	
44 	/**
45      * Converts all of caller's dividends to tokens.
46      */
47 	function reinvest() public;
48 	
49 	/**
50      * Fallback function to handle ethereum that was send straight to the contract
51      * Unfortunately we cannot use a referral address this way.
52      */
53 	function() payable external;
54 }
55 
56 
57 /**
58  * Accepts HYPER tokens: Staking
59  */
60 contract Staking {
61 	using SafeMath for *;
62 	
63 	/*==============================
64     =            EVENTS            =
65     ==============================*/
66     // ERC20
67     event Transfer (
68         address indexed from,
69         address indexed to,
70         uint256 tokens
71     );
72 	
73 	event onDeposit (
74 		address indexed customer,
75 		uint256 tokens
76 	);
77 	
78 	event onReinvestProfit (
79 		address indexed customer,
80 		uint256 tokens
81 	);
82 	
83 	event onWithdrawProfit (
84 		address indexed customer,
85 		uint256 tokens
86 	);
87 	
88 	event onWithdrawCapital (
89 		address indexed customer,
90 		uint256 tokens
91 	);
92 	
93 	
94 	/*=================================
95     =            MODIFIERS            =
96     =================================*/	
97 	modifier onlyTokenContract {
98         require(msg.sender == address(tokenContract_));
99         _;
100     }
101 	
102 	// only people with deposit
103     modifier onlyBagholders() {
104         require(myDeposit() > 0);
105         _;
106     }
107     
108     // only people with profits
109     modifier onlyStronghands() {
110         require(myProfit(msg.sender) > 0);
111         _;
112     }
113 	
114 	// administrators can:
115     // -> set token contract
116     // they CANNOT:
117     // -> take funds
118     // -> disable withdrawals
119     // -> kill the contract
120     // -> change the price of tokens
121     modifier onlyAdministrator(){
122         address _customerAddress = msg.sender;
123         require(administrator_ == _customerAddress);
124         _;
125     }
126 	
127 	
128 	/*================================
129     =            DATASETS            =
130     ================================*/
131     // amount of shares for each address (scaled number)
132     mapping(address => Dealer) internal dealers_; 	// address => Dealer
133     uint256 internal totalDeposit_ = 0;
134 	
135 	// token exchange contract
136 	HyperETH public tokenContract_;
137 	
138 	// administrator (see above on what they can do)
139     address internal administrator_;
140 	
141 	// Player data
142 	struct Dealer {
143 		uint256 deposit;		// active deposit
144 		uint256 profit;			// old outstanding profits
145 		uint256 time;			// last time profits have been moved
146 	}
147     
148 	
149 	/*=======================================
150     =            PUBLIC FUNCTIONS            =
151     =======================================*/
152     constructor() public {
153 		administrator_ = 0x73018870D10173ae6F71Cac3047ED3b6d175F274;
154     }
155 	
156 	function() payable external {
157 		// prevent invalid or unintentional calls
158 		//require(msg.data.length == 0);
159 	}
160 	
161 	/**
162     * @dev Standard ERC677 function that will handle incoming token transfers.
163     *
164     * @param _from  Token sender address.
165     * @param _value Amount of tokens.
166     * @param _data  Transaction metadata.
167     */
168     function tokenFallback(address _from, uint256 _value, bytes _data)
169 		onlyTokenContract()
170 		external
171 		returns (bool)
172 	{
173         // data setup
174 		Dealer storage _dealer = dealers_[_from];
175 		
176 		// profit and deposit tracking
177 		_dealer.profit = myProfit(_from);	/* saves the new generated profit; old profit will be taken into account within the calculation
178 											   last time deposit timer is 0 for the first deposit */
179 		_dealer.time = now;					// so we set the timer AFTER calculating profits
180         
181 		// allocate tokens
182 		_dealer.deposit = _dealer.deposit.add(_value);
183 		totalDeposit_ = totalDeposit_.add(_value);
184 		
185 		// trigger event
186 		emit onDeposit(_from, _value);
187 		
188 		return true;
189 		
190 		// silence compiler warning
191 		_data;
192 	}
193 	
194 	/**
195 	 * Reinvest generated profit
196 	 */
197 	function reinvestProfit()
198 		onlyStronghands()
199 		public 
200 	{
201 		address _customerAddress = msg.sender;
202 		Dealer storage _dealer = dealers_[_customerAddress];
203 		
204 		uint256 _profits = myProfit(_customerAddress);
205 		
206 		// update Dealer
207 		_dealer.deposit = _dealer.deposit.add(_profits);	// add new tokens to active deposit
208 		_dealer.profit = 0;									// old tokens have been reinvested
209 		_dealer.time = now;									// generate tokens from now
210 		
211 		// update total deposit value
212 		totalDeposit_ = totalDeposit_.add(_profits);
213 		
214 		// trigger event
215 		emit onReinvestProfit(_customerAddress, _profits);
216 	}
217 	
218 	/**
219 	 * Withdraw profit to token exchange
220 	 */
221 	function withdrawProfit()
222 		onlyStronghands()
223 		public
224 	{
225 		address _customerAddress = msg.sender;
226 		Dealer storage _dealer = dealers_[_customerAddress];
227 		
228 		uint256 _profits = myProfit(_customerAddress);
229 		
230 		// update profits
231 		_dealer.profit = 0;		// old tokens have been reinvested
232 		_dealer.time = now;		// generate tokens from now
233 		
234 		// transfer tokens from exchange to sender
235 		tokenContract_.transfer(_customerAddress, _profits);
236 		
237 		// trigger event
238 		emit onWithdrawProfit(_customerAddress, _profits);
239 	}
240 	
241 	/**
242 	 * Withdraw deposit to token exchange. 10% fee will be incured
243 	 */
244 	function withdrawCapital()
245 		onlyBagholders()
246 		public
247 	{
248 		address _customerAddress = msg.sender;
249 		Dealer storage _dealer = dealers_[_customerAddress];
250 		
251 		uint256 _deposit = _dealer.deposit;
252 		uint256 _taxedDeposit = _deposit.mul(90).div(100);
253 		uint256 _profits = myProfit(_customerAddress);
254 		
255 		// update deposit
256 		_dealer.deposit = 0;
257 		_dealer.profit = _profits;
258 		
259 		// reduce tokens in staking deposit ledger
260 		// use the untaxed value, bcs Dealers deposit will drop to 0,
261 		// but token transfer (below) will be taxed
262 		totalDeposit_ = totalDeposit_.sub(_deposit);
263 		
264 		// transfer tokens from exchange to sender
265 		tokenContract_.transfer(_customerAddress, _taxedDeposit);
266 		
267 		// trigger event
268 		emit onWithdrawCapital(_customerAddress, _taxedDeposit);
269 	}
270 	
271 	/**
272 	 * Staking will reinvest its ETH
273 	 */
274 	function reinvestEther()
275 		public
276 	{
277 		uint256 _balance = address(this).balance;
278 		if (_balance > 0) {
279 			// triggers exchanges payable fallback buy function
280 			if(!address(tokenContract_).call.value(_balance)()) {
281 				// Some failure code
282 				revert();
283 			}
284 		}
285 	}
286 	
287 	/**
288 	 * Staking will reinvest its dividends
289 	 */
290 	function reinvestDividends()
291 		public
292 	{
293 		uint256 _dividends = myDividends(true);
294 		if (_dividends > 0) {
295 			tokenContract_.reinvest();
296 		}
297 	}
298 	
299 	
300 	/*----------  HELPERS AND CALCULATORS  ----------*/	
301     /**
302      * Retrieve the total token supply.
303      */
304     function totalDeposit()
305         public
306         view
307         returns(uint256)
308     {
309         return totalDeposit_;
310     }
311 	
312 	/**
313      * Retrieve the total token supply.
314      */
315     function totalSupply()
316         public
317         view
318         returns(uint256)
319     {
320         return tokenContract_.myTokens();
321     }
322 	
323 	function stakepool()
324 		public
325 		view
326 		returns(int256)
327 	{
328 		uint256 _tokens = totalSupply();
329 		
330 		// we cannot divide by 0
331 		if (totalDeposit_ > 0) {
332 			// returns a value that indicates the token pool amount of the staking contract
333 			// based on 1000 => 1000 = 100%; 303 = 30.3%; -200 = -20%
334 			return int256((1000).mul(_tokens).div(totalDeposit_) - 1000);
335 		} else {
336 			return 1000;	// 100%
337 		}
338 	}
339 	
340 	/**
341      * Retrieve the tokens owned by the caller.
342      */
343     function myDeposit()
344         public
345         view
346         returns(uint256)
347     {
348 		address _customerAddress = msg.sender;
349         Dealer storage _dealer = dealers_[_customerAddress];
350         return _dealer.deposit;
351     }
352 	
353 	/**
354      * Retrieve the profit of the caller. Profits are virtual
355      */
356 	function myProfit(address _customerAddress)
357 		public
358 		view
359 		returns(uint256)
360 	{
361 		Dealer storage _dealer = dealers_[_customerAddress];
362 		uint256 _oldProfits = _dealer.profit;
363 		uint256 _newProfits = 0;
364 		
365 		if (
366 			// if time is 0, the dealer has not deposited tokens yet
367 			_dealer.time == 0 ||
368 			
369 			// dealer has currently no tokens deposited
370 			_dealer.deposit == 0
371 		)
372 		{
373 			_newProfits = 0;
374 		} else {
375 			// get the last deposit time stamp
376 			uint256 _timeStaking = now - _dealer.time;
377 			
378 			_newProfits = _timeStaking	// time difference since profits are being generated
379 				.mul(_dealer.deposit)	// current deposit
380 				.mul(1000)				// 1.000% (daily)
381 				.div(100000)			// to base 100%
382 				.div(86400);			// 1 day in seconds
383 		}
384 		
385 		// Dealer may have tokens in profit wallet left, so always add the old value
386 		return _newProfits.add(_oldProfits);
387 	}
388 	
389 	function myDividends(bool _includeReferralBonus)
390 		public
391 		view
392 		returns(uint256)
393 	{
394 		return tokenContract_.myDividends(_includeReferralBonus);
395 	}
396 	
397 	/**
398 	 * Set the token contract
399 	 */
400 	function setTokenContract(address _tokenContract)
401 		onlyAdministrator()
402 		public
403 	{
404 		tokenContract_ = HyperETH(_tokenContract);
405 	}
406 }
407 
408 
409 /**
410  * @title SafeMath
411  * @dev Math operations with safety checks that throw on error
412  */
413 library SafeMath {
414 
415     /**
416     * @dev Multiplies two numbers, throws on overflow.
417     */
418     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
419         if (a == 0) {
420             return 0;
421         }
422         uint256 c = a * b;
423         assert(c / a == b);
424         return c;
425     }
426 
427     /**
428     * @dev Integer division of two numbers, truncating the quotient.
429     */
430     function div(uint256 a, uint256 b) internal pure returns (uint256) {
431         // assert(b > 0); // Solidity automatically throws when dividing by 0
432         uint256 c = a / b;
433         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
434         return c;
435     }
436 
437     /**
438     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
439     */
440     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
441         assert(b <= a);
442         return a - b;
443     }
444 
445     /**
446     * @dev Adds two numbers, throws on overflow.
447     */
448     function add(uint256 a, uint256 b) internal pure returns (uint256) {
449         uint256 c = a + b;
450         assert(c >= a);
451         return c;
452     }
453 }