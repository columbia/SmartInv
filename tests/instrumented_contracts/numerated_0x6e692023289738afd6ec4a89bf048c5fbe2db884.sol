1 pragma solidity ^0.4.18;
2 
3 /*
4  - Testing -
5 
6 Proof of Weak Hands  -  New Open Edition!
7  _____             _____     _ _ _ _____ 
8 |     |___ ___ ___|  _  |___| | | |  |  |
9 |  |  | . | -_|   |   __| . | | | |     |
10 |_____|  _|___|_|_|__|  |___|_____|__|__|
11       |_|              
12       
13 Proof of Weak Hands  -  New Open Edition!
14 
15 OpenPoWH was made to be a decentralized clone of PoWH with an even start for all. 
16 
17 It's simple:
18 - The first 50 transactions can only buy in for 0.1 ETH max. Anything more gets refunded. 
19 - The contract address is released roughly 7 days prior to the game starting (based on block number), alowing time for review and preparation.
20 -_Any purchases done before the start block are refunded.
21 
22 Credits:
23 
24 Based on original PoWH concept: https://test.jochen-hoenicke.de/eth/ponzitoken/
25 Original PoWHCoin Launch: PonziBot
26 EthPy Secure Rewrite and Audit: divine, tocksIck, arc
27 Limitation of Buyin Amount: tocksick
28 Delayed Public Start Time: Common Sense / https://solidity.readthedocs.io/ / The People
29 modernvillain: Shit Shadow didn't even get a mention?
30 
31 
32 */
33 
34 contract OpenPoWH {
35 
36 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
37 	// orders of magnitude, hence the need to bridge between the two.
38 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
39 
40 	// Number of first buyers that are limited
41 	uint8 constant limitedFirstBuyers = 50;    // Limit 50 buyers to 0.1
42 	uint256 constant firstBuyerLimit = 0.1 ether;
43 	
44 	// CRR = 50%
45 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
46 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
47 	int constant crr_n = 1; // CRR numerator
48 	int constant crr_d = 2; // CRR denominator
49 
50 	// The price coefficient. Chosen such that at 1 token total supply
51 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
52 	int constant price_coeff = -0x296ABF784A358468C;
53 
54 	// Typical values that we have to declare.
55 	string constant public name = "OpenPoWH";
56 	string constant public symbol = "OPoWH";
57 	uint8 constant public decimals = 18;
58 
59 	// Array between each address and their number of tokens.
60 	mapping(address => uint256) public tokenBalance;
61 		
62 	// Array between each address and how much Ether has been paid out to it.
63 	// Note that this is scaled by the scaleFactor variable.
64 	mapping(address => int256) public payouts;
65 
66 	// Variable tracking how many tokens are in existence overall.
67 	uint256 public totalSupply;
68 
69 	// Aggregate sum of all payouts.
70 	// Note that this is scaled by the scaleFactor variable.
71 	int256 totalPayouts;
72 
73 	// Variable tracking how much Ether each token is currently worth.
74 	// Note that this is scaled by the scaleFactor variable.
75 	uint256 earningsPerToken;
76 	
77 	// Current contract balance in Ether
78 	uint256 public contractBalance;
79 	
80 	// Stores first buyer countdown
81 	uint8 initialFunds;
82 
83  	// Game Start Time
84  	// Around 7 days @ 15s/block
85   	uint public gameStartBlock;
86   	uint constant gameStartBlockOffset = 4; 
87     
88 	function OpenPoWH() public {
89     	initialFunds = limitedFirstBuyers;
90     	gameStartBlock = block.number + gameStartBlockOffset; 
91     }
92 
93 	// The following functions are used by the front-end for display purposes.
94 
95 	// Returns the number of tokens currently held by _owner.
96 	function balanceOf(address _owner) public constant returns (uint256 balance) {
97 		return tokenBalance[_owner];
98 	}
99 
100 	// Withdraws all dividends held by the caller sending the transaction, updates
101 	// the requisite global variables, and transfers Ether back to the caller.
102 	function withdraw() public {
103 		// Retrieve the dividends associated with the address the request came from.
104 		var balance = dividends(msg.sender);
105 		
106 		// Update the payouts array, incrementing the request address by `balance`.
107 		payouts[msg.sender] += (int256) (balance * scaleFactor);
108 		
109 		// Increase the total amount that's been paid out to maintain invariance.
110 		totalPayouts += (int256) (balance * scaleFactor);
111 		
112 		// Send the dividends to the address that requested the withdraw.
113 		contractBalance = sub(contractBalance, balance);
114 		msg.sender.transfer(balance);
115 	}
116 
117 	// Converts the Ether accrued as dividends back into EPY tokens without having to
118 	// withdraw it first. Saves on gas and potential price spike loss.
119 	function reinvestDividends() public {
120 		// Retrieve the dividends associated with the address the request came from.
121 		var balance = dividends(msg.sender);
122 		
123 		// Update the payouts array, incrementing the request address by `balance`.
124 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
125 		payouts[msg.sender] += (int256) (balance * scaleFactor);
126 		
127 		// Increase the total amount that's been paid out to maintain invariance.
128 		totalPayouts += (int256) (balance * scaleFactor);
129 		
130 		// Assign balance to a new variable.
131 		uint value_ = (uint) (balance);
132 		
133 		// If your dividends are worth less than 1 szabo, or more than a million Ether
134 		// (in which case, why are you even here), abort.
135 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
136 			revert();
137 			
138 		// msg.sender is the address of the caller.
139 		var sender = msg.sender;
140 		
141 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
142 		// (Yes, the buyer receives a part of the distribution as well!)
143 		var res = reserve() - balance;
144 
145 		// 10% of the total Ether sent is used to pay existing holders.
146 		var fee = div(value_, 10);
147 		
148 		// The amount of Ether used to purchase new tokens for the caller.
149 		var numEther = value_ - fee;
150 		
151 		// The number of tokens which can be purchased for numEther.
152 		var numTokens = calculateDividendTokens(numEther, balance);
153 		
154 		// The buyer fee, scaled by the scaleFactor variable.
155 		var buyerFee = fee * scaleFactor;
156 		
157 		// Check that we have tokens in existence (this should always be true), or
158 		// else you're gonna have a bad time.
159 		if (totalSupply > 0) {
160 			// Compute the bonus co-efficient for all existing holders and the buyer.
161 			// The buyer receives part of the distribution for each token bought in the
162 			// same way they would have if they bought each token individually.
163 			var bonusCoEff =
164 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
165 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
166 				
167 			// The total reward to be distributed amongst the masses is the fee (in Ether)
168 			// multiplied by the bonus co-efficient.
169 			var holderReward = fee * bonusCoEff;
170 			
171 			buyerFee -= holderReward;
172 
173 			// Fee is distributed to all existing token holders before the new tokens are purchased.
174 			// rewardPerShare is the amount gained per token thanks to this buy-in.
175 			var rewardPerShare = holderReward / totalSupply;
176 			
177 			// The Ether value per token is increased proportionally.
178 			earningsPerToken += rewardPerShare;
179 		}
180 		
181 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
182 		totalSupply = add(totalSupply, numTokens);
183 		
184 		// Assign the tokens to the balance of the buyer.
185 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
186 		
187 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
188 		// Also include the fee paid for entering the scheme.
189 		// First we compute how much was just paid out to the buyer...
190 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
191 		
192 		// Then we update the payouts array for the buyer with this amount...
193 		payouts[sender] += payoutDiff;
194 		
195 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
196 		totalPayouts    += payoutDiff;
197 		
198 	}
199 
200 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
201 	// in the tokenBalance array, and therefore is shown as a dividend. A second
202 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
203 	function sellMyTokens() public {
204 		var balance = balanceOf(msg.sender);
205 		sell(balance);
206 	}
207 
208 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
209 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
210     function getMeOutOfHere() public {
211 		sellMyTokens();
212         withdraw();
213 	}
214 	
215 	// Gatekeeper function to check if the amount of Ether being sent isn't either
216 	// too small or too large. If it passes, goes direct to buy().
217 	function fund() payable public {
218   
219     require(block.number >= gameStartBlock);              // If game has not started yet, refund the money.
220     
221 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
222 		if (msg.value > 0.000001 ether) {
223 			// Limit first buyers to 0.1 ether
224 			if( initialFunds > 0 ) {
225 				initialFunds--;
226 				require( msg.value <= firstBuyerLimit );
227 			}
228 		    contractBalance = add(contractBalance, msg.value);
229 			buy();
230 		} else {
231 			revert();
232 		}
233     }
234 
235 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
236 	function buyPrice() public constant returns (uint) {
237 		return getTokensForEther(1 finney);
238 	}
239 
240 	// Function that returns the (dynamic) price of selling a single token.
241 	function sellPrice() public constant returns (uint) {
242         var eth = getEtherForTokens(1 finney);
243         var fee = div(eth, 10);
244         return eth - fee;
245     }
246 
247 	// Calculate the current dividends associated with the caller address. This is the net result
248 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
249 	// Ether that has already been paid out.
250 	function dividends(address _owner) public constant returns (uint256 amount) {
251 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
252 	}
253 
254 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
255 	// This is only used in the case when there is no transaction data, and that should be
256 	// quite rare unless interacting directly with the smart contract.
257 	function withdrawOld(address to) public {
258 		// Retrieve the dividends associated with the address the request came from.
259 		var balance = dividends(msg.sender);
260 		
261 		// Update the payouts array, incrementing the request address by `balance`.
262 		payouts[msg.sender] += (int256) (balance * scaleFactor);
263 		
264 		// Increase the total amount that's been paid out to maintain invariance.
265 		totalPayouts += (int256) (balance * scaleFactor);
266 		
267 		contractBalance = sub(contractBalance, balance);
268 		// Send the dividends to the address that requested the withdraw.
269 		to.transfer(balance);		
270 	}
271 
272 	// Internal balance function, used to calculate the dynamic reserve value.
273 	function balance() internal constant returns (uint256 amount) {
274 		// msg.value is the amount of Ether sent by the transaction.
275 		return contractBalance - msg.value;
276 	}
277 
278 	function buy() internal {
279 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
280 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
281 			revert();
282 						
283 		// msg.sender is the address of the caller.
284 		var sender = msg.sender;
285 		
286 		// 10% of the total Ether sent is used to pay existing holders.
287 		var fee = div(msg.value, 10);
288 		
289 		// The amount of Ether used to purchase new tokens for the caller.
290 		var numEther = msg.value - fee;
291 		
292 		// The number of tokens which can be purchased for numEther.
293 		var numTokens = getTokensForEther(numEther);
294 		
295 		// The buyer fee, scaled by the scaleFactor variable.
296 		var buyerFee = fee * scaleFactor;
297 		
298 		// Check that we have tokens in existence (this should always be true), or
299 		// else you're gonna have a bad time.
300 		if (totalSupply > 0) {
301 			// Compute the bonus co-efficient for all existing holders and the buyer.
302 			// The buyer receives part of the distribution for each token bought in the
303 			// same way they would have if they bought each token individually.
304 			var bonusCoEff =
305 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
306 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
307 				
308 			// The total reward to be distributed amongst the masses is the fee (in Ether)
309 			// multiplied by the bonus co-efficient.
310 			var holderReward = fee * bonusCoEff;
311 			
312 			buyerFee -= holderReward;
313 
314 			// Fee is distributed to all existing token holders before the new tokens are purchased.
315 			// rewardPerShare is the amount gained per token thanks to this buy-in.
316 			var rewardPerShare = holderReward / totalSupply;
317 			
318 			// The Ether value per token is increased proportionally.
319 			earningsPerToken += rewardPerShare;
320 			
321 		}
322 
323 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
324 		totalSupply = add(totalSupply, numTokens);
325 
326 		// Assign the tokens to the balance of the buyer.
327 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
328 
329 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
330 		// Also include the fee paid for entering the scheme.
331 		// First we compute how much was just paid out to the buyer...
332 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
333 		
334 		// Then we update the payouts array for the buyer with this amount...
335 		payouts[sender] += payoutDiff;
336 		
337 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
338 		totalPayouts    += payoutDiff;
339 		
340 	}
341 
342 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
343 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
344 	// will be *significant*.
345 	function sell(uint256 amount) internal {
346 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
347 		var numEthersBeforeFee = getEtherForTokens(amount);
348 		
349 		// 10% of the resulting Ether is used to pay remaining holders.
350         var fee = div(numEthersBeforeFee, 10);
351 		
352 		// Net Ether for the seller after the fee has been subtracted.
353         var numEthers = numEthersBeforeFee - fee;
354 		
355 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
356 		totalSupply = sub(totalSupply, amount);
357 		
358         // Remove the tokens from the balance of the buyer.
359 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
360 
361         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
362 		// First we compute how much was just paid out to the seller...
363 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
364 		
365         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
366 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
367 		// they decide to buy back in.
368 		payouts[msg.sender] -= payoutDiff;		
369 		
370 		// Decrease the total amount that's been paid out to maintain invariance.
371         totalPayouts -= payoutDiff;
372 		
373 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
374 		// selling tokens, but it guards against division by zero).
375 		if (totalSupply > 0) {
376 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
377 			var etherFee = fee * scaleFactor;
378 			
379 			// Fee is distributed to all remaining token holders.
380 			// rewardPerShare is the amount gained per token thanks to this sell.
381 			var rewardPerShare = etherFee / totalSupply;
382 			
383 			// The Ether value per token is increased proportionally.
384 			earningsPerToken = add(earningsPerToken, rewardPerShare);
385 		}
386 	}
387 	
388 	// Dynamic value of Ether in reserve, according to the CRR requirement.
389 	function reserve() internal constant returns (uint256 amount) {
390 		return sub(balance(),
391 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
392 	}
393 
394 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
395 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
396 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
397 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
398 	}
399 
400 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
401 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
402 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
403 	}
404 
405 	// Converts a number tokens into an Ether value.
406 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
407 		// How much reserve Ether do we have left in the contract?
408 		var reserveAmount = reserve();
409 
410 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
411 		if (tokens == totalSupply)
412 			return reserveAmount;
413 
414 		// If there would be excess Ether left after the transaction this is called within, return the Ether
415 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
416 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
417 		// and denominator altered to 1 and 2 respectively.
418 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
419 	}
420 
421 	// You don't care about these, but if you really do they're hex values for 
422 	// co-efficients used to simulate approximations of the log and exp functions.
423 	int256  constant one        = 0x10000000000000000;
424 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
425 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
426 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
427 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
428 	int256  constant c1         = 0x1ffffffffff9dac9b;
429 	int256  constant c3         = 0x0aaaaaaac16877908;
430 	int256  constant c5         = 0x0666664e5e9fa0c99;
431 	int256  constant c7         = 0x049254026a7630acf;
432 	int256  constant c9         = 0x038bd75ed37753d68;
433 	int256  constant c11        = 0x03284a0c14610924f;
434 
435 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
436 	// approximates the function log(1+x)-log(1-x)
437 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
438 	function fixedLog(uint256 a) internal pure returns (int256 log) {
439 		int32 scale = 0;
440 		while (a > sqrt2) {
441 			a /= 2;
442 			scale++;
443 		}
444 		while (a <= sqrtdot5) {
445 			a *= 2;
446 			scale--;
447 		}
448 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
449 		var z = (s*s) / one;
450 		return scale * ln2 +
451 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
452 				/one))/one))/one))/one))/one);
453 	}
454 
455 	int256 constant c2 =  0x02aaaaaaaaa015db0;
456 	int256 constant c4 = -0x000b60b60808399d1;
457 	int256 constant c6 =  0x0000455956bccdd06;
458 	int256 constant c8 = -0x000001b893ad04b3a;
459 	
460 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
461 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
462 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
463 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
464 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
465 		a -= scale*ln2;
466 		int256 z = (a*a) / one;
467 		int256 R = ((int256)(2) * one) +
468 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
469 		exp = (uint256) (((R + a) * one) / (R - a));
470 		if (scale >= 0)
471 			exp <<= scale;
472 		else
473 			exp >>= -scale;
474 		return exp;
475 	}
476 	
477 	// The below are safemath implementations of the four arithmetic operators
478 	// designed to explicitly prevent over- and under-flows of integer values.
479 
480 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
481 		if (a == 0) {
482 			return 0;
483 		}
484 		uint256 c = a * b;
485 		assert(c / a == b);
486 		return c;
487 	}
488 
489 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
490 		// assert(b > 0); // Solidity automatically throws when dividing by 0
491 		uint256 c = a / b;
492 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
493 		return c;
494 	}
495 
496 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
497 		assert(b <= a);
498 		return a - b;
499 	}
500 
501 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
502 		uint256 c = a + b;
503 		assert(c >= a);
504 		return c;
505 	}
506 
507 	// This allows you to buy tokens by sending Ether directly to the smart contract
508 	// without including any transaction data (useful for, say, mobile wallet apps).
509 	function () payable public {
510 		// msg.value is the amount of Ether sent by the transaction.
511 		if (msg.value > 0) {
512 			fund();
513 		} else {
514 			withdrawOld(msg.sender);
515 		}
516 	}
517 }