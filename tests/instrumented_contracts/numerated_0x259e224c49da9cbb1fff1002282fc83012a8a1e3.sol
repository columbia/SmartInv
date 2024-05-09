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
59       if(msg.value < 17480000000000000000){
60         sale.base.saleData[sale.base.milestoneTimes[0]][0] = 75;
61       } else {
62         sale.base.saleData[sale.base.milestoneTimes[0]][0] = 50;
63       }
64     } else {
65       if(msg.value < 15035000000000000000){
66         sale.base.saleData[sale.base.milestoneTimes[0]][0] = 65;
67       } else {
68         sale.base.saleData[sale.base.milestoneTimes[0]][0] = 43;
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
108       return 382;
109     } else {
110       return 440;
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
320 library CrowdsaleLib {
321   using BasicMathLib for uint256;
322 
323   struct CrowdsaleStorage {
324   	address owner;     //owner of the crowdsale
325 
326   	uint256 tokensPerEth;  //number of tokens received per ether
327   	uint256 capAmount; //Maximum amount to be raised in wei
328   	uint256 startTime; //ICO start time, timestamp
329   	uint256 endTime; //ICO end time, timestamp automatically calculated
330     uint256 exchangeRate; //cents/ETH exchange rate at the time of the sale
331     uint256 ownerBalance; //owner wei Balance
332     uint256 startingTokenBalance; //initial amount of tokens for sale
333     uint256[] milestoneTimes; //Array of timestamps when token price and address cap changes
334     uint8 currentMilestone; //Pointer to the current milestone
335     uint8 tokenDecimals; //stored token decimals for calculation later
336     uint8 percentBurn; //percentage of extra tokens to burn
337     bool tokensSet; //true if tokens have been prepared for crowdsale
338     bool rateSet; //true if exchange rate has been set
339 
340     //Maps timestamp to token price and address purchase cap starting at that time
341     mapping (uint256 => uint256[2]) saleData;
342 
343     //shows how much wei an address has contributed
344   	mapping (address => uint256) hasContributed;
345 
346     //For token withdraw function, maps a user address to the amount of tokens they can withdraw
347   	mapping (address => uint256) withdrawTokensMap;
348 
349     // any leftover wei that buyers contributed that didn't add up to a whole token amount
350     mapping (address => uint256) leftoverWei;
351 
352   	CrowdsaleToken token; //token being sold
353   }
354 
355   // Indicates when an address has withdrawn their supply of tokens
356   event LogTokensWithdrawn(address indexed _bidder, uint256 Amount);
357 
358   // Indicates when an address has withdrawn their supply of extra wei
359   event LogWeiWithdrawn(address indexed _bidder, uint256 Amount);
360 
361   // Logs when owner has pulled eth
362   event LogOwnerEthWithdrawn(address indexed owner, uint256 amount, string Msg);
363 
364   // Generic Notice message that includes and address and number
365   event LogNoticeMsg(address _buyer, uint256 value, string Msg);
366 
367   // Indicates when an error has occurred in the execution of a function
368   event LogErrorMsg(string Msg);
369 
370   /// @dev Called by a crowdsale contract upon creation.
371   /// @param self Stored crowdsale from crowdsale contract
372   /// @param _owner Address of crowdsale owner
373   /// @param _saleData Array of 3 item sets such that, in each 3 element
374   /// set, 1 is timestamp, 2 is price in cents at that time,
375   /// 3 is address token purchase cap at that time, 0 if no address cap
376   /// @param _fallbackExchangeRate Exchange rate of cents/ETH
377   /// @param _capAmountInCents Total to be raised in cents
378   /// @param _endTime Timestamp of sale end time
379   /// @param _percentBurn Percentage of extra tokens to burn
380   /// @param _token Token being sold
381   function init(CrowdsaleStorage storage self,
382                 address _owner,
383                 uint256[] _saleData,
384                 uint256 _fallbackExchangeRate,
385                 uint256 _capAmountInCents,
386                 uint256 _endTime,
387                 uint8 _percentBurn,
388                 CrowdsaleToken _token)
389   {
390   	require(self.capAmount == 0);
391   	require(self.owner == 0);
392     require(_saleData.length > 0);
393     require((_saleData.length%3) == 0); // ensure saleData is 3-item sets
394     require(_saleData[0] > (now + 3 days));
395     require(_endTime > _saleData[0]);
396     require(_capAmountInCents > 0);
397     require(_owner > 0);
398     require(_fallbackExchangeRate > 0);
399     require(_percentBurn <= 100);
400     self.owner = _owner;
401     self.capAmount = ((_capAmountInCents/_fallbackExchangeRate) + 1)*(10**18);
402     self.startTime = _saleData[0];
403     self.endTime = _endTime;
404     self.token = _token;
405     self.tokenDecimals = _token.decimals();
406     self.percentBurn = _percentBurn;
407     self.exchangeRate = _fallbackExchangeRate;
408 
409     uint256 _tempTime;
410     for(uint256 i = 0; i < _saleData.length; i += 3){
411       require(_saleData[i] > _tempTime);
412       require(_saleData[i + 1] > 0);
413       require((_saleData[i + 2] == 0) || (_saleData[i + 2] >= 100));
414       self.milestoneTimes.push(_saleData[i]);
415       self.saleData[_saleData[i]][0] = _saleData[i + 1];
416       self.saleData[_saleData[i]][1] = _saleData[i + 2];
417       _tempTime = _saleData[i];
418     }
419     changeTokenPrice(self, _saleData[1]);
420   }
421 
422   /// @dev function to check if the crowdsale is currently active
423   /// @param self Stored crowdsale from crowdsale contract
424   /// @return success
425   function crowdsaleActive(CrowdsaleStorage storage self) constant returns (bool) {
426   	return (now >= self.startTime && now <= self.endTime);
427   }
428 
429   /// @dev function to check if the crowdsale has ended
430   /// @param self Stored crowdsale from crowdsale contract
431   /// @return success
432   function crowdsaleEnded(CrowdsaleStorage storage self) constant returns (bool) {
433   	return now > self.endTime;
434   }
435 
436   /// @dev function to check if a purchase is valid
437   /// @param self Stored crowdsale from crowdsale contract
438   /// @return true if the transaction can buy tokens
439   function validPurchase(CrowdsaleStorage storage self) internal constant returns (bool) {
440     bool nonZeroPurchase = msg.value != 0;
441     if (crowdsaleActive(self) && nonZeroPurchase) {
442       return true;
443     } else {
444       LogErrorMsg("Invalid Purchase! Check send time and amount of ether.");
445       return false;
446     }
447   }
448 
449   /// @dev Function called by purchasers to pull tokens
450   /// @param self Stored crowdsale from crowdsale contract
451   /// @return true if tokens were withdrawn
452   function withdrawTokens(CrowdsaleStorage storage self) returns (bool) {
453     bool ok;
454 
455     if (self.withdrawTokensMap[msg.sender] == 0) {
456       LogErrorMsg("Sender has no tokens to withdraw!");
457       return false;
458     }
459 
460     if (msg.sender == self.owner) {
461       if(!crowdsaleEnded(self)){
462         LogErrorMsg("Owner cannot withdraw extra tokens until after the sale!");
463         return false;
464       } else {
465         if(self.percentBurn > 0){
466           uint256 _burnAmount = (self.withdrawTokensMap[msg.sender] * self.percentBurn)/100;
467           self.withdrawTokensMap[msg.sender] = self.withdrawTokensMap[msg.sender] - _burnAmount;
468           ok = self.token.burnToken(_burnAmount);
469           require(ok);
470         }
471       }
472     }
473 
474     var total = self.withdrawTokensMap[msg.sender];
475     self.withdrawTokensMap[msg.sender] = 0;
476     ok = self.token.transfer(msg.sender, total);
477     require(ok);
478     LogTokensWithdrawn(msg.sender, total);
479     return true;
480   }
481 
482   /// @dev Function called by purchasers to pull leftover wei from their purchases
483   /// @param self Stored crowdsale from crowdsale contract
484   /// @return true if wei was withdrawn
485   function withdrawLeftoverWei(CrowdsaleStorage storage self) returns (bool) {
486     require(self.hasContributed[msg.sender] > 0);
487     if (self.leftoverWei[msg.sender] == 0) {
488       LogErrorMsg("Sender has no extra wei to withdraw!");
489       return false;
490     }
491 
492     var total = self.leftoverWei[msg.sender];
493     self.leftoverWei[msg.sender] = 0;
494     msg.sender.transfer(total);
495     LogWeiWithdrawn(msg.sender, total);
496     return true;
497   }
498 
499   /// @dev send ether from the completed crowdsale to the owners wallet address
500   /// @param self Stored crowdsale from crowdsale contract
501   /// @return true if owner withdrew eth
502   function withdrawOwnerEth(CrowdsaleStorage storage self) returns (bool) {
503     if ((!crowdsaleEnded(self)) && (self.token.balanceOf(this)>0)) {
504       LogErrorMsg("Cannot withdraw owner ether until after the sale!");
505       return false;
506     }
507 
508     require(msg.sender == self.owner);
509     require(self.ownerBalance > 0);
510 
511     uint256 amount = self.ownerBalance;
512     self.ownerBalance = 0;
513     self.owner.transfer(amount);
514     LogOwnerEthWithdrawn(msg.sender,amount,"Crowdsale owner has withdrawn all funds!");
515 
516     return true;
517   }
518 
519   /// @dev Function to change the price of the token
520   /// @param self Stored crowdsale from crowdsale contract
521   /// @param _newPrice new token price (amount of tokens per ether)
522   /// @return true if the token price changed successfully
523   function changeTokenPrice(CrowdsaleStorage storage self,uint256 _newPrice) internal returns (bool) {
524   	require(_newPrice > 0);
525 
526     uint256 result;
527     uint256 remainder;
528 
529     result = self.exchangeRate / _newPrice;
530     remainder = self.exchangeRate % _newPrice;
531     if(remainder > 0) {
532       self.tokensPerEth = result + 1;
533     } else {
534       self.tokensPerEth = result;
535     }
536     return true;
537   }
538 
539   /// @dev function that is called three days before the sale to set the token and price
540   /// @param self Stored Crowdsale from crowdsale contract
541   /// @param _exchangeRate  ETH exchange rate expressed in cents/ETH
542   /// @return true if the exchange rate has been set
543   function setTokenExchangeRate(CrowdsaleStorage storage self, uint256 _exchangeRate) returns (bool) {
544     require(msg.sender == self.owner);
545     require((now > (self.startTime - 3 days)) && (now < (self.startTime)));
546     require(!self.rateSet);   // the exchange rate can only be set once!
547     require(self.token.balanceOf(this) > 0);
548     require(_exchangeRate > 0);
549 
550     uint256 _capAmountInCents;
551     uint256 _tokenBalance;
552     bool err;
553 
554     (err, _capAmountInCents) = self.exchangeRate.times(self.capAmount);
555     require(!err);
556 
557     _tokenBalance = self.token.balanceOf(this);
558     self.withdrawTokensMap[msg.sender] = _tokenBalance;
559     self.startingTokenBalance = _tokenBalance;
560     self.tokensSet = true;
561 
562     self.exchangeRate = _exchangeRate;
563     self.capAmount = (_capAmountInCents/_exchangeRate) + 1;
564     changeTokenPrice(self,self.saleData[self.milestoneTimes[0]][0]);
565     self.rateSet = true;
566 
567     LogNoticeMsg(msg.sender,self.tokensPerEth,"Owner has sent the exchange Rate and tokens bought per ETH!");
568     return true;
569   }
570 
571   /// @dev fallback function to set tokens if the exchange rate function was not called
572   /// @param self Stored Crowdsale from crowdsale contract
573   /// @return true if tokens set successfully
574   function setTokens(CrowdsaleStorage storage self) returns (bool) {
575     require(msg.sender == self.owner);
576     require(!self.tokensSet);
577 
578     uint256 _tokenBalance;
579 
580     _tokenBalance = self.token.balanceOf(this);
581     self.withdrawTokensMap[msg.sender] = _tokenBalance;
582     self.startingTokenBalance = _tokenBalance;
583     self.tokensSet = true;
584 
585     return true;
586   }
587 
588   /// @dev Gets the price and buy cap for individual addresses at the given milestone index
589   /// @param self Stored Crowdsale from crowdsale contract
590   /// @param timestamp Time during sale for which data is requested
591   /// @return A 3-element array with 0 the timestamp, 1 the price in cents, 2 the address cap
592   function getSaleData(CrowdsaleStorage storage self, uint256 timestamp) constant returns (uint256[3]) {
593     uint256[3] memory _thisData;
594     uint256 index;
595 
596     while((index < self.milestoneTimes.length) && (self.milestoneTimes[index] < timestamp)) {
597       index++;
598     }
599     if(index == 0)
600       index++;
601 
602     _thisData[0] = self.milestoneTimes[index - 1];
603     _thisData[1] = self.saleData[_thisData[0]][0];
604     _thisData[2] = self.saleData[_thisData[0]][1];
605     return _thisData;
606   }
607 
608   /// @dev Gets the number of tokens sold thus far
609   /// @param self Stored Crowdsale from crowdsale contract
610   /// @return Number of tokens sold
611   function getTokensSold(CrowdsaleStorage storage self) constant returns (uint256) {
612     return self.startingTokenBalance - self.token.balanceOf(this);
613   }
614 }
615 
616 contract CrowdsaleToken {
617   using TokenLib for TokenLib.TokenStorage;
618 
619   TokenLib.TokenStorage public token;
620 
621   function CrowdsaleToken(address owner,
622                                 string name,
623                                 string symbol,
624                                 uint8 decimals,
625                                 uint256 initialSupply,
626                                 bool allowMinting)
627   {
628     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
629   }
630 
631   function name() constant returns (string) {
632     return token.name;
633   }
634 
635   function symbol() constant returns (string) {
636     return token.symbol;
637   }
638 
639   function decimals() constant returns (uint8) {
640     return token.decimals;
641   }
642 
643   function totalSupply() constant returns (uint256) {
644     return token.totalSupply;
645   }
646 
647   function initialSupply() constant returns (uint256) {
648     return token.INITIAL_SUPPLY;
649   }
650 
651   function balanceOf(address who) constant returns (uint256) {
652     return token.balanceOf(who);
653   }
654 
655   function allowance(address owner, address spender) constant returns (uint256) {
656     return token.allowance(owner, spender);
657   }
658 
659   function transfer(address to, uint value) returns (bool ok) {
660     return token.transfer(to, value);
661   }
662 
663   function transferFrom(address from, address to, uint value) returns (bool ok) {
664     return token.transferFrom(from, to, value);
665   }
666 
667   function approve(address spender, uint value) returns (bool ok) {
668     return token.approve(spender, value);
669   }
670 
671   function changeOwner(address newOwner) returns (bool ok) {
672     return token.changeOwner(newOwner);
673   }
674 
675   function burnToken(uint256 amount) returns (bool ok) {
676     return token.burnToken(amount);
677   }
678 }
679 
680 library BasicMathLib {
681   event Err(string typeErr);
682 
683   /// @dev Multiplies two numbers and checks for overflow before returning.
684   /// Does not throw but rather logs an Err event if there is overflow.
685   /// @param a First number
686   /// @param b Second number
687   /// @return err False normally, or true if there is overflow
688   /// @return res The product of a and b, or 0 if there is overflow
689   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
690     assembly{
691       res := mul(a,b)
692       switch or(iszero(b), eq(div(res,b), a))
693       case 0 {
694         err := 1
695         res := 0
696       }
697     }
698     if (err)
699       Err("times func overflow");
700   }
701 
702   /// @dev Divides two numbers but checks for 0 in the divisor first.
703   /// Does not throw but rather logs an Err event if 0 is in the divisor.
704   /// @param a First number
705   /// @param b Second number
706   /// @return err False normally, or true if `b` is 0
707   /// @return res The quotient of a and b, or 0 if `b` is 0
708   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
709     assembly{
710       switch iszero(b)
711       case 0 {
712         res := div(a,b)
713         mstore(add(mload(0x40),0x20),res)
714         return(mload(0x40),0x40)
715       }
716     }
717     Err("tried to divide by zero");
718     return (true, 0);
719   }
720 
721   /// @dev Adds two numbers and checks for overflow before returning.
722   /// Does not throw but rather logs an Err event if there is overflow.
723   /// @param a First number
724   /// @param b Second number
725   /// @return err False normally, or true if there is overflow
726   /// @return res The sum of a and b, or 0 if there is overflow
727   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
728     assembly{
729       res := add(a,b)
730       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
731       case 0 {
732         err := 1
733         res := 0
734       }
735     }
736     if (err)
737       Err("plus func overflow");
738   }
739 
740   /// @dev Subtracts two numbers and checks for underflow before returning.
741   /// Does not throw but rather logs an Err event if there is underflow.
742   /// @param a First number
743   /// @param b Second number
744   /// @return err False normally, or true if there is underflow
745   /// @return res The difference between a and b, or 0 if there is underflow
746   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
747     assembly{
748       res := sub(a,b)
749       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
750       case 0 {
751         err := 1
752         res := 0
753       }
754     }
755     if (err)
756       Err("minus func underflow");
757   }
758 }
759 
760 library TokenLib {
761   using BasicMathLib for uint256;
762 
763   struct TokenStorage {
764     mapping (address => uint256) balances;
765     mapping (address => mapping (address => uint256)) allowed;
766 
767     string name;
768     string symbol;
769     uint256 totalSupply;
770     uint256 INITIAL_SUPPLY;
771     address owner;
772     uint8 decimals;
773     bool stillMinting;
774   }
775 
776   event Transfer(address indexed from, address indexed to, uint256 value);
777   event Approval(address indexed owner, address indexed spender, uint256 value);
778   event OwnerChange(address from, address to);
779   event Burn(address indexed burner, uint256 value);
780   event MintingClosed(bool mintingClosed);
781 
782   /// @dev Called by the Standard Token upon creation.
783   /// @param self Stored token from token contract
784   /// @param _name Name of the new token
785   /// @param _symbol Symbol of the new token
786   /// @param _decimals Decimal places for the token represented
787   /// @param _initial_supply The initial token supply
788   /// @param _allowMinting True if additional tokens can be created, false otherwise
789   function init(TokenStorage storage self,
790                 address _owner,
791                 string _name,
792                 string _symbol,
793                 uint8 _decimals,
794                 uint256 _initial_supply,
795                 bool _allowMinting)
796   {
797     require(self.INITIAL_SUPPLY == 0);
798     self.name = _name;
799     self.symbol = _symbol;
800     self.totalSupply = _initial_supply;
801     self.INITIAL_SUPPLY = _initial_supply;
802     self.decimals = _decimals;
803     self.owner = _owner;
804     self.stillMinting = _allowMinting;
805     self.balances[_owner] = _initial_supply;
806   }
807 
808   /// @dev Transfer tokens from caller's account to another account.
809   /// @param self Stored token from token contract
810   /// @param _to Address to send tokens
811   /// @param _value Number of tokens to send
812   /// @return True if completed
813   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool) {
814     bool err;
815     uint256 balance;
816 
817     (err,balance) = self.balances[msg.sender].minus(_value);
818     require(!err);
819     self.balances[msg.sender] = balance;
820     //It's not possible to overflow token supply
821     self.balances[_to] = self.balances[_to] + _value;
822     Transfer(msg.sender, _to, _value);
823     return true;
824   }
825 
826   /// @dev Authorized caller transfers tokens from one account to another
827   /// @param self Stored token from token contract
828   /// @param _from Address to send tokens from
829   /// @param _to Address to send tokens to
830   /// @param _value Number of tokens to send
831   /// @return True if completed
832   function transferFrom(TokenStorage storage self,
833                         address _from,
834                         address _to,
835                         uint256 _value)
836                         returns (bool)
837   {
838     var _allowance = self.allowed[_from][msg.sender];
839     bool err;
840     uint256 balanceOwner;
841     uint256 balanceSpender;
842 
843     (err,balanceOwner) = self.balances[_from].minus(_value);
844     require(!err);
845 
846     (err,balanceSpender) = _allowance.minus(_value);
847     require(!err);
848 
849     self.balances[_from] = balanceOwner;
850     self.allowed[_from][msg.sender] = balanceSpender;
851     self.balances[_to] = self.balances[_to] + _value;
852 
853     Transfer(_from, _to, _value);
854     return true;
855   }
856 
857   /// @dev Retrieve token balance for an account
858   /// @param self Stored token from token contract
859   /// @param _owner Address to retrieve balance of
860   /// @return balance The number of tokens in the subject account
861   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
862     return self.balances[_owner];
863   }
864 
865   /// @dev Authorize an account to send tokens on caller's behalf
866   /// @param self Stored token from token contract
867   /// @param _spender Address to authorize
868   /// @param _value Number of tokens authorized account may send
869   /// @return True if completed
870   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool) {
871     self.allowed[msg.sender][_spender] = _value;
872     Approval(msg.sender, _spender, _value);
873     return true;
874   }
875 
876   /// @dev Remaining tokens third party spender has to send
877   /// @param self Stored token from token contract
878   /// @param _owner Address of token holder
879   /// @param _spender Address of authorized spender
880   /// @return remaining Number of tokens spender has left in owner's account
881   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
882     return self.allowed[_owner][_spender];
883   }
884 
885   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
886   /// @param self Stored token from token contract
887   /// @param _spender Address to authorize
888   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
889   /// @param _increase True if increasing allowance, false if decreasing allowance
890   /// @return True if completed
891   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
892                           returns (bool)
893   {
894     uint256 _newAllowed;
895     bool err;
896 
897     if(_increase) {
898       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
899       require(!err);
900 
901       self.allowed[msg.sender][_spender] = _newAllowed;
902     } else {
903       if (_valueChange > self.allowed[msg.sender][_spender]) {
904         self.allowed[msg.sender][_spender] = 0;
905       } else {
906         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
907         self.allowed[msg.sender][_spender] = _newAllowed;
908       }
909     }
910 
911     Approval(msg.sender, _spender, _newAllowed);
912     return true;
913   }
914 
915   /// @dev Change owning address of the token contract, specifically for minting
916   /// @param self Stored token from token contract
917   /// @param _newOwner Address for the new owner
918   /// @return True if completed
919   function changeOwner(TokenStorage storage self, address _newOwner) returns (bool) {
920     require((self.owner == msg.sender) && (_newOwner > 0));
921 
922     self.owner = _newOwner;
923     OwnerChange(msg.sender, _newOwner);
924     return true;
925   }
926 
927   /// @dev Mints additional tokens, new tokens go to owner
928   /// @param self Stored token from token contract
929   /// @param _amount Number of tokens to mint
930   /// @return True if completed
931   function mintToken(TokenStorage storage self, uint256 _amount) returns (bool) {
932     require((self.owner == msg.sender) && self.stillMinting);
933     uint256 _newAmount;
934     bool err;
935 
936     (err, _newAmount) = self.totalSupply.plus(_amount);
937     require(!err);
938 
939     self.totalSupply =  _newAmount;
940     self.balances[self.owner] = self.balances[self.owner] + _amount;
941     Transfer(0x0, self.owner, _amount);
942     return true;
943   }
944 
945   /// @dev Permanent stops minting
946   /// @param self Stored token from token contract
947   /// @return True if completed
948   function closeMint(TokenStorage storage self) returns (bool) {
949     require(self.owner == msg.sender);
950 
951     self.stillMinting = false;
952     MintingClosed(true);
953     return true;
954   }
955 
956   /// @dev Permanently burn tokens
957   /// @param self Stored token from token contract
958   /// @param _amount Amount of tokens to burn
959   /// @return True if completed
960   function burnToken(TokenStorage storage self, uint256 _amount) returns (bool) {
961       uint256 _newBalance;
962       bool err;
963 
964       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
965       require(!err);
966 
967       self.balances[msg.sender] = _newBalance;
968       self.totalSupply = self.totalSupply - _amount;
969       Burn(msg.sender, _amount);
970       Transfer(msg.sender, 0x0, _amount);
971       return true;
972   }
973 }