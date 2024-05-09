1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 pragma solidity ^0.4.15;
35 
36 /*
37     Copyright 2016, Jordi Baylina
38 
39     This program is free software: you can redistribute it and/or modify
40     it under the terms of the GNU General Public License as published by
41     the Free Software Foundation, either version 3 of the License, or
42     (at your option) any later version.
43 
44     This program is distributed in the hope that it will be useful,
45     but WITHOUT ANY WARRANTY; without even the implied warranty of
46     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
47     GNU General Public License for more details.
48 
49     You should have received a copy of the GNU General Public License
50     along with this program.  If not, see <http://www.gnu.org/licenses/>.
51  */
52 
53 /// @title MiniMeToken Contract
54 /// @author Jordi Baylina
55 /// @dev This token contract's goal is to make it easy for anyone to clone this
56 ///  token using the token distribution at a given block, this will allow DAO's
57 ///  and DApps to upgrade their features in a decentralized manner without
58 ///  affecting the original token
59 /// @dev It is ERC20 compliant, but still needs to under go further testing.
60 
61 
62 /// @dev The token controller contract must implement these functions
63 contract TokenController {
64     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
65     /// @param _owner The address that sent the ether to create tokens
66     /// @return True if the ether is accepted, false if it throws
67     function proxyPayment(address _owner) payable returns(bool);
68 
69     /// @notice Notifies the controller about a token transfer allowing the
70     ///  controller to react if desired
71     /// @param _from The origin of the transfer
72     /// @param _to The destination of the transfer
73     /// @param _amount The amount of the transfer
74     /// @return False if the controller does not authorize the transfer
75     function onTransfer(address _from, address _to, uint _amount) returns(bool);
76 
77     /// @notice Notifies the controller about an approval allowing the
78     ///  controller to react if desired
79     /// @param _owner The address that calls `approve()`
80     /// @param _spender The spender in the `approve()` call
81     /// @param _amount The amount in the `approve()` call
82     /// @return False if the controller does not authorize the approval
83     function onApprove(address _owner, address _spender, uint _amount)
84         returns(bool);
85 }
86 
87 contract Controlled {
88     /// @notice The address of the controller is the only address that can call
89     ///  a function with this modifier
90     modifier onlyController { require(msg.sender == controller); _; }
91 
92     address public controller;
93 
94     function Controlled() { controller = msg.sender;}
95 
96     /// @notice Changes the controller of the contract
97     /// @param _newController The new controller of the contract
98     function changeController(address _newController) onlyController {
99         controller = _newController;
100     }
101 }
102 
103 contract ApproveAndCallFallBack {
104     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
105 }
106 
107 /// @dev The actual token contract, the default controller is the msg.sender
108 ///  that deploys the contract, so usually this token will be deployed by a
109 ///  token controller contract, which Giveth will call a "Campaign"
110 contract MiniMeToken is Controlled {
111 
112     string public name;                //The Token's name: e.g. DigixDAO Tokens
113     uint8 public decimals;             //Number of decimals of the smallest unit
114     string public symbol;              //An identifier: e.g. REP
115     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
116 
117 
118     /// @dev `Checkpoint` is the structure that attaches a block number to a
119     ///  given value, the block number attached is the one that last changed the
120     ///  value
121     struct  Checkpoint {
122 
123         // `fromBlock` is the block number that the value was generated from
124         uint128 fromBlock;
125 
126         // `value` is the amount of tokens at a specific block number
127         uint128 value;
128     }
129 
130     // `parentToken` is the Token address that was cloned to produce this token;
131     //  it will be 0x0 for a token that was not cloned
132     MiniMeToken public parentToken;
133 
134     // `parentSnapShotBlock` is the block number from the Parent Token that was
135     //  used to determine the initial distribution of the Clone Token
136     uint public parentSnapShotBlock;
137 
138     // `creationBlock` is the block number that the Clone Token was created
139     uint public creationBlock;
140 
141     // `balances` is the map that tracks the balance of each address, in this
142     //  contract when the balance changes the block number that the change
143     //  occurred is also included in the map
144     mapping (address => Checkpoint[]) balances;
145 
146     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
147     mapping (address => mapping (address => uint256)) allowed;
148 
149     // Tracks the history of the `totalSupply` of the token
150     Checkpoint[] totalSupplyHistory;
151 
152     // Flag that determines if the token is transferable or not.
153     bool public transfersEnabled;
154 
155     // The factory used to create new clone tokens
156     MiniMeTokenFactory public tokenFactory;
157 
158 ////////////////
159 // Constructor
160 ////////////////
161 
162     /// @notice Constructor to create a MiniMeToken
163     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
164     ///  will create the Clone token contracts, the token factory needs to be
165     ///  deployed first
166     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
167     ///  new token
168     /// @param _parentSnapShotBlock Block of the parent token that will
169     ///  determine the initial distribution of the clone token, set to 0 if it
170     ///  is a new token
171     /// @param _tokenName Name of the new token
172     /// @param _decimalUnits Number of decimals of the new token
173     /// @param _tokenSymbol Token Symbol for the new token
174     /// @param _transfersEnabled If true, tokens will be able to be transferred
175     function MiniMeToken(
176         address _tokenFactory,
177         address _parentToken,
178         uint _parentSnapShotBlock,
179         string _tokenName,
180         uint8 _decimalUnits,
181         string _tokenSymbol,
182         bool _transfersEnabled
183     ) {
184         tokenFactory = MiniMeTokenFactory(_tokenFactory);
185         name = _tokenName;                                 // Set the name
186         decimals = _decimalUnits;                          // Set the decimals
187         symbol = _tokenSymbol;                             // Set the symbol
188         parentToken = MiniMeToken(_parentToken);
189         parentSnapShotBlock = _parentSnapShotBlock;
190         transfersEnabled = _transfersEnabled;
191         creationBlock = block.number;
192     }
193 
194 
195 ///////////////////
196 // ERC20 Methods
197 ///////////////////
198 
199     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
200     /// @param _to The address of the recipient
201     /// @param _amount The amount of tokens to be transferred
202     /// @return Whether the transfer was successful or not
203     function transfer(address _to, uint256 _amount) returns (bool success) {
204         require(transfersEnabled);
205         return doTransfer(msg.sender, _to, _amount);
206     }
207 
208     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
209     ///  is approved by `_from`
210     /// @param _from The address holding the tokens being transferred
211     /// @param _to The address of the recipient
212     /// @param _amount The amount of tokens to be transferred
213     /// @return True if the transfer was successful
214     function transferFrom(address _from, address _to, uint256 _amount
215     ) returns (bool success) {
216 
217         // The controller of this contract can move tokens around at will,
218         //  this is important to recognize! Confirm that you trust the
219         //  controller of this contract, which in most situations should be
220         //  another open source smart contract or 0x0
221         if (msg.sender != controller) {
222             require(transfersEnabled);
223 
224             // The standard ERC 20 transferFrom functionality
225             if (allowed[_from][msg.sender] < _amount) return false;
226             allowed[_from][msg.sender] -= _amount;
227         }
228         return doTransfer(_from, _to, _amount);
229     }
230 
231     /// @dev This is the actual transfer function in the token contract, it can
232     ///  only be called by other functions in this contract.
233     /// @param _from The address holding the tokens being transferred
234     /// @param _to The address of the recipient
235     /// @param _amount The amount of tokens to be transferred
236     /// @return True if the transfer was successful
237     function doTransfer(address _from, address _to, uint _amount
238     ) internal returns(bool) {
239 
240            if (_amount == 0) {
241                return true;
242            }
243 
244            require(parentSnapShotBlock < block.number);
245 
246            // Do not allow transfer to 0x0 or the token contract itself
247            require((_to != 0) && (_to != address(this)));
248 
249            // If the amount being transfered is more than the balance of the
250            //  account the transfer returns false
251            var previousBalanceFrom = balanceOfAt(_from, block.number);
252            if (previousBalanceFrom < _amount) {
253                return false;
254            }
255 
256            // Alerts the token controller of the transfer
257            if (isContract(controller)) {
258                require(TokenController(controller).onTransfer(_from, _to, _amount));
259            }
260 
261            // First update the balance array with the new value for the address
262            //  sending the tokens
263            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
264 
265            // Then update the balance array with the new value for the address
266            //  receiving the tokens
267            var previousBalanceTo = balanceOfAt(_to, block.number);
268            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
269            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
270 
271            // An event to make the transfer easy to find on the blockchain
272            Transfer(_from, _to, _amount);
273 
274            return true;
275     }
276 
277     /// @param _owner The address that's balance is being requested
278     /// @return The balance of `_owner` at the current block
279     function balanceOf(address _owner) constant returns (uint256 balance) {
280         return balanceOfAt(_owner, block.number);
281     }
282 
283     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
284     ///  its behalf. This is a modified version of the ERC20 approve function
285     ///  to be a little bit safer
286     /// @param _spender The address of the account able to transfer the tokens
287     /// @param _amount The amount of tokens to be approved for transfer
288     /// @return True if the approval was successful
289     function approve(address _spender, uint256 _amount) returns (bool success) {
290         require(transfersEnabled);
291 
292         // To change the approve amount you first have to reduce the addresses`
293         //  allowance to zero by calling `approve(_spender,0)` if it is not
294         //  already 0 to mitigate the race condition described here:
295         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
297 
298         // Alerts the token controller of the approve function call
299         if (isContract(controller)) {
300             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
301         }
302 
303         allowed[msg.sender][_spender] = _amount;
304         Approval(msg.sender, _spender, _amount);
305         return true;
306     }
307 
308     /// @dev This function makes it easy to read the `allowed[]` map
309     /// @param _owner The address of the account that owns the token
310     /// @param _spender The address of the account able to transfer the tokens
311     /// @return Amount of remaining tokens of _owner that _spender is allowed
312     ///  to spend
313     function allowance(address _owner, address _spender
314     ) constant returns (uint256 remaining) {
315         return allowed[_owner][_spender];
316     }
317 
318     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
319     ///  its behalf, and then a function is triggered in the contract that is
320     ///  being approved, `_spender`. This allows users to use their tokens to
321     ///  interact with contracts in one function call instead of two
322     /// @param _spender The address of the contract able to transfer the tokens
323     /// @param _amount The amount of tokens to be approved for transfer
324     /// @return True if the function call was successful
325     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
326     ) returns (bool success) {
327         require(approve(_spender, _amount));
328 
329         ApproveAndCallFallBack(_spender).receiveApproval(
330             msg.sender,
331             _amount,
332             this,
333             _extraData
334         );
335 
336         return true;
337     }
338 
339     /// @dev This function makes it easy to get the total number of tokens
340     /// @return The total number of tokens
341     function totalSupply() constant returns (uint) {
342         return totalSupplyAt(block.number);
343     }
344 
345 
346 ////////////////
347 // Query balance and totalSupply in History
348 ////////////////
349 
350     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
351     /// @param _owner The address from which the balance will be retrieved
352     /// @param _blockNumber The block number when the balance is queried
353     /// @return The balance at `_blockNumber`
354     function balanceOfAt(address _owner, uint _blockNumber) constant
355         returns (uint) {
356 
357         // These next few lines are used when the balance of the token is
358         //  requested before a check point was ever created for this token, it
359         //  requires that the `parentToken.balanceOfAt` be queried at the
360         //  genesis block for that token as this contains initial balance of
361         //  this token
362         if ((balances[_owner].length == 0)
363             || (balances[_owner][0].fromBlock > _blockNumber)) {
364             if (address(parentToken) != 0) {
365                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
366             } else {
367                 // Has no parent
368                 return 0;
369             }
370 
371         // This will return the expected balance during normal situations
372         } else {
373             return getValueAt(balances[_owner], _blockNumber);
374         }
375     }
376 
377     /// @notice Total amount of tokens at a specific `_blockNumber`.
378     /// @param _blockNumber The block number when the totalSupply is queried
379     /// @return The total amount of tokens at `_blockNumber`
380     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
381 
382         // These next few lines are used when the totalSupply of the token is
383         //  requested before a check point was ever created for this token, it
384         //  requires that the `parentToken.totalSupplyAt` be queried at the
385         //  genesis block for this token as that contains totalSupply of this
386         //  token at this block number.
387         if ((totalSupplyHistory.length == 0)
388             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
389             if (address(parentToken) != 0) {
390                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
391             } else {
392                 return 0;
393             }
394 
395         // This will return the expected totalSupply during normal situations
396         } else {
397             return getValueAt(totalSupplyHistory, _blockNumber);
398         }
399     }
400 
401 ////////////////
402 // Clone Token Method
403 ////////////////
404 
405     /// @notice Creates a new clone token with the initial distribution being
406     ///  this token at `_snapshotBlock`
407     /// @param _cloneTokenName Name of the clone token
408     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
409     /// @param _cloneTokenSymbol Symbol of the clone token
410     /// @param _snapshotBlock Block when the distribution of the parent token is
411     ///  copied to set the initial distribution of the new clone token;
412     ///  if the block is zero than the actual block, the current block is used
413     /// @param _transfersEnabled True if transfers are allowed in the clone
414     /// @return The address of the new MiniMeToken Contract
415     function createCloneToken(
416         string _cloneTokenName,
417         uint8 _cloneDecimalUnits,
418         string _cloneTokenSymbol,
419         uint _snapshotBlock,
420         bool _transfersEnabled
421         ) returns(address) {
422         if (_snapshotBlock == 0) _snapshotBlock = block.number;
423         MiniMeToken cloneToken = tokenFactory.createCloneToken(
424             this,
425             _snapshotBlock,
426             _cloneTokenName,
427             _cloneDecimalUnits,
428             _cloneTokenSymbol,
429             _transfersEnabled
430             );
431 
432         cloneToken.changeController(msg.sender);
433 
434         // An event to make the token easy to find on the blockchain
435         NewCloneToken(address(cloneToken), _snapshotBlock);
436         return address(cloneToken);
437     }
438 
439 ////////////////
440 // Generate and destroy tokens
441 ////////////////
442 
443     /// @notice Generates `_amount` tokens that are assigned to `_owner`
444     /// @param _owner The address that will be assigned the new tokens
445     /// @param _amount The quantity of tokens generated
446     /// @return True if the tokens are generated correctly
447     function generateTokens(address _owner, uint _amount
448     ) onlyController returns (bool) {
449         uint curTotalSupply = totalSupply();
450         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
451         uint previousBalanceTo = balanceOf(_owner);
452         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
453         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
454         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
455         Transfer(0, _owner, _amount);
456         return true;
457     }
458 
459 
460     /// @notice Burns `_amount` tokens from `_owner`
461     /// @param _owner The address that will lose the tokens
462     /// @param _amount The quantity of tokens to burn
463     /// @return True if the tokens are burned correctly
464     function destroyTokens(address _owner, uint _amount
465     ) onlyController returns (bool) {
466         uint curTotalSupply = totalSupply();
467         require(curTotalSupply >= _amount);
468         uint previousBalanceFrom = balanceOf(_owner);
469         require(previousBalanceFrom >= _amount);
470         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
471         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
472         Transfer(_owner, 0, _amount);
473         return true;
474     }
475 
476 ////////////////
477 // Enable tokens transfers
478 ////////////////
479 
480 
481     /// @notice Enables token holders to transfer their tokens freely if true
482     /// @param _transfersEnabled True if transfers are allowed in the clone
483     function enableTransfers(bool _transfersEnabled) onlyController {
484         transfersEnabled = _transfersEnabled;
485     }
486 
487 ////////////////
488 // Internal helper functions to query and set a value in a snapshot array
489 ////////////////
490 
491     /// @dev `getValueAt` retrieves the number of tokens at a given block number
492     /// @param checkpoints The history of values being queried
493     /// @param _block The block number to retrieve the value at
494     /// @return The number of tokens being queried
495     function getValueAt(Checkpoint[] storage checkpoints, uint _block
496     ) constant internal returns (uint) {
497         if (checkpoints.length == 0) return 0;
498 
499         // Shortcut for the actual value
500         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
501             return checkpoints[checkpoints.length-1].value;
502         if (_block < checkpoints[0].fromBlock) return 0;
503 
504         // Binary search of the value in the array
505         uint min = 0;
506         uint max = checkpoints.length-1;
507         while (max > min) {
508             uint mid = (max + min + 1)/ 2;
509             if (checkpoints[mid].fromBlock<=_block) {
510                 min = mid;
511             } else {
512                 max = mid-1;
513             }
514         }
515         return checkpoints[min].value;
516     }
517 
518     /// @dev `updateValueAtNow` used to update the `balances` map and the
519     ///  `totalSupplyHistory`
520     /// @param checkpoints The history of data being updated
521     /// @param _value The new number of tokens
522     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
523     ) internal  {
524         if ((checkpoints.length == 0)
525         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
526                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
527                newCheckPoint.fromBlock =  uint128(block.number);
528                newCheckPoint.value = uint128(_value);
529            } else {
530                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
531                oldCheckPoint.value = uint128(_value);
532            }
533     }
534 
535     /// @dev Internal function to determine if an address is a contract
536     /// @param _addr The address being queried
537     /// @return True if `_addr` is a contract
538     function isContract(address _addr) constant internal returns(bool) {
539         uint size;
540         if (_addr == 0) return false;
541         assembly {
542             size := extcodesize(_addr)
543         }
544         return size>0;
545     }
546 
547     /// @dev Helper function to return a min betwen the two uints
548     function min(uint a, uint b) internal returns (uint) {
549         return a < b ? a : b;
550     }
551 
552     /// @notice The fallback function: If the contract's controller has not been
553     ///  set to 0, then the `proxyPayment` method is called which relays the
554     ///  ether and creates tokens as described in the token controller contract
555     function ()  payable {
556         require(isContract(controller));
557         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
558     }
559 
560 //////////
561 // Safety Methods
562 //////////
563 
564     /// @notice This method can be used by the controller to extract mistakenly
565     ///  sent tokens to this contract.
566     /// @param _token The address of the token contract that you want to recover
567     ///  set to 0 in case you want to extract ether.
568     function claimTokens(address _token) onlyController {
569         if (_token == 0x0) {
570             controller.transfer(this.balance);
571             return;
572         }
573 
574         MiniMeToken token = MiniMeToken(_token);
575         uint balance = token.balanceOf(this);
576         token.transfer(controller, balance);
577         ClaimedTokens(_token, controller, balance);
578     }
579 
580 ////////////////
581 // Events
582 ////////////////
583     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
584     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
585     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
586     event Approval(
587         address indexed _owner,
588         address indexed _spender,
589         uint256 _amount
590         );
591 
592 }
593 
594 
595 ////////////////
596 // MiniMeTokenFactory
597 ////////////////
598 
599 /// @dev This contract is used to generate clone contracts from a contract.
600 ///  In solidity this is the way to create a contract from a contract of the
601 ///  same class
602 contract MiniMeTokenFactory {
603 
604     /// @notice Update the DApp by creating a new token with new functionalities
605     ///  the msg.sender becomes the controller of this clone token
606     /// @param _parentToken Address of the token being cloned
607     /// @param _snapshotBlock Block of the parent token that will
608     ///  determine the initial distribution of the clone token
609     /// @param _tokenName Name of the new token
610     /// @param _decimalUnits Number of decimals of the new token
611     /// @param _tokenSymbol Token Symbol for the new token
612     /// @param _transfersEnabled If true, tokens will be able to be transferred
613     /// @return The address of the new token contract
614     function createCloneToken(
615         address _parentToken,
616         uint _snapshotBlock,
617         string _tokenName,
618         uint8 _decimalUnits,
619         string _tokenSymbol,
620         bool _transfersEnabled
621     ) returns (MiniMeToken) {
622         MiniMeToken newToken = new MiniMeToken(
623             this,
624             _parentToken,
625             _snapshotBlock,
626             _tokenName,
627             _decimalUnits,
628             _tokenSymbol,
629             _transfersEnabled
630             );
631 
632         newToken.changeController(msg.sender);
633         return newToken;
634     }
635 }
636 
637 
638 contract ERC20 {
639   /// @notice Send `_amount` tokens to `_to` from `msg.sender`
640   /// @param _to The address of the recipient
641   /// @param _amount The amount of tokens to be transferred
642   /// @return Whether the transfer was successful or not
643   function transfer(address _to, uint256 _amount) returns (bool success);
644 
645   /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
646   ///  is approved by `_from`
647   /// @param _from The address holding the tokens being transferred
648   /// @param _to The address of the recipient
649   /// @param _amount The amount of tokens to be transferred
650   /// @return True if the transfer was successful
651   function transferFrom(address _from, address _to, uint256 _amount
652   ) returns (bool success);
653 
654   /// @param _owner The address that's balance is being requested
655   /// @return The balance of `_owner` at the current block
656   function balanceOf(address _owner) constant returns (uint256 balance);
657 
658   /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
659   ///  its behalf. This is a modified version of the ERC20 approve function
660   ///  to be a little bit safer
661   /// @param _spender The address of the account able to transfer the tokens
662   /// @param _amount The amount of tokens to be approved for transfer
663   /// @return True if the approval was successful
664   function approve(address _spender, uint256 _amount) returns (bool success);
665 
666   /// @dev This function makes it easy to read the `allowed[]` map
667   /// @param _owner The address of the account that owns the token
668   /// @param _spender The address of the account able to transfer the tokens
669   /// @return Amount of remaining tokens of _owner that _spender is allowed
670   ///  to spend
671   function allowance(address _owner, address _spender
672   ) constant returns (uint256 remaining);
673 
674   /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
675   ///  its behalf, and then a function is triggered in the contract that is
676   ///  being approved, `_spender`. This allows users to use their tokens to
677   ///  interact with contracts in one function call instead of two
678   /// @param _spender The address of the contract able to transfer the tokens
679   /// @param _amount The amount of tokens to be approved for transfer
680   /// @return True if the function call was successful
681   function approveAndCall(address _spender, uint256 _amount, bytes _extraData
682   ) returns (bool success);
683 
684   /// @dev This function makes it easy to get the total number of tokens
685   /// @return The total number of tokens
686   function totalSupply() constant returns (uint);
687 }
688 
689 
690 contract PreSale is Controlled, TokenController {
691   using SafeMath for uint256;
692 
693   uint256 constant public exchangeRate = 1; // ETH-WCT exchange rate
694   uint256 constant public investor_bonus = 25;
695 
696   MiniMeToken public wct;
697   address public preSaleWallet;
698 
699   uint256 public totalSupplyCap;            // Total WCT supply to be generated
700   uint256 public totalSold;                 // How much tokens have been sold
701 
702   uint256 public minimum_investment;
703 
704   uint256 public startBlock;
705   uint256 public endBlock;
706 
707   uint256 public initializedBlock;
708   uint256 public finalizedBlock;
709 
710   bool public paused;
711   bool public transferable;
712 
713   modifier initialized() {
714     assert(initializedBlock != 0);
715     _;
716   }
717 
718   modifier contributionOpen() {
719     assert(getBlockNumber() >= startBlock &&
720            getBlockNumber() <= endBlock &&
721            finalizedBlock == 0);
722     _;
723   }
724 
725   modifier notPaused() {
726     require(!paused);
727     _;
728   }
729 
730   function PreSale(address _wct) {
731     require(_wct != 0x0);
732     wct = MiniMeToken(_wct);
733   }
734 
735   function initialize(
736       address _preSaleWallet,
737       uint256 _totalSupplyCap,
738       uint256 _minimum_investment,
739       uint256 _startBlock,
740       uint256 _endBlock
741   ) public onlyController {
742     // Initialize only once
743     require(initializedBlock == 0);
744 
745     assert(wct.totalSupply() == 0);
746     assert(wct.controller() == address(this));
747     assert(wct.decimals() == 18);  // Same amount of decimals as ETH
748 
749     require(_preSaleWallet != 0x0);
750     preSaleWallet = _preSaleWallet;
751 
752     assert(_startBlock >= getBlockNumber());
753     require(_startBlock < _endBlock);
754     startBlock = _startBlock;
755     endBlock = _endBlock;
756 
757     require(_totalSupplyCap > 0);
758     totalSupplyCap = _totalSupplyCap;
759 
760     minimum_investment = _minimum_investment;
761 
762     initializedBlock = getBlockNumber();
763     Initialized(initializedBlock);
764   }
765 
766   /// @notice If anybody sends Ether directly to this contract, consider he is
767   /// getting WCTs.
768   function () public payable notPaused {
769     proxyPayment(msg.sender);
770   }
771 
772   //////////
773   // TokenController functions
774   //////////
775 
776   /// @notice This method will generally be called by the WCT token contract to
777   ///  acquire WCTs. Or directly from third parties that want to acquire WCTs in
778   ///  behalf of a token holder.
779   /// @param _th WCT holder where the WCTs will be minted.
780   function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
781     require(_th != 0x0);
782     doBuy(_th);
783     return true;
784   }
785 
786   function onTransfer(address, address, uint256) public returns (bool) {
787     return transferable;
788   }
789 
790   function onApprove(address, address, uint256) public returns (bool) {
791     return transferable;
792   }
793 
794   function doBuy(address _th) internal {
795     require(msg.value >= minimum_investment);
796 
797     // Antispam mechanism
798     address caller;
799     if (msg.sender == address(wct)) {
800       caller = _th;
801     } else {
802       caller = msg.sender;
803     }
804     assert(!isContract(caller));
805 
806     uint256 toFund = msg.value;
807     uint256 leftForSale = tokensForSale();
808     if (toFund > 0) {
809       if (leftForSale > 0) {
810         uint256 tokensGenerated = toFund.mul(exchangeRate);
811 
812         // Check total supply cap reached, sell the all remaining tokens
813         if (tokensGenerated > leftForSale) {
814           tokensGenerated = leftForSale;
815           toFund = leftForSale.div(exchangeRate);
816         }
817 
818         assert(wct.generateTokens(_th, tokensGenerated));
819         totalSold = totalSold.add(tokensGenerated);
820 
821         preSaleWallet.transfer(toFund);
822         NewSale(_th, toFund, tokensGenerated);
823       } else {
824         toFund = 0;
825       }
826     }
827 
828     uint256 toReturn = msg.value.sub(toFund);
829     if (toReturn > 0) {
830       caller.transfer(toReturn);
831     }
832   }
833 
834   /// @dev Internal function to determine if an address is a contract
835   /// @param _addr The address being queried
836   /// @return True if `_addr` is a contract
837   function isContract(address _addr) constant internal returns (bool) {
838     if (_addr == 0) return false;
839     uint256 size;
840     assembly {
841       size := extcodesize(_addr)
842     }
843     return (size > 0);
844   }
845 
846   /// @notice This method will can be called by the controller before the contribution period
847   ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
848   ///  by creating the remaining tokens and transferring the controller to the configured
849   ///  controller.
850   function finalize() public initialized {
851     require(finalizedBlock == 0);
852     assert(getBlockNumber() >= startBlock);
853     assert(msg.sender == controller || getBlockNumber() > endBlock || tokensForSale() == 0);
854 
855     wct.changeController(0x0);
856     finalizedBlock = getBlockNumber();
857 
858     Finalized(finalizedBlock);
859   }
860 
861   //////////
862   // Constant functions
863   //////////
864 
865   /// @return Total tokens availale for the sale in weis.
866   function tokensForSale() public constant returns(uint256) {
867     return totalSupplyCap > totalSold ? totalSupplyCap - totalSold : 0;
868   }
869 
870   //////////
871   // Testing specific methods
872   //////////
873 
874   /// @notice This function is overridden by the test Mocks.
875   function getBlockNumber() internal constant returns (uint256) {
876     return block.number;
877   }
878 
879 
880   //////////
881   // Safety Methods
882   //////////
883 
884   /// @notice This method can be used by the controller to extract mistakenly
885   ///  sent tokens to this contract.
886   /// @param _token The address of the token contract that you want to recover
887   ///  set to 0 in case you want to extract ether.
888   function claimTokens(address _token) public onlyController {
889     if (wct.controller() == address(this)) {
890       wct.claimTokens(_token);
891     }
892 
893     if (_token == 0x0) {
894       controller.transfer(this.balance);
895       return;
896     }
897 
898     ERC20 token = ERC20(_token);
899     uint256 balance = token.balanceOf(this);
900     token.transfer(controller, balance);
901     ClaimedTokens(_token, controller, balance);
902   }
903 
904   /// @notice Pauses the contribution if there is any issue
905   function pauseContribution(bool _paused) onlyController {
906     paused = _paused;
907   }
908 
909   function allowTransfers(bool _transferable) onlyController {
910     transferable = _transferable;
911   }
912 
913   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
914   event NewSale(address indexed _th, uint256 _amount, uint256 _tokens);
915   event Initialized(uint _now);
916   event Finalized(uint _now);
917 }