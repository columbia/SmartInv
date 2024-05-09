1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Controller
6  */
7 contract Controller {
8 
9   /// @notice Called when `_owner` sends ether to the token contract
10   /// @param _owner The address that sent the ether to create tokens
11   /// @return True if the ether is accepted, false if it throws
12   function proxyPayment(address _owner) payable returns(bool);
13 
14   /// @notice Notifies the controller about a token transfer allowing the
15   ///  controller to react if desired
16   /// @param _from The origin of the transfer
17   /// @param _to The destination of the transfer
18   /// @param _amount The amount of the transfer
19   /// @return False if the controller does not authorize the transfer
20   function onTransfer(address _from, address _to, uint _amount) returns(bool);
21 
22   /// @notice Notifies the controller about an approval allowing the
23   ///  controller to react if desired
24   /// @param _owner The address that calls `approve()`
25   /// @param _spender The spender in the `approve()` call
26   /// @param _amount The amount in the `approve()` call
27   /// @return False if the controller does not authorize the approval
28   function onApprove(address _owner, address _spender, uint _amount) returns(bool);
29 }
30 
31 /**
32  * Math operations with safety checks
33  */
34 library SafeMath {
35 
36   function mul(uint a, uint b) internal returns (uint) {
37     uint c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint a, uint b) internal returns (uint) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint a, uint b) internal returns (uint) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint a, uint b) internal returns (uint) {
55     uint c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 
60   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
61     return a >= b ? a : b;
62   }
63 
64   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
65     return a < b ? a : b;
66   }
67 
68   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
69     return a >= b ? a : b;
70   }
71 
72   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
73     return a < b ? a : b;
74   }
75 
76   function assert(bool assertion) internal {
77     if (!assertion) {
78       throw;
79     }
80   }
81 }
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89 
90   address public owner;
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   function Ownable() {
97     owner = msg.sender;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     if (msg.sender != owner) {
105       throw;
106     }
107     _;
108   }
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address newOwner) onlyOwner {
115     if (newOwner != address(0)) {
116       owner = newOwner;
117     }
118   }
119 }
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20Basic {
127   uint public totalSupply;
128   function balanceOf(address who) constant returns (uint);
129   function transfer(address to, uint value);
130   event Transfer(address indexed from, address indexed to, uint value);
131 }
132 
133 /**
134  * @title Contracts that should not own Tokens
135  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
136  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
137  * owner to reclaim the tokens.
138  */
139 contract HasNoTokens is Ownable {
140 
141  /**
142   * @dev Reject all ERC23 compatible tokens
143   * @param from_ address The address that is transferring the tokens
144   * @param value_ Uint the amount of the specified token
145   * @param data_ Bytes The data passed from the caller.
146   */
147   function tokenFallback(address from_, uint value_, bytes data_) external {
148     throw;
149   }
150 
151   /**
152    * @dev Reclaim all ERC20Basic compatible tokens
153    * @param tokenAddr address The address of the token contract
154    */
155   function reclaimToken(address tokenAddr) external onlyOwner {
156     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
157     uint256 balance = tokenInst.balanceOf(this);
158     tokenInst.transfer(owner, balance);
159   }
160 }
161 
162 // @dev Contract to hold ETH raised during a token sale.
163 // Prevents attack in which the Multisig sends raised ether to the
164 // sale contract to mint tokens to itself, and getting the
165 // funds back immediately.
166 contract AbstractSale {
167   function saleFinalized() constant returns (bool);
168 }
169 
170 contract Escrow is HasNoTokens {
171 
172   address public beneficiary;
173   uint public finalBlock;
174   AbstractSale public tokenSale;
175 
176   // @dev Constructor initializes public variables
177   // @param _beneficiary The address of the multisig that will receive the funds
178   // @param _finalBlock Block after which the beneficiary can request the funds
179   function Escrow(address _beneficiary, uint _finalBlock, address _tokenSale) {
180     beneficiary = _beneficiary;
181     finalBlock = _finalBlock;
182     tokenSale = AbstractSale(_tokenSale);
183   }
184 
185   // @dev Receive all sent funds without any further logic
186   function() public payable {}
187 
188   // @dev Withdraw function sends all the funds to the wallet if conditions are correct
189   function withdraw() public {
190     if (msg.sender != beneficiary) throw;
191     if (block.number > finalBlock) return doWithdraw();
192     if (tokenSale.saleFinalized()) return doWithdraw();
193   }
194 
195   function doWithdraw() internal {
196     if (!beneficiary.send(this.balance)) throw;
197   }
198 }
199 
200 /**
201  * @title Basic token
202  * @dev Basic version of StandardToken, with no allowances.
203  */
204 contract BasicToken is ERC20Basic {
205   using SafeMath for uint;
206 
207   mapping (address => uint) balances;
208 
209   /**
210    * @dev Fix for the ERC20 short address attack.
211    */
212   modifier onlyPayloadSize(uint size) {
213      if(msg.data.length < size + 4) {
214        throw;
215      }
216      _;
217   }
218 
219   /**
220   * @dev transfer token for a specified address
221   * @param _to The address to transfer to.
222   * @param _value The amount to be transferred.
223   */
224   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     Transfer(msg.sender, _to, _value);
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) constant returns (uint balance) {
236     return balances[_owner];
237   }
238 }
239 
240 /**
241  * @title ERC20 interface
242  * @dev see https://github.com/ethereum/EIPs/issues/20
243  */
244 contract ERC20 is ERC20Basic {
245   function allowance(address owner, address spender) constant returns (uint);
246   function transferFrom(address from, address to, uint value);
247   function approve(address spender, uint value);
248   event Approval(address indexed owner, address indexed spender, uint value);
249 }
250 
251 /**
252  * @title Standard ERC20 token
253  *
254  * @dev Implemantation of the basic standart token.
255  * @dev https://github.com/ethereum/EIPs/issues/20
256  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
257  */
258 contract StandardToken is BasicToken, ERC20 {
259 
260   mapping (address => mapping (address => uint)) allowed;
261 
262   /**
263    * @dev Transfer tokens from one address to another
264    * @param _from address The address which you want to send tokens from
265    * @param _to address The address which you want to transfer to
266    * @param _value uint the amout of tokens to be transfered
267    */
268   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
269     var _allowance = allowed[_from][msg.sender];
270     balances[_to] = balances[_to].add(_value);
271     balances[_from] = balances[_from].sub(_value);
272     allowed[_from][msg.sender] = _allowance.sub(_value);
273     Transfer(_from, _to, _value);
274   }
275 
276   /**
277    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
278    * @param _spender The address which will spend the funds.
279    * @param _value The amount of tokens to be spent.
280    */
281   function approve(address _spender, uint _value) {
282     // To change the approve amount you first have to reduce the addresses`
283     //  allowance to zero by calling `approve(_spender, 0)` if it is not
284     //  already 0 to mitigate the race condition described here:
285     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
287     allowed[msg.sender][_spender] = _value;
288     Approval(msg.sender, _spender, _value);
289   }
290 
291   /**
292    * @dev Function to check the amount of tokens than an owner allowed to a spender.
293    * @param _owner address The address which owns the funds.
294    * @param _spender address The address which will spend the funds.
295    * @return A uint specifing the amount of tokens still avaible for the spender.
296    */
297   function allowance(address _owner, address _spender) constant returns (uint remaining) {
298     return allowed[_owner][_spender];
299   }
300 }
301 
302 /**
303  * Controlled
304  */
305 contract Controlled {
306 
307   address public controller;
308 
309   function Controlled() {
310     controller = msg.sender;
311   }
312 
313   function changeController(address _controller) onlyController {
314     controller = _controller;
315   }
316 
317   modifier onlyController {
318     if (msg.sender != controller) throw;
319     _;
320   }
321 }
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  */
327 contract MintableToken is StandardToken, Controlled {
328 
329   event Mint(address indexed to, uint value);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333   uint public totalSupply = 0;
334 
335   /**
336    * @dev Function to mint tokens
337    * @param _to The address that will recieve the minted tokens.
338    * @param _amount The amount of tokens to mint.
339    * @return A boolean that indicates if the operation was successful.
340    */
341   function mint(address _to, uint _amount) onlyController canMint returns (bool) {
342     totalSupply = totalSupply.add(_amount);
343     balances[_to] = balances[_to].add(_amount);
344     Mint(_to, _amount);
345     return true;
346   }
347 
348   /**
349    * @dev Function to stop minting new tokens.
350    * @return True if the operation was successful.
351    */
352   function finishMinting() onlyController returns (bool) {
353     mintingFinished = true;
354     MintFinished();
355     return true;
356   }
357 
358   modifier canMint() {
359     if (mintingFinished) throw;
360     _;
361   }
362 }
363 
364 /**
365  * @title LimitedTransferToken
366  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
367  * transferability for different events. It is intended to be used as a base class for other token
368  * contracts.
369  * LimitedTransferToken has been designed to allow for different limiting factors,
370  * this can be achieved by recursively calling super.transferableTokens() until the base class is
371  * hit. For example:
372  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
373  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
374  *     }
375  * A working example is VestedToken.sol:
376  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
377  */
378 contract LimitedTransferToken is ERC20 {
379 
380   /**
381    * @dev Checks whether it can transfer or otherwise throws.
382    */
383   modifier canTransfer(address _sender, uint _value) {
384    if (_value > transferableTokens(_sender, uint64(now))) throw;
385    _;
386   }
387 
388   /**
389    * @dev Checks modifier and allows transfer if tokens are not locked.
390    * @param _to The address that will recieve the tokens.
391    * @param _value The amount of tokens to be transferred.
392    */
393   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
394     super.transfer(_to, _value);
395   }
396 
397   /**
398   * @dev Checks modifier and allows transfer if tokens are not locked.
399   * @param _from The address that will send the tokens.
400   * @param _to The address that will recieve the tokens.
401   * @param _value The amount of tokens to be transferred.
402   */
403   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
404     super.transferFrom(_from, _to, _value);
405   }
406 
407   /**
408    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
409    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
410    * specific logic for limiting token transferability for a holder over time.
411    */
412   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
413     return balanceOf(holder);
414   }
415 }
416 
417 /**
418  * @title Vested token
419  * @dev Tokens that can be vested for a group of addresses.
420  */
421 contract VestedToken is StandardToken, LimitedTransferToken {
422 
423   uint256 MAX_GRANTS_PER_ADDRESS = 20;
424 
425   struct TokenGrant {
426     address granter;     // 20 bytes
427     uint256 value;       // 32 bytes
428     uint64 cliff;
429     uint64 vesting;
430     uint64 start;        // 3 * 8 = 24 bytes
431     bool revokable;
432     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
433   } // total 78 bytes = 3 sstore per operation (32 per sstore)
434 
435   mapping (address => TokenGrant[]) public grants;
436 
437   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
438 
439   /**
440    * @dev Grant tokens to a specified address
441    * @param _to address The address which the tokens will be granted to.
442    * @param _value uint256 The amount of tokens to be granted.
443    * @param _start uint64 Time of the beginning of the grant.
444    * @param _cliff uint64 Time of the cliff period.
445    * @param _vesting uint64 The vesting period.
446    * @param _revokable bool If the grant is revokable.
447    * @param _burnsOnRevoke bool When true, the tokens are burned if revoked.
448    */
449   function grantVestedTokens(
450     address _to,
451     uint256 _value,
452     uint64 _start,
453     uint64 _cliff,
454     uint64 _vesting,
455     bool _revokable,
456     bool _burnsOnRevoke
457   ) public {
458 
459     // Check for date inconsistencies that may cause unexpected behavior
460     if (_cliff < _start || _vesting < _cliff) {
461       throw;
462     }
463 
464     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;  // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
465 
466     uint count = grants[_to].push(
467                 TokenGrant(
468                   _revokable ? msg.sender : 0,  // avoid storing an extra 20 bytes when it is non-revokable
469                   _value,
470                   _cliff,
471                   _vesting,
472                   _start,
473                   _revokable,
474                   _burnsOnRevoke
475                 )
476               );
477     transfer(_to, _value);
478     NewTokenGrant(msg.sender, _to, _value, count - 1);
479   }
480 
481   /**
482    * @dev Revoke the grant of tokens of a specifed address.
483    * @param _holder The address which will have its tokens revoked.
484    * @param _grantId The id of the token grant.
485    */
486   function revokeTokenGrant(address _holder, uint _grantId) public {
487     TokenGrant grant = grants[_holder][_grantId];
488 
489     if (!grant.revokable) { // Check if grant was revokable
490       throw;
491     }
492 
493     if (grant.granter != msg.sender) { // Only granter can revoke it
494       throw;
495     }
496 
497     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
498     uint256 nonVested = nonVestedTokens(grant, uint64(now));
499 
500     // remove grant from array
501     delete grants[_holder][_grantId];
502     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
503     grants[_holder].length -= 1;
504 
505     balances[receiver] = balances[receiver].add(nonVested);
506     balances[_holder] = balances[_holder].sub(nonVested);
507 
508     Transfer(_holder, receiver, nonVested);
509   }
510 
511   /**
512    * @dev Calculate the total amount of transferable tokens of a holder at a given time
513    * @param holder address The address of the holder
514    * @param time uint64 The specific time.
515    * @return An uint representing a holder's total amount of transferable tokens.
516    */
517   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
518     uint256 grantIndex = tokenGrantsCount(holder);
519     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
520 
521     // Iterate through all the grants the holder has, and add all non-vested tokens
522     uint256 nonVested = 0;
523     for (uint256 i = 0; i < grantIndex; i++) {
524       nonVested = nonVested.add(nonVestedTokens(grants[holder][i], time));
525     }
526 
527     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
528     uint256 vestedTransferable = balanceOf(holder).sub(nonVested);
529 
530     // Return the minimum of how many vested can transfer and other value
531     // in case there are other limiting transferability factors (default is balanceOf)
532     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
533   }
534 
535   /**
536    * @dev Check the amount of grants that an address has.
537    * @param _holder The holder of the grants.
538    * @return A uint representing the total amount of grants.
539    */
540   function tokenGrantsCount(address _holder) constant returns (uint index) {
541     return grants[_holder].length;
542   }
543 
544   /**
545    * @dev Calculate amount of vested tokens at a specifc time.
546    * @param tokens uint256 The amount of tokens grantted.
547    * @param time uint64 The time to be checked
548    * @param start uint64 A time representing the begining of the grant
549    * @param cliff uint64 The cliff period.
550    * @param vesting uint64 The vesting period.
551    * @return An uint representing the amount of vested tokensof a specif grant.
552    *  transferableTokens
553    *   |                         _/--------   vestedTokens rect
554    *   |                       _/
555    *   |                     _/
556    *   |                   _/
557    *   |                 _/
558    *   |                /
559    *   |              .|
560    *   |            .  |
561    *   |          .    |
562    *   |        .      |
563    *   |      .        |(grants[_holder] == address(0)) return 0;
564    *   |    .          |
565    *   +===+===========+---------+----------> time
566    *      Start       Clift    Vesting
567    */
568   function calculateVestedTokens(
569     uint256 tokens,
570     uint256 time,
571     uint256 start,
572     uint256 cliff,
573     uint256 vesting) constant returns (uint256)
574     {
575       // Shortcuts for before cliff and after vesting cases.
576       if (time < cliff) return 0;
577       if (time >= vesting) return tokens;
578 
579       // Interpolate all vested tokens.
580       // As before cliff the shortcut returns 0, we can use just calculate a value
581       // in the vesting rect (as shown in above's figure)
582 
583       // vestedTokens = tokens * (time - start) / (vesting - start)
584       uint256 vestedTokens = tokens.mul(time.sub(start)).div(vesting.sub(start));
585       return vestedTokens;
586   }
587 
588   /**
589    * @dev Get all information about a specifc grant.
590    * @param _holder The address which will have its tokens revoked.
591    * @param _grantId The id of the token grant.
592    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
593    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
594    */
595   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
596     TokenGrant grant = grants[_holder][_grantId];
597 
598     granter = grant.granter;
599     value = grant.value;
600     start = grant.start;
601     cliff = grant.cliff;
602     vesting = grant.vesting;
603     revokable = grant.revokable;
604     burnsOnRevoke = grant.burnsOnRevoke;
605 
606     vested = vestedTokens(grant, uint64(now));
607   }
608 
609   /**
610    * @dev Get the amount of vested tokens at a specific time.
611    * @param grant TokenGrant The grant to be checked.
612    * @param time The time to be checked
613    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
614    */
615   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
616     return calculateVestedTokens(
617       grant.value,
618       uint256(time),
619       uint256(grant.start),
620       uint256(grant.cliff),
621       uint256(grant.vesting)
622     );
623   }
624 
625   /**
626    * @dev Calculate the amount of non vested tokens at a specific time.
627    * @param grant TokenGrant The grant to be checked.
628    * @param time uint64 The time to be checked
629    * @return An uint representing the amount of non vested tokens of a specifc grant on the
630    * passed time frame.
631    */
632   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
633     return grant.value.sub(vestedTokens(grant, time));
634   }
635 
636   /**
637    * @dev Calculate the date when the holder can trasfer all its tokens
638    * @param holder address The address of the holder
639    * @return An uint representing the date of the last transferable tokens.
640    */
641   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
642     date = uint64(now);
643     uint256 grantIndex = grants[holder].length;
644     for (uint256 i = 0; i < grantIndex; i++) {
645       date = SafeMath.max64(grants[holder][i].vesting, date);
646     }
647   }
648 }
649 
650 /// @title Artcoin (ART) - democratizing culture.
651 contract Artcoin is MintableToken, VestedToken {
652 
653   string public constant name = 'Artcoin';
654   string public constant symbol = 'ART';
655   uint public constant decimals = 18;
656 
657   function() public payable {
658     if (isContract(controller)) {
659       if (!Controller(controller).proxyPayment.value(msg.value)(msg.sender)) throw;
660     } else {
661       throw;
662     }
663   }
664 
665   function isContract(address _addr) constant internal returns(bool) {
666     uint size;
667     if (_addr == address(0)) return false;
668     assembly {
669       size := extcodesize(_addr)
670     }
671     return size > 0;
672   }
673 }
674 
675 /// @title Artcoin Placeholder - democratizing culture.
676 contract ArtcoinPlaceholder is Controller {
677 
678   Artcoin public token;
679   address public tokenSale;
680 
681   function ArtcoinPlaceholder(address _token, address _tokenSale) {
682     token = Artcoin(_token);
683     tokenSale = _tokenSale;
684   }
685 
686   function changeController(address consortium) public {
687     if (msg.sender != tokenSale) throw;
688     token.changeController(consortium);
689     suicide(consortium);
690   }
691 
692   function proxyPayment(address _owner) payable public returns (bool) {
693     throw;
694     return false;
695   }
696 
697   function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
698     return true;
699   }
700 
701   function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
702     return true;
703   }
704 }
705 
706 /// @title ART Sale - democratizing culture.
707 contract ArtSale is Controller {
708   using SafeMath for uint;
709 
710   address public manager;
711   address public operations;
712   ArtcoinPlaceholder public consortiumPlaceholder;
713 
714   Artcoin public token;
715   Escrow public escrow;
716 
717   uint public initialBlock;  // block number in which the sale starts, inclusive. sale will be opened at initial block.
718   uint public finalBlock;  // block number in which the sale ends, exclusive, sale will be closed at ends block.
719   uint public initialPrice;  // number of wei-Artcoin tokens for 1 wei, at the start of the sale (18 decimals)
720   uint public finalPrice;  // number of wei-Artcoin tokens for 1 wei, at the end of the sale
721   uint public priceStages;  // number of different price stages for interpolating between initialPrice and finalPrice
722 
723   uint public maximumSubscription;  // maximum subscriptions, in wei
724   uint public totalSubscription = 0;  // total subscriptions, in wei
725 
726   mapping (address => bool) public activations;  // confirmations to activate the sale
727   mapping (address => uint) public subscriptions;  // subscriptions
728 
729   uint constant public dust = 1 finney;  // minimum investment
730 
731   bool public saleStopped = false;
732   bool public saleFinalized = false;
733 
734   event NewPresaleAllocation(address indexed holder, uint amount);
735   event NewSubscription(address indexed holder, uint amount, uint etherAmount);
736 
737   function ArtSale(address _manager,
738                    address _operations,
739                    uint _initialBlock,
740                    uint _finalBlock,
741                    uint256 _initialPrice,
742                    uint256 _finalPrice,
743                    uint8 _priceStages,
744                    uint _maximumSubscription)
745                    nonZeroAddress(_operations) {
746     if (_initialBlock < getBlockNumber()) throw;
747     if (_initialBlock >= _finalBlock) throw;
748     if (_initialPrice <= _finalPrice) throw;
749     if (_priceStages < 2) throw;
750     if (_priceStages > _initialPrice - _finalPrice) throw;
751 
752     manager = _manager;
753     operations = _operations;
754     maximumSubscription = _maximumSubscription;
755     initialBlock = _initialBlock;
756     finalBlock = _finalBlock;
757     initialPrice = _initialPrice;
758     finalPrice = _finalPrice;
759     priceStages = _priceStages;
760   }
761 
762   // @notice Set Artcoin token and escrow address.
763   // @param _token: Address of an instance of the Artcoin token
764   // @param _consortiumPlaceholder: Address of the consortium placeholder
765   // @param _escrow: Address of the wallet receiving the funds of the sale
766   function setArtcoin(address _token,
767                       address _consortiumPlaceholder,
768                       address _escrow)
769                       nonZeroAddress(_token)
770                       nonZeroAddress(_consortiumPlaceholder)
771                       nonZeroAddress(_escrow)
772                       public {
773     if (activations[this]) throw;
774 
775     token = Artcoin(_token);
776     consortiumPlaceholder = ArtcoinPlaceholder(_consortiumPlaceholder);
777     escrow = Escrow(_escrow);
778 
779     if (token.controller() != address(this)) throw;  // sale is token controller
780     if (token.totalSupply() > 0) throw;  // token is empty
781     if (consortiumPlaceholder.tokenSale() != address(this)) throw;  // placeholder has reference to sale
782     if (consortiumPlaceholder.token() != address(token)) throw; // placeholder has reference to ART
783     if (escrow.finalBlock() != finalBlock) throw;  // final blocks must match
784     if (escrow.beneficiary() != operations) throw;  // receiving wallet must match
785     if (escrow.tokenSale() != address(this)) throw;  // watched token sale must be self
786 
787     doActivateSale(this);
788   }
789 
790   // @notice Certain addresses need to call the activate function prior to the sale opening block.
791   // This proves that they have checked the sale contract is legit, as well as proving
792   // the capability for those addresses to interact with the contract.
793   function activateSale() public {
794     doActivateSale(msg.sender);
795   }
796 
797   function doActivateSale(address _entity) nonZeroAddress(token) onlyBeforeSale private {
798     activations[_entity] = true;
799   }
800 
801   // @notice Whether the needed accounts have activated the sale.
802   // @return Is sale activated
803   function isActivated() constant public returns (bool) {
804     return activations[this] && activations[operations];
805   }
806 
807   // @notice Get the price for a Artcoin token at any given block number
808   // @param _blockNumber the block for which the price is requested
809   // @return Number of wei-Artcoin for 1 wei
810   // If sale isn't ongoing for that block, returns 0.
811   function getPrice(uint _blockNumber) constant public returns (uint) {
812     if (_blockNumber < initialBlock || _blockNumber >= finalBlock) return 0;
813     return priceForStage(stageForBlock(_blockNumber));
814   }
815 
816   // @notice Get what the stage is for a given blockNumber
817   // @param _blockNumber: Block number
818   // @return The sale stage for that block. Stage is between 0 and (priceStages - 1)
819   function stageForBlock(uint _blockNumber) constant internal returns (uint) {
820     uint blockN = _blockNumber.sub(initialBlock);
821     uint totalBlocks = finalBlock.sub(initialBlock);
822     return priceStages.mul(blockN).div(totalBlocks);
823   }
824 
825   // @notice Get what the price is for a given stage
826   // @param _stage: Stage number
827   // @return Price in wei for that stage.
828   // If sale stage doesn't exist, returns 0.
829   function priceForStage(uint _stage) constant internal returns (uint) {
830     if (_stage >= priceStages) return 0;
831     uint priceDifference = initialPrice.sub(finalPrice);
832     uint stageDelta = priceDifference.div(uint(priceStages - 1));
833     return initialPrice.sub(uint(_stage).mul(stageDelta));
834   }
835 
836   // @notice Artcoin needs to make initial token allocations for presale partners
837   // This allocation has to be made before the sale is activated. Activating the
838   // sale means no more arbitrary allocations are possible and expresses conformity.
839   // @param _recipient: The receiver of the tokens
840   // @param _amount: Amount of tokens allocated for receiver.
841   function allocatePresaleTokens(address _recipient,
842                                  uint _amount,
843                                  uint64 cliffDate,
844                                  uint64 vestingDate,
845                                  bool revokable,
846                                  bool burnOnRevocation)
847                                  onlyBeforeSaleActivation
848                                  onlyBeforeSale
849                                  nonZeroAddress(_recipient)
850                                  only(operations) public {
851     token.grantVestedTokens(_recipient, _amount, uint64(now), cliffDate, vestingDate, revokable, burnOnRevocation);
852     NewPresaleAllocation(_recipient, _amount);
853   }
854 
855   /// @dev The fallback function is called when ether is sent to the contract, it
856   /// simply calls `doPayment()` with the address that sent the ether as the
857   /// `_subscriber`. Payable is a required solidity modifier for functions to receive
858   /// ether, without this modifier functions will throw if ether is sent to them
859   function() public payable {
860     return doPayment(msg.sender);
861   }
862 
863   /// @dev `doPayment()` is an internal function that sends the ether that this
864   /// contract receives to escrow and creates tokens in the address of the
865   /// @param _subscriber The address that will hold the newly created tokens
866   function doPayment(address _subscriber)
867            onlyDuringSalePeriod
868            onlySaleNotStopped
869            onlySaleActivated
870            nonZeroAddress(_subscriber)
871            minimumValue(dust) internal {
872     if (totalSubscription + msg.value > maximumSubscription) throw;  // throw if maximum subscription exceeded
873     uint purchasedTokens = msg.value.mul(getPrice(getBlockNumber()));  // number of purchased tokens
874 
875     if (!escrow.send(msg.value)) throw;  // escrow funds
876     if (!token.mint(_subscriber, purchasedTokens)) throw;  // deliver tokens
877 
878     subscriptions[_subscriber] = subscriptions[_subscriber].add(msg.value);
879     totalSubscription = totalSubscription.add(msg.value);
880     NewSubscription(_subscriber, purchasedTokens, msg.value);
881   }
882 
883   // @notice Function to stop sale before the sale period ends
884   // @dev Only operations is authorized to call this method
885   function stopSale() onlySaleActivated onlySaleNotStopped only(operations) public {
886     saleStopped = true;
887   }
888 
889   // @notice Function to restart stopped sale
890   // @dev Only operations is authorized to call this method
891   function restartSale() onlyDuringSalePeriod onlySaleStopped only(operations) public {
892     saleStopped = false;
893   }
894 
895   // @notice Finalizes sale and distributes Artcoin to purchasers and releases payments
896   // @dev Transfers the token controller power to the consortium.
897   function finalizeSale() onlyAfterSale only(operations) public {
898     doFinalizeSale();
899   }
900 
901   function doFinalizeSale() internal {
902     uint purchasedTokens = token.totalSupply();
903 
904     uint advisorTokens = purchasedTokens * 5 / 100;  // mint 5% of purchased for advisors
905     if (!token.mint(operations, advisorTokens)) throw;
906 
907     uint managerTokens = purchasedTokens * 25 / 100;  // mint 25% of purchased for manager
908     if (!token.mint(manager, managerTokens)) throw;
909 
910     token.changeController(consortiumPlaceholder);
911 
912     saleFinalized = true;
913     saleStopped = true;
914   }
915 
916   // @notice Deploy Artcoin Consortium contract
917   // @param consortium: The address the consortium was deployed at.
918   function deployConsortium(address consortium) onlyFinalizedSale nonZeroAddress(consortium) only(operations) public {
919     consortiumPlaceholder.changeController(consortium);
920   }
921 
922   function setOperations(address _operations) nonZeroAddress(_operations) only(operations) public {
923     operations = _operations;
924   }
925 
926   function getBlockNumber() constant internal returns (uint) {
927     return block.number;
928   }
929 
930   function saleFinalized() constant returns (bool) {
931     return saleFinalized;
932   }
933 
934   function proxyPayment(address _owner) payable public returns (bool) {
935     doPayment(_owner);
936     return true;
937   }
938 
939   /// @notice Notifies the controller about a transfer
940   /// @param _from The origin of the transfer
941   /// @param _to The destination of the transfer
942   /// @param _amount The amount of the transfer
943   /// @return False if the controller does not authorize the transfer
944   function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
945     // Until the sale is finalized, only allows transfers originated by the sale contract.
946     // When finalizeSale is called, this function will stop being called and will always be true.
947     return _from == address(this);
948   }
949 
950   /// @notice Notifies the controller about an approval
951   /// @param _owner The address that calls `approve()`
952   /// @param _spender The spender in the `approve()` call
953   /// @param _amount The amount in the `approve()` call
954   /// @return False if the controller does not authorize the approval
955   function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
956     return false;
957   }
958 
959   modifier only(address x) {
960     if (msg.sender != x) throw;
961     _;
962   }
963 
964   modifier onlyBeforeSale {
965     if (getBlockNumber() >= initialBlock) throw;
966     _;
967   }
968 
969   modifier onlyDuringSalePeriod {
970     if (getBlockNumber() < initialBlock) throw;
971     if (getBlockNumber() >= finalBlock) throw;
972     _;
973   }
974 
975   modifier onlyAfterSale {
976     if (getBlockNumber() < finalBlock) throw;
977     _;
978   }
979 
980   modifier onlySaleStopped {
981     if (!saleStopped) throw;
982     _;
983   }
984 
985   modifier onlySaleNotStopped {
986     if (saleStopped) throw;
987     _;
988   }
989 
990   modifier onlyBeforeSaleActivation {
991     if (isActivated()) throw;
992     _;
993   }
994 
995   modifier onlySaleActivated {
996     if (!isActivated()) throw;
997     _;
998   }
999 
1000   modifier onlyFinalizedSale {
1001     if (getBlockNumber() < finalBlock) throw;
1002     if (!saleFinalized) throw;
1003     _;
1004   }
1005 
1006   modifier nonZeroAddress(address x) {
1007     if (x == 0) throw;
1008     _;
1009   }
1010 
1011   modifier minimumValue(uint256 x) {
1012     if (msg.value < x) throw;
1013     _;
1014   }
1015 }