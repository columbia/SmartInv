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
15 
16 The purpose of this contract is to fund the development of a protocol that secures individual sovereignty and incentivized communal responsibility.
17 
18 Many thanks to the PoWH community for overall support
19 
20 Key Features
21 	Flux Fee: Adapts to the "expansion" and "contraction" of the ecosystem's health.
22 	Resolve Tokens: The utility token that "licenses" new products and services into the ecosystem.
23 
24 */contract PoWHrGlass {
25 
26 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
27 	// orders of magnitude, hence the need to bridge between the two.
28 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
29 
30 	// CRR = 50%
31 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
32 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
33 	uint256 constant trickTax = 3;//tricklingUpTax
34 	uint256 constant tricklingUpTax = 6;//divided at every referral layer
35 	int constant crr_n = 1; // CRR numerator
36 	int constant crr_d = 2; // CRR denominator
37 
38 	// The price coefficient. Chosen such that at 1 token total supply
39 	// the amount in reserve is 10 ether and token price is 1 Ether.
40 	int constant price_coeff = 0x2793DB20E4C20163A;//-0x570CAC130DBC4A9607;//-0x33548A9DD6D8344F0;
41 
42 	// Array between each address and their number of staking bond tokens.
43 	mapping(address => uint256) public bondHoldings;
44 	mapping(address => uint256) public averageBuyInPrice;
45 	
46 	// Array between each address and how much Ether has been paid out to it.
47 	// Note that this is scaled by the scaleFactor variable.
48 	mapping(address => address) public reff;
49 	mapping(address => uint256) public tricklePocket;
50 	mapping(address => uint256) public trickling;
51 	mapping(address => int256) public payouts;
52 
53 	// Variable tracking how many tokens are in existence overall.
54 	uint256 public totalBondSupply;
55 
56 	// Aggregate sum of all payouts.
57 	// Note that this is scaled by the scaleFactor variable.
58 	int256 totalPayouts;
59 	uint256 public tricklingSum;
60 	uint256 public stakingRequirement = 1e18;
61 	address public lastGateway;
62 
63 	//flux fee ratio score keepers
64 	uint256 public withdrawSum;
65 	uint256 public investSum;
66 
67 	// Variable tracking how much Ether each token is currently worth.
68 	// Note that this is scaled by the scaleFactor variable.
69 	uint256 earningsPerToken;
70 	
71 	// Current contract balance in Ether
72 	uint256 public contractBalance;
73 
74 	function PoWHrGlass() public {
75 	}
76 
77 
78 	event onTokenPurchase(
79         address indexed customerAddress,
80         uint256 incomingEthereum,
81         uint256 tokensMinted,
82         address indexed referredBy,
83         uint256 feeFluxImport
84     );
85     
86     event onTokenSell(
87         address indexed customerAddress,
88         uint256 totalTokensAtTheTime,//maybe it'd be cool to see what % people are selling from their total bank
89         uint256 tokensBurned,
90         uint256 ethereumEarned
91     );
92     
93     event onReinvestment(
94         address indexed customerAddress,
95         uint256 ethereumReinvested,
96         uint256 tokensMinted
97     );
98     
99     event onWithdraw(
100         address indexed customerAddress,
101         uint256 ethereumWithdrawn,
102         uint256 feeFluxExport
103     );
104 
105 
106 	// Returns the number of tokens currently held by _owner.
107 	function holdingsOf(address _owner) public constant returns (uint256 balance) {
108 		return bondHoldings[_owner];
109 	}
110 
111 	// Withdraws all dividends held by the caller sending the transaction, updates
112 	// the requisite global variables, and transfers Ether back to the caller.
113 	function withdraw() public {
114 		trickleUp();
115 		// Retrieve the dividends associated with the address the request came from.
116 		var balance = dividends(msg.sender);
117 		var pocketBalance = tricklePocket[msg.sender];
118 		tricklePocket[msg.sender] = 0;
119 		tricklingSum = sub(tricklingSum,pocketBalance);
120 		uint256 out = add(balance,pocketBalance);
121 		// Update the payouts array, incrementing the request address by `balance`.
122 		payouts[msg.sender] += (int256) (balance * scaleFactor);
123 		
124 		// Increase the total amount that's been paid out to maintain invariance.
125 		totalPayouts += (int256) (balance * scaleFactor);
126 		
127 		// Send the dividends to the address that requested the withdraw.
128 		contractBalance = sub(contractBalance, out );
129 
130 		withdrawSum = add(withdrawSum,out );
131 		msg.sender.transfer(out);
132 		emit onWithdraw(msg.sender, out, withdrawSum);
133 	}
134 
135 	function withdrawOld(address to) public {
136 		trickleUp();
137 		// Retrieve the dividends associated with the address the request came from.
138 		var balance = dividends(msg.sender);
139 		var pocketBalance = tricklePocket[msg.sender];
140 		tricklePocket[msg.sender] = 0;
141 		tricklingSum = sub(tricklingSum,pocketBalance);//gotta preserve that things for dynamic calculation		
142 		uint256 out = add(balance,pocketBalance);
143 
144 		// Update the payouts array, incrementing the request address by `balance`.
145 		payouts[msg.sender] += (int256) (balance * scaleFactor);
146 		
147 		// Increase the total amount that's been paid out to maintain invariance.
148 		totalPayouts += (int256) (balance * scaleFactor);
149 		
150 		// Send the dividends to the address that requested the withdraw.
151 		contractBalance = sub(contractBalance, out);
152 
153 		withdrawSum = add(withdrawSum, out);
154 		to.transfer(out);
155 		emit onWithdraw(to,out, withdrawSum);
156 	}
157 
158 
159 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
160 	// in the bondHoldings array, and therefore is shown as a dividend. A second
161 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
162 	function sellMyTokens(uint256 _amount) public {
163 		if(_amount <= bondHoldings[msg.sender]){
164 			sell(_amount);
165 		}else{
166 			revert();
167 		}
168 	}
169 
170 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
171 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
172     function getMeOutOfHere() public {
173 		sellMyTokens(bondHoldings[msg.sender]);
174         withdraw();
175 	}
176 
177 	function reffUp(address _reff) internal{
178 		address sender = msg.sender;
179 		if (_reff == 0x0000000000000000000000000000000000000000 || _reff == msg.sender)
180 			_reff = lastGateway;
181 			
182 		if(  bondHoldings[_reff] >= stakingRequirement ) {
183 			//good to go. good gateway
184 		}else{
185 			if(lastGateway == 0x0000000000000000000000000000000000000000){
186 				lastGateway = sender;//first buyer ever
187 				_reff = sender;//first buyer is their own gateway/masternode
188 			}
189 			else
190 				_reff = lastGateway;//the lucky last player gets to be the gate way.
191 		}
192 
193 		reff[sender] = _reff;
194 	}
195 	// Gatekeeper function to check if the amount of Ether being sent isn't either
196 	// too small or too large. If it passes, goes direct to buy().
197 	function fund(address _reff) payable public {
198 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
199 		reffUp(_reff);
200 		if (msg.value > 0.000001 ether) {
201 		    contractBalance = add(contractBalance, msg.value);
202 		    investSum = add(investSum,msg.value);
203 			buy();
204 			lastGateway = msg.sender;
205 		} else {
206 			revert();
207 		}
208     }
209 
210 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
211 	function buyPrice() public constant returns (uint) {
212 		return getTokensForEther(1 finney);
213 	}
214 
215 	// Function that returns the (dynamic) price of selling a single token.
216 	function sellPrice() public constant returns (uint) {
217         var eth = getEtherForTokens(1 finney);
218 
219         uint256 fee;
220         if(withdrawSum ==0){
221     		return eth;
222 	    }
223         else{
224     		fee = fluxFeed(eth,false);
225 	    	return eth - fee;
226 	    }
227 
228         
229     }
230     function feeDiv(uint256 a, uint256 b) internal pure returns (uint256 amount) {
231     	if (b == 0)
232 			return 0;
233 		else
234 			return div(a,b);
235     }
236 
237 	function fluxFeed(uint256 amount, bool slim_reinvest) public constant returns (uint256 fee) {
238 		if (withdrawSum == 0)
239 			return 0;
240 		else
241 		{
242 			if(slim_reinvest){
243 				return div( mul(amount , withdrawSum), mul(investSum,3) );//discount for supporting the Pyramid
244 			}else{
245 				return div( mul(amount , withdrawSum), investSum);// amount * withdrawSum / investSum	
246 			}
247 		}
248 		//gotta multiply and stuff in that order in order to get a high precision taxed amount.
249 		// because grouping (withdrawSum / investSum) can't return a precise decimal.
250 		//so instead we expand the value by multiplying then shrink it. by the denominator
251 
252 		/*
253 		100eth IN & 100eth OUT = 100% tax fee (returning 1) !!!
254 		100eth IN & 50eth OUT = 50% tax fee (returning 2)
255 		100eth IN & 33eth OUT = 33% tax fee (returning 3)
256 		100eth IN & 25eth OUT = 25% tax fee (returning 4)
257 		100eth IN & 10eth OUT = 10% tax fee (returning 10)
258 
259 		!!! keep in mind there is no fee if there are no holders. So if 100% of the eth has left the contract that means there can't possibly be holders to tax you
260 		*/
261 	}
262 
263 	// Calculate the current dividends associated with the caller address. This is the net result
264 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
265 	// Ether that has already been paid out.
266 	function dividends(address _owner) public constant returns (uint256 amount) {
267 		return (uint256) ((int256)(earningsPerToken * bondHoldings[_owner] ) - payouts[_owner]) / scaleFactor;
268 	}
269 	function cashWallet(address _owner) public constant returns (uint256 amount) {
270 		return tricklePocket[_owner] + dividends(_owner);
271 	}
272 
273 	// Internal balance function, used to calculate the dynamic reserve value.
274 	function balance() internal constant returns (uint256 amount){
275 		// msg.value is the amount of Ether sent by the transaction.
276 		return contractBalance - msg.value - tricklingSum;
277 	}
278 				function trickleUp() internal{
279 					uint256 tricks = trickling[ msg.sender ];
280 					if(tricks > 0){
281 						trickling[ msg.sender ] = 0;
282 						uint256 passUp = div(tricks,tricklingUpTax);
283 						uint256 reward = sub(tricks,passUp);//trickling[]
284 						address reffo = reff[msg.sender];
285 						if( holdingsOf(reffo) >= stakingRequirement){ // your reff must be holding more than the staking requirement
286 							trickling[ reffo ] = add(trickling[ reffo ],passUp);
287 							tricklePocket[ reffo ] = add(tricklePocket[ reffo ],reward);
288 						}else{//basically. if your referral guy bailed out then he can't get the rewards, instead give it to the new guy that was baited in by this feature
289 							trickling[ lastGateway ] = add(trickling[ lastGateway ],passUp);
290 							tricklePocket[ lastGateway ] = add(tricklePocket[ lastGateway ],reward);
291 							reff[msg.sender] = lastGateway;
292 						}
293 					}
294 				}
295 
296 								function buy() internal {
297 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
298 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
299 										revert();
300 													
301 									// msg.sender is the address of the caller.
302 									var sender = msg.sender;
303 									
304 									// 10% of the total Ether sent is used to pay existing holders.
305 									uint256 fee = 0; 
306 									uint256 trickle = 0; 
307 									if(bondHoldings[sender] < totalBondSupply){
308 										fee = fluxFeed(msg.value,false);
309 										trickle = div(fee, trickTax);
310 										fee = sub(fee , trickle);
311 										trickling[sender] = add(trickling[sender] ,  trickle);
312 									}
313 									var numEther = msg.value - (fee + trickle);// The amount of Ether used to purchase new tokens for the caller.
314 									var numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
315 
316 
317 									// The buyer fee, scaled by the scaleFactor variable.
318 									var buyerFee = fee * scaleFactor;
319 									
320 									if (totalBondSupply > 0){// because ...
321 										// Compute the bonus co-efficient for all existing holders and the buyer.
322 										// The buyer receives part of the distribution for each token bought in the
323 										// same way they would have if they bought each token individually.
324 										uint256 bonusCoEff;
325 										bonusCoEff = (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / ( totalBondSupply + totalBondSupply + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
326 										
327 										
328 										// The total reward to be distributed amongst the masses is the fee (in Ether)
329 										// multiplied by the bonus co-efficient.
330 										var holderReward = fee * bonusCoEff;
331 										
332 										buyerFee -= holderReward;
333 										
334 										// The Ether value per token is increased proportionally.
335 										earningsPerToken += holderReward / totalBondSupply;
336 										
337 									}
338 
339 									
340 									
341 									// Add the numTokens which were just created to the total supply. We're a crypto central bank!
342 									totalBondSupply = add(totalBondSupply, numTokens);
343 
344 									var averageCostPerToken = div(numTokens , numEther);
345 									var newTokenSum = add(bondHoldings[sender], numTokens);
346 									var totalSpentBefore = mul(averageBuyInPrice[sender], holdingsOf(sender) );
347 									averageBuyInPrice[sender] = div( totalSpentBefore + mul( averageCostPerToken , numTokens), newTokenSum )  ;
348 
349 									// Assign the tokens to the balance of the buyer.
350 									bondHoldings[sender] = add(bondHoldings[sender], numTokens);
351 									// Update the payout array so that the buyer cannot claim dividends on previous purchases.
352 									// Also include the fee paid for entering the scheme.
353 									// First we compute how much was just paid out to the buyer...
354 									int256 payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
355 								
356 									
357 									
358 									// Then we update the payouts array for the buyer with this amount...
359 									payouts[sender] += payoutDiff;
360 									
361 									// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
362 									totalPayouts += payoutDiff;
363 
364 									
365 									
366 									tricklingSum = add(tricklingSum ,  trickle);
367 									trickleUp();
368 									emit onTokenPurchase(sender,numEther,numTokens, reff[sender], investSum);
369 								}
370 
371 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
372 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
373 								// will be *significant*.
374 								function sell(uint256 amount) internal {
375 								    var numEthersBeforeFee = getEtherForTokens(amount);
376 									
377 									// x% of the resulting Ether is used to pay remaining holders.
378 									uint256 fee = 0;
379 									uint256 trickle = 0;
380 									if(totalBondSupply != bondHoldings[msg.sender]){
381 										fee = fluxFeed(numEthersBeforeFee,false);//fluxFeed()
382 										trickle = div(fee, trickTax); 
383 										fee = sub(fee , trickle);
384 										trickling[msg.sender] = add(trickling[msg.sender] ,  trickle);
385 										tricklingSum = add(tricklingSum ,  trickle);
386 									} 
387 									
388 									// Net Ether for the seller after the fee has been subtracted.
389 							        var numEthers = numEthersBeforeFee - (fee + trickle);
390 									
391 									//How much you bought it for divided by how much you're getting back.
392 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
393 									mint( div( averageBuyInPrice[msg.sender] * scaleFactor , div(amount,numEthers) ) , msg.sender );
394 
395 									// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
396 									totalBondSupply = sub(totalBondSupply, amount);
397 									// Remove the tokens from the balance of the buyer.
398 									bondHoldings[msg.sender] = sub(bondHoldings[msg.sender], amount);
399 
400 							        // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
401 									// First we compute how much was just paid out to the seller...
402 									int256 payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
403 									
404 									
405 							        // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
406 									// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
407 									// they decide to buy back in.
408 									payouts[msg.sender] -= payoutDiff;		
409 									
410 									// Decrease the total amount that's been paid out to maintain invariance.
411 							        totalPayouts -= payoutDiff;
412 									
413 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
414 									// selling tokens, but it guards against division by zero).
415 									if (totalBondSupply > 0) {
416 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
417 										var etherFee = fee * scaleFactor;
418 										
419 										// Fee is distributed to all remaining token holders.
420 										// rewardPerShare is the amount gained per token thanks to this sell.
421 										var rewardPerShare = etherFee / totalBondSupply;
422 										
423 										// The Ether value per token is increased proportionally.
424 										earningsPerToken = add(earningsPerToken, rewardPerShare);
425 									}
426 									
427 									trickleUp();
428 									emit onTokenSell(msg.sender,(bondHoldings[msg.sender]+amount),amount,numEthers);
429 								}
430 
431 				// Converts the Ether accrued as dividends back into Staking tokens without having to
432 				// withdraw it first. Saves on gas and potential price spike loss.
433 				function reinvestDividends() public {
434 					// Retrieve the dividends associated with the address the request came from.
435 					var balance = tricklePocket[msg.sender];
436 					balance = add( balance, dividends(msg.sender) );
437 					tricklingSum = sub(tricklingSum,tricklePocket[msg.sender]);
438 					tricklePocket[msg.sender] = 0;
439 					
440 					// Update the payouts array, incrementing the request address by `balance`.
441 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
442 					payouts[msg.sender] += (int256) (balance * scaleFactor);
443 					
444 					// Increase the total amount that's been paid out to maintain invariance.
445 					totalPayouts += (int256) (balance * scaleFactor);
446 					
447 					// Assign balance to a new variable.
448 					uint value_ = (uint) (balance);
449 					
450 					// If your dividends are worth less than 1 szabo, or more than a million Ether
451 					// (in which case, why are you even here), abort.
452 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
453 						revert();
454 						
455 					// msg.sender is the address of the caller.
456 					//var sender = msg.sender;
457 					
458 
459 					// 10% of the total Ether sent is used to pay existing holders.
460 					//var fee = div(value_, 10);//old
461 
462 					uint256 fee = 0; 
463 					uint256 trickle = 0;
464 					if(bondHoldings[msg.sender] != totalBondSupply){
465 						fee = fluxFeed(value_,true); // reinvestment fees are lower than regular ones.
466 						trickle = div(fee, trickTax);
467 						fee = sub(fee , trickle);
468 						trickling[msg.sender] += trickle;
469 					}
470 					
471 
472 					var res = sub(reserve() , balance);
473 					// The amount of Ether used to purchase new tokens for the caller.
474 					var numEther = value_ - fee;
475 					
476 					// The number of tokens which can be purchased for numEther.
477 					var numTokens = calculateDividendTokens(numEther, balance);
478 					
479 					// The buyer fee, scaled by the scaleFactor variable.
480 					var buyerFee = fee * scaleFactor;
481 					
482 					// Check that we have tokens in existence (this should always be true), or
483 					// else you're gonna have a bad time.
484 					if (totalBondSupply > 0) {
485 						uint256 bonusCoEff;
486 						
487 						// Compute the bonus co-efficient for all existing holders and the buyer.
488 						// The buyer receives part of the distribution for each token bought in the
489 						// same way they would have if they bought each token individually.
490 						bonusCoEff =  (scaleFactor - (res + numEther ) * numTokens * scaleFactor / (totalBondSupply + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
491 					
492 						// The total reward to be distributed amongst the masses is the fee (in Ether)
493 						// multiplied by the bonus co-efficient.
494 						var holderReward = fee * bonusCoEff;
495 						
496 						buyerFee -= holderReward;
497 
498 						// Fee is distributed to all existing token holders before the new tokens are purchased.
499 						// rewardPerShare is the amount gained per token thanks to this buy-in.
500 						
501 						// The Ether value per token is increased proportionally.
502 						earningsPerToken += holderReward / totalBondSupply;
503 					}
504 					
505 					int256 payoutDiff;
506 					// Add the numTokens which were just created to the total supply. We're a crypto central bank!
507 					totalBondSupply = add(totalBondSupply, numTokens);
508 					// Assign the tokens to the balance of the buyer.
509 					bondHoldings[msg.sender] = add(bondHoldings[msg.sender], numTokens);
510 					// Update the payout array so that the buyer cannot claim dividends on previous purchases.
511 					// Also include the fee paid for entering the scheme.
512 					// First we compute how much was just paid out to the buyer...
513 					payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
514 				
515 					
516 					/*var averageCostPerToken = div(numTokens , numEther);
517 					var newTokenSum = add(bondHoldings_FNX[sender], numTokens);
518 					var totalSpentBefore = mul(averageBuyInPrice[sender], holdingsOf(sender) );*/
519 					//averageBuyInPrice[sender] = div( totalSpentBefore + mul( averageCostPerToken , numTokens), newTokenSum )  ;
520 					
521 					// Then we update the payouts array for the buyer with this amount...
522 					payouts[msg.sender] += payoutDiff;
523 					
524 					// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
525 					totalPayouts += payoutDiff;
526 
527 					
528 
529 					tricklingSum += trickle;//add to trickle's Sum after reserve calculations
530 					trickleUp();
531 					emit onReinvestment(msg.sender,numEther,numTokens);
532 				}
533 	
534 	// Dynamic value of Ether in reserve, according to the CRR requirement.
535 	function reserve() internal constant returns (uint256 amount){
536 		return sub(balance(),
537 			  ((uint256) ((int256) (earningsPerToken * totalBondSupply) - totalPayouts ) / scaleFactor) 
538 		);
539 	}
540 
541 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
542 	// dynamic reserve and totalBondSupply values (derived from the buy and sell prices).
543 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
544 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply);
545 	}
546 
547 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
548 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
549 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply);
550 	}
551 
552 	// Converts a number tokens into an Ether value.
553 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
554 		// How much reserve Ether do we have left in the contract?
555 		var reserveAmount = reserve();
556 
557 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
558 		if (tokens == (totalBondSupply) )
559 			return reserveAmount;
560 
561 		// If there would be excess Ether left after the transaction this is called within, return the Ether
562 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
563 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
564 		// and denominator altered to 1 and 2 respectively.
565 		return sub(reserveAmount, fixedExp((fixedLog(totalBondSupply - tokens) - price_coeff) * crr_d/crr_n));
566 	}
567 
568 	// You don't care about these, but if you really do they're hex values for 
569 	// co-efficients used to simulate approximations of the log and exp functions.
570 	int256  constant one        = 0x10000000000000000;
571 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
572 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
573 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
574 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
575 	int256  constant c1         = 0x1ffffffffff9dac9b;
576 	int256  constant c3         = 0x0aaaaaaac16877908;
577 	int256  constant c5         = 0x0666664e5e9fa0c99;
578 	int256  constant c7         = 0x049254026a7630acf;
579 	int256  constant c9         = 0x038bd75ed37753d68;
580 	int256  constant c11        = 0x03284a0c14610924f;
581 
582 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
583 	// approximates the function log(1+x)-log(1-x)
584 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
585 	function fixedLog(uint256 a) internal pure returns (int256 log) {
586 		int32 scale = 0;
587 		while (a > sqrt2) {
588 			a /= 2;
589 			scale++;
590 		}
591 		while (a <= sqrtdot5) {
592 			a *= 2;
593 			scale--;
594 		}
595 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
596 		var z = (s*s) / one;
597 		return scale * ln2 +
598 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
599 				/one))/one))/one))/one))/one);
600 	}
601 
602 	int256 constant c2 =  0x02aaaaaaaaa015db0;
603 	int256 constant c4 = -0x000b60b60808399d1;
604 	int256 constant c6 =  0x0000455956bccdd06;
605 	int256 constant c8 = -0x000001b893ad04b3a;
606 	
607 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
608 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
609 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
610 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
611 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
612 		a -= scale*ln2;
613 		int256 z = (a*a) / one;
614 		int256 R = ((int256)(2) * one) +
615 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
616 		exp = (uint256) (((R + a) * one) / (R - a));
617 		if (scale >= 0)
618 			exp <<= scale;
619 		else
620 			exp >>= -scale;
621 		return exp;
622 	}
623 	
624 	// The below are safemath implementations of the four arithmetic operators
625 	// designed to explicitly prevent over- and under-flows of integer values.
626 
627 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
628 		if (a == 0) {
629 			return 0;
630 		}
631 		uint256 c = a * b;
632 		assert(c / a == b);
633 		return c;
634 	}
635 
636 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
637 		// assert(b > 0); // Solidity automatically throws when dividing by 0
638 		uint256 c = a / b;
639 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
640 		return c;
641 	}
642 
643 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
644 		assert(b <= a);
645 		return a - b;
646 	}
647 
648 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
649 		uint256 c = a + b;
650 		assert(c >= a);
651 		return c;
652 	}
653 
654 	// reff fair
655 	function () payable public {
656 		//revert();// msg.value is the amount of Ether sent by the transaction.
657 		
658 		if (msg.value > 0) {
659 			fund(lastGateway);
660 		} else {
661 			withdrawOld(msg.sender);
662 		}
663 	}
664 
665 
666 /*                                                                             
667                                                     @@@@@                          
668                                                 @@@@@@@@@@                         
669                                              @@@@@@@@@@@@@@                        
670                                           @@@@@@@@@@@@@@@@                         
671            @@                          @@@@@@@@@@@@@@@                @@           
672           @@@@@@@                     @@@@@@@@@@@@@               @@@@@@@          
673          @@@@@@@@@@@                  @@@@@@@@@                @@@@@@@@@@@         
674         @@@@@@@@@@@@@@@@              @@@@@@@               @@@@@@@@@@@@@@@        
675            @@@@@@@@@@@@@@@@           @@@@@@@           @@@@@@@@@@@@@@@@           
676                @@@@@@@@@@@@           @@@@@@@           @@@@@@@@@@@@@              
677                   @@@@@@@@            @@@@@@@             @@@@@@@                  
678                      @@@              @@@@@@@              @@@                     
679                                       @@@@@@@                                      
680            @@                         @@@@@@@                                      
681           @@@@@@                   @@@@@@@@@@@@@                                   
682          @@@@@@@@@@             @@@@@@@@@@@@@@@@@@@                                
683         @@@@@@@@@@@@@@@      @@@@@@@@@@@@@@@@@@@@@@@@@@                            
684            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@                         
685               @@@@@@@@@@@@@@@@@@@@@@@         @@@@@@@@@@@@@@@                      
686                  @@@@@@@@@@@@@@@@@               @@@@@@@@@@@@                      
687                      @@@@@@@@@@                      @@@@@@@@                      
688                          @@                           @@@@@@@                      
689                                                       @@@@@@@                      
690                                                       @@@@@@@                      
691                                       @@@@@@@         @@@@@@@                      
692                                       @@@@@@@         @@@@@@@                      
693                                       @@@@@@@         @@@@@@@                      
694                                       @@@@@@@         @@@@@@@                      
695                                       @@@@@@@         @@@@@@@                      
696                                       @@@@@@@                                      
697                                       @@@@@@@                                      
698                                       @@@@@@@                                      
699                                       @@@@@@@                                      
700 */
701 
702 	uint256 public totalSupply;
703     uint256 constant private MAX_UINT256 = 2**256 - 1;
704     mapping (address => uint256) public balances;
705     mapping (address => mapping (address => uint256)) public allowed;
706     
707     string public name = "0xBabylon";
708     uint8 public decimals = 18; 
709     string public symbol = "PoWHr";
710     
711     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
712     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
713 
714     function mint(uint256 amount,address _account) internal{
715     	totalSupply += amount;
716     	balances[_account] += amount;
717     }
718 
719     function transfer(address _to, uint256 _value) public returns (bool success) {
720         require(balances[msg.sender] >= _value);
721         balances[msg.sender] -= _value;
722         balances[_to] += _value;
723         emit Transfer(msg.sender, _to, _value);
724         return true;
725     }
726 	
727     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
728         uint256 allowance = allowed[_from][msg.sender];
729         require(balances[_from] >= _value && allowance >= _value);
730         balances[_to] += _value;
731         balances[_from] -= _value;
732         if (allowance < MAX_UINT256) {
733             allowed[_from][msg.sender] -= _value;
734         }
735         emit Transfer(_from, _to, _value);
736         return true;
737     }
738 
739     function approve(address _spender, uint256 _value) public returns (bool success) {
740         allowed[msg.sender][_spender] = _value;
741         emit Approval(msg.sender, _spender, _value);
742         return true;
743     }
744 
745     function balanceOf(address _owner) public view returns (uint256 balance) {
746         return balances[_owner];
747     }
748 
749     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
750         return allowed[_owner][_spender];
751     }
752 }