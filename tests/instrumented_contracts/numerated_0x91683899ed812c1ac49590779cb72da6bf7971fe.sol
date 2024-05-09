1 pragma solidity ^ 0.6.6;
2 /*
3           ,/`.
4         ,'/ __`.
5       ,'_/__ _ _`.
6     ,'__/__ _ _  _`.
7   ,'_  /___ __ _ __ `.
8  '-.._/___ _ __ __  __`.
9 */
10 
11 contract ColorToken{
12 
13 	mapping(address => uint256) public balances;
14 	mapping(address => uint256) public red;
15 	mapping(address => uint256) public green;
16 	mapping(address => uint256) public blue;
17 
18 	uint public _totalSupply;
19 
20 	mapping(address => mapping(address => uint)) approvals;
21 
22 	event Transfer(
23 		address indexed from,
24 		address indexed to,
25 		uint256 amount,
26 		bytes data
27 	);
28 	
29 	function totalSupply() public view returns (uint256) {
30         return _totalSupply;
31     }
32 
33     function balanceOf(address _owner) public view returns (uint256 balance) {
34 		return balances[_owner];
35 	}
36 
37 	function addColor(address addr, uint amount, uint _red, uint _green, uint _blue) internal {
38 		//adding color values to balance
39 		red[addr] += _red * amount;
40 		green[addr] += _green * amount;
41 		blue[addr] += _blue * amount;
42 	}
43 
44 
45   	function RGB_Ratio() public view returns(uint,uint,uint){
46   		return RGB_Ratio(msg.sender);
47   	}
48 
49   	function RGB_Ratio(address addr) public view returns(uint,uint,uint){
50   		//returns the color of one's tokens
51   		uint weight = balances[addr];
52   		if (weight == 0){
53   			return (0,0,0);
54   		}
55   		return ( red[addr]/weight, green[addr]/weight, blue[addr]/weight);
56   	}
57 
58   	function RGB_scale(address addr, uint numerator, uint denominator) internal view returns(uint,uint,uint){
59 		return (red[addr] * numerator / denominator, green[addr] * numerator / denominator, blue[addr] * numerator / denominator);
60 	}
61 
62 	// Function that is called when a user or another contract wants to transfer funds.
63 	function transfer(address _to, uint _value, bytes memory _data) public virtual returns (bool) {
64 		if( isContract(_to) ){
65 			return transferToContract(_to, _value, _data);
66 		}else{
67 			return transferToAddress(_to, _value, _data);
68 		}
69 	}
70 	
71 	// Standard function transfer similar to ERC20 transfer with no _data.
72 	// Added due to backwards compatibility reasons .
73 	function transfer(address _to, uint _value) public virtual returns (bool) {
74 		//standard function transfer similar to ERC20 transfer with no _data
75 		//added due to backwards compatibility reasons
76 		bytes memory empty;
77 		if(isContract(_to)){
78 			return transferToContract(_to, _value, empty);
79 		}else{
80 			return transferToAddress(_to, _value, empty);
81 		}
82 	}
83 
84 
85 	//function that is called when transaction target is an address
86 	function transferToAddress(address _to, uint _value, bytes memory _data) private returns (bool) {
87 		moveTokens(msg.sender, _to, _value);
88 		emit Transfer(msg.sender, _to, _value, _data);
89 		return true;
90 	}
91 
92 	//function that is called when transaction target is a contract
93 	function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool) {
94 		moveTokens(msg.sender, _to, _value);
95 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
96 		receiver.tokenFallback(msg.sender, _value, _data);
97 		emit Transfer(msg.sender, _to, _value, _data);
98 		return true;
99 	}
100 
101 	function moveTokens(address _from, address _to, uint _amount) internal virtual{
102 		require( _amount <= balances[_from] );
103 
104 		//mix colors
105 		(uint red_ratio, uint green_ratio, uint blue_ratio) = RGB_scale( _from, _amount, balances[_from] );
106 		red[_from] -= red_ratio;
107 		green[_from] -= green_ratio;
108 		blue[_from] -= blue_ratio;
109 		red[_to] += red_ratio;
110 		green[_to] += green_ratio;
111 		blue[_to] += blue_ratio;
112 
113 		//update balances
114 		balances[_from] -= _amount;
115 		balances[_to] += _amount;
116 	}
117 
118     function allowance(address src, address guy) public view returns (uint) {
119         return approvals[src][guy];
120     }
121   	
122     function transferFrom(address src, address dst, uint amount) public returns (bool){
123         address sender = msg.sender;
124         require(approvals[src][sender] >=  amount);
125         require(balances[src] >= amount);
126         approvals[src][sender] -= amount;
127         moveTokens(src,dst,amount);
128         bytes memory empty;
129         emit Transfer(sender, dst, amount, empty);
130         return true;
131     }
132 
133     event Approval(address indexed src, address indexed guy, uint amount);
134     function approve(address guy, uint amount) public returns (bool) {
135         address sender = msg.sender;
136         approvals[sender][guy] = amount;
137 
138         emit Approval( sender, guy, amount );
139         return true;
140     }
141 
142     function isContract(address _addr) public view returns (bool is_contract) {
143 		uint length;
144 		assembly {
145 			//retrieve the size of the code on target address, this needs assembly
146 			length := extcodesize(_addr)
147 		}
148 		if(length>0) {
149 			return true;
150 		}else {
151 			return false;
152 		}
153 	}
154 }
155 
156 contract Pyramid is ColorToken{
157 	// scaleFactor is used to convert Ether into bonds and vice-versa: they're of different
158 	// orders of magnitude, hence the need to bridge between the two.
159 	uint256 constant scaleFactor = 0x10000000000000000;
160 	address payable address0 = address(0);
161 
162     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
163     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
164 
165 	// Typical values that we have to declare.
166 	string constant public name = "Bonds";
167 	string constant public symbol = "BOND";
168 	uint8 constant public decimals = 18;
169 
170 	mapping(address => uint256) public average_ethSpent;
171 	// For calculating hodl multiplier that factors into resolves minted
172 	mapping(address => uint256) public average_buyInTimeSum;
173 	// Array between each address and their number of resolves being staked.
174 	mapping(address => uint256) public resolveWeight;
175 
176 	// Array between each address and how much Ether has been paid out to it.
177 	// Note that this is scaled by the scaleFactor variable.
178 	mapping(address => int256) public payouts;
179 
180 	// The total number of resolves being staked in this contract
181 	uint256 public dissolvingResolves;
182 
183 	// For calculating the hodl multiplier. Weighted average release time
184 	uint public sumOfInputETH;
185 	uint public sumOfInputTime;
186 	uint public sumOfOutputETH;
187 	uint public sumOfOutputTime;
188 
189 	// Something about invarience.
190 	int256 public earningsOffset;
191 
192 	// Variable tracking how much Ether each token is currently worth// Note that this is scaled by the scaleFactor variable.
193 	uint256 public earningsPerResolve;
194 
195 	//The resolve token contract
196 	ResolveToken public resolveToken;
197 
198 	constructor() public{
199 		resolveToken = new ResolveToken( address(this) );
200 	}
201 
202 	function fluxFee(uint paidAmount) public view returns (uint fee) {
203 		//we're only going to count resolve tokens that haven't been burned.
204 		uint totalResolveSupply = resolveToken.totalSupply() - resolveToken.balanceOf( address(0) );
205 		if ( dissolvingResolves == 0 )
206 			return 0;
207 
208 		//the fee is the % of resolve tokens outside of the contract
209 		return paidAmount * ( totalResolveSupply - dissolvingResolves ) / totalResolveSupply * sumOfOutputETH / sumOfInputETH;
210 	}
211 
212 	// Converts the Ether accrued as resolveEarnings back into bonds without having to
213 	// withdraw it first. Saves on gas and potential price spike loss.
214 	event Reinvest( address indexed addr, uint256 reinvested, uint256 dissolved, uint256 bonds, uint256 resolveTax);
215 	function reinvestEarnings(uint amountFromEarnings) public returns(uint,uint){
216 		address sender = msg.sender;
217 		// Retrieve the resolveEarnings associated with the address the request came from.		
218 		uint upScaleDivs = (uint)((int256)( earningsPerResolve * resolveWeight[sender] ) - payouts[sender]);
219 		uint totalEarnings = upScaleDivs / scaleFactor;//resolveEarnings(sender);
220 		require(amountFromEarnings <= totalEarnings, "the amount exceeds total earnings");
221 		uint oldWeight = resolveWeight[sender];
222 		resolveWeight[sender] = oldWeight * (totalEarnings - amountFromEarnings) / totalEarnings;
223 		uint weightDiff = oldWeight - resolveWeight[sender];
224 		resolveToken.transfer( address0, weightDiff );
225 		dissolvingResolves -= weightDiff;
226 		
227 		// something about invariance
228 		int withdrawnEarnings = (int)(upScaleDivs * amountFromEarnings / totalEarnings) - (int)(weightDiff*earningsPerResolve);
229 		payouts[sender] += withdrawnEarnings;
230 		// Increase the total amount that's been paid out to maintain invariance.
231 		earningsOffset += withdrawnEarnings;
232 
233 		// Assign balance to a new variable.
234 		uint value_ = (uint) (amountFromEarnings);
235 
236 		// If your resolveEarnings are worth less than 1 szabo, abort.
237 		if (value_ < 0.000001 ether)
238 			revert();
239 
240 		// Calculate the fee
241 		uint fee = fluxFee(value_);
242 
243 		// The amount of Ether used to purchase new bonds for the caller
244 		uint numEther = value_ - fee;
245 
246 		//resolve reward tracking stuff
247 		average_ethSpent[sender] += numEther;
248 		average_buyInTimeSum[sender] += now * scaleFactor * numEther;
249 		sumOfInputETH += numEther;
250 		sumOfInputTime += now * scaleFactor * numEther;
251 
252 		// The number of bonds which can be purchased for numEther.
253 		uint createdBonds = ethereumToTokens_(numEther);
254 		uint[] memory RGB = new uint[](3);
255   		(RGB[0], RGB[1], RGB[2]) = RGB_Ratio(sender);
256 		
257 		addColor(sender, createdBonds, RGB[0], RGB[1], RGB[2]);
258 
259 		// the variable stoLOGC the amount to be paid to stakers
260 		uint resolveFee;
261 
262 		// Check if we have bonds in existence
263 		if ( dissolvingResolves > 0 ) {
264 			resolveFee = fee * scaleFactor;
265 
266 			// Fee is distributed to all existing resolve stakers before the new bonds are purchased.
267 			// rewardPerResolve is the amount(ETH) gained per resolve token from this purchase.
268 			uint rewardPerResolve = resolveFee / dissolvingResolves;
269 
270 			// The Ether value per token is increased proportionally.
271 			earningsPerResolve += rewardPerResolve;
272 		}
273 
274 		// Add the createdBonds to the total supply.
275 		_totalSupply += createdBonds;
276 
277 		// Assign the bonds to the balance of the buyer.
278 		balances[sender] += createdBonds;
279 
280 		emit Reinvest(sender, value_, weightDiff, createdBonds, resolveFee);
281 		return (createdBonds, weightDiff);
282 	}
283 
284 	// Sells your bonds for Ether
285 	function sellAllBonds() public returns(uint returned_eth, uint returned_resolves, uint initialInput_ETH){
286 		return sell( balanceOf(msg.sender) );
287 	}
288 
289 	function sellBonds(uint amount) public returns(uint returned_eth, uint returned_resolves, uint initialInput_ETH){
290 		require(balanceOf(msg.sender) >= amount, "Amount is more than balance");
291 		( returned_eth, returned_resolves, initialInput_ETH ) = sell(amount);
292 		return (returned_eth, returned_resolves, initialInput_ETH);
293 	}
294 
295 	// Big red exit button to pull all of a holder's Ethereum value from the contract
296 	function getMeOutOfHere() public {
297 		sellAllBonds();
298 		withdraw( resolveEarnings(msg.sender) );
299 	}
300 
301 	// Gatekeeper function to check if the amount of Ether being sent isn't too small
302 	function fund() payable public returns(uint createdBonds){
303 		uint[] memory RGB = new uint[](3);
304   		(RGB[0], RGB[1], RGB[2]) = RGB_Ratio(msg.sender);
305 		return buy(msg.sender, RGB[0], RGB[1], RGB[2]);
306   	}
307  
308 	// Calculate the current resolveEarnings associated with the caller address. This is the net result
309 	// of multiplying the number of resolves held by their current value in Ether and subtracting the
310 	// Ether that has already been paid out.
311 	function resolveEarnings(address _owner) public view returns (uint256 amount) {
312 		return (uint256) ((int256)(earningsPerResolve * resolveWeight[_owner]) - payouts[_owner]) / scaleFactor;
313 	}
314 
315 	event Buy( address indexed addr, uint256 spent, uint256 bonds, uint256 resolveTax);
316 	function buy(address addr, uint _red, uint _green, uint _blue) public payable returns(uint createdBonds){
317 		//make sure the color components don't exceed limits
318 		if(_red>1e18) _red = 1e18;
319 		if(_green>1e18) _green = 1e18;
320 		if(_blue>1e18) _blue = 1e18;
321 		
322 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
323 		if ( msg.value < 0.000001 ether )
324 			revert();
325 
326 		// Calculate the fee
327 		uint fee = fluxFee(msg.value);
328 
329 		// The amount of Ether used to purchase new bonds for the caller.
330 		uint numEther = msg.value - fee;
331 
332 		//resolve reward tracking stuff
333 		uint currentTime = now;
334 		average_ethSpent[addr] += numEther;
335 		average_buyInTimeSum[addr] += currentTime * scaleFactor * numEther;
336 		sumOfInputETH += numEther;
337 		sumOfInputTime += currentTime * scaleFactor * numEther;
338 
339 		// The number of bonds which can be purchased for numEther.
340 		createdBonds = ethereumToTokens_(numEther);
341 		addColor(addr, createdBonds, _red, _green, _blue);
342 
343 		// Add the createdBonds to the total supply.
344 		_totalSupply += createdBonds;
345 
346 		// Assign the bonds to the balance of the buyer.
347 		balances[addr] += createdBonds;
348 
349 		// Check if we have bonds in existence
350 		uint resolveFee;
351 		if (dissolvingResolves > 0) {
352 			resolveFee = fee * scaleFactor;
353 
354 			// Fee is distributed to all existing resolve holders before the new bonds are purchased.
355 			// rewardPerResolve is the amount gained per resolve token from this purchase.
356 			uint rewardPerResolve = resolveFee/dissolvingResolves;
357 
358 			// The Ether value per resolve is increased proportionally.
359 			earningsPerResolve += rewardPerResolve;
360 		}
361 		emit Buy( addr, msg.value, createdBonds, resolveFee);
362 		return createdBonds;
363 	}
364 
365 	function avgHodl() public view returns(uint hodlTime){
366 		return now - (sumOfInputTime - sumOfOutputTime) / (sumOfInputETH - sumOfOutputETH) / scaleFactor;
367 	}
368 
369 	function getReturnsForBonds(address addr, uint bondsReleased) public view returns(uint etherValue, uint mintedResolves, uint new_releaseTimeSum, uint new_releaseAmount, uint initialInput_ETH){
370 		uint output_ETH = tokensToEthereum_(bondsReleased);
371 		uint input_ETH = average_ethSpent[addr] * bondsReleased / balances[addr];
372 		// hodl multiplier. because if you don't hodl at all, you shouldn't be rewarded resolves.
373 		// and the multiplier you get for hodling needs to be relative to the average hodl
374 		uint buyInTime = average_buyInTimeSum[addr] / average_ethSpent[addr];
375 		uint cashoutTime = now * scaleFactor - buyInTime;
376 		uint new_sumOfOutputTime = sumOfOutputTime + average_buyInTimeSum[addr] * bondsReleased / balances[addr];
377 		uint new_sumOfOutputETH = sumOfOutputETH + input_ETH; //It's based on the original ETH, so that's why input_ETH is used. Not output_ETH.
378 		uint averageHoldingTime = now * scaleFactor - ( sumOfInputTime - sumOfOutputTime ) / ( sumOfInputETH - sumOfOutputETH );
379 		return (output_ETH, input_ETH * cashoutTime / averageHoldingTime * input_ETH / output_ETH, new_sumOfOutputTime, new_sumOfOutputETH, input_ETH);
380 	}
381 
382 	event Sell( address indexed addr, uint256 bondsSold, uint256 cashout, uint256 resolves, uint256 resolveTax, uint256 initialCash);
383 	function sell(uint256 amount) internal returns(uint eth, uint resolves, uint initialInput){
384 		address payable sender = msg.sender;
385 	  	// Calculate the amount of Ether & Resolves that the holder's bonds sell for at the current sell price.
386 
387 		uint[] memory UINTs = new uint[](5);
388 		(
389 		UINTs[0]/*ether before fee*/,
390 		UINTs[1]/*minted resolves*/,
391 		UINTs[2]/*new_sumOfOutputTime*/,
392 		UINTs[3]/*new_sumOfOutputETH*/,
393 		UINTs[4]/*initialInput_ETH*/) = getReturnsForBonds(sender, amount);
394 
395 		// calculate the fee
396 	    uint fee = fluxFee(UINTs[0]/*ether before fee*/);
397 
398 		// magic distribution
399 		uint[] memory RGB = new uint[](3);
400   		(RGB[0], RGB[1], RGB[2]) = RGB_Ratio(sender);
401 		resolveToken.mint(sender, UINTs[1]/*minted resolves*/, RGB[0], RGB[1], RGB[2]);
402 
403 		// update weighted average cashout time
404 		sumOfOutputTime = UINTs[2]/*new_sumOfOutputTime*/;
405 		sumOfOutputETH = UINTs[3] /*new_sumOfOutputETH*/;
406 
407 		// reduce the amount of "eth spent" based on the percentage of bonds being sold back into the contract
408 		average_ethSpent[sender] = average_ethSpent[sender] * ( balances[sender] - amount) / balances[sender];
409 		// reduce the "buyInTime" sum that's used for average buy in time
410 		average_buyInTimeSum[sender] = average_buyInTimeSum[sender] * (balances[sender] - amount) / balances[sender];
411 
412 		// Net Ether for the seller after the fee has been subtracted.
413 	    uint numEthers = UINTs[0]/*ether before fee*/ - fee;
414 
415 		// Burn the bonds which were just sold from the total supply.
416 		_totalSupply -= amount;
417 
418 
419 	    // maintain color density
420 	    thinColor( sender, balances[sender] - amount, balances[sender]);
421 	    // Remove the bonds from the balance of the buyer.
422 	    balances[sender] -= amount;
423 
424 		// Check if we have bonds in existence
425 		uint resolveFee;
426 		if ( dissolvingResolves > 0 ){
427 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
428 			resolveFee = fee * scaleFactor;
429 
430 			// Fee is distributed to all remaining resolve holders.
431 			// rewardPerResolve is the amount gained per resolve thanks to this sell.
432 			uint rewardPerResolve = resolveFee/dissolvingResolves;
433 
434 			// The Ether value per resolve is increased proportionally.
435 			earningsPerResolve += rewardPerResolve;
436 		}
437 		
438 		
439 		(bool success, ) = sender.call{value:numEthers}("");
440         require(success, "Transfer failed.");
441 
442 		emit Sell( sender, amount, numEthers, UINTs[1]/*minted resolves*/, resolveFee, UINTs[4] /*initialInput_ETH*/);
443 		return (numEthers, UINTs[1]/*minted resolves*/, UINTs[4] /*initialInput_ETH*/);
444 	}
445 
446 	function thinColor(address addr, uint newWeight, uint oldWeight) internal{
447 		//bonds cease to exist so the color density needs to be updated.
448   		(red[addr], green[addr], blue[addr]) = RGB_scale( addr, newWeight, oldWeight);
449   	}
450 
451 	// Allow contract to accept resolve tokens
452 	event StakeResolves( address indexed addr, uint256 amountStaked, bytes _data );
453 	function tokenFallback(address from, uint value, bytes calldata _data) external{
454 		if(msg.sender == address(resolveToken) ){
455 			resolveWeight[from] += value;
456 			dissolvingResolves += value;
457 
458 			// Then we update the payouts array for the "resolve shareholder" with this amount
459 			int payoutDiff = (int256) (earningsPerResolve * value);
460 			payouts[from] += payoutDiff;
461 			earningsOffset += payoutDiff;
462 
463 			emit StakeResolves(from, value, _data);
464 		}else{
465 			revert("no want");
466 		}
467 	}
468 
469 	// Withdraws resolveEarnings held by the caller sending the transaction, updates
470 	// the requisite global variables, and transfers Ether back to the caller.
471 	event Withdraw( address indexed addr, uint256 earnings, uint256 dissolve );
472 	function withdraw(uint amount) public returns(uint){
473 		address payable sender = msg.sender;
474 		// Retrieve the resolveEarnings associated with the address the request came from.
475 		uint upScaleDivs = (uint)((int256)( earningsPerResolve * resolveWeight[sender] ) - payouts[sender]);
476 		uint totalEarnings = upScaleDivs / scaleFactor;
477 		require( amount <= totalEarnings && amount > 0 );
478 		uint oldWeight = resolveWeight[sender];
479 		resolveWeight[sender] = oldWeight * ( totalEarnings - amount ) / totalEarnings;
480 		uint weightDiff = oldWeight - resolveWeight[sender];
481 		resolveToken.transfer( address0, weightDiff);
482 		dissolvingResolves -= weightDiff;
483 		
484 		// something about invariance
485 		int withdrawnEarnings = (int)(upScaleDivs * amount / totalEarnings) - (int)(weightDiff*earningsPerResolve);
486 		payouts[sender] += withdrawnEarnings;
487 		// Increase the total amount that's been paid out to maintain invariance.
488 		earningsOffset += withdrawnEarnings;
489 
490 
491 		// Send the resolveEarnings to the address that requested the withdraw.
492 		(bool success, ) = sender.call{value: amount}("");
493         require(success, "Transfer failed.");
494 
495 		emit Withdraw( sender, amount, weightDiff);
496 		return weightDiff;
497 	}
498 
499 	event PullResolves( address indexed addr, uint256 pulledResolves, uint256 forfeiture);
500 	function pullResolves(uint amount) public returns (uint forfeiture){
501 		address sender = msg.sender;
502 		uint resolves = resolveWeight[ sender ];
503 		require(amount <= resolves && amount > 0);
504 		require(amount < dissolvingResolves);//"you can't forfeit the last resolve"
505 
506 		uint yourTotalEarnings = (uint)((int256)(resolves * earningsPerResolve) - payouts[sender]);
507 		uint forfeitedEarnings = yourTotalEarnings * amount / resolves;
508 
509 		// Update the payout array so that the "resolve shareholder" cannot claim resolveEarnings on previous staked resolves.
510 		payouts[sender] += (int256)(forfeitedEarnings) - (int256)(earningsPerResolve * amount);
511 
512 		resolveWeight[sender] -= amount;
513 		dissolvingResolves -= amount;
514 		// The Ether value per token is increased proportionally.
515 		earningsPerResolve += forfeitedEarnings / dissolvingResolves;
516 
517 		resolveToken.transfer( sender, amount );
518 		emit PullResolves( sender, amount, forfeitedEarnings / scaleFactor);
519 		return forfeitedEarnings / scaleFactor;
520 	}
521 
522 	function moveTokens(address _from, address _to, uint _amount) internal override{
523 		//mix multi-dimensional bond values
524 		uint totalBonds = balances[_from];
525 		uint ethSpent = average_ethSpent[_from] * _amount / totalBonds;
526 		uint buyInTimeSum = average_buyInTimeSum[_from] * _amount / totalBonds;
527 		average_ethSpent[_from] -= ethSpent;
528 		average_buyInTimeSum[_from] -= buyInTimeSum;
529 		average_ethSpent[_to] += ethSpent;
530 		average_buyInTimeSum[_to] += buyInTimeSum;
531 		super.moveTokens(_from, _to, _amount);
532 	}
533 
534     function buyPrice()
535         public 
536         view 
537         returns(uint256)
538     {
539         // our calculation relies on the token supply, so we need supply. Doh.
540         if(_totalSupply == 0){
541             return tokenPriceInitial_ + tokenPriceIncremental_;
542         } else {
543             uint256 _ethereum = tokensToEthereum_(1e18);
544             uint256 _dividends = fluxFee(_ethereum  );
545             uint256 _taxedEthereum = _ethereum + _dividends;
546             return _taxedEthereum;
547         }
548     }
549 
550     function sellPrice() 
551         public 
552         view 
553         returns(uint256)
554     {
555         // our calculation relies on the token supply, so we need supply. Doh.
556         if(_totalSupply == 0){
557             return tokenPriceInitial_ - tokenPriceIncremental_;
558         } else {
559             uint256 _ethereum = tokensToEthereum_(1e18);
560             uint256 _dividends = fluxFee(_ethereum  );
561             uint256 _taxedEthereum = subtract(_ethereum, _dividends);
562             return _taxedEthereum;
563         }
564     }
565 
566     function calculateTokensReceived(uint256 _ethereumToSpend) 
567         public 
568         view 
569         returns(uint256)
570     {
571         uint256 _dividends = fluxFee(_ethereumToSpend);
572         uint256 _taxedEthereum = subtract(_ethereumToSpend, _dividends);
573         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
574         
575         return _amountOfTokens;
576     }
577     
578 
579     function calculateEthereumReceived(uint256 _tokensToSell) 
580         public 
581         view 
582         returns(uint256)
583     {
584         require(_tokensToSell <= _totalSupply);
585         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
586         uint256 _dividends = fluxFee(_ethereum );
587         uint256 _taxedEthereum = subtract(_ethereum, _dividends);
588         return _taxedEthereum;
589     }
590 
591     function ethereumToTokens_(uint256 _ethereum)
592         internal
593         view
594         returns(uint256)
595     {
596         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
597         uint256 _tokensReceived = 
598          (
599             (
600                 // underflow attempts BTFO
601                 subtract(
602                     (sqrt
603                         (
604                             (_tokenPriceInitial**2)
605                             +
606                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
607                             +
608                             (((tokenPriceIncremental_)**2)*(_totalSupply**2))
609                             +
610                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*_totalSupply)
611                         )
612                     ), _tokenPriceInitial
613                 )
614             )/(tokenPriceIncremental_)
615         )-(_totalSupply)
616         ;
617   
618         return _tokensReceived;
619     }
620 
621     function tokensToEthereum_(uint256 _tokens)
622         internal
623         view
624         returns(uint256)
625     {
626 
627         uint256 tokens_ = (_tokens + 1e18);
628         uint256 _tokenSupply = (_totalSupply + 1e18);
629         uint256 _etherReceived =
630         (
631             // underflow attempts BTFO
632             subtract(
633                 (
634                     (
635                         (
636                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
637                         )-tokenPriceIncremental_
638                     )*(tokens_ - 1e18)
639                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
640             )
641         /1e18);
642         return _etherReceived;
643     }
644 
645     function sqrt(uint x) internal pure returns (uint y) {
646         uint z = (x + 1) / 2;
647         y = x;
648         while (z < y) {
649             y = z;
650             z = (x / z + z) / 2;
651         }
652     }
653 
654     function subtract(uint256 a, uint256 b) internal pure returns (uint256) {
655         assert(b <= a);
656         return a - b;
657     }
658 }
659 
660 contract ResolveToken is ColorToken{
661 
662 	string public name = "Color";
663     string public symbol = "`c";
664     uint8 constant public decimals = 18;
665 	address public hourglass;
666 
667 	constructor(address _hourglass) public{
668 		hourglass = _hourglass;
669 	}
670 
671 	modifier hourglassOnly{
672 	  require(msg.sender == hourglass);
673 	  _;
674     }
675 
676 	event Mint(
677 		address indexed addr,
678 		uint256 amount
679 	);
680 
681 	function mint(address _address, uint _value, uint _red, uint _green, uint _blue) external hourglassOnly(){
682 		balances[_address] += _value;
683 		_totalSupply += _value;
684 		addColor(_address, _value, _red, _green, _blue);
685 		emit Mint(_address, _value);
686 	}
687 }
688 
689 abstract contract ERC223ReceivingContract{
690     function tokenFallback(address _from, uint _value, bytes calldata _data) external virtual;
691 }