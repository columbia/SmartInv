1 pragma solidity ^0.4.22;/*
2  _ _____  ___   _ _  __ 
3  ` __ ___  ___  _  _  ,'   
4   `. __  ____   /__ ,'
5     `.  __  __ /  ,'       
6       `.__ _  /_,'
7         `. _ /,'
8           `./'             
9           ,/`.             
10         ,'/ __`.        
11       ,'_/_  _ _`.      
12     ,'__/_ ___ _  `.       
13   ,'_  /___ __ _ __ `.  
14  '-.._/____   _  __  _`.
15 Decentralized Securities Licensing
16 */contract PeerLicensing{
17 
18 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
19 	// orders of magnitude, hence the need to bridge between the two.
20 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
21 
22 	// CRR = 50%
23 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
24 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
25 	uint256 constant trickTax = 3;//tricklingUpTax
26 	uint256 constant tricklingUpTax = 6;//divided at every referral layer
27 	int constant crr_n = 1; // CRR numerator
28 	int constant crr_d = 2; // CRR denominator
29 
30 	// The price coefficient. Chosen such that at 1 token total supply
31 	// the amount in reserve is 10 ether and token price is 1 Ether.
32 	int constant price_coeff = 0x2793DB20E4C20163A;//-0x570CAC130DBC4A9607;//-0x33548A9DD6D8344F0;
33 
34 	// Array between each address and their number of staking bond tokens.
35 	mapping(address => uint256) public bondHoldings;
36 	mapping(address => uint256) public averageBuyInPrice;
37 	
38 	// Array between each address and how much Ether has been paid out to it.
39 	// Note that this is scaled by the scaleFactor variable.
40 	mapping(address => address) public reff;
41 	mapping(address => uint256) public tricklePocket;
42 	mapping(address => uint256) public trickling;
43 	mapping(address => int256) public payouts;
44 
45 	// Variable tracking how many tokens are in existence overall.
46 	uint256 public totalBondSupply;
47 
48 	// Aggregate sum of all payouts.
49 	// Note that this is scaled by the scaleFactor variable.
50 	int256 totalPayouts;
51 	uint256 public tricklingSum;
52 	uint256 public stakingRequirement = 1e18;
53 	address public lastGateway;
54 
55 	//flux fee ratio score keepers
56 	uint256 public withdrawSum;
57 	uint256 public investSum;
58 
59 	// Variable tracking how much Ether each token is currently worth.
60 	// Note that this is scaled by the scaleFactor variable.
61 	uint256 earningsPerToken;
62 	
63 	// Current contract balance in Ether
64 	uint256 public contractBalance;
65 
66 	function PeerLicensing() public {
67 	}
68 
69 
70 	event onTokenPurchase(
71         address indexed customerAddress,
72         uint256 incomingEthereum,
73         uint256 tokensMinted,
74         address indexed referredBy,
75         uint256 feeFluxImport
76     );
77     
78     event onTokenSell(
79         address indexed customerAddress,
80         uint256 totalTokensAtTheTime,//maybe it'd be cool to see what % people are selling from their total bank
81         uint256 tokensBurned,
82         uint256 ethereumEarned
83     );
84     
85     event onReinvestment(
86         address indexed customerAddress,
87         uint256 ethereumReinvested,
88         uint256 tokensMinted
89     );
90     
91     event onWithdraw(
92         address indexed customerAddress,
93         uint256 ethereumWithdrawn,
94         uint256 feeFluxExport
95     );
96 
97 
98 	// Returns the number of tokens currently held by _owner.
99 	function holdingsOf(address _owner) public constant returns (uint256 balance) {
100 		return bondHoldings[_owner];
101 	}
102 
103 	// Withdraws all dividends held by the caller sending the transaction, updates
104 	// the requisite global variables, and transfers Ether back to the caller.
105 	function withdraw() public {
106 		trickleUp();
107 		// Retrieve the dividends associated with the address the request came from.
108 		var balance = dividends(msg.sender);
109 		var pocketBalance = tricklePocket[msg.sender];
110 		tricklePocket[msg.sender] = 0;
111 		tricklingSum = sub(tricklingSum,pocketBalance);
112 		uint256 out = add(balance,pocketBalance);
113 		// Update the payouts array, incrementing the request address by `balance`.
114 		payouts[msg.sender] += (int256) (balance * scaleFactor);
115 		
116 		// Increase the total amount that's been paid out to maintain invariance.
117 		totalPayouts += (int256) (balance * scaleFactor);
118 		
119 		// Send the dividends to the address that requested the withdraw.
120 		contractBalance = sub(contractBalance, out );
121 
122 		withdrawSum = add(withdrawSum,out );
123 		msg.sender.transfer(out);
124 		emit onWithdraw(msg.sender, out, withdrawSum);
125 	}
126 
127 	function withdrawOld(address to) public {
128 		trickleUp();
129 		// Retrieve the dividends associated with the address the request came from.
130 		var balance = dividends(msg.sender);
131 		var pocketBalance = tricklePocket[msg.sender];
132 		tricklePocket[msg.sender] = 0;
133 		tricklingSum = sub(tricklingSum,pocketBalance);//gotta preserve that things for dynamic calculation		
134 		uint256 out = add(balance,pocketBalance);
135 
136 		// Update the payouts array, incrementing the request address by `balance`.
137 		payouts[msg.sender] += (int256) (balance * scaleFactor);
138 		
139 		// Increase the total amount that's been paid out to maintain invariance.
140 		totalPayouts += (int256) (balance * scaleFactor);
141 		
142 		// Send the dividends to the address that requested the withdraw.
143 		contractBalance = sub(contractBalance, out);
144 
145 		withdrawSum = add(withdrawSum, out);
146 		to.transfer(out);
147 		emit onWithdraw(to,out, withdrawSum);
148 	}
149 
150 
151 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
152 	// in the bondHoldings array, and therefore is shown as a dividend. A second
153 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
154 	function sellMyTokens(uint256 _amount) public {
155 		if(_amount <= bondHoldings[msg.sender]){
156 			sell(_amount);
157 		}else{
158 			revert();
159 		}
160 	}
161 
162 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
163 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
164     function getMeOutOfHere() public {
165 		sellMyTokens(bondHoldings[msg.sender]);
166         withdraw();
167 	}
168 
169 	function reffUp(address _reff) internal{
170 		address sender = msg.sender;
171 		if (_reff == 0x0000000000000000000000000000000000000000 || _reff == msg.sender)
172 			_reff = lastGateway;
173 			
174 		if(  bondHoldings[_reff] >= stakingRequirement ) {
175 			//good to go. good gateway
176 		}else{
177 			if(lastGateway == 0x0000000000000000000000000000000000000000){
178 				lastGateway = sender;//first buyer ever
179 				_reff = sender;//first buyer is their own gateway/masternode
180 			}
181 			else
182 				_reff = lastGateway;//the lucky last player gets to be the gate way.
183 		}
184 
185 		reff[sender] = _reff;
186 	}
187 	// Gatekeeper function to check if the amount of Ether being sent isn't either
188 	// too small or too large. If it passes, goes direct to buy().
189 	function fund(address _reff) payable public {
190 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
191 		reffUp(_reff);
192 		if (msg.value > 0.000001 ether) {
193 		    contractBalance = add(contractBalance, msg.value);
194 		    investSum = add(investSum,msg.value);
195 			buy();
196 			lastGateway = msg.sender;
197 		} else {
198 			revert();
199 		}
200     }
201 
202 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
203 	function buyPrice() public constant returns (uint) {
204 		return getTokensForEther(1 finney);
205 	}
206 
207 	// Function that returns the (dynamic) price of selling a single token.
208 	function sellPrice() public constant returns (uint) {
209         var eth = getEtherForTokens(1 finney);
210 
211         uint256 fee;
212         if(withdrawSum ==0){
213     		return eth;
214 	    }
215         else{
216     		fee = fluxFeed(eth,false);
217 	    	return eth - fee;
218 	    }
219 
220         
221     }
222 	function getInvestSum() public constant returns (uint256 sum) {
223 		return investSum;
224 	}
225 	function getWithdrawSum() public constant returns (uint256 sum) {
226 		return withdrawSum;
227 	}
228 	function fluxFeed(uint256 amount, bool slim_reinvest) public constant returns (uint256 fee) {
229 		if (withdrawSum == 0)
230 			return 0;
231 		else
232 		{
233 			if(slim_reinvest){
234 				return div( mul(amount , withdrawSum), mul(investSum,3) );//discount for supporting the Pyramid
235 			}else{
236 				return div( mul(amount , withdrawSum), investSum);// amount * withdrawSum / investSum	
237 			}
238 		}
239 		//gotta multiply and stuff in that order in order to get a high precision taxed amount.
240 		// because grouping (withdrawSum / investSum) can't return a precise decimal.
241 		//so instead we expand the value by multiplying then shrink it. by the denominator
242 
243 		/*
244 		100eth IN & 100eth OUT = 100% tax fee (returning 1) !!!
245 		100eth IN & 50eth OUT = 50% tax fee (returning 2)
246 		100eth IN & 33eth OUT = 33% tax fee (returning 3)
247 		100eth IN & 25eth OUT = 25% tax fee (returning 4)
248 		100eth IN & 10eth OUT = 10% tax fee (returning 10)
249 
250 		!!! keep in mind there is no fee if there are no holders. So if 100% of the eth has left the contract that means there can't possibly be holders to tax you
251 		*/
252 	}
253 
254 	// Calculate the current dividends associated with the caller address. This is the net result
255 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
256 	// Ether that has already been paid out.
257 	function dividends(address _owner) public constant returns (uint256 amount) {
258 		return (uint256) ((int256)(earningsPerToken * bondHoldings[_owner] ) - payouts[_owner]) / scaleFactor;
259 	}
260 	function cashWallet(address _owner) public constant returns (uint256 amount) {
261 		return tricklePocket[_owner] + dividends(_owner);
262 	}
263 
264 	// Internal balance function, used to calculate the dynamic reserve value.
265 	function balance() internal constant returns (uint256 amount){
266 		// msg.value is the amount of Ether sent by the transaction.
267 		return contractBalance - msg.value - tricklingSum;
268 	}
269 				function trickleUp() internal{
270 					uint256 tricks = trickling[ msg.sender ];
271 					if(tricks > 0){
272 						trickling[ msg.sender ] = 0;
273 						uint256 passUp = div(tricks,tricklingUpTax);
274 						uint256 reward = sub(tricks,passUp);//trickling[]
275 						address reffo = reff[msg.sender];
276 						if( holdingsOf(reffo) >= stakingRequirement){ // your reff must be holding more than the staking requirement
277 							trickling[ reffo ] = add(trickling[ reffo ],passUp);
278 							tricklePocket[ reffo ] = add(tricklePocket[ reffo ],reward);
279 						}else{//basically. if your referral guy bailed out then he can't get the rewards, instead give it to the new guy that was baited in by this feature
280 							trickling[ lastGateway ] = add(trickling[ lastGateway ],passUp);
281 							tricklePocket[ lastGateway ] = add(tricklePocket[ lastGateway ],reward);
282 							reff[msg.sender] = lastGateway;
283 						}
284 					}
285 				}
286 
287 								function buy() internal {
288 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
289 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
290 										revert();
291 													
292 									// msg.sender is the address of the caller.
293 									var sender = msg.sender;
294 									
295 									// 10% of the total Ether sent is used to pay existing holders.
296 									uint256 fee = 0; 
297 									uint256 trickle = 0; 
298 									if(bondHoldings[sender] < totalBondSupply){
299 										fee = fluxFeed(msg.value,false);
300 										trickle = div(fee, trickTax);
301 										fee = sub(fee , trickle);
302 										trickling[sender] = add(trickling[sender] ,  trickle);
303 									}
304 									var numEther = msg.value - (fee + trickle);// The amount of Ether used to purchase new tokens for the caller.
305 									var numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
306 
307 
308 									// The buyer fee, scaled by the scaleFactor variable.
309 									var buyerFee = fee * scaleFactor;
310 									
311 									if (totalBondSupply > 0){// because ...
312 										// Compute the bonus co-efficient for all existing holders and the buyer.
313 										// The buyer receives part of the distribution for each token bought in the
314 										// same way they would have if they bought each token individually.
315 										uint256 bonusCoEff;
316 										bonusCoEff = (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / ( totalBondSupply + totalBondSupply + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
317 										
318 										
319 										// The total reward to be distributed amongst the masses is the fee (in Ether)
320 										// multiplied by the bonus co-efficient.
321 										var holderReward = fee * bonusCoEff;
322 										
323 										buyerFee -= holderReward;
324 										
325 										// The Ether value per token is increased proportionally.
326 										earningsPerToken += holderReward / totalBondSupply;
327 										
328 									}
329 
330 									
331 									
332 									// Add the numTokens which were just created to the total supply. We're a crypto central bank!
333 									totalBondSupply = add(totalBondSupply, numTokens);
334 
335 									var averageCostPerToken = div(numTokens , numEther);
336 									var newTokenSum = add(bondHoldings[sender], numTokens);
337 									var totalSpentBefore = mul(averageBuyInPrice[sender], holdingsOf(sender) );
338 									averageBuyInPrice[sender] = div( totalSpentBefore + mul( averageCostPerToken , numTokens), newTokenSum )  ;
339 
340 									// Assign the tokens to the balance of the buyer.
341 									bondHoldings[sender] = add(bondHoldings[sender], numTokens);
342 									// Update the payout array so that the buyer cannot claim dividends on previous purchases.
343 									// Also include the fee paid for entering the scheme.
344 									// First we compute how much was just paid out to the buyer...
345 									int256 payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
346 								
347 									
348 									
349 									// Then we update the payouts array for the buyer with this amount...
350 									payouts[sender] += payoutDiff;
351 									
352 									// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
353 									totalPayouts += payoutDiff;
354 
355 									
356 									
357 									tricklingSum = add(tricklingSum ,  trickle);
358 									trickleUp();
359 									emit onTokenPurchase(sender,numEther,numTokens, reff[sender], investSum);
360 								}
361 
362 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
363 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
364 								// will be *significant*.
365 								function sell(uint256 amount) internal {
366 								    var numEthersBeforeFee = getEtherForTokens(amount);
367 									
368 									// x% of the resulting Ether is used to pay remaining holders.
369 									uint256 fee = 0;
370 									uint256 trickle = 0;
371 									if(totalBondSupply != bondHoldings[msg.sender]){
372 										fee = fluxFeed(numEthersBeforeFee,false);//fluxFeed()
373 										trickle = div(fee, trickTax); 
374 										fee = sub(fee , trickle);
375 										trickling[msg.sender] = add(trickling[msg.sender] ,  trickle);
376 										tricklingSum = add(tricklingSum ,  trickle);
377 									} 
378 									
379 									// Net Ether for the seller after the fee has been subtracted.
380 							        var numEthers = numEthersBeforeFee - (fee + trickle);
381 									
382 									//How much you bought it for divided by how much you're getting back.
383 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
384 									mint( mul( div( averageBuyInPrice[msg.sender] * scaleFactor , div(amount,numEthers) ) , amount/*correlate to the amount sold*/) , msg.sender );
385 
386 									// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
387 									totalBondSupply = sub(totalBondSupply, amount);
388 									// Remove the tokens from the balance of the buyer.
389 									bondHoldings[msg.sender] = sub(bondHoldings[msg.sender], amount);
390 
391 							        // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
392 									// First we compute how much was just paid out to the seller...
393 									int256 payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
394 									
395 									
396 							        // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
397 									// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
398 									// they decide to buy back in.
399 									payouts[msg.sender] -= payoutDiff;		
400 									
401 									// Decrease the total amount that's been paid out to maintain invariance.
402 							        totalPayouts -= payoutDiff;
403 									
404 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
405 									// selling tokens, but it guards against division by zero).
406 									if (totalBondSupply > 0) {
407 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
408 										var etherFee = fee * scaleFactor;
409 										
410 										// Fee is distributed to all remaining token holders.
411 										// rewardPerShare is the amount gained per token thanks to this sell.
412 										var rewardPerShare = etherFee / totalBondSupply;
413 										
414 										// The Ether value per token is increased proportionally.
415 										earningsPerToken = add(earningsPerToken, rewardPerShare);
416 									}
417 									
418 									trickleUp();
419 									emit onTokenSell(msg.sender,(bondHoldings[msg.sender]+amount),amount,numEthers);
420 								}
421 
422 				// Converts the Ether accrued as dividends back into Staking tokens without having to
423 				// withdraw it first. Saves on gas and potential price spike loss.
424 				function reinvestDividends() public {
425 					// Retrieve the dividends associated with the address the request came from.
426 					var balance = tricklePocket[msg.sender];
427 					balance = add( balance, dividends(msg.sender) );
428 					tricklingSum = sub(tricklingSum,tricklePocket[msg.sender]);
429 					tricklePocket[msg.sender] = 0;
430 					
431 					// Update the payouts array, incrementing the request address by `balance`.
432 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
433 					payouts[msg.sender] += (int256) (balance * scaleFactor);
434 					
435 					// Increase the total amount that's been paid out to maintain invariance.
436 					totalPayouts += (int256) (balance * scaleFactor);
437 					
438 					// Assign balance to a new variable.
439 					uint value_ = (uint) (balance);
440 					
441 					// If your dividends are worth less than 1 szabo, or more than a million Ether
442 					// (in which case, why are you even here), abort.
443 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
444 						revert();
445 						
446 
447 					uint256 fee = 0; 
448 					uint256 trickle = 0;
449 					if(bondHoldings[msg.sender] != totalBondSupply){
450 						fee = fluxFeed(value_,true); // reinvestment fees are lower than regular ones.
451 						trickle = div(fee, trickTax);
452 						fee = sub(fee , trickle);
453 						trickling[msg.sender] += trickle;
454 					}
455 					
456 
457 					var res = sub(reserve() , balance);
458 					// The amount of Ether used to purchase new tokens for the caller.
459 					var numEther = value_ - fee;
460 					
461 					// The number of tokens which can be purchased for numEther.
462 					var numTokens = calculateDividendTokens(numEther, balance);
463 					
464 					// The buyer fee, scaled by the scaleFactor variable.
465 					var buyerFee = fee * scaleFactor;
466 					
467 					// Check that we have tokens in existence (this should always be true), or
468 					// else you're gonna have a bad time.
469 					if (totalBondSupply > 0) {
470 						uint256 bonusCoEff;
471 						
472 						// Compute the bonus co-efficient for all existing holders and the buyer.
473 						// The buyer receives part of the distribution for each token bought in the
474 						// same way they would have if they bought each token individually.
475 						bonusCoEff =  (scaleFactor - (res + numEther ) * numTokens * scaleFactor / (totalBondSupply + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
476 					
477 						// The total reward to be distributed amongst the masses is the fee (in Ether)
478 						// multiplied by the bonus co-efficient.
479 						var holderReward = fee * bonusCoEff;
480 						
481 						buyerFee -= holderReward;
482 
483 						// Fee is distributed to all existing token holders before the new tokens are purchased.
484 						// rewardPerShare is the amount gained per token thanks to this buy-in.
485 						
486 						// The Ether value per token is increased proportionally.
487 						earningsPerToken += holderReward / totalBondSupply;
488 					}
489 					
490 					int256 payoutDiff;
491 					// Add the numTokens which were just created to the total supply. We're a crypto central bank!
492 					totalBondSupply = add(totalBondSupply, numTokens);
493 					// Assign the tokens to the balance of the buyer.
494 					bondHoldings[msg.sender] = add(bondHoldings[msg.sender], numTokens);
495 					// Update the payout array so that the buyer cannot claim dividends on previous purchases.
496 					// Also include the fee paid for entering the scheme.
497 					// First we compute how much was just paid out to the buyer...
498 					payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
499 				
500 					
501 					/*var averageCostPerToken = div(numTokens , numEther);
502 					var newTokenSum = add(bondHoldings_FNX[sender], numTokens);
503 					var totalSpentBefore = mul(averageBuyInPrice[sender], holdingsOf(sender) );*/
504 					//averageBuyInPrice[sender] = div( totalSpentBefore + mul( averageCostPerToken , numTokens), newTokenSum )  ;
505 					
506 					// Then we update the payouts array for the buyer with this amount...
507 					payouts[msg.sender] += payoutDiff;
508 					
509 					// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
510 					totalPayouts += payoutDiff;
511 
512 					
513 
514 					tricklingSum += trickle;//add to trickle's Sum after reserve calculations
515 					trickleUp();
516 					emit onReinvestment(msg.sender,numEther,numTokens);
517 				}
518 	
519 	// Dynamic value of Ether in reserve, according to the CRR requirement.
520 	function reserve() internal constant returns (uint256 amount){
521 		return sub(balance(),
522 			  ((uint256) ((int256) (earningsPerToken * totalBondSupply) - totalPayouts ) / scaleFactor) 
523 		);
524 	}
525 
526 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
527 	// dynamic reserve and totalBondSupply values (derived from the buy and sell prices).
528 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
529 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply);
530 	}
531 
532 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
533 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
534 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply);
535 	}
536 
537 	// Converts a number tokens into an Ether value.
538 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
539 		// How much reserve Ether do we have left in the contract?
540 		var reserveAmount = reserve();
541 
542 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
543 		if (tokens == (totalBondSupply) )
544 			return reserveAmount;
545 
546 		// If there would be excess Ether left after the transaction this is called within, return the Ether
547 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
548 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
549 		// and denominator altered to 1 and 2 respectively.
550 		return sub(reserveAmount, fixedExp((fixedLog(totalBondSupply - tokens) - price_coeff) * crr_d/crr_n));
551 	}
552 
553 	// You don't care about these, but if you really do they're hex values for 
554 	// co-efficients used to simulate approximations of the log and exp functions.
555 	int256  constant one        = 0x10000000000000000;
556 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
557 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
558 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
559 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
560 	int256  constant c1         = 0x1ffffffffff9dac9b;
561 	int256  constant c3         = 0x0aaaaaaac16877908;
562 	int256  constant c5         = 0x0666664e5e9fa0c99;
563 	int256  constant c7         = 0x049254026a7630acf;
564 	int256  constant c9         = 0x038bd75ed37753d68;
565 	int256  constant c11        = 0x03284a0c14610924f;
566 
567 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
568 	// approximates the function log(1+x)-log(1-x)
569 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
570 	function fixedLog(uint256 a) internal pure returns (int256 log) {
571 		int32 scale = 0;
572 		while (a > sqrt2) {
573 			a /= 2;
574 			scale++;
575 		}
576 		while (a <= sqrtdot5) {
577 			a *= 2;
578 			scale--;
579 		}
580 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
581 		var z = (s*s) / one;
582 		return scale * ln2 +
583 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
584 				/one))/one))/one))/one))/one);
585 	}
586 
587 	int256 constant c2 =  0x02aaaaaaaaa015db0;
588 	int256 constant c4 = -0x000b60b60808399d1;
589 	int256 constant c6 =  0x0000455956bccdd06;
590 	int256 constant c8 = -0x000001b893ad04b3a;
591 	
592 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
593 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
594 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
595 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
596 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
597 		a -= scale*ln2;
598 		int256 z = (a*a) / one;
599 		int256 R = ((int256)(2) * one) +
600 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
601 		exp = (uint256) (((R + a) * one) / (R - a));
602 		if (scale >= 0)
603 			exp <<= scale;
604 		else
605 			exp >>= -scale;
606 		return exp;
607 	}
608 	
609 	// The below are safemath implementations of the four arithmetic operators
610 	// designed to explicitly prevent over- and under-flows of integer values.
611 
612 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
613 		if (a == 0) {
614 			return 0;
615 		}
616 		uint256 c = a * b;
617 		assert(c / a == b);
618 		return c;
619 	}
620 
621 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
622 		uint256 c = a / b;
623 		return c;
624 	}
625 
626 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
627 		assert(b <= a);
628 		return a - b;
629 	}
630 
631 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
632 		uint256 c = a + b;
633 		assert(c >= a);
634 		return c;
635 	}
636 	function () payable public {
637 		
638 		if (msg.value > 0) {
639 			fund(lastGateway);
640 		} else {
641 			withdrawOld(msg.sender);
642 		}
643 	}
644 
645 
646 
647 	uint256 public totalSupply;
648     uint256 constant private MAX_UINT256 = 2**256 - 1;
649     mapping (address => uint256) public balances;
650     mapping (address => mapping (address => uint256)) public allowed;
651     
652     string public name = "0xBabylon";
653     uint8 public decimals = 18;
654     string public symbol = "SEC";
655     
656     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
657     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
658 
659     function mint(uint256 amount,address _account) internal{
660     	totalSupply += amount;
661     	balances[_account] += amount;
662     }
663 
664     function transfer(address _to, uint256 _value) public returns (bool success) {
665         require(balances[msg.sender] >= _value);
666         balances[msg.sender] -= _value;
667         balances[_to] += _value;
668         emit Transfer(msg.sender, _to, _value);
669         return true;
670     }
671 	
672     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
673         uint256 allowance = allowed[_from][msg.sender];
674         require(balances[_from] >= _value && allowance >= _value);
675         balances[_to] += _value;
676         balances[_from] -= _value;
677         if (allowance < MAX_UINT256) {
678             allowed[_from][msg.sender] -= _value;
679         }
680         emit Transfer(_from, _to, _value);
681         return true;
682     }
683 
684     function approve(address _spender, uint256 _value) public returns (bool success) {
685         allowed[msg.sender][_spender] = _value;
686         emit Approval(msg.sender, _spender, _value);
687         return true;
688     }
689 
690     function balanceOf(address _owner) public view returns (uint256 balance) {
691         return balances[_owner];
692     }
693 
694     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
695         return allowed[_owner][_spender];
696     }
697 }