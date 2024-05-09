1 pragma solidity ^0.4.18;
2 
3 /**
4  * TradeToken Crowdsale Contract
5  *
6  * This is the crowdsale contract for the TradeToken. It utilizes Majoolr's
7  * CrowdsaleLib library to reduce custom source code surface area and increase
8  * overall security.Majoolr provides smart contract services and security reviews
9  * for contract deployments in addition to working on open source projects in the
10  * Ethereum community.
11  * For further information: trade.io, majoolr.io
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
22 contract TIOCrowdsale {
23   using DirectCrowdsaleLib for DirectCrowdsaleLib.DirectCrowdsaleStorage;
24 
25   DirectCrowdsaleLib.DirectCrowdsaleStorage sale;
26   bool public greenshoeActive;
27   function TIOCrowdsale(
28                 address owner,
29                 uint256[] saleData,           // [1512633600, 50, 0, 1513238400, 56, 0, 1513843200, 64, 0, 1514448000, 75, 0]
30                 uint256 fallbackExchangeRate, // 45000
31                 uint256 capAmountInCents,     // 24750000000
32                 uint256 endTime,              // 1515052740
33                 uint8 percentBurn,            // 100
34                 CrowdsaleToken token)         // 0x80bc5512561c7f85a3a9508c7df7901b370fa1df
35   {
36   	sale.init(owner, saleData, fallbackExchangeRate, capAmountInCents, endTime, percentBurn, token);
37   }
38 
39   // fallback function can be used to buy tokens
40   function () payable {
41     sendPurchase();
42   }
43 
44   function sendPurchase() payable returns (bool) {
45     uint256 _tokensSold = getTokensSold();
46     if(_tokensSold > 270000000000000000000000000 && (!greenshoeActive)){
47       bool success = activateGreenshoe();
48       assert(success);
49     }
50   	return sale.receivePurchase(msg.value);
51   }
52 
53   function activateGreenshoe() private returns (bool) {
54     uint256 _currentPrice = sale.base.saleData[sale.base.milestoneTimes[sale.base.currentMilestone]][0];
55     while(sale.base.milestoneTimes.length > sale.base.currentMilestone + 1)
56     {
57       sale.base.currentMilestone += 1;
58       sale.base.saleData[sale.base.milestoneTimes[sale.base.currentMilestone]][0] = _currentPrice;
59     }
60     greenshoeActive = true;
61     return true;
62   }
63 
64   function withdrawTokens() returns (bool) {
65   	return sale.withdrawTokens();
66   }
67 
68   function withdrawLeftoverWei() returns (bool) {
69     return sale.withdrawLeftoverWei();
70   }
71 
72   function withdrawOwnerEth() returns (bool) {
73     return sale.withdrawOwnerEth();
74   }
75 
76   function crowdsaleActive() constant returns (bool) {
77     return sale.crowdsaleActive();
78   }
79 
80   function crowdsaleEnded() constant returns (bool) {
81     return sale.crowdsaleEnded();
82   }
83 
84   function setTokenExchangeRate(uint256 _exchangeRate) returns (bool) {
85     return sale.setTokenExchangeRate(_exchangeRate);
86   }
87 
88   function setTokens() returns (bool) {
89     return sale.setTokens();
90   }
91 
92   function getOwner() constant returns (address) {
93     return sale.base.owner;
94   }
95 
96   function getTokensPerEth() constant returns (uint256) {
97     return sale.base.tokensPerEth;
98   }
99 
100   function getExchangeRate() constant returns (uint256) {
101     return sale.base.exchangeRate;
102   }
103 
104   function getCapAmount() constant returns (uint256) {
105     if(!greenshoeActive) {
106       return sale.base.capAmount - 160000000000000000000000;
107     } else {
108       return sale.base.capAmount;
109     }
110   }
111 
112   function getStartTime() constant returns (uint256) {
113     return sale.base.startTime;
114   }
115 
116   function getEndTime() constant returns (uint256) {
117     return sale.base.endTime;
118   }
119 
120   function getEthRaised() constant returns (uint256) {
121     return sale.base.ownerBalance;
122   }
123 
124   function getContribution(address _buyer) constant returns (uint256) {
125   	return sale.base.hasContributed[_buyer];
126   }
127 
128   function getTokenPurchase(address _buyer) constant returns (uint256) {
129   	return sale.base.withdrawTokensMap[_buyer];
130   }
131 
132   function getLeftoverWei(address _buyer) constant returns (uint256) {
133     return sale.base.leftoverWei[_buyer];
134   }
135 
136   function getSaleData(uint256 timestamp) constant returns (uint256[3]) {
137     return sale.getSaleData(timestamp);
138   }
139 
140   function getTokensSold() constant returns (uint256) {
141     return sale.base.startingTokenBalance - sale.base.withdrawTokensMap[sale.base.owner];
142   }
143 
144   function getPercentBurn() constant returns (uint256) {
145     return sale.base.percentBurn;
146   }
147 }
148 
149 library DirectCrowdsaleLib {
150   using BasicMathLib for uint256;
151   using CrowdsaleLib for CrowdsaleLib.CrowdsaleStorage;
152 
153   struct DirectCrowdsaleStorage {
154 
155   	CrowdsaleLib.CrowdsaleStorage base; // base storage from CrowdsaleLib
156 
157   }
158 
159   event LogTokensBought(address indexed buyer, uint256 amount);
160   event LogAddressCapExceeded(address indexed buyer, uint256 amount, string Msg);
161   event LogErrorMsg(uint256 amount, string Msg);
162   event LogTokenPriceChange(uint256 amount, string Msg);
163 
164 
165   /// @dev Called by a crowdsale contract upon creation.
166   /// @param self Stored crowdsale from crowdsale contract
167   /// @param _owner Address of crowdsale owner
168   /// @param _saleData Array of 3 item sets such that, in each 3 element
169   /// set, 1 is timestamp, 2 is price in cents at that time,
170   /// 3 is address purchase cap at that time, 0 if no address cap
171   /// @param _fallbackExchangeRate Exchange rate of cents/ETH
172   /// @param _capAmountInCents Total to be raised in cents
173   /// @param _endTime Timestamp of sale end time
174   /// @param _percentBurn Percentage of extra tokens to burn
175   /// @param _token Token being sold
176   function init(DirectCrowdsaleStorage storage self,
177                 address _owner,
178                 uint256[] _saleData,
179                 uint256 _fallbackExchangeRate,
180                 uint256 _capAmountInCents,
181                 uint256 _endTime,
182                 uint8 _percentBurn,
183                 CrowdsaleToken _token)
184                 public
185   {
186   	self.base.init(_owner,
187                 _saleData,
188                 _fallbackExchangeRate,
189                 _capAmountInCents,
190                 _endTime,
191                 _percentBurn,
192                 _token);
193   }
194 
195   /// @dev Called when an address wants to purchase tokens
196   /// @param self Stored crowdsale from crowdsale contract
197   /// @param _amount amount of wei that the buyer is sending
198   /// @return true on succesful purchase
199   function receivePurchase(DirectCrowdsaleStorage storage self, uint256 _amount)
200                            public
201                            returns (bool)
202   {
203     require(msg.sender != self.base.owner);
204   	require(self.base.validPurchase());
205 
206   	// if the token price increase interval has passed, update the current day and change the token price
207   	if ((self.base.milestoneTimes.length > self.base.currentMilestone + 1) &&
208         (now > self.base.milestoneTimes[self.base.currentMilestone + 1]))
209     {
210         while((self.base.milestoneTimes.length > self.base.currentMilestone + 1) &&
211               (now > self.base.milestoneTimes[self.base.currentMilestone + 1]))
212         {
213           self.base.currentMilestone += 1;
214         }
215 
216         self.base.changeTokenPrice(self.base.saleData[self.base.milestoneTimes[self.base.currentMilestone]][0]);
217         LogTokenPriceChange(self.base.tokensPerEth,"Token Price has changed!");
218     }
219 
220   	uint256 _numTokens; //number of tokens that will be purchased
221     uint256 _newBalance; //the new balance of the owner of the crowdsale
222     uint256 _weiTokens; //temp calc holder
223     uint256 _leftoverWei; //wei change for purchaser
224     uint256 _remainder; //temp calc holder
225     bool err;
226 
227     if((self.base.ownerBalance + _amount) > self.base.capAmount){
228       _leftoverWei = (self.base.ownerBalance + _amount) - self.base.capAmount;
229       _amount = _amount - _leftoverWei;
230     }
231 
232     // Find the number of tokens as a function in wei
233     (err,_weiTokens) = _amount.times(self.base.tokensPerEth);
234     require(!err);
235 
236     _numTokens = _weiTokens / 1000000000000000000;
237     _remainder = _weiTokens % 1000000000000000000;
238     _remainder = _remainder / self.base.tokensPerEth;
239     _leftoverWei = _leftoverWei + _remainder;
240     _amount = _amount - _remainder;
241     self.base.leftoverWei[msg.sender] += _leftoverWei;
242 
243     // can't overflow because it is under the cap
244     self.base.hasContributed[msg.sender] += _amount;
245 
246     assert(_numTokens <= self.base.token.balanceOf(this));
247 
248     // calculate the amount of ether in the owners balance
249     (err,_newBalance) = self.base.ownerBalance.plus(_amount);
250     require(!err);
251 
252     self.base.ownerBalance = _newBalance;   // "deposit" the amount
253 
254     // can't overflow because it will be under the cap
255 	  self.base.withdrawTokensMap[msg.sender] += _numTokens;
256 
257     //subtract tokens from owner's share
258     (err,_remainder) = self.base.withdrawTokensMap[self.base.owner].minus(_numTokens);
259     require(!err);
260     self.base.withdrawTokensMap[self.base.owner] = _remainder;
261 
262 	  LogTokensBought(msg.sender, _numTokens);
263 
264     return true;
265   }
266 
267   /*Functions "inherited" from CrowdsaleLib library*/
268 
269   function setTokenExchangeRate(DirectCrowdsaleStorage storage self, uint256 _exchangeRate)
270                                 public
271                                 returns (bool)
272   {
273     return self.base.setTokenExchangeRate(_exchangeRate);
274   }
275 
276   function setTokens(DirectCrowdsaleStorage storage self) public returns (bool) {
277     return self.base.setTokens();
278   }
279 
280   function withdrawTokens(DirectCrowdsaleStorage storage self) public returns (bool) {
281     return self.base.withdrawTokens();
282   }
283 
284   function withdrawLeftoverWei(DirectCrowdsaleStorage storage self) public returns (bool) {
285     return self.base.withdrawLeftoverWei();
286   }
287 
288   function withdrawOwnerEth(DirectCrowdsaleStorage storage self) public returns (bool) {
289     return self.base.withdrawOwnerEth();
290   }
291 
292   function getSaleData(DirectCrowdsaleStorage storage self, uint256 timestamp)
293                        public
294                        view
295                        returns (uint256[3])
296   {
297     return self.base.getSaleData(timestamp);
298   }
299 
300   function getTokensSold(DirectCrowdsaleStorage storage self) public view returns (uint256) {
301     return self.base.getTokensSold();
302   }
303 
304   function crowdsaleActive(DirectCrowdsaleStorage storage self) public view returns (bool) {
305     return self.base.crowdsaleActive();
306   }
307 
308   function crowdsaleEnded(DirectCrowdsaleStorage storage self) public view returns (bool) {
309     return self.base.crowdsaleEnded();
310   }
311 }
312 
313 library CrowdsaleLib {
314   using BasicMathLib for uint256;
315 
316   struct CrowdsaleStorage {
317   	address owner;     //owner of the crowdsale
318 
319   	uint256 tokensPerEth;  //number of tokens received per ether
320   	uint256 capAmount; //Maximum amount to be raised in wei
321   	uint256 startTime; //ICO start time, timestamp
322   	uint256 endTime; //ICO end time, timestamp automatically calculated
323     uint256 exchangeRate; //cents/ETH exchange rate at the time of the sale
324     uint256 ownerBalance; //owner wei Balance
325     uint256 startingTokenBalance; //initial amount of tokens for sale
326     uint256[] milestoneTimes; //Array of timestamps when token price and address cap changes
327     uint8 currentMilestone; //Pointer to the current milestone
328     uint8 tokenDecimals; //stored token decimals for calculation later
329     uint8 percentBurn; //percentage of extra tokens to burn
330     bool tokensSet; //true if tokens have been prepared for crowdsale
331     bool rateSet; //true if exchange rate has been set
332 
333     //Maps timestamp to token price and address purchase cap starting at that time
334     mapping (uint256 => uint256[2]) saleData;
335 
336     //shows how much wei an address has contributed
337   	mapping (address => uint256) hasContributed;
338 
339     //For token withdraw function, maps a user address to the amount of tokens they can withdraw
340   	mapping (address => uint256) withdrawTokensMap;
341 
342     // any leftover wei that buyers contributed that didn't add up to a whole token amount
343     mapping (address => uint256) leftoverWei;
344 
345   	CrowdsaleToken token; //token being sold
346   }
347 
348   // Indicates when an address has withdrawn their supply of tokens
349   event LogTokensWithdrawn(address indexed _bidder, uint256 Amount);
350 
351   // Indicates when an address has withdrawn their supply of extra wei
352   event LogWeiWithdrawn(address indexed _bidder, uint256 Amount);
353 
354   // Logs when owner has pulled eth
355   event LogOwnerEthWithdrawn(address indexed owner, uint256 amount, string Msg);
356 
357   // Generic Notice message that includes and address and number
358   event LogNoticeMsg(address _buyer, uint256 value, string Msg);
359 
360   // Indicates when an error has occurred in the execution of a function
361   event LogErrorMsg(uint256 amount, string Msg);
362 
363   /// @dev Called by a crowdsale contract upon creation.
364   /// @param self Stored crowdsale from crowdsale contract
365   /// @param _owner Address of crowdsale owner
366   /// @param _saleData Array of 3 item sets such that, in each 3 element
367   /// set, 1 is timestamp, 2 is price in cents at that time,
368   /// 3 is address token purchase cap at that time, 0 if no address cap
369   /// @param _fallbackExchangeRate Exchange rate of cents/ETH
370   /// @param _capAmountInCents Total to be raised in cents
371   /// @param _endTime Timestamp of sale end time
372   /// @param _percentBurn Percentage of extra tokens to burn
373   /// @param _token Token being sold
374   function init(CrowdsaleStorage storage self,
375                 address _owner,
376                 uint256[] _saleData,
377                 uint256 _fallbackExchangeRate,
378                 uint256 _capAmountInCents,
379                 uint256 _endTime,
380                 uint8 _percentBurn,
381                 CrowdsaleToken _token)
382                 public
383   {
384   	require(self.capAmount == 0);
385   	require(self.owner == 0);
386     require(_saleData.length > 0);
387     require((_saleData.length%3) == 0); // ensure saleData is 3-item sets
388     require(_saleData[0] > (now + 3 days));
389     require(_endTime > _saleData[0]);
390     require(_capAmountInCents > 0);
391     require(_owner > 0);
392     require(_fallbackExchangeRate > 0);
393     require(_percentBurn <= 100);
394     self.owner = _owner;
395     self.capAmount = ((_capAmountInCents/_fallbackExchangeRate) + 1)*(10**18);
396     self.startTime = _saleData[0];
397     self.endTime = _endTime;
398     self.token = _token;
399     self.tokenDecimals = _token.decimals();
400     self.percentBurn = _percentBurn;
401     self.exchangeRate = _fallbackExchangeRate;
402 
403     uint256 _tempTime;
404     for(uint256 i = 0; i < _saleData.length; i += 3){
405       require(_saleData[i] > _tempTime);
406       require(_saleData[i + 1] > 0);
407       require((_saleData[i + 2] == 0) || (_saleData[i + 2] >= 100));
408       self.milestoneTimes.push(_saleData[i]);
409       self.saleData[_saleData[i]][0] = _saleData[i + 1];
410       self.saleData[_saleData[i]][1] = _saleData[i + 2];
411       _tempTime = _saleData[i];
412     }
413     changeTokenPrice(self, _saleData[1]);
414   }
415 
416   /// @dev function to check if the crowdsale is currently active
417   /// @param self Stored crowdsale from crowdsale contract
418   /// @return success
419   function crowdsaleActive(CrowdsaleStorage storage self) public view returns (bool) {
420   	return (now >= self.startTime && now <= self.endTime);
421   }
422 
423   /// @dev function to check if the crowdsale has ended
424   /// @param self Stored crowdsale from crowdsale contract
425   /// @return success
426   function crowdsaleEnded(CrowdsaleStorage storage self) public view returns (bool) {
427   	return now > self.endTime;
428   }
429 
430   /// @dev function to check if a purchase is valid
431   /// @param self Stored crowdsale from crowdsale contract
432   /// @return true if the transaction can buy tokens
433   function validPurchase(CrowdsaleStorage storage self) internal returns (bool) {
434     bool nonZeroPurchase = msg.value != 0;
435     if (crowdsaleActive(self) && nonZeroPurchase) {
436       return true;
437     } else {
438       LogErrorMsg(msg.value, "Invalid Purchase! Check start time and amount of ether.");
439       return false;
440     }
441   }
442 
443   /// @dev Function called by purchasers to pull tokens
444   /// @param self Stored crowdsale from crowdsale contract
445   /// @return true if tokens were withdrawn
446   function withdrawTokens(CrowdsaleStorage storage self) public returns (bool) {
447     bool ok;
448 
449     if (self.withdrawTokensMap[msg.sender] == 0) {
450       LogErrorMsg(0, "Sender has no tokens to withdraw!");
451       return false;
452     }
453 
454     if (msg.sender == self.owner) {
455       if(!crowdsaleEnded(self)){
456         LogErrorMsg(0, "Owner cannot withdraw extra tokens until after the sale!");
457         return false;
458       } else {
459         if(self.percentBurn > 0){
460           uint256 _burnAmount = (self.withdrawTokensMap[msg.sender] * self.percentBurn)/100;
461           self.withdrawTokensMap[msg.sender] = self.withdrawTokensMap[msg.sender] - _burnAmount;
462           ok = self.token.burnToken(_burnAmount);
463           require(ok);
464         }
465       }
466     }
467 
468     var total = self.withdrawTokensMap[msg.sender];
469     self.withdrawTokensMap[msg.sender] = 0;
470     ok = self.token.transfer(msg.sender, total);
471     require(ok);
472     LogTokensWithdrawn(msg.sender, total);
473     return true;
474   }
475 
476   /// @dev Function called by purchasers to pull leftover wei from their purchases
477   /// @param self Stored crowdsale from crowdsale contract
478   /// @return true if wei was withdrawn
479   function withdrawLeftoverWei(CrowdsaleStorage storage self) public returns (bool) {
480     if (self.leftoverWei[msg.sender] == 0) {
481       LogErrorMsg(0, "Sender has no extra wei to withdraw!");
482       return false;
483     }
484 
485     var total = self.leftoverWei[msg.sender];
486     self.leftoverWei[msg.sender] = 0;
487     msg.sender.transfer(total);
488     LogWeiWithdrawn(msg.sender, total);
489     return true;
490   }
491 
492   /// @dev send ether from the completed crowdsale to the owners wallet address
493   /// @param self Stored crowdsale from crowdsale contract
494   /// @return true if owner withdrew eth
495   function withdrawOwnerEth(CrowdsaleStorage storage self) public returns (bool) {
496     if ((!crowdsaleEnded(self)) && (self.token.balanceOf(this)>0)) {
497       LogErrorMsg(0, "Cannot withdraw owner ether until after the sale!");
498       return false;
499     }
500 
501     require(msg.sender == self.owner);
502     require(self.ownerBalance > 0);
503 
504     uint256 amount = self.ownerBalance;
505     self.ownerBalance = 0;
506     self.owner.transfer(amount);
507     LogOwnerEthWithdrawn(msg.sender,amount,"Crowdsale owner has withdrawn all funds!");
508 
509     return true;
510   }
511 
512   /// @dev Function to change the price of the token
513   /// @param self Stored crowdsale from crowdsale contract
514   /// @param _newPrice new token price (amount of tokens per ether)
515   /// @return true if the token price changed successfully
516   function changeTokenPrice(CrowdsaleStorage storage self,
517                             uint256 _newPrice)
518                             internal
519                             returns (bool)
520   {
521   	require(_newPrice > 0);
522 
523     bool err;
524     uint256 result;
525 
526     (err, result) = self.exchangeRate.times(10**uint256(self.tokenDecimals));
527     require(!err);
528 
529     self.tokensPerEth = result / _newPrice;
530 
531     return true;
532   }
533 
534   /// @dev function that is called three days before the sale to set the token and price
535   /// @param self Stored Crowdsale from crowdsale contract
536   /// @param _exchangeRate  ETH exchange rate expressed in cents/ETH
537   /// @return true if the exchange rate has been set
538   function setTokenExchangeRate(CrowdsaleStorage storage self, uint256 _exchangeRate)
539                                 public
540                                 returns (bool)
541   {
542     require(msg.sender == self.owner);
543     require((now > (self.startTime - 3 days)) && (now < (self.startTime)));
544     require(!self.rateSet);   // the exchange rate can only be set once!
545     require(self.token.balanceOf(this) > 0);
546     require(_exchangeRate > 0);
547 
548     uint256 _capAmountInCents;
549     bool err;
550 
551     (err, _capAmountInCents) = self.exchangeRate.times(self.capAmount);
552     require(!err);
553 
554     self.exchangeRate = _exchangeRate;
555     self.capAmount = (_capAmountInCents/_exchangeRate) + 1;
556     changeTokenPrice(self,self.saleData[self.milestoneTimes[0]][0]);
557     self.rateSet = true;
558 
559     err = !(setTokens(self));
560     require(!err);
561 
562     LogNoticeMsg(msg.sender,self.tokensPerEth,"Owner has set the exchange Rate and tokens bought per ETH!");
563     return true;
564   }
565 
566   /// @dev fallback function to set tokens if the exchange rate function was not called
567   /// @param self Stored Crowdsale from crowdsale contract
568   /// @return true if tokens set successfully
569   function setTokens(CrowdsaleStorage storage self) public returns (bool) {
570     require((msg.sender == self.owner) || (msg.sender == address(this)));
571     require(!self.tokensSet);
572 
573     uint256 _tokenBalance;
574 
575     _tokenBalance = self.token.balanceOf(this);
576     self.withdrawTokensMap[msg.sender] = _tokenBalance;
577     self.startingTokenBalance = _tokenBalance;
578     self.tokensSet = true;
579 
580     return true;
581   }
582 
583   /// @dev Gets the price and buy cap for individual addresses at the given milestone index
584   /// @param self Stored Crowdsale from crowdsale contract
585   /// @param timestamp Time during sale for which data is requested
586   /// @return A 3-element array with 0 the timestamp, 1 the price in cents, 2 the address cap
587   function getSaleData(CrowdsaleStorage storage self, uint256 timestamp)
588                        public
589                        view
590                        returns (uint256[3])
591   {
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
610   function getTokensSold(CrowdsaleStorage storage self) public view returns (uint256) {
611     return self.startingTokenBalance - self.token.balanceOf(this);
612   }
613 }
614 
615 library TokenLib {
616   using BasicMathLib for uint256;
617 
618   struct TokenStorage {
619     bool initialized;
620     mapping (address => uint256) balances;
621     mapping (address => mapping (address => uint256)) allowed;
622 
623     string name;
624     string symbol;
625     uint256 totalSupply;
626     uint256 initialSupply;
627     address owner;
628     uint8 decimals;
629     bool stillMinting;
630   }
631 
632   event Transfer(address indexed from, address indexed to, uint256 value);
633   event Approval(address indexed owner, address indexed spender, uint256 value);
634   event OwnerChange(address from, address to);
635   event Burn(address indexed burner, uint256 value);
636   event MintingClosed(bool mintingClosed);
637 
638   /// @dev Called by the Standard Token upon creation.
639   /// @param self Stored token from token contract
640   /// @param _name Name of the new token
641   /// @param _symbol Symbol of the new token
642   /// @param _decimals Decimal places for the token represented
643   /// @param _initial_supply The initial token supply
644   /// @param _allowMinting True if additional tokens can be created, false otherwise
645   function init(TokenStorage storage self,
646                 address _owner,
647                 string _name,
648                 string _symbol,
649                 uint8 _decimals,
650                 uint256 _initial_supply,
651                 bool _allowMinting)
652                 public
653   {
654     require(!self.initialized);
655     self.initialized = true;
656     self.name = _name;
657     self.symbol = _symbol;
658     self.totalSupply = _initial_supply;
659     self.initialSupply = _initial_supply;
660     self.decimals = _decimals;
661     self.owner = _owner;
662     self.stillMinting = _allowMinting;
663     self.balances[_owner] = _initial_supply;
664   }
665 
666   /// @dev Transfer tokens from caller's account to another account.
667   /// @param self Stored token from token contract
668   /// @param _to Address to send tokens
669   /// @param _value Number of tokens to send
670   /// @return True if completed
671   function transfer(TokenStorage storage self, address _to, uint256 _value) public returns (bool) {
672     require(_to != address(0));
673     bool err;
674     uint256 balance;
675 
676     (err,balance) = self.balances[msg.sender].minus(_value);
677     require(!err);
678     self.balances[msg.sender] = balance;
679     //It's not possible to overflow token supply
680     self.balances[_to] = self.balances[_to] + _value;
681     Transfer(msg.sender, _to, _value);
682     return true;
683   }
684 
685   /// @dev Authorized caller transfers tokens from one account to another
686   /// @param self Stored token from token contract
687   /// @param _from Address to send tokens from
688   /// @param _to Address to send tokens to
689   /// @param _value Number of tokens to send
690   /// @return True if completed
691   function transferFrom(TokenStorage storage self,
692                         address _from,
693                         address _to,
694                         uint256 _value)
695                         public
696                         returns (bool)
697   {
698     var _allowance = self.allowed[_from][msg.sender];
699     bool err;
700     uint256 balanceOwner;
701     uint256 balanceSpender;
702 
703     (err,balanceOwner) = self.balances[_from].minus(_value);
704     require(!err);
705 
706     (err,balanceSpender) = _allowance.minus(_value);
707     require(!err);
708 
709     self.balances[_from] = balanceOwner;
710     self.allowed[_from][msg.sender] = balanceSpender;
711     self.balances[_to] = self.balances[_to] + _value;
712 
713     Transfer(_from, _to, _value);
714     return true;
715   }
716 
717   /// @dev Retrieve token balance for an account
718   /// @param self Stored token from token contract
719   /// @param _owner Address to retrieve balance of
720   /// @return balance The number of tokens in the subject account
721   function balanceOf(TokenStorage storage self, address _owner) public view returns (uint256 balance) {
722     return self.balances[_owner];
723   }
724 
725   /// @dev Authorize an account to send tokens on caller's behalf
726   /// @param self Stored token from token contract
727   /// @param _spender Address to authorize
728   /// @param _value Number of tokens authorized account may send
729   /// @return True if completed
730   function approve(TokenStorage storage self, address _spender, uint256 _value) public returns (bool) {
731     // must set to zero before changing approval amount in accordance with spec
732     require((_value == 0) || (self.allowed[msg.sender][_spender] == 0));
733 
734     self.allowed[msg.sender][_spender] = _value;
735     Approval(msg.sender, _spender, _value);
736     return true;
737   }
738 
739   /// @dev Remaining tokens third party spender has to send
740   /// @param self Stored token from token contract
741   /// @param _owner Address of token holder
742   /// @param _spender Address of authorized spender
743   /// @return remaining Number of tokens spender has left in owner's account
744   function allowance(TokenStorage storage self, address _owner, address _spender)
745                      public
746                      view
747                      returns (uint256 remaining) {
748     return self.allowed[_owner][_spender];
749   }
750 
751   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
752   /// @param self Stored token from token contract
753   /// @param _spender Address to authorize
754   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
755   /// @param _increase True if increasing allowance, false if decreasing allowance
756   /// @return True if completed
757   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
758                           public returns (bool)
759   {
760     uint256 _newAllowed;
761     bool err;
762 
763     if(_increase) {
764       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
765       require(!err);
766 
767       self.allowed[msg.sender][_spender] = _newAllowed;
768     } else {
769       if (_valueChange > self.allowed[msg.sender][_spender]) {
770         self.allowed[msg.sender][_spender] = 0;
771       } else {
772         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
773         self.allowed[msg.sender][_spender] = _newAllowed;
774       }
775     }
776 
777     Approval(msg.sender, _spender, _newAllowed);
778     return true;
779   }
780 
781   /// @dev Change owning address of the token contract, specifically for minting
782   /// @param self Stored token from token contract
783   /// @param _newOwner Address for the new owner
784   /// @return True if completed
785   function changeOwner(TokenStorage storage self, address _newOwner) public returns (bool) {
786     require((self.owner == msg.sender) && (_newOwner > 0));
787 
788     self.owner = _newOwner;
789     OwnerChange(msg.sender, _newOwner);
790     return true;
791   }
792 
793   /// @dev Mints additional tokens, new tokens go to owner
794   /// @param self Stored token from token contract
795   /// @param _amount Number of tokens to mint
796   /// @return True if completed
797   function mintToken(TokenStorage storage self, uint256 _amount) public returns (bool) {
798     require((self.owner == msg.sender) && self.stillMinting);
799     uint256 _newAmount;
800     bool err;
801 
802     (err, _newAmount) = self.totalSupply.plus(_amount);
803     require(!err);
804 
805     self.totalSupply =  _newAmount;
806     self.balances[self.owner] = self.balances[self.owner] + _amount;
807     Transfer(0x0, self.owner, _amount);
808     return true;
809   }
810 
811   /// @dev Permanent stops minting
812   /// @param self Stored token from token contract
813   /// @return True if completed
814   function closeMint(TokenStorage storage self) public returns (bool) {
815     require(self.owner == msg.sender);
816 
817     self.stillMinting = false;
818     MintingClosed(true);
819     return true;
820   }
821 
822   /// @dev Permanently burn tokens
823   /// @param self Stored token from token contract
824   /// @param _amount Amount of tokens to burn
825   /// @return True if completed
826   function burnToken(TokenStorage storage self, uint256 _amount) public returns (bool) {
827       uint256 _newBalance;
828       bool err;
829 
830       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
831       require(!err);
832 
833       self.balances[msg.sender] = _newBalance;
834       self.totalSupply = self.totalSupply - _amount;
835       Burn(msg.sender, _amount);
836       Transfer(msg.sender, 0x0, _amount);
837       return true;
838   }
839 }
840 
841 library BasicMathLib {
842   /// @dev Multiplies two numbers and checks for overflow before returning.
843   /// Does not throw.
844   /// @param a First number
845   /// @param b Second number
846   /// @return err False normally, or true if there is overflow
847   /// @return res The product of a and b, or 0 if there is overflow
848   function times(uint256 a, uint256 b) public view returns (bool err,uint256 res) {
849     assembly{
850       res := mul(a,b)
851       switch or(iszero(b), eq(div(res,b), a))
852       case 0 {
853         err := 1
854         res := 0
855       }
856     }
857   }
858 
859   /// @dev Divides two numbers but checks for 0 in the divisor first.
860   /// Does not throw.
861   /// @param a First number
862   /// @param b Second number
863   /// @return err False normally, or true if `b` is 0
864   /// @return res The quotient of a and b, or 0 if `b` is 0
865   function dividedBy(uint256 a, uint256 b) public view returns (bool err,uint256 i) {
866     uint256 res;
867     assembly{
868       switch iszero(b)
869       case 0 {
870         res := div(a,b)
871         let loc := mload(0x40)
872         mstore(add(loc,0x20),res)
873         i := mload(add(loc,0x20))
874       }
875       default {
876         err := 1
877         i := 0
878       }
879     }
880   }
881 
882   /// @dev Adds two numbers and checks for overflow before returning.
883   /// Does not throw.
884   /// @param a First number
885   /// @param b Second number
886   /// @return err False normally, or true if there is overflow
887   /// @return res The sum of a and b, or 0 if there is overflow
888   function plus(uint256 a, uint256 b) public view returns (bool err, uint256 res) {
889     assembly{
890       res := add(a,b)
891       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
892       case 0 {
893         err := 1
894         res := 0
895       }
896     }
897   }
898 
899   /// @dev Subtracts two numbers and checks for underflow before returning.
900   /// Does not throw but rather logs an Err event if there is underflow.
901   /// @param a First number
902   /// @param b Second number
903   /// @return err False normally, or true if there is underflow
904   /// @return res The difference between a and b, or 0 if there is underflow
905   function minus(uint256 a, uint256 b) public view returns (bool err,uint256 res) {
906     assembly{
907       res := sub(a,b)
908       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
909       case 0 {
910         err := 1
911         res := 0
912       }
913     }
914   }
915 }
916 
917 contract CrowdsaleToken {
918   using TokenLib for TokenLib.TokenStorage;
919 
920   TokenLib.TokenStorage public token;
921 
922   function CrowdsaleToken(address owner,
923                                    string name,
924                                    string symbol,
925                                    uint8 decimals,
926                                    uint256 initialSupply,
927                                    bool allowMinting)
928                                    public
929   {
930     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
931   }
932 
933   function name() public view returns (string) {
934     return token.name;
935   }
936 
937   function symbol() public view returns (string) {
938     return token.symbol;
939   }
940 
941   function decimals() public view returns (uint8) {
942     return token.decimals;
943   }
944 
945   function totalSupply() public view returns (uint256) {
946     return token.totalSupply;
947   }
948 
949   function initialSupply() public view returns (uint256) {
950     return token.initialSupply;
951   }
952 
953   function balanceOf(address who) public view returns (uint256) {
954     return token.balanceOf(who);
955   }
956 
957   function allowance(address owner, address spender) public view returns (uint256) {
958     return token.allowance(owner, spender);
959   }
960 
961   function transfer(address to, uint256 value) public returns (bool ok) {
962     return token.transfer(to, value);
963   }
964 
965   function transferFrom(address from, address to, uint value) public returns (bool ok) {
966     return token.transferFrom(from, to, value);
967   }
968 
969   function approve(address spender, uint256 value) public returns (bool ok) {
970     return token.approve(spender, value);
971   }
972 
973   function approveChange(address spender, uint256 valueChange, bool increase)
974                          public
975                          returns (bool)
976   {
977     return token.approveChange(spender, valueChange, increase);
978   }
979 
980   function changeOwner(address newOwner) public returns (bool ok) {
981     return token.changeOwner(newOwner);
982   }
983 
984   function burnToken(uint256 amount) public returns (bool ok) {
985     return token.burnToken(amount);
986   }
987 }