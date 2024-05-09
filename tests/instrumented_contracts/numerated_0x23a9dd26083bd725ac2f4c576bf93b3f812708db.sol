1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   uint256 totalSupply_;
125 
126   /**
127   * @dev total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133 
134   /**
135   * @dev transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[msg.sender]);
142 
143     // SafeMath.sub will throw if there is not enough balance.
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     emit Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     uint256 _allowance = allowed[_from][msg.sender];
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = _allowance.sub(_value);
187     emit Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    */
223   function increaseApproval (address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 
253 /**
254  * @title The GainmersTOKEN contract
255  * @dev The GainmersTOKEN Token inherite from StandardToken and Ownable by Zeppelin
256  * @author Gainmers.Teamdev
257  */
258 contract GainmersTOKEN is StandardToken, Ownable {
259     string  public  constant name = "Gain Token";
260     string  public  constant symbol = "GMR";
261     uint8   public  constant decimals = 18;
262 
263     uint256 public  totalSupply;
264     uint    public  transferableStartTime;
265     address public  tokenSaleContract;
266    
267 
268     modifier onlyWhenTransferEnabled() 
269     {
270         if ( now < transferableStartTime ) {
271             require(msg.sender == tokenSaleContract || msg.sender == owner);
272         }
273         _;
274     }
275 
276     modifier validDestination(address to) 
277     {
278         require(to != address(this));
279         _;
280     }
281 
282     modifier onlySaleContract()
283     {
284         require(msg.sender == tokenSaleContract);
285         _;
286     }
287 
288     function GainmersTOKEN(
289         uint tokenTotalAmount, 
290         uint _transferableStartTime, 
291         address _admin) public 
292     {
293         
294         totalSupply = tokenTotalAmount * (10 ** uint256(decimals));
295 
296         balances[msg.sender] = totalSupply;
297         emit Transfer(address(0x0), msg.sender, totalSupply);
298 
299         transferableStartTime = _transferableStartTime;
300         tokenSaleContract = msg.sender;
301 
302         transferOwnership(_admin); 
303 
304     }
305 
306     /**
307      * @dev override transfer token for a specified address to add onlyWhenTransferEnabled and validDestination
308      * @param _to The address to transfer to.
309      * @param _value The amount to be transferred.
310      */
311     function transfer(address _to, uint _value)
312         public
313         validDestination(_to)
314         onlyWhenTransferEnabled
315         returns (bool) 
316     {
317         return super.transfer(_to, _value);
318     }
319 
320     /**
321      * @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
322      * @param _from The address to transfer from.
323      * @param _to The address to transfer to.
324      * @param _value The amount to be transferred.
325      */
326     function transferFrom(address _from, address _to, uint _value)
327         public
328         validDestination(_to)
329         onlyWhenTransferEnabled
330         returns (bool) 
331     {
332         return super.transferFrom(_from, _to, _value);
333     }
334 
335     event Burn(address indexed _burner, uint _value);
336 
337     /**
338      * @dev burn tokens
339      * @param _value The amount to be burned.
340      * @return always true (necessary in case of override)
341      */
342     function burn(uint _value) 
343         public
344         onlyWhenTransferEnabled
345         onlyOwner
346         returns (bool)
347     {
348         balances[msg.sender] = balances[msg.sender].sub(_value);
349         totalSupply = totalSupply.sub(_value);
350         emit Burn(msg.sender, _value);
351         emit Transfer(msg.sender, address(0x0), _value);
352         return true;
353     }
354 
355     /**
356      * @dev burn tokens in the behalf of someone
357      * @param _from The address of the owner of the token.
358      * @param _value The amount to be burned.
359      * @return always true (necessary in case of override)
360      */
361     function burnFrom(address _from, uint256 _value) 
362         public
363         onlyWhenTransferEnabled
364         onlyOwner
365         returns(bool) 
366     {
367         assert(transferFrom(_from, msg.sender, _value));
368         return burn(_value);
369     }
370 
371     /** 
372     *If the event SaleSoldout is called this function enables earlier tokens transfer
373     */
374     function enableTransferEarlier ()
375         public
376         onlySaleContract
377     {
378         transferableStartTime = now + 2 days;
379     }
380 
381 
382     /**
383      * @dev transfer to owner any tokens send by mistake on this contracts
384      * @param token The address of the token to transfer.
385      * @param amount The amount to be transfered.
386      */
387     function emergencyERC20Drain(ERC20 token, uint amount )
388         public
389         onlyOwner 
390     {
391         token.transfer(owner, amount);
392     }
393 
394 }
395 
396 /**
397  * @title ModifiedCrowdsale
398  * @dev ModifiedCrowdsale is based in Crowdsale. Crowdsale is a base contract for managing a token crowdsale,
399  * allowing investors to purchase tokens with ether. This contract implements
400  * such functionality in its most fundamental form and can be extended to provide additional
401  * functionality and/or custom behavior.
402  * The external interface represents the basic interface for purchasing tokens, and conform
403  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
404  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
405  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
406  * behavior.
407  */
408  
409 contract ModifiedCrowdsale {
410     using SafeMath for uint256;
411 
412     // The token being sold
413     StandardToken public token; 
414 
415     //Start and end timestamps where investments are allowed 
416     uint256 public startTime;
417     uint256 public endTime;
418 
419      // how many token units a buyer gets per wei
420     uint256 public rate;
421 
422     // address where crowdsale funds are collected
423     address public wallet;
424 
425     // amount of raised money in wei
426     uint256 public weiRaised;
427 
428     /**
429      * event for token purchase logging
430      * @param purchaser who paid for the tokens
431      * @param value weis paid for purchase
432      * @param amount amount of tokens purchased
433      */
434     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
435     //Event trigger if the Crowdsale reaches the hardcap
436      event TokenSaleSoldOut();
437     /**
438     * @param _startTime StartTime for the token crowdsale
439     * @param _endTime EndTime for the token crowdsale     
440     * @param _rate Number of token units a buyer gets per wei
441     * @param _wallet Address where collected funds will be forwarded to
442     */
443     function ModifiedCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public  {
444         
445         require(_startTime >= now);
446         require(_endTime >= _startTime);
447         require(_rate > 0);
448         require(_wallet != 0x0);
449 
450         startTime = _startTime;
451         endTime = _endTime;
452         rate = _rate;
453         wallet = _wallet;
454         
455         token = createTokenContract(); 
456     }
457 
458     // creates the token to be sold.
459     // override this method to have crowdsale of a specific mintable token.
460     function createTokenContract() 
461         internal 
462         returns(StandardToken) 
463     {
464         return new StandardToken();
465     }
466 
467     /**
468     * @dev fallback function ***DO NOT OVERRIDE***
469     */
470     function () external payable {
471         buyTokens(msg.sender);
472     }
473 
474     // low level token purchase function
475     function buyTokens(address _beneficiary) public   payable {
476         require(validPurchase());
477         uint256 weiAmount = msg.value;
478 
479         // calculate token amount to be created
480         uint256 tokens = weiAmount.mul(rate);
481         tokens += getBonus(tokens);
482 
483         // update state
484         weiRaised = weiRaised.add(weiAmount);
485 
486         require(token.transfer(_beneficiary, tokens)); 
487         emit TokenPurchase(_beneficiary, weiAmount, tokens);
488 
489         forwardFunds();
490 
491         postBuyTokens();
492     }
493 
494     // Action after buying tokens
495     function postBuyTokens () internal  
496     {emit TokenSaleSoldOut();
497     }
498 
499     // send ether to the fund collection wallet
500     // override to create custom fund forwarding mechanisms
501     function forwardFunds() 
502        internal 
503     {
504         wallet.transfer(msg.value);
505     }
506 
507     // @return true if the transaction can buy tokens
508     function validPurchase()  internal  view
509         returns(bool) 
510     {
511         bool withinPeriod = now >= startTime && now <= endTime;
512         bool nonZeroPurchase = msg.value != 0;
513         bool nonInvalidAccount = msg.sender != 0;
514         return withinPeriod && nonZeroPurchase && nonInvalidAccount;
515     }
516 
517     // @return true if crowdsale event has ended
518     function hasEnded() 
519         public 
520         constant 
521         returns(bool) 
522     {
523         return now > endTime;
524     }
525 
526 
527     /**
528       * @dev Get the bonus based on the buy time 
529       * @return the number of bonus token
530     */
531     function getBonus(uint256 _tokens) internal view returns (uint256 bonus) {
532         require(_tokens != 0);
533         if (startTime <= now && now < startTime + 7 days ) {
534             return _tokens.div(5);
535         } else if (startTime + 7 days <= now && now < startTime + 14 days ) {
536             return _tokens.div(10);
537         } else if (startTime + 14 days <= now && now < startTime + 21 days ) {
538             return _tokens.div(20);
539         }
540 
541         return 0;
542     }
543 }
544 
545 /**
546  * @title CappedCrowdsale
547  * @dev Extension of Crowdsale with a max amount of funds raised
548  */
549 contract CappedCrowdsale is ModifiedCrowdsale {
550   using SafeMath for uint256;
551 
552   uint256 public cap;
553 
554   function CappedCrowdsale(uint256 _cap) public {
555     require(_cap > 0);
556     cap = _cap;
557   }
558 
559   // overriding Crowdsale#validPurchase to add extra cap logic
560   // @return true if investors can buy at the moment
561   // Request Modification : delete constant because needed in son contract
562   function validPurchase() internal view returns (bool) {
563     bool withinCap = weiRaised.add(msg.value) <= cap;
564     return super.validPurchase() && withinCap;
565   }
566 
567   // overriding Crowdsale#hasEnded to add cap logic
568   // @return true if crowdsale event has ended
569   function hasEnded() public constant returns (bool) {
570     bool capReached = weiRaised >= cap;
571     return super.hasEnded() || capReached;
572   }
573 
574 }
575 
576 
577 
578 /**
579  * @title GainmersSALE
580  * @dev 
581  * GainmersSALE inherits form the Ownable and CappedCrowdsale,
582  *
583  * @author Gainmers.Teamdev
584  */
585 contract GainmersSALE is Ownable, CappedCrowdsale {
586     
587     //Total supply of the GainmersTOKEN
588     uint public constant TotalTOkenSupply = 100000000;
589 
590     //Hardcap of the ICO in wei
591     uint private constant Hardcap = 30000 ether;
592 
593     //Exchange rate EHT/ GMR token
594     uint private constant RateExchange = 1660;
595 
596    
597 
598     /**Initial distribution of the Tokens*/
599 
600     // Token initialy distributed for the team management and developer incentives (10%)
601     address public constant TeamWallet = 0x6009267Cb183AEC8842cb1d020410f172dD2d50F;
602     uint public constant TeamWalletAmount = 10000000e18; 
603     
604      // Token initialy distributed for the Advisors and sponsors (10%)
605     address public constant TeamAdvisorsWallet = 0x3925848aF4388a3c10cd73F3529159de5f0C686c;
606     uint public constant AdvisorsAmount = 10000000e18;
607     
608      // Token initially distribuded for future invesment rounds and prizes in the plataform (15%)
609     address public constant 
610     ReinvestWallet = 0x1cc1Bf6D3100Ce4EE3a398bEdE33A7e3a42225D7;
611     uint public constant ReinvestAmount = 15000000e18;
612 
613      // Token initialy distributed for  Bounty Campaing (5%)
614     address public constant BountyCampaingWallet = 0xD36FcA0DAd25554922d860dA18Ac47e4F9513672
615     ;
616     uint public constant BountyAmount = 5000000e18;
617 
618     
619 
620     //Period after the sale for the token to be transferable
621     uint public constant AfterSaleTransferableTime = 2 days;
622 
623 
624     function GainmersSALE(uint256 _startTime, uint256 _endTime) public
625       CappedCrowdsale(Hardcap)
626       ModifiedCrowdsale(_startTime,
627                          _endTime, 
628                          RateExchange, 
629                          TeamWallet)
630     {
631         
632         token.transfer(TeamWallet, TeamWalletAmount);
633         token.transfer(TeamAdvisorsWallet, AdvisorsAmount);
634         token.transfer(ReinvestWallet, ReinvestAmount);
635         token.transfer(BountyCampaingWallet, BountyAmount);
636 
637 
638         
639     }
640 
641     /**
642      * @dev Handles the creation of the GainmersTOKEN
643      * @return the  StandardToken 
644      */
645     function createTokenContract () 
646       internal 
647       returns(StandardToken) 
648     {
649         return new GainmersTOKEN(TotalTOkenSupply,
650          endTime.add(AfterSaleTransferableTime),
651         TeamWallet);
652     }
653 
654 
655 
656     /**
657      * @dev Drain the remaining tokens of the crowdsale to the TeamWallet account
658      * @dev Only for owner
659      * @return the StandardToken 
660      */
661     function drainRemainingToken () 
662       public
663       onlyOwner
664     {
665         require(hasEnded());
666         token.transfer(TeamWallet, token.balanceOf(this));
667     }
668 
669 
670     /** 
671     * @dev Allows the early transfer of tokens if the ICO end before the end date
672     */
673 
674     function postBuyTokens ()  internal {
675         if ( weiRaised >= Hardcap ) {  
676             GainmersTOKEN gainmersToken = GainmersTOKEN (token);
677             gainmersToken.enableTransferEarlier();
678             emit TokenSaleSoldOut();
679         }
680     }
681 }