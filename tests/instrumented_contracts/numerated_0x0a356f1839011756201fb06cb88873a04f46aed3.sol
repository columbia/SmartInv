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
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     emit Transfer(_from, _to, _value);
171     emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
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
224     allowed[msg.sender][_spender].add(_addedValue));
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
322    * @dev Allows the current owner to transfer control of the contract to a newOwner.
323    * @param _newOwner The address to transfer ownership to.
324    */
325   function transferOwnership(address _newOwner) public onlyOwner {
326     _transferOwnership(_newOwner);
327   }
328 
329   /**
330    * @dev Transfers control of the contract to a newOwner.
331    * @param _newOwner The address to transfer ownership to.
332    */
333   function _transferOwnership(address _newOwner) internal {
334     require(_newOwner != address(0));
335     emit OwnershipTransferred(owner, _newOwner);
336     owner = _newOwner;
337   }
338 }
339 
340 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
341 
342 /**
343  * @title Mintable token
344  * @dev Simple ERC20 Token example, with mintable token creation
345  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
346  */
347 contract MintableToken is StandardToken, Ownable {
348   event Mint(address indexed to, uint256 amount);
349   event MintFinished();
350 
351   bool public mintingFinished = false;
352 
353 
354   modifier canMint() {
355     require(!mintingFinished);
356     _;
357   }
358 
359   /**
360    * @dev Function to mint tokens
361    * @param _to The address that will receive the minted tokens.
362    * @param _amount The amount of tokens to mint.
363    * @return A boolean that indicates if the operation was successful.
364    */
365   function mint(
366     address _to,
367     uint256 _amount
368   )
369     public
370     onlyOwner
371     canMint
372     returns (bool)
373   {
374     _mint(_to,_amount);
375     return true;
376   }
377 
378   function _mint(
379     address _to,
380     uint256 _amount
381   )
382     internal
383     returns (bool)
384   {
385     totalSupply_ = totalSupply_.add(_amount);
386     balances[_to] = balances[_to].add(_amount);
387     emit Mint(_to, _amount);
388     emit Transfer(address(0), _to, _amount);
389   }
390 
391   /**
392    * @dev Function to stop minting new tokens.
393    * @return True if the operation was successful.
394    */
395   function finishMinting() public onlyOwner canMint returns (bool) {
396     mintingFinished = true;
397     emit MintFinished();
398     return true;
399   }
400 }
401 
402 // File: contracts/QBEE.sol
403 
404 contract QueenBeeCompanyToken is StandardToken, BurnableToken, Ownable, MintableToken {
405     using SafeMath for uint256;
406 
407     event LockAccount(address addr, uint256 amount);
408     event UnlockAccount(address addr);
409     event ChangeAdmin(
410       address indexed previousAdmin,
411       address indexed newAdmin
412     );
413     event EnableTransfer();
414     event DisableTransfer();
415 
416 
417     string public constant symbol = "QBZ";
418     string public constant name = "QBEE";
419     uint8 public constant decimals = 18;
420 
421     uint256 public constant INITIAL_SUPPLY            = 8000000000 * (10 ** uint256(decimals));
422     uint256 public constant INITIAL_SUPPLY_15PERCENT  = 1200000000 * (10 ** uint256(decimals));
423     uint256 public constant INITIAL_SUPPLY_40PERCENT  = 3200000000 * (10 ** uint256(decimals));
424 
425     address public constant earlyFoundation     = 0x1980C8271Ba6BFaF1D5C43e8dAe655de8CFaBdBe;
426     address public constant advisorTeam         = 0xE65A71a07d0D431d01CE6342Ba56BB3A2f634165;
427     address public constant business            = 0x8A8f70f546c81EF8B178BBc4544d1F008C88096c;
428     address public constant publicAddr          = 0xC1486038AA29bF676478e2bB787F97298900E08b;
429     address public constant reserveAffiliates   = 0x086b779Eb55744A8518708f016fd5530493ecab5;
430 
431     // Address of token administrator
432     address public adminAddr;
433 
434     // Enable transfer after token sale is completed
435     bool public transferEnabled = true;
436 
437     // Accounts to be locked for certain period
438     mapping(address => uint256) private lockedAccounts;
439 
440     /*
441      *
442      * Permissions when transferEnabled is false :
443      *              ContractOwner    Admin      Others
444      * transfer            v           v           x
445      * transferFrom        v           v           x
446      *
447      * Permissions when transferEnabled is true :
448      *              ContractOwner    Admin      Others
449      * transfer            v           v           v
450      * transferFrom        v           v           v
451      *
452      */
453 
454     /*
455      * Check if token transfer is allowed
456      * Permission table above is result of this modifier
457      */
458     modifier onlyWhenTransferAllowed() {
459         require(transferEnabled == true
460 			|| msg.sender == owner
461             || msg.sender == adminAddr);
462         _;
463     }
464 
465     modifier onlyAllowedAmount(address from, uint256 amount) {
466         require(balances[from].sub(amount) >= lockedAccounts[from]);
467         _;
468     }
469     /*
470      * The constructor of QueenBeeCoin contract
471      *
472      * @param _adminAddr: Address of token administrator
473      */
474     constructor(address _adminAddr) public {
475         _mint(earlyFoundation, INITIAL_SUPPLY_15PERCENT);
476         _mint(advisorTeam, INITIAL_SUPPLY_15PERCENT);
477         _mint(business, INITIAL_SUPPLY_15PERCENT);
478         _mint(publicAddr, INITIAL_SUPPLY_40PERCENT);
479         _mint(reserveAffiliates, INITIAL_SUPPLY_15PERCENT);
480 
481         // token migration from old token
482         allowed[earlyFoundation][msg.sender] = INITIAL_SUPPLY_15PERCENT;
483         
484         address beneficiary_1 = 0xf559b5A8910183E9B5ca7DFA5A30e3CC38177056;
485         address beneficiary_2 = 0x8E39AAF968D65c2040f51145777700147B8025AB;
486         address beneficiary_3 = 0x34B400774388b922E42b1339b6DB8Df623D60ca4;
487         address beneficiary_4 = 0x4593E0a3bBEA7CEeb892e8ba8BBE808a3c8d3478;
488         address beneficiary_5 = 0x5068c0bDBe8c92F5fd4D346d1072C59359623de7;
489         address beneficiary_6 = 0xB2b588Ad768373b36109825871E65e99FEAc441B;
490         address beneficiary_7 = 0x9B82b4D087928497cb6728402f68e0C33DA5205C;
491 
492         uint256 token_1 = 16000000 * 10**uint256(decimals);
493         uint256 token_2 = 16000000 * 10**uint256(decimals);
494         uint256 token_3 =  8000000 * 10**uint256(decimals);
495         uint256 token_4 =  8000000 * 10**uint256(decimals);
496         uint256 token_5 =  4000000 * 10**uint256(decimals);
497         uint256 token_6 =  2000000 * 10**uint256(decimals);
498         uint256 token_7 =  2000000 * 10**uint256(decimals);
499         
500         transferFrom(earlyFoundation, beneficiary_1, token_1);
501         transferFrom(earlyFoundation, beneficiary_2, token_2);
502         transferFrom(earlyFoundation, beneficiary_3, token_3);
503         transferFrom(earlyFoundation, beneficiary_4, token_4);
504         transferFrom(earlyFoundation, beneficiary_5, token_5);
505         transferFrom(earlyFoundation, beneficiary_6, token_6);
506         transferFrom(earlyFoundation, beneficiary_7, token_7);
507         
508         allowed[earlyFoundation][msg.sender] = 0; 
509         adminAddr = _adminAddr;
510     }
511 
512     /*
513      * Change admin address 
514      */
515     function changeAdmin(address _adminAddr) public onlyOwner {
516         emit ChangeAdmin(adminAddr, _adminAddr);
517         adminAddr = _adminAddr;
518     }
519 
520 
521     /*
522      * Set transferEnabled variable to true
523      */
524     function enableTransfer() external onlyOwner {
525         transferEnabled = true;
526         emit EnableTransfer();
527     }
528 
529     /*
530      * Set transferEnabled variable to false
531      */
532     function disableTransfer() external onlyOwner {
533 	      transferEnabled = false;
534         emit DisableTransfer();
535     }
536 
537     /*
538      * Transfer token from message sender to another
539      *
540      * @param to: Destination address
541      * @param value: Amount of QBST to transfer
542      */
543     function transfer(address to, uint256 value)
544         public
545         onlyWhenTransferAllowed
546         onlyAllowedAmount(msg.sender, value)
547         returns (bool)
548     {
549         return super.transfer(to, value);
550     }
551 
552     /*
553      * Transfer token from 'from' address to 'to' addreess
554      *
555      * @param from: Origin address
556      * @param to: Destination address
557      * @param value: Amount of QBST to transfer
558      */
559     function transferFrom(address from, address to, uint256 value)
560         public
561         onlyWhenTransferAllowed
562         onlyAllowedAmount(from, value)
563         returns (bool)
564     {
565         return super.transferFrom(from, to, value);
566     }
567 
568     /*
569      * Burn token, only owner is allowed
570      *
571      * @param value: Amount of QBST to burn
572      */
573     function burn(uint256 value) public onlyOwner {
574         //require(transferEnabled);
575         super.burn(value);
576     }
577 
578     function mint(address to, uint256 value) public onlyOwner returns(bool) {
579         //require(transferEnabled);
580         require(totalSupply().add(value) <= INITIAL_SUPPLY);
581         super.mint(to, value);
582     }
583 
584     /*
585      * Disable transfering tokens more than allowed amount from certain account
586      *
587      * @param addr: Account to set allowed amount
588      * @param amount: Amount of tokens to allow
589      */
590     function lockAccount(address addr, uint256 amount)
591         external
592         onlyOwner
593     {
594         require(amount > 0 && amount <= balanceOf(addr));
595         lockedAccounts[addr] = amount;
596         emit LockAccount(addr, amount);
597     }
598 
599     /*
600      * Enable transfering tokens of locked account
601      *
602      * @param addr: Account to unlock
603      */
604 
605     function unlockAccount(address addr)
606         external
607         onlyOwner
608     {
609         lockedAccounts[addr] = 0;
610         emit UnlockAccount(addr);
611     }
612     
613     function lockedValue(address addr) public view returns(uint256) {
614         return lockedAccounts[addr];
615     }
616 }