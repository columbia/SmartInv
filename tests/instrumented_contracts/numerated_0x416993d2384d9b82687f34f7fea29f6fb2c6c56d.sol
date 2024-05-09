1 pragma solidity ^0.4.18;
2 
3 contract Controlled {
4     /// @notice The address of the controller is the only address that can call
5     ///  a function with this modifier
6     modifier onlyController { require(msg.sender == controller); _; }
7 
8     address public controller;
9 
10     function Controlled() public { controller = msg.sender;}
11 
12     /// @notice Changes the controller of the contract
13     /// @param _newController The new controller of the contract
14     function changeController(address _newController) public onlyController {
15         controller = _newController;
16     }
17 }
18 
19 
20 contract TokenController {
21     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
22     /// @param _owner The address that sent the ether to create tokens
23     /// @return True if the ether is accepted, false if it throws
24     function proxyPayment(address _owner) public payable returns(bool);
25 
26     /// @notice Notifies the controller about a token transfer allowing the
27     ///  controller to react if desired
28     /// @param _from The origin of the transfer
29     /// @param _to The destination of the transfer
30     /// @param _amount The amount of the transfer
31     /// @return False if the controller does not authorize the transfer
32     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
33 
34     /// @notice Notifies the controller about an approval allowing the
35     ///  controller to react if desired
36     /// @param _owner The address that calls `approve()`
37     /// @param _spender The spender in the `approve()` call
38     /// @param _amount The amount in the `approve()` call
39     /// @return False if the controller does not authorize the approval
40     function onApprove(address _owner, address _spender, uint _amount) public
41         returns(bool);
42 }
43 
44 
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
47 }
48 
49 /// @dev The actual token contract, the default controller is the msg.sender
50 ///  that deploys the contract, so usually this token will be deployed by a
51 ///  token controller contract, which Giveth will call a "Campaign"
52 contract MiniMeToken is Controlled {
53 
54     string public name;                //The Token's name: e.g. DigixDAO Tokens
55     uint8 public decimals;             //Number of decimals of the smallest unit
56     string public symbol;              //An identifier: e.g. REP
57     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
58 
59 
60     /// @dev `Checkpoint` is the structure that attaches a block number to a
61     ///  given value, the block number attached is the one that last changed the
62     ///  value
63     struct  Checkpoint {
64 
65         // `fromBlock` is the block number that the value was generated from
66         uint128 fromBlock;
67 
68         // `value` is the amount of tokens at a specific block number
69         uint128 value;
70     }
71 
72     // `parentToken` is the Token address that was cloned to produce this token;
73     //  it will be 0x0 for a token that was not cloned
74     MiniMeToken public parentToken;
75 
76     // `parentSnapShotBlock` is the block number from the Parent Token that was
77     //  used to determine the initial distribution of the Clone Token
78     uint public parentSnapShotBlock;
79 
80     // `creationBlock` is the block number that the Clone Token was created
81     uint public creationBlock;
82 
83     // `balances` is the map that tracks the balance of each address, in this
84     //  contract when the balance changes the block number that the change
85     //  occurred is also included in the map
86     mapping (address => Checkpoint[]) balances;
87 
88     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
89     mapping (address => mapping (address => uint256)) allowed;
90 
91     // Tracks the history of the `totalSupply` of the token
92     Checkpoint[] totalSupplyHistory;
93 
94     // Flag that determines if the token is transferable or not.
95     bool public transfersEnabled;
96 
97     // The factory used to create new clone tokens
98     MiniMeTokenFactory public tokenFactory;
99 
100 ////////////////
101 // Constructor
102 ////////////////
103 
104     /// @notice Constructor to create a MiniMeToken
105     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
106     ///  will create the Clone token contracts, the token factory needs to be
107     ///  deployed first
108     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
109     ///  new token
110     /// @param _parentSnapShotBlock Block of the parent token that will
111     ///  determine the initial distribution of the clone token, set to 0 if it
112     ///  is a new token
113     /// @param _tokenName Name of the new token
114     /// @param _decimalUnits Number of decimals of the new token
115     /// @param _tokenSymbol Token Symbol for the new token
116     /// @param _transfersEnabled If true, tokens will be able to be transferred
117     function MiniMeToken(
118         address _tokenFactory,
119         address _parentToken,
120         uint _parentSnapShotBlock,
121         string _tokenName,
122         uint8 _decimalUnits,
123         string _tokenSymbol,
124         bool _transfersEnabled
125     ) public {
126         tokenFactory = MiniMeTokenFactory(_tokenFactory);
127         name = _tokenName;                                 // Set the name
128         decimals = _decimalUnits;                          // Set the decimals
129         symbol = _tokenSymbol;                             // Set the symbol
130         parentToken = MiniMeToken(_parentToken);
131         parentSnapShotBlock = _parentSnapShotBlock;
132         transfersEnabled = _transfersEnabled;
133         creationBlock = block.number;
134     }
135 
136 
137 ///////////////////
138 // ERC20 Methods
139 ///////////////////
140 
141     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
142     /// @param _to The address of the recipient
143     /// @param _amount The amount of tokens to be transferred
144     /// @return Whether the transfer was successful or not
145     function transfer(address _to, uint256 _amount) public returns (bool success) {
146         require(transfersEnabled);
147         return doTransfer(msg.sender, _to, _amount);
148     }
149 
150     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
151     ///  is approved by `_from`
152     /// @param _from The address holding the tokens being transferred
153     /// @param _to The address of the recipient
154     /// @param _amount The amount of tokens to be transferred
155     /// @return True if the transfer was successful
156     function transferFrom(address _from, address _to, uint256 _amount
157     ) public returns (bool success) {
158 
159         // The controller of this contract can move tokens around at will,
160         //  this is important to recognize! Confirm that you trust the
161         //  controller of this contract, which in most situations should be
162         //  another open source smart contract or 0x0
163         if (msg.sender != controller) {
164             require(transfersEnabled);
165 
166             // The standard ERC 20 transferFrom functionality
167             if (allowed[_from][msg.sender] < _amount) return false;
168             allowed[_from][msg.sender] -= _amount;
169         }
170         return doTransfer(_from, _to, _amount);
171     }
172 
173     /// @dev This is the actual transfer function in the token contract, it can
174     ///  only be called by other functions in this contract.
175     /// @param _from The address holding the tokens being transferred
176     /// @param _to The address of the recipient
177     /// @param _amount The amount of tokens to be transferred
178     /// @return True if the transfer was successful
179     function doTransfer(address _from, address _to, uint _amount
180     ) internal returns(bool) {
181 
182            if (_amount == 0) {
183                return true;
184            }
185 
186            require(parentSnapShotBlock < block.number);
187 
188            // Do not allow transfer to 0x0 or the token contract itself
189            require((_to != 0) && (_to != address(this)));
190 
191            // If the amount being transfered is more than the balance of the
192            //  account the transfer returns false
193            var previousBalanceFrom = balanceOfAt(_from, block.number);
194            if (previousBalanceFrom < _amount) {
195                return false;
196            }
197 
198            // Alerts the token controller of the transfer
199            if (isContract(controller)) {
200                require(TokenController(controller).onTransfer(_from, _to, _amount));
201            }
202 
203            // First update the balance array with the new value for the address
204            //  sending the tokens
205            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
206 
207            // Then update the balance array with the new value for the address
208            //  receiving the tokens
209            var previousBalanceTo = balanceOfAt(_to, block.number);
210            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
211            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
212 
213            // An event to make the transfer easy to find on the blockchain
214            Transfer(_from, _to, _amount);
215 
216            return true;
217     }
218 
219     /// @param _owner The address that's balance is being requested
220     /// @return The balance of `_owner` at the current block
221     function balanceOf(address _owner) public constant returns (uint256 balance) {
222         return balanceOfAt(_owner, block.number);
223     }
224 
225     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
226     ///  its behalf. This is a modified version of the ERC20 approve function
227     ///  to be a little bit safer
228     /// @param _spender The address of the account able to transfer the tokens
229     /// @param _amount The amount of tokens to be approved for transfer
230     /// @return True if the approval was successful
231     function approve(address _spender, uint256 _amount) public returns (bool success) {
232         require(transfersEnabled);
233 
234         // To change the approve amount you first have to reduce the addresses`
235         //  allowance to zero by calling `approve(_spender,0)` if it is not
236         //  already 0 to mitigate the race condition described here:
237         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
239 
240         // Alerts the token controller of the approve function call
241         if (isContract(controller)) {
242             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
243         }
244 
245         allowed[msg.sender][_spender] = _amount;
246         Approval(msg.sender, _spender, _amount);
247         return true;
248     }
249 
250     /// @dev This function makes it easy to read the `allowed[]` map
251     /// @param _owner The address of the account that owns the token
252     /// @param _spender The address of the account able to transfer the tokens
253     /// @return Amount of remaining tokens of _owner that _spender is allowed
254     ///  to spend
255     function allowance(address _owner, address _spender
256     ) public constant returns (uint256 remaining) {
257         return allowed[_owner][_spender];
258     }
259 
260     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
261     ///  its behalf, and then a function is triggered in the contract that is
262     ///  being approved, `_spender`. This allows users to use their tokens to
263     ///  interact with contracts in one function call instead of two
264     /// @param _spender The address of the contract able to transfer the tokens
265     /// @param _amount The amount of tokens to be approved for transfer
266     /// @return True if the function call was successful
267     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
268     ) public returns (bool success) {
269         require(approve(_spender, _amount));
270 
271         ApproveAndCallFallBack(_spender).receiveApproval(
272             msg.sender,
273             _amount,
274             this,
275             _extraData
276         );
277 
278         return true;
279     }
280 
281     /// @dev This function makes it easy to get the total number of tokens
282     /// @return The total number of tokens
283     function totalSupply() public constant returns (uint) {
284         return totalSupplyAt(block.number);
285     }
286 
287 
288 ////////////////
289 // Query balance and totalSupply in History
290 ////////////////
291 
292     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
293     /// @param _owner The address from which the balance will be retrieved
294     /// @param _blockNumber The block number when the balance is queried
295     /// @return The balance at `_blockNumber`
296     function balanceOfAt(address _owner, uint _blockNumber) public constant
297         returns (uint) {
298 
299         // These next few lines are used when the balance of the token is
300         //  requested before a check point was ever created for this token, it
301         //  requires that the `parentToken.balanceOfAt` be queried at the
302         //  genesis block for that token as this contains initial balance of
303         //  this token
304         if ((balances[_owner].length == 0)
305             || (balances[_owner][0].fromBlock > _blockNumber)) {
306             if (address(parentToken) != 0) {
307                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
308             } else {
309                 // Has no parent
310                 return 0;
311             }
312 
313         // This will return the expected balance during normal situations
314         } else {
315             return getValueAt(balances[_owner], _blockNumber);
316         }
317     }
318 
319     /// @notice Total amount of tokens at a specific `_blockNumber`.
320     /// @param _blockNumber The block number when the totalSupply is queried
321     /// @return The total amount of tokens at `_blockNumber`
322     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
323 
324         // These next few lines are used when the totalSupply of the token is
325         //  requested before a check point was ever created for this token, it
326         //  requires that the `parentToken.totalSupplyAt` be queried at the
327         //  genesis block for this token as that contains totalSupply of this
328         //  token at this block number.
329         if ((totalSupplyHistory.length == 0)
330             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
331             if (address(parentToken) != 0) {
332                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
333             } else {
334                 return 0;
335             }
336 
337         // This will return the expected totalSupply during normal situations
338         } else {
339             return getValueAt(totalSupplyHistory, _blockNumber);
340         }
341     }
342 
343 ////////////////
344 // Clone Token Method
345 ////////////////
346 
347     /// @notice Creates a new clone token with the initial distribution being
348     ///  this token at `_snapshotBlock`
349     /// @param _cloneTokenName Name of the clone token
350     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
351     /// @param _cloneTokenSymbol Symbol of the clone token
352     /// @param _snapshotBlock Block when the distribution of the parent token is
353     ///  copied to set the initial distribution of the new clone token;
354     ///  if the block is zero than the actual block, the current block is used
355     /// @param _transfersEnabled True if transfers are allowed in the clone
356     /// @return The address of the new MiniMeToken Contract
357     function createCloneToken(
358         string _cloneTokenName,
359         uint8 _cloneDecimalUnits,
360         string _cloneTokenSymbol,
361         uint _snapshotBlock,
362         bool _transfersEnabled
363         ) public returns(address) {
364         if (_snapshotBlock == 0) _snapshotBlock = block.number;
365         MiniMeToken cloneToken = tokenFactory.createCloneToken(
366             this,
367             _snapshotBlock,
368             _cloneTokenName,
369             _cloneDecimalUnits,
370             _cloneTokenSymbol,
371             _transfersEnabled
372             );
373 
374         cloneToken.changeController(msg.sender);
375 
376         // An event to make the token easy to find on the blockchain
377         NewCloneToken(address(cloneToken), _snapshotBlock);
378         return address(cloneToken);
379     }
380 
381 ////////////////
382 // Generate and destroy tokens
383 ////////////////
384 
385     /// @notice Generates `_amount` tokens that are assigned to `_owner`
386     /// @param _owner The address that will be assigned the new tokens
387     /// @param _amount The quantity of tokens generated
388     /// @return True if the tokens are generated correctly
389     function generateTokens(address _owner, uint _amount
390     ) public onlyController returns (bool) {
391         uint curTotalSupply = totalSupply();
392         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
393         uint previousBalanceTo = balanceOf(_owner);
394         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
395         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
396         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
397         Transfer(0, _owner, _amount);
398         return true;
399     }
400 
401 
402     /// @notice Burns `_amount` tokens from `_owner`
403     /// @param _owner The address that will lose the tokens
404     /// @param _amount The quantity of tokens to burn
405     /// @return True if the tokens are burned correctly
406     function destroyTokens(address _owner, uint _amount
407     ) onlyController public returns (bool) {
408         uint curTotalSupply = totalSupply();
409         require(curTotalSupply >= _amount);
410         uint previousBalanceFrom = balanceOf(_owner);
411         require(previousBalanceFrom >= _amount);
412         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
413         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
414         Transfer(_owner, 0, _amount);
415         return true;
416     }
417 
418 ////////////////
419 // Enable tokens transfers
420 ////////////////
421 
422 
423     /// @notice Enables token holders to transfer their tokens freely if true
424     /// @param _transfersEnabled True if transfers are allowed in the clone
425     function enableTransfers(bool _transfersEnabled) public onlyController {
426         transfersEnabled = _transfersEnabled;
427     }
428 
429 ////////////////
430 // Internal helper functions to query and set a value in a snapshot array
431 ////////////////
432 
433     /// @dev `getValueAt` retrieves the number of tokens at a given block number
434     /// @param checkpoints The history of values being queried
435     /// @param _block The block number to retrieve the value at
436     /// @return The number of tokens being queried
437     function getValueAt(Checkpoint[] storage checkpoints, uint _block
438     ) constant internal returns (uint) {
439         if (checkpoints.length == 0) return 0;
440 
441         // Shortcut for the actual value
442         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
443             return checkpoints[checkpoints.length-1].value;
444         if (_block < checkpoints[0].fromBlock) return 0;
445 
446         // Binary search of the value in the array
447         uint min = 0;
448         uint max = checkpoints.length-1;
449         while (max > min) {
450             uint mid = (max + min + 1)/ 2;
451             if (checkpoints[mid].fromBlock<=_block) {
452                 min = mid;
453             } else {
454                 max = mid-1;
455             }
456         }
457         return checkpoints[min].value;
458     }
459 
460     /// @dev `updateValueAtNow` used to update the `balances` map and the
461     ///  `totalSupplyHistory`
462     /// @param checkpoints The history of data being updated
463     /// @param _value The new number of tokens
464     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
465     ) internal  {
466         if ((checkpoints.length == 0)
467         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
468                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
469                newCheckPoint.fromBlock =  uint128(block.number);
470                newCheckPoint.value = uint128(_value);
471            } else {
472                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
473                oldCheckPoint.value = uint128(_value);
474            }
475     }
476 
477     /// @dev Internal function to determine if an address is a contract
478     /// @param _addr The address being queried
479     /// @return True if `_addr` is a contract
480     function isContract(address _addr) constant internal returns(bool) {
481         uint size;
482         if (_addr == 0) return false;
483         assembly {
484             size := extcodesize(_addr)
485         }
486         return size>0;
487     }
488 
489     /// @dev Helper function to return a min betwen the two uints
490     function min(uint a, uint b) pure internal returns (uint) {
491         return a < b ? a : b;
492     }
493 
494     /// @notice The fallback function: If the contract's controller has not been
495     ///  set to 0, then the `proxyPayment` method is called which relays the
496     ///  ether and creates tokens as described in the token controller contract
497     function () public payable {
498         require(isContract(controller));
499         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
500     }
501 
502 //////////
503 // Safety Methods
504 //////////
505 
506     /// @notice This method can be used by the controller to extract mistakenly
507     ///  sent tokens to this contract.
508     /// @param _token The address of the token contract that you want to recover
509     ///  set to 0 in case you want to extract ether.
510     function claimTokens(address _token) public onlyController {
511         if (_token == 0x0) {
512             controller.transfer(this.balance);
513             return;
514         }
515 
516         MiniMeToken token = MiniMeToken(_token);
517         uint balance = token.balanceOf(this);
518         token.transfer(controller, balance);
519         ClaimedTokens(_token, controller, balance);
520     }
521 
522 ////////////////
523 // Events
524 ////////////////
525     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
526     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
527     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
528     event Approval(
529         address indexed _owner,
530         address indexed _spender,
531         uint256 _amount
532         );
533 
534 }
535 
536 
537 ////////////////
538 // MiniMeTokenFactory
539 ////////////////
540 
541 /// @dev This contract is used to generate clone contracts from a contract.
542 ///  In solidity this is the way to create a contract from a contract of the
543 ///  same class
544 contract MiniMeTokenFactory {
545 
546     /// @notice Update the DApp by creating a new token with new functionalities
547     ///  the msg.sender becomes the controller of this clone token
548     /// @param _parentToken Address of the token being cloned
549     /// @param _snapshotBlock Block of the parent token that will
550     ///  determine the initial distribution of the clone token
551     /// @param _tokenName Name of the new token
552     /// @param _decimalUnits Number of decimals of the new token
553     /// @param _tokenSymbol Token Symbol for the new token
554     /// @param _transfersEnabled If true, tokens will be able to be transferred
555     /// @return The address of the new token contract
556     function createCloneToken(
557         address _parentToken,
558         uint _snapshotBlock,
559         string _tokenName,
560         uint8 _decimalUnits,
561         string _tokenSymbol,
562         bool _transfersEnabled
563     ) public returns (MiniMeToken) {
564         MiniMeToken newToken = new MiniMeToken(
565             this,
566             _parentToken,
567             _snapshotBlock,
568             _tokenName,
569             _decimalUnits,
570             _tokenSymbol,
571             _transfersEnabled
572             );
573 
574         newToken.changeController(msg.sender);
575         return newToken;
576     }
577 }
578 
579 
580 contract Ownable {
581   address public owner;
582 
583 
584   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586 
587   /**
588    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
589    * account.
590    */
591   function Ownable() public {
592     owner = msg.sender;
593   }
594 
595 
596   /**
597    * @dev Throws if called by any account other than the owner.
598    */
599   modifier onlyOwner() {
600     require(msg.sender == owner);
601     _;
602   }
603 
604 
605   /**
606    * @dev Allows the current owner to transfer control of the contract to a newOwner.
607    * @param newOwner The address to transfer ownership to.
608    */
609   function transferOwnership(address newOwner) public onlyOwner {
610     require(newOwner != address(0));
611     OwnershipTransferred(owner, newOwner);
612     owner = newOwner;
613   }
614 }
615 
616 contract WhiteList is Ownable {
617 
618   mapping (address => bool) public whiteListed;
619   address[] public investors;
620   address[] public contracts;
621 
622   // Address early participation whitelist status changed
623   event WhiteListed(address addr, bool status);
624 
625   modifier areWhiteListed(address[] addrs) {
626     for (uint i=0; i<addrs.length; i++) {
627         if (!whiteListed[addrs[i]] || addrs[i] == 0)
628             revert();
629     }
630     _;
631   }
632 
633   modifier areNotWhiteListed(address[] addrs) {
634     for (uint i=0; i<addrs.length; i++) {
635         if (whiteListed[addrs[i]] || addrs[i] == 0)
636             revert();
637     }
638     _;
639   }
640 
641   function WhiteList(address[] addrs) public {
642     for (uint i=0; i<addrs.length; i++) {
643         if(isContract(addrs[i])){
644             contracts.push(addrs[i]);
645         } else {
646             investors.push(addrs[i]);
647         }
648         if (whiteListed[addrs[i]] || addrs[i] == 0) {
649             revert();
650         }
651         whiteListed[addrs[i]] = true;
652     }
653 
654   }
655 
656   function addAddress(address[] addrs) public onlyOwner areNotWhiteListed(addrs) {
657     for (uint i=0; i<addrs.length; i++) {
658         whiteListed[addrs[i]] = true;
659         if(isContract(addrs[i])){
660             contracts.push(addrs[i]);
661         } else {
662             investors.push(addrs[i]);
663         }
664         WhiteListed(addrs[i], true);
665     }
666   }
667 
668   function removeAddress(address addr) public onlyOwner {
669     require(whiteListed[addr]);
670     if (isContract(addr)) {
671         for (uint i=0; i<contracts.length - 1; i++) {
672             if (contracts[i] == addr) {
673                 contracts[i] = contracts[contracts.length - 1];
674                 break;
675             }
676         }
677         contracts.length -= 1;
678     } else {
679         for (uint j=0; j<investors.length - 1; j++) {
680             if (investors[j] == addr) {
681                 investors[j] = investors[investors.length - 1];
682                 break;
683             }
684         }
685         investors.length -= 1;
686     }
687     whiteListed[addr] = false;
688     WhiteListed(addr, false);
689   }
690 
691   /// @dev Internal function to determine if an address is a contract
692   /// @param _addr The address being queried
693   /// @return True if `_addr` is a contract
694   function isContract(address _addr) constant internal returns(bool) {
695     uint size;
696     if (_addr == 0) return false;
697     assembly {
698         size := extcodesize(_addr)
699     }
700     return size>0;
701   }
702 
703 
704   // web3 function call
705   function getInvestors() public constant returns (address[]) {
706     return investors;
707   }
708 
709   function getContracts() public constant returns (address[]) {
710     return contracts;
711   }
712 
713   function isWhiteListed(address addr) public constant returns (bool) {
714     return whiteListed[addr];
715   }
716 
717 }
718 
719 
720 contract MultiSigWallet {
721 
722     /*
723      *  Events
724      */
725     event Confirmation(address indexed sender, uint indexed transactionId);
726     event Revocation(address indexed sender, uint indexed transactionId);
727     event Submission(uint indexed transactionId);
728     event Execution(uint indexed transactionId);
729     event ExecutionFailure(uint indexed transactionId);
730     event Deposit(address indexed sender, uint value);
731     event OwnerAddition(address indexed owner);
732     event OwnerRemoval(address indexed owner);
733     event RequirementChange(uint required);
734 
735     /*
736      *  Constants
737      */
738     uint constant public MAX_OWNER_COUNT = 50;
739 
740     /*
741      *  Storage
742      */
743     mapping (uint => Transaction) public transactions;
744     mapping (uint => mapping (address => bool)) public confirmations;
745     mapping (address => bool) public isOwner;
746     address[] public owners;
747     uint public required;
748     uint public transactionCount;
749 
750     struct Transaction {
751         address destination;
752         uint value;
753         bytes data;
754         bool executed;
755     }
756 
757 
758     /*
759      *  Modifiers
760      */
761     modifier onlyWallet() {
762         if (msg.sender != address(this))
763             revert();
764         _;
765     }
766 
767     modifier onlyOwner() {
768         if(!isOwner[msg.sender]) 
769             revert();
770         _;
771     }
772 
773     modifier ownerDoesNotExist(address owner) {
774         if (isOwner[owner])
775             revert();
776         _;
777     }
778 
779     modifier ownerExists(address owner) {
780         if (!isOwner[owner])
781             revert();
782         _;
783     }
784 
785     modifier transactionExists(uint transactionId) {
786         if (transactions[transactionId].destination == 0)
787             revert();
788         _;
789     }
790 
791     modifier confirmed(uint transactionId, address owner) {
792         if (!confirmations[transactionId][owner])
793             revert();
794         _;
795     }
796 
797     modifier notConfirmed(uint transactionId, address owner) {
798         if (confirmations[transactionId][owner])
799             revert();
800         _;
801     }
802 
803     modifier notExecuted(uint transactionId) {
804         if (transactions[transactionId].executed)
805             revert();
806         _;
807     }
808 
809     modifier notNull(address _address) {
810         if (_address == 0)
811             revert();
812         _;
813     }
814 
815     modifier validRequirement(uint ownerCount, uint _required) {
816         if (   ownerCount > MAX_OWNER_COUNT
817             || _required > ownerCount
818             || _required == 0
819             || ownerCount == 0)
820             revert();
821         _;
822     }
823 
824     /// @dev Fallback function allows to deposit ether.
825     function() public payable
826     {
827         if (msg.value > 0)
828             Deposit(msg.sender, msg.value);
829     }
830 
831     function MultiSigWallet(address[] _owners, uint _required)
832         public
833         validRequirement(_owners.length, _required)
834     {
835         for (uint i=0; i<_owners.length; i++) {
836             if (isOwner[_owners[i]] || _owners[i] == 0)
837                 revert();
838             isOwner[_owners[i]] = true;
839         }
840         owners = _owners;
841         required = _required;
842     }
843 
844     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
845     /// @param owner Address of new owner.
846     function addOwner(address owner)
847         public
848         onlyWallet
849         ownerDoesNotExist(owner)
850         notNull(owner)
851         validRequirement(owners.length + 1, required)
852     {
853         isOwner[owner] = true;
854         owners.push(owner);
855         OwnerAddition(owner);
856     }
857 
858     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
859     /// @param owner Address of owner.
860     function removeOwner(address owner)
861         public
862         onlyWallet
863         ownerExists(owner)
864     {
865         isOwner[owner] = false;
866         for (uint i=0; i<owners.length - 1; i++)
867             if (owners[i] == owner) {
868                 owners[i] = owners[owners.length - 1];
869                 break;
870             }
871         owners.length -= 1;
872         if (required > owners.length)
873             changeRequirement(owners.length);
874         OwnerRemoval(owner);
875     }
876 
877     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
878     /// @param owner Address of owner to be replaced.
879     /// @param newOwner Address of new owner.
880     function replaceOwner(address owner, address newOwner)
881         public
882         onlyWallet
883         ownerExists(owner)
884         ownerDoesNotExist(newOwner)
885     {
886         for (uint i=0; i<owners.length; i++)
887             if (owners[i] == owner) {
888                 owners[i] = newOwner;
889                 break;
890             }
891         isOwner[owner] = false;
892         isOwner[newOwner] = true;
893         OwnerRemoval(owner);
894         OwnerAddition(newOwner);
895     }
896 
897     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
898     /// @param _required Number of required confirmations.
899     function changeRequirement(uint _required)
900         public
901         onlyWallet
902         validRequirement(owners.length, _required)
903     {
904         required = _required;
905         RequirementChange(_required);
906     }
907 
908     /// @dev Allows an owner to submit and confirm a transaction.
909     /// @param destination Transaction target address.
910     /// @param value Transaction ether value.
911     /// @param data Transaction data payload.
912     /// @return Returns transaction ID.
913     function submitTransaction(address destination, uint value, bytes data)
914         public
915         returns (uint transactionId)
916     {
917         transactionId = addTransaction(destination, value, data);
918         confirmTransaction(transactionId);
919     }
920 
921     /// @dev Allows an owner to confirm a transaction.
922     /// @param transactionId Transaction ID.
923     function confirmTransaction(uint transactionId)
924         public
925         ownerExists(msg.sender)
926         transactionExists(transactionId)
927         notConfirmed(transactionId, msg.sender)
928     {
929         confirmations[transactionId][msg.sender] = true;
930         Confirmation(msg.sender, transactionId);
931         executeTransaction(transactionId);
932     }
933 
934     /// @dev Allows an owner to revoke a confirmation for a transaction.
935     /// @param transactionId Transaction ID.
936     function revokeConfirmation(uint transactionId)
937         public
938         ownerExists(msg.sender)
939         confirmed(transactionId, msg.sender)
940         notExecuted(transactionId)
941     {
942         confirmations[transactionId][msg.sender] = false;
943         Revocation(msg.sender, transactionId);
944     }
945 
946     /// @dev Allows anyone to execute a confirmed transaction.
947     /// @param transactionId Transaction ID.
948     function executeTransaction(uint transactionId)
949         public
950         ownerExists(msg.sender)
951         confirmed(transactionId, msg.sender)
952         notExecuted(transactionId)
953     {
954         if (isConfirmed(transactionId)) {
955 
956             transactions[transactionId].executed = true;
957             if (transactions[transactionId].destination.call.value(transactions[transactionId].value)(transactions[transactionId].data))
958                 Execution(transactionId);
959             else {
960                 ExecutionFailure(transactionId);
961                 transactions[transactionId].executed = false;
962             }
963         }
964     }
965 
966     /// @dev Returns the confirmation status of a transaction.
967     /// @param transactionId Transaction ID.
968     /// @return Confirmation status.
969     function isConfirmed(uint transactionId)
970         public
971         constant
972         returns (bool)
973     {
974         uint count = 0;
975         for (uint i=0; i<owners.length; i++) {
976             if (confirmations[transactionId][owners[i]])
977                 count += 1;
978             if (count == required)
979                 return true;
980         }
981     }
982 
983     /*
984      * Internal functions
985      */
986     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
987     /// @param destination Transaction target address.
988     /// @param value Transaction ether value.
989     /// @param data Transaction data payload.
990     /// @return Returns transaction ID.
991     function addTransaction(address destination, uint value, bytes data)
992         internal
993         notNull(destination)
994         returns (uint transactionId)
995     {
996         transactionId = transactionCount;
997         transactions[transactionId] = Transaction({
998             destination: destination,
999             value: value,
1000             data: data,
1001             executed: false
1002         });
1003         transactionCount += 1;
1004         Submission(transactionId);
1005     }
1006 
1007     /*
1008      * Web3 call functions
1009      */
1010     /// @dev Returns number of confirmations of a transaction.
1011     /// @param transactionId Transaction ID.
1012     /// @return Number of confirmations.
1013     function getConfirmationCount(uint transactionId)
1014         public
1015         constant
1016         returns (uint count)
1017     {
1018         for (uint i=0; i<owners.length; i++)
1019             if (confirmations[transactionId][owners[i]])
1020                 count += 1;
1021     }
1022 
1023     /// @dev Returns total number of transactions after filers are applied.
1024     /// @param pending Include pending transactions.
1025     /// @param executed Include executed transactions.
1026     /// @return Total number of transactions after filters are applied.
1027     function getTransactionCount(bool pending, bool executed)
1028         public
1029         constant
1030         returns (uint count)
1031     {
1032         for (uint i=0; i<transactionCount; i++)
1033             if (   pending && !transactions[i].executed
1034                 || executed && transactions[i].executed)
1035                 count += 1;
1036     }
1037 
1038     /// @dev Returns list of owners.
1039     /// @return List of owner addresses.
1040     function getOwners()
1041         public
1042         constant
1043         returns (address[])
1044     {
1045         return owners;
1046     }
1047 
1048     /// @dev Returns array with owner addresses, which confirmed transaction.
1049     /// @param transactionId Transaction ID.
1050     /// @return Returns array of owner addresses.
1051     function getConfirmations(uint transactionId)
1052         public
1053         constant
1054         returns (address[] _confirmations)
1055     {
1056         address[] memory confirmationsTemp = new address[](owners.length);
1057         uint count = 0;
1058         uint i;
1059         for (i=0; i<owners.length; i++)
1060             if (confirmations[transactionId][owners[i]]) {
1061                 confirmationsTemp[count] = owners[i];
1062                 count += 1;
1063             }
1064         _confirmations = new address[](count);
1065         for (i=0; i<count; i++)
1066             _confirmations[i] = confirmationsTemp[i];
1067     }
1068 
1069     /// @dev Returns list of transaction IDs in defined range.
1070     /// @param from Index start position of transaction array.
1071     /// @param to Index end position of transaction array.
1072     /// @param pending Include pending transactions.
1073     /// @param executed Include executed transactions.
1074     /// @return Returns array of transaction IDs.
1075     function getTransactionIds(uint from, uint to, bool pending, bool executed)
1076         public
1077         constant
1078         returns (uint[] _transactionIds)
1079     {
1080         uint[] memory transactionIdsTemp = new uint[](transactionCount);
1081         uint count = 0;
1082         uint i;
1083         for (i=0; i<transactionCount; i++)
1084             if (   pending && !transactions[i].executed
1085                 || executed && transactions[i].executed)
1086             {
1087                 transactionIdsTemp[count] = i;
1088                 count += 1;
1089             }
1090         _transactionIds = new uint[](to - from);
1091         for (i=from; i<to; i++)
1092             _transactionIds[i - from] = transactionIdsTemp[i];
1093     }
1094 }
1095 
1096 
1097 contract Market is TokenController, MultiSigWallet {
1098 
1099 	uint public totalTokenCollected;
1100 
1101 	MiniMeToken public tokenContract;
1102     WhiteList public MyWhiteList;
1103 
1104 	uint public basePrice;
1105 	uint public marketCap;
1106 
1107 	uint public startFundingTime;
1108 	uint public endFundingTime;
1109 	// market duration 6 hour. 6 * 60 * 60
1110 	uint public constant DURATION = 21600;
1111 
1112     modifier beforeStart {
1113         require(!saleStarted());
1114         _;
1115     }
1116 
1117     modifier inProgress {
1118         require(saleStarted() && ! saleEnded());
1119         _;
1120     }
1121 
1122 	/// @return true if sale has started, false otherwise.
1123     function saleStarted() public constant returns (bool) {
1124         return (startFundingTime > 0 && now >= startFundingTime);
1125     }
1126 
1127 	/// @return true if sale is due when the last phase is finished.
1128     function saleEnded() public constant returns (bool) {
1129         return now >= endFundingTime;
1130     }
1131 
1132 
1133 	function Market(
1134 		address _whiteListAddress,
1135 		address _tokenAddress,
1136 		address[] _owners,
1137 		uint _required
1138 	) public MultiSigWallet(_owners, _required) {
1139 		MyWhiteList = WhiteList(_whiteListAddress);
1140 		tokenContract = MiniMeToken(_tokenAddress);
1141 	}
1142 
1143 	function startAndSetParams(uint _basePrice, uint _marketCap) onlyWallet beforeStart public {
1144 		basePrice = _basePrice;
1145 		marketCap = _marketCap;
1146 		startFundingTime = now;
1147 		endFundingTime = startFundingTime + DURATION;
1148 	}
1149 
1150 	function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
1151 		require (MyWhiteList.isWhiteListed(_from));
1152 		require (MyWhiteList.isWhiteListed(_to));
1153 		if(address(this) == _to) {
1154 			uint ethAmount = computeEtherAmount(_amount);
1155 			require(this.balance > ethAmount);
1156 			totalTokenCollected = totalTokenCollected + _amount;
1157 			_from.transfer(ethAmount);
1158 		}
1159 		return true;
1160 	}
1161 
1162 	function onApprove(address _owner, address _spender, uint) public returns(bool) {
1163 		require (MyWhiteList.isWhiteListed(_owner));
1164         require (MyWhiteList.isWhiteListed(_spender));
1165 		return true;
1166 	}
1167 
1168 	function deposit() public onlyOwner payable {
1169 		// deposit ether in this contract but do not get any token;
1170 		if (msg.value > 0) {
1171 			Deposit(msg.sender, msg.value);
1172 		}
1173 	}
1174 
1175 	function() public payable {
1176 	    require (MyWhiteList.isWhiteListed(msg.sender));
1177 		doPayment(msg.sender);
1178 	}
1179 
1180 	function proxyPayment(address _owner) public payable returns(bool) {
1181 		require (MyWhiteList.isWhiteListed(_owner));
1182 		doPayment(_owner);
1183 		return true;
1184 	}
1185 
1186 	function doPayment(address _owner) inProgress internal {
1187 		require((tokenContract.controller() != 0) && (msg.value != 0));
1188 
1189 		uint tokenAmount = computeTokenAmount(msg.value);
1190 		uint generateTokenAmount = tokenAmount - totalTokenCollected;
1191 		uint currentSupply = tokenContract.totalSupply();
1192 		// total supply must not exceed marketCap after execution
1193 		require(currentSupply + generateTokenAmount <= marketCap);
1194 
1195 		// transfer collected token first. only generate token when necessary.
1196 		if (tokenAmount >= totalTokenCollected) {
1197 			if(totalTokenCollected !=0) {
1198 				tokenContract.transfer(_owner, totalTokenCollected);
1199 				totalTokenCollected = 0;
1200 			}
1201 			require(tokenContract.generateTokens(_owner, generateTokenAmount));
1202 		} else {
1203 			tokenContract.transfer(_owner, tokenAmount);
1204 			totalTokenCollected = totalTokenCollected - tokenAmount;
1205 		}
1206 
1207 		return;
1208 	}
1209 
1210 	function updateBasePriceAndMarketCap(uint _basePrice, uint _marketCap) onlyWallet public {
1211 		basePrice = _basePrice;
1212     marketCap = _marketCap; 
1213 	}
1214 
1215 	function computeTokenAmount(uint ethAmount) view internal returns (uint tokens) {
1216 		tokens = ethAmount * basePrice;
1217 	}
1218 
1219 	function computeEtherAmount(uint tokenAmount) view internal returns (uint eth) {
1220 		eth = tokenAmount / basePrice;
1221 	}
1222 }