1 pragma solidity ^0.4.13;
2 
3 contract ArgumentsChecker {
4 
5     /// @dev check which prevents short address attack
6     modifier payloadSizeIs(uint size) {
7        require(msg.data.length == size + 4 /* function selector */);
8        _;
9     }
10 
11     /// @dev check that address is valid
12     modifier validAddress(address addr) {
13         require(addr != address(0));
14         _;
15     }
16 }
17 
18 contract ERC20Basic {
19   uint256 public totalSupply;
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     if (a == 0) {
65       return 0;
66     }
67     uint256 c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256 balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 contract ReentrancyGuard {
124 
125   /**
126    * @dev We use a single lock for the whole contract.
127    */
128   bool private rentrancy_lock = false;
129 
130   /**
131    * @dev Prevents a contract from calling itself, directly or indirectly.
132    * @notice If you mark a function `nonReentrant`, you should also
133    * mark it `external`. Calling one nonReentrant function from
134    * another is not supported. Instead, you can implement a
135    * `private` function doing the actual work, and a `external`
136    * wrapper marked as `nonReentrant`.
137    */
138   modifier nonReentrant() {
139     require(!rentrancy_lock);
140     rentrancy_lock = true;
141     _;
142     rentrancy_lock = false;
143   }
144 
145 }
146 
147 contract CrowdsaleBase is ArgumentsChecker, ReentrancyGuard {
148     using SafeMath for uint256;
149 
150     event FundTransfer(address backer, uint amount, bool isContribution);
151 
152     function CrowdsaleBase(address owner80, address owner20, string token_name, string token_symbol)
153         public
154     {
155         m_funds = new LightFundsRegistry(owner80, owner20);
156         m_token = new TokenBase(token_name, token_symbol);
157 
158         assert(! hasHardCap() || getMaximumFunds() >= getMinimumFunds());
159     }
160 
161 
162     // PUBLIC interface
163 
164     // fallback function as a shortcut
165     function()
166         public
167         payable
168     {
169         require(0 == msg.data.length);
170         buy();  // only internal call here!
171     }
172 
173     /// @notice crowdsale participation
174     function buy()
175         public  // dont mark as external!
176         payable
177     {
178         buyInternal(msg.sender, msg.value);
179     }
180 
181 
182     /// @notice refund
183     function withdrawPayments()
184         external
185     {
186         m_funds.withdrawPayments(msg.sender);
187     }
188 
189 
190     // INTERNAL
191 
192     /// @dev payment processing
193     function buyInternal(address investor, uint payment)
194         internal
195         nonReentrant
196     {
197         require(payment >= getMinInvestment());
198         if (getCurrentTime() >= getEndTime())
199             finish();
200 
201         if (m_finished) {
202             // saving provided gas
203             investor.transfer(payment);
204             return;
205         }
206 
207         uint startingWeiCollected = getWeiCollected();
208         uint startingInvariant = this.balance.add(startingWeiCollected);
209 
210         uint change;
211         if (hasHardCap()) {
212             // return or update payment if needed
213             uint paymentAllowed = getMaximumFunds().sub(getWeiCollected());
214             assert(0 != paymentAllowed);
215 
216             if (paymentAllowed < payment) {
217                 change = payment.sub(paymentAllowed);
218                 payment = paymentAllowed;
219             }
220         }
221 
222         // issue tokens
223         require(m_token.mint(investor, calculateTokens(payment)));
224 
225         // record payment
226         m_funds.invested.value(payment)(investor);
227 
228         assert((!hasHardCap() || getWeiCollected() <= getMaximumFunds()) && getWeiCollected() > startingWeiCollected);
229         FundTransfer(investor, payment, true);
230 
231         if (hasHardCap() && getWeiCollected() == getMaximumFunds())
232             finish();
233 
234         if (change > 0)
235             investor.transfer(change);
236 
237         assert(startingInvariant == this.balance.add(getWeiCollected()).add(change));
238     }
239 
240     function finish() internal {
241         if (m_finished)
242             return;
243 
244         if (getWeiCollected() >= getMinimumFunds()) {
245             // Success
246             m_funds.changeState(LightFundsRegistry.State.SUCCEEDED);
247             m_token.ICOSuccess();
248         }
249         else {
250             // Failure
251             m_funds.changeState(LightFundsRegistry.State.REFUNDING);
252         }
253 
254         m_finished = true;
255     }
256 
257 
258     /// @notice whether to apply hard cap check logic via getMaximumFunds() method
259     function hasHardCap() internal constant returns (bool) {
260         return getMaximumFunds() != 0;
261     }
262 
263     /// @dev to be overridden in tests
264     function getCurrentTime() internal constant returns (uint) {
265         return now;
266     }
267 
268     /// @notice maximum investments to be accepted during the sale (in wei)
269     function getMaximumFunds() internal constant returns (uint) {
270         return euroCents2wei(getMaximumFundsInEuroCents());
271     }
272 
273     /// @notice minimum amount of funding to consider the sale as successful (in wei)
274     function getMinimumFunds() internal constant returns (uint) {
275         return euroCents2wei(getMinimumFundsInEuroCents());
276     }
277 
278     /// @notice end time of the sale
279     function getEndTime() public pure returns (uint) {
280         return 1521331200;
281     }
282 
283     /// @notice minimal amount of one investment (in wei)
284     function getMinInvestment() public pure returns (uint) {
285         return 10 finney;
286     }
287 
288     /// @dev smallest divisible token units (token wei) in one token
289     function tokenWeiInToken() internal constant returns (uint) {
290         return uint(10) ** uint(m_token.decimals());
291     }
292 
293     /// @dev calculates token amount for given investment
294     function calculateTokens(uint payment) internal constant returns (uint) {
295         return wei2euroCents(payment).mul(tokenWeiInToken()).div(tokenPriceInEuroCents());
296     }
297 
298 
299     // conversions
300 
301     function wei2euroCents(uint wei_) public view returns (uint) {
302         return wei_.mul(euroCentsInOneEther()).div(1 ether);
303     }
304 
305 
306     function euroCents2wei(uint euroCents) public view returns (uint) {
307         return euroCents.mul(1 ether).div(euroCentsInOneEther());
308     }
309 
310 
311     // stat
312 
313     /// @notice amount of euro collected
314     function getEuroCollected() public constant returns (uint) {
315         return wei2euroCents(getWeiCollected()).div(100);
316     }
317 
318     /// @notice amount of wei collected
319     function getWeiCollected() public constant returns (uint) {
320         return m_funds.totalInvested();
321     }
322 
323     /// @notice amount of wei-tokens minted
324     function getTokenMinted() public constant returns (uint) {
325         return m_token.totalSupply();
326     }
327 
328 
329     // SETTINGS
330 
331     /// @notice maximum investments to be accepted during the sale (in euro-cents)
332     function getMaximumFundsInEuroCents() public constant returns (uint);
333 
334     /// @notice minimum amount of funding to consider the sale as successful (in euro-cents)
335     function getMinimumFundsInEuroCents() public constant returns (uint);
336 
337     /// @notice euro-cents per 1 ether
338     function euroCentsInOneEther() public constant returns (uint);
339 
340     /// @notice price of one token (1e18 wei-tokens) in euro cents
341     function tokenPriceInEuroCents() public constant returns (uint);
342 
343 
344     // FIELDS
345 
346     /// @dev contract responsible for funds accounting
347     LightFundsRegistry public m_funds;
348 
349     /// @dev contract responsible for token accounting
350     TokenBase public m_token;
351 
352     bool m_finished = false;
353 }
354 
355 contract LightFundsRegistry is ArgumentsChecker, Ownable, ReentrancyGuard {
356     using SafeMath for uint256;
357 
358     enum State {
359         // gathering funds
360         GATHERING,
361         // returning funds to investors
362         REFUNDING,
363         // funds sent to owners
364         SUCCEEDED
365     }
366 
367     event StateChanged(State _state);
368     event Invested(address indexed investor, uint256 amount);
369     event EtherSent(address indexed to, uint value);
370     event RefundSent(address indexed to, uint value);
371 
372 
373     modifier requiresState(State _state) {
374         require(m_state == _state);
375         _;
376     }
377 
378 
379     // PUBLIC interface
380 
381     function LightFundsRegistry(address owner80, address owner20)
382         public
383         validAddress(owner80)
384         validAddress(owner20)
385     {
386         m_owner80 = owner80;
387         m_owner20 = owner20;
388     }
389 
390     /// @dev performs only allowed state transitions
391     function changeState(State _newState)
392         external
393         onlyOwner
394     {
395         assert(m_state != _newState);
396 
397         if (State.GATHERING == m_state) {   assert(State.REFUNDING == _newState || State.SUCCEEDED == _newState); }
398         else assert(false);
399 
400         m_state = _newState;
401         StateChanged(m_state);
402 
403         if (State.SUCCEEDED == _newState) {
404             uint _80percent = this.balance.mul(80).div(100);
405             m_owner80.transfer(_80percent);
406             EtherSent(m_owner80, _80percent);
407 
408             uint _20percent = this.balance;
409             m_owner20.transfer(_20percent);
410             EtherSent(m_owner20, _20percent);
411         }
412     }
413 
414     /// @dev records an investment
415     function invested(address _investor)
416         external
417         payable
418         onlyOwner
419         requiresState(State.GATHERING)
420     {
421         uint256 amount = msg.value;
422         require(0 != amount);
423 
424         // register investor
425         if (0 == m_weiBalances[_investor])
426             m_investors.push(_investor);
427 
428         // register payment
429         totalInvested = totalInvested.add(amount);
430         m_weiBalances[_investor] = m_weiBalances[_investor].add(amount);
431 
432         Invested(_investor, amount);
433     }
434 
435     /// @notice withdraw accumulated balance, called by payee in case crowdsale has failed
436     function withdrawPayments(address payee)
437         external
438         nonReentrant
439         onlyOwner
440         requiresState(State.REFUNDING)
441     {
442         uint256 payment = m_weiBalances[payee];
443 
444         require(payment != 0);
445         require(this.balance >= payment);
446 
447         totalInvested = totalInvested.sub(payment);
448         m_weiBalances[payee] = 0;
449 
450         payee.transfer(payment);
451         RefundSent(payee, payment);
452     }
453 
454     function getInvestorsCount() external view returns (uint) { return m_investors.length; }
455 
456 
457     // FIELDS
458 
459     /// @notice total amount of investments in wei
460     uint256 public totalInvested;
461 
462     /// @notice state of the registry
463     State public m_state = State.GATHERING;
464 
465     /// @dev balances of investors in wei
466     mapping(address => uint256) public m_weiBalances;
467 
468     /// @dev list of unique investors
469     address[] public m_investors;
470 
471     address public m_owner80;
472     address public m_owner20;
473 }
474 
475 contract ERC20 is ERC20Basic {
476   function allowance(address owner, address spender) public view returns (uint256);
477   function transferFrom(address from, address to, uint256 value) public returns (bool);
478   function approve(address spender, uint256 value) public returns (bool);
479   event Approval(address indexed owner, address indexed spender, uint256 value);
480 }
481 
482 contract StandardToken is ERC20, BasicToken {
483 
484   mapping (address => mapping (address => uint256)) internal allowed;
485 
486 
487   /**
488    * @dev Transfer tokens from one address to another
489    * @param _from address The address which you want to send tokens from
490    * @param _to address The address which you want to transfer to
491    * @param _value uint256 the amount of tokens to be transferred
492    */
493   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
494     require(_to != address(0));
495     require(_value <= balances[_from]);
496     require(_value <= allowed[_from][msg.sender]);
497 
498     balances[_from] = balances[_from].sub(_value);
499     balances[_to] = balances[_to].add(_value);
500     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
501     Transfer(_from, _to, _value);
502     return true;
503   }
504 
505   /**
506    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
507    *
508    * Beware that changing an allowance with this method brings the risk that someone may use both the old
509    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
510    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
511    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
512    * @param _spender The address which will spend the funds.
513    * @param _value The amount of tokens to be spent.
514    */
515   function approve(address _spender, uint256 _value) public returns (bool) {
516     allowed[msg.sender][_spender] = _value;
517     Approval(msg.sender, _spender, _value);
518     return true;
519   }
520 
521   /**
522    * @dev Function to check the amount of tokens that an owner allowed to a spender.
523    * @param _owner address The address which owns the funds.
524    * @param _spender address The address which will spend the funds.
525    * @return A uint256 specifying the amount of tokens still available for the spender.
526    */
527   function allowance(address _owner, address _spender) public view returns (uint256) {
528     return allowed[_owner][_spender];
529   }
530 
531   /**
532    * approve should be called when allowed[_spender] == 0. To increment
533    * allowed value is better to use this function to avoid 2 calls (and wait until
534    * the first transaction is mined)
535    * From MonolithDAO Token.sol
536    */
537   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
538     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
539     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
540     return true;
541   }
542 
543   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
544     uint oldValue = allowed[msg.sender][_spender];
545     if (_subtractedValue > oldValue) {
546       allowed[msg.sender][_spender] = 0;
547     } else {
548       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
549     }
550     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
551     return true;
552   }
553 
554 }
555 
556 contract CirculatingToken is StandardToken {
557 
558     event CirculationEnabled();
559 
560     modifier requiresCirculation {
561         require(m_isCirculating);
562         _;
563     }
564 
565 
566     // PUBLIC interface
567 
568     function transfer(address _to, uint256 _value) requiresCirculation returns (bool) {
569         return super.transfer(_to, _value);
570     }
571 
572     function transferFrom(address _from, address _to, uint256 _value) requiresCirculation returns (bool) {
573         return super.transferFrom(_from, _to, _value);
574     }
575 
576     function approve(address _spender, uint256 _value) requiresCirculation returns (bool) {
577         return super.approve(_spender, _value);
578     }
579 
580 
581     // INTERNAL functions
582 
583     function enableCirculation() internal returns (bool) {
584         if (m_isCirculating)
585             return false;
586 
587         m_isCirculating = true;
588         CirculationEnabled();
589         return true;
590     }
591 
592 
593     // FIELDS
594 
595     /// @notice are the circulation started?
596     bool public m_isCirculating;
597 }
598 
599 contract MintableToken is StandardToken, Ownable {
600   event Mint(address indexed to, uint256 amount);
601   event MintFinished();
602 
603   bool public mintingFinished = false;
604 
605 
606   modifier canMint() {
607     require(!mintingFinished);
608     _;
609   }
610 
611   /**
612    * @dev Function to mint tokens
613    * @param _to The address that will receive the minted tokens.
614    * @param _amount The amount of tokens to mint.
615    * @return A boolean that indicates if the operation was successful.
616    */
617   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
618     totalSupply = totalSupply.add(_amount);
619     balances[_to] = balances[_to].add(_amount);
620     Mint(_to, _amount);
621     Transfer(address(0), _to, _amount);
622     return true;
623   }
624 
625   /**
626    * @dev Function to stop minting new tokens.
627    * @return True if the operation was successful.
628    */
629   function finishMinting() onlyOwner canMint public returns (bool) {
630     mintingFinished = true;
631     MintFinished();
632     return true;
633   }
634 }
635 
636 contract TokenBase is MintableToken, CirculatingToken {
637 
638     event Burn(address indexed from, uint256 amount);
639 
640 
641     string m_name;
642     string m_symbol;
643     uint8 public constant decimals = 18;
644 
645 
646     function TokenBase(string _name, string _symbol) public {
647         require(bytes(_name).length > 0 && bytes(_name).length <= 32);
648         require(bytes(_symbol).length > 0 && bytes(_symbol).length <= 32);
649 
650         m_name = _name;
651         m_symbol = _symbol;
652     }
653 
654 
655     function burn(uint256 _amount) external returns (bool) {
656         address _from = msg.sender;
657         require(_amount>0);
658         require(_amount<=balances[_from]);
659 
660         totalSupply = totalSupply.sub(_amount);
661         balances[_from] = balances[_from].sub(_amount);
662         Burn(_from, _amount);
663         Transfer(_from, address(0), _amount);
664 
665         return true;
666     }
667 
668 
669     function name() public view returns (string) {
670         return m_name;
671     }
672 
673     function symbol() public view returns (string) {
674         return m_symbol;
675     }
676 
677 
678     function ICOSuccess()
679         external
680         onlyOwner
681     {
682         assert(finishMinting());
683         assert(enableCirculation());
684     }
685 }
686 
687 
688 contract EESTSale6 is CrowdsaleBase {
689 
690     function EESTSale6() public
691         CrowdsaleBase(
692             /*owner80*/ address(0xade21bda21be237f8b13a494a46b122c5f1f26fb),
693             /*owner20*/ address(0xa6809a7e050ca9ea9e4d2ccedc88f07d6ada09aa),
694             "Electronic exchange sign-token 6", "EEST6")
695     {
696     }
697 
698 
699     /// @notice maximum investments to be accepted during the sale (in euro-cents)
700     function getMaximumFundsInEuroCents() public constant returns (uint) {
701         return 6000000000;
702     }
703 
704     /// @notice minimum amount of funding to consider the sale as successful (in euro-cents)
705     function getMinimumFundsInEuroCents() public constant returns (uint) {
706         return 6000000000;
707     }
708 
709     /// @notice euro-cents per 1 ether
710     function euroCentsInOneEther() public constant returns (uint) {
711         return 58000;
712     }
713 
714     /// @notice price of one token (1e18 wei-tokens) in euro cents
715     function tokenPriceInEuroCents() public constant returns (uint) {
716         return 1000;
717     }
718 }