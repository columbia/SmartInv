1 pragma solidity ^0.4.13;
2 
3 contract Controlled {
4     /// @notice The address of the controller is the only address that can call
5     ///  a function with this modifier
6     modifier onlyController { require(msg.sender == controller); _; }
7 
8     address public controller;
9 
10     constructor() public { controller = msg.sender;}
11 
12     /// @notice Changes the controller of the contract
13     /// @param _newController The new controller of the contract
14     function changeController(address _newController) public onlyController {
15         controller = _newController;
16     }
17 }
18 
19 contract MiniMeToken is Controlled {
20 
21     string public name;                //The Token's name: e.g. DigixDAO Tokens
22     uint8 public decimals;             //Number of decimals of the smallest unit
23     string public symbol;              //An identifier: e.g. REP
24     string public version = "MMT_0.2"; //An arbitrary versioning scheme
25 
26 
27     /// @dev `Checkpoint` is the structure that attaches a block number to a
28     ///  given value, the block number attached is the one that last changed the
29     ///  value
30     struct  Checkpoint {
31 
32         // `fromBlock` is the block number that the value was generated from
33         uint128 fromBlock;
34 
35         // `value` is the amount of tokens at a specific block number
36         uint128 value;
37     }
38 
39     // `parentToken` is the Token address that was cloned to produce this token;
40     //  it will be 0x0 for a token that was not cloned
41     MiniMeToken public parentToken;
42 
43     // `parentSnapShotBlock` is the block number from the Parent Token that was
44     //  used to determine the initial distribution of the Clone Token
45     uint256 public parentSnapShotBlock;
46 
47     // `creationBlock` is the block number that the Clone Token was created
48     uint256 public creationBlock;
49 
50     // `balances` is the map that tracks the balance of each address, in this
51     //  contract when the balance changes the block number that the change
52     //  occurred is also included in the map
53     mapping (address => Checkpoint[]) balances;
54 
55     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
56     mapping (address => mapping (address => uint256)) allowed;
57 
58     // Tracks the history of the `totalSupply` of the token
59     Checkpoint[] totalSupplyHistory;
60 
61     // Flag that determines if the token is transferable or not.
62     bool public transfersEnabled;
63 
64 ////////////////
65 // Constructor
66 ////////////////
67 
68     /// @notice Constructor to create a MiniMeToken
69     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
70     ///  new token
71     /// @param _parentSnapShotBlock Block of the parent token that will
72     ///  determine the initial distribution of the clone token, set to 0 if it
73     ///  is a new token
74     /// @param _tokenName Name of the new token
75     /// @param _decimalUnits Number of decimals of the new token
76     /// @param _tokenSymbol Token Symbol for the new token
77     /// @param _transfersEnabled If true, tokens will be able to be transferred
78     constructor(
79         address _parentToken,
80         uint256 _parentSnapShotBlock,
81         string _tokenName,
82         uint8 _decimalUnits,
83         string _tokenSymbol,
84         bool _transfersEnabled
85     ) public {
86         name = _tokenName;                                 // Set the name
87         decimals = _decimalUnits;                          // Set the decimals
88         symbol = _tokenSymbol;                             // Set the symbol
89         parentToken = MiniMeToken(_parentToken);
90         parentSnapShotBlock = _parentSnapShotBlock;
91         transfersEnabled = _transfersEnabled;
92         creationBlock = block.number;
93     }
94 
95 
96 ///////////////////
97 // ERC20 Methods
98 ///////////////////
99 
100     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
101     /// @param _to The address of the recipient
102     /// @param _amount The amount of tokens to be transferred
103     /// @return Whether the transfer was successful or not
104     function transfer(address _to, uint256 _amount) public returns (bool success) {
105         require(transfersEnabled);
106         doTransfer(msg.sender, _to, _amount);
107         return true;
108     }
109 
110     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
111     ///  is approved by `_from`
112     /// @param _from The address holding the tokens being transferred
113     /// @param _to The address of the recipient
114     /// @param _amount The amount of tokens to be transferred
115     /// @return True if the transfer was successful
116     function transferFrom(address _from, address _to, uint256 _amount
117     ) public returns (bool success) {
118 
119         // The controller of this contract can move tokens around at will,
120         //  this is important to recognize! Confirm that you trust the
121         //  controller of this contract, which in most situations should be
122         //  another open source smart contract or 0x0
123         if (msg.sender != controller) {
124             require(transfersEnabled);
125 
126             // The standard ERC 20 transferFrom functionality
127             require(allowed[_from][msg.sender] >= _amount);
128             allowed[_from][msg.sender] -= _amount;
129         }
130         doTransfer(_from, _to, _amount);
131         return true;
132     }
133 
134     /// @dev This is the actual transfer function in the token contract, it can
135     ///  only be called by other functions in this contract.
136     /// @param _from The address holding the tokens being transferred
137     /// @param _to The address of the recipient
138     /// @param _amount The amount of tokens to be transferred
139     /// @return True if the transfer was successful
140     function doTransfer(address _from, address _to, uint256 _amount
141     ) internal {
142 
143         if (_amount == 0) {
144             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
145             return;
146         }
147 
148         require(parentSnapShotBlock < block.number);
149 
150         // Do not allow transfer to 0x0 or the token contract itself
151         require((_to != 0) && (_to != address(this)));
152 
153         // If the amount being transfered is more than the balance of the
154         //  account the transfer throws
155         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
156 
157         require(previousBalanceFrom >= _amount);
158 
159         // Alerts the token controller of the transfer
160         if (isContract(controller)) {
161             require(TokenController(controller).onTransfer(_from, _to, _amount));
162         }
163 
164         // First update the balance array with the new value for the address
165         //  sending the tokens
166         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
167 
168         // Then update the balance array with the new value for the address
169         //  receiving the tokens
170         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
171         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
172         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
173 
174         // An event to make the transfer easy to find on the blockchain
175         emit Transfer(_from, _to, _amount);
176 
177     }
178 
179     /// @param _owner The address that's balance is being requested
180     /// @return The balance of `_owner` at the current block
181     function balanceOf(address _owner) public view returns (uint256 balance) {
182         return balanceOfAt(_owner, block.number);
183     }
184 
185     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
186     ///  its behalf. This is a modified version of the ERC20 approve function
187     ///  to be a little bit safer
188     /// @param _spender The address of the account able to transfer the tokens
189     /// @param _amount The amount of tokens to be approved for transfer
190     /// @return True if the approval was successful
191     function approve(address _spender, uint256 _amount) public returns (bool success) {
192         require(transfersEnabled);
193 
194         // To change the approve amount you first have to reduce the addresses`
195         //  allowance to zero by calling `approve(_spender,0)` if it is not
196         //  already 0 to mitigate the race condition described here:
197         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
199 
200         // Alerts the token controller of the approve function call
201         if (isContract(controller)) {
202             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
203         }
204 
205         allowed[msg.sender][_spender] = _amount;
206         emit Approval(msg.sender, _spender, _amount);
207         return true;
208     }
209 
210     /// @dev This function makes it easy to read the `allowed[]` map
211     /// @param _owner The address of the account that owns the token
212     /// @param _spender The address of the account able to transfer the tokens
213     /// @return Amount of remaining tokens of _owner that _spender is allowed
214     ///  to spend
215     function allowance(address _owner, address _spender
216     ) public view returns (uint256 remaining) {
217         return allowed[_owner][_spender];
218     }
219 
220     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
221     ///  its behalf, and then a function is triggered in the contract that is
222     ///  being approved, `_spender`. This allows users to use their tokens to
223     ///  interact with contracts in one function call instead of two
224     /// @param _spender The address of the contract able to transfer the tokens
225     /// @param _amount The amount of tokens to be approved for transfer
226     /// @return True if the function call was successful
227     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
228     ) public returns (bool success) {
229         require(approve(_spender, _amount));
230 
231         if (isContract(_spender)) {
232             ApproveAndCallFallBack(_spender).receiveApproval(
233                 msg.sender,
234                 _amount,
235                 this,
236                 _extraData
237             );
238         }
239 
240         return true;
241     }
242 
243     /// @dev This function makes it easy to get the total number of tokens
244     /// @return The total number of tokens
245     function totalSupply() public view returns (uint256) {
246         return totalSupplyAt(block.number);
247     }
248 
249 
250 ////////////////
251 // Query balance and totalSupply in History
252 ////////////////
253 
254     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
255     /// @param _owner The address from which the balance will be retrieved
256     /// @param _blockNumber The block number when the balance is queried
257     /// @return The balance at `_blockNumber`
258     function balanceOfAt(address _owner, uint256 _blockNumber) public view
259         returns (uint256) {
260 
261         // These next few lines are used when the balance of the token is
262         //  requested before a check point was ever created for this token, it
263         //  requires that the `parentToken.balanceOfAt` be queried at the
264         //  genesis block for that token as this contains initial balance of
265         //  this token
266         if ((balances[_owner].length == 0)
267             || (balances[_owner][0].fromBlock > _blockNumber)) {
268             if (address(parentToken) != 0) {
269                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
270             } else {
271                 // Has no parent
272                 return 0;
273             }
274 
275         // This will return the expected balance during normal situations
276         } else {
277             return getValueAt(balances[_owner], _blockNumber);
278         }
279     }
280 
281     /// @notice Total amount of tokens at a specific `_blockNumber`.
282     /// @param _blockNumber The block number when the totalSupply is queried
283     /// @return The total amount of tokens at `_blockNumber`
284     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
285 
286         // These next few lines are used when the totalSupply of the token is
287         //  requested before a check point was ever created for this token, it
288         //  requires that the `parentToken.totalSupplyAt` be queried at the
289         //  genesis block for this token as that contains totalSupply of this
290         //  token at this block number.
291         if ((totalSupplyHistory.length == 0)
292             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
293             if (address(parentToken) != 0) {
294                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
295             } else {
296                 return 0;
297             }
298 
299         // This will return the expected totalSupply during normal situations
300         } else {
301             return getValueAt(totalSupplyHistory, _blockNumber);
302         }
303     }
304 
305 ////////////////
306 // Generate and destroy tokens
307 ////////////////
308 
309     /// @notice Generates `_amount` tokens that are assigned to `_owner`
310     /// @param _owner The address that will be assigned the new tokens
311     /// @param _amount The quantity of tokens generated
312     /// @return True if the tokens are generated correctly
313     function generateTokens(address _owner, uint256 _amount
314     ) public onlyController returns (bool) {
315         uint256 curTotalSupply = totalSupply();
316         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
317         uint256 previousBalanceTo = balanceOf(_owner);
318         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
319         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
320         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
321         emit Transfer(0, _owner, _amount);
322         return true;
323     }
324 
325 
326     /// @notice Burns `_amount` tokens from `_owner`
327     /// @param _owner The address that will lose the tokens
328     /// @param _amount The quantity of tokens to burn
329     /// @return True if the tokens are burned correctly
330     function destroyTokens(address _owner, uint256 _amount
331     ) onlyController public returns (bool) {
332         uint256 curTotalSupply = totalSupply();
333         require(curTotalSupply >= _amount);
334         uint256 previousBalanceFrom = balanceOf(_owner);
335         require(previousBalanceFrom >= _amount);
336         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
337         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
338         emit Transfer(_owner, 0, _amount);
339         return true;
340     }
341 
342 ////////////////
343 // Enable tokens transfers
344 ////////////////
345 
346 
347     /// @notice Enables token holders to transfer their tokens freely if true
348     /// @param _transfersEnabled True if transfers are allowed in the clone
349     function enableTransfers(bool _transfersEnabled) public onlyController {
350         transfersEnabled = _transfersEnabled;
351     }
352 
353 ////////////////
354 // Internal helper functions to query and set a value in a snapshot array
355 ////////////////
356 
357     /// @dev `getValueAt` retrieves the number of tokens at a given block number
358     /// @param checkpoints The history of values being queried
359     /// @param _block The block number to retrieve the value at
360     /// @return The number of tokens being queried
361     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block
362     ) view internal returns (uint256) {
363         if (checkpoints.length == 0) return 0;
364 
365         // Shortcut for the actual value
366         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
367             return checkpoints[checkpoints.length-1].value;
368         if (_block < checkpoints[0].fromBlock) return 0;
369 
370         // Binary search of the value in the array
371         uint256 min = 0;
372         uint256 max = checkpoints.length-1;
373         while (max > min) {
374             uint256 mid = (max + min + 1) / 2;
375             if (checkpoints[mid].fromBlock <= _block) {
376                 min = mid;
377             } else {
378                 max = mid - 1;
379             }
380         }
381         return checkpoints[min].value;
382     }
383 
384     /// @dev `updateValueAtNow` used to update the `balances` map and the
385     ///  `totalSupplyHistory`
386     /// @param checkpoints The history of data being updated
387     /// @param _value The new number of tokens
388     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value
389     ) internal  {
390         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
391             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
392             newCheckPoint.fromBlock = uint128(block.number);
393             newCheckPoint.value = uint128(_value);
394         } else {
395             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
396             oldCheckPoint.value = uint128(_value);
397         }
398     }
399 
400     /// @dev Internal function to determine if an address is a contract
401     /// @param _addr The address being queried
402     /// @return True if `_addr` is a contract
403     function isContract(address _addr) view internal returns(bool) {
404         uint256 size;
405         if (_addr == 0) return false;
406         assembly {
407             size := extcodesize(_addr)
408         }
409         return size>0;
410     }
411 
412     /// @dev Helper function to return a min betwen the two uints
413     function min(uint256 a, uint256 b) pure internal returns (uint256) {
414         return a < b ? a : b;
415     }
416 
417     /// @notice The fallback function: If the contract's controller has not been
418     ///  set to 0, then the `proxyPayment` method is called which relays the
419     ///  ether and creates tokens as described in the token controller contract
420     function () public payable {
421         require(isContract(controller));
422         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
423     }
424 
425 //////////
426 // Safety Methods
427 //////////
428 
429     /// @notice This method can be used by the controller to extract mistakenly
430     ///  sent tokens to this contract.
431     /// @param _token The address of the token contract that you want to recover
432     ///  set to 0 in case you want to extract ether.
433     function claimTokens(address _token) public onlyController {
434         if (_token == 0x0) {
435             controller.transfer(address(this).balance);
436             return;
437         }
438 
439         MiniMeToken token = MiniMeToken(_token);
440         uint256 balance = token.balanceOf(this);
441         token.transfer(controller, balance);
442         emit ClaimedTokens(_token, controller, balance);
443     }
444 
445 ////////////////
446 // Events
447 ////////////////
448 
449     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
450     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
451     event Approval(
452         address indexed _owner,
453         address indexed _spender,
454         uint256 _amount
455     );
456 
457 }
458 
459 contract ApproveAndCallFallBack {
460     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
461 }
462 
463 contract ERC677Receiver {
464     function tokenFallback(address _from, uint _amount, bytes _data) public;
465 }
466 
467 contract ERC677 is MiniMeToken {
468 
469     /**
470      * @dev ERC677 constructor is just a fallback to the MiniMeToken constructor
471      */
472     constructor(address _parentToken, uint _parentSnapShotBlock, string _tokenName, uint8 _decimalUnits, string _tokenSymbol, bool _transfersEnabled) public MiniMeToken(
473         _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
474     }
475 
476     /** 
477      * @notice `msg.sender` transfers `_amount` to `_to` contract and then tokenFallback() function is triggered in the `_to` contract.
478      * @param _to The address of the contract able to receive the tokens
479      * @param _amount The amount of tokens to be transferred
480      * @param _data The payload to be treated by `_to` contract in corresponding format
481      * @return True if the function call was successful
482      */
483     function transferAndCall(address _to, uint _amount, bytes _data) public returns (bool) {
484         require(transfer(_to, _amount));
485 
486         emit Transfer(msg.sender, _to, _amount, _data);
487 
488         // call receiver
489         if (isContract(_to)) {
490             ERC677Receiver(_to).tokenFallback(msg.sender, _amount, _data);
491         }
492 
493         return true;
494     }
495 
496     /**
497      * @notice Raised when transfer to contract has been completed
498      */
499     event Transfer(address indexed _from, address indexed _to, uint256 _amount, bytes _data);
500 }
501 
502 contract LogiToken is ERC677 {
503 
504     /**
505      * @dev Logi constructor just parametrizes the ERC677 -> MiniMeToken constructor
506      */
507     constructor() public ERC677(
508         0x0,                      // no parent token
509         0,                        // no parent token - no snapshot block number
510         "LogiToken",              // Token name
511         18,                       // Decimals
512         "LOGI",                   // Symbol
513         false                     // Disable transfers for time of minting
514     ) {}
515     
516 
517     // use the smallest denomination unit to operate with token amounts
518     uint256 public constant maxSupply = 100 * 1000 * 1000 * 10**uint256(decimals);
519 
520     // mapping for locking certain addresses
521     mapping(address => uint256) public lockups;
522 
523     event LockedTokens(address indexed _holder, uint256 _lockup);
524 
525     /**
526      * @notice Sets the locks of an array of addresses.
527      * @dev Must be called while minting (enableTransfers = false). Sizes of `_holder` and `_lockups` must be the same.
528      * @param _holders The array of investor addresses
529      * @param _lockups The array of timestamps until which corresponding address must be locked
530      */
531     function setLocks(address[] _holders, uint256[] _lockups) public onlyController {
532         require(_holders.length == _lockups.length);
533         require(_holders.length < 255);
534         require(transfersEnabled == false);
535 
536         for (uint8 i = 0; i < _holders.length; i++) {
537             address holder = _holders[i];
538             uint256 lockup = _lockups[i];
539 
540             // make sure lockup period can not be overwritten once set
541             require(lockups[holder] == 0);
542 
543             lockups[holder] = lockup;
544 
545             emit LockedTokens(holder, lockup);
546         }
547     }
548 
549     /**
550      * @dev Finishes minting process and throws out the controller.
551      */
552     function finishMinting() public onlyController() {
553         assert(totalSupply() <= maxSupply); // ensure hard cap
554         enableTransfers(true); // turn-on transfers
555         changeController(address(0x0)); // ensure no new tokens will be created
556     }
557 
558     modifier notLocked(address _addr) {
559         require(now >= lockups[_addr]);
560         _;
561     }
562 
563     /**
564      * @notice Send `_amount` tokens to `_to` from `msg.sender`
565      * @dev We override transfer function to add lockup check
566      * @param _to The address of the recipient
567      * @param _amount The amount of tokens to be transferred
568      * @return Whether the transfer was successful or not
569      */
570     function transfer(address _to, uint256 _amount) public notLocked(msg.sender) returns (bool success) {
571         return super.transfer(_to, _amount);
572     }
573 
574     /**
575      * @notice Send `_amount` tokens to `_to` from `_from` on the condition it is approved by `_from`
576      * @dev We override transfer function to add lockup check
577      * @param _from The address holding the tokens being transferred
578      * @param _to The address of the recipient
579      * @param _amount The amount of tokens to be transferred
580      * @return True if the transfer was successful
581      */
582     function transferFrom(address _from, address _to, uint256 _amount) public notLocked(_from) returns (bool success) {
583         return super.transferFrom(_from, _to, _amount);
584     }
585 }
586 
587 contract TokenController {
588     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
589     /// @param _owner The address that sent the ether to create tokens
590     /// @return True if the ether is accepted, false if it throws
591     function proxyPayment(address _owner) public payable returns(bool);
592 
593     /// @notice Notifies the controller about a token transfer allowing the
594     ///  controller to react if desired
595     /// @param _from The origin of the transfer
596     /// @param _to The destination of the transfer
597     /// @param _amount The amount of the transfer
598     /// @return False if the controller does not authorize the transfer
599     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
600 
601     /// @notice Notifies the controller about an approval allowing the
602     ///  controller to react if desired
603     /// @param _owner The address that calls `approve()`
604     /// @param _spender The spender in the `approve()` call
605     /// @param _amount The amount in the `approve()` call
606     /// @return False if the controller does not authorize the approval
607     function onApprove(address _owner, address _spender, uint _amount) public
608         returns(bool);
609 }