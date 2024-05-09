1 /// @title MiniMeToken Contract
2 /// @author Jordi Baylina
3 /// @dev This token contract's goal is to make it easy for anyone to clone this
4 ///  token using the token distribution at a given block, this will allow DAO's
5 ///  and DApps to upgrade their features in a decentralized manner without
6 ///  affecting the original token
7 /// @dev It is ERC20 compliant, but still needs to under go further testing.
8 
9 
10 interface ITokenController {
11 /// @notice Called when `_owner` sends ether to the MiniMe Token contract
12 /// @param _owner The address that sent the ether to create tokens
13 /// @return True if the ether is accepted, false if it throws
14 function proxyPayment(address _owner) public payable returns(bool);
15 
16 /// @notice Notifies the controller about a token transfer allowing the
17 ///  controller to react if desired
18 /// @param _from The origin of the transfer
19 /// @param _to The destination of the transfer
20 /// @param _amount The amount of the transfer
21 /// @return False if the controller does not authorize the transfer
22 function onTransfer(address _from, address _to, uint _amount) public constant returns(bool);
23 
24 /// @notice Notifies the controller about an approval allowing the
25 ///  controller to react if desired
26 /// @param _owner The address that calls `approve()`
27 /// @param _spender The spender in the `approve()` call
28 /// @param _amount The amount in the `approve()` call
29 /// @return False if the controller does not authorize the approval
30 function onApprove(address _owner, address _spender, uint _amount) public constant returns(bool);
31 }
32 
33 
34 contract Controlled {
35 /// @notice The address of the controller is the only address that can call
36 ///  a function with this modifier
37 modifier onlyController {
38     require(msg.sender == controller);
39     _;
40 }
41 
42 address public controller;
43 
44 function Controlled()  public { controller = msg.sender;}
45 
46 /// @notice Changes the controller of the contract
47 /// @param _newController The new controller of the contract
48 function changeController(address _newController) onlyController  public {
49     controller = _newController;
50 }
51 }
52 
53 contract ApproveAndCallFallBack {
54 function receiveApproval(
55     address from,
56     uint256 _amount,
57     address _token,
58     bytes _data
59 ) public;
60 }
61 
62 /// @dev The actual token contract, the default controller is the msg.sender
63 ///  that deploys the contract, so usually this token will be deployed by a
64 ///  token controller contract, which Giveth will call a "Campaign"
65 contract MiniMeToken is Controlled {
66 
67 string public name;                //The Token's name: e.g. DigixDAO Tokens
68 uint8 public decimals;             //Number of decimals of the smallest unit
69 string public symbol;              //An identifier: e.g. REP
70 string public version = "MMT_0.1"; //An arbitrary versioning scheme
71 
72 
73 /// @dev `Checkpoint` is the structure that attaches a block number to a
74 ///  given value, the block number attached is the one that last changed the
75 ///  value
76 struct Checkpoint {
77 
78     // `fromBlock` is the block number that the value was generated from
79     uint128 fromBlock;
80 
81     // `value` is the amount of tokens at a specific block number
82     uint128 value;
83 }
84 
85 // `parentToken` is the Token address that was cloned to produce this token;
86 //  it will be 0x0 for a token that was not cloned
87 MiniMeToken public parentToken;
88 
89 // `parentSnapShotBlock` is the block number from the Parent Token that was
90 //  used to determine the initial distribution of the Clone Token
91 uint public parentSnapShotBlock;
92 
93 // `creationBlock` is the block number that the Clone Token was created
94 uint public creationBlock;
95 
96 // `balances` is the map that tracks the balance of each address, in this
97 //  contract when the balance changes the block number that the change
98 //  occurred is also included in the map
99 mapping (address => Checkpoint[]) balances;
100 
101 // `allowed` tracks any extra transfer rights as in all ERC20 tokens
102 mapping (address => mapping (address => uint256)) allowed;
103 
104 // Tracks the history of the `totalSupply` of the token
105 Checkpoint[] totalSupplyHistory;
106 
107 // Flag that determines if the token is transferable or not.
108 bool public transfersEnabled;
109 
110 // The factory used to create new clone tokens
111 MiniMeTokenFactory public tokenFactory;
112 
113 ////////////////
114 // Constructor
115 ////////////////
116 
117 /// @notice Constructor to create a MiniMeToken
118 /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
119 ///  will create the Clone token contracts, the token factory needs to be
120 ///  deployed first
121 /// @param _parentToken Address of the parent token, set to 0x0 if it is a
122 ///  new token
123 /// @param _parentSnapShotBlock Block of the parent token that will
124 ///  determine the initial distribution of the clone token, set to 0 if it
125 ///  is a new token
126 /// @param _tokenName Name of the new token
127 /// @param _decimalUnits Number of decimals of the new token
128 /// @param _tokenSymbol Token Symbol for the new token
129 /// @param _transfersEnabled If true, tokens will be able to be transferred
130 function MiniMeToken(
131     address _tokenFactory,
132     address _parentToken,
133     uint _parentSnapShotBlock,
134     string _tokenName,
135     uint8 _decimalUnits,
136     string _tokenSymbol,
137     bool _transfersEnabled
138 )  public
139 {
140     tokenFactory = MiniMeTokenFactory(_tokenFactory);
141     name = _tokenName;                                 // Set the name
142     decimals = _decimalUnits;                          // Set the decimals
143     symbol = _tokenSymbol;                             // Set the symbol
144     parentToken = MiniMeToken(_parentToken);
145     parentSnapShotBlock = _parentSnapShotBlock;
146     transfersEnabled = _transfersEnabled;
147     creationBlock = block.number;
148 }
149 
150 
151 ///////////////////
152 // ERC20 Methods
153 ///////////////////
154 
155 /// @notice Send `_amount` tokens to `_to` from `msg.sender`
156 /// @param _to The address of the recipient
157 /// @param _amount The amount of tokens to be transferred
158 /// @return Whether the transfer was successful or not
159 function transfer(address _to, uint256 _amount) public returns (bool success) {
160     require(transfersEnabled);
161     return doTransfer(msg.sender, _to, _amount);
162 }
163 
164 /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
165 ///  is approved by `_from`
166 /// @param _from The address holding the tokens being transferred
167 /// @param _to The address of the recipient
168 /// @param _amount The amount of tokens to be transferred
169 /// @return True if the transfer was successful
170 function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
171 
172     // The controller of this contract can move tokens around at will,
173     //  this is important to recognize! Confirm that you trust the
174     //  controller of this contract, which in most situations should be
175     //  another open source smart contract or 0x0
176     if (msg.sender != controller) {
177         require(transfersEnabled);
178 
179         // The standard ERC 20 transferFrom functionality
180         if (allowed[_from][msg.sender] < _amount)
181             return false;
182         allowed[_from][msg.sender] -= _amount;
183     }
184     return doTransfer(_from, _to, _amount);
185 }
186 
187 /// @dev This is the actual transfer function in the token contract, it can
188 ///  only be called by other functions in this contract.
189 /// @param _from The address holding the tokens being transferred
190 /// @param _to The address of the recipient
191 /// @param _amount The amount of tokens to be transferred
192 /// @return True if the transfer was successful
193 function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
194     if (_amount == 0) {
195         return true;
196     }
197     require(parentSnapShotBlock < block.number);
198     // Do not allow transfer to 0x0 or the token contract itself
199     require((_to != 0) && (_to != address(this)));
200     // If the amount being transfered is more than the balance of the
201     //  account the transfer returns false
202     var previousBalanceFrom = balanceOfAt(_from, block.number);
203     if (previousBalanceFrom < _amount) {
204         return false;
205     }
206     // Alerts the token controller of the transfer
207     if (isContract(controller)) {
208         // Adding the ` == true` makes the linter shut up so...
209         require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
210     }
211     // First update the balance array with the new value for the address
212     //  sending the tokens
213     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
214     // Then update the balance array with the new value for the address
215     //  receiving the tokens
216     var previousBalanceTo = balanceOfAt(_to, block.number);
217     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
218     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
219     // An event to make the transfer easy to find on the blockchain
220     Transfer(_from, _to, _amount);
221     return true;
222 }
223 
224 /// @param _owner The address that's balance is being requested
225 /// @return The balance of `_owner` at the current block
226 function balanceOf(address _owner) public constant returns (uint256 balance) {
227     return balanceOfAt(_owner, block.number);
228 }
229 
230 /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
231 ///  its behalf. This is a modified version of the ERC20 approve function
232 ///  to be a little bit safer
233 /// @param _spender The address of the account able to transfer the tokens
234 /// @param _amount The amount of tokens to be approved for transfer
235 /// @return True if the approval was successful
236 function approve(address _spender, uint256 _amount) public returns (bool success) {
237     require(transfersEnabled);
238 
239     // To change the approve amount you first have to reduce the addresses`
240     //  allowance to zero by calling `approve(_spender,0)` if it is not
241     //  already 0 to mitigate the race condition described here:
242     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
244 
245     // Alerts the token controller of the approve function call
246     if (isContract(controller)) {
247         // Adding the ` == true` makes the linter shut up so...
248         require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
249     }
250 
251     allowed[msg.sender][_spender] = _amount;
252     Approval(msg.sender, _spender, _amount);
253     return true;
254 }
255 
256 /// @dev This function makes it easy to read the `allowed[]` map
257 /// @param _owner The address of the account that owns the token
258 /// @param _spender The address of the account able to transfer the tokens
259 /// @return Amount of remaining tokens of _owner that _spender is allowed
260 ///  to spend
261 function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
262     return allowed[_owner][_spender];
263 }
264 
265 /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
266 ///  its behalf, and then a function is triggered in the contract that is
267 ///  being approved, `_spender`. This allows users to use their tokens to
268 ///  interact with contracts in one function call instead of two
269 /// @param _spender The address of the contract able to transfer the tokens
270 /// @param _amount The amount of tokens to be approved for transfer
271 /// @return True if the function call was successful
272 function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
273     require(approve(_spender, _amount));
274 
275     ApproveAndCallFallBack(_spender).receiveApproval(
276         msg.sender,
277         _amount,
278         this,
279         _extraData
280     );
281 
282     return true;
283 }
284 
285 /// @dev This function makes it easy to get the total number of tokens
286 /// @return The total number of tokens
287 function totalSupply() public constant returns (uint) {
288     return totalSupplyAt(block.number);
289 }
290 
291 
292 ////////////////
293 // Query balance and totalSupply in History
294 ////////////////
295 
296 /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
297 /// @param _owner The address from which the balance will be retrieved
298 /// @param _blockNumber The block number when the balance is queried
299 /// @return The balance at `_blockNumber`
300 function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
301 
302     // These next few lines are used when the balance of the token is
303     //  requested before a check point was ever created for this token, it
304     //  requires that the `parentToken.balanceOfAt` be queried at the
305     //  genesis block for that token as this contains initial balance of
306     //  this token
307     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
308         if (address(parentToken) != 0) {
309             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
310         } else {
311             // Has no parent
312             return 0;
313         }
314 
315     // This will return the expected balance during normal situations
316     } else {
317         return getValueAt(balances[_owner], _blockNumber);
318     }
319 }
320 
321 /// @notice Total amount of tokens at a specific `_blockNumber`.
322 /// @param _blockNumber The block number when the totalSupply is queried
323 /// @return The total amount of tokens at `_blockNumber`
324 function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
325 
326     // These next few lines are used when the totalSupply of the token is
327     //  requested before a check point was ever created for this token, it
328     //  requires that the `parentToken.totalSupplyAt` be queried at the
329     //  genesis block for this token as that contains totalSupply of this
330     //  token at this block number.
331     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
332         if (address(parentToken) != 0) {
333             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
334         } else {
335             return 0;
336         }
337 
338     // This will return the expected totalSupply during normal situations
339     } else {
340         return getValueAt(totalSupplyHistory, _blockNumber);
341     }
342 }
343 
344 ////////////////
345 // Clone Token Method
346 ////////////////
347 
348 /// @notice Creates a new clone token with the initial distribution being
349 ///  this token at `_snapshotBlock`
350 /// @param _cloneTokenName Name of the clone token
351 /// @param _cloneDecimalUnits Number of decimals of the smallest unit
352 /// @param _cloneTokenSymbol Symbol of the clone token
353 /// @param _snapshotBlock Block when the distribution of the parent token is
354 ///  copied to set the initial distribution of the new clone token;
355 ///  if the block is zero than the actual block, the current block is used
356 /// @param _transfersEnabled True if transfers are allowed in the clone
357 /// @return The address of the new MiniMeToken Contract
358 function createCloneToken(
359     string _cloneTokenName,
360     uint8 _cloneDecimalUnits,
361     string _cloneTokenSymbol,
362     uint _snapshotBlock,
363     bool _transfersEnabled
364 ) public returns(address)
365 {
366     uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
367 
368     MiniMeToken cloneToken = tokenFactory.createCloneToken(
369         this,
370         snapshot,
371         _cloneTokenName,
372         _cloneDecimalUnits,
373         _cloneTokenSymbol,
374         _transfersEnabled
375     );
376 
377     cloneToken.changeController(msg.sender);
378 
379     // An event to make the token easy to find on the blockchain
380     NewCloneToken(address(cloneToken), snapshot);
381     return address(cloneToken);
382 }
383 
384 ////////////////
385 // Generate and destroy tokens
386 ////////////////
387 
388 /// @notice Generates `_amount` tokens that are assigned to `_owner`
389 /// @param _owner The address that will be assigned the new tokens
390 /// @param _amount The quantity of tokens generated
391 /// @return True if the tokens are generated correctly
392 function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
393     uint curTotalSupply = totalSupply();
394     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
395     uint previousBalanceTo = balanceOf(_owner);
396     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
397     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
398     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
399     Transfer(0, _owner, _amount);
400     return true;
401 }
402 
403 
404 /// @notice Burns `_amount` tokens from `_owner`
405 /// @param _owner The address that will lose the tokens
406 /// @param _amount The quantity of tokens to burn
407 /// @return True if the tokens are burned correctly
408 function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
409     uint curTotalSupply = totalSupply();
410     require(curTotalSupply >= _amount);
411     uint previousBalanceFrom = balanceOf(_owner);
412     require(previousBalanceFrom >= _amount);
413     updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
414     updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
415     Transfer(_owner, 0, _amount);
416     return true;
417 }
418 
419 ////////////////
420 // Enable tokens transfers
421 ////////////////
422 
423 
424 /// @notice Enables token holders to transfer their tokens freely if true
425 /// @param _transfersEnabled True if transfers are allowed in the clone
426 function enableTransfers(bool _transfersEnabled) onlyController public {
427     transfersEnabled = _transfersEnabled;
428 }
429 
430 ////////////////
431 // Internal helper functions to query and set a value in a snapshot array
432 ////////////////
433 
434 /// @dev `getValueAt` retrieves the number of tokens at a given block number
435 /// @param checkpoints The history of values being queried
436 /// @param _block The block number to retrieve the value at
437 /// @return The number of tokens being queried
438 function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
439     if (checkpoints.length == 0)
440         return 0;
441 
442     // Shortcut for the actual value
443     if (_block >= checkpoints[checkpoints.length-1].fromBlock)
444         return checkpoints[checkpoints.length-1].value;
445     if (_block < checkpoints[0].fromBlock)
446         return 0;
447 
448     // Binary search of the value in the array
449     uint min = 0;
450     uint max = checkpoints.length-1;
451     while (max > min) {
452         uint mid = (max + min + 1) / 2;
453         if (checkpoints[mid].fromBlock<=_block) {
454             min = mid;
455         } else {
456             max = mid-1;
457         }
458     }
459     return checkpoints[min].value;
460 }
461 
462 /// @dev `updateValueAtNow` used to update the `balances` map and the
463 ///  `totalSupplyHistory`
464 /// @param checkpoints The history of data being updated
465 /// @param _value The new number of tokens
466 function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
467     if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
468         Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
469         newCheckPoint.fromBlock = uint128(block.number);
470         newCheckPoint.value = uint128(_value);
471     } else {
472         Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
473         oldCheckPoint.value = uint128(_value);
474     }
475 }
476 
477 /// @dev Internal function to determine if an address is a contract
478 /// @param _addr The address being queried
479 /// @return True if `_addr` is a contract
480 function isContract(address _addr) constant internal returns(bool) {
481     uint size;
482     if (_addr == 0)
483         return false;
484 
485     assembly {
486         size := extcodesize(_addr)
487     }
488 
489     return size>0;
490 }
491 
492 /// @dev Helper function to return a min betwen the two uints
493 function min(uint a, uint b) internal returns (uint) {
494     return a < b ? a : b;
495 }
496 
497 /// @notice The fallback function: If the contract's controller has not been
498 ///  set to 0, then the `proxyPayment` method is called which relays the
499 ///  ether and creates tokens as described in the token controller contract
500 function ()  payable  public {
501     require(isContract(controller));
502     // Adding the ` == true` makes the linter shut up so...
503     require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
504 }
505 
506 //////////
507 // Safety Methods
508 //////////
509 
510 /// @notice This method can be used by the controller to extract mistakenly
511 ///  sent tokens to this contract.
512 /// @param _token The address of the token contract that you want to recover
513 ///  set to 0 in case you want to extract ether.
514 function claimTokens(address _token) onlyController  public {
515     if (_token == 0x0) {
516         controller.transfer(this.balance);
517         return;
518     }
519 
520     MiniMeToken token = MiniMeToken(_token);
521     uint balance = token.balanceOf(this);
522     token.transfer(controller, balance);
523     ClaimedTokens(_token, controller, balance);
524 }
525 
526 ////////////////
527 // Events
528 ////////////////
529 event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
530 event Transfer(address indexed _from, address indexed _to, uint256 _amount);
531 event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
532 event Approval(
533     address indexed _owner,
534     address indexed _spender,
535     uint256 _amount
536     );
537 
538 }
539 
540 
541 ////////////////
542 // MiniMeTokenFactory
543 ////////////////
544 
545 /// @dev This contract is used to generate clone contracts from a contract.
546 ///  In solidity this is the way to create a contract from a contract of the
547 ///  same class
548 contract MiniMeTokenFactory {
549 
550 /// @notice Update the DApp by creating a new token with new functionalities
551 ///  the msg.sender becomes the controller of this clone token
552 /// @param _parentToken Address of the token being cloned
553 /// @param _snapshotBlock Block of the parent token that will
554 ///  determine the initial distribution of the clone token
555 /// @param _tokenName Name of the new token
556 /// @param _decimalUnits Number of decimals of the new token
557 /// @param _tokenSymbol Token Symbol for the new token
558 /// @param _transfersEnabled If true, tokens will be able to be transferred
559 /// @return The address of the new token contract
560 function createCloneToken(
561     address _parentToken,
562     uint _snapshotBlock,
563     string _tokenName,
564     uint8 _decimalUnits,
565     string _tokenSymbol,
566     bool _transfersEnabled
567 ) public returns (MiniMeToken)
568 {
569     MiniMeToken newToken = new MiniMeToken(
570         this,
571         _parentToken,
572         _snapshotBlock,
573         _tokenName,
574         _decimalUnits,
575         _tokenSymbol,
576         _transfersEnabled
577     );
578 
579     newToken.changeController(msg.sender);
580     return newToken;
581 }
582 }