1 pragma solidity ^0.4.18;
2 
3 /*                             ____
4                      __,-~~/~    `---.
5                    _/_,---(      ,    )
6                __ /        <    /   )  \___
7 - ------===;;;'====------------------===;;;===----- -  -
8                   \/  ~"~"~"~"~"~\~"~)~"/
9                   (_ (   \  (     >    \)
10                    \_( _ <         >_>'
11                       ~ `-i' ::>|--"
12                           I;|.|.|
13                          <|i::|i|`.
14                         (` ^'"`-' ")
15                         
16                      [HyperPonzi-v0.99]
17     Because all good plans involve rapid exponential growth.
18     
19 ---------------------------------------------------------------------------
20  
21  - Be careful with this contract!!!
22  
23      - CRR = 0.05
24         - This is MUCH faster expansion than Ethpy (0.5)!
25      - 10% buy fee, 50% sell fee
26         - Huge sell fee balances extreme CRR
27         - If early investors exit they pay out MASSIVE dividends
28      - 10 txn x 0.001 ETH limit start
29         - Fair start before exponential nuke goes off
30  
31  - Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
32  - Based on EthPyramid:
33          Developers:
34         	Arc
35         	Divine
36         	Norsefire
37         	ToCsIcK
38         	
39          Front-End:
40         	Cardioth
41         	tenmei
42         	Trendium
43         	
44          Moral Support:
45         	DeadCow.Rat
46         	Dots
47         	FatKreamy
48         	Kaseylol
49         	QuantumDeath666
50         	Quentin
51          
52          Shit-Tier:
53         	HentaiChrist
54 */
55 
56 contract HyperPonzi{
57 
58 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
59 	// orders of magnitude, hence the need to bridge between the two.
60 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
61 
62 	// Number of first buyers that are limited 
63 	uint16 constant limitedFirstBuyers = 10;
64 	uint256 constant firstBuyerLimit = 0.001 ether;
65 	
66 	// CRR = 5%
67 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
68 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
69 	int constant crr_n = 5; // CRR numerator
70 	int constant crr_d = 100; // CRR denominator
71 
72 	// The price coefficient. Chosen such that at 1 token total supply
73 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
74 	int constant price_coeff = -0x296ABF784A358468C;
75 
76 	// Typical values that we have to declare.
77 	string constant public name = "HyperPonzi";
78 	string constant public symbol = "HYPE";
79 	uint8 constant public decimals = 18;
80 
81 	// Array between each address and their number of tokens.
82 	mapping(address => uint256) public tokenBalance;
83 		
84 	// Array between each address and how much Ether has been paid out to it.
85 	// Note that this is scaled by the scaleFactor variable.
86 	mapping(address => int256) public payouts;
87 
88 	// Variable tracking how many tokens are in existence overall.
89 	uint256 public totalSupply;
90 
91 	// Aggregate sum of all payouts.
92 	// Note that this is scaled by the scaleFactor variable.
93 	int256 totalPayouts;
94 
95 	// Variable tracking how much Ether each token is currently worth.
96 	// Note that this is scaled by the scaleFactor variable.
97 	uint256 earningsPerToken;
98 	
99 	// Current contract balance in Ether
100 	uint256 public contractBalance;
101 	
102 	// Stores first buyer countdown
103 	uint16 initialFunds;
104 
105 	function HyperPonzi() public {
106 		initialFunds = limitedFirstBuyers;
107 	}
108 
109 	// The following functions are used by the front-end for display purposes.
110 
111 	// Returns the number of tokens currently held by _owner.
112 	function balanceOf(address _owner) public constant returns (uint256 balance) {
113 		return tokenBalance[_owner];
114 	}
115 
116 	// Withdraws all dividends held by the caller sending the transaction, updates
117 	// the requisite global variables, and transfers Ether back to the caller.
118 	function withdraw() public {
119 		// Retrieve the dividends associated with the address the request came from.
120 		var balance = dividends(msg.sender);
121 		
122 		// Update the payouts array, incrementing the request address by `balance`.
123 		payouts[msg.sender] += (int256) (balance * scaleFactor);
124 		
125 		// Increase the total amount that's been paid out to maintain invariance.
126 		totalPayouts += (int256) (balance * scaleFactor);
127 		
128 		// Send the dividends to the address that requested the withdraw.
129 		contractBalance = sub(contractBalance, balance);
130 		msg.sender.transfer(balance);
131 	}
132 
133 	// Converts the Ether accrued as dividends back into EPY tokens without having to
134 	// withdraw it first. Saves on gas and potential price spike loss.
135 	function reinvestDividends() public {
136 		// Retrieve the dividends associated with the address the request came from.
137 		var balance = dividends(msg.sender);
138 		
139 		// Update the payouts array, incrementing the request address by `balance`.
140 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
141 		payouts[msg.sender] += (int256) (balance * scaleFactor);
142 		
143 		// Increase the total amount that's been paid out to maintain invariance.
144 		totalPayouts += (int256) (balance * scaleFactor);
145 		
146 		// Assign balance to a new variable.
147 		uint value_ = (uint) (balance);
148 		
149 		// If your dividends are worth less than 1 szabo, or more than a million Ether
150 		// (in which case, why are you even here), abort.
151 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
152 			revert();
153 			
154 		// msg.sender is the address of the caller.
155 		var sender = msg.sender;
156 		
157 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
158 		// (Yes, the buyer receives a part of the distribution as well!)
159 		var res = reserve() - balance;
160 
161 		// 10% buy fee
162 		var fee = div(value_, 10);
163 		
164 		// The amount of Ether used to purchase new tokens for the caller.
165 		var numEther = value_ - fee;
166 		
167 		// The number of tokens which can be purchased for numEther.
168 		var numTokens = calculateDividendTokens(numEther, balance);
169 		
170 		// The buyer fee, scaled by the scaleFactor variable.
171 		var buyerFee = fee * scaleFactor;
172 		
173 		// Check that we have tokens in existence (this should always be true), or
174 		// else you're gonna have a bad time.
175 		if (totalSupply > 0) {
176 			// Compute the bonus co-efficient for all existing holders and the buyer.
177 			// The buyer receives part of the distribution for each token bought in the
178 			// same way they would have if they bought each token individually.
179 			var bonusCoEff =
180 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
181 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
182 				
183 			// The total reward to be distributed amongst the masses is the fee (in Ether)
184 			// multiplied by the bonus co-efficient.
185 			var holderReward = fee * bonusCoEff;
186 			
187 			buyerFee -= holderReward;
188 
189 			// Fee is distributed to all existing token holders before the new tokens are purchased.
190 			// rewardPerShare is the amount gained per token thanks to this buy-in.
191 			var rewardPerShare = holderReward / totalSupply;
192 			
193 			// The Ether value per token is increased proportionally.
194 			earningsPerToken += rewardPerShare;
195 		}
196 		
197 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
198 		totalSupply = add(totalSupply, numTokens);
199 		
200 		// Assign the tokens to the balance of the buyer.
201 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
202 		
203 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
204 		// Also include the fee paid for entering the scheme.
205 		// First we compute how much was just paid out to the buyer...
206 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
207 		
208 		// Then we update the payouts array for the buyer with this amount...
209 		payouts[sender] += payoutDiff;
210 		
211 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
212 		totalPayouts    += payoutDiff;
213 		
214 	}
215 
216 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
217 	// in the tokenBalance array, and therefore is shown as a dividend. A second
218 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
219 	function sellMyTokens() public {
220 		var balance = balanceOf(msg.sender);
221 		sell(balance);
222 	}
223 
224 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
225 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
226     function getMeOutOfHere() public {
227 		sellMyTokens();
228         withdraw();
229 	}
230 	
231 	// Gatekeeper function to check if the amount of Ether being sent isn't either
232 	// too small or too large. If it passes, goes direct to buy().
233 	function fund() payable public {
234 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
235 		if (msg.value > 0.000001 ether) {
236 			// Limit first buyers to 0.1 ether
237 			if( initialFunds > 0 ) {
238 				initialFunds--;
239 				require( msg.value <= firstBuyerLimit );
240 			}
241 		    contractBalance = add(contractBalance, msg.value);
242 			buy();
243 		} else {
244 			revert();
245 		}
246     }
247 
248 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
249 	function buyPrice() public constant returns (uint) {
250 		return getTokensForEther(1 finney);
251 	}
252 
253 	// Function that returns the (dynamic) price of selling a single token.
254 	function sellPrice() public constant returns (uint) {
255         var eth = getEtherForTokens(1 finney);
256         var fee = div(eth, 2);
257         return eth - fee;
258     }
259 
260 	// Calculate the current dividends associated with the caller address. This is the net result
261 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
262 	// Ether that has already been paid out.
263 	function dividends(address _owner) public constant returns (uint256 amount) {
264 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
265 	}
266 
267 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
268 	// This is only used in the case when there is no transaction data, and that should be
269 	// quite rare unless interacting directly with the smart contract.
270 	function withdrawOld(address to) public {
271 		// Retrieve the dividends associated with the address the request came from.
272 		var balance = dividends(msg.sender);
273 		
274 		// Update the payouts array, incrementing the request address by `balance`.
275 		payouts[msg.sender] += (int256) (balance * scaleFactor);
276 		
277 		// Increase the total amount that's been paid out to maintain invariance.
278 		totalPayouts += (int256) (balance * scaleFactor);
279 		
280 		contractBalance = sub(contractBalance, balance);
281 		// Send the dividends to the address that requested the withdraw.
282 		to.transfer(balance);		
283 	}
284 
285 	// Internal balance function, used to calculate the dynamic reserve value.
286 	function balance() internal constant returns (uint256 amount) {
287 		// msg.value is the amount of Ether sent by the transaction.
288 		return contractBalance - msg.value;
289 	}
290 
291 	function buy() internal {
292 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
293 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
294 			revert();
295 						
296 		// msg.sender is the address of the caller.
297 		var sender = msg.sender;
298 		
299 		// 10% buy fee
300 		var fee = div(msg.value, 10);
301 		
302 		// The amount of Ether used to purchase new tokens for the caller.
303 		var numEther = msg.value - fee;
304 		
305 		// The number of tokens which can be purchased for numEther.
306 		var numTokens = getTokensForEther(numEther);
307 		
308 		// The buyer fee, scaled by the scaleFactor variable.
309 		var buyerFee = fee * scaleFactor;
310 		
311 		// Check that we have tokens in existence (this should always be true), or
312 		// else you're gonna have a bad time.
313 		if (totalSupply > 0) {
314 			// Compute the bonus co-efficient for all existing holders and the buyer.
315 			// The buyer receives part of the distribution for each token bought in the
316 			// same way they would have if they bought each token individually.
317 			var bonusCoEff =
318 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
319 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
320 				
321 			// The total reward to be distributed amongst the masses is the fee (in Ether)
322 			// multiplied by the bonus co-efficient.
323 			var holderReward = fee * bonusCoEff;
324 			
325 			buyerFee -= holderReward;
326 
327 			// Fee is distributed to all existing token holders before the new tokens are purchased.
328 			// rewardPerShare is the amount gained per token thanks to this buy-in.
329 			var rewardPerShare = holderReward / totalSupply;
330 			
331 			// The Ether value per token is increased proportionally.
332 			earningsPerToken += rewardPerShare;
333 			
334 		}
335 
336 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
337 		totalSupply = add(totalSupply, numTokens);
338 
339 		// Assign the tokens to the balance of the buyer.
340 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
341 
342 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
343 		// Also include the fee paid for entering the scheme.
344 		// First we compute how much was just paid out to the buyer...
345 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
346 		
347 		// Then we update the payouts array for the buyer with this amount...
348 		payouts[sender] += payoutDiff;
349 		
350 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
351 		totalPayouts    += payoutDiff;
352 		
353 	}
354 
355 	// Sell function that takes tokens and converts them into Ether. Also comes with a 5% fee
356 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
357 	// will be *significant*.
358 	function sell(uint256 amount) internal {
359 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
360 		var numEthersBeforeFee = getEtherForTokens(amount);
361 		
362 		// 50% of the resulting Ether is used to pay remaining holders.
363         var fee = div(numEthersBeforeFee, 2);
364 		
365 		// Net Ether for the seller after the fee has been subtracted.
366         var numEthers = numEthersBeforeFee - fee;
367 		
368 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
369 		totalSupply = sub(totalSupply, amount);
370 		
371         // Remove the tokens from the balance of the buyer.
372 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
373 
374         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
375 		// First we compute how much was just paid out to the seller...
376 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
377 		
378         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
379 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
380 		// they decide to buy back in.
381 		payouts[msg.sender] -= payoutDiff;		
382 		
383 		// Decrease the total amount that's been paid out to maintain invariance.
384         totalPayouts -= payoutDiff;
385 		
386 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
387 		// selling tokens, but it guards against division by zero).
388 		if (totalSupply > 0) {
389 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
390 			var etherFee = fee * scaleFactor;
391 			
392 			// Fee is distributed to all remaining token holders.
393 			// rewardPerShare is the amount gained per token thanks to this sell.
394 			var rewardPerShare = etherFee / totalSupply;
395 			
396 			// The Ether value per token is increased proportionally.
397 			earningsPerToken = add(earningsPerToken, rewardPerShare);
398 		}
399 	}
400 	
401 	// Dynamic value of Ether in reserve, according to the CRR requirement.
402 	function reserve() internal constant returns (uint256 amount) {
403 		return sub(balance(),
404 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
405 	}
406 
407 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
408 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
409 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
410 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
411 	}
412 
413 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
414 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
415 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
416 	}
417 
418 	// Converts a number tokens into an Ether value.
419 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
420 		// How much reserve Ether do we have left in the contract?
421 		var reserveAmount = reserve();
422 
423 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
424 		if (tokens == totalSupply)
425 			return reserveAmount;
426 
427 		// If there would be excess Ether left after the transaction this is called within, return the Ether
428 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
429 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
430 		// and denominator altered to 1 and 2 respectively.
431 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
432 	}
433 
434 	// You don't care about these, but if you really do they're hex values for 
435 	// co-efficients used to simulate approximations of the log and exp functions.
436 	int256  constant one        = 0x10000000000000000;
437 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
438 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
439 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
440 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
441 	int256  constant c1         = 0x1ffffffffff9dac9b;
442 	int256  constant c3         = 0x0aaaaaaac16877908;
443 	int256  constant c5         = 0x0666664e5e9fa0c99;
444 	int256  constant c7         = 0x049254026a7630acf;
445 	int256  constant c9         = 0x038bd75ed37753d68;
446 	int256  constant c11        = 0x03284a0c14610924f;
447 
448 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
449 	// approximates the function log(1+x)-log(1-x)
450 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
451 	function fixedLog(uint256 a) internal pure returns (int256 log) {
452 		int32 scale = 0;
453 		while (a > sqrt2) {
454 			a /= 2;
455 			scale++;
456 		}
457 		while (a <= sqrtdot5) {
458 			a *= 2;
459 			scale--;
460 		}
461 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
462 		var z = (s*s) / one;
463 		return scale * ln2 +
464 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
465 				/one))/one))/one))/one))/one);
466 	}
467 
468 	int256 constant c2 =  0x02aaaaaaaaa015db0;
469 	int256 constant c4 = -0x000b60b60808399d1;
470 	int256 constant c6 =  0x0000455956bccdd06;
471 	int256 constant c8 = -0x000001b893ad04b3a;
472 	
473 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
474 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
475 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
476 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
477 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
478 		a -= scale*ln2;
479 		int256 z = (a*a) / one;
480 		int256 R = ((int256)(2) * one) +
481 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
482 		exp = (uint256) (((R + a) * one) / (R - a));
483 		if (scale >= 0)
484 			exp <<= scale;
485 		else
486 			exp >>= -scale;
487 		return exp;
488 	}
489 	
490 	// The below are safemath implementations of the four arithmetic operators
491 	// designed to explicitly prevent over- and under-flows of integer values.
492 
493 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
494 		if (a == 0) {
495 			return 0;
496 		}
497 		uint256 c = a * b;
498 		assert(c / a == b);
499 		return c;
500 	}
501 
502 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
503 		// assert(b > 0); // Solidity automatically throws when dividing by 0
504 		uint256 c = a / b;
505 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
506 		return c;
507 	}
508 
509 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
510 		assert(b <= a);
511 		return a - b;
512 	}
513 
514 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
515 		uint256 c = a + b;
516 		assert(c >= a);
517 		return c;
518 	}
519 
520 	// This allows you to buy tokens by sending Ether directly to the smart contract
521 	// without including any transaction data (useful for, say, mobile wallet apps).
522 	function () payable public {
523 		// msg.value is the amount of Ether sent by the transaction.
524 		if (msg.value > 0) {
525 			fund();
526 		} else {
527 			withdrawOld(msg.sender);
528 		}
529 	}
530 }