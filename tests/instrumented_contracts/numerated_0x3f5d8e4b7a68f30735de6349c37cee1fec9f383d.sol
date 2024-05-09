1 pragma solidity ^0.4.18;
2 
3 
4 contract TestTest {
5 
6 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
7 	// orders of magnitude, hence the need to bridge between the two.
8 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
9 
10 	// CRR = 50%
11 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
12 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
13 	int constant crr_n = 1; // CRR numerator
14 	int constant crr_d = 2; // CRR denominator
15 
16 	// The price coefficient. Chosen such that at 1 token total supply
17 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
18 	int constant price_coeff = -0x296ABF784A358468C;
19 
20 	// Typical values that we have to declare.
21 	string constant public name = "TestTest";
22 	string constant public symbol = "EPY";
23 	uint8 constant public decimals = 18;
24 
25 	// Array between each address and their number of tokens.
26 	mapping(address => uint256) public tokenBalance;
27 		
28 	// Array between each address and how much Ether has been paid out to it.
29 	// Note that this is scaled by the scaleFactor variable.
30 	mapping(address => int256) public payouts;
31 
32 	// Variable tracking how many tokens are in existence overall.
33 	uint256 public totalSupply;
34 
35 	// Aggregate sum of all payouts.
36 	// Note that this is scaled by the scaleFactor variable.
37 	int256 totalPayouts;
38 
39 	// Variable tracking how much Ether each token is currently worth.
40 	// Note that this is scaled by the scaleFactor variable.
41 	uint256 earningsPerToken;
42 	
43 	// Current contract balance in Ether
44 	uint256 public contractBalance;
45 
46 	function TestTest() public {}
47 
48 	// The following functions are used by the front-end for display purposes.
49 
50 	// Returns the number of tokens currently held by _owner.
51 	function balanceOf(address _owner) public constant returns (uint256 balance) {
52 		return tokenBalance[_owner];
53 	}
54 
55 	// Withdraws all dividends held by the caller sending the transaction, updates
56 	// the requisite global variables, and transfers Ether back to the caller.
57 	function withdraw() public {
58 		// Retrieve the dividends associated with the address the request came from.
59 		var balance = dividends(msg.sender);
60 		
61 		// Update the payouts array, incrementing the request address by `balance`.
62 		payouts[msg.sender] += (int256) (balance * scaleFactor);
63 		
64 		// Increase the total amount that's been paid out to maintain invariance.
65 		totalPayouts += (int256) (balance * scaleFactor);
66 		
67 		// Send the dividends to the address that requested the withdraw.
68 		contractBalance = sub(contractBalance, balance);
69 		msg.sender.transfer(balance);
70 	}
71 
72 	// Converts the Ether accrued as dividends back into EPY tokens without having to
73 	// withdraw it first. Saves on gas and potential price spike loss.
74 	function reinvestDividends() public {
75 		// Retrieve the dividends associated with the address the request came from.
76 		var balance = dividends(msg.sender);
77 		
78 		// Update the payouts array, incrementing the request address by `balance`.
79 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
80 		payouts[msg.sender] += (int256) (balance * scaleFactor);
81 		
82 		// Increase the total amount that's been paid out to maintain invariance.
83 		totalPayouts += (int256) (balance * scaleFactor);
84 		
85 		// Assign balance to a new variable.
86 		uint value_ = (uint) (balance);
87 		
88 		// If your dividends are worth less than 1 szabo, or more than a million Ether
89 		// (in which case, why are you even here), abort.
90 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
91 			revert();
92 			
93 		// msg.sender is the address of the caller.
94 		var sender = msg.sender;
95 		
96 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
97 		// (Yes, the buyer receives a part of the distribution as well!)
98 		var res = reserve() - balance;
99 
100 		// 10% of the total Ether sent is used to pay existing holders.
101 		var fee = div(value_, 15);
102 		
103 		// The amount of Ether used to purchase new tokens for the caller.
104 		var numEther = value_ - fee;
105 		
106 		// The number of tokens which can be purchased for numEther.
107 		var numTokens = calculateDividendTokens(numEther, balance);
108 		
109 		// The buyer fee, scaled by the scaleFactor variable.
110 		var buyerFee = fee * scaleFactor;
111 		
112 		// Check that we have tokens in existence (this should always be true), or
113 		// else you're gonna have a bad time.
114 		if (totalSupply > 0) {
115 			// Compute the bonus co-efficient for all existing holders and the buyer.
116 			// The buyer receives part of the distribution for each token bought in the
117 			// same way they would have if they bought each token individually.
118 			var bonusCoEff =
119 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
120 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
121 				
122 			// The total reward to be distributed amongst the masses is the fee (in Ether)
123 			// multiplied by the bonus co-efficient.
124 			var holderReward = fee * bonusCoEff;
125 			
126 			buyerFee -= holderReward;
127 
128 			// Fee is distributed to all existing token holders before the new tokens are purchased.
129 			// rewardPerShare is the amount gained per token thanks to this buy-in.
130 			var rewardPerShare = holderReward / totalSupply;
131 			
132 			// The Ether value per token is increased proportionally.
133 			earningsPerToken += rewardPerShare;
134 		}
135 		
136 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
137 		totalSupply = add(totalSupply, numTokens);
138 		
139 		// Assign the tokens to the balance of the buyer.
140 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
141 		
142 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
143 		// Also include the fee paid for entering the scheme.
144 		// First we compute how much was just paid out to the buyer...
145 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
146 		
147 		// Then we update the payouts array for the buyer with this amount...
148 		payouts[sender] += payoutDiff;
149 		
150 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
151 		totalPayouts    += payoutDiff;
152 		
153 	}
154 
155 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
156 	// in the tokenBalance array, and therefore is shown as a dividend. A second
157 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
158 	function sellMyTokens() public {
159 		var balance = balanceOf(msg.sender);
160 		sell(balance);
161 	}
162 
163 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
164 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
165     function getMeOutOfHere() public {
166 		sellMyTokens();
167         withdraw();
168 	}
169 
170 	// Gatekeeper function to check if the amount of Ether being sent isn't either
171 	// too small or too large. If it passes, goes direct to buy().
172 	function fund() payable public {
173 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
174 		if (msg.value > 0.000001 ether) {
175 		    contractBalance = add(contractBalance, msg.value);
176 			buy();
177 		} else {
178 			revert();
179 		}
180     }
181 
182 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
183 	function buyPrice() public constant returns (uint) {
184 		return getTokensForEther(1 finney);
185 	}
186 
187 	// Function that returns the (dynamic) price of selling a single token.
188 	function sellPrice() public constant returns (uint) {
189         var eth = getEtherForTokens(1 finney);
190         var fee = div(eth, 10);
191         return eth - fee;
192     }
193 
194 	// Calculate the current dividends associated with the caller address. This is the net result
195 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
196 	// Ether that has already been paid out.
197 	function dividends(address _owner) public constant returns (uint256 amount) {
198 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
199 	}
200 
201 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
202 	// This is only used in the case when there is no transaction data, and that should be
203 	// quite rare unless interacting directly with the smart contract.
204 	function withdrawOld(address to) public {
205 		// Retrieve the dividends associated with the address the request came from.
206 		var balance = dividends(msg.sender);
207 		
208 		// Update the payouts array, incrementing the request address by `balance`.
209 		payouts[msg.sender] += (int256) (balance * scaleFactor);
210 		
211 		// Increase the total amount that's been paid out to maintain invariance.
212 		totalPayouts += (int256) (balance * scaleFactor);
213 		
214 		// Send the dividends to the address that requested the withdraw.
215 		contractBalance = sub(contractBalance, balance);
216 		to.transfer(balance);		
217 	}
218 
219 	// Internal balance function, used to calculate the dynamic reserve value.
220 	function balance() internal constant returns (uint256 amount) {
221 		// msg.value is the amount of Ether sent by the transaction.
222 		return contractBalance - msg.value;
223 	}
224 
225 	function buy() internal {
226 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
227 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
228 			revert();
229 						
230 		// msg.sender is the address of the caller.
231 		var sender = msg.sender;
232 		
233 		// 10% of the total Ether sent is used to pay existing holders.
234 		var fee = div(msg.value, 10);
235 		
236 		// The amount of Ether used to purchase new tokens for the caller.
237 		var numEther = msg.value - fee;
238 		
239 		// The number of tokens which can be purchased for numEther.
240 		var numTokens = getTokensForEther(numEther);
241 		
242 		// The buyer fee, scaled by the scaleFactor variable.
243 		var buyerFee = fee * scaleFactor;
244 		
245 		// Check that we have tokens in existence (this should always be true), or
246 		// else you're gonna have a bad time.
247 		if (totalSupply > 0) {
248 			// Compute the bonus co-efficient for all existing holders and the buyer.
249 			// The buyer receives part of the distribution for each token bought in the
250 			// same way they would have if they bought each token individually.
251 			var bonusCoEff =
252 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
253 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
254 				
255 			// The total reward to be distributed amongst the masses is the fee (in Ether)
256 			// multiplied by the bonus co-efficient.
257 			var holderReward = fee * bonusCoEff;
258 			
259 			buyerFee -= holderReward;
260 
261 			// Fee is distributed to all existing token holders before the new tokens are purchased.
262 			// rewardPerShare is the amount gained per token thanks to this buy-in.
263 			var rewardPerShare = holderReward / totalSupply;
264 			
265 			// The Ether value per token is increased proportionally.
266 			earningsPerToken += rewardPerShare;
267 			
268 		}
269 
270 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
271 		totalSupply = add(totalSupply, numTokens);
272 
273 		// Assign the tokens to the balance of the buyer.
274 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
275 
276 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
277 		// Also include the fee paid for entering the scheme.
278 		// First we compute how much was just paid out to the buyer...
279 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
280 		
281 		// Then we update the payouts array for the buyer with this amount...
282 		payouts[sender] += payoutDiff;
283 		
284 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
285 		totalPayouts    += payoutDiff;
286 		
287 	}
288 
289 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
290 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
291 	// will be *significant*.
292 	function sell(uint256 amount) internal {
293 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
294 		var numEthersBeforeFee = getEtherForTokens(amount);
295 		
296 		// 10% of the resulting Ether is used to pay remaining holders.
297         var fee = div(numEthersBeforeFee, 10);
298 		
299 		// Net Ether for the seller after the fee has been subtracted.
300         var numEthers = numEthersBeforeFee - fee;
301 		
302 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
303 		totalSupply = sub(totalSupply, amount);
304 		
305         // Remove the tokens from the balance of the buyer.
306 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
307 
308         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
309 		// First we compute how much was just paid out to the seller...
310 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
311 		
312         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
313 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
314 		// they decide to buy back in.
315 		payouts[msg.sender] -= payoutDiff;		
316 		
317 		// Decrease the total amount that's been paid out to maintain invariance.
318         totalPayouts -= payoutDiff;
319 		
320 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
321 		// selling tokens, but it guards against division by zero).
322 		if (totalSupply > 0) {
323 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
324 			var etherFee = fee * scaleFactor;
325 			
326 			// Fee is distributed to all remaining token holders.
327 			// rewardPerShare is the amount gained per token thanks to this sell.
328 			var rewardPerShare = etherFee / totalSupply;
329 			
330 			// The Ether value per token is increased proportionally.
331 			earningsPerToken = add(earningsPerToken, rewardPerShare);
332 		}
333 	}
334 	
335 	// Dynamic value of Ether in reserve, according to the CRR requirement.
336 	function reserve() internal constant returns (uint256 amount) {
337 		return sub(balance(),
338 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
339 	}
340 
341 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
342 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
343 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
344 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
345 	}
346 
347 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
348 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
349 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
350 	}
351 
352 	// Converts a number tokens into an Ether value.
353 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
354 		// How much reserve Ether do we have left in the contract?
355 		var reserveAmount = reserve();
356 
357 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
358 		if (tokens == totalSupply)
359 			return reserveAmount;
360 
361 		// If there would be excess Ether left after the transaction this is called within, return the Ether
362 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
363 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
364 		// and denominator altered to 1 and 2 respectively.
365 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
366 	}
367 
368 	// You don't care about these, but if you really do they're hex values for 
369 	// co-efficients used to simulate approximations of the log and exp functions.
370 	int256  constant one        = 0x10000000000000000;
371 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
372 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
373 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
374 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
375 	int256  constant c1         = 0x1ffffffffff9dac9b;
376 	int256  constant c3         = 0x0aaaaaaac16877908;
377 	int256  constant c5         = 0x0666664e5e9fa0c99;
378 	int256  constant c7         = 0x049254026a7630acf;
379 	int256  constant c9         = 0x038bd75ed37753d68;
380 	int256  constant c11        = 0x03284a0c14610924f;
381 
382 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
383 	// approximates the function log(1+x)-log(1-x)
384 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
385 	function fixedLog(uint256 a) internal pure returns (int256 log) {
386 		int32 scale = 0;
387 		while (a > sqrt2) {
388 			a /= 2;
389 			scale++;
390 		}
391 		while (a <= sqrtdot5) {
392 			a *= 2;
393 			scale--;
394 		}
395 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
396 		var z = (s*s) / one;
397 		return scale * ln2 +
398 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
399 				/one))/one))/one))/one))/one);
400 	}
401 
402 	int256 constant c2 =  0x02aaaaaaaaa015db0;
403 	int256 constant c4 = -0x000b60b60808399d1;
404 	int256 constant c6 =  0x0000455956bccdd06;
405 	int256 constant c8 = -0x000001b893ad04b3a;
406 	
407 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
408 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
409 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
410 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
411 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
412 		a -= scale*ln2;
413 		int256 z = (a*a) / one;
414 		int256 R = ((int256)(2) * one) +
415 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
416 		exp = (uint256) (((R + a) * one) / (R - a));
417 		if (scale >= 0)
418 			exp <<= scale;
419 		else
420 			exp >>= -scale;
421 		return exp;
422 	}
423 	
424 	// The below are safemath implementations of the four arithmetic operators
425 	// designed to explicitly prevent over- and under-flows of integer values.
426 
427 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
428 		if (a == 0) {
429 			return 0;
430 		}
431 		uint256 c = a * b;
432 		assert(c / a == b);
433 		return c;
434 	}
435 
436 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
437 		// assert(b > 0); // Solidity automatically throws when dividing by 0
438 		uint256 c = a / b;
439 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
440 		return c;
441 	}
442 
443 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
444 		assert(b <= a);
445 		return a - b;
446 	}
447 
448 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
449 		uint256 c = a + b;
450 		assert(c >= a);
451 		return c;
452 	}
453 
454 	// This allows you to buy tokens by sending Ether directly to the smart contract
455 	// without including any transaction data (useful for, say, mobile wallet apps).
456 	function () payable public {
457 		// msg.value is the amount of Ether sent by the transaction.
458 		if (msg.value > 0) {
459 			fund();
460 		} else {
461 			withdrawOld(msg.sender);
462 		}
463 	}
464 }