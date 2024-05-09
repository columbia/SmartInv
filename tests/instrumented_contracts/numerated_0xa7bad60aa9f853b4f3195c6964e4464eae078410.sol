1 pragma solidity ^0.4.15;
2 
3 /**
4  * Ethino Crowdsale Contract
5  *
6  * This is the crowdsale contract for the Ethino token. It utilizes Majoolr's
7  * CrowdsaleLib library to reduce custom source code surface area and increase overall
8  * security.Majoolr provides smart contract services
9  * and security reviews for contract deployments in addition to working on open
10  * source projects in the Ethereum community.
11  * For further information: ethino.com, majoolr.io
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
22 contract ENOCrowdsale {
23   using DirectCrowdsaleLib for DirectCrowdsaleLib.DirectCrowdsaleStorage;
24 
25   DirectCrowdsaleLib.DirectCrowdsaleStorage sale;
26 
27   function ENOCrowdsale(
28                 address owner,
29                 uint256 capAmountInCents,
30                 uint256 startTime,
31                 uint256 endTime,
32                 uint256[] tokenPricePoints,
33                 uint256 fallbackExchangeRate,
34                 uint256 changeInterval,
35                 uint8 percentBurn,
36                 CrowdsaleToken token)
37   {
38   	sale.init(owner, capAmountInCents, startTime, endTime, tokenPricePoints, fallbackExchangeRate, changeInterval, percentBurn, token);
39   }
40 
41   /*EVENTS*/
42 
43   event LogTokensBought(address indexed buyer, uint256 amount);
44   event LogErrorMsg(uint256 amount, string Msg);
45   event LogTokenPriceChange(uint256 amount, string Msg);
46   event LogTokensWithdrawn(address indexed _bidder, uint256 Amount);
47   event LogWeiWithdrawn(address indexed _bidder, uint256 Amount);
48   event LogOwnerEthWithdrawn(address indexed owner, uint256 amount, string Msg);
49   event LogNoticeMsg(address _buyer, uint256 value, string Msg);
50   event LogErrorMsg(string Msg);
51 
52   /*FUNCTIONS*/
53 
54   // fallback function can be used to buy tokens
55   function () payable {
56     sendPurchase();
57   }
58 
59   function sendPurchase() payable returns (bool) {
60   	return sale.receivePurchase(msg.value);
61   }
62 
63   function withdrawOwnerEth() returns (bool) {
64   	return sale.withdrawOwnerEth();
65   }
66 
67   function setTokenExchangeRate(uint256 _exchangeRate) returns (bool) {
68     return sale.setTokenExchangeRate(_exchangeRate);
69   }
70 
71   function setTokens() returns (bool) {
72     return sale.setTokens();
73   }
74 
75   function withdrawTokens() returns (bool) {
76   	return sale.withdrawTokens();
77   }
78 
79   function withdrawLeftoverWei() returns (bool) {
80     return sale.withdrawLeftoverWei();
81   }
82 
83   /*GETTERS*/
84 
85   function owner() constant returns (address) {
86     return sale.base.owner;
87   }
88 
89   function tokensPerEth() constant returns (uint256) {
90     return sale.base.tokensPerEth;
91   }
92 
93   function exchangeRate() constant returns (uint256) {
94     return sale.base.exchangeRate;
95   }
96 
97   function capAmount() constant returns (uint256) {
98     return sale.base.capAmount;
99   }
100 
101   function startTime() constant returns (uint256) {
102     return sale.base.startTime;
103   }
104 
105   function endTime() constant returns (uint256) {
106     return sale.base.endTime;
107   }
108 
109   function changeInterval() constant returns (uint256) {
110     return sale.changeInterval;
111   }
112 
113   function crowdsaleActive() constant returns (bool) {
114   	return sale.crowdsaleActive();
115   }
116 
117   function firstPriceChange() constant returns (uint256) {
118     return sale.tokenPricePoints[1];
119   }
120 
121   function crowdsaleEnded() constant returns (bool) {
122   	return sale.crowdsaleEnded();
123   }
124 
125   function ethRaised() constant returns (uint256) {
126     return sale.base.ownerBalance;
127   }
128 
129   function tokensSold() constant returns (uint256) {
130     return sale.base.startingTokenBalance - sale.base.token.balanceOf(this);
131   }
132 
133   function contributionAmount(address _buyer) constant returns (uint256) {
134   	return sale.base.hasContributed[_buyer];
135   }
136 
137   function tokenPurchaseAmount(address _buyer) constant returns (uint256) {
138   	return sale.base.withdrawTokensMap[_buyer];
139   }
140 
141   function leftoverWeiAmount(address _buyer) constant returns (uint256) {
142     return sale.base.leftoverWei[_buyer];
143   }
144 }
145 
146 pragma solidity ^0.4.15;
147 
148 /**
149  * @title DirectCrowdsaleLib
150  * @author Majoolr.io
151  *
152  * version 1.0.0
153  * Copyright (c) 2017 Majoolr, LLC
154  * The MIT License (MIT)
155  * https://github.com/Majoolr/ethereum-libraries/blob/master/LICENSE
156  *
157  * The DirectCrowdsale Library provides functionality to create a initial coin offering
158  * for a standard token sale with high supply where there is a direct ether to
159  * token transfer.
160  *
161  * Majoolr provides smart contract services and security reviews for contract
162  * deployments in addition to working on open source projects in the Ethereum
163  * community. Our purpose is to test, document, and deploy reusable code onto the
164  * blockchain and improve both security and usability. We also educate non-profits,
165  * schools, and other community members about the application of blockchain
166  * technology. For further information: majoolr.io
167  *
168  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
169  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
170  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
171  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
172  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
173  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
174  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
175  */
176 
177 library DirectCrowdsaleLib {
178   using BasicMathLib for uint256;
179   using CrowdsaleLib for CrowdsaleLib.CrowdsaleStorage;
180 
181   struct DirectCrowdsaleStorage {
182 
183   	CrowdsaleLib.CrowdsaleStorage base; // base storage from CrowdsaleLib
184 
185     uint256[] tokenPricePoints;    // price points at each price change interval in cents/token.
186 
187   	uint256 changeInterval;      // amount of time between changes in the price of the token
188   	uint256 lastPriceChangeTime;  // time of the last change in token cost
189   }
190 
191   event LogTokensBought(address indexed buyer, uint256 amount);
192   event LogAddressCapExceeded(address indexed buyer, uint256 amount, string Msg);
193   event LogErrorMsg(uint256 amount, string Msg);
194   event LogTokenPriceChange(uint256 amount, string Msg);
195 
196 
197   /// @dev Called by a crowdsale contract upon creation.
198   /// @param self Stored crowdsale from crowdsale contract
199   /// @param _owner Address of crowdsale owner
200   /// @param _capAmountInCents Total to be raised in cents
201   /// @param _startTime Timestamp of sale start time
202   /// @param _endTime Timestamp of sale end time
203   /// @param _tokenPricePoints Array of each price point during sale cents/token
204   /// @param _fallbackExchangeRate Exchange rate of cents/ETH
205   /// @param _changeInterval The number of seconds between each step
206   /// @param _percentBurn Percentage of extra tokens to burn
207   /// @param _token Token being sold
208   function init(DirectCrowdsaleStorage storage self,
209                 address _owner,
210                 uint256 _capAmountInCents,
211                 uint256 _startTime,
212                 uint256 _endTime,
213                 uint256[] _tokenPricePoints,
214                 uint256 _fallbackExchangeRate,
215                 uint256 _changeInterval,
216                 uint8 _percentBurn,
217                 CrowdsaleToken _token)
218   {
219   	self.base.init(_owner,
220                 _tokenPricePoints[0],
221                 _fallbackExchangeRate,
222                 _capAmountInCents,
223                 _startTime,
224                 _endTime,
225                 _percentBurn,
226                 _token);
227 
228     require(_tokenPricePoints.length > 0);
229 
230     // if there is no increase or decrease in price, the time interval should also be zero
231     if (_tokenPricePoints.length == 1) {
232     	require(_changeInterval == 0);
233     }
234     self.tokenPricePoints = _tokenPricePoints;
235   	self.changeInterval = _changeInterval;
236   	self.lastPriceChangeTime = _startTime;
237   }
238 
239   /// @dev Called when an address wants to purchase tokens
240   /// @param self Stored crowdsale from crowdsale contract
241   /// @param _amount amound of wei that the buyer is sending
242   /// @return true on succesful purchase
243   function receivePurchase(DirectCrowdsaleStorage storage self, uint256 _amount) returns (bool) {
244     require(msg.sender != self.base.owner);
245   	require(self.base.validPurchase());
246 
247     require((self.base.ownerBalance + _amount) <= self.base.capAmount);
248 
249   	// if the token price increase interval has passed, update the current day and change the token price
250   	if ((self.changeInterval > 0) && (now >= (self.lastPriceChangeTime + self.changeInterval))) {
251   		self.lastPriceChangeTime = self.lastPriceChangeTime + self.changeInterval;
252       uint256 index = (now-self.base.startTime)/self.changeInterval;
253 
254       //prevents going out of bounds on the tokenPricePoints array
255       if (self.tokenPricePoints.length <= index)
256         index = self.tokenPricePoints.length - 1;
257 
258       self.base.changeTokenPrice(self.tokenPricePoints[index]);
259 
260       LogTokenPriceChange(self.base.tokensPerEth,"Token Price has changed!");
261   	}
262 
263   	uint256 numTokens; //number of tokens that will be purchased
264   	bool err;
265     uint256 newBalance; //the new balance of the owner of the crowdsale
266     uint256 weiTokens; //temp calc holder
267     uint256 zeros; //for calculating token
268     uint256 leftoverWei; //wei change for purchaser
269     uint256 remainder; //temp calc holder
270 
271     // Find the number of tokens as a function in wei
272     (err,weiTokens) = _amount.times(self.base.tokensPerEth);
273     require(!err);
274 
275     if(self.base.tokenDecimals <= 18){
276       zeros = 10**(18-uint256(self.base.tokenDecimals));
277       numTokens = weiTokens/zeros;
278       leftoverWei = weiTokens % zeros;
279       self.base.leftoverWei[msg.sender] += leftoverWei;
280     } else {
281       zeros = 10**(uint256(self.base.tokenDecimals)-18);
282       numTokens = weiTokens*zeros;
283     }
284 
285     // can't overflow because it is under the cap
286     self.base.hasContributed[msg.sender] += _amount - leftoverWei;
287 
288     require(numTokens <= self.base.token.balanceOf(this));
289 
290     // calculate the amout of ether in the owners balance
291     (err,newBalance) = self.base.ownerBalance.plus(_amount-leftoverWei);
292     require(!err);
293 
294     self.base.ownerBalance = newBalance;   // "deposit" the amount
295 
296     // can't overflow because it will be under the cap
297 	  self.base.withdrawTokensMap[msg.sender] += numTokens;
298 
299     //subtract tokens from owner's share
300     (err,remainder) = self.base.withdrawTokensMap[self.base.owner].minus(numTokens);
301     self.base.withdrawTokensMap[self.base.owner] = remainder;
302 
303 	  LogTokensBought(msg.sender, numTokens);
304 
305     return true;
306   }
307 
308   /*Functions "inherited" from CrowdsaleLib library*/
309 
310   function setTokenExchangeRate(DirectCrowdsaleStorage storage self, uint256 _exchangeRate) returns (bool) {
311     return self.base.setTokenExchangeRate(_exchangeRate);
312   }
313 
314   function setTokens(DirectCrowdsaleStorage storage self) returns (bool) {
315     return self.base.setTokens();
316   }
317 
318   function withdrawTokens(DirectCrowdsaleStorage storage self) returns (bool) {
319     return self.base.withdrawTokens();
320   }
321 
322   function withdrawLeftoverWei(DirectCrowdsaleStorage storage self) returns (bool) {
323     return self.base.withdrawLeftoverWei();
324   }
325 
326   function withdrawOwnerEth(DirectCrowdsaleStorage storage self) returns (bool) {
327     return self.base.withdrawOwnerEth();
328   }
329 
330   function crowdsaleActive(DirectCrowdsaleStorage storage self) constant returns (bool) {
331     return self.base.crowdsaleActive();
332   }
333 
334   function crowdsaleEnded(DirectCrowdsaleStorage storage self) constant returns (bool) {
335     return self.base.crowdsaleEnded();
336   }
337 
338   function validPurchase(DirectCrowdsaleStorage storage self) constant returns (bool) {
339     return self.base.validPurchase();
340   }
341 }
342 pragma solidity ^0.4.15;
343 
344 /**
345  * Standard ERC20 token
346  *
347  * https://github.com/ethereum/EIPs/issues/20
348  * Based on code by FirstBlood:
349  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
350  *
351  * This is an example token contract built using the Majoolr token library at
352  * https://github.com/Majoolr/ethereum-libraries/tree/master/TokenLib. This
353  * example does not use all of the functionality available, it is only
354  * a barebones example of a basic ERC20 token contract.
355  *
356  * Majoolr provides smart contract services and security reviews for contract
357  * deployments in addition to working on open source projects in the Ethereum
358  * community. Our purpose is to test, document, and deploy reusable code onto the
359  * blockchain and improve both security and usability. We also educate non-profits,
360  * schools, and other community members about the application of blockchain
361  * technology. For further information: majoolr.io
362  *
363  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
364  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
365  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
366  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
367  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
368  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
369  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
370  */
371 
372 contract CrowdsaleToken {
373   using TokenLib for TokenLib.TokenStorage;
374 
375   TokenLib.TokenStorage public token;
376 
377   function CrowdsaleToken(address owner,
378                                 string name,
379                                 string symbol,
380                                 uint8 decimals,
381                                 uint256 initialSupply,
382                                 bool allowMinting)
383   {
384     token.init(owner, name, symbol, decimals, initialSupply, allowMinting);
385   }
386 
387   function name() constant returns (string) {
388     return token.name;
389   }
390 
391   function symbol() constant returns (string) {
392     return token.symbol;
393   }
394 
395   function decimals() constant returns (uint8) {
396     return token.decimals;
397   }
398 
399   function totalSupply() constant returns (uint256) {
400     return token.totalSupply;
401   }
402 
403   function initialSupply() constant returns (uint256) {
404     return token.INITIAL_SUPPLY;
405   }
406 
407   function balanceOf(address who) constant returns (uint256) {
408     return token.balanceOf(who);
409   }
410 
411   function allowance(address owner, address spender) constant returns (uint256) {
412     return token.allowance(owner, spender);
413   }
414 
415   function transfer(address to, uint value) returns (bool ok) {
416     return token.transfer(to, value);
417   }
418 
419   function transferFrom(address from, address to, uint value) returns (bool ok) {
420     return token.transferFrom(from, to, value);
421   }
422 
423   function approve(address spender, uint value) returns (bool ok) {
424     return token.approve(spender, value);
425   }
426 
427   function changeOwner(address newOwner) returns (bool ok) {
428     return token.changeOwner(newOwner);
429   }
430 
431   function burnToken(uint256 amount) returns (bool ok) {
432     return token.burnToken(amount);
433   }
434 }
435 
436 pragma solidity ^0.4.15;
437 
438 /**
439  * @title CrowdsaleLib
440  * @author Majoolr.io
441  *
442  * version 1.0.0
443  * Copyright (c) 2017 Majoolr, LLC
444  * The MIT License (MIT)
445  * https://github.com/Majoolr/ethereum-libraries/blob/master/LICENSE
446  *
447  * The Crowdsale Library provides basic functionality to create an initial coin
448  * offering for different types of token sales.
449  *
450  * Majoolr provides smart contract services and security reviews for contract
451  * deployments in addition to working on open source projects in the Ethereum
452  * community. Our purpose is to test, document, and deploy reusable code onto the
453  * blockchain and improve both security and usability. We also educate non-profits,
454  * schools, and other community members about the application of blockchain
455  * technology. For further information: majoolr.io
456  *
457  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
458  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
459  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
460  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
461  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
462  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
463  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
464  */
465 
466 library CrowdsaleLib {
467   using BasicMathLib for uint256;
468 
469   struct CrowdsaleStorage {
470   	address owner;     //owner of the crowdsale
471 
472   	uint256 tokensPerEth;  //number of tokens received per ether
473   	uint256 capAmount; //Maximum amount to be raised in wei
474   	uint256 startTime; //ICO start time, timestamp
475   	uint256 endTime; //ICO end time, timestamp automatically calculated
476     uint256 exchangeRate; //cents/ETH exchange rate at the time of the sale
477     uint256 ownerBalance; //owner wei Balance
478     uint256 startingTokenBalance; //initial amount of tokens for sale
479     uint8 tokenDecimals; //stored token decimals for calculation later
480     uint8 percentBurn; //percentage of extra tokens to burn
481     bool tokensSet; //true if tokens have been prepared for crowdsale
482     bool rateSet; //true if exchange rate has been set
483 
484     //shows how much wei an address has contributed
485   	mapping (address => uint256) hasContributed;
486 
487     //For token withdraw function, maps a user address to the amount of tokens they can withdraw
488   	mapping (address => uint256) withdrawTokensMap;
489 
490     // any leftover wei that buyers contributed that didn't add up to a whole token amount
491     mapping (address => uint256) leftoverWei;
492 
493   	CrowdsaleToken token; //token being sold
494   }
495 
496   // Indicates when an address has withdrawn their supply of tokens
497   event LogTokensWithdrawn(address indexed _bidder, uint256 Amount);
498 
499   // Indicates when an address has withdrawn their supply of extra wei
500   event LogWeiWithdrawn(address indexed _bidder, uint256 Amount);
501 
502   // Logs when owner has pulled eth
503   event LogOwnerEthWithdrawn(address indexed owner, uint256 amount, string Msg);
504 
505   // Generic Notice message that includes and address and number
506   event LogNoticeMsg(address _buyer, uint256 value, string Msg);
507 
508   // Indicates when an error has occurred in the execution of a function
509   event LogErrorMsg(string Msg);
510 
511   /// @dev Called by a crowdsale contract upon creation.
512   /// @param self Stored crowdsale from crowdsale contract
513   /// @param _owner Address of crowdsale owner
514   /// @param _tokenPriceInCents Price of tokens in cents
515   /// @param _fallbackExchangeRate Exchange rate of cents/ETH
516   /// @param _capAmountInCents Total to be raised in cents
517   /// @param _startTime Timestamp of sale start time
518   /// @param _endTime Timestamp of sale end time
519   /// @param _percentBurn Percentage of extra tokens to burn
520   /// @param _token Token being sold
521   function init(CrowdsaleStorage storage self,
522                 address _owner,
523                 uint256 _tokenPriceInCents,
524                 uint256 _fallbackExchangeRate,
525                 uint256 _capAmountInCents,
526                 uint256 _startTime,
527                 uint256 _endTime,
528                 uint8 _percentBurn,
529                 CrowdsaleToken _token)
530   {
531   	require(self.capAmount == 0);
532   	require(self.owner == 0);
533     require(_endTime > _startTime);
534     require(_tokenPriceInCents > 0);
535     require(_capAmountInCents > 0);
536     require(_owner > 0);
537     require(_fallbackExchangeRate > 0);
538     require(_percentBurn <= 100);
539     self.owner = _owner;
540     self.capAmount = ((_capAmountInCents/_fallbackExchangeRate) + 1)*(10**18);
541     self.startTime = _startTime;
542     self.endTime = _endTime;
543     self.token = _token;
544     self.tokenDecimals = _token.decimals();
545     self.percentBurn = _percentBurn;
546     self.exchangeRate = _fallbackExchangeRate;
547     changeTokenPrice(self,_tokenPriceInCents);
548   }
549 
550   /// @dev function to check if the crowdsale is currently active
551   /// @param self Stored crowdsale from crowdsale contract
552   /// @return success
553   function crowdsaleActive(CrowdsaleStorage storage self) constant returns (bool) {
554   	return (now >= self.startTime && now <= self.endTime);
555   }
556 
557   /// @dev function to check if the crowdsale has ended
558   /// @param self Stored crowdsale from crowdsale contract
559   /// @return success
560   function crowdsaleEnded(CrowdsaleStorage storage self) constant returns (bool) {
561   	return now > self.endTime;
562   }
563 
564   /// @dev function to check if a purchase is valid
565   /// @param self Stored crowdsale from crowdsale contract
566   /// @return true if the transaction can buy tokens
567   function validPurchase(CrowdsaleStorage storage self) internal constant returns (bool) {
568     bool nonZeroPurchase = msg.value != 0;
569     if (crowdsaleActive(self) && nonZeroPurchase) {
570       return true;
571     } else {
572       LogErrorMsg("Invalid Purchase! Check send time and amount of ether.");
573       return false;
574     }
575   }
576 
577   /// @dev Function called by purchasers to pull tokens
578   /// @param self Stored crowdsale from crowdsale contract
579   /// @return true if tokens were withdrawn
580   function withdrawTokens(CrowdsaleStorage storage self) returns (bool) {
581     bool ok;
582 
583     if (self.withdrawTokensMap[msg.sender] == 0) {
584       LogErrorMsg("Sender has no tokens to withdraw!");
585       return false;
586     }
587 
588     if (msg.sender == self.owner) {
589       if((!crowdsaleEnded(self))){
590         LogErrorMsg("Owner cannot withdraw extra tokens until after the sale!");
591         return false;
592       } else {
593         if(self.percentBurn > 0){
594           uint256 _burnAmount = (self.withdrawTokensMap[msg.sender] * self.percentBurn)/100;
595           self.withdrawTokensMap[msg.sender] = self.withdrawTokensMap[msg.sender] - _burnAmount;
596           ok = self.token.burnToken(_burnAmount);
597           require(ok);
598         }
599       }
600     }
601 
602     var total = self.withdrawTokensMap[msg.sender];
603     self.withdrawTokensMap[msg.sender] = 0;
604     ok = self.token.transfer(msg.sender, total);
605     require(ok);
606     LogTokensWithdrawn(msg.sender, total);
607     return true;
608   }
609 
610   /// @dev Function called by purchasers to pull leftover wei from their purchases
611   /// @param self Stored crowdsale from crowdsale contract
612   /// @return true if wei was withdrawn
613   function withdrawLeftoverWei(CrowdsaleStorage storage self) returns (bool) {
614     require(self.hasContributed[msg.sender] > 0);
615     if (self.leftoverWei[msg.sender] == 0) {
616       LogErrorMsg("Sender has no extra wei to withdraw!");
617       return false;
618     }
619 
620     var total = self.leftoverWei[msg.sender];
621     self.leftoverWei[msg.sender] = 0;
622     msg.sender.transfer(total);
623     LogWeiWithdrawn(msg.sender, total);
624     return true;
625   }
626 
627   /// @dev send ether from the completed crowdsale to the owners wallet address
628   /// @param self Stored crowdsale from crowdsale contract
629   /// @return true if owner withdrew eth
630   function withdrawOwnerEth(CrowdsaleStorage storage self) returns (bool) {
631     if (!crowdsaleEnded(self)) {
632       LogErrorMsg("Cannot withdraw owner ether until after the sale!");
633       return false;
634     }
635 
636     require(msg.sender == self.owner);
637     require(self.ownerBalance > 0);
638 
639     uint256 amount = self.ownerBalance;
640     self.ownerBalance = 0;
641     self.owner.transfer(amount);
642     LogOwnerEthWithdrawn(msg.sender,amount,"Crowdsale owner has withdrawn all funds!");
643 
644     return true;
645   }
646 
647   /// @dev Function to change the price of the token
648   /// @param self Stored crowdsale from crowdsale contract
649   /// @param _newPrice new token price (amount of tokens per ether)
650   /// @return true if the token price changed successfully
651   function changeTokenPrice(CrowdsaleStorage storage self,uint256 _newPrice) internal returns (bool) {
652   	require(_newPrice > 0);
653 
654     uint256 result;
655     bool err;
656 
657     (err,result) = self.exchangeRate.dividedBy(_newPrice);
658     require(!err);
659 
660   	self.tokensPerEth = result + 1;
661     return true;
662   }
663 
664   /// @dev function that is called three days before the sale to set the token and price
665   /// @param self Stored Crowdsale from crowdsale contract
666   /// @param _exchangeRate  ETH exchange rate expressed in cents/ETH
667   /// @return true if the exchange rate has been set
668   function setTokenExchangeRate(CrowdsaleStorage storage self, uint256 _exchangeRate) returns (bool) {
669     require(msg.sender == self.owner);
670     require((now > (self.startTime - 3 days)) && (now < (self.startTime)));
671     require(!self.rateSet);   // the exchange rate can only be set once!
672     require(self.token.balanceOf(this) > 0);
673     require(_exchangeRate > 0);
674 
675     uint256 _capAmountInCents;
676     uint256 _tokenPriceInCents;
677     uint256 _tokenBalance;
678     bool err;
679 
680     (err, _capAmountInCents) = self.exchangeRate.times(self.capAmount);
681     require(!err);
682 
683     (err, _tokenPriceInCents) = self.exchangeRate.dividedBy(self.tokensPerEth);
684     require(!err);
685 
686     _tokenBalance = self.token.balanceOf(this);
687     self.withdrawTokensMap[msg.sender] = _tokenBalance;
688     self.startingTokenBalance = _tokenBalance;
689     self.tokensSet = true;
690 
691     self.exchangeRate = _exchangeRate;
692     self.capAmount = (_capAmountInCents/_exchangeRate) + 1;
693     changeTokenPrice(self,_tokenPriceInCents + 1);
694     self.rateSet = true;
695 
696     LogNoticeMsg(msg.sender,self.tokensPerEth,"Owner has sent the exchange Rate and tokens bought per ETH!");
697     return true;
698   }
699 
700   /// @dev fallback function to set tokens if the exchange rate function was not called
701   /// @param self Stored Crowdsale from crowdsale contract
702   /// @return true if tokens set successfully
703   function setTokens(CrowdsaleStorage storage self) returns (bool) {
704     require(msg.sender == self.owner);
705     require(!self.tokensSet);
706 
707     uint256 _tokenBalance;
708 
709     _tokenBalance = self.token.balanceOf(this);
710     self.withdrawTokensMap[msg.sender] = _tokenBalance;
711     self.startingTokenBalance = _tokenBalance;
712     self.tokensSet = true;
713 
714     return true;
715   }
716 }
717 
718 pragma solidity ^0.4.15;
719 
720 /**
721  * @title TokenLib
722  * @author Majoolr.io
723  *
724  * version 1.1.0
725  * Copyright (c) 2017 Majoolr, LLC
726  * The MIT License (MIT)
727  * https://github.com/Majoolr/ethereum-libraries/blob/master/LICENSE
728  *
729  * The Token Library provides functionality to create a variety of ERC20 tokens.
730  * See https://github.com/Majoolr/ethereum-contracts for an example of how to
731  * create a basic ERC20 token.
732  *
733  * Majoolr works on open source projects in the Ethereum community with the
734  * purpose of testing, documenting, and deploying reusable code onto the
735  * blockchain to improve security and usability of smart contracts. Majoolr
736  * also strives to educate non-profits, schools, and other community members
737  * about the application of blockchain technology.
738  * For further information: majoolr.io
739  *
740  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
741  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
742  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
743  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
744  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
745  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
746  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
747  */
748 
749 library TokenLib {
750   using BasicMathLib for uint256;
751 
752   struct TokenStorage {
753     mapping (address => uint256) balances;
754     mapping (address => mapping (address => uint256)) allowed;
755 
756     string name;
757     string symbol;
758     uint256 totalSupply;
759     uint256 INITIAL_SUPPLY;
760     address owner;
761     uint8 decimals;
762     bool stillMinting;
763   }
764 
765   event Transfer(address indexed from, address indexed to, uint256 value);
766   event Approval(address indexed owner, address indexed spender, uint256 value);
767   event OwnerChange(address from, address to);
768   event Burn(address indexed burner, uint256 value);
769   event MintingClosed(bool mintingClosed);
770 
771   /// @dev Called by the Standard Token upon creation.
772   /// @param self Stored token from token contract
773   /// @param _name Name of the new token
774   /// @param _symbol Symbol of the new token
775   /// @param _decimals Decimal places for the token represented
776   /// @param _initial_supply The initial token supply
777   /// @param _allowMinting True if additional tokens can be created, false otherwise
778   function init(TokenStorage storage self,
779                 address _owner,
780                 string _name,
781                 string _symbol,
782                 uint8 _decimals,
783                 uint256 _initial_supply,
784                 bool _allowMinting)
785   {
786     require(self.INITIAL_SUPPLY == 0);
787     self.name = _name;
788     self.symbol = _symbol;
789     self.totalSupply = _initial_supply;
790     self.INITIAL_SUPPLY = _initial_supply;
791     self.decimals = _decimals;
792     self.owner = _owner;
793     self.stillMinting = _allowMinting;
794     self.balances[_owner] = _initial_supply;
795   }
796 
797   /// @dev Transfer tokens from caller's account to another account.
798   /// @param self Stored token from token contract
799   /// @param _to Address to send tokens
800   /// @param _value Number of tokens to send
801   /// @return True if completed
802   function transfer(TokenStorage storage self, address _to, uint256 _value) returns (bool) {
803     bool err;
804     uint256 balance;
805 
806     (err,balance) = self.balances[msg.sender].minus(_value);
807     require(!err);
808     self.balances[msg.sender] = balance;
809     //It's not possible to overflow token supply
810     self.balances[_to] = self.balances[_to] + _value;
811     Transfer(msg.sender, _to, _value);
812     return true;
813   }
814 
815   /// @dev Authorized caller transfers tokens from one account to another
816   /// @param self Stored token from token contract
817   /// @param _from Address to send tokens from
818   /// @param _to Address to send tokens to
819   /// @param _value Number of tokens to send
820   /// @return True if completed
821   function transferFrom(TokenStorage storage self,
822                         address _from,
823                         address _to,
824                         uint256 _value)
825                         returns (bool)
826   {
827     var _allowance = self.allowed[_from][msg.sender];
828     bool err;
829     uint256 balanceOwner;
830     uint256 balanceSpender;
831 
832     (err,balanceOwner) = self.balances[_from].minus(_value);
833     require(!err);
834 
835     (err,balanceSpender) = _allowance.minus(_value);
836     require(!err);
837 
838     self.balances[_from] = balanceOwner;
839     self.allowed[_from][msg.sender] = balanceSpender;
840     self.balances[_to] = self.balances[_to] + _value;
841 
842     Transfer(_from, _to, _value);
843     return true;
844   }
845 
846   /// @dev Retrieve token balance for an account
847   /// @param self Stored token from token contract
848   /// @param _owner Address to retrieve balance of
849   /// @return balance The number of tokens in the subject account
850   function balanceOf(TokenStorage storage self, address _owner) constant returns (uint256 balance) {
851     return self.balances[_owner];
852   }
853 
854   /// @dev Authorize an account to send tokens on caller's behalf
855   /// @param self Stored token from token contract
856   /// @param _spender Address to authorize
857   /// @param _value Number of tokens authorized account may send
858   /// @return True if completed
859   function approve(TokenStorage storage self, address _spender, uint256 _value) returns (bool) {
860     self.allowed[msg.sender][_spender] = _value;
861     Approval(msg.sender, _spender, _value);
862     return true;
863   }
864 
865   /// @dev Remaining tokens third party spender has to send
866   /// @param self Stored token from token contract
867   /// @param _owner Address of token holder
868   /// @param _spender Address of authorized spender
869   /// @return remaining Number of tokens spender has left in owner's account
870   function allowance(TokenStorage storage self, address _owner, address _spender) constant returns (uint256 remaining) {
871     return self.allowed[_owner][_spender];
872   }
873 
874   /// @dev Authorize third party transfer by increasing/decreasing allowed rather than setting it
875   /// @param self Stored token from token contract
876   /// @param _spender Address to authorize
877   /// @param _valueChange Increase or decrease in number of tokens authorized account may send
878   /// @param _increase True if increasing allowance, false if decreasing allowance
879   /// @return True if completed
880   function approveChange (TokenStorage storage self, address _spender, uint256 _valueChange, bool _increase)
881                           returns (bool)
882   {
883     uint256 _newAllowed;
884     bool err;
885 
886     if(_increase) {
887       (err, _newAllowed) = self.allowed[msg.sender][_spender].plus(_valueChange);
888       require(!err);
889 
890       self.allowed[msg.sender][_spender] = _newAllowed;
891     } else {
892       if (_valueChange > self.allowed[msg.sender][_spender]) {
893         self.allowed[msg.sender][_spender] = 0;
894       } else {
895         _newAllowed = self.allowed[msg.sender][_spender] - _valueChange;
896         self.allowed[msg.sender][_spender] = _newAllowed;
897       }
898     }
899 
900     Approval(msg.sender, _spender, _newAllowed);
901     return true;
902   }
903 
904   /// @dev Change owning address of the token contract, specifically for minting
905   /// @param self Stored token from token contract
906   /// @param _newOwner Address for the new owner
907   /// @return True if completed
908   function changeOwner(TokenStorage storage self, address _newOwner) returns (bool) {
909     require((self.owner == msg.sender) && (_newOwner > 0));
910 
911     self.owner = _newOwner;
912     OwnerChange(msg.sender, _newOwner);
913     return true;
914   }
915 
916   /// @dev Mints additional tokens, new tokens go to owner
917   /// @param self Stored token from token contract
918   /// @param _amount Number of tokens to mint
919   /// @return True if completed
920   function mintToken(TokenStorage storage self, uint256 _amount) returns (bool) {
921     require((self.owner == msg.sender) && self.stillMinting);
922     uint256 _newAmount;
923     bool err;
924 
925     (err, _newAmount) = self.totalSupply.plus(_amount);
926     require(!err);
927 
928     self.totalSupply =  _newAmount;
929     self.balances[self.owner] = self.balances[self.owner] + _amount;
930     Transfer(0x0, self.owner, _amount);
931     return true;
932   }
933 
934   /// @dev Permanent stops minting
935   /// @param self Stored token from token contract
936   /// @return True if completed
937   function closeMint(TokenStorage storage self) returns (bool) {
938     require(self.owner == msg.sender);
939 
940     self.stillMinting = false;
941     MintingClosed(true);
942     return true;
943   }
944 
945   /// @dev Permanently burn tokens
946   /// @param self Stored token from token contract
947   /// @param _amount Amount of tokens to burn
948   /// @return True if completed
949   function burnToken(TokenStorage storage self, uint256 _amount) returns (bool) {
950       uint256 _newBalance;
951       bool err;
952 
953       (err, _newBalance) = self.balances[msg.sender].minus(_amount);
954       require(!err);
955 
956       self.balances[msg.sender] = _newBalance;
957       self.totalSupply = self.totalSupply - _amount;
958       Burn(msg.sender, _amount);
959       Transfer(msg.sender, 0x0, _amount);
960       return true;
961   }
962 }
963 
964 pragma solidity ^0.4.13;
965 
966 /**
967  * @title Basic Math Library
968  * @author Majoolr.io
969  *
970  * version 1.1.0
971  * Copyright (c) 2017 Majoolr, LLC
972  * The MIT License (MIT)
973  * https://github.com/Majoolr/ethereum-libraries/blob/master/LICENSE
974  *
975  * The Basic Math Library is inspired by the Safe Math library written by
976  * OpenZeppelin at https://github.com/OpenZeppelin/zeppelin-solidity/ .
977  * Majoolr works on open source projects in the Ethereum community with the
978  * purpose of testing, documenting, and deploying reusable code onto the
979  * blockchain to improve security and usability of smart contracts. Majoolr
980  * also strives to educate non-profits, schools, and other community members
981  * about the application of blockchain technology.
982  * For further information: majoolr.io, openzeppelin.org
983  *
984  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
985  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
986  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
987  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
988  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
989  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
990  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
991  */
992 
993 library BasicMathLib {
994   event Err(string typeErr);
995 
996   /// @dev Multiplies two numbers and checks for overflow before returning.
997   /// Does not throw but rather logs an Err event if there is overflow.
998   /// @param a First number
999   /// @param b Second number
1000   /// @return err False normally, or true if there is overflow
1001   /// @return res The product of a and b, or 0 if there is overflow
1002   function times(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
1003     assembly{
1004       res := mul(a,b)
1005       switch or(iszero(b), eq(div(res,b), a))
1006       case 0 {
1007         err := 1
1008         res := 0
1009       }
1010     }
1011     if (err)
1012       Err("times func overflow");
1013   }
1014 
1015   /// @dev Divides two numbers but checks for 0 in the divisor first.
1016   /// Does not throw but rather logs an Err event if 0 is in the divisor.
1017   /// @param a First number
1018   /// @param b Second number
1019   /// @return err False normally, or true if `b` is 0
1020   /// @return res The quotient of a and b, or 0 if `b` is 0
1021   function dividedBy(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
1022     assembly{
1023       switch iszero(b)
1024       case 0 {
1025         res := div(a,b)
1026         mstore(add(mload(0x40),0x20),res)
1027         return(mload(0x40),0x40)
1028       }
1029     }
1030     Err("tried to divide by zero");
1031     return (true, 0);
1032   }
1033 
1034   /// @dev Adds two numbers and checks for overflow before returning.
1035   /// Does not throw but rather logs an Err event if there is overflow.
1036   /// @param a First number
1037   /// @param b Second number
1038   /// @return err False normally, or true if there is overflow
1039   /// @return res The sum of a and b, or 0 if there is overflow
1040   function plus(uint256 a, uint256 b) constant returns (bool err, uint256 res) {
1041     assembly{
1042       res := add(a,b)
1043       switch and(eq(sub(res,b), a), or(gt(res,b),eq(res,b)))
1044       case 0 {
1045         err := 1
1046         res := 0
1047       }
1048     }
1049     if (err)
1050       Err("plus func overflow");
1051   }
1052 
1053   /// @dev Subtracts two numbers and checks for underflow before returning.
1054   /// Does not throw but rather logs an Err event if there is underflow.
1055   /// @param a First number
1056   /// @param b Second number
1057   /// @return err False normally, or true if there is underflow
1058   /// @return res The difference between a and b, or 0 if there is underflow
1059   function minus(uint256 a, uint256 b) constant returns (bool err,uint256 res) {
1060     assembly{
1061       res := sub(a,b)
1062       switch eq(and(eq(add(res,b), a), or(lt(res,a), eq(res,a))), 1)
1063       case 0 {
1064         err := 1
1065         res := 0
1066       }
1067     }
1068     if (err)
1069       Err("minus func underflow");
1070   }
1071 }