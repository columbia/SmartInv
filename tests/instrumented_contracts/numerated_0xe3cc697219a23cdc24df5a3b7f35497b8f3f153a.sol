1 pragma solidity ^0.4.18;
2 
3 /**
4  * IOwnership
5  *
6  * Perminent ownership
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 interface IOwnership {
12 
13     /**
14      * Returns true if `_account` is the current owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) public view returns (bool);
19 
20 
21     /**
22      * Gets the current owner
23      *
24      * @return address The current owner
25      */
26     function getOwner() public view returns (address);
27 }
28 
29 
30 /**
31  * Ownership
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
45      * Access is restricted to the current owner
46      */
47     modifier only_owner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52 
53     /**
54      * The publisher is the inital owner
55      */
56     function Ownership() public {
57         owner = msg.sender;
58     }
59 
60 
61     /**
62      * Returns true if `_account` is the current owner
63      *
64      * @param _account The address to test against
65      */
66     function isOwner(address _account) public view returns (bool) {
67         return _account == owner;
68     }
69 
70 
71     /**
72      * Gets the current owner
73      *
74      * @return address The current owner
75      */
76     function getOwner() public view returns (address) {
77         return owner;
78     }
79 }
80 
81 
82 /**
83  * ITransferableOwnership
84  *
85  * Enhances ownership by allowing the current owner to 
86  * transfer ownership to a new owner
87  *
88  * #created 01/10/2017
89  * #author Frank Bonnet
90  */
91 interface ITransferableOwnership {
92     
93 
94     /**
95      * Transfer ownership to `_newOwner`
96      *
97      * @param _newOwner The address of the account that will become the new owner 
98      */
99     function transferOwnership(address _newOwner) public;
100 }
101 
102 
103 
104 /**
105  * TransferableOwnership
106  *
107  * Enhances ownership by allowing the current owner to 
108  * transfer ownership to a new owner
109  *
110  * #created 01/10/2017
111  * #author Frank Bonnet
112  */
113 contract TransferableOwnership is ITransferableOwnership, Ownership {
114 
115 
116     /**
117      * Transfer ownership to `_newOwner`
118      *
119      * @param _newOwner The address of the account that will become the new owner 
120      */
121     function transferOwnership(address _newOwner) public only_owner {
122         owner = _newOwner;
123     }
124 }
125 
126 
127 /**
128  * IAuthenticator 
129  *
130  * Authenticator interface
131  *
132  * #created 15/10/2017
133  * #author Frank Bonnet
134  */
135 interface IAuthenticator {
136     
137 
138     /**
139      * Authenticate 
140      *
141      * Returns whether `_account` is authenticated or not
142      *
143      * @param _account The account to authenticate
144      * @return whether `_account` is successfully authenticated
145      */
146     function authenticate(address _account) public view returns (bool);
147 }
148 
149 
150 /**
151  * IAuthenticationManager 
152  *
153  * Allows the authentication process to be enabled and disabled
154  *
155  * #created 15/10/2017
156  * #author Frank Bonnet
157  */
158 interface IAuthenticationManager {
159     
160 
161     /**
162      * Returns true if authentication is enabled and false 
163      * otherwise
164      *
165      * @return Whether the converter is currently authenticating or not
166      */
167     function isAuthenticating() public view returns (bool);
168 
169 
170     /**
171      * Enable authentication
172      */
173     function enableAuthentication() public;
174 
175 
176     /**
177      * Disable authentication
178      */
179     function disableAuthentication() public;
180 }
181 
182 
183 /**
184  * ERC20 compatible token interface
185  *
186  * - Implements ERC 20 Token standard
187  * - Implements short address attack fix
188  *
189  * #created 29/09/2017
190  * #author Frank Bonnet
191  */
192 interface IToken { 
193 
194     /** 
195      * Get the total supply of tokens
196      * 
197      * @return The total supply
198      */
199     function totalSupply() public view returns (uint);
200 
201 
202     /** 
203      * Get balance of `_owner` 
204      * 
205      * @param _owner The address from which the balance will be retrieved
206      * @return The balance
207      */
208     function balanceOf(address _owner) public view returns (uint);
209 
210 
211     /** 
212      * Send `_value` token to `_to` from `msg.sender`
213      * 
214      * @param _to The address of the recipient
215      * @param _value The amount of token to be transferred
216      * @return Whether the transfer was successful or not
217      */
218     function transfer(address _to, uint _value) public returns (bool);
219 
220 
221     /** 
222      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
223      * 
224      * @param _from The address of the sender
225      * @param _to The address of the recipient
226      * @param _value The amount of token to be transferred
227      * @return Whether the transfer was successful or not
228      */
229     function transferFrom(address _from, address _to, uint _value) public returns (bool);
230 
231 
232     /** 
233      * `msg.sender` approves `_spender` to spend `_value` tokens
234      * 
235      * @param _spender The address of the account able to transfer the tokens
236      * @param _value The amount of tokens to be approved for transfer
237      * @return Whether the approval was successful or not
238      */
239     function approve(address _spender, uint _value) public returns (bool);
240 
241 
242     /** 
243      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
244      * 
245      * @param _owner The address of the account owning tokens
246      * @param _spender The address of the account able to transfer the tokens
247      * @return Amount of remaining tokens allowed to spent
248      */
249     function allowance(address _owner, address _spender) public view returns (uint);
250 }
251 
252 
253 /**
254  * IManagedToken
255  *
256  * Adds the following functionality to the basic ERC20 token
257  * - Locking
258  * - Issuing
259  * - Burning 
260  *
261  * #created 29/09/2017
262  * #author Frank Bonnet
263  */
264 interface IManagedToken { 
265 
266     /** 
267      * Returns true if the token is locked
268      * 
269      * @return Whether the token is locked
270      */
271     function isLocked() public view returns (bool);
272 
273 
274     /**
275      * Locks the token so that the transfering of value is disabled 
276      *
277      * @return Whether the unlocking was successful or not
278      */
279     function lock() public returns (bool);
280 
281 
282     /**
283      * Unlocks the token so that the transfering of value is enabled 
284      *
285      * @return Whether the unlocking was successful or not
286      */
287     function unlock() public returns (bool);
288 
289 
290     /**
291      * Issues `_value` new tokens to `_to`
292      *
293      * @param _to The address to which the tokens will be issued
294      * @param _value The amount of new tokens to issue
295      * @return Whether the tokens where sucessfully issued or not
296      */
297     function issue(address _to, uint _value) public returns (bool);
298 
299 
300     /**
301      * Burns `_value` tokens of `_from`
302      *
303      * @param _from The address that owns the tokens to be burned
304      * @param _value The amount of tokens to be burned
305      * @return Whether the tokens where sucessfully burned or not 
306      */
307     function burn(address _from, uint _value) public returns (bool);
308 }
309 
310 
311 /**
312  * ITokenRetriever
313  *
314  * Allows tokens to be retrieved from a contract
315  *
316  * #created 29/09/2017
317  * #author Frank Bonnet
318  */
319 interface ITokenRetriever {
320 
321     /**
322      * Extracts tokens from the contract
323      *
324      * @param _tokenContract The address of ERC20 compatible token
325      */
326     function retrieveTokens(address _tokenContract) public;
327 }
328 
329 
330 /**
331  * TokenRetriever
332  *
333  * Allows tokens to be retrieved from a contract
334  *
335  * #created 18/10/2017
336  * #author Frank Bonnet
337  */
338 contract TokenRetriever is ITokenRetriever {
339 
340     /**
341      * Extracts tokens from the contract
342      *
343      * @param _tokenContract The address of ERC20 compatible token
344      */
345     function retrieveTokens(address _tokenContract) public {
346         IToken tokenInstance = IToken(_tokenContract);
347         uint tokenBalance = tokenInstance.balanceOf(this);
348         if (tokenBalance > 0) {
349             tokenInstance.transfer(msg.sender, tokenBalance);
350         }
351     }
352 }
353 
354 
355 /**
356  * ITokenObserver
357  *
358  * Allows a token smart-contract to notify observers 
359  * when tokens are received
360  *
361  * #created 09/10/2017
362  * #author Frank Bonnet
363  */
364 interface ITokenObserver {
365 
366 
367     /**
368      * Called by the observed token smart-contract in order 
369      * to notify the token observer when tokens are received
370      *
371      * @param _from The address that the tokens where send from
372      * @param _value The amount of tokens that was received
373      */
374     function notifyTokensReceived(address _from, uint _value) public;
375 }
376 
377 
378 /**
379  * TokenObserver
380  *
381  * Allows observers to be notified by an observed token smart-contract
382  * when tokens are received
383  *
384  * #created 09/10/2017
385  * #author Frank Bonnet
386  */
387 contract TokenObserver is ITokenObserver {
388 
389 
390     /**
391      * Called by the observed token smart-contract in order 
392      * to notify the token observer when tokens are received
393      *
394      * @param _from The address that the tokens where send from
395      * @param _value The amount of tokens that was received
396      */
397     function notifyTokensReceived(address _from, uint _value) public {
398         onTokensReceived(msg.sender, _from, _value);
399     }
400 
401 
402     /**
403      * Event handler
404      * 
405      * Called by `_token` when a token amount is received
406      *
407      * @param _token The token contract that received the transaction
408      * @param _from The account or contract that send the transaction
409      * @param _value The value of tokens that where received
410      */
411     function onTokensReceived(address _token, address _from, uint _value) internal;
412 }
413 
414 
415 /**
416  * IPausable
417  *
418  * Simple interface to pause and resume 
419  *
420  * #created 11/10/2017
421  * #author Frank Bonnet
422  */
423 interface IPausable {
424 
425 
426     /**
427      * Returns whether the implementing contract is 
428      * currently paused or not
429      *
430      * @return Whether the paused state is active
431      */
432     function isPaused() public view returns (bool);
433 
434 
435     /**
436      * Change the state to paused
437      */
438     function pause() public;
439 
440 
441     /**
442      * Change the state to resume, undo the effects 
443      * of calling pause
444      */
445     function resume() public;
446 }
447 
448 
449 /**
450  * ITokenChanger
451  *
452  * Basic token changer public interface 
453  *
454  * #created 06/10/2017
455  * #author Frank Bonnet
456  */
457 interface ITokenChanger {
458 
459 
460     /**
461      * Returns true if '_token' is on of the tokens that are 
462      * managed by this token changer
463      * 
464      * @param _token The address being tested
465      * @return Whether the '_token' is part of this token changer
466      */
467     function isToken(address _token) public view returns (bool);
468 
469 
470     /**
471      * Returns the address of the left token
472      *
473      * @return Left token address
474      */
475     function getLeftToken() public view returns (address);
476 
477 
478     /**
479      * Returns the address of the right token
480      *
481      * @return Right token address
482      */
483     function getRightToken() public view returns (address);
484 
485 
486     /**
487      * Returns the fee that is paid in tokens when using 
488      * the token changer
489      *
490      * @return The percentage of tokens that is charged
491      */
492     function getFee() public view returns (uint);
493 
494     
495     /**
496      * Returns the rate that is used to change between tokens
497      *
498      * @return The rate used when changing tokens
499      */
500     function getRate() public view returns (uint);
501 
502 
503     /**
504      * Returns the precision of the rate and fee params
505      *
506      * @return The amount of decimals used
507      */
508     function getPrecision() public view returns (uint);
509 
510 
511     /**
512      * Calculates and returns the fee based on `_value` of tokens
513      *
514      * @return The actual fee
515      */
516     function calculateFee(uint _value) public view returns (uint);
517 }
518 
519 
520 /**
521  * TokenChanger
522  *
523  * Provides a generic way to convert between two tokens using a fixed 
524  * ratio and an optional fee.
525  *
526  * #created 06/10/2017
527  * #author Frank Bonnet
528  */
529 contract TokenChanger is ITokenChanger, IPausable {
530 
531     IManagedToken private tokenLeft; // tokenLeft = tokenRight * rate / precision
532     IManagedToken private tokenRight; // tokenRight = tokenLeft / rate * precision
533 
534     uint private rate; // Ratio between tokens
535     uint private fee; // Percentage lost in transfer
536     uint private precision; // Precision 
537     bool private paused; // Paused state
538     bool private burn; // Whether the changer should burn tokens
539 
540 
541     /**
542      * Only if '_token' is the left or right token 
543      * that of the token changer
544      */
545     modifier is_token(address _token) {
546         require(_token == address(tokenLeft) || _token == address(tokenRight));
547         _;
548     }
549 
550 
551     /**
552      * Construct token changer
553      *
554      * @param _tokenLeft Ref to the 'left' token smart-contract
555      * @param _tokenRight Ref to the 'right' token smart-contract
556      * @param _rate The rate used when changing tokens
557      * @param _fee The percentage of tokens that is charged
558      * @param _decimals The amount of decimals used for _rate and _fee
559      * @param _paused Whether the token changer starts in the paused state or not
560      * @param _burn Whether the changer should burn tokens or not
561      */
562     function TokenChanger(address _tokenLeft, address _tokenRight, uint _rate, uint _fee, uint _decimals, bool _paused, bool _burn) public {
563         tokenLeft = IManagedToken(_tokenLeft);
564         tokenRight = IManagedToken(_tokenRight);
565         rate = _rate;
566         fee = _fee;
567         precision = _decimals > 0 ? 10**_decimals : 1;
568         paused = _paused;
569         burn = _burn;
570     }
571 
572     
573     /**
574      * Returns true if '_token' is on of the tokens that are 
575      * managed by this token changer
576      * 
577      * @param _token The address being tested
578      * @return Whether the '_token' is part of this token changer
579      */
580     function isToken(address _token) public view returns (bool) {
581         return _token == address(tokenLeft) || _token == address(tokenRight);
582     }
583 
584 
585     /**
586      * Returns the address of the left token
587      *
588      * @return Left token address
589      */
590     function getLeftToken() public view returns (address) {
591         return tokenLeft;
592     }
593 
594 
595     /**
596      * Returns the address of the right token
597      *
598      * @return Right token address
599      */
600     function getRightToken() public view returns (address) {
601         return tokenRight;
602     }
603 
604 
605     /**
606      * Returns the fee that is paid in tokens when using 
607      * the token changer
608      *
609      * @return The percentage of tokens that is charged
610      */
611     function getFee() public view returns (uint) {
612         return fee;
613     }
614 
615 
616     /**
617      * Returns the rate that is used to change between tokens
618      *
619      * @return The rate used when changing tokens
620      */
621     function getRate() public view returns (uint) {
622         return rate;
623     }
624 
625 
626     /**
627      * Returns the precision of the rate and fee params
628      *
629      * @return The amount of decimals used
630      */
631     function getPrecision() public view returns (uint) {
632         return precision;
633     }
634 
635 
636     /**
637      * Returns whether the token changer is currently 
638      * paused or not. While being in the paused state 
639      * the contract should revert the transaction instead 
640      * of converting tokens
641      *
642      * @return Whether the token changer is in the paused state
643      */
644     function isPaused() public view returns (bool) {
645         return paused;
646     }
647 
648 
649     /**
650      * Pause the token changer making the contract 
651      * revert the transaction instead of converting 
652      */
653     function pause() public {
654         paused = true;
655     }
656 
657 
658     /**
659      * Resume the token changer making the contract 
660      * convert tokens instead of reverting the transaction 
661      */
662     function resume() public {
663         paused = false;
664     }
665 
666 
667     /**
668      * Calculates and returns the fee based on `_value` of tokens
669      *
670      * @param _value The amount of tokens that is being converted
671      * @return The actual fee
672      */
673     function calculateFee(uint _value) public view returns (uint) {
674         return fee == 0 ? 0 : _value * fee / precision;
675     }
676 
677 
678     /**
679      * Converts tokens by burning the tokens received at the token smart-contact 
680      * located at `_from` and by issuing tokens at the opposite token smart-contract
681      *
682      * @param _from The token smart-contract that received the tokens
683      * @param _sender The account that send the tokens (token owner)
684      * @param _value The amount of tokens that where received
685      */
686     function convert(address _from, address _sender, uint _value) internal {
687         require(!paused);
688         require(_value > 0);
689 
690         uint amountToIssue;
691         if (_from == address(tokenLeft)) {
692             amountToIssue = _value * rate / precision;
693             tokenRight.issue(_sender, amountToIssue - calculateFee(amountToIssue));
694             if (burn) {
695                 tokenLeft.burn(this, _value);
696             }   
697         } 
698         
699         else if (_from == address(tokenRight)) {
700             amountToIssue = _value * precision / rate;
701             tokenLeft.issue(_sender, amountToIssue - calculateFee(amountToIssue));
702             if (burn) {
703                 tokenRight.burn(this, _value);
704             } 
705         }
706     }
707 }
708 
709 
710 /**
711  * ATM Token Changer
712  *
713  * This contract of this token changer will allow anyone with a current balance of ATM, 
714  * to deposit it and in return receive KATX, or KATM.
715  *
716  * KATM maintaining the primary security functions of the KATM token as 
717  * outlined within the whitepaper.
718  *
719  * KATX as indicated by its ‘X’ designation is the utility token for those who are under strict 
720  * compliance within their country of residence, and does not entitle holders to profit sharing.
721  *
722  * #created 30/10/2017
723  * #author Frank Bonnet
724  */
725 contract KATMTokenChanger is TokenChanger, TokenObserver, TransferableOwnership, TokenRetriever, IAuthenticationManager {
726 
727     enum Stages {
728         Deploying,
729         Deployed
730     }
731 
732     Stages public stage;
733 
734     // Authentication
735     IAuthenticator private authenticator;
736     bool private requireAuthentication;
737 
738 
739     /**
740      * Throw if at stage other than current stage
741      * 
742      * @param _stage expected stage to test for
743      */
744     modifier at_stage(Stages _stage) {
745         require(stage == _stage);
746         _;
747     }
748 
749 
750     /**
751      * Throw if not authenticated
752      * 
753      * @param _account The account that is authenticated
754      */
755     modifier authenticate(address _account) {
756         require(!requireAuthentication || authenticator.authenticate(_account));
757         _;
758     }
759 
760 
761     /**
762      * Construct Security - Utility token changer
763      *
764      * @param _security Ref to the Security token smart-contract
765      * @param _utility Ref to the Utiltiy token smart-contract
766      */
767     function KATMTokenChanger(address _security, address _utility) public
768         TokenChanger(_security, _utility, 8000, 500, 4, false, true) {
769         stage = Stages.Deploying;
770     }
771 
772 
773     /**
774      * Setup authentication
775      *
776      * @param _authenticator The address of the authenticator (whitelist)
777      * @param _requireAuthentication Wether the crowdale requires contributors to be authenticated
778      */
779     function setupWhitelist(address _authenticator, bool _requireAuthentication) public only_owner at_stage(Stages.Deploying) {
780         authenticator = IAuthenticator(_authenticator);
781         requireAuthentication = _requireAuthentication;
782     }
783 
784 
785     /**
786      * After calling the deploy function the crowdsale
787      * rules become immutable 
788      */
789     function deploy() public only_owner at_stage(Stages.Deploying) {
790         stage = Stages.Deployed;
791     }
792 
793 
794     /**
795      * Returns true if authentication is enabled and false 
796      * otherwise
797      *
798      * @return Whether the converter is currently authenticating or not
799      */
800     function isAuthenticating() public view returns (bool) {
801         return requireAuthentication;
802     }
803 
804 
805     /**
806      * Enable authentication
807      */
808     function enableAuthentication() public only_owner {
809         requireAuthentication = true;
810     }
811 
812 
813     /**
814      * Disable authentication
815      */
816     function disableAuthentication() public only_owner {
817         requireAuthentication = false;
818     }
819 
820 
821     /**
822      * Pause the token changer making the contract 
823      * revert the transaction instead of converting 
824      */
825     function pause() public only_owner {
826         super.pause();
827     }
828 
829 
830     /**
831      * Resume the token changer making the contract 
832      * convert tokens instead of reverting the transaction 
833      */
834     function resume() public only_owner {
835         super.resume();
836     }
837 
838 
839     /**
840      * Event handler that initializes the token conversion
841      * 
842      * Called by `_token` when a token amount is received on 
843      * the address of this token changer
844      *
845      * @param _token The token contract that received the transaction
846      * @param _from The account or contract that send the transaction
847      * @param _value The value of tokens that where received
848      */
849     function onTokensReceived(address _token, address _from, uint _value) internal is_token(_token) authenticate(_from) at_stage(Stages.Deployed) {
850         require(_token == msg.sender);
851         
852         // Convert tokens
853         convert(_token, _from, _value);
854     }
855 
856 
857     /**
858      * Failsafe mechanism
859      * 
860      * Allows the owner to retrieve tokens from the contract that 
861      * might have been send there by accident
862      *
863      * @param _tokenContract The address of ERC20 compatible token
864      */
865     function retrieveTokens(address _tokenContract) public only_owner {
866         super.retrieveTokens(_tokenContract);
867     }
868 
869 
870     /**
871      * Prevents the accidental sending of ether
872      */
873     function () public payable {
874         revert();
875     }
876 }