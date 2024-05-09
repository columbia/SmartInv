1 //In dedication to my wife and family
2 pragma solidity ^0.4.23;
3 contract _0xBabylon{
4 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
5 	// orders of magnitude, hence the need to bridge between the two.
6 	uint256 constant scaleFactor = 0x10000000000000000;// 2^64
7 
8 	int constant crr_n = 3;//CRR numerator
9 	int constant crr_d = 5;//CRR denominator
10 
11 	int constant price_coeff = 0x42ea9ce452cde449f;
12 
13 	// Array between each address and their number of tokens.
14 	mapping(address => uint256) public holdings;
15 	//cut down by a percentage when you sell out.
16 	mapping(address => uint256) public avgFactor_ethSpent;
17 
18 	mapping(address => uint256) public color_R;
19 	mapping(address => uint256) public color_G;
20 	mapping(address => uint256) public color_B;
21 
22 	// Array between each address and how much Ether has been paid out to it.
23 	// Note that this is scaled by the scaleFactor variable.
24 	mapping(address => address) public reff;
25 	mapping(address => uint256) public tricklingPass;
26 	mapping(address => uint256) public pocket;
27 	mapping(address => int256) public payouts;
28 
29 	// Variable tracking how many tokens are in existence overall.
30 	uint256 public totalBondSupply;
31 
32 	// Aggregate sum of all payouts.
33 	// Note that this is scaled by the scaleFactor variable.
34 	int256 totalPayouts;
35 	uint256 public trickleSum;
36 	uint256 public stakingRequirement = 1e18;
37 	
38 	address public lastGateway;
39 	uint256 constant trickTax = 3; //divides flux'd fee and for every pass up
40 
41 	//flux fee ratio and contract score keepers
42 	uint256 public withdrawSum;
43 	uint256 public investSum;
44 
45 	// Variable tracking how much Ether each token is currently worth.
46 	// Note that this is scaled by the scaleFactor variable.
47 	uint256 earningsPerBond;
48 
49 	event onTokenPurchase(
50         address indexed customerAddress,
51         uint256 incomingEthereum,
52         uint256 tokensMinted,
53         address indexed gateway
54     );
55 	event onBoughtFor(
56         address indexed buyerAddress,
57         address indexed forWho,
58         uint256 incomingEthereum,
59         uint256 tokensMinted,
60         address indexed gateway
61     );
62 	event onReinvestFor(
63         address indexed buyerAddress,
64         address indexed forWho,
65         uint256 incomingEthereum,
66         uint256 tokensMinted,
67         address indexed gateway
68     );
69     
70     event onTokenSell(
71         address indexed customerAddress,
72         uint256 totalTokensAtTheTime,//maybe it'd be cool to see what % people are selling from their total bank
73         uint256 tokensBurned,
74         uint256 ethereumEarned,
75         uint256 resolved,
76         address indexed gateway
77     );
78     
79     event onReinvestment(
80         address indexed customerAddress,
81         uint256 ethereumReinvested,
82         uint256 tokensMinted,
83         address indexed gateway
84     );
85     
86     event onWithdraw(
87         address indexed customerAddress,
88         uint256 ethereumWithdrawn
89     );
90     event onCashDividends(
91         address indexed ownerAddress,
92         address indexed receiverAddress,
93         uint256 ethereumWithdrawn
94     );
95     event onColor(
96         address indexed customerAddress,
97         uint256 oldR,
98         uint256 oldG,
99         uint256 oldB,
100         uint256 newR,
101         uint256 newG,
102         uint256 newB
103     );
104 
105     event onTrickle(
106         address indexed fromWho,
107         address indexed finalReff,
108         uint256 reward,
109         uint256 passUp
110     );
111 
112 	// The following functions are used by the front-end for display purposes.
113 
114 
115 	// Returns the number of tokens currently held by _owner.
116 	function holdingsOf(address _owner) public constant returns (uint256 balance) {
117 		return holdings[_owner];
118 	}
119 
120 	// Withdraws all dividends held by the caller sending the transaction, updates
121 	// the requisite global variables, and transfers Ether back to the caller.
122 	function withdraw(address to) public {
123 		trickleUp(msg.sender);
124 		// Retrieve the dividends associated with the address the request came from.
125 		uint256 balance = dividends(msg.sender);
126 		//uint256 pocketBalance = tricklePocket[msg.sender];
127 		//tricklePocket[msg.sender] = 0;
128 		// Update the payouts array, incrementing the request address by `balance`.
129 		payouts[msg.sender] += (int256) (balance * scaleFactor);
130 		
131 		// Increase the total amount that's been paid out to maintain invariance.
132 		totalPayouts += (int256) (balance * scaleFactor);
133 
134 		uint256 pocketETH = pocket[msg.sender];
135 		pocket[msg.sender] = 0;
136 		trickleSum -= pocketETH;
137 
138 		balance += pocketETH;
139 		// Send the dividends to the address that requested the withdraw.
140 		withdrawSum += balance;
141 		to.transfer(balance);
142 		emit onCashDividends(msg.sender,to,balance);
143 	}
144 	function fullCycleSellBonds(uint256 balance) internal {
145 		// Send the cashed out stake to the address that requested the withdraw.
146 		withdrawSum += balance;
147 		msg.sender.transfer(balance);
148 		emit onWithdraw(msg.sender, balance);
149 	}
150 
151 
152 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
153 	// in the tokenBalance array, and therefore is shown as a dividend. A second
154 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
155 	function sellBonds(uint256 _amount) public {
156 		uint256 bondBalance = holdings[msg.sender];
157 		if(_amount <= bondBalance && _amount > 0){
158 			sell(_amount);
159 		}else{
160 			sell(bondBalance);
161 		}
162 	}
163 
164 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
165 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
166     function getMeOutOfHere() public {
167 		sellBonds( holdings[msg.sender] );
168         withdraw(msg.sender);
169 	}
170 
171 	function reffUp(address _reff) internal{
172 		address sender = msg.sender;
173 		if (_reff == 0x0000000000000000000000000000000000000000 || _reff == msg.sender){
174 			_reff = reff[sender];
175 		}
176 			
177 			
178 		if(  holdings[_reff] < stakingRequirement ){//if req not met
179 			if(lastGateway == 0x0000000000000000000000000000000000000000){
180 				lastGateway = sender;//first buyer ever
181 				_reff = sender;//first buyer is their own gateway/masternode
182 			}
183 			else
184 				_reff = lastGateway;//the lucky last player gets to be the gate way.
185 		}
186 		reff[sender] = _reff;
187 	}
188 	function rgbLimit(uint256 _rgb)internal pure returns(uint256){
189 		if(_rgb > 255)
190 			return 255;
191 		else
192 			return _rgb;
193 	}
194 	//BONUS
195 	//when you don't pick a color, the contract will need a default. which will be your current color
196 	function edgePigment(uint8 C)internal view returns (uint256 x)
197 	{	
198 		uint256 holding = holdings[msg.sender];
199 		if(holding==0)
200 			return 0;
201 		else{
202 			if(C==0){
203 				return 255 * color_R[msg.sender]/holding;
204 			}else if(C==1){
205 				return 255 * color_G[msg.sender]/holding;
206 			}else if(C==2){
207 				return 255 * color_B[msg.sender]/holding;
208 			}
209 		} 
210 	}
211 	function fund(address reffo, address forWho) payable public {
212 		fund_color( reffo, forWho, edgePigment(0),edgePigment(1),edgePigment(2) );
213 	}
214 	function fund_color( address _reff, address forWho,uint256 cR,uint256 cG,uint256 cB) payable public {
215 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
216 		reffUp(_reff);
217 		if (msg.value > 0.000001 ether){
218 			investSum += msg.value;
219 			cR=rgbLimit(cR);
220 			cG=rgbLimit(cG);
221 			cB=rgbLimit(cB);
222 		    buy( forWho ,cR,cG,cB);
223 			lastGateway = msg.sender;
224 		} else {
225 			revert();
226 		}
227     }
228 
229     function reinvest_color(address forWho,uint256 cR,uint256 cG,uint256 cB) public {
230     	cR=rgbLimit(cR);
231 		cG=rgbLimit(cG);
232 		cB=rgbLimit(cB);
233 		processReinvest( forWho, cR,cG,cB);
234 	}
235     function reinvest(address forWho) public {
236 		processReinvest( forWho, edgePigment(0),edgePigment(1),edgePigment(2) );
237 	}
238 
239 	// Function that returns the (dynamic) price of a single token.
240 	function price(bool buyOrSell) public constant returns (uint) {
241         if(buyOrSell){
242         	return getTokensForEther(1 finney);
243         }else{
244         	uint256 eth = getEtherForTokens(1 finney);
245         	uint256 fee = fluxFeed(eth, false, false);
246 	        return eth - fee;
247         }
248     }
249 
250 	function fluxFeed(uint256 _eth, bool slim_reinvest,bool newETH) public constant returns (uint256 amount) {
251 		uint256 finalInvestSum;
252 		if(newETH)
253 			finalInvestSum = investSum-_eth;//bigger buy bonus
254 		else
255 			finalInvestSum = investSum;
256 
257 		uint256 contract_ETH = finalInvestSum - withdrawSum;
258 		if(slim_reinvest){//trickleSum can never be 0, trust me
259 			return  _eth/(contract_ETH/trickleSum) *  contract_ETH /investSum;
260 		}else{
261 			return  _eth *  contract_ETH / investSum;
262 		}
263 
264 		/*
265 		Fee
266 			100eth IN & 100eth OUT = 0% tax fee (returning 1)
267 			100eth IN & 50eth OUT = 50% tax fee (returning 2)
268 			100eth IN & 33eth OUT = 66% tax fee (returning 3)
269 			100eth IN & 25eth OUT = 75% tax fee (returning 4)
270 			100eth IN & 10eth OUT = 90% tax fee (returning 10)
271 		*/
272 	}
273 
274 	// Calculate the current dividends associated with the caller address. This is the net result
275 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
276 	// Ether that has already been paid out.
277 	function dividends(address _owner) public constant returns (uint256 amount) {
278 		return (uint256) ((int256)( earningsPerBond * holdings[_owner] ) - payouts[_owner] ) / scaleFactor;
279 	}
280 
281 	// Internal balance function, used to calculate the dynamic reserve value.
282 	function contractBalance() internal constant returns (uint256 amount){
283 		// msg.value is the amount of Ether sent by the transaction.
284 		return investSum - withdrawSum - msg.value - trickleSum;
285 	}
286 				function trickleUp(address fromWho) internal{//you can trickle up other people by giving them some.
287 					uint256 tricks = tricklingPass[ fromWho ];//this is the amount moving in the trickle flo
288 					if(tricks > 0){
289 						tricklingPass[ fromWho ] = 0;//we've already captured the amount so set your tricklingPass flo to 0
290 						uint256 passUp = tricks * (investSum - withdrawSum)/investSum;//to get the amount we're gonna pass up. divide by trickTax
291 						uint256 reward = tricks-passUp;//and our remaining reward for ourselves is the amount we just slice off subtracted from the flo
292 						address finalReff;//we're not exactly sure who we're gonna pass this up to yet
293 						address reffo =  reff[ fromWho ];//this is who it should go up to. if everything is legit
294 						if( holdings[reffo] >= stakingRequirement){
295 							finalReff = reffo;//if that address is holding enough to stake, it's a legit node to flo up to.
296 						}else{
297 							finalReff = lastGateway;//if not, then we use the last buyer
298 						}
299 						tricklingPass[ finalReff ] += passUp;//so now we add that flo you've passed up to the tricklingPass of the final Reff
300 						pocket[ finalReff ] += reward;// Reward
301 						emit onTrickle(fromWho, finalReff, reward, passUp);
302 					}
303 				}
304 								function buy(address forWho,uint256 cR,uint256 cG,uint256 cB) internal {
305 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
306 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
307 										revert();	
308 									
309 									//Fee to pay existing holders, and the referral commission
310 									uint256 fee = 0; 
311 									uint256 trickle = 0; 
312 									if(holdings[forWho] != totalBondSupply){
313 										fee = fluxFeed(msg.value,false,true);
314 										trickle = fee/trickTax;
315 										fee = fee - trickle;
316 										tricklingPass[forWho] += trickle;
317 									}
318 									uint256 numEther = msg.value - (fee+trickle);// The amount of Ether used to purchase new tokens for the caller.
319 									uint256 numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
320 
321 									buyCalcAndPayout( forWho, fee, numTokens, numEther, reserve() );
322 
323 									addPigment(forWho, numTokens,cR,cG,cB);
324 								
325 									if(forWho != msg.sender){//make sure you're not yourself
326 										//if forWho doesn't have a reff or if that masternode is weak, then reset it
327 										if(reff[forWho] == 0x0000000000000000000000000000000000000000 || (holdings[reff[forWho]] < stakingRequirement) )
328 											reff[forWho] = msg.sender;
329 										
330 										emit onBoughtFor(msg.sender, forWho, numEther, numTokens, reff[forWho] );
331 									}else{
332 										emit onTokenPurchase(forWho, numEther ,numTokens , reff[forWho] );
333 									}
334 
335 									trickleSum += trickle;//add to trickle's Sum after reserve calculations
336 									trickleUp(forWho);
337 								}
338 													function buyCalcAndPayout(address forWho,uint256 fee,uint256 numTokens,uint256 numEther,uint256 res)internal{
339 														// The buyer fee, scaled by the scaleFactor variable.
340 														uint256 buyerFee = fee * scaleFactor;
341 														
342 														if (totalBondSupply > 0){// because ...
343 															// Compute the bonus co-efficient for all existing holders and the buyer.
344 															// The buyer receives part of the distribution for each token bought in the
345 															// same way they would have if they bought each token individually.
346 															uint256 bonusCoEff = (scaleFactor - (res + numEther) * numTokens * scaleFactor / ( totalBondSupply  + numTokens) / numEther)
347 									 						*(uint)(crr_d) / (uint)(crr_d-crr_n);
348 															
349 															// The total reward to be distributed amongst the masses is the fee (in Ether)
350 															// multiplied by the bonus co-efficient.
351 															uint256 holderReward = fee * bonusCoEff;
352 															
353 															buyerFee -= holderReward;
354 															
355 															// The Ether value per token is increased proportionally.
356 															earningsPerBond +=  holderReward / totalBondSupply;
357 														}
358 														//resolve reward tracking stuff
359 														avgFactor_ethSpent[forWho] += numEther;
360 
361 														// Add the numTokens which were just created to the total supply. We're a crypto central bank!
362 														totalBondSupply += numTokens;
363 														// Assign the tokens to the balance of the buyer.
364 														holdings[forWho] += numTokens;
365 														// Update the payout array so that the buyer cannot claim dividends on previous purchases.
366 														// Also include the fee paid for entering the scheme.
367 														// First we compute how much was just paid out to the buyer...
368 														int256 payoutDiff = (int256) ((earningsPerBond * numTokens) - buyerFee);
369 														// Then we update the payouts array for the buyer with this amount...
370 														payouts[forWho] += payoutDiff;
371 														
372 														// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
373 														totalPayouts += payoutDiff;
374 													}
375 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
376 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
377 								// will be *significant*.
378 								function TOKEN_scaleDown(uint256 value,uint256 reduce) internal view returns(uint256 x){
379 									uint256 holdingsOfSender = holdings[msg.sender];
380 									return value * ( holdingsOfSender - reduce) / holdingsOfSender;
381 								}
382 								function sell(uint256 amount) internal {
383 								    uint256 numEthersBeforeFee = getEtherForTokens(amount);
384 									
385 									// x% of the resulting Ether is used to pay remaining holders.
386 									uint256 fee = 0;
387 									uint256 trickle = 0;
388 									if(totalBondSupply != holdings[msg.sender]){
389 										fee = fluxFeed(numEthersBeforeFee, false,false);
390 							        	trickle = fee/ trickTax;
391 										fee -= trickle;
392 										tricklingPass[msg.sender] +=trickle;
393 									}
394 									
395 									// Net Ether for the seller after the fee has been subtracted.
396 							        uint256 numEthers = numEthersBeforeFee - (fee+trickle);
397 
398 									//How much you bought it for divided by how much you're getting back.
399 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
400 									uint256 resolved = mint(
401 										calcResolve(msg.sender,amount,numEthersBeforeFee),
402 										msg.sender
403 									);
404 
405 									// *Remove* the numTokens which were just sold from the total supply.
406 									avgFactor_ethSpent[msg.sender] = TOKEN_scaleDown(avgFactor_ethSpent[msg.sender] , amount);
407 
408 									color_R[msg.sender] = TOKEN_scaleDown(color_R[msg.sender] , amount);
409 									color_G[msg.sender] = TOKEN_scaleDown(color_G[msg.sender] , amount);
410 									color_B[msg.sender] = TOKEN_scaleDown(color_B[msg.sender] , amount);
411 									
412 									totalBondSupply -= amount;
413 									// Remove the tokens from the balance of the buyer.
414 									holdings[msg.sender] -= amount;
415 
416 									int256 payoutDiff = (int256) (earningsPerBond * amount);//we don't add in numETH because it is immedietly paid out.
417 		
418 							        // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
419 									// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
420 									// they decide to buy back in.
421 									payouts[msg.sender] -= payoutDiff;
422 									
423 									// Decrease the total amount that's been paid out to maintain invariance.
424 							        totalPayouts -= payoutDiff;
425 							        
426 
427 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
428 									// selling tokens, but it guards against division by zero).
429 									if (totalBondSupply > 0) {
430 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
431 										uint256 etherFee = fee * scaleFactor;
432 										
433 										// Fee is distributed to all remaining token holders.
434 										// rewardPerShare is the amount gained per token thanks to this sell.
435 										uint256 rewardPerShare = etherFee / totalBondSupply;
436 										
437 										// The Ether value per token is increased proportionally.
438 										earningsPerBond +=  rewardPerShare;
439 									}
440 									fullCycleSellBonds(numEthers);
441 								
442 									trickleSum += trickle;
443 									trickleUp(msg.sender);
444 									emit onTokenSell(msg.sender,holdings[msg.sender]+amount,amount,numEthers,resolved,reff[msg.sender]);
445 								}
446 
447 				// Converts the Ether accrued as dividends back into Staking tokens without having to
448 				// withdraw it first. Saves on gas and potential price spike loss.
449 				function processReinvest(address forWho,uint256 cR,uint256 cG,uint256 cB) internal{
450 					// Retrieve the dividends associated with the address the request came from.
451 					uint256 balance = dividends(msg.sender);
452 
453 					// Update the payouts array, incrementing the request address by `balance`.
454 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
455 					payouts[msg.sender] += (int256) (balance * scaleFactor);
456 					
457 					// Increase the total amount that's been paid out to maintain invariance.
458 					totalPayouts += (int256) (balance * scaleFactor);					
459 						
460 					// Assign balance to a new variable.
461 					uint256 pocketETH = pocket[msg.sender];
462 					uint value_ = (uint) (balance + pocketETH);
463 					pocket[msg.sender] = 0;
464 					
465 					// If your dividends are worth less than 1 szabo, or more than a million Ether
466 					// (in which case, why are you even here), abort.
467 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
468 						revert();
469 
470 					uint256 fee = 0; 
471 					uint256 trickle = 0;
472 					if(holdings[forWho] != totalBondSupply){
473 						fee = fluxFeed(value_, true,false );// reinvestment fees are lower than regular ones.
474 						trickle = fee/ trickTax;
475 						fee = fee - trickle;
476 						tricklingPass[forWho] += trickle;
477 					}
478 					
479 					// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
480 					// (Yes, the buyer receives a part of the distribution as well!)
481 					uint256 res = reserve() - balance;
482 
483 					// The amount of Ether used to purchase new tokens for the caller.
484 					uint256 numEther = value_ - (fee+trickle);
485 					
486 					// The number of tokens which can be purchased for numEther.
487 					uint256 numTokens = calculateDividendTokens(numEther, balance);
488 					
489 					buyCalcAndPayout( forWho, fee, numTokens, numEther, res );
490 
491 					addPigment(forWho, numTokens,cR,cG,cB);
492 					
493 
494 					if(forWho != msg.sender){//make sure you're not yourself
495 						//if forWho doesn't have a reff, then reset it
496 						address reffOfWho = reff[forWho];
497 						if(reffOfWho == 0x0000000000000000000000000000000000000000 || (holdings[reffOfWho] < stakingRequirement) )
498 							reff[forWho] = msg.sender;
499 
500 						emit onReinvestFor(msg.sender,forWho,numEther,numTokens,reff[forWho]);
501 					}else{
502 						emit onReinvestment(forWho,numEther,numTokens,reff[forWho]);	
503 					}
504 
505 					trickleUp(forWho);
506 					trickleSum += trickle - pocketETH;
507 				}
508 	
509 	function addPigment(address forWho, uint256 tokens,uint256 r,uint256 g,uint256 b) internal{
510 		color_R[forWho] += tokens * r / 255;
511 		color_G[forWho] += tokens * g / 255;
512 		color_B[forWho] += tokens * b / 255;
513 		emit onColor(forWho,r,g,b,color_R[forWho] ,color_G[forWho] ,color_B[forWho] );
514 	}
515 	// Dynamic value of Ether in reserve, according to the CRR requirement.
516 	function reserve() internal constant returns (uint256 amount){
517 		return contractBalance()-((uint256) ((int256) (earningsPerBond * totalBondSupply) - totalPayouts ) / scaleFactor);
518 	}
519 
520 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
521 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
522 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
523 		return fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff) - totalBondSupply ;
524 	}
525 
526 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
527 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
528 		return fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff) -  totalBondSupply;
529 	}
530 
531 	// Converts a number tokens into an Ether value.
532 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
533 		// How much reserve Ether do we have left in the contract?
534 		uint256 reserveAmount = reserve();
535 
536 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
537 		if (tokens == totalBondSupply )
538 			return reserveAmount;
539 
540 		// If there would be excess Ether left after the transaction this is called within, return the Ether
541 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
542 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
543 		// and denominator altered to 1 and 2 respectively.
544 		return reserveAmount - fixedExp((fixedLog(totalBondSupply  - tokens) - price_coeff) * crr_d/crr_n);
545 	}
546 
547 	function () payable public {
548 		if (msg.value > 0) {
549 			fund(lastGateway,msg.sender);
550 		} else {
551 			withdraw(msg.sender);
552 		}
553 	}
554 
555 										address public resolver = this;
556 									    uint256 public totalSupply;
557 									    uint256 constant private MAX_UINT256 = 2**256 - 1;
558 									    mapping (address => uint256) public balances;
559 									    mapping (address => mapping (address => uint256)) public allowed;
560 									    
561 									    string public name = "0xBabylon";
562 									    uint8 public decimals = 18;
563 									    string public symbol = "PoWHr";
564 									    
565 									    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
566 									    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
567 									    event Resolved(address indexed _owner, uint256 amount);
568 
569 									    function mint(uint256 amount,address _account) internal returns (uint minted){
570 									    	totalSupply += amount;
571 									    	balances[_account] += amount;
572 									    	emit Resolved(_account,amount);
573 									    	return amount;
574 									    }
575 
576 									    function balanceOf(address _owner) public view returns (uint256 balance) {
577 									        return balances[_owner];
578 									    }
579 									    
580 
581 										function calcResolve(address _owner,uint256 amount,uint256 _eth) public constant returns (uint256 calculatedResolveTokens) {
582 											return amount*amount*avgFactor_ethSpent[_owner]/holdings[_owner]/_eth/1000000;
583 										}
584 
585 
586 									    function transfer(address _to, uint256 _value) public returns (bool success) {
587 									        require( balanceOf(msg.sender) >= _value);
588 									        balances[msg.sender] -= _value;
589 									        balances[_to] += _value;
590 									        emit Transfer(msg.sender, _to, _value);
591 									        return true;
592 									    }
593 										
594 									    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
595 									        uint256 allowance = allowed[_from][msg.sender];
596 									        require(    balanceOf(_from)  >= _value && allowance >= _value );
597 									        balances[_to] += _value;
598 									        balances[_from] -= _value;
599 									        if (allowance < MAX_UINT256) {
600 									            allowed[_from][msg.sender] -= _value;
601 									        }
602 									        emit Transfer(_from, _to, _value);
603 									        return true;
604 									    }
605 
606 									    function approve(address _spender, uint256 _value) public returns (bool success) {
607 									        allowed[msg.sender][_spender] = _value;
608 									        emit Approval(msg.sender, _spender, _value);
609 									        return true;
610 									    }
611 
612 									    function resolveSupply() public view returns (uint256 balance) {
613 									        return totalSupply;
614 									    }
615 
616 									    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
617 									        return allowed[_owner][_spender];
618 									    }
619 
620     // You don't care about these, but if you really do they're hex values for 
621 	// co-efficients used to simulate approximations of the log and exp functions.
622 	int256  constant one        = 0x10000000000000000;
623 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
624 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
625 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
626 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
627 	int256  constant c1         = 0x1ffffffffff9dac9b;
628 	int256  constant c3         = 0x0aaaaaaac16877908;
629 	int256  constant c5         = 0x0666664e5e9fa0c99;
630 	int256  constant c7         = 0x049254026a7630acf;
631 	int256  constant c9         = 0x038bd75ed37753d68;
632 	int256  constant c11        = 0x03284a0c14610924f;
633 
634 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
635 	// approximates the function log(1+x)-log(1-x)
636 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
637 	function fixedLog(uint256 a) internal pure returns (int256 log) {
638 		int32 scale = 0;
639 		while (a > sqrt2) {
640 			a /= 2;
641 			scale++;
642 		}
643 		while (a <= sqrtdot5) {
644 			a *= 2;
645 			scale--;
646 		}
647 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
648 		int256 z = (s*s) / one;
649 		return scale * ln2 +
650 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
651 				/one))/one))/one))/one))/one);
652 	}
653 
654 	int256 constant c2 =  0x02aaaaaaaaa015db0;
655 	int256 constant c4 = -0x000b60b60808399d1;
656 	int256 constant c6 =  0x0000455956bccdd06;
657 	int256 constant c8 = -0x000001b893ad04b3a;
658 
659 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
660 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
661 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
662 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
663 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
664 		a -= scale*ln2;
665 		int256 z = (a*a) / one;
666 		int256 R = ((int256)(2) * one) +
667 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
668 		exp = (uint256) (((R + a) * one) / (R - a));
669 		if (scale >= 0)
670 			exp <<= scale;
671 		else
672 			exp >>= -scale;
673 		return exp;
674 	}
675 }