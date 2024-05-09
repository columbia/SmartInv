1 pragma solidity ^0.4.18;
2 /*
3 
4           ,/`.
5         ,'/ __`.
6       ,'_/_  _ _`.
7     ,'__/_ ___ _  `.
8   ,'_  /___ __ _ __ `.
9  '-.._/___...-"-.-..__`.
10 
11 A shameless clone of ETHphoenix
12  
13 Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
14 
15 Special Thanks to
16  Developers:
17 	Arc
18 	Divine
19 	Norsefire
20 	ToCsIcK
21  
22 */
23 
24 contract TemporaryPyramid {
25 
26 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
27 	// orders of magnitude, hence the need to bridge between the two.
28 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
29 
30 	// CRR = 50%
31 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
32 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
33 	int constant crr_n = 1; // CRR numerator
34 	int constant crr_d = 2; // CRR denominator
35 
36 	// The price coefficient. Chosen such that at 1 token total supply
37 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
38 	int constant price_coeff = -0x296ABF784A358468C;
39 
40 	// Typical values that we have to declare.
41 	string constant public name = "TemPyr";
42 	string constant public symbol = "TPY";
43 	uint8 constant public decimals = 18;
44 
45 	// Array between each address and their number of tokens.
46 	mapping(address => uint256) public tokenBalance;
47 		
48 	// Array between each address and how much Ether has been paid out to it.
49 	// Note that this is scaled by the scaleFactor variable.
50 	mapping(address => int256) public payouts;
51 
52 	// Variable tracking how many tokens are in existence overall.
53 	uint256 public totalSupply;
54 
55 	// Aggregate sum of all payouts.
56 	// Note that this is scaled by the scaleFactor variable.
57 	int256 totalPayouts;
58 
59 	// Variable tracking how much Ether each token is currently worth.
60 	// Note that this is scaled by the scaleFactor variable.
61 	uint256 earningsPerToken;
62 	
63 	// Current contract balance in Ether
64 	uint256 public contractBalance;
65 
66 	function TemporaryPyramid() public {}
67 
68 	// The following functions are used by the front-end for display purposes.
69 
70 	// Returns the number of tokens currently held by _owner.
71 	function balanceOf(address _owner) public constant returns (uint256 balance) {
72 		return tokenBalance[_owner];
73 	}
74 
75 	// Withdraws all dividends held by the caller sending the transaction, updates
76 	// the requisite global variables, and transfers Ether back to the caller.
77 	function withdraw() public {
78 		// Retrieve the dividends associated with the address the request came from.
79 		var balance = dividends(msg.sender);
80 		
81 		// Update the payouts array, incrementing the request address by `balance`.
82 		payouts[msg.sender] += (int256) (balance * scaleFactor);
83 		
84 		// Increase the total amount that's been paid out to maintain invariance.
85 		totalPayouts += (int256) (balance * scaleFactor);
86 		
87 		// Send the dividends to the address that requested the withdraw.
88 		contractBalance = sub(contractBalance, balance);
89 		msg.sender.transfer(balance);
90 	}
91 
92 	// Converts the Ether accrued as dividends back into EPY tokens without having to
93 	// withdraw it first. Saves on gas and potential price spike loss.
94 	function reinvestDividends() public {
95 		// Retrieve the dividends associated with the address the request came from.
96 		var balance = dividends(msg.sender);
97 		
98 		// Update the payouts array, incrementing the request address by `balance`.
99 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
100 		payouts[msg.sender] += (int256) (balance * scaleFactor);
101 		
102 		// Increase the total amount that's been paid out to maintain invariance.
103 		totalPayouts += (int256) (balance * scaleFactor);
104 		
105 		// Assign balance to a new variable.
106 		uint value_ = (uint) (balance);
107 		
108 		// If your dividends are worth less than 1 szabo, or more than a million Ether
109 		// (in which case, why are you even here), abort.
110 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
111 			revert();
112 			
113 		// msg.sender is the address of the caller.
114 		var sender = msg.sender;
115 		
116 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
117 		// (Yes, the buyer receives a part of the distribution as well!)
118 		var res = reserve() - balance;
119 
120 		// 10% of the total Ether sent is used to pay existing holders.
121 		var fee = div(value_, 10);
122 		
123 		// The amount of Ether used to purchase new tokens for the caller.
124 		var numEther = value_ - fee;
125 		
126 		// The number of tokens which can be purchased for numEther.
127 		var numTokens = calculateDividendTokens(numEther, balance);
128 		
129 		// The buyer fee, scaled by the scaleFactor variable.
130 		var buyerFee = fee * scaleFactor;
131 		
132 		// Check that we have tokens in existence (this should always be true), or
133 		// else you're gonna have a bad time.
134 		if (totalSupply > 0) {
135 			// Compute the bonus co-efficient for all existing holders and the buyer.
136 			// The buyer receives part of the distribution for each token bought in the
137 			// same way they would have if they bought each token individually.
138 			var bonusCoEff =
139 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
140 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
141 				
142 			// The total reward to be distributed amongst the masses is the fee (in Ether)
143 			// multiplied by the bonus co-efficient.
144 			var holderReward = fee * bonusCoEff;
145 			
146 			buyerFee -= holderReward;
147 
148 			// Fee is distributed to all existing token holders before the new tokens are purchased.
149 			// rewardPerShare is the amount gained per token thanks to this buy-in.
150 			var rewardPerShare = holderReward / totalSupply;
151 			
152 			// The Ether value per token is increased proportionally.
153 			earningsPerToken += rewardPerShare;
154 		}
155 		
156 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
157 		totalSupply = add(totalSupply, numTokens);
158 		
159 		// Assign the tokens to the balance of the buyer.
160 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
161 		
162 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
163 		// Also include the fee paid for entering the scheme.
164 		// First we compute how much was just paid out to the buyer...
165 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
166 		
167 		// Then we update the payouts array for the buyer with this amount...
168 		payouts[sender] += payoutDiff;
169 		
170 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
171 		totalPayouts    += payoutDiff;
172 		
173 	}
174 
175 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
176 	// in the tokenBalance array, and therefore is shown as a dividend. A second
177 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
178 	function sellMyTokens() public {
179 		var balance = balanceOf(msg.sender);
180 		sell(balance);
181 	}
182 
183 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
184 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
185     function getMeOutOfHere() public {
186 		sellMyTokens();
187         withdraw();
188 	}
189 
190 	// Gatekeeper function to check if the amount of Ether being sent isn't either
191 	// too small or too large. If it passes, goes direct to buy().
192 	function fund() payable public {
193 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
194 		if (msg.value > 0.000001 ether) {
195 		    contractBalance = add(contractBalance, msg.value);
196 			buy();
197 		} else {
198 			revert();
199 		}
200     }
201 
202 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
203 	function buyPrice() public constant returns (uint) {
204 		return getTokensForEther(1 finney);
205 	}
206 
207 	// Function that returns the (dynamic) price of selling a single token.
208 	function sellPrice() public constant returns (uint) {
209         var eth = getEtherForTokens(1 finney);
210         var fee = div(eth, 10);
211         return eth - fee;
212     }
213 
214 	// Calculate the current dividends associated with the caller address. This is the net result
215 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
216 	// Ether that has already been paid out.
217 	function dividends(address _owner) public constant returns (uint256 amount) {
218 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
219 	}
220 
221 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
222 	// This is only used in the case when there is no transaction data, and that should be
223 	// quite rare unless interacting directly with the smart contract.
224 	function withdrawOld(address to) public {
225 		// Retrieve the dividends associated with the address the request came from.
226 		var balance = dividends(msg.sender);
227 		
228 		// Update the payouts array, incrementing the request address by `balance`.
229 		payouts[msg.sender] += (int256) (balance * scaleFactor);
230 		
231 		// Increase the total amount that's been paid out to maintain invariance.
232 		totalPayouts += (int256) (balance * scaleFactor);
233 		
234 		// Send the dividends to the address that requested the withdraw.
235 		contractBalance = sub(contractBalance, balance);
236 		to.transfer(balance);		
237 	}
238 
239 	// Internal balance function, used to calculate the dynamic reserve value.
240 	function balance() internal constant returns (uint256 amount) {
241 		// msg.value is the amount of Ether sent by the transaction.
242 		return contractBalance - msg.value;
243 	}
244 
245 	function buy() internal {
246 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
247 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
248 			revert();
249 						
250 		// msg.sender is the address of the caller.
251 		var sender = msg.sender;
252 		
253 		// 10% of the total Ether sent is used to pay existing holders.
254 		var fee = div(msg.value, 10);
255 		
256 		// The amount of Ether used to purchase new tokens for the caller.
257 		var numEther = msg.value - fee;
258 		
259 		// The number of tokens which can be purchased for numEther.
260 		var numTokens = getTokensForEther(numEther);
261 		
262 		// The buyer fee, scaled by the scaleFactor variable.
263 		var buyerFee = fee * scaleFactor;
264 		
265 		// Check that we have tokens in existence (this should always be true), or
266 		// else you're gonna have a bad time.
267 		if (totalSupply > 0) {
268 			// Compute the bonus co-efficient for all existing holders and the buyer.
269 			// The buyer receives part of the distribution for each token bought in the
270 			// same way they would have if they bought each token individually.
271 			var bonusCoEff =
272 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
273 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
274 				
275 			// The total reward to be distributed amongst the masses is the fee (in Ether)
276 			// multiplied by the bonus co-efficient.
277 			var holderReward = fee * bonusCoEff;
278 			
279 			buyerFee -= holderReward;
280 
281 			// Fee is distributed to all existing token holders before the new tokens are purchased.
282 			// rewardPerShare is the amount gained per token thanks to this buy-in.
283 			var rewardPerShare = holderReward / totalSupply;
284 			
285 			// The Ether value per token is increased proportionally.
286 			earningsPerToken += rewardPerShare;
287 			
288 		}
289 
290 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
291 		totalSupply = add(totalSupply, numTokens);
292 
293 		// Assign the tokens to the balance of the buyer.
294 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
295 
296 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
297 		// Also include the fee paid for entering the scheme.
298 		// First we compute how much was just paid out to the buyer...
299 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
300 		
301 		// Then we update the payouts array for the buyer with this amount...
302 		payouts[sender] += payoutDiff;
303 		
304 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
305 		totalPayouts    += payoutDiff;
306 		
307 	}
308 
309 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
310 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
311 	// will be *significant*.
312 	function sell(uint256 amount) internal {
313 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
314 		var numEthersBeforeFee = getEtherForTokens(amount);
315 		
316 		// 10% of the resulting Ether is used to pay remaining holders.
317         var fee = div(numEthersBeforeFee, 10);
318 		
319 		// Net Ether for the seller after the fee has been subtracted.
320         var numEthers = numEthersBeforeFee - fee;
321 		
322 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
323 		totalSupply = sub(totalSupply, amount);
324 		
325         // Remove the tokens from the balance of the buyer.
326 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
327 
328         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
329 		// First we compute how much was just paid out to the seller...
330 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
331 		
332         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
333 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
334 		// they decide to buy back in.
335 		payouts[msg.sender] -= payoutDiff;		
336 		
337 		// Decrease the total amount that's been paid out to maintain invariance.
338         totalPayouts -= payoutDiff;
339 		
340 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
341 		// selling tokens, but it guards against division by zero).
342 		if (totalSupply > 0) {
343 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
344 			var etherFee = fee * scaleFactor;
345 			
346 			// Fee is distributed to all remaining token holders.
347 			// rewardPerShare is the amount gained per token thanks to this sell.
348 			var rewardPerShare = etherFee / totalSupply;
349 			
350 			// The Ether value per token is increased proportionally.
351 			earningsPerToken = add(earningsPerToken, rewardPerShare);
352 		}
353 	}
354 	
355 	// Dynamic value of Ether in reserve, according to the CRR requirement.
356 	function reserve() internal constant returns (uint256 amount) {
357 		return sub(balance(),
358 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
359 	}
360 
361 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
362 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
363 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
364 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
365 	}
366 
367 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
368 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
369 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
370 	}
371 
372 	// Converts a number tokens into an Ether value.
373 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
374 		// How much reserve Ether do we have left in the contract?
375 		var reserveAmount = reserve();
376 
377 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
378 		if (tokens == totalSupply)
379 			return reserveAmount;
380 
381 		// If there would be excess Ether left after the transaction this is called within, return the Ether
382 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
383 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
384 		// and denominator altered to 1 and 2 respectively.
385 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
386 	}
387 
388 	// You don't care about these, but if you really do they're hex values for 
389 	// co-efficients used to simulate approximations of the log and exp functions.
390 	int256  constant one        = 0x10000000000000000;
391 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
392 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
393 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
394 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
395 	int256  constant c1         = 0x1ffffffffff9dac9b;
396 	int256  constant c3         = 0x0aaaaaaac16877908;
397 	int256  constant c5         = 0x0666664e5e9fa0c99;
398 	int256  constant c7         = 0x049254026a7630acf;
399 	int256  constant c9         = 0x038bd75ed37753d68;
400 	int256  constant c11        = 0x03284a0c14610924f;
401 
402 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
403 	// approximates the function log(1+x)-log(1-x)
404 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
405 	function fixedLog(uint256 a) internal pure returns (int256 log) {
406 		int32 scale = 0;
407 		while (a > sqrt2) {
408 			a /= 2;
409 			scale++;
410 		}
411 		while (a <= sqrtdot5) {
412 			a *= 2;
413 			scale--;
414 		}
415 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
416 		var z = (s*s) / one;
417 		return scale * ln2 +
418 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
419 				/one))/one))/one))/one))/one);
420 	}
421 
422 	int256 constant c2 =  0x02aaaaaaaaa015db0;
423 	int256 constant c4 = -0x000b60b60808399d1;
424 	int256 constant c6 =  0x0000455956bccdd06;
425 	int256 constant c8 = -0x000001b893ad04b3a;
426 	
427 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
428 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
429 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
430 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
431 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
432 		a -= scale*ln2;
433 		int256 z = (a*a) / one;
434 		int256 R = ((int256)(2) * one) +
435 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
436 		exp = (uint256) (((R + a) * one) / (R - a));
437 		if (scale >= 0)
438 			exp <<= scale;
439 		else
440 			exp >>= -scale;
441 		return exp;
442 	}
443 	
444 	// The below are safemath implementations of the four arithmetic operators
445 	// designed to explicitly prevent over- and under-flows of integer values.
446 
447 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
448 		if (a == 0) {
449 			return 0;
450 		}
451 		uint256 c = a * b;
452 		assert(c / a == b);
453 		return c;
454 	}
455 
456 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
457 		// assert(b > 0); // Solidity automatically throws when dividing by 0
458 		uint256 c = a / b;
459 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
460 		return c;
461 	}
462 
463 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
464 		assert(b <= a);
465 		return a - b;
466 	}
467 
468 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
469 		uint256 c = a + b;
470 		assert(c >= a);
471 		return c;
472 	}
473 
474 	// This allows you to buy tokens by sending Ether directly to the smart contract
475 	// without including any transaction data (useful for, say, mobile wallet apps).
476 	function () payable public {
477 		// msg.value is the amount of Ether sent by the transaction.
478 		if (msg.value > 0) {
479 			fund();
480 		} else {
481 			withdrawOld(msg.sender);
482 		}
483 	}
484 }