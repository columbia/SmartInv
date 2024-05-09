1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-31
3 */
4 
5 pragma solidity ^0.6.12;
6 
7 // SPDX-License-Identifier: GPL-3.0
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15     address public owner;
16 
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21     /**
22      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23      * account.
24      */
25     constructor() public {
26         owner = msg.sender;
27     }
28 
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(msg.sender == owner, "Not authorized operation");
35         _;
36     }
37 
38 
39     /**
40      * @dev Allows the current owner to transfer control of the contract to a newOwner.
41      * @param newOwner The address to transfer ownership to.
42      */
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0), "Address shouldn't be zero");
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 
49 }
50 
51 
52 /**
53  * @dev Wrappers over Solidity's arithmetic operations with added overflow
54  * checks.
55  *
56  * Arithmetic operations in Solidity wrap on overflow. This can easily result
57  * in bugs, because programmers usually assume that an overflow raises an
58  * error, which is the standard behavior in high level programming languages.
59  * `SafeMath` restores this intuition by reverting the transaction when an
60  * operation overflows.
61  *
62  * Using this library instead of the unchecked operations eliminates an entire
63  * class of bugs, so it's recommended to use it always.
64  */
65 library SafeMath {
66     /**
67      * @dev Returns the addition of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `+` operator.
71      *
72      * Requirements:
73      * - Addition cannot overflow.
74      */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath: addition overflow");
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the subtraction of two unsigned integers, reverting on
84      * overflow (when the result is negative).
85      *
86      * Counterpart to Solidity's `-` operator.
87      *
88      * Requirements:
89      * - Subtraction cannot overflow.
90      */
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b <= a, "SafeMath: subtraction overflow");
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         // Solidity only automatically asserts when dividing by 0
134         require(b > 0, "SafeMath: division by zero");
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b != 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 }
157 
158 interface IERC20 {
159     /**
160      * @dev Returns the amount of tokens in existence.
161      */
162     function totalSupply() external view returns (uint256);
163 
164     /**
165      * @dev Returns the amount of tokens owned by `account`.
166      */
167     function balanceOf(address _owner) external view returns (uint256);
168 
169 
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     /**
173      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
174      * a call to `approve`. `value` is the new allowance.
175      */
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 
180 /**
181  * @dev Simple ERC20 Token example, with mintable token creation only during the deployement of the token contract */
182 
183 contract TokenContract is Ownable{
184   using SafeMath for uint256;
185 
186   string public name;
187   string public symbol;
188   uint8 public decimals;
189   uint256 public totalSupply;
190   address public tokenOwner;
191   address private ico;
192 
193   mapping(address => uint256) balances;
194   mapping (address => mapping (address => uint256)) internal allowed;
195   mapping(address => bool) public vestedlist;
196 
197   event SetICO(address indexed _ico);
198   event Mint(address indexed to, uint256 amount);
199   event MintFinished();
200   event UnlockToken();
201   event LockToken();
202   event Burn();
203   event Approval(address indexed owner, address indexed spender, uint256 value);
204   event Transfer(address indexed from, address indexed to, uint256 value);
205   event addedToVestedlist(address indexed _vestedAddress);
206   event removedFromVestedlist(address indexed _vestedAddress);
207 
208   
209   bool public mintingFinished = false;
210   bool public locked = true;
211 
212   modifier canMint() {
213     require(!mintingFinished);
214     _;
215   }
216   
217   modifier canTransfer() {
218     require(!locked || msg.sender == owner || msg.sender == ico);
219     _;
220   }
221   
222   modifier onlyAuthorized() {
223     require(msg.sender == owner || msg.sender == ico);
224     _;
225   }
226 
227 
228   constructor(string memory _name, string memory  _symbol, uint8 _decimals) public {
229     require (_decimals != 0);
230     name = _name;
231     symbol = _symbol;
232     decimals = _decimals;
233     totalSupply = 0;
234     balances[msg.sender] = totalSupply;
235     emit Transfer(address(0), msg.sender, totalSupply);
236 
237 
238   }
239 
240   /**
241    * @dev Function to mint tokens
242    * @param _to The address that will receive the minted tokens.
243    * @param _amount The amount of tokens to mint.
244    * @return A boolean that indicates if the operation was successful.
245    */
246   function mint(address _to, uint256 _amount) public onlyAuthorized canMint returns (bool) {
247     totalSupply = totalSupply.add(_amount);
248     balances[_to] = balances[_to].add(_amount);
249     emit Mint(_to, _amount);
250     emit Transfer(address(this), _to, _amount);
251     return true;
252   }
253 
254   /**
255    * @dev Function to stop minting new tokens.
256    * @return True if the operation was successful.
257    */
258   function finishMinting() public onlyAuthorized canMint returns (bool) {
259     mintingFinished = true;
260     emit MintFinished();
261     return true;
262   }
263 
264   /**
265   * @dev transfer token for a specified address
266   * @param _to The address to transfer to.
267   * @param _value The amount to be transferred.
268   */
269   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
270     require(_to != address(0));
271 	require (!isVestedlisted(msg.sender));
272     require(_value <= balances[msg.sender]);
273     require (msg.sender != address(this));
274 
275     // SafeMath.sub will throw if there is not enough balance.
276     balances[msg.sender] = balances[msg.sender].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     emit Transfer(msg.sender, _to, _value);
279     return true;
280   }
281 
282 
283   function burn(address _who, uint256 _value) onlyAuthorized public returns (bool){
284     require(_who != address(0));
285     
286     totalSupply = totalSupply.sub(_value);
287     balances[_who] = balances[_who].sub(_value);
288     emit Burn();
289     emit Transfer(_who, address(0), _value);
290     return true;
291   }
292   
293 
294   function balanceOf(address _owner) public view returns (uint256 balance) {
295     return balances[_owner];
296   }
297   
298   /**
299    * @dev Transfer tokens from one address to another
300    * @param _from address The address which you want to send tokens from
301    * @param _to address The address which you want to transfer to
302    * @param _value uint256 the amount of tokens to be transferred
303    */
304   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
305     require(_to != address(0));
306     require(_value <= balances[_from]);
307     require(_value <= allowed[_from][msg.sender]);
308 
309     balances[_from] = balances[_from].sub(_value);
310     balances[_to] = balances[_to].add(_value);
311     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
312     emit Transfer(_from, _to, _value);
313     return true;
314   }
315 
316   function transferFromERC20Contract(address _to, uint256 _value) public onlyOwner returns (bool) {
317     require(_to != address(0));
318     require(_value <= balances[address(this)]);
319     balances[address(this)] = balances[address(this)].sub(_value);
320     balances[_to] = balances[_to].add(_value);
321     emit Transfer(address(this), _to, _value);
322     return true;
323   }
324 
325 
326   /**
327    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328    *
329    * Beware that changing an allowance with this method brings the risk that someone may use both the old
330    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333    * @param _spender The address which will spend the funds.
334    * @param _value The amount of tokens to be spent.
335    */
336   function approve(address _spender, uint256 _value) public returns (bool) {
337     allowed[msg.sender][_spender] = _value;
338     emit Approval(msg.sender, _spender, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Function to check the amount of tokens that an owner allowed to a spender.
344    * @param _owner address The address which owns the funds.
345    * @param _spender address The address which will spend the funds.
346    * @return A uint256 specifying the amount of tokens still available for the spender.
347    */
348   function allowance(address _owner, address _spender) public view returns (uint256) {
349     return allowed[_owner][_spender];
350   }
351 
352   /**
353    * @dev Increase the amount of tokens that an owner allowed to a spender.
354    *
355    * approve should be called when allowed[_spender] == 0. To increment
356    * allowed value is better to use this function to avoid 2 calls (and wait until
357    * the first transaction is mined)
358    * @param _spender The address which will spend the funds.
359    * @param _addedValue The amount of tokens to increase the allowance by.
360    */
361   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
362     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
363     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364     return true;
365   }
366 
367   /**
368    * @dev Decrease the amount of tokens that an owner allowed to a spender.
369    *
370    * approve should be called when allowed[_spender] == 0. To decrement
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * @param _spender The address which will spend the funds.
374    * @param _subtractedValue The amount of tokens to decrease the allowance by.
375    */
376   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
377     uint oldValue = allowed[msg.sender][_spender];
378     if (_subtractedValue > oldValue) {
379       allowed[msg.sender][_spender] = 0;
380     } else {
381       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
382     }
383     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
384     return true;
385   }
386 
387   function unlockToken() public onlyAuthorized returns (bool) {
388     locked = false;
389     emit UnlockToken();
390     return true;
391   }
392 
393   function lockToken() public onlyAuthorized returns (bool) {
394     locked = true;
395     emit LockToken();
396     return true;
397   }
398   
399   function setICO(address _icocontract) public onlyOwner returns (bool) {
400     require(_icocontract != address(0));
401     ico = _icocontract;
402     emit SetICO(_icocontract);
403     return true;
404   }
405 
406     /**
407      * @dev Adds list of addresses to Vestedlist. Not overloaded due to limitations with truffle testing.
408      * @param _vestedAddress Addresses to be added to the Vestedlist
409      */
410     function addToVestedlist(address[] memory _vestedAddress) public onlyOwner {
411         for (uint256 i = 0; i < _vestedAddress.length; i++) {
412             if (vestedlist[_vestedAddress[i]]) continue;
413             vestedlist[_vestedAddress[i]] = true;
414         }
415     }
416 
417 
418     /**
419      * @dev Removes single address from Vestedlist.
420      * @param _vestedAddress Address to be removed to the Vestedlist
421      */
422     function removeFromVestedlist(address[] memory _vestedAddress) public onlyOwner {
423         for (uint256 i = 0; i < _vestedAddress.length; i++) {
424             if (!vestedlist[_vestedAddress[i]]) continue;
425             vestedlist[_vestedAddress[i]] = false;
426         }
427     }
428 
429 
430     function isVestedlisted(address _vestedAddress) internal view returns (bool) {
431       return (vestedlist[_vestedAddress]);
432     }
433 
434 }
435 
436 /**
437  * @title PullPayment
438  * @dev Base contract supporting async send for pull payments. Inherit from this
439  * contract and use asyncSend instead of send.
440  */
441 contract PullPayment {
442     using SafeMath for uint256;
443 
444     mapping (address => uint256) public payments;
445 
446     uint256 public totalPayments;
447 
448     /**
449     * @dev Called by the payer to store the sent amount as credit to be pulled.
450     * @param dest The destination address of the funds.
451     * @param amount The amount to transfer.
452     */
453     function asyncSend(address dest, uint256 amount) internal{
454         payments[dest] = payments[dest].add(amount);
455         totalPayments = totalPayments.add(amount);
456     }
457 
458     /**
459     * @dev withdraw accumulated balance, called by payee.
460     */
461     function withdrawPayments() internal{
462         address payable payee = msg.sender;
463         uint256 payment = payments[payee];
464 
465         require(payment != 0);
466         require(address(this).balance >= payment);
467 
468         totalPayments = totalPayments.sub(payment);
469         payments[payee] = 0;
470 
471         assert(payee.send(payment));
472     }
473 }
474 
475 /**
476  * @title ICO
477  * @dev ICO is a base contract for managing a public token sale,
478  * allowing investors to purchase tokens with ether. This contract implements
479  * such functionality in its most fundamental form and can be extended to provide additional
480  * functionality and/or custom behavior.
481  * The external interface represents the basic interface for purchasing tokens, and conform
482  * the base architecture for a public sale. They are *not* intended to be modified / overriden.
483  * The internal interface conforms the extensible and modifiable surface of public token sales. Override
484  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
485  * behavior.
486  */
487 
488 contract ICO is PullPayment, Ownable {
489 
490   using SafeMath for uint256;
491 
492   // The token being sold
493   TokenContract public token;
494 
495   // Address where funds are collected
496   address payable public wallet;
497 
498   // Address to receive project tokens
499   address public projectOwner;
500 
501   // Refund period if the ICO failed
502   uint256 public refundPeriod;
503 
504   // How many token units a buyer gets per ETH/wei during Pre sale. The ETH price is fixed at 400$ during Pre sale.
505   uint256 public Presalerate = 0.00025 ether;   //  1 DCASH Token = 0.10 $ = 0.00025 Ether
506 
507   // How many token units a buyer gets per ETH/wei during ICO. The ETH price is fixed at 400$ during the ICO to guarantee the 30 % discount rate with the presale rate
508   uint256 public Icorate = 0.000325 ether;    //  1 DCASH Token = 0.13 $ = 0.000325 Ether
509  
510   // Amount of ETH/Wei raised during the ICO period
511   uint256 public EthRaisedIco;
512 
513   // Amount of ETH/wei raised during the Pre sale
514   uint256 public EthRaisedpresale;
515 
516   // Token amount distributed during the ICO period
517   uint256 public tokenDistributed;
518 
519   // Token amount distributed during the Pre sale
520   uint256 public tokenDistributedpresale;
521 
522   // investors part according to the whitepaper 60 % (50% ICO + 10% PreSale) 
523   uint256 public investors = 60;
524   
525   // Min purchase size of incoming ETH during pre sale period fixed at 2 ETH valued at 800 $ 
526   uint256 public constant MIN_PURCHASE_Presale = 2 ether;
527 
528   // Minimum purchase size of incoming ETH during ICO at 1$
529   uint256 public constant MIN_PURCHASE_ICO = 0.0025 ether;
530 
531   // Hardcap cap in Ether raised during Pre sale fixed at $ 200 000 for ETH valued at 440$ 
532   uint256 public PresaleSalemaxCap1 = 500 ether;
533 
534   // Softcap funding goal during ICO in Ether raised fixed at $ 200 000 for ETH valued at 400$.
535   uint256 public ICOminCap = 500 ether;
536 
537   // Hardcap goal in Ether during ICO in Ether raised fixed at $ 13 000 000 for ETH valued at 400$
538   uint256 public ICOmaxCap = 32500 ether;
539 
540   // presale start/end
541   bool public presale = true;    // State of the ongoing sales Pre sale 
542   
543   // ICO start/end
544   bool public ico = false;         // State of the ongoing sales ICO period
545 
546   // Balances in incoming Ether
547   mapping(address => uint256) balances;
548   
549   // Bool to check that the Presalesale period is launch only one time
550   bool public statepresale = false;
551   
552   // Bool to check that the ico is launch only one time
553   bool public stateico = true;
554 
555   /**
556    * Event for token purchase logging
557    * @param purchaser who paid for the tokens
558    * @param beneficiary who got the tokens
559    * @param value weis paid for purchase
560    * @param amount amount of tokens purchased
561    */
562   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
563   event NewContract(address indexed _from, address indexed _contract, string _type);
564 
565   /**
566    * @param _wallet Address where collected funds will be forwarded to
567    * @param _token Address of the ERC20 Token
568    * @param _project Address where the Token of the project will be sent
569    */
570   constructor(address payable _wallet, address _token, address _project) public {
571     require(_wallet != address(0) && _token != address(0) && _project != address(0));
572     wallet = _wallet;
573     token = TokenContract(_token);    
574     projectOwner = _project;
575 
576   }
577 
578   // -----------------------------------------
579   // ICO external interface
580   // -----------------------------------------
581 
582   /**
583    * @dev fallback function ***DO NOT OVERRIDE***
584    */
585   receive() external payable {
586      if (presale) {
587       buypresaleTokens(msg.sender);
588     }
589 
590     if (ico) {
591       buyICOTokens(msg.sender);
592     }
593   }
594 
595   function buypresaleTokens (address _beneficiary) internal {
596     require(_beneficiary != address(0) , "Failed the wallet is not allowed");  
597     require(msg.value >= MIN_PURCHASE_Presale, "Failed the amount is not respecting the minimum deposit of Presale ");
598     // Check that if investors sends more than the MIN_PURCHASE_Presale
599     uint256 weiAmount = msg.value;
600 	// According to the whitepaper the backers who invested on Presale Sale have not possibilities to be refunded. Their ETH Balance is updated to zero value.
601 	balances[msg.sender] = 0;
602     // calculate token amount to be created
603     uint256 tokensTocreate = _getTokenpresaleAmount(weiAmount);
604     _getRemainingTokenStock(_beneficiary, tokensTocreate);
605     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokensTocreate);
606 
607     // update state
608     EthRaisedpresale = EthRaisedpresale.add(weiAmount);
609     tokenDistributedpresale = tokenDistributedpresale.add(tokensTocreate);
610 
611     // If Presale Sale softcap is reached then the ether on the ICO contract are send to project wallet
612     if (EthRaisedpresale <= PresaleSalemaxCap1) {
613       wallet.transfer(address(this).balance);
614     } else {
615       //If PresaleSalemaxCap1 is reached then the presale is closed
616       if (EthRaisedpresale >= PresaleSalemaxCap1) {
617         presale = false;
618       }
619     }
620   }
621   
622   /**
623    * @dev low level token purchase ***DO NOT OVERRIDE***
624    * @param _beneficiary Address performing the token purchase
625    */
626   function buyICOTokens(address _beneficiary) internal {
627 	require(_beneficiary != address(0) , "Failed the wallet is not allowed");  
628     require(msg.value >= MIN_PURCHASE_ICO, "Failed the amount is not respecting the minimum deposit of ICO");
629     // Check that if investors sends more than the MIN_PURCHASE_ICO
630     uint256 weiAmount = msg.value;
631 
632     // calculate token amount to be created
633     uint256 tokensTocreate = _getTokenAmount(weiAmount);
634 
635     // Look if there is token on the contract if he is not create the amount of token
636     _getRemainingTokenStock(_beneficiary, tokensTocreate);
637     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokensTocreate);
638 
639     // update state
640     EthRaisedIco = EthRaisedIco.add(weiAmount);
641 
642     // Creation of the token and transfer to beneficiary
643     tokenDistributed = tokenDistributed.add(tokensTocreate);
644 
645     // Update the balance of benificiary
646     balances[_beneficiary] = balances[_beneficiary].add(weiAmount);
647 
648     uint256 totalEthRaised = EthRaisedIco.add(EthRaisedpresale);
649 
650     // If ICOminCap is reached then the ether on the ICO contract are send to project wallet
651     if (totalEthRaised >= ICOminCap && totalEthRaised <= ICOmaxCap) {
652       wallet.transfer(address(this).balance);
653     }
654 
655     //If ICOmaxCap is reached then the ICO close
656     if (totalEthRaised >= ICOmaxCap) {
657       ico = false;
658     }
659   }
660 
661   /* ADMINISTRATIVE FUNCTIONS */
662 
663   // Update the ETH ICO rate  
664   function updateETHIcoRate(uint256 _EtherAmount) public onlyOwner {
665     Icorate = (_EtherAmount).mul(1 wei);
666   }
667   
668     // Update the ETH PreSale rate  
669   function updateETHPresaleRate(uint256 _EtherAmount) public onlyOwner {
670     Presalerate = (_EtherAmount).mul(1 wei);
671   }
672 
673     // Update the ETH ICO MAX CAP  
674   function updateICOMaxcap(uint256 _EtherAmount) public onlyOwner {
675     ICOmaxCap = (_EtherAmount).mul(1 wei);
676   }
677 
678   // start presale
679   function startpresale() public onlyOwner {
680     require(statepresale && !ico,"Failed the Presale was already started or another sale is ongoing");
681     presale = true;
682     statepresale = false;
683     token.lockToken();
684   }
685 
686   // close Presale
687   function closepresale() public onlyOwner {
688     require(presale && !ico, "Failed it was already closed");
689     presale = false;
690   }
691  
692  // start ICO
693   function startICO() public onlyOwner {
694 
695     // bool to see if the ico has already been launched and  presale is not in progress
696     require(stateico && !presale, "Failed the ICO was already started or another salae is ongoing");
697 
698     refundPeriod = now.add(2764800);
699       // 32 days in seconds ==> 32*24*3600
700 
701     ico = true;
702     token.lockToken();
703 
704     // Put the bool to False to block the start of this function again
705     stateico = false;
706   }
707 
708   // close ICO
709   function closeICO() public onlyOwner {
710     require(!presale && ico,"Failed it was already closed");
711     ico = false;
712   }
713 
714   /* When ICO MIN_CAP is not reach the smart contract will be credited to make refund possible by backers
715    * 1) backer call the "refund" function of the ICO contract
716    * 2) backer call the "reimburse" function of the ICO contract to get a refund in ETH
717    */
718   function refund() public {
719     require(_refundPeriod());
720     require(balances[msg.sender] > 0);
721 
722     uint256 ethToSend = balances[msg.sender];
723     balances[msg.sender] = 0;
724     asyncSend(msg.sender, ethToSend);
725   }
726 
727   function reimburse() public {
728     require(_refundPeriod());
729     withdrawPayments();
730     EthRaisedIco = address(this).balance;
731   }
732 
733   // Function to pay out if the ICO is successful
734   function WithdrawFunds() public onlyOwner {
735     require(!ico && !presale, "Failed a sales is ongoing");
736     require(now > refundPeriod.add(7776000) || _isSuccessful(), "Failed the refund period is not finished");
737     //  90 days in seconds ==> 2*30*24*3600
738     if (_isSuccessful()) {
739       uint256 _tokensProjectToSend = _getTokenAmountToDistribute(100 - investors);
740       _getRemainingTokenStock(projectOwner, _tokensProjectToSend);
741       token.unlockToken();
742     } else {
743       wallet.transfer(EthRaisedIco);
744     }
745     
746     // burn in case that there is some not distributed tokens on the contract
747     if (token.balanceOf(address(this)) > 0) {
748       uint256 totalDistributedToken = tokenDistributed;
749       token.burn(address(this),totalDistributedToken);
750     }
751   }
752 
753   // -----------------------------------------
754   // Internal interface (extensible)
755   // -----------------------------------------
756 
757   /**
758    * @dev Override to extend the way in which ether is converted to tokens.
759    * @param _weiAmount Value in wei to be converted into tokens
760    * @return Number of tokens that can be purchased with the specified _weiAmount
761    */
762 
763   // Calcul the amount of token the benifiaciary will get by buying during Presale 
764   function _getTokenpresaleAmount(uint256 _weiAmount) internal view returns (uint256) {
765     uint256 _amountToSend = _weiAmount.div(Presalerate).mul(10 ** 10);
766     return _amountToSend;
767   }
768   
769   // Calcul the amount of token the benifiaciary will get by buying during Sale
770   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
771     uint256 _amountToSend = _weiAmount.div(Icorate).mul(10 ** 10);
772     return _amountToSend;
773   }
774 
775   // Calcul the token amount to distribute in the forwardFunds for the project (team, bounty ...)
776   function _getTokenAmountToDistribute(uint _part) internal view returns (uint256) {
777     uint256 _delivredTokens = tokenDistributed.add(tokenDistributedpresale);
778     return (_part.mul(_delivredTokens).div(investors));
779 
780   }
781 
782   // verify the remaining token stock & deliver tokens to the beneficiary
783   function _getRemainingTokenStock(address _beneficiary, uint256 _tokenAmount) internal {
784     if (token.balanceOf(address(this)) >= _tokenAmount) {
785       require(token.transfer(_beneficiary, _tokenAmount));
786     }
787     else {
788       if (token.balanceOf(address(this)) == 0) {
789         require(token.mint(_beneficiary, _tokenAmount));
790       }
791       else {
792         uint256 remainingTokenTocreate = _tokenAmount.sub(token.balanceOf(address(this)));
793         require(token.transfer(_beneficiary, token.balanceOf(address(this))));
794         require(token.mint(_beneficiary, remainingTokenTocreate));
795       }
796     }
797   }
798 
799   // Function to check the refund period
800   function _refundPeriod() internal view returns (bool){
801     require(!_isSuccessful(),"Failed refund period is not opened");
802     return ((!ico && !stateico) || (now > refundPeriod));
803   }
804 
805   // check if the ico is successful
806   function _isSuccessful() internal view returns (bool){
807     return (EthRaisedIco.add(EthRaisedpresale) >= ICOminCap);
808   }
809 
810 }