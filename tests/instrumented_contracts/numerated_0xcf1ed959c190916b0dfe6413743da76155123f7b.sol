1 pragma solidity ^0.4.23;
2 
3  
4 
5  
6 
7  
8 
9 contract owned {
10 
11  
12 
13     address public owner;
14 
15  
16 
17  
18 
19  
20 
21     function owned() public {
22 
23  
24 
25         owner = msg.sender;
26 
27  
28 
29     }
30 
31  
32 
33  
34 
35  
36 
37     modifier onlyOwner {
38 
39  
40 
41         require(msg.sender == owner);
42 
43  
44 
45         _;
46 
47  
48 
49     }
50 
51  
52 
53  
54 
55  
56 
57     function transferOwnership(address newOwner) onlyOwner public {
58 
59  
60 
61         owner = newOwner;
62 
63  
64 
65     }
66 
67  
68 
69 }
70 
71  
72 
73  
74 
75  
76 
77 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
78 
79  
80 
81  
82 
83  
84 
85 contract TokenERC20 {
86 
87  
88 
89     // Public variables of the token
90 
91  
92 
93     string public name = "Yumerium Token";
94 
95  
96 
97     string public symbol = "YUM";
98 
99  
100 
101     uint8 public decimals = 8;
102 
103  
104 
105     uint256 public totalSupply = 808274854 * 10 ** uint256(decimals);
106 
107  
108 
109  
110 
111     // This creates an array with all balances
112 
113  
114 
115     mapping (address => uint256) public balanceOf;
116 
117  
118 
119     mapping (address => mapping (address => uint256)) public allowance;
120 
121  
122     
123  
124 
125  
126 
127     // This generates a public event on the blockchain that will notify clients
128 
129  
130 
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133  
134 
135  
136 
137  
138 
139     // This notifies clients about the amount burnt
140 
141  
142 
143     event Burn(address indexed from, uint256 value);
144 
145  
146 
147  
148 
149  
150 
151     /**
152 
153  
154 
155      * Constrctor function
156 
157  
158 
159      *
160 
161  
162 
163      * Initializes contract with initial supply tokens to the creator of the contract
164 
165  
166 
167      */
168 
169  
170 
171     
172 
173  
174 
175  
176 
177  
178 
179     /**
180 
181  
182 
183      * Internal transfer, only can be called by this contract
184 
185  
186 
187      */
188 
189  
190 
191     function _transfer(address _from, address _to, uint _value) internal {
192 
193  
194 
195         // Prevent transfer to 0x0 address. Use burn() instead
196 
197  
198 
199         require(_to != 0x0);
200 
201  
202 
203         // Check if the sender has enough
204 
205  
206 
207         require(balanceOf[_from] >= _value);
208 
209  
210 
211         // Check for overflows
212 
213  
214 
215         require(balanceOf[_to] + _value > balanceOf[_to]);
216 
217  
218 
219         // Save this for an assertion in the future
220 
221  
222 
223         uint previousBalances = balanceOf[_from] + balanceOf[_to];
224 
225  
226 
227         // Subtract from the sender
228 
229  
230 
231         balanceOf[_from] -= _value;
232 
233  
234 
235         // Add the same to the recipient
236 
237  
238 
239         balanceOf[_to] += _value;
240 
241  
242 
243         Transfer(_from, _to, _value);
244 
245  
246 
247         // Asserts are used to use static analysis to find bugs in your code. They should never fail
248 
249  
250 
251         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
252 
253  
254 
255     }
256 
257  
258 
259  
260 
261  
262 
263     /**
264 
265  
266 
267      * Transfer tokens
268 
269  
270 
271      *
272 
273  
274 
275      * Send `_value` tokens to `_to` from your account
276 
277  
278 
279      *
280 
281  
282 
283      * @param _to The address of the recipient
284 
285  
286 
287      * @param _value the amount to send
288 
289  
290 
291      */
292 
293  
294 
295     function transfer(address _to, uint256 _value) public {
296 
297  
298 
299         _transfer(msg.sender, _to, _value);
300 
301  
302 
303     }
304     
305     
306     
307 
308  
309 
310  
311 
312  
313 
314     /**
315 
316  
317 
318      * Transfer tokens from other address
319 
320  
321 
322      *
323 
324  
325 
326      * Send `_value` tokens to `_to` in behalf of `_from`
327 
328  
329 
330      *
331 
332  
333 
334      * @param _from The address of the sender
335 
336  
337 
338      * @param _to The address of the recipient
339 
340  
341 
342      * @param _value the amount to send
343 
344  
345 
346      */
347 
348  
349 
350     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
351 
352  
353 
354         require(_value <= allowance[_from][msg.sender]);     // Check allowance
355 
356  
357 
358         allowance[_from][msg.sender] -= _value;
359 
360  
361 
362         _transfer(_from, _to, _value);
363 
364  
365 
366         return true;
367 
368  
369 
370     }
371 
372  
373 
374  
375 
376  
377 
378     /**
379 
380  
381 
382      * Set allowance for other address
383 
384  
385 
386      *
387 
388  
389 
390      * Allows `_spender` to spend no more than `_value` tokens in your behalf
391 
392  
393 
394      *
395 
396  
397 
398      * @param _spender The address authorized to spend
399 
400  
401 
402      * @param _value the max amount they can spend
403 
404  
405 
406      */
407 
408  
409 
410     function approve(address _spender, uint256 _value) public
411 
412  
413 
414         returns (bool success) {
415 
416  
417 
418         allowance[msg.sender][_spender] = _value;
419 
420  
421 
422         return true;
423 
424  
425 
426     }
427 
428  
429 
430  
431 
432  
433 
434     /**
435 
436  
437 
438      * Set allowance for other address and notify
439 
440  
441 
442      *
443 
444  
445 
446      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
447 
448  
449 
450      *
451 
452  
453 
454      * @param _spender The address authorized to spend
455 
456  
457 
458      * @param _value the max amount they can spend
459 
460  
461 
462      * @param _extraData some extra information to send to the approved contract
463 
464  
465 
466      */
467 
468  
469 
470     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
471 
472  
473 
474         public
475 
476  
477 
478         returns (bool success) {
479 
480  
481 
482         tokenRecipient spender = tokenRecipient(_spender);
483 
484  
485 
486         if (approve(_spender, _value)) {
487 
488  
489 
490             spender.receiveApproval(msg.sender, _value, this, _extraData);
491 
492  
493 
494             return true;
495 
496  
497 
498         }
499 
500  
501 
502     }
503 
504  
505 
506  
507 
508  
509 
510     /**
511 
512  
513 
514      * Destroy tokens
515 
516  
517 
518      *
519 
520  
521 
522      * Remove `_value` tokens from the system irreversibly
523 
524  
525 
526      *
527 
528  
529 
530      * @param _value the amount of money to burn
531 
532  
533 
534      */
535 
536  
537 
538     function burn(uint256 _value) public returns (bool success) {
539 
540  
541 
542         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
543 
544  
545 
546         balanceOf[msg.sender] -= _value;            // Subtract from the sender
547 
548  
549 
550         totalSupply -= _value;                      // Updates totalSupply
551 
552  
553 
554         Burn(msg.sender, _value);
555 
556  
557 
558         return true;
559 
560  
561 
562     }
563 
564  
565 
566  
567 
568  
569 
570     /**
571 
572  
573 
574      * Destroy tokens from other account
575 
576  
577 
578      *
579 
580  
581 
582      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
583 
584  
585 
586      *
587 
588  
589 
590      * @param _from the address of the sender
591 
592  
593 
594      * @param _value the amount of money to burn
595 
596  
597 
598      */
599 
600  
601 
602     function burnFrom(address _from, uint256 _value) public returns (bool success) {
603 
604  
605 
606         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
607 
608  
609 
610         require(_value <= allowance[_from][msg.sender]);    // Check allowance
611 
612  
613 
614         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
615 
616  
617 
618         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
619 
620  
621 
622         totalSupply -= _value;                              // Update totalSupply
623 
624  
625 
626         Burn(_from, _value);
627 
628  
629 
630         return true;
631 
632  
633 
634     }
635 
636  
637 
638 }
639 
640  
641 
642  
643 
644  
645 
646 /******************************************/
647 
648  
649 
650 /*       ADVANCED TOKEN STARTS HERE       */
651 
652  
653 
654 /******************************************/
655 
656  
657 
658  
659 
660  
661 
662 contract Yumerium is owned, TokenERC20 {
663 
664     address public saleAddress;
665     
666 
667     mapping (address => bool) public frozenAccount;
668 
669     
670 
671     event Buy(address indexed to, uint256 value);
672 
673     
674 
675     event Sell(address indexed from, uint256 value);
676 
677     event Sale(address indexed to, uint256 value);
678  
679 
680     /* This generates a public event on the blockchain that will notify clients */
681 
682  
683 
684     event FrozenFunds(address target, bool frozen);
685 
686     
687 
688     function Yumerium() public {
689 
690         balanceOf[this] = totalSupply; 
691 
692 
693     }
694     
695     
696     function sale(address _to, uint256 _value) public {
697         require (msg.sender == saleAddress);
698         require (balanceOf[this] >= _value);
699         
700         balanceOf[this] -= _value;
701         balanceOf[_to] += _value;
702         Sale(_to, _value);
703     }
704     
705     
706     function privateSale(address _to, uint256 _value) onlyOwner public {
707         require (balanceOf[this] >= _value);
708         
709         balanceOf[this] -= _value;
710         balanceOf[_to] += _value;
711         Sale(_to, _value);
712     }
713     
714     
715     
716     function changeSaleAddress(address _saleAddress) onlyOwner public {
717         saleAddress = _saleAddress;
718     }
719  
720 
721     /* Internal transfer, only can be called by this contract */
722 
723  
724 
725     function _transfer(address _from, address _to, uint _value) internal {
726 
727  
728 
729         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
730 
731  
732 
733         require (balanceOf[_from] >= _value);               // Check if the sender has enough
734 
735  
736 
737         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
738 
739  
740 
741         require(!frozenAccount[_from]);                     // Check if sender is frozen
742 
743  
744 
745         require(!frozenAccount[_to]);                       // Check if recipient is frozen
746 
747  
748 
749         balanceOf[_from] -= _value;                         // Subtract from the sender
750 
751  
752 
753         balanceOf[_to] += _value;                           // Add the same to the recipient
754 
755  
756 
757         Transfer(_from, _to, _value);
758 
759         
760 
761     }
762 
763  
764 
765  
766 
767  
768 
769     /// @notice Create `mintedAmount` tokens and send it to `target`
770 
771  
772 
773     /// @param target Address to receive the tokens
774 
775  
776 
777     /// @param mintedAmount the amount of tokens it will receive
778 
779  
780 
781     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
782 
783  
784 
785         balanceOf[target] += mintedAmount;
786 
787  
788 
789         totalSupply += mintedAmount;
790 
791  
792 
793         Transfer(0, this, mintedAmount);
794 
795  
796 
797         Transfer(this, target, mintedAmount);
798 
799  
800 
801     }
802 
803  
804 
805  
806 
807  
808 
809     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
810 
811  
812 
813     /// @param target Address to be frozen
814 
815  
816 
817     /// @param freeze either to freeze it or not
818 
819  
820 
821     function freezeAccount(address target, bool freeze) onlyOwner public {
822 
823  
824 
825         frozenAccount[target] = freeze;
826 
827  
828 
829         FrozenFunds(target, freeze);
830 
831  
832 
833     }
834 
835  
836 
837  
838 
839 
840     
841 
842     
843 
844     function sell(uint256 amount) payable public {
845 
846         _transfer(msg.sender, owner, amount);
847 
848 
849         Sell(msg.sender, amount);
850 
851     }
852 
853  
854 
855  
856 
857  
858 
859 }