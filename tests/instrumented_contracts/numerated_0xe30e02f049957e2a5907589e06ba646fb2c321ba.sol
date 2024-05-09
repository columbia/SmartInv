1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Input validation
5  *
6  * - Validates argument length
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 contract InputValidator {
12 
13     /**
14      * ERC20 Short Address Attack fix
15      */
16     modifier safe_arguments(uint _numArgs) {
17         assert(msg.data.length == _numArgs * 32 + 4);
18         _;
19     }
20 }
21 
22 
23 /**
24  * @title Multi-owned interface
25  *
26  * Interface that allows multiple owners
27  *
28  * #created 09/10/2017
29  * #author Frank Bonnet
30  */
31 contract IMultiOwned {
32 
33     /**
34      * Returns true if `_account` is an owner
35      *
36      * @param _account The address to test against
37      */
38     function isOwner(address _account) constant returns (bool);
39 
40 
41     /**
42      * Returns the amount of owners
43      *
44      * @return The amount of owners
45      */
46     function getOwnerCount() constant returns (uint);
47 
48 
49     /**
50      * Gets the owner at `_index`
51      *
52      * @param _index The index of the owner
53      * @return The address of the owner found at `_index`
54      */
55     function getOwnerAt(uint _index) constant returns (address);
56 
57 
58      /**
59      * Adds `_account` as a new owner
60      *
61      * @param _account The account to add as an owner
62      */
63     function addOwner(address _account);
64 
65 
66     /**
67      * Removes `_account` as an owner
68      *
69      * @param _account The account to remove as an owner
70      */
71     function removeOwner(address _account);
72 }
73 
74 
75 /**
76  * @title Multi-owned
77  *
78  * Allows multiple owners
79  *
80  * #created 09/10/2017
81  * #author Frank Bonnet
82  */
83 contract MultiOwned is IMultiOwned {
84 
85     // Owners
86     mapping (address => uint) private owners;
87     address[] private ownersIndex;
88 
89 
90      /**
91      * Access is restricted to owners only
92      */
93     modifier only_owner() {
94         require(isOwner(msg.sender));
95         _;
96     }
97 
98 
99     /**
100      * The publisher is the initial owner
101      */
102     function MultiOwned() {
103         ownersIndex.push(msg.sender);
104         owners[msg.sender] = 0;
105     }
106 
107 
108     /**
109      * Returns true if `_account` is the current owner
110      *
111      * @param _account The address to test against
112      */
113     function isOwner(address _account) public constant returns (bool) {
114         return owners[_account] < ownersIndex.length && _account == ownersIndex[owners[_account]];
115     }
116 
117 
118     /**
119      * Returns the amount of owners
120      *
121      * @return The amount of owners
122      */
123     function getOwnerCount() public constant returns (uint) {
124         return ownersIndex.length;
125     }
126 
127 
128     /**
129      * Gets the owner at `_index`
130      *
131      * @param _index The index of the owner
132      * @return The address of the owner found at `_index`
133      */
134     function getOwnerAt(uint _index) public constant returns (address) {
135         return ownersIndex[_index];
136     }
137 
138 
139     /**
140      * Adds `_account` as a new owner
141      *
142      * @param _account The account to add as an owner
143      */
144     function addOwner(address _account) public only_owner {
145         if (!isOwner(_account)) {
146             owners[_account] = ownersIndex.push(_account) - 1;
147         }
148     }
149 
150 
151     /**
152      * Removes `_account` as an owner
153      *
154      * @param _account The account to remove as an owner
155      */
156     function removeOwner(address _account) public only_owner {
157         if (isOwner(_account)) {
158             uint indexToDelete = owners[_account];
159             address keyToMove = ownersIndex[ownersIndex.length - 1];
160             ownersIndex[indexToDelete] = keyToMove;
161             owners[keyToMove] = indexToDelete; 
162             ownersIndex.length--;
163         }
164     }
165 }
166 
167 
168 /**
169  * @title Token retrieve interface
170  *
171  * Allows tokens to be retrieved from a contract
172  *
173  * #created 29/09/2017
174  * #author Frank Bonnet
175  */
176 contract ITokenRetriever {
177 
178     /**
179      * Extracts tokens from the contract
180      *
181      * @param _tokenContract The address of ERC20 compatible token
182      */
183     function retrieveTokens(address _tokenContract);
184 }
185 
186 
187 /**
188  * @title Token retrieve
189  *
190  * Allows tokens to be retrieved from a contract
191  *
192  * #created 18/10/2017
193  * #author Frank Bonnet
194  */
195 contract TokenRetriever is ITokenRetriever {
196 
197     /**
198      * Extracts tokens from the contract
199      *
200      * @param _tokenContract The address of ERC20 compatible token
201      */
202     function retrieveTokens(address _tokenContract) public {
203         IToken tokenInstance = IToken(_tokenContract);
204         uint tokenBalance = tokenInstance.balanceOf(this);
205         if (tokenBalance > 0) {
206             tokenInstance.transfer(msg.sender, tokenBalance);
207         }
208     }
209 }
210 
211 
212 /**
213  * @title Observable interface
214  *
215  * Allows observers to register and unregister with the 
216  * implementing smart-contract that is observable
217  *
218  * #created 09/10/2017
219  * #author Frank Bonnet
220  */
221 contract IObservable {
222 
223     /**
224      * Returns true if `_account` is a registered observer
225      * 
226      * @param _account The account to test against
227      * @return Whether the account is a registered observer
228      */
229     function isObserver(address _account) constant returns (bool);
230 
231 
232     /**
233      * Gets the amount of registered observers
234      * 
235      * @return The amount of registered observers
236      */
237     function getObserverCount() constant returns (uint);
238 
239 
240     /**
241      * Gets the observer at `_index`
242      * 
243      * @param _index The index of the observer
244      * @return The observers address
245      */
246     function getObserverAtIndex(uint _index) constant returns (address);
247 
248 
249     /**
250      * Register `_observer` as an observer
251      * 
252      * @param _observer The account to add as an observer
253      */
254     function registerObserver(address _observer);
255 
256 
257     /**
258      * Unregister `_observer` as an observer
259      * 
260      * @param _observer The account to remove as an observer
261      */
262     function unregisterObserver(address _observer);
263 }
264 
265 
266 /**
267  * @title Abstract Observable
268  *
269  * Allows observers to register and unregister with the the 
270  * implementing smart-contract that is observable
271  *
272  * #created 09/10/2017
273  * #author Frank Bonnet
274  */
275 contract Observable is IObservable {
276 
277     // Observers
278     mapping(address => uint) private observers;
279     address[] private observerIndex;
280 
281 
282     /**
283      * Returns true if `_account` is a registered observer
284      * 
285      * @param _account The account to test against
286      * @return Whether the account is a registered observer
287      */
288     function isObserver(address _account) public constant returns (bool) {
289         return observers[_account] < observerIndex.length && _account == observerIndex[observers[_account]];
290     }
291 
292 
293     /**
294      * Gets the amount of registered observers
295      * 
296      * @return The amount of registered observers
297      */
298     function getObserverCount() public constant returns (uint) {
299         return observerIndex.length;
300     }
301 
302 
303     /**
304      * Gets the observer at `_index`
305      * 
306      * @param _index The index of the observer
307      * @return The observers address
308      */
309     function getObserverAtIndex(uint _index) public constant returns (address) {
310         return observerIndex[_index];
311     }
312 
313 
314     /**
315      * Register `_observer` as an observer
316      * 
317      * @param _observer The account to add as an observer
318      */
319     function registerObserver(address _observer) public {
320         require(canRegisterObserver(_observer));
321         if (!isObserver(_observer)) {
322             observers[_observer] = observerIndex.push(_observer) - 1;
323         }
324     }
325 
326 
327     /**
328      * Unregister `_observer` as an observer
329      * 
330      * @param _observer The account to remove as an observer
331      */
332     function unregisterObserver(address _observer) public {
333         require(canUnregisterObserver(_observer));
334         if (isObserver(_observer)) {
335             uint indexToDelete = observers[_observer];
336             address keyToMove = observerIndex[observerIndex.length - 1];
337             observerIndex[indexToDelete] = keyToMove;
338             observers[keyToMove] = indexToDelete;
339             observerIndex.length--;
340         }
341     }
342 
343 
344     /**
345      * Returns whether it is allowed to register `_observer` by calling 
346      * canRegisterObserver() in the implementing smart-contract
347      *
348      * @param _observer The address to register as an observer
349      * @return Whether the sender is allowed or not
350      */
351     function canRegisterObserver(address _observer) internal constant returns (bool);
352 
353 
354     /**
355      * Returns whether it is allowed to unregister `_observer` by calling 
356      * canRegisterObserver() in the implementing smart-contract
357      *
358      * @param _observer The address to unregister as an observer
359      * @return Whether the sender is allowed or not
360      */
361     function canUnregisterObserver(address _observer) internal constant returns (bool);
362 }
363 
364 
365 /**
366  * @title Token observer interface
367  *
368  * Allows a token smart-contract to notify observers 
369  * when tokens are received
370  *
371  * #created 09/10/2017
372  * #author Frank Bonnet
373  */
374 contract ITokenObserver {
375 
376     /**
377      * Called by the observed token smart-contract in order 
378      * to notify the token observer when tokens are received
379      *
380      * @param _from The address that the tokens where send from
381      * @param _value The amount of tokens that was received
382      */
383     function notifyTokensReceived(address _from, uint _value);
384 }
385 
386 
387 /**
388  * @title ERC20 compatible token interface
389  *
390  * - Implements ERC 20 Token standard
391  * - Implements short address attack fix
392  *
393  * #created 29/09/2017
394  * #author Frank Bonnet
395  */
396 contract IToken { 
397 
398     /** 
399      * Get the total supply of tokens
400      * 
401      * @return The total supply
402      */
403     function totalSupply() constant returns (uint);
404 
405 
406     /** 
407      * Get balance of `_owner` 
408      * 
409      * @param _owner The address from which the balance will be retrieved
410      * @return The balance
411      */
412     function balanceOf(address _owner) constant returns (uint);
413 
414 
415     /** 
416      * Send `_value` token to `_to` from `msg.sender`
417      * 
418      * @param _to The address of the recipient
419      * @param _value The amount of token to be transferred
420      * @return Whether the transfer was successful or not
421      */
422     function transfer(address _to, uint _value) returns (bool);
423 
424 
425     /** 
426      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
427      * 
428      * @param _from The address of the sender
429      * @param _to The address of the recipient
430      * @param _value The amount of token to be transferred
431      * @return Whether the transfer was successful or not
432      */
433     function transferFrom(address _from, address _to, uint _value) returns (bool);
434 
435 
436     /** 
437      * `msg.sender` approves `_spender` to spend `_value` tokens
438      * 
439      * @param _spender The address of the account able to transfer the tokens
440      * @param _value The amount of tokens to be approved for transfer
441      * @return Whether the approval was successful or not
442      */
443     function approve(address _spender, uint _value) returns (bool);
444 
445 
446     /** 
447      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
448      * 
449      * @param _owner The address of the account owning tokens
450      * @param _spender The address of the account able to transfer the tokens
451      * @return Amount of remaining tokens allowed to spent
452      */
453     function allowance(address _owner, address _spender) constant returns (uint);
454 }
455 
456 
457 /**
458  * @title ERC20 compatible token
459  *
460  * - Implements ERC 20 Token standard
461  * - Implements short address attack fix
462  *
463  * #created 29/09/2017
464  * #author Frank Bonnet
465  */
466 contract Token is IToken, InputValidator {
467 
468     // Ethereum token standard
469     string public standard = "Token 0.3";
470     string public name;        
471     string public symbol;
472     uint8 public decimals;
473 
474     // Token state
475     uint internal totalTokenSupply;
476 
477     // Token balances
478     mapping (address => uint) internal balances;
479 
480     // Token allowances
481     mapping (address => mapping (address => uint)) internal allowed;
482 
483 
484     // Events
485     event Transfer(address indexed _from, address indexed _to, uint _value);
486     event Approval(address indexed _owner, address indexed _spender, uint _value);
487 
488     /** 
489      * Construct ERC20 token
490      * 
491      * @param _name The full token name
492      * @param _symbol The token symbol (aberration)
493      * @param _decimals The token precision
494      */
495     function Token(string _name, string _symbol, uint8 _decimals) {
496         name = _name;
497         symbol = _symbol;
498         decimals = _decimals;
499         balances[msg.sender] = 0;
500         totalTokenSupply = 0;
501     }
502 
503 
504     /** 
505      * Get the total token supply
506      * 
507      * @return The total supply
508      */
509     function totalSupply() public constant returns (uint) {
510         return totalTokenSupply;
511     }
512 
513 
514     /** 
515      * Get balance of `_owner` 
516      * 
517      * @param _owner The address from which the balance will be retrieved
518      * @return The balance
519      */
520     function balanceOf(address _owner) public constant returns (uint) {
521         return balances[_owner];
522     }
523 
524 
525     /** 
526      * Send `_value` token to `_to` from `msg.sender`
527      * 
528      * @param _to The address of the recipient
529      * @param _value The amount of token to be transferred
530      * @return Whether the transfer was successful or not
531      */
532     function transfer(address _to, uint _value) public safe_arguments(2) returns (bool) {
533 
534         // Check if the sender has enough tokens
535         require(balances[msg.sender] >= _value);   
536 
537         // Check for overflows
538         require(balances[_to] + _value >= balances[_to]);
539 
540         // Transfer tokens
541         balances[msg.sender] -= _value;
542         balances[_to] += _value;
543 
544         // Notify listeners
545         Transfer(msg.sender, _to, _value);
546         return true;
547     }
548 
549 
550     /** 
551      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
552      * 
553      * @param _from The address of the sender
554      * @param _to The address of the recipient
555      * @param _value The amount of token to be transferred
556      * @return Whether the transfer was successful or not 
557      */
558     function transferFrom(address _from, address _to, uint _value) public safe_arguments(3) returns (bool) {
559 
560         // Check if the sender has enough
561         require(balances[_from] >= _value);
562 
563         // Check for overflows
564         require(balances[_to] + _value >= balances[_to]);
565 
566         // Check allowance
567         require(_value <= allowed[_from][msg.sender]);
568 
569         // Transfer tokens
570         balances[_to] += _value;
571         balances[_from] -= _value;
572 
573         // Update allowance
574         allowed[_from][msg.sender] -= _value;
575 
576         // Notify listeners
577         Transfer(_from, _to, _value);
578         return true;
579     }
580 
581 
582     /** 
583      * `msg.sender` approves `_spender` to spend `_value` tokens
584      * 
585      * @param _spender The address of the account able to transfer the tokens
586      * @param _value The amount of tokens to be approved for transfer
587      * @return Whether the approval was successful or not
588      */
589     function approve(address _spender, uint _value) public safe_arguments(2) returns (bool) {
590 
591         // Update allowance
592         allowed[msg.sender][_spender] = _value;
593 
594         // Notify listeners
595         Approval(msg.sender, _spender, _value);
596         return true;
597     }
598 
599 
600     /** 
601      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
602      * 
603      * @param _owner The address of the account owning tokens
604      * @param _spender The address of the account able to transfer the tokens
605      * @return Amount of remaining tokens allowed to spent
606      */
607     function allowance(address _owner, address _spender) public constant returns (uint) {
608       return allowed[_owner][_spender];
609     }
610 }
611 
612 
613 /**
614  * @title ManagedToken interface
615  *
616  * Adds the following functionality to the basic ERC20 token
617  * - Locking
618  * - Issuing
619  * - Burning 
620  *
621  * #created 29/09/2017
622  * #author Frank Bonnet
623  */
624 contract IManagedToken is IToken { 
625 
626     /** 
627      * Returns true if the token is locked
628      * 
629      * @return Whether the token is locked
630      */
631     function isLocked() constant returns (bool);
632 
633 
634     /**
635      * Locks the token so that the transfering of value is disabled 
636      *
637      * @return Whether the unlocking was successful or not
638      */
639     function lock() returns (bool);
640 
641 
642     /**
643      * Unlocks the token so that the transfering of value is enabled 
644      *
645      * @return Whether the unlocking was successful or not
646      */
647     function unlock() returns (bool);
648 
649 
650     /**
651      * Issues `_value` new tokens to `_to`
652      *
653      * @param _to The address to which the tokens will be issued
654      * @param _value The amount of new tokens to issue
655      * @return Whether the tokens where sucessfully issued or not
656      */
657     function issue(address _to, uint _value) returns (bool);
658 
659 
660     /**
661      * Burns `_value` tokens of `_from`
662      *
663      * @param _from The address that owns the tokens to be burned
664      * @param _value The amount of tokens to be burned
665      * @return Whether the tokens where sucessfully burned or not 
666      */
667     function burn(address _from, uint _value) returns (bool);
668 }
669 
670 
671 /**
672  * @title ManagedToken
673  *
674  * Adds the following functionality to the basic ERC20 token
675  * - Locking
676  * - Issuing
677  * - Burning 
678  *
679  * #created 29/09/2017
680  * #author Frank Bonnet
681  */
682 contract ManagedToken is IManagedToken, Token, MultiOwned {
683 
684     // Token state
685     bool internal locked;
686 
687 
688     /**
689      * Allow access only when not locked
690      */
691     modifier only_when_unlocked() {
692         require(!locked);
693         _;
694     }
695 
696 
697     /** 
698      * Construct managed ERC20 token
699      * 
700      * @param _name The full token name
701      * @param _symbol The token symbol (aberration)
702      * @param _decimals The token precision
703      * @param _locked Whether the token should be locked initially
704      */
705     function ManagedToken(string _name, string _symbol, uint8 _decimals, bool _locked) 
706         Token(_name, _symbol, _decimals) {
707         locked = _locked;
708     }
709 
710 
711     /** 
712      * Send `_value` token to `_to` from `msg.sender`
713      * 
714      * @param _to The address of the recipient
715      * @param _value The amount of token to be transferred
716      * @return Whether the transfer was successful or not
717      */
718     function transfer(address _to, uint _value) public only_when_unlocked returns (bool) {
719         return super.transfer(_to, _value);
720     }
721 
722 
723     /** 
724      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
725      * 
726      * @param _from The address of the sender
727      * @param _to The address of the recipient
728      * @param _value The amount of token to be transferred
729      * @return Whether the transfer was successful or not
730      */
731     function transferFrom(address _from, address _to, uint _value) public only_when_unlocked returns (bool) {
732         return super.transferFrom(_from, _to, _value);
733     }
734 
735 
736     /** 
737      * `msg.sender` approves `_spender` to spend `_value` tokens
738      * 
739      * @param _spender The address of the account able to transfer the tokens
740      * @param _value The amount of tokens to be approved for transfer
741      * @return Whether the approval was successful or not
742      */
743     function approve(address _spender, uint _value) public returns (bool) {
744         return super.approve(_spender, _value);
745     }
746 
747 
748     /** 
749      * Returns true if the token is locked
750      * 
751      * @return Whether the token is locked
752      */
753     function isLocked() public constant returns (bool) {
754         return locked;
755     }
756 
757 
758     /**
759      * Locks the token so that the transfering of value is enabled 
760      *
761      * @return Whether the locking was successful or not
762      */
763     function lock() public only_owner returns (bool)  {
764         locked = true;
765         return locked;
766     }
767 
768 
769     /**
770      * Unlocks the token so that the transfering of value is enabled 
771      *
772      * @return Whether the unlocking was successful or not
773      */
774     function unlock() public only_owner returns (bool)  {
775         locked = false;
776         return !locked;
777     }
778 
779 
780     /**
781      * Issues `_value` new tokens to `_to`
782      *
783      * @param _to The address to which the tokens will be issued
784      * @param _value The amount of new tokens to issue
785      * @return Whether the approval was successful or not
786      */
787     function issue(address _to, uint _value) public only_owner safe_arguments(2) returns (bool) {
788         
789         // Check for overflows
790         require(balances[_to] + _value >= balances[_to]);
791 
792         // Create tokens
793         balances[_to] += _value;
794         totalTokenSupply += _value;
795 
796         // Notify listeners 
797         Transfer(0, this, _value);
798         Transfer(this, _to, _value);
799         return true;
800     }
801 
802 
803     /**
804      * Burns `_value` tokens of `_recipient`
805      *
806      * @param _from The address that owns the tokens to be burned
807      * @param _value The amount of tokens to be burned
808      * @return Whether the tokens where sucessfully burned or not
809      */
810     function burn(address _from, uint _value) public only_owner safe_arguments(2) returns (bool) {
811 
812         // Check if the token owner has enough tokens
813         require(balances[_from] >= _value);
814 
815         // Check for overflows
816         require(balances[_from] - _value <= balances[_from]);
817 
818         // Burn tokens
819         balances[_from] -= _value;
820         totalTokenSupply -= _value;
821 
822         // Notify listeners 
823         Transfer(_from, 0, _value);
824         return true;
825     }
826 }
827 
828 
829 /**
830  * @title DRP Utility token (DRPU)
831  *
832  * DRPU as indicated by its ‘U’ designation is Dcorp’s utility token for those who are under strict 
833  * compliance within their country of residence, and does not entitle holders to profit sharing.
834  *
835  * https://www.dcorp.it/drpu
836  *
837  * #created 01/10/2017
838  * #author Frank Bonnet
839  */
840 contract DRPUToken is ManagedToken, Observable, TokenRetriever {
841 
842     /**
843      * Construct the managed utility token
844      */
845     function DRPUToken() ManagedToken("DRP Utility", "DRPU", 8, false) {}
846 
847 
848     /**
849      * Returns whether sender is allowed to register `_observer`
850      *
851      * @param _observer The address to register as an observer
852      * @return Whether the sender is allowed or not
853      */
854     function canRegisterObserver(address _observer) internal constant returns (bool) {
855         return _observer != address(this) && isOwner(msg.sender);
856     }
857 
858 
859     /**
860      * Returns whether sender is allowed to unregister `_observer`
861      *
862      * @param _observer The address to unregister as an observer
863      * @return Whether the sender is allowed or not
864      */
865     function canUnregisterObserver(address _observer) internal constant returns (bool) {
866         return msg.sender == _observer || isOwner(msg.sender);
867     }
868 
869 
870     /** 
871      * Send `_value` token to `_to` from `msg.sender`
872      * - Notifies registered observers when the observer receives tokens
873      * 
874      * @param _to The address of the recipient
875      * @param _value The amount of token to be transferred
876      * @return Whether the transfer was successful or not
877      */
878     function transfer(address _to, uint _value) public returns (bool) {
879         bool result = super.transfer(_to, _value);
880         if (isObserver(_to)) {
881             ITokenObserver(_to).notifyTokensReceived(msg.sender, _value);
882         }
883 
884         return result;
885     }
886 
887 
888     /** 
889      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
890      * - Notifies registered observers when the observer receives tokens
891      * 
892      * @param _from The address of the sender
893      * @param _to The address of the recipient
894      * @param _value The amount of token to be transferred
895      * @return Whether the transfer was successful or not
896      */
897     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
898         bool result = super.transferFrom(_from, _to, _value);
899         if (isObserver(_to)) {
900             ITokenObserver(_to).notifyTokensReceived(_from, _value);
901         }
902 
903         return result;
904     }
905 
906 
907     /**
908      * Failsafe mechanism
909      * 
910      * Allows the owner to retrieve tokens from the contract that 
911      * might have been send there by accident
912      *
913      * @param _tokenContract The address of ERC20 compatible token
914      */
915     function retrieveTokens(address _tokenContract) public only_owner {
916         super.retrieveTokens(_tokenContract);
917     }
918 
919 
920     /**
921      * Prevents the accidental sending of ether
922      */
923     function () payable {
924         revert();
925     }
926 }