1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 contract ERC20 {
36 	function totalSupply() constant returns (uint totalSupply);
37 	function balanceOf(address _owner) constant returns (uint balance);
38 	function transfer(address _to, uint _value) returns (bool success);
39 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
40 	function approve(address _spender, uint _value) returns (bool success);
41 	function allowance(address _owner, address _spender) constant returns (uint remaining);
42     // This generates a public event on the blockchain that will notify clients
43 	event Transfer(address indexed _from, address indexed _to, uint _value);
44 	event Approval(address indexed _owner, address indexed _spender, uint _value);
45 }
46 
47 //Token with owner (admin)
48 contract OwnedToken {
49 	address public owner; //contract owner (admin) address
50 	function OwnedToken () public {
51 		owner = msg.sender;
52 	}
53 	//Check if owner initiate call
54     modifier onlyOwner()
55     {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61      * Transfer ownership
62      *
63      * @param newOwner The address of the new contract owner
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         owner = newOwner;
67     }
68 }
69 
70 //Contract with name
71 contract NamedOwnedToken is OwnedToken {
72 	string public name; //the name for display purposes
73 	string public symbol; //the symbol for display purposes
74 	function NamedOwnedToken(string tokenName, string tokenSymbol) public
75 	{
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78 	}
79 
80     /**
81      * Change name and symbol
82      *
83      * @param newName The new contract name
84      * @param newSymbol The new contract symbol 
85      */
86     function changeName(string newName, string newSymbol)public onlyOwner {
87 		name = newName;
88 		symbol = newSymbol;
89     }
90 }
91 
92 contract TSBToken is ERC20, NamedOwnedToken {
93 	using SafeMath for uint256;
94 
95     // Public variables of the token
96 
97     uint256 public _totalSupply = 0; //Total number of token issued (1 token = 10^decimals)
98 	uint8 public decimals = 18; //Decimals, each 1 token = 10^decimals
99 
100     
101     mapping (address => uint256) public balances; // A map with all balances
102     mapping (address => mapping (address => uint256)) public allowed; //Implement allowence to support ERC20
103 
104     mapping (address => uint256) public paidETH; //The sum have already been paid to token owner
105 	uint256 public accrueDividendsPerXTokenETH = 0;
106 	uint256 public tokenPriceETH = 0;
107 
108     mapping (address => uint256) public paydCouponsETH;
109 	uint256 public accrueCouponsPerXTokenETH = 0;
110 	uint256 public totalCouponsUSD = 0;
111 	uint256 public MaxCouponsPaymentUSD = 150000;
112 
113 	mapping (address => uint256) public rebuySum;
114 	mapping (address => uint256) public rebuyInformTime;
115 
116 
117 	uint256 public endSaleTime;
118 	uint256 public startRebuyTime;
119 	uint256 public reservedSum;
120 	bool public rebuyStarted = false;
121 
122 	uint public tokenDecimals;
123 	uint public tokenDecimalsLeft;
124 
125     /**
126      * Constructor function
127      *
128      * Initializes contract
129      */
130     function TSBToken(
131         string tokenName,
132         string tokenSymbol
133     ) NamedOwnedToken(tokenName, tokenSymbol) public {
134 		tokenDecimals = 10**uint256(decimals - 5);
135 		tokenDecimalsLeft = 10**5;
136 		startRebuyTime = now + 1 years;
137 		endSaleTime = now;
138     }
139 
140     /**
141      * Internal function, calc dividends to transfer when tokens are transfering to another wallet
142      */
143 	function transferDiv(uint startTokens, uint fromTokens, uint toTokens, uint sumPaydFrom, uint sumPaydTo, uint acrued) internal constant returns (uint, uint) {
144 		uint sumToPayDividendsFrom = fromTokens.mul(acrued);
145 		uint sumToPayDividendsTo = toTokens.mul(acrued);
146 		uint sumTransfer = sumPaydFrom.div(startTokens);
147 		sumTransfer = sumTransfer.mul(startTokens-fromTokens);
148 		if (sumPaydFrom > sumTransfer) {
149 			sumPaydFrom -= sumTransfer;
150 			if (sumPaydFrom > sumToPayDividendsFrom) {
151 				sumTransfer += sumPaydFrom - sumToPayDividendsFrom;
152 				sumPaydFrom = sumToPayDividendsFrom;
153 			}
154 		} else {
155 			sumTransfer = sumPaydFrom;
156 			sumPaydFrom = 0;
157 		}
158 		sumPaydTo = sumPaydTo.add(sumTransfer);
159 		if (sumPaydTo > sumToPayDividendsTo) {
160 			uint differ = sumPaydTo - sumToPayDividendsTo;
161 			sumPaydTo = sumToPayDividendsTo;
162 			sumPaydFrom = sumPaydFrom.add(differ);
163 			if (sumPaydFrom > sumToPayDividendsFrom) {
164 				sumPaydFrom = sumToPayDividendsFrom;
165 			} 
166 		}
167 		return (sumPaydFrom, sumPaydTo);
168 	}
169 
170 
171 
172     /**
173      * Internal transfer, only can be called by this contract
174      */
175     function _transfer(address _from, address _to, uint _value) internal {
176         require(_to != address(0));                               // Prevent transfer to 0x0 address. Use burn() instead
177         require(balances[_from] >= _value);                // Check if the sender has enough
178         require(balances[_to] + _value > balances[_to]); // Check for overflows
179 		uint startTokens = balances[_from].div(tokenDecimals);
180         balances[_from] -= _value;                         // Subtract from the sender
181         balances[_to] += _value;                           // Add the same to the recipient
182 
183 		if (balances[_from] == 0) {
184 			paidETH[_to] = paidETH[_to].add(paidETH[_from]);
185 		} else {
186 			uint fromTokens = balances[_from].div(tokenDecimals);
187 			uint toTokens = balances[_to].div(tokenDecimals);
188 			(paidETH[_from], paidETH[_to]) = transferDiv(startTokens, fromTokens, toTokens, paidETH[_from], paidETH[_to], accrueDividendsPerXTokenETH+accrueCouponsPerXTokenETH);
189 		}
190         Transfer(_from, _to, _value);
191     }
192 
193     /**
194      * Transfer tokens
195      *
196      * Send `_value` tokens to `_to` from your account
197      *
198      * @param _to The address of the recipient
199      * @param _value the amount to send
200      */
201     function transfer(address _to, uint256 _value) public returns (bool success) {
202         _transfer(msg.sender, _to, _value);
203         return true;
204     }
205 
206     /**
207      * Balance of tokens
208      *
209      * @param _owner The address of token wallet
210      */
211 	function balanceOf(address _owner) public constant returns (uint256 balance) {
212 		return balances[_owner];
213 	}
214 
215     /**
216      * Returns total issued tokens number
217      *
218 	*/
219 	function totalSupply() public constant returns (uint totalSupply) {
220 		return _totalSupply;
221 	}
222 
223 
224     /**
225      * Transfer tokens from other address
226      *
227      * Send `_value` tokens to `_to` in behalf of `_from`
228      *
229      * @param _from The address of the sender
230      * @param _to The address of the recipient
231      * @param _value the amount to send
232      */
233     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
234         require(_value <= allowed[_from][msg.sender]);     // Check allowance
235         allowed[_from][msg.sender] -= _value;
236         _transfer(_from, _to, _value);
237         return true;
238     }
239 
240     /**
241      * Set allowance for other address
242      *
243      * Allows `_spender` to spend no more than `_value` tokens in your behalf
244      *
245      * @param _spender The address authorized to spend
246      * @param _value the max amount they can spend
247      */
248     function approve(address _spender, uint256 _value) public
249         returns (bool success) {
250         allowed[msg.sender][_spender] = _value;
251         return true;
252     }
253 
254     /**
255      * Check allowance for address
256      *
257      * @param _owner The address who authorize to spend
258      * @param _spender The address authorized to spend
259      */
260 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
261 		return allowed[_owner][_spender];
262 	}
263 
264 
265 	// This notifies clients about the amount burnt
266     event Burn(address indexed from, uint256 value);
267 
268     /**
269      * Internal function destroy tokens
270      */
271     function burnTo(uint256 _value, address adr) internal returns (bool success) {
272         require(balances[adr] >= _value);   // Check if the sender has enough
273         require(_value > 0);   // Check if the sender has enough
274 		uint startTokens = balances[adr].div(tokenDecimals);
275         balances[adr] -= _value;            // Subtract from the sender
276 		uint endTokens = balances[adr].div(tokenDecimals);
277 
278 		uint sumToPayFrom = endTokens.mul(accrueDividendsPerXTokenETH + accrueCouponsPerXTokenETH);
279 		uint divETH = paidETH[adr].div(startTokens);
280 		divETH = divETH.mul(endTokens);
281 		if (divETH > sumToPayFrom) {
282 			paidETH[adr] = sumToPayFrom;
283 		} else {
284 			paidETH[adr] = divETH;
285 		}
286 
287 		_totalSupply -= _value;                      // Updates totalSupply
288         Burn(adr, _value);
289         return true;
290     }
291 
292     /**
293      * Delete tokens tokens during the end of croudfunding 
294      * (in case of errors made by crowdfnuding participants)
295      * Only owner could call
296      */
297     function deleteTokens(address adr, uint256 amount) public onlyOwner canMint {
298         burnTo(amount, adr);
299     }
300 
301 	bool public mintingFinished = false;
302 	event Mint(address indexed to, uint256 amount);
303 	event MintFinished();
304 
305 	//Check if it is possible to mint new tokens (mint allowed only during croudfunding)
306 	modifier canMint() {
307 		require(!mintingFinished);
308 		_;
309 	}
310 	
311 	function () public payable {
312 	}
313 
314 	//Withdraw unused ETH from contract to owner
315 	function WithdrawLeftToOwner(uint sum) public onlyOwner {
316 	    owner.transfer(sum);
317 	}
318 	
319     /**
320      * Mint additional tokens at the end of croudfunding
321      */
322 	function mintToken(address target, uint256 mintedAmount) public onlyOwner canMint  {
323 		balances[target] += mintedAmount;
324 		uint tokensInX = mintedAmount.div(tokenDecimals);
325 		paidETH[target] += tokensInX.mul(accrueDividendsPerXTokenETH + accrueCouponsPerXTokenETH);
326 		_totalSupply += mintedAmount;
327 		Mint(owner, mintedAmount);
328 		Transfer(0x0, target, mintedAmount);
329 	}
330 
331     /**
332      * Finish minting
333      */
334 	function finishMinting() public onlyOwner returns (bool) {
335 		mintingFinished = true;
336 		endSaleTime = now;
337 		startRebuyTime = endSaleTime + (180 * 1 days);
338 		MintFinished();
339 		return true;
340 	}
341 
342     /**
343      * Withdraw accrued dividends and coupons
344      */
345 	function WithdrawDividendsAndCoupons() public {
346 		withdrawTo(msg.sender,0);
347 	}
348 
349     /**
350      * Owner could initiate a withdrawal of accrued dividends and coupons to some address (in purpose to help users)
351      */
352 	function WithdrawDividendsAndCouponsTo(address _sendadr) public onlyOwner {
353 		withdrawTo(_sendadr, tx.gasprice * block.gaslimit);
354 	}
355 
356     /**
357      * Internal function to withdraw accrued dividends and coupons
358      */
359 	function withdrawTo(address _sendadr, uint comiss) internal {
360 		uint tokensPerX = balances[_sendadr].div(tokenDecimals);
361 		uint sumPayd = paidETH[_sendadr];
362 		uint sumToPayRes = tokensPerX.mul(accrueCouponsPerXTokenETH+accrueDividendsPerXTokenETH);
363 		uint sumToPay = sumToPayRes.sub(comiss);
364 		require(sumToPay>sumPayd);
365 		sumToPay = sumToPay.sub(sumPayd);
366 		_sendadr.transfer(sumToPay);
367 		paidETH[_sendadr] = sumToPayRes;
368 	}
369 
370     /**
371      * Owner accrue new sum of dividends and coupons (once per month)
372      */
373 	function accrueDividendandCoupons(uint sumDivFinney, uint sumFinneyCoup) public onlyOwner {
374 		sumDivFinney = sumDivFinney * 1 finney;
375 		sumFinneyCoup = sumFinneyCoup * 1 finney;
376 		uint tokens = _totalSupply.div(tokenDecimals);
377 		accrueDividendsPerXTokenETH = accrueDividendsPerXTokenETH.add(sumDivFinney.div(tokens));
378 		accrueCouponsPerXTokenETH = accrueCouponsPerXTokenETH.add(sumFinneyCoup.div(tokens));
379 	}
380 
381     /**
382      * Set a price of token to rebuy
383      */
384 	function setTokenPrice(uint priceFinney) public onlyOwner {
385 		tokenPriceETH = priceFinney * 1 finney;
386 	}
387 
388 	event RebuyInformEvent(address indexed adr, uint256 amount);
389 
390     /**
391      * Inform owner that someone whant to sell tokens
392      * The rebuy proccess allowed in 2 weeks after inform
393      * Only after half a year after croudfunding
394      */
395 	function InformRebuy(uint sum) public {
396 		_informRebuyTo(sum, msg.sender);
397 	}
398 
399 	function InformRebuyTo(uint sum, address adr) public onlyOwner{
400 		_informRebuyTo(sum, adr);
401 	}
402 
403 	function _informRebuyTo(uint sum, address adr) internal{
404 		require (rebuyStarted || (now >= startRebuyTime));
405 		require (sum <= balances[adr]);
406 		rebuyInformTime[adr] = now;
407 		rebuySum[adr] = sum;
408 		RebuyInformEvent(adr, sum);
409 	}
410 
411     /**
412      * Owner could allow rebuy proccess early
413      */
414 	function StartRebuy() public onlyOwner{
415 		rebuyStarted = true;
416 	}
417 
418     /**
419     * Sell tokens after 2 weeks from information
420     */
421 	function doRebuy() public {
422 		_doRebuyTo(msg.sender, 0);
423 	}
424     /**
425     * Contract owner would perform tokens rebuy after 2 weeks from information
426     */
427 	function doRebuyTo(address adr) public onlyOwner {
428 		_doRebuyTo(adr, tx.gasprice * block.gaslimit);
429 	}
430 	function _doRebuyTo(address adr, uint comiss) internal {
431 		require (rebuyStarted || (now >= startRebuyTime));
432 		require (now >= rebuyInformTime[adr].add(14 days));
433 		uint sum = rebuySum[adr];
434 		require (sum <= balances[adr]);
435 		withdrawTo(adr, 0);
436 		if (burnTo(sum, adr)) {
437 			sum = sum.div(tokenDecimals);
438 			sum = sum.mul(tokenPriceETH);
439 			sum = sum.div(tokenDecimalsLeft);
440 			sum = sum.sub(comiss);
441 			adr.transfer(sum);
442 			rebuySum[adr] = 0;
443 		}
444 	}
445 
446 }
447 
448 contract TSBCrowdFundingContract is NamedOwnedToken{
449 	using SafeMath for uint256;
450 
451 
452 	enum CrowdSaleState {NotFinished, Success, Failure}
453 	CrowdSaleState public crowdSaleState = CrowdSaleState.NotFinished;
454 
455 
456     uint public fundingGoalUSD = 200000; //Min cap
457     uint public fundingMaxCapUSD = 500000; //Max cap
458     uint public priceUSD = 1; //Price in USD per 1 token
459 	uint public USDDecimals = 1 ether;
460 
461 	uint public startTime; //crowdfunding start time
462     uint public endTime; //crowdfunding end time
463     uint public bonusEndTime; //crowdfunding end of bonus time
464     uint public selfDestroyTime = 2 weeks;
465     TSBToken public tokenReward; //TSB Token to send
466 	
467 	uint public ETHPrice = 30000; //Current price of one ETH in USD cents
468 	uint public BTCPrice = 400000; //Current price of one BTC in USD cents
469 	uint public PriceDecimals = 100;
470 
471 	uint public ETHCollected = 0; //Collected sum of ETH
472 	uint public BTCCollected = 0; //Collected sum of BTC
473 	uint public amountRaisedUSD = 0; //Collected sum in USD
474 	uint public TokenAmountToPay = 0; //Number of tokens to distribute (excluding bonus tokens)
475 
476 	mapping(address => uint256) public balanceMapPos;
477 	struct mapStruct {
478 		address mapAddress;
479 		uint mapBalanceETH;
480 		uint mapBalanceBTC;
481 		uint bonusTokens;
482 	}
483 	mapStruct[] public balanceList; //Array of struct with information about invested sums
484 
485     uint public bonusCapUSD = 100000; //Bonus cap
486 	mapping(bytes32 => uint256) public bonusesMapPos;
487 	struct bonusStruct {
488 		uint balancePos;
489 		bool notempty;
490 		uint maxBonusETH;
491 		uint maxBonusBTC;
492 		uint bonusETH;
493 		uint bonusBTC;
494 		uint8 bonusPercent;
495 	}
496 	bonusStruct[] public bonusesList; //Array of struct with information about bonuses
497 	
498     bool public fundingGoalReached = false; 
499     bool public crowdsaleClosed = false;
500 
501     event GoalReached(address beneficiary, uint amountRaised);
502     event FundTransfer(address backer, uint amount, bool isContribution);
503 
504 	function TSBCrowdFundingContract( 
505 		uint _startTime,
506         uint durationInHours,
507         string tokenName,
508         string tokenSymbol
509 	) NamedOwnedToken(tokenName, tokenSymbol) public {
510 	//	require(_startTime >= now);
511 	    SetStartTime(_startTime, durationInHours);
512 		bonusCapUSD = bonusCapUSD * USDDecimals;
513 	}
514 
515     function SetStartTime(uint startT, uint durationInHours) public onlyOwner {
516         startTime = startT;
517         bonusEndTime = startT+ 24 hours;
518         endTime = startT + (durationInHours * 1 hours);
519     }
520 
521 	function assignTokenContract(address tok) public onlyOwner   {
522 		tokenReward = TSBToken(tok);
523 		tokenReward.transferOwnership(address(this));
524 	}
525 
526 	function () public payable {
527 		bool withinPeriod = now >= startTime && now <= endTime;
528 		bool nonZeroPurchase = msg.value != 0;
529 		require( withinPeriod && nonZeroPurchase && (crowdSaleState == CrowdSaleState.NotFinished));
530 		uint bonuspos = 0;
531 		if (now <= bonusEndTime) {
532 //		    lastdata = msg.data;
533 			bytes32 code = sha3(msg.data);
534 			bonuspos = bonusesMapPos[code];
535 		}
536 		ReceiveAmount(msg.sender, msg.value, 0, now, bonuspos);
537 
538 	}
539 
540 	function CheckBTCtransaction() internal constant returns (bool) {
541 		return true;
542 	}
543 
544 	function AddBTCTransactionFromArray (address[] ETHadress, uint[] BTCnum, uint[] TransTime, bytes4[] bonusdata) public onlyOwner {
545         require(ETHadress.length == BTCnum.length); 
546         require(TransTime.length == bonusdata.length);
547         require(ETHadress.length == bonusdata.length);
548         for (uint i = 0; i < ETHadress.length; i++) {
549             AddBTCTransaction(ETHadress[i], BTCnum[i], TransTime[i], bonusdata[i]);
550         }
551 	}
552     /**
553      * Add transfered BTC, only owner could call
554      *
555      * @param ETHadress The address of ethereum wallet of sender 
556      * @param BTCnum the received amount in BTC * 10^18
557      * @param TransTime the original (BTC) transaction time
558      */
559 	function AddBTCTransaction (address ETHadress, uint BTCnum, uint TransTime, bytes4 bonusdata) public onlyOwner {
560 		require(CheckBTCtransaction());
561 		require((TransTime >= startTime) && (TransTime <= endTime));
562 		require(BTCnum != 0);
563 		uint bonuspos = 0;
564 		if (TransTime <= bonusEndTime) {
565 //		    lastdata = bonusdata;
566 			bytes32 code = sha3(bonusdata);
567 			bonuspos = bonusesMapPos[code];
568 		}
569 		ReceiveAmount(ETHadress, 0, BTCnum, TransTime, bonuspos);
570 	}
571 
572 	modifier afterDeadline() { if (now >= endTime) _; }
573 
574     /**
575      * Set price for ETH and BTC, only owner could call
576      *
577      * @param _ETHPrice ETH price in USD cents
578      * @param _BTCPrice BTC price in USD cents
579      */
580 	function SetCryptoPrice(uint _ETHPrice, uint _BTCPrice) public onlyOwner {
581 		ETHPrice = _ETHPrice;
582 		BTCPrice = _BTCPrice;
583 	}
584 
585     /**
586      * Convert sum in ETH plus BTC to USD
587      *
588      * @param ETH ETH sum in wei
589      * @param BTC BTC sum in 10^18
590      */
591 	function convertToUSD(uint ETH, uint BTC) public constant returns (uint) {
592 		uint _ETH = ETH.mul(ETHPrice);
593 		uint _BTC = BTC.mul(BTCPrice);
594 		return (_ETH+_BTC).div(PriceDecimals);
595 	}
596 
597     /**
598      * Calc collected sum in USD
599      */
600 	function collectedSum() public constant returns (uint) {
601 		return convertToUSD(ETHCollected,BTCCollected);
602 	}
603 
604     /**
605      * Check if min cap was reached (only after finish of crowdfunding)
606      */
607     function checkGoalReached() public afterDeadline {
608 		amountRaisedUSD = collectedSum();
609         if (amountRaisedUSD >= (fundingGoalUSD * USDDecimals) ){
610 			crowdSaleState = CrowdSaleState.Success;
611 			TokenAmountToPay = amountRaisedUSD;
612             GoalReached(owner, amountRaisedUSD);
613         } else {
614 			crowdSaleState = CrowdSaleState.Failure;
615 		}
616     }
617 
618     /**
619      * Check if max cap was reached
620      */
621     function checkMaxCapReached() public {
622 		amountRaisedUSD = collectedSum();
623         if (amountRaisedUSD >= (fundingMaxCapUSD * USDDecimals) ){
624 	        crowdSaleState = CrowdSaleState.Success;
625 			TokenAmountToPay = amountRaisedUSD;
626             GoalReached(owner, amountRaisedUSD);
627         }
628     }
629 
630 	function ReceiveAmount(address investor, uint sumETH, uint sumBTC, uint TransTime, uint bonuspos) internal {
631 		require(investor != 0x0);
632 
633 		uint pos = balanceMapPos[investor];
634 		if (pos>0) {
635 			pos--;
636 			assert(pos < balanceList.length);
637 			assert(balanceList[pos].mapAddress == investor);
638 			balanceList[pos].mapBalanceETH = balanceList[pos].mapBalanceETH.add(sumETH);
639 			balanceList[pos].mapBalanceBTC = balanceList[pos].mapBalanceBTC.add(sumBTC);
640 		} else {
641 			mapStruct memory newStruct;
642 			newStruct.mapAddress = investor;
643 			newStruct.mapBalanceETH = sumETH;
644 			newStruct.mapBalanceBTC = sumBTC;
645 			newStruct.bonusTokens = 0;
646 			pos = balanceList.push(newStruct);		
647 			balanceMapPos[investor] = pos;
648 			pos--;
649 		}
650 		
651 		// update state
652 		ETHCollected = ETHCollected.add(sumETH);
653 		BTCCollected = BTCCollected.add(sumBTC);
654 		
655 		checkBonus(pos, sumETH, sumBTC, TransTime, bonuspos);
656 		checkMaxCapReached();
657 	}
658 
659 	uint public DistributionNextPos = 0;
660 
661     /**
662      * Distribute tokens to next N participants, only owner could call
663      */
664 	function DistributeNextNTokens(uint n) public payable onlyOwner {
665 		require(BonusesDistributed);
666 		require(DistributionNextPos<balanceList.length);
667 		uint nextpos;
668 		if (n == 0) {
669 		    nextpos = balanceList.length;
670 		} else {
671     		nextpos = DistributionNextPos.add(n);
672     		if (nextpos > balanceList.length) {
673     			nextpos = balanceList.length;
674     		}
675 		}
676 		uint TokenAmountToPay_local = TokenAmountToPay;
677 		for (uint i = DistributionNextPos; i < nextpos; i++) {
678 			uint USDbalance = convertToUSD(balanceList[i].mapBalanceETH, balanceList[i].mapBalanceBTC);
679 			uint tokensCount = USDbalance.mul(priceUSD);
680 			tokenReward.mintToken(balanceList[i].mapAddress, tokensCount + balanceList[i].bonusTokens);
681 			TokenAmountToPay_local = TokenAmountToPay_local.sub(tokensCount);
682 			balanceList[i].mapBalanceETH = 0;
683 			balanceList[i].mapBalanceBTC = 0;
684 		}
685 		TokenAmountToPay = TokenAmountToPay_local;
686 		DistributionNextPos = nextpos;
687 	}
688 
689 	function finishDistribution()  onlyOwner {
690 		require ((TokenAmountToPay == 0)||(DistributionNextPos >= balanceList.length));
691 //		tokenReward.finishMinting();
692 		tokenReward.transferOwnership(owner);
693 		selfdestruct(owner);
694 	}
695 
696     /**
697      * Withdraw the funds
698      *
699      * Checks to see if goal was not reached, each contributor can withdraw
700      * the amount they contributed.
701      */
702     function safeWithdrawal() public afterDeadline {
703         require(crowdSaleState == CrowdSaleState.Failure);
704 		uint pos = balanceMapPos[msg.sender];
705 		require((pos>0)&&(pos<=balanceList.length));
706 		pos--;
707         uint amount = balanceList[pos].mapBalanceETH;
708         balanceList[pos].mapBalanceETH = 0;
709         if (amount > 0) {
710             msg.sender.transfer(amount);
711             FundTransfer(msg.sender, amount, false);
712         }
713     }
714 
715     /**
716      * If something goes wrong owner could destroy the contract after 2 weeks from the crowdfunding end
717      * In this case the token distribution or sum refund will be performed in mannual
718      */
719 	function killContract() public onlyOwner {
720 		require(now >= endTime + selfDestroyTime);
721 		tokenReward.transferOwnership(owner);
722         selfdestruct(owner);
723     }
724 
725     /**
726      * Add a new bonus code, only owner could call
727      */
728 	function AddBonusToListFromArray(bytes32[] bonusCode, uint[] ETHsumInFinney, uint[] BTCsumInFinney) public onlyOwner {
729 	    require(bonusCode.length == ETHsumInFinney.length);
730 	    require(bonusCode.length == BTCsumInFinney.length);
731 	    for (uint i = 0; i < bonusCode.length; i++) {
732 	        AddBonusToList(bonusCode[i], ETHsumInFinney[i], BTCsumInFinney[i] );
733 	    }
734 	}
735     /**
736      * Add a new bonus code, only owner could call
737      */
738 	function AddBonusToList(bytes32 bonusCode, uint ETHsumInFinney, uint BTCsumInFinney) public onlyOwner {
739 		uint pos = bonusesMapPos[bonusCode];
740 
741 		if (pos > 0) {
742 			pos -= 1;
743 			bonusesList[pos].maxBonusETH = ETHsumInFinney * 1 finney;
744 			bonusesList[pos].maxBonusBTC = BTCsumInFinney * 1 finney;
745 		} else {
746 			bonusStruct memory newStruct;
747 			newStruct.balancePos = 0;
748 			newStruct.notempty = false;
749 			newStruct.maxBonusETH = ETHsumInFinney * 1 finney;
750 			newStruct.maxBonusBTC = BTCsumInFinney * 1 finney;
751 			newStruct.bonusETH = 0;
752 			newStruct.bonusBTC = 0;
753 			newStruct.bonusPercent = 20;
754 			pos = bonusesList.push(newStruct);		
755 			bonusesMapPos[bonusCode] = pos;
756 		}
757 	}
758 	bool public BonusesDistributed = false;
759 	uint public BonusCalcPos = 0;
760 //    bytes public lastdata;
761 	function checkBonus(uint newBalancePos, uint sumETH, uint sumBTC, uint TransTime, uint pos) internal {
762 			if (pos > 0) {
763 				pos--;
764 				if (!bonusesList[pos].notempty) {
765 					bonusesList[pos].balancePos = newBalancePos;
766 					bonusesList[pos].notempty = true;
767 				} else {
768 				    if (bonusesList[pos].balancePos != newBalancePos) return;
769 				}
770 				bonusesList[pos].bonusETH = bonusesList[pos].bonusETH.add(sumETH);
771 				// if (bonusesList[pos].bonusETH > bonusesList[pos].maxBonusETH)
772 				// 	bonusesList[pos].bonusETH = bonusesList[pos].maxBonusETH;
773 				bonusesList[pos].bonusBTC = bonusesList[pos].bonusBTC.add(sumBTC);
774 				// if (bonusesList[pos].bonusBTC > bonusesList[pos].maxBonusBTC)
775 				// 	bonusesList[pos].bonusBTC = bonusesList[pos].maxBonusBTC;
776 			}
777 	}
778 
779     /**
780      * Calc the number of bonus tokens for N next bonus participants, only owner could call
781      */
782 	function calcNextNBonuses(uint N) public onlyOwner {
783 		require(crowdSaleState == CrowdSaleState.Success);
784 		require(!BonusesDistributed);
785 		uint nextPos = BonusCalcPos + N;
786 		if (nextPos > bonusesList.length) 
787 			nextPos = bonusesList.length;
788         uint bonusCapUSD_local = bonusCapUSD;    
789 		for (uint i = BonusCalcPos; i < nextPos; i++) {
790 			if  ((bonusesList[i].notempty) && (bonusesList[i].balancePos < balanceList.length)) {
791 				uint maxbonus = convertToUSD(bonusesList[i].maxBonusETH, bonusesList[i].maxBonusBTC);
792 				uint bonus = convertToUSD(bonusesList[i].bonusETH, bonusesList[i].bonusBTC);
793 				if (maxbonus < bonus)
794 				    bonus = maxbonus;
795 				bonus = bonus.mul(priceUSD);
796 				if (bonusCapUSD_local >= bonus) {
797 					bonusCapUSD_local = bonusCapUSD_local - bonus;
798 				} else {
799 					bonus = bonusCapUSD_local;
800 					bonusCapUSD_local = 0;
801 				}
802 				bonus = bonus.mul(bonusesList[i].bonusPercent) / 100;
803 				balanceList[bonusesList[i].balancePos].bonusTokens = bonus;
804 				if (bonusCapUSD_local == 0) {
805 					BonusesDistributed = true;
806 					break;
807 				}
808 			}
809 		}
810         bonusCapUSD = bonusCapUSD_local;    
811 		BonusCalcPos = nextPos;
812 		if (nextPos >= bonusesList.length) {
813 			BonusesDistributed = true;
814 		}
815 	}
816 
817 }