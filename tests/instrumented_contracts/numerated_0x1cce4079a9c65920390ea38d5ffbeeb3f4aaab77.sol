1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() {
135     owner = msg.sender;
136   }
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) onlyOwner public {
153     require(newOwner != address(0));
154     OwnershipTransferred(owner, newOwner);
155     owner = newOwner;
156   }
157 
158 }
159 
160 contract FinalizableCrowdsale is Crowdsale, Ownable {
161   using SafeMath for uint256;
162 
163   bool public isFinalized = false;
164 
165   event Finalized();
166 
167   /**
168    * @dev Must be called after crowdsale ends, to do some extra finalization
169    * work. Calls the contract's finalization function.
170    */
171   function finalize() onlyOwner public {
172     require(!isFinalized);
173     require(hasEnded());
174 
175     finalization();
176     Finalized();
177 
178     isFinalized = true;
179   }
180 
181   /**
182    * @dev Can be overridden to add finalization logic. The overriding function
183    * should call super.finalization() to ensure the chain of finalization is
184    * executed entirely.
185    */
186   function finalization() internal {
187   }
188 }
189 
190 contract RefundVault is Ownable {
191   using SafeMath for uint256;
192 
193   enum State { Active, Refunding, Closed }
194 
195   mapping (address => uint256) public deposited;
196   address public wallet;
197   State public state;
198 
199   event Closed();
200   event RefundsEnabled();
201   event Refunded(address indexed beneficiary, uint256 weiAmount);
202 
203   function RefundVault(address _wallet) {
204     require(_wallet != 0x0);
205     wallet = _wallet;
206     state = State.Active;
207   }
208 
209   function deposit(address investor) onlyOwner public payable {
210     require(state == State.Active);
211     deposited[investor] = deposited[investor].add(msg.value);
212   }
213 
214   function close() onlyOwner public {
215     require(state == State.Active);
216     state = State.Closed;
217     Closed();
218     wallet.transfer(this.balance);
219   }
220 
221   function enableRefunds() onlyOwner public {
222     require(state == State.Active);
223     state = State.Refunding;
224     RefundsEnabled();
225   }
226 
227   function refund(address investor) public {
228     require(state == State.Refunding);
229     uint256 depositedValue = deposited[investor];
230     deposited[investor] = 0;
231     investor.transfer(depositedValue);
232     Refunded(investor, depositedValue);
233   }
234 }
235 
236 contract ERC20Basic {
237   uint256 public totalSupply;
238   function balanceOf(address who) public constant returns (uint256);
239   function transfer(address to, uint256 value) public returns (bool);
240   event Transfer(address indexed from, address indexed to, uint256 value);
241 }
242 
243 contract BasicToken is ERC20Basic {
244   using SafeMath for uint256;
245 
246   mapping(address => uint256) balances;
247 
248   /**
249   * @dev transfer token for a specified address
250   * @param _to The address to transfer to.
251   * @param _value The amount to be transferred.
252   */
253   function transfer(address _to, uint256 _value) public returns (bool) {
254     require(_to != address(0));
255 
256     // SafeMath.sub will throw if there is not enough balance.
257     balances[msg.sender] = balances[msg.sender].sub(_value);
258     balances[_to] = balances[_to].add(_value);
259     Transfer(msg.sender, _to, _value);
260     return true;
261   }
262 
263   /**
264   * @dev Gets the balance of the specified address.
265   * @param _owner The address to query the the balance of.
266   * @return An uint256 representing the amount owned by the passed address.
267   */
268   function balanceOf(address _owner) public constant returns (uint256 balance) {
269     return balances[_owner];
270   }
271 
272 }
273 
274 contract ERC20 is ERC20Basic {
275   function allowance(address owner, address spender) public constant returns (uint256);
276   function transferFrom(address from, address to, uint256 value) public returns (bool);
277   function approve(address spender, uint256 value) public returns (bool);
278   event Approval(address indexed owner, address indexed spender, uint256 value);
279 }
280 
281 contract StandardToken is ERC20, BasicToken {
282 
283   mapping (address => mapping (address => uint256)) allowed;
284 
285 
286   /**
287    * @dev Transfer tokens from one address to another
288    * @param _from address The address which you want to send tokens from
289    * @param _to address The address which you want to transfer to
290    * @param _value uint256 the amount of tokens to be transferred
291    */
292   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
293     require(_to != address(0));
294 
295     uint256 _allowance = allowed[_from][msg.sender];
296 
297     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
298     // require (_value <= _allowance);
299 
300     balances[_from] = balances[_from].sub(_value);
301     balances[_to] = balances[_to].add(_value);
302     allowed[_from][msg.sender] = _allowance.sub(_value);
303     Transfer(_from, _to, _value);
304     return true;
305   }
306 
307   /**
308    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
309    *
310    * Beware that changing an allowance with this method brings the risk that someone may use both the old
311    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
312    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
313    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314    * @param _spender The address which will spend the funds.
315    * @param _value The amount of tokens to be spent.
316    */
317   function approve(address _spender, uint256 _value) public returns (bool) {
318     allowed[msg.sender][_spender] = _value;
319     Approval(msg.sender, _spender, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Function to check the amount of tokens that an owner allowed to a spender.
325    * @param _owner address The address which owns the funds.
326    * @param _spender address The address which will spend the funds.
327    * @return A uint256 specifying the amount of tokens still available for the spender.
328    */
329   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
330     return allowed[_owner][_spender];
331   }
332 
333   /**
334    * approve should be called when allowed[_spender] == 0. To increment
335    * allowed value is better to use this function to avoid 2 calls (and wait until
336    * the first transaction is mined)
337    * From MonolithDAO Token.sol
338    */
339   function increaseApproval (address _spender, uint _addedValue)
340     returns (bool success) {
341     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
342     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346   function decreaseApproval (address _spender, uint _subtractedValue)
347     returns (bool success) {
348     uint oldValue = allowed[msg.sender][_spender];
349     if (_subtractedValue > oldValue) {
350       allowed[msg.sender][_spender] = 0;
351     } else {
352       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
353     }
354     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 
358 }
359 
360 contract BurnableToken is StandardToken {
361 
362     event Burn(address indexed burner, uint256 value);
363 
364     /**
365      * @dev Burns a specific amount of tokens.
366      * @param _value The amount of token to be burned.
367      */
368     function burn(uint256 _value) public {
369         require(_value > 0);
370 
371         address burner = msg.sender;
372         balances[burner] = balances[burner].sub(_value);
373         totalSupply = totalSupply.sub(_value);
374         Burn(burner, _value);
375     }
376 }
377 
378 contract MintableToken is StandardToken, Ownable {
379   event Mint(address indexed to, uint256 amount);
380   event MintFinished();
381 
382   bool public mintingFinished = false;
383 
384 
385   modifier canMint() {
386     require(!mintingFinished);
387     _;
388   }
389 
390   /**
391    * @dev Function to mint tokens
392    * @param _to The address that will receive the minted tokens.
393    * @param _amount The amount of tokens to mint.
394    * @return A boolean that indicates if the operation was successful.
395    */
396   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
397     totalSupply = totalSupply.add(_amount);
398     balances[_to] = balances[_to].add(_amount);
399     Mint(_to, _amount);
400     Transfer(0x0, _to, _amount);
401     return true;
402   }
403 
404   /**
405    * @dev Function to stop minting new tokens.
406    * @return True if the operation was successful.
407    */
408   function finishMinting() onlyOwner public returns (bool) {
409     mintingFinished = true;
410     MintFinished();
411     return true;
412   }
413 }
414 
415 contract MeeTip is MintableToken, BurnableToken {
416     string public name = "MeeTip";
417     string public symbol = "MTIP";
418     uint256 public decimals = 18;
419 }
420 
421 contract MeeTipCrowdsale is FinalizableCrowdsale {
422     using SafeMath for uint256;
423 
424     address public foundersWallet;
425     address public bountyWallet;
426     // minimal purchase is 0.05 Ether
427     uint256 public constant MINIMAL_PURCHASE = 50 finney;
428     // hard cap is 27 000 000 MTIP
429     uint256 public tokenCap = 27000000 * 10**18;
430     // minimum amount of tokens to be sold
431     uint256 public tokenGoal = 50000 * 10**18;
432     uint256 public tokenSold;
433     uint256 public endTimePreICO;
434     uint256 public startTimeICO;
435     uint256 public endFirstDayICO;
436     uint256 public endFirstWeekICO;
437     uint256 public endSecondWeekICO;
438     uint256 public endThirdWeekICO;
439 
440     // refund vault used to hold funds while crowdsale is running
441     RefundVault public vault;
442 
443     function MeeTipCrowdsale(
444         uint256 _startTime,
445         uint256 _endTimePreICO,
446         uint256 _startTimeICO,
447         uint256 _endFirstDayICO,
448         uint256 _endFirstWeekICO,
449         uint256 _endSecondWeekICO,
450         uint256 _endThirdWeekICO,
451         uint256 _endTime,
452         address _contributionWallet,
453         address _foundersWallet,
454         address _bountyWallet
455         )
456         FinalizableCrowdsale()
457         // convertion rate is 900 MTIP per 1 ether during preICO
458         Crowdsale(_startTime, _endTime, 900, _contributionWallet)
459         {
460         require(_foundersWallet != 0x0);
461         require(_bountyWallet != 0x0);
462         require(_endTimePreICO >= _startTime);
463         require(_startTimeICO >= _endTimePreICO);
464         require(_endFirstDayICO >= _startTimeICO);
465         require(_endFirstWeekICO >= _endFirstDayICO);
466         require(_endSecondWeekICO >= _endFirstWeekICO);
467         require(_endThirdWeekICO >= _endSecondWeekICO);
468         require(_endTime >= _endThirdWeekICO);
469 
470         vault = new RefundVault(wallet);
471 
472         endTimePreICO = _endTimePreICO;
473         startTimeICO = _startTimeICO;
474         endFirstDayICO = _endFirstDayICO;
475         endFirstWeekICO = _endFirstWeekICO;
476         endSecondWeekICO = _endSecondWeekICO;
477         endThirdWeekICO = _endThirdWeekICO;
478 
479         foundersWallet = _foundersWallet;
480         bountyWallet = _bountyWallet;
481 
482         // allocate 1 500 000 MTIP for company
483         token.mint(foundersWallet, 1500000 * (10**18));
484 
485         // allocate 1 500 000 MTIP for bounty program
486         token.mint(bountyWallet, 1500000 * (10**18));
487         }
488 
489     function createTokenContract() internal returns (MintableToken) {
490         return new MeeTip();
491     }
492 
493     // low level token purchase function
494     function buyTokens(address beneficiary) public payable {
495         require(beneficiary != 0x0);
496 
497         updateRate();
498 
499         require(validPurchase());
500 
501         uint256 weiAmount = msg.value;
502 
503         // calculate token amount to be created
504         uint256 tokens = weiAmount.mul(rate);
505 
506         // update state
507         weiRaised = weiRaised.add(weiAmount);
508         tokenSold = tokenSold.add(tokens);
509 
510         token.mint(beneficiary, tokens);
511         TokenPurchase(
512             msg.sender,
513             beneficiary,
514             weiAmount,
515             tokens
516         );
517 
518         forwardFunds();
519     }
520 
521     function updateRate() internal constant {
522         if (now <= endTimePreICO) {
523             rate = 900;
524         } else if (now <= endFirstDayICO ) {
525             rate = 800;
526         } else if (now <= endFirstWeekICO) {
527             rate = 750;
528         } else if (now <= endSecondWeekICO) {
529             rate = 700;
530         } else if (now <= endThirdWeekICO) {
531             rate = 650;
532         } else if (now <= endTime) {
533             rate = 600;
534         }
535     }
536 
537     // @return true if the transaction can buy tokens
538     function validPurchase() internal constant returns (bool) {
539         bool withinPreICO = startTime <= now && now <= endTimePreICO;
540         bool withinICO = startTimeICO <= now && now <= endTime;
541         bool enoughPurchase = msg.value >= MINIMAL_PURCHASE;
542         bool withinTokenCap = tokenSold.add(msg.value.mul(rate)) <= tokenCap;
543         return (withinPreICO || withinICO) && enoughPurchase && withinTokenCap;
544     }
545 
546     // We're overriding the fund forwarding from Crowdsale.
547     // In addition to sending the funds, we want to call
548     // the RefundVault deposit function
549     function forwardFunds() internal {
550         // no refunds during preICO
551         if ( now <= endTimePreICO ) {
552             wallet.transfer(msg.value);
553         } else {
554             vault.deposit.value(msg.value)(msg.sender);
555         }
556     }
557 
558     // if crowdsale is unsuccessful, investors can claim refunds here
559     function claimRefund() public {
560         require(isFinalized);
561         require(!goalReached());
562 
563         vault.refund(msg.sender);
564     }
565 
566     // vault finalization task, called when owner calls finalize()
567     function finalization() internal {
568         if (goalReached()) {
569             vault.close();
570         } else {
571             vault.enableRefunds();
572         }
573         super.finalization();
574     }
575 
576     function goalReached() public constant returns (bool) {
577         return tokenSold >= tokenGoal;
578     }
579 
580     // overriding Crowdsale#hasEnded to add cap logic
581     // @return true if crowdsale event has ended
582     function hasEnded() public constant returns (bool) {
583         bool tokenCapReached = tokenSold >= tokenCap;
584         return super.hasEnded() || tokenCapReached;
585     }
586 }