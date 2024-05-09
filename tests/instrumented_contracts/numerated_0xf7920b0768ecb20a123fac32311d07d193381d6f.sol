1 pragma solidity ^0.4.13;
2 
3 contract ApproveAndCallReceiver {
4     function receiveApproval(
5         address _from, 
6         uint256 _amount, 
7         address _token, 
8         bytes _data
9     );
10 }
11 
12 contract Controlled {
13     /// @notice The address of the controller is the only address that can call
14     ///  a function with this modifier
15     modifier onlyController { 
16         require(msg.sender == controller); 
17         _; 
18     }
19 
20     //block for check//bool private initialed = false;
21     address public controller;
22 
23     function Controlled() {
24       //block for check//require(!initialed);
25       controller = msg.sender;
26       //block for check//initialed = true;
27     }
28 
29     /// @notice Changes the controller of the contract
30     /// @param _newController The new controller of the contract
31     function changeController(address _newController) onlyController {
32         controller = _newController;
33     }
34 }
35 
36 contract ERC20Token {
37     /* This is a slight change to the ERC20 base standard.
38       function totalSupply() constant returns (uint256 supply);
39       is replaced with:
40       uint256 public totalSupply;
41       This automatically creates a getter function for the totalSupply.
42       This is moved to the base contract since public getter functions are not
43       currently recognised as an implementation of the matching abstract
44       function by the compiler.
45     */
46     /// total amount of tokens
47     function totalSupply() constant returns (uint256 balance);
48 
49     /// @param _owner The address from which the balance will be retrieved
50     /// @return The balance
51     function balanceOf(address _owner) constant returns (uint256 balance);
52 
53     /// @notice send `_value` token to `_to` from `msg.sender`
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transfer(address _to, uint256 _value) returns (bool success);
58 
59     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
60     /// @param _from The address of the sender
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
65 
66     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @param _value The amount of tokens to be approved for transfer
69     /// @return Whether the approval was successful or not
70     function approve(address _spender, uint256 _value) returns (bool success);
71 
72     /// @param _owner The address of the account owning tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 contract TNBTokenI is ERC20Token, Controlled {
82 
83     string public name;                //The Token's name: e.g. DigixDAO Tokens
84     uint8 public decimals;             //Number of decimals of the smallest unit
85     string public symbol;              //An identifier: e.g. REP
86     string public version = "MMT_0.1"; //An arbitrary versioning scheme
87 
88 ///////////////////
89 // ERC20 Methods
90 ///////////////////
91 
92     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
93     ///  its behalf, and then a function is triggered in the contract that is
94     ///  being approved, `_spender`. This allows users to use their tokens to
95     ///  interact with contracts in one function call instead of two
96     /// @param _spender The address of the contract able to transfer the tokens
97     /// @param _amount The amount of tokens to be approved for transfer
98     /// @return True if the function call was successful
99     function approveAndCall(
100         address _spender,
101         uint256 _amount,
102         bytes _extraData
103     ) returns (bool success);
104 
105 ////////////////
106 // Query balance and totalSupply in History
107 ////////////////
108 
109     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
110     /// @param _owner The address from which the balance will be retrieved
111     /// @param _blockNumber The block number when the balance is queried
112     /// @return The balance at `_blockNumber`
113     function balanceOfAt(
114         address _owner,
115         uint _blockNumber
116     ) constant returns (uint);
117 
118     /// @notice Total amount of tokens at a specific `_blockNumber`.
119     /// @param _blockNumber The block number when the totalSupply is queried
120     /// @return The total amount of tokens at `_blockNumber`
121     function totalSupplyAt(uint _blockNumber) constant returns(uint);
122 
123 ////////////////
124 // Generate and destroy tokens
125 ////////////////
126 
127     /// @notice Generates `_amount` tokens that are assigned to `_owner`
128     /// @param _owner The address that will be assigned the new tokens
129     /// @param _amount The quantity of tokens generated
130     /// @return True if the tokens are generated correctly
131     function generateTokens(address _owner, uint _amount) returns (bool);
132 
133 
134     /// @notice Burns `_amount` tokens from `_owner`
135     /// @param _owner The address that will lose the tokens
136     /// @param _amount The quantity of tokens to burn
137     /// @return True if the tokens are burned correctly
138     function destroyTokens(address _owner, uint _amount) returns (bool);
139 
140 ////////////////
141 // Enable tokens transfers
142 ////////////////
143 
144     /// @notice Enables token holders to transfer their tokens freely if true
145     /// @param _transfersEnabled True if transfers are allowed in the clone
146     function enableTransfers(bool _transfersEnabled);
147 
148 //////////
149 // Safety Methods
150 //////////
151 
152     /// @notice This method can be used by the controller to extract mistakenly
153     ///  sent tokens to this contract.
154     /// @param _token The address of the token contract that you want to recover
155     ///  set to 0 in case you want to extract ether.
156     function claimTokens(address _token);
157 
158 ////////////////
159 // Events
160 ////////////////
161 
162     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
163 }
164 
165 contract TNBToken is TNBTokenI {
166 
167     string public name;                //代币名称: e.g. DigixDAO Tokens
168     uint8 public decimals;             //最小单位精度，即可以精确到小数点后多少位
169     string public symbol;              //符号
170     string public version = "TNB_0.2"; //任意格式的版本数据
171     uint256 public maximumTNB = 60 * 10**8 * 10**18;
172     /// @dev `Checkpoint` 是一个记录区块数及其对应总额的结构
173     struct Checkpoint {
174 
175         // `fromBlock` is the block number that the value was generated from
176         uint128 fromBlock;
177 
178         // `value` is the amount of tokens at a specific block number
179         uint128 value;
180     }
181 
182     // `creationBlock` is the block number that the Clone Token was created
183     uint public creationBlock;
184 
185     // `balances` is the map that tracks the balance of each address, in this
186     //  contract when the balance changes the block number that the change
187     //  occurred is also included in the map
188     mapping (address => Checkpoint[]) balances;
189 
190     //禁售数量
191     mapping (address => uint256) frozen;
192     bool public isFrozen = false;
193     //每次解禁时间点
194     uint[] forbidenEndTime;
195 
196     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
197     mapping (address => mapping (address => uint256)) allowed;
198 
199     // Tracks the history of the `totalSupply` of the token
200     Checkpoint[] totalSupplyHistory;
201 
202     // Flag that determines if the token is transferable or not.
203     bool public transfersEnabled;
204 
205 
206 ////////////////
207 // Constructor
208 ////////////////
209 
210     /// @notice Constructor to create a TNBToken
211     ///  param _tokenFactory The address of the TNBTokenFactory contract that
212     ///  will create the Clone token contracts, the token factory needs to be
213     ///  deployed first
214     /// param _parentToken Address of the parent token, set to 0x0 if it is a
215     ///  new token
216     /// param _parentSnapShotBlock Block of the parent token that will
217     ///  determine the initial distribution of the clone token, set to 0 if it
218     ///  is a new token
219     /// @param _tokenName Name of the new token
220     /// @param _decimalUnits Number of decimals of the new token
221     /// @param _tokenSymbol Token Symbol for the new token
222     /// @param _transfersEnabled If true, tokens will be able to be transferred
223     function TNBToken(
224         //address _tokenFactory,
225         //address _parentToken,
226         //uint _parentSnapShotBlock,
227         string _tokenName,
228         uint8 _decimalUnits,
229         string _tokenSymbol,
230         bool _transfersEnabled
231     ) {
232         name = _tokenName;                                 // Set the name
233         decimals = _decimalUnits;                          // Set the decimals
234         symbol = _tokenSymbol;                             // Set the symbol
235         transfersEnabled = _transfersEnabled;
236         creationBlock = block.number;
237     }
238 
239 ///////////////////
240 // ERC20 Methods
241 ///////////////////
242 
243     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
244     /// @param _to The address of the recipient
245     /// @param _amount The amount of tokens to be transferred
246     /// @return Whether the transfer was successful or not
247     function transfer(address _to, uint256 _amount) returns (bool success) {
248         require(transfersEnabled);
249         return doTransfer(msg.sender, _to, _amount);
250     }
251 
252     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
253     ///  is approved by `_from`
254     /// @param _from The address holding the tokens being transferred
255     /// @param _to The address of the recipient
256     /// @param _amount The amount of tokens to be transferred
257     /// @return True if the transfer was successful
258     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
259 
260         // The controller of this contract can move tokens around at will,
261         //  this is important to recognize! Confirm that you trust the
262         //  controller of this contract, which in most situations should be
263         //  another open source smart contract or 0x0
264         if (msg.sender != controller) {
265             require(transfersEnabled);
266 
267             // The standard ERC 20 transferFrom functionality
268             if (allowed[_from][msg.sender] < _amount) {
269                 return false;
270             }
271             allowed[_from][msg.sender] -= _amount;
272         }
273         return doTransfer(_from, _to, _amount);
274     }
275 
276     /// @dev This is the actual transfer function in the token contract, it can
277     ///  only be called by other functions in this contract.
278     /// @param _from The address holding the tokens being transferred
279     /// @param _to The address of the recipient
280     /// @param _amount The amount of tokens to be transferred
281     /// @return True if the transfer was successful
282     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
283 
284         if (_amount == 0) {
285             return true;
286         }
287 
288         //require(parentSnapShotBlock < block.number);
289 
290         // Do not allow transfer to 0x0 or the token contract itself
291         require((_to != 0) && (_to != address(this)));
292 
293         // If the amount being transfered is more than the balance of the
294         //  account the transfer returns false
295         var previousBalanceFrom = balanceOfAt(_from, block.number);
296         if (previousBalanceFrom < _amount) {
297             return false;
298         }
299 
300         // Alerts the token controller of the transfer
301         if (isContract(controller)) {
302             bool onTransfer = TokenController(controller).onTransfer(_from, _to, _amount);
303             require(onTransfer);
304         }
305 
306         // First update the balance array with the new value for the address
307         //  sending the tokens
308         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
309 
310         // Then update the balance array with the new value for the address
311         //  receiving the tokens
312         var previousBalanceTo = balanceOfAt(_to, block.number);
313         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
314         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
315 
316         // An event to make the transfer easy to find on the blockchain
317         Transfer(_from, _to, _amount);
318 
319         return true;
320     }
321 
322     /// @param _owner The address that's balance is being requested
323     /// @return The balance of `_owner` at the current block
324     function balanceOf(address _owner) constant returns (uint256 balance) {
325         return balanceOfAt(_owner, block.number);
326     }
327 
328     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
329     ///  its behalf. This is a modified version of the ERC20 approve function
330     ///  to be a little bit safer
331     /// @param _spender The address of the account able to transfer the tokens
332     /// @param _amount The amount of tokens to be approved for transfer
333     /// @return True if the approval was successful
334     function approve(address _spender, uint256 _amount) returns (bool success) {
335         require(transfersEnabled);
336 
337         // To change the approve amount you first have to reduce the addresses`
338         //  allowance to zero by calling `approve(_spender,0)` if it is not
339         //  already 0 to mitigate the race condition described here:
340         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
341         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
342 
343         // Alerts the token controller of the approve function call
344         if (isContract(controller)) {
345             bool onApprove = TokenController(controller).onApprove(msg.sender, _spender, _amount);
346             require(onApprove);
347         }
348 
349         allowed[msg.sender][_spender] = _amount;
350         Approval(msg.sender, _spender, _amount);
351         return true;
352     }
353 
354     /// @dev This function makes it easy to read the `allowed[]` map
355     /// @param _owner The address of the account that owns the token
356     /// @param _spender The address of the account able to transfer the tokens
357     /// @return Amount of remaining tokens of _owner that _spender is allowed
358     ///  to spend
359     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
360         return allowed[_owner][_spender];
361     }
362 
363     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
364     ///  its behalf, and then a function is triggered in the contract that is
365     ///  being approved, `_spender`. This allows users to use their tokens to
366     ///  interact with contracts in one function call instead of two
367     /// @param _spender The address of the contract able to transfer the tokens
368     /// @param _amount The amount of tokens to be approved for transfer
369     /// @return True if the function call was successful
370     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
371         require(approve(_spender, _amount));
372 
373         ApproveAndCallReceiver(_spender).receiveApproval(
374             msg.sender,
375             _amount,
376             this,
377             _extraData
378         );
379 
380         return true;
381     }
382 
383     /// @dev This function makes it easy to get the total number of tokens
384     /// @return The total number of tokens
385     function totalSupply() constant returns (uint) {
386         return totalSupplyAt(block.number);
387     }
388 
389 ////////////////
390 // Query balance and totalSupply in History
391 ////////////////
392 
393     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
394     /// @param _owner The address from which the balance will be retrieved
395     /// @param _blockNumber The block number when the balance is queried
396     /// @return The balance at `_blockNumber`
397     function balanceOfAt(address _owner, uint _blockNumber) constant returns (uint) {
398 
399         // These next few lines are used when the balance of the token is
400         //  requested before a check point was ever created for this token, it
401         //  requires that the `parentToken.balanceOfAt` be queried at the
402         //  genesis block for that token as this contains initial balance of
403         //  this token
404         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
405             //if (address(parentToken) != 0) {
406             //    return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
407             //} else {
408                 // Has no parent
409                 return 0;
410             //}
411 
412         // This will return the expected balance during normal situations
413         } else {
414             return getValueAt(balances[_owner], _blockNumber);
415         }
416     }
417 
418     /// @notice Total amount of tokens at a specific `_blockNumber`.
419     /// @param _blockNumber The block number when the totalSupply is queried
420     /// @return The total amount of tokens at `_blockNumber`
421     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
422 
423         // These next few lines are used when the totalSupply of the token is
424         //  requested before a check point was ever created for this token, it
425         //  requires that the `parentToken.totalSupplyAt` be queried at the
426         //  genesis block for this token as that contains totalSupply of this
427         //  token at this block number.
428         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
429             //if (address(parentToken) != 0) {
430             //    return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
431             //} else {
432                 return 0;
433             //}
434 
435         // This will return the expected totalSupply during normal situations
436         } else {
437             return getValueAt(totalSupplyHistory, _blockNumber);
438         }
439     }
440 
441 ////////////////
442 // Generate and destroy tokens
443 ////////////////
444 
445     /// @notice Generates `_amount` tokens that are assigned to `_owner`
446     /// @param _owner The address that will be assigned the new tokens
447     /// @param _amount The quantity of tokens generated
448     /// @return True if the tokens are generated correctly
449     function generateTokens(address _owner, uint _amount) onlyController returns (bool) {
450         uint curTotalSupply = totalSupply();
451         uint256 newTotalSupply = curTotalSupply + _amount;
452         require(newTotalSupply >= curTotalSupply); // Check for overflow
453         require(newTotalSupply <= maximumTNB);
454         uint previousBalanceTo = balanceOf(_owner);
455         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
456         updateValueAtNow(totalSupplyHistory, newTotalSupply);
457         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
458         Transfer(0, _owner, _amount);
459         return true;
460     }
461 
462     /// @notice Burns `_amount` tokens from `_owner`
463     /// @param _owner The address that will lose the tokens
464     /// @param _amount The quantity of tokens to burn
465     /// @return True if the tokens are burned correctly
466     function destroyTokens(address _owner, uint _amount) onlyController returns (bool) {
467         uint curTotalSupply = totalSupply();
468         require(curTotalSupply >= _amount);
469         uint previousBalanceFrom = balanceOf(_owner);
470         require(previousBalanceFrom >= _amount);
471         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
472         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
473         Transfer(_owner, 0, _amount);
474         return true;
475     }
476 
477 ////////////////
478 // Enable tokens transfers
479 ////////////////
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
495     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
496         if (checkpoints.length == 0) {
497             return 0;
498         }
499 
500         // Shortcut for the actual value
501         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
502             return checkpoints[checkpoints.length-1].value;
503         if (_block < checkpoints[0].fromBlock) {
504             return 0;
505         }
506 
507         // Binary search of the value in the array
508         uint min = 0;
509         uint max = checkpoints.length-1;
510         while (max > min) {
511             uint mid = (max + min + 1) / 2;
512             if (checkpoints[mid].fromBlock<=_block) {
513                 min = mid;
514             } else {
515                 max = mid-1;
516             }
517         }
518         return checkpoints[min].value;
519     }
520 
521     /// @dev `updateValueAtNow` used to update the `balances` map and the
522     ///  `totalSupplyHistory`
523     /// @param checkpoints The history of data being updated
524     /// @param _value The new number of tokens
525     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
526         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
527             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
528             newCheckPoint.fromBlock = uint128(block.number);
529             newCheckPoint.value = uint128(_value);
530         } else {
531             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
532             oldCheckPoint.value = uint128(_value);
533         }
534     }
535 
536     /// @dev Internal function to determine if an address is a contract
537     /// @param _addr The address being queried
538     /// @return True if `_addr` is a contract
539     function isContract(address _addr) constant internal returns(bool) {
540         uint size;
541         if (_addr == 0) {
542             return false;
543         }
544         assembly {
545             size := extcodesize(_addr)
546         }
547         return size>0;
548     }
549 
550     /// @dev Helper function to return a min betwen the two uints
551     function min(uint a, uint b) internal returns (uint) {
552         return a < b ? a : b;
553     }
554 
555     /// @notice The fallback function: If the contract's controller has not been
556     ///  set to 0, then the `proxyPayment` method is called which relays the
557     ///  ether and creates tokens as described in the token controller contract
558     function ()  payable {
559         //屏蔽控制方的合约类型检查，以兼容发行方无控制合约的情况。
560         require(isContract(controller));
561         bool proxyPayment = TokenController(controller).proxyPayment.value(msg.value)(msg.sender);
562         require(proxyPayment);
563     }
564 
565 //////////
566 // Safety Methods
567 //////////
568 
569     /// @notice This method can be used by the controller to extract mistakenly
570     ///  sent tokens to this contract.
571     /// @param _token The address of the token contract that you want to recover
572     ///  set to 0 in case you want to extract ether.
573     function claimTokens(address _token) onlyController {
574         if (_token == 0x0) {
575             controller.transfer(this.balance);
576             return;
577         }
578 
579         TNBToken token = TNBToken(_token);
580         uint balance = token.balanceOf(this);
581         token.transfer(controller, balance);
582         ClaimedTokens(_token, controller, balance);
583     }
584 
585 ////////////////
586 // Events
587 ////////////////
588     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
589     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
590     event Approval(
591         address indexed _owner,
592         address indexed _spender,
593         uint256 _amount
594     );
595 }
596 
597 contract TokenController {
598     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
599     /// @param _owner The address that sent the ether to create tokens
600     /// @return True if the ether is accepted, false if it throws
601     function proxyPayment(address _owner) payable returns(bool);
602 
603     /// @notice Notifies the controller about a token transfer allowing the
604     ///  controller to react if desired
605     /// @param _from The origin of the transfer
606     /// @param _to The destination of the transfer
607     /// @param _amount The amount of the transfer
608     /// @return False if the controller does not authorize the transfer
609     function onTransfer(address _from, address _to, uint _amount) returns(bool);
610 
611     /// @notice Notifies the controller about an approval allowing the
612     ///  controller to react if desired
613     /// @param _owner The address that calls `approve()`
614     /// @param _spender The spender in the `approve()` call
615     /// @param _amount The amount in the `approve()` call
616     /// @return False if the controller does not authorize the approval
617     function onApprove(address _owner, address _spender, uint _amount) returns(bool);
618 }