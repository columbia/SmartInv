1 pragma solidity ^0.4.13;
2 
3 
4 
5 
6 interface ERC20Interface {
7 function totalSupply() external view returns (uint256);
8 
9 
10 
11 
12 function balanceOf(address who) external view returns (uint256);
13 
14 
15 
16 
17 function allowance(address owner, address spender)
18 external view returns (uint256);
19 
20 
21 
22 
23 function transfer(address to, uint256 value) external returns (bool);
24 
25 
26 
27 
28 function approve(address spender, uint256 value)
29 external returns (bool);
30 
31 
32 
33 
34 function transferFrom(address from, address to, uint256 value)
35 external returns (bool);
36 
37 
38 
39 
40 event Transfer(
41 address indexed from,
42 address indexed to,
43 uint256 value
44 );
45 
46 
47 
48 
49 event Approval(
50 address indexed owner,
51 address indexed spender,
52 uint256 value
53 );
54 }
55 
56 
57 
58 
59 contract OpsCoin is ERC20Interface {
60 
61 
62 
63 
64 /**
65 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
66 */
67 
68 
69 
70 
71 using SafeMath for uint256;
72 
73 
74 
75 
76 string public symbol;
77 string public name;
78 address public owner;
79 uint256 public totalSupply;
80 
81 
82 
83 
84 
85 
86 
87 
88 mapping (address => uint256) private balances;
89 mapping (address => mapping (address => uint256)) private allowed;
90 mapping (address => mapping (address => uint)) private timeLock;
91 
92 
93 
94 
95 
96 
97 
98 
99 constructor() {
100 symbol = "OPS";
101 name = "EY OpsCoin";
102 totalSupply = 1000000;
103 owner = msg.sender;
104 balances[owner] = totalSupply;
105 emit Transfer(address(0), owner, totalSupply);
106 }
107 
108 
109 
110 
111 //only owner  modifier
112 modifier onlyOwner () {
113 require(msg.sender == owner);
114 _;
115 }
116 
117 
118 
119 
120 /**
121 self destruct added by westlad
122 */
123 function close() public onlyOwner {
124 selfdestruct(owner);
125 }
126 
127 
128 
129 
130 /**
131 * @dev Gets the balance of the specified address.
132 * @param _address The address to query the balance of.
133 * @return An uint256 representing the amount owned by the passed address.
134 */
135 function balanceOf(address _address) public view returns (uint256) {
136 return balances[_address];
137 }
138 
139 
140 
141 
142 /**
143 * @dev Function to check the amount of tokens that an owner allowed to a spender.
144 * @param _owner address The address which owns the funds.
145 * @param _spender address The address which will spend the funds.
146 * @return A uint256 specifying the amount of tokens still available for the spender.
147 */
148 function allowance(address _owner, address _spender) public view returns (uint256)
149 {
150 return allowed[_owner][_spender];
151 }
152 
153 
154 
155 
156 /**
157 * @dev Total number of tokens in existence
158 */
159 function totalSupply() public view returns (uint256) {
160 return totalSupply;
161 }
162 
163 
164 
165 
166 
167 
168 
169 
170 /**
171 * @dev Internal function that mints an amount of the token and assigns it to
172 * an account. This encapsulates the modification of balances such that the
173 * proper events are emitted.
174 * @param _account The account that will receive the created tokens.
175 * @param _amount The amount that will be created.
176 */
177 function mint(address _account, uint256 _amount) public {
178 require(_account != 0);
179 require(_amount > 0);
180 totalSupply = totalSupply.add(_amount);
181 balances[_account] = balances[_account].add(_amount);
182 emit Transfer(address(0), _account, _amount);
183 }
184 
185 
186 
187 
188 /**
189 * @dev Internal function that burns an amount of the token of a given
190 * account.
191 * @param _account The account whose tokens will be burnt.
192 * @param _amount The amount that will be burnt.
193 */
194 function burn(address _account, uint256 _amount) public {
195 require(_account != 0);
196 require(_amount <= balances[_account]);
197 
198 
199 
200 
201 totalSupply = totalSupply.sub(_amount);
202 balances[_account] = balances[_account].sub(_amount);
203 emit Transfer(_account, address(0), _amount);
204 }
205 
206 
207 
208 
209 /**
210 * @dev Internal function that burns an amount of the token of a given
211 * account, deducting from the sender's allowance for said account. Uses the
212 * internal burn function.
213 * @param _account The account whose tokens will be burnt.
214 * @param _amount The amount that will be burnt.
215 */
216 function burnFrom(address _account, uint256 _amount) public {
217 require(_amount <= allowed[_account][msg.sender]);
218 
219 
220 
221 
222 allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
223 emit Approval(_account, msg.sender, allowed[_account][msg.sender]);
224 burn(_account, _amount);
225 }
226 
227 
228 
229 
230 /**
231 * @dev Transfer token for a specified address
232 * @param _to The address to transfer to.
233 * @param _value The amount to be transferred.
234 */
235 function transfer(address _to, uint256 _value) public returns (bool) {
236 require(_value <= balances[msg.sender]);
237 require(_to != address(0));
238 
239 
240 
241 
242 balances[msg.sender] = balances[msg.sender].sub(_value);
243 balances[_to] = balances[_to].add(_value);
244 emit Transfer(msg.sender, _to, _value);
245 return true;
246 }
247 
248 
249 
250 
251 /**
252 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253 * Beware that changing an allowance with this method brings the risk that someone may use both the old
254 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257 * @param _spender The address which will spend the funds.
258 * @param _value The amount of tokens to be spent.
259 */
260 function approve(address _spender, uint256 _value) public returns (bool) {
261 require(_spender != address(0));
262 
263 
264 
265 
266 allowed[msg.sender][_spender] = _value;
267 emit Approval(msg.sender, _spender, _value);
268 return true;
269 }
270 
271 
272 
273 
274 /**
275 * @dev Approve the passed address to spend the specified amount of tokens after a specfied amount of time on behalf of msg.sender.
276 * Beware that changing an allowance with this method brings the risk that someone may use both the old
277 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280 * @param _spender The address which will spend the funds.
281 * @param _value The amount of tokens to be spent.
282 * @param _timeLockTill The time until when this amount cannot be withdrawn
283 */
284 function approveAt(address _spender, uint256 _value, uint _timeLockTill) public returns (bool) {
285 require(_spender != address(0));
286 
287 
288 
289 
290 allowed[msg.sender][_spender] = _value;
291 timeLock[msg.sender][_spender] = _timeLockTill;
292 emit Approval(msg.sender, _spender, _value);
293 return true;
294 }
295 
296 
297 
298 
299 /**
300 * @dev Transfer tokens from one address to another
301 * @param _from address The address which you want to send tokens from
302 * @param _to address The address which you want to transfer to
303 * @param _value uint256 the amount of tokens to be transferred
304 */
305 function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
306 {
307 require(_value <= balances[_from]);
308 require(_value <= allowed[_from][msg.sender]);
309 require(_to != address(0));
310 
311 
312 
313 
314 balances[_from] = balances[_from].sub(_value);
315 balances[_to] = balances[_to].add(_value);
316 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317 emit Transfer(_from, _to, _value);
318 return true;
319 }
320 
321 
322 
323 
324 /**
325 * @dev Transfer tokens from one address to another
326 * @param _from address The address which you want to send tokens from
327 * @param _to address The address which you want to transfer to
328 * @param _value uint256 the amount of tokens to be transferred
329 */
330 function transferFromAt(address _from, address _to, uint256 _value) public returns (bool)
331 {
332 require(_value <= balances[_from]);
333 require(_value <= allowed[_from][msg.sender]);
334 require(_to != address(0));
335 require(block.timestamp > timeLock[_from][msg.sender]);
336 
337 
338 
339 
340 balances[_from] = balances[_from].sub(_value);
341 balances[_to] = balances[_to].add(_value);
342 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
343 emit Transfer(_from, _to, _value);
344 return true;
345 }
346 
347 
348 
349 
350 /**
351 * @dev Increase the amount of tokens that an owner allowed to a spender.
352 * approve should be called when allowed_[_spender] == 0. To increment
353 * allowed value is better to use this function to avoid 2 calls (and wait until
354 * the first transaction is mined)
355 * From MonolithDAO Token.sol
356 * @param _spender The address which will spend the funds.
357 * @param _addedValue The amount of tokens to increase the allowance by.
358 */
359 function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool)
360 {
361 require(_spender != address(0));
362 
363 
364 
365 
366 allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
367 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
368 return true;
369 }
370 
371 
372 
373 
374 /**
375 * @dev Decrease the amount of tokens that an owner allowed to a spender.
376 * approve should be called when allowed_[_spender] == 0. To decrement
377 * allowed value is better to use this function to avoid 2 calls (and wait until
378 * the first transaction is mined)
379 * From MonolithDAO Token.sol
380 * @param _spender The address which will spend the funds.
381 * @param _subtractedValue The amount of tokens to decrease the allowance by.
382 */
383 function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool)
384 {
385 require(_spender != address(0));
386 
387 
388 
389 
390 allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].sub(_subtractedValue));
391 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392 return true;
393 }
394 
395 
396 
397 
398 }
399 
400 
401 
402 
403 contract Verifier{
404 function verifyTx(
405 uint[2],
406 uint[2],
407 uint[2][2],
408 uint[2],
409 uint[2],
410 uint[2],
411 uint[2],
412 uint[2],
413 address
414 ) public pure returns (bool){}
415 
416 
417 
418 
419 /**
420 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
421 */
422 function getInputBits(uint, address) public view returns(bytes8){}
423 }
424 
425 
426 
427 
428 contract OpsCoinShield{
429 
430 
431 
432 
433 /**
434 @notice © Copyright 2018 EYGS LLP and/or other members of the global Ernst & Young/EY network; pat. pending.
435 
436 
437 
438 
439 Contract to enable the management of ZKSnark-hidden coin transactions.
440 */
441 
442 
443 
444 
445 address public owner;
446 bytes8[merkleWidth] ns; //store spent token nullifiers
447 uint constant merkleWidth = 256;
448 uint constant merkleDepth = 9;
449 uint constant lastRow = merkleDepth-1;
450 uint private balance = 0;
451 bytes8[merkleWidth] private zs; //array holding the commitments.  Basically the bottom row of the merkle tree
452 uint private zCount; //remember the number of commitments we hold
453 uint private nCount; //remember the number of commitments we spent
454 bytes8[] private roots; //holds each root we've calculated so that we can pull the one relevant to the prover
455 uint private currentRootIndex; //holds the index for the current root so that the
456 //prover can provide it later and this contract can look up the relevant root
457 Verifier private mv; //the verification smart contract that the mint function uses
458 Verifier private sv; //the verification smart contract that the transfer function uses
459 OpsCoin private ops; //the OpsCoin ERC20-like token contract
460 struct Proof { //recast this as a struct because otherwise, as a set of local variable, it takes too much stack space
461 uint[2] a;
462 uint[2] a_p;
463 uint[2][2] b;
464 uint[2] b_p;
465 uint[2] c;
466 uint[2] c_p;
467 uint[2] h;
468 uint[2] k;
469 }
470 //Proof proof; //not used - proof is now set per address
471 mapping(address => Proof) private proofs;
472 
473 
474 
475 
476 constructor(address mintVerifier, address transferVerifier, address opsCoin) public {
477 // TODO - you can get a way with a single, generic verifier.
478 owner = msg.sender;
479 mv = Verifier(mintVerifier);
480 sv = Verifier(transferVerifier);
481 ops = OpsCoin(opsCoin);
482 }
483 
484 
485 
486 
487 //only owner  modifier
488 modifier onlyOwner () {
489 require(msg.sender == owner);
490 _;
491 }
492 
493 
494 
495 
496 /**
497 self destruct added by westlad
498 */
499 function close() public onlyOwner {
500 selfdestruct(owner);
501 }
502 
503 
504 
505 
506 
507 
508 
509 
510 function getMintVerifier() public view returns(address){
511 return address(mv);
512 }
513 
514 
515 
516 
517 function getTransferVerifier() public view returns(address){
518 return address(sv);
519 }
520 
521 
522 
523 
524 function getOpsCoin() public view returns(address){
525 return address(ops);
526 }
527 
528 
529 
530 
531 /**
532 The mint function accepts opscoin and creates the same amount as a commitment.
533 */
534 function mint(uint amount) public {
535 //first, verify the proof
536 
537 
538 
539 
540 bool result = mv.verifyTx(
541 proofs[msg.sender].a,
542 proofs[msg.sender].a_p,
543 proofs[msg.sender].b,
544 proofs[msg.sender].b_p,
545 proofs[msg.sender].c,
546 proofs[msg.sender].c_p,
547 proofs[msg.sender].h,
548 proofs[msg.sender].k,
549 msg.sender);
550 
551 
552 
553 
554 require(result); //the proof must check out
555 //transfer OPS from the sender to this contract
556 ops.transferFrom(msg.sender, address(this), amount);
557 //save the commitments
558 bytes8 z = mv.getInputBits(64, msg.sender);//recover the input params from MintVerifier
559 zs[zCount++] = z; //add the token
560 require(uint(mv.getInputBits(0, msg.sender))==amount); //check we've been correctly paid
561 bytes8 root = merkle(0,0); //work out the Merkle root as it's now different
562 currentRootIndex = roots.push(root)-1; //and save it to the list
563 }
564 
565 
566 
567 
568 /**
569 The transfer function transfers a commitment to a new owner
570 */
571 function transfer() public {
572 //verification contract
573 bool result = sv.verifyTx(
574 proofs[msg.sender].a,
575 proofs[msg.sender].a_p,
576 proofs[msg.sender].b,
577 proofs[msg.sender].b_p,
578 proofs[msg.sender].c,
579 proofs[msg.sender].c_p,
580 proofs[msg.sender].h,
581 proofs[msg.sender].k,
582 msg.sender);
583 require(result); //the proof must verify. The spice must flow.
584 
585 
586 
587 
588 bytes8 nc = sv.getInputBits(0, msg.sender);
589 bytes8 nd = sv.getInputBits(64, msg.sender);
590 bytes8 ze = sv.getInputBits(128, msg.sender);
591 bytes8 zf = sv.getInputBits(192, msg.sender);
592 for (uint i=0; i<nCount; i++) { //check this is an unspent coin
593 require(ns[i]!=nc && ns[i]!=nd);
594 }
595 ns[nCount++] = nc; //remember we spent it
596 ns[nCount++] = nd; //remember we spent it
597 zs[zCount++] = ze; //add Bob's commitment to the list of commitments
598 zs[zCount++] = zf; //add Alice's commitment to the list of commitment
599 bytes8 root = merkle(0,0); //work out the Merkle root as it's now different
600 currentRootIndex = roots.push(root)-1; //and save it to the list
601 }
602 
603 
604 
605 
606 function burn(address payTo) public {
607 //first, verify the proof
608 bool result = mv.verifyTx(
609 proofs[msg.sender].a,
610 proofs[msg.sender].a_p,
611 proofs[msg.sender].b,
612 proofs[msg.sender].b_p,
613 proofs[msg.sender].c,
614 proofs[msg.sender].c_p,
615 proofs[msg.sender].h,
616 proofs[msg.sender].k,
617 msg.sender);
618 
619 
620 
621 
622 require(result); //the proof must check out ok
623 //transfer OPS from this contract to the nominated address
624 bytes8 C = mv.getInputBits(0, msg.sender);//recover the coin value
625 uint256 value = uint256(C); //convert the coin value to a uint
626 ops.transfer(payTo, value); //and pay the man
627 bytes8 Nc = mv.getInputBits(64, msg.sender); //recover the nullifier
628 ns[nCount++] = Nc; //add the nullifier to the list of nullifiers
629 bytes8 root = merkle(0,0); //work out the Merkle root as it's now different
630 currentRootIndex = roots.push(root)-1; //and save it to the list
631 }
632 
633 
634 
635 
636 /**
637 This function is only needed because mint and transfer otherwise use too many
638 local variables for the limited stack space, rather than pass a proof as
639 parameters to these functions (more logical)
640 */
641 function setProofParams(
642 uint[2] a,
643 uint[2] a_p,
644 uint[2][2] b,
645 uint[2] b_p,
646 uint[2] c,
647 uint[2] c_p,
648 uint[2] h,
649 uint[2] k)
650 public {
651 //TODO there must be a shorter way to do this:
652 proofs[msg.sender].a[0] = a[0];
653 proofs[msg.sender].a[1] = a[1];
654 proofs[msg.sender].a_p[0] = a_p[0];
655 proofs[msg.sender].a_p[1] = a_p[1];
656 proofs[msg.sender].b[0][0] = b[0][0];
657 proofs[msg.sender].b[0][1] = b[0][1];
658 proofs[msg.sender].b[1][0] = b[1][0];
659 proofs[msg.sender].b[1][1] = b[1][1];
660 proofs[msg.sender].b_p[0] = b_p[0];
661 proofs[msg.sender].b_p[1] = b_p[1];
662 proofs[msg.sender].c[0] = c[0];
663 proofs[msg.sender].c[1] = c[1];
664 proofs[msg.sender].c_p[0] = c_p[0];
665 proofs[msg.sender].c_p[1] = c_p[1];
666 proofs[msg.sender].h[0] = h[0];
667 proofs[msg.sender].h[1] = h[1];
668 proofs[msg.sender].k[0] = k[0];
669 proofs[msg.sender].k[1] = k[1];
670 }
671 
672 
673 
674 
675 function getTokens() public view returns(bytes8[merkleWidth], uint root) {
676 //need the commitments to compute a proof and also an index to look up the current
677 //root.
678 return (zs,currentRootIndex);
679 }
680 
681 
682 
683 
684 /**
685 Function to return the root that was current at rootIndex
686 */
687 function getRoot(uint rootIndex) view public returns(bytes8) {
688 return roots[rootIndex];
689 }
690 
691 
692 
693 
694 function computeMerkle() public view returns (bytes8){//for backwards compat
695 return merkle(0,0);
696 }
697 
698 
699 
700 
701 function merkle(uint r, uint t) public view returns (bytes8) {
702 //This is a recursive approach, which seems efficient but we do end up
703 //calculating the whole tree from scratch each time.  Need to look at storing
704 //intermediate values and seeing if that will make it cheaper.
705 if (r==lastRow) {
706 return zs[t];
707 } else {
708 return bytes8(sha256(merkle(r+1,2*t)^merkle(r+1,2*t+1))<<192);
709 }
710 }
711 }
712 
713 
714 
715 
716 library SafeMath {
717 
718 
719 
720 
721 /**
722 * @dev Multiplies two numbers, reverts on overflow.
723 */
724 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
725 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
726 // benefit is lost if 'b' is also tested.
727 // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
728 if (a == 0) {
729 return 0;
730 }
731 
732 
733 
734 
735 uint256 c = a * b;
736 require(c / a == b);
737 
738 
739 
740 
741 return c;
742 }
743 
744 
745 
746 
747 /**
748 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
749 */
750 function div(uint256 a, uint256 b) internal pure returns (uint256) {
751 require(b > 0); // Solidity only automatically asserts when dividing by 0
752 uint256 c = a / b;
753 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
754 
755 
756 
757 
758 return c;
759 }
760 
761 
762 
763 
764 /**
765 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
766 */
767 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
768 require(b <= a);
769 uint256 c = a - b;
770 
771 
772 
773 
774 return c;
775 }
776 
777 
778 
779 
780 /**
781 * @dev Adds two numbers, reverts on overflow.
782 */
783 function add(uint256 a, uint256 b) internal pure returns (uint256) {
784 uint256 c = a + b;
785 require(c >= a);
786 
787 
788 
789 
790 return c;
791 }
792 
793 
794 
795 
796 /**
797 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
798 * reverts when dividing by zero.
799 */
800 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
801 require(b != 0);
802 return a % b;
803 }
804 }