1 pragma solidity ^0.4.16;
2 
3 /** @title owned. */
4 contract owned  {
5   address owner;
6   function owned() {
7     owner = msg.sender;
8   }
9   function changeOwner(address newOwner) onlyOwner {
10     owner = newOwner;
11   }
12   modifier onlyOwner() {
13     require(msg.sender==owner); 
14     _;
15   }
16 }
17 
18 /** @title mortal. */
19 contract mortal is owned() {
20   function kill() onlyOwner {
21     if (msg.sender == owner) selfdestruct(owner);
22   }
23 }
24 
25 /** @title DSMath. */
26 contract DSMath {
27 
28 	// Copyright (C) 2015, 2016, 2017  DappHub, LLC
29 
30 	// Licensed under the Apache License, Version 2.0 (the "License").
31 	// You may not use this file except in compliance with the License.
32 
33 	// Unless required by applicable law or agreed to in writing, software
34 	// distributed under the License is distributed on an "AS IS" BASIS,
35 	// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
36     
37 	// /*
38     // uint128 functions (h is for half)
39     //  */
40 
41     function hmore(uint128 x, uint128 y) constant internal returns (bool) {
42         return x>y;
43     }
44 
45     function hless(uint128 x, uint128 y) constant internal returns (bool) {
46         return x<y;
47     }
48 
49     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
50         require((z = x + y) >= x);
51     }
52 
53     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
54         require((z = x - y) <= x);
55     }
56 
57     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
58         require(y == 0 ||(z = x * y)/ y == x);
59     }
60 
61     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
62         z = x / y;
63     }
64 
65     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
66         return x <= y ? x : y;
67     }
68 
69     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
70         return x >= y ? x : y;
71     }
72 
73     // /*
74     // int256 functions
75     //  */
76 
77     /*
78     WAD math
79      */
80     uint64 constant WAD_Dec=18;
81     uint128 constant WAD = 10 ** 18;
82 
83     function wmore(uint128 x, uint128 y) constant internal returns (bool) {
84         return hmore(x, y);
85     }
86 
87     function wless(uint128 x, uint128 y) constant internal returns (bool) {
88         return hless(x, y);
89     }
90 
91     function wadd(uint128 x, uint128 y) constant  returns (uint128) {
92         return hadd(x, y);
93     }
94 
95     function wsub(uint128 x, uint128 y) constant   returns (uint128) {
96         return hsub(x, y);
97     }
98 
99     function wmul(uint128 x, uint128 y) constant returns (uint128 z) {
100         z = cast((uint256(x) * y + WAD / 2) / WAD);
101     }
102 
103     function wdiv(uint128 x, uint128 y) constant internal  returns (uint128 z) {
104         z = cast((uint256(x) * WAD + y / 2) / y);
105     }
106 
107     function wmin(uint128 x, uint128 y) constant internal  returns (uint128) {
108         return hmin(x, y);
109     }
110 
111     function wmax(uint128 x, uint128 y) constant internal  returns (uint128) {
112         return hmax(x, y);
113     }
114 
115     function cast(uint256 x) constant internal returns (uint128 z) {
116         assert((z = uint128(x)) == x);
117     }
118 	
119 }
120  
121 /** @title I_minter. */
122 contract I_minter { 
123     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
124     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
125     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
126     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
127     event EventBankrupt();
128 
129     function Leverage() constant returns (uint128)  {}
130     function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) constant returns (uint128 price)  {}
131     function RiskPrice(uint128 _currentPrice) constant returns (uint128 price)  {}     
132     function PriceReturn(uint _TransID,uint128 _Price) {}
133     function NewStatic() external payable returns (uint _TransID)  {}
134     function NewStaticAdr(address _Risk) external payable returns (uint _TransID)  {}
135     function NewRisk() external payable returns (uint _TransID)  {}
136     function NewRiskAdr(address _Risk) external payable returns (uint _TransID)  {}
137     function RetRisk(uint128 _Quantity) external payable returns (uint _TransID)  {}
138     function RetStatic(uint128 _Quantity) external payable returns (uint _TransID)  {}
139     function Strike() constant returns (uint128)  {}
140 }
141 
142 /** @title I_Pricer. */
143 contract I_Pricer {
144     uint128 public lastPrice;
145     I_minter public mint;
146     string public sURL;
147     mapping (bytes32 => uint) RevTransaction;
148     function __callback(bytes32 myid, string result) {}
149     function queryCost() constant returns (uint128 _value) {}
150     function QuickPrice() payable {}
151     function requestPrice(uint _actionID) payable returns (uint _TrasID) {}
152     function collectFee() returns(bool) {}
153     function () {
154         //if ether is sent to this address, send it back.
155         revert();
156     }
157 }
158 
159 /** @title I_coin. */
160 contract I_coin is mortal {
161 
162     event EventClear();
163 
164 	I_minter public mint;
165     string public name;                   //fancy name: eg Simon Bucks
166     uint8 public decimals=18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
167     string public symbol;                 //An identifier: eg SBX
168     string public version = '';       //human 0.1 standard. Just an arbitrary versioning scheme.
169 	
170     function mintCoin(address target, uint256 mintedAmount) returns (bool success) {}
171     function meltCoin(address target, uint256 meltedAmount) returns (bool success) {}
172     function approveAndCall(address _spender, uint256 _value, bytes _extraData){}
173 
174     function setMinter(address _minter) {}   
175 	function increaseApproval (address _spender, uint256 _addedValue) returns (bool success) {}    
176 	function decreaseApproval (address _spender, uint256 _subtractedValue) 	returns (bool success) {} 
177 
178     // @param _owner The address from which the balance will be retrieved
179     // @return The balance
180     function balanceOf(address _owner) constant returns (uint256 balance) {}    
181 
182 
183     // @notice send `_value` token to `_to` from `msg.sender`
184     // @param _to The address of the recipient
185     // @param _value The amount of token to be transferred
186     // @return Whether the transfer was successful or not
187     function transfer(address _to, uint256 _value) returns (bool success) {}
188 
189 
190     // @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
191     // @param _from The address of the sender
192     // @param _to The address of the recipient
193     // @param _value The amount of token to be transferred
194     // @return Whether the transfer was successful or not
195     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
196 
197     // @notice `msg.sender` approves `_addr` to spend `_value` tokens
198     // @param _spender The address of the account able to transfer the tokens
199     // @param _value The amount of wei to be approved for transfer
200     // @return Whether the approval was successful or not
201     function approve(address _spender, uint256 _value) returns (bool success) {}
202 
203     event Transfer(address indexed _from, address indexed _to, uint256 _value);
204     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
205 	
206 	// @param _owner The address of the account owning tokens
207     // @param _spender The address of the account able to transfer the tokens
208     // @return Amount of remaining tokens allowed to spent
209     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
210 	
211 	mapping (address => uint256) balances;
212     mapping (address => mapping (address => uint256)) allowed;
213 
214 	// @return total amount of tokens
215     uint256 public totalSupply;
216 }
217 
218 /** @title DSBaseActor. */
219 contract DSBaseActor {
220    /*
221    Copyright 2016 Nexus Development, LLC
222 
223    Licensed under the Apache License, Version 2.0 (the "License");
224    you may not use this file except in compliance with the License.
225    You may obtain a copy of the License at
226 
227        http://www.apache.org/licenses/LICENSE-2.0
228 
229    Unless required by applicable law or agreed to in writing, software
230    distributed under the License is distributed on an "AS IS" BASIS,
231    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
232    See the License for the specific language governing permissions and
233    limitations under the License.
234    */
235 
236     bool _ds_mutex;
237     modifier mutex() {
238         assert(!_ds_mutex);
239         _ds_mutex = true;
240         _;
241         _ds_mutex = false;
242     }
243 	
244     function tryExec( address target, bytes calldata, uint256 value)
245 			mutex()
246             internal
247             returns (bool call_ret)
248     {
249 		/** @dev Requests new StatiCoins be made for a given address
250           * @param target where the ETH is sent to.
251           * @param calldata
252           * @param value
253           * @return True if ETH is transfered
254         */
255         return target.call.value(value)(calldata);
256     }
257 	
258     function exec( address target, bytes calldata, uint256 value)
259              internal
260     {
261         assert(tryExec(target, calldata, value));
262     }
263 }
264 
265 /** @title canFreeze. */
266 contract canFreeze is owned { 
267 	//Copyright (c) 2017 GenkiFS
268 	//Basically a "break glass in case of emergency"
269     bool public frozen=false;
270     modifier LockIfFrozen() {
271         if (!frozen){
272             _;
273         }
274     }
275     function Freeze() onlyOwner {
276         // fixes the price and allows everyone to redeem their coins at the current value
277 		// only becomes false when all ETH has been claimed or the pricer contract is changed
278         frozen=true;
279     }
280 }
281 
282 /** @title oneWrite. */
283 contract oneWrite {  
284 	//  Adds modifies that allow one function to be called only once
285 	//Copyright (c) 2017 GenkiFS
286   bool written = false;
287   function oneWrite() {
288 	/** @dev Constuctor, make sure written=false initally
289 	*/
290     written = false;
291   }
292   modifier LockIfUnwritten() {
293     if (written){
294         _;
295     }
296   }
297   modifier writeOnce() {
298     if (!written){
299         written=true;
300         _;
301     }
302   }
303 }
304 
305 /** @title pricerControl. */
306 contract pricerControl is canFreeze {
307 	//  Copyright (c) 2017 GenkiFS
308 	//  Controls the Pricer contract for minter.  Allows updates to be made in the future by swapping the pricer contract
309 	//  Although this is not expected, web addresses, API's, new oracles could require adjusments to the pricer contract
310 	//  A delay of 2 days is implemented to allow coinholders to redeem their coins if they do not agree with the new contract
311 	//  A new pricer contract unfreezes the minter (allowing a live price to be used)
312     I_Pricer public pricer;
313     address public future;
314     uint256 public releaseTime;
315     uint public PRICER_DELAY = 2; // days updated when coins are set
316     event EventAddressChange(address indexed _from, address indexed _to, uint _timeChange);
317 
318     function setPricer(address newAddress) onlyOwner {
319 		/** @dev Changes the Pricer contract, after a certain delay
320           * @param newAddress Allows coins to be created and sent to other people
321           * @return transaction ID which can be viewed in the pending mapping
322         */
323         releaseTime = now + PRICER_DELAY;
324         future = newAddress;
325         EventAddressChange(pricer, future, releaseTime);
326     }  
327 
328     modifier updates() {
329         if (now > releaseTime  && pricer != future){
330             update();
331             //log0('Updating');
332         }
333         _;
334     }
335 
336     modifier onlyPricer() {
337       require(msg.sender==address(pricer));
338       _;
339     }
340 
341     function update() internal {
342         pricer =  I_Pricer(future);
343 		frozen = false;
344     }
345 }
346 
347 /** @title minter. */	
348 contract minter is I_minter, DSBaseActor, oneWrite, pricerControl, DSMath{ //
349 	// Copyright (c) 2017 GenkiFS
350 	// This contract is the controller for the StatiCoin contracts.  
351 	// Users have 4(+2) functions they can call to mint/melt Static/Risk coins which then calls the Pricer contract
352 	// after a delay the Pricer contract will call back to the PriceReturn() function
353 	// this will then call one of the functions ActionNewStatic, ActionNewRisk, ActionRetStatic, ActionRetRisk
354 	// which will then call the Static or Risk ERC20 contracts to mint/melt new tokens
355 	// Transfer of tokens is handled by the ERC20 contracts, ETH is stored here.  
356     enum Action {NewStatic, RetStatic, NewRisk, RetRisk} // Enum of what users can do
357     struct Trans { // Struct
358         uint128 amount; // Amount sent by the user (Can be either ETH or number of returned coins)
359         address holder; // Address of the user
360         Action action;  // Type of action requested (mint/melt a Risk/StatiCoin)
361 		bytes32 pricerID;  // ID for the pricer function
362     }
363     uint128 public lastPrice; //Storage of the last price returned by the Pricer contract
364 	uint128 public PendingETH; //Amount of eth to be added to the contract
365     uint public TransID=0; // An increasing counter to keep track of transactions requested
366 	uint public TransCompleted; // Last transaction removed
367     string public Currency; // Name of underlying base currency
368     I_coin public Static;  // ERC20 token interface for the StatiCoin
369     I_coin public Risk;  // ERC20 token interface for the Risk coin
370     uint128 public Multiplier;//=15*10**(17); // default ratio for Risk price
371     uint128 public levToll=5*10**(18-1);//0.5  // this plus the multiplier defines the maximum leverage
372     uint128 public mintFee = 2*10**(18-3); //0.002 Used to pay oricalize and for marketing contract which is in both parties interest.
373     mapping (uint => Trans[]) public pending; // A mapping of pending transactions
374 
375     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
376     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
377     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
378     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
379     event EventBankrupt();	//Called when no more ETH is in the contract and everything needs to be manually reset.  
380 	
381 	function minter(string _currency, uint128 _Multiplier) { //,uint8 _DecimalPlaces
382         // CONSTRUCTOR  
383         Currency=_currency;
384         Multiplier = _Multiplier;
385         // can't add new contracts here as it gives out of gas messages.  Too much code.
386     }	
387 
388 	function () {
389         //if ETH is just sent to this address then we cannot determine if it's for StatiCoins or RiskCoins, so send it back.
390         revert();
391     }
392 
393 	function Bailout() 
394 			external 
395 			payable 
396 			{
397         /** @dev Allows extra ETH to be added to the benefit of both types of coin holders
398           * @return nothing
399         */
400     }
401 		
402     function NewStatic() 
403 			external 
404 			payable 
405 			returns (uint _TransID) {
406         /** @dev Requests new StatiCoins be made for the sender.  
407 		  * This cannot be called by a contract.  Only a simple wallet (with 0 codesize).
408 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
409           * @return transaction ID which can be viewed in the pending mapping
410         */
411 		_TransID=NewCoinInternal(msg.sender,cast(msg.value),Action.NewStatic);
412 		//log0('NewStatic');
413     }
414 	
415     function NewStaticAdr(address _user) 
416 			external 
417 			payable 
418 			returns (uint _TransID)  {  
419         /** @dev Requests new StatiCoins be made for a given address.  
420 		  * The address cannot be a contract, only a simple wallet (with 0 codesize).
421 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
422           * @param _user Allows coins to be created and sent to other people
423           * @return transaction ID which can be viewed in the pending mapping
424         */
425 		_TransID=NewCoinInternal(_user,cast(msg.value),Action.NewStatic);
426 		//log0('NewStatic');
427     }
428 	
429     function NewRisk() 
430 			external 
431 			payable 
432 			returns (uint _TransID)  {
433         /** @dev Requests new Riskcoins be made for the sender.  
434 		  * This cannot be called by a contract, only a simple wallet (with 0 codesize).
435 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
436           * @return transaction ID which can be viewed in the pending mapping
437           */
438 		_TransID=NewCoinInternal(msg.sender,cast(msg.value),Action.NewRisk);
439         //log0('NewRisk');
440     }
441 
442     function NewRiskAdr(address _user) 
443 			external 
444 			payable 
445 			returns (uint _TransID)  {
446         /** @dev Requests new Riskcoins be made for a given address.  
447 		  * The address cannot be a contract, only a simple wallet (with 0 codesize).
448 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
449           * @param _user Allows coins to be created and sent to other people
450           * @return transaction ID which can be viewed in the pending mapping
451           */
452 		_TransID=NewCoinInternal(_user,cast(msg.value),Action.NewRisk);
453         //log0('NewRisk');
454     }
455 
456     function RetRisk(uint128 _Quantity) 
457 			external 
458 			payable 
459 			LockIfUnwritten  
460 			returns (uint _TransID)  {
461         /** @dev Returns Riskcoins.  Needs a bit of eth sent to pay the pricer contract and the excess is returned.  
462 		  * The address cannot be a contract, only a simple wallet (with 0 codesize).
463           * @param _Quantity Amount of coins being returned
464 		  * @return transaction ID which can be viewed in the pending mapping
465         */
466         if(frozen){
467             //Skip the pricer contract
468             TransID++;
469 			ActionRetRisk(Trans(_Quantity,msg.sender,Action.RetRisk,0),TransID,lastPrice);
470 			_TransID=TransID;
471         } else {
472             //Only returned when Risk price is positive
473 			_TransID=RetCoinInternal(_Quantity,cast(msg.value),msg.sender,Action.RetRisk);
474         }
475 		//log0('RetRisk');
476     }
477 
478     function RetStatic(uint128 _Quantity) 
479 			external 
480 			payable 
481 			LockIfUnwritten  
482 			returns (uint _TransID)  {
483         /** @dev Returns StatiCoins,  Needs a bit of eth sent to pay the pricer contract
484           * @param _Quantity Amount of coins being returned
485 		  * @return transaction ID which can be viewed in the pending mapping
486         */
487         if(frozen){
488             //Skip the pricer contract
489 			TransID++;
490             ActionRetStatic(Trans(_Quantity,msg.sender,Action.RetStatic,0),TransID,lastPrice);
491 			_TransID=TransID;
492         } else {
493             //Static can be returned at any time
494 			_TransID=RetCoinInternal(_Quantity,cast(msg.value),msg.sender,Action.RetStatic);
495         }
496 		//log0('RetStatic');
497     }
498 	
499 	//****************************//
500 	// Constant functions (Ones that don't write to the blockchain)
501 
502     function StaticEthAvailable() 
503 			constant 
504 			returns (uint128)  {
505 		/** @dev Returns the total amount of eth that can be sent to buy StatiCoins
506 		  * @return amount of Eth
507         */
508 		return StaticEthAvailable(cast(Risk.totalSupply()), cast(this.balance));
509     }
510 
511 	function StaticEthAvailable(uint128 _RiskTotal, uint128 _TotalETH) 
512 			constant 
513 			returns (uint128)  {
514 		/** @dev Returns the total amount of eth that can be sent to buy StatiCoins allows users to test arbitrary amounts of RiskTotal and ETH contained in the contract
515 		  * @param _RiskTotal Quantity of riskcoins
516           * @param  _TotalETH Total value of ETH in the contract
517 		  * @return amount of Eth
518         */
519 		// (Multiplier+levToll)*_RiskTotal - _TotalETH
520 		uint128 temp = wmul(wadd(Multiplier,levToll),_RiskTotal);
521 		if(wless(_TotalETH,temp)){
522 			return wsub(temp ,_TotalETH);
523 		} else {
524 			return 0;
525 		}
526     }
527 
528 	function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) 
529 			constant 
530 			returns (uint128 price)  {
531 	    /** @dev Allows users to query various hypothetical prices of RiskCoins in terms of base currency
532           * @param _currentPrice Current price of ETH in Base currency.
533           * @param _StaticTotal Total quantity of StatiCoins issued.
534           * @param _RiskTotal Total quantity of invetor coins issued.
535           * @param _ETHTotal Total quantity of ETH in the contract.
536           * @return price of RiskCoins 
537         */
538         if(_ETHTotal == 0 || _RiskTotal==0){
539 			//Return the default price of _currentPrice * Multiplier
540             return wmul( _currentPrice , Multiplier); 
541         } else {
542             if(hmore( wmul(_ETHTotal , _currentPrice),_StaticTotal)){ //_ETHTotal*_currentPrice>_StaticTotal
543 				//Risk price is positive
544                 return wdiv(wsub(wmul(_ETHTotal , _currentPrice) , _StaticTotal) , _RiskTotal); // (_ETHTotal * _currentPrice) - _StaticTotal) / _RiskTotal
545             } else  {
546 				//RiskPrice is negative
547                 return 0;
548             }
549         }       
550     }
551 	
552     function RiskPrice(uint128 _currentPrice) 
553 			constant 
554 			returns (uint128 price)  {
555 	    /** @dev Allows users to query price of RiskCoins in terms of base currency, using current quantities of coins
556           * @param _currentPrice Current price of ETH in Base currency.
557 	      * @return price of RiskCoins 
558         */
559         return RiskPrice(_currentPrice,cast(Static.totalSupply()),cast(Risk.totalSupply()),wsub(cast(this.balance),PendingETH));
560     }     
561 
562     function LastRiskPrice() 
563 			constant 
564 			returns (uint128 price)  {
565 	    /** @dev Allows users to query the last price of RiskCoins in terms of base currency
566         *   @return price of RiskCoins 
567         */
568         return RiskPrice(lastPrice);
569     }     		
570 	
571 	function Leverage() public 
572 			constant 
573 			returns (uint128)  {
574 		/** @dev Returns the ratio at which Riskcoin grows in value for the equivalent growth in ETH price
575 		* @return ratio
576         */
577         if(Risk.totalSupply()>0){
578             return wdiv(cast(this.balance) , cast(Risk.totalSupply())); //  this.balance/Risk.totalSupply
579         }else{
580             return 0;
581         }
582     }
583 
584     function Strike() public 
585 			constant 
586 			returns (uint128)  {
587 		/** @dev Returns the current price at which the Risk price goes negative
588 		* @return Risk price in underlying per ETH
589         */ 
590         if(this.balance>0){
591             return wdiv(cast(Static.totalSupply()) , cast(this.balance)); //Static.totalSupply / this.balance
592         }else{
593             return 0;            
594         }
595     }
596 
597 	//****************************//
598 	// Only owner can access the following functions
599     function setFee(uint128 _newFee) 
600 			onlyOwner {
601         /** @dev Allows the minting fee to be changed, only owner can modify
602           * @param _newFee Size of new fee
603           * return nothing 
604         */
605         mintFee=_newFee;
606     }
607 
608     function setCoins(address newRisk,address newStatic) 
609 			updates 
610 			onlyOwner 
611 			writeOnce {
612         /** @dev Allows the minting fee to be reduced, only owner can modify once, Triggers the pricer to be updated 
613           * @param newRisk Address of Riskcoin contract
614           * @param newStatic Address of StatiCoin contract
615           * return nothing 
616         */
617         Risk=I_coin(newRisk);
618         Static=I_coin(newStatic);
619 		PRICER_DELAY = 2 days;
620     }
621 	
622 	//****************************//	
623 	// Only Pricer can access the following function
624     function PriceReturn(uint _TransID,uint128 _Price) 
625 			onlyPricer {
626 	    /** @dev Return function for the Pricer contract only.  Controls melting and minting of new coins.
627           * @param _TransID Tranasction ID issued by the minter.
628           * @param _Price Quantity of Base currency per ETH delivered by the Pricer contract
629           * Nothing returned.  One of 4 functions is implemented
630         */
631 	    Trans memory details=pending[_TransID][0];//Get the details for this transaction. 
632         if(0==_Price||frozen){ //If there is an error in pricing or contract is frozen, use the old price
633             _Price=lastPrice;
634         } else {
635 			if(Static.totalSupply()>0 && Risk.totalSupply()>0) {// dont update if there are coins missing
636 				lastPrice=_Price; // otherwise update the last price
637 			}
638         }
639 		//Mint some new StatiCoins
640         if(Action.NewStatic==details.action){
641             ActionNewStatic(details,_TransID, _Price);
642         }
643 		//Melt some old StatiCoins
644         if(Action.RetStatic==details.action){
645             ActionRetStatic(details,_TransID, _Price);
646         }
647 		//Mint some new Risk coins
648         if(Action.NewRisk==details.action){
649             ActionNewRisk(details,_TransID, _Price);
650         }
651 		//Melt some old Risk coin
652         if(Action.RetRisk==details.action){
653             ActionRetRisk(details,_TransID, _Price);
654         }
655 		//Remove the transaction from the blockchain (saving some gas)
656 		TransCompleted=_TransID;
657 		delete pending[_TransID];
658     }
659 	
660 	//****************************//
661     // Only internal functions now
662     function ActionNewStatic(Trans _details, uint _TransID, uint128 _Price) 
663 			internal {
664 		/** @dev Internal function to create new StatiCoins based on transaction data in the Pending queue.  If not enough spare StatiCoins are available then ETH is refunded.
665           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
666           * @param _TransID ID of the transaction (as stored in this contract).
667           * @param _Price Current 24 hour average price as returned by the oracle in the pricer contract.
668           * @return function returns nothing, but adds StatiCoins to the users address and events are created
669         */
670 		//log0('NewStatic');
671             
672             //if(Action.NewStatic<>_details.action){revert();}  //already checked
673 			
674 			uint128 CurRiskPrice=RiskPrice(_Price);
675 			uint128 AmountReturn;
676 			uint128 AmountMint;
677 			
678 			//Calculates the amount of ETH that can be added to create StatiCoins (excluding the amount already sent and stored in the contract)
679 			uint128 StaticAvail = StaticEthAvailable(cast(Risk.totalSupply()), wsub(cast(this.balance),PendingETH)); 
680 						
681 			// If the amount sent is less than the Static amount available, everything is fine.  Nothing needs to be returned.  
682 			if (wless(_details.amount,StaticAvail)) {
683 				// restrictions do not hamper the creation of a StatiCoin
684 				AmountMint = _details.amount;
685 				AmountReturn = 0;
686 			} else {
687 				// Amount of Static is less than amount requested.  
688 				// Take all the StatiCoins available.
689 				// Maybe there is zero Static available, so all will be returned.
690 				AmountMint = StaticAvail;
691 				AmountReturn = wsub(_details.amount , StaticAvail) ;
692 			}	
693 			
694 			if(0 == CurRiskPrice){
695 				// return all the ETH
696 				AmountReturn = _details.amount;
697 				//AmountMint = 0; //not required as Risk price = 0
698 			}
699 			
700 			//Static can be added when Risk price is positive and leverage is below the limit
701             if(CurRiskPrice > 0  && StaticAvail>0 ){
702                 // Dont create if CurRiskPrice is 0 or there is no Static available (leverage is too high)
703 				//log0('leverageOK');
704                 Static.mintCoin(_details.holder, uint256(wmul(AmountMint , _Price))); //request coins from the Static creator contract
705                 EventCreateStatic(_details.holder, wmul(AmountMint , _Price), _TransID, _Price); // Event giving the holder address, coins created, transaction id, and price 
706 				PendingETH=wsub(PendingETH,AmountMint);
707             } 
708 
709 			if (AmountReturn>0) {
710                 // return some money because not enough StatiCoins are available
711 				bytes memory calldata; // define a blank `bytes`
712                 exec(_details.holder,calldata, AmountReturn);  //Refund ETH from this contract
713 				PendingETH=wsub(PendingETH,AmountReturn);
714 			}	
715     }
716 
717     function ActionNewRisk(Trans _details, uint _TransID,uint128 _Price) 
718 			internal {
719 		/** @dev Internal function to create new Risk coins based on transaction data in the Pending queue.  Risk coins can only be created if the price is above zero
720           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
721           * @param _TransID ID of the transaction (as stored in this contract).
722           * @param _Price Current 24 hour average price as returned by the oracle in the pricer contract.
723           * @return function returns nothing, but adds Riskcoins to the users address and events are created
724         */
725         //log0('NewRisk');
726         //if(Action.NewRisk<>_details.action){revert();}  //already checked
727 		// Get the Risk price using the amount of ETH in the contract before this transaction existed
728 		uint128 CurRiskPrice;
729 		if(wless(cast(this.balance),PendingETH)){
730 			CurRiskPrice=0;
731 		} else {
732 			CurRiskPrice=RiskPrice(_Price,cast(Static.totalSupply()),cast(Risk.totalSupply()),wsub(cast(this.balance),PendingETH));
733 		}
734         if(CurRiskPrice>0){
735             uint128 quantity=wdiv(wmul(_details.amount , _Price),CurRiskPrice);  // No of Riskcoins =  _details.amount * _Price / CurRiskPrice
736             Risk.mintCoin(_details.holder, uint256(quantity) );  //request coins from the Riskcoin creator contract
737             EventCreateRisk(_details.holder, quantity, _TransID, _Price); // Event giving the holder address, coins created, transaction id, and price 
738         } else {
739             // Don't create if CurRiskPrice is 0, Return all the ETH originally sent
740             bytes memory calldata; // define a blank `bytes`
741             exec(_details.holder,calldata, _details.amount);
742         }
743 		PendingETH=wsub(PendingETH,_details.amount);
744     }
745 
746     function ActionRetStatic(Trans _details, uint _TransID,uint128 _Price) 
747 			internal {
748 		/** @dev Internal function to Return StatiCoins based on transaction data in the Pending queue.  Static can be returned at any time.
749           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
750           * @param _TransID ID of the transaction (as stored in this contract).
751           * @param _Price Current 24 hour average price as returned by the oracle in the pricer contract.
752           * @return function returns nothing, but removes StatiCoins from the user's address, sends ETH and events are created
753         */
754 		//if(Action.RetStatic<>_details.action){revert();}  //already checked
755 		//log0('RetStatic');
756 		uint128 _ETHReturned;
757 		if(0==Risk.totalSupply()){_Price=lastPrice;} //No Risk coins for balance so use fixed price
758         _ETHReturned = wdiv(_details.amount , _Price); //_details.amount / _Price
759         if (Static.meltCoin(_details.holder,_details.amount)){
760             // deducted first, will add back if Returning ETH goes wrong.
761             EventRedeemStatic(_details.holder,_details.amount ,_TransID, _Price);
762             if (wless(cast(this.balance),_ETHReturned)) {
763                  _ETHReturned=cast(this.balance);//Not enough ETH available.  Return all Eth in the contract
764             }
765 			bytes memory calldata; // define a blank `bytes`
766             if (tryExec(_details.holder, calldata, _ETHReturned)) { 
767 				//ETH returned successfully
768 			} else {
769 				// there was an error, so add back the amount previously deducted
770 				Static.mintCoin(_details.holder,_details.amount); //Add back the amount requested
771 				EventCreateStatic(_details.holder,_details.amount ,_TransID, _Price);  //redo the creation event
772 			}
773 			if ( 0==this.balance) {
774 				Bankrupt();
775 			}
776         }        
777     }
778 
779     function ActionRetRisk(Trans _details, uint _TransID,uint128 _Price) 
780 			internal {
781 		/** @dev Internal function to Return Riskcoins based on transaction data in the Pending queue.  Riskcoins can be returned so long as the Risk price is greater than 0.
782           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
783           * @param _TransID ID of the transaction (as stored in this contract).
784           * @param _Price Current 24 hour average price as returned by the oracle in the Pricer contract.
785           * @return function returns nothing, but removes StatiCoins from the users address, sends ETH and events are created
786         */        
787 		//if(Action.RetRisk<>_details.action){revert();}  //already checked
788 		//log0('RetRisk');
789         uint128 _ETHReturned;
790 		uint128 CurRiskPrice;
791 		//if(0==Static.totalSupply()){_Price=lastPrice};// no StatiCoins, so all Risk coins are worth the same.  // _ETHReturned = _details.amount / _RiskTotal * _ETHTotal
792 		CurRiskPrice=RiskPrice(_Price);
793         if(CurRiskPrice>0){
794             _ETHReturned = wdiv( wmul(_details.amount , CurRiskPrice) , _Price); // _details.amount * CurRiskPrice / _Price
795             if (Risk.meltCoin(_details.holder,_details.amount )){
796                 // Coins are deducted first, will add back if returning ETH goes wrong.
797                 EventRedeemRisk(_details.holder,_details.amount ,_TransID, _Price);
798                 if ( wless(cast(this.balance),_ETHReturned)) { // should never happen, but just in case
799                      _ETHReturned=cast(this.balance);
800                 }
801 				bytes memory calldata; // define a blank `bytes`
802                 if (tryExec(_details.holder, calldata, _ETHReturned)) { 
803 					//Returning ETH went ok.  
804                 } else {
805                     // there was an error, so add back the amount previously deducted from the Riskcoin contract
806                     Risk.mintCoin(_details.holder,_details.amount);
807                     EventCreateRisk(_details.holder,_details.amount ,_TransID, _Price);
808                 }
809             } 
810         }  else {
811             // Risk price is zero so can't do anything.  Call back and delete the transaction from the contract
812         }
813     }
814 
815 	function IsWallet(address _address) 
816 			internal 
817 			returns(bool){
818 		/**
819 		* @dev checks that _address is not a contract.  
820 		* @param _address to check 
821 		* @return True if not a contract, 
822 		*/		
823 		uint codeLength;
824 		assembly {
825             // Retrieve the size of the code on target address, this needs assembly .
826             codeLength := extcodesize(_address)
827         }
828 		return(0==codeLength);		
829     } 
830 
831 	function RetCoinInternal(uint128 _Quantity, uint128 _AmountETH, address _user, Action _action) 
832 			internal 
833 			updates 
834 			returns (uint _TransID)  {
835         /** @dev Requests coins be melted and ETH returned
836 		  * @param _Quantity of Static or Risk coins to be melted0
837 		  * @param _AmountETH Amount of eth sent to this contract to cover oracle fee.  Excess is returned.
838           * @param _user Address to whom the returned ETH will be sent.
839 		  * @param _action Allows Static or Risk coins to be returned
840 		  * @return transaction ID which can be viewed in the Pending mapping
841         */
842 		require(IsWallet(_user));
843 		uint128 refund;
844         uint128 Fee=pricer.queryCost();  //Get the cost of querying the pricer contract
845 		if(wless(_AmountETH,Fee)){
846 			revert();  //log0('Not enough ETH to mint');
847 			} else {
848 			refund=wsub(_AmountETH,Fee);//Returning coins has had too much ETH sent, so return it.
849 		}
850 		if(0==_Quantity){revert();}// quantity has to be non zero
851 		TransID++;
852         
853         uint PricerID = pricer.requestPrice.value(uint256(Fee))(TransID);  //Ask the pricer to get the price.  The Fee also cover calling the function PriceReturn at a later time.
854 		pending[TransID].push(Trans(_Quantity,_user,_action,bytes32(PricerID)));  //Add a transaction to the Pending queue.
855         _TransID=TransID;  //return the transaction ID to the user 
856         _user.transfer(uint256(refund)); //Return ETH if too much has been sent to cover the pricer
857     }
858 		
859 	function NewCoinInternal(address _user, uint128 _amount, Action _action) 
860 			internal 
861 			updates 
862 			LockIfUnwritten 
863 			LockIfFrozen  
864 			returns (uint _TransID)  {
865 		/** @dev Requests new coins be made
866           * @param _user Address for whom the coins are to be created
867           * @param _amount Amount of eth sent to this contract
868 		  * @param _action Allows Static or Risk coins to be minted
869 		  * @return transaction ID which can be viewed in the pending mapping
870         */
871 		require(IsWallet(_user));
872 		uint128 toCredit;
873         uint128 Fee=wmax(wmul(_amount,mintFee),pricer.queryCost()); // fee is the maxium of the pricer query cost and a mintFee% of value sent
874         if(wless(_amount,Fee)) revert(); //log0('Not enough ETH to mint');
875 		TransID++;
876         uint PricerID = pricer.requestPrice.value(uint256(Fee))(TransID); //Ask the pricer to return the price
877 		toCredit=wsub(_amount,Fee);
878 		pending[TransID].push(Trans(toCredit,_user,_action,bytes32(PricerID))); //Store the transaction ID and data ready for later recall
879 		PendingETH=wadd(PendingETH,toCredit);
880         _TransID=TransID;//return the transaction ID for this contract to the user 		
881 	} 
882 
883     function Bankrupt() 
884 			internal {
885 			EventBankrupt();
886 			// Reset the contract
887 			Static.kill();  //delete all current Static tokens
888 			Risk.kill();  //delete all current Risk tokens
889 			//need to create new coins externally, too much gas is used if done here.  
890 			frozen=false;
891 			written=false;  // Reset the writeOnce and LockIfUnwritten modifiers
892     }
893 }