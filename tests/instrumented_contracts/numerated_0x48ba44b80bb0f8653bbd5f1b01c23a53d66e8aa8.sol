1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     if (a == 0) {
56       return 0;
57     }
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115 
116   uint256 totalSupply_;
117 
118   /**
119   * @dev total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return totalSupply_;
123   }
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133 
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     emit Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   /**
141   * @dev Gets the balance of the specified address.
142   * @param _owner The address to query the the balance of.
143   * @return An uint256 representing the amount owned by the passed address.
144   */
145   function balanceOf(address _owner) public view returns (uint256) {
146     return balances[_owner];
147   }
148 
149 }
150 
151 
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender) public view returns (uint256);
159   function transferFrom(address from, address to, uint256 value) public returns (bool);
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     emit Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 
262 /// @title   Token
263 /// @author  Jose Perez - <jose.perez@diginex.com>
264 /// @notice  ERC20 token
265 /// @dev     The contract allows to perform a number of token sales in different periods in time.
266 ///          allowing participants in previous token sales to transfer tokens to other accounts.
267 ///          Additionally, token locking logic for KYC/AML compliance checking is supported.
268 
269 contract Token is StandardToken, Ownable {
270     using SafeMath for uint256;
271 
272     string public constant name = "ZwoopToken";
273     string public constant symbol = "ZWP";
274     uint256 public constant decimals = 18;
275 
276     // Using same number of decimal figures as ETH (i.e. 18).
277     uint256 public constant TOKEN_UNIT = 10 ** uint256(decimals);
278 
279     // Maximum number of tokens in circulation
280     uint256 public constant MAX_TOKEN_SUPPLY = 2000000000 * TOKEN_UNIT;
281 
282     // Maximum number of tokens sales to be performed.
283     uint256 public constant MAX_TOKEN_SALES = 1;
284 
285     // Maximum size of the batch functions input arrays.
286     uint256 public constant MAX_BATCH_SIZE = 400;
287 
288     address public assigner;    // The address allowed to assign or mint tokens during token sale.
289     address public locker;      // The address allowed to lock/unlock addresses.
290 
291     mapping(address => bool) public locked;        // If true, address' tokens cannot be transferred.
292 
293     uint256 public currentTokenSaleId = 0;           // The id of the current token sale.
294     mapping(address => uint256) public tokenSaleId;  // In which token sale the address participated.
295 
296     bool public tokenSaleOngoing = false;
297 
298     event TokenSaleStarting(uint indexed tokenSaleId);
299     event TokenSaleEnding(uint indexed tokenSaleId);
300     event Lock(address indexed addr);
301     event Unlock(address indexed addr);
302     event Assign(address indexed to, uint256 amount);
303     event Mint(address indexed to, uint256 amount);
304     event LockerTransferred(address indexed previousLocker, address indexed newLocker);
305     event AssignerTransferred(address indexed previousAssigner, address indexed newAssigner);
306 
307     /// @dev Constructor that initializes the contract.
308     /// @param _assigner The assigner account.
309     /// @param _locker The locker account.
310     constructor(address _assigner, address _locker) public {
311         require(_assigner != address(0));
312         require(_locker != address(0));
313 
314         assigner = _assigner;
315         locker = _locker;
316     }
317 
318     /// @dev True if a token sale is ongoing.
319     modifier tokenSaleIsOngoing() {
320         require(tokenSaleOngoing);
321         _;
322     }
323 
324     /// @dev True if a token sale is not ongoing.
325     modifier tokenSaleIsNotOngoing() {
326         require(!tokenSaleOngoing);
327         _;
328     }
329 
330     /// @dev Throws if called by any account other than the assigner.
331     modifier onlyAssigner() {
332         require(msg.sender == assigner);
333         _;
334     }
335 
336     /// @dev Throws if called by any account other than the locker.
337     modifier onlyLocker() {
338         require(msg.sender == locker);
339         _;
340     }
341 
342     /// @dev Starts a new token sale. Only the owner can start a new token sale. If a token sale
343     ///      is ongoing, it has to be ended before a new token sale can be started.
344     ///      No more than `MAX_TOKEN_SALES` sales can be carried out.
345     /// @return True if the operation was successful.
346     function tokenSaleStart() external onlyOwner tokenSaleIsNotOngoing returns(bool) {
347         require(currentTokenSaleId < MAX_TOKEN_SALES);
348         currentTokenSaleId++;
349         tokenSaleOngoing = true;
350         emit TokenSaleStarting(currentTokenSaleId);
351         return true;
352     }
353 
354     /// @dev Ends the current token sale. Only the owner can end a token sale.
355     /// @return True if the operation was successful.
356     function tokenSaleEnd() external onlyOwner tokenSaleIsOngoing returns(bool) {
357         emit TokenSaleEnding(currentTokenSaleId);
358         tokenSaleOngoing = false;
359         return true;
360     }
361 
362     /// @dev Returns whether or not a token sale is ongoing.
363     /// @return True if a token sale is ongoing.
364     function isTokenSaleOngoing() external view returns(bool) {
365         return tokenSaleOngoing;
366     }
367 
368     /// @dev Getter of the variable `currentTokenSaleId`.
369     /// @return Returns the current token sale id.
370     function getCurrentTokenSaleId() external view returns(uint256) {
371         return currentTokenSaleId;
372     }
373 
374     /// @dev Getter of the variable `tokenSaleId[]`.
375     /// @param _address The address of the participant.
376     /// @return Returns the id of the token sale the address participated in.
377     function getAddressTokenSaleId(address _address) external view returns(uint256) {
378         return tokenSaleId[_address];
379     }
380 
381     /// @dev Allows the current owner to change the assigner.
382     /// @param _newAssigner The address of the new assigner.
383     /// @return True if the operation was successful.
384     function transferAssigner(address _newAssigner) external onlyOwner returns(bool) {
385         require(_newAssigner != address(0));
386 
387         emit AssignerTransferred(assigner, _newAssigner);
388         assigner = _newAssigner;
389         return true;
390     }
391 
392     /// @dev Function to mint tokens. It can only be called by the assigner during an ongoing token sale.
393     /// @param _to The address that will receive the minted tokens.
394     /// @param _amount The amount of tokens to mint.
395     /// @return A boolean that indicates if the operation was successful.
396     function mint(address _to, uint256 _amount) public onlyAssigner tokenSaleIsOngoing returns(bool) {
397         totalSupply_ = totalSupply_.add(_amount);
398         require(totalSupply_ <= MAX_TOKEN_SUPPLY);
399 
400         if (tokenSaleId[_to] == 0) {
401             tokenSaleId[_to] = currentTokenSaleId;
402         }
403         require(tokenSaleId[_to] == currentTokenSaleId);
404 
405         balances[_to] = balances[_to].add(_amount);
406 
407         emit Mint(_to, _amount);
408         emit Transfer(address(0), _to, _amount);
409         return true;
410     }
411 
412     /// @dev Mints tokens for several addresses in one single call.
413     /// @param _to address[] The addresses that get the tokens.
414     /// @param _amount address[] The number of tokens to be minted.
415     /// @return A boolean that indicates if the operation was successful.
416     function mintInBatches(address[] _to, uint256[] _amount) external onlyAssigner tokenSaleIsOngoing returns(bool) {
417         require(_to.length > 0);
418         require(_to.length == _amount.length);
419         require(_to.length <= MAX_BATCH_SIZE);
420 
421         for (uint i = 0; i < _to.length; i++) {
422             mint(_to[i], _amount[i]);
423         }
424         return true;
425     }
426 
427     /// @dev Function to assign any number of tokens to a given address.
428     ///      Compared to the `mint` function, the `assign` function allows not just to increase but also to decrease
429     ///      the number of tokens of an address by assigning a lower value than the address current balance.
430     ///      This function can only be executed during initial token sale.
431     /// @param _to The address that will receive the assigned tokens.
432     /// @param _amount The amount of tokens to assign.
433     /// @return True if the operation was successful.
434     function assign(address _to, uint256 _amount) public onlyAssigner tokenSaleIsOngoing returns(bool) {
435         require(currentTokenSaleId == 1);
436 
437         // The desired value to assign (`_amount`) can be either higher or lower than the current number of tokens
438         // of the address (`balances[_to]`). To calculate the new `totalSupply_` value, the difference between `_amount`
439         // and `balances[_to]` (`delta`) is calculated first, and then added or substracted to `totalSupply_` accordingly.
440         uint256 delta = 0;
441         if (balances[_to] < _amount) {
442             // balances[_to] will be increased, so totalSupply_ should be increased
443             delta = _amount.sub(balances[_to]);
444             totalSupply_ = totalSupply_.add(delta);
445         } else {
446             // balances[_to] will be decreased, so totalSupply_ should be decreased
447             delta = balances[_to].sub(_amount);
448             totalSupply_ = totalSupply_.sub(delta);
449         }
450         require(totalSupply_ <= MAX_TOKEN_SUPPLY);
451 
452         balances[_to] = _amount;
453         tokenSaleId[_to] = currentTokenSaleId;
454 
455         emit Assign(_to, _amount);
456         emit Transfer(address(0), _to, _amount);
457         return true;
458     }
459 
460     /// @dev Assigns tokens to several addresses in one call.
461     /// @param _to address[] The addresses that get the tokens.
462     /// @param _amount address[] The number of tokens to be assigned.
463     /// @return True if the operation was successful.
464     function assignInBatches(address[] _to, uint256[] _amount) external onlyAssigner tokenSaleIsOngoing returns(bool) {
465         require(_to.length > 0);
466         require(_to.length == _amount.length);
467         require(_to.length <= MAX_BATCH_SIZE);
468 
469         for (uint i = 0; i < _to.length; i++) {
470             assign(_to[i], _amount[i]);
471         }
472         return true;
473     }
474 
475     /// @dev Allows the current owner to change the locker.
476     /// @param _newLocker The address of the new locker.
477     /// @return True if the operation was successful.
478     function transferLocker(address _newLocker) external onlyOwner returns(bool) {
479         require(_newLocker != address(0));
480 
481         emit LockerTransferred(locker, _newLocker);
482         locker = _newLocker;
483         return true;
484     }
485 
486     /// @dev Locks an address. A locked address cannot transfer its tokens or other addresses' tokens out.
487     ///      Only addresses participating in the current token sale can be locked.
488     ///      Only the locker account can lock addresses and only during the token sale.
489     /// @param _address address The address to lock.
490     /// @return True if the operation was successful.
491     function lockAddress(address _address) public onlyLocker tokenSaleIsOngoing returns(bool) {
492         require(tokenSaleId[_address] == currentTokenSaleId);
493         require(!locked[_address]);
494 
495         locked[_address] = true;
496         emit Lock(_address);
497         return true;
498     }
499 
500     /// @dev Unlocks an address so that its owner can transfer tokens out again.
501     ///      Addresses can be unlocked any time. Only the locker account can unlock addresses
502     /// @param _address address The address to unlock.
503     /// @return True if the operation was successful.
504     function unlockAddress(address _address) public onlyLocker returns(bool) {
505         require(locked[_address]);
506 
507         locked[_address] = false;
508         emit Unlock(_address);
509         return true;
510     }
511 
512     /// @dev Locks several addresses in one single call.
513     /// @param _addresses address[] The addresses to lock.
514     /// @return True if the operation was successful.
515     function lockInBatches(address[] _addresses) external onlyLocker returns(bool) {
516         require(_addresses.length > 0);
517         require(_addresses.length <= MAX_BATCH_SIZE);
518 
519         for (uint i = 0; i < _addresses.length; i++) {
520             lockAddress(_addresses[i]);
521         }
522         return true;
523     }
524 
525     /// @dev Unlocks several addresses in one single call.
526     /// @param _addresses address[] The addresses to unlock.
527     /// @return True if the operation was successful.
528     function unlockInBatches(address[] _addresses) external onlyLocker returns(bool) {
529         require(_addresses.length > 0);
530         require(_addresses.length <= MAX_BATCH_SIZE);
531 
532         for (uint i = 0; i < _addresses.length; i++) {
533             unlockAddress(_addresses[i]);
534         }
535         return true;
536     }
537 
538     /// @dev Checks whether or not the given address is locked.
539     /// @param _address address The address to be checked.
540     /// @return Boolean indicating whether or not the address is locked.
541     function isLocked(address _address) external view returns(bool) {
542         return locked[_address];
543     }
544 
545     /// @dev Transfers tokens to the specified address. It prevents transferring tokens from a locked address.
546     ///      Locked addresses can receive tokens.
547     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
548     /// @param _to The address to transfer tokens to.
549     /// @param _value The number of tokens to be transferred.
550     function transfer(address _to, uint256 _value) public returns(bool) {
551         require(!locked[msg.sender]);
552 
553         if (tokenSaleOngoing) {
554             require(tokenSaleId[msg.sender] < currentTokenSaleId);
555             require(tokenSaleId[_to] < currentTokenSaleId);
556         }
557 
558         return super.transfer(_to, _value);
559     }
560 
561     /// @dev Transfers tokens from one address to another. It prevents transferring tokens if the caller is locked or
562     ///      if the allowed address is locked.
563     ///      Locked addresses can receive tokens.
564     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
565     /// @param _from address The address to transfer tokens from.
566     /// @param _to address The address to transfer tokens to.
567     /// @param _value The number of tokens to be transferred.
568     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
569         require(!locked[msg.sender]);
570         require(!locked[_from]);
571 
572         if (tokenSaleOngoing) {
573             require(tokenSaleId[msg.sender] < currentTokenSaleId);
574             require(tokenSaleId[_from] < currentTokenSaleId);
575             require(tokenSaleId[_to] < currentTokenSaleId);
576         }
577 
578         return super.transferFrom(_from, _to, _value);
579     }
580 }
581 
582 
583 /// @title  ExchangeRate
584 /// @author Jose Perez - <jose.perez@diginex.com>
585 /// @notice Tamper-proof record of exchange rates e.g. BTC/USD, ETC/USD, etc.
586 /// @dev    Exchange rates are updated from off-chain server periodically. Rates are taken from a
587 //          publicly available third-party provider, such as Coinbase, CoinMarketCap, etc.
588 contract ExchangeRate is Ownable {
589     event RateUpdated(string id, uint256 rate);
590     event UpdaterTransferred(address indexed previousUpdater, address indexed newUpdater);
591 
592     address public updater;
593 
594     mapping(string => uint256) internal currentRates;
595 
596     /// @dev The ExchangeRate constructor.
597     /// @param _updater Account which can update the rates.
598     constructor(address _updater) public {
599         require(_updater != address(0));
600         updater = _updater;
601     }
602 
603     /// @dev Throws if called by any account other than the updater.
604     modifier onlyUpdater() {
605         require(msg.sender == updater);
606         _;
607     }
608 
609     /// @dev Allows the current owner to change the updater.
610     /// @param _newUpdater The address of the new updater.
611     function transferUpdater(address _newUpdater) external onlyOwner {
612         require(_newUpdater != address(0));
613         emit UpdaterTransferred(updater, _newUpdater);
614         updater = _newUpdater;
615     }
616 
617     /// @dev Allows the current updater account to update a single rate.
618     /// @param _id The rate identifier.
619     /// @param _rate The exchange rate.
620     function updateRate(string _id, uint256 _rate) external onlyUpdater {
621         require(_rate != 0);
622         currentRates[_id] = _rate;
623         emit RateUpdated(_id, _rate);
624     }
625 
626     /// @dev Allows anyone to read the current rate.
627     /// @param _id The rate identifier.
628     /// @return The current rate.
629     function getRate(string _id) external view returns(uint256) {
630         return currentRates[_id];
631     }
632 }
633 
634 
635 /// @title  VestingTrustee
636 /// @author Jose Perez - <jose.perez@diginex.com>
637 /// @notice Vesting trustee contract for Diginex ERC20 tokens. Tokens are granted to specific
638 ///         addresses and vested under certain criteria (vesting period, cliff period, etc.)
639 ///         Tokens must be transferred to the VestingTrustee contract address prior to granting them.
640 contract VestingTrustee is Ownable {
641     using SafeMath for uint256;
642 
643     // ERC20 contract.
644     Token public token;
645 
646     // The address allowed to grant and revoke tokens.
647     address public vester;
648 
649     // Vesting grant for a specific holder.
650     struct Grant {
651         uint256 value;
652         uint256 start;
653         uint256 cliff;
654         uint256 end;
655         uint256 installmentLength; // In seconds.
656         uint256 transferred;
657         bool revocable;
658     }
659 
660     // Holder to grant information mapping.
661     mapping (address => Grant) public grants;
662 
663     // Total tokens available for vesting.
664     uint256 public totalVesting;
665 
666     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
667     event TokensUnlocked(address indexed _to, uint256 _value);
668     event GrantRevoked(address indexed _holder, uint256 _refund);
669     event VesterTransferred(address indexed previousVester, address indexed newVester);
670 
671     /// @dev Constructor that initializes the VestingTrustee contract.
672     /// @param _diginexCoin The address of the previously deployed ERC20 token contract.
673     /// @param _vester The vester address.
674     constructor(Token _diginexCoin, address _vester) public {
675         require(_diginexCoin != address(0));
676         require(_vester != address(0));
677 
678         token = _diginexCoin;
679         vester = _vester;
680     }
681 
682     // @dev Prevents being called by any account other than the vester.
683     modifier onlyVester() {
684         require(msg.sender == vester);
685         _;
686     }
687 
688     /// @dev Allows the owner to change the vester.
689     /// @param _newVester The address of the new vester.
690     /// @return True if the operation was successful.
691     function transferVester(address _newVester) external onlyOwner returns(bool) {
692         require(_newVester != address(0));
693 
694         emit VesterTransferred(vester, _newVester);
695         vester = _newVester;
696         return true;
697     }
698     
699 
700     /// @dev Grant tokens to a specified address. All time units are in seconds since Unix epoch.
701     ///      Tokens must be transferred to the VestingTrustee contract address prior to calling this
702     ///      function. The number of tokens assigned to the VestingTrustee contract address must
703     //       always be equal or greater than the total number of vested tokens.
704     /// @param _to address The holder address.
705     /// @param _value uint256 The amount of tokens to be granted.
706     /// @param _start uint256 The beginning of the vesting period.
707     /// @param _cliff uint256 Time, between _start and _end, when the first installment is made.
708     /// @param _end uint256 The end of the vesting period.
709     /// @param _installmentLength uint256 The length of each vesting installment.
710     /// @param _revocable bool Whether the grant is revocable or not.
711     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,
712         uint256 _installmentLength, bool _revocable)
713         external onlyVester {
714 
715         require(_to != address(0));
716         require(_to != address(this)); // Don't allow holder to be this contract.
717         require(_value > 0);
718 
719         // Require that every holder can be granted tokens only once.
720         require(grants[_to].value == 0);
721 
722         // Require for time ranges to be consistent and valid.
723         require(_start <= _cliff && _cliff <= _end);
724 
725         // Require installment length to be valid and no longer than (end - start).
726         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
727 
728         // Grant must not exceed the total amount of tokens currently available for vesting.
729         require(totalVesting.add(_value) <= token.balanceOf(address(this)));
730 
731         // Assign a new grant.
732         grants[_to] = Grant({
733             value: _value,
734             start: _start,
735             cliff: _cliff,
736             end: _end,
737             installmentLength: _installmentLength,
738             transferred: 0,
739             revocable: _revocable
740         });
741 
742         // Since tokens have been granted, increase the total amount of vested tokens.
743         // This indirectly reduces the total amount available for vesting.
744         totalVesting = totalVesting.add(_value);
745 
746         emit NewGrant(msg.sender, _to, _value);
747     }
748 
749     /// @dev Revoke the grant of tokens of a specified grantee address.
750     ///      The vester can arbitrarily revoke the tokens of a revocable grant anytime.
751     ///      However, the grantee owns `calculateVestedTokens` number of tokens, even if some of them
752     ///      have not been transferred to the grantee yet. Therefore, the `revoke` function should
753     ///      transfer all non-transferred tokens to their rightful owner. The rest of the granted tokens
754     ///      should be transferred to the vester.
755     /// @param _holder The address which will have its tokens revoked.
756     function revoke(address _holder) public onlyVester {
757         Grant storage holderGrant = grants[_holder];
758 
759         // Grant must be revocable.
760         require(holderGrant.revocable);
761 
762         // Calculate number of tokens to be transferred to vester and to holder:
763         // holderGrant.value = toVester + vested = toVester + ( toHolder + holderGrant.transferred )
764         uint256 vested = calculateVestedTokens(holderGrant, now);
765         uint256 toVester = holderGrant.value.sub(vested);
766         uint256 toHolder = vested.sub(holderGrant.transferred);
767 
768         // Remove grant information.
769         delete grants[_holder];
770 
771         // Update totalVesting.
772         totalVesting = totalVesting.sub(toHolder);
773         totalVesting = totalVesting.sub(toVester);
774 
775         // Transfer tokens.
776         token.transfer(_holder, toHolder);
777         token.transfer(vester, toVester);
778         
779         emit GrantRevoked(_holder, toVester);
780     }
781 
782     /// @dev Calculate amount of vested tokens at a specifc time.
783     /// @param _grant Grant The vesting grant.
784     /// @param _time uint256 The time to be checked
785     /// @return a uint256 Representing the amount of vested tokens of a specific grant.
786     function calculateVestedTokens(Grant _grant, uint256 _time) private pure returns (uint256) {
787         // If we're before the cliff, then nothing is vested.
788         if (_time < _grant.cliff) {
789             return 0;
790         }
791 
792         // If we're after the end of the vesting period - everything is vested;
793         if (_time >= _grant.end) {
794             return _grant.value;
795         }
796 
797         // Calculate amount of installments past until now.
798         // NOTE: result gets floored because of integer division.
799         uint256 installmentsPast = _time.sub(_grant.start).div(_grant.installmentLength);
800 
801         // Calculate amount of days in entire vesting period.
802         uint256 vestingDays = _grant.end.sub(_grant.start);
803 
804         // Calculate and return installments that have passed according to vesting days that have passed.
805         return _grant.value.mul(installmentsPast.mul(_grant.installmentLength)).div(vestingDays);
806     }
807 
808     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
809     /// @param _holder address The address of the holder.
810     /// @param _time uint256 The specific time to calculate against.
811     /// @return a uint256 Representing a holder's total amount of vested tokens.
812     function vestedTokens(address _holder, uint256 _time) external view returns (uint256) {
813         Grant memory holderGrant = grants[_holder];
814 
815         if (holderGrant.value == 0) {
816             return 0;
817         }
818 
819         return calculateVestedTokens(holderGrant, _time);
820     }
821 
822     /// @dev Unlock vested tokens and transfer them to their holder.
823     /// @param _holder address The address of the holder.
824     function unlockVestedTokens(address _holder) external {
825         Grant storage holderGrant = grants[_holder];
826 
827         // Require that there will be funds left in grant to transfer to holder.
828         require(holderGrant.value.sub(holderGrant.transferred) > 0);
829 
830         // Get the total amount of vested tokens, according to grant.
831         uint256 vested = calculateVestedTokens(holderGrant, now);
832         if (vested == 0) {
833             return;
834         }
835 
836         // Make sure the holder doesn't transfer more than what he already has.
837         uint256 transferable = vested.sub(holderGrant.transferred);
838         if (transferable == 0) {
839             return;
840         }
841 
842         // Update transferred and total vesting amount, then transfer remaining vested funds to holder.
843         holderGrant.transferred = holderGrant.transferred.add(transferable);
844         totalVesting = totalVesting.sub(transferable);
845         token.transfer(_holder, transferable);
846 
847         emit TokensUnlocked(_holder, transferable);
848     }
849 }