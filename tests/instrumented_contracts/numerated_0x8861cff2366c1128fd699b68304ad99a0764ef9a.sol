1 // File: contracts/token/IERC20Basic.sol
2 
3 pragma solidity ^0.5.17;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract IERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: contracts/token/IERC20.sol
19 
20 pragma solidity ^0.5.17;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract IERC20 is IERC20Basic {
29   function name() external view returns (string memory);
30   function symbol() external view returns (string memory);
31   function allowance(address owner, address spender) public view returns (uint256);
32   function transferFrom(address from, address to, uint256 value) public returns (bool);
33   function approve(address spender, uint256 value) public returns (bool);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 // File: contracts/token/IMintableToken.sol
38 
39 pragma solidity ^0.5.17;
40 
41 
42 contract IMintableToken is IERC20 {
43     function mint(address, uint) external returns (bool);
44     function burn(uint) external returns (bool);
45 
46     event Minted(address indexed to, uint256 amount);
47     event Burned(address indexed from, uint256 amount);
48     event MinterAdded(address indexed minter);
49     event MinterRemoved(address indexed minter);
50 }
51 
52 // File: contracts/math/SafeMath.sol
53 
54 pragma solidity ^0.5.17;
55 
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62 
63   /**
64   * @dev Multiplies two numbers, throws on overflow.
65   */
66 
67   /*@CTK SafeMath_mul
68     @tag spec
69     @post __reverted == __has_assertion_failure
70     @post __has_assertion_failure == __has_overflow
71     @post __reverted == false -> c == a * b
72     @post msg == msg__post
73    */
74   /* CertiK Smart Labelling, for more details visit: https://certik.org */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     if (a == 0) {
77       return 0;
78     }
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   /*@CTK SafeMath_div
88     @tag spec
89     @pre b != 0
90     @post __reverted == __has_assertion_failure
91     @post __has_overflow == true -> __has_assertion_failure == true
92     @post __reverted == false -> __return == a / b
93     @post msg == msg__post
94    */
95   /* CertiK Smart Labelling, for more details visit: https://certik.org */
96   function div(uint256 a, uint256 b) internal pure returns (uint256) {
97     // assert(b > 0); // Solidity automatically throws when dividing by 0
98     // uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100     return a / b;
101   }
102 
103   /**
104   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   /*@CTK SafeMath_sub
107     @tag spec
108     @post __reverted == __has_assertion_failure
109     @post __has_overflow == true -> __has_assertion_failure == true
110     @post __reverted == false -> __return == a - b
111     @post msg == msg__post
112    */
113   /* CertiK Smart Labelling, for more details visit: https://certik.org */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   /*@CTK SafeMath_add
123     @tag spec
124     @post __reverted == __has_assertion_failure
125     @post __has_assertion_failure == __has_overflow
126     @post __reverted == false -> c == a + b
127     @post msg == msg__post
128    */
129   /* CertiK Smart Labelling, for more details visit: https://certik.org */
130   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
131     c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
136 
137 // File: contracts/token/BasicToken.sol
138 
139 pragma solidity ^0.5.17;
140 
141 
142 
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is IERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   uint256 totalSupply_;
154 
155   /**
156   * @dev total number of tokens in existence
157   */
158   function totalSupply() public view returns (uint256) {
159     return totalSupply_;
160   }
161 
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   /*@CTK transfer_success
168     @pre _to != address(0)
169     @pre balances[msg.sender] >= _value
170     @pre __reverted == false
171     @post __reverted == false
172     @post __return == true
173    */
174   /*@CTK transfer_same_address
175     @tag no_overflow
176     @pre _to == msg.sender
177     @post this == __post
178    */
179   /*@CTK transfer_conditions
180     @tag assume_completion
181     @pre _to != msg.sender
182     @post __post.balances[_to] == balances[_to] + _value
183     @post __post.balances[msg.sender] == balances[msg.sender] - _value
184    */
185   /* CertiK Smart Labelling, for more details visit: https://certik.org */
186   function transfer(address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[msg.sender]);
189 
190     balances[msg.sender] = balances[msg.sender].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     emit Transfer(msg.sender, _to, _value);
193     return true;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param _owner The address to query the the balance of.
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   /*@CTK balanceOf
202     @post __reverted == false
203     @post __return == balances[_owner]
204    */
205   /* CertiK Smart Labelling, for more details visit: https://certik.org */
206   function balanceOf(address _owner) public view returns (uint256) {
207     return balances[_owner];
208   }
209 }
210 
211 // File: contracts/token/StandardToken.sol
212 
213 pragma solidity ^0.5.17;
214 
215 
216 
217 
218 /**
219  * @title Standard ERC20 token
220  *
221  * @dev Implementation of the basic standard token.
222  * @dev https://github.com/ethereum/EIPs/issues/20
223  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  */
225 contract StandardToken is IERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) internal allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   /*@CTK transferFrom
237     @tag assume_completion
238     @pre _from != _to
239     @post __return == true
240     @post __post.balances[_to] == balances[_to] + _value
241     @post __post.balances[_from] == balances[_from] - _value
242     @post __has_overflow == false
243    */
244   /* CertiK Smart Labelling, for more details visit: https://certik.org */
245   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
246     require(_to != address(0));
247     require(_value <= balances[_from]);
248     require(_value <= allowed[_from][msg.sender]);
249 
250     balances[_from] = balances[_from].sub(_value);
251     balances[_to] = balances[_to].add(_value);
252     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
253     emit Transfer(_from, _to, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
259    *
260    * Beware that changing an allowance with this method brings the risk that someone may use both the old
261    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
262    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
263    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264    * @param _spender The address which will spend the funds.
265    * @param _value The amount of tokens to be spent.
266    */
267   /*@CTK approve_success
268     @post _value == 0 -> __reverted == false
269     @post allowed[msg.sender][_spender] == 0 -> __reverted == false
270    */
271   /*@CTK approve
272     @tag assume_completion
273     @post __post.allowed[msg.sender][_spender] == _value
274    */
275   /* CertiK Smart Labelling, for more details visit: https://certik.org */
276   function approve(address _spender, uint256 _value) public returns (bool) {
277     allowed[msg.sender][_spender] = _value;
278     emit Approval(msg.sender, _spender, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Function to check the amount of tokens that an owner allowed to a spender.
284    * @param _owner address The address which owns the funds.
285    * @param _spender address The address which will spend the funds.
286    * @return A uint256 specifying the amount of tokens still available for the spender.
287    */
288   function allowance(address _owner, address _spender) public view returns (uint256) {
289     return allowed[_owner][_spender];
290   }
291 
292   /**
293    * @dev Increase the amount of tokens that an owner allowed to a spender.
294    *
295    * approve should be called when allowed[_spender] == 0. To increment
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _addedValue The amount of tokens to increase the allowance by.
301    */
302   /*@CTK CtkIncreaseApprovalEffect
303     @tag assume_completion
304     @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] + _addedValue
305     @post __has_overflow == false
306    */
307   /* CertiK Smart Labelling, for more details visit: https://certik.org */
308   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
309     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
310     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314   /**
315    * @dev Decrease the amount of tokens that an owner allowed to a spender.
316    *
317    * approve should be called when allowed[_spender] == 0. To decrement
318    * allowed value is better to use this function to avoid 2 calls (and wait until
319    * the first transaction is mined)
320    * From MonolithDAO Token.sol
321    * @param _spender The address which will spend the funds.
322    * @param _subtractedValue The amount of tokens to decrease the allowance by.
323    */
324   /*@CTK CtkDecreaseApprovalEffect_1
325     @pre allowed[msg.sender][_spender] >= _subtractedValue
326     @tag assume_completion
327     @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] - _subtractedValue
328     @post __has_overflow == false
329    */
330    /*@CTK CtkDecreaseApprovalEffect_2
331     @pre allowed[msg.sender][_spender] < _subtractedValue
332     @tag assume_completion
333     @post __post.allowed[msg.sender][_spender] == 0
334     @post __has_overflow == false
335    */
336   /* CertiK Smart Labelling, for more details visit: https://certik.org */
337   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
338     uint oldValue = allowed[msg.sender][_spender];
339     if (_subtractedValue > oldValue) {
340       allowed[msg.sender][_spender] = 0;
341     } else {
342       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
343     }
344     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
345     return true;
346   }
347 
348 }
349 
350 // File: contracts/ownership/Ownable.sol
351 
352 pragma solidity ^0.5.17;
353 
354 
355 /**
356  * @title Ownable
357  * @dev The Ownable contract has an owner address, and provides basic authorization control
358  * functions, this simplifies the implementation of "user permissions".
359  */
360 contract Ownable {
361   address public owner;
362 
363 
364   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
365 
366 
367   /**
368    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
369    * account.
370    */
371   constructor() public {
372     owner = msg.sender;
373   }
374 
375   /**
376    * @dev Throws if called by any account other than the owner.
377    */
378   modifier onlyOwner() {
379     require(msg.sender == owner);
380     _;
381   }
382 
383   /**
384    * @dev Allows the current owner to transfer control of the contract to a newOwner.
385    * @param newOwner The address to transfer ownership to.
386    */
387   function transferOwnership(address newOwner) public onlyOwner {
388     require(newOwner != address(0));
389     emit OwnershipTransferred(owner, newOwner);
390     owner = newOwner;
391   }
392 
393 }
394 
395 // File: contracts/lifecycle/Pausable.sol
396 
397 pragma solidity ^0.5.17;
398 
399 
400 /**
401  * @title Pausable
402  * @dev Base contract which allows children to implement an emergency stop mechanism.
403  */
404 contract Pausable is Ownable {
405   event Pause();
406   event Unpause();
407 
408   bool public paused = false;
409 
410 
411   /**
412    * @dev Modifier to make a function callable only when the contract is not paused.
413    */
414   modifier whenNotPaused() {
415     require(!paused);
416     _;
417   }
418 
419   /**
420    * @dev Modifier to make a function callable only when the contract is paused.
421    */
422   modifier whenPaused() {
423     require(paused);
424     _;
425   }
426 
427   /**
428    * @dev called by the owner to pause, triggers stopped state
429    */
430   function pause() onlyOwner whenNotPaused public {
431     paused = true;
432     emit Pause();
433   }
434 
435   /**
436    * @dev called by the owner to unpause, returns to normal state
437    */
438   function unpause() onlyOwner whenPaused public {
439     paused = false;
440     emit Unpause();
441   }
442 }
443 
444 // File: contracts/token/ShadowToken.sol
445 
446 pragma solidity ^0.5.17;
447 
448 
449 
450 
451 contract ShadowToken is StandardToken, IMintableToken, Pausable {
452     event Minted(address indexed to, uint256 amount);
453     event Burned(address indexed from, uint256 amount);
454     event MinterAdded(address indexed minter);
455     event MinterRemoved(address indexed minter);
456 
457     modifier onlyMinter() {
458         require(minter == msg.sender, "not the minter");
459         _;
460     }
461 
462     address public coToken;
463     address public minter;
464     string public name;
465     string public symbol;
466     uint8 public decimals;
467 
468     constructor(address _minter, address _coToken, string memory _name, string memory _symbol, uint8 _decimals) public {
469         minter = _minter;
470         coToken = _coToken;
471         name = _name;
472         symbol = _symbol;
473         decimals = _decimals;
474         emit MinterAdded(_minter);
475     }
476 
477     function mint(address _to, uint256 _amount) public onlyMinter whenNotPaused returns (bool) {
478         totalSupply_ = totalSupply_.add(_amount);
479         balances[_to] = balances[_to].add(_amount);
480         emit Minted(_to, _amount);
481         emit Transfer(address(0), _to, _amount);
482         return true;
483     }
484 
485     // user can also burn by sending token to address(0), but this function will emit Burned event
486     function burn(uint256 _amount) public returns (bool) {
487         require(balances[msg.sender] >= _amount);
488         totalSupply_ = totalSupply_.sub(_amount);
489         balances[msg.sender] = balances[msg.sender].sub(_amount);
490         emit Burned(msg.sender, _amount);
491         emit Transfer(msg.sender, address(0), _amount);
492         return true;
493     }
494 }
495 
496 // File: contracts/token/CycloneToken.sol
497 
498 pragma solidity ^0.5.17;
499 
500 
501 
502 
503 
504 contract CycloneToken is StandardToken, IMintableToken, Pausable {
505 
506     modifier onlyOperator() {
507         require(operator == msg.sender, "not the operator");
508         _;
509     }
510 
511     // Minters include Aeolus (liquidity mining) and CoinCyclone/ERC20Cyclone (anonymity mining)
512     modifier onlyMinters() {
513         require(minters[msg.sender] == true, "not the minter");
514         _;
515     }
516 
517     address public operator;
518     mapping (address => bool) public minters;
519     string public constant name = "Cyclone Protocol";
520     string public constant symbol = "CYC";
521     uint8 public constant decimals = 18;
522 
523     constructor(address _operator, address _lp) public {
524         require (_operator != address(0), "invalid address");
525         if (_lp != address(0)) {
526             // mint 2021 CYC for community
527             totalSupply_ = totalSupply_.add(2021 * 1000000000000000000);	
528             balances[_lp] = balances[_lp].add(2021 * 1000000000000000000);
529             _moveDelegates(address(0), delegates[_lp], 2021 * 1000000000000000000);
530         }
531         operator = _operator;
532     }
533 
534     function addMinter(address _minter) external onlyOperator {
535         minters[_minter] = true;
536         emit MinterAdded(_minter);
537     }
538 
539     function removeMinter(address _minter) external onlyOperator {
540         minters[_minter] = false;
541         emit MinterRemoved(_minter);
542     }
543 
544     function updateOperator(address _operator) external onlyOperator {
545         require (_operator != address(0), "invalid operator address");
546         operator = _operator;
547     }
548 
549     function mint(address _to, uint256 _amount) public onlyMinters whenNotPaused returns (bool) {
550         require (_to != address(0), "invalid address for mint");
551         require (_amount != 0, "mint amount should not be zero");
552         totalSupply_ = totalSupply_.add(_amount);
553         balances[_to] = balances[_to].add(_amount);
554         emit Minted(_to, _amount);
555         emit Transfer(address(0), _to, _amount);
556         _moveDelegates(address(0), delegates[_to], _amount);
557         return true;
558     }
559 
560     // user can also burn by sending token to address(0), but this function will emit Burned event
561     function burn(uint256 _amount) public returns (bool) {
562         require (_amount != 0, "burn amount should not be zero");
563         require(balances[msg.sender] >= _amount);
564         totalSupply_ = totalSupply_.sub(_amount);
565         balances[msg.sender] = balances[msg.sender].sub(_amount);
566         emit Burned(msg.sender, _amount);
567         emit Transfer(msg.sender, address(0), _amount);
568         _moveDelegates(delegates[msg.sender], address(0), _amount);
569         return true;
570     }
571   
572     // Which is copied and modified from COMPOUND:
573     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
574     
575     /// @notice A checkpoint for marking number of votes from a given block
576     struct Checkpoint {
577         uint32 fromBlock;
578         uint256 votes;
579     }
580 
581     /// @notice A record of votes checkpoints for each account, by index
582     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
583 
584     /// @notice The number of checkpoints for each account
585     mapping (address => uint32) public numCheckpoints;
586 
587     /// @notice A record of each accounts delegate
588     mapping (address => address) public delegates;
589 
590     /// @notice The EIP-712 typehash for the contract's domain
591     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
592 
593     /// @notice The EIP-712 typehash for the delegation struct used by the contract
594     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
595 
596     /// @notice A record of states for signing / validating signatures
597     mapping (address => uint) public nonces;
598 
599     /// @notice An event thats emitted when an account changes its delegate
600     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
601 
602     /// @notice An event thats emitted when a delegate account's vote balance changes
603     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
604 
605     /**
606      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
607      * @param dst The address of the destination account
608      * @param amount The number of tokens to transfer
609      * @return Whether or not the transfer succeeded
610      */
611     function transfer(address dst, uint256 amount) public returns (bool) {
612         _transferTokens(msg.sender, dst, amount);
613         return true;
614     }
615 
616     /**
617      * @notice Transfer `amount` tokens from `src` to `dst`
618      * @param src The address of the source account
619      * @param dst The address of the destination account
620      * @param amount The number of tokens to transfer
621      * @return Whether or not the transfer succeeded
622      */
623     function transferFrom(address src, address dst, uint256 amount) public returns (bool) {
624         address spender = msg.sender;
625         uint256 spenderAllowance = allowed[src][spender];
626 
627         if (spender != src) {
628             uint256 newAllowance = spenderAllowance.sub(amount);
629             allowed[src][spender] = newAllowance;
630 
631             emit Approval(src, spender, newAllowance);
632         }
633 
634         _transferTokens(src, dst, amount);
635         return true;
636     }
637 
638     /**
639      * @notice Delegate votes from `msg.sender` to `delegatee`
640      * @param delegatee The address to delegate votes to
641      */
642     function delegate(address delegatee) public {
643         return _delegate(msg.sender, delegatee);
644     }
645 
646     /**
647      * @notice Delegates votes from signatory to `delegatee`
648      * @param delegatee The address to delegate votes to
649      * @param nonce The contract state required to match the signature
650      * @param expiry The time at which to expire the signature
651      * @param v The recovery byte of the signature
652      * @param r Half of the ECDSA signature pair
653      * @param s Half of the ECDSA signature pair
654      */
655     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
656         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), uint(0), address(this)));
657         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
658         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
659         address signatory = ecrecover(digest, v, r, s);
660         require(signatory != address(0), "delegateBySig: invalid signature");
661         require(nonce == nonces[signatory]++, "delegateBySig: invalid nonce");
662         require(now <= expiry, "delegateBySig: signature expired");
663         return _delegate(signatory, delegatee);
664     }
665 
666     /**
667      * @notice Gets the current votes balance for `account`
668      * @param account The address to get votes balance
669      * @return The number of current votes for `account`
670      */
671     function getCurrentVotes(address account) external view returns (uint256) {
672         uint32 nCheckpoints = numCheckpoints[account];
673         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
674     }
675 
676     /**
677      * @notice Determine the prior number of votes for an account as of a block number
678      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
679      * @param account The address of the account to check
680      * @param blockNumber The block number to get the vote balance at
681      * @return The number of votes the account had as of the given block
682      */
683     function getPriorVotes(address account, uint blockNumber) public view returns (uint256) {
684         require(blockNumber < block.number, "getPriorVotes: not yet determined");
685 
686         uint32 nCheckpoints = numCheckpoints[account];
687         if (nCheckpoints == 0) {
688             return 0;
689         }
690 
691         // First check most recent balance
692         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
693             return checkpoints[account][nCheckpoints - 1].votes;
694         }
695 
696         // Next check implicit zero balance
697         if (checkpoints[account][0].fromBlock > blockNumber) {
698             return 0;
699         }
700 
701         uint32 lower = 0;
702         uint32 upper = nCheckpoints - 1;
703         while (upper > lower) {
704             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
705             Checkpoint memory cp = checkpoints[account][center];
706             if (cp.fromBlock == blockNumber) {
707                 return cp.votes;
708             } else if (cp.fromBlock < blockNumber) {
709                 lower = center;
710             } else {
711                 upper = center - 1;
712             }
713         }
714         return checkpoints[account][lower].votes;
715     }
716 
717     function _delegate(address delegator, address delegatee) internal {
718         address currentDelegate = delegates[delegator];
719         uint256 delegatorBalance = balances[delegator];
720         delegates[delegator] = delegatee;
721 
722         emit DelegateChanged(delegator, currentDelegate, delegatee);
723 
724         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
725     }
726 
727     function _transferTokens(address src, address dst, uint256 amount) internal {
728         require(src != address(0), "_transferTokens: cannot transfer from the zero address");
729         require(dst != address(0), "_transferTokens: cannot transfer to the zero address");
730 
731         balances[src] = balances[src].sub(amount);
732         balances[dst] = balances[dst].add(amount);
733         emit Transfer(src, dst, amount);
734 
735         _moveDelegates(delegates[src], delegates[dst], amount);
736     }
737 
738     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
739         if (srcRep != dstRep && amount > 0) {
740             if (srcRep != address(0)) {
741                 uint32 srcRepNum = numCheckpoints[srcRep];
742                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
743                 uint256 srcRepNew = srcRepOld.sub(amount);
744                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
745             }
746 
747             if (dstRep != address(0)) {
748                 uint32 dstRepNum = numCheckpoints[dstRep];
749                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
750                 uint256 dstRepNew = dstRepOld.add(amount);
751                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
752             }
753         }
754     }
755 
756     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
757       uint32 blockNumber = safe32(block.number, "_writeCheckpoint: block number exceeds 32 bits");
758 
759       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
760           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
761       } else {
762           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
763           numCheckpoints[delegatee] = nCheckpoints + 1;
764       }
765 
766       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
767     }
768 
769     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
770         require(n < 2**32, errorMessage);
771         return uint32(n);
772     }
773 }