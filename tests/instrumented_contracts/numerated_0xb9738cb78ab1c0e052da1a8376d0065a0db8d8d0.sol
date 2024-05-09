1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114 
115     // SafeMath.sub will throw if there is not enough balance.
116     balances[msg.sender] = balances[msg.sender].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     Transfer(msg.sender, _to, _value);
119     return true;
120   }
121 
122   /**
123   * @dev Gets the balance of the specified address.
124   * @param _owner The address to query the the balance of.
125   * @return An uint256 representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) public constant returns (uint256 balance) {
128     return balances[_owner];
129   }
130 
131 }
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
221  * @title StandardCrowdsale 
222  * @dev StandardCrowdsale is a base contract for managing a token crowdsale.
223  * Crowdsales have a start and end timestamps, where investors can make
224  * token purchases and the crowdsale will assign them tokens based
225  * on a token per ETH rate. Funds collected are forwarded to a wallet
226  * as they arrive.
227  */
228 contract StandardCrowdsale {
229     using SafeMath for uint256;
230 
231     // The token being sold
232     StandardToken public token; 
233 
234     // start and end timestamps where investments are allowed (both inclusive)
235     uint256 public startTime;
236     uint256 public endTime;
237 
238     // address where funds are collected
239     address public wallet;
240 
241     // how many token units a buyer gets per wei
242     uint256 public rate;
243 
244     // amount of raised money in wei
245     uint256 public weiRaised;
246 
247     /**
248      * event for token purchase logging
249      * @param purchaser who paid for the tokens
250      * @param value weis paid for purchase
251      * @param amount amount of tokens purchased
252      */
253     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
254 
255     function StandardCrowdsale(
256         uint256 _startTime, 
257         uint256 _endTime, 
258         uint256 _rate, 
259         address _wallet) 
260     {
261         require(_startTime >= now);
262         require(_endTime >= _startTime);
263         require(_rate > 0);
264         require(_wallet != 0x0);
265 
266         startTime = _startTime;
267         endTime = _endTime;
268         rate = _rate;
269         wallet = _wallet;
270         
271         token = createTokenContract(); 
272     }
273 
274     // creates the token to be sold.
275     // override this method to have crowdsale of a specific mintable token.
276     function createTokenContract() 
277         internal 
278         returns(StandardToken) 
279     {
280         return new StandardToken();
281     }
282 
283     // fallback function can be used to buy tokens
284     function () 
285        payable 
286     {
287         buyTokens();
288     }
289 
290     // low level token purchase function
291     function buyTokens() 
292        public 
293        payable 
294     {
295         require(validPurchase());
296 
297         uint256 weiAmount = msg.value;
298 
299         // calculate token amount to be created
300         uint256 tokens = weiAmount.mul(rate);
301         tokens += getBonus(tokens);
302 
303         // update state
304         weiRaised = weiRaised.add(weiAmount);
305 
306         require(token.transfer(msg.sender, tokens)); 
307         TokenPurchase(msg.sender, weiAmount, tokens);
308 
309         forwardFunds();
310 
311         postBuyTokens();
312     }
313 
314     // Action after buying tokens
315     function postBuyTokens ()
316         internal
317     {
318     }
319 
320     // send ether to the fund collection wallet
321     // override to create custom fund forwarding mechanisms
322     function forwardFunds() 
323        internal 
324     {
325         wallet.transfer(msg.value);
326     }
327 
328     // @return true if the transaction can buy tokens
329     function validPurchase() 
330         internal 
331         returns(bool) 
332     {
333         bool withinPeriod = now >= startTime && now <= endTime;
334         bool nonZeroPurchase = msg.value != 0;
335         return withinPeriod && nonZeroPurchase;
336     }
337 
338     // @return true if crowdsale event has ended
339     function hasEnded() 
340         public 
341         constant 
342         returns(bool) 
343     {
344         return now > endTime;
345     }
346 
347     modifier onlyBeforeSale() {
348         require(now < startTime);
349         _;
350     }
351 
352     modifier only24HBeforeSale() {
353         require(now < startTime.sub(1 days));
354         _;
355     }
356 
357     function getBonus(uint256 _tokens) constant returns (uint256 bonus) {
358         return 0;
359     }
360 }
361 
362 /**
363  * @title CappedCrowdsale
364  * @dev Extension of Crowdsale with a max amount of funds raised
365  */
366 contract CappedCrowdsale is StandardCrowdsale {
367   using SafeMath for uint256;
368 
369   uint256 public cap;
370 
371   function CappedCrowdsale(uint256 _cap) {
372     require(_cap > 0);
373     cap = _cap;
374   }
375 
376   // overriding Crowdsale#validPurchase to add extra cap logic
377   // @return true if investors can buy at the moment
378   function validPurchase() internal returns (bool) {
379     bool withinCap = weiRaised.add(msg.value) <= cap;
380     return super.validPurchase() && withinCap;
381   }
382 
383   // overriding Crowdsale#hasEnded to add cap logic
384   // @return true if crowdsale event has ended
385   function hasEnded() public constant returns (bool) {
386     bool capReached = weiRaised >= cap;
387     return super.hasEnded() || capReached;
388   }
389 
390 }
391 
392 /**
393  * @title The MINDToken contract
394  * @dev The MINDToken Token contract
395  * @dev inherite from StandardToken and Ownable by Zeppelin
396  */
397 contract MINDToken is StandardToken, Ownable {
398     string  public  constant name = "MIND Token";
399     string  public  constant symbol = "MIND";
400     uint8    public  constant decimals = 18;
401 
402     uint    public  transferableStartTime;
403 
404     address public  tokenSaleContract;
405     address public  fullTokenWallet;
406 
407     function gettransferableStartTime() constant returns (uint){return now - transferableStartTime;}
408 
409     modifier onlyWhenTransferEnabled() 
410     {
411         if ( now < transferableStartTime ) {
412             require(msg.sender == tokenSaleContract || msg.sender == fullTokenWallet || msg.sender == owner);
413         }
414         _;
415     }
416 
417     modifier validDestination(address to) 
418     {
419         require(to != address(this));
420         _;
421     }
422 
423     modifier onlySaleContract()
424     {
425         require(msg.sender == tokenSaleContract);
426         _;
427     }
428 
429     function MINDToken(
430         uint tokenTotalAmount, 
431         uint _transferableStartTime, 
432         address _admin, 
433         address _fullTokenWallet) 
434     {
435         
436         // Mint all tokens. Then disable minting forever.
437         totalSupply = tokenTotalAmount * (10 ** uint256(decimals));
438 
439         balances[msg.sender] = totalSupply;
440         Transfer(address(0x0), msg.sender, totalSupply);
441 
442         transferableStartTime = _transferableStartTime;
443         tokenSaleContract = msg.sender;
444         fullTokenWallet = _fullTokenWallet;
445 
446         transferOwnership(_admin); // admin could drain tokens and eth that were sent here by mistake
447 
448     }
449 
450     /**
451      * @dev override transfer token for a specified address to add onlyWhenTransferEnabled and validDestination
452      * @param _to The address to transfer to.
453      * @param _value The amount to be transferred.
454      */
455     function transfer(address _to, uint _value)
456         public
457         validDestination(_to)
458         onlyWhenTransferEnabled
459         returns (bool) 
460     {
461         return super.transfer(_to, _value);
462     }
463 
464     /**
465      * @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
466      * @param _from The address to transfer from.
467      * @param _to The address to transfer to.
468      * @param _value The amount to be transferred.
469      */
470     function transferFrom(address _from, address _to, uint _value)
471         public
472         validDestination(_to)
473         onlyWhenTransferEnabled
474         returns (bool) 
475     {
476         return super.transferFrom(_from, _to, _value);
477     }
478 
479     event Burn(address indexed _burner, uint _value);
480 
481     /**
482      * @dev burn tokens
483      * @param _value The amount to be burned.
484      * @return always true (necessary in case of override)
485      */
486     function burn(uint _value) 
487         public
488         onlyWhenTransferEnabled
489         onlyOwner
490         returns (bool)
491     {
492         balances[msg.sender] = balances[msg.sender].sub(_value);
493         totalSupply = totalSupply.sub(_value);
494         Burn(msg.sender, _value);
495         Transfer(msg.sender, address(0x0), _value);
496         return true;
497     }
498 
499     /**
500      * @dev burn tokens in the behalf of someone
501      * @param _from The address of the owner of the token.
502      * @param _value The amount to be burned.
503      * @return always true (necessary in case of override)
504      */
505     function burnFrom(address _from, uint256 _value) 
506         public
507         onlyWhenTransferEnabled
508         onlyOwner
509         returns(bool) 
510     {
511         assert(transferFrom(_from, msg.sender, _value));
512         return burn(_value);
513     }
514 
515     /** 
516     * enable transfer earlier (only presale contract can enable the sale earlier)
517     */
518     function enableTransferEarlier ()
519         public
520         onlySaleContract
521     {
522         transferableStartTime = now + 3 days;
523     }
524 
525 
526     /**
527      * @dev transfer to owner any tokens send by mistake on this contracts
528      * @param token The address of the token to transfer.
529      * @param amount The amount to be transfered.
530      */
531     function emergencyERC20Drain(ERC20 token, uint amount )
532         public
533         onlyOwner 
534     {
535         token.transfer(owner, amount);
536     }
537 
538 }
539 
540 /**
541  * @title MINDTokenCrowdSale
542  * @dev 
543  * We add new features to a base crowdsale using multiple inheritance.
544  * We are using the following extensions:
545  * CappedCrowdsale - sets a max boundary for raised funds
546  *
547  * The code is based on the contracts of Open Zeppelin and we add our contracts : MINDTokenCrowdSale and the MIND Token
548  *
549  */
550 contract MINDTokenCrowdSale is Ownable, CappedCrowdsale {
551 
552     // hard cap of the token pre-sale in ether
553     uint private constant HARD_CAP_IN_WEI = 2000 ether;
554     
555     // Token sale rate from ETH to MIND
556     uint private constant RATE_ETH_MIND = 10000;
557 
558     // wallet use also to gather the ether of the token sale
559     address private constant MIND_CROWDSALE_WALLET = 0x942b56E5A6e92B39643dCB5F232EF583680F0B01;
560 
561     event CrowdSaleTokenSoldout();
562 
563     function MINDTokenCrowdSale(uint256 _startTime, uint256 _endTime, address _tokenAddr)
564       CappedCrowdsale(HARD_CAP_IN_WEI)
565       StandardCrowdsale(_startTime, _endTime, RATE_ETH_MIND, MIND_CROWDSALE_WALLET)
566     {
567         token = MINDToken(_tokenAddr);
568     }
569 
570     function getToken() constant returns (address){
571       return token;
572     }
573 
574     /**
575      * @dev Create the MIND token (override createTokenContract of StandardCrowdsale)
576      * @return the StandardToken created
577      */
578     function createTokenContract () 
579       internal 
580       returns(StandardToken) 
581     {
582         return MINDToken(0x0); // No token is created
583     }
584 
585     /**
586       * @dev Get the bonus based on the buy time (override getBonus of StandardCrowdsale)
587       * @return the number of bonus token
588     */
589     function getBonus(uint256 _tokens) constant returns (uint256 bonus) {
590         require(_tokens != 0);
591         if (startTime <= now && now < startTime + 1 days) {
592             // 20% bonus
593             return _tokens.div(5);
594         } else if (startTime + 1 days <= now && now < startTime + 2 days ) {
595             // 15% bonus
596             return _tokens.mul(3).div(20);
597         } else if (startTime + 2 days <= now && now < startTime + 3 days ) {
598             // 10% bonus
599             return _tokens.div(10);
600         } else if (startTime + 3 days <= now && now < startTime + 4 days ) {
601             // 5% bonus
602             return _tokens.div(20);
603         }
604 
605         return 0;
606     }
607 
608     /**
609      * @dev Transfer the unsold tokens to the MIND Foundation multisign wallet 
610      * @dev Only for owner
611      * @return the StandardToken created
612      */
613     function drainRemainingToken () 
614       public
615       onlyOwner
616     {
617         require(hasEnded());
618         token.transfer(MIND_CROWDSALE_WALLET, token.balanceOf(this));
619     }
620 
621 
622     /**
623       * @dev Action after buying tokens: check if all sold out and enable transfer immediately
624       */
625     function postBuyTokens ()
626         internal
627     {
628         if ( token.balanceOf(this) == 0 ) 
629         {
630             CrowdSaleTokenSoldout();
631         }
632     }
633 
634     // @return true if the transaction can buy tokens
635     function validPurchase() 
636         internal 
637         returns(bool) 
638     {
639         return super.validPurchase() && msg.value >= 0.1 ether;
640     }
641 }