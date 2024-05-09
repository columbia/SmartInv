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
15 Decentralized Securities Licensing
16 */contract PeerLicensing {
17 
18 	// scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
19 	// orders of magnitude, hence the need to bridge between the two.
20 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
21 
22 	// CRR = 50%
23 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
24 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
25 	uint256 constant trickTax = 3;//divides flux'd fee and for every pass up
26 	int constant crr_n = 1; // CRR numerator
27 	int constant crr_d = 2; // CRR denominator
28 
29 	int constant price_coeff = 0x299DC11F94E57CEB1;
30 
31 	// Array between each address and their number of tokens.
32 	//mapping(address => uint256) public tokenBalance;
33 	mapping(address => uint256) public holdings_BULL;
34 	mapping(address => uint256) public holdings_BEAR;
35 	//cut down by a percentage when you sell out.
36 	mapping(address => uint256) public avgFactor_ethSpent;
37 
38 	//Particle Coloring
39 	//this will change at the same rate in either market
40 		/*mapping(address => uint256) public souleculeEdgeR0;
41 		mapping(address => uint256) public souleculeEdgeG0;
42 		mapping(address => uint256) public souleculeEdgeB0;
43 		mapping(address => uint256) public souleculeEdgeR1;
44 		mapping(address => uint256) public souleculeEdgeG1;
45 		mapping(address => uint256) public souleculeEdgeB1;
46 	//this should change slower in a bull market. faster in a bear market
47 		mapping(address => uint256) public souleculeCoreR0;
48 		mapping(address => uint256) public souleculeCoreG0;
49 		mapping(address => uint256) public souleculeCoreB0;
50 		mapping(address => uint256) public souleculeCoreR1;
51 		mapping(address => uint256) public souleculeCoreG1;
52 		mapping(address => uint256) public souleculeCoreB1;*/
53 	
54 	// Array between each address and how much Ether has been paid out to it.
55 	// Note that this is scaled by the scaleFactor variable.
56 	mapping(address => address) public reff;
57 	mapping(address => uint256) public tricklePocket;
58 	mapping(address => uint256) public trickling;
59 	mapping(address => int256) public payouts;
60 
61 	// Variable tracking how many tokens are in existence overall.
62 	uint256 public totalBondSupply_BULL;
63 	uint256 public totalBondSupply_BEAR;
64 
65 	// Aggregate sum of all payouts.
66 	// Note that this is scaled by the scaleFactor variable.
67 	int256 totalPayouts;
68 	uint256 public tricklingSum;
69 	uint256 public stakingRequirement = 1e18;
70 	address public lastGateway;
71 
72 	//flux fee ratio score keepers
73 	uint256 public withdrawSum;
74 	uint256 public investSum;
75 
76 	// Variable tracking how much Ether each token is currently worth.
77 	// Note that this is scaled by the scaleFactor variable.
78 	uint256 earningsPerBond_BULL;
79 	uint256 earningsPerBond_BEAR;
80 
81 	function PeerLicensing() public {
82 	}
83 
84 
85 	event onTokenPurchase(
86         address indexed customerAddress,
87         uint256 incomingEthereum,
88         uint256 tokensMinted,
89         address indexed referredBy,
90         bool token
91     );
92     
93     event onTokenSell(
94         address indexed customerAddress,
95         uint256 totalTokensAtTheTime,//maybe it'd be cool to see what % people are selling from their total bank
96         uint256 tokensBurned,
97         uint256 ethereumEarned,
98         bool token,
99         uint256 resolved
100     );
101     
102     event onReinvestment(
103         address indexed customerAddress,
104         uint256 ethereumReinvested,
105         uint256 tokensMinted,
106         bool token
107     );
108     
109     event onWithdraw(
110         address indexed customerAddress,
111         uint256 ethereumWithdrawn
112     );
113 
114 
115 	// The following functions are used by the front-end for display purposes.
116 
117 
118 	// Returns the number of tokens currently held by _owner.
119 	function holdingsOf(address _owner) public constant returns (uint256 balance) {
120 		return holdings_BULL[_owner] + holdings_BEAR[_owner];
121 	}
122 	function holdingsOf_BULL(address _owner) public constant returns (uint256 balance) {
123 		return holdings_BULL[_owner];
124 	}
125 	function holdingsOf_BEAR(address _owner) public constant returns (uint256 balance) {
126 		return holdings_BEAR[_owner];
127 	}
128 
129 	// Withdraws all dividends held by the caller sending the transaction, updates
130 	// the requisite global variables, and transfers Ether back to the caller.
131 	function withdraw() public {
132 		trickleUp();
133 		// Retrieve the dividends associated with the address the request came from.
134 		var balance = dividends(msg.sender);
135 		var pocketBalance = tricklePocket[msg.sender];
136 		tricklePocket[msg.sender] = 0;
137 		tricklingSum = sub(tricklingSum,pocketBalance);
138 		uint256 out =add(balance, pocketBalance);
139 		// Update the payouts array, incrementing the request address by `balance`.
140 		payouts[msg.sender] += (int256) (balance * scaleFactor);
141 		
142 		// Increase the total amount that's been paid out to maintain invariance.
143 		totalPayouts += (int256) (balance * scaleFactor);
144 		
145 		// Send the dividends to the address that requested the withdraw.
146 		withdrawSum = add(withdrawSum,out);
147 		msg.sender.transfer(out);
148 		onWithdraw(msg.sender, out);
149 	}
150 
151 	function withdrawOld(address to) public {
152 		trickleUp();
153 		// Retrieve the dividends associated with the address the request came from.
154 		var balance = dividends(msg.sender);
155 		var pocketBalance = tricklePocket[msg.sender];
156 		tricklePocket[msg.sender] = 0;
157 		tricklingSum = sub(tricklingSum,pocketBalance);//gotta preserve that things for dynamic calculation
158 		uint256 out =add(balance, pocketBalance);
159 		// Update the payouts array, incrementing the request address by `balance`.
160 		payouts[msg.sender] += (int256) (balance * scaleFactor);
161 		
162 		// Increase the total amount that's been paid out to maintain invariance.
163 		totalPayouts += (int256) (balance * scaleFactor);
164 		
165 		// Send the dividends to the address that requested the withdraw.
166 		withdrawSum = add(withdrawSum,out);
167 		to.transfer(out);
168 		onWithdraw(to,out);
169 	}
170 	function fullCycleSellBonds(uint256 balance) internal {
171 		// Send the cashed out stake to the address that requested the withdraw.
172 		withdrawSum = add(withdrawSum,balance );
173 		msg.sender.transfer(balance);
174 		emit onWithdraw(msg.sender, balance);
175 	}
176 
177 
178 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
179 	// in the tokenBalance array, and therefore is shown as a dividend. A second
180 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
181 	function sellBonds(uint256 _amount, bool bondType) public {
182 		uint256 bondBalance;
183 		if(bondType){
184 			bondBalance = holdings_BULL[msg.sender];
185 		}else{
186 			bondBalance = holdings_BEAR[msg.sender];
187 		}
188 		if(_amount <= bondBalance && _amount > 0){
189 			sell(_amount,bondType);
190 		}else{
191 			if(_amount > bondBalance ){
192 				sell(bondBalance,bondType);
193 			}else{
194 				revert();
195 			}
196 		}
197 	}
198 
199 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
200 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
201     function getMeOutOfHere() public {
202 		sellBonds( holdings_BULL[msg.sender] ,true);
203 		sellBonds( holdings_BEAR[msg.sender] ,false);
204         withdraw();
205 	}
206 
207 	function reffUp(address _reff) internal{
208 		address sender = msg.sender;
209 		if (_reff == 0x0000000000000000000000000000000000000000)
210 			_reff = lastGateway;
211 			
212 		if(  add(holdings_BEAR[_reff],holdings_BULL[_reff]) >= stakingRequirement ) {
213 			//good to go. good gateway
214 		}else{
215 			if(lastGateway == 0x0000000000000000000000000000000000000000){
216 				lastGateway = sender;//first buyer ever
217 				_reff = sender;//first buyer is their own gateway/masternode
218 			}
219 			else
220 				_reff = lastGateway;//the lucky last player gets to be the gate way.
221 		}
222 
223 		reff[sender] = _reff;
224 	}
225 	// Gatekeeper function to check if the amount of Ether being sent isn't either
226 	// too small or too large. If it passes, goes direct to buy().
227 	/*function rgbLimit(uint256 _rgb)internal pure returns(uint256){
228 		if(_rgb > 255)
229 			return 255;
230 		else
231 			return _rgb;
232 	}*/
233 	//BONUS
234 	/*function edgePigmentR() internal returns (uint256 x)
235 	{return 255 * souleculeEdgeR1[msg.sender] / (souleculeEdgeR0[msg.sender]+souleculeEdgeR1[msg.sender]);}
236 	function edgePigmentG() internal returns (uint256 x)
237 	{return 255 * souleculeEdgeG1[msg.sender] / (souleculeEdgeG0[msg.sender]+souleculeEdgeG1[msg.sender]);}
238 	function edgePigmentB() internal returns (uint256 x)
239 	{return 255 * souleculeEdgeB1[msg.sender] / (souleculeEdgeB0[msg.sender]+souleculeEdgeB1[msg.sender]);}*/
240 
241 
242 	function fund(address _reff,bool bondType) payable public {
243 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
244 		reffUp(_reff);
245 		if (msg.value > 0.000001 ether) {
246 			investSum = add(investSum,msg.value);
247 
248 		    buy(bondType/*,edgePigmentR(),edgePigmentG(),edgePigmentB()*/);
249 			lastGateway = msg.sender;
250 		} else {
251 			revert();
252 		}
253     }
254 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
255 	function buyPrice() public constant returns (uint) {
256 		return getTokensForEther(1 finney);
257 	}
258 
259 	// Function that returns the (dynamic) price of selling a single token.
260 	function sellPrice() public constant returns (uint) {
261         var eth = getEtherForTokens(1 finney);
262         var fee = fluxFeed(eth, false);
263         return eth - fee;
264     }
265 	function fluxFeed(uint256 _eth, bool slim_reinvest) public constant returns (uint256 amount) {
266 		if (withdrawSum == 0){
267 			return 0;
268 		}else{
269 			if(slim_reinvest){
270 				return div( mul(_eth , withdrawSum), mul(investSum,3) );//discount for supporting the Pyramid
271 			}else{
272 				return div( mul(_eth , withdrawSum), investSum);// amount * withdrawSum / investSum	
273 			}
274 		}
275 		//gotta multiply and stuff in that order in order to get a high precision taxed amount.
276 		// because grouping (withdrawSum / investSum) can't return a precise decimal.
277 		//so instead we expand the value by multiplying then shrink it. by the denominator
278 
279 		/*
280 		100eth IN & 100eth OUT = 100% tax fee (returning 1) !!!
281 		100eth IN & 50eth OUT = 50% tax fee (returning 2)
282 		100eth IN & 33eth OUT = 33% tax fee (returning 3)
283 		100eth IN & 25eth OUT = 25% tax fee (returning 4)
284 		100eth IN & 10eth OUT = 10% tax fee (returning 10)
285 
286 		!!! keep in mind there is no fee if there are no holders. So if 100% of the eth has left the contract that means there can't possibly be holders to tax you
287 		*/
288 	}
289 
290 	// Calculate the current dividends associated with the caller address. This is the net result
291 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
292 	// Ether that has already been paid out.
293 	function dividends(address _owner) public constant returns (uint256 amount) {
294 		return (uint256) ((int256)(earningsPerBond_BULL * holdings_BULL[_owner] + earningsPerBond_BEAR * holdings_BEAR[_owner]) - payouts[_owner]) / scaleFactor;
295 	}
296 	function cashWallet(address _owner) public constant returns (uint256 amount) {
297 		return tricklePocket[_owner] + dividends(_owner);
298 	}
299 
300 	// Internal balance function, used to calculate the dynamic reserve value.
301 	function balance() internal constant returns (uint256 amount){
302 		// msg.value is the amount of Ether sent by the transaction.
303 		return sub(sub(investSum,withdrawSum) ,add( msg.value , tricklingSum));
304 	}
305 				function trickleUp() internal{
306 					uint256 tricks = trickling[ msg.sender ];
307 					if(tricks > 0){
308 						trickling[ msg.sender ] = 0;
309 						uint256 passUp = div(tricks,trickTax);
310 						uint256 reward = sub(tricks,passUp);//trickling[]
311 						address reffo = reff[msg.sender];
312 						if( holdingsOf(reffo) < stakingRequirement){
313 							trickling[ reffo ] = add(trickling[ reffo ],passUp);
314 							tricklePocket[ reffo ] = add(tricklePocket[ reffo ],reward);
315 						}else{//basically. if your referral guy bailed out then he can't get the rewards, instead give it to the new guy that was baited in by this feature
316 							trickling[ lastGateway ] = add(trickling[ lastGateway ],passUp);
317 							tricklePocket[ lastGateway ] = add(tricklePocket[ lastGateway ],reward);
318 						}/**/
319 					}
320 				}
321 
322 								function buy(bool bondType/*, uint256 soulR,uint256 soulG,uint256 soulB*/) internal {
323 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
324 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
325 										revert();
326 													
327 									// msg.sender is the address of the caller.
328 									var sender = msg.sender;
329 									
330 									// 10% of the total Ether sent is used to pay existing holders.
331 									uint256 fee = 0; 
332 									uint256 trickle = 0; 
333 									if(holdings_BULL[sender] != totalBondSupply_BULL){
334 										fee = fluxFeed(msg.value,false);
335 										trickle = div(fee, trickTax);
336 										fee = sub(fee , trickle);
337 										trickling[sender] = add(trickling[sender],trickle);
338 									}
339 									var numEther = sub(msg.value , add(fee , trickle));// The amount of Ether used to purchase new tokens for the caller.
340 									var numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
341 
342 
343 									// The buyer fee, scaled by the scaleFactor variable.
344 									var buyerFee = fee * scaleFactor;
345 									
346 									if (totalBondSupply_BULL > 0){// because ...
347 										// Compute the bonus co-efficient for all existing holders and the buyer.
348 										// The buyer receives part of the distribution for each token bought in the
349 										// same way they would have if they bought each token individually.
350 										uint256 bonusCoEff;
351 										if(bondType){
352 											bonusCoEff = (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / ( totalBondSupply_BULL + totalBondSupply_BEAR + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
353 										}else{
354 											bonusCoEff = scaleFactor;
355 										}
356 										
357 										// The total reward to be distributed amongst the masses is the fee (in Ether)
358 										// multiplied by the bonus co-efficient.
359 										var holderReward = fee * bonusCoEff;
360 										
361 										buyerFee -= holderReward;
362 										
363 										// The Ether value per token is increased proportionally.
364 										earningsPerBond_BULL = add(earningsPerBond_BULL,div(holderReward , totalBondSupply_BULL));
365 										
366 									}
367 
368 									//resolve reward tracking stuff
369 									avgFactor_ethSpent[msg.sender] = add(avgFactor_ethSpent[msg.sender], numEther);
370 
371 									int256 payoutDiff;
372 									if(bondType){
373 										// Add the numTokens which were just created to the total supply. We're a crypto central bank!
374 										totalBondSupply_BULL = add(totalBondSupply_BULL, numTokens);
375 										// Assign the tokens to the balance of the buyer.
376 										holdings_BULL[sender] = add(holdings_BULL[sender], numTokens);
377 										// Update the payout array so that the buyer cannot claim dividends on previous purchases.
378 										// Also include the fee paid for entering the scheme.
379 										// First we compute how much was just paid out to the buyer...
380 										payoutDiff = (int256) ((earningsPerBond_BULL * numTokens) - buyerFee);
381 									}else{
382 										totalBondSupply_BEAR = add(totalBondSupply_BEAR, numTokens);
383 										holdings_BEAR[sender] = add(holdings_BEAR[sender], numTokens);
384 										payoutDiff = (int256) ((earningsPerBond_BEAR * numTokens) - buyerFee);
385 									}
386 									
387 									// Then we update the payouts array for the buyer with this amount...
388 									payouts[sender] = payouts[sender]+payoutDiff;
389 									
390 									// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
391 									totalPayouts = totalPayouts+payoutDiff;
392 
393 									tricklingSum = add(tricklingSum,trickle);//add to trickle's Sum after reserve calculations
394 									trickleUp();
395 
396 									if(bondType){
397 										emit onTokenPurchase(sender,numEther,numTokens, reff[sender],true);
398 									}else{
399 										emit onTokenPurchase(sender,numEther,numTokens, reff[sender],false);
400 									}
401 
402 									//#COLORBONUS
403 									/*
404 									souleculeCoreR1[msg.sender] += soulR * numTokens/255;
405 									souleculeCoreG1[msg.sender] += soulG * numTokens/255;
406 									souleculeCoreB1[msg.sender] += soulB * numTokens/255;
407 									souleculeCoreR0[msg.sender] += numTokens-(soulR * numTokens/255);
408 									souleculeCoreG0[msg.sender] += numTokens-(soulG * numTokens/255);
409 									souleculeCoreB0[msg.sender] += numTokens-(soulB * numTokens/255);
410 
411 									souleculeEdgeR1[msg.sender] += soulR * numEther/255;
412 									souleculeEdgeG1[msg.sender] += soulG * numEther/255;
413 									souleculeEdgeB1[msg.sender] += soulB * numEther/255;
414 									souleculeEdgeR0[msg.sender] += numTokens-(soulR * numEther/255);
415 									souleculeEdgeG0[msg.sender] += numTokens-(soulG * numEther/255);
416 									souleculeEdgeB0[msg.sender] += numTokens-(soulB * numEther/255);*/
417 								}
418 
419 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
420 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
421 								// will be *significant*.
422 								function sell(uint256 amount,bool bondType) internal {
423 								    var numEthersBeforeFee = getEtherForTokens(amount);
424 									
425 									// x% of the resulting Ether is used to pay remaining holders.
426 									uint256 fee = 0;
427 									uint256 trickle = 0;
428 									if(totalBondSupply_BEAR != holdings_BEAR[msg.sender]){
429 										fee = fluxFeed(numEthersBeforeFee, true);
430 							        	trickle = div(fee, trickTax);
431 										fee = sub(fee , trickle);
432 										trickling[msg.sender] = add(trickling[msg.sender],trickle);
433 										tricklingSum = add(tricklingSum , trickle);
434 									} 
435 									
436 									// Net Ether for the seller after the fee has been subtracted.
437 							        var numEthers = sub(numEthersBeforeFee , add(fee , trickle));
438 
439 									//How much you bought it for divided by how much you're getting back.
440 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
441 									uint256 resolved = mint(
442 										calcResolve(msg.sender,amount,numEthers),
443 										msg.sender
444 									);
445 
446 									//#COLORBONUS
447 									/*
448 									souleculeCoreR1[msg.sender] = mul( souleculeCoreR1[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
449 									souleculeCoreG1[msg.sender] = mul( souleculeCoreG1[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
450 									souleculeCoreB1[msg.sender] = mul( souleculeCoreB1[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
451 									souleculeCoreR0[msg.sender] = mul( souleculeCoreR0[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
452 									souleculeCoreG0[msg.sender] = mul( souleculeCoreG0[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
453 									souleculeCoreB0[msg.sender] = mul( souleculeCoreB0[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
454 
455 									souleculeEdgeR1[msg.sender] -= edgePigmentR() * amount/255;
456 									souleculeEdgeG1[msg.sender] -= edgePigmentG() * amount/255;
457 									souleculeEdgeB1[msg.sender] -= edgePigmentB() * amount/255;
458 									souleculeEdgeR0[msg.sender] -= amount-(edgePigmentR() * amount/255);
459 									souleculeEdgeG0[msg.sender] -= amount-(edgePigmentG() * amount/255);
460 									souleculeEdgeB0[msg.sender] -= amount-(edgePigmentB() * amount/255);*/
461 
462 									// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
463 									int256 payoutDiff;
464 									if(bondType){
465 										totalBondSupply_BULL = sub(totalBondSupply_BULL, amount);
466 
467 										avgFactor_ethSpent[msg.sender] = mul( avgFactor_ethSpent[msg.sender] ,sub(holdings_BULL[msg.sender], amount) ) / holdings_BULL[msg.sender];
468 										// Remove the tokens from the balance of the buyer.
469 										holdings_BULL[msg.sender] = sub(holdings_BULL[msg.sender], amount);
470 										
471 									}else{
472 										totalBondSupply_BEAR = sub(totalBondSupply_BEAR, amount);
473 										
474 										avgFactor_ethSpent[msg.sender] = mul( avgFactor_ethSpent[msg.sender] ,sub(holdings_BEAR[msg.sender], amount) ) / holdings_BEAR[msg.sender];
475 										// Remove the tokens from the balance of the buyer.
476 										holdings_BEAR[msg.sender] = sub(holdings_BEAR[msg.sender], amount);
477 									}
478 									fullCycleSellBonds(numEthers);
479 									
480 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
481 									// selling tokens, but it guards against division by zero).
482 									if (totalBondSupply_BEAR > 0) {
483 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
484 										var etherFee = mul(fee , scaleFactor);
485 										
486 										// Fee is distributed to all remaining token holders.
487 										// rewardPerShare is the amount gained per token thanks to this sell.
488 										var rewardPerShare = div(etherFee , totalBondSupply_BEAR);
489 										
490 										// The Ether value per token is increased proportionally.
491 										earningsPerBond_BEAR = add(earningsPerBond_BEAR, rewardPerShare);
492 									}
493 									
494 									trickleUp();
495 									emit onTokenSell(msg.sender,add(add(holdings_BULL[msg.sender],holdings_BEAR[msg.sender]),amount),amount,numEthers,bondType,resolved);
496 
497 								}
498 
499 				// Converts the Ether accrued as dividends back into Staking tokens without having to
500 				// withdraw it first. Saves on gas and potential price spike loss.
501 				function reinvest(bool bondType/*, uint256 soulR,uint256 soulG,uint256 soulB*/) internal {
502 					// Retrieve the dividends associated with the address the request came from.
503 					var balance = dividends(msg.sender);
504 					balance = add(balance,tricklePocket[msg.sender]);
505 					tricklingSum = sub(tricklingSum,tricklePocket[msg.sender]);
506 					tricklePocket[msg.sender] = 0;
507 
508 					
509 					// Update the payouts array, incrementing the request address by `balance`.
510 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
511 					payouts[msg.sender] += (int256) (balance * scaleFactor);
512 					
513 					// Increase the total amount that's been paid out to maintain invariance.
514 					totalPayouts += (int256) (balance * scaleFactor);
515 					
516 					// Assign balance to a new variable.
517 					uint value_ = (uint) (balance);
518 					
519 					// If your dividends are worth less than 1 szabo, or more than a million Ether
520 					// (in which case, why are you even here), abort.
521 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
522 						revert();
523 						
524 					// msg.sender is the address of the caller.
525 					//var sender = msg.sender;
526 					
527 
528 
529 					uint256 fee = 0; 
530 					uint256 trickle = 0;
531 					if(holdings_BULL[msg.sender] != totalBondSupply_BULL){
532 						fee = fluxFeed(value_, true ); // reinvestment fees are lower than regular ones.
533 						trickle = div(fee, trickTax);
534 						fee = sub(fee , trickle);
535 						trickling[msg.sender] += trickle;
536 					}
537 					
538 
539 					var res = sub(reserve() , balance);
540 					// The amount of Ether used to purchase new tokens for the caller.
541 					var numEther = value_ - fee;
542 					
543 					// The number of tokens which can be purchased for numEther.
544 					var numTokens = calculateDividendTokens(numEther, balance);
545 					
546 					// The buyer fee, scaled by the scaleFactor variable.
547 					var buyerFee = fee * scaleFactor;
548 					
549 					// Check that we have tokens in existence (this should always be true), or
550 					// else you're gonna have a bad time.
551 					if (totalBondSupply_BULL > 0) {
552 						uint256 bonusCoEff;
553 						if(bondType){
554 							// Compute the bonus co-efficient for all existing holders and the buyer.
555 							// The buyer receives part of the distribution for each token bought in the
556 							// same way they would have if they bought each token individually.
557 							bonusCoEff =  (scaleFactor - (res + numEther ) * numTokens * scaleFactor / (totalBondSupply_BULL + totalBondSupply_BEAR  + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
558 						}else{
559 							bonusCoEff = scaleFactor;
560 						}
561 						
562 						// The total reward to be distributed amongst the masses is the fee (in Ether)
563 						// multiplied by the bonus co-efficient.
564 						buyerFee -= fee * bonusCoEff;
565 
566 						// Fee is distributed to all existing token holders before the new tokens are purchased.
567 						// rewardPerShare is the amount gained per token thanks to this buy-in.
568 						
569 						// The Ether value per token is increased proportionally.
570 						earningsPerBond_BULL += fee * bonusCoEff / totalBondSupply_BULL;
571 					}
572 					//resolve reward tracking stuff
573 					avgFactor_ethSpent[msg.sender] = add(avgFactor_ethSpent[msg.sender], numEther);
574 
575 					int256 payoutDiff;
576 					if(bondType){
577 						// Add the numTokens which were just created to the total supply. We're a crypto central bank!
578 						totalBondSupply_BULL = add(totalBondSupply_BULL, numTokens);
579 						// Assign the tokens to the balance of the buyer.
580 						holdings_BULL[msg.sender] = add(holdings_BULL[msg.sender], numTokens);
581 						// Update the payout array so that the buyer cannot claim dividends on previous purchases.
582 						// Also include the fee paid for entering the scheme.
583 						// First we compute how much was just paid out to the buyer...
584 						payoutDiff = (int256) ((earningsPerBond_BULL * numTokens) - buyerFee);
585 					}else{
586 						totalBondSupply_BEAR = add(totalBondSupply_BEAR, numTokens);
587 						holdings_BEAR[msg.sender] = add(holdings_BEAR[msg.sender], numTokens);
588 						payoutDiff = (int256) ((earningsPerBond_BEAR * numTokens) - buyerFee);
589 					}
590 					
591 					/*var averageCostPerToken = div(numTokens , numEther);
592 					var newTokenSum = add(holdings_BULL[sender], numTokens);
593 					var totalSpentBefore = mul(averageBuyInPrice[sender], holdingsOf(sender) );*/
594 					//averageBuyInPrice[sender] = div( totalSpentBefore + mul( averageCostPerToken , numTokens), newTokenSum )  ;
595 					
596 					// Then we update the payouts array for the buyer with this amount...
597 					payouts[msg.sender] += payoutDiff;
598 					
599 					// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
600 					totalPayouts += payoutDiff;
601 
602 					tricklingSum += trickle;//add to trickle's Sum after reserve calculations
603 					trickleUp();
604 					if(bondType){
605 						emit onReinvestment(msg.sender,numEther,numTokens,true);
606 					}else{
607 						emit onReinvestment(msg.sender,numEther,numTokens,false);	
608 					}
609 
610 					//#COLORBONUS
611 					/*
612 					souleculeCoreR1[msg.sender] += soulR * numTokens/255;
613 					souleculeCoreG1[msg.sender] += soulG * numTokens/255;
614 					souleculeCoreB1[msg.sender] += soulB * numTokens/255;
615 					souleculeCoreR0[msg.sender] += numTokens-(soulR * numTokens/255);
616 					souleculeCoreG0[msg.sender] += numTokens-(soulG * numTokens/255);
617 					souleculeCoreB0[msg.sender] += numTokens-(soulB * numTokens/255);
618 
619 					souleculeEdgeR1[msg.sender] += soulR * numEther/255;
620 					souleculeEdgeG1[msg.sender] += soulG * numEther/255;
621 					souleculeEdgeB1[msg.sender] += soulB * numEther/255;
622 					souleculeEdgeR0[msg.sender] += numTokens-(soulR * numEther/255);
623 					souleculeEdgeG0[msg.sender] += numTokens-(soulG * numEther/255);
624 					souleculeEdgeB0[msg.sender] += numTokens-(soulB * numEther/255);*/
625 				}
626 
627 	
628 	// Dynamic value of Ether in reserve, according to the CRR requirement.
629 	function reserve() internal constant returns (uint256 amount){
630 		return sub(balance(),
631 			  ((uint256) ((int256) (earningsPerBond_BULL * totalBondSupply_BULL + earningsPerBond_BEAR * totalBondSupply_BEAR) - totalPayouts ) / scaleFactor) 
632 		);
633 	}
634 
635 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
636 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
637 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
638 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply_BULL + totalBondSupply_BEAR);
639 	}
640 
641 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
642 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
643 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply_BULL + totalBondSupply_BEAR);
644 	}
645 
646 	// Converts a number tokens into an Ether value.
647 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
648 		// How much reserve Ether do we have left in the contract?
649 		var reserveAmount = reserve();
650 
651 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
652 		if (tokens == (totalBondSupply_BULL + totalBondSupply_BEAR) )
653 			return reserveAmount;
654 
655 		// If there would be excess Ether left after the transaction this is called within, return the Ether
656 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
657 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
658 		// and denominator altered to 1 and 2 respectively.
659 		return sub(reserveAmount, fixedExp((fixedLog(totalBondSupply_BULL + totalBondSupply_BEAR - tokens) - price_coeff) * crr_d/crr_n));
660 	}
661 
662 	// You don't care about these, but if you really do they're hex values for 
663 	// co-efficients used to simulate approximations of the log and exp functions.
664 	int256  constant one        = 0x10000000000000000;
665 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
666 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
667 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
668 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
669 	int256  constant c1         = 0x1ffffffffff9dac9b;
670 	int256  constant c3         = 0x0aaaaaaac16877908;
671 	int256  constant c5         = 0x0666664e5e9fa0c99;
672 	int256  constant c7         = 0x049254026a7630acf;
673 	int256  constant c9         = 0x038bd75ed37753d68;
674 	int256  constant c11        = 0x03284a0c14610924f;
675 
676 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
677 	// approximates the function log(1+x)-log(1-x)
678 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
679 	function fixedLog(uint256 a) internal pure returns (int256 log) {
680 		int32 scale = 0;
681 		while (a > sqrt2) {
682 			a /= 2;
683 			scale++;
684 		}
685 		while (a <= sqrtdot5) {
686 			a *= 2;
687 			scale--;
688 		}
689 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
690 		var z = (s*s) / one;
691 		return scale * ln2 +
692 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
693 				/one))/one))/one))/one))/one);
694 	}
695 
696 	int256 constant c2 =  0x02aaaaaaaaa015db0;
697 	int256 constant c4 = -0x000b60b60808399d1;
698 	int256 constant c6 =  0x0000455956bccdd06;
699 	int256 constant c8 = -0x000001b893ad04b3a;
700 	
701 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
702 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
703 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
704 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
705 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
706 		a -= scale*ln2;
707 		int256 z = (a*a) / one;
708 		int256 R = ((int256)(2) * one) +
709 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
710 		exp = (uint256) (((R + a) * one) / (R - a));
711 		if (scale >= 0)
712 			exp <<= scale;
713 		else
714 			exp >>= -scale;
715 		return exp;
716 	}
717 	
718 	// The below are safemath implementations of the four arithmetic operators
719 	// designed to explicitly prevent over- and under-flows of integer values.
720 
721 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
722 		if (a == 0) {
723 			return 0;
724 		}
725 		uint256 c = a * b;
726 		assert(c / a == b);
727 		return c;
728 	}
729 
730 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
731 		uint256 c = a / b;
732 		return c;
733 	}
734 
735 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
736 		assert(b <= a);
737 		return a - b;
738 	}
739 
740 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
741 		uint256 c = a + b;
742 		assert(c >= a);
743 		return c;
744 	}
745 
746 	function () payable public {
747 		if (msg.value > 0) {
748 			fund(lastGateway,true);
749 		} else {
750 			withdrawOld(msg.sender);
751 		}
752 	}
753 
754 	uint256 public totalSupply;
755     uint256 constant private MAX_UINT256 = 2**256 - 1;
756     mapping (address => uint256) public balances;
757     mapping (address => mapping (address => uint256)) public allowed;
758     
759     string public name = "0xBabylon";
760     uint8 public decimals = 12;
761     string public symbol = "PoWHr";
762     
763     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
764     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
765     event Resolved(address indexed _owner, uint256 amount);
766     event Burned(address indexed _owner, uint256 amount);
767 
768     function mint(uint256 amount,address _account) internal returns (uint minted){
769     	totalSupply += amount;
770     	balances[_account] += amount;
771     	Resolved(_account,amount);
772     	return amount;
773     }
774 
775 	function burn(uint256 _value) public returns (uint256 amount) {
776         require(balances[msg.sender] >= _value);
777         totalSupply -= _value;
778     	balances[msg.sender] -= _value;
779     	Resolved(msg.sender,_value);
780     	return _value;
781     }
782 
783 	function calcResolve(address _owner,uint256 amount,uint256 _eth) public constant returns (uint256 calculatedResolveTokens) {
784 		return div(div(div(mul(mul(amount,amount),avgFactor_ethSpent[_owner]),holdings_BULL[_owner]+holdings_BEAR[_owner]),_eth),1000000);
785 	}
786 
787 
788     function transfer(address _to, uint256 _value) public returns (bool success) {
789         require(balances[msg.sender] >= _value);
790         balances[msg.sender] -= _value;
791         balances[_to] += _value;
792         emit Transfer(msg.sender, _to, _value);
793         return true;
794     }
795 	
796     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
797         uint256 allowance = allowed[_from][msg.sender];
798         require(balances[_from] >= _value && allowance >= _value);
799         balances[_to] += _value;
800         balances[_from] -= _value;
801         if (allowance < MAX_UINT256) {
802             allowed[_from][msg.sender] -= _value;
803         }
804         emit Transfer(_from, _to, _value);
805         return true;
806     }
807 
808     function approve(address _spender, uint256 _value) public returns (bool success) {
809         allowed[msg.sender][_spender] = _value;
810         emit Approval(msg.sender, _spender, _value);
811         return true;
812     }
813 
814     function balanceOf(address _owner) public view returns (uint256 balance) {
815         return balances[_owner];
816     }
817     function resolveSupply(address _owner) public view returns (uint256 balance) {
818         return totalSupply;
819     }
820 
821     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
822         return allowed[_owner][_spender];
823     }
824 }