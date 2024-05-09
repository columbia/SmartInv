1 pragma solidity ^0.4.19;
2 
3 /*
4     Our Roulette - A decentralized, crowdfunded game of Roulette
5     
6     Developer:
7         Dadas1337
8         
9     Thanks to:
10     
11         FrontEnd help & tips:
12             CiernaOvca
13             Matt007
14             Kebabist
15             
16         Chief-Shiller:
17             M.Tejas
18             
19         Auditor:
20             Inventor
21             
22     If the website ever goes down for any reason, just send a 0 ETH transaction
23     with no data and at least 150 000 GAS to the contract address.
24     Your shares will be sold and dividends withdrawn.
25 */
26 
27 contract OurRoulette{
28     struct Bet{
29         uint value;
30         uint height; //result of a bet placed at height is determined by blocks at height+1 and height+2, bet can be resolved from height+3 upwards..
31         uint tier; //min bet amount
32         bytes betdata;
33     }
34     mapping (address => Bet) bets;
35     
36     //helper function used when calculating win amounts
37     function GroupMultiplier(uint number,uint groupID) public pure returns(uint){
38         uint80[12] memory groups=[ //matrix of bet multipliers for each group - 2bits per number
39             0x30c30c30c30c30c30c0, //0: 3rd column
40             0x0c30c30c30c30c30c30, //1: 2nd column
41             0x030c30c30c30c30c30c, //2: 1st column
42             0x0000000000003fffffc, //3: 1st 12
43             0x0000003fffffc000000, //4: 2nd 12
44             0x3fffffc000000000000, //5: 3rd 12
45             0x0000000002aaaaaaaa8, //6: 1 to 18
46             0x2222222222222222220, //7: even
47             0x222208888a222088888, //8: red
48             0x0888a22220888a22220, //9: black
49             0x0888888888888888888, //10: odd
50             0x2aaaaaaaa8000000000  //11: 19 to 36
51         ];
52         return (groups[groupID]>>(number*2))&3; //this function is only public so you can verify that group multipliers are working correctly
53     }
54     
55     //returns a "random" number based on blockhashes and addresses
56     function GetNumber(address adr,uint height) public view returns(uint){
57         bytes32 hash1=block.blockhash(height+1);
58         bytes32 hash2=block.blockhash(height+2);
59         if(hash1==0 || hash2==0)return 69;//if the hash equals zero, it means that its too late now (blockhash can only get most recent 256 blocks)
60         return ((uint)(keccak256(adr,hash1,hash2)))%37;
61     }
62     
63     //returns user's payout from his last bet
64     function BetPayout() public view returns (uint payout) {
65         Bet memory tmp = bets[msg.sender];
66         
67         uint n=GetNumber(msg.sender,tmp.height);
68         if(n==69)return 0; //unable to get blockhash - too late
69         
70         payout=((uint)(tmp.betdata[n]))*36; //if there is a bet on the winning number, set payout to the bet*36
71         for(uint i=37;i<49;i++)payout+=((uint)(tmp.betdata[i]))*GroupMultiplier(n,i-37); //check all groups
72         
73         return payout*tmp.tier;
74     }
75     
76     //claims last bet (if it exists), creates a new one and sends back any leftover balance
77     function PlaceBet(uint tier,bytes betdata) public payable {
78         Bet memory tmp = bets[msg.sender];
79         uint balance=msg.value; //user's balance
80         require(tier<(realReserve()/12500)); //tier has to be 12500 times lower than current balance
81         
82         require((tmp.height+2)<=(block.number-1)); //if there is a bet that can't be claimed yet, revert (this bet must be resolved before placing another one)
83         if(tmp.height!=0&&((block.number-1)>=(tmp.height+2))){ //if there is an unclaimed bet that can be resolved...
84             uint win=BetPayout();
85             
86             if(win>0&&tmp.tier>(realReserve()/12500)){
87                 // tier has to be 12500 times lower than current balance
88                 // if it isnt, refund the bet and cancel the new bet
89                 
90                 //   - this shouldnt ever happen, only in a very specific scenario where
91                 //     most of the people pull out at the same time.
92                 
93                 if(realReserve()>=tmp.value){
94                     bets[msg.sender].height=0; //set bet height to 0 so it can't be claimed again
95                     contractBalance-=tmp.value;
96                     SubFromDividends(tmp.value);
97                     msg.sender.transfer(tmp.value+balance); //refund both last bet and current bet
98                 }else msg.sender.transfer(balance); //if there isnt enough money to refund last bet, then refund at least the new bet
99                                                     //again, this should never happen, its an extreme edge-case
100                                                     //old bet can be claimed later, after the balance increases again
101 
102                 return; //cancel the new bet
103             }
104             
105             balance+=win; //if all is right, add last bet's payout to user's balance
106         }
107         
108         uint betsz=0;
109         for(uint i=0;i<49;i++)betsz+=(uint)(betdata[i]);
110         require(betsz<=50); //bet size can't be greater than 50 "chips"
111         
112         betsz*=tier; //convert chips to wei
113         require(betsz<=balance); //betsz must be smaller or equal to user's current balance
114         
115         tmp.height=block.number; //fill the new bet's structure
116         tmp.value=betsz;
117         tmp.tier=tier;
118         tmp.betdata=betdata;
119         
120         bets[msg.sender]=tmp; //save it to storage
121         
122         balance-=betsz; //balance now contains (msg.value)+(winnings from last bet) - (current bet size)
123         
124         if(balance>0){
125             contractBalance-=balance;
126             if(balance>=msg.value){
127                 contractBalance-=(balance-msg.value);
128                 SubFromDividends(balance-msg.value);
129             }else{
130                 contractBalance+=(msg.value-balance);
131                 AddToDividends(msg.value-balance);
132             }
133 
134             msg.sender.transfer(balance); //send any leftover balance back to the user
135         }else{
136             contractBalance+=msg.value;
137             AddToDividends(msg.value);
138         }
139     }
140     
141     //adds "value" to dividends
142     function AddToDividends(uint256 value) internal {
143         earningsPerToken+=(int256)((value*scaleFactor)/totalSupply);
144     }
145     
146     //subtract "value" from dividends
147     function SubFromDividends(uint256 value)internal {
148         earningsPerToken-=(int256)((value*scaleFactor)/totalSupply);
149     }
150     
151     //claims last bet
152     function ClaimMyBet() public{
153         Bet memory tmp = bets[msg.sender];
154         require((tmp.height+2)<=(block.number-1)); //if it is a bet that can't be claimed yet
155         
156         uint win=BetPayout();
157         
158         if(win>0){
159             if(bets[msg.sender].tier>(realReserve()/12500)){
160                 // tier has to be 12500 times lower than current balance
161                 // if it isnt, refund the bet
162                 
163                 //   - this shouldnt ever happen, only in a very specific scenario where
164                 //     most of the people pull out at the same time.
165                 
166                 if(realReserve()>=tmp.value){
167                     bets[msg.sender].height=0; //set bet height to 0 so it can't be claimed again
168                     contractBalance-=tmp.value;
169                     SubFromDividends(tmp.value);
170                     msg.sender.transfer(tmp.value);
171                 }
172                 
173                 //if the code gets here, it means that there isnt enough balance to refund the bet
174                 //bet can be claimed later, after the balance increases again
175                 return;
176             }
177             
178             bets[msg.sender].height=0; //set bet height to 0 so it can't be claimed again
179             contractBalance-=win;
180             SubFromDividends(win);
181             msg.sender.transfer(win);
182         }
183     }
184     
185     //public function used to fill user interface with data
186     function GetMyBet() public view returns(uint, uint, uint, uint, bytes){
187         return (bets[msg.sender].value,bets[msg.sender].height,bets[msg.sender].tier,BetPayout(),bets[msg.sender].betdata);
188     }
189     
190 //          --- EthPyramid code with fixed compiler warnings and support for negative dividends ---
191 
192 /*
193           ,/`.
194         ,'/ __`.
195       ,'_/_  _ _`.
196     ,'__/_ ___ _  `.
197   ,'_  /___ __ _ __ `.
198  '-.._/___...-"-.-..__`.
199   B
200 
201  EthPyramid. A no-bullshit, transparent, self-sustaining pyramid scheme.
202  
203  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
204 
205  Developers:
206 	Arc
207 	Divine
208 	Norsefire
209 	ToCsIcK
210 	
211  Front-End:
212 	Cardioth
213 	tenmei
214 	Trendium
215 	
216  Moral Support:
217 	DeadCow.Rat
218 	Dots
219 	FatKreamy
220 	Kaseylol
221 	QuantumDeath666
222 	Quentin
223  
224  Shit-Tier:
225 	HentaiChrist
226  
227 */
228     
229     // scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
230 	// orders of magnitude, hence the need to bridge between the two.
231 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
232 
233 	// CRR = 50%
234 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
235 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
236 	int constant crr_n = 1; // CRR numerator
237 	int constant crr_d = 2; // CRR denominator
238 
239 	// The price coefficient. Chosen such that at 1 token total supply
240 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
241 	int constant price_coeff = -0x296ABF784A358468C;
242 
243 	// Array between each address and their number of tokens.
244 	mapping(address => uint256) public tokenBalance;
245 		
246 	// Array between each address and how much Ether has been paid out to it.
247 	// Note that this is scaled by the scaleFactor variable.
248 	mapping(address => int256) public payouts;
249 
250 	// Variable tracking how many tokens are in existence overall.
251 	uint256 public totalSupply;
252 
253 	// Aggregate sum of all payouts.
254 	// Note that this is scaled by the scaleFactor variable.
255 	int256 totalPayouts;
256 
257 	// Variable tracking how much Ether each token is currently worth.
258 	// Note that this is scaled by the scaleFactor variable.
259 	int256 earningsPerToken;
260 	
261 	// Current contract balance in Ether
262 	uint256 public contractBalance;
263 
264 	// The following functions are used by the front-end for display purposes.
265 
266 	// Returns the number of tokens currently held by _owner.
267 	function balanceOf(address _owner) public constant returns (uint256 balance) {
268 		return tokenBalance[_owner];
269 	}
270 
271 	// Withdraws all dividends held by the caller sending the transaction, updates
272 	// the requisite global variables, and transfers Ether back to the caller.
273 	function withdraw() public {
274 		// Retrieve the dividends associated with the address the request came from.
275 		uint256 balance = dividends(msg.sender);
276 		
277 		// Update the payouts array, incrementing the request address by `balance`.
278 		payouts[msg.sender] += (int256) (balance * scaleFactor);
279 		
280 		// Increase the total amount that's been paid out to maintain invariance.
281 		totalPayouts += (int256) (balance * scaleFactor);
282 		
283 		// Send the dividends to the address that requested the withdraw.
284 		contractBalance = sub(contractBalance, balance);
285 		msg.sender.transfer(balance);
286 	}
287 
288 	// Converts the Ether accrued as dividends back into EPY tokens without having to
289 	// withdraw it first. Saves on gas and potential price spike loss.
290 	function reinvestDividends() public {
291 		// Retrieve the dividends associated with the address the request came from.
292 		uint256 balance = dividends(msg.sender);
293 		
294 		// Update the payouts array, incrementing the request address by `balance`.
295 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
296 		payouts[msg.sender] += (int256) (balance * scaleFactor);
297 		
298 		// Increase the total amount that's been paid out to maintain invariance.
299 		totalPayouts += (int256) (balance * scaleFactor);
300 		
301 		// Assign balance to a new variable.
302 		uint value_ = (uint) (balance);
303 		
304 		// If your dividends are worth less than 1 szabo, or more than a million Ether
305 		// (in which case, why are you even here), abort.
306 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
307 			revert();
308 			
309 		// msg.sender is the address of the caller.
310 		address sender = msg.sender;
311 		
312 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
313 		// (Yes, the buyer receives a part of the distribution as well!)
314 		uint256 res = reserve() - balance;
315 
316 		// 10% of the total Ether sent is used to pay existing holders.
317 		uint256 fee = div(value_, 10);
318 		
319 		// The amount of Ether used to purchase new tokens for the caller.
320 		uint256 numEther = value_ - fee;
321 		
322 		// The number of tokens which can be purchased for numEther.
323 		uint256 numTokens = calculateDividendTokens(numEther, balance);
324 		
325 		// The buyer fee, scaled by the scaleFactor variable.
326 		uint256 buyerFee = fee * scaleFactor;
327 		
328 		// Check that we have tokens in existence (this should always be true), or
329 		// else you're gonna have a bad time.
330 		if (totalSupply > 0) {
331 			// Compute the bonus co-efficient for all existing holders and the buyer.
332 			// The buyer receives part of the distribution for each token bought in the
333 			// same way they would have if they bought each token individually.
334 			uint256 bonusCoEff =
335 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
336 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
337 				
338 			// The total reward to be distributed amongst the masses is the fee (in Ether)
339 			// multiplied by the bonus co-efficient.
340 			uint256 holderReward = fee * bonusCoEff;
341 			
342 			buyerFee -= holderReward;
343 
344 			// Fee is distributed to all existing token holders before the new tokens are purchased.
345 			// rewardPerShare is the amount gained per token thanks to this buy-in.
346 			uint256 rewardPerShare = holderReward / totalSupply;
347 			
348 			// The Ether value per token is increased proportionally.
349 			earningsPerToken += (int256)(rewardPerShare);
350 		}
351 		
352 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
353 		totalSupply = add(totalSupply, numTokens);
354 		
355 		// Assign the tokens to the balance of the buyer.
356 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
357 		
358 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
359 		// Also include the fee paid for entering the scheme.
360 		// First we compute how much was just paid out to the buyer...
361 		int256 payoutDiff  = ((earningsPerToken * (int256)(numTokens)) - (int256)(buyerFee));
362 		
363 		// Then we update the payouts array for the buyer with this amount...
364 		payouts[sender] += payoutDiff;
365 		
366 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
367 		totalPayouts    += payoutDiff;
368 		
369 	}
370 
371 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
372 	// in the tokenBalance array, and therefore is shown as a dividend. A second
373 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
374 	function sellMyTokens() public {
375 		uint256 balance = balanceOf(msg.sender);
376 		sell(balance);
377 	}
378 
379 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
380 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
381     function getMeOutOfHere() public {
382 		sellMyTokens();
383         withdraw();
384 	}
385 
386 	// Gatekeeper function to check if the amount of Ether being sent isn't either
387 	// too small or too large. If it passes, goes direct to buy().
388 	function fund() payable public {
389 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
390 		if (msg.value > 0.000001 ether) {
391 		    contractBalance = add(contractBalance, msg.value);
392 			buy();
393 		} else {
394 			revert();
395 		}
396     }
397 
398 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
399 	function buyPrice() public constant returns (uint) {
400 		return getTokensForEther(1 finney);
401 	}
402 
403 	// Function that returns the (dynamic) price of selling a single token.
404 	function sellPrice() public constant returns (uint) {
405         uint256 eth;
406         uint256 penalty;
407         (eth,penalty) = getEtherForTokens(1 finney);
408         
409         uint256 fee = div(eth, 10);
410         return eth - fee;
411     }
412 
413 	// Calculate the current dividends associated with the caller address. This is the net result
414 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
415 	// Ether that has already been paid out. Returns 0 in case of negative dividends
416 	function dividends(address _owner) public constant returns (uint256 amount) {
417 	    int256 r=((earningsPerToken * (int256)(tokenBalance[_owner])) - payouts[_owner]) / (int256)(scaleFactor);
418 	    if(r<0)return 0;
419 		return (uint256)(r);
420 	}
421 	
422 	// Returns real dividends, including negative values
423 	function realDividends(address _owner) public constant returns (int256 amount) {
424 	    return (((earningsPerToken * (int256)(tokenBalance[_owner])) - payouts[_owner]) / (int256)(scaleFactor));
425 	}
426 
427 	// Internal balance function, used to calculate the dynamic reserve value.
428 	function balance() internal constant returns (uint256 amount) {
429 		// msg.value is the amount of Ether sent by the transaction.
430 		return contractBalance - msg.value;
431 	}
432 
433 	function buy() internal {
434 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
435 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
436 			revert();
437 						
438 		// msg.sender is the address of the caller.
439 		address sender = msg.sender;
440 		
441 		// 10% of the total Ether sent is used to pay existing holders.
442 		uint256 fee = div(msg.value, 10);
443 		
444 		// The amount of Ether used to purchase new tokens for the caller.
445 		uint256 numEther = msg.value - fee;
446 		
447 		// The number of tokens which can be purchased for numEther.
448 		uint256 numTokens = getTokensForEther(numEther);
449 		
450 		// The buyer fee, scaled by the scaleFactor variable.
451 		uint256 buyerFee = fee * scaleFactor;
452 		
453 		// Check that we have tokens in existence (this should always be true), or
454 		// else you're gonna have a bad time.
455 		if (totalSupply > 0) {
456 			// Compute the bonus co-efficient for all existing holders and the buyer.
457 			// The buyer receives part of the distribution for each token bought in the
458 			// same way they would have if they bought each token individually.
459 			uint256 bonusCoEff =
460 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
461 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
462 				
463 			// The total reward to be distributed amongst the masses is the fee (in Ether)
464 			// multiplied by the bonus co-efficient.
465 			uint256 holderReward = fee * bonusCoEff;
466 			
467 			buyerFee -= holderReward;
468 
469 			// Fee is distributed to all existing token holders before the new tokens are purchased.
470 			// rewardPerShare is the amount gained per token thanks to this buy-in.
471 			uint256 rewardPerShare = holderReward / totalSupply;
472 			
473 			// The Ether value per token is increased proportionally.
474 			earningsPerToken += (int256)(rewardPerShare);
475 			
476 		}
477 
478 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
479 		totalSupply = add(totalSupply, numTokens);
480 
481 		// Assign the tokens to the balance of the buyer.
482 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
483 
484 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
485 		// Also include the fee paid for entering the scheme.
486 		// First we compute how much was just paid out to the buyer...
487 		int256 payoutDiff = ((earningsPerToken * (int256)(numTokens)) - (int256)(buyerFee));
488 		
489 		// Then we update the payouts array for the buyer with this amount...
490 		payouts[sender] += payoutDiff;
491 		
492 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
493 		totalPayouts    += payoutDiff;
494 		
495 	}
496 
497 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
498 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
499 	// will be *significant*.
500 	function sell(uint256 amount) internal {
501 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
502 		uint256 numEthersBeforeFee;
503 		uint256 penalty;
504 		(numEthersBeforeFee,penalty) = getEtherForTokens(amount);
505 		
506 		// 10% of the resulting Ether is used to pay remaining holders, but only if there are any remaining holders.
507 		uint256 fee = 0;
508 		if(amount!=totalSupply) fee = div(numEthersBeforeFee, 10);
509 		
510 		// Net Ether for the seller after the fee has been subtracted.
511         uint256 numEthers = numEthersBeforeFee - fee;
512 		
513 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
514 		totalSupply = sub(totalSupply, amount);
515 		
516         // Remove the tokens from the balance of the buyer.
517 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
518 
519         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
520 		// First we compute how much was just paid out to the seller...
521 		int256 payoutDiff = (earningsPerToken * (int256)(amount) + (int256)(numEthers * scaleFactor));
522 		
523         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
524 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
525 		// they decide to buy back in.
526 		payouts[msg.sender] -= payoutDiff;
527 		
528 		// Decrease the total amount that's been paid out to maintain invariance.
529         totalPayouts -= payoutDiff;
530 		
531 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
532 		// selling tokens, but it guards against division by zero).
533 		if (totalSupply > 0) {
534 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
535 			uint256 etherFee = fee * scaleFactor;
536 			
537 			if(penalty>0)etherFee += (penalty * scaleFactor); //if there is any penalty, use it to settle the debt
538 			
539 			// Fee is distributed to all remaining token holders.
540 			// rewardPerShare is the amount gained per token thanks to this sell.
541 			uint256 rewardPerShare = etherFee / totalSupply;
542 			
543 			// The Ether value per token is increased proportionally.
544 			earningsPerToken += (int256)(rewardPerShare);
545 		}else payouts[msg.sender]+=(int256)(penalty); //if he is the last holder, give him his penalty too, so there is no leftover ETH in the contract
546 		
547 		int256 afterdiv=realDividends(msg.sender); //get his dividends - after this sale
548 		if(afterdiv<0){
549 		     //if he was so deeply in debt, that even after selling his share, he still doesn't break even,
550 		     //then we have to spread his debt between other users to maintain invariance
551 		     SubFromDividends((uint256)(afterdiv*-1));
552 		     totalPayouts -= payouts[msg.sender];
553 		     payouts[msg.sender]=0;
554 		     //again, this shouldnt ever happen. It is not possible to win in the Roulette so much,
555 		     //that this scenario will happen. I have only managed to reach it by using the testing functions,
556 		     //SubDiv() - removed on mainnet contract
557 		}
558 	}
559 	
560 	//returns value of all dividends currently held by all shareholders
561 	function totalDiv() public view returns (int256){
562 	    return ((earningsPerToken * (int256)(totalSupply))-totalPayouts)/(int256)(scaleFactor);
563 	}
564 	
565 	// Dynamic value of Ether in reserve, according to the CRR requirement. Designed to not decrease token value in case of negative dividends
566 	function reserve() internal constant returns (uint256 amount) {
567 	    int256 divs=totalDiv();
568 	    
569 	    if(divs<0)return balance()+(uint256)(divs*-1);
570 	    return balance()-(uint256)(divs);
571 	}
572 	
573 	// Dynamic value of Ether in reserve, according to the CRR requirement. Returns reserve including negative dividends
574 	function realReserve() public view returns (uint256 amount) {
575 	    int256 divs=totalDiv();
576 	    
577 	    if(divs<0){
578 	        uint256 udivs=(uint256)(divs*-1);
579 	        uint256 b=balance();
580 	        if(b<udivs)return 0;
581 	        return b-udivs;
582 	    }
583 	    return balance()-(uint256)(divs);
584 	}
585 
586 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
587 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
588 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
589 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
590 	}
591 
592 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
593 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
594 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
595 	}
596 	
597 	// Converts a number tokens into an Ether value. Doesn't account for negative dividends
598 	function getEtherForTokensOld(uint256 tokens) public constant returns (uint256 ethervalue) {
599 		// How much reserve Ether do we have left in the contract?
600 		uint256 reserveAmount = reserve();
601 
602 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
603 		if (tokens == totalSupply)
604 			return reserveAmount;
605 
606 		// If there would be excess Ether left after the transaction this is called within, return the Ether
607 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
608 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
609 		// and denominator altered to 1 and 2 respectively.
610 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
611 	}
612 
613 	// Converts a number tokens into an Ether value. Accounts for negative dividends
614 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue,uint256 penalty) {
615 		uint256 eth=getEtherForTokensOld(tokens);
616 		int256 divs=totalDiv();
617 		if(divs>=0)return (eth,0);
618 		
619 		uint256 debt=(uint256)(divs*-1);
620 		penalty=(((debt*scaleFactor)/totalSupply)*tokens)/scaleFactor;
621 		
622 		if(penalty>eth)return (0,penalty);
623 		return (eth-penalty,penalty);
624 	}
625 
626 	// You don't care about these, but if you really do they're hex values for 
627 	// co-efficients used to simulate approximations of the log and exp functions.
628 	int256  constant one        = 0x10000000000000000;
629 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
630 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
631 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
632 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
633 	int256  constant c1         = 0x1ffffffffff9dac9b;
634 	int256  constant c3         = 0x0aaaaaaac16877908;
635 	int256  constant c5         = 0x0666664e5e9fa0c99;
636 	int256  constant c7         = 0x049254026a7630acf;
637 	int256  constant c9         = 0x038bd75ed37753d68;
638 	int256  constant c11        = 0x03284a0c14610924f;
639 
640 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
641 	// approximates the function log(1+x)-log(1-x)
642 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
643 	function fixedLog(uint256 a) internal pure returns (int256 log) {
644 		int32 scale = 0;
645 		while (a > sqrt2) {
646 			a /= 2;
647 			scale++;
648 		}
649 		while (a <= sqrtdot5) {
650 			a *= 2;
651 			scale--;
652 		}
653 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
654 		int256 z = (s*s) / one;
655 		return scale * ln2 +
656 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
657 				/one))/one))/one))/one))/one);
658 	}
659 
660 	int256 constant c2 =  0x02aaaaaaaaa015db0;
661 	int256 constant c4 = -0x000b60b60808399d1;
662 	int256 constant c6 =  0x0000455956bccdd06;
663 	int256 constant c8 = -0x000001b893ad04b3a;
664 	
665 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
666 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
667 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
668 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
669 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
670 		a -= scale*ln2;
671 		int256 z = (a*a) / one;
672 		int256 R = ((int256)(2) * one) +
673 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
674 		exp = (uint256) (((R + a) * one) / (R - a));
675 		if (scale >= 0)
676 			exp <<= scale;
677 		else
678 			exp >>= -scale;
679 		return exp;
680 	}
681 	
682 	// The below are safemath implementations of the four arithmetic operators
683 	// designed to explicitly prevent over- and under-flows of integer values.
684 
685 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
686 		if (a == 0) {
687 			return 0;
688 		}
689 		uint256 c = a * b;
690 		assert(c / a == b);
691 		return c;
692 	}
693 
694 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
695 		// assert(b > 0); // Solidity automatically throws when dividing by 0
696 		uint256 c = a / b;
697 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
698 		return c;
699 	}
700 
701 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
702 		assert(b <= a);
703 		return a - b;
704 	}
705 
706 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
707 		uint256 c = a + b;
708 		assert(c >= a);
709 		return c;
710 	}
711 
712 	// This allows you to buy tokens by sending Ether directly to the smart contract
713 	// without including any transaction data (useful for, say, mobile wallet apps).
714 	function () payable public {
715 		// msg.value is the amount of Ether sent by the transaction.
716 		if (msg.value > 0) {
717 			fund();
718 		} else {
719 			getMeOutOfHere();
720 		}
721 	}
722 }