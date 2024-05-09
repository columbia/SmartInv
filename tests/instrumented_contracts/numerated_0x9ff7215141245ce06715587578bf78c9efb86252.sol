1 pragma solidity ^0.4.19;
2 
3 /*
4 
5  To exit and withdraw balance add to transaction data: 0xb1e35242 
6 
7           ,/`.
8          '/ __`.
9        ,'_/_ _ _`.
10        EthPyramid2
11     ,'__/_ ____ _  `.
12   ,'_  /___ __ __ __ `.
13  '-.._/____...-"-.-..__`.
14 
15 This is a PONZI Crypto-GAME and >>NOT<< an investment opportunity! 
16 
17 It illustrate the functionallities and possibilities of smart 
18 contracts and was just deployed for testing. 
19  
20  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
21  
22 
23 */
24 
25 contract EthPyramid2 {
26 
27 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
28 	// orders of magnitude, hence the need to bridge between the two.
29 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
30 
31 	// CRR = 50%
32 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
33 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
34 	int constant crr_n = 1; // CRR numerator
35 	int constant crr_d = 2; // CRR denominator
36 
37 	// The price coefficient. Chosen such that at 1 token total supply
38 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
39 	int constant price_coeff = -0x296ABF784A358468C;
40 
41 	// Typical values that we have to declare.
42 	string constant public name = "EthPyramid2";
43 	string constant public symbol = "EPY2";
44 	uint8 constant public decimals = 18;
45 
46 	// Array between each address and their number of tokens.
47 	mapping(address => uint256) public tokenBalance;
48 		
49 	// Array between each address and how much Ether has been paid out to it.
50 	// Note that this is scaled by the scaleFactor variable.
51 	mapping(address => int256) public payouts;
52 
53 	// Variable tracking how many tokens are in existence overall.
54 	uint256 public totalSupply;
55 
56 	// Aggregate sum of all payouts.
57 	// Note that this is scaled by the scaleFactor variable.
58 	int256 totalPayouts;
59 
60 	// Variable tracking how much Ether each token is currently worth.
61 	// Note that this is scaled by the scaleFactor variable.
62 	uint256 earningsPerToken;
63 
64 	function EthPyramid() public {}
65 
66 	// The following functions are used by the front-end for display purposes.
67 
68 	// Returns the number of tokens currently held by _owner.
69 	function balanceOf(address _owner) public constant returns (uint256 balance) {
70 		return tokenBalance[_owner];
71 	}
72 
73 	// Withdraws all dividends held by the caller sending the transaction, updates
74 	// the requisite global variables, and transfers Ether back to the caller.
75 	function withdraw() public {
76 		// Retrieve the dividends associated with the address the request came from.
77 		var balance = dividends(msg.sender);
78 		
79 		// Update the payouts array, incrementing the request address by `balance`.
80 		payouts[msg.sender] += (int256) (balance * scaleFactor);
81 		
82 		// Increase the total amount that's been paid out to maintain invariance.
83 		totalPayouts += (int256) (balance * scaleFactor);
84 		
85 		// Send the dividends to the address that requested the withdraw.
86 		msg.sender.transfer(balance);
87 	}
88 
89 	// Converts the Ether accrued as dividends back into EPY tokens without having to
90 	// withdraw it first. Saves on gas and potential price spike loss.
91 	function reinvestDividends() public {
92 		// Retrieve the dividends associated with the address the request came from.
93 		var balance = dividends(msg.sender);
94 		
95 		// Update the payouts array, incrementing the request address by `balance`.
96 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
97 		payouts[msg.sender] += (int256) (balance * scaleFactor);
98 		
99 		// Increase the total amount that's been paid out to maintain invariance.
100 		totalPayouts += (int256) (balance * scaleFactor);
101 		
102 		// Assign balance to a new variable.
103 		uint value_ = (uint) (balance);
104 		
105 		// If your dividends are worth less than 1 szabo, or more than a million Ether
106 		// (in which case, why are you even here), abort.
107 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
108 			revert();
109 			
110 		// msg.sender is the address of the caller.
111 		var sender = msg.sender;
112 		
113 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
114 		// (Yes, the buyer receives a part of the distribution as well!)
115 		var res = reserve() - balance;
116 
117 		// 10% of the total Ether sent is used to pay existing holders.
118 		var fee = div(value_, 10);
119 		
120 		// The amount of Ether used to purchase new tokens for the caller.
121 		var numEther = value_ - fee;
122 		
123 		// The number of tokens which can be purchased for numEther.
124 		var numTokens = calculateDividendTokens(numEther, balance);
125 		
126 		// The buyer fee, scaled by the scaleFactor variable.
127 		var buyerFee = fee * scaleFactor;
128 		
129 		// Check that we have tokens in existence (this should always be true), or
130 		// else you're gonna have a bad time.
131 		if (totalSupply > 0) {
132 			// Compute the bonus co-efficient for all existing holders and the buyer.
133 			// The buyer receives part of the distribution for each token bought in the
134 			// same way they would have if they bought each token individually.
135 			var bonusCoEff =
136 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
137 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
138 				
139 			// The total reward to be distributed amongst the masses is the fee (in Ether)
140 			// multiplied by the bonus co-efficient.
141 			var holderReward = fee * bonusCoEff;
142 			
143 			buyerFee -= holderReward;
144 
145 			// Fee is distributed to all existing token holders before the new tokens are purchased.
146 			// rewardPerShare is the amount gained per token thanks to this buy-in.
147 			var rewardPerShare = holderReward / totalSupply;
148 			
149 			// The Ether value per token is increased proportionally.
150 			earningsPerToken += rewardPerShare;
151 		}
152 		
153 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
154 		totalSupply = add(totalSupply, numTokens);
155 		
156 		// Assign the tokens to the balance of the buyer.
157 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
158 		
159 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
160 		// Also include the fee paid for entering the scheme.
161 		// First we compute how much was just paid out to the buyer...
162 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
163 		
164 		// Then we update the payouts array for the buyer with this amount...
165 		payouts[sender] += payoutDiff;
166 		
167 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
168 		totalPayouts    += payoutDiff;
169 		
170 	}
171 
172 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
173 	// in the tokenBalance array, and therefore is shown as a dividend. A second
174 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
175 	function sellMyTokens() public {
176 		var balance = balanceOf(msg.sender);
177 		sell(balance);
178 	}
179 
180 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
181 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
182     function getMeOutOfHere() public {
183 		sellMyTokens();
184         withdraw();
185 	}
186 
187 	// Gatekeeper function to check if the amount of Ether being sent isn't either
188 	// too small or too large. If it passes, goes direct to buy().
189 	function fund() payable public {
190 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
191 		if (msg.value > 0.000001 ether) {
192 			buy();
193 		} else {
194 			revert();
195 		}
196     }
197 
198 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
199 	function buyPrice() public constant returns (uint) {
200 		return getTokensForEther(1 finney);
201 	}
202 
203 	// Function that returns the (dynamic) price of selling a single token.
204 	function sellPrice() public constant returns (uint) {
205         var eth = getEtherForTokens(1 finney);
206         var fee = div(eth, 10);
207         return eth - fee;
208     }
209 
210 	// Calculate the current dividends associated with the caller address. This is the net result
211 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
212 	// Ether that has already been paid out.
213 	function dividends(address _owner) public constant returns (uint256 amount) {
214 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
215 	}
216 
217 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
218 	// This is only used in the case when there is no transaction data, and that should be
219 	// quite rare unless interacting directly with the smart contract.
220 	function withdrawOld(address to) public {
221 		// Retrieve the dividends associated with the address the request came from.
222 		var balance = dividends(msg.sender);
223 		
224 		// Update the payouts array, incrementing the request address by `balance`.
225 		payouts[msg.sender] += (int256) (balance * scaleFactor);
226 		
227 		// Increase the total amount that's been paid out to maintain invariance.
228 		totalPayouts += (int256) (balance * scaleFactor);
229 		
230 		// Send the dividends to the address that requested the withdraw.
231 		to.transfer(balance);
232 	}
233 
234 	// Internal balance function, used to calculate the dynamic reserve value.
235 	function balance() internal constant returns (uint256 amount) {
236 		// msg.value is the amount of Ether sent by the transaction.
237 		return this.balance - msg.value;
238 	}
239 
240 	function buy() internal {
241 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
242 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
243 			revert();
244 			
245 		// msg.sender is the address of the caller.
246 		var sender = msg.sender;
247 		
248 		// 10% of the total Ether sent is used to pay existing holders.
249 		var fee = div(msg.value, 10);
250 		
251 		// The amount of Ether used to purchase new tokens for the caller.
252 		var numEther = msg.value - fee;
253 		
254 		// The number of tokens which can be purchased for numEther.
255 		var numTokens = getTokensForEther(numEther);
256 		
257 		// The buyer fee, scaled by the scaleFactor variable.
258 		var buyerFee = fee * scaleFactor;
259 		
260 		// Check that we have tokens in existence (this should always be true), or
261 		// else you're gonna have a bad time.
262 		if (totalSupply > 0) {
263 			// Compute the bonus co-efficient for all existing holders and the buyer.
264 			// The buyer receives part of the distribution for each token bought in the
265 			// same way they would have if they bought each token individually.
266 			var bonusCoEff =
267 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
268 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
269 				
270 			// The total reward to be distributed amongst the masses is the fee (in Ether)
271 			// multiplied by the bonus co-efficient.
272 			var holderReward = fee * bonusCoEff;
273 			
274 			buyerFee -= holderReward;
275 
276 			// Fee is distributed to all existing token holders before the new tokens are purchased.
277 			// rewardPerShare is the amount gained per token thanks to this buy-in.
278 			var rewardPerShare = holderReward / totalSupply;
279 			
280 			// The Ether value per token is increased proportionally.
281 			earningsPerToken += rewardPerShare;
282 			
283 		}
284 
285 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
286 		totalSupply = add(totalSupply, numTokens);
287 
288 		// Assign the tokens to the balance of the buyer.
289 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
290 
291 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
292 		// Also include the fee paid for entering the scheme.
293 		// First we compute how much was just paid out to the buyer...
294 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
295 		
296 		// Then we update the payouts array for the buyer with this amount...
297 		payouts[sender] += payoutDiff;
298 		
299 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
300 		totalPayouts    += payoutDiff;
301 		
302 	}
303 
304 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
305 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
306 	// will be *significant*.
307 	function sell(uint256 amount) internal {
308 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
309 		var numEthersBeforeFee = getEtherForTokens(amount);
310 		
311 		// 10% of the resulting Ether is used to pay remaining holders.
312         var fee = div(numEthersBeforeFee, 10);
313 		
314 		// Net Ether for the seller after the fee has been subtracted.
315         var numEthers = numEthersBeforeFee - fee;
316 		
317 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
318 		totalSupply = sub(totalSupply, amount);
319 		
320         // Remove the tokens from the balance of the buyer.
321 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
322 
323         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
324 		// First we compute how much was just paid out to the seller...
325 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
326 		
327         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
328 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
329 		// they decide to buy back in.
330 		payouts[msg.sender] -= payoutDiff;		
331 		
332 		// Decrease the total amount that's been paid out to maintain invariance.
333         totalPayouts -= payoutDiff;
334 		
335 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
336 		// selling tokens, but it guards against division by zero).
337 		if (totalSupply > 0) {
338 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
339 			var etherFee = fee * scaleFactor;
340 			
341 			// Fee is distributed to all remaining token holders.
342 			// rewardPerShare is the amount gained per token thanks to this sell.
343 			var rewardPerShare = etherFee / totalSupply;
344 			
345 			// The Ether value per token is increased proportionally.
346 			earningsPerToken = add(earningsPerToken, rewardPerShare);
347 		}
348 	}
349 	
350 	// Dynamic value of Ether in reserve, according to the CRR requirement.
351 	function reserve() internal constant returns (uint256 amount) {
352 		return sub(balance(),
353 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
354 	}
355 
356 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
357 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
358 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
359 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
360 	}
361 
362 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
363 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
364 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
365 	}
366 
367 	// Converts a number tokens into an Ether value.
368 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
369 		// How much reserve Ether do we have left in the contract?
370 		var reserveAmount = reserve();
371 
372 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
373 		if (tokens == totalSupply)
374 			return reserveAmount;
375 
376 		// If there would be excess Ether left after the transaction this is called within, return the Ether
377 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
378 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
379 		// and denominator altered to 1 and 2 respectively.
380 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
381 	}
382 
383 	// You don't care about these, but if you really do they're hex values for 
384 	// co-efficients used to simulate approximations of the log and exp functions.
385 	int256  constant one        = 0x10000000000000000;
386 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
387 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
388 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
389 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
390 	int256  constant c1         = 0x1ffffffffff9dac9b;
391 	int256  constant c3         = 0x0aaaaaaac16877908;
392 	int256  constant c5         = 0x0666664e5e9fa0c99;
393 	int256  constant c7         = 0x049254026a7630acf;
394 	int256  constant c9         = 0x038bd75ed37753d68;
395 	int256  constant c11        = 0x03284a0c14610924f;
396 
397 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
398 	// approximates the function log(1+x)-log(1-x)
399 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
400 	function fixedLog(uint256 a) internal pure returns (int256 log) {
401 		int32 scale = 0;
402 		while (a > sqrt2) {
403 			a /= 2;
404 			scale++;
405 		}
406 		while (a <= sqrtdot5) {
407 			a *= 2;
408 			scale--;
409 		}
410 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
411 		var z = (s*s) / one;
412 		return scale * ln2 +
413 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
414 				/one))/one))/one))/one))/one);
415 	}
416 
417 	int256 constant c2 =  0x02aaaaaaaaa015db0;
418 	int256 constant c4 = -0x000b60b60808399d1;
419 	int256 constant c6 =  0x0000455956bccdd06;
420 	int256 constant c8 = -0x000001b893ad04b3a;
421 	
422 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
423 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
424 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
425 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
426 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
427 		a -= scale*ln2;
428 		int256 z = (a*a) / one;
429 		int256 R = ((int256)(2) * one) +
430 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
431 		exp = (uint256) (((R + a) * one) / (R - a));
432 		if (scale >= 0)
433 			exp <<= scale;
434 		else
435 			exp >>= -scale;
436 		return exp;
437 	}
438 	
439 	// The below are safemath implementations of the four arithmetic operators
440 	// designed to explicitly prevent over- and under-flows of integer values.
441 
442 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443 		if (a == 0) {
444 			return 0;
445 		}
446 		uint256 c = a * b;
447 		assert(c / a == b);
448 		return c;
449 	}
450 
451 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
452 		// assert(b > 0); // Solidity automatically throws when dividing by 0
453 		uint256 c = a / b;
454 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
455 		return c;
456 	}
457 
458 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
459 		assert(b <= a);
460 		return a - b;
461 	}
462 
463 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
464 		uint256 c = a + b;
465 		assert(c >= a);
466 		return c;
467 	}
468 
469 	// This allows you to buy tokens by sending Ether directly to the smart contract
470 	// without including any transaction data (useful for, say, mobile wallet apps).
471 	function () payable public {
472 		// msg.value is the amount of Ether sent by the transaction.
473 		if (msg.value > 0) {
474 			fund();
475 		} else {
476 			withdrawOld(msg.sender);
477 		}
478 	}
479 }