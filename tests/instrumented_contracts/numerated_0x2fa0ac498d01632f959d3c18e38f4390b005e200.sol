1 pragma solidity ^0.4.18;
2 
3 /*
4     JustCoin
5 */
6 
7 contract EthPyramid {
8 
9 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
10 	// orders of magnitude, hence the need to bridge between the two.
11 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
12 
13 	// CRR = 50%
14 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
15 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
16 	int constant crr_n = 1; // CRR numerator
17 	int constant crr_d = 2; // CRR denominator
18 
19 	// The price coefficient. Chosen such that at 1 token total supply
20 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
21 	int constant price_coeff = -0x296ABF784A358468C;
22 
23 	// Typical values that we have to declare.
24 	string constant public name = "EthPyramid";
25 	string constant public symbol = "EPY";
26 	uint8 constant public decimals = 18;
27 
28 	// Array between each address and their number of tokens.
29 	mapping(address => uint256) public tokenBalance;
30 		
31 	// Array between each address and how much Ether has been paid out to it.
32 	// Note that this is scaled by the scaleFactor variable.
33 	mapping(address => int256) public payouts;
34 
35 	// Variable tracking how many tokens are in existence overall.
36 	uint256 public totalSupply;
37 
38 	// Aggregate sum of all payouts.
39 	// Note that this is scaled by the scaleFactor variable.
40 	int256 totalPayouts;
41 
42 	// Variable tracking how much Ether each token is currently worth.
43 	// Note that this is scaled by the scaleFactor variable.
44 	uint256 earningsPerToken;
45 	
46 	// Current contract balance in Ether
47 	uint256 public contractBalance;
48 
49 	function EthPyramid() public {}
50 
51 	// The following functions are used by the front-end for display purposes.
52 
53 	// Returns the number of tokens currently held by _owner.
54 	function balanceOf(address _owner) public constant returns (uint256 balance) {
55 		return tokenBalance[_owner];
56 	}
57 
58 	// Withdraws all dividends held by the caller sending the transaction, updates
59 	// the requisite global variables, and transfers Ether back to the caller.
60 	function withdraw() public {
61 		// Retrieve the dividends associated with the address the request came from.
62 		var balance = dividends(msg.sender);
63 		
64 		// Update the payouts array, incrementing the request address by `balance`.
65 		payouts[msg.sender] += (int256) (balance * scaleFactor);
66 		
67 		// Increase the total amount that's been paid out to maintain invariance.
68 		totalPayouts += (int256) (balance * scaleFactor);
69 		
70 		// Send the dividends to the address that requested the withdraw.
71 		contractBalance = sub(contractBalance, balance);
72 		msg.sender.transfer(balance);
73 	}
74 
75 	// Converts the Ether accrued as dividends back into EPY tokens without having to
76 	// withdraw it first. Saves on gas and potential price spike loss.
77 	function reinvestDividends() public {
78 		// Retrieve the dividends associated with the address the request came from.
79 		var balance = dividends(msg.sender);
80 		
81 		// Update the payouts array, incrementing the request address by `balance`.
82 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
83 		payouts[msg.sender] += (int256) (balance * scaleFactor);
84 		
85 		// Increase the total amount that's been paid out to maintain invariance.
86 		totalPayouts += (int256) (balance * scaleFactor);
87 		
88 		// Assign balance to a new variable.
89 		uint value_ = (uint) (balance);
90 		
91 		// If your dividends are worth less than 1 szabo, or more than a million Ether
92 		// (in which case, why are you even here), abort.
93 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
94 			revert();
95 			
96 		// msg.sender is the address of the caller.
97 		var sender = msg.sender;
98 		
99 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
100 		// (Yes, the buyer receives a part of the distribution as well!)
101 		var res = reserve() - balance;
102 
103 		// 10% of the total Ether sent is used to pay existing holders.
104 		var fee = div(value_, 10);
105 		
106 		// The amount of Ether used to purchase new tokens for the caller.
107 		var numEther = value_ - fee;
108 		
109 		// The number of tokens which can be purchased for numEther.
110 		var numTokens = calculateDividendTokens(numEther, balance);
111 		
112 		// The buyer fee, scaled by the scaleFactor variable.
113 		var buyerFee = fee * scaleFactor;
114 		
115 		// Check that we have tokens in existence (this should always be true), or
116 		// else you're gonna have a bad time.
117 		if (totalSupply > 0) {
118 			// Compute the bonus co-efficient for all existing holders and the buyer.
119 			// The buyer receives part of the distribution for each token bought in the
120 			// same way they would have if they bought each token individually.
121 			var bonusCoEff =
122 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
123 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
124 				
125 			// The total reward to be distributed amongst the masses is the fee (in Ether)
126 			// multiplied by the bonus co-efficient.
127 			var holderReward = fee * bonusCoEff;
128 			
129 			buyerFee -= holderReward;
130 
131 			// Fee is distributed to all existing token holders before the new tokens are purchased.
132 			// rewardPerShare is the amount gained per token thanks to this buy-in.
133 			var rewardPerShare = holderReward / totalSupply;
134 			
135 			// The Ether value per token is increased proportionally.
136 			earningsPerToken += rewardPerShare;
137 		}
138 		
139 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
140 		totalSupply = add(totalSupply, numTokens);
141 		
142 		// Assign the tokens to the balance of the buyer.
143 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
144 		
145 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
146 		// Also include the fee paid for entering the scheme.
147 		// First we compute how much was just paid out to the buyer...
148 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
149 		
150 		// Then we update the payouts array for the buyer with this amount...
151 		payouts[sender] += payoutDiff;
152 		
153 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
154 		totalPayouts    += payoutDiff;
155 		
156 	}
157 
158 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
159 	// in the tokenBalance array, and therefore is shown as a dividend. A second
160 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
161 	function sellMyTokens() public {
162 		var balance = balanceOf(msg.sender);
163 		sell(balance);
164 	}
165 
166 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
167 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
168     function getMeOutOfHere() public {
169 		sellMyTokens();
170         withdraw();
171 	}
172 
173 	// Gatekeeper function to check if the amount of Ether being sent isn't either
174 	// too small or too large. If it passes, goes direct to buy().
175 	function fund() payable public {
176 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
177 		if (msg.value > 0.000001 ether) {
178 		    contractBalance = add(contractBalance, msg.value);
179 			buy();
180 		} else {
181 			revert();
182 		}
183     }
184 
185 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
186 	function buyPrice() public constant returns (uint) {
187 		return getTokensForEther(1 finney);
188 	}
189 
190 	// Function that returns the (dynamic) price of selling a single token.
191 	function sellPrice() public constant returns (uint) {
192         var eth = getEtherForTokens(1 finney);
193         var fee = div(eth, 10);
194         return eth - fee;
195     }
196 
197 	// Calculate the current dividends associated with the caller address. This is the net result
198 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
199 	// Ether that has already been paid out.
200 	function dividends(address _owner) public constant returns (uint256 amount) {
201 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
202 	}
203 
204 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
205 	// This is only used in the case when there is no transaction data, and that should be
206 	// quite rare unless interacting directly with the smart contract.
207 	function withdrawOld(address to) public {
208 		// Retrieve the dividends associated with the address the request came from.
209 		var balance = dividends(msg.sender);
210 		
211 		// Update the payouts array, incrementing the request address by `balance`.
212 		payouts[msg.sender] += (int256) (balance * scaleFactor);
213 		
214 		// Increase the total amount that's been paid out to maintain invariance.
215 		totalPayouts += (int256) (balance * scaleFactor);
216 		
217 		// Send the dividends to the address that requested the withdraw.
218 		contractBalance = sub(contractBalance, balance);
219 		to.transfer(balance);		
220 	}
221 
222 	// Internal balance function, used to calculate the dynamic reserve value.
223 	function balance() internal constant returns (uint256 amount) {
224 		// msg.value is the amount of Ether sent by the transaction.
225 		return contractBalance - msg.value;
226 	}
227 
228 	function buy() internal {
229 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
230 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
231 			revert();
232 						
233 		// msg.sender is the address of the caller.
234 		var sender = msg.sender;
235 		
236 		// 10% of the total Ether sent is used to pay existing holders.
237 		var fee = div(msg.value, 10);
238 		
239 		// The amount of Ether used to purchase new tokens for the caller.
240 		var numEther = msg.value - fee;
241 		
242 		// The number of tokens which can be purchased for numEther.
243 		var numTokens = getTokensForEther(numEther);
244 		
245 		// The buyer fee, scaled by the scaleFactor variable.
246 		var buyerFee = fee * scaleFactor;
247 		
248 		// Check that we have tokens in existence (this should always be true), or
249 		// else you're gonna have a bad time.
250 		if (totalSupply > 0) {
251 			// Compute the bonus co-efficient for all existing holders and the buyer.
252 			// The buyer receives part of the distribution for each token bought in the
253 			// same way they would have if they bought each token individually.
254 			var bonusCoEff =
255 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
256 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
257 				
258 			// The total reward to be distributed amongst the masses is the fee (in Ether)
259 			// multiplied by the bonus co-efficient.
260 			var holderReward = fee * bonusCoEff;
261 			
262 			buyerFee -= holderReward;
263 
264 			// Fee is distributed to all existing token holders before the new tokens are purchased.
265 			// rewardPerShare is the amount gained per token thanks to this buy-in.
266 			var rewardPerShare = holderReward / totalSupply;
267 			
268 			// The Ether value per token is increased proportionally.
269 			earningsPerToken += rewardPerShare;
270 			
271 		}
272 
273 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
274 		totalSupply = add(totalSupply, numTokens);
275 
276 		// Assign the tokens to the balance of the buyer.
277 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
278 
279 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
280 		// Also include the fee paid for entering the scheme.
281 		// First we compute how much was just paid out to the buyer...
282 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
283 		
284 		// Then we update the payouts array for the buyer with this amount...
285 		payouts[sender] += payoutDiff;
286 		
287 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
288 		totalPayouts    += payoutDiff;
289 		
290 	}
291 
292 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
293 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
294 	// will be *significant*.
295 	function sell(uint256 amount) internal {
296 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
297 		var numEthersBeforeFee = getEtherForTokens(amount);
298 		
299 		// 10% of the resulting Ether is used to pay remaining holders.
300         var fee = div(numEthersBeforeFee, 10);
301 		
302 		// Net Ether for the seller after the fee has been subtracted.
303         var numEthers = numEthersBeforeFee - fee;
304 		
305 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
306 		totalSupply = sub(totalSupply, amount);
307 		
308         // Remove the tokens from the balance of the buyer.
309 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
310 
311         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
312 		// First we compute how much was just paid out to the seller...
313 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
314 		
315         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
316 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
317 		// they decide to buy back in.
318 		payouts[msg.sender] -= payoutDiff;		
319 		
320 		// Decrease the total amount that's been paid out to maintain invariance.
321         totalPayouts -= payoutDiff;
322 		
323 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
324 		// selling tokens, but it guards against division by zero).
325 		if (totalSupply > 0) {
326 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
327 			var etherFee = fee * scaleFactor;
328 			
329 			// Fee is distributed to all remaining token holders.
330 			// rewardPerShare is the amount gained per token thanks to this sell.
331 			var rewardPerShare = etherFee / totalSupply;
332 			
333 			// The Ether value per token is increased proportionally.
334 			earningsPerToken = add(earningsPerToken, rewardPerShare);
335 		}
336 	}
337 	
338 	// Dynamic value of Ether in reserve, according to the CRR requirement.
339 	function reserve() internal constant returns (uint256 amount) {
340 		return sub(balance(),
341 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
342 	}
343 
344 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
345 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
346 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
347 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
348 	}
349 
350 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
351 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
352 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
353 	}
354 
355 	// Converts a number tokens into an Ether value.
356 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
357 		// How much reserve Ether do we have left in the contract?
358 		var reserveAmount = reserve();
359 
360 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
361 		if (tokens == totalSupply)
362 			return reserveAmount;
363 
364 		// If there would be excess Ether left after the transaction this is called within, return the Ether
365 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
366 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
367 		// and denominator altered to 1 and 2 respectively.
368 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
369 	}
370 
371 	// You don't care about these, but if you really do they're hex values for 
372 	// co-efficients used to simulate approximations of the log and exp functions.
373 	int256  constant one        = 0x10000000000000000;
374 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
375 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
376 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
377 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
378 	int256  constant c1         = 0x1ffffffffff9dac9b;
379 	int256  constant c3         = 0x0aaaaaaac16877908;
380 	int256  constant c5         = 0x0666664e5e9fa0c99;
381 	int256  constant c7         = 0x049254026a7630acf;
382 	int256  constant c9         = 0x038bd75ed37753d68;
383 	int256  constant c11        = 0x03284a0c14610924f;
384 
385 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
386 	// approximates the function log(1+x)-log(1-x)
387 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
388 	function fixedLog(uint256 a) internal pure returns (int256 log) {
389 		int32 scale = 0;
390 		while (a > sqrt2) {
391 			a /= 2;
392 			scale++;
393 		}
394 		while (a <= sqrtdot5) {
395 			a *= 2;
396 			scale--;
397 		}
398 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
399 		var z = (s*s) / one;
400 		return scale * ln2 +
401 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
402 				/one))/one))/one))/one))/one);
403 	}
404 
405 	int256 constant c2 =  0x02aaaaaaaaa015db0;
406 	int256 constant c4 = -0x000b60b60808399d1;
407 	int256 constant c6 =  0x0000455956bccdd06;
408 	int256 constant c8 = -0x000001b893ad04b3a;
409 	
410 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
411 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
412 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
413 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
414 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
415 		a -= scale*ln2;
416 		int256 z = (a*a) / one;
417 		int256 R = ((int256)(2) * one) +
418 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
419 		exp = (uint256) (((R + a) * one) / (R - a));
420 		if (scale >= 0)
421 			exp <<= scale;
422 		else
423 			exp >>= -scale;
424 		return exp;
425 	}
426 	
427 	// The below are safemath implementations of the four arithmetic operators
428 	// designed to explicitly prevent over- and under-flows of integer values.
429 
430 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
431 		if (a == 0) {
432 			return 0;
433 		}
434 		uint256 c = a * b;
435 		assert(c / a == b);
436 		return c;
437 	}
438 
439 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
440 		// assert(b > 0); // Solidity automatically throws when dividing by 0
441 		uint256 c = a / b;
442 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
443 		return c;
444 	}
445 
446 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
447 		assert(b <= a);
448 		return a - b;
449 	}
450 
451 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
452 		uint256 c = a + b;
453 		assert(c >= a);
454 		return c;
455 	}
456 
457 	// This allows you to buy tokens by sending Ether directly to the smart contract
458 	// without including any transaction data (useful for, say, mobile wallet apps).
459 	function () payable public {
460 		// msg.value is the amount of Ether sent by the transaction.
461 		if (msg.value > 0) {
462 			fund();
463 		} else {
464 			withdrawOld(msg.sender);
465 		}
466 	}
467 }