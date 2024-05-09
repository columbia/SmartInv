1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ERC223.sol
4 
5 /**
6  * @title Interface for an ERC223 Contract
7  * @author Amr Gawish <amr@gawi.sh>
8  * @dev Only one method is unique to contracts `transfer(address _to, uint _value, bytes _data)`
9  * @notice The interface has been stripped to its unique methods to prevent duplicating methods with ERC20 interface
10 */
11 interface ERC223 {
12     function transfer(address _to, uint _value, bytes _data) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
14 }
15 
16 // File: contracts/ERC223ReceivingContract.sol
17 
18 /**
19  * @title Contract that will work with ERC223 tokens.
20  */
21  
22 contract ERC223ReceivingContract { 
23 
24     /**
25     * @dev Standard ERC223 function that will handle incoming token transfers.
26     *
27     * @param _from  Token sender address.
28     * @param _value Amount of tokens.
29     * @param _data  Transaction metadata.
30     */
31     function tokenFallback(address _from, uint _value, bytes _data) public;
32 }
33 
34 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipRenounced(address indexed previousOwner);
46   event OwnershipTransferred(
47     address indexed previousOwner,
48     address indexed newOwner
49   );
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to relinquish control of the contract.
70    */
71   function renounceOwnership() public onlyOwner {
72     emit OwnershipRenounced(owner);
73     owner = address(0);
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address _newOwner) public onlyOwner {
81     _transferOwnership(_newOwner);
82   }
83 
84   /**
85    * @dev Transfers control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function _transferOwnership(address _newOwner) internal {
89     require(_newOwner != address(0));
90     emit OwnershipTransferred(owner, _newOwner);
91     owner = _newOwner;
92   }
93 }
94 
95 // File: contracts/OperatorManaged.sol
96 
97 // Simple JSE Operator management contract
98 contract OperatorManaged is Ownable {
99 
100     address public operatorAddress;
101     address public adminAddress;
102 
103     event AdminAddressChanged(address indexed _newAddress);
104     event OperatorAddressChanged(address indexed _newAddress);
105 
106 
107     constructor() public
108         Ownable()
109     {
110         adminAddress = msg.sender;
111     }
112 
113     modifier onlyAdmin() {
114         require(isAdmin(msg.sender));
115         _;
116     }
117 
118 
119     modifier onlyAdminOrOperator() {
120         require(isAdmin(msg.sender) || isOperator(msg.sender));
121         _;
122     }
123 
124 
125     modifier onlyOwnerOrAdmin() {
126         require(isOwner(msg.sender) || isAdmin(msg.sender));
127         _;
128     }
129 
130 
131     modifier onlyOperator() {
132         require(isOperator(msg.sender));
133         _;
134     }
135 
136 
137     function isAdmin(address _address) internal view returns (bool) {
138         return (adminAddress != address(0) && _address == adminAddress);
139     }
140 
141 
142     function isOperator(address _address) internal view returns (bool) {
143         return (operatorAddress != address(0) && _address == operatorAddress);
144     }
145 
146     function isOwner(address _address) internal view returns (bool) {
147         return (owner != address(0) && _address == owner);
148     }
149 
150 
151     function isOwnerOrOperator(address _address) internal view returns (bool) {
152         return (isOwner(_address) || isOperator(_address));
153     }
154 
155 
156     // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.
157     function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
158         require(_adminAddress != owner);
159         require(_adminAddress != address(this));
160         require(!isOperator(_adminAddress));
161 
162         adminAddress = _adminAddress;
163 
164         emit AdminAddressChanged(_adminAddress);
165 
166         return true;
167     }
168 
169 
170     // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.
171     function setOperatorAddress(address _operatorAddress) external onlyOwnerOrAdmin returns (bool) {
172         require(_operatorAddress != owner);
173         require(_operatorAddress != address(this));
174         require(!isAdmin(_operatorAddress));
175 
176         operatorAddress = _operatorAddress;
177 
178         emit OperatorAddressChanged(_operatorAddress);
179 
180         return true;
181     }
182 }
183 
184 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
185 
186 /**
187  * @title SafeMath
188  * @dev Math operations with safety checks that throw on error
189  */
190 library SafeMath {
191 
192   /**
193   * @dev Multiplies two numbers, throws on overflow.
194   */
195   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
196     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
197     // benefit is lost if 'b' is also tested.
198     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
199     if (a == 0) {
200       return 0;
201     }
202 
203     c = a * b;
204     assert(c / a == b);
205     return c;
206   }
207 
208   /**
209   * @dev Integer division of two numbers, truncating the quotient.
210   */
211   function div(uint256 a, uint256 b) internal pure returns (uint256) {
212     // assert(b > 0); // Solidity automatically throws when dividing by 0
213     // uint256 c = a / b;
214     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215     return a / b;
216   }
217 
218   /**
219   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
220   */
221   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222     assert(b <= a);
223     return a - b;
224   }
225 
226   /**
227   * @dev Adds two numbers, throws on overflow.
228   */
229   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
230     c = a + b;
231     assert(c >= a);
232     return c;
233   }
234 }
235 
236 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
237 
238 /**
239  * @title ERC20Basic
240  * @dev Simpler version of ERC20 interface
241  * @dev see https://github.com/ethereum/EIPs/issues/179
242  */
243 contract ERC20Basic {
244   function totalSupply() public view returns (uint256);
245   function balanceOf(address who) public view returns (uint256);
246   function transfer(address to, uint256 value) public returns (bool);
247   event Transfer(address indexed from, address indexed to, uint256 value);
248 }
249 
250 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
251 
252 /**
253  * @title Basic token
254  * @dev Basic version of StandardToken, with no allowances.
255  */
256 contract BasicToken is ERC20Basic {
257   using SafeMath for uint256;
258 
259   mapping(address => uint256) balances;
260 
261   uint256 totalSupply_;
262 
263   /**
264   * @dev total number of tokens in existence
265   */
266   function totalSupply() public view returns (uint256) {
267     return totalSupply_;
268   }
269 
270   /**
271   * @dev transfer token for a specified address
272   * @param _to The address to transfer to.
273   * @param _value The amount to be transferred.
274   */
275   function transfer(address _to, uint256 _value) public returns (bool) {
276     require(_to != address(0));
277     require(_value <= balances[msg.sender]);
278 
279     balances[msg.sender] = balances[msg.sender].sub(_value);
280     balances[_to] = balances[_to].add(_value);
281     emit Transfer(msg.sender, _to, _value);
282     return true;
283   }
284 
285   /**
286   * @dev Gets the balance of the specified address.
287   * @param _owner The address to query the the balance of.
288   * @return An uint256 representing the amount owned by the passed address.
289   */
290   function balanceOf(address _owner) public view returns (uint256) {
291     return balances[_owner];
292   }
293 
294 }
295 
296 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
297 
298 /**
299  * @title ERC20 interface
300  * @dev see https://github.com/ethereum/EIPs/issues/20
301  */
302 contract ERC20 is ERC20Basic {
303   function allowance(address owner, address spender)
304     public view returns (uint256);
305 
306   function transferFrom(address from, address to, uint256 value)
307     public returns (bool);
308 
309   function approve(address spender, uint256 value) public returns (bool);
310   event Approval(
311     address indexed owner,
312     address indexed spender,
313     uint256 value
314   );
315 }
316 
317 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
318 
319 /**
320  * @title Standard ERC20 token
321  *
322  * @dev Implementation of the basic standard token.
323  * @dev https://github.com/ethereum/EIPs/issues/20
324  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
325  */
326 contract StandardToken is ERC20, BasicToken {
327 
328   mapping (address => mapping (address => uint256)) internal allowed;
329 
330 
331   /**
332    * @dev Transfer tokens from one address to another
333    * @param _from address The address which you want to send tokens from
334    * @param _to address The address which you want to transfer to
335    * @param _value uint256 the amount of tokens to be transferred
336    */
337   function transferFrom(
338     address _from,
339     address _to,
340     uint256 _value
341   )
342     public
343     returns (bool)
344   {
345     require(_to != address(0));
346     require(_value <= balances[_from]);
347     require(_value <= allowed[_from][msg.sender]);
348 
349     balances[_from] = balances[_from].sub(_value);
350     balances[_to] = balances[_to].add(_value);
351     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
352     emit Transfer(_from, _to, _value);
353     return true;
354   }
355 
356   /**
357    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
358    *
359    * Beware that changing an allowance with this method brings the risk that someone may use both the old
360    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
361    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
362    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363    * @param _spender The address which will spend the funds.
364    * @param _value The amount of tokens to be spent.
365    */
366   function approve(address _spender, uint256 _value) public returns (bool) {
367     allowed[msg.sender][_spender] = _value;
368     emit Approval(msg.sender, _spender, _value);
369     return true;
370   }
371 
372   /**
373    * @dev Function to check the amount of tokens that an owner allowed to a spender.
374    * @param _owner address The address which owns the funds.
375    * @param _spender address The address which will spend the funds.
376    * @return A uint256 specifying the amount of tokens still available for the spender.
377    */
378   function allowance(
379     address _owner,
380     address _spender
381    )
382     public
383     view
384     returns (uint256)
385   {
386     return allowed[_owner][_spender];
387   }
388 
389   /**
390    * @dev Increase the amount of tokens that an owner allowed to a spender.
391    *
392    * approve should be called when allowed[_spender] == 0. To increment
393    * allowed value is better to use this function to avoid 2 calls (and wait until
394    * the first transaction is mined)
395    * From MonolithDAO Token.sol
396    * @param _spender The address which will spend the funds.
397    * @param _addedValue The amount of tokens to increase the allowance by.
398    */
399   function increaseApproval(
400     address _spender,
401     uint _addedValue
402   )
403     public
404     returns (bool)
405   {
406     allowed[msg.sender][_spender] = (
407       allowed[msg.sender][_spender].add(_addedValue));
408     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
409     return true;
410   }
411 
412   /**
413    * @dev Decrease the amount of tokens that an owner allowed to a spender.
414    *
415    * approve should be called when allowed[_spender] == 0. To decrement
416    * allowed value is better to use this function to avoid 2 calls (and wait until
417    * the first transaction is mined)
418    * From MonolithDAO Token.sol
419    * @param _spender The address which will spend the funds.
420    * @param _subtractedValue The amount of tokens to decrease the allowance by.
421    */
422   function decreaseApproval(
423     address _spender,
424     uint _subtractedValue
425   )
426     public
427     returns (bool)
428   {
429     uint oldValue = allowed[msg.sender][_spender];
430     if (_subtractedValue > oldValue) {
431       allowed[msg.sender][_spender] = 0;
432     } else {
433       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
434     }
435     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
436     return true;
437   }
438 
439 }
440 
441 // File: openzeppelin-solidity/contracts/token/ERC20//MintableToken.sol
442 
443 /**
444  * @title Mintable token
445  * @dev Simple ERC20 Token example, with mintable token creation
446  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
447  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
448  */
449 contract MintableToken is StandardToken, Ownable {
450   event Mint(address indexed to, uint256 amount);
451   event MintFinished();
452 
453   bool public mintingFinished = false;
454 
455 
456   modifier canMint() {
457     require(!mintingFinished);
458     _;
459   }
460 
461   modifier hasMintPermission() {
462     require(msg.sender == owner);
463     _;
464   }
465 
466   /**
467    * @dev Function to mint tokens
468    * @param _to The address that will receive the minted tokens.
469    * @param _amount The amount of tokens to mint.
470    * @return A boolean that indicates if the operation was successful.
471    */
472   function mint(
473     address _to,
474     uint256 _amount
475   )
476     hasMintPermission
477     canMint
478     public
479     returns (bool)
480   {
481     totalSupply_ = totalSupply_.add(_amount);
482     balances[_to] = balances[_to].add(_amount);
483     emit Mint(_to, _amount);
484     emit Transfer(address(0), _to, _amount);
485     return true;
486   }
487 
488   /**
489    * @dev Function to stop minting new tokens.
490    * @return True if the operation was successful.
491    */
492   function finishMinting() onlyOwner canMint public returns (bool) {
493     mintingFinished = true;
494     emit MintFinished();
495     return true;
496   }
497 }
498 
499 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
500 
501 /**
502  * @title Burnable Token
503  * @dev Token that can be irreversibly burned (destroyed).
504  */
505 contract BurnableToken is BasicToken {
506 
507   event Burn(address indexed burner, uint256 value);
508 
509   /**
510    * @dev Burns a specific amount of tokens.
511    * @param _value The amount of token to be burned.
512    */
513   function burn(uint256 _value) public {
514     _burn(msg.sender, _value);
515   }
516 
517   function _burn(address _who, uint256 _value) internal {
518     require(_value <= balances[_who]);
519     // no need to require value <= totalSupply, since that would imply the
520     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
521 
522     balances[_who] = balances[_who].sub(_value);
523     totalSupply_ = totalSupply_.sub(_value);
524     emit Burn(_who, _value);
525     emit Transfer(_who, address(0), _value);
526   }
527 }
528 
529 // File: contracts/JSEToken.sol
530 
531 /**
532  * @title Main Token Contract for JSE Coin
533  * @author Amr Gawish <amr@gawi.sh>
534  * @dev This Token is the Mintable and Burnable to allow variety of actions to be done by users.
535  * @dev It also complies with both ERC20 and ERC223.
536  * @notice Trying to use JSE Token to Contracts that doesn't accept tokens and doesn't have tokenFallback function will fail, and all contracts
537  * must comply to ERC223 compliance. 
538 */
539 contract JSEToken is ERC223, BurnableToken, Ownable, MintableToken, OperatorManaged {
540     
541     event Finalized();
542 
543     string public name = "JSE Token";
544     string public symbol = "JSE";
545     uint public decimals = 18;
546     uint public initialSupply = 10000000000 * (10 ** decimals); //10,000,000,000 aka 10 billion
547 
548     bool public finalized;
549 
550     constructor() OperatorManaged() public {
551         totalSupply_ = initialSupply;
552         balances[msg.sender] = initialSupply; 
553 
554         emit Transfer(0x0, msg.sender, initialSupply);
555     }
556 
557 
558     // Implementation of the standard transferFrom method that takes into account the finalize flag.
559     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
560         checkTransferAllowed(msg.sender, _to);
561 
562         return super.transferFrom(_from, _to, _value);
563     }
564 
565     function checkTransferAllowed(address _sender, address _to) private view {
566         if (finalized) {
567             // Everybody should be ok to transfer once the token is finalized.
568             return;
569         }
570 
571         // Owner and Ops are allowed to transfer tokens before the sale is finalized.
572         // This allows the tokens to move from the TokenSale contract to a beneficiary.
573         // We also allow someone to send tokens back to the owner. This is useful among other
574         // cases, for the Trustee to transfer unlocked tokens back to the owner (reclaimTokens).
575         require(isOwnerOrOperator(_sender) || _to == owner);
576     }
577 
578     // Implementation of the standard transfer method that takes into account the finalize flag.
579     function transfer(address _to, uint256 _value) public returns (bool success) {
580         checkTransferAllowed(msg.sender, _to);
581 
582         return super.transfer(_to, _value);
583     }
584 
585     /**
586     * @dev transfer token for a specified contract address
587     * @param _to The address to transfer to.
588     * @param _value The amount to be transferred.
589     * @param _data Additional Data sent to the contract.
590     */
591     function transfer(address _to, uint _value, bytes _data) external returns (bool) {
592         checkTransferAllowed(msg.sender, _to);
593 
594         require(_to != address(0));
595         require(_value <= balances[msg.sender]);
596         require(isContract(_to));
597 
598 
599         balances[msg.sender] = balances[msg.sender].sub(_value);
600         balances[_to] = balances[_to].add(_value);
601         ERC223ReceivingContract erc223Contract = ERC223ReceivingContract(_to);
602         erc223Contract.tokenFallback(msg.sender, _value, _data);
603 
604         emit Transfer(msg.sender, _to, _value);
605         return true;
606     }
607 
608     /** 
609     * @dev Owner can transfer out any accidentally sent ERC20 tokens
610     */
611     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
612         return ERC20(tokenAddress).transfer(owner, tokens);
613     }
614 
615     function isContract(address _addr) private view returns (bool) {
616         uint codeSize;
617         /* solium-disable-next-line */
618         assembly {
619             codeSize := extcodesize(_addr)
620         }
621         return codeSize > 0;
622     }
623 
624     // Finalize method marks the point where token transfers are finally allowed for everybody.
625     function finalize() external onlyAdmin returns (bool success) {
626         require(!finalized);
627 
628         finalized = true;
629 
630         emit Finalized();
631 
632         return true;
633     }
634 }