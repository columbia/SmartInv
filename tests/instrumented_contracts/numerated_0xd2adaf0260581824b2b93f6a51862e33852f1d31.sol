1 pragma solidity ^0.4.18;
2 
3 /*
4           ,/`.
5         ,'/ __`.
6       ,'_/_  _ _`.
7     ,'__/_ ___ _  `.
8   ,'_  /___ __ _ __ `.
9  '-.._/___...-"-.-..__`.
10   A+
11 
12  -=[ FairPonzi v1.0 ]=-
13  
14   Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
15   Based on EthPyramid
16  
17  - Reserve requirement ratio (crr_d) is fixed from previous PoWH clones that gave very high distribution to first investors
18  - Contract will go live at 8 AM UTC time, Saturday, Feb 3 2018
19     - This time will be posted to all public channels to ensure fair distribution
20  - 5% fee on buy and sell distributed as dividends to all token holders. Dividends can be easily reinvested
21     - This is reduced from 10% in EthPyramid to encourage more trading
22     
23 - This is truly the People's Ponzi.
24 */
25 
26 contract FairPonzi {
27 
28 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
29 	// orders of magnitude, hence the need to bridge between the two.
30 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
31 
32 	// CRR = 25%
33 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
34 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
35 	int constant crr_n = 1; // CRR numerator
36 	int constant crr_d = 4; // CRR denominator
37 
38 	// The price coefficient. Chosen such that at 1 token total supply
39 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
40 	int constant price_coeff = -0x296ABF784A358468C;
41 
42 	// Typical values that we have to declare.
43 	string constant public name = "FairPonzi";
44 	string constant public symbol = "PONZ";
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
65 	function FairPonzi() public {}
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
87 		msg.sender.transfer(balance);
88 	}
89 
90 	// Converts the Ether accrued as dividends back into ETP tokens without having to
91 	// withdraw it first. Saves on gas and potential price spike loss.
92 	function reinvestDividends() public {
93 		// Retrieve the dividends associated with the address the request came from.
94 		var balance = dividends(msg.sender);
95 		
96 		// Update the payouts array, incrementing the request address by `balance`.
97 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
98 		payouts[msg.sender] += (int256) (balance * scaleFactor);
99 		
100 		// Increase the total amount that's been paid out to maintain invariance.
101 		totalPayouts += (int256) (balance * scaleFactor);
102 		
103 		// Assign balance to a new variable.
104 		uint value_ = (uint) (balance);
105 		
106 		// If your dividends are worth less than 1 szabo, or more than a million Ether
107 		// (in which case, why are you even here), abort.
108 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
109 			revert();
110 			
111 		// msg.sender is the address of the caller.
112 		var sender = msg.sender;
113 		
114 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
115 		// (Yes, the buyer receives a part of the distribution as well!)
116 		var res = reserve() - balance;
117 
118 		// 5% of the total Ether sent is used to pay existing holders.
119 		var fee = div(value_, 5);
120 		
121 		// The amount of Ether used to purchase new tokens for the caller.
122 		var numEther = value_ - fee;
123 		
124 		// The number of tokens which can be purchased for numEther.
125 		var numTokens = calculateDividendTokens(numEther, balance);
126 		
127 		// The buyer fee, scaled by the scaleFactor variable.
128 		var buyerFee = fee * scaleFactor;
129 		
130 		// Check that we have tokens in existence (this should always be true), or
131 		// else you're gonna have a bad time.
132 		if (totalSupply > 0) {
133 			// Compute the bonus co-efficient for all existing holders and the buyer.
134 			// The buyer receives part of the distribution for each token bought in the
135 			// same way they would have if they bought each token individually.
136 			var bonusCoEff =
137 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
138 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
139 				
140 			// The total reward to be distributed amongst the masses is the fee (in Ether)
141 			// multiplied by the bonus co-efficient.
142 			var holderReward = fee * bonusCoEff;
143 			
144 			buyerFee -= holderReward;
145 
146 			// Fee is distributed to all existing token holders before the new tokens are purchased.
147 			// rewardPerShare is the amount gained per token thanks to this buy-in.
148 			var rewardPerShare = holderReward / totalSupply;
149 			
150 			// The Ether value per token is increased proportionally.
151 			earningsPerToken += rewardPerShare;
152 		}
153 		
154 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
155 		totalSupply = add(totalSupply, numTokens);
156 		
157 		// Assign the tokens to the balance of the buyer.
158 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
159 		
160 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
161 		// Also include the fee paid for entering the scheme.
162 		// First we compute how much was just paid out to the buyer...
163 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
164 		
165 		// Then we update the payouts array for the buyer with this amount...
166 		payouts[sender] += payoutDiff;
167 		
168 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
169 		totalPayouts    += payoutDiff;
170 		
171 	}
172 
173 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
174 	// in the tokenBalance array, and therefore is shown as a dividend. A second
175 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
176 	function sellMyTokens() public {
177 		var balance = balanceOf(msg.sender);
178 		sell(balance);
179 	}
180 
181 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
182 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
183     function getMeOutOfHere() public {
184 		sellMyTokens();
185         withdraw();
186 	}
187 
188 	// Gatekeeper function to check if the amount of Ether being sent isn't either
189 	// too small or too large. If it passes, goes direct to buy().
190 	function fund() payable public {
191 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
192 		if (msg.value > 0.000001 ether) {
193 			buy();
194 		}
195     }
196 
197 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
198 	function buyPrice() public constant returns (uint) {
199 		return getTokensForEther(1 finney);
200 	}
201 
202 	// Function that returns the (dynamic) price of selling a single token.
203 	function sellPrice() public constant returns (uint) {
204         var eth = getEtherForTokens(1 finney);
205         var fee = div(eth, 5);
206         return eth - fee;
207     }
208 
209 	// Calculate the current dividends associated with the caller address. This is the net result
210 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
211 	// Ether that has already been paid out.
212 	function dividends(address _owner) public constant returns (uint256 amount) {
213 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
214 	}
215 
216 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
217 	// This is only used in the case when there is no transaction data, and that should be
218 	// quite rare unless interacting directly with the smart contract.
219 	function withdrawOld(address to) public {
220 		// Retrieve the dividends associated with the address the request came from.
221 		var balance = dividends(msg.sender);
222 		
223 		// Update the payouts array, incrementing the request address by `balance`.
224 		payouts[msg.sender] += (int256) (balance * scaleFactor);
225 		
226 		// Increase the total amount that's been paid out to maintain invariance.
227 		totalPayouts += (int256) (balance * scaleFactor);
228 		
229 		// Send the dividends to the address that requested the withdraw.
230 		to.transfer(balance);
231 	}
232 
233 	// Internal balance function, used to calculate the dynamic reserve value.
234 	function balance() internal constant returns (uint256 amount) {
235 		// msg.value is the amount of Ether sent by the transaction.
236 		return this.balance - msg.value;
237 	}
238 
239 	function buy() internal {
240 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
241 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
242 			revert();
243 			
244 		// msg.sender is the address of the caller.
245 		var sender = msg.sender;
246 		
247 		// 5% of the total Ether sent is used to pay existing holders.
248 		var fee = div(msg.value, 5);
249 		
250 		// The amount of Ether used to purchase new tokens for the caller.
251 		var numEther = msg.value - fee;
252 		
253 		// The number of tokens which can be purchased for numEther.
254 		var numTokens = getTokensForEther(numEther);
255 		
256 		// The buyer fee, scaled by the scaleFactor variable.
257 		var buyerFee = fee * scaleFactor;
258 		
259 		// Check that we have tokens in existence (this should always be true), or
260 		// else you're gonna have a bad time.
261 		if (totalSupply > 0) {
262 			// Compute the bonus co-efficient for all existing holders and the buyer.
263 			// The buyer receives part of the distribution for each token bought in the
264 			// same way they would have if they bought each token individually.
265 			var bonusCoEff =
266 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
267 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
268 				
269 			// The total reward to be distributed amongst the masses is the fee (in Ether)
270 			// multiplied by the bonus co-efficient.
271 			var holderReward = fee * bonusCoEff;
272 			
273 			buyerFee -= holderReward;
274 
275 			// Fee is distributed to all existing token holders before the new tokens are purchased.
276 			// rewardPerShare is the amount gained per token thanks to this buy-in.
277 			var rewardPerShare = holderReward / totalSupply;
278 			
279 			// The Ether value per token is increased proportionally.
280 			earningsPerToken += rewardPerShare;
281 			
282 		}
283 
284 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
285 		totalSupply = add(totalSupply, numTokens);
286 
287 		// Assign the tokens to the balance of the buyer.
288 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
289 
290 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
291 		// Also include the fee paid for entering the scheme.
292 		// First we compute how much was just paid out to the buyer...
293 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
294 		
295 		// Then we update the payouts array for the buyer with this amount...
296 		payouts[sender] += payoutDiff;
297 		
298 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
299 		totalPayouts    += payoutDiff;
300 		
301 	}
302 
303 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
304 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
305 	// will be *significant*.
306 	function sell(uint256 amount) internal {
307 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
308 		var numEthersBeforeFee = getEtherForTokens(amount);
309 		
310 		// 5% of the resulting Ether is used to pay remaining holders.
311         var fee = div(numEthersBeforeFee, 5);
312 		
313 		// Net Ether for the seller after the fee has been subtracted.
314         var numEthers = numEthersBeforeFee - fee;
315 		
316 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
317 		totalSupply = sub(totalSupply, amount);
318 		
319         // Remove the tokens from the balance of the buyer.
320 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
321 
322         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
323 		// First we compute how much was just paid out to the seller...
324 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
325 		
326         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
327 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
328 		// they decide to buy back in.
329 		payouts[msg.sender] -= payoutDiff;		
330 		
331 		// Decrease the total amount that's been paid out to maintain invariance.
332         totalPayouts -= payoutDiff;
333 		
334 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
335 		// selling tokens, but it guards against division by zero).
336 		if (totalSupply > 0) {
337 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
338 			var etherFee = fee * scaleFactor;
339 			
340 			// Fee is distributed to all remaining token holders.
341 			// rewardPerShare is the amount gained per token thanks to this sell.
342 			var rewardPerShare = etherFee / totalSupply;
343 			
344 			// The Ether value per token is increased proportionally.
345 			earningsPerToken = add(earningsPerToken, rewardPerShare);
346 		}
347 	}
348 	
349 	// Dynamic value of Ether in reserve, according to the CRR requirement.
350 	function reserve() internal constant returns (uint256 amount) {
351 		return sub(balance(),
352 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
353 	}
354 
355 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
356 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
357 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
358 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
359 	}
360 
361 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
362 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
363 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
364 	}
365 
366 	// Converts a number tokens into an Ether value.
367 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
368 		// How much reserve Ether do we have left in the contract?
369 		var reserveAmount = reserve();
370 
371 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
372 		if (tokens == totalSupply)
373 			return reserveAmount;
374 
375 		// If there would be excess Ether left after the transaction this is called within, return the Ether
376 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
377 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
378 		// and denominator altered to 1 and 2 respectively.
379 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
380 	}
381 
382 	// You don't care about these, but if you really do they're hex values for 
383 	// co-efficients used to simulate approximations of the log and exp functions.
384 	int256  constant one        = 0x10000000000000000;
385 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
386 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
387 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
388 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
389 	int256  constant c1         = 0x1ffffffffff9dac9b;
390 	int256  constant c3         = 0x0aaaaaaac16877908;
391 	int256  constant c5         = 0x0666664e5e9fa0c99;
392 	int256  constant c7         = 0x049254026a7630acf;
393 	int256  constant c9         = 0x038bd75ed37753d68;
394 	int256  constant c11        = 0x03284a0c14610924f;
395 
396 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
397 	// approximates the function log(1+x)-log(1-x)
398 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
399 	function fixedLog(uint256 a) internal pure returns (int256 log) {
400 		int32 scale = 0;
401 		while (a > sqrt2) {
402 			a /= 2;
403 			scale++;
404 		}
405 		while (a <= sqrtdot5) {
406 			a *= 2;
407 			scale--;
408 		}
409 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
410 		var z = (s*s) / one;
411 		return scale * ln2 +
412 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
413 				/one))/one))/one))/one))/one);
414 	}
415 
416 	int256 constant c2 =  0x02aaaaaaaaa015db0;
417 	int256 constant c4 = -0x000b60b60808399d1;
418 	int256 constant c6 =  0x0000455956bccdd06;
419 	int256 constant c8 = -0x000001b893ad04b3a;
420 	
421 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
422 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
423 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
424 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
425 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
426 		a -= scale*ln2;
427 		int256 z = (a*a) / one;
428 		int256 R = ((int256)(2) * one) +
429 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
430 		exp = (uint256) (((R + a) * one) / (R - a));
431 		if (scale >= 0)
432 			exp <<= scale;
433 		else
434 			exp >>= -scale;
435 		return exp;
436 	}
437 	
438 	// The below are safemath implementations of the four arithmetic operators
439 	// designed to explicitly prevent over- and under-flows of integer values.
440 
441 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
442 		if (a == 0) {
443 			return 0;
444 		}
445 		uint256 c = a * b;
446 		assert(c / a == b);
447 		return c;
448 	}
449 
450 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
451 		// assert(b > 0); // Solidity automatically throws when dividing by 0
452 		uint256 c = a / b;
453 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
454 		return c;
455 	}
456 
457 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
458 		assert(b <= a);
459 		return a - b;
460 	}
461 
462 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
463 		uint256 c = a + b;
464 		assert(c >= a);
465 		return c;
466 	}
467 
468 	// This allows you to buy tokens by sending Ether directly to the smart contract
469 	// without including any transaction data (useful for, say, mobile wallet apps).
470 	function () payable public {
471 		// msg.value is the amount of Ether sent by the transaction.
472 		if (msg.value > 0) {
473 			buy();
474 		} else {
475 			withdrawOld(msg.sender);
476 		}
477 	}
478 }