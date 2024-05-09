1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     function Ownable() {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) onlyOwner public {
64         require(newOwner != address(0));
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67     }
68 
69 }
70 
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
96 
97 
98 /// @dev The token controller contract must implement these functions
99 contract TokenController {
100     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
101     /// @param _owner The address that sent the ether to create tokens
102     /// @return True if the ether is accepted, false if it throws
103     function proxyPayment(address _owner) payable returns(bool);
104 
105     /// @notice Notifies the controller about a token transfer allowing the
106     ///  controller to react if desired
107     /// @param _from The origin of the transfer
108     /// @param _to The destination of the transfer
109     /// @param _amount The amount of the transfer
110     /// @return False if the controller does not authorize the transfer
111     function onTransfer(address _from, address _to, uint256 _amount) returns(bool);
112 
113     /// @notice Notifies the controller about an approval allowing the
114     ///  controller to react if desired
115     /// @param _owner The address that calls `approve()`
116     /// @param _spender The spender in the `approve()` call
117     /// @param _amount The amount in the `approve()` call
118     /// @return False if the controller does not authorize the approval
119     function onApprove(address _owner, address _spender, uint256 _amount)
120     returns(bool);
121 }
122 
123 contract Controlled {
124     /// @notice The address of the controller is the only address that can call
125     ///  a function with this modifier
126     modifier onlyController { require(msg.sender == controller); _; }
127 
128     address public controller;
129 
130     function Controlled() { controller = msg.sender;}
131 
132     /// @notice Changes the controller of the contract
133     /// @param _newController The new controller of the contract
134     function changeController(address _newController) onlyController {
135         controller = _newController;
136     }
137 }
138 
139 contract ApproveAndCallFallBack {
140     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
141 }
142 
143 /// @dev The actual token contract, the default controller is the msg.sender
144 ///  that deploys the contract, so usually this token will be deployed by a
145 ///  token controller contract, which Giveth will call a "Campaign"
146 contract MiniMeToken is Controlled {
147 
148     string public name;                //The Token's name: e.g. DigixDAO Tokens
149     uint8 public decimals;             //Number of decimals of the smallest unit
150     string public symbol;              //An identifier: e.g. REP
151     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
152 
153 
154     /// @dev `Checkpoint` is the structure that attaches a block number to a
155     ///  given value, the block number attached is the one that last changed the
156     ///  value
157     struct  Checkpoint {
158 
159     // `fromBlock` is the block number that the value was generated from
160     uint128 fromBlock;
161 
162     // `value` is the amount of tokens at a specific block number
163     uint128 value;
164     }
165 
166     // `parentToken` is the Token address that was cloned to produce this token;
167     //  it will be 0x0 for a token that was not cloned
168     MiniMeToken public parentToken;
169 
170     // `parentSnapShotBlock` is the block number from the Parent Token that was
171     //  used to determine the initial distribution of the Clone Token
172     uint256 public parentSnapShotBlock;
173 
174     // `creationBlock` is the block number that the Clone Token was created
175     uint256 public creationBlock;
176 
177     // `balances` is the map that tracks the balance of each address, in this
178     //  contract when the balance changes the block number that the change
179     //  occurred is also included in the map
180     mapping (address => Checkpoint[]) balances;
181 
182     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
183     mapping (address => mapping (address => uint256)) allowed;
184 
185     // Tracks the history of the `totalSupply` of the token
186     Checkpoint[] totalSupplyHistory;
187 
188     // Flag that determines if the token is transferable or not.
189     bool public transfersEnabled;
190 
191     // The factory used to create new clone tokens
192     MiniMeTokenFactory public tokenFactory;
193 
194     ////////////////
195     // Constructor
196     ////////////////
197 
198     /// @notice Constructor to create a MiniMeToken
199     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
200     ///  will create the Clone token contracts, the token factory needs to be
201     ///  deployed first
202     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
203     ///  new token
204     /// @param _parentSnapShotBlock Block of the parent token that will
205     ///  determine the initial distribution of the clone token, set to 0 if it
206     ///  is a new token
207     /// @param _tokenName Name of the new token
208     /// @param _decimalUnits Number of decimals of the new token
209     /// @param _tokenSymbol Token Symbol for the new token
210     /// @param _transfersEnabled If true, tokens will be able to be transferred
211     function MiniMeToken(
212         address _tokenFactory,
213         address _parentToken,
214         uint256 _parentSnapShotBlock,
215         string _tokenName,
216         uint8 _decimalUnits,
217         string _tokenSymbol,
218         bool _transfersEnabled
219     ) {
220         tokenFactory = MiniMeTokenFactory(_tokenFactory);
221         name = _tokenName;                                 // Set the name
222         decimals = _decimalUnits;                          // Set the decimals
223         symbol = _tokenSymbol;                             // Set the symbol
224         parentToken = MiniMeToken(_parentToken);
225         parentSnapShotBlock = _parentSnapShotBlock;
226         transfersEnabled = _transfersEnabled;
227         creationBlock = block.number;
228     }
229 
230 
231     ///////////////////
232     // ERC20 Methods
233     ///////////////////
234 
235     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
236     /// @param _to The address of the recipient
237     /// @param _amount The amount of tokens to be transferred
238     /// @return Whether the transfer was successful or not
239     function transfer(address _to, uint256 _amount) returns (bool success) {
240         require(transfersEnabled);
241         return doTransfer(msg.sender, _to, _amount);
242     }
243 
244     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
245     ///  is approved by `_from`
246     /// @param _from The address holding the tokens being transferred
247     /// @param _to The address of the recipient
248     /// @param _amount The amount of tokens to be transferred
249     /// @return True if the transfer was successful
250     function transferFrom(address _from, address _to, uint256 _amount
251     ) returns (bool success) {
252 
253         // The controller of this contract can move tokens around at will,
254         //  this is important to recognize! Confirm that you trust the
255         //  controller of this contract, which in most situations should be
256         //  another open source smart contract or 0x0
257         if (msg.sender != controller) {
258             require(transfersEnabled);
259 
260             // The standard ERC 20 transferFrom functionality
261             if (allowed[_from][msg.sender] < _amount) return false;
262             allowed[_from][msg.sender] -= _amount;
263         }
264         return doTransfer(_from, _to, _amount);
265     }
266 
267     /// @dev This is the actual transfer function in the token contract, it can
268     ///  only be called by other functions in this contract.
269     /// @param _from The address holding the tokens being transferred
270     /// @param _to The address of the recipient
271     /// @param _amount The amount of tokens to be transferred
272     /// @return True if the transfer was successful
273     function doTransfer(address _from, address _to, uint256 _amount
274     ) internal returns(bool) {
275 
276         if (_amount == 0) {
277             return true;
278         }
279 
280         require(parentSnapShotBlock < block.number);
281 
282         // Do not allow transfer to 0x0 or the token contract itself
283         require((_to != 0) && (_to != address(this)));
284 
285         // If the amount being transfered is more than the balance of the
286         //  account the transfer returns false
287         var previousBalanceFrom = balanceOfAt(_from, block.number);
288         if (previousBalanceFrom < _amount) {
289             return false;
290         }
291 
292         // Alerts the token controller of the transfer
293         if (isContract(controller)) {
294             require(TokenController(controller).onTransfer(_from, _to, _amount));
295         }
296 
297         // First update the balance array with the new value for the address
298         //  sending the tokens
299         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
300 
301         // Then update the balance array with the new value for the address
302         //  receiving the tokens
303         var previousBalanceTo = balanceOfAt(_to, block.number);
304         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
305         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
306 
307         // An event to make the transfer easy to find on the blockchain
308         Transfer(_from, _to, _amount);
309 
310         return true;
311     }
312 
313     /// @param _owner The address that's balance is being requested
314     /// @return The balance of `_owner` at the current block
315     function balanceOf(address _owner) constant returns (uint256 balance) {
316         return balanceOfAt(_owner, block.number);
317     }
318 
319     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
320     ///  its behalf. This is a modified version of the ERC20 approve function
321     ///  to be a little bit safer
322     /// @param _spender The address of the account able to transfer the tokens
323     /// @param _amount The amount of tokens to be approved for transfer
324     /// @return True if the approval was successful
325     function approve(address _spender, uint256 _amount) returns (bool success) {
326         require(transfersEnabled);
327 
328         // To change the approve amount you first have to reduce the addresses`
329         //  allowance to zero by calling `approve(_spender,0)` if it is not
330         //  already 0 to mitigate the race condition described here:
331         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
333 
334         // Alerts the token controller of the approve function call
335         if (isContract(controller)) {
336             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
337         }
338 
339         allowed[msg.sender][_spender] = _amount;
340         Approval(msg.sender, _spender, _amount);
341         return true;
342     }
343 
344     /// @dev This function makes it easy to read the `allowed[]` map
345     /// @param _owner The address of the account that owns the token
346     /// @param _spender The address of the account able to transfer the tokens
347     /// @return Amount of remaining tokens of _owner that _spender is allowed
348     ///  to spend
349     function allowance(address _owner, address _spender
350     ) constant returns (uint256 remaining) {
351         return allowed[_owner][_spender];
352     }
353 
354     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
355     ///  its behalf, and then a function is triggered in the contract that is
356     ///  being approved, `_spender`. This allows users to use their tokens to
357     ///  interact with contracts in one function call instead of two
358     /// @param _spender The address of the contract able to transfer the tokens
359     /// @param _amount The amount of tokens to be approved for transfer
360     /// @return True if the function call was successful
361     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
362     ) returns (bool success) {
363         require(approve(_spender, _amount));
364 
365         ApproveAndCallFallBack(_spender).receiveApproval(
366         msg.sender,
367         _amount,
368         this,
369         _extraData
370         );
371 
372         return true;
373     }
374 
375     /// @dev This function makes it easy to get the total number of tokens
376     /// @return The total number of tokens
377     function totalSupply() constant returns (uint) {
378         return totalSupplyAt(block.number);
379     }
380 
381     ////////////////
382     // Query balance and totalSupply in History
383     ////////////////
384 
385     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
386     /// @param _owner The address from which the balance will be retrieved
387     /// @param _blockNumber The block number when the balance is queried
388     /// @return The balance at `_blockNumber`
389     function balanceOfAt(address _owner, uint256 _blockNumber) constant
390     returns (uint) {
391 
392         // These next few lines are used when the balance of the token is
393         //  requested before a check point was ever created for this token, it
394         //  requires that the `parentToken.balanceOfAt` be queried at the
395         //  genesis block for that token as this contains initial balance of
396         //  this token
397         if ((balances[_owner].length == 0)
398         || (balances[_owner][0].fromBlock > _blockNumber)) {
399             if (address(parentToken) != 0) {
400                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
401             } else {
402                 // Has no parent
403                 return 0;
404             }
405 
406             // This will return the expected balance during normal situations
407         } else {
408             return getValueAt(balances[_owner], _blockNumber);
409         }
410     }
411 
412     /// @notice Total amount of tokens at a specific `_blockNumber`.
413     /// @param _blockNumber The block number when the totalSupply is queried
414     /// @return The total amount of tokens at `_blockNumber`
415     function totalSupplyAt(uint256 _blockNumber) constant returns(uint) {
416 
417         // These next few lines are used when the totalSupply of the token is
418         //  requested before a check point was ever created for this token, it
419         //  requires that the `parentToken.totalSupplyAt` be queried at the
420         //  genesis block for this token as that contains totalSupply of this
421         //  token at this block number.
422         if ((totalSupplyHistory.length == 0)
423         || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
424             if (address(parentToken) != 0) {
425                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
426             } else {
427                 return 0;
428             }
429 
430             // This will return the expected totalSupply during normal situations
431         } else {
432             return getValueAt(totalSupplyHistory, _blockNumber);
433         }
434     }
435 
436     ////////////////
437     // Clone Token Method
438     ////////////////
439 
440     /// @notice Creates a new clone token with the initial distribution being
441     ///  this token at `_snapshotBlock`
442     /// @param _cloneTokenName Name of the clone token
443     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
444     /// @param _cloneTokenSymbol Symbol of the clone token
445     /// @param _snapshotBlock Block when the distribution of the parent token is
446     ///  copied to set the initial distribution of the new clone token;
447     ///  if the block is zero than the actual block, the current block is used
448     /// @param _transfersEnabled True if transfers are allowed in the clone
449     /// @return The address of the new MiniMeToken Contract
450     function createCloneToken(
451     string _cloneTokenName,
452     uint8 _cloneDecimalUnits,
453     string _cloneTokenSymbol,
454     uint256 _snapshotBlock,
455     bool _transfersEnabled
456     ) returns(address) {
457         if (_snapshotBlock == 0) _snapshotBlock = block.number;
458         MiniMeToken cloneToken = tokenFactory.createCloneToken(
459         this,
460         _snapshotBlock,
461         _cloneTokenName,
462         _cloneDecimalUnits,
463         _cloneTokenSymbol,
464         _transfersEnabled
465         );
466 
467         cloneToken.changeController(msg.sender);
468 
469         // An event to make the token easy to find on the blockchain
470         NewCloneToken(address(cloneToken), _snapshotBlock);
471         return address(cloneToken);
472     }
473 
474     ////////////////
475     // Generate and destroy tokens
476     ////////////////
477 
478     /// @notice Generates `_amount` tokens that are assigned to `_owner`
479     /// @param _owner The address that will be assigned the new tokens
480     /// @param _amount The quantity of tokens generated
481     /// @return True if the tokens are generated correctly
482     function generateTokens(address _owner, uint256 _amount
483     ) onlyController returns (bool) {
484         uint256 curTotalSupply = totalSupply();
485         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
486         uint256 previousBalanceTo = balanceOf(_owner);
487         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
488         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
489         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
490         Transfer(0, _owner, _amount);
491         return true;
492     }
493 
494 
495     /// @notice Burns `_amount` tokens from `_owner`
496     /// @param _owner The address that will lose the tokens
497     /// @param _amount The quantity of tokens to burn
498     /// @return True if the tokens are burned correctly
499     function destroyTokens(address _owner, uint256 _amount
500     ) onlyController returns (bool) {
501         uint256 curTotalSupply = totalSupply();
502         require(curTotalSupply >= _amount);
503         uint256 previousBalanceFrom = balanceOf(_owner);
504         require(previousBalanceFrom >= _amount);
505         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
506         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
507         Transfer(_owner, 0, _amount);
508         return true;
509     }
510 
511     ////////////////
512     // Enable tokens transfers
513     ////////////////
514 
515     /// @notice Enables token holders to transfer their tokens freely if true
516     /// @param _transfersEnabled True if transfers are allowed in the clone
517     function enableTransfers(bool _transfersEnabled) onlyController {
518         transfersEnabled = _transfersEnabled;
519     }
520 
521     ////////////////
522     // Internal helper functions to query and set a value in a snapshot array
523     ////////////////
524 
525     /// @dev `getValueAt` retrieves the number of tokens at a given block number
526     /// @param checkpoints The history of values being queried
527     /// @param _block The block number to retrieve the value at
528     /// @return The number of tokens being queried
529     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block
530     ) constant internal returns (uint) {
531         if (checkpoints.length == 0) return 0;
532 
533         // Shortcut for the actual value
534         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
535         return checkpoints[checkpoints.length-1].value;
536         if (_block < checkpoints[0].fromBlock) return 0;
537 
538         // Binary search of the value in the array
539         uint256 min = 0;
540         uint256 max = checkpoints.length-1;
541         while (max > min) {
542             uint256 mid = (max + min + 1)/ 2;
543             if (checkpoints[mid].fromBlock<=_block) {
544                 min = mid;
545             } else {
546                 max = mid-1;
547             }
548         }
549         return checkpoints[min].value;
550     }
551 
552     /// @dev `updateValueAtNow` used to update the `balances` map and the
553     ///  `totalSupplyHistory`
554     /// @param checkpoints The history of data being updated
555     /// @param _value The new number of tokens
556     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value
557     ) internal  {
558         if ((checkpoints.length == 0)
559         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
560             Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
561             newCheckPoint.fromBlock =  uint128(block.number);
562             newCheckPoint.value = uint128(_value);
563         } else {
564             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
565             oldCheckPoint.value = uint128(_value);
566         }
567     }
568 
569     /// @dev Internal function to determine if an address is a contract
570     /// @param _addr The address being queried
571     /// @return True if `_addr` is a contract
572     function isContract(address _addr) constant internal returns(bool) {
573         uint256 size;
574         if (_addr == 0) return false;
575         assembly {
576             size := extcodesize(_addr)
577         }
578         return size>0;
579     }
580 
581     /// @dev Helper function to return a min betwen the two uints
582     function min(uint256 a, uint256 b) internal returns (uint) {
583         return a < b ? a : b;
584     }
585 
586     /// @notice The fallback function: If the contract's controller has not been
587     ///  set to 0, then the `proxyPayment` method is called which relays the
588     ///  ether and creates tokens as described in the token controller contract
589     function ()  payable {
590         require(isContract(controller));
591         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
592     }
593 
594     //////////
595     // Safety Methods
596     //////////
597 
598     /// @notice This method can be used by the controller to extract mistakenly
599     ///  sent tokens to this contract.
600     /// @param _token The address of the token contract that you want to recover
601     ///  set to 0 in case you want to extract ether.
602     function claimTokens(address _token) onlyController {
603         if (_token == 0x0) {
604             controller.transfer(this.balance);
605             return;
606         }
607 
608         MiniMeToken token = MiniMeToken(_token);
609         uint256 balance = token.balanceOf(this);
610         token.transfer(controller, balance);
611         ClaimedTokens(_token, controller, balance);
612     }
613 
614     ////////////////
615     // Events
616     ////////////////
617     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
618     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
619     event NewCloneToken(address indexed _cloneToken, uint256 _snapshotBlock);
620     event Approval(
621         address indexed _owner,
622         address indexed _spender,
623         uint256 _amount
624     );
625 
626 }
627 
628 ////////////////
629 // MiniMeTokenFactory
630 ////////////////
631 
632 /// @dev This contract is used to generate clone contracts from a contract.
633 ///  In solidity this is the way to create a contract from a contract of the
634 ///  same class
635 contract MiniMeTokenFactory {
636 
637     /// @notice Update the DApp by creating a new token with new functionalities
638     ///  the msg.sender becomes the controller of this clone token
639     /// @param _parentToken Address of the token being cloned
640     /// @param _snapshotBlock Block of the parent token that will
641     ///  determine the initial distribution of the clone token
642     /// @param _tokenName Name of the new token
643     /// @param _decimalUnits Number of decimals of the new token
644     /// @param _tokenSymbol Token Symbol for the new token
645     /// @param _transfersEnabled If true, tokens will be able to be transferred
646     /// @return The address of the new token contract
647     function createCloneToken(
648         address _parentToken,
649         uint256 _snapshotBlock,
650         string _tokenName,
651         uint8 _decimalUnits,
652         string _tokenSymbol,
653         bool _transfersEnabled
654     ) returns (MiniMeToken) {
655         MiniMeToken newToken = new MiniMeToken(
656             this,
657             _parentToken,
658             _snapshotBlock,
659             _tokenName,
660             _decimalUnits,
661             _tokenSymbol,
662             _transfersEnabled
663         );
664 
665         newToken.changeController(msg.sender);
666         return newToken;
667     }
668 }
669 
670 contract TokenBurner {
671     function burn(address , uint256 )
672     returns (bool result) {
673         return false;
674     }
675 }
676 
677 contract FiinuToken is MiniMeToken, Ownable {
678 
679     TokenBurner public tokenBurner;
680 
681     function FiinuToken(address _tokenFactory)
682     MiniMeToken(
683         _tokenFactory,
684         0x0,                     // no parent token
685         0,                       // no snapshot block number from parent
686         "Fiinu Token",           // Token name
687         6,                       // Decimals
688         "FNU",                   // Symbol
689         true                    // Enable transfers
690     )
691     {}
692 
693     function setTokenBurner(address _tokenBurner) onlyOwner {
694         tokenBurner = TokenBurner(_tokenBurner);
695     }
696 
697     // allows a token holder to burn tokens
698     // requires tokenBurner to be set to a valid contract address
699     // tokenBurner can take any appropriate action
700     function burn(uint256 _amount) {
701         uint256 curTotalSupply = totalSupply();
702         require(curTotalSupply >= _amount);
703         uint256 previousBalanceFrom = balanceOf(msg.sender);
704         require(previousBalanceFrom >= _amount);
705         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
706         updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
707         assert(tokenBurner.burn(msg.sender, _amount));
708         Transfer(msg.sender, 0, _amount);
709     }
710 
711 }
712 
713 contract Milestones is Ownable {
714 
715     enum State { PreIco, IcoOpen, IcoClosed, IcoSuccessful, IcoFailed, BankLicenseSuccessful, BankLicenseFailed }
716 
717     event Milestone(string _announcement, State _state);
718 
719     State public state = State.PreIco;
720     bool public tradingOpen = false;
721 
722     modifier inState(State _state) {
723         require(state == _state);
724         _;
725     }
726 
727     modifier isTradingOpen() {
728         require(tradingOpen);
729         _;
730     }
731 
732     function Milestone_OpenTheIco(string _announcement) onlyOwner inState(State.PreIco) {
733         state = State.IcoOpen;
734         Milestone(_announcement, state);
735     }
736 
737     function Milestone_CloseTheIco(string _announcement) onlyOwner inState(State.IcoOpen) {
738         state = State.IcoClosed;
739         Milestone(_announcement, state);
740     }
741 
742     function Milestone_IcoSuccessful(string _announcement) onlyOwner inState(State.IcoClosed) {
743         state = State.IcoSuccessful;
744         Milestone(_announcement, state);
745     }
746 
747     function Milestone_IcoFailed(string _announcement) onlyOwner inState(State.IcoClosed) {
748         state = State.IcoFailed;
749         Milestone(_announcement, state);
750     }
751 
752     function Milestone_BankLicenseSuccessful(string _announcement) onlyOwner inState(State.IcoSuccessful) {
753         tradingOpen = true;
754         state = State.BankLicenseSuccessful;
755         Milestone(_announcement, state);
756     }
757 
758     function Milestone_BankLicenseFailed(string _announcement) onlyOwner inState(State.IcoSuccessful) {
759         state = State.BankLicenseFailed;
760         Milestone(_announcement, state);
761     }
762 
763 }
764 
765 contract Investors is Milestones {
766 
767     struct WhitelistEntry {
768         uint256 max;
769         uint256 total;
770         bool init;
771     }
772 
773     mapping(address => bool) internal admins;
774     mapping(address => WhitelistEntry) approvedInvestors;
775 
776     modifier onlyAdmins() {
777         require(admins[msg.sender] == true);
778         _;
779     }
780 
781     function manageInvestors(address _investors_wallet_address, uint256 _max_approved_investment) onlyAdmins {
782         if(approvedInvestors[_investors_wallet_address].init){
783             approvedInvestors[_investors_wallet_address].max = SafeMath.mul(_max_approved_investment, 10 ** 18); // ETH to WEI
784             // clean up
785             if(approvedInvestors[_investors_wallet_address].max == 0 && approvedInvestors[_investors_wallet_address].total == 0)
786             delete approvedInvestors[_investors_wallet_address];
787         }
788         else{
789             approvedInvestors[_investors_wallet_address] = WhitelistEntry(SafeMath.mul(_max_approved_investment, 10 ** 18), 0, true);
790         }
791     }
792 
793     function manageAdmins(address _address, bool _add) onlyOwner {
794         admins[_address] = _add;
795     }
796 
797 }
798 
799 contract FiinuCrowdSale is TokenController, Investors {
800     using SafeMath for uint256;
801 
802     event Investment(address indexed _investor, uint256 _valueEth, uint256 _valueFnu);
803     event RefundAdded(address indexed _refunder, uint256 _valueEth);
804     event RefundEnabled(uint256 _valueEth);
805 
806     address wallet;
807     address public staff_1 = 0x2717FCee32b2896E655Ad82EfF81987A34EFF3E7;
808     address public staff_2 = 0x7ee4471C371e581Af42b280CD19Ed7593BD7D15F;
809     address public staff_3 = 0xE6BeCcc43b48416CE69B6d03c2e44E2B7b8F77b4;
810     address public staff_4 = 0x3369De7Ff98bd5C225a67E09ac81aFa7b5dF3d3d;
811 
812     uint256 constant minRaisedWei = 20000 ether;
813     uint256 constant targetRaisedWei = 100000 ether;
814     uint256 constant maxRaisedWei = 400000 ether;
815     uint256 public raisedWei = 0;
816     uint256 public refundWei = 0;
817 
818     bool public refundOpen = false;
819 
820     MiniMeToken public tokenContract;   // The new token for this Campaign
821 
822     function FiinuCrowdSale(address _wallet, address _tokenAddress) {
823         wallet = _wallet; // multi sig wallet
824         tokenContract = MiniMeToken(_tokenAddress);// The Deployed Token Contract
825     }
826 
827     /////////////////
828     // TokenController interface
829     /////////////////
830 
831     /// @notice `proxyPayment()` returns false, meaning ether is not accepted at
832     ///  the token address, only the address of FiinuCrowdSale
833     /// @param _owner The address that will hold the newly created tokens
834 
835     function proxyPayment(address _owner) payable returns(bool) {
836         return false;
837     }
838 
839     /// @notice Notifies the controller about a transfer, for this Campaign all
840     ///  transfers are allowed by default and no extra notifications are needed
841     /// @param _from The origin of the transfer
842     /// @param _to The destination of the transfer
843     /// @param _amount The amount of the transfer
844     /// @return False if the controller does not authorize the transfer
845     function onTransfer(address _from, address _to, uint256 _amount) returns(bool) {
846         return tradingOpen;
847     }
848 
849     /// @notice Notifies the controller about an approval, for this Campaign all
850     ///  approvals are allowed by default and no extra notifications are needed
851     /// @param _owner The address that calls `approve()`
852     /// @param _spender The spender in the `approve()` call
853     /// @param _amount The amount in the `approve()` call
854     /// @return False if the controller does not authorize the approval
855     function onApprove(address _owner, address _spender, uint256 _amount)
856     returns(bool)
857     {
858         return true;
859     }
860 
861     function weiToFNU(uint256 _wei) public constant returns (uint){
862         uint256 _return;
863         // 1 FNU = 0.75 ETH
864         if(state == State.PreIco){
865             _return = _wei.add(_wei.div(3));
866         }
867         else {
868             // 1 FNU = 1 ETH
869             if(raisedWei < targetRaisedWei){
870                 _return = _wei;
871             } else {
872                 // 1 FNU = raisedWei / targetRaisedWei
873                 _return = _wei.mul(targetRaisedWei).div(raisedWei);
874             }
875         }
876         // WEI to FNU
877         return _return.div(10 ** 12);
878     }
879 
880     function () payable { // incoming investment in the state of PreIco or IcoOpen
881 
882         require(msg.value != 0); // incoming transaction must have value
883         require(state == State.PreIco || state == State.IcoOpen);
884         require(approvedInvestors[msg.sender].init == true); // is approved investor
885         require(approvedInvestors[msg.sender].max >= approvedInvestors[msg.sender].total.add(msg.value)); // investment is not breaching max approved investment amount
886         require(maxRaisedWei >= raisedWei.add(msg.value)); // investment is not breaching max raising limit
887 
888         uint256 _fnu = weiToFNU(msg.value);
889         require(_fnu > 0);
890 
891         raisedWei = raisedWei.add(msg.value);
892         approvedInvestors[msg.sender].total = approvedInvestors[msg.sender].total.add(msg.value); // increase total invested
893         mint(msg.sender, _fnu); // Mint the tokens
894         wallet.transfer(msg.value); // Move ETH to multi sig wallet
895         Investment(msg.sender, msg.value, _fnu); // Announce investment
896     }
897 
898     function refund() payable {
899         require(msg.value != 0); // incoming transaction must have value
900         require(state == State.IcoClosed || state == State.IcoSuccessful || state == State.IcoFailed || state == State.BankLicenseFailed);
901         refundWei = refundWei.add(msg.value);
902         RefundAdded(msg.sender, msg.value);
903     }
904 
905     function Milestone_IcoSuccessful(string _announcement) onlyOwner {
906         require(raisedWei >= minRaisedWei);
907         uint256 _toBeAllocated = tokenContract.totalSupply();
908         _toBeAllocated = _toBeAllocated.div(10);
909         mint(staff_1, _toBeAllocated.mul(81).div(100)); // 81%
910         mint(staff_2, _toBeAllocated.mul(9).div(100)); // 9%
911         mint(staff_3, _toBeAllocated.mul(15).div(1000));  // 1.5%
912         mint(staff_4, _toBeAllocated.mul(15).div(1000)); // 1.5%
913         mint(owner, _toBeAllocated.mul(7).div(100)); // 7%
914         super.Milestone_IcoSuccessful(_announcement);
915     }
916 
917     function Milestone_IcoFailed(string _announcement) onlyOwner {
918         require(raisedWei < minRaisedWei);
919         super.Milestone_IcoFailed(_announcement);
920     }
921 
922     function Milestone_BankLicenseFailed(string _announcement) onlyOwner {
923         // remove staff allocations
924         burn(staff_1);
925         burn(staff_2);
926         burn(staff_3);
927         burn(staff_4);
928         burn(owner);
929         super.Milestone_BankLicenseFailed(_announcement);
930     }
931 
932     function EnableRefund() onlyOwner {
933         require(state == State.IcoFailed || state == State.BankLicenseFailed);
934         require(refundWei > 0);
935         refundOpen = true;
936         RefundEnabled(refundWei);
937     }
938 
939     // handle automatic refunds
940     function RequestRefund() public {
941         require(refundOpen);
942         require(state == State.IcoFailed || state == State.BankLicenseFailed);
943         require(tokenContract.balanceOf(msg.sender) > 0); // you must have some FNU to request refund
944         // refund prorata against your ETH investment
945         uint256 refundAmount = refundWei.mul(approvedInvestors[msg.sender].total).div(raisedWei);
946         burn(msg.sender);
947         msg.sender.transfer(refundAmount);
948     }
949 
950     // minting possible only if State.PreIco and State.IcoOpen for () payable or State.IcoClosed for investFIAT()
951     function mint(address _to, uint256 _tokens) internal {
952         tokenContract.generateTokens(_to, _tokens);
953     }
954 
955     // burning only in State.ICOcompleted for Milestone_BankLicenseFailed() or State.BankLicenseFailed for RequestRefund()
956     function burn(address _address) internal {
957         tokenContract.destroyTokens(_address, tokenContract.balanceOf(_address));
958     }
959 }
960 
961 contract ProfitSharing is Ownable {
962     using SafeMath for uint256;
963 
964     event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
965     event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
966     event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
967 
968     MiniMeToken public token;
969 
970     uint256 public RECYCLE_TIME = 1 years;
971 
972     struct Dividend {
973         uint256 blockNumber;
974         uint256 timestamp;
975         uint256 amount;
976         uint256 claimedAmount;
977         uint256 totalSupply;
978         bool recycled;
979         mapping (address => bool) claimed;
980     }
981 
982     Dividend[] public dividends;
983 
984     mapping (address => uint256) dividendsClaimed;
985 
986     modifier validDividendIndex(uint256 _dividendIndex) {
987         require(_dividendIndex < dividends.length);
988         _;
989     }
990 
991     function ProfitSharing(address _token) {
992         token = MiniMeToken(_token);
993     }
994 
995     function depositDividend() payable
996     onlyOwner
997     {
998         uint256 currentSupply = token.totalSupplyAt(block.number);
999         uint256 dividendIndex = dividends.length;
1000         uint256 blockNumber = SafeMath.sub(block.number, 1);
1001         dividends.push(
1002             Dividend(
1003                 blockNumber,
1004                 getNow(),
1005                 msg.value,
1006                 0,
1007                 currentSupply,
1008                 false
1009             )
1010         );
1011         DividendDeposited(msg.sender, blockNumber, msg.value, currentSupply, dividendIndex);
1012     }
1013 
1014     function claimDividend(uint256 _dividendIndex) public
1015     validDividendIndex(_dividendIndex)
1016     {
1017         Dividend storage dividend = dividends[_dividendIndex];
1018         require(dividend.claimed[msg.sender] == false);
1019         require(dividend.recycled == false);
1020         uint256 balance = token.balanceOfAt(msg.sender, dividend.blockNumber);
1021         uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
1022         dividend.claimed[msg.sender] = true;
1023         dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
1024         if (claim > 0) {
1025             msg.sender.transfer(claim);
1026             DividendClaimed(msg.sender, _dividendIndex, claim);
1027         }
1028     }
1029 
1030     function claimDividendAll() public {
1031         require(dividendsClaimed[msg.sender] < dividends.length);
1032         for (uint256 i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
1033             if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
1034                 dividendsClaimed[msg.sender] = SafeMath.add(i, 1);
1035                 claimDividend(i);
1036             }
1037         }
1038     }
1039 
1040     function recycleDividend(uint256 _dividendIndex) public
1041     onlyOwner
1042     validDividendIndex(_dividendIndex)
1043     {
1044         Dividend storage dividend = dividends[_dividendIndex];
1045         require(dividend.recycled == false);
1046         require(dividend.timestamp < SafeMath.sub(getNow(), RECYCLE_TIME));
1047         dividends[_dividendIndex].recycled = true;
1048         uint256 currentSupply = token.totalSupplyAt(block.number);
1049         uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
1050         uint256 dividendIndex = dividends.length;
1051         uint256 blockNumber = SafeMath.sub(block.number, 1);
1052         dividends.push(
1053             Dividend(
1054                 blockNumber,
1055                 getNow(),
1056                 remainingAmount,
1057                 0,
1058                 currentSupply,
1059                 false
1060             )
1061         );
1062         DividendRecycled(msg.sender, blockNumber, remainingAmount, currentSupply, dividendIndex);
1063     }
1064 
1065     //Function is mocked for tests
1066     function getNow() internal constant returns (uint256) {
1067         return now;
1068     }
1069 
1070 }