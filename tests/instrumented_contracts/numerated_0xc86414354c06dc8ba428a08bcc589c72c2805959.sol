1 pragma solidity ^0.4.2;
2 
3 contract owned 
4 {
5 	address public owner;
6 
7 	function owned() 
8 	{
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner 
13 	{
14 		require(msg.sender == owner);
15 		_;
16 	}
17 
18 	function transferOwnership(address newOwner) onlyOwner 
19 	{
20 		owner = newOwner;
21 	}
22 }
23 
24 contract tokenRecipient 
25 { 
26 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
27 }
28 
29 library MathFunction 
30 {
31     // standard uint256 functions
32 
33     function plus(uint256 x, uint256 y) constant internal returns (uint256 z) {
34         assert((z = x + y) >= x);
35     }
36 
37     function minus(uint256 x, uint256 y) constant internal returns (uint256 z) {
38         assert((z = x - y) <= x);
39     }
40 
41     function multiply(uint256 x, uint256 y) constant internal returns (uint256 z) {
42         z = x * y;
43         assert(x == 0 || z / x == y);
44     }
45 
46     function divide(uint256 x, uint256 y) constant internal returns (uint256 z) {
47         z = x / y;
48     }
49     
50     // uint256 function
51 
52     function hplus(uint256 x, uint256 y) constant internal returns (uint256 z) {
53         assert((z = x + y) >= x);
54     }
55 
56     function hminus(uint256 x, uint256 y) constant internal returns (uint256 z) {
57         assert((z = x - y) <= x);
58     }
59 
60     function hmultiply(uint256 x, uint256 y) constant internal returns (uint256 z) {
61         z = x * y;
62         assert(x == 0 || z / x == y);
63     }
64 
65     function hdivide(uint256 x, uint256 y) constant internal returns (uint256 z) {
66         z = x / y;
67     }
68 
69     // BIG math
70 
71     uint256 constant BIG = 10 ** 18;
72 
73     function wplus(uint256 x, uint256 y) constant internal returns (uint256) {
74         return hplus(x, y);
75     }
76 
77     function wminus(uint256 x, uint256 y) constant internal returns (uint256) {
78         return hminus(x, y);
79     }
80 
81     function wmultiply(uint256 x, uint256 y) constant internal returns (uint256 z) {
82         z = cast((uint256(x) * y + BIG / 2) / BIG);
83     }
84 
85     function wdivide(uint256 x, uint256 y) constant internal returns (uint256 z) {
86         z = cast((uint256(x) * BIG + y / 2) / y);
87     }
88 
89     function cast(uint256 x) constant internal returns (uint256 z) {
90         assert((z = uint256(x)) == x);
91     }
92 }
93 
94 contract ERC20 
95 {
96     function totalSupply() constant returns (uint _totalSupply);
97     function balanceOf(address _owner) constant returns (uint balance);
98     function transfer(address _to, uint _value) returns (bool success);
99     function transferFrom(address _from, address _to, uint _value) returns (bool success);
100     function approve(address _spender, uint _value) returns (bool success);
101     function allowance(address _owner, address _spender) constant returns (uint remaining);
102     event Transfer(address indexed _from, address indexed _to, uint _value);
103     event Approval(address indexed _owner, address indexed _spender, uint _value);
104 }
105 
106 contract token is owned, ERC20
107 {
108 	using MathFunction for uint256;
109 	
110 	// Public variables
111 	string public name;
112 	string public symbol;
113 	uint8 public decimals;
114 	uint256 public totalSupply;
115 	
116 	mapping (address => uint256) public contrubutedAmount;
117 	mapping (address => uint256) public balanceOf;													// This creates an array with all balances
118 	mapping (address => mapping (address => uint256)) public allowance;								// Creates an array with allowed amount of tokens for sender
119 	
120 	modifier onlyContributer
121 	{
122 		require(balanceOf[msg.sender] > 0);
123 		_;
124 	}
125 	
126 	// Initializes contract with name, symbol, decimal and total supply
127 	function token() 
128 	{		
129 		totalSupply = 166000;  																		// Update total supply
130 		totalSupply = totalSupply.multiply(10 ** 18);
131 		balanceOf[msg.sender] = totalSupply;              											// Give the creator all initial tokens
132 		name = "Global Academy Place";               										// Set the name for display purposes
133 		symbol = "GAP";                                											// Set the symbol for display purposes
134 		decimals = 18;                            													// Amount of decimals for display purposes
135 	}
136 	
137 	function balanceOf(address _owner) constant returns (uint256 balance) 
138 	{
139 		return balanceOf[_owner];																	// Get the balance
140 	}
141 	
142 	function totalSupply() constant returns (uint256 _totalSupply)
143 	{
144 	    return totalSupply;
145 	}
146   
147 	function transfer(address _to, uint256 _value) returns (bool success) 
148 	{
149 		require(balanceOf[msg.sender] >= _value);													// Check if the sender has enough    
150 		require(balanceOf[_to] <= balanceOf[_to].plus(_value));										// Check for overflows
151 								
152 		balanceOf[msg.sender] = balanceOf[msg.sender].minus(_value);                     			// Subtract from the sender
153 		balanceOf[_to] = balanceOf[_to].plus(_value);                            					// Add the same to the recipient
154 		
155 		Transfer(msg.sender, _to, _value);                   										// Notify anyone listening that this transfer took place
156 		return true;
157 	}
158 	
159 	// A contract attempts to get the coins
160 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success)			
161 	{
162 		require(_value <= balanceOf[_from]);														// Check if the sender has enough
163 		require(balanceOf[_to] <= balanceOf[_to].plus(_value));										// Check for overflows
164 		require(_value <= allowance[_from][msg.sender]);											// Check allowance
165   									
166 		balanceOf[_from] = balanceOf[_from].minus(_value);                          				// Subtract from the sender
167 		balanceOf[_to] = balanceOf[_to].plus(_value);                            					// Add the same to the recipient
168 		allowance[_from][msg.sender] = allowance[_from][msg.sender].minus(_value);					// Decrease the allowence of sender
169 		
170 		Transfer(_from, _to, _value);
171 		return true;
172 	}
173 
174 	// Allow another contract to spend some tokens in your behalf 
175 	function approve(address _spender, uint256 _value)	returns (bool success) 						
176 	{
177 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
178 		
179 		allowance[msg.sender][_spender] = _value;
180 		Approval(msg.sender, _spender, _value);
181 		return true;
182 	}
183 	
184 	// Approve and then communicate the approved contract in a single tx
185 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) 
186 	{    
187 		tokenRecipient spender = tokenRecipient(_spender);
188 		if (approve(_spender, _value)) 
189 		{
190 			spender.receiveApproval(msg.sender, _value, this, _extraData);
191 			return true;
192 		}
193 	}	
194 	
195 	// Function to check the amount of tokens that an owner allowed to a spender
196 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
197 	{
198 		return allowance[_owner][_spender];
199 	}
200 }
201 
202 contract ICOToken is token
203 {
204 	// Public variables
205 	string public firstLevelPrice = "Token 0.0100 ETH per Token";
206 	string public secondLevelPrice = "Token 0.0125 ETH per Token";
207 	string public thirdLevelPrice = "Token 0.0166 ETH per Token";
208 	string public CapLevelPrice = "Token 0.0250 ETH per Token";
209 	uint256 public _firstLevelEth;
210 	uint256 public _secondLevelEth;
211 	uint256 public _thirdLevelEth;
212 	uint256 public _capLevelEth;
213 	uint256 public buyPrice;
214 	uint256 public fundingGoal;
215 	uint256 public amountRaisedEth; 
216 	uint256 public deadline;
217 	uint256 public maximumBuyBackPriceInCents;
218 	uint256 public maximumBuyBackAmountInCents;
219 	uint256 public maximumBuyBackAmountInWEI;
220 	address public beneficiary;	
221 	
222 	mapping (address => uint256) public KilledTokens;												// This creates an array with all killed tokens
223 	
224 	// Private variables
225 	uint256 _currentLevelEth;
226 	uint256 _currentLevelPrice;
227 	uint256 _nextLevelEth;
228 	uint256 _nextLevelPrice;
229 	uint256 _firstLevelPrice;
230 	uint256 _secondLevelPrice;
231 	uint256 _thirdLevelPrice;
232 	uint256 _capLevelPrice;
233 	uint256 _currentSupply;
234 	uint256 remainig;
235 	uint256 amount;
236 	uint256 TokensAmount;
237 	bool fundingGoalReached;
238 	bool crowdsaleClosed;
239 
240 	event GoalReached(address _beneficiary, uint amountRaised);
241 	
242 	modifier afterDeadline() 
243 	{
244 		require(crowdsaleClosed);
245 		_;
246 	}
247 	 
248 	// Initializes contract 
249 	
250 	function ICOToken() token() 
251 	{          
252 		balanceOf[msg.sender] = totalSupply;              											// Give the creator all initial tokens
253 		
254 		beneficiary = owner;
255 		fundingGoal = 1600 ether;																	// Funding Goal in Eth
256 		deadline = 1506549600;																		// 54 720 minutes = 38 days
257 		
258 		fundingGoalReached = false;
259 		crowdsaleClosed = false;
260 												
261 		_firstLevelEth = 600 ether;										
262 		_firstLevelPrice = 10000000000000000;										
263 		_secondLevelEth = 1100 ether;										
264 		_secondLevelPrice = 12500000000000000;										
265 		_thirdLevelEth = 1600 ether;										
266 		_thirdLevelPrice = 16666666666666666;										
267 		_capLevelEth = 2501 ether;										
268 		_capLevelPrice = 25000000000000000;										
269 												
270 		_currentLevelEth = _firstLevelEth;															// In the beggining the current level is first level
271 		_currentLevelPrice = _firstLevelPrice;														// Next level is the second one 
272 		_nextLevelEth = _secondLevelEth;															
273 		_nextLevelPrice = _secondLevelPrice;										
274 		
275 		amountRaisedEth = 0;
276 		maximumBuyBackAmountInWEI = 50000000000000000;
277 	}
278 	
279 	// Changes the level price when the current one is reached
280 	// Makes the current to be next 
281 	// And next to be the following one
282 	function levelChanger() internal						
283 	{
284 		if(_nextLevelPrice == _secondLevelPrice)
285 		{
286 			_currentLevelEth = _secondLevelEth;
287 			_currentLevelPrice = _secondLevelPrice;
288 			_nextLevelEth = _thirdLevelEth;
289 			_nextLevelPrice = _thirdLevelPrice;
290 		}
291 		else if(_nextLevelPrice == _thirdLevelPrice)
292 		{
293 			_currentLevelEth = _thirdLevelEth;
294 			_currentLevelPrice = _thirdLevelPrice;
295 			_nextLevelEth = _capLevelEth;
296 			_nextLevelPrice = _capLevelPrice;
297 		}
298 		else
299 		{
300 			_currentLevelEth = _capLevelEth;
301 			_currentLevelPrice = _capLevelPrice;
302 			_nextLevelEth = _capLevelEth;
303 			_nextLevelPrice = _capLevelPrice;
304 		}
305 	}
306 	
307 	// Check if the tokens amount is bigger than total supply
308 	function safeCheck (uint256 _TokensAmount) internal
309 	{
310 		require(_TokensAmount <= totalSupply);
311 	}
312 	
313 	// Calculates the tokens amount
314 	function tokensAmount() internal returns (uint256 _tokensAmount) 			
315 	{   
316 		amountRaisedEth = amountRaisedEth.wplus(amount);
317 		uint256 raisedForNextLevel = amountRaisedEth.wminus(_currentLevelEth);
318 		remainig = amount.minus(raisedForNextLevel);
319 		TokensAmount = (raisedForNextLevel.wdivide(_nextLevelPrice)).wplus(remainig.wdivide(_currentLevelPrice));
320 		buyPrice = _nextLevelPrice;
321 		levelChanger();			
322 		
323 		return TokensAmount;
324 	}
325 	
326 	function manualBuyPrice (uint256 _NewPrice) onlyOwner
327 	{
328 		_currentLevelPrice = _NewPrice;
329 		buyPrice = _currentLevelPrice;
330 	}
331 	
332 	// The function without name is the default function that is called whenever anyone sends funds to a contract
333 	function buyTokens () payable         								
334 	{
335 		assert(!crowdsaleClosed);																	// Checks if the crowdsale is closed
336 	
337 		amount = msg.value;																			// Amount in ether
338 		assert(amountRaisedEth.plus(amount) <= _nextLevelEth);										// Check if you are going to jump over one level (e.g. from first to third - not allowed)					
339 								
340 		if(amountRaisedEth.plus(amount) > _currentLevelEth)											
341 		{								
342 			TokensAmount = tokensAmount();															// The current level is passed and calculate new buy price and change level
343 			safeCheck(TokensAmount);						
344 		}						
345 		else						
346 		{						
347 			buyPrice = _currentLevelPrice;															// Use the current level buy price
348 			TokensAmount = amount.wdivide(buyPrice);
349 			safeCheck(TokensAmount);						
350 			amountRaisedEth = amountRaisedEth.plus(amount);						
351 		}						
352 								
353 		_currentSupply = _currentSupply.plus(TokensAmount);
354 		contrubutedAmount[msg.sender] = contrubutedAmount[msg.sender].plus(msg.value);		
355 		balanceOf[this] = balanceOf[this].minus(TokensAmount);						
356 		balanceOf[msg.sender] = balanceOf[msg.sender].plus(TokensAmount);                   		// Adds tokens amount to buyer's balance
357 		Transfer(this, msg.sender, TokensAmount);                									// Execute an event reflecting the change					
358 		return;                                     	            								// Ends function and returns
359 	}						
360 	function () payable   
361 	{
362 		buyTokens();
363 	}
364 	// Checks if the goal or time limit has been reached and ends the campaign 
365 	function CloseCrowdSale(uint256 _maximumBuyBackAmountInCents) internal 								
366 	{
367 		if (amountRaisedEth >= fundingGoal)
368 		{
369 			fundingGoalReached = true;																// Checks if the funding goal is reached
370 			GoalReached(beneficiary, amountRaisedEth);
371 		}
372 		crowdsaleClosed = true;																		// Close the crowdsale
373 		maximumBuyBackPriceInCents = _maximumBuyBackAmountInCents;            						// Calculates the maximum buy back price
374 		totalSupply = _currentSupply;
375 		balanceOf[this] = 0;
376 		maximumBuyBackAmountInCents = maximumBuyBackPriceInCents.multiply(totalSupply);				// Calculates the max buy back amount in cents
377 		maximumBuyBackAmountInWEI = maximumBuyBackAmountInWEI.multiply(totalSupply);
378 	}
379 }
380 
381 contract GAP is ICOToken
382 {	
383 	// Public variables
384 	string public maximumBuyBack = "Token 0.05 ETH per Token";										// Max price in ETH for buy back
385 	uint256 public KilledTillNow;
386 	uint256 public sellPrice;
387 	uint256 public mustToSellCourses;
388 	uint public depositsTillNow;
389 	uint public actualPriceInCents;
390 	address public Killer;	
391 	
392 	event FundTransfer(address backer, uint amount, bool isContribution);
393 	
394 	function GAP() ICOToken()
395 	{
396 		Killer = 0;
397 		KilledTillNow = 0;
398 		sellPrice = 0;
399 		mustToSellCourses = 0;
400 		depositsTillNow = 0;
401 	}
402 	
403 	// The contributers can check the actual price in wei before selling 
404 	function checkActualPrice() returns (uint256 _sellPrice)
405 	{
406 		return sellPrice;
407 	}
408 				
409 	// End the crowdsale and start buying back			
410 	// Only owner can execute this function			
411 	function BuyBackStart(uint256 actualSellPriceInWei, uint256 _mustToSellCourses, uint256 maxBuyBackPriceCents) onlyOwner			
412 	{																	
413 		CloseCrowdSale(maxBuyBackPriceCents);															
414 		sellPrice = actualSellPriceInWei;
415 		mustToSellCourses = _mustToSellCourses;
416 	}			
417 	
418 	function deposit (uint _deposits, uint256 actualSellPriceInWei, uint _actualPriceInCents) onlyOwner payable												
419 	{
420 		assert(_deposits < 100);																	// Check if the deposits are less than 10	
421 		depositsTillNow = depositsTillNow.plus(_deposits);          								// Increase the deposit counter
422 		assert(mustToSellCourses > 0);
423 		if(mustToSellCourses < _deposits)
424 		{
425 			_deposits = mustToSellCourses;		
426 		}
427 		mustToSellCourses = mustToSellCourses.minus(_deposits);										// Calculate the remaining amount of courses to sell					
428 		sellPrice = actualSellPriceInWei;
429 		actualPriceInCents = _actualPriceInCents;
430 	}	
431 				
432 	function sell(uint256 amount) onlyContributer returns (uint256 revenue)			
433 	{	
434 	    require(this.balance >= amount * sellPrice);                                                 // checks if the contract has enough ether to buy
435 		revenue = amount.multiply(sellPrice);														// The revenue you receive when you sell your tokens
436 		amount = amount.multiply(10 ** 18);
437 		balanceOf[msg.sender] = balanceOf[msg.sender].minus(amount);                   				// Subtracts the amount from seller's balance
438 		balanceOf[Killer] = balanceOf[Killer].plus(amount);                         				// Adds the amount to owner's balance
439 		KilledTokens[msg.sender] = KilledTokens[msg.sender].plus(amount);							// Calculates the killed tokens of the contibuter
440 		KilledTillNow = KilledTillNow.plus(amount);													// Calculates all the killed tokens until now
441 			
442 		msg.sender.transfer(revenue);															// Sends ether to the seller: it's important // To do this last to prevent recursion attacks
443 		
444 		Transfer(msg.sender, Killer, amount);             											// Executes an event reflecting on the change
445 		return revenue;                                 											// Ends function and returns the revenue	
446 	}
447 	
448 	function ownerWithdrawal(uint256 amountInWei, address _to) onlyOwner
449 	{						
450 		uint256 _value = amountInWei;						
451 		_to.transfer(_value);						
452 	}
453 	
454 	function safeWithdrawal() afterDeadline 			
455 	{			
456 		if (!fundingGoalReached) 			
457 		{			
458 			uint256 tokensAmount = balanceOf[msg.sender];
459 			uint256 amountForReturn = contrubutedAmount[msg.sender];
460 			balanceOf[msg.sender] = 0;
461 			KilledTillNow = KilledTillNow.plus(tokensAmount);
462 			KilledTokens[msg.sender] = KilledTokens[msg.sender].plus(tokensAmount);
463 			require(tokensAmount > 0);
464 			contrubutedAmount[msg.sender] = contrubutedAmount[msg.sender].minus(amountForReturn);
465             msg.sender.transfer(amountForReturn);
466 		}
467 		
468 		if(fundingGoalReached && beneficiary == msg.sender)
469 		{
470 			require(fundingGoalReached && beneficiary == msg.sender);
471 			beneficiary.transfer(amountRaisedEth); 
472 		}
473 	}
474 }