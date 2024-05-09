1 pragma solidity ^0.4.18;
2 
3 /**
4  * IMultiOwned
5  *
6  * Interface that allows multiple owners
7  *
8  * #created 09/10/2017
9  * #author Frank Bonnet
10  */
11 interface IMultiOwned {
12 
13     /**
14      * Returns true if `_account` is an owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) public view returns (bool);
19 
20 
21     /**
22      * Returns the amount of owners
23      *
24      * @return The amount of owners
25      */
26     function getOwnerCount() public view returns (uint);
27 
28 
29     /**
30      * Gets the owner at `_index`
31      *
32      * @param _index The index of the owner
33      * @return The address of the owner found at `_index`
34      */
35     function getOwnerAt(uint _index) public view returns (address);
36 
37 
38      /**
39      * Adds `_account` as a new owner
40      *
41      * @param _account The account to add as an owner
42      */
43     function addOwner(address _account) public;
44 
45 
46     /**
47      * Removes `_account` as an owner
48      *
49      * @param _account The account to remove as an owner
50      */
51     function removeOwner(address _account) public;
52 }
53 
54 
55 /**
56  * MultiOwned
57  *
58  * Allows multiple owners
59  *
60  * #created 09/10/2017
61  * #author Frank Bonnet
62  */
63 contract MultiOwned is IMultiOwned {
64 
65     // Owners
66     mapping (address => uint) private owners;
67     address[] private ownersIndex;
68 
69 
70      /**
71      * Access is restricted to owners only
72      */
73     modifier only_owner() {
74         require(isOwner(msg.sender));
75         _;
76     }
77 
78 
79     /**
80      * The publisher is the initial owner
81      */
82     function MultiOwned() public {
83         ownersIndex.push(msg.sender);
84         owners[msg.sender] = 0;
85     }
86 
87 
88     /**
89      * Returns true if `_account` is the current owner
90      *
91      * @param _account The address to test against
92      */
93     function isOwner(address _account) public view returns (bool) {
94         return owners[_account] < ownersIndex.length && _account == ownersIndex[owners[_account]];
95     }
96 
97 
98     /**
99      * Returns the amount of owners
100      *
101      * @return The amount of owners
102      */
103     function getOwnerCount() public view returns (uint) {
104         return ownersIndex.length;
105     }
106 
107 
108     /**
109      * Gets the owner at `_index`
110      *
111      * @param _index The index of the owner
112      * @return The address of the owner found at `_index`
113      */
114     function getOwnerAt(uint _index) public view returns (address) {
115         return ownersIndex[_index];
116     }
117 
118 
119     /**
120      * Adds `_account` as a new owner
121      *
122      * @param _account The account to add as an owner
123      */
124     function addOwner(address _account) public only_owner {
125         if (!isOwner(_account)) {
126             owners[_account] = ownersIndex.push(_account) - 1;
127         }
128     }
129 
130 
131     /**
132      * Removes `_account` as an owner
133      *
134      * @param _account The account to remove as an owner
135      */
136     function removeOwner(address _account) public only_owner {
137         if (isOwner(_account)) {
138             uint indexToDelete = owners[_account];
139             address keyToMove = ownersIndex[ownersIndex.length - 1];
140             ownersIndex[indexToDelete] = keyToMove;
141             owners[keyToMove] = indexToDelete; 
142             ownersIndex.length--;
143         }
144     }
145 }
146 
147 
148 /**
149  * IObservable
150  *
151  * Allows observers to register and unregister with the 
152  * implementing smart-contract that is observable
153  *
154  * #created 09/10/2017
155  * #author Frank Bonnet
156  */
157 interface IObservable {
158 
159 
160     /**
161      * Returns true if `_account` is a registered observer
162      * 
163      * @param _account The account to test against
164      * @return Whether the account is a registered observer
165      */
166     function isObserver(address _account) public view returns (bool);
167 
168 
169     /**
170      * Gets the amount of registered observers
171      * 
172      * @return The amount of registered observers
173      */
174     function getObserverCount() public view returns (uint);
175 
176 
177     /**
178      * Gets the observer at `_index`
179      * 
180      * @param _index The index of the observer
181      * @return The observers address
182      */
183     function getObserverAtIndex(uint _index) public view returns (address);
184 
185 
186     /**
187      * Register `_observer` as an observer
188      * 
189      * @param _observer The account to add as an observer
190      */
191     function registerObserver(address _observer) public;
192 
193 
194     /**
195      * Unregister `_observer` as an observer
196      * 
197      * @param _observer The account to remove as an observer
198      */
199     function unregisterObserver(address _observer) public;
200 }
201 
202 
203 /**
204  * Abstract Observable
205  *
206  * Allows observers to register and unregister with the the 
207  * implementing smart-contract that is observable
208  *
209  * #created 09/10/2017
210  * #author Frank Bonnet
211  */
212 contract Observable is IObservable {
213 
214 
215     // Observers
216     mapping (address => uint) private observers;
217     address[] private observerIndex;
218 
219 
220     /**
221      * Returns true if `_account` is a registered observer
222      * 
223      * @param _account The account to test against
224      * @return Whether the account is a registered observer
225      */
226     function isObserver(address _account) public view returns (bool) {
227         return observers[_account] < observerIndex.length && _account == observerIndex[observers[_account]];
228     }
229 
230 
231     /**
232      * Gets the amount of registered observers
233      * 
234      * @return The amount of registered observers
235      */
236     function getObserverCount() public view returns (uint) {
237         return observerIndex.length;
238     }
239 
240 
241     /**
242      * Gets the observer at `_index`
243      * 
244      * @param _index The index of the observer
245      * @return The observers address
246      */
247     function getObserverAtIndex(uint _index) public view returns (address) {
248         return observerIndex[_index];
249     }
250 
251 
252     /**
253      * Register `_observer` as an observer
254      * 
255      * @param _observer The account to add as an observer
256      */
257     function registerObserver(address _observer) public {
258         require(canRegisterObserver(_observer));
259         if (!isObserver(_observer)) {
260             observers[_observer] = observerIndex.push(_observer) - 1;
261         }
262     }
263 
264 
265     /**
266      * Unregister `_observer` as an observer
267      * 
268      * @param _observer The account to remove as an observer
269      */
270     function unregisterObserver(address _observer) public {
271         require(canUnregisterObserver(_observer));
272         if (isObserver(_observer)) {
273             uint indexToDelete = observers[_observer];
274             address keyToMove = observerIndex[observerIndex.length - 1];
275             observerIndex[indexToDelete] = keyToMove;
276             observers[keyToMove] = indexToDelete;
277             observerIndex.length--;
278         }
279     }
280 
281 
282     /**
283      * Returns whether it is allowed to register `_observer` by calling 
284      * canRegisterObserver() in the implementing smart-contract
285      *
286      * @param _observer The address to register as an observer
287      * @return Whether the sender is allowed or not
288      */
289     function canRegisterObserver(address _observer) internal view returns (bool);
290 
291 
292     /**
293      * Returns whether it is allowed to unregister `_observer` by calling 
294      * canRegisterObserver() in the implementing smart-contract
295      *
296      * @param _observer The address to unregister as an observer
297      * @return Whether the sender is allowed or not
298      */
299     function canUnregisterObserver(address _observer) internal view returns (bool);
300 }
301 
302 
303 
304 /**
305  * ITokenObserver
306  *
307  * Allows a token smart-contract to notify observers 
308  * when tokens are received
309  *
310  * #created 09/10/2017
311  * #author Frank Bonnet
312  */
313 interface ITokenObserver {
314 
315 
316     /**
317      * Called by the observed token smart-contract in order 
318      * to notify the token observer when tokens are received
319      *
320      * @param _from The address that the tokens where send from
321      * @param _value The amount of tokens that was received
322      */
323     function notifyTokensReceived(address _from, uint _value) public;
324 }
325 
326 
327 /**
328  * TokenObserver
329  *
330  * Allows observers to be notified by an observed token smart-contract
331  * when tokens are received
332  *
333  * #created 09/10/2017
334  * #author Frank Bonnet
335  */
336 contract TokenObserver is ITokenObserver {
337 
338 
339     /**
340      * Called by the observed token smart-contract in order 
341      * to notify the token observer when tokens are received
342      *
343      * @param _from The address that the tokens where send from
344      * @param _value The amount of tokens that was received
345      */
346     function notifyTokensReceived(address _from, uint _value) public {
347         onTokensReceived(msg.sender, _from, _value);
348     }
349 
350 
351     /**
352      * Event handler
353      * 
354      * Called by `_token` when a token amount is received
355      *
356      * @param _token The token contract that received the transaction
357      * @param _from The account or contract that send the transaction
358      * @param _value The value of tokens that where received
359      */
360     function onTokensReceived(address _token, address _from, uint _value) internal;
361 }
362 
363 
364 
365 /**
366  * ITokenRetriever
367  *
368  * Allows tokens to be retrieved from a contract
369  *
370  * #created 29/09/2017
371  * #author Frank Bonnet
372  */
373 interface ITokenRetriever {
374 
375     /**
376      * Extracts tokens from the contract
377      *
378      * @param _tokenContract The address of ERC20 compatible token
379      */
380     function retrieveTokens(address _tokenContract) public;
381 }
382 
383 
384 /**
385  * TokenRetriever
386  *
387  * Allows tokens to be retrieved from a contract
388  *
389  * #created 18/10/2017
390  * #author Frank Bonnet
391  */
392 contract TokenRetriever is ITokenRetriever {
393 
394     /**
395      * Extracts tokens from the contract
396      *
397      * @param _tokenContract The address of ERC20 compatible token
398      */
399     function retrieveTokens(address _tokenContract) public {
400         IToken tokenInstance = IToken(_tokenContract);
401         uint tokenBalance = tokenInstance.balanceOf(this);
402         if (tokenBalance > 0) {
403             tokenInstance.transfer(msg.sender, tokenBalance);
404         }
405     }
406 }
407 
408 
409 /**
410  * Input validation
411  *
412  * Validates argument length
413  *
414  * #created 01/10/2017
415  * #author Frank Bonnet
416  */
417 contract InputValidator {
418 
419 
420     /**
421      * ERC20 Short Address Attack fix
422      */
423     modifier safe_arguments(uint _numArgs) {
424         assert(msg.data.length == _numArgs * 32 + 4);
425         _;
426     }
427 }
428 
429 
430 /**
431  * ERC20 compatible token interface
432  *
433  * - Implements ERC 20 Token standard
434  * - Implements short address attack fix
435  *
436  * #created 29/09/2017
437  * #author Frank Bonnet
438  */
439 interface IToken { 
440 
441     /** 
442      * Get the total supply of tokens
443      * 
444      * @return The total supply
445      */
446     function totalSupply() public view returns (uint);
447 
448 
449     /** 
450      * Get balance of `_owner` 
451      * 
452      * @param _owner The address from which the balance will be retrieved
453      * @return The balance
454      */
455     function balanceOf(address _owner) public view returns (uint);
456 
457 
458     /** 
459      * Send `_value` token to `_to` from `msg.sender`
460      * 
461      * @param _to The address of the recipient
462      * @param _value The amount of token to be transferred
463      * @return Whether the transfer was successful or not
464      */
465     function transfer(address _to, uint _value) public returns (bool);
466 
467 
468     /** 
469      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
470      * 
471      * @param _from The address of the sender
472      * @param _to The address of the recipient
473      * @param _value The amount of token to be transferred
474      * @return Whether the transfer was successful or not
475      */
476     function transferFrom(address _from, address _to, uint _value) public returns (bool);
477 
478 
479     /** 
480      * `msg.sender` approves `_spender` to spend `_value` tokens
481      * 
482      * @param _spender The address of the account able to transfer the tokens
483      * @param _value The amount of tokens to be approved for transfer
484      * @return Whether the approval was successful or not
485      */
486     function approve(address _spender, uint _value) public returns (bool);
487 
488 
489     /** 
490      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
491      * 
492      * @param _owner The address of the account owning tokens
493      * @param _spender The address of the account able to transfer the tokens
494      * @return Amount of remaining tokens allowed to spent
495      */
496     function allowance(address _owner, address _spender) public view returns (uint);
497 }
498 
499 
500 /**
501  * ERC20 compatible token
502  *
503  * - Implements ERC 20 Token standard
504  * - Implements short address attack fix
505  *
506  * #created 29/09/2017
507  * #author Frank Bonnet
508  */
509 contract Token is IToken, InputValidator {
510 
511     // Ethereum token standard
512     string public standard = "Token 0.3.1";
513     string public name;        
514     string public symbol;
515     uint8 public decimals;
516 
517     // Token state
518     uint internal totalTokenSupply;
519 
520     // Token balances
521     mapping (address => uint) internal balances;
522 
523     // Token allowances
524     mapping (address => mapping (address => uint)) internal allowed;
525 
526 
527     // Events
528     event Transfer(address indexed _from, address indexed _to, uint _value);
529     event Approval(address indexed _owner, address indexed _spender, uint _value);
530 
531     /** 
532      * Construct ERC20 token
533      * 
534      * @param _name The full token name
535      * @param _symbol The token symbol (aberration)
536      * @param _decimals The token precision
537      */
538     function Token(string _name, string _symbol, uint8 _decimals) public {
539         name = _name;
540         symbol = _symbol;
541         decimals = _decimals;
542         balances[msg.sender] = 0;
543         totalTokenSupply = 0;
544     }
545 
546 
547     /** 
548      * Get the total token supply
549      * 
550      * @return The total supply
551      */
552     function totalSupply() public view returns (uint) {
553         return totalTokenSupply;
554     }
555 
556 
557     /** 
558      * Get balance of `_owner` 
559      * 
560      * @param _owner The address from which the balance will be retrieved
561      * @return The balance
562      */
563     function balanceOf(address _owner) public view returns (uint) {
564         return balances[_owner];
565     }
566 
567 
568     /** 
569      * Send `_value` token to `_to` from `msg.sender`
570      * 
571      * @param _to The address of the recipient
572      * @param _value The amount of token to be transferred
573      * @return Whether the transfer was successful or not
574      */
575     function transfer(address _to, uint _value) public safe_arguments(2) returns (bool) {
576 
577         // Check if the sender has enough tokens
578         require(balances[msg.sender] >= _value);   
579 
580         // Check for overflows
581         require(balances[_to] + _value >= balances[_to]);
582 
583         // Transfer tokens
584         balances[msg.sender] -= _value;
585         balances[_to] += _value;
586 
587         // Notify listeners
588         Transfer(msg.sender, _to, _value);
589         return true;
590     }
591 
592 
593     /** 
594      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
595      * 
596      * @param _from The address of the sender
597      * @param _to The address of the recipient
598      * @param _value The amount of token to be transferred
599      * @return Whether the transfer was successful or not 
600      */
601     function transferFrom(address _from, address _to, uint _value) public safe_arguments(3) returns (bool) {
602 
603         // Check if the sender has enough
604         require(balances[_from] >= _value);
605 
606         // Check for overflows
607         require(balances[_to] + _value >= balances[_to]);
608 
609         // Check allowance
610         require(_value <= allowed[_from][msg.sender]);
611 
612         // Transfer tokens
613         balances[_to] += _value;
614         balances[_from] -= _value;
615 
616         // Update allowance
617         allowed[_from][msg.sender] -= _value;
618 
619         // Notify listeners
620         Transfer(_from, _to, _value);
621         return true;
622     }
623 
624 
625     /** 
626      * `msg.sender` approves `_spender` to spend `_value` tokens
627      * 
628      * @param _spender The address of the account able to transfer the tokens
629      * @param _value The amount of tokens to be approved for transfer
630      * @return Whether the approval was successful or not
631      */
632     function approve(address _spender, uint _value) public safe_arguments(2) returns (bool) {
633 
634         // Update allowance
635         allowed[msg.sender][_spender] = _value;
636 
637         // Notify listeners
638         Approval(msg.sender, _spender, _value);
639         return true;
640     }
641 
642 
643     /** 
644      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
645      * 
646      * @param _owner The address of the account owning tokens
647      * @param _spender The address of the account able to transfer the tokens
648      * @return Amount of remaining tokens allowed to spent
649      */
650     function allowance(address _owner, address _spender) public view returns (uint) {
651       return allowed[_owner][_spender];
652     }
653 }
654 
655 
656 
657 /**
658  * IManagedToken
659  *
660  * Adds the following functionality to the basic ERC20 token
661  * - Locking
662  * - Issuing
663  * - Burning 
664  *
665  * #created 29/09/2017
666  * #author Frank Bonnet
667  */
668 interface IManagedToken { 
669 
670     /** 
671      * Returns true if the token is locked
672      * 
673      * @return Whether the token is locked
674      */
675     function isLocked() public view returns (bool);
676 
677 
678     /**
679      * Locks the token so that the transfering of value is disabled 
680      *
681      * @return Whether the unlocking was successful or not
682      */
683     function lock() public returns (bool);
684 
685 
686     /**
687      * Unlocks the token so that the transfering of value is enabled 
688      *
689      * @return Whether the unlocking was successful or not
690      */
691     function unlock() public returns (bool);
692 
693 
694     /**
695      * Issues `_value` new tokens to `_to`
696      *
697      * @param _to The address to which the tokens will be issued
698      * @param _value The amount of new tokens to issue
699      * @return Whether the tokens where sucessfully issued or not
700      */
701     function issue(address _to, uint _value) public returns (bool);
702 
703 
704     /**
705      * Burns `_value` tokens of `_from`
706      *
707      * @param _from The address that owns the tokens to be burned
708      * @param _value The amount of tokens to be burned
709      * @return Whether the tokens where sucessfully burned or not 
710      */
711     function burn(address _from, uint _value) public returns (bool);
712 }
713 
714 
715 /**
716  * ManagedToken
717  *
718  * Adds the following functionality to the basic ERC20 token
719  * - Locking
720  * - Issuing
721  * - Burning 
722  *
723  * #created 29/09/2017
724  * #author Frank Bonnet
725  */
726 contract ManagedToken is IManagedToken, Token, MultiOwned {
727 
728     // Token state
729     bool internal locked;
730 
731 
732     /**
733      * Allow access only when not locked
734      */
735     modifier only_when_unlocked() {
736         require(!locked);
737         _;
738     }
739 
740 
741     /** 
742      * Construct managed ERC20 token
743      * 
744      * @param _name The full token name
745      * @param _symbol The token symbol (aberration)
746      * @param _decimals The token precision
747      * @param _locked Whether the token should be locked initially
748      */
749     function ManagedToken(string _name, string _symbol, uint8 _decimals, bool _locked) public 
750         Token(_name, _symbol, _decimals) {
751         locked = _locked;
752     }
753 
754 
755     /** 
756      * Send `_value` token to `_to` from `msg.sender`
757      * 
758      * @param _to The address of the recipient
759      * @param _value The amount of token to be transferred
760      * @return Whether the transfer was successful or not
761      */
762     function transfer(address _to, uint _value) public only_when_unlocked returns (bool) {
763         return super.transfer(_to, _value);
764     }
765 
766 
767     /** 
768      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
769      * 
770      * @param _from The address of the sender
771      * @param _to The address of the recipient
772      * @param _value The amount of token to be transferred
773      * @return Whether the transfer was successful or not
774      */
775     function transferFrom(address _from, address _to, uint _value) public only_when_unlocked returns (bool) {
776         return super.transferFrom(_from, _to, _value);
777     }
778 
779 
780     /** 
781      * `msg.sender` approves `_spender` to spend `_value` tokens
782      * 
783      * @param _spender The address of the account able to transfer the tokens
784      * @param _value The amount of tokens to be approved for transfer
785      * @return Whether the approval was successful or not
786      */
787     function approve(address _spender, uint _value) public returns (bool) {
788         return super.approve(_spender, _value);
789     }
790 
791 
792     /** 
793      * Returns true if the token is locked
794      * 
795      * @return Whether the token is locked
796      */
797     function isLocked() public view returns (bool) {
798         return locked;
799     }
800 
801 
802     /**
803      * Locks the token so that the transfering of value is enabled 
804      *
805      * @return Whether the locking was successful or not
806      */
807     function lock() public only_owner returns (bool)  {
808         locked = true;
809         return locked;
810     }
811 
812 
813     /**
814      * Unlocks the token so that the transfering of value is enabled 
815      *
816      * @return Whether the unlocking was successful or not
817      */
818     function unlock() public only_owner returns (bool)  {
819         locked = false;
820         return !locked;
821     }
822 
823 
824     /**
825      * Issues `_value` new tokens to `_to`
826      *
827      * @param _to The address to which the tokens will be issued
828      * @param _value The amount of new tokens to issue
829      * @return Whether the approval was successful or not
830      */
831     function issue(address _to, uint _value) public only_owner safe_arguments(2) returns (bool) {
832         
833         // Check for overflows
834         require(balances[_to] + _value >= balances[_to]);
835 
836         // Create tokens
837         balances[_to] += _value;
838         totalTokenSupply += _value;
839 
840         // Notify listeners 
841         Transfer(0, this, _value);
842         Transfer(this, _to, _value);
843         return true;
844     }
845 
846 
847     /**
848      * Burns `_value` tokens of `_recipient`
849      *
850      * @param _from The address that owns the tokens to be burned
851      * @param _value The amount of tokens to be burned
852      * @return Whether the tokens where sucessfully burned or not
853      */
854     function burn(address _from, uint _value) public only_owner safe_arguments(2) returns (bool) {
855 
856         // Check if the token owner has enough tokens
857         require(balances[_from] >= _value);
858 
859         // Check for overflows
860         require(balances[_from] - _value <= balances[_from]);
861 
862         // Burn tokens
863         balances[_from] -= _value;
864         totalTokenSupply -= _value;
865 
866         // Notify listeners 
867         Transfer(_from, 0, _value);
868         return true;
869     }
870 }
871 
872 
873 /**
874  * Spend token (SPEND)
875  *
876  * SPEND is an ERC20 token as outlined within the whitepaper.
877  *
878  * #created 06/01/2018
879  * #author Frank Bonnet
880  */
881 contract SpendToken is ManagedToken, Observable, TokenRetriever {
882 
883     /**
884      * Construct the managed token
885      */
886     function SpendToken() public ManagedToken("Spend Token", "SPEND", 8, true) {}
887 
888 
889     /**
890      * Returns whether sender is allowed to register `_observer`
891      *
892      * @param _observer The address to register as an observer
893      * @return Whether the sender is allowed or not
894      */
895     function canRegisterObserver(address _observer) internal view returns (bool) {
896         return _observer != address(this) && isOwner(msg.sender);
897     }
898 
899 
900     /**
901      * Returns whether sender is allowed to unregister `_observer`
902      *
903      * @param _observer The address to unregister as an observer
904      * @return Whether the sender is allowed or not
905      */
906     function canUnregisterObserver(address _observer) internal view returns (bool) {
907         return msg.sender == _observer || isOwner(msg.sender);
908     }
909 
910 
911     /**
912      * Issues `_value` new tokens to `_to`
913      *
914      * @param _to The address to which the tokens will be issued
915      * @param _value The amount of new tokens to issue
916      * @return Whether the approval was successful or not
917      */
918     function issue(address _to, uint _value) public returns (bool) {
919         bool result = super.issue(_to, _value);
920         if (isObserver(_to)) {
921             ITokenObserver(_to).notifyTokensReceived(msg.sender, _value);
922         }
923 
924         return result;
925     }
926 
927 
928     /** 
929      * Send `_value` token to `_to` from `msg.sender`
930      * - Notifies registered observers when the observer receives tokens
931      * 
932      * @param _to The address of the recipient
933      * @param _value The amount of token to be transferred
934      * @return Whether the transfer was successful or not
935      */
936     function transfer(address _to, uint _value) public returns (bool) {
937         bool result = super.transfer(_to, _value);
938         if (isObserver(_to)) {
939             ITokenObserver(_to).notifyTokensReceived(msg.sender, _value);
940         }
941 
942         return result;
943     }
944 
945 
946     /** 
947      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
948      * - Notifies registered observers when the observer receives tokens
949      * 
950      * @param _from The address of the sender
951      * @param _to The address of the recipient
952      * @param _value The amount of token to be transferred
953      * @return Whether the transfer was successful or not
954      */
955     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
956         bool result = super.transferFrom(_from, _to, _value);
957         if (isObserver(_to)) {
958             ITokenObserver(_to).notifyTokensReceived(_from, _value);
959         }
960 
961         return result;
962     }
963 
964 
965     /**
966      * Failsafe mechanism
967      * 
968      * Allows the owner to retrieve tokens from the contract that 
969      * might have been send there by accident
970      *
971      * @param _tokenContract The address of ERC20 compatible token
972      */
973     function retrieveTokens(address _tokenContract) public only_owner {
974         super.retrieveTokens(_tokenContract);
975     }
976 
977 
978     /**
979      * Prevents the accidental sending of ether
980      */
981     function () public payable {
982         revert();
983     }
984 }