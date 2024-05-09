1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
258 
259 /**
260  * @title Burnable Token
261  * @dev Token that can be irreversibly burned (destroyed).
262  */
263 contract BurnableToken is BasicToken {
264 
265   event Burn(address indexed burner, uint256 value);
266 
267   /**
268    * @dev Burns a specific amount of tokens.
269    * @param _value The amount of token to be burned.
270    */
271   function burn(uint256 _value) public {
272     _burn(msg.sender, _value);
273   }
274 
275   function _burn(address _who, uint256 _value) internal {
276     require(_value <= balances[_who]);
277     // no need to require value <= totalSupply, since that would imply the
278     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
279 
280     balances[_who] = balances[_who].sub(_value);
281     totalSupply_ = totalSupply_.sub(_value);
282     emit Burn(_who, _value);
283     emit Transfer(_who, address(0), _value);
284   }
285 }
286 
287 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295   address public owner;
296 
297 
298   event OwnershipRenounced(address indexed previousOwner);
299   event OwnershipTransferred(
300     address indexed previousOwner,
301     address indexed newOwner
302   );
303 
304 
305   /**
306    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
307    * account.
308    */
309   constructor() public {
310     owner = msg.sender;
311   }
312 
313   /**
314    * @dev Throws if called by any account other than the owner.
315    */
316   modifier onlyOwner() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Allows the current owner to relinquish control of the contract.
323    * @notice Renouncing to ownership will leave the contract without an owner.
324    * It will not be possible to call the functions with the `onlyOwner`
325    * modifier anymore.
326    */
327   function renounceOwnership() public onlyOwner {
328     emit OwnershipRenounced(owner);
329     owner = address(0);
330   }
331 
332   /**
333    * @dev Allows the current owner to transfer control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336   function transferOwnership(address _newOwner) public onlyOwner {
337     _transferOwnership(_newOwner);
338   }
339 
340   /**
341    * @dev Transfers control of the contract to a newOwner.
342    * @param _newOwner The address to transfer ownership to.
343    */
344   function _transferOwnership(address _newOwner) internal {
345     require(_newOwner != address(0));
346     emit OwnershipTransferred(owner, _newOwner);
347     owner = _newOwner;
348   }
349 }
350 
351 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
357  */
358 contract MintableToken is StandardToken, Ownable {
359   event Mint(address indexed to, uint256 amount);
360   event MintFinished();
361 
362   bool public mintingFinished = false;
363 
364 
365   modifier canMint() {
366     require(!mintingFinished);
367     _;
368   }
369 
370   modifier hasMintPermission() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(
382     address _to,
383     uint256 _amount
384   )
385     public
386     hasMintPermission
387     canMint
388     returns (bool)
389   {
390     totalSupply_ = totalSupply_.add(_amount);
391     balances[_to] = balances[_to].add(_amount);
392     emit Mint(_to, _amount);
393     emit Transfer(address(0), _to, _amount);
394     return true;
395   }
396 
397   /**
398    * @dev Function to stop minting new tokens.
399    * @return True if the operation was successful.
400    */
401   function finishMinting() public onlyOwner canMint returns (bool) {
402     mintingFinished = true;
403     emit MintFinished();
404     return true;
405   }
406 }
407 
408 // File: contracts/QBTCoin.sol
409 
410 contract QBTCoin is StandardToken, BurnableToken, Ownable, MintableToken {
411     using SafeMath for uint256;
412 
413     string public constant symbol = "QBT";
414     string public constant name = "QBT Coin";
415     uint8 public constant decimals = 18;
416     uint256 public constant INITIAL_SUPPLY = 2500000000 * (10 ** uint256(decimals));
417     uint256 public constant TOKEN_SALE_ALLOWANCE = 1250000000 * (10 ** uint256(decimals));
418     uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_SALE_ALLOWANCE;
419 
420     // Address of token administrator
421     address public adminAddr;
422 
423     // Address of token sale contract
424     address public tokenSaleAddr;
425 
426     // Enable transfer after token sale is completed
427     bool public transferEnabled = false;
428 
429     // Accounts to be locked for certain period
430     mapping(address => uint256) private lockedAccounts;
431 
432     /*
433      *
434      * Permissions when transferEnabled is false :
435      *              ContractOwner    Admin    SaleCon2ract    Others
436      * transfer            x           v            v           x
437      * transferFrom        x           v            v           x
438      *
439      * Permissions when transferEnabled is true :
440      *              ContractOwner    Admin    SaleContract    Others
441      * transfer            v           v            v           v
442      * transferFrom        v           v            v           v
443      *
444      */
445 
446     /*
447      * Check if token transfer is allowed
448      * Permission table above is result of this modifier
449      */
450     modifier onlyWhenTransferAllowed() {
451         require(transferEnabled == true
452             || msg.sender == adminAddr
453             || msg.sender == tokenSaleAddr);
454         _;
455     }
456 
457     /*
458      * Check if token sale address is not set
459      */
460     modifier onlyWhenTokenSaleAddrNotSet() {
461         require(tokenSaleAddr == address(0x0));
462         _;
463     }
464 
465     /*
466      * Check if token transfer destination is valid
467      */
468     modifier onlyValidDestination(address to) {
469         require(to != address(0x0)
470             && to != address(this)
471             && to != owner
472             && to != adminAddr
473             && to != tokenSaleAddr);
474         _;
475     }
476 
477     modifier onlyAllowedAmount(address from, uint256 amount) {
478         require(balances[from].sub(amount) >= lockedAccounts[from]);
479         _;
480     }
481     /*
482      * The constructor of QBTCoin contract
483      *
484      * @param _adminAddr: Address of token administrator
485      */
486     constructor(address _adminAddr) public {
487         totalSupply_ = INITIAL_SUPPLY;
488 
489         balances[msg.sender] = totalSupply_;
490         emit Transfer(address(0x0), msg.sender, totalSupply_);
491 
492         adminAddr = _adminAddr;
493         approve(adminAddr, ADMIN_ALLOWANCE);
494     }
495 
496     /*
497      * Change admin address 
498      */
499     function changeAdmin(address _adminAddr) public onlyOwner {
500         adminAddr = _adminAddr;
501     }
502 
503     /*
504      * Set amount of token sale to approve allowance for sale contract
505      *
506      * @param _tokenSaleAddr: Address of sale contract
507      * @param _amountForSale: Amount of token for sale
508      */
509     function setTokenSaleAmount(address _tokenSaleAddr, uint256 amountForSale)
510         external
511         onlyOwner
512         onlyWhenTokenSaleAddrNotSet
513     {
514         require(!transferEnabled);
515 
516         uint256 amount = (amountForSale == 0) ? TOKEN_SALE_ALLOWANCE : amountForSale;
517         require(amount <= TOKEN_SALE_ALLOWANCE);
518 
519         approve(_tokenSaleAddr, amount);
520         tokenSaleAddr = _tokenSaleAddr;
521     }
522 
523     /*
524      * Set transferEnabled variable to true
525      */
526     function enableTransfer() external onlyOwner {
527         transferEnabled = true;
528         approve(tokenSaleAddr, 0);
529     }
530 
531     /*
532      * Set transferEnabled variable to false
533      */
534     function disableTransfer() external onlyOwner {
535         transferEnabled = false;
536     }
537 
538     /*
539      * Transfer token from message sender to another
540      *
541      * @param to: Destination address
542      * @param value: Amount of QBT token to transfer
543      */
544     function transfer(address to, uint256 value)
545         public
546         onlyWhenTransferAllowed
547         onlyValidDestination(to)
548         onlyAllowedAmount(msg.sender, value)
549         returns (bool)
550     {
551         return super.transfer(to, value);
552     }
553 
554     /*
555      * Transfer token from 'from' address to 'to' addreess
556      *
557      * @param from: Origin address
558      * @param to: Destination address
559      * @param value: Amount of QBT Coin to transfer
560      */
561     function transferFrom(address from, address to, uint256 value)
562         public
563         onlyWhenTransferAllowed
564         onlyValidDestination(to)
565         onlyAllowedAmount(from, value)
566         returns (bool)
567     {
568         return super.transferFrom(from, to, value);
569     }
570 
571     /*
572      * Burn token, only owner is allowed
573      *
574      * @param value: Amount of QBT Coin to burn
575      */
576     function burn(uint256 value) public onlyOwner {
577         require(transferEnabled);
578         super.burn(value);
579     }
580 
581     function mint(address to, uint256 value) public onlyOwner returns(bool) {
582         require(transferEnabled);
583         super.mint(to, value);
584     }
585 
586     // function mint(uint256 value) public onlyOwner {
587         // require(transferEnabled);
588     //     super.mint(value);
589     // }
590     /*
591      * Disable transfering tokens more than allowed amount from certain account
592      *
593      * @param addr: Account to set allowed amount
594      * @param amount: Amount of tokens to allow
595      */
596     function lockAccount(address addr, uint256 amount)
597         external
598         onlyOwner
599         onlyValidDestination(addr)
600     {
601         require(amount > 0);
602         lockedAccounts[addr] = amount;
603     }
604 
605     /*
606      * Enable transfering tokens of locked account
607      *
608      * @param addr: Account to unlock
609      */
610 
611     function unlockAccount(address addr)
612         external
613         onlyOwner
614         onlyValidDestination(addr)
615     {
616         lockedAccounts[addr] = 0;
617     }
618 }