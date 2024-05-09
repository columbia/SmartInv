1 pragma solidity ^0.4.18;
2 
3 /*
4     Copyright 2017, Debdoot Das (IDIOT IQ)
5     Copyright 2017, Jordi Baylina (Giveth)
6 
7     Based on MineMeToken.sol from https://github.com/Giveth/minime
8  */
9 
10 
11 contract Controlled {
12     /// @notice The address of the controller is the only address that can call
13     ///  a function with this modifier
14     modifier onlyController { require(msg.sender == controller); _; }
15 
16     address public controller;
17 
18     function Controlled() public { controller = msg.sender;}
19 
20     /// @notice Changes the controller of the contract
21     /// @param _newController The new controller of the contract
22     function changeController(address _newController) public onlyController {
23         controller = _newController;
24     }
25 }
26 
27 // @dev The token controller contract must implement these functions
28 contract TokenController {
29     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
30     /// @param _owner The address that sent the ether to create tokens
31     /// @return True if the ether is accepted, false if it throws
32     function proxyPayment(address _owner) public payable returns(bool);
33 
34     /// @notice Notifies the controller about a token transfer allowing the
35     ///  controller to react if desired
36     /// @param _from The origin of the transfer
37     /// @param _to The destination of the transfer
38     /// @param _amount The amount of the transfer
39     /// @return False if the controller does not authorize the transfer
40     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
41 
42     /// @notice Notifies the controller about an approval allowing the
43     ///  controller to react if desired
44     /// @param _owner The address that calls `approve()`
45     /// @param _spender The spender in the `approve()` call
46     /// @param _amount The amount in the `approve()` call
47     /// @return False if the controller does not authorize the approval
48     function onApprove(address _owner, address _spender, uint _amount) public
49         returns(bool);
50 }
51 
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
54 }
55 
56 /// @dev The actual token contract, the default controller is the msg.sender
57 ///  that deploys the contract, so usually this token will be deployed by a
58 ///  token controller contract, which Giveth will call a "Campaign"
59 contract DOTSToken is Controlled {
60 
61     string public name;                //The Token's name: e.g. DigixDAO Tokens
62     uint8 public decimals;             //Number of decimals of the smallest unit
63     string public symbol;              //An identifier: e.g. REP
64     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
65 
66 
67     /// @dev `Checkpoint` is the structure that attaches a block number to a
68     ///  given value, the block number attached is the one that last changed the
69     ///  value
70     struct  Checkpoint {
71 
72         // `fromBlock` is the block number that the value was generated from
73         uint128 fromBlock;
74 
75         // `value` is the amount of tokens at a specific block number
76         uint128 value;
77     }
78 
79     // `parentToken` is the Token address that was cloned to produce this token;
80     //  it will be 0x0 for a token that was not cloned
81     DOTSToken public parentToken;
82 
83     // `parentSnapShotBlock` is the block number from the Parent Token that was
84     //  used to determine the initial distribution of the Clone Token
85     uint public parentSnapShotBlock;
86 
87     // `creationBlock` is the block number that the Clone Token was created
88     uint public creationBlock;
89 
90     // `balances` is the map that tracks the balance of each address, in this
91     //  contract when the balance changes the block number that the change
92     //  occurred is also included in the map
93     mapping (address => Checkpoint[]) balances;
94 
95     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
96     mapping (address => mapping (address => uint256)) allowed;
97 
98     // Tracks the history of the `totalSupply` of the token
99     Checkpoint[] totalSupplyHistory;
100 
101     // Flag that determines if the token is transferable or not.
102     bool public transfersEnabled;
103 
104     // The factory used to create new clone tokens
105     DOTSTokenFactory public tokenFactory;
106 
107 ////////////////
108 // Constructor
109 ////////////////
110 
111     /// @notice Constructor to create a DOTSToken
112     /// @param _tokenFactory The address of the DOTSTokenFactory contract that
113     ///  will create the Clone token contracts, the token factory needs to be
114     ///  deployed first
115     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
116     ///  new token
117     /// @param _parentSnapShotBlock Block of the parent token that will
118     ///  determine the initial distribution of the clone token, set to 0 if it
119     ///  is a new token
120     /// @param _tokenName Name of the new token
121     /// @param _decimalUnits Number of decimals of the new token
122     /// @param _tokenSymbol Token Symbol for the new token
123     /// @param _transfersEnabled If true, tokens will be able to be transferred
124     function DOTSToken(
125         address _tokenFactory,
126         address _parentToken,
127         uint _parentSnapShotBlock,
128         string _tokenName,
129         uint8 _decimalUnits,
130         string _tokenSymbol,
131         bool _transfersEnabled
132     ) public {
133         tokenFactory = DOTSTokenFactory(_tokenFactory);
134         name = _tokenName;                                 // Set the name
135         decimals = _decimalUnits;                          // Set the decimals
136         symbol = _tokenSymbol;                             // Set the symbol
137         parentToken = DOTSToken(_parentToken);
138         parentSnapShotBlock = _parentSnapShotBlock;
139         transfersEnabled = _transfersEnabled;
140         creationBlock = block.number;
141     }
142 
143 
144 ///////////////////
145 // ERC20 Methods
146 ///////////////////
147 
148     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
149     /// @param _to The address of the recipient
150     /// @param _amount The amount of tokens to be transferred
151     /// @return Whether the transfer was successful or not
152     function transfer(address _to, uint256 _amount) public returns (bool success) {
153         require(transfersEnabled);
154         return doTransfer(msg.sender, _to, _amount);
155     }
156 
157     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
158     ///  is approved by `_from`
159     /// @param _from The address holding the tokens being transferred
160     /// @param _to The address of the recipient
161     /// @param _amount The amount of tokens to be transferred
162     /// @return True if the transfer was successful
163     function transferFrom(address _from, address _to, uint256 _amount
164     ) public returns (bool success) {
165 
166         // The controller of this contract can move tokens around at will,
167         //  this is important to recognize! Confirm that you trust the
168         //  controller of this contract, which in most situations should be
169         //  another open source smart contract or 0x0
170         if (msg.sender != controller) {
171             require(transfersEnabled);
172 
173             // The standard ERC 20 transferFrom functionality
174             if (allowed[_from][msg.sender] < _amount) return false;
175             allowed[_from][msg.sender] -= _amount;
176         }
177         return doTransfer(_from, _to, _amount);
178     }
179 
180     /// @dev This is the actual transfer function in the token contract, it can
181     ///  only be called by other functions in this contract.
182     /// @param _from The address holding the tokens being transferred
183     /// @param _to The address of the recipient
184     /// @param _amount The amount of tokens to be transferred
185     /// @return True if the transfer was successful
186     function doTransfer(address _from, address _to, uint _amount
187     ) internal returns(bool) {
188 
189            if (_amount == 0) {
190                return true;
191            }
192 
193            require(parentSnapShotBlock < block.number);
194 
195            // Do not allow transfer to 0x0 or the token contract itself
196            require((_to != 0) && (_to != address(this)));
197 
198            // If the amount being transfered is more than the balance of the
199            //  account the transfer returns false
200            var previousBalanceFrom = balanceOfAt(_from, block.number);
201            if (previousBalanceFrom < _amount) {
202                return false;
203            }
204 
205            // Alerts the token controller of the transfer
206            if (isContract(controller)) {
207                require(TokenController(controller).onTransfer(_from, _to, _amount));
208            }
209 
210            // First update the balance array with the new value for the address
211            //  sending the tokens
212            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
213 
214            // Then update the balance array with the new value for the address
215            //  receiving the tokens
216            var previousBalanceTo = balanceOfAt(_to, block.number);
217            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
218            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
219 
220            // An event to make the transfer easy to find on the blockchain
221            Transfer(_from, _to, _amount);
222 
223            return true;
224     }
225 
226     /// @param _owner The address that's balance is being requested
227     /// @return The balance of `_owner` at the current block
228     function balanceOf(address _owner) public constant returns (uint256 balance) {
229         return balanceOfAt(_owner, block.number);
230     }
231 
232     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
233     ///  its behalf. This is a modified version of the ERC20 approve function
234     ///  to be a little bit safer
235     /// @param _spender The address of the account able to transfer the tokens
236     /// @param _amount The amount of tokens to be approved for transfer
237     /// @return True if the approval was successful
238     function approve(address _spender, uint256 _amount) public returns (bool success) {
239         require(transfersEnabled);
240 
241         // To change the approve amount you first have to reduce the addresses`
242         //  allowance to zero by calling `approve(_spender,0)` if it is not
243         //  already 0 to mitigate the race condition described here:
244         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
246 
247         // Alerts the token controller of the approve function call
248         if (isContract(controller)) {
249             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
250         }
251 
252         allowed[msg.sender][_spender] = _amount;
253         Approval(msg.sender, _spender, _amount);
254         return true;
255     }
256 
257     /// @dev This function makes it easy to read the `allowed[]` map
258     /// @param _owner The address of the account that owns the token
259     /// @param _spender The address of the account able to transfer the tokens
260     /// @return Amount of remaining tokens of _owner that _spender is allowed
261     ///  to spend
262     function allowance(address _owner, address _spender
263     ) public constant returns (uint256 remaining) {
264         return allowed[_owner][_spender];
265     }
266 
267     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
268     ///  its behalf, and then a function is triggered in the contract that is
269     ///  being approved, `_spender`. This allows users to use their tokens to
270     ///  interact with contracts in one function call instead of two
271     /// @param _spender The address of the contract able to transfer the tokens
272     /// @param _amount The amount of tokens to be approved for transfer
273     /// @return True if the function call was successful
274     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
275     ) public returns (bool success) {
276         require(approve(_spender, _amount));
277 
278         ApproveAndCallFallBack(_spender).receiveApproval(
279             msg.sender,
280             _amount,
281             this,
282             _extraData
283         );
284 
285         return true;
286     }
287 
288     /// @dev This function makes it easy to get the total number of tokens
289     /// @return The total number of tokens
290     function totalSupply() public constant returns (uint) {
291         return totalSupplyAt(block.number);
292     }
293 
294 
295 ////////////////
296 // Query balance and totalSupply in History
297 ////////////////
298 
299     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
300     /// @param _owner The address from which the balance will be retrieved
301     /// @param _blockNumber The block number when the balance is queried
302     /// @return The balance at `_blockNumber`
303     function balanceOfAt(address _owner, uint _blockNumber) public constant
304         returns (uint) {
305 
306         // These next few lines are used when the balance of the token is
307         //  requested before a check point was ever created for this token, it
308         //  requires that the `parentToken.balanceOfAt` be queried at the
309         //  genesis block for that token as this contains initial balance of
310         //  this token
311         if ((balances[_owner].length == 0)
312             || (balances[_owner][0].fromBlock > _blockNumber)) {
313             if (address(parentToken) != 0) {
314                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
315             } else {
316                 // Has no parent
317                 return 0;
318             }
319 
320         // This will return the expected balance during normal situations
321         } else {
322             return getValueAt(balances[_owner], _blockNumber);
323         }
324     }
325 
326     /// @notice Total amount of tokens at a specific `_blockNumber`.
327     /// @param _blockNumber The block number when the totalSupply is queried
328     /// @return The total amount of tokens at `_blockNumber`
329     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
330 
331         // These next few lines are used when the totalSupply of the token is
332         //  requested before a check point was ever created for this token, it
333         //  requires that the `parentToken.totalSupplyAt` be queried at the
334         //  genesis block for this token as that contains totalSupply of this
335         //  token at this block number.
336         if ((totalSupplyHistory.length == 0)
337             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
338             if (address(parentToken) != 0) {
339                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
340             } else {
341                 return 0;
342             }
343 
344         // This will return the expected totalSupply during normal situations
345         } else {
346             return getValueAt(totalSupplyHistory, _blockNumber);
347         }
348     }
349 
350 ////////////////
351 // Clone Token Method
352 ////////////////
353 
354     /// @notice Creates a new clone token with the initial distribution being
355     ///  this token at `_snapshotBlock`
356     /// @param _cloneTokenName Name of the clone token
357     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
358     /// @param _cloneTokenSymbol Symbol of the clone token
359     /// @param _snapshotBlock Block when the distribution of the parent token is
360     ///  copied to set the initial distribution of the new clone token;
361     ///  if the block is zero than the actual block, the current block is used
362     /// @param _transfersEnabled True if transfers are allowed in the clone
363     /// @return The address of the new DOTSToken Contract
364     function createCloneToken(
365         string _cloneTokenName,
366         uint8 _cloneDecimalUnits,
367         string _cloneTokenSymbol,
368         uint _snapshotBlock,
369         bool _transfersEnabled
370         ) public returns(address) {
371         if (_snapshotBlock == 0) _snapshotBlock = block.number;
372         DOTSToken cloneToken = tokenFactory.createCloneToken(
373             this,
374             _snapshotBlock,
375             _cloneTokenName,
376             _cloneDecimalUnits,
377             _cloneTokenSymbol,
378             _transfersEnabled
379             );
380 
381         cloneToken.changeController(msg.sender);
382 
383         // An event to make the token easy to find on the blockchain
384         NewCloneToken(address(cloneToken), _snapshotBlock);
385         return address(cloneToken);
386     }
387 
388 ////////////////
389 // Generate and destroy tokens
390 ////////////////
391 
392     /// @notice Generates `_amount` tokens that are assigned to `_owner`
393     /// @param _owner The address that will be assigned the new tokens
394     /// @param _amount The quantity of tokens generated
395     /// @return True if the tokens are generated correctly
396     function generateTokens(address _owner, uint _amount
397     ) public onlyController returns (bool) {
398         uint curTotalSupply = totalSupply();
399         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
400         uint previousBalanceTo = balanceOf(_owner);
401         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
402         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
403         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
404         Transfer(0, _owner, _amount);
405         return true;
406     }
407 
408 
409     /// @notice Burns `_amount` tokens from `_owner`
410     /// @param _owner The address that will lose the tokens
411     /// @param _amount The quantity of tokens to burn
412     /// @return True if the tokens are burned correctly
413     function destroyTokens(address _owner, uint _amount
414     ) onlyController public returns (bool) {
415         uint curTotalSupply = totalSupply();
416         require(curTotalSupply >= _amount);
417         uint previousBalanceFrom = balanceOf(_owner);
418         require(previousBalanceFrom >= _amount);
419         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
420         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
421         Transfer(_owner, 0, _amount);
422         return true;
423     }
424 
425 ////////////////
426 // Enable tokens transfers
427 ////////////////
428 
429 
430     /// @notice Enables token holders to transfer their tokens freely if true
431     /// @param _transfersEnabled True if transfers are allowed in the clone
432     function enableTransfers(bool _transfersEnabled) public onlyController {
433         transfersEnabled = _transfersEnabled;
434     }
435 
436 ////////////////
437 // Internal helper functions to query and set a value in a snapshot array
438 ////////////////
439 
440     /// @dev `getValueAt` retrieves the number of tokens at a given block number
441     /// @param checkpoints The history of values being queried
442     /// @param _block The block number to retrieve the value at
443     /// @return The number of tokens being queried
444     function getValueAt(Checkpoint[] storage checkpoints, uint _block
445     ) constant internal returns (uint) {
446         if (checkpoints.length == 0) return 0;
447 
448         // Shortcut for the actual value
449         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
450             return checkpoints[checkpoints.length-1].value;
451         if (_block < checkpoints[0].fromBlock) return 0;
452 
453         // Binary search of the value in the array
454         uint min = 0;
455         uint max = checkpoints.length-1;
456         while (max > min) {
457             uint mid = (max + min + 1)/ 2;
458             if (checkpoints[mid].fromBlock<=_block) {
459                 min = mid;
460             } else {
461                 max = mid-1;
462             }
463         }
464         return checkpoints[min].value;
465     }
466 
467     /// @dev `updateValueAtNow` used to update the `balances` map and the
468     ///  `totalSupplyHistory`
469     /// @param checkpoints The history of data being updated
470     /// @param _value The new number of tokens
471     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
472     ) internal  {
473         if ((checkpoints.length == 0)
474         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
475                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
476                newCheckPoint.fromBlock =  uint128(block.number);
477                newCheckPoint.value = uint128(_value);
478            } else {
479                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
480                oldCheckPoint.value = uint128(_value);
481            }
482     }
483 
484     /// @dev Internal function to determine if an address is a contract
485     /// @param _addr The address being queried
486     /// @return True if `_addr` is a contract
487     function isContract(address _addr) constant internal returns(bool) {
488         uint size;
489         if (_addr == 0) return false;
490         assembly {
491             size := extcodesize(_addr)
492         }
493         return size>0;
494     }
495 
496     /// @dev Helper function to return a min betwen the two uints
497     function min(uint a, uint b) pure internal returns (uint) {
498         return a < b ? a : b;
499     }
500 
501     /// @notice The fallback function: If the contract's controller has not been
502     ///  set to 0, then the `proxyPayment` method is called which relays the
503     ///  ether and creates tokens as described in the token controller contract
504     function () public payable {
505         require(isContract(controller));
506         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
507     }
508 
509 //////////
510 // Safety Methods
511 //////////
512 
513     /// @notice This method can be used by the controller to extract mistakenly
514     ///  sent tokens to this contract.
515     /// @param _token The address of the token contract that you want to recover
516     ///  set to 0 in case you want to extract ether.
517     function claimTokens(address _token) public onlyController {
518         if (_token == 0x0) {
519             controller.transfer(this.balance);
520             return;
521         }
522 
523         DOTSToken token = DOTSToken(_token);
524         uint balance = token.balanceOf(this);
525         token.transfer(controller, balance);
526         ClaimedTokens(_token, controller, balance);
527     }
528 
529 ////////////////
530 // Events
531 ////////////////
532     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
533     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
534     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
535     event Approval(
536         address indexed _owner,
537         address indexed _spender,
538         uint256 _amount
539         );
540 
541 }
542 
543 
544 ////////////////
545 // DOTSTokenFactory
546 ////////////////
547 
548 /// @dev This contract is used to generate clone contracts from a contract.
549 ///  In solidity this is the way to create a contract from a contract of the
550 ///  same class
551 contract DOTSTokenFactory {
552 
553     /// @notice Update the DApp by creating a new token with new functionalities
554     ///  the msg.sender becomes the controller of this clone token
555     /// @param _parentToken Address of the token being cloned
556     /// @param _snapshotBlock Block of the parent token that will
557     ///  determine the initial distribution of the clone token
558     /// @param _tokenName Name of the new token
559     /// @param _decimalUnits Number of decimals of the new token
560     /// @param _tokenSymbol Token Symbol for the new token
561     /// @param _transfersEnabled If true, tokens will be able to be transferred
562     /// @return The address of the new token contract
563     function createCloneToken(
564         address _parentToken,
565         uint _snapshotBlock,
566         string _tokenName,
567         uint8 _decimalUnits,
568         string _tokenSymbol,
569         bool _transfersEnabled
570     ) public returns (DOTSToken) {
571         DOTSToken newToken = new DOTSToken(
572             this,
573             _parentToken,
574             _snapshotBlock,
575             _tokenName,
576             _decimalUnits,
577             _tokenSymbol,
578             _transfersEnabled
579             );
580 
581         newToken.changeController(msg.sender);
582         return newToken;
583     }
584 }
585 
586 
587 contract DOTS is DOTSToken {
588   // @dev DOTS constructor just parametrizes the DOTSToken constructor
589   function DOTS(
590   ) DOTSToken(
591     0xd010cfdf53b23b27fe80ea418843b428c4c3526e, // address of tokenfactory
592     0x0,                    // no parent token
593     0,                      // no snapshot block number from parent
594     "DOTS",                 // Token name
595     18,                     // Decimals
596     "DOT$",                 // Symbol
597     true                    // Enable transfers
598     ) public {}
599 }