1 pragma solidity ^0.4.18;
2 
3 // File: contracts/token/Controlled.sol
4 
5 contract Controlled {
6     /// @notice The address of the controller is the only address that can call
7     ///  a function with this modifier
8     modifier onlyController { require(msg.sender == controller); _; }
9 
10     address public controller;
11 
12     function Controlled() public { controller = msg.sender;}
13 
14     /// @notice Changes the controller of the contract
15     /// @param _newController The new controller of the contract
16     function changeController(address _newController) public onlyController {
17         controller = _newController;
18     }
19 }
20 
21 // File: contracts/token/TokenController.sol
22 
23 /// @dev The token controller contract must implement these functions
24 contract TokenController {
25     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
26     /// @param _owner The address that sent the ether to create tokens
27     /// @return True if the ether is accepted, false if it throws
28     function proxyPayment(address _owner) public payable returns(bool);
29 
30     /// @notice Notifies the controller about a token transfer allowing the
31     ///  controller to react if desired
32     /// @param _from The origin of the transfer
33     /// @param _to The destination of the transfer
34     /// @param _amount The amount of the transfer
35     /// @return False if the controller does not authorize the transfer
36     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
37 
38     /// @notice Notifies the controller about an approval allowing the
39     ///  controller to react if desired
40     /// @param _owner The address that calls `approve()`
41     /// @param _spender The spender in the `approve()` call
42     /// @param _amount The amount in the `approve()` call
43     /// @return False if the controller does not authorize the approval
44     function onApprove(address _owner, address _spender, uint _amount) public
45         returns(bool);
46 }
47 
48 // File: contracts/token/MiniMeToken.sol
49 
50 /*
51     Copyright 2016, Jordi Baylina
52 
53     This program is free software: you can redistribute it and/or modify
54     it under the terms of the GNU General Public License as published by
55     the Free Software Foundation, either version 3 of the License, or
56     (at your option) any later version.
57 
58     This program is distributed in the hope that it will be useful,
59     but WITHOUT ANY WARRANTY; without even the implied warranty of
60     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
61     GNU General Public License for more details.
62 
63     You should have received a copy of the GNU General Public License
64     along with this program.  If not, see <http://www.gnu.org/licenses/>.
65  */
66 
67 /// @title MiniMeToken Contract
68 /// @author Jordi Baylina
69 /// @dev This token contract's goal is to make it easy for anyone to clone this
70 ///  token using the token distribution at a given block, this will allow DAO's
71 ///  and DApps to upgrade their features in a decentralized manner without
72 ///  affecting the original token
73 /// @dev It is ERC20 compliant, but still needs to under go further testing.
74 
75 
76 
77 
78 contract ApproveAndCallFallBack {
79     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
80 }
81 
82 /// @dev The actual token contract, the default controller is the msg.sender
83 ///  that deploys the contract, so usually this token will be deployed by a
84 ///  token controller contract, which Giveth will call a "Campaign"
85 contract MiniMeToken is Controlled {
86 
87     string public name;                //The Token's name: e.g. DigixDAO Tokens
88     uint8 public decimals;             //Number of decimals of the smallest unit
89     string public symbol;              //An identifier: e.g. REP
90     string public version = 'MMT_0.3'; //An arbitrary versioning scheme
91 
92 
93     /// @dev `Checkpoint` is the structure that attaches a block number to a
94     ///  given value, the block number attached is the one that last changed the
95     ///  value
96     struct  Checkpoint {
97 
98         // `fromBlock` is the block number that the value was generated from
99         uint128 fromBlock;
100 
101         // `value` is the amount of tokens at a specific block number
102         uint128 value;
103     }
104 
105     // `parentToken` is the Token address that was cloned to produce this token;
106     //  it will be 0x0 for a token that was not cloned
107     MiniMeToken public parentToken;
108 
109     // `parentSnapShotBlock` is the block number from the Parent Token that was
110     //  used to determine the initial distribution of the Clone Token
111     uint public parentSnapShotBlock;
112 
113     // `creationBlock` is the block number that the Clone Token was created
114     uint public creationBlock;
115 
116     // `balances` is the map that tracks the balance of each address, in this
117     //  contract when the balance changes the block number that the change
118     //  occurred is also included in the map
119     mapping (address => Checkpoint[]) balances;
120 
121     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
122     mapping (address => mapping (address => uint256)) allowed;
123 
124     // Tracks the history of the `totalSupply` of the token
125     Checkpoint[] totalSupplyHistory;
126 
127     // Flag that determines if the token is transferable or not.
128     bool public transfersEnabled;
129 
130     // The factory used to create new clone tokens
131     MiniMeTokenFactory public tokenFactory;
132 
133 ////////////////
134 // Constructor
135 ////////////////
136 
137     /// @notice Constructor to create a MiniMeToken
138     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
139     ///  will create the Clone token contracts, the token factory needs to be
140     ///  deployed first
141     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
142     ///  new token
143     /// @param _parentSnapShotBlock Block of the parent token that will
144     ///  determine the initial distribution of the clone token, set to 0 if it
145     ///  is a new token
146     /// @param _tokenName Name of the new token
147     /// @param _decimalUnits Number of decimals of the new token
148     /// @param _tokenSymbol Token Symbol for the new token
149     /// @param _transfersEnabled If true, tokens will be able to be transferred
150     function MiniMeToken(
151         address _tokenFactory,
152         address _parentToken,
153         uint _parentSnapShotBlock,
154         string _tokenName,
155         uint8 _decimalUnits,
156         string _tokenSymbol,
157         bool _transfersEnabled
158     ) public {
159         tokenFactory = MiniMeTokenFactory(_tokenFactory);
160         name = _tokenName;                                 // Set the name
161         decimals = _decimalUnits;                          // Set the decimals
162         symbol = _tokenSymbol;                             // Set the symbol
163         parentToken = MiniMeToken(_parentToken);
164         parentSnapShotBlock = _parentSnapShotBlock;
165         transfersEnabled = _transfersEnabled;
166         creationBlock = block.number;
167     }
168 
169 
170 ///////////////////
171 // ERC20 Methods
172 ///////////////////
173 
174     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
175     /// @param _to The address of the recipient
176     /// @param _amount The amount of tokens to be transferred
177     /// @return Whether the transfer was successful or not
178     function transfer(address _to, uint256 _amount) public returns (bool success) {
179         require(transfersEnabled);
180         return doTransfer(msg.sender, _to, _amount);
181     }
182 
183     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
184     ///  is approved by `_from`
185     /// @param _from The address holding the tokens being transferred
186     /// @param _to The address of the recipient
187     /// @param _amount The amount of tokens to be transferred
188     /// @return True if the transfer was successful
189     function transferFrom(address _from, address _to, uint256 _amount
190     ) public returns (bool success) {
191 
192         // The controller of this contract can move tokens around at will,
193 
194         //  controller of this contract, which in most situations should be
195         //  another open source smart contract or 0x0
196         if (msg.sender != controller) {
197             require(transfersEnabled);
198 
199             // The standard ERC 20 transferFrom functionality
200             if (allowed[_from][msg.sender] < _amount) return false;
201             allowed[_from][msg.sender] -= _amount;
202         }
203         return doTransfer(_from, _to, _amount);
204     }
205 
206     /// @dev This is the actual transfer function in the token contract, it can
207     ///  only be called by other functions in this contract.
208     /// @param _from The address holding the tokens being transferred
209     /// @param _to The address of the recipient
210     /// @param _amount The amount of tokens to be transferred
211     /// @return True if the transfer was successful
212     function doTransfer(address _from, address _to, uint _amount
213     ) internal returns(bool) {
214 
215            if (_amount == 0) {
216                return true;
217            }
218 
219            require(parentSnapShotBlock < block.number);
220 
221            // Do not allow transfer to 0x0 or the token contract itself
222            require((_to != 0) && (_to != address(this)));
223 
224            // If the amount being transfered is more than the balance of the
225            //  account the transfer returns false
226            var previousBalanceFrom = balanceOfAt(_from, block.number);
227            if (previousBalanceFrom < _amount) {
228                return false;
229            }
230 
231            // Alerts the token controller of the transfer
232            if (isContract(controller)) {
233                require(TokenController(controller).onTransfer(_from, _to, _amount));
234            }
235 
236            // First update the balance array with the new value for the address
237            //  sending the tokens
238            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
239 
240            // Then update the balance array with the new value for the address
241            //  receiving the tokens
242            var previousBalanceTo = balanceOfAt(_to, block.number);
243            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
244            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
245 
246            // An event to make the transfer easy to find on the blockchain
247            Transfer(_from, _to, _amount);
248 
249            return true;
250     }
251 
252     /// @param _owner The address that's balance is being requested
253     /// @return The balance of `_owner` at the current block
254     function balanceOf(address _owner) public constant returns (uint256 balance) {
255         return balanceOfAt(_owner, block.number);
256     }
257 
258     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
259     ///  its behalf. This is a modified version of the ERC20 approve function
260     ///  to be a little bit safer
261     /// @param _spender The address of the account able to transfer the tokens
262     /// @param _amount The amount of tokens to be approved for transfer
263     /// @return True if the approval was successful
264     function approve(address _spender, uint256 _amount) public returns (bool success) {
265         require(transfersEnabled);
266 
267         // To change the approve amount you first have to reduce the addresses`
268         //  allowance to zero by calling `approve(_spender,0)` if it is not
269         //  already 0 to mitigate the race condition described here:
270         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
272 
273         // Alerts the token controller of the approve function call
274         if (isContract(controller)) {
275             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
276         }
277 
278         allowed[msg.sender][_spender] = _amount;
279         Approval(msg.sender, _spender, _amount);
280         return true;
281     }
282 
283     /// @dev This function makes it easy to read the `allowed[]` map
284     /// @param _owner The address of the account that owns the token
285     /// @param _spender The address of the account able to transfer the tokens
286     /// @return Amount of remaining tokens of _owner that _spender is allowed
287     ///  to spend
288     function allowance(address _owner, address _spender
289     ) public constant returns (uint256 remaining) {
290         return allowed[_owner][_spender];
291     }
292 
293     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
294     ///  its behalf, and then a function is triggered in the contract that is
295     ///  being approved, `_spender`. This allows users to use their tokens to
296     ///  interact with contracts in one function call instead of two
297     /// @param _spender The address of the contract able to transfer the tokens
298     /// @param _amount The amount of tokens to be approved for transfer
299     /// @return True if the function call was successful
300     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
301     ) public returns (bool success) {
302         require(approve(_spender, _amount));
303 
304         ApproveAndCallFallBack(_spender).receiveApproval(
305             msg.sender,
306             _amount,
307             this,
308             _extraData
309         );
310 
311         return true;
312     }
313 
314     /// @dev This function makes it easy to get the total number of tokens
315     /// @return The total number of tokens
316     function totalSupply() public constant returns (uint) {
317         return totalSupplyAt(block.number);
318     }
319 
320 
321 ////////////////
322 // Query balance and totalSupply in History
323 ////////////////
324 
325     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
326     /// @param _owner The address from which the balance will be retrieved
327     /// @param _blockNumber The block number when the balance is queried
328     /// @return The balance at `_blockNumber`
329     function balanceOfAt(address _owner, uint _blockNumber) public constant
330         returns (uint) {
331 
332         // These next few lines are used when the balance of the token is
333         //  requested before a check point was ever created for this token, it
334         //  requires that the `parentToken.balanceOfAt` be queried at the
335         //  genesis block for that token as this contains initial balance of
336         //  this token
337         if ((balances[_owner].length == 0)
338             || (balances[_owner][0].fromBlock > _blockNumber)) {
339             if (address(parentToken) != 0) {
340                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
341             } else {
342                 // Has no parent
343                 return 0;
344             }
345 
346         // This will return the expected balance during normal situations
347         } else {
348             return getValueAt(balances[_owner], _blockNumber);
349         }
350     }
351 
352     /// @notice Total amount of tokens at a specific `_blockNumber`.
353     /// @param _blockNumber The block number when the totalSupply is queried
354     /// @return The total amount of tokens at `_blockNumber`
355     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
356 
357         // These next few lines are used when the totalSupply of the token is
358         //  requested before a check point was ever created for this token, it
359         //  requires that the `parentToken.totalSupplyAt` be queried at the
360         //  genesis block for this token as that contains totalSupply of this
361         //  token at this block number.
362         if ((totalSupplyHistory.length == 0)
363             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
364             if (address(parentToken) != 0) {
365                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
366             } else {
367                 return 0;
368             }
369 
370         // This will return the expected totalSupply during normal situations
371         } else {
372             return getValueAt(totalSupplyHistory, _blockNumber);
373         }
374     }
375 
376 ////////////////
377 // Clone Token Method
378 ////////////////
379 
380     /// @notice Creates a new clone token with the initial distribution being
381     ///  this token at `_snapshotBlock`
382     /// @param _cloneTokenName Name of the clone token
383     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
384     /// @param _cloneTokenSymbol Symbol of the clone token
385     /// @param _snapshotBlock Block when the distribution of the parent token is
386     ///  copied to set the initial distribution of the new clone token;
387     ///  if the block is zero than the actual block, the current block is used
388     /// @param _transfersEnabled True if transfers are allowed in the clone
389     /// @return The address of the new MiniMeToken Contract
390     function createCloneToken(
391         string _cloneTokenName,
392         uint8 _cloneDecimalUnits,
393         string _cloneTokenSymbol,
394         uint _snapshotBlock,
395         bool _transfersEnabled
396         ) public returns(address) {
397         if (_snapshotBlock == 0) _snapshotBlock = block.number;
398         MiniMeToken cloneToken = tokenFactory.createCloneToken(
399             this,
400             _snapshotBlock,
401             _cloneTokenName,
402             _cloneDecimalUnits,
403             _cloneTokenSymbol,
404             _transfersEnabled
405             );
406 
407         cloneToken.changeController(msg.sender);
408 
409         // An event to make the token easy to find on the blockchain
410         NewCloneToken(address(cloneToken), _snapshotBlock);
411         return address(cloneToken);
412     }
413 
414 ////////////////
415 // Generate and destroy tokens
416 ////////////////
417 
418     /// @notice Generates `_amount` tokens that are assigned to `_owner`
419     /// @param _owner The address that will be assigned the new tokens
420     /// @param _amount The quantity of tokens generated
421     /// @return True if the tokens are generated correctly
422     function generateTokens(address _owner, uint _amount
423     ) public onlyController returns (bool) {
424         uint curTotalSupply = totalSupply();
425         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
426         uint previousBalanceTo = balanceOf(_owner);
427         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
428         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
429         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
430         Transfer(0, _owner, _amount);
431         return true;
432     }
433 
434     /// @notice Burns `_amount` tokens from `_owner`
435     /// @param _owner The address that will lose the tokens
436     /// @param _amount The quantity of tokens to burn
437     /// @return True if the tokens are burned correctly
438     function destroyTokens(address _owner, uint _amount
439     ) onlyController public returns (bool) {
440         uint curTotalSupply = totalSupply();
441         require(curTotalSupply >= _amount);
442         uint previousBalanceFrom = balanceOf(_owner);
443         require(previousBalanceFrom >= _amount);
444         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
445         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
446         Transfer(_owner, 0, _amount);
447         return true;
448     }
449 
450 ////////////////
451 // Enable tokens transfers
452 ////////////////
453 
454 
455     /// @notice Enables token holders to transfer their tokens freely if true
456     /// @param _transfersEnabled True if transfers are allowed in the clone
457     function enableTransfers(bool _transfersEnabled) public onlyController {
458         transfersEnabled = _transfersEnabled;
459     }
460 
461 ////////////////
462 // Internal helper functions to query and set a value in a snapshot array
463 ////////////////
464 
465     /// @dev `getValueAt` retrieves the number of tokens at a given block number
466     /// @param checkpoints The history of values being queried
467     /// @param _block The block number to retrieve the value at
468     /// @return The number of tokens being queried
469     function getValueAt(Checkpoint[] storage checkpoints, uint _block
470     ) constant internal returns (uint) {
471         if (checkpoints.length == 0) return 0;
472 
473         // Shortcut for the actual value
474         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
475             return checkpoints[checkpoints.length-1].value;
476         if (_block < checkpoints[0].fromBlock) return 0;
477 
478         // Binary search of the value in the array
479         uint min = 0;
480         uint max = checkpoints.length-1;
481         while (max > min) {
482             uint mid = (max + min + 1)/ 2;
483             if (checkpoints[mid].fromBlock<=_block) {
484                 min = mid;
485             } else {
486                 max = mid-1;
487             }
488         }
489         return checkpoints[min].value;
490     }
491 
492     /// @dev `updateValueAtNow` used to update the `balances` map and the
493     ///  `totalSupplyHistory`
494     /// @param checkpoints The history of data being updated
495     /// @param _value The new number of tokens
496     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
497     ) internal  {
498         if ((checkpoints.length == 0)
499         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
500                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
501                newCheckPoint.fromBlock =  uint128(block.number);
502                newCheckPoint.value = uint128(_value);
503            } else {
504                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
505                oldCheckPoint.value = uint128(_value);
506            }
507     }
508 
509     /// @dev Internal function to determine if an address is a contract
510     /// @param _addr The address being queried
511     /// @return True if `_addr` is a contract
512     function isContract(address _addr) constant internal returns(bool) {
513         uint size;
514         if (_addr == 0) return false;
515         assembly {
516             size := extcodesize(_addr)
517         }
518         return size>0;
519     }
520 
521     /// @dev Helper function to return a min betwen the two uints
522     function min(uint a, uint b) pure internal returns (uint) {
523         return a < b ? a : b;
524     }
525 
526     /// @notice The fallback function: If the contract's controller has not been
527     ///  set to 0, then the `proxyPayment` method is called which relays the
528     ///  ether and creates tokens as described in the token controller contract
529     function () public payable {
530         require(isContract(controller));
531         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
532     }
533 
534 //////////
535 // Safety Methods
536 //////////
537 
538     /// @notice This method can be used by the controller to extract mistakenly
539     ///  sent tokens to this contract.
540     /// @param _token The address of the token contract that you want to recover
541     ///  set to 0 in case you want to extract ether.
542     function claimTokens(address _token) public onlyController {
543         if (_token == 0x0) {
544             controller.transfer(this.balance);
545             return;
546         }
547 
548         MiniMeToken token = MiniMeToken(_token);
549         uint balance = token.balanceOf(this);
550         token.transfer(controller, balance);
551         ClaimedTokens(_token, controller, balance);
552     }
553 
554 ////////////////
555 // Events
556 ////////////////
557     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
558     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
559     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
560     event Approval(
561         address indexed _owner,
562         address indexed _spender,
563         uint256 _amount
564         );
565 
566 }
567 
568 
569 ////////////////
570 // MiniMeTokenFactory
571 ////////////////
572 
573 /// @dev This contract is used to generate clone contracts from a contract.
574 ///  In solidity this is the way to create a contract from a contract of the
575 ///  same class
576 contract MiniMeTokenFactory {
577 
578     /// @notice Update the DApp by creating a new token with new functionalities
579     ///  the msg.sender becomes the controller of this clone token
580     /// @param _parentToken Address of the token being cloned
581     /// @param _snapshotBlock Block of the parent token that will
582     ///  determine the initial distribution of the clone token
583     /// @param _tokenName Name of the new token
584     /// @param _decimalUnits Number of decimals of the new token
585     /// @param _tokenSymbol Token Symbol for the new token
586     /// @param _transfersEnabled If true, tokens will be able to be transferred
587     /// @return The address of the new token contract
588     function createCloneToken(
589         address _parentToken,
590         uint _snapshotBlock,
591         string _tokenName,
592         uint8 _decimalUnits,
593         string _tokenSymbol,
594         bool _transfersEnabled
595     ) public returns (MiniMeToken) {
596         MiniMeToken newToken = new MiniMeToken(
597             this,
598             _parentToken,
599             _snapshotBlock,
600             _tokenName,
601             _decimalUnits,
602             _tokenSymbol,
603             _transfersEnabled
604             );
605 
606         newToken.changeController(msg.sender);
607         return newToken;
608     }
609 }
610 
611 // File: contracts/ATX.sol
612 
613 contract ATX is MiniMeToken {
614     mapping (address => bool) public blacklisted;
615     bool public generateFinished;
616 
617     // @dev ATX constructor just parametrizes the MiniMeToken constructor
618     function ATX(address _tokenFactory)
619     MiniMeToken(
620         _tokenFactory,
621         0x0,            // no parent token
622         0,              // no snapshot block number from parent
623         "Aston X",  // Token name
624         18,                 // Decimals
625         "ATX",              // Symbol
626         false               // Enable transfers
627     ) {}
628 
629     function generateTokens(address _owner, uint _amount) public onlyController returns (bool) {
630         require(generateFinished == false);
631         return super.generateTokens(_owner, _amount);
632     }
633     
634     function swapTokens(address[] _owners, uint[] _amounts) public onlyController returns (uint) {
635         require(generateFinished == false);
636         require(_owners.length == _amounts.length);
637         require(_owners.length > 0 && _amounts.length > 0);
638 
639         uint gencnt = 0;
640         for(uint i=0; i<_owners.length; i++) {
641             if(super.generateTokens(_owners[i], _amounts[i])) {
642                 gencnt++;
643             }
644         }
645         return gencnt;
646     }
647 
648     function resetTokens(address[] _owners, uint[] _amounts) public onlyController returns (uint) {
649         require(generateFinished == false);
650         require(_owners.length == _amounts.length);
651         require(_owners.length > 0 && _amounts.length > 0);
652 
653         uint resetcnt = 0;
654         for(uint i=0; i<_owners.length; i++) {
655             if(super.destroyTokens(_owners[i], _amounts[i])) {
656                 resetcnt++;
657             }
658         }
659         return resetcnt;
660     }
661     
662     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
663         require(blacklisted[_from] == false);
664         return super.doTransfer(_from, _to, _amount);
665     }
666 
667     function finishGenerating(bool _finishGenerating) public onlyController {
668         generateFinished = _finishGenerating;
669     }
670 
671     function blacklistAccount(address tokenOwner) public onlyController returns (bool) {
672         blacklisted[tokenOwner] = true;
673         return true;
674     }
675     function unBlacklistAccount(address tokenOwner) public onlyController returns (bool) {
676         blacklisted[tokenOwner] = false;
677         return true;
678     }
679     function destruct(address to) public onlyController returns(bool) {
680         selfdestruct(to);
681         return true;
682     }
683 }