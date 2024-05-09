1 pragma solidity ^0.4.13;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 // Abstract contract for the full ERC 20 Token standard
21 // https://github.com/ethereum/EIPs/issues/20
22 
23 contract ERC20Token {
24     /* This is a slight change to the ERC20 base standard.
25     function totalSupply() constant returns (uint256 supply);
26     is replaced with:
27     uint256 public totalSupply;
28     This automatically creates a getter function for the totalSupply.
29     This is moved to the base contract since public getter functions are not
30     currently recognised as an implementation of the matching abstract
31     function by the compiler.
32     */
33     /// total amount of tokens
34     uint256 public totalSupply;
35 
36     /// @param _owner The address from which the balance will be retrieved
37     /// @return The balance
38     function balanceOf(address _owner) constant returns (uint256 balance);
39 
40     /// @notice send `_value` token to `_to` from `msg.sender`
41     /// @param _to The address of the recipient
42     /// @param _value The amount of token to be transferred
43     /// @return Whether the transfer was successful or not
44     function transfer(address _to, uint256 _value) returns (bool success);
45 
46     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
47     /// @param _from The address of the sender
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
52 
53     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @param _value The amount of tokens to be approved for transfer
56     /// @return Whether the approval was successful or not
57     function approve(address _spender, uint256 _value) returns (bool success);
58 
59     /// @param _owner The address of the account owning tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @return Amount of remaining tokens allowed to spent
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 
69 
70 /// @title MiniMeToken Contract
71 /// @author Jordi Baylina
72 /// @dev This token contract's goal is to make it easy for anyone to clone this
73 ///  token using the token distribution at a given block, this will allow DAO's
74 ///  and DApps to upgrade their features in a decentralized manner without
75 ///  affecting the original token
76 /// @dev It is ERC20 compliant, but still needs to under go further testing.
77 
78 
79 /// @dev The token controller contract must implement these functions
80 contract TokenController {
81     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
82     /// @param _owner The address that sent the ether to create tokens
83     /// @return True if the ether is accepted, false if it throws
84     function proxyPayment(address _owner) payable returns(bool);
85 
86     /// @notice Notifies the controller about a token transfer allowing the
87     ///  controller to react if desired
88     /// @param _from The origin of the transfer
89     /// @param _to The destination of the transfer
90     /// @param _amount The amount of the transfer
91     /// @return False if the controller does not authorize the transfer
92     function onTransfer(address _from, address _to, uint _amount) returns(bool);
93 
94     /// @notice Notifies the controller about an approval allowing the
95     ///  controller to react if desired
96     /// @param _owner The address that calls `approve()`
97     /// @param _spender The spender in the `approve()` call
98     /// @param _amount The amount in the `approve()` call
99     /// @return False if the controller does not authorize the approval
100     function onApprove(address _owner, address _spender, uint _amount)
101         returns(bool);
102 }
103 
104 contract Controlled {
105     /// @notice The address of the controller is the only address that can call
106     ///  a function with this modifier
107     modifier onlyController { if (msg.sender != controller) throw; _; }
108 
109     address public controller;
110 
111     function Controlled() { controller = msg.sender;}
112 
113     /// @notice Changes the controller of the contract
114     /// @param _newController The new controller of the contract
115     function changeController(address _newController) onlyController {
116         controller = _newController;
117     }
118 }
119 
120 contract ApproveAndCallFallBack {
121     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
122 }
123 
124 /// @dev The actual token contract, the default controller is the msg.sender
125 ///  that deploys the contract, so usually this token will be deployed by a
126 ///  token controller contract, which Giveth will call a "Campaign"
127 contract MiniMeToken is Controlled {
128 
129     string public name;                //The Token's name: e.g. DigixDAO Tokens
130     uint8 public decimals;             //Number of decimals of the smallest unit
131     string public symbol;              //An identifier: e.g. REP
132     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
133 
134 
135     /// @dev `Checkpoint` is the structure that attaches a block number to a
136     ///  given value, the block number attached is the one that last changed the
137     ///  value
138     struct  Checkpoint {
139 
140         // `fromBlock` is the block number that the value was generated from
141         uint128 fromBlock;
142 
143         // `value` is the amount of tokens at a specific block number
144         uint128 value;
145     }
146 
147     // `parentToken` is the Token address that was cloned to produce this token;
148     //  it will be 0x0 for a token that was not cloned
149     MiniMeToken public parentToken;
150 
151     // `parentSnapShotBlock` is the block number from the Parent Token that was
152     //  used to determine the initial distribution of the Clone Token
153     uint public parentSnapShotBlock;
154 
155     // `creationBlock` is the block number that the Clone Token was created
156     uint public creationBlock;
157 
158     // `balances` is the map that tracks the balance of each address, in this
159     //  contract when the balance changes the block number that the change
160     //  occurred is also included in the map
161     mapping (address => Checkpoint[]) balances;
162 
163     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
164     mapping (address => mapping (address => uint256)) allowed;
165 
166     // Tracks the history of the `totalSupply` of the token
167     Checkpoint[] totalSupplyHistory;
168 
169     // Flag that determines if the token is transferable or not.
170     bool public transfersEnabled;
171 
172     // The factory used to create new clone tokens
173     MiniMeTokenFactory public tokenFactory;
174 
175 ////////////////
176 // Constructor
177 ////////////////
178 
179     /// @notice Constructor to create a MiniMeToken
180     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
181     ///  will create the Clone token contracts, the token factory needs to be
182     ///  deployed first
183     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
184     ///  new token
185     /// @param _parentSnapShotBlock Block of the parent token that will
186     ///  determine the initial distribution of the clone token, set to 0 if it
187     ///  is a new token
188     /// @param _tokenName Name of the new token
189     /// @param _decimalUnits Number of decimals of the new token
190     /// @param _tokenSymbol Token Symbol for the new token
191     /// @param _transfersEnabled If true, tokens will be able to be transferred
192     function MiniMeToken(
193         address _tokenFactory,
194         address _parentToken,
195         uint _parentSnapShotBlock,
196         string _tokenName,
197         uint8 _decimalUnits,
198         string _tokenSymbol,
199         bool _transfersEnabled
200     ) {
201         tokenFactory = MiniMeTokenFactory(_tokenFactory);
202         name = _tokenName;                                 // Set the name
203         decimals = _decimalUnits;                          // Set the decimals
204         symbol = _tokenSymbol;                             // Set the symbol
205         parentToken = MiniMeToken(_parentToken);
206         parentSnapShotBlock = _parentSnapShotBlock;
207         transfersEnabled = _transfersEnabled;
208         creationBlock = block.number;
209     }
210 
211 
212 ///////////////////
213 // ERC20 Methods
214 ///////////////////
215 
216     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
217     /// @param _to The address of the recipient
218     /// @param _amount The amount of tokens to be transferred
219     /// @return Whether the transfer was successful or not
220     function transfer(address _to, uint256 _amount) returns (bool success) {
221         if (!transfersEnabled) throw;
222         return doTransfer(msg.sender, _to, _amount);
223     }
224 
225     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
226     ///  is approved by `_from`
227     /// @param _from The address holding the tokens being transferred
228     /// @param _to The address of the recipient
229     /// @param _amount The amount of tokens to be transferred
230     /// @return True if the transfer was successful
231     function transferFrom(address _from, address _to, uint256 _amount
232     ) returns (bool success) {
233 
234         // The controller of this contract can move tokens around at will,
235         //  this is important to recognize! Confirm that you trust the
236         //  controller of this contract, which in most situations should be
237         //  another open source smart contract or 0x0
238         if (msg.sender != controller) {
239             if (!transfersEnabled) throw;
240 
241             // The standard ERC 20 transferFrom functionality
242             if (allowed[_from][msg.sender] < _amount) return false;
243             allowed[_from][msg.sender] -= _amount;
244         }
245         return doTransfer(_from, _to, _amount);
246     }
247 
248     /// @dev This is the actual transfer function in the token contract, it can
249     ///  only be called by other functions in this contract.
250     /// @param _from The address holding the tokens being transferred
251     /// @param _to The address of the recipient
252     /// @param _amount The amount of tokens to be transferred
253     /// @return True if the transfer was successful
254     function doTransfer(address _from, address _to, uint _amount
255     ) internal returns(bool) {
256 
257            if (_amount == 0) {
258                return true;
259            }
260 
261            if (parentSnapShotBlock >= block.number) throw;
262 
263            // Do not allow transfer to 0x0 or the token contract itself
264            if ((_to == 0) || (_to == address(this))) throw;
265 
266            // If the amount being transfered is more than the balance of the
267            //  account the transfer returns false
268            var previousBalanceFrom = balanceOfAt(_from, block.number);
269            if (previousBalanceFrom < _amount) {
270                return false;
271            }
272 
273            // Alerts the token controller of the transfer
274            if (isContract(controller)) {
275                if (!TokenController(controller).onTransfer(_from, _to, _amount))
276                throw;
277            }
278 
279            // First update the balance array with the new value for the address
280            //  sending the tokens
281            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
282 
283            // Then update the balance array with the new value for the address
284            //  receiving the tokens
285            var previousBalanceTo = balanceOfAt(_to, block.number);
286            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
287            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
288 
289            // An event to make the transfer easy to find on the blockchain
290            Transfer(_from, _to, _amount);
291 
292            return true;
293     }
294 
295     /// @param _owner The address that's balance is being requested
296     /// @return The balance of `_owner` at the current block
297     function balanceOf(address _owner) constant returns (uint256 balance) {
298         return balanceOfAt(_owner, block.number);
299     }
300 
301     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
302     ///  its behalf. This is a modified version of the ERC20 approve function
303     ///  to be a little bit safer
304     /// @param _spender The address of the account able to transfer the tokens
305     /// @param _amount The amount of tokens to be approved for transfer
306     /// @return True if the approval was successful
307     function approve(address _spender, uint256 _amount) returns (bool success) {
308         if (!transfersEnabled) throw;
309 
310         // To change the approve amount you first have to reduce the addresses`
311         //  allowance to zero by calling `approve(_spender,0)` if it is not
312         //  already 0 to mitigate the race condition described here:
313         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
315 
316         // Alerts the token controller of the approve function call
317         if (isContract(controller)) {
318             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
319                 throw;
320         }
321 
322         allowed[msg.sender][_spender] = _amount;
323         Approval(msg.sender, _spender, _amount);
324         return true;
325     }
326 
327     /// @dev This function makes it easy to read the `allowed[]` map
328     /// @param _owner The address of the account that owns the token
329     /// @param _spender The address of the account able to transfer the tokens
330     /// @return Amount of remaining tokens of _owner that _spender is allowed
331     ///  to spend
332     function allowance(address _owner, address _spender
333     ) constant returns (uint256 remaining) {
334         return allowed[_owner][_spender];
335     }
336 
337     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
338     ///  its behalf, and then a function is triggered in the contract that is
339     ///  being approved, `_spender`. This allows users to use their tokens to
340     ///  interact with contracts in one function call instead of two
341     /// @param _spender The address of the contract able to transfer the tokens
342     /// @param _amount The amount of tokens to be approved for transfer
343     /// @return True if the function call was successful
344     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
345     ) returns (bool success) {
346         if (!approve(_spender, _amount)) throw;
347 
348         ApproveAndCallFallBack(_spender).receiveApproval(
349             msg.sender,
350             _amount,
351             this,
352             _extraData
353         );
354 
355         return true;
356     }
357 
358     /// @dev This function makes it easy to get the total number of tokens
359     /// @return The total number of tokens
360     function totalSupply() constant returns (uint) {
361         return totalSupplyAt(block.number);
362     }
363 
364 
365 ////////////////
366 // Query balance and totalSupply in History
367 ////////////////
368 
369     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
370     /// @param _owner The address from which the balance will be retrieved
371     /// @param _blockNumber The block number when the balance is queried
372     /// @return The balance at `_blockNumber`
373     function balanceOfAt(address _owner, uint _blockNumber) constant
374         returns (uint) {
375 
376         // These next few lines are used when the balance of the token is
377         //  requested before a check point was ever created for this token, it
378         //  requires that the `parentToken.balanceOfAt` be queried at the
379         //  genesis block for that token as this contains initial balance of
380         //  this token
381         if ((balances[_owner].length == 0)
382             || (balances[_owner][0].fromBlock > _blockNumber)) {
383             if (address(parentToken) != 0) {
384                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
385             } else {
386                 // Has no parent
387                 return 0;
388             }
389 
390         // This will return the expected balance during normal situations
391         } else {
392             return getValueAt(balances[_owner], _blockNumber);
393         }
394     }
395 
396     /// @notice Total amount of tokens at a specific `_blockNumber`.
397     /// @param _blockNumber The block number when the totalSupply is queried
398     /// @return The total amount of tokens at `_blockNumber`
399     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
400 
401         // These next few lines are used when the totalSupply of the token is
402         //  requested before a check point was ever created for this token, it
403         //  requires that the `parentToken.totalSupplyAt` be queried at the
404         //  genesis block for this token as that contains totalSupply of this
405         //  token at this block number.
406         if ((totalSupplyHistory.length == 0)
407             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
408             if (address(parentToken) != 0) {
409                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
410             } else {
411                 return 0;
412             }
413 
414         // This will return the expected totalSupply during normal situations
415         } else {
416             return getValueAt(totalSupplyHistory, _blockNumber);
417         }
418     }
419 
420 ////////////////
421 // Clone Token Method
422 ////////////////
423 
424     /// @notice Creates a new clone token with the initial distribution being
425     ///  this token at `_snapshotBlock`
426     /// @param _cloneTokenName Name of the clone token
427     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
428     /// @param _cloneTokenSymbol Symbol of the clone token
429     /// @param _snapshotBlock Block when the distribution of the parent token is
430     ///  copied to set the initial distribution of the new clone token;
431     ///  if the block is zero than the actual block, the current block is used
432     /// @param _transfersEnabled True if transfers are allowed in the clone
433     /// @return The address of the new MiniMeToken Contract
434     function createCloneToken(
435         string _cloneTokenName,
436         uint8 _cloneDecimalUnits,
437         string _cloneTokenSymbol,
438         uint _snapshotBlock,
439         bool _transfersEnabled
440         ) returns(address) {
441         if (_snapshotBlock == 0) _snapshotBlock = block.number;
442         MiniMeToken cloneToken = tokenFactory.createCloneToken(
443             this,
444             _snapshotBlock,
445             _cloneTokenName,
446             _cloneDecimalUnits,
447             _cloneTokenSymbol,
448             _transfersEnabled
449             );
450 
451         cloneToken.changeController(msg.sender);
452 
453         // An event to make the token easy to find on the blockchain
454         NewCloneToken(address(cloneToken), _snapshotBlock);
455         return address(cloneToken);
456     }
457 
458 ////////////////
459 // Generate and destroy tokens
460 ////////////////
461 
462     /// @notice Generates `_amount` tokens that are assigned to `_owner`
463     /// @param _owner The address that will be assigned the new tokens
464     /// @param _amount The quantity of tokens generated
465     /// @return True if the tokens are generated correctly
466     function generateTokens(address _owner, uint _amount
467     ) onlyController returns (bool) {
468         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
469         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
470         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
471         var previousBalanceTo = balanceOf(_owner);
472         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
473         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
474         Transfer(0, _owner, _amount);
475         return true;
476     }
477 
478 
479     /// @notice Burns `_amount` tokens from `_owner`
480     /// @param _owner The address that will lose the tokens
481     /// @param _amount The quantity of tokens to burn
482     /// @return True if the tokens are burned correctly
483     function destroyTokens(address _owner, uint _amount
484     ) onlyController returns (bool) {
485         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
486         if (curTotalSupply < _amount) throw;
487         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
488         var previousBalanceFrom = balanceOf(_owner);
489         if (previousBalanceFrom < _amount) throw;
490         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
491         Transfer(_owner, 0, _amount);
492         return true;
493     }
494 
495 ////////////////
496 // Enable tokens transfers
497 ////////////////
498 
499 
500     /// @notice Enables token holders to transfer their tokens freely if true
501     /// @param _transfersEnabled True if transfers are allowed in the clone
502     function enableTransfers(bool _transfersEnabled) onlyController {
503         transfersEnabled = _transfersEnabled;
504     }
505 
506 ////////////////
507 // Internal helper functions to query and set a value in a snapshot array
508 ////////////////
509 
510     /// @dev `getValueAt` retrieves the number of tokens at a given block number
511     /// @param checkpoints The history of values being queried
512     /// @param _block The block number to retrieve the value at
513     /// @return The number of tokens being queried
514     function getValueAt(Checkpoint[] storage checkpoints, uint _block
515     ) constant internal returns (uint) {
516         if (checkpoints.length == 0) return 0;
517 
518         // Shortcut for the actual value
519         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
520             return checkpoints[checkpoints.length-1].value;
521         if (_block < checkpoints[0].fromBlock) return 0;
522 
523         // Binary search of the value in the array
524         uint min = 0;
525         uint max = checkpoints.length-1;
526         while (max > min) {
527             uint mid = (max + min + 1)/ 2;
528             if (checkpoints[mid].fromBlock<=_block) {
529                 min = mid;
530             } else {
531                 max = mid-1;
532             }
533         }
534         return checkpoints[min].value;
535     }
536 
537     /// @dev `updateValueAtNow` used to update the `balances` map and the
538     ///  `totalSupplyHistory`
539     /// @param checkpoints The history of data being updated
540     /// @param _value The new number of tokens
541     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
542     ) internal  {
543         if ((checkpoints.length == 0)
544         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
545                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
546                newCheckPoint.fromBlock =  uint128(block.number);
547                newCheckPoint.value = uint128(_value);
548            } else {
549                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
550                oldCheckPoint.value = uint128(_value);
551            }
552     }
553 
554     /// @dev Internal function to determine if an address is a contract
555     /// @param _addr The address being queried
556     /// @return True if `_addr` is a contract
557     function isContract(address _addr) constant internal returns(bool) {
558         uint size;
559         if (_addr == 0) return false;
560         assembly {
561             size := extcodesize(_addr)
562         }
563         return size>0;
564     }
565 
566     /// @dev Helper function to return a min betwen the two uints
567     function min(uint a, uint b) internal returns (uint) {
568         return a < b ? a : b;
569     }
570 
571     /// @notice The fallback function: If the contract's controller has not been
572     ///  set to 0, then the `proxyPayment` method is called which relays the
573     ///  ether and creates tokens as described in the token controller contract
574     function ()  payable {
575         if (isContract(controller)) {
576             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
577                 throw;
578         } else {
579             throw;
580         }
581     }
582 
583     /// @notice This method can be used by the controller to extract mistakenly
584     ///  sent tokens to this contract.
585     /// @param _token The address of the token contract that you want to recover
586     ///  set to 0 in case you want to extract ether.
587     function claimTokens(address _token) onlyController {
588         if (_token == 0x0) {
589             controller.transfer(this.balance);
590             return;
591         }
592 
593         ERC20Token token = ERC20Token(_token);
594         uint balance = token.balanceOf(this);
595         token.transfer(controller, balance);
596         ClaimedTokens(_token, controller, balance);
597     }
598 
599 
600 ////////////////
601 // Events
602 ////////////////
603     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
604     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
605     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
606     event Approval(
607         address indexed _owner,
608         address indexed _spender,
609         uint256 _amount
610         );
611 
612 }
613 
614 
615 ////////////////
616 // MiniMeTokenFactory
617 ////////////////
618 
619 /// @dev This contract is used to generate clone contracts from a contract.
620 ///  In solidity this is the way to create a contract from a contract of the
621 ///  same class
622 contract MiniMeTokenFactory {
623 
624     /// @notice Update the DApp by creating a new token with new functionalities
625     ///  the msg.sender becomes the controller of this clone token
626     /// @param _parentToken Address of the token being cloned
627     /// @param _snapshotBlock Block of the parent token that will
628     ///  determine the initial distribution of the clone token
629     /// @param _tokenName Name of the new token
630     /// @param _decimalUnits Number of decimals of the new token
631     /// @param _tokenSymbol Token Symbol for the new token
632     /// @param _transfersEnabled If true, tokens will be able to be transferred
633     /// @return The address of the new token contract
634     function createCloneToken(
635         address _parentToken,
636         uint _snapshotBlock,
637         string _tokenName,
638         uint8 _decimalUnits,
639         string _tokenSymbol,
640         bool _transfersEnabled
641     ) returns (MiniMeToken) {
642         MiniMeToken newToken = new MiniMeToken(
643             this,
644             _parentToken,
645             _snapshotBlock,
646             _tokenName,
647             _decimalUnits,
648             _tokenSymbol,
649             _transfersEnabled
650             );
651 
652         newToken.changeController(msg.sender);
653         return newToken;
654     }
655 }
656 
657 
658 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
659 ///  later changed
660 contract Owned {
661     /// @dev `owner` is the only address that can call a function with this
662     /// modifier
663     modifier onlyOwner { if (msg.sender != owner) throw; _; }
664 
665     address public owner;
666 
667     /// @notice The Constructor assigns the message sender to be `owner`
668     function Owned() { owner = msg.sender;}
669 
670     /// @notice `owner` can step down and assign some other address to this role
671     /// @param _newOwner The address of the new owner. 0x0 can be used to create
672     ///  an unowned neutral vault, however that cannot be undone
673     function changeOwner(address _newOwner) onlyOwner {
674         owner = _newOwner;
675     }
676 }
677 
678 
679 /// @dev This is designed to control the issuance of a MiniMe Token for a
680 ///  non-profit Campaign. This contract effectively dictates the terms of the
681 ///  funding round.
682 
683 contract GivethCampaign is TokenController, Owned {
684 
685     uint public startFundingTime;       // In UNIX Time Format
686     uint public endFundingTime;         // In UNIX Time Format
687     uint public maximumFunding;         // In wei
688     uint public totalCollected;         // In wei
689     MiniMeToken public tokenContract;   // The new token for this Campaign
690     address public vaultAddress;        // The address to hold the funds donated
691 
692 /// @notice 'GivethCampaign()' initiates the Campaign by setting its funding
693 /// parameters
694 /// @dev There are several checks to make sure the parameters are acceptable
695 /// @param _startFundingTime The UNIX time that the Campaign will be able to
696 /// start receiving funds
697 /// @param _endFundingTime The UNIX time that the Campaign will stop being able
698 /// to receive funds
699 /// @param _maximumFunding In wei, the Maximum amount that the Campaign can
700 /// receive (currently the max is set at 10,000 ETH for the beta)
701 /// @param _vaultAddress The address that will store the donated funds
702 /// @param _tokenAddress Address of the token contract this contract controls
703 
704     function GivethCampaign(
705         uint _startFundingTime,
706         uint _endFundingTime,
707         uint _maximumFunding,
708         address _vaultAddress,
709         address _tokenAddress
710 
711     ) {
712         if ((_endFundingTime < now) ||                // Cannot end in the past
713             (_endFundingTime <= _startFundingTime) ||
714             (_maximumFunding > 10000000 ether) ||        // The Beta is limited
715             (_vaultAddress == 0))                     // To prevent burning ETH
716             {
717             throw;
718             }
719         startFundingTime = _startFundingTime;
720         endFundingTime = _endFundingTime;
721         maximumFunding = _maximumFunding;
722         tokenContract = MiniMeToken(_tokenAddress);// The Deployed Token Contract
723         vaultAddress = _vaultAddress;
724     }
725 
726 /// @dev The fallback function is called when ether is sent to the contract, it
727 /// simply calls `doPayment()` with the address that sent the ether as the
728 /// `_owner`. Payable is a required solidity modifier for functions to receive
729 /// ether, without this modifier functions will throw if ether is sent to them
730 
731     function ()  payable {
732         doPayment(msg.sender);
733     }
734 
735 /////////////////
736 // TokenController interface
737 /////////////////
738 
739 /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
740 /// have the tokens created in an address of their choosing
741 /// @param _owner The address that will hold the newly created tokens
742 
743     function proxyPayment(address _owner) payable returns(bool) {
744         doPayment(_owner);
745         return true;
746     }
747 
748 /// @notice Notifies the controller about a transfer, for this Campaign all
749 ///  transfers are allowed by default and no extra notifications are needed
750 /// @param _from The origin of the transfer
751 /// @param _to The destination of the transfer
752 /// @param _amount The amount of the transfer
753 /// @return False if the controller does not authorize the transfer
754     function onTransfer(address _from, address _to, uint _amount) returns(bool) {
755         return true;
756     }
757 
758 /// @notice Notifies the controller about an approval, for this Campaign all
759 ///  approvals are allowed by default and no extra notifications are needed
760 /// @param _owner The address that calls `approve()`
761 /// @param _spender The spender in the `approve()` call
762 /// @param _amount The amount in the `approve()` call
763 /// @return False if the controller does not authorize the approval
764     function onApprove(address _owner, address _spender, uint _amount)
765         returns(bool)
766     {
767         return true;
768     }
769 
770 
771 /// @dev `doPayment()` is an internal function that sends the ether that this
772 ///  contract receives to the `vault` and creates tokens in the address of the
773 ///  `_owner` assuming the Campaign is still accepting funds
774 /// @param _owner The address that will hold the newly created tokens
775 
776     function doPayment(address _owner) internal {
777 
778 // First check that the Campaign is allowed to receive this donation
779         if ((now<startFundingTime) ||
780             (now>endFundingTime) ||
781             (tokenContract.controller() == 0) ||           // Extra check
782             (msg.value == 0) ||
783             (totalCollected + msg.value > maximumFunding))
784         {
785             throw;
786         }
787 
788 //Track how much the Campaign has collected
789         totalCollected += msg.value;
790 
791 //Send the ether to the vault
792         if (!vaultAddress.send(msg.value)) {
793             throw;
794         }
795 
796 // Creates an equal amount of tokens as ether sent. The new tokens are created
797 //  in the `_owner` address
798         if (!tokenContract.generateTokens(_owner, msg.value)) {
799             throw;
800         }
801 
802         return;
803     }
804 
805 /// @notice `finalizeFunding()` ends the Campaign by calling setting the
806 ///  controller to 0, thereby ending the issuance of new tokens and stopping the
807 ///  Campaign from receiving more ether
808 /// @dev `finalizeFunding()` can only be called after the end of the funding period.
809 
810     function finalizeFunding() {
811         if (now < endFundingTime) throw;
812         tokenContract.changeController(0);
813     }
814 
815 
816 /// @notice `onlyOwner` changes the location that ether is sent
817 /// @param _newVaultAddress The address that will receive the ether sent to this
818 ///  Campaign
819     function setVault(address _newVaultAddress) onlyOwner {
820         vaultAddress = _newVaultAddress;
821     }
822 
823     //////////
824     // Safety Methods
825     //////////
826 
827     /// @notice This method can be used by the controller to extract mistakenly
828     ///  sent tokens to this contract.
829     /// @param _token The address of the token contract that you want to recover
830     ///  set to 0 in case you want to extract ether.
831     function claimTokens(address _token) public onlyOwner {
832         if (tokenContract.controller() == address(this)) {
833             tokenContract.claimTokens(_token);
834         }
835         if (_token == 0x0) {
836             owner.transfer(this.balance);
837             return;
838         }
839 
840         ERC20Token token = ERC20Token(_token);
841         uint256 balance = token.balanceOf(this);
842         token.transfer(owner, balance);
843         ClaimedTokens(_token, owner, balance);
844     }
845 
846     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
847 
848 }