1 pragma solidity 0.4.15;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract TokenController {
48     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
49     /// @param _owner The address that sent the ether to create tokens
50     /// @return True if the ether is accepted, false if it throws
51     function proxyPayment(address _owner) payable returns(bool);
52 
53     /// @notice Notifies the controller about a token transfer allowing the
54     ///  controller to react if desired
55     /// @param _from The origin of the transfer
56     /// @param _to The destination of the transfer
57     /// @param _amount The amount of the transfer
58     /// @return False if the controller does not authorize the transfer
59     function onTransfer(address _from, address _to, uint _amount) returns(bool);
60 
61     /// @notice Notifies the controller about an approval allowing the
62     ///  controller to react if desired
63     /// @param _owner The address that calls `approve()`
64     /// @param _spender The spender in the `approve()` call
65     /// @param _amount The amount in the `approve()` call
66     /// @return False if the controller does not authorize the approval
67     function onApprove(address _owner, address _spender, uint _amount)
68         returns(bool);
69 }
70 
71 contract Controlled {
72     /// @notice The address of the controller is the only address that can call
73     ///  a function with this modifier
74     modifier onlyController { require(msg.sender == controller); _; }
75 
76     address public controller;
77 
78     function Controlled() { controller = msg.sender;}
79 
80     /// @notice Changes the controller of the contract
81     /// @param _newController The new controller of the contract
82     function changeController(address _newController) onlyController {
83         controller = _newController;
84     }
85 }
86 
87 contract ApproveAndCallFallBack {
88     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
89 }
90 
91 contract MiniMeToken is Controlled {
92 
93     string public name;                //The Token's name: e.g. DigixDAO Tokens
94     uint8 public decimals;             //Number of decimals of the smallest unit
95     string public symbol;              //An identifier: e.g. REP
96     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
97 
98 
99     /// @dev `Checkpoint` is the structure that attaches a block number to a
100     ///  given value, the block number attached is the one that last changed the
101     ///  value
102     struct  Checkpoint {
103 
104         // `fromBlock` is the block number that the value was generated from
105         uint128 fromBlock;
106 
107         // `value` is the amount of tokens at a specific block number
108         uint128 value;
109     }
110 
111     // `parentToken` is the Token address that was cloned to produce this token;
112     //  it will be 0x0 for a token that was not cloned
113     MiniMeToken public parentToken;
114 
115     // `parentSnapShotBlock` is the block number from the Parent Token that was
116     //  used to determine the initial distribution of the Clone Token
117     uint public parentSnapShotBlock;
118 
119     // `creationBlock` is the block number that the Clone Token was created
120     uint public creationBlock;
121 
122     // `balances` is the map that tracks the balance of each address, in this
123     //  contract when the balance changes the block number that the change
124     //  occurred is also included in the map
125     mapping (address => Checkpoint[]) balances;
126 
127     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
128     mapping (address => mapping (address => uint256)) allowed;
129 
130     // Tracks the history of the `totalSupply` of the token
131     Checkpoint[] totalSupplyHistory;
132 
133     // Flag that determines if the token is transferable or not.
134     bool public transfersEnabled;
135 
136     // The factory used to create new clone tokens
137     MiniMeTokenFactory public tokenFactory;
138 
139 ////////////////
140 // Constructor
141 ////////////////
142 
143     /// @notice Constructor to create a MiniMeToken
144     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
145     ///  will create the Clone token contracts, the token factory needs to be
146     ///  deployed first
147     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
148     ///  new token
149     /// @param _parentSnapShotBlock Block of the parent token that will
150     ///  determine the initial distribution of the clone token, set to 0 if it
151     ///  is a new token
152     /// @param _tokenName Name of the new token
153     /// @param _decimalUnits Number of decimals of the new token
154     /// @param _tokenSymbol Token Symbol for the new token
155     /// @param _transfersEnabled If true, tokens will be able to be transferred
156     function MiniMeToken(
157         address _tokenFactory,
158         address _parentToken,
159         uint _parentSnapShotBlock,
160         string _tokenName,
161         uint8 _decimalUnits,
162         string _tokenSymbol,
163         bool _transfersEnabled
164     ) {
165         tokenFactory = MiniMeTokenFactory(_tokenFactory);
166         name = _tokenName;                                 // Set the name
167         decimals = _decimalUnits;                          // Set the decimals
168         symbol = _tokenSymbol;                             // Set the symbol
169         parentToken = MiniMeToken(_parentToken);
170         parentSnapShotBlock = _parentSnapShotBlock;
171         transfersEnabled = _transfersEnabled;
172         creationBlock = block.number;
173     }
174 
175 
176 ///////////////////
177 // ERC20 Methods
178 ///////////////////
179 
180     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
181     /// @param _to The address of the recipient
182     /// @param _amount The amount of tokens to be transferred
183     /// @return Whether the transfer was successful or not
184     function transfer(address _to, uint256 _amount) returns (bool success) {
185         require(transfersEnabled);
186         return doTransfer(msg.sender, _to, _amount);
187     }
188 
189     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
190     ///  is approved by `_from`
191     /// @param _from The address holding the tokens being transferred
192     /// @param _to The address of the recipient
193     /// @param _amount The amount of tokens to be transferred
194     /// @return True if the transfer was successful
195     function transferFrom(address _from, address _to, uint256 _amount
196     ) returns (bool success) {
197 
198         // The controller of this contract can move tokens around at will,
199         //  this is important to recognize! Confirm that you trust the
200         //  controller of this contract, which in most situations should be
201         //  another open source smart contract or 0x0
202         if (msg.sender != controller) {
203             require(transfersEnabled);
204 
205             // The standard ERC 20 transferFrom functionality
206             if (allowed[_from][msg.sender] < _amount) return false;
207             allowed[_from][msg.sender] -= _amount;
208         }
209         return doTransfer(_from, _to, _amount);
210     }
211 
212     /// @dev This is the actual transfer function in the token contract, it can
213     ///  only be called by other functions in this contract.
214     /// @param _from The address holding the tokens being transferred
215     /// @param _to The address of the recipient
216     /// @param _amount The amount of tokens to be transferred
217     /// @return True if the transfer was successful
218     function doTransfer(address _from, address _to, uint _amount
219     ) internal returns(bool) {
220 
221            if (_amount == 0) {
222                return true;
223            }
224 
225            require(parentSnapShotBlock < block.number);
226 
227            // Do not allow transfer to 0x0 or the token contract itself
228            require((_to != 0) && (_to != address(this)));
229 
230            // If the amount being transfered is more than the balance of the
231            //  account the transfer returns false
232            var previousBalanceFrom = balanceOfAt(_from, block.number);
233            if (previousBalanceFrom < _amount) {
234                return false;
235            }
236 
237            // Alerts the token controller of the transfer
238            if (isContract(controller)) {
239                require(TokenController(controller).onTransfer(_from, _to, _amount));
240            }
241 
242            // First update the balance array with the new value for the address
243            //  sending the tokens
244            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
245 
246            // Then update the balance array with the new value for the address
247            //  receiving the tokens
248            var previousBalanceTo = balanceOfAt(_to, block.number);
249            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
250            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
251 
252            // An event to make the transfer easy to find on the blockchain
253            Transfer(_from, _to, _amount);
254 
255            return true;
256     }
257 
258     /// @param _owner The address that's balance is being requested
259     /// @return The balance of `_owner` at the current block
260     function balanceOf(address _owner) constant returns (uint256 balance) {
261         return balanceOfAt(_owner, block.number);
262     }
263 
264     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
265     ///  its behalf. This is a modified version of the ERC20 approve function
266     ///  to be a little bit safer
267     /// @param _spender The address of the account able to transfer the tokens
268     /// @param _amount The amount of tokens to be approved for transfer
269     /// @return True if the approval was successful
270     function approve(address _spender, uint256 _amount) returns (bool success) {
271         require(transfersEnabled);
272 
273         // To change the approve amount you first have to reduce the addresses`
274         //  allowance to zero by calling `approve(_spender,0)` if it is not
275         //  already 0 to mitigate the race condition described here:
276         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
278 
279         // Alerts the token controller of the approve function call
280         if (isContract(controller)) {
281             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
282         }
283 
284         allowed[msg.sender][_spender] = _amount;
285         Approval(msg.sender, _spender, _amount);
286         return true;
287     }
288 
289     /// @dev This function makes it easy to read the `allowed[]` map
290     /// @param _owner The address of the account that owns the token
291     /// @param _spender The address of the account able to transfer the tokens
292     /// @return Amount of remaining tokens of _owner that _spender is allowed
293     ///  to spend
294     function allowance(address _owner, address _spender
295     ) constant returns (uint256 remaining) {
296         return allowed[_owner][_spender];
297     }
298 
299     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
300     ///  its behalf, and then a function is triggered in the contract that is
301     ///  being approved, `_spender`. This allows users to use their tokens to
302     ///  interact with contracts in one function call instead of two
303     /// @param _spender The address of the contract able to transfer the tokens
304     /// @param _amount The amount of tokens to be approved for transfer
305     /// @return True if the function call was successful
306     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
307     ) returns (bool success) {
308         require(approve(_spender, _amount));
309 
310         ApproveAndCallFallBack(_spender).receiveApproval(
311             msg.sender,
312             _amount,
313             this,
314             _extraData
315         );
316 
317         return true;
318     }
319 
320     /// @dev This function makes it easy to get the total number of tokens
321     /// @return The total number of tokens
322     function totalSupply() constant returns (uint) {
323         return totalSupplyAt(block.number);
324     }
325 
326 
327 ////////////////
328 // Query balance and totalSupply in History
329 ////////////////
330 
331     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
332     /// @param _owner The address from which the balance will be retrieved
333     /// @param _blockNumber The block number when the balance is queried
334     /// @return The balance at `_blockNumber`
335     function balanceOfAt(address _owner, uint _blockNumber) constant
336         returns (uint) {
337 
338         // These next few lines are used when the balance of the token is
339         //  requested before a check point was ever created for this token, it
340         //  requires that the `parentToken.balanceOfAt` be queried at the
341         //  genesis block for that token as this contains initial balance of
342         //  this token
343         if ((balances[_owner].length == 0)
344             || (balances[_owner][0].fromBlock > _blockNumber)) {
345             if (address(parentToken) != 0) {
346                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
347             } else {
348                 // Has no parent
349                 return 0;
350             }
351 
352         // This will return the expected balance during normal situations
353         } else {
354             return getValueAt(balances[_owner], _blockNumber);
355         }
356     }
357 
358     /// @notice Total amount of tokens at a specific `_blockNumber`.
359     /// @param _blockNumber The block number when the totalSupply is queried
360     /// @return The total amount of tokens at `_blockNumber`
361     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
362 
363         // These next few lines are used when the totalSupply of the token is
364         //  requested before a check point was ever created for this token, it
365         //  requires that the `parentToken.totalSupplyAt` be queried at the
366         //  genesis block for this token as that contains totalSupply of this
367         //  token at this block number.
368         if ((totalSupplyHistory.length == 0)
369             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
370             if (address(parentToken) != 0) {
371                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
372             } else {
373                 return 0;
374             }
375 
376         // This will return the expected totalSupply during normal situations
377         } else {
378             return getValueAt(totalSupplyHistory, _blockNumber);
379         }
380     }
381 
382 ////////////////
383 // Clone Token Method
384 ////////////////
385 
386     /// @notice Creates a new clone token with the initial distribution being
387     ///  this token at `_snapshotBlock`
388     /// @param _cloneTokenName Name of the clone token
389     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
390     /// @param _cloneTokenSymbol Symbol of the clone token
391     /// @param _snapshotBlock Block when the distribution of the parent token is
392     ///  copied to set the initial distribution of the new clone token;
393     ///  if the block is zero than the actual block, the current block is used
394     /// @param _transfersEnabled True if transfers are allowed in the clone
395     /// @return The address of the new MiniMeToken Contract
396     function createCloneToken(
397         string _cloneTokenName,
398         uint8 _cloneDecimalUnits,
399         string _cloneTokenSymbol,
400         uint _snapshotBlock,
401         bool _transfersEnabled
402         ) returns(address) {
403         if (_snapshotBlock == 0) _snapshotBlock = block.number;
404         MiniMeToken cloneToken = tokenFactory.createCloneToken(
405             this,
406             _snapshotBlock,
407             _cloneTokenName,
408             _cloneDecimalUnits,
409             _cloneTokenSymbol,
410             _transfersEnabled
411             );
412 
413         cloneToken.changeController(msg.sender);
414 
415         // An event to make the token easy to find on the blockchain
416         NewCloneToken(address(cloneToken), _snapshotBlock);
417         return address(cloneToken);
418     }
419 
420 ////////////////
421 // Generate and destroy tokens
422 ////////////////
423 
424     /// @notice Generates `_amount` tokens that are assigned to `_owner`
425     /// @param _owner The address that will be assigned the new tokens
426     /// @param _amount The quantity of tokens generated
427     /// @return True if the tokens are generated correctly
428     function generateTokens(address _owner, uint _amount
429     ) onlyController returns (bool) {
430         uint curTotalSupply = totalSupply();
431         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
432         uint previousBalanceTo = balanceOf(_owner);
433         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
434         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
435         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
436         Transfer(0, _owner, _amount);
437         return true;
438     }
439 
440 
441     /// @notice Burns `_amount` tokens from `_owner`
442     /// @param _owner The address that will lose the tokens
443     /// @param _amount The quantity of tokens to burn
444     /// @return True if the tokens are burned correctly
445     function destroyTokens(address _owner, uint _amount
446     ) onlyController returns (bool) {
447         uint curTotalSupply = totalSupply();
448         require(curTotalSupply >= _amount);
449         uint previousBalanceFrom = balanceOf(_owner);
450         require(previousBalanceFrom >= _amount);
451         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
452         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
453         Transfer(_owner, 0, _amount);
454         return true;
455     }
456 
457 ////////////////
458 // Enable tokens transfers
459 ////////////////
460 
461 
462     /// @notice Enables token holders to transfer their tokens freely if true
463     /// @param _transfersEnabled True if transfers are allowed in the clone
464     function enableTransfers(bool _transfersEnabled) onlyController {
465         transfersEnabled = _transfersEnabled;
466     }
467 
468 ////////////////
469 // Internal helper functions to query and set a value in a snapshot array
470 ////////////////
471 
472     /// @dev `getValueAt` retrieves the number of tokens at a given block number
473     /// @param checkpoints The history of values being queried
474     /// @param _block The block number to retrieve the value at
475     /// @return The number of tokens being queried
476     function getValueAt(Checkpoint[] storage checkpoints, uint _block
477     ) constant internal returns (uint) {
478         if (checkpoints.length == 0) return 0;
479 
480         // Shortcut for the actual value
481         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
482             return checkpoints[checkpoints.length-1].value;
483         if (_block < checkpoints[0].fromBlock) return 0;
484 
485         // Binary search of the value in the array
486         uint min = 0;
487         uint max = checkpoints.length-1;
488         while (max > min) {
489             uint mid = (max + min + 1)/ 2;
490             if (checkpoints[mid].fromBlock<=_block) {
491                 min = mid;
492             } else {
493                 max = mid-1;
494             }
495         }
496         return checkpoints[min].value;
497     }
498 
499     /// @dev `updateValueAtNow` used to update the `balances` map and the
500     ///  `totalSupplyHistory`
501     /// @param checkpoints The history of data being updated
502     /// @param _value The new number of tokens
503     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
504     ) internal  {
505         if ((checkpoints.length == 0)
506         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
507                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
508                newCheckPoint.fromBlock =  uint128(block.number);
509                newCheckPoint.value = uint128(_value);
510            } else {
511                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
512                oldCheckPoint.value = uint128(_value);
513            }
514     }
515 
516     /// @dev Internal function to determine if an address is a contract
517     /// @param _addr The address being queried
518     /// @return True if `_addr` is a contract
519     function isContract(address _addr) constant internal returns(bool) {
520         uint size;
521         if (_addr == 0) return false;
522         assembly {
523             size := extcodesize(_addr)
524         }
525         return size>0;
526     }
527 
528     /// @dev Helper function to return a min betwen the two uints
529     function min(uint a, uint b) internal returns (uint) {
530         return a < b ? a : b;
531     }
532 
533     /// @notice The fallback function: If the contract's controller has not been
534     ///  set to 0, then the `proxyPayment` method is called which relays the
535     ///  ether and creates tokens as described in the token controller contract
536     function ()  payable {
537         require(isContract(controller));
538         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
539     }
540 
541 //////////
542 // Safety Methods
543 //////////
544 
545     /// @notice This method can be used by the controller to extract mistakenly
546     ///  sent tokens to this contract.
547     /// @param _token The address of the token contract that you want to recover
548     ///  set to 0 in case you want to extract ether.
549     function claimTokens(address _token) onlyController {
550         if (_token == 0x0) {
551             controller.transfer(this.balance);
552             return;
553         }
554 
555         MiniMeToken token = MiniMeToken(_token);
556         uint balance = token.balanceOf(this);
557         token.transfer(controller, balance);
558         ClaimedTokens(_token, controller, balance);
559     }
560 
561 ////////////////
562 // Events
563 ////////////////
564     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
565     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
566     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
567     event Approval(
568         address indexed _owner,
569         address indexed _spender,
570         uint256 _amount
571         );
572 
573 }
574 
575 contract MiniMeTokenFactory {
576 
577     /// @notice Update the DApp by creating a new token with new functionalities
578     ///  the msg.sender becomes the controller of this clone token
579     /// @param _parentToken Address of the token being cloned
580     /// @param _snapshotBlock Block of the parent token that will
581     ///  determine the initial distribution of the clone token
582     /// @param _tokenName Name of the new token
583     /// @param _decimalUnits Number of decimals of the new token
584     /// @param _tokenSymbol Token Symbol for the new token
585     /// @param _transfersEnabled If true, tokens will be able to be transferred
586     /// @return The address of the new token contract
587     function createCloneToken(
588         address _parentToken,
589         uint _snapshotBlock,
590         string _tokenName,
591         uint8 _decimalUnits,
592         string _tokenSymbol,
593         bool _transfersEnabled
594     ) returns (MiniMeToken) {
595         MiniMeToken newToken = new MiniMeToken(
596             this,
597             _parentToken,
598             _snapshotBlock,
599             _tokenName,
600             _decimalUnits,
601             _tokenSymbol,
602             _transfersEnabled
603             );
604 
605         newToken.changeController(msg.sender);
606         return newToken;
607     }
608 }
609 
610 contract MiniMeVestedToken is MiniMeToken {
611   using SafeMath for uint256;
612   using Math for uint64;
613 
614   struct TokenGrant {
615     address granter;     // 20 bytes
616     uint256 value;       // 32 bytes
617     uint64 cliff;
618     uint64 vesting;
619     uint64 start;        // 3 * 8 = 24 bytes
620     bool revokable;
621     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
622   } // total 78 bytes = 3 sstore per operation (32 per sstore)
623 
624   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
625 
626   mapping (address => TokenGrant[]) public grants;
627 
628   mapping (address => bool) public canCreateGrants;
629   address public vestingWhitelister;
630 
631   modifier canTransfer(address _sender, uint _value) {
632     require(spendableBalanceOf(_sender) >= _value);
633     _;
634   }
635 
636   modifier onlyVestingWhitelister {
637     require(msg.sender == vestingWhitelister);
638     _;
639   }
640 
641   function MiniMeVestedToken (
642       address _tokenFactory,
643       address _parentToken,
644       uint _parentSnapShotBlock,
645       string _tokenName,
646       uint8 _decimalUnits,
647       string _tokenSymbol,
648       bool _transfersEnabled
649   ) public
650     MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
651     vestingWhitelister = msg.sender;
652     doSetCanCreateGrants(vestingWhitelister, true);
653   }
654 
655   // @dev Add canTransfer modifier before allowing transfer and transferFrom to go through
656   function transfer(address _to, uint _value)
657            public
658            canTransfer(msg.sender, _value)
659            returns (bool success) {
660     return super.transfer(_to, _value);
661   }
662 
663   function transferFrom(address _from, address _to, uint _value)
664            public
665            canTransfer(_from, _value)
666            returns (bool success) {
667     return super.transferFrom(_from, _to, _value);
668   }
669 
670   function spendableBalanceOf(address _holder) public constant returns (uint) {
671     return transferableTokens(_holder, uint64(now)); // solhint-disable not-rely-on-time
672   }
673 
674   /**
675    * @dev Grant tokens to a specified address
676    * @param _to address The address which the tokens will be granted to.
677    * @param _value uint256 The amount of tokens to be granted.
678    * @param _start uint64 Time of the beginning of the grant.
679    * @param _cliff uint64 Time of the cliff period.
680    * @param _vesting uint64 The vesting period.
681    */
682   function grantVestedTokens(
683     address _to,
684     uint256 _value,
685     uint64 _start,
686     uint64 _cliff,
687     uint64 _vesting,
688     bool _revokable,
689     bool _burnsOnRevoke
690   ) public {
691     // Check start, cliff and vesting are properly order to ensure correct functionality of the formula.
692     require(_cliff >= _start);
693     require(_vesting >= _cliff);
694 
695     require(canCreateGrants[msg.sender]);
696     require(tokenGrantsCount(_to) < 20);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
697 
698     TokenGrant memory grant = TokenGrant(
699       _revokable ? msg.sender : 0,
700       _value,
701       _cliff,
702       _vesting,
703       _start,
704       _revokable,
705       _burnsOnRevoke
706     );
707 
708     uint256 count = grants[_to].push(grant);
709 
710     assert(transfer(_to, _value));
711 
712     NewTokenGrant(msg.sender, _to, _value, count - 1);
713   }
714 
715   function setCanCreateGrants(address _addr, bool _allowed)
716            public onlyVestingWhitelister {
717     doSetCanCreateGrants(_addr, _allowed);
718   }
719 
720   function changeVestingWhitelister(address _newWhitelister) public onlyVestingWhitelister {
721     require(_newWhitelister != 0);
722     doSetCanCreateGrants(vestingWhitelister, false);
723     vestingWhitelister = _newWhitelister;
724     doSetCanCreateGrants(vestingWhitelister, true);
725   }
726 
727   /**
728    * @dev Revoke the grant of tokens of a specifed address.
729    * @param _holder The address which will have its tokens revoked.
730    * @param _receiver Recipient of revoked tokens.
731    * @param _grantId The id of the token grant.
732    */
733   function revokeTokenGrant(address _holder, address _receiver, uint256 _grantId) public onlyVestingWhitelister {
734     require(_receiver != 0);
735 
736     TokenGrant storage grant = grants[_holder][_grantId];
737 
738     require(grant.revokable);
739     require(grant.granter == msg.sender); // Only granter can revoke it
740 
741     address receiver = grant.burnsOnRevoke ? 0xdead : _receiver;
742 
743     uint256 nonVested = nonVestedTokens(grant, uint64(now));
744 
745     // remove grant from array
746     delete grants[_holder][_grantId];
747     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
748     grants[_holder].length -= 1;
749 
750     doTransfer(_holder, receiver, nonVested);
751   }
752 
753   /**
754    * @dev Check the amount of grants that an address has.
755    * @param _holder The holder of the grants.
756    * @return A uint256 representing the total amount of grants.
757    */
758   function tokenGrantsCount(address _holder) public constant returns (uint index) {
759     return grants[_holder].length;
760   }
761 
762   /**
763    * @dev Get all information about a specific grant.
764    * @param _holder The address which will have its tokens revoked.
765    * @param _grantId The id of the token grant.
766    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
767    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
768    */
769   function tokenGrant(address _holder, uint256 _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
770     TokenGrant storage grant = grants[_holder][_grantId];
771 
772     granter = grant.granter;
773     value = grant.value;
774     start = grant.start;
775     cliff = grant.cliff;
776     vesting = grant.vesting;
777     revokable = grant.revokable;
778     burnsOnRevoke = grant.burnsOnRevoke;
779 
780     vested = vestedTokens(grant, uint64(now));
781   }
782 
783   // @dev The date in which all tokens are transferable for the holder
784   // Useful for displaying purposes (not used in any logic calculations)
785   function lastTokenIsTransferableDate(address holder) public constant returns (uint64 date) {
786     date = uint64(now);
787     uint256 grantIndex = tokenGrantsCount(holder);
788     for (uint256 i = 0; i < grantIndex; i++) {
789       date = grants[holder][i].vesting.max64(date);
790     }
791     return date;
792   }
793 
794   // @dev How many tokens can a holder transfer at a point in time
795   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
796     uint256 grantIndex = tokenGrantsCount(holder);
797 
798     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
799 
800     // Iterate through all the grants the holder has, and add all non-vested tokens
801     uint256 nonVested = 0;
802     for (uint256 i = 0; i < grantIndex; i++) {
803       nonVested = nonVested.add(nonVestedTokens(grants[holder][i], time));
804     }
805 
806     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
807     return balanceOf(holder).sub(nonVested);
808   }
809 
810   function doSetCanCreateGrants(address _addr, bool _allowed)
811            internal {
812     canCreateGrants[_addr] = _allowed;
813   }
814 
815   /**
816    * @dev Calculate amount of vested tokens at a specific time
817    * @param tokens uint256 The amount of tokens granted
818    * @param time uint64 The time to be checked
819    * @param start uint64 The time representing the beginning of the grant
820    * @param cliff uint64  The cliff period, the period before nothing can be paid out
821    * @param vesting uint64 The vesting period
822    * @return An uint256 representing the amount of vested tokens of a specific grant
823    *  transferableTokens
824    *   |                         _/--------   vestedTokens rect
825    *   |                       _/
826    *   |                     _/
827    *   |                   _/
828    *   |                 _/
829    *   |                /
830    *   |              .|
831    *   |            .  |
832    *   |          .    |
833    *   |        .      |
834    *   |      .        |
835    *   |    .          |
836    *   +===+===========+---------+----------> time
837    *      Start       Cliff    Vesting
838    */
839   function calculateVestedTokens(
840     uint256 tokens,
841     uint256 time,
842     uint256 start,
843     uint256 cliff,
844     uint256 vesting) internal constant returns (uint256)
845     {
846 
847     // Shortcuts for before cliff and after vesting cases.
848     if (time < cliff) return 0;
849     if (time >= vesting) return tokens;
850 
851     // Interpolate all vested tokens.
852     // As before cliff the shortcut returns 0, we can use just this function to
853     // calculate it.
854 
855     // vested = tokens * (time - start) / (vesting - start)
856     uint256 vested = tokens.mul(
857                              time.sub(start)
858                            ).div(vesting.sub(start));
859 
860     return vested;
861   }
862 
863   /**
864    * @dev Calculate the amount of non vested tokens at a specific time.
865    * @param grant TokenGrant The grant to be checked.
866    * @param time uint64 The time to be checked
867    * @return An uint256 representing the amount of non vested tokens of a specific grant on the
868    * passed time frame.
869    */
870   function nonVestedTokens(TokenGrant storage grant, uint64 time) internal constant returns (uint256) {
871     // Of all the tokens of the grant, how many of them are not vested?
872     // grantValue - vestedTokens
873     return grant.value.sub(vestedTokens(grant, time));
874   }
875 
876   /**
877    * @dev Get the amount of vested tokens at a specific time.
878    * @param grant TokenGrant The grant to be checked.
879    * @param time The time to be checked
880    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
881    */
882   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
883     return calculateVestedTokens(
884       grant.value,
885       uint256(time),
886       uint256(grant.start),
887       uint256(grant.cliff),
888       uint256(grant.vesting)
889     );
890   }
891 }
892 
893 contract BLT is MiniMeVestedToken {
894   function BLT(address _tokenFactory) public MiniMeVestedToken(
895     _tokenFactory,
896     0x0,           // no parent token
897     0,             // no snapshot block number from parent
898     "Bloom Token", // Token name
899     18,            // Decimals
900     "BLT",         // Symbol
901     true           // Enable transfers
902   ) {} // solhint-disable-line no-empty-blocks
903 }
904 
905 /**
906  * @title Ownable
907  * @dev The Ownable contract has an owner address, and provides basic authorization control
908  * functions, this simplifies the implementation of "user permissions".
909  */
910 contract Ownable {
911   address public owner;
912 
913 
914   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
915 
916 
917   /**
918    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
919    * account.
920    */
921   function Ownable() public {
922     owner = msg.sender;
923   }
924 
925   /**
926    * @dev Throws if called by any account other than the owner.
927    */
928   modifier onlyOwner() {
929     require(msg.sender == owner);
930     _;
931   }
932 
933   /**
934    * @dev Allows the current owner to transfer control of the contract to a newOwner.
935    * @param newOwner The address to transfer ownership to.
936    */
937   function transferOwnership(address newOwner) public onlyOwner {
938     require(newOwner != address(0));
939     OwnershipTransferred(owner, newOwner);
940     owner = newOwner;
941   }
942 
943 }
944 
945 /* Temporary controller for after sale */
946 contract PlaceholderController is TokenController, Ownable {
947   BLT public token;
948 
949   function PlaceholderController(address _blt) public {
950     token = BLT(_blt);
951   }
952 
953   function changeTokenController(address _newController) public onlyOwner {
954     token.changeController(_newController);
955   }
956 
957   // No buying tokens
958   function proxyPayment(address) public payable returns (bool) {
959     require(msg.value == 0);
960     return false;
961   }
962 
963   function onTransfer(address, address, uint) public returns (bool) {
964     return true;
965   }
966 
967   function onApprove(address, address, uint) public returns (bool) {
968     return true;
969   }
970 }