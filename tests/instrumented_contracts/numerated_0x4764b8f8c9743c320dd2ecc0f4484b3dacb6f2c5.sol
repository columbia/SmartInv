1 pragma solidity 0.5.4;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that revert on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, reverts on overflow.
49   */
50   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (_a == 0) {
55       return 0;
56     }
57 
58     uint256 c = _a * _b;
59     require(c / _a == _b);
60 
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
66   */
67   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
68     require(_b > 0); // Solidity only automatically asserts when dividing by 0
69     uint256 c = _a / _b;
70     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
71 
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     require(_b <= _a);
80     uint256 c = _a - _b;
81 
82     return c;
83   }
84 
85   /**
86   * @dev Adds two numbers, reverts on overflow.
87   */
88   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
89     uint256 c = _a + _b;
90     require(c >= _a);
91 
92     return c;
93   }
94 
95   /**
96   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
97   * reverts when dividing by zero.
98   */
99   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100     require(b != 0);
101     return a % b;
102   }
103 }
104 
105 /**
106  * @title Contract for Rewards Token
107  * Copyright 2018, Rewards Blockchain Systems (Rewards.com)
108  */
109 
110 contract RewardsToken is Ownable {
111     using SafeMath for uint;
112 
113     string public constant symbol = 'RWRD';
114     string public constant name = 'Rewards Cash';
115     uint8 public constant decimals = 18;
116 
117     uint256 public constant hardCap = 5 * (10 ** (18 + 8)); //500MM tokens. Max amount of tokens which can be minte10
118     uint256 public totalSupply;
119 
120     bool public mintingFinished = false;
121     bool public frozen = true;
122 
123     mapping(address => uint256) balances;
124     mapping(address => mapping(address => uint256)) internal allowed;
125 
126     event NewToken(address indexed _token);
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129     event Burned(address indexed _burner, uint _burnedAmount);
130     event Revoke(address indexed _from, uint256 _value);
131     event MintFinished();
132     event MintStarted();
133     event Freeze();
134     event Unfreeze();
135 
136     modifier canMint() {
137         require(!mintingFinished, "Minting was already finished");
138         _;
139     }
140 
141     modifier canTransfer() {
142         require(msg.sender == owner || !frozen, "Tokens could not be transferred");
143         _;
144     }
145 
146     constructor () public {
147         emit NewToken(address(this));
148     }
149 
150     /**
151      * @dev Function to mint tokens
152      * @param _to The address that will receive the minted tokens.
153      * @param _amount The amount of tokens to mint.
154      * @return A boolean that indicates if the operation was successful.
155      */
156     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
157         require(_to != address(0), "Address should not be zero");
158         require(totalSupply.add(_amount) <= hardCap);
159 
160         totalSupply = totalSupply.add(_amount);
161         balances[_to] = balances[_to].add(_amount);
162         emit Transfer(address(0), _to, _amount);
163         return true;
164     }
165 
166     /**
167      * @dev Function to stop minting new tokens.
168      * @return True if the operation was successful.
169      */
170     function finishMinting() public onlyOwner returns (bool) {
171         require(!mintingFinished);
172         mintingFinished = true;
173         emit MintFinished();
174         return true;
175     }
176 
177     /**
178      * @dev Function to start minging new tokens.
179      * @return True if the operation was successful
180      */
181     function startMinting() public onlyOwner returns (bool) {
182         require(mintingFinished);
183         mintingFinished = false;
184         emit MintStarted();
185         return true;
186     }
187 
188     /**
189     * @dev transfer token for a specified address
190     * @param _to The address to transfer to.
191     * @param _value The amount to be transferred.
192     */
193     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
194         require(_to != address(0), "Address should not be zero");
195         require(_value <= balances[msg.sender], "Insufficient balance");
196 
197         // SafeMath.sub will throw if there is not enough balance.
198         balances[msg.sender] = balances[msg.sender] - _value;
199         balances[_to] = balances[_to].add(_value);
200         emit Transfer(msg.sender, _to, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Transfer tokens from one address to another
206      * @param _from address The address which you want to send tokens from
207      * @param _to address The address which you want to transfer to
208      * @param _value uint256 the amount of tokens to be transferred
209      */
210     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
211         require(_to != address(0), "Address should not be zero");
212         require(_value <= balances[_from], "Insufficient Balance");
213         require(_value <= allowed[_from][msg.sender], "Insufficient Allowance");
214 
215         balances[_from] = balances[_from] - _value;
216         balances[_to] = balances[_to].add(_value);
217         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
218         emit Transfer(_from, _to, _value);
219         return true;
220     }
221 
222     /**
223      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224      *
225      * Beware that changing an allowance with this method brings the risk that someone may use both the old
226      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      * @param _spender The address which will spend the funds.
230      * @param _value The amount of tokens to be spent.
231      */
232     function approve(address _spender, uint256 _value) public returns (bool) {
233         allowed[msg.sender][_spender] = _value;
234         emit Approval(msg.sender, _spender, _value);
235         return true;
236     }
237 
238     /**
239      * @dev Function to check the amount of tokens that an owner allowed to a spender.
240      * @param _owner address The address which owns the funds.
241      * @param _spender address The address which will spend the funds.
242      * @return A uint256 specifying the amount of tokens still available for the spender.
243      */
244     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
245         return allowed[_owner][_spender];
246     }
247 
248     /**
249      * approve should be called when allowed[_spender] == 0. To increment
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      */
254     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
255         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
256         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257         return true;
258     }
259 
260     /**
261      * @dev Decrease the amount of tokens that an owner allowed to a spender.
262      * approve should be called when allowed[_spender] == 0. To decrement
263      * allowed value is better to use this function to avoid 2 calls (and wait until
264      * the first transaction is mined)
265      * @param _spender The address which will spend the funds.
266      * @param _subtractedValue The amount of tokens to decrease the allowance by.
267      */
268     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
269         uint oldValue = allowed[msg.sender][_spender];
270         if (_subtractedValue > oldValue) {
271             allowed[msg.sender][_spender] = 0;
272         } else {
273             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274         }
275         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276         return true;
277     }
278 
279     /**
280      * @dev Gets the balance of the specified address.
281      * @param _owner The address to query the the balance of.
282      * @return An uint256 representing the amount owned by the passed address.
283      */
284     function balanceOf(address _owner) public view returns (uint256 balance) {
285         return balances[_owner];
286     }
287 
288     /** 
289      * @dev Burn tokens from an address
290      * @param _burnAmount The amount of tokens to burn
291      */
292     function burn(uint _burnAmount) public {
293         require(_burnAmount <= balances[msg.sender]);
294 
295         balances[msg.sender] = balances[msg.sender].sub(_burnAmount);
296         totalSupply = totalSupply.sub(_burnAmount);
297         emit Burned(msg.sender, _burnAmount);
298     }
299 
300     /**
301      * @dev Revokes minted tokens
302      * @param _from The address whose tokens are revoked
303      * @param _value The amount of token to revoke
304      */
305     function revoke(address _from, uint256 _value) public onlyOwner returns (bool) {
306         require(_value <= balances[_from]);
307         // no need to require value <= totalSupply, since that would imply the
308         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
309 
310         balances[_from] = balances[_from].sub(_value);
311         totalSupply = totalSupply.sub(_value);
312 
313         emit Revoke(_from, _value);
314         emit Transfer(_from, address(0), _value);
315         return true;
316     }
317 
318     /**
319      * @dev Freeze tokens
320      */
321     function freeze() public onlyOwner {
322         require(!frozen);
323         frozen = true;
324         emit Freeze();
325     }
326 
327     /**
328      * @dev Unfreeze tokens 
329      */
330     function unfreeze() public onlyOwner {
331         require(frozen);
332         frozen = false;
333         emit Unfreeze();
334     }
335 }
336 
337 /**
338  * @title Contract that will hold vested tokens;
339  * @notice Tokens for vested contributors will be hold in this contract and token holders
340  * will claim their tokens according to their own vesting timelines.
341  * Copyright 2018, Rewards Blockchain Systems (Rewards.com)
342  */
343 contract VestingVault is Ownable {
344     using SafeMath for uint256;
345 
346     struct Grant {
347         uint value;
348         uint vestingStart;
349         uint vestingCliff;
350         uint vestingDuration;
351         uint[] scheduleTimes;
352         uint[] scheduleValues;
353         uint level;              // 1: frequency, 2: schedules
354         uint transferred;
355     }
356 
357     RewardsToken public token;
358 
359     mapping(address => Grant) public grants;
360 
361     uint public totalVestedTokens;
362     // array of vested users addresses
363     address[] public vestedAddresses;
364     bool public locked;
365 
366     event NewGrant (address _to, uint _amount, uint _start, uint _duration, uint _cliff, uint[] _scheduleTimes,
367                     uint[] _scheduleAmounts, uint _level);
368     event NewRelease(address _holder, uint _amount);
369     event WithdrawAll(uint _amount);
370     event BurnTokens(uint _amount);
371     event LockedVault();
372 
373     modifier isOpen() {
374         require(locked == false, "Vault is already locked");
375         _;
376     }
377 
378     constructor (RewardsToken _token) public {
379         require(address(_token) != address(0), "Token address should not be zero");
380 
381         token = _token;
382         locked = false;
383     }
384 
385     /**
386      * @return address[] that represents vested addresses;
387      */
388     function returnVestedAddresses() public view returns (address[] memory) {
389         return vestedAddresses;
390     }
391 
392     /**
393      * @return grant that represents vested info for specific user;
394      */
395     function returnGrantInfo(address _user)
396     public view returns (uint, uint, uint, uint, uint[] memory, uint[] memory, uint, uint) {
397         require(_user != address(0), "Address should not be zero");
398         Grant storage grant = grants[_user];
399 
400         return (grant.value, grant.vestingStart, grant.vestingCliff, grant.vestingDuration, grant.scheduleTimes,
401         grant.scheduleValues, grant.level, grant.transferred);
402     }
403 
404     /**
405      * @dev Add vested contributor information
406      * @param _to Withdraw address that tokens will be sent
407      * @param _value Amount to hold during vesting period
408      * @param _start Unix epoch time that vesting starts from
409      * @param _duration Seconds amount of vesting duration
410      * @param _cliff Seconds amount of vesting cliffHi
411      * @param _scheduleTimes Array of Unix epoch times for vesting schedules
412      * @param _scheduleValues Array of Amount for vesting schedules
413      * @param _level Indicator that will represent types of vesting
414      * @return Int value that represents granted token amount
415      */
416     function grant(
417         address _to, uint _value, uint _start, uint _duration, uint _cliff, uint[] memory _scheduleTimes,
418         uint[] memory _scheduleValues, uint _level) public onlyOwner isOpen returns (uint256) {
419         require(_to != address(0), "Address should not be zero");
420         require(_level == 1 || _level == 2, "Invalid vesting level");
421         // make sure a single address can be granted tokens only once.
422         require(grants[_to].value == 0, "Already added to vesting vault");
423 
424         if (_level == 2) {
425             require(_scheduleTimes.length == _scheduleValues.length, "Schedule Times and Values should be matched");
426             _value = 0;
427             for (uint i = 0; i < _scheduleTimes.length; i++) {
428                 require(_scheduleTimes[i] > 0, "Seconds Amount of ScheduleTime should be greater than zero");
429                 require(_scheduleValues[i] > 0, "Amount of ScheduleValue should be greater than zero");
430                 if (i > 0) {
431                     require(_scheduleTimes[i] > _scheduleTimes[i - 1], "ScheduleTimes should be sorted by ASC");
432                 }
433                 _value = _value.add(_scheduleValues[i]);
434             }
435         }
436 
437         require(_value > 0, "Vested amount should be greater than zero");
438 
439         grants[_to] = Grant({
440             value : _value,
441             vestingStart : _start,
442             vestingDuration : _duration,
443             vestingCliff : _cliff,
444             scheduleTimes : _scheduleTimes,
445             scheduleValues : _scheduleValues,
446             level : _level,
447             transferred : 0
448             });
449 
450         vestedAddresses.push(_to);
451         totalVestedTokens = totalVestedTokens.add(_value);
452 
453         emit NewGrant(_to, _value, _start, _duration, _cliff, _scheduleTimes, _scheduleValues, _level);
454         return _value;
455     }
456 
457     /**
458      * @dev Get token amount for a token holder available to transfer at specific time
459      * @param _holder Address that represents holder's withdraw address
460      * @param _time Unix epoch time at the moment
461      * @return Int value that represents token amount that is available to release at the moment
462      */
463     function transferableTokens(address _holder, uint256 _time) public view returns (uint256) {
464         Grant storage grantInfo = grants[_holder];
465 
466         if (grantInfo.value == 0) {
467             return 0;
468         }
469         return calculateTransferableTokens(grantInfo, _time);
470     }
471 
472     /**
473      * @dev Internal function to calculate available amount at specific time
474      * @param _grant Grant that represents holder's vesting info
475      * @param _time Unix epoch time at the moment
476      * @return Int value that represents available vested token amount
477      */
478     function calculateTransferableTokens(Grant memory _grant, uint256 _time) private pure returns (uint256) {
479         uint totalVestedAmount = _grant.value;
480         uint totalAvailableVestedAmount = 0;
481 
482         if (_grant.level == 1) {
483             if (_time < _grant.vestingCliff.add(_grant.vestingStart)) {
484                 return 0;
485             } else if (_time >= _grant.vestingStart.add(_grant.vestingDuration)) {
486                 return _grant.value;
487             } else {
488                 totalAvailableVestedAmount =
489                 totalVestedAmount.mul(_time.sub(_grant.vestingStart)).div(_grant.vestingDuration);
490             }
491         } else {
492             if (_time < _grant.scheduleTimes[0]) {
493                 return 0;
494             } else if (_time >= _grant.scheduleTimes[_grant.scheduleTimes.length - 1]) {
495                 return _grant.value;
496             } else {
497                 for (uint i = 0; i < _grant.scheduleTimes.length; i++) {
498                     if (_grant.scheduleTimes[i] <= _time) {
499                         totalAvailableVestedAmount = totalAvailableVestedAmount.add(_grant.scheduleValues[i]);
500                     } else {
501                         break;
502                     }
503                 }
504             }
505         }
506 
507         return totalAvailableVestedAmount;
508     }
509 
510     /**
511      * @dev Claim vested token
512      * @notice this will be eligible after vesting start + cliff or schedule times
513      */
514     function claim() public {
515         address beneficiary = msg.sender;
516         Grant storage grantInfo = grants[beneficiary];
517         require(grantInfo.value > 0, "Grant does not exist");
518 
519         uint256 vested = calculateTransferableTokens(grantInfo, now);
520         require(vested > 0, "There is no vested tokens");
521 
522         uint256 transferable = vested.sub(grantInfo.transferred);
523         require(transferable > 0, "There is no remaining balance for this address");
524         require(token.balanceOf(address(this)) >= transferable, "Contract Balance is insufficient");
525 
526         grantInfo.transferred = grantInfo.transferred.add(transferable);
527         totalVestedTokens = totalVestedTokens.sub(transferable);
528 
529         token.transfer(beneficiary, transferable);
530         emit NewRelease(beneficiary, transferable);
531     }
532     
533     /**
534      * @dev Function to revoke tokens from an address
535      */
536     function revokeTokens(address _from, uint _amount) public onlyOwner {
537         // finally transfer all remaining tokens to owner
538         Grant storage grantInfo = grants[_from];
539         require(grantInfo.value > 0, "Grant does not exist");
540 
541         uint256 revocable = grantInfo.value.sub(grantInfo.transferred);
542         require(revocable > 0, "There is no remaining balance for this address");
543         require(revocable >= _amount, "Revocable balance is insufficient");
544         require(token.balanceOf(address(this)) >= _amount, "Contract Balance is insufficient");
545 
546         grantInfo.value = grantInfo.value.sub(_amount);
547         totalVestedTokens = totalVestedTokens.sub(_amount);
548 
549         token.burn(_amount);
550         emit BurnTokens(_amount);
551     }
552 
553     /**
554      * @dev Function to burn remaining tokens
555      */
556     function burnRemainingTokens() public onlyOwner {
557         // finally burn all remaining tokens to owner
558         uint amount = token.balanceOf(address(this));
559 
560         token.burn(amount);
561         emit BurnTokens(amount);
562     }
563 
564     /**
565      * @dev Function to withdraw remaining tokens;
566      */
567     function withdraw() public onlyOwner {
568         // finally withdraw all remaining tokens to owner
569         uint amount = token.balanceOf(address(this));
570         token.transfer(owner, amount);
571 
572         emit WithdrawAll(amount);
573     }
574 
575     /**
576      * @dev Function to lock vault not to be able to alloc more
577      */
578     function lockVault() public onlyOwner {
579         // finally lock vault
580         require(!locked);
581         locked = true;
582         emit LockedVault();
583     }
584 }
585 
586 /**
587  * @title Contract for distribution of tokens
588  * Copyright 2018, Rewards Blockchain Systems (Rewards.com)
589  */
590 contract RewardsTokenDistribution is Ownable {
591     using SafeMath for uint256;
592 
593     RewardsToken public token;
594     VestingVault public vestingVault;
595 
596     bool public finished;
597 
598     event TokenMinted(address indexed _to, uint _value, string _id);
599     event RevokeTokens(address indexed _from, uint _value);
600     event MintingFinished();
601    
602     modifier isAllowed() {
603         require(finished == false, "Minting was already finished");
604         _;
605     }
606 
607     /**
608      * @dev Constructor
609      * @param _token Contract address of RewardsToken
610      * @param _vestingVault Contract address of VestingVault
611      */
612     constructor (
613         RewardsToken _token,
614         VestingVault _vestingVault
615     ) public {
616         require(address(_token) != address(0), "Address should not be zero");
617         require(address(_vestingVault) != address(0), "Address should not be zero");
618 
619         token = _token;
620         vestingVault = _vestingVault;
621         finished = false;
622     }
623 
624     /**
625      * @dev Function to allocate tokens for normal contributor
626      * @param _to Address of a contributor
627      * @param _value Value that represents tokens amount allocated for a contributor
628      */
629     function allocNormalUser(address _to, uint _value) public onlyOwner isAllowed {
630         token.mint(_to, _value);
631         emit TokenMinted(_to, _value, "Allocated Tokens To User");
632     }
633 
634     /**
635      * @dev Function to allocate tokens for vested contributor
636      * @param _to Withdraw address that tokens will be sent
637      * @param _value Amount to hold during vesting period
638      * @param _start Unix epoch time that vesting starts from
639      * @param _duration Seconds amount of vesting duration
640      * @param _cliff Seconds amount of vesting cliff
641      * @param _scheduleTimes Array of Unix epoch times for vesting schedules
642      * @param _scheduleValues Array of Amount for vesting schedules
643      * @param _level Indicator that will represent types of vesting
644      */
645     function allocVestedUser(
646         address _to, uint _value, uint _start, uint _duration, uint _cliff, uint[] memory _scheduleTimes,
647         uint[] memory _scheduleValues, uint _level) public onlyOwner isAllowed {
648         _value = vestingVault.grant(_to, _value, _start, _duration, _cliff, _scheduleTimes, _scheduleValues, _level);
649         token.mint(address(vestingVault), _value);
650         emit TokenMinted(_to, _value, "Allocated Vested Tokens To User");
651     }
652 
653     /**
654      * @dev Function to allocate tokens for normal contributors
655      * @param _holders Address of a contributor
656      * @param _amounts Value that represents tokens amount allocated for a contributor
657      */
658     function allocNormalUsers(address[] memory _holders, uint[] memory _amounts) public onlyOwner isAllowed {
659         require(_holders.length > 0, "Empty holder addresses");
660         require(_holders.length == _amounts.length, "Invalid arguments");
661         for (uint i = 0; i < _holders.length; i++) {
662             token.mint(_holders[i], _amounts[i]);
663             emit TokenMinted(_holders[i], _amounts[i], "Allocated Tokens To Users");
664         }
665     }
666     
667     /**
668      * @dev Function to revoke tokens from an address
669      */
670     function revokeTokensFromVestedUser(address _from, uint _amount) public onlyOwner {
671         vestingVault.revokeTokens(_from, _amount);
672         emit RevokeTokens(_from, _amount);
673     }
674 
675     /**
676      * @dev Function to get back Ownership of RewardToken Contract after minting finished
677      */
678     function transferBackTokenOwnership() public onlyOwner {
679         token.transferOwnership(owner);
680     }
681 
682     /**
683      * @dev Function to get back Ownership of VestingVault Contract after minting finished
684      */
685     function transferBackVestingVaultOwnership() public onlyOwner {
686         vestingVault.transferOwnership(owner);
687     }
688 
689     /**
690      * @dev Function to finish token distribution
691      */
692     function finalize() public onlyOwner {
693         token.finishMinting();
694         finished = true;
695         emit MintingFinished();
696     }
697 }