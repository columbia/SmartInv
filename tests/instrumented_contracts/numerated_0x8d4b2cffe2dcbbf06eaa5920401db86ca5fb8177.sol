1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 
53 
54 
55 
56 
57 
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 /**
72  * @title SafeERC20
73  * @dev Wrappers around ERC20 operations that throw on failure.
74  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
75  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
76  */
77 library SafeERC20 {
78   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
79     assert(token.transfer(to, value));
80   }
81 
82   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
83     assert(token.transferFrom(from, to, value));
84   }
85 
86   function safeApprove(ERC20 token, address spender, uint256 value) internal {
87     assert(token.approve(spender, value));
88   }
89 }
90 
91 
92 
93 /**
94  * @title CrowdsaleConfig
95  * @dev Holds all constants for SelfKeyCrowdsale contract
96 */
97 contract CrowdsaleConfig {
98     uint256 public constant TOKEN_DECIMALS = 18;
99     uint256 public constant MIN_TOKEN_UNIT = 10 ** uint256(TOKEN_DECIMALS);
100 
101     // Initial distribution amounts
102     uint256 public constant TOTAL_SUPPLY_CAP = 6000000000 * MIN_TOKEN_UNIT;
103 
104     // 33% of the total supply cap
105     uint256 public constant SALE_CAP = 1980000000 * MIN_TOKEN_UNIT;
106 
107     // Minimum cap per purchaser on public sale = $100 in KEY (at $0.015)
108     uint256 public constant PURCHASER_MIN_TOKEN_CAP = 6666 * MIN_TOKEN_UNIT;
109 
110     // Maximum cap per purchaser on first day of public sale = $3,000 in KEY (at $0.015)
111     uint256 public constant PURCHASER_MAX_TOKEN_CAP_DAY1 = 200000 * MIN_TOKEN_UNIT;
112 
113     // Maximum cap per purchaser on public sale = $18,000 in KEY (at $0.015)
114     uint256 public constant PURCHASER_MAX_TOKEN_CAP = 1200000 * MIN_TOKEN_UNIT;
115 
116     // 16.5%
117     uint256 public constant FOUNDATION_POOL_TOKENS = 876666666 * MIN_TOKEN_UNIT;
118     uint256 public constant FOUNDATION_POOL_TOKENS_VESTED = 113333334 * MIN_TOKEN_UNIT;
119 
120     // Approx 33%
121     uint256 public constant COMMUNITY_POOL_TOKENS = 1980000000 * MIN_TOKEN_UNIT;
122 
123     // Founders' distribution. Total = 16.5%
124     uint256 public constant FOUNDERS_TOKENS = 330000000 * MIN_TOKEN_UNIT;
125     uint256 public constant FOUNDERS_TOKENS_VESTED_1 = 330000000 * MIN_TOKEN_UNIT;
126     uint256 public constant FOUNDERS_TOKENS_VESTED_2 = 330000000 * MIN_TOKEN_UNIT;
127 
128     // 1% for legal advisors
129     uint256 public constant LEGAL_EXPENSES_1_TOKENS = 54000000 * MIN_TOKEN_UNIT;
130     uint256 public constant LEGAL_EXPENSES_2_TOKENS = 6000000 * MIN_TOKEN_UNIT;
131 
132     // KEY price in USD (thousandths)
133     uint256 public constant TOKEN_PRICE_THOUSANDTH = 15;  // $0.015 per KEY
134 
135     // Contract wallet addresses for initial allocation
136     address public constant CROWDSALE_WALLET_ADDR = 0xE0831b1687c9faD3447a517F9371E66672505dB0;
137     address public constant FOUNDATION_POOL_ADDR = 0xD68947892Ef4D94Cdef7165b109Cf6Cd3f58A8e8;
138     address public constant FOUNDATION_POOL_ADDR_VEST = 0xd0C24Bb82e71A44eA770e84A3c79979F9233308D;
139     address public constant COMMUNITY_POOL_ADDR = 0x0506c5485AE54aB14C598Ef16C459409E5d8Fc03;
140     address public constant FOUNDERS_POOL_ADDR = 0x4452d6454e777743a5Ee233fbe873055008fF528;
141     address public constant LEGAL_EXPENSES_ADDR_1 = 0xb57911380F13A0a9a6Ba6562248674B5f56D7BFE;
142     address public constant LEGAL_EXPENSES_ADDR_2 = 0x9be281CdcF34B3A01468Ad1008139410Ba5BB2fB;
143 
144     // 6 months period, in seconds, for pre-commitment half-vesting
145     uint64 public constant PRECOMMITMENT_VESTING_SECONDS = 15552000;
146 }
147 
148 
149 
150 /**
151  * @title Ownable
152  * @dev The Ownable contract has an owner address, and provides basic authorization control
153  * functions, this simplifies the implementation of "user permissions".
154  */
155 contract Ownable {
156   address public owner;
157 
158 
159   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161 
162   /**
163    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164    * account.
165    */
166   function Ownable() public {
167     owner = msg.sender;
168   }
169 
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) public onlyOwner {
185     require(newOwner != address(0));
186     OwnershipTransferred(owner, newOwner);
187     owner = newOwner;
188   }
189 
190 }
191 
192 
193 
194 
195 
196 
197 
198 
199 
200 
201 
202 
203 
204 
205 
206 /**
207  * @title Basic token
208  * @dev Basic version of StandardToken, with no allowances.
209  */
210 contract BasicToken is ERC20Basic {
211   using SafeMath for uint256;
212 
213   mapping(address => uint256) balances;
214 
215   /**
216   * @dev transfer token for a specified address
217   * @param _to The address to transfer to.
218   * @param _value The amount to be transferred.
219   */
220   function transfer(address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[msg.sender]);
223 
224     // SafeMath.sub will throw if there is not enough balance.
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     Transfer(msg.sender, _to, _value);
228     return true;
229   }
230 
231   /**
232   * @dev Gets the balance of the specified address.
233   * @param _owner The address to query the the balance of.
234   * @return An uint256 representing the amount owned by the passed address.
235   */
236   function balanceOf(address _owner) public view returns (uint256 balance) {
237     return balances[_owner];
238   }
239 
240 }
241 
242 
243 
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * @dev https://github.com/ethereum/EIPs/issues/20
250  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
251  */
252 contract StandardToken is ERC20, BasicToken {
253 
254   mapping (address => mapping (address => uint256)) internal allowed;
255 
256 
257   /**
258    * @dev Transfer tokens from one address to another
259    * @param _from address The address which you want to send tokens from
260    * @param _to address The address which you want to transfer to
261    * @param _value uint256 the amount of tokens to be transferred
262    */
263   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
264     require(_to != address(0));
265     require(_value <= balances[_from]);
266     require(_value <= allowed[_from][msg.sender]);
267 
268     balances[_from] = balances[_from].sub(_value);
269     balances[_to] = balances[_to].add(_value);
270     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271     Transfer(_from, _to, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277    *
278    * Beware that changing an allowance with this method brings the risk that someone may use both the old
279    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282    * @param _spender The address which will spend the funds.
283    * @param _value The amount of tokens to be spent.
284    */
285   function approve(address _spender, uint256 _value) public returns (bool) {
286     allowed[msg.sender][_spender] = _value;
287     Approval(msg.sender, _spender, _value);
288     return true;
289   }
290 
291   /**
292    * @dev Function to check the amount of tokens that an owner allowed to a spender.
293    * @param _owner address The address which owns the funds.
294    * @param _spender address The address which will spend the funds.
295    * @return A uint256 specifying the amount of tokens still available for the spender.
296    */
297   function allowance(address _owner, address _spender) public view returns (uint256) {
298     return allowed[_owner][_spender];
299   }
300 
301   /**
302    * @dev Increase the amount of tokens that an owner allowed to a spender.
303    *
304    * approve should be called when allowed[_spender] == 0. To increment
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _addedValue The amount of tokens to increase the allowance by.
310    */
311   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
312     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
313     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317   /**
318    * @dev Decrease the amount of tokens that an owner allowed to a spender.
319    *
320    * approve should be called when allowed[_spender] == 0. To decrement
321    * allowed value is better to use this function to avoid 2 calls (and wait until
322    * the first transaction is mined)
323    * From MonolithDAO Token.sol
324    * @param _spender The address which will spend the funds.
325    * @param _subtractedValue The amount of tokens to decrease the allowance by.
326    */
327   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
328     uint oldValue = allowed[msg.sender][_spender];
329     if (_subtractedValue > oldValue) {
330       allowed[msg.sender][_spender] = 0;
331     } else {
332       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333     }
334     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338 }
339 
340 
341 
342 
343 
344 /**
345  * @title Mintable token
346  * @dev Simple ERC20 Token example, with mintable token creation
347  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
348  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
349  */
350 
351 contract MintableToken is StandardToken, Ownable {
352   event Mint(address indexed to, uint256 amount);
353   event MintFinished();
354 
355   bool public mintingFinished = false;
356 
357 
358   modifier canMint() {
359     require(!mintingFinished);
360     _;
361   }
362 
363   /**
364    * @dev Function to mint tokens
365    * @param _to The address that will receive the minted tokens.
366    * @param _amount The amount of tokens to mint.
367    * @return A boolean that indicates if the operation was successful.
368    */
369   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
370     totalSupply = totalSupply.add(_amount);
371     balances[_to] = balances[_to].add(_amount);
372     Mint(_to, _amount);
373     Transfer(address(0), _to, _amount);
374     return true;
375   }
376 
377   /**
378    * @dev Function to stop minting new tokens.
379    * @return True if the operation was successful.
380    */
381   function finishMinting() onlyOwner canMint public returns (bool) {
382     mintingFinished = true;
383     MintFinished();
384     return true;
385   }
386 }
387 
388 /* solhint-disable not-rely-on-time */
389 
390 
391 
392 
393 
394 
395 
396 
397 
398 /**
399  * @title SelfKeyToken
400  * @dev SelfKey Token implementation.
401  */
402 contract SelfKeyToken is MintableToken {
403     string public constant name = 'SelfKey'; //solhint-disable-line const-name-snakecase
404     string public constant symbol = 'KEY'; //solhint-disable-line const-name-snakecase
405     uint256 public constant decimals = 18; //solhint-disable-line const-name-snakecase
406 
407     uint256 public cap;
408     bool private transfersEnabled = false;
409 
410     event Burned(address indexed burner, uint256 value);
411 
412     /**
413      * @dev Only the contract owner can transfer without restrictions.
414      *      Regular holders need to wait until sale is finalized.
415      * @param _sender — The address sending the tokens
416      * @param _value — The number of tokens to send
417      */
418     modifier canTransfer(address _sender, uint256 _value) {
419         require(transfersEnabled || _sender == owner);
420         _;
421     }
422 
423     /**
424      * @dev Constructor that sets a maximum supply cap.
425      * @param _cap — The maximum supply cap.
426      */
427     function SelfKeyToken(uint256 _cap) public {
428         cap = _cap;
429     }
430 
431     /**
432      * @dev Overrides MintableToken.mint() for restricting supply under cap
433      * @param _to — The address to receive minted tokens
434      * @param _value — The number of tokens to mint
435      */
436     function mint(address _to, uint256 _value) public onlyOwner canMint returns (bool) {
437         require(totalSupply.add(_value) <= cap);
438         return super.mint(_to, _value);
439     }
440 
441     /**
442      * @dev Checks modifier and allows transfer if tokens are not locked.
443      * @param _to — The address to receive tokens
444      * @param _value — The number of tokens to send
445      */
446     function transfer(address _to, uint256 _value)
447         public canTransfer(msg.sender, _value) returns (bool)
448     {
449         return super.transfer(_to, _value);
450     }
451 
452     /**
453      * @dev Checks modifier and allows transfer if tokens are not locked.
454      * @param _from — The address to send tokens from
455      * @param _to — The address to receive tokens
456      * @param _value — The number of tokens to send
457      */
458     function transferFrom(address _from, address _to, uint256 _value)
459         public canTransfer(_from, _value) returns (bool)
460     {
461         return super.transferFrom(_from, _to, _value);
462     }
463 
464     /**
465      * @dev Enables token transfers.
466      *      Called when the token sale is successfully finalized
467      */
468     function enableTransfers() public onlyOwner {
469         transfersEnabled = true;
470     }
471 
472     /**
473     * @dev Burns a specific number of tokens.
474     * @param _value — The number of tokens to be burned.
475     */
476     function burn(uint256 _value) public onlyOwner {
477         require(_value > 0);
478 
479         address burner = msg.sender;
480         balances[burner] = balances[burner].sub(_value);
481         totalSupply = totalSupply.sub(_value);
482         Burned(burner, _value);
483     }
484 }
485 
486 
487 
488 
489 
490 
491 
492 
493 
494 
495 
496 
497 /**
498  * @title TokenTimelock
499  * @dev TokenTimelock is a token holder contract that will allow a
500  * beneficiary to extract the tokens after a given release time
501  */
502 contract TokenTimelock {
503   using SafeERC20 for ERC20Basic;
504 
505   // ERC20 basic token contract being held
506   ERC20Basic public token;
507 
508   // beneficiary of tokens after they are released
509   address public beneficiary;
510 
511   // timestamp when token release is enabled
512   uint256 public releaseTime;
513 
514   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
515     require(_releaseTime > now);
516     token = _token;
517     beneficiary = _beneficiary;
518     releaseTime = _releaseTime;
519   }
520 
521   /**
522    * @notice Transfers tokens held by timelock to beneficiary.
523    */
524   function release() public {
525     require(now >= releaseTime);
526 
527     uint256 amount = token.balanceOf(this);
528     require(amount > 0);
529 
530     token.safeTransfer(beneficiary, amount);
531   }
532 }
533 
534 
535 
536 
537 
538 
539 /**
540  * @title RefundVault
541  * @dev This contract is used for storing funds while a crowdsale
542  * is in progress. Supports refunding the money if crowdsale fails,
543  * and forwarding it if crowdsale is successful.
544  */
545 contract RefundVault is Ownable {
546   using SafeMath for uint256;
547 
548   enum State { Active, Refunding, Closed }
549 
550   mapping (address => uint256) public deposited;
551   address public wallet;
552   State public state;
553 
554   event Closed();
555   event RefundsEnabled();
556   event Refunded(address indexed beneficiary, uint256 weiAmount);
557 
558   function RefundVault(address _wallet) public {
559     require(_wallet != address(0));
560     wallet = _wallet;
561     state = State.Active;
562   }
563 
564   function deposit(address investor) onlyOwner public payable {
565     require(state == State.Active);
566     deposited[investor] = deposited[investor].add(msg.value);
567   }
568 
569   function close() onlyOwner public {
570     require(state == State.Active);
571     state = State.Closed;
572     Closed();
573     wallet.transfer(this.balance);
574   }
575 
576   function enableRefunds() onlyOwner public {
577     require(state == State.Active);
578     state = State.Refunding;
579     RefundsEnabled();
580   }
581 
582   function refund(address investor) public {
583     require(state == State.Refunding);
584     uint256 depositedValue = deposited[investor];
585     deposited[investor] = 0;
586     investor.transfer(depositedValue);
587     Refunded(investor, depositedValue);
588   }
589 }
590 
591 
592 
593 /**
594  * @title SelfKeyCrowdsale
595  * @dev SelfKey Token Crowdsale implementation.
596  */
597 // solhint-disable-next-line max-states-count
598 contract SelfKeyCrowdsale is Ownable, CrowdsaleConfig {
599     using SafeMath for uint256;
600     using SafeERC20 for SelfKeyToken;
601 
602     // whitelist of addresses that can perform precommitments and KYC verifications
603     mapping(address => bool) public isVerifier;
604 
605     // Token contract
606     SelfKeyToken public token;
607 
608     uint64 public startTime;
609     uint64 public endTime;
610 
611     // Minimum tokens expected to sell
612     uint256 public goal;
613 
614     // How many tokens a buyer gets per ETH
615     uint256 public rate = 51800;
616 
617     // ETH price in USD, can be later updated until start date
618     uint256 public ethPrice = 777;
619 
620     // Total amount of tokens purchased, including pre-sale
621     uint256 public totalPurchased = 0;
622 
623     mapping(address => bool) public kycVerified;
624     mapping(address => uint256) public tokensPurchased;
625 
626     // a mapping of dynamically instantiated token timelocks for each pre-commitment beneficiary
627     mapping(address => address) public vestedTokens;
628 
629     bool public isFinalized = false;
630 
631     // Token Timelocks
632     TokenTimelock public foundersTimelock1;
633     TokenTimelock public foundersTimelock2;
634     TokenTimelock public foundationTimelock;
635 
636     // Vault to hold funds until crowdsale is finalized. Allows refunding if crowdsale is not successful.
637     RefundVault public vault;
638 
639     // Crowdsale events
640     event TokenPurchase(
641         address indexed purchaser,
642         address indexed beneficiary,
643         uint256 value,
644         uint256 amount
645     );
646 
647     event VerifiedKYC(address indexed participant);
648 
649     event AddedPrecommitment(
650         address indexed participant,
651         uint256 tokensAllocated
652     );
653 
654     event Finalized();
655 
656     modifier verifierOnly() {
657         require(isVerifier[msg.sender]);
658         _;
659     }
660 
661     /**
662      * @dev Crowdsale contract constructor
663      * @param _startTime — Unix timestamp representing the crowdsale start time
664      * @param _endTime — Unix timestamp representing the crowdsale start time
665      * @param _goal — Minimum amount of tokens expected to sell.
666      */
667     function SelfKeyCrowdsale(
668         uint64 _startTime,
669         uint64 _endTime,
670         uint256 _goal
671     ) public
672     {
673         require(_endTime > _startTime);
674 
675         // sets contract owner as a verifier
676         isVerifier[msg.sender] = true;
677 
678         token = new SelfKeyToken(TOTAL_SUPPLY_CAP);
679 
680         // mints all possible tokens to the crowdsale contract
681         token.mint(address(this), TOTAL_SUPPLY_CAP);
682         token.finishMinting();
683 
684         startTime = _startTime;
685         endTime = _endTime;
686         goal = _goal;
687 
688         vault = new RefundVault(CROWDSALE_WALLET_ADDR);
689 
690         // Set timelocks to 6 months and a year after startTime, respectively
691         uint64 sixMonthLock = uint64(startTime + 15552000);
692         uint64 yearLock = uint64(startTime + 31104000);
693 
694         // Instantiation of token timelocks
695         foundersTimelock1 = new TokenTimelock(token, FOUNDERS_POOL_ADDR, sixMonthLock);
696         foundersTimelock2 = new TokenTimelock(token, FOUNDERS_POOL_ADDR, yearLock);
697         foundationTimelock = new TokenTimelock(token, FOUNDATION_POOL_ADDR_VEST, yearLock);
698 
699         // Genesis allocation of tokens
700         token.safeTransfer(FOUNDATION_POOL_ADDR, FOUNDATION_POOL_TOKENS);
701         token.safeTransfer(COMMUNITY_POOL_ADDR, COMMUNITY_POOL_TOKENS);
702         token.safeTransfer(FOUNDERS_POOL_ADDR, FOUNDERS_TOKENS);
703         token.safeTransfer(LEGAL_EXPENSES_ADDR_1, LEGAL_EXPENSES_1_TOKENS);
704         token.safeTransfer(LEGAL_EXPENSES_ADDR_2, LEGAL_EXPENSES_2_TOKENS);
705 
706         // Allocation of vested tokens
707         token.safeTransfer(foundersTimelock1, FOUNDERS_TOKENS_VESTED_1);
708         token.safeTransfer(foundersTimelock2, FOUNDERS_TOKENS_VESTED_2);
709         token.safeTransfer(foundationTimelock, FOUNDATION_POOL_TOKENS_VESTED);
710     }
711 
712     /**
713      * @dev Fallback function is used to buy tokens.
714      *      It's the only entry point since `buyTokens` is internal
715      */
716     function () public payable {
717         buyTokens(msg.sender);
718     }
719 
720     /**
721      * @dev Adds an address to the whitelist of Verifiers
722      * @param _address - address of the verifier
723      */
724     function addVerifier (address _address) public onlyOwner {
725         isVerifier[_address] = true;
726     }
727 
728     /**
729      * @dev Removes an address from the whitelist of Verifiers
730      * @param _address - address of the verifier to be removed
731      */
732     function removeVerifier (address _address) public onlyOwner {
733         isVerifier[_address] = false;
734     }
735 
736     /**
737      * @dev Sets a new start date as long as token hasn't started yet
738      * @param _startTime - unix timestamp of the new start time
739      */
740     function setStartTime (uint64 _startTime) public onlyOwner {
741         require(now < startTime);
742         require(_startTime > now);
743         require(_startTime < endTime);
744 
745         startTime = _startTime;
746     }
747 
748     /**
749      * @dev Sets a new end date as long as end date hasn't been reached
750      * @param _endTime - unix timestamp of the new end time
751      */
752     function setEndTime (uint64 _endTime) public onlyOwner {
753         require(now < endTime);
754         require(_endTime > now);
755         require(_endTime > startTime);
756 
757         endTime = _endTime;
758     }
759 
760     /**
761      * @dev Updates the ETH/USD conversion rate as long as the public sale hasn't started
762      * @param _ethPrice - Updated conversion rate
763      */
764     function setEthPrice(uint256 _ethPrice) public onlyOwner {
765         require(now < startTime);
766         require(_ethPrice > 0);
767 
768         ethPrice = _ethPrice;
769         rate = ethPrice.mul(1000).div(TOKEN_PRICE_THOUSANDTH);
770     }
771 
772     /**
773      * @dev Must be called after crowdsale ends, to do some extra finalization
774      *      work. Calls the contract's finalization function.
775      */
776     function finalize() public onlyOwner {
777         require(now > startTime);
778         require(!isFinalized);
779 
780         finalization();
781         Finalized();
782 
783         isFinalized = true;
784     }
785 
786     /**
787      * @dev If crowdsale is unsuccessful, a refund can be claimed back
788      */
789     function claimRefund(address participant) public {
790         // requires sale to be finalized and goal not reached,
791         require(isFinalized);
792         require(!goalReached());
793 
794         vault.refund(participant);
795     }
796 
797     /**
798      * @dev If crowdsale is unsuccessful, participants can claim refunds
799      */
800     function goalReached() public constant returns (bool) {
801         return totalPurchased >= goal;
802     }
803 
804     /**
805      * @dev Release time-locked tokens
806      */
807     function releaseLockFounders1() public {
808         foundersTimelock1.release();
809     }
810 
811     function releaseLockFounders2() public {
812         foundersTimelock2.release();
813     }
814 
815     function releaseLockFoundation() public {
816         foundationTimelock.release();
817     }
818 
819     /**
820      * @dev Release time-locked tokens for any vested address
821      */
822     function releaseLock(address participant) public {
823         require(vestedTokens[participant] != 0x0);
824 
825         TokenTimelock timelock = TokenTimelock(vestedTokens[participant]);
826         timelock.release();
827     }
828 
829     /**
830      * @dev Verifies KYC for given participant.
831      *      This enables token purchases by the participant addres
832      */
833     function verifyKYC(address participant) public verifierOnly {
834         kycVerified[participant] = true;
835 
836         VerifiedKYC(participant);
837     }
838 
839     /**
840      * @dev Adds an address for pre-sale commitments made off-chain.
841      * @param beneficiary — Address of the already verified participant
842      * @param tokensAllocated — Exact amount of KEY tokens (including decimal places) to allocate
843      * @param halfVesting — determines whether the half the tokens will be time-locked or not
844      */
845     function addPrecommitment(
846         address beneficiary,
847         uint256 tokensAllocated,
848         bool halfVesting
849     ) public verifierOnly
850     {
851         // requires to be on pre-sale
852         require(now < startTime); // solhint-disable-line not-rely-on-time
853 
854         kycVerified[beneficiary] = true;
855 
856         uint256 tokens = tokensAllocated;
857         totalPurchased = totalPurchased.add(tokens);
858         tokensPurchased[beneficiary] = tokensPurchased[beneficiary].add(tokens);
859 
860         if (halfVesting) {
861             // half the tokens are put into a time-lock for a pre-defined period
862             uint64 endTimeLock = uint64(startTime + PRECOMMITMENT_VESTING_SECONDS);
863 
864             // Sets a timelock for half the tokens allocated
865             uint256 half = tokens.div(2);
866             TokenTimelock timelock;
867 
868             if (vestedTokens[beneficiary] == 0x0) {
869                 timelock = new TokenTimelock(token, beneficiary, endTimeLock);
870                 vestedTokens[beneficiary] = address(timelock);
871             } else {
872                 timelock = TokenTimelock(vestedTokens[beneficiary]);
873             }
874 
875             token.safeTransfer(beneficiary, half);
876             token.safeTransfer(timelock, tokens.sub(half));
877         } else {
878             // all tokens are sent to the participant's address
879             token.safeTransfer(beneficiary, tokens);
880         }
881 
882         AddedPrecommitment(
883             beneficiary,
884             tokens
885         );
886     }
887 
888     /**
889      * @dev Additional finalization logic. Enables token transfers.
890      */
891     function finalization() internal {
892         if (goalReached()) {
893             burnUnsold();
894             vault.close();
895             token.enableTransfers();
896         } else {
897             vault.enableRefunds();
898         }
899     }
900 
901     /**
902      *  @dev Low level token purchase. Only callable internally. Participants MUST be KYC-verified before purchase
903      *  @param participant — The address of the token purchaser
904      */
905     function buyTokens(address participant) internal {
906         require(kycVerified[participant]);
907         require(now >= startTime);
908         require(now < endTime);
909         require(!isFinalized);
910         require(msg.value != 0);
911 
912         // Calculate the token amount to be allocated
913         uint256 weiAmount = msg.value;
914         uint256 tokens = weiAmount.mul(rate);
915 
916         // Update state
917         tokensPurchased[participant] = tokensPurchased[participant].add(tokens);
918         totalPurchased = totalPurchased.add(tokens);
919 
920         require(totalPurchased <= SALE_CAP);
921         require(tokensPurchased[participant] >= PURCHASER_MIN_TOKEN_CAP);
922 
923         if (now < startTime + 86400) {
924             // if still during the first day of token sale, apply different max cap
925             require(tokensPurchased[participant] <= PURCHASER_MAX_TOKEN_CAP_DAY1);
926         } else {
927             require(tokensPurchased[participant] <= PURCHASER_MAX_TOKEN_CAP);
928         }
929 
930         // Sends ETH contribution to the RefundVault and tokens to participant
931         vault.deposit.value(msg.value)(participant);
932         token.safeTransfer(participant, tokens);
933 
934         TokenPurchase(
935             msg.sender,
936             participant,
937             weiAmount,
938             tokens
939         );
940     }
941 
942     /**
943      * @dev Burn all remaining (unsold) tokens.
944      *      This should be called after sale finalization
945      */
946     function burnUnsold() internal {
947         // All tokens held by this contract get burned
948         token.burn(token.balanceOf(this));
949     }
950 }