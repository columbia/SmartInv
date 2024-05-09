1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     require(newOwner != address(0));
67     OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) public constant returns (uint256);
81   function transfer(address to, uint256 value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 }
131 
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154 
155     uint256 _allowance = allowed[_from][msg.sender];
156 
157     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
158     // require (_value <= _allowance);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = _allowance.sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    */
199   function increaseApproval (address _spender, uint _addedValue)
200     returns (bool success) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   function decreaseApproval (address _spender, uint _subtractedValue)
207     returns (bool success) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 /**
221  * @title The MINDToken contract
222  * @dev The MINDToken Token contract
223  * @dev inherite from StandardToken and Ownable by Zeppelin
224  * @author Request.network
225  */
226 contract MINDToken is StandardToken, Ownable {
227     string  public  constant name = "MIND Token";
228     string  public  constant symbol = "MIND";
229     uint8    public  constant decimals = 18;
230 
231     uint    public  transferableStartTime;
232 
233     address public  tokenSaleContract;
234     address public  fullTokenWallet;
235 
236     function gettransferableStartTime() constant returns (uint){return now - transferableStartTime;}
237 
238     modifier onlyWhenTransferEnabled() 
239     {
240         if ( now < transferableStartTime ) {
241             require(msg.sender == tokenSaleContract || msg.sender == fullTokenWallet || msg.sender == owner);
242         }
243         _;
244     }
245 
246     modifier validDestination(address to) 
247     {
248         require(to != address(this));
249         _;
250     }
251 
252     modifier onlySaleContract()
253     {
254         require(msg.sender == tokenSaleContract);
255         _;
256     }
257 
258     function MINDToken(
259         uint tokenTotalAmount, 
260         uint _transferableStartTime, 
261         address _admin, 
262         address _fullTokenWallet) 
263     {
264         
265         // Mint all tokens. Then disable minting forever.
266         totalSupply = tokenTotalAmount * (10 ** uint256(decimals));
267 
268         balances[msg.sender] = totalSupply;
269         Transfer(address(0x0), msg.sender, totalSupply);
270 
271         transferableStartTime = _transferableStartTime;
272         tokenSaleContract = msg.sender;
273         fullTokenWallet = _fullTokenWallet;
274 
275         transferOwnership(_admin); // admin could drain tokens and eth that were sent here by mistake
276 
277     }
278 
279     /**
280      * @dev override transfer token for a specified address to add onlyWhenTransferEnabled and validDestination
281      * @param _to The address to transfer to.
282      * @param _value The amount to be transferred.
283      */
284     function transfer(address _to, uint _value)
285         public
286         validDestination(_to)
287         onlyWhenTransferEnabled
288         returns (bool) 
289     {
290         return super.transfer(_to, _value);
291     }
292 
293     /**
294      * @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
295      * @param _from The address to transfer from.
296      * @param _to The address to transfer to.
297      * @param _value The amount to be transferred.
298      */
299     function transferFrom(address _from, address _to, uint _value)
300         public
301         validDestination(_to)
302         onlyWhenTransferEnabled
303         returns (bool) 
304     {
305         return super.transferFrom(_from, _to, _value);
306     }
307 
308     event Burn(address indexed _burner, uint _value);
309 
310     /**
311      * @dev burn tokens
312      * @param _value The amount to be burned.
313      * @return always true (necessary in case of override)
314      */
315     function burn(uint _value) 
316         public
317         onlyWhenTransferEnabled
318         onlyOwner
319         returns (bool)
320     {
321         balances[msg.sender] = balances[msg.sender].sub(_value);
322         totalSupply = totalSupply.sub(_value);
323         Burn(msg.sender, _value);
324         Transfer(msg.sender, address(0x0), _value);
325         return true;
326     }
327 
328     /**
329      * @dev burn tokens in the behalf of someone
330      * @param _from The address of the owner of the token.
331      * @param _value The amount to be burned.
332      * @return always true (necessary in case of override)
333      */
334     function burnFrom(address _from, uint256 _value) 
335         public
336         onlyWhenTransferEnabled
337         onlyOwner
338         returns(bool) 
339     {
340         assert(transferFrom(_from, msg.sender, _value));
341         return burn(_value);
342     }
343 
344     /** 
345     * enable transfer earlier (only presale contract can enable the sale earlier)
346     */
347     function enableTransferEarlier ()
348         public
349         onlySaleContract
350     {
351         transferableStartTime = now + 3 days;
352     }
353 
354 
355     /**
356      * @dev transfer to owner any tokens send by mistake on this contracts
357      * @param token The address of the token to transfer.
358      * @param amount The amount to be transfered.
359      */
360     function emergencyERC20Drain(ERC20 token, uint amount )
361         public
362         onlyOwner 
363     {
364         token.transfer(owner, amount);
365     }
366 
367 }
368 
369 
370 /**
371  * @title StandardCrowdsale 
372  * @dev StandardCrowdsale is a base contract for managing a token crowdsale.
373  * Crowdsales have a start and end timestamps, where investors can make
374  * token purchases and the crowdsale will assign them tokens based
375  * on a token per ETH rate. Funds collected are forwarded to a wallet
376  * as they arrive.
377  * @dev from Crowdsale by Zepellin with small changes. Changes are commented with "Request Modification"
378  */
379 contract StandardCrowdsale {
380     using SafeMath for uint256;
381 
382     // The token being sold
383     StandardToken public token; // Request Modification : change to not mintable
384 
385     // start and end timestamps where investments are allowed (both inclusive)
386     uint256 public startTime;
387     uint256 public endTime;
388 
389     // address where funds are collected
390     address public wallet;
391 
392     // how many token units a buyer gets per wei
393     uint256 public rate;
394 
395     // amount of raised money in wei
396     uint256 public weiRaised;
397 
398     /**
399      * event for token purchase logging
400      * @param purchaser who paid for the tokens
401      * @param value weis paid for purchase
402      * @param amount amount of tokens purchased
403      */
404     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
405 
406     function StandardCrowdsale(
407         uint256 _startTime, 
408         uint256 _endTime, 
409         uint256 _rate, 
410         address _wallet) 
411     {
412         
413         require(_startTime >= now);
414         require(_endTime >= _startTime);
415         require(_rate > 0);
416         require(_wallet != 0x0);
417 
418         startTime = _startTime;
419         endTime = _endTime;
420         rate = _rate;
421         wallet = _wallet;
422         
423         token = createTokenContract(); // Request Modification : change to StandardToken + position
424     }
425 
426     // creates the token to be sold.
427     // Request Modification : change to StandardToken
428     // override this method to have crowdsale of a specific mintable token.
429     function createTokenContract() 
430         internal 
431         returns(StandardToken) 
432     {
433         return new StandardToken();
434     }
435 
436     // fallback function can be used to buy tokens
437     function () 
438        payable 
439     {
440         buyTokens();
441     }
442 
443     // low level token purchase function
444     // Request Modification : change to not mint but transfer from this contract
445     function buyTokens() 
446        public 
447        payable 
448     {
449         require(validPurchase());
450 
451         uint256 weiAmount = msg.value;
452 
453         // calculate token amount to be created
454         uint256 tokens = weiAmount.mul(rate);
455         tokens += getBonus(tokens);
456 
457         // update state
458         weiRaised = weiRaised.add(weiAmount);
459 
460         require(token.transfer(msg.sender, tokens)); // Request Modification : changed here - tranfer instead of mintable
461         TokenPurchase(msg.sender, weiAmount, tokens);
462 
463         forwardFunds();
464 
465         postBuyTokens();
466     }
467 
468     // Action after buying tokens
469     function postBuyTokens ()
470         internal
471     {
472     }
473 
474     // send ether to the fund collection wallet
475     // override to create custom fund forwarding mechanisms
476     function forwardFunds() 
477        internal 
478     {
479         wallet.transfer(msg.value);
480     }
481 
482     // @return true if the transaction can buy tokens
483     function validPurchase() 
484         internal 
485         returns(bool) 
486     {
487         bool withinPeriod = now >= startTime && now <= endTime;
488         bool nonZeroPurchase = msg.value != 0;
489         return withinPeriod && nonZeroPurchase;
490     }
491 
492     // @return true if crowdsale event has ended
493     function hasEnded() 
494         public 
495         constant 
496         returns(bool) 
497     {
498         return now > endTime;
499     }
500 
501     modifier onlyBeforeSale() {
502         require(now < startTime);
503         _;
504     }
505 
506     // Request Modification : Add check 24hours before token sale
507     modifier only24HBeforeSale() {
508         require(now < startTime.sub(1 days));
509         _;
510     }
511 
512     function getBonus(uint256 _tokens) constant returns (uint256 bonus) {
513         return 0;
514     }
515 }
516 
517 /**
518  * @title CappedCrowdsale
519  * @dev Extension of Crowdsale with a max amount of funds raised
520  */
521 contract CappedCrowdsale is StandardCrowdsale {
522   using SafeMath for uint256;
523 
524   uint256 public cap;
525 
526   function CappedCrowdsale(uint256 _cap) {
527     require(_cap > 0);
528     cap = _cap;
529   }
530 
531   // overriding Crowdsale#validPurchase to add extra cap logic
532   // @return true if investors can buy at the moment
533   // Request Modification : delete constant because needed in son contract
534   function validPurchase() internal returns (bool) {
535     bool withinCap = weiRaised.add(msg.value) <= cap;
536     return super.validPurchase() && withinCap;
537   }
538 
539   // overriding Crowdsale#hasEnded to add cap logic
540   // @return true if crowdsale event has ended
541   function hasEnded() public constant returns (bool) {
542     bool capReached = weiRaised >= cap;
543     return super.hasEnded() || capReached;
544   }
545 
546 }
547 
548 /**
549  * @title MINDTokenPreSale
550  * @dev 
551  * We add new features to a base crowdsale using multiple inheritance.
552  * We are using the following extensions:
553  * CappedCrowdsale - sets a max boundary for raised funds
554  *
555  * The code is based on the contracts of Open Zeppelin and we add our contracts : MINDTokenPreSale and the Request Token
556  *
557  * @author Request.network
558  */
559 contract MINDTokenPreSale is Ownable, CappedCrowdsale {
560     // hard cap of the token pre-sale in ether
561     uint private constant HARD_CAP_IN_WEI = 10000 ether;
562 
563     // Total of MIND Token supply
564     uint public constant TOTAL_MIND_TOKEN_SUPPLY = 50000000;
565 
566     // Token sale rate from ETH to MIND
567     uint private constant RATE_ETH_MIND = 1000;
568 
569     // Token initialy distributed for the team (15%)
570     address public constant TEAM_VESTING_WALLET = 0xb3F3D774C3575aB01bce9d9a9Fe92Aa41926a92e;
571     uint public constant TEAM_VESTING_AMOUNT = 7500000e18;
572 
573     // Token initialy distributed for the full token sale (20%)
574     address public constant FULL_TOKEN_WALLET = 0x8759A03B3BEB1aa1A7bA765792cF83CaAe4f28E9;
575     uint public constant FULL_TOKEN_AMOUNT = 20000000e18;
576 
577     // Token initialy distributed for the early foundation (15%)
578     // wallet use also to gather the ether of the token sale
579     address private constant MIND_FOUNDATION_WALLET = 0xDfD5e09bB845d39bd05be4664271e471FA8dA4E6;
580     uint public constant MIND_FOUNDATION_AMOUNT = 7500000e18;
581 
582     // PERIOD WHEN TOKEN IS NOT TRANSFERABLE AFTER THE SALE
583     uint public constant PERIOD_AFTERSALE_NOT_TRANSFERABLE_IN_SEC = 3 days;
584 
585     event PreSaleTokenSoldout();
586 
587     function MINDTokenPreSale(uint256 _startTime, uint256 _endTime)
588       CappedCrowdsale(HARD_CAP_IN_WEI)
589       StandardCrowdsale(_startTime, _endTime, RATE_ETH_MIND, MIND_FOUNDATION_WALLET)
590     {
591         
592         token.transfer(TEAM_VESTING_WALLET, TEAM_VESTING_AMOUNT);
593 
594         token.transfer(FULL_TOKEN_WALLET, FULL_TOKEN_AMOUNT);
595 
596         token.transfer(MIND_FOUNDATION_WALLET, MIND_FOUNDATION_AMOUNT);
597         
598     }
599 
600     /**
601      * @dev Create the MIND token (override createTokenContract of StandardCrowdsale)
602      * @return the StandardToken created
603      */
604     function createTokenContract () 
605       internal 
606       returns(StandardToken) 
607     {
608         return new MINDToken(TOTAL_MIND_TOKEN_SUPPLY, endTime.add(PERIOD_AFTERSALE_NOT_TRANSFERABLE_IN_SEC), MIND_FOUNDATION_WALLET, FULL_TOKEN_WALLET);
609     }
610 
611     /**
612       * @dev Get the bonus based on the buy time (override getBonus of StandardCrowdsale)
613       * @return the number of bonus token
614     */
615     function getBonus(uint256 _tokens) constant returns (uint256 bonus) {
616         require(_tokens != 0);
617         if (startTime <= now && now < startTime + 1 days) {
618             return _tokens.div(2);
619         } else if (startTime + 1 days <= now && now < startTime + 2 days ) {
620             return _tokens.div(4);
621         } else if (startTime + 2 days <= now && now < startTime + 3 days ) {
622             return _tokens.div(10);
623         }
624 
625         return 0;
626     }
627 
628     /**
629      * @dev Transfer the unsold tokens to the MIND Foundation multisign wallet 
630      * @dev Only for owner
631      * @return the StandardToken created
632      */
633     function drainRemainingToken () 
634       public
635       onlyOwner
636     {
637         require(hasEnded());
638         token.transfer(MIND_FOUNDATION_WALLET, token.balanceOf(this));
639     }
640 
641 
642     /**
643       * @dev Action after buying tokens: check if all sold out and enable transfer immediately
644       */
645     function postBuyTokens ()
646         internal
647     {
648         if ( weiRaised >= HARD_CAP_IN_WEI ) 
649         {
650             MINDToken mindToken = MINDToken (token);
651             mindToken.enableTransferEarlier();
652             PreSaleTokenSoldout();
653         }
654     }
655 }