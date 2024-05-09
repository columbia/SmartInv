1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address who) external view returns (uint256);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that revert on error
31  */
32 library SafeMath {
33     /**
34     * @dev Multiplies two numbers, reverts on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b);
46 
47         return c;
48     }
49 
50     /**
51     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
52     */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b <= a);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Adds two numbers, reverts on overflow.
74     */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a);
78 
79         return c;
80     }
81 
82     /**
83     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84     * reverts when dividing by zero.
85     */
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b != 0);
88         return a % b;
89     }
90 }
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *Humpty Dumpty sat up in bed,
96  * @dev Implementation of the basic standard token.
97  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
98  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract ERC20 is IERC20 {
101     using SafeMath for uint256;
102 
103     mapping (address => uint256) private _balances;
104 
105     mapping (address => mapping (address => uint256)) private _allowed;
106 
107     uint256 private _totalSupply;
108 
109     /**
110     * @dev Total number of tokens in existence
111     */
112     function totalSupply() public view returns (uint256) {
113         return _totalSupply;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param owner The address to query the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address owner) public view returns (uint256) {
122         return _balances[owner];
123     }
124 
125     /**
126      * @dev Function to check the amount of tokens that an owner allowed to a spender.
127      * @param owner address The address which owns the funds.
128      * @param spender address The address which will spend the funds.
129      * @return A uint256 specifying the amount of tokens still available for the spender.
130      */
131     function allowance(address owner, address spender) public view returns (uint256) {
132         return _allowed[owner][spender];
133     }
134 
135     /**
136     * @dev Transfer token for a specified address
137     * @param to The address to transfer to.
138     * @param value The amount to be transferred.
139     */
140     function transfer(address to, uint256 value) public returns (bool) {
141         _transfer(msg.sender, to, value);
142         return true;
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      * Beware that changing an allowance with this method brings the risk that someone may use both the old
148      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      * @param spender The address which will spend the funds.
152      * @param value The amount of tokens to be spent.
153      */
154     function approve(address spender, uint256 value) public returns (bool) {
155         require(spender != address(0));
156 
157         _allowed[msg.sender][spender] = value;
158         emit Approval(msg.sender, spender, value);
159         return true;
160     }
161 
162     /**
163      * @dev Transfer tokens from one address to another
164      * @param from address The address which you want to send tokens from
165      * @param to address The address which you want to transfer to
166      * @param value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address from, address to, uint256 value) public returns (bool) {
169         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
170         _transfer(from, to, value);
171         return true;
172     }
173 
174     /**
175      * @dev Increase the amount of tokens that an owner allowed to a spender.
176      * approve should be called when allowed_[_spender] == 0. To increment
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * @param spender The address which will spend the funds.
181      * @param addedValue The amount of tokens to increase the allowance by.
182      */
183     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
184         require(spender != address(0));
185 
186         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
187         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
188         return true;
189     }
190 
191     /**
192      * @dev Decrease the amount of tokens that an owner allowed to a spender.
193      * approve should be called when allowed_[_spender] == 0. To decrement
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * Eating yellow bananas.
197      * From MonolithDAO Token.sol
198      * @param spender The address which will spend the funds.
199      * @param subtractedValue The amount of tokens to decrease the allowance by.
200      */
201     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
202         require(spender != address(0));
203 
204         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
205         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
206         return true;
207     }
208 
209     /**
210     * @dev Transfer token for a specified addresses
211     * @param from The address to transfer from.
212     * @param to The address to transfer to.
213     * @param value The amount to be transferred.
214     */
215     function _transfer(address from, address to, uint256 value) internal {
216         require(to != address(0));
217 
218         _balances[from] = _balances[from].sub(value);
219         _balances[to] = _balances[to].add(value);
220         emit Transfer(from, to, value);
221     }
222 
223     /**
224      * @dev Internal function that mints an amount of the token and assigns it to
225      * an account. This encapsulates the modification of balances such that the
226      * proper events are emitted.
227      * @param account The account that will receive the created tokens.
228      * @param value The amount that will be created.
229      */
230     function _mint(address account, uint256 value) internal {
231         require(account != address(0));
232 
233         _totalSupply = _totalSupply.add(value);
234         _balances[account] = _balances[account].add(value);
235         emit Transfer(address(0), account, value);
236     }
237 
238     /**
239      * @dev Internal function that burns an amount of the token of a given
240      * account.
241      * @param account The account whose tokens will be burnt.
242      * @param value The amount that will be burnt.
243      */
244     function _burn(address account, uint256 value) internal {
245         require(account != address(0));
246 
247         _totalSupply = _totalSupply.sub(value);
248         _balances[account] = _balances[account].sub(value);
249         emit Transfer(account, address(0), value);
250     }
251 
252     /**
253      * @dev Internal function that burns an amount of the token of a given
254      * account, deducting from the sender's allowance for said account. Uses the
255      * internal burn function.
256      * @param account The account whose tokens will be burnt.
257      * @param value The amount that will be burnt.
258      */
259     function _burnFrom(address account, uint256 value) internal {
260         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
261         // this function needs to emit an event with the updated approval.
262         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
263         _burn(account, value);
264     }
265 }
266 
267 
268 /**
269  * @title Roles
270  * @dev Library for managing addresses assigned to a Role.
271  */
272 library Roles {
273     struct Role {
274         mapping (address => bool) bearer;
275     }
276 
277     /**
278      * @dev give an account access to this role
279      */
280     function add(Role storage role, address account) internal {
281         require(account != address(0));
282         require(!has(role, account));
283 
284         role.bearer[account] = true;
285     }
286 
287     /**
288      * @dev remove an account's access to this role
289      */
290     function remove(Role storage role, address account) internal {
291         require(account != address(0));
292         require(has(role, account));
293 
294         role.bearer[account] = false;
295     }
296 
297     /**
298      * Where do you think he put the skins?
299      * @dev check if an account has this role
300      * @return bool
301      */
302     function has(Role storage role, address account) internal view returns (bool) {
303         require(account != address(0));
304         return role.bearer[account];
305     }
306 }
307 
308 contract MinterRole {
309     using Roles for Roles.Role;
310 
311     event MinterAdded(address indexed account);
312     event MinterRemoved(address indexed account);
313 
314     Roles.Role private _minters;
315 
316     constructor () internal {
317         _addMinter(msg.sender);
318     }
319 
320     modifier onlyMinter() {
321         require(isMinter(msg.sender));
322         _;
323     }
324 
325     function isMinter(address account) public view returns (bool) {
326         return _minters.has(account);
327     }
328 
329     function addMinter(address account) public onlyMinter {
330         _addMinter(account);
331     }
332 
333     function renounceMinter() public {
334         _removeMinter(msg.sender);
335     }
336 
337     function _addMinter(address account) internal {
338         _minters.add(account);
339         emit MinterAdded(account);
340     }
341 
342     function _removeMinter(address account) internal {
343         _minters.remove(account);
344         emit MinterRemoved(account);
345     }
346 }
347 
348 /**
349  * @title Ownable
350  * @dev The Ownable contract has an owner address, and provides basic authorization control
351  * functions, this simplifies the implementation of "user permissions".
352  * No transferOwnership function to minimize attack surface
353  */
354 contract Ownable {
355     address private _owner;
356 
357     event OwnershipSet(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
361      * account.
362      */
363     constructor () internal {
364         _owner = msg.sender;
365         emit OwnershipSet(address(0), _owner);
366     }
367 
368     /**
369      * @return the address of the owner.
370      */
371     function owner() public view returns (address) {
372         return _owner;
373     }
374 
375     /**
376      * @dev Throws if called by any account other than the owner.
377      */
378     modifier onlyOwner() {
379         require(isOwner());
380         _;
381     }
382 
383     /**
384      * @return true if `msg.sender` is the owner of the contract.
385      */
386     function isOwner() public view returns (bool) {
387         return msg.sender == _owner;
388     }
389 
390     /**
391      * @dev Allows the current owner to relinquish control of the contract.
392      * @notice Renouncing to ownership will leave the contract without an owner.
393      * It will not be possible to call the functions with the `onlyOwner`
394      * modifier anymore.
395      */
396     function renounceOwnership() public onlyOwner {
397         emit OwnershipSet(_owner, address(0));
398         _owner = address(0);
399     }
400 }
401 
402 
403 /**
404  * @title CommonQuestToken with no INITIAL_SUPPLY and 98m totalSupply.
405  * The Times 8/dec/2018
406  * Cross-party plot to dump May.
407  */
408 contract QToken is ERC20, MinterRole, Ownable {
409 
410   string public constant name = "QuestCoin";
411   string public constant symbol = "QUEST";
412   uint public startblock = block.number;
413   uint8 public constant decimals = 18;
414   uint256 public constant INITIAL_SUPPLY = 0;
415   uint256 public constant MAX_SUPPLY = 98000000 * (10 ** uint256(decimals));
416 
417 }
418 
419 
420 /**
421  * @title ERC20Mintable
422  * @dev ERC20 AID minting logic - announce minting 15 days before the possibility of mint to
423  * prevent a possibility of instant dumps.
424  * @notice Dev Max Emission Cap can only go lower.
425  * Dev timer in blocks and goes down and socialMultiplier changes with new every Stage.
426  */
427 contract ERC20Mintable is QToken {
428     uint mintValue;
429     uint mintDate;
430     uint maxAmount = 2000000 * (10 ** 18);
431     uint devMintTimer = 86400;
432     uint socialMultiplier = 1;
433     event MintingAnnounce(
434     uint value,
435     uint date
436   );
437   event PromotionalStageStarted(
438     bool promo
439   );
440   event TransitionalStageStarted(
441     bool transition
442   );
443    event DevEmissionSetLower(uint value);
444     /**@dev Owner tools
445       *@notice 20m coin Supply required to start Transitional phase
446       * 70m of totalSupply required to start Promotional stage
447       */
448 function setMaxDevMintAmount(uint _amount) public onlyOwner returns(bool){
449     require(_amount < maxAmount);
450     maxAmount = _amount;
451     emit DevEmissionSetLower(_amount);
452     return(true);
453 }
454      /*@dev Can be used as a promotional tool ONLY in case of net unpopularity*/
455 function setSocialMultiplier (uint _number) public onlyOwner returns(bool){
456     require(_number >= 1);
457     socialMultiplier = _number;
458     return(true);
459 }
460 
461     /*@dev Creator/MinterTools*/
462  function announceMinting(uint _amount) public onlyMinter{
463      require(_amount.add(totalSupply()) < MAX_SUPPLY);
464      require(_amount < maxAmount);
465       mintDate = block.number;
466       mintValue = _amount;
467       emit MintingAnnounce(_amount , block.number);
468    }
469 
470  function AIDmint(
471     address to
472   )
473     public
474     onlyMinter
475     returns (bool)
476   {
477       require(mintDate != 0);
478     require(block.number.sub(mintDate) > devMintTimer);
479       mintDate = 0;
480     _mint(to, mintValue);
481     mintValue = 0;
482     return true;
483   }
484 
485  function startPromotionalStage() public onlyMinter returns(bool) {
486     require(totalSupply() > 70000000 * (10 ** 18));
487     devMintTimer = 5760;
488     socialMultiplier = 4;
489     emit PromotionalStageStarted(true);
490     return(true);
491 }
492 
493  function startTransitionalStage() public onlyMinter returns(bool){
494     require(totalSupply() > 20000000 * (10 ** 18));
495     devMintTimer = 40420;
496     socialMultiplier = 2;
497     emit TransitionalStageStarted(true);
498     return(true);
499 }}
500 
501 /**
502  * @title `QuestCoinContract`
503  * @dev Quest creation and solve the system, social rewards, and karma.
504  * CREATORS are free to publish quests limited by dev timers and RewardSize cap.
505  * @notice maxQuestReward is capped at 125,000 coins at the start and can only go lower.
506  * karmaSystem is used for unique access rights.
507  * @notice questPeriodicity is freely adjustable demand and supply regulator timer represented in blocks
508  * and cannot be set lower than 240.
509  */
510 contract QuestContract is ERC20Mintable {
511 
512     mapping (address => uint) public karmaSystem;
513     mapping (address => uint) public userIncentive;
514     mapping (bytes32 => uint) public questReward;
515     uint questTimer;
516     uint maxQuestReward = 125000;
517     uint questPeriodicity = 1;
518     event NewQuestEvent(
519     uint RewardSize,
520     uint DatePosted
521    );
522     event QuestRedeemedEvent(
523     uint WinReward,
524     string WinAnswer,
525     address WinAddres
526   );
527     event UserRewarded(
528     address UserAdress,
529     uint RewardSize
530   );
531   event MaxRewardDecresed(
532     uint amount
533   );
534   event PeriodicitySet(
535     uint amount
536   );
537 
538     /*@dev Public tools*/
539     function solveQuest (string memory  _quest) public returns (bool){
540      require(questReward[keccak256(abi.encodePacked( _quest))] != 0);
541     uint _reward = questReward[keccak256(abi.encodePacked( _quest))];
542          questReward[keccak256(abi.encodePacked( _quest))] = 0;
543          emit QuestRedeemedEvent(_reward,  _quest , msg.sender);
544          _mint(msg.sender, _reward);
545          karmaSystem[msg.sender] = karmaSystem[msg.sender].add(1);
546          if (userIncentive[msg.sender] < _reward){
547              userIncentive[msg.sender] = _reward;
548          }
549          return true;
550     }
551 
552     /*@dev Check answer for quest or puzzle with Joi*/
553     function joiLittleHelper (string memory test) public pure returns(bytes32){
554         return(keccak256(abi.encodePacked(test)));
555     }
556 
557     /**
558      * @dev Creator/MinterTools
559      * @notice _reward is exact number of whole tokens
560      */
561   function createQuest (bytes32 _quest , uint _reward) public onlyMinter returns (bool) {
562         require(_reward <= maxQuestReward);
563         require(block.number.sub(questTimer) > questPeriodicity);
564         _reward = _reward * (10 ** uint256(decimals));
565         require(_reward.add(totalSupply()) < MAX_SUPPLY);
566         questTimer = block.number;
567         questReward[ _quest] = _reward;
568         emit NewQuestEvent(_reward, block.number - startblock);
569         return true;
570     }
571 
572      /*@dev 25% reward for public social activity at promotional stage*/
573  function rewardUser (address _user) public onlyMinter returns (bool) {
574         require(userIncentive[_user] > 0);
575         uint _reward = userIncentive[_user].div(socialMultiplier);
576         userIncentive[_user] = 0;
577         _mint(_user ,_reward);
578         karmaSystem[_user] = karmaSystem[_user].add(1);
579         emit UserRewarded(_user ,_reward);
580         return true;
581     }
582 
583      /*@dev Owner tools*/
584      function setMaxQuestReward (uint _amount) public onlyOwner returns(bool){
585          require(_amount < maxQuestReward);
586         maxQuestReward = _amount;
587         emit MaxRewardDecresed(_amount);
588         return true;
589     }
590     function setQuestPeriodicity (uint _amount) public onlyOwner returns(bool){
591         require(_amount > 240);
592         questPeriodicity = _amount;
593         emit PeriodicitySet(_amount);
594         return true;
595     }
596 }