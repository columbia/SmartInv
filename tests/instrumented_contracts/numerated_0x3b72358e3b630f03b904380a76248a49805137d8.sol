1 pragma solidity ^0.4.18;
2 
3 /*
4   HODLCoin. A no-bullshit, transparent, self-sustaining pyramid scheme.
5  Clone of Ethpyramid original developers, Built in Safemath to stop under/overflow errors. 
6  
7  https://test.jochen-hoenicke.de/eth/ponzitoken/
8 
9  Developers:
10 	Arc
11 	Divine
12 	Norsefire
13 	ToCsIcK
14 	
15  Front-End:
16 	Cardioth
17 	tenmei
18 	Trendium
19 	
20  Moral Support:
21 	DeadCow.Rat
22 	Dots
23 	FatKreamy
24 	Kaseylol
25 	QuantumDeath666
26 	Quentin
27  
28  Shit-Tier:
29 	HentaiChrist
30  
31 */
32 
33 contract HODLCoin{
34 
35 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
36 	// orders of magnitude, hence the need to bridge between the two.
37 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
38 
39 	// CRR = 50%
40 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
41 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
42 	int constant crr_n = 1; // CRR numerator
43 	int constant crr_d = 2; // CRR denominator
44 
45 	// The price coefficient. Chosen such that at 1 token total supply
46 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
47 	int constant price_coeff = -0x296ABF784A358468C;
48 
49 	// Typical values that we have to declare.
50 	string constant public name = "HODLCoin";
51 	string constant public symbol = "HODL";
52 	uint8 constant public decimals = 18;
53 
54 	// Array between each address and their number of tokens.
55 	mapping(address => uint256) public tokenBalance;
56 		
57 	// Array between each address and how much Ether has been paid out to it.
58 	// Note that this is scaled by the scaleFactor variable.
59 	mapping(address => int256) public payouts;
60 
61 	// Variable tracking how many tokens are in existence overall.
62 	uint256 public totalSupply;
63 
64 	// Aggregate sum of all payouts.
65 	// Note that this is scaled by the scaleFactor variable.
66 	int256 totalPayouts;
67 
68 	// Variable tracking how much Ether each token is currently worth.
69 	// Note that this is scaled by the scaleFactor variable.
70 	uint256 earningsPerToken;
71 	
72 	// Current contract balance in Ether
73 	uint256 public contractBalance;
74 
75 	function HODLCoin() public {}
76 
77 	// The following functions are used by the front-end for display purposes.
78 
79 	// Returns the number of tokens currently held by _owner.
80 	function balanceOf(address _owner) public constant returns (uint256 balance) {
81 		return tokenBalance[_owner];
82 	}
83 
84 	// Withdraws all dividends held by the caller sending the transaction, updates
85 	// the requisite global variables, and transfers Ether back to the caller.
86 	function withdraw() public {
87 		// Retrieve the dividends associated with the address the request came from.
88 		var balance = dividends(msg.sender);
89 		
90 		// Update the payouts array, incrementing the request address by `balance`.
91 		payouts[msg.sender] += (int256) (balance * scaleFactor);
92 		
93 		// Increase the total amount that's been paid out to maintain invariance.
94 		totalPayouts += (int256) (balance * scaleFactor);
95 		
96 		// Send the dividends to the address that requested the withdraw.
97 		contractBalance = sub(contractBalance, balance);
98 		msg.sender.transfer(balance);
99 	}
100 
101 	// Converts the Ether accrued as dividends back into LPY tokens without having to
102 	// withdraw it first. Saves on gas and potential price spike loss.
103 	function reinvestDividends() public {
104 		// Retrieve the dividends associated with the address the request came from.
105 		var balance = dividends(msg.sender);
106 		
107 		// Update the payouts array, incrementing the request address by `balance`.
108 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
109 		payouts[msg.sender] += (int256) (balance * scaleFactor);
110 		
111 		// Increase the total amount that's been paid out to maintain invariance.
112 		totalPayouts += (int256) (balance * scaleFactor);
113 		
114 		// Assign balance to a new variable.
115 		uint value_ = (uint) (balance);
116 		
117 		// If your dividends are worth less than 1 szabo, or more than a million Ether
118 		// (in which case, why are you even here), abort.
119 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
120 			revert();
121 			
122 		// msg.sender is the address of the caller.
123 		var sender = msg.sender;
124 		
125 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
126 		// (Yes, the buyer receives a part of the distribution as well!)
127 		var res = reserve() - balance;
128 
129 		// 10% of the total Ether sent is used to pay existing holders.
130 		var fee = div(value_, 10);
131 		
132 		// The amount of Ether used to purchase new tokens for the caller.
133 		var numEther = value_ - fee;
134 		
135 		// The number of tokens which can be purchased for numEther.
136 		var numTokens = calculateDividendTokens(numEther, balance);
137 		
138 		// The buyer fee, scaled by the scaleFactor variable.
139 		var buyerFee = fee * scaleFactor;
140 		
141 		// Check that we have tokens in existence (this should always be true), or
142 		// else you're gonna have a bad time.
143 		if (totalSupply > 0) {
144 			// Compute the bonus co-efficient for all existing holders and the buyer.
145 			// The buyer receives part of the distribution for each token bought in the
146 			// same way they would have if they bought each token individually.
147 			var bonusCoEff =
148 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
149 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
150 				
151 			// The total reward to be distributed amongst the masses is the fee (in Ether)
152 			// multiplied by the bonus co-efficient.
153 			var holderReward = fee * bonusCoEff;
154 			
155 			buyerFee -= holderReward;
156 
157 			// Fee is distributed to all existing token holders before the new tokens are purchased.
158 			// rewardPerShare is the amount gained per token thanks to this buy-in.
159 			var rewardPerShare = holderReward / totalSupply;
160 			
161 			// The Ether value per token is increased proportionally.
162 			earningsPerToken += rewardPerShare;
163 		}
164 		
165 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
166 		totalSupply = add(totalSupply, numTokens);
167 		
168 		// Assign the tokens to the balance of the buyer.
169 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
170 		
171 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
172 		// Also include the fee paid for entering the scheme.
173 		// First we compute how much was just paid out to the buyer...
174 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
175 		
176 		// Then we update the payouts array for the buyer with this amount...
177 		payouts[sender] += payoutDiff;
178 		
179 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
180 		totalPayouts    += payoutDiff;
181 		
182 	}
183 
184 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
185 	// in the tokenBalance array, and therefore is shown as a dividend. A second
186 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
187 	function sellMyTokens() public {
188 		var balance = balanceOf(msg.sender);
189 		sell(balance);
190 	}
191 
192 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
193 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
194     function getMeOutOfHere() public {
195 		sellMyTokens();
196         withdraw();
197 	}
198 
199 	// Gatekeeper function to check if the amount of Ether being sent isn't either
200 	// too small or too large. If it passes, goes direct to buy().
201 	function fund() payable public {
202 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
203 		if (msg.value > 0.000001 ether) {
204 		    contractBalance = add(contractBalance, msg.value);
205 			buy();
206 		} else {
207 			revert();
208 		}
209     }
210 
211 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
212 	function buyPrice() public constant returns (uint) {
213 		return getTokensForEther(1 finney);
214 	}
215 
216 	// Function that returns the (dynamic) price of selling a single token.
217 	function sellPrice() public constant returns (uint) {
218         var eth = getEtherForTokens(1 finney);
219         var fee = div(eth, 10);
220         return eth - fee;
221     }
222 
223 	// Calculate the current dividends associated with the caller address. This is the net result
224 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
225 	// Ether that has already been paid out.
226 	function dividends(address _owner) public constant returns (uint256 amount) {
227 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
228 	}
229 
230 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
231 	// This is only used in the case when there is no transaction data, and that should be
232 	// quite rare unless interacting directly with the smart contract.
233 	function withdrawOld(address to) public {
234 		// Retrieve the dividends associated with the address the request came from.
235 		var balance = dividends(msg.sender);
236 		
237 		// Update the payouts array, incrementing the request address by `balance`.
238 		payouts[msg.sender] += (int256) (balance * scaleFactor);
239 		
240 		// Increase the total amount that's been paid out to maintain invariance.
241 		totalPayouts += (int256) (balance * scaleFactor);
242 		
243 		// Send the dividends to the address that requested the withdraw.
244 		contractBalance = sub(contractBalance, balance);
245 		to.transfer(balance);		
246 	}
247 
248 	// Internal balance function, used to calculate the dynamic reserve value.
249 	function balance() internal constant returns (uint256 amount) {
250 		// msg.value is the amount of Ether sent by the transaction.
251 		return contractBalance - msg.value;
252 	}
253 
254 	function buy() internal {
255 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
256 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
257 			revert();
258 						
259 		// msg.sender is the address of the caller.
260 		var sender = msg.sender;
261 		
262 		// 10% of the total Ether sent is used to pay existing holders.
263 		var fee = div(msg.value, 10);
264 		
265 		// The amount of Ether used to purchase new tokens for the caller.
266 		var numEther = msg.value - fee;
267 		
268 		// The number of tokens which can be purchased for numEther.
269 		var numTokens = getTokensForEther(numEther);
270 		
271 		// The buyer fee, scaled by the scaleFactor variable.
272 		var buyerFee = fee * scaleFactor;
273 		
274 		// Check that we have tokens in existence (this should always be true), or
275 		// else you're gonna have a bad time.
276 		if (totalSupply > 0) {
277 			// Compute the bonus co-efficient for all existing holders and the buyer.
278 			// The buyer receives part of the distribution for each token bought in the
279 			// same way they would have if they bought each token individually.
280 			var bonusCoEff =
281 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
282 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
283 				
284 			// The total reward to be distributed amongst the masses is the fee (in Ether)
285 			// multiplied by the bonus co-efficient.
286 			var holderReward = fee * bonusCoEff;
287 			
288 			buyerFee -= holderReward;
289 
290 			// Fee is distributed to all existing token holders before the new tokens are purchased.
291 			// rewardPerShare is the amount gained per token thanks to this buy-in.
292 			var rewardPerShare = holderReward / totalSupply;
293 			
294 			// The Ether value per token is increased proportionally.
295 			earningsPerToken += rewardPerShare;
296 			
297 		}
298 
299 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
300 		totalSupply = add(totalSupply, numTokens);
301 
302 		// Assign the tokens to the balance of the buyer.
303 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
304 
305 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
306 		// Also include the fee paid for entering the scheme.
307 		// First we compute how much was just paid out to the buyer...
308 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
309 		
310 		// Then we update the payouts array for the buyer with this amount...
311 		payouts[sender] += payoutDiff;
312 		
313 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
314 		totalPayouts    += payoutDiff;
315 		
316 	}
317 
318 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
319 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
320 	// will be *significant*.
321 	function sell(uint256 amount) internal {
322 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
323 		var numEthersBeforeFee = getEtherForTokens(amount);
324 		
325 		// 10% of the resulting Ether is used to pay remaining holders.
326         var fee = div(numEthersBeforeFee, 10);
327 		
328 		// Net Ether for the seller after the fee has been subtracted.
329         var numEthers = numEthersBeforeFee - fee;
330 		
331 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
332 		totalSupply = sub(totalSupply, amount);
333 		
334         // Remove the tokens from the balance of the buyer.
335 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
336 
337         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
338 		// First we compute how much was just paid out to the seller...
339 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
340 		
341         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
342 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
343 		// they decide to buy back in.
344 		payouts[msg.sender] -= payoutDiff;		
345 		
346 		// Decrease the total amount that's been paid out to maintain invariance.
347         totalPayouts -= payoutDiff;
348 		
349 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
350 		// selling tokens, but it guards against division by zero).
351 		if (totalSupply > 0) {
352 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
353 			var etherFee = fee * scaleFactor;
354 			
355 			// Fee is distributed to all remaining token holders.
356 			// rewardPerShare is the amount gained per token thanks to this sell.
357 			var rewardPerShare = etherFee / totalSupply;
358 			
359 			// The Ether value per token is increased proportionally.
360 			earningsPerToken = add(earningsPerToken, rewardPerShare);
361 		}
362 	}
363 	
364 	// Dynamic value of Ether in reserve, according to the CRR requirement.
365 	function reserve() internal constant returns (uint256 amount) {
366 		return sub(balance(),
367 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
368 	}
369 
370 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
371 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
372 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
373 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
374 	}
375 
376 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
377 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
378 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
379 	}
380 
381 	// Converts a number tokens into an Ether value.
382 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
383 		// How much reserve Ether do we have left in the contract?
384 		var reserveAmount = reserve();
385 
386 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
387 		if (tokens == totalSupply)
388 			return reserveAmount;
389 
390 		// If there would be excess Ether left after the transaction this is called within, return the Ether
391 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
392 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
393 		// and denominator altered to 1 and 2 respectively.
394 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
395 	}
396 
397 	// You don't care about these, but if you really do they're hex values for 
398 	// co-efficients used to simulate approximations of the log and exp functions.
399 	int256  constant one        = 0x10000000000000000;
400 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
401 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
402 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
403 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
404 	int256  constant c1         = 0x1ffffffffff9dac9b;
405 	int256  constant c3         = 0x0aaaaaaac16877908;
406 	int256  constant c5         = 0x0666664e5e9fa0c99;
407 	int256  constant c7         = 0x049254026a7630acf;
408 	int256  constant c9         = 0x038bd75ed37753d68;
409 	int256  constant c11        = 0x03284a0c14610924f;
410 
411 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
412 	// approximates the function log(1+x)-log(1-x)
413 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
414 	function fixedLog(uint256 a) internal pure returns (int256 log) {
415 		int32 scale = 0;
416 		while (a > sqrt2) {
417 			a /= 2;
418 			scale++;
419 		}
420 		while (a <= sqrtdot5) {
421 			a *= 2;
422 			scale--;
423 		}
424 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
425 		var z = (s*s) / one;
426 		return scale * ln2 +
427 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
428 				/one))/one))/one))/one))/one);
429 	}
430 
431 	int256 constant c2 =  0x02aaaaaaaaa015db0;
432 	int256 constant c4 = -0x000b60b60808399d1;
433 	int256 constant c6 =  0x0000455956bccdd06;
434 	int256 constant c8 = -0x000001b893ad04b3a;
435 	
436 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
437 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
438 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
439 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
440 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
441 		a -= scale*ln2;
442 		int256 z = (a*a) / one;
443 		int256 R = ((int256)(2) * one) +
444 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
445 		exp = (uint256) (((R + a) * one) / (R - a));
446 		if (scale >= 0)
447 			exp <<= scale;
448 		else
449 			exp >>= -scale;
450 		return exp;
451 	}
452 	
453 	// The below are safemath implementations of the four arithmetic operators
454 	// designed to explicitly prevent over- and under-flows of integer values.
455 
456 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
457 		if (a == 0) {
458 			return 0;
459 		}
460 		uint256 c = a * b;
461 		assert(c / a == b);
462 		return c;
463 	}
464 
465 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
466 		// assert(b > 0); // Solidity automatically throws when dividing by 0
467 		uint256 c = a / b;
468 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
469 		return c;
470 	}
471 
472 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
473 		assert(b <= a);
474 		return a - b;
475 	}
476 
477 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
478 		uint256 c = a + b;
479 		assert(c >= a);
480 		return c;
481 	}
482 
483 	// This allows you to buy tokens by sending Ether directly to the smart contract
484 	// without including any transaction data (useful for, say, mobile wallet apps).
485 	function () payable public {
486 		// msg.value is the amount of Ether sent by the transaction.
487 		if (msg.value > 0) {
488 			fund();
489 		} else {
490 			withdrawOld(msg.sender);
491 		}
492 	}
493 }