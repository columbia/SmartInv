1 pragma solidity ^0.4.18;
2 
3 contract ApproveAndCallFallBack {
4     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
5 }
6 
7 contract TokenController {
8     function proxyPayment(address _owner) public payable returns(bool);
9 
10     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
11 
12     function onApprove(address _owner, address _spender, uint _amount) public
13         returns(bool);
14 }
15 
16 contract Controlled {
17     modifier onlyController { 
18         require(msg.sender == controller); 
19         _; 
20     }
21 
22     address public controller;
23 
24     function Controlled() public { 
25         controller = msg.sender;
26     }
27 
28     function changeController(address _newController) public onlyController {
29         controller = _newController;
30     }
31 }
32 
33 
34 /// @dev The actual token contract, the default controller is the msg.sender
35 ///  that deploys the contract, so usually this token will be deployed by a
36 ///  token controller contract, which Giveth will call a "Campaign"
37 contract WizzleGlobalToken is Controlled {
38 
39     string public name;                //The Token's name: e.g. DigixDAO Tokens
40     uint8 public decimals;             //Number of decimals of the smallest unit
41     string public symbol;              //An identifier: e.g. REP
42     string public version = 'v1';      //An arbitrary versioning scheme
43 
44     /// @dev `Checkpoint` is the structure that attaches a block number to a
45     ///  given value, the block number attached is the one that last changed the
46     ///  value
47     struct  Checkpoint {
48 
49         // `fromBlock` is the block number that the value was generated from
50         uint128 fromBlock;
51 
52         // `value` is the amount of tokens at a specific block number
53         uint128 value;
54     }
55 
56     // `parentToken` is the Token address that was cloned to produce this token;
57     //  it will be 0x0 for a token that was not cloned
58     WizzleGlobalToken public parentToken;
59 
60     // `parentSnapShotBlock` is the block number from the Parent Token that was
61     //  used to determine the initial distribution of the Clone Token
62     uint public parentSnapShotBlock;
63 
64     // `creationBlock` is the block number that the Clone Token was created
65     uint public creationBlock;
66 
67     // `balances` is the map that tracks the balance of each address, in this
68     //  contract when the balance changes the block number that the change
69     //  occurred is also included in the map
70     mapping (address => Checkpoint[]) balances;
71 
72     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
73     mapping (address => mapping (address => uint256)) allowed;
74 
75     // Tracks the history of the `totalSupply` of the token
76     Checkpoint[] totalSupplyHistory;
77 
78     // Flag that determines if the token is transferable or not.
79     bool public transfersEnabled;
80 
81     // The factory used to create new clone tokens
82     WizzleGlobalTokenFactory public tokenFactory;
83 
84 ////////////////
85 // Constructor
86 ////////////////
87 
88     /// @notice Constructor to create a WizzleGlobalToken
89     /// @param _tokenFactory The address of the WizzleGlobalTokenFactory contract that
90     ///  will create the Clone token contracts, the token factory needs to be
91     ///  deployed first
92     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
93     ///  new token
94     /// @param _parentSnapShotBlock Block of the parent token that will
95     ///  determine the initial distribution of the clone token, set to 0 if it
96     ///  is a new token
97     /// @param _tokenName Name of the new token
98     /// @param _decimalUnits Number of decimals of the new token
99     /// @param _tokenSymbol Token Symbol for the new token
100     /// @param _transfersEnabled If true, tokens will be able to be transferred
101     function WizzleGlobalToken(
102         address _tokenFactory,
103         address _parentToken,
104         uint _parentSnapShotBlock,
105         string _tokenName,
106         uint8 _decimalUnits,
107         string _tokenSymbol,
108         bool _transfersEnabled
109     ) public {
110         tokenFactory = WizzleGlobalTokenFactory(_tokenFactory);
111         name = _tokenName;                                 // Set the name
112         decimals = _decimalUnits;                          // Set the decimals
113         symbol = _tokenSymbol;                             // Set the symbol
114         parentToken = WizzleGlobalToken(_parentToken);
115         parentSnapShotBlock = _parentSnapShotBlock;
116         transfersEnabled = _transfersEnabled;
117         creationBlock = block.number;
118     }
119 
120 
121 ///////////////////
122 // ERC20 Methods
123 ///////////////////
124 
125     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
126     /// @param _to The address of the recipient
127     /// @param _amount The amount of tokens to be transferred
128     /// @return Whether the transfer was successful or not
129     function transfer(address _to, uint256 _amount) public returns (bool success) {
130         require(transfersEnabled);
131         doTransfer(msg.sender, _to, _amount);
132         return true;
133     }
134 
135     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
136     ///  is approved by `_from`
137     /// @param _from The address holding the tokens being transferred
138     /// @param _to The address of the recipient
139     /// @param _amount The amount of tokens to be transferred
140     /// @return True if the transfer was successful
141     function transferFrom(address _from, address _to, uint256 _amount
142     ) public returns (bool success) {
143 
144         // The controller of this contract can move tokens around at will,
145         //  this is important to recognize! Confirm that you trust the
146         //  controller of this contract, which in most situations should be
147         //  another open source smart contract or 0x0
148         if (msg.sender != controller) {
149             require(transfersEnabled);
150 
151             // The standard ERC 20 transferFrom functionality
152             require(allowed[_from][msg.sender] >= _amount);
153             allowed[_from][msg.sender] -= _amount;
154         }
155         doTransfer(_from, _to, _amount);
156         return true;
157     }
158 
159     /// @dev This is the actual transfer function in the token contract, it can
160     ///  only be called by other functions in this contract.
161     /// @param _from The address holding the tokens being transferred
162     /// @param _to The address of the recipient
163     /// @param _amount The amount of tokens to be transferred
164     /// @return True if the transfer was successful
165     function doTransfer(address _from, address _to, uint _amount
166     ) internal {
167 
168            if (_amount == 0) {
169                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
170                return;
171            }
172 
173            require(parentSnapShotBlock < block.number);
174 
175            // Do not allow transfer to 0x0 or the token contract itself
176            require((_to != 0) && (_to != address(this)));
177 
178            // If the amount being transfered is more than the balance of the
179            //  account the transfer throws
180            var previousBalanceFrom = balanceOfAt(_from, block.number);
181 
182            require(previousBalanceFrom >= _amount);
183 
184            // Alerts the token controller of the transfer
185            if (isContract(controller)) {
186                require(TokenController(controller).onTransfer(_from, _to, _amount));
187            }
188 
189            // First update the balance array with the new value for the address
190            //  sending the tokens
191            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
192 
193            // Then update the balance array with the new value for the address
194            //  receiving the tokens
195            var previousBalanceTo = balanceOfAt(_to, block.number);
196            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
197            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
198 
199            // An event to make the transfer easy to find on the blockchain
200            Transfer(_from, _to, _amount);
201 
202     }
203 
204     /// @param _owner The address that's balance is being requested
205     /// @return The balance of `_owner` at the current block
206     function balanceOf(address _owner) public constant returns (uint256 balance) {
207         return balanceOfAt(_owner, block.number);
208     }
209 
210     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
211     ///  its behalf. This is a modified version of the ERC20 approve function
212     ///  to be a little bit safer
213     /// @param _spender The address of the account able to transfer the tokens
214     /// @param _amount The amount of tokens to be approved for transfer
215     /// @return True if the approval was successful
216     function approve(address _spender, uint256 _amount) public returns (bool success) {
217         require(transfersEnabled);
218 
219         // To change the approve amount you first have to reduce the addresses`
220         //  allowance to zero by calling `approve(_spender,0)` if it is not
221         //  already 0 to mitigate the race condition described here:
222         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
224 
225         // Alerts the token controller of the approve function call
226         if (isContract(controller)) {
227             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
228         }
229 
230         allowed[msg.sender][_spender] = _amount;
231         Approval(msg.sender, _spender, _amount);
232         return true;
233     }
234 
235     /// @dev This function makes it easy to read the `allowed[]` map
236     /// @param _owner The address of the account that owns the token
237     /// @param _spender The address of the account able to transfer the tokens
238     /// @return Amount of remaining tokens of _owner that _spender is allowed
239     ///  to spend
240     function allowance(address _owner, address _spender
241     ) public constant returns (uint256 remaining) {
242         return allowed[_owner][_spender];
243     }
244 
245     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
246     ///  its behalf, and then a function is triggered in the contract that is
247     ///  being approved, `_spender`. This allows users to use their tokens to
248     ///  interact with contracts in one function call instead of two
249     /// @param _spender The address of the contract able to transfer the tokens
250     /// @param _amount The amount of tokens to be approved for transfer
251     /// @return True if the function call was successful
252     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
253     ) public returns (bool success) {
254         require(approve(_spender, _amount));
255 
256         ApproveAndCallFallBack(_spender).receiveApproval(
257             msg.sender,
258             _amount,
259             this,
260             _extraData
261         );
262 
263         return true;
264     }
265 
266     /// @dev This function makes it easy to get the total number of tokens
267     /// @return The total number of tokens
268     function totalSupply() public constant returns (uint) {
269         return totalSupplyAt(block.number);
270     }
271 
272 
273 ////////////////
274 // Query balance and totalSupply in History
275 ////////////////
276 
277     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
278     /// @param _owner The address from which the balance will be retrieved
279     /// @param _blockNumber The block number when the balance is queried
280     /// @return The balance at `_blockNumber`
281     function balanceOfAt(address _owner, uint _blockNumber) public constant
282         returns (uint) {
283 
284         // These next few lines are used when the balance of the token is
285         //  requested before a check point was ever created for this token, it
286         //  requires that the `parentToken.balanceOfAt` be queried at the
287         //  genesis block for that token as this contains initial balance of
288         //  this token
289         if ((balances[_owner].length == 0)
290             || (balances[_owner][0].fromBlock > _blockNumber)) {
291             if (address(parentToken) != 0) {
292                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
293             } else {
294                 // Has no parent
295                 return 0;
296             }
297 
298         // This will return the expected balance during normal situations
299         } else {
300             return getValueAt(balances[_owner], _blockNumber);
301         }
302     }
303 
304     /// @notice Total amount of tokens at a specific `_blockNumber`.
305     /// @param _blockNumber The block number when the totalSupply is queried
306     /// @return The total amount of tokens at `_blockNumber`
307     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
308 
309         // These next few lines are used when the totalSupply of the token is
310         //  requested before a check point was ever created for this token, it
311         //  requires that the `parentToken.totalSupplyAt` be queried at the
312         //  genesis block for this token as that contains totalSupply of this
313         //  token at this block number.
314         if ((totalSupplyHistory.length == 0)
315             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
316             if (address(parentToken) != 0) {
317                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
318             } else {
319                 return 0;
320             }
321 
322         // This will return the expected totalSupply during normal situations
323         } else {
324             return getValueAt(totalSupplyHistory, _blockNumber);
325         }
326     }
327 
328 ////////////////
329 // Clone Token Method
330 ////////////////
331 
332     /// @notice Creates a new clone token with the initial distribution being
333     ///  this token at `_snapshotBlock`
334     /// @param _cloneTokenName Name of the clone token
335     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
336     /// @param _cloneTokenSymbol Symbol of the clone token
337     /// @param _snapshotBlock Block when the distribution of the parent token is
338     ///  copied to set the initial distribution of the new clone token;
339     ///  if the block is zero than the actual block, the current block is used
340     /// @param _transfersEnabled True if transfers are allowed in the clone
341     /// @return The address of the new WizzleGlobalToken Contract
342     function createCloneToken(
343         string _cloneTokenName,
344         uint8 _cloneDecimalUnits,
345         string _cloneTokenSymbol,
346         uint _snapshotBlock,
347         bool _transfersEnabled
348         ) public returns(address) {
349 
350         if (_snapshotBlock == 0) 
351             _snapshotBlock = block.number;
352 
353         WizzleGlobalToken cloneToken = tokenFactory.createCloneToken(
354             this,
355             _snapshotBlock,
356             _cloneTokenName,
357             _cloneDecimalUnits,
358             _cloneTokenSymbol,
359             _transfersEnabled
360             );
361 
362         cloneToken.changeController(msg.sender);
363 
364         // An event to make the token easy to find on the blockchain
365         NewCloneToken(address(cloneToken), _snapshotBlock);
366         return address(cloneToken);
367     }
368 
369 ////////////////
370 // Generate and destroy tokens
371 ////////////////
372 
373     /// @notice Generates `_amount` tokens that are assigned to `_owner`
374     /// @param _owner The address that will be assigned the new tokens
375     /// @param _amount The quantity of tokens generated
376     /// @return True if the tokens are generated correctly
377     function generateTokens(address _owner, uint _amount
378     ) public onlyController returns (bool) {
379         uint curTotalSupply = totalSupply();
380         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
381         uint previousBalanceTo = balanceOf(_owner);
382         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
383         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
384         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
385         Transfer(0, _owner, _amount);
386         return true;
387     }
388 
389 ////////////////
390 // Enable tokens transfers
391 ////////////////
392 
393 
394     /// @notice Enables token holders to transfer their tokens freely if true
395     /// @param _transfersEnabled True if transfers are allowed in the clone
396     function enableTransfers(bool _transfersEnabled) public onlyController {
397         transfersEnabled = _transfersEnabled;
398     }
399 
400 ////////////////
401 // Internal helper functions to query and set a value in a snapshot array
402 ////////////////
403 
404     /// @dev `getValueAt` retrieves the number of tokens at a given block number
405     /// @param checkpoints The history of values being queried
406     /// @param _block The block number to retrieve the value at
407     /// @return The number of tokens being queried
408     function getValueAt(Checkpoint[] storage checkpoints, uint _block
409     ) constant internal returns (uint) {
410         if (checkpoints.length == 0) return 0;
411 
412         // Shortcut for the actual value
413         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
414             return checkpoints[checkpoints.length-1].value;
415         if (_block < checkpoints[0].fromBlock) return 0;
416 
417         // Binary search of the value in the array
418         uint min = 0;
419         uint max = checkpoints.length-1;
420         while (max > min) {
421             uint mid = (max + min + 1)/ 2;
422             if (checkpoints[mid].fromBlock<=_block) {
423                 min = mid;
424             } else {
425                 max = mid-1;
426             }
427         }
428         return checkpoints[min].value;
429     }
430 
431     /// @dev `updateValueAtNow` used to update the `balances` map and the
432     ///  `totalSupplyHistory`
433     /// @param checkpoints The history of data being updated
434     /// @param _value The new number of tokens
435     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
436     ) internal  {
437         if ((checkpoints.length == 0)
438         || (checkpoints[checkpoints.length-1].fromBlock < block.number)) {
439                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
440                newCheckPoint.fromBlock =  uint128(block.number);
441                newCheckPoint.value = uint128(_value);
442            } else {
443                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
444                oldCheckPoint.value = uint128(_value);
445            }
446     }
447 
448     /// @dev Internal function to determine if an address is a contract
449     /// @param _addr The address being queried
450     /// @return True if `_addr` is a contract
451     function isContract(address _addr) constant internal returns(bool) {
452         uint size;
453         if (_addr == 0) return false;
454         assembly {
455             size := extcodesize(_addr)
456         }
457         return size>0;
458     }
459 
460     /// @dev Helper function to return a min betwen the two uints
461     function min(uint a, uint b) pure internal returns (uint) {
462         return a < b ? a : b;
463     }
464 
465     /// @notice The fallback function: If the contract's controller has not been
466     ///  set to 0, then the `proxyPayment` method is called which relays the
467     ///  ether and creates tokens as described in the token controller contract
468     function () public payable {
469         require(isContract(controller));
470         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
471     }
472 
473 //////////
474 // Safety Methods
475 //////////
476 
477     /// @notice This method can be used by the controller to extract mistakenly
478     ///  sent tokens to this contract.
479     /// @param _token The address of the token contract that you want to recover
480     ///  set to 0 in case you want to extract ether.
481     function claimTokens(address _token) public onlyController {
482         if (_token == 0x0) {
483             controller.transfer(this.balance);
484             return;
485         }
486 
487         WizzleGlobalToken token = WizzleGlobalToken(_token);
488         uint balance = token.balanceOf(this);
489         token.transfer(controller, balance);
490         ClaimedTokens(_token, controller, balance);
491     }
492 
493 ////////////////
494 // Events
495 ////////////////
496     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
497     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
498     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
499     event Approval(
500         address indexed _owner,
501         address indexed _spender,
502         uint256 _amount
503         );
504 
505 }
506 
507 ////////////////
508 // WizzleGlobalTokenFactory
509 ////////////////
510 
511 /// @dev This contract is used to generate clone contracts from a contract.
512 ///  In solidity this is the way to create a contract from a contract of the
513 ///  same class
514 contract WizzleGlobalTokenFactory {
515 
516     /// @notice Update the DApp by creating a new token with new functionalities
517     ///  the msg.sender becomes the controller of this clone token
518     /// @param _parentToken Address of the token being cloned
519     /// @param _snapshotBlock Block of the parent token that will
520     ///  determine the initial distribution of the clone token
521     /// @param _tokenName Name of the new token
522     /// @param _decimalUnits Number of decimals of the new token
523     /// @param _tokenSymbol Token Symbol for the new token
524     /// @param _transfersEnabled If true, tokens will be able to be transferred
525     /// @return The address of the new token contract
526     function createCloneToken(
527         address _parentToken,
528         uint _snapshotBlock,
529         string _tokenName,
530         uint8 _decimalUnits,
531         string _tokenSymbol,
532         bool _transfersEnabled
533     ) public returns (WizzleGlobalToken) {
534         WizzleGlobalToken newToken = new WizzleGlobalToken(
535             this,
536             _parentToken,
537             _snapshotBlock,
538             _tokenName,
539             _decimalUnits,
540             _tokenSymbol,
541             _transfersEnabled
542             );
543 
544         newToken.changeController(msg.sender);
545         return newToken;
546     }
547 }