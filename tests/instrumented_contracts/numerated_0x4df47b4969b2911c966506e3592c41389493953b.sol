1 pragma solidity ^0.4.18;
2 
3 // FundRequest Token
4 //
5 // @authors:
6 // Davy Van Roy <davy.van.roy@gmail.com>
7 // Quinten De Swaef <quintendeswaef@gmail.com>
8 //
9 // Security audit performed by LeastAuthority:
10 // https://github.com/FundRequest/audit-reports/raw/master/2018-02-06 - Least Authority - ICO Contracts Audit Report.pdf
11 
12 contract ApproveAndCallFallBack {
13     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
14 }
15 
16 contract Controlled {
17     /// @notice The address of the controller is the only address that can call
18     ///  a function with this modifier
19     modifier onlyController { require(msg.sender == controller); _; }
20 
21     address public controller;
22 
23     function Controlled() public { controller = msg.sender;}
24 
25     /// @notice Changes the controller of the contract
26     /// @param _newController The new controller of the contract
27     function changeController(address _newController) public onlyController {
28         controller = _newController;
29     }
30 }
31 
32 
33 /// @dev This contract is used to generate clone contracts from a contract.
34 ///  In solidity this is the way to create a contract from a contract of the
35 ///  same class
36 contract MiniMeTokenFactory {
37 
38     /// @notice Update the DApp by creating a new token with new functionalities
39     ///  the msg.sender becomes the controller of this clone token
40     /// @param _parentToken Address of the token being cloned
41     /// @param _snapshotBlock Block of the parent token that will
42     ///  determine the initial distribution of the clone token
43     /// @param _tokenName Name of the new token
44     /// @param _decimalUnits Number of decimals of the new token
45     /// @param _tokenSymbol Token Symbol for the new token
46     /// @param _transfersEnabled If true, tokens will be able to be transferred
47     /// @return The address of the new token contract
48     function createCloneToken(
49     address _parentToken,
50     uint _snapshotBlock,
51     string _tokenName,
52     uint8 _decimalUnits,
53     string _tokenSymbol,
54     bool _transfersEnabled
55     ) public returns (MiniMeToken)
56     {
57         MiniMeToken newToken = new MiniMeToken(
58         this,
59         _parentToken,
60         _snapshotBlock,
61         _tokenName,
62         _decimalUnits,
63         _tokenSymbol,
64         _transfersEnabled
65         );
66 
67         newToken.changeController(msg.sender);
68         return newToken;
69     }
70 }
71 
72 /*
73     Copyright 2016, Jordi Baylina
74 
75     This program is free software: you can redistribute it and/or modify
76     it under the terms of the GNU General Public License as published by
77     the Free Software Foundation, either version 3 of the License, or
78     (at your option) any later version.
79 
80     This program is distributed in the hope that it will be useful,
81     but WITHOUT ANY WARRANTY; without even the implied warranty of
82     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
83     GNU General Public License for more details.
84 
85     You should have received a copy of the GNU General Public License
86     along with this program.  If not, see <http://www.gnu.org/licenses/>.
87  */
88 
89 /// @title MiniMeToken Contract
90 /// @author Jordi Baylina
91 /// @dev This token contract's goal is to make it easy for anyone to clone this
92 ///  token using the token distribution at a given block, this will allow DAO's
93 ///  and DApps to upgrade their features in a decentralized manner without
94 ///  affecting the original token
95 /// @dev It is ERC20 compliant, but still needs to under go further testing.
96 /// @dev The actual token contract, the default controller is the msg.sender
97 ///  that deploys the contract, so usually this token will be deployed by a
98 ///  token controller contract, which Giveth will call a "Campaign"
99 contract MiniMeToken is Controlled {
100 
101     string public name;                //The Token's name: e.g. DigixDAO Tokens
102     uint8 public decimals;             //Number of decimals of the smallest unit
103     string public symbol;              //An identifier: e.g. REP
104     string public version = "1.0.0"; 
105 
106     /// @dev `Checkpoint` is the structure that attaches a block number to a
107     ///  given value, the block number attached is the one that last changed the
108     ///  value
109     struct Checkpoint {
110 
111         // `fromBlock` is the block number that the value was generated from
112         uint128 fromBlock;
113 
114         // `value` is the amount of tokens at a specific block number
115         uint128 value;
116     }
117 
118     // `parentToken` is the Token address that was cloned to produce this token;
119     //  it will be 0x0 for a token that was not cloned
120     MiniMeToken public parentToken;
121 
122     // `parentSnapShotBlock` is the block number from the Parent Token that was
123     //  used to determine the initial distribution of the Clone Token
124     uint public parentSnapShotBlock;
125 
126     // `creationBlock` is the block number that the Clone Token was created
127     uint public creationBlock;
128 
129     // `balances` is the map that tracks the balance of each address, in this
130     //  contract when the balance changes the block number that the change
131     //  occurred is also included in the map
132     mapping (address => Checkpoint[]) balances;
133 
134     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
135     mapping (address => mapping (address => uint256)) allowed;
136 
137     // Tracks the history of the `totalSupply` of the token
138     Checkpoint[] totalSupplyHistory;
139 
140     // Flag that determines if the token is transferable or not.
141     bool public transfersEnabled;
142 
143     // The factory used to create new clone tokens
144     MiniMeTokenFactory public tokenFactory;
145 
146 ////////////////
147 // Constructor
148 ////////////////
149 
150     /// @notice Constructor to create a MiniMeToken
151     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
152     ///  will create the Clone token contracts, the token factory needs to be
153     ///  deployed first
154     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
155     ///  new token
156     /// @param _parentSnapShotBlock Block of the parent token that will
157     ///  determine the initial distribution of the clone token, set to 0 if it
158     ///  is a new token
159     /// @param _tokenName Name of the new token
160     /// @param _decimalUnits Number of decimals of the new token
161     /// @param _tokenSymbol Token Symbol for the new token
162     /// @param _transfersEnabled If true, tokens will be able to be transferred
163     function MiniMeToken(
164         address _tokenFactory,
165         address _parentToken,
166         uint _parentSnapShotBlock,
167         string _tokenName,
168         uint8 _decimalUnits,
169         string _tokenSymbol,
170         bool _transfersEnabled
171     ) public 
172     {
173         tokenFactory = MiniMeTokenFactory(_tokenFactory);
174         name = _tokenName;                                 // Set the name
175         decimals = _decimalUnits;                          // Set the decimals
176         symbol = _tokenSymbol;                             // Set the symbol
177         parentToken = MiniMeToken(_parentToken);
178         parentSnapShotBlock = _parentSnapShotBlock;
179         transfersEnabled = _transfersEnabled;
180         creationBlock = block.number;
181     }
182 
183 
184 ///////////////////
185 // ERC20 Methods
186 ///////////////////
187 
188     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
189     /// @param _to The address of the recipient
190     /// @param _amount The amount of tokens to be transferred
191     /// @return Whether the transfer was successful or not
192     function transfer(address _to, uint256 _amount) public returns (bool success) {
193         require(transfersEnabled);
194         return doTransfer(msg.sender, _to, _amount);
195     }
196 
197     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
198     ///  is approved by `_from`
199     /// @param _from The address holding the tokens being transferred
200     /// @param _to The address of the recipient
201     /// @param _amount The amount of tokens to be transferred
202     /// @return True if the transfer was successful
203     function transferFrom(address _from, address _to, uint256 _amount) 
204         public returns (bool success) 
205         {
206         // The controller of this contract can move tokens around at will,
207         //  this is important to recognize! Confirm that you trust the
208         //  controller of this contract, which in most situations should be
209         //  another open source smart contract or 0x0
210         if (msg.sender != controller) {
211             require(transfersEnabled);
212 
213             // The standard ERC 20 transferFrom functionality
214             if (allowed[_from][msg.sender] < _amount) {
215                 return false;
216             }
217             allowed[_from][msg.sender] -= _amount;
218         }
219         return doTransfer(_from, _to, _amount);
220     }
221 
222     /// @dev This is the actual transfer function in the token contract, it can
223     ///  only be called by other functions in this contract.
224     /// @param _from The address holding the tokens being transferred
225     /// @param _to The address of the recipient
226     /// @param _amount The amount of tokens to be transferred
227     /// @return True if the transfer was successful
228     function doTransfer(address _from, address _to, uint _amount
229     ) internal returns(bool) 
230     {
231 
232            if (_amount == 0) {
233                return true;
234            }
235 
236            require(parentSnapShotBlock < block.number);
237 
238            // Do not allow transfer to 0x0 or the token contract itself
239            require((_to != 0) && (_to != address(this)));
240 
241            // If the amount being transfered is more than the balance of the
242            //  account the transfer returns false
243            var previousBalanceFrom = balanceOfAt(_from, block.number);
244            if (previousBalanceFrom < _amount) {
245                return false;
246            }
247 
248            // Alerts the token controller of the transfer
249            if (isContract(controller)) {
250                require(TokenController(controller).onTransfer(_from, _to, _amount));
251            }
252 
253            // First update the balance array with the new value for the address
254            //  sending the tokens
255            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
256 
257            // Then update the balance array with the new value for the address
258            //  receiving the tokens
259            var previousBalanceTo = balanceOfAt(_to, block.number);
260            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
261            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
262 
263            // An event to make the transfer easy to find on the blockchain
264            Transfer(_from, _to, _amount);
265 
266            return true;
267     }
268 
269     /// @param _owner The address that's balance is being requested
270     /// @return The balance of `_owner` at the current block
271     function balanceOf(address _owner) public constant returns (uint256 balance) {
272         return balanceOfAt(_owner, block.number);
273     }
274 
275     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
276     ///  its behalf. This is a modified version of the ERC20 approve function
277     ///  to be a little bit safer
278     /// @param _spender The address of the account able to transfer the tokens
279     /// @param _amount The amount of tokens to be approved for transfer
280     /// @return True if the approval was successful
281     function approve(address _spender, uint256 _amount) public returns (bool success) {
282         require(transfersEnabled);
283 
284         // To change the approve amount you first have to reduce the addresses`
285         //  allowance to zero by calling `approve(_spender,0)` if it is not
286         //  already 0 to mitigate the race condition described here:
287         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
289         return doApprove(_spender, _amount);
290     }
291 
292     function doApprove(address _spender, uint256 _amount) internal returns (bool success) {
293         require(transfersEnabled);
294         if (isContract(controller)) {
295             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
296         }
297         allowed[msg.sender][_spender] = _amount;
298         Approval(msg.sender, _spender, _amount);
299         return true;
300     }
301 
302     /// @dev This function makes it easy to read the `allowed[]` map
303     /// @param _owner The address of the account that owns the token
304     /// @param _spender The address of the account able to transfer the tokens
305     /// @return Amount of remaining tokens of _owner that _spender is allowed
306     ///  to spend
307     function allowance(address _owner, address _spender
308     ) public constant returns (uint256 remaining) 
309     {
310         return allowed[_owner][_spender];
311     }
312 
313     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
314     ///  its behalf, and then a function is triggered in the contract that is
315     ///  being approved, `_spender`. This allows users to use their tokens to
316     ///  interact with contracts in one function call instead of two
317     /// @param _spender The address of the contract able to transfer the tokens
318     /// @param _amount The amount of tokens to be approved for transfer
319     /// @return True if the function call was successful
320     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
321     ) public returns (bool success) 
322     {
323         require(approve(_spender, _amount));
324 
325         ApproveAndCallFallBack(_spender).receiveApproval(
326             msg.sender,
327             _amount,
328             this,
329             _extraData
330         );
331 
332         return true;
333     }
334 
335     /// @dev This function makes it easy to get the total number of tokens
336     /// @return The total number of tokens
337     function totalSupply() public constant returns (uint) {
338         return totalSupplyAt(block.number);
339     }
340 
341 
342 ////////////////
343 // Query balance and totalSupply in History
344 ////////////////
345 
346     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
347     /// @param _owner The address from which the balance will be retrieved
348     /// @param _blockNumber The block number when the balance is queried
349     /// @return The balance at `_blockNumber`
350     function balanceOfAt(address _owner, uint _blockNumber) public constant
351         returns (uint) 
352     {
353         // These next few lines are used when the balance of the token is
354         //  requested before a check point was ever created for this token, it
355         //  requires that the `parentToken.balanceOfAt` be queried at the
356         //  genesis block for that token as this contains initial balance of
357         //  this token
358         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
359             if (address(parentToken) != 0) {
360                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
361             } else {
362                 // Has no parent
363                 return 0;
364             }
365 
366         // This will return the expected balance during normal situations
367         } else {
368             return getValueAt(balances[_owner], _blockNumber);
369         }
370     }
371 
372     /// @notice Total amount of tokens at a specific `_blockNumber`.
373     /// @param _blockNumber The block number when the totalSupply is queried
374     /// @return The total amount of tokens at `_blockNumber`
375     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
376 
377         // These next few lines are used when the totalSupply of the token is
378         //  requested before a check point was ever created for this token, it
379         //  requires that the `parentToken.totalSupplyAt` be queried at the
380         //  genesis block for this token as that contains totalSupply of this
381         //  token at this block number.
382         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
383             if (address(parentToken) != 0) {
384                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
385             } else {
386                 return 0;
387             }
388 
389         // This will return the expected totalSupply during normal situations
390         } else {
391             return getValueAt(totalSupplyHistory, _blockNumber);
392         }
393     }
394 
395 ////////////////
396 // Clone Token Method
397 ////////////////
398 
399     /// @notice Creates a new clone token with the initial distribution being
400     ///  this token at `_snapshotBlock`
401     /// @param _cloneTokenName Name of the clone token
402     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
403     /// @param _cloneTokenSymbol Symbol of the clone token
404     /// @param _snapshotBlock Block when the distribution of the parent token is
405     ///  copied to set the initial distribution of the new clone token;
406     ///  if the block is zero than the actual block, the current block is used
407     /// @param _transfersEnabled True if transfers are allowed in the clone
408     /// @return The address of the new MiniMeToken Contract
409     function createCloneToken(
410         string _cloneTokenName,
411         uint8 _cloneDecimalUnits,
412         string _cloneTokenSymbol,
413         uint _snapshotBlock,
414         bool _transfersEnabled
415         ) public returns(address) 
416     {
417         if (_snapshotBlock == 0) {
418             _snapshotBlock = block.number;
419         }
420 
421         MiniMeToken cloneToken = tokenFactory.createCloneToken(
422             this,
423             _snapshotBlock,
424             _cloneTokenName,
425             _cloneDecimalUnits,
426             _cloneTokenSymbol,
427             _transfersEnabled
428             );
429 
430         cloneToken.changeController(msg.sender);
431 
432         // An event to make the token easy to find on the blockchain
433         NewCloneToken(address(cloneToken), _snapshotBlock);
434         return address(cloneToken);
435     }
436 
437 ////////////////
438 // Generate and destroy tokens
439 ////////////////
440 
441     /// @notice Generates `_amount` tokens that are assigned to `_owner`
442     /// @param _owner The address that will be assigned the new tokens
443     /// @param _amount The quantity of tokens generated
444     /// @return True if the tokens are generated correctly
445     function generateTokens(address _owner, uint _amount) 
446         public onlyController returns (bool) 
447     {
448         uint curTotalSupply = totalSupply();
449         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
450         uint previousBalanceTo = balanceOf(_owner);
451         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
452         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
453         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
454         Transfer(0, _owner, _amount);
455         return true;
456     }
457 
458 
459     /// @notice Burns `_amount` tokens from `_owner`
460     /// @param _owner The address that will lose the tokens
461     /// @param _amount The quantity of tokens to burn
462     /// @return True if the tokens are burned correctly
463     function destroyTokens(address _owner, uint _amount
464     ) onlyController public returns (bool) 
465     {
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
483     function enableTransfers(bool _transfersEnabled) public onlyController {
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
495     function getValueAt(Checkpoint[] storage checkpoints, uint _block) 
496         constant internal returns (uint) 
497     {
498         if (checkpoints.length == 0) {
499             return 0;
500         }
501 
502         // Shortcut for the actual value
503         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
504             return checkpoints[checkpoints.length-1].value;
505         }
506             
507         if (_block < checkpoints[0].fromBlock) {
508             return 0;
509         }
510 
511         // Binary search of the value in the array
512         uint min = 0;
513         uint max = checkpoints.length - 1;
514         while (max > min) {
515             uint mid = (max + min + 1) / 2;
516             if (checkpoints[mid].fromBlock<=_block) {
517                 min = mid;
518             } else {
519                 max = mid-1;
520             }
521         }
522         return checkpoints[min].value;
523     }
524 
525     /// @dev `updateValueAtNow` used to update the `balances` map and the
526     ///  `totalSupplyHistory`
527     /// @param checkpoints The history of data being updated
528     /// @param _value The new number of tokens
529     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
530     ) internal  
531     {
532         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length-1].fromBlock < block.number)) {
533                Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
534                newCheckPoint.fromBlock = uint128(block.number);
535                newCheckPoint.value = uint128(_value);
536            } else {
537                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
538                oldCheckPoint.value = uint128(_value);
539            }
540     }
541 
542     /// @dev Internal function to determine if an address is a contract
543     /// @param _addr The address being queried
544     /// @return True if `_addr` is a contract
545     function isContract(address _addr) constant internal returns(bool) {
546         uint size;
547         if (_addr == 0) {
548             return false;
549         }
550         assembly {
551             size := extcodesize(_addr)
552         }
553         return size>0;
554     }
555 
556     /// @dev Helper function to return a min betwen the two uints
557     function min(uint a, uint b) pure internal returns (uint) {
558         return a < b ? a : b;
559     }
560 
561     /// @notice The fallback function: If the contract's controller has not been
562     ///  set to 0, then the `proxyPayment` method is called which relays the
563     ///  ether and creates tokens as described in the token controller contract
564     function () public payable {
565         require(isContract(controller));
566         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
567     }
568 
569 //////////
570 // Safety Methods
571 //////////
572 
573     /// @notice This method can be used by the controller to extract mistakenly
574     ///  sent tokens to this contract.
575     /// @param _token The address of the token contract that you want to recover
576     ///  set to 0 in case you want to extract ether.
577     function claimTokens(address _token) public onlyController {
578         if (_token == 0x0) {
579             controller.transfer(this.balance);
580             return;
581         }
582 
583         MiniMeToken token = MiniMeToken(_token);
584         uint balance = token.balanceOf(this);
585         token.transfer(controller, balance);
586         ClaimedTokens(_token, controller, balance);
587     }
588 
589 ////////////////
590 // Events
591 ////////////////
592     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
593     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
594     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
595     event Approval(
596         address indexed _owner,
597         address indexed _spender,
598         uint256 _amount
599         );
600 
601 }
602 
603 /// @dev The token controller contract must implement these functions
604 contract TokenController {
605     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
606     /// @param _owner The address that sent the ether to create tokens
607     /// @return True if the ether is accepted, false if it throws
608     function proxyPayment(address _owner) public payable returns(bool);
609 
610     /// @notice Notifies the controller about a token transfer allowing the
611     ///  controller to react if desired
612     /// @param _from The origin of the transfer
613     /// @param _to The destination of the transfer
614     /// @param _amount The amount of the transfer
615     /// @return False if the controller does not authorize the transfer
616     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
617 
618     /// @notice Notifies the controller about an approval allowing the
619     ///  controller to react if desired
620     /// @param _owner The address that calls `approve()`
621     /// @param _spender The spender in the `approve()` call
622     /// @param _amount The amount in the `approve()` call
623     /// @return False if the controller does not authorize the approval
624     function onApprove(address _owner, address _spender, uint _amount)
625     public
626     returns(bool);
627 }
628 
629 // FundRequest Token
630 //
631 // @authors:
632 // Davy Van Roy <davy.van.roy@gmail.com>
633 // Quinten De Swaef <quinten.de.swaef@gmail.com>
634 //
635 // Security audit performed by LeastAuthority:
636 // https://github.com/FundRequest/audit-reports/raw/master/2018-02-06 - Least Authority - ICO Contracts Audit Report.pdf
637 contract FundRequestToken is MiniMeToken {
638 
639   function FundRequestToken(
640     address _tokenFactory,
641     address _parentToken, 
642     uint _parentSnapShotBlock, 
643     string _tokenName, 
644     uint8 _decimalUnits, 
645     string _tokenSymbol, 
646     bool _transfersEnabled) 
647     public 
648     MiniMeToken(
649       _tokenFactory,
650       _parentToken, 
651       _parentSnapShotBlock, 
652       _tokenName, 
653       _decimalUnits, 
654       _tokenSymbol, 
655       _transfersEnabled) 
656   {
657     //constructor
658   }
659 
660   function safeApprove(address _spender, uint256 _currentValue, uint256 _amount) public returns (bool success) {
661     require(allowed[msg.sender][_spender] == _currentValue);
662     return doApprove(_spender, _amount);
663   }
664 
665   function isFundRequestToken() public pure returns (bool) {
666     return true;
667   }
668 }