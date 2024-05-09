1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   ERC20 public token;
109 
110   // Address where funds are collected
111   address public wallet;
112 
113   // How many token units a buyer gets per wei.
114   // The rate is the conversion between wei and the smallest and indivisible token unit.
115   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116   // 1 wei will give you 1 unit, or 0.001 TOK.
117   uint256 public rate;
118 
119   // Amount of wei raised
120   uint256 public weiRaised;
121 
122   /**
123    * Event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(
130     address indexed purchaser,
131     address indexed beneficiary,
132     uint256 value,
133     uint256 amount
134   );
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177     _processPurchase(_beneficiary, tokens);
178     emit TokenPurchase(
179       msg.sender,
180       _beneficiary,
181       weiAmount,
182       tokens
183     );
184 
185     _updatePurchasingState(_beneficiary, weiAmount);
186 
187     _forwardFunds();
188     _postValidatePurchase(_beneficiary, weiAmount);
189   }
190 
191   // -----------------------------------------
192   // Internal interface (extensible)
193   // -----------------------------------------
194 
195   /**
196    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
197    * @param _beneficiary Address performing the token purchase
198    * @param _weiAmount Value in wei involved in the purchase
199    */
200   function _preValidatePurchase(
201     address _beneficiary,
202     uint256 _weiAmount
203   )
204     internal
205   {
206     require(_beneficiary != address(0));
207     require(_weiAmount != 0);
208   }
209 
210   /**
211    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _postValidatePurchase(
216     address _beneficiary,
217     uint256 _weiAmount
218   )
219     internal
220   {
221     // optional override
222   }
223 
224   /**
225    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
226    * @param _beneficiary Address performing the token purchase
227    * @param _tokenAmount Number of tokens to be emitted
228    */
229   function _deliverTokens(
230     address _beneficiary,
231     uint256 _tokenAmount
232   )
233     internal
234   {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(
244     address _beneficiary,
245     uint256 _tokenAmount
246   )
247     internal
248   {
249     _deliverTokens(_beneficiary, _tokenAmount);
250   }
251 
252   /**
253    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
254    * @param _beneficiary Address receiving the tokens
255    * @param _weiAmount Value in wei involved in the purchase
256    */
257   function _updatePurchasingState(
258     address _beneficiary,
259     uint256 _weiAmount
260   )
261     internal
262   {
263     // optional override
264   }
265 
266   /**
267    * @dev Override to extend the way in which ether is converted to tokens.
268    * @param _weiAmount Value in wei to be converted into tokens
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount)
272     internal view returns (uint256)
273   {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 }
284 
285 // File: contracts/DynamicRateCrowdsale.sol
286 
287 contract DynamicRateCrowdsale is Crowdsale {
288     using SafeMath for uint256;
289 
290     // 奖励汇率
291     uint256 public bonusRate;
292 
293     constructor(uint256 _bonusRate) public {
294         require(_bonusRate > 0);
295         bonusRate = _bonusRate;
296     }
297 
298     function getCurrentRate() public view returns (uint256) {
299         return rate.add(bonusRate);
300     }
301 
302     function _getTokenAmount(uint256 _weiAmount)
303         internal view returns (uint256)
304     {
305         uint256 currentRate = getCurrentRate();
306         return currentRate.mul(_weiAmount);
307     }
308 }
309 
310 // File: openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
311 
312 /**
313  * @title AllowanceCrowdsale
314  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
315  */
316 contract AllowanceCrowdsale is Crowdsale {
317   using SafeMath for uint256;
318 
319   address public tokenWallet;
320 
321   /**
322    * @dev Constructor, takes token wallet address.
323    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
324    */
325   constructor(address _tokenWallet) public {
326     require(_tokenWallet != address(0));
327     tokenWallet = _tokenWallet;
328   }
329 
330   /**
331    * @dev Checks the amount of tokens left in the allowance.
332    * @return Amount of tokens left in the allowance
333    */
334   function remainingTokens() public view returns (uint256) {
335     return token.allowance(tokenWallet, this);
336   }
337 
338   /**
339    * @dev Overrides parent behavior by transferring tokens from wallet.
340    * @param _beneficiary Token purchaser
341    * @param _tokenAmount Amount of tokens purchased
342    */
343   function _deliverTokens(
344     address _beneficiary,
345     uint256 _tokenAmount
346   )
347     internal
348   {
349     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
350   }
351 }
352 
353 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
354 
355 /**
356  * @title CappedCrowdsale
357  * @dev Crowdsale with a limit for total contributions.
358  */
359 contract CappedCrowdsale is Crowdsale {
360   using SafeMath for uint256;
361 
362   uint256 public cap;
363 
364   /**
365    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
366    * @param _cap Max amount of wei to be contributed
367    */
368   constructor(uint256 _cap) public {
369     require(_cap > 0);
370     cap = _cap;
371   }
372 
373   /**
374    * @dev Checks whether the cap has been reached.
375    * @return Whether the cap was reached
376    */
377   function capReached() public view returns (bool) {
378     return weiRaised >= cap;
379   }
380 
381   /**
382    * @dev Extend parent behavior requiring purchase to respect the funding cap.
383    * @param _beneficiary Token purchaser
384    * @param _weiAmount Amount of wei contributed
385    */
386   function _preValidatePurchase(
387     address _beneficiary,
388     uint256 _weiAmount
389   )
390     internal
391   {
392     super._preValidatePurchase(_beneficiary, _weiAmount);
393     require(weiRaised.add(_weiAmount) <= cap);
394   }
395 
396 }
397 
398 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
399 
400 /**
401  * @title TimedCrowdsale
402  * @dev Crowdsale accepting contributions only within a time frame.
403  */
404 contract TimedCrowdsale is Crowdsale {
405   using SafeMath for uint256;
406 
407   uint256 public openingTime;
408   uint256 public closingTime;
409 
410   /**
411    * @dev Reverts if not in crowdsale time range.
412    */
413   modifier onlyWhileOpen {
414     // solium-disable-next-line security/no-block-members
415     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
416     _;
417   }
418 
419   /**
420    * @dev Constructor, takes crowdsale opening and closing times.
421    * @param _openingTime Crowdsale opening time
422    * @param _closingTime Crowdsale closing time
423    */
424   constructor(uint256 _openingTime, uint256 _closingTime) public {
425     // solium-disable-next-line security/no-block-members
426     require(_openingTime >= block.timestamp);
427     require(_closingTime >= _openingTime);
428 
429     openingTime = _openingTime;
430     closingTime = _closingTime;
431   }
432 
433   /**
434    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
435    * @return Whether crowdsale period has elapsed
436    */
437   function hasClosed() public view returns (bool) {
438     // solium-disable-next-line security/no-block-members
439     return block.timestamp > closingTime;
440   }
441 
442   /**
443    * @dev Extend parent behavior requiring to be within contributing period
444    * @param _beneficiary Token purchaser
445    * @param _weiAmount Amount of wei contributed
446    */
447   function _preValidatePurchase(
448     address _beneficiary,
449     uint256 _weiAmount
450   )
451     internal
452     onlyWhileOpen
453   {
454     super._preValidatePurchase(_beneficiary, _weiAmount);
455   }
456 
457 }
458 
459 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
460 
461 /**
462  * @title Ownable
463  * @dev The Ownable contract has an owner address, and provides basic authorization control
464  * functions, this simplifies the implementation of "user permissions".
465  */
466 contract Ownable {
467   address public owner;
468 
469 
470   event OwnershipRenounced(address indexed previousOwner);
471   event OwnershipTransferred(
472     address indexed previousOwner,
473     address indexed newOwner
474   );
475 
476 
477   /**
478    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
479    * account.
480    */
481   constructor() public {
482     owner = msg.sender;
483   }
484 
485   /**
486    * @dev Throws if called by any account other than the owner.
487    */
488   modifier onlyOwner() {
489     require(msg.sender == owner);
490     _;
491   }
492 
493   /**
494    * @dev Allows the current owner to relinquish control of the contract.
495    */
496   function renounceOwnership() public onlyOwner {
497     emit OwnershipRenounced(owner);
498     owner = address(0);
499   }
500 
501   /**
502    * @dev Allows the current owner to transfer control of the contract to a newOwner.
503    * @param _newOwner The address to transfer ownership to.
504    */
505   function transferOwnership(address _newOwner) public onlyOwner {
506     _transferOwnership(_newOwner);
507   }
508 
509   /**
510    * @dev Transfers control of the contract to a newOwner.
511    * @param _newOwner The address to transfer ownership to.
512    */
513   function _transferOwnership(address _newOwner) internal {
514     require(_newOwner != address(0));
515     emit OwnershipTransferred(owner, _newOwner);
516     owner = _newOwner;
517   }
518 }
519 
520 // File: contracts/EoptCrowdsale.sol
521 
522 contract EoptCrowdsale is Crowdsale, CappedCrowdsale, AllowanceCrowdsale, DynamicRateCrowdsale, TimedCrowdsale, Ownable {
523     
524     constructor(
525         uint256 _rate, 
526         uint256 _bonusRate, 
527         address _wallet, 
528         ERC20 _token, 
529         uint256 _cap, 
530         address _tokenWallet,
531         uint256 _openingTime,
532         uint256 _closingTime
533     )
534         Crowdsale(_rate, _wallet, _token)
535         CappedCrowdsale(_cap)
536         AllowanceCrowdsale(_tokenWallet)
537         TimedCrowdsale(_openingTime, _closingTime)
538         DynamicRateCrowdsale(_bonusRate)
539         public
540     {   
541         
542     }
543 
544     // 购买事件
545     event Purchase(
546         address indexed purchaser,
547         address indexed beneficiary,
548         uint256 value,
549         uint256 amount,
550         uint256 weiRaised,
551         uint256 rate,
552         uint256 bonusRate,
553         uint256 cap
554     );
555 
556     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount)
557         internal
558     {
559         super._updatePurchasingState(_beneficiary, _weiAmount);
560         uint256 tokens = _getTokenAmount(_weiAmount);
561         emit Purchase(
562             msg.sender,
563             _beneficiary,
564             _weiAmount,
565             tokens,
566             weiRaised,
567             rate,
568             bonusRate,
569             cap
570         );
571     }
572 
573     // 设置汇率，1 ETH : N TOKEN
574     function setRate(uint256 _rate) onlyOwner public {
575         require(_rate > 0 && _rate < 1000000);
576         rate = _rate;
577     }
578 
579     // 设置奖励汇率，1 ETH : N TOKEN(bonus)
580     function setBonusRate(uint256 _bonusRate) onlyOwner public {
581         require(_bonusRate > 0 && _bonusRate < 1000000);
582         bonusRate = _bonusRate;
583     }
584 
585     // 设置众筹结束时间
586     function setClosingTime(uint256 _closingTime) onlyOwner public {
587         require(_closingTime >= block.timestamp);
588         require(_closingTime >= openingTime);
589         closingTime = _closingTime;
590     }
591 
592     // 设置众筹总量限额 0 < _cap < 50w ETH
593     function setCap(uint256 _cap) onlyOwner public {
594         require(_cap > 0 && _cap < 500000000000000000000000);
595         cap = _cap;
596     }
597 
598     // 设置EOPT的代币合约地址
599     function setToken(ERC20 _token) onlyOwner public {
600         require(_token != address(0));
601         token = _token;
602     }
603 
604     // 设置提供EOPT的钱包地址
605     function setTokenWallet(address _tokenWallet) onlyOwner public {
606         require(_tokenWallet != address(0));
607         tokenWallet = _tokenWallet;
608     }
609 
610     // 设置接收众筹ETH的钱包地址
611     function setWallet(address _wallet) onlyOwner public {
612         require(_wallet != address(0));
613         wallet = _wallet;
614     }
615 }