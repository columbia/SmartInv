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
12  EthDividends. A no-bullshit, transparent, self-sustaining pyramid scheme.
13  
14  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
15 
16  Developer:
17  
18  Xaos@keemail.me
19  https://t.me/XaosPL
20  https://discord.gg/3zVBb
21 	
22  
23  
24 */
25 
26 contract ETHDividends {
27 
28 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
29 	// orders of magnitude, hence the need to bridge between the two.
30 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
31 
32 	// CRR = 50%
33 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
34 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
35 	int constant crr_n = 1; // CRR numerator
36 	int constant crr_d = 2; // CRR denominator
37 
38 	// The price coefficient. Chosen such that at 1 token total supply
39 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
40 	int constant price_coeff = -0x296ABF784A358468C;
41 
42 	// Typical values that we have to declare.
43 	string constant public name = "ETHDividends";
44 	string constant public symbol = "ETX";
45 	uint8 constant public decimals = 18;
46 
47 	// Array between each address and their number of tokens.
48 	mapping(address => uint256) public tokenBalance;
49 		
50 	// Array between each address and how much Ether has been paid out to it.
51 	// Note that this is scaled by the scaleFactor variable.
52 	mapping(address => int256) public payouts;
53 
54 	// Variable tracking how many tokens are in existence overall.
55 	uint256 public totalSupply;
56 
57 	// Aggregate sum of all payouts.
58 	// Note that this is scaled by the scaleFactor variable.
59 	int256 totalPayouts;
60 
61 	// Variable tracking how much Ether each token is currently worth.
62 	// Note that this is scaled by the scaleFactor variable.
63 	uint256 earningsPerToken;
64 	
65 	// Current contract balance in Ether
66 	uint256 public contractBalance;
67 
68 	function ETHDividends() public {}
69 
70 	// The following functions are used by the front-end for display purposes.
71 
72 	// Returns the number of tokens currently held by _owner.
73 	function balanceOf(address _owner) public constant returns (uint256 balance) {
74 		return tokenBalance[_owner];
75 	}
76 
77 	// Withdraws all dividends held by the caller sending the transaction, updates
78 	// the requisite global variables, and transfers Ether back to the caller.
79 	function withdraw() public {
80 		// Retrieve the dividends associated with the address the request came from.
81 		var balance = dividends(msg.sender);
82 		
83 		// Update the payouts array, incrementing the request address by `balance`.
84 		payouts[msg.sender] += (int256) (balance * scaleFactor);
85 		
86 		// Increase the total amount that's been paid out to maintain invariance.
87 		totalPayouts += (int256) (balance * scaleFactor);
88 		
89 		// Send the dividends to the address that requested the withdraw.
90 		contractBalance = sub(contractBalance, balance);
91 		msg.sender.transfer(balance);
92 	}
93 
94 	// Converts the Ether accrued as dividends back into EPY tokens without having to
95 	// withdraw it first. Saves on gas and potential price spike loss.
96 	function reinvestDividends() public {
97 		// Retrieve the dividends associated with the address the request came from.
98 		var balance = dividends(msg.sender);
99 		
100 		// Update the payouts array, incrementing the request address by `balance`.
101 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
102 		payouts[msg.sender] += (int256) (balance * scaleFactor);
103 		
104 		// Increase the total amount that's been paid out to maintain invariance.
105 		totalPayouts += (int256) (balance * scaleFactor);
106 		
107 		// Assign balance to a new variable.
108 		uint value_ = (uint) (balance);
109 		
110 		// If your dividends are worth less than 1 szabo, or more than a million Ether
111 		// (in which case, why are you even here), abort.
112 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
113 			revert();
114 			
115 		// msg.sender is the address of the caller.
116 		var sender = msg.sender;
117 		
118 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
119 		// (Yes, the buyer receives a part of the distribution as well!)
120 		var res = reserve() - balance;
121 
122 		// 10% of the total Ether sent is used to pay existing holders.
123 		var fee = div(value_, 10);
124 		
125 		// The amount of Ether used to purchase new tokens for the caller.
126 		var numEther = value_ - fee;
127 		
128 		// The number of tokens which can be purchased for numEther.
129 		var numTokens = calculateDividendTokens(numEther, balance);
130 		
131 		// The buyer fee, scaled by the scaleFactor variable.
132 		var buyerFee = fee * scaleFactor;
133 		
134 		// Check that we have tokens in existence (this should always be true), or
135 		// else you're gonna have a bad time.
136 		if (totalSupply > 0) {
137 			// Compute the bonus co-efficient for all existing holders and the buyer.
138 			// The buyer receives part of the distribution for each token bought in the
139 			// same way they would have if they bought each token individually.
140 			var bonusCoEff =
141 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
142 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
143 				
144 			// The total reward to be distributed amongst the masses is the fee (in Ether)
145 			// multiplied by the bonus co-efficient.
146 			var holderReward = fee * bonusCoEff;
147 			
148 			buyerFee -= holderReward;
149 
150 			// Fee is distributed to all existing token holders before the new tokens are purchased.
151 			// rewardPerShare is the amount gained per token thanks to this buy-in.
152 			var rewardPerShare = holderReward / totalSupply;
153 			
154 			// The Ether value per token is increased proportionally.
155 			earningsPerToken += rewardPerShare;
156 		}
157 		
158 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
159 		totalSupply = add(totalSupply, numTokens);
160 		
161 		// Assign the tokens to the balance of the buyer.
162 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
163 		
164 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
165 		// Also include the fee paid for entering the scheme.
166 		// First we compute how much was just paid out to the buyer...
167 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
168 		
169 		// Then we update the payouts array for the buyer with this amount...
170 		payouts[sender] += payoutDiff;
171 		
172 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
173 		totalPayouts    += payoutDiff;
174 		
175 	}
176 
177 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
178 	// in the tokenBalance array, and therefore is shown as a dividend. A second
179 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
180 	function sellMyTokens() public {
181 		var balance = balanceOf(msg.sender);
182 		sell(balance);
183 	}
184 
185 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
186 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
187     function getMeOutOfHere() public {
188 		sellMyTokens();
189         withdraw();
190 	}
191 
192 	// Gatekeeper function to check if the amount of Ether being sent isn't either
193 	// too small or too large. If it passes, goes direct to buy().
194 	function fund() payable public {
195 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
196 		if (msg.value > 0.000001 ether) {
197 		    contractBalance = add(contractBalance, msg.value);
198 			buy();
199 		} else {
200 			revert();
201 		}
202     }
203 
204 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
205 	function buyPrice() public constant returns (uint) {
206 		return getTokensForEther(1 finney);
207 	}
208 
209 	// Function that returns the (dynamic) price of selling a single token.
210 	function sellPrice() public constant returns (uint) {
211         var eth = getEtherForTokens(1 finney);
212         var fee = div(eth, 10);
213         return eth - fee;
214     }
215 
216 	// Calculate the current dividends associated with the caller address. This is the net result
217 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
218 	// Ether that has already been paid out.
219 	function dividends(address _owner) public constant returns (uint256 amount) {
220 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
221 	}
222 
223 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
224 	// This is only used in the case when there is no transaction data, and that should be
225 	// quite rare unless interacting directly with the smart contract.
226 	function withdrawOld(address to) public {
227 		// Retrieve the dividends associated with the address the request came from.
228 		var balance = dividends(msg.sender);
229 		
230 		// Update the payouts array, incrementing the request address by `balance`.
231 		payouts[msg.sender] += (int256) (balance * scaleFactor);
232 		
233 		// Increase the total amount that's been paid out to maintain invariance.
234 		totalPayouts += (int256) (balance * scaleFactor);
235 		
236 		// Send the dividends to the address that requested the withdraw.
237 		contractBalance = sub(contractBalance, balance);
238 		to.transfer(balance);		
239 	}
240 
241 	// Internal balance function, used to calculate the dynamic reserve value.
242 	function balance() internal constant returns (uint256 amount) {
243 		// msg.value is the amount of Ether sent by the transaction.
244 		return contractBalance - msg.value;
245 	}
246 
247 	function buy() internal {
248 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
249 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
250 			revert();
251 						
252 		// msg.sender is the address of the caller.
253 		var sender = msg.sender;
254 		
255 		// 10% of the total Ether sent is used to pay existing holders.
256 		var fee = div(msg.value, 10);
257 		
258 		// The amount of Ether used to purchase new tokens for the caller.
259 		var numEther = msg.value - fee;
260 		
261 		// The number of tokens which can be purchased for numEther.
262 		var numTokens = getTokensForEther(numEther);
263 		
264 		// The buyer fee, scaled by the scaleFactor variable.
265 		var buyerFee = fee * scaleFactor;
266 		
267 		// Check that we have tokens in existence (this should always be true), or
268 		// else you're gonna have a bad time.
269 		if (totalSupply > 0) {
270 			// Compute the bonus co-efficient for all existing holders and the buyer.
271 			// The buyer receives part of the distribution for each token bought in the
272 			// same way they would have if they bought each token individually.
273 			var bonusCoEff =
274 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
275 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
276 				
277 			// The total reward to be distributed amongst the masses is the fee (in Ether)
278 			// multiplied by the bonus co-efficient.
279 			var holderReward = fee * bonusCoEff;
280 			
281 			buyerFee -= holderReward;
282 
283 			// Fee is distributed to all existing token holders before the new tokens are purchased.
284 			// rewardPerShare is the amount gained per token thanks to this buy-in.
285 			var rewardPerShare = holderReward / totalSupply;
286 			
287 			// The Ether value per token is increased proportionally.
288 			earningsPerToken += rewardPerShare;
289 			
290 		}
291 
292 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
293 		totalSupply = add(totalSupply, numTokens);
294 
295 		// Assign the tokens to the balance of the buyer.
296 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
297 
298 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
299 		// Also include the fee paid for entering the scheme.
300 		// First we compute how much was just paid out to the buyer...
301 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
302 		
303 		// Then we update the payouts array for the buyer with this amount...
304 		payouts[sender] += payoutDiff;
305 		
306 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
307 		totalPayouts    += payoutDiff;
308 		
309 	}
310 
311 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
312 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
313 	// will be *significant*.
314 	function sell(uint256 amount) internal {
315 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
316 		var numEthersBeforeFee = getEtherForTokens(amount);
317 		
318 		// 10% of the resulting Ether is used to pay remaining holders.
319         var fee = div(numEthersBeforeFee, 10);
320 		
321 		// Net Ether for the seller after the fee has been subtracted.
322         var numEthers = numEthersBeforeFee - fee;
323 		
324 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
325 		totalSupply = sub(totalSupply, amount);
326 		
327         // Remove the tokens from the balance of the buyer.
328 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
329 
330         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
331 		// First we compute how much was just paid out to the seller...
332 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
333 		
334         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
335 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
336 		// they decide to buy back in.
337 		payouts[msg.sender] -= payoutDiff;		
338 		
339 		// Decrease the total amount that's been paid out to maintain invariance.
340         totalPayouts -= payoutDiff;
341 		
342 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
343 		// selling tokens, but it guards against division by zero).
344 		if (totalSupply > 0) {
345 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
346 			var etherFee = fee * scaleFactor;
347 			
348 			// Fee is distributed to all remaining token holders.
349 			// rewardPerShare is the amount gained per token thanks to this sell.
350 			var rewardPerShare = etherFee / totalSupply;
351 			
352 			// The Ether value per token is increased proportionally.
353 			earningsPerToken = add(earningsPerToken, rewardPerShare);
354 		}
355 	}
356 	
357 	// Dynamic value of Ether in reserve, according to the CRR requirement.
358 	function reserve() internal constant returns (uint256 amount) {
359 		return sub(balance(),
360 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
361 	}
362 
363 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
364 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
365 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
366 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
367 	}
368 
369 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
370 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
371 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
372 	}
373 
374 	// Converts a number tokens into an Ether value.
375 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
376 		// How much reserve Ether do we have left in the contract?
377 		var reserveAmount = reserve();
378 
379 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
380 		if (tokens == totalSupply)
381 			return reserveAmount;
382 
383 		// If there would be excess Ether left after the transaction this is called within, return the Ether
384 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
385 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
386 		// and denominator altered to 1 and 2 respectively.
387 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
388 	}
389 
390 	// You don't care about these, but if you really do they're hex values for 
391 	// co-efficients used to simulate approximations of the log and exp functions.
392 	int256  constant one        = 0x10000000000000000;
393 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
394 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
395 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
396 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
397 	int256  constant c1         = 0x1ffffffffff9dac9b;
398 	int256  constant c3         = 0x0aaaaaaac16877908;
399 	int256  constant c5         = 0x0666664e5e9fa0c99;
400 	int256  constant c7         = 0x049254026a7630acf;
401 	int256  constant c9         = 0x038bd75ed37753d68;
402 	int256  constant c11        = 0x03284a0c14610924f;
403 
404 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
405 	// approximates the function log(1+x)-log(1-x)
406 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
407 	function fixedLog(uint256 a) internal pure returns (int256 log) {
408 		int32 scale = 0;
409 		while (a > sqrt2) {
410 			a /= 2;
411 			scale++;
412 		}
413 		while (a <= sqrtdot5) {
414 			a *= 2;
415 			scale--;
416 		}
417 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
418 		var z = (s*s) / one;
419 		return scale * ln2 +
420 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
421 				/one))/one))/one))/one))/one);
422 	}
423 
424 	int256 constant c2 =  0x02aaaaaaaaa015db0;
425 	int256 constant c4 = -0x000b60b60808399d1;
426 	int256 constant c6 =  0x0000455956bccdd06;
427 	int256 constant c8 = -0x000001b893ad04b3a;
428 	
429 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
430 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
431 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
432 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
433 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
434 		a -= scale*ln2;
435 		int256 z = (a*a) / one;
436 		int256 R = ((int256)(2) * one) +
437 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
438 		exp = (uint256) (((R + a) * one) / (R - a));
439 		if (scale >= 0)
440 			exp <<= scale;
441 		else
442 			exp >>= -scale;
443 		return exp;
444 	}
445 	
446 	// The below are safemath implementations of the four arithmetic operators
447 	// designed to explicitly prevent over- and under-flows of integer values.
448 
449 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
450 		if (a == 0) {
451 			return 0;
452 		}
453 		uint256 c = a * b;
454 		assert(c / a == b);
455 		return c;
456 	}
457 
458 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
459 		// assert(b > 0); // Solidity automatically throws when dividing by 0
460 		uint256 c = a / b;
461 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
462 		return c;
463 	}
464 
465 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
466 		assert(b <= a);
467 		return a - b;
468 	}
469 
470 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
471 		uint256 c = a + b;
472 		assert(c >= a);
473 		return c;
474 	}
475 
476 	// This allows you to buy tokens by sending Ether directly to the smart contract
477 	// without including any transaction data (useful for, say, mobile wallet apps).
478 	function () payable public {
479 		// msg.value is the amount of Ether sent by the transaction.
480 		if (msg.value > 0) {
481 			fund();
482 		} else {
483 			withdrawOld(msg.sender);
484 		}
485 	}
486 }