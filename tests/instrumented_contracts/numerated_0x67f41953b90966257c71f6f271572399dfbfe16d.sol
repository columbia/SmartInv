1 pragma solidity ^0.4.23;/*
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
15 PyrConnect
16 Decentralized Securities Licensing
17 */
18 contract PeerLicensing{
19 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
20 	// orders of magnitude, hence the need to bridge between the two.
21 	uint256 constant scaleFactor = 0x10000000000000000;// 2^64
22 
23 	// CRR = 50%
24 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
25 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
26 	uint256 constant trickTax = 3;//divides flux'd fee and for every pass up
27 	int constant crr_n = 1; // CRR numerator
28 	int constant crr_d = 2; // CRR denominator
29 
30 	int constant price_coeff = 0x57ea9ce452cde449f;
31 
32 	// Array between each address and their number of tokens.
33 	mapping(address => uint256) public holdings;
34 	//cut down by a percentage when you sell out.
35 	mapping(address => uint256) public avgFactor_ethSpent;
36 
37 	mapping(address => uint256) public souleculeR;
38 	mapping(address => uint256) public souleculeG;
39 	mapping(address => uint256) public souleculeB;
40 
41 	// Array between each address and how much Ether has been paid out to it.
42 	// Note that this is scaled by the scaleFactor variable.
43 	mapping(address => address) public reff;
44 	mapping(address => uint256) public tricklingFlo;
45 	mapping(address => uint256) public pocket;
46 	mapping(address => int256) public payouts;
47 
48 	// Variable tracking how many tokens are in existence overall.
49 	uint256 public totalBondSupply;
50 
51 	// Aggregate sum of all payouts.
52 	// Note that this is scaled by the scaleFactor variable.
53 	int256 totalPayouts;
54 	uint256 public trickleSum;
55 	uint256 public stakingRequirement = 1e18;
56 	
57 	address public lastGateway;
58 
59 	//flux fee ratio and contract score keepers
60 	uint256 public withdrawSum;
61 	uint256 public investSum;
62 
63 	// Variable tracking how much Ether each token is currently worth.
64 	// Note that this is scaled by the scaleFactor variable.
65 	uint256 earningsPerBond;
66 
67 	constructor() public {}
68 
69 	event onTokenPurchase(
70         address indexed customerAddress,
71         uint256 incomingEthereum,
72         uint256 tokensMinted,
73         address indexed referredBy
74     );
75 	event onBoughtFor(
76         address indexed buyerAddress,
77         address indexed forWho,
78         uint256 incomingEthereum,
79         uint256 tokensMinted,
80         address indexed referredBy
81     );
82     
83     event onTokenSell(
84         address indexed customerAddress,
85         uint256 totalTokensAtTheTime,//maybe it'd be cool to see what % people are selling from their total bank
86         uint256 tokensBurned,
87         uint256 ethereumEarned,
88         uint256 resolved
89     );
90     
91     event onReinvestment(
92         address indexed customerAddress,
93         uint256 ethereumReinvested,
94         uint256 tokensMinted
95     );
96     
97     event onWithdraw(
98         address indexed customerAddress,
99         uint256 ethereumWithdrawn
100     );
101     event onCashDividends(
102         address indexed customerAddress,
103         uint256 ethereumWithdrawn
104     );
105     event onColor(
106         address indexed customerAddress,
107         uint256 oldR,
108         uint256 oldG,
109         uint256 oldB,
110         uint256 newR,
111         uint256 newG,
112         uint256 newB
113     );
114 
115 
116 	// The following functions are used by the front-end for display purposes.
117 
118 
119 	// Returns the number of tokens currently held by _owner.
120 	function holdingsOf(address _owner) public constant returns (uint256 balance) {
121 		return holdings[_owner];
122 	}
123 
124 	// Withdraws all dividends held by the caller sending the transaction, updates
125 	// the requisite global variables, and transfers Ether back to the caller.
126 	function withdraw(address to) public {
127 		trickleUp();
128 		// Retrieve the dividends associated with the address the request came from.
129 		uint256 balance = dividends(msg.sender);
130 		//uint256 pocketBalance = tricklePocket[msg.sender];
131 		//tricklePocket[msg.sender] = 0;
132 		// Update the payouts array, incrementing the request address by `balance`.
133 		payouts[msg.sender] += (int256) (balance * scaleFactor);
134 		
135 		// Increase the total amount that's been paid out to maintain invariance.
136 		totalPayouts += (int256) (balance * scaleFactor);
137 
138 		uint256 pocketETH = pocket[msg.sender];
139 		pocket[msg.sender] = 0;
140 		trickleSum -= pocketETH;
141 
142 		balance += pocketETH;
143 		// Send the dividends to the address that requested the withdraw.
144 		withdrawSum += balance;
145 		to.transfer(balance);
146 		emit onCashDividends(to,balance);
147 	}
148 	function fullCycleSellBonds(uint256 balance) internal {
149 		// Send the cashed out stake to the address that requested the withdraw.
150 		withdrawSum += balance;
151 		msg.sender.transfer(balance);
152 		emit onWithdraw(msg.sender, balance);
153 	}
154 
155 
156 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
157 	// in the tokenBalance array, and therefore is shown as a dividend. A second
158 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
159 	function sellBonds(uint256 _amount) public {
160 		uint256 bondBalance = holdings[msg.sender];
161 		if(_amount <= bondBalance && _amount > 0){
162 			sell(_amount);
163 		}else{
164 			sell(bondBalance);
165 		}
166 	}
167 
168 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
169 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
170     function getMeOutOfHere() public {
171 		sellBonds( holdings[msg.sender] );
172         withdraw(msg.sender);
173 	}
174 
175 	function reffUp(address _reff) internal{
176 		address sender = msg.sender;
177 		if (_reff == 0x0000000000000000000000000000000000000000 || _reff == msg.sender)
178 			_reff = lastGateway;
179 			
180 		if(  holdings[_reff] >= stakingRequirement ) {
181 			//good to go. good gateway
182 		}else{
183 			if(lastGateway == 0x0000000000000000000000000000000000000000){
184 				lastGateway = sender;//first buyer ever
185 				_reff = sender;//first buyer is their own gateway/masternode
186 			}
187 			else
188 				_reff = lastGateway;//the lucky last player gets to be the gate way.
189 		}
190 		reff[sender] = _reff;
191 	}
192 	function rgbLimit(uint256 _rgb)internal pure returns(uint256){
193 		if(_rgb > 255)
194 			return 255;
195 		else
196 			return _rgb;
197 	}
198 	//BONUS
199 	//when you don't pick a color, the contract will need a default. which will be your current color
200 	/*function edgePigmentR()internal view returns (uint256 x)
201 	{if(holdings[msg.sender]==0)return 0;else return 255 * souleculeR[msg.sender]/holdings[msg.sender];}
202 	function edgePigmentG()internal view returns (uint256 x)
203 	{if(holdings[msg.sender]==0)return 0;else return 255 * souleculeG[msg.sender]/holdings[msg.sender];}
204 	function edgePigmentB()internal view returns (uint256 x)
205 	{if(holdings[msg.sender]==0)return 0;else return 255 * souleculeB[msg.sender]/holdings[msg.sender];}*/
206 	function edgePigment(uint8 C)internal view returns (uint256 x)
207 	{	
208 		uint256 holding = holdings[msg.sender];
209 		if(holding==0)
210 			return 0;
211 		else{
212 			if(C==0){
213 				return 255 * souleculeR[msg.sender]/holding;
214 			}else if(C==1){
215 				return 255 * souleculeG[msg.sender]/holding;
216 			}else if(C==2){
217 				return 255 * souleculeB[msg.sender]/holding;
218 			}
219 		} 
220 	}
221 	function fund(address reffo, address forWho) payable public {
222 		fund_color( reffo, forWho, edgePigment(0),edgePigment(1),edgePigment(2) );
223 	}
224 	function fund_color( address _reff, address forWho,uint256 soulR,uint256 soulG,uint256 soulB) payable public {
225 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
226 		reffUp(_reff);
227 		if (msg.value > 0.000001 ether){
228 			investSum += msg.value;
229 			soulR=rgbLimit(soulR);
230 			soulG=rgbLimit(soulG);
231 			soulB=rgbLimit(soulB);
232 		    buy( forWho ,soulR,soulG,soulB);
233 			lastGateway = msg.sender;
234 		} else {
235 			revert();
236 		}
237     }
238 
239     function reinvest_color(uint256 soulR,uint256 soulG,uint256 soulB) public {
240     	soulR=rgbLimit(soulR);
241 		soulG=rgbLimit(soulG);
242 		soulB=rgbLimit(soulB);
243 		processReinvest( soulR,soulG,soulB);
244 	}
245     function reinvest() public {
246 		processReinvest( edgePigment(0),edgePigment(1),edgePigment(2) );
247 	}
248 
249 	// Function that returns the (dynamic) price of a single token.
250 	function price(bool buyOrSell) public constant returns (uint) {
251         if(buyOrSell){
252         	return getTokensForEther(1 finney);
253         }else{
254         	uint256 eth = getEtherForTokens(1 finney);
255 	        uint256 fee = fluxFeed(eth, false, false);
256 	        return eth - fee;
257         }
258     }
259 
260 	function fluxFeed(uint256 _eth, bool slim_reinvest,bool buyOrSell) public constant returns (uint256 amount) {	
261 		uint8 bonus;
262 		if(slim_reinvest){
263 			bonus = 3;
264 			/*
265 			For the ecosystem:
266 			Reinvest discount = FluxFee * resolveGroupWithdrawnChoiceSum / ( resolveGroupWithdrawnChoiceSum + resolveGroupReinvestChoiceSum )
267 			
268 			The reinvest discounted price is equal to the flux'd fee multiplied by
269 			the sum of ETH chosen to be withdrawn from the pyramid's resolve type divided by
270 			the sum of BOTH ETH chosen to be withdrawn AND chosen to be reinvested in the same type.
271 			
272 			This means that the more your community reinvests in another, the better your reinvest deal.
273 			*/
274 		}else{
275 			bonus = 1;
276 		}
277 		if(buyOrSell)
278 			return  _eth/bonus * withdrawSum/(investSum);//we've already added it in.
279 		else
280 			return  _eth/bonus * (withdrawSum + _eth)/investSum;
281 	
282 		//gotta multiply and stuff in that order in order to get a high precision taxed amount.
283 		//because grouping (withdrawSum / investSum) can't return a precise decimal.
284 		//so instead we expand the value by multiplying then shrink it. by the denominator
285 
286 		/*
287 		100eth IN & 100eth OUT = 100% tax fee (returning 1) !!!
288 		100eth IN & 50eth OUT = 50% tax fee (returning 2)
289 		100eth IN & 33eth OUT = 33% tax fee (returning 3)
290 		100eth IN & 25eth OUT = 25% tax fee (returning 4)
291 		100eth IN & 10eth OUT = 10% tax fee (returning 10)
292 
293 		!!! keep in mind there is no fee if there are no holders. So if 100% of the eth has left
294 		the contract that means there can't possibly be holders to tax you. Funny how that works.
295 
296 		The flux fee also forces communities to help eachother more and more if the value drops.
297 		*/
298 	}
299 
300 	// Calculate the current dividends associated with the caller address. This is the net result
301 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
302 	// Ether that has already been paid out.
303 	function dividends(address _owner) public constant returns (uint256 amount) {
304 		return (uint256) ((int256)( earningsPerBond * holdings[_owner] ) - payouts[_owner] ) / scaleFactor;
305 	}
306 	function cashWallet(address _owner) public constant returns (uint256 amount) {
307 		return dividends(_owner)+pocket[_owner];
308 	}
309 
310 	// Internal balance function, used to calculate the dynamic reserve value.
311 	function contractBalance() internal constant returns (uint256 amount){
312 		// msg.value is the amount of Ether sent by the transaction.
313 		return investSum - withdrawSum - msg.value - trickleSum;
314 	}
315 				function trickleUp() internal{
316 					uint256 tricks = tricklingFlo[ msg.sender ];//this is the amount moving in the trickle flo
317 					if(tricks > 0){
318 						tricklingFlo[ msg.sender ] = 0;//we've already captured the amount so set your tricklingFlo flo to 0
319 						uint256 passUp = tricks/trickTax;//to get the amount we're gonna pass up. divide by trickTax
320 						uint256 reward = tricks-passUp;//and our remaining reward for ourselves is the amount we just slice off subtracted from the flo
321 						address finalReff;//we're not exactly sure who we're gonna pass this up to yet
322 						address reffo =  reff[msg.sender];//this is who it should go up to. if everything is legit
323 						if( holdings[reffo] >= stakingRequirement){
324 							finalReff = reffo;//if that address is holding enough to stake, it's a legit node to flo up to.
325 						}else{
326 							finalReff = lastGateway;//if not, then we use the last buyer
327 						}
328 						tricklingFlo[ finalReff ] += passUp;//so now we add that flo you've passed up to the tricklingFlo of the final Reff
329 						pocket[ msg.sender ] += reward;// oh yeah... and that reward... I gotchu
330 					}
331 				}
332 								function buy(address forWho,uint256 soulR,uint256 soulG,uint256 soulB) internal {
333 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
334 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
335 										revert();	
336 									
337 									//Fee to pay existing holders, and the referral commission
338 									uint256 fee = 0; 
339 									uint256 trickle = 0; 
340 									if(holdings[forWho] != totalBondSupply){
341 										fee = fluxFeed(msg.value,false,true);
342 										trickle = fee/trickTax;
343 										fee = fee - trickle;
344 										tricklingFlo[forWho] += trickle;
345 									}
346 									uint256 numEther = msg.value - (fee+trickle);// The amount of Ether used to purchase new tokens for the caller.
347 									uint256 numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
348 
349 									buyCalcAndPayout( forWho, fee, numTokens, numEther, reserve() );
350 
351 									addPigment(numTokens,soulR,soulG,soulB);
352 
353 									trickleSum += trickle;//add to trickle's Sum after reserve calculations
354 									trickleUp();
355 								
356 									emit onTokenPurchase(forWho, numEther ,numTokens , reff[msg.sender]);
357 									
358 									if(forWho != msg.sender){//make sure you're not yourself
359 										//if forWho doesn't have a reff, then reset it
360 										if(reff[forWho] == 0x0000000000000000000000000000000000000000)
361 											{reff[forWho] = msg.sender;}
362 											emit onBoughtFor(msg.sender, forWho,numEther,numTokens,reff[msg.sender]);
363 									}
364 								}
365 													function buyCalcAndPayout(address forWho,uint256 fee,uint256 numTokens,uint256 numEther,uint256 res)internal{
366 														// The buyer fee, scaled by the scaleFactor variable.
367 														uint256 buyerFee = fee * scaleFactor;
368 														
369 														if (totalBondSupply > 0){// because ...
370 															// Compute the bonus co-efficient for all existing holders and the buyer.
371 															// The buyer receives part of the distribution for each token bought in the
372 															// same way they would have if they bought each token individually.
373 															uint256 bonusCoEff = (scaleFactor - (res + numEther) * numTokens * scaleFactor / ( totalBondSupply  + numTokens) / numEther)
374 									 						*(uint)(crr_d) / (uint)(crr_d-crr_n);
375 															
376 															// The total reward to be distributed amongst the masses is the fee (in Ether)
377 															// multiplied by the bonus co-efficient.
378 															uint256 holderReward = fee * bonusCoEff;
379 															
380 															buyerFee -= holderReward;
381 															
382 															// The Ether value per token is increased proportionally.
383 															earningsPerBond +=  holderReward / totalBondSupply;
384 														}
385 														//resolve reward tracking stuff
386 														avgFactor_ethSpent[forWho] += numEther;
387 
388 														// Add the numTokens which were just created to the total supply. We're a crypto central bank!
389 														totalBondSupply += numTokens;
390 														// Assign the tokens to the balance of the buyer.
391 														holdings[forWho] += numTokens;
392 														// Update the payout array so that the buyer cannot claim dividends on previous purchases.
393 														// Also include the fee paid for entering the scheme.
394 														// First we compute how much was just paid out to the buyer...
395 														int256 payoutDiff = (int256) ((earningsPerBond * numTokens) - buyerFee);
396 														// Then we update the payouts array for the buyer with this amount...
397 														payouts[forWho] += payoutDiff;
398 														
399 														// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
400 														totalPayouts += payoutDiff;
401 													}
402 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
403 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
404 								// will be *significant*.
405 								function TOKEN_scaleDown(uint256 value,uint256 reduce) internal view returns(uint256 x){
406 									uint256 holdingsOfSender = holdings[msg.sender];
407 									return value * ( holdingsOfSender - reduce) / holdingsOfSender;
408 								}
409 								function sell(uint256 amount) internal {
410 								    uint256 numEthersBeforeFee = getEtherForTokens(amount);
411 									
412 									// x% of the resulting Ether is used to pay remaining holders.
413 									uint256 fee = 0;
414 									uint256 trickle = 0;
415 									if(totalBondSupply != holdings[msg.sender]){
416 										fee = fluxFeed(numEthersBeforeFee, false,false);
417 							        	trickle = fee/ trickTax;
418 										fee -= trickle;
419 										tricklingFlo[msg.sender] +=trickle;
420 									}
421 									
422 									// Net Ether for the seller after the fee has been subtracted.
423 							        uint256 numEthers = numEthersBeforeFee - (fee+trickle);
424 
425 									//How much you bought it for divided by how much you're getting back.
426 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
427 									uint256 resolved = mint(
428 										calcResolve(msg.sender,amount,numEthersBeforeFee),
429 										msg.sender
430 									);
431 
432 									// *Remove* the numTokens which were just sold from the total supply.
433 									avgFactor_ethSpent[msg.sender] = TOKEN_scaleDown(avgFactor_ethSpent[msg.sender] , amount);
434 
435 									souleculeR[msg.sender] = TOKEN_scaleDown(souleculeR[msg.sender] , amount);
436 									souleculeG[msg.sender] = TOKEN_scaleDown(souleculeG[msg.sender] , amount);
437 									souleculeB[msg.sender] = TOKEN_scaleDown(souleculeB[msg.sender] , amount);
438 									
439 									totalBondSupply -= amount;
440 									// Remove the tokens from the balance of the buyer.
441 									holdings[msg.sender] -= amount;
442 
443 									int256 payoutDiff = (int256) (earningsPerBond * amount);//we don't add in numETH because it is immedietly paid out.
444 		
445 							        // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
446 									// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
447 									// they decide to buy back in.
448 									payouts[msg.sender] -= payoutDiff;		
449 									
450 									// Decrease the total amount that's been paid out to maintain invariance.
451 							        totalPayouts -= payoutDiff;
452 							        
453 
454 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
455 									// selling tokens, but it guards against division by zero).
456 									if (totalBondSupply > 0) {
457 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
458 										uint256 etherFee = fee * scaleFactor;
459 										
460 										// Fee is distributed to all remaining token holders.
461 										// rewardPerShare is the amount gained per token thanks to this sell.
462 										uint256 rewardPerShare = etherFee / totalBondSupply;
463 										
464 										// The Ether value per token is increased proportionally.
465 										earningsPerBond +=  rewardPerShare;
466 									}
467 									fullCycleSellBonds(numEthers);
468 								
469 									trickleSum += trickle;
470 									trickleUp();
471 									emit onTokenSell(msg.sender,holdings[msg.sender]+amount,amount,numEthers,resolved);
472 								}
473 
474 				// Converts the Ether accrued as dividends back into Staking tokens without having to
475 				// withdraw it first. Saves on gas and potential price spike loss.
476 				function processReinvest(uint256 soulR,uint256 soulG,uint256 soulB) internal{
477 					// Retrieve the dividends associated with the address the request came from.
478 					uint256 balance = dividends(msg.sender);
479 
480 					// Update the payouts array, incrementing the request address by `balance`.
481 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
482 					payouts[msg.sender] += (int256) (balance * scaleFactor);
483 					
484 					// Increase the total amount that's been paid out to maintain invariance.
485 					totalPayouts += (int256) (balance * scaleFactor);					
486 						
487 					// Assign balance to a new variable.
488 					uint256 pocketETH = pocket[msg.sender];
489 					uint value_ = (uint) (balance + pocketETH);
490 					pocket[msg.sender] = 0;
491 					
492 					// If your dividends are worth less than 1 szabo, or more than a million Ether
493 					// (in which case, why are you even here), abort.
494 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
495 						revert();
496 
497 					uint256 fee = 0; 
498 					uint256 trickle = 0;
499 					if(holdings[msg.sender] != totalBondSupply){
500 						fee = fluxFeed(value_, true,true );// reinvestment fees are lower than regular ones.
501 						trickle = fee/ trickTax;
502 						fee = fee - trickle;
503 						tricklingFlo[msg.sender] += trickle;
504 					}
505 					
506 					// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
507 					// (Yes, the buyer receives a part of the distribution as well!)
508 					uint256 res = reserve() - balance;
509 
510 					// The amount of Ether used to purchase new tokens for the caller.
511 					uint256 numEther = value_ - (fee+trickle);
512 					
513 					// The number of tokens which can be purchased for numEther.
514 					uint256 numTokens = calculateDividendTokens(numEther, balance);
515 					
516 					buyCalcAndPayout( msg.sender, fee, numTokens, numEther, res );
517 
518 					addPigment(numTokens,soulR,soulG,soulB);
519 										
520 					trickleUp();
521 					//trickleSum -= pocketETH;
522 					trickleSum += trickle - pocketETH;
523 					emit onReinvestment(msg.sender,numEther,numTokens);
524 					if(msg.sender != msg.sender){//make sure you're not yourself
525 						//if forWho doesn't have a reff, then reset it
526 						if(reff[msg.sender] == 0x0000000000000000000000000000000000000000)
527 							{reff[msg.sender] = msg.sender;}
528 							emit onBoughtFor(msg.sender, msg.sender,numEther,numTokens,reff[msg.sender]);
529 					}
530 				}
531 	
532 	function addPigment(uint256 tokens,uint256 r,uint256 g,uint256 b) internal{
533 		souleculeR[msg.sender] += tokens * r / 255;
534 		souleculeG[msg.sender] += tokens * g / 255;
535 		souleculeB[msg.sender] += tokens * b / 255;
536 		emit onColor(msg.sender,r,g,b,souleculeR[msg.sender] ,souleculeG[msg.sender] ,souleculeB[msg.sender] );
537 	}
538 	// Dynamic value of Ether in reserve, according to the CRR requirement.
539 	function reserve() internal constant returns (uint256 amount){
540 		return contractBalance()-((uint256) ((int256) (earningsPerBond * totalBondSupply) - totalPayouts ) / scaleFactor);
541 	}
542 
543 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
544 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
545 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
546 		return fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff) - totalBondSupply ;
547 	}
548 
549 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
550 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
551 		return fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff) -  totalBondSupply;
552 	}
553 
554 	// Converts a number tokens into an Ether value.
555 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
556 		// How much reserve Ether do we have left in the contract?
557 		uint256 reserveAmount = reserve();
558 
559 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
560 		if (tokens == totalBondSupply )
561 			return reserveAmount;
562 
563 		// If there would be excess Ether left after the transaction this is called within, return the Ether
564 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
565 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
566 		// and denominator altered to 1 and 2 respectively.
567 		return reserveAmount - fixedExp((fixedLog(totalBondSupply  - tokens) - price_coeff) * crr_d/crr_n);
568 	}
569 
570 	function () payable public {
571 		if (msg.value > 0) {
572 			fund(lastGateway,msg.sender);
573 		} else {
574 			withdraw(msg.sender);
575 		}
576 	}
577 
578 										address public resolver = this;
579 										uint256 public totalSupply;
580 										uint256 public totalBurned;
581 									    uint256 constant private MAX_UINT256 = 2**256 - 1;
582 									    mapping (address => uint256) public balances;
583 									    mapping (address => uint256) public burned;
584 									    mapping (address => mapping (address => uint256)) public allowed;
585 									    
586 									    string public name = "0xBabylon";//yes, this is still the CODE name
587 									    uint8 public decimals = 18;
588 									    string public symbol = "PoWHr";//PoWHr Brokers
589 									    
590 									    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
591 									    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
592 									    event Resolved(address indexed _owner, uint256 amount);
593 									    event Burned(address indexed _owner, uint256 amount);
594 
595 									    function mint(uint256 amount,address _account) internal returns (uint minted){
596 									    	totalSupply += amount;
597 									    	balances[_account] += amount;
598 									    	emit Resolved(_account,amount);
599 									    	return amount;
600 									    }
601 
602 									    function balanceOf(address _owner) public view returns (uint256 balance) {
603 									        return balances[_owner]-burned[_owner];
604 									    }
605 									    
606 										function burn(uint256 _value) public returns (uint256 amount) {
607 									        require( balanceOf(msg.sender) >= _value);
608 									        totalBurned += _value;
609 									    	burned[msg.sender] += _value;
610 									    	emit Burned(msg.sender,_value);
611 									    	return _value;
612 									    }
613 
614 										function calcResolve(address _owner,uint256 amount,uint256 _eth) public constant returns (uint256 calculatedResolveTokens) {
615 											return amount*amount*avgFactor_ethSpent[_owner]/holdings[_owner]/_eth;
616 										}
617 
618 
619 									    function transfer(address _to, uint256 _value) public returns (bool success) {
620 									        require( balanceOf(msg.sender) >= _value);
621 									        balances[msg.sender] -= _value;
622 									        balances[_to] += _value;
623 									        emit Transfer(msg.sender, _to, _value);
624 									        return true;
625 									    }
626 										
627 									    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
628 									        uint256 allowance = allowed[_from][msg.sender];
629 									        require(    balanceOf(_from)  >= _value && allowance >= _value );
630 									        balances[_to] += _value;
631 									        balances[_from] -= _value;
632 									        if (allowance < MAX_UINT256) {
633 									            allowed[_from][msg.sender] -= _value;
634 									        }
635 									        emit Transfer(_from, _to, _value);
636 									        return true;
637 									    }
638 
639 									    function approve(address _spender, uint256 _value) public returns (bool success) {
640 									        allowed[msg.sender][_spender] = _value;
641 									        emit Approval(msg.sender, _spender, _value);
642 									        return true;
643 									    }
644 
645 									    function resolveSupply() public view returns (uint256 balance) {
646 									        return totalSupply-totalBurned;
647 									    }
648 
649 									    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
650 									        return allowed[_owner][_spender];
651 									    }
652 
653     // You don't care about these, but if you really do they're hex values for 
654 	// co-efficients used to simulate approximations of the log and exp functions.
655 	int256  constant one        = 0x10000000000000000;
656 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
657 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
658 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
659 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
660 	int256  constant c1         = 0x1ffffffffff9dac9b;
661 	int256  constant c3         = 0x0aaaaaaac16877908;
662 	int256  constant c5         = 0x0666664e5e9fa0c99;
663 	int256  constant c7         = 0x049254026a7630acf;
664 	int256  constant c9         = 0x038bd75ed37753d68;
665 	int256  constant c11        = 0x03284a0c14610924f;
666 
667 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
668 	// approximates the function log(1+x)-log(1-x)
669 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
670 	function fixedLog(uint256 a) internal pure returns (int256 log) {
671 		int32 scale = 0;
672 		while (a > sqrt2) {
673 			a /= 2;
674 			scale++;
675 		}
676 		while (a <= sqrtdot5) {
677 			a *= 2;
678 			scale--;
679 		}
680 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
681 		int256 z = (s*s) / one;
682 		return scale * ln2 +
683 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
684 				/one))/one))/one))/one))/one);
685 	}
686 
687 	int256 constant c2 =  0x02aaaaaaaaa015db0;
688 	int256 constant c4 = -0x000b60b60808399d1;
689 	int256 constant c6 =  0x0000455956bccdd06;
690 	int256 constant c8 = -0x000001b893ad04b3a;
691 
692 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
693 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
694 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
695 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
696 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
697 		a -= scale*ln2;
698 		int256 z = (a*a) / one;
699 		int256 R = ((int256)(2) * one) +
700 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
701 		exp = (uint256) (((R + a) * one) / (R - a));
702 		if (scale >= 0)
703 			exp <<= scale;
704 		else
705 			exp >>= -scale;
706 		return exp;
707 	}
708 }