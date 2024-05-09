1 pragma solidity 0.4.19;
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
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40   
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61     
62   address public owner;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() public {
72     owner = msg.sender;
73   }
74 
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 }
95 
96 
97 
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133     
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   uint256 totalSupply_;
139   
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147   
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 }
174 
175 
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     Transfer(_from, _to, _value);
205     return true;
206   }
207 
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    *
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param _spender The address which will spend the funds.
217    * @param _value The amount of tokens to be spent.
218    */
219   function approve(address _spender, uint256 _value) public returns (bool) {
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224   
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(address _owner, address _spender) public view returns (uint256) {
233     return allowed[_owner][_spender];
234   }
235   
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _addedValue The amount of tokens to increase the allowance by.
246    */
247   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To decrement
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _subtractedValue The amount of tokens to decrease the allowance by.
263    */
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 }
275 
276 
277 
278 
279 /**
280  * @title Pausable
281  * @dev Base contract which allows children to implement an emergency stop mechanism.
282  */
283 contract Pausable is Ownable {
284     
285   event Pause();
286   event Unpause();
287 
288   bool public paused = true;
289 
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is not paused
293    * or when the owner is invoking the function.
294    */
295   modifier whenNotPaused() {
296     require(!paused || msg.sender == owner);
297     _;
298   }
299   
300 
301   /**
302    * @dev Modifier to make a function callable only when the contract is paused.
303    */
304   modifier whenPaused() {
305     require(paused);
306     _;
307   }
308 
309 
310   /**
311    * @dev called by the owner to pause, triggers stopped state
312    */
313   function pause() onlyOwner whenNotPaused public {
314     paused = true;
315     Pause();
316   }
317   
318 
319   /**
320    * @dev called by the owner to unpause, returns to normal state
321    */
322   function unpause() onlyOwner whenPaused public {
323     paused = false;
324     Unpause();
325   }
326 }
327 
328 
329 
330 
331 /**
332  * @title Pausable token
333  * @dev StandardToken modified with pausable transfers.
334  **/
335 contract PausableToken is StandardToken, Pausable {
336 
337   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
338     return super.transfer(_to, _value);
339   }
340 
341 
342   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
343     return super.transferFrom(_from, _to, _value);
344   }
345   
346 
347   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
348     return super.approve(_spender, _value);
349   }
350   
351 
352   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
353     return super.increaseApproval(_spender, _addedValue);
354   }
355   
356 
357   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
358     return super.decreaseApproval(_spender, _subtractedValue);
359   }
360 }
361 
362 
363 
364 
365 contract LMDA is PausableToken {
366     
367     string public  name;
368     string public symbol;
369     uint8 public decimals;
370     uint256 public totalSupply;
371 
372 
373     /**
374      * Constructor initializes the name, symbol, decimals and total 
375      * supply of the token. The owner of the contract which is initially 
376      * the ICO contract will receive the entire total supply. 
377      * */
378     function LMDA() public {
379         name = "LaMonedaCoin";
380         symbol = "LMDA";
381         decimals = 18;
382         totalSupply = 500000000e18;
383         
384         balances[owner] = totalSupply;
385         Transfer(address(this), owner, totalSupply);
386     }
387 }
388 
389 
390 
391 
392 contract ICO is Ownable {
393     
394     using SafeMath for uint256;
395     
396     event AidropInvoked();
397     event MainSaleActivated();
398     event TokenPurchased(address recipient, uint256 tokens);
399     event DeadlineExtended(uint256 daysExtended);
400     event DeadlineShortened(uint256 daysShortenedBy);
401     event OffChainPurchaseMade(address recipient, uint256 tokensBought);
402     event TokenPriceChanged(string stage, uint256 newTokenPrice);
403     event ExchangeRateChanged(string stage, uint256 newRate);
404     event BonusChanged(string stage, uint256 newBonus);
405     event TokensWithdrawn(address to, uint256 LMDA); 
406     event TokensUnpaused();
407     event ICOPaused(uint256 timeStamp);
408     event ICOUnpaused(uint256 timeStamp);  
409     
410     address public receiverOne;
411     address public receiverTwo;
412     address public receiverThree;
413     address public reserveAddress;
414     address public teamAddress;
415     
416     uint256 public endTime;
417     uint256 public tokenPriceForPreICO;
418     uint256 public rateForPreICO;
419     uint256 public tokenPriceForMainICO;
420     uint256 public rateForMainICO;
421     uint256 public tokenCapForPreICO;
422     uint256 public tokenCapForMainICO;
423     uint256 public bonusForPreICO;
424     uint256 public bonusForMainICO;
425     uint256 public tokensSold;
426     uint256 public timePaused;
427     bool public icoPaused;
428     
429     
430     enum StateOfICO {
431         PRE,
432         MAIN
433     }
434     
435     StateOfICO public stateOfICO;
436     
437     LMDA public lmda;
438 
439     mapping (address => uint256) public investmentOf;
440     
441     
442     /**
443      * Functions with this modifier can only be called when the ICO 
444      * is not paused.
445      * */
446     modifier whenNotPaused {
447         require(!icoPaused);
448         _;
449     }
450     
451     
452     /**
453      * Constructor functions creates a new instance of the LMDA token 
454      * and automatically distributes tokens to the reserve and team 
455      * addresses. The constructor also initializes all of the state 
456      * variables of the ICO contract. 
457      * */
458     function ICO() public {
459         lmda = new LMDA();
460         receiverOne = 0x43adebFC525FEcf9b2E91a4931E4a003a1F0d959;   //Pre ICO
461         receiverTwo = 0xB447292181296B8c7F421F1182be20640dc8Bb05;   //Pre ICO
462         receiverThree = 0x3f68b06E7C0E87828647Dbba0b5beAef3822b7Db; //Main ICO
463         reserveAddress = 0x7d05F660124B641b74b146E9aDA60D7D836dcCf5;
464         teamAddress = 0xAD942E5085Af6a7A4C31f17ac687F8d5d7C0225C;
465         lmda.transfer(reserveAddress, 90000000e18);
466         lmda.transfer(teamAddress, 35500000e18);
467         stateOfICO = StateOfICO.PRE;
468         endTime = now.add(21 days);
469         tokenPriceForPreICO = 0.00005 ether;
470         rateForPreICO = 20000;
471         tokenPriceForMainICO = 0.00007 ether;
472         rateForMainICO = 14285; // should be 14,285.7143 
473         tokenCapForPreICO = 144000000e18;
474         tokenCapForMainICO = 374500000e18; 
475         bonusForPreICO = 20;
476         bonusForMainICO = 15;
477         tokensSold = 0;
478         icoPaused= false;
479     }
480     
481     
482     /**
483      * This function allows the owner of the contract to airdrop LMDA tokens 
484      * to a list of addresses, so long as a list of values is also provided.
485      * 
486      * @param _addrs The list of recipient addresses
487      * @param _values The number of tokens each address will receive 
488      * */
489     function airdrop(address[] _addrs, uint256[] _values) public onlyOwner {
490         require(lmda.balanceOf(address(this)) >= getSumOfValues(_values));
491         require(_addrs.length <= 100 && _addrs.length == _values.length);
492         for(uint i = 0; i < _addrs.length; i++) {
493             lmda.transfer(_addrs[i], _values[i]);
494         }
495         AidropInvoked();
496     }
497     
498     
499     /**
500      * Function is called internally by the airdrop() function to ensure that 
501      * there are enough tokens remaining to execute the airdrop. 
502      * 
503      * @param _values The list of values representing the tokens to be sent
504      * @return Returns the sum of all the values
505      * */
506     function getSumOfValues(uint256[] _values) internal pure returns(uint256 sum) {
507         sum = 0;
508         for(uint i = 0; i < _values.length; i++) {
509             sum = sum.add(_values[i]);
510         }
511     }
512     
513     
514     /**
515      * Function allows the owner to activate the main sale.
516      * */
517     function activateMainSale() public onlyOwner whenNotPaused {
518         require(now >= endTime || tokensSold >= tokenCapForPreICO);
519         stateOfICO = StateOfICO.MAIN;
520         endTime = now.add(49 days);
521         MainSaleActivated();
522     }
523 
524 
525     /**
526      * Fallback function invokes the buyToknes() method when ETH is recieved 
527      * to enable the automatic distribution of tokens to investors.
528      * */
529     function() public payable {
530         buyTokens(msg.sender);
531     }
532     
533     
534     /**
535      * Allows investors to buy tokens for themselves or others by explicitly 
536      * invoking the function using the ABI / JSON Interface of the contract.
537      * 
538      * @param _addr The address of the recipient
539      * */
540     function buyTokens(address _addr) public payable whenNotPaused {
541         require(now <= endTime && _addr != 0x0);
542         require(lmda.balanceOf(address(this)) > 0);
543         if(stateOfICO == StateOfICO.PRE && tokensSold >= tokenCapForPreICO) {
544             revert();
545         } else if(stateOfICO == StateOfICO.MAIN && tokensSold >= tokenCapForMainICO) {
546             revert();
547         }
548         uint256 toTransfer = msg.value.mul(getRate().mul(getBonus())).div(100).add(getRate());
549         lmda.transfer(_addr, toTransfer);
550         tokensSold = tokensSold.add(toTransfer);
551         investmentOf[msg.sender] = investmentOf[msg.sender].add(msg.value);
552         TokenPurchased(_addr, toTransfer);
553         forwardFunds();
554     }
555     
556     
557     /**
558      * Allows the owner to send tokens to investors who paid with other currencies.
559      * 
560      * @param _recipient The address of the receiver 
561      * @param _value The total amount of tokens to be sent
562      * */
563     function processOffChainPurchase(address _recipient, uint256 _value) public onlyOwner {
564         require(lmda.balanceOf(address(this)) >= _value);
565         require(_value > 0 && _recipient != 0x0);
566         lmda.transfer(_recipient, _value);
567         tokensSold = tokensSold.add(_value);
568         OffChainPurchaseMade(_recipient, _value);
569     }
570     
571     
572     /**
573      * Function is called internally by the buyTokens() function in order to send 
574      * ETH to owners of the ICO automatically. 
575      * */
576     function forwardFunds() internal {
577         if(stateOfICO == StateOfICO.PRE) {
578             receiverOne.transfer(msg.value.div(2));
579             receiverTwo.transfer(msg.value.div(2));
580         } else {
581             receiverThree.transfer(msg.value);
582         }
583     }
584     
585     
586     /**
587      * Allows the owner to extend the deadline of the current ICO phase.
588      * 
589      * @param _daysToExtend The number of days to extend the deadline by.
590      * */
591     function extendDeadline(uint256 _daysToExtend) public onlyOwner {
592         endTime = endTime.add(_daysToExtend.mul(1 days));
593         DeadlineExtended(_daysToExtend);
594     }
595     
596     
597     /**
598      * Allows the owner to shorten the deadline of the current ICO phase.
599      * 
600      * @param _daysToShortenBy The number of days to shorten the deadline by.
601      * */
602     function shortenDeadline(uint256 _daysToShortenBy) public onlyOwner {
603         if(now.sub(_daysToShortenBy.mul(1 days)) < endTime) {
604             endTime = now;
605         }
606         endTime = endTime.sub(_daysToShortenBy.mul(1 days));
607         DeadlineShortened(_daysToShortenBy);
608     }
609     
610     
611     /**
612      * Allows the owner to change the token price of the current phase. 
613      * This function will automatically calculate the new exchange rate. 
614      * 
615      * @param _newTokenPrice The new price of the token.
616      * */
617     function changeTokenPrice(uint256 _newTokenPrice) public onlyOwner {
618         require(_newTokenPrice > 0);
619         if(stateOfICO == StateOfICO.PRE) {
620             if(tokenPriceForPreICO == _newTokenPrice) { revert(); } 
621             tokenPriceForPreICO = _newTokenPrice;
622             rateForPreICO = uint256(1e18).div(tokenPriceForPreICO);
623             TokenPriceChanged("Pre ICO", _newTokenPrice);
624         } else {
625             if(tokenPriceForMainICO == _newTokenPrice) { revert(); } 
626             tokenPriceForMainICO = _newTokenPrice;
627             rateForMainICO = uint256(1e18).div(tokenPriceForMainICO);
628             TokenPriceChanged("Main ICO", _newTokenPrice);
629         }
630     }
631     
632     
633     /**
634      * Allows the owner to change the exchange rate of the current phase.
635      * This function will automatically calculate the new token price. 
636      * 
637      * @param _newRate The new exchange rate.
638      * */
639     function changeRateOfToken(uint256 _newRate) public onlyOwner {
640         require(_newRate > 0);
641         if(stateOfICO == StateOfICO.PRE) {
642             if(rateForPreICO == _newRate) { revert(); }
643             rateForPreICO = _newRate;
644             tokenPriceForPreICO = uint256(1e18).div(rateForPreICO);
645             ExchangeRateChanged("Pre ICO", _newRate);
646         } else {
647             if(rateForMainICO == _newRate) { revert(); }
648             rateForMainICO = _newRate;
649             rateForMainICO = uint256(1e18).div(rateForMainICO);
650             ExchangeRateChanged("Main ICO", _newRate);
651         }
652     }
653     
654     
655     /**
656      * Allows the owner to change the bonus of the current phase.
657      * 
658      * @param _newBonus The new bonus percentage.
659      * */
660     function changeBonus(uint256 _newBonus) public onlyOwner {
661         if(stateOfICO == StateOfICO.PRE) {
662             if(bonusForPreICO == _newBonus) { revert(); }
663             bonusForPreICO = _newBonus;
664             BonusChanged("Pre ICO", _newBonus);
665         } else {
666             if(bonusForMainICO == _newBonus) { revert(); }
667             bonusForMainICO = _newBonus;
668             BonusChanged("Main ICO", _newBonus);
669         }
670     }
671     
672     
673     /**
674      * Allows the owner to withdraw all unsold tokens to his wallet. 
675      * */
676     function withdrawUnsoldTokens() public onlyOwner {
677         TokensWithdrawn(owner, lmda.balanceOf(address(this)));
678         lmda.transfer(owner, lmda.balanceOf(address(this)));
679     }
680     
681     
682     /**
683      * Allows the owner to unpause the LMDA token.
684      * */
685     function unpauseToken() public onlyOwner {
686         TokensUnpaused();
687         lmda.unpause();
688     }
689     
690     
691     /**
692      * Allows the owner to claim back ownership of the LMDA token contract.
693      * */
694     function transferTokenOwnership() public onlyOwner {
695         lmda.transferOwnership(owner);
696     }
697     
698     
699     /**
700      * Allows the owner to pause the ICO.
701      * */
702     function pauseICO() public onlyOwner whenNotPaused {
703         require(now < endTime);
704         timePaused = now;
705         icoPaused = true;
706         ICOPaused(now);
707     }
708     
709   
710     /**
711      * Allows the owner to unpause the ICO.
712      * */
713     function unpauseICO() public onlyOwner {
714         endTime = endTime.add(now.sub(timePaused));
715         timePaused = 0;
716         ICOUnpaused(now);
717     }
718     
719     
720     /**
721      * @return The total amount of tokens that have been sold.
722      * */
723     function getTokensSold() public view returns(uint256 _tokensSold) {
724         _tokensSold = tokensSold;
725     }
726     
727     
728     /**
729      * @return The current bonuse percentage.
730      * */
731     function getBonus() public view returns(uint256 _bonus) {
732         if(stateOfICO == StateOfICO.PRE) { 
733             _bonus = bonusForPreICO;
734         } else {
735             _bonus = bonusForMainICO;
736         }
737     }
738     
739     
740     /**
741      * @return The current exchange rate.
742      * */
743     function getRate() public view returns(uint256 _exchangeRate) {
744         if(stateOfICO == StateOfICO.PRE) {
745             _exchangeRate = rateForPreICO;
746         } else {
747             _exchangeRate = rateForMainICO;
748         }
749     }
750     
751     
752     /**
753      * @return The current token price. 
754      * */
755     function getTokenPrice() public view returns(uint256 _tokenPrice) {
756         if(stateOfICO == StateOfICO.PRE) {
757             _tokenPrice = tokenPriceForPreICO;
758         } else {
759             _tokenPrice = tokenPriceForMainICO;
760         }
761     }
762 }