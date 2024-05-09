1 pragma solidity ^0.4.24;
2 
3 /**************************************************************
4  * @title Scale Token Contract
5  * @file Scale.sol
6  * @author Jared Downing and Kane Thomas of the Scale Network
7  * @version 1.0
8  *
9  * @section DESCRIPTION
10  *
11  * This is an ERC20-based token with staking and inflationary functionality.
12  *
13  *************************************************************/
14 
15 //////////////////////////////////
16 /// OpenZeppelin library imports
17 //////////////////////////////////
18 
19 /**
20  * @title ERC20Basic
21  * @dev Simpler version of ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/179
23  */
24 contract ERC20Basic {
25   uint256 public totalSupply;
26   function balanceOf(address who) public view returns (uint256);
27   function transfer(address to, uint256 value) public returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   constructor() public {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     require(newOwner != address(0));
67     emit OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71 }
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
311 //////////////////////////////////
312 /// Scale Token
313 //////////////////////////////////
314 
315 contract Scale is MintableToken, HasNoEther {
316 
317     // Libraries
318     using SafeMath for uint;
319 
320     //////////////////////
321     // Token Information
322     //////////////////////
323     string public constant name = "SCALE";
324     string public constant symbol = "SCALE";
325     uint8 public constant  decimals = 18;
326 
327     ///////////////////////////////////////////////////////////
328     // Variables For Staking and Pooling
329     ///////////////////////////////////////////////////////////
330 
331     // -- Pool Minting Rates and Percentages -- //
332     // Pool for Scale distribution to rewards pool
333     // Set to address 0 to prohibit minting to the pool before it is assigned
334     address public pool = address(0);
335 
336     // Pool and Owner minted tokens per second
337     uint public poolMintRate;
338     uint public ownerMintRate;
339 
340     // Amount of Scale to be staked to the pool, staking, and mint, as calculated through their percentages
341     uint public poolMintAmount;
342     uint public stakingMintAmount;
343     uint public ownerMintAmount;
344 
345     // Scale distribution percentages
346     uint public poolPercentage = 70;
347     uint public ownerPercentage = 5;
348     uint public stakingPercentage = 25;
349 
350     // Last time minted for owner and pool
351     uint public ownerTimeLastMinted;
352     uint public poolTimeLastMinted;
353 
354     // -- Staking -- //
355     // Minted tokens per second
356     uint public stakingMintRate;
357 
358     // Total Scale currently staked
359     uint public totalScaleStaked;
360 
361     // Mapping of the timestamp => totalStaking that is created each time an address stakes or unstakes
362     mapping (uint => uint) totalStakingHistory;
363 
364     // Variable for staking accuracy. Set to 86400 for seconds in a day so that staking gains are based on the day an account begins staking.
365     uint timingVariable = 86400;
366 
367     // Address staking information
368     struct AddressStakeData {
369         uint stakeBalance;
370         uint initialStakeTime;
371     }
372 
373     // Track all tokens staked
374     mapping (address => AddressStakeData) public stakeBalances;
375 
376     // -- Inflation -- //
377     // Inflation rate begins at 100% per year and decreases by 30% per year until it 
378     // reaches 10% where it decreases by 0.5% per year, stopping at 1% per year.
379     uint256 inflationRate = 1000;
380 
381     // Used to manage when to inflate. Allowed to inflate once per year until the rate reaches 1%.
382     uint256 public lastInflationUpdate;
383 
384     // -- Events -- //
385     // Fired when tokens are staked
386     event Stake(address indexed staker, uint256 value);
387     // Fired when tokens are unstaked
388     event Unstake(address indexed unstaker, uint256 stakedAmount, uint256 stakingGains);
389 
390     //////////////////////////////////////////////////
391     /// Scale Token Functionality
392     //////////////////////////////////////////////////
393 
394     /// @dev Scale token constructor
395     constructor() public {
396         // Assign owner
397         owner = msg.sender;
398 
399         // Assign initial owner supply
400         uint _initOwnerSupply = 10000000 ether;
401         // Mint given to owner only one-time
402         bool _success = mint(msg.sender, _initOwnerSupply);
403         // Require minting success
404         require(_success);
405 
406         // Set pool and owner last minted to ensure extra coins are not minted by either
407         ownerTimeLastMinted = now;
408         poolTimeLastMinted = now;
409 
410         // Set minting amount for pool, staking, and owner over the course of 1 year
411         poolMintAmount = _initOwnerSupply.mul(poolPercentage).div(100);
412         ownerMintAmount = _initOwnerSupply.mul(ownerPercentage).div(100);
413         stakingMintAmount = _initOwnerSupply.mul(stakingPercentage).div(100);
414 
415         // One year in seconds
416         uint _oneYearInSeconds = 31536000 ether;
417 
418         // Set the rate of coins minted per second for the pool, owner, and global staking
419         poolMintRate = calculateFraction(poolMintAmount, _oneYearInSeconds, decimals);
420         ownerMintRate = calculateFraction(ownerMintAmount, _oneYearInSeconds, decimals);
421         stakingMintRate = calculateFraction(stakingMintAmount, _oneYearInSeconds, decimals);
422 
423         // Set the last time inflation was update to now so that the next time it can be updated is 1 year from now
424         lastInflationUpdate = now;
425     }
426 
427     /////////////
428     // Inflation
429     /////////////
430 
431     /// @dev the inflation rate begins at 100% and decreases by 30% every year until it reaches 10%
432     /// at 10% the rate begins to decrease by 0.5% until it reaches 1%
433     function adjustInflationRate() private {
434 
435 
436       // Make sure adjustInflationRate cannot be called for at least another year
437       lastInflationUpdate = now;
438 
439       // Decrease inflation rate by 30% each year
440       if (inflationRate > 100) {
441 
442         inflationRate = inflationRate.sub(300);
443       }
444       // Inflation rate reaches 10%. Decrease inflation rate by 0.5% from here on out until it reaches 1%.
445       else if (inflationRate > 10) {
446 
447         inflationRate = inflationRate.sub(5);
448       }
449 
450       // Calculate new mint amount of Scale that should be created per year.
451       poolMintAmount = totalSupply.mul(inflationRate).div(1000).mul(poolPercentage).div(100);
452       ownerMintAmount = totalSupply.mul(inflationRate).div(1000).mul(ownerPercentage).div(100);
453       stakingMintAmount = totalSupply.mul(inflationRate).div(1000).mul(stakingPercentage).div(100);
454 
455         // Adjust Scale created per-second for each rate
456         poolMintRate = calculateFraction(poolMintAmount, 31536000 ether, decimals);
457         ownerMintRate = calculateFraction(ownerMintAmount, 31536000 ether, decimals);
458         stakingMintRate = calculateFraction(stakingMintAmount, 31536000 ether, decimals);
459     }
460 
461     /// @dev anyone can call this function to update the inflation rate yearly
462     function updateInflationRate() public {
463 
464       // Require 1 year to have passed for every inflation adjustment
465       require(now.sub(lastInflationUpdate) >= 31536000);
466 
467       adjustInflationRate();
468 
469     }
470 
471     /////////////
472     // Staking
473     /////////////
474 
475     /// @dev staking function which allows users to stake an amount of tokens to gain interest for up to 365 days
476     /// @param _stakeAmount how many tokens a user wants to stake
477     function stakeScale(uint _stakeAmount) external {
478 
479         // Require that tokens are staked successfully
480         require(stake(msg.sender, _stakeAmount));
481     }
482 
483     /// @dev stake for a seperate address
484     /// @param _stakeAmount how many tokens a user wants to stake
485     function stakeFor(address _user, uint _stakeAmount) external {
486 
487       // You can only stake tokens for another user if they have not already staked tokens
488       require(stakeBalances[_user].stakeBalance == 0);
489 
490       // Transfer Scale from to the msg.sender to the user
491       transfer( _user, _stakeAmount);
492 
493       // Stake for the user
494       stake(_user, _stakeAmount);
495     }
496 
497     /// @dev stake function reduces the user's total available balance and adds it to their staking balance
498     /// @param _value how many tokens a user wants to stake
499     function stake(address _user, uint256 _value) private returns (bool success) {
500 
501         // You can only stake as many tokens as you have
502         require(_value <= balances[_user]);
503         // You can only stake tokens if you have not already staked tokens
504         require(stakeBalances[_user].stakeBalance == 0);
505 
506         // Subtract stake amount from regular token balance
507         balances[_user] = balances[_user].sub(_value);
508 
509         // Add stake amount to staked balance
510         stakeBalances[_user].stakeBalance = _value;
511 
512         // Increment the staking staked tokens value
513         totalScaleStaked = totalScaleStaked.add(_value);
514 
515         // Save the time that the stake started
516         stakeBalances[_user].initialStakeTime = now.div(timingVariable);
517 
518         // Set the new staking history
519         setTotalStakingHistory();
520 
521         // Fire an event to tell the world of the newly staked tokens
522         emit Stake(_user, _value);
523 
524         return true;
525     }
526 
527     /// @dev returns how much Scale a user has earned so far
528     /// @param _now is passed in to allow for a gas-free analysis
529     /// @return staking gains based on the amount of time passed since staking began
530     function getStakingGains(uint _now) view public returns (uint) {
531 
532         if (stakeBalances[msg.sender].stakeBalance == 0) {
533 
534           return 0;
535         }
536 
537         return calculateStakeGains(_now);
538     }
539 
540     /// @dev allows users to reclaim any staked tokens
541     /// @return bool on success
542     function unstake() external returns (bool) {
543 
544         // Require that there was some amount vested
545         require(stakeBalances[msg.sender].stakeBalance > 0);
546 
547         // Require that at least 7 timing variables have passed (days)
548         require(now.div(timingVariable).sub(stakeBalances[msg.sender].initialStakeTime) >= 7);
549 
550         // Calculate tokens to mint
551         uint _tokensToMint = calculateStakeGains(now);
552 
553         balances[msg.sender] = balances[msg.sender].add(stakeBalances[msg.sender].stakeBalance);
554 
555         // Subtract stake balance from totalScaleStaked
556         totalScaleStaked = totalScaleStaked.sub(stakeBalances[msg.sender].stakeBalance);
557 
558         // Mint the new tokens to the sender
559         mint(msg.sender, _tokensToMint);
560 
561         // Scale unstaked event
562         emit Unstake(msg.sender, stakeBalances[msg.sender].stakeBalance, _tokensToMint);
563 
564         // Clear out stored data from mapping
565         stakeBalances[msg.sender].stakeBalance = 0;
566         stakeBalances[msg.sender].initialStakeTime = 0;
567 
568         // Set this every time someone adjusts the totalScaleStaking amount
569         setTotalStakingHistory();
570 
571         return true;
572     }
573 
574     /// @dev Helper function to claimStake that modularizes the minting via staking calculation
575     /// @param _now when the user stopped staking. Passed in as a variable to allow for checking without using gas from the getStakingGains function.
576     /// @return uint for total coins to be minted
577     function calculateStakeGains(uint _now) view private returns (uint mintTotal)  {
578 
579       uint _nowAsTimingVariable = _now.div(timingVariable);    // Today as a unique value in unix time
580       uint _initialStakeTimeInVariable = stakeBalances[msg.sender].initialStakeTime; // When the user started staking as a unique day in unix time
581       uint _timePassedSinceStakeInVariable = _nowAsTimingVariable.sub(_initialStakeTimeInVariable); // How much time has passed, in days, since the user started staking.
582       uint _stakePercentages = 0; // Keeps an additive track of the user's staking percentages over time
583       uint _tokensToMint = 0; // How many new Scale tokens to create
584       uint _lastUsedVariable;  // Last day the totalScaleStaked was updated
585 
586       // Average this msg.sender's relative percentage ownership of totalScaleStaked throughout each day since they started staking
587       for (uint i = _initialStakeTimeInVariable; i < _nowAsTimingVariable; i++) {
588 
589         // If the day exists add it to the percentages
590         if (totalStakingHistory[i] != 0) {
591 
592            // If the day does exist add it to the number to be later averaged as a total average percentage of total staking
593           _stakePercentages = _stakePercentages.add(calculateFraction(stakeBalances[msg.sender].stakeBalance, totalStakingHistory[i], decimals));
594 
595           // Set this as the last day someone staked
596           _lastUsedVariable = totalStakingHistory[i];
597         }
598         else {
599 
600           // Use the last day found in the totalStakingHistory mapping
601           _stakePercentages = _stakePercentages.add(calculateFraction(stakeBalances[msg.sender].stakeBalance, _lastUsedVariable, decimals));
602         }
603 
604       }
605 
606         // Get the account's average percentage staked of the total stake over the course of all days they have been staking
607         uint _stakePercentageAverage = calculateFraction(_stakePercentages, _timePassedSinceStakeInVariable, 0);
608 
609         // Calculate this account's mint rate per second while staking
610         uint _finalMintRate = stakingMintRate.mul(_stakePercentageAverage);
611 
612         // Account for 18 decimals when calculating the amount of tokens to mint
613         _finalMintRate = _finalMintRate.div(1 ether);
614 
615         // Calculate total tokens to be minted. Multiply by timingVariable to convert back to seconds.
616         if (_timePassedSinceStakeInVariable >= 365) {
617 
618           // Tokens were staked for the maximum amount of time, one year. Give them one year's worth of tokens. ( this limit is placed to avoid gas limits)
619           _tokensToMint = calculateMintTotal(timingVariable.mul(365), _finalMintRate);
620         }
621         else {
622 
623           // Tokens were staked for less than the maximum amount of time
624           _tokensToMint = calculateMintTotal(_timePassedSinceStakeInVariable.mul(timingVariable), _finalMintRate);
625         }
626 
627         return  _tokensToMint;
628     }
629 
630     /// @dev set the new totalStakingHistory mapping to the current timestamp and totalScaleStaked
631     function setTotalStakingHistory() private {
632 
633       // Get now in terms of the variable staking accuracy (days in Scale's case)
634       uint _nowAsTimingVariable = now.div(timingVariable);
635 
636       // Set the totalStakingHistory as a timestamp of the totalScaleStaked today
637       totalStakingHistory[_nowAsTimingVariable] = totalScaleStaked;
638     }
639 
640     /// @dev Allows user to check their staked balance
641     /// @return staked balance
642     function getStakedBalance() view external returns (uint stakedBalance) {
643 
644         return stakeBalances[msg.sender].stakeBalance;
645     }
646 
647     /////////////
648     // Scale Owner Claiming
649     /////////////
650 
651     /// @dev allows contract owner to claim their mint
652     function ownerClaim() external onlyOwner {
653 
654         require(now > ownerTimeLastMinted);
655 
656         uint _timePassedSinceLastMint; // The amount of time passed since the owner claimed in seconds
657         uint _tokenMintCount; // The amount of new tokens to mint
658         bool _mintingSuccess; // The success of minting the new Scale tokens
659 
660         // Calculate the number of seconds that have passed since the owner last took a claim
661         _timePassedSinceLastMint = now.sub(ownerTimeLastMinted);
662 
663         assert(_timePassedSinceLastMint > 0);
664 
665         // Determine the token mint amount, determined from the number of seconds passed and the ownerMintRate
666         _tokenMintCount = calculateMintTotal(_timePassedSinceLastMint, ownerMintRate);
667 
668         // Mint the owner's tokens; this also increases totalSupply
669         _mintingSuccess = mint(msg.sender, _tokenMintCount);
670 
671         require(_mintingSuccess);
672 
673         // New minting was a success. Set last time minted to current block.timestamp (now)
674         ownerTimeLastMinted = now;
675     }
676 
677     ////////////////////////////////
678     // Scale Pool Distribution
679     ////////////////////////////////
680 
681     /// @dev anyone can call this function that mints Scale to the pool dedicated to Scale distribution to rewards pool
682     function poolIssue() public {
683 
684         // Do not allow tokens to be minted to the pool until the pool is set
685         require(pool != address(0));
686 
687         // Make sure time has passed since last minted to pool
688         require(now > poolTimeLastMinted);
689         require(pool != address(0));
690 
691         uint _timePassedSinceLastMint; // The amount of time passed since the pool claimed in seconds
692         uint _tokenMintCount; // The amount of new tokens to mint
693         bool _mintingSuccess; // The success of minting the new Scale tokens
694 
695         // Calculate the number of seconds that have passed since the pool last took a claim
696         _timePassedSinceLastMint = now.sub(poolTimeLastMinted);
697 
698         assert(_timePassedSinceLastMint > 0);
699 
700         // Determine the token mint amount, determined from the number of seconds passed and the poolMintRate
701         _tokenMintCount = calculateMintTotal(_timePassedSinceLastMint, poolMintRate);
702 
703         // Mint the pool's tokens; this also increases totalSupply
704         _mintingSuccess = mint(pool, _tokenMintCount);
705 
706         require(_mintingSuccess);
707 
708         // New minting was a success! Set last time minted to current block.timestamp (now)
709         poolTimeLastMinted = now;
710     }
711 
712     /// @dev sets the address for the rewards pool
713     /// @param _newAddress pool Address
714     function setPool(address _newAddress) public onlyOwner {
715 
716         pool = _newAddress;
717     }
718 
719     ////////////////////////////////
720     // Helper Functions
721     ////////////////////////////////
722 
723     /// @dev calculateFraction allows us to better handle the Solidity ugliness of not having decimals as a native type
724     /// @param _numerator is the top part of the fraction we are calculating
725     /// @param _denominator is the bottom part of the fraction we are calculating
726     /// @param _precision tells the function how many significant digits to calculate out to
727     /// @return quotient returns the result of our fraction calculation
728     function calculateFraction(uint _numerator, uint _denominator, uint _precision) pure private returns(uint quotient) {
729         // Take passed value and expand it to the required precision
730         _numerator = _numerator.mul(10 ** (_precision + 1));
731         // Handle last-digit rounding
732         uint _quotient = ((_numerator.div(_denominator)) + 5) / 10;
733         return (_quotient);
734     }
735 
736     /// @dev Determines the amount of Scale to create based on the number of seconds that have passed
737     /// @param _timeInSeconds is the time passed in seconds to mint for
738     /// @param _mintRate the mint rate per second 
739     /// @return uint with the calculated number of new tokens to mint
740     function calculateMintTotal(uint _timeInSeconds, uint _mintRate) pure private returns(uint mintAmount) {
741         // Calculates the amount of tokens to mint based upon the number of seconds passed
742         return(_timeInSeconds.mul(_mintRate));
743     }
744 
745 }