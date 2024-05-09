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
160  * @title IAuthenticationManager 
161  *
162  * Allows the authentication process to be enabled and disabled
163  *
164  * #created 15/10/2017
165  * #author Frank Bonnet
166  */
167 contract IAuthenticationManager {
168     
169 
170     /**
171      * Returns true if authentication is enabled and false 
172      * otherwise
173      *
174      * @return Whether the converter is currently authenticating or not
175      */
176     function isAuthenticating() constant returns (bool);
177 
178 
179     /**
180      * Enable authentication
181      */
182     function enableAuthentication();
183 
184 
185     /**
186      * Disable authentication
187      */
188     function disableAuthentication();
189 }
190 
191 
192 /**
193  * @title IAuthenticator 
194  *
195  * Authenticator interface
196  *
197  * #created 15/10/2017
198  * #author Frank Bonnet
199  */
200 contract IAuthenticator {
201     
202 
203     /**
204      * Authenticate 
205      *
206      * Returns whether `_account` is authenticated or not
207      *
208      * @param _account The account to authenticate
209      * @return whether `_account` is successfully authenticated
210      */
211     function authenticate(address _account) constant returns (bool);
212 }
213 
214 
215 /**
216  * @title IWhitelist 
217  *
218  * Whitelist authentication interface
219  *
220  * #created 04/10/2017
221  * #author Frank Bonnet
222  */
223 contract IWhitelist is IAuthenticator {
224     
225 
226     /**
227      * Returns whether an entry exists for `_account`
228      *
229      * @param _account The account to check
230      * @return whether `_account` is has an entry in the whitelist
231      */
232     function hasEntry(address _account) constant returns (bool);
233 
234 
235     /**
236      * Add `_account` to the whitelist
237      *
238      * If an account is currently disabled, the account is reenabled, otherwise 
239      * a new entry is created
240      *
241      * @param _account The account to add
242      */
243     function add(address _account);
244 
245 
246     /**
247      * Remove `_account` from the whitelist
248      *
249      * Will not actually remove the entry but disable it by updating
250      * the accepted record
251      *
252      * @param _account The account to remove
253      */
254     function remove(address _account);
255 }
256 
257 
258 /**
259  * @title Token retrieve interface
260  *
261  * Allows tokens to be retrieved from a contract
262  *
263  * #created 29/09/2017
264  * #author Frank Bonnet
265  */
266 contract ITokenRetriever {
267 
268     /**
269      * Extracts tokens from the contract
270      *
271      * @param _tokenContract The address of ERC20 compatible token
272      */
273     function retrieveTokens(address _tokenContract);
274 }
275 
276 
277 /**
278  * @title Token retrieve
279  *
280  * Allows tokens to be retrieved from a contract
281  *
282  * #created 18/10/2017
283  * #author Frank Bonnet
284  */
285 contract TokenRetriever is ITokenRetriever {
286 
287     /**
288      * Extracts tokens from the contract
289      *
290      * @param _tokenContract The address of ERC20 compatible token
291      */
292     function retrieveTokens(address _tokenContract) public {
293         IToken tokenInstance = IToken(_tokenContract);
294         uint tokenBalance = tokenInstance.balanceOf(this);
295         if (tokenBalance > 0) {
296             tokenInstance.transfer(msg.sender, tokenBalance);
297         }
298     }
299 }
300 
301 
302 /**
303  * @title Token observer interface
304  *
305  * Allows a token smart-contract to notify observers 
306  * when tokens are received
307  *
308  * #created 09/10/2017
309  * #author Frank Bonnet
310  */
311 contract ITokenObserver {
312 
313     /**
314      * Called by the observed token smart-contract in order 
315      * to notify the token observer when tokens are received
316      *
317      * @param _from The address that the tokens where send from
318      * @param _value The amount of tokens that was received
319      */
320     function notifyTokensReceived(address _from, uint _value);
321 }
322 
323 
324 /**
325  * @title Abstract token observer
326  *
327  * Allows observers to be notified by an observed token smart-contract
328  * when tokens are received
329  *
330  * #created 09/10/2017
331  * #author Frank Bonnet
332  */
333 contract TokenObserver is ITokenObserver {
334 
335     /**
336      * Called by the observed token smart-contract in order 
337      * to notify the token observer when tokens are received
338      *
339      * @param _from The address that the tokens where send from
340      * @param _value The amount of tokens that was received
341      */
342     function notifyTokensReceived(address _from, uint _value) public {
343         onTokensReceived(msg.sender, _from, _value);
344     }
345 
346 
347     /**
348      * Event handler
349      * 
350      * Called by `_token` when a token amount is received
351      *
352      * @param _token The token contract that received the transaction
353      * @param _from The account or contract that send the transaction
354      * @param _value The value of tokens that where received
355      */
356     function onTokensReceived(address _token, address _from, uint _value) internal;
357 }
358 
359 
360 /**
361  * @title ERC20 compatible token interface
362  *
363  * - Implements ERC 20 Token standard
364  * - Implements short address attack fix
365  *
366  * #created 29/09/2017
367  * #author Frank Bonnet
368  */
369 contract IToken { 
370 
371     /** 
372      * Get the total supply of tokens
373      * 
374      * @return The total supply
375      */
376     function totalSupply() constant returns (uint);
377 
378 
379     /** 
380      * Get balance of `_owner` 
381      * 
382      * @param _owner The address from which the balance will be retrieved
383      * @return The balance
384      */
385     function balanceOf(address _owner) constant returns (uint);
386 
387 
388     /** 
389      * Send `_value` token to `_to` from `msg.sender`
390      * 
391      * @param _to The address of the recipient
392      * @param _value The amount of token to be transferred
393      * @return Whether the transfer was successful or not
394      */
395     function transfer(address _to, uint _value) returns (bool);
396 
397 
398     /** 
399      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
400      * 
401      * @param _from The address of the sender
402      * @param _to The address of the recipient
403      * @param _value The amount of token to be transferred
404      * @return Whether the transfer was successful or not
405      */
406     function transferFrom(address _from, address _to, uint _value) returns (bool);
407 
408 
409     /** 
410      * `msg.sender` approves `_spender` to spend `_value` tokens
411      * 
412      * @param _spender The address of the account able to transfer the tokens
413      * @param _value The amount of tokens to be approved for transfer
414      * @return Whether the approval was successful or not
415      */
416     function approve(address _spender, uint _value) returns (bool);
417 
418 
419     /** 
420      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
421      * 
422      * @param _owner The address of the account owning tokens
423      * @param _spender The address of the account able to transfer the tokens
424      * @return Amount of remaining tokens allowed to spent
425      */
426     function allowance(address _owner, address _spender) constant returns (uint);
427 }
428 
429 
430 /**
431  * @title ManagedToken interface
432  *
433  * Adds the following functionality to the basic ERC20 token
434  * - Locking
435  * - Issuing
436  * - Burning 
437  *
438  * #created 29/09/2017
439  * #author Frank Bonnet
440  */
441 contract IManagedToken is IToken { 
442 
443     /** 
444      * Returns true if the token is locked
445      * 
446      * @return Whether the token is locked
447      */
448     function isLocked() constant returns (bool);
449 
450 
451     /**
452      * Locks the token so that the transfering of value is disabled 
453      *
454      * @return Whether the unlocking was successful or not
455      */
456     function lock() returns (bool);
457 
458 
459     /**
460      * Unlocks the token so that the transfering of value is enabled 
461      *
462      * @return Whether the unlocking was successful or not
463      */
464     function unlock() returns (bool);
465 
466 
467     /**
468      * Issues `_value` new tokens to `_to`
469      *
470      * @param _to The address to which the tokens will be issued
471      * @param _value The amount of new tokens to issue
472      * @return Whether the tokens where sucessfully issued or not
473      */
474     function issue(address _to, uint _value) returns (bool);
475 
476 
477     /**
478      * Burns `_value` tokens of `_from`
479      *
480      * @param _from The address that owns the tokens to be burned
481      * @param _value The amount of tokens to be burned
482      * @return Whether the tokens where sucessfully burned or not 
483      */
484     function burn(address _from, uint _value) returns (bool);
485 }
486 
487 
488 /**
489  * @title Token Changer interface
490  *
491  * Basic token changer public interface 
492  *
493  * #created 06/10/2017
494  * #author Frank Bonnet
495  */
496 contract ITokenChanger {
497 
498     /**
499      * Returns true if '_token' is on of the tokens that are 
500      * managed by this token changer
501      * 
502      * @param _token The address being tested
503      * @return Whether the '_token' is part of this token changer
504      */
505     function isToken(address _token) constant returns (bool);
506 
507 
508     /**
509      * Returns the address of the left token
510      *
511      * @return Left token address
512      */
513     function getLeftToken() constant returns (address);
514 
515 
516     /**
517      * Returns the address of the right token
518      *
519      * @return Right token address
520      */
521     function getRightToken() constant returns (address);
522 
523 
524     /**
525      * Returns the fee that is paid in tokens when using 
526      * the token changer
527      *
528      * @return The percentage of tokens that is charged
529      */
530     function getFee() constant returns (uint);
531 
532     
533     /**
534      * Returns the rate that is used to change between tokens
535      *
536      * @return The rate used when changing tokens
537      */
538     function getRate() constant returns (uint);
539 
540 
541     /**
542      * Returns the precision of the rate and fee params
543      *
544      * @return The amount of decimals used
545      */
546     function getPrecision() constant returns (uint);
547 
548 
549     /**
550      * Calculates and returns the fee based on `_value` of tokens
551      *
552      * @return The actual fee
553      */
554     function calculateFee(uint _value) constant returns (uint);
555 }
556 
557 
558 /**
559  * @title Token Changer
560  *
561  * Provides a generic way to convert between two tokens using a fixed 
562  * ratio and an optional fee.
563  *
564  * #created 06/10/2017
565  * #author Frank Bonnet
566  */
567 contract TokenChanger is ITokenChanger, IPausable {
568 
569     IManagedToken private tokenLeft; // tokenLeft = tokenRight * rate / precision
570     IManagedToken private tokenRight; // tokenRight = tokenLeft / rate * precision
571 
572     uint private rate; // Ratio between tokens
573     uint private fee; // Percentage lost in transfer
574     uint private precision; // Precision 
575     bool private paused; // Paused state
576     bool private burn; // Whether the changer should burn tokens
577 
578 
579     /**
580      * Only if '_token' is the left or right token 
581      * that of the token changer
582      */
583     modifier is_token(address _token) {
584         require(_token == address(tokenLeft) || _token == address(tokenRight));
585         _;
586     }
587 
588 
589     /**
590      * Construct token changer
591      *
592      * @param _tokenLeft Ref to the 'left' token smart-contract
593      * @param _tokenRight Ref to the 'right' token smart-contract
594      * @param _rate The rate used when changing tokens
595      * @param _fee The percentage of tokens that is charged
596      * @param _decimals The amount of decimals used for _rate and _fee
597      * @param _paused Whether the token changer starts in the paused state or not
598      * @param _burn Whether the changer should burn tokens or not
599      */
600     function TokenChanger(address _tokenLeft, address _tokenRight, uint _rate, uint _fee, uint _decimals, bool _paused, bool _burn) {
601         tokenLeft = IManagedToken(_tokenLeft);
602         tokenRight = IManagedToken(_tokenRight);
603         rate = _rate;
604         fee = _fee;
605         precision = _decimals > 0 ? 10**_decimals : 1;
606         paused = _paused;
607         burn = _burn;
608     }
609 
610     
611     /**
612      * Returns true if '_token' is on of the tokens that are 
613      * managed by this token changer
614      * 
615      * @param _token The address being tested
616      * @return Whether the '_token' is part of this token changer
617      */
618     function isToken(address _token) public constant returns (bool) {
619         return _token == address(tokenLeft) || _token == address(tokenRight);
620     }
621 
622 
623     /**
624      * Returns the address of the left token
625      *
626      * @return Left token address
627      */
628     function getLeftToken() public constant returns (address) {
629         return tokenLeft;
630     }
631 
632 
633     /**
634      * Returns the address of the right token
635      *
636      * @return Right token address
637      */
638     function getRightToken() public constant returns (address) {
639         return tokenRight;
640     }
641 
642 
643     /**
644      * Returns the fee that is paid in tokens when using 
645      * the token changer
646      *
647      * @return The percentage of tokens that is charged
648      */
649     function getFee() public constant returns (uint) {
650         return fee;
651     }
652 
653 
654     /**
655      * Returns the rate that is used to change between tokens
656      *
657      * @return The rate used when changing tokens
658      */
659     function getRate() public constant returns (uint) {
660         return rate;
661     }
662 
663 
664     /**
665      * Returns the precision of the rate and fee params
666      *
667      * @return The amount of decimals used
668      */
669     function getPrecision() public constant returns (uint) {
670         return precision;
671     }
672 
673 
674     /**
675      * Returns whether the token changer is currently 
676      * paused or not. While being in the paused state 
677      * the contract should revert the transaction instead 
678      * of converting tokens
679      *
680      * @return Whether the token changer is in the paused state
681      */
682     function isPaused() public constant returns (bool) {
683         return paused;
684     }
685 
686 
687     /**
688      * Pause the token changer making the contract 
689      * revert the transaction instead of converting 
690      */
691     function pause() public {
692         paused = true;
693     }
694 
695 
696     /**
697      * Resume the token changer making the contract 
698      * convert tokens instead of reverting the transaction 
699      */
700     function resume() public {
701         paused = false;
702     }
703 
704 
705     /**
706      * Calculates and returns the fee based on `_value` of tokens
707      *
708      * @param _value The amount of tokens that is being converted
709      * @return The actual fee
710      */
711     function calculateFee(uint _value) public constant returns (uint) {
712         return fee == 0 ? 0 : _value * fee / precision;
713     }
714 
715 
716     /**
717      * Converts tokens by burning the tokens received at the token smart-contact 
718      * located at `_from` and by issuing tokens at the opposite token smart-contract
719      *
720      * @param _from The token smart-contract that received the tokens
721      * @param _sender The account that send the tokens (token owner)
722      * @param _value The amount of tokens that where received
723      */
724     function convert(address _from, address _sender, uint _value) internal {
725         require(!paused);
726         require(_value > 0);
727 
728         uint amountToIssue;
729         if (_from == address(tokenLeft)) {
730             amountToIssue = _value * rate / precision;
731             tokenRight.issue(_sender, amountToIssue - calculateFee(amountToIssue));
732             if (burn) {
733                 tokenLeft.burn(this, _value);
734             }   
735         } 
736         
737         else if (_from == address(tokenRight)) {
738             amountToIssue = _value * precision / rate;
739             tokenLeft.issue(_sender, amountToIssue - calculateFee(amountToIssue));
740             if (burn) {
741                 tokenRight.burn(this, _value);
742             } 
743         }
744     }
745 }
746 
747 
748 /**
749  * @title DRPU Converter
750  *
751  * Will allow DRP token holders to convert their DRP Balance into DRPU at the ratio of 1:2, locking all recieved DRP into the converter.
752  *
753  * DRPU as indicated by its ‘U’ designation is Dcorp’s utility token for those who are under strict 
754  * compliance within their country of residence, and does not entitle holders to profit sharing.
755  *
756  * https://www.dcorp.it/drpu
757  *
758  * #created 11/10/2017
759  * #author Frank Bonnet
760  */
761 contract DRPUTokenConverter is TokenChanger, IAuthenticationManager, TransferableOwnership, TokenRetriever {
762 
763     // Authentication
764     IWhitelist private whitelist;
765     bool private requireAuthentication;
766 
767 
768     /**
769      * Construct drp - drpu token changer
770      *
771      * Rate is multiplied by 10**6 taking into account the difference in 
772      * decimals between (old) DRP (2) and DRPU (8)
773      *
774      * @param _whitelist The address of the whitelist authenticator
775      * @param _drp Ref to the (old) DRP token smart-contract
776      * @param _drpu Ref to the DRPU token smart-contract https://www.dcorp.it/drpu
777      */
778     function DRPUTokenConverter(address _whitelist, address _drp, address _drpu) 
779         TokenChanger(_drp, _drpu, 2 * 10**6, 0, 0, false, false) {
780         whitelist = IWhitelist(_whitelist);
781         requireAuthentication = true;
782     }
783 
784 
785     /**
786      * Returns true if authentication is enabled and false 
787      * otherwise
788      *
789      * @return Whether the converter is currently authenticating or not
790      */
791     function isAuthenticating() public constant returns (bool) {
792         return requireAuthentication;
793     }
794 
795 
796     /**
797      * Enable authentication
798      */
799     function enableAuthentication() public only_owner {
800         requireAuthentication = true;
801     }
802 
803 
804     /**
805      * Disable authentication
806      */
807     function disableAuthentication() public only_owner {
808         requireAuthentication = false;
809     }
810 
811 
812     /**
813      * Pause the token changer making the contract 
814      * revert the transaction instead of converting 
815      */
816     function pause() public only_owner {
817         super.pause();
818     }
819 
820 
821     /**
822      * Resume the token changer making the contract 
823      * convert tokens instead of reverting the transaction 
824      */
825     function resume() public only_owner {
826         super.resume();
827     }
828 
829 
830     /**
831      * Request that the (old) drp smart-contract transfers `_value` worth 
832      * of (old) drp to the drpu token converter to be converted
833      * 
834      * Note! This function requires the drpu token converter smart-contract 
835      * to be approved to spend at least `_value` worth of (old) drp by the 
836      * owner of the tokens by calling the approve() function in the (old) 
837      * dpr token smart-contract
838      *
839      * @param _value The amount of tokens to transfer and convert
840      */
841     function requestConversion(uint _value) public {
842         require(_value > 0);
843         address sender = msg.sender;
844 
845         // Authenticate
846         require(!requireAuthentication || whitelist.authenticate(sender));
847 
848         IToken drpToken = IToken(getLeftToken());
849         drpToken.transferFrom(sender, this, _value); // Transfer old drp from sender to converter 
850         convert(drpToken, sender, _value); // Convert to drps
851     }
852 
853 
854     /**
855      * Failsafe mechanism
856      * 
857      * Allows the owner to retrieve tokens from the contract that 
858      * might have been send there by accident
859      *
860      * @param _tokenContract The address of ERC20 compatible token
861      */
862     function retrieveTokens(address _tokenContract) public only_owner {
863         require(getLeftToken() != _tokenContract); // Ensure that the (old) drp token stays locked
864         super.retrieveTokens(_tokenContract);
865     }
866 
867 
868     /**
869      * Prevents the accidental sending of ether
870      */
871     function () payable {
872         revert();
873     }
874 }