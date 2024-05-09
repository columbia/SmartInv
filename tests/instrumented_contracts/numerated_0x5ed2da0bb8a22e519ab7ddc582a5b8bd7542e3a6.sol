1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5 
6 
7 
8     uint256 constant internal MAX_UINT = 2 ** 256 - 1; // max uint256
9 
10 
11 
12     /**
13 
14      * @dev Multiplies two numbers, reverts on overflow.
15 
16      */
17 
18     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
19 
20         if (_a == 0) {
21 
22             return 0;
23 
24         }
25 
26         require(MAX_UINT / _a >= _b);
27 
28         return _a * _b;
29 
30     }
31 
32 
33 
34     /**
35 
36      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
37 
38      */
39 
40     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
41 
42         require(_b != 0);
43 
44         return _a / _b;
45 
46     }
47 
48 
49 
50     /**
51 
52      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53 
54      */
55 
56     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
57 
58         require(_b <= _a);
59 
60         return _a - _b;
61 
62     }
63 
64 
65 
66     /**
67 
68      * @dev Adds two numbers, reverts on overflow.
69 
70      */
71 
72     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
73 
74         require(MAX_UINT - _a >= _b);
75 
76         return _a + _b;
77 
78     }
79 
80 
81 
82 }
83 
84 
85 
86 
87 
88 contract Ownable {
89 
90     address public owner;
91 
92 
93 
94     event OwnershipTransferred(
95 
96         address indexed previousOwner,
97 
98         address indexed newOwner
99 
100     );
101 
102 
103 
104     /**
105 
106      * @dev Throws if called by any account other than the owner.
107 
108      */
109 
110     modifier onlyOwner() {
111 
112         require(msg.sender == owner);
113 
114         _;
115 
116     }
117 
118 
119 
120     /**
121 
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123 
124      * @param _newOwner The address to transfer ownership to.
125 
126      */
127 
128     function transferOwnership(address _newOwner) public onlyOwner {
129 
130         _transferOwnership(_newOwner);
131 
132     }
133 
134 
135 
136     /**
137 
138      * @dev Transfers control of the contract to a newOwner.
139 
140      * @param _newOwner The address to transfer ownership to.
141 
142      */
143 
144     function _transferOwnership(address _newOwner) internal {
145 
146         require(_newOwner != address(0));
147 
148         emit OwnershipTransferred(owner, _newOwner);
149 
150         owner = _newOwner;
151 
152     }
153 
154 }
155 
156 
157 
158 
159 
160 contract Pausable is Ownable {
161 
162     event Pause();
163 
164     event Unpause();
165 
166 
167 
168     bool public paused = false;
169 
170 
171 
172     /**
173 
174      * @dev Modifier to make a function callable only when the contract is not paused.
175 
176      */
177 
178     modifier whenNotPaused() {
179 
180         require(!paused);
181 
182         _;
183 
184     }
185 
186 
187 
188     /**
189 
190      * @dev Modifier to make a function callable only when the contract is paused.
191 
192      */
193 
194     modifier whenPaused() {
195 
196         require(paused);
197 
198         _;
199 
200     }
201 
202 
203 
204     /**
205 
206      * @dev called by the owner to pause, triggers stopped state
207 
208      */
209 
210     function pause() public onlyOwner whenNotPaused {
211 
212         paused = true;
213 
214         emit Pause();
215 
216     }
217 
218 
219 
220     /**
221 
222      * @dev called by the owner to unpause, returns to normal state
223 
224      */
225 
226     function unpause() public onlyOwner whenPaused {
227 
228         paused = false;
229 
230         emit Unpause();
231 
232     }
233 
234 }
235 
236 
237 
238 
239 
240 contract StandardToken {
241 
242     using SafeMath for uint256;
243 
244 
245 
246     mapping(address => uint256) internal balances;
247 
248 
249 
250     mapping(address => mapping(address => uint256)) internal allowed;
251 
252 
253 
254     uint256 internal totalSupply_;
255 
256 
257 
258     event Transfer(
259 
260         address indexed from,
261 
262         address indexed to,
263 
264         uint256 value
265 
266     );
267 
268 
269 
270     event Approval(
271 
272         address indexed owner,
273 
274         address indexed spender,
275 
276         uint256 vaule
277 
278     );
279 
280 
281 
282     /**
283 
284      * @dev Total number of tokens in existence
285 
286      */
287 
288     function totalSupply() public view returns(uint256) {
289 
290         return totalSupply_;
291 
292     }
293 
294 
295 
296     /**
297 
298      * @dev Gets the balance of the specified address.
299 
300      * @param _owner The address to query the the balance of.
301 
302      * @return An uint256 representing the amount owned by the passed address.
303 
304      */
305 
306     function balanceOf(address _owner) public view returns(uint256) {
307 
308         return balances[_owner];
309 
310     }
311 
312 
313 
314     /**
315 
316      * @dev Function to check the amount of tokens that an owner allowed to a spender.
317 
318      * @param _owner address The address which owns the funds.
319 
320      * @param _spender address The address which will spend the funds.
321 
322      * @return A uint256 specifying the amount of tokens still available for the spender.
323 
324      */
325 
326     function allowance(
327 
328         address _owner,
329 
330         address _spender
331 
332     )
333 
334     public
335 
336     view
337 
338     returns(uint256) {
339 
340         return allowed[_owner][_spender];
341 
342     }
343 
344 
345 
346     /**
347 
348      * @dev Transfer token for a specified address
349 
350      * @param _to The address to transfer to.
351 
352      * @param _value The amount to be transferred.
353 
354      */
355 
356     function transfer(address _to, uint256 _value) public returns(bool) {
357 
358         require(_to != address(0));
359 
360         require(_value <= balances[msg.sender]);
361 
362 
363 
364         balances[msg.sender] = balances[msg.sender].sub(_value);
365 
366         balances[_to] = balances[_to].add(_value);
367 
368         emit Transfer(msg.sender, _to, _value);
369 
370         return true;
371 
372     }
373 
374 
375 
376     /**
377 
378      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
379 
380      * Beware that changing an allowance with this method brings the risk that someone may use both the old
381 
382      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
383 
384      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
385 
386      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387 
388      * @param _spender The address which will spend the funds.
389 
390      * @param _value The amount of tokens to be spent.
391 
392      */
393 
394     function approve(address _spender, uint256 _value) public returns(bool) {
395 
396         allowed[msg.sender][_spender] = _value;
397 
398         emit Approval(msg.sender, _spender, _value);
399 
400         return true;
401 
402     }
403 
404 
405 
406     /**
407 
408      * @dev Transfer tokens from one address to another
409 
410      * @param _from address The address which you want to send tokens from
411 
412      * @param _to address The address which you want to transfer to
413 
414      * @param _value uint256 the amount of tokens to be transferred
415 
416      */
417 
418     function transferFrom(
419 
420         address _from,
421 
422         address _to,
423 
424         uint256 _value
425 
426     )
427 
428     public
429 
430     returns(bool) {
431 
432         require(_to != address(0));
433 
434         require(_value <= balances[_from]);
435 
436         require(_value <= allowed[_from][msg.sender]);
437 
438 
439 
440         balances[_from] = balances[_from].sub(_value);
441 
442         balances[_to] = balances[_to].add(_value);
443 
444         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
445 
446         emit Transfer(_from, _to, _value);
447 
448         return true;
449 
450     }
451 
452 
453 
454     /**
455 
456      * @dev Increase the amount of tokens that an owner allowed to a spender.
457 
458      * approve should be called when allowed[_spender] == 0. To increment
459 
460      * allowed value is better to use this function to avoid 2 calls (and wait until
461 
462      * the first transaction is mined)
463 
464      * From MonolithDAO Token.sol
465 
466      * @param _spender The address which will spend the funds.
467 
468      * @param _addedValue The amount of tokens to increase the allowance by.
469 
470      */
471 
472     function increaseApproval(
473 
474         address _spender,
475 
476         uint256 _addedValue
477 
478     )
479 
480     public
481 
482     returns(bool) {
483 
484         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
485 
486         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
487 
488         return true;
489 
490     }
491 
492 
493 
494     /**
495 
496      * @dev Decrease the amount of tokens that an owner allowed to a spender.
497 
498      * approve should be called when allowed[_spender] == 0. To decrement
499 
500      * allowed value is better to use this function to avoid 2 calls (and wait until
501 
502      * the first transaction is mined)
503 
504      * From MonolithDAO Token.sol
505 
506      * @param _spender The address which will spend the funds.
507 
508      * @param _subtractedValue The amount of tokens to decrease the allowance by.
509 
510      */
511 
512     function decreaseApproval(
513 
514         address _spender,
515 
516         uint256 _subtractedValue
517 
518     )
519 
520     public
521 
522     returns(bool) {
523 
524         uint256 oldValue = allowed[msg.sender][_spender];
525 
526         if (_subtractedValue >= oldValue) {
527 
528             allowed[msg.sender][_spender] = 0;
529 
530         } else {
531 
532             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
533 
534         }
535 
536         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
537 
538         return true;
539 
540     }
541 
542 
543 
544     function _burn(address account, uint256 value) internal {
545 
546         require(account != address(0));
547 
548         totalSupply_ = totalSupply_.sub(value);
549 
550         balances[account] = balances[account].sub(value);
551 
552         emit Transfer(account, address(0), value);
553 
554     }
555 
556 
557 
558     /**
559 
560      * @dev Internal function that burns an amount of the token of a given
561 
562      * account, deducting from the sender's allowance for said account. Uses the
563 
564      * internal burn function.
565 
566      * @param account The account whose tokens will be burnt.
567 
568      * @param value The amount that will be burnt.
569 
570      */
571 
572     function _burnFrom(address account, uint256 value) internal {
573 
574         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
575 
576         // this function needs to emit an event with the updated approval.
577 
578         allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
579 
580         _burn(account, value);
581 
582     }
583 
584 
585 
586 }
587 
588 
589 
590 
591 
592 contract BurnableToken is StandardToken {
593 
594 
595 
596     /**
597 
598      * @dev Burns a specific amount of tokens.
599 
600      * @param value The amount of token to be burned.
601 
602      */
603 
604     function burn(uint256 value) public {
605 
606         _burn(msg.sender, value);
607 
608     }
609 
610 
611 
612     /**
613 
614      * @dev Burns a specific amount of tokens from the target address and decrements allowance
615 
616      * @param from address The address which you want to send tokens from
617 
618      * @param value uint256 The amount of token to be burned
619 
620      */
621 
622     function burnFrom(address from, uint256 value) public {
623 
624         _burnFrom(from, value);
625 
626     }
627 
628 }
629 
630 
631 
632 
633 
634 contract PausableToken is StandardToken, Pausable {
635 
636 
637 
638     function transfer(
639 
640         address _to,
641 
642         uint256 _value
643 
644     )
645 
646     public
647 
648     whenNotPaused
649 
650     returns(bool) {
651 
652         return super.transfer(_to, _value);
653 
654     }
655 
656 
657 
658     function transferFrom(
659 
660         address _from,
661 
662         address _to,
663 
664         uint256 _value
665 
666     )
667 
668     public
669 
670     whenNotPaused
671 
672     returns(bool) {
673 
674         return super.transferFrom(_from, _to, _value);
675 
676     }
677 
678 
679 
680     function approve(
681 
682         address _spender,
683 
684         uint256 _value
685 
686     )
687 
688     public
689 
690     whenNotPaused
691 
692     returns(bool) {
693 
694         return super.approve(_spender, _value);
695 
696     }
697 
698 
699 
700     function increaseApproval(
701 
702         address _spender,
703 
704         uint _addedValue
705 
706     )
707 
708     public
709 
710     whenNotPaused
711 
712     returns(bool success) {
713 
714         return super.increaseApproval(_spender, _addedValue);
715 
716     }
717 
718 
719 
720     function decreaseApproval(
721 
722         address _spender,
723 
724         uint _subtractedValue
725 
726     )
727 
728     public
729 
730     whenNotPaused
731 
732     returns(bool success) {
733 
734         return super.decreaseApproval(_spender, _subtractedValue);
735 
736     }
737 
738 }
739 
740 
741 
742 
743 
744 contract TestToken is PausableToken, BurnableToken {
745 
746     string public name; // name of Token 
747 
748     string public symbol; // symbol of Token 
749 
750     uint8 public decimals;
751 
752 
753 
754     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _INIT_TOTALSUPPLY, address _owner) public {
755 
756         require(_owner != address(0));
757 
758         totalSupply_ = _INIT_TOTALSUPPLY * 10 ** uint256(_decimals);
759 
760         balances[_owner] = totalSupply_;
761 
762         name = _name;
763 
764         symbol = _symbol;
765 
766         decimals = _decimals;
767 
768         owner = _owner;
769         
770         emit Transfer(address(0), owner, totalSupply_);
771 
772     }
773 
774 }