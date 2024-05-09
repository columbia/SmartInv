1 pragma solidity ^0.4.24;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5 
6   // The token being sold
7   ERC20Interface public token;
8 
9   // Address where funds are collected
10   address public wallet;
11 
12   // How many token units a buyer gets per wei
13   uint256 public rate;
14 
15   // Amount of wei raised
16   uint256 public weiRaised;
17 
18   /**
19    * Event for token purchase logging
20    * @param purchaser who paid for the tokens
21    * @param beneficiary who got the tokens
22    * @param value weis paid for purchase
23    * @param amount amount of tokens purchased
24    */
25   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
26 
27   /**
28    * @param _rate Number of token units a buyer gets per wei
29    * @param _wallet Address where collected funds will be forwarded to
30    * @param _token Address of the token being sold
31    */
32   constructor(uint256 _rate, address _wallet, ERC20Interface _token) public {
33     require(_rate > 0);
34     require(_wallet != address(0));
35     require(_token != address(0));
36 
37     rate = _rate;
38     wallet = _wallet;
39     token = _token;
40   }
41 
42   // -----------------------------------------
43   // Crowdsale external interface
44   // -----------------------------------------
45 
46   /**
47    * @dev fallback function ***DO NOT OVERRIDE***
48    */
49   function () external payable {
50     buyTokens(msg.sender);
51   }
52 
53   /**
54    * @dev low level token purchase ***DO NOT OVERRIDE***
55    * @param _beneficiary Address performing the token purchase
56    */
57   function buyTokens(address _beneficiary) public payable {
58 
59     uint256 weiAmount = msg.value;
60     _preValidatePurchase(_beneficiary, weiAmount);
61 
62     // calculate token amount to be created
63     uint256 tokens = _getTokenAmount(weiAmount);
64 
65     // update state
66     weiRaised = weiRaised.add(weiAmount);
67 
68     _processPurchase(_beneficiary, tokens);
69     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
70 
71     _updatePurchasingState(_beneficiary, weiAmount);
72 
73     _forwardFunds();
74     _postValidatePurchase(_beneficiary, weiAmount);
75   }
76 
77   // -----------------------------------------
78   // Internal interface (extensible)
79   // -----------------------------------------
80 
81   /**
82    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
83    * @param _beneficiary Address performing the token purchase
84    * @param _weiAmount Value in wei involved in the purchase
85    */
86   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
87     require(_beneficiary != address(0));
88     require(_weiAmount != 0);
89   }
90 
91   /**
92    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
93    * @param _beneficiary Address performing the token purchase
94    * @param _weiAmount Value in wei involved in the purchase
95    */
96   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
97     // optional override
98   }
99 
100   /**
101    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
102    * @param _beneficiary Address performing the token purchase
103    * @param _tokenAmount Number of tokens to be emitted
104    */
105   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
106     token.transfer(_beneficiary, _tokenAmount);
107   }
108 
109   /**
110    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
111    * @param _beneficiary Address receiving the tokens
112    * @param _tokenAmount Number of tokens to be purchased
113    */
114   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
115     _deliverTokens(_beneficiary, _tokenAmount);
116   }
117 
118   /**
119    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
120    * @param _beneficiary Address receiving the tokens
121    * @param _weiAmount Value in wei involved in the purchase
122    */
123   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
124     // optional override
125   }
126 
127   /**
128    * @dev Override to extend the way in which ether is converted to tokens.
129    * @param _weiAmount Value in wei to be converted into tokens
130    * @return Number of tokens that can be purchased with the specified _weiAmount
131    */
132   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
133     return _weiAmount.mul(rate);
134   }
135 
136   /**
137    * @dev Determines how ETH is stored/forwarded on purchases.
138    */
139   function _forwardFunds() internal {
140     wallet.transfer(msg.value);
141   }
142 }
143 
144 contract ERC20Interface {
145   function totalSupply() external view returns (uint256);
146   function balanceOf(address who) external view returns (uint256);
147   function transfer(address to, uint256 value) external returns (bool);
148   function allowance(address owner, address spender) external view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) external returns (bool);
150   function approve(address spender, uint256 value) external returns (bool);
151   event Transfer(address indexed from, address indexed to, uint256 value);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 contract ERC20Standard is ERC20Interface {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) balances;
159   mapping (address => mapping (address => uint256)) internal allowed;
160 
161   uint256 totalSupply_;
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) external returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     // SafeMath.sub will throw if there is not enough balance.
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     emit Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * 
205    * To avoid this issue, allowances are only allowed to be changed between zero and non-zero.
206    *
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) external returns (bool) {
211     require(allowed[msg.sender][_spender] == 0 || _value == 0);
212     allowed[msg.sender][_spender] = _value;
213     emit Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218   * @dev total number of tokens in existence
219   */
220   function totalSupply() external view returns (uint256) {
221     return totalSupply_;
222   }
223 
224   /**
225   * @dev Gets the balance of the specified address.
226   * @param _owner The address to query the the balance of.
227   * @return An uint256 representing the amount owned by the passed address.
228   */
229   function balanceOf(address _owner) external view returns (uint256 balance) {
230     return balances[_owner];
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(address _owner, address _spender) external view returns (uint256) {
240     return allowed[_owner][_spender];
241   }
242 
243   /**
244    * @dev Increase the amount of tokens that an owner allowed to a spender.
245    *
246    * approve should be called when allowed[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param _spender The address which will spend the funds.
251    * @param _addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
254     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To decrement
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _subtractedValue The amount of tokens to decrease the allowance by.
268    */
269   function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
270     uint oldValue = allowed[msg.sender][_spender];
271     if (_subtractedValue > oldValue) {
272       allowed[msg.sender][_spender] = 0;
273     } else {
274       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275     }
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280 }
281 
282 contract ERC223Interface {
283     function totalSupply() external view returns (uint256);
284     function balanceOf(address who) external view returns (uint256);
285     function transfer(address to, uint256 value) external returns (bool);
286     function transfer(address to, uint256 value, bytes data) external returns (bool);
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 }
289 
290 contract ERC223ReceivingContract { 
291 /**
292  * @dev Standard ERC223 function that will handle incoming token transfers.
293  *
294  * @param _from  Token sender address.
295  * @param _value Amount of tokens.
296  * @param _data  Transaction metadata.
297  */
298     function tokenFallback(address _from, uint _value, bytes _data) public;
299 }
300 
301 contract ERC223Standard is ERC223Interface, ERC20Standard {
302     using SafeMath for uint256;
303 
304     /**
305      * @dev Transfer the specified amount of tokens to the specified address.
306      *      Invokes the `tokenFallback` function if the recipient is a contract.
307      *      The token transfer fails if the recipient is a contract
308      *      but does not implement the `tokenFallback` function
309      *      or the fallback function to receive funds.
310      *
311      * @param _to    Receiver address.
312      * @param _value Amount of tokens that will be transferred.
313      * @param _data  Transaction metadata.
314      */
315     function transfer(address _to, uint256 _value, bytes _data) external returns(bool){
316         // Standard function transfer similar to ERC20 transfer with no _data .
317         // Added due to backwards compatibility reasons .
318         uint256 codeLength;
319 
320         assembly {
321             // Retrieve the size of the code on target address, this needs assembly .
322             codeLength := extcodesize(_to)
323         }
324 
325         balances[msg.sender] = balances[msg.sender].sub(_value);
326         balances[_to] = balances[_to].add(_value);
327         if(codeLength>0) {
328             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
329             receiver.tokenFallback(msg.sender, _value, _data);
330         }
331         emit Transfer(msg.sender, _to, _value);
332     }
333     
334     /**
335      * @dev Transfer the specified amount of tokens to the specified address.
336      *      This function works the same with the previous one
337      *      but doesn't contain `_data` param.
338      *      Added due to backwards compatibility reasons.
339      *
340      * @param _to    Receiver address.
341      * @param _value Amount of tokens that will be transferred.
342      */
343     function transfer(address _to, uint256 _value) external returns(bool){
344         uint256 codeLength;
345         bytes memory empty;
346 
347         assembly {
348             // Retrieve the size of the code on target address, this needs assembly .
349             codeLength := extcodesize(_to)
350         }
351 
352         balances[msg.sender] = balances[msg.sender].sub(_value);
353         balances[_to] = balances[_to].add(_value);
354         if(codeLength>0) {
355             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
356             receiver.tokenFallback(msg.sender, _value, empty);
357         }
358         emit Transfer(msg.sender, _to, _value);
359         return true;
360     }
361  
362 }
363 
364 contract Ownable {
365   address public owner;
366 
367 
368   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370 
371   /**
372    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
373    * account.
374    */
375   constructor() public {
376     owner = msg.sender;
377   }
378 
379   /**
380    * @dev Throws if called by any account other than the owner.
381    */
382   modifier onlyOwner() {
383     require(msg.sender == owner);
384     _;
385   }
386 
387   /**
388    * @dev Allows the current owner to transfer control of the contract to a newOwner.
389    * @param newOwner The address to transfer ownership to.
390    */
391   function transferOwnership(address newOwner) public onlyOwner {
392     require(newOwner != address(0));
393     emit OwnershipTransferred(owner, newOwner);
394     owner = newOwner;
395   }
396 
397 }
398 
399 contract MintableToken is ERC223Standard, Ownable {
400   event Mint(address indexed to, uint256 amount);
401   event MintFinished();
402 
403   bool public mintingFinished = false;
404 
405   modifier canMint() {
406     require(!mintingFinished);
407     _;
408   }
409 
410   /**
411    * @dev Function to mint tokens
412    * @param _to The address that will receive the minted tokens.
413    * @param _amount The amount of tokens to mint.
414    * @return A boolean that indicates if the operation was successful.
415    */
416   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
417     totalSupply_ = totalSupply_.add(_amount);
418     balances[_to] = balances[_to].add(_amount);
419     emit Mint(_to, _amount);
420     emit Transfer(address(0), _to, _amount);
421     return true;
422   }
423 
424   /**
425    * @dev Function to stop minting new tokens.
426    * @return True if the operation was successful.
427    */
428   function finishMinting() onlyOwner canMint public returns (bool) {
429     mintingFinished = true;
430     emit MintFinished();
431     return true;
432   }
433 }
434 
435 contract PoolAndSaleInterface {
436     address public tokenSaleAddr;
437     address public votingAddr;
438     address public votingTokenAddr;
439     uint256 public tap;
440     uint256 public initialTap;
441     uint256 public initialRelease;
442 
443     function setTokenSaleContract(address _tokenSaleAddr) external;
444     function startProject() external;
445 }
446 
447 library SafeMath {
448 
449   /**
450   * @dev Multiplies two numbers, throws on overflow.
451   */
452   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
453     if (a == 0) {
454       return 0;
455     }
456     uint256 c = a * b;
457     assert(c / a == b);
458     return c;
459   }
460 
461   /**
462   * @dev Integer division of two numbers, truncating the quotient.
463   */
464   function div(uint256 a, uint256 b) internal pure returns (uint256) {
465     // assert(b > 0); // Solidity automatically throws when dividing by 0
466     // uint256 c = a / b;
467     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
468     return a / b;
469   }
470 
471   /**
472   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
473   */
474   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
475     assert(b <= a);
476     return a - b;
477   }
478 
479   /**
480   * @dev Adds two numbers, throws on overflow.
481   */
482   function add(uint256 a, uint256 b) internal pure returns (uint256) {
483     uint256 c = a + b;
484     assert(c >= a);
485     return c;
486   }
487 }
488 
489 contract TimeLockPool{
490     using SafeMath for uint256;
491 
492     struct LockedBalance {
493       uint256 balance;
494       uint256 releaseTime;
495     }
496 
497     /*
498       structure: lockedBalnces[owner][token] = LockedBalance(balance, releaseTime);
499       token address = '0x0' stands for ETH (unit = wei)
500     */
501     mapping (address => mapping (address => LockedBalance[])) public lockedBalances;
502 
503     event Deposit(
504         address indexed owner,
505         address indexed tokenAddr,
506         uint256 amount,
507         uint256 releaseTime
508     );
509 
510     event Withdraw(
511         address indexed owner,
512         address indexed tokenAddr,
513         uint256 amount
514     );
515 
516     /// @dev Constructor. 
517     /// @return 
518     constructor() public {}
519 
520     /// @dev Deposit tokens to specific account with time-lock.
521     /// @param tokenAddr The contract address of a ERC20/ERC223 token.
522     /// @param account The owner of deposited tokens.
523     /// @param amount Amount to deposit.
524     /// @param releaseTime Time-lock period.
525     /// @return True if it is successful, revert otherwise.
526     function depositERC20 (
527         address tokenAddr,
528         address account,
529         uint256 amount,
530         uint256 releaseTime
531     ) external returns (bool) {
532         require(account != address(0x0));
533         require(tokenAddr != 0x0);
534         require(msg.value == 0);
535         require(amount > 0);
536         require(ERC20Interface(tokenAddr).transferFrom(msg.sender, this, amount));
537 
538         lockedBalances[account][tokenAddr].push(LockedBalance(amount, releaseTime));
539         emit Deposit(account, tokenAddr, amount, releaseTime);
540 
541         return true;
542     }
543 
544     /// @dev Deposit ETH to specific account with time-lock.
545     /// @param account The owner of deposited tokens.
546     /// @param releaseTime Timestamp to release the fund.
547     /// @return True if it is successful, revert otherwise.
548     function depositETH (
549         address account,
550         uint256 releaseTime
551     ) external payable returns (bool) {
552         require(account != address(0x0));
553         address tokenAddr = address(0x0);
554         uint256 amount = msg.value;
555         require(amount > 0);
556 
557         lockedBalances[account][tokenAddr].push(LockedBalance(amount, releaseTime));
558         emit Deposit(account, tokenAddr, amount, releaseTime);
559 
560         return true;
561     }
562 
563     /// @dev Release the available balance of an account.
564     /// @param account An account to receive tokens.
565     /// @param tokenAddr An address of ERC20/ERC223 token.
566     /// @param index_from Starting index of records to withdraw.
567     /// @param index_to Ending index of records to withdraw.
568     /// @return True if it is successful, revert otherwise.
569     function withdraw (address account, address tokenAddr, uint256 index_from, uint256 index_to) external returns (bool) {
570         require(account != address(0x0));
571 
572         uint256 release_amount = 0;
573         for (uint256 i = index_from; i < lockedBalances[account][tokenAddr].length && i < index_to + 1; i++) {
574             if (lockedBalances[account][tokenAddr][i].balance > 0 &&
575                 lockedBalances[account][tokenAddr][i].releaseTime <= block.timestamp) {
576 
577                 release_amount = release_amount.add(lockedBalances[account][tokenAddr][i].balance);
578                 lockedBalances[account][tokenAddr][i].balance = 0;
579             }
580         }
581 
582         require(release_amount > 0);
583 
584         if (tokenAddr == 0x0) {
585             if (!account.send(release_amount)) {
586                 revert();
587             }
588             emit Withdraw(account, tokenAddr, release_amount);
589             return true;
590         } else {
591             if (!ERC20Interface(tokenAddr).transfer(account, release_amount)) {
592                 revert();
593             }
594             emit Withdraw(account, tokenAddr, release_amount);
595             return true;
596         }
597     }
598 
599     /// @dev Returns total amount of balances which already passed release time.
600     /// @param account An account to receive tokens.
601     /// @param tokenAddr An address of ERC20/ERC223 token.
602     /// @return Available balance of specified token.
603     function getAvailableBalanceOf (address account, address tokenAddr) 
604         external
605         view
606         returns (uint256)
607     {
608         require(account != address(0x0));
609 
610         uint256 balance = 0;
611         for(uint256 i = 0; i < lockedBalances[account][tokenAddr].length; i++) {
612             if (lockedBalances[account][tokenAddr][i].releaseTime <= block.timestamp) {
613                 balance = balance.add(lockedBalances[account][tokenAddr][i].balance);
614             }
615         }
616         return balance;
617     }
618 
619     /// @dev Returns total amount of balances which are still locked.
620     /// @param account An account to receive tokens.
621     /// @param tokenAddr An address of ERC20/ERC223 token.
622     /// @return Locked balance of specified token.
623     function getLockedBalanceOf (address account, address tokenAddr)
624         external
625         view
626         returns (uint256) 
627     {
628         require(account != address(0x0));
629 
630         uint256 balance = 0;
631         for(uint256 i = 0; i < lockedBalances[account][tokenAddr].length; i++) {
632             if(lockedBalances[account][tokenAddr][i].releaseTime > block.timestamp) {
633                 balance = balance.add(lockedBalances[account][tokenAddr][i].balance);
634             }
635         }
636         return balance;
637     }
638 
639     /// @dev Returns next release time of locked balances.
640     /// @param account An account to receive tokens.
641     /// @param tokenAddr An address of ERC20/ERC223 token.
642     /// @return Timestamp of next release.
643     function getNextReleaseTimeOf (address account, address tokenAddr)
644         external
645         view
646         returns (uint256) 
647     {
648         require(account != address(0x0));
649 
650         uint256 nextRelease = 2**256 - 1;
651         for (uint256 i = 0; i < lockedBalances[account][tokenAddr].length; i++) {
652             if (lockedBalances[account][tokenAddr][i].releaseTime > block.timestamp &&
653                lockedBalances[account][tokenAddr][i].releaseTime < nextRelease) {
654 
655                 nextRelease = lockedBalances[account][tokenAddr][i].releaseTime;
656             }
657         }
658 
659         /* returns 0 if there are no more locked balances. */
660         if (nextRelease == 2**256 - 1) {
661             nextRelease = 0;
662         }
663         return nextRelease;
664     }
665 }
666 
667 contract TimedCrowdsale is Crowdsale {
668   using SafeMath for uint256;
669 
670   uint256 public openingTime;
671   uint256 public closingTime;
672 
673   /**
674    * @dev Reverts if not in crowdsale time range.
675    */
676   modifier onlyWhileOpen {
677     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
678     _;
679   }
680 
681   /**
682    * @dev Constructor, takes crowdsale opening and closing times.
683    * @param _openingTime Crowdsale opening time
684    * @param _closingTime Crowdsale closing time
685    */
686   constructor(uint256 _openingTime, uint256 _closingTime) public {
687     require(_openingTime >= block.timestamp);
688     require(_closingTime >= _openingTime);
689 
690     openingTime = _openingTime;
691     closingTime = _closingTime;
692   }
693 
694   /**
695    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
696    * @return Whether crowdsale period has elapsed
697    */
698   function hasClosed() public view returns (bool) {
699     return block.timestamp > closingTime;
700   }
701 
702   /**
703    * @dev Extend parent behavior requiring to be within contributing period
704    * @param _beneficiary Token purchaser
705    * @param _weiAmount Amount of wei contributed
706    */
707   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
708     super._preValidatePurchase(_beneficiary, _weiAmount);
709   }
710 
711 }
712 
713 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
714   using SafeMath for uint256;
715 
716   bool public isFinalized = false;
717 
718   event Finalized();
719 
720   /**
721    * @dev Must be called after crowdsale ends, to do some extra finalization
722    * work. Calls the contract's finalization function.
723    */
724   function finalize() onlyOwner public {
725     require(!isFinalized);
726     require(hasClosed());
727 
728     finalization();
729     emit Finalized();
730 
731     isFinalized = true;
732   }
733 
734   /**
735    * @dev Can be overridden to add finalization logic. The overriding function
736    * should call super.finalization() to ensure the chain of finalization is
737    * executed entirely.
738    */
739   function finalization() internal {
740   }
741 
742 }
743 
744 contract TokenController is Ownable {
745     using SafeMath for uint256;
746 
747     MintableToken public targetToken;
748     address public votingAddr;
749     address public tokensaleManagerAddr;
750 
751     State public state;
752 
753     enum State {
754         Init,
755         Tokensale,
756         Public
757     }
758 
759     /// @dev The deployer must change the ownership of the target token to this contract.
760     /// @param _targetToken : The target token this contract manage the rights to mint.
761     /// @return 
762     constructor (
763         MintableToken _targetToken
764     ) public {
765         targetToken = MintableToken(_targetToken);
766         state = State.Init;
767     }
768 
769     /// @dev Mint and distribute specified amount of tokens to an address.
770     /// @param to An address that receive the minted tokens.
771     /// @param amount Amount to mint.
772     /// @return True if the distribution is successful, revert otherwise.
773     function mint (address to, uint256 amount) external returns (bool) {
774         /*
775           being called from voting contract will be available in the future
776           ex. if (state == State.Public && msg.sender == votingAddr) 
777         */
778 
779         if ((state == State.Init && msg.sender == owner) ||
780             (state == State.Tokensale && msg.sender == tokensaleManagerAddr)) {
781             return targetToken.mint(to, amount);
782         }
783 
784         revert();
785     }
786 
787     /// @dev Change the phase from "Init" to "Tokensale".
788     /// @param _tokensaleManagerAddr A contract address of token-sale.
789     /// @return True if the change of the phase is successful, revert otherwise.
790     function openTokensale (address _tokensaleManagerAddr)
791         external
792         onlyOwner
793         returns (bool)
794     {
795         /* check if the owner of the target token is set to this contract */
796         require(MintableToken(targetToken).owner() == address(this));
797         require(state == State.Init);
798         require(_tokensaleManagerAddr != address(0x0));
799 
800         tokensaleManagerAddr = _tokensaleManagerAddr;
801         state = State.Tokensale;
802         return true;
803     }
804 
805     /// @dev Change the phase from "Tokensale" to "Public". This function will be
806     ///      cahnged in the future to receive an address of voting contract as an
807     ///      argument in order to handle the result of minting proposal.
808     /// @return True if the change of the phase is successful, revert otherwise.
809     function closeTokensale () external returns (bool) {
810         require(state == State.Tokensale && msg.sender == tokensaleManagerAddr);
811 
812         state = State.Public;
813         return true;
814     }
815 
816     /// @dev Check if the state is "Init" or not.
817     /// @return True if the state is "Init", false otherwise.
818     function isStateInit () external view returns (bool) {
819         return (state == State.Init);
820     }
821 
822     /// @dev Check if the state is "Tokensale" or not.
823     /// @return True if the state is "Tokensale", false otherwise.
824     function isStateTokensale () external view returns (bool) {
825         return (state == State.Tokensale);
826     }
827 
828     /// @dev Check if the state is "Public" or not.
829     /// @return True if the state is "Public", false otherwise.
830     function isStatePublic () external view returns (bool) {
831         return (state == State.Public);
832     }
833 }
834 
835 contract TokenSaleManager is Ownable {
836     using SafeMath for uint256;
837 
838     ERC20Interface public token;
839     address public poolAddr;
840     address public tokenControllerAddr;
841     address public timeLockPoolAddr;
842     address[] public tokenSales;
843     mapping( address => bool ) public tokenSaleIndex;
844     bool public isStarted = false;
845     bool public isFinalized = false;
846 
847     modifier onlyDaicoPool {
848         require(msg.sender == poolAddr);
849         _;
850     }
851 
852     modifier onlyTokenSale {
853         require(tokenSaleIndex[msg.sender]);
854         _;
855     }
856 
857     /// @dev Constructor. It set the DaicoPool to receive the starting signal from this contract.
858     /// @param _tokenControllerAddr The contract address of TokenController.
859     /// @param _timeLockPoolAddr The contract address of a TimeLockPool.
860     /// @param _daicoPoolAddr The contract address of DaicoPool.
861     /// @param _token The contract address of a ERC20 token.
862     constructor (
863         address _tokenControllerAddr,
864         address _timeLockPoolAddr,
865         address _daicoPoolAddr,
866         ERC20Interface _token
867     ) public {
868         require(_tokenControllerAddr != address(0x0));
869         tokenControllerAddr = _tokenControllerAddr;
870 
871         require(_timeLockPoolAddr != address(0x0));
872         timeLockPoolAddr = _timeLockPoolAddr;
873 
874         token = _token;
875 
876         poolAddr = _daicoPoolAddr;
877         require(PoolAndSaleInterface(poolAddr).votingTokenAddr() == address(token));
878         PoolAndSaleInterface(poolAddr).setTokenSaleContract(this);
879 
880     }
881 
882     /// @dev This contract doen't receive any ETH.
883     function() external payable {
884         revert();
885     }
886 
887     /// @dev Add a new token sale with specific parameters. New sale should start
888     /// @dev after the previous one closed.
889     /// @param openingTime A timestamp of the date this sale will start.
890     /// @param closingTime A timestamp of the date this sale will end.
891     /// @param tokensCap Number of tokens to be sold. Can be 0 if it accepts carryover.
892     /// @param rate Number of tokens issued with 1 ETH. [minimal unit of the token / ETH]  
893     /// @param carryover If true, unsold tokens will be carryovered to next sale. 
894     /// @param timeLockRate Specified rate of issued tokens will be locked. ex. 50 = 50%
895     /// @param timeLockEnd A timestamp of the date locked tokens will be released.
896     /// @param minAcceptableWei Minimum contribution.
897     function addTokenSale (
898         uint256 openingTime,
899         uint256 closingTime,
900         uint256 tokensCap,
901         uint256 rate,
902         bool carryover,
903         uint256 timeLockRate,
904         uint256 timeLockEnd,
905         uint256 minAcceptableWei
906     ) external onlyOwner {
907         require(!isStarted);
908         require(
909             tokenSales.length == 0 ||
910             TimedCrowdsale(tokenSales[tokenSales.length-1]).closingTime() < openingTime
911         );
912 
913         require(TokenController(tokenControllerAddr).state() == TokenController.State.Init);
914 
915         tokenSales.push(new TokenSale(
916             rate,
917             token,
918             poolAddr,
919             openingTime,
920             closingTime,
921             tokensCap,
922             timeLockRate,
923             timeLockEnd,
924             carryover,
925             minAcceptableWei
926         ));
927         tokenSaleIndex[tokenSales[tokenSales.length-1]] = true;
928 
929     }
930 
931     /// @dev Initialize the tokensales. No other sales can be added after initialization.
932     /// @return True if successful, revert otherwise.
933     function initialize () external onlyOwner returns (bool) {
934         require(!isStarted);
935         TokenSale(tokenSales[0]).initialize(0);
936         isStarted = true;
937     }
938 
939     /// @dev Request TokenController to mint new tokens. This function is only called by 
940     /// @dev token sales.
941     /// @param _beneficiary The address to receive the new tokens.
942     /// @param _tokenAmount Token amount to be minted.
943     /// @return True if successful, revert otherwise.
944     function mint (
945         address _beneficiary,
946         uint256 _tokenAmount
947     ) external onlyTokenSale returns(bool) {
948         require(isStarted && !isFinalized);
949         require(TokenController(tokenControllerAddr).mint(_beneficiary, _tokenAmount));
950         return true;
951     }
952 
953     /// @dev Mint new tokens with time-lock. This function is only called by token sales.
954     /// @param _beneficiary The address to receive the new tokens.
955     /// @param _tokenAmount Token amount to be minted.
956     /// @param _releaseTime A timestamp of the date locked tokens will be released.
957     /// @return True if successful, revert otherwise.
958     function mintTimeLocked (
959         address _beneficiary,
960         uint256 _tokenAmount,
961         uint256 _releaseTime
962     ) external onlyTokenSale returns(bool) {
963         require(isStarted && !isFinalized);
964         require(TokenController(tokenControllerAddr).mint(this, _tokenAmount));
965         require(ERC20Interface(token).approve(timeLockPoolAddr, _tokenAmount));
966         require(TimeLockPool(timeLockPoolAddr).depositERC20(
967             token,
968             _beneficiary,
969             _tokenAmount,
970             _releaseTime
971         ));
972         return true;
973     }
974 
975     /// @dev Adds single address to whitelist of all token sales.
976     /// @param _beneficiary Address to be added to the whitelist
977     function addToWhitelist(address _beneficiary) external onlyOwner {
978         require(isStarted);
979         for (uint256 i = 0; i < tokenSales.length; i++ ) {
980             WhitelistedCrowdsale(tokenSales[i]).addToWhitelist(_beneficiary);
981         }
982     }
983 
984     /// @dev Adds multiple addresses to whitelist of all token sales.
985     /// @param _beneficiaries Addresses to be added to the whitelist
986     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
987         require(isStarted);
988         for (uint256 i = 0; i < tokenSales.length; i++ ) {
989             WhitelistedCrowdsale(tokenSales[i]).addManyToWhitelist(_beneficiaries);
990         }
991     }
992 
993 
994     /// @dev Finalize the specific token sale. Can be done if end date has come or 
995     /// @dev all tokens has been sold out. It process carryover if it is set.
996     /// @param _indexTokenSale index of the target token sale. 
997     function finalize (uint256 _indexTokenSale) external {
998         require(isStarted && !isFinalized);
999         TokenSale ts = TokenSale(tokenSales[_indexTokenSale]);
1000 
1001         if (ts.canFinalize()) {
1002             ts.finalize();
1003             uint256 carryoverAmount = 0;
1004             if (ts.carryover() &&
1005                 ts.tokensCap() > ts.tokensMinted() &&
1006                 _indexTokenSale.add(1) < tokenSales.length) {
1007                 carryoverAmount = ts.tokensCap().sub(ts.tokensMinted());
1008             } 
1009             if(_indexTokenSale.add(1) < tokenSales.length) {
1010                 TokenSale(tokenSales[_indexTokenSale.add(1)]).initialize(carryoverAmount);
1011             }
1012         }
1013 
1014     }
1015 
1016     /// @dev Finalize the manager. Can be done if all token sales are already finalized.
1017     /// @dev It makes the DaicoPool open the TAP.
1018     function finalizeTokenSaleManager () external{
1019         require(isStarted && !isFinalized);
1020         for (uint256 i = 0; i < tokenSales.length; i++ ) {
1021             require(FinalizableCrowdsale(tokenSales[i]).isFinalized());
1022         }
1023         require(TokenController(tokenControllerAddr).closeTokensale());
1024         isFinalized = true;
1025         PoolAndSaleInterface(poolAddr).startProject();
1026     }
1027 }
1028 
1029 contract WhitelistedCrowdsale is Crowdsale, Ownable {
1030 
1031   mapping(address => bool) public whitelist;
1032 
1033   /**
1034    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
1035    */
1036   modifier isWhitelisted(address _beneficiary) {
1037     require(whitelist[_beneficiary]);
1038     _;
1039   }
1040 
1041   /**
1042    * @dev Adds single address to whitelist.
1043    * @param _beneficiary Address to be added to the whitelist
1044    */
1045   function addToWhitelist(address _beneficiary) external onlyOwner {
1046     whitelist[_beneficiary] = true;
1047   }
1048 
1049   /**
1050    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
1051    * @param _beneficiaries Addresses to be added to the whitelist
1052    */
1053   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
1054     for (uint256 i = 0; i < _beneficiaries.length; i++) {
1055       whitelist[_beneficiaries[i]] = true;
1056     }
1057   }
1058 
1059   /**
1060    * @dev Removes single address from whitelist.
1061    * @param _beneficiary Address to be removed to the whitelist
1062    */
1063   function removeFromWhitelist(address _beneficiary) external onlyOwner {
1064     whitelist[_beneficiary] = false;
1065   }
1066 
1067   /**
1068    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1069    * @param _beneficiary Token beneficiary
1070    * @param _weiAmount Amount of wei contributed
1071    */
1072   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
1073     super._preValidatePurchase(_beneficiary, _weiAmount);
1074   }
1075 
1076 }
1077 
1078 contract TokenSale is FinalizableCrowdsale,
1079                       WhitelistedCrowdsale {
1080     using SafeMath for uint256;
1081 
1082     address public managerAddr; 
1083     address public poolAddr;
1084     bool public isInitialized = false;
1085     uint256 public timeLockRate;
1086     uint256 public timeLockEnd;
1087     uint256 public tokensMinted = 0;
1088     uint256 public tokensCap;
1089     uint256 public minAcceptableWei;
1090     bool public carryover;
1091 
1092     modifier onlyManager{
1093         require(msg.sender == managerAddr);
1094         _;
1095     }
1096 
1097     /// @dev Constructor.
1098     /// @param _rate Number of tokens issued with 1 ETH. [minimal unit of the token / ETH]
1099     /// @param _token The contract address of a ERC20 token.
1100     /// @param _poolAddr The contract address of DaicoPool.
1101     /// @param _openingTime A timestamp of the date this sale will start.
1102     /// @param _closingTime A timestamp of the date this sale will end.
1103     /// @param _tokensCap Number of tokens to be sold. Can be 0 if it accepts carryover.
1104     /// @param _timeLockRate Specified rate of issued tokens will be locked. ex. 50 = 50%
1105     /// @param _timeLockEnd A timestamp of the date locked tokens will be released.
1106     /// @param _carryover If true, unsold tokens will be carryovered to next sale. 
1107     /// @param _minAcceptableWei Minimum contribution.
1108     /// @return 
1109     constructor (
1110         uint256 _rate, /* The unit of rate is [nano tokens / ETH] in this contract */
1111         ERC20Interface _token,
1112         address _poolAddr,
1113         uint256 _openingTime,
1114         uint256 _closingTime,
1115         uint256 _tokensCap,
1116         uint256 _timeLockRate,
1117         uint256 _timeLockEnd,
1118         bool _carryover,
1119         uint256 _minAcceptableWei
1120     ) public Crowdsale(_rate, _poolAddr, _token) TimedCrowdsale(_openingTime, _closingTime) {
1121         require(_timeLockRate >= 0 && _timeLockRate <=100);
1122         require(_poolAddr != address(0x0));
1123 
1124         managerAddr = msg.sender;
1125         poolAddr = _poolAddr;
1126         timeLockRate = _timeLockRate;
1127         timeLockEnd = _timeLockEnd;
1128         tokensCap = _tokensCap;
1129         carryover = _carryover;
1130         minAcceptableWei = _minAcceptableWei;
1131     }
1132 
1133     /// @dev Initialize the sale. If carryoverAmount is given, it added the tokens to be sold.
1134     /// @param carryoverAmount Amount of tokens to be added to capTokens.
1135     /// @return 
1136     function initialize(uint256 carryoverAmount) external onlyManager {
1137         require(!isInitialized);
1138         isInitialized = true;
1139         tokensCap = tokensCap.add(carryoverAmount);
1140     }
1141 
1142     /// @dev Finalize the sale. It transfers all the funds it has. Can be repeated.
1143     /// @return 
1144     function finalize() onlyOwner public {
1145         //require(!isFinalized);
1146         require(isInitialized);
1147         require(canFinalize());
1148 
1149         finalization();
1150         emit Finalized();
1151 
1152         isFinalized = true;
1153     }
1154 
1155     /// @dev Check if the sale can be finalized.
1156     /// @return True if closing time has come or tokens are sold out.
1157     function canFinalize() public view returns(bool) {
1158         return (hasClosed() || (isInitialized && tokensCap <= tokensMinted));
1159     }
1160 
1161 
1162     /// @dev It transfers all the funds it has.
1163     /// @return 
1164     function finalization() internal {
1165         if(address(this).balance > 0){
1166             poolAddr.transfer(address(this).balance);
1167         }
1168     }
1169 
1170     /**
1171      * @dev Overrides delivery by minting tokens upon purchase.
1172      * @param _beneficiary Token purchaser
1173      * @param _tokenAmount Number of tokens to be minted
1174      */
1175     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
1176         //require(tokensMinted.add(_tokenAmount) <= tokensCap);
1177         require(tokensMinted < tokensCap);
1178 
1179         uint256 time_locked = _tokenAmount.mul(timeLockRate).div(100); 
1180         uint256 instant = _tokenAmount.sub(time_locked);
1181 
1182         if (instant > 0) {
1183             require(TokenSaleManager(managerAddr).mint(_beneficiary, instant));
1184         }
1185         if (time_locked > 0) {
1186             require(TokenSaleManager(managerAddr).mintTimeLocked(
1187                 _beneficiary,
1188                 time_locked,
1189                 timeLockEnd
1190             ));
1191         }
1192   
1193         tokensMinted = tokensMinted.add(_tokenAmount);
1194     }
1195 
1196     /// @dev Overrides _forwardFunds to do nothing. 
1197     function _forwardFunds() internal {}
1198 
1199     /// @dev Overrides _preValidatePurchase to check minimam contribution and initialization.
1200     /// @param _beneficiary Token purchaser
1201     /// @param _weiAmount weiAmount to pay
1202     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1203         super._preValidatePurchase(_beneficiary, _weiAmount);
1204         require(isInitialized);
1205         require(_weiAmount >= minAcceptableWei);
1206     }
1207 
1208     /**
1209      * @dev Overridden in order to change the unit of rate with [nano toekns / ETH]
1210      * instead of original [minimal unit of the token / wei].
1211      * @param _weiAmount Value in wei to be converted into tokens
1212      * @return Number of tokens that can be purchased with the specified _weiAmount
1213      */
1214     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1215       return _weiAmount.mul(rate).div(10**18); //The unit of rate is [nano tokens / ETH].
1216     }
1217 
1218 }