1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     Unpause();
87   }
88 }
89 
90 
91 /**
92  * @title SafeMath
93  * @dev Math operations with safety checks that throw on error
94  */
95 library SafeMath {
96   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
97     uint256 c = a * b;
98     assert(a == 0 || c / a == b);
99     return c;
100   }
101 
102   function div(uint256 a, uint256 b) internal constant returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function add(uint256 a, uint256 b) internal constant returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20Basic {
128   uint256 public totalSupply;
129   function balanceOf(address who) public constant returns (uint256);
130   function transfer(address to, uint256 value) public returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender) public constant returns (uint256);
141   function transferFrom(address from, address to, uint256 value) public returns (bool);
142   function approve(address spender, uint256 value) public returns (bool);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153 
154   mapping(address => uint256) balances;
155 
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     // SafeMath.sub will throw if there is not enough balance.
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public constant returns (uint256 balance) {
178     return balances[_owner];
179   }
180 
181 }
182 
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    */
246   function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
247     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 
266 /**
267  * @title Burnable Token
268  * @dev Token that can be irreversibly burned (destroyed).
269  */
270 contract BurnableToken is StandardToken {
271 
272     event Burn(address indexed burner, uint256 value);
273 
274     /**
275      * @dev Burns a specific amount of tokens.
276      * @param _value The amount of token to be burned.
277      */
278     function burn(uint256 _value) public {
279         require(_value > 0);
280         require(_value <= balances[msg.sender]);
281         // no need to require value <= totalSupply, since that would imply the
282         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
283 
284         address burner = msg.sender;
285         balances[burner] = balances[burner].sub(_value);
286         totalSupply = totalSupply.sub(_value);
287         Burn(burner, _value);
288     }
289 }
290 
291 
292 /**
293  * @title BitImageToken
294  * @dev ERC20 burnable token based on OpenZeppelin's implementation.
295  */
296 contract BitImageToken is StandardToken, BurnableToken, Ownable {
297 
298     /**
299      * @dev Event for tokens timelock logging.
300      * @param _holder {address} the holder of tokens after they are released.
301      * @param _releaseTime {uint256} the UNIX timestamp when token release is enabled.
302      */
303     event Timelock(address indexed _holder, uint256 _releaseTime);
304 
305     string public name;
306     string public symbol;
307     uint8 public decimals;
308     bool public released;
309     address public saleAgent;
310 
311     mapping (address => uint256) public timelock;
312 
313     modifier onlySaleAgent() {
314         require(msg.sender == saleAgent);
315         _;
316     }
317 
318     modifier whenReleased() {
319         if (timelock[msg.sender] != 0) {
320             require(released && now > timelock[msg.sender]);
321         } else {
322             require(released || msg.sender == saleAgent);
323         }
324         _;
325     }
326 
327 
328     /**
329      * @dev Constructor instantiates token supply and allocates balanace to the owner.
330      */
331     function BitImageToken() public {
332         name = "Bitimage Token";
333         symbol = "BIM";
334         decimals = 18;
335         released = false;
336         totalSupply = 10000000000 ether;
337         balances[msg.sender] = totalSupply;
338         Transfer(address(0), msg.sender, totalSupply);
339     }
340 
341     /**
342      * @dev Associates this token with a specified sale agent. The sale agent will be able
343      * to call transferFrom() function to transfer tokens during crowdsale.
344      * @param _saleAgent {address} the address of a sale agent that will sell this token.
345      */
346     function setSaleAgent(address _saleAgent) public onlyOwner {
347         require(_saleAgent != address(0));
348         require(saleAgent == address(0));
349         saleAgent = _saleAgent;
350         super.approve(saleAgent, totalSupply);
351     }
352 
353     /**
354      * @dev Sets the released flag to true which enables to transfer tokens after crowdsale is end.
355      * Once released, it is not possible to disable transfers.
356      */
357     function release() public onlySaleAgent {
358         released = true;
359     }
360 
361     /**
362      * @dev Sets time when token release is enabled for specified holder.
363      * @param _holder {address} the holder of tokens after they are released.
364      * @param _releaseTime {uint256} the UNIX timestamp when token release is enabled.
365      */
366     function lock(address _holder, uint256 _releaseTime) public onlySaleAgent {
367         require(_holder != address(0));
368         require(_releaseTime > now);
369         timelock[_holder] = _releaseTime;
370         Timelock(_holder, _releaseTime);
371     }
372 
373     /**
374      * @dev Transfers tokens to specified address.
375      * Overrides the transfer() function with modifier that prevents the ability to transfer
376      * tokens by holders unitl release time. Only sale agent can transfer tokens unitl release time.
377      * @param _to {address} the address to transfer to.
378      * @param _value {uint256} the amount of tokens to be transferred.
379      */
380     function transfer(address _to, uint256 _value) public whenReleased returns (bool) {
381         return super.transfer(_to, _value);
382     }
383 
384     /**
385      * @dev Transfers tokens from one address to another.
386      * Overrides the transferFrom() function with modifier that prevents the ability to transfer
387      * tokens by holders unitl release time. Only sale agent can transfer tokens unitl release time.
388      * @param _from {address} the address to send from.
389      * @param _to {address} the address to transfer to.
390      * @param _value {uint256} the amount of tokens to be transferred.
391      */
392     function transferFrom(address _from, address _to, uint256 _value) public whenReleased returns (bool) {
393         return super.transferFrom(_from, _to, _value);
394     }
395 
396     /**
397      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
398      * Overrides the approve() function with  modifier that prevents the ability to approve the passed
399      * address to spend the specified amount of tokens until release time.
400      * @param _spender {address} the address which will spend the funds.
401      * @param _value {uint256} the amount of tokens to be spent.
402      */
403     function approve(address _spender, uint256 _value) public whenReleased returns (bool) {
404         return super.approve(_spender, _value);
405     }
406 
407     /**
408      * @dev Increment allowed value.
409      * Overrides the increaseApproval() function with modifier that prevents the ability to increment
410      * allowed value until release time.
411      * @param _spender {address} the address which will spend the funds.
412      * @param _addedValue {uint} the amount of tokens to be added.
413      */
414     function increaseApproval(address _spender, uint _addedValue) public whenReleased returns (bool success) {
415         return super.increaseApproval(_spender, _addedValue);
416     }
417 
418     /**
419      * @dev Dicrement allowed value.
420      * Overrides the decreaseApproval() function with modifier that prevents the ability to dicrement
421      * allowed value until release time.
422      * @param _spender {address} the address which will spend the funds.
423      * @param _subtractedValue {uint} the amount of tokens to be subtracted.
424      */
425     function decreaseApproval(address _spender, uint _subtractedValue) public whenReleased returns (bool success) {
426         return super.decreaseApproval(_spender, _subtractedValue);
427     }
428 
429     /**
430      * @dev Burns a specified amount of tokens.
431      * Overrides the burn() function with modifier that prevents the ability to burn tokens
432      * by holders excluding the sale agent.
433      * @param _value {uint256} the amount of token to be burned.
434      */
435     function burn(uint256 _value) public onlySaleAgent {
436         super.burn(_value);
437     }
438 
439     /**
440      * @dev Burns a specified amount of tokens from specified address.
441      * @param _from {address} the address to burn from.
442      * @param _value {uint256} the amount of token to be burned.
443      */
444     function burnFrom(address _from, uint256 _value) public onlySaleAgent {
445         require(_value > 0);
446         require(_value <= balances[_from]);
447         balances[_from] = balances[_from].sub(_value);
448         totalSupply = totalSupply.sub(_value);
449         Burn(_from, _value);
450     }
451 }
452 
453 
454 /**
455  * @title BitImageCrowdsale
456  * @dev The BitImageCrowdsale contract is used for selling BitImageToken tokens (BIM).
457  */
458 contract BitImageTokenSale is Pausable {
459     using SafeMath for uint256;
460 
461     /**
462      * @dev Event for token purchase logging.
463      * @param _investor {address} the address of investor.
464      * @param _weiAmount {uint256} the amount of contributed Ether.
465      * @param _tokenAmount {uint256} the amount of tokens purchased.
466      */
467     event TokenPurchase(address indexed _investor, uint256 _weiAmount, uint256 _tokenAmount);
468 
469     /**
470      * @dev Event for Ether Refunding logging.
471      * @param _investor {address} the address of investor.
472      * @param _weiAmount {uint256} the amount of Ether to be refunded.
473      */
474     event Refunded(address indexed _investor, uint256 _weiAmount);
475 
476     BitImageToken public token;
477 
478     address public walletEtherPresale;
479     address public walletEhterCrowdsale;
480 
481     address public walletTokenTeam;
482     address[] public walletTokenAdvisors;
483     address public walletTokenBounty;
484     address public walletTokenReservation;
485 
486     uint256 public startTime;
487     uint256 public period;
488     uint256 public periodPresale;
489     uint256 public periodCrowdsale;
490     uint256 public periodWeek;
491 
492     uint256 public weiMinInvestment;
493     uint256 public weiMaxInvestment;
494 
495     uint256 public rate;
496 
497     uint256 public softCap;
498     uint256 public goal;
499     uint256 public goalIncrement;
500     uint256 public hardCap;
501 
502     uint256 public tokenIcoAllocated;
503     uint256 public tokenTeamAllocated;
504     uint256 public tokenAdvisorsAllocated;
505     uint256 public tokenBountyAllocated;
506     uint256 public tokenReservationAllocated;
507 
508     uint256 public weiTotalReceived;
509 
510     uint256 public tokenTotalSold;
511 
512     uint256 public weiTotalRefunded;
513 
514     uint256 public bonus;
515     uint256 public bonusDicrement;
516     uint256 public bonusAfterPresale;
517 
518     struct Investor {
519         uint256 weiContributed;
520         uint256 tokenBuyed;
521         bool refunded;
522     }
523 
524     mapping (address => Investor) private investors;
525     address[] private investorsIndex;
526 
527     enum State { NEW, PRESALE, CROWDSALE, CLOSED }
528     State public state;
529 
530 
531     /**
532      * @dev Constructor for a crowdsale of BitImageToken tokens.
533      */
534     function BitImageTokenSale() public {
535         walletEtherPresale = 0xE19f0ccc003a36396FE9dA4F344157B2c60A4B8E;
536         walletEhterCrowdsale = 0x10e5f0e94A43FA7C9f7F88F42a6a861312aD1d31;
537         walletTokenTeam = 0x35425E32fE41f167990DBEa1010132E9669Fa500;
538         walletTokenBounty = 0x91325c4a25893d80e26b4dC14b964Cf5a27fECD8;
539         walletTokenReservation = 0x4795eC1E7C24B80001eb1F43206F6e075fCAb4fc;
540         walletTokenAdvisors = [
541             0x2E308F904C831e41329215a4807d9f1a82B67eE2,
542             0x331274f61b3C976899D6FeB6f18A966A50E98C8d,
543             0x6098b02d10A1f27E39bCA219CeB56355126EC74f,
544             0xC14C105430C13e6cBdC8DdB41E88fD88b9325927
545         ];
546         periodPresale = 4 weeks;
547         periodCrowdsale = 6 weeks;
548         periodWeek = 1 weeks;
549         weiMinInvestment = 0.1 ether;
550         weiMaxInvestment = 500 ether;
551         rate = 130000;
552         softCap = 2000 ether;
553         goal = 6000 ether;
554         goalIncrement = goal;
555         hardCap = 42000 ether;
556         bonus = 30;
557         bonusDicrement = 5;
558         state = State.NEW;
559         pause();
560     }
561 
562     /**
563      * @dev Fallback function is called whenever Ether is sent to the contract.
564      */
565     function() external payable {
566         purchase(msg.sender);
567     }
568 
569     /**
570      * @dev Initilizes the token with given address and allocates tokens.
571      * @param _token {address} the address of token contract.
572      */
573     function setToken(address _token) external onlyOwner whenPaused {
574         require(state == State.NEW);
575         require(_token != address(0));
576         require(token == address(0));
577         token = BitImageToken(_token);
578         tokenIcoAllocated = token.totalSupply().mul(62).div(100);
579         tokenTeamAllocated = token.totalSupply().mul(18).div(100);
580         tokenAdvisorsAllocated = token.totalSupply().mul(4).div(100);
581         tokenBountyAllocated = token.totalSupply().mul(6).div(100);
582         tokenReservationAllocated = token.totalSupply().mul(10).div(100);
583         require(token.totalSupply() == tokenIcoAllocated.add(tokenTeamAllocated).add(tokenAdvisorsAllocated).add(tokenBountyAllocated).add(tokenReservationAllocated));
584     }
585 
586     /**
587      * @dev Sets the start time.
588      * @param _startTime {uint256} the UNIX timestamp when to start the sale.
589      */
590     function start(uint256 _startTime) external onlyOwner whenPaused {
591         require(_startTime >= now);
592         require(token != address(0));
593         if (state == State.NEW) {
594             state = State.PRESALE;
595             period = periodPresale;
596         } else if (state == State.PRESALE && weiTotalReceived >= softCap) {
597             state = State.CROWDSALE;
598             period = periodCrowdsale;
599             bonusAfterPresale = bonus.sub(bonusDicrement);
600             bonus = bonusAfterPresale;
601         } else {
602             revert();
603         }
604         startTime = _startTime;
605         unpause();
606     }
607 
608     /**
609      * @dev Finalizes the sale.
610      */
611     function finalize() external onlyOwner {
612         require(weiTotalReceived >= softCap);
613         require(now > startTime.add(period) || weiTotalReceived >= hardCap);
614 
615         if (state == State.PRESALE) {
616             require(this.balance > 0);
617             walletEtherPresale.transfer(this.balance);
618             pause();
619         } else if (state == State.CROWDSALE) {
620             uint256 tokenTotalUnsold = tokenIcoAllocated.sub(tokenTotalSold);
621             tokenReservationAllocated = tokenReservationAllocated.add(tokenTotalUnsold);
622 
623             require(token.transferFrom(token.owner(), walletTokenBounty, tokenBountyAllocated));
624             require(token.transferFrom(token.owner(), walletTokenReservation, tokenReservationAllocated));
625             require(token.transferFrom(token.owner(), walletTokenTeam, tokenTeamAllocated));
626             token.lock(walletTokenReservation, now + 0.5 years);
627             token.lock(walletTokenTeam, now + 1 years);
628             uint256 tokenAdvisor = tokenAdvisorsAllocated.div(walletTokenAdvisors.length);
629             for (uint256 i = 0; i < walletTokenAdvisors.length; i++) {
630                 require(token.transferFrom(token.owner(), walletTokenAdvisors[i], tokenAdvisor));
631                 token.lock(walletTokenAdvisors[i], now + 0.5 years);
632             }
633 
634             token.release();
635             state = State.CLOSED;
636         } else {
637             revert();
638         }
639     }
640 
641     /**
642      * @dev Allows investors to get refund in case when ico is failed.
643      */
644     function refund() external whenNotPaused {
645         require(state == State.PRESALE);
646         require(now > startTime.add(period));
647         require(weiTotalReceived < softCap);
648 
649         require(this.balance > 0);
650 
651         Investor storage investor = investors[msg.sender];
652 
653         require(investor.weiContributed > 0);
654         require(!investor.refunded);
655 
656         msg.sender.transfer(investor.weiContributed);
657         token.burnFrom(msg.sender, investor.tokenBuyed);
658         investor.refunded = true;
659         weiTotalRefunded = weiTotalRefunded.add(investor.weiContributed);
660 
661         Refunded(msg.sender, investor.weiContributed);
662     }
663 
664     function purchase(address _investor) private whenNotPaused {
665         require(state == State.PRESALE || state == State.CROWDSALE);
666         require(now >= startTime && now <= startTime.add(period));
667 
668         if (state == State.CROWDSALE) {
669             uint256 timeFromStart = now.sub(startTime);
670             if (timeFromStart > periodWeek) {
671                 uint256 currentWeek = timeFromStart.div(1 weeks);
672                 uint256 bonusWeek = bonusAfterPresale.sub(bonusDicrement.mul(currentWeek));
673                 if (bonus > bonusWeek) {
674                     bonus = bonusWeek;
675                 }
676                 currentWeek++;
677                 periodWeek = currentWeek.mul(1 weeks);
678             }
679         }
680 
681         uint256 weiAmount = msg.value;
682         require(weiAmount >= weiMinInvestment && weiAmount <= weiMaxInvestment);
683 
684         uint256 tokenAmount = weiAmount.mul(rate);
685         uint256 tokenBonusAmount = tokenAmount.mul(bonus).div(100);
686         tokenAmount = tokenAmount.add(tokenBonusAmount);
687 
688         weiTotalReceived = weiTotalReceived.add(weiAmount);
689         tokenTotalSold = tokenTotalSold.add(tokenAmount);
690         require(tokenTotalSold <= tokenIcoAllocated);
691 
692         require(token.transferFrom(token.owner(), _investor, tokenAmount));
693 
694         Investor storage investor = investors[_investor];
695         if (investor.weiContributed == 0) {
696             investorsIndex.push(_investor);
697         }
698         investor.tokenBuyed = investor.tokenBuyed.add(tokenAmount);
699         investor.weiContributed = investor.weiContributed.add(weiAmount);
700 
701         if (state == State.CROWDSALE) {
702             walletEhterCrowdsale.transfer(weiAmount);
703         }
704         TokenPurchase(_investor, weiAmount, tokenAmount);
705 
706         if (weiTotalReceived >= goal) {
707             if (state == State.PRESALE) {
708                 startTime = now;
709                 period = 1 weeks;
710             }
711             uint256 delta = weiTotalReceived.sub(goal);
712             goal = goal.add(goalIncrement).add(delta);
713             bonus = bonus.sub(bonusDicrement);
714         }
715     }
716 }