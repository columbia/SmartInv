1 // Ethertote - Official Token Sale Contract
2 // 28.07.18
3 //
4 // Any unsold tokens can be sent directly to the TokenBurn Contract
5 // by anyone once the Token Sale is complete - 
6 // this is a PUBLIC function that anyone can call!!
7 //
8 // All Eth raised during the token sale is automatically sent to the 
9 // EthRaised smart contract for distribution
10 
11 
12 pragma solidity ^0.4.24;
13 
14 ///////////////////////////////////////////////////////////////////////////////
15 // SafeMath Library 
16 ///////////////////////////////////////////////////////////////////////////////
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
24     // benefit is lost if 'b' is also tested.
25     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
26     if (a == 0) {
27       return 0;
28     }
29 
30     c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 
65 // ----------------------------------------------------------------------------
66 // Imported Token Contract functions
67 // ----------------------------------------------------------------------------
68 
69 contract EthertoteToken {
70     function thisContractAddress() public pure returns (address) {}
71     function balanceOf(address) public pure returns (uint256) {}
72     function transfer(address, uint) public {}
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // Main Contract
78 // ----------------------------------------------------------------------------
79 
80 contract TokenSale {
81   using SafeMath for uint256;
82   
83   EthertoteToken public token;
84 
85   address public admin;
86   address public thisContractAddress;
87 
88   // address of the TOTE token original smart contract
89   address public tokenContractAddress = 0x42be9831FFF77972c1D0E1eC0aA9bdb3CaA04D47;
90   
91   // address of TokenBurn contract to "burn" unsold tokens
92   // for further details, review the TokenBurn contract and verify code on Etherscan
93   address public tokenBurnAddress = 0xadCa18DC9489C5FE5BdDf1A8a8C2623B66029198;
94   
95   // address of EthRaised contract, that will be used to distribute funds 
96   // raised by the token sale. Added as "wallet address"
97   address public ethRaisedAddress = 0x9F73D808807c71Af185FEA0c1cE205002c74123C;
98   
99   uint public preIcoPhaseCountdown;       // used for website tokensale
100   uint public icoPhaseCountdown;          // used for website tokensale
101   uint public postIcoPhaseCountdown;      // used for website tokensale
102   
103   // pause token sale in an emergency [true/false]
104   bool public tokenSaleIsPaused;
105   
106   // note the pause time to allow special function to extend closingTime
107   uint public tokenSalePausedTime;
108   
109   // note the resume time 
110   uint public tokenSaleResumedTime;
111   
112   // The time (in seconds) that needs to be added on to the closing time 
113   // in the event of an emergency pause of the token sale
114   uint public tokenSalePausedDuration;
115   
116   // Amount of wei raised
117   uint256 public weiRaised;
118   
119   // 1000 tokens per Eth - 9,000,000 tokens for sale
120   uint public maxEthRaised = 9000;
121   
122   // Maximum amount of Wei that can be raised
123   // e.g. 9,000,000 tokens for sale with 1000 tokens per 1 eth
124   // means maximum Wei raised would be maxEthRaised * 1000000000000000000
125   uint public maxWeiRaised = maxEthRaised.mul(1000000000000000000);
126 
127   // starting time and closing time of Crowdsale
128   // scheduled start on Monday, August 27th 2018 at 5:00pm GMT+1
129   uint public openingTime = 1535385600;
130   uint public closingTime = openingTime.add(7 days);
131   
132   // used as a divider so that 1 eth will buy 1000 tokens
133   // set rate to 1,000,000,000,000,000
134   uint public rate = 1000000000000000;
135   
136   // minimum and maximum spend of eth per transaction
137   uint public minSpend = 100000000000000000;    // 0.1 Eth
138   uint public maxSpend = 100000000000000000000; // 100 Eth 
139 
140   
141   // MODIFIERS
142   modifier onlyAdmin { 
143         require(msg.sender == admin
144         ); 
145         _; 
146   }
147   
148   // EVENTS
149   event Deployed(string, uint);
150   event SalePaused(string, uint);
151   event SaleResumed(string, uint);
152   event TokensBurned(string, uint);
153   
154  // ---------------------------------------------------------------------------
155  // Constructor function
156  // _ethRaisedContract = Address where collected funds will be forwarded to
157  // _tokenContractAddress = Address of the original token contract being sold
158  // ---------------------------------------------------------------------------
159  
160   constructor() public {
161     
162     admin = msg.sender;
163     thisContractAddress = address(this);
164 
165     token = EthertoteToken(tokenContractAddress);
166     
167 
168     require(ethRaisedAddress != address(0));
169     require(tokenContractAddress != address(0));
170     require(tokenBurnAddress != address(0));
171 
172     preIcoPhaseCountdown = openingTime;
173     icoPhaseCountdown = closingTime;
174     
175     // after 14 days the "post-tokensale" header section of the homepage 
176     // on the website will be removed based on this time
177     postIcoPhaseCountdown = closingTime.add(14 days);
178     
179     emit Deployed("Ethertote Token Sale contract deployed", now);
180   }
181   
182   
183   
184   // check balance of this smart contract
185   function tokenSaleTokenBalance() public view returns(uint) {
186       return token.balanceOf(thisContractAddress);
187   }
188   
189   // check the token balance of any ethereum address  
190   function getAnyAddressTokenBalance(address _address) public view returns(uint) {
191       return token.balanceOf(_address);
192   }
193   
194   // confirm if The Token Sale has finished
195   function tokenSaleHasFinished() public view returns (bool) {
196     return now > closingTime;
197   }
198   
199   // this function will send any unsold tokens to the null TokenBurn contract address
200   // once the crowdsale is finished, anyone can publicly call this function!
201   function burnUnsoldTokens() public {
202       require(tokenSaleIsPaused == false);
203       require(tokenSaleHasFinished() == true);
204       token.transfer(tokenBurnAddress, tokenSaleTokenBalance());
205       emit TokensBurned("tokens sent to TokenBurn contract", now);
206   }
207 
208 
209 
210   // function to temporarily pause token sale if needed
211   function pauseTokenSale() onlyAdmin public {
212       // confirm the token sale hasn't already completed
213       require(tokenSaleHasFinished() == false);
214       
215       // confirm the token sale isn't already paused
216       require(tokenSaleIsPaused == false);
217       
218       // pause the sale and note the time of the pause
219       tokenSaleIsPaused = true;
220       tokenSalePausedTime = now;
221       emit SalePaused("token sale has been paused", now);
222   }
223   
224     // function to resume token sale
225   function resumeTokenSale() onlyAdmin public {
226       
227       // confirm the token sale is currently paused
228       require(tokenSaleIsPaused == true);
229       
230       tokenSaleResumedTime = now;
231       
232       // now calculate the difference in time between the pause time
233       // and the resume time, to establish how long the sale was
234       // paused for. This time now needs to be added to the closingTime.
235       
236       // Note: if the token sale was paused whilst the sale was live and was
237       // paused before the sale ended, then the value of tokenSalePausedTime
238       // will always be less than the value of tokenSaleResumedTime
239       
240       tokenSalePausedDuration = tokenSaleResumedTime.sub(tokenSalePausedTime);
241       
242       // add the total pause time to the closing time.
243       
244       closingTime = closingTime.add(tokenSalePausedDuration);
245       
246       // extend post ICO countdown for the web-site
247       postIcoPhaseCountdown = closingTime.add(14 days);
248       // now resume the token sale
249       tokenSaleIsPaused = false;
250       emit SaleResumed("token sale has now resumed", now);
251   }
252   
253 
254 // ----------------------------------------------------------------------------
255 // Event for token purchase logging
256 // purchaser = the contract address that paid for the tokens
257 // beneficiary = the address who got the tokens
258 // value = the amount (in Wei) paid for purchase
259 // amount = the amount of tokens purchased
260 // ----------------------------------------------------------------------------
261   event TokenPurchase(
262     address indexed purchaser,
263     address indexed beneficiary,
264     uint256 value,
265     uint256 amount
266   );
267 
268 
269 
270 // -----------------------------------------
271 // Crowdsale external interface
272 // -----------------------------------------
273 
274 
275 // ----------------------------------------------------------------------------
276 // fallback function ***DO NOT OVERRIDE***
277 // allows purchase of tokens directly from MEW and other wallets
278 // will conform to require statements set out in buyTokens() function
279 // ----------------------------------------------------------------------------
280    
281   function () external payable {
282     buyTokens(msg.sender);
283   }
284 
285 
286 // ----------------------------------------------------------------------------
287 // function for front-end token purchase on our website ***DO NOT OVERRIDE***
288 // buyer = Address of the wallet performing the token purchase
289 // ----------------------------------------------------------------------------
290   function buyTokens(address buyer) public payable {
291     
292     // check Crowdsale is open (can disable for testing)
293     require(openingTime <= block.timestamp);
294     require(block.timestamp < closingTime);
295     
296     // minimum purchase of 100 tokens (0.1 eth)
297     require(msg.value >= minSpend);
298     
299     // maximum purchase per transaction to allow broader
300     // token distribution during tokensale
301     require(msg.value <= maxSpend);
302     
303     // stop sales of tokens if token balance is 0
304     require(tokenSaleTokenBalance() > 0);
305     
306     // stop sales of tokens if Token sale is paused
307     require(tokenSaleIsPaused == false);
308     
309     // log the amount being sent
310     uint256 weiAmount = msg.value;
311     preValidatePurchase(buyer, weiAmount);
312 
313     // calculate token amount to be sold
314     uint256 tokens = getTokenAmount(weiAmount);
315     
316     // check that the amount of eth being sent by the buyer 
317     // does not exceed the equivalent number of tokens remaining
318     require(tokens <= tokenSaleTokenBalance());
319 
320     // update state
321     weiRaised = weiRaised.add(weiAmount);
322 
323     processPurchase(buyer, tokens);
324     emit TokenPurchase(
325       msg.sender,
326       buyer,
327       weiAmount,
328       tokens
329     );
330 
331     updatePurchasingState(buyer, weiAmount);
332 
333     forwardFunds();
334     postValidatePurchase(buyer, weiAmount);
335   }
336 
337   // -----------------------------------------
338   // Internal interface (extensible)
339   // -----------------------------------------
340 
341 // ----------------------------------------------------------------------------
342 // Validation of an incoming purchase
343 // ----------------------------------------------------------------------------
344   function preValidatePurchase(
345     address buyer,
346     uint256 weiAmount
347   )
348     internal pure
349   {
350     require(buyer != address(0));
351     require(weiAmount != 0);
352   }
353 
354 // ----------------------------------------------------------------------------
355 // Validation of an executed purchase
356 // ----------------------------------------------------------------------------
357   function postValidatePurchase(
358     address,
359     uint256
360   )
361     internal pure
362   {
363     // optional override
364   }
365 
366 // ----------------------------------------------------------------------------
367 // Source of tokens
368 // ----------------------------------------------------------------------------
369   function deliverTokens(
370     address buyer,
371     uint256 tokenAmount
372   )
373     internal
374   {
375     token.transfer(buyer, tokenAmount);
376   }
377 
378 // ----------------------------------------------------------------------------
379 // The following function is executed when a purchase has been validated 
380 // and is ready to be executed
381 // ----------------------------------------------------------------------------
382   function processPurchase(
383     address buyer,
384     uint256 tokenAmount
385   )
386     internal
387   {
388     deliverTokens(buyer, tokenAmount);
389   }
390 
391 // ----------------------------------------------------------------------------
392 // Override for extensions that require an internal state to check for 
393 // validity (current user contributions, etc.)
394 // ----------------------------------------------------------------------------
395   function updatePurchasingState(
396     address,
397     uint256
398   )
399     internal pure
400   {
401     // optional override
402   }
403 
404 // ----------------------------------------------------------------------------
405 // Override to extend the way in which ether is converted to tokens.
406 // _weiAmount Value in wei to be converted into tokens
407 // return Number of tokens that can be purchased with the specified _weiAmount
408 // ----------------------------------------------------------------------------
409   function getTokenAmount(uint256 weiAmount)
410     internal view returns (uint256)
411   {
412     return weiAmount.div(rate);
413   }
414 
415 // ----------------------------------------------------------------------------
416 // how ETH is stored/forwarded on purchases.
417 // Sent to the EthRaised Contract
418 // ----------------------------------------------------------------------------
419   function forwardFunds() internal {
420     ethRaisedAddress.transfer(msg.value);
421   }
422   
423 
424 // functions for tokensale information on the website 
425 
426     function maximumRaised() public view returns(uint) {
427         return maxWeiRaised;
428     }
429     
430     function amountRaised() public view returns(uint) {
431         return weiRaised;
432     }
433   
434     function timeComplete() public view returns(uint) {
435         return closingTime;
436     }
437     
438     // special function to delay the token sale if necessary
439     function delayOpeningTime(uint256 _openingTime) onlyAdmin public {  
440     openingTime = _openingTime;
441     closingTime = openingTime.add(7 days);
442     preIcoPhaseCountdown = openingTime;
443     icoPhaseCountdown = closingTime;
444     postIcoPhaseCountdown = closingTime.add(14 days);
445     }
446     
447   
448 }