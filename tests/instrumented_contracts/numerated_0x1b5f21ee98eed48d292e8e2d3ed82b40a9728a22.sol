1 pragma solidity ^0.4.15;
2 
3 /*
4   Abstract contract for the full ERC 20 Token standard
5   https://github.com/ethereum/EIPs/issues/20
6 
7   Copyright 2017, Jordi Baylina (Giveth)
8 
9   Original contract from https://github.com/status-im/status-network-token/blob/master/contracts/ERC20Token.sol
10 */
11 contract ERC20Token {
12     /* This is a slight change to the ERC20 base standard.
13       function totalSupply() constant returns (uint256 supply);
14       is replaced with:
15       uint256 public totalSupply;
16       This automatically creates a getter function for the totalSupply.
17       This is moved to the base contract since public getter functions are not
18       currently recognised as an implementation of the matching abstract
19       function by the compiler.
20     */
21     /// total amount of tokens
22     function totalSupply() constant returns (uint256 balance);
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) constant returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) returns (bool success);
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of tokens to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) returns (bool success);
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 /*
56   Copyright 2017, Roderik van der Veer (SettleMint)
57   Copyright 2017, Jorge Izquierdo (Aragon Foundation)
58   Copyright 2017, Jordi Baylina (Giveth)
59 
60   Based on MiniMeToken.sol from https://github.com/Giveth/minime
61   Original contract from https://github.com/aragon/aragon-network-token/blob/master/contracts/interface/Controlled.sol
62 */
63 contract Controlled {
64     /// @notice The address of the controller is the only address that can call
65     ///  a function with this modifier
66     modifier onlyController { 
67         require(msg.sender == controller); 
68         _; 
69     }
70 
71     address public controller;
72 
73     function Controlled() { controller = msg.sender;}
74 
75     /// @notice Changes the controller of the contract
76     /// @param _newController The new controller of the contract
77     function changeController(address _newController) onlyController {
78         controller = _newController;
79     }
80 }
81 
82 contract MiniMeTokenI is ERC20Token, Controlled {
83 
84     string public name;                //The Token's name: e.g. DigixDAO Tokens
85     uint8 public decimals;             //Number of decimals of the smallest unit
86     string public symbol;              //An identifier: e.g. REP
87     string public version = "MMT_0.1"; //An arbitrary versioning scheme
88 
89 ///////////////////
90 // ERC20 Methods
91 ///////////////////
92 
93     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
94     ///  its behalf, and then a function is triggered in the contract that is
95     ///  being approved, `_spender`. This allows users to use their tokens to
96     ///  interact with contracts in one function call instead of two
97     /// @param _spender The address of the contract able to transfer the tokens
98     /// @param _amount The amount of tokens to be approved for transfer
99     /// @return True if the function call was successful
100     function approveAndCall(
101         address _spender,
102         uint256 _amount,
103         bytes _extraData
104     ) returns (bool success);
105 
106 ////////////////
107 // Query balance and totalSupply in History
108 ////////////////
109 
110     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
111     /// @param _owner The address from which the balance will be retrieved
112     /// @param _blockNumber The block number when the balance is queried
113     /// @return The balance at `_blockNumber`
114     function balanceOfAt(
115         address _owner,
116         uint _blockNumber
117     ) constant returns (uint);
118 
119     /// @notice Total amount of tokens at a specific `_blockNumber`.
120     /// @param _blockNumber The block number when the totalSupply is queried
121     /// @return The total amount of tokens at `_blockNumber`
122     function totalSupplyAt(uint _blockNumber) constant returns(uint);
123 
124 ////////////////
125 // Clone Token Method
126 ////////////////
127 
128     /// @notice Creates a new clone token with the initial distribution being
129     ///  this token at `_snapshotBlock`
130     /// @param _cloneTokenName Name of the clone token
131     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
132     /// @param _cloneTokenSymbol Symbol of the clone token
133     /// @param _snapshotBlock Block when the distribution of the parent token is
134     ///  copied to set the initial distribution of the new clone token;
135     ///  if the block is zero than the actual block, the current block is used
136     /// @param _transfersEnabled True if transfers are allowed in the clone
137     /// @return The address of the new MiniMeToken Contract
138     function createCloneToken(
139         string _cloneTokenName,
140         uint8 _cloneDecimalUnits,
141         string _cloneTokenSymbol,
142         uint _snapshotBlock,
143         bool _transfersEnabled
144     ) returns(address);
145 
146 ////////////////
147 // Generate and destroy tokens
148 ////////////////
149 
150     /// @notice Generates `_amount` tokens that are assigned to `_owner`
151     /// @param _owner The address that will be assigned the new tokens
152     /// @param _amount The quantity of tokens generated
153     /// @return True if the tokens are generated correctly
154     function generateTokens(address _owner, uint _amount) returns (bool);
155 
156 
157     /// @notice Burns `_amount` tokens from `_owner`
158     /// @param _owner The address that will lose the tokens
159     /// @param _amount The quantity of tokens to burn
160     /// @return True if the tokens are burned correctly
161     function destroyTokens(address _owner, uint _amount) returns (bool);
162 
163 ////////////////
164 // Enable tokens transfers
165 ////////////////
166 
167     /// @notice Enables token holders to transfer their tokens freely if true
168     /// @param _transfersEnabled True if transfers are allowed in the clone
169     function enableTransfers(bool _transfersEnabled);
170 
171 //////////
172 // Safety Methods
173 //////////
174 
175     /// @notice This method can be used by the controller to extract mistakenly
176     ///  sent tokens to this contract.
177     /// @param _token The address of the token contract that you want to recover
178     ///  set to 0 in case you want to extract ether.
179     function claimTokens(address _token);
180 
181 ////////////////
182 // Events
183 ////////////////
184 
185     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
186     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
187 }
188 
189 /*
190   Copyright 2017, Jorge Izquierdo (Aragon Foundation)
191   Copyright 2017, Jordi Baylina (Giveth)
192 
193   Based on MiniMeToken.sol from https://github.com/Giveth/minime
194   Original contract from https://github.com/aragon/aragon-network-token/blob/master/contracts/interface/Controller.sol
195 */
196 /// @dev The token controller contract must implement these functions
197 contract TokenController {
198     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
199     /// @param _owner The address that sent the ether to create tokens
200     /// @return True if the ether is accepted, false if it throws
201     function proxyPayment(address _owner) payable returns(bool);
202 
203     /// @notice Notifies the controller about a token transfer allowing the
204     ///  controller to react if desired
205     /// @param _from The origin of the transfer
206     /// @param _to The destination of the transfer
207     /// @param _amount The amount of the transfer
208     /// @return False if the controller does not authorize the transfer
209     function onTransfer(address _from, address _to, uint _amount) returns(bool);
210 
211     /// @notice Notifies the controller about an approval allowing the
212     ///  controller to react if desired
213     /// @param _owner The address that calls `approve()`
214     /// @param _spender The spender in the `approve()` call
215     /// @param _amount The amount in the `approve()` call
216     /// @return False if the controller does not authorize the approval
217     function onApprove(address _owner, address _spender, uint _amount) returns(bool);
218 }
219 
220 
221 /*
222   Copyright 2017, Jordi Baylina (Giveth)
223 
224   Original contract from https://github.com/aragon/aragon-network-token/blob/master/contracts/interface/ApproveAndCallReceiver.sol
225 */
226 contract ApproveAndCallReceiver {
227     function receiveApproval(
228         address _from, 
229         uint256 _amount, 
230         address _token, 
231         bytes _data
232     );
233 }
234 
235  
236 /*
237   Copyright 2017, Anton Egorov (Mothership Foundation)
238   Copyright 2017, Jordi Baylina (Giveth)
239 
240   Based on MineMeToken.sol from https://github.com/Giveth/minime
241   Original contract from https://github.com/status-im/status-network-token/blob/master/contracts/MiniMeToken.sol
242 */
243 /// @title MiniMeToken Contract
244 /// @author Jordi Baylina
245 /// @dev This token contract's goal is to make it easy for anyone to clone this
246 ///  token using the token distribution at a given block, this will allow DAO's
247 ///  and DApps to upgrade their features in a decentralized manner without
248 ///  affecting the original token
249 /// @dev It is ERC20 compliant, but still needs to under go further testing.
250 
251 /// @dev The actual token contract, the default controller is the msg.sender
252 ///  that deploys the contract, so usually this token will be deployed by a
253 ///  token controller contract, which Giveth will call a "Campaign"
254 contract MiniMeToken is MiniMeTokenI {
255 
256     string public name;                //The Token's name: e.g. DigixDAO Tokens
257     uint8 public decimals;             //Number of decimals of the smallest unit
258     string public symbol;              //An identifier: e.g. REP
259     string public version = "MMT_0.1"; //An arbitrary versioning scheme
260 
261     /// @dev `Checkpoint` is the structure that attaches a block number to a
262     ///  given value, the block number attached is the one that last changed the
263     ///  value
264     struct Checkpoint {
265 
266         // `fromBlock` is the block number that the value was generated from
267         uint128 fromBlock;
268 
269         // `value` is the amount of tokens at a specific block number
270         uint128 value;
271     }
272 
273     // `parentToken` is the Token address that was cloned to produce this token;
274     //  it will be 0x0 for a token that was not cloned
275     MiniMeToken public parentToken;
276 
277     // `parentSnapShotBlock` is the block number from the Parent Token that was
278     //  used to determine the initial distribution of the Clone Token
279     uint public parentSnapShotBlock;
280 
281     // `creationBlock` is the block number that the Clone Token was created
282     uint public creationBlock;
283 
284     // `balances` is the map that tracks the balance of each address, in this
285     //  contract when the balance changes the block number that the change
286     //  occurred is also included in the map
287     mapping (address => Checkpoint[]) balances;
288 
289     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
290     mapping (address => mapping (address => uint256)) allowed;
291 
292     // Tracks the history of the `totalSupply` of the token
293     Checkpoint[] totalSupplyHistory;
294 
295     // Flag that determines if the token is transferable or not.
296     bool public transfersEnabled;
297 
298     // The factory used to create new clone tokens
299     MiniMeTokenFactory public tokenFactory;
300 
301 ////////////////
302 // Constructor
303 ////////////////
304 
305     /// @notice Constructor to create a MiniMeToken
306     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
307     ///  will create the Clone token contracts, the token factory needs to be
308     ///  deployed first
309     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
310     ///  new token
311     /// @param _parentSnapShotBlock Block of the parent token that will
312     ///  determine the initial distribution of the clone token, set to 0 if it
313     ///  is a new token
314     /// @param _tokenName Name of the new token
315     /// @param _decimalUnits Number of decimals of the new token
316     /// @param _tokenSymbol Token Symbol for the new token
317     /// @param _transfersEnabled If true, tokens will be able to be transferred
318     function MiniMeToken(
319         address _tokenFactory,
320         address _parentToken,
321         uint _parentSnapShotBlock,
322         string _tokenName,
323         uint8 _decimalUnits,
324         string _tokenSymbol,
325         bool _transfersEnabled
326     ) {
327         tokenFactory = MiniMeTokenFactory(_tokenFactory);
328         name = _tokenName;                                 // Set the name
329         decimals = _decimalUnits;                          // Set the decimals
330         symbol = _tokenSymbol;                             // Set the symbol
331         parentToken = MiniMeToken(_parentToken);
332         parentSnapShotBlock = _parentSnapShotBlock;
333         transfersEnabled = _transfersEnabled;
334         creationBlock = block.number;
335     }
336 
337 ///////////////////
338 // ERC20 Methods
339 ///////////////////
340 
341     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
342     /// @param _to The address of the recipient
343     /// @param _amount The amount of tokens to be transferred
344     /// @return Whether the transfer was successful or not
345     function transfer(address _to, uint256 _amount) returns (bool success) {
346         require(transfersEnabled);
347         return doTransfer(msg.sender, _to, _amount);
348     }
349 
350     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
351     ///  is approved by `_from`
352     /// @param _from The address holding the tokens being transferred
353     /// @param _to The address of the recipient
354     /// @param _amount The amount of tokens to be transferred
355     /// @return True if the transfer was successful
356     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
357 
358         // The controller of this contract can move tokens around at will,
359         //  this is important to recognize! Confirm that you trust the
360         //  controller of this contract, which in most situations should be
361         //  another open source smart contract or 0x0
362         if (msg.sender != controller) {
363             require(transfersEnabled);
364 
365             // The standard ERC 20 transferFrom functionality
366             if (allowed[_from][msg.sender] < _amount) {
367                 return false;
368             }
369             allowed[_from][msg.sender] -= _amount;
370         }
371         return doTransfer(_from, _to, _amount);
372     }
373 
374     /// @dev This is the actual transfer function in the token contract, it can
375     ///  only be called by other functions in this contract.
376     /// @param _from The address holding the tokens being transferred
377     /// @param _to The address of the recipient
378     /// @param _amount The amount of tokens to be transferred
379     /// @return True if the transfer was successful
380     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
381 
382         if (_amount == 0) {
383             return true;
384         }
385 
386         require(parentSnapShotBlock < block.number);
387 
388         // Do not allow transfer to 0x0 or the token contract itself
389         require((_to != 0) && (_to != address(this)));
390 
391         // If the amount being transfered is more than the balance of the
392         //  account the transfer returns false
393         var previousBalanceFrom = balanceOfAt(_from, block.number);
394         if (previousBalanceFrom < _amount) {
395             return false;
396         }
397 
398         // Alerts the token controller of the transfer
399         if (isContract(controller)) {
400             bool onTransfer = TokenController(controller).onTransfer(_from, _to, _amount);
401             require(onTransfer);
402         }
403 
404         // First update the balance array with the new value for the address
405         //  sending the tokens
406         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
407 
408         // Then update the balance array with the new value for the address
409         //  receiving the tokens
410         var previousBalanceTo = balanceOfAt(_to, block.number);
411         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
412         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
413 
414         // An event to make the transfer easy to find on the blockchain
415         Transfer(_from, _to, _amount);
416 
417         return true;
418     }
419 
420     /// @param _owner The address that's balance is being requested
421     /// @return The balance of `_owner` at the current block
422     function balanceOf(address _owner) constant returns (uint256 balance) {
423         return balanceOfAt(_owner, block.number);
424     }
425 
426     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
427     ///  its behalf. This is a modified version of the ERC20 approve function
428     ///  to be a little bit safer
429     /// @param _spender The address of the account able to transfer the tokens
430     /// @param _amount The amount of tokens to be approved for transfer
431     /// @return True if the approval was successful
432     function approve(address _spender, uint256 _amount) returns (bool success) {
433         require(transfersEnabled);
434 
435         // To change the approve amount you first have to reduce the addresses`
436         //  allowance to zero by calling `approve(_spender,0)` if it is not
437         //  already 0 to mitigate the race condition described here:
438         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
439         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
440 
441         // Alerts the token controller of the approve function call
442         if (isContract(controller)) {
443             bool onApprove = TokenController(controller).onApprove(msg.sender, _spender, _amount);
444             require(onApprove);
445         }
446 
447         allowed[msg.sender][_spender] = _amount;
448         Approval(msg.sender, _spender, _amount);
449         return true;
450     }
451 
452     /// @dev This function makes it easy to read the `allowed[]` map
453     /// @param _owner The address of the account that owns the token
454     /// @param _spender The address of the account able to transfer the tokens
455     /// @return Amount of remaining tokens of _owner that _spender is allowed
456     ///  to spend
457     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
458         return allowed[_owner][_spender];
459     }
460 
461     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
462     ///  its behalf, and then a function is triggered in the contract that is
463     ///  being approved, `_spender`. This allows users to use their tokens to
464     ///  interact with contracts in one function call instead of two
465     /// @param _spender The address of the contract able to transfer the tokens
466     /// @param _amount The amount of tokens to be approved for transfer
467     /// @return True if the function call was successful
468     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
469         require(approve(_spender, _amount));
470 
471         ApproveAndCallReceiver(_spender).receiveApproval(
472             msg.sender,
473             _amount,
474             this,
475             _extraData
476         );
477 
478         return true;
479     }
480 
481     /// @dev This function makes it easy to get the total number of tokens
482     /// @return The total number of tokens
483     function totalSupply() constant returns (uint) {
484         return totalSupplyAt(block.number);
485     }
486 
487 ////////////////
488 // Query balance and totalSupply in History
489 ////////////////
490 
491     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
492     /// @param _owner The address from which the balance will be retrieved
493     /// @param _blockNumber The block number when the balance is queried
494     /// @return The balance at `_blockNumber`
495     function balanceOfAt(address _owner, uint _blockNumber) constant returns (uint) {
496 
497         // These next few lines are used when the balance of the token is
498         //  requested before a check point was ever created for this token, it
499         //  requires that the `parentToken.balanceOfAt` be queried at the
500         //  genesis block for that token as this contains initial balance of
501         //  this token
502         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
503             if (address(parentToken) != 0) {
504                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
505             } else {
506                 // Has no parent
507                 return 0;
508             }
509 
510         // This will return the expected balance during normal situations
511         } else {
512             return getValueAt(balances[_owner], _blockNumber);
513         }
514     }
515 
516     /// @notice Total amount of tokens at a specific `_blockNumber`.
517     /// @param _blockNumber The block number when the totalSupply is queried
518     /// @return The total amount of tokens at `_blockNumber`
519     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
520 
521         // These next few lines are used when the totalSupply of the token is
522         //  requested before a check point was ever created for this token, it
523         //  requires that the `parentToken.totalSupplyAt` be queried at the
524         //  genesis block for this token as that contains totalSupply of this
525         //  token at this block number.
526         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
527             if (address(parentToken) != 0) {
528                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
529             } else {
530                 return 0;
531             }
532 
533         // This will return the expected totalSupply during normal situations
534         } else {
535             return getValueAt(totalSupplyHistory, _blockNumber);
536         }
537     }
538 
539 ////////////////
540 // Clone Token Method
541 ////////////////
542 
543     /// @notice Creates a new clone token with the initial distribution being
544     ///  this token at `_snapshotBlock`
545     /// @param _cloneTokenName Name of the clone token
546     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
547     /// @param _cloneTokenSymbol Symbol of the clone token
548     /// @param _snapshotBlock Block when the distribution of the parent token is
549     ///  copied to set the initial distribution of the new clone token;
550     ///  if the block is zero than the actual block, the current block is used
551     /// @param _transfersEnabled True if transfers are allowed in the clone
552     /// @return The address of the new MiniMeToken Contract
553     function createCloneToken(
554         string _cloneTokenName, 
555         uint8 _cloneDecimalUnits, 
556         string _cloneTokenSymbol, 
557         uint _snapshotBlock, 
558         bool _transfersEnabled
559     ) returns(address) 
560     {
561 
562         if (_snapshotBlock == 0) {
563             _snapshotBlock = block.number;
564         }
565 
566         MiniMeToken cloneToken = tokenFactory.createCloneToken(
567             this,
568             _snapshotBlock,
569             _cloneTokenName,
570             _cloneDecimalUnits,
571             _cloneTokenSymbol,
572             _transfersEnabled
573         );
574 
575         cloneToken.changeController(msg.sender);
576 
577         // An event to make the token easy to find on the blockchain
578         NewCloneToken(address(cloneToken), _snapshotBlock);
579         return address(cloneToken);
580     }
581 
582 ////////////////
583 // Generate and destroy tokens
584 ////////////////
585 
586     /// @notice Generates `_amount` tokens that are assigned to `_owner`
587     /// @param _owner The address that will be assigned the new tokens
588     /// @param _amount The quantity of tokens generated
589     /// @return True if the tokens are generated correctly
590     function generateTokens(address _owner, uint _amount) onlyController returns (bool) {
591         uint curTotalSupply = totalSupply();
592         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
593         uint previousBalanceTo = balanceOf(_owner);
594         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
595         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
596         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
597         Transfer(0, _owner, _amount);
598         return true;
599     }
600 
601     /// @notice Burns `_amount` tokens from `_owner`
602     /// @param _owner The address that will lose the tokens
603     /// @param _amount The quantity of tokens to burn
604     /// @return True if the tokens are burned correctly
605     function destroyTokens(address _owner, uint _amount) onlyController returns (bool) {
606         uint curTotalSupply = totalSupply();
607         require(curTotalSupply >= _amount);
608         uint previousBalanceFrom = balanceOf(_owner);
609         require(previousBalanceFrom >= _amount);
610         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
611         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
612         Transfer(_owner, 0, _amount);
613         return true;
614     }
615 
616 ////////////////
617 // Enable tokens transfers
618 ////////////////
619 
620     /// @notice Enables token holders to transfer their tokens freely if true
621     /// @param _transfersEnabled True if transfers are allowed in the clone
622     function enableTransfers(bool _transfersEnabled) onlyController {
623         transfersEnabled = _transfersEnabled;
624     }
625 
626 ////////////////
627 // Internal helper functions to query and set a value in a snapshot array
628 ////////////////
629 
630     /// @dev `getValueAt` retrieves the number of tokens at a given block number
631     /// @param checkpoints The history of values being queried
632     /// @param _block The block number to retrieve the value at
633     /// @return The number of tokens being queried
634     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
635         if (checkpoints.length == 0) {
636             return 0;
637         }
638 
639         // Shortcut for the actual value
640         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
641             return checkpoints[checkpoints.length-1].value;
642         if (_block < checkpoints[0].fromBlock) {
643             return 0;
644         }
645 
646         // Binary search of the value in the array
647         uint min = 0;
648         uint max = checkpoints.length-1;
649         while (max > min) {
650             uint mid = (max + min + 1) / 2;
651             if (checkpoints[mid].fromBlock<=_block) {
652                 min = mid;
653             } else {
654                 max = mid-1;
655             }
656         }
657         return checkpoints[min].value;
658     }
659 
660     /// @dev `updateValueAtNow` used to update the `balances` map and the
661     ///  `totalSupplyHistory`
662     /// @param checkpoints The history of data being updated
663     /// @param _value The new number of tokens
664     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
665         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
666             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
667             newCheckPoint.fromBlock = uint128(block.number);
668             newCheckPoint.value = uint128(_value);
669         } else {
670             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
671             oldCheckPoint.value = uint128(_value);
672         }
673     }
674 
675     /// @dev Internal function to determine if an address is a contract
676     /// @param _addr The address being queried
677     /// @return True if `_addr` is a contract
678     function isContract(address _addr) constant internal returns(bool) {
679         uint size;
680         if (_addr == 0) {
681             return false;
682         }
683         assembly {
684             size := extcodesize(_addr)
685         }
686         return size>0;
687     }
688 
689     /// @dev Helper function to return a min betwen the two uints
690     function min(uint a, uint b) internal returns (uint) {
691         return a < b ? a : b;
692     }
693 
694     /// @notice The fallback function: If the contract's controller has not been
695     ///  set to 0, then the `proxyPayment` method is called which relays the
696     ///  ether and creates tokens as described in the token controller contract
697     function ()  payable {
698         require(isContract(controller));
699         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
700         require(proxyPayment);
701     }
702 
703 //////////
704 // Safety Methods
705 //////////
706 
707     /// @notice This method can be used by the controller to extract mistakenly
708     ///  sent tokens to this contract.
709     /// @param _token The address of the token contract that you want to recover
710     ///  set to 0 in case you want to extract ether.
711     function claimTokens(address _token) onlyController {
712         if (_token == 0x0) {
713             controller.transfer(this.balance);
714             return;
715         }
716 
717         MiniMeToken token = MiniMeToken(_token);
718         uint balance = token.balanceOf(this);
719         token.transfer(controller, balance);
720         ClaimedTokens(_token, controller, balance);
721     }
722 
723 ////////////////
724 // Events
725 ////////////////
726     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
727     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
728     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
729     event Approval(
730         address indexed _owner,
731         address indexed _spender,
732         uint256 _amount
733     );
734 }
735 
736 
737 
738 ////////////////
739 // MiniMeTokenFactory
740 ////////////////
741 
742 /// @dev This contract is used to generate clone contracts from a contract.
743 ///  In solidity this is the way to create a contract from a contract of the
744 ///  same class
745 contract MiniMeTokenFactory {
746 
747     /// @notice Update the DApp by creating a new token with new functionalities
748     ///  the msg.sender becomes the controller of this clone token
749     /// @param _parentToken Address of the token being cloned
750     /// @param _snapshotBlock Block of the parent token that will
751     ///  determine the initial distribution of the clone token
752     /// @param _tokenName Name of the new token
753     /// @param _decimalUnits Number of decimals of the new token
754     /// @param _tokenSymbol Token Symbol for the new token
755     /// @param _transfersEnabled If true, tokens will be able to be transferred
756     /// @return The address of the new token contract
757     function createCloneToken(
758         address _parentToken,
759         uint _snapshotBlock,
760         string _tokenName,
761         uint8 _decimalUnits,
762         string _tokenSymbol,
763         bool _transfersEnabled
764     ) returns (MiniMeToken) 
765     {
766         MiniMeToken newToken = new MiniMeToken(
767             this,
768             _parentToken,
769             _snapshotBlock,
770             _tokenName,
771             _decimalUnits,
772             _tokenSymbol,
773             _transfersEnabled
774         );
775 
776         newToken.changeController(msg.sender);
777         return newToken;
778     }
779 }
780 
781 contract DataBrokerDaoToken is MiniMeToken {  
782 
783     function DataBrokerDaoToken(address _tokenFactory) MiniMeToken(   
784       _tokenFactory,
785       0x0,                    // no parent token
786       0,                      // no snapshot block number from parent
787       "DataBroker DAO Token", // Token name
788       18,                     // Decimals
789       "DATA",                 // Symbol
790       true                   // Enable transfers
791       ) 
792       {}
793 
794 }