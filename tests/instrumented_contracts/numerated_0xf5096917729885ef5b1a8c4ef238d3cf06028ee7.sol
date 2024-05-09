1 pragma solidity ^0.4.11;
2 
3 /*
4   Copyright 2017, Anton Egorov (Mothership Foundation)
5   Copyright 2017, Klaus Hott (BlockchainLabs.nz)
6   Copyright 2017, Jorge Izquierdo (Aragon Foundation)
7   Copyright 2017, Jordi Baylina (Giveth)
8 
9   This program is free software: you can redistribute it and/or modify
10   it under the terms of the GNU General Public License as published by
11   the Free Software Foundation, either version 3 of the License, or
12   (at your option) any later version.
13 
14   This program is distributed in the hope that it will be useful,
15   but WITHOUT ANY WARRANTY; without even the implied warranty of
16   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17   GNU General Public License for more details.
18 
19   You should have received a copy of the GNU General Public License
20   along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 
22   Based on SampleCampaign-TokenController.sol from https://github.com/Giveth/minime
23   Original contract is https://github.com/status-im/status-network-token/blob/master/contracts/StatusContribution.sol
24 */
25 
26 library SafeMath {
27   function mul(uint a, uint b) internal returns (uint) {
28     uint c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint a, uint b) internal returns (uint) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint a, uint b) internal returns (uint) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint a, uint b) internal returns (uint) {
46     uint c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a >= b ? a : b;
53   }
54 
55   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
56     return a < b ? a : b;
57   }
58 
59   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a >= b ? a : b;
61   }
62 
63   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a < b ? a : b;
65   }
66 }
67 
68 contract Controlled {
69   /// @notice The address of the controller is the only address that can call
70   ///  a function with this modifier
71   modifier onlyController { if (msg.sender != controller) throw; _; }
72 
73   address public controller;
74 
75   function Controlled() { controller = msg.sender;}
76 
77   /// @notice Changes the controller of the contract
78   /// @param _newController The new controller of the contract
79   function changeController(address _newController) onlyController {
80     controller = _newController;
81   }
82 }
83 
84 contract Refundable {
85   function refund(address th, uint amount) returns (bool);
86 }
87 
88 /// @dev The token controller contract must implement these functions
89 contract TokenController {
90   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
91   /// @param _owner The address that sent the ether to create tokens
92   /// @return True if the ether is accepted, false if it throws
93   function proxyPayment(address _owner) payable returns(bool);
94 
95   /// @notice Notifies the controller about a token transfer allowing the
96   ///  controller to react if desired
97   /// @param _from The origin of the transfer
98   /// @param _to The destination of the transfer
99   /// @param _amount The amount of the transfer
100   /// @return False if the controller does not authorize the transfer
101   function onTransfer(address _from, address _to, uint _amount) returns(bool);
102 
103   /// @notice Notifies the controller about an approval allowing the
104   ///  controller to react if desired
105   /// @param _owner The address that calls `approve()`
106   /// @param _spender The spender in the `approve()` call
107   /// @param _amount The amount in the `approve()` call
108   /// @return False if the controller does not authorize the approval
109   function onApprove(address _owner, address _spender, uint _amount)
110     returns(bool);
111 }
112 
113 contract ERC20Token {
114   /* This is a slight change to the ERC20 base standard.
115      function totalSupply() constant returns (uint256 supply);
116      is replaced with:
117      uint256 public totalSupply;
118      This automatically creates a getter function for the totalSupply.
119      This is moved to the base contract since public getter functions are not
120      currently recognised as an implementation of the matching abstract
121      function by the compiler.
122   */
123   /// total amount of tokens
124   function totalSupply() constant returns (uint256 balance);
125 
126   /// @param _owner The address from which the balance will be retrieved
127   /// @return The balance
128   function balanceOf(address _owner) constant returns (uint256 balance);
129 
130   /// @notice send `_value` token to `_to` from `msg.sender`
131   /// @param _to The address of the recipient
132   /// @param _value The amount of token to be transferred
133   /// @return Whether the transfer was successful or not
134   function transfer(address _to, uint256 _value) returns (bool success);
135 
136   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
137   /// @param _from The address of the sender
138   /// @param _to The address of the recipient
139   /// @param _value The amount of token to be transferred
140   /// @return Whether the transfer was successful or not
141   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
142 
143   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
144   /// @param _spender The address of the account able to transfer the tokens
145   /// @param _value The amount of tokens to be approved for transfer
146   /// @return Whether the approval was successful or not
147   function approve(address _spender, uint256 _value) returns (bool success);
148 
149   /// @param _owner The address of the account owning tokens
150   /// @param _spender The address of the account able to transfer the tokens
151   /// @return Amount of remaining tokens allowed to spent
152   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
153 
154   event Transfer(address indexed _from, address indexed _to, uint256 _value);
155   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
156 }
157 
158 contract Burnable is Controlled {
159   /// @notice The address of the controller is the only address that can call
160   ///  a function with this modifier, also the burner can call but also the
161   /// target of the function must be the burner
162   modifier onlyControllerOrBurner(address target) {
163     assert(msg.sender == controller || (msg.sender == burner && msg.sender == target));
164     _;
165   }
166 
167   modifier onlyBurner {
168     assert(msg.sender == burner);
169     _;
170   }
171   address public burner;
172 
173   function Burnable() { burner = msg.sender;}
174 
175   /// @notice Changes the burner of the contract
176   /// @param _newBurner The new burner of the contract
177   function changeBurner(address _newBurner) onlyBurner {
178     burner = _newBurner;
179   }
180 }
181 
182 contract MiniMeTokenI is ERC20Token, Burnable {
183 
184       string public name;                //The Token's name: e.g. DigixDAO Tokens
185       uint8 public decimals;             //Number of decimals of the smallest unit
186       string public symbol;              //An identifier: e.g. REP
187       string public version = 'MMT_0.1'; //An arbitrary versioning scheme
188 
189 ///////////////////
190 // ERC20 Methods
191 ///////////////////
192 
193 
194     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
195     ///  its behalf, and then a function is triggered in the contract that is
196     ///  being approved, `_spender`. This allows users to use their tokens to
197     ///  interact with contracts in one function call instead of two
198     /// @param _spender The address of the contract able to transfer the tokens
199     /// @param _amount The amount of tokens to be approved for transfer
200     /// @return True if the function call was successful
201     function approveAndCall(
202         address _spender,
203         uint256 _amount,
204         bytes _extraData
205     ) returns (bool success);
206 
207 ////////////////
208 // Query balance and totalSupply in History
209 ////////////////
210 
211     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
212     /// @param _owner The address from which the balance will be retrieved
213     /// @param _blockNumber The block number when the balance is queried
214     /// @return The balance at `_blockNumber`
215     function balanceOfAt(
216         address _owner,
217         uint _blockNumber
218     ) constant returns (uint);
219 
220     /// @notice Total amount of tokens at a specific `_blockNumber`.
221     /// @param _blockNumber The block number when the totalSupply is queried
222     /// @return The total amount of tokens at `_blockNumber`
223     function totalSupplyAt(uint _blockNumber) constant returns(uint);
224 
225 ////////////////
226 // Clone Token Method
227 ////////////////
228 
229     /// @notice Creates a new clone token with the initial distribution being
230     ///  this token at `_snapshotBlock`
231     /// @param _cloneTokenName Name of the clone token
232     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
233     /// @param _cloneTokenSymbol Symbol of the clone token
234     /// @param _snapshotBlock Block when the distribution of the parent token is
235     ///  copied to set the initial distribution of the new clone token;
236     ///  if the block is zero than the actual block, the current block is used
237     /// @param _transfersEnabled True if transfers are allowed in the clone
238     /// @return The address of the new MiniMeToken Contract
239     function createCloneToken(
240         string _cloneTokenName,
241         uint8 _cloneDecimalUnits,
242         string _cloneTokenSymbol,
243         uint _snapshotBlock,
244         bool _transfersEnabled
245     ) returns(address);
246 
247 ////////////////
248 // Generate and destroy tokens
249 ////////////////
250 
251     /// @notice Generates `_amount` tokens that are assigned to `_owner`
252     /// @param _owner The address that will be assigned the new tokens
253     /// @param _amount The quantity of tokens generated
254     /// @return True if the tokens are generated correctly
255     function generateTokens(address _owner, uint _amount) returns (bool);
256 
257 
258     /// @notice Burns `_amount` tokens from `_owner`
259     /// @param _owner The address that will lose the tokens
260     /// @param _amount The quantity of tokens to burn
261     /// @return True if the tokens are burned correctly
262     function destroyTokens(address _owner, uint _amount) returns (bool);
263 
264 ////////////////
265 // Enable tokens transfers
266 ////////////////
267 
268     /// @notice Enables token holders to transfer their tokens freely if true
269     /// @param _transfersEnabled True if transfers are allowed in the clone
270     function enableTransfers(bool _transfersEnabled);
271 
272 //////////
273 // Safety Methods
274 //////////
275 
276     /// @notice This method can be used by the controller to extract mistakenly
277     ///  sent tokens to this contract.
278     /// @param _token The address of the token contract that you want to recover
279     ///  set to 0 in case you want to extract ether.
280     function claimTokens(address _token);
281 
282 ////////////////
283 // Events
284 ////////////////
285 
286     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
287     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
288 }
289 
290 contract Finalizable {
291   uint256 public finalizedBlock;
292   bool public goalMet;
293 
294   function finalize();
295 }
296 
297 contract Contribution is Controlled, TokenController, Finalizable {
298   using SafeMath for uint256;
299 
300   uint256 public totalSupplyCap; // Total MSP supply to be generated
301   uint256 public exchangeRate; // ETH-MSP exchange rate
302   uint256 public totalSold; // How much tokens sold
303   uint256 public totalSaleSupplyCap; // Token sale cap
304 
305   MiniMeTokenI public sit;
306   MiniMeTokenI public msp;
307 
308   uint256 public startBlock;
309   uint256 public endBlock;
310 
311   address public destEthDevs;
312   address public destTokensSit;
313   address public destTokensTeam;
314   address public destTokensReferals;
315 
316   address public mspController;
317 
318   uint256 public initializedBlock;
319   uint256 public finalizedTime;
320 
321   uint256 public minimum_investment;
322   uint256 public minimum_goal;
323 
324   bool public paused;
325 
326   modifier initialized() {
327     assert(address(msp) != 0x0);
328     _;
329   }
330 
331   modifier contributionOpen() {
332     assert(getBlockNumber() >= startBlock &&
333             getBlockNumber() <= endBlock &&
334             finalizedBlock == 0 &&
335             address(msp) != 0x0);
336     _;
337   }
338 
339   modifier notPaused() {
340     require(!paused);
341     _;
342   }
343 
344   function Contribution() {
345     // Booleans are false by default consider removing this
346     paused = false;
347   }
348 
349   /// @notice This method should be called by the controller before the contribution
350   ///  period starts This initializes most of the parameters
351   /// @param _msp Address of the MSP token contract
352   /// @param _mspController Token controller for the MSP that will be transferred after
353   ///  the contribution finalizes.
354   /// @param _totalSupplyCap Maximum amount of tokens to generate during the contribution
355   /// @param _exchangeRate ETH to MSP rate for the token sale
356   /// @param _startBlock Block when the contribution period starts
357   /// @param _endBlock The last block that the contribution period is active
358   /// @param _destEthDevs Destination address where the contribution ether is sent
359   /// @param _destTokensSit Address of the exchanger SIT-MSP where the MSP are sent
360   ///  to be distributed to the SIT holders.
361   /// @param _destTokensTeam Address where the tokens for the team are sent
362   /// @param _destTokensReferals Address where the tokens for the referal system are sent
363   /// @param _sit Address of the SIT token contract
364   function initialize(
365       address _msp,
366       address _mspController,
367 
368       uint256 _totalSupplyCap,
369       uint256 _exchangeRate,
370       uint256 _minimum_goal,
371 
372       uint256 _startBlock,
373       uint256 _endBlock,
374 
375       address _destEthDevs,
376       address _destTokensSit,
377       address _destTokensTeam,
378       address _destTokensReferals,
379 
380       address _sit
381   ) public onlyController {
382     // Initialize only once
383     assert(address(msp) == 0x0);
384 
385     msp = MiniMeTokenI(_msp);
386     assert(msp.totalSupply() == 0);
387     assert(msp.controller() == address(this));
388     assert(msp.decimals() == 18);  // Same amount of decimals as ETH
389 
390     require(_mspController != 0x0);
391     mspController = _mspController;
392 
393     require(_exchangeRate > 0);
394     exchangeRate = _exchangeRate;
395 
396     assert(_startBlock >= getBlockNumber());
397     require(_startBlock < _endBlock);
398     startBlock = _startBlock;
399     endBlock = _endBlock;
400 
401     require(_destEthDevs != 0x0);
402     destEthDevs = _destEthDevs;
403 
404     require(_destTokensSit != 0x0);
405     destTokensSit = _destTokensSit;
406 
407     require(_destTokensTeam != 0x0);
408     destTokensTeam = _destTokensTeam;
409 
410     require(_destTokensReferals != 0x0);
411     destTokensReferals = _destTokensReferals;
412 
413     require(_sit != 0x0);
414     sit = MiniMeTokenI(_sit);
415 
416     initializedBlock = getBlockNumber();
417     // SIT amount should be no more than 20% of MSP total supply cap
418     assert(sit.totalSupplyAt(initializedBlock) * 5 <= _totalSupplyCap);
419     totalSupplyCap = _totalSupplyCap;
420 
421     // We are going to sale 70% of total supply cap
422     totalSaleSupplyCap = percent(70).mul(_totalSupplyCap).div(percent(100));
423 
424     minimum_goal = _minimum_goal;
425   }
426 
427   function setMinimumInvestment(
428       uint _minimum_investment
429   ) public onlyController {
430     minimum_investment = _minimum_investment;
431   }
432 
433   function setExchangeRate(
434       uint _exchangeRate
435   ) public onlyController {
436     assert(getBlockNumber() < startBlock);
437     exchangeRate = _exchangeRate;
438   }
439 
440   /// @notice If anybody sends Ether directly to this contract, consider he is
441   ///  getting MSPs.
442   function () public payable notPaused {
443     proxyPayment(msg.sender);
444   }
445 
446 
447   //////////
448   // TokenController functions
449   //////////
450 
451   /// @notice This method will generally be called by the MSP token contract to
452   ///  acquire MSPs. Or directly from third parties that want to acquire MSPs in
453   ///  behalf of a token holder.
454   /// @param _th MSP holder where the MSPs will be minted.
455   function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
456     require(_th != 0x0);
457     doBuy(_th);
458     return true;
459   }
460 
461   function onTransfer(address, address, uint256) public returns (bool) {
462     return false;
463   }
464 
465   function onApprove(address, address, uint256) public returns (bool) {
466     return false;
467   }
468 
469   function doBuy(address _th) internal {
470     require(msg.value >= minimum_investment);
471 
472     // Antispam mechanism
473     address caller;
474     if (msg.sender == address(msp)) {
475       caller = _th;
476     } else {
477       caller = msg.sender;
478     }
479 
480     // Do not allow contracts to game the system
481     assert(!isContract(caller));
482 
483     uint256 toFund = msg.value;
484     uint256 leftForSale = tokensForSale();
485     if (toFund > 0) {
486       if (leftForSale > 0) {
487         uint256 tokensGenerated = toFund.mul(exchangeRate);
488 
489         // Check total supply cap reached, sell the all remaining tokens
490         if (tokensGenerated > leftForSale) {
491           tokensGenerated = leftForSale;
492           toFund = leftForSale.div(exchangeRate);
493         }
494 
495         assert(msp.generateTokens(_th, tokensGenerated));
496         totalSold = totalSold.add(tokensGenerated);
497         if (totalSold >= minimum_goal) {
498           goalMet = true;
499         }
500         destEthDevs.transfer(toFund);
501         NewSale(_th, toFund, tokensGenerated);
502       } else {
503         toFund = 0;
504       }
505     }
506 
507     uint256 toReturn = msg.value.sub(toFund);
508     if (toReturn > 0) {
509       // If the call comes from the Token controller,
510       // then we return it to the token Holder.
511       // Otherwise we return to the sender.
512       if (msg.sender == address(msp)) {
513         _th.transfer(toReturn);
514       } else {
515         msg.sender.transfer(toReturn);
516       }
517     }
518   }
519 
520   /// @dev Internal function to determine if an address is a contract
521   /// @param _addr The address being queried
522   /// @return True if `_addr` is a contract
523   function isContract(address _addr) constant internal returns (bool) {
524     if (_addr == 0) return false;
525     uint256 size;
526     assembly {
527       size := extcodesize(_addr)
528     }
529     return (size > 0);
530   }
531 
532   function refund() public {
533     require(finalizedBlock != 0);
534     require(!goalMet);
535 
536     uint256 amountTokens = msp.balanceOf(msg.sender);
537     require(amountTokens > 0);
538     uint256 amountEther = amountTokens.div(exchangeRate);
539     address th = msg.sender;
540 
541     Refundable(mspController).refund(th, amountTokens);
542     Refundable(destEthDevs).refund(th, amountEther);
543 
544     Refund(th, amountTokens, amountEther);
545   }
546 
547   event Refund(address _token_holder, uint256 _amount_tokens, uint256 _amount_ether);
548 
549   /// @notice This method will can be called by the controller before the contribution period
550   ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
551   ///  by creating the remaining tokens and transferring the controller to the configured
552   ///  controller.
553   function finalize() public initialized {
554     assert(getBlockNumber() >= startBlock);
555     assert(msg.sender == controller || getBlockNumber() > endBlock || tokensForSale() == 0);
556     require(finalizedBlock == 0);
557 
558     finalizedBlock = getBlockNumber();
559     finalizedTime = now;
560 
561     if (goalMet) {
562       // Generate 5% for the team
563       assert(msp.generateTokens(
564         destTokensTeam,
565         percent(5).mul(totalSupplyCap).div(percent(100))));
566 
567       // Generate 5% for the referal bonuses
568       assert(msp.generateTokens(
569         destTokensReferals,
570         percent(5).mul(totalSupplyCap).div(percent(100))));
571 
572       // Generate tokens for SIT exchanger
573       assert(msp.generateTokens(
574         destTokensSit,
575         sit.totalSupplyAt(initializedBlock)));
576     }
577 
578     msp.changeController(mspController);
579     Finalized();
580   }
581 
582   function percent(uint256 p) internal returns (uint256) {
583     return p.mul(10**16);
584   }
585 
586 
587   //////////
588   // Constant functions
589   //////////
590 
591   /// @return Total tokens issued in weis.
592   function tokensIssued() public constant returns (uint256) {
593     return msp.totalSupply();
594   }
595 
596   /// @return Total tokens availale for the sale in weis.
597   function tokensForSale() public constant returns(uint256) {
598     return totalSaleSupplyCap > totalSold ? totalSaleSupplyCap - totalSold : 0;
599   }
600 
601 
602   //////////
603   // Testing specific methods
604   //////////
605 
606   /// @notice This function is overridden by the test Mocks.
607   function getBlockNumber() internal constant returns (uint256) {
608     return block.number;
609   }
610 
611 
612   //////////
613   // Safety Methods
614   //////////
615 
616   /// @notice This method can be used by the controller to extract mistakenly
617   ///  sent tokens to this contract.
618   /// @param _token The address of the token contract that you want to recover
619   ///  set to 0 in case you want to extract ether.
620   function claimTokens(address _token) public onlyController {
621     if (msp.controller() == address(this)) {
622       msp.claimTokens(_token);
623     }
624     if (_token == 0x0) {
625       controller.transfer(this.balance);
626       return;
627     }
628 
629     ERC20Token token = ERC20Token(_token);
630     uint256 balance = token.balanceOf(this);
631     token.transfer(controller, balance);
632     ClaimedTokens(_token, controller, balance);
633   }
634 
635 
636   /// @notice Pauses the contribution if there is any issue
637   function pauseContribution() onlyController {
638     paused = true;
639   }
640 
641   /// @notice Resumes the contribution
642   function resumeContribution() onlyController {
643     paused = false;
644   }
645 
646   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
647   event NewSale(address indexed _th, uint256 _amount, uint256 _tokens);
648   event Finalized();
649 }