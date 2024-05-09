1 pragma solidity ^0.4.18;
2 
3 /*
4           ,/`.
5         ,'/ __`.
6       ,'_/_  _ _`.
7     ,'__/_ ___ _  `.
8   ,'_  /___ __ _ __ `.
9  '-.._/___...-"-.-..__`.
10   B
11 
12  EthPyramid v2.0 A no-bullshit, transparent, self-sustaining pyramid scheme.
13  - https://ethpyramid2.com/
14  
15  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
16 
17  Developers:
18 	Arc
19 	Divine
20 	Norsefire
21 	ToCsIcK
22 	
23  Front-End:
24 	Cardioth
25 	tenmei
26 	Trendium
27 	
28  Moral Support:
29 	DeadCow.Rat
30 	Dots
31 	FatKreamy
32 	Kaseylol
33 	QuantumDeath666
34 	Quentin
35  
36  Shit-Tier:
37 	HentaiChrist
38  
39 */
40 
41 contract EthPyramid2 {
42 
43 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
44 	// orders of magnitude, hence the need to bridge between the two.
45 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
46 
47 	// CRR = 50%
48 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
49 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
50 	int constant crr_n = 1; // CRR numerator
51 	int constant crr_d = 2; // CRR denominator
52 
53 	// The price coefficient. Chosen such that at 1 token total supply
54 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
55 	int constant price_coeff = -0x296ABF784A358468C;
56 
57 	// Typical values that we have to declare.
58 	string constant public name = "EthPyramid2";
59 	string constant public symbol = "EPY";
60 	uint8 constant public decimals = 18;
61 
62 	// Array between each address and their number of tokens.
63 	mapping(address => uint256) public tokenBalance;
64 		
65 	// Array between each address and how much Ether has been paid out to it.
66 	// Note that this is scaled by the scaleFactor variable.
67 	mapping(address => int256) public payouts;
68 
69 	// Variable tracking how many tokens are in existence overall.
70 	uint256 public totalSupply;
71 
72 	// Aggregate sum of all payouts.
73 	// Note that this is scaled by the scaleFactor variable.
74 	int256 totalPayouts;
75 
76 	// Variable tracking how much Ether each token is currently worth.
77 	// Note that this is scaled by the scaleFactor variable.
78 	uint256 earningsPerToken;
79 	
80 	// Current contract balance in Ether
81 	uint256 public contractBalance;
82 
83 	function EthPyramid2() public {}
84 
85 	// The following functions are used by the front-end for display purposes.
86 
87 	// Returns the number of tokens currently held by _owner.
88 	function balanceOf(address _owner) public constant returns (uint256 balance) {
89 		return tokenBalance[_owner];
90 	}
91 
92 	// Withdraws all dividends held by the caller sending the transaction, updates
93 	// the requisite global variables, and transfers Ether back to the caller.
94 	function withdraw() public {
95 		// Retrieve the dividends associated with the address the request came from.
96 		var balance = dividends(msg.sender);
97 		
98 		// Update the payouts array, incrementing the request address by `balance`.
99 		payouts[msg.sender] += (int256) (balance * scaleFactor);
100 		
101 		// Increase the total amount that's been paid out to maintain invariance.
102 		totalPayouts += (int256) (balance * scaleFactor);
103 		
104 		// Send the dividends to the address that requested the withdraw.
105 		contractBalance = sub(contractBalance, balance);
106 		msg.sender.transfer(balance);
107 	}
108 
109 	// Converts the Ether accrued as dividends back into EPY tokens without having to
110 	// withdraw it first. Saves on gas and potential price spike loss.
111 	function reinvestDividends() public {
112 		// Retrieve the dividends associated with the address the request came from.
113 		var balance = dividends(msg.sender);
114 		
115 		// Update the payouts array, incrementing the request address by `balance`.
116 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
117 		payouts[msg.sender] += (int256) (balance * scaleFactor);
118 		
119 		// Increase the total amount that's been paid out to maintain invariance.
120 		totalPayouts += (int256) (balance * scaleFactor);
121 		
122 		// Assign balance to a new variable.
123 		uint value_ = (uint) (balance);
124 		
125 		// If your dividends are worth less than 1 szabo, or more than a million Ether
126 		// (in which case, why are you even here), abort.
127 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
128 			revert();
129 			
130 		// msg.sender is the address of the caller.
131 		var sender = msg.sender;
132 		
133 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
134 		// (Yes, the buyer receives a part of the distribution as well!)
135 		var res = reserve() - balance;
136 
137 		// 10% of the total Ether sent is used to pay existing holders.
138 		var fee = div(value_, 10);
139 		
140 		// The amount of Ether used to purchase new tokens for the caller.
141 		var numEther = value_ - fee;
142 		
143 		// The number of tokens which can be purchased for numEther.
144 		var numTokens = calculateDividendTokens(numEther, balance);
145 		
146 		// The buyer fee, scaled by the scaleFactor variable.
147 		var buyerFee = fee * scaleFactor;
148 		
149 		// Check that we have tokens in existence (this should always be true), or
150 		// else you're gonna have a bad time.
151 		if (totalSupply > 0) {
152 			// Compute the bonus co-efficient for all existing holders and the buyer.
153 			// The buyer receives part of the distribution for each token bought in the
154 			// same way they would have if they bought each token individually.
155 			var bonusCoEff =
156 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
157 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
158 				
159 			// The total reward to be distributed amongst the masses is the fee (in Ether)
160 			// multiplied by the bonus co-efficient.
161 			var holderReward = fee * bonusCoEff;
162 			
163 			buyerFee -= holderReward;
164 
165 			// Fee is distributed to all existing token holders before the new tokens are purchased.
166 			// rewardPerShare is the amount gained per token thanks to this buy-in.
167 			var rewardPerShare = holderReward / totalSupply;
168 			
169 			// The Ether value per token is increased proportionally.
170 			earningsPerToken += rewardPerShare;
171 		}
172 		
173 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
174 		totalSupply = add(totalSupply, numTokens);
175 		
176 		// Assign the tokens to the balance of the buyer.
177 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
178 		
179 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
180 		// Also include the fee paid for entering the scheme.
181 		// First we compute how much was just paid out to the buyer...
182 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
183 		
184 		// Then we update the payouts array for the buyer with this amount...
185 		payouts[sender] += payoutDiff;
186 		
187 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
188 		totalPayouts    += payoutDiff;
189 		
190 	}
191 
192 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
193 	// in the tokenBalance array, and therefore is shown as a dividend. A second
194 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
195 	function sellMyTokens() public {
196 		var balance = balanceOf(msg.sender);
197 		sell(balance);
198 	}
199 
200 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
201 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
202     function getMeOutOfHere() public {
203 		sellMyTokens();
204         withdraw();
205 	}
206 
207 	// Gatekeeper function to check if the amount of Ether being sent isn't either
208 	// too small or too large. If it passes, goes direct to buy().
209 	function fund() payable public {
210 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
211 		if (msg.value > 0.000001 ether) {
212 		    contractBalance = add(contractBalance, msg.value);
213 			buy();
214 		} else {
215 			revert();
216 		}
217     }
218 
219 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
220 	function buyPrice() public constant returns (uint) {
221 		return getTokensForEther(1 finney);
222 	}
223 
224 	// Function that returns the (dynamic) price of selling a single token.
225 	function sellPrice() public constant returns (uint) {
226         var eth = getEtherForTokens(1 finney);
227         var fee = div(eth, 10);
228         return eth - fee;
229     }
230 
231 	// Calculate the current dividends associated with the caller address. This is the net result
232 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
233 	// Ether that has already been paid out.
234 	function dividends(address _owner) public constant returns (uint256 amount) {
235 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
236 	}
237 
238 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
239 	// This is only used in the case when there is no transaction data, and that should be
240 	// quite rare unless interacting directly with the smart contract.
241 	function withdrawOld(address to) public {
242 		// Retrieve the dividends associated with the address the request came from.
243 		var balance = dividends(msg.sender);
244 		
245 		// Update the payouts array, incrementing the request address by `balance`.
246 		payouts[msg.sender] += (int256) (balance * scaleFactor);
247 		
248 		// Increase the total amount that's been paid out to maintain invariance.
249 		totalPayouts += (int256) (balance * scaleFactor);
250 		
251 		// Send the dividends to the address that requested the withdraw.
252 		contractBalance = sub(contractBalance, balance);
253 		to.transfer(balance);		
254 	}
255 
256 	// Internal balance function, used to calculate the dynamic reserve value.
257 	function balance() internal constant returns (uint256 amount) {
258 		// msg.value is the amount of Ether sent by the transaction.
259 		return contractBalance - msg.value;
260 	}
261 
262 	function buy() internal {
263 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
264 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
265 			revert();
266 						
267 		// msg.sender is the address of the caller.
268 		var sender = msg.sender;
269 		
270 		// 10% of the total Ether sent is used to pay existing holders.
271 		var fee = div(msg.value, 10);
272 		
273 		// The amount of Ether used to purchase new tokens for the caller.
274 		var numEther = msg.value - fee;
275 		
276 		// The number of tokens which can be purchased for numEther.
277 		var numTokens = getTokensForEther(numEther);
278 		
279 		// The buyer fee, scaled by the scaleFactor variable.
280 		var buyerFee = fee * scaleFactor;
281 		
282 		// Check that we have tokens in existence (this should always be true), or
283 		// else you're gonna have a bad time.
284 		if (totalSupply > 0) {
285 			// Compute the bonus co-efficient for all existing holders and the buyer.
286 			// The buyer receives part of the distribution for each token bought in the
287 			// same way they would have if they bought each token individually.
288 			var bonusCoEff =
289 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
290 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
291 				
292 			// The total reward to be distributed amongst the masses is the fee (in Ether)
293 			// multiplied by the bonus co-efficient.
294 			var holderReward = fee * bonusCoEff;
295 			
296 			buyerFee -= holderReward;
297 
298 			// Fee is distributed to all existing token holders before the new tokens are purchased.
299 			// rewardPerShare is the amount gained per token thanks to this buy-in.
300 			var rewardPerShare = holderReward / totalSupply;
301 			
302 			// The Ether value per token is increased proportionally.
303 			earningsPerToken += rewardPerShare;
304 			
305 		}
306 
307 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
308 		totalSupply = add(totalSupply, numTokens);
309 
310 		// Assign the tokens to the balance of the buyer.
311 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
312 
313 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
314 		// Also include the fee paid for entering the scheme.
315 		// First we compute how much was just paid out to the buyer...
316 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
317 		
318 		// Then we update the payouts array for the buyer with this amount...
319 		payouts[sender] += payoutDiff;
320 		
321 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
322 		totalPayouts    += payoutDiff;
323 		
324 	}
325 
326 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
327 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
328 	// will be *significant*.
329 	function sell(uint256 amount) internal {
330 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
331 		var numEthersBeforeFee = getEtherForTokens(amount);
332 		
333 		// 10% of the resulting Ether is used to pay remaining holders.
334         var fee = div(numEthersBeforeFee, 10);
335 		
336 		// Net Ether for the seller after the fee has been subtracted.
337         var numEthers = numEthersBeforeFee - fee;
338 		
339 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
340 		totalSupply = sub(totalSupply, amount);
341 		
342         // Remove the tokens from the balance of the buyer.
343 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
344 
345         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
346 		// First we compute how much was just paid out to the seller...
347 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
348 		
349         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
350 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
351 		// they decide to buy back in.
352 		payouts[msg.sender] -= payoutDiff;		
353 		
354 		// Decrease the total amount that's been paid out to maintain invariance.
355         totalPayouts -= payoutDiff;
356 		
357 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
358 		// selling tokens, but it guards against division by zero).
359 		if (totalSupply > 0) {
360 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
361 			var etherFee = fee * scaleFactor;
362 			
363 			// Fee is distributed to all remaining token holders.
364 			// rewardPerShare is the amount gained per token thanks to this sell.
365 			var rewardPerShare = etherFee / totalSupply;
366 			
367 			// The Ether value per token is increased proportionally.
368 			earningsPerToken = add(earningsPerToken, rewardPerShare);
369 		}
370 	}
371 	
372 	// Dynamic value of Ether in reserve, according to the CRR requirement.
373 	function reserve() internal constant returns (uint256 amount) {
374 		return sub(balance(),
375 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
376 	}
377 
378 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
379 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
380 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
381 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
382 	}
383 
384 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
385 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
386 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
387 	}
388 
389 	// Converts a number tokens into an Ether value.
390 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
391 		// How much reserve Ether do we have left in the contract?
392 		var reserveAmount = reserve();
393 
394 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
395 		if (tokens == totalSupply)
396 			return reserveAmount;
397 
398 		// If there would be excess Ether left after the transaction this is called within, return the Ether
399 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
400 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
401 		// and denominator altered to 1 and 2 respectively.
402 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
403 	}
404 
405 	// You don't care about these, but if you really do they're hex values for 
406 	// co-efficients used to simulate approximations of the log and exp functions.
407 	int256  constant one        = 0x10000000000000000;
408 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
409 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
410 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
411 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
412 	int256  constant c1         = 0x1ffffffffff9dac9b;
413 	int256  constant c3         = 0x0aaaaaaac16877908;
414 	int256  constant c5         = 0x0666664e5e9fa0c99;
415 	int256  constant c7         = 0x049254026a7630acf;
416 	int256  constant c9         = 0x038bd75ed37753d68;
417 	int256  constant c11        = 0x03284a0c14610924f;
418 
419 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
420 	// approximates the function log(1+x)-log(1-x)
421 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
422 	function fixedLog(uint256 a) internal pure returns (int256 log) {
423 		int32 scale = 0;
424 		while (a > sqrt2) {
425 			a /= 2;
426 			scale++;
427 		}
428 		while (a <= sqrtdot5) {
429 			a *= 2;
430 			scale--;
431 		}
432 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
433 		var z = (s*s) / one;
434 		return scale * ln2 +
435 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
436 				/one))/one))/one))/one))/one);
437 	}
438 
439 	int256 constant c2 =  0x02aaaaaaaaa015db0;
440 	int256 constant c4 = -0x000b60b60808399d1;
441 	int256 constant c6 =  0x0000455956bccdd06;
442 	int256 constant c8 = -0x000001b893ad04b3a;
443 	
444 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
445 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
446 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
447 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
448 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
449 		a -= scale*ln2;
450 		int256 z = (a*a) / one;
451 		int256 R = ((int256)(2) * one) +
452 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
453 		exp = (uint256) (((R + a) * one) / (R - a));
454 		if (scale >= 0)
455 			exp <<= scale;
456 		else
457 			exp >>= -scale;
458 		return exp;
459 	}
460 	
461 	// The below are safemath implementations of the four arithmetic operators
462 	// designed to explicitly prevent over- and under-flows of integer values.
463 
464 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
465 		if (a == 0) {
466 			return 0;
467 		}
468 		uint256 c = a * b;
469 		assert(c / a == b);
470 		return c;
471 	}
472 
473 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
474 		// assert(b > 0); // Solidity automatically throws when dividing by 0
475 		uint256 c = a / b;
476 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
477 		return c;
478 	}
479 
480 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
481 		assert(b <= a);
482 		return a - b;
483 	}
484 
485 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
486 		uint256 c = a + b;
487 		assert(c >= a);
488 		return c;
489 	}
490 
491 	// This allows you to buy tokens by sending Ether directly to the smart contract
492 	// without including any transaction data (useful for, say, mobile wallet apps).
493 	function () payable public {
494 		// msg.value is the amount of Ether sent by the transaction.
495 		if (msg.value > 0) {
496 			fund();
497 		} else {
498 			withdrawOld(msg.sender);
499 		}
500 	}
501 }