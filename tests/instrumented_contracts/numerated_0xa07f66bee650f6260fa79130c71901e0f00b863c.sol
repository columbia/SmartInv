1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
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
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
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
115 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
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
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
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
246     if (_subtractedValue > oldValue) {
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
257 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     hasMintPermission
356     canMint
357     public
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() onlyOwner canMint public returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: node_modules\openzeppelin-solidity\contracts\ownership\HasNoEther.sol
379 
380 /**
381  * @title Contracts that should not own Ether
382  * @author Remco Bloemen <remco@2π.com>
383  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
384  * in the contract, it will allow the owner to reclaim this ether.
385  * @notice Ether can still be sent to this contract by:
386  * calling functions labeled `payable`
387  * `selfdestruct(contract_address)`
388  * mining directly to the contract address
389  */
390 contract HasNoEther is Ownable {
391 
392   /**
393   * @dev Constructor that rejects incoming Ether
394   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
395   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
396   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
397   * we could use assembly to access msg.value.
398   */
399   constructor() public payable {
400     require(msg.value == 0);
401   }
402 
403   /**
404    * @dev Disallows direct send by settings a default function without the `payable` flag.
405    */
406   function() external {
407   }
408 
409   /**
410    * @dev Transfer all Ether held by the contract to the owner.
411    */
412   function reclaimEther() external onlyOwner {
413     owner.transfer(address(this).balance);
414   }
415 }
416 
417 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
418 
419 /**
420  * @title SafeERC20
421  * @dev Wrappers around ERC20 operations that throw on failure.
422  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
423  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
424  */
425 library SafeERC20 {
426   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
427     require(token.transfer(to, value));
428   }
429 
430   function safeTransferFrom(
431     ERC20 token,
432     address from,
433     address to,
434     uint256 value
435   )
436     internal
437   {
438     require(token.transferFrom(from, to, value));
439   }
440 
441   function safeApprove(ERC20 token, address spender, uint256 value) internal {
442     require(token.approve(spender, value));
443   }
444 }
445 
446 // File: node_modules\openzeppelin-solidity\contracts\ownership\CanReclaimToken.sol
447 
448 /**
449  * @title Contracts that should be able to recover tokens
450  * @author SylTi
451  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
452  * This will prevent any accidental loss of tokens.
453  */
454 contract CanReclaimToken is Ownable {
455   using SafeERC20 for ERC20Basic;
456 
457   /**
458    * @dev Reclaim all ERC20Basic compatible tokens
459    * @param token ERC20Basic The address of the token contract
460    */
461   function reclaimToken(ERC20Basic token) external onlyOwner {
462     uint256 balance = token.balanceOf(this);
463     token.safeTransfer(owner, balance);
464   }
465 
466 }
467 
468 // File: node_modules\openzeppelin-solidity\contracts\ownership\HasNoTokens.sol
469 
470 /**
471  * @title Contracts that should not own Tokens
472  * @author Remco Bloemen <remco@2π.com>
473  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
474  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
475  * owner to reclaim the tokens.
476  */
477 contract HasNoTokens is CanReclaimToken {
478 
479  /**
480   * @dev Reject all ERC223 compatible tokens
481   * @param from_ address The address that is transferring the tokens
482   * @param value_ uint256 the amount of the specified token
483   * @param data_ Bytes The data passed from the caller.
484   */
485   function tokenFallback(address from_, uint256 value_, bytes data_) external {
486     from_;
487     value_;
488     data_;
489     revert();
490   }
491 
492 }
493 
494 // File: node_modules\openzeppelin-solidity\contracts\ownership\HasNoContracts.sol
495 
496 /**
497  * @title Contracts that should not own Contracts
498  * @author Remco Bloemen <remco@2π.com>
499  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
500  * of this contract to reclaim ownership of the contracts.
501  */
502 contract HasNoContracts is Ownable {
503 
504   /**
505    * @dev Reclaim ownership of Ownable contracts
506    * @param contractAddr The address of the Ownable to be reclaimed.
507    */
508   function reclaimContract(address contractAddr) external onlyOwner {
509     Ownable contractInst = Ownable(contractAddr);
510     contractInst.transferOwnership(owner);
511   }
512 }
513 
514 // File: node_modules\openzeppelin-solidity\contracts\ownership\NoOwner.sol
515 
516 /**
517  * @title Base contract for contracts that should not own things.
518  * @author Remco Bloemen <remco@2π.com>
519  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
520  * Owned contracts. See respective base contracts for details.
521  */
522 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
523 }
524 
525 // File: contracts\Token.sol
526 
527 contract Token is MintableToken, NoOwner {
528     string public symbol = "TKT";
529     string public name = "Ticket token";
530     uint8 public constant decimals = 18;
531 
532     address founder; //founder address to allow him transfer tokens while minting
533     function init(address _founder) onlyOwner public {
534         founder = _founder;
535     }
536 
537     function getFounder() public returns(address) {
538         return founder;
539     }
540 
541     /**
542      * Allow transfer only after crowdsale finished
543      */
544     modifier canTransfer() {
545         require(mintingFinished || msg.sender == founder);
546         _;
547     }
548 
549     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
550         return super.transfer(_to, _value);
551     }
552 
553     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
554         return super.transferFrom(_from, _to, _value);
555     }
556 }
557 
558 // File: contracts\Crowdsale.sol
559 
560 contract Crowdsale {
561     using SafeMath for uint256;
562 
563     address manager;
564     address owner;
565 
566     uint64 public startTimestamp;   //Crowdsale start timestamp
567     uint64 public endTimestamp;     //Crowdsale end timestamp
568     uint256 public goal;            //minimal amount of sold tokens (if not reached - ETH may be refunded)
569     uint256 public hardCap;         //total amount of tokens available
570     uint256 public rate;            //how many tokens will be minted for 1 ETH
571 
572     uint256 public tokensSold;      //total amount of tokens sold(!) on ICO
573     uint256 public tokensMinted;    //total amount of minted tokens (this includes founder tokens and sold tokens)
574     uint256 public collectedEther;  //total amount of ether collected during ICO
575 
576     mapping(address => uint256) contributions; //amount of ether (in wei)received from a buyer
577 
578     Token public token;
579 
580     bool public finalized;
581 
582     modifier onlyOwner() {
583       require((msg.sender == owner) || (msg.sender == manager));
584       _;
585     }
586 
587     constructor(
588         uint64 _startTimestamp, uint64 _endTimestamp, uint256 _rate,
589         uint256 _founderTokens, uint256 _goal, uint256 _hardCap,
590         address _owner
591         ) public {
592       require(_startTimestamp > now);
593         require(_startTimestamp < _endTimestamp);
594         startTimestamp = _startTimestamp;
595         endTimestamp = _endTimestamp;
596 
597         require(_hardCap > 0);
598         hardCap = _hardCap;
599 
600         goal = _goal;
601 
602         require(_rate > 0);
603         rate = _rate;
604 
605         owner = _owner;
606         manager = msg.sender;
607 
608         token = new Token();
609         token.init(owner);
610 
611         require(_founderTokens < _hardCap);
612         mintTokens(owner, _founderTokens);
613     }
614 
615     /**
616     * @notice Sell tokens directly, without referral bonuses
617     */
618     function () public payable {
619         require(crowdsaleOpen());
620         require(msg.value > 0);
621         collectedEther = collectedEther.add(msg.value);
622         contributions[msg.sender] = contributions[msg.sender].add(msg.value);
623         uint256 amount = getTokensForValue(msg.value);
624         tokensSold = tokensSold.add(amount);
625         mintTokens(msg.sender, amount);
626     }
627 
628     /**
629     * @notice How many tokens one will receive for specified value of Ether
630     * @param value paid
631     * @return amount of tokens
632     */
633     function getTokensForValue(uint256 value) public view returns(uint256) {
634         return value.mul(rate);
635     }
636 
637 
638     /**
639     * @notice If crowdsale is running
640     */
641     function crowdsaleOpen() view public returns(bool) {
642         return !finalized && (tokensMinted < hardCap) && (startTimestamp <= now) && (now <= endTimestamp);
643     }
644 
645     /**
646     * @notice Calculates how many tokens are left to sale
647     * @return amount of tokens left before hard cap reached
648     */
649     function getTokensLeft() view public returns(uint256) {
650         return hardCap.sub(tokensMinted);
651     }
652 
653     /**
654     * @dev Helper function to mint tokens and increase tokensMinted counter
655     */
656     function mintTokens(address beneficiary, uint256 amount) internal {
657         tokensMinted = tokensMinted.add(amount);
658         require(tokensMinted <= hardCap);
659         assert(token.mint(beneficiary, amount));
660     }
661 
662     /**
663     * @notice Sends all contributed ether back if minimum cap is not reached by the end of crowdsale
664     */
665     function refund() public returns(bool) {
666         return refundTo(msg.sender);
667     }
668     function refundTo(address beneficiary) public returns(bool) {
669         require(contributions[beneficiary] > 0);
670         require(finalized || (now > endTimestamp));
671         require(tokensSold < goal);
672 
673         uint256 value = contributions[beneficiary];
674         contributions[beneficiary] = 0;
675         beneficiary.transfer(value);
676         return true;
677     }
678 
679     /**
680     * @notice Closes crowdsale, finishes minting (allowing token transfers), transfers token ownership to the owner
681     */
682     function finalizeCrowdsale() public onlyOwner {
683         finalized = true;
684         token.finishMinting();
685         token.transferOwnership(owner);
686         if (tokensSold >= goal && address(this).balance > 0) {
687             owner.transfer(address(this).balance);
688         }
689     }
690 
691     /**
692     * @notice Claim collected ether without closing crowdsale
693     */
694     function claimEther() public onlyOwner {
695         require(tokensSold >= goal);
696         if (address(this).balance > 0) {
697             owner.transfer(address(this).balance);
698         }
699     }
700 
701 }