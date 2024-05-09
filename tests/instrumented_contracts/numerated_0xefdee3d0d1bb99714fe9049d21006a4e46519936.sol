1 pragma solidity ^0.4.25;
2 
3 /*Zenoshi Dividend Contract Token
4 
5 Symbol: ZDT
6 
7 Version: 1.0
8 
9 */
10 
11 contract DSAuthority {
12 
13     function canCall(
14 
15         address src, address dst, bytes4 sig
16 
17     ) public view returns (bool);
18 
19 }
20 contract DSAuthEvents {
21 
22     event LogSetAuthority (address indexed authority);
23 
24     event LogSetOwner     (address indexed owner);
25 
26 }
27 contract DSAuth is DSAuthEvents {
28 
29     DSAuthority  public  authority;
30 
31     address      public  owner;
32 
33 
34 
35     constructor() public {
36 
37         owner = msg.sender;
38 
39         emit LogSetOwner(msg.sender);
40 
41     }
42 
43 
44 
45     function setOwner(address owner_)
46 
47         public
48 
49         auth
50 
51     {
52 
53         owner = owner_;
54 
55         emit LogSetOwner(owner);
56 
57     }
58 
59 
60 
61     function setAuthority(DSAuthority authority_)
62 
63         public
64 
65         auth
66 
67     {
68 
69         authority = authority_;
70 
71         emit LogSetAuthority(authority);
72 
73     }
74 
75 
76 
77     modifier auth {
78 
79         require(isAuthorized(msg.sender, msg.sig));
80 
81         _;
82 
83     }
84 
85 
86 
87     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
88 
89         if (src == address(this)) {
90 
91             return true;
92 
93         } else if (src == owner) {
94 
95             return true;
96 
97         } else if (authority == DSAuthority(0)) {
98 
99             return false;
100 
101         } else {
102 
103             return authority.canCall(src, this, sig);
104 
105         }
106 
107     }
108 
109 }
110 
111 
112 
113 
114 
115 contract DSMath {
116 
117     function add(uint x, uint y) internal pure returns (uint z) {
118 
119         require((z = x + y) >= x);
120 
121     }
122 
123     function sub(uint x, uint y) internal pure returns (uint z) {
124 
125         require((z = x - y) <= x);
126 
127     }
128 
129     function mul(uint x, uint y) internal pure returns (uint z) {
130 
131         require(y == 0 || (z = x * y) / y == x);
132 
133     }
134 
135 
136 
137     function min(uint x, uint y) internal pure returns (uint z) {
138 
139         return x <= y ? x : y;
140 
141     }
142 
143     function max(uint x, uint y) internal pure returns (uint z) {
144 
145         return x >= y ? x : y;
146 
147     }
148 
149     function imin(int x, int y) internal pure returns (int z) {
150 
151         return x <= y ? x : y;
152 
153     }
154 
155     function imax(int x, int y) internal pure returns (int z) {
156 
157         return x >= y ? x : y;
158 
159     }
160 
161 
162 
163     uint constant WAD = 10 ** 18;
164 
165     uint constant RAY = 10 ** 27;
166 
167 
168 
169     function wmul(uint x, uint y) internal pure returns (uint z) {
170 
171         z = add(mul(x, y), WAD / 2) / WAD;
172 
173     }
174 
175     function rmul(uint x, uint y) internal pure returns (uint z) {
176 
177         z = add(mul(x, y), RAY / 2) / RAY;
178 
179     }
180 
181     function wdiv(uint x, uint y) internal pure returns (uint z) {
182 
183         z = add(mul(x, WAD), y / 2) / y;
184 
185     }
186 
187     function rdiv(uint x, uint y) internal pure returns (uint z) {
188 
189         z = add(mul(x, RAY), y / 2) / y;
190 
191     }
192 
193 
194 
195     // This famous algorithm is called "exponentiation by squaring"
196 
197     // and calculates x^n with x as fixed-point and n as regular unsigned.
198 
199     //
200 
201     // It's O(log n), instead of O(n) for naive repeated multiplication.
202 
203     //
204 
205     // These facts are why it works:
206 
207     //
208 
209     //  If n is even, then x^n = (x^2)^(n/2).
210 
211     //  If n is odd,  then x^n = x * x^(n-1),
212 
213     //   and applying the equation for even x gives
214 
215     //    x^n = x * (x^2)^((n-1) / 2).
216 
217     //
218 
219     //  Also, EVM division is flooring and
220 
221     //    floor[(n-1) / 2] = floor[n / 2].
222 
223     //
224 
225     function rpow(uint x, uint n) internal pure returns (uint z) {
226 
227         z = n % 2 != 0 ? x : RAY;
228 
229 
230 
231         for (n /= 2; n != 0; n /= 2) {
232 
233             x = rmul(x, x);
234 
235 
236 
237             if (n % 2 != 0) {
238 
239                 z = rmul(z, x);
240 
241             }
242 
243         }
244 
245     }
246 
247 }
248 
249 
250 
251 contract ERC20Events {
252 
253     event Approval(address indexed src, address indexed guy, uint wad);
254 
255     event Transfer(address indexed src, address indexed dst, uint wad);
256 
257 }
258 
259 
260 
261 contract ERC20 is ERC20Events {
262 
263     function totalSupply() public view returns (uint);
264 
265     function balanceOf(address guy) public view returns (uint);
266 
267     function allowance(address src, address guy) public view returns (uint);
268 
269 
270 
271     function approve(address guy, uint wad) public returns (bool);
272 
273     function transfer(address dst, uint wad) public returns (bool);
274 
275     function transferFrom(
276 
277         address src, address dst, uint wad
278 
279     ) public returns (bool);
280 
281 }
282 
283 
284 
285 contract DSTokenBase is ERC20, DSMath {
286 
287     uint256                                            _supply;
288 
289     mapping (address => uint256)                       _balances;
290 
291     mapping (address => mapping (address => uint256))  _approvals;
292 
293 
294 
295     constructor(uint supply) public {
296 
297         _balances[msg.sender] = supply;
298 
299         _supply = supply;
300 
301     }
302 
303 
304 
305  /**
306 
307   * @dev Total number of tokens in existence
308 
309   */
310 
311     function totalSupply() public view returns (uint) {
312 
313         return _supply;
314 
315     }
316 
317 
318 
319  /**
320 
321   * @dev Gets the balance of the specified address.
322 
323   * @param src The address to query the balance of.
324 
325   * @return An uint256 representing the amount owned by the passed address.
326 
327   */
328 
329 
330 
331     function balanceOf(address src) public view returns (uint) {
332 
333         return _balances[src];
334 
335     }
336 
337 
338 
339  /**
340 
341    * @dev Function to check the amount of tokens that an owner allowed to a spender.
342 
343    * @param src address The address which owns the funds.
344 
345    * @param guy address The address which will spend the funds.
346 
347    */
348 
349     function allowance(address src, address guy) public view returns (uint) {
350 
351         return _approvals[src][guy];
352 
353     }
354 
355 
356 
357   /**
358 
359    * @dev Transfer token for a specified address
360 
361    * @param dst The address to transfer to.
362 
363    * @param wad The amount to be transferred.
364 
365    */
366 
367 
368 
369     function transfer(address dst, uint wad) public returns (bool) {
370 
371         return transferFrom(msg.sender, dst, wad);
372 
373     }
374 
375 
376 
377  /**
378 
379    * @dev Transfer tokens from one address to another
380 
381    * @param src address The address which you want to send tokens from
382 
383    * @param dst address The address which you want to transfer to
384 
385    * @param wad uint256 the amount of tokens to be transferred
386 
387    */
388 
389 
390 
391     function transferFrom(address src, address dst, uint wad)
392 
393         public
394 
395         returns (bool)
396 
397     {
398 
399         if (src != msg.sender) {
400 
401             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
402 
403         }
404 
405 
406 
407         _balances[src] = sub(_balances[src], wad);
408 
409         _balances[dst] = add(_balances[dst], wad);
410 
411 
412 
413         emit Transfer(src, dst, wad);
414 
415 
416 
417         return true;
418 
419     }
420 
421 
422 
423 
424 
425  /**
426 
427    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
428 
429    * Beware that changing an allowance with this method brings the risk that someone may use both the old
430 
431    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
432 
433    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
434 
435    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
436 
437    * @param guy The address which will spend the funds.
438 
439    * @param wad The amount of tokens to be spent.
440 
441    */
442 
443 
444 
445     function approve(address guy, uint wad) public returns (bool) {
446 
447         _approvals[msg.sender][guy] = wad;
448 
449 
450 
451         emit Approval(msg.sender, guy, wad);
452 
453 
454 
455         return true;
456 
457     }
458 
459 
460 
461  /**
462 
463    * @dev Increase the amount of tokens that an owner allowed to a spender.
464 
465    * approve should be called when allowed_[_spender] == 0. To increment
466 
467    * allowed value is better to use this function to avoid 2 calls (and wait until
468 
469    * the first transaction is mined)
470 
471    * From MonolithDAO Token.sol
472 
473    * @param src The address which will spend the funds.
474 
475    * @param wad The amount of tokens to increase the allowance by.
476 
477    */
478 
479   function increaseAllowance(
480 
481     address src,
482 
483     uint256 wad
484 
485   )
486 
487     public
488 
489     returns (bool)
490 
491   {
492 
493     require(src != address(0));
494 
495 
496 
497     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
498 
499     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
500 
501     return true;
502 
503   }
504 
505 
506 
507  /**
508 
509    * @dev Decrese the amount of tokens that an owner allowed to a spender.
510 
511    * approve should be called when allowed_[_spender] == 0. To increment
512 
513    * allowed value is better to use this function to avoid 2 calls (and wait until
514 
515    * the first transaction is mined)
516 
517    * From MonolithDAO Token.sol
518 
519    * @param src The address which will spend the funds.
520 
521    * @param wad The amount of tokens to increase the allowance by.
522 
523    */
524 
525   function decreaseAllowance(
526 
527     address src,
528 
529     uint256 wad
530 
531   )
532 
533     public
534 
535     returns (bool)
536 
537   {
538 
539     require(src != address(0));
540 
541     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
542 
543     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
544 
545     return true;
546 
547   }
548 
549 
550 
551 }
552 
553 
554 
555 contract DSNote {
556 
557     event LogNote(
558 
559         bytes4   indexed  sig,
560 
561         address  indexed  guy,
562 
563         bytes32  indexed  foo,
564 
565         bytes32  indexed  bar,
566 
567         uint              wad,
568 
569         bytes             fax
570 
571     ) anonymous;
572 
573 
574 
575     modifier note {
576 
577         bytes32 foo;
578 
579         bytes32 bar;
580 
581 
582 
583         assembly {
584 
585             foo := calldataload(4)
586 
587             bar := calldataload(36)
588 
589         }
590 
591 
592 
593         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
594 
595 
596 
597         _;
598 
599     }
600 
601 }
602 
603 
604 
605 contract DSStop is DSNote, DSAuth {
606 
607 
608 
609     bool public stopped;
610 
611 
612 
613     modifier stoppable {
614 
615         require(!stopped);
616 
617         _;
618 
619     }
620 
621     function stop() public auth note {
622 
623         stopped = true;
624 
625     }
626 
627     function start() public auth note {
628 
629         stopped = false;
630 
631     }
632 
633 
634 
635 }
636 
637 
638 
639 
640 
641 contract ZDTToken is DSTokenBase , DSStop {
642 
643 
644 
645     string  public  symbol="ZDT";
646 
647     string  public  name="Zenoshi Dividend Token";
648 
649     uint256  public  decimals = 8; // Token Precision every token is 1.00000000
650 
651     uint256 public initialSupply=90000000000000000;// 900000000+8 zeros for decimals
652 
653     address public burnAdmin;
654 
655     constructor() public
656 
657     DSTokenBase(initialSupply)
658 
659     {
660 
661         burnAdmin=msg.sender;
662 
663     }
664 
665 
666 
667     event Burn(address indexed guy, uint wad);
668 
669 
670 
671  /**
672 
673    * @dev Throws if called by any account other than the owner.
674 
675    */
676 
677   modifier onlyAdmin() {
678 
679     require(isAdmin());
680 
681     _;
682 
683   }
684 
685 
686 
687   /**
688 
689    * @return true if `msg.sender` is the owner of the contract.
690 
691    */
692 
693   function isAdmin() public view returns(bool) {
694 
695     return msg.sender == burnAdmin;
696 
697 }
698 
699 
700 
701 /**
702 
703    * @dev Allows the current owner to relinquish control of the contract.
704 
705    * @notice Renouncing to ownership will leave the contract without an owner.
706 
707    * It will not be possible to call the functions with the `onlyOwner`
708 
709    * modifier anymore.
710 
711    */
712 
713   function renounceOwnership() public onlyAdmin {
714 
715     burnAdmin = address(0);
716 
717   }
718 
719 
720 
721     function approve(address guy) public stoppable returns (bool) {
722 
723         return super.approve(guy, uint(-1));
724 
725     }
726 
727 
728 
729     function approve(address guy, uint wad) public stoppable returns (bool) {
730 
731         return super.approve(guy, wad);
732 
733     }
734 
735 
736 
737     function transferFrom(address src, address dst, uint wad)
738 
739         public
740 
741         stoppable
742 
743         returns (bool)
744 
745     {
746 
747         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
748 
749             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
750 
751         }
752 
753 
754 
755         _balances[src] = sub(_balances[src], wad);
756 
757         _balances[dst] = add(_balances[dst], wad);
758 
759 
760 
761         emit Transfer(src, dst, wad);
762 
763 
764 
765         return true;
766 
767     }
768 
769 
770 
771 
772 
773 
774 
775     /**
776 
777    * @dev Burns a specific amount of tokens from the target address
778 
779    * @param guy address The address which you want to send tokens from
780 
781    * @param wad uint256 The amount of token to be burned
782 
783    */
784 
785     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
786 
787         require(guy != address(0));
788 
789 
790 
791 
792 
793         _balances[guy] = sub(_balances[guy], wad);
794 
795         _supply = sub(_supply, wad);
796 
797 
798 
799         emit Burn(guy, wad);
800 
801         emit Transfer(guy, address(0), wad);
802 
803     }
804 
805 
806 
807 
808 
809 }