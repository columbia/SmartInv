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
12 This is a PONZI Crypto-GAME and >>NOT<< an investment opportunity! 
13 It illustrate the functionallities and possibilities of smart 
14 contracts and was just deployed for testing. 
15  
16  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
17 
18 */
19 
20 contract EthPyramid_Shadow {
21 
22 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
23 	// orders of magnitude, hence the need to bridge between the two.
24 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
25 
26 	// CRR = 50%
27 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
28 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
29 	int constant crr_n = 1; // CRR numerator
30 	int constant crr_d = 2; // CRR denominator
31 
32 	// The price coefficient. Chosen such that at 1 token total supply
33 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
34 	int constant price_coeff = -0x296ABF784A358468C;
35 
36 	// Typical values that we have to declare.
37 	string constant public name = "EthPyramid_Shadow";
38 	string constant public symbol = "EPTS";
39 	uint8 constant public decimals = 18;
40 
41 	// Array between each address and their number of tokens.
42 	mapping(address => uint256) public tokenBalance;
43 		
44 	// Array between each address and how much Ether has been paid out to it.
45 	// Note that this is scaled by the scaleFactor variable.
46 	mapping(address => int256) public payouts;
47 
48 	// Variable tracking how many tokens are in existence overall.
49 	uint256 public totalSupply;
50 
51 	// Aggregate sum of all payouts.
52 	// Note that this is scaled by the scaleFactor variable.
53 	int256 totalPayouts;
54 
55 	// Variable tracking how much Ether each token is currently worth.
56 	// Note that this is scaled by the scaleFactor variable.
57 	uint256 earningsPerToken;
58 
59 	function EthPyramid() public {}
60 
61 	// The following functions are used by the front-end for display purposes.
62 
63 	// Returns the number of tokens currently held by _owner.
64 	function balanceOf(address _owner) public constant returns (uint256 balance) {
65 		return tokenBalance[_owner];
66 	}
67 
68 	// Withdraws all dividends held by the caller sending the transaction, updates
69 	// the requisite global variables, and transfers Ether back to the caller.
70 	function withdraw() public {
71 		// Retrieve the dividends associated with the address the request came from.
72 		var balance = dividends(msg.sender);
73 		
74 		// Update the payouts array, incrementing the request address by `balance`.
75 		payouts[msg.sender] += (int256) (balance * scaleFactor);
76 		
77 		// Increase the total amount that's been paid out to maintain invariance.
78 		totalPayouts += (int256) (balance * scaleFactor);
79 		
80 		// Send the dividends to the address that requested the withdraw.
81 		msg.sender.transfer(balance);
82 	}
83 
84 	// Converts the Ether accrued as dividends back into EPY tokens without having to
85 	// withdraw it first. Saves on gas and potential price spike loss.
86 	function reinvestDividends() public {
87 		// Retrieve the dividends associated with the address the request came from.
88 		var balance = dividends(msg.sender);
89 		
90 		// Update the payouts array, incrementing the request address by `balance`.
91 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
92 		payouts[msg.sender] += (int256) (balance * scaleFactor);
93 		
94 		// Increase the total amount that's been paid out to maintain invariance.
95 		totalPayouts += (int256) (balance * scaleFactor);
96 		
97 		// Assign balance to a new variable.
98 		uint value_ = (uint) (balance);
99 		
100 		// If your dividends are worth less than 1 szabo, or more than a million Ether
101 		// (in which case, why are you even here), abort.
102 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
103 			revert();
104 			
105 		// msg.sender is the address of the caller.
106 		var sender = msg.sender;
107 		
108 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
109 		// (Yes, the buyer receives a part of the distribution as well!)
110 		var res = reserve() - balance;
111 
112 		// 10% of the total Ether sent is used to pay existing holders.
113 		var fee = div(value_, 10);
114 		
115 		// The amount of Ether used to purchase new tokens for the caller.
116 		var numEther = value_ - fee;
117 		
118 		// The number of tokens which can be purchased for numEther.
119 		var numTokens = calculateDividendTokens(numEther, balance);
120 		
121 		// The buyer fee, scaled by the scaleFactor variable.
122 		var buyerFee = fee * scaleFactor;
123 		
124 		// Check that we have tokens in existence (this should always be true), or
125 		// else you're gonna have a bad time.
126 		if (totalSupply > 0) {
127 			// Compute the bonus co-efficient for all existing holders and the buyer.
128 			// The buyer receives part of the distribution for each token bought in the
129 			// same way they would have if they bought each token individually.
130 			var bonusCoEff =
131 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
132 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
133 				
134 			// The total reward to be distributed amongst the masses is the fee (in Ether)
135 			// multiplied by the bonus co-efficient.
136 			var holderReward = fee * bonusCoEff;
137 			
138 			buyerFee -= holderReward;
139 
140 			// Fee is distributed to all existing token holders before the new tokens are purchased.
141 			// rewardPerShare is the amount gained per token thanks to this buy-in.
142 			var rewardPerShare = holderReward / totalSupply;
143 			
144 			// The Ether value per token is increased proportionally.
145 			earningsPerToken += rewardPerShare;
146 		}
147 		
148 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
149 		totalSupply = add(totalSupply, numTokens);
150 		
151 		// Assign the tokens to the balance of the buyer.
152 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
153 		
154 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
155 		// Also include the fee paid for entering the scheme.
156 		// First we compute how much was just paid out to the buyer...
157 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
158 		
159 		// Then we update the payouts array for the buyer with this amount...
160 		payouts[sender] += payoutDiff;
161 		
162 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
163 		totalPayouts    += payoutDiff;
164 		
165 	}
166 
167 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
168 	// in the tokenBalance array, and therefore is shown as a dividend. A second
169 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
170 	function sellMyTokens() public {
171 		var balance = balanceOf(msg.sender);
172 		sell(balance);
173 	}
174 
175 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
176 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
177     function getMeOutOfHere() public {
178 		sellMyTokens();
179         withdraw();
180 	}
181 
182 	// Gatekeeper function to check if the amount of Ether being sent isn't either
183 	// too small or too large. If it passes, goes direct to buy().
184 	function fund() payable public {
185 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
186 		if (msg.value > 0.000001 ether) {
187 			buy();
188 		} else {
189 			revert();
190 		}
191     }
192 
193 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
194 	function buyPrice() public constant returns (uint) {
195 		return getTokensForEther(1 finney);
196 	}
197 
198 	// Function that returns the (dynamic) price of selling a single token.
199 	function sellPrice() public constant returns (uint) {
200         var eth = getEtherForTokens(1 finney);
201         var fee = div(eth, 10);
202         return eth - fee;
203     }
204 
205 	// Calculate the current dividends associated with the caller address. This is the net result
206 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
207 	// Ether that has already been paid out.
208 	function dividends(address _owner) public constant returns (uint256 amount) {
209 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
210 	}
211 
212 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
213 	// This is only used in the case when there is no transaction data, and that should be
214 	// quite rare unless interacting directly with the smart contract.
215 	function withdrawOld(address to) public {
216 		// Retrieve the dividends associated with the address the request came from.
217 		var balance = dividends(msg.sender);
218 		
219 		// Update the payouts array, incrementing the request address by `balance`.
220 		payouts[msg.sender] += (int256) (balance * scaleFactor);
221 		
222 		// Increase the total amount that's been paid out to maintain invariance.
223 		totalPayouts += (int256) (balance * scaleFactor);
224 		
225 		// Send the dividends to the address that requested the withdraw.
226 		to.transfer(balance);
227 	}
228 
229 	// Internal balance function, used to calculate the dynamic reserve value.
230 	function balance() internal constant returns (uint256 amount) {
231 		// msg.value is the amount of Ether sent by the transaction.
232 		return this.balance - msg.value;
233 	}
234 
235 	function buy() internal {
236 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
237 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
238 			revert();
239 			
240 		// msg.sender is the address of the caller.
241 		var sender = msg.sender;
242 		
243 		// 10% of the total Ether sent is used to pay existing holders.
244 		var fee = div(msg.value, 10);
245 		
246 		// The amount of Ether used to purchase new tokens for the caller.
247 		var numEther = msg.value - fee;
248 		
249 		// The number of tokens which can be purchased for numEther.
250 		var numTokens = getTokensForEther(numEther);
251 		
252 		// The buyer fee, scaled by the scaleFactor variable.
253 		var buyerFee = fee * scaleFactor;
254 		
255 		// Check that we have tokens in existence (this should always be true), or
256 		// else you're gonna have a bad time.
257 		if (totalSupply > 0) {
258 			// Compute the bonus co-efficient for all existing holders and the buyer.
259 			// The buyer receives part of the distribution for each token bought in the
260 			// same way they would have if they bought each token individually.
261 			var bonusCoEff =
262 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
263 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
264 				
265 			// The total reward to be distributed amongst the masses is the fee (in Ether)
266 			// multiplied by the bonus co-efficient.
267 			var holderReward = fee * bonusCoEff;
268 			
269 			buyerFee -= holderReward;
270 
271 			// Fee is distributed to all existing token holders before the new tokens are purchased.
272 			// rewardPerShare is the amount gained per token thanks to this buy-in.
273 			var rewardPerShare = holderReward / totalSupply;
274 			
275 			// The Ether value per token is increased proportionally.
276 			earningsPerToken += rewardPerShare;
277 			
278 		}
279 
280 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
281 		totalSupply = add(totalSupply, numTokens);
282 
283 		// Assign the tokens to the balance of the buyer.
284 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
285 
286 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
287 		// Also include the fee paid for entering the scheme.
288 		// First we compute how much was just paid out to the buyer...
289 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
290 		
291 		// Then we update the payouts array for the buyer with this amount...
292 		payouts[sender] += payoutDiff;
293 		
294 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
295 		totalPayouts    += payoutDiff;
296 		
297 	}
298 
299 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
300 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
301 	// will be *significant*.
302 	function sell(uint256 amount) internal {
303 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
304 		var numEthersBeforeFee = getEtherForTokens(amount);
305 		
306 		// 10% of the resulting Ether is used to pay remaining holders.
307         var fee = div(numEthersBeforeFee, 10);
308 		
309 		// Net Ether for the seller after the fee has been subtracted.
310         var numEthers = numEthersBeforeFee - fee;
311 		
312 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
313 		totalSupply = sub(totalSupply, amount);
314 		
315         // Remove the tokens from the balance of the buyer.
316 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
317 
318         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
319 		// First we compute how much was just paid out to the seller...
320 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
321 		
322         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
323 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
324 		// they decide to buy back in.
325 		payouts[msg.sender] -= payoutDiff;		
326 		
327 		// Decrease the total amount that's been paid out to maintain invariance.
328         totalPayouts -= payoutDiff;
329 		
330 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
331 		// selling tokens, but it guards against division by zero).
332 		if (totalSupply > 0) {
333 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
334 			var etherFee = fee * scaleFactor;
335 			
336 			// Fee is distributed to all remaining token holders.
337 			// rewardPerShare is the amount gained per token thanks to this sell.
338 			var rewardPerShare = etherFee / totalSupply;
339 			
340 			// The Ether value per token is increased proportionally.
341 			earningsPerToken = add(earningsPerToken, rewardPerShare);
342 		}
343 	}
344 	
345 	// Dynamic value of Ether in reserve, according to the CRR requirement.
346 	function reserve() internal constant returns (uint256 amount) {
347 		return sub(balance(),
348 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
349 	}
350 
351 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
352 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
353 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
354 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
355 	}
356 
357 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
358 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
359 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
360 	}
361 
362 	// Converts a number tokens into an Ether value.
363 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
364 		// How much reserve Ether do we have left in the contract?
365 		var reserveAmount = reserve();
366 
367 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
368 		if (tokens == totalSupply)
369 			return reserveAmount;
370 
371 		// If there would be excess Ether left after the transaction this is called within, return the Ether
372 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
373 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
374 		// and denominator altered to 1 and 2 respectively.
375 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
376 	}
377 
378 	// You don't care about these, but if you really do they're hex values for 
379 	// co-efficients used to simulate approximations of the log and exp functions.
380 	int256  constant one        = 0x10000000000000000;
381 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
382 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
383 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
384 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
385 	int256  constant c1         = 0x1ffffffffff9dac9b;
386 	int256  constant c3         = 0x0aaaaaaac16877908;
387 	int256  constant c5         = 0x0666664e5e9fa0c99;
388 	int256  constant c7         = 0x049254026a7630acf;
389 	int256  constant c9         = 0x038bd75ed37753d68;
390 	int256  constant c11        = 0x03284a0c14610924f;
391 
392 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
393 	// approximates the function log(1+x)-log(1-x)
394 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
395 	function fixedLog(uint256 a) internal pure returns (int256 log) {
396 		int32 scale = 0;
397 		while (a > sqrt2) {
398 			a /= 2;
399 			scale++;
400 		}
401 		while (a <= sqrtdot5) {
402 			a *= 2;
403 			scale--;
404 		}
405 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
406 		var z = (s*s) / one;
407 		return scale * ln2 +
408 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
409 				/one))/one))/one))/one))/one);
410 	}
411 
412 	int256 constant c2 =  0x02aaaaaaaaa015db0;
413 	int256 constant c4 = -0x000b60b60808399d1;
414 	int256 constant c6 =  0x0000455956bccdd06;
415 	int256 constant c8 = -0x000001b893ad04b3a;
416 	
417 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
418 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
419 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
420 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
421 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
422 		a -= scale*ln2;
423 		int256 z = (a*a) / one;
424 		int256 R = ((int256)(2) * one) +
425 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
426 		exp = (uint256) (((R + a) * one) / (R - a));
427 		if (scale >= 0)
428 			exp <<= scale;
429 		else
430 			exp >>= -scale;
431 		return exp;
432 	}
433 	
434 	// The below are safemath implementations of the four arithmetic operators
435 	// designed to explicitly prevent over- and under-flows of integer values.
436 
437 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
438 		if (a == 0) {
439 			return 0;
440 		}
441 		uint256 c = a * b;
442 		assert(c / a == b);
443 		return c;
444 	}
445 
446 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
447 		// assert(b > 0); // Solidity automatically throws when dividing by 0
448 		uint256 c = a / b;
449 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
450 		return c;
451 	}
452 
453 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
454 		assert(b <= a);
455 		return a - b;
456 	}
457 
458 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
459 		uint256 c = a + b;
460 		assert(c >= a);
461 		return c;
462 	}
463 
464 	// This allows you to buy tokens by sending Ether directly to the smart contract
465 	// without including any transaction data (useful for, say, mobile wallet apps).
466 	function () payable public {
467 		// msg.value is the amount of Ether sent by the transaction.
468 		if (msg.value > 0) {
469 			fund();
470 		} else {
471 			withdrawOld(msg.sender);
472 		}
473 	}
474 }