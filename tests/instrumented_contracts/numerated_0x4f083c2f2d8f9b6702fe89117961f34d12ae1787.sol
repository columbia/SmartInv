1 pragma solidity ^0.4.18;
2 
3 contract JustDCoin {
4 
5 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
6 	// orders of magnitude, hence the need to bridge between the two.
7 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
8 
9 	// CRR = 80%
10 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
11 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
12 	int constant crr_n = 4; // CRR numerator
13 	int constant crr_d = 5; // CRR denominator
14 
15 	// The price coefficient. Chosen such that at 1 token total supply
16 	// the amount in reserve is 0.8 ether and token price is 1 Ether.
17 	int constant price_coeff = -0x678adeacb985cb06;
18 
19 	// Typical values that we have to declare.
20 	string constant public name = "JustDCoin";
21 	string constant public symbol = "JustD";
22 	uint8 constant public decimals = 18;
23 
24 	// Array between each address and their number of tokens.
25 	mapping(address => uint256) public tokenBalance;
26 		
27 	// Array between each address and how much Ether has been paid out to it.
28 	// Note that this is scaled by the scaleFactor variable.
29 	mapping(address => int256) public payouts;
30 
31 	// Variable tracking how many tokens are in existence overall.
32 	uint256 public totalSupply;
33 
34 	// Aggregate sum of all payouts.
35 	// Note that this is scaled by the scaleFactor variable.
36 	int256 totalPayouts;
37 
38 	// Variable tracking how much Ether each token is currently worth.
39 	// Note that this is scaled by the scaleFactor variable.
40 	uint256 earningsPerToken;
41 	
42 	// Current contract balance in Ether
43 	uint256 public contractBalance;
44 
45 	function JustDCoin() public {}
46 
47 	// The following functions are used by the front-end for display purposes.
48 
49 	// Returns the number of tokens currently held by _owner.
50 	function balanceOf(address _owner) public constant returns (uint256 balance) {
51 		return tokenBalance[_owner];
52 	}
53 
54 	// Withdraws all dividends held by the caller sending the transaction, updates
55 	// the requisite global variables, and transfers Ether back to the caller.
56 	function withdraw() public {
57 		// Retrieve the dividends associated with the address the request came from.
58 		var balance = dividends(msg.sender);
59 		
60 		// Update the payouts array, incrementing the request address by `balance`.
61 		payouts[msg.sender] += (int256) (balance * scaleFactor);
62 		
63 		// Increase the total amount that's been paid out to maintain invariance.
64 		totalPayouts += (int256) (balance * scaleFactor);
65 		
66 		// Send the dividends to the address that requested the withdraw.
67 		contractBalance = sub(contractBalance, balance);
68 		msg.sender.transfer(balance);
69 	}
70 
71 	// Converts the Ether accrued as dividends back into EPY tokens without having to
72 	// withdraw it first. Saves on gas and potential price spike loss.
73 	function reinvestDividends() public {
74 		// Retrieve the dividends associated with the address the request came from.
75 		var balance = dividends(msg.sender);
76 		
77 		// Update the payouts array, incrementing the request address by `balance`.
78 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
79 		payouts[msg.sender] += (int256) (balance * scaleFactor);
80 		
81 		// Increase the total amount that's been paid out to maintain invariance.
82 		totalPayouts += (int256) (balance * scaleFactor);
83 		
84 		// Assign balance to a new variable.
85 		uint value_ = (uint) (balance);
86 		
87 		// If your dividends are worth less than 1 szabo, or more than a million Ether
88 		// (in which case, why are you even here), abort.
89 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
90 			revert();
91 			
92 		// msg.sender is the address of the caller.
93 		var sender = msg.sender;
94 		
95 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
96 		// (Yes, the buyer receives a part of the distribution as well!)
97 		var res = reserve() - balance;
98 
99 		// 5% of the total Ether sent is used to pay existing holders.
100 		var fee = div(value_, 20);
101 		
102 		// The amount of Ether used to purchase new tokens for the caller.
103 		var numEther = value_ - fee;
104 		
105 		// The number of tokens which can be purchased for numEther.
106 		var numTokens = calculateDividendTokens(numEther, balance);
107 		
108 		// The buyer fee, scaled by the scaleFactor variable.
109 		var buyerFee = fee * scaleFactor;
110 		
111 		// Check that we have tokens in existence (this should always be true), or
112 		// else you're gonna have a bad time.
113 		if (totalSupply > 0) {
114 			// Compute the bonus co-efficient for all existing holders and the buyer.
115 			// The buyer receives part of the distribution for each token bought in the
116 			// same way they would have if they bought each token individually.
117 			var bonusCoEff =
118 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
119 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
120 				
121 			// The total reward to be distributed amongst the masses is the fee (in Ether)
122 			// multiplied by the bonus co-efficient.
123 			var holderReward = fee * bonusCoEff;
124 			
125 			buyerFee -= holderReward;
126 
127 			// Fee is distributed to all existing token holders before the new tokens are purchased.
128 			// rewardPerShare is the amount gained per token thanks to this buy-in.
129 			var rewardPerShare = holderReward / totalSupply;
130 			
131 			// The Ether value per token is increased proportionally.
132 			earningsPerToken += rewardPerShare;
133 		}
134 		
135 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
136 		totalSupply = add(totalSupply, numTokens);
137 		
138 		// Assign the tokens to the balance of the buyer.
139 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
140 		
141 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
142 		// Also include the fee paid for entering the scheme.
143 		// First we compute how much was just paid out to the buyer...
144 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
145 		
146 		// Then we update the payouts array for the buyer with this amount...
147 		payouts[sender] += payoutDiff;
148 		
149 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
150 		totalPayouts    += payoutDiff;
151 		
152 	}
153 
154 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
155 	// in the tokenBalance array, and therefore is shown as a dividend. A second
156 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
157 	function sellMyTokens() public {
158 		var balance = balanceOf(msg.sender);
159 		sell(balance);
160 	}
161 
162 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
163 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
164     function getMeOutOfHere() public {
165 		sellMyTokens();
166         withdraw();
167 	}
168 
169 	// Gatekeeper function to check if the amount of Ether being sent isn't either
170 	// too small or too large. If it passes, goes direct to buy().
171 	function fund() payable public {
172 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
173 		if (msg.value > 0.000001 ether) {
174 		    contractBalance = add(contractBalance, msg.value);
175 			buy();
176 		} else {
177 			revert();
178 		}
179     }
180 
181 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
182 	function buyPrice() public constant returns (uint) {
183 		return getTokensForEther(1 finney);
184 	}
185 
186 	// Function that returns the (dynamic) price of selling a single token.
187 	function sellPrice() public constant returns (uint) {
188         var eth = getEtherForTokens(1 finney);
189         var fee = div(eth, 10);
190         return eth - fee;
191     }
192 
193 	// Calculate the current dividends associated with the caller address. This is the net result
194 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
195 	// Ether that has already been paid out.
196 	function dividends(address _owner) public constant returns (uint256 amount) {
197 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
198 	}
199 
200 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
201 	// This is only used in the case when there is no transaction data, and that should be
202 	// quite rare unless interacting directly with the smart contract.
203 	function withdrawOld(address to) public {
204 		// Retrieve the dividends associated with the address the request came from.
205 		var balance = dividends(msg.sender);
206 		
207 		// Update the payouts array, incrementing the request address by `balance`.
208 		payouts[msg.sender] += (int256) (balance * scaleFactor);
209 		
210 		// Increase the total amount that's been paid out to maintain invariance.
211 		totalPayouts += (int256) (balance * scaleFactor);
212 		
213 		// Send the dividends to the address that requested the withdraw.
214 		contractBalance = sub(contractBalance, balance);
215 		to.transfer(balance);		
216 	}
217 
218 	// Internal balance function, used to calculate the dynamic reserve value.
219 	function balance() internal constant returns (uint256 amount) {
220 		// msg.value is the amount of Ether sent by the transaction.
221 		return contractBalance - msg.value;
222 	}
223 
224 	function buy() internal {
225 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
226 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
227 			revert();
228 						
229 		// msg.sender is the address of the caller.
230 		var sender = msg.sender;
231 		
232 		// 5% of the total Ether sent is used to pay existing holders.
233 		var fee = div(msg.value, 20);
234 		
235 		// The amount of Ether used to purchase new tokens for the caller.
236 		var numEther = msg.value - fee;
237 		
238 		// The number of tokens which can be purchased for numEther.
239 		var numTokens = getTokensForEther(numEther);
240 		
241 		// The buyer fee, scaled by the scaleFactor variable.
242 		var buyerFee = fee * scaleFactor;
243 		
244 		// Check that we have tokens in existence (this should always be true), or
245 		// else you're gonna have a bad time.
246 		if (totalSupply > 0) {
247 			// Compute the bonus co-efficient for all existing holders and the buyer.
248 			// The buyer receives part of the distribution for each token bought in the
249 			// same way they would have if they bought each token individually.
250 			var bonusCoEff =
251 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
252 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
253 				
254 			// The total reward to be distributed amongst the masses is the fee (in Ether)
255 			// multiplied by the bonus co-efficient.
256 			var holderReward = fee * bonusCoEff;
257 			
258 			buyerFee -= holderReward;
259 
260 			// Fee is distributed to all existing token holders before the new tokens are purchased.
261 			// rewardPerShare is the amount gained per token thanks to this buy-in.
262 			var rewardPerShare = holderReward / totalSupply;
263 			
264 			// The Ether value per token is increased proportionally.
265 			earningsPerToken += rewardPerShare;
266 			
267 		}
268 
269 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
270 		totalSupply = add(totalSupply, numTokens);
271 
272 		// Assign the tokens to the balance of the buyer.
273 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
274 
275 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
276 		// Also include the fee paid for entering the scheme.
277 		// First we compute how much was just paid out to the buyer...
278 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
279 		
280 		// Then we update the payouts array for the buyer with this amount...
281 		payouts[sender] += payoutDiff;
282 		
283 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
284 		totalPayouts    += payoutDiff;
285 		
286 	}
287 
288 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
289 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
290 	// will be *significant*.
291 	function sell(uint256 amount) internal {
292 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
293 		var numEthersBeforeFee = getEtherForTokens(amount);
294 		
295 		// 5% of the resulting Ether is used to pay remaining holders.
296         var fee = div(numEthersBeforeFee, 20);
297 		
298 		// Net Ether for the seller after the fee has been subtracted.
299         var numEthers = numEthersBeforeFee - fee;
300 		
301 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
302 		totalSupply = sub(totalSupply, amount);
303 		
304         // Remove the tokens from the balance of the buyer.
305 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
306 
307         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
308 		// First we compute how much was just paid out to the seller...
309 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
310 		
311         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
312 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
313 		// they decide to buy back in.
314 		payouts[msg.sender] -= payoutDiff;		
315 		
316 		// Decrease the total amount that's been paid out to maintain invariance.
317         totalPayouts -= payoutDiff;
318 		
319 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
320 		// selling tokens, but it guards against division by zero).
321 		if (totalSupply > 0) {
322 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
323 			var etherFee = fee * scaleFactor;
324 			
325 			// Fee is distributed to all remaining token holders.
326 			// rewardPerShare is the amount gained per token thanks to this sell.
327 			var rewardPerShare = etherFee / totalSupply;
328 			
329 			// The Ether value per token is increased proportionally.
330 			earningsPerToken = add(earningsPerToken, rewardPerShare);
331 		}
332 	}
333 	
334 	// Dynamic value of Ether in reserve, according to the CRR requirement.
335 	function reserve() internal constant returns (uint256 amount) {
336 		return sub(balance(),
337 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
338 	}
339 
340 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
341 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
342 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
343 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
344 	}
345 
346 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
347 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
348 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
349 	}
350 
351 	// Converts a number tokens into an Ether value.
352 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
353 		// How much reserve Ether do we have left in the contract?
354 		var reserveAmount = reserve();
355 
356 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
357 		if (tokens == totalSupply)
358 			return reserveAmount;
359 
360 		// If there would be excess Ether left after the transaction this is called within, return the Ether
361 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
362 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
363 		// and denominator altered to 1 and 2 respectively.
364 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
365 	}
366 
367 	// You don't care about these, but if you really do they're hex values for 
368 	// co-efficients used to simulate approximations of the log and exp functions.
369 	int256  constant one        = 0x10000000000000000;
370 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
371 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
372 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
373 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
374 	int256  constant c1         = 0x1ffffffffff9dac9b;
375 	int256  constant c3         = 0x0aaaaaaac16877908;
376 	int256  constant c5         = 0x0666664e5e9fa0c99;
377 	int256  constant c7         = 0x049254026a7630acf;
378 	int256  constant c9         = 0x038bd75ed37753d68;
379 	int256  constant c11        = 0x03284a0c14610924f;
380 
381 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
382 	// approximates the function log(1+x)-log(1-x)
383 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
384 	function fixedLog(uint256 a) internal pure returns (int256 log) {
385 		int32 scale = 0;
386 		while (a > sqrt2) {
387 			a /= 2;
388 			scale++;
389 		}
390 		while (a <= sqrtdot5) {
391 			a *= 2;
392 			scale--;
393 		}
394 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
395 		var z = (s*s) / one;
396 		return scale * ln2 +
397 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
398 				/one))/one))/one))/one))/one);
399 	}
400 
401 	int256 constant c2 =  0x02aaaaaaaaa015db0;
402 	int256 constant c4 = -0x000b60b60808399d1;
403 	int256 constant c6 =  0x0000455956bccdd06;
404 	int256 constant c8 = -0x000001b893ad04b3a;
405 	
406 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
407 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
408 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
409 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
410 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
411 		a -= scale*ln2;
412 		int256 z = (a*a) / one;
413 		int256 R = ((int256)(2) * one) +
414 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
415 		exp = (uint256) (((R + a) * one) / (R - a));
416 		if (scale >= 0)
417 			exp <<= scale;
418 		else
419 			exp >>= -scale;
420 		return exp;
421 	}
422 	
423 	// The below are safemath implementations of the four arithmetic operators
424 	// designed to explicitly prevent over- and under-flows of integer values.
425 
426 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
427 		if (a == 0) {
428 			return 0;
429 		}
430 		uint256 c = a * b;
431 		assert(c / a == b);
432 		return c;
433 	}
434 
435 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
436 		// assert(b > 0); // Solidity automatically throws when dividing by 0
437 		uint256 c = a / b;
438 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
439 		return c;
440 	}
441 
442 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
443 		assert(b <= a);
444 		return a - b;
445 	}
446 
447 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
448 		uint256 c = a + b;
449 		assert(c >= a);
450 		return c;
451 	}
452 
453 	// This allows you to buy tokens by sending Ether directly to the smart contract
454 	// without including any transaction data (useful for, say, mobile wallet apps).
455 	function () payable public {
456 		// msg.value is the amount of Ether sent by the transaction.
457 		if (msg.value > 0) {
458 			fund();
459 		} else {
460 			withdrawOld(msg.sender);
461 		}
462 	}
463 }