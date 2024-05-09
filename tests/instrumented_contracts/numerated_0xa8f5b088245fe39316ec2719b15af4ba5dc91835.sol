1 pragma solidity 0.4.19;
2 
3 contract MiniMeTokenFactory {
4 
5     /// @notice Update the DApp by creating a new token with new functionalities
6     ///  the msg.sender becomes the controller of this clone token
7     /// @param _parentToken Address of the token being cloned
8     /// @param _snapshotBlock Block of the parent token that will
9     ///  determine the initial distribution of the clone token
10     /// @param _tokenName Name of the new token
11     /// @param _decimalUnits Number of decimals of the new token
12     /// @param _tokenSymbol Token Symbol for the new token
13     /// @param _transfersEnabled If true, tokens will be able to be transferred
14     /// @return The address of the new token contract
15     function createCloneToken(
16         address _parentToken,
17         uint _snapshotBlock,
18         string _tokenName,
19         uint8 _decimalUnits,
20         string _tokenSymbol,
21         bool _transfersEnabled
22     ) public returns (MiniMeToken) {
23         MiniMeToken newToken = new MiniMeToken(
24             this,
25             _parentToken,
26             _snapshotBlock,
27             _tokenName,
28             _decimalUnits,
29             _tokenSymbol,
30             _transfersEnabled
31             );
32 
33         newToken.changeController(msg.sender);
34         return newToken;
35     }
36 }
37 
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 
66   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
67     return a >= b ? a : b;
68   }
69 
70   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
71     return a < b ? a : b;
72   }
73 
74   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
75     return a >= b ? a : b;
76   }
77 
78   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
79     return a < b ? a : b;
80   }
81 
82   function percent(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a * b;
84     assert(a == 0 || c / a == b);
85     return c / 100;
86   }
87 }
88 
89 contract TokenController {
90     using SafeMath for uint256;
91 
92     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
93     /// @param _owner The address that sent the ether to create tokens
94     /// @return True if the ether is accepted, false if it throws
95     function proxyPayment(address _owner) public payable returns(bool);
96 
97     /// @notice Notifies the controller about a token transfer allowing the
98     ///  controller to react if desired
99     /// @param _from The origin of the transfer
100     /// @param _to The destination of the transfer
101     /// @param _amount The amount of the transfer
102     /// @return False if the controller does not authorize the transfer
103     function onTransfer(address _from, address _to, uint256 _amount) public returns(bool);
104 
105     /// @notice Notifies the controller about an approval allowing the
106     ///  controller to react if desired
107     /// @param _owner The address that calls `approve()`
108     /// @param _spender The spender in the `approve()` call
109     /// @param _amount The amount in the `approve()` call
110     /// @return False if the controller does not authorize the approval
111     function onApprove(address _owner, address _spender, uint256 _amount) public
112         returns(bool);
113 }
114 
115 contract TLNConfig {
116 
117     string  public constant TLN_TOKEN_SYMBOL   = "TLN";
118     string  public constant TLN_TOKEN_NAME     = "LendCoin Token";
119     uint8   public constant TLN_TOKEN_DECIMALS = 18;
120 }
121 
122 contract ApproveAndCallFallBack {
123     using SafeMath for uint256;
124     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
125 }
126 
127 contract Controlled {
128     /// @notice The address of the controller is the only address that can call
129     ///  a function with this modifier
130     modifier onlyController { require(msg.sender == controller); _; }
131 
132     address public controller;
133 
134     function Controlled() public { controller = msg.sender;}
135 
136     /// @notice Changes the controller of the contract
137     /// @param _newController The new controller of the contract
138     function changeController(address _newController) public onlyController {
139         controller = _newController;
140     }
141 }
142 
143 contract MiniMeToken is Controlled {
144     using SafeMath for uint256;
145 
146     string public name;                //The Token's name: e.g. DigixDAO Tokens
147     uint8 public decimals;             //Number of decimals of the smallest unit
148     string public symbol;              //An identifier: e.g. REP
149     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
150 
151 
152     /// @dev `Checkpoint` is the structure that attaches a block number to a
153     ///  given value, the block number attached is the one that last changed the
154     ///  value
155     struct  Checkpoint {
156 
157         // `fromBlock` is the block number that the value was generated from
158         uint128 fromBlock;
159 
160         // `value` is the amount of tokens at a specific block number
161         uint256 value;
162     }
163 
164     // `parentToken` is the Token address that was cloned to produce this token;
165     //  it will be 0x0 for a token that was not cloned
166     MiniMeToken public parentToken;
167 
168     // `parentSnapShotBlock` is the block number from the Parent Token that was
169     //  used to determine the initial distribution of the Clone Token
170     uint public parentSnapShotBlock;
171 
172     // `creationBlock` is the block number that the Clone Token was created
173     uint public creationBlock;
174 
175     // `balances` is the map that tracks the balance of each address, in this
176     //  contract when the balance changes the block number that the change
177     //  occurred is also included in the map
178     mapping (address => Checkpoint[]) balances;
179 
180     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
181     mapping (address => mapping (address => uint256)) allowed;
182 
183     // Tracks the history of the `totalSupply` of the token
184     Checkpoint[] totalSupplyHistory;
185 
186     // Flag that determines if the token is transferable or not.
187     bool public transfersEnabled;
188 
189     // The factory used to create new clone tokens
190     MiniMeTokenFactory public tokenFactory;
191 
192 ////////////////
193 // Constructor
194 ////////////////
195 
196     /// @notice Constructor to create a MiniMeToken
197     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
198     ///  will create the Clone token contracts, the token factory needs to be
199     ///  deployed first
200     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
201     ///  new token
202     /// @param _parentSnapShotBlock Block of the parent token that will
203     ///  determine the initial distribution of the clone token, set to 0 if it
204     ///  is a new token
205     /// @param _tokenName Name of the new token
206     /// @param _decimalUnits Number of decimals of the new token
207     /// @param _tokenSymbol Token Symbol for the new token
208     /// @param _transfersEnabled If true, tokens will be able to be transferred
209     function MiniMeToken(
210         address _tokenFactory,
211         address _parentToken,
212         uint _parentSnapShotBlock,
213         string _tokenName,
214         uint8 _decimalUnits,
215         string _tokenSymbol,
216         bool _transfersEnabled
217     ) public {
218         tokenFactory = MiniMeTokenFactory(_tokenFactory);
219         name = _tokenName;                                 // Set the name
220         decimals = _decimalUnits;                          // Set the decimals
221         symbol = _tokenSymbol;                             // Set the symbol
222         parentToken = MiniMeToken(_parentToken);
223         parentSnapShotBlock = _parentSnapShotBlock;
224         transfersEnabled = _transfersEnabled;
225         creationBlock = getBlockNumber();
226     }
227 
228 
229 ///////////////////
230 // ERC20 Methods
231 ///////////////////
232 
233     ///
234     /// Fix for the ERC20 short address attack
235     ///
236     modifier onlyPayloadSize(uint size) {
237         assert(msg.data.length >= size + 4);
238         _;
239     }
240 
241     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
242     /// @param _to The address of the recipient
243     /// @param _amount The amount of tokens to be transferred
244     /// @return Whether the transfer was successful or not
245     function transfer(address _to, uint256 _amount) onlyPayloadSize(2*32) public returns (bool success) {
246         require(transfersEnabled);
247         doTransfer(msg.sender, _to, _amount);
248         return true;
249     }
250 
251     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
252     ///  is approved by `_from`
253     /// @param _from The address holding the tokens being transferred
254     /// @param _to The address of the recipient
255     /// @param _amount The amount of tokens to be transferred
256     /// @return True if the transfer was successful
257     function transferFrom(address _from, address _to, uint256 _amount
258     ) onlyPayloadSize(2*32) public returns (bool success) {
259 
260         // The controller of this contract can move tokens around at will,
261         //  this is important to recognize! Confirm that you trust the
262         //  controller of this contract, which in most situations should be
263         //  another open source smart contract or 0x0
264         if (msg.sender != controller) {
265             require(transfersEnabled);
266 
267             // The standard ERC 20 transferFrom functionality
268             require(allowed[_from][msg.sender] >= _amount);
269             allowed[_from][msg.sender] -= _amount;
270         }
271         doTransfer(_from, _to, _amount);
272         return true;
273     }
274 
275     /// @dev This is the actual transfer function in the token contract, it can
276     ///  only be called by other functions in this contract.
277     /// @param _from The address holding the tokens being transferred
278     /// @param _to The address of the recipient
279     /// @param _amount The amount of tokens to be transferred
280     /// @return True if the transfer was successful
281     function doTransfer(address _from, address _to, uint256 _amount
282     ) internal {
283 
284            if (_amount == 0) {
285                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
286                return;
287            }
288 
289            require(parentSnapShotBlock < getBlockNumber());
290 
291            // Do not allow transfer to 0x0 or the token contract itself
292            require((_to != 0) && (_to != address(this)));
293 
294            // If the amount being transfered is more than the balance of the
295            //  account the transfer throws
296            var previousBalanceFrom = balanceOfAt(_from, getBlockNumber());
297 
298            require(previousBalanceFrom >= _amount);
299 
300            // Alerts the token controller of the transfer
301            if (isContract(controller)) {
302                require(TokenController(controller).onTransfer(_from, _to, _amount));
303            }
304 
305            // First update the balance array with the new value for the address
306            //  sending the tokens
307            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
308 
309            // Then update the balance array with the new value for the address
310            //  receiving the tokens
311            var previousBalanceTo = balanceOfAt(_to, getBlockNumber());
312            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
313            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
314 
315            // An event to make the transfer easy to find on the blockchain
316            Transfer(_from, _to, _amount);
317 
318     }
319 
320     /// @param _owner The address that's balance is being requested
321     /// @return The balance of `_owner` at the current block
322     function balanceOf(address _owner) public constant returns (uint256 balance) {
323         return balanceOfAt(_owner, getBlockNumber());
324     }
325 
326     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
327     ///  its behalf. This is a modified version of the ERC20 approve function
328     ///  to be a little bit safer
329     /// @param _spender The address of the account able to transfer the tokens
330     /// @param _amount The amount of tokens to be approved for transfer
331     /// @return True if the approval was successful
332     function approve(address _spender, uint256 _amount) onlyPayloadSize(2*32) public returns (bool success) {
333         require(transfersEnabled);
334 
335         // To change the approve amount you first have to reduce the addresses`
336         //  allowance to zero by calling `approve(_spender,0)` if it is not
337         //  already 0 to mitigate the race condition described here:
338         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
339         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
340 
341         // Alerts the token controller of the approve function call
342         if (isContract(controller)) {
343             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
344         }
345 
346         allowed[msg.sender][_spender] = _amount;
347         Approval(msg.sender, _spender, _amount);
348         return true;
349     }
350 
351     /// @dev This function makes it easy to read the `allowed[]` map
352     /// @param _owner The address of the account that owns the token
353     /// @param _spender The address of the account able to transfer the tokens
354     /// @return Amount of remaining tokens of _owner that _spender is allowed
355     ///  to spend
356     function allowance(address _owner, address _spender
357     ) public constant returns (uint256 remaining) {
358         return allowed[_owner][_spender];
359     }
360 
361     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
362     ///  its behalf, and then a function is triggered in the contract that is
363     ///  being approved, `_spender`. This allows users to use their tokens to
364     ///  interact with contracts in one function call instead of two
365     /// @param _spender The address of the contract able to transfer the tokens
366     /// @param _amount The amount of tokens to be approved for transfer
367     /// @return True if the function call was successful
368     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
369     ) public returns (bool success) {
370         require(approve(_spender, _amount));
371 
372         ApproveAndCallFallBack(_spender).receiveApproval(
373             msg.sender,
374             _amount,
375             this,
376             _extraData
377         );
378 
379         return true;
380     }
381 
382     /// @dev This function makes it easy to get the total number of tokens
383     /// @return The total number of tokens
384     function totalSupply() public constant returns (uint256) {
385         return totalSupplyAt(getBlockNumber());
386     }
387 
388 
389 ////////////////
390 // Query balance and totalSupply in History
391 ////////////////
392 
393     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
394     /// @param _owner The address from which the balance will be retrieved
395     /// @param _blockNumber The block number when the balance is queried
396     /// @return The balance at `_blockNumber`
397     function balanceOfAt(address _owner, uint _blockNumber) public constant
398         returns (uint256) {
399 
400         // These next few lines are used when the balance of the token is
401         //  requested before a check point was ever created for this token, it
402         //  requires that the `parentToken.balanceOfAt` be queried at the
403         //  genesis block for that token as this contains initial balance of
404         //  this token
405         if ((balances[_owner].length == 0)
406             || (balances[_owner][0].fromBlock > _blockNumber)) {
407             if (address(parentToken) != 0) {
408                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
409             } else {
410                 // Has no parent
411                 return 0;
412             }
413 
414         // This will return the expected balance during normal situations
415         } else {
416             return getValueAt(balances[_owner], _blockNumber);
417         }
418     }
419 
420     /// @notice Total amount of tokens at a specific `_blockNumber`.
421     /// @param _blockNumber The block number when the totalSupply is queried
422     /// @return The total amount of tokens at `_blockNumber`
423     function totalSupplyAt(uint _blockNumber) public constant returns(uint256) {
424 
425         // These next few lines are used when the totalSupply of the token is
426         //  requested before a check point was ever created for this token, it
427         //  requires that the `parentToken.totalSupplyAt` be queried at the
428         //  genesis block for this token as that contains totalSupply of this
429         //  token at this block number.
430         if ((totalSupplyHistory.length == 0)
431             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
432             if (address(parentToken) != 0) {
433                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
434             } else {
435                 return 0;
436             }
437 
438         // This will return the expected totalSupply during normal situations
439         } else {
440             return getValueAt(totalSupplyHistory, _blockNumber);
441         }
442     }
443 
444 ////////////////
445 // Clone Token Method
446 ////////////////
447 
448     /// @notice Creates a new clone token with the initial distribution being
449     ///  this token at `_snapshotBlock`
450     /// @param _cloneTokenName Name of the clone token
451     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
452     /// @param _cloneTokenSymbol Symbol of the clone token
453     /// @param _snapshotBlock Block when the distribution of the parent token is
454     ///  copied to set the initial distribution of the new clone token;
455     ///  if the block is zero than the actual block, the current block is used
456     /// @param _transfersEnabled True if transfers are allowed in the clone
457     /// @return The address of the new MiniMeToken Contract
458     function createCloneToken(
459         string _cloneTokenName,
460         uint8 _cloneDecimalUnits,
461         string _cloneTokenSymbol,
462         uint _snapshotBlock,
463         bool _transfersEnabled
464         ) public returns(address) {
465         if (_snapshotBlock == 0) _snapshotBlock = getBlockNumber();
466         MiniMeToken cloneToken = tokenFactory.createCloneToken(
467             this,
468             _snapshotBlock,
469             _cloneTokenName,
470             _cloneDecimalUnits,
471             _cloneTokenSymbol,
472             _transfersEnabled
473             );
474 
475         cloneToken.changeController(msg.sender);
476 
477         // An event to make the token easy to find on the blockchain
478         NewCloneToken(address(cloneToken), _snapshotBlock);
479         return address(cloneToken);
480     }
481 
482 ////////////////
483 // Generate and destroy tokens
484 ////////////////
485 
486     /// @notice Generates `_amount` tokens that are assigned to `_owner`
487     /// @param _owner The address that will be assigned the new tokens
488     /// @param _amount The quantity of tokens generated
489     /// @return True if the tokens are generated correctly
490     function generateTokens(address _owner, uint256 _amount
491     ) public onlyController returns (bool) {
492         uint256 curTotalSupply = totalSupply();
493         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
494         uint256 previousBalanceTo = balanceOf(_owner);
495         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
496         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
497         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
498         Transfer(0, _owner, _amount);
499         return true;
500     }
501 
502 
503     /// @notice Burns `_amount` tokens from `_owner`
504     /// @param _owner The address that will lose the tokens
505     /// @param _amount The quantity of tokens to burn
506     /// @return True if the tokens are burned correctly
507     function destroyTokens(address _owner, uint256 _amount
508     ) onlyController public returns (bool) {
509         uint256 curTotalSupply = totalSupply();
510         require(curTotalSupply >= _amount);
511         uint256 previousBalanceFrom = balanceOf(_owner);
512         require(previousBalanceFrom >= _amount);
513         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
514         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
515         Transfer(_owner, 0, _amount);
516         return true;
517     }
518 
519 ////////////////
520 // Enable tokens transfers
521 ////////////////
522 
523 
524     /// @notice Enables token holders to transfer their tokens freely if true
525     /// @param _transfersEnabled True if transfers are allowed in the clone
526     function enableTransfers(bool _transfersEnabled) public onlyController {
527         transfersEnabled = _transfersEnabled;
528     }
529 
530 ////////////////
531 // Internal helper functions to query and set a value in a snapshot array
532 ////////////////
533 
534     /// @dev `getValueAt` retrieves the number of tokens at a given block number
535     /// @param checkpoints The history of values being queried
536     /// @param _block The block number to retrieve the value at
537     /// @return The number of tokens being queried
538     function getValueAt(Checkpoint[] storage checkpoints, uint _block
539     ) constant internal returns (uint256) {
540         if (checkpoints.length == 0) return 0;
541 
542         // Shortcut for the actual value
543         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
544             return checkpoints[checkpoints.length-1].value;
545         if (_block < checkpoints[0].fromBlock) return 0;
546 
547         // Binary search of the value in the array
548         uint min = 0;
549         uint max = checkpoints.length-1;
550         while (max > min) {
551             uint mid = (max + min + 1)/ 2;
552             if (checkpoints[mid].fromBlock<=_block) {
553                 min = mid;
554             } else {
555                 max = mid-1;
556             }
557         }
558         return checkpoints[min].value;
559     }
560 
561     /// @dev `updateValueAtNow` used to update the `balances` map and the
562     ///  `totalSupplyHistory`
563     /// @param checkpoints The history of data being updated
564     /// @param _value The new number of tokens
565     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value
566     ) internal  {
567         if ((checkpoints.length == 0)
568         || (checkpoints[checkpoints.length -1].fromBlock < getBlockNumber())) {
569                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
570                newCheckPoint.fromBlock =  uint128(getBlockNumber());
571                newCheckPoint.value = _value;
572            } else {
573                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
574                oldCheckPoint.value = _value;
575            }
576     }
577 
578     /// @dev Internal function to determine if an address is a contract
579     /// @param _addr The address being queried
580     /// @return True if `_addr` is a contract
581     function isContract(address _addr) constant internal returns(bool) {
582         uint size;
583         if (_addr == 0) return false;
584         assembly {
585             size := extcodesize(_addr)
586         }
587         return size>0;
588     }
589 
590     /// @dev Helper function to return a min betwen the two uints
591     function min(uint256 a, uint256 b) pure internal returns (uint256) {
592         return a < b ? a : b;
593     }
594 
595     /// @notice The fallback function: If the contract's controller has not been
596     ///  set to 0, then the `proxyPayment` method is called which relays the
597     ///  ether and creates tokens as described in the token controller contract
598     function () public payable {
599         require(isContract(controller));
600         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
601     }
602 
603 //////////
604 // Safety Methods
605 //////////
606 
607     /// @notice This method can be used by the controller to extract mistakenly
608     ///  sent tokens to this contract.
609     /// @param _token The address of the token contract that you want to recover
610     ///  set to 0 in case you want to extract ether.
611     function claimTokens(address _token) public onlyController {
612         if (_token == 0x0) {
613             controller.transfer(this.balance);
614             return;
615         }
616 
617         MiniMeToken token = MiniMeToken(_token);
618         uint256 balance = token.balanceOf(this);
619         token.transfer(controller, balance);
620         ClaimedTokens(_token, controller, balance);
621     }
622 
623 //////////
624 // Testing specific methods
625 //////////
626 
627     /// @notice This function is overridden by the test Mocks.
628     function getBlockNumber() internal constant returns (uint256) {
629         return block.number;
630     }
631 
632 ////////////////
633 // Events
634 ////////////////
635     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
636     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
637     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
638     event Approval(
639         address indexed _owner,
640         address indexed _spender,
641         uint256 _amount
642         );
643 
644 }
645 
646 contract TLN is MiniMeToken, TLNConfig {
647     // @dev TLN constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
648     function TLN(address _tokenFactory) public
649             MiniMeToken(
650                 _tokenFactory,
651                 0x0,                     // no parent token
652                 0,                       // no snapshot block number from parent
653                 TLN_TOKEN_NAME,          // Token name
654                 TLN_TOKEN_DECIMALS,      // Decimals
655                 TLN_TOKEN_SYMBOL,        // Symbol
656                 true                     // Enable transfers
657             ) {}
658 }