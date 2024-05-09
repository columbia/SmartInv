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
364 /**
365  * ITokenRetriever
366  *
367  * Allows tokens to be retrieved from a contract
368  *
369  * #created 29/09/2017
370  * #author Frank Bonnet
371  */
372 interface ITokenRetriever {
373 
374     /**
375      * Extracts tokens from the contract
376      *
377      * @param _tokenContract The address of ERC20 compatible token
378      */
379     function retrieveTokens(address _tokenContract) public;
380 }
381 
382 
383 /**
384  * TokenRetriever
385  *
386  * Allows tokens to be retrieved from a contract
387  *
388  * #created 18/10/2017
389  * #author Frank Bonnet
390  */
391 contract TokenRetriever is ITokenRetriever {
392 
393     /**
394      * Extracts tokens from the contract
395      *
396      * @param _tokenContract The address of ERC20 compatible token
397      */
398     function retrieveTokens(address _tokenContract) public {
399         IToken tokenInstance = IToken(_tokenContract);
400         uint tokenBalance = tokenInstance.balanceOf(this);
401         if (tokenBalance > 0) {
402             tokenInstance.transfer(msg.sender, tokenBalance);
403         }
404     }
405 }
406 
407 
408 /**
409  * Input validation
410  *
411  * Validates argument length
412  *
413  * #created 01/10/2017
414  * #author Frank Bonnet
415  */
416 contract InputValidator {
417 
418 
419     /**
420      * ERC20 Short Address Attack fix
421      */
422     modifier safe_arguments(uint _numArgs) {
423         assert(msg.data.length == _numArgs * 32 + 4);
424         _;
425     }
426 }
427 
428 
429 /**
430  * ERC20 compatible token interface
431  *
432  * - Implements ERC 20 Token standard
433  * - Implements short address attack fix
434  *
435  * #created 29/09/2017
436  * #author Frank Bonnet
437  */
438 interface IToken { 
439 
440     /** 
441      * Get the total supply of tokens
442      * 
443      * @return The total supply
444      */
445     function totalSupply() public view returns (uint);
446 
447 
448     /** 
449      * Get balance of `_owner` 
450      * 
451      * @param _owner The address from which the balance will be retrieved
452      * @return The balance
453      */
454     function balanceOf(address _owner) public view returns (uint);
455 
456 
457     /** 
458      * Send `_value` token to `_to` from `msg.sender`
459      * 
460      * @param _to The address of the recipient
461      * @param _value The amount of token to be transferred
462      * @return Whether the transfer was successful or not
463      */
464     function transfer(address _to, uint _value) public returns (bool);
465 
466 
467     /** 
468      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
469      * 
470      * @param _from The address of the sender
471      * @param _to The address of the recipient
472      * @param _value The amount of token to be transferred
473      * @return Whether the transfer was successful or not
474      */
475     function transferFrom(address _from, address _to, uint _value) public returns (bool);
476 
477 
478     /** 
479      * `msg.sender` approves `_spender` to spend `_value` tokens
480      * 
481      * @param _spender The address of the account able to transfer the tokens
482      * @param _value The amount of tokens to be approved for transfer
483      * @return Whether the approval was successful or not
484      */
485     function approve(address _spender, uint _value) public returns (bool);
486 
487 
488     /** 
489      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
490      * 
491      * @param _owner The address of the account owning tokens
492      * @param _spender The address of the account able to transfer the tokens
493      * @return Amount of remaining tokens allowed to spent
494      */
495     function allowance(address _owner, address _spender) public view returns (uint);
496 }
497 
498 
499 /**
500  * ERC20 compatible token
501  *
502  * - Implements ERC 20 Token standard
503  * - Implements short address attack fix
504  *
505  * #created 29/09/2017
506  * #author Frank Bonnet
507  */
508 contract Token is IToken, InputValidator {
509 
510     // Ethereum token standard
511     string public standard = "Token 0.3.1";
512     string public name;        
513     string public symbol;
514     uint8 public decimals;
515 
516     // Token state
517     uint internal totalTokenSupply;
518 
519     // Token balances
520     mapping (address => uint) internal balances;
521 
522     // Token allowances
523     mapping (address => mapping (address => uint)) internal allowed;
524 
525 
526     // Events
527     event Transfer(address indexed _from, address indexed _to, uint _value);
528     event Approval(address indexed _owner, address indexed _spender, uint _value);
529 
530     /** 
531      * Construct ERC20 token
532      * 
533      * @param _name The full token name
534      * @param _symbol The token symbol (aberration)
535      * @param _decimals The token precision
536      */
537     function Token(string _name, string _symbol, uint8 _decimals) public {
538         name = _name;
539         symbol = _symbol;
540         decimals = _decimals;
541         balances[msg.sender] = 0;
542         totalTokenSupply = 0;
543     }
544 
545 
546     /** 
547      * Get the total token supply
548      * 
549      * @return The total supply
550      */
551     function totalSupply() public view returns (uint) {
552         return totalTokenSupply;
553     }
554 
555 
556     /** 
557      * Get balance of `_owner` 
558      * 
559      * @param _owner The address from which the balance will be retrieved
560      * @return The balance
561      */
562     function balanceOf(address _owner) public view returns (uint) {
563         return balances[_owner];
564     }
565 
566 
567     /** 
568      * Send `_value` token to `_to` from `msg.sender`
569      * 
570      * @param _to The address of the recipient
571      * @param _value The amount of token to be transferred
572      * @return Whether the transfer was successful or not
573      */
574     function transfer(address _to, uint _value) public safe_arguments(2) returns (bool) {
575 
576         // Check if the sender has enough tokens
577         require(balances[msg.sender] >= _value);   
578 
579         // Check for overflows
580         require(balances[_to] + _value >= balances[_to]);
581 
582         // Transfer tokens
583         balances[msg.sender] -= _value;
584         balances[_to] += _value;
585 
586         // Notify listeners
587         Transfer(msg.sender, _to, _value);
588         return true;
589     }
590 
591 
592     /** 
593      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
594      * 
595      * @param _from The address of the sender
596      * @param _to The address of the recipient
597      * @param _value The amount of token to be transferred
598      * @return Whether the transfer was successful or not 
599      */
600     function transferFrom(address _from, address _to, uint _value) public safe_arguments(3) returns (bool) {
601 
602         // Check if the sender has enough
603         require(balances[_from] >= _value);
604 
605         // Check for overflows
606         require(balances[_to] + _value >= balances[_to]);
607 
608         // Check allowance
609         require(_value <= allowed[_from][msg.sender]);
610 
611         // Transfer tokens
612         balances[_to] += _value;
613         balances[_from] -= _value;
614 
615         // Update allowance
616         allowed[_from][msg.sender] -= _value;
617 
618         // Notify listeners
619         Transfer(_from, _to, _value);
620         return true;
621     }
622 
623 
624     /** 
625      * `msg.sender` approves `_spender` to spend `_value` tokens
626      * 
627      * @param _spender The address of the account able to transfer the tokens
628      * @param _value The amount of tokens to be approved for transfer
629      * @return Whether the approval was successful or not
630      */
631     function approve(address _spender, uint _value) public safe_arguments(2) returns (bool) {
632 
633         // Update allowance
634         allowed[msg.sender][_spender] = _value;
635 
636         // Notify listeners
637         Approval(msg.sender, _spender, _value);
638         return true;
639     }
640 
641 
642     /** 
643      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
644      * 
645      * @param _owner The address of the account owning tokens
646      * @param _spender The address of the account able to transfer the tokens
647      * @return Amount of remaining tokens allowed to spent
648      */
649     function allowance(address _owner, address _spender) public view returns (uint) {
650       return allowed[_owner][_spender];
651     }
652 }
653 
654 
655 
656 /**
657  * IManagedToken
658  *
659  * Adds the following functionality to the basic ERC20 token
660  * - Locking
661  * - Issuing
662  * - Burning 
663  *
664  * #created 29/09/2017
665  * #author Frank Bonnet
666  */
667 interface IManagedToken { 
668 
669     /** 
670      * Returns true if the token is locked
671      * 
672      * @return Whether the token is locked
673      */
674     function isLocked() public view returns (bool);
675 
676 
677     /**
678      * Locks the token so that the transfering of value is disabled 
679      *
680      * @return Whether the unlocking was successful or not
681      */
682     function lock() public returns (bool);
683 
684 
685     /**
686      * Unlocks the token so that the transfering of value is enabled 
687      *
688      * @return Whether the unlocking was successful or not
689      */
690     function unlock() public returns (bool);
691 
692 
693     /**
694      * Issues `_value` new tokens to `_to`
695      *
696      * @param _to The address to which the tokens will be issued
697      * @param _value The amount of new tokens to issue
698      * @return Whether the tokens where sucessfully issued or not
699      */
700     function issue(address _to, uint _value) public returns (bool);
701 
702 
703     /**
704      * Burns `_value` tokens of `_from`
705      *
706      * @param _from The address that owns the tokens to be burned
707      * @param _value The amount of tokens to be burned
708      * @return Whether the tokens where sucessfully burned or not 
709      */
710     function burn(address _from, uint _value) public returns (bool);
711 }
712 
713 
714 /**
715  * ManagedToken
716  *
717  * Adds the following functionality to the basic ERC20 token
718  * - Locking
719  * - Issuing
720  * - Burning 
721  *
722  * #created 29/09/2017
723  * #author Frank Bonnet
724  */
725 contract ManagedToken is IManagedToken, Token, MultiOwned {
726 
727     // Token state
728     bool internal locked;
729 
730 
731     /**
732      * Allow access only when not locked
733      */
734     modifier only_when_unlocked() {
735         require(!locked);
736         _;
737     }
738 
739 
740     /** 
741      * Construct managed ERC20 token
742      * 
743      * @param _name The full token name
744      * @param _symbol The token symbol (aberration)
745      * @param _decimals The token precision
746      * @param _locked Whether the token should be locked initially
747      */
748     function ManagedToken(string _name, string _symbol, uint8 _decimals, bool _locked) public 
749         Token(_name, _symbol, _decimals) {
750         locked = _locked;
751     }
752 
753 
754     /** 
755      * Send `_value` token to `_to` from `msg.sender`
756      * 
757      * @param _to The address of the recipient
758      * @param _value The amount of token to be transferred
759      * @return Whether the transfer was successful or not
760      */
761     function transfer(address _to, uint _value) public only_when_unlocked returns (bool) {
762         return super.transfer(_to, _value);
763     }
764 
765 
766     /** 
767      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
768      * 
769      * @param _from The address of the sender
770      * @param _to The address of the recipient
771      * @param _value The amount of token to be transferred
772      * @return Whether the transfer was successful or not
773      */
774     function transferFrom(address _from, address _to, uint _value) public only_when_unlocked returns (bool) {
775         return super.transferFrom(_from, _to, _value);
776     }
777 
778 
779     /** 
780      * `msg.sender` approves `_spender` to spend `_value` tokens
781      * 
782      * @param _spender The address of the account able to transfer the tokens
783      * @param _value The amount of tokens to be approved for transfer
784      * @return Whether the approval was successful or not
785      */
786     function approve(address _spender, uint _value) public returns (bool) {
787         return super.approve(_spender, _value);
788     }
789 
790 
791     /** 
792      * Returns true if the token is locked
793      * 
794      * @return Whether the token is locked
795      */
796     function isLocked() public view returns (bool) {
797         return locked;
798     }
799 
800 
801     /**
802      * Locks the token so that the transfering of value is enabled 
803      *
804      * @return Whether the locking was successful or not
805      */
806     function lock() public only_owner returns (bool)  {
807         locked = true;
808         return locked;
809     }
810 
811 
812     /**
813      * Unlocks the token so that the transfering of value is enabled 
814      *
815      * @return Whether the unlocking was successful or not
816      */
817     function unlock() public only_owner returns (bool)  {
818         locked = false;
819         return !locked;
820     }
821 
822 
823     /**
824      * Issues `_value` new tokens to `_to`
825      *
826      * @param _to The address to which the tokens will be issued
827      * @param _value The amount of new tokens to issue
828      * @return Whether the approval was successful or not
829      */
830     function issue(address _to, uint _value) public only_owner safe_arguments(2) returns (bool) {
831         
832         // Check for overflows
833         require(balances[_to] + _value >= balances[_to]);
834 
835         // Create tokens
836         balances[_to] += _value;
837         totalTokenSupply += _value;
838 
839         // Notify listeners 
840         Transfer(0, this, _value);
841         Transfer(this, _to, _value);
842         return true;
843     }
844 
845 
846     /**
847      * Burns `_value` tokens of `_recipient`
848      *
849      * @param _from The address that owns the tokens to be burned
850      * @param _value The amount of tokens to be burned
851      * @return Whether the tokens where sucessfully burned or not
852      */
853     function burn(address _from, uint _value) public only_owner safe_arguments(2) returns (bool) {
854 
855         // Check if the token owner has enough tokens
856         require(balances[_from] >= _value);
857 
858         // Check for overflows
859         require(balances[_from] - _value <= balances[_from]);
860 
861         // Burn tokens
862         balances[_from] -= _value;
863         totalTokenSupply -= _value;
864 
865         // Notify listeners 
866         Transfer(_from, 0, _value);
867         return true;
868     }
869 }
870 
871 
872 /**
873  * KATM Utility token (KATX)
874  *
875  * KATX as indicated by its ‘X’ designation is the utility token for those who are under strict 
876  * compliance within their country of residence, and does not entitle holders to profit sharing.
877  *
878  * #created 30/10/2017
879  * #author Frank Bonnet
880  */
881 contract KATXToken is ManagedToken, Observable, TokenRetriever {
882 
883 
884     /**
885      * Construct the managed utility token
886      */
887     function KATXToken() public ManagedToken("KATM Utility", "KATX", 8, false) {}
888 
889 
890     /**
891      * Returns whether sender is allowed to register `_observer`
892      *
893      * @param _observer The address to register as an observer
894      * @return Whether the sender is allowed or not
895      */
896     function canRegisterObserver(address _observer) internal view returns (bool) {
897         return _observer != address(this) && isOwner(msg.sender);
898     }
899 
900 
901     /**
902      * Returns whether sender is allowed to unregister `_observer`
903      *
904      * @param _observer The address to unregister as an observer
905      * @return Whether the sender is allowed or not
906      */
907     function canUnregisterObserver(address _observer) internal view returns (bool) {
908         return msg.sender == _observer || isOwner(msg.sender);
909     }
910 
911 
912     /** 
913      * Send `_value` token to `_to` from `msg.sender`
914      * - Notifies registered observers when the observer receives tokens
915      * 
916      * @param _to The address of the recipient
917      * @param _value The amount of token to be transferred
918      * @return Whether the transfer was successful or not
919      */
920     function transfer(address _to, uint _value) public returns (bool) {
921         bool result = super.transfer(_to, _value);
922         if (isObserver(_to)) {
923             ITokenObserver(_to).notifyTokensReceived(msg.sender, _value);
924         }
925 
926         return result;
927     }
928 
929 
930     /** 
931      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
932      * - Notifies registered observers when the observer receives tokens
933      * 
934      * @param _from The address of the sender
935      * @param _to The address of the recipient
936      * @param _value The amount of token to be transferred
937      * @return Whether the transfer was successful or not
938      */
939     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
940         bool result = super.transferFrom(_from, _to, _value);
941         if (isObserver(_to)) {
942             ITokenObserver(_to).notifyTokensReceived(_from, _value);
943         }
944 
945         return result;
946     }
947 
948 
949     /**
950      * Failsafe mechanism
951      * 
952      * Allows the owner to retrieve tokens from the contract that 
953      * might have been send there by accident
954      *
955      * @param _tokenContract The address of ERC20 compatible token
956      */
957     function retrieveTokens(address _tokenContract) public only_owner {
958         super.retrieveTokens(_tokenContract);
959     }
960 
961 
962     /**
963      * Prevents the accidental sending of ether
964      */
965     function () public payable {
966         revert();
967     }
968 }