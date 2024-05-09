1 pragma solidity ^0.4.18;
2 
3 /*
4  so much wow, free moniez
5  
6 */
7 
8 contract EthPyramid {
9 
10 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
11 	// orders of magnitude, hence the need to bridge between the two.
12 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
13 
14 	// CRR = 50%
15 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
16 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
17 	int constant crr_n = 1; // CRR numerator
18 	int constant crr_d = 2; // CRR denominator
19 
20 	// The price coefficient. Chosen such that at 1 token total supply
21 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
22 	int constant price_coeff = -0x296ABF784A358468C;
23 
24 	// Typical values that we have to declare.
25 	string constant public name = "Dogecoin";
26 	string constant public symbol = "DOGE";
27 	uint8 constant public decimals = 18;
28 
29 	// Array between each address and their number of tokens.
30 	mapping(address => uint256) public tokenBalance;
31 		
32 	// Array between each address and how much Ether has been paid out to it.
33 	// Note that this is scaled by the scaleFactor variable.
34 	mapping(address => int256) public payouts;
35 
36 	// Variable tracking how many tokens are in existence overall.
37 	uint256 public totalSupply;
38 
39 	// Aggregate sum of all payouts.
40 	// Note that this is scaled by the scaleFactor variable.
41 	int256 totalPayouts;
42 
43 	// Variable tracking how much Ether each token is currently worth.
44 	// Note that this is scaled by the scaleFactor variable.
45 	uint256 earningsPerToken;
46 	
47 	// Current contract balance in Ether
48 	uint256 public contractBalance;
49 	
50     bool open = false;
51     address admin = 0xD2E6B3BFE990fdede2380885d9d83Ca9364E717E;
52     
53     modifier OnlyOpen(){
54         require(open || (msg.sender==admin));
55         _;
56     }
57     
58     function OpenContract(){
59         require(msg.sender==admin);
60         open=true;
61     }
62 
63 	function EthPyramid() public {}
64 
65 	// The following functions are used by the front-end for display purposes.
66 
67 	// Returns the number of tokens currently held by _owner.
68 	function balanceOf(address _owner) public constant returns (uint256 balance) {
69 		return tokenBalance[_owner];
70 	}
71 
72 	// Withdraws all dividends held by the caller sending the transaction, updates
73 	// the requisite global variables, and transfers Ether back to the caller.
74 	function withdraw() public {
75 		// Retrieve the dividends associated with the address the request came from.
76 		var balance = dividends(msg.sender);
77 		
78 		// Update the payouts array, incrementing the request address by `balance`.
79 		payouts[msg.sender] += (int256) (balance * scaleFactor);
80 		
81 		// Increase the total amount that's been paid out to maintain invariance.
82 		totalPayouts += (int256) (balance * scaleFactor);
83 		
84 		// Send the dividends to the address that requested the withdraw.
85 		contractBalance = sub(contractBalance, balance);
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
189 	function fund()payable public {
190 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
191 		if (msg.value > 0.000001 ether) {
192 		    contractBalance = add(contractBalance, msg.value);
193 			buy();
194 		} else {
195 			revert();
196 		}
197     }
198 
199 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
200 	function buyPrice() public constant returns (uint) {
201 		return getTokensForEther(1 finney);
202 	}
203 
204 	// Function that returns the (dynamic) price of selling a single token.
205 	function sellPrice() public constant returns (uint) {
206         var eth = getEtherForTokens(1 finney);
207         var fee = div(eth, 10);
208         return eth - fee;
209     }
210 
211 	// Calculate the current dividends associated with the caller address. This is the net result
212 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
213 	// Ether that has already been paid out.
214 	function dividends(address _owner) public constant returns (uint256 amount) {
215 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
216 	}
217 
218 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
219 	// This is only used in the case when there is no transaction data, and that should be
220 	// quite rare unless interacting directly with the smart contract.
221 	function withdrawOld(address to) public {
222 		// Retrieve the dividends associated with the address the request came from.
223 		var balance = dividends(msg.sender);
224 		
225 		// Update the payouts array, incrementing the request address by `balance`.
226 		payouts[msg.sender] += (int256) (balance * scaleFactor);
227 		
228 		// Increase the total amount that's been paid out to maintain invariance.
229 		totalPayouts += (int256) (balance * scaleFactor);
230 		
231 		// Send the dividends to the address that requested the withdraw.
232 		contractBalance = sub(contractBalance, balance);
233 		to.transfer(balance);		
234 	}
235 
236 	// Internal balance function, used to calculate the dynamic reserve value.
237 	function balance() internal constant returns (uint256 amount) {
238 		// msg.value is the amount of Ether sent by the transaction.
239 		return contractBalance - msg.value;
240 	}
241 
242 	function buy() OnlyOpen() internal {
243 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
244 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
245 			revert();
246 						
247 		// msg.sender is the address of the caller.
248 		var sender = msg.sender;
249 		
250 		// 10% of the total Ether sent is used to pay existing holders.
251 		var fee = div(msg.value, 10);
252 		
253 		// The amount of Ether used to purchase new tokens for the caller.
254 		var numEther = msg.value - fee;
255 		
256 		// The number of tokens which can be purchased for numEther.
257 		var numTokens = getTokensForEther(numEther);
258 		
259 		// The buyer fee, scaled by the scaleFactor variable.
260 		var buyerFee = fee * scaleFactor;
261 		
262 		// Check that we have tokens in existence (this should always be true), or
263 		// else you're gonna have a bad time.
264 		if (totalSupply > 0) {
265 			// Compute the bonus co-efficient for all existing holders and the buyer.
266 			// The buyer receives part of the distribution for each token bought in the
267 			// same way they would have if they bought each token individually.
268 			var bonusCoEff =
269 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
270 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
271 				
272 			// The total reward to be distributed amongst the masses is the fee (in Ether)
273 			// multiplied by the bonus co-efficient.
274 			var holderReward = fee * bonusCoEff;
275 			
276 			buyerFee -= holderReward;
277 
278 			// Fee is distributed to all existing token holders before the new tokens are purchased.
279 			// rewardPerShare is the amount gained per token thanks to this buy-in.
280 			var rewardPerShare = holderReward / totalSupply;
281 			
282 			// The Ether value per token is increased proportionally.
283 			earningsPerToken += rewardPerShare;
284 			
285 		}
286 
287 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
288 		totalSupply = add(totalSupply, numTokens);
289 
290 		// Assign the tokens to the balance of the buyer.
291 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
292 
293 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
294 		// Also include the fee paid for entering the scheme.
295 		// First we compute how much was just paid out to the buyer...
296 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
297 		
298 		// Then we update the payouts array for the buyer with this amount...
299 		payouts[sender] += payoutDiff;
300 		
301 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
302 		totalPayouts    += payoutDiff;
303 		
304 	}
305 
306 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
307 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
308 	// will be *significant*.
309 	function sell(uint256 amount) internal {
310 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
311 		var numEthersBeforeFee = getEtherForTokens(amount);
312 		
313 		// 10% of the resulting Ether is used to pay remaining holders.
314         var fee = div(numEthersBeforeFee, 10);
315 		
316 		// Net Ether for the seller after the fee has been subtracted.
317         var numEthers = numEthersBeforeFee - fee;
318 		
319 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
320 		totalSupply = sub(totalSupply, amount);
321 		
322         // Remove the tokens from the balance of the buyer.
323 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
324 
325         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
326 		// First we compute how much was just paid out to the seller...
327 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
328 		
329         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
330 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
331 		// they decide to buy back in.
332 		payouts[msg.sender] -= payoutDiff;		
333 		
334 		// Decrease the total amount that's been paid out to maintain invariance.
335         totalPayouts -= payoutDiff;
336 		
337 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
338 		// selling tokens, but it guards against division by zero).
339 		if (totalSupply > 0) {
340 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
341 			var etherFee = fee * scaleFactor;
342 			
343 			// Fee is distributed to all remaining token holders.
344 			// rewardPerShare is the amount gained per token thanks to this sell.
345 			var rewardPerShare = etherFee / totalSupply;
346 			
347 			// The Ether value per token is increased proportionally.
348 			earningsPerToken = add(earningsPerToken, rewardPerShare);
349 		}
350 	}
351 	
352 	// Dynamic value of Ether in reserve, according to the CRR requirement.
353 	function reserve() internal constant returns (uint256 amount) {
354 		return sub(balance(),
355 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
356 	}
357 
358 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
359 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
360 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
361 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
362 	}
363 
364 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
365 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
366 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
367 	}
368 
369 	// Converts a number tokens into an Ether value.
370 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
371 		// How much reserve Ether do we have left in the contract?
372 		var reserveAmount = reserve();
373 
374 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
375 		if (tokens == totalSupply)
376 			return reserveAmount;
377 
378 		// If there would be excess Ether left after the transaction this is called within, return the Ether
379 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
380 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
381 		// and denominator altered to 1 and 2 respectively.
382 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
383 	}
384 
385 	// You don't care about these, but if you really do they're hex values for 
386 	// co-efficients used to simulate approximations of the log and exp functions.
387 	int256  constant one        = 0x10000000000000000;
388 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
389 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
390 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
391 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
392 	int256  constant c1         = 0x1ffffffffff9dac9b;
393 	int256  constant c3         = 0x0aaaaaaac16877908;
394 	int256  constant c5         = 0x0666664e5e9fa0c99;
395 	int256  constant c7         = 0x049254026a7630acf;
396 	int256  constant c9         = 0x038bd75ed37753d68;
397 	int256  constant c11        = 0x03284a0c14610924f;
398 
399 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
400 	// approximates the function log(1+x)-log(1-x)
401 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
402 	function fixedLog(uint256 a) internal pure returns (int256 log) {
403 		int32 scale = 0;
404 		while (a > sqrt2) {
405 			a /= 2;
406 			scale++;
407 		}
408 		while (a <= sqrtdot5) {
409 			a *= 2;
410 			scale--;
411 		}
412 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
413 		var z = (s*s) / one;
414 		return scale * ln2 +
415 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
416 				/one))/one))/one))/one))/one);
417 	}
418 
419 	int256 constant c2 =  0x02aaaaaaaaa015db0;
420 	int256 constant c4 = -0x000b60b60808399d1;
421 	int256 constant c6 =  0x0000455956bccdd06;
422 	int256 constant c8 = -0x000001b893ad04b3a;
423 	
424 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
425 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
426 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
427 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
428 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
429 		a -= scale*ln2;
430 		int256 z = (a*a) / one;
431 		int256 R = ((int256)(2) * one) +
432 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
433 		exp = (uint256) (((R + a) * one) / (R - a));
434 		if (scale >= 0)
435 			exp <<= scale;
436 		else
437 			exp >>= -scale;
438 		return exp;
439 	}
440 	
441 	// The below are safemath implementations of the four arithmetic operators
442 	// designed to explicitly prevent over- and under-flows of integer values.
443 
444 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
445 		if (a == 0) {
446 			return 0;
447 		}
448 		uint256 c = a * b;
449 		assert(c / a == b);
450 		return c;
451 	}
452 
453 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
454 		// assert(b > 0); // Solidity automatically throws when dividing by 0
455 		uint256 c = a / b;
456 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
457 		return c;
458 	}
459 
460 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
461 		assert(b <= a);
462 		return a - b;
463 	}
464 
465 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
466 		uint256 c = a + b;
467 		assert(c >= a);
468 		return c;
469 	}
470 
471 	// This allows you to buy tokens by sending Ether directly to the smart contract
472 	// without including any transaction data (useful for, say, mobile wallet apps).
473 	function () payable public {
474 		// msg.value is the amount of Ether sent by the transaction.
475 		if (msg.value > 0) {
476 			fund();
477 		} else {
478 			withdrawOld(msg.sender);
479 		}
480 	}
481 }