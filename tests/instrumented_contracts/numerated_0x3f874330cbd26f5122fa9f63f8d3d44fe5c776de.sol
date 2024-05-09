1 pragma solidity ^0.4.15;
2 
3 /*
4   Copyright 2017, Roderik van der Veer (SettleMint)
5   Copyright 2017, Jorge Izquierdo (Aragon Foundation)
6   Copyright 2017, Jordi Baylina (Giveth)
7 
8   Based on MiniMeToken.sol from https://github.com/Giveth/minime
9   Original contract from https://github.com/aragon/aragon-network-token/blob/master/contracts/interface/Controlled.sol
10 */
11 contract Controlled {
12     /// @notice The address of the controller is the only address that can call
13     ///  a function with this modifier
14     modifier onlyController { 
15         require(msg.sender == controller); 
16         _; 
17     }
18 
19     address public controller;
20 
21     function Controlled() { controller = msg.sender;}
22 
23     /// @notice Changes the controller of the contract
24     /// @param _newController The new controller of the contract
25     function changeController(address _newController) onlyController {
26         controller = _newController;
27     }
28 }
29 
30 /*
31   Abstract contract for the full ERC 20 Token standard
32   https://github.com/ethereum/EIPs/issues/20
33 
34   Copyright 2017, Jordi Baylina (Giveth)
35 
36   Original contract from https://github.com/status-im/status-network-token/blob/master/contracts/ERC20Token.sol
37 */
38 contract ERC20Token {
39     /* This is a slight change to the ERC20 base standard.
40       function totalSupply() constant returns (uint256 supply);
41       is replaced with:
42       uint256 public totalSupply;
43       This automatically creates a getter function for the totalSupply.
44       This is moved to the base contract since public getter functions are not
45       currently recognised as an implementation of the matching abstract
46       function by the compiler.
47     */
48     /// total amount of tokens
49     function totalSupply() constant returns (uint256 balance);
50 
51     /// @param _owner The address from which the balance will be retrieved
52     /// @return The balance
53     function balanceOf(address _owner) constant returns (uint256 balance);
54 
55     /// @notice send `_value` token to `_to` from `msg.sender`
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transfer(address _to, uint256 _value) returns (bool success);
60 
61     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
62     /// @param _from The address of the sender
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
67 
68     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @param _value The amount of tokens to be approved for transfer
71     /// @return Whether the approval was successful or not
72     function approve(address _spender, uint256 _value) returns (bool success);
73 
74     /// @param _owner The address of the account owning tokens
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @return Amount of remaining tokens allowed to spent
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 }
82 
83 contract MiniMeTokenI is ERC20Token, Controlled {
84 
85     string public name;                //The Token's name: e.g. DigixDAO Tokens
86     uint8 public decimals;             //Number of decimals of the smallest unit
87     string public symbol;              //An identifier: e.g. REP
88     string public version = "MMT_0.1"; //An arbitrary versioning scheme
89 
90 ///////////////////
91 // ERC20 Methods
92 ///////////////////
93 
94     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
95     ///  its behalf, and then a function is triggered in the contract that is
96     ///  being approved, `_spender`. This allows users to use their tokens to
97     ///  interact with contracts in one function call instead of two
98     /// @param _spender The address of the contract able to transfer the tokens
99     /// @param _amount The amount of tokens to be approved for transfer
100     /// @return True if the function call was successful
101     function approveAndCall(
102         address _spender,
103         uint256 _amount,
104         bytes _extraData
105     ) returns (bool success);
106 
107 ////////////////
108 // Query balance and totalSupply in History
109 ////////////////
110 
111     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
112     /// @param _owner The address from which the balance will be retrieved
113     /// @param _blockNumber The block number when the balance is queried
114     /// @return The balance at `_blockNumber`
115     function balanceOfAt(
116         address _owner,
117         uint _blockNumber
118     ) constant returns (uint);
119 
120     /// @notice Total amount of tokens at a specific `_blockNumber`.
121     /// @param _blockNumber The block number when the totalSupply is queried
122     /// @return The total amount of tokens at `_blockNumber`
123     function totalSupplyAt(uint _blockNumber) constant returns(uint);
124 
125 ////////////////
126 // Clone Token Method
127 ////////////////
128 
129     /// @notice Creates a new clone token with the initial distribution being
130     ///  this token at `_snapshotBlock`
131     /// @param _cloneTokenName Name of the clone token
132     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
133     /// @param _cloneTokenSymbol Symbol of the clone token
134     /// @param _snapshotBlock Block when the distribution of the parent token is
135     ///  copied to set the initial distribution of the new clone token;
136     ///  if the block is zero than the actual block, the current block is used
137     /// @param _transfersEnabled True if transfers are allowed in the clone
138     /// @return The address of the new MiniMeToken Contract
139     function createCloneToken(
140         string _cloneTokenName,
141         uint8 _cloneDecimalUnits,
142         string _cloneTokenSymbol,
143         uint _snapshotBlock,
144         bool _transfersEnabled
145     ) returns(address);
146 
147 ////////////////
148 // Generate and destroy tokens
149 ////////////////
150 
151     /// @notice Generates `_amount` tokens that are assigned to `_owner`
152     /// @param _owner The address that will be assigned the new tokens
153     /// @param _amount The quantity of tokens generated
154     /// @return True if the tokens are generated correctly
155     function generateTokens(address _owner, uint _amount) returns (bool);
156 
157 
158     /// @notice Burns `_amount` tokens from `_owner`
159     /// @param _owner The address that will lose the tokens
160     /// @param _amount The quantity of tokens to burn
161     /// @return True if the tokens are burned correctly
162     function destroyTokens(address _owner, uint _amount) returns (bool);
163 
164 ////////////////
165 // Enable tokens transfers
166 ////////////////
167 
168     /// @notice Enables token holders to transfer their tokens freely if true
169     /// @param _transfersEnabled True if transfers are allowed in the clone
170     function enableTransfers(bool _transfersEnabled);
171 
172 //////////
173 // Safety Methods
174 //////////
175 
176     /// @notice This method can be used by the controller to extract mistakenly
177     ///  sent tokens to this contract.
178     /// @param _token The address of the token contract that you want to recover
179     ///  set to 0 in case you want to extract ether.
180     function claimTokens(address _token);
181 
182 ////////////////
183 // Events
184 ////////////////
185 
186     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
187     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
188 }
189 
190 /*
191   Copyright 2017, Jorge Izquierdo (Aragon Foundation)
192   Copyright 2017, Jordi Baylina (Giveth)
193 
194   Based on MiniMeToken.sol from https://github.com/Giveth/minime
195   Original contract from https://github.com/aragon/aragon-network-token/blob/master/contracts/interface/Controller.sol
196 */
197 /// @dev The token controller contract must implement these functions
198 contract TokenController {
199     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
200     /// @param _owner The address that sent the ether to create tokens
201     /// @return True if the ether is accepted, false if it throws
202     function proxyPayment(address _owner) payable returns(bool);
203 
204     /// @notice Notifies the controller about a token transfer allowing the
205     ///  controller to react if desired
206     /// @param _from The origin of the transfer
207     /// @param _to The destination of the transfer
208     /// @param _amount The amount of the transfer
209     /// @return False if the controller does not authorize the transfer
210     function onTransfer(address _from, address _to, uint _amount) returns(bool);
211 
212     /// @notice Notifies the controller about an approval allowing the
213     ///  controller to react if desired
214     /// @param _owner The address that calls `approve()`
215     /// @param _spender The spender in the `approve()` call
216     /// @param _amount The amount in the `approve()` call
217     /// @return False if the controller does not authorize the approval
218     function onApprove(address _owner, address _spender, uint _amount) returns(bool);
219 }
220 
221 
222 /*
223   Copyright 2017, Jordi Baylina (Giveth)
224 
225   Original contract from https://github.com/aragon/aragon-network-token/blob/master/contracts/interface/ApproveAndCallReceiver.sol
226 */
227 contract ApproveAndCallReceiver {
228     function receiveApproval(
229         address _from, 
230         uint256 _amount, 
231         address _token, 
232         bytes _data
233     );
234 }
235 
236  
237 /*
238   Copyright 2017, Anton Egorov (Mothership Foundation)
239   Copyright 2017, Jordi Baylina (Giveth)
240 
241   Based on MineMeToken.sol from https://github.com/Giveth/minime
242   Original contract from https://github.com/status-im/status-network-token/blob/master/contracts/MiniMeToken.sol
243 */
244 /// @title MiniMeToken Contract
245 /// @author Jordi Baylina
246 /// @dev This token contract's goal is to make it easy for anyone to clone this
247 ///  token using the token distribution at a given block, this will allow DAO's
248 ///  and DApps to upgrade their features in a decentralized manner without
249 ///  affecting the original token
250 /// @dev It is ERC20 compliant, but still needs to under go further testing.
251 
252 /// @dev The actual token contract, the default controller is the msg.sender
253 ///  that deploys the contract, so usually this token will be deployed by a
254 ///  token controller contract, which Giveth will call a "Campaign"
255 contract MiniMeToken is MiniMeTokenI {
256 
257     string public name;                //The Token's name: e.g. DigixDAO Tokens
258     uint8 public decimals;             //Number of decimals of the smallest unit
259     string public symbol;              //An identifier: e.g. REP
260     string public version = "MMT_0.1"; //An arbitrary versioning scheme
261 
262     /// @dev `Checkpoint` is the structure that attaches a block number to a
263     ///  given value, the block number attached is the one that last changed the
264     ///  value
265     struct Checkpoint {
266 
267         // `fromBlock` is the block number that the value was generated from
268         uint128 fromBlock;
269 
270         // `value` is the amount of tokens at a specific block number
271         uint128 value;
272     }
273 
274     // `parentToken` is the Token address that was cloned to produce this token;
275     //  it will be 0x0 for a token that was not cloned
276     MiniMeToken public parentToken;
277 
278     // `parentSnapShotBlock` is the block number from the Parent Token that was
279     //  used to determine the initial distribution of the Clone Token
280     uint public parentSnapShotBlock;
281 
282     // `creationBlock` is the block number that the Clone Token was created
283     uint public creationBlock;
284 
285     // `balances` is the map that tracks the balance of each address, in this
286     //  contract when the balance changes the block number that the change
287     //  occurred is also included in the map
288     mapping (address => Checkpoint[]) balances;
289 
290     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
291     mapping (address => mapping (address => uint256)) allowed;
292 
293     // Tracks the history of the `totalSupply` of the token
294     Checkpoint[] totalSupplyHistory;
295 
296     // Flag that determines if the token is transferable or not.
297     bool public transfersEnabled;
298 
299     // The factory used to create new clone tokens
300     MiniMeTokenFactory public tokenFactory;
301 
302 ////////////////
303 // Constructor
304 ////////////////
305 
306     /// @notice Constructor to create a MiniMeToken
307     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
308     ///  will create the Clone token contracts, the token factory needs to be
309     ///  deployed first
310     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
311     ///  new token
312     /// @param _parentSnapShotBlock Block of the parent token that will
313     ///  determine the initial distribution of the clone token, set to 0 if it
314     ///  is a new token
315     /// @param _tokenName Name of the new token
316     /// @param _decimalUnits Number of decimals of the new token
317     /// @param _tokenSymbol Token Symbol for the new token
318     /// @param _transfersEnabled If true, tokens will be able to be transferred
319     function MiniMeToken(
320         address _tokenFactory,
321         address _parentToken,
322         uint _parentSnapShotBlock,
323         string _tokenName,
324         uint8 _decimalUnits,
325         string _tokenSymbol,
326         bool _transfersEnabled
327     ) {
328         tokenFactory = MiniMeTokenFactory(_tokenFactory);
329         name = _tokenName;                                 // Set the name
330         decimals = _decimalUnits;                          // Set the decimals
331         symbol = _tokenSymbol;                             // Set the symbol
332         parentToken = MiniMeToken(_parentToken);
333         parentSnapShotBlock = _parentSnapShotBlock;
334         transfersEnabled = _transfersEnabled;
335         creationBlock = block.number;
336     }
337 
338 ///////////////////
339 // ERC20 Methods
340 ///////////////////
341 
342     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
343     /// @param _to The address of the recipient
344     /// @param _amount The amount of tokens to be transferred
345     /// @return Whether the transfer was successful or not
346     function transfer(address _to, uint256 _amount) returns (bool success) {
347         require(transfersEnabled);
348         return doTransfer(msg.sender, _to, _amount);
349     }
350 
351     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
352     ///  is approved by `_from`
353     /// @param _from The address holding the tokens being transferred
354     /// @param _to The address of the recipient
355     /// @param _amount The amount of tokens to be transferred
356     /// @return True if the transfer was successful
357     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
358 
359         // The controller of this contract can move tokens around at will,
360         //  this is important to recognize! Confirm that you trust the
361         //  controller of this contract, which in most situations should be
362         //  another open source smart contract or 0x0
363         if (msg.sender != controller) {
364             require(transfersEnabled);
365 
366             // The standard ERC 20 transferFrom functionality
367             if (allowed[_from][msg.sender] < _amount) {
368                 return false;
369             }
370             allowed[_from][msg.sender] -= _amount;
371         }
372         return doTransfer(_from, _to, _amount);
373     }
374 
375     /// @dev This is the actual transfer function in the token contract, it can
376     ///  only be called by other functions in this contract.
377     /// @param _from The address holding the tokens being transferred
378     /// @param _to The address of the recipient
379     /// @param _amount The amount of tokens to be transferred
380     /// @return True if the transfer was successful
381     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
382 
383         if (_amount == 0) {
384             return true;
385         }
386 
387         require(parentSnapShotBlock < block.number);
388 
389         // Do not allow transfer to 0x0 or the token contract itself
390         require((_to != 0) && (_to != address(this)));
391 
392         // If the amount being transfered is more than the balance of the
393         //  account the transfer returns false
394         var previousBalanceFrom = balanceOfAt(_from, block.number);
395         if (previousBalanceFrom < _amount) {
396             return false;
397         }
398 
399         // Alerts the token controller of the transfer
400         if (isContract(controller)) {
401             bool onTransfer = TokenController(controller).onTransfer(_from, _to, _amount);
402             require(onTransfer);
403         }
404 
405         // First update the balance array with the new value for the address
406         //  sending the tokens
407         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
408 
409         // Then update the balance array with the new value for the address
410         //  receiving the tokens
411         var previousBalanceTo = balanceOfAt(_to, block.number);
412         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
413         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
414 
415         // An event to make the transfer easy to find on the blockchain
416         Transfer(_from, _to, _amount);
417 
418         return true;
419     }
420 
421     /// @param _owner The address that's balance is being requested
422     /// @return The balance of `_owner` at the current block
423     function balanceOf(address _owner) constant returns (uint256 balance) {
424         return balanceOfAt(_owner, block.number);
425     }
426 
427     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
428     ///  its behalf. This is a modified version of the ERC20 approve function
429     ///  to be a little bit safer
430     /// @param _spender The address of the account able to transfer the tokens
431     /// @param _amount The amount of tokens to be approved for transfer
432     /// @return True if the approval was successful
433     function approve(address _spender, uint256 _amount) returns (bool success) {
434         require(transfersEnabled);
435 
436         // To change the approve amount you first have to reduce the addresses`
437         //  allowance to zero by calling `approve(_spender,0)` if it is not
438         //  already 0 to mitigate the race condition described here:
439         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
440         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
441 
442         // Alerts the token controller of the approve function call
443         if (isContract(controller)) {
444             bool onApprove = TokenController(controller).onApprove(msg.sender, _spender, _amount);
445             require(onApprove);
446         }
447 
448         allowed[msg.sender][_spender] = _amount;
449         Approval(msg.sender, _spender, _amount);
450         return true;
451     }
452 
453     /// @dev This function makes it easy to read the `allowed[]` map
454     /// @param _owner The address of the account that owns the token
455     /// @param _spender The address of the account able to transfer the tokens
456     /// @return Amount of remaining tokens of _owner that _spender is allowed
457     ///  to spend
458     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
459         return allowed[_owner][_spender];
460     }
461 
462     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
463     ///  its behalf, and then a function is triggered in the contract that is
464     ///  being approved, `_spender`. This allows users to use their tokens to
465     ///  interact with contracts in one function call instead of two
466     /// @param _spender The address of the contract able to transfer the tokens
467     /// @param _amount The amount of tokens to be approved for transfer
468     /// @return True if the function call was successful
469     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
470         require(approve(_spender, _amount));
471 
472         ApproveAndCallReceiver(_spender).receiveApproval(
473             msg.sender,
474             _amount,
475             this,
476             _extraData
477         );
478 
479         return true;
480     }
481 
482     /// @dev This function makes it easy to get the total number of tokens
483     /// @return The total number of tokens
484     function totalSupply() constant returns (uint) {
485         return totalSupplyAt(block.number);
486     }
487 
488 ////////////////
489 // Query balance and totalSupply in History
490 ////////////////
491 
492     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
493     /// @param _owner The address from which the balance will be retrieved
494     /// @param _blockNumber The block number when the balance is queried
495     /// @return The balance at `_blockNumber`
496     function balanceOfAt(address _owner, uint _blockNumber) constant returns (uint) {
497 
498         // These next few lines are used when the balance of the token is
499         //  requested before a check point was ever created for this token, it
500         //  requires that the `parentToken.balanceOfAt` be queried at the
501         //  genesis block for that token as this contains initial balance of
502         //  this token
503         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
504             if (address(parentToken) != 0) {
505                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
506             } else {
507                 // Has no parent
508                 return 0;
509             }
510 
511         // This will return the expected balance during normal situations
512         } else {
513             return getValueAt(balances[_owner], _blockNumber);
514         }
515     }
516 
517     /// @notice Total amount of tokens at a specific `_blockNumber`.
518     /// @param _blockNumber The block number when the totalSupply is queried
519     /// @return The total amount of tokens at `_blockNumber`
520     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
521 
522         // These next few lines are used when the totalSupply of the token is
523         //  requested before a check point was ever created for this token, it
524         //  requires that the `parentToken.totalSupplyAt` be queried at the
525         //  genesis block for this token as that contains totalSupply of this
526         //  token at this block number.
527         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
528             if (address(parentToken) != 0) {
529                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
530             } else {
531                 return 0;
532             }
533 
534         // This will return the expected totalSupply during normal situations
535         } else {
536             return getValueAt(totalSupplyHistory, _blockNumber);
537         }
538     }
539 
540 ////////////////
541 // Clone Token Method
542 ////////////////
543 
544     /// @notice Creates a new clone token with the initial distribution being
545     ///  this token at `_snapshotBlock`
546     /// @param _cloneTokenName Name of the clone token
547     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
548     /// @param _cloneTokenSymbol Symbol of the clone token
549     /// @param _snapshotBlock Block when the distribution of the parent token is
550     ///  copied to set the initial distribution of the new clone token;
551     ///  if the block is zero than the actual block, the current block is used
552     /// @param _transfersEnabled True if transfers are allowed in the clone
553     /// @return The address of the new MiniMeToken Contract
554     function createCloneToken(
555         string _cloneTokenName, 
556         uint8 _cloneDecimalUnits, 
557         string _cloneTokenSymbol, 
558         uint _snapshotBlock, 
559         bool _transfersEnabled
560     ) returns(address) 
561     {
562 
563         if (_snapshotBlock == 0) {
564             _snapshotBlock = block.number;
565         }
566 
567         MiniMeToken cloneToken = tokenFactory.createCloneToken(
568             this,
569             _snapshotBlock,
570             _cloneTokenName,
571             _cloneDecimalUnits,
572             _cloneTokenSymbol,
573             _transfersEnabled
574         );
575 
576         cloneToken.changeController(msg.sender);
577 
578         // An event to make the token easy to find on the blockchain
579         NewCloneToken(address(cloneToken), _snapshotBlock);
580         return address(cloneToken);
581     }
582 
583 ////////////////
584 // Generate and destroy tokens
585 ////////////////
586 
587     /// @notice Generates `_amount` tokens that are assigned to `_owner`
588     /// @param _owner The address that will be assigned the new tokens
589     /// @param _amount The quantity of tokens generated
590     /// @return True if the tokens are generated correctly
591     function generateTokens(address _owner, uint _amount) onlyController returns (bool) {
592         uint curTotalSupply = totalSupply();
593         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
594         uint previousBalanceTo = balanceOf(_owner);
595         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
596         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
597         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
598         Transfer(0, _owner, _amount);
599         return true;
600     }
601 
602     /// @notice Burns `_amount` tokens from `_owner`
603     /// @param _owner The address that will lose the tokens
604     /// @param _amount The quantity of tokens to burn
605     /// @return True if the tokens are burned correctly
606     function destroyTokens(address _owner, uint _amount) onlyController returns (bool) {
607         uint curTotalSupply = totalSupply();
608         require(curTotalSupply >= _amount);
609         uint previousBalanceFrom = balanceOf(_owner);
610         require(previousBalanceFrom >= _amount);
611         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
612         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
613         Transfer(_owner, 0, _amount);
614         return true;
615     }
616 
617 ////////////////
618 // Enable tokens transfers
619 ////////////////
620 
621     /// @notice Enables token holders to transfer their tokens freely if true
622     /// @param _transfersEnabled True if transfers are allowed in the clone
623     function enableTransfers(bool _transfersEnabled) onlyController {
624         transfersEnabled = _transfersEnabled;
625     }
626 
627 ////////////////
628 // Internal helper functions to query and set a value in a snapshot array
629 ////////////////
630 
631     /// @dev `getValueAt` retrieves the number of tokens at a given block number
632     /// @param checkpoints The history of values being queried
633     /// @param _block The block number to retrieve the value at
634     /// @return The number of tokens being queried
635     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
636         if (checkpoints.length == 0) {
637             return 0;
638         }
639 
640         // Shortcut for the actual value
641         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
642             return checkpoints[checkpoints.length-1].value;
643         if (_block < checkpoints[0].fromBlock) {
644             return 0;
645         }
646 
647         // Binary search of the value in the array
648         uint min = 0;
649         uint max = checkpoints.length-1;
650         while (max > min) {
651             uint mid = (max + min + 1) / 2;
652             if (checkpoints[mid].fromBlock<=_block) {
653                 min = mid;
654             } else {
655                 max = mid-1;
656             }
657         }
658         return checkpoints[min].value;
659     }
660 
661     /// @dev `updateValueAtNow` used to update the `balances` map and the
662     ///  `totalSupplyHistory`
663     /// @param checkpoints The history of data being updated
664     /// @param _value The new number of tokens
665     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
666         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
667             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
668             newCheckPoint.fromBlock = uint128(block.number);
669             newCheckPoint.value = uint128(_value);
670         } else {
671             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
672             oldCheckPoint.value = uint128(_value);
673         }
674     }
675 
676     /// @dev Internal function to determine if an address is a contract
677     /// @param _addr The address being queried
678     /// @return True if `_addr` is a contract
679     function isContract(address _addr) constant internal returns(bool) {
680         uint size;
681         if (_addr == 0) {
682             return false;
683         }
684         assembly {
685             size := extcodesize(_addr)
686         }
687         return size>0;
688     }
689 
690     /// @dev Helper function to return a min betwen the two uints
691     function min(uint a, uint b) internal returns (uint) {
692         return a < b ? a : b;
693     }
694 
695     /// @notice The fallback function: If the contract's controller has not been
696     ///  set to 0, then the `proxyPayment` method is called which relays the
697     ///  ether and creates tokens as described in the token controller contract
698     function ()  payable {
699         require(isContract(controller));
700         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
701         require(proxyPayment);
702     }
703 
704 //////////
705 // Safety Methods
706 //////////
707 
708     /// @notice This method can be used by the controller to extract mistakenly
709     ///  sent tokens to this contract.
710     /// @param _token The address of the token contract that you want to recover
711     ///  set to 0 in case you want to extract ether.
712     function claimTokens(address _token) onlyController {
713         if (_token == 0x0) {
714             controller.transfer(this.balance);
715             return;
716         }
717 
718         MiniMeToken token = MiniMeToken(_token);
719         uint balance = token.balanceOf(this);
720         token.transfer(controller, balance);
721         ClaimedTokens(_token, controller, balance);
722     }
723 
724 ////////////////
725 // Events
726 ////////////////
727     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
728     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
729     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
730     event Approval(
731         address indexed _owner,
732         address indexed _spender,
733         uint256 _amount
734     );
735 }
736 
737 
738 
739 ////////////////
740 // MiniMeTokenFactory
741 ////////////////
742 
743 /// @dev This contract is used to generate clone contracts from a contract.
744 ///  In solidity this is the way to create a contract from a contract of the
745 ///  same class
746 contract MiniMeTokenFactory {
747 
748     /// @notice Update the DApp by creating a new token with new functionalities
749     ///  the msg.sender becomes the controller of this clone token
750     /// @param _parentToken Address of the token being cloned
751     /// @param _snapshotBlock Block of the parent token that will
752     ///  determine the initial distribution of the clone token
753     /// @param _tokenName Name of the new token
754     /// @param _decimalUnits Number of decimals of the new token
755     /// @param _tokenSymbol Token Symbol for the new token
756     /// @param _transfersEnabled If true, tokens will be able to be transferred
757     /// @return The address of the new token contract
758     function createCloneToken(
759         address _parentToken,
760         uint _snapshotBlock,
761         string _tokenName,
762         uint8 _decimalUnits,
763         string _tokenSymbol,
764         bool _transfersEnabled
765     ) returns (MiniMeToken) 
766     {
767         MiniMeToken newToken = new MiniMeToken(
768             this,
769             _parentToken,
770             _snapshotBlock,
771             _tokenName,
772             _decimalUnits,
773             _tokenSymbol,
774             _transfersEnabled
775         );
776 
777         newToken.changeController(msg.sender);
778         return newToken;
779     }
780 }
781 
782 contract DataBrokerDaoToken is MiniMeToken {  
783 
784     function DataBrokerDaoToken(address _tokenFactory) MiniMeToken(   
785       _tokenFactory,
786       0x0,                    // no parent token
787       0,                      // no snapshot block number from parent
788       "DataBroker DAO Token", // Token name
789       18,                     // Decimals
790       "DATA",                 // Symbol
791       true                   // Enable transfers
792       ) 
793       {}
794 
795 }
796 
797 pragma solidity ^0.4.15;
798 
799 
800 /**
801  * @title SafeMath
802  * @dev Math operations with safety checks that throw on error
803  */
804 library SafeMath {
805 
806     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
807         uint256 c = a * b;
808         assert(a == 0 || c / a == b);
809         return c;
810     }
811 
812     function div(uint256 a, uint256 b) internal constant returns (uint256) {
813         // assert(b > 0); // Solidity automatically throws when dividing by 0
814         uint256 c = a / b;
815         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
816         return c;
817     }
818 
819     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
820         assert(b <= a);
821         return a - b;
822     }
823 
824     function add(uint256 a, uint256 b) internal constant returns (uint256) {
825         uint256 c = a + b;
826         assert(c >= a);
827         return c;
828     }
829 }
830 
831 contract EarlyTokenSale is TokenController, Controlled {
832 
833     using SafeMath for uint256;
834 
835     // In UNIX time format - http://www.unixtimestamp.com/
836     uint256 public startFundingTime;       
837     uint256 public endFundingTime;
838     
839     // 15% of tokens hard cap, at 1200 tokens per ETH
840     // 225,000,000*0.15 => 33,750,000 / 1200 => 28,125 ETH
841     uint256 constant public maximumFunding = 28125 ether;
842     uint256 constant public tokensPerEther = 1200; 
843     uint256 constant public maxGasPrice = 50000000000;
844     
845     // antispam
846     uint256 constant public maxCallFrequency = 100;
847     mapping (address => uint256) public lastCallBlock; 
848 
849     // total amount raised in wei
850     uint256 public totalCollected;
851 
852     // the tokencontract for the DataBrokerDAO
853     DataBrokerDaoToken public tokenContract;
854 
855     // the funds end up in this address
856     address public vaultAddress;
857 
858     bool public paused;
859     bool public finalized = false;
860 
861     /// @param _startFundingTime The UNIX time that the EarlyTokenSale will be able to start receiving funds
862     /// @param _endFundingTime   The UNIX time that the EarlyTokenSale will stop being able to receive funds
863     /// @param _vaultAddress     The address that will store the donated funds
864     /// @param _tokenAddress     Address of the token contract this contract controls
865     function EarlyTokenSale(
866         uint _startFundingTime, 
867         uint _endFundingTime, 
868         address _vaultAddress, 
869         address _tokenAddress
870     ) {
871         require(_endFundingTime > now);
872         require(_endFundingTime >= _startFundingTime);
873         require(_vaultAddress != 0);
874         require(_tokenAddress != 0);
875 
876         startFundingTime = _startFundingTime;
877         endFundingTime = _endFundingTime;
878         tokenContract = DataBrokerDaoToken(_tokenAddress);
879         vaultAddress = _vaultAddress;
880         paused = false;
881     }
882 
883     /// @dev The fallback function is called when ether is sent to the contract, it
884     /// simply calls `doPayment()` with the address that sent the ether as the
885     /// `_owner`. Payable is a required solidity modifier for functions to receive
886     /// ether, without this modifier functions will throw if ether is sent to them
887     function () payable notPaused {
888         doPayment(msg.sender);
889     }
890 
891     /// @notice `proxyPayment()` allows the caller to send ether to the EarlyTokenSale and
892     /// have the tokens created in an address of their choosing
893     /// @param _owner The address that will hold the newly created tokens
894     function proxyPayment(address _owner) payable notPaused returns(bool success) {
895         return doPayment(_owner);
896     }
897 
898     /// @notice Notifies the controller about a transfer, for this EarlyTokenSale all
899     /// transfers are allowed by default and no extra notifications are needed
900     /// @param _from The origin of the transfer
901     /// @param _to The destination of the transfer
902     /// @param _amount The amount of the transfer
903     /// @return False if the controller does not authorize the transfer
904     function onTransfer(address _from, address _to, uint _amount) returns(bool success) {
905         if ( _from == vaultAddress ) {
906             return true;
907         }
908         return false;
909     }
910 
911     /// @notice Notifies the controller about an approval, for this EarlyTokenSale all
912     /// approvals are allowed by default and no extra notifications are needed
913     /// @param _owner The address that calls `approve()`
914     /// @param _spender The spender in the `approve()` call
915     /// @param _amount The amount in the `approve()` call
916     /// @return False if the controller does not authorize the approval
917     function onApprove(address _owner, address _spender, uint _amount) returns(bool success) {
918         if ( _owner == vaultAddress ) {
919             return true;
920         }
921         return false;
922     }
923 
924     /// @dev `doPayment()` is an internal function that sends the ether that this
925     ///  contract receives to the `vault` and creates tokens in the address of the
926     ///  `_owner` assuming the EarlyTokenSale is still accepting funds
927     /// @param _owner The address that will hold the newly created tokens
928     function doPayment(address _owner) internal returns(bool success) {
929         require(tx.gasprice <= maxGasPrice);
930 
931         // Antispam
932         // do not allow contracts to game the system
933         require(!isContract(msg.sender));
934         // limit the amount of contributions to once per 100 blocks
935         require(getBlockNumber().sub(lastCallBlock[msg.sender]) >= maxCallFrequency);
936         lastCallBlock[msg.sender] = getBlockNumber();
937 
938         // First check that the EarlyTokenSale is allowed to receive this donation
939         if (msg.sender != controller) {
940             require(startFundingTime <= now);
941         }
942         require(endFundingTime > now);
943         require(tokenContract.controller() != 0);
944         require(msg.value > 0);
945         require(totalCollected.add(msg.value) <= maximumFunding);
946 
947         // Track how much the EarlyTokenSale has collected
948         totalCollected = totalCollected.add(msg.value);
949 
950         //Send the ether to the vault
951         require(vaultAddress.send(msg.value));
952 
953         // Creates an equal amount of tokens as ether sent. The new tokens are created in the `_owner` address
954         require(tokenContract.generateTokens(_owner, tokensPerEther.mul(msg.value)));
955         
956         return true;
957     }
958 
959     /// @dev Internal function to determine if an address is a contract
960     /// @param _addr The address being queried
961     /// @return True if `_addr` is a contract
962     function isContract(address _addr) constant internal returns (bool) {
963         if (_addr == 0) {
964             return false;
965         }
966         uint256 size;
967         assembly {
968             size := extcodesize(_addr)
969         }
970         return (size > 0);
971     }
972 
973     /// @notice `finalizeSale()` ends the EarlyTokenSale. It will generate the platform and team tokens
974     ///  and set the controller to the referral fee contract.
975     /// @dev `finalizeSale()` can only be called after the end of the funding period or if the maximum amount is raised.
976     function finalizeSale() onlyController {
977         require(now > endFundingTime || totalCollected >= maximumFunding);
978         require(!finalized);
979 
980         uint256 reservedTokens = 225000000 * 0.35 * 10**18;      
981         if (!tokenContract.generateTokens(vaultAddress, reservedTokens)) {
982             revert();
983         }
984 
985         finalized = true;
986     }
987 
988 //////////
989 // Testing specific methods
990 //////////
991 
992     /// @notice This function is overridden by the tests.
993     function getBlockNumber() internal constant returns (uint256) {
994         return block.number;
995     }
996 
997 //////////
998 // Safety Methods
999 //////////
1000 
1001     /// @notice This method can be used by the controller to extract mistakenly
1002     ///  sent tokens to this contract.
1003     /// @param _token The address of the token contract that you want to recover
1004     ///  set to 0 in case you want to extract ether.
1005     function claimTokens(address _token) onlyController {
1006         if (_token == 0x0) {
1007             controller.transfer(this.balance);
1008             return;
1009         }
1010 
1011         ERC20Token token = ERC20Token(_token);
1012         uint balance = token.balanceOf(this);
1013         token.transfer(controller, balance);
1014         ClaimedTokens(_token, controller, balance);
1015     }
1016 
1017     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1018 
1019   /// @notice Pauses the contribution if there is any issue
1020     function pauseContribution() onlyController {
1021         paused = true;
1022     }
1023 
1024     /// @notice Resumes the contribution
1025     function resumeContribution() onlyController {
1026         paused = false;
1027     }
1028 
1029     modifier notPaused() {
1030         require(!paused);
1031         _;
1032     }
1033 }