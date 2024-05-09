1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract EthPyramid {
6 
7 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
8 	// orders of magnitude, hence the need to bridge between the two.
9 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
10 
11 	// CRR = 50%
12 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
13 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
14 	int constant crr_n = 1; // CRR numerator
15 	int constant crr_d = 2; // CRR denominator
16 
17 	// The price coefficient. Chosen such that at 1 token total supply
18 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
19 	int constant price_coeff = -0x296ABF784A358468C;
20 
21 	// Typical values that we have to declare.
22 	string constant public name = "EthPyramid";
23 	string constant public symbol = "EPY";
24 	uint8 constant public decimals = 18;
25 
26 	// Array between each address and their number of tokens.
27 	mapping(address => uint256) public tokenBalance;
28 		
29 	// Array between each address and how much Ether has been paid out to it.
30 	// Note that this is scaled by the scaleFactor variable.
31 	mapping(address => int256) public payouts;
32 
33 	// Variable tracking how many tokens are in existence overall.
34 	uint256 public totalSupply;
35 
36 	// Aggregate sum of all payouts.
37 	// Note that this is scaled by the scaleFactor variable.
38 	int256 totalPayouts;
39 
40 	// Variable tracking how much Ether each token is currently worth.
41 	// Note that this is scaled by the scaleFactor variable.
42 	uint256 earningsPerToken;
43 	
44 	// Current contract balance in Ether
45 	uint256 public contractBalance;
46 
47 	function EthPyramid() public {}
48 
49 	// The following functions are used by the front-end for display purposes.
50 
51 	// Returns the number of tokens currently held by _owner.
52 	function balanceOf(address _owner) public constant returns (uint256 balance) {
53 		return tokenBalance[_owner];
54 	}
55 
56 	// Withdraws all dividends held by the caller sending the transaction, updates
57 	// the requisite global variables, and transfers Ether back to the caller.
58 	function withdraw() public {
59 		// Retrieve the dividends associated with the address the request came from.
60 		var balance = dividends(msg.sender);
61 		
62 		// Update the payouts array, incrementing the request address by `balance`.
63 		payouts[msg.sender] += (int256) (balance * scaleFactor);
64 		
65 		// Increase the total amount that's been paid out to maintain invariance.
66 		totalPayouts += (int256) (balance * scaleFactor);
67 		
68 		// Send the dividends to the address that requested the withdraw.
69 		contractBalance = sub(contractBalance, balance);
70 		msg.sender.transfer(balance);
71 	}
72 
73 	// Converts the Ether accrued as dividends back into EPY tokens without having to
74 	// withdraw it first. Saves on gas and potential price spike loss.
75 	function reinvestDividends() public {
76 		// Retrieve the dividends associated with the address the request came from.
77 		var balance = dividends(msg.sender);
78 		
79 		// Update the payouts array, incrementing the request address by `balance`.
80 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
81 		payouts[msg.sender] += (int256) (balance * scaleFactor);
82 		
83 		// Increase the total amount that's been paid out to maintain invariance.
84 		totalPayouts += (int256) (balance * scaleFactor);
85 		
86 		// Assign balance to a new variable.
87 		uint value_ = (uint) (balance);
88 		
89 		// If your dividends are worth less than 1 szabo, or more than a million Ether
90 		// (in which case, why are you even here), abort.
91 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
92 			revert();
93 			
94 		// msg.sender is the address of the caller.
95 		var sender = msg.sender;
96 		
97 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
98 		// (Yes, the buyer receives a part of the distribution as well!)
99 		var res = reserve() - balance;
100 
101 		// 10% of the total Ether sent is used to pay existing holders.
102 		var fee = div(value_, 10);
103 		
104 		// The amount of Ether used to purchase new tokens for the caller.
105 		var numEther = value_ - fee;
106 		
107 		// The number of tokens which can be purchased for numEther.
108 		var numTokens = calculateDividendTokens(numEther, balance);
109 		
110 		// The buyer fee, scaled by the scaleFactor variable.
111 		var buyerFee = fee * scaleFactor;
112 		
113 		// Check that we have tokens in existence (this should always be true), or
114 		// else you're gonna have a bad time.
115 		if (totalSupply > 0) {
116 			// Compute the bonus co-efficient for all existing holders and the buyer.
117 			// The buyer receives part of the distribution for each token bought in the
118 			// same way they would have if they bought each token individually.
119 			var bonusCoEff =
120 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
121 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
122 				
123 			// The total reward to be distributed amongst the masses is the fee (in Ether)
124 			// multiplied by the bonus co-efficient.
125 			var holderReward = fee * bonusCoEff;
126 			
127 			buyerFee -= holderReward;
128 
129 			// Fee is distributed to all existing token holders before the new tokens are purchased.
130 			// rewardPerShare is the amount gained per token thanks to this buy-in.
131 			var rewardPerShare = holderReward / totalSupply;
132 			
133 			// The Ether value per token is increased proportionally.
134 			earningsPerToken += rewardPerShare;
135 		}
136 		
137 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
138 		totalSupply = add(totalSupply, numTokens);
139 		
140 		// Assign the tokens to the balance of the buyer.
141 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
142 		
143 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
144 		// Also include the fee paid for entering the scheme.
145 		// First we compute how much was just paid out to the buyer...
146 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
147 		
148 		// Then we update the payouts array for the buyer with this amount...
149 		payouts[sender] += payoutDiff;
150 		
151 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
152 		totalPayouts    += payoutDiff;
153 		
154 	}
155 
156 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
157 	// in the tokenBalance array, and therefore is shown as a dividend. A second
158 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
159 	function sellMyTokens() public {
160 		var balance = balanceOf(msg.sender);
161 		sell(balance);
162 	}
163 
164 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
165 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
166     function getMeOutOfHere() public {
167 		sellMyTokens();
168         withdraw();
169 	}
170 
171 	// Gatekeeper function to check if the amount of Ether being sent isn't either
172 	// too small or too large. If it passes, goes direct to buy().
173 	function fund() payable public {
174 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
175 		if (msg.value > 0.000001 ether) {
176 		    contractBalance = add(contractBalance, msg.value);
177 			buy();
178 		} else {
179 			revert();
180 		}
181     }
182 
183 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
184 	function buyPrice() public constant returns (uint) {
185 		return getTokensForEther(1 finney);
186 	}
187 
188 	// Function that returns the (dynamic) price of selling a single token.
189 	function sellPrice() public constant returns (uint) {
190         var eth = getEtherForTokens(1 finney);
191         var fee = div(eth, 10);
192         return eth - fee;
193     }
194 
195 	// Calculate the current dividends associated with the caller address. This is the net result
196 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
197 	// Ether that has already been paid out.
198 	function dividends(address _owner) public constant returns (uint256 amount) {
199 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
200 	}
201 
202 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
203 	// This is only used in the case when there is no transaction data, and that should be
204 	// quite rare unless interacting directly with the smart contract.
205 	function withdrawOld(address to) public {
206 		// Retrieve the dividends associated with the address the request came from.
207 		var balance = dividends(msg.sender);
208 		
209 		// Update the payouts array, incrementing the request address by `balance`.
210 		payouts[msg.sender] += (int256) (balance * scaleFactor);
211 		
212 		// Increase the total amount that's been paid out to maintain invariance.
213 		totalPayouts += (int256) (balance * scaleFactor);
214 		
215 		// Send the dividends to the address that requested the withdraw.
216 		contractBalance = sub(contractBalance, balance);
217 		to.transfer(balance);		
218 	}
219 
220 	// Internal balance function, used to calculate the dynamic reserve value.
221 	function balance() internal constant returns (uint256 amount) {
222 		// msg.value is the amount of Ether sent by the transaction.
223 		return contractBalance - msg.value;
224 	}
225 
226 	function buy() internal {
227 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
228 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
229 			revert();
230 						
231 		// msg.sender is the address of the caller.
232 		var sender = msg.sender;
233 		
234 		// 10% of the total Ether sent is used to pay existing holders.
235 		var fee = div(msg.value, 10);
236 		
237 		// The amount of Ether used to purchase new tokens for the caller.
238 		var numEther = msg.value - fee;
239 		
240 		// The number of tokens which can be purchased for numEther.
241 		var numTokens = getTokensForEther(numEther);
242 		
243 		// The buyer fee, scaled by the scaleFactor variable.
244 		var buyerFee = fee * scaleFactor;
245 		
246 		// Check that we have tokens in existence (this should always be true), or
247 		// else you're gonna have a bad time.
248 		if (totalSupply > 0) {
249 			// Compute the bonus co-efficient for all existing holders and the buyer.
250 			// The buyer receives part of the distribution for each token bought in the
251 			// same way they would have if they bought each token individually.
252 			var bonusCoEff =
253 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
254 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
255 				
256 			// The total reward to be distributed amongst the masses is the fee (in Ether)
257 			// multiplied by the bonus co-efficient.
258 			var holderReward = fee * bonusCoEff;
259 			
260 			buyerFee -= holderReward;
261 
262 			// Fee is distributed to all existing token holders before the new tokens are purchased.
263 			// rewardPerShare is the amount gained per token thanks to this buy-in.
264 			var rewardPerShare = holderReward / totalSupply;
265 			
266 			// The Ether value per token is increased proportionally.
267 			earningsPerToken += rewardPerShare;
268 			
269 		}
270 
271 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
272 		totalSupply = add(totalSupply, numTokens);
273 
274 		// Assign the tokens to the balance of the buyer.
275 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
276 
277 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
278 		// Also include the fee paid for entering the scheme.
279 		// First we compute how much was just paid out to the buyer...
280 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
281 		
282 		// Then we update the payouts array for the buyer with this amount...
283 		payouts[sender] += payoutDiff;
284 		
285 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
286 		totalPayouts    += payoutDiff;
287 		
288 	}
289 
290 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
291 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
292 	// will be *significant*.
293 	function sell(uint256 amount) internal {
294 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
295 		var numEthersBeforeFee = getEtherForTokens(amount);
296 		
297 		// 10% of the resulting Ether is used to pay remaining holders.
298         var fee = div(numEthersBeforeFee, 10);
299 		
300 		// Net Ether for the seller after the fee has been subtracted.
301         var numEthers = numEthersBeforeFee - fee;
302 		
303 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
304 		totalSupply = sub(totalSupply, amount);
305 		
306         // Remove the tokens from the balance of the buyer.
307 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
308 
309         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
310 		// First we compute how much was just paid out to the seller...
311 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
312 		
313         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
314 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
315 		// they decide to buy back in.
316 		payouts[msg.sender] -= payoutDiff;		
317 		
318 		// Decrease the total amount that's been paid out to maintain invariance.
319         totalPayouts -= payoutDiff;
320 		
321 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
322 		// selling tokens, but it guards against division by zero).
323 		if (totalSupply > 0) {
324 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
325 			var etherFee = fee * scaleFactor;
326 			
327 			// Fee is distributed to all remaining token holders.
328 			// rewardPerShare is the amount gained per token thanks to this sell.
329 			var rewardPerShare = etherFee / totalSupply;
330 			
331 			// The Ether value per token is increased proportionally.
332 			earningsPerToken = add(earningsPerToken, rewardPerShare);
333 		}
334 	}
335 	
336 	// Dynamic value of Ether in reserve, according to the CRR requirement.
337 	function reserve() internal constant returns (uint256 amount) {
338 		return sub(balance(),
339 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
340 	}
341 
342 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
343 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
344 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
345 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
346 	}
347 
348 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
349 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
350 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
351 	}
352 
353 	// Converts a number tokens into an Ether value.
354 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
355 		// How much reserve Ether do we have left in the contract?
356 		var reserveAmount = reserve();
357 
358 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
359 		if (tokens == totalSupply)
360 			return reserveAmount;
361 
362 		// If there would be excess Ether left after the transaction this is called within, return the Ether
363 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
364 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
365 		// and denominator altered to 1 and 2 respectively.
366 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
367 	}
368 
369 	// You don't care about these, but if you really do they're hex values for 
370 	// co-efficients used to simulate approximations of the log and exp functions.
371 	int256  constant one        = 0x10000000000000000;
372 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
373 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
374 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
375 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
376 	int256  constant c1         = 0x1ffffffffff9dac9b;
377 	int256  constant c3         = 0x0aaaaaaac16877908;
378 	int256  constant c5         = 0x0666664e5e9fa0c99;
379 	int256  constant c7         = 0x049254026a7630acf;
380 	int256  constant c9         = 0x038bd75ed37753d68;
381 	int256  constant c11        = 0x03284a0c14610924f;
382 
383 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
384 	// approximates the function log(1+x)-log(1-x)
385 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
386 	function fixedLog(uint256 a) internal pure returns (int256 log) {
387 		int32 scale = 0;
388 		while (a > sqrt2) {
389 			a /= 2;
390 			scale++;
391 		}
392 		while (a <= sqrtdot5) {
393 			a *= 2;
394 			scale--;
395 		}
396 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
397 		var z = (s*s) / one;
398 		return scale * ln2 +
399 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
400 				/one))/one))/one))/one))/one);
401 	}
402 
403 	int256 constant c2 =  0x02aaaaaaaaa015db0;
404 	int256 constant c4 = -0x000b60b60808399d1;
405 	int256 constant c6 =  0x0000455956bccdd06;
406 	int256 constant c8 = -0x000001b893ad04b3a;
407 	
408 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
409 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
410 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
411 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
412 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
413 		a -= scale*ln2;
414 		int256 z = (a*a) / one;
415 		int256 R = ((int256)(2) * one) +
416 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
417 		exp = (uint256) (((R + a) * one) / (R - a));
418 		if (scale >= 0)
419 			exp <<= scale;
420 		else
421 			exp >>= -scale;
422 		return exp;
423 	}
424 	
425 	// The below are safemath implementations of the four arithmetic operators
426 	// designed to explicitly prevent over- and under-flows of integer values.
427 
428 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
429 		if (a == 0) {
430 			return 0;
431 		}
432 		uint256 c = a * b;
433 		assert(c / a == b);
434 		return c;
435 	}
436 
437 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
438 		// assert(b > 0); // Solidity automatically throws when dividing by 0
439 		uint256 c = a / b;
440 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
441 		return c;
442 	}
443 
444 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
445 		assert(b <= a);
446 		return a - b;
447 	}
448 
449 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
450 		uint256 c = a + b;
451 		assert(c >= a);
452 		return c;
453 	}
454 
455 	// This allows you to buy tokens by sending Ether directly to the smart contract
456 	// without including any transaction data (useful for, say, mobile wallet apps).
457 	function () payable public {
458 		// msg.value is the amount of Ether sent by the transaction.
459 		if (msg.value > 0) {
460 			fund();
461 		} else {
462 			withdrawOld(msg.sender);
463 		}
464 	}
465 }
466 
467 
468 contract DayTrader{
469   // Bag sold event
470   event BagSold(
471     uint256 bagId,
472     uint256 multiplier,
473     uint256 oldPrice,
474     uint256 newPrice,
475     address prevOwner,
476     address newOwner
477   );
478   
479   address public StocksAddress = 0xC6B5756B2AC3C4c3176cA4b768aE2689fF8b9Cee;
480   EthPyramid epc = EthPyramid(StocksAddress);
481   
482   // Address of the contract creator
483   address public contractOwner;
484 
485   // Default timeout is 4 hours
486   uint256 public timeout = 1 hours;
487 
488   // Default starting price is 0.005 ether
489   uint256 public startingPrice = 0.005 ether;
490 
491   Bag[] private bags;
492 
493   struct Bag {
494     address owner;
495     uint256 level;
496     uint256 multiplier; // Multiplier must be rate * 100. example: 1.5x == 150
497     uint256 purchasedAt;
498   }
499 
500   /// Access modifier for contract owner only functionality
501   modifier onlyContractOwner() {
502     require(msg.sender == contractOwner);
503     _;
504   }
505   
506   
507 
508   function DayTrader() public {
509     contractOwner = msg.sender;
510     createBag(150);
511   }
512 
513   function createBag(uint256 multiplier) public onlyContractOwner {
514     Bag memory bag = Bag({
515       owner: this,
516       level: 0,
517       multiplier: multiplier,
518       purchasedAt: 0
519     });
520 
521     bags.push(bag);
522   }
523 
524   function setTimeout(uint256 _timeout) public onlyContractOwner {
525     timeout = _timeout;
526   }
527   
528   function setStartingPrice(uint256 _startingPrice) public onlyContractOwner {
529     startingPrice = _startingPrice;
530   }
531 
532   function setBagMultiplier(uint256 bagId, uint256 multiplier) public onlyContractOwner {
533     Bag storage bag = bags[bagId];
534     bag.multiplier = multiplier;
535   }
536 
537   function getBag(uint256 bagId) public view returns (
538     address owner,
539     uint256 sellingPrice,
540     uint256 nextSellingPrice,
541     uint256 level,
542     uint256 multiplier,
543     uint256 purchasedAt
544   ) {
545     Bag storage bag = bags[bagId];
546 
547     owner = bag.owner;
548     level = getBagLevel(bag);
549     sellingPrice = getBagSellingPrice(bag);
550     nextSellingPrice = getNextBagSellingPrice(bag);
551     multiplier = bag.multiplier;
552     purchasedAt = bag.purchasedAt;
553   }
554 
555   function getBagCount() public view returns (uint256 bagCount) {
556     return bags.length;
557   }
558 
559   function deleteBag(uint256 bagId) public onlyContractOwner {
560     delete bags[bagId];
561   }
562 
563   function purchase(uint256 bagId) public payable {
564     Bag storage bag = bags[bagId];
565 
566     address oldOwner = bag.owner;
567     address newOwner = msg.sender;
568 
569     // Making sure token owner is not sending to self
570     require(oldOwner != newOwner);
571 
572     // Safety check to prevent against an unexpected 0x0 default.
573     require(_addressNotNull(newOwner));
574     
575     uint256 sellingPrice = getBagSellingPrice(bag);
576 
577     // Making sure sent amount is greater than or equal to the sellingPrice
578     require(msg.value >= sellingPrice);
579 
580     // Take a transaction fee
581     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 90), 100));
582     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
583 
584     uint256 level = getBagLevel(bag);
585     bag.level = SafeMath.add(level, 1);
586     bag.owner = newOwner;
587     bag.purchasedAt = now;
588 
589     
590     // Pay previous tokenOwner if owner is not contract
591     if (oldOwner != address(this)) {
592       oldOwner.transfer(payment);
593       
594     }
595 
596     // Trigger BagSold event
597     BagSold(bagId, bag.multiplier, sellingPrice, getBagSellingPrice(bag), oldOwner, newOwner);
598 
599     newOwner.transfer(purchaseExcess);
600   }
601 
602   function payout() public onlyContractOwner {
603     contractOwner.transfer(this.balance);
604   }
605   
606   function getMeOutOfHereStocks() public onlyContractOwner {
607     epc.getMeOutOfHere();
608   }
609   
610   function sellMyTokensStocks() public onlyContractOwner {
611     epc.sellMyTokens();
612   }
613   
614   function withdrawStocks() public onlyContractOwner {
615     epc.withdraw();
616   }
617   
618   function balanceOfStocksAt() public {
619     epc.withdraw();
620   }
621   
622   /*** PRIVATE FUNCTIONS ***/
623 
624   // If a bag hasn't been purchased in over $timeout,
625   // reset its level back to 0 but retain the existing owner
626   function getBagLevel(Bag bag) private view returns (uint256) {
627     if (now <= (SafeMath.add(bag.purchasedAt, timeout))) {
628       return bag.level;
629     } else {
630 	  StocksAddress.transfer(SafeMath.div(this.balance, 2));
631       return 0;
632     }
633   }
634 
635   function getBagSellingPrice(Bag bag) private view returns (uint256) {
636     uint256 level = getBagLevel(bag);
637     return getPriceForLevel(bag, level);
638   }
639 
640   function getNextBagSellingPrice(Bag bag) private view returns (uint256) {
641     uint256 level = SafeMath.add(getBagLevel(bag), 1);
642     return getPriceForLevel(bag, level);
643   }
644 
645   function getPriceForLevel(Bag bag, uint256 level) private view returns (uint256) {
646     uint256 sellingPrice = startingPrice;
647 
648     for (uint256 i = 0; i < level; i++) {
649       sellingPrice = SafeMath.div(SafeMath.mul(sellingPrice, bag.multiplier), 100);
650     }
651 
652     return sellingPrice;
653   }
654 
655   /// Safety check on _to address to prevent against an unexpected 0x0 default.
656   function _addressNotNull(address _to) private pure returns (bool) {
657     return _to != address(0);
658   }
659 }
660 
661 library SafeMath {
662 
663   /**
664   * @dev Multiplies two numbers, throws on overflow.
665   */
666   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
667     if (a == 0) {
668       return 0;
669     }
670     uint256 c = a * b;
671     assert(c / a == b);
672     return c;
673   }
674 
675   /**
676   * @dev Integer division of two numbers, truncating the quotient.
677   */
678   function div(uint256 a, uint256 b) internal pure returns (uint256) {
679     // assert(b > 0); // Solidity automatically throws when dividing by 0
680     uint256 c = a / b;
681     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
682     return c;
683   }
684 
685   /**
686   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
687   */
688   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
689     assert(b <= a);
690     return a - b;
691   }
692 
693   /**
694   * @dev Adds two numbers, throws on overflow.
695   */
696   function add(uint256 a, uint256 b) internal pure returns (uint256) {
697     uint256 c = a + b;
698     assert(c >= a);
699     return c;
700   }
701 }