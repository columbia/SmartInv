1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 /**
117  * @title SafeERC20
118  * @dev Wrappers around ERC20 operations that throw on failure.
119  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
120  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
121  */
122 library SafeERC20 {
123   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
124     assert(token.transfer(to, value));
125   }
126 
127   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
128     assert(token.transferFrom(from, to, value));
129   }
130 
131   function safeApprove(ERC20 token, address spender, uint256 value) internal {
132     assert(token.approve(spender, value));
133   }
134 }
135 
136 
137 /**
138  * @title Contracts that should be able to recover tokens
139  * @author SylTi
140  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
141  * This will prevent any accidental loss of tokens.
142  */
143 contract CanReclaimToken is Ownable {
144   using SafeERC20 for ERC20Basic;
145 
146   /**
147    * @dev Reclaim all ERC20Basic compatible tokens
148    * @param token ERC20Basic The address of the token contract
149    */
150   function reclaimToken(ERC20Basic token) external onlyOwner {
151     uint256 balance = token.balanceOf(this);
152     token.safeTransfer(owner, balance);
153   }
154 
155 }
156 
157 
158 /**
159  * @title Contracts that should not own Contracts
160  * @author Remco Bloemen <remco@2π.com>
161  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
162  * of this contract to reclaim ownership of the contracts.
163  */
164 contract HasNoContracts is Ownable {
165 
166   /**
167    * @dev Reclaim ownership of Ownable contracts
168    * @param contractAddr The address of the Ownable to be reclaimed.
169    */
170   function reclaimContract(address contractAddr) external onlyOwner {
171     Ownable contractInst = Ownable(contractAddr);
172     contractInst.transferOwnership(owner);
173   }
174 }
175 
176 
177 /**
178  * @title Contracts that should not own Tokens
179  * @author Remco Bloemen <remco@2π.com>
180  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
181  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
182  * owner to reclaim the tokens.
183  */
184 contract HasNoTokens is CanReclaimToken {
185 
186  /**
187   * @dev Reject all ERC223 compatible tokens
188   * @param from_ address The address that is transferring the tokens
189   * @param value_ uint256 the amount of the specified token
190   * @param data_ Bytes The data passed from the caller.
191   */
192   function tokenFallback(address from_, uint256 value_, bytes data_) external {
193     from_;
194     value_;
195     data_;
196     revert();
197   }
198 
199 }
200 
201 
202 /**
203  * @title Contracts that should not own Ether
204  * @author Remco Bloemen <remco@2π.com>
205  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
206  * in the contract, it will allow the owner to reclaim this ether.
207  * @notice Ether can still be send to this contract by:
208  * calling functions labeled `payable`
209  * `selfdestruct(contract_address)`
210  * mining directly to the contract address
211 */
212 contract HasNoEther is Ownable {
213 
214   /**
215   * @dev Constructor that rejects incoming Ether
216   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
217   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
218   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
219   * we could use assembly to access msg.value.
220   */
221   function HasNoEther() public payable {
222     require(msg.value == 0);
223   }
224 
225   /**
226    * @dev Disallows direct send by settings a default function without the `payable` flag.
227    */
228   function() external {
229   }
230 
231   /**
232    * @dev Transfer all Ether held by the contract to the owner.
233    */
234   function reclaimEther() external onlyOwner {
235     assert(owner.send(this.balance));
236   }
237 }
238 
239 
240 /**
241  * @title Base contract for contracts that should not own things.
242  * @author Remco Bloemen <remco@2π.com>
243  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
244  * Owned contracts. See respective base contracts for details.
245  */
246 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
247 }
248 
249 
250 /**
251  * @title Basic token
252  * @dev Basic version of StandardToken, with no allowances.
253  */
254 contract BasicToken is ERC20Basic {
255   using SafeMath for uint256;
256 
257   mapping(address => uint256) balances;
258 
259   uint256 totalSupply_;
260 
261   /**
262   * @dev total number of tokens in existence
263   */
264   function totalSupply() public view returns (uint256) {
265     return totalSupply_;
266   }
267 
268   /**
269   * @dev transfer token for a specified address
270   * @param _to The address to transfer to.
271   * @param _value The amount to be transferred.
272   */
273   function transfer(address _to, uint256 _value) public returns (bool) {
274     require(_to != address(0));
275     require(_value <= balances[msg.sender]);
276 
277     // SafeMath.sub will throw if there is not enough balance.
278     balances[msg.sender] = balances[msg.sender].sub(_value);
279     balances[_to] = balances[_to].add(_value);
280     Transfer(msg.sender, _to, _value);
281     return true;
282   }
283 
284   /**
285   * @dev Gets the balance of the specified address.
286   * @param _owner The address to query the the balance of.
287   * @return An uint256 representing the amount owned by the passed address.
288   */
289   function balanceOf(address _owner) public view returns (uint256 balance) {
290     return balances[_owner];
291   }
292 
293 }
294 
295 
296 /**
297  * @title Standard ERC20 token
298  *
299  * @dev Implementation of the basic standard token.
300  * @dev https://github.com/ethereum/EIPs/issues/20
301  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
302  */
303 contract StandardToken is ERC20, BasicToken {
304 
305   mapping (address => mapping (address => uint256)) internal allowed;
306 
307 
308   /**
309    * @dev Transfer tokens from one address to another
310    * @param _from address The address which you want to send tokens from
311    * @param _to address The address which you want to transfer to
312    * @param _value uint256 the amount of tokens to be transferred
313    */
314   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
315     require(_to != address(0));
316     require(_value <= balances[_from]);
317     require(_value <= allowed[_from][msg.sender]);
318 
319     balances[_from] = balances[_from].sub(_value);
320     balances[_to] = balances[_to].add(_value);
321     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
322     Transfer(_from, _to, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328    *
329    * Beware that changing an allowance with this method brings the risk that someone may use both the old
330    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333    * @param _spender The address which will spend the funds.
334    * @param _value The amount of tokens to be spent.
335    */
336   function approve(address _spender, uint256 _value) public returns (bool) {
337     allowed[msg.sender][_spender] = _value;
338     Approval(msg.sender, _spender, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Function to check the amount of tokens that an owner allowed to a spender.
344    * @param _owner address The address which owns the funds.
345    * @param _spender address The address which will spend the funds.
346    * @return A uint256 specifying the amount of tokens still available for the spender.
347    */
348   function allowance(address _owner, address _spender) public view returns (uint256) {
349     return allowed[_owner][_spender];
350   }
351 
352   /**
353    * @dev Increase the amount of tokens that an owner allowed to a spender.
354    *
355    * approve should be called when allowed[_spender] == 0. To increment
356    * allowed value is better to use this function to avoid 2 calls (and wait until
357    * the first transaction is mined)
358    * From MonolithDAO Token.sol
359    * @param _spender The address which will spend the funds.
360    * @param _addedValue The amount of tokens to increase the allowance by.
361    */
362   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
363     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
364     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368   /**
369    * @dev Decrease the amount of tokens that an owner allowed to a spender.
370    *
371    * approve should be called when allowed[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
379     uint oldValue = allowed[msg.sender][_spender];
380     if (_subtractedValue > oldValue) {
381       allowed[msg.sender][_spender] = 0;
382     } else {
383       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
384     }
385     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
386     return true;
387   }
388 
389 }
390 
391 
392 /**
393  * @title BetexToken
394  */
395 contract BetexToken is StandardToken, NoOwner {
396 
397     string public constant name = "Betex Token"; // solium-disable-line uppercase
398     string public constant symbol = "BETEX"; // solium-disable-line uppercase
399     uint8 public constant decimals = 18; // solium-disable-line uppercase
400 
401     // transfer unlock time (except team and broker recipients)
402     uint256 public firstUnlockTime;
403 
404     // transfer unlock time for the team and broker recipients
405     uint256 public secondUnlockTime; 
406 
407     // addresses locked till second unlock time
408     mapping (address => bool) public blockedTillSecondUnlock;
409 
410     // token holders
411     address[] public holders;
412 
413     // holder number
414     mapping (address => uint256) public holderNumber;
415 
416     // ICO address
417     address public icoAddress;
418 
419     // supply constants
420     uint256 public constant TOTAL_SUPPLY = 10000000 * (10 ** uint256(decimals));
421     uint256 public constant SALE_SUPPLY = 5000000 * (10 ** uint256(decimals));
422 
423     // funds supply constants
424     uint256 public constant BOUNTY_SUPPLY = 200000 * (10 ** uint256(decimals));
425     uint256 public constant RESERVE_SUPPLY = 800000 * (10 ** uint256(decimals));
426     uint256 public constant BROKER_RESERVE_SUPPLY = 1000000 * (10 ** uint256(decimals));
427     uint256 public constant TEAM_SUPPLY = 3000000 * (10 ** uint256(decimals));
428 
429     // funds addresses constants
430     address public constant BOUNTY_ADDRESS = 0x48c15e5A9343E3220cdD8127620AE286A204448a;
431     address public constant RESERVE_ADDRESS = 0xC8fE659AaeF73b6e41DEe427c989150e3eDAf57D;
432     address public constant BROKER_RESERVE_ADDRESS = 0x8697d46171aBCaD2dC5A4061b8C35f909a402417;
433     address public constant TEAM_ADDRESS = 0x1761988F02C75E7c3432fa31d179cad6C5843F24;
434 
435     // min tokens to be a holder, 0.1
436     uint256 public constant MIN_HOLDER_TOKENS = 10 ** uint256(decimals - 1);
437     
438     /**
439      * @dev Constructor
440      * @param _firstUnlockTime first unlock time
441      * @param _secondUnlockTime second unlock time
442      */
443     function BetexToken
444     (
445         uint256 _firstUnlockTime, 
446         uint256 _secondUnlockTime
447     )
448         public 
449     {        
450         require(_secondUnlockTime > firstUnlockTime);
451 
452         firstUnlockTime = _firstUnlockTime;
453         secondUnlockTime = _secondUnlockTime;
454 
455         // Allocate tokens to the bounty fund
456         balances[BOUNTY_ADDRESS] = BOUNTY_SUPPLY;
457         holders.push(BOUNTY_ADDRESS);
458         emit Transfer(0x0, BOUNTY_ADDRESS, BOUNTY_SUPPLY);
459 
460         // Allocate tokens to the reserve fund
461         balances[RESERVE_ADDRESS] = RESERVE_SUPPLY;
462         holders.push(RESERVE_ADDRESS);
463         emit Transfer(0x0, RESERVE_ADDRESS, RESERVE_SUPPLY);
464 
465         // Allocate tokens to the broker reserve fund
466         balances[BROKER_RESERVE_ADDRESS] = BROKER_RESERVE_SUPPLY;
467         holders.push(BROKER_RESERVE_ADDRESS);
468         emit Transfer(0x0, BROKER_RESERVE_ADDRESS, BROKER_RESERVE_SUPPLY);
469 
470         // Allocate tokens to the team fund
471         balances[TEAM_ADDRESS] = TEAM_SUPPLY;
472         holders.push(TEAM_ADDRESS);
473         emit Transfer(0x0, TEAM_ADDRESS, TEAM_SUPPLY);
474 
475         totalSupply_ = TOTAL_SUPPLY.sub(SALE_SUPPLY);
476     }
477 
478     /**
479      * @dev set ICO address and allocate sale supply to it
480      */
481     function setICO(address _icoAddress) public onlyOwner {
482         require(_icoAddress != address(0));
483         require(icoAddress == address(0));
484         require(totalSupply_ == TOTAL_SUPPLY.sub(SALE_SUPPLY));
485         
486         // Allocate tokens to the ico contract
487         balances[_icoAddress] = SALE_SUPPLY;
488         emit Transfer(0x0, _icoAddress, SALE_SUPPLY);
489 
490         icoAddress = _icoAddress;
491         totalSupply_ = TOTAL_SUPPLY;
492     }
493     
494     // standard transfer function with timelocks
495     function transfer(address _to, uint256 _value) public returns (bool) {
496         require(transferAllowed(msg.sender));
497         enforceSecondLock(msg.sender, _to);
498         preserveHolders(msg.sender, _to, _value);
499         return super.transfer(_to, _value);
500     }
501 
502     // standard transferFrom function with timelocks
503     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
504         require(transferAllowed(msg.sender));
505         enforceSecondLock(msg.sender, _to);
506         preserveHolders(_from, _to, _value);
507         return super.transferFrom(_from, _to, _value);
508     }
509 
510     // get holders count
511     function getHoldersCount() public view returns (uint256) {
512         return holders.length;
513     }
514 
515     // enforce second lock on receiver
516     function enforceSecondLock(address _from, address _to) internal {
517         if (now < secondUnlockTime) { // solium-disable-line security/no-block-members
518             if (_from == TEAM_ADDRESS || _from == BROKER_RESERVE_ADDRESS) {
519                 require(balances[_to] == uint256(0) || blockedTillSecondUnlock[_to]);
520                 blockedTillSecondUnlock[_to] = true;
521             }
522         }
523     }
524 
525     // preserve holders list
526     function preserveHolders(address _from, address _to, uint256 _value) internal {
527         if (balances[_from].sub(_value) < MIN_HOLDER_TOKENS) 
528             removeHolder(_from);
529         if (balances[_to].add(_value) >= MIN_HOLDER_TOKENS) 
530             addHolder(_to);   
531     }
532 
533     // remove holder from the holders list
534     function removeHolder(address _holder) internal {
535         uint256 _number = holderNumber[_holder];
536 
537         if (_number == 0 || holders.length == 0 || _number > holders.length)
538             return;
539 
540         uint256 _index = _number.sub(1);
541         uint256 _lastIndex = holders.length.sub(1);
542         address _lastHolder = holders[_lastIndex];
543 
544         if (_index != _lastIndex) {
545             holders[_index] = _lastHolder;
546             holderNumber[_lastHolder] = _number;
547         }
548 
549         holderNumber[_holder] = 0;
550         holders.length = _lastIndex;
551     } 
552 
553     // add holder to the holders list
554     function addHolder(address _holder) internal {
555         if (holderNumber[_holder] == 0) {
556             holders.push(_holder);
557             holderNumber[_holder] = holders.length;
558         }
559     }
560 
561     // @return true if transfer operation is allowed
562     function transferAllowed(address _sender) internal view returns(bool) {
563         if (now > secondUnlockTime || _sender == icoAddress) // solium-disable-line security/no-block-members
564             return true;
565         if (now < firstUnlockTime) // solium-disable-line security/no-block-members
566             return false;
567         if (blockedTillSecondUnlock[_sender])
568             return false;
569         return true;
570     }
571 
572 }