1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86   /**
87    * @dev Allows the current owner to relinquish control of the contract.
88    */
89   function renounceOwnership() public onlyOwner {
90     emit OwnershipRenounced(owner);
91     owner = address(0);
92   }
93 }
94 
95 contract Token {
96   function transfer(address _to, uint256 _value) public returns (bool);
97   function balanceOf(address who) public view returns (uint256);
98 }
99 
100 /**
101  * @title Crowdsale
102  * @dev Crowdsale is a base contract for managing a token crowdsale,
103  * allowing investors to purchase tokens with ether. This contract implements
104  * such functionality in its most fundamental form and can be extended to provide additional
105  * functionality and/or custom behavior.
106  * The external interface represents the basic interface for purchasing tokens, and conform
107  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
108  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
109  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
110  * behavior.
111  */
112 contract Crowdsale is Ownable {
113   using SafeMath for uint256;
114 
115   // The token being sold
116   Token public token;
117 
118   // Address where funds are collected
119   address public wallet;
120 
121   // How many usd per 10000 tokens.
122   uint256 public rate = 7142;
123 
124   // usd cents per 1 ETH
125   uint256 public ethRate = 27500;
126 
127   // Amount of wei raised
128   uint256 public weiRaised;
129 
130   // Seconds in a week
131   uint256 public week = 604800;
132 
133   // ICO start time
134   uint256 public icoStartTime;
135 
136   // bonuses in %
137   uint256 public privateIcoBonus = 50;
138   uint256 public preIcoBonus = 30;
139   uint256 public ico1Bonus = 15;
140   uint256 public ico2Bonus = 10;
141   uint256 public ico3Bonus = 5;
142   uint256 public ico4Bonus = 0;
143 
144   // min contribution in wei
145   uint256 public privateIcoMin = 1 ether;
146   uint256 public preIcoMin = 1 ether;
147   uint256 public ico1Min = 1 ether;
148   uint256 public ico2Min = 1 ether;
149   uint256 public ico3Min = 1 ether;
150   uint256 public ico4Min = 1 ether; 
151 
152   // max contribution in wei
153   uint256 public privateIcoMax = 350 ether;
154   uint256 public preIcoMax = 10000 ether;
155   uint256 public ico1Max = 10000 ether;
156   uint256 public ico2Max = 10000 ether;
157   uint256 public ico3Max = 10000 ether;
158   uint256 public ico4Max = 10000 ether;
159 
160 
161   // hardcaps in tokens
162   uint256 public privateIcoCap = uint256(322532).mul(1e8);
163   uint256 public preIcoCap = uint256(8094791).mul(1e8);
164   uint256 public ico1Cap = uint256(28643106).mul(1e8);
165   uint256 public ico2Cap = uint256(17123596).mul(1e8);
166   uint256 public ico3Cap = uint256(9807150).mul(1e8);
167   uint256 public ico4Cap = uint256(6008825).mul(1e8);
168 
169   // tokens sold
170   uint256 public privateIcoSold;
171   uint256 public preIcoSold;
172   uint256 public ico1Sold;
173   uint256 public ico2Sold;
174   uint256 public ico3Sold;
175   uint256 public ico4Sold;
176 
177   //whitelist
178   mapping(address => bool) public whitelist; 
179   //whitelisters addresses
180   mapping(address => bool) public whitelisters;
181 
182   modifier isWhitelister() {
183     require(whitelisters[msg.sender]);
184     _;
185   }
186 
187   modifier isWhitelisted() {
188     require(whitelist[msg.sender]);
189     _;
190   }
191 
192   // Sale stages
193   enum Stages {Pause, PrivateIco, PrivateIcoEnd, PreIco, PreIcoEnd, Ico1, Ico2, Ico3, Ico4, IcoEnd}
194 
195   Stages currentStage;
196 
197   /**
198    * Event for token purchase logging
199    * @param purchaser who paid for the tokens
200    * @param beneficiary who got the tokens
201    * @param value weis paid for purchase
202    * @param amount amount of tokens purchased
203    */
204   event TokenPurchase(
205     address indexed purchaser,
206     address indexed beneficiary,
207     uint256 value,
208     uint256 amount
209   );
210 
211   /** Event emitted when _account is Whitelisted / UnWhitelisted */
212   event WhitelistUpdated(address indexed _account, uint8 _phase);
213 
214   /**
215    * @param _wallet Address where collected funds will be forwarded to
216    * @param _token Address of the token being sold
217    */
218   constructor(address _newOwner, address _wallet, Token _token) public {
219     require(_newOwner != address(0));
220     require(_wallet != address(0));
221     require(_token != address(0));
222 
223     owner = _newOwner;
224     wallet = _wallet;
225     token = _token;
226 
227     currentStage = Stages.Pause;
228   }
229 
230   // -----------------------------------------
231   // Crowdsale external interface
232   // -----------------------------------------
233 
234   /**
235    * @dev fallback function ***DO NOT OVERRIDE***
236    */
237   function () external payable {
238     buyTokens(msg.sender);
239   }
240 
241   /**
242    * @dev sale stage start
243    */
244 
245   function startPrivateIco() public onlyOwner returns (bool) {
246     require(currentStage == Stages.Pause);
247     currentStage = Stages.PrivateIco;
248     return true;
249   }
250 
251   /**
252    * @dev sale stage end
253    */
254 
255   function endPrivateIco() public onlyOwner returns (bool) {
256     require(currentStage == Stages.PrivateIco);
257     currentStage = Stages.PrivateIcoEnd;
258     return true;
259   }
260 
261   /**
262    * @dev sale stage start
263    */
264 
265   function startPreIco() public onlyOwner returns (bool) {
266     require(currentStage == Stages.PrivateIcoEnd);
267     currentStage = Stages.PreIco;
268     return true;
269   }
270 
271   /**
272    * @dev sale stage end
273    */
274 
275   function endPreIco() public onlyOwner returns (bool) {
276     require(currentStage == Stages.PreIco);
277     currentStage = Stages.PreIcoEnd;
278     return true;
279   }
280 
281   /**
282    * @dev sale stage start
283    */
284 
285   function startIco() public onlyOwner returns (bool) {
286     require(currentStage == Stages.PreIcoEnd);
287     currentStage = Stages.Ico1;
288     icoStartTime = now;
289     return true;
290   }
291 
292 
293   /**
294    * @dev getting stage index (private ICO = 1, pre ICO = 2, ICO = 3, pause = 0, end = 9)
295    */
296 
297   function getStageName () public view returns (string) {
298     if (currentStage == Stages.Pause) return 'Pause';
299     if (currentStage == Stages.PrivateIco) return 'Private ICO';
300     if (currentStage == Stages.PrivateIcoEnd) return 'Private ICO end';
301     if (currentStage == Stages.PreIco) return 'Prte ICO';
302     if (currentStage == Stages.PreIcoEnd) return 'Pre ICO end';
303     if (currentStage == Stages.Ico1) return 'ICO 1-st week';
304     if (currentStage == Stages.Ico2) return 'ICO 2-d week';
305     if (currentStage == Stages.Ico3) return 'ICO 3-d week';
306     if (currentStage == Stages.Ico4) return 'ICO 4-th week';
307     return 'ICO is over';
308   }
309 
310   /**
311    * @dev low level token purchase ***DO NOT OVERRIDE***
312    * @param _beneficiary Address performing the token purchase
313    */
314   function buyTokens(address _beneficiary) public payable isWhitelisted {
315 
316     uint256 weiAmount = msg.value;
317     uint256 time;
318     uint256 weeksPassed;
319 
320     require(currentStage != Stages.Pause);
321     require(currentStage != Stages.PrivateIcoEnd);
322     require(currentStage != Stages.PreIcoEnd);
323     require(currentStage != Stages.IcoEnd);
324 
325     if (currentStage == Stages.Ico1 || currentStage == Stages.Ico2 || currentStage == Stages.Ico3 || currentStage == Stages.Ico4) {
326       time = now.sub(icoStartTime);
327       weeksPassed = time.div(week);
328 
329       if (currentStage == Stages.Ico1) {
330         if (weeksPassed == 1) currentStage = Stages.Ico2;
331         else if (weeksPassed == 2) currentStage = Stages.Ico3;
332         else if (weeksPassed == 3) currentStage = Stages.Ico4;
333         else if (weeksPassed > 3) currentStage = Stages.IcoEnd;
334       } else if (currentStage == Stages.Ico2) {
335         if (weeksPassed == 2) currentStage = Stages.Ico3;
336         else if (weeksPassed == 3) currentStage = Stages.Ico4;
337         else if (weeksPassed > 3) currentStage = Stages.IcoEnd;
338       } else if (currentStage == Stages.Ico3) {
339         if (weeksPassed == 3) currentStage = Stages.Ico4;
340         else if (weeksPassed > 3) currentStage = Stages.IcoEnd;
341       } else if (currentStage == Stages.Ico4) {
342         if (weeksPassed > 3) currentStage = Stages.IcoEnd;
343       }
344     }
345 
346     if (currentStage != Stages.IcoEnd) {
347       _preValidatePurchase(_beneficiary, weiAmount);
348 
349       // calculate token amount to be created
350       uint256 tokens = _getTokenAmount(weiAmount);
351 
352       // update state
353       weiRaised = weiRaised.add(weiAmount);
354 
355       if (currentStage == Stages.PrivateIco) privateIcoSold = privateIcoSold.add(tokens);
356       if (currentStage == Stages.PreIco) preIcoSold = preIcoSold.add(tokens);
357       if (currentStage == Stages.Ico1) ico1Sold = ico1Sold.add(tokens);
358       if (currentStage == Stages.Ico2) ico2Sold = ico2Sold.add(tokens);
359       if (currentStage == Stages.Ico3) ico3Sold = ico3Sold.add(tokens);
360       if (currentStage == Stages.Ico4) ico4Sold = ico4Sold.add(tokens);
361 
362       _processPurchase(_beneficiary, tokens);
363       emit TokenPurchase(
364         msg.sender,
365         _beneficiary,
366         weiAmount,
367         tokens
368       );
369 
370       _forwardFunds();
371     } else {
372       msg.sender.transfer(msg.value);
373     }
374   }
375 
376   // -----------------------------------------
377   // Internal interface (extensible)
378   // -----------------------------------------
379 
380   /**
381    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
382    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
383    *   super._preValidatePurchase(_beneficiary, _weiAmount);
384    *   require(weiRaised.add(_weiAmount) <= cap);
385    * @param _beneficiary Address performing the token purchase
386    * @param _weiAmount Value in wei involved in the purchase
387    */
388   function _preValidatePurchase(
389     address _beneficiary,
390     uint256 _weiAmount
391   )
392     internal view
393   {
394     require(_beneficiary != address(0));
395     require(_weiAmount != 0);
396 
397     if (currentStage == Stages.PrivateIco) {
398       require(_weiAmount >= privateIcoMin);
399       require(_weiAmount <= privateIcoMax);
400     } else if (currentStage == Stages.PreIco) {
401       require(_weiAmount >= preIcoMin);
402       require(_weiAmount <= preIcoMax);
403     } else if (currentStage == Stages.Ico1) {
404       require(_weiAmount >= ico1Min);
405       require(_weiAmount <= ico1Max);
406     } else if (currentStage == Stages.Ico2) {
407       require(_weiAmount >= ico2Min);
408       require(_weiAmount <= ico2Max);
409     } else if (currentStage == Stages.Ico3) {
410       require(_weiAmount >= ico3Min);
411       require(_weiAmount <= ico3Max);
412     } else if (currentStage == Stages.Ico4) {
413       require(_weiAmount >= ico4Min);
414       require(_weiAmount <= ico4Max);
415     }
416   }
417 
418   /**
419    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
420    * @param _beneficiary Address performing the token purchase
421    * @param _tokenAmount Number of tokens to be emitted
422    */
423   function _deliverTokens(
424     address _beneficiary,
425     uint256 _tokenAmount
426   )
427     internal
428   {
429     require(token.transfer(_beneficiary, _tokenAmount));
430   }
431 
432   /**
433    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
434    * @param _beneficiary Address receiving the tokens
435    * @param _tokenAmount Number of tokens to be purchased
436    */
437   function _processPurchase(
438     address _beneficiary,
439     uint256 _tokenAmount
440   )
441     internal
442   {
443     _deliverTokens(_beneficiary, _tokenAmount);
444   }
445 
446   /**
447    * @dev Override to extend the way in which ether is converted to tokens.
448    * @param _weiAmount Value in wei to be converted into tokens
449    * @return Number of tokens that can be purchased with the specified _weiAmount
450    */
451   function _getTokenAmount(uint256 _weiAmount)
452     internal view returns (uint256)
453   {
454     uint256 bonus;
455     uint256 cap;
456 
457     if (currentStage == Stages.PrivateIco) {
458       bonus = privateIcoBonus;
459       cap = privateIcoCap.sub(privateIcoSold);
460     } else if (currentStage == Stages.PreIco) {
461       bonus = preIcoBonus;
462       cap = preIcoCap.sub(preIcoSold);
463     } else if (currentStage == Stages.Ico1) {
464       bonus = ico1Bonus;
465       cap = ico1Cap.sub(ico1Sold);
466     } else if (currentStage == Stages.Ico2) {
467       bonus = ico2Bonus;
468       cap = ico2Cap.sub(ico2Sold);
469     } else if (currentStage == Stages.Ico3) {
470       bonus = ico3Bonus;
471       cap = ico3Cap.sub(ico3Sold);
472     } else if (currentStage == Stages.Ico4) {
473       bonus = ico4Bonus;
474       cap = ico4Cap.sub(ico4Sold);
475     }
476     uint256 tokenAmount = _weiAmount.mul(ethRate).div(rate).div(1e8);
477     uint256 bonusTokens = tokenAmount.mul(bonus).div(100);
478     tokenAmount = tokenAmount.add(bonusTokens);
479 
480     require(tokenAmount <= cap);
481     return tokenAmount;
482   }
483 
484   /**
485    * @dev Determines how ETH is stored/forwarded on purchases.
486    */
487   function _forwardFunds() internal {
488     wallet.transfer(msg.value);
489   }
490 
491   function withdrawTokens() public onlyOwner returns (bool) {
492     uint256 time;
493     uint256 weeksPassed;
494 
495     if (currentStage == Stages.Ico1 || currentStage == Stages.Ico2 || currentStage == Stages.Ico3 || currentStage == Stages.Ico4) {
496       time = now.sub(icoStartTime);
497       weeksPassed = time.div(week);
498 
499       if (weeksPassed > 3) currentStage = Stages.IcoEnd;
500     }
501     require(currentStage == Stages.IcoEnd);
502 
503     uint256 balance = token.balanceOf(address(this));
504     if (balance > 0) {
505       require(token.transfer(owner, balance));
506     }
507   }
508 
509   /**
510    * @dev Direct tokens sending
511    * @param _to address
512    * @param _amount tokens amount
513    */
514   function SendTokens(address _to, uint256 _amount) public onlyOwner returns (bool) {
515     uint256 time;
516     uint256 weeksPassed;
517 
518     require(_to != address(0));
519     require(currentStage != Stages.Pause);
520     require(currentStage != Stages.PrivateIcoEnd);
521     require(currentStage != Stages.PreIcoEnd);
522     require(currentStage != Stages.IcoEnd);
523 
524     if (currentStage == Stages.Ico1 || currentStage == Stages.Ico2 || currentStage == Stages.Ico3 || currentStage == Stages.Ico4) {
525       time = now.sub(icoStartTime);
526       weeksPassed = time.div(week);
527 
528       if (currentStage == Stages.Ico1) {
529         if (weeksPassed == 1) currentStage = Stages.Ico2;
530         else if (weeksPassed == 2) currentStage = Stages.Ico3;
531         else if (weeksPassed == 3) currentStage = Stages.Ico4;
532         else if (weeksPassed > 3) currentStage = Stages.IcoEnd;
533       } else if (currentStage == Stages.Ico2) {
534         if (weeksPassed == 2) currentStage = Stages.Ico3;
535         else if (weeksPassed == 3) currentStage = Stages.Ico4;
536         else if (weeksPassed > 3) currentStage = Stages.IcoEnd;
537       } else if (currentStage == Stages.Ico3) {
538         if (weeksPassed == 3) currentStage = Stages.Ico4;
539         else if (weeksPassed > 3) currentStage = Stages.IcoEnd;
540       } else if (currentStage == Stages.Ico4) {
541         if (weeksPassed > 3) currentStage = Stages.IcoEnd;
542       }
543     }
544 
545     if (currentStage != Stages.IcoEnd) {
546       uint256 cap;
547       if (currentStage == Stages.PrivateIco) {
548         cap = privateIcoCap.sub(privateIcoSold);
549       } else if (currentStage == Stages.PreIco) {
550         cap = preIcoCap.sub(preIcoSold);
551       } else if (currentStage == Stages.Ico1) {
552         cap = ico1Cap.sub(ico1Sold);
553       } else if (currentStage == Stages.Ico2) {
554         cap = ico2Cap.sub(ico2Sold);
555       } else if (currentStage == Stages.Ico3) {
556         cap = ico3Cap.sub(ico3Sold);
557       } else if (currentStage == Stages.Ico4) {
558         cap = ico4Cap.sub(ico4Sold);
559       }
560 
561       require(_amount <= cap);
562 
563       if (currentStage == Stages.PrivateIco) privateIcoSold = privateIcoSold.add(_amount);
564       if (currentStage == Stages.PreIco) preIcoSold = preIcoSold.add(_amount);
565       if (currentStage == Stages.Ico1) ico1Sold = ico1Sold.add(_amount);
566       if (currentStage == Stages.Ico2) ico2Sold = ico2Sold.add(_amount);
567       if (currentStage == Stages.Ico3) ico3Sold = ico3Sold.add(_amount);
568       if (currentStage == Stages.Ico4) ico4Sold = ico4Sold.add(_amount);
569     } else {
570       return false;
571     }
572     require(token.transfer(_to, _amount));
573   }
574 
575     /// @dev Adds account addresses to whitelist.
576     /// @param _account address.
577     /// @param _phase 1 to add, 0 to remove.
578     function updateWhitelist (address _account, uint8 _phase) external isWhitelister returns (bool) {
579       require(_account != address(0));
580       require(_phase <= 1);
581       if (_phase == 1) whitelist[_account] = true;
582       else whitelist[_account] = false;
583       emit WhitelistUpdated(_account, _phase);
584       return true;
585     }
586 
587     /// @dev Adds new whitelister
588     /// @param _address new whitelister address.
589     function addWhitelister (address _address) public onlyOwner returns (bool) {
590       whitelisters[_address] = true;
591       return true;
592     }
593 
594     /// @dev Removes whitelister
595     /// @param _address address to remove.
596     function removeWhitelister (address _address) public onlyOwner returns (bool) {
597       whitelisters[_address] = false;
598       return true;
599     }
600 
601     function setUsdRate (uint256 _usdCents) public onlyOwner returns (bool) {
602       ethRate = _usdCents;
603       return true;
604     }
605 }