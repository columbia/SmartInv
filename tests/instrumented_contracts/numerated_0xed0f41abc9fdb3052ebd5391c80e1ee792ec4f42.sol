1 pragma solidity ^0.4.16;
2 //User interface at http://www.staticoin.com
3 //Full source code at https://github.com/genkifs/staticoin
4 
5 /** @title owned. */
6 contract owned  {
7   address owner;
8   function owned() {
9     owner = msg.sender;
10   }
11   function changeOwner(address newOwner) onlyOwner {
12     owner = newOwner;
13   }
14   modifier onlyOwner() {
15     if (msg.sender==owner) 
16     _;
17   }
18 }
19 
20 /** @title mortal. */
21 contract mortal is owned() {
22   function kill() onlyOwner {
23     if (msg.sender == owner) selfdestruct(owner);
24   }
25 }
26 
27 /** @title DSMath. */
28 contract DSMath {
29 
30 	// Copyright (C) 2015, 2016, 2017  DappHub, LLC
31 
32 	// Licensed under the Apache License, Version 2.0 (the "License").
33 	// You may not use this file except in compliance with the License.
34 
35 	// Unless required by applicable law or agreed to in writing, software
36 	// distributed under the License is distributed on an "AS IS" BASIS,
37 	// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
38     
39 	// /*
40     // uint128 functions (h is for half)
41     //  */
42 
43     function hmore(uint128 x, uint128 y) constant internal returns (bool) {
44         return x>y;
45     }
46 
47     function hless(uint128 x, uint128 y) constant internal returns (bool) {
48         return x<y;
49     }
50 
51     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
52         require((z = x + y) >= x);
53     }
54 
55     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
56         require((z = x - y) <= x);
57     }
58 
59     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
60         require(y == 0 ||(z = x * y)/ y == x);
61     }
62 
63     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
64         z = x / y;
65     }
66 
67     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
68         return x <= y ? x : y;
69     }
70 
71     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
72         return x >= y ? x : y;
73     }
74 
75     // /*
76     // int256 functions
77     //  */
78 
79     /*
80     WAD math
81      */
82     uint64 constant WAD_Dec=18;
83     uint128 constant WAD = 10 ** 18;
84 
85     function wmore(uint128 x, uint128 y) constant internal returns (bool) {
86         return hmore(x, y);
87     }
88 
89     function wless(uint128 x, uint128 y) constant internal returns (bool) {
90         return hless(x, y);
91     }
92 
93     function wadd(uint128 x, uint128 y) constant  returns (uint128) {
94         return hadd(x, y);
95     }
96 
97     function wsub(uint128 x, uint128 y) constant   returns (uint128) {
98         return hsub(x, y);
99     }
100 
101     function wmul(uint128 x, uint128 y) constant returns (uint128 z) {
102         z = cast((uint256(x) * y + WAD / 2) / WAD);
103     }
104 
105     function wdiv(uint128 x, uint128 y) constant internal  returns (uint128 z) {
106         z = cast((uint256(x) * WAD + y / 2) / y);
107     }
108 
109     function wmin(uint128 x, uint128 y) constant internal  returns (uint128) {
110         return hmin(x, y);
111     }
112 
113     function wmax(uint128 x, uint128 y) constant internal  returns (uint128) {
114         return hmax(x, y);
115     }
116 
117     function cast(uint256 x) constant internal returns (uint128 z) {
118         assert((z = uint128(x)) == x);
119     }
120 	
121 }
122  
123 /** @title I_minter. */
124 contract I_minter { 
125     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
126     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
127     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
128     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
129     event EventBankrupt();
130 
131     function Leverage() constant returns (uint128)  {}
132     function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) constant returns (uint128 price)  {}
133     function RiskPrice(uint128 _currentPrice) constant returns (uint128 price)  {}     
134     function PriceReturn(uint _TransID,uint128 _Price) {}
135     function NewStatic() external payable returns (uint _TransID)  {}
136     function NewStaticAdr(address _Risk) external payable returns (uint _TransID)  {}
137     function NewRisk() external payable returns (uint _TransID)  {}
138     function NewRiskAdr(address _Risk) external payable returns (uint _TransID)  {}
139     function RetRisk(uint128 _Quantity) external payable returns (uint _TransID)  {}
140     function RetStatic(uint128 _Quantity) external payable returns (uint _TransID)  {}
141     function Strike() constant returns (uint128)  {}
142 }
143 
144 /** @title I_Pricer. */
145 contract I_Pricer {
146     uint128 public lastPrice;
147     I_minter public mint;
148     string public sURL;
149     mapping (bytes32 => uint) RevTransaction;
150 
151     function setMinter(address _newAddress) {}
152     function __callback(bytes32 myid, string result) {}
153     function queryCost() constant returns (uint128 _value) {}
154     function QuickPrice() payable {}
155     function requestPrice(uint _actionID) payable returns (uint _TrasID) {}
156     function collectFee() returns(bool) {}
157     function () {
158         //if ether is sent to this address, send it back.
159         revert();
160     }
161 }
162 
163 /** @title I_coin. */
164 contract I_coin is mortal {
165 
166     event EventClear();
167 
168 	I_minter public mint;
169     string public name;                   //fancy name: eg Simon Bucks
170     uint8 public decimals=18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
171     string public symbol;                 //An identifier: eg SBX
172     string public version = '';       //human 0.1 standard. Just an arbitrary versioning scheme.
173 	
174     function mintCoin(address target, uint256 mintedAmount) returns (bool success) {}
175     function meltCoin(address target, uint256 meltedAmount) returns (bool success) {}
176     function approveAndCall(address _spender, uint256 _value, bytes _extraData){}
177 
178     function setMinter(address _minter) {}   
179 	function increaseApproval (address _spender, uint256 _addedValue) returns (bool success) {}    
180 	function decreaseApproval (address _spender, uint256 _subtractedValue) 	returns (bool success) {} 
181 
182     // @param _owner The address from which the balance will be retrieved
183     // @return The balance
184     function balanceOf(address _owner) constant returns (uint256 balance) {}    
185 
186 
187     // @notice send `_value` token to `_to` from `msg.sender`
188     // @param _to The address of the recipient
189     // @param _value The amount of token to be transferred
190     // @return Whether the transfer was successful or not
191     function transfer(address _to, uint256 _value) returns (bool success) {}
192 
193 
194     // @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
195     // @param _from The address of the sender
196     // @param _to The address of the recipient
197     // @param _value The amount of token to be transferred
198     // @return Whether the transfer was successful or not
199     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
200 
201     // @notice `msg.sender` approves `_addr` to spend `_value` tokens
202     // @param _spender The address of the account able to transfer the tokens
203     // @param _value The amount of wei to be approved for transfer
204     // @return Whether the approval was successful or not
205     function approve(address _spender, uint256 _value) returns (bool success) {}
206 
207     event Transfer(address indexed _from, address indexed _to, uint256 _value);
208     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
209 	
210 	// @param _owner The address of the account owning tokens
211     // @param _spender The address of the account able to transfer the tokens
212     // @return Amount of remaining tokens allowed to spent
213     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
214 	
215 	mapping (address => uint256) balances;
216     mapping (address => mapping (address => uint256)) allowed;
217 
218 	// @return total amount of tokens
219     uint256 public totalSupply;
220 }
221 
222 /** @title DSBaseActor. */
223 contract DSBaseActor {
224    /*
225    Copyright 2016 Nexus Development, LLC
226 
227    Licensed under the Apache License, Version 2.0 (the "License");
228    you may not use this file except in compliance with the License.
229    You may obtain a copy of the License at
230 
231        http://www.apache.org/licenses/LICENSE-2.0
232 
233    Unless required by applicable law or agreed to in writing, software
234    distributed under the License is distributed on an "AS IS" BASIS,
235    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
236    See the License for the specific language governing permissions and
237    limitations under the License.
238    */
239 
240     bool _ds_mutex;
241     modifier mutex() {
242         assert(!_ds_mutex);
243         _ds_mutex = true;
244         _;
245         _ds_mutex = false;
246     }
247 	
248     function tryExec( address target, bytes calldata, uint256 value)
249 			mutex()
250             internal
251             returns (bool call_ret)
252     {
253 		/** @dev Requests new StatiCoins be made for a given address
254           * @param target where the ETH is sent to.
255           * @param calldata
256           * @param value
257           * @return True if ETH is transfered
258         */
259         return target.call.value(value)(calldata);
260     }
261 	
262     function exec( address target, bytes calldata, uint256 value)
263              internal
264     {
265         assert(tryExec(target, calldata, value));
266     }
267 }
268 
269 /** @title canFreeze. */
270 contract canFreeze is owned { 
271 	//Copyright (c) 2017 GenkiFS
272 	//Basically a "break glass in case of emergency"
273     bool public frozen=false;
274     modifier LockIfFrozen() {
275         if (!frozen){
276             _;
277         }
278     }
279     function Freeze() onlyOwner {
280         // fixes the price and allows everyone to redeem their coins at the current value
281 		// only becomes false when all ETH has been claimed or the pricer contract is changed
282         frozen=true;
283     }
284 }
285 
286 /** @title oneWrite. */
287 contract oneWrite {  
288 	//  Adds modifies that allow one function to be called only once
289 	//Copyright (c) 2017 GenkiFS
290   bool written = false;
291   function oneWrite() {
292 	/** @dev Constuctor, make sure written=false initally
293 	*/
294     written = false;
295   }
296   modifier LockIfUnwritten() {
297     if (written){
298         _;
299     }
300   }
301   modifier writeOnce() {
302     if (!written){
303         written=true;
304         _;
305     }
306   }
307 }
308 
309 /** @title pricerControl. */
310 contract pricerControl is canFreeze {
311 	//  Copyright (c) 2017 GenkiFS
312 	//  Controls the Pricer contract for minter.  Allows updates to be made in the future by swapping the pricer contract
313 	//  Although this is not expected, web addresses, API's, new oracles could require adjusments to the pricer contract
314 	//  A delay of 2 days is implemented to allow coinholders to redeem their coins if they do not agree with the new contract
315 	//  A new pricer contract unfreezes the minter (allowing a live price to be used)
316     I_Pricer public pricer;
317     address public future;
318     uint256 public releaseTime;
319     uint public PRICER_DELAY = 2; // days updated when coins are set
320     event EventAddressChange(address indexed _from, address indexed _to, uint _timeChange);
321 
322     function setPricer(address newAddress) onlyOwner {
323 		/** @dev Changes the Pricer contract, after a certain delay
324           * @param newAddress Allows coins to be created and sent to other people
325           * @return transaction ID which can be viewed in the pending mapping
326         */
327         releaseTime = now + PRICER_DELAY;
328         future = newAddress;
329         EventAddressChange(pricer, future, releaseTime);
330     }  
331 
332     modifier updates() {
333         if (now > releaseTime  && pricer != future){
334             update();
335             //log0('Updating');
336         }
337         _;
338     }
339 
340     modifier onlyPricer() {
341       if (msg.sender==address(pricer))
342       _;
343     }
344 
345     function update() internal {
346         pricer =  I_Pricer(future);
347 		frozen = false;
348     }
349 }
350 
351 /** @title minter. */	
352 contract minter is I_minter, DSBaseActor, oneWrite, pricerControl, DSMath{ //
353 	// Copyright (c) 2017 GenkiFS
354 	// This contract is the controller for the StatiCoin contracts.  
355 	// Users have 4(+2) functions they can call to mint/melt Static/Risk coins which then calls the Pricer contract
356 	// after a delay the Pricer contract will call back to the PriceReturn() function
357 	// this will then call one of the functions ActionNewStatic, ActionNewRisk, ActionRetStatic, ActionRetRisk
358 	// which will then call the Static or Risk ERC20 contracts to mint/melt new tokens
359 	// Transfer of tokens is handled by the ERC20 contracts, ETH is stored here.  
360     enum Action {NewStatic, RetStatic, NewRisk, RetRisk} // Enum of what users can do
361     struct Trans { // Struct
362         uint128 amount; // Amount sent by the user (Can be either ETH or number of returned coins)
363         address holder; // Address of the user
364         Action action;  // Type of action requested (mint/melt a Risk/StatiCoin)
365 		uint pricerID;  // ID for the pricer function
366     }
367     uint128 public lastPrice; //Storage of the last price returned by the Pricer contract
368     uint public TransID=0; // An increasing counter to keep track of transactions requested
369     string public Currency; // Name of underlying base currency
370     I_coin public Static;  // ERC20 token interface for the StatiCoin
371     I_coin public Risk;  // ERC20 token interface for the Risk coin
372     uint128 public Multiplier;//=15*10**(17); // default ratio for Risk price
373     uint128 public levToll=5*10**(18-1);//0.5  // this plus the multiplier defines the maximum leverage
374     uint128 public mintFee = 2*10**(18-3); //0.002 Used to pay oricalize and for marketing contract which is in both parties interest.
375     mapping (uint => Trans[]) public pending; // A mapping of pending transactions
376 
377     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
378     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
379     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
380     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
381     event EventBankrupt();	//Called when no more ETH is in the contract and everything needs to be manually reset.  
382 	
383 	function minter(string _currency, uint128 _Multiplier) { //,uint8 _DecimalPlaces
384         // CONSTRUCTOR  
385         Currency=_currency;
386         Multiplier = _Multiplier;
387         // can't add new contracts here as it gives out of gas messages.  Too much code.
388     }	
389 
390 	function () {
391         //if ETH is just sent to this address then we cannot determine if it's for StatiCoins or RiskCoins, so send it back.
392         revert();
393     }
394 
395 	function Bailout() 
396 			external 
397 			payable 
398 			{
399         /** @dev Allows extra ETH to be added to the benefit of both types of coin holders
400           * @return nothing
401         */
402     }
403 		
404     function NewStatic() 
405 			external 
406 			payable 
407 			returns (uint _TransID) {
408         /** @dev Requests new StatiCoins be made for the sender.  
409 		  * This cannot be called by a contract.  Only a simple wallet (with 0 codesize).
410 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
411           * @return transaction ID which can be viewed in the pending mapping
412         */
413 		_TransID=NewCoinInternal(msg.sender,cast(msg.value),Action.NewStatic);
414 		//log0('NewStatic');
415     }
416 	
417     function NewStaticAdr(address _user) 
418 			external 
419 			payable 
420 			returns (uint _TransID)  {  
421         /** @dev Requests new StatiCoins be made for a given address.  
422 		  * The address cannot be a contract, only a simple wallet (with 0 codesize).
423 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
424           * @param _user Allows coins to be created and sent to other people
425           * @return transaction ID which can be viewed in the pending mapping
426         */
427 		_TransID=NewCoinInternal(_user,cast(msg.value),Action.NewStatic);
428 		//log0('NewStatic');
429     }
430 	
431     function NewRisk() 
432 			external 
433 			payable 
434 			returns (uint _TransID)  {
435         /** @dev Requests new Riskcoins be made for the sender.  
436 		  * This cannot be called by a contract, only a simple wallet (with 0 codesize).
437 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
438           * @return transaction ID which can be viewed in the pending mapping
439           */
440 		_TransID=NewCoinInternal(msg.sender,cast(msg.value),Action.NewRisk);
441         //log0('NewRisk');
442     }
443 
444     function NewRiskAdr(address _user) 
445 			external 
446 			payable 
447 			returns (uint _TransID)  {
448         /** @dev Requests new Riskcoins be made for a given address.  
449 		  * The address cannot be a contract, only a simple wallet (with 0 codesize).
450 		  * Contracts must use the Approve, transferFrom pattern and move coins from wallets
451           * @param _user Allows coins to be created and sent to other people
452           * @return transaction ID which can be viewed in the pending mapping
453           */
454 		_TransID=NewCoinInternal(_user,cast(msg.value),Action.NewRisk);
455         //log0('NewRisk');
456     }
457 
458     function RetRisk(uint128 _Quantity) 
459 			external 
460 			payable 
461 			LockIfUnwritten  
462 			returns (uint _TransID)  {
463         /** @dev Returns Riskcoins.  Needs a bit of eth sent to pay the pricer contract and the excess is returned.  
464 		  * The address cannot be a contract, only a simple wallet (with 0 codesize).
465           * @param _Quantity Amount of coins being returned
466 		  * @return transaction ID which can be viewed in the pending mapping
467         */
468         if(frozen){
469             //Skip the pricer contract
470             TransID++;
471 			ActionRetRisk(Trans(_Quantity,msg.sender,Action.RetRisk,0),TransID,lastPrice);
472 			_TransID=TransID;
473         } else {
474             //Only returned when Risk price is positive
475 			_TransID=RetCoinInternal(_Quantity,cast(msg.value),msg.sender,Action.RetRisk);
476         }
477 		//log0('RetRisk');
478     }
479 
480     function RetStatic(uint128 _Quantity) 
481 			external 
482 			payable 
483 			LockIfUnwritten  
484 			returns (uint _TransID)  {
485         /** @dev Returns StatiCoins,  Needs a bit of eth sent to pay the pricer contract
486           * @param _Quantity Amount of coins being returned
487 		  * @return transaction ID which can be viewed in the pending mapping
488         */
489         if(frozen){
490             //Skip the pricer contract
491 			TransID++;
492             ActionRetStatic(Trans(_Quantity,msg.sender,Action.RetStatic,0),TransID,lastPrice);
493 			_TransID=TransID;
494         } else {
495             //Static can be returned at any time
496 			_TransID=RetCoinInternal(_Quantity,cast(msg.value),msg.sender,Action.RetStatic);
497         }
498 		//log0('RetStatic');
499     }
500 	
501 	//****************************//
502 	// Constant functions (Ones that don't write to the blockchain)
503     function StaticEthAvailable() 
504 			constant 
505 			returns (uint128)  {
506 		/** @dev Returns the total amount of eth that can be sent to buy StatiCoins
507 		  * @return amount of Eth
508         */
509 		return StaticEthAvailable(cast(Risk.totalSupply()), cast(this.balance));
510     }
511 
512 	function StaticEthAvailable(uint128 _RiskTotal, uint128 _TotalETH) 
513 			constant 
514 			returns (uint128)  {
515 		/** @dev Returns the total amount of eth that can be sent to buy StatiCoins allows users to test arbitrary amounts of RiskTotal and ETH contained in the contract
516 		  * @param _RiskTotal Quantity of 
517           * @param  _TotalETH Total value of ETH in the contract
518 		  * @return amount of Eth
519         */
520 		// (Multiplier+levToll)*_RiskTotal - _TotalETH
521 		uint128 temp = wmul(wadd(Multiplier,levToll),_RiskTotal);
522 		if(wless(_TotalETH,temp)){
523 			return wsub(temp ,_TotalETH);
524 		} else {
525 			return 0;
526 		}
527     }
528 
529 	function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) 
530 			constant 
531 			returns (uint128 price)  {
532 	    /** @dev Allows users to query various hypothetical prices of RiskCoins in terms of base currency
533           * @param _currentPrice Current price of ETH in Base currency.
534           * @param _StaticTotal Total quantity of StatiCoins issued.
535           * @param _RiskTotal Total quantity of invetor coins issued.
536           * @param _ETHTotal Total quantity of ETH in the contract.
537           * @return price of RiskCoins 
538         */
539         if(_ETHTotal == 0 || _RiskTotal==0){
540 			//Return the default price of _currentPrice * Multiplier
541             return wmul( _currentPrice , Multiplier); 
542         } else {
543             if(hmore( wmul(_ETHTotal , _currentPrice),_StaticTotal)){ //_ETHTotal*_currentPrice>_StaticTotal
544 				//Risk price is positive
545                 return wdiv(wsub(wmul(_ETHTotal , _currentPrice) , _StaticTotal) , _RiskTotal); // (_ETHTotal * _currentPrice) - _StaticTotal) / _RiskTotal
546             } else  {
547 				//RiskPrice is negative
548                 return 0;
549             }
550         }       
551     }
552 
553     function RiskPrice() 
554 			constant 
555 			returns (uint128 price)  {
556 	    /** @dev Allows users to query the last price of RiskCoins in terms of base currency
557         *   @return price of RiskCoins 
558         */
559         return RiskPrice(lastPrice);
560     }     	
561 	
562     function RiskPrice(uint128 _currentPrice) 
563 			constant 
564 			returns (uint128 price)  {
565 	    /** @dev Allows users to query price of RiskCoins in terms of base currency, using current quantities of coins
566           * @param _currentPrice Current price of ETH in Base currency.
567 	      * @return price of RiskCoins 
568         */
569         return RiskPrice(_currentPrice,cast(Static.totalSupply()),cast(Risk.totalSupply()),cast(this.balance));
570     }     
571 
572 	function Leverage() public 
573 			constant 
574 			returns (uint128)  {
575 		/** @dev Returns the ratio at which Riskcoin grows in value for the equivalent growth in ETH price
576 		* @return ratio
577         */
578         if(Risk.totalSupply()>0){
579             return wdiv(cast(this.balance) , cast(Risk.totalSupply())); //  this.balance/Risk.totalSupply
580         }else{
581             return 0;
582         }
583     }
584 
585     function Strike() public 
586 			constant 
587 			returns (uint128)  {
588 		/** @dev Returns the current price at which the Risk price goes negative
589 		* @return Risk price in underlying per ETH
590         */ 
591         if(this.balance>0){
592             return wdiv(cast(Static.totalSupply()) , cast(this.balance)); //Static.totalSupply / this.balance
593         }else{
594             return 0;            
595         }
596     }
597 
598 	//****************************//
599 	// Only owner can access the following functions
600     function setFee(uint128 _newFee) 
601 			onlyOwner {
602         /** @dev Allows the minting fee to be changed, only owner can modify
603 		  * Fee is only charged on coin creation
604           * @param _newFee Size of new fee
605           * return nothing 
606         */
607         mintFee=_newFee;
608     }
609 
610     function setCoins(address newRisk,address newStatic) 
611 			updates 
612 			onlyOwner 
613 			writeOnce {
614         /** @dev only owner can modify once, Triggers the pricer to be updated 
615           * @param newRisk Address of Riskcoin contract
616           * @param newStatic Address of StatiCoin contract
617           * return nothing 
618         */
619         Risk=I_coin(newRisk);
620         Static=I_coin(newStatic);
621 		PRICER_DELAY = 2 days;
622     }
623 	
624 	//****************************//	
625 	// Only Pricer can access the following function
626     function PriceReturn(uint _TransID,uint128 _Price) 
627 			onlyPricer {
628 	    /** @dev Return function for the Pricer contract only.  Controls melting and minting of new coins.
629           * @param _TransID Tranasction ID issued by the minter.
630           * @param _Price Quantity of Base currency per ETH delivered by the Pricer contract
631           * Nothing returned.  One of 4 functions is implemented
632         */
633 	    Trans memory details=pending[_TransID][0];//Get the details for this transaction. 
634         if(0==_Price||frozen){ //If there is an error in pricing or contract is frozen, use the old price
635             _Price=lastPrice;
636         } else {
637 			if(Static.totalSupply()>0 && Risk.totalSupply()>0) {// dont update if there are coins missing
638 				lastPrice=_Price; // otherwise update the last price
639 			}
640         }
641 		//Mint some new StatiCoins
642         if(Action.NewStatic==details.action){
643             ActionNewStatic(details,_TransID, _Price);
644         }
645 		//Melt some old StatiCoins
646         if(Action.RetStatic==details.action){
647             ActionRetStatic(details,_TransID, _Price);
648         }
649 		//Mint some new Riskcoins
650         if(Action.NewRisk==details.action){
651             ActionNewRisk(details,_TransID, _Price);
652         }
653 		//Melt some old Riskcoins
654         if(Action.RetRisk==details.action){
655             ActionRetRisk(details,_TransID, _Price);
656         }
657 		//Remove the transaction from the blockchain (saving some gas)
658 		delete pending[_TransID];
659     }
660 	
661 	//****************************//
662     // Only internal functions now
663     function ActionNewStatic(Trans _details, uint _TransID, uint128 _Price) 
664 			internal {
665 		/** @dev Internal function to create new StatiCoins based on transaction data in the Pending queue.  If not enough spare StatiCoins are available then some ETH is refunded.
666           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
667           * @param _TransID ID of the transaction (as stored in this contract).
668           * @param _Price Current 24 hour average price as returned by the oracle in the pricer contract.
669           * @return function returns nothing, but adds StatiCoins to the users address and events are created
670         */
671 		//log0('NewStatic');
672             
673             //if(Action.NewStatic<>_details.action){revert();}  //already checked
674 			
675 			uint128 CurRiskPrice=RiskPrice(_Price);
676 			uint128 AmountReturn;
677 			uint128 AmountMint;
678 			
679 			//Calculates the amount of ETH that can be added to create StatiCoins (excluding the amount already sent and stored in the contract)
680 			uint128 StaticAvail = StaticEthAvailable(cast(Risk.totalSupply()), wsub(cast(this.balance),_details.amount)); 
681 						
682 			// If the amount sent is less than the Static amount available, everything is fine.  Nothing needs to be returned.  
683 			if (wless(_details.amount,StaticAvail)) {
684 				// restrictions do not hamper the creation of a StatiCoin
685 				AmountMint = _details.amount;
686 				AmountReturn = 0;
687 			} else {
688 				// Amount of Static is less than amount requested.  
689 				// Take all the StatiCoins available.
690 				// Maybe there is zero Static available, so all will be returned.
691 				AmountMint = StaticAvail;
692 				AmountReturn = wsub(_details.amount , StaticAvail) ;
693 			}	
694 			
695 			if(0 == CurRiskPrice){
696 				// return all the ETH
697 				AmountReturn = _details.amount;
698 				//AmountMint = 0; //not required as Risk price = 0
699 			}
700 			
701 			//Static can be added when Risk price is positive and leverage is below the limit
702             if(CurRiskPrice > 0  && StaticAvail>0 ){
703                 // Dont create if CurRiskPrice is 0 or there is no Static available (leverage is too high)
704 				//log0('leverageOK');
705                 Static.mintCoin(_details.holder, uint256(wmul(AmountMint , _Price))); //request coins from the Static creator contract
706                 EventCreateStatic(_details.holder, wmul(AmountMint , _Price), _TransID, _Price); // Event giving the holder address, coins created, transaction id, and price 
707             } 
708 
709 			if (AmountReturn>0) {
710                 // return some money because not enough StatiCoins are available
711 				bytes memory calldata; // define a blank `bytes`
712                 exec(_details.holder,calldata, AmountReturn);  //Refund ETH from this contract
713 			}	
714     }
715 
716     function ActionNewRisk(Trans _details, uint _TransID,uint128 _Price) 
717 			internal {
718 		/** @dev Internal function to create new Risk coins based on transaction data in the Pending queue.  Risk coins can only be created if the price is above zero
719           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
720           * @param _TransID ID of the transaction (as stored in this contract).
721           * @param _Price Current 24 hour average price as returned by the oracle in the pricer contract.
722           * @return function returns nothing, but adds Riskcoins to the users address and events are created
723         */
724         //log0('NewRisk');
725         //if(Action.NewRisk<>_details.action){revert();}  //already checked
726 		// Get the Risk price using the amount of ETH in the contract before this transaction existed
727 		uint128 CurRiskPrice;
728 		if(wless(cast(this.balance),_details.amount)){
729 			CurRiskPrice=RiskPrice(_Price,cast(Static.totalSupply()),cast(Risk.totalSupply()),0);
730 		} else {
731 			CurRiskPrice=RiskPrice(_Price,cast(Static.totalSupply()),cast(Risk.totalSupply()),wsub(cast(this.balance),_details.amount));
732 		}
733         if(CurRiskPrice>0){
734             uint128 quantity=wdiv(wmul(_details.amount , _Price),CurRiskPrice);  // No of Riskcoins =  _details.amount * _Price / CurRiskPrice
735             Risk.mintCoin(_details.holder, uint256(quantity) );  //request coins from the Riskcoin creator contract
736             EventCreateRisk(_details.holder, quantity, _TransID, _Price); // Event giving the holder address, coins created, transaction id, and price 
737         } else {
738             // Don't create if CurRiskPrice is 0, Return all the ETH originally sent
739             bytes memory calldata; // define a blank `bytes`
740             exec(_details.holder,calldata, _details.amount);
741         }
742     }
743 
744     function ActionRetStatic(Trans _details, uint _TransID,uint128 _Price) 
745 			internal {
746 		/** @dev Internal function to Return StatiCoins based on transaction data in the Pending queue.  Static can be returned at any time.
747           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
748           * @param _TransID ID of the transaction (as stored in this contract).
749           * @param _Price Current 24 hour average price as returned by the oracle in the pricer contract.
750           * @return function returns nothing, but removes StatiCoins from the user's address, sends ETH and events are created
751         */
752 		//if(Action.RetStatic<>_details.action){revert();}  //already checked
753 		//log0('RetStatic');
754 		uint128 _ETHReturned;
755 		if(0==Risk.totalSupply()){_Price=lastPrice;} //No Risk coins for balance so use fixed price
756         _ETHReturned = wdiv(_details.amount , _Price); //_details.amount / _Price
757         if (Static.meltCoin(_details.holder,_details.amount)){
758             // deducted first, will add back if Returning ETH goes wrong.
759             EventRedeemStatic(_details.holder,_details.amount ,_TransID, _Price);
760             if (wless(cast(this.balance),_ETHReturned)) {
761                  _ETHReturned=cast(this.balance);//Not enough ETH available.  Return all Eth in the contract
762             }
763 			bytes memory calldata; // define a blank `bytes`
764             if (tryExec(_details.holder, calldata, _ETHReturned)) { 
765 				//ETH returned successfully
766 			} else {
767 				// there was an error, so add back the amount previously deducted
768 				Static.mintCoin(_details.holder,_details.amount); //Add back the amount requested
769 				EventCreateStatic(_details.holder,_details.amount ,_TransID, _Price);  //redo the creation event
770 			}
771 			if ( 0==this.balance) {
772 				Bankrupt();
773 			}
774         }        
775     }
776 
777     function ActionRetRisk(Trans _details, uint _TransID,uint128 _Price) 
778 			internal {
779 		/** @dev Internal function to Return Riskcoins based on transaction data in the Pending queue.  Riskcoins can be returned so long as the Risk price is greater than 0.
780           * @param _details Structure holding the amount sent (in ETH), the address of the person to sent to, and the type of request.
781           * @param _TransID ID of the transaction (as stored in this contract).
782           * @param _Price Current 24 hour average price as returned by the oracle in the Pricer contract.
783           * @return function returns nothing, but removes RiskCoins from the users address, sends ETH and events are created
784         */        
785 		//if(Action.RetRisk<>_details.action){revert();}  //already checked
786 		//log0('RetRisk');
787         uint128 _ETHReturned;
788 		uint128 CurRiskPrice;
789 		// no StatiCoins, so all Risk coins are worth the same, so _ETHReturned = _details.amount / _RiskTotal * _ETHTotal
790 		CurRiskPrice=RiskPrice(_Price);
791         if(CurRiskPrice>0){
792             _ETHReturned = wdiv( wmul(_details.amount , CurRiskPrice) , _Price); // _details.amount * CurRiskPrice / _Price
793             if (Risk.meltCoin(_details.holder,_details.amount )){
794                 // Coins are deducted first, will add back if returning ETH goes wrong.
795                 EventRedeemRisk(_details.holder,_details.amount ,_TransID, _Price);
796                 if ( wless(cast(this.balance),_ETHReturned)) { // should never happen, but just in case
797                      _ETHReturned=cast(this.balance);
798                 }
799 				bytes memory calldata; // define a blank `bytes`
800                 if (tryExec(_details.holder, calldata, _ETHReturned)) { 
801 					//Returning ETH went ok.  
802                 } else {
803                     // there was an error, so add back the amount previously deducted from the Riskcoin contract
804                     Risk.mintCoin(_details.holder,_details.amount);
805                     EventCreateRisk(_details.holder,_details.amount ,_TransID, _Price);
806                 }
807             } 
808         }  else {
809             // Risk price is zero so can't do anything.  Call back and delete the transaction from the contract
810         }
811     }
812 
813 	function IsWallet(address _address) 
814 			internal 
815 			returns(bool){
816 		/**
817 		* @dev checks that _address is not a contract.  
818 		* @param _address to check 
819 		* @return True if not a contract, 
820 		*/		
821 		uint codeLength;
822 		assembly {
823             // Retrieve the size of the code on target address, this needs assembly .
824             codeLength := extcodesize(_address)
825         }
826 		return(0==codeLength);		
827     } 
828 
829 	function RetCoinInternal(uint128 _Quantity, uint128 _AmountETH, address _user, Action _action) 
830 			internal 
831 			updates 
832 			returns (uint _TransID)  {
833         /** @dev Requests coins be melted and ETH returned
834 		  * @param _Quantity of Static or Risk coins to be melted
835 		  * @param _AmountETH Amount of ETH sent to this contract to cover oracle fee.  Excess is returned.
836           * @param _user Address to whom the returned ETH will be sent.
837 		  * @param _action Allows Static or Risk coins to be returned
838 		  * @return transaction ID which can be viewed in the Pending mapping
839         */
840 		require(IsWallet(_user));
841 		uint128 refund;
842         uint128 Fee=pricer.queryCost();  //Get the cost of querying the pricer contract
843 		if(wless(_AmountETH,Fee)){
844 			revert();  //log0('Not enough ETH to mint');
845 			} else {
846 			refund=wsub(_AmountETH,Fee);//Returning coins has had too much ETH sent, so return it.
847 		}
848 		if(0==_Quantity){revert();}// quantity has to be non zero
849 		TransID++;
850         
851         uint PricerID = pricer.requestPrice.value(uint256(Fee))(TransID);  //Ask the pricer to get the price.  The Fee also cover calling the function PriceReturn at a later time.
852 		pending[TransID].push(Trans(_Quantity,_user,_action,PricerID));  //Add a transaction to the Pending queue.
853         _TransID=TransID;  //return the transaction ID to the user 
854         _user.transfer(uint256(refund)); //Return ETH if too much has been sent to cover the pricer
855     }
856 		
857 	function NewCoinInternal(address _user, uint128 _amount, Action _action) 
858 			internal 
859 			updates 
860 			LockIfUnwritten 
861 			LockIfFrozen  
862 			returns (uint _TransID)  {
863 		/** @dev Requests new coins be made
864           * @param _user Address for whom the coins are to be created
865           * @param _amount Amount of eth sent to this contract
866 		  * @param _action Allows Static or Risk coins to be minted
867 		  * @return transaction ID which can be viewed in the pending mapping
868         */
869 		require(IsWallet(_user));
870         uint128 Fee=wmax(wmul(_amount,mintFee),pricer.queryCost()); // fee is the maxium of the pricer query cost and a mintFee% of value sent
871         if(wless(_amount,Fee)) revert(); //log0('Not enough ETH to mint');
872 		TransID++;
873         uint PricerID = pricer.requestPrice.value(uint256(Fee))(TransID); //Ask the pricer to return the price
874 		pending[TransID].push(Trans(wsub(_amount,Fee),_user,_action,PricerID)); //Store the transaction ID and data ready for later recall
875         _TransID=TransID;//return the transaction ID for this contract to the user 		
876 	} 
877 
878     function Bankrupt() 
879 			internal {
880 			EventBankrupt();
881 			// Reset the contract
882 			Static.kill();  //delete all current Static tokens
883 			Risk.kill();  //delete all current Risk tokens
884 			//need to create new coins externally, too much gas is used if done here.  
885 			frozen=false;
886 			written=false;  // Reset the writeOnce and LockIfUnwritten modifiers
887     }
888 }