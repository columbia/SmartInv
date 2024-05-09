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
29 	// The price coefficient. Chosen such that at 1 token total supply
30 	// the amount in reserve is 10 ether and token price is 1 Ether.
31 	int constant price_coeff = -0x2793DB20E4C20163A;
32 
33 	// Array between each address and their number of tokens.
34 	//mapping(address => uint256) public tokenBalance;
35 	mapping(address => uint256) public holdings_BULL;
36 	mapping(address => uint256) public holdings_BEAR;
37 	//cut down by a percentage when you sell out.
38 	mapping(address => uint256) public avgFactor_ethSpent;
39 
40 	//Particle Coloring
41 	//this will change at the same rate in either market
42 		/*mapping(address => uint256) public souleculeEdgeR0;
43 		mapping(address => uint256) public souleculeEdgeG0;
44 		mapping(address => uint256) public souleculeEdgeB0;
45 		mapping(address => uint256) public souleculeEdgeR1;
46 		mapping(address => uint256) public souleculeEdgeG1;
47 		mapping(address => uint256) public souleculeEdgeB1;
48 	//this should change slower in a bull market. faster in a bear market
49 		mapping(address => uint256) public souleculeCoreR0;
50 		mapping(address => uint256) public souleculeCoreG0;
51 		mapping(address => uint256) public souleculeCoreB0;
52 		mapping(address => uint256) public souleculeCoreR1;
53 		mapping(address => uint256) public souleculeCoreG1;
54 		mapping(address => uint256) public souleculeCoreB1;*/
55 	
56 	// Array between each address and how much Ether has been paid out to it.
57 	// Note that this is scaled by the scaleFactor variable.
58 	mapping(address => address) public reff;
59 	mapping(address => uint256) public tricklePocket;
60 	mapping(address => uint256) public trickling;
61 	mapping(address => int256) public payouts;
62 
63 	// Variable tracking how many tokens are in existence overall.
64 	uint256 public totalBondSupply_BULL;
65 	uint256 public totalBondSupply_BEAR;
66 
67 	// Aggregate sum of all payouts.
68 	// Note that this is scaled by the scaleFactor variable.
69 	int256 totalPayouts;
70 	uint256 public tricklingSum;
71 	uint256 public stakingRequirement = 1e18;
72 	address public lastGateway;
73 
74 	//flux fee ratio score keepers
75 	uint256 public withdrawSum;
76 	uint256 public investSum;
77 
78 	// Variable tracking how much Ether each token is currently worth.
79 	// Note that this is scaled by the scaleFactor variable.
80 	uint256 earningsPerBond_BULL;
81 	uint256 earningsPerBond_BEAR;
82 
83 	function PeerLicensing() public {
84 	}
85 
86 
87 	event onTokenPurchase(
88         address indexed customerAddress,
89         uint256 incomingEthereum,
90         uint256 tokensMinted,
91         address indexed referredBy,
92         bool token
93     );
94     
95     event onTokenSell(
96         address indexed customerAddress,
97         uint256 totalTokensAtTheTime,//maybe it'd be cool to see what % people are selling from their total bank
98         uint256 tokensBurned,
99         uint256 ethereumEarned,
100         bool token,
101         uint256 resolved
102     );
103     
104     event onReinvestment(
105         address indexed customerAddress,
106         uint256 ethereumReinvested,
107         uint256 tokensMinted,
108         bool token
109     );
110     
111     event onWithdraw(
112         address indexed customerAddress,
113         uint256 ethereumWithdrawn
114     );
115 
116 
117 	// The following functions are used by the front-end for display purposes.
118 
119 
120 	// Returns the number of tokens currently held by _owner.
121 	function holdingsOf(address _owner) public constant returns (uint256 balance) {
122 		return holdings_BULL[_owner] + holdings_BEAR[_owner];
123 	}
124 	function holdingsOf_BULL(address _owner) public constant returns (uint256 balance) {
125 		return holdings_BULL[_owner];
126 	}
127 	function holdingsOf_BEAR(address _owner) public constant returns (uint256 balance) {
128 		return holdings_BEAR[_owner];
129 	}
130 
131 	// Withdraws all dividends held by the caller sending the transaction, updates
132 	// the requisite global variables, and transfers Ether back to the caller.
133 	function withdraw() public {
134 		trickleUp();
135 		// Retrieve the dividends associated with the address the request came from.
136 		var balance = dividends(msg.sender);
137 		var pocketBalance = tricklePocket[msg.sender];
138 		tricklePocket[msg.sender] = 0;
139 		tricklingSum = sub(tricklingSum,pocketBalance);
140 		uint256 out =add(balance, pocketBalance);
141 		// Update the payouts array, incrementing the request address by `balance`.
142 		payouts[msg.sender] += (int256) (balance * scaleFactor);
143 		
144 		// Increase the total amount that's been paid out to maintain invariance.
145 		totalPayouts += (int256) (balance * scaleFactor);
146 		
147 		// Send the dividends to the address that requested the withdraw.
148 		withdrawSum = add(withdrawSum,out);
149 		msg.sender.transfer(out);
150 		onWithdraw(msg.sender, out);
151 	}
152 
153 	function withdrawOld(address to) public {
154 		trickleUp();
155 		// Retrieve the dividends associated with the address the request came from.
156 		var balance = dividends(msg.sender);
157 		var pocketBalance = tricklePocket[msg.sender];
158 		tricklePocket[msg.sender] = 0;
159 		tricklingSum = sub(tricklingSum,pocketBalance);//gotta preserve that things for dynamic calculation
160 		uint256 out =add(balance, pocketBalance);
161 		// Update the payouts array, incrementing the request address by `balance`.
162 		payouts[msg.sender] += (int256) (balance * scaleFactor);
163 		
164 		// Increase the total amount that's been paid out to maintain invariance.
165 		totalPayouts += (int256) (balance * scaleFactor);
166 		
167 		// Send the dividends to the address that requested the withdraw.
168 		withdrawSum = add(withdrawSum,out);
169 		to.transfer(out);
170 		onWithdraw(to,out);
171 	}
172 	function fullCycleSellBonds(uint256 balance) internal {
173 		// Send the cashed out stake to the address that requested the withdraw.
174 		withdrawSum = add(withdrawSum,balance );
175 		msg.sender.transfer(balance);
176 		emit onWithdraw(msg.sender, balance);
177 	}
178 
179 
180 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
181 	// in the tokenBalance array, and therefore is shown as a dividend. A second
182 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
183 	function sellBonds(uint256 _amount, bool bondType) public {
184 		uint256 bondBalance;
185 		if(bondType){
186 			bondBalance = holdings_BULL[msg.sender];
187 		}else{
188 			bondBalance = holdings_BEAR[msg.sender];
189 		}
190 		if(_amount <= bondBalance && _amount > 0){
191 			sell(_amount,bondType);
192 		}else{
193 			if(_amount > bondBalance ){
194 				sell(bondBalance,bondType);
195 			}else{
196 				revert();
197 			}
198 		}
199 	}
200 
201 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
202 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
203     function getMeOutOfHere() public {
204 		sellBonds( holdings_BULL[msg.sender] ,true);
205 		sellBonds( holdings_BEAR[msg.sender] ,false);
206         withdraw();
207 	}
208 
209 	function reffUp(address _reff) internal{
210 		address sender = msg.sender;
211 		if (_reff == 0x0000000000000000000000000000000000000000)
212 			_reff = lastGateway;
213 			
214 		if(  add(holdings_BEAR[_reff],holdings_BULL[_reff]) >= stakingRequirement ) {
215 			//good to go. good gateway
216 		}else{
217 			if(lastGateway == 0x0000000000000000000000000000000000000000){
218 				lastGateway = sender;//first buyer ever
219 				_reff = sender;//first buyer is their own gateway/masternode
220 			}
221 			else
222 				_reff = lastGateway;//the lucky last player gets to be the gate way.
223 		}
224 
225 		reff[sender] = _reff;
226 	}
227 	// Gatekeeper function to check if the amount of Ether being sent isn't either
228 	// too small or too large. If it passes, goes direct to buy().
229 	/*function rgbLimit(uint256 _rgb)internal pure returns(uint256){
230 		if(_rgb > 255)
231 			return 255;
232 		else
233 			return _rgb;
234 	}*/
235 	//BONUS
236 	/*function edgePigmentR() internal returns (uint256 x)
237 	{return 255 * souleculeEdgeR1[msg.sender] / (souleculeEdgeR0[msg.sender]+souleculeEdgeR1[msg.sender]);}
238 	function edgePigmentG() internal returns (uint256 x)
239 	{return 255 * souleculeEdgeG1[msg.sender] / (souleculeEdgeG0[msg.sender]+souleculeEdgeG1[msg.sender]);}
240 	function edgePigmentB() internal returns (uint256 x)
241 	{return 255 * souleculeEdgeB1[msg.sender] / (souleculeEdgeB0[msg.sender]+souleculeEdgeB1[msg.sender]);}*/
242 
243 
244 	function fund(address _reff,bool bondType) payable public {
245 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
246 		reffUp(_reff);
247 		if (msg.value > 0.000001 ether) {
248 			investSum = add(investSum,msg.value);
249 
250 		    buy(bondType/*,edgePigmentR(),edgePigmentG(),edgePigmentB()*/);
251 			lastGateway = msg.sender;
252 		} else {
253 			revert();
254 		}
255     }
256 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
257 	function buyPrice() public constant returns (uint) {
258 		return getTokensForEther(1 finney);
259 	}
260 
261 	// Function that returns the (dynamic) price of selling a single token.
262 	function sellPrice() public constant returns (uint) {
263         var eth = getEtherForTokens(1 finney);
264         var fee = fluxFeed(eth, false);
265         return eth - fee;
266     }
267 	function fluxFeed(uint256 _eth, bool slim_reinvest) public constant returns (uint256 amount) {
268 		if (withdrawSum == 0){
269 			return 0;
270 		}else{
271 			if(slim_reinvest){
272 				return div( mul(_eth , withdrawSum), mul(investSum,3) );//discount for supporting the Pyramid
273 			}else{
274 				return div( mul(_eth , withdrawSum), investSum);// amount * withdrawSum / investSum	
275 			}
276 		}
277 		//gotta multiply and stuff in that order in order to get a high precision taxed amount.
278 		// because grouping (withdrawSum / investSum) can't return a precise decimal.
279 		//so instead we expand the value by multiplying then shrink it. by the denominator
280 
281 		/*
282 		100eth IN & 100eth OUT = 100% tax fee (returning 1) !!!
283 		100eth IN & 50eth OUT = 50% tax fee (returning 2)
284 		100eth IN & 33eth OUT = 33% tax fee (returning 3)
285 		100eth IN & 25eth OUT = 25% tax fee (returning 4)
286 		100eth IN & 10eth OUT = 10% tax fee (returning 10)
287 
288 		!!! keep in mind there is no fee if there are no holders. So if 100% of the eth has left the contract that means there can't possibly be holders to tax you
289 		*/
290 	}
291 
292 	// Calculate the current dividends associated with the caller address. This is the net result
293 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
294 	// Ether that has already been paid out.
295 	function dividends(address _owner) public constant returns (uint256 amount) {
296 		return (uint256) ((int256)(earningsPerBond_BULL * holdings_BULL[_owner] + earningsPerBond_BEAR * holdings_BEAR[_owner]) - payouts[_owner]) / scaleFactor;
297 	}
298 	function cashWallet(address _owner) public constant returns (uint256 amount) {
299 		return tricklePocket[_owner] + dividends(_owner);
300 	}
301 
302 	// Internal balance function, used to calculate the dynamic reserve value.
303 	function balance() internal constant returns (uint256 amount){
304 		// msg.value is the amount of Ether sent by the transaction.
305 		return sub(sub(investSum,withdrawSum) ,add( msg.value , tricklingSum));
306 	}
307 				function trickleUp() internal{
308 					uint256 tricks = trickling[ msg.sender ];
309 					if(tricks > 0){
310 						trickling[ msg.sender ] = 0;
311 						uint256 passUp = div(tricks,trickTax);
312 						uint256 reward = sub(tricks,passUp);//trickling[]
313 						address reffo = reff[msg.sender];
314 						if( holdingsOf(reffo) < stakingRequirement){
315 							trickling[ reffo ] = add(trickling[ reffo ],passUp);
316 							tricklePocket[ reffo ] = add(tricklePocket[ reffo ],reward);
317 						}else{//basically. if your referral guy bailed out then he can't get the rewards, instead give it to the new guy that was baited in by this feature
318 							trickling[ lastGateway ] = add(trickling[ lastGateway ],passUp);
319 							tricklePocket[ lastGateway ] = add(tricklePocket[ lastGateway ],reward);
320 						}/**/
321 					}
322 				}
323 
324 								function buy(bool bondType/*, uint256 soulR,uint256 soulG,uint256 soulB*/) internal {
325 									// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
326 									if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
327 										revert();
328 													
329 									// msg.sender is the address of the caller.
330 									var sender = msg.sender;
331 									
332 									// 10% of the total Ether sent is used to pay existing holders.
333 									uint256 fee = 0; 
334 									uint256 trickle = 0; 
335 									if(holdings_BULL[sender] != totalBondSupply_BULL){
336 										fee = fluxFeed(msg.value,false);
337 										trickle = div(fee, trickTax);
338 										fee = sub(fee , trickle);
339 										trickling[sender] = add(trickling[sender],trickle);
340 									}
341 									var numEther = sub(msg.value , add(fee , trickle));// The amount of Ether used to purchase new tokens for the caller.
342 									var numTokens = getTokensForEther(numEther);// The number of tokens which can be purchased for numEther.
343 
344 
345 									// The buyer fee, scaled by the scaleFactor variable.
346 									var buyerFee = fee * scaleFactor;
347 									
348 									if (totalBondSupply_BULL > 0){// because ...
349 										// Compute the bonus co-efficient for all existing holders and the buyer.
350 										// The buyer receives part of the distribution for each token bought in the
351 										// same way they would have if they bought each token individually.
352 										uint256 bonusCoEff;
353 										if(bondType){
354 											bonusCoEff = (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / ( totalBondSupply_BULL + totalBondSupply_BEAR + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
355 										}else{
356 											bonusCoEff = scaleFactor;
357 										}
358 										
359 										// The total reward to be distributed amongst the masses is the fee (in Ether)
360 										// multiplied by the bonus co-efficient.
361 										var holderReward = fee * bonusCoEff;
362 										
363 										buyerFee -= holderReward;
364 										
365 										// The Ether value per token is increased proportionally.
366 										earningsPerBond_BULL = add(earningsPerBond_BULL,div(holderReward , totalBondSupply_BULL));
367 										
368 									}
369 
370 									//resolve reward tracking stuff
371 									avgFactor_ethSpent[msg.sender] = add(avgFactor_ethSpent[msg.sender], numEther);
372 
373 									int256 payoutDiff;
374 									if(bondType){
375 										// Add the numTokens which were just created to the total supply. We're a crypto central bank!
376 										totalBondSupply_BULL = add(totalBondSupply_BULL, numTokens);
377 										// Assign the tokens to the balance of the buyer.
378 										holdings_BULL[sender] = add(holdings_BULL[sender], numTokens);
379 										// Update the payout array so that the buyer cannot claim dividends on previous purchases.
380 										// Also include the fee paid for entering the scheme.
381 										// First we compute how much was just paid out to the buyer...
382 										payoutDiff = (int256) ((earningsPerBond_BULL * numTokens) - buyerFee);
383 									}else{
384 										totalBondSupply_BEAR = add(totalBondSupply_BEAR, numTokens);
385 										holdings_BEAR[sender] = add(holdings_BEAR[sender], numTokens);
386 										payoutDiff = (int256) ((earningsPerBond_BEAR * numTokens) - buyerFee);
387 									}
388 									
389 									// Then we update the payouts array for the buyer with this amount...
390 									payouts[sender] = payouts[sender]+payoutDiff;
391 									
392 									// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
393 									totalPayouts = totalPayouts+payoutDiff;
394 
395 									tricklingSum = add(tricklingSum,trickle);//add to trickle's Sum after reserve calculations
396 									trickleUp();
397 
398 									if(bondType){
399 										emit onTokenPurchase(sender,numEther,numTokens, reff[sender],true);
400 									}else{
401 										emit onTokenPurchase(sender,numEther,numTokens, reff[sender],false);
402 									}
403 
404 									//#COLORBONUS
405 									/*
406 									souleculeCoreR1[msg.sender] += soulR * numTokens/255;
407 									souleculeCoreG1[msg.sender] += soulG * numTokens/255;
408 									souleculeCoreB1[msg.sender] += soulB * numTokens/255;
409 									souleculeCoreR0[msg.sender] += numTokens-(soulR * numTokens/255);
410 									souleculeCoreG0[msg.sender] += numTokens-(soulG * numTokens/255);
411 									souleculeCoreB0[msg.sender] += numTokens-(soulB * numTokens/255);
412 
413 									souleculeEdgeR1[msg.sender] += soulR * numEther/255;
414 									souleculeEdgeG1[msg.sender] += soulG * numEther/255;
415 									souleculeEdgeB1[msg.sender] += soulB * numEther/255;
416 									souleculeEdgeR0[msg.sender] += numTokens-(soulR * numEther/255);
417 									souleculeEdgeG0[msg.sender] += numTokens-(soulG * numEther/255);
418 									souleculeEdgeB0[msg.sender] += numTokens-(soulB * numEther/255);*/
419 								}
420 
421 								// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
422 								// to discouraging dumping, and means that if someone near the top sells, the fee distributed
423 								// will be *significant*.
424 								function sell(uint256 amount,bool bondType) internal {
425 								    var numEthersBeforeFee = getEtherForTokens(amount);
426 									
427 									// x% of the resulting Ether is used to pay remaining holders.
428 									uint256 fee = 0;
429 									uint256 trickle = 0;
430 									if(totalBondSupply_BEAR != holdings_BEAR[msg.sender]){
431 										fee = fluxFeed(numEthersBeforeFee, true);
432 							        	trickle = div(fee, trickTax);
433 										fee = sub(fee , trickle);
434 										trickling[msg.sender] = add(trickling[msg.sender],trickle);
435 										tricklingSum = add(tricklingSum , trickle);
436 									} 
437 									
438 									// Net Ether for the seller after the fee has been subtracted.
439 							        var numEthers = sub(numEthersBeforeFee , add(fee , trickle));
440 
441 									//How much you bought it for divided by how much you're getting back.
442 									//This means that if you get dumped on, you can get more resolve tokens if you sell out.
443 									uint256 resolved = mint(
444 										calcResolve(msg.sender,amount,numEthers),
445 										msg.sender
446 									);
447 
448 									//#COLORBONUS
449 									/*
450 									souleculeCoreR1[msg.sender] = mul( souleculeCoreR1[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
451 									souleculeCoreG1[msg.sender] = mul( souleculeCoreG1[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
452 									souleculeCoreB1[msg.sender] = mul( souleculeCoreB1[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
453 									souleculeCoreR0[msg.sender] = mul( souleculeCoreR0[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
454 									souleculeCoreG0[msg.sender] = mul( souleculeCoreG0[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
455 									souleculeCoreB0[msg.sender] = mul( souleculeCoreB0[msg.sender] ,sub(holdingsOf(msg.sender), amount) ) / holdingsOf(msg.sender);
456 
457 									souleculeEdgeR1[msg.sender] -= edgePigmentR() * amount/255;
458 									souleculeEdgeG1[msg.sender] -= edgePigmentG() * amount/255;
459 									souleculeEdgeB1[msg.sender] -= edgePigmentB() * amount/255;
460 									souleculeEdgeR0[msg.sender] -= amount-(edgePigmentR() * amount/255);
461 									souleculeEdgeG0[msg.sender] -= amount-(edgePigmentG() * amount/255);
462 									souleculeEdgeB0[msg.sender] -= amount-(edgePigmentB() * amount/255);*/
463 
464 									// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
465 									int256 payoutDiff;
466 									if(bondType){
467 										totalBondSupply_BULL = sub(totalBondSupply_BULL, amount);
468 
469 										avgFactor_ethSpent[msg.sender] = mul( avgFactor_ethSpent[msg.sender] ,sub(holdings_BULL[msg.sender], amount) ) / holdings_BULL[msg.sender];
470 										// Remove the tokens from the balance of the buyer.
471 										holdings_BULL[msg.sender] = sub(holdings_BULL[msg.sender], amount);
472 										
473 									}else{
474 										totalBondSupply_BEAR = sub(totalBondSupply_BEAR, amount);
475 										
476 										avgFactor_ethSpent[msg.sender] = mul( avgFactor_ethSpent[msg.sender] ,sub(holdings_BEAR[msg.sender], amount) ) / holdings_BEAR[msg.sender];
477 										// Remove the tokens from the balance of the buyer.
478 										holdings_BEAR[msg.sender] = sub(holdings_BEAR[msg.sender], amount);
479 									}
480 									fullCycleSellBonds(numEthers);
481 									
482 									// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
483 									// selling tokens, but it guards against division by zero).
484 									if (totalBondSupply_BEAR > 0) {
485 										// Scale the Ether taken as the selling fee by the scaleFactor variable.
486 										var etherFee = mul(fee , scaleFactor);
487 										
488 										// Fee is distributed to all remaining token holders.
489 										// rewardPerShare is the amount gained per token thanks to this sell.
490 										var rewardPerShare = div(etherFee , totalBondSupply_BEAR);
491 										
492 										// The Ether value per token is increased proportionally.
493 										earningsPerBond_BEAR = add(earningsPerBond_BEAR, rewardPerShare);
494 									}
495 									
496 									trickleUp();
497 									emit onTokenSell(msg.sender,add(add(holdings_BULL[msg.sender],holdings_BEAR[msg.sender]),amount),amount,numEthers,bondType,resolved);
498 
499 								}
500 
501 				// Converts the Ether accrued as dividends back into Staking tokens without having to
502 				// withdraw it first. Saves on gas and potential price spike loss.
503 				function reinvest(bool bondType/*, uint256 soulR,uint256 soulG,uint256 soulB*/) internal {
504 					// Retrieve the dividends associated with the address the request came from.
505 					var balance = dividends(msg.sender);
506 					balance = add(balance,tricklePocket[msg.sender]);
507 					tricklingSum = sub(tricklingSum,tricklePocket[msg.sender]);
508 					tricklePocket[msg.sender] = 0;
509 
510 					
511 					// Update the payouts array, incrementing the request address by `balance`.
512 					// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
513 					payouts[msg.sender] += (int256) (balance * scaleFactor);
514 					
515 					// Increase the total amount that's been paid out to maintain invariance.
516 					totalPayouts += (int256) (balance * scaleFactor);
517 					
518 					// Assign balance to a new variable.
519 					uint value_ = (uint) (balance);
520 					
521 					// If your dividends are worth less than 1 szabo, or more than a million Ether
522 					// (in which case, why are you even here), abort.
523 					if (value_ < 0.000001 ether || value_ > 1000000 ether)
524 						revert();
525 						
526 					// msg.sender is the address of the caller.
527 					//var sender = msg.sender;
528 					
529 
530 
531 					uint256 fee = 0; 
532 					uint256 trickle = 0;
533 					if(holdings_BULL[msg.sender] != totalBondSupply_BULL){
534 						fee = fluxFeed(value_, true ); // reinvestment fees are lower than regular ones.
535 						trickle = div(fee, trickTax);
536 						fee = sub(fee , trickle);
537 						trickling[msg.sender] += trickle;
538 					}
539 					
540 
541 					var res = sub(reserve() , balance);
542 					// The amount of Ether used to purchase new tokens for the caller.
543 					var numEther = value_ - fee;
544 					
545 					// The number of tokens which can be purchased for numEther.
546 					var numTokens = calculateDividendTokens(numEther, balance);
547 					
548 					// The buyer fee, scaled by the scaleFactor variable.
549 					var buyerFee = fee * scaleFactor;
550 					
551 					// Check that we have tokens in existence (this should always be true), or
552 					// else you're gonna have a bad time.
553 					if (totalBondSupply_BULL > 0) {
554 						uint256 bonusCoEff;
555 						if(bondType){
556 							// Compute the bonus co-efficient for all existing holders and the buyer.
557 							// The buyer receives part of the distribution for each token bought in the
558 							// same way they would have if they bought each token individually.
559 							bonusCoEff =  (scaleFactor - (res + numEther ) * numTokens * scaleFactor / (totalBondSupply_BULL + totalBondSupply_BEAR  + numTokens) / numEther) * (uint)(crr_d) / (uint)(crr_d-crr_n);
560 						}else{
561 							bonusCoEff = scaleFactor;
562 						}
563 						
564 						// The total reward to be distributed amongst the masses is the fee (in Ether)
565 						// multiplied by the bonus co-efficient.
566 						buyerFee -= fee * bonusCoEff;
567 
568 						// Fee is distributed to all existing token holders before the new tokens are purchased.
569 						// rewardPerShare is the amount gained per token thanks to this buy-in.
570 						
571 						// The Ether value per token is increased proportionally.
572 						earningsPerBond_BULL += fee * bonusCoEff / totalBondSupply_BULL;
573 					}
574 					//resolve reward tracking stuff
575 					avgFactor_ethSpent[msg.sender] = add(avgFactor_ethSpent[msg.sender], numEther);
576 
577 					int256 payoutDiff;
578 					if(bondType){
579 						// Add the numTokens which were just created to the total supply. We're a crypto central bank!
580 						totalBondSupply_BULL = add(totalBondSupply_BULL, numTokens);
581 						// Assign the tokens to the balance of the buyer.
582 						holdings_BULL[msg.sender] = add(holdings_BULL[msg.sender], numTokens);
583 						// Update the payout array so that the buyer cannot claim dividends on previous purchases.
584 						// Also include the fee paid for entering the scheme.
585 						// First we compute how much was just paid out to the buyer...
586 						payoutDiff = (int256) ((earningsPerBond_BULL * numTokens) - buyerFee);
587 					}else{
588 						totalBondSupply_BEAR = add(totalBondSupply_BEAR, numTokens);
589 						holdings_BEAR[msg.sender] = add(holdings_BEAR[msg.sender], numTokens);
590 						payoutDiff = (int256) ((earningsPerBond_BEAR * numTokens) - buyerFee);
591 					}
592 					
593 					/*var averageCostPerToken = div(numTokens , numEther);
594 					var newTokenSum = add(holdings_BULL[sender], numTokens);
595 					var totalSpentBefore = mul(averageBuyInPrice[sender], holdingsOf(sender) );*/
596 					//averageBuyInPrice[sender] = div( totalSpentBefore + mul( averageCostPerToken , numTokens), newTokenSum )  ;
597 					
598 					// Then we update the payouts array for the buyer with this amount...
599 					payouts[msg.sender] += payoutDiff;
600 					
601 					// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
602 					totalPayouts += payoutDiff;
603 
604 					tricklingSum += trickle;//add to trickle's Sum after reserve calculations
605 					trickleUp();
606 					if(bondType){
607 						emit onReinvestment(msg.sender,numEther,numTokens,true);
608 					}else{
609 						emit onReinvestment(msg.sender,numEther,numTokens,false);	
610 					}
611 
612 					//#COLORBONUS
613 					/*
614 					souleculeCoreR1[msg.sender] += soulR * numTokens/255;
615 					souleculeCoreG1[msg.sender] += soulG * numTokens/255;
616 					souleculeCoreB1[msg.sender] += soulB * numTokens/255;
617 					souleculeCoreR0[msg.sender] += numTokens-(soulR * numTokens/255);
618 					souleculeCoreG0[msg.sender] += numTokens-(soulG * numTokens/255);
619 					souleculeCoreB0[msg.sender] += numTokens-(soulB * numTokens/255);
620 
621 					souleculeEdgeR1[msg.sender] += soulR * numEther/255;
622 					souleculeEdgeG1[msg.sender] += soulG * numEther/255;
623 					souleculeEdgeB1[msg.sender] += soulB * numEther/255;
624 					souleculeEdgeR0[msg.sender] += numTokens-(soulR * numEther/255);
625 					souleculeEdgeG0[msg.sender] += numTokens-(soulG * numEther/255);
626 					souleculeEdgeB0[msg.sender] += numTokens-(soulB * numEther/255);*/
627 				}
628 
629 	
630 	// Dynamic value of Ether in reserve, according to the CRR requirement.
631 	function reserve() internal constant returns (uint256 amount){
632 		return sub(balance(),
633 			  ((uint256) ((int256) (earningsPerBond_BULL * totalBondSupply_BULL + earningsPerBond_BEAR * totalBondSupply_BEAR) - totalPayouts ) / scaleFactor) 
634 		);
635 	}
636 
637 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
638 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
639 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
640 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply_BULL + totalBondSupply_BEAR);
641 	}
642 
643 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
644 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
645 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalBondSupply_BULL + totalBondSupply_BEAR);
646 	}
647 
648 	// Converts a number tokens into an Ether value.
649 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
650 		// How much reserve Ether do we have left in the contract?
651 		var reserveAmount = reserve();
652 
653 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
654 		if (tokens == (totalBondSupply_BULL + totalBondSupply_BEAR) )
655 			return reserveAmount;
656 
657 		// If there would be excess Ether left after the transaction this is called within, return the Ether
658 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
659 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
660 		// and denominator altered to 1 and 2 respectively.
661 		return sub(reserveAmount, fixedExp((fixedLog(totalBondSupply_BULL + totalBondSupply_BEAR - tokens) - price_coeff) * crr_d/crr_n));
662 	}
663 
664 	// You don't care about these, but if you really do they're hex values for 
665 	// co-efficients used to simulate approximations of the log and exp functions.
666 	int256  constant one        = 0x10000000000000000;
667 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
668 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
669 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
670 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
671 	int256  constant c1         = 0x1ffffffffff9dac9b;
672 	int256  constant c3         = 0x0aaaaaaac16877908;
673 	int256  constant c5         = 0x0666664e5e9fa0c99;
674 	int256  constant c7         = 0x049254026a7630acf;
675 	int256  constant c9         = 0x038bd75ed37753d68;
676 	int256  constant c11        = 0x03284a0c14610924f;
677 
678 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
679 	// approximates the function log(1+x)-log(1-x)
680 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
681 	function fixedLog(uint256 a) internal pure returns (int256 log) {
682 		int32 scale = 0;
683 		while (a > sqrt2) {
684 			a /= 2;
685 			scale++;
686 		}
687 		while (a <= sqrtdot5) {
688 			a *= 2;
689 			scale--;
690 		}
691 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
692 		var z = (s*s) / one;
693 		return scale * ln2 +
694 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
695 				/one))/one))/one))/one))/one);
696 	}
697 
698 	int256 constant c2 =  0x02aaaaaaaaa015db0;
699 	int256 constant c4 = -0x000b60b60808399d1;
700 	int256 constant c6 =  0x0000455956bccdd06;
701 	int256 constant c8 = -0x000001b893ad04b3a;
702 	
703 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
704 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
705 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
706 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
707 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
708 		a -= scale*ln2;
709 		int256 z = (a*a) / one;
710 		int256 R = ((int256)(2) * one) +
711 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
712 		exp = (uint256) (((R + a) * one) / (R - a));
713 		if (scale >= 0)
714 			exp <<= scale;
715 		else
716 			exp >>= -scale;
717 		return exp;
718 	}
719 	
720 	// The below are safemath implementations of the four arithmetic operators
721 	// designed to explicitly prevent over- and under-flows of integer values.
722 
723 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
724 		if (a == 0) {
725 			return 0;
726 		}
727 		uint256 c = a * b;
728 		assert(c / a == b);
729 		return c;
730 	}
731 
732 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
733 		uint256 c = a / b;
734 		return c;
735 	}
736 
737 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
738 		assert(b <= a);
739 		return a - b;
740 	}
741 
742 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
743 		uint256 c = a + b;
744 		assert(c >= a);
745 		return c;
746 	}
747 
748 	function () payable public {
749 		if (msg.value > 0) {
750 			fund(lastGateway,true);
751 		} else {
752 			withdrawOld(msg.sender);
753 		}
754 	}
755 
756 	uint256 public totalSupply;
757     uint256 constant private MAX_UINT256 = 2**256 - 1;
758     mapping (address => uint256) public balances;
759     mapping (address => mapping (address => uint256)) public allowed;
760     
761     string public name = "0xBabylon";
762     uint8 public decimals = 12;
763     string public symbol = "PoWHr";
764     
765     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
766     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
767     event Resolved(address indexed _owner, uint256 amount);
768     event Burned(address indexed _owner, uint256 amount);
769 
770     function mint(uint256 amount,address _account) internal returns (uint minted){
771     	totalSupply += amount;
772     	balances[_account] += amount;
773     	Resolved(_account,amount);
774     	return amount;
775     }
776 
777 	function burn(uint256 _value) public returns (uint256 amount) {
778         require(balances[msg.sender] >= _value);
779         totalSupply -= _value;
780     	balances[msg.sender] -= _value;
781     	Resolved(msg.sender,_value);
782     	return _value;
783     }
784 
785 	function calcResolve(address _owner,uint256 amount,uint256 _eth) public constant returns (uint256 calculatedResolveTokens) {
786 		return div(div(div(mul(mul(amount,amount),avgFactor_ethSpent[_owner]),holdings_BULL[_owner]+holdings_BEAR[_owner]),_eth),1000000);
787 	}
788 
789 
790     function transfer(address _to, uint256 _value) public returns (bool success) {
791         require(balances[msg.sender] >= _value);
792         balances[msg.sender] -= _value;
793         balances[_to] += _value;
794         emit Transfer(msg.sender, _to, _value);
795         return true;
796     }
797 	
798     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
799         uint256 allowance = allowed[_from][msg.sender];
800         require(balances[_from] >= _value && allowance >= _value);
801         balances[_to] += _value;
802         balances[_from] -= _value;
803         if (allowance < MAX_UINT256) {
804             allowed[_from][msg.sender] -= _value;
805         }
806         emit Transfer(_from, _to, _value);
807         return true;
808     }
809 
810     function approve(address _spender, uint256 _value) public returns (bool success) {
811         allowed[msg.sender][_spender] = _value;
812         emit Approval(msg.sender, _spender, _value);
813         return true;
814     }
815 
816     function balanceOf(address _owner) public view returns (uint256 balance) {
817         return balances[_owner];
818     }
819     function resolveSupply(address _owner) public view returns (uint256 balance) {
820         return totalSupply;
821     }
822 
823     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
824         return allowed[_owner][_spender];
825     }
826 }