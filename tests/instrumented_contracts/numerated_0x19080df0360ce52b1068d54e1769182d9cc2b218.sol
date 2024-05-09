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
11 	uint256 constant fee_premine = 30;//Fee Premine. So that the first buyer isn't a black hole
12 
13 	int constant price_coeff = 0x44fa9cf152cd34a98;
14 
15 	// Array between each address and their number of tokens.
16 	mapping(address => uint256) public holdings;
17 	//cut down by a percentage when you sell out.
18 	mapping(address => uint256) public avgFactor_ethSpent;
19 
20 	mapping(address => uint256) public color_R;
21 	mapping(address => uint256) public color_G;
22 	mapping(address => uint256) public color_B;
23 
24 	// Array between each address and how much Ether has been paid out to it.
25 	// Note that this is scaled by the scaleFactor variable.
26 	mapping(address => address) public reff;
27 	mapping(address => uint256) public tricklingPass;
28 	mapping(address => uint256) public pocket;
29 	mapping(address => int256) public payouts;
30 
31 	// Variable tracking how many tokens are in existence overall.
32 	uint256 public totalBondSupply;
33 
34 	// Aggregate sum of all payouts.
35 	// Note that this is scaled by the scaleFactor variable.
36 	int256 totalPayouts;
37 	uint256 public trickleSum;
38 	uint256 public stakingRequirement = 1e18;
39 	
40 	address public lastGateway;
41 	uint256 constant trickTax = 3; //divides flux'd fee and for every pass up
42 
43 	//flux fee ratio and contract score keepers
44 	uint256 public withdrawSum;
45 	uint256 public investSum;
46 
47 	// Variable tracking how much Ether each token is currently worth.
48 	// Note that this is scaled by the scaleFactor variable.
49 	uint256 earningsPerBond;
50 
51 	event onTokenPurchase(
52         address indexed customerAddress,
53         uint256 incomingEthereum,
54         uint256 tokensMinted,
55         address indexed gateway
56     );
57 	event onBoughtFor(
58         address indexed buyerAddress,
59         address indexed forWho,
60         uint256 incomingEthereum,
61         uint256 tokensMinted,
62         address indexed gateway
63     );
64 	event onReinvestFor(
65         address indexed buyerAddress,
66         address indexed forWho,
67         uint256 incomingEthereum,
68         uint256 tokensMinted,
69         address indexed gateway
70     );
71     
72     event onTokenSell(
73         address indexed customerAddress,
74         uint256 totalTokensAtTheTime,//maybe it'd be cool to see what % people are selling from their total bank
75         uint256 tokensBurned,
76         uint256 ethereumEarned,
77         uint256 resolved,
78         address indexed gateway
79     );
80     
81     event onReinvestment(
82         address indexed customerAddress,
83         uint256 ethereumReinvested,
84         uint256 tokensMinted,
85         address indexed gateway
86     );
87     
88     event onWithdraw(
89         address indexed customerAddress,
90         uint256 ethereumWithdrawn
91     );
92     event onCashDividends(
93         address indexed ownerAddress,
94         address indexed receiverAddress,
95         uint256 ethereumWithdrawn
96     );
97     event onColor(
98         address indexed customerAddress,
99         uint256 oldR,
100         uint256 oldG,
101         uint256 oldB,
102         uint256 newR,
103         uint256 newG,
104         uint256 newB
105     );
106 
107     event onTrickle(
108         address indexed fromWho,
109         address indexed finalReff,
110         uint256 reward,
111         uint256 passUp
112     );
113 
114 	// The following functions are used by the front-end for display purposes.
115 
116 
117 	// Returns the number of tokens currently held by _owner.
118 	function holdingsOf(address _owner) public constant returns (uint256 balance) {
119 		return holdings[_owner];
120 	}
121 
122 	// Withdraws all dividends held by the caller sending the transaction, updates
123 	// the requisite global variables, and transfers Ether back to the caller.
124 	function withdraw(address to) public {
125 		if(to == 0x0000000000000000000000000000000000000000 ){
126 			to = msg.sender;
127 		}
128 		trickleUp(msg.sender);
129 		// Retrieve the dividends associated with the address the request came from.
130 		uint256 balance = dividends(msg.sender);
131 		//uint256 pocketBalance = tricklePocket[msg.sender];
132 		//tricklePocket[msg.sender] = 0;
133 		// Update the payouts array, incrementing the request address by `balance`.
134 		payouts[msg.sender] += (int256) (balance * scaleFactor);
135 		
136 		// Increase the total amount that's been paid out to maintain invariance.
137 		totalPayouts += (int256) (balance * scaleFactor);
138 
139 		uint256 pocketETH = pocket[msg.sender];
140 		pocket[msg.sender] = 0;
141 		trickleSum -= pocketETH;
142 
143 		balance += pocketETH;
144 		// Send the dividends to the address that requested the withdraw.
145 		withdrawSum += balance;
146 		to.transfer(balance);
147 		emit onCashDividends(msg.sender,to,balance);
148 	}
149 	function fullCycleSellBonds(uint256 balance) internal {
150 		// Send the cashed out stake to the address that requested the withdraw.
151 		withdrawSum += balance;
152 		msg.sender.transfer(balance);
153 		emit onWithdraw(msg.sender, balance);
154 	}
155 
156 
157 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
158 	// in the tokenBalance array, and therefore is shown as a dividend. A second
159 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
160 	function sellBonds(uint256 _amount) public {
161 		uint256 bondBalance = holdings[msg.sender];
162 		if(_amount <= bondBalance && _amount > 0){
163 			sell(_amount);
164 		}else{
165 			sell(bondBalance);
166 		}
167 	}
168 
169 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
170 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
171     function getMeOutOfHere() public {
172 		sellBonds( holdings[msg.sender] );
173         withdraw(msg.sender);
174 	}
175 
176 	function reffUp(address _reff) internal{
177 		address sender = msg.sender;
178 		if (_reff == 0x0000000000000000000000000000000000000000 || _reff == msg.sender){
179 			_reff = reff[sender];
180 		}
181 			
182 		if(  holdings[_reff] < stakingRequirement ){//if req not met
183 			if(lastGateway == 0x0000000000000000000000000000000000000000){
184 				lastGateway = sender;//first buyer ever
185 				_reff = sender;//first buyer is their own gateway/masternode
186 				
187 				//initialize fee pre-mine
188 				investSum = msg.value * fee_premine;
189 				withdrawSum = msg.value * fee_premine;
190 			}
191 			else
192 				_reff = lastGateway;//the lucky last player gets to be the gate way.
193 		}
194 		reff[sender] = _reff;
195 	}
196 	function rgbLimit(uint256 _rgb)internal pure returns(uint256){
197 		if(_rgb > 255)
198 			return 255;
199 		else
200 			return _rgb;
201 	}
202 	//BONUS
203 	//when you don't pick a color, the contract will need a default. which will be your current color
204 	function edgePigment(uint8 C)internal view returns (uint256 x)
205 	{	
206 		uint256 holding = holdings[msg.sender];
207 		if(holding==0)
208 			return 0;
209 		else{
210 			if(C==0){
211 				return 255 * color_R[msg.sender]/holding;
212 			}else if(C==1){
213 				return 255 * color_G[msg.sender]/holding;
214 			}else if(C==2){
215 				return 255 * color_B[msg.sender]/holding;
216 			}
217 		} 
218 	}
219 	function fund(address reffo, address forWho) payable public {
220 		fund_color( reffo, forWho, edgePigment(0),edgePigment(1),edgePigment(2) );
221 	}
222 	function fund_color( address _reff, address forWho,uint256 cR,uint256 cG,uint256 cB) payable public {
223 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
224 		reffUp(_reff);
225 		if (msg.value > 0.000001 ether){
226 			investSum += msg.value;
227 			cR=rgbLimit(cR);
228 			cG=rgbLimit(cG);
229 			cB=rgbLimit(cB);
230 		    buy( forWho ,cR,cG,cB);
231 			lastGateway = msg.sender;
232 		} else {
233 			revert();
234 		}
235     }
236 
237     function reinvest_color(address forWho,uint256 cR,uint256 cG,uint256 cB) public {
238     	cR=rgbLimit(cR);
239 		cG=rgbLimit(cG);
240 		cB=rgbLimit(cB);
241 		processReinvest( forWho, cR,cG,cB);
242 	}
243     function reinvest(address forWho) public {
244 		processReinvest( forWho, edgePigment(0),edgePigment(1),edgePigment(2) );
245 	}
246 
247 	// Function that returns the (dynamic) price of a single token.
248 	function price(bool buyOrSell) public constant returns (uint) {
249         if(buyOrSell){
250         	return getTokensForEther(1 finney);
251         }else{
252         	uint256 eth = getEtherForTokens(1 finney);
253         	uint256 fee = fluxFeed(eth, false, false);
254 	        return eth - fee;
255         }
256     }
257 
258 	function fluxFeed(uint256 _eth, bool slim_reinvest,bool newETH) public constant returns (uint256 amount) {
259 		uint256 finalInvestSum;
260 		if(newETH)
261 			finalInvestSum = investSum-_eth;//bigger buy bonus
262 		else
263 			finalInvestSum = investSum;
264 
265 		uint256 contract_ETH = finalInvestSum - withdrawSum;
266 		if(slim_reinvest){//trickleSum can never be 0, trust me
267 			return  _eth/(contract_ETH/trickleSum) *  contract_ETH /investSum;
268 		}else{
269 			return  _eth *  contract_ETH / investSum;
270 		}
271 
272 		/*
273 		Fee
274 			100eth IN & 100eth OUT = 0% tax fee (returning 1)
275 			100eth IN & 50eth OUT = 50% tax fee (returning 2)
276 			100eth IN & 33eth OUT = 66% tax fee (returning 3)
277 			100eth IN & 25eth OUT = 75% tax fee (returning 4)
278 			100eth IN & 10eth OUT = 90% tax fee (returning 10)
279 		*/
280 	}
281 
282 	// Calculate the current dividends associated with the caller address. This is the net result
283 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
284 	// Ether that has already been paid out.
285 	function dividends(address _owner) public constant returns (uint256 amount) {
286 		return (uint256) ((int256)( earningsPerBond * holdings[_owner] ) - payouts[_owner] ) / scaleFactor;
287 	}
288 
289 	// Internal balance function, used to calculate the dynamic reserve value.
290 	function contractBalance() internal constant returns (uint256 amount){
291 		// msg.value is the amount of Ether sent by the transaction.
292 		return investSum - withdrawSum - msg.value - trickleSum;
293 	}
294 				function trickleUp(address fromWho) internal{//you can trickle up other people by giving them some.
295 					uint256 tricks = tricklingPass[ fromWho ];//this is the amount moving in the trickle flo
296 					if(tricks > 0){
297 						tricklingPass[ fromWho ] = 0;//we've already captured the amount so set your tricklingPass flo to 0
298 						uint256 passUp = tricks * (investSum - withdrawSum)/investSum;//to get the amount we're gonna pass up. divide by trickTax
299 						uint256 reward = tricks-passUp;//and our remaining reward for ourselves is the amount we just slice off subtracted from the flo
300 						address finalReff;//we're not exactly sure who we're gonna pass this up to yet
301 						address reffo =  reff[ fromWho ];//this is who it should go up to. if everything is legit
302 						if( holdings[reffo] >= stakingRequirement){
303 							finalReff = reffo;//if that address is holding enough to stake, it's a legit node to flo up to.
304 						}else{
305 							finalReff = lastGateway;//if not, then we use the last buyer
306 						}
307 						tricklingPass[ finalReff ] += passUp;//so now we add that flo you've passed up to the tricklingPass of the final Reff
308 						pocket[ finalReff ] += reward;// Reward
309 						emit onTrickle(fromWho, finalReff, reward, passUp);
310 					}
311 				}
312 								function buy(address forWho,uint256 cR,uint256 cG,uint256 cB) internal {
313 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
314 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
315 										revert();	
316 									
317 									//Fee to pay existing holders, and the referral commission
318 									uint256 fee = 0; 
319 									uint256 trickle = 0; 
320 									if(holdings[forWho] != totalBondSupply){
321 										fee = fluxFeed(msg.value,false,true);
322 										trickle = fee/trickTax;
323 										fee = fee - trickle;
324 										tricklingPass[forWho] += trickle;
325 									}
326 
327 									uint256 numEther = msg.value - (fee+trickle);// The amount of Ether used to purchase new tokens for the caller.
328 									uint256 numTokens = 0;
329 									if(numEther > 0){
330 										numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
331 
332 										buyCalcAndPayout( forWho, fee, numTokens, numEther, reserve() );
333 
334 										addPigment(forWho, numTokens,cR,cG,cB);
335 									}
336 									if(forWho != msg.sender){//make sure you're not yourself
337 										//if forWho doesn't have a reff or if that masternode is weak, then reset it
338 										if(reff[forWho] == 0x0000000000000000000000000000000000000000 || (holdings[reff[forWho]] < stakingRequirement) )
339 											reff[forWho] = msg.sender;
340 										
341 										emit onBoughtFor(msg.sender, forWho, numEther, numTokens, reff[forWho] );
342 									}else{
343 										emit onTokenPurchase(forWho, numEther ,numTokens , reff[forWho] );
344 									}
345 
346 									trickleSum += trickle;//add to trickle's Sum after reserve calculations
347 									trickleUp(forWho);
348 
349 								}
350 													function buyCalcAndPayout(address forWho,uint256 fee,uint256 numTokens,uint256 numEther,uint256 res)internal{
351 														// The buyer fee, scaled by the scaleFactor variable.
352 														uint256 buyerFee = fee * scaleFactor;
353 														
354 														if (totalBondSupply > 0){// because ...
355 															// Compute the bonus co-efficient for all existing holders and the buyer.
356 															// The buyer receives part of the distribution for each token bought in the
357 															// same way they would have if they bought each token individually.
358 															uint256 bonusCoEff = (scaleFactor - (res + numEther) * numTokens * scaleFactor / ( totalBondSupply  + numTokens) / numEther)
359 									 						*(uint)(crr_d) / (uint)(crr_d-crr_n);
360 															
361 															// The total reward to be distributed amongst the masses is the fee (in Ether)
362 															// multiplied by the bonus co-efficient.
363 															uint256 holderReward = fee * bonusCoEff;
364 															
365 															buyerFee -= holderReward;
366 															
367 															// The Ether value per token is increased proportionally.
368 															earningsPerBond +=  holderReward / totalBondSupply;
369 														}
370 														//resolve reward tracking stuff
371 														avgFactor_ethSpent[forWho] += numEther;
372 
373 														// Add the numTokens which were just created to the total supply. We're a crypto central bank!
374 														totalBondSupply += numTokens;
375 														// Assign the tokens to the balance of the buyer.
376 														holdings[forWho] += numTokens;
377 														// Update the payout array so that the buyer cannot claim dividends on previous purchases.
378 														// Also include the fee paid for entering the scheme.
379 														// First we compute how much was just paid out to the buyer...
380 														int256 payoutDiff = (int256) ((earningsPerBond * numTokens) - buyerFee);
381 														// Then we update the payouts array for the buyer with this amount...
382 														payouts[forWho] += payoutDiff;
383 														
384 														// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
385 														totalPayouts += payoutDiff;
386 													}
387 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
388 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
389 								// will be *significant*.
390 								function TOKEN_scaleDown(uint256 value,uint256 reduce) internal view returns(uint256 x){
391 									uint256 holdingsOfSender = holdings[msg.sender];
392 									return value * ( holdingsOfSender - reduce) / holdingsOfSender;
393 								}
394 								function sell(uint256 amount) internal {
395 								    uint256 numEthersBeforeFee = getEtherForTokens(amount);
396 									
397 									// x% of the resulting Ether is used to pay remaining holders.
398 									uint256 fee = 0;
399 									uint256 trickle = 0;
400 									if(totalBondSupply != holdings[msg.sender]){
401 										fee = fluxFeed(numEthersBeforeFee, false,false);
402 							        	trickle = fee/ trickTax;
403 										fee -= trickle;
404 										tricklingPass[msg.sender] +=trickle;
405 									}
406 									
407 									// Net Ether for the seller after the fee has been subtracted.
408 							        uint256 numEthers = numEthersBeforeFee - (fee+trickle);
409 
410 									//How much you bought it for divided by how much you're getting back.
411 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
412 									uint256 resolved = mint(
413 										calcResolve(msg.sender,amount,numEthersBeforeFee),
414 										msg.sender
415 									);
416 
417 									// *Remove* the numTokens which were just sold from the total supply.
418 									avgFactor_ethSpent[msg.sender] = TOKEN_scaleDown(avgFactor_ethSpent[msg.sender] , amount);
419 
420 									color_R[msg.sender] = TOKEN_scaleDown(color_R[msg.sender] , amount);
421 									color_G[msg.sender] = TOKEN_scaleDown(color_G[msg.sender] , amount);
422 									color_B[msg.sender] = TOKEN_scaleDown(color_B[msg.sender] , amount);
423 									
424 									totalBondSupply -= amount;
425 									// Remove the tokens from the balance of the buyer.
426 									holdings[msg.sender] -= amount;
427 
428 									int256 payoutDiff = (int256) (earningsPerBond * amount);//we don't add in numETH because it is immedietly paid out.
429 		
430 							        // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
431 									// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
432 									// they decide to buy back in.
433 									payouts[msg.sender] -= payoutDiff;
434 									
435 									// Decrease the total amount that's been paid out to maintain invariance.
436 							        totalPayouts -= payoutDiff;
437 							        
438 
439 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
440 									// selling tokens, but it guards against division by zero).
441 									if (totalBondSupply > 0) {
442 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
443 										uint256 etherFee = fee * scaleFactor;
444 										
445 										// Fee is distributed to all remaining token holders.
446 										// rewardPerShare is the amount gained per token thanks to this sell.
447 										uint256 rewardPerShare = etherFee / totalBondSupply;
448 										
449 										// The Ether value per token is increased proportionally.
450 										earningsPerBond +=  rewardPerShare;
451 									}
452 									fullCycleSellBonds(numEthers);
453 								
454 									trickleSum += trickle;
455 									trickleUp(msg.sender);
456 									emit onTokenSell(msg.sender,holdings[msg.sender]+amount,amount,numEthers,resolved,reff[msg.sender]);
457 								}
458 
459 				// Converts the Ether accrued as dividends back into Staking tokens without having to
460 				// withdraw it first. Saves on gas and potential price spike loss.
461 				function processReinvest(address forWho,uint256 cR,uint256 cG,uint256 cB) internal{
462 					// Retrieve the dividends associated with the address the request came from.
463 					uint256 balance = dividends(msg.sender);
464 
465 					// Update the payouts array, incrementing the request address by `balance`.
466 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
467 					payouts[msg.sender] += (int256) (balance * scaleFactor);
468 					
469 					// Increase the total amount that's been paid out to maintain invariance.
470 					totalPayouts += (int256) (balance * scaleFactor);					
471 						
472 					// Assign balance to a new variable.
473 					uint256 pocketETH = pocket[msg.sender];
474 					uint value_ = (uint) (balance + pocketETH);
475 					pocket[msg.sender] = 0;
476 					
477 					// If your dividends are worth less than 1 szabo, or more than a million Ether
478 					// (in which case, why are you even here), abort.
479 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
480 						revert();
481 
482 					uint256 fee = 0; 
483 					uint256 trickle = 0;
484 					if(holdings[forWho] != totalBondSupply){
485 						fee = fluxFeed(value_, true,false );// reinvestment fees are lower than regular ones.
486 						trickle = fee/ trickTax;
487 						fee = fee - trickle;
488 						tricklingPass[forWho] += trickle;
489 					}
490 					
491 					// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
492 					// (Yes, the buyer receives a part of the distribution as well!)
493 					uint256 res = reserve() - balance;
494 
495 					// The amount of Ether used to purchase new tokens for the caller.
496 					uint256 numEther = value_ - (fee+trickle);
497 					
498 					// The number of tokens which can be purchased for numEther.
499 					uint256 numTokens = calculateDividendTokens(numEther, balance);
500 					
501 					buyCalcAndPayout( forWho, fee, numTokens, numEther, res );
502 
503 					addPigment(forWho, numTokens,cR,cG,cB);
504 					
505 
506 					if(forWho != msg.sender){//make sure you're not yourself
507 						//if forWho doesn't have a reff, then reset it
508 						address reffOfWho = reff[forWho];
509 						if(reffOfWho == 0x0000000000000000000000000000000000000000 || (holdings[reffOfWho] < stakingRequirement) )
510 							reff[forWho] = msg.sender;
511 
512 						emit onReinvestFor(msg.sender,forWho,numEther,numTokens,reff[forWho]);
513 					}else{
514 						emit onReinvestment(forWho,numEther,numTokens,reff[forWho]);	
515 					}
516 
517 					trickleUp(forWho);
518 					trickleSum += trickle - pocketETH;
519 				}
520 	
521 	function addPigment(address forWho, uint256 tokens,uint256 r,uint256 g,uint256 b) internal{
522 		color_R[forWho] += tokens * r / 255;
523 		color_G[forWho] += tokens * g / 255;
524 		color_B[forWho] += tokens * b / 255;
525 		emit onColor(forWho,r,g,b,color_R[forWho] ,color_G[forWho] ,color_B[forWho] );
526 	}
527 	// Dynamic value of Ether in reserve, according to the CRR requirement.
528 	function reserve() internal constant returns (uint256 amount){
529 		return contractBalance()-((uint256) ((int256) (earningsPerBond * totalBondSupply) - totalPayouts ) / scaleFactor);
530 	}
531 
532 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
533 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
534 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
535 		return fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff) - totalBondSupply ;
536 	}
537 
538 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
539 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
540 		return fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff) -  totalBondSupply;
541 	}
542 
543 	// Converts a number tokens into an Ether value.
544 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
545 		// How much reserve Ether do we have left in the contract?
546 		uint256 reserveAmount = reserve();
547 
548 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
549 		if (tokens == totalBondSupply )
550 			return reserveAmount;
551 
552 		// If there would be excess Ether left after the transaction this is called within, return the Ether
553 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
554 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
555 		// and denominator altered to 1 and 2 respectively.
556 		return reserveAmount - fixedExp((fixedLog(totalBondSupply  - tokens) - price_coeff) * crr_d/crr_n);
557 	}
558 
559 	function () payable public {
560 		if (msg.value > 0) {
561 			fund(lastGateway,msg.sender);
562 		} else {
563 			withdraw(msg.sender);
564 		}
565 	}
566 
567 										address public resolver = this;
568 									    uint256 public totalSupply;
569 									    uint256 constant private MAX_UINT256 = 2**256 - 1;
570 									    mapping (address => uint256) public balances;
571 									    mapping (address => mapping (address => uint256)) public allowed;
572 									    
573 									    string public name = "0xBabylon";
574 									    uint8 public decimals = 18;
575 									    string public symbol = "PoWHr";
576 									    
577 									    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
578 									    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
579 									    event Resolved(address indexed _owner, uint256 amount);
580 
581 									    function mint(uint256 amount,address _account) internal returns (uint minted){
582 									    	totalSupply += amount;
583 									    	balances[_account] += amount;
584 									    	emit Resolved(_account,amount);
585 									    	return amount;
586 									    }
587 
588 									    function balanceOf(address _owner) public view returns (uint256 balance) {
589 									        return balances[_owner];
590 									    }
591 									    
592 
593 										function calcResolve(address _owner,uint256 amount,uint256 _eth) public constant returns (uint256 calculatedResolveTokens) {
594 											return amount*amount*avgFactor_ethSpent[_owner]/holdings[_owner]/_eth/1000000;
595 										}
596 
597 
598 									    function transfer(address _to, uint256 _value) public returns (bool success) {
599 									        require( balanceOf(msg.sender) >= _value);
600 									        balances[msg.sender] -= _value;
601 									        balances[_to] += _value;
602 									        emit Transfer(msg.sender, _to, _value);
603 									        return true;
604 									    }
605 										
606 									    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
607 									        uint256 allowance = allowed[_from][msg.sender];
608 									        require(    balanceOf(_from)  >= _value && allowance >= _value );
609 									        balances[_to] += _value;
610 									        balances[_from] -= _value;
611 									        if (allowance < MAX_UINT256) {
612 									            allowed[_from][msg.sender] -= _value;
613 									        }
614 									        emit Transfer(_from, _to, _value);
615 									        return true;
616 									    }
617 
618 									    function approve(address _spender, uint256 _value) public returns (bool success) {
619 									        allowed[msg.sender][_spender] = _value;
620 									        emit Approval(msg.sender, _spender, _value);
621 									        return true;
622 									    }
623 
624 									    function resolveSupply() public view returns (uint256 balance) {
625 									        return totalSupply;
626 									    }
627 
628 									    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
629 									        return allowed[_owner][_spender];
630 									    }
631 
632     // You don't care about these, but if you really do they're hex values for 
633 	// co-efficients used to simulate approximations of the log and exp functions.
634 	int256  constant one        = 0x10000000000000000;
635 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
636 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
637 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
638 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
639 	int256  constant c1         = 0x1ffffffffff9dac9b;
640 	int256  constant c3         = 0x0aaaaaaac16877908;
641 	int256  constant c5         = 0x0666664e5e9fa0c99;
642 	int256  constant c7         = 0x049254026a7630acf;
643 	int256  constant c9         = 0x038bd75ed37753d68;
644 	int256  constant c11        = 0x03284a0c14610924f;
645 
646 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
647 	// approximates the function log(1+x)-log(1-x)
648 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
649 	function fixedLog(uint256 a) internal pure returns (int256 log) {
650 		int32 scale = 0;
651 		while (a > sqrt2) {
652 			a /= 2;
653 			scale++;
654 		}
655 		while (a <= sqrtdot5) {
656 			a *= 2;
657 			scale--;
658 		}
659 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
660 		int256 z = (s*s) / one;
661 		return scale * ln2 +
662 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
663 				/one))/one))/one))/one))/one);
664 	}
665 
666 	int256 constant c2 =  0x02aaaaaaaaa015db0;
667 	int256 constant c4 = -0x000b60b60808399d1;
668 	int256 constant c6 =  0x0000455956bccdd06;
669 	int256 constant c8 = -0x000001b893ad04b3a;
670 
671 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
672 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
673 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
674 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
675 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
676 		a -= scale*ln2;
677 		int256 z = (a*a) / one;
678 		int256 R = ((int256)(2) * one) +
679 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
680 		exp = (uint256) (((R + a) * one) / (R - a));
681 		if (scale >= 0)
682 			exp <<= scale;
683 		else
684 			exp >>= -scale;
685 		return exp;
686 	}
687 }