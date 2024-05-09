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
57 	string constant public name = "EthPyramid";
58 	string constant public symbol = "EPY";
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
79 	function EthPyramid() public {}
80 
81 	// The following functions are used by the front-end for display purposes.
82 
83 	// Returns the number of tokens currently held by _owner.
84 	function balanceOf(address _owner) public constant returns (uint256 balance) {
85 		return tokenBalance[_owner];
86 	}
87 
88 	// Withdraws all dividends held by the caller sending the transaction, updates
89 	// the requisite global variables, and transfers Ether back to the caller.
90 	function withdraw() public {
91 		// Retrieve the dividends associated with the address the request came from.
92 		var balance = dividends(msg.sender);
93 		
94 		// Update the payouts array, incrementing the request address by `balance`.
95 		payouts[msg.sender] += (int256) (balance * scaleFactor);
96 		
97 		// Increase the total amount that's been paid out to maintain invariance.
98 		totalPayouts += (int256) (balance * scaleFactor);
99 		
100 		// Send the dividends to the address that requested the withdraw.
101 		msg.sender.transfer(balance);
102 	}
103 
104 	// Converts the Ether accrued as dividends back into EPY tokens without having to
105 	// withdraw it first. Saves on gas and potential price spike loss.
106 	function reinvestDividends() public {
107 		// Retrieve the dividends associated with the address the request came from.
108 		var balance = dividends(msg.sender);
109 		
110 		// Update the payouts array, incrementing the request address by `balance`.
111 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
112 		payouts[msg.sender] += (int256) (balance * scaleFactor);
113 		
114 		// Increase the total amount that's been paid out to maintain invariance.
115 		totalPayouts += (int256) (balance * scaleFactor);
116 		
117 		// Assign balance to a new variable.
118 		uint value_ = (uint) (balance);
119 		
120 		// If your dividends are worth less than 1 szabo, or more than a million Ether
121 		// (in which case, why are you even here), abort.
122 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
123 			revert();
124 			
125 		// msg.sender is the address of the caller.
126 		var sender = msg.sender;
127 		
128 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
129 		// (Yes, the buyer receives a part of the distribution as well!)
130 		var res = reserve() - balance;
131 
132 		// 10% of the total Ether sent is used to pay existing holders.
133 		var fee = div(value_, 10);
134 		
135 		// The amount of Ether used to purchase new tokens for the caller.
136 		var numEther = value_ - fee;
137 		
138 		// The number of tokens which can be purchased for numEther.
139 		var numTokens = calculateDividendTokens(numEther, balance);
140 		
141 		// The buyer fee, scaled by the scaleFactor variable.
142 		var buyerFee = fee * scaleFactor;
143 		
144 		// Check that we have tokens in existence (this should always be true), or
145 		// else you're gonna have a bad time.
146 		if (totalSupply > 0) {
147 			// Compute the bonus co-efficient for all existing holders and the buyer.
148 			// The buyer receives part of the distribution for each token bought in the
149 			// same way they would have if they bought each token individually.
150 			var bonusCoEff =
151 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
152 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
153 				
154 			// The total reward to be distributed amongst the masses is the fee (in Ether)
155 			// multiplied by the bonus co-efficient.
156 			var holderReward = fee * bonusCoEff;
157 			
158 			buyerFee -= holderReward;
159 
160 			// Fee is distributed to all existing token holders before the new tokens are purchased.
161 			// rewardPerShare is the amount gained per token thanks to this buy-in.
162 			var rewardPerShare = holderReward / totalSupply;
163 			
164 			// The Ether value per token is increased proportionally.
165 			earningsPerToken += rewardPerShare;
166 		}
167 		
168 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
169 		totalSupply = add(totalSupply, numTokens);
170 		
171 		// Assign the tokens to the balance of the buyer.
172 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
173 		
174 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
175 		// Also include the fee paid for entering the scheme.
176 		// First we compute how much was just paid out to the buyer...
177 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
178 		
179 		// Then we update the payouts array for the buyer with this amount...
180 		payouts[sender] += payoutDiff;
181 		
182 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
183 		totalPayouts    += payoutDiff;
184 		
185 	}
186 
187 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
188 	// in the tokenBalance array, and therefore is shown as a dividend. A second
189 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
190 	function sellMyTokens() public {
191 		var balance = balanceOf(msg.sender);
192 		sell(balance);
193 	}
194 
195 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
196 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
197     function getMeOutOfHere() public {
198 		sellMyTokens();
199         withdraw();
200 	}
201 
202 	// Gatekeeper function to check if the amount of Ether being sent isn't either
203 	// too small or too large. If it passes, goes direct to buy().
204 	function fund() payable public {
205 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
206 		if (msg.value > 0.000001 ether) {
207 			buy();
208 		} else {
209 			revert();
210 		}
211     }
212 
213 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
214 	function buyPrice() public constant returns (uint) {
215 		return getTokensForEther(1 finney);
216 	}
217 
218 	// Function that returns the (dynamic) price of selling a single token.
219 	function sellPrice() public constant returns (uint) {
220         var eth = getEtherForTokens(1 finney);
221         var fee = div(eth, 10);
222         return eth - fee;
223     }
224 
225 	// Calculate the current dividends associated with the caller address. This is the net result
226 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
227 	// Ether that has already been paid out.
228 	function dividends(address _owner) public constant returns (uint256 amount) {
229 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
230 	}
231 
232 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
233 	// This is only used in the case when there is no transaction data, and that should be
234 	// quite rare unless interacting directly with the smart contract.
235 	function withdrawOld(address to) public {
236 		// Retrieve the dividends associated with the address the request came from.
237 		var balance = dividends(msg.sender);
238 		
239 		// Update the payouts array, incrementing the request address by `balance`.
240 		payouts[msg.sender] += (int256) (balance * scaleFactor);
241 		
242 		// Increase the total amount that's been paid out to maintain invariance.
243 		totalPayouts += (int256) (balance * scaleFactor);
244 		
245 		// Send the dividends to the address that requested the withdraw.
246 		to.transfer(balance);
247 	}
248 
249 	// Internal balance function, used to calculate the dynamic reserve value.
250 	function balance() internal constant returns (uint256 amount) {
251 		// msg.value is the amount of Ether sent by the transaction.
252 		return this.balance - msg.value;
253 	}
254 
255 	function buy() internal {
256 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
257 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
258 			revert();
259 			
260 		// msg.sender is the address of the caller.
261 		var sender = msg.sender;
262 		
263 		// 10% of the total Ether sent is used to pay existing holders.
264 		var fee = div(msg.value, 10);
265 		
266 		// The amount of Ether used to purchase new tokens for the caller.
267 		var numEther = msg.value - fee;
268 		
269 		// The number of tokens which can be purchased for numEther.
270 		var numTokens = getTokensForEther(numEther);
271 		
272 		// The buyer fee, scaled by the scaleFactor variable.
273 		var buyerFee = fee * scaleFactor;
274 		
275 		// Check that we have tokens in existence (this should always be true), or
276 		// else you're gonna have a bad time.
277 		if (totalSupply > 0) {
278 			// Compute the bonus co-efficient for all existing holders and the buyer.
279 			// The buyer receives part of the distribution for each token bought in the
280 			// same way they would have if they bought each token individually.
281 			var bonusCoEff =
282 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
283 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
284 				
285 			// The total reward to be distributed amongst the masses is the fee (in Ether)
286 			// multiplied by the bonus co-efficient.
287 			var holderReward = fee * bonusCoEff;
288 			
289 			buyerFee -= holderReward;
290 
291 			// Fee is distributed to all existing token holders before the new tokens are purchased.
292 			// rewardPerShare is the amount gained per token thanks to this buy-in.
293 			var rewardPerShare = holderReward / totalSupply;
294 			
295 			// The Ether value per token is increased proportionally.
296 			earningsPerToken += rewardPerShare;
297 			
298 		}
299 
300 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
301 		totalSupply = add(totalSupply, numTokens);
302 
303 		// Assign the tokens to the balance of the buyer.
304 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
305 
306 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
307 		// Also include the fee paid for entering the scheme.
308 		// First we compute how much was just paid out to the buyer...
309 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
310 		
311 		// Then we update the payouts array for the buyer with this amount...
312 		payouts[sender] += payoutDiff;
313 		
314 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
315 		totalPayouts    += payoutDiff;
316 		
317 	}
318 
319 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
320 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
321 	// will be *significant*.
322 	function sell(uint256 amount) internal {
323 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
324 		var numEthersBeforeFee = getEtherForTokens(amount);
325 		
326 		// 10% of the resulting Ether is used to pay remaining holders.
327         var fee = div(numEthersBeforeFee, 10);
328 		
329 		// Net Ether for the seller after the fee has been subtracted.
330         var numEthers = numEthersBeforeFee - fee;
331 		
332 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
333 		totalSupply = sub(totalSupply, amount);
334 		
335         // Remove the tokens from the balance of the buyer.
336 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
337 
338         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
339 		// First we compute how much was just paid out to the seller...
340 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
341 		
342         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
343 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
344 		// they decide to buy back in.
345 		payouts[msg.sender] -= payoutDiff;		
346 		
347 		// Decrease the total amount that's been paid out to maintain invariance.
348         totalPayouts -= payoutDiff;
349 		
350 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
351 		// selling tokens, but it guards against division by zero).
352 		if (totalSupply > 0) {
353 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
354 			var etherFee = fee * scaleFactor;
355 			
356 			// Fee is distributed to all remaining token holders.
357 			// rewardPerShare is the amount gained per token thanks to this sell.
358 			var rewardPerShare = etherFee / totalSupply;
359 			
360 			// The Ether value per token is increased proportionally.
361 			earningsPerToken = add(earningsPerToken, rewardPerShare);
362 		}
363 	}
364 	
365 	// Dynamic value of Ether in reserve, according to the CRR requirement.
366 	function reserve() internal constant returns (uint256 amount) {
367 		return sub(balance(),
368 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
369 	}
370 
371 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
372 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
373 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
374 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
375 	}
376 
377 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
378 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
379 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
380 	}
381 
382 	// Converts a number tokens into an Ether value.
383 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
384 		// How much reserve Ether do we have left in the contract?
385 		var reserveAmount = reserve();
386 
387 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
388 		if (tokens == totalSupply)
389 			return reserveAmount;
390 
391 		// If there would be excess Ether left after the transaction this is called within, return the Ether
392 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
393 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
394 		// and denominator altered to 1 and 2 respectively.
395 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
396 	}
397 
398 	// You don't care about these, but if you really do they're hex values for 
399 	// co-efficients used to simulate approximations of the log and exp functions.
400 	int256  constant one        = 0x10000000000000000;
401 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
402 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
403 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
404 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
405 	int256  constant c1         = 0x1ffffffffff9dac9b;
406 	int256  constant c3         = 0x0aaaaaaac16877908;
407 	int256  constant c5         = 0x0666664e5e9fa0c99;
408 	int256  constant c7         = 0x049254026a7630acf;
409 	int256  constant c9         = 0x038bd75ed37753d68;
410 	int256  constant c11        = 0x03284a0c14610924f;
411 
412 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
413 	// approximates the function log(1+x)-log(1-x)
414 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
415 	function fixedLog(uint256 a) internal pure returns (int256 log) {
416 		int32 scale = 0;
417 		while (a > sqrt2) {
418 			a /= 2;
419 			scale++;
420 		}
421 		while (a <= sqrtdot5) {
422 			a *= 2;
423 			scale--;
424 		}
425 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
426 		var z = (s*s) / one;
427 		return scale * ln2 +
428 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
429 				/one))/one))/one))/one))/one);
430 	}
431 
432 	int256 constant c2 =  0x02aaaaaaaaa015db0;
433 	int256 constant c4 = -0x000b60b60808399d1;
434 	int256 constant c6 =  0x0000455956bccdd06;
435 	int256 constant c8 = -0x000001b893ad04b3a;
436 	
437 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
438 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
439 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
440 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
441 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
442 		a -= scale*ln2;
443 		int256 z = (a*a) / one;
444 		int256 R = ((int256)(2) * one) +
445 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
446 		exp = (uint256) (((R + a) * one) / (R - a));
447 		if (scale >= 0)
448 			exp <<= scale;
449 		else
450 			exp >>= -scale;
451 		return exp;
452 	}
453 	
454 	// The below are safemath implementations of the four arithmetic operators
455 	// designed to explicitly prevent over- and under-flows of integer values.
456 
457 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
458 		if (a == 0) {
459 			return 0;
460 		}
461 		uint256 c = a * b;
462 		assert(c / a == b);
463 		return c;
464 	}
465 
466 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
467 		// assert(b > 0); // Solidity automatically throws when dividing by 0
468 		uint256 c = a / b;
469 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
470 		return c;
471 	}
472 
473 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
474 		assert(b <= a);
475 		return a - b;
476 	}
477 
478 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
479 		uint256 c = a + b;
480 		assert(c >= a);
481 		return c;
482 	}
483 
484 	// This allows you to buy tokens by sending Ether directly to the smart contract
485 	// without including any transaction data (useful for, say, mobile wallet apps).
486 	function () payable public {
487 		// msg.value is the amount of Ether sent by the transaction.
488 		if (msg.value > 0) {
489 			fund();
490 		} else {
491 			withdrawOld(msg.sender);
492 		}
493 	}
494 }