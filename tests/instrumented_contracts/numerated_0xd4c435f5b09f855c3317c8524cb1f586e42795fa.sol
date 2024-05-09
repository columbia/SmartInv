1 pragma solidity ^0.4.15;
2 
3 contract TokenController {
4     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
5     /// @param _owner The address that sent the ether to create tokens
6     /// @return True if the ether is accepted, false if it throws
7     function proxyPayment(address _owner) payable returns(bool);
8 
9     /// @notice Notifies the controller about a token transfer allowing the
10     ///  controller to react if desired
11     /// @param _from The origin of the transfer
12     /// @param _to The destination of the transfer
13     /// @param _amount The amount of the transfer
14     /// @return False if the controller does not authorize the transfer
15     function onTransfer(address _from, address _to, uint _amount) returns(bool);
16 
17     /// @notice Notifies the controller about an approval allowing the
18     ///  controller to react if desired
19     /// @param _owner The address that calls `approve()`
20     /// @param _spender The spender in the `approve()` call
21     /// @param _amount The amount in the `approve()` call
22     /// @return False if the controller does not authorize the approval
23     function onApprove(address _owner, address _spender, uint _amount)
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
34     function Controlled() { controller = msg.sender;}
35 
36     /// @notice Changes the controller of the contract
37     /// @param _newController The new controller of the contract
38     function changeController(address _newController) onlyController {
39         controller = _newController;
40     }
41 }
42 
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
45 }
46 
47 contract MiniMeToken is Controlled {
48 
49     string public name;                //The Token's name: e.g. DigixDAO Tokens
50     uint8 public decimals;             //Number of decimals of the smallest unit
51     string public symbol;              //An identifier: e.g. REP
52     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
53 
54 
55     /// @dev `Checkpoint` is the structure that attaches a block number to a
56     ///  given value, the block number attached is the one that last changed the
57     ///  value
58     struct  Checkpoint {
59 
60         // `fromBlock` is the block number that the value was generated from
61         uint128 fromBlock;
62 
63         // `value` is the amount of tokens at a specific block number
64         uint128 value;
65     }
66 
67     // `parentToken` is the Token address that was cloned to produce this token;
68     //  it will be 0x0 for a token that was not cloned
69     MiniMeToken public parentToken;
70 
71     // `parentSnapShotBlock` is the block number from the Parent Token that was
72     //  used to determine the initial distribution of the Clone Token
73     uint public parentSnapShotBlock;
74 
75     // `creationBlock` is the block number that the Clone Token was created
76     uint public creationBlock;
77 
78     // `balances` is the map that tracks the balance of each address, in this
79     //  contract when the balance changes the block number that the change
80     //  occurred is also included in the map
81     mapping (address => Checkpoint[]) balances;
82 
83     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
84     mapping (address => mapping (address => uint256)) allowed;
85 
86     // Tracks the history of the `totalSupply` of the token
87     Checkpoint[] totalSupplyHistory;
88 
89     // Flag that determines if the token is transferable or not.
90     bool public transfersEnabled;
91 
92     // The factory used to create new clone tokens
93     MiniMeTokenFactory public tokenFactory;
94 
95 ////////////////
96 // Constructor
97 ////////////////
98 
99     /// @notice Constructor to create a MiniMeToken
100     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
101     ///  will create the Clone token contracts, the token factory needs to be
102     ///  deployed first
103     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
104     ///  new token
105     /// @param _parentSnapShotBlock Block of the parent token that will
106     ///  determine the initial distribution of the clone token, set to 0 if it
107     ///  is a new token
108     /// @param _tokenName Name of the new token
109     /// @param _decimalUnits Number of decimals of the new token
110     /// @param _tokenSymbol Token Symbol for the new token
111     /// @param _transfersEnabled If true, tokens will be able to be transferred
112     function MiniMeToken(
113         address _tokenFactory,
114         address _parentToken,
115         uint _parentSnapShotBlock,
116         string _tokenName,
117         uint8 _decimalUnits,
118         string _tokenSymbol,
119         bool _transfersEnabled
120     ) {
121         tokenFactory = MiniMeTokenFactory(_tokenFactory);
122         name = _tokenName;                                 // Set the name
123         decimals = _decimalUnits;                          // Set the decimals
124         symbol = _tokenSymbol;                             // Set the symbol
125         parentToken = MiniMeToken(_parentToken);
126         parentSnapShotBlock = _parentSnapShotBlock;
127         transfersEnabled = _transfersEnabled;
128         creationBlock = block.number;
129     }
130 
131 
132 ///////////////////
133 // ERC20 Methods
134 ///////////////////
135 
136     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
137     /// @param _to The address of the recipient
138     /// @param _amount The amount of tokens to be transferred
139     /// @return Whether the transfer was successful or not
140     function transfer(address _to, uint256 _amount) returns (bool success) {
141         require(transfersEnabled);
142         return doTransfer(msg.sender, _to, _amount);
143     }
144 
145     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
146     ///  is approved by `_from`
147     /// @param _from The address holding the tokens being transferred
148     /// @param _to The address of the recipient
149     /// @param _amount The amount of tokens to be transferred
150     /// @return True if the transfer was successful
151     function transferFrom(address _from, address _to, uint256 _amount
152     ) returns (bool success) {
153 
154         // The controller of this contract can move tokens around at will,
155         //  this is important to recognize! Confirm that you trust the
156         //  controller of this contract, which in most situations should be
157         //  another open source smart contract or 0x0
158         if (msg.sender != controller) {
159             require(transfersEnabled);
160 
161             // The standard ERC 20 transferFrom functionality
162             if (allowed[_from][msg.sender] < _amount) return false;
163             allowed[_from][msg.sender] -= _amount;
164         }
165         return doTransfer(_from, _to, _amount);
166     }
167 
168     /// @dev This is the actual transfer function in the token contract, it can
169     ///  only be called by other functions in this contract.
170     /// @param _from The address holding the tokens being transferred
171     /// @param _to The address of the recipient
172     /// @param _amount The amount of tokens to be transferred
173     /// @return True if the transfer was successful
174     function doTransfer(address _from, address _to, uint _amount
175     ) internal returns(bool) {
176 
177            if (_amount == 0) {
178                return true;
179            }
180 
181            require(parentSnapShotBlock < block.number);
182 
183            // Do not allow transfer to 0x0 or the token contract itself
184            require((_to != 0) && (_to != address(this)));
185 
186            // If the amount being transfered is more than the balance of the
187            //  account the transfer returns false
188            var previousBalanceFrom = balanceOfAt(_from, block.number);
189            if (previousBalanceFrom < _amount) {
190                return false;
191            }
192 
193            // Alerts the token controller of the transfer
194            if (isContract(controller)) {
195                require(TokenController(controller).onTransfer(_from, _to, _amount));
196            }
197 
198            // First update the balance array with the new value for the address
199            //  sending the tokens
200            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
201 
202            // Then update the balance array with the new value for the address
203            //  receiving the tokens
204            var previousBalanceTo = balanceOfAt(_to, block.number);
205            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
206            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
207 
208            // An event to make the transfer easy to find on the blockchain
209            Transfer(_from, _to, _amount);
210 
211            return true;
212     }
213 
214     /// @param _owner The address that's balance is being requested
215     /// @return The balance of `_owner` at the current block
216     function balanceOf(address _owner) constant returns (uint256 balance) {
217         return balanceOfAt(_owner, block.number);
218     }
219 
220     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
221     ///  its behalf. This is a modified version of the ERC20 approve function
222     ///  to be a little bit safer
223     /// @param _spender The address of the account able to transfer the tokens
224     /// @param _amount The amount of tokens to be approved for transfer
225     /// @return True if the approval was successful
226     function approve(address _spender, uint256 _amount) returns (bool success) {
227         require(transfersEnabled);
228 
229         // To change the approve amount you first have to reduce the addresses`
230         //  allowance to zero by calling `approve(_spender,0)` if it is not
231         //  already 0 to mitigate the race condition described here:
232         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
234 
235         // Alerts the token controller of the approve function call
236         if (isContract(controller)) {
237             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
238         }
239 
240         allowed[msg.sender][_spender] = _amount;
241         Approval(msg.sender, _spender, _amount);
242         return true;
243     }
244 
245     /// @dev This function makes it easy to read the `allowed[]` map
246     /// @param _owner The address of the account that owns the token
247     /// @param _spender The address of the account able to transfer the tokens
248     /// @return Amount of remaining tokens of _owner that _spender is allowed
249     ///  to spend
250     function allowance(address _owner, address _spender
251     ) constant returns (uint256 remaining) {
252         return allowed[_owner][_spender];
253     }
254 
255     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
256     ///  its behalf, and then a function is triggered in the contract that is
257     ///  being approved, `_spender`. This allows users to use their tokens to
258     ///  interact with contracts in one function call instead of two
259     /// @param _spender The address of the contract able to transfer the tokens
260     /// @param _amount The amount of tokens to be approved for transfer
261     /// @return True if the function call was successful
262     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
263     ) returns (bool success) {
264         require(approve(_spender, _amount));
265 
266         ApproveAndCallFallBack(_spender).receiveApproval(
267             msg.sender,
268             _amount,
269             this,
270             _extraData
271         );
272 
273         return true;
274     }
275 
276     /// @dev This function makes it easy to get the total number of tokens
277     /// @return The total number of tokens
278     function totalSupply() constant returns (uint) {
279         return totalSupplyAt(block.number);
280     }
281 
282 
283 ////////////////
284 // Query balance and totalSupply in History
285 ////////////////
286 
287     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
288     /// @param _owner The address from which the balance will be retrieved
289     /// @param _blockNumber The block number when the balance is queried
290     /// @return The balance at `_blockNumber`
291     function balanceOfAt(address _owner, uint _blockNumber) constant
292         returns (uint) {
293 
294         // These next few lines are used when the balance of the token is
295         //  requested before a check point was ever created for this token, it
296         //  requires that the `parentToken.balanceOfAt` be queried at the
297         //  genesis block for that token as this contains initial balance of
298         //  this token
299         if ((balances[_owner].length == 0)
300             || (balances[_owner][0].fromBlock > _blockNumber)) {
301             if (address(parentToken) != 0) {
302                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
303             } else {
304                 // Has no parent
305                 return 0;
306             }
307 
308         // This will return the expected balance during normal situations
309         } else {
310             return getValueAt(balances[_owner], _blockNumber);
311         }
312     }
313 
314     /// @notice Total amount of tokens at a specific `_blockNumber`.
315     /// @param _blockNumber The block number when the totalSupply is queried
316     /// @return The total amount of tokens at `_blockNumber`
317     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
318 
319         // These next few lines are used when the totalSupply of the token is
320         //  requested before a check point was ever created for this token, it
321         //  requires that the `parentToken.totalSupplyAt` be queried at the
322         //  genesis block for this token as that contains totalSupply of this
323         //  token at this block number.
324         if ((totalSupplyHistory.length == 0)
325             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
326             if (address(parentToken) != 0) {
327                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
328             } else {
329                 return 0;
330             }
331 
332         // This will return the expected totalSupply during normal situations
333         } else {
334             return getValueAt(totalSupplyHistory, _blockNumber);
335         }
336     }
337 
338 ////////////////
339 // Clone Token Method
340 ////////////////
341 
342     /// @notice Creates a new clone token with the initial distribution being
343     ///  this token at `_snapshotBlock`
344     /// @param _cloneTokenName Name of the clone token
345     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
346     /// @param _cloneTokenSymbol Symbol of the clone token
347     /// @param _snapshotBlock Block when the distribution of the parent token is
348     ///  copied to set the initial distribution of the new clone token;
349     ///  if the block is zero than the actual block, the current block is used
350     /// @param _transfersEnabled True if transfers are allowed in the clone
351     /// @return The address of the new MiniMeToken Contract
352     function createCloneToken(
353         string _cloneTokenName,
354         uint8 _cloneDecimalUnits,
355         string _cloneTokenSymbol,
356         uint _snapshotBlock,
357         bool _transfersEnabled
358         ) returns(address) {
359         if (_snapshotBlock == 0) _snapshotBlock = block.number;
360         MiniMeToken cloneToken = tokenFactory.createCloneToken(
361             this,
362             _snapshotBlock,
363             _cloneTokenName,
364             _cloneDecimalUnits,
365             _cloneTokenSymbol,
366             _transfersEnabled
367             );
368 
369         cloneToken.changeController(msg.sender);
370 
371         // An event to make the token easy to find on the blockchain
372         NewCloneToken(address(cloneToken), _snapshotBlock);
373         return address(cloneToken);
374     }
375 
376 ////////////////
377 // Generate and destroy tokens
378 ////////////////
379 
380     /// @notice Generates `_amount` tokens that are assigned to `_owner`
381     /// @param _owner The address that will be assigned the new tokens
382     /// @param _amount The quantity of tokens generated
383     /// @return True if the tokens are generated correctly
384     function generateTokens(address _owner, uint _amount
385     ) onlyController returns (bool) {
386         uint curTotalSupply = totalSupply();
387         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
388         uint previousBalanceTo = balanceOf(_owner);
389         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
390         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
391         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
392         Transfer(0, _owner, _amount);
393         return true;
394     }
395 
396 
397     /// @notice Burns `_amount` tokens from `_owner`
398     /// @param _owner The address that will lose the tokens
399     /// @param _amount The quantity of tokens to burn
400     /// @return True if the tokens are burned correctly
401     function destroyTokens(address _owner, uint _amount
402     ) onlyController returns (bool) {
403         uint curTotalSupply = totalSupply();
404         require(curTotalSupply >= _amount);
405         uint previousBalanceFrom = balanceOf(_owner);
406         require(previousBalanceFrom >= _amount);
407         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
408         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
409         Transfer(_owner, 0, _amount);
410         return true;
411     }
412 
413 ////////////////
414 // Enable tokens transfers
415 ////////////////
416 
417 
418     /// @notice Enables token holders to transfer their tokens freely if true
419     /// @param _transfersEnabled True if transfers are allowed in the clone
420     function enableTransfers(bool _transfersEnabled) onlyController {
421         transfersEnabled = _transfersEnabled;
422     }
423 
424 ////////////////
425 // Internal helper functions to query and set a value in a snapshot array
426 ////////////////
427 
428     /// @dev `getValueAt` retrieves the number of tokens at a given block number
429     /// @param checkpoints The history of values being queried
430     /// @param _block The block number to retrieve the value at
431     /// @return The number of tokens being queried
432     function getValueAt(Checkpoint[] storage checkpoints, uint _block
433     ) constant internal returns (uint) {
434         if (checkpoints.length == 0) return 0;
435 
436         // Shortcut for the actual value
437         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
438             return checkpoints[checkpoints.length-1].value;
439         if (_block < checkpoints[0].fromBlock) return 0;
440 
441         // Binary search of the value in the array
442         uint min = 0;
443         uint max = checkpoints.length-1;
444         while (max > min) {
445             uint mid = (max + min + 1)/ 2;
446             if (checkpoints[mid].fromBlock<=_block) {
447                 min = mid;
448             } else {
449                 max = mid-1;
450             }
451         }
452         return checkpoints[min].value;
453     }
454 
455     /// @dev `updateValueAtNow` used to update the `balances` map and the
456     ///  `totalSupplyHistory`
457     /// @param checkpoints The history of data being updated
458     /// @param _value The new number of tokens
459     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
460     ) internal  {
461         if ((checkpoints.length == 0)
462         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
463                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
464                newCheckPoint.fromBlock =  uint128(block.number);
465                newCheckPoint.value = uint128(_value);
466            } else {
467                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
468                oldCheckPoint.value = uint128(_value);
469            }
470     }
471 
472     /// @dev Internal function to determine if an address is a contract
473     /// @param _addr The address being queried
474     /// @return True if `_addr` is a contract
475     function isContract(address _addr) constant internal returns(bool) {
476         uint size;
477         if (_addr == 0) return false;
478         assembly {
479             size := extcodesize(_addr)
480         }
481         return size>0;
482     }
483 
484     /// @dev Helper function to return a min betwen the two uints
485     function min(uint a, uint b) internal returns (uint) {
486         return a < b ? a : b;
487     }
488 
489     /// @notice The fallback function: If the contract's controller has not been
490     ///  set to 0, then the `proxyPayment` method is called which relays the
491     ///  ether and creates tokens as described in the token controller contract
492     function ()  payable {
493         require(isContract(controller));
494         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
495     }
496 
497 //////////
498 // Safety Methods
499 //////////
500 
501     /// @notice This method can be used by the controller to extract mistakenly
502     ///  sent tokens to this contract.
503     /// @param _token The address of the token contract that you want to recover
504     ///  set to 0 in case you want to extract ether.
505     function claimTokens(address _token) public onlyController {
506         if (_token == 0x0) {
507             controller.transfer(this.balance);
508             return;
509         }
510 
511         MiniMeToken token = MiniMeToken(_token);
512         uint balance = token.balanceOf(this);
513         token.transfer(controller, balance);
514         ClaimedTokens(_token, controller, balance);
515     }
516 
517 ////////////////
518 // Events
519 ////////////////
520     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
521     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
522     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
523     event Approval(
524         address indexed _owner,
525         address indexed _spender,
526         uint256 _amount
527         );
528 
529 }
530 
531 contract CND is MiniMeToken {
532   /**
533     * @dev Constructor
534   */
535   uint256 public constant IS_CND_CONTRACT_MAGIC_NUMBER = 0x1338;
536   function CND(address _tokenFactory)
537     MiniMeToken(
538       _tokenFactory,
539       0x0,                      // no parent token
540       0,                        // no snapshot block number from parent
541       "Cindicator Token",   // Token name
542       18,                       // Decimals
543       "CND",                    // Symbol
544       true                      // Enable transfers
545     ) 
546     {}
547 
548     function() payable {
549       require(false);
550     }
551 }
552 
553 contract MiniMeTokenFactory {
554 
555     /// @notice Update the DApp by creating a new token with new functionalities
556     ///  the msg.sender becomes the controller of this clone token
557     /// @param _parentToken Address of the token being cloned
558     /// @param _snapshotBlock Block of the parent token that will
559     ///  determine the initial distribution of the clone token
560     /// @param _tokenName Name of the new token
561     /// @param _decimalUnits Number of decimals of the new token
562     /// @param _tokenSymbol Token Symbol for the new token
563     /// @param _transfersEnabled If true, tokens will be able to be transferred
564     /// @return The address of the new token contract
565     function createCloneToken(
566         address _parentToken,
567         uint _snapshotBlock,
568         string _tokenName,
569         uint8 _decimalUnits,
570         string _tokenSymbol,
571         bool _transfersEnabled
572     ) returns (MiniMeToken) {
573         MiniMeToken newToken = new MiniMeToken(
574             this,
575             _parentToken,
576             _snapshotBlock,
577             _tokenName,
578             _decimalUnits,
579             _tokenSymbol,
580             _transfersEnabled
581             );
582 
583         newToken.changeController(msg.sender);
584         return newToken;
585     }
586 }