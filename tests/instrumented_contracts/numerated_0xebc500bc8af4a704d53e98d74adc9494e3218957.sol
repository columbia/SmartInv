1 pragma solidity ^0.4.13;
2 
3 contract TokenController {
4     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
5     /// @param _owner The address that sent the ether to create tokens
6     /// @return True if the ether is accepted, false if it throws
7     function proxyPayment(address _owner) public payable returns(bool);
8 
9     /// @notice Notifies the controller about a token transfer allowing the
10     ///  controller to react if desired
11     /// @param _from The origin of the transfer
12     /// @param _to The destination of the transfer
13     /// @param _amount The amount of the transfer
14     /// @return False if the controller does not authorize the transfer
15     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
16 
17     /// @notice Notifies the controller about an approval allowing the
18     ///  controller to react if desired
19     /// @param _owner The address that calls `approve()`
20     /// @param _spender The spender in the `approve()` call
21     /// @param _amount The amount in the `approve()` call
22     /// @return False if the controller does not authorize the approval
23     function onApprove(address _owner, address _spender, uint _amount) public
24         returns(bool);
25 }
26 
27 contract Controlled {
28     /// @notice The address of the controller is the only address that can call
29     ///  a function with this modifier
30     modifier onlyController { require(msg.sender == controller); _; }
31 
32     address public controller;
33 
34     function Controlled() public { controller = msg.sender;}
35 
36     /// @notice Changes the controller of the contract
37     /// @param _newController The new controller of the contract
38     function changeController(address _newController) public onlyController {
39         controller = _newController;
40     }
41 }
42 
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
45 }
46 
47 contract Blocked {
48   mapping (address => bool) blocked;
49 
50   event Blocked(address _addr);
51   event Unblocked(address _addr);
52 
53   function blockAddress(address _addr) public {
54     require(!blocked[_addr]);
55     blocked[_addr] = true;
56 
57     Blocked(_addr);
58   }
59 
60   function unblockAddress(address _addr) public {
61     require(blocked[_addr]);
62     blocked[_addr] = false;
63 
64     Unblocked(_addr);
65   }
66 }
67 
68 contract MiniMeToken is Controlled {
69 
70     string public name;                //The Token's name: e.g. DigixDAO Tokens
71     uint8 public decimals;             //Number of decimals of the smallest unit
72     string public symbol;              //An identifier: e.g. REP
73     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
74 
75 
76     /// @dev `Checkpoint` is the structure that attaches a block number to a
77     ///  given value, the block number attached is the one that last changed the
78     ///  value
79     struct  Checkpoint {
80 
81         // `fromBlock` is the block number that the value was generated from
82         uint128 fromBlock;
83 
84         // `value` is the amount of tokens at a specific block number
85         uint128 value;
86     }
87 
88     // `parentToken` is the Token address that was cloned to produce this token;
89     //  it will be 0x0 for a token that was not cloned
90     MiniMeToken public parentToken;
91 
92     // `parentSnapShotBlock` is the block number from the Parent Token that was
93     //  used to determine the initial distribution of the Clone Token
94     uint public parentSnapShotBlock;
95 
96     // `creationBlock` is the block number that the Clone Token was created
97     uint public creationBlock;
98 
99     // `balances` is the map that tracks the balance of each address, in this
100     //  contract when the balance changes the block number that the change
101     //  occurred is also included in the map
102     mapping (address => Checkpoint[]) balances;
103 
104     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
105     mapping (address => mapping (address => uint256)) allowed;
106 
107     // Tracks the history of the `totalSupply` of the token
108     Checkpoint[] totalSupplyHistory;
109 
110     // Flag that determines if the token is transferable or not.
111     bool public transfersEnabled;
112 
113     // The factory used to create new clone tokens
114     MiniMeTokenFactory public tokenFactory;
115 
116 ////////////////
117 // Constructor
118 ////////////////
119 
120     /// @notice Constructor to create a MiniMeToken
121     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
122     ///  will create the Clone token contracts, the token factory needs to be
123     ///  deployed first
124     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
125     ///  new token
126     /// @param _parentSnapShotBlock Block of the parent token that will
127     ///  determine the initial distribution of the clone token, set to 0 if it
128     ///  is a new token
129     /// @param _tokenName Name of the new token
130     /// @param _decimalUnits Number of decimals of the new token
131     /// @param _tokenSymbol Token Symbol for the new token
132     /// @param _transfersEnabled If true, tokens will be able to be transferred
133     function MiniMeToken(
134         address _tokenFactory,
135         address _parentToken,
136         uint _parentSnapShotBlock,
137         string _tokenName,
138         uint8 _decimalUnits,
139         string _tokenSymbol,
140         bool _transfersEnabled
141     ) public {
142         tokenFactory = MiniMeTokenFactory(_tokenFactory);
143         name = _tokenName;                                 // Set the name
144         decimals = _decimalUnits;                          // Set the decimals
145         symbol = _tokenSymbol;                             // Set the symbol
146         parentToken = MiniMeToken(_parentToken);
147         parentSnapShotBlock = _parentSnapShotBlock;
148         transfersEnabled = _transfersEnabled;
149         creationBlock = block.number;
150     }
151 
152 
153 ///////////////////
154 // ERC20 Methods
155 ///////////////////
156 
157     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
158     /// @param _to The address of the recipient
159     /// @param _amount The amount of tokens to be transferred
160     /// @return Whether the transfer was successful or not
161     function transfer(address _to, uint256 _amount) public returns (bool success) {
162         require(transfersEnabled);
163         doTransfer(msg.sender, _to, _amount);
164         return true;
165     }
166 
167     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
168     ///  is approved by `_from`
169     /// @param _from The address holding the tokens being transferred
170     /// @param _to The address of the recipient
171     /// @param _amount The amount of tokens to be transferred
172     /// @return True if the transfer was successful
173     function transferFrom(address _from, address _to, uint256 _amount
174     ) public returns (bool success) {
175 
176         // The controller of this contract can move tokens around at will,
177         //  this is important to recognize! Confirm that you trust the
178         //  controller of this contract, which in most situations should be
179         //  another open source smart contract or 0x0
180         if (msg.sender != controller) {
181             require(transfersEnabled);
182 
183             // The standard ERC 20 transferFrom functionality
184             require(allowed[_from][msg.sender] >= _amount);
185             allowed[_from][msg.sender] -= _amount;
186         }
187         doTransfer(_from, _to, _amount);
188         return true;
189     }
190 
191     /// @dev This is the actual transfer function in the token contract, it can
192     ///  only be called by other functions in this contract.
193     /// @param _from The address holding the tokens being transferred
194     /// @param _to The address of the recipient
195     /// @param _amount The amount of tokens to be transferred
196     /// @return True if the transfer was successful
197     function doTransfer(address _from, address _to, uint _amount
198     ) internal {
199 
200            if (_amount == 0) {
201                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
202                return;
203            }
204 
205            require(parentSnapShotBlock < block.number);
206                    // Do not allow transfer to 0x0 or the token contract itself
207 //           require((_to != 0) && (_to != address(this)));
208 
209            // If the amount being transfered is more than the balance of the
210            //  account the transfer throws
211            var previousBalanceFrom = balanceOfAt(_from, block.number);
212 
213            require(previousBalanceFrom >= _amount);
214 
215            // Alerts the token controller of the transfer
216 //           if (isContract(controller)) {
217 //               require(TokenController(controller).onTransfer(_from, _to, _amount));
218 //           }
219 
220            // First update the balance array with the new value for the address
221            //  sending the tokens
222            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
223 
224            // Then update the balance array with the new value for the address
225            //  receiving the tokens
226            var previousBalanceTo = balanceOfAt(_to, block.number);
227            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
228            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
229 
230            // An event to make the transfer easy to find on the blockchain
231            Transfer(_from, _to, _amount);
232 
233     }
234 
235     /// @param _owner The address that's balance is being requested
236     /// @return The balance of `_owner` at the current block
237     function balanceOf(address _owner) public constant returns (uint256 balance) {
238         return balanceOfAt(_owner, block.number);
239     }
240 
241     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
242     ///  its behalf. This is a modified version of the ERC20 approve function
243     ///  to be a little bit safer
244     /// @param _spender The address of the account able to transfer the tokens
245     /// @param _amount The amount of tokens to be approved for transfer
246     /// @return True if the approval was successful
247     function approve(address _spender, uint256 _amount) public returns (bool success) {
248         require(transfersEnabled);
249 
250         // To change the approve amount you first have to reduce the addresses`
251         //  allowance to zero by calling `approve(_spender,0)` if it is not
252         //  already 0 to mitigate the race condition described here:
253         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
255 
256         // Alerts the token controller of the approve function call
257         if (isContract(controller)) {
258             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
259         }
260 
261         allowed[msg.sender][_spender] = _amount;
262         Approval(msg.sender, _spender, _amount);
263         return true;
264     }
265 
266     /// @dev This function makes it easy to read the `allowed[]` map
267     /// @param _owner The address of the account that owns the token
268     /// @param _spender The address of the account able to transfer the tokens
269     /// @return Amount of remaining tokens of _owner that _spender is allowed
270     ///  to spend
271     function allowance(address _owner, address _spender
272     ) public constant returns (uint256 remaining) {
273         return allowed[_owner][_spender];
274     }
275 
276     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
277     ///  its behalf, and then a function is triggered in the contract that is
278     ///  being approved, `_spender`. This allows users to use their tokens to
279     ///  interact with contracts in one function call instead of two
280     /// @param _spender The address of the contract able to transfer the tokens
281     /// @param _amount The amount of tokens to be approved for transfer
282     /// @return True if the function call was successful
283     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
284     ) public returns (bool success) {
285         require(approve(_spender, _amount));
286 
287         ApproveAndCallFallBack(_spender).receiveApproval(
288             msg.sender,
289             _amount,
290             this,
291             _extraData
292         );
293 
294         return true;
295     }
296 
297     /// @dev This function makes it easy to get the total number of tokens
298     /// @return The total number of tokens
299     function totalSupply() public constant returns (uint) {
300         return totalSupplyAt(block.number);
301     }
302 
303 
304 ////////////////
305 // Query balance and totalSupply in History
306 ////////////////
307 
308     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
309     /// @param _owner The address from which the balance will be retrieved
310     /// @param _blockNumber The block number when the balance is queried
311     /// @return The balance at `_blockNumber`
312     function balanceOfAt(address _owner, uint _blockNumber) public constant
313         returns (uint) {
314 
315         // These next few lines are used when the balance of the token is
316         //  requested before a check point was ever created for this token, it
317         //  requires that the `parentToken.balanceOfAt` be queried at the
318         //  genesis block for that token as this contains initial balance of
319         //  this token
320         if ((balances[_owner].length == 0)
321             || (balances[_owner][0].fromBlock > _blockNumber)) {
322             if (address(parentToken) != 0) {
323                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
324             } else {
325                 // Has no parent
326                 return 0;
327             }
328 
329         // This will return the expected balance during normal situations
330         } else {
331             return getValueAt(balances[_owner], _blockNumber);
332         }
333     }
334 
335     /// @notice Total amount of tokens at a specific `_blockNumber`.
336     /// @param _blockNumber The block number when the totalSupply is queried
337     /// @return The total amount of tokens at `_blockNumber`
338     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
339 
340         // These next few lines are used when the totalSupply of the token is
341         //  requested before a check point was ever created for this token, it
342         //  requires that the `parentToken.totalSupplyAt` be queried at the
343         //  genesis block for this token as that contains totalSupply of this
344         //  token at this block number.
345         if ((totalSupplyHistory.length == 0)
346             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
347             if (address(parentToken) != 0) {
348                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
349             } else {
350                 return 0;
351             }
352 
353         // This will return the expected totalSupply during normal situations
354         } else {
355             return getValueAt(totalSupplyHistory, _blockNumber);
356         }
357     }
358 
359 ////////////////
360 // Clone Token Method
361 ////////////////
362 
363     /// @notice Creates a new clone token with the initial distribution being
364     ///  this token at `_snapshotBlock`
365     /// @param _cloneTokenName Name of the clone token
366     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
367     /// @param _cloneTokenSymbol Symbol of the clone token
368     /// @param _snapshotBlock Block when the distribution of the parent token is
369     ///  copied to set the initial distribution of the new clone token;
370     ///  if the block is zero than the actual block, the current block is used
371     /// @param _transfersEnabled True if transfers are allowed in the clone
372     /// @return The address of the new MiniMeToken Contract
373     function createCloneToken(
374         string _cloneTokenName,
375         uint8 _cloneDecimalUnits,
376         string _cloneTokenSymbol,
377         uint _snapshotBlock,
378         bool _transfersEnabled
379         ) public returns(address) {
380         if (_snapshotBlock == 0) _snapshotBlock = block.number;
381         MiniMeToken cloneToken = tokenFactory.createCloneToken(
382             this,
383             _snapshotBlock,
384             _cloneTokenName,
385             _cloneDecimalUnits,
386             _cloneTokenSymbol,
387             _transfersEnabled
388             );
389 
390         cloneToken.changeController(msg.sender);
391 
392         // An event to make the token easy to find on the blockchain
393         NewCloneToken(address(cloneToken), _snapshotBlock);
394         return address(cloneToken);
395     }
396 
397 ////////////////
398 // Generate and destroy tokens
399 ////////////////
400 
401     /// @notice Generates `_amount` tokens that are assigned to `_owner`
402     /// @param _owner The address that will be assigned the new tokens
403     /// @param _amount The quantity of tokens generated
404     /// @return True if the tokens are generated correctly
405     function generateTokens(address _owner, uint _amount
406     ) public onlyController returns (bool) {
407         uint curTotalSupply = totalSupply();
408         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
409         uint previousBalanceTo = balanceOf(_owner);
410         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
411         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
412         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
413         Transfer(0, _owner, _amount);
414         return true;
415     }
416 
417 
418     /// @notice Burns `_amount` tokens from `_owner`
419     /// @param _owner The address that will lose the tokens
420     /// @param _amount The quantity of tokens to burn
421     /// @return True if the tokens are burned correctly
422     function destroyTokens(address _owner, uint _amount
423     ) onlyController public returns (bool) {
424         uint curTotalSupply = totalSupply();
425         require(curTotalSupply >= _amount);
426         uint previousBalanceFrom = balanceOf(_owner);
427         require(previousBalanceFrom >= _amount);
428         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
429         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
430         Transfer(_owner, 0, _amount);
431         return true;
432     }
433 
434 ////////////////
435 // Enable tokens transfers
436 ////////////////
437 
438 
439     /// @notice Enables token holders to transfer their tokens freely if true
440     /// @param _transfersEnabled True if transfers are allowed in the clone
441     function enableTransfers(bool _transfersEnabled) public onlyController {
442         transfersEnabled = _transfersEnabled;
443     }
444 
445 ////////////////
446 // Internal helper functions to query and set a value in a snapshot array
447 ////////////////
448 
449     /// @dev `getValueAt` retrieves the number of tokens at a given block number
450     /// @param checkpoints The history of values being queried
451     /// @param _block The block number to retrieve the value at
452     /// @return The number of tokens being queried
453     function getValueAt(Checkpoint[] storage checkpoints, uint _block
454     ) constant internal returns (uint) {
455         if (checkpoints.length == 0) return 0;
456 
457         // Shortcut for the actual value
458         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
459             return checkpoints[checkpoints.length-1].value;
460         if (_block < checkpoints[0].fromBlock) return 0;
461 
462         // Binary search of the value in the array
463         uint min = 0;
464         uint max = checkpoints.length-1;
465         while (max > min) {
466             uint mid = (max + min + 1)/ 2;
467             if (checkpoints[mid].fromBlock<=_block) {
468                 min = mid;
469             } else {
470                 max = mid-1;
471             }
472         }
473         return checkpoints[min].value;
474     }
475 
476     /// @dev `updateValueAtNow` used to update the `balances` map and the
477     ///  `totalSupplyHistory`
478     /// @param checkpoints The history of data being updated
479     /// @param _value The new number of tokens
480     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
481     ) internal  {
482         if ((checkpoints.length == 0)
483         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
484                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
485                newCheckPoint.fromBlock =  uint128(block.number);
486                newCheckPoint.value = uint128(_value);
487            } else {
488                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
489                oldCheckPoint.value = uint128(_value);
490            }
491     }
492 
493     /// @dev Internal function to determine if an address is a contract
494     /// @param _addr The address being queried
495     /// @return True if `_addr` is a contract
496     function isContract(address _addr) constant internal returns(bool) {
497         uint size;
498         if (_addr == 0) return false;
499         assembly {
500             size := extcodesize(_addr)
501         }
502         return size>0;
503     }
504 
505     /// @dev Helper function to return a min betwen the two uints
506     function min(uint a, uint b) pure internal returns (uint) {
507         return a < b ? a : b;
508     }
509 
510     /// @notice The fallback function: If the contract's controller has not been
511     ///  set to 0, then the `proxyPayment` method is called which relays the
512     ///  ether and creates tokens as described in the token controller contract
513     function () public payable {
514         require(isContract(controller));
515         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
516     }
517 
518 //////////
519 // Safety Methods
520 //////////
521 
522     /// @notice This method can be used by the controller to extract mistakenly
523     ///  sent tokens to this contract.
524     /// @param _token The address of the token contract that you want to recover
525     ///  set to 0 in case you want to extract ether.
526     function claimTokens(address _token) public onlyController {
527         if (_token == 0x0) {
528             controller.transfer(this.balance);
529             return;
530         }
531 
532         MiniMeToken token = MiniMeToken(_token);
533         uint balance = token.balanceOf(this);
534         token.transfer(controller, balance);
535         ClaimedTokens(_token, controller, balance);
536     }
537 
538 ////////////////
539 // Events
540 ////////////////
541     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
542     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
543     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
544     event Approval(
545         address indexed _owner,
546         address indexed _spender,
547         uint256 _amount
548         );
549 
550 }
551 
552 contract MiniMeTokenFactory {
553 
554     /// @notice Update the DApp by creating a new token with new functionalities
555     ///  the msg.sender becomes the controller of this clone token
556     /// @param _parentToken Address of the token being cloned
557     /// @param _snapshotBlock Block of the parent token that will
558     ///  determine the initial distribution of the clone token
559     /// @param _tokenName Name of the new token
560     /// @param _decimalUnits Number of decimals of the new token
561     /// @param _tokenSymbol Token Symbol for the new token
562     /// @param _transfersEnabled If true, tokens will be able to be transferred
563     /// @return The address of the new token contract
564     function createCloneToken(
565         address _parentToken,
566         uint _snapshotBlock,
567         string _tokenName,
568         uint8 _decimalUnits,
569         string _tokenSymbol,
570         bool _transfersEnabled
571     ) public returns (MiniMeToken) {
572         MiniMeToken newToken = new MiniMeToken(
573             this,
574             _parentToken,
575             _snapshotBlock,
576             _tokenName,
577             _decimalUnits,
578             _tokenSymbol,
579             _transfersEnabled
580             );
581 
582         newToken.changeController(msg.sender);
583         return newToken;
584     }
585 }
586 
587 contract BIGER is MiniMeToken, Blocked {
588 
589   modifier onlyNotBlocked(address _addr) {
590     require(!blocked[_addr]);
591     _;
592   }
593 
594   function BIGER(address _tokenFactory) MiniMeToken(
595     _tokenFactory,
596     0x0,                  // no parent token
597     0,                    // no snapshot block number from parent
598     "BIGER",        // Token name
599     18,                   // Decimals
600     "BIGER",                // Symbol
601     true                 // Enable transfers
602   ) public {}
603 
604   /**
605    * @dev transfer BIGER token to `_to` with amount of `_amount`.
606    * Only not blocked user can transfer.
607    */
608   function transfer(address _to, uint256 _amount) public onlyNotBlocked(msg.sender) returns (bool success) {
609     return super.transfer(_to, _amount);
610   }
611 
612   function transferFrom(address _from, address _to, uint256 _amount) public onlyNotBlocked(_from) returns (bool success) {
613     return super.transferFrom(_from, _to, _amount);
614   }
615 
616   function generateTokens(address _owner, uint _amount) public onlyController  returns (bool) {
617     return super.generateTokens(_owner, _amount);
618   }
619 
620   function destroyTokens(address _owner, uint _amount) public onlyController  returns (bool) {
621     return super.destroyTokens(_owner, _amount);
622   }
623 
624   function blockAddress(address _addr) public onlyController  {
625     super.blockAddress(_addr);
626   }
627 
628   function unblockAddress(address _addr) public onlyController  {
629     super.unblockAddress(_addr);
630   }
631 
632   function enableTransfers(bool _transfersEnabled) public onlyController {
633     super.enableTransfers(_transfersEnabled);
634   }
635 
636   // byList functions
637 
638   function generateTokensByList(address[] _owners, uint[] _amounts) public onlyController  returns (bool) {
639     require(_owners.length == _amounts.length);
640 
641     for(uint i = 0; i < _owners.length; ++i) {
642       generateTokens(_owners[i], _amounts[i]);
643     }
644 
645     return true;
646   }
647 }