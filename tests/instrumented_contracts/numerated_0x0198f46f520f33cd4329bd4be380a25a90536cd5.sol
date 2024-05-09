1 /*
2 -----------------------------------------------------------------
3 FILE INFORMATION
4 -----------------------------------------------------------------
5 
6 file:       PlayChip.sol
7 version:    0.8
8 date:       2018-10-4
9 authors:    Joel Aquilina
10             Anton Jurisevic
11 
12 -----------------------------------------------------------------
13 MODULE DESCRIPTION
14 -----------------------------------------------------------------
15 
16 A simple ERC20 token with additional functionality to send
17 batched transfers and approvals. This way transactions can be
18 made in bulk, saving time and gas.
19 
20 The contract can be paused by the owner so that transfers are
21 disabled until it is unpaused. The contract begins paused
22 so that during this initialisation phase, all tokens are to
23 be distributed by the deployer of the contract.
24 
25 The contract can also be self-destructed by the owner after a
26 four week delay after announcing the self-destruction. Note
27 that pausing the contract will do nothing during the
28 self-destruction period.
29 
30 -----------------------------------------------------------------
31 */
32 
33 
34 pragma solidity 0.4.25;
35 pragma experimental "v0.5.0";
36 
37 
38 /*
39 -----------------------------------------------------------------
40 FILE INFORMATION
41 -----------------------------------------------------------------
42 
43 file:       ERC20Token.sol
44 version:    1.0
45 
46 -----------------------------------------------------------------
47 MODULE DESCRIPTION
48 -----------------------------------------------------------------
49 
50 Standard ERC20 token interface.
51 
52 -----------------------------------------------------------------
53 */
54 
55 
56 
57 
58 /**
59  * @title A basic ERC20 token interface.
60  * @dev To use this, be sure to implement the `approve`, `transfer`, and `transferFrom`
61  *      abstract functions, and to initialise `name`, `symbol`, `decimals`, and `totalSupply`.
62  */
63 contract ERC20Token {
64 
65     string public name;
66     string public symbol;
67     uint8 public decimals;
68     uint public totalSupply;
69 
70     mapping(address => uint) public balanceOf;
71     mapping(address => mapping(address => uint)) public allowance;
72 
73     function approve(address spender, uint quantity) public returns (bool);
74     function transfer(address to, uint quantity) public returns (bool);
75     function transferFrom(address from, address to, uint quantity) public returns (bool);
76 
77     event Transfer(address indexed from, address indexed to, uint quantity);
78     event Approval(address indexed owner, address indexed spender, uint quantity);
79 
80 }
81 /*
82 -----------------------------------------------------------------
83 FILE INFORMATION
84 -----------------------------------------------------------------
85 
86 file:       Owned.sol
87 version:    1.1
88 date:       2018-2-26
89 author:     Anton Jurisevic
90             Dominic Romanowski
91 
92 auditors: Sigma Prime, https://github.com/sigp/havven-audit
93           BlocTrax, https://havven.io/uploads/havven_bloctrax_security_audit_june-6th.pdf
94 
95 -----------------------------------------------------------------
96 MODULE DESCRIPTION
97 -----------------------------------------------------------------
98 
99 A contract with an owner, to be inherited by other contracts.
100 Requires its owner to be explicitly set in the constructor.
101 Provides an onlyOwner access modifier.
102 
103 To change owner, the current owner must nominate the next owner,
104 who then has to accept the nomination. The nomination can be
105 cancelled before it is accepted by the new owner by having the
106 previous owner change the nomination (setting it to 0).
107 
108 If the ownership is to be relinquished, then it can be handed
109 to a smart contract whose only function is to accept that
110 ownership, which guarantees no owner-only functionality can
111 ever be invoked.
112 
113 -----------------------------------------------------------------
114 */
115 
116 
117 /**
118  * @title A contract with an owner.
119  * @notice Contract ownership is transferred by first nominating the new owner,
120  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
121  */
122 contract Owned {
123     address public owner;
124     address public nominatedOwner;
125 
126     /**
127      * @dev Owned Constructor
128      * @param _owner The initial owner of the contract.
129      */
130     constructor(address _owner)
131         public
132     {
133         require(_owner != address(0), "Null owner address.");
134         owner = _owner;
135         emit OwnerChanged(address(0), _owner);
136     }
137 
138     /**
139      * @notice Nominate a new owner of this contract.
140      * @dev Only the current owner may nominate a new owner.
141      * @param _owner The new owner to be nominated.
142      */
143     function nominateNewOwner(address _owner)
144         public
145         onlyOwner
146     {
147         nominatedOwner = _owner;
148         emit OwnerNominated(_owner);
149     }
150 
151     /**
152      * @notice Accept the nomination to be owner.
153      */
154     function acceptOwnership()
155         external
156     {
157         require(msg.sender == nominatedOwner, "Not nominated.");
158         emit OwnerChanged(owner, nominatedOwner);
159         owner = nominatedOwner;
160         nominatedOwner = address(0);
161     }
162 
163     modifier onlyOwner
164     {
165         require(msg.sender == owner, "Not owner.");
166         _;
167     }
168 
169     event OwnerNominated(address newOwner);
170     event OwnerChanged(address oldOwner, address newOwner);
171 }
172 
173 /*
174 -----------------------------------------------------------------------------
175 MIT License
176 
177 Copyright (c) 2018 Havven
178 
179 Permission is hereby granted, free of charge, to any person obtaining a copy
180 of this software and associated documentation files (the "Software"), to deal
181 in the Software without restriction, including without limitation the rights
182 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
183 copies of the Software, and to permit persons to whom the Software is
184 furnished to do so, subject to the following conditions:
185 
186 The above copyright notice and this permission notice shall be included in
187 all copies or substantial portions of the Software.
188 
189 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
190 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
191 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
192 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
193 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
194 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
195 SOFTWARE.
196 -----------------------------------------------------------------------------
197 */
198 /*
199 -----------------------------------------------------------------
200 FILE INFORMATION
201 -----------------------------------------------------------------
202 
203 file:       Pausable.sol
204 version:    0.8
205 date:       2018-10-5
206 author:     Anton Jurisevic
207 
208 -----------------------------------------------------------------
209 MODULE DESCRIPTION
210 -----------------------------------------------------------------
211 
212 This contract allows inheritors to be paused and unpaused by
213 itself or its owner. It offers modifiers allowing decorated functions
214 to operate only if the contract is paused or unpaused as
215 according to need.
216 
217 The inheriting contract must itself inherit from Owned,
218 and initialise it.
219 
220 -----------------------------------------------------------------
221 */
222 
223 
224 
225 
226 
227 
228 /**
229  * @title A pausable contract.
230  * @dev The inheriting contract must itself inherit from Owned, and initialise it.
231  */
232 contract Pausable is Owned {
233 
234     bool public paused;
235     
236     /**
237      * @dev Internal `pause()` with no owner-only constraint.
238      */
239     function _pause()
240         internal
241     {
242         if (!paused) {
243             paused = true;
244             emit Paused();
245         }
246     }
247 
248     /**
249      * @notice Pause operations of the contract.
250      * @dev Functions modified with `onlyUnpaused` will cease to operate,
251      *      while functions with `onlyPaused` will start operating.
252      *      If this is called while the contract is paused, nothing will happen. 
253      */
254     function pause() 
255         public
256         onlyOwner
257     {
258         _pause();
259     }
260 
261     /**
262      * @dev Internal `unpause()` with no owner-only constraint.
263      */
264     function _unpause()
265         internal
266     {
267         if (paused) {
268             paused = false;
269             emit Unpaused();
270         }
271     }
272 
273     /**
274      * @notice Unpause operations of the contract.
275      * @dev Functions modified with `onlyPaused` will cease to operate,
276      *      while functions with `onlyUnpaused` will start operating.
277      *      If this is called while the contract is unpaused, nothing will happen. 
278      */
279     function unpause()
280         public
281         onlyOwner
282     {
283         _unpause();
284     }
285 
286     modifier onlyPaused {
287         require(paused, "Contract must be paused.");
288         _;
289     }
290 
291     modifier pausable {
292         require(!paused, "Contract must not be paused.");
293         _;
294     }
295 
296     event Paused();
297     event Unpaused();
298 
299 }
300 /*
301 -----------------------------------------------------------------
302 FILE INFORMATION
303 -----------------------------------------------------------------
304 
305 file:       SelfDestructible.sol
306 version:    1.2
307 date:       2018-05-29
308 author:     Anton Jurisevic
309 
310 auditors: Sigma Prime, https://github.com/sigp/havven-audit
311           BlocTrax, https://havven.io/uploads/havven_bloctrax_security_audit_june-6th.pdf
312 
313 -----------------------------------------------------------------
314 MODULE DESCRIPTION
315 -----------------------------------------------------------------
316 
317 This contract allows an inheriting contract to be destroyed after
318 its owner indicates an intention and then waits for a period
319 without changing their mind. All ether contained in the contract
320 is forwarded to a nominated beneficiary upon destruction.
321 
322 The inheriting contract must itself inherit from Owned, and
323 initialise it.
324 
325 -----------------------------------------------------------------
326 */
327 
328 
329 
330 
331 
332 
333 /**
334  * @title This contract can be destroyed by its owner after a delay elapses.
335  * @dev The inheriting contract must itself inherit from Owned, and initialise it.
336  */
337 contract SelfDestructible is Owned {
338 
339     uint public selfDestructInitiationTime;
340     bool public selfDestructInitiated;
341     address public selfDestructBeneficiary;
342     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
343 
344     /**
345      * @dev Constructor
346      * @param _beneficiary The account which will receive ether upon self-destruct.
347      */
348     constructor(address _beneficiary)
349         public
350     {
351         selfDestructBeneficiary = _beneficiary;
352         emit SelfDestructBeneficiaryUpdated(_beneficiary);
353     }
354 
355     /**
356      * @notice Set the beneficiary address of this contract.
357      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
358      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
359      */
360     function setSelfDestructBeneficiary(address _beneficiary)
361         external
362         onlyOwner
363     {
364         require(_beneficiary != address(0), "Beneficiary must not be the zero address.");
365         selfDestructBeneficiary = _beneficiary;
366         emit SelfDestructBeneficiaryUpdated(_beneficiary);
367     }
368 
369     /**
370      * @notice Begin the self-destruction counter of this contract.
371      * Once the delay has elapsed, the contract may be self-destructed.
372      * @dev Only the contract owner may call this, and only if self-destruct has not been initiated.
373      */
374     function initiateSelfDestruct()
375         external
376         onlyOwner
377     {
378         require(!selfDestructInitiated, "Self-destruct already initiated.");
379         selfDestructInitiationTime = now;
380         selfDestructInitiated = true;
381         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
382     }
383 
384     /**
385      * @notice Terminate and reset the self-destruction timer.
386      * @dev Only the contract owner may call this, and only during self-destruction.
387      */
388     function terminateSelfDestruct()
389         external
390         onlyOwner
391     {
392         require(selfDestructInitiated, "Self-destruct not yet initiated.");
393         selfDestructInitiationTime = 0;
394         selfDestructInitiated = false;
395         emit SelfDestructTerminated();
396     }
397 
398     /**
399      * @notice If the self-destruction delay has elapsed, destroy this contract and
400      * remit any ether it owns to the beneficiary address.
401      * @dev Only the contract owner may call this.
402      */
403     function selfDestruct()
404         external
405         onlyOwner
406     {
407         require(selfDestructInitiated, "Self-destruct not yet initiated.");
408         require(selfDestructInitiationTime + SELFDESTRUCT_DELAY < now, "Self-destruct delay has not yet elapsed.");
409         address beneficiary = selfDestructBeneficiary;
410         emit SelfDestructed(beneficiary);
411         selfdestruct(beneficiary);
412     }
413 
414     event SelfDestructTerminated();
415     event SelfDestructed(address beneficiary);
416     event SelfDestructInitiated(uint selfDestructDelay);
417     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
418 }
419 
420 /*
421 -----------------------------------------------------------------------------
422 MIT License
423 
424 Copyright (c) 2018 Havven
425 
426 Permission is hereby granted, free of charge, to any person obtaining a copy
427 of this software and associated documentation files (the "Software"), to deal
428 in the Software without restriction, including without limitation the rights
429 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
430 copies of the Software, and to permit persons to whom the Software is
431 furnished to do so, subject to the following conditions:
432 
433 The above copyright notice and this permission notice shall be included in
434 all copies or substantial portions of the Software.
435 
436 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
437 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
438 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
439 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
440 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
441 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
442 SOFTWARE.
443 -----------------------------------------------------------------------------
444 */
445 
446 
447 /**
448  * @title The PlayChip token contract.
449  * @notice This token contract has an owner, who can pause or
450  *         self-destruct it after a delay. Transfers will be disabled
451  *         except from the contract itself while it is paused, unless it is
452  *         self-destructing.
453  * @dev The contract starts paused and must be unpaused before it will operate.
454  */
455 contract PlayChip is ERC20Token, Owned, Pausable, SelfDestructible {
456 
457     /**
458      * @param _totalSupply The initial supply of tokens, which will be given to
459      *                     the initial owner of the contract. This quantity is
460      *                     a fixed-point integer with 18 decimal places (wei).
461      * @param _owner The initial owner of the contract, who must unpause the contract
462      *               before it can be used, but may use the `initBatchTransfer` to disburse
463      *               funds to initial token holders before unpausing it.
464      */
465     constructor(uint _totalSupply, address _owner)
466         Owned(_owner)
467         Pausable()
468         SelfDestructible(_owner)
469         public
470     {
471         _pause();
472         name = "PlayChip";
473         symbol = "PLA";
474         decimals = 18;
475         totalSupply = _totalSupply;
476         balanceOf[this] = totalSupply;
477         emit Transfer(address(0), this, totalSupply);
478     }
479 
480 
481     /* ========== MODIFIERS AND UTILITIES ========== */
482 
483     modifier requireSameLength(uint a, uint b) {
484         require(a == b, "Input array lengths differ.");
485         _;
486     }
487 
488     /* Although we could have merged SelfDestructible and Pausable, this
489      * modifier keeps those contracts decoupled. */
490     modifier pausableIfNotSelfDestructing {
491         require(!paused || selfDestructInitiated, "Contract must not be paused.");
492         _;
493     }
494 
495     /**
496      * @dev Returns the difference of the given arguments. Will throw an exception iff `x < y`.
497      * @return `y` subtracted from `x`.
498      */
499     function safeSub(uint x, uint y)
500         pure
501         internal
502         returns (uint)
503     {
504         require(y <= x, "Safe sub failed.");
505         return x - y;
506     }
507 
508 
509     /* ========== ERC20 FUNCTIONS ========== */
510 
511     /**
512      * @notice Transfers `quantity` tokens from `from` to `to`.
513      * @dev Throws an exception if the balance owned by the `from` address is less than `quantity`, or if
514      *      the transfer is to the 0x0 address, in case it was the result of an omitted argument.
515      * @param from The spender.
516      * @param to The recipient.
517      * @param quantity The quantity to transfer, in wei.
518      * @return Always returns true if no exception was thrown.
519      */
520     function _transfer(address from, address to, uint quantity)
521         internal
522         returns (bool)
523     {
524         require(to != address(0), "Transfers to 0x0 disallowed.");
525         balanceOf[from] = safeSub(balanceOf[from], quantity); // safeSub handles insufficient balance.
526         balanceOf[to] += quantity;
527         emit Transfer(from, to, quantity);
528         return true;
529 
530         /* Since balances are only manipulated here, and the sum of all
531          * balances is preserved, no balance is greater than
532          * totalSupply; the safeSub implies that balanceOf[to] + quantity is
533          * no greater than totalSupply.
534          * Thus a safeAdd is unnecessary, since overflow is impossible. */
535     }
536 
537     /**
538       * @notice ERC20 transfer function; transfers `quantity` tokens from the message sender to `to`.
539       * @param to The recipient.
540       * @param quantity The quantity to transfer, in wei.
541       * @dev Exceptional conditions:
542       *          * The contract is paused if it is not self-destructing.
543       *          * The sender's balance is less than the transfer quantity.
544       *          * The `to` parameter is 0x0.
545       * @return Always returns true if no exception was thrown.
546       */
547     function transfer(address to, uint quantity)
548         public
549         pausableIfNotSelfDestructing
550         returns (bool)
551     {
552         return _transfer(msg.sender, to, quantity);
553     }
554 
555     /**
556      * @notice ERC20 approve function; approves `spender` to transfer up to `quantity` tokens on the sender's behalf.
557      * @param spender The approvee.
558      * @param quantity The maximum spend quantity in wei; overwrites any existing quantity.
559      * @dev Throws an exception if the contract is paused if it is not self-destructing, or if `spender` is 0x0.
560      * @return Always returns true.
561      */
562     function approve(address spender, uint quantity)
563         public
564         pausableIfNotSelfDestructing
565         returns (bool)
566     {
567         require(spender != address(0), "Approvals for 0x0 disallowed.");
568         allowance[msg.sender][spender] = quantity;
569         emit Approval(msg.sender, spender, quantity);
570         return true;
571     }
572 
573     /**
574       * @notice ERC20 transferFrom function; transfers `quantity` tokens from
575       *         `from` to `to` if the sender is approved.
576       * @param from The spender; balance is deducted from this account.
577       * @param to The recipient.
578       * @param quantity The quantity to transfer, in wei.
579       * @dev Exceptional conditions:
580       *          * The contract is paused if it is not self-destructing.
581       *          * The `from` account has approved the sender to spend less than the transfer quantity.
582       *          * The `from` account's balance is less than the transfer quantity.
583       *          * The `to` parameter is 0x0.
584       * @return Always returns true if no exception was thrown.
585       */
586     function transferFrom(address from, address to, uint quantity)
587         public
588         pausableIfNotSelfDestructing
589         returns (bool)
590     {
591         // safeSub handles insufficient allowance.
592         allowance[from][msg.sender] = safeSub(allowance[from][msg.sender], quantity);
593         return _transfer(from, to, quantity);
594     }
595 
596 
597     /* ========== BATCHED ERC20 FUNCTIONS ========== */
598 
599     /**
600       * @notice Performs ERC20 transfers in batches; for each `i`,
601       *         transfers `quantity[i]` tokens from the message sender to `to[i]`.
602       * @param recipients An array of recipients.
603       * @param quantities A corresponding array of transfer quantities, in wei.
604       * @dev Exceptional conditions:
605       *          * The `recipients` and `quantities` arrays differ in length.
606       *          * The sender's balance is less than the transfer quantity.
607       *          * Any recipient is 0x0.
608       * @return Always returns true if no exception was thrown.
609       */
610     function _batchTransfer(address sender, address[] recipients, uint[] quantities)
611         internal
612         requireSameLength(recipients.length, quantities.length)
613         returns (bool)
614     {
615         uint length = recipients.length;
616         for (uint i = 0; i < length; i++) {
617             _transfer(sender, recipients[i], quantities[i]);
618         }
619         return true;
620     }
621 
622     /**
623       * @notice Performs ERC20 transfers in batches; for each `i`,
624       *         transfers `quantities[i]` tokens from the message sender to `recipients[i]`.
625       * @param recipients An array of recipients.
626       * @param quantities A corresponding array of transfer quantities, in wei.
627       * @dev Exceptional conditions:
628       *          * The contract is paused if it is not self-destructing.
629       *          * The `recipients` and `quantities` arrays differ in length.
630       *          * The sender's balance is less than the transfer quantity.
631       *          * Any recipient is 0x0.
632       * @return Always returns true if no exception was thrown.
633       */
634     function batchTransfer(address[] recipients, uint[] quantities)
635         external
636         pausableIfNotSelfDestructing
637         returns (bool)
638     {
639         return _batchTransfer(msg.sender, recipients, quantities);
640     }
641 
642     /**
643       * @notice Performs ERC20 approvals in batches; for each `i`,
644       *         approves `quantities[i]` tokens to be spent by `spenders[i]`
645       *         on behalf of the message sender.
646       * @param spenders An array of spenders.
647       * @param quantities A corresponding array of approval quantities, in wei.
648       * @dev Exceptional conditions:
649       *          * The contract is paused if it is not self-destructing.
650       *          * The `spenders` and `quantities` arrays differ in length.
651       *          * Any spender is 0x0.
652       * @return Always returns true if no exception was thrown.
653       */
654     function batchApprove(address[] spenders, uint[] quantities)
655         external
656         pausableIfNotSelfDestructing
657         requireSameLength(spenders.length, quantities.length)
658         returns (bool)
659     {
660         uint length = spenders.length;
661         for (uint i = 0; i < length; i++) {
662             approve(spenders[i], quantities[i]);
663         }
664         return true;
665     }
666 
667     /**
668       * @notice Performs ERC20 transferFroms in batches; for each `i`,
669       *         transfers `quantities[i]` tokens from `spenders[i]` to `recipients[i]`
670       *         if the sender is approved.
671       * @param spenders An array of spenders.
672       * @param recipients An array of recipients.
673       * @param quantities A corresponding array of transfer quantities, in wei.
674       * @dev For the common use cases of transferring from many spenders to one recipient or vice versa,
675       *      the sole spender or recipient must be duplicated in the input array.
676       *      Exceptional conditions:
677       *          * The contract is paused if it is not self-destructing.
678       *          * Any of the `spenders`, `recipients`, or `quantities` arrays differ in length.
679       *          * Any spender account has approved the sender to spend less than the transfer quantity.
680       *          * Any spender account's balance is less than its corresponding transfer quantity.
681       *          * Any recipient is 0x0.
682       * @return Always returns true if no exception was thrown.
683       */
684     function batchTransferFrom(address[] spenders, address[] recipients, uint[] quantities)
685         external
686         pausableIfNotSelfDestructing
687         requireSameLength(spenders.length, recipients.length)
688         requireSameLength(recipients.length, quantities.length)
689         returns (bool)
690     {
691         uint length = spenders.length;
692         for (uint i = 0; i < length; i++) {
693             transferFrom(spenders[i], recipients[i], quantities[i]);
694         }
695         return true;
696     }
697 
698 
699     /* ========== ADMINISTRATION FUNCTIONS ========== */
700 
701     /**
702       * @notice Performs ERC20 transfers from the contract address in batches; for each `i`,
703       *         transfers `quantities[i]` tokens from the contract to `recipients[i]`.
704       *         Allows the owner to perform transfers while the contract is paused.
705       *         Intended mainly to be used to disburse funds immediately after deployment.
706       * @param recipients An array of recipients.
707       * @param quantities A corresponding array of transfer quantities, in wei.
708       * @dev Exceptional conditions:
709       *          * The sender is not the contract's owner.
710       *          * The `recipients` and `quantities` arrays differ in length.
711       *          * The contract's balance is less than the transfer quantity.
712       *          * Any recipient is 0x0.
713       * @return Always returns true if no exception was thrown.
714       */
715     function contractBatchTransfer(address[] recipients, uint[] quantities)
716         external
717         onlyOwner
718         returns (bool)
719     {
720         return _batchTransfer(this, recipients, quantities);
721     }
722 
723 }