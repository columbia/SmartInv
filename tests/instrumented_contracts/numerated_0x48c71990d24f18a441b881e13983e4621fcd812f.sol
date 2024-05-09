1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36     function transferOwnership(address newOwner) external onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 }
43 
44 // File: contracts/ERC20Basic.sol
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52     function totalSupply() public view returns (uint256);
53     function balanceOf(address who) public view returns (uint256);
54     function transferInternal(address to, uint256 value) internal returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 // File: contracts/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   /**
89   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 // File: contracts/BasicToken.sol
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113     using SafeMath for uint256;
114 
115     mapping(address => uint256) balances;
116 
117     uint256 totalSupply_;
118 
119   /**
120   * @dev total number of tokens in existence
121   */
122     function totalSupply() public view returns (uint256) {
123         return totalSupply_;
124     }
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131     function transferInternal(address _to, uint256 _value) internal returns (bool) {
132         require(_to != address(0));
133         require(_value <= balances[msg.sender]);
134 
135         // SafeMath.sub will throw if there is not enough balance.
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147     function balanceOf(address _owner) public view returns (uint256 balance) {
148         return balances[_owner];
149     }
150 
151 }
152 
153 // File: contracts/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160     function allowanceInternal(address owner, address spender) internal view returns (uint256);
161     function transferFromInternal(address from, address to, uint256 value) internal returns (bool);
162     function approveInternal(address spender, uint256 value) internal returns (bool);
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: contracts/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177     mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186     function transferFromInternal(address _from, address _to, uint256 _value) internal returns (bool) {
187         require(_to != address(0));
188         require(_value <= balances[_from]);
189         require(_value <= allowed[_from][msg.sender]);
190 
191         balances[_from] = balances[_from].sub(_value);
192         balances[_to] = balances[_to].add(_value);
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194         emit Transfer(_from, _to, _value);
195         return true;
196     }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208     function approveInternal(address _spender, uint256 _value) internal returns (bool) {
209         allowed[msg.sender][_spender] = _value;
210         emit Approval(msg.sender, _spender, _value);
211         return true;
212     }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220     function allowanceInternal(address _owner, address _spender) internal view returns (uint256) {
221         return allowed[_owner][_spender];
222     }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234     function increaseApprovalInternal(address _spender, uint _addedValue) internal returns (bool) {
235         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250     function decreaseApprovalInternal(address _spender, uint _subtractedValue) internal returns (bool) {
251         uint oldValue = allowed[msg.sender][_spender];
252         if (_subtractedValue > oldValue) {
253             allowed[msg.sender][_spender] = 0;
254         } else {
255             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256         }
257         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258         return true;
259     }
260 
261 }
262 
263 // File: contracts/MintableToken.sol
264 
265 //import "./StandardToken.sol";
266 //import "../../ownership/Ownable.sol";
267 
268 
269 
270 /**
271  * @title Mintable token
272  * @dev Simple ERC20 Token example, with mintable token creation
273  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
274  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
275  */
276 contract MintableToken is StandardToken, Ownable {
277     event Mint(address indexed to, uint256 amount);
278     event MintFinished();
279 
280     bool public mintingFinished = false;
281     address public icoContractAddress;
282 
283     modifier canMint() {
284         require(!mintingFinished);
285         _;
286     }
287 
288     /**
289     * @dev Throws if called by any account other than the icoContract.
290     */
291     modifier onlyIcoContract() {
292         require(msg.sender == icoContractAddress);
293         _;
294     }
295 
296 
297     /**
298     * @dev Function to mint tokens
299     * @param _to The address that will receive the minted tokens.
300     * @param _amount The amount of tokens to mint.
301     * @return A boolean that indicates if the operation was successful.
302     */
303     function mint(address _to, uint256 _amount) onlyIcoContract canMint external returns (bool) {
304         //return true;
305         totalSupply_ = totalSupply_.add(_amount);
306         balances[_to] = balances[_to].add(_amount);
307         emit Mint(_to, _amount);
308         emit Transfer(address(0), _to, _amount);
309         return true;
310     }
311 
312     /**
313      * @dev Function to stop minting new tokens.
314      * @return True if the operation was successful.
315      */
316     function finishMinting() onlyOwner canMint external returns (bool) {
317         mintingFinished = true;
318         emit MintFinished();
319         return true;
320     }
321 
322 }
323 
324 // File: contracts/Pausable.sol
325 
326 /**
327  * @title Pausable
328  * @dev Base contract which allows children to implement an emergency stop mechanism.
329  */
330 contract Pausable is Ownable {
331     event Pause();
332     event Unpause();
333 
334     bool public paused = false;
335 
336 
337   /**
338    * @dev Modifier to make a function callable only when the contract is not paused.
339    */
340     modifier whenNotPaused() {
341         require(!paused);
342         _;
343     }
344 
345   /**
346    * @dev Modifier to make a function callable only when the contract is paused.
347    */
348     modifier whenPaused() {
349         require(paused);
350         _;
351     }
352 
353   /**
354    * @dev called by the owner to pause, triggers stopped state
355    */
356     function pause() onlyOwner whenNotPaused external {
357         paused = true;
358         emit Pause();
359     }
360 
361   /**
362    * @dev called by the owner to unpause, returns to normal state
363    */
364     function unpause() onlyOwner whenPaused external {
365         paused = false;
366         emit Unpause();
367     }
368 }
369 
370 // File: contracts/PausableToken.sol
371 
372 /**
373  * @title Pausable token
374  * @dev StandardToken modified with pausable transfers.
375  **/
376 contract PausableToken is StandardToken, Pausable {
377 
378     function transferInternal(address _to, uint256 _value) internal whenNotPaused returns (bool) {
379         return super.transferInternal(_to, _value);
380     }
381 
382     function transferFromInternal(address _from, address _to, uint256 _value) internal whenNotPaused returns (bool) {
383         return super.transferFromInternal(_from, _to, _value);
384     }
385 
386     function approveInternal(address _spender, uint256 _value) internal whenNotPaused returns (bool) {
387         return super.approveInternal(_spender, _value);
388     }
389 
390     function increaseApprovalInternal(address _spender, uint _addedValue) internal whenNotPaused returns (bool success) {
391         return super.increaseApprovalInternal(_spender, _addedValue);
392     }
393 
394     function decreaseApprovalInternal(address _spender, uint _subtractedValue) internal whenNotPaused returns (bool success) {
395         return super.decreaseApprovalInternal(_spender, _subtractedValue);
396     }
397 }
398 
399 // File: contracts/ReentrancyGuard.sol
400 
401 /**
402  * @title Helps contracts guard agains reentrancy attacks.
403  * @author Remco Bloemen <remco@2π.com>
404  * @notice If you mark a function `nonReentrant`, you should also
405  * mark it `external`.
406  */
407 contract ReentrancyGuard {
408 
409   /**
410    * @dev We use a single lock for the whole contract.
411    */
412   bool private reentrancy_lock = false;
413 
414   /**
415    * @dev Prevents a contract from calling itself, directly or indirectly.
416    * @notice If you mark a function `nonReentrant`, you should also
417    * mark it `external`. Calling one nonReentrant function from
418    * another is not supported. Instead, you can implement a
419    * `private` function doing the actual work, and a `external`
420    * wrapper marked as `nonReentrant`.
421    */
422   modifier nonReentrant() {
423     require(!reentrancy_lock);
424     reentrancy_lock = true;
425     _;
426     reentrancy_lock = false;
427   }
428 
429 }
430 
431 // File: contracts/IiinoCoin.sol
432 
433 contract IiinoCoin is MintableToken, PausableToken, ReentrancyGuard {
434     event RewardMint(address indexed to, uint256 amount);
435     event RewardMintingAmt(uint256 _amountOfTokensMintedPreCycle);
436     event ResetReward();
437     event RedeemReward(address indexed to, uint256 value);
438 
439     event CreatedEscrow(bytes32 _tradeHash);
440     event ReleasedEscrow(bytes32 _tradeHash);
441     event Dispute(bytes32 _tradeHash);
442     event CancelledBySeller(bytes32 _tradeHash);
443     event CancelledByBuyer(bytes32 _tradeHash);
444     event BuyerArbitratorSet(bytes32 _tradeHash);
445     event SellerArbitratorSet(bytes32 _tradeHash);
446     event DisputeResolved (bytes32 _tradeHash);
447     event IcoContractAddressSet (address _icoContractAddress);
448 
449     using SafeMath for uint256;
450 
451     // Mapping of rewards to beneficiaries of the reward
452     mapping(address => uint256) public reward;
453 
454     string public name;
455     string public symbol;
456     uint8 public decimals;
457 
458     uint256 public amountMintPerDuration; // amount to mint during one minting cycle
459     uint256 public durationBetweenRewardMints; // reward miniting cycle duration
460     uint256 public previousDistribution; //EPOCH time of the previous distribution
461     uint256 public totalRewardsDistributed; //Total amount of the rewards distributed
462     uint256 public totalRewardsRedeemed; //Total amount of the rewards redeemed
463     uint256 public minimumRewardWithdrawalLimit; //The minimum limit of rewards that can be withdrawn
464     uint256 public rewardAvailableCurrentDistribution; //The amount of rewards available for the current Distribution.
465 
466     function IiinoCoin(
467         string _name,
468         string _symbol,
469         uint8 _decimals,
470         uint256 _amountMintPerDuration,
471         uint256 _durationBetweenRewardMints
472     ) public {
473         name = _name;
474         symbol = _symbol;
475         decimals = _decimals;
476 
477         amountMintPerDuration = _amountMintPerDuration;
478         durationBetweenRewardMints = _durationBetweenRewardMints;
479         previousDistribution = now; // To initialize the previous distribution to the time of the creation of the contract
480         totalRewardsDistributed = 0;
481         totalRewardsRedeemed = 0;
482         minimumRewardWithdrawalLimit = 10 ether; //Defaulted to 10 iiinos represented in iii
483         rewardAvailableCurrentDistribution = amountMintPerDuration;
484         icoContractAddress = msg.sender;
485     }
486 
487     /**
488     * @dev set the icoContractAddress in the token so that the ico Contract can mint the token
489     * @param _icoContractAddress array of address. The address to which the reward needs to be distributed
490     */
491     function setIcoContractAddress(
492         address _icoContractAddress
493     ) external nonReentrant onlyOwner whenNotPaused {
494         require (_icoContractAddress != address(0));
495         emit IcoContractAddressSet(_icoContractAddress);
496         icoContractAddress = _icoContractAddress;
497     }
498 
499     /**
500     * @dev distribute reward tokens to the list of addresses based on their proportion
501     * @param _rewardAdresses array of address. The address to which the reward needs to be distributed
502     */
503     function batchDistributeReward(
504         address[] _rewardAdresses,
505         uint256[] _amountOfReward,
506         uint256 _timestampOfDistribution
507     ) external nonReentrant onlyOwner whenNotPaused {
508         require(_timestampOfDistribution > previousDistribution.add(durationBetweenRewardMints)); //To only allow a distribution to happen 30 days (2592000 seconds) after the previous distribution
509         require(_timestampOfDistribution < now); // To only allow a distribution time in the past
510         require(_rewardAdresses.length == _amountOfReward.length); // To verify the length of the arrays are the same.
511 
512         uint256 rewardDistributed = 0;
513 
514         for (uint j = 0; j < _rewardAdresses.length; j++) {
515             rewardMint(_rewardAdresses[j], _amountOfReward[j]);
516             rewardDistributed = rewardDistributed.add(_amountOfReward[j]);
517         }
518         require(rewardAvailableCurrentDistribution >= rewardDistributed);
519         totalRewardsDistributed = totalRewardsDistributed.add(rewardDistributed);
520         rewardAvailableCurrentDistribution = rewardAvailableCurrentDistribution.sub(rewardDistributed);
521     }
522 
523     /**
524     * @dev distribute reward tokens to a addresse based on the proportion
525     * @param _rewardAddress The address to which the reward needs to be distributed
526     */
527     function distributeReward(
528         address _rewardAddress,
529         uint256 _amountOfReward,
530         uint256 _timestampOfDistribution
531     ) external nonReentrant onlyOwner whenNotPaused {
532 
533         require(_timestampOfDistribution > previousDistribution);
534         require(_timestampOfDistribution < previousDistribution.add(durationBetweenRewardMints)); //To only allow a distribution to happen 30 days (2592000 seconds) after the previous distribution
535         require(_timestampOfDistribution < now); // To only allow a distribution time in the past
536         //reward[_rewardAddress] = reward[_rewardAddress].add(_amountOfReward);
537         rewardMint(_rewardAddress, _amountOfReward);
538 
539     }
540 
541     /**
542     * @dev reset reward tokensfor the new duration
543     */
544     function resetReward() external nonReentrant onlyOwner whenNotPaused {
545         require(now > previousDistribution.add(durationBetweenRewardMints)); //To only allow a distribution to happen 30 days (2592000 seconds) after the previous distribution
546         previousDistribution = previousDistribution.add(durationBetweenRewardMints); // To set the new distribution period as the previous distribution timestamp
547         rewardAvailableCurrentDistribution = amountMintPerDuration;
548         emit ResetReward();
549     }
550 
551     /**
552    * @dev Redeem Reward tokens from one rewards array to balances array
553    * @param _beneficiary address The address which contains the reward as well as the address to which the balance will be transferred
554    * @param _value uint256 the amount of tokens to be redeemed
555    */
556     function redeemReward(
557         address _beneficiary,
558         uint256 _value
559     ) external nonReentrant whenNotPaused{
560         //Need to consider what happens to rewards after the stopping of minting process
561         require(msg.sender == _beneficiary);
562         require(_value >= minimumRewardWithdrawalLimit);
563         require(reward[_beneficiary] >= _value);
564         reward[_beneficiary] = reward[_beneficiary].sub(_value);
565         balances[_beneficiary] = balances[_beneficiary].add(_value);
566         totalRewardsRedeemed = totalRewardsRedeemed.add(_value);
567         emit RedeemReward(_beneficiary, _value);
568     }
569 
570     function rewardMint(
571         address _to,
572         uint256 _amount
573     ) onlyOwner canMint whenNotPaused internal returns (bool) {
574         require(_amount > 0);
575         require(_to != address(0));
576         require(rewardAvailableCurrentDistribution >= _amount);
577         totalSupply_ = totalSupply_.add(_amount);
578         reward[_to] = reward[_to].add(_amount);
579         totalRewardsDistributed = totalRewardsDistributed.add(_amount);
580         rewardAvailableCurrentDistribution = rewardAvailableCurrentDistribution.sub(_amount);
581         emit RewardMint(_to, _amount);
582         //Transfer(address(0), _to, _amount); //balance of the user will only be updated on claiming the coin
583         return true;
584     }
585     function userRewardAccountBalance(
586         address _address
587     ) whenNotPaused external view returns (uint256) {
588         require(_address != address(0));
589         return reward[_address];
590     }
591     function changeRewardMintingAmount(
592         uint256 _newRewardMintAmt
593     ) whenNotPaused nonReentrant onlyOwner external {
594         require(_newRewardMintAmt < amountMintPerDuration);
595         amountMintPerDuration = _newRewardMintAmt;
596         emit RewardMintingAmt(_newRewardMintAmt);
597     }
598 
599     function transferFrom(address _from, address _to, uint256 _value) external nonReentrant returns (bool) {
600         return transferFromInternal(_from, _to, _value);
601     }
602     function approve(address _spender, uint256 _value) external nonReentrant returns (bool) {
603         return approveInternal(_spender, _value);
604     }
605     function allowance(address _owner, address _spender) external view returns (uint256) {
606         return allowanceInternal(_owner, _spender);
607     }
608     function increaseApproval(address _spender, uint _addedValue) external nonReentrant returns (bool) {
609         return increaseApprovalInternal(_spender, _addedValue);
610     }
611     function decreaseApproval(address _spender, uint _subtractedValue) external nonReentrant returns (bool) {
612         return decreaseApprovalInternal(_spender, _subtractedValue);
613     }
614     function transfer(address _to, uint256 _value) external nonReentrant returns (bool) {
615         return transferInternal(_to, _value);
616     }
617 }