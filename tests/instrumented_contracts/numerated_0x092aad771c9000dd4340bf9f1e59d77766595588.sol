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
340 contract BasicToken is ERC20Basic {
341   using SafeMath for uint256;
342 
343   mapping(address => uint256) balances;
344 
345   uint256 totalSupply_;
346 
347   /**
348   * @dev total number of tokens in existence
349   */
350   function totalSupply() public view returns (uint256) {
351     return totalSupply_;
352   }
353 
354   /**
355   * @dev transfer token for a specified address
356   * @param _to The address to transfer to.
357   * @param _value The amount to be transferred.
358   */
359   function transfer(address _to, uint256 _value) public returns (bool) {
360     require(_to != address(0));
361     require(_value <= balances[msg.sender]);
362 
363     // SafeMath.sub will throw if there is not enough balance.
364     balances[msg.sender] = balances[msg.sender].sub(_value);
365     balances[_to] = balances[_to].add(_value);
366     emit Transfer(msg.sender, _to, _value);
367     return true;
368   }
369 
370   /**
371   * @dev Gets the balance of the specified address.
372   * @param _owner The address to query the the balance of.
373   * @return An uint256 representing the amount owned by the passed address.
374   */
375   function balanceOf(address _owner) public view returns (uint256 balance) {
376     return balances[_owner];
377   }
378 
379 }
380 /////////////////////////////////////////////////////////////////////////////////////////////
381 /**
382  * @title Standard ERC20 token
383  *
384  * @dev Implementation of the basic standard token.
385  * @dev https://github.com/ethereum/EIPs/issues/20
386  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
387  */
388 contract StandardToken is ERC20, BasicToken {
389 
390   mapping (address => mapping (address => uint256)) internal allowed;
391 
392 
393   /**
394    * @dev Transfer tokens from one address to another
395    * @param _from address The address which you want to send tokens from
396    * @param _to address The address which you want to transfer to
397    * @param _value uint256 the amount of tokens to be transferred
398    */
399   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
400     require(_to != address(0));
401     require(_value <= balances[_from]);
402     require(_value <= allowed[_from][msg.sender]);
403 
404     balances[_from] = balances[_from].sub(_value);
405     balances[_to] = balances[_to].add(_value);
406     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
407     emit Transfer(_from, _to, _value);
408     return true;
409   }
410 
411   /**
412    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
413    *
414    * Beware that changing an allowance with this method brings the risk that someone may use both the old
415    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
416    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
417    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
418    * @param _spender The address which will spend the funds.
419    * @param _value The amount of tokens to be spent.
420    */
421   function approve(address _spender, uint256 _value) public returns (bool) {
422     allowed[msg.sender][_spender] = _value;
423     emit Approval(msg.sender, _spender, _value);
424     return true;
425   }
426 
427   /**
428    * @dev Function to check the amount of tokens that an owner allowed to a spender.
429    * @param _owner address The address which owns the funds.
430    * @param _spender address The address which will spend the funds.
431    * @return A uint256 specifying the amount of tokens still available for the spender.
432    */
433   function allowance(address _owner, address _spender) public view returns (uint256) {
434     return allowed[_owner][_spender];
435   }
436 
437   /**
438    * @dev Increase the amount of tokens that an owner allowed to a spender.
439    *
440    * approve should be called when allowed[_spender] == 0. To increment
441    * allowed value is better to use this function to avoid 2 calls (and wait until
442    * the first transaction is mined)
443    * From MonolithDAO Token.sol
444    * @param _spender The address which will spend the funds.
445    * @param _addedValue The amount of tokens to increase the allowance by.
446    */
447   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
448     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
449     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
450     return true;
451   }
452 
453   /**
454    * @dev Decrease the amount of tokens that an owner allowed to a spender.
455    *
456    * approve should be called when allowed[_spender] == 0. To decrement
457    * allowed value is better to use this function to avoid 2 calls (and wait until
458    * the first transaction is mined)
459    * From MonolithDAO Token.sol
460    * @param _spender The address which will spend the funds.
461    * @param _subtractedValue The amount of tokens to decrease the allowance by.
462    */
463   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
464     uint oldValue = allowed[msg.sender][_spender];
465     if (_subtractedValue > oldValue) {
466       allowed[msg.sender][_spender] = 0;
467     } else {
468       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
469     }
470     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
471     return true;
472   }
473 
474 }
475 /////////////////////////////////////////////////////////////////////////////////////////////
476 
477 /////////////////////////////////////////////////////////////////////////////////////////////
478 contract PausableToken is StandardToken, Pausable {
479 
480   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
481     return super.transfer(_to, _value);
482   }
483 
484   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
485     return super.transferFrom(_from, _to, _value);
486   }
487 
488   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
489     return super.approve(_spender, _value);
490   }
491 
492   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
493     return super.increaseApproval(_spender, _addedValue);
494   }
495 
496   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
497     return super.decreaseApproval(_spender, _subtractedValue);
498   }
499 }
500 /////////////////////////////////////////////////////////////////////////////////////////////
501 /**
502    @title ERC827 interface, an extension of ERC20 token standard
503 
504    Interface of a ERC827 token, following the ERC20 standard with extra
505    methods to transfer value and data and execute calls in transfers and
506    approvals.
507  */
508 contract ERC827 is ERC20 {
509 
510   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
511   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
512   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
513 
514 }
515 /////////////////////////////////////////////////////////////////////////////////////////////
516 /**
517    @title ERC827, an extension of ERC20 token standard
518 
519    Implementation the ERC827, following the ERC20 standard with extra
520    methods to transfer value and data and execute calls in transfers and
521    approvals.
522    Uses OpenZeppelin StandardToken.
523  */
524 contract ERC827Token is ERC827, StandardToken {
525 
526   /**
527      @dev Addition to ERC20 token methods. It allows to
528      approve the transfer of value and execute a call with the sent data.
529 
530      Beware that changing an allowance with this method brings the risk that
531      someone may use both the old and the new allowance by unfortunate
532      transaction ordering. One possible solution to mitigate this race condition
533      is to first reduce the spender's allowance to 0 and set the desired value
534      afterwards:
535      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
536 
537      @param _spender The address that will spend the funds.
538      @param _value The amount of tokens to be spent.
539      @param _data ABI-encoded contract call to call `_to` address.
540 
541      @return true if the call function was executed successfully
542    */
543   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
544     require(_spender != address(this));
545 
546     super.approve(_spender, _value);
547 
548     require(_spender.call(_data));
549 
550     return true;
551   }
552 
553   /**
554      @dev Addition to ERC20 token methods. Transfer tokens to a specified
555      address and execute a call with the sent data on the same transaction
556 
557      @param _to address The address which you want to transfer to
558      @param _value uint256 the amout of tokens to be transfered
559      @param _data ABI-encoded contract call to call `_to` address.
560 
561      @return true if the call function was executed successfully
562    */
563   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
564     require(_to != address(this));
565 
566     super.transfer(_to, _value);
567 
568     require(_to.call(_data));
569     return true;
570   }
571 
572   /**
573      @dev Addition to ERC20 token methods. Transfer tokens from one address to
574      another and make a contract call on the same transaction
575 
576      @param _from The address which you want to send tokens from
577      @param _to The address which you want to transfer to
578      @param _value The amout of tokens to be transferred
579      @param _data ABI-encoded contract call to call `_to` address.
580 
581      @return true if the call function was executed successfully
582    */
583   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
584     require(_to != address(this));
585 
586     super.transferFrom(_from, _to, _value);
587 
588     require(_to.call(_data));
589     return true;
590   }
591 
592   /**
593    * @dev Addition to StandardToken methods. Increase the amount of tokens that
594    * an owner allowed to a spender and execute a call with the sent data.
595    *
596    * approve should be called when allowed[_spender] == 0. To increment
597    * allowed value is better to use this function to avoid 2 calls (and wait until
598    * the first transaction is mined)
599    * From MonolithDAO Token.sol
600    * @param _spender The address which will spend the funds.
601    * @param _addedValue The amount of tokens to increase the allowance by.
602    * @param _data ABI-encoded contract call to call `_spender` address.
603    */
604   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
605     require(_spender != address(this));
606 
607     super.increaseApproval(_spender, _addedValue);
608 
609     require(_spender.call(_data));
610 
611     return true;
612   }
613 
614   /**
615    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
616    * an owner allowed to a spender and execute a call with the sent data.
617    *
618    * approve should be called when allowed[_spender] == 0. To decrement
619    * allowed value is better to use this function to avoid 2 calls (and wait until
620    * the first transaction is mined)
621    * From MonolithDAO Token.sol
622    * @param _spender The address which will spend the funds.
623    * @param _subtractedValue The amount of tokens to decrease the allowance by.
624    * @param _data ABI-encoded contract call to call `_spender` address.
625    */
626   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
627     require(_spender != address(this));
628 
629     super.decreaseApproval(_spender, _subtractedValue);
630 
631     require(_spender.call(_data));
632 
633     return true;
634   }
635 
636 }
637 
638 
639 /////////////////////////////////////////////////////////////////////////////////////////////
640 contract ERC223ContractInterface {
641   function tokenFallback(address _from, uint256 _value, bytes _data) external;
642 }
643 /////////////////////////////////////////////////////////////////////////////////////////////
644 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
645 
646 // IdeaCoin Contract Starts Here/////////////////////////////////////////////////////////////////////////////////////////////
647 contract IdeaCoin is ERC20Basic("IDC", "IdeaCoin", 18, 1000000000000000000000000), ERC827Token, PausableToken, Destructible, Contactable, HasNoTokens, HasNoContracts {
648 
649     using SafeMath for uint;
650 
651     mapping (address => bool) public frozenAccount;
652     event FrozenFunds(address target, bool frozen);
653     event Burn(address _from, uint256 _value);
654     event Mint(address _to, uint _value);
655 
656 
657       function IdeaCoin() public {
658             _balanceOf[msg.sender] = _totalSupply;
659         }
660 
661        function freezeAccount(address target, bool freeze) onlyOwner public {
662          frozenAccount[target] = freeze;
663          emit FrozenFunds(target, freeze);
664          }
665 
666        function totalSupply() public constant returns (uint) {
667            return _totalSupply;
668        }
669 
670        function balanceOf(address _addr) public constant returns (uint) {
671            return _balanceOf[_addr];
672        }
673 
674 
675  function transfer(address _to, uint256 _value, bytes _data) public
676     returns (bool success)
677   {
678       require(!frozenAccount[msg.sender]);
679     transfer(_to, _value);
680     bool is_contract = false;
681     assembly {
682       is_contract := not(iszero(extcodesize(_to)))
683     }
684     if (is_contract) {
685       ERC223ContractInterface receiver = ERC223ContractInterface(_to);
686       receiver.tokenFallback(msg.sender, _value, _data);
687     }
688     return true;
689   }
690 
691 
692         function transferFrom(address _from, address _to, uint _value) public returns (bool) {
693            require(!frozenAccount[_from] && !frozenAccount[_to] && !frozenAccount[msg.sender]);
694             if (_allowances[_from][msg.sender] > 0 &&
695                 _value > 0 &&
696                 _allowances[_from][msg.sender] >= _value &&
697                 _balanceOf[_from] >= _value) {
698                 _balanceOf[_from] = _balanceOf[_from].sub(_value);
699                 _balanceOf[_to] = _balanceOf[_to].add(_value);
700                 _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
701                 emit Transfer(_from, _to, _value);
702                 return true;
703             }
704             return false;
705         }
706 
707 
708 
709 
710         function approve(address _spender, uint _value) public returns (bool) {
711            require(!frozenAccount[msg.sender] && !frozenAccount[_spender]);
712             _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
713             emit Approval(msg.sender, _spender, _value);
714             return true;
715         }
716 
717         function allowance(address _owner, address _spender) public constant returns (uint) {
718             return _allowances[_owner][_spender];
719         }
720 
721 
722 
723 
724       function burn(address _from, uint256 _value) onlyOwner public {
725               require(_balanceOf[_from] >= 0);
726               _balanceOf[_from] =  _balanceOf[_from].sub(_value);
727               _totalSupply = _totalSupply.sub(_value);
728               emit Burn(_from, _value);
729             }
730 
731 
732        function mintToken(address _to, uint256 _value) onlyOwner public  {
733                 require(!frozenAccount[msg.sender] && !frozenAccount[_to]);
734                _balanceOf[_to] = _balanceOf[_to].add(_value);
735                _totalSupply = _totalSupply.add(_value);
736                emit Mint(_to,_value);
737                
738                
739 
740              }
741 
742 }
743 
744 ////////////////////////////////////////////////////////////////////////////////////////////
745 
746 
747 
748 ////////////////////////////////////////////////////////////////////////////////////////////