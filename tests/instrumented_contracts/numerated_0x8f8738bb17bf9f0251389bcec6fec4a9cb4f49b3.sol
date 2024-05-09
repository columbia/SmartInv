1 pragma solidity ^0.4.18;
2 
3 /*
4  ShadowPeak. The world's first ever REVERSE Ponzi! Last In Last Out.
5  
6  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
7 
8  Development:
9 	Arc
10 	Divine
11 	Norsefire
12 	ToCsIcK
13 
14  Mathmematics:
15     QuantumDeath666
16 	
17  Immoral Support:
18     tc99
19     brypto
20     sixmiledrive
21     shadowofphobos
22     
23  Shit-Tier:
24     SECnigger
25  
26 */
27 
28 contract ShadowPeak {
29 
30 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
31 	// orders of magnitude, hence the need to bridge between the two.
32 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
33 
34 	// CRR = 50%
35 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
36 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
37 	int constant crr_n = 2; // CRR numerator
38 	int constant crr_d = 1; // CRR denominator
39 
40 	// The price coefficient. Chosen such that at 1 token total supply
41 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
42 	int constant price_coeff = -0x102DB2CAFCFCE7B8F;
43 
44 	// Typical values that we have to declare.
45 	string constant public name = "ShadowPeak";
46 	string constant public symbol = "SHP";
47 	uint8 constant public decimals = 18;
48 
49 	// Array between each address and their number of tokens.
50 	mapping(address => uint256) public tokenBalance;
51 		
52 	// Array between each address and how much Ether has been paid out to it.
53 	// Note that this is scaled by the scaleFactor variable.
54 	mapping(address => int256) public payouts;
55 
56 	// Variable tracking how many tokens are in existence overall.
57 	uint256 public totalSupply;
58 
59 	// Aggregate sum of all payouts.
60 	// Note that this is scaled by the scaleFactor variable.
61 	int256 totalPayouts;
62 
63 	// Variable tracking how much Ether each token is currently worth.
64 	// Note that this is scaled by the scaleFactor variable.
65 	uint256 earningsPerToken;
66 	
67 	// Current contract balance in Ether
68 	uint256 public contractBalance;
69 
70 	function ShadowPeak() public {}
71 
72 	// The following functions are used by the front-end for display purposes.
73 
74 	// Returns the number of tokens currently held by _owner.
75 	function balanceOf(address _owner) public constant returns (uint256 balance) {
76 		return tokenBalance[_owner];
77 	}
78 
79 	// Withdraws all dividends held by the caller sending the transaction, updates
80 	// the requisite global variables, and transfers Ether back to the caller.
81 	function withdraw() public {
82 		// Retrieve the dividends associated with the address the request came from.
83 		var balance = dividends(msg.sender);
84 		
85 		// Update the payouts array, incrementing the request address by `balance`.
86 		payouts[msg.sender] += (int256) (balance * scaleFactor);
87 		
88 		// Increase the total amount that's been paid out to maintain invariance.
89 		totalPayouts += (int256) (balance * scaleFactor);
90 		
91 		// Send the dividends to the address that requested the withdraw.
92 		contractBalance = sub(contractBalance, balance);
93 		msg.sender.transfer(balance);
94 	}
95 
96 	// Converts the Ether accrued as dividends back into EPY tokens without having to
97 	// withdraw it first. Saves on gas and potential price spike loss.
98 	function reinvestDividends() public {
99 		// Retrieve the dividends associated with the address the request came from.
100 		var balance = dividends(msg.sender);
101 		
102 		// Update the payouts array, incrementing the request address by `balance`.
103 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
104 		payouts[msg.sender] += (int256) (balance * scaleFactor);
105 		
106 		// Increase the total amount that's been paid out to maintain invariance.
107 		totalPayouts += (int256) (balance * scaleFactor);
108 		
109 		// Assign balance to a new variable.
110 		uint value_ = (uint) (balance);
111 		
112 		// If your dividends are worth less than 1 szabo, or more than a million Ether
113 		// (in which case, why are you even here), abort.
114 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
115 			revert();
116 			
117 		// msg.sender is the address of the caller.
118 		var sender = msg.sender;
119 		
120 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
121 		// (Yes, the buyer receives a part of the distribution as well!)
122 		var res = reserve() - balance;
123 
124 		// 10% of the total Ether sent is used to pay existing holders.
125 		var fee = div(value_, 10);
126 		
127 		// The amount of Ether used to purchase new tokens for the caller.
128 		var numEther = value_ - fee;
129 		
130 		// The number of tokens which can be purchased for numEther.
131 		var numTokens = calculateDividendTokens(numEther, balance);
132 		
133 		// The buyer fee, scaled by the scaleFactor variable.
134 		var buyerFee = fee * scaleFactor;
135 		
136 		// Check that we have tokens in existence (this should always be true), or
137 		// else you're gonna have a bad time.
138 		if (totalSupply > 0) {
139 			// Compute the bonus co-efficient for all existing holders and the buyer.
140 			// The buyer receives part of the distribution for each token bought in the
141 			// same way they would have if they bought each token individually.
142 			var bonusCoEff =
143 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
144 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
145 				
146 			// The total reward to be distributed amongst the masses is the fee (in Ether)
147 			// multiplied by the bonus co-efficient.
148 			var holderReward = fee * bonusCoEff;
149 			
150 			buyerFee -= holderReward;
151 
152 			// Fee is distributed to all existing token holders before the new tokens are purchased.
153 			// rewardPerShare is the amount gained per token thanks to this buy-in.
154 			var rewardPerShare = holderReward / totalSupply;
155 			
156 			// The Ether value per token is increased proportionally.
157 			earningsPerToken += rewardPerShare;
158 		}
159 		
160 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
161 		totalSupply = add(totalSupply, numTokens);
162 		
163 		// Assign the tokens to the balance of the buyer.
164 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
165 		
166 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
167 		// Also include the fee paid for entering the scheme.
168 		// First we compute how much was just paid out to the buyer...
169 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
170 		
171 		// Then we update the payouts array for the buyer with this amount...
172 		payouts[sender] += payoutDiff;
173 		
174 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
175 		totalPayouts    += payoutDiff;
176 		
177 	}
178 
179 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
180 	// in the tokenBalance array, and therefore is shown as a dividend. A second
181 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
182 	function sellMyTokens() public {
183 		var balance = balanceOf(msg.sender);
184 		sell(balance);
185 	}
186 
187 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
188 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
189     function getMeOutOfHere() public {
190 		sellMyTokens();
191         withdraw();
192 	}
193 
194 	// Gatekeeper function to check if the amount of Ether being sent isn't either
195 	// too small or too large. If it passes, goes direct to buy().
196 	function fund() payable public {
197 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
198 		if (msg.value > 0.000001 ether) {
199 		    contractBalance = add(contractBalance, msg.value);
200 			buy();
201 		} else {
202 			revert();
203 		}
204     }
205 
206 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
207 	function buyPrice() public constant returns (uint) {
208 		return getTokensForEther(1 finney);
209 	}
210 
211 	// Function that returns the (dynamic) price of selling a single token.
212 	function sellPrice() public constant returns (uint) {
213         var eth = getEtherForTokens(1 finney);
214         var fee = div(eth, 10);
215         return eth - fee;
216     }
217 
218 	// Calculate the current dividends associated with the caller address. This is the net result
219 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
220 	// Ether that has already been paid out.
221 	function dividends(address _owner) public constant returns (uint256 amount) {
222 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
223 	}
224 
225 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
226 	// This is only used in the case when there is no transaction data, and that should be
227 	// quite rare unless interacting directly with the smart contract.
228 	function withdrawOld(address to) public {
229 		// Retrieve the dividends associated with the address the request came from.
230 		var balance = dividends(msg.sender);
231 		
232 		// Update the payouts array, incrementing the request address by `balance`.
233 		payouts[msg.sender] += (int256) (balance * scaleFactor);
234 		
235 		// Increase the total amount that's been paid out to maintain invariance.
236 		totalPayouts += (int256) (balance * scaleFactor);
237 		
238 		// Send the dividends to the address that requested the withdraw.
239 		contractBalance = sub(contractBalance, balance);
240 		to.transfer(balance);		
241 	}
242 
243 	// Internal balance function, used to calculate the dynamic reserve value.
244 	function balance() internal constant returns (uint256 amount) {
245 		// msg.value is the amount of Ether sent by the transaction.
246 		return contractBalance - msg.value;
247 	}
248 
249 	function buy() internal {
250 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
251 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
252 			revert();
253 						
254 		// msg.sender is the address of the caller.
255 		var sender = msg.sender;
256 		
257 		// 10% of the total Ether sent is used to pay existing holders.
258 		var fee = div(msg.value, 10);
259 		
260 		// The amount of Ether used to purchase new tokens for the caller.
261 		var numEther = msg.value - fee;
262 		
263 		// The number of tokens which can be purchased for numEther.
264 		var numTokens = getTokensForEther(numEther);
265 		
266 		// The buyer fee, scaled by the scaleFactor variable.
267 		var buyerFee = fee * scaleFactor;
268 		
269 		// Check that we have tokens in existence (this should always be true), or
270 		// else you're gonna have a bad time.
271 		if (totalSupply > 0) {
272 			// Compute the bonus co-efficient for all existing holders and the buyer.
273 			// The buyer receives part of the distribution for each token bought in the
274 			// same way they would have if they bought each token individually.
275 			var bonusCoEff =
276 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
277 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
278 				
279 			// The total reward to be distributed amongst the masses is the fee (in Ether)
280 			// multiplied by the bonus co-efficient.
281 			var holderReward = fee * bonusCoEff;
282 			
283 			buyerFee -= holderReward;
284 
285 			// Fee is distributed to all existing token holders before the new tokens are purchased.
286 			// rewardPerShare is the amount gained per token thanks to this buy-in.
287 			var rewardPerShare = holderReward / totalSupply;
288 			
289 			// The Ether value per token is increased proportionally.
290 			earningsPerToken += rewardPerShare;
291 			
292 		}
293 
294 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
295 		totalSupply = add(totalSupply, numTokens);
296 
297 		// Assign the tokens to the balance of the buyer.
298 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
299 
300 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
301 		// Also include the fee paid for entering the scheme.
302 		// First we compute how much was just paid out to the buyer...
303 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
304 		
305 		// Then we update the payouts array for the buyer with this amount...
306 		payouts[sender] += payoutDiff;
307 		
308 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
309 		totalPayouts    += payoutDiff;
310 		
311 	}
312 
313 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
314 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
315 	// will be *significant*.
316 	function sell(uint256 amount) internal {
317 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
318 		var numEthersBeforeFee = getEtherForTokens(amount);
319 		
320 		// 10% of the resulting Ether is used to pay remaining holders.
321         var fee = div(numEthersBeforeFee, 10);
322 		
323 		// Net Ether for the seller after the fee has been subtracted.
324         var numEthers = numEthersBeforeFee - fee;
325 		
326 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
327 		totalSupply = sub(totalSupply, amount);
328 		
329         // Remove the tokens from the balance of the buyer.
330 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
331 
332         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
333 		// First we compute how much was just paid out to the seller...
334 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
335 		
336         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
337 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
338 		// they decide to buy back in.
339 		payouts[msg.sender] -= payoutDiff;		
340 		
341 		// Decrease the total amount that's been paid out to maintain invariance.
342         totalPayouts -= payoutDiff;
343 		
344 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
345 		// selling tokens, but it guards against division by zero).
346 		if (totalSupply > 0) {
347 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
348 			var etherFee = fee * scaleFactor;
349 			
350 			// Fee is distributed to all remaining token holders.
351 			// rewardPerShare is the amount gained per token thanks to this sell.
352 			var rewardPerShare = etherFee / totalSupply;
353 			
354 			// The Ether value per token is increased proportionally.
355 			earningsPerToken = add(earningsPerToken, rewardPerShare);
356 		}
357 	}
358 	
359 	// Dynamic value of Ether in reserve, according to the CRR requirement.
360 	function reserve() internal constant returns (uint256 amount) {
361 		return sub(balance(),
362 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
363 	}
364 
365 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
366 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
367 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
368 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
369 	}
370 
371 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
372 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
373 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
374 	}
375 
376 	// Converts a number tokens into an Ether value.
377 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
378 		// How much reserve Ether do we have left in the contract?
379 		var reserveAmount = reserve();
380 
381 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
382 		if (tokens == totalSupply)
383 			return reserveAmount;
384 
385 		// If there would be excess Ether left after the transaction this is called within, return the Ether
386 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
387 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
388 		// and denominator altered to 1 and 2 respectively.
389 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
390 	}
391 
392 	// You don't care about these, but if you really do they're hex values for 
393 	// co-efficients used to simulate approximations of the log and exp functions.
394 	int256  constant one        = 0x10000000000000000;
395 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
396 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
397 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
398 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
399 	int256  constant c1         = 0x1ffffffffff9dac9b;
400 	int256  constant c3         = 0x0aaaaaaac16877908;
401 	int256  constant c5         = 0x0666664e5e9fa0c99;
402 	int256  constant c7         = 0x049254026a7630acf;
403 	int256  constant c9         = 0x038bd75ed37753d68;
404 	int256  constant c11        = 0x03284a0c14610924f;
405 
406 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
407 	// approximates the function log(1+x)-log(1-x)
408 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
409 	function fixedLog(uint256 a) internal pure returns (int256 log) {
410 		int32 scale = 0;
411 		while (a > sqrt2) {
412 			a /= 2;
413 			scale++;
414 		}
415 		while (a <= sqrtdot5) {
416 			a *= 2;
417 			scale--;
418 		}
419 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
420 		var z = (s*s) / one;
421 		return scale * ln2 +
422 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
423 				/one))/one))/one))/one))/one);
424 	}
425 
426 	int256 constant c2 =  0x02aaaaaaaaa015db0;
427 	int256 constant c4 = -0x000b60b60808399d1;
428 	int256 constant c6 =  0x0000455956bccdd06;
429 	int256 constant c8 = -0x000001b893ad04b3a;
430 	
431 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
432 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
433 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
434 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
435 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
436 		a -= scale*ln2;
437 		int256 z = (a*a) / one;
438 		int256 R = ((int256)(2) * one) +
439 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
440 		exp = (uint256) (((R + a) * one) / (R - a));
441 		if (scale >= 0)
442 			exp <<= scale;
443 		else
444 			exp >>= -scale;
445 		return exp;
446 	}
447 	
448 	// The below are safemath implementations of the four arithmetic operators
449 	// designed to explicitly prevent over- and under-flows of integer values.
450 
451 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
452 		if (a == 0) {
453 			return 0;
454 		}
455 		uint256 c = a * b;
456 		assert(c / a == b);
457 		return c;
458 	}
459 
460 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
461 		// assert(b > 0); // Solidity automatically throws when dividing by 0
462 		uint256 c = a / b;
463 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
464 		return c;
465 	}
466 
467 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
468 		assert(b <= a);
469 		return a - b;
470 	}
471 
472 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
473 		uint256 c = a + b;
474 		assert(c >= a);
475 		return c;
476 	}
477 
478 	// This allows you to buy tokens by sending Ether directly to the smart contract
479 	// without including any transaction data (useful for, say, mobile wallet apps).
480 	function () payable public {
481 		// msg.value is the amount of Ether sent by the transaction.
482 		if (msg.value > 0) {
483 			fund();
484 		} else {
485 			withdrawOld(msg.sender);
486 		}
487 	}
488 }