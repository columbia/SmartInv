1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ArgumentsChecker {
33 
34     /// @dev check which prevents short address attack
35     modifier payloadSizeIs(uint size) {
36        require(msg.data.length == size + 4 /* function selector */);
37        _;
38     }
39 
40     /// @dev check that address is valid
41     modifier validAddress(address addr) {
42         require(addr != address(0));
43         _;
44     }
45 }
46 
47 contract ReentrancyGuard {
48 
49   /**
50    * @dev We use a single lock for the whole contract.
51    */
52   bool private rentrancy_lock = false;
53 
54   /**
55    * @dev Prevents a contract from calling itself, directly or indirectly.
56    * @notice If you mark a function `nonReentrant`, you should also
57    * mark it `external`. Calling one nonReentrant function from
58    * another is not supported. Instead, you can implement a
59    * `private` function doing the actual work, and a `external`
60    * wrapper marked as `nonReentrant`.
61    */
62   modifier nonReentrant() {
63     require(!rentrancy_lock);
64     rentrancy_lock = true;
65     _;
66     rentrancy_lock = false;
67   }
68 
69 }
70 
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106 }
107 
108 contract CrowdsaleBase is ArgumentsChecker, ReentrancyGuard {
109     using SafeMath for uint256;
110 
111     event FundTransfer(address backer, uint amount, bool isContribution);
112 
113     function CrowdsaleBase(address owner80, address owner20, string token_name, string token_symbol)
114         public
115     {
116         m_funds = new LightFundsRegistry(owner80, owner20);
117         m_token = new TokenBase(token_name, token_symbol);
118 
119         assert(! hasHardCap() || getMaximumFunds() >= getMinimumFunds());
120     }
121 
122 
123     // PUBLIC interface
124 
125     // fallback function as a shortcut
126     function()
127         public
128         payable
129     {
130         require(0 == msg.data.length);
131         buy();  // only internal call here!
132     }
133 
134     /// @notice crowdsale participation
135     function buy()
136         public  // dont mark as external!
137         payable
138     {
139         buyInternal(msg.sender, msg.value);
140     }
141 
142 
143     /// @notice refund
144     function withdrawPayments()
145         external
146     {
147         m_funds.withdrawPayments(msg.sender);
148     }
149 
150 
151     // INTERNAL
152 
153     /// @dev payment processing
154     function buyInternal(address investor, uint payment)
155         internal
156         nonReentrant
157     {
158         require(payment >= getMinInvestment());
159         if (getCurrentTime() >= getEndTime())
160             finish();
161 
162         if (m_finished) {
163             // saving provided gas
164             investor.transfer(payment);
165             return;
166         }
167 
168         uint startingWeiCollected = getWeiCollected();
169         uint startingInvariant = this.balance.add(startingWeiCollected);
170 
171         uint change;
172         if (hasHardCap()) {
173             // return or update payment if needed
174             uint paymentAllowed = getMaximumFunds().sub(getWeiCollected());
175             assert(0 != paymentAllowed);
176 
177             if (paymentAllowed < payment) {
178                 change = payment.sub(paymentAllowed);
179                 payment = paymentAllowed;
180             }
181         }
182 
183         // issue tokens
184         require(m_token.mint(investor, calculateTokens(payment)));
185 
186         // record payment
187         m_funds.invested.value(payment)(investor);
188 
189         assert((!hasHardCap() || getWeiCollected() <= getMaximumFunds()) && getWeiCollected() > startingWeiCollected);
190         FundTransfer(investor, payment, true);
191 
192         if (hasHardCap() && getWeiCollected() == getMaximumFunds())
193             finish();
194 
195         if (change > 0)
196             investor.transfer(change);
197 
198         assert(startingInvariant == this.balance.add(getWeiCollected()).add(change));
199     }
200 
201     function finish() internal {
202         if (m_finished)
203             return;
204 
205         if (getWeiCollected() >= getMinimumFunds()) {
206             // Success
207             m_funds.changeState(LightFundsRegistry.State.SUCCEEDED);
208             m_token.ICOSuccess();
209         }
210         else {
211             // Failure
212             m_funds.changeState(LightFundsRegistry.State.REFUNDING);
213         }
214 
215         m_finished = true;
216     }
217 
218 
219     /// @notice whether to apply hard cap check logic via getMaximumFunds() method
220     function hasHardCap() internal constant returns (bool) {
221         return getMaximumFunds() != 0;
222     }
223 
224     /// @dev to be overridden in tests
225     function getCurrentTime() internal constant returns (uint) {
226         return now;
227     }
228 
229     /// @notice maximum investments to be accepted during the sale (in wei)
230     function getMaximumFunds() internal constant returns (uint) {
231         return euroCents2wei(getMaximumFundsInEuroCents());
232     }
233 
234     /// @notice minimum amount of funding to consider the sale as successful (in wei)
235     function getMinimumFunds() internal constant returns (uint) {
236         return euroCents2wei(getMinimumFundsInEuroCents());
237     }
238 
239     /// @notice end time of the sale
240     function getEndTime() public pure returns (uint) {
241         return 1521331200;
242     }
243 
244     /// @notice minimal amount of one investment (in wei)
245     function getMinInvestment() public pure returns (uint) {
246         return 10 finney;
247     }
248 
249     /// @dev smallest divisible token units (token wei) in one token
250     function tokenWeiInToken() internal constant returns (uint) {
251         return uint(10) ** uint(m_token.decimals());
252     }
253 
254     /// @dev calculates token amount for given investment
255     function calculateTokens(uint payment) internal constant returns (uint) {
256         return wei2euroCents(payment).mul(tokenWeiInToken()).div(tokenPriceInEuroCents());
257     }
258 
259 
260     // conversions
261 
262     function wei2euroCents(uint wei_) public view returns (uint) {
263         return wei_.mul(euroCentsInOneEther()).div(1 ether);
264     }
265 
266 
267     function euroCents2wei(uint euroCents) public view returns (uint) {
268         return euroCents.mul(1 ether).div(euroCentsInOneEther());
269     }
270 
271 
272     // stat
273 
274     /// @notice amount of euro collected
275     function getEuroCollected() public constant returns (uint) {
276         return wei2euroCents(getWeiCollected()).div(100);
277     }
278 
279     /// @notice amount of wei collected
280     function getWeiCollected() public constant returns (uint) {
281         return m_funds.totalInvested();
282     }
283 
284     /// @notice amount of wei-tokens minted
285     function getTokenMinted() public constant returns (uint) {
286         return m_token.totalSupply();
287     }
288 
289 
290     // SETTINGS
291 
292     /// @notice maximum investments to be accepted during the sale (in euro-cents)
293     function getMaximumFundsInEuroCents() public constant returns (uint);
294 
295     /// @notice minimum amount of funding to consider the sale as successful (in euro-cents)
296     function getMinimumFundsInEuroCents() public constant returns (uint);
297 
298     /// @notice euro-cents per 1 ether
299     function euroCentsInOneEther() public constant returns (uint);
300 
301     /// @notice price of one token (1e18 wei-tokens) in euro cents
302     function tokenPriceInEuroCents() public constant returns (uint);
303 
304 
305     // FIELDS
306 
307     /// @dev contract responsible for funds accounting
308     LightFundsRegistry public m_funds;
309 
310     /// @dev contract responsible for token accounting
311     TokenBase public m_token;
312 
313     bool m_finished = false;
314 }
315 
316 contract ERC20Basic {
317   uint256 public totalSupply;
318   function balanceOf(address who) public view returns (uint256);
319   function transfer(address to, uint256 value) public returns (bool);
320   event Transfer(address indexed from, address indexed to, uint256 value);
321 }
322 
323 contract BasicToken is ERC20Basic {
324   using SafeMath for uint256;
325 
326   mapping(address => uint256) balances;
327 
328   /**
329   * @dev transfer token for a specified address
330   * @param _to The address to transfer to.
331   * @param _value The amount to be transferred.
332   */
333   function transfer(address _to, uint256 _value) public returns (bool) {
334     require(_to != address(0));
335     require(_value <= balances[msg.sender]);
336 
337     // SafeMath.sub will throw if there is not enough balance.
338     balances[msg.sender] = balances[msg.sender].sub(_value);
339     balances[_to] = balances[_to].add(_value);
340     Transfer(msg.sender, _to, _value);
341     return true;
342   }
343 
344   /**
345   * @dev Gets the balance of the specified address.
346   * @param _owner The address to query the the balance of.
347   * @return An uint256 representing the amount owned by the passed address.
348   */
349   function balanceOf(address _owner) public view returns (uint256 balance) {
350     return balances[_owner];
351   }
352 
353 }
354 
355 contract ERC20 is ERC20Basic {
356   function allowance(address owner, address spender) public view returns (uint256);
357   function transferFrom(address from, address to, uint256 value) public returns (bool);
358   function approve(address spender, uint256 value) public returns (bool);
359   event Approval(address indexed owner, address indexed spender, uint256 value);
360 }
361 
362 contract StandardToken is ERC20, BasicToken {
363 
364   mapping (address => mapping (address => uint256)) internal allowed;
365 
366 
367   /**
368    * @dev Transfer tokens from one address to another
369    * @param _from address The address which you want to send tokens from
370    * @param _to address The address which you want to transfer to
371    * @param _value uint256 the amount of tokens to be transferred
372    */
373   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
374     require(_to != address(0));
375     require(_value <= balances[_from]);
376     require(_value <= allowed[_from][msg.sender]);
377 
378     balances[_from] = balances[_from].sub(_value);
379     balances[_to] = balances[_to].add(_value);
380     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
381     Transfer(_from, _to, _value);
382     return true;
383   }
384 
385   /**
386    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
387    *
388    * Beware that changing an allowance with this method brings the risk that someone may use both the old
389    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
390    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
391    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
392    * @param _spender The address which will spend the funds.
393    * @param _value The amount of tokens to be spent.
394    */
395   function approve(address _spender, uint256 _value) public returns (bool) {
396     allowed[msg.sender][_spender] = _value;
397     Approval(msg.sender, _spender, _value);
398     return true;
399   }
400 
401   /**
402    * @dev Function to check the amount of tokens that an owner allowed to a spender.
403    * @param _owner address The address which owns the funds.
404    * @param _spender address The address which will spend the funds.
405    * @return A uint256 specifying the amount of tokens still available for the spender.
406    */
407   function allowance(address _owner, address _spender) public view returns (uint256) {
408     return allowed[_owner][_spender];
409   }
410 
411   /**
412    * approve should be called when allowed[_spender] == 0. To increment
413    * allowed value is better to use this function to avoid 2 calls (and wait until
414    * the first transaction is mined)
415    * From MonolithDAO Token.sol
416    */
417   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
418     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
419     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
420     return true;
421   }
422 
423   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
424     uint oldValue = allowed[msg.sender][_spender];
425     if (_subtractedValue > oldValue) {
426       allowed[msg.sender][_spender] = 0;
427     } else {
428       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
429     }
430     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
431     return true;
432   }
433 
434 }
435 
436 contract MintableToken is StandardToken, Ownable {
437   event Mint(address indexed to, uint256 amount);
438   event MintFinished();
439 
440   bool public mintingFinished = false;
441 
442 
443   modifier canMint() {
444     require(!mintingFinished);
445     _;
446   }
447 
448   /**
449    * @dev Function to mint tokens
450    * @param _to The address that will receive the minted tokens.
451    * @param _amount The amount of tokens to mint.
452    * @return A boolean that indicates if the operation was successful.
453    */
454   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
455     totalSupply = totalSupply.add(_amount);
456     balances[_to] = balances[_to].add(_amount);
457     Mint(_to, _amount);
458     Transfer(address(0), _to, _amount);
459     return true;
460   }
461 
462   /**
463    * @dev Function to stop minting new tokens.
464    * @return True if the operation was successful.
465    */
466   function finishMinting() onlyOwner canMint public returns (bool) {
467     mintingFinished = true;
468     MintFinished();
469     return true;
470   }
471 }
472 
473 contract CirculatingToken is StandardToken {
474 
475     event CirculationEnabled();
476 
477     modifier requiresCirculation {
478         require(m_isCirculating);
479         _;
480     }
481 
482 
483     // PUBLIC interface
484 
485     function transfer(address _to, uint256 _value) requiresCirculation returns (bool) {
486         return super.transfer(_to, _value);
487     }
488 
489     function transferFrom(address _from, address _to, uint256 _value) requiresCirculation returns (bool) {
490         return super.transferFrom(_from, _to, _value);
491     }
492 
493     function approve(address _spender, uint256 _value) requiresCirculation returns (bool) {
494         return super.approve(_spender, _value);
495     }
496 
497 
498     // INTERNAL functions
499 
500     function enableCirculation() internal returns (bool) {
501         if (m_isCirculating)
502             return false;
503 
504         m_isCirculating = true;
505         CirculationEnabled();
506         return true;
507     }
508 
509 
510     // FIELDS
511 
512     /// @notice are the circulation started?
513     bool public m_isCirculating;
514 }
515 
516 contract TokenBase is MintableToken, CirculatingToken {
517 
518     event Burn(address indexed from, uint256 amount);
519 
520 
521     string m_name;
522     string m_symbol;
523     uint8 public constant decimals = 18;
524 
525 
526     function TokenBase(string _name, string _symbol) public {
527         require(bytes(_name).length > 0 && bytes(_name).length <= 32);
528         require(bytes(_symbol).length > 0 && bytes(_symbol).length <= 32);
529 
530         m_name = _name;
531         m_symbol = _symbol;
532     }
533 
534 
535     function burn(uint256 _amount) external returns (bool) {
536         address _from = msg.sender;
537         require(_amount>0);
538         require(_amount<=balances[_from]);
539 
540         totalSupply = totalSupply.sub(_amount);
541         balances[_from] = balances[_from].sub(_amount);
542         Burn(_from, _amount);
543         Transfer(_from, address(0), _amount);
544 
545         return true;
546     }
547 
548 
549     function name() public view returns (string) {
550         return m_name;
551     }
552 
553     function symbol() public view returns (string) {
554         return m_symbol;
555     }
556 
557 
558     function ICOSuccess()
559         external
560         onlyOwner
561     {
562         assert(finishMinting());
563         assert(enableCirculation());
564     }
565 }
566 
567 contract LightFundsRegistry is ArgumentsChecker, Ownable, ReentrancyGuard {
568     using SafeMath for uint256;
569 
570     enum State {
571         // gathering funds
572         GATHERING,
573         // returning funds to investors
574         REFUNDING,
575         // funds sent to owners
576         SUCCEEDED
577     }
578 
579     event StateChanged(State _state);
580     event Invested(address indexed investor, uint256 amount);
581     event EtherSent(address indexed to, uint value);
582     event RefundSent(address indexed to, uint value);
583 
584 
585     modifier requiresState(State _state) {
586         require(m_state == _state);
587         _;
588     }
589 
590 
591     // PUBLIC interface
592 
593     function LightFundsRegistry(address owner80, address owner20)
594         public
595         validAddress(owner80)
596         validAddress(owner20)
597     {
598         m_owner80 = owner80;
599         m_owner20 = owner20;
600     }
601 
602     /// @dev performs only allowed state transitions
603     function changeState(State _newState)
604         external
605         onlyOwner
606     {
607         assert(m_state != _newState);
608 
609         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
610         else assert(false);
611 
612         m_state = _newState;
613         StateChanged(m_state);
614 
615         if (State.SUCCEEDED == _newState) {
616             uint _80percent = this.balance.mul(80).div(100);
617             m_owner80.transfer(_80percent);
618             EtherSent(m_owner80, _80percent);
619 
620             uint _20percent = this.balance;
621             m_owner20.transfer(_20percent);
622             EtherSent(m_owner20, _20percent);
623         }
624     }
625 
626     /// @dev records an investment
627     function invested(address _investor)
628         external
629         payable
630         onlyOwner
631         requiresState(State.GATHERING)
632     {
633         uint256 amount = msg.value;
634         require(0 != amount);
635 
636         // register investor
637         if (0 == m_weiBalances[_investor])
638             m_investors.push(_investor);
639 
640         // register payment
641         totalInvested = totalInvested.add(amount);
642         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
643 
644         Invested(_investor, amount);
645     }
646 
647     /// @notice withdraw accumulated balance, called by payee in case crowdsale has failed
648     function withdrawPayments(address payee)
649         external
650         nonReentrant
651         onlyOwner
652         requiresState(State.REFUNDING)
653     {
654         uint256 payment = m_weiBalances[payee];
655 
656         require(payment != 0);
657         require(this.balance >= payment);
658 
659         totalInvested = totalInvested.sub(payment);
660         m_weiBalances[payee] = 0;
661 
662         payee.transfer(payment);
663         RefundSent(payee, payment);
664     }
665 
666     function getInvestorsCount() external view returns (uint) { return m_investors.length; }
667 
668 
669     // FIELDS
670 
671     /// @notice total amount of investments in wei
672     uint256 public totalInvested;
673 
674     /// @notice state of the registry
675     State public m_state = State.GATHERING;
676 
677     /// @dev balances of investors in wei
678     mapping(address => uint256) public m_weiBalances;
679 
680     /// @dev list of unique investors
681     address[] public m_investors;
682 
683     address public m_owner80;
684     address public m_owner20;
685 }
686 
687 contract EESTSale is CrowdsaleBase {
688 
689     function EESTSale() public
690         CrowdsaleBase(
691             /*owner80*/ address(0xd9ab6c63ae5dc8b4d766352b9f666f6e02dba26e),
692             /*owner20*/ address(0xa46e5704057f9432d10919196c3c671cfafa2030),
693             "Electronic exchange sign-token", "EEST")
694     {
695     }
696 
697 
698     /// @notice maximum investments to be accepted during the sale (in euro-cents)
699     function getMaximumFundsInEuroCents() public constant returns (uint) {
700         return 36566900000;
701     }
702 
703     /// @notice minimum amount of funding to consider the sale as successful (in euro-cents)
704     function getMinimumFundsInEuroCents() public constant returns (uint) {
705         return 36566900000;
706     }
707 
708     /// @notice euro-cents per 1 ether
709     function euroCentsInOneEther() public constant returns (uint) {
710         return 58000;
711     }
712 
713     /// @notice price of one token (1e18 wei-tokens) in euro cents
714     function tokenPriceInEuroCents() public constant returns (uint) {
715         return 1000;
716     }
717 }