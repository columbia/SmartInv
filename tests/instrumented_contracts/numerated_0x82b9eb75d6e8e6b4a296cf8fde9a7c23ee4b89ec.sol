1 pragma solidity 0.5.7;
2 /** 
3  _____                   __  __      ______      ____                 ____       ______      ______   
4 /\  __`\     /'\_/`\    /\ \/\ \    /\__  _\    /\  _`\              /\  _`\    /\__  _\    /\__  _\  
5 \ \ \/\ \   /\      \   \ \ `\\ \   \/_/\ \/    \ \,\L\_\            \ \ \L\ \  \/_/\ \/    \/_/\ \/  
6  \ \ \ \ \  \ \ \__\ \   \ \ , ` \     \ \ \     \/_\__ \    _______  \ \  _ <'    \ \ \       \ \ \  
7   \ \ \_\ \  \ \ \_/\ \   \ \ \`\ \     \_\ \__    /\ \L\ \ /\______\  \ \ \L\ \    \_\ \__     \ \ \ 
8    \ \_____\  \ \_\\ \_\   \ \_\ \_\    /\_____\   \ `\____\\/______/   \ \____/    /\_____\     \ \_\
9     \/_____/   \/_/ \/_/    \/_/\/_/    \/_____/    \/_____/             \/___/     \/_____/      \/_/
10 
11     WEBSITE: www.omnis-bit.com
12 
13 
14     This contract's staking features are based on the code provided at
15     https://github.com/PoSToken/PoSToken
16 
17     SafeMath Library provided by OpenZeppelin
18     https://github.com/OpenZeppelin/openzeppelin-solidity
19 
20     TODO: Third Party Audit
21     
22     Contract Developed and Designed by StartBlock for the Omnis-Bit Team
23     Contract Writer: Fares A. Akel C.
24     Service Provider Contact: info@startblock.tech
25  */
26 
27 /**
28  * @title SafeMath
29  * @dev Unsigned math operations with safety checks that revert on error.
30  */
31 library SafeMath {
32     /**
33      * @dev Multiplies two unsigned integers, reverts on overflow.
34      */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
51      */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0, "SafeMath: division by zero");
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     /**
62      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a, "SafeMath: subtraction overflow");
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Adds two unsigned integers, reverts on overflow.
73      */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77 
78         return c;
79     }
80 
81     /**
82      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
83      * reverts when dividing by zero.
84      */
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0, "SafeMath: modulo by zero");
87         return a % b;
88     }
89 }
90 
91 /**
92  * @title Admined
93  * @dev The Admined contract has an owner address, can set administrators,
94  * and provides authorization control functions. These features can be used in other contracts
95  * through interfacing, so external contracts can check main contract admin levels
96  */
97 contract Admined {
98     address public owner; //named owner for etherscan compatibility
99     mapping(address => uint256) public level;
100 
101     /**
102      * @dev The Admined constructor sets the original `owner` of the contract to the sender
103      * account and assing high level privileges.
104      */
105     constructor() public {
106         owner = msg.sender;
107         level[owner] = 3;
108         emit OwnerSet(owner);
109         emit LevelSet(owner, level[owner]);
110     }
111 
112     /**
113      * @dev Throws if called by any account with lower level than minLvl.
114      * @param _minLvl Minimum level to use the function
115      */
116     modifier onlyAdmin(uint256 _minLvl) {
117         require(level[msg.sender] >= _minLvl, 'You do not have privileges for this transaction');
118         _;
119     }
120 
121     /**
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferOwnership(address newOwner) onlyAdmin(3) public {
126         require(newOwner != address(0), 'Address cannot be zero');
127 
128         owner = newOwner;
129         level[owner] = 3;
130 
131         emit OwnerSet(owner);
132         emit LevelSet(owner, level[owner]);
133 
134         level[msg.sender] = 0;
135         emit LevelSet(msg.sender, level[msg.sender]);
136     }
137 
138     /**
139      * @dev Allows the assignment of new privileges to a new address.
140      * @param userAddress The address to transfer ownership to.
141      * @param lvl Lvl to assign.
142      */
143     function setLevel(address userAddress, uint256 lvl) onlyAdmin(2) public {
144         require(userAddress != address(0), 'Address cannot be zero');
145         require(lvl < level[msg.sender], 'You do not have privileges for this level assignment');
146 
147         level[userAddress] = lvl;
148         emit LevelSet(userAddress, level[userAddress]);
149     }
150 
151     event LevelSet(address indexed user, uint256 lvl);
152     event OwnerSet(address indexed user);
153 
154 }
155 
156 /**
157  * @title ERC20Basic
158  * @dev Simpler version of ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/179
160  */
161 contract ERC20Basic {
162     uint256 public totalSupply;
163 
164     function balanceOf(address who) public view returns(uint256);
165 
166     function transfer(address to, uint256 value) public returns(bool);
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 }
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175     function allowance(address owner, address spender) public view returns(uint256);
176 
177     function transferFrom(address from, address to, uint256 value) public returns(bool);
178 
179     function approve(address spender, uint256 value) public returns(bool);
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 contract StakerToken {
184     uint256 public stakeStartTime;
185     uint256 public stakeMinAge;
186     uint256 public stakeMaxAge;
187 
188     function claimStake() public returns(bool);
189 
190     function coinAge() public view returns(uint256);
191 
192     function annualInterest() public view returns(uint256);
193 }
194 
195 contract OMNIS is ERC20, StakerToken, Admined {
196     using SafeMath
197     for uint256;
198     ///////////////////////////////////////////////////////////////////
199     //TOKEN RELATED
200     string public name = "OMNIS-BIT";
201     string public symbol = "OMNIS";
202     string public version = "v3";
203     uint8 public decimals = 18;
204 
205     uint public totalSupply;
206     uint public maxTotalSupply;
207     uint public totalInitialSupply;
208     bool public globalBalancesFreeze; //In case of a Migration to let make a SnapShot
209 
210     mapping(address => uint256) balances;
211     mapping(address => mapping(address => uint256)) allowed;
212     //TOKEN SECTION END
213     ///////////////////////////////////////////////////////////////////
214 
215     ///////////////////////////////////////////////////////////////////
216     //AIRDROP RELATED
217     struct Airdrop {
218         uint value;
219         bool claimed;
220     }
221 
222     address public airdropWallet;
223 
224     mapping(address => Airdrop) public airdrops; //One airdrop at a time allowed
225     //AIRDROP SECTION END
226     ///////////////////////////////////////////////////////////////////
227 
228     ///////////////////////////////////////////////////////////////////
229     //ESCROW RELATED
230     enum PaymentStatus {
231         Requested,
232         Rejected,
233         Pending,
234         Completed,
235         Refunded
236     }
237 
238     struct Payment {
239         address provider;
240         address customer;
241         uint value;
242         string comment;
243         PaymentStatus status;
244         bool refundApproved;
245     }
246 
247     uint escrowCounter;
248     uint public escrowFeePercent = 5; //initially set to 0.5%
249     bool public escrowEnabled = true;
250 
251     /**
252      * @dev Throws if escrow is disabled.
253      */
254     modifier escrowIsEnabled() {
255         require(escrowEnabled == true, 'Escrow is Disabled');
256         _;
257     }
258 
259     mapping(uint => Payment) public payments;
260     address public collectionAddress;
261     //ESCROW SECTION END
262     ///////////////////////////////////////////////////////////////////
263 
264     ///////////////////////////////////////////////////////////////////
265     //STAKING RELATED
266     struct transferInStruct {
267         uint128 amount;
268         uint64 time;
269     }
270 
271     uint public chainStartTime;
272     uint public chainStartBlockNumber;
273     uint public stakeStartTime;
274     uint public stakeMinAge = 3 days;
275     uint public stakeMaxAge = 90 days;
276 
277     mapping(address => bool) public userFreeze;
278 
279     mapping(address => transferInStruct[]) transferIns;
280 
281     modifier canPoSclaimStake() {
282         require(totalSupply < maxTotalSupply, 'Max supply reached');
283         _;
284     }
285     //STAKING SECTION END
286     ///////////////////////////////////////////////////////////////////
287 
288     /**
289      * @dev Throws if any frozen is applied.
290      * @param _holderWallet Address of the actual token holder
291      */
292     modifier notFrozen(address _holderWallet) {
293         require(globalBalancesFreeze == false, 'Balances are globally frozen');
294         require(userFreeze[_holderWallet] == false, 'Balance frozen by the user');
295         _;
296     }
297 
298     ///////////////////////////////////////////////////////////////////
299     //EVENTS
300     event ClaimStake(address indexed _address, uint _reward);
301     event NewCollectionWallet(address newWallet);
302 
303     event ClaimDrop(address indexed user, uint value);
304     event NewAirdropWallet(address newWallet);
305 
306     event GlobalFreeze(bool status);
307 
308     event EscrowLock(bool status);
309     event NewFeeRate(uint newFee);
310     event PaymentCreation(
311         uint indexed orderId,
312         address indexed provider,
313         address indexed customer,
314         uint value,
315         string description
316     );
317     event PaymentUpdate(
318         uint indexed orderId,
319         address indexed provider,
320         address indexed customer,
321         uint value,
322         PaymentStatus status
323     );
324     event PaymentRefundApprove(
325         uint indexed orderId,
326         address indexed provider,
327         address indexed customer,
328         bool status
329     );
330     ///////////////////////////////////////////////////////////////////
331 
332     constructor() public {
333 
334         maxTotalSupply = 1000000000 * 10 ** 18; //MAX SUPPLY EVER
335         totalInitialSupply = 820000000 * 10 ** 18; //INITIAL SUPPLY
336         chainStartTime = now; //Deployment Time
337         chainStartBlockNumber = block.number; //Deployment Block
338         totalSupply = totalInitialSupply;
339         collectionAddress = msg.sender; //Initially fees collection wallet to creator
340         airdropWallet = msg.sender; //Initially airdrop wallet to creator
341         balances[msg.sender] = totalInitialSupply;
342 
343         emit Transfer(address(0), msg.sender, totalInitialSupply);
344     }
345 
346     /**
347      * @dev setCurrentEscrowFee
348      * @dev Allow an admin from level 3 to set the Escrow Service Fee
349      * @param _newFee The new fee rate
350      */
351     function setCurrentEscrowFee(uint _newFee) onlyAdmin(3) public {
352         require(_newFee < 1000, 'Fee is higher than 100%');
353         escrowFeePercent = _newFee;
354         emit NewFeeRate(escrowFeePercent);
355     }
356 
357     /**
358      * @dev setCollectionWallet
359      * @dev Allow an admin from level 3 to set the Escrow Service Fee Wallet
360      * @param _newWallet The new fee wallet
361      */
362     function setCollectionWallet(address _newWallet) onlyAdmin(3) public {
363         require(_newWallet != address(0), 'Address cannot be zero');
364         collectionAddress = _newWallet;
365         emit NewCollectionWallet(collectionAddress);
366     }
367 
368     /**
369      * @dev setAirDropWallet
370      * @dev Allow an admin from level 3 to set the Airdrop Service Wallet
371      * @param _newWallet The new Airdrop wallet
372      */
373     function setAirDropWallet(address _newWallet) onlyAdmin(3) public {
374         require(_newWallet != address(0), 'Address cannot be zero');
375         airdropWallet = _newWallet;
376         emit NewAirdropWallet(airdropWallet);
377     }
378 
379     ///////////////////////////////////////////////////////////////////
380     //ERC20 FUNCTIONS
381     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns(bool) {
382         require(_to != address(0), 'Address cannot be zero');
383 
384         if (msg.sender == _to) return claimStake();
385 
386         balances[msg.sender] = balances[msg.sender].sub(_value);
387         balances[_to] = balances[_to].add(_value);
388         emit Transfer(msg.sender, _to, _value);
389 
390         //STAKING RELATED//////////////////////////////////////////////
391         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
392         uint64 _now = uint64(now);
393         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));
394         transferIns[_to].push(transferInStruct(uint128(_value), _now));
395         ///////////////////////////////////////////////////////////////
396 
397         return true;
398     }
399 
400     function balanceOf(address _owner) public view returns(uint256 balance) {
401         return balances[_owner];
402     }
403 
404     function transferFrom(address _from, address _to, uint256 _value) notFrozen(_from) public returns(bool) {
405         require(_to != address(0), 'Address cannot be zero');
406 
407         uint256 _allowance = allowed[_from][msg.sender];
408         balances[_from] = balances[_from].sub(_value);
409         balances[_to] = balances[_to].add(_value);
410         allowed[_from][msg.sender] = _allowance.sub(_value);
411         emit Transfer(_from, _to, _value);
412 
413         //STAKING RELATED//////////////////////////////////////////////
414         if (transferIns[_from].length > 0) delete transferIns[_from];
415         uint64 _now = uint64(now);
416         transferIns[_from].push(transferInStruct(uint128(balances[_from]), _now));
417         transferIns[_to].push(transferInStruct(uint128(_value), _now));
418         ///////////////////////////////////////////////////////////////
419 
420         return true;
421     }
422 
423     function approve(address _spender, uint256 _value) public returns(bool) {
424         allowed[msg.sender][_spender] = _value;
425         emit Approval(msg.sender, _spender, _value);
426 
427         return true;
428     }
429 
430     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
431         return allowed[_owner][_spender];
432     }
433     //ERC20 SECTION END
434     ///////////////////////////////////////////////////////////////////
435 
436     ///////////////////////////////////////////////////////////////////
437     //STAKING FUNCTIONS
438     /**
439      * @dev claimStake
440      * @dev Allow any user to claim stake earned
441      */
442     function claimStake() canPoSclaimStake public returns(bool) {
443         if (balances[msg.sender] <= 0) return false;
444         if (transferIns[msg.sender].length <= 0) return false;
445 
446         uint reward = getProofOfStakeReward(msg.sender);
447         if (reward <= 0) return false;
448         totalSupply = totalSupply.add(reward);
449         balances[msg.sender] = balances[msg.sender].add(reward);
450 
451         //STAKING RELATED//////////////////////////////////////////////
452         delete transferIns[msg.sender];
453         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), uint64(now)));
454         ///////////////////////////////////////////////////////////////
455 
456         emit Transfer(address(0), msg.sender, reward);
457         emit ClaimStake(msg.sender, reward);
458         return true;
459     }
460 
461     /**
462      * @dev getBlockNumber
463      * @dev Returns the block number since deployment
464      */
465     function getBlockNumber() public view returns(uint blockNumber) {
466         blockNumber = block.number.sub(chainStartBlockNumber);
467     }
468 
469     /**
470      * @dev coinAge
471      * @dev Returns the coinage for the callers account
472      */
473     function coinAge() public view returns(uint myCoinAge) {
474         myCoinAge = getCoinAge(msg.sender, now);
475     }
476 
477     /**
478      * @dev annualInterest
479      * @dev Returns the current interest rate
480      */
481     function annualInterest() public view returns(uint interest) {
482         uint _now = now;
483         // If all periods are finished but not max supply is reached,
484         // a default small interest rate is left until max supply
485         // get reached
486         interest = (1 * 1e15); //fallback interest
487         if ((_now.sub(stakeStartTime)).div(365 days) == 0) {
488             interest = (106 * 1e15);
489         } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {
490             interest = (49 * 1e15);
491         } else if ((_now.sub(stakeStartTime)).div(365 days) == 2) {
492             interest = (24 * 1e15);
493         } else if ((_now.sub(stakeStartTime)).div(365 days) == 3) {
494             interest = (13 * 1e15);
495         } else if ((_now.sub(stakeStartTime)).div(365 days) == 4) {
496             interest = (11 * 1e15);
497         }
498     }
499 
500     /**
501      * @dev getProofOfStakeReward
502      * @dev Returns the current stake of a wallet
503      * @param _address is the user wallet
504      */
505     function getProofOfStakeReward(address _address) public view returns(uint) {
506         require((now >= stakeStartTime) && (stakeStartTime > 0), 'Staking is not yet enabled');
507 
508         uint _now = now;
509         uint _coinAge = getCoinAge(_address, _now);
510         if (_coinAge <= 0) return 0;
511 
512         // If all periods are finished but not max supply is reached,
513         // a default small interest rate is left until max supply
514         // get reached
515         uint interest = (1 * 1e15); //fallback interest
516 
517         if ((_now.sub(stakeStartTime)).div(365 days) == 0) {
518             interest = (106 * 1e15);
519         } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {
520             interest = (49 * 1e15);
521         } else if ((_now.sub(stakeStartTime)).div(365 days) == 2) {
522             interest = (24 * 1e15);
523         } else if ((_now.sub(stakeStartTime)).div(365 days) == 3) {
524             interest = (13 * 1e15);
525         } else if ((_now.sub(stakeStartTime)).div(365 days) == 4) {
526             interest = (11 * 1e1);
527         }
528 
529         return (_coinAge * interest).div(365 * (10 ** uint256(decimals)));
530     }
531 
532     function getCoinAge(address _address, uint _now) internal view returns(uint _coinAge) {
533         if (transferIns[_address].length <= 0) return 0;
534 
535         for (uint i = 0; i < transferIns[_address].length; i++) {
536             if (_now < uint(transferIns[_address][i].time).add(stakeMinAge)) continue;
537 
538             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
539             if (nCoinSeconds > stakeMaxAge) nCoinSeconds = stakeMaxAge;
540 
541             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
542         }
543     }
544 
545 
546     /**
547      * @dev setStakeStartTime
548      * @dev Used by the owner to define the staking period start
549      * @param timestamp time in UNIX format
550      */
551     function setStakeStartTime(uint timestamp) onlyAdmin(3) public {
552         require((stakeStartTime <= 0) && (timestamp >= chainStartTime), 'Wrong time set');
553         stakeStartTime = timestamp;
554     }
555     //STACKING SECTION END
556     ///////////////////////////////////////////////////////////////////
557 
558     ///////////////////////////////////////////////////////////////////
559     //UTILITY FUNCTIONS
560     /**
561      * @dev batchTransfer
562      * @dev Used by the owner to deliver several transfers at the same time (Airdrop)
563      * @param _recipients Array of addresses
564      * @param _values Array of values
565      */
566     function batchTransfer(
567         address[] calldata _recipients,
568         uint[] calldata _values
569     ) onlyAdmin(1)
570     external returns(bool) {
571         //Check data sizes
572         require(_recipients.length > 0 && _recipients.length == _values.length, 'Addresses and Values have wrong sizes');
573         //Total value calc
574         uint total = 0;
575         for (uint i = 0; i < _values.length; i++) {
576             total = total.add(_values[i]);
577         }
578         //Sender must hold funds
579         require(total <= balances[msg.sender], 'Not enough funds for the transaction');
580         //Make transfers
581         uint64 _now = uint64(now);
582         for (uint j = 0; j < _recipients.length; j++) {
583             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
584             //STAKING RELATED//////////////////////////////////////////////
585             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]), _now));
586             ///////////////////////////////////////////////////////////////
587             emit Transfer(msg.sender, _recipients[j], _values[j]);
588         }
589         //Reduce all balance on a single transaction from sender
590         balances[msg.sender] = balances[msg.sender].sub(total);
591         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
592         if (balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));
593 
594         return true;
595     }
596 
597     /**
598      * @dev dropSet
599      * @dev Used by the owner to set several self-claiming drops at the same time (Airdrop)
600      * @param _recipients Array of addresses
601      * @param _values Array of values1
602      */
603     function dropSet(
604         address[] calldata _recipients,
605         uint[] calldata _values
606     ) onlyAdmin(1)
607     external returns(bool) {
608         //Check data sizes 
609         require(_recipients.length > 0 && _recipients.length == _values.length, 'Addresses and Values have wrong sizes');
610 
611         for (uint j = 0; j < _recipients.length; j++) {
612             //Store user drop info
613             airdrops[_recipients[j]].value = _values[j];
614             airdrops[_recipients[j]].claimed = false;
615         }
616 
617         return true;
618     }
619 
620     /**
621      * @dev claimAirdrop
622      * @dev Allow any user with a drop set to claim it
623      */
624     function claimAirdrop() external returns(bool) {
625         //Check if not claimed
626         require(airdrops[msg.sender].claimed == false, 'Airdrop already claimed');
627         require(airdrops[msg.sender].value != 0, 'No airdrop value to claim');
628 
629         //Original value
630         uint _value = airdrops[msg.sender].value;
631 
632         //Set as Claimed
633         airdrops[msg.sender].claimed = true;
634         //Clear value
635         airdrops[msg.sender].value = 0;
636 
637         //Tokens are on airdropWallet
638         address _from = airdropWallet;
639         //Tokens goes to costumer
640         address _to = msg.sender;
641         balances[_from] = balances[_from].sub(_value);
642         balances[_to] = balances[_to].add(_value);
643 
644         emit Transfer(_from, _to, _value);
645         emit ClaimDrop(_to, _value);
646 
647         //STAKING RELATED//////////////////////////////////////////////
648         if (transferIns[_from].length > 0) delete transferIns[_from];
649         uint64 _now = uint64(now);
650         transferIns[_from].push(transferInStruct(uint128(balances[_from]), _now));
651         transferIns[_to].push(transferInStruct(uint128(_value), _now));
652         ///////////////////////////////////////////////////////////////
653 
654         return true;
655 
656     }
657 
658     /**
659      * @dev userFreezeBalance
660      * @dev Allow a user to safe Lock/Unlock it's balance
661      * @param _lock Lock Status to set
662      */
663     function userFreezeBalance(bool _lock) public returns(bool) {
664         userFreeze[msg.sender] = _lock;
665     }
666 
667     /**
668      * @dev ownerFreeze
669      * @dev Allow the owner to globally freeze tokens for a migration/snapshot
670      * @param _lock Lock Status to set
671      */
672     function ownerFreeze(bool _lock) onlyAdmin(3) public returns(bool) {
673         globalBalancesFreeze = _lock;
674         emit GlobalFreeze(globalBalancesFreeze);
675     }
676 
677     //UTILITY SECTION ENDS
678     ///////////////////////////////////////////////////////////////////
679 
680     ///////////////////////////////////////////////////////////////////
681     //ESCROW FUNCTIONS
682     /**
683      * @dev createPaymentRequest
684      * @dev Allow an user to request start a Escrow process
685      * @param _customer Counterpart that will receive payment on success
686      * @param _value Amount to be escrowed
687      * @param _description Description
688      */
689     function createPaymentRequest(
690         address _customer,
691         uint _value,
692         string calldata _description
693     )
694     escrowIsEnabled()
695     notFrozen(msg.sender)
696     external returns(uint) {
697 
698         require(_customer != address(0), 'Address cannot be zero');
699         require(_value > 0, 'Value cannot be zero');
700 
701         payments[escrowCounter] = Payment(msg.sender, _customer, _value, _description, PaymentStatus.Requested, false);
702         emit PaymentCreation(escrowCounter, msg.sender, _customer, _value, _description);
703 
704         escrowCounter = escrowCounter.add(1);
705         return escrowCounter - 1;
706 
707     }
708 
709     /**
710      * @dev answerPaymentRequest
711      * @dev Allow a user to answer to a Escrow process
712      * @param _orderId the request ticket number
713      * @param _answer request answer
714      */
715     function answerPaymentRequest(uint _orderId, bool _answer) external returns(bool) {
716         //Get Payment Handler
717         Payment storage payment = payments[_orderId];
718 
719         require(payment.status == PaymentStatus.Requested, 'Ticket wrong status, expected "Requested"');
720         require(payment.customer == msg.sender, 'You are not allowed to manage this ticket');
721 
722         if (_answer == true) {
723 
724             address _to = address(this);
725 
726             balances[payment.provider] = balances[payment.provider].sub(payment.value);
727             balances[_to] = balances[_to].add(payment.value);
728             emit Transfer(payment.provider, _to, payment.value);
729 
730             //STAKING RELATED//////////////////////////////////////////////
731             if (transferIns[payment.provider].length > 0) delete transferIns[payment.provider];
732             uint64 _now = uint64(now);
733             transferIns[payment.provider].push(transferInStruct(uint128(balances[payment.provider]), _now));
734             ///////////////////////////////////////////////////////////////
735 
736             payments[_orderId].status = PaymentStatus.Pending;
737 
738             emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, PaymentStatus.Pending);
739 
740         } else {
741 
742             payments[_orderId].status = PaymentStatus.Rejected;
743 
744             emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, PaymentStatus.Rejected);
745 
746         }
747 
748         return true;
749     }
750 
751 
752     /**
753      * @dev release
754      * @dev Allow a provider or admin user to release a payment
755      * @param _orderId Ticket number of the escrow service
756      */
757     function release(uint _orderId) external returns(bool) {
758         //Get Payment Handler
759         Payment storage payment = payments[_orderId];
760         //Only if pending
761         require(payment.status == PaymentStatus.Pending, 'Ticket wrong status, expected "Pending"');
762         //Only owner or token provider
763         require(level[msg.sender] >= 2 || msg.sender == payment.provider, 'You are not allowed to manage this ticket');
764         //Tokens are on contract
765         address _from = address(this);
766         //Tokens goes to costumer
767         address _to = payment.customer;
768         //Original value
769         uint _value = payment.value;
770         //Fee calculation
771         uint _fee = _value.mul(escrowFeePercent).div(1000);
772         //Value less fees
773         _value = _value.sub(_fee);
774         //Costumer transfer
775         balances[_from] = balances[_from].sub(_value);
776         balances[_to] = balances[_to].add(_value);
777         emit Transfer(_from, _to, _value);
778         //collectionAddress fee recolection
779         balances[_from] = balances[_from].sub(_fee);
780         balances[collectionAddress] = balances[collectionAddress].add(_fee);
781         emit Transfer(_from, collectionAddress, _fee);
782         //Delete any staking from contract address itself
783         if (transferIns[_from].length > 0) delete transferIns[_from];
784         //Store staking information for receivers
785         uint64 _now = uint64(now);
786         //Costumer
787         transferIns[_to].push(transferInStruct(uint128(_value), _now));
788         //collectionAddress
789         transferIns[collectionAddress].push(transferInStruct(uint128(_fee), _now));
790         //Payment Escrow Completed
791         payment.status = PaymentStatus.Completed;
792         //Emit Event
793         emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, payment.status);
794 
795         return true;
796     }
797 
798     /**
799      * @dev refund
800      * @dev Allow a user to refund a payment
801      * @param _orderId Ticket number of the escrow service
802      */
803     function refund(uint _orderId) external returns(bool) {
804         //Get Payment Handler
805         Payment storage payment = payments[_orderId];
806         //Only if pending
807         require(payment.status == PaymentStatus.Pending, 'Ticket wrong status, expected "Pending"');
808         //Only if refund was approved
809         require(payment.refundApproved, 'Refund has not been approved yet');
810         //Tokens are on contract
811         address _from = address(this);
812         //Tokens go back to provider
813         address _to = payment.provider;
814         //Original value
815         uint _value = payment.value;
816         //Provider transfer
817         balances[_from] = balances[_from].sub(_value);
818         balances[_to] = balances[_to].add(_value);
819         emit Transfer(_from, _to, _value);
820         //Delete any staking from contract address itself
821         if (transferIns[_from].length > 0) delete transferIns[_from];
822         //Store staking information for receivers
823         uint64 _now = uint64(now);
824         transferIns[_to].push(transferInStruct(uint128(_value), _now));
825         //Payment Escrow Refunded
826         payment.status = PaymentStatus.Refunded;
827         //Emit Event
828         emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, payment.status);
829 
830         return true;
831     }
832 
833     /**
834      * @dev approveRefund
835      * @dev Allow a user to approve a refund
836      * @param _orderId Ticket number of the escrow service
837      */
838     function approveRefund(uint _orderId) external returns(bool) {
839         //Get Payment Handler
840         Payment storage payment = payments[_orderId];
841         //Only if pending
842         require(payment.status == PaymentStatus.Pending, 'Ticket wrong status, expected "Pending"');
843         //Only owner or costumer
844         require(level[msg.sender] >= 2 || msg.sender == payment.customer, 'You are not allowed to manage this ticket');
845         //Approve Refund
846         payment.refundApproved = true;
847 
848         emit PaymentRefundApprove(_orderId, payment.provider, payment.customer, payment.refundApproved);
849 
850         return true;
851     }
852 
853     /**
854      * @dev escrowLockSet
855      * @dev Allow the owner to lock the escrow feature
856      * @param _lock lock indicator
857      */
858     function escrowLockSet(bool _lock) external onlyAdmin(3) returns(bool) {        
859         escrowEnabled = _lock;
860         emit EscrowLock(escrowEnabled);
861         return true;
862     }
863 
864     //ESCROW SECTION END
865     ///////////////////////////////////////////////////////////////////
866 }