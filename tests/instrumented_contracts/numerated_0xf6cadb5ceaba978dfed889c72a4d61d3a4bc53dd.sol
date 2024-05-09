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
573 
574 
575 /**
576  * @title BetexStorage
577  */
578 contract BetexStorage is Ownable {
579 
580     // minimum funding to get volume bonus	
581     uint256 public constant VOLUME_BONUS_CONDITION = 50 ether;
582 
583     // minimum funding to get volume extra bonus	
584     uint256 public constant VOLUME_EXTRA_BONUS_CONDITION = 100 ether;
585 
586     // extra bonus amount during first bonus round, %
587     uint256 public constant FIRST_VOLUME_EXTRA_BONUS = 20;
588 
589     // extra bonus amount during second bonus round, %
590     uint256 public constant SECOND_VOLUME_EXTRA_BONUS = 10;
591 
592     // bonus amount during first bonus round, %
593     uint256 public constant FIRST_VOLUME_BONUS = 10;
594 
595     // bonus amount during second bonus round, %
596     uint256 public constant SECOND_VOLUME_BONUS = 5;
597 
598     // oraclize funding order
599     struct Order {
600         address beneficiary;
601         uint256 funds;
602         uint256 bonus;
603         uint256 rate;
604     }
605 
606     // oraclize funding orders
607     mapping (bytes32 => Order) public orders;
608 
609     // oraclize orders for unsold tokens allocation
610     mapping (bytes32 => bool) public unsoldAllocationOrders;
611 
612     // addresses allowed to buy tokens
613     mapping (address => bool) public whitelist;
614 
615     // funded
616     mapping (address => bool) public funded;
617 
618     // funders
619     address[] public funders;
620     
621     // pre ico funders
622     address[] public preICOFunders;
623 
624     // tokens to allocate before ico sale starts
625     mapping (address => uint256) public preICOBalances;
626 
627     // is preICO data initialized
628     bool public preICODataInitialized;
629 
630 
631     /**
632      * @dev Constructor
633      */  
634     function BetexStorage() public {
635 
636         // pre sale round 1
637         preICOFunders.push(0x233Fd2B3d7a0924Fe1Bb0dd7FA168eEF8C522E65);
638         preICOBalances[0x233Fd2B3d7a0924Fe1Bb0dd7FA168eEF8C522E65] = 15000000000000000000000;
639         preICOFunders.push(0x2712ba56cB3Cf8783693c8a1796F70ABa57132b1);
640         preICOBalances[0x2712ba56cB3Cf8783693c8a1796F70ABa57132b1] = 15000000000000000000000;
641         preICOFunders.push(0x6f3DDfb726eA637e125C4fbf6694B940711478f4);
642         preICOBalances[0x6f3DDfb726eA637e125C4fbf6694B940711478f4] = 15000000000000000000000;
643         preICOFunders.push(0xAf7Ff6f381684707001d517Bf83C4a3538f9C82a);
644         preICOBalances[0xAf7Ff6f381684707001d517Bf83C4a3538f9C82a] = 22548265874120000000000;
645         preICOFunders.push(0x51219a9330c196b8bd7fA0737C8e0db53c1ad628);
646         preICOBalances[0x51219a9330c196b8bd7fA0737C8e0db53c1ad628] = 32145215844400000000000;
647         preICOFunders.push(0xA2D42D689769f7BA32712f27B09606fFD8F3b699);
648         preICOBalances[0xA2D42D689769f7BA32712f27B09606fFD8F3b699] = 15000000000000000000000;
649         preICOFunders.push(0xB7C9D3AAbF44296232538B8b184F274B57003994);
650         preICOBalances[0xB7C9D3AAbF44296232538B8b184F274B57003994] = 20000000000000000000000;
651         preICOFunders.push(0x58667a170F53b809CA9143c1CeEa00D2Df866577);
652         preICOBalances[0x58667a170F53b809CA9143c1CeEa00D2Df866577] = 184526257787000000000000;
653         preICOFunders.push(0x0D4b2A1a47b1059d622C033c2a58F2F651010553);
654         preICOBalances[0x0D4b2A1a47b1059d622C033c2a58F2F651010553] = 17845264771100000000000;
655         preICOFunders.push(0x982F59497026473d2227f5dd02cdf6fdCF237AE0);
656         preICOBalances[0x982F59497026473d2227f5dd02cdf6fdCF237AE0] = 31358989521120000000000;
657         preICOFunders.push(0x250d540EFeabA7b5C0407A955Fd76217590dbc37);
658         preICOBalances[0x250d540EFeabA7b5C0407A955Fd76217590dbc37] = 15000000000000000000000;
659         preICOFunders.push(0x2Cde7768B7d5dcb12c5b5572daEf3F7B855c8685);
660         preICOBalances[0x2Cde7768B7d5dcb12c5b5572daEf3F7B855c8685] = 17500000000000000000000;
661         preICOFunders.push(0x89777c2a4C1843a99B2fF481a4CEF67f5d7A1387);
662         preICOBalances[0x89777c2a4C1843a99B2fF481a4CEF67f5d7A1387] = 15000000000000000000000;
663         preICOFunders.push(0x63699D4d309e48e8B575BE771700570A828dC655);
664         preICOBalances[0x63699D4d309e48e8B575BE771700570A828dC655] = 15000000000000000000000;
665         preICOFunders.push(0x9bc92E0da2e4aC174b8E33D7c74b5009563a8e2A);
666         preICOBalances[0x9bc92E0da2e4aC174b8E33D7c74b5009563a8e2A] = 21542365440880000000000;
667         preICOFunders.push(0xA1CA632CF8Fb3a965c84668e09e3BEdb3567F35D);
668         preICOBalances[0xA1CA632CF8Fb3a965c84668e09e3BEdb3567F35D] = 15000000000000000000000;
669         preICOFunders.push(0x1DCeF74ddD26c82f34B300E027b5CaA4eC4F8C83);
670         preICOBalances[0x1DCeF74ddD26c82f34B300E027b5CaA4eC4F8C83] = 15000000000000000000000;
671         preICOFunders.push(0x51B7Bf4B7C1E89cfe7C09938Ad0096F9dFFCA4B7);
672         preICOBalances[0x51B7Bf4B7C1E89cfe7C09938Ad0096F9dFFCA4B7] = 17533640761380000000000;
673 
674         // pre sale round 2 
675         preICOFunders.push(0xD2Cdc0905877ee3b7d08220D783bd042de825AEb);
676         preICOBalances[0xD2Cdc0905877ee3b7d08220D783bd042de825AEb] = 5000000000000000000000;
677         preICOFunders.push(0x3b217081702AF670e2c2fD25FD7da882620a68E8);
678         preICOBalances[0x3b217081702AF670e2c2fD25FD7da882620a68E8] = 7415245400000000000000;
679         preICOFunders.push(0xbA860D4B9423bF6b517B29c395A49fe80Da758E3);
680         preICOBalances[0xbA860D4B9423bF6b517B29c395A49fe80Da758E3] = 5000000000000000000000;
681         preICOFunders.push(0xF64b80DdfB860C0D1bEb760fd9fC663c4D5C4dC3);
682         preICOBalances[0xF64b80DdfB860C0D1bEb760fd9fC663c4D5C4dC3] = 75000000000000000000000;
683         preICOFunders.push(0x396D5A35B5f41D7cafCCF9BeF225c274d2c7B6E2);
684         preICOBalances[0x396D5A35B5f41D7cafCCF9BeF225c274d2c7B6E2] = 74589245777000000000000;
685         preICOFunders.push(0x4d61A4aD175E96139Ae8c5d951327e3f6Cc3f764);
686         preICOBalances[0x4d61A4aD175E96139Ae8c5d951327e3f6Cc3f764] = 5000000000000000000000;
687         preICOFunders.push(0x4B490F6A49C17657A5508B8Bf8F1D7f5aAD8c921);
688         preICOBalances[0x4B490F6A49C17657A5508B8Bf8F1D7f5aAD8c921] = 200000000000000000000000;
689         preICOFunders.push(0xC943038f2f1dd1faC6E10B82039C14bd20ff1F8E);
690         preICOBalances[0xC943038f2f1dd1faC6E10B82039C14bd20ff1F8E] = 174522545811300000000000;
691         preICOFunders.push(0xBa87D63A8C4Ed665b6881BaCe4A225a07c418F22);
692         preICOBalances[0xBa87D63A8C4Ed665b6881BaCe4A225a07c418F22] = 5000000000000000000000;
693         preICOFunders.push(0x753846c0467cF320BcDA9f1C67fF86dF39b1438c);
694         preICOBalances[0x753846c0467cF320BcDA9f1C67fF86dF39b1438c] = 5000000000000000000000;
695         preICOFunders.push(0x3773bBB1adDF9D642D5bbFaafa13b0690Fb33460);
696         preICOBalances[0x3773bBB1adDF9D642D5bbFaafa13b0690Fb33460] = 5000000000000000000000;
697         preICOFunders.push(0x456Cf70345cbF483779166af117B40938B8F0A9c);
698         preICOBalances[0x456Cf70345cbF483779166af117B40938B8F0A9c] = 50000000000000000000000;
699         preICOFunders.push(0x662AE260D736F041Db66c34617d5fB22eC0cC2Ee);
700         preICOBalances[0x662AE260D736F041Db66c34617d5fB22eC0cC2Ee] = 40000000000000000000000;
701         preICOFunders.push(0xEa7e647F167AdAa4df52AF630A873a1379f68E3F);
702         preICOBalances[0xEa7e647F167AdAa4df52AF630A873a1379f68E3F] = 40000000000000000000000;
703         preICOFunders.push(0x352913f3F7CA96530180b93C18C86f38b3F0c429);
704         preICOBalances[0x352913f3F7CA96530180b93C18C86f38b3F0c429] = 45458265454000000000000;
705         preICOFunders.push(0xB21bf8391a6500ED210Af96d125867124261f4d4);
706         preICOBalances[0xB21bf8391a6500ED210Af96d125867124261f4d4] = 5000000000000000000000;
707         preICOFunders.push(0xDecBd29B42c66f90679D2CB34e73E571F447f6c5);
708         preICOBalances[0xDecBd29B42c66f90679D2CB34e73E571F447f6c5] = 7500000000000000000000;
709         preICOFunders.push(0xE36106a0DC0F07e87f7194694631511317909b8B);
710         preICOBalances[0xE36106a0DC0F07e87f7194694631511317909b8B] = 5000000000000000000000;
711         preICOFunders.push(0xe9114cd97E0Ee4fe349D3F57d0C9710E18581b69);
712         preICOBalances[0xe9114cd97E0Ee4fe349D3F57d0C9710E18581b69] = 40000000000000000000000;
713         preICOFunders.push(0xC73996ce45752B9AE4e85EDDf056Aa9aaCaAD4A2);
714         preICOBalances[0xC73996ce45752B9AE4e85EDDf056Aa9aaCaAD4A2] = 100000000000000000000000;
715         preICOFunders.push(0x6C1407d9984Dc2cE33456b67acAaEC78c1784673);
716         preICOBalances[0x6C1407d9984Dc2cE33456b67acAaEC78c1784673] = 5000000000000000000000;
717         preICOFunders.push(0x987e93429004CA9fa2A42604658B99Bb5A574f01);
718         preICOBalances[0x987e93429004CA9fa2A42604658B99Bb5A574f01] = 124354548881022000000000;
719         preICOFunders.push(0x4c3B81B5f9f9c7efa03bE39218E6760E8D2A1609);
720         preICOBalances[0x4c3B81B5f9f9c7efa03bE39218E6760E8D2A1609] = 5000000000000000000000;
721         preICOFunders.push(0x33fA8cd89B151458Cb147ecC497e469f2c1D38eA);
722         preICOBalances[0x33fA8cd89B151458Cb147ecC497e469f2c1D38eA] = 60000000000000000000000;
723 
724         // main sale (01-31 of Marh)
725         preICOFunders.push(0x9AfA1204afCf48AB4302F246Ef4BE5C1D733a751);
726         preICOBalances[0x9AfA1204afCf48AB4302F246Ef4BE5C1D733a751] = 154551417972192330000000;
727     }
728 
729     /**
730      * @dev Add a new address to the funders
731      * @param _funder funder's address
732      */
733     function addFunder(address _funder) public onlyOwner {
734         if (!funded[_funder]) {
735             funders.push(_funder);
736             funded[_funder] = true;
737         }
738     }
739    
740     /**
741      * @return true if address is a funder address
742      * @param _funder funder's address
743      */
744     function isFunder(address _funder) public view returns(bool) {
745         return funded[_funder];
746     }
747 
748     /**
749      * @return funders count
750      */
751     function getFundersCount() public view returns(uint256) {
752         return funders.length;
753     }
754 
755     /**
756      * @return number of preICO funders count
757      */
758     function getPreICOFundersCount() public view returns(uint256) {
759         return preICOFunders.length;
760     }
761 
762     /**
763      * @dev Add a new oraclize funding order
764      * @param _orderId oraclize order id
765      * @param _beneficiary who'll get the tokens
766      * @param _funds paid wei amount
767      * @param _bonus bonus amount
768      */
769     function addOrder(
770         bytes32 _orderId, 
771         address _beneficiary, 
772         uint256 _funds, 
773         uint256 _bonus
774     )
775         public 
776         onlyOwner 
777     {
778         orders[_orderId].beneficiary = _beneficiary;
779         orders[_orderId].funds = _funds;
780         orders[_orderId].bonus = _bonus;
781     }
782 
783     /**
784      * @dev Get oraclize funding order by order id
785      * @param _orderId oraclize order id
786      * @return beneficiaty address, paid funds amount and bonus amount 
787      */
788     function getOrder(bytes32 _orderId) 
789         public 
790         view 
791         returns(address, uint256, uint256)
792     {
793         address _beneficiary = orders[_orderId].beneficiary;
794         uint256 _funds = orders[_orderId].funds;
795         uint256 _bonus = orders[_orderId].bonus;
796 
797         return (_beneficiary, _funds, _bonus);
798     }
799 
800     /**
801      * @dev Set eth/usd rate for the specified oraclize order
802      * @param _orderId oraclize order id
803      * @param _rate eth/usd rate
804      */
805     function setRateForOrder(bytes32 _orderId, uint256 _rate) public onlyOwner {
806         orders[_orderId].rate = _rate;
807     }
808 
809     /**
810      * @dev Add a new oraclize unsold tokens allocation order
811      * @param _orderId oraclize order id
812      */
813     function addUnsoldAllocationOrder(bytes32 _orderId) public onlyOwner {
814         unsoldAllocationOrders[_orderId] = true;
815     }
816 
817     /**
818      * @dev Whitelist the address
819      * @param _address address to be whitelisted
820      */
821     function addToWhitelist(address _address) public onlyOwner {
822         whitelist[_address] = true;
823     }
824 
825     /**
826      * @dev Check if address is whitelisted
827      * @param _address address that needs to be verified
828      * @return true if address is whitelisted
829      */
830     function isWhitelisted(address _address) public view returns(bool) {
831         return whitelist[_address];
832     }
833 
834     /**
835      * @dev Get bonus amount for token purchase
836      * @param _funds amount of the funds
837      * @param _bonusChangeTime bonus change time
838      * @return corresponding bonus value
839      */
840     function getBonus(uint256 _funds, uint256 _bonusChangeTime) public view returns(uint256) {
841         
842         if (_funds < VOLUME_BONUS_CONDITION)
843             return 0;
844 
845         if (now < _bonusChangeTime) { // solium-disable-line security/no-block-members
846             if (_funds >= VOLUME_EXTRA_BONUS_CONDITION)
847                 return FIRST_VOLUME_EXTRA_BONUS;
848             else 
849                 return FIRST_VOLUME_BONUS;
850         } else {
851             if (_funds >= VOLUME_EXTRA_BONUS_CONDITION)
852                 return SECOND_VOLUME_EXTRA_BONUS;
853             else
854                 return SECOND_VOLUME_BONUS;
855         }
856         return 0;
857     }
858 }
859 
860 
861 
862 // <ORACLIZE_API>
863 /*
864 Copyright (c) 2015-2016 Oraclize SRL
865 Copyright (c) 2016 Oraclize LTD
866 
867 
868 
869 Permission is hereby granted, free of charge, to any person obtaining a copy
870 of this software and associated documentation files (the "Software"), to deal
871 in the Software without restriction, including without limitation the rights
872 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
873 copies of the Software, and to permit persons to whom the Software is
874 furnished to do so, subject to the following conditions:
875 
876 
877 
878 The above copyright notice and this permission notice shall be included in
879 all copies or substantial portions of the Software.
880 
881 
882 
883 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
884 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
885 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
886 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
887 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
888 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
889 THE SOFTWARE.
890 */
891 
892 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
893 pragma solidity ^0.4.18;
894 
895 contract OraclizeI {
896     address public cbAddress;
897     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
898     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
899     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
900     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
901     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
902     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
903     function getPrice(string _datasource) public returns (uint _dsprice);
904     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
905     function setProofType(byte _proofType) external;
906     function setCustomGasPrice(uint _gasPrice) external;
907     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
908 }
909 contract OraclizeAddrResolverI {
910     function getAddress() public returns (address _addr);
911 }
912 contract usingOraclize {
913     uint constant day = 60*60*24;
914     uint constant week = 60*60*24*7;
915     uint constant month = 60*60*24*30;
916     byte constant proofType_NONE = 0x00;
917     byte constant proofType_TLSNotary = 0x10;
918     byte constant proofType_Android = 0x20;
919     byte constant proofType_Ledger = 0x30;
920     byte constant proofType_Native = 0xF0;
921     byte constant proofStorage_IPFS = 0x01;
922     uint8 constant networkID_auto = 0;
923     uint8 constant networkID_mainnet = 1;
924     uint8 constant networkID_testnet = 2;
925     uint8 constant networkID_morden = 2;
926     uint8 constant networkID_consensys = 161;
927 
928     OraclizeAddrResolverI OAR;
929 
930     OraclizeI oraclize;
931     modifier oraclizeAPI {
932         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
933             oraclize_setNetwork(networkID_auto);
934 
935         if(address(oraclize) != OAR.getAddress())
936             oraclize = OraclizeI(OAR.getAddress());
937 
938         _;
939     }
940     modifier coupon(string code){
941         oraclize = OraclizeI(OAR.getAddress());
942         _;
943     }
944 
945     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
946       return oraclize_setNetwork();
947       networkID; // silence the warning and remain backwards compatible
948     }
949     function oraclize_setNetwork() internal returns(bool){
950         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
951             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
952             oraclize_setNetworkName("eth_mainnet");
953             return true;
954         }
955         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
956             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
957             oraclize_setNetworkName("eth_ropsten3");
958             return true;
959         }
960         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
961             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
962             oraclize_setNetworkName("eth_kovan");
963             return true;
964         }
965         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
966             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
967             oraclize_setNetworkName("eth_rinkeby");
968             return true;
969         }
970         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
971             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
972             return true;
973         }
974         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
975             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
976             return true;
977         }
978         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
979             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
980             return true;
981         }
982         return false;
983     }
984 
985     function __callback(bytes32 myid, string result) public {
986         __callback(myid, result, new bytes(0));
987     }
988     function __callback(bytes32 myid, string result, bytes proof) public {
989       return;
990       myid; result; proof; // Silence compiler warnings
991     }
992 
993     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
994         return oraclize.getPrice(datasource);
995     }
996 
997     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
998         return oraclize.getPrice(datasource, gaslimit);
999     }
1000 
1001     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1002         uint price = oraclize.getPrice(datasource);
1003         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1004         return oraclize.query.value(price)(0, datasource, arg);
1005     }
1006     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1007         uint price = oraclize.getPrice(datasource);
1008         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1009         return oraclize.query.value(price)(timestamp, datasource, arg);
1010     }
1011     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1012         uint price = oraclize.getPrice(datasource, gaslimit);
1013         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1014         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1015     }
1016     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1017         uint price = oraclize.getPrice(datasource, gaslimit);
1018         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1019         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1020     }
1021     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1022         uint price = oraclize.getPrice(datasource);
1023         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1024         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1025     }
1026     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1027         uint price = oraclize.getPrice(datasource);
1028         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1029         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1030     }
1031     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1032         uint price = oraclize.getPrice(datasource, gaslimit);
1033         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1034         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1035     }
1036     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1037         uint price = oraclize.getPrice(datasource, gaslimit);
1038         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1039         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1040     }
1041     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1042         uint price = oraclize.getPrice(datasource);
1043         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1044         bytes memory args = stra2cbor(argN);
1045         return oraclize.queryN.value(price)(0, datasource, args);
1046     }
1047     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1048         uint price = oraclize.getPrice(datasource);
1049         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1050         bytes memory args = stra2cbor(argN);
1051         return oraclize.queryN.value(price)(timestamp, datasource, args);
1052     }
1053     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1054         uint price = oraclize.getPrice(datasource, gaslimit);
1055         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1056         bytes memory args = stra2cbor(argN);
1057         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1058     }
1059     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1060         uint price = oraclize.getPrice(datasource, gaslimit);
1061         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1062         bytes memory args = stra2cbor(argN);
1063         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1064     }
1065     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1066         string[] memory dynargs = new string[](1);
1067         dynargs[0] = args[0];
1068         return oraclize_query(datasource, dynargs);
1069     }
1070     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1071         string[] memory dynargs = new string[](1);
1072         dynargs[0] = args[0];
1073         return oraclize_query(timestamp, datasource, dynargs);
1074     }
1075     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1076         string[] memory dynargs = new string[](1);
1077         dynargs[0] = args[0];
1078         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1079     }
1080     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1081         string[] memory dynargs = new string[](1);
1082         dynargs[0] = args[0];
1083         return oraclize_query(datasource, dynargs, gaslimit);
1084     }
1085 
1086     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1087         string[] memory dynargs = new string[](2);
1088         dynargs[0] = args[0];
1089         dynargs[1] = args[1];
1090         return oraclize_query(datasource, dynargs);
1091     }
1092     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1093         string[] memory dynargs = new string[](2);
1094         dynargs[0] = args[0];
1095         dynargs[1] = args[1];
1096         return oraclize_query(timestamp, datasource, dynargs);
1097     }
1098     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1099         string[] memory dynargs = new string[](2);
1100         dynargs[0] = args[0];
1101         dynargs[1] = args[1];
1102         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1103     }
1104     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1105         string[] memory dynargs = new string[](2);
1106         dynargs[0] = args[0];
1107         dynargs[1] = args[1];
1108         return oraclize_query(datasource, dynargs, gaslimit);
1109     }
1110     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1111         string[] memory dynargs = new string[](3);
1112         dynargs[0] = args[0];
1113         dynargs[1] = args[1];
1114         dynargs[2] = args[2];
1115         return oraclize_query(datasource, dynargs);
1116     }
1117     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1118         string[] memory dynargs = new string[](3);
1119         dynargs[0] = args[0];
1120         dynargs[1] = args[1];
1121         dynargs[2] = args[2];
1122         return oraclize_query(timestamp, datasource, dynargs);
1123     }
1124     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1125         string[] memory dynargs = new string[](3);
1126         dynargs[0] = args[0];
1127         dynargs[1] = args[1];
1128         dynargs[2] = args[2];
1129         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1130     }
1131     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1132         string[] memory dynargs = new string[](3);
1133         dynargs[0] = args[0];
1134         dynargs[1] = args[1];
1135         dynargs[2] = args[2];
1136         return oraclize_query(datasource, dynargs, gaslimit);
1137     }
1138 
1139     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1140         string[] memory dynargs = new string[](4);
1141         dynargs[0] = args[0];
1142         dynargs[1] = args[1];
1143         dynargs[2] = args[2];
1144         dynargs[3] = args[3];
1145         return oraclize_query(datasource, dynargs);
1146     }
1147     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1148         string[] memory dynargs = new string[](4);
1149         dynargs[0] = args[0];
1150         dynargs[1] = args[1];
1151         dynargs[2] = args[2];
1152         dynargs[3] = args[3];
1153         return oraclize_query(timestamp, datasource, dynargs);
1154     }
1155     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1156         string[] memory dynargs = new string[](4);
1157         dynargs[0] = args[0];
1158         dynargs[1] = args[1];
1159         dynargs[2] = args[2];
1160         dynargs[3] = args[3];
1161         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1162     }
1163     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1164         string[] memory dynargs = new string[](4);
1165         dynargs[0] = args[0];
1166         dynargs[1] = args[1];
1167         dynargs[2] = args[2];
1168         dynargs[3] = args[3];
1169         return oraclize_query(datasource, dynargs, gaslimit);
1170     }
1171     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1172         string[] memory dynargs = new string[](5);
1173         dynargs[0] = args[0];
1174         dynargs[1] = args[1];
1175         dynargs[2] = args[2];
1176         dynargs[3] = args[3];
1177         dynargs[4] = args[4];
1178         return oraclize_query(datasource, dynargs);
1179     }
1180     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1181         string[] memory dynargs = new string[](5);
1182         dynargs[0] = args[0];
1183         dynargs[1] = args[1];
1184         dynargs[2] = args[2];
1185         dynargs[3] = args[3];
1186         dynargs[4] = args[4];
1187         return oraclize_query(timestamp, datasource, dynargs);
1188     }
1189     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1190         string[] memory dynargs = new string[](5);
1191         dynargs[0] = args[0];
1192         dynargs[1] = args[1];
1193         dynargs[2] = args[2];
1194         dynargs[3] = args[3];
1195         dynargs[4] = args[4];
1196         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1197     }
1198     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1199         string[] memory dynargs = new string[](5);
1200         dynargs[0] = args[0];
1201         dynargs[1] = args[1];
1202         dynargs[2] = args[2];
1203         dynargs[3] = args[3];
1204         dynargs[4] = args[4];
1205         return oraclize_query(datasource, dynargs, gaslimit);
1206     }
1207     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1208         uint price = oraclize.getPrice(datasource);
1209         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1210         bytes memory args = ba2cbor(argN);
1211         return oraclize.queryN.value(price)(0, datasource, args);
1212     }
1213     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1214         uint price = oraclize.getPrice(datasource);
1215         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1216         bytes memory args = ba2cbor(argN);
1217         return oraclize.queryN.value(price)(timestamp, datasource, args);
1218     }
1219     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1220         uint price = oraclize.getPrice(datasource, gaslimit);
1221         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1222         bytes memory args = ba2cbor(argN);
1223         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1224     }
1225     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1226         uint price = oraclize.getPrice(datasource, gaslimit);
1227         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1228         bytes memory args = ba2cbor(argN);
1229         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1230     }
1231     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1232         bytes[] memory dynargs = new bytes[](1);
1233         dynargs[0] = args[0];
1234         return oraclize_query(datasource, dynargs);
1235     }
1236     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1237         bytes[] memory dynargs = new bytes[](1);
1238         dynargs[0] = args[0];
1239         return oraclize_query(timestamp, datasource, dynargs);
1240     }
1241     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1242         bytes[] memory dynargs = new bytes[](1);
1243         dynargs[0] = args[0];
1244         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1245     }
1246     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1247         bytes[] memory dynargs = new bytes[](1);
1248         dynargs[0] = args[0];
1249         return oraclize_query(datasource, dynargs, gaslimit);
1250     }
1251 
1252     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1253         bytes[] memory dynargs = new bytes[](2);
1254         dynargs[0] = args[0];
1255         dynargs[1] = args[1];
1256         return oraclize_query(datasource, dynargs);
1257     }
1258     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1259         bytes[] memory dynargs = new bytes[](2);
1260         dynargs[0] = args[0];
1261         dynargs[1] = args[1];
1262         return oraclize_query(timestamp, datasource, dynargs);
1263     }
1264     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1265         bytes[] memory dynargs = new bytes[](2);
1266         dynargs[0] = args[0];
1267         dynargs[1] = args[1];
1268         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1269     }
1270     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1271         bytes[] memory dynargs = new bytes[](2);
1272         dynargs[0] = args[0];
1273         dynargs[1] = args[1];
1274         return oraclize_query(datasource, dynargs, gaslimit);
1275     }
1276     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1277         bytes[] memory dynargs = new bytes[](3);
1278         dynargs[0] = args[0];
1279         dynargs[1] = args[1];
1280         dynargs[2] = args[2];
1281         return oraclize_query(datasource, dynargs);
1282     }
1283     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1284         bytes[] memory dynargs = new bytes[](3);
1285         dynargs[0] = args[0];
1286         dynargs[1] = args[1];
1287         dynargs[2] = args[2];
1288         return oraclize_query(timestamp, datasource, dynargs);
1289     }
1290     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1291         bytes[] memory dynargs = new bytes[](3);
1292         dynargs[0] = args[0];
1293         dynargs[1] = args[1];
1294         dynargs[2] = args[2];
1295         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1296     }
1297     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1298         bytes[] memory dynargs = new bytes[](3);
1299         dynargs[0] = args[0];
1300         dynargs[1] = args[1];
1301         dynargs[2] = args[2];
1302         return oraclize_query(datasource, dynargs, gaslimit);
1303     }
1304 
1305     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1306         bytes[] memory dynargs = new bytes[](4);
1307         dynargs[0] = args[0];
1308         dynargs[1] = args[1];
1309         dynargs[2] = args[2];
1310         dynargs[3] = args[3];
1311         return oraclize_query(datasource, dynargs);
1312     }
1313     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1314         bytes[] memory dynargs = new bytes[](4);
1315         dynargs[0] = args[0];
1316         dynargs[1] = args[1];
1317         dynargs[2] = args[2];
1318         dynargs[3] = args[3];
1319         return oraclize_query(timestamp, datasource, dynargs);
1320     }
1321     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1322         bytes[] memory dynargs = new bytes[](4);
1323         dynargs[0] = args[0];
1324         dynargs[1] = args[1];
1325         dynargs[2] = args[2];
1326         dynargs[3] = args[3];
1327         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1328     }
1329     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1330         bytes[] memory dynargs = new bytes[](4);
1331         dynargs[0] = args[0];
1332         dynargs[1] = args[1];
1333         dynargs[2] = args[2];
1334         dynargs[3] = args[3];
1335         return oraclize_query(datasource, dynargs, gaslimit);
1336     }
1337     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1338         bytes[] memory dynargs = new bytes[](5);
1339         dynargs[0] = args[0];
1340         dynargs[1] = args[1];
1341         dynargs[2] = args[2];
1342         dynargs[3] = args[3];
1343         dynargs[4] = args[4];
1344         return oraclize_query(datasource, dynargs);
1345     }
1346     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1347         bytes[] memory dynargs = new bytes[](5);
1348         dynargs[0] = args[0];
1349         dynargs[1] = args[1];
1350         dynargs[2] = args[2];
1351         dynargs[3] = args[3];
1352         dynargs[4] = args[4];
1353         return oraclize_query(timestamp, datasource, dynargs);
1354     }
1355     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1356         bytes[] memory dynargs = new bytes[](5);
1357         dynargs[0] = args[0];
1358         dynargs[1] = args[1];
1359         dynargs[2] = args[2];
1360         dynargs[3] = args[3];
1361         dynargs[4] = args[4];
1362         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1363     }
1364     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1365         bytes[] memory dynargs = new bytes[](5);
1366         dynargs[0] = args[0];
1367         dynargs[1] = args[1];
1368         dynargs[2] = args[2];
1369         dynargs[3] = args[3];
1370         dynargs[4] = args[4];
1371         return oraclize_query(datasource, dynargs, gaslimit);
1372     }
1373 
1374     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1375         return oraclize.cbAddress();
1376     }
1377     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1378         return oraclize.setProofType(proofP);
1379     }
1380     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1381         return oraclize.setCustomGasPrice(gasPrice);
1382     }
1383 
1384     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1385         return oraclize.randomDS_getSessionPubKeyHash();
1386     }
1387 
1388     function getCodeSize(address _addr) constant internal returns(uint _size) {
1389         assembly {
1390             _size := extcodesize(_addr)
1391         }
1392     }
1393 
1394     function parseAddr(string _a) internal pure returns (address){
1395         bytes memory tmp = bytes(_a);
1396         uint160 iaddr = 0;
1397         uint160 b1;
1398         uint160 b2;
1399         for (uint i=2; i<2+2*20; i+=2){
1400             iaddr *= 256;
1401             b1 = uint160(tmp[i]);
1402             b2 = uint160(tmp[i+1]);
1403             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1404             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1405             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1406             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1407             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1408             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1409             iaddr += (b1*16+b2);
1410         }
1411         return address(iaddr);
1412     }
1413 
1414     function strCompare(string _a, string _b) internal pure returns (int) {
1415         bytes memory a = bytes(_a);
1416         bytes memory b = bytes(_b);
1417         uint minLength = a.length;
1418         if (b.length < minLength) minLength = b.length;
1419         for (uint i = 0; i < minLength; i ++)
1420             if (a[i] < b[i])
1421                 return -1;
1422             else if (a[i] > b[i])
1423                 return 1;
1424         if (a.length < b.length)
1425             return -1;
1426         else if (a.length > b.length)
1427             return 1;
1428         else
1429             return 0;
1430     }
1431 
1432     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1433         bytes memory h = bytes(_haystack);
1434         bytes memory n = bytes(_needle);
1435         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1436             return -1;
1437         else if(h.length > (2**128 -1))
1438             return -1;
1439         else
1440         {
1441             uint subindex = 0;
1442             for (uint i = 0; i < h.length; i ++)
1443             {
1444                 if (h[i] == n[0])
1445                 {
1446                     subindex = 1;
1447                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1448                     {
1449                         subindex++;
1450                     }
1451                     if(subindex == n.length)
1452                         return int(i);
1453                 }
1454             }
1455             return -1;
1456         }
1457     }
1458 
1459     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1460         bytes memory _ba = bytes(_a);
1461         bytes memory _bb = bytes(_b);
1462         bytes memory _bc = bytes(_c);
1463         bytes memory _bd = bytes(_d);
1464         bytes memory _be = bytes(_e);
1465         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1466         bytes memory babcde = bytes(abcde);
1467         uint k = 0;
1468         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1469         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1470         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1471         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1472         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1473         return string(babcde);
1474     }
1475 
1476     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1477         return strConcat(_a, _b, _c, _d, "");
1478     }
1479 
1480     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1481         return strConcat(_a, _b, _c, "", "");
1482     }
1483 
1484     function strConcat(string _a, string _b) internal pure returns (string) {
1485         return strConcat(_a, _b, "", "", "");
1486     }
1487 
1488     // parseInt
1489     function parseInt(string _a) internal pure returns (uint) {
1490         return parseInt(_a, 0);
1491     }
1492 
1493     // parseInt(parseFloat*10^_b)
1494     function parseInt(string _a, uint _b) internal pure returns (uint) {
1495         bytes memory bresult = bytes(_a);
1496         uint mint = 0;
1497         bool decimals = false;
1498         for (uint i=0; i<bresult.length; i++){
1499             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1500                 if (decimals){
1501                    if (_b == 0) break;
1502                     else _b--;
1503                 }
1504                 mint *= 10;
1505                 mint += uint(bresult[i]) - 48;
1506             } else if (bresult[i] == 46) decimals = true;
1507         }
1508         if (_b > 0) mint *= 10**_b;
1509         return mint;
1510     }
1511 
1512     function uint2str(uint i) internal pure returns (string){
1513         if (i == 0) return "0";
1514         uint j = i;
1515         uint len;
1516         while (j != 0){
1517             len++;
1518             j /= 10;
1519         }
1520         bytes memory bstr = new bytes(len);
1521         uint k = len - 1;
1522         while (i != 0){
1523             bstr[k--] = byte(48 + i % 10);
1524             i /= 10;
1525         }
1526         return string(bstr);
1527     }
1528 
1529     function stra2cbor(string[] arr) internal pure returns (bytes) {
1530             uint arrlen = arr.length;
1531 
1532             // get correct cbor output length
1533             uint outputlen = 0;
1534             bytes[] memory elemArray = new bytes[](arrlen);
1535             for (uint i = 0; i < arrlen; i++) {
1536                 elemArray[i] = (bytes(arr[i]));
1537                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1538             }
1539             uint ctr = 0;
1540             uint cborlen = arrlen + 0x80;
1541             outputlen += byte(cborlen).length;
1542             bytes memory res = new bytes(outputlen);
1543 
1544             while (byte(cborlen).length > ctr) {
1545                 res[ctr] = byte(cborlen)[ctr];
1546                 ctr++;
1547             }
1548             for (i = 0; i < arrlen; i++) {
1549                 res[ctr] = 0x5F;
1550                 ctr++;
1551                 for (uint x = 0; x < elemArray[i].length; x++) {
1552                     // if there's a bug with larger strings, this may be the culprit
1553                     if (x % 23 == 0) {
1554                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1555                         elemcborlen += 0x40;
1556                         uint lctr = ctr;
1557                         while (byte(elemcborlen).length > ctr - lctr) {
1558                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1559                             ctr++;
1560                         }
1561                     }
1562                     res[ctr] = elemArray[i][x];
1563                     ctr++;
1564                 }
1565                 res[ctr] = 0xFF;
1566                 ctr++;
1567             }
1568             return res;
1569         }
1570 
1571     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1572             uint arrlen = arr.length;
1573 
1574             // get correct cbor output length
1575             uint outputlen = 0;
1576             bytes[] memory elemArray = new bytes[](arrlen);
1577             for (uint i = 0; i < arrlen; i++) {
1578                 elemArray[i] = (bytes(arr[i]));
1579                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1580             }
1581             uint ctr = 0;
1582             uint cborlen = arrlen + 0x80;
1583             outputlen += byte(cborlen).length;
1584             bytes memory res = new bytes(outputlen);
1585 
1586             while (byte(cborlen).length > ctr) {
1587                 res[ctr] = byte(cborlen)[ctr];
1588                 ctr++;
1589             }
1590             for (i = 0; i < arrlen; i++) {
1591                 res[ctr] = 0x5F;
1592                 ctr++;
1593                 for (uint x = 0; x < elemArray[i].length; x++) {
1594                     // if there's a bug with larger strings, this may be the culprit
1595                     if (x % 23 == 0) {
1596                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1597                         elemcborlen += 0x40;
1598                         uint lctr = ctr;
1599                         while (byte(elemcborlen).length > ctr - lctr) {
1600                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1601                             ctr++;
1602                         }
1603                     }
1604                     res[ctr] = elemArray[i][x];
1605                     ctr++;
1606                 }
1607                 res[ctr] = 0xFF;
1608                 ctr++;
1609             }
1610             return res;
1611         }
1612 
1613 
1614     string oraclize_network_name;
1615     function oraclize_setNetworkName(string _network_name) internal {
1616         oraclize_network_name = _network_name;
1617     }
1618 
1619     function oraclize_getNetworkName() internal view returns (string) {
1620         return oraclize_network_name;
1621     }
1622 
1623     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1624         require((_nbytes > 0) && (_nbytes <= 32));
1625         bytes memory nbytes = new bytes(1);
1626         nbytes[0] = byte(_nbytes);
1627         bytes memory unonce = new bytes(32);
1628         bytes memory sessionKeyHash = new bytes(32);
1629         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1630         assembly {
1631             mstore(unonce, 0x20)
1632             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1633             mstore(sessionKeyHash, 0x20)
1634             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1635         }
1636         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
1637         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
1638         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
1639         return queryId;
1640     }
1641 
1642     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1643         oraclize_randomDS_args[queryId] = commitment;
1644     }
1645 
1646     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1647     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1648 
1649     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1650         bool sigok;
1651         address signer;
1652 
1653         bytes32 sigr;
1654         bytes32 sigs;
1655 
1656         bytes memory sigr_ = new bytes(32);
1657         uint offset = 4+(uint(dersig[3]) - 0x20);
1658         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1659         bytes memory sigs_ = new bytes(32);
1660         offset += 32 + 2;
1661         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1662 
1663         assembly {
1664             sigr := mload(add(sigr_, 32))
1665             sigs := mload(add(sigs_, 32))
1666         }
1667 
1668 
1669         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1670         if (address(keccak256(pubkey)) == signer) return true;
1671         else {
1672             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1673             return (address(keccak256(pubkey)) == signer);
1674         }
1675     }
1676 
1677     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1678         bool sigok;
1679 
1680         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1681         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1682         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1683 
1684         bytes memory appkey1_pubkey = new bytes(64);
1685         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1686 
1687         bytes memory tosign2 = new bytes(1+65+32);
1688         tosign2[0] = byte(1); //role
1689         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1690         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1691         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1692         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1693 
1694         if (sigok == false) return false;
1695 
1696 
1697         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1698         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1699 
1700         bytes memory tosign3 = new bytes(1+65);
1701         tosign3[0] = 0xFE;
1702         copyBytes(proof, 3, 65, tosign3, 1);
1703 
1704         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1705         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1706 
1707         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1708 
1709         return sigok;
1710     }
1711 
1712     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1713         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1714         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1715 
1716         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1717         require(proofVerified);
1718 
1719         _;
1720     }
1721 
1722     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1723         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1724         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1725 
1726         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1727         if (proofVerified == false) return 2;
1728 
1729         return 0;
1730     }
1731 
1732     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1733         bool match_ = true;
1734 
1735 
1736         for (uint256 i=0; i< n_random_bytes; i++) {
1737             if (content[i] != prefix[i]) match_ = false;
1738         }
1739 
1740         return match_;
1741     }
1742 
1743     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1744 
1745         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1746         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1747         bytes memory keyhash = new bytes(32);
1748         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1749         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1750 
1751         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1752         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1753 
1754         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1755         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1756 
1757         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1758         // This is to verify that the computed args match with the ones specified in the query.
1759         bytes memory commitmentSlice1 = new bytes(8+1+32);
1760         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1761 
1762         bytes memory sessionPubkey = new bytes(64);
1763         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1764         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1765 
1766         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1767         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1768             delete oraclize_randomDS_args[queryId];
1769         } else return false;
1770 
1771 
1772         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1773         bytes memory tosign1 = new bytes(32+8+1+32);
1774         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1775         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1776 
1777         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1778         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1779             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1780         }
1781 
1782         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1783     }
1784 
1785     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1786     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1787         uint minLength = length + toOffset;
1788 
1789         // Buffer too small
1790         require(to.length >= minLength); // Should be a better way?
1791 
1792         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1793         uint i = 32 + fromOffset;
1794         uint j = 32 + toOffset;
1795 
1796         while (i < (32 + fromOffset + length)) {
1797             assembly {
1798                 let tmp := mload(add(from, i))
1799                 mstore(add(to, j), tmp)
1800             }
1801             i += 32;
1802             j += 32;
1803         }
1804 
1805         return to;
1806     }
1807 
1808     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1809     // Duplicate Solidity's ecrecover, but catching the CALL return value
1810     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1811         // We do our own memory management here. Solidity uses memory offset
1812         // 0x40 to store the current end of memory. We write past it (as
1813         // writes are memory extensions), but don't update the offset so
1814         // Solidity will reuse it. The memory used here is only needed for
1815         // this context.
1816 
1817         // FIXME: inline assembly can't access return values
1818         bool ret;
1819         address addr;
1820 
1821         assembly {
1822             let size := mload(0x40)
1823             mstore(size, hash)
1824             mstore(add(size, 32), v)
1825             mstore(add(size, 64), r)
1826             mstore(add(size, 96), s)
1827 
1828             // NOTE: we can reuse the request memory because we deal with
1829             //       the return code
1830             ret := call(3000, 1, 0, size, 128, size, 32)
1831             addr := mload(size)
1832         }
1833 
1834         return (ret, addr);
1835     }
1836 
1837     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1838     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1839         bytes32 r;
1840         bytes32 s;
1841         uint8 v;
1842 
1843         if (sig.length != 65)
1844           return (false, 0);
1845 
1846         // The signature format is a compact form of:
1847         //   {bytes32 r}{bytes32 s}{uint8 v}
1848         // Compact means, uint8 is not padded to 32 bytes.
1849         assembly {
1850             r := mload(add(sig, 32))
1851             s := mload(add(sig, 64))
1852 
1853             // Here we are loading the last 32 bytes. We exploit the fact that
1854             // 'mload' will pad with zeroes if we overread.
1855             // There is no 'mload8' to do this, but that would be nicer.
1856             v := byte(0, mload(add(sig, 96)))
1857 
1858             // Alternative solution:
1859             // 'byte' is not working due to the Solidity parser, so lets
1860             // use the second best option, 'and'
1861             // v := and(mload(add(sig, 65)), 255)
1862         }
1863 
1864         // albeit non-transactional signatures are not specified by the YP, one would expect it
1865         // to match the YP range of [27, 28]
1866         //
1867         // geth uses [0, 1] and some clients have followed. This might change, see:
1868         //  https://github.com/ethereum/go-ethereum/issues/2053
1869         if (v < 27)
1870           v += 27;
1871 
1872         if (v != 27 && v != 28)
1873             return (false, 0);
1874 
1875         return safer_ecrecover(hash, v, r, s);
1876     }
1877 
1878 }
1879 // </ORACLIZE_API>
1880 
1881 
1882 
1883 /**
1884  * @title BetexICO
1885  */
1886 contract BetexICO is usingOraclize, HasNoContracts {
1887     using SafeMath for uint256;
1888     using SafeERC20 for ERC20;
1889 
1890     // Betex token
1891     BetexToken public token;
1892 
1893     // Betex storage
1894     BetexStorage public betexStorage;
1895 
1896     // ico start timestamp
1897     uint256 public startTime;
1898 
1899     // bonus change timestamp  
1900     uint256 public bonusChangeTime;
1901 
1902     // ico end timestamp
1903     uint256 public endTime;
1904 
1905     // wallet address to trasfer funding to
1906     address public wallet;
1907 
1908     // tokens sold
1909     uint256 public sold;
1910 
1911     // wei raised
1912     uint256 public raised;
1913 
1914     // unsold tokens amount
1915     uint256 public unsoldTokensAmount;
1916 
1917     // how many tokens are sold before unsold allocation started
1918     uint256 public soldBeforeUnsoldAllocation;
1919 
1920     // counter for funders, who got unsold tokens allocated
1921     uint256 public unsoldAllocationCount;
1922 
1923     // are preICO tokens allocated
1924     bool public preICOTokensAllocated;
1925 
1926     // is unsold tokens allocation scheduled
1927     bool public unsoldAllocatonScheduled;
1928 
1929     // eth/usd rate url
1930     string public ethRateURL = "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd";
1931 
1932     // oraclize gas limit
1933     uint256 public oraclizeGasLimit = 200000;
1934 
1935     // unsold tokens allocation oraclize gas limit
1936     uint256 public unsoldAllocationOraclizeGasLimit = 2500000;
1937 
1938     // three hours delay (from the ico end time) for unsold tokens allocation
1939     uint256 public unsoldAllocationDelay = 10800;
1940 
1941     // addresses authorized to refill the contract (for oraclize queries)
1942     mapping (address => bool) public refillers;
1943 
1944     // minimum funding amount
1945     uint256 public constant MIN_FUNDING_AMOUNT = 0.5 ether;
1946 
1947     // rate exponent
1948     uint256 public constant RATE_EXPONENT = 4;
1949 
1950     // token price, usd
1951     uint256 public constant TOKEN_PRICE = 3;
1952 
1953     // size of unsold tokens allocation bunch
1954     uint256 public constant UNSOLD_ALLOCATION_SIZE = 50; 
1955 
1956     // unsold allocation exponent
1957     uint256 public constant UNSOLD_ALLOCATION_EXPONENT = 10;
1958 
1959     /**
1960      * event for add to whitelist logging
1961      * @param funder funder address
1962      */
1963     event WhitelistAddEvent(address indexed funder);
1964 
1965     /**
1966      * event for funding order logging
1967      * @param funder funder who has done the order
1968      * @param orderId oraclize orderId
1969      * @param funds paid wei amount
1970      */
1971     event OrderEvent(address indexed funder, bytes32 indexed orderId, uint256 funds);
1972 
1973     /**
1974      * event for token purchase logging
1975      * @param funder funder who paid for the tokens
1976      * @param orderId oraclize orderId
1977      * @param tokens amount of tokens purchased
1978      */
1979     event TokenPurchaseEvent(address indexed funder, bytes32 indexed orderId, uint256 tokens);
1980 
1981     /**
1982      * event for unsold tokens allocation logging
1983      * @param funder funder token holders
1984      * @param tokens amount of tokens purchased
1985      */
1986     event UnsoldTokensAllocationEvent(address indexed funder, uint256 tokens);
1987 
1988 
1989     /**
1990      * @dev Constructor
1991      * @param _startTime start time timestamp
1992      * @param _bonusChangeTime bonus change timestamp
1993      * @param _endTime end time timestamp
1994      * @param _wallet wallet address to transfer funding to
1995      * @param _token Betex token address
1996      * @param _betexStorage BetexStorage contract address
1997      */
1998     function BetexICO (
1999         uint256 _startTime,
2000         uint256 _bonusChangeTime,
2001         uint256 _endTime,
2002         address _wallet, 
2003         address _token,
2004         address _betexStorage
2005     ) 
2006         public 
2007         payable
2008     {
2009         require(_startTime < _endTime);
2010         require(_bonusChangeTime > _startTime && _bonusChangeTime < _endTime);
2011 
2012         require(_wallet != address(0));
2013         require(_token != address(0));
2014         require(_betexStorage != address(0));
2015 
2016         startTime = _startTime;
2017         bonusChangeTime = _bonusChangeTime;
2018         endTime = _endTime;
2019         wallet = _wallet;
2020 
2021         token = BetexToken(_token);
2022         betexStorage = BetexStorage(_betexStorage);
2023     }
2024 
2025     // fallback function, used to buy tokens and refill the contract for oraclize
2026     function () public payable {
2027         address _sender = msg.sender;
2028         uint256 _funds = msg.value;
2029 
2030         if (betexStorage.isWhitelisted(_sender)) {
2031             buyTokens(_sender, _funds);
2032         } else if (!refillers[_sender] && !(owner == _sender)) {
2033             revert();
2034         }
2035     }
2036 
2037     /**
2038      * @dev Get current rate from oraclize and transfer tokens or start unsold tokens allocation
2039      * @param _orderId oraclize order id
2040      * @param _result current eth/usd rate
2041      */
2042     function __callback(bytes32 _orderId, string _result) public {  // solium-disable-line mixedcase
2043         require(msg.sender == oraclize_cbAddress());
2044 
2045         // check if it's an order for aftersale token allocation
2046         if (betexStorage.unsoldAllocationOrders(_orderId)) {
2047             if (!allUnsoldTokensAllocated()) {
2048                 allocateUnsoldTokens();
2049                 if (!allUnsoldTokensAllocated()) {
2050                     bytes32 orderId = oraclize_query("URL", ethRateURL, unsoldAllocationOraclizeGasLimit);
2051                     betexStorage.addUnsoldAllocationOrder(orderId);
2052                 }
2053             }
2054         } else {
2055             uint256 _rate = parseInt(_result, RATE_EXPONENT);
2056 
2057             address _beneficiary;
2058             uint256 _funds;
2059             uint256 _bonus;
2060 
2061             (_beneficiary, _funds, _bonus) = betexStorage.getOrder(_orderId);
2062 
2063             uint256 _sum = _funds.mul(_rate).div(10 ** RATE_EXPONENT);
2064             uint256 _tokens = _sum.div(TOKEN_PRICE);
2065 
2066             uint256 _bonusTokens = _tokens.mul(_bonus).div(100);
2067             _tokens = _tokens.add(_bonusTokens);
2068 
2069             if (sold.add(_tokens) > token.SALE_SUPPLY()) {
2070                 _tokens = token.SALE_SUPPLY().sub(sold);
2071             }
2072 
2073             betexStorage.setRateForOrder(_orderId, _rate);
2074 
2075             token.transfer(_beneficiary, _tokens);
2076             sold = sold.add(_tokens);
2077             emit TokenPurchaseEvent(_beneficiary, _orderId, _tokens);
2078         }
2079     }
2080 
2081     // schedule unsold tokens allocation using oraclize
2082     function scheduleUnsoldAllocation() public {
2083         require(!unsoldAllocatonScheduled);
2084 
2085         // query for unsold tokens allocation with delay from the ico end time
2086         bytes32 _orderId = oraclize_query(endTime.add(unsoldAllocationDelay), "URL", ethRateURL, unsoldAllocationOraclizeGasLimit); // solium-disable-line arg-overflow
2087         betexStorage.addUnsoldAllocationOrder(_orderId); 
2088 
2089         unsoldAllocatonScheduled = true;
2090     }
2091 
2092     /**
2093      * @dev Allocate unsold tokens (for bunch of funders)
2094      */
2095     function allocateUnsoldTokens() public {
2096         require(now > endTime.add(unsoldAllocationDelay)); // solium-disable-line security/no-block-members
2097         require(!allUnsoldTokensAllocated());
2098 
2099         // save unsold and sold amounts
2100         if (unsoldAllocationCount == 0) {
2101             unsoldTokensAmount = token.SALE_SUPPLY().sub(sold);
2102             soldBeforeUnsoldAllocation = sold;
2103         }
2104 
2105         for (uint256 i = 0; i < UNSOLD_ALLOCATION_SIZE && !allUnsoldTokensAllocated(); i = i.add(1)) {
2106             address _funder = betexStorage.funders(unsoldAllocationCount);
2107             uint256 _funderTokens = token.balanceOf(_funder);
2108 
2109             if (_funderTokens != 0) {
2110                 uint256 _share = _funderTokens.mul(10 ** UNSOLD_ALLOCATION_EXPONENT).div(soldBeforeUnsoldAllocation);
2111                 uint256 _tokensToAllocate = unsoldTokensAmount.mul(_share).div(10 ** UNSOLD_ALLOCATION_EXPONENT);
2112 
2113                 token.transfer(_funder, _tokensToAllocate); 
2114                 emit UnsoldTokensAllocationEvent(_funder, _tokensToAllocate);
2115                 sold = sold.add(_tokensToAllocate);
2116             }
2117 
2118             unsoldAllocationCount = unsoldAllocationCount.add(1);
2119         }
2120 
2121         if (allUnsoldTokensAllocated()) {
2122             if (sold < token.SALE_SUPPLY()) {
2123                 uint256 _change = token.SALE_SUPPLY().sub(sold);
2124                 address _reserveAddress = token.RESERVE_ADDRESS();
2125                 token.transfer(_reserveAddress, _change);
2126                 sold = sold.add(_change);
2127             }
2128         }           
2129     }
2130 
2131     // allocate preICO tokens
2132     function allocatePreICOTokens() public {
2133         require(!preICOTokensAllocated);
2134 
2135         for (uint256 i = 0; i < betexStorage.getPreICOFundersCount(); i++) {
2136             address _funder = betexStorage.preICOFunders(i);
2137             uint256 _tokens = betexStorage.preICOBalances(_funder);
2138 
2139             token.transfer(_funder, _tokens);
2140             sold = sold.add(_tokens);
2141 
2142             betexStorage.addFunder(_funder);
2143         }
2144         
2145         preICOTokensAllocated = true;
2146     }
2147 
2148     /**
2149      * @dev Whitelist funder's address
2150      * @param _funder funder's address
2151      */
2152     function addToWhitelist(address _funder) onlyOwner public {
2153         require(_funder != address(0));
2154         betexStorage.addToWhitelist(_funder);
2155 
2156         emit WhitelistAddEvent(_funder);
2157     }
2158 
2159     /**
2160      * @dev Set oraclize gas limit
2161      * @param _gasLimit a new oraclize gas limit
2162      */
2163     function setOraclizeGasLimit(uint256 _gasLimit) onlyOwner public {
2164         require(_gasLimit > 0);
2165         oraclizeGasLimit = _gasLimit;
2166     }
2167 
2168     /**
2169      * @dev Set oraclize gas price
2170      * @param _gasPrice a new oraclize gas price
2171      */
2172     function setOraclizeGasPrice(uint256 _gasPrice) onlyOwner public {
2173         require(_gasPrice > 0);
2174         oraclize_setCustomGasPrice(_gasPrice);
2175     }
2176 
2177     /**
2178      * @dev Add a refiller
2179      * @param _refiller address that authorized to refill the contract
2180      */
2181     function addRefiller(address _refiller) onlyOwner public {
2182         require(_refiller != address(0));
2183         refillers[_refiller] = true;
2184     }
2185 
2186     /**
2187      * @dev Withdraw ether from contract
2188      * @param _amount amount to withdraw
2189      */
2190     function withdrawEther(uint256 _amount) onlyOwner public {
2191         require(address(this).balance >= _amount);
2192         owner.transfer(_amount);
2193     }
2194 
2195     /**
2196      * @dev Makes order for tokens purchase
2197      * @param _funder funder who paid for the tokens
2198      * @param _funds amount of the funds
2199      */
2200     function buyTokens(address _funder, uint256 _funds) internal {
2201         require(liveBetexICO());
2202         require(_funds >= MIN_FUNDING_AMOUNT);
2203         require(oraclize_getPrice("URL") <= address(this).balance);
2204         
2205         bytes32 _orderId = oraclize_query("URL", ethRateURL, oraclizeGasLimit);
2206         uint256 _bonus = betexStorage.getBonus(_funds, bonusChangeTime);
2207         betexStorage.addOrder(_orderId, _funder, _funds, _bonus); // solium-disable-line arg-overflow
2208 
2209         wallet.transfer(_funds);
2210         raised = raised.add(_funds);
2211 
2212         betexStorage.addFunder(_funder);
2213 
2214         emit OrderEvent(_funder, _orderId, _funds);
2215     }
2216 
2217     // @return true if all unsold tokens are allocated
2218     function allUnsoldTokensAllocated() internal view returns (bool) {
2219         return unsoldAllocationCount == betexStorage.getFundersCount();
2220     }
2221 
2222     // @return true if the ICO is alive
2223     function liveBetexICO() internal view returns (bool) {
2224         return now >= startTime && now <= endTime && sold < token.SALE_SUPPLY(); // solium-disable-line security/no-block-members
2225     }
2226     
2227 }