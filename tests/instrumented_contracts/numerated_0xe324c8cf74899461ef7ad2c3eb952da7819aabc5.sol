1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-25
3 */
4 
5 pragma solidity ^ 0.6.6;
6 /*
7           ,/`.
8         ,'/ __`.
9       ,'_/__ _ _`.
10     ,'__/__ _ _  _`.
11   ,'_  /___ __ _ __ `.
12  '-.._/___ _ __ __  __`.
13 */
14 
15 contract ColorToken{
16 
17 	mapping(address => uint256) public balances;
18 	mapping(address => uint256) public red;
19 	mapping(address => uint256) public green;
20 	mapping(address => uint256) public blue;
21 
22 	uint public _totalSupply;
23 
24 	mapping(address => mapping(address => uint)) approvals;
25 
26 	event Transfer(
27 		address indexed from,
28 		address indexed to,
29 		uint256 amount,
30 		bytes data
31 	);
32 	
33 	function totalSupply() public view returns (uint256) {
34         return _totalSupply;
35     }
36 
37     function balanceOf(address _owner) public view returns (uint256 balance) {
38 		return balances[_owner];
39 	}
40 
41 	function addColor(address addr, uint amount, uint _red, uint _green, uint _blue) internal {
42 		//adding color values to balance
43 		red[addr] += _red * amount;
44 		green[addr] += _green * amount;
45 		blue[addr] += _blue * amount;
46 	}
47 
48 
49   	function RGB_Ratio() public view returns(uint,uint,uint){
50   		return RGB_Ratio(msg.sender);
51   	}
52 
53   	function RGB_Ratio(address addr) public view returns(uint,uint,uint){
54   		//returns the color of one's tokens
55   		uint weight = balances[addr];
56   		if (weight == 0){
57   			return (0,0,0);
58   		}
59   		return ( red[addr]/weight, green[addr]/weight, blue[addr]/weight);
60   	}
61 
62   	function RGB_scale(address addr, uint numerator, uint denominator) internal view returns(uint,uint,uint){
63 		return (red[addr] * numerator / denominator, green[addr] * numerator / denominator, blue[addr] * numerator / denominator);
64 	}
65 
66 	// Function that is called when a user or another contract wants to transfer funds.
67 	function transfer(address _to, uint _value, bytes memory _data) public virtual returns (bool) {
68 		if( isContract(_to) ){
69 			return transferToContract(_to, _value, _data);
70 		}else{
71 			return transferToAddress(_to, _value, _data);
72 		}
73 	}
74 	
75 	// Standard function transfer similar to ERC20 transfer with no _data.
76 	// Added due to backwards compatibility reasons .
77 	function transfer(address _to, uint _value) public virtual returns (bool) {
78 		//standard function transfer similar to ERC20 transfer with no _data
79 		//added due to backwards compatibility reasons
80 		bytes memory empty;
81 		if(isContract(_to)){
82 			return transferToContract(_to, _value, empty);
83 		}else{
84 			return transferToAddress(_to, _value, empty);
85 		}
86 	}
87 
88 
89 	//function that is called when transaction target is an address
90 	function transferToAddress(address _to, uint _value, bytes memory _data) private returns (bool) {
91 		moveTokens(msg.sender, _to, _value);
92 		emit Transfer(msg.sender, _to, _value, _data);
93 		return true;
94 	}
95 
96 	//function that is called when transaction target is a contract
97 	function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool) {
98 		moveTokens(msg.sender, _to, _value);
99 		ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
100 		receiver.tokenFallback(msg.sender, _value, _data);
101 		emit Transfer(msg.sender, _to, _value, _data);
102 		return true;
103 	}
104 
105 	function moveTokens(address _from, address _to, uint _amount) internal virtual{
106 		require( _amount <= balances[_from] );
107 
108 		//mix colors
109 		(uint red_ratio, uint green_ratio, uint blue_ratio) = RGB_scale( _from, _amount, balances[_from] );
110 		red[_from] -= red_ratio;
111 		green[_from] -= green_ratio;
112 		blue[_from] -= blue_ratio;
113 		red[_to] += red_ratio;
114 		green[_to] += green_ratio;
115 		blue[_to] += blue_ratio;
116 
117 		//update balances
118 		balances[_from] -= _amount;
119 		balances[_to] += _amount;
120 	}
121 
122     function allowance(address src, address guy) public view returns (uint) {
123         return approvals[src][guy];
124     }
125   	
126     function transferFrom(address src, address dst, uint amount) public returns (bool){
127         address sender = msg.sender;
128         require(approvals[src][sender] >=  amount);
129         require(balances[src] >= amount);
130         approvals[src][sender] -= amount;
131         moveTokens(src,dst,amount);
132         bytes memory empty;
133         emit Transfer(sender, dst, amount, empty);
134         return true;
135     }
136 
137     event Approval(address indexed src, address indexed guy, uint amount);
138     function approve(address guy, uint amount) public returns (bool) {
139         address sender = msg.sender;
140         approvals[sender][guy] = amount;
141 
142         emit Approval( sender, guy, amount );
143         return true;
144     }
145 
146     function isContract(address _addr) public view returns (bool is_contract) {
147 		uint length;
148 		assembly {
149 			//retrieve the size of the code on target address, this needs assembly
150 			length := extcodesize(_addr)
151 		}
152 		if(length>0) {
153 			return true;
154 		}else {
155 			return false;
156 		}
157 	}
158 }
159 
160 contract Pyramid is ColorToken{
161 	// scaleFactor is used to convert Ether into bonds and vice-versa: they're of different
162 	// orders of magnitude, hence the need to bridge between the two.
163 	uint256 constant scaleFactor = 0x10000000000000000;
164 	address payable address0 = address(0);
165 
166     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
167     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
168 
169 	// Typical values that we have to declare.
170 	string constant public name = "Bonds";
171 	string constant public symbol = "BOND";
172 	uint8 constant public decimals = 18;
173 
174 	mapping(address => uint256) public average_ethSpent;
175 	// For calculating hodl multiplier that factors into resolves minted
176 	mapping(address => uint256) public average_buyInTimeSum;
177 	// Array between each address and their number of resolves being staked.
178 	mapping(address => uint256) public resolveWeight;
179 
180 	// Array between each address and how much Ether has been paid out to it.
181 	// Note that this is scaled by the scaleFactor variable.
182 	mapping(address => int256) public payouts;
183 
184 	// The total number of resolves being staked in this contract
185 	uint256 public dissolvingResolves;
186 
187 	// For calculating the hodl multiplier. Weighted average release time
188 	uint public sumOfInputETH;
189 	uint public sumOfInputTime;
190 	uint public sumOfOutputETH;
191 	uint public sumOfOutputTime;
192 
193 	// Something about invarience.
194 	int256 public earningsOffset;
195 
196 	// Variable tracking how much Ether each token is currently worth// Note that this is scaled by the scaleFactor variable.
197 	uint256 public earningsPerResolve;
198 
199 	//The resolve token contract
200 	ResolveToken public resolveToken;
201 
202 	constructor() public{
203 		resolveToken = new ResolveToken( address(this) );
204 	}
205 
206 	function fluxFee(uint paidAmount) public view returns (uint fee) {
207 		//we're only going to count resolve tokens that haven't been burned.
208 		uint totalResolveSupply = resolveToken.totalSupply() - resolveToken.balanceOf( address(0) );
209 		if ( dissolvingResolves == 0 )
210 			return 0;
211 
212 		//the fee is the % of resolve tokens outside of the contract
213 		return paidAmount * ( totalResolveSupply - dissolvingResolves ) / totalResolveSupply * sumOfOutputETH / sumOfInputETH;
214 	}
215 
216 	// Converts the Ether accrued as resolveEarnings back into bonds without having to
217 	// withdraw it first. Saves on gas and potential price spike loss.
218 	event Reinvest( address indexed addr, uint256 reinvested, uint256 dissolved, uint256 bonds, uint256 resolveTax);
219 	function reinvestEarnings(uint amountFromEarnings) public returns(uint,uint){
220 		address sender = msg.sender;
221 		// Retrieve the resolveEarnings associated with the address the request came from.		
222 		uint upScaleDivs = (uint)((int256)( earningsPerResolve * resolveWeight[sender] ) - payouts[sender]);
223 		uint totalEarnings = upScaleDivs / scaleFactor;//resolveEarnings(sender);
224 		require(amountFromEarnings <= totalEarnings, "the amount exceeds total earnings");
225 		uint oldWeight = resolveWeight[sender];
226 		resolveWeight[sender] = oldWeight * (totalEarnings - amountFromEarnings) / totalEarnings;
227 		uint weightDiff = oldWeight - resolveWeight[sender];
228 		resolveToken.transfer( address0, weightDiff );
229 		dissolvingResolves -= weightDiff;
230 		
231 		// something about invariance
232 		int withdrawnEarnings = (int)(upScaleDivs * amountFromEarnings / totalEarnings) - (int)(weightDiff*earningsPerResolve);
233 		payouts[sender] += withdrawnEarnings;
234 		// Increase the total amount that's been paid out to maintain invariance.
235 		earningsOffset += withdrawnEarnings;
236 
237 		// Assign balance to a new variable.
238 		uint value_ = (uint) (amountFromEarnings);
239 
240 		// If your resolveEarnings are worth less than 1 szabo, abort.
241 		if (value_ < 0.000001 ether)
242 			revert();
243 
244 		// Calculate the fee
245 		uint fee = fluxFee(value_);
246 
247 		// The amount of Ether used to purchase new bonds for the caller
248 		uint numEther = value_ - fee;
249 
250 		//resolve reward tracking stuff
251 		average_ethSpent[sender] += numEther;
252 		average_buyInTimeSum[sender] += now * scaleFactor * numEther;
253 		sumOfInputETH += numEther;
254 		sumOfInputTime += now * scaleFactor * numEther;
255 
256 		// The number of bonds which can be purchased for numEther.
257 		uint createdBonds = ethereumToTokens_(numEther);
258 		uint[] memory RGB = new uint[](3);
259   		(RGB[0], RGB[1], RGB[2]) = RGB_Ratio(sender);
260 		
261 		addColor(sender, createdBonds, RGB[0], RGB[1], RGB[2]);
262 
263 		// the variable stoLOGC the amount to be paid to stakers
264 		uint resolveFee;
265 
266 		// Check if we have bonds in existence
267 		if ( dissolvingResolves > 0 ) {
268 			resolveFee = fee * scaleFactor;
269 
270 			// Fee is distributed to all existing resolve stakers before the new bonds are purchased.
271 			// rewardPerResolve is the amount(ETH) gained per resolve token from this purchase.
272 			uint rewardPerResolve = resolveFee / dissolvingResolves;
273 
274 			// The Ether value per token is increased proportionally.
275 			earningsPerResolve += rewardPerResolve;
276 		}
277 
278 		// Add the createdBonds to the total supply.
279 		_totalSupply += createdBonds;
280 
281 		// Assign the bonds to the balance of the buyer.
282 		balances[sender] += createdBonds;
283 
284 		emit Reinvest(sender, value_, weightDiff, createdBonds, resolveFee);
285 		return (createdBonds, weightDiff);
286 	}
287 
288 	// Sells your bonds for Ether
289 	function sellAllBonds() public returns(uint returned_eth, uint returned_resolves, uint initialInput_ETH){
290 		return sell( balanceOf(msg.sender) );
291 	}
292 
293 	function sellBonds(uint amount) public returns(uint returned_eth, uint returned_resolves, uint initialInput_ETH){
294 		require(balanceOf(msg.sender) >= amount, "Amount is more than balance");
295 		( returned_eth, returned_resolves, initialInput_ETH ) = sell(amount);
296 		return (returned_eth, returned_resolves, initialInput_ETH);
297 	}
298 
299 	// Big red exit button to pull all of a holder's Ethereum value from the contract
300 	function getMeOutOfHere() public {
301 		sellAllBonds();
302 		withdraw( resolveEarnings(msg.sender) );
303 	}
304 
305 	// Gatekeeper function to check if the amount of Ether being sent isn't too small
306 	function fund() payable public returns(uint createdBonds){
307 		uint[] memory RGB = new uint[](3);
308   		(RGB[0], RGB[1], RGB[2]) = RGB_Ratio(msg.sender);
309 		return buy(msg.sender, RGB[0], RGB[1], RGB[2]);
310   	}
311  
312 	// Calculate the current resolveEarnings associated with the caller address. This is the net result
313 	// of multiplying the number of resolves held by their current value in Ether and subtracting the
314 	// Ether that has already been paid out.
315 	function resolveEarnings(address _owner) public view returns (uint256 amount) {
316 		return (uint256) ((int256)(earningsPerResolve * resolveWeight[_owner]) - payouts[_owner]) / scaleFactor;
317 	}
318 
319 	event Buy( address indexed addr, uint256 spent, uint256 bonds, uint256 resolveTax);
320 	function buy(address addr, uint _red, uint _green, uint _blue) public payable returns(uint createdBonds){
321 		//make sure the color components don't exceed limits
322 		if(_red>1e18) _red = 1e18;
323 		if(_green>1e18) _green = 1e18;
324 		if(_blue>1e18) _blue = 1e18;
325 		
326 		// Any transaction of less than 1 szabo is likely to be worth less than the gas used to send it.
327 		if ( msg.value < 0.000001 ether )
328 			revert();
329 
330 		// Calculate the fee
331 		uint fee = fluxFee(msg.value);
332 
333 		// The amount of Ether used to purchase new bonds for the caller.
334 		uint numEther = msg.value - fee;
335 
336 		//resolve reward tracking stuff
337 		uint currentTime = now;
338 		average_ethSpent[addr] += numEther;
339 		average_buyInTimeSum[addr] += currentTime * scaleFactor * numEther;
340 		sumOfInputETH += numEther;
341 		sumOfInputTime += currentTime * scaleFactor * numEther;
342 
343 		// The number of bonds which can be purchased for numEther.
344 		createdBonds = ethereumToTokens_(numEther);
345 		addColor(addr, createdBonds, _red, _green, _blue);
346 
347 		// Add the createdBonds to the total supply.
348 		_totalSupply += createdBonds;
349 
350 		// Assign the bonds to the balance of the buyer.
351 		balances[addr] += createdBonds;
352 
353 		// Check if we have bonds in existence
354 		uint resolveFee;
355 		if (dissolvingResolves > 0) {
356 			resolveFee = fee * scaleFactor;
357 
358 			// Fee is distributed to all existing resolve holders before the new bonds are purchased.
359 			// rewardPerResolve is the amount gained per resolve token from this purchase.
360 			uint rewardPerResolve = resolveFee/dissolvingResolves;
361 
362 			// The Ether value per resolve is increased proportionally.
363 			earningsPerResolve += rewardPerResolve;
364 		}
365 		emit Buy( addr, msg.value, createdBonds, resolveFee);
366 		return createdBonds;
367 	}
368 
369 	function avgHodl() public view returns(uint hodlTime){
370 		return now - (sumOfInputTime - sumOfOutputTime) / (sumOfInputETH - sumOfOutputETH) / scaleFactor;
371 	}
372 
373 	function getReturnsForBonds(address addr, uint bondsReleased) public view returns(uint etherValue, uint mintedResolves, uint new_releaseTimeSum, uint new_releaseAmount, uint initialInput_ETH){
374 		uint output_ETH = tokensToEthereum_(bondsReleased);
375 		uint input_ETH = average_ethSpent[addr] * bondsReleased / balances[addr];
376 		// hodl multiplier. because if you don't hodl at all, you shouldn't be rewarded resolves.
377 		// and the multiplier you get for hodling needs to be relative to the average hodl
378 		uint buyInTime = average_buyInTimeSum[addr] / average_ethSpent[addr];
379 		uint cashoutTime = now * scaleFactor - buyInTime;
380 		uint new_sumOfOutputTime = sumOfOutputTime + average_buyInTimeSum[addr] * bondsReleased / balances[addr];
381 		uint new_sumOfOutputETH = sumOfOutputETH + input_ETH; //It's based on the original ETH, so that's why input_ETH is used. Not output_ETH.
382 		uint averageHoldingTime = now * scaleFactor - ( sumOfInputTime - sumOfOutputTime ) / ( sumOfInputETH - sumOfOutputETH );
383 		return (output_ETH, input_ETH * cashoutTime / averageHoldingTime * input_ETH / output_ETH, new_sumOfOutputTime, new_sumOfOutputETH, input_ETH);
384 	}
385 
386 	event Sell( address indexed addr, uint256 bondsSold, uint256 cashout, uint256 resolves, uint256 resolveTax, uint256 initialCash);
387 	function sell(uint256 amount) internal returns(uint eth, uint resolves, uint initialInput){
388 		address payable sender = msg.sender;
389 	  	// Calculate the amount of Ether & Resolves that the holder's bonds sell for at the current sell price.
390 
391 		uint[] memory UINTs = new uint[](5);
392 		(
393 		UINTs[0]/*ether before fee*/,
394 		UINTs[1]/*minted resolves*/,
395 		UINTs[2]/*new_sumOfOutputTime*/,
396 		UINTs[3]/*new_sumOfOutputETH*/,
397 		UINTs[4]/*initialInput_ETH*/) = getReturnsForBonds(sender, amount);
398 
399 		// calculate the fee
400 	    uint fee = fluxFee(UINTs[0]/*ether before fee*/);
401 
402 		// magic distribution
403 		uint[] memory RGB = new uint[](3);
404   		(RGB[0], RGB[1], RGB[2]) = RGB_Ratio(sender);
405 		resolveToken.mint(sender, UINTs[1]/*minted resolves*/, RGB[0], RGB[1], RGB[2]);
406 
407 		// update weighted average cashout time
408 		sumOfOutputTime = UINTs[2]/*new_sumOfOutputTime*/;
409 		sumOfOutputETH = UINTs[3] /*new_sumOfOutputETH*/;
410 
411 		// reduce the amount of "eth spent" based on the percentage of bonds being sold back into the contract
412 		average_ethSpent[sender] = average_ethSpent[sender] * ( balances[sender] - amount) / balances[sender];
413 		// reduce the "buyInTime" sum that's used for average buy in time
414 		average_buyInTimeSum[sender] = average_buyInTimeSum[sender] * (balances[sender] - amount) / balances[sender];
415 
416 		// Net Ether for the seller after the fee has been subtracted.
417 	    uint numEthers = UINTs[0]/*ether before fee*/ - fee;
418 
419 		// Burn the bonds which were just sold from the total supply.
420 		_totalSupply -= amount;
421 
422 
423 	    // maintain color density
424 	    thinColor( sender, balances[sender] - amount, balances[sender]);
425 	    // Remove the bonds from the balance of the buyer.
426 	    balances[sender] -= amount;
427 
428 		// Check if we have bonds in existence
429 		uint resolveFee;
430 		if ( dissolvingResolves > 0 ){
431 			// Scale the Ether taken as the selling fee by the scaleFactor variable.
432 			resolveFee = fee * scaleFactor;
433 
434 			// Fee is distributed to all remaining resolve holders.
435 			// rewardPerResolve is the amount gained per resolve thanks to this sell.
436 			uint rewardPerResolve = resolveFee/dissolvingResolves;
437 
438 			// The Ether value per resolve is increased proportionally.
439 			earningsPerResolve += rewardPerResolve;
440 		}
441 		
442 		
443 		(bool success, ) = sender.call{value:numEthers}("");
444         require(success, "Transfer failed.");
445 
446 		emit Sell( sender, amount, numEthers, UINTs[1]/*minted resolves*/, resolveFee, UINTs[4] /*initialInput_ETH*/);
447 		return (numEthers, UINTs[1]/*minted resolves*/, UINTs[4] /*initialInput_ETH*/);
448 	}
449 
450 	function thinColor(address addr, uint newWeight, uint oldWeight) internal{
451 		//bonds cease to exist so the color density needs to be updated.
452   		(red[addr], green[addr], blue[addr]) = RGB_scale( addr, newWeight, oldWeight);
453   	}
454 
455 	// Allow contract to accept resolve tokens
456 	event StakeResolves( address indexed addr, uint256 amountStaked, bytes _data );
457 	function tokenFallback(address from, uint value, bytes calldata _data) external{
458 		if(msg.sender == address(resolveToken) ){
459 			resolveWeight[from] += value;
460 			dissolvingResolves += value;
461 
462 			// Then we update the payouts array for the "resolve shareholder" with this amount
463 			int payoutDiff = (int256) (earningsPerResolve * value);
464 			payouts[from] += payoutDiff;
465 			earningsOffset += payoutDiff;
466 
467 			emit StakeResolves(from, value, _data);
468 		}else{
469 			revert("no want");
470 		}
471 	}
472 
473 	// Withdraws resolveEarnings held by the caller sending the transaction, updates
474 	// the requisite global variables, and transfers Ether back to the caller.
475 	event Withdraw( address indexed addr, uint256 earnings, uint256 dissolve );
476 	function withdraw(uint amount) public returns(uint){
477 		address payable sender = msg.sender;
478 		// Retrieve the resolveEarnings associated with the address the request came from.
479 		uint upScaleDivs = (uint)((int256)( earningsPerResolve * resolveWeight[sender] ) - payouts[sender]);
480 		uint totalEarnings = upScaleDivs / scaleFactor;
481 		require( amount <= totalEarnings && amount > 0 );
482 		uint oldWeight = resolveWeight[sender];
483 		resolveWeight[sender] = oldWeight * ( totalEarnings - amount ) / totalEarnings;
484 		uint weightDiff = oldWeight - resolveWeight[sender];
485 		resolveToken.transfer( address0, weightDiff);
486 		dissolvingResolves -= weightDiff;
487 		
488 		// something about invariance
489 		int withdrawnEarnings = (int)(upScaleDivs * amount / totalEarnings) - (int)(weightDiff*earningsPerResolve);
490 		payouts[sender] += withdrawnEarnings;
491 		// Increase the total amount that's been paid out to maintain invariance.
492 		earningsOffset += withdrawnEarnings;
493 
494 
495 		// Send the resolveEarnings to the address that requested the withdraw.
496 		(bool success, ) = sender.call{value: amount}("");
497         require(success, "Transfer failed.");
498 
499 		emit Withdraw( sender, amount, weightDiff);
500 		return weightDiff;
501 	}
502 
503 	event PullResolves( address indexed addr, uint256 pulledResolves, uint256 forfeiture);
504 	function pullResolves(uint amount) public returns (uint forfeiture){
505 		address sender = msg.sender;
506 		uint resolves = resolveWeight[ sender ];
507 		require(amount <= resolves && amount > 0);
508 		require(amount < dissolvingResolves);//"you can't forfeit the last resolve"
509 
510 		uint yourTotalEarnings = (uint)((int256)(resolves * earningsPerResolve) - payouts[sender]);
511 		uint forfeitedEarnings = yourTotalEarnings * amount / resolves;
512 
513 		// Update the payout array so that the "resolve shareholder" cannot claim resolveEarnings on previous staked resolves.
514 		payouts[sender] += (int256)(forfeitedEarnings) - (int256)(earningsPerResolve * amount);
515 
516 		resolveWeight[sender] -= amount;
517 		dissolvingResolves -= amount;
518 		// The Ether value per token is increased proportionally.
519 		earningsPerResolve += forfeitedEarnings / dissolvingResolves;
520 
521 		resolveToken.transfer( sender, amount );
522 		emit PullResolves( sender, amount, forfeitedEarnings / scaleFactor);
523 		return forfeitedEarnings / scaleFactor;
524 	}
525 
526 	function moveTokens(address _from, address _to, uint _amount) internal override{
527 		//mix multi-dimensional bond values
528 		uint totalBonds = balances[_from];
529 		uint ethSpent = average_ethSpent[_from] * _amount / totalBonds;
530 		uint buyInTimeSum = average_buyInTimeSum[_from] * _amount / totalBonds;
531 		average_ethSpent[_from] -= ethSpent;
532 		average_buyInTimeSum[_from] -= buyInTimeSum;
533 		average_ethSpent[_to] += ethSpent;
534 		average_buyInTimeSum[_to] += buyInTimeSum;
535 		super.moveTokens(_from, _to, _amount);
536 	}
537 
538     function buyPrice()
539         public 
540         view 
541         returns(uint256)
542     {
543         // our calculation relies on the token supply, so we need supply. Doh.
544         if(_totalSupply == 0){
545             return tokenPriceInitial_ + tokenPriceIncremental_;
546         } else {
547             uint256 _ethereum = tokensToEthereum_(1e18);
548             uint256 _dividends = fluxFee(_ethereum  );
549             uint256 _taxedEthereum = _ethereum + _dividends;
550             return _taxedEthereum;
551         }
552     }
553 
554     function sellPrice() 
555         public 
556         view 
557         returns(uint256)
558     {
559         // our calculation relies on the token supply, so we need supply. Doh.
560         if(_totalSupply == 0){
561             return tokenPriceInitial_ - tokenPriceIncremental_;
562         } else {
563             uint256 _ethereum = tokensToEthereum_(1e18);
564             uint256 _dividends = fluxFee(_ethereum  );
565             uint256 _taxedEthereum = subtract(_ethereum, _dividends);
566             return _taxedEthereum;
567         }
568     }
569 
570     function calculateTokensReceived(uint256 _ethereumToSpend) 
571         public 
572         view 
573         returns(uint256)
574     {
575         uint256 _dividends = fluxFee(_ethereumToSpend);
576         uint256 _taxedEthereum = subtract(_ethereumToSpend, _dividends);
577         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
578         
579         return _amountOfTokens;
580     }
581     
582 
583     function calculateEthereumReceived(uint256 _tokensToSell) 
584         public 
585         view 
586         returns(uint256)
587     {
588         require(_tokensToSell <= _totalSupply);
589         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
590         uint256 _dividends = fluxFee(_ethereum );
591         uint256 _taxedEthereum = subtract(_ethereum, _dividends);
592         return _taxedEthereum;
593     }
594 
595     function ethereumToTokens_(uint256 _ethereum)
596         internal
597         view
598         returns(uint256)
599     {
600         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
601         uint256 _tokensReceived = 
602          (
603             (
604                 // underflow attempts BTFO
605                 subtract(
606                     (sqrt
607                         (
608                             (_tokenPriceInitial**2)
609                             +
610                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
611                             +
612                             (((tokenPriceIncremental_)**2)*(_totalSupply**2))
613                             +
614                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*_totalSupply)
615                         )
616                     ), _tokenPriceInitial
617                 )
618             )/(tokenPriceIncremental_)
619         )-(_totalSupply)
620         ;
621   
622         return _tokensReceived;
623     }
624 
625     function tokensToEthereum_(uint256 _tokens)
626         internal
627         view
628         returns(uint256)
629     {
630 
631         uint256 tokens_ = (_tokens + 1e18);
632         uint256 _tokenSupply = (_totalSupply + 1e18);
633         uint256 _etherReceived =
634         (
635             // underflow attempts BTFO
636             subtract(
637                 (
638                     (
639                         (
640                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
641                         )-tokenPriceIncremental_
642                     )*(tokens_ - 1e18)
643                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
644             )
645         /1e18);
646         return _etherReceived;
647     }
648 
649     function sqrt(uint x) internal pure returns (uint y) {
650         uint z = (x + 1) / 2;
651         y = x;
652         while (z < y) {
653             y = z;
654             z = (x / z + z) / 2;
655         }
656     }
657 
658     function subtract(uint256 a, uint256 b) internal pure returns (uint256) {
659         assert(b <= a);
660         return a - b;
661     }
662 }
663 
664 contract ResolveToken is ColorToken{
665 
666 	string public name = "Color";
667     string public symbol = "`c";
668     uint8 constant public decimals = 18;
669 	address public hourglass;
670 
671 	constructor(address _hourglass) public{
672 		hourglass = _hourglass;
673 	}
674 
675 	modifier hourglassOnly{
676 	  require(msg.sender == hourglass);
677 	  _;
678     }
679 
680 	event Mint(
681 		address indexed addr,
682 		uint256 amount
683 	);
684 
685 	function mint(address _address, uint _value, uint _red, uint _green, uint _blue) external hourglassOnly(){
686 		balances[_address] += _value;
687 		_totalSupply += _value;
688 		addColor(_address, _value, _red, _green, _blue);
689 		emit Mint(_address, _value);
690 	}
691 }
692 
693 abstract contract ERC223ReceivingContract{
694     function tokenFallback(address _from, uint _value, bytes calldata _data) external virtual;
695 }