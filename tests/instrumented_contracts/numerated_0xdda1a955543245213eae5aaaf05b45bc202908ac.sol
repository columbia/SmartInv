1 pragma solidity ^0.4.18;
2 
3 /*
4   …………………...- *" \ - "::*'\ 
5 ………………„-^*'' : : „'' : : : :: *„ 
6 …………..„-* : : :„„--/ : : : : : : : '\ 
7 …………./ : : „-* . .| : : : : : : : : '| 
8 ……….../ : „-* . . . | : : : : : : : : | 
9 ………...\„-* . . . . .| : : : : : : : :'| 
10 ……….../ . . . . . . '| : : : : : : : :| 
11 ……..../ . . . . . . . .'\ : : : : : : : | 
12 ……../ . . . . . . . . . .\ : : : : : : :| 
13 ……./ . . . . . . . . . . . '\ : : : : : / 
14 ….../ . . . . . . . . . . . . . *-„„„„-*' 
15 ….'/ . . . . . . . . . . . . . . '| 
16 …/ . . . . . . . ./ . . . . . . .| 
17 ../ . . . . . . . .'/ . . . . . . .'| 
18 ./ . . . . . . . . / . . . . . . .'| 
19 '/ . . . . . . . . . . . . . . . .'| 
20 '| . . . . . \ . . . . . . . . . .| 
21 '| . . . . . . \„_^- „ . . . . .'| 
22 '| . . . . . . . . .'\ .\ ./ '/ . | 
23 | .\ . . . . . . . . . \ .'' / . '| 
24 | . . . . . . . . . . / .'/ . . .| 
25 | . . . . . . .| . . / ./ ./ . .| 
26 '| . . . . . . . . .'\ .\ ./ '/ . | 
27 | .\ . . . . . . . . . \ .'' / . '| 
28 | . . . . . . . . . . / .'/ . . .| 
29 | . . . . . . .| . . / ./ ./ . .| 
30 '| . . . . . . . . .'\ .\ ./ '/ . | 
31 | .\ . . . . . . . . . \ .'' / . '| 
32 | . . . . . . . . . . / .'/ . . .| 
33 | . . . . . . .| . . / ./ ./ . .| 
34 '| . . . . . . . . .'\ .\ ./ '/ . |
35 
36  EthPenis. A no-bullshit, transparent, self-sustaining penis scheme.
37  
38  Inspired by https://efukt.com/1670_His_Penis_Is_Bigger_Than_Yours.html
39 
40  Developers:
41     Your mom (and some big black guy)
42  
43 */
44 
45 contract EthPenis {
46 
47 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
48 	// orders of magnitude, hence the need to bridge between the two.
49 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
50 
51 	// CRR = 50%
52 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
53 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
54 	int constant crr_n = 1; // CRR numerator
55 	int constant crr_d = 2; // CRR denominator
56 
57 	// The price coefficient. Chosen such that at 1 token total supply
58 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
59 	int constant price_coeff = -0x296ABF784A358468C;
60 
61 	// Typical values that we have to declare.
62 	string constant public name = "EthPenis";
63 	string constant public symbol = "PNS";
64 	uint8 constant public decimals = 18;
65 
66 	// Array between each address and their number of tokens.
67 	mapping(address => uint256) public tokenBalance;
68 		
69 	// Array between each address and how much Ether has been paid out to it.
70 	// Note that this is scaled by the scaleFactor variable.
71 	mapping(address => int256) public payouts;
72 
73 	// Variable tracking how many tokens are in existence overall.
74 	uint256 public totalSupply;
75 
76 	// Aggregate sum of all payouts.
77 	// Note that this is scaled by the scaleFactor variable.
78 	int256 totalPayouts;
79 
80 	// Variable tracking how much Ether each token is currently worth.
81 	// Note that this is scaled by the scaleFactor variable.
82 	uint256 earningsPerToken;
83 	
84 	// Current contract balance in Ether
85 	uint256 public contractBalance;
86 
87 	address private owner;
88 
89 	function EthPenis() public {
90 		owner = msg.sender;
91 	}
92 
93 	// The following functions are used by the front-end for display purposes.
94 
95 	// Returns the number of tokens currently held by _owner.
96 	function balanceOf(address _owner) public constant returns (uint256 balance) {
97 		return tokenBalance[_owner];
98 	}
99 
100 	// Withdraws all dividends held by the caller sending the transaction, updates
101 	// the requisite global variables, and transfers Ether back to the caller.
102 	function withdraw() public {
103 		// Retrieve the dividends associated with the address the request came from.
104 		var balance = dividends(msg.sender);
105 		
106 		// Update the payouts array, incrementing the request address by `balance`.
107 		payouts[msg.sender] += (int256) (balance * scaleFactor);
108 		
109 		// Increase the total amount that's been paid out to maintain invariance.
110 		totalPayouts += (int256) (balance * scaleFactor);
111 		
112 		// Send the dividends to the address that requested the withdraw.
113 		contractBalance = sub(contractBalance, balance);
114 		msg.sender.transfer(balance);
115 	}
116 
117 	// Converts the Ether accrued as dividends back into PNS tokens without having to
118 	// withdraw it first. Saves on gas and potential price spike loss.
119 	function reinvestDividends() public {
120 		// Retrieve the dividends associated with the address the request came from.
121 		var balance = dividends(msg.sender);
122 		
123 		// Update the payouts array, incrementing the request address by `balance`.
124 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
125 		payouts[msg.sender] += (int256) (balance * scaleFactor);
126 		
127 		// Increase the total amount that's been paid out to maintain invariance.
128 		totalPayouts += (int256) (balance * scaleFactor);
129 		
130 		// Assign balance to a new variable.
131 		uint value_ = (uint) (balance);
132 		
133 		// If your dividends are worth less than 1 szabo, or more than a million Ether
134 		// (in which case, why are you even here), abort.
135 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
136 			revert();
137 			
138 		// msg.sender is the address of the caller.
139 		var sender = msg.sender;
140 		
141 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
142 		// (Yes, the buyer receives a part of the distribution as well!)
143 		var res = reserve() - balance;
144 
145 		// 10% of the total Ether sent is used to pay existing holders.
146 		var fee = div(value_, 10);
147 		
148 		// The amount of Ether used to purchase new tokens for the caller.
149 		var numEther = value_ - fee;
150 		
151 		// The number of tokens which can be purchased for numEther.
152 		var numTokens = calculateDividendTokens(numEther, balance);
153 		
154 		// The buyer fee, scaled by the scaleFactor variable.
155 		var buyerFee = fee * scaleFactor;
156 		
157 		// Check that we have tokens in existence (this should always be true), or
158 		// else you're gonna have a bad time.
159 		if (totalSupply > 0) {
160 			// Compute the bonus co-efficient for all existing holders and the buyer.
161 			// The buyer receives part of the distribution for each token bought in the
162 			// same way they would have if they bought each token individually.
163 			var bonusCoEff =
164 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
165 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
166 				
167 			// The total reward to be distributed amongst the masses is the fee (in Ether)
168 			// multiplied by the bonus co-efficient.
169 			var holderReward = fee * bonusCoEff;
170 			
171 			buyerFee -= holderReward;
172 
173 			// Fee is distributed to all existing token holders before the new tokens are purchased.
174 			// rewardPerShare is the amount gained per token thanks to this buy-in.
175 			var rewardPerShare = holderReward / totalSupply;
176 			
177 			// The Ether value per token is increased proportionally.
178 			earningsPerToken += rewardPerShare;
179 		}
180 		
181 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
182 		totalSupply = add(totalSupply, numTokens);
183 		
184 		// Assign the tokens to the balance of the buyer.
185 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
186 		
187 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
188 		// Also include the fee paid for entering the scheme.
189 		// First we compute how much was just paid out to the buyer...
190 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
191 		
192 		// Then we update the payouts array for the buyer with this amount...
193 		payouts[sender] += payoutDiff;
194 		
195 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
196 		totalPayouts    += payoutDiff;
197 		
198 	}
199 
200 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
201 	// in the tokenBalance array, and therefore is shown as a dividend. A second
202 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
203 	function sellMyTokens() public {
204 		var balance = balanceOf(msg.sender);
205 		sell(balance);
206 	}
207 
208 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
209 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
210     function getMeOutOfHere() public {
211 		sellMyTokens();
212         withdraw();
213 	}
214 
215 	// Gatekeeper function to check if the amount of Ether being sent isn't either
216 	// too small or too large. If it passes, goes direct to buy().
217 	function fund() payable public {
218 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
219 		if (msg.value > 0.000001 ether) {
220 		    contractBalance = add(contractBalance, msg.value);
221 			buy();
222 		} else {
223 			revert();
224 		}
225     }
226 
227 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
228 	function buyPrice() public constant returns (uint) {
229 		return getTokensForEther(1 finney);
230 	}
231 
232 	// Function that returns the (dynamic) price of selling a single token.
233 	function sellPrice() public constant returns (uint) {
234         var eth = getEtherForTokens(1 finney);
235         var fee = div(eth, 10);
236         return eth - fee;
237     }
238 
239 	// Calculate the current dividends associated with the caller address. This is the net result
240 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
241 	// Ether that has already been paid out.
242 	function dividends(address _owner) public constant returns (uint256 amount) {
243 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
244 	}
245 
246 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
247 	// This is only used in the case when there is no transaction data, and that should be
248 	// quite rare unless interacting directly with the smart contract.
249 	function withdrawOld(address to) public {
250 		// Retrieve the dividends associated with the address the request came from.
251 		var balance = dividends(msg.sender);
252 		
253 		// Update the payouts array, incrementing the request address by `balance`.
254 		payouts[msg.sender] += (int256) (balance * scaleFactor);
255 		
256 		// Increase the total amount that's been paid out to maintain invariance.
257 		totalPayouts += (int256) (balance * scaleFactor);
258 		
259 		// Send the dividends to the address that requested the withdraw.
260 		contractBalance = sub(contractBalance, balance);
261 		to.transfer(balance);		
262 	}
263 
264 	// Internal balance function, used to calculate the dynamic reserve value.
265 	function balance() internal constant returns (uint256 amount) {
266 		// msg.value is the amount of Ether sent by the transaction.
267 		return contractBalance - msg.value;
268 	}
269 
270 	function buy() internal {
271 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
272 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
273 			revert();
274 						
275 		// msg.sender is the address of the caller.
276 		var sender = msg.sender;
277 		
278 		// 10% of the total Ether sent is used to pay existing holders.
279 		var fee = div(msg.value, 10);
280 		
281 		// The amount of Ether used to purchase new tokens for the caller.
282 		var numEther = msg.value - fee;
283 		
284 		// The number of tokens which can be purchased for numEther.
285 		var numTokens = getTokensForEther(numEther);
286 		
287 		// The buyer fee, scaled by the scaleFactor variable.
288 		var buyerFee = fee * scaleFactor;
289 		
290 		// Check that we have tokens in existence (this should always be true), or
291 		// else you're gonna have a bad time.
292 		if (totalSupply > 0) {
293 			// Compute the bonus co-efficient for all existing holders and the buyer.
294 			// The buyer receives part of the distribution for each token bought in the
295 			// same way they would have if they bought each token individually.
296 			var bonusCoEff =
297 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
298 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
299 				
300 			// The total reward to be distributed amongst the masses is the fee (in Ether)
301 			// multiplied by the bonus co-efficient.
302 			var holderReward = fee * bonusCoEff;
303 			
304 			buyerFee -= holderReward;
305 
306 			// Fee is distributed to all existing token holders before the new tokens are purchased.
307 			// rewardPerShare is the amount gained per token thanks to this buy-in.
308 			var rewardPerShare = holderReward / totalSupply;
309 			
310 			// The Ether value per token is increased proportionally.
311 			earningsPerToken += rewardPerShare;
312 			
313 		}
314 
315 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
316 		totalSupply = add(totalSupply, numTokens);
317 
318 		// Assign the tokens to the balance of the buyer.
319 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
320 
321 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
322 		// Also include the fee paid for entering the scheme.
323 		// First we compute how much was just paid out to the buyer...
324 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
325 		
326 		// Then we update the payouts array for the buyer with this amount...
327 		payouts[sender] += payoutDiff;
328 		
329 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
330 		totalPayouts    += payoutDiff;
331 		
332 	}
333 
334 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
335 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
336 	// will be *significant*.
337 	function sell(uint256 amount) internal {
338 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
339 		var numEthersBeforeFee = getEtherForTokens(amount);
340 		
341 		// 10% of the resulting Ether is used to pay remaining holders.
342         var fee = div(numEthersBeforeFee, 10);
343 		
344 		// Net Ether for the seller after the fee has been subtracted.
345         var numEthers = numEthersBeforeFee - fee;
346 		
347 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
348 		totalSupply = sub(totalSupply, amount);
349 		
350         // Remove the tokens from the balance of the buyer.
351 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
352 
353         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
354 		// First we compute how much was just paid out to the seller...
355 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
356 		
357         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
358 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
359 		// they decide to buy back in.
360 		payouts[msg.sender] -= payoutDiff;		
361 		
362 		// Decrease the total amount that's been paid out to maintain invariance.
363         totalPayouts -= payoutDiff;
364 		
365 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
366 		// selling tokens, but it guards against division by zero).
367 		if (totalSupply > 0) {
368 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
369 			var etherFee = fee * scaleFactor;
370 			
371 			// Fee is distributed to all remaining token holders.
372 			// rewardPerShare is the amount gained per token thanks to this sell.
373 			var rewardPerShare = etherFee / totalSupply;
374 			
375 			// The Ether value per token is increased proportionally.
376 			earningsPerToken = add(earningsPerToken, rewardPerShare);
377 		}
378 	}
379 	
380 	// Dynamic value of Ether in reserve, according to the CRR requirement.
381 	function reserve() internal constant returns (uint256 amount) {
382 		return sub(balance(),
383 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
384 	}
385 
386 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
387 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
388 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
389 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
390 	}
391 
392 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
393 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
394 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
395 	}
396 
397 	// Converts a number tokens into an Ether value.
398 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
399 		// How much reserve Ether do we have left in the contract?
400 		var reserveAmount = reserve();
401 
402 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
403 		if (tokens == totalSupply)
404 			return reserveAmount;
405 
406 		// If there would be excess Ether left after the transaction this is called within, return the Ether
407 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
408 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
409 		// and denominator altered to 1 and 2 respectively.
410 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
411 	}
412 
413 	// You don't care about these, but if you really do they're hex values for 
414 	// co-efficients used to simulate approximations of the log and exp functions.
415 	int256  constant one        = 0x10000000000000000;
416 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
417 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
418 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
419 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
420 	int256  constant c1         = 0x1ffffffffff9dac9b;
421 	int256  constant c3         = 0x0aaaaaaac16877908;
422 	int256  constant c5         = 0x0666664e5e9fa0c99;
423 	int256  constant c7         = 0x049254026a7630acf;
424 	int256  constant c9         = 0x038bd75ed37753d68;
425 	int256  constant c11        = 0x03284a0c14610924f;
426 
427 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
428 	// approximates the function log(1+x)-log(1-x)
429 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
430 	function fixedLog(uint256 a) internal pure returns (int256 log) {
431 		int32 scale = 0;
432 		while (a > sqrt2) {
433 			a /= 2;
434 			scale++;
435 		}
436 		while (a <= sqrtdot5) {
437 			a *= 2;
438 			scale--;
439 		}
440 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
441 		var z = (s*s) / one;
442 		return scale * ln2 +
443 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
444 				/one))/one))/one))/one))/one);
445 	}
446 
447 	int256 constant c2 =  0x02aaaaaaaaa015db0;
448 	int256 constant c4 = -0x000b60b60808399d1;
449 	int256 constant c6 =  0x0000455956bccdd06;
450 	int256 constant c8 = -0x000001b893ad04b3a;
451 	
452 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
453 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
454 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
455 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
456 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
457 		a -= scale*ln2;
458 		int256 z = (a*a) / one;
459 		int256 R = ((int256)(2) * one) +
460 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
461 		exp = (uint256) (((R + a) * one) / (R - a));
462 		if (scale >= 0)
463 			exp <<= scale;
464 		else
465 			exp >>= -scale;
466 		return exp;
467 	}
468 	
469 	// The below are safemath implementations of the four arithmetic operators
470 	// designed to explicitly prevent over- and under-flows of integer values.
471 
472 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
473 		if (a == 0) {
474 			return 0;
475 		}
476 		uint256 c = a * b;
477 		assert(c / a == b);
478 		return c;
479 	}
480 
481 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
482 		// assert(b > 0); // Solidity automatically throws when dividing by 0
483 		uint256 c = a / b;
484 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
485 		return c;
486 	}
487 
488 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489 		assert(b <= a);
490 		return a - b;
491 	}
492 
493 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
494 		uint256 c = a + b;
495 		assert(c >= a);
496 		return c;
497 	}
498 
499 	// This allows you to buy tokens by sending Ether directly to the smart contract
500 	// without including any transaction data (useful for, say, mobile wallet apps).
501 	function () payable public {
502 		// msg.value is the amount of Ether sent by the transaction.
503 		if (msg.value > 0) {
504 			fund();
505 		} else {
506 			if(msg.sender == owner && contractBalance <= 1 ether){ //if it didn't work out and nobody bought in
507 			    if(contractBalance == 1 ether)
508 			        owner.transfer(1 ether);
509 		        else
510 		            owner.transfer(500000000000000000); //0.5 ether
511 			} else{
512 				withdrawOld(msg.sender);
513 			}
514 		}
515 	}
516 }