1 ///File: giveth-common-contracts/contracts/ERC20.sol
2 
3 pragma solidity ^0.4.19;
4 
5 
6 /**
7  * @title ERC20
8  * @dev A standard interface for tokens.
9  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
10  */
11 contract ERC20 {
12   
13     /// @dev Returns the total token supply
14     function totalSupply() public constant returns (uint256 supply);
15 
16     /// @dev Returns the account balance of the account with address _owner
17     function balanceOf(address _owner) public constant returns (uint256 balance);
18 
19     /// @dev Transfers _value number of tokens to address _to
20     function transfer(address _to, uint256 _value) public returns (bool success);
21 
22     /// @dev Transfers _value number of tokens from address _from to address _to
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
24 
25     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
26     function approve(address _spender, uint256 _value) public returns (bool success);
27 
28     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
29     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 
34 }
35 
36 
37 ///File: giveth-common-contracts/contracts/Owned.sol
38 
39 pragma solidity ^0.4.19;
40 
41 
42 /// @title Owned
43 /// @author Adrià Massanet <adria@codecontext.io>
44 /// @notice The Owned contract has an owner address, and provides basic 
45 ///  authorization control functions, this simplifies & the implementation of
46 ///  user permissions; this contract has three work flows for a change in
47 ///  ownership, the first requires the new owner to validate that they have the
48 ///  ability to accept ownership, the second allows the ownership to be
49 ///  directly transfered without requiring acceptance, and the third allows for
50 ///  the ownership to be removed to allow for decentralization 
51 contract Owned {
52 
53     address public owner;
54     address public newOwnerCandidate;
55 
56     event OwnershipRequested(address indexed by, address indexed to);
57     event OwnershipTransferred(address indexed from, address indexed to);
58     event OwnershipRemoved();
59 
60     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
61     function Owned() public {
62         owner = msg.sender;
63     }
64 
65     /// @dev `owner` is the only address that can call a function with this
66     /// modifier
67     modifier onlyOwner() {
68         require (msg.sender == owner);
69         _;
70     }
71     
72     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
73     ///  be called first by the current `owner` then `acceptOwnership()` must be
74     ///  called by the `newOwnerCandidate`
75     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
76     ///  new owner
77     /// @param _newOwnerCandidate The address being proposed as the new owner
78     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
79         newOwnerCandidate = _newOwnerCandidate;
80         OwnershipRequested(msg.sender, newOwnerCandidate);
81     }
82 
83     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
84     ///  transfer of ownership
85     function acceptOwnership() public {
86         require(msg.sender == newOwnerCandidate);
87 
88         address oldOwner = owner;
89         owner = newOwnerCandidate;
90         newOwnerCandidate = 0x0;
91 
92         OwnershipTransferred(oldOwner, owner);
93     }
94 
95     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
96     ///  be called and it will immediately assign ownership to the `newOwner`
97     /// @notice `owner` can step down and assign some other address to this role
98     /// @param _newOwner The address of the new owner
99     function changeOwnership(address _newOwner) public onlyOwner {
100         require(_newOwner != 0x0);
101 
102         address oldOwner = owner;
103         owner = _newOwner;
104         newOwnerCandidate = 0x0;
105 
106         OwnershipTransferred(oldOwner, owner);
107     }
108 
109     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
110     ///  be called and it will immediately assign ownership to the 0x0 address;
111     ///  it requires a 0xdece be input as a parameter to prevent accidental use
112     /// @notice Decentralizes the contract, this operation cannot be undone 
113     /// @param _dac `0xdac` has to be entered for this function to work
114     function removeOwnership(address _dac) public onlyOwner {
115         require(_dac == 0xdac);
116         owner = 0x0;
117         newOwnerCandidate = 0x0;
118         OwnershipRemoved();     
119     }
120 } 
121 
122 
123 ///File: giveth-common-contracts/contracts/Escapable.sol
124 
125 pragma solidity ^0.4.19;
126 /*
127     Copyright 2016, Jordi Baylina
128     Contributor: Adrià Massanet <adria@codecontext.io>
129 
130     This program is free software: you can redistribute it and/or modify
131     it under the terms of the GNU General Public License as published by
132     the Free Software Foundation, either version 3 of the License, or
133     (at your option) any later version.
134 
135     This program is distributed in the hope that it will be useful,
136     but WITHOUT ANY WARRANTY; without even the implied warranty of
137     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
138     GNU General Public License for more details.
139 
140     You should have received a copy of the GNU General Public License
141     along with this program.  If not, see <http://www.gnu.org/licenses/>.
142 */
143 
144 
145 
146 
147 
148 /// @dev `Escapable` is a base level contract built off of the `Owned`
149 ///  contract; it creates an escape hatch function that can be called in an
150 ///  emergency that will allow designated addresses to send any ether or tokens
151 ///  held in the contract to an `escapeHatchDestination` as long as they were
152 ///  not blacklisted
153 contract Escapable is Owned {
154     address public escapeHatchCaller;
155     address public escapeHatchDestination;
156     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
157 
158     /// @notice The Constructor assigns the `escapeHatchDestination` and the
159     ///  `escapeHatchCaller`
160     /// @param _escapeHatchCaller The address of a trusted account or contract
161     ///  to call `escapeHatch()` to send the ether in this contract to the
162     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
163     ///  cannot move funds out of `escapeHatchDestination`
164     /// @param _escapeHatchDestination The address of a safe location (usu a
165     ///  Multisig) to send the ether held in this contract; if a neutral address
166     ///  is required, the WHG Multisig is an option:
167     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
168     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
169         escapeHatchCaller = _escapeHatchCaller;
170         escapeHatchDestination = _escapeHatchDestination;
171     }
172 
173     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
174     ///  are the only addresses that can call a function with this modifier
175     modifier onlyEscapeHatchCallerOrOwner {
176         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
177         _;
178     }
179 
180     /// @notice Creates the blacklist of tokens that are not able to be taken
181     ///  out of the contract; can only be done at the deployment, and the logic
182     ///  to add to the blacklist will be in the constructor of a child contract
183     /// @param _token the token contract address that is to be blacklisted 
184     function blacklistEscapeToken(address _token) internal {
185         escapeBlacklist[_token] = true;
186         EscapeHatchBlackistedToken(_token);
187     }
188 
189     /// @notice Checks to see if `_token` is in the blacklist of tokens
190     /// @param _token the token address being queried
191     /// @return False if `_token` is in the blacklist and can't be taken out of
192     ///  the contract via the `escapeHatch()`
193     function isTokenEscapable(address _token) view public returns (bool) {
194         return !escapeBlacklist[_token];
195     }
196 
197     /// @notice The `escapeHatch()` should only be called as a last resort if a
198     /// security issue is uncovered or something unexpected happened
199     /// @param _token to transfer, use 0x0 for ether
200     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
201         require(escapeBlacklist[_token]==false);
202 
203         uint256 balance;
204 
205         /// @dev Logic for ether
206         if (_token == 0x0) {
207             balance = this.balance;
208             escapeHatchDestination.transfer(balance);
209             EscapeHatchCalled(_token, balance);
210             return;
211         }
212         /// @dev Logic for tokens
213         ERC20 token = ERC20(_token);
214         balance = token.balanceOf(this);
215         require(token.transfer(escapeHatchDestination, balance));
216         EscapeHatchCalled(_token, balance);
217     }
218 
219     /// @notice Changes the address assigned to call `escapeHatch()`
220     /// @param _newEscapeHatchCaller The address of a trusted account or
221     ///  contract to call `escapeHatch()` to send the value in this contract to
222     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
223     ///  cannot move funds out of `escapeHatchDestination`
224     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
225         escapeHatchCaller = _newEscapeHatchCaller;
226     }
227 
228     event EscapeHatchBlackistedToken(address token);
229     event EscapeHatchCalled(address token, uint amount);
230 }
231 
232 
233 ///File: ./contracts/lib/Pausable.sol
234 
235 pragma solidity ^0.4.21;
236 
237 
238 
239 /**
240  * @title Pausable
241  * @dev Base contract which allows children to implement an emergency stop mechanism.
242  */
243 contract Pausable is Owned {
244     event Pause();
245     event Unpause();
246 
247     bool public paused = false;
248 
249     /**
250     * @dev Modifier to make a function callable only when the contract is not paused.
251     */
252     modifier whenNotPaused() {
253         require(!paused);
254         _;
255     }
256 
257     /**
258     * @dev Modifier to make a function callable only when the contract is paused.
259     */
260     modifier whenPaused() {
261         require(paused);
262         _;
263     }
264 
265     /**
266     * @dev called by the owner to pause, triggers stopped state
267     */
268     function pause() onlyOwner whenNotPaused public {
269         paused = true;
270         emit Pause();
271     }
272 
273     /**
274     * @dev called by the owner to unpause, returns to normal state
275     */
276     function unpause() onlyOwner whenPaused public {
277         paused = false;
278         emit Unpause();
279     }
280 }
281 
282 ///File: ./contracts/lib/Vault.sol
283 
284 pragma solidity ^0.4.21;
285 
286 /*
287     Copyright 2018, Jordi Baylina, RJ Ewing
288 
289     This program is free software: you can redistribute it and/or modify
290     it under the terms of the GNU General Public License as published by
291     the Free Software Foundation, either version 3 of the License, or
292     (at your option) any later version.
293 
294     This program is distributed in the hope that it will be useful,
295     but WITHOUT ANY WARRANTY; without even the implied warranty of
296     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
297     GNU General Public License for more details.
298 
299     You should have received a copy of the GNU General Public License
300     along with this program.  If not, see <http://www.gnu.org/licenses/>.
301  */
302 
303 /// @title Vault Contract
304 /// @author Jordi Baylina, RJ Ewing
305 /// @notice This contract holds funds for Campaigns and automates payments. For
306 ///  this iteration the funds will come straight from the Giveth Multisig as a
307 ///  safety precaution, but once fully tested and optimized this contract will
308 ///  be a safe place to store funds equipped with optional variable time delays
309 ///  to allow for an optional escape hatch
310 
311 
312 
313 
314 /// @dev `Vault` is a higher level contract built off of the `Escapable`
315 ///  contract that holds funds for Campaigns and automates payments.
316 contract Vault is Escapable, Pausable {
317 
318     /// @dev `Payment` is a public structure that describes the details of
319     ///  each payment making it easy to track the movement of funds
320     ///  transparently
321     struct Payment {
322         string name;              // What is the purpose of this payment
323         bytes32 reference;        // Reference of the payment.
324         address spender;          // Who is sending the funds
325         uint earliestPayTime;     // The earliest a payment can be made (Unix Time)
326         bool canceled;            // If True then the payment has been canceled
327         bool paid;                // If True then the payment has been paid
328         address recipient;        // Who is receiving the funds
329         address token;            // Token this payment represents
330         uint amount;              // The amount of wei sent in the payment
331         uint securityGuardDelay;  // The seconds `securityGuard` can delay payment
332     }
333 
334     Payment[] public authorizedPayments;
335 
336     address public securityGuard;
337     uint public absoluteMinTimeLock;
338     uint public timeLock;
339     uint public maxSecurityGuardDelay;
340     bool public allowDisbursePaymentWhenPaused;
341 
342     /// @dev The white list of approved addresses allowed to set up && receive
343     ///  payments from this vault
344     mapping (address => bool) public allowedSpenders;
345 
346     // @dev Events to make the payment movements easy to find on the blockchain
347     event PaymentAuthorized(uint indexed idPayment, address indexed recipient, uint amount, address token, bytes32 reference);
348     event PaymentExecuted(uint indexed idPayment, address indexed recipient, uint amount, address token);
349     event PaymentCanceled(uint indexed idPayment);
350     event SpenderAuthorization(address indexed spender, bool authorized);
351 
352     /// @dev The address assigned the role of `securityGuard` is the only
353     ///  addresses that can call a function with this modifier
354     modifier onlySecurityGuard { 
355         require(msg.sender == securityGuard);
356         _;
357     }
358 
359     /// By default, we dis-allow payment disburements if the contract is paused.
360     /// However, to facilitate a migration of the bridge, we can allow
361     /// disbursements when paused if explicitly set
362     modifier disbursementsAllowed {
363         require(!paused || allowDisbursePaymentWhenPaused);
364         _;
365     }
366 
367     /// @notice The Constructor creates the Vault on the blockchain
368     /// @param _escapeHatchCaller The address of a trusted account or contract to
369     ///  call `escapeHatch()` to send the ether in this contract to the
370     ///  `escapeHatchDestination` it would be ideal if `escapeHatchCaller` cannot move
371     ///  funds out of `escapeHatchDestination`
372     /// @param _escapeHatchDestination The address of a safe location (usu a
373     ///  Multisig) to send the ether held in this contract in an emergency
374     /// @param _absoluteMinTimeLock The minimum number of seconds `timelock` can
375     ///  be set to, if set to 0 the `owner` can remove the `timeLock` completely
376     /// @param _timeLock Initial number of seconds that payments are delayed
377     ///  after they are authorized (a security precaution)
378     /// @param _securityGuard Address that will be able to delay the payments
379     ///  beyond the initial timelock requirements; can be set to 0x0 to remove
380     ///  the `securityGuard` functionality
381     /// @param _maxSecurityGuardDelay The maximum number of seconds in total
382     ///   that `securityGuard` can delay a payment so that the owner can cancel
383     ///   the payment if needed
384     function Vault(
385         address _escapeHatchCaller,
386         address _escapeHatchDestination,
387         uint _absoluteMinTimeLock,
388         uint _timeLock,
389         address _securityGuard,
390         uint _maxSecurityGuardDelay
391     ) Escapable(_escapeHatchCaller, _escapeHatchDestination) public
392     {
393         absoluteMinTimeLock = _absoluteMinTimeLock;
394         timeLock = _timeLock;
395         securityGuard = _securityGuard;
396         maxSecurityGuardDelay = _maxSecurityGuardDelay;
397     }
398 
399 /////////
400 // Helper functions
401 /////////
402 
403     /// @notice States the total number of authorized payments in this contract
404     /// @return The number of payments ever authorized even if they were canceled
405     function numberOfAuthorizedPayments() public view returns (uint) {
406         return authorizedPayments.length;
407     }
408 
409 ////////
410 // Spender Interface
411 ////////
412 
413     /// @notice only `allowedSpenders[]` Creates a new `Payment`
414     /// @param _name Brief description of the payment that is authorized
415     /// @param _reference External reference of the payment
416     /// @param _recipient Destination of the payment
417     /// @param _amount Amount to be paid in wei
418     /// @param _paymentDelay Number of seconds the payment is to be delayed, if
419     ///  this value is below `timeLock` then the `timeLock` determines the delay
420     /// @return The Payment ID number for the new authorized payment
421     function authorizePayment(
422         string _name,
423         bytes32 _reference,
424         address _recipient,
425         address _token,
426         uint _amount,
427         uint _paymentDelay
428     ) whenNotPaused external returns(uint) {
429 
430         // Fail if you arent on the `allowedSpenders` white list
431         require(allowedSpenders[msg.sender]);
432         uint idPayment = authorizedPayments.length;       // Unique Payment ID
433         authorizedPayments.length++;
434 
435         // The following lines fill out the payment struct
436         Payment storage p = authorizedPayments[idPayment];
437         p.spender = msg.sender;
438 
439         // Overflow protection
440         require(_paymentDelay <= 10**18);
441 
442         // Determines the earliest the recipient can receive payment (Unix time)
443         p.earliestPayTime = _paymentDelay >= timeLock ?
444                                 _getTime() + _paymentDelay :
445                                 _getTime() + timeLock;
446         p.recipient = _recipient;
447         p.amount = _amount;
448         p.name = _name;
449         p.reference = _reference;
450         p.token = _token;
451         emit PaymentAuthorized(idPayment, p.recipient, p.amount, p.token, p.reference);
452         return idPayment;
453     }
454 
455     /// Anyone can call this function to disburse the payment to 
456     ///  the recipient after `earliestPayTime` has passed
457     /// @param _idPayment The payment ID to be executed
458     function disburseAuthorizedPayment(uint _idPayment) disbursementsAllowed public {
459         // Check that the `_idPayment` has been added to the payments struct
460         require(_idPayment < authorizedPayments.length);
461 
462         Payment storage p = authorizedPayments[_idPayment];
463 
464         // Checking for reasons not to execute the payment
465         require(allowedSpenders[p.spender]);
466         require(_getTime() >= p.earliestPayTime);
467         require(!p.canceled);
468         require(!p.paid);
469 
470         p.paid = true; // Set the payment to being paid
471 
472         // Make the payment
473         if (p.token == 0) {
474             p.recipient.transfer(p.amount);
475         } else {
476             require(ERC20(p.token).transfer(p.recipient, p.amount));
477         }
478 
479         emit PaymentExecuted(_idPayment, p.recipient, p.amount, p.token);
480     }
481 
482     /// convience function to disburse multiple payments in a single tx
483     function disburseAuthorizedPayments(uint[] _idPayments) public {
484         for (uint i = 0; i < _idPayments.length; i++) {
485             uint _idPayment = _idPayments[i];
486             disburseAuthorizedPayment(_idPayment);
487         }
488     }
489 
490 /////////
491 // SecurityGuard Interface
492 /////////
493 
494     /// @notice `onlySecurityGuard` Delays a payment for a set number of seconds
495     /// @param _idPayment ID of the payment to be delayed
496     /// @param _delay The number of seconds to delay the payment
497     function delayPayment(uint _idPayment, uint _delay) onlySecurityGuard external {
498         require(_idPayment < authorizedPayments.length);
499 
500         // Overflow test
501         require(_delay <= 10**18);
502 
503         Payment storage p = authorizedPayments[_idPayment];
504 
505         require(p.securityGuardDelay + _delay <= maxSecurityGuardDelay);
506         require(!p.paid);
507         require(!p.canceled);
508 
509         p.securityGuardDelay += _delay;
510         p.earliestPayTime += _delay;
511     }
512 
513 ////////
514 // Owner Interface
515 ///////
516 
517     /// @notice `onlyOwner` Cancel a payment all together
518     /// @param _idPayment ID of the payment to be canceled.
519     function cancelPayment(uint _idPayment) onlyOwner external {
520         require(_idPayment < authorizedPayments.length);
521 
522         Payment storage p = authorizedPayments[_idPayment];
523 
524         require(!p.canceled);
525         require(!p.paid);
526 
527         p.canceled = true;
528         emit PaymentCanceled(_idPayment);
529     }
530 
531     /// @notice `onlyOwner` Adds a spender to the `allowedSpenders[]` white list
532     /// @param _spender The address of the contract being authorized/unauthorized
533     /// @param _authorize `true` if authorizing and `false` if unauthorizing
534     function authorizeSpender(address _spender, bool _authorize) onlyOwner external {
535         allowedSpenders[_spender] = _authorize;
536         emit SpenderAuthorization(_spender, _authorize);
537     }
538 
539     /// @notice `onlyOwner` Sets the address of `securityGuard`
540     /// @param _newSecurityGuard Address of the new security guard
541     function setSecurityGuard(address _newSecurityGuard) onlyOwner external {
542         securityGuard = _newSecurityGuard;
543     }
544 
545     /// @notice `onlyOwner` Changes `timeLock`; the new `timeLock` cannot be
546     ///  lower than `absoluteMinTimeLock`
547     /// @param _newTimeLock Sets the new minimum default `timeLock` in seconds;
548     ///  pending payments maintain their `earliestPayTime`
549     function setTimelock(uint _newTimeLock) onlyOwner external {
550         require(_newTimeLock >= absoluteMinTimeLock);
551         timeLock = _newTimeLock;
552     }
553 
554     /// @notice `onlyOwner` Changes the maximum number of seconds
555     /// `securityGuard` can delay a payment
556     /// @param _maxSecurityGuardDelay The new maximum delay in seconds that
557     ///  `securityGuard` can delay the payment's execution in total
558     function setMaxSecurityGuardDelay(uint _maxSecurityGuardDelay) onlyOwner external {
559         maxSecurityGuardDelay = _maxSecurityGuardDelay;
560     }
561 
562     /// @dev called by the owner to pause the contract. Triggers a stopped state 
563     ///  and resets allowDisbursePaymentWhenPaused to false
564     function pause() onlyOwner whenNotPaused public {
565         allowDisbursePaymentWhenPaused = false;
566         super.pause();
567     }
568 
569     /// Owner can allow payment disbursement when the contract is paused. This is so the
570     /// bridge can be upgraded without having to migrate any existing authorizedPayments
571     /// @dev only callable whenPaused b/c pausing the contract will reset `allowDisbursePaymentWhenPaused` to false
572     /// @param allowed `true` if allowing payments to be disbursed when paused, otherwise 'false'
573     function setAllowDisbursePaymentWhenPaused(bool allowed) onlyOwner whenPaused public {
574         allowDisbursePaymentWhenPaused = allowed;
575     }
576 
577     // for overidding during testing
578     function _getTime() internal view returns (uint) {
579         return now;
580     }
581 
582 }
583 
584 ///File: ./contracts/lib/FailClosedVault.sol
585 
586 pragma solidity ^0.4.21;
587 
588 /*
589     Copyright 2018, RJ Ewing
590 
591     This program is free software: you can redistribute it and/or modify
592     it under the terms of the GNU General Public License as published by
593     the Free Software Foundation, either version 3 of the License, or
594     (at your option) any later version.
595 
596     This program is distributed in the hope that it will be useful,
597     but WITHOUT ANY WARRANTY; without even the implied warranty of
598     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
599     GNU General Public License for more details.
600 
601     You should have received a copy of the GNU General Public License
602     along with this program.  If not, see <http://www.gnu.org/licenses/>.
603  */
604 
605 
606 
607 /**
608 * @dev `FailClosedVault` is a version of the vault that requires
609 *  the securityGuard to "see" each payment before it can be collected
610 */
611 contract FailClosedVault is Vault {
612     uint public securityGuardLastCheckin;
613 
614     /**
615     * @param _absoluteMinTimeLock For this version of the vault, it is recommended
616     *   that this value is > 24hrs. If not, it will require the securityGuard to checkIn
617     *   multiple times a day. Also consider that `securityGuardLastCheckin >= payment.earliestPayTime - timelock + 30mins);`
618     *   is the condition to allow payments to be payed. The additional 30 mins is to reduce (not eliminate)
619     *   the risk of front-running
620     */
621     function FailClosedVault(
622         address _escapeHatchCaller,
623         address _escapeHatchDestination,
624         uint _absoluteMinTimeLock,
625         uint _timeLock,
626         address _securityGuard,
627         uint _maxSecurityGuardDelay
628     ) Vault(
629         _escapeHatchCaller,
630         _escapeHatchDestination, 
631         _absoluteMinTimeLock,
632         _timeLock,
633         _securityGuard,
634         _maxSecurityGuardDelay
635     ) public {
636     }
637 
638 /////////////////////
639 // Spender Interface
640 /////////////////////
641 
642     /**
643     * Disburse an authorizedPayment to the recipient if all checks pass.
644     *
645     * @param _idPayment The payment ID to be disbursed
646     */
647     function disburseAuthorizedPayment(uint _idPayment) disbursementsAllowed public {
648         // Check that the `_idPayment` has been added to the payments struct
649         require(_idPayment < authorizedPayments.length);
650 
651         Payment storage p = authorizedPayments[_idPayment];
652         // The current minimum delay for a payment is `timeLock`. Thus the following ensuress
653         // that the `securityGuard` has checked in after the payment was created
654         // @notice earliestPayTime is updated when a payment is delayed. Which may require
655         // another checkIn before the payment can be collected.
656         // @notice We add 30 mins to this to reduce (not eliminate) the risk of front-running
657         require(securityGuardLastCheckin >= p.earliestPayTime - timeLock + 30 minutes);
658 
659         super.disburseAuthorizedPayment(_idPayment);
660     }
661 
662 ///////////////////////////
663 // SecurityGuard Interface
664 ///////////////////////////
665 
666     /**
667     * @notice `onlySecurityGuard` can checkin. If they fail to checkin,
668     * payments will not be allowed to be disbursed, unless the payment has
669     * an `earliestPayTime` <= `securityGuardLastCheckin`.
670     * @notice To reduce the risk of a front-running attack on payments, it
671     * is important that this is called with a resonable gasPrice set for the
672     * current network congestion. If this tx is not mined, within 30 mins
673     * of being sent, it is possible that a payment can be authorized w/o the
674     * securityGuard's knowledge
675     */
676     function checkIn() onlySecurityGuard external {
677         securityGuardLastCheckin = _getTime();
678     }
679 }
680 
681 ///File: ./contracts/GivethBridge.sol
682 
683 pragma solidity ^0.4.21;
684 
685 /*
686     Copyright 2017, RJ Ewing <perissology@protonmail.com>
687 
688     This program is free software: you can redistribute it and/or modify
689     it under the terms of the GNU General Public License as published by
690     the Free Software Foundation, either version 3 of the License, or
691     (at your option) any later version.
692 
693     This program is distributed in the hope that it will be useful,
694     but WITHOUT ANY WARRANTY; without even the implied warranty of
695     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
696     GNU General Public License for more details.
697 
698     You should have received a copy of the GNU General Public License
699     along with this program.  If not, see <http://www.gnu.org/licenses/>.
700 */
701 
702 
703 
704 
705 
706 /**
707 * @notice It is not recommened to call this function outside of the giveth dapp (giveth.io)
708 * this function is bridged to a side chain. If for some reason the sidechain tx fails, the donation
709 * will end up in the givers control inside LiquidPledging contract. If you do not use the dapp, there
710 * will be no way of notifying the sender/giver that the giver has to take action (withdraw/donate) in
711 * the dapp
712 */
713 contract GivethBridge is FailClosedVault {
714 
715     mapping(address => bool) tokenWhitelist;
716 
717     event Donate(uint64 giverId, uint64 receiverId, address token, uint amount);
718     event DonateAndCreateGiver(address giver, uint64 receiverId, address token, uint amount);
719     event EscapeFundsCalled(address token, uint amount);
720 
721     //== constructor
722 
723     /**
724     * @param _escapeHatchCaller The address of a trusted account or contract to
725     *  call `escapeHatch()` to send the ether in this contract to the
726     *  `escapeHatchDestination` in the case on an emergency. it would be ideal 
727     *  if `escapeHatchCaller` cannot move funds out of `escapeHatchDestination`
728     * @param _escapeHatchDestination The address of a safe location (usually a
729     *  Multisig) to send the ether held in this contract in the case of an emergency
730     * @param _absoluteMinTimeLock The minimum number of seconds `timelock` can
731     *  be set to, if set to 0 the `owner` can remove the `timeLock` completely
732     * @param _timeLock Minimum number of seconds that payments are delayed
733     *  after they are authorized (a security precaution)
734     * @param _securityGuard Address that will be able to delay the payments
735     *  beyond the initial timelock requirements; can be set to 0x0 to remove
736     *  the `securityGuard` functionality
737     * @param _maxSecurityGuardDelay The maximum number of seconds in total
738     *   that `securityGuard` can delay a payment so that the owner can cancel
739     *   the payment if needed
740     */
741     function GivethBridge(
742         address _escapeHatchCaller,
743         address _escapeHatchDestination,
744         uint _absoluteMinTimeLock,
745         uint _timeLock,
746         address _securityGuard,
747         uint _maxSecurityGuardDelay
748     ) FailClosedVault(
749         _escapeHatchCaller,
750         _escapeHatchDestination,
751         _absoluteMinTimeLock,
752         _timeLock,
753         _securityGuard,
754         _maxSecurityGuardDelay
755     ) public
756     {
757         tokenWhitelist[0] = true; // enable eth transfers
758     }
759 
760     //== public methods
761 
762     /**
763     * @notice It is not recommened to call this function outside of the giveth dapp (giveth.io)
764     * this function is bridged to a side chain. If for some reason the sidechain tx fails, the donation
765     * will end up in the givers control inside LiquidPledging contract. If you do not use the dapp, there
766     * will be no way of notifying the sender/giver that the giver has to take action (withdraw/donate) in
767     * the dapp
768     *
769     * @param giver The address to create a 'giver' pledge admin for in the liquidPledging contract
770     * @param receiverId The adminId of the liquidPledging pledge admin receiving the donation
771     */
772     function donateAndCreateGiver(address giver, uint64 receiverId) payable external {
773         donateAndCreateGiver(giver, receiverId, 0, 0);
774     }
775 
776     /**
777     * @notice It is not recommened to call this function outside of the giveth dapp (giveth.io)
778     * this function is bridged to a side chain. If for some reason the sidechain tx fails, the donation
779     * will end up in the givers control inside LiquidPledging contract. If you do not use the dapp, there
780     * will be no way of notifying the sender/giver that the giver has to take action (withdraw/donate) in
781     * the dapp
782     *
783     * @param giver The address to create a 'giver' pledge admin for in the liquidPledging contract
784     * @param receiverId The adminId of the liquidPledging pledge admin receiving the donation
785     * @param token The token to donate. If donating ETH, then 0x0. Note: the token must be whitelisted
786     * @param _amount The amount of the token to donate. If donating ETH, then 0x0 as the msg.value will be used instead.
787     */
788     function donateAndCreateGiver(address giver, uint64 receiverId, address token, uint _amount) whenNotPaused payable public {
789         require(giver != 0);
790         require(receiverId != 0);
791         uint amount = _receiveDonation(token, _amount);
792         emit DonateAndCreateGiver(giver, receiverId, token, amount);
793     }
794 
795     /**
796     * @notice It is not recommened to call this function outside of the giveth dapp (giveth.io)
797     * this function is bridged to a side chain. If for some reason the sidechain tx fails, the donation
798     * will end up in the givers control inside LiquidPledging contract. If you do not use the dapp, there
799     * will be no way of notifying the sender/giver that the giver has to take action (withdraw/donate) in
800     * the dapp
801     *
802     * @param giverId The adminId of the liquidPledging pledge admin who is donating
803     * @param receiverId The adminId of the liquidPledging pledge admin receiving the donation
804     */
805     function donate(uint64 giverId, uint64 receiverId) payable external {
806         donate(giverId, receiverId, 0, 0);
807     }
808 
809     /**
810     * @notice It is not recommened to call this function outside of the giveth dapp (giveth.io)
811     * this function is bridged to a side chain. If for some reason the sidechain tx fails, the donation
812     * will end up in the givers control inside LiquidPledging contract. If you do not use the dapp, there
813     * will be no way of notifying the sender/giver that the giver has to take action (withdraw/donate) in
814     * the dapp
815     *
816     * @param giverId The adminId of the liquidPledging pledge admin who is donating
817     * @param receiverId The adminId of the liquidPledging pledge admin receiving the donation
818     * @param token The token to donate. If donating ETH, then 0x0. Note: the token must be whitelisted
819     * @param _amount The amount of the token to donate. If donating ETH, then 0x0 as the msg.value will be used instead.
820     */
821     function donate(uint64 giverId, uint64 receiverId, address token, uint _amount) whenNotPaused payable public {
822         require(giverId != 0);
823         require(receiverId != 0);
824         uint amount = _receiveDonation(token, _amount);
825         emit Donate(giverId, receiverId, token, amount);
826     }
827 
828     /**
829     * The `owner` can call this function to add/remove a token from the whitelist
830     *
831     * @param token The address of the token to update
832     * @param accepted Wether or not to accept this token for donations
833     */
834     function whitelistToken(address token, bool accepted) whenNotPaused onlyOwner external {
835         tokenWhitelist[token] = accepted;
836     }
837 
838     /**
839     * Transfer tokens/eth to the escapeHatchDestination.
840     * Used as a safety mechanism to prevent the bridge from holding too much value
841     *
842     * before being thoroughly battle-tested.
843     * @param _token the token to transfer. 0x0 for ETH
844     * @param _amount the amount to transfer
845     */
846     function escapeFunds(address _token, uint _amount) external onlyEscapeHatchCallerOrOwner {
847         // @dev Logic for ether
848         if (_token == 0) {
849             escapeHatchDestination.transfer(_amount);
850         // @dev Logic for tokens
851         } else {
852             ERC20 token = ERC20(_token);
853             require(token.transfer(escapeHatchDestination, _amount));
854         }
855         emit EscapeFundsCalled(_token, _amount);
856     }
857 
858     //== internal methods
859 
860     /**
861     * @dev used to actually receive the donation. Will transfer the token to to this contract
862     */
863     function _receiveDonation(address token, uint _amount) internal returns(uint amount) {
864         require(tokenWhitelist[token]);
865         amount = _amount;
866 
867         // eth donation
868         if (token == 0) {
869             amount = msg.value;
870         }
871 
872         require(amount > 0);
873 
874         if (token != 0) {
875             require(ERC20(token).transferFrom(msg.sender, this, amount));
876         }
877     }
878 }