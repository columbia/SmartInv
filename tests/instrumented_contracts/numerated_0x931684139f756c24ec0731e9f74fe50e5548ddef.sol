1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36     if (a == 0) {
37       return 0;
38     }
39     c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     // uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return a / b;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Burnable Token
213  * @dev Token that can be irreversibly burned (destroyed).
214  */
215 contract BurnableToken is BasicToken {
216 
217   event Burn(address indexed burner, uint256 value);
218 
219   /**
220    * @dev Burns a specific amount of tokens.
221    * @param _value The amount of token to be burned.
222    */
223   function burn(uint256 _value) public {
224     _burn(msg.sender, _value);
225   }
226 
227   function _burn(address _who, uint256 _value) internal {
228     require(_value <= balances[_who]);
229     // no need to require value <= totalSupply, since that would imply the
230     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
231 
232     balances[_who] = balances[_who].sub(_value);
233     totalSupply_ = totalSupply_.sub(_value);
234     emit Burn(_who, _value);
235     emit Transfer(_who, address(0), _value);
236   }
237 }
238 
239 /**
240  * @title SafeERC20
241  * @dev Wrappers around ERC20 operations that throw on failure.
242  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
243  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
244  */
245 library SafeERC20 {
246   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
247     assert(token.transfer(to, value));
248   }
249 
250   function safeTransferFrom(
251     ERC20 token,
252     address from,
253     address to,
254     uint256 value
255   )
256     internal
257   {
258     assert(token.transferFrom(from, to, value));
259   }
260 
261   function safeApprove(ERC20 token, address spender, uint256 value) internal {
262     assert(token.approve(spender, value));
263   }
264 }
265 
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of "user permissions".
270  */
271 contract Ownable {
272   address public owner;
273 
274 
275   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277 
278   /**
279    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
280    * account.
281    */
282   function Ownable() public {
283     owner = msg.sender;
284   }
285 
286   /**
287    * @dev Throws if called by any account other than the owner.
288    */
289   modifier onlyOwner() {
290     require(msg.sender == owner);
291     _;
292   }
293 
294   /**
295    * @dev Allows the current owner to transfer control of the contract to a newOwner.
296    * @param newOwner The address to transfer ownership to.
297    */
298   function transferOwnership(address newOwner) public onlyOwner {
299     require(newOwner != address(0));
300     emit OwnershipTransferred(owner, newOwner);
301     owner = newOwner;
302   }
303 
304 }
305 
306 /* solium-disable security/no-block-members */
307 
308 
309 
310 
311 
312 
313 
314 
315 
316 /**
317  * @title TokenVesting
318  * @dev A token holder contract that can release its token balance gradually like a
319  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
320  * owner.
321  */
322 contract TokenVesting is Ownable {
323   using SafeMath for uint256;
324   using SafeERC20 for ERC20Basic;
325 
326   event Released(uint256 amount);
327   event Revoked();
328 
329   // beneficiary of tokens after they are released
330   address public beneficiary;
331 
332   uint256 public cliff;
333   uint256 public start;
334   uint256 public duration;
335 
336   bool public revocable;
337 
338   mapping (address => uint256) public released;
339   mapping (address => bool) public revoked;
340 
341   /**
342    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
343    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
344    * of the balance will have vested.
345    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
346    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
347    * @param _duration duration in seconds of the period in which the tokens will vest
348    * @param _revocable whether the vesting is revocable or not
349    */
350   function TokenVesting(
351     address _beneficiary,
352     uint256 _start,
353     uint256 _cliff,
354     uint256 _duration,
355     bool _revocable
356   )
357     public
358   {
359     require(_beneficiary != address(0));
360     require(_cliff <= _duration);
361 
362     beneficiary = _beneficiary;
363     revocable = _revocable;
364     duration = _duration;
365     cliff = _start.add(_cliff);
366     start = _start;
367   }
368 
369   /**
370    * @notice Transfers vested tokens to beneficiary.
371    * @param token ERC20 token which is being vested
372    */
373   function release(ERC20Basic token) public {
374     uint256 unreleased = releasableAmount(token);
375 
376     require(unreleased > 0);
377 
378     released[token] = released[token].add(unreleased);
379 
380     token.safeTransfer(beneficiary, unreleased);
381 
382     emit Released(unreleased);
383   }
384 
385   /**
386    * @notice Allows the owner to revoke the vesting. Tokens already vested
387    * remain in the contract, the rest are returned to the owner.
388    * @param token ERC20 token which is being vested
389    */
390   function revoke(ERC20Basic token) public onlyOwner {
391     require(revocable);
392     require(!revoked[token]);
393 
394     uint256 balance = token.balanceOf(this);
395 
396     uint256 unreleased = releasableAmount(token);
397     uint256 refund = balance.sub(unreleased);
398 
399     revoked[token] = true;
400 
401     token.safeTransfer(owner, refund);
402 
403     emit Revoked();
404   }
405 
406   /**
407    * @dev Calculates the amount that has already vested but hasn't been released yet.
408    * @param token ERC20 token which is being vested
409    */
410   function releasableAmount(ERC20Basic token) public view returns (uint256) {
411     return vestedAmount(token).sub(released[token]);
412   }
413 
414   /**
415    * @dev Calculates the amount that has already vested.
416    * @param token ERC20 token which is being vested
417    */
418   function vestedAmount(ERC20Basic token) public view returns (uint256) {
419     uint256 currentBalance = token.balanceOf(this);
420     uint256 totalBalance = currentBalance.add(released[token]);
421 
422     if (block.timestamp < cliff) {
423       return 0;
424     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
425       return totalBalance;
426     } else {
427       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
428     }
429   }
430 }
431 
432 /**
433  * @title PresaleTokenVesting
434  * @dev PresaleTokenVesting allows for vesting periods which begin at
435  * the time the token sale ends.
436  */
437 contract PresaleTokenVesting is TokenVesting {
438 
439     function PresaleTokenVesting(address _beneficiary, uint256 _duration) TokenVesting(_beneficiary, 0, _duration, _duration, false) public {
440     }
441 
442     function vestedAmount(ERC20Basic token) public view returns (uint256) {
443         UrbitToken urbit = UrbitToken(token); 
444         if (!urbit.saleClosed()) {
445             return(0);
446         } else {
447             uint256 currentBalance = token.balanceOf(this);
448             uint256 totalBalance = currentBalance.add(released[token]);
449             uint256 saleClosedTime = urbit.saleClosedTimestamp();
450             if (block.timestamp >= duration.add(saleClosedTime)) { // solium-disable-line security/no-block-members
451                 return totalBalance;
452             } else {
453                 return totalBalance.mul(block.timestamp.sub(saleClosedTime)).div(duration); // solium-disable-line security/no-block-members
454 
455             }
456         }
457     }
458 }
459 
460 /**
461  * @title TokenVault
462  * @dev TokenVault is a token holder contract that will allow a
463  * beneficiary to spend the tokens from some function of a specified ERC20 token
464  */
465 contract TokenVault {
466     using SafeERC20 for ERC20;
467 
468     // ERC20 token contract being held
469     ERC20 public token;
470 
471     function TokenVault(ERC20 _token) public {
472         token = _token;
473     }
474 
475     /**
476      * @notice Allow the token itself to send tokens
477      * using transferFrom().
478      */
479     function fillUpAllowance() public {
480         uint256 amount = token.balanceOf(this);
481         require(amount > 0);
482 
483         token.approve(token, amount);
484     }
485 }
486 
487 /**
488  * @title UrbitToken
489  * @dev UrbitToken is a contract for the Urbit token sale, creating the
490  * tokens and managing the vaults.
491  */
492 contract UrbitToken is BurnableToken, StandardToken {
493     string public constant name = "Urbit Token"; // solium-disable-line uppercase
494     string public constant symbol = "URB"; // solium-disable-line uppercase
495     uint8 public constant decimals = 18; // solium-disable-line uppercase
496     uint256 public constant MAGNITUDE = 10**uint256(decimals);
497 
498     /// Maximum tokens to be allocated (600 million)
499     uint256 public constant HARD_CAP = 600000000 * MAGNITUDE;
500 
501     /// This address is used to manage the admin functions and allocate vested tokens
502     address public urbitAdminAddress;
503 
504     /// This address is used to keep the tokens for sale
505     address public saleTokensAddress;
506 
507     /// This vault is used to keep the bounty and marketing tokens
508     TokenVault public bountyTokensVault;
509 
510     /// This vault is used to keep the team and founders tokens
511     TokenVault public urbitTeamTokensVault;
512 
513     /// This vault is used to keep the advisors tokens
514     TokenVault public advisorsTokensVault;
515 
516     /// This vault is used to keep the rewards tokens
517     TokenVault public rewardsTokensVault;
518 
519     /// This vault is used to keep the retained tokens
520     TokenVault public retainedTokensVault;
521 
522     /// Store the vesting contracts addresses
523     mapping(address => address[]) public vestingsOf;
524 
525     /// when the token sale is closed, the trading is open
526     uint256 public saleClosedTimestamp = 0;
527 
528     /// Only allowed to execute before the token sale is closed
529     modifier beforeSaleClosed {
530         require(!saleClosed());
531         _;
532     }
533 
534     /// Limiting functions to the admins of the token only
535     modifier onlyAdmin {
536         require(senderIsAdmin());
537         _;
538     }
539 
540     function UrbitToken(
541         address _urbitAdminAddress,
542         address _saleTokensAddress) public
543     {
544         require(_urbitAdminAddress != address(0));
545         require(_saleTokensAddress != address(0));
546 
547         urbitAdminAddress = _urbitAdminAddress;
548         saleTokensAddress = _saleTokensAddress;
549     }
550 
551     /// @dev allows the admin to assign a new admin
552     function changeAdmin(address _newUrbitAdminAddress) external onlyAdmin {
553         require(_newUrbitAdminAddress != address(0));
554         urbitAdminAddress = _newUrbitAdminAddress;
555     }
556 
557     /// @dev creates the tokens needed for sale
558     function createSaleTokens() external onlyAdmin beforeSaleClosed {
559         require(bountyTokensVault == address(0));
560 
561         /// Maximum tokens to be allocated on the sale
562         /// 252,000,000 URB
563         createTokens(252000000, saleTokensAddress);
564 
565         /// Bounty tokens - 24M URB
566         bountyTokensVault = createTokenVault(24000000);
567     }
568 
569     /// @dev Close the token sale
570     function closeSale() external onlyAdmin beforeSaleClosed {
571         createAwardTokens();
572         saleClosedTimestamp = block.timestamp; // solium-disable-line security/no-block-members
573     }
574 
575     /// @dev Once the token sale is closed and tokens are distributed,
576     /// burn the remaining unsold, undistributed tokens
577     function burnUnsoldTokens() external onlyAdmin {
578         require(saleClosed());
579         _burn(saleTokensAddress, balances[saleTokensAddress]);
580         _burn(bountyTokensVault, balances[bountyTokensVault]);
581     }
582 
583     function lockBountyTokens(uint256 _tokensAmount, address _beneficiary, uint256 _duration) external beforeSaleClosed {
584         require(msg.sender == saleTokensAddress || senderIsAdmin());
585         _presaleLock(bountyTokensVault, _tokensAmount, _beneficiary, _duration);
586     }
587 
588     /// @dev Shorter version of vest tokens (lock for a single whole period)
589     function lockTokens(address _fromVault, uint256 _tokensAmount, address _beneficiary, uint256 _unlockTime) external onlyAdmin {
590         this.vestTokens(_fromVault, _tokensAmount, _beneficiary, _unlockTime, 0, 0, false); // solium-disable-line arg-overflow
591     }
592 
593     /// @dev Vest tokens
594     function vestTokens(
595         address _fromVault,
596         uint256 _tokensAmount,
597         address _beneficiary,
598         uint256 _start,
599         uint256 _cliff,
600         uint256 _duration,
601         bool _revocable)
602         external onlyAdmin
603     {
604         TokenVesting vesting = new TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable);
605         vestingsOf[_beneficiary].push(address(vesting));
606 
607         require(this.transferFrom(_fromVault, vesting, _tokensAmount));
608     }
609 
610     /// @dev releases vested tokens for the caller's own address
611     function releaseVestedTokens() external {
612         this.releaseVestedTokensFor(msg.sender);
613     }
614 
615     /// @dev releases vested tokens for the specified address.
616     /// Can be called by any account for any address.
617     function releaseVestedTokensFor(address _owner) external {
618         ERC20Basic token = ERC20Basic(address(this));
619         for (uint i = 0; i < vestingsOf[_owner].length; i++) {
620             TokenVesting tv = TokenVesting(vestingsOf[_owner][i]);
621             if (tv.releasableAmount(token) > 0) {
622                 tv.release(token);
623             }
624         }
625     }
626 
627     /// @dev returns whether the sender is admin (or the contract itself)
628     function senderIsAdmin() public view returns (bool) {
629         return (msg.sender == urbitAdminAddress || msg.sender == address(this));
630     }
631 
632     /// @dev The sale is closed when the saleClosedTimestamp is set.
633     function saleClosed() public view returns (bool) {
634         return (saleClosedTimestamp > 0);
635     }
636 
637     /// @dev check the locked balance for an address
638     function lockedBalanceOf(address _owner) public view returns (uint256) {
639         uint256 result = 0;
640         for (uint i = 0; i < vestingsOf[_owner].length; i++) {
641             result += balances[vestingsOf[_owner][i]];
642         }
643         return result;
644     }
645 
646     /// @dev check the locked but releasable balance for an address
647     function releasableBalanceOf(address _owner) public view returns (uint256) {
648         uint256 result = 0;
649         for (uint i = 0; i < vestingsOf[_owner].length; i++) {
650             result += TokenVesting(vestingsOf[_owner][i]).releasableAmount(this);
651         }
652         return result;
653     }
654 
655     /// @dev get the number of TokenVesting contracts for an address
656     function vestingCountOf(address _owner) public view returns (uint) {
657         return vestingsOf[_owner].length;
658     }
659 
660     /// @dev get the specified TokenVesting contract address for an address
661     function vestingOf(address _owner, uint _index) public view returns (address) {
662         return vestingsOf[_owner][_index];
663     }
664 
665     /// @dev Trading is limited before the sale is closed
666     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
667         if (saleClosed() || msg.sender == saleTokensAddress || senderIsAdmin()) {
668             return super.transferFrom(_from, _to, _value);
669         }
670         return false;
671     }
672 
673     /// @dev Trading is limited before the sale is closed
674     function transfer(address _to, uint256 _value) public returns (bool) {
675         if (saleClosed() || msg.sender == saleTokensAddress || senderIsAdmin()) {
676             return super.transfer(_to, _value);
677         }
678         return false;
679     }
680 
681     /// @dev Grant tokens which begin vesting upon close of sale.
682     function _presaleLock(TokenVault _fromVault, uint256 _tokensAmount, address _beneficiary, uint256 _duration) internal {
683         PresaleTokenVesting vesting = new PresaleTokenVesting(_beneficiary, _duration);
684         vestingsOf[_beneficiary].push(address(vesting));
685 
686         require(this.transferFrom(_fromVault, vesting, _tokensAmount));
687     }
688 
689     // @dev create specified number of toekns and transfer to destination
690     function createTokens(uint32 count, address destination) internal onlyAdmin {
691         uint256 tokens = count * MAGNITUDE;
692         totalSupply_ = totalSupply_.add(tokens);
693         balances[destination] = tokens;
694         emit Transfer(0x0, destination, tokens);
695     }
696 
697     /// @dev Create a TokenVault and fill with the specified newly minted tokens
698     function createTokenVault(uint32 count) internal onlyAdmin returns (TokenVault) {
699         TokenVault tokenVault = new TokenVault(ERC20(this));
700         createTokens(count, tokenVault);
701         tokenVault.fillUpAllowance();
702         return tokenVault;
703     }
704 
705     /// @dev Creates the tokens awarded after the sale is closed
706     function createAwardTokens() internal onlyAdmin {
707         /// Team tokens - 30M URB
708         urbitTeamTokensVault = createTokenVault(30000000);
709 
710         /// Advisors tokens - 24M URB
711         advisorsTokensVault = createTokenVault(24000000);
712 
713         /// Rewards tokens - 150M URB
714         rewardsTokensVault = createTokenVault(150000000);
715 
716         /// Retained tokens - 120M URB
717         retainedTokensVault = createTokenVault(120000000);
718     }
719 }