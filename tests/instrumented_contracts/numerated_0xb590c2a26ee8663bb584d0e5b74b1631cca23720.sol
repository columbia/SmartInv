1 pragma solidity ^0.4.23;
2 
3 
4 // @title SafeMath
5 // @dev Math operations with safety checks that throw on error
6 library SafeMath {
7 
8   // @dev Multiplies two numbers, throws on overflow.
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     c = a * b;
18     require(c / a == b, "mul failed");
19     return c;
20   }
21 
22   // @dev Integer division of two numbers, truncating the quotient.
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b <= a, "sub fail");
33     return a - b;
34   }
35 
36   // @dev Adds two numbers, throws on overflow.
37   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     c = a + b;
39     require(c >= a, "add fail");
40     return c;
41   }
42 }
43 
44 
45 // @title ERC20 interface
46 // @dev see https://github.com/ethereum/EIPs/issues/20
47 contract iERC20 {
48   function allowance(address owner, address spender)
49     public view returns (uint256);
50 
51   function transferFrom(address from, address to, uint256 value)
52     public returns (bool);
53 
54   function approve(address spender, uint256 value) public returns (bool);
55 
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 tokens);
60   event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
61 }
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 // @title iNovaStaking
72 // @dev The interface for cross-contract calls to the Nova Staking contract
73 // @author Dragon Foundry (https://www.nvt.gg)
74 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
75 contract iNovaStaking {
76 
77   function balanceOf(address _owner) public view returns (uint256);
78 }
79 
80 
81 
82 // @title iNovaGame
83 // @dev The interface for cross-contract calls to the Nova Game contract
84 // @author Dragon Foundry (https://www.nvt.gg)
85 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
86 contract iNovaGame {
87   function isAdminForGame(uint _game, address account) external view returns(bool);
88 
89   // List of all games tracked by the Nova Game contract
90   uint[] public games;
91 }
92 
93 
94 
95 
96 
97 
98 
99 // @title NovaMasterAccess
100 // @dev NovaMasterAccess contract for controlling access to Nova Token contract functions
101 // @author Dragon Foundry (https://www.nvt.gg)
102 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
103 contract NovaMasterAccess {
104   using SafeMath for uint256;
105 
106   event OwnershipTransferred(address previousOwner, address newOwner);
107   event PromotedGame(uint game, bool isPromoted, string json);
108   event SuppressedGame(uint game, bool isSuppressed);
109 
110   // Reference to the address of the Nova Token ERC20 contract
111   iERC20 public nvtContract;
112 
113   // Reference to the address of the Nova Game contract
114   iNovaGame public gameContract;
115 
116   // The Owner can perform all admin tasks.
117   address public owner;
118 
119   // The Recovery account can change the Owner account.
120   address public recoveryAddress;
121 
122 
123   // @dev The original `owner` of the contract is the contract creator.
124   constructor() 
125     internal 
126   {
127     owner = msg.sender;
128   }
129 
130   // @dev Access control modifier to limit access to the Owner account
131   modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136   // @dev Access control modifier to limit access to the Recovery account
137   modifier onlyRecovery() {
138     require(msg.sender == recoveryAddress);
139     _;
140   }
141 
142   // @dev Assigns a new address to act as the Owner.
143   // @notice Can only be called by the recovery account
144   // @param _newOwner The address of the new Owner
145   function setOwner(address _newOwner) 
146     external 
147     onlyRecovery 
148   {
149     require(_newOwner != address(0));
150     require(_newOwner != recoveryAddress);
151 
152     owner = _newOwner;
153     emit OwnershipTransferred(owner, _newOwner);
154   }
155 
156   // @dev Assigns a new address to act as the Recovery address.
157   // @notice Can only be called by the Owner account
158   // @param _newRecovery The address of the new Recovery account
159   function setRecovery(address _newRecovery) 
160     external 
161     onlyOwner 
162   {
163     require(_newRecovery != address(0));
164     require(_newRecovery != owner);
165 
166     recoveryAddress = _newRecovery;
167   }
168 
169   // @dev Adds or removes a game from the list of promoted games
170   // @param _game - the game to be promoted
171   // @param _isPromoted - true for promoted, false for not
172   // @param _json - A json string to be used to display promotional information
173   function setPromotedGame(uint _game, bool _isPromoted, string _json)
174     external
175     onlyOwner
176   {
177     uint gameId = gameContract.games(_game);
178     require(gameId == _game, "gameIds must match");
179     emit PromotedGame(_game, _isPromoted, _isPromoted ? _json : "");
180   }
181 
182   // @dev Adds or removes a game from the list of suppressed games.
183   //   Suppressed games won't show up on the site, but can still be interacted with
184   //   by users.
185   // @param _game - the game to be promoted
186   // @param _isSuppressed - true for suppressed, false for not
187   function setSuppressedGame(uint _game, bool _isSuppressed)
188     external
189     onlyOwner
190   {
191     uint gameId = gameContract.games(_game);
192     require(gameId == _game, "gameIds must match");
193     emit SuppressedGame(_game, _isSuppressed);
194   }
195 }
196 
197 
198 
199 // @title ERC20 Sidechain manager imlpementation
200 // @dev Utility contract that manages Ethereum and ERC-20 tokens transferred in from the main chain
201 // @dev Can manage any number of tokens
202 // @author Dragon Foundry (https://www.nvt.gg)
203 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
204 contract NovaStakingBase is NovaMasterAccess, iNovaStaking {
205   using SafeMath for uint256;
206 
207   uint public constant WEEK_ZERO_START = 1538352000; // 10/1/2018 @ 00:00:00
208   uint public constant SECONDS_PER_WEEK = 604800;
209 
210   // The Nova Token balances of all games and users on the system
211   mapping(address => uint) public balances;
212   
213   // The number of Nova Tokens stored as income each week
214   mapping(uint => uint) public storedNVTbyWeek;
215 
216   // @dev Access control modifier to limit access to game admin accounts
217   modifier onlyGameAdmin(uint _game) {
218     require(gameContract.isAdminForGame(_game, msg.sender));
219     _;
220   }
221 
222   // @dev Used on deployment to link the Staking and Game contracts.
223   // @param _gameContract - the address of a valid GameContract instance
224   function linkContracts(address _gameContract)
225     external
226     onlyOwner
227   {
228     gameContract = iNovaGame(_gameContract);
229   }
230 
231   event Transfer(address indexed from, address indexed to, uint256 value);
232   event Balance(address account, uint256 value);
233   event StoredNVT(uint week, uint stored);
234 
235   // @dev Gets the balance of the specified address.
236   // @param _owner The address to query the the balance of.
237   // @returns An uint256 representing the amount owned by the passed address.
238   function balanceOf(address _owner) 
239     public
240     view
241   returns (uint256) {
242     return balances[_owner];
243   }
244 
245   // Internal transfer of ERC20 tokens to complete payment of an auction.
246   // @param _from The address which you want to send tokens from
247   // @param _to The address which you want to transfer to
248   // @param _value The amout of tokens to be transferred
249   function _transfer(address _from, address _to, uint _value) 
250     internal
251   {
252     require(_from != _to, "can't transfer to yourself");
253     balances[_from] = balances[_from].sub(_value);
254     balances[_to] = balances[_to].add(_value);
255     emit Transfer(_from, _to, _value);
256     emit Balance(_from, balances[_from]);
257     emit Balance(_to, balances[_to]);
258   }
259 
260   // @dev Gets the current week, as calculated by this smart contract
261   // @returns uint - the current week
262   function getCurrentWeek()
263     external
264     view
265   returns(uint) {
266     return _getCurrentWeek();
267   }
268 
269   // @dev Internal function to calculate the current week
270   // @returns uint - the current week
271   function _getCurrentWeek()
272     internal
273     view
274   returns(uint) {
275     return (now - WEEK_ZERO_START) / SECONDS_PER_WEEK;
276   }
277 }
278 
279 
280 // @title Nova Stake Management
281 // @dev NovaStakeManagement contract for managing stakes and game balances
282 // @author Dragon Foundry (https://www.nvt.gg)
283 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
284 contract NovaStakeManagement is NovaStakingBase {
285 
286   // Emitted whenever a user or game takes a payout from the system
287   event Payout(address indexed staker, uint amount, uint endWeek);
288 
289   // Emitted whenever a user's stake is increased or decreased.
290   event ChangeStake(uint week, uint indexed game, address indexed staker, uint prevStake, uint newStake,
291     uint accountStake, uint gameStake, uint totalStake);
292 
293   // @dev Tracks current stake levels for all accounts and games.
294   //   Tracks separately for accounts by game, accounts, games, and the total stake on the system
295   // Mapping(Game => Mapping(Account => Stake))
296   mapping(uint => mapping(address => uint)) public gameAccountStaked;
297   // Mapping(Account => Stake)
298   mapping(address => uint) public accountStaked;
299   // Mapping(Game => Stake)
300   mapping(uint => uint) public gameStaked;
301   // Stake
302   uint public totalStaked;
303 
304   // @dev Tracks stakes by week for accounts and games. Each is updated when a user changes their stake.
305   //   These can be zero if they haven't been updated during the current week, so "zero"
306   //     just means "look at the week before", as no stakes have been changed.
307   //   When setting a stake to zero, the system records a "1". This is safe, because it's stored
308   //     with 18 significant digits, and the calculation 
309   // Mapping(Week => Mapping(Game => Mapping(Account => Stake)))
310   mapping(uint => mapping(uint => mapping(address => uint))) public weekGameAccountStakes;
311   // Mapping(Week => Mapping(Account => Stake))
312   mapping(uint => mapping(address => uint)) public weekAccountStakes;
313   // Mapping(Week => Mapping(Game => Stake))
314   mapping(uint => mapping(uint => uint)) public weekGameStakes;
315   // Mapping(Week => Stake)
316   mapping(uint => uint) public weekTotalStakes;
317 
318   // The last week that an account took a payout. Used for calculating the remaining payout for the account
319   mapping(address => uint) public lastPayoutWeekByAccount;
320   // The last week that a game took a payout. Used for calculating the remaining payout for the game
321   mapping(uint => uint) public lastPayoutWeekByGame;
322 
323   // Tracks the amount of income the system has taken in.
324   // All income is paid out to games (50%) and stakers (50%)
325   mapping(uint => uint) public weeklyIncome;
326 
327   constructor()
328     public
329   {
330     weekTotalStakes[_getCurrentWeek() - 1] = 1;
331   }
332 
333 
334   // @dev Sets the sender's stake on a game to an amount.
335   // @param _game - the game to increase or decrease the sender's stake on
336   // @param _newStake - The new stake value. Can be an increase or decrease,
337   //   but must be different than their current stake, and lower than their staking balance.
338   function setStake(uint _game, uint _newStake)
339     public
340   {
341     uint currentStake = gameAccountStaked[_game][msg.sender];
342     if (currentStake < _newStake) {
343       increaseStake(_game, _newStake - currentStake);
344     } else 
345     if (currentStake > _newStake) {
346       decreaseStake(_game, currentStake - _newStake);
347 
348     }
349   }
350 
351   // @dev Increases the sender's stake on a game by an amount.
352   // @param _game - the game to increase the sender's stake on
353   // @param _increase - The increase must be non-zero, and less than 
354   //   or equal to the user's available staking balance
355   function increaseStake(uint _game, uint _increase)
356     public
357   returns(uint newStake) {
358     require(_increase > 0, "Must be a non-zero change");
359     // Take the payment
360     uint newBalance = balances[msg.sender].sub(_increase);
361     balances[msg.sender] = newBalance;
362     emit Balance(msg.sender, newBalance);
363 
364     uint prevStake = gameAccountStaked[_game][msg.sender];
365     newStake = prevStake.add(_increase);
366     uint gameStake = gameStaked[_game].add(_increase);
367     uint accountStake = accountStaked[msg.sender].add(_increase);
368     uint totalStake = totalStaked.add(_increase);
369 
370     _storeStakes(_game, msg.sender, prevStake, newStake, gameStake, accountStake, totalStake);
371   }
372 
373   // @dev Decreases the sender's stake on a game by an amount.
374   // @param _game - the game to decrease the sender's stake on
375   // @param _decrease - The decrease must be non-zero, and less than or equal to the user's stake on the game
376   function decreaseStake(uint _game, uint _decrease)
377     public
378   returns(uint newStake) {
379     require(_decrease > 0, "Must be a non-zero change");
380     uint newBalance = balances[msg.sender].add(_decrease);
381     balances[msg.sender] = newBalance;
382     emit Balance(msg.sender, newBalance);
383 
384     uint prevStake = gameAccountStaked[_game][msg.sender];
385     newStake = prevStake.sub(_decrease);
386     uint gameStake = gameStaked[_game].sub(_decrease);
387     uint accountStake = accountStaked[msg.sender].sub(_decrease);
388     uint totalStake = totalStaked.sub(_decrease);
389 
390     _storeStakes(_game, msg.sender, prevStake, newStake, gameStake, accountStake, totalStake);
391   }
392 
393   // @dev Lets a  staker collect the current payout for all their stakes.
394   // @param _numberOfWeeks - the number of weeks to collect. Set to 0 to collect all weeks.
395   // @returns _payout - the total payout over all the collected weeks
396   function collectPayout(uint _numberOfWeeks) 
397     public
398   returns(uint _payout) {
399     uint startWeek = lastPayoutWeekByAccount[msg.sender];
400     require(startWeek > 0, "must be a valid start week");
401     uint endWeek = _getEndWeek(startWeek, _numberOfWeeks);
402     require(startWeek < endWeek, "must be at least one week to pay out");
403     
404     uint lastWeekStake;
405     for (uint i = startWeek; i < endWeek; i++) {
406       // Get the stake for the week. Use the last week's stake if the stake hasn't changed
407       uint weeklyStake = weekAccountStakes[i][msg.sender] == 0 
408           ? lastWeekStake 
409           : weekAccountStakes[i][msg.sender];
410       lastWeekStake = weeklyStake;
411 
412       uint weekStake = _getWeekTotalStake(i);
413       uint storedNVT = storedNVTbyWeek[i];
414       uint weeklyPayout = storedNVT > 1 && weeklyStake > 1 && weekStake > 1 
415         ? weeklyStake.mul(storedNVT) / weekStake / 2
416         : 0;
417       _payout = _payout.add(weeklyPayout);
418 
419     }
420     // If the weekly stake for the end week is not set, set it to the
421     //   last week's stake, to ensure we know what to pay out.
422     // This works even if the end week is the current week; the value
423     //   will be overwritten if necessary by future stake changes
424     if(weekAccountStakes[endWeek][msg.sender] == 0) {
425       weekAccountStakes[endWeek][msg.sender] = lastWeekStake;
426     }
427     // Always update the last payout week
428     lastPayoutWeekByAccount[msg.sender] = endWeek;
429 
430     _transfer(address(this), msg.sender, _payout);
431     emit Payout(msg.sender, _payout, endWeek);
432   }
433 
434   // @dev Lets a game admin collect the current payout for their game.
435   // @param _game - the game to collect
436   // @param _numberOfWeeks - the number of weeks to collect. Set to 0 to collect all weeks.
437   // @returns _payout - the total payout over all the collected weeks
438   function collectGamePayout(uint _game, uint _numberOfWeeks)
439     external
440     onlyGameAdmin(_game)
441   returns(uint _payout) {
442     uint week = lastPayoutWeekByGame[_game];
443     require(week > 0, "must be a valid start week");
444     uint endWeek = _getEndWeek(week, _numberOfWeeks);
445     require(week < endWeek, "must be at least one week to pay out");
446 
447     uint lastWeekStake;
448     for (week; week < endWeek; week++) {
449       // Get the stake for the week. Use the last week's stake if the stake hasn't changed
450       uint weeklyStake = weekGameStakes[week][_game] == 0 
451           ? lastWeekStake 
452           : weekGameStakes[week][_game];
453       lastWeekStake = weeklyStake;
454 
455       uint weekStake = _getWeekTotalStake(week);
456       uint storedNVT = storedNVTbyWeek[week];
457       uint weeklyPayout = storedNVT > 1 && weeklyStake > 1 && weekStake > 1 
458         ? weeklyStake.mul(storedNVT) / weekStake / 2
459         : 0;
460       _payout = _payout.add(weeklyPayout);
461     }
462     // If the weekly stake for the end week is not set, set it to 
463     //   the last week's stake, to ensure we know what to pay out
464     //   This works even if the end week is the current week; the value
465     //   will be overwritten if necessary by future stake changes
466     if(weekGameStakes[endWeek][_game] == 0) {
467       weekGameStakes[endWeek][_game] = lastWeekStake;
468     }
469     // Always update the last payout week
470     lastPayoutWeekByGame[_game] = endWeek;
471 
472     _transfer(address(this), address(_game), _payout);
473     emit Payout(address(_game), _payout, endWeek);
474   }
475 
476   // @dev Internal function to calculate the game, account, and total stakes on a stake change
477   // @param _game - the game to be staked on
478   // @param _staker - the account doing the staking
479   // @param _prevStake - the previous stake of the staker on that game
480   // @param _newStake - the newly updated stake of the staker on that game
481   // @param _gameStake - the new total stake for the game
482   // @param _accountStake - the new total stake for the staker's account
483   // @param _totalStake - the new total stake for the system as a whole
484   function _storeStakes(uint _game, address _staker, uint _prevStake, uint _newStake,
485     uint _gameStake, uint _accountStake, uint _totalStake)
486     internal
487   {
488     uint _currentWeek = _getCurrentWeek();
489 
490     gameAccountStaked[_game][msg.sender] = _newStake;
491     gameStaked[_game] = _gameStake;
492     accountStaked[msg.sender] = _accountStake;
493     totalStaked = _totalStake;
494     
495     // Each of these stores the weekly stake as "1" if it's been set to 0.
496     // This tracks the difference between "not set this week" and "set to zero this week"
497     weekGameAccountStakes[_currentWeek][_game][_staker] = _newStake > 0 ? _newStake : 1;
498     weekAccountStakes[_currentWeek][_staker] = _accountStake > 0 ? _accountStake : 1;
499     weekGameStakes[_currentWeek][_game] = _gameStake > 0 ? _gameStake : 1;
500     weekTotalStakes[_currentWeek] = _totalStake > 0 ? _totalStake : 1;
501 
502     // Get the last payout week; set it to this week if there hasn't been a week.
503     // This lets the user iterate payouts correctly.
504     if(lastPayoutWeekByAccount[_staker] == 0) {
505       lastPayoutWeekByAccount[_staker] = _currentWeek - 1;
506       if (lastPayoutWeekByGame[_game] == 0) {
507         lastPayoutWeekByGame[_game] = _currentWeek - 1;
508       }
509     }
510 
511     emit ChangeStake(_currentWeek, _game, _staker, _prevStake, _newStake, 
512       _accountStake, _gameStake, _totalStake);
513   }
514 
515   // @dev Internal function to get the total stake for a given week
516   // @notice This updates the stored values for intervening weeks, 
517   //   as that's more efficient at 100 or more users
518   // @param _week - the week in which to calculate the total stake
519   // @returns _stake - the total stake in that week
520   function _getWeekTotalStake(uint _week)
521     internal
522   returns(uint _stake) {
523     _stake = weekTotalStakes[_week];
524     if(_stake == 0) {
525       uint backWeek = _week;
526       while(_stake == 0) {
527         backWeek--;
528         _stake = weekTotalStakes[backWeek];
529       }
530       weekTotalStakes[_week] = _stake;
531     }
532   }
533 
534   // @dev Internal function to get the end week based on start, number of weeks, and current week
535   // @param _startWeek - the start of the range
536   // @param _numberOfWeeks - the length of the range
537   // @returns endWeek - either the current week, or the end of the range
538   // @notice This throws if it tries to get a week range longer than the current week
539   function _getEndWeek(uint _startWeek, uint _numberOfWeeks)
540     internal
541     view
542   returns(uint endWeek) {
543     uint _currentWeek = _getCurrentWeek();
544     require(_startWeek < _currentWeek, "must get at least one week");
545     endWeek = _numberOfWeeks == 0 ? _currentWeek : _startWeek + _numberOfWeeks;
546     require(endWeek <= _currentWeek, "can't get more than the current week");
547   }
548 }
549 
550 
551 
552 // @title NovaToken ERC20 contract
553 // @dev ERC20 management contract, designed to make using ERC-20 tokens easier
554 // @author Dragon Foundry (https://www.nvt.gg)
555 // (c) 2018 Dragon Foundry LLC. All Rights Reserved. This code is not open source.
556 contract NovaStaking is NovaStakeManagement {
557 
558   event Deposit(address account, uint256 amount, uint256 balance);
559   event Withdrawal(address account, uint256 amount, uint256 balance);
560 
561   // @dev Constructor creates a reference to the NFT ownership contract
562   //  and verifies the manager cut is in the valid range.
563   // @param _nvtContract - address of the mainnet NovaToken contract
564   constructor(iERC20 _nvtContract)
565     public
566   {
567     nvtContract = _nvtContract;
568   }
569 
570   // @dev Allows a user to deposit NVT through approveAndCall.
571   // @notice Other methods of sending NVT to this contract will still work, but will result in you losing your NVT.
572   // @param _sender is the original sender of the message
573   // @param _amount is the amount of NVT that was approved
574   // @param _contract is the contract that sent the approval; we check to be sure it's the NVT contract
575   // @param _data is the data that is passed in along with the call. It's not used here
576   function receiveApproval(address _sender, uint _amount, address _contract, bytes _data)
577     public
578   {
579     require(_data.length == 0, "you must pass no data");
580     require(_contract == address(nvtContract), "sending from a non-NVT contract is not allowed");
581 
582     // Track the transferred NVT
583     uint newBalance = balances[_sender].add(_amount);
584     balances[_sender] = newBalance;
585 
586     emit Balance(_sender, newBalance);
587     emit Deposit(_sender, _amount, newBalance);
588 
589     // Transfer the NVT to this
590     require(nvtContract.transferFrom(_sender, address(this), _amount), "must successfully transfer");
591   }
592 
593   function receiveNVT(uint _amount, uint _week) 
594     external
595   {
596     require(_week >= _getCurrentWeek(), "Current Week must be equal or greater");
597     uint totalDonation = weeklyIncome[_week].add(_amount);
598     weeklyIncome[_week] = totalDonation;
599 
600     uint stored = storedNVTbyWeek[_week].add(_amount);
601     storedNVTbyWeek[_week] = stored;
602     emit StoredNVT(_week, stored);
603     // transfer the donation
604     _transfer(msg.sender, address(this), _amount);
605   }
606 
607   // @dev Allows a user to withdraw some or all of their NVT stored in this contract
608   // @param _sender is the original sender of the message
609   // @param _amount is the amount of NVT to be withdrawn. Withdraw(0) will withdraw all.
610   // @returns true if successful, false if unsuccessful, but will most throw on most failures
611   function withdraw(uint amount)
612     external
613   {
614     uint withdrawalAmount = amount > 0 ? amount : balances[msg.sender];
615     require(withdrawalAmount > 0, "Can't withdraw - zero balance");
616     uint newBalance = balances[msg.sender].sub(withdrawalAmount);
617     balances[msg.sender] = newBalance;
618     emit Withdrawal(msg.sender, withdrawalAmount, newBalance);
619     emit Balance(msg.sender, newBalance);
620     nvtContract.transfer(msg.sender, withdrawalAmount);
621   }
622 
623   // @dev Add more ERC-20 tokens to a game. Can be used to fund games with Nova Tokens for card creation
624   // @param _game - the # of the game to add tokens to
625   // @param _tokensToToAdd - the number of Nova Tokens to transfer from the calling account
626   function addNVTtoGame(uint _game, uint _tokensToToAdd)
627     external
628     onlyGameAdmin(_game)
629   {
630     // Take the funding, and apply it to the GAME's address (a fake ETH address...)
631     _transfer(msg.sender, address(_game), _tokensToToAdd);
632   }
633 
634   // @dev Withdraw earned (or funded) Nova Tokens from a game.
635   // @param _game - the # of the game to add tokens to
636   // @param _tokensToWithdraw - the number of NVT to transfer from the game to the calling account
637   function withdrawNVTfromGame(uint _game, uint _tokensToWithdraw)
638     external
639     onlyGameAdmin(_game)
640   {
641     // Take the NVT funds from the game, and apply them to the game admin's address
642     _transfer(address(_game), msg.sender, _tokensToWithdraw);
643   }
644 }