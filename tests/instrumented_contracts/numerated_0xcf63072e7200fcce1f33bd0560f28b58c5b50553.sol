1 pragma solidity ^0.4.15;
2 
3 /**
4  * DealBox Crowdsale Contract
5  *
6  * This is the crowdsale contract for the DLBX Token. It utilizes Majoolr's
7  * CrowdsaleLib library to reduce custom source code surface area and increase
8  * overall security.Majoolr provides smart contract services and security reviews
9  * for contract deployments in addition to working on open source projects in the
10  * Ethereum community.
11  * For further information: dlbx.io, majoolr.io
12  *
13  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
14  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
15  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
16  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
17  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
18  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
19  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
20  */
21 
22 contract DLBXCrowdsale {
23   using DirectCrowdsaleLib for DirectCrowdsaleLib.DirectCrowdsaleStorage;
24 
25   DirectCrowdsaleLib.DirectCrowdsaleStorage sale;
26   uint256 public discountEndTime;
27 
28   function DLBXCrowdsale(
29                 address owner,
30                 uint256[] saleData,           // [1509937200, 65, 0]
31                 uint256 fallbackExchangeRate, // 28600
32                 uint256 capAmountInCents,     // 30000000000
33                 uint256 endTime,              // 1516417200
34                 uint8 percentBurn,            // 100
35                 uint256 _discountEndTime,     // 1513738800
36                 CrowdsaleToken token)         // 0xabe9ce5be54de2d588665b8a4f8c5489d8d51502
37   {
38   	sale.init(owner, saleData, fallbackExchangeRate, capAmountInCents, endTime, percentBurn, token);
39     discountEndTime = _discountEndTime;
40   }
41 
42   //Events
43   event LogTokensBought(address indexed buyer, uint256 amount);
44   event LogAddressCapExceeded(address indexed buyer, uint256 amount, string Msg);
45   event LogErrorMsg(uint256 amount, string Msg);
46   event LogTokenPriceChange(uint256 amount, string Msg);
47   event LogTokensWithdrawn(address indexed _bidder, uint256 Amount);
48   event LogWeiWithdrawn(address indexed _bidder, uint256 Amount);
49   event LogOwnerEthWithdrawn(address indexed owner, uint256 amount, string Msg);
50   event LogNoticeMsg(address _buyer, uint256 value, string Msg);
51 
52   // fallback function can be used to buy tokens
53   function () payable {
54     sendPurchase();
55   }
56 
57   function sendPurchase() payable returns (bool) {
58     if (now > discountEndTime){
59       if(msg.value < 16666666666666666666){
60         sale.base.tokensPerEth = 400;
61       } else {
62         sale.base.tokensPerEth = 600;
63       }
64     } else {
65       if(msg.value < 14333333333333333333){
66         sale.base.tokensPerEth = 462;
67       } else {
68         sale.base.tokensPerEth = 698;
69       }
70     }
71   	return sale.receivePurchase(msg.value);
72   }
73 
74   function withdrawTokens() returns (bool) {
75   	return sale.withdrawTokens();
76   }
77 
78   function withdrawLeftoverWei() returns (bool) {
79     return sale.withdrawLeftoverWei();
80   }
81 
82   function withdrawOwnerEth() returns (bool) {
83     return sale.withdrawOwnerEth();
84   }
85 
86   function crowdsaleActive() constant returns (bool) {
87     return sale.crowdsaleActive();
88   }
89 
90   function crowdsaleEnded() constant returns (bool) {
91     return sale.crowdsaleEnded();
92   }
93 
94   function setTokenExchangeRate(uint256 _exchangeRate) returns (bool) {
95     return sale.setTokenExchangeRate(_exchangeRate);
96   }
97 
98   function setTokens() returns (bool) {
99     return sale.setTokens();
100   }
101 
102   function getOwner() constant returns (address) {
103     return sale.base.owner;
104   }
105 
106   function getTokensPerEth() constant returns (uint256) {
107     if (now > discountEndTime){
108       return 400;
109     } else {
110       return 461;
111     }
112   }
113 
114   function getExchangeRate() constant returns (uint256) {
115     return sale.base.exchangeRate;
116   }
117 
118   function getCapAmount() constant returns (uint256) {
119       return sale.base.capAmount;
120   }
121 
122   function getStartTime() constant returns (uint256) {
123     return sale.base.startTime;
124   }
125 
126   function getEndTime() constant returns (uint256) {
127     return sale.base.endTime;
128   }
129 
130   function getEthRaised() constant returns (uint256) {
131     return sale.base.ownerBalance;
132   }
133 
134   function getContribution(address _buyer) constant returns (uint256) {
135   	return sale.base.hasContributed[_buyer];
136   }
137 
138   function getTokenPurchase(address _buyer) constant returns (uint256) {
139   	return sale.base.withdrawTokensMap[_buyer];
140   }
141 
142   function getLeftoverWei(address _buyer) constant returns (uint256) {
143     return sale.base.leftoverWei[_buyer];
144   }
145 
146   function getSaleData() constant returns (uint256) {
147     if (now > discountEndTime){
148       return 75;
149     } else {
150       return 65;
151     }
152   }
153 
154   function getTokensSold() constant returns (uint256) {
155     return sale.base.startingTokenBalance - sale.base.withdrawTokensMap[sale.base.owner];
156   }
157 
158   function getPercentBurn() constant returns (uint256) {
159     return sale.base.percentBurn;
160   }
161 }
162 
163 library DirectCrowdsaleLib {
164   using BasicMathLib for uint256;
165   using CrowdsaleLib for CrowdsaleLib.CrowdsaleStorage;
166 
167   struct DirectCrowdsaleStorage {
168 
169   	CrowdsaleLib.CrowdsaleStorage base; // base storage from CrowdsaleLib
170 
171   }
172 
173   event LogTokensBought(address indexed buyer, uint256 amount);
174   event LogAddressCapExceeded(address indexed buyer, uint256 amount, string Msg);
175   event LogErrorMsg(uint256 amount, string Msg);
176   event LogTokenPriceChange(uint256 amount, string Msg);
177 
178 
179   /// @dev Called by a crowdsale contract upon creation.
180   /// @param self Stored crowdsale from crowdsale contract
181   /// @param _owner Address of crowdsale owner
182   /// @param _saleData Array of 3 item sets such that, in each 3 element
183   /// set, 1 is timestamp, 2 is price in cents at that time,
184   /// 3 is address purchase cap at that time, 0 if no address cap
185   /// @param _fallbackExchangeRate Exchange rate of cents/ETH
186   /// @param _capAmountInCents Total to be raised in cents
187   /// @param _endTime Timestamp of sale end time
188   /// @param _percentBurn Percentage of extra tokens to burn
189   /// @param _token Token being sold
190   function init(DirectCrowdsaleStorage storage self,
191                 address _owner,
192                 uint256[] _saleData,
193                 uint256 _fallbackExchangeRate,
194                 uint256 _capAmountInCents,
195                 uint256 _endTime,
196                 uint8 _percentBurn,
197                 CrowdsaleToken _token)
198   {
199   	self.base.init(_owner,
200                 _saleData,
201                 _fallbackExchangeRate,
202                 _capAmountInCents,
203                 _endTime,
204                 _percentBurn,
205                 _token);
206   }
207 
208   /// @dev Called when an address wants to purchase tokens
209   /// @param self Stored crowdsale from crowdsale contract
210   /// @param _amount amount of wei that the buyer is sending
211   /// @return true on succesful purchase
212   function receivePurchase(DirectCrowdsaleStorage storage self, uint256 _amount) returns (bool) {
213     require(msg.sender != self.base.owner);
214   	require(self.base.validPurchase());
215 
216     require((self.base.ownerBalance + _amount) <= self.base.capAmount);
217 
218   	// if the token price increase interval has passed, update the current day and change the token price
219   	if ((self.base.milestoneTimes.length > self.base.currentMilestone + 1) &&
220         (now > self.base.milestoneTimes[self.base.currentMilestone + 1]))
221     {
222         while((self.base.milestoneTimes.length > self.base.currentMilestone + 1) &&
223               (now > self.base.milestoneTimes[self.base.currentMilestone + 1]))
224         {
225           self.base.currentMilestone += 1;
226         }
227 
228         self.base.changeTokenPrice(self.base.saleData[self.base.milestoneTimes[self.base.currentMilestone]][0]);
229         LogTokenPriceChange(self.base.tokensPerEth,"Token Price has changed!");
230     }
231 
232   	uint256 _numTokens; //number of tokens that will be purchased
233     uint256 _newBalance; //the new balance of the owner of the crowdsale
234     uint256 _weiTokens; //temp calc holder
235     uint256 _zeros; //for calculating token
236     uint256 _leftoverWei; //wei change for purchaser
237     uint256 _remainder; //temp calc holder
238     bool err;
239 
240     // Find the number of tokens as a function in wei
241     (err,_weiTokens) = _amount.times(self.base.tokensPerEth);
242     require(!err);
243 
244     if(self.base.tokenDecimals <= 18){
245       _zeros = 10**(18-uint256(self.base.tokenDecimals));
246       _numTokens = _weiTokens/_zeros;
247       _leftoverWei = _weiTokens % _zeros;
248       self.base.leftoverWei[msg.sender] += _leftoverWei;
249     } else {
250       _zeros = 10**(uint256(self.base.tokenDecimals)-18);
251       _numTokens = _weiTokens*_zeros;
252     }
253 
254     // can't overflow because it is under the cap
255     self.base.hasContributed[msg.sender] += _amount - _leftoverWei;
256 
257     require(_numTokens <= self.base.token.balanceOf(this));
258 
259     // calculate the amount of ether in the owners balance
260     (err,_newBalance) = self.base.ownerBalance.plus(_amount-_leftoverWei);
261     require(!err);
262 
263     self.base.ownerBalance = _newBalance;   // "deposit" the amount
264 
265     // can't overflow because it will be under the cap
266 	  self.base.withdrawTokensMap[msg.sender] += _numTokens;
267 
268     //subtract tokens from owner's share
269     (err,_remainder) = self.base.withdrawTokensMap[self.base.owner].minus(_numTokens);
270     self.base.withdrawTokensMap[self.base.owner] = _remainder;
271 
272 	  LogTokensBought(msg.sender, _numTokens);
273 
274     return true;
275   }
276 
277   /*Functions "inherited" from CrowdsaleLib library*/
278 
279   function setTokenExchangeRate(DirectCrowdsaleStorage storage self, uint256 _exchangeRate) returns (bool) {
280     return self.base.setTokenExchangeRate(_exchangeRate);
281   }
282 
283   function setTokens(DirectCrowdsaleStorage storage self) returns (bool) {
284     return self.base.setTokens();
285   }
286 
287   function getSaleData(DirectCrowdsaleStorage storage self, uint256 timestamp) returns (uint256[3]) {
288     return self.base.getSaleData(timestamp);
289   }
290 
291   function getTokensSold(DirectCrowdsaleStorage storage self) constant returns (uint256) {
292     return self.base.getTokensSold();
293   }
294 
295   function withdrawTokens(DirectCrowdsaleStorage storage self) returns (bool) {
296     return self.base.withdrawTokens();
297   }
298 
299   function withdrawLeftoverWei(DirectCrowdsaleStorage storage self) returns (bool) {
300     return self.base.withdrawLeftoverWei();
301   }
302 
303   function withdrawOwnerEth(DirectCrowdsaleStorage storage self) returns (bool) {
304     return self.base.withdrawOwnerEth();
305   }
306 
307   function crowdsaleActive(DirectCrowdsaleStorage storage self) constant returns (bool) {
308     return self.base.crowdsaleActive();
309   }
310 
311   function crowdsaleEnded(DirectCrowdsaleStorage storage self) constant returns (bool) {
312     return self.base.crowdsaleEnded();
313   }
314 
315   function validPurchase(DirectCrowdsaleStorage storage self) constant returns (bool) {
316     return self.base.validPurchase();
317   }
318 }
319 
320 library TokenLib {
321   using BasicMathLib for uint256;
322 
323   struct TokenStorage {
324     mapping (address => uint256) balances;
325     mapping (address => mapping (address => uint256)) allowed;
326 
327     string name;
328     string symbol;
329     uint256 totalSupply;
330     uint256 INITIAL_SUPPLY;
331     address owner;
332     uint8 decimals;
333     bool stillMinting;
334   }
335 
336   event Transfer(address indexed from, address indexed to, uint256 value);
337   event Approval(address indexed owner, address indexed spender, uint256 value);
338   event OwnerChange(address from, address to);
339   event Burn(address indexed burner, uint256 value);
340   event MintingClosed(bool mintingClosed);
341 
342   /// @dev Called by the Standard Token upon creation.
343   /// @param self Stored token from token contract
344   /// @param _name Name of the new token
345   /// @param _symbol Symbol of the new token
346   /// @param _decimals Decimal places for the token represented
347   /// @param _initial_supply The initial token supply
348   /// @param _allowMinting True if additional tokens can be created, false otherwise
349   function init(TokenStorage storage self,
350                 address _owner,
351                 string _name,
352                 string _symbol,
353                 uint8 _decimals,
354                 uint256 _initial_supply,
355                 bool _allowMinting)
356   {
357     require(self.INITIAL_SUPPLY == 0);
358     self.name = _name;
359     self.symbol = _symbol;
360     self.totalSupply = _initial_supply;
361     self.INITIAL_SUPPLY = _initial_supply;
362     self.decimals = _decimals;
363     self.owner = _owner;
364     self.stillMinting = _allowMinting;
365     self.balances[_owner] = _initial_supply;
366   }
367 
368   /// @dev Transfer tokens from caller's account to another account.
369   /// @param self Stored token from token contract
370   /// @param _to Address to send tokens
371   /// @param _value Number of tokens to send
372   /// @return True if completed
373   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool) {
374     bool err;
375     uint256 balance;
376 
377     (err,balance) = self.balances[msg.sender].minus(_value);
378     require(!err);
379     self.balances[msg.sender] = balance;
380     //It's not possible to overflow token supply
381     self.balances[_to] = self.balances[_to] + _value;
382     Transfer(msg.sender, _to, _value);
383     return true;
384   }
385 
386   /// @dev Authorized caller transfers tokens from one account to another
387   /// @param self Stored token from token contract
388   /// @param _from Address to send tokens from
389   /// @param _to Address to send tokens to
390   /// @param _value Number of tokens to send
391   /// @return True if completed
392   function transferFrom(TokenStorage storage self,
393                         address _from,
394                         address _to,
395                         uint256 _value)
396                         returns (bool)
397   {
398     var _allowance = self.allowed[_from][msg.sender];
399     bool err;
400     uint256 balanceOwner;
401     uint256 balanceSpender;
402 
403     (err,balanceOwner) = self.balances[_from].minus(_value);
404     require(!err);
405 
406     (err,balanceSpender) = _allowance.minus(_value);
407     require(!err);
408 
409     self.balances[_from] = balanceOwner;
410     self.allowed[_from][msg.sender] = balanceSpender;
411     self.balances[_to] = self.balances[_to] + _value;
412 
413     Transfer(_from, _to, _value);
414     return true;
415   }
416 
417   /// @dev Retrieve token balance for an account
418   /// @param self Stored token from token contract
419   /// @param _owner Address to retrieve balance of
420   /// @return balance The number of tokens in the subject account
421   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
422     return self.balances[_owner];
423   }
424 
425   /// @dev Authorize an account to send tokens on caller's behalf
426   /// @param self Stored token from token contract
427   /// @param _spender Address to authorize
428   /// @param _value Number of tokens authorized account may send
429   /// @return True if completed
430   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool) {
431     self.allowed[msg.sender][_spender] = _value;
432     Approval(msg.sender, _spender, _value);
433     return true;
434   }
435 
436   /// @dev Remaining tokens third party spender has to send
437   /// @param self Stored token from token contract
438   /// @param _owner Address of token holder
439   /// @param _spender Address of authorized spender
440   /// @return remaining Number of tokens spender has left in owner's account
441   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
442     return self.allowed[_owner][_spender];
443   }
444 
445   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
446   /// @param self Stored token from token contract
447   /// @param _spender Address to authorize
448   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
449   /// @param _increase True if increasing allowance, false if decreasing allowance
450   /// @return True if completed
451   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
452                           returns (bool)
453   {
454     uint256 _newAllowed;
455     bool err;
456 
457     if(_increase) {
458       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
459       require(!err);
460 
461       self.allowed[msg.sender][_spender] = _newAllowed;
462     } else {
463       if (_valueChange > self.allowed[msg.sender][_spender]) {
464         self.allowed[msg.sender][_spender] = 0;
465       } else {
466         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
467         self.allowed[msg.sender][_spender] = _newAllowed;
468       }
469     }
470 
471     Approval(msg.sender, _spender, _newAllowed);
472     return true;
473   }
474 
475   /// @dev Change owning address of the token contract, specifically for minting
476   /// @param self Stored token from token contract
477   /// @param _newOwner Address for the new owner
478   /// @return True if completed
479   function changeOwner(TokenStorage storage self, address _newOwner) returns (bool) {
480     require((self.owner == msg.sender) && (_newOwner > 0));
481 
482     self.owner = _newOwner;
483     OwnerChange(msg.sender, _newOwner);
484     return true;
485   }
486 
487   /// @dev Mints additional tokens, new tokens go to owner
488   /// @param self Stored token from token contract
489   /// @param _amount Number of tokens to mint
490   /// @return True if completed
491   function mintToken(TokenStorage storage self, uint256 _amount) returns (bool) {
492     require((self.owner == msg.sender) && self.stillMinting);
493     uint256 _newAmount;
494     bool err;
495 
496     (err, _newAmount) = self.totalSupply.plus(_amount);
497     require(!err);
498 
499     self.totalSupply =  _newAmount;
500     self.balances[self.owner] = self.balances[self.owner] + _amount;
501     Transfer(0x0, self.owner, _amount);
502     return true;
503   }
504 
505   /// @dev Permanent stops minting
506   /// @param self Stored token from token contract
507   /// @return True if completed
508   function closeMint(TokenStorage storage self) returns (bool) {
509     require(self.owner == msg.sender);
510 
511     self.stillMinting = false;
512     MintingClosed(true);
513     return true;
514   }
515 
516   /// @dev Permanently burn tokens
517   /// @param self Stored token from token contract
518   /// @param _amount Amount of tokens to burn
519   /// @return True if completed
520   function burnToken(TokenStorage storage self, uint256 _amount) returns (bool) {
521       uint256 _newBalance;
522       bool err;
523 
524       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
525       require(!err);
526 
527       self.balances[msg.sender] = _newBalance;
528       self.totalSupply = self.totalSupply - _amount;
529       Burn(msg.sender, _amount);
530       Transfer(msg.sender, 0x0, _amount);
531       return true;
532   }
533 }
534 
535 library BasicMathLib {
536   event Err(string typeErr);
537 
538   /// @dev Multiplies two numbers and checks for overflow before returning.
539   /// Does not throw but rather logs an Err event if there is overflow.
540   /// @param a First number
541   /// @param b Second number
542   /// @return err False normally, or true if there is overflow
543   /// @return res The product of a and b, or 0 if there is overflow
544   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
545     assembly{
546       res := mul(a,b)
547       switch or(iszero(b), eq(div(res,b), a))
548       case 0 {
549         err := 1
550         res := 0
551       }
552     }
553     if (err)
554       Err("times func overflow");
555   }
556 
557   /// @dev Divides two numbers but checks for 0 in the divisor first.
558   /// Does not throw but rather logs an Err event if 0 is in the divisor.
559   /// @param a First number
560   /// @param b Second number
561   /// @return err False normally, or true if `b` is 0
562   /// @return res The quotient of a and b, or 0 if `b` is 0
563   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
564     assembly{
565       switch iszero(b)
566       case 0 {
567         res := div(a,b)
568         mstore(add(mload(0x40),0x20),res)
569         return(mload(0x40),0x40)
570       }
571     }
572     Err("tried to divide by zero");
573     return (true, 0);
574   }
575 
576   /// @dev Adds two numbers and checks for overflow before returning.
577   /// Does not throw but rather logs an Err event if there is overflow.
578   /// @param a First number
579   /// @param b Second number
580   /// @return err False normally, or true if there is overflow
581   /// @return res The sum of a and b, or 0 if there is overflow
582   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
583     assembly{
584       res := add(a,b)
585       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
586       case 0 {
587         err := 1
588         res := 0
589       }
590     }
591     if (err)
592       Err("plus func overflow");
593   }
594 
595   /// @dev Subtracts two numbers and checks for underflow before returning.
596   /// Does not throw but rather logs an Err event if there is underflow.
597   /// @param a First number
598   /// @param b Second number
599   /// @return err False normally, or true if there is underflow
600   /// @return res The difference between a and b, or 0 if there is underflow
601   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
602     assembly{
603       res := sub(a,b)
604       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
605       case 0 {
606         err := 1
607         res := 0
608       }
609     }
610     if (err)
611       Err("minus func underflow");
612   }
613 }
614 
615 contract CrowdsaleToken {
616   using TokenLib for TokenLib.TokenStorage;
617 
618   TokenLib.TokenStorage public token;
619 
620   function CrowdsaleToken(address owner,
621                                 string name,
622                                 string symbol,
623                                 uint8 decimals,
624                                 uint256 initialSupply,
625                                 bool allowMinting)
626   {
627     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
628   }
629 
630   function name() constant returns (string) {
631     return token.name;
632   }
633 
634   function symbol() constant returns (string) {
635     return token.symbol;
636   }
637 
638   function decimals() constant returns (uint8) {
639     return token.decimals;
640   }
641 
642   function totalSupply() constant returns (uint256) {
643     return token.totalSupply;
644   }
645 
646   function initialSupply() constant returns (uint256) {
647     return token.INITIAL_SUPPLY;
648   }
649 
650   function balanceOf(address who) constant returns (uint256) {
651     return token.balanceOf(who);
652   }
653 
654   function allowance(address owner, address spender) constant returns (uint256) {
655     return token.allowance(owner, spender);
656   }
657 
658   function transfer(address to, uint value) returns (bool ok) {
659     return token.transfer(to, value);
660   }
661 
662   function transferFrom(address from, address to, uint value) returns (bool ok) {
663     return token.transferFrom(from, to, value);
664   }
665 
666   function approve(address spender, uint value) returns (bool ok) {
667     return token.approve(spender, value);
668   }
669 
670   function changeOwner(address newOwner) returns (bool ok) {
671     return token.changeOwner(newOwner);
672   }
673 
674   function burnToken(uint256 amount) returns (bool ok) {
675     return token.burnToken(amount);
676   }
677 }
678 
679 library CrowdsaleLib {
680   using BasicMathLib for uint256;
681 
682   struct CrowdsaleStorage {
683   	address owner;     //owner of the crowdsale
684 
685   	uint256 tokensPerEth;  //number of tokens received per ether
686   	uint256 capAmount; //Maximum amount to be raised in wei
687   	uint256 startTime; //ICO start time, timestamp
688   	uint256 endTime; //ICO end time, timestamp automatically calculated
689     uint256 exchangeRate; //cents/ETH exchange rate at the time of the sale
690     uint256 ownerBalance; //owner wei Balance
691     uint256 startingTokenBalance; //initial amount of tokens for sale
692     uint256[] milestoneTimes; //Array of timestamps when token price and address cap changes
693     uint8 currentMilestone; //Pointer to the current milestone
694     uint8 tokenDecimals; //stored token decimals for calculation later
695     uint8 percentBurn; //percentage of extra tokens to burn
696     bool tokensSet; //true if tokens have been prepared for crowdsale
697     bool rateSet; //true if exchange rate has been set
698 
699     //Maps timestamp to token price and address purchase cap starting at that time
700     mapping (uint256 => uint256[2]) saleData;
701 
702     //shows how much wei an address has contributed
703   	mapping (address => uint256) hasContributed;
704 
705     //For token withdraw function, maps a user address to the amount of tokens they can withdraw
706   	mapping (address => uint256) withdrawTokensMap;
707 
708     // any leftover wei that buyers contributed that didn't add up to a whole token amount
709     mapping (address => uint256) leftoverWei;
710 
711   	CrowdsaleToken token; //token being sold
712   }
713 
714   // Indicates when an address has withdrawn their supply of tokens
715   event LogTokensWithdrawn(address indexed _bidder, uint256 Amount);
716 
717   // Indicates when an address has withdrawn their supply of extra wei
718   event LogWeiWithdrawn(address indexed _bidder, uint256 Amount);
719 
720   // Logs when owner has pulled eth
721   event LogOwnerEthWithdrawn(address indexed owner, uint256 amount, string Msg);
722 
723   // Generic Notice message that includes and address and number
724   event LogNoticeMsg(address _buyer, uint256 value, string Msg);
725 
726   // Indicates when an error has occurred in the execution of a function
727   event LogErrorMsg(string Msg);
728 
729   /// @dev Called by a crowdsale contract upon creation.
730   /// @param self Stored crowdsale from crowdsale contract
731   /// @param _owner Address of crowdsale owner
732   /// @param _saleData Array of 3 item sets such that, in each 3 element
733   /// set, 1 is timestamp, 2 is price in cents at that time,
734   /// 3 is address token purchase cap at that time, 0 if no address cap
735   /// @param _fallbackExchangeRate Exchange rate of cents/ETH
736   /// @param _capAmountInCents Total to be raised in cents
737   /// @param _endTime Timestamp of sale end time
738   /// @param _percentBurn Percentage of extra tokens to burn
739   /// @param _token Token being sold
740   function init(CrowdsaleStorage storage self,
741                 address _owner,
742                 uint256[] _saleData,
743                 uint256 _fallbackExchangeRate,
744                 uint256 _capAmountInCents,
745                 uint256 _endTime,
746                 uint8 _percentBurn,
747                 CrowdsaleToken _token)
748   {
749   	require(self.capAmount == 0);
750   	require(self.owner == 0);
751     require(_saleData.length > 0);
752     require((_saleData.length%3) == 0); // ensure saleData is 3-item sets
753     require(_endTime > _saleData[0]);
754     require(_capAmountInCents > 0);
755     require(_owner > 0);
756     require(_fallbackExchangeRate > 0);
757     require(_percentBurn <= 100);
758     self.owner = _owner;
759     self.capAmount = ((_capAmountInCents/_fallbackExchangeRate) + 1)*(10**18);
760     self.startTime = _saleData[0];
761     self.endTime = _endTime;
762     self.token = _token;
763     self.tokenDecimals = _token.decimals();
764     self.percentBurn = _percentBurn;
765     self.exchangeRate = _fallbackExchangeRate;
766 
767     uint256 _tempTime;
768     for(uint256 i = 0; i < _saleData.length; i += 3){
769       require(_saleData[i] > _tempTime);
770       require(_saleData[i + 1] > 0);
771       require((_saleData[i + 2] == 0) || (_saleData[i + 2] >= 100));
772       self.milestoneTimes.push(_saleData[i]);
773       self.saleData[_saleData[i]][0] = _saleData[i + 1];
774       self.saleData[_saleData[i]][1] = _saleData[i + 2];
775       _tempTime = _saleData[i];
776     }
777     changeTokenPrice(self, _saleData[1]);
778   }
779 
780   /// @dev function to check if the crowdsale is currently active
781   /// @param self Stored crowdsale from crowdsale contract
782   /// @return success
783   function crowdsaleActive(CrowdsaleStorage storage self) constant returns (bool) {
784   	return (now >= self.startTime && now <= self.endTime);
785   }
786 
787   /// @dev function to check if the crowdsale has ended
788   /// @param self Stored crowdsale from crowdsale contract
789   /// @return success
790   function crowdsaleEnded(CrowdsaleStorage storage self) constant returns (bool) {
791   	return now > self.endTime;
792   }
793 
794   /// @dev function to check if a purchase is valid
795   /// @param self Stored crowdsale from crowdsale contract
796   /// @return true if the transaction can buy tokens
797   function validPurchase(CrowdsaleStorage storage self) internal constant returns (bool) {
798     bool nonZeroPurchase = msg.value != 0;
799     if (crowdsaleActive(self) && nonZeroPurchase) {
800       return true;
801     } else {
802       LogErrorMsg("Invalid Purchase! Check send time and amount of ether.");
803       return false;
804     }
805   }
806 
807   /// @dev Function called by purchasers to pull tokens
808   /// @param self Stored crowdsale from crowdsale contract
809   /// @return true if tokens were withdrawn
810   function withdrawTokens(CrowdsaleStorage storage self) returns (bool) {
811     bool ok;
812 
813     if (self.withdrawTokensMap[msg.sender] == 0) {
814       LogErrorMsg("Sender has no tokens to withdraw!");
815       return false;
816     }
817 
818     if (msg.sender == self.owner) {
819       if(!crowdsaleEnded(self)){
820         LogErrorMsg("Owner cannot withdraw extra tokens until after the sale!");
821         return false;
822       } else {
823         if(self.percentBurn > 0){
824           uint256 _burnAmount = (self.withdrawTokensMap[msg.sender] * self.percentBurn)/100;
825           self.withdrawTokensMap[msg.sender] = self.withdrawTokensMap[msg.sender] - _burnAmount;
826           ok = self.token.burnToken(_burnAmount);
827           require(ok);
828         }
829       }
830     }
831 
832     var total = self.withdrawTokensMap[msg.sender];
833     self.withdrawTokensMap[msg.sender] = 0;
834     ok = self.token.transfer(msg.sender, total);
835     require(ok);
836     LogTokensWithdrawn(msg.sender, total);
837     return true;
838   }
839 
840   /// @dev Function called by purchasers to pull leftover wei from their purchases
841   /// @param self Stored crowdsale from crowdsale contract
842   /// @return true if wei was withdrawn
843   function withdrawLeftoverWei(CrowdsaleStorage storage self) returns (bool) {
844     require(self.hasContributed[msg.sender] > 0);
845     if (self.leftoverWei[msg.sender] == 0) {
846       LogErrorMsg("Sender has no extra wei to withdraw!");
847       return false;
848     }
849 
850     var total = self.leftoverWei[msg.sender];
851     self.leftoverWei[msg.sender] = 0;
852     msg.sender.transfer(total);
853     LogWeiWithdrawn(msg.sender, total);
854     return true;
855   }
856 
857   /// @dev send ether from the completed crowdsale to the owners wallet address
858   /// @param self Stored crowdsale from crowdsale contract
859   /// @return true if owner withdrew eth
860   function withdrawOwnerEth(CrowdsaleStorage storage self) returns (bool) {
861     if ((!crowdsaleEnded(self)) && (self.token.balanceOf(this)>0)) {
862       LogErrorMsg("Cannot withdraw owner ether until after the sale!");
863       return false;
864     }
865 
866     require(msg.sender == self.owner);
867     require(self.ownerBalance > 0);
868 
869     uint256 amount = self.ownerBalance;
870     self.ownerBalance = 0;
871     self.owner.transfer(amount);
872     LogOwnerEthWithdrawn(msg.sender,amount,"Crowdsale owner has withdrawn all funds!");
873 
874     return true;
875   }
876 
877   /// @dev Function to change the price of the token
878   /// @param self Stored crowdsale from crowdsale contract
879   /// @param _newPrice new token price (amount of tokens per ether)
880   /// @return true if the token price changed successfully
881   function changeTokenPrice(CrowdsaleStorage storage self,uint256 _newPrice) internal returns (bool) {
882   	require(_newPrice > 0);
883 
884     uint256 result;
885     uint256 remainder;
886 
887     result = self.exchangeRate / _newPrice;
888     remainder = self.exchangeRate % _newPrice;
889     if(remainder > 0) {
890       self.tokensPerEth = result + 1;
891     } else {
892       self.tokensPerEth = result;
893     }
894     return true;
895   }
896 
897   /// @dev function that is called three days before the sale to set the token and price
898   /// @param self Stored Crowdsale from crowdsale contract
899   /// @param _exchangeRate  ETH exchange rate expressed in cents/ETH
900   /// @return true if the exchange rate has been set
901   function setTokenExchangeRate(CrowdsaleStorage storage self, uint256 _exchangeRate) returns (bool) {
902     require(msg.sender == self.owner);
903     require((now > (self.startTime - 3 days)) && (now < (self.startTime)));
904     require(!self.rateSet);   // the exchange rate can only be set once!
905     require(self.token.balanceOf(this) > 0);
906     require(_exchangeRate > 0);
907 
908     uint256 _capAmountInCents;
909     uint256 _tokenBalance;
910     bool err;
911 
912     (err, _capAmountInCents) = self.exchangeRate.times(self.capAmount);
913     require(!err);
914 
915     _tokenBalance = self.token.balanceOf(this);
916     self.withdrawTokensMap[msg.sender] = _tokenBalance;
917     self.startingTokenBalance = _tokenBalance;
918     self.tokensSet = true;
919 
920     self.exchangeRate = _exchangeRate;
921     self.capAmount = (_capAmountInCents/_exchangeRate) + 1;
922     changeTokenPrice(self,self.saleData[self.milestoneTimes[0]][0]);
923     self.rateSet = true;
924 
925     LogNoticeMsg(msg.sender,self.tokensPerEth,"Owner has sent the exchange Rate and tokens bought per ETH!");
926     return true;
927   }
928 
929   /// @dev fallback function to set tokens if the exchange rate function was not called
930   /// @param self Stored Crowdsale from crowdsale contract
931   /// @return true if tokens set successfully
932   function setTokens(CrowdsaleStorage storage self) returns (bool) {
933     require(msg.sender == self.owner);
934     require(!self.tokensSet);
935 
936     uint256 _tokenBalance;
937 
938     _tokenBalance = self.token.balanceOf(this);
939     self.withdrawTokensMap[msg.sender] = _tokenBalance;
940     self.startingTokenBalance = _tokenBalance;
941     self.tokensSet = true;
942 
943     return true;
944   }
945 
946   /// @dev Gets the price and buy cap for individual addresses at the given milestone index
947   /// @param self Stored Crowdsale from crowdsale contract
948   /// @param timestamp Time during sale for which data is requested
949   /// @return A 3-element array with 0 the timestamp, 1 the price in cents, 2 the address cap
950   function getSaleData(CrowdsaleStorage storage self, uint256 timestamp) constant returns (uint256[3]) {
951     uint256[3] memory _thisData;
952     uint256 index;
953 
954     while((index < self.milestoneTimes.length) && (self.milestoneTimes[index] < timestamp)) {
955       index++;
956     }
957     if(index == 0)
958       index++;
959 
960     _thisData[0] = self.milestoneTimes[index - 1];
961     _thisData[1] = self.saleData[_thisData[0]][0];
962     _thisData[2] = self.saleData[_thisData[0]][1];
963     return _thisData;
964   }
965 
966   /// @dev Gets the number of tokens sold thus far
967   /// @param self Stored Crowdsale from crowdsale contract
968   /// @return Number of tokens sold
969   function getTokensSold(CrowdsaleStorage storage self) constant returns (uint256) {
970     return self.startingTokenBalance - self.token.balanceOf(this);
971   }
972 }