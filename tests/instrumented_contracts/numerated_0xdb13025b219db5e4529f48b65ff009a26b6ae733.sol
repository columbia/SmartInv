1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function balanceOf(address _owner) external view returns (uint256);
9   function allowance(address _owner, address spender) external view returns (uint256);
10   function transfer(address to, uint256 value) external returns (bool);
11   function transferFrom(address from, address to, uint256 value) external returns (bool);
12   function approve(address spender, uint256 value) external returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner=0xE2d9b8259F74a46b5E3f74A30c7867be0a5f5185;
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31  constructor() internal {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     if (a == 0) {
65       return 0;
66     }
67     uint256 c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     // uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return a / b;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 /**
100  * @title Helps contracts guard against reentrancy attacks.
101  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
102  * @dev If you mark a function `nonReentrant`, you should also
103  * mark it `external`.
104  */
105 contract ReentrancyGuard {
106 
107   /// @dev counter to allow mutex lock with only one SSTORE operation
108   uint256 private _guardCounter;
109 
110   constructor() internal {
111     // The counter starts at one to prevent changing it from zero to a non-zero
112     // value, which is a more expensive operation.
113     _guardCounter = 1;
114   }
115 
116   /**
117    * @dev Prevents a contract from calling itself, directly or indirectly.
118    * Calling a `nonReentrant` function from another `nonReentrant`
119    * function is not supported. It is possible to prevent this from happening
120    * by making the `nonReentrant` function external, and make it call a
121    * `private` function that does the actual work.
122    */
123   modifier nonReentrant() {
124     _guardCounter += 1;
125     uint256 localCounter = _guardCounter;
126     _;
127     require(localCounter == _guardCounter);
128   }
129 
130 }
131 contract Haltable is Ownable  {
132     
133   bool public halted;
134   
135    modifier stopInEmergency {
136     if (halted) revert();
137     _;
138   }
139 
140   modifier stopNonOwnersInEmergency {
141     if (halted && msg.sender != owner) revert();
142     _;
143   }
144 
145   modifier onlyInEmergency {
146     if (!halted) revert();
147     _;
148   }
149 
150   // called by the owner on emergency, triggers stopped state
151   function halt() external onlyOwner {
152     halted = true;
153   }
154 
155   // called by the owner on end of emergency, returns to normal state
156   function unhalt() external onlyOwner onlyInEmergency {
157     halted = false;
158   }
159 
160 }
161 contract Ubricoin is IERC20,Ownable,ReentrancyGuard,Haltable{
162   
163   using SafeMath for uint256;
164 
165   // UBN Token parameters
166   string public name = 'Ubricoin';
167   string public symbol = 'UBN';
168   string public version = '2.0';
169   uint256 public constant RATE = 1000;  //1 ether = 1000 Ubricoins tokens
170   
171   // min tokens to be a holder, 0.1
172   uint256 public constant MIN_HOLDER_TOKENS = 10 ** uint256(decimals - 1);
173   
174   // 18 decimals is the strongly suggested default, avoid changing it
175   uint8   public constant decimals = 18;
176   uint256 public constant decimalFactor = 10 ** uint256(decimals);
177   uint256 public totalSupply_;           // amount of tokens already sold/supply                                 
178   uint256 public constant TOTAL_SUPPLY = 10000000000 * decimalFactor; // The initialSupply or totalSupply of  100% Released at Token Distribution (TD)
179   uint256 public constant SALES_SUPPLY =  1300000000 * decimalFactor; // 2.30% Released at Token Distribution (TD)
180   
181   // Funds supply constants // tokens to be Distributed at every stage 
182   uint256 public AVAILABLE_FOUNDER_SUPPLY  =  1500000000 * decimalFactor; // 17.3% Released at TD 
183   uint256 public AVAILABLE_AIRDROP_SUPPLY  =  2000000000 * decimalFactor; // 22.9% Released at TD/Eco System Allocated
184   uint256 public AVAILABLE_OWNER_SUPPLY    =  2000000000 * decimalFactor; // 22.9% Released at TD 
185   uint256 public AVAILABLE_TEAMS_SUPPLY    =  3000000000 * decimalFactor; // 34.5% Released at TD 
186   uint256 public AVAILABLE_BONUS_SUPPLY    =   200000000 * decimalFactor; // 0.10% Released at TD 
187   uint256 public claimedTokens = 0;
188   
189   // Funds supply addresses constants // tokens distribution
190   address public constant AVAILABLE_FOUNDER_SUPPLY_ADDRESS = 0xAC762012330350DDd97Cc64B133536F8E32193a8; //AVAILABLE_FOUNDER_SUPPLY_ADDRESS 1
191   address public constant AVAILABLE_AIRDROP_SUPPLY_ADDRESS = 0x28970854Bfa61C0d6fE56Cc9daAAe5271CEaEC09; //AVAILABLE_AIRDROP_SUPPLY_ADDRESS 2 Eco system Allocated
192   address public constant AVAILABLE_OWNER_SUPPLY_ADDRESS = 0xE2d9b8259F74a46b5E3f74A30c7867be0a5f5185;   //AVAILABLE_OWNER_SUPPLY_ADDRESS   3
193   address public constant AVAILABLE_BONUS_SUPPLY_ADDRESS = 0xDE59297Bf5D1D1b9d38D8F50e55A270eb9aE136e;   //AVAILABLE_BONUS1_SUPPLY_ADDRESS  4
194   address public constant AVAILABLE_TEAMS_SUPPLY_ADDRESS = 0x9888375f4663891770DaaaF9286d97d44FeFC82E;   //AVAILABLE_RESERVE_TEAM_SUPPLY_ADDRESS 5
195 
196   // Token holders
197   address[] public holders;
198   
199 
200   // ICO address
201   address public icoAddress;
202   mapping (address => uint256) balances;  // This creates an array with all balances
203   mapping (address => mapping (address => uint256)) internal allowed;
204   
205   // Keeps track of whether or not an Ubricoin airdrop has been made to a particular address
206   mapping (address => bool) public airdrops;
207   
208   mapping (address => uint256) public holderNumber; // Holders number
209   
210   // This generates a public event on the blockchain that will notify clients
211   event Transfer(address indexed from, address indexed to, uint256 value);
212   event Approval(address indexed owner, address indexed spender, uint256 value);
213   event TransferredToken(address indexed to, uint256 value);
214   event FailedTransfer(address indexed to, uint256 value);
215   // This notifies clients about the amount burnt , only admin is able to burn the contract
216   event Burn(address from, uint256 value); 
217   event AirDropped ( address[] _recipient, uint256 _amount, uint256 claimedTokens);
218   event AirDrop_many ( address[] _recipient, uint256[] _amount, uint256 claimedTokens);
219   
220  
221     /**
222      * @dev Constructor that gives a portion of all existing tokens to various addresses.
223      * @dev Distribute founder, airdrop,owner, reserve_team and bonus_supply tokens
224      * @dev and Ico address for the remaining tokens
225      */
226   constructor () public  { 
227       
228         // Allocate tokens to the available_founder_supply_address fund 1
229         balances[AVAILABLE_FOUNDER_SUPPLY_ADDRESS] = AVAILABLE_FOUNDER_SUPPLY;
230         holders.push(AVAILABLE_FOUNDER_SUPPLY_ADDRESS);
231         emit Transfer(0x0, AVAILABLE_FOUNDER_SUPPLY_ADDRESS, AVAILABLE_FOUNDER_SUPPLY);
232 
233         // Allocate tokens to the available_airdrop_supply_address fund 2 eco system allocated
234         balances[AVAILABLE_AIRDROP_SUPPLY_ADDRESS] = AVAILABLE_AIRDROP_SUPPLY;
235         holders.push(AVAILABLE_AIRDROP_SUPPLY_ADDRESS);
236         emit Transfer(0x0, AVAILABLE_AIRDROP_SUPPLY_ADDRESS, AVAILABLE_AIRDROP_SUPPLY);
237 
238         // Allocate tokens to the available_owner_supply_address fund 3
239         balances[AVAILABLE_OWNER_SUPPLY_ADDRESS] = AVAILABLE_OWNER_SUPPLY;
240         holders.push(AVAILABLE_OWNER_SUPPLY_ADDRESS);
241         emit Transfer(0x0, AVAILABLE_OWNER_SUPPLY_ADDRESS, AVAILABLE_OWNER_SUPPLY);
242 
243         // Allocate tokens to the available_reserve_team_supply_address fund 4
244         balances[AVAILABLE_TEAMS_SUPPLY_ADDRESS] = AVAILABLE_TEAMS_SUPPLY;
245         holders.push(AVAILABLE_TEAMS_SUPPLY_ADDRESS);
246         emit Transfer(0x0, AVAILABLE_TEAMS_SUPPLY_ADDRESS, AVAILABLE_TEAMS_SUPPLY);
247         
248         // Allocate tokens to the available_reserve_team_supply_address fund 5
249         balances[AVAILABLE_BONUS_SUPPLY_ADDRESS] = AVAILABLE_BONUS_SUPPLY;
250         holders.push(AVAILABLE_BONUS_SUPPLY_ADDRESS);
251         emit Transfer(0x0, AVAILABLE_BONUS_SUPPLY_ADDRESS, AVAILABLE_BONUS_SUPPLY);
252 
253         totalSupply_ = TOTAL_SUPPLY.sub(SALES_SUPPLY);
254         
255     }
256     
257    /**
258      * @dev Function fallback/payable to buy tokens from contract by sending ether.
259      * @notice Buy tokens from contract by sending ether
260      * @dev This are the tokens allocated for sale's supply
261      */
262   function () payable nonReentrant external  {
263       
264     require(msg.data.length == 0);
265     require(msg.value > 0);
266     
267       uint256 tokens = msg.value.mul(RATE); // calculates the aamount
268       balances[msg.sender] = balances[msg.sender].add(tokens);
269       totalSupply_ = totalSupply_.add(tokens);
270       owner.transfer(msg.value);  //make transfer
271       
272     }
273 
274     /**
275      * @dev set ICO address and allocate sale supply to it
276      *      Tokens left for payment using ethers
277      */
278   function setICO(address _icoAddress) public onlyOwner {
279       
280     require(_icoAddress != address(0));
281     require(icoAddress  == address(0));
282     require(totalSupply_ == TOTAL_SUPPLY.sub(SALES_SUPPLY));
283       
284        // Allocate tokens to the ico contract
285        balances[_icoAddress] = SALES_SUPPLY;
286        emit Transfer(0x0, _icoAddress, SALES_SUPPLY);
287 
288        icoAddress = _icoAddress;
289        totalSupply_ = TOTAL_SUPPLY;
290        
291     }
292 
293     /**
294      * @dev total number of tokens in existence
295      */
296   function totalSupply() public view returns (uint256) {
297       
298       return totalSupply_;
299       
300     }
301     
302     /**
303      * @dev Gets the balance of the specified address.
304      * @param _owner The address to query the the balance of.
305      * @return An uint256 representing the amount owned by the passed address.
306      */
307   function balanceOf(address _owner) public view returns (uint256 balance) {
308       
309       return balances[_owner];
310       
311     }
312   
313 
314    /**
315      * @dev Function to check the amount of tokens that an owner allowed to a spender.
316      * @param _owner address The address which owns the funds.
317      * @param _spender address The address which will spend the funds.
318      * @return A uint256 specifying the amount of tokens still available for the spender.
319      */
320   function allowance(address _owner, address _spender) public view returns (uint256 remaining ) {
321       
322       return allowed[_owner][_spender];
323       
324     }
325     
326     /**
327      * Internal transfer, only can be called by this contract
328      */
329   function _transfer(address _from, address _to, uint256 _value) internal {
330       
331     require(_to != 0x0);                 // Prevent transfer to 0x0 address. Use burn() instead
332     require(balances[_from] >= _value);  // Check if the sender has enough
333     require(balances[_to] + _value >= balances[_to]);             // Check for overflows
334      
335       uint256 previousBalances = balances[_from] + balances[_to];   // Save this for an assertion in the future
336       balances[_from] -= _value;   // Subtract from the sender
337       balances[_to] += _value;     // Add the same to the recipient
338       emit Transfer(_from, _to, _value);
339       
340       // Asserts are used to use static analysis to find bugs in your code. They should never fail
341       assert(balances[_from] + balances[_to] == previousBalances);  
342       
343     }
344     
345    
346     /**
347      * Standard transfer function 
348      * Transfer tokens
349      *
350      * Send `_value` tokens to `_to` from your account
351      *
352      * @param _to The address of the recipient
353      * @param _value the amount to send
354      */
355   function transfer(address _to, uint256 _value) public returns (bool success) {
356       
357        require(balances[msg.sender] > 0);                     
358        require(balances[msg.sender] >= _value);  // Check if the sender has enough  
359        require(_to != address(0x0));             // Prevent transfer to 0x0 address. Use burn() instead
360        
361        require(_value > 0);	
362        require(_to != msg.sender);               // Check if sender and receiver is not same
363        require(_value <= balances[msg.sender]);
364 
365        // SafeMath.sub will throw if there is not enough balance.
366        balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract value from sender
367        balances[_to] = balances[_to].add(_value);               // Add the value to the receiver
368        emit Transfer(msg.sender, _to, _value);                  // Notify all clients about the transfer events
369        return true;
370        
371     }
372     
373     /**
374      * @dev Transfer tokens from one address to another
375      * @param _from address The address which you want to send tokens from
376      * @param _to address The address which you want to transfer to
377      * @param _value uint256 the amount of tokens to be transferred
378      */
379   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
380       
381     require(_to != address(0x0));
382     require(_value <= balances[_from]);
383     require(_value <= allowed[_from][msg.sender]);  // Check allowance
384 
385       balances[_from] = balances[_from].sub(_value);
386       balances[_to] = balances[_to].add(_value);
387       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
388       emit Transfer(_from, _to, _value);
389       return true;
390       
391    }
392 
393     /**
394      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
395      *
396      * Beware that changing an allowance with this method brings the risk that someone may use both the old
397      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
398      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
399      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
400      * @param _spender The address which will spend the funds.
401      * @param _value The amount of tokens to be spent.
402     */
403   function approve(address _spender, uint256 _value) public returns (bool success) {
404       
405       allowed[msg.sender][_spender] = _value;
406       emit  Approval(msg.sender, _spender, _value);
407       return true;
408       
409     }
410     
411   // get holders count
412   function getHoldersCount() public view returns (uint256) {
413       
414         return holders.length;
415     }
416     
417   // preserve holders list
418   function preserveHolders(address _from, address _to, uint256 _value) internal {
419       
420         if (balances[_from].sub(_value) < MIN_HOLDER_TOKENS) 
421             removeHolder(_from);
422         if (balances[_to].add(_value) >= MIN_HOLDER_TOKENS) 
423             addHolder(_to);   
424     }
425 
426   // remove holder from the holders list
427   function removeHolder(address _holder) internal {
428       
429         uint256 _number = holderNumber[_holder];
430 
431         if (_number == 0 || holders.length == 0 || _number > holders.length)
432             return;
433 
434         uint256 _index = _number.sub(1);
435         uint256 _lastIndex = holders.length.sub(1);
436         address _lastHolder = holders[_lastIndex];
437 
438         if (_index != _lastIndex) {
439             holders[_index] = _lastHolder;
440             holderNumber[_lastHolder] = _number;
441         }
442 
443         holderNumber[_holder] = 0;
444         holders.length = _lastIndex;
445     } 
446 
447   // add holder to the holders list
448   function addHolder(address _holder) internal {
449       
450         if (holderNumber[_holder] == 0) {
451             holders.push(_holder);
452             holderNumber[_holder] = holders.length;
453             
454         }
455     }
456 
457     /**
458      * @dev Internal function that burns an amount of the token of a given
459      * account.
460      * @param account The account whose tokens will be burnt.
461      * @param value The amount that will be burnt.
462      */
463  function _burn(address account, uint256 value) external onlyOwner {
464      
465       require(balances[msg.sender] >= value);   // Check if the sender has enough
466       balances[msg.sender] -= value;            // Subtract from the sender
467       totalSupply_ -= value;                    // Updates totalSupply
468       emit Burn(msg.sender, value);
469       //return true;
470       
471       require(account != address(0x0));
472 
473       totalSupply_ = totalSupply_.sub(value);
474       balances[account] = balances[account].sub(value);
475       emit Transfer(account, address(0X0), value);
476      
477     }
478     
479     /**
480      * @dev Internal function that burns an amount of the token of a given
481      * account, deducting from the sender's allowance for said account. Uses the
482      * internal burn function.
483      * Emits an Approval event (reflecting the reduced allowance).
484      * @param account The account whose tokens will be burnt.
485      * @param value The amount that will be burnt.
486      */
487   function _burnFrom(address account, uint256 value) external onlyOwner {
488       
489       require(balances[account] >= value);               // Check if the targeted balance is enough
490       require(value <= allowed[account][msg.sender]);    // Check allowance
491       balances[account] -= value;                        // Subtract from the targeted balance
492       allowed[account][msg.sender] -= value;             // Subtract from the sender's allowance
493       totalSupply_ -= value;                             // Update totalSupply
494       emit Burn(account, value);
495       // return true; 
496       
497       allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
498       emit Burn(account, value);
499       emit Approval(account, msg.sender, allowed[account][msg.sender]);
500       
501     }
502     
503   function validPurchase() internal returns (bool) {
504       
505       bool lessThanMaxInvestment = msg.value <= 1000 ether; // change the value to whatever you need
506       return validPurchase() && lessThanMaxInvestment;
507       
508     }
509     
510     /**
511      * @dev Internal function that mints an amount of the token and assigns it to
512      * an account. This encapsulates the modification of balances such that the
513      * proper events are emitted.
514      * @param target The account that will receive the created tokens.
515      * @param mintedAmount The amount that will be created.
516      * @dev  perform a minting/create new UBN's for new allocations
517      * @param  target is the address to mint tokens to
518      * 
519      */
520   function mintToken(address target, uint256 mintedAmount) public onlyOwner {
521       
522       balances[target] += mintedAmount;
523       totalSupply_ += mintedAmount;
524       
525       emit Transfer(0, owner, mintedAmount);
526       emit Transfer(owner, target, mintedAmount);
527       
528     }
529     
530     /**
531     * @dev perform a transfer of allocations
532     * @param _recipient is a list of recipients
533     * 
534     * Below function can be used when you want to send every recipeint with different number of tokens
535     * 
536     */
537   function airDrop_many(address[] _recipient, uint256[] _amount) public onlyOwner {
538         
539         require(msg.sender == owner);
540         require(_recipient.length == _amount.length);
541         uint256 amount = _amount[i] * uint256(decimalFactor);
542         uint256 airdropped;
543     
544         for (uint i=0; i < _recipient.length; i++) {
545            if (!airdrops[_recipient[i]]) {
546                 airdrops[_recipient[i]] = true;
547                 require(Ubricoin.transfer(_recipient[i], _amount[i] * decimalFactor));
548                 //Ubricoin.transfer(_recipient[i], _amount[i]);
549                 airdropped = airdropped.add(amount );
550             } else{
551                 
552                  emit FailedTransfer(_recipient[i], airdropped); 
553         }
554         
555     AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
556     //totalSupply_ = totalSupply_.sub(airdropped);
557     claimedTokens = claimedTokens.add(airdropped);
558     emit AirDrop_many(_recipient, _amount, claimedTokens);
559     
560         }
561     }
562     
563    /**
564     * @dev perform a transfer of allocations
565     * @param _recipient is a list of recipients
566     * 
567     * this function can be used when you want to send same number of tokens to all the recipients
568     * 
569     */
570   function airDrop(address[] _recipient, uint256 _amount) public onlyOwner {
571       
572         require(_amount > 0);
573         uint256 airdropped;
574         uint256 amount = _amount * uint256(decimalFactor);
575         for (uint256 index = 0; index < _recipient.length; index++) {
576             if (!airdrops[_recipient[index]]) {
577                 airdrops[_recipient[index]] = true;
578                 require(Ubricoin.transfer(_recipient[index], amount * decimalFactor ));
579                 airdropped = airdropped.add(amount );
580             }else{
581             
582             emit FailedTransfer(_recipient[index], airdropped); 
583         }
584     }
585         
586     AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
587     //totalSupply_ = totalSupply_.sub(airdropped);
588     claimedTokens = claimedTokens.add(airdropped);
589     emit AirDropped(_recipient, _amount, claimedTokens);
590     
591     }
592     
593 
594 }