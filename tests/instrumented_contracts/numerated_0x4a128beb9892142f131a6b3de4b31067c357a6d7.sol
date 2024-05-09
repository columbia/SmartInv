1 contract TokenController {
2     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
3     /// @param _owner The address that sent the ether to create tokens
4     /// @return True if the ether is accepted, false if it throws
5     function proxyPayment(address _owner) payable returns(bool);
6 
7     /// @notice Notifies the controller about a token transfer allowing the
8     ///  controller to react if desired
9     /// @param _from The origin of the transfer
10     /// @param _to The destination of the transfer
11     /// @param _amount The amount of the transfer
12     /// @return False if the controller does not authorize the transfer
13     function onTransfer(address _from, address _to, uint _amount) returns(bool);
14 
15     /// @notice Notifies the controller about an approval allowing the
16     ///  controller to react if desired
17     /// @param _owner The address that calls `approve()`
18     /// @param _spender The spender in the `approve()` call
19     /// @param _amount The amount in the `approve()` call
20     /// @return False if the controller does not authorize the approval
21     function onApprove(address _owner, address _spender, uint _amount)
22         returns(bool);
23 }
24 
25 contract Controlled {
26     /// @notice The address of the controller is the only address that can call
27     ///  a function with this modifier
28     modifier onlyController { require(msg.sender == controller); _; }
29 
30     address public controller;
31 
32     function Controlled() { controller = msg.sender;}
33 
34     /// @notice Changes the controller of the contract
35     /// @param _newController The new controller of the contract
36     function changeController(address _newController) onlyController {
37         controller = _newController;
38     }
39 }
40 
41 contract ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
43 }
44 
45 /// @dev The actual token contract, the default controller is the msg.sender
46 ///  that deploys the contract, so usually this token will be deployed by a
47 ///  token controller contract, which Giveth will call a "Campaign"
48 contract MiniMeToken is Controlled {
49 
50     string public name;                //The Token's name: e.g. DigixDAO Tokens
51     uint8 public decimals;             //Number of decimals of the smallest unit
52     string public symbol;              //An identifier: e.g. REP
53     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
54 
55 
56     /// @dev `Checkpoint` is the structure that attaches a block number to a
57     ///  given value, the block number attached is the one that last changed the
58     ///  value
59     struct  Checkpoint {
60 
61         // `fromBlock` is the block number that the value was generated from
62         uint128 fromBlock;
63 
64         // `value` is the amount of tokens at a specific block number
65         uint128 value;
66     }
67 
68     // `parentToken` is the Token address that was cloned to produce this token;
69     //  it will be 0x0 for a token that was not cloned
70     MiniMeToken public parentToken;
71 
72     // `parentSnapShotBlock` is the block number from the Parent Token that was
73     //  used to determine the initial distribution of the Clone Token
74     uint public parentSnapShotBlock;
75 
76     // `creationBlock` is the block number that the Clone Token was created
77     uint public creationBlock;
78 
79     // `balances` is the map that tracks the balance of each address, in this
80     //  contract when the balance changes the block number that the change
81     //  occurred is also included in the map
82     mapping (address => Checkpoint[]) balances;
83 
84     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
85     mapping (address => mapping (address => uint256)) allowed;
86 
87     // Tracks the history of the `totalSupply` of the token
88     Checkpoint[] totalSupplyHistory;
89 
90     // Flag that determines if the token is transferable or not.
91     bool public transfersEnabled;
92 
93     // The factory used to create new clone tokens
94     MiniMeTokenFactory public tokenFactory;
95 
96 ////////////////
97 // Constructor
98 ////////////////
99 
100     /// @notice Constructor to create a MiniMeToken
101     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
102     ///  will create the Clone token contracts, the token factory needs to be
103     ///  deployed first
104     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
105     ///  new token
106     /// @param _parentSnapShotBlock Block of the parent token that will
107     ///  determine the initial distribution of the clone token, set to 0 if it
108     ///  is a new token
109     /// @param _tokenName Name of the new token
110     /// @param _decimalUnits Number of decimals of the new token
111     /// @param _tokenSymbol Token Symbol for the new token
112     /// @param _transfersEnabled If true, tokens will be able to be transferred
113     function MiniMeToken(
114         address _tokenFactory,
115         address _parentToken,
116         uint _parentSnapShotBlock,
117         string _tokenName,
118         uint8 _decimalUnits,
119         string _tokenSymbol,
120         bool _transfersEnabled
121     ) {
122         tokenFactory = MiniMeTokenFactory(_tokenFactory);
123         name = _tokenName;                                 // Set the name
124         decimals = _decimalUnits;                          // Set the decimals
125         symbol = _tokenSymbol;                             // Set the symbol
126         parentToken = MiniMeToken(_parentToken);
127         parentSnapShotBlock = _parentSnapShotBlock;
128         transfersEnabled = _transfersEnabled;
129         creationBlock = block.number;
130     }
131 
132 
133 ///////////////////
134 // ERC20 Methods
135 ///////////////////
136 
137     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
138     /// @param _to The address of the recipient
139     /// @param _amount The amount of tokens to be transferred
140     /// @return Whether the transfer was successful or not
141     function transfer(address _to, uint256 _amount) returns (bool success) {
142         require(transfersEnabled);
143         return doTransfer(msg.sender, _to, _amount);
144     }
145 
146     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
147     ///  is approved by `_from`
148     /// @param _from The address holding the tokens being transferred
149     /// @param _to The address of the recipient
150     /// @param _amount The amount of tokens to be transferred
151     /// @return True if the transfer was successful
152     function transferFrom(address _from, address _to, uint256 _amount
153     ) returns (bool success) {
154 
155         // The controller of this contract can move tokens around at will,
156         //  this is important to recognize! Confirm that you trust the
157         //  controller of this contract, which in most situations should be
158         //  another open source smart contract or 0x0
159         if (msg.sender != controller) {
160             require(transfersEnabled);
161 
162             // The standard ERC 20 transferFrom functionality
163             if (allowed[_from][msg.sender] < _amount) return false;
164             allowed[_from][msg.sender] -= _amount;
165         }
166         return doTransfer(_from, _to, _amount);
167     }
168 
169     /// @dev This is the actual transfer function in the token contract, it can
170     ///  only be called by other functions in this contract.
171     /// @param _from The address holding the tokens being transferred
172     /// @param _to The address of the recipient
173     /// @param _amount The amount of tokens to be transferred
174     /// @return True if the transfer was successful
175     function doTransfer(address _from, address _to, uint _amount
176     ) internal returns(bool) {
177 
178            if (_amount == 0) {
179                return true;
180            }
181 
182            require(parentSnapShotBlock < block.number);
183 
184            // Do not allow transfer to 0x0 or the token contract itself
185            require((_to != 0) && (_to != address(this)));
186 
187            // If the amount being transfered is more than the balance of the
188            //  account the transfer returns false
189            var previousBalanceFrom = balanceOfAt(_from, block.number);
190            if (previousBalanceFrom < _amount) {
191                return false;
192            }
193 
194            // Alerts the token controller of the transfer
195            if (isContract(controller)) {
196                require(TokenController(controller).onTransfer(_from, _to, _amount));
197            }
198 
199            // First update the balance array with the new value for the address
200            //  sending the tokens
201            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
202 
203            // Then update the balance array with the new value for the address
204            //  receiving the tokens
205            var previousBalanceTo = balanceOfAt(_to, block.number);
206            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
207            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
208 
209            // An event to make the transfer easy to find on the blockchain
210            Transfer(_from, _to, _amount);
211 
212            return true;
213     }
214 
215     /// @param _owner The address that's balance is being requested
216     /// @return The balance of `_owner` at the current block
217     function balanceOf(address _owner) constant returns (uint256 balance) {
218         return balanceOfAt(_owner, block.number);
219     }
220 
221     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
222     ///  its behalf. This is a modified version of the ERC20 approve function
223     ///  to be a little bit safer
224     /// @param _spender The address of the account able to transfer the tokens
225     /// @param _amount The amount of tokens to be approved for transfer
226     /// @return True if the approval was successful
227     function approve(address _spender, uint256 _amount) returns (bool success) {
228         require(transfersEnabled);
229 
230         // To change the approve amount you first have to reduce the addresses`
231         //  allowance to zero by calling `approve(_spender,0)` if it is not
232         //  already 0 to mitigate the race condition described here:
233         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
235 
236         // Alerts the token controller of the approve function call
237         if (isContract(controller)) {
238             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
239         }
240 
241         allowed[msg.sender][_spender] = _amount;
242         Approval(msg.sender, _spender, _amount);
243         return true;
244     }
245 
246     /// @dev This function makes it easy to read the `allowed[]` map
247     /// @param _owner The address of the account that owns the token
248     /// @param _spender The address of the account able to transfer the tokens
249     /// @return Amount of remaining tokens of _owner that _spender is allowed
250     ///  to spend
251     function allowance(address _owner, address _spender
252     ) constant returns (uint256 remaining) {
253         return allowed[_owner][_spender];
254     }
255 
256     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
257     ///  its behalf, and then a function is triggered in the contract that is
258     ///  being approved, `_spender`. This allows users to use their tokens to
259     ///  interact with contracts in one function call instead of two
260     /// @param _spender The address of the contract able to transfer the tokens
261     /// @param _amount The amount of tokens to be approved for transfer
262     /// @return True if the function call was successful
263     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
264     ) returns (bool success) {
265         require(approve(_spender, _amount));
266 
267         ApproveAndCallFallBack(_spender).receiveApproval(
268             msg.sender,
269             _amount,
270             this,
271             _extraData
272         );
273 
274         return true;
275     }
276 
277     /// @dev This function makes it easy to get the total number of tokens
278     /// @return The total number of tokens
279     function totalSupply() constant returns (uint) {
280         return totalSupplyAt(block.number);
281     }
282 
283 
284 ////////////////
285 // Query balance and totalSupply in History
286 ////////////////
287 
288     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
289     /// @param _owner The address from which the balance will be retrieved
290     /// @param _blockNumber The block number when the balance is queried
291     /// @return The balance at `_blockNumber`
292     function balanceOfAt(address _owner, uint _blockNumber) constant
293         returns (uint) {
294 
295         // These next few lines are used when the balance of the token is
296         //  requested before a check point was ever created for this token, it
297         //  requires that the `parentToken.balanceOfAt` be queried at the
298         //  genesis block for that token as this contains initial balance of
299         //  this token
300         if ((balances[_owner].length == 0)
301             || (balances[_owner][0].fromBlock > _blockNumber)) {
302             if (address(parentToken) != 0) {
303                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
304             } else {
305                 // Has no parent
306                 return 0;
307             }
308 
309         // This will return the expected balance during normal situations
310         } else {
311             return getValueAt(balances[_owner], _blockNumber);
312         }
313     }
314 
315     /// @notice Total amount of tokens at a specific `_blockNumber`.
316     /// @param _blockNumber The block number when the totalSupply is queried
317     /// @return The total amount of tokens at `_blockNumber`
318     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
319 
320         // These next few lines are used when the totalSupply of the token is
321         //  requested before a check point was ever created for this token, it
322         //  requires that the `parentToken.totalSupplyAt` be queried at the
323         //  genesis block for this token as that contains totalSupply of this
324         //  token at this block number.
325         if ((totalSupplyHistory.length == 0)
326             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
327             if (address(parentToken) != 0) {
328                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
329             } else {
330                 return 0;
331             }
332 
333         // This will return the expected totalSupply during normal situations
334         } else {
335             return getValueAt(totalSupplyHistory, _blockNumber);
336         }
337     }
338 
339 ////////////////
340 // Clone Token Method
341 ////////////////
342 
343     /// @notice Creates a new clone token with the initial distribution being
344     ///  this token at `_snapshotBlock`
345     /// @param _cloneTokenName Name of the clone token
346     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
347     /// @param _cloneTokenSymbol Symbol of the clone token
348     /// @param _snapshotBlock Block when the distribution of the parent token is
349     ///  copied to set the initial distribution of the new clone token;
350     ///  if the block is zero than the actual block, the current block is used
351     /// @param _transfersEnabled True if transfers are allowed in the clone
352     /// @return The address of the new MiniMeToken Contract
353     function createCloneToken(
354         string _cloneTokenName,
355         uint8 _cloneDecimalUnits,
356         string _cloneTokenSymbol,
357         uint _snapshotBlock,
358         bool _transfersEnabled
359         ) returns(address) {
360         if (_snapshotBlock == 0) _snapshotBlock = block.number;
361         MiniMeToken cloneToken = tokenFactory.createCloneToken(
362             this,
363             _snapshotBlock,
364             _cloneTokenName,
365             _cloneDecimalUnits,
366             _cloneTokenSymbol,
367             _transfersEnabled
368             );
369 
370         cloneToken.changeController(msg.sender);
371 
372         // An event to make the token easy to find on the blockchain
373         NewCloneToken(address(cloneToken), _snapshotBlock);
374         return address(cloneToken);
375     }
376 
377 ////////////////
378 // Generate and destroy tokens
379 ////////////////
380 
381     /// @notice Generates `_amount` tokens that are assigned to `_owner`
382     /// @param _owner The address that will be assigned the new tokens
383     /// @param _amount The quantity of tokens generated
384     /// @return True if the tokens are generated correctly
385     function generateTokens(address _owner, uint _amount
386     ) onlyController returns (bool) {
387         uint curTotalSupply = totalSupply();
388         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
389         uint previousBalanceTo = balanceOf(_owner);
390         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
391         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
392         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
393         Transfer(0, _owner, _amount);
394         return true;
395     }
396 
397 
398     /// @notice Burns `_amount` tokens from `_owner`
399     /// @param _owner The address that will lose the tokens
400     /// @param _amount The quantity of tokens to burn
401     /// @return True if the tokens are burned correctly
402     function destroyTokens(address _owner, uint _amount
403     ) onlyController returns (bool) {
404         uint curTotalSupply = totalSupply();
405         require(curTotalSupply >= _amount);
406         uint previousBalanceFrom = balanceOf(_owner);
407         require(previousBalanceFrom >= _amount);
408         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
409         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
410         Transfer(_owner, 0, _amount);
411         return true;
412     }
413 
414 ////////////////
415 // Enable tokens transfers
416 ////////////////
417 
418 
419     /// @notice Enables token holders to transfer their tokens freely if true
420     /// @param _transfersEnabled True if transfers are allowed in the clone
421     function enableTransfers(bool _transfersEnabled) onlyController {
422         transfersEnabled = _transfersEnabled;
423     }
424 
425 ////////////////
426 // Internal helper functions to query and set a value in a snapshot array
427 ////////////////
428 
429     /// @dev `getValueAt` retrieves the number of tokens at a given block number
430     /// @param checkpoints The history of values being queried
431     /// @param _block The block number to retrieve the value at
432     /// @return The number of tokens being queried
433     function getValueAt(Checkpoint[] storage checkpoints, uint _block
434     ) constant internal returns (uint) {
435         if (checkpoints.length == 0) return 0;
436 
437         // Shortcut for the actual value
438         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
439             return checkpoints[checkpoints.length-1].value;
440         if (_block < checkpoints[0].fromBlock) return 0;
441 
442         // Binary search of the value in the array
443         uint min = 0;
444         uint max = checkpoints.length-1;
445         while (max > min) {
446             uint mid = (max + min + 1)/ 2;
447             if (checkpoints[mid].fromBlock<=_block) {
448                 min = mid;
449             } else {
450                 max = mid-1;
451             }
452         }
453         return checkpoints[min].value;
454     }
455 
456     /// @dev `updateValueAtNow` used to update the `balances` map and the
457     ///  `totalSupplyHistory`
458     /// @param checkpoints The history of data being updated
459     /// @param _value The new number of tokens
460     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
461     ) internal  {
462         if ((checkpoints.length == 0)
463         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
464                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
465                newCheckPoint.fromBlock =  uint128(block.number);
466                newCheckPoint.value = uint128(_value);
467            } else {
468                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
469                oldCheckPoint.value = uint128(_value);
470            }
471     }
472 
473     /// @dev Internal function to determine if an address is a contract
474     /// @param _addr The address being queried
475     /// @return True if `_addr` is a contract
476     function isContract(address _addr) constant internal returns(bool) {
477         uint size;
478         if (_addr == 0) return false;
479         assembly {
480             size := extcodesize(_addr)
481         }
482         return size>0;
483     }
484 
485     /// @dev Helper function to return a min betwen the two uints
486     function min(uint a, uint b) internal returns (uint) {
487         return a < b ? a : b;
488     }
489 
490     /// @notice The fallback function: If the contract's controller has not been
491     ///  set to 0, then the `proxyPayment` method is called which relays the
492     ///  ether and creates tokens as described in the token controller contract
493     function ()  payable {
494         require(isContract(controller));
495         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
496     }
497 
498 //////////
499 // Safety Methods
500 //////////
501 
502     /// @notice This method can be used by the controller to extract mistakenly
503     ///  sent tokens to this contract.
504     /// @param _token The address of the token contract that you want to recover
505     ///  set to 0 in case you want to extract ether.
506     function claimTokens(address _token) onlyController {
507         if (_token == 0x0) {
508             controller.transfer(this.balance);
509             return;
510         }
511 
512         MiniMeToken token = MiniMeToken(_token);
513         uint balance = token.balanceOf(this);
514         token.transfer(controller, balance);
515         ClaimedTokens(_token, controller, balance);
516     }
517 
518 ////////////////
519 // Events
520 ////////////////
521     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
522     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
523     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
524     event Approval(
525         address indexed _owner,
526         address indexed _spender,
527         uint256 _amount
528         );
529 
530 }
531 
532 
533 ////////////////
534 // MiniMeTokenFactory
535 ////////////////
536 
537 /// @dev This contract is used to generate clone contracts from a contract.
538 ///  In solidity this is the way to create a contract from a contract of the
539 ///  same class
540 contract MiniMeTokenFactory {
541 
542     /// @notice Update the DApp by creating a new token with new functionalities
543     ///  the msg.sender becomes the controller of this clone token
544     /// @param _parentToken Address of the token being cloned
545     /// @param _snapshotBlock Block of the parent token that will
546     ///  determine the initial distribution of the clone token
547     /// @param _tokenName Name of the new token
548     /// @param _decimalUnits Number of decimals of the new token
549     /// @param _tokenSymbol Token Symbol for the new token
550     /// @param _transfersEnabled If true, tokens will be able to be transferred
551     /// @return The address of the new token contract
552     function createCloneToken(
553         address _parentToken,
554         uint _snapshotBlock,
555         string _tokenName,
556         uint8 _decimalUnits,
557         string _tokenSymbol,
558         bool _transfersEnabled
559     ) returns (MiniMeToken) {
560         MiniMeToken newToken = new MiniMeToken(
561             this,
562             _parentToken,
563             _snapshotBlock,
564             _tokenName,
565             _decimalUnits,
566             _tokenSymbol,
567             _transfersEnabled
568             );
569 
570         newToken.changeController(msg.sender);
571         return newToken;
572     }
573 }
574 
575 contract Token is MiniMeToken {
576     // @dev Token constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
577     function Token(address _tokenFactory)
578     MiniMeToken(
579         _tokenFactory,
580         0x0,            // no parent token
581         0,              // no snapshot block number from parent
582         "Professional Activity Token",          // Token name
583         18,             // Decimals
584         "PATO",          // Symbol
585         true            // Enable transfers
586     ) {}
587 }