1 pragma solidity 0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Controlled {
34     /// @notice The address of the controller is the only address that can call
35     ///  a function with this modifier
36     modifier onlyController { require(msg.sender == controller); _; }
37 
38     address public controller;
39 
40     function Controlled() public { controller = msg.sender;}
41 
42     /// @notice Changes the controller of the contract
43     /// @param _newController The new controller of the contract
44     function changeController(address _newController) public onlyController {
45         controller = _newController;
46     }
47 }
48 
49 /*
50     Copyright 2016, Jordi Baylina
51 
52     This program is free software: you can redistribute it and/or modify
53     it under the terms of the GNU General Public License as published by
54     the Free Software Foundation, either version 3 of the License, or
55     (at your option) any later version.
56 
57     This program is distributed in the hope that it will be useful,
58     but WITHOUT ANY WARRANTY; without even the implied warranty of
59     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
60     GNU General Public License for more details.
61 
62     You should have received a copy of the GNU General Public License
63     along with this program.  If not, see <http://www.gnu.org/licenses/>.
64  */
65 
66 /// @title MiniMeToken Contract
67 /// @author Jordi Baylina
68 /// @dev This token contract's goal is to make it easy for anyone to clone this
69 ///  token using the token distribution at a given block, this will allow DAO's
70 ///  and DApps to upgrade their features in a decentralized manner without
71 ///  affecting the original token
72 /// @dev It is ERC20 compliant, but still needs to under go further testing.
73 
74 contract ApproveAndCallFallBack {
75     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
76 }
77 
78 /// @dev The actual token contract, the default controller is the msg.sender
79 ///  that deploys the contract, so usually this token will be deployed by a
80 ///  token controller contract, which Giveth will call a "Campaign"
81 contract MiniMeToken is Controlled {
82 
83     string public name;                //The Token's name: e.g. DigixDAO Tokens
84     uint8 public decimals;             //Number of decimals of the smallest unit
85     string public symbol;              //An identifier: e.g. REP
86     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
87 
88 
89     /// @dev `Checkpoint` is the structure that attaches a block number to a
90     ///  given value, the block number attached is the one that last changed the
91     ///  value
92     struct  Checkpoint {
93 
94         // `fromBlock` is the block number that the value was generated from
95         uint128 fromBlock;
96 
97         // `value` is the amount of tokens at a specific block number
98         uint128 value;
99     }
100 
101     // `parentToken` is the Token address that was cloned to produce this token;
102     //  it will be 0x0 for a token that was not cloned
103     MiniMeToken public parentToken;
104 
105     // `parentSnapShotBlock` is the block number from the Parent Token that was
106     //  used to determine the initial distribution of the Clone Token
107     uint public parentSnapShotBlock;
108 
109     // `creationBlock` is the block number that the Clone Token was created
110     uint public creationBlock;
111 
112     // `balances` is the map that tracks the balance of each address, in this
113     //  contract when the balance changes the block number that the change
114     //  occurred is also included in the map
115     mapping (address => Checkpoint[]) balances;
116 
117     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
118     mapping (address => mapping (address => uint256)) allowed;
119 
120     // Tracks the history of the `totalSupply` of the token
121     Checkpoint[] totalSupplyHistory;
122 
123     // Flag that determines if the token is transferable or not.
124     bool public transfersEnabled;
125 
126     // The factory used to create new clone tokens
127     MiniMeTokenFactory public tokenFactory;
128 
129 ////////////////
130 // Constructor
131 ////////////////
132 
133     /// @notice Constructor to create a MiniMeToken
134     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
135     ///  will create the Clone token contracts, the token factory needs to be
136     ///  deployed first
137     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
138     ///  new token
139     /// @param _parentSnapShotBlock Block of the parent token that will
140     ///  determine the initial distribution of the clone token, set to 0 if it
141     ///  is a new token
142     /// @param _tokenName Name of the new token
143     /// @param _decimalUnits Number of decimals of the new token
144     /// @param _tokenSymbol Token Symbol for the new token
145     /// @param _transfersEnabled If true, tokens will be able to be transferred
146     function MiniMeToken(
147         address _tokenFactory,
148         address _parentToken,
149         uint _parentSnapShotBlock,
150         string _tokenName,
151         uint8 _decimalUnits,
152         string _tokenSymbol,
153         bool _transfersEnabled
154     ) public {
155         tokenFactory = MiniMeTokenFactory(_tokenFactory);
156         name = _tokenName;                                 // Set the name
157         decimals = _decimalUnits;                          // Set the decimals
158         symbol = _tokenSymbol;                             // Set the symbol
159         parentToken = MiniMeToken(_parentToken);
160         parentSnapShotBlock = _parentSnapShotBlock;
161         transfersEnabled = _transfersEnabled;
162         creationBlock = block.number;
163     }
164 
165 
166 ///////////////////
167 // ERC20 Methods
168 ///////////////////
169 
170     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
171     /// @param _to The address of the recipient
172     /// @param _amount The amount of tokens to be transferred
173     /// @return Whether the transfer was successful or not
174     function transfer(address _to, uint256 _amount) public returns (bool success) {
175         require(transfersEnabled);
176         return doTransfer(msg.sender, _to, _amount);
177     }
178 
179     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
180     ///  is approved by `_from`
181     /// @param _from The address holding the tokens being transferred
182     /// @param _to The address of the recipient
183     /// @param _amount The amount of tokens to be transferred
184     /// @return True if the transfer was successful
185     function transferFrom(address _from, address _to, uint256 _amount
186     ) public returns (bool success) {
187 
188         // The controller of this contract can move tokens around at will,
189         //  this is important to recognize! Confirm that you trust the
190         //  controller of this contract, which in most situations should be
191         //  another open source smart contract or 0x0
192         if (msg.sender != controller) {
193             require(transfersEnabled);
194 
195             // The standard ERC 20 transferFrom functionality
196             if (allowed[_from][msg.sender] < _amount) return false;
197             allowed[_from][msg.sender] -= _amount;
198         }
199         return doTransfer(_from, _to, _amount);
200     }
201 
202     /// @dev This is the actual transfer function in the token contract, it can
203     ///  only be called by other functions in this contract.
204     /// @param _from The address holding the tokens being transferred
205     /// @param _to The address of the recipient
206     /// @param _amount The amount of tokens to be transferred
207     /// @return True if the transfer was successful
208     function doTransfer(address _from, address _to, uint _amount
209     ) internal returns(bool) {
210 
211            if (_amount == 0) {
212                return true;
213            }
214 
215            require(parentSnapShotBlock < block.number);
216 
217            // Do not allow transfer to 0x0 or the token contract itself
218            require((_to != 0) && (_to != address(this)));
219 
220            // If the amount being transfered is more than the balance of the
221            //  account the transfer returns false
222            var previousBalanceFrom = balanceOfAt(_from, block.number);
223            if (previousBalanceFrom < _amount) {
224                return false;
225            }
226 
227            // First update the balance array with the new value for the address
228            //  sending the tokens
229            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
230 
231            // Then update the balance array with the new value for the address
232            //  receiving the tokens
233            var previousBalanceTo = balanceOfAt(_to, block.number);
234            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
235            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
236 
237            // An event to make the transfer easy to find on the blockchain
238            Transfer(_from, _to, _amount);
239 
240            return true;
241     }
242 
243     /// @param _owner The address that's balance is being requested
244     /// @return The balance of `_owner` at the current block
245     function balanceOf(address _owner) public constant returns (uint256 balance) {
246         return balanceOfAt(_owner, block.number);
247     }
248 
249     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
250     ///  its behalf. This is a modified version of the ERC20 approve function
251     ///  to be a little bit safer
252     /// @param _spender The address of the account able to transfer the tokens
253     /// @param _amount The amount of tokens to be approved for transfer
254     /// @return True if the approval was successful
255     function approve(address _spender, uint256 _amount) public returns (bool success) {
256         require(transfersEnabled);
257 
258         // To change the approve amount you first have to reduce the addresses`
259         //  allowance to zero by calling `approve(_spender,0)` if it is not
260         //  already 0 to mitigate the race condition described here:
261         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
263 
264         allowed[msg.sender][_spender] = _amount;
265         Approval(msg.sender, _spender, _amount);
266         return true;
267     }
268 
269     /// @dev This function makes it easy to read the `allowed[]` map
270     /// @param _owner The address of the account that owns the token
271     /// @param _spender The address of the account able to transfer the tokens
272     /// @return Amount of remaining tokens of _owner that _spender is allowed
273     ///  to spend
274     function allowance(address _owner, address _spender
275     ) public constant returns (uint256 remaining) {
276         return allowed[_owner][_spender];
277     }
278 
279     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
280     ///  its behalf, and then a function is triggered in the contract that is
281     ///  being approved, `_spender`. This allows users to use their tokens to
282     ///  interact with contracts in one function call instead of two
283     /// @param _spender The address of the contract able to transfer the tokens
284     /// @param _amount The amount of tokens to be approved for transfer
285     /// @return True if the function call was successful
286     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
287     ) public returns (bool success) {
288         require(approve(_spender, _amount));
289 
290         ApproveAndCallFallBack(_spender).receiveApproval(
291             msg.sender,
292             _amount,
293             this,
294             _extraData
295         );
296 
297         return true;
298     }
299 
300     /// @dev This function makes it easy to get the total number of tokens
301     /// @return The total number of tokens
302     function totalSupply() public constant returns (uint) {
303         return totalSupplyAt(block.number);
304     }
305 
306 
307 ////////////////
308 // Query balance and totalSupply in History
309 ////////////////
310 
311     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
312     /// @param _owner The address from which the balance will be retrieved
313     /// @param _blockNumber The block number when the balance is queried
314     /// @return The balance at `_blockNumber`
315     function balanceOfAt(address _owner, uint _blockNumber) public constant
316         returns (uint) {
317 
318         // These next few lines are used when the balance of the token is
319         //  requested before a check point was ever created for this token, it
320         //  requires that the `parentToken.balanceOfAt` be queried at the
321         //  genesis block for that token as this contains initial balance of
322         //  this token
323         if ((balances[_owner].length == 0)
324             || (balances[_owner][0].fromBlock > _blockNumber)) {
325             if (address(parentToken) != 0) {
326                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
327             } else {
328                 // Has no parent
329                 return 0;
330             }
331 
332         // This will return the expected balance during normal situations
333         } else {
334             return getValueAt(balances[_owner], _blockNumber);
335         }
336     }
337 
338     /// @notice Total amount of tokens at a specific `_blockNumber`.
339     /// @param _blockNumber The block number when the totalSupply is queried
340     /// @return The total amount of tokens at `_blockNumber`
341     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
342 
343         // These next few lines are used when the totalSupply of the token is
344         //  requested before a check point was ever created for this token, it
345         //  requires that the `parentToken.totalSupplyAt` be queried at the
346         //  genesis block for this token as that contains totalSupply of this
347         //  token at this block number.
348         if ((totalSupplyHistory.length == 0)
349             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
350             if (address(parentToken) != 0) {
351                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
352             } else {
353                 return 0;
354             }
355 
356         // This will return the expected totalSupply during normal situations
357         } else {
358             return getValueAt(totalSupplyHistory, _blockNumber);
359         }
360     }
361 
362 ////////////////
363 // Clone Token Method
364 ////////////////
365 
366     /// @notice Creates a new clone token with the initial distribution being
367     ///  this token at `_snapshotBlock`
368     /// @param _cloneTokenName Name of the clone token
369     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
370     /// @param _cloneTokenSymbol Symbol of the clone token
371     /// @param _snapshotBlock Block when the distribution of the parent token is
372     ///  copied to set the initial distribution of the new clone token;
373     ///  if the block is zero than the actual block, the current block is used
374     /// @param _transfersEnabled True if transfers are allowed in the clone
375     /// @return The address of the new MiniMeToken Contract
376     function createCloneToken(
377         string _cloneTokenName,
378         uint8 _cloneDecimalUnits,
379         string _cloneTokenSymbol,
380         uint _snapshotBlock,
381         bool _transfersEnabled
382         ) public returns(address) {
383         if (_snapshotBlock == 0) _snapshotBlock = block.number;
384         MiniMeToken cloneToken = tokenFactory.createCloneToken(
385             this,
386             _snapshotBlock,
387             _cloneTokenName,
388             _cloneDecimalUnits,
389             _cloneTokenSymbol,
390             _transfersEnabled
391             );
392 
393         cloneToken.changeController(msg.sender);
394 
395         // An event to make the token easy to find on the blockchain
396         NewCloneToken(address(cloneToken), _snapshotBlock);
397         return address(cloneToken);
398     }
399 
400 ////////////////
401 // Generate and destroy tokens
402 ////////////////
403 
404     /// @notice Generates `_amount` tokens that are assigned to `_owner`
405     /// @param _owner The address that will be assigned the new tokens
406     /// @param _amount The quantity of tokens generated
407     /// @return True if the tokens are generated correctly
408     function generateTokens(address _owner, uint _amount
409     ) public onlyController returns (bool) {
410         uint curTotalSupply = totalSupply();
411         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
412         uint previousBalanceTo = balanceOf(_owner);
413         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
414         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
415         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
416         Transfer(0, _owner, _amount);
417         return true;
418     }
419 
420 
421     /// @notice Burns `_amount` tokens from `_owner`
422     /// @param _owner The address that will lose the tokens
423     /// @param _amount The quantity of tokens to burn
424     /// @return True if the tokens are burned correctly
425     function destroyTokens(address _owner, uint _amount
426     ) onlyController public returns (bool) {
427         uint curTotalSupply = totalSupply();
428         require(curTotalSupply >= _amount);
429         uint previousBalanceFrom = balanceOf(_owner);
430         require(previousBalanceFrom >= _amount);
431         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
432         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
433         Transfer(_owner, 0, _amount);
434         return true;
435     }
436 
437 ////////////////
438 // Enable tokens transfers
439 ////////////////
440 
441 
442     /// @notice Enables token holders to transfer their tokens freely if true
443     /// @param _transfersEnabled True if transfers are allowed in the clone
444     function enableTransfers(bool _transfersEnabled) public onlyController {
445         transfersEnabled = _transfersEnabled;
446     }
447 
448 ////////////////
449 // Internal helper functions to query and set a value in a snapshot array
450 ////////////////
451 
452     /// @dev `getValueAt` retrieves the number of tokens at a given block number
453     /// @param checkpoints The history of values being queried
454     /// @param _block The block number to retrieve the value at
455     /// @return The number of tokens being queried
456     function getValueAt(Checkpoint[] storage checkpoints, uint _block
457     ) constant internal returns (uint) {
458         if (checkpoints.length == 0) return 0;
459 
460         // Shortcut for the actual value
461         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
462             return checkpoints[checkpoints.length-1].value;
463         if (_block < checkpoints[0].fromBlock) return 0;
464 
465         // Binary search of the value in the array
466         uint min = 0;
467         uint max = checkpoints.length-1;
468         while (max > min) {
469             uint mid = (max + min + 1)/ 2;
470             if (checkpoints[mid].fromBlock<=_block) {
471                 min = mid;
472             } else {
473                 max = mid-1;
474             }
475         }
476         return checkpoints[min].value;
477     }
478 
479     /// @dev `updateValueAtNow` used to update the `balances` map and the
480     ///  `totalSupplyHistory`
481     /// @param checkpoints The history of data being updated
482     /// @param _value The new number of tokens
483     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
484     ) internal  {
485         if ((checkpoints.length == 0)
486         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
487                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
488                newCheckPoint.fromBlock =  uint128(block.number);
489                newCheckPoint.value = uint128(_value);
490            } else {
491                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
492                oldCheckPoint.value = uint128(_value);
493            }
494     }
495 
496     /// @dev Internal function to determine if an address is a contract
497     /// @param _addr The address being queried
498     /// @return True if `_addr` is a contract
499     function isContract(address _addr) constant internal returns(bool) {
500         uint size;
501         if (_addr == 0) return false;
502         assembly {
503             size := extcodesize(_addr)
504         }
505         return size>0;
506     }
507 
508     /// @dev Helper function to return a min betwen the two uints
509     /// PURE function
510     function min(uint a, uint b) internal constant returns (uint) {
511         return a < b ? a : b;
512     }
513 
514     /// @notice The fallback function: If the contract's controller has not been
515     ///  set to 0, then the `proxyPayment` method is called which relays the
516     ///  ether and creates tokens as described in the token controller contract
517     function () public payable {
518     }
519 
520 //////////
521 // Safety Methods
522 //////////
523 
524     /// @notice This method can be used by the controller to extract mistakenly
525     ///  sent tokens to this contract.
526     /// @param _token The address of the token contract that you want to recover
527     ///  set to 0 in case you want to extract ether.
528     function claimTokens(address _token) public onlyController {
529         if (_token == 0x0) {
530             controller.transfer(this.balance);
531             return;
532         }
533 
534         MiniMeToken token = MiniMeToken(_token);
535         uint balance = token.balanceOf(this);
536         token.transfer(controller, balance);
537         ClaimedTokens(_token, controller, balance);
538     }
539 
540 ////////////////
541 // Events
542 ////////////////
543     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
544     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
545     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
546     event Approval(
547         address indexed _owner,
548         address indexed _spender,
549         uint256 _amount
550         );
551 
552 }
553 
554 
555 ////////////////
556 // MiniMeTokenFactory
557 ////////////////
558 
559 /// @dev This contract is used to generate clone contracts from a contract.
560 ///  In solidity this is the way to create a contract from a contract of the
561 ///  same class
562 contract MiniMeTokenFactory {
563 
564     /// @notice Update the DApp by creating a new token with new functionalities
565     ///  the msg.sender becomes the controller of this clone token
566     /// @param _parentToken Address of the token being cloned
567     /// @param _snapshotBlock Block of the parent token that will
568     ///  determine the initial distribution of the clone token
569     /// @param _tokenName Name of the new token
570     /// @param _decimalUnits Number of decimals of the new token
571     /// @param _tokenSymbol Token Symbol for the new token
572     /// @param _transfersEnabled If true, tokens will be able to be transferred
573     /// @return The address of the new token contract
574     function createCloneToken(
575         address _parentToken,
576         uint _snapshotBlock,
577         string _tokenName,
578         uint8 _decimalUnits,
579         string _tokenSymbol,
580         bool _transfersEnabled
581     ) public returns (MiniMeToken) {
582         MiniMeToken newToken = new MiniMeToken(
583             this,
584             _parentToken,
585             _snapshotBlock,
586             _tokenName,
587             _decimalUnits,
588             _tokenSymbol,
589             _transfersEnabled
590             );
591 
592         newToken.changeController(msg.sender);
593         return newToken;
594     }
595 }
596 
597 contract StakeTreeWithTokenization {
598   using SafeMath for uint256;
599 
600   uint public version = 2;
601 
602   struct Funder {
603     bool exists;
604     uint balance;
605     uint withdrawalEntry;
606     uint contribution;
607     uint contributionClaimed;
608   }
609 
610   mapping(address => Funder) public funders;
611 
612   bool public live = true; // For sunsetting contract
613   uint public totalCurrentFunders = 0; // Keeps track of total funders
614   uint public withdrawalCounter = 0; // Keeps track of how many withdrawals have taken place
615   uint public sunsetWithdrawDate;
616   
617   MiniMeToken public tokenContract;
618   MiniMeTokenFactory public tokenFactory;
619   bool public tokenized = false;
620   bool public canClaimTokens = false;
621 
622   address public beneficiary; // Address for beneficiary
623   uint public sunsetWithdrawalPeriod; // How long it takes for beneficiary to swipe contract when put into sunset mode
624   uint public withdrawalPeriod; // How long the beneficiary has to wait withdraw
625   uint public minimumFundingAmount; // Setting used for setting minimum amounts to fund contract with
626   uint public lastWithdrawal; // Last withdrawal time
627   uint public nextWithdrawal; // Next withdrawal time
628 
629   uint public contractStartTime; // For accounting purposes
630 
631   event Payment(address indexed funder, uint amount);
632   event Refund(address indexed funder, uint amount);
633   event Withdrawal(uint amount);
634   event TokensClaimed(address indexed funder, uint amount);
635   event Sunset(bool hasSunset);
636 
637   function StakeTreeWithTokenization(
638     address beneficiaryAddress, 
639     uint withdrawalPeriodInit, 
640     uint withdrawalStart, 
641     uint sunsetWithdrawPeriodInit,
642     uint minimumFundingAmountInit) {
643 
644     beneficiary = beneficiaryAddress;
645     withdrawalPeriod = withdrawalPeriodInit;
646     sunsetWithdrawalPeriod = sunsetWithdrawPeriodInit;
647 
648     lastWithdrawal = withdrawalStart; 
649     nextWithdrawal = lastWithdrawal + withdrawalPeriod;
650 
651     minimumFundingAmount = minimumFundingAmountInit;
652 
653     contractStartTime = now;
654   }
655 
656   // Modifiers
657   modifier onlyByBeneficiary() {
658     require(msg.sender == beneficiary);
659     _;
660   }
661 
662   modifier onlyWhenTokenized() {
663     require(isTokenized());
664     _;
665   }
666 
667   modifier onlyByFunder() {
668     require(isFunder(msg.sender));
669     _;
670   }
671 
672   modifier onlyAfterNextWithdrawalDate() {
673     require(now >= nextWithdrawal);
674     _;
675   }
676 
677   modifier onlyWhenLive() {
678     require(live);
679     _;
680   }
681 
682   modifier onlyWhenSunset() {
683     require(!live);
684     _;
685   }
686 
687   /*
688   * External accounts can pay directly to contract to fund it.
689   */
690   function () payable {
691     fund();
692   }
693 
694   /*
695   * Additional api for contracts to use as well
696   * Can only happen when live and over a minimum amount set by the beneficiary
697   */
698 
699   function fund() public payable onlyWhenLive {
700     require(msg.value >= minimumFundingAmount);
701 
702     // Only increase total funders when we have a new funder
703     if(!isFunder(msg.sender)) {
704       totalCurrentFunders = totalCurrentFunders.add(1); // Increase total funder count
705 
706       funders[msg.sender] = Funder({
707         exists: true,
708         balance: msg.value,
709         withdrawalEntry: withdrawalCounter, // Set the withdrawal counter. Ie at which withdrawal the funder "entered" the patronage contract
710         contribution: 0,
711         contributionClaimed: 0
712       });
713     }
714     else { 
715       consolidateFunder(msg.sender, msg.value);
716     }
717 
718     Payment(msg.sender, msg.value);
719   }
720 
721   // Pure functions
722 
723   /*
724   * This function calculates how much the beneficiary can withdraw.
725   * Due to no floating points in Solidity, we will lose some fidelity
726   * if there's wei on the last digit. The beneficiary loses a neglibible amount
727   * to withdraw but this benefits the beneficiary again on later withdrawals.
728   * We multiply by 10 (which corresponds to the 10%) 
729   * then divide by 100 to get the actual part.
730   */
731   function calculateWithdrawalAmount(uint startAmount) public returns (uint){
732     return startAmount.mul(10).div(100); // 10%
733   }
734 
735   /*
736   * This function calculates the refund amount for the funder.
737   * Due to no floating points in Solidity, we will lose some fidelity.
738   * The funder loses a neglibible amount to refund. 
739   * The left over wei gets pooled to the fund.
740   */
741   function calculateRefundAmount(uint amount, uint withdrawalTimes) public returns (uint) {    
742     for(uint i=0; i<withdrawalTimes; i++){
743       amount = amount.mul(9).div(10);
744     }
745     return amount;
746   }
747 
748   // Getter functions
749 
750   /*
751   * To calculate the refund amount we look at how many times the beneficiary
752   * has withdrawn since the funder added their funds. 
753   * We use that deduct 10% for each withdrawal.
754   */
755 
756   function getRefundAmountForFunder(address addr) public constant returns (uint) {
757     // Only calculate on-the-fly if funder has not been updated
758     if(shouldUpdateFunder(addr)) {
759       uint amount = funders[addr].balance;
760       uint withdrawalTimes = getHowManyWithdrawalsForFunder(addr);
761       return calculateRefundAmount(amount, withdrawalTimes);
762     }
763     else {
764       return funders[addr].balance;
765     }
766   }
767 
768   function getFunderContribution(address funder) public constant returns (uint) {
769     // Only calculate on-the-fly if funder has not been updated
770     if(shouldUpdateFunder(funder)) {
771       uint oldBalance = funders[funder].balance;
772       uint newBalance = getRefundAmountForFunder(funder);
773       uint contribution = oldBalance.sub(newBalance);
774       return funders[funder].contribution.add(contribution);
775     }
776     else {
777       return funders[funder].contribution;
778     }
779   }
780 
781   function getBeneficiary() public constant returns (address) {
782     return beneficiary;
783   }
784 
785   function getCurrentTotalFunders() public constant returns (uint) {
786     return totalCurrentFunders;
787   }
788 
789   function getWithdrawalCounter() public constant returns (uint) {
790     return withdrawalCounter;
791   }
792 
793   function getWithdrawalEntryForFunder(address addr) public constant returns (uint) {
794     return funders[addr].withdrawalEntry;
795   }
796 
797   function getContractBalance() public constant returns (uint256 balance) {
798     balance = this.balance;
799   }
800 
801   function getFunderBalance(address funder) public constant returns (uint256) {
802     return getRefundAmountForFunder(funder);
803   }
804 
805   function getFunderContributionClaimed(address addr) public constant returns (uint) {
806     return funders[addr].contributionClaimed;
807   }
808 
809   function isFunder(address addr) public constant returns (bool) {
810     return funders[addr].exists;
811   }
812 
813   function isTokenized() public constant returns (bool) {
814     return tokenized;
815   }
816 
817   function shouldUpdateFunder(address funder) public constant returns (bool) {
818     return getWithdrawalEntryForFunder(funder) < withdrawalCounter;
819   }
820 
821   function getHowManyWithdrawalsForFunder(address addr) private constant returns (uint) {
822     return withdrawalCounter.sub(getWithdrawalEntryForFunder(addr));
823   }
824 
825   // State changing functions
826   function setMinimumFundingAmount(uint amount) external onlyByBeneficiary {
827     require(amount > 0);
828     minimumFundingAmount = amount;
829   }
830 
831   function withdraw() external onlyByBeneficiary onlyAfterNextWithdrawalDate onlyWhenLive  {
832     // Check
833     uint amount = calculateWithdrawalAmount(this.balance);
834 
835     // Effects
836     withdrawalCounter = withdrawalCounter.add(1);
837     lastWithdrawal = now; // For tracking purposes
838     nextWithdrawal = nextWithdrawal + withdrawalPeriod; // Fixed period increase
839 
840     // Interaction
841     beneficiary.transfer(amount);
842 
843     Withdrawal(amount);
844   }
845 
846   // Refunding by funder
847   // Only funders can refund their own funding
848   // Can only be sent back to the same address it was funded with
849   // We also remove the funder if they succesfully exit with their funds
850   function refund() external onlyByFunder {
851     // Check
852     uint walletBalance = this.balance;
853     uint amount = getRefundAmountForFunder(msg.sender);
854     require(amount > 0);
855 
856     // Effects
857     removeFunder();
858 
859     // Interaction
860     msg.sender.transfer(amount);
861 
862     Refund(msg.sender, amount);
863 
864     // Make sure this worked as intended
865     assert(this.balance == walletBalance-amount);
866   }
867 
868   // Used when the funder wants to remove themselves as a funder
869   // without refunding. Their eth stays in the pool
870   function removeFunder() public onlyByFunder {
871     delete funders[msg.sender];
872     totalCurrentFunders = totalCurrentFunders.sub(1);
873   }
874 
875   /*
876   * This is a bookkeeping function which updates the state for the funder
877   * when top up their funds.
878   */
879 
880   function consolidateFunder(address funder, uint newPayment) private {
881     // Update contribution
882     funders[funder].contribution = getFunderContribution(funder);
883     // Update balance
884     funders[funder].balance = getRefundAmountForFunder(funder).add(newPayment);
885     // Update withdrawal entry
886     funders[funder].withdrawalEntry = withdrawalCounter;
887   }
888 
889   function addTokenization(string tokenName, string tokenSymbol, uint8 tokenDecimals ) external onlyByBeneficiary {
890     require(!isTokenized());
891 
892     tokenFactory = new MiniMeTokenFactory();
893     tokenContract = tokenFactory.createCloneToken(0x0, 0, tokenName, tokenDecimals, tokenSymbol, true);
894 
895     tokenized = true;
896     canClaimTokens = true;
897   }
898 
899   function claimTokens() external onlyByFunder onlyWhenTokenized {
900     require(canClaimTokens);
901 
902     uint contributionAmount = getFunderContribution(msg.sender);
903     uint contributionClaimedAmount = getFunderContributionClaimed(msg.sender);
904 
905     // Only claim tokens if they have some left to claim
906     uint claimAmount = contributionAmount.sub(contributionClaimedAmount);
907     require(claimAmount > 0);
908 
909     // Claim tokens
910     funders[msg.sender].contributionClaimed = contributionAmount;
911     tokenContract.generateTokens(msg.sender, claimAmount);
912 
913     TokensClaimed(msg.sender, claimAmount);
914   }
915 
916   /*
917   * The beneficiary can stop/enable funders from claiming more tokens.
918   * This opens up opportunities for tokenizing only happening for a set periods.
919   */
920   function enableTokenClaiming(bool _enabled) external onlyWhenTokenized onlyByBeneficiary {
921     canClaimTokens = _enabled;
922   }
923 
924   /* --- Sunsetting --- */
925   /*
926   * The beneficiary can decide to stop using this contract.
927   * They use this sunset function to put it into sunset mode.
928   * The beneficiary can then swipe rest of the funds after a set time
929   * if funders have not withdrawn their funds.
930   */
931 
932   function sunset() external onlyByBeneficiary onlyWhenLive {
933     sunsetWithdrawDate = now.add(sunsetWithdrawalPeriod);
934     live = false;
935 
936     Sunset(true);
937   }
938 
939   function swipe(address recipient) external onlyWhenSunset onlyByBeneficiary {
940     require(now >= sunsetWithdrawDate);
941 
942     recipient.transfer(this.balance);
943   }
944 
945   /* --- Token Contract Forwarding Controller Functions --- */
946   /* 
947   * Allows beneficiary to call two additional functions on the token contract:
948   * claimTokens
949   * enabledTransfers
950   * 
951   */
952   function tokenContractClaimTokens(address _token) onlyByBeneficiary onlyWhenTokenized {
953     tokenContract.claimTokens(_token);
954   }
955   function tokenContractEnableTransfers(bool _transfersEnabled) onlyByBeneficiary onlyWhenTokenized {
956     tokenContract.enableTransfers(_transfersEnabled);
957   }
958 }