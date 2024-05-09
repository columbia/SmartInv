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
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     emit OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
64 }
65 
66 contract Controlled {
67     /// @notice The address of the controller is the only address that can call
68     ///  a function with this modifier
69     modifier onlyController { require(msg.sender == controller); _; }
70 
71     address public controller;
72 
73     constructor() public { controller = msg.sender;}
74 
75     /// @notice Changes the controller of the contract
76     /// @param _newController The new controller of the contract
77     function changeController(address _newController) public onlyController {
78         controller = _newController;
79     }
80 }
81 
82 contract ERC677Receiver {
83     function tokenFallback(address _from, uint _amount, bytes _data) public;
84 }
85 
86 contract MiniMeToken is Controlled {
87 
88     string public name;                //The Token's name: e.g. DigixDAO Tokens
89     uint8 public decimals;             //Number of decimals of the smallest unit
90     string public symbol;              //An identifier: e.g. REP
91     string public version = "MMT_0.2"; //An arbitrary versioning scheme
92 
93 
94     /// @dev `Checkpoint` is the structure that attaches a block number to a
95     ///  given value, the block number attached is the one that last changed the
96     ///  value
97     struct  Checkpoint {
98 
99         // `fromBlock` is the block number that the value was generated from
100         uint128 fromBlock;
101 
102         // `value` is the amount of tokens at a specific block number
103         uint128 value;
104     }
105 
106     // `parentToken` is the Token address that was cloned to produce this token;
107     //  it will be 0x0 for a token that was not cloned
108     MiniMeToken public parentToken;
109 
110     // `parentSnapShotBlock` is the block number from the Parent Token that was
111     //  used to determine the initial distribution of the Clone Token
112     uint256 public parentSnapShotBlock;
113 
114     // `creationBlock` is the block number that the Clone Token was created
115     uint256 public creationBlock;
116 
117     // `balances` is the map that tracks the balance of each address, in this
118     //  contract when the balance changes the block number that the change
119     //  occurred is also included in the map
120     mapping (address => Checkpoint[]) balances;
121 
122     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
123     mapping (address => mapping (address => uint256)) allowed;
124 
125     // Tracks the history of the `totalSupply` of the token
126     Checkpoint[] totalSupplyHistory;
127 
128     // Flag that determines if the token is transferable or not.
129     bool public transfersEnabled;
130 
131 ////////////////
132 // Constructor
133 ////////////////
134 
135     /// @notice Constructor to create a MiniMeToken
136     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
137     ///  new token
138     /// @param _parentSnapShotBlock Block of the parent token that will
139     ///  determine the initial distribution of the clone token, set to 0 if it
140     ///  is a new token
141     /// @param _tokenName Name of the new token
142     /// @param _decimalUnits Number of decimals of the new token
143     /// @param _tokenSymbol Token Symbol for the new token
144     /// @param _transfersEnabled If true, tokens will be able to be transferred
145     constructor(
146         address _parentToken,
147         uint256 _parentSnapShotBlock,
148         string _tokenName,
149         uint8 _decimalUnits,
150         string _tokenSymbol,
151         bool _transfersEnabled
152     ) public {
153         name = _tokenName;                                 // Set the name
154         decimals = _decimalUnits;                          // Set the decimals
155         symbol = _tokenSymbol;                             // Set the symbol
156         parentToken = MiniMeToken(_parentToken);
157         parentSnapShotBlock = _parentSnapShotBlock;
158         transfersEnabled = _transfersEnabled;
159         creationBlock = block.number;
160     }
161 
162 
163 ///////////////////
164 // ERC20 Methods
165 ///////////////////
166 
167     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
168     /// @param _to The address of the recipient
169     /// @param _amount The amount of tokens to be transferred
170     /// @return Whether the transfer was successful or not
171     function transfer(address _to, uint256 _amount) public returns (bool success) {
172         require(transfersEnabled);
173         doTransfer(msg.sender, _to, _amount);
174         return true;
175     }
176 
177     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
178     ///  is approved by `_from`
179     /// @param _from The address holding the tokens being transferred
180     /// @param _to The address of the recipient
181     /// @param _amount The amount of tokens to be transferred
182     /// @return True if the transfer was successful
183     function transferFrom(address _from, address _to, uint256 _amount
184     ) public returns (bool success) {
185 
186         // The controller of this contract can move tokens around at will,
187         //  this is important to recognize! Confirm that you trust the
188         //  controller of this contract, which in most situations should be
189         //  another open source smart contract or 0x0
190         if (msg.sender != controller) {
191             require(transfersEnabled);
192 
193             // The standard ERC 20 transferFrom functionality
194             require(allowed[_from][msg.sender] >= _amount);
195             allowed[_from][msg.sender] -= _amount;
196         }
197         doTransfer(_from, _to, _amount);
198         return true;
199     }
200 
201     /// @dev This is the actual transfer function in the token contract, it can
202     ///  only be called by other functions in this contract.
203     /// @param _from The address holding the tokens being transferred
204     /// @param _to The address of the recipient
205     /// @param _amount The amount of tokens to be transferred
206     /// @return True if the transfer was successful
207     function doTransfer(address _from, address _to, uint256 _amount
208     ) internal {
209 
210         if (_amount == 0) {
211             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
212             return;
213         }
214 
215         require(parentSnapShotBlock < block.number);
216 
217         // Do not allow transfer to 0x0 or the token contract itself
218         require((_to != 0) && (_to != address(this)));
219 
220         // If the amount being transfered is more than the balance of the
221         //  account the transfer throws
222         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
223 
224         require(previousBalanceFrom >= _amount);
225 
226         // Alerts the token controller of the transfer
227         if (isContract(controller)) {
228             require(TokenController(controller).onTransfer(_from, _to, _amount));
229         }
230 
231         // First update the balance array with the new value for the address
232         //  sending the tokens
233         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
234 
235         // Then update the balance array with the new value for the address
236         //  receiving the tokens
237         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
238         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
239         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
240 
241         // An event to make the transfer easy to find on the blockchain
242         emit Transfer(_from, _to, _amount);
243 
244     }
245 
246     /// @param _owner The address that's balance is being requested
247     /// @return The balance of `_owner` at the current block
248     function balanceOf(address _owner) public view returns (uint256 balance) {
249         return balanceOfAt(_owner, block.number);
250     }
251 
252     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
253     ///  its behalf. This is a modified version of the ERC20 approve function
254     ///  to be a little bit safer
255     /// @param _spender The address of the account able to transfer the tokens
256     /// @param _amount The amount of tokens to be approved for transfer
257     /// @return True if the approval was successful
258     function approve(address _spender, uint256 _amount) public returns (bool success) {
259         require(transfersEnabled);
260 
261         // To change the approve amount you first have to reduce the addresses`
262         //  allowance to zero by calling `approve(_spender,0)` if it is not
263         //  already 0 to mitigate the race condition described here:
264         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
266 
267         // Alerts the token controller of the approve function call
268         if (isContract(controller)) {
269             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
270         }
271 
272         allowed[msg.sender][_spender] = _amount;
273         emit Approval(msg.sender, _spender, _amount);
274         return true;
275     }
276 
277     /// @dev This function makes it easy to read the `allowed[]` map
278     /// @param _owner The address of the account that owns the token
279     /// @param _spender The address of the account able to transfer the tokens
280     /// @return Amount of remaining tokens of _owner that _spender is allowed
281     ///  to spend
282     function allowance(address _owner, address _spender
283     ) public view returns (uint256 remaining) {
284         return allowed[_owner][_spender];
285     }
286 
287     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
288     ///  its behalf, and then a function is triggered in the contract that is
289     ///  being approved, `_spender`. This allows users to use their tokens to
290     ///  interact with contracts in one function call instead of two
291     /// @param _spender The address of the contract able to transfer the tokens
292     /// @param _amount The amount of tokens to be approved for transfer
293     /// @return True if the function call was successful
294     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
295     ) public returns (bool success) {
296         require(approve(_spender, _amount));
297 
298         if (isContract(_spender)) {
299             ApproveAndCallFallBack(_spender).receiveApproval(
300                 msg.sender,
301                 _amount,
302                 this,
303                 _extraData
304             );
305         }
306 
307         return true;
308     }
309 
310     /// @dev This function makes it easy to get the total number of tokens
311     /// @return The total number of tokens
312     function totalSupply() public view returns (uint256) {
313         return totalSupplyAt(block.number);
314     }
315 
316 
317 ////////////////
318 // Query balance and totalSupply in History
319 ////////////////
320 
321     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
322     /// @param _owner The address from which the balance will be retrieved
323     /// @param _blockNumber The block number when the balance is queried
324     /// @return The balance at `_blockNumber`
325     function balanceOfAt(address _owner, uint256 _blockNumber) public view
326         returns (uint256) {
327 
328         // These next few lines are used when the balance of the token is
329         //  requested before a check point was ever created for this token, it
330         //  requires that the `parentToken.balanceOfAt` be queried at the
331         //  genesis block for that token as this contains initial balance of
332         //  this token
333         if ((balances[_owner].length == 0)
334             || (balances[_owner][0].fromBlock > _blockNumber)) {
335             if (address(parentToken) != 0) {
336                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
337             } else {
338                 // Has no parent
339                 return 0;
340             }
341 
342         // This will return the expected balance during normal situations
343         } else {
344             return getValueAt(balances[_owner], _blockNumber);
345         }
346     }
347 
348     /// @notice Total amount of tokens at a specific `_blockNumber`.
349     /// @param _blockNumber The block number when the totalSupply is queried
350     /// @return The total amount of tokens at `_blockNumber`
351     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
352 
353         // These next few lines are used when the totalSupply of the token is
354         //  requested before a check point was ever created for this token, it
355         //  requires that the `parentToken.totalSupplyAt` be queried at the
356         //  genesis block for this token as that contains totalSupply of this
357         //  token at this block number.
358         if ((totalSupplyHistory.length == 0)
359             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
360             if (address(parentToken) != 0) {
361                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
362             } else {
363                 return 0;
364             }
365 
366         // This will return the expected totalSupply during normal situations
367         } else {
368             return getValueAt(totalSupplyHistory, _blockNumber);
369         }
370     }
371 
372 ////////////////
373 // Generate and destroy tokens
374 ////////////////
375 
376     /// @notice Generates `_amount` tokens that are assigned to `_owner`
377     /// @param _owner The address that will be assigned the new tokens
378     /// @param _amount The quantity of tokens generated
379     /// @return True if the tokens are generated correctly
380     function generateTokens(address _owner, uint256 _amount
381     ) public onlyController returns (bool) {
382         uint256 curTotalSupply = totalSupply();
383         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
384         uint256 previousBalanceTo = balanceOf(_owner);
385         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
386         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
387         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
388         emit Transfer(0, _owner, _amount);
389         return true;
390     }
391 
392 
393     /// @notice Burns `_amount` tokens from `_owner`
394     /// @param _owner The address that will lose the tokens
395     /// @param _amount The quantity of tokens to burn
396     /// @return True if the tokens are burned correctly
397     function destroyTokens(address _owner, uint256 _amount
398     ) onlyController public returns (bool) {
399         uint256 curTotalSupply = totalSupply();
400         require(curTotalSupply >= _amount);
401         uint256 previousBalanceFrom = balanceOf(_owner);
402         require(previousBalanceFrom >= _amount);
403         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
404         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
405         emit Transfer(_owner, 0, _amount);
406         return true;
407     }
408 
409 ////////////////
410 // Enable tokens transfers
411 ////////////////
412 
413 
414     /// @notice Enables token holders to transfer their tokens freely if true
415     /// @param _transfersEnabled True if transfers are allowed in the clone
416     function enableTransfers(bool _transfersEnabled) public onlyController {
417         transfersEnabled = _transfersEnabled;
418     }
419 
420 ////////////////
421 // Internal helper functions to query and set a value in a snapshot array
422 ////////////////
423 
424     /// @dev `getValueAt` retrieves the number of tokens at a given block number
425     /// @param checkpoints The history of values being queried
426     /// @param _block The block number to retrieve the value at
427     /// @return The number of tokens being queried
428     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block
429     ) view internal returns (uint256) {
430         if (checkpoints.length == 0) return 0;
431 
432         // Shortcut for the actual value
433         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
434             return checkpoints[checkpoints.length-1].value;
435         if (_block < checkpoints[0].fromBlock) return 0;
436 
437         // Binary search of the value in the array
438         uint256 min = 0;
439         uint256 max = checkpoints.length-1;
440         while (max > min) {
441             uint256 mid = (max + min + 1) / 2;
442             if (checkpoints[mid].fromBlock <= _block) {
443                 min = mid;
444             } else {
445                 max = mid - 1;
446             }
447         }
448         return checkpoints[min].value;
449     }
450 
451     /// @dev `updateValueAtNow` used to update the `balances` map and the
452     ///  `totalSupplyHistory`
453     /// @param checkpoints The history of data being updated
454     /// @param _value The new number of tokens
455     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value
456     ) internal  {
457         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
458             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
459             newCheckPoint.fromBlock = uint128(block.number);
460             newCheckPoint.value = uint128(_value);
461         } else {
462             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
463             oldCheckPoint.value = uint128(_value);
464         }
465     }
466 
467     /// @dev Internal function to determine if an address is a contract
468     /// @param _addr The address being queried
469     /// @return True if `_addr` is a contract
470     function isContract(address _addr) view internal returns(bool) {
471         uint256 size;
472         if (_addr == 0) return false;
473         assembly {
474             size := extcodesize(_addr)
475         }
476         return size>0;
477     }
478 
479     /// @dev Helper function to return a min betwen the two uints
480     function min(uint256 a, uint256 b) pure internal returns (uint256) {
481         return a < b ? a : b;
482     }
483 
484     /// @notice The fallback function: If the contract's controller has not been
485     ///  set to 0, then the `proxyPayment` method is called which relays the
486     ///  ether and creates tokens as described in the token controller contract
487     function () public payable {
488         require(isContract(controller));
489         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
490     }
491 
492 //////////
493 // Safety Methods
494 //////////
495 
496     /// @notice This method can be used by the controller to extract mistakenly
497     ///  sent tokens to this contract.
498     /// @param _token The address of the token contract that you want to recover
499     ///  set to 0 in case you want to extract ether.
500     function claimTokens(address _token) public onlyController {
501         if (_token == 0x0) {
502             controller.transfer(address(this).balance);
503             return;
504         }
505 
506         MiniMeToken token = MiniMeToken(_token);
507         uint256 balance = token.balanceOf(this);
508         token.transfer(controller, balance);
509         emit ClaimedTokens(_token, controller, balance);
510     }
511 
512 ////////////////
513 // Events
514 ////////////////
515 
516     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
517     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
518     event Approval(
519         address indexed _owner,
520         address indexed _spender,
521         uint256 _amount
522     );
523 
524 }
525 
526 contract ERC677 is MiniMeToken {
527 
528     /**
529      * @dev ERC677 constructor is just a fallback to the MiniMeToken constructor
530      */
531     constructor(address _parentToken, uint _parentSnapShotBlock, string _tokenName, uint8 _decimalUnits, string _tokenSymbol, bool _transfersEnabled) public MiniMeToken(
532         _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
533     }
534 
535     /** 
536      * @notice `msg.sender` transfers `_amount` to `_to` contract and then tokenFallback() function is triggered in the `_to` contract.
537      * @param _to The address of the contract able to receive the tokens
538      * @param _amount The amount of tokens to be transferred
539      * @param _data The payload to be treated by `_to` contract in corresponding format
540      * @return True if the function call was successful
541      */
542     function transferAndCall(address _to, uint _amount, bytes _data) public returns (bool) {
543         require(transfer(_to, _amount));
544 
545         emit Transfer(msg.sender, _to, _amount, _data);
546 
547         // call receiver
548         if (isContract(_to)) {
549             ERC677Receiver(_to).tokenFallback(msg.sender, _amount, _data);
550         }
551 
552         return true;
553     }
554 
555     /**
556      * @notice Raised when transfer to contract has been completed
557      */
558     event Transfer(address indexed _from, address indexed _to, uint256 _amount, bytes _data);
559 }
560 
561 contract SmarcToken is ERC677, Ownable {
562 
563     // mapping for locking certain addresses
564     mapping(address => uint256) public lockups;
565 
566     event LockedTokens(address indexed _holder, uint256 _lockup);
567 
568     // burnable address
569     address public burnable;
570 
571     /**
572      * @dev Smarc constructor just parametrizes the ERC677 -> MiniMeToken constructor
573      */
574     constructor() public ERC677(
575         0x0,                      // no parent token
576         0,                        // no parent token - no snapshot block number
577         "SmarcToken",             // Token name
578         18,                       // Decimals
579         "SMARC",                  // Symbol
580         false                     // Disable transfers for time of minting
581     ) {}
582 
583     uint256 public constant maxSupply = 150 * 1000 * 1000 * 10**uint256(decimals); // use the smallest denomination unit to operate with token amounts
584 
585     /**
586      * @notice Sets the locks of an array of addresses.
587      * @dev Must be called while minting (enableTransfers = false). Sizes of `_holder` and `_lockups` must be the same.
588      * @param _holders The array of investor addresses
589      * @param _lockups The array of timestamps until which corresponding address must be locked
590      */
591     function setLocks(address[] _holders, uint256[] _lockups) public onlyController {
592         require(_holders.length == _lockups.length);
593         require(_holders.length < 256);
594         require(transfersEnabled == false);
595 
596         for (uint8 i = 0; i < _holders.length; i++) {
597             address holder = _holders[i];
598             uint256 lockup = _lockups[i];
599 
600             // make sure lockup period can not be overwritten once set
601             require(lockups[holder] == 0);
602 
603             lockups[holder] = lockup;
604 
605             emit LockedTokens(holder, lockup);
606         }
607     }
608 
609     /**
610      * @notice Finishes minting process and throws out the controller.
611      * @dev Owner can not finish minting without setting up address for burning tokens.
612      * @param _burnable The address to burn tokens from
613      */
614     function finishMinting(address _burnable) public onlyController() {
615         require(_burnable != address(0x0)); // burnable address must be set
616         assert(totalSupply() <= maxSupply); // ensure hard cap
617         enableTransfers(true); // turn-on transfers
618         changeController(address(0x0)); // ensure no new tokens will be created
619         burnable = _burnable; // set burnable address
620     }
621 
622     modifier notLocked(address _addr) {
623         require(now >= lockups[_addr]);
624         _;
625     }
626 
627     /**
628      * @notice Send `_amount` tokens to `_to` from `msg.sender`
629      * @dev We override transfer function to add lockup check
630      * @param _to The address of the recipient
631      * @param _amount The amount of tokens to be transferred
632      * @return Whether the transfer was successful or not
633      */
634     function transfer(address _to, uint256 _amount) public notLocked(msg.sender) returns (bool success) {
635         return super.transfer(_to, _amount);
636     }
637 
638     /**
639      * @notice Send `_amount` tokens to `_to` from `_from` on the condition it is approved by `_from`
640      * @dev We override transfer function to add lockup check
641      * @param _from The address holding the tokens being transferred
642      * @param _to The address of the recipient
643      * @param _amount The amount of tokens to be transferred
644      * @return True if the transfer was successful
645      */
646     function transferFrom(address _from, address _to, uint256 _amount) public notLocked(_from) returns (bool success) {
647         return super.transferFrom(_from, _to, _amount);
648     }
649 
650     /**
651      * @notice Burns `_amount` tokens from pre-defined "burnable" address.
652      * @param _amount The amount of tokens to burn
653      * @return True if the tokens are burned correctly
654      */
655     function burn(uint256 _amount) public onlyOwner returns (bool) {
656         require(burnable != address(0x0)); // burnable address must be set
657 
658         uint256 currTotalSupply = totalSupply();
659         uint256 previousBalance = balanceOf(burnable);
660 
661         require(currTotalSupply >= _amount);
662         require(previousBalance >= _amount);
663 
664         updateValueAtNow(totalSupplyHistory, currTotalSupply - _amount);
665         updateValueAtNow(balances[burnable], previousBalance - _amount);
666 
667         emit Transfer(burnable, 0, _amount);
668         
669         return true;
670     }
671 }