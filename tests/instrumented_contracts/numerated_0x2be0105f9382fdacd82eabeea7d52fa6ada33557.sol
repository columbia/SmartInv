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
21 */
22 
23 library SafeMath {
24   function mul(uint a, uint b) internal returns (uint) {
25     uint c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint a, uint b) internal returns (uint) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint a, uint b) internal returns (uint) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint a, uint b) internal returns (uint) {
43     uint c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a >= b ? a : b;
50   }
51 
52   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a < b ? a : b;
54   }
55 
56   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a >= b ? a : b;
58   }
59 
60   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a < b ? a : b;
62   }
63 }
64 
65 contract Controlled {
66   /// @notice The address of the controller is the only address that can call
67   ///  a function with this modifier
68   modifier onlyController { if (msg.sender != controller) throw; _; }
69 
70   address public controller;
71 
72   function Controlled() { controller = msg.sender;}
73 
74   /// @notice Changes the controller of the contract
75   /// @param _newController The new controller of the contract
76   function changeController(address _newController) onlyController {
77     controller = _newController;
78   }
79 }
80 
81 contract Refundable {
82   function refund(address th, uint amount) returns (bool);
83 }
84 
85 /// @dev The token controller contract must implement these functions
86 contract TokenController {
87   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
88   /// @param _owner The address that sent the ether to create tokens
89   /// @return True if the ether is accepted, false if it throws
90   function proxyPayment(address _owner) payable returns(bool);
91 
92   /// @notice Notifies the controller about a token transfer allowing the
93   ///  controller to react if desired
94   /// @param _from The origin of the transfer
95   /// @param _to The destination of the transfer
96   /// @param _amount The amount of the transfer
97   /// @return False if the controller does not authorize the transfer
98   function onTransfer(address _from, address _to, uint _amount) returns(bool);
99 
100   /// @notice Notifies the controller about an approval allowing the
101   ///  controller to react if desired
102   /// @param _owner The address that calls `approve()`
103   /// @param _spender The spender in the `approve()` call
104   /// @param _amount The amount in the `approve()` call
105   /// @return False if the controller does not authorize the approval
106   function onApprove(address _owner, address _spender, uint _amount)
107     returns(bool);
108 }
109 
110 contract ERC20Token {
111   /* This is a slight change to the ERC20 base standard.
112      function totalSupply() constant returns (uint256 supply);
113      is replaced with:
114      uint256 public totalSupply;
115      This automatically creates a getter function for the totalSupply.
116      This is moved to the base contract since public getter functions are not
117      currently recognised as an implementation of the matching abstract
118      function by the compiler.
119   */
120   /// total amount of tokens
121   function totalSupply() constant returns (uint256 balance);
122 
123   /// @param _owner The address from which the balance will be retrieved
124   /// @return The balance
125   function balanceOf(address _owner) constant returns (uint256 balance);
126 
127   /// @notice send `_value` token to `_to` from `msg.sender`
128   /// @param _to The address of the recipient
129   /// @param _value The amount of token to be transferred
130   /// @return Whether the transfer was successful or not
131   function transfer(address _to, uint256 _value) returns (bool success);
132 
133   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
134   /// @param _from The address of the sender
135   /// @param _to The address of the recipient
136   /// @param _value The amount of token to be transferred
137   /// @return Whether the transfer was successful or not
138   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
139 
140   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
141   /// @param _spender The address of the account able to transfer the tokens
142   /// @param _value The amount of tokens to be approved for transfer
143   /// @return Whether the approval was successful or not
144   function approve(address _spender, uint256 _value) returns (bool success);
145 
146   /// @param _owner The address of the account owning tokens
147   /// @param _spender The address of the account able to transfer the tokens
148   /// @return Amount of remaining tokens allowed to spent
149   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
150 
151   event Transfer(address indexed _from, address indexed _to, uint256 _value);
152   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
153 }
154 
155 contract Burnable is Controlled {
156   /// @notice The address of the controller is the only address that can call
157   ///  a function with this modifier, also the burner can call but also the
158   /// target of the function must be the burner
159   modifier onlyControllerOrBurner(address target) {
160     assert(msg.sender == controller || (msg.sender == burner && msg.sender == target));
161     _;
162   }
163 
164   modifier onlyBurner {
165     assert(msg.sender == burner);
166     _;
167   }
168   address public burner;
169 
170   function Burnable() { burner = msg.sender;}
171 
172   /// @notice Changes the burner of the contract
173   /// @param _newBurner The new burner of the contract
174   function changeBurner(address _newBurner) onlyBurner {
175     burner = _newBurner;
176   }
177 }
178 
179 contract MiniMeTokenI is ERC20Token, Burnable {
180 
181       string public name;                //The Token's name: e.g. DigixDAO Tokens
182       uint8 public decimals;             //Number of decimals of the smallest unit
183       string public symbol;              //An identifier: e.g. REP
184       string public version = 'MMT_0.1'; //An arbitrary versioning scheme
185 
186 ///////////////////
187 // ERC20 Methods
188 ///////////////////
189 
190 
191     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
192     ///  its behalf, and then a function is triggered in the contract that is
193     ///  being approved, `_spender`. This allows users to use their tokens to
194     ///  interact with contracts in one function call instead of two
195     /// @param _spender The address of the contract able to transfer the tokens
196     /// @param _amount The amount of tokens to be approved for transfer
197     /// @return True if the function call was successful
198     function approveAndCall(
199         address _spender,
200         uint256 _amount,
201         bytes _extraData
202     ) returns (bool success);
203 
204 ////////////////
205 // Query balance and totalSupply in History
206 ////////////////
207 
208     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
209     /// @param _owner The address from which the balance will be retrieved
210     /// @param _blockNumber The block number when the balance is queried
211     /// @return The balance at `_blockNumber`
212     function balanceOfAt(
213         address _owner,
214         uint _blockNumber
215     ) constant returns (uint);
216 
217     /// @notice Total amount of tokens at a specific `_blockNumber`.
218     /// @param _blockNumber The block number when the totalSupply is queried
219     /// @return The total amount of tokens at `_blockNumber`
220     function totalSupplyAt(uint _blockNumber) constant returns(uint);
221 
222 ////////////////
223 // Clone Token Method
224 ////////////////
225 
226     /// @notice Creates a new clone token with the initial distribution being
227     ///  this token at `_snapshotBlock`
228     /// @param _cloneTokenName Name of the clone token
229     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
230     /// @param _cloneTokenSymbol Symbol of the clone token
231     /// @param _snapshotBlock Block when the distribution of the parent token is
232     ///  copied to set the initial distribution of the new clone token;
233     ///  if the block is zero than the actual block, the current block is used
234     /// @param _transfersEnabled True if transfers are allowed in the clone
235     /// @return The address of the new MiniMeToken Contract
236     function createCloneToken(
237         string _cloneTokenName,
238         uint8 _cloneDecimalUnits,
239         string _cloneTokenSymbol,
240         uint _snapshotBlock,
241         bool _transfersEnabled
242     ) returns(address);
243 
244 ////////////////
245 // Generate and destroy tokens
246 ////////////////
247 
248     /// @notice Generates `_amount` tokens that are assigned to `_owner`
249     /// @param _owner The address that will be assigned the new tokens
250     /// @param _amount The quantity of tokens generated
251     /// @return True if the tokens are generated correctly
252     function generateTokens(address _owner, uint _amount) returns (bool);
253 
254 
255     /// @notice Burns `_amount` tokens from `_owner`
256     /// @param _owner The address that will lose the tokens
257     /// @param _amount The quantity of tokens to burn
258     /// @return True if the tokens are burned correctly
259     function destroyTokens(address _owner, uint _amount) returns (bool);
260 
261 ////////////////
262 // Enable tokens transfers
263 ////////////////
264 
265     /// @notice Enables token holders to transfer their tokens freely if true
266     /// @param _transfersEnabled True if transfers are allowed in the clone
267     function enableTransfers(bool _transfersEnabled);
268 
269 //////////
270 // Safety Methods
271 //////////
272 
273     /// @notice This method can be used by the controller to extract mistakenly
274     ///  sent tokens to this contract.
275     /// @param _token The address of the token contract that you want to recover
276     ///  set to 0 in case you want to extract ether.
277     function claimTokens(address _token);
278 
279 ////////////////
280 // Events
281 ////////////////
282 
283     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
284     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
285 }
286 
287 contract Finalizable {
288   uint256 public finalizedBlock;
289   bool public goalMet;
290 
291   function finalize();
292 }
293 
294 contract Contribution is Controlled, TokenController, Finalizable {
295   using SafeMath for uint256;
296 
297   uint256 public totalSupplyCap; // Total MSP supply to be generated
298   uint256 public exchangeRate; // ETH-MSP exchange rate
299   uint256 public totalSold; // How much tokens sold
300   uint256 public totalSaleSupplyCap; // Token sale cap
301 
302   MiniMeTokenI public sit;
303   MiniMeTokenI public msp;
304 
305   uint256 public startBlock;
306   uint256 public endBlock;
307 
308   address public destEthDevs;
309   address public destTokensSit;
310   address public destTokensTeam;
311   address public destTokensReferals;
312 
313   address public mspController;
314 
315   uint256 public initializedBlock;
316   uint256 public finalizedTime;
317 
318   uint256 public minimum_investment;
319   uint256 public minimum_goal;
320 
321   bool public paused;
322 
323   modifier initialized() {
324     assert(address(msp) != 0x0);
325     _;
326   }
327 
328   modifier contributionOpen() {
329     assert(getBlockNumber() >= startBlock &&
330             getBlockNumber() <= endBlock &&
331             finalizedBlock == 0 &&
332             address(msp) != 0x0);
333     _;
334   }
335 
336   modifier notPaused() {
337     require(!paused);
338     _;
339   }
340 
341   function Contribution() {
342     // Booleans are false by default consider removing this
343     paused = false;
344   }
345 
346   /// @notice This method should be called by the controller before the contribution
347   ///  period starts This initializes most of the parameters
348   /// @param _msp Address of the MSP token contract
349   /// @param _mspController Token controller for the MSP that will be transferred after
350   ///  the contribution finalizes.
351   /// @param _totalSupplyCap Maximum amount of tokens to generate during the contribution
352   /// @param _exchangeRate ETH to MSP rate for the token sale
353   /// @param _startBlock Block when the contribution period starts
354   /// @param _endBlock The last block that the contribution period is active
355   /// @param _destEthDevs Destination address where the contribution ether is sent
356   /// @param _destTokensSit Address of the exchanger SIT-MSP where the MSP are sent
357   ///  to be distributed to the SIT holders.
358   /// @param _destTokensTeam Address where the tokens for the team are sent
359   /// @param _destTokensReferals Address where the tokens for the referal system are sent
360   /// @param _sit Address of the SIT token contract
361   function initialize(
362       address _msp,
363       address _mspController,
364 
365       uint256 _totalSupplyCap,
366       uint256 _exchangeRate,
367       uint256 _minimum_goal,
368 
369       uint256 _startBlock,
370       uint256 _endBlock,
371 
372       address _destEthDevs,
373       address _destTokensSit,
374       address _destTokensTeam,
375       address _destTokensReferals,
376 
377       address _sit
378   ) public onlyController {
379     // Initialize only once
380     assert(address(msp) == 0x0);
381 
382     msp = MiniMeTokenI(_msp);
383     assert(msp.totalSupply() == 0);
384     assert(msp.controller() == address(this));
385     assert(msp.decimals() == 18);  // Same amount of decimals as ETH
386 
387     require(_mspController != 0x0);
388     mspController = _mspController;
389 
390     require(_exchangeRate > 0);
391     exchangeRate = _exchangeRate;
392 
393     assert(_startBlock >= getBlockNumber());
394     require(_startBlock < _endBlock);
395     startBlock = _startBlock;
396     endBlock = _endBlock;
397 
398     require(_destEthDevs != 0x0);
399     destEthDevs = _destEthDevs;
400 
401     require(_destTokensSit != 0x0);
402     destTokensSit = _destTokensSit;
403 
404     require(_destTokensTeam != 0x0);
405     destTokensTeam = _destTokensTeam;
406 
407     require(_destTokensReferals != 0x0);
408     destTokensReferals = _destTokensReferals;
409 
410     require(_sit != 0x0);
411     sit = MiniMeTokenI(_sit);
412 
413     initializedBlock = getBlockNumber();
414     // SIT amount should be no more than 20% of MSP total supply cap
415     assert(sit.totalSupplyAt(initializedBlock) * 5 <= _totalSupplyCap);
416     totalSupplyCap = _totalSupplyCap;
417 
418     // We are going to sale 70% of total supply cap
419     totalSaleSupplyCap = percent(70).mul(_totalSupplyCap).div(percent(100));
420 
421     minimum_goal = _minimum_goal;
422   }
423 
424   function setMinimumInvestment(
425       uint _minimum_investment
426   ) public onlyController {
427     minimum_investment = _minimum_investment;
428   }
429 
430   function setExchangeRate(
431       uint _exchangeRate
432   ) public onlyController {
433     assert(getBlockNumber() < startBlock);
434     exchangeRate = _exchangeRate;
435   }
436 
437   /// @notice If anybody sends Ether directly to this contract, consider he is
438   ///  getting MSPs.
439   function () public payable notPaused {
440     proxyPayment(msg.sender);
441   }
442 
443 
444   //////////
445   // TokenController functions
446   //////////
447 
448   /// @notice This method will generally be called by the MSP token contract to
449   ///  acquire MSPs. Or directly from third parties that want to acquire MSPs in
450   ///  behalf of a token holder.
451   /// @param _th MSP holder where the MSPs will be minted.
452   function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
453     require(_th != 0x0);
454     doBuy(_th);
455     return true;
456   }
457 
458   function onTransfer(address, address, uint256) public returns (bool) {
459     return false;
460   }
461 
462   function onApprove(address, address, uint256) public returns (bool) {
463     return false;
464   }
465 
466   function doBuy(address _th) internal {
467     require(msg.value >= minimum_investment);
468 
469     // Antispam mechanism
470     address caller;
471     if (msg.sender == address(msp)) {
472       caller = _th;
473     } else {
474       caller = msg.sender;
475     }
476 
477     // Do not allow contracts to game the system
478     assert(!isContract(caller));
479 
480     uint256 toFund = msg.value;
481     uint256 leftForSale = tokensForSale();
482     if (toFund > 0) {
483       if (leftForSale > 0) {
484         uint256 tokensGenerated = toFund.mul(exchangeRate);
485 
486         // Check total supply cap reached, sell the all remaining tokens
487         if (tokensGenerated > leftForSale) {
488           tokensGenerated = leftForSale;
489           toFund = leftForSale.div(exchangeRate);
490         }
491 
492         assert(msp.generateTokens(_th, tokensGenerated));
493         totalSold = totalSold.add(tokensGenerated);
494         if (totalSold >= minimum_goal) {
495           goalMet = true;
496         }
497         destEthDevs.transfer(toFund);
498         NewSale(_th, toFund, tokensGenerated);
499       } else {
500         toFund = 0;
501       }
502     }
503 
504     uint256 toReturn = msg.value.sub(toFund);
505     if (toReturn > 0) {
506       // If the call comes from the Token controller,
507       // then we return it to the token Holder.
508       // Otherwise we return to the sender.
509       if (msg.sender == address(msp)) {
510         _th.transfer(toReturn);
511       } else {
512         msg.sender.transfer(toReturn);
513       }
514     }
515   }
516 
517   /// @dev Internal function to determine if an address is a contract
518   /// @param _addr The address being queried
519   /// @return True if `_addr` is a contract
520   function isContract(address _addr) constant internal returns (bool) {
521     if (_addr == 0) return false;
522     uint256 size;
523     assembly {
524       size := extcodesize(_addr)
525     }
526     return (size > 0);
527   }
528 
529   function refund() public {
530     require(finalizedBlock != 0);
531     require(!goalMet);
532 
533     uint256 amountTokens = msp.balanceOf(msg.sender);
534     require(amountTokens > 0);
535     uint256 amountEther = amountTokens.div(exchangeRate);
536     address th = msg.sender;
537 
538     Refundable(mspController).refund(th, amountTokens);
539     Refundable(destEthDevs).refund(th, amountEther);
540 
541     Refund(th, amountTokens, amountEther);
542   }
543 
544   event Refund(address _token_holder, uint256 _amount_tokens, uint256 _amount_ether);
545 
546   /// @notice This method will can be called by the controller before the contribution period
547   ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
548   ///  by creating the remaining tokens and transferring the controller to the configured
549   ///  controller.
550   function finalize() public initialized {
551     assert(getBlockNumber() >= startBlock);
552     assert(msg.sender == controller || getBlockNumber() > endBlock || tokensForSale() == 0);
553     require(finalizedBlock == 0);
554 
555     finalizedBlock = getBlockNumber();
556     finalizedTime = now;
557 
558     if (goalMet) {
559       // Generate 5% for the team
560       assert(msp.generateTokens(
561         destTokensTeam,
562         percent(5).mul(totalSupplyCap).div(percent(100))));
563 
564       // Generate 5% for the referal bonuses
565       assert(msp.generateTokens(
566         destTokensReferals,
567         percent(5).mul(totalSupplyCap).div(percent(100))));
568 
569       // Generate tokens for SIT exchanger
570       assert(msp.generateTokens(
571         destTokensSit,
572         sit.totalSupplyAt(initializedBlock)));
573     }
574 
575     msp.changeController(mspController);
576     Finalized();
577   }
578 
579   function percent(uint256 p) internal returns (uint256) {
580     return p.mul(10**16);
581   }
582 
583 
584   //////////
585   // Constant functions
586   //////////
587 
588   /// @return Total tokens issued in weis.
589   function tokensIssued() public constant returns (uint256) {
590     return msp.totalSupply();
591   }
592 
593   /// @return Total tokens availale for the sale in weis.
594   function tokensForSale() public constant returns(uint256) {
595     return totalSaleSupplyCap > totalSold ? totalSaleSupplyCap - totalSold : 0;
596   }
597 
598 
599   //////////
600   // Testing specific methods
601   //////////
602 
603   /// @notice This function is overridden by the test Mocks.
604   function getBlockNumber() internal constant returns (uint256) {
605     return block.number;
606   }
607 
608 
609   //////////
610   // Safety Methods
611   //////////
612 
613   /// @notice This method can be used by the controller to extract mistakenly
614   ///  sent tokens to this contract.
615   /// @param _token The address of the token contract that you want to recover
616   ///  set to 0 in case you want to extract ether.
617   function claimTokens(address _token) public onlyController {
618     if (msp.controller() == address(this)) {
619       msp.claimTokens(_token);
620     }
621     if (_token == 0x0) {
622       controller.transfer(this.balance);
623       return;
624     }
625 
626     ERC20Token token = ERC20Token(_token);
627     uint256 balance = token.balanceOf(this);
628     token.transfer(controller, balance);
629     ClaimedTokens(_token, controller, balance);
630   }
631 
632 
633   /// @notice Pauses the contribution if there is any issue
634   function pauseContribution() onlyController {
635     paused = true;
636   }
637 
638   /// @notice Resumes the contribution
639   function resumeContribution() onlyController {
640     paused = false;
641   }
642 
643   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
644   event NewSale(address indexed _th, uint256 _amount, uint256 _tokens);
645   event Finalized();
646 }
647 
648 /// @title SITExchanger Contract
649 /// @author Anton Egorov
650 /// @dev This contract will be used to distribute MSP between SIT holders.
651 ///  SIT token is not transferable, and we just keep an accounting between all tokens
652 ///  deposited and the tokens collected.
653 ///  The controllerShip of SIT should be transferred to this contract before the
654 ///  contribution period starts.
655 
656 contract SITExchanger is Controlled, TokenController {
657   using SafeMath for uint256;
658 
659   mapping (address => uint256) public collected;
660   uint256 public totalCollected;
661   MiniMeTokenI public sit;
662   MiniMeTokenI public msp;
663   Contribution public contribution;
664 
665   function SITExchanger(address _sit, address _msp, address _contribution) {
666     sit = MiniMeTokenI(_sit);
667     msp = MiniMeTokenI(_msp);
668     contribution = Contribution(_contribution);
669   }
670 
671   /// @notice This method should be called by the SIT holders to collect their
672   ///  corresponding MSPs
673   function collect() public {
674     // SIT sholder could collect MSP right after contribution started
675     assert(getBlockNumber() > contribution.startBlock());
676 
677     // Get current MSP ballance
678     uint256 balance = sit.balanceOfAt(msg.sender, contribution.initializedBlock());
679 
680     // And then subtract the amount already collected
681     uint256 amount = balance.sub(collected[msg.sender]);
682 
683     require(amount > 0);  // Notify the user that there are no tokens to exchange
684 
685     totalCollected = totalCollected.add(amount);
686     collected[msg.sender] = collected[msg.sender].add(amount);
687 
688     assert(msp.transfer(msg.sender, amount));
689 
690     TokensCollected(msg.sender, amount);
691   }
692 
693   function proxyPayment(address) public payable returns (bool) {
694     throw;
695   }
696 
697   function onTransfer(address, address, uint256) public returns (bool) {
698     return false;
699   }
700 
701   function onApprove(address, address, uint256) public returns (bool) {
702     return false;
703   }
704 
705   //////////
706   // Testing specific methods
707   //////////
708 
709   /// @notice This function is overridden by the test Mocks.
710   function getBlockNumber() internal constant returns (uint256) {
711     return block.number;
712   }
713 
714   //////////
715   // Safety Method
716   //////////
717 
718   /// @notice This method can be used by the controller to extract mistakenly
719   ///  sent tokens to this contract.
720   /// @param _token The address of the token contract that you want to recover
721   ///  set to 0 in case you want to extract ether.
722   function claimTokens(address _token) public onlyController {
723     assert(_token != address(msp));
724     if (_token == 0x0) {
725       controller.transfer(this.balance);
726       return;
727     }
728 
729     ERC20Token token = ERC20Token(_token);
730     uint256 balance = token.balanceOf(this);
731     token.transfer(controller, balance);
732     ClaimedTokens(_token, controller, balance);
733   }
734 
735   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
736   event TokensCollected(address indexed _holder, uint256 _amount);
737 
738 }