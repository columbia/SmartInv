1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /////////////////////////////////////////////////////////////////////////////////////////////
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferIDCContractOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 /////////////////////////////////////////////////////////////////////////////////////////////
91 /**
92  * @title Claimable
93  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
94  * This allows the new owner to accept the transfer.
95  */
96 contract Claimable is Ownable {
97   address public pendingOwner;
98 
99   /**
100    * @dev Modifier throws if called by any account other than the pendingOwner.
101    */
102   modifier onlyPendingOwner() {
103     require(msg.sender == pendingOwner);
104     _;
105   }
106 
107   /**
108    * @dev Allows the current owner to set the pendingOwner address.
109    * @param newOwner The address to transfer ownership to.
110    */
111   function transferOwnership(address newOwner) onlyOwner public {
112     pendingOwner = newOwner;
113   }
114 
115   /**
116    * @dev Allows the pendingOwner address to finalize the transfer.
117    */
118   function claimOwnership() onlyPendingOwner public {
119    emit OwnershipTransferred(owner, pendingOwner);
120     owner = pendingOwner;
121     pendingOwner = address(0);
122   }
123 }
124 
125 /////////////////////////////////////////////////////////////////////////////////////////////
126 /**
127  * @title Contracts that should be able to recover tokens
128  * @author SylTi
129  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
130  * This will prevent any accidental loss of tokens.
131  */
132 contract CanReclaimToken is Ownable {
133   using SafeERC20 for ERC20Basic;
134 
135   /**
136    * @dev Reclaim all ERC20Basic compatible tokens
137    * @param token ERC20Basic The address of the token contract
138    */
139   function reclaimToken(ERC20Basic token) external onlyOwner {
140     uint256 balance = token.balanceOf(this);
141     token.safeTransfer(owner, balance);
142   }
143 
144 }
145 
146 /////////////////////////////////////////////////////////////////////////////////////////////
147 /**
148  * @title Contactable token
149  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
150  * contact information.
151  */
152 contract Contactable is Ownable {
153 
154   string public contactInformation;
155 
156   /**
157     * @dev Allows the owner to set a string with their contact information.
158     * @param info The contact information to attach to the contract.
159     */
160   function setContactInformation(string info) onlyOwner public {
161     contactInformation = info;
162   }
163 }
164 /////////////////////////////////////////////////////////////////////////////////////////////
165 /**
166  * @title Contracts that should not own Contracts
167  * @author Remco Bloemen <remco@2π.com>
168  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
169  * of this contract to reclaim ownership of the contracts.
170  */
171 contract HasNoContracts is Ownable {
172 
173   /**
174    * @dev Reclaim ownership of Ownable contracts
175    * @param contractAddr The address of the Ownable to be reclaimed.
176    */
177   function reclaimContract(address contractAddr) external onlyOwner {
178     Ownable contractInst = Ownable(contractAddr);
179     contractInst.transferIDCContractOwnership(owner);
180   }
181 }
182 /////////////////////////////////////////////////////////////////////////////////////////////
183 
184 /////////////////////////////////////////////////////////////////////////////////////////////
185 /**
186  * @title Contracts that should not own Tokens
187  * @author Remco Bloemen <remco@2π.com>
188  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
189  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
190  * owner to reclaim the tokens.
191  */
192 contract HasNoTokens is CanReclaimToken {
193 
194  /**
195   * @dev Reject all ERC223 compatible tokens
196   * @param from_ address The address that is transferring the tokens
197   * @param value_ uint256 the amount of the specified token
198   * @param data_ Bytes The data passed from the caller.
199   */
200   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
201     from_;
202     value_;
203     data_;
204     revert();
205   }
206 
207 }
208 /////////////////////////////////////////////////////////////////////////////////////////////
209 /**
210  * @title Destructible
211  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
212  */
213 contract Destructible is Ownable {
214 
215   function Destructible() public payable { }
216 
217   /**
218    * @dev Transfers the current balance to the owner and terminates the contract.
219    */
220   function destroy() onlyOwner public {
221     selfdestruct(owner);
222   }
223 
224   function destroyAndSend(address _recipient) onlyOwner public {
225     selfdestruct(_recipient);
226   }
227 }
228 /////////////////////////////////////////////////////////////////////////////////////////////
229 /**
230  * @title Pausable
231  * @dev Base contract which allows children to implement an emergency stop mechanism.
232  */
233 contract Pausable is Ownable {
234   event Pause();
235   event Unpause();
236 
237   bool public paused = false;
238 
239 
240   /**
241    * @dev Modifier to make a function callable only when the contract is not paused.
242    */
243   modifier whenNotPaused() {
244     require(!paused);
245     _;
246   }
247 
248   /**
249    * @dev Modifier to make a function callable only when the contract is paused.
250    */
251   modifier whenPaused() {
252     require(paused);
253     _;
254   }
255 
256   /**
257    * @dev called by the owner to pause, triggers stopped state
258    */
259   function pause() onlyOwner whenNotPaused public {
260     paused = true;
261     emit Pause();
262   }
263 
264   /**
265    * @dev called by the owner to unpause, returns to normal state
266    */
267   function unpause() onlyOwner whenPaused public {
268     paused = false;
269     emit Unpause();
270   }
271 }
272 /////////////////////////////////////////////////////////////////////////////////////////////
273 contract ERC20Basic {
274   string internal _symbol;
275   string internal _name;
276   uint8 internal _decimals;
277   uint internal _totalSupply;
278   mapping (address => uint) internal _balanceOf;
279 
280   mapping (address => mapping (address => uint)) internal _allowances;
281 
282   function ERC20Basic(string symbol, string name, uint8 decimals, uint totalSupply) public {
283       _symbol = symbol;
284       _name = name;
285       _decimals = decimals;
286       _totalSupply = totalSupply;
287   }
288 
289   function name() public constant returns (string) {
290       return _name;
291   }
292 
293   function symbol() public constant returns (string) {
294       return _symbol;
295   }
296 
297   function decimals() public constant returns (uint8) {
298       return _decimals;
299   }
300 
301   function totalSupply() public constant returns (uint) {
302       return _totalSupply;
303   }
304   function balanceOf(address _addr) public constant returns (uint);
305   function transfer(address _to, uint _value) public returns (bool);
306   event Transfer(address indexed _from, address indexed _to, uint _value);
307 }
308 /////////////////////////////////////////////////////////////////////////////////////////////
309 contract ERC20 is ERC20Basic {
310   function allowance(address owner, address spender) public view returns (uint256);
311   function transferFrom(address from, address to, uint256 value) public returns (bool);
312   function approve(address spender, uint256 value) public returns (bool);
313   event Approval(address indexed owner, address indexed spender, uint256 value);
314 }
315 /////////////////////////////////////////////////////////////////////////////////////////////
316 /**
317  * @title SafeERC20
318  * @dev Wrappers around ERC20 operations that throw on failure.
319  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
320  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
321  */
322 library SafeERC20 {
323   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
324     assert(token.transfer(to, value));
325   }
326 
327   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
328     assert(token.transferFrom(from, to, value));
329   }
330 
331   function safeApprove(ERC20 token, address spender, uint256 value) internal {
332     assert(token.approve(spender, value));
333   }
334 }
335 /////////////////////////////////////////////////////////////////////////////////////////////
336 /**
337  * @title Basic token
338  * @dev Basic version of StandardToken, with no allowances.
339  */
340 contract BasicToken is ERC20Basic, Ownable {
341   using SafeMath for uint256;
342 
343  mapping (address => bool) public frozenAccount;
344  event FrozenFunds(address target, bool frozen);
345 
346   uint256 totalSupply_;
347 
348   /**
349   * @dev total number of tokens in existence
350   */
351   function totalSupply() public view returns (uint256) {
352     return totalSupply_;
353   }
354   
355    function freezeAccount(address target, bool freeze) onlyOwner external {
356          frozenAccount[target] = freeze;
357          emit FrozenFunds(target, freeze);
358          }
359 
360   /**
361   * @dev transfer token for a specified address
362   * @param _to The address to transfer to.
363   * @param _value The amount to be transferred.
364   */
365   function transfer(address _to, uint256 _value) public returns (bool) {
366       require(!frozenAccount[msg.sender]);
367     require(_to != address(0));
368     require(_value <= _balanceOf[msg.sender]);
369 
370     // SafeMath.sub will throw if there is not enough balance.
371     _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
372     _balanceOf[_to] = _balanceOf[_to].add(_value);
373     emit Transfer(msg.sender, _to, _value);
374     return true;
375   }
376 
377   /**
378   * @dev Gets the balance of the specified address.
379   * @param _owner The address to query the the balance of.
380   * @return An uint256 representing the amount owned by the passed address.
381   */
382   function balanceOf(address _owner) public view returns (uint256 balance) {
383     return _balanceOf[_owner];
384   }
385 
386 }
387 /////////////////////////////////////////////////////////////////////////////////////////////
388 /**
389  * @title Standard ERC20 token
390  *
391  * @dev Implementation of the basic standard token.
392  * @dev https://github.com/ethereum/EIPs/issues/20
393  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
394  */
395 contract StandardToken is ERC20, BasicToken {
396 
397   mapping (address => mapping (address => uint256)) internal allowed;
398 
399 
400   /**
401    * @dev Transfer tokens from one address to another
402    * @param _from address The address which you want to send tokens from
403    * @param _to address The address which you want to transfer to
404    * @param _value uint256 the amount of tokens to be transferred
405    */
406   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
407     require(!frozenAccount[_from] && !frozenAccount[_to] && !frozenAccount[msg.sender]);
408     require(_to != address(0));
409     require(_value <= _balanceOf[_from]);
410     require(_value <= allowed[_from][msg.sender]);
411 
412     _balanceOf[_from] = _balanceOf[_from].sub(_value);
413     _balanceOf[_to] = _balanceOf[_to].add(_value);
414     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
415     emit Transfer(_from, _to, _value);
416     return true;
417   }
418 
419   /**
420    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
421    *
422    * Beware that changing an allowance with this method brings the risk that someone may use both the old
423    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
424    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
425    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
426    * @param _spender The address which will spend the funds.
427    * @param _value The amount of tokens to be spent.
428    */
429   function approve(address _spender, uint256 _value) public returns (bool) {
430     allowed[msg.sender][_spender] = _value;
431     emit Approval(msg.sender, _spender, _value);
432     return true;
433   }
434 
435   /**
436    * @dev Function to check the amount of tokens that an owner allowed to a spender.
437    * @param _owner address The address which owns the funds.
438    * @param _spender address The address which will spend the funds.
439    * @return A uint256 specifying the amount of tokens still available for the spender.
440    */
441   function allowance(address _owner, address _spender) public view returns (uint256) {
442     return allowed[_owner][_spender];
443   }
444 
445   /**
446    * @dev Increase the amount of tokens that an owner allowed to a spender.
447    *
448    * approve should be called when allowed[_spender] == 0. To increment
449    * allowed value is better to use this function to avoid 2 calls (and wait until
450    * the first transaction is mined)
451    * From MonolithDAO Token.sol
452    * @param _spender The address which will spend the funds.
453    * @param _addedValue The amount of tokens to increase the allowance by.
454    */
455   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
456     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
457     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
458     return true;
459   }
460 
461   /**
462    * @dev Decrease the amount of tokens that an owner allowed to a spender.
463    *
464    * approve should be called when allowed[_spender] == 0. To decrement
465    * allowed value is better to use this function to avoid 2 calls (and wait until
466    * the first transaction is mined)
467    * From MonolithDAO Token.sol
468    * @param _spender The address which will spend the funds.
469    * @param _subtractedValue The amount of tokens to decrease the allowance by.
470    */
471   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
472     uint oldValue = allowed[msg.sender][_spender];
473     if (_subtractedValue > oldValue) {
474       allowed[msg.sender][_spender] = 0;
475     } else {
476       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
477     }
478     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
479     return true;
480   }
481 
482 }
483 /////////////////////////////////////////////////////////////////////////////////////////////
484 
485 /////////////////////////////////////////////////////////////////////////////////////////////
486 contract PausableToken is StandardToken, Pausable {
487 
488   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
489     return super.transfer(_to, _value);
490   }
491 
492   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
493     return super.transferFrom(_from, _to, _value);
494   }
495 
496   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
497     return super.approve(_spender, _value);
498   }
499 
500   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
501     return super.increaseApproval(_spender, _addedValue);
502   }
503 
504   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
505     return super.decreaseApproval(_spender, _subtractedValue);
506   }
507 }
508 /////////////////////////////////////////////////////////////////////////////////////////////
509 /**
510    @title ERC827 interface, an extension of ERC20 token standard
511 
512    Interface of a ERC827 token, following the ERC20 standard with extra
513    methods to transfer value and data and execute calls in transfers and
514    approvals.
515  */
516 contract ERC827 is ERC20 {
517 
518   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
519   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
520   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
521 
522 }
523 /////////////////////////////////////////////////////////////////////////////////////////////
524 /**
525    @title ERC827, an extension of ERC20 token standard
526 
527    Implementation the ERC827, following the ERC20 standard with extra
528    methods to transfer value and data and execute calls in transfers and
529    approvals.
530    Uses OpenZeppelin StandardToken.
531  */
532 contract ERC827Token is ERC827, StandardToken {
533 
534   /**
535      @dev Addition to ERC20 token methods. It allows to
536      approve the transfer of value and execute a call with the sent data.
537 
538      Beware that changing an allowance with this method brings the risk that
539      someone may use both the old and the new allowance by unfortunate
540      transaction ordering. One possible solution to mitigate this race condition
541      is to first reduce the spender's allowance to 0 and set the desired value
542      afterwards:
543      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
544 
545      @param _spender The address that will spend the funds.
546      @param _value The amount of tokens to be spent.
547      @param _data ABI-encoded contract call to call `_to` address.
548 
549      @return true if the call function was executed successfully
550    */
551   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
552     require(!frozenAccount[msg.sender] && !frozenAccount[_spender]);
553     require(_spender != address(this));
554 
555     super.approve(_spender, _value);
556 
557     require(_spender.call(_data));
558 
559     return true;
560   }
561 
562   /**
563      @dev Addition to ERC20 token methods. Transfer tokens to a specified
564      address and execute a call with the sent data on the same transaction
565 
566      @param _to address The address which you want to transfer to
567      @param _value uint256 the amout of tokens to be transfered
568      @param _data ABI-encoded contract call to call `_to` address.
569 
570      @return true if the call function was executed successfully
571    */
572   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
573     require(_to != address(this));
574 
575     super.transfer(_to, _value);
576 
577     require(_to.call(_data));
578     return true;
579   }
580 
581   /**
582      @dev Addition to ERC20 token methods. Transfer tokens from one address to
583      another and make a contract call on the same transaction
584 
585      @param _from The address which you want to send tokens from
586      @param _to The address which you want to transfer to
587      @param _value The amout of tokens to be transferred
588      @param _data ABI-encoded contract call to call `_to` address.
589 
590      @return true if the call function was executed successfully
591    */
592   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
593     require(_to != address(this));
594 
595     super.transferFrom(_from, _to, _value);
596 
597     require(_to.call(_data));
598     return true;
599   }
600 
601   /**
602    * @dev Addition to StandardToken methods. Increase the amount of tokens that
603    * an owner allowed to a spender and execute a call with the sent data.
604    *
605    * approve should be called when allowed[_spender] == 0. To increment
606    * allowed value is better to use this function to avoid 2 calls (and wait until
607    * the first transaction is mined)
608    * From MonolithDAO Token.sol
609    * @param _spender The address which will spend the funds.
610    * @param _addedValue The amount of tokens to increase the allowance by.
611    * @param _data ABI-encoded contract call to call `_spender` address.
612    */
613   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
614     require(_spender != address(this));
615 
616     super.increaseApproval(_spender, _addedValue);
617 
618     require(_spender.call(_data));
619 
620     return true;
621   }
622 
623   /**
624    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
625    * an owner allowed to a spender and execute a call with the sent data.
626    *
627    * approve should be called when allowed[_spender] == 0. To decrement
628    * allowed value is better to use this function to avoid 2 calls (and wait until
629    * the first transaction is mined)
630    * From MonolithDAO Token.sol
631    * @param _spender The address which will spend the funds.
632    * @param _subtractedValue The amount of tokens to decrease the allowance by.
633    * @param _data ABI-encoded contract call to call `_spender` address.
634    */
635   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
636     require(_spender != address(this));
637 
638     super.decreaseApproval(_spender, _subtractedValue);
639 
640     require(_spender.call(_data));
641 
642     return true;
643   }
644 
645 }
646 
647 
648 
649 /////////////////////////////////////////////////////////////////////////////////////////////
650 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
651 
652 // IdeaCoin Contract Starts Here/////////////////////////////////////////////////////////////////////////////////////////////
653 contract IdeaCoin is ERC20Basic("IDC", "IdeaCoin", 18, 1000000000000000000000000), ERC827Token, PausableToken, Destructible, Contactable, HasNoTokens, HasNoContracts {
654 
655     using SafeMath for uint;
656 
657    
658     event Burn(address _from, uint256 _value);
659     event Mint(address _to, uint _value);
660 
661 
662       function IdeaCoin() public {
663             _balanceOf[msg.sender] = _totalSupply;
664         }
665 
666       
667        function totalSupply() public constant returns (uint) {
668            return _totalSupply;
669        }
670 
671        function balanceOf(address _addr) public constant returns (uint) {
672            return _balanceOf[_addr];
673        }
674 
675 
676         function burn(address _from, uint256 _value) onlyOwner external {
677               require(_balanceOf[_from] >= 0);
678               _balanceOf[_from] =  _balanceOf[_from].sub(_value);
679               _totalSupply = _totalSupply.sub(_value);
680               emit Burn(_from, _value);
681             }
682 
683 
684         function mintToken(address _to, uint256 _value) onlyOwner external  {
685                 require(!frozenAccount[msg.sender] && !frozenAccount[_to]);
686                _balanceOf[_to] = _balanceOf[_to].add(_value);
687                _totalSupply = _totalSupply.add(_value);
688                emit Mint(_to,_value);
689              }
690 
691 }
692 
693 ////////////////////////////////////////////////////////////////////////////////////////////