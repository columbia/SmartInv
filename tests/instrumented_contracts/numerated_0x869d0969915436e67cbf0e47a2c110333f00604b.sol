1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Math
51  * @dev Assorted math operations
52  */
53 library Math {
54   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
55     return a >= b ? a : b;
56   }
57 
58   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
59     return a < b ? a : b;
60   }
61 
62   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
63     return a >= b ? a : b;
64   }
65 
66   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
67     return a < b ? a : b;
68   }
69 }
70 
71 contract OracleI {
72     bytes32 public oracleName;
73     bytes16 public oracleType;
74     uint256 public rate;
75     bool public waitQuery;
76     uint256 public updateTime;
77     uint256 public callbackTime;
78     function getPrice() view public returns (uint);
79     function setBank(address _bankAddress) public;
80     function setGasPrice(uint256 _price) public;
81     function setGasLimit(uint256 _limit) public;
82     function updateRate() external returns (bool);
83 }
84 
85 interface ExchangerI {
86     /* Order creation */
87     function buyTokens(address _recipient) payable public;
88     function sellTokens(address _recipient, uint256 tokensCount) public;
89 
90     /* Rate calc & init  params */
91     function requestRates() payable public;
92     function calcRates() public;
93 
94     /* Data getters */
95     function tokenBalance() public view returns(uint256);
96     function getOracleData(uint number) public view returns (address, bytes32, bytes16, bool, uint256, uint256, uint256);
97 
98     /* Balance methods */
99     function refillBalance() payable public;
100     function withdrawReserve() public;
101 }
102 
103 /**
104  * @title Ownable
105  * @dev The Ownable contract has an owner address, and provides basic authorization control
106  * functions, this simplifies the implementation of "user permissions".
107  */
108 contract Ownable {
109   address public owner;
110 
111 
112   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114 
115   /**
116    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
117    * account.
118    */
119   function Ownable() public {
120     owner = msg.sender;
121   }
122 
123   /**
124    * @dev Throws if called by any account other than the owner.
125    */
126   modifier onlyOwner() {
127     require(msg.sender == owner);
128     _;
129   }
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address newOwner) public onlyOwner {
136     require(newOwner != address(0));
137     OwnershipTransferred(owner, newOwner);
138     owner = newOwner;
139   }
140 
141 }
142 
143 
144 /**
145  * @title ERC20Basic
146  * @dev Simpler version of ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/179
148  */
149 contract ERC20Basic {
150   function totalSupply() public view returns (uint256);
151   function balanceOf(address who) public view returns (uint256);
152   function transfer(address to, uint256 value) public returns (bool);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is ERC20Basic {
173   using SafeMath for uint256;
174 
175   mapping(address => uint256) balances;
176 
177   uint256 totalSupply_;
178 
179   /**
180   * @dev total number of tokens in existence
181   */
182   function totalSupply() public view returns (uint256) {
183     return totalSupply_;
184   }
185 
186   /**
187   * @dev transfer token for a specified address
188   * @param _to The address to transfer to.
189   * @param _value The amount to be transferred.
190   */
191   function transfer(address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193     require(_value <= balances[msg.sender]);
194 
195     // SafeMath.sub will throw if there is not enough balance.
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     Transfer(msg.sender, _to, _value);
199     return true;
200   }
201 
202   /**
203   * @dev Gets the balance of the specified address.
204   * @param _owner The address to query the the balance of.
205   * @return An uint256 representing the amount owned by the passed address.
206   */
207   function balanceOf(address _owner) public view returns (uint256 balance) {
208     return balances[_owner];
209   }
210 
211 }
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[_from]);
234     require(_value <= allowed[_from][msg.sender]);
235 
236     balances[_from] = balances[_from].sub(_value);
237     balances[_to] = balances[_to].add(_value);
238     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239     Transfer(_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    *
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) public returns (bool) {
254     allowed[msg.sender][_spender] = _value;
255     Approval(msg.sender, _spender, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param _owner address The address which owns the funds.
262    * @param _spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(address _owner, address _spender) public view returns (uint256) {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
280     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 /**
309  * @title Burnable Token
310  * @dev Token that can be irreversibly burned (destroyed).
311  */
312 contract BurnableToken is BasicToken {
313 
314   event Burn(address indexed burner, uint256 value);
315 
316   /**
317    * @dev Burns a specific amount of tokens.
318    * @param _value The amount of token to be burned.
319    */
320   function burn(uint256 _value) public {
321     require(_value <= balances[msg.sender]);
322     // no need to require value <= totalSupply, since that would imply the
323     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
324 
325     address burner = msg.sender;
326     balances[burner] = balances[burner].sub(_value);
327     totalSupply_ = totalSupply_.sub(_value);
328     Burn(burner, _value);
329   }
330 }
331 
332 /**
333  * @title Mintable token
334  * @dev Simple ERC20 Token example, with mintable token creation
335  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
336  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
337  */
338 contract MintableToken is StandardToken, Ownable {
339   event Mint(address indexed to, uint256 amount);
340   event MintFinished();
341 
342   bool public mintingFinished = false;
343 
344 
345   modifier canMint() {
346     require(!mintingFinished);
347     _;
348   }
349 
350   /**
351    * @dev Function to mint tokens
352    * @param _to The address that will receive the minted tokens.
353    * @param _amount The amount of tokens to mint.
354    * @return A boolean that indicates if the operation was successful.
355    */
356   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
357     totalSupply_ = totalSupply_.add(_amount);
358     balances[_to] = balances[_to].add(_amount);
359     Mint(_to, _amount);
360     Transfer(address(0), _to, _amount);
361     return true;
362   }
363 
364   /**
365    * @dev Function to stop minting new tokens.
366    * @return True if the operation was successful.
367    */
368   function finishMinting() onlyOwner canMint public returns (bool) {
369     mintingFinished = true;
370     MintFinished();
371     return true;
372   }
373 }
374 
375 
376 /**
377  * @title Claimable
378  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
379  * This allows the new owner to accept the transfer.
380  */
381 contract Claimable is Ownable {
382   address public pendingOwner;
383 
384   /**
385    * @dev Modifier throws if called by any account other than the pendingOwner.
386    */
387   modifier onlyPendingOwner() {
388     require(msg.sender == pendingOwner);
389     _;
390   }
391 
392   /**
393    * @dev Allows the current owner to set the pendingOwner address.
394    * @param newOwner The address to transfer ownership to.
395    */
396   function transferOwnership(address newOwner) onlyOwner public {
397     pendingOwner = newOwner;
398   }
399 
400   /**
401    * @dev Allows the pendingOwner address to finalize the transfer.
402    */
403   function claimOwnership() onlyPendingOwner public {
404     OwnershipTransferred(owner, pendingOwner);
405     owner = pendingOwner;
406     pendingOwner = address(0);
407   }
408 }
409 
410 
411 /**
412  * @title LibreCash token contract.
413  *
414  * @dev ERC20 token contract.
415  */
416 contract LibreCash is MintableToken, BurnableToken, Claimable  {
417     string public constant name = "LibreCash";
418     string public constant symbol = "Libre";
419     uint32 public constant decimals = 18;
420 }
421 
422 
423 contract ComplexExchanger is ExchangerI {
424     using SafeMath for uint256;
425 
426     address public tokenAddress;
427     LibreCash token;
428     address[] public oracles;
429     uint256 public deadline;
430     address public withdrawWallet;
431 
432     uint256 public requestTime;
433     uint256 public calcTime;
434 
435     uint256 public buyRate;
436     uint256 public sellRate;
437     uint256 public buyFee;
438     uint256 public sellFee;
439 
440     uint256 constant ORACLE_ACTUAL = 15 minutes;
441     uint256 constant ORACLE_TIMEOUT = 10 minutes;
442     // RATE_PERIOD should be greater than or equal to ORACLE_ACTUAL
443     uint256 constant RATE_PERIOD = 15 minutes;
444     uint256 constant MIN_READY_ORACLES = 2;
445     uint256 constant FEE_MULTIPLIER = 100;
446     uint256 constant RATE_MULTIPLIER = 1000;
447     uint256 constant MAX_RATE = 5000 * RATE_MULTIPLIER;
448     uint256 constant MIN_RATE = 100 * RATE_MULTIPLIER;
449     
450     event InvalidRate(uint256 rate, address oracle);
451     event OracleRequest(address oracle);
452     event Buy(address sender, address recipient, uint256 tokenAmount, uint256 price);
453     event Sell(address sender, address recipient, uint256 cryptoAmount, uint256 price);
454     event ReserveRefill(uint256 amount);
455     event ReserveWithdraw(uint256 amount);
456 
457     enum State {
458         LOCKED,
459         PROCESSING_ORDERS,
460         WAIT_ORACLES,
461         CALC_RATES,
462         REQUEST_RATES
463     }
464 
465     function() payable public {
466         buyTokens(msg.sender);
467     }
468 
469     function ComplexExchanger(
470         address _token,
471         uint256 _buyFee,
472         uint256 _sellFee,
473         address[] _oracles,
474         uint256 _deadline, 
475         address _withdrawWallet
476     ) public
477     {
478         require(
479             _withdrawWallet != address(0x0) &&
480             _token != address(0x0) &&
481             _deadline > now &&
482             _oracles.length >= MIN_READY_ORACLES
483         );
484 
485         tokenAddress = _token;
486         token = LibreCash(tokenAddress);
487         oracles = _oracles;
488         buyFee = _buyFee;
489         sellFee = _sellFee;
490         deadline = _deadline;
491         withdrawWallet = _withdrawWallet;
492     }
493 
494     /**
495      * @dev Returns the contract state.
496      */
497     function getState() public view returns (State) {
498         if (now >= deadline)
499             return State.LOCKED;
500 
501         if (now - calcTime < RATE_PERIOD)
502             return State.PROCESSING_ORDERS;
503 
504         if (waitingOracles() != 0)
505             return State.WAIT_ORACLES;
506         
507         if (readyOracles() >= MIN_READY_ORACLES)
508             return State.CALC_RATES;
509 
510         return State.REQUEST_RATES;
511     }
512 
513     /**
514      * @dev Allows user to buy tokens by ether.
515      * @param _recipient The recipient of tokens.
516      */
517     function buyTokens(address _recipient) public payable {
518         require(getState() == State.PROCESSING_ORDERS);
519 
520         uint256 availableTokens = tokenBalance();
521         require(availableTokens > 0);
522 
523         uint256 tokensAmount = msg.value.mul(buyRate) / RATE_MULTIPLIER;
524         require(tokensAmount != 0);
525 
526         uint256 refundAmount = 0;
527         // if recipient set as 0x0 - recipient is sender
528         address recipient = _recipient == 0x0 ? msg.sender : _recipient;
529 
530         if (tokensAmount > availableTokens) {
531             refundAmount = tokensAmount.sub(availableTokens).mul(RATE_MULTIPLIER) / buyRate;
532             tokensAmount = availableTokens;
533         }
534 
535         token.transfer(recipient, tokensAmount);
536         Buy(msg.sender, recipient, tokensAmount, buyRate);
537         if (refundAmount > 0)
538             recipient.transfer(refundAmount);
539     }
540 
541     /**
542      * @dev Allows user to sell tokens and get ether.
543      * @param _recipient The recipient of ether.
544      * @param tokensCount The count of tokens to sell.
545      */
546     function sellTokens(address _recipient, uint256 tokensCount) public {
547         require(getState() == State.PROCESSING_ORDERS);
548         require(tokensCount <= token.allowance(msg.sender, this));
549 
550         uint256 cryptoAmount = tokensCount.mul(RATE_MULTIPLIER) / sellRate;
551         require(cryptoAmount != 0);
552 
553         if (cryptoAmount > this.balance) {
554             uint256 extraTokens = (cryptoAmount - this.balance).mul(sellRate) / RATE_MULTIPLIER;
555             cryptoAmount = this.balance;
556             tokensCount = tokensCount.sub(extraTokens);
557         }
558 
559         token.transferFrom(msg.sender, this, tokensCount);
560         address recipient = _recipient == 0x0 ? msg.sender : _recipient;
561 
562         Sell(msg.sender, recipient, cryptoAmount, sellRate);
563         recipient.transfer(cryptoAmount);
564     }
565 
566     /**
567      * @dev Requests oracles rates updating; funds oracles if needed.
568      */
569     function requestRates() public payable {
570         require(getState() == State.REQUEST_RATES);
571         // Or just sub msg.value
572         // If it will be below zero - it will throw revert()
573         // require(msg.value >= requestPrice());
574         uint256 value = msg.value;
575 
576         for (uint256 i = 0; i < oracles.length; i++) {
577             OracleI oracle = OracleI(oracles[i]);
578             uint callPrice = oracle.getPrice();
579             
580             // If oracle needs funds - refill it
581             if (oracles[i].balance < callPrice) {
582                 value = value.sub(callPrice);
583                 oracles[i].transfer(callPrice);
584             }
585             
586             if (oracle.updateRate())
587                 OracleRequest(oracles[i]);
588         }
589         requestTime = now;
590 
591         if (value > 0)
592             msg.sender.transfer(value);
593     }
594 
595     /**
596      * @dev Returns cost of requestRates function.
597      */
598     function requestPrice() public view returns(uint256) {
599         uint256 requestCost = 0;
600         for (uint256 i = 0; i < oracles.length; i++) {
601             requestCost = requestCost.add(OracleI(oracles[i]).getPrice());
602         }
603         return requestCost;
604     }
605 
606     /**
607      * @dev Calculates buy and sell rates after oracles have received it.
608      */
609     function calcRates() public {
610         require(getState() == State.CALC_RATES);
611 
612         uint256 minRate = 2**256 - 1; // Max for UINT256
613         uint256 maxRate = 0;
614         uint256 validOracles = 0;
615 
616         for (uint256 i = 0; i < oracles.length; i++) {
617             OracleI oracle = OracleI(oracles[i]);
618             uint256 rate = oracle.rate();
619             if (oracle.waitQuery()) {
620                 continue;
621             }
622             if (isRateValid(rate)) {
623                 minRate = Math.min256(rate, minRate);
624                 maxRate = Math.max256(rate, maxRate);
625                 validOracles++;
626             } else {
627                 InvalidRate(rate, oracles[i]);
628             }
629         }
630         // If valid rates data is insufficient - throw
631         if (validOracles < MIN_READY_ORACLES)
632             revert();
633 
634         buyRate = minRate.mul(FEE_MULTIPLIER * RATE_MULTIPLIER - buyFee * RATE_MULTIPLIER / 100) / FEE_MULTIPLIER / RATE_MULTIPLIER;
635         sellRate = maxRate.mul(FEE_MULTIPLIER * RATE_MULTIPLIER + sellFee * RATE_MULTIPLIER / 100) / FEE_MULTIPLIER / RATE_MULTIPLIER;
636 
637         calcTime = now;
638     }
639 
640     /**
641      * @dev Returns contract oracles' count.
642      */
643     function oracleCount() public view returns(uint256) {
644         return oracles.length;
645     }
646 
647     /**
648      * @dev Returns token balance of the sender.
649      */
650     function tokenBalance() public view returns(uint256) {
651         return token.balanceOf(address(this));
652     }
653 
654     /**
655      * @dev Returns data for an oracle by its id in the array.
656      */
657     function getOracleData(uint number) 
658         public 
659         view 
660         returns (address, bytes32, bytes16, bool, uint256, uint256, uint256)
661                 /* address, name, type, waitQuery, updTime, clbTime, rate */
662     {
663         OracleI curOracle = OracleI(oracles[number]);
664 
665         return(
666             oracles[number],
667             curOracle.oracleName(),
668             curOracle.oracleType(),
669             curOracle.waitQuery(),
670             curOracle.updateTime(),
671             curOracle.callbackTime(),
672             curOracle.rate()
673         );
674     }
675 
676     /**
677      * @dev Returns ready (which have data to be used) oracles count.
678      */
679     function readyOracles() public view returns (uint256) {
680         uint256 count = 0;
681         for (uint256 i = 0; i < oracles.length; i++) {
682             OracleI oracle = OracleI(oracles[i]);
683             if ((oracle.rate() != 0) && 
684                 !oracle.waitQuery() &&
685                 (now - oracle.updateTime()) < ORACLE_ACTUAL)
686                 count++;
687         }
688 
689         return count;
690     }
691 
692     /**
693      * @dev Returns wait query oracle count.
694      */
695     function waitingOracles() public view returns (uint256) {
696         uint256 count = 0;
697         for (uint256 i = 0; i < oracles.length; i++) {
698             if (OracleI(oracles[i]).waitQuery() && (now - requestTime) < ORACLE_TIMEOUT) {
699                 count++;
700             }
701         }
702 
703         return count;
704     }
705 
706     /**
707      * @dev Withdraws balance only to special hardcoded wallet ONLY WHEN contract is locked.
708      */
709     function withdrawReserve() public {
710         require(getState() == State.LOCKED && msg.sender == withdrawWallet);
711         ReserveWithdraw(this.balance);
712         withdrawWallet.transfer(this.balance);
713         token.burn(tokenBalance());
714     }
715 
716     /**
717      * @dev Allows to deposit eth to the contract without creating orders.
718      */
719     function refillBalance() public payable {
720         ReserveRefill(msg.value);
721     }
722 
723     /**
724      * @dev Returns if given rate is within limits; internal.
725      * @param rate Rate.
726      */
727     function isRateValid(uint256 rate) internal pure returns(bool) {
728         return rate >= MIN_RATE && rate <= MAX_RATE;
729     }
730 }