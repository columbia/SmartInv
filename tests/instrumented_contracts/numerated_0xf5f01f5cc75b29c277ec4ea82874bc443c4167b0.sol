1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownership interface
5  *
6  * Perminent ownership
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 contract IOwnership {
12 
13     /**
14      * Returns true if `_account` is the current owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) constant returns (bool);
19 
20 
21     /**
22      * Gets the current owner
23      *
24      * @return address The current owner
25      */
26     function getOwner() constant returns (address);
27 }
28 
29 
30 /**
31  * @title Ownership
32  *
33  * Perminent ownership
34  *
35  * #created 01/10/2017
36  * #author Frank Bonnet
37  */
38 contract Ownership is IOwnership {
39 
40     // Owner
41     address internal owner;
42 
43 
44     /**
45      * The publisher is the inital owner
46      */
47     function Ownership() {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53      * Access is restricted to the current owner
54      */
55     modifier only_owner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62      * Returns true if `_account` is the current owner
63      *
64      * @param _account The address to test against
65      */
66     function isOwner(address _account) public constant returns (bool) {
67         return _account == owner;
68     }
69 
70 
71     /**
72      * Gets the current owner
73      *
74      * @return address The current owner
75      */
76     function getOwner() public constant returns (address) {
77         return owner;
78     }
79 }
80 
81 
82 /**
83  * @title Transferable ownership interface
84  *
85  * Enhances ownership by allowing the current owner to 
86  * transfer ownership to a new owner
87  *
88  * #created 01/10/2017
89  * #author Frank Bonnet
90  */
91 contract ITransferableOwnership {
92     
93 
94     /**
95      * Transfer ownership to `_newOwner`
96      *
97      * @param _newOwner The address of the account that will become the new owner 
98      */
99     function transferOwnership(address _newOwner);
100 }
101 
102 
103 /**
104  * @title Transferable ownership
105  *
106  * Enhances ownership by allowing the current owner to 
107  * transfer ownership to a new owner
108  *
109  * #created 01/10/2017
110  * #author Frank Bonnet
111  */
112 contract TransferableOwnership is ITransferableOwnership, Ownership {
113 
114 
115     /**
116      * Transfer ownership to `_newOwner`
117      *
118      * @param _newOwner The address of the account that will become the new owner 
119      */
120     function transferOwnership(address _newOwner) public only_owner {
121         owner = _newOwner;
122     }
123 }
124 
125 
126 /**
127  * @title Pausable interface
128  *
129  * Simple interface to pause and resume 
130  *
131  * #created 11/10/2017
132  * #author Frank Bonnet
133  */
134 contract IPausable {
135 
136     /**
137      * Returns whether the implementing contract is 
138      * currently paused or not
139      *
140      * @return Whether the paused state is active
141      */
142     function isPaused() constant returns (bool);
143 
144 
145     /**
146      * Change the state to paused
147      */
148     function pause();
149 
150 
151     /**
152      * Change the state to resume, undo the effects 
153      * of calling pause
154      */
155     function resume();
156 }
157 
158 
159 /**
160  * @title Token retrieve interface
161  *
162  * Allows tokens to be retrieved from a contract
163  *
164  * #created 29/09/2017
165  * #author Frank Bonnet
166  */
167 contract ITokenRetriever {
168 
169     /**
170      * Extracts tokens from the contract
171      *
172      * @param _tokenContract The address of ERC20 compatible token
173      */
174     function retrieveTokens(address _tokenContract);
175 }
176 
177 
178 /**
179  * @title Token retrieve
180  *
181  * Allows tokens to be retrieved from a contract
182  *
183  * #created 18/10/2017
184  * #author Frank Bonnet
185  */
186 contract TokenRetriever is ITokenRetriever {
187 
188     /**
189      * Extracts tokens from the contract
190      *
191      * @param _tokenContract The address of ERC20 compatible token
192      */
193     function retrieveTokens(address _tokenContract) public {
194         IToken tokenInstance = IToken(_tokenContract);
195         uint tokenBalance = tokenInstance.balanceOf(this);
196         if (tokenBalance > 0) {
197             tokenInstance.transfer(msg.sender, tokenBalance);
198         }
199     }
200 }
201 
202 
203 /**
204  * @title Token observer interface
205  *
206  * Allows a token smart-contract to notify observers 
207  * when tokens are received
208  *
209  * #created 09/10/2017
210  * #author Frank Bonnet
211  */
212 contract ITokenObserver {
213 
214     /**
215      * Called by the observed token smart-contract in order 
216      * to notify the token observer when tokens are received
217      *
218      * @param _from The address that the tokens where send from
219      * @param _value The amount of tokens that was received
220      */
221     function notifyTokensReceived(address _from, uint _value);
222 }
223 
224 
225 /**
226  * @title Abstract token observer
227  *
228  * Allows observers to be notified by an observed token smart-contract
229  * when tokens are received
230  *
231  * #created 09/10/2017
232  * #author Frank Bonnet
233  */
234 contract TokenObserver is ITokenObserver {
235 
236     /**
237      * Called by the observed token smart-contract in order 
238      * to notify the token observer when tokens are received
239      *
240      * @param _from The address that the tokens where send from
241      * @param _value The amount of tokens that was received
242      */
243     function notifyTokensReceived(address _from, uint _value) public {
244         onTokensReceived(msg.sender, _from, _value);
245     }
246 
247 
248     /**
249      * Event handler
250      * 
251      * Called by `_token` when a token amount is received
252      *
253      * @param _token The token contract that received the transaction
254      * @param _from The account or contract that send the transaction
255      * @param _value The value of tokens that where received
256      */
257     function onTokensReceived(address _token, address _from, uint _value) internal;
258 }
259 
260 
261 /**
262  * @title ERC20 compatible token interface
263  *
264  * - Implements ERC 20 Token standard
265  * - Implements short address attack fix
266  *
267  * #created 29/09/2017
268  * #author Frank Bonnet
269  */
270 contract IToken { 
271 
272     /** 
273      * Get the total supply of tokens
274      * 
275      * @return The total supply
276      */
277     function totalSupply() constant returns (uint);
278 
279 
280     /** 
281      * Get balance of `_owner` 
282      * 
283      * @param _owner The address from which the balance will be retrieved
284      * @return The balance
285      */
286     function balanceOf(address _owner) constant returns (uint);
287 
288 
289     /** 
290      * Send `_value` token to `_to` from `msg.sender`
291      * 
292      * @param _to The address of the recipient
293      * @param _value The amount of token to be transferred
294      * @return Whether the transfer was successful or not
295      */
296     function transfer(address _to, uint _value) returns (bool);
297 
298 
299     /** 
300      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
301      * 
302      * @param _from The address of the sender
303      * @param _to The address of the recipient
304      * @param _value The amount of token to be transferred
305      * @return Whether the transfer was successful or not
306      */
307     function transferFrom(address _from, address _to, uint _value) returns (bool);
308 
309 
310     /** 
311      * `msg.sender` approves `_spender` to spend `_value` tokens
312      * 
313      * @param _spender The address of the account able to transfer the tokens
314      * @param _value The amount of tokens to be approved for transfer
315      * @return Whether the approval was successful or not
316      */
317     function approve(address _spender, uint _value) returns (bool);
318 
319 
320     /** 
321      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
322      * 
323      * @param _owner The address of the account owning tokens
324      * @param _spender The address of the account able to transfer the tokens
325      * @return Amount of remaining tokens allowed to spent
326      */
327     function allowance(address _owner, address _spender) constant returns (uint);
328 }
329 
330 
331 /**
332  * @title ManagedToken interface
333  *
334  * Adds the following functionality to the basic ERC20 token
335  * - Locking
336  * - Issuing
337  * - Burning 
338  *
339  * #created 29/09/2017
340  * #author Frank Bonnet
341  */
342 contract IManagedToken is IToken { 
343 
344     /** 
345      * Returns true if the token is locked
346      * 
347      * @return Whether the token is locked
348      */
349     function isLocked() constant returns (bool);
350 
351 
352     /**
353      * Locks the token so that the transfering of value is disabled 
354      *
355      * @return Whether the unlocking was successful or not
356      */
357     function lock() returns (bool);
358 
359 
360     /**
361      * Unlocks the token so that the transfering of value is enabled 
362      *
363      * @return Whether the unlocking was successful or not
364      */
365     function unlock() returns (bool);
366 
367 
368     /**
369      * Issues `_value` new tokens to `_to`
370      *
371      * @param _to The address to which the tokens will be issued
372      * @param _value The amount of new tokens to issue
373      * @return Whether the tokens where sucessfully issued or not
374      */
375     function issue(address _to, uint _value) returns (bool);
376 
377 
378     /**
379      * Burns `_value` tokens of `_from`
380      *
381      * @param _from The address that owns the tokens to be burned
382      * @param _value The amount of tokens to be burned
383      * @return Whether the tokens where sucessfully burned or not 
384      */
385     function burn(address _from, uint _value) returns (bool);
386 }
387 
388 
389 /**
390  * @title Token Changer interface
391  *
392  * Basic token changer public interface 
393  *
394  * #created 06/10/2017
395  * #author Frank Bonnet
396  */
397 contract ITokenChanger {
398 
399     /**
400      * Returns true if '_token' is on of the tokens that are 
401      * managed by this token changer
402      * 
403      * @param _token The address being tested
404      * @return Whether the '_token' is part of this token changer
405      */
406     function isToken(address _token) constant returns (bool);
407 
408 
409     /**
410      * Returns the address of the left token
411      *
412      * @return Left token address
413      */
414     function getLeftToken() constant returns (address);
415 
416 
417     /**
418      * Returns the address of the right token
419      *
420      * @return Right token address
421      */
422     function getRightToken() constant returns (address);
423 
424 
425     /**
426      * Returns the fee that is paid in tokens when using 
427      * the token changer
428      *
429      * @return The percentage of tokens that is charged
430      */
431     function getFee() constant returns (uint);
432 
433     
434     /**
435      * Returns the rate that is used to change between tokens
436      *
437      * @return The rate used when changing tokens
438      */
439     function getRate() constant returns (uint);
440 
441 
442     /**
443      * Returns the precision of the rate and fee params
444      *
445      * @return The amount of decimals used
446      */
447     function getPrecision() constant returns (uint);
448 
449 
450     /**
451      * Calculates and returns the fee based on `_value` of tokens
452      *
453      * @return The actual fee
454      */
455     function calculateFee(uint _value) constant returns (uint);
456 }
457 
458 
459 /**
460  * @title Token Changer
461  *
462  * Provides a generic way to convert between two tokens using a fixed 
463  * ratio and an optional fee.
464  *
465  * #created 06/10/2017
466  * #author Frank Bonnet
467  */
468 contract TokenChanger is ITokenChanger, IPausable {
469 
470     IManagedToken private tokenLeft; // tokenLeft = tokenRight * rate / precision
471     IManagedToken private tokenRight; // tokenRight = tokenLeft / rate * precision
472 
473     uint private rate; // Ratio between tokens
474     uint private fee; // Percentage lost in transfer
475     uint private precision; // Precision 
476     bool private paused; // Paused state
477     bool private burn; // Whether the changer should burn tokens
478 
479 
480     /**
481      * Only if '_token' is the left or right token 
482      * that of the token changer
483      */
484     modifier is_token(address _token) {
485         require(_token == address(tokenLeft) || _token == address(tokenRight));
486         _;
487     }
488 
489 
490     /**
491      * Construct token changer
492      *
493      * @param _tokenLeft Ref to the 'left' token smart-contract
494      * @param _tokenRight Ref to the 'right' token smart-contract
495      * @param _rate The rate used when changing tokens
496      * @param _fee The percentage of tokens that is charged
497      * @param _decimals The amount of decimals used for _rate and _fee
498      * @param _paused Whether the token changer starts in the paused state or not
499      * @param _burn Whether the changer should burn tokens or not
500      */
501     function TokenChanger(address _tokenLeft, address _tokenRight, uint _rate, uint _fee, uint _decimals, bool _paused, bool _burn) {
502         tokenLeft = IManagedToken(_tokenLeft);
503         tokenRight = IManagedToken(_tokenRight);
504         rate = _rate;
505         fee = _fee;
506         precision = _decimals > 0 ? 10**_decimals : 1;
507         paused = _paused;
508         burn = _burn;
509     }
510 
511     
512     /**
513      * Returns true if '_token' is on of the tokens that are 
514      * managed by this token changer
515      * 
516      * @param _token The address being tested
517      * @return Whether the '_token' is part of this token changer
518      */
519     function isToken(address _token) public constant returns (bool) {
520         return _token == address(tokenLeft) || _token == address(tokenRight);
521     }
522 
523 
524     /**
525      * Returns the address of the left token
526      *
527      * @return Left token address
528      */
529     function getLeftToken() public constant returns (address) {
530         return tokenLeft;
531     }
532 
533 
534     /**
535      * Returns the address of the right token
536      *
537      * @return Right token address
538      */
539     function getRightToken() public constant returns (address) {
540         return tokenRight;
541     }
542 
543 
544     /**
545      * Returns the fee that is paid in tokens when using 
546      * the token changer
547      *
548      * @return The percentage of tokens that is charged
549      */
550     function getFee() public constant returns (uint) {
551         return fee;
552     }
553 
554 
555     /**
556      * Returns the rate that is used to change between tokens
557      *
558      * @return The rate used when changing tokens
559      */
560     function getRate() public constant returns (uint) {
561         return rate;
562     }
563 
564 
565     /**
566      * Returns the precision of the rate and fee params
567      *
568      * @return The amount of decimals used
569      */
570     function getPrecision() public constant returns (uint) {
571         return precision;
572     }
573 
574 
575     /**
576      * Returns whether the token changer is currently 
577      * paused or not. While being in the paused state 
578      * the contract should revert the transaction instead 
579      * of converting tokens
580      *
581      * @return Whether the token changer is in the paused state
582      */
583     function isPaused() public constant returns (bool) {
584         return paused;
585     }
586 
587 
588     /**
589      * Pause the token changer making the contract 
590      * revert the transaction instead of converting 
591      */
592     function pause() public {
593         paused = true;
594     }
595 
596 
597     /**
598      * Resume the token changer making the contract 
599      * convert tokens instead of reverting the transaction 
600      */
601     function resume() public {
602         paused = false;
603     }
604 
605 
606     /**
607      * Calculates and returns the fee based on `_value` of tokens
608      *
609      * @param _value The amount of tokens that is being converted
610      * @return The actual fee
611      */
612     function calculateFee(uint _value) public constant returns (uint) {
613         return fee == 0 ? 0 : _value * fee / precision;
614     }
615 
616 
617     /**
618      * Converts tokens by burning the tokens received at the token smart-contact 
619      * located at `_from` and by issuing tokens at the opposite token smart-contract
620      *
621      * @param _from The token smart-contract that received the tokens
622      * @param _sender The account that send the tokens (token owner)
623      * @param _value The amount of tokens that where received
624      */
625     function convert(address _from, address _sender, uint _value) internal {
626         require(!paused);
627         require(_value > 0);
628 
629         uint amountToIssue;
630         if (_from == address(tokenLeft)) {
631             amountToIssue = _value * rate / precision;
632             tokenRight.issue(_sender, amountToIssue - calculateFee(amountToIssue));
633             if (burn) {
634                 tokenLeft.burn(this, _value);
635             }   
636         } 
637         
638         else if (_from == address(tokenRight)) {
639             amountToIssue = _value * precision / rate;
640             tokenLeft.issue(_sender, amountToIssue - calculateFee(amountToIssue));
641             if (burn) {
642                 tokenRight.burn(this, _value);
643             } 
644         }
645     }
646 }
647 
648 
649 /**
650  * @title DRP Token Changer
651  *
652  * This contract of this VC platform token changer will allow anyone with a current balance of DRP, 
653  * to deposit it and in return receive DRPU, or DRPS.
654  *
655  * DRPU as indicated by its ‘U’ designation is Dcorp’s utility token for those who are under strict 
656  * compliance within their country of residence, and does not entitle holders to profit sharing.
657  *
658  * DRPS as indicated by its ‘S’ designation, maintaining the primary security functions of the DRP token 
659  * as outlined within the Dcorp whitepaper. Those who bear DRPS will be entitled to profit sharing in the 
660  * form of dividends as per a voting process, and is considered the "Security" token of Dcorp.
661  *
662  * https://www.dcorp.it/tokenchanger
663  *
664  * #created 06/10/2017
665  * #author Frank Bonnet
666  */
667 contract DRPTokenChanger is TokenChanger, TokenObserver, TransferableOwnership, TokenRetriever {
668 
669     /**
670      * Construct drps - drpu token changer
671      *
672      * @param _drps Ref to the DRPS token smart-contract https://www.dcorp.it/drps
673      * @param _drpu Ref to the DRPU token smart-contract https://www.dcorp.it/drpu
674      */
675     function DRPTokenChanger(address _drps, address _drpu) 
676         TokenChanger(_drps, _drpu, 20000, 100, 4, false, true) {}
677 
678 
679     /**
680      * Pause the token changer making the contract 
681      * revert the transaction instead of converting 
682      */
683     function pause() public only_owner {
684         super.pause();
685     }
686 
687 
688     /**
689      * Resume the token changer making the contract 
690      * convert tokens instead of reverting the transaction 
691      */
692     function resume() public only_owner {
693         super.resume();
694     }
695 
696 
697     /**
698      * Event handler that initializes the token conversion
699      * 
700      * Called by `_token` when a token amount is received on 
701      * the address of this token changer
702      *
703      * @param _token The token contract that received the transaction
704      * @param _from The account or contract that send the transaction
705      * @param _value The value of tokens that where received
706      */
707     function onTokensReceived(address _token, address _from, uint _value) internal is_token(_token) {
708         require(_token == msg.sender);
709 
710         // Convert tokens
711         convert(_token, _from, _value);
712     }
713 
714 
715     /**
716      * Failsafe mechanism
717      * 
718      * Allows the owner to retrieve tokens from the contract that 
719      * might have been send there by accident
720      *
721      * @param _tokenContract The address of ERC20 compatible token
722      */
723     function retrieveTokens(address _tokenContract) public only_owner {
724         super.retrieveTokens(_tokenContract);
725     }
726 
727 
728     /**
729      * Prevents the accidental sending of ether
730      */
731     function () payable {
732         revert();
733     }
734 }