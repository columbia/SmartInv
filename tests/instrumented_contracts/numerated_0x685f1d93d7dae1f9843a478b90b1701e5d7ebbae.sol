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
12  ShadowSpike. A no-bullshit, transparent, self-sustaining pyramid scheme.
13  
14  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
15 
16  Developers:
17 	Arc
18 	Divine
19 	Norsefire
20 	ToCsIcK
21 	
22  Front-End:
23 	Cardioth
24 	tenmei
25 	Trendium
26 	
27  Moral Support:
28 	DeadCow.Rat
29 	Dots
30 	FatKreamy
31 	Kaseylol
32 	QuantumDeath666
33 	Quentin
34  
35  Shit-Tier:
36 	HentaiChrist
37  
38 */
39 
40 contract ShadowSpike {
41 
42 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
43 	// orders of magnitude, hence the need to bridge between the two.
44 	uint256 constant scaleFactor = 0x10000000000;  // 2^64
45 
46 	// CRR = 50%
47 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
48 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
49 	int constant crr_n = 1; // CRR numerator
50 	int constant crr_d = 100000; // CRR denominator
51 
52 	// The price coefficient. Chosen such that at 1 token total supply
53 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
54 	int constant price_coeff = -0x296ABF784A358468C;
55 
56 	// Typical values that we have to declare.
57 	string constant public name = "ShadowSpike";
58 	string constant public symbol = "SHP";
59 	uint8 constant public decimals = 18;
60 
61 	// Array between each address and their number of tokens.
62 	mapping(address => uint256) public tokenBalance;
63 		
64 	// Array between each address and how much Ether has been paid out to it.
65 	// Note that this is scaled by the scaleFactor variable.
66 	mapping(address => int256) public payouts;
67 
68 	// Variable tracking how many tokens are in existence overall.
69 	uint256 public totalSupply;
70 
71 	// Aggregate sum of all payouts.
72 	// Note that this is scaled by the scaleFactor variable.
73 	int256 totalPayouts;
74 
75 	// Variable tracking how much Ether each token is currently worth.
76 	// Note that this is scaled by the scaleFactor variable.
77 	uint256 earningsPerToken;
78 	
79 	// Current contract balance in Ether
80 	uint256 public contractBalance;
81 
82 	function ShadowSpike() public {}
83 
84 	// The following functions are used by the front-end for display purposes.
85 
86 	// Returns the number of tokens currently held by _owner.
87 	function balanceOf(address _owner) public constant returns (uint256 balance) {
88 		return tokenBalance[_owner];
89 	}
90 
91 	// Withdraws all dividends held by the caller sending the transaction, updates
92 	// the requisite global variables, and transfers Ether back to the caller.
93 	function withdraw() public {
94 		// Retrieve the dividends associated with the address the request came from.
95 		var balance = dividends(msg.sender);
96 		
97 		// Update the payouts array, incrementing the request address by `balance`.
98 		payouts[msg.sender] += (int256) (balance * scaleFactor);
99 		
100 		// Increase the total amount that's been paid out to maintain invariance.
101 		totalPayouts += (int256) (balance * scaleFactor);
102 		
103 		// Send the dividends to the address that requested the withdraw.
104 		contractBalance = sub(contractBalance, balance);
105 		msg.sender.transfer(balance);
106 	}
107 
108 	// Converts the Ether accrued as dividends back into EPY tokens without having to
109 	// withdraw it first. Saves on gas and potential price spike loss.
110 	function reinvestDividends() public {
111 		// Retrieve the dividends associated with the address the request came from.
112 		var balance = dividends(msg.sender);
113 		
114 		// Update the payouts array, incrementing the request address by `balance`.
115 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
116 		payouts[msg.sender] += (int256) (balance * scaleFactor);
117 		
118 		// Increase the total amount that's been paid out to maintain invariance.
119 		totalPayouts += (int256) (balance * scaleFactor);
120 		
121 		// Assign balance to a new variable.
122 		uint value_ = (uint) (balance);
123 		
124 		// If your dividends are worth less than 1 szabo, or more than a million Ether
125 		// (in which case, why are you even here), abort.
126 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
127 			revert();
128 			
129 		// msg.sender is the address of the caller.
130 		var sender = msg.sender;
131 		
132 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
133 		// (Yes, the buyer receives a part of the distribution as well!)
134 		var res = reserve() - balance;
135 
136 		// 10% of the total Ether sent is used to pay existing holders.
137 		var fee = div(value_, 10);
138 		
139 		// The amount of Ether used to purchase new tokens for the caller.
140 		var numEther = value_ - fee;
141 		
142 		// The number of tokens which can be purchased for numEther.
143 		var numTokens = calculateDividendTokens(numEther, balance);
144 		
145 		// The buyer fee, scaled by the scaleFactor variable.
146 		var buyerFee = fee * scaleFactor;
147 		
148 		// Check that we have tokens in existence (this should always be true), or
149 		// else you're gonna have a bad time.
150 		if (totalSupply > 0) {
151 			// Compute the bonus co-efficient for all existing holders and the buyer.
152 			// The buyer receives part of the distribution for each token bought in the
153 			// same way they would have if they bought each token individually.
154 			var bonusCoEff =
155 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
156 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
157 				
158 			// The total reward to be distributed amongst the masses is the fee (in Ether)
159 			// multiplied by the bonus co-efficient.
160 			var holderReward = fee * bonusCoEff;
161 			
162 			buyerFee -= holderReward;
163 
164 			// Fee is distributed to all existing token holders before the new tokens are purchased.
165 			// rewardPerShare is the amount gained per token thanks to this buy-in.
166 			var rewardPerShare = holderReward / totalSupply;
167 			
168 			// The Ether value per token is increased proportionally.
169 			earningsPerToken += rewardPerShare;
170 		}
171 		
172 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
173 		totalSupply = add(totalSupply, numTokens);
174 		
175 		// Assign the tokens to the balance of the buyer.
176 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
177 		
178 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
179 		// Also include the fee paid for entering the scheme.
180 		// First we compute how much was just paid out to the buyer...
181 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
182 		
183 		// Then we update the payouts array for the buyer with this amount...
184 		payouts[sender] += payoutDiff;
185 		
186 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
187 		totalPayouts    += payoutDiff;
188 		
189 	}
190 
191 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
192 	// in the tokenBalance array, and therefore is shown as a dividend. A second
193 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
194 	function sellMyTokens() public {
195 		var balance = balanceOf(msg.sender);
196 		sell(balance);
197 	}
198 
199 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
200 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
201     function getMeOutOfHere() public {
202 		sellMyTokens();
203         withdraw();
204 	}
205 
206 	// Gatekeeper function to check if the amount of Ether being sent isn't either
207 	// too small or too large. If it passes, goes direct to buy().
208 	function fund() payable public {
209 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
210 		if (msg.value > 0.000001 ether) {
211 		    contractBalance = add(contractBalance, msg.value);
212 			buy();
213 		} else {
214 			revert();
215 		}
216     }
217 
218 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
219 	function buyPrice() public constant returns (uint) {
220 		return getTokensForEther(1 finney);
221 	}
222 
223 	// Function that returns the (dynamic) price of selling a single token.
224 	function sellPrice() public constant returns (uint) {
225         var eth = getEtherForTokens(1 finney);
226         var fee = div(eth, 10);
227         return eth - fee;
228     }
229 
230 	// Calculate the current dividends associated with the caller address. This is the net result
231 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
232 	// Ether that has already been paid out.
233 	function dividends(address _owner) public constant returns (uint256 amount) {
234 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
235 	}
236 
237 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
238 	// This is only used in the case when there is no transaction data, and that should be
239 	// quite rare unless interacting directly with the smart contract.
240 	function withdrawOld(address to) public {
241 		// Retrieve the dividends associated with the address the request came from.
242 		var balance = dividends(msg.sender);
243 		
244 		// Update the payouts array, incrementing the request address by `balance`.
245 		payouts[msg.sender] += (int256) (balance * scaleFactor);
246 		
247 		// Increase the total amount that's been paid out to maintain invariance.
248 		totalPayouts += (int256) (balance * scaleFactor);
249 		
250 		// Send the dividends to the address that requested the withdraw.
251 		contractBalance = sub(contractBalance, balance);
252 		to.transfer(balance);		
253 	}
254 
255 	// Internal balance function, used to calculate the dynamic reserve value.
256 	function balance() internal constant returns (uint256 amount) {
257 		// msg.value is the amount of Ether sent by the transaction.
258 		return contractBalance - msg.value;
259 	}
260 
261 	function buy() internal {
262 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
263 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
264 			revert();
265 						
266 		// msg.sender is the address of the caller.
267 		var sender = msg.sender;
268 		
269 		// 10% of the total Ether sent is used to pay existing holders.
270 		var fee = div(msg.value, 10);
271 		
272 		// The amount of Ether used to purchase new tokens for the caller.
273 		var numEther = msg.value - fee;
274 		
275 		// The number of tokens which can be purchased for numEther.
276 		var numTokens = getTokensForEther(numEther);
277 		
278 		// The buyer fee, scaled by the scaleFactor variable.
279 		var buyerFee = fee * scaleFactor;
280 		
281 		// Check that we have tokens in existence (this should always be true), or
282 		// else you're gonna have a bad time.
283 		if (totalSupply > 0) {
284 			// Compute the bonus co-efficient for all existing holders and the buyer.
285 			// The buyer receives part of the distribution for each token bought in the
286 			// same way they would have if they bought each token individually.
287 			var bonusCoEff =
288 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
289 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
290 				
291 			// The total reward to be distributed amongst the masses is the fee (in Ether)
292 			// multiplied by the bonus co-efficient.
293 			var holderReward = fee * bonusCoEff;
294 			
295 			buyerFee -= holderReward;
296 
297 			// Fee is distributed to all existing token holders before the new tokens are purchased.
298 			// rewardPerShare is the amount gained per token thanks to this buy-in.
299 			var rewardPerShare = holderReward / totalSupply;
300 			
301 			// The Ether value per token is increased proportionally.
302 			earningsPerToken += rewardPerShare;
303 			
304 		}
305 
306 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
307 		totalSupply = add(totalSupply, numTokens);
308 
309 		// Assign the tokens to the balance of the buyer.
310 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
311 
312 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
313 		// Also include the fee paid for entering the scheme.
314 		// First we compute how much was just paid out to the buyer...
315 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
316 		
317 		// Then we update the payouts array for the buyer with this amount...
318 		payouts[sender] += payoutDiff;
319 		
320 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
321 		totalPayouts    += payoutDiff;
322 		
323 	}
324 
325 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
326 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
327 	// will be *significant*.
328 	function sell(uint256 amount) internal {
329 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
330 		var numEthersBeforeFee = getEtherForTokens(amount);
331 		
332 		// 10% of the resulting Ether is used to pay remaining holders.
333         var fee = div(numEthersBeforeFee, 10);
334 		
335 		// Net Ether for the seller after the fee has been subtracted.
336         var numEthers = numEthersBeforeFee - fee;
337 		
338 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
339 		totalSupply = sub(totalSupply, amount);
340 		
341         // Remove the tokens from the balance of the buyer.
342 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
343 
344         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
345 		// First we compute how much was just paid out to the seller...
346 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
347 		
348         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
349 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
350 		// they decide to buy back in.
351 		payouts[msg.sender] -= payoutDiff;		
352 		
353 		// Decrease the total amount that's been paid out to maintain invariance.
354         totalPayouts -= payoutDiff;
355 		
356 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
357 		// selling tokens, but it guards against division by zero).
358 		if (totalSupply > 0) {
359 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
360 			var etherFee = fee * scaleFactor;
361 			
362 			// Fee is distributed to all remaining token holders.
363 			// rewardPerShare is the amount gained per token thanks to this sell.
364 			var rewardPerShare = etherFee / totalSupply;
365 			
366 			// The Ether value per token is increased proportionally.
367 			earningsPerToken = add(earningsPerToken, rewardPerShare);
368 		}
369 	}
370 	
371 	// Dynamic value of Ether in reserve, according to the CRR requirement.
372 	function reserve() internal constant returns (uint256 amount) {
373 		return sub(balance(),
374 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
375 	}
376 
377 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
378 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
379 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
380 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
381 	}
382 
383 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
384 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
385 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
386 	}
387 
388 	// Converts a number tokens into an Ether value.
389 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
390 		// How much reserve Ether do we have left in the contract?
391 		var reserveAmount = reserve();
392 
393 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
394 		if (tokens == totalSupply)
395 			return reserveAmount;
396 
397 		// If there would be excess Ether left after the transaction this is called within, return the Ether
398 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
399 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
400 		// and denominator altered to 1 and 2 respectively.
401 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
402 	}
403 
404 	// You don't care about these, but if you really do they're hex values for 
405 	// co-efficients used to simulate approximations of the log and exp functions.
406 	int256  constant one        = 0x10000000000000000;
407 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
408 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
409 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
410 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
411 	int256  constant c1         = 0x1ffffffffff9dac9b;
412 	int256  constant c3         = 0x0aaaaaaac16877908;
413 	int256  constant c5         = 0x0666664e5e9fa0c99;
414 	int256  constant c7         = 0x049254026a7630acf;
415 	int256  constant c9         = 0x038bd75ed37753d68;
416 	int256  constant c11        = 0x03284a0c14610924f;
417 
418 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
419 	// approximates the function log(1+x)-log(1-x)
420 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
421 	function fixedLog(uint256 a) internal pure returns (int256 log) {
422 		int32 scale = 0;
423 		while (a > sqrt2) {
424 			a /= 2;
425 			scale++;
426 		}
427 		while (a <= sqrtdot5) {
428 			a *= 2;
429 			scale--;
430 		}
431 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
432 		var z = (s*s) / one;
433 		return scale * ln2 +
434 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
435 				/one))/one))/one))/one))/one);
436 	}
437 
438 	int256 constant c2 =  0x02aaaaaaaaa015db0;
439 	int256 constant c4 = -0x000b60b60808399d1;
440 	int256 constant c6 =  0x0000455956bccdd06;
441 	int256 constant c8 = -0x000001b893ad04b3a;
442 	
443 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
444 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
445 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
446 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
447 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
448 		a -= scale*ln2;
449 		int256 z = (a*a) / one;
450 		int256 R = ((int256)(2) * one) +
451 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
452 		exp = (uint256) (((R + a) * one) / (R - a));
453 		if (scale >= 0)
454 			exp <<= scale;
455 		else
456 			exp >>= -scale;
457 		return exp;
458 	}
459 	
460 	// The below are safemath implementations of the four arithmetic operators
461 	// designed to explicitly prevent over- and under-flows of integer values.
462 
463 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
464 		if (a == 0) {
465 			return 0;
466 		}
467 		uint256 c = a * b;
468 		assert(c / a == b);
469 		return c;
470 	}
471 
472 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
473 		// assert(b > 0); // Solidity automatically throws when dividing by 0
474 		uint256 c = a / b;
475 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
476 		return c;
477 	}
478 
479 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
480 		assert(b <= a);
481 		return a - b;
482 	}
483 
484 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
485 		uint256 c = a + b;
486 		assert(c >= a);
487 		return c;
488 	}
489 
490 	// This allows you to buy tokens by sending Ether directly to the smart contract
491 	// without including any transaction data (useful for, say, mobile wallet apps).
492 	function () payable public {
493 		// msg.value is the amount of Ether sent by the transaction.
494 		if (msg.value > 0) {
495 			fund();
496 		} else {
497 			withdrawOld(msg.sender);
498 		}
499 	}
500 }