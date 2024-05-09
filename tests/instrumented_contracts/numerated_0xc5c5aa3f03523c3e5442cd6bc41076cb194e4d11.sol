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
36     // These functions will be removed in the real thing, they are only here for testing purposes
37     address owner = msg.sender;
38     function Kill() public { if(owner==msg.sender)selfdestruct(owner); }
39     
40     function AddDiv() public payable {
41         require(msg.sender==owner);
42         contractBalance+=msg.value;
43         AddToDividends(msg.value);
44     }
45     
46     function SubDiv(uint256 value) public {
47         require(msg.sender==owner);
48         contractBalance-=value;
49         SubFromDividends(value);
50         msg.sender.transfer(value);
51     }
52     
53     // ---- end of testing functions
54     
55     //helper function used when calculating win amounts
56     function GroupMultiplier(uint number,uint groupID) public pure returns(uint){
57         uint80[12] memory groups=[ //matrix of bet multipliers for each group - 2bits per number
58             0x30c30c30c30c30c30c0, //0: 3rd column
59             0x0c30c30c30c30c30c30, //1: 2nd column
60             0x030c30c30c30c30c30c, //2: 1st column
61             0x0000000000003fffffc, //3: 1st 12
62             0x0000003fffffc000000, //4: 2nd 12
63             0x3fffffc000000000000, //5: 3rd 12
64             0x0000000002aaaaaaaa8, //6: 1 to 18
65             0x2222222222222222220, //7: even
66             0x222208888a222088888, //8: red
67             0x0888a22220888a22220, //9: black
68             0x0888888888888888888, //10: odd
69             0x2aaaaaaaa8000000000  //11: 19 to 36
70         ];
71         return (groups[groupID]>>(number*2))&3; //this function is only public so you can verify that group multipliers are working correctly
72     }
73     
74     //returns a "random" number based on blockhashes and addresses
75     function GetNumber(address adr,uint height) public view returns(uint){
76         bytes32 hash1=block.blockhash(height+1);
77         bytes32 hash2=block.blockhash(height+2);
78         if(hash1==0 || hash2==0)return 69;//if the hash equals zero, it means that its too late now (blockhash can only get most recent 256 blocks)
79         return ((uint)(keccak256(adr,hash1,hash2)))%37;
80     }
81     
82     //returns user's payout from his last bet
83     function BetPayout() public view returns (uint payout) {
84         Bet memory tmp = bets[msg.sender];
85         
86         uint n=GetNumber(msg.sender,tmp.height);
87         if(n==69)return 0; //unable to get blockhash - too late
88         
89         payout=((uint)(tmp.betdata[n]))*36; //if there is a bet on the winning number, set payout to the bet*36
90         for(uint i=37;i<49;i++)payout+=((uint)(tmp.betdata[i]))*GroupMultiplier(n,i-37); //check all groups
91         
92         return payout*tmp.tier;
93     }
94     
95     //claims last bet (if it exists), creates a new one and sends back any leftover balance
96     function PlaceBet(uint tier,bytes betdata) public payable {
97         Bet memory tmp = bets[msg.sender];
98         uint balance=msg.value; //user's balance
99         require(tier<(realReserve()/12500)); //tier has to be 12500 times lower than current balance
100         
101         require((tmp.height+2)<=(block.number-1)); //if there is a bet that can't be claimed yet, revert (this bet must be resolved before placing another one)
102         if(tmp.height!=0&&((block.number-1)>=(tmp.height+2))){ //if there is an unclaimed bet that can be resolved...
103             uint win=BetPayout();
104             
105             if(win>0&&tmp.tier>(realReserve()/12500)){
106                 // tier has to be 12500 times lower than current balance
107                 // if it isnt, refund the bet and cancel the new bet
108                 
109                 //   - this shouldnt ever happen, only in a very specific scenario where
110                 //     most of the people pull out at the same time.
111                 
112                 if(contractBalance>=tmp.value){
113                     bets[msg.sender].height=0; //set bet height to 0 so it can't be claimed again
114                     contractBalance-=tmp.value;
115                     SubFromDividends(tmp.value);
116                     msg.sender.transfer(tmp.value+balance); //refund both last bet and current bet
117                 }else msg.sender.transfer(balance); //if there isnt enough money to refund last bet, then refund at least the new bet
118                                                     //again, this should never happen, its an extreme edge-case
119                                                     //old bet can be claimed later, after the balance increases again
120 
121                 return; //cancel the new bet
122             }
123             
124             balance+=win; //if all is right, add last bet's payout to user's balance
125         }
126         
127         uint betsz=0;
128         for(uint i=0;i<49;i++)betsz+=(uint)(betdata[i]);
129         require(betsz<=50); //bet size can't be greater than 50 "chips"
130         
131         betsz*=tier; //convert chips to wei
132         require(betsz<=balance); //betsz must be smaller or equal to user's current balance
133         
134         tmp.height=block.number; //fill the new bet's structure
135         tmp.value=betsz;
136         tmp.tier=tier;
137         tmp.betdata=betdata;
138         
139         bets[msg.sender]=tmp; //save it to storage
140         
141         balance-=betsz; //balance now contains (msg.value)+(winnings from last bet) - (current bet size)
142         
143         if(balance>0){
144             contractBalance-=balance;
145             if(balance>=msg.value){
146                 contractBalance-=(balance-msg.value);
147                 SubFromDividends(balance-msg.value);
148             }else{
149                 contractBalance+=(msg.value-balance);
150                 AddToDividends(msg.value-balance);
151             }
152 
153             msg.sender.transfer(balance); //send any leftover balance back to the user
154         }else{
155             contractBalance+=msg.value;
156             AddToDividends(msg.value);
157         }
158     }
159     
160     //adds "value" to dividends
161     function AddToDividends(uint256 value) internal {
162         earningsPerToken+=(int256)((value*scaleFactor)/totalSupply);
163     }
164     
165     //subtract "value" from dividends
166     function SubFromDividends(uint256 value)internal {
167         earningsPerToken-=(int256)((value*scaleFactor)/totalSupply);
168     }
169     
170     //claims last bet
171     function ClaimMyBet() public{
172         Bet memory tmp = bets[msg.sender];
173         require((tmp.height+2)<=(block.number-1)); //if it is a bet that can't be claimed yet
174         
175         uint win=BetPayout();
176         
177         if(win>0){
178             if(bets[msg.sender].tier>(realReserve()/12500)){
179                 // tier has to be 12500 times lower than current balance
180                 // if it isnt, refund the bet
181                 
182                 //   - this shouldnt ever happen, only in a very specific scenario where
183                 //     most of the people pull out at the same time.
184                 
185                 if(contractBalance>=tmp.value){
186                     bets[msg.sender].height=0; //set bet height to 0 so it can't be claimed again
187                     contractBalance-=tmp.value;
188                     SubFromDividends(tmp.value);
189                     msg.sender.transfer(tmp.value);
190                 }
191                 
192                 //if the code gets here, it means that there isnt enough balance to refund the bet
193                 //bet can be claimed later, after the balance increases again
194                 return;
195             }
196             
197             bets[msg.sender].height=0; //set bet height to 0 so it can't be claimed again
198             contractBalance-=win;
199             SubFromDividends(win);
200             msg.sender.transfer(win);
201         }
202     }
203     
204     //public function used to fill user interface with data
205     function GetMyBet() public view returns(uint, uint, uint, uint, bytes){
206         return (bets[msg.sender].value,bets[msg.sender].height,bets[msg.sender].tier,BetPayout(),bets[msg.sender].betdata);
207     }
208     
209 //          --- EthPyramid code with fixed compiler warnings and support for negative dividends ---
210 
211 /*
212           ,/`.
213         ,'/ __`.
214       ,'_/_  _ _`.
215     ,'__/_ ___ _  `.
216   ,'_  /___ __ _ __ `.
217  '-.._/___...-"-.-..__`.
218   B
219 
220  EthPyramid. A no-bullshit, transparent, self-sustaining pyramid scheme.
221  
222  Inspired by https://test.jochen-hoenicke.de/eth/ponzitoken/
223 
224  Developers:
225 	Arc
226 	Divine
227 	Norsefire
228 	ToCsIcK
229 	
230  Front-End:
231 	Cardioth
232 	tenmei
233 	Trendium
234 	
235  Moral Support:
236 	DeadCow.Rat
237 	Dots
238 	FatKreamy
239 	Kaseylol
240 	QuantumDeath666
241 	Quentin
242  
243  Shit-Tier:
244 	HentaiChrist
245  
246 */
247     
248     // scaleFactor is used to convert Ether into tokens and vice-versa: they're of different
249 	// orders of magnitude, hence the need to bridge between the two.
250 	uint256 constant scaleFactor = 0x10000000000000000;  // 2^64
251 
252 	// CRR = 50%
253 	// CRR is Cash Reserve Ratio (in this case Crypto Reserve Ratio).
254 	// For more on this: check out https://en.wikipedia.org/wiki/Reserve_requirement
255 	int constant crr_n = 1; // CRR numerator
256 	int constant crr_d = 2; // CRR denominator
257 
258 	// The price coefficient. Chosen such that at 1 token total supply
259 	// the amount in reserve is 0.5 ether and token price is 1 Ether.
260 	int constant price_coeff = -0x296ABF784A358468C;
261 
262 	// Array between each address and their number of tokens.
263 	mapping(address => uint256) public tokenBalance;
264 		
265 	// Array between each address and how much Ether has been paid out to it.
266 	// Note that this is scaled by the scaleFactor variable.
267 	mapping(address => int256) public payouts;
268 
269 	// Variable tracking how many tokens are in existence overall.
270 	uint256 public totalSupply;
271 
272 	// Aggregate sum of all payouts.
273 	// Note that this is scaled by the scaleFactor variable.
274 	int256 totalPayouts;
275 
276 	// Variable tracking how much Ether each token is currently worth.
277 	// Note that this is scaled by the scaleFactor variable.
278 	int256 earningsPerToken;
279 	
280 	// Current contract balance in Ether
281 	uint256 public contractBalance;
282 
283 	// The following functions are used by the front-end for display purposes.
284 
285 	// Returns the number of tokens currently held by _owner.
286 	function balanceOf(address _owner) public constant returns (uint256 balance) {
287 		return tokenBalance[_owner];
288 	}
289 
290 	// Withdraws all dividends held by the caller sending the transaction, updates
291 	// the requisite global variables, and transfers Ether back to the caller.
292 	function withdraw() public {
293 		// Retrieve the dividends associated with the address the request came from.
294 		uint256 balance = dividends(msg.sender);
295 		
296 		// Update the payouts array, incrementing the request address by `balance`.
297 		payouts[msg.sender] += (int256) (balance * scaleFactor);
298 		
299 		// Increase the total amount that's been paid out to maintain invariance.
300 		totalPayouts += (int256) (balance * scaleFactor);
301 		
302 		// Send the dividends to the address that requested the withdraw.
303 		contractBalance = sub(contractBalance, balance);
304 		msg.sender.transfer(balance);
305 	}
306 
307 	// Converts the Ether accrued as dividends back into EPY tokens without having to
308 	// withdraw it first. Saves on gas and potential price spike loss.
309 	function reinvestDividends() public {
310 		// Retrieve the dividends associated with the address the request came from.
311 		uint256 balance = dividends(msg.sender);
312 		
313 		// Update the payouts array, incrementing the request address by `balance`.
314 		// Since this is essentially a shortcut to withdrawing and reinvesting, this step still holds.
315 		payouts[msg.sender] += (int256) (balance * scaleFactor);
316 		
317 		// Increase the total amount that's been paid out to maintain invariance.
318 		totalPayouts += (int256) (balance * scaleFactor);
319 		
320 		// Assign balance to a new variable.
321 		uint value_ = (uint) (balance);
322 		
323 		// If your dividends are worth less than 1 szabo, or more than a million Ether
324 		// (in which case, why are you even here), abort.
325 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
326 			revert();
327 			
328 		// msg.sender is the address of the caller.
329 		address sender = msg.sender;
330 		
331 		// A temporary reserve variable used for calculating the reward the holder gets for buying tokens.
332 		// (Yes, the buyer receives a part of the distribution as well!)
333 		uint256 res = reserve() - balance;
334 
335 		// 10% of the total Ether sent is used to pay existing holders.
336 		uint256 fee = div(value_, 10);
337 		
338 		// The amount of Ether used to purchase new tokens for the caller.
339 		uint256 numEther = value_ - fee;
340 		
341 		// The number of tokens which can be purchased for numEther.
342 		uint256 numTokens = calculateDividendTokens(numEther, balance);
343 		
344 		// The buyer fee, scaled by the scaleFactor variable.
345 		uint256 buyerFee = fee * scaleFactor;
346 		
347 		// Check that we have tokens in existence (this should always be true), or
348 		// else you're gonna have a bad time.
349 		if (totalSupply > 0) {
350 			// Compute the bonus co-efficient for all existing holders and the buyer.
351 			// The buyer receives part of the distribution for each token bought in the
352 			// same way they would have if they bought each token individually.
353 			uint256 bonusCoEff =
354 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
355 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
356 				
357 			// The total reward to be distributed amongst the masses is the fee (in Ether)
358 			// multiplied by the bonus co-efficient.
359 			uint256 holderReward = fee * bonusCoEff;
360 			
361 			buyerFee -= holderReward;
362 
363 			// Fee is distributed to all existing token holders before the new tokens are purchased.
364 			// rewardPerShare is the amount gained per token thanks to this buy-in.
365 			uint256 rewardPerShare = holderReward / totalSupply;
366 			
367 			// The Ether value per token is increased proportionally.
368 			earningsPerToken += (int256)(rewardPerShare);
369 		}
370 		
371 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
372 		totalSupply = add(totalSupply, numTokens);
373 		
374 		// Assign the tokens to the balance of the buyer.
375 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
376 		
377 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
378 		// Also include the fee paid for entering the scheme.
379 		// First we compute how much was just paid out to the buyer...
380 		int256 payoutDiff  = ((earningsPerToken * (int256)(numTokens)) - (int256)(buyerFee));
381 		
382 		// Then we update the payouts array for the buyer with this amount...
383 		payouts[sender] += payoutDiff;
384 		
385 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
386 		totalPayouts    += payoutDiff;
387 		
388 	}
389 
390 	// Sells your tokens for Ether. This Ether is assigned to the callers entry
391 	// in the tokenBalance array, and therefore is shown as a dividend. A second
392 	// call to withdraw() must be made to invoke the transfer of Ether back to your address.
393 	function sellMyTokens() public {
394 		uint256 balance = balanceOf(msg.sender);
395 		sell(balance);
396 	}
397 
398 	// The slam-the-button escape hatch. Sells the callers tokens for Ether, then immediately
399 	// invokes the withdraw() function, sending the resulting Ether to the callers address.
400     function getMeOutOfHere() public {
401 		sellMyTokens();
402         withdraw();
403 	}
404 
405 	// Gatekeeper function to check if the amount of Ether being sent isn't either
406 	// too small or too large. If it passes, goes direct to buy().
407 	function fund() payable public {
408 		// Don't allow for funding if the amount of Ether sent is less than 1 szabo.
409 		if (msg.value > 0.000001 ether) {
410 		    contractBalance = add(contractBalance, msg.value);
411 			buy();
412 		} else {
413 			revert();
414 		}
415     }
416 
417 	// Function that returns the (dynamic) price of buying a finney worth of tokens.
418 	function buyPrice() public constant returns (uint) {
419 		return getTokensForEther(1 finney);
420 	}
421 
422 	// Function that returns the (dynamic) price of selling a single token.
423 	function sellPrice() public constant returns (uint) {
424         uint256 eth;
425         uint256 penalty;
426         (eth,penalty) = getEtherForTokens(1 finney);
427         
428         uint256 fee = div(eth, 10);
429         return eth - fee;
430     }
431 
432 	// Calculate the current dividends associated with the caller address. This is the net result
433 	// of multiplying the number of tokens held by their current value in Ether and subtracting the
434 	// Ether that has already been paid out. Returns 0 in case of negative dividends
435 	function dividends(address _owner) public constant returns (uint256 amount) {
436 	    int256 r=((earningsPerToken * (int256)(tokenBalance[_owner])) - payouts[_owner]) / (int256)(scaleFactor);
437 	    if(r<0)return 0;
438 		return (uint256)(r);
439 	}
440 	
441 	// Returns real dividends, including negative values
442 	function realDividends(address _owner) public constant returns (int256 amount) {
443 	    return (((earningsPerToken * (int256)(tokenBalance[_owner])) - payouts[_owner]) / (int256)(scaleFactor));
444 	}
445 
446 	// Internal balance function, used to calculate the dynamic reserve value.
447 	function balance() internal constant returns (uint256 amount) {
448 		// msg.value is the amount of Ether sent by the transaction.
449 		return contractBalance - msg.value;
450 	}
451 
452 	function buy() internal {
453 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
454 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
455 			revert();
456 						
457 		// msg.sender is the address of the caller.
458 		address sender = msg.sender;
459 		
460 		// 10% of the total Ether sent is used to pay existing holders.
461 		uint256 fee = div(msg.value, 10);
462 		
463 		// The amount of Ether used to purchase new tokens for the caller.
464 		uint256 numEther = msg.value - fee;
465 		
466 		// The number of tokens which can be purchased for numEther.
467 		uint256 numTokens = getTokensForEther(numEther);
468 		
469 		// The buyer fee, scaled by the scaleFactor variable.
470 		uint256 buyerFee = fee * scaleFactor;
471 		
472 		// Check that we have tokens in existence (this should always be true), or
473 		// else you're gonna have a bad time.
474 		if (totalSupply > 0) {
475 			// Compute the bonus co-efficient for all existing holders and the buyer.
476 			// The buyer receives part of the distribution for each token bought in the
477 			// same way they would have if they bought each token individually.
478 			uint256 bonusCoEff =
479 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
480 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
481 				
482 			// The total reward to be distributed amongst the masses is the fee (in Ether)
483 			// multiplied by the bonus co-efficient.
484 			uint256 holderReward = fee * bonusCoEff;
485 			
486 			buyerFee -= holderReward;
487 
488 			// Fee is distributed to all existing token holders before the new tokens are purchased.
489 			// rewardPerShare is the amount gained per token thanks to this buy-in.
490 			uint256 rewardPerShare = holderReward / totalSupply;
491 			
492 			// The Ether value per token is increased proportionally.
493 			earningsPerToken += (int256)(rewardPerShare);
494 			
495 		}
496 
497 		// Add the numTokens which were just created to the total supply. We're a crypto central bank!
498 		totalSupply = add(totalSupply, numTokens);
499 
500 		// Assign the tokens to the balance of the buyer.
501 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
502 
503 		// Update the payout array so that the buyer cannot claim dividends on previous purchases.
504 		// Also include the fee paid for entering the scheme.
505 		// First we compute how much was just paid out to the buyer...
506 		int256 payoutDiff = ((earningsPerToken * (int256)(numTokens)) - (int256)(buyerFee));
507 		
508 		// Then we update the payouts array for the buyer with this amount...
509 		payouts[sender] += payoutDiff;
510 		
511 		// And then we finally add it to the variable tracking the total amount spent to maintain invariance.
512 		totalPayouts    += payoutDiff;
513 		
514 	}
515 
516 	// Sell function that takes tokens and converts them into Ether. Also comes with a 10% fee
517 	// to discouraging dumping, and means that if someone near the top sells, the fee distributed
518 	// will be *significant*.
519 	function sell(uint256 amount) internal {
520 	    // Calculate the amount of Ether that the holders tokens sell for at the current sell price.
521 		uint256 numEthersBeforeFee;
522 		uint256 penalty;
523 		(numEthersBeforeFee,penalty) = getEtherForTokens(amount);
524 		
525 		// 10% of the resulting Ether is used to pay remaining holders, but only if there are any remaining holders.
526 		uint256 fee = 0;
527 		if(amount!=totalSupply) fee = div(numEthersBeforeFee, 10);
528 		
529 		// Net Ether for the seller after the fee has been subtracted.
530         uint256 numEthers = numEthersBeforeFee - fee;
531 		
532 		// *Remove* the numTokens which were just sold from the total supply. We're /definitely/ a crypto central bank.
533 		totalSupply = sub(totalSupply, amount);
534 		
535         // Remove the tokens from the balance of the buyer.
536 		tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
537 
538         // Update the payout array so that the seller cannot claim future dividends unless they buy back in.
539 		// First we compute how much was just paid out to the seller...
540 		int256 payoutDiff = (earningsPerToken * (int256)(amount) + (int256)(numEthers * scaleFactor));
541 		
542         // We reduce the amount paid out to the seller (this effectively resets their payouts value to zero,
543 		// since they're selling all of their tokens). This makes sure the seller isn't disadvantaged if
544 		// they decide to buy back in.
545 		payouts[msg.sender] -= payoutDiff;
546 		
547 		// Decrease the total amount that's been paid out to maintain invariance.
548         totalPayouts -= payoutDiff;
549 		
550 		// Check that we have tokens in existence (this is a bit of an irrelevant check since we're
551 		// selling tokens, but it guards against division by zero).
552 		if (totalSupply > 0) {
553 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
554 			uint256 etherFee = fee * scaleFactor;
555 			
556 			if(penalty>0)etherFee += (penalty * scaleFactor); //if there is any penalty, use it to settle the debt
557 			
558 			// Fee is distributed to all remaining token holders.
559 			// rewardPerShare is the amount gained per token thanks to this sell.
560 			uint256 rewardPerShare = etherFee / totalSupply;
561 			
562 			// The Ether value per token is increased proportionally.
563 			earningsPerToken += (int256)(rewardPerShare);
564 		}else payouts[msg.sender]+=(int256)(penalty); //if he is the last holder, give him his penalty too, so there is no leftover ETH in the contract
565 	}
566 	
567 	//returns value of all dividends currently held by all shareholders
568 	function totalDiv() public view returns (int256){
569 	    return ((earningsPerToken * (int256)(totalSupply))-totalPayouts)/(int256)(scaleFactor);
570 	}
571 	
572 	// Dynamic value of Ether in reserve, according to the CRR requirement. Designed to not decrease token value in case of negative dividends
573 	function reserve() internal constant returns (uint256 amount) {
574 	    int256 divs=totalDiv();
575 	    
576 	    if(divs<0)return balance()+(uint256)(divs*-1);
577 	    return balance()-(uint256)(divs);
578 	}
579 	
580 	// Dynamic value of Ether in reserve, according to the CRR requirement. Returns reserve without negative dividends
581 	function realReserve() public view returns (uint256 amount) {
582 	    int256 divs=totalDiv();
583 	    
584 	    if(divs<0)return balance();
585 	    return balance()-(uint256)(divs);
586 	}
587 
588 	// Calculates the number of tokens that can be bought for a given amount of Ether, according to the
589 	// dynamic reserve and totalSupply values (derived from the buy and sell prices).
590 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
591 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
592 	}
593 
594 	// Semantically similar to getTokensForEther, but subtracts the callers balance from the amount of Ether returned for conversion.
595 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
596 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
597 	}
598 	
599 	// Converts a number tokens into an Ether value. Doesn't account for negative dividends
600 	function getEtherForTokensOld(uint256 tokens) public constant returns (uint256 ethervalue) {
601 		// How much reserve Ether do we have left in the contract?
602 		uint256 reserveAmount = reserve();
603 
604 		// If you're the Highlander (or bagholder), you get The Prize. Everything left in the vault.
605 		if (tokens == totalSupply)
606 			return reserveAmount;
607 
608 		// If there would be excess Ether left after the transaction this is called within, return the Ether
609 		// corresponding to the equation in Dr Jochen Hoenicke's original Ponzi paper, which can be found
610 		// at https://test.jochen-hoenicke.de/eth/ponzitoken/ in the third equation, with the CRR numerator 
611 		// and denominator altered to 1 and 2 respectively.
612 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
613 	}
614 
615 	// Converts a number tokens into an Ether value. Accounts for negative dividends
616 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue,uint256 penalty) {
617 		uint256 eth=getEtherForTokensOld(tokens);
618 		int256 divs=totalDiv();
619 		if(divs>=0)return (eth,0);
620 		
621 		uint256 debt=(uint256)(divs*-1);
622 		penalty=(((debt*scaleFactor)/totalSupply)*tokens)/scaleFactor;
623 		
624 		if(penalty>eth)return (0,penalty);
625 		return (eth-penalty,penalty);
626 	}
627 
628 	// You don't care about these, but if you really do they're hex values for 
629 	// co-efficients used to simulate approximations of the log and exp functions.
630 	int256  constant one        = 0x10000000000000000;
631 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
632 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
633 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
634 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
635 	int256  constant c1         = 0x1ffffffffff9dac9b;
636 	int256  constant c3         = 0x0aaaaaaac16877908;
637 	int256  constant c5         = 0x0666664e5e9fa0c99;
638 	int256  constant c7         = 0x049254026a7630acf;
639 	int256  constant c9         = 0x038bd75ed37753d68;
640 	int256  constant c11        = 0x03284a0c14610924f;
641 
642 	// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
643 	// approximates the function log(1+x)-log(1-x)
644 	// Hence R(s) = log((1+s)/(1-s)) = log(a)
645 	function fixedLog(uint256 a) internal pure returns (int256 log) {
646 		int32 scale = 0;
647 		while (a > sqrt2) {
648 			a /= 2;
649 			scale++;
650 		}
651 		while (a <= sqrtdot5) {
652 			a *= 2;
653 			scale--;
654 		}
655 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
656 		int256 z = (s*s) / one;
657 		return scale * ln2 +
658 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
659 				/one))/one))/one))/one))/one);
660 	}
661 
662 	int256 constant c2 =  0x02aaaaaaaaa015db0;
663 	int256 constant c4 = -0x000b60b60808399d1;
664 	int256 constant c6 =  0x0000455956bccdd06;
665 	int256 constant c8 = -0x000001b893ad04b3a;
666 	
667 	// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
668 	// approximates the function x*(exp(x)+1)/(exp(x)-1)
669 	// Hence exp(x) = (R(x)+x)/(R(x)-x)
670 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
671 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
672 		a -= scale*ln2;
673 		int256 z = (a*a) / one;
674 		int256 R = ((int256)(2) * one) +
675 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
676 		exp = (uint256) (((R + a) * one) / (R - a));
677 		if (scale >= 0)
678 			exp <<= scale;
679 		else
680 			exp >>= -scale;
681 		return exp;
682 	}
683 	
684 	// The below are safemath implementations of the four arithmetic operators
685 	// designed to explicitly prevent over- and under-flows of integer values.
686 
687 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
688 		if (a == 0) {
689 			return 0;
690 		}
691 		uint256 c = a * b;
692 		assert(c / a == b);
693 		return c;
694 	}
695 
696 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
697 		// assert(b > 0); // Solidity automatically throws when dividing by 0
698 		uint256 c = a / b;
699 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
700 		return c;
701 	}
702 
703 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
704 		assert(b <= a);
705 		return a - b;
706 	}
707 
708 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
709 		uint256 c = a + b;
710 		assert(c >= a);
711 		return c;
712 	}
713 
714 	// This allows you to buy tokens by sending Ether directly to the smart contract
715 	// without including any transaction data (useful for, say, mobile wallet apps).
716 	function () payable public {
717 		// msg.value is the amount of Ether sent by the transaction.
718 		if (msg.value > 0) {
719 			fund();
720 		} else {
721 			getMeOutOfHere();
722 		}
723 	}
724 }