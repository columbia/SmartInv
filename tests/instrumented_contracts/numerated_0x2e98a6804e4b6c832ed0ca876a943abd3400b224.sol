1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 /**************************************************************
62  * @title Bela Token Contract
63  * @file Bela.sol
64  * @author Joe Jordan, BurgTech Solutions
65  * @version 1.0
66  *
67  * @section LICENSE
68  *
69  * Contact for licensing details. All rights reserved.
70  *
71  * @section DESCRIPTION
72  *
73  * This is an ERC20-based token with staking functionality.
74  *
75  *************************************************************/
76 //////////////////////////////////
77 /// OpenZeppelin library imports
78 //////////////////////////////////
79 
80 ///* Truffle format 
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
92 
93 
94 /**
95  * @title SafeMath
96  * @dev Math operations with safety checks that throw on error
97  */
98 library SafeMath {
99   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100     if (a == 0) {
101       return 0;
102     }
103     uint256 c = a * b;
104     assert(c / a == b);
105     return c;
106   }
107 
108   function div(uint256 a, uint256 b) internal pure returns (uint256) {
109     // assert(b > 0); // Solidity automatically throws when dividing by 0
110     uint256 c = a / b;
111     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112     return c;
113   }
114 
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     assert(b <= a);
117     return a - b;
118   }
119 
120   function add(uint256 a, uint256 b) internal pure returns (uint256) {
121     uint256 c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     // SafeMath.sub will throw if there is not enough balance.
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256 balance) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 
166 
167 
168 
169 
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address owner, address spender) public view returns (uint256);
177   function transferFrom(address from, address to, uint256 value) public returns (bool);
178   function approve(address spender, uint256 value) public returns (bool);
179   event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267     uint oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 
280 
281 
282 
283 /**
284  * @title Mintable token
285  * @dev Simple ERC20 Token example, with mintable token creation
286  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
287  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
288  */
289 
290 contract MintableToken is StandardToken, Ownable {
291   event Mint(address indexed to, uint256 amount);
292   //event MintFinished();
293 
294   //bool public mintingFinished = false;
295 
296   /*
297   modifier canMint() {
298     require(!mintingFinished);
299     _;
300   }
301   */
302 
303   /**
304    * @dev Function to mint tokens
305    * @param _to The address that will receive the minted tokens.
306    * @param _amount The amount of tokens to mint.
307    * @return A boolean that indicates if the operation was successful.
308    */
309   function mint(address _to, uint256 _amount) internal returns (bool) {
310     totalSupply = totalSupply.add(_amount);
311     balances[_to] = balances[_to].add(_amount);
312     Mint(_to, _amount);
313     Transfer(address(0), _to, _amount);
314     return true;
315   }
316 
317   /**
318    * @dev Function to stop minting new tokens.
319    * @return True if the operation was successful.
320    
321   function finishMinting() onlyOwner canMint public returns (bool) {
322     mintingFinished = true;
323     MintFinished();
324     return true;
325   }
326   */
327 }
328 
329 
330 
331 
332 
333 /**
334  * @title Contracts that should not own Ether
335  * @author Remco Bloemen <remco@2π.com>
336  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
337  * in the contract, it will allow the owner to reclaim this ether.
338  * @notice Ether can still be send to this contract by:
339  * calling functions labeled `payable`
340  * `selfdestruct(contract_address)`
341  * mining directly to the contract address
342 */
343 contract HasNoEther is Ownable {
344 
345   /**
346   * @dev Constructor that rejects incoming Ether
347   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
348   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
349   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
350   * we could use assembly to access msg.value.
351   */
352   function HasNoEther() public payable {
353     require(msg.value == 0);
354   }
355 
356   /**
357    * @dev Disallows direct send by settings a default function without the `payable` flag.
358    */
359   function() external {
360   }
361 
362   /**
363    * @dev Transfer all Ether held by the contract to the owner.
364    */
365   function reclaimEther() external onlyOwner {
366     assert(owner.send(this.balance));
367   }
368 }
369 
370 
371 ///* Remix format
372 //import "./MintableToken.sol";
373 //import "./HasNoEther.sol";
374 
375 
376 contract Bela is MintableToken, HasNoEther 
377 {
378     // Using libraries 
379     using SafeMath for uint;
380 
381     //////////////////////////////////////////////////
382     /// State Variables for the Bela token contract
383     //////////////////////////////////////////////////
384     
385     //////////////////////
386     // ERC20 token state
387     //////////////////////
388     
389     /**
390     These state vars are handled in the OpenZeppelin libraries;
391     we display them here for the developer's information.
392     ***
393     // ERC20Basic - Store account balances
394     mapping (address => uint256) public balances;
395 
396     // StandardToken - Owner of account approves transfer of an amount to another account
397     mapping (address => mapping (address => uint256)) public allowed;
398 
399     // 
400     uint256 public totalSupply;
401     */
402     
403     //////////////////////
404     // Human token state
405     //////////////////////
406     string public constant name = "Bela";
407     string public constant symbol = "BELA";
408     uint8 public constant  decimals = 18;
409 
410     ///////////////////////////////////////////////////////////
411     // State vars for custom staking and budget functionality
412     ///////////////////////////////////////////////////////////
413 
414     // Owner last minted time
415     uint public ownerTimeLastMinted;
416     // Owner minted tokens per second
417     uint public ownerMintRate;
418 
419     /// Stake minting
420     // Minted tokens per second for all stakers
421     uint private globalMintRate;
422     // Total tokens currently staked
423     uint public totalBelaStaked; 
424 
425     // struct that will hold user stake
426     struct TokenStakeData {
427         uint initialStakeBalance;
428         uint initialStakeTime;
429         uint initialStakePercentage;
430         address stakeSplitAddress;
431     }
432     
433     // Track all tokens staked
434     mapping (address => TokenStakeData) public stakeBalances;
435 
436     // Fire a loggable event when tokens are staked
437     event Stake(address indexed staker, address indexed stakeSplitAddress, uint256 value);
438 
439     // Fire a loggable event when staked tokens are vested
440     event Vest(address indexed vester, address indexed stakeSplitAddress, uint256 stakedAmount, uint256 stakingGains);
441 
442     //////////////////////////////////////////////////
443     /// Begin Bela token functionality
444     //////////////////////////////////////////////////
445 
446     /// @dev Bela token constructor
447     function Bela() public
448     {
449         // Define owner
450         owner = msg.sender;
451         // Define initial owner supply. (ether here is used only to get the decimals right)
452         uint _initOwnerSupply = 41000000 ether;
453         // One-time bulk mint given to owner
454         bool _success = mint(msg.sender, _initOwnerSupply);
455         // Abort if initial minting failed for whatever reason
456         require(_success);
457 
458         ////////////////////////////////////
459         // Set up state minting variables
460         ////////////////////////////////////
461 
462         // Set last minted to current block.timestamp ('now')
463         ownerTimeLastMinted = now;
464         
465         // 4500 minted tokens per day, 86400 seconds in a day
466         ownerMintRate = calculateFraction(4500, 86400, decimals);
467         
468         // 4,900,000 targeted minted tokens per year via staking; 31,536,000 seconds per year
469         globalMintRate = calculateFraction(4900000, 31536000, decimals);
470     }
471 
472     /// @dev staking function which allows users to stake an amount of tokens to gain interest for up to 30 days 
473     function stakeBela(uint _stakeAmount) external
474     {
475         // Require that tokens are staked successfully
476         require(stakeTokens(_stakeAmount));
477     }
478 
479     /// @dev staking function which allows users to split the interest earned with another address
480     function stakeBelaSplit(uint _stakeAmount, address _stakeSplitAddress) external
481     {
482         // Require that a Bela split actually be split with an address
483         require(_stakeSplitAddress > 0);
484         // Store split address into stake mapping
485         stakeBalances[msg.sender].stakeSplitAddress = _stakeSplitAddress;
486         // Require that tokens are staked successfully
487         require(stakeTokens(_stakeAmount));
488 
489     }
490 
491     /// @dev allows users to reclaim any staked tokens
492     /// @return bool on success
493     function claimStake() external returns (bool success)
494     {
495         /// Sanity checks: 
496         // require that there was some amount vested
497         require(stakeBalances[msg.sender].initialStakeBalance > 0);
498         // require that time has elapsed
499         require(now > stakeBalances[msg.sender].initialStakeTime);
500 
501         // Calculate the time elapsed since the tokens were originally staked
502         uint _timePassedSinceStake = now.sub(stakeBalances[msg.sender].initialStakeTime);
503 
504         // Calculate tokens to mint
505         uint _tokensToMint = calculateStakeGains(_timePassedSinceStake);
506 
507         // Add the original stake back to the user's balance
508         balances[msg.sender] += stakeBalances[msg.sender].initialStakeBalance;
509         
510         // Subtract stake balance from totalBelaStaked
511         totalBelaStaked -= stakeBalances[msg.sender].initialStakeBalance;
512         
513         // Mint the new tokens; the new tokens are added to the user's balance
514         if (stakeBalances[msg.sender].stakeSplitAddress > 0) 
515         {
516             // Splitting stake, so mint half to sender and half to stakeSplitAddress
517             mint(msg.sender, _tokensToMint.div(2));
518             mint(stakeBalances[msg.sender].stakeSplitAddress, _tokensToMint.div(2));
519         } else {
520             // Not spliting stake; mint all new tokens and give them to msg.sender 
521             mint(msg.sender, _tokensToMint);
522         }
523         
524         // Fire an event to tell the world of the newly vested tokens
525         Vest(msg.sender, stakeBalances[msg.sender].stakeSplitAddress, stakeBalances[msg.sender].initialStakeBalance, _tokensToMint);
526 
527         // Clear out stored data from mapping
528         stakeBalances[msg.sender].initialStakeBalance = 0;
529         stakeBalances[msg.sender].initialStakeTime = 0;
530         stakeBalances[msg.sender].initialStakePercentage = 0;
531         stakeBalances[msg.sender].stakeSplitAddress = 0;
532 
533         return true;
534     }
535 
536     /// @dev Allows user to check their staked balance
537     function getStakedBalance() view external returns (uint stakedBalance) 
538     {
539         return stakeBalances[msg.sender].initialStakeBalance;
540     }
541 
542     /// @dev allows contract owner to claim their mint
543     function ownerClaim() external onlyOwner
544     {
545         // Sanity check: ensure that we didn't travel back in time
546         require(now > ownerTimeLastMinted);
547         
548         uint _timePassedSinceLastMint;
549         uint _tokenMintCount;
550         bool _mintingSuccess;
551 
552         // Calculate the number of seconds that have passed since the owner last took a claim
553         _timePassedSinceLastMint = now.sub(ownerTimeLastMinted);
554 
555         // Sanity check: ensure that some time has passed since the owner last claimed
556         assert(_timePassedSinceLastMint > 0);
557 
558         // Determine the token mint amount, determined from the number of seconds passed and the ownerMintRate
559         _tokenMintCount = calculateMintTotal(_timePassedSinceLastMint, ownerMintRate);
560 
561         // Mint the owner's tokens; this also increases totalSupply
562         _mintingSuccess = mint(msg.sender, _tokenMintCount);
563 
564         // Sanity check: ensure that the minting was successful
565         require(_mintingSuccess);
566         
567         // New minting was a success! Set last time minted to current block.timestamp (now)
568         ownerTimeLastMinted = now;
569     }
570 
571     /// @dev stake function reduces the user's total available balance. totalSupply is unaffected
572     /// @param _value determines how many tokens a user wants to stake
573     function stakeTokens(uint256 _value) private returns (bool success)
574     {
575         /// Sanity Checks:
576         // You can only stake as many tokens as you have
577         require(_value <= balances[msg.sender]);
578         // You can only stake tokens if you have not already staked tokens
579         require(stakeBalances[msg.sender].initialStakeBalance == 0);
580 
581         // Subtract stake amount from regular token balance
582         balances[msg.sender] = balances[msg.sender].sub(_value);
583 
584         // Add stake amount to staked balance
585         stakeBalances[msg.sender].initialStakeBalance = _value;
586 
587         // Increment the global staked tokens value
588         totalBelaStaked += _value;
589 
590         /// Determine percentage of global stake
591         stakeBalances[msg.sender].initialStakePercentage = calculateFraction(_value, totalBelaStaked, decimals);
592         
593         // Save the time that the stake started
594         stakeBalances[msg.sender].initialStakeTime = now;
595 
596         // Fire an event to tell the world of the newly staked tokens
597         Stake(msg.sender, stakeBalances[msg.sender].stakeSplitAddress, _value);
598 
599         return true;
600     }
601 
602     /// @dev Helper function to claimStake that modularizes the minting via staking calculation 
603     function calculateStakeGains(uint _timePassedSinceStake) view private returns (uint mintTotal)
604     {
605         // Store seconds in a day (need it in variable to use SafeMath)
606         uint _secondsPerDay = 86400;
607         uint _finalStakePercentage;     // store our stake percentage at the time of stake claim
608         uint _stakePercentageAverage;   // store our calculated average minting rate ((initial+final) / 2)
609         uint _finalMintRate;            // store our calculated final mint rate (in Bela-per-second)
610         uint _tokensToMint = 0;         // store number of new tokens to be minted
611         
612         // Determine the amount to be newly minted upon vesting, if any
613         if (_timePassedSinceStake > _secondsPerDay) {
614             
615             /// We've passed the minimum staking time; calculate minting rate average ((initialRate + finalRate) / 2)
616             
617             // First, calculate our final stake percentage based upon the total amount of Bela staked
618             _finalStakePercentage = calculateFraction(stakeBalances[msg.sender].initialStakeBalance, totalBelaStaked, decimals);
619 
620             // Second, calculate average of initial and final stake percentage
621             _stakePercentageAverage = calculateFraction((stakeBalances[msg.sender].initialStakePercentage.add(_finalStakePercentage)), 2, 0);
622 
623             // Finally, calculate our final mint rate (in Bela-per-second)
624             _finalMintRate = globalMintRate.mul(_stakePercentageAverage); 
625             _finalMintRate = _finalMintRate.div(1 ether);
626             
627             // Tokens were staked for enough time to mint new tokens; determine how many
628             if (_timePassedSinceStake > _secondsPerDay.mul(30)) {
629                 // Tokens were staked for the maximum amount of time (30 days)
630                 _tokensToMint = calculateMintTotal(_secondsPerDay.mul(30), _finalMintRate);
631             } else {
632                 // Tokens were staked for a mintable amount of time, but less than the 30-day max
633                 _tokensToMint = calculateMintTotal(_timePassedSinceStake, _finalMintRate);
634             }
635         } 
636         
637         // Return the amount of new tokens to be minted
638         return _tokensToMint;
639 
640     }
641 
642     /// @dev calculateFraction allows us to better handle the Solidity ugliness of not having decimals as a native type 
643     /// @param _numerator is the top part of the fraction we are calculating
644     /// @param _denominator is the bottom part of the fraction we are calculating
645     /// @param _precision tells the function how many significant digits to calculate out to
646     /// @return quotient returns the result of our fraction calculation
647     function calculateFraction(uint _numerator, uint _denominator, uint _precision) pure private returns(uint quotient) 
648     {
649         // Take passed value and expand it to the required precision
650         _numerator = _numerator.mul(10 ** (_precision + 1));
651         // handle last-digit rounding
652         uint _quotient = ((_numerator.div(_denominator)) + 5) / 10;
653         return (_quotient);
654     }
655 
656     /// @dev Determines mint total based upon how many seconds have passed
657     /// @param _timeInSeconds takes the time that has elapsed since the last minting
658     /// @return uint with the calculated number of new tokens to mint
659     function calculateMintTotal(uint _timeInSeconds, uint _mintRate) pure private returns(uint mintAmount)
660     {
661         // Calculates the amount of tokens to mint based upon the number of seconds passed
662         return(_timeInSeconds.mul(_mintRate));
663     }
664 
665 }