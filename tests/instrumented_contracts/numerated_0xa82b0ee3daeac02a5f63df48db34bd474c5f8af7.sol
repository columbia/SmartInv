1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 /**************************************************************
58  * @title Scale Token Contract
59  * @file Scale.sol
60  * @author Jared Downing and Kane Thomas of the Scale Network
61  * @version 1.0
62  *
63  * @section DESCRIPTION
64  *
65  * This is an ERC20-based token with staking and inflationary functionality.
66  *
67  *************************************************************/
68 
69 //////////////////////////////////
70 /// OpenZeppelin library imports
71 //////////////////////////////////
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     // SafeMath.sub will throw if there is not enough balance.
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     emit Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address _owner) public view returns (uint256 balance) {
137     return balances[_owner];
138   }
139 
140 }
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * @dev https://github.com/ethereum/EIPs/issues/20
158  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174 
175     balances[_from] = balances[_from].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178     emit Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184    *
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     emit Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(address _owner, address _spender) public view returns (uint256) {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
219     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224   /**
225    * @dev Decrease the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Mintable token
249  * @dev Simple ERC20 Token example, with mintable token creation
250  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
251  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
252  * Modified to allow minting for non-owner addresses
253  */
254 
255 contract MintableToken is StandardToken, Ownable {
256   event Mint(address indexed to, uint256 amount);
257 
258   /**
259    * @dev Function to mint tokens
260    * @param _to The address that will receive the minted tokens.
261    * @param _amount The amount of tokens to mint.
262    * @return A boolean that indicates if the operation was successful.
263    */
264   function mint(address _to, uint256 _amount) internal returns (bool) {
265     totalSupply = totalSupply.add(_amount);
266     balances[_to] = balances[_to].add(_amount);
267     emit Mint(_to, _amount);
268     emit Transfer(address(0), _to, _amount);
269     return true;
270   }
271 
272 }
273 
274 /**
275  * @title Contracts that should not own Ether
276  * @author Remco Bloemen <remco@2π.com>
277  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
278  * in the contract, it will allow the owner to reclaim this ether.
279  * @notice Ether can still be send to this contract by:
280  * calling functions labeled `payable`
281  * `selfdestruct(contract_address)`
282  * mining directly to the contract address
283 */
284 contract HasNoEther is Ownable {
285 
286   /**
287   * @dev Constructor that rejects incoming Ether
288   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
289   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
290   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
291   * we could use assembly to access msg.value.
292   */
293   constructor() public payable {
294     require(msg.value == 0);
295   }
296 
297   /**
298    * @dev Disallows direct send by settings a default function without the `payable` flag.
299    */
300   function() external {
301   }
302 
303   /**
304    * @dev Transfer all Ether held by the contract to the owner.
305    */
306   function reclaimEther() external onlyOwner {
307     assert(owner.send(address(this).balance));
308   }
309 }
310 
311 
312 /**
313  * @title Burnable Token
314  * @dev Token that can be irreversibly burned (destroyed).
315  */
316 contract BurnableToken is BasicToken {
317 
318   event Burn(address indexed burner, uint256 value);
319 
320   /**
321    * @dev Burns a specific amount of tokens.
322    * @param _value The amount of token to be burned.
323    */
324   function burn(uint256 _value) public {
325     _burn(msg.sender, _value);
326   }
327 
328   function _burn(address _who, uint256 _value) internal {
329     require(_value <= balances[_who]);
330     // no need to require value <= totalSupply, since that would imply the
331     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
332 
333     balances[_who] = balances[_who].sub(_value);
334     totalSupply = totalSupply.sub(_value);
335     emit Burn(_who, _value);
336     emit Transfer(_who, address(0), _value);
337   }
338 }
339 
340 //////////////////////////////////
341 /// Scale Token
342 //////////////////////////////////
343 
344 contract Scale is MintableToken, HasNoEther, BurnableToken {
345 
346     // Libraries
347     using SafeMath for uint;
348 
349     //////////////////////
350     // Token Information
351     //////////////////////
352     string public constant name = "SCALE";
353     string public constant symbol = "SCALE";
354     uint8 public constant  decimals = 18;
355 
356     ///////////////////////////////////////////////////////////
357     // Variables For Staking and Pooling
358     ///////////////////////////////////////////////////////////
359 
360     // -- Pool Minting Rates and Percentages -- //
361     // Pool for Scale distribution to rewards pool
362     // Set to 0 to prohibit issuing to the pool before it is assigned
363     address public pool = address(0);
364 
365     // Pool and Owner minted tokens per second
366     uint public poolMintRate;
367     uint public ownerMintRate;
368 
369     // Amount of Scale to be staked to the pool, staking, and owner, as calculated through their percentages
370     uint public poolMintAmount;
371     uint public stakingMintAmount;
372     uint public ownerMintAmount;
373 
374     // Scale distribution percentages
375     uint public poolPercentage = 70;
376     uint public ownerPercentage = 5;
377     uint public stakingPercentage = 25;
378 
379     // Last time minted for owner and pool
380     uint public ownerTimeLastMinted;
381     uint public poolTimeLastMinted;
382 
383     // -- Staking -- //
384     // Minted tokens per second
385     uint public stakingMintRate;
386 
387     // Total Scale currently staked
388     uint public totalScaleStaked;
389 
390     // Mapping of the timestamp => totalStaking that is created each time an address stakes or unstakes
391     mapping (uint => uint) totalStakingHistory;
392 
393     // Variable for staking accuracy. Set to 86400 for seconds in a day so that staking gains are based on the day an account begins staking.
394     uint timingVariable = 86400;
395 
396     // Address staking information
397     struct AddressStakeData {
398         uint stakeBalance;
399         uint initialStakeTime;
400         uint unstakeTime;
401         mapping (uint => uint) stakePerDay;
402     }
403 
404     // Track all tokens staked
405     mapping (address => AddressStakeData) public stakeBalances;
406 
407     // -- Inflation -- //
408     // Inflation rate begins at 100% per year and decreases by 30% per year until it reaches 10% where it decreases by 0.5% per year
409     uint256 inflationRate = 1000;
410 
411     // Used to manage when to inflate. Allowed to inflate once per year until the rate reaches 1%.
412     uint256 public lastInflationUpdate;
413 
414     // -- Events -- //
415     // Fired when tokens are staked
416     event Stake(address indexed staker, uint256 value);
417     // Fired when tokens are unstaked
418     event Unstake(address indexed unstaker, uint256 stakedAmount);
419     // Fired when a user claims their stake
420     event ClaimStake(address indexed claimer, uint256 stakedAmount, uint256 stakingGains);
421 
422     //////////////////////////////////////////////////
423     /// Scale Token Functionality
424     //////////////////////////////////////////////////
425 
426     /// @dev Scale token constructor
427     constructor() public {
428         // Assign owner
429         owner = msg.sender;
430 
431         // Assign initial owner supply
432         uint _initOwnerSupply = 10000000 ether;
433         // Mint given to owner only one-time
434         bool _success = mint(msg.sender, _initOwnerSupply);
435         // Require minting success
436         require(_success);
437 
438         // Set pool and owner last minted to ensure extra coins are not minted by either
439         ownerTimeLastMinted = now;
440         poolTimeLastMinted = now;
441 
442         // Set minting amount for pool, staking, and owner over the course of 1 year
443         poolMintAmount = _initOwnerSupply.mul(poolPercentage).div(100);
444         ownerMintAmount = _initOwnerSupply.mul(ownerPercentage).div(100);
445         stakingMintAmount = _initOwnerSupply.mul(stakingPercentage).div(100);
446 
447         // One year in seconds
448         uint _oneYearInSeconds = 31536000 ether;
449 
450         // Set the rate of coins minted per second for the pool, owner, and global staking
451         poolMintRate = calculateFraction(poolMintAmount, _oneYearInSeconds, decimals);
452         ownerMintRate = calculateFraction(ownerMintAmount, _oneYearInSeconds, decimals);
453         stakingMintRate = calculateFraction(stakingMintAmount, _oneYearInSeconds, decimals);
454 
455         // Set the last time inflation was updated to now so that the next time it can be updated is 1 year from now
456         lastInflationUpdate = now;
457     }
458 
459     /////////////
460     // Inflation
461     /////////////
462 
463     /// @dev the inflation rate begins at 100% and decreases by 30% every year until it reaches 10%
464     /// at 10% the rate begins to decrease by 0.5% until it reaches 1%
465     function adjustInflationRate() private {
466       // Make sure adjustInflationRate cannot be called for at least another year
467       lastInflationUpdate = now;
468 
469       // Decrease inflation rate by 30% each year
470       if (inflationRate > 100) {
471         inflationRate = inflationRate.sub(300);
472       }
473       // Inflation rate reaches 10%. Decrease inflation rate by 0.5% from here on out until it reaches 1%.
474       else if (inflationRate > 10) {
475         inflationRate = inflationRate.sub(5);
476       }
477 
478       adjustMintRates();
479     }
480 
481     /// @dev adjusts the mint rate when the yearly inflation update is called
482     function adjustMintRates() internal {
483 
484       // Calculate new mint amount of Scale that should be created per year.
485       poolMintAmount = totalSupply.mul(inflationRate).div(1000).mul(poolPercentage).div(100);
486       ownerMintAmount = totalSupply.mul(inflationRate).div(1000).mul(ownerPercentage).div(100);
487       stakingMintAmount = totalSupply.mul(inflationRate).div(1000).mul(stakingPercentage).div(100);
488 
489       // Adjust Scale created per-second for each rate
490       poolMintRate = calculateFraction(poolMintAmount, 31536000 ether, decimals);
491       ownerMintRate = calculateFraction(ownerMintAmount, 31536000 ether, decimals);
492       stakingMintRate = calculateFraction(stakingMintAmount, 31536000 ether, decimals);
493     }
494 
495     /// @dev anyone can call this function to update the inflation rate yearly
496     function updateInflationRate() public {
497 
498       // Require 1 year to have passed for every inflation adjustment
499       require(now.sub(lastInflationUpdate) >= 31536000);
500 
501       adjustInflationRate();
502     }
503 
504     /////////////
505     // Staking
506     /////////////
507 
508     /// @dev staking function which allows users to stake an amount of tokens to gain interest for up to 1 year
509     function stake(uint _stakeAmount) external {
510         // Require that tokens are staked successfully
511         require(stakeScale(msg.sender, _stakeAmount));
512     }
513 
514    /// @dev staking function which allows users to stake an amount of tokens for another user
515    function stakeFor(address _user, uint _amount) external {
516         // Stake for the user
517         require(stakeScale(_user, _amount));
518    }
519 
520    /// @dev Transfer tokens from the contract to the user when unstaking
521    /// @param _value uint256 the amount of tokens to be transferred
522    function transferFromContract(uint _value) internal {
523 
524      // Sanity check to make sure we are not transferring more than the contract has
525      require(_value <= balances[address(this)]);
526 
527      // Add to the msg.sender balance
528      balances[msg.sender] = balances[msg.sender].add(_value);
529      
530      // Subtract from the contract's balance
531      balances[address(this)] = balances[address(this)].sub(_value);
532 
533      // Fire an event for transfer
534      emit Transfer(address(this), msg.sender, _value);
535    }
536 
537    /// @dev stake function reduces the user's total available balance and adds it to their staking balance
538    /// @param _value how many tokens a user wants to stake
539    function stakeScale(address _user, uint256 _value) private returns (bool success) {
540 
541        // You can only stake / stakeFor as many tokens as you have
542        require(_value <= balances[msg.sender]);
543 
544        // Require the user is not in power down period
545        require(stakeBalances[_user].unstakeTime == 0);
546 
547        // Transfer tokens to contract address
548        transfer(address(this), _value);
549 
550        // Now as a day
551        uint _nowAsDay = now.div(timingVariable);
552 
553        // Adjust the new staking balance
554        uint _newStakeBalance = stakeBalances[_user].stakeBalance.add(_value);
555 
556        // If this is the initial stake time, save
557        if (stakeBalances[_user].stakeBalance == 0) {
558          // Save the time that the stake started
559          stakeBalances[_user].initialStakeTime = _nowAsDay;
560        }
561 
562        // Add stake amount to staked balance
563        stakeBalances[_user].stakeBalance = _newStakeBalance;
564 
565        // Assign the total amount staked at this day
566        stakeBalances[_user].stakePerDay[_nowAsDay] = _newStakeBalance;
567 
568        // Increment the total staked tokens
569        totalScaleStaked = totalScaleStaked.add(_value);
570 
571        // Set the new staking history
572        setTotalStakingHistory();
573 
574        // Fire an event for newly staked tokens
575        emit Stake(_user, _value);
576 
577        return true;
578    }
579 
580     /// @dev deposit a user's initial stake plus earnings if the user unstaked at least 14 days ago
581     function claimStake() external returns (bool) {
582 
583       // Require that at least 14 days have passed (days)
584       require(now.div(timingVariable).sub(stakeBalances[msg.sender].unstakeTime) >= 14);
585 
586       // Get the user's stake balance 
587       uint _userStakeBalance = stakeBalances[msg.sender].stakeBalance;
588 
589       // Calculate tokens to mint using unstakeTime, rewards are not received during power-down period
590       uint _tokensToMint = calculateStakeGains(stakeBalances[msg.sender].unstakeTime);
591 
592       // Clear out stored data from mapping
593       stakeBalances[msg.sender].stakeBalance = 0;
594       stakeBalances[msg.sender].initialStakeTime = 0;
595       stakeBalances[msg.sender].unstakeTime = 0;
596 
597       // Return the stake balance to the staker
598       transferFromContract(_userStakeBalance);
599 
600       // Mint the new tokens to the sender
601       mint(msg.sender, _tokensToMint);
602 
603       // Scale unstaked event
604       emit ClaimStake(msg.sender, _userStakeBalance, _tokensToMint);
605 
606       return true;
607     }
608 
609     /// @dev allows users to start the reclaim process for staked tokens and stake rewards
610     /// @return bool on success
611     function initUnstake() external returns (bool) {
612 
613         // Require that the user has not already started the unstaked process
614         require(stakeBalances[msg.sender].unstakeTime == 0);
615 
616         // Require that there was some amount staked
617         require(stakeBalances[msg.sender].stakeBalance > 0);
618 
619         // Log time that user started unstaking
620         stakeBalances[msg.sender].unstakeTime = now.div(timingVariable);
621 
622         // Subtract stake balance from totalScaleStaked
623         totalScaleStaked = totalScaleStaked.sub(stakeBalances[msg.sender].stakeBalance);
624 
625         // Set this every time someone adjusts the totalScaleStaked amount
626         setTotalStakingHistory();
627 
628         // Scale unstaked event
629         emit Unstake(msg.sender, stakeBalances[msg.sender].stakeBalance);
630 
631         return true;
632     }
633 
634     /// @dev function to let the user know how much time they have until they can claim their tokens from unstaking
635     /// @param _user to check the time until claimable of
636     /// @return uint time in seconds until they may claim
637     function timeUntilClaimAvaliable(address _user) view external returns (uint) {
638       return stakeBalances[_user].unstakeTime.add(14).mul(86400);
639     }
640 
641     /// @dev function to check the staking balance of a user
642     /// @param _user to check the balance of
643     /// @return uint of the stake balance
644     function stakeBalanceOf(address _user) view external returns (uint) {
645       return stakeBalances[_user].stakeBalance;
646     }
647 
648     /// @dev returns how much Scale a user has earned so far
649     /// @param _now is passed in to allow for a gas-free analysis
650     /// @return staking gains based on the amount of time passed since staking began
651     function getStakingGains(uint _now) view public returns (uint) {
652         if (stakeBalances[msg.sender].stakeBalance == 0) {
653           return 0;
654         }
655         return calculateStakeGains(_now.div(timingVariable));
656     }
657 
658     /// @dev Calculates staking gains 
659     /// @param _unstakeTime when the user stopped staking.
660     /// @return uint for total coins to be minted
661     function calculateStakeGains(uint _unstakeTime) view private returns (uint mintTotal)  {
662 
663       uint _initialStakeTimeInVariable = stakeBalances[msg.sender].initialStakeTime; // When the user started staking as a unique day in unix time
664       uint _timePassedSinceStakeInVariable = _unstakeTime.sub(_initialStakeTimeInVariable); // How much time has passed, in days, since the user started staking.
665       uint _stakePercentages = 0; // Keeps an additive track of the user's staking percentages over time
666       uint _tokensToMint = 0; // How many new Scale tokens to create
667       uint _lastDayStakeWasUpdated;  // Last day the totalScaleStaked was updated
668       uint _lastStakeDay; // Last day that the user staked
669 
670       // If user staked and init unstaked on the same day, gains are 0
671       if (_timePassedSinceStakeInVariable == 0) {
672         return 0;
673       }
674       // If user has been staking longer than 365 days, staked days after 365 days do not earn interest 
675       else if (_timePassedSinceStakeInVariable >= 365) {
676        _unstakeTime = _initialStakeTimeInVariable.add(365);
677        _timePassedSinceStakeInVariable = 365;
678       }
679       // Average this msg.sender's relative percentage ownership of totalScaleStaked throughout each day since they started staking
680       for (uint i = _initialStakeTimeInVariable; i < _unstakeTime; i++) {
681 
682         // Total amount user has staked on i day
683         uint _stakeForDay = stakeBalances[msg.sender].stakePerDay[i];
684 
685         // If this was a day that the user staked or added stake
686         if (_stakeForDay != 0) {
687 
688             // If the day exists add it to the percentages
689             if (totalStakingHistory[i] != 0) {
690 
691                 // If the day does exist add it to the number to be later averaged as a total average percentage of total staking
692                 _stakePercentages = _stakePercentages.add(calculateFraction(_stakeForDay, totalStakingHistory[i], decimals));
693 
694                 // Set the last day someone staked
695                 _lastDayStakeWasUpdated = totalStakingHistory[i];
696             }
697             else {
698                 // Use the last day found in the totalStakingHistory mapping
699                 _stakePercentages = _stakePercentages.add(calculateFraction(_stakeForDay, _lastDayStakeWasUpdated, decimals));
700             }
701 
702             _lastStakeDay = _stakeForDay;
703         }
704         else {
705 
706             // If the day exists add it to the percentages
707             if (totalStakingHistory[i] != 0) {
708 
709                 // If the day does exist add it to the number to be later averaged as a total average percentage of total staking
710                 _stakePercentages = _stakePercentages.add(calculateFraction(_lastStakeDay, totalStakingHistory[i], decimals));
711 
712                 // Set the last day someone staked
713                 _lastDayStakeWasUpdated = totalStakingHistory[i];
714             }
715             else {
716                 // Use the last day found in the totalStakingHistory mapping
717                 _stakePercentages = _stakePercentages.add(calculateFraction(_lastStakeDay, _lastDayStakeWasUpdated, decimals));
718             }
719         }
720       }
721         // Get the account's average percentage staked of the total stake over the course of all days they have been staking
722         uint _stakePercentageAverage = calculateFraction(_stakePercentages, _timePassedSinceStakeInVariable, 0);
723 
724         // Calculate this account's mint rate per second while staking
725         uint _finalMintRate = stakingMintRate.mul(_stakePercentageAverage);
726 
727         // Account for 18 decimals when calculating the amount of tokens to mint
728         _finalMintRate = _finalMintRate.div(1 ether);
729 
730         // Calculate total tokens to be minted. Multiply by timingVariable to convert back to seconds.
731         _tokensToMint = calculateMintTotal(_timePassedSinceStakeInVariable.mul(timingVariable), _finalMintRate);
732 
733         return  _tokensToMint;
734     }
735 
736     /// @dev set the new totalStakingHistory mapping to the current timestamp and totalScaleStaked
737     function setTotalStakingHistory() private {
738 
739       // Get now in terms of the variable staking accuracy (days in Scale's case)
740       uint _nowAsTimingVariable = now.div(timingVariable);
741 
742       // Set the totalStakingHistory as a timestamp of the totalScaleStaked today
743       totalStakingHistory[_nowAsTimingVariable] = totalScaleStaked;
744     }
745 
746     /////////////
747     // Scale Owner Claiming
748     /////////////
749 
750     /// @dev allows contract owner to claim their allocated mint
751     function ownerClaim() external onlyOwner {
752 
753         require(now > ownerTimeLastMinted);
754 
755         uint _timePassedSinceLastMint; // The amount of time passed since the owner claimed in seconds
756         uint _tokenMintCount; // The amount of new tokens to mint
757         bool _mintingSuccess; // The success of minting the new Scale tokens
758 
759         // Calculate the number of seconds that have passed since the owner last took a claim
760         _timePassedSinceLastMint = now.sub(ownerTimeLastMinted);
761 
762         assert(_timePassedSinceLastMint > 0);
763 
764         // Determine the token mint amount, determined from the number of seconds passed and the ownerMintRate
765         _tokenMintCount = calculateMintTotal(_timePassedSinceLastMint, ownerMintRate);
766 
767         // Mint the owner's tokens; this also increases totalSupply
768         _mintingSuccess = mint(msg.sender, _tokenMintCount);
769 
770         require(_mintingSuccess);
771 
772         // New minting was a success. Set last time minted to current block.timestamp (now)
773         ownerTimeLastMinted = now;
774     }
775 
776     ////////////////////////////////
777     // Scale Pool Distribution
778     ////////////////////////////////
779 
780     // @dev anyone can call this function that mints Scale to the pool dedicated to Scale distribution to rewards pool
781     function poolIssue() public {
782 
783         // Do not allow tokens to be minted to the pool until the pool is set
784         require(pool != address(0));
785 
786         // Make sure time has passed since last minted to pool
787         require(now > poolTimeLastMinted);
788         require(pool != address(0));
789 
790         uint _timePassedSinceLastMint; // The amount of time passed since the pool claimed in seconds
791         uint _tokenMintCount; // The amount of new tokens to mint
792         bool _mintingSuccess; // The success of minting the new Scale tokens
793 
794         // Calculate the number of seconds that have passed since the owner last took a claim
795         _timePassedSinceLastMint = now.sub(poolTimeLastMinted);
796 
797         assert(_timePassedSinceLastMint > 0);
798 
799         // Determine the token mint amount, determined from the number of seconds passed and the ownerMintRate
800         _tokenMintCount = calculateMintTotal(_timePassedSinceLastMint, poolMintRate);
801 
802         // Mint the owner's tokens; this also increases totalSupply
803         _mintingSuccess = mint(pool, _tokenMintCount);
804 
805         require(_mintingSuccess);
806 
807         // New minting was a success! Set last time minted to current block.timestamp (now)
808         poolTimeLastMinted = now;
809     }
810 
811     /// @dev sets the address for the rewards pool
812     /// @param _newAddress pool Address
813     function setPool(address _newAddress) public onlyOwner {
814         pool = _newAddress;
815     }
816 
817     ////////////////////////////////
818     // Helper Functions
819     ////////////////////////////////
820 
821     /// @dev calculateFraction allows us to better handle the Solidity ugliness of not having decimals as a native type
822     /// @param _numerator is the top part of the fraction we are calculating
823     /// @param _denominator is the bottom part of the fraction we are calculating
824     /// @param _precision tells the function how many significant digits to calculate out to
825     /// @return quotient returns the result of our fraction calculation
826     function calculateFraction(uint _numerator, uint _denominator, uint _precision) pure private returns(uint quotient) {
827         // Take passed value and expand it to the required precision
828         _numerator = _numerator.mul(10 ** (_precision + 1));
829         // Handle last-digit rounding
830         uint _quotient = ((_numerator.div(_denominator)) + 5) / 10;
831         return (_quotient);
832     }
833 
834     /// @dev Determines the amount of Scale to create based on the number of seconds that have passed
835     /// @param _timeInSeconds is the time passed in seconds to mint for
836     /// @return uint with the calculated number of new tokens to mint
837     function calculateMintTotal(uint _timeInSeconds, uint _mintRate) pure private returns(uint mintAmount) {
838         // Calculates the amount of tokens to mint based upon the number of seconds passed
839         return(_timeInSeconds.mul(_mintRate));
840     }
841 }