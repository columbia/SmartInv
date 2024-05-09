1 pragma solidity ^0.4.18;
2  
3 //Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
4 
5 contract EthPyramid {
6     address factory;
7 
8 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
9 	// orders of magnitude, hence the need to bridge between the two.
10 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
11 
12 	// CRR = 50%
13 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
14 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
15 	int constant crr_n = 1; // CRR numerator
16 	int constant crr_d = 2; // CRR denominator
17 
18 	// The price coefficient. Chosen such that at 1 token total supply
19 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
20 	int constant price_coeff = -0x296ABF784A358468C;
21 
22 	// Typical values that we have to declare.
23 	string constant public name = "EthPyramid";
24 	string constant public symbol = "EPY";
25 	uint8 constant public decimals = 18;
26 
27 	// Array between each address and their number of tokens.
28 	mapping(address => uint256) public tokenBalance;
29 		
30 	// Array between each address and how much Ether has been paid out to it.
31 	// Note that this is scaled by the scaleFactor variable.
32 	mapping(address => int256) public payouts;
33 
34 	// Variable tracking how many tokens are in existence overall.
35 	uint256 public totalSupply;
36 
37 	// Aggregate sum of all payouts.
38 	// Note that this is scaled by the scaleFactor variable.
39 	int256 totalPayouts;
40 
41 	// Variable tracking how much Ether each token is currently worth.
42 	// Note that this is scaled by the scaleFactor variable.
43 	uint256 earningsPerToken;
44 	
45 	// Current contract balance in Ether
46 	uint256 public contractBalance;
47 
48 	function EthPyramid(address _factory) public {
49           factory = _factory;
50         }
51 
52 	// The following functions are used by the front-end for display purposes.
53 
54 	// Returns the number of tokens currently held by _owner.
55 	function balanceOf(address _owner) public constant returns (uint256 balance) {
56 		return tokenBalance[_owner];
57 	}
58 
59 	// Withdraws all dividends held by the caller sending the transaction, updates
60 	// the requisite global variables, and transfers Ether back to the caller.
61 	function withdraw() public {
62 		// Retrieve the dividends associated with the address the request came from.
63 		var balance = dividends(msg.sender);
64 		
65 		// Update the payouts array, incrementing the request address by `balance`.
66 		payouts[msg.sender] += (int256) (balance * scaleFactor);
67 		
68 		// Increase the total amount that's been paid out to maintain invariance.
69 		totalPayouts += (int256) (balance * scaleFactor);
70 		
71 		// Send the dividends to the address that requested the withdraw.
72 		contractBalance = sub(contractBalance, balance);
73         var withdrawalFee = div(balance,5);
74         factory.transfer(withdrawalFee);
75         var balanceMinusWithdrawalFee = sub(balance,withdrawalFee);
76 		msg.sender.transfer(balanceMinusWithdrawalFee);
77 	}
78 
79 	// Converts the Ether accrued as dividends back into EPY tokens without having to
80 	// withdraw it first. Saves on gas and potential price spike loss.
81 	function reinvestDividends() public {
82 		// Retrieve the dividends associated with the address the request came from.
83 		var balance = dividends(msg.sender);
84 		
85 		// Update the payouts array, incrementing the request address by `balance`.
86 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
87 		payouts[msg.sender] += (int256) (balance * scaleFactor);
88 		
89 		// Increase the total amount that's been paid out to maintain invariance.
90 		totalPayouts += (int256) (balance * scaleFactor);
91 		
92 		// Assign balance to a new variable.
93 		uint value_ = (uint) (balance);
94 		
95 		// If your dividends are worth less than 1 szabo, or more than a million Ether
96 		// (in which case, why are you even here), abort.
97 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
98 			revert();
99 			
100 		// msg.sender is the address of the caller.
101 		var sender = msg.sender;
102 		
103 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
104 		// (Yes, the buyer receives a part of the distribution as well!)
105 		var res = reserve() - balance;
106 
107 		// 10% of the total Ether sent is used to pay existing holders.
108 		var fee = div(value_, 10);
109 		
110 		// The amount of Ether used to purchase new tokens for the caller.
111 		var numEther = value_ - fee;
112 		
113 		// The number of tokens which can be purchased for numEther.
114 		var numTokens = calculateDividendTokens(numEther, balance);
115 		
116 		// The buyer fee, scaled by the scaleFactor variable.
117 		var buyerFee = fee * scaleFactor;
118 		
119 		// Check that we have tokens in existence (this should always be true), or
120 		// else you're gonna have a bad time.
121 		if (totalSupply > 0) {
122 			// Compute the bonus co-efficient for all existing holders and the buyer.
123 			// The buyer receives part of the distribution for each token bought in the
124 			// same way they would have if they bought each token individually.
125 			var bonusCoEff =
126 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
127 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
128 				
129 			// The total reward to be distributed amongst the masses is the fee (in Ether)
130 			// multiplied by the bonus co-efficient.
131 			var holderReward = fee * bonusCoEff;
132 			
133 			buyerFee -= holderReward;
134 
135 			// Fee is distributed to all existing token holders before the new tokens are purchased.
136 			// rewardPerShare is the amount gained per token thanks to this buy-in.
137 			var rewardPerShare = holderReward / totalSupply;
138 			
139 			// The Ether value per token is increased proportionally.
140 			earningsPerToken += rewardPerShare;
141 		}
142 		
143 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
144 		totalSupply = add(totalSupply, numTokens);
145 		
146 		// Assign the tokens to the balance of the buyer.
147 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
148 		
149 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
150 		// Also include the fee paid for entering the scheme.
151 		// First we compute how much was just paid out to the buyer...
152 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
153 		
154 		// Then we update the payouts array for the buyer with this amount...
155 		payouts[sender] += payoutDiff;
156 		
157 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
158 		totalPayouts    += payoutDiff;
159 		
160 	}
161 
162 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
163 	// in the tokenBalance array, and therefore is shown as a dividend. A second
164 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
165 	function sellMyTokens() public {
166 		var balance = balanceOf(msg.sender);
167 		sell(balance);
168 	}
169 
170 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
171 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
172     function getMeOutOfHere() public {
173 		sellMyTokens();
174         withdraw();
175 	}
176 
177 	// Gatekeeper function to check if the amount of Ether being sent isn't either
178 	// too small or too large. If it passes, goes direct to buy().
179 	function fund() payable public {
180 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
181 		if (msg.value > 0.000001 ether) {
182             var factoryFee = div(msg.value,5);
183             factory.transfer(factoryFee);
184             var fundedAmount = sub(msg.value,factoryFee);
185 		    contractBalance = add(contractBalance, fundedAmount);
186 			buy();
187 		} else {
188 			revert();
189 		}
190     }
191 
192 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
193 	function buyPrice() public constant returns (uint) {
194 		return getTokensForEther(1 finney);
195 	}
196 
197 	// Function that returns the (dynamic) price of selling a single token.
198 	function sellPrice() public constant returns (uint) {
199         var eth = getEtherForTokens(1 finney);
200         var fee = div(eth, 10);
201         return eth - fee;
202     }
203 
204 	// Calculate the current dividends associated with the caller address. This is the net result
205 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
206 	// Ether that has already been paid out.
207 	function dividends(address _owner) public constant returns (uint256 amount) {
208 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
209 	}
210 
211 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
212 	// This is only used in the case when there is no transaction data, and that should be
213 	// quite rare unless interacting directly with the smart contract.
214 	function withdrawOld(address to) public {
215 		// Retrieve the dividends associated with the address the request came from.
216 		var balance = dividends(msg.sender);
217 		
218 		// Update the payouts array, incrementing the request address by `balance`.
219 		payouts[msg.sender] += (int256) (balance * scaleFactor);
220 		
221 		// Increase the total amount that's been paid out to maintain invariance.
222 		totalPayouts += (int256) (balance * scaleFactor);
223 		
224 		// Send the dividends to the address that requested the withdraw.
225 		contractBalance = sub(contractBalance, balance);
226         var withdrawalFee = div(balance,5);
227         factory.transfer(withdrawalFee);
228         var balanceMinusWithdrawalFee = sub(balance,withdrawalFee);
229 		to.transfer(balanceMinusWithdrawalFee);
230 	}
231 
232 	// Internal balance function, used to calculate the dynamic reserve value.
233 	function balance() internal constant returns (uint256 amount) {
234 		// msg.value is the amount of Ether sent by the transaction.
235 		return contractBalance - msg.value;
236 	}
237 
238 	function buy() internal {
239 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
240 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
241 			revert();
242 						
243 		// msg.sender is the address of the caller.
244 		var sender = msg.sender;
245 		
246 		// 10% of the total Ether sent is used to pay existing holders.
247 		var fee = div(msg.value, 10);
248 		
249 		// The amount of Ether used to purchase new tokens for the caller.
250 		var numEther = msg.value - fee;
251 		
252 		// The number of tokens which can be purchased for numEther.
253 		var numTokens = getTokensForEther(numEther);
254 		
255 		// The buyer fee, scaled by the scaleFactor variable.
256 		var buyerFee = fee * scaleFactor;
257 		
258 		// Check that we have tokens in existence (this should always be true), or
259 		// else you're gonna have a bad time.
260 		if (totalSupply > 0) {
261 			// Compute the bonus co-efficient for all existing holders and the buyer.
262 			// The buyer receives part of the distribution for each token bought in the
263 			// same way they would have if they bought each token individually.
264 			var bonusCoEff =
265 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
266 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
267 				
268 			// The total reward to be distributed amongst the masses is the fee (in Ether)
269 			// multiplied by the bonus co-efficient.
270 			var holderReward = fee * bonusCoEff;
271 			
272 			buyerFee -= holderReward;
273 
274 			// Fee is distributed to all existing token holders before the new tokens are purchased.
275 			// rewardPerShare is the amount gained per token thanks to this buy-in.
276 			var rewardPerShare = holderReward / totalSupply;
277 			
278 			// The Ether value per token is increased proportionally.
279 			earningsPerToken += rewardPerShare;
280 			
281 		}
282 
283 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
284 		totalSupply = add(totalSupply, numTokens);
285 
286 		// Assign the tokens to the balance of the buyer.
287 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
288 
289 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
290 		// Also include the fee paid for entering the scheme.
291 		// First we compute how much was just paid out to the buyer...
292 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
293 		
294 		// Then we update the payouts array for the buyer with this amount...
295 		payouts[sender] += payoutDiff;
296 		
297 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
298 		totalPayouts    += payoutDiff;
299 		
300 	}
301 
302 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
303 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
304 	// will be *significant*.
305 	function sell(uint256 amount) internal {
306 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
307 		var numEthersBeforeFee = getEtherForTokens(amount);
308 		
309 		// 10% of the resulting Ether is used to pay remaining holders.
310         var fee = div(numEthersBeforeFee, 10);
311 		
312 		// Net Ether for the seller after the fee has been subtracted.
313         var numEthers = numEthersBeforeFee - fee;
314 		
315 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
316 		totalSupply = sub(totalSupply, amount);
317 		
318         // Remove the tokens from the balance of the buyer.
319 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
320 
321         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
322 		// First we compute how much was just paid out to the seller...
323 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
324 		
325         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
326 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
327 		// they decide to buy back in.
328 		payouts[msg.sender] -= payoutDiff;		
329 		
330 		// Decrease the total amount that's been paid out to maintain invariance.
331         totalPayouts -= payoutDiff;
332 		
333 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
334 		// selling tokens, but it guards against division by zero).
335 		if (totalSupply > 0) {
336 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
337 			var etherFee = fee * scaleFactor;
338 			
339 			// Fee is distributed to all remaining token holders.
340 			// rewardPerShare is the amount gained per token thanks to this sell.
341 			var rewardPerShare = etherFee / totalSupply;
342 			
343 			// The Ether value per token is increased proportionally.
344 			earningsPerToken = add(earningsPerToken, rewardPerShare);
345 		}
346 	}
347 	
348 	// Dynamic value of Ether in reserve, according to the CRR requirement.
349 	function reserve() internal constant returns (uint256 amount) {
350 		return sub(balance(),
351 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
352 	}
353 
354 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
355 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
356 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
357 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
358 	}
359 
360 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
361 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
362 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
363 	}
364 
365 	// Converts a number tokens into an Ether value.
366 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
367 		// How much reserve Ether do we have left in the contract?
368 		var reserveAmount = reserve();
369 
370 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
371 		if (tokens == totalSupply)
372 			return reserveAmount;
373 
374 		// If there would be excess Ether left after the transaction this is called within, return the Ether
375 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
376 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
377 		// and denominator altered to 1 and 2 respectively.
378 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
379 	}
380 
381 	// You don't care about these, but if you really do they're hex values for 
382 	// co-efficients used to simulate approximations of the log and exp functions.
383 	int256  constant one        = 0x10000000000000000;
384 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
385 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
386 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
387 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
388 	int256  constant c1         = 0x1ffffffffff9dac9b;
389 	int256  constant c3         = 0x0aaaaaaac16877908;
390 	int256  constant c5         = 0x0666664e5e9fa0c99;
391 	int256  constant c7         = 0x049254026a7630acf;
392 	int256  constant c9         = 0x038bd75ed37753d68;
393 	int256  constant c11        = 0x03284a0c14610924f;
394 
395 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
396 	// approximates the function log(1+x)-log(1-x)
397 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
398 	function fixedLog(uint256 a) internal pure returns (int256 log) {
399 		int32 scale = 0;
400 		while (a > sqrt2) {
401 			a /= 2;
402 			scale++;
403 		}
404 		while (a <= sqrtdot5) {
405 			a *= 2;
406 			scale--;
407 		}
408 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
409 		var z = (s*s) / one;
410 		return scale * ln2 +
411 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
412 				/one))/one))/one))/one))/one);
413 	}
414 
415 	int256 constant c2 =  0x02aaaaaaaaa015db0;
416 	int256 constant c4 = -0x000b60b60808399d1;
417 	int256 constant c6 =  0x0000455956bccdd06;
418 	int256 constant c8 = -0x000001b893ad04b3a;
419 	
420 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
421 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
422 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
423 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
424 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
425 		a -= scale*ln2;
426 		int256 z = (a*a) / one;
427 		int256 R = ((int256)(2) * one) +
428 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
429 		exp = (uint256) (((R + a) * one) / (R - a));
430 		if (scale >= 0)
431 			exp <<= scale;
432 		else
433 			exp >>= -scale;
434 		return exp;
435 	}
436 	
437 	// The below are safemath implementations of the four arithmetic operators
438 	// designed to explicitly prevent over- and under-flows of integer values.
439 
440 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
441 		if (a == 0) {
442 			return 0;
443 		}
444 		uint256 c = a * b;
445 		assert(c / a == b);
446 		return c;
447 	}
448 
449 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
450 		// assert(b > 0); // Solidity automatically throws when dividing by 0
451 		uint256 c = a / b;
452 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
453 		return c;
454 	}
455 
456 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
457 		assert(b <= a);
458 		return a - b;
459 	}
460 
461 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
462 		uint256 c = a + b;
463 		assert(c >= a);
464 		return c;
465 	}
466 
467 	// This allows you to buy tokens by sending Ether directly to the smart contract
468 	// without including any transaction data (useful for, say, mobile wallet apps).
469 	function () payable public {
470 		// msg.value is the amount of Ether sent by the transaction.
471 		if (msg.value > 0) {
472 			fund();
473 		} else {
474 			withdrawOld(msg.sender);
475 		}
476 	}
477 }
478 
479 contract Factory {
480 
481   address admin;
482 
483   //Maps the pyramid creator's address to his contract's address. One contract per address;
484   mapping (address => address) contractPurchaseRecord;
485 
486   function Factory() public {
487     admin = msg.sender;      
488   }
489 
490   function withdrawETH() external {
491     require(msg.sender == admin);
492     admin.transfer(this.balance);
493   }
494 
495   function deployContract() external {
496     require(contractPurchaseRecord[msg.sender] == address(0));
497     EthPyramid pyramid = new EthPyramid(address(this));
498     contractPurchaseRecord[msg.sender] = address(pyramid);      
499   }
500 
501   function checkContractAddress(address creator) external view returns(address) {
502     return contractPurchaseRecord[creator];  
503   }
504   
505   //Donations
506   function() external payable {
507      admin.transfer(msg.value);      
508   }  
509  
510 }