1 /*
2 -----------------------------------------------------------------
3 FILE INFORMATION
4 -----------------------------------------------------------------
5 
6 file:       PlayChip-FREE.sol
7 version:    1.0
8 date:       2018-12-05
9 authors:    Joel Aquilina
10             Anton Jurisevic
11 			Samuel Brooks
12 
13 -----------------------------------------------------------------
14 MODULE DESCRIPTION
15 -----------------------------------------------------------------
16 
17 This contract exists to manage multi-sig functionality for
18 Free PlayChips.
19 
20 It is a simple ERC20 token with additional functionality to send
21 batched transfers and approvals. This way transactions can be
22 made in bulk, saving time and gas.
23 
24 The contract can be paused by the owner so that transfers are
25 disabled until it is unpaused. The contract begins paused
26 so that during this initialisation phase, all tokens are to
27 be distributed by the deployer of the contract.
28 
29 The contract can also be self-destructed by the owner after a
30 four week delay after announcing the self-destruction. Note
31 that pausing the contract will do nothing during the
32 self-destruction period.
33 
34 -----------------------------------------------------------------
35 */
36 
37 
38 pragma solidity 0.4.25;
39 pragma experimental "v0.5.0";
40 
41 
42 /*
43 -----------------------------------------------------------------
44 FILE INFORMATION
45 -----------------------------------------------------------------
46 
47 file:       ERC20Token.sol
48 version:    1.0
49 
50 -----------------------------------------------------------------
51 MODULE DESCRIPTION
52 -----------------------------------------------------------------
53 
54 Standard ERC20 token interface.
55 
56 -----------------------------------------------------------------
57 */
58 
59 
60 
61 
62 /**
63  * @title A basic ERC20 token interface.
64  * @dev To use this, be sure to implement the `approve`, `transfer`, and `transferFrom`
65  *      abstract functions, and to initialise `name`, `symbol`, `decimals`, and `totalSupply`.
66  */
67 contract ERC20Token {
68 
69     string public name;
70     string public symbol;
71     uint8 public decimals;
72     uint public totalSupply;
73 
74     mapping(address => uint) public balanceOf;
75     mapping(address => mapping(address => uint)) public allowance;
76 
77     function approve(address spender, uint quantity) public returns (bool);
78     function transfer(address to, uint quantity) public returns (bool);
79     function transferFrom(address from, address to, uint quantity) public returns (bool);
80 
81     event Transfer(address indexed from, address indexed to, uint quantity);
82     event Approval(address indexed owner, address indexed spender, uint quantity);
83 
84 }
85 /*
86 -----------------------------------------------------------------
87 FILE INFORMATION
88 -----------------------------------------------------------------
89 
90 file:       Owned.sol
91 version:    1.1
92 date:       2018-2-26
93 author:     Anton Jurisevic
94             Dominic Romanowski
95 
96 auditors: Sigma Prime, https://github.com/sigp/havven-audit
97           BlocTrax, https://havven.io/uploads/havven_bloctrax_security_audit_june-6th.pdf
98 
99 -----------------------------------------------------------------
100 MODULE DESCRIPTION
101 -----------------------------------------------------------------
102 
103 A contract with an owner, to be inherited by other contracts.
104 Requires its owner to be explicitly set in the constructor.
105 Provides an onlyOwner access modifier.
106 
107 To change owner, the current owner must nominate the next owner,
108 who then has to accept the nomination. The nomination can be
109 cancelled before it is accepted by the new owner by having the
110 previous owner change the nomination (setting it to 0).
111 
112 If the ownership is to be relinquished, then it can be handed
113 to a smart contract whose only function is to accept that
114 ownership, which guarantees no owner-only functionality can
115 ever be invoked.
116 
117 -----------------------------------------------------------------
118 */
119 
120 
121 /**
122  * @title A contract with an owner.
123  * @notice Contract ownership is transferred by first nominating the new owner,
124  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
125  */
126 contract Owned {
127     address public owner;
128     address public nominatedOwner;
129 
130     /**
131      * @dev Owned Constructor
132      * @param _owner The initial owner of the contract.
133      */
134     constructor(address _owner)
135         public
136     {
137         require(_owner != address(0), "Null owner address.");
138         owner = _owner;
139         emit OwnerChanged(address(0), _owner);
140     }
141 
142     /**
143      * @notice Nominate a new owner of this contract.
144      * @dev Only the current owner may nominate a new owner.
145      * @param _owner The new owner to be nominated.
146      */
147     function nominateNewOwner(address _owner)
148         public
149         onlyOwner
150     {
151         nominatedOwner = _owner;
152         emit OwnerNominated(_owner);
153     }
154 
155     /**
156      * @notice Accept the nomination to be owner.
157      */
158     function acceptOwnership()
159         external
160     {
161         require(msg.sender == nominatedOwner, "Not nominated.");
162         emit OwnerChanged(owner, nominatedOwner);
163         owner = nominatedOwner;
164         nominatedOwner = address(0);
165     }
166 
167     modifier onlyOwner
168     {
169         require(msg.sender == owner, "Not owner.");
170         _;
171     }
172 
173     event OwnerNominated(address newOwner);
174     event OwnerChanged(address oldOwner, address newOwner);
175 }
176 
177 /*
178 -----------------------------------------------------------------------------
179 MIT License
180 
181 Copyright (c) 2018 Havven
182 
183 Permission is hereby granted, free of charge, to any person obtaining a copy
184 of this software and associated documentation files (the "Software"), to deal
185 in the Software without restriction, including without limitation the rights
186 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
187 copies of the Software, and to permit persons to whom the Software is
188 furnished to do so, subject to the following conditions:
189 
190 The above copyright notice and this permission notice shall be included in
191 all copies or substantial portions of the Software.
192 
193 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
194 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
195 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
196 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
197 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
198 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
199 SOFTWARE.
200 -----------------------------------------------------------------------------
201 */
202 /*
203 -----------------------------------------------------------------
204 FILE INFORMATION
205 -----------------------------------------------------------------
206 
207 file:       Pausable.sol
208 version:    0.8
209 date:       2018-10-5
210 author:     Anton Jurisevic
211 
212 -----------------------------------------------------------------
213 MODULE DESCRIPTION
214 -----------------------------------------------------------------
215 
216 This contract allows inheritors to be paused and unpaused by
217 itself or its owner. It offers modifiers allowing decorated functions
218 to operate only if the contract is paused or unpaused as
219 according to need.
220 
221 The inheriting contract must itself inherit from Owned,
222 and initialise it.
223 
224 -----------------------------------------------------------------
225 */
226 
227 
228 
229 
230 
231 
232 /**
233  * @title A pausable contract.
234  * @dev The inheriting contract must itself inherit from Owned, and initialise it.
235  */
236 contract Pausable is Owned {
237 
238     bool public paused;
239     
240     /**
241      * @dev Internal `pause()` with no owner-only constraint.
242      */
243     function _pause()
244         internal
245     {
246         if (!paused) {
247             paused = true;
248             emit Paused();
249         }
250     }
251 
252     /**
253      * @notice Pause operations of the contract.
254      * @dev Functions modified with `onlyUnpaused` will cease to operate,
255      *      while functions with `onlyPaused` will start operating.
256      *      If this is called while the contract is paused, nothing will happen. 
257      */
258     function pause() 
259         public
260         onlyOwner
261     {
262         _pause();
263     }
264 
265     /**
266      * @dev Internal `unpause()` with no owner-only constraint.
267      */
268     function _unpause()
269         internal
270     {
271         if (paused) {
272             paused = false;
273             emit Unpaused();
274         }
275     }
276 
277     /**
278      * @notice Unpause operations of the contract.
279      * @dev Functions modified with `onlyPaused` will cease to operate,
280      *      while functions with `onlyUnpaused` will start operating.
281      *      If this is called while the contract is unpaused, nothing will happen. 
282      */
283     function unpause()
284         public
285         onlyOwner
286     {
287         _unpause();
288     }
289 
290     modifier onlyPaused {
291         require(paused, "Contract must be paused.");
292         _;
293     }
294 
295     modifier pausable {
296         require(!paused, "Contract must not be paused.");
297         _;
298     }
299 
300     event Paused();
301     event Unpaused();
302 
303 }
304 /*
305 -----------------------------------------------------------------
306 FILE INFORMATION
307 -----------------------------------------------------------------
308 
309 file:       SelfDestructible.sol
310 version:    1.2
311 date:       2018-05-29
312 author:     Anton Jurisevic
313 
314 auditors: Sigma Prime, https://github.com/sigp/havven-audit
315           BlocTrax, https://havven.io/uploads/havven_bloctrax_security_audit_june-6th.pdf
316 
317 -----------------------------------------------------------------
318 MODULE DESCRIPTION
319 -----------------------------------------------------------------
320 
321 This contract allows an inheriting contract to be destroyed after
322 its owner indicates an intention and then waits for a period
323 without changing their mind. All ether contained in the contract
324 is forwarded to a nominated beneficiary upon destruction.
325 
326 The inheriting contract must itself inherit from Owned, and
327 initialise it.
328 
329 -----------------------------------------------------------------
330 */
331 
332 
333 
334 
335 
336 
337 /**
338  * @title This contract can be destroyed by its owner after a delay elapses.
339  * @dev The inheriting contract must itself inherit from Owned, and initialise it.
340  */
341 contract SelfDestructible is Owned {
342 
343     uint public selfDestructInitiationTime;
344     bool public selfDestructInitiated;
345     address public selfDestructBeneficiary;
346     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
347 
348     /**
349      * @dev Constructor
350      * @param _beneficiary The account which will receive ether upon self-destruct.
351      */
352     constructor(address _beneficiary)
353         public
354     {
355         selfDestructBeneficiary = _beneficiary;
356         emit SelfDestructBeneficiaryUpdated(_beneficiary);
357     }
358 
359     /**
360      * @notice Set the beneficiary address of this contract.
361      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
362      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
363      */
364     function setSelfDestructBeneficiary(address _beneficiary)
365         external
366         onlyOwner
367     {
368         require(_beneficiary != address(0), "Beneficiary must not be the zero address.");
369         selfDestructBeneficiary = _beneficiary;
370         emit SelfDestructBeneficiaryUpdated(_beneficiary);
371     }
372 
373     /**
374      * @notice Begin the self-destruction counter of this contract.
375      * Once the delay has elapsed, the contract may be self-destructed.
376      * @dev Only the contract owner may call this, and only if self-destruct has not been initiated.
377      */
378     function initiateSelfDestruct()
379         external
380         onlyOwner
381     {
382         require(!selfDestructInitiated, "Self-destruct already initiated.");
383         selfDestructInitiationTime = now;
384         selfDestructInitiated = true;
385         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
386     }
387 
388     /**
389      * @notice Terminate and reset the self-destruction timer.
390      * @dev Only the contract owner may call this, and only during self-destruction.
391      */
392     function terminateSelfDestruct()
393         external
394         onlyOwner
395     {
396         require(selfDestructInitiated, "Self-destruct not yet initiated.");
397         selfDestructInitiationTime = 0;
398         selfDestructInitiated = false;
399         emit SelfDestructTerminated();
400     }
401 
402     /**
403      * @notice If the self-destruction delay has elapsed, destroy this contract and
404      * remit any ether it owns to the beneficiary address.
405      * @dev Only the contract owner may call this.
406      */
407     function selfDestruct()
408         external
409         onlyOwner
410     {
411         require(selfDestructInitiated, "Self-destruct not yet initiated.");
412         require(selfDestructInitiationTime + SELFDESTRUCT_DELAY < now, "Self-destruct delay has not yet elapsed.");
413         address beneficiary = selfDestructBeneficiary;
414         emit SelfDestructed(beneficiary);
415         selfdestruct(beneficiary);
416     }
417 
418     event SelfDestructTerminated();
419     event SelfDestructed(address beneficiary);
420     event SelfDestructInitiated(uint selfDestructDelay);
421     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
422 }
423 
424 /*
425 -----------------------------------------------------------------------------
426 MIT License
427 
428 Copyright (c) 2018 Havven
429 
430 Permission is hereby granted, free of charge, to any person obtaining a copy
431 of this software and associated documentation files (the "Software"), to deal
432 in the Software without restriction, including without limitation the rights
433 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
434 copies of the Software, and to permit persons to whom the Software is
435 furnished to do so, subject to the following conditions:
436 
437 The above copyright notice and this permission notice shall be included in
438 all copies or substantial portions of the Software.
439 
440 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
441 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
442 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
443 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
444 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
445 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
446 SOFTWARE.
447 -----------------------------------------------------------------------------
448 */
449 
450 
451 /**
452  * @title The PlayChip token contract.
453  * @notice This token contract has an owner, who can pause or
454  *         self-destruct it after a delay. Transfers will be disabled
455  *         except from the contract itself while it is paused, unless it is
456  *         self-destructing.
457  * @dev The contract starts paused and must be unpaused before it will operate.
458  */
459 contract PlayChip is ERC20Token, Owned, Pausable, SelfDestructible {
460 
461     /**
462      * @param _totalSupply The initial supply of tokens, which will be given to
463      *                     the initial owner of the contract. This quantity is
464      *                     a fixed-point integer with 18 decimal places (wei).
465      * @param _owner The initial owner of the contract, who must unpause the contract
466      *               before it can be used, but may use the `initBatchTransfer` to disburse
467      *               funds to initial token holders before unpausing it.
468      */
469     constructor(uint _totalSupply, address _owner)
470         Owned(_owner)
471         Pausable()
472         SelfDestructible(_owner)
473         public
474     {
475         _pause();
476         name = "PlayChip Free";
477         symbol = "PLAF";
478         decimals = 18;
479         totalSupply = _totalSupply;
480         balanceOf[this] = totalSupply;
481         emit Transfer(address(0), this, totalSupply);
482     }
483 
484 
485     /* ========== MODIFIERS AND UTILITIES ========== */
486 
487     modifier requireSameLength(uint a, uint b) {
488         require(a == b, "Input array lengths differ.");
489         _;
490     }
491 
492     /* Although we could have merged SelfDestructible and Pausable, this
493      * modifier keeps those contracts decoupled. */
494     modifier pausableIfNotSelfDestructing {
495         require(!paused || selfDestructInitiated, "Contract must not be paused.");
496         _;
497     }
498 
499     /**
500      * @dev Returns the difference of the given arguments. Will throw an exception iff `x < y`.
501      * @return `y` subtracted from `x`.
502      */
503     function safeSub(uint x, uint y)
504         pure
505         internal
506         returns (uint)
507     {
508         require(y <= x, "Safe sub failed.");
509         return x - y;
510     }
511 
512 
513     /* ========== ERC20 FUNCTIONS ========== */
514 
515     /**
516      * @notice Transfers `quantity` tokens from `from` to `to`.
517      * @dev Throws an exception if the balance owned by the `from` address is less than `quantity`, or if
518      *      the transfer is to the 0x0 address, in case it was the result of an omitted argument.
519      * @param from The spender.
520      * @param to The recipient.
521      * @param quantity The quantity to transfer, in wei.
522      * @return Always returns true if no exception was thrown.
523      */
524     function _transfer(address from, address to, uint quantity)
525         internal
526         returns (bool)
527     {
528         require(to != address(0), "Transfers to 0x0 disallowed.");
529         balanceOf[from] = safeSub(balanceOf[from], quantity); // safeSub handles insufficient balance.
530         balanceOf[to] += quantity;
531         emit Transfer(from, to, quantity);
532         return true;
533 
534         /* Since balances are only manipulated here, and the sum of all
535          * balances is preserved, no balance is greater than
536          * totalSupply; the safeSub implies that balanceOf[to] + quantity is
537          * no greater than totalSupply.
538          * Thus a safeAdd is unnecessary, since overflow is impossible. */
539     }
540 
541     /**
542       * @notice ERC20 transfer function; transfers `quantity` tokens from the message sender to `to`.
543       * @param to The recipient.
544       * @param quantity The quantity to transfer, in wei.
545       * @dev Exceptional conditions:
546       *          * The contract is paused if it is not self-destructing.
547       *          * The sender's balance is less than the transfer quantity.
548       *          * The `to` parameter is 0x0.
549       * @return Always returns true if no exception was thrown.
550       */
551     function transfer(address to, uint quantity)
552         public
553         pausableIfNotSelfDestructing
554         returns (bool)
555     {
556         return _transfer(msg.sender, to, quantity);
557     }
558 
559     /**
560      * @notice ERC20 approve function; approves `spender` to transfer up to `quantity` tokens on the sender's behalf.
561      * @param spender The approvee.
562      * @param quantity The maximum spend quantity in wei; overwrites any existing quantity.
563      * @dev Throws an exception if the contract is paused if it is not self-destructing, or if `spender` is 0x0.
564      * @return Always returns true.
565      */
566     function approve(address spender, uint quantity)
567         public
568         pausableIfNotSelfDestructing
569         returns (bool)
570     {
571         require(spender != address(0), "Approvals for 0x0 disallowed.");
572         allowance[msg.sender][spender] = quantity;
573         emit Approval(msg.sender, spender, quantity);
574         return true;
575     }
576 
577     /**
578       * @notice ERC20 transferFrom function; transfers `quantity` tokens from
579       *         `from` to `to` if the sender is approved.
580       * @param from The spender; balance is deducted from this account.
581       * @param to The recipient.
582       * @param quantity The quantity to transfer, in wei.
583       * @dev Exceptional conditions:
584       *          * The contract is paused if it is not self-destructing.
585       *          * The `from` account has approved the sender to spend less than the transfer quantity.
586       *          * The `from` account's balance is less than the transfer quantity.
587       *          * The `to` parameter is 0x0.
588       * @return Always returns true if no exception was thrown.
589       */
590     function transferFrom(address from, address to, uint quantity)
591         public
592         pausableIfNotSelfDestructing
593         returns (bool)
594     {
595         // safeSub handles insufficient allowance.
596         allowance[from][msg.sender] = safeSub(allowance[from][msg.sender], quantity);
597         return _transfer(from, to, quantity);
598     }
599 
600 
601     /* ========== BATCHED ERC20 FUNCTIONS ========== */
602 
603     /**
604       * @notice Performs ERC20 transfers in batches; for each `i`,
605       *         transfers `quantity[i]` tokens from the message sender to `to[i]`.
606       * @param recipients An array of recipients.
607       * @param quantities A corresponding array of transfer quantities, in wei.
608       * @dev Exceptional conditions:
609       *          * The `recipients` and `quantities` arrays differ in length.
610       *          * The sender's balance is less than the transfer quantity.
611       *          * Any recipient is 0x0.
612       * @return Always returns true if no exception was thrown.
613       */
614     function _batchTransfer(address sender, address[] recipients, uint[] quantities)
615         internal
616         requireSameLength(recipients.length, quantities.length)
617         returns (bool)
618     {
619         uint length = recipients.length;
620         for (uint i = 0; i < length; i++) {
621             _transfer(sender, recipients[i], quantities[i]);
622         }
623         return true;
624     }
625 
626     /**
627       * @notice Performs ERC20 transfers in batches; for each `i`,
628       *         transfers `quantities[i]` tokens from the message sender to `recipients[i]`.
629       * @param recipients An array of recipients.
630       * @param quantities A corresponding array of transfer quantities, in wei.
631       * @dev Exceptional conditions:
632       *          * The contract is paused if it is not self-destructing.
633       *          * The `recipients` and `quantities` arrays differ in length.
634       *          * The sender's balance is less than the transfer quantity.
635       *          * Any recipient is 0x0.
636       * @return Always returns true if no exception was thrown.
637       */
638     function batchTransfer(address[] recipients, uint[] quantities)
639         external
640         pausableIfNotSelfDestructing
641         returns (bool)
642     {
643         return _batchTransfer(msg.sender, recipients, quantities);
644     }
645 
646     /**
647       * @notice Performs ERC20 approvals in batches; for each `i`,
648       *         approves `quantities[i]` tokens to be spent by `spenders[i]`
649       *         on behalf of the message sender.
650       * @param spenders An array of spenders.
651       * @param quantities A corresponding array of approval quantities, in wei.
652       * @dev Exceptional conditions:
653       *          * The contract is paused if it is not self-destructing.
654       *          * The `spenders` and `quantities` arrays differ in length.
655       *          * Any spender is 0x0.
656       * @return Always returns true if no exception was thrown.
657       */
658     function batchApprove(address[] spenders, uint[] quantities)
659         external
660         pausableIfNotSelfDestructing
661         requireSameLength(spenders.length, quantities.length)
662         returns (bool)
663     {
664         uint length = spenders.length;
665         for (uint i = 0; i < length; i++) {
666             approve(spenders[i], quantities[i]);
667         }
668         return true;
669     }
670 
671     /**
672       * @notice Performs ERC20 transferFroms in batches; for each `i`,
673       *         transfers `quantities[i]` tokens from `spenders[i]` to `recipients[i]`
674       *         if the sender is approved.
675       * @param spenders An array of spenders.
676       * @param recipients An array of recipients.
677       * @param quantities A corresponding array of transfer quantities, in wei.
678       * @dev For the common use cases of transferring from many spenders to one recipient or vice versa,
679       *      the sole spender or recipient must be duplicated in the input array.
680       *      Exceptional conditions:
681       *          * The contract is paused if it is not self-destructing.
682       *          * Any of the `spenders`, `recipients`, or `quantities` arrays differ in length.
683       *          * Any spender account has approved the sender to spend less than the transfer quantity.
684       *          * Any spender account's balance is less than its corresponding transfer quantity.
685       *          * Any recipient is 0x0.
686       * @return Always returns true if no exception was thrown.
687       */
688     function batchTransferFrom(address[] spenders, address[] recipients, uint[] quantities)
689         external
690         pausableIfNotSelfDestructing
691         requireSameLength(spenders.length, recipients.length)
692         requireSameLength(recipients.length, quantities.length)
693         returns (bool)
694     {
695         uint length = spenders.length;
696         for (uint i = 0; i < length; i++) {
697             transferFrom(spenders[i], recipients[i], quantities[i]);
698         }
699         return true;
700     }
701 
702 
703     /* ========== ADMINISTRATION FUNCTIONS ========== */
704 
705     /**
706       * @notice Performs ERC20 transfers from the contract address in batches; for each `i`,
707       *         transfers `quantities[i]` tokens from the contract to `recipients[i]`.
708       *         Allows the owner to perform transfers while the contract is paused.
709       *         Intended mainly to be used to disburse funds immediately after deployment.
710       * @param recipients An array of recipients.
711       * @param quantities A corresponding array of transfer quantities, in wei.
712       * @dev Exceptional conditions:
713       *          * The sender is not the contract's owner.
714       *          * The `recipients` and `quantities` arrays differ in length.
715       *          * The contract's balance is less than the transfer quantity.
716       *          * Any recipient is 0x0.
717       * @return Always returns true if no exception was thrown.
718       */
719     function contractBatchTransfer(address[] recipients, uint[] quantities)
720         external
721         onlyOwner
722         returns (bool)
723     {
724         return _batchTransfer(this, recipients, quantities);
725     }
726 
727 }