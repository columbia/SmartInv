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
245       _numTokens = _weiTokens/1000000000000000000;
246       _leftoverWei = _weiTokens % 1000000000000000000;
247       _leftoverWei = _leftoverWei/self.base.tokensPerEth;
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
394     require(_endTime > _saleData[0]);
395     require(_capAmountInCents > 0);
396     require(_owner > 0);
397     require(_fallbackExchangeRate > 0);
398     require(_percentBurn <= 100);
399     self.owner = _owner;
400     self.capAmount = ((_capAmountInCents/_fallbackExchangeRate) + 1)*(10**18);
401     self.startTime = _saleData[0];
402     self.endTime = _endTime;
403     self.token = _token;
404     self.tokenDecimals = _token.decimals();
405     self.percentBurn = _percentBurn;
406     self.exchangeRate = _fallbackExchangeRate;
407 
408     uint256 _tempTime;
409     for(uint256 i = 0; i < _saleData.length; i += 3){
410       require(_saleData[i] > _tempTime);
411       require(_saleData[i + 1] > 0);
412       require((_saleData[i + 2] == 0) || (_saleData[i + 2] >= 100));
413       self.milestoneTimes.push(_saleData[i]);
414       self.saleData[_saleData[i]][0] = _saleData[i + 1];
415       self.saleData[_saleData[i]][1] = _saleData[i + 2];
416       _tempTime = _saleData[i];
417     }
418     changeTokenPrice(self, _saleData[1]);
419   }
420 
421   /// @dev function to check if the crowdsale is currently active
422   /// @param self Stored crowdsale from crowdsale contract
423   /// @return success
424   function crowdsaleActive(CrowdsaleStorage storage self) constant returns (bool) {
425   	return (now >= self.startTime && now <= self.endTime);
426   }
427 
428   /// @dev function to check if the crowdsale has ended
429   /// @param self Stored crowdsale from crowdsale contract
430   /// @return success
431   function crowdsaleEnded(CrowdsaleStorage storage self) constant returns (bool) {
432   	return now > self.endTime;
433   }
434 
435   /// @dev function to check if a purchase is valid
436   /// @param self Stored crowdsale from crowdsale contract
437   /// @return true if the transaction can buy tokens
438   function validPurchase(CrowdsaleStorage storage self) internal constant returns (bool) {
439     bool nonZeroPurchase = msg.value != 0;
440     if (crowdsaleActive(self) && nonZeroPurchase) {
441       return true;
442     } else {
443       LogErrorMsg("Invalid Purchase! Check send time and amount of ether.");
444       return false;
445     }
446   }
447 
448   /// @dev Function called by purchasers to pull tokens
449   /// @param self Stored crowdsale from crowdsale contract
450   /// @return true if tokens were withdrawn
451   function withdrawTokens(CrowdsaleStorage storage self) returns (bool) {
452     bool ok;
453 
454     if (self.withdrawTokensMap[msg.sender] == 0) {
455       LogErrorMsg("Sender has no tokens to withdraw!");
456       return false;
457     }
458 
459     if (msg.sender == self.owner) {
460       if(!crowdsaleEnded(self)){
461         LogErrorMsg("Owner cannot withdraw extra tokens until after the sale!");
462         return false;
463       } else {
464         if(self.percentBurn > 0){
465           uint256 _burnAmount = (self.withdrawTokensMap[msg.sender] * self.percentBurn)/100;
466           self.withdrawTokensMap[msg.sender] = self.withdrawTokensMap[msg.sender] - _burnAmount;
467           ok = self.token.burnToken(_burnAmount);
468           require(ok);
469         }
470       }
471     }
472 
473     var total = self.withdrawTokensMap[msg.sender];
474     self.withdrawTokensMap[msg.sender] = 0;
475     ok = self.token.transfer(msg.sender, total);
476     require(ok);
477     LogTokensWithdrawn(msg.sender, total);
478     return true;
479   }
480 
481   /// @dev Function called by purchasers to pull leftover wei from their purchases
482   /// @param self Stored crowdsale from crowdsale contract
483   /// @return true if wei was withdrawn
484   function withdrawLeftoverWei(CrowdsaleStorage storage self) returns (bool) {
485     require(self.hasContributed[msg.sender] > 0);
486     if (self.leftoverWei[msg.sender] == 0) {
487       LogErrorMsg("Sender has no extra wei to withdraw!");
488       return false;
489     }
490 
491     var total = self.leftoverWei[msg.sender];
492     self.leftoverWei[msg.sender] = 0;
493     msg.sender.transfer(total);
494     LogWeiWithdrawn(msg.sender, total);
495     return true;
496   }
497 
498   /// @dev send ether from the completed crowdsale to the owners wallet address
499   /// @param self Stored crowdsale from crowdsale contract
500   /// @return true if owner withdrew eth
501   function withdrawOwnerEth(CrowdsaleStorage storage self) returns (bool) {
502     if ((!crowdsaleEnded(self)) && (self.token.balanceOf(this)>0)) {
503       LogErrorMsg("Cannot withdraw owner ether until after the sale!");
504       return false;
505     }
506 
507     require(msg.sender == self.owner);
508     require(self.ownerBalance > 0);
509 
510     uint256 amount = self.ownerBalance;
511     self.ownerBalance = 0;
512     self.owner.transfer(amount);
513     LogOwnerEthWithdrawn(msg.sender,amount,"Crowdsale owner has withdrawn all funds!");
514 
515     return true;
516   }
517 
518   /// @dev Function to change the price of the token
519   /// @param self Stored crowdsale from crowdsale contract
520   /// @param _newPrice new token price (amount of tokens per ether)
521   /// @return true if the token price changed successfully
522   function changeTokenPrice(CrowdsaleStorage storage self,uint256 _newPrice) internal returns (bool) {
523   	require(_newPrice > 0);
524 
525     uint256 result;
526     uint256 remainder;
527 
528     result = self.exchangeRate / _newPrice;
529     remainder = self.exchangeRate % _newPrice;
530     if(remainder > 0) {
531       self.tokensPerEth = result + 1;
532     } else {
533       self.tokensPerEth = result;
534     }
535     return true;
536   }
537 
538   /// @dev function that is called three days before the sale to set the token and price
539   /// @param self Stored Crowdsale from crowdsale contract
540   /// @param _exchangeRate  ETH exchange rate expressed in cents/ETH
541   /// @return true if the exchange rate has been set
542   function setTokenExchangeRate(CrowdsaleStorage storage self, uint256 _exchangeRate) returns (bool) {
543     require(msg.sender == self.owner);
544     require((now > (self.startTime - 3 days)) && (now < (self.startTime)));
545     require(!self.rateSet);   // the exchange rate can only be set once!
546     require(self.token.balanceOf(this) > 0);
547     require(_exchangeRate > 0);
548 
549     uint256 _capAmountInCents;
550     uint256 _tokenBalance;
551     bool err;
552 
553     (err, _capAmountInCents) = self.exchangeRate.times(self.capAmount);
554     require(!err);
555 
556     _tokenBalance = self.token.balanceOf(this);
557     self.withdrawTokensMap[msg.sender] = _tokenBalance;
558     self.startingTokenBalance = _tokenBalance;
559     self.tokensSet = true;
560 
561     self.exchangeRate = _exchangeRate;
562     self.capAmount = (_capAmountInCents/_exchangeRate) + 1;
563     changeTokenPrice(self,self.saleData[self.milestoneTimes[0]][0]);
564     self.rateSet = true;
565 
566     LogNoticeMsg(msg.sender,self.tokensPerEth,"Owner has sent the exchange Rate and tokens bought per ETH!");
567     return true;
568   }
569 
570   /// @dev fallback function to set tokens if the exchange rate function was not called
571   /// @param self Stored Crowdsale from crowdsale contract
572   /// @return true if tokens set successfully
573   function setTokens(CrowdsaleStorage storage self) returns (bool) {
574     require(msg.sender == self.owner);
575     require(!self.tokensSet);
576 
577     uint256 _tokenBalance;
578 
579     _tokenBalance = self.token.balanceOf(this);
580     self.withdrawTokensMap[msg.sender] = _tokenBalance;
581     self.startingTokenBalance = _tokenBalance;
582     self.tokensSet = true;
583 
584     return true;
585   }
586 
587   /// @dev Gets the price and buy cap for individual addresses at the given milestone index
588   /// @param self Stored Crowdsale from crowdsale contract
589   /// @param timestamp Time during sale for which data is requested
590   /// @return A 3-element array with 0 the timestamp, 1 the price in cents, 2 the address cap
591   function getSaleData(CrowdsaleStorage storage self, uint256 timestamp) constant returns (uint256[3]) {
592     uint256[3] memory _thisData;
593     uint256 index;
594 
595     while((index < self.milestoneTimes.length) && (self.milestoneTimes[index] < timestamp)) {
596       index++;
597     }
598     if(index == 0)
599       index++;
600 
601     _thisData[0] = self.milestoneTimes[index - 1];
602     _thisData[1] = self.saleData[_thisData[0]][0];
603     _thisData[2] = self.saleData[_thisData[0]][1];
604     return _thisData;
605   }
606 
607   /// @dev Gets the number of tokens sold thus far
608   /// @param self Stored Crowdsale from crowdsale contract
609   /// @return Number of tokens sold
610   function getTokensSold(CrowdsaleStorage storage self) constant returns (uint256) {
611     return self.startingTokenBalance - self.token.balanceOf(this);
612   }
613 }
614 contract CrowdsaleToken {
615   using TokenLib for TokenLib.TokenStorage;
616 
617   TokenLib.TokenStorage public token;
618 
619   function CrowdsaleToken(address owner,
620                                 string name,
621                                 string symbol,
622                                 uint8 decimals,
623                                 uint256 initialSupply,
624                                 bool allowMinting)
625   {
626     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
627   }
628 
629   function name() constant returns (string) {
630     return token.name;
631   }
632 
633   function symbol() constant returns (string) {
634     return token.symbol;
635   }
636 
637   function decimals() constant returns (uint8) {
638     return token.decimals;
639   }
640 
641   function totalSupply() constant returns (uint256) {
642     return token.totalSupply;
643   }
644 
645   function initialSupply() constant returns (uint256) {
646     return token.INITIAL_SUPPLY;
647   }
648 
649   function balanceOf(address who) constant returns (uint256) {
650     return token.balanceOf(who);
651   }
652 
653   function allowance(address owner, address spender) constant returns (uint256) {
654     return token.allowance(owner, spender);
655   }
656 
657   function transfer(address to, uint value) returns (bool ok) {
658     return token.transfer(to, value);
659   }
660 
661   function transferFrom(address from, address to, uint value) returns (bool ok) {
662     return token.transferFrom(from, to, value);
663   }
664 
665   function approve(address spender, uint value) returns (bool ok) {
666     return token.approve(spender, value);
667   }
668 
669   function changeOwner(address newOwner) returns (bool ok) {
670     return token.changeOwner(newOwner);
671   }
672 
673   function burnToken(uint256 amount) returns (bool ok) {
674     return token.burnToken(amount);
675   }
676 }
677 
678 library TokenLib {
679   using BasicMathLib for uint256;
680 
681   struct TokenStorage {
682     mapping (address => uint256) balances;
683     mapping (address => mapping (address => uint256)) allowed;
684 
685     string name;
686     string symbol;
687     uint256 totalSupply;
688     uint256 INITIAL_SUPPLY;
689     address owner;
690     uint8 decimals;
691     bool stillMinting;
692   }
693 
694   event Transfer(address indexed from, address indexed to, uint256 value);
695   event Approval(address indexed owner, address indexed spender, uint256 value);
696   event OwnerChange(address from, address to);
697   event Burn(address indexed burner, uint256 value);
698   event MintingClosed(bool mintingClosed);
699 
700   /// @dev Called by the Standard Token upon creation.
701   /// @param self Stored token from token contract
702   /// @param _name Name of the new token
703   /// @param _symbol Symbol of the new token
704   /// @param _decimals Decimal places for the token represented
705   /// @param _initial_supply The initial token supply
706   /// @param _allowMinting True if additional tokens can be created, false otherwise
707   function init(TokenStorage storage self,
708                 address _owner,
709                 string _name,
710                 string _symbol,
711                 uint8 _decimals,
712                 uint256 _initial_supply,
713                 bool _allowMinting)
714   {
715     require(self.INITIAL_SUPPLY == 0);
716     self.name = _name;
717     self.symbol = _symbol;
718     self.totalSupply = _initial_supply;
719     self.INITIAL_SUPPLY = _initial_supply;
720     self.decimals = _decimals;
721     self.owner = _owner;
722     self.stillMinting = _allowMinting;
723     self.balances[_owner] = _initial_supply;
724   }
725 
726   /// @dev Transfer tokens from caller's account to another account.
727   /// @param self Stored token from token contract
728   /// @param _to Address to send tokens
729   /// @param _value Number of tokens to send
730   /// @return True if completed
731   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool) {
732     bool err;
733     uint256 balance;
734 
735     (err,balance) = self.balances[msg.sender].minus(_value);
736     require(!err);
737     self.balances[msg.sender] = balance;
738     //It's not possible to overflow token supply
739     self.balances[_to] = self.balances[_to] + _value;
740     Transfer(msg.sender, _to, _value);
741     return true;
742   }
743 
744   /// @dev Authorized caller transfers tokens from one account to another
745   /// @param self Stored token from token contract
746   /// @param _from Address to send tokens from
747   /// @param _to Address to send tokens to
748   /// @param _value Number of tokens to send
749   /// @return True if completed
750   function transferFrom(TokenStorage storage self,
751                         address _from,
752                         address _to,
753                         uint256 _value)
754                         returns (bool)
755   {
756     var _allowance = self.allowed[_from][msg.sender];
757     bool err;
758     uint256 balanceOwner;
759     uint256 balanceSpender;
760 
761     (err,balanceOwner) = self.balances[_from].minus(_value);
762     require(!err);
763 
764     (err,balanceSpender) = _allowance.minus(_value);
765     require(!err);
766 
767     self.balances[_from] = balanceOwner;
768     self.allowed[_from][msg.sender] = balanceSpender;
769     self.balances[_to] = self.balances[_to] + _value;
770 
771     Transfer(_from, _to, _value);
772     return true;
773   }
774 
775   /// @dev Retrieve token balance for an account
776   /// @param self Stored token from token contract
777   /// @param _owner Address to retrieve balance of
778   /// @return balance The number of tokens in the subject account
779   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
780     return self.balances[_owner];
781   }
782 
783   /// @dev Authorize an account to send tokens on caller's behalf
784   /// @param self Stored token from token contract
785   /// @param _spender Address to authorize
786   /// @param _value Number of tokens authorized account may send
787   /// @return True if completed
788   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool) {
789     self.allowed[msg.sender][_spender] = _value;
790     Approval(msg.sender, _spender, _value);
791     return true;
792   }
793 
794   /// @dev Remaining tokens third party spender has to send
795   /// @param self Stored token from token contract
796   /// @param _owner Address of token holder
797   /// @param _spender Address of authorized spender
798   /// @return remaining Number of tokens spender has left in owner's account
799   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
800     return self.allowed[_owner][_spender];
801   }
802 
803   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
804   /// @param self Stored token from token contract
805   /// @param _spender Address to authorize
806   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
807   /// @param _increase True if increasing allowance, false if decreasing allowance
808   /// @return True if completed
809   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
810                           returns (bool)
811   {
812     uint256 _newAllowed;
813     bool err;
814 
815     if(_increase) {
816       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
817       require(!err);
818 
819       self.allowed[msg.sender][_spender] = _newAllowed;
820     } else {
821       if (_valueChange > self.allowed[msg.sender][_spender]) {
822         self.allowed[msg.sender][_spender] = 0;
823       } else {
824         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
825         self.allowed[msg.sender][_spender] = _newAllowed;
826       }
827     }
828 
829     Approval(msg.sender, _spender, _newAllowed);
830     return true;
831   }
832 
833   /// @dev Change owning address of the token contract, specifically for minting
834   /// @param self Stored token from token contract
835   /// @param _newOwner Address for the new owner
836   /// @return True if completed
837   function changeOwner(TokenStorage storage self, address _newOwner) returns (bool) {
838     require((self.owner == msg.sender) && (_newOwner > 0));
839 
840     self.owner = _newOwner;
841     OwnerChange(msg.sender, _newOwner);
842     return true;
843   }
844 
845   /// @dev Mints additional tokens, new tokens go to owner
846   /// @param self Stored token from token contract
847   /// @param _amount Number of tokens to mint
848   /// @return True if completed
849   function mintToken(TokenStorage storage self, uint256 _amount) returns (bool) {
850     require((self.owner == msg.sender) && self.stillMinting);
851     uint256 _newAmount;
852     bool err;
853 
854     (err, _newAmount) = self.totalSupply.plus(_amount);
855     require(!err);
856 
857     self.totalSupply =  _newAmount;
858     self.balances[self.owner] = self.balances[self.owner] + _amount;
859     Transfer(0x0, self.owner, _amount);
860     return true;
861   }
862 
863   /// @dev Permanent stops minting
864   /// @param self Stored token from token contract
865   /// @return True if completed
866   function closeMint(TokenStorage storage self) returns (bool) {
867     require(self.owner == msg.sender);
868 
869     self.stillMinting = false;
870     MintingClosed(true);
871     return true;
872   }
873 
874   /// @dev Permanently burn tokens
875   /// @param self Stored token from token contract
876   /// @param _amount Amount of tokens to burn
877   /// @return True if completed
878   function burnToken(TokenStorage storage self, uint256 _amount) returns (bool) {
879       uint256 _newBalance;
880       bool err;
881 
882       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
883       require(!err);
884 
885       self.balances[msg.sender] = _newBalance;
886       self.totalSupply = self.totalSupply - _amount;
887       Burn(msg.sender, _amount);
888       Transfer(msg.sender, 0x0, _amount);
889       return true;
890   }
891 }
892 
893 library BasicMathLib {
894   event Err(string typeErr);
895 
896   /// @dev Multiplies two numbers and checks for overflow before returning.
897   /// Does not throw but rather logs an Err event if there is overflow.
898   /// @param a First number
899   /// @param b Second number
900   /// @return err False normally, or true if there is overflow
901   /// @return res The product of a and b, or 0 if there is overflow
902   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
903     assembly{
904       res := mul(a,b)
905       switch or(iszero(b), eq(div(res,b), a))
906       case 0 {
907         err := 1
908         res := 0
909       }
910     }
911     if (err)
912       Err("times func overflow");
913   }
914 
915   /// @dev Divides two numbers but checks for 0 in the divisor first.
916   /// Does not throw but rather logs an Err event if 0 is in the divisor.
917   /// @param a First number
918   /// @param b Second number
919   /// @return err False normally, or true if `b` is 0
920   /// @return res The quotient of a and b, or 0 if `b` is 0
921   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
922     assembly{
923       switch iszero(b)
924       case 0 {
925         res := div(a,b)
926         mstore(add(mload(0x40),0x20),res)
927         return(mload(0x40),0x40)
928       }
929     }
930     Err("tried to divide by zero");
931     return (true, 0);
932   }
933 
934   /// @dev Adds two numbers and checks for overflow before returning.
935   /// Does not throw but rather logs an Err event if there is overflow.
936   /// @param a First number
937   /// @param b Second number
938   /// @return err False normally, or true if there is overflow
939   /// @return res The sum of a and b, or 0 if there is overflow
940   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
941     assembly{
942       res := add(a,b)
943       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
944       case 0 {
945         err := 1
946         res := 0
947       }
948     }
949     if (err)
950       Err("plus func overflow");
951   }
952 
953   /// @dev Subtracts two numbers and checks for underflow before returning.
954   /// Does not throw but rather logs an Err event if there is underflow.
955   /// @param a First number
956   /// @param b Second number
957   /// @return err False normally, or true if there is underflow
958   /// @return res The difference between a and b, or 0 if there is underflow
959   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
960     assembly{
961       res := sub(a,b)
962       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
963       case 0 {
964         err := 1
965         res := 0
966       }
967     }
968     if (err)
969       Err("minus func underflow");
970   }
971 }