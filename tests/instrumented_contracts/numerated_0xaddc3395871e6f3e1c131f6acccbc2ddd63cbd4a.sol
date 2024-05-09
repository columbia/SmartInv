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
11 /// @dev The token controller contract must implement these functions
12 contract TokenController {
13     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
14     /// @param _owner The address that sent the ether to create tokens
15     /// @return True if the ether is accepted, false if it throws
16     function proxyPayment(address _owner) payable returns(bool);
17 
18     /// @notice Notifies the controller about a token transfer allowing the
19     ///  controller to react if desired
20     /// @param _from The origin of the transfer
21     /// @param _to The destination of the transfer
22     /// @param _amount The amount of the transfer
23     /// @return False if the controller does not authorize the transfer
24     function onTransfer(address _from, address _to, uint _amount) returns(bool);
25 
26     /// @notice Notifies the controller about an approval allowing the
27     ///  controller to react if desired
28     /// @param _owner The address that calls `approve()`
29     /// @param _spender The spender in the `approve()` call
30     /// @param _amount The amount in the `approve()` call
31     /// @return False if the controller does not authorize the approval
32     function onApprove(address _owner, address _spender, uint _amount)
33         returns(bool);
34 }
35 
36 contract Controlled {
37     /// @notice The address of the controller is the only address that can call
38     ///  a function with this modifier
39     modifier onlyController { require(msg.sender == controller); _; }
40 
41     address public controller;
42 
43     function Controlled() { controller = msg.sender;}
44 
45     /// @notice Changes the controller of the contract
46     /// @param _newController The new controller of the contract
47     function changeController(address _newController) onlyController {
48         controller = _newController;
49     }
50 }
51 
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
54 }
55 
56 /// @dev The actual token contract, the default controller is the msg.sender
57 ///  that deploys the contract, so usually this token will be deployed by a
58 ///  token controller contract, which Giveth will call a "Campaign"
59 contract MisToken is Controlled {
60 
61     string public name;                //The Token's name: e.g. DigixDAO Tokens
62     uint8 public decimals;             //Number of decimals of the smallest unit
63     string public symbol;              //An identifier: e.g. REP
64     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
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
81     MisToken public parentToken;
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
105     MisTokenFactory public tokenFactory;
106 
107 ////////////////
108 // Constructor
109 ////////////////
110 
111     /// @notice Constructor to create a MisToken
112     /// @param _tokenFactory The address of the MisTokenFactory contract that
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
124     function MisToken(
125         address _tokenFactory,
126         address _parentToken,
127         uint _parentSnapShotBlock,
128         string _tokenName,
129         uint8 _decimalUnits,
130         string _tokenSymbol,
131         bool _transfersEnabled
132     ) {
133         tokenFactory = MisTokenFactory(_tokenFactory);
134         name = _tokenName;                                 // Set the name
135         decimals = _decimalUnits;                          // Set the decimals
136         symbol = _tokenSymbol;                             // Set the symbol
137         parentToken = MisToken(_parentToken);
138         parentSnapShotBlock = _parentSnapShotBlock;
139         transfersEnabled = _transfersEnabled;
140         creationBlock = block.number;
141     }
142     
143     
144  
145 
146 
147 ///////////////////
148 // ERC20 Methods
149 ///////////////////
150 
151     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
152     /// @param _to The address of the recipient
153     /// @param _amount The amount of tokens to be transferred
154     /// @return Whether the transfer was successful or not
155     function transfer(address _to, uint256 _amount) returns (bool success) {
156         require(transfersEnabled);
157         return doTransfer(msg.sender, _to, _amount);
158     }
159 
160     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
161     ///  is approved by `_from`
162     /// @param _from The address holding the tokens being transferred
163     /// @param _to The address of the recipient
164     /// @param _amount The amount of tokens to be transferred
165     /// @return True if the transfer was successful
166     function transferFrom(address _from, address _to, uint256 _amount
167     ) returns (bool success) {
168 
169         // The controller of this contract can move tokens around at will,
170         //  this is important to recognize! Confirm that you trust the
171         //  controller of this contract, which in most situations should be
172         //  another open source smart contract or 0x0
173         if (msg.sender != controller) {
174             require(transfersEnabled);
175 
176             // The standard ERC 20 transferFrom functionality
177             if (allowed[_from][msg.sender] < _amount) return false;
178             allowed[_from][msg.sender] -= _amount;
179         }
180         return doTransfer(_from, _to, _amount);
181     }
182 
183     /// @dev This is the actual transfer function in the token contract, it can
184     ///  only be called by other functions in this contract.
185     /// @param _from The address holding the tokens being transferred
186     /// @param _to The address of the recipient
187     /// @param _amount The amount of tokens to be transferred
188     /// @return True if the transfer was successful
189     function doTransfer(address _from, address _to, uint _amount
190     ) internal returns(bool) {
191 
192            if (_amount == 0) {
193                return true;
194            }
195 
196            require(parentSnapShotBlock < block.number);
197 
198            // Do not allow transfer to 0x0 or the token contract itself
199            require((_to != 0) && (_to != address(this)));
200 
201            // If the amount being transfered is more than the balance of the
202            //  account the transfer returns false
203            var previousBalanceFrom = balanceOfAt(_from, block.number);
204            if (previousBalanceFrom < _amount) {
205                return false;
206            }
207 
208            // Alerts the token controller of the transfer
209            if (isContract(controller)) {
210                require(TokenController(controller).onTransfer(_from, _to, _amount));
211            }
212 
213            // First update the balance array with the new value for the address
214            //  sending the tokens
215            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
216 
217            // Then update the balance array with the new value for the address
218            //  receiving the tokens
219            var previousBalanceTo = balanceOfAt(_to, block.number);
220            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
221            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
222 
223            // An event to make the transfer easy to find on the blockchain
224            Transfer(_from, _to, _amount);
225 
226            return true;
227     }
228 
229     /// @param _owner The address that's balance is being requested
230     /// @return The balance of `_owner` at the current block
231     function balanceOf(address _owner) constant returns (uint256 balance) {
232         return balanceOfAt(_owner, block.number);
233     }
234 
235     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
236     ///  its behalf. This is a modified version of the ERC20 approve function
237     ///  to be a little bit safer
238     /// @param _spender The address of the account able to transfer the tokens
239     /// @param _amount The amount of tokens to be approved for transfer
240     /// @return True if the approval was successful
241     function approve(address _spender, uint256 _amount) returns (bool success) {
242         require(transfersEnabled);
243 
244         // To change the approve amount you first have to reduce the addresses`
245         //  allowance to zero by calling `approve(_spender,0)` if it is not
246         //  already 0 to mitigate the race condition described here:
247         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
249 
250         // Alerts the token controller of the approve function call
251         if (isContract(controller)) {
252             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
253         }
254 
255         allowed[msg.sender][_spender] = _amount;
256         Approval(msg.sender, _spender, _amount);
257         return true;
258     }
259 
260     /// @dev This function makes it easy to read the `allowed[]` map
261     /// @param _owner The address of the account that owns the token
262     /// @param _spender The address of the account able to transfer the tokens
263     /// @return Amount of remaining tokens of _owner that _spender is allowed
264     ///  to spend
265     function allowance(address _owner, address _spender
266     ) constant returns (uint256 remaining) {
267         return allowed[_owner][_spender];
268     }
269 
270     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
271     ///  its behalf, and then a function is triggered in the contract that is
272     ///  being approved, `_spender`. This allows users to use their tokens to
273     ///  interact with contracts in one function call instead of two
274     /// @param _spender The address of the contract able to transfer the tokens
275     /// @param _amount The amount of tokens to be approved for transfer
276     /// @return True if the function call was successful
277     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
278     ) returns (bool success) {
279         require(approve(_spender, _amount));
280 
281         ApproveAndCallFallBack(_spender).receiveApproval(
282             msg.sender,
283             _amount,
284             this,
285             _extraData
286         );
287 
288         return true;
289     }
290 
291     /// @dev This function makes it easy to get the total number of tokens
292     /// @return The total number of tokens
293     function totalSupply() constant returns (uint) {
294         return totalSupplyAt(block.number);
295     }
296 
297 
298 ////////////////
299 // Query balance and totalSupply in History
300 ////////////////
301 
302     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
303     /// @param _owner The address from which the balance will be retrieved
304     /// @param _blockNumber The block number when the balance is queried
305     /// @return The balance at `_blockNumber`
306     function balanceOfAt(address _owner, uint _blockNumber) constant
307         returns (uint) {
308 
309         // These next few lines are used when the balance of the token is
310         //  requested before a check point was ever created for this token, it
311         //  requires that the `parentToken.balanceOfAt` be queried at the
312         //  genesis block for that token as this contains initial balance of
313         //  this token
314         if ((balances[_owner].length == 0)
315             || (balances[_owner][0].fromBlock > _blockNumber)) {
316             if (address(parentToken) != 0) {
317                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
318             } else {
319                 // Has no parent
320                 return 0;
321             }
322 
323         // This will return the expected balance during normal situations
324         } else {
325             return getValueAt(balances[_owner], _blockNumber);
326         }
327     }
328 
329     /// @notice Total amount of tokens at a specific `_blockNumber`.
330     /// @param _blockNumber The block number when the totalSupply is queried
331     /// @return The total amount of tokens at `_blockNumber`
332     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
333 
334         // These next few lines are used when the totalSupply of the token is
335         //  requested before a check point was ever created for this token, it
336         //  requires that the `parentToken.totalSupplyAt` be queried at the
337         //  genesis block for this token as that contains totalSupply of this
338         //  token at this block number.
339         if ((totalSupplyHistory.length == 0)
340             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
341             if (address(parentToken) != 0) {
342                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
343             } else {
344                 return 0;
345             }
346 
347         // This will return the expected totalSupply during normal situations
348         } else {
349             return getValueAt(totalSupplyHistory, _blockNumber);
350         }
351     }
352 
353 ////////////////
354 // Clone Token Method
355 ////////////////
356 
357     /// @notice Creates a new clone token with the initial distribution being
358     ///  this token at `_snapshotBlock`
359     /// @param _cloneTokenName Name of the clone token
360     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
361     /// @param _cloneTokenSymbol Symbol of the clone token
362     /// @param _snapshotBlock Block when the distribution of the parent token is
363     ///  copied to set the initial distribution of the new clone token;
364     ///  if the block is zero than the actual block, the current block is used
365     /// @param _transfersEnabled True if transfers are allowed in the clone
366     /// @return The address of the new MisToken Contract
367     function createCloneToken(
368         string _cloneTokenName,
369         uint8 _cloneDecimalUnits,
370         string _cloneTokenSymbol,
371         uint _snapshotBlock,
372         bool _transfersEnabled
373         ) returns(address) {
374         if (_snapshotBlock == 0) _snapshotBlock = block.number;
375         MisToken cloneToken = tokenFactory.createCloneToken(
376             this,
377             _snapshotBlock,
378             _cloneTokenName,
379             _cloneDecimalUnits,
380             _cloneTokenSymbol,
381             _transfersEnabled
382             );
383 
384         cloneToken.changeController(msg.sender);
385 
386         // An event to make the token easy to find on the blockchain
387         NewCloneToken(address(cloneToken), _snapshotBlock);
388         return address(cloneToken);
389     }
390 
391 ////////////////
392 // Generate and destroy tokens
393 ////////////////
394 
395     /// @notice Generates `_amount` tokens that are assigned to `_owner`
396     /// @param _owner The address that will be assigned the new tokens
397     /// @param _amount The quantity of tokens generated
398     /// @return True if the tokens are generated correctly
399     function generateTokens(address _owner, uint _amount
400     ) onlyController returns (bool) {
401         uint curTotalSupply = totalSupply();
402         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
403         uint previousBalanceTo = balanceOf(_owner);
404         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
405         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
406         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
407         Transfer(0, _owner, _amount);
408         return true;
409     }
410 
411 
412     /// @notice Burns `_amount` tokens from `_owner`
413     /// @param _owner The address that will lose the tokens
414     /// @param _amount The quantity of tokens to burn
415     /// @return True if the tokens are burned correctly
416     function destroyTokens(address _owner, uint _amount
417     ) onlyController returns (bool) {
418         uint curTotalSupply = totalSupply();
419         require(curTotalSupply >= _amount);
420         uint previousBalanceFrom = balanceOf(_owner);
421         require(previousBalanceFrom >= _amount);
422         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
423         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
424         Transfer(_owner, 0, _amount);
425         return true;
426     }
427 
428 ////////////////
429 // Enable tokens transfers
430 ////////////////
431 
432 
433     /// @notice Enables token holders to transfer their tokens freely if true
434     /// @param _transfersEnabled True if transfers are allowed in the clone
435     function enableTransfers(bool _transfersEnabled) onlyController {
436         transfersEnabled = _transfersEnabled;
437     }
438 
439 ////////////////
440 // Internal helper functions to query and set a value in a snapshot array
441 ////////////////
442 
443     /// @dev `getValueAt` retrieves the number of tokens at a given block number
444     /// @param checkpoints The history of values being queried
445     /// @param _block The block number to retrieve the value at
446     /// @return The number of tokens being queried
447     function getValueAt(Checkpoint[] storage checkpoints, uint _block
448     ) constant internal returns (uint) {
449         if (checkpoints.length == 0) return 0;
450 
451         // Shortcut for the actual value
452         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
453             return checkpoints[checkpoints.length-1].value;
454         if (_block < checkpoints[0].fromBlock) return 0;
455 
456         // Binary search of the value in the array
457         uint min = 0;
458         uint max = checkpoints.length-1;
459         while (max > min) {
460             uint mid = (max + min + 1)/ 2;
461             if (checkpoints[mid].fromBlock<=_block) {
462                 min = mid;
463             } else {
464                 max = mid-1;
465             }
466         }
467         return checkpoints[min].value;
468     }
469 
470     /// @dev `updateValueAtNow` used to update the `balances` map and the
471     ///  `totalSupplyHistory`
472     /// @param checkpoints The history of data being updated
473     /// @param _value The new number of tokens
474     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
475     ) internal  {
476         if ((checkpoints.length == 0)
477         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
478                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
479                newCheckPoint.fromBlock =  uint128(block.number);
480                newCheckPoint.value = uint128(_value);
481            } else {
482                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
483                oldCheckPoint.value = uint128(_value);
484            }
485     }
486 
487     /// @dev Internal function to determine if an address is a contract
488     /// @param _addr The address being queried
489     /// @return True if `_addr` is a contract
490     function isContract(address _addr) constant internal returns(bool) {
491         uint size;
492         if (_addr == 0) return false;
493         assembly {
494             size := extcodesize(_addr)
495         }
496         return size>0;
497     }
498 
499     /// @dev Helper function to return a min betwen the two uints
500     function min(uint a, uint b) internal returns (uint) {
501         return a < b ? a : b;
502     }
503 
504     /// @notice The fallback function: If the contract's controller has not been
505     ///  set to 0, then the `proxyPayment` method is called which relays the
506     ///  ether and creates tokens as described in the token controller contract
507     function ()  payable {
508         require(isContract(controller));
509         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
510     }
511 
512 //////////
513 // Safety Methods
514 //////////
515 
516     /// @notice This method can be used by the controller to extract mistakenly
517     ///  sent tokens to this contract.
518     /// @param _token The address of the token contract that you want to recover
519     ///  set to 0 in case you want to extract ether.
520     function claimTokens(address _token) onlyController {
521         if (_token == 0x0) {
522             controller.transfer(this.balance);
523             return;
524         }
525 
526         MisToken token = MisToken(_token);
527         uint balance = token.balanceOf(this);
528         token.transfer(controller, balance);
529         ClaimedTokens(_token, controller, balance);
530     }
531 
532 ////////////////
533 // Events
534 ////////////////
535     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
536     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
537     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
538     event Approval(
539         address indexed _owner,
540         address indexed _spender,
541         uint256 _amount
542         );
543 
544 }
545 
546 
547 ////////////////
548 // MisTokenFactory
549 ////////////////
550 
551 /// @dev This contract is used to generate clone contracts from a contract.
552 ///  In solidity this is the way to create a contract from a contract of the
553 ///  same class
554 contract MisTokenFactory {
555 
556     /// @notice Update the DApp by creating a new token with new functionalities
557     ///  the msg.sender becomes the controller of this clone token
558     /// @param _parentToken Address of the token being cloned
559     /// @param _snapshotBlock Block of the parent token that will
560     ///  determine the initial distribution of the clone token
561     /// @param _tokenName Name of the new token
562     /// @param _decimalUnits Number of decimals of the new token
563     /// @param _tokenSymbol Token Symbol for the new token
564     /// @param _transfersEnabled If true, tokens will be able to be transferred
565     /// @return The address of the new token contract
566     function createCloneToken(
567         address _parentToken,
568         uint _snapshotBlock,
569         string _tokenName,
570         uint8 _decimalUnits,
571         string _tokenSymbol,
572         bool _transfersEnabled
573     ) returns (MisToken) {
574         MisToken newToken = new MisToken(
575             this,
576             _parentToken,
577             _snapshotBlock,
578             _tokenName,
579             _decimalUnits,
580             _tokenSymbol,
581             _transfersEnabled
582             );
583 
584         newToken.changeController(msg.sender);
585         return newToken;
586     }
587 }
588 
589    contract MISTOKEN is MisToken {
590   // @dev MISTOKEN constructor just parametrizes the MisToken constructor
591   function MISTOKEN(
592   ) MisToken(
593     0x693a9cFbACe1B67558E78ce2D081965193002223,  // address of tokenfactory
594     0x0,                    // no parent token
595     0,                      // no snapshot block number from parent
596     "MISTOKEN",             // Token name
597     18,                     // Decimals
598     "MISO",                 // Symbol
599     true                    // Enable transfers
600     ) {}
601 }