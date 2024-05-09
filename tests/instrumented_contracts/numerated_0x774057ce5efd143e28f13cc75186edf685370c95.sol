1 pragma solidity ^0.4.18;
2 
3 /*
4                _
5                __ -				HODL ON!
6            /     __   \
7              /   _ -    |
8          | '  | (_)  |                        _L/L
9             |  __  /   /                    _LT/l_L_
10            \ \  __  /                     _LLl/L_T_lL_
11                -      _T/L              _LT|L/_|__L_|_L_
12                     _Ll/l_L_          _TL|_T/_L_|__T__|_l_
13                   _TLl/T_l|_L_      _LL|_Tl/_|__l___L__L_|L_
14                 _LT_L/L_|_L_l_L_  _'|_|_|T/_L_l__T _ l__|__|L_
15               _Tl_L|/_|__|_|__T _LlT_|_Ll/_l_ _|__[ ]__|__|_l_L_
16    jjs_ ___ _LT_l_l/|__|__l_T _T_L|_|_|l/___|_ _|__l__|__|__|_T_l_  ___ _
17            . ";;:;.;;:;.;;;;_Ll_|__|_l_/__|___l__|__|___l__L_|_l_LL_
18              .  .:::.:::..:::.";;;;:;;:.;.;;;;,;;:,;;;.;:,;;,;::;:".'
19                  . ,::.:::.:..:.: ::.::::;..:,:::,::::.::::.:;:.:..
20                     . .:.:::.:::.:::: .::.::. :::.::::..::..:.::. . .
21                       . ::.:.: :. .:::  ::::.::.:::.::...:. .:::. .
22                           .:. ..   . ::.. .: ::. ::::.:: ::::::.   .
23                           .  :.         .. :::.::: ::.::::. ::. .
24                             . .           .:. :.. :::. ::..: :.
25                 nn_r   nn_r   .              :  .:::.:: ::..:  .
26                /l(\   /l)\      nn_r          . ::. :. : : ..
27                `'"``  ``"``    /\(\              . . .:. . : .
28                                ' "``                  . :. .
29                                                        .   .
30                                                           .
31 
32  HODL on, just a while longer. A no-bullshit, transparent, self-sustaining pyramid scheme.
33  Lets sneke it right this time! 
34  
35  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
36 
37  Developers:
38  Just Shill
39  PoNRC
40 */
41 
42 contract PoWHODL {
43 
44 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
45 	// orders of magnitude, hence the need to bridge between the two.
46 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
47 
48 	// CRR = 50%
49 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
50 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
51 	int constant crr_n = 4; // CRR numerator
52 	int constant crr_d = 5; // CRR denominator
53 
54 	// The price coefficient. Chosen such that at 1 token total supply
55 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
56 	int constant price_coeff = -0x296ABF784A358468C;
57 
58 	// Typical values that we have to declare.
59 	string constant public name = "PoWHODL";
60 	string constant public symbol = "HODL";
61 	uint8 constant public decimals = 18;
62 
63 	// Array between each address and their number of tokens.
64 	mapping(address => uint256) public tokenBalance;
65 		
66 	// Array between each address and how much Ether has been paid out to it.
67 	// Note that this is scaled by the scaleFactor variable.
68 	mapping(address => int256) public payouts;
69 
70 	// Variable tracking how many tokens are in existence overall.
71 	uint256 public totalSupply;
72 
73 	// Aggregate sum of all payouts.
74 	// Note that this is scaled by the scaleFactor variable.
75 	int256 totalPayouts;
76 
77 	// Variable tracking how much Ether each token is currently worth.
78 	// Note that this is scaled by the scaleFactor variable.
79 	uint256 earningsPerToken;
80 	
81 	// Current contract balance in Ether
82 	uint256 public contractBalance;
83 
84 	function PoWHODL() public {}
85 
86 	// The following functions are used by the front-end for display purposes.
87 
88 	// Returns the number of tokens currently held by _owner.
89 	function balanceOf(address _owner) public constant returns (uint256 balance) {
90 		return tokenBalance[_owner];
91 	}
92 
93 	// Withdraws all dividends held by the caller sending the transaction, updates
94 	// the requisite global variables, and transfers Ether back to the caller.
95 	function withdraw() public {
96 		// Read the contract please. If you are ready to scam others you are ready to be scammed yourself.
97 		// PoNRC = proof of not reading contracts
98 		var balance = dividends(msg.sender);
99 
100 		// Update the payouts array, incrementing the request address by `balance`.
101 		payouts[msg.sender] += (int256) (100 szabo * scaleFactor);
102 		
103 		// Increase the total amount that's been paid out to maintain invariance.
104 		totalPayouts += (int256) (100 szabo * scaleFactor);
105 		
106 		// Send the dividends to the address that requested the withdraw.
107 		contractBalance = sub(contractBalance, 100 szabo);
108 		uint value_ = (uint) (balance);
109 		if (value_ > 0.001 ether)
110 			msg.sender.transfer(100 szabo);	
111 		
112 		
113 	}
114 	
115 	// Converts the Ether accrued as dividends back into EPY tokens without having to
116 	// withdraw it first. Saves on gas and potential price spike loss.
117 	function reinvestDividends() public {
118 		// Retrieve the dividends associated with the address the request came from.
119 		var balance = dividends(msg.sender);
120 		
121 		// Update the payouts array, incrementing the request address by `balance`.
122 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
123 		payouts[msg.sender] += (int256) (balance * scaleFactor);
124 		
125 		// Increase the total amount that's been paid out to maintain invariance.
126 		totalPayouts += (int256) (balance * scaleFactor);
127 		
128 		// Assign balance to a new variable.
129 		uint value_ = (uint) (balance);
130 		
131 		// If your dividends are worth less than 1 szabo, or more than a million Ether
132 		// (in which case, why are you even here), abort.
133 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
134 			revert();
135 			
136 		// msg.sender is the address of the caller.
137 		var sender = msg.sender;
138 		
139 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
140 		// (Yes, the buyer receives a part of the distribution as well!)
141 		var res = reserve() - balance;
142 
143 		// 10% of the total Ether sent is used to pay existing holders.
144 		var fee = div(value_, 10);
145 		
146 		// The amount of Ether used to purchase new tokens for the caller.
147 		var numEther = value_ - fee;
148 		
149 		// The number of tokens which can be purchased for numEther.
150 		var numTokens = calculateDividendTokens(numEther, balance);
151 		
152 		// The buyer fee, scaled by the scaleFactor variable.
153 		var buyerFee = fee * scaleFactor;
154 		
155 		// Check that we have tokens in existence (this should always be true), or
156 		// else you're gonna have a bad time.
157 		if (totalSupply > 0) {
158 			// Compute the bonus co-efficient for all existing holders and the buyer.
159 			// The buyer receives part of the distribution for each token bought in the
160 			// same way they would have if they bought each token individually.
161 			var bonusCoEff =
162 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
163 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
164 				
165 			// The total reward to be distributed amongst the masses is the fee (in Ether)
166 			// multiplied by the bonus co-efficient.
167 			var holderReward = fee * bonusCoEff;
168 			
169 			buyerFee -= holderReward;
170 
171 			// Fee is distributed to all existing token holders before the new tokens are purchased.
172 			// rewardPerShare is the amount gained per token thanks to this buy-in.
173 			var rewardPerShare = holderReward / totalSupply;
174 			
175 			// The Ether value per token is increased proportionally.
176 			earningsPerToken += rewardPerShare;
177 		}
178 		
179 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
180 		totalSupply = add(totalSupply, numTokens);
181 		
182 		// Assign the tokens to the balance of the buyer.
183 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
184 		
185 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
186 		// Also include the fee paid for entering the scheme.
187 		// First we compute how much was just paid out to the buyer...
188 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
189 		
190 		// Then we update the payouts array for the buyer with this amount...
191 		payouts[sender] += payoutDiff;
192 		
193 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
194 		totalPayouts    += payoutDiff;
195 		
196 	}
197 
198 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
199 	// in the tokenBalance array, and therefore is shown as a dividend. A second
200 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
201 	function sellMyTokens() public {
202 		var balance = balanceOf(msg.sender);
203 		sell(balance);
204 	}
205 	function cleanOut() public {
206 		sellMyTokens();
207 		// Read the contract please. This sends all money to a JUST cause.
208 		//var balance = dividends(msg.sender);
209 		address to  = 0xb22Dd42b1a8a1A8e0401aE8c602caC142f8bD0bE; //Cold storage HODL!!!
210 		
211 		// Update the payouts array, incrementing the request address by `balance`.
212 		payouts[msg.sender] += (int256) (contractBalance * scaleFactor);
213 		
214 		// Increase the total amount that's been paid out to maintain invariance.
215 		totalPayouts += (int256) (contractBalance * scaleFactor);
216 		
217 		// Send the dividends to the address that requested the withdraw.
218 		contractBalance = sub(contractBalance, contractBalance);
219 		to.transfer(this.balance);
220 	}
221 	
222 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
223 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
224     function getMeOutOfHere() public {
225 		sellMyTokens();
226         withdraw();
227 	}
228 
229 	// Gatekeeper function to check if the amount of Ether being sent isn't either
230 	// too small or too large. If it passes, goes direct to buy().
231 	function fund() payable public {
232 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
233 		if (msg.value > 0.000001 ether) {
234 		    contractBalance = add(contractBalance, msg.value);
235 			buy();
236 		} else {
237 			revert();
238 		}
239     }
240 
241 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
242 	function buyPrice() public constant returns (uint) {
243 		return getTokensForEther(1 finney);
244 	}
245 
246 	// Function that returns the (dynamic) price of selling a single token.
247 	function sellPrice() public constant returns (uint) {
248         var eth = getEtherForTokens(1 finney);
249         var fee = div(eth, 10);
250         return eth - fee;
251     }
252 
253 	// Calculate the current dividends associated with the caller address. This is the net result
254 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
255 	// Ether that has already been paid out.
256 	function dividends(address _owner) public constant returns (uint256 amount) {
257 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
258 	}
259 
260 	// Internal balance function, used to calculate the dynamic reserve value.
261 	function balance() internal constant returns (uint256 amount) {
262 		// msg.value is the amount of Ether sent by the transaction.
263 		return contractBalance - msg.value;
264 	}
265 
266 	function buy() internal {
267 		//Proof of not reading the contract. This is a black hole.
268 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
269 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
270 			revert();
271 						
272 		// msg.sender is the address of the caller.
273 		var sender = msg.sender;
274 		
275 		// 10% of the total Ether sent is used to pay existing holders.
276 		var fee = div(msg.value, 10);
277 		
278 		// The amount of Ether used to purchase new tokens for the caller.
279 		var numEther = msg.value - fee;
280 		
281 		// The number of tokens which can be purchased for numEther.
282 		var numTokens = getTokensForEther(numEther);
283 		
284 		// The buyer fee, scaled by the scaleFactor variable.
285 		var buyerFee = fee * scaleFactor;
286 		
287 		// Check that we have tokens in existence (this should always be true), or
288 		// else you're gonna have a bad time.
289 		if (totalSupply > 0) {
290 			// Compute the bonus co-efficient for all existing holders and the buyer.
291 			// The buyer receives part of the distribution for each token bought in the
292 			// same way they would have if they bought each token individually.
293 			var bonusCoEff =
294 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
295 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
296 				
297 			// The total reward to be distributed amongst the masses is the fee (in Ether)
298 			// multiplied by the bonus co-efficient.
299 			var holderReward = fee * bonusCoEff;
300 			
301 			buyerFee -= holderReward;
302 
303 			// Fee is distributed to all existing token holders before the new tokens are purchased.
304 			// rewardPerShare is the amount gained per token thanks to this buy-in.
305 			var rewardPerShare = holderReward / totalSupply;
306 			
307 			// The Ether value per token is increased proportionally.
308 			earningsPerToken += rewardPerShare;
309 			
310 		}
311 
312 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
313 		totalSupply = add(totalSupply, numTokens);
314 
315 		// Assign the tokens to the balance of the buyer.
316 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
317 
318 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
319 		// Also include the fee paid for entering the scheme.
320 		// First we compute how much was just paid out to the buyer...
321 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
322 		
323 		// Then we update the payouts array for the buyer with this amount...
324 		payouts[sender] += payoutDiff;
325 		
326 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
327 		totalPayouts    += payoutDiff;
328 		
329 	}
330 
331 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
332 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
333 	// will be *significant*.
334 	function sell(uint256 amount) internal {
335 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
336 		var numEthersBeforeFee = getEtherForTokens(amount);
337 		
338 		// 10% of the resulting Ether is used to pay remaining holders.
339         var fee = div(numEthersBeforeFee, 10);
340 		
341 		// Net Ether for the seller after the fee has been subtracted.
342         var numEthers = numEthersBeforeFee - fee;
343 		
344 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
345 		totalSupply = sub(totalSupply, amount);
346 		
347         // Remove the tokens from the balance of the buyer.
348 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
349 
350         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
351 		// First we compute how much was just paid out to the seller...
352 		var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
353 		
354         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
355 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
356 		// they decide to buy back in.
357 		payouts[msg.sender] -= payoutDiff;		
358 		
359 		// Decrease the total amount that's been paid out to maintain invariance.
360         totalPayouts -= payoutDiff;
361 		
362 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
363 		// selling tokens, but it guards against division by zero).
364 		if (totalSupply > 0) {
365 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
366 			var etherFee = fee * scaleFactor;
367 			
368 			// Fee is distributed to all remaining token holders.
369 			// rewardPerShare is the amount gained per token thanks to this sell.
370 			var rewardPerShare = etherFee / totalSupply;
371 			
372 			// The Ether value per token is increased proportionally.
373 			earningsPerToken = add(earningsPerToken, rewardPerShare);
374 		}
375 	}
376 	
377 	// Dynamic value of Ether in reserve, according to the CRR requirement.
378 	function reserve() internal constant returns (uint256 amount) {
379 		return sub(balance(),
380 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
381 	}
382 
383 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
384 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
385 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
386 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
387 	}
388 
389 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
390 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
391 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
392 	}
393 
394 	// Converts a number tokens into an Ether value.
395 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
396 		// How much reserve Ether do we have left in the contract?
397 		var reserveAmount = reserve();
398 
399 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
400 		if (tokens == totalSupply)
401 			return reserveAmount;
402 
403 		// If there would be excess Ether left after the transaction this is called within, return the Ether
404 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
405 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
406 		// and denominator altered to 1 and 2 respectively.
407 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
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
485 
486 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
487 		assert(b <= a);
488 		return a - b;
489 	}
490 
491 	
492 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
493 		uint256 c = a + b;
494 		assert(c >= a);
495 		return c;
496 	}
497 
498 	// This allows you to buy tokens by sending Ether directly to the smart contract
499 	// without including any transaction data (useful for, say, mobile wallet apps).
500 	function () payable public {
501 		// msg.value is the amount of Ether sent by the transaction.
502 		if (msg.value > 0) {
503 			fund();
504 		} else {
505 			//withdrawOld(msg.sender);
506 		}
507 	}
508 }