1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 
8 interface IERC20 {
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Unsigned math operations with safety checks that revert on error
31  */
32  
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
98  * Originally based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  *
101  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
102  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
103  * compliant implementations may not do it.
104  */
105 
106 contract ERC20 is IERC20 {
107 
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) internal _balances;
111 
112     mapping (address => mapping (address => uint256)) internal _allowed;
113 
114     uint256 internal _totalSupply;
115 
116     /**
117     * @dev Total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param to The address to transfer to.
145     * @param value The amount to be transferred.
146     */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         require(spender != address(0));
163 
164         _allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179         _transfer(from, to, value);
180         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
273         _burn(account, value);
274         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
275     }
276 }
277 
278 /**
279  * @title ERC20Detailed token
280  * @dev The decimals are only for visualization purposes.
281  * All the operations are done using the smallest and indivisible token unit,
282  * just as on Ethereum all the operations are done in wei.
283  */
284  
285 contract ERC20Detailed is  ERC20 {
286     string private _name;
287     string private _symbol;
288     uint8 internal _decimals;
289 
290     constructor (string memory name, string memory symbol, uint8 decimals) public {
291         _name = name;
292         _symbol = symbol;
293         _decimals = decimals;
294     }
295 
296     /**
297      * @return the name of the token.
298      */
299     function name() public view returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @return the symbol of the token.
305      */
306     function symbol() public view returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311      * @return the number of decimals of the token.
312      */
313     function decimals() public view returns (uint8) {
314         return _decimals;
315     }
316 }
317 
318 /**
319  * @title Ownable
320  * @dev The Ownable contract has an owner address, and provides basic authorization control
321  * functions, this simplifies the implementation of "user permissions".
322  */
323  
324 contract Ownable {
325     
326     address private _owner;
327 
328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
329 
330     /**
331      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
332      * account.
333      */
334     constructor () internal {
335         _owner = msg.sender;
336         emit OwnershipTransferred(address(0), _owner);
337     }
338 
339     /**
340      * @return the address of the owner.
341      */
342     function owner() public view returns (address) {
343         return _owner;
344     }
345 
346     /**
347      * @dev Throws if called by any account other than the owner.
348      */
349     modifier onlyOwner() {
350         require(isOwner());
351         _;
352     }
353 
354     /**
355      * @return true if `msg.sender` is the owner of the contract.
356      */
357     function isOwner() public view returns (bool) {
358         return msg.sender == _owner;
359     }
360 
361     /**
362      * @dev Allows the current owner to relinquish control of the contract.
363      * @notice Renouncing to ownership will leave the contract without an owner.
364      * It will not be possible to call the functions with the `onlyOwner`
365      * modifier anymore.
366      */
367     function renounceOwnership() public onlyOwner {
368         emit OwnershipTransferred(_owner, address(0));
369         _owner = address(0);
370     }
371 
372     /**
373      * @dev Allows the current owner to transfer control of the contract to a newOwner.
374      * @param newOwner The address to transfer ownership to.
375      */
376     function transferOwnership(address newOwner) public onlyOwner {
377         _transferOwnership(newOwner);
378     }
379 
380     /**
381      * @dev Transfers control of the contract to a newOwner.
382      * @param newOwner The address to transfer ownership to.
383      */
384     function _transferOwnership(address newOwner) internal {
385         require(newOwner != address(0));
386         emit OwnershipTransferred(_owner, newOwner);
387         _owner = newOwner;
388     }
389 }
390 
391 
392 contract Remote is Ownable, IERC20 {
393     
394     IERC20 internal _remoteToken;
395     address internal _remoteContractAddress;
396 
397     /**
398     @dev approveSpenderOnVault
399     This is only needed if you put the funds in the Vault contract address, and then need to withdraw them
400     Avoid this, by not putting funds in there that you need to get back.
401     @param spender The address that will be used to withdraw from the Vault.
402     @param value The amount of tokens to approve.
403     @return success
404      */
405     function approveSpenderOnVault (address spender, uint256 value) 
406         external onlyOwner returns (bool success) {
407             // NOTE Approve the spender on the Vault address
408             _remoteToken.approve(spender, value);     
409             success = true;
410         }
411 
412    /** 
413     @dev remoteTransferFrom This allows the admin to withdraw tokens from the contract, using an 
414     allowance that has been previously set. 
415     @param from address to take the tokens from (allowance)
416     @param to the recipient to give the tokens to
417     @param value the amount in tokens to send
418     @return bool
419     */
420     function remoteTransferFrom (address from, address to, uint256 value) external onlyOwner returns (bool) {
421         return _remoteTransferFrom(from, to, value);
422     }
423 
424     /**
425     @dev setRemoteContractAddress
426     @param remoteContractAddress The remote contract's address
427     @return success
428      */
429     function setRemoteContractAddress (address remoteContractAddress)
430         external onlyOwner returns (bool success) {
431             _remoteContractAddress = remoteContractAddress;        
432             _remoteToken = IERC20(_remoteContractAddress);
433             success = true;
434         }
435 
436     function remoteBalanceOf(address owner) external view returns (uint256) {
437         return _remoteToken.balanceOf(owner);
438     }
439 
440     function remoteTotalSupply() external view returns (uint256) {
441         return _remoteToken.totalSupply();
442     }
443 
444     /** */
445     function remoteAllowance (address owner, address spender) external view returns (uint256) {
446         return _remoteToken.allowance(owner, spender);
447     }
448 
449     /**
450     @dev remoteBalanceOfVault Return tokens from the balance of the Vault contract.
451     This should be zero. Tokens should come from allowance, not balanceOf.
452     @return balance
453      */
454     function remoteBalanceOfVault () external view onlyOwner 
455         returns(uint256 balance) {
456             balance = _remoteToken.balanceOf(address(this));
457         }
458 
459     /**
460     @dev remoteAllowanceOnMyAddress Check contracts allowance on the users address.
461     @return allowance
462      */
463     function remoteAllowanceOnMyAddress () public view
464         returns(uint256 allowance) {
465             allowance = _remoteToken.allowance(msg.sender, address(this));
466         } 
467 
468     /** 
469     @dev _remoteTransferFrom This allows contract to withdraw tokens from an address, using an 
470     allowance that has been previously set. 
471     @param from address to take the tokens from (allowance)
472     @param to the recipient to give the tokens to
473     @param value the amount in tokens to send
474     @return bool
475     */
476     function _remoteTransferFrom (address from, address to, uint256 value) internal returns (bool) {
477         return _remoteToken.transferFrom(from, to, value);
478     }
479 
480 }
481 
482 
483 contract ProofOfTrident is ERC20Detailed, Remote {
484     
485     event SentToStake(address from, address to, uint256 value);  
486 
487     // max total supply set.
488     uint256 private _maxTotalSupply = 100000000000 * 10**uint(18);
489     
490     // minimum number of tokens that can be staked
491     uint256 internal _stakeMinimum = 100000000 * 10**uint(18); 
492     // maximum number of tokens that can be staked
493     uint256 internal _stakeMaximum = 500000000 * 10**uint(18); 
494     
495     uint internal _oneDay = 60 * 60 * 24;    
496     uint internal _sixMonths = _oneDay * 182;   
497     uint internal _oneYear = _oneDay * 365; 
498     uint internal _stakeMinimumTimestamp = 1000; // minimum age for coin age: 1000 seconds
499 
500     // Stop the maximum stake at this to encourage users to collect regularly. 
501     uint internal _stakeMaximumTimestamp = _oneYear + _sixMonths;
502     uint256 internal _percentageLower = 2;
503     uint256 internal _percentageMiddle = 7;
504     uint256 internal _percentageUpper = 13;
505     //uint256 internal _percentageOfTokensReturned = 10;
506     // These funds will go into a variable, but will be stored at the original owner address
507     uint256 private _treasuryPercentageOfReward = 50;    
508   
509     address internal _treasury;
510 
511     /**
512      @dev cancelTrident
513      @return success
514      */
515     function cancelTrident() external returns (bool) {
516         // Don't check the real balance as the user is allowed to add the whole amount to stake.
517         uint256 _amountInVault = _transferIns[msg.sender].amountInVault;
518         // Check that there is at least an amount set to stake.
519         require(_amountInVault > 0, "You have not staked any tokens.");
520         
521         // reset values before moving on
522         _transferIns[msg.sender].amountInVault = 0;
523         _transferIns[msg.sender].tokenTimestamp = block.timestamp;
524 
525         // NOTE  Convert to transferFrom Vault
526         // DONE The contract needs a allowance on itself for every token
527         _remoteTransferFrom(address(this), msg.sender, _amountInVault);
528 
529         return true;
530     }
531 
532     /**
533      @dev collectRewards
534      @return success
535      */
536     function collectRewards() external returns (bool) {
537         // Don't check the real balance as the user is allowed to add the whole amount to stake.
538         uint256 _amountInVault = _transferIns[msg.sender].amountInVault;
539         // Check that there is at least an amount set to stake.
540         require(_amountInVault > 0, "You have not staked any tokens.");
541         
542         // If the stake age is less than minimum, reject the attempt.
543         require(_holdAgeTimestamp(msg.sender) >= _transferIns[msg.sender].stakeMinimumTimestamp,
544         "You need to stake for the minimum time of 1000 seconds.");
545 
546         uint256 rewardForUser = tridentReward(msg.sender);
547         require(rewardForUser > 0, "Your reward is currently zero. Nothing to collect.");
548 
549         // reset values before moving on
550         _transferIns[msg.sender].amountInVault = 0;
551         _transferIns[msg.sender].tokenTimestamp = block.timestamp;
552         _transferIns[msg.sender].percentageLower = 0;
553         _transferIns[msg.sender].percentageMiddle = 0;
554         _transferIns[msg.sender].percentageUpper = 0;
555         _transferIns[msg.sender].stakeMinimumTimestamp = _oneDay;
556         _transferIns[msg.sender].stakeMaximumTimestamp = _oneYear + _sixMonths;
557         // return their stake
558         // DONE the contract needs and allowance inself for all the inputs, make this on 
559         // first set up
560         _remoteTransferFrom(address(this), msg.sender, _amountInVault);
561 
562         // calculate the amount for the treasury
563         uint256 _amountForTreasury = rewardForUser.mul(_treasuryPercentageOfReward).div(100);
564 
565         // apply the rewards to the owner address to save on gas later
566         _mint(_treasury, _amountForTreasury);
567 
568         // calculate the amount for the user
569         _mint(msg.sender, rewardForUser);
570         return true;
571     }
572 
573     function setTreasuryAddress (address treasury) external onlyOwner {
574         _treasury = treasury;
575     }
576 
577     struct TransferInStake {
578         uint256 amountInVault;
579         uint256 tokenTimestamp;
580         uint256 percentageLower;
581         uint256 percentageMiddle;
582         uint256 percentageUpper;
583         uint stakeMinimumTimestamp;
584         uint stakeMaximumTimestamp;
585     }
586 
587     mapping(address => TransferInStake) internal _transferIns;
588 
589     modifier canPoSMint() {
590         // This will allow the supply to go slightly over the max total supply (once the last rewards are applied).
591         // Users can collect rewards (and stake) after the closure period. 
592         // In theory somone could hold for a long time and then receive a very large reward.
593         require(_totalSupply < _maxTotalSupply,
594         "This operation would take the total supply over the maximum supply.");
595         _;
596     }
597 
598     /**
599     @dev setTridentDetails
600 
601     @param stakeMinimumTimestamp The timestamp as the minimum amount of staking 
602     @param stakeMaximumTimestamp The timestamp as the maximum amount of staking 
603     @param stakeMinimumInTokens The minimum amount of tokens to stake
604     @param stakeMaximumInTokens The the maximum amount of tokens to stake 
605     @param percentageTreasury The percentage of the reward that the treasury take 
606     @param percentageLower The lower annual interest rate to pay out to users 
607     @param percentageMiddle The middel annual interest rate to pay out to users 
608     @param percentageUpper The upper annual interest rate to pay out to users 
609     @param maxTotalSupply The maximum supply that can be minted 
610     @return success
611     */
612     function setTridentDetails(
613         uint256 stakeMinimumTimestamp,
614         uint256 stakeMaximumTimestamp,
615         uint256 stakeMinimumInTokens,
616         uint256 stakeMaximumInTokens,
617         uint256 percentageTreasury,
618         uint256 percentageLower,
619         uint256 percentageMiddle,
620         uint256 percentageUpper,
621         uint256 maxTotalSupply) 
622         external onlyOwner returns (bool success) {
623             _stakeMinimum = stakeMinimumInTokens * 10**uint(18);
624             _stakeMaximum = stakeMaximumInTokens * 10**uint(18);
625             _stakeMinimumTimestamp = stakeMinimumTimestamp;
626             _stakeMaximumTimestamp = stakeMaximumTimestamp;
627             _percentageLower = percentageLower;  
628             _percentageMiddle = percentageMiddle;  
629             _percentageUpper = percentageUpper; 
630             _treasuryPercentageOfReward = percentageTreasury;
631             _maxTotalSupply = maxTotalSupply * 10**uint(18);
632             success = true;
633         }
634 
635     function canAddToVault() external view canPoSMint returns(bool) {
636         return true;
637     }
638 
639     function treasuryAddress () external view onlyOwner returns (address treasury) {
640         treasury = _treasury;
641     }
642 
643     /**
644     @dev tridentDetails
645     @return stakeMinimum The token count minimum
646     @return stakeMaximum The token count minimum
647     @return interest The average interest earned per year
648     @return treasuryPercentage The percentage (extra) given to treasury per reward
649     @return maxTotalSupply The maximum supply cap
650     */
651     function tridentDetails ()
652     external view returns
653     (
654     uint stakeMinimumTimestamp,
655     uint stakeMaximumTimestamp,
656     uint256 percentageLower,
657     uint256 percentageMiddle,
658     uint256 percentageUpper,
659     uint256 treasuryPercentage,
660     uint256 stakeMinimum,
661     uint256 stakeMaximum,
662     uint256 maxTotalSupply) {
663         stakeMinimumTimestamp = _stakeMinimumTimestamp;
664         stakeMaximumTimestamp = _stakeMaximumTimestamp;
665         percentageLower = _percentageLower;
666         percentageMiddle = _percentageMiddle;
667         percentageUpper = _percentageUpper;
668         treasuryPercentage = _treasuryPercentageOfReward; 
669         stakeMinimum = _stakeMinimum;
670         stakeMaximum = _stakeMaximum;     
671         maxTotalSupply = _maxTotalSupply;
672     }
673     
674     function percentageLower () external view returns (uint256) {
675         return _percentageLower;
676     }
677 
678     function percentageMiddle () external view returns (uint256) {
679         return _percentageMiddle;
680     }
681 
682     function percentageUpper () external view returns (uint256) {
683         return _percentageUpper;
684     }
685 
686     function stakeMinimum () external view returns (uint256) {
687         return _stakeMinimum;
688     }
689 
690     function stakeMaximum () external view returns (uint256) {
691         return _stakeMaximum;
692     }
693 
694     function myHoldAgeTimestamp() external view returns (uint256) {
695         return _holdAgeTimestamp(msg.sender);
696     }
697 
698     function myAmountInVault() external view returns (uint256) {
699         return _transferIns[msg.sender].amountInVault;
700     }
701 
702     function myPercentageLower() external view returns (uint256) {
703         return _transferIns[msg.sender].percentageLower;
704     }
705 
706     function myPercentageMiddle() external view returns (uint256) {
707         return _transferIns[msg.sender].percentageMiddle;
708     }
709 
710     function myPercentageUpper() external view returns (uint256) {
711         return _transferIns[msg.sender].percentageUpper;
712     }
713 
714     function myStakeMinimumTimestamp() external view returns (uint) {
715         return _transferIns[msg.sender].stakeMinimumTimestamp;
716     }
717 
718     function myStakeMaximumTimestamp() external view returns (uint) {
719         return _transferIns[msg.sender].stakeMaximumTimestamp;
720     }
721 
722     /**
723      @dev tridentReward: Returns value of the reward. Does not allocate reward.
724     @param owner The owner address
725      @return totalReward
726      */
727     function tridentReward(address owner) public view returns (uint256 totalReward) {
728         require(_transferIns[owner].amountInVault > 0, "You have not sent any tokens into stake.");
729         
730         uint256 _amountInStake =  _transferIns[owner].amountInVault;//Take from struct
731   
732         uint _lengthOfHoldInSeconds = _holdAgeTimestamp(owner);//Take from method
733 
734         if (_lengthOfHoldInSeconds > (_transferIns[owner].stakeMaximumTimestamp)) {
735             _lengthOfHoldInSeconds = _transferIns[owner].stakeMaximumTimestamp;
736         }
737 
738         uint percentage = _transferIns[owner].percentageLower;
739 
740         // NOTE  if user holds for long time
741         if (_lengthOfHoldInSeconds >= (_sixMonths)) {
742             percentage = _transferIns[owner].percentageMiddle;
743         }
744         if (_lengthOfHoldInSeconds >= (_oneYear)) {
745             percentage = _transferIns[owner].percentageUpper;
746         }
747 
748         uint256 reward = 
749         _amountInStake.
750         mul(percentage)
751         .mul(_lengthOfHoldInSeconds)
752         .div(_stakeMaximumTimestamp)
753         .div(100);
754 
755         totalReward = reward;
756 
757     }
758 
759     /**
760      @dev _holdAgeTimestamp
761      @param owner The owner address
762      @return holdAgeTimestamp The stake age in seconds
763      */
764     function _holdAgeTimestamp(address owner) internal view returns (uint256 holdAgeTimestamp) {
765         
766         require(_transferIns[owner].amountInVault > 0,
767         "You haven't sent any tokens to stake, so there is no stake age to return.");
768         
769         uint256 _lengthOfHoldTimestamp = (block.timestamp - _transferIns[owner].tokenTimestamp);
770         
771         holdAgeTimestamp = _lengthOfHoldTimestamp;
772     }   
773 }
774 
775 /**
776  * @title Burnable Token
777  * @dev Token that can be irreversibly burned (destroyed).
778  */
779  
780 contract ERC20Burnable is ERC20 {
781     
782     /**
783      * @dev Burns a specific amount of tokens.
784      * @param value The amount of token to be burned.
785      */
786     function burn(uint256 value) public {
787         _burn(msg.sender, value);
788     }
789 
790     /**
791      * @dev Burns a specific amount of tokens from the target address and decrements allowance
792      * @param from address The address which you want to send tokens from
793      * @param value uint256 The amount of token to be burned
794      */
795     function burnFrom(address from, uint256 value) public {
796         _burnFrom(from, value);
797     }
798 }
799 
800 /**
801  * @title Vault
802  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
803  * Note they can later distribute these tokens as they wish using `transfer` and other
804  * `ERC20` functions.
805  */
806 
807 contract Vault is ProofOfTrident, ERC20Burnable {
808 
809     uint8 private constant DECIMALS = 18;
810     uint256 private constant INITIAL_SUPPLY = 0;
811     address private _vaultAddress = address(this);
812     
813     /**
814      * @dev Constructor that gives msg.sender all of existing tokens, 0.
815      */
816     constructor (string memory name, string memory symbol, address remoteContractAddress, address treasury)
817         public ERC20Detailed(name, symbol, DECIMALS) {
818 
819             _remoteContractAddress = remoteContractAddress;
820             _remoteToken = IERC20(_remoteContractAddress);
821             _decimals = DECIMALS;
822             _treasury = treasury;
823             //_percentageOfTokensReturned = percentageOfTokensReturned;
824             
825             _mint(msg.sender, INITIAL_SUPPLY);
826         }
827 
828     function() external payable {
829         // If Ether is sent to this address, send it back.
830         // The contracts must be used, not the fallback
831         revert();
832     }
833  
834     /**
835      * @dev adminDoDestructContract
836      */ 
837     function adminDoDestructContract() external onlyOwner { 
838         if (msg.sender == owner()) selfdestruct(msg.sender);
839     }
840 
841     /** 
842     @dev vaultRequestFromUser This allows the contract to transferFrom the user to 
843     themselves using allowance that has been previously set. 
844     @return string Message
845     */
846     function vaultRequestFromUser () external canPoSMint returns (string memory message) {
847      
848         // calculate remote allowance given to the contract on the senders address
849         // completed via the wallet
850         uint256 amountAllowed = _remoteToken.allowance(msg.sender, _vaultAddress);
851         require(amountAllowed > 0, "No allowance has been set.");        
852         require(amountAllowed <= _stakeMaximum, "The allowance has been set too high.");
853         uint256 amountBalance = _remoteToken.balanceOf(msg.sender);
854         require(amountBalance >= amountAllowed);
855         
856         require(_transferIns[msg.sender].amountInVault == 0,
857         "You are already staking. Cancel your stake (sacrificing reward), or collect your reward and send again.");
858         
859         require(amountBalance >= amountAllowed,
860         "The sending account balance is lower than the requested value.");
861         require(amountAllowed >= _stakeMinimum,
862         "There is a minimum stake amount set.");
863         uint256 vaultBalance = _remoteToken.balanceOf(_vaultAddress);
864         _remoteTransferFrom(msg.sender, _vaultAddress, amountAllowed);
865 
866         _transferIns[msg.sender].amountInVault = amountAllowed;
867         _transferIns[msg.sender].tokenTimestamp = block.timestamp;
868         _transferIns[msg.sender].percentageLower = _percentageLower;
869         _transferIns[msg.sender].percentageMiddle = _percentageMiddle;
870         _transferIns[msg.sender].percentageUpper = _percentageUpper;
871 
872         _transferIns[msg.sender].stakeMinimumTimestamp = _stakeMinimumTimestamp;
873         _transferIns[msg.sender].stakeMaximumTimestamp = _stakeMaximumTimestamp;
874 
875         _remoteToken.approve(_vaultAddress, vaultBalance.add(amountAllowed));  
876  
877         return "Vault deposit complete, thank you.";
878     }
879 
880     /**
881     * @dev vaultDetails
882     * @return address vaultAddress, 
883     * @return address remoteContractAddress,
884     * @return uint decimals
885      */ 
886     function vaultDetails() external view returns (
887         address vaultAddress,  
888         address remoteContractAddress, 
889         uint decimals) {
890         vaultAddress = _vaultAddress;
891         remoteContractAddress = _remoteContractAddress;      
892         decimals = _decimals;
893     }
894 
895     /**
896     @dev myBalance Return tokens from a balance
897     @return balance
898      */
899     function myBalance () external view returns(uint256 balance) {
900         balance = _balances[msg.sender];
901     }
902 
903     /**
904     @dev myAddress Return address from a sender. 
905     Useful for setting allowances
906     @return myAddress
907      */
908     function myAddress () external view returns(address myadddress) {
909         myadddress = msg.sender;
910     }
911 
912     /**
913     @dev vaultBalance Return number of tokens helds by the contract.
914     @return balance
915      */
916     function vaultBalance () external view onlyOwner returns(uint balance) {
917         balance = _balances[address(this)];
918     }
919 
920 }