1 pragma solidity ^0.4.21;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
7     function transfer(address to, uint256 tokens) public returns (bool success);
8     function approve(address spender, uint256 tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract EthPyBase {
16     
17     function buy(address) public payable returns(uint256){}
18     function withdraw() public {}
19     function myTokens() public view returns(uint256){}
20 }
21 
22 
23 contract Owned {
24     address public owner;
25     address public ownerCandidate;
26 
27     function Owned() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35     
36     function changeOwner(address _newOwner) public onlyOwner {
37         ownerCandidate = _newOwner;
38     }
39     
40     function acceptOwnership() public {
41         require(msg.sender == ownerCandidate);  
42         owner = ownerCandidate;
43     }
44     
45 }
46 
47 
48 
49 contract EPTest is Owned {
50     
51     
52     address public twin_contract;
53     EthPyBase twin;
54     
55     function addTwinAddress(address twinAddress) public onlyOwner {
56         require(twinAddress != address(this));
57         twin_contract = twinAddress;
58         twin = EthPyBase(twin_contract);
59     }
60 
61 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
62 	// orders of magnitude, hence the need to bridge between the two.
63 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
64 
65 	// CRR = 50%
66 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
67 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
68 	int constant crr_n = 1; // CRR numerator
69 	int constant crr_d = 2; // CRR denominator
70 
71 	// The price coefficient. Chosen such that at 1 token total supply
72 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
73 	int constant price_coeff = -0x296ABF784A358468C;
74 
75 	// Typical values that we have to declare.
76 	string constant public name = "EPTest";
77 	string constant public symbol = "EPY";
78 	uint8 constant public decimals = 18;
79 
80 	// Array between each address and their number of tokens.
81 	mapping(address => uint256) public tokenBalance;
82 		
83 	// Array between each address and how much Ether has been paid out to it.
84 	// Note that this is scaled by the scaleFactor variable.
85 	mapping(address => int256) public payouts;
86 
87 	// Variable tracking how many tokens are in existence overall.
88 	uint256 public totalSupply;
89 
90 	// Aggregate sum of all payouts.
91 	// Note that this is scaled by the scaleFactor variable.
92 	int256 totalPayouts;
93 
94 	// Variable tracking how much Ether each token is currently worth.
95 	// Note that this is scaled by the scaleFactor variable.
96 	uint256 earningsPerToken;
97 	
98 	// Current contract balance in Ether
99 	uint256 public contractBalance;
100 
101 	function EPTest() public {}
102 
103 	// The following functions are used by the front-end for display purposes.
104 
105 	// Returns the number of tokens currently held by _owner.
106 	function balanceOf(address _owner) public constant returns (uint256 balance) {
107 		return tokenBalance[_owner];
108 	}
109 
110 	// Withdraws all dividends held by the caller sending the transaction, updates
111 	// the requisite global variables, and transfers Ether back to the caller.
112 	function withdraw() public {
113 		// Retrieve the dividends associated with the address the request came from.
114 		var balance = dividends(msg.sender);
115 		
116 		// Update the payouts array, incrementing the request address by `balance`.
117 		payouts[msg.sender] += (int256) (balance * scaleFactor);
118 		
119 		// Increase the total amount that's been paid out to maintain invariance.
120 		totalPayouts += (int256) (balance * scaleFactor);
121 		
122 		// Send the dividends to the address that requested the withdraw.
123 		contractBalance = sub(contractBalance, balance);
124 		msg.sender.transfer(balance);
125 	}
126 
127 	// Converts the Ether accrued as dividends back into EPY tokens without having to
128 	// withdraw it first. Saves on gas and potential price spike loss.
129 	function reinvestDividends() public {
130 		// Retrieve the dividends associated with the address the request came from.
131 		var balance = dividends(msg.sender);
132 		
133 		// Update the payouts array, incrementing the request address by `balance`.
134 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
135 		payouts[msg.sender] += (int256) (balance * scaleFactor);
136 		
137 		// Increase the total amount that's been paid out to maintain invariance.
138 		totalPayouts += (int256) (balance * scaleFactor);
139 		
140 		// Assign balance to a new variable.
141 		uint value_ = (uint) (balance);
142 		
143 		// If your dividends are worth less than 1 szabo, or more than a million Ether
144 		// (in which case, why are you even here), abort.
145 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
146 			revert();
147 			
148 		// msg.sender is the address of the caller.
149 		var sender = msg.sender;
150 		
151 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
152 		// (Yes, the buyer receives a part of the distribution as well!)
153 		var res = reserve() - balance;
154 
155 		// 10% of the total Ether sent is used to pay existing holders.
156 		var fee = div(value_, 10);
157 		
158 		// The amount of Ether used to purchase new tokens for the caller.
159 		var numEther = value_ - fee;
160 		
161 		// The number of tokens which can be purchased for numEther.
162 		var numTokens = calculateDividendTokens(numEther, balance);
163 		
164 		// The buyer fee, scaled by the scaleFactor variable.
165 		var buyerFee = fee * scaleFactor;
166 		
167 		// Check that we have tokens in existence (this should always be true), or
168 		// else you're gonna have a bad time.
169 		if (totalSupply > 0) {
170 			// Compute the bonus co-efficient for all existing holders and the buyer.
171 			// The buyer receives part of the distribution for each token bought in the
172 			// same way they would have if they bought each token individually.
173 			var bonusCoEff =
174 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
175 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
176 				
177 			// The total reward to be distributed amongst the masses is the fee (in Ether)
178 			// multiplied by the bonus co-efficient.
179 			var holderReward = fee * bonusCoEff;
180 			
181 			buyerFee -= holderReward;
182 
183 			// Fee is distributed to all existing token holders before the new tokens are purchased.
184 			// rewardPerShare is the amount gained per token thanks to this buy-in.
185 			var rewardPerShare = holderReward / totalSupply;
186 			
187 			// The Ether value per token is increased proportionally.
188 			earningsPerToken += rewardPerShare;
189 		}
190 		
191 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
192 		totalSupply = add(totalSupply, numTokens);
193 		
194 		// Assign the tokens to the balance of the buyer.
195 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
196 		
197 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
198 		// Also include the fee paid for entering the scheme.
199 		// First we compute how much was just paid out to the buyer...
200 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
201 		
202 		// Then we update the payouts array for the buyer with this amount...
203 		payouts[sender] += payoutDiff;
204 		
205 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
206 		totalPayouts    += payoutDiff;
207 		
208 	}
209 
210 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
211 	// in the tokenBalance array, and therefore is shown as a dividend. A second
212 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
213 	function sellMyTokens() public {
214 		var balance = balanceOf(msg.sender);
215 		sell(balance);
216 	}
217 
218 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
219 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
220     function getMeOutOfHere() public {
221 		sellMyTokens();
222         withdraw();
223 	}
224 
225 	// Gatekeeper function to check if the amount of Ether being sent isn't either
226 	// too small or too large. If it passes, goes direct to buy().
227 	function fund() payable public {
228 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
229 		if (msg.value > 0.000001 ether) {
230 			buy();
231 		} else {
232 			revert();
233 		}
234     }
235 
236 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
237 	function buyPrice() public constant returns (uint) {
238 		return getTokensForEther(1 finney);
239 	}
240 
241 	// Function that returns the (dynamic) price of selling a single token.
242 	function sellPrice() public constant returns (uint) {
243         var eth = getEtherForTokens(1 finney);
244         var fee = div(eth, 10);
245         return eth - fee;
246     }
247 
248 	// Calculate the current dividends associated with the caller address. This is the net result
249 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
250 	// Ether that has already been paid out.
251 	function dividends(address _owner) public constant returns (uint256 amount) {
252 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
253 	}
254 
255 	// Version of withdraw that extracts the dividends and sends the Ether to the caller.
256 	// This is only used in the case when there is no transaction data, and that should be
257 	// quite rare unless interacting directly with the smart contract.
258 	function withdrawOld(address to) public {
259 		// Retrieve the dividends associated with the address the request came from.
260 		var balance = dividends(msg.sender);
261 		
262 		// Update the payouts array, incrementing the request address by `balance`.
263 		payouts[msg.sender] += (int256) (balance * scaleFactor);
264 		
265 		// Increase the total amount that's been paid out to maintain invariance.
266 		totalPayouts += (int256) (balance * scaleFactor);
267 		
268 		// Send the dividends to the address that requested the withdraw.
269 		contractBalance = sub(contractBalance, balance);
270 		to.transfer(balance);		
271 	}
272 
273 	// Internal balance function, used to calculate the dynamic reserve value.
274 	function balance() internal constant returns (uint256 amount) {
275 		// msg.value is the amount of Ether sent by the transaction.
276 		return contractBalance - msg.value;
277 	}
278 
279 	function buy() internal {
280 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
281 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
282 			revert();
283 						
284 		// msg.sender is the address of the caller.
285 		var sender = msg.sender;
286 
287 		// 5% of the total Ether sent is used to pay existing holders.
288 		uint fee = div(msg.value, 20);
289 		
290 		// 5% is sent to twin contract
291 		uint fee2 = div(msg.value, 20);
292 		
293 		//contractBalance -= (msg.value - fee2);
294 		
295 		// The amount of Ether used to purchase new tokens for the caller.
296 		var numEther = msg.value - fee - fee2;
297 		
298 		// The number of tokens which can be purchased for numEther.
299 		var numTokens = getTokensForEther(numEther);
300 		
301 		// The buyer fee, scaled by the scaleFactor variable.
302 		var buyerFee = fee * scaleFactor;
303 		
304 		// Check that we have tokens in existence (this should always be true), or
305 		// else you're gonna have a bad time.
306 		if (totalSupply > 0) {
307 			// Compute the bonus co-efficient for all existing holders and the buyer.
308 			// The buyer receives part of the distribution for each token bought in the
309 			// same way they would have if they bought each token individually.
310 			var bonusCoEff =
311 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
312 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
313 				
314 			// The total reward to be distributed amongst the masses is the fee (in Ether)
315 			// multiplied by the bonus co-efficient.
316 			var holderReward = fee * bonusCoEff;
317 			
318 			buyerFee -= holderReward;
319 
320 			// Fee is distributed to all existing token holders before the new tokens are purchased.
321 			// rewardPerShare is the amount gained per token thanks to this buy-in.
322 			var rewardPerShare = holderReward / totalSupply;
323 			
324 			// The Ether value per token is increased proportionally.
325 			earningsPerToken += rewardPerShare;
326 			
327 		}
328 
329 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
330 		totalSupply = add(totalSupply, numTokens);
331 
332 		// Assign the tokens to the balance of the buyer.
333 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
334 
335 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
336 		// Also include the fee paid for entering the scheme.
337 		// First we compute how much was just paid out to the buyer...
338 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
339 		
340 		// Then we update the payouts array for the buyer with this amount...
341 		payouts[sender] += payoutDiff;
342 		
343 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
344 		totalPayouts    += payoutDiff;
345 		
346 		if( fee2 != 0 ){
347 		    twin.buy.value(fee2).gas(1000000)(msg.sender);
348 		}
349 		
350 	}
351 
352 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
353 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
354 	// will be *significant*.
355 	function sell(uint256 amount) internal {
356 	    
357 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
358 		var numEthersBeforeFee = getEtherForTokens(amount);
359 	
360         // 5% of the total Ether sent is used to pay existing holders.
361 		uint fee = div(numEthersBeforeFee, 20);
362 		
363 		// 5% is sent to twin contract
364 		uint fee2 = div(numEthersBeforeFee, 20);
365 		
366 		// Net Ether for the seller after the fee has been subtracted.
367         var numEthers = numEthersBeforeFee - fee - fee2;
368 		
369 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
370 		totalSupply = sub(totalSupply, amount);
371 		
372         // Remove the tokens from the balance of the buyer.
373 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
374 
375         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
376 		// First we compute how much was just paid out to the seller...
377 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
378 		
379         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
380 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
381 		// they decide to buy back in.
382 		payouts[msg.sender] -= payoutDiff;		
383 		
384 		// Decrease the total amount that's been paid out to maintain invariance.
385         totalPayouts -= payoutDiff;
386 		
387 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
388 		// selling tokens, but it guards against division by zero).
389 		if (totalSupply > 0) {
390 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
391 			var etherFee = fee * scaleFactor;
392 			
393 			// Fee is distributed to all remaining token holders.
394 			// rewardPerShare is the amount gained per token thanks to this sell.
395 			var rewardPerShare = etherFee / totalSupply;
396 			
397 			// The Ether value per token is increased proportionally.
398 			earningsPerToken = add(earningsPerToken, rewardPerShare);
399 		}
400 		
401 	    if( fee2 != 0 ){
402 		    twin.buy.value(fee2).gas(1000000)(msg.sender);
403 		}
404 		
405 		
406 	}
407 	
408 	// Dynamic value of Ether in reserve, according to the CRR requirement.
409 	function reserve() internal constant returns (uint256 amount) {
410 		return sub(balance(),
411 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
412 	}
413 
414 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
415 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
416 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
417 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
418 	}
419 
420 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
421 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
422 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
423 	}
424 
425 	// Converts a number tokens into an Ether value.
426 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
427 		// How much reserve Ether do we have left in the contract?
428 		var reserveAmount = reserve();
429 
430 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
431 		if (tokens == totalSupply)
432 			return reserveAmount;
433 
434 		// If there would be excess Ether left after the transaction this is called within, return the Ether
435 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
436 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
437 		// and denominator altered to 1 and 2 respectively.
438 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
439 	}
440 
441 	// You don't care about these, but if you really do they're hex values for 
442 	// co-efficients used to simulate approximations of the log and exp functions.
443 	int256  constant one        = 0x10000000000000000;
444 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
445 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
446 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
447 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
448 	int256  constant c1         = 0x1ffffffffff9dac9b;
449 	int256  constant c3         = 0x0aaaaaaac16877908;
450 	int256  constant c5         = 0x0666664e5e9fa0c99;
451 	int256  constant c7         = 0x049254026a7630acf;
452 	int256  constant c9         = 0x038bd75ed37753d68;
453 	int256  constant c11        = 0x03284a0c14610924f;
454 
455 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
456 	// approximates the function log(1+x)-log(1-x)
457 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
458 	function fixedLog(uint256 a) internal pure returns (int256 log) {
459 		int32 scale = 0;
460 		while (a > sqrt2) {
461 			a /= 2;
462 			scale++;
463 		}
464 		while (a <= sqrtdot5) {
465 			a *= 2;
466 			scale--;
467 		}
468 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
469 		var z = (s*s) / one;
470 		return scale * ln2 +
471 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
472 				/one))/one))/one))/one))/one);
473 	}
474 
475 	int256 constant c2 =  0x02aaaaaaaaa015db0;
476 	int256 constant c4 = -0x000b60b60808399d1;
477 	int256 constant c6 =  0x0000455956bccdd06;
478 	int256 constant c8 = -0x000001b893ad04b3a;
479 	
480 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
481 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
482 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
483 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
484 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
485 		a -= scale*ln2;
486 		int256 z = (a*a) / one;
487 		int256 R = ((int256)(2) * one) +
488 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
489 		exp = (uint256) (((R + a) * one) / (R - a));
490 		if (scale >= 0)
491 			exp <<= scale;
492 		else
493 			exp >>= -scale;
494 		return exp;
495 	}
496 	
497 	// The below are safemath implementations of the four arithmetic operators
498 	// designed to explicitly prevent over- and under-flows of integer values.
499 
500 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
501 		if (a == 0) {
502 			return 0;
503 		}
504 		uint256 c = a * b;
505 		assert(c / a == b);
506 		return c;
507 	}
508 
509 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
510 		// assert(b > 0); // Solidity automatically throws when dividing by 0
511 		uint256 c = a / b;
512 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
513 		return c;
514 	}
515 
516 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
517 		assert(b <= a);
518 		return a - b;
519 	}
520 
521 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
522 		uint256 c = a + b;
523 		assert(c >= a);
524 		return c;
525 	}
526 
527 	// This allows you to buy tokens by sending Ether directly to the smart contract
528 	// without including any transaction data (useful for, say, mobile wallet apps).
529 	function () payable public {
530 		// msg.value is the amount of Ether sent by the transaction.
531 		if (msg.value > 0) {
532 			fund();
533 		} else {
534 			withdrawOld(msg.sender);
535 		}
536 	}
537 }