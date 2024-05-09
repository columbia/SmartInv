1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  * https://github.com/OpenZeppelin/zeppelin-solidity/
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 
20 
21 /**
22  * @title SafeERC20
23  * @dev Wrappers around ERC20 operations that throw on failure.
24  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
25  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
26  */
27 library SafeERC20 {
28   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
29     assert(token.transfer(to, value));
30   }
31 
32   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
33     assert(token.transferFrom(from, to, value));
34   }
35 
36   function safeApprove(ERC20 token, address spender, uint256 value) internal {
37     assert(token.approve(spender, value));
38   }
39 }
40 
41 
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  * https://github.com/OpenZeppelin/zeppelin-solidity/
48  */
49 contract Ownable {
50   address public owner;                                                     // Operational owner.
51   address public masterOwner = 0xe4925C73851490401b858B657F26E62e9aD20F66;  // for ownership transfer segregation of duty, hard coded to wallet account
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public {
79     require(newOwner != address(0));
80     require(masterOwner == msg.sender); // only master owner can initiate change to ownership
81     OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 }
85 
86 
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  * https://github.com/OpenZeppelin/zeppelin-solidity/
93  */
94 library SafeMath {
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     if (a == 0) {
97       return 0;
98     }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 
122   function cei(uint256 a, uint256 b) internal pure returns (uint256) {
123     return ((a + b - 1) / b) * b;
124   }
125 }
126 
127 
128 
129 
130 
131 
132 
133 
134 
135 
136 
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     // SafeMath.sub will throw if there is not enough balance.
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256 balance) {
169     return balances[_owner];
170   }
171 
172 }
173 
174 
175 
176 
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  * https://github.com/OpenZeppelin/zeppelin-solidity/
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/ethereum/EIPs/issues/20
196  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
210     require(_to != address(0));
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(address _owner, address _spender) public view returns (uint256) {
244     return allowed[_owner][_spender];
245   }
246 
247   /**
248    * @dev Increase the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To increment
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _addedValue The amount of tokens to increase the allowance by.
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
274     uint oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue > oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284 }
285 
286 
287 /** This interfaces will be implemented by different VZT contracts in future*/
288 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
289 
290 contract VZToken is StandardToken, Ownable {
291 
292 
293     /* metadata */
294 
295     string public constant name = "VectorZilla Token"; // solium-disable-line uppercase
296     string public constant symbol = "VZT"; // solium-disable-line uppercase
297     string public constant version = "1.0"; // solium-disable-line uppercase
298     uint8 public constant decimals = 18; // solium-disable-line uppercase
299 
300     /* all accounts in wei */
301 
302     uint256 public constant INITIAL_SUPPLY = 100000000 * 10 ** 18; //intial total supply
303     uint256 public constant BURNABLE_UP_TO =  90000000 * 10 ** 18; //burnable up to 90% (90 million) of total supply
304     uint256 public constant VECTORZILLA_RESERVE_VZT = 25000000 * 10 ** 18; //25 million - reserved tokens
305 
306     // Reserved tokens will be sent to this address. this address will be replaced on production:
307     address public constant VECTORZILLA_RESERVE = 0xF63e65c57024886cCa65985ca6E2FB38df95dA11;
308 
309     // - tokenSaleContract receives the whole balance for distribution
310     address public tokenSaleContract;
311 
312     /* Following stuff is to manage regulatory hurdles on who can and cannot use VZT token  */
313     mapping (address => bool) public frozenAccount;
314     event FrozenFunds(address target, bool frozen);
315 
316 
317     /** Modifiers to be used all over the place **/
318 
319     modifier onlyOwnerAndContract() {
320         require(msg.sender == owner || msg.sender == tokenSaleContract);
321         _;
322     }
323 
324 
325     modifier onlyWhenValidAddress( address _addr ) {
326         require(_addr != address(0x0));
327         _;
328     }
329 
330     modifier onlyWhenValidContractAddress(address _addr) {
331         require(_addr != address(0x0));
332         require(_addr != address(this));
333         require(isContract(_addr));
334         _;
335     }
336 
337     modifier onlyWhenBurnable(uint256 _value) {
338         require(totalSupply - _value >= INITIAL_SUPPLY - BURNABLE_UP_TO);
339         _;
340     }
341 
342     modifier onlyWhenNotFrozen(address _addr) {
343         require(!frozenAccount[_addr]);
344         _;
345     }
346 
347     /** End of Modifier Definations */
348 
349     /** Events */
350 
351     event Burn(address indexed burner, uint256 value);
352     event Finalized();
353     //log event whenever withdrawal from this contract address happens
354     event Withdraw(address indexed from, address indexed to, uint256 value);
355 
356     /*
357         Contructor that distributes initial supply between
358         owner and vzt reserve.
359     */
360     function VZToken(address _owner) public {
361         require(_owner != address(0));
362         totalSupply = INITIAL_SUPPLY;
363         balances[_owner] = INITIAL_SUPPLY - VECTORZILLA_RESERVE_VZT; //75 millions tokens
364         balances[VECTORZILLA_RESERVE] = VECTORZILLA_RESERVE_VZT; //25 millions
365         owner = _owner;
366     }
367 
368     /*
369         This unnamed function is called whenever the owner send Ether to fund the gas
370         fees and gas reimbursement.
371     */
372     function () payable public onlyOwner {}
373 
374     /**
375      * @dev transfer `_value` token for a specified address
376      * @param _to The address to transfer to.
377      * @param _value The amount to be transferred.
378      */
379     function transfer(address _to, uint256 _value) 
380         public
381         onlyWhenValidAddress(_to)
382         onlyWhenNotFrozen(msg.sender)
383         onlyWhenNotFrozen(_to)
384         returns(bool) {
385         return super.transfer(_to, _value);
386     }
387 
388     /**
389      * @dev Transfer `_value` tokens from one address (`_from`) to another (`_to`)
390      * @param _from address The address which you want to send tokens from
391      * @param _to address The address which you want to transfer to
392      * @param _value uint256 the amount of tokens to be transferred
393      */
394     function transferFrom(address _from, address _to, uint256 _value) 
395         public
396         onlyWhenValidAddress(_to)
397         onlyWhenValidAddress(_from)
398         onlyWhenNotFrozen(_from)
399         onlyWhenNotFrozen(_to)
400         returns(bool) {
401         return super.transferFrom(_from, _to, _value);
402     }
403 
404     /**
405      * @dev Burns a specific (`_value`) amount of tokens.
406      * @param _value uint256 The amount of token to be burned.
407      */
408     function burn(uint256 _value)
409         public
410         onlyWhenBurnable(_value)
411         onlyWhenNotFrozen(msg.sender)
412         returns (bool) {
413         require(_value <= balances[msg.sender]);
414       // no need to require value <= totalSupply, since that would imply the
415       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
416         address burner = msg.sender;
417         balances[burner] = balances[burner].sub(_value);
418         totalSupply = totalSupply.sub(_value);
419         Burn(burner, _value);
420         Transfer(burner, address(0x0), _value);
421         return true;
422       }
423 
424     /**
425      * Destroy tokens from other account
426      *
427      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
428      *
429      * @param _from the address of the sender
430      * @param _value the amount of money to burn
431      */
432     function burnFrom(address _from, uint256 _value) 
433         public
434         onlyWhenBurnable(_value)
435         onlyWhenNotFrozen(_from)
436         onlyWhenNotFrozen(msg.sender)
437         returns (bool success) {
438         assert(transferFrom( _from, msg.sender, _value ));
439         return burn(_value);
440     }
441 
442     /**
443      * Set allowance for other address and notify
444      *
445      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
446      *
447      * @param _spender The address authorized to spend
448      * @param _value the max amount they can spend
449      * @param _extraData some extra information to send to the approved contract
450      */
451     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
452         public
453         onlyWhenValidAddress(_spender)
454         returns (bool success) {
455         tokenRecipient spender = tokenRecipient(_spender);
456         if (approve(_spender, _value)) {
457             spender.receiveApproval(msg.sender, _value, this, _extraData);
458             return true;
459         }
460     }
461 
462     /**
463      * Freezes account and disables transfers/burning
464      *  This is to manage regulatory hurdlers where contract owner is required to freeze some accounts.
465      */
466     function freezeAccount(address target, bool freeze) external onlyOwner {
467         frozenAccount[target] = freeze;
468         FrozenFunds(target, freeze);
469     }
470 
471     /* Owner withdrawal of an ether deposited from Token ether balance */
472     function withdrawToOwner(uint256 weiAmt) public onlyOwner {
473         // do not allow zero transfer
474         require(weiAmt > 0);
475         owner.transfer(weiAmt);
476         // signal the event for communication only it is meaningful
477         Withdraw(this, msg.sender, weiAmt);
478     }
479 
480 
481     /// @notice This method can be used by the controller to extract mistakenly
482     ///  sent tokens to this contract.
483     /// @param _token The address of the token contract that you want to recover
484     ///  set to 0 in case you want to extract ether.
485     function claimTokens(address _token) external onlyOwner {
486         if (_token == 0x0) {
487             owner.transfer(this.balance);
488             return;
489         }
490         StandardToken token = StandardToken(_token);
491         uint balance = token.balanceOf(this);
492         token.transfer(owner, balance);
493         // signal the event for communication only it is meaningful
494         Withdraw(this, owner, balance);
495     }
496 
497     function setTokenSaleContract(address _tokenSaleContract)
498         external
499         onlyWhenValidContractAddress(_tokenSaleContract)
500         onlyOwner {
501            require(_tokenSaleContract != tokenSaleContract);
502            tokenSaleContract = _tokenSaleContract;
503     }
504 
505     /// @dev Internal function to determine if an address is a contract
506     /// @param _addr address The address being queried
507     /// @return True if `_addr` is a contract
508     function isContract(address _addr) constant internal returns(bool) {
509         if (_addr == 0) {
510             return false;
511         }
512         uint256 size;
513         assembly {
514             size: = extcodesize(_addr)
515         }
516         return (size > 0);
517     }
518 
519     /**
520      * @dev Function to send `_value` tokens to user (`_to`) from sale contract/owner
521      * @param _to address The address that will receive the minted tokens.
522      * @param _value uint256 The amount of tokens to be sent.
523      * @return True if the operation was successful.
524      */
525     function sendToken(address _to, uint256 _value)
526         public
527         onlyWhenValidAddress(_to)
528         onlyOwnerAndContract
529         returns(bool) {
530         address _from = owner;
531         // Check if the sender has enough
532         require(balances[_from] >= _value);
533         // Check for overflows
534         require(balances[_to] + _value > balances[_to]);
535         // Save this for an assertion in the future
536         uint256 previousBalances = balances[_from] + balances[_to];
537         // Subtract from the sender
538         balances[_from] -= _value;
539         // Add the same to the recipient
540         balances[_to] += _value;
541         Transfer(_from, _to, _value);
542         // Asserts are used to use static analysis to find bugs in your code. They should never fail
543         assert(balances[_from] + balances[_to] == previousBalances);
544         return true;
545     }
546     /**
547      * @dev Batch transfer of tokens to addresses from owner's balance
548      * @param addresses address[] The address that will receive the minted tokens.
549      * @param _values uint256[] The amount of tokens to be sent.
550      * @return True if the operation was successful.
551      */
552     function batchSendTokens(address[] addresses, uint256[] _values) 
553         public onlyOwnerAndContract
554         returns (bool) {
555         require(addresses.length == _values.length);
556         require(addresses.length <= 20); //only batches of 20 allowed
557         uint i = 0;
558         uint len = addresses.length;
559         for (;i < len; i++) {
560             sendToken(addresses[i], _values[i]);
561         }
562         return true;
563     }
564 }
565 
566 
567 
568 
569 
570 
571 
572 /**
573  * @title Pausable
574  * @dev Base contract which allows children to implement an emergency stop mechanism.
575  */
576 contract Pausable is Ownable {
577   event Pause();
578   event Unpause();
579 
580   bool public paused = false;
581 
582 
583   /**
584    * @dev Modifier to make a function callable only when the contract is not paused.
585    */
586   modifier whenNotPaused() {
587     require(!paused);
588     _;
589   }
590 
591   /**
592    * @dev Modifier to make a function callable only when the contract is paused.
593    */
594   modifier whenPaused() {
595     require(paused);
596     _;
597   }
598 
599   /**
600    * @dev called by the owner to pause, triggers stopped state
601    */
602   function pause() onlyOwner whenNotPaused public {
603     paused = true;
604     Pause();
605   }
606 
607   /**
608    * @dev called by the owner to unpause, returns to normal state
609    */
610   function unpause() onlyOwner whenPaused public {
611     paused = false;
612     Unpause();
613   }
614 }
615 
616 
617 
618 
619 
620 
621 
622 
623 
624 /**
625  * @title Contracts that should be able to recover tokens
626  * @author SylTi
627  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
628  * This will prevent any accidental loss of tokens.
629  * https://github.com/OpenZeppelin/zeppelin-solidity/
630  */
631 contract CanReclaimToken is Ownable {
632   using SafeERC20 for ERC20Basic;
633 
634     //log event whenever withdrawal from this contract address happens
635     event Withdraw(address indexed from, address indexed to, uint256 value);
636   /**
637    * @dev Reclaim all ERC20Basic compatible tokens
638    * @param token ERC20Basic The address of the token contract
639    */
640   function reclaimToken(address token) external onlyOwner {
641     if (token == 0x0) {
642       owner.transfer(this.balance);
643       return;
644     }
645     ERC20Basic ecr20BasicToken = ERC20Basic(token);
646     uint256 balance = ecr20BasicToken.balanceOf(this);
647     ecr20BasicToken.safeTransfer(owner, balance);
648     Withdraw(msg.sender, owner, balance);
649   }
650 
651 }
652 
653 /**
654  * @title Contracts that should not own Tokens
655  * @author Remco Bloemen <remco@2π.com>
656  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
657  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
658  * owner to reclaim the tokens.
659 * https://github.com/OpenZeppelin/zeppelin-solidity/
660  */
661 contract HasNoTokens is CanReclaimToken {
662 
663  /**
664   * @dev Reject all ERC23 compatible tokens
665   * @param from_ address The address that is transferring the tokens
666   * @param value_ uint256 the amount of the specified token
667   * @param data_ Bytes The data passed from the caller.
668   */
669   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
670     from_;
671     value_;
672     data_;
673     revert();
674   }
675 
676 }
677 
678 
679 contract VZTPresale is Ownable, Pausable, HasNoTokens {
680 
681 
682     using SafeMath for uint256;
683 
684     string public constant name = "VectorZilla Public Presale";  // solium-disable-line uppercase
685     string public constant version = "1.0"; // solium-disable-line uppercase
686 
687     VZToken token;
688 
689     // this multi-sig address will be replaced on production:
690     address public constant VZT_WALLET = 0xa50EB7D45aA025525254aB2452679cE888B16b86;
691     /* if the minimum funding goal in wei is not reached, buyers may withdraw their funds */
692     uint256 public constant MIN_FUNDING_GOAL = 200 * 10 ** 18;
693     uint256 public constant PRESALE_TOKEN_SOFT_CAP = 1875000 * 10 ** 18;    // presale soft cap of 1,875,000 VZT
694     uint256 public constant PRESALE_RATE = 1250;                            // presale price is 1 ETH to 1,250 VZT
695     uint256 public constant SOFTCAP_RATE = 1150;                            // presale price becomes 1 ETH to 1,150 VZT after softcap is reached
696     uint256 public constant PRESALE_TOKEN_HARD_CAP = 5900000 * 10 ** 18;    // presale token hardcap
697     uint256 public constant MAX_GAS_PRICE = 50000000000;
698 
699     uint256 public minimumPurchaseLimit = 0.1 * 10 ** 18;                      // minimum purchase is 0.1 ETH to make the gas worthwhile
700     uint256 public startDate = 1516001400;                            // January 15, 2018 7:30 AM UTC
701     uint256 public endDate = 1517815800;                              // Febuary 5, 2018 7:30 AM UTC
702     uint256 public totalCollected = 0;                                // total amount of Ether raised in wei
703     uint256 public tokensSold = 0;                                    // total number of VZT tokens sold
704     uint256 public totalDistributed = 0;                              // total number of VZT tokens distributed once finalised
705     uint256 public numWhitelisted = 0;                                // total number whitelisted
706 
707     struct PurchaseLog {
708         uint256 ethValue;
709         uint256 vztValue;
710         bool kycApproved;
711         bool tokensDistributed;
712         bool paidFiat;
713         uint256 lastPurchaseTime;
714         uint256 lastDistributionTime;
715     }
716 
717     //purchase log that captures
718     mapping (address => PurchaseLog) public purchaseLog;
719     //capture refunds
720     mapping (address => bool) public refundLog;
721     //capture buyers in array, this is for quickly looking up from DAPP
722     address[] public buyers;
723     uint256 public buyerCount = 0;                                              // total number of buyers purchased VZT
724 
725     bool public isFinalized = false;                                        // it becomes true when token sale is completed
726     bool public publicSoftCapReached = false;                               // it becomes true when public softcap is reached
727 
728     // list of addresses that can purchase
729     mapping(address => bool) public whitelist;
730 
731     // event logging for token purchase
732     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
733     // event logging for token sale finalized
734     event Finalized();
735     // event logging for softcap reached
736     event SoftCapReached();
737     // event logging for funds transfered to VectorZilla multi-sig wallet
738     event FundsTransferred();
739     // event logging for each individual refunded amount
740     event Refunded(address indexed beneficiary, uint256 weiAmount);
741     // event logging for each individual distributed token + bonus
742     event TokenDistributed(address indexed purchaser, uint256 tokenAmt);
743 
744 
745     /*
746         Constructor to initialize everything.
747     */
748     function VZTPresale(address _token, address _owner) public {
749         require(_token != address(0));
750         require(_owner != address(0));
751         token = VZToken(_token);
752         // default owner
753         owner = _owner;
754     }
755 
756     /*
757        default function to buy tokens.
758     */
759 
760     function() payable public whenNotPaused {
761         doPayment(msg.sender);
762     }
763 
764     /*
765        allows owner to register token purchases done via fiat-eth (or equivalent currency)
766     */
767     function payableInFiatEth(address buyer, uint256 value) external onlyOwner {
768         purchaseLog[buyer].paidFiat = true;
769         // do public presale
770         purchasePresale(buyer, value);
771     }
772 
773     function setTokenContract(address _token) external onlyOwner {
774         require(token != address(0));
775         token = VZToken(_token);
776 
777     }
778 
779     /**
780     * add address to whitelist
781     * @param _addr wallet address to be added to whitelist
782     */
783     function addToWhitelist(address _addr) public onlyOwner returns (bool) {
784         require(_addr != address(0));
785         if (!whitelist[_addr]) {
786             whitelist[_addr] = true;
787             numWhitelisted++;
788         }
789         purchaseLog[_addr].kycApproved = true;
790         return true;
791     }
792 
793      /**
794       * add address to whitelist
795       * @param _addresses wallet addresses to be whitelisted
796       */
797     function addManyToWhitelist(address[] _addresses) 
798         external 
799         onlyOwner 
800         returns (bool) 
801         {
802         require(_addresses.length <= 50);
803         uint idx = 0;
804         uint len = _addresses.length;
805         for (; idx < len; idx++) {
806             address _addr = _addresses[idx];
807             addToWhitelist(_addr);
808         }
809         return true;
810     }
811     /**
812      * remove address from whitelist
813      * @param _addr wallet address to be removed from whitelist
814      */
815      function removeFomWhitelist(address _addr) public onlyOwner returns (bool) {
816          require(_addr != address(0));
817          require(whitelist[_addr]);
818         delete whitelist[_addr];
819         purchaseLog[_addr].kycApproved = false;
820         numWhitelisted--;
821         return true;
822      }
823 
824     /*
825         Send Tokens tokens to a buyer:
826         - and KYC is approved
827     */
828     function sendTokens(address _user) public onlyOwner returns (bool) {
829         require(_user != address(0));
830         require(_user != address(this));
831         require(purchaseLog[_user].kycApproved);
832         require(purchaseLog[_user].vztValue > 0);
833         require(!purchaseLog[_user].tokensDistributed);
834         require(!refundLog[_user]);
835         purchaseLog[_user].tokensDistributed = true;
836         purchaseLog[_user].lastDistributionTime = now;
837         totalDistributed++;
838         token.sendToken(_user, purchaseLog[_user].vztValue);
839         TokenDistributed(_user, purchaseLog[_user].vztValue);
840         return true;
841     }
842 
843     /*
844         Refund ethers to buyer if KYC couldn't/wasn't verified.
845     */
846     function refundEthIfKYCNotVerified(address _user) public onlyOwner returns (bool) {
847         if (!purchaseLog[_user].kycApproved) {
848             return doRefund(_user);
849         }
850         return false;
851     }
852 
853     /*
854 
855     /*
856         return true if buyer is whitelisted
857     */
858     function isWhitelisted(address buyer) public view returns (bool) {
859         return whitelist[buyer];
860     }
861 
862     /*
863         Check to see if this is public presale.
864     */
865     function isPresale() public view returns (bool) {
866         return !isFinalized && now >= startDate && now <= endDate;
867     }
868 
869     /*
870         check if allocated has sold out.
871     */
872     function hasSoldOut() public view returns (bool) {
873         return PRESALE_TOKEN_HARD_CAP - tokensSold < getMinimumPurchaseVZTLimit();
874     }
875 
876     /*
877         Check to see if the presale end date has passed or if all tokens allocated
878         for sale has been purchased.
879     */
880     function hasEnded() public view returns (bool) {
881         return now > endDate || hasSoldOut();
882     }
883 
884     /*
885         Determine if the minimum goal in wei has been reached.
886     */
887     function isMinimumGoalReached() public view returns (bool) {
888         return totalCollected >= MIN_FUNDING_GOAL;
889     }
890 
891     /*
892         For the convenience of presale interface to present status info.
893     */
894     function getSoftCapReached() public view returns (bool) {
895         return publicSoftCapReached;
896     }
897 
898     function setMinimumPurchaseEtherLimit(uint256 newMinimumPurchaseLimit) external onlyOwner {
899         require(newMinimumPurchaseLimit > 0);
900         minimumPurchaseLimit = newMinimumPurchaseLimit;
901     }
902     /*
903         For the convenience of presale interface to find current tier price.
904     */
905 
906     function getMinimumPurchaseVZTLimit() public view returns (uint256) {
907         if (getTier() == 1) {
908             return minimumPurchaseLimit.mul(PRESALE_RATE); //1250VZT/ether
909         } else if (getTier() == 2) {
910             return minimumPurchaseLimit.mul(SOFTCAP_RATE); //1150VZT/ether
911         }
912         return minimumPurchaseLimit.mul(1000); //base price
913     }
914 
915     /*
916         For the convenience of presale interface to find current discount tier.
917     */
918     function getTier() public view returns (uint256) {
919         // Assume presale top tier discount
920         uint256 tier = 1;
921         if (now >= startDate && now < endDate && getSoftCapReached()) {
922             // tier 2 discount
923             tier = 2;
924         }
925         return tier;
926     }
927 
928     /*
929         For the convenience of presale interface to present status info.
930     */
931     function getPresaleStatus() public view returns (uint256[3]) {
932         // 0 - presale not started
933         // 1 - presale started
934         // 2 - presale ended
935         if (now < startDate)
936             return ([0, startDate, endDate]);
937         else if (now <= endDate && !hasEnded())
938             return ([1, startDate, endDate]);
939         else
940             return ([2, startDate, endDate]);
941     }
942 
943     /*
944         Called after presale ends, to do some extra finalization work.
945     */
946     function finalize() public onlyOwner {
947         // do nothing if finalized
948         require(!isFinalized);
949         // presale must have ended
950         require(hasEnded());
951 
952         if (isMinimumGoalReached()) {
953             // transfer to VectorZilla multisig wallet
954             VZT_WALLET.transfer(this.balance);
955             // signal the event for communication
956             FundsTransferred();
957         }
958         // mark as finalized
959         isFinalized = true;
960         // signal the event for communication
961         Finalized();
962     }
963 
964 
965     /**
966      * @notice `proxyPayment()` allows the caller to send ether to the VZTPresale
967      * and have the tokens created in an address of their choosing
968      * @param buyer The address that will hold the newly created tokens
969      */
970     function proxyPayment(address buyer) 
971     payable 
972     public
973     whenNotPaused 
974     returns(bool success) 
975     {
976         return doPayment(buyer);
977     }
978 
979     /*
980         Just in case we need to tweak pre-sale dates
981     */
982     function setDates(uint256 newStartDate, uint256 newEndDate) public onlyOwner {
983         require(newEndDate >= newStartDate);
984         startDate = newStartDate;
985         endDate = newEndDate;
986     }
987 
988 
989     // @dev `doPayment()` is an internal function that sends the ether that this
990     //  contract receives to the `vault` and creates tokens in the address of the
991     //  `buyer` assuming the VZTPresale is still accepting funds
992     //  @param buyer The address that will hold the newly created tokens
993     // @return True if payment is processed successfully
994     function doPayment(address buyer) internal returns(bool success) {
995         require(tx.gasprice <= MAX_GAS_PRICE);
996         // Antispam
997         // do not allow contracts to game the system
998         require(buyer != address(0));
999         require(!isContract(buyer));
1000         // limit the amount of contributions to once per 100 blocks
1001         //require(getBlockNumber().sub(lastCallBlock[msg.sender]) >= maxCallFrequency);
1002         //lastCallBlock[msg.sender] = getBlockNumber();
1003 
1004         if (msg.sender != owner) {
1005             // stop if presale is over
1006             require(isPresale());
1007             // stop if no more token is allocated for sale
1008             require(!hasSoldOut());
1009             require(msg.value >= minimumPurchaseLimit);
1010         }
1011         require(msg.value > 0);
1012         purchasePresale(buyer, msg.value);
1013         return true;
1014     }
1015 
1016     /// @dev Internal function to determine if an address is a contract
1017     /// @param _addr The address being queried
1018     /// @return True if `_addr` is a contract
1019     function isContract(address _addr) constant internal returns (bool) {
1020         if (_addr == 0) {
1021             return false;
1022         }
1023         uint256 size;
1024         assembly {
1025             size := extcodesize(_addr)
1026         }
1027         return (size > 0);
1028     }
1029 
1030     /// @dev Internal function to process sale
1031     /// @param buyer The buyer address
1032     /// @param value  The value of ether paid
1033     function purchasePresale(address buyer, uint256 value) internal {
1034          require(value >= minimumPurchaseLimit);
1035          require(buyer != address(0));
1036         uint256 tokens = 0;
1037         // still under soft cap
1038         if (!publicSoftCapReached) {
1039             // 1 ETH for 1,250 VZT
1040             tokens = value * PRESALE_RATE;
1041             // get less if over softcap
1042             if (tokensSold + tokens > PRESALE_TOKEN_SOFT_CAP) {
1043                 uint256 availablePresaleTokens = PRESALE_TOKEN_SOFT_CAP - tokensSold;
1044                 uint256 softCapTokens = (value - (availablePresaleTokens / PRESALE_RATE)) * SOFTCAP_RATE;
1045                 tokens = availablePresaleTokens + softCapTokens;
1046                 // process presale at 1 ETH to 1,150 VZT
1047                 processSale(buyer, value, tokens, SOFTCAP_RATE);
1048                 // public soft cap has been reached
1049                 publicSoftCapReached = true;
1050                 // signal the event for communication
1051                 SoftCapReached();
1052             } else {
1053                 // process presale @PRESALE_RATE
1054                 processSale(buyer, value, tokens, PRESALE_RATE);
1055             }
1056         } else {
1057             // 1 ETH to 1,150 VZT
1058             tokens = value * SOFTCAP_RATE;
1059             // process presale at 1 ETH to 1,150 VZT
1060             processSale(buyer, value, tokens, SOFTCAP_RATE);
1061         }
1062     }
1063 
1064     /*
1065         process sale at determined price.
1066     */
1067     function processSale(address buyer, uint256 value, uint256 vzt, uint256 vztRate) internal {
1068         require(buyer != address(0));
1069         require(vzt > 0);
1070         require(vztRate > 0);
1071         require(value > 0);
1072 
1073         uint256 vztOver = 0;
1074         uint256 excessEthInWei = 0;
1075         uint256 paidValue = value;
1076         uint256 purchasedVzt = vzt;
1077 
1078         if (tokensSold + purchasedVzt > PRESALE_TOKEN_HARD_CAP) {// if maximum is exceeded
1079             // find overage
1080             vztOver = tokensSold + purchasedVzt - PRESALE_TOKEN_HARD_CAP;
1081             // overage ETH to refund
1082             excessEthInWei = vztOver / vztRate;
1083             // adjust tokens purchased
1084             purchasedVzt = purchasedVzt - vztOver;
1085             // adjust Ether paid
1086             paidValue = paidValue - excessEthInWei;
1087         }
1088 
1089         /* To quick lookup list of buyers (pending token, kyc, or even refunded)
1090             we are keeping an array of buyers. There might be duplicate entries when
1091             a buyer gets refund (incomplete kyc, or requested), and then again contributes.
1092         */
1093         if (purchaseLog[buyer].vztValue == 0) {
1094             buyers.push(buyer);
1095             buyerCount++;
1096         }
1097 
1098         //if not whitelisted, mark kyc pending
1099         if (!isWhitelisted(buyer)) {
1100             purchaseLog[buyer].kycApproved = false;
1101         }
1102         //reset refund status in refundLog
1103         refundLog[buyer] = false;
1104 
1105          // record purchase in purchaseLog
1106         purchaseLog[buyer].vztValue = SafeMath.add(purchaseLog[buyer].vztValue, purchasedVzt);
1107         purchaseLog[buyer].ethValue = SafeMath.add(purchaseLog[buyer].ethValue, paidValue);
1108         purchaseLog[buyer].lastPurchaseTime = now;
1109 
1110 
1111         // total Wei raised
1112         totalCollected += paidValue;
1113         // total VZT sold
1114         tokensSold += purchasedVzt;
1115 
1116         /*
1117             For event, log buyer and beneficiary properly
1118         */
1119         address beneficiary = buyer;
1120         if (beneficiary == msg.sender) {
1121             beneficiary = msg.sender;
1122         }
1123         // signal the event for communication
1124         TokenPurchase(buyer, beneficiary, paidValue, purchasedVzt);
1125         // transfer must be done at the end after all states are updated to prevent reentrancy attack.
1126         if (excessEthInWei > 0 && !purchaseLog[buyer].paidFiat) {
1127             // refund overage ETH
1128             buyer.transfer(excessEthInWei);
1129             // signal the event for communication
1130             Refunded(buyer, excessEthInWei);
1131         }
1132     }
1133 
1134     /*
1135         Distribute tokens to a buyer:
1136         - when minimum goal is reached
1137         - and KYC is approved
1138     */
1139     function distributeTokensFor(address buyer) external onlyOwner returns (bool) {
1140         require(isFinalized);
1141         require(hasEnded());
1142         if (isMinimumGoalReached()) {
1143             return sendTokens(buyer);
1144         }
1145         return false;
1146     }
1147 
1148     /*
1149         purchaser requesting a refund, only allowed when minimum goal not reached.
1150     */
1151     function claimRefund() external returns (bool) {
1152         return doRefund(msg.sender);
1153     }
1154 
1155     /*
1156       send refund to purchaser requesting a refund 
1157    */
1158     function sendRefund(address buyer) external onlyOwner returns (bool) {
1159         return doRefund(buyer);
1160     }
1161 
1162     /*
1163         Internal function to manage refunds 
1164     */
1165     function doRefund(address buyer) internal returns (bool) {
1166         require(tx.gasprice <= MAX_GAS_PRICE);
1167         require(buyer != address(0));
1168         require(!purchaseLog[buyer].paidFiat);
1169         if (msg.sender != owner) {
1170             // cannot refund unless authorized
1171             require(isFinalized && !isMinimumGoalReached());
1172         }
1173         require(purchaseLog[buyer].ethValue > 0);
1174         require(purchaseLog[buyer].vztValue > 0);
1175         require(!refundLog[buyer]);
1176         require(!purchaseLog[buyer].tokensDistributed);
1177 
1178         // ETH to refund
1179         uint256 depositedValue = purchaseLog[buyer].ethValue;
1180         //VZT to revert
1181         uint256 vztValue = purchaseLog[buyer].vztValue;
1182         // assume all refunded, should we even do this if
1183         // we are going to delete buyer from log?
1184         purchaseLog[buyer].ethValue = 0;
1185         purchaseLog[buyer].vztValue = 0;
1186         refundLog[buyer] = true;
1187         //delete from purchase log.
1188         //but we won't remove buyer from buyers array
1189         delete purchaseLog[buyer];
1190         //decrement global counters
1191         tokensSold = tokensSold.sub(vztValue);
1192         totalCollected = totalCollected.sub(depositedValue);
1193 
1194         // send must be called only after purchaseLog[buyer] is deleted to
1195         //prevent reentrancy attack.
1196         buyer.transfer(depositedValue);
1197         Refunded(buyer, depositedValue);
1198         return true;
1199     }
1200 
1201     function getBuyersList() external view returns (address[]) {
1202         return buyers;
1203     }
1204 
1205     /**
1206         * @dev Transfer all Ether held by the contract to the owner.
1207         * Emergency where we might need to recover
1208     */
1209     function reclaimEther() external onlyOwner {
1210         assert(owner.send(this.balance));
1211     }
1212 
1213 }