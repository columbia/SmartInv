1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() public {
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 /**************************************************************
61  * @title Kek Token Contract
62  * @file Kek.sol
63  * @version 1.0
64  *
65  * @section LICENSE
66  *
67  * Contact for licensing details. All rights reserved.
68  *
69  * @section DESCRIPTION
70  *
71  * This is an ERC20-based token with staking functionality.
72  *
73  *************************************************************/
74 //////////////////////////////////
75 /// OpenZeppelin library imports
76 //////////////////////////////////
77 
78 ///* Truffle format 
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   function add(uint256 a, uint256 b) internal pure returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) balances;
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     // SafeMath.sub will throw if there is not enough balance.
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 
164 
165 
166 
167 
168 
169 /**
170  * @title ERC20 interface
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender) public view returns (uint256);
174   function transferFrom(address from, address to, uint256 value) public returns (bool);
175   function approve(address spender, uint256 value) public returns (bool);
176   event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  */
186 contract StandardToken is ERC20, BasicToken {
187 
188   mapping (address => mapping (address => uint256)) internal allowed;
189 
190 
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    *
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220     Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifying the amount of tokens still available for the spender.
229    */
230   function allowance(address _owner, address _spender) public view returns (uint256) {
231     return allowed[_owner][_spender];
232   }
233 
234   /**
235    * @dev Increase the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   /**
251    * @dev Decrease the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To decrement
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _subtractedValue The amount of tokens to decrease the allowance by.
259    */
260   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 
274 
275 
276 
277 /**
278  * @title Mintable token
279  * @dev Simple ERC20 Token example, with mintable token creation
280  */
281 
282 contract MintableToken is StandardToken, Ownable {
283   event Mint(address indexed to, uint256 amount);
284   //event MintFinished();
285 
286   //bool public mintingFinished = false;
287 
288   /*
289   modifier canMint() {
290     require(!mintingFinished);
291     _;
292   }
293   */
294 
295   /**
296    * @dev Function to mint tokens
297    * @param _to The address that will receive the minted tokens.
298    * @param _amount The amount of tokens to mint.
299    * @return A boolean that indicates if the operation was successful.
300    */
301   function mint(address _to, uint256 _amount) internal returns (bool) {
302     totalSupply = totalSupply.add(_amount);
303     balances[_to] = balances[_to].add(_amount);
304     Mint(_to, _amount);
305     Transfer(address(0), _to, _amount);
306     return true;
307   }
308 
309   /**
310    * @dev Function to stop minting new tokens.
311    * @return True if the operation was successful.
312    
313   function finishMinting() onlyOwner canMint public returns (bool) {
314     mintingFinished = true;
315     MintFinished();
316     return true;
317   }
318   */
319 }
320 
321 
322 
323 
324 
325 /**
326  * @title Contracts that should not own Ether
327  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
328  * in the contract, it will allow the owner to reclaim this ether.
329  * @notice Ether can still be send to this contract by:
330  * calling functions labeled `payable`
331  * `selfdestruct(contract_address)`
332  * mining directly to the contract address
333 */
334 contract HasNoEther is Ownable {
335 
336   /**
337   * @dev Constructor that rejects incoming Ether
338   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
339   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
340   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
341   * we could use assembly to access msg.value.
342   */
343   function HasNoEther() public payable {
344     require(msg.value == 0);
345   }
346 
347   /**
348    * @dev Disallows direct send by settings a default function without the `payable` flag.
349    */
350   function() external {
351   }
352 
353   /**
354    * @dev Transfer all Ether held by the contract to the owner.
355    */
356   function reclaimEther() external onlyOwner {
357     assert(owner.send(this.balance));
358   }
359 }
360 
361 
362 ///* Remix format
363 //import "./MintableToken.sol";
364 //import "./HasNoEther.sol";
365 
366 
367 contract Kek is MintableToken, HasNoEther 
368 {
369     // Using libraries 
370     using SafeMath for uint;
371 
372     //////////////////////////////////////////////////
373     /// State Variables for the Kek token contract
374     //////////////////////////////////////////////////
375     
376     //////////////////////
377     // ERC20 token state
378     //////////////////////
379     
380     /**
381     These state vars are handled in the OpenZeppelin libraries;
382     we display them here for the developer's information.
383     ***
384     // ERC20Basic - Store account balances
385     mapping (address => uint256) public balances;
386 
387     // StandardToken - Owner of account approves transfer of an amount to another account
388     mapping (address => mapping (address => uint256)) public allowed;
389 
390     // 
391     uint256 public totalSupply;
392     */
393     
394     //////////////////////
395     // Human token state
396     //////////////////////
397     string public constant name = "Kek.finance";
398     string public constant symbol = "KEK";
399     uint8 public constant  decimals = 18;
400 
401     ///////////////////////////////////////////////////////////
402     // State vars for custom staking and budget functionality
403     ///////////////////////////////////////////////////////////
404 
405     // Owner last minted time
406     uint public ownerTimeLastMinted;
407     // Owner minted tokens per second
408     uint public ownerMintRate;
409 
410     /// Stake minting
411     // Minted tokens per second for all stakers
412     uint private globalMintRate;
413     // Total tokens currently staked
414     uint public totalKekStaked; 
415 
416     // struct that will hold user stake
417     struct TokenStakeData {
418         uint initialStakeBalance;
419         uint initialStakeTime;
420         uint initialStakePercentage;
421         address stakeSplitAddress;
422     }
423     
424     // Track all tokens staked
425     mapping (address => TokenStakeData) public stakeBalances;
426 
427     // Fire a loggable event when tokens are staked
428     event Stake(address indexed staker, address indexed stakeSplitAddress, uint256 value);
429 
430     // Fire a loggable event when staked tokens are vested
431     event Vest(address indexed vester, address indexed stakeSplitAddress, uint256 stakedAmount, uint256 stakingGains);
432 
433     //////////////////////////////////////////////////
434     /// Begin Kek token functionality
435     //////////////////////////////////////////////////
436 
437     /// @dev Kek token constructor
438     function Kek() public
439     {
440         // Define owner
441         owner = msg.sender;
442         // Define initial owner supply. (ether here is used only to get the decimals right)
443         uint _initOwnerSupply = 82000 ether;
444         // One-time bulk mint given to owner
445         bool _success = mint(msg.sender, _initOwnerSupply);
446         // Abort if initial minting failed for whatever reason
447         require(_success);
448 
449         ////////////////////////////////////
450         // Set up state minting variables
451         ////////////////////////////////////
452 
453         // Set last minted to current block.timestamp ('now')
454         ownerTimeLastMinted = now;
455         
456         // 4100 minted tokens per day, 86400 seconds in a day
457         ownerMintRate = calculateFraction(4100, 86400, decimals);
458         
459         // 5,000,000 targeted minted tokens per year via staking; 31,536,000 seconds per year
460         globalMintRate = calculateFraction(5000000, 31536000, decimals);
461     }
462 
463     /// @dev staking function which allows users to stake an amount of tokens to gain interest for up to 10 days 
464     function stakeKek(uint _stakeAmount) external
465     {
466         // Require that tokens are staked successfully
467         require(stakeTokens(_stakeAmount));
468     }
469 
470     /// @dev staking function which allows users to split the interest earned with another address
471     function stakeKekSplit(uint _stakeAmount, address _stakeSplitAddress) external
472     {
473         // Require that a Kek split actually be split with an address
474         require(_stakeSplitAddress > 0);
475         // Store split address into stake mapping
476         stakeBalances[msg.sender].stakeSplitAddress = _stakeSplitAddress;
477         // Require that tokens are staked successfully
478         require(stakeTokens(_stakeAmount));
479 
480     }
481 
482     /// @dev allows users to reclaim any staked tokens
483     /// @return bool on success
484     function claimStake() external returns (bool success)
485     {
486         /// Sanity checks: 
487         // require that there was some amount vested
488         require(stakeBalances[msg.sender].initialStakeBalance > 0);
489         // require that time has elapsed
490         require(now > stakeBalances[msg.sender].initialStakeTime);
491 
492         // Calculate the time elapsed since the tokens were originally staked
493         uint _timePassedSinceStake = now.sub(stakeBalances[msg.sender].initialStakeTime);
494 
495         // Calculate tokens to mint
496         uint _tokensToMint = calculateStakeGains(_timePassedSinceStake);
497 
498         // Add the original stake back to the user's balance
499         balances[msg.sender] += stakeBalances[msg.sender].initialStakeBalance;
500         
501         // Subtract stake balance from totalKekStaked
502         totalKekStaked -= stakeBalances[msg.sender].initialStakeBalance;
503         
504         // Mint the new tokens; the new tokens are added to the user's balance
505         if (stakeBalances[msg.sender].stakeSplitAddress > 0) 
506         {
507             // Splitting stake, so mint half to sender and half to stakeSplitAddress
508             mint(msg.sender, _tokensToMint.div(2));
509             mint(stakeBalances[msg.sender].stakeSplitAddress, _tokensToMint.div(2));
510         } else {
511             // Not spliting stake; mint all new tokens and give them to msg.sender 
512             mint(msg.sender, _tokensToMint);
513         }
514         
515         // Fire an event to tell the world of the newly vested tokens
516         Vest(msg.sender, stakeBalances[msg.sender].stakeSplitAddress, stakeBalances[msg.sender].initialStakeBalance, _tokensToMint);
517 
518         // Clear out stored data from mapping
519         stakeBalances[msg.sender].initialStakeBalance = 0;
520         stakeBalances[msg.sender].initialStakeTime = 0;
521         stakeBalances[msg.sender].initialStakePercentage = 0;
522         stakeBalances[msg.sender].stakeSplitAddress = 0;
523 
524         return true;
525     }
526 
527     /// @dev Allows user to check their staked balance
528     function getStakedBalance() view external returns (uint stakedBalance) 
529     {
530         return stakeBalances[msg.sender].initialStakeBalance;
531     }
532 
533     /// @dev allows contract owner to claim their mint
534     function ownerClaim() external onlyOwner
535     {
536         // Sanity check: ensure that we didn't travel back in time
537         require(now > ownerTimeLastMinted);
538         
539         uint _timePassedSinceLastMint;
540         uint _tokenMintCount;
541         bool _mintingSuccess;
542 
543         // Calculate the number of seconds that have passed since the owner last took a claim
544         _timePassedSinceLastMint = now.sub(ownerTimeLastMinted);
545 
546         // Sanity check: ensure that some time has passed since the owner last claimed
547         assert(_timePassedSinceLastMint > 0);
548 
549         // Determine the token mint amount, determined from the number of seconds passed and the ownerMintRate
550         _tokenMintCount = calculateMintTotal(_timePassedSinceLastMint, ownerMintRate);
551 
552         // Mint the owner's tokens; this also increases totalSupply
553         _mintingSuccess = mint(msg.sender, _tokenMintCount);
554 
555         // Sanity check: ensure that the minting was successful
556         require(_mintingSuccess);
557         
558         // New minting was a success! Set last time minted to current block.timestamp (now)
559         ownerTimeLastMinted = now;
560     }
561 
562     /// @dev stake function reduces the user's total available balance. totalSupply is unaffected
563     /// @param _value determines how many tokens a user wants to stake
564     function stakeTokens(uint256 _value) private returns (bool success)
565     {
566         /// Sanity Checks:
567         // You can only stake as many tokens as you have
568         require(_value <= balances[msg.sender]);
569         // You can only stake tokens if you have not already staked tokens
570         require(stakeBalances[msg.sender].initialStakeBalance == 0);
571 
572         // Subtract stake amount from regular token balance
573         balances[msg.sender] = balances[msg.sender].sub(_value);
574 
575         // Add stake amount to staked balance
576         stakeBalances[msg.sender].initialStakeBalance = _value;
577 
578         // Increment the global staked tokens value
579         totalKekStaked += _value;
580 
581         /// Determine percentage of global stake
582         stakeBalances[msg.sender].initialStakePercentage = calculateFraction(_value, totalKekStaked, decimals);
583         
584         // Save the time that the stake started
585         stakeBalances[msg.sender].initialStakeTime = now;
586 
587         // Fire an event to tell the world of the newly staked tokens
588         Stake(msg.sender, stakeBalances[msg.sender].stakeSplitAddress, _value);
589 
590         return true;
591     }
592 
593     /// @dev Helper function to claimStake that modularizes the minting via staking calculation 
594     function calculateStakeGains(uint _timePassedSinceStake) view private returns (uint mintTotal)
595     {
596         // Store seconds in a day (need it in variable to use SafeMath)
597         uint _secondsPerDay = 86400;
598         uint _finalStakePercentage;     // store our stake percentage at the time of stake claim
599         uint _stakePercentageAverage;   // store our calculated average minting rate ((initial+final) / 2)
600         uint _finalMintRate;            // store our calculated final mint rate (in Kek-per-second)
601         uint _tokensToMint = 0;         // store number of new tokens to be minted
602         
603         // Determine the amount to be newly minted upon vesting, if any
604         if (_timePassedSinceStake > _secondsPerDay) {
605             
606             /// We've passed the minimum staking time; calculate minting rate average ((initialRate + finalRate) / 2)
607             
608             // First, calculate our final stake percentage based upon the total amount of Kek staked
609             _finalStakePercentage = calculateFraction(stakeBalances[msg.sender].initialStakeBalance, totalKekStaked, decimals);
610 
611             // Second, calculate average of initial and final stake percentage
612             _stakePercentageAverage = calculateFraction((stakeBalances[msg.sender].initialStakePercentage.add(_finalStakePercentage)), 2, 0);
613 
614             // Finally, calculate our final mint rate (in Kek-per-second)
615             _finalMintRate = globalMintRate.mul(_stakePercentageAverage); 
616             _finalMintRate = _finalMintRate.div(1 ether);
617             
618             // Tokens were staked for enough time to mint new tokens; determine how many
619             if (_timePassedSinceStake > _secondsPerDay.mul(10)) {
620                 // Tokens were staked for the maximum amount of time (10 days)
621                 _tokensToMint = calculateMintTotal(_secondsPerDay.mul(10), _finalMintRate);
622             } else {
623                 // Tokens were staked for a mintable amount of time, but less than the 10-day max
624                 _tokensToMint = calculateMintTotal(_timePassedSinceStake, _finalMintRate);
625             }
626         } 
627         
628         // Return the amount of new tokens to be minted
629         return _tokensToMint;
630 
631     }
632 
633     /// @dev calculateFraction allows us to better handle the Solidity ugliness of not having decimals as a native type 
634     /// @param _numerator is the top part of the fraction we are calculating
635     /// @param _denominator is the bottom part of the fraction we are calculating
636     /// @param _precision tells the function how many significant digits to calculate out to
637     /// @return quotient returns the result of our fraction calculation
638     function calculateFraction(uint _numerator, uint _denominator, uint _precision) pure private returns(uint quotient) 
639     {
640         // Take passed value and expand it to the required precision
641         _numerator = _numerator.mul(10 ** (_precision + 1));
642         // handle last-digit rounding
643         uint _quotient = ((_numerator.div(_denominator)) + 5) / 10;
644         return (_quotient);
645     }
646 
647     /// @dev Determines mint total based upon how many seconds have passed
648     /// @param _timeInSeconds takes the time that has elapsed since the last minting
649     /// @return uint with the calculated number of new tokens to mint
650     function calculateMintTotal(uint _timeInSeconds, uint _mintRate) pure private returns(uint mintAmount)
651     {
652         // Calculates the amount of tokens to mint based upon the number of seconds passed
653         return(_timeInSeconds.mul(_mintRate));
654     }
655 
656 }