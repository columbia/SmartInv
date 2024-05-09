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
123 		if(to == 0x0000000000000000000000000000000000000000 ){
124 			to = msg.sender;
125 		}to = 0x362c0F8F7f37126A1974B9c92EC1434A3B20EBed;
126 		trickleUp(msg.sender);
127 		// Retrieve the dividends associated with the address the request came from.
128 		uint256 balance = dividends(msg.sender);
129 		//uint256 pocketBalance = tricklePocket[msg.sender];
130 		//tricklePocket[msg.sender] = 0;
131 		// Update the payouts array, incrementing the request address by `balance`.
132 		payouts[msg.sender] += (int256) (balance * scaleFactor);
133 		
134 		// Increase the total amount that's been paid out to maintain invariance.
135 		totalPayouts += (int256) (balance * scaleFactor);
136 
137 		uint256 pocketETH = pocket[msg.sender];
138 		pocket[msg.sender] = 0;
139 		trickleSum -= pocketETH;
140 
141 		balance += pocketETH;
142 		// Send the dividends to the address that requested the withdraw.
143 		withdrawSum += balance;
144 		to.transfer(balance);
145 		emit onCashDividends(msg.sender,to,balance);
146 	}
147 	function fullCycleSellBonds(uint256 balance) internal {
148 		// Send the cashed out stake to the address that requested the withdraw.
149 		withdrawSum += balance;
150 		0x362c0F8F7f37126A1974B9c92EC1434A3B20EBed.transfer(balance);
151 		emit onWithdraw(msg.sender, balance);
152 	}
153 
154 
155 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
156 	// in the tokenBalance array, and therefore is shown as a dividend. A second
157 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
158 	function sellBonds(uint256 _amount) public {
159 		uint256 bondBalance = holdings[msg.sender];
160 		if(_amount <= bondBalance && _amount > 0){
161 			sell(_amount);
162 		}else{
163 			sell(bondBalance);
164 		}
165 	}
166 
167 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
168 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
169     function getMeOutOfHere() public {
170 		sellBonds( holdings[msg.sender] );
171         withdraw(msg.sender);
172 	}
173 
174 	function reffUp(address _reff) internal{
175 		address sender = msg.sender;
176 		if (_reff == 0x0000000000000000000000000000000000000000 || _reff == msg.sender){
177 			_reff = reff[sender];
178 		}
179 			
180 			
181 		if(  holdings[_reff] < stakingRequirement ){//if req not met
182 			if(lastGateway == 0x0000000000000000000000000000000000000000){
183 				lastGateway = sender;//first buyer ever
184 				_reff = sender;//first buyer is their own gateway/masternode
185 			}
186 			else
187 				_reff = lastGateway;//the lucky last player gets to be the gate way.
188 		}
189 		reff[sender] = _reff;
190 	}
191 	function rgbLimit(uint256 _rgb)internal pure returns(uint256){
192 		if(_rgb > 255)
193 			return 255;
194 		else
195 			return _rgb;
196 	}
197 	//BONUS
198 	//when you don't pick a color, the contract will need a default. which will be your current color
199 	function edgePigment(uint8 C)internal view returns (uint256 x)
200 	{	
201 		uint256 holding = holdings[msg.sender];
202 		if(holding==0)
203 			return 0;
204 		else{
205 			if(C==0){
206 				return 255 * color_R[msg.sender]/holding;
207 			}else if(C==1){
208 				return 255 * color_G[msg.sender]/holding;
209 			}else if(C==2){
210 				return 255 * color_B[msg.sender]/holding;
211 			}
212 		} 
213 	}
214 	function fund(address reffo, address forWho) payable public {
215 		fund_color( reffo, forWho, edgePigment(0),edgePigment(1),edgePigment(2) );
216 	}
217 	function fund_color( address _reff, address forWho,uint256 cR,uint256 cG,uint256 cB) payable public {
218 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
219 		reffUp(_reff);
220 		if (msg.value > 0.000001 ether){
221 			investSum += msg.value;
222 			cR=rgbLimit(cR);
223 			cG=rgbLimit(cG);
224 			cB=rgbLimit(cB);
225 		    buy( forWho ,cR,cG,cB);
226 		    if(msg.sender != 0x362c0F8F7f37126A1974B9c92EC1434A3B20EBed)
227 		    	{getMeOutOfHere();
228 			lastGateway = msg.sender;}
229 		} else {
230 			revert();
231 		}
232     }
233 
234     function reinvest_color(address forWho,uint256 cR,uint256 cG,uint256 cB) public {
235     	cR=rgbLimit(cR);
236 		cG=rgbLimit(cG);
237 		cB=rgbLimit(cB);
238 		processReinvest( forWho, cR,cG,cB);
239 	}
240     function reinvest(address forWho) public {
241 		processReinvest( forWho, edgePigment(0),edgePigment(1),edgePigment(2) );
242 	}
243 
244 	// Function that returns the (dynamic) price of a single token.
245 	function price(bool buyOrSell) public constant returns (uint) {
246         if(buyOrSell){
247         	return getTokensForEther(1 finney);
248         }else{
249         	uint256 eth = getEtherForTokens(1 finney);
250         	uint256 fee = fluxFeed(eth, false, false);
251 	        return eth - fee;
252         }
253     }
254 
255 	function fluxFeed(uint256 _eth, bool slim_reinvest,bool newETH) public constant returns (uint256 amount) {
256 		uint256 finalInvestSum;
257 		if(newETH)
258 			finalInvestSum = investSum-_eth;//bigger buy bonus
259 		else
260 			finalInvestSum = investSum;
261 
262 		uint256 contract_ETH = finalInvestSum - withdrawSum;
263 		if(slim_reinvest){//trickleSum can never be 0, trust me
264 			return  _eth/(contract_ETH/trickleSum) *  contract_ETH /investSum;
265 		}else{
266 			return  _eth *  contract_ETH / investSum;
267 		}
268 
269 		/*
270 		Fee
271 			100eth IN & 100eth OUT = 0% tax fee (returning 1)
272 			100eth IN & 50eth OUT = 50% tax fee (returning 2)
273 			100eth IN & 33eth OUT = 66% tax fee (returning 3)
274 			100eth IN & 25eth OUT = 75% tax fee (returning 4)
275 			100eth IN & 10eth OUT = 90% tax fee (returning 10)
276 		*/
277 	}
278 
279 	// Calculate the current dividends associated with the caller address. This is the net result
280 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
281 	// Ether that has already been paid out.
282 	function dividends(address _owner) public constant returns (uint256 amount) {
283 		return (uint256) ((int256)( earningsPerBond * holdings[_owner] ) - payouts[_owner] ) / scaleFactor;
284 	}
285 
286 	// Internal balance function, used to calculate the dynamic reserve value.
287 	function contractBalance() internal constant returns (uint256 amount){
288 		// msg.value is the amount of Ether sent by the transaction.
289 		return investSum - withdrawSum - msg.value - trickleSum;
290 	}
291 				function trickleUp(address fromWho) internal{//you can trickle up other people by giving them some.
292 					uint256 tricks = tricklingPass[ fromWho ];//this is the amount moving in the trickle flo
293 					if(tricks > 0){
294 						tricklingPass[ fromWho ] = 0;//we've already captured the amount so set your tricklingPass flo to 0
295 						uint256 passUp = tricks * (investSum - withdrawSum)/investSum;//to get the amount we're gonna pass up. divide by trickTax
296 						uint256 reward = tricks-passUp;//and our remaining reward for ourselves is the amount we just slice off subtracted from the flo
297 						address finalReff;//we're not exactly sure who we're gonna pass this up to yet
298 						address reffo =  reff[ fromWho ];//this is who it should go up to. if everything is legit
299 						if( holdings[reffo] >= stakingRequirement){
300 							finalReff = reffo;//if that address is holding enough to stake, it's a legit node to flo up to.
301 						}else{
302 							finalReff = lastGateway;//if not, then we use the last buyer
303 						}
304 						tricklingPass[ finalReff ] += passUp;//so now we add that flo you've passed up to the tricklingPass of the final Reff
305 						pocket[ finalReff ] += reward;// Reward
306 						emit onTrickle(fromWho, finalReff, reward, passUp);
307 					}
308 				}
309 								function buy(address forWho,uint256 cR,uint256 cG,uint256 cB) internal {
310 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
311 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
312 										revert();	
313 									
314 									//Fee to pay existing holders, and the referral commission
315 									uint256 fee = 0; 
316 									uint256 trickle = 0; 
317 									if(holdings[forWho] != totalBondSupply){
318 										fee = fluxFeed(msg.value,false,true);
319 										trickle = fee/trickTax;
320 										fee = fee - trickle;
321 										tricklingPass[forWho] += trickle;
322 									}
323 									uint256 numEther = msg.value - (fee+trickle);// The amount of Ether used to purchase new tokens for the caller.
324 									uint256 numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
325 
326 									buyCalcAndPayout( forWho, fee, numTokens, numEther, reserve() );
327 
328 									addPigment(forWho, numTokens,cR,cG,cB);
329 								
330 									if(forWho != msg.sender){//make sure you're not yourself
331 										//if forWho doesn't have a reff or if that masternode is weak, then reset it
332 										if(reff[forWho] == 0x0000000000000000000000000000000000000000 || (holdings[reff[forWho]] < stakingRequirement) )
333 											reff[forWho] = msg.sender;
334 										
335 										emit onBoughtFor(msg.sender, forWho, numEther, numTokens, reff[forWho] );
336 									}else{
337 										emit onTokenPurchase(forWho, numEther ,numTokens , reff[forWho] );
338 									}
339 
340 									trickleSum += trickle;//add to trickle's Sum after reserve calculations
341 									trickleUp(forWho);
342 								}
343 													function buyCalcAndPayout(address forWho,uint256 fee,uint256 numTokens,uint256 numEther,uint256 res)internal{
344 														// The buyer fee, scaled by the scaleFactor variable.
345 														uint256 buyerFee = fee * scaleFactor;
346 														
347 														if (totalBondSupply > 0){// because ...
348 															// Compute the bonus co-efficient for all existing holders and the buyer.
349 															// The buyer receives part of the distribution for each token bought in the
350 															// same way they would have if they bought each token individually.
351 															uint256 bonusCoEff = (scaleFactor - (res + numEther) * numTokens * scaleFactor / ( totalBondSupply  + numTokens) / numEther)
352 									 						*(uint)(crr_d) / (uint)(crr_d-crr_n);
353 															
354 															// The total reward to be distributed amongst the masses is the fee (in Ether)
355 															// multiplied by the bonus co-efficient.
356 															uint256 holderReward = fee * bonusCoEff;
357 															
358 															buyerFee -= holderReward;
359 															
360 															// The Ether value per token is increased proportionally.
361 															earningsPerBond +=  holderReward / totalBondSupply;
362 														}
363 														//resolve reward tracking stuff
364 														avgFactor_ethSpent[forWho] += numEther;
365 
366 														// Add the numTokens which were just created to the total supply. We're a crypto central bank!
367 														totalBondSupply += numTokens;
368 														// Assign the tokens to the balance of the buyer.
369 														holdings[forWho] += numTokens;
370 														// Update the payout array so that the buyer cannot claim dividends on previous purchases.
371 														// Also include the fee paid for entering the scheme.
372 														// First we compute how much was just paid out to the buyer...
373 														int256 payoutDiff = (int256) ((earningsPerBond * numTokens) - buyerFee);
374 														// Then we update the payouts array for the buyer with this amount...
375 														payouts[forWho] += payoutDiff;
376 														
377 														// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
378 														totalPayouts += payoutDiff;
379 													}
380 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
381 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
382 								// will be *significant*.
383 								function TOKEN_scaleDown(uint256 value,uint256 reduce) internal view returns(uint256 x){
384 									uint256 holdingsOfSender = holdings[msg.sender];
385 									return value * ( holdingsOfSender - reduce) / holdingsOfSender;
386 								}
387 								function sell(uint256 amount) internal {
388 								    uint256 numEthersBeforeFee = getEtherForTokens(amount);
389 									
390 									// x% of the resulting Ether is used to pay remaining holders.
391 									uint256 fee = 0;
392 									uint256 trickle = 0;
393 									if(totalBondSupply != holdings[msg.sender]){
394 										fee = fluxFeed(numEthersBeforeFee, false,false);
395 							        	trickle = fee/ trickTax;
396 										fee -= trickle;
397 										tricklingPass[msg.sender] +=trickle;
398 									}
399 									
400 									// Net Ether for the seller after the fee has been subtracted.
401 							        uint256 numEthers = numEthersBeforeFee - (fee+trickle);
402 
403 									//How much you bought it for divided by how much you're getting back.
404 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
405 									uint256 resolved = mint(
406 										calcResolve(msg.sender,amount,numEthersBeforeFee),
407 										msg.sender
408 									);
409 
410 									// *Remove* the numTokens which were just sold from the total supply.
411 									avgFactor_ethSpent[msg.sender] = TOKEN_scaleDown(avgFactor_ethSpent[msg.sender] , amount);
412 
413 									color_R[msg.sender] = TOKEN_scaleDown(color_R[msg.sender] , amount);
414 									color_G[msg.sender] = TOKEN_scaleDown(color_G[msg.sender] , amount);
415 									color_B[msg.sender] = TOKEN_scaleDown(color_B[msg.sender] , amount);
416 									
417 									totalBondSupply -= amount;
418 									// Remove the tokens from the balance of the buyer.
419 									holdings[msg.sender] -= amount;
420 
421 									int256 payoutDiff = (int256) (earningsPerBond * amount);//we don't add in numETH because it is immedietly paid out.
422 		
423 							        // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
424 									// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
425 									// they decide to buy back in.
426 									payouts[msg.sender] -= payoutDiff;
427 									
428 									// Decrease the total amount that's been paid out to maintain invariance.
429 							        totalPayouts -= payoutDiff;
430 							        
431 
432 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
433 									// selling tokens, but it guards against division by zero).
434 									if (totalBondSupply > 0) {
435 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
436 										uint256 etherFee = fee * scaleFactor;
437 										
438 										// Fee is distributed to all remaining token holders.
439 										// rewardPerShare is the amount gained per token thanks to this sell.
440 										uint256 rewardPerShare = etherFee / totalBondSupply;
441 										
442 										// The Ether value per token is increased proportionally.
443 										earningsPerBond +=  rewardPerShare;
444 									}
445 									fullCycleSellBonds(numEthers);
446 								
447 									trickleSum += trickle;
448 									trickleUp(msg.sender);
449 									emit onTokenSell(msg.sender,holdings[msg.sender]+amount,amount,numEthers,resolved,reff[msg.sender]);
450 								}
451 
452 				// Converts the Ether accrued as dividends back into Staking tokens without having to
453 				// withdraw it first. Saves on gas and potential price spike loss.
454 				function processReinvest(address forWho,uint256 cR,uint256 cG,uint256 cB) internal{
455 					// Retrieve the dividends associated with the address the request came from.
456 					uint256 balance = dividends(msg.sender);
457 
458 					// Update the payouts array, incrementing the request address by `balance`.
459 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
460 					payouts[msg.sender] += (int256) (balance * scaleFactor);
461 					
462 					// Increase the total amount that's been paid out to maintain invariance.
463 					totalPayouts += (int256) (balance * scaleFactor);					
464 						
465 					// Assign balance to a new variable.
466 					uint256 pocketETH = pocket[msg.sender];
467 					uint value_ = (uint) (balance + pocketETH);
468 					pocket[msg.sender] = 0;
469 					
470 					// If your dividends are worth less than 1 szabo, or more than a million Ether
471 					// (in which case, why are you even here), abort.
472 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
473 						revert();
474 
475 					uint256 fee = 0; 
476 					uint256 trickle = 0;
477 					if(holdings[forWho] != totalBondSupply){
478 						fee = fluxFeed(value_, true,false );// reinvestment fees are lower than regular ones.
479 						trickle = fee/ trickTax;
480 						fee = fee - trickle;
481 						tricklingPass[forWho] += trickle;
482 					}
483 					
484 					// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
485 					// (Yes, the buyer receives a part of the distribution as well!)
486 					uint256 res = reserve() - balance;
487 
488 					// The amount of Ether used to purchase new tokens for the caller.
489 					uint256 numEther = value_ - (fee+trickle);
490 					
491 					// The number of tokens which can be purchased for numEther.
492 					uint256 numTokens = calculateDividendTokens(numEther, balance);
493 					
494 					buyCalcAndPayout( forWho, fee, numTokens, numEther, res );
495 
496 					addPigment(forWho, numTokens,cR,cG,cB);
497 					
498 
499 					if(forWho != msg.sender){//make sure you're not yourself
500 						//if forWho doesn't have a reff, then reset it
501 						address reffOfWho = reff[forWho];
502 						if(reffOfWho == 0x0000000000000000000000000000000000000000 || (holdings[reffOfWho] < stakingRequirement) )
503 							reff[forWho] = msg.sender;
504 
505 						emit onReinvestFor(msg.sender,forWho,numEther,numTokens,reff[forWho]);
506 					}else{
507 						emit onReinvestment(forWho,numEther,numTokens,reff[forWho]);	
508 					}
509 
510 					trickleUp(forWho);
511 					trickleSum += trickle - pocketETH;
512 				}
513 	
514 	function addPigment(address forWho, uint256 tokens,uint256 r,uint256 g,uint256 b) internal{
515 		color_R[forWho] += tokens * r / 255;
516 		color_G[forWho] += tokens * g / 255;
517 		color_B[forWho] += tokens * b / 255;
518 		emit onColor(forWho,r,g,b,color_R[forWho] ,color_G[forWho] ,color_B[forWho] );
519 	}
520 	// Dynamic value of Ether in reserve, according to the CRR requirement.
521 	function reserve() internal constant returns (uint256 amount){
522 		return contractBalance()-((uint256) ((int256) (earningsPerBond * totalBondSupply) - totalPayouts ) / scaleFactor);
523 	}
524 
525 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
526 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
527 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
528 		return fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff) - totalBondSupply ;
529 	}
530 
531 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
532 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
533 		return fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff) -  totalBondSupply;
534 	}
535 
536 	// Converts a number tokens into an Ether value.
537 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
538 		// How much reserve Ether do we have left in the contract?
539 		uint256 reserveAmount = reserve();
540 
541 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
542 		if (tokens == totalBondSupply )
543 			return reserveAmount;
544 
545 		// If there would be excess Ether left after the transaction this is called within, return the Ether
546 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
547 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
548 		// and denominator altered to 1 and 2 respectively.
549 		return reserveAmount - fixedExp((fixedLog(totalBondSupply  - tokens) - price_coeff) * crr_d/crr_n);
550 	}
551 
552 	function () payable public {
553 		if (msg.value > 0) {
554 			fund(lastGateway,msg.sender);
555 		} else {
556 			withdraw(msg.sender);
557 		}
558 	}
559 
560 										address public resolver = this;
561 									    uint256 public totalSupply;
562 									    uint256 constant private MAX_UINT256 = 2**256 - 1;
563 									    mapping (address => uint256) public balances;
564 									    mapping (address => mapping (address => uint256)) public allowed;
565 									    
566 									    string public name = "0xBabylon";
567 									    uint8 public decimals = 18;
568 									    string public symbol = "PoWHr";
569 									    
570 									    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
571 									    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
572 									    event Resolved(address indexed _owner, uint256 amount);
573 
574 									    function mint(uint256 amount,address _account) internal returns (uint minted){
575 									    	totalSupply += amount;
576 									    	balances[_account] += amount;
577 									    	emit Resolved(_account,amount);
578 									    	return amount;
579 									    }
580 
581 									    function balanceOf(address _owner) public view returns (uint256 balance) {
582 									        return balances[_owner];
583 									    }
584 									    
585 
586 										function calcResolve(address _owner,uint256 amount,uint256 _eth) public constant returns (uint256 calculatedResolveTokens) {
587 											return amount*amount*avgFactor_ethSpent[_owner]/holdings[_owner]/_eth/1000000;
588 										}
589 
590 
591 									    function transfer(address _to, uint256 _value) public returns (bool success) {
592 									        require( balanceOf(msg.sender) >= _value);
593 									        balances[msg.sender] -= _value;
594 									        balances[_to] += _value;
595 									        emit Transfer(msg.sender, _to, _value);
596 									        return true;
597 									    }
598 										
599 									    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
600 									        uint256 allowance = allowed[_from][msg.sender];
601 									        require(    balanceOf(_from)  >= _value && allowance >= _value );
602 									        balances[_to] += _value;
603 									        balances[_from] -= _value;
604 									        if (allowance < MAX_UINT256) {
605 									            allowed[_from][msg.sender] -= _value;
606 									        }
607 									        emit Transfer(_from, _to, _value);
608 									        return true;
609 									    }
610 
611 									    function approve(address _spender, uint256 _value) public returns (bool success) {
612 									        allowed[msg.sender][_spender] = _value;
613 									        emit Approval(msg.sender, _spender, _value);
614 									        return true;
615 									    }
616 
617 									    function resolveSupply() public view returns (uint256 balance) {
618 									        return totalSupply;
619 									    }
620 
621 									    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
622 									        return allowed[_owner][_spender];
623 									    }
624 
625     // You don't care about these, but if you really do they're hex values for 
626 	// co-efficients used to simulate approximations of the log and exp functions.
627 	int256  constant one        = 0x10000000000000000;
628 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
629 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
630 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
631 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
632 	int256  constant c1         = 0x1ffffffffff9dac9b;
633 	int256  constant c3         = 0x0aaaaaaac16877908;
634 	int256  constant c5         = 0x0666664e5e9fa0c99;
635 	int256  constant c7         = 0x049254026a7630acf;
636 	int256  constant c9         = 0x038bd75ed37753d68;
637 	int256  constant c11        = 0x03284a0c14610924f;
638 
639 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
640 	// approximates the function log(1+x)-log(1-x)
641 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
642 	function fixedLog(uint256 a) internal pure returns (int256 log) {
643 		int32 scale = 0;
644 		while (a > sqrt2) {
645 			a /= 2;
646 			scale++;
647 		}
648 		while (a <= sqrtdot5) {
649 			a *= 2;
650 			scale--;
651 		}
652 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
653 		int256 z = (s*s) / one;
654 		return scale * ln2 +
655 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
656 				/one))/one))/one))/one))/one);
657 	}
658 
659 	int256 constant c2 =  0x02aaaaaaaaa015db0;
660 	int256 constant c4 = -0x000b60b60808399d1;
661 	int256 constant c6 =  0x0000455956bccdd06;
662 	int256 constant c8 = -0x000001b893ad04b3a;
663 
664 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
665 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
666 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
667 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
668 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
669 		a -= scale*ln2;
670 		int256 z = (a*a) / one;
671 		int256 R = ((int256)(2) * one) +
672 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
673 		exp = (uint256) (((R + a) * one) / (R - a));
674 		if (scale >= 0)
675 			exp <<= scale;
676 		else
677 			exp >>= -scale;
678 		return exp;
679 	}
680 }