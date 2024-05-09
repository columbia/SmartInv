1 pragma solidity ^0.4.18;
2 
3 /*
4           ,/`.
5         ,'/ __`.
6       ,'_/_ _A _`.
7     ,'__/_ NEET _  `.
8   ,'_  /__ WILL _ __ `.
9  '-.._/____RISE"-.-..__`.
10   
11 
12  NEETPyramid. A bullshit, non-transparent, somwhat self-sustaining pyramid scheme for NEETs by NEETs. Totally not a scam. Okay maybe.
13  
14  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
15 
16  Developers:
17  	NotJustinSun
18  	NotBrandonEnrich
19  	NotYourMum
20  
21 */
22 
23 contract NEETPyramid {
24 
25 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
26 	// orders of magnitude, hence the need to bridge between the two.
27 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
28 
29 	// CRR = 50%
30 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
31 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
32 	int constant crr_n = 1; // CRR numerator
33 	int constant crr_d = 2; // CRR denominator
34 
35 	// The price coefficient. Chosen such that at 1 token total supply
36 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
37 	int constant price_coeff = -0x296ABF784A358468C;
38 
39 	// Typical values that we have to declare.
40 	string constant public name = "NEETPyramid";
41 	string constant public symbol = "NPY";
42 	uint8 constant public decimals = 18;
43 
44 	// Array between each address and their number of tokens.
45 	mapping(address => uint256) public tokenBalance;
46 		
47 	// Array between each address and how much Ether has been paid out to it.
48 	// Note that this is scaled by the scaleFactor variable.
49 	mapping(address => int256) public payouts;
50 
51 	// Variable tracking how many tokens are in existence overall.
52 	uint256 public totalSupply;
53 
54 	// Aggregate sum of all payouts.
55 	// Note that this is scaled by the scaleFactor variable.
56 	int256 totalPayouts;
57 
58 	// Variable tracking how much Ether each token is currently worth.
59 	// Note that this is scaled by the scaleFactor variable.
60 	uint256 earningsPerToken;
61 	
62 	// Current contract balance in Ether
63 	uint256 public contractBalance;
64 
65 	function NEETPyramid() public {}
66 
67 	// The following functions are used by the front-end for display purposes.
68 
69 	// Returns the number of tokens currently held by _owner.
70 	function balanceOf(address _owner) public constant returns (uint256 balance) {
71 		return tokenBalance[_owner];
72 	}
73 
74 	// Withdraws all dividends held by the caller sending the transaction, updates
75 	// the requisite global variables, and transfers Ether back to the caller.
76 	function withdraw() public {
77 		// Retrieve the dividends associated with the address the request came from.
78 		var balance = dividends(msg.sender);
79 		
80 		// Update the payouts array, incrementing the request address by `balance`.
81 		payouts[msg.sender] += (int256) (balance * scaleFactor);
82 		
83 		// Increase the total amount that's been paid out to maintain invariance.
84 		totalPayouts += (int256) (balance * scaleFactor);
85 		
86 		// Send the dividends to the address that requested the withdraw.
87 		contractBalance = sub(contractBalance, balance);
88 		msg.sender.transfer(balance);
89 	}
90 
91 	// Converts the Ether accrued as dividends back into NPY tokens without having to
92 	// withdraw it first. Saves on gas and potential price spike loss.
93 	function reinvestDividends() public {
94 		// Retrieve the dividends associated with the address the request came from.
95 		var balance = dividends(msg.sender);
96 		
97 		// Update the payouts array, incrementing the request address by `balance`.
98 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
99 		payouts[msg.sender] += (int256) (balance * scaleFactor);
100 		
101 		// Increase the total amount that's been paid out to maintain invariance.
102 		totalPayouts += (int256) (balance * scaleFactor);
103 		
104 		// Assign balance to a new variable.
105 		uint value_ = (uint) (balance);
106 		
107 		// If your dividends are worth less than 1 szabo, or more than a million Ether
108 		// (in which case, why are you even here), abort.
109 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
110 			revert();
111 			
112 		// msg.sender is the address of the caller.
113 		var sender = msg.sender;
114 		
115 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
116 		// (Yes, the buyer receives a part of the distribution as well!)
117 		var res = reserve() - balance;
118 
119 		// 10% of the total Ether sent is used to pay existing holders.
120 		var fee = div(value_, 10);
121 		
122 		// The amount of Ether used to purchase new tokens for the caller.
123 		var numEther = value_ - fee;
124 		
125 		// The number of tokens which can be purchased for numEther.
126 		var numTokens = calculateDividendTokens(numEther, balance);
127 		
128 		// The buyer fee, scaled by the scaleFactor variable.
129 		var buyerFee = fee * scaleFactor;
130 		
131 		// Check that we have tokens in existence (this should always be true), or
132 		// else you're gonna have a bad time.
133 		if (totalSupply > 0) {
134 			// Compute the bonus co-efficient for all existing holders and the buyer.
135 			// The buyer receives part of the distribution for each token bought in the
136 			// same way they would have if they bought each token individually.
137 			var bonusCoEff =
138 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
139 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
140 				
141 			// The total reward to be distributed amongst the masses is the fee (in Ether)
142 			// multiplied by the bonus co-efficient.
143 			var holderReward = fee * bonusCoEff;
144 			
145 			buyerFee -= holderReward;
146 
147 			// Fee is distributed to all existing token holders before the new tokens are purchased.
148 			// rewardPerShare is the amount gained per token thanks to this buy-in.
149 			var rewardPerShare = holderReward / totalSupply;
150 			
151 			// The Ether value per token is increased proportionally.
152 			earningsPerToken += rewardPerShare;
153 		}
154 		
155 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
156 		totalSupply = add(totalSupply, numTokens);
157 		
158 		// Assign the tokens to the balance of the buyer.
159 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
160 		
161 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
162 		// Also include the fee paid for entering the scheme.
163 		// First we compute how much was just paid out to the buyer...
164 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
165 		
166 		// Then we update the payouts array for the buyer with this amount...
167 		payouts[sender] += payoutDiff;
168 		
169 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
170 		totalPayouts    += payoutDiff;
171 		
172 	}
173 
174 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
175 	// in the tokenBalance array, and therefore is shown as a dividend. A second
176 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
177 	function sellMyTokens() public {
178 		var balance = balanceOf(msg.sender);
179 		sell(balance);
180 	}
181 
182 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
183 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
184     function getMeOutOfHere() public {
185 		sellMyTokens();
186         withdraw();
187 	}
188 
189 	// Gatekeeper function to check if the amount of Ether being sent isn't either
190 	// too small or too large. If it passes, goes direct to buy().
191 	function fund() payable public {
192 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
193 		if (msg.value > 0.000001 ether) {
194 		    contractBalance = add(contractBalance, msg.value);
195 			buy();
196 		} else {
197 			revert();
198 		}
199     }
200 
201 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
202 	function buyPrice() public constant returns (uint) {
203 		return getTokensForEther(1 finney);
204 	}
205 
206 	// Function that returns the (dynamic) price of selling a single token.
207 	function sellPrice() public constant returns (uint) {
208         var eth = getEtherForTokens(1 finney);
209         var fee = div(eth, 10);
210         return eth - fee;
211     }
212 
213 	// Calculate the current dividends associated with the caller address. This is the net result
214 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
215 	// Ether that has already been paid out.
216 	function dividends(address _owner) public constant returns (uint256 amount) {
217 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
218 	}
219 
220 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
221 	// This is only used in the case when there is no transaction data, and that should be
222 	// quite rare unless interacting directly with the smart contract.
223 	function withdrawOld(address to) public {
224 		// Retrieve the dividends associated with the address the request came from.
225 		var balance = dividends(msg.sender);
226 		
227 		// Update the payouts array, incrementing the request address by `balance`.
228 		payouts[msg.sender] += (int256) (balance * scaleFactor);
229 		
230 		// Increase the total amount that's been paid out to maintain invariance.
231 		totalPayouts += (int256) (balance * scaleFactor);
232 		
233 		// Send the dividends to the address that requested the withdraw.
234 		contractBalance = sub(contractBalance, balance);
235 		to.transfer(balance);		
236 	}
237 
238 	// Internal balance function, used to calculate the dynamic reserve value.
239 	function balance() internal constant returns (uint256 amount) {
240 		// msg.value is the amount of Ether sent by the transaction.
241 		return contractBalance - msg.value;
242 	}
243 
244 	function buy() internal {
245 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
246 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
247 			revert();
248 						
249 		// msg.sender is the address of the caller.
250 		var sender = msg.sender;
251 		
252 		// 10% of the total Ether sent is used to pay existing holders.
253 		var fee = div(msg.value, 10);
254 		
255 		// The amount of Ether used to purchase new tokens for the caller.
256 		var numEther = msg.value - fee;
257 		
258 		// The number of tokens which can be purchased for numEther.
259 		var numTokens = getTokensForEther(numEther);
260 		
261 		// The buyer fee, scaled by the scaleFactor variable.
262 		var buyerFee = fee * scaleFactor;
263 		
264 		// Check that we have tokens in existence (this should always be true), or
265 		// else you're gonna have a bad time.
266 		if (totalSupply > 0) {
267 			// Compute the bonus co-efficient for all existing holders and the buyer.
268 			// The buyer receives part of the distribution for each token bought in the
269 			// same way they would have if they bought each token individually.
270 			var bonusCoEff =
271 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
272 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
273 				
274 			// The total reward to be distributed amongst the masses is the fee (in Ether)
275 			// multiplied by the bonus co-efficient.
276 			var holderReward = fee * bonusCoEff;
277 			
278 			buyerFee -= holderReward;
279 
280 			// Fee is distributed to all existing token holders before the new tokens are purchased.
281 			// rewardPerShare is the amount gained per token thanks to this buy-in.
282 			var rewardPerShare = holderReward / totalSupply;
283 			
284 			// The Ether value per token is increased proportionally.
285 			earningsPerToken += rewardPerShare;
286 			
287 		}
288 
289 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
290 		totalSupply = add(totalSupply, numTokens);
291 
292 		// Assign the tokens to the balance of the buyer.
293 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
294 
295 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
296 		// Also include the fee paid for entering the scheme.
297 		// First we compute how much was just paid out to the buyer...
298 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
299 		
300 		// Then we update the payouts array for the buyer with this amount...
301 		payouts[sender] += payoutDiff;
302 		
303 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
304 		totalPayouts    += payoutDiff;
305 		
306 	}
307 
308 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
309 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
310 	// will be *significant*.
311 	function sell(uint256 amount) internal {
312 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
313 		var numEthersBeforeFee = getEtherForTokens(amount);
314 		
315 		// 10% of the resulting Ether is used to pay remaining holders.
316         var fee = div(numEthersBeforeFee, 10);
317 		
318 		// Net Ether for the seller after the fee has been subtracted.
319         var numEthers = numEthersBeforeFee - fee;
320 		
321 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
322 		totalSupply = sub(totalSupply, amount);
323 		
324         // Remove the tokens from the balance of the buyer.
325 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
326 
327         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
328 		// First we compute how much was just paid out to the seller...
329 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
330 		
331         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
332 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
333 		// they decide to buy back in.
334 		payouts[msg.sender] -= payoutDiff;		
335 		
336 		// Decrease the total amount that's been paid out to maintain invariance.
337         totalPayouts -= payoutDiff;
338 		
339 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
340 		// selling tokens, but it guards against division by zero).
341 		if (totalSupply > 0) {
342 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
343 			var etherFee = fee * scaleFactor;
344 			
345 			// Fee is distributed to all remaining token holders.
346 			// rewardPerShare is the amount gained per token thanks to this sell.
347 			var rewardPerShare = etherFee / totalSupply;
348 			
349 			// The Ether value per token is increased proportionally.
350 			earningsPerToken = add(earningsPerToken, rewardPerShare);
351 		}
352 	}
353 	
354 	// Dynamic value of Ether in reserve, according to the CRR requirement.
355 	function reserve() internal constant returns (uint256 amount) {
356 		return sub(balance(),
357 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
358 	}
359 
360 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
361 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
362 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
363 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
364 	}
365 
366 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
367 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
368 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
369 	}
370 
371 	// Converts a number tokens into an Ether value.
372 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
373 		// How much reserve Ether do we have left in the contract?
374 		var reserveAmount = reserve();
375 
376 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
377 		if (tokens == totalSupply)
378 			return reserveAmount;
379 
380 		// If there would be excess Ether left after the transaction this is called within, return the Ether
381 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
382 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
383 		// and denominator altered to 1 and 2 respectively.
384 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
385 	}
386 
387 	// You don't care about these, but if you really do they're hex values for 
388 	// co-efficients used to simulate approximations of the log and exp functions.
389 	int256  constant one        = 0x10000000000000000;
390 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
391 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
392 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
393 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
394 	int256  constant c1         = 0x1ffffffffff9dac9b;
395 	int256  constant c3         = 0x0aaaaaaac16877908;
396 	int256  constant c5         = 0x0666664e5e9fa0c99;
397 	int256  constant c7         = 0x049254026a7630acf;
398 	int256  constant c9         = 0x038bd75ed37753d68;
399 	int256  constant c11        = 0x03284a0c14610924f;
400 
401 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
402 	// approximates the function log(1+x)-log(1-x)
403 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
404 	function fixedLog(uint256 a) internal pure returns (int256 log) {
405 		int32 scale = 0;
406 		while (a > sqrt2) {
407 			a /= 2;
408 			scale++;
409 		}
410 		while (a <= sqrtdot5) {
411 			a *= 2;
412 			scale--;
413 		}
414 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
415 		var z = (s*s) / one;
416 		return scale * ln2 +
417 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
418 				/one))/one))/one))/one))/one);
419 	}
420 
421 	int256 constant c2 =  0x02aaaaaaaaa015db0;
422 	int256 constant c4 = -0x000b60b60808399d1;
423 	int256 constant c6 =  0x0000455956bccdd06;
424 	int256 constant c8 = -0x000001b893ad04b3a;
425 	
426 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
427 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
428 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
429 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
430 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
431 		a -= scale*ln2;
432 		int256 z = (a*a) / one;
433 		int256 R = ((int256)(2) * one) +
434 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
435 		exp = (uint256) (((R + a) * one) / (R - a));
436 		if (scale >= 0)
437 			exp <<= scale;
438 		else
439 			exp >>= -scale;
440 		return exp;
441 	}
442 	
443 	// The below are safemath implementations of the four arithmetic operators
444 	// designed to explicitly prevent over- and under-flows of integer values.
445 
446 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
447 		if (a == 0) {
448 			return 0;
449 		}
450 		uint256 c = a * b;
451 		assert(c / a == b);
452 		return c;
453 	}
454 
455 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
456 		// assert(b > 0); // Solidity automatically throws when dividing by 0
457 		uint256 c = a / b;
458 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
459 		return c;
460 	}
461 
462 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
463 		assert(b <= a);
464 		return a - b;
465 	}
466 
467 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
468 		uint256 c = a + b;
469 		assert(c >= a);
470 		return c;
471 	}
472 
473 	// This allows you to buy tokens by sending Ether directly to the smart contract
474 	// without including any transaction data (useful for, say, mobile wallet apps).
475 	function () payable public {
476 		// msg.value is the amount of Ether sent by the transaction.
477 		if (msg.value > 0) {
478 			fund();
479 		} else {
480 			withdrawOld(msg.sender);
481 		}
482 	}
483 }