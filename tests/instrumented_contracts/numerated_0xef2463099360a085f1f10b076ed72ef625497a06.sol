1 pragma solidity 0.4.15;
2 
3 
4 /// @dev The token controller contract must implement these functions
5 contract TokenController {
6     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
7     /// @param _owner The address that sent the ether to create tokens
8     /// @return True if the ether is accepted, false if it throws
9     function proxyPayment(address _owner) payable returns(bool);
10 
11     /// @notice Notifies the controller about a token transfer allowing the
12     ///  controller to react if desired
13     /// @param _from The origin of the transfer
14     /// @param _to The destination of the transfer
15     /// @param _amount The amount of the transfer
16     /// @return False if the controller does not authorize the transfer
17     function onTransfer(address _from, address _to, uint _amount) returns(bool);
18 
19     /// @notice Notifies the controller about an approval allowing the
20     ///  controller to react if desired
21     /// @param _owner The address that calls `approve()`
22     /// @param _spender The spender in the `approve()` call
23     /// @param _amount The amount in the `approve()` call
24     /// @return False if the controller does not authorize the approval
25     function onApprove(address _owner, address _spender, uint _amount)
26         returns(bool);
27 }
28 
29 contract Controlled {
30     /// @notice The address of the controller is the only address that can call
31     ///  a function with this modifier
32     modifier onlyController { require(msg.sender == controller); _; }
33 
34     address public controller;
35 
36     function Controlled() { controller = msg.sender;}
37 
38     /// @notice Changes the controller of the contract
39     /// @param _newController The new controller of the contract
40     function changeController(address _newController) onlyController {
41         controller = _newController;
42     }
43 }
44 
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
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
57     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
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
125     ) {
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
145     function transfer(address _to, uint256 _amount) returns (bool success) {
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
157     ) returns (bool success) {
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
221     function balanceOf(address _owner) constant returns (uint256 balance) {
222         return balanceOfAt(_owner, block.number);
223     }
224 
225     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
226     ///  its behalf. This is a modified version of the ERC20 approve function
227     ///  to be a little bit safer
228     /// @param _spender The address of the account able to transfer the tokens
229     /// @param _amount The amount of tokens to be approved for transfer
230     /// @return True if the approval was successful
231     function approve(address _spender, uint256 _amount) returns (bool success) {
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
256     ) constant returns (uint256 remaining) {
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
268     ) returns (bool success) {
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
283     function totalSupply() constant returns (uint) {
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
296     function balanceOfAt(address _owner, uint _blockNumber) constant
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
322     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
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
363         ) returns(address) {
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
390     ) onlyController returns (bool) {
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
407     ) onlyController returns (bool) {
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
425     function enableTransfers(bool _transfersEnabled) onlyController {
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
490     function min(uint a, uint b) internal returns (uint) {
491         return a < b ? a : b;
492     }
493 
494     /// @notice The fallback function: If the contract's controller has not been
495     ///  set to 0, then the `proxyPayment` method is called which relays the
496     ///  ether and creates tokens as described in the token controller contract
497     function ()  payable {
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
510     function claimTokens(address _token) onlyController {
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
563     ) returns (MiniMeToken) 
564     {
565         MiniMeToken newToken = new MiniMeToken(
566             this,
567             _parentToken,
568             _snapshotBlock,
569             _tokenName,
570             _decimalUnits,
571             _tokenSymbol,
572             _transfersEnabled
573             );
574 
575         newToken.changeController(msg.sender);
576         return newToken;
577     }
578 }
579 
580 contract SHP is MiniMeToken {
581     // @dev SHP constructor
582     function SHP(address _tokenFactory)
583             MiniMeToken(
584                 _tokenFactory,
585                 0x0,                             // no parent token
586                 0,                               // no snapshot block number from parent
587                 "Sharpe Platform Token",         // Token name
588                 18,                              // Decimals
589                 "SHP",                           // Symbol
590                 true                             // Enable transfers
591             ) {}
592 }