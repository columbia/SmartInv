1 pragma solidity ^0.4.25;
2 
3 
4 contract Prosperity {
5 	
6 	/**
7      * Transfer tokens from the caller to a new holder.
8      * Remember, there's 0% fee here.
9      */
10     function transfer(address _toAddress, uint256 _amountOfTokens) public returns(bool);
11 	
12 	/**
13      * Retrieve the tokens owned by the caller.
14      */
15 	function myTokens() public view returns(uint256);
16 	
17 	/**
18      * Retrieve the dividends owned by the caller.
19      * If `_includeReferralBonus` is 1/true, the referral bonus will be included in the calculations.
20      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
21      * But in the internal calculations, we want them separate. 
22      */ 
23     function myDividends(bool _includeReferralBonus) public view returns(uint256);
24 	
25 	/**
26      * Converts all incoming ethereum to tokens for the caller, and passes down the referral
27      */
28     function buy(address _referredBy) public payable returns(uint256);
29 	
30 	/**
31      * Withdraws all of the callers earnings.
32      */
33     function withdraw() public;
34 	
35 	/**
36      * Converts all of caller's dividends to tokens.
37      */
38 	function reinvest() public;
39 	
40 	/**
41      * Fallback function to handle ethereum that was send straight to the contract
42      * Unfortunately we cannot use a referral address this way.
43      */
44 	function() payable external;
45 }
46 
47 
48 /**
49  * Accepts THC tokens: Lending
50  */
51 contract Lending {
52 	using SafeMath for *;
53 	
54 	/*==============================
55     =            EVENTS            =
56     ==============================*/
57     // ERC20
58     event Transfer (
59         address indexed from,
60         address indexed to,
61         uint256 tokens
62     );
63 	
64 	event onDeposit (
65 		address indexed customer,
66 		uint256 tokens
67 	);
68 	
69 	event onReinvestProfit (
70 		address indexed customer,
71 		uint256 tokens
72 	);
73 	
74 	event onWithdrawProfit (
75 		address indexed customer,
76 		uint256 tokens
77 	);
78 	
79 	event onWithdrawCapital (
80 		address indexed customer,
81 		uint256 tokens
82 	);
83 	
84 	
85 	/*=================================
86     =            MODIFIERS            =
87     =================================*/	
88 	modifier onlyTokenContract {
89         require(msg.sender == address(tokenContract_));
90         _;
91     }
92 	
93 	// only people with deposit
94     modifier onlyBagholders() {
95         require(myDeposit() > 0);
96         _;
97     }
98     
99     // only people with profits
100     modifier onlyStronghands() {
101         require(myProfit(msg.sender) > 0);
102         _;
103     }
104 	
105 	// administrators can:
106     // -> set token contract
107     // they CANNOT:
108     // -> take funds
109     // -> disable withdrawals
110     // -> kill the contract
111     // -> change the price of tokens
112     modifier onlyAdministrator(){
113         address _customerAddress = msg.sender;
114         require(administrator_ == _customerAddress);
115         _;
116     }
117 	
118 	
119 	/*================================
120     =            DATASETS            =
121     ================================*/
122     // amount of shares for each address (scaled number)
123     mapping(address => Dealer) internal dealers_; 	// address => Dealer
124     uint256 internal totalDeposit_ = 0;
125 	
126 	// token exchange contract
127 	Prosperity public tokenContract_;
128 	
129 	// administrator (see above on what they can do)
130     address internal administrator_;
131 	
132 	// Player data
133 	struct Dealer {
134 		uint256 deposit;		// active deposit
135 		uint256 profit;			// old outstanding profits
136 		uint256 time;			// last time profits have been moved
137 	}
138     
139 	
140 	/*=======================================
141     =            PUBLIC FUNCTIONS            =
142     =======================================*/
143     constructor() public {
144 		administrator_ = 0x28436C7453EbA01c6EcbC8a9cAa975f0ADE6Fff1;
145     }
146 	
147 	function() payable external {
148 		// prevent invalid or unintentional calls
149 		//require(msg.data.length == 0);
150 	}
151 	
152 	/**
153     * @dev Standard ERC677 function that will handle incoming token transfers.
154     *
155     * @param _from  Token sender address.
156     * @param _value Amount of tokens.
157     * @param _data  Transaction metadata.
158     */
159     function tokenFallback(address _from, uint256 _value, bytes _data)
160 		onlyTokenContract()
161 		external
162 		returns (bool)
163 	{
164         // data setup
165 		Dealer storage _dealer = dealers_[_from];
166 		
167 		// profit and deposit tracking
168 		_dealer.profit = myProfit(_from);	/* saves the new generated profit; old profit will be taken into account within the calculation
169 											   last time deposit timer is 0 for the first deposit */
170 		_dealer.time = now;					// so we set the timer AFTER calculating profits
171         
172 		// allocate tokens
173 		_dealer.deposit = _dealer.deposit.add(_value);
174 		totalDeposit_ = totalDeposit_.add(_value);
175 		
176 		// trigger event
177 		emit onDeposit(_from, _value);
178 		
179 		return true;
180 		
181 		// silence compiler warning
182 		_data;
183 	}
184 	
185 	/**
186 	 * Reinvest generated profit
187 	 */
188 	function reinvestProfit()
189 		onlyStronghands()
190 		public 
191 	{
192 		address _customerAddress = msg.sender;
193 		Dealer storage _dealer = dealers_[_customerAddress];
194 		
195 		uint256 _profits = myProfit(_customerAddress);
196 		
197 		// update Dealer
198 		_dealer.deposit = _dealer.deposit.add(_profits);	// add new tokens to active deposit
199 		_dealer.profit = 0;									// old tokens have been reinvested
200 		_dealer.time = now;									// generate tokens from now
201 		
202 		// update total deposit value
203 		totalDeposit_ = totalDeposit_.add(_profits);
204 		
205 		// trigger event
206 		emit onReinvestProfit(_customerAddress, _profits);
207 	}
208 	
209 	/**
210 	 * Withdraw profit to token exchange
211 	 */
212 	function withdrawProfit()
213 		onlyStronghands()
214 		public
215 	{
216 		address _customerAddress = msg.sender;
217 		Dealer storage _dealer = dealers_[_customerAddress];
218 		
219 		uint256 _profits = myProfit(_customerAddress);
220 		
221 		// update profits
222 		_dealer.profit = 0;		// old tokens have been reinvested
223 		_dealer.time = now;		// generate tokens from now
224 		
225 		// transfer tokens from exchange to sender
226 		tokenContract_.transfer(_customerAddress, _profits);
227 		
228 		// trigger event
229 		emit onWithdrawProfit(_customerAddress, _profits);
230 	}
231 	
232 	/**
233 	 * Withdraw deposit to token exchange. 25% fee will be incured
234 	 */
235 	function withdrawCapital()
236 		onlyBagholders()
237 		public
238 	{
239 		address _customerAddress = msg.sender;
240 		Dealer storage _dealer = dealers_[_customerAddress];
241 		
242 		uint256 _deposit = _dealer.deposit;
243 		uint256 _taxedDeposit = _deposit.mul(75).div(100);
244 		uint256 _profits = myProfit(_customerAddress);
245 		
246 		// update deposit
247 		_dealer.deposit = 0;
248 		_dealer.profit = _profits;
249 		
250 		// reduce tokens in lending deposit ledger
251 		// use the untaxed value, bcs Dealers deposit will drop to 0,
252 		// but token transfer (below) will be taxed
253 		totalDeposit_ = totalDeposit_.sub(_deposit);
254 		
255 		// transfer tokens from exchange to sender
256 		tokenContract_.transfer(_customerAddress, _taxedDeposit);
257 		
258 		// trigger event
259 		emit onWithdrawCapital(_customerAddress, _taxedDeposit);
260 	}
261 	
262 	/**
263 	 * Lending will reinvest its ETH
264 	 */
265 	function reinvestEther()
266 		public
267 	{
268 		uint256 _balance = address(this).balance;
269 		if (_balance > 0) {
270 			// triggers exchanges payable fallback buy function
271 			if(!address(tokenContract_).call.value(_balance)()) {
272 				// Some failure code
273 				revert();
274 			}
275 		}
276 	}
277 	
278 	/**
279 	 * Lending will reinvest its dividends
280 	 */
281 	function reinvestDividends()
282 		public
283 	{
284 		uint256 _dividends = myDividends(true);
285 		if (_dividends > 0) {
286 			tokenContract_.reinvest();
287 		}
288 	}
289 	
290 	
291 	/*----------  HELPERS AND CALCULATORS  ----------*/	
292     /**
293      * Retrieve the total token supply.
294      */
295     function totalDeposit()
296         public
297         view
298         returns(uint256)
299     {
300         return totalDeposit_;
301     }
302 	
303 	/**
304      * Retrieve the total token supply.
305      */
306     function totalSupply()
307         public
308         view
309         returns(uint256)
310     {
311         return tokenContract_.myTokens();
312     }
313 	
314 	function surplus()
315 		public
316 		view
317 		returns(int256)
318 	{
319 		uint256 _tokens = totalSupply();
320 		
321 		// we cannot divide by 0
322 		if (totalDeposit_ > 0) {
323 			// returns a value that indicates the surplus of the lending contract
324 			// based on 1000 => 1000 = 100%; 303 = 30.3%; -200 = -20%
325 			return int256((1000).mul(_tokens).div(totalDeposit_) - 1000);
326 		} else {
327 			return 1000;	// 100%
328 		}
329 	}
330 	
331 	/**
332      * Retrieve the tokens owned by the caller.
333      */
334     function myDeposit()
335         public
336         view
337         returns(uint256)
338     {
339 		address _customerAddress = msg.sender;
340         Dealer storage _dealer = dealers_[_customerAddress];
341         return _dealer.deposit;
342     }
343 	
344 	/**
345      * Retrieve the profit of the caller. Profits are virtual
346      */
347 	function myProfit(address _customerAddress)
348 		public
349 		view
350 		returns(uint256)
351 	{
352 		Dealer storage _dealer = dealers_[_customerAddress];
353 		uint256 _oldProfits = _dealer.profit;
354 		uint256 _newProfits = 0;
355 		
356 		if (
357 			// if time is 0, the dealer has not deposited tokens yet
358 			_dealer.time == 0 ||
359 			
360 			// dealer has currently no tokens deposited
361 			_dealer.deposit == 0
362 		)
363 		{
364 			_newProfits = 0;
365 		} else {
366 			// get the last deposit time stamp
367 			uint256 _timeLending = now - _dealer.time;
368 			
369 			_newProfits = _timeLending	// time difference since profits are being generated
370 				.mul(_dealer.deposit)	// current deposit
371 				.mul(1337)				// 1.337% (daily)
372 				.div(100000)			// to base 100%
373 				.div(86400);			// 1 day in seconds
374 		}
375 		
376 		// Dealer may have tokens in profit wallet left, so always add the old value
377 		return _newProfits.add(_oldProfits);
378 	}
379 	
380 	function myDividends(bool _includeReferralBonus)
381 		public
382 		view
383 		returns(uint256)
384 	{
385 		return tokenContract_.myDividends(_includeReferralBonus);
386 	}
387 	
388 	/**
389 	 * Set the token contract
390 	 */
391 	function setTokenContract(address _tokenContract)
392 		onlyAdministrator()
393 		public
394 	{
395 		tokenContract_ = Prosperity(_tokenContract);
396 	}
397 }
398 
399 
400 /**
401  * @title SafeMath
402  * @dev Math operations with safety checks that throw on error
403  */
404 library SafeMath {
405 
406     /**
407     * @dev Multiplies two numbers, throws on overflow.
408     */
409     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
410         if (a == 0) {
411             return 0;
412         }
413         uint256 c = a * b;
414         assert(c / a == b);
415         return c;
416     }
417 
418     /**
419     * @dev Integer division of two numbers, truncating the quotient.
420     */
421     function div(uint256 a, uint256 b) internal pure returns (uint256) {
422         // assert(b > 0); // Solidity automatically throws when dividing by 0
423         uint256 c = a / b;
424         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
425         return c;
426     }
427 
428     /**
429     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
430     */
431     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
432         assert(b <= a);
433         return a - b;
434     }
435 
436     /**
437     * @dev Adds two numbers, throws on overflow.
438     */
439     function add(uint256 a, uint256 b) internal pure returns (uint256) {
440         uint256 c = a + b;
441         assert(c >= a);
442         return c;
443     }
444 }