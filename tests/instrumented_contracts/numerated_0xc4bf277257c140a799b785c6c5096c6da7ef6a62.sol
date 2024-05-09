1 pragma solidity >=0.4.24 <0.5.0;
2 
3 /**
4  *
5  *  @title AddressMap
6  *  @dev Map of unique indexed addresseses.
7  *
8  *  **NOTE**
9  *    The internal collections are one-based.
10  *    This is simply because null values are expressed as zero,
11  *    which makes it hard to check for the existence of items within the array,
12  *    or grabbing the first item of an array for non-existent items.
13  *
14  *    This is only exposed internally, so callers still use zero-based indices.
15  *
16  */
17 library AddressMap {
18     address constant ZERO_ADDRESS = address(0);
19 
20     struct Data {
21         int256 count;
22         mapping(address => int256) indices;
23         mapping(int256 => address) items;
24     }
25 
26     /**
27      *  Appends the address to the end of the map, if the addres is not
28      *  zero and the address doesn't currently exist.
29      *  @param addr The address to append.
30      *  @return true if the address was added.
31      */
32     function append(Data storage self, address addr)
33     internal
34     returns (bool) {
35         if (addr == ZERO_ADDRESS) {
36             return false;
37         }
38 
39         int256 index = self.indices[addr] - 1;
40         if (index >= 0 && index < self.count) {
41             return false;
42         }
43 
44         self.count++;
45         self.indices[addr] = self.count;
46         self.items[self.count] = addr;
47         return true;
48     }
49 
50     /**
51      *  Removes the given address from the map.
52      *  @param addr The address to remove from the map.
53      *  @return true if the address was removed.
54      */
55     function remove(Data storage self, address addr)
56     internal
57     returns (bool) {
58         int256 oneBasedIndex = self.indices[addr];
59         if (oneBasedIndex < 1 || oneBasedIndex > self.count) {
60             return false;  // address doesn't exist, or zero.
61         }
62 
63         // When the item being removed is not the last item in the collection,
64         // replace that item with the last one, otherwise zero it out.
65         //
66         //  If {2} is the item to be removed
67         //     [0, 1, 2, 3, 4]
68         //  The result would be:
69         //     [0, 1, 4, 3]
70         //
71         if (oneBasedIndex < self.count) {
72             // Replace with last item
73             address last = self.items[self.count];  // Get the last item
74             self.indices[last] = oneBasedIndex;     // Update last items index to current index
75             self.items[oneBasedIndex] = last;       // Update current index to last item
76             delete self.items[self.count];          // Delete the last item, since it's moved
77         } else {
78             // Delete the address
79             delete self.items[oneBasedIndex];
80         }
81 
82         delete self.indices[addr];
83         self.count--;
84         return true;
85     }
86 
87     /**
88      *  Retrieves the address at the given index.
89      *  THROWS when the index is invalid.
90      *  @param index The index of the item to retrieve.
91      *  @return The address of the item at the given index.
92      */
93     function at(Data storage self, int256 index)
94     internal
95     view
96     returns (address) {
97         require(index >= 0 && index < self.count, "Index outside of bounds.");
98         return self.items[index + 1];
99     }
100 
101     /**
102      *  Gets the index of the given address.
103      *  @param addr The address of the item to get the index for.
104      *  @return The index of the given address.
105      */
106     function indexOf(Data storage self, address addr)
107     internal
108     view
109     returns (int256) {
110         if (addr == ZERO_ADDRESS) {
111             return -1;
112         }
113 
114         int256 index = self.indices[addr] - 1;
115         if (index < 0 || index >= self.count) {
116             return -1;
117         }
118         return index;
119     }
120 
121     /**
122      *  Returns whether or not the given address exists within the map.
123      *  @param addr The address to check for existence.
124      *  @return If the given address exists or not.
125      */
126     function exists(Data storage self, address addr)
127     internal
128     view
129     returns (bool) {
130         int256 index = self.indices[addr] - 1;
131         return index >= 0 && index < self.count;
132     }
133 
134     /**
135      * Clears all items within the map.
136      */
137     function clear(Data storage self)
138     internal {
139         self.count = 0;
140     }
141 
142 }
143 
144 /**
145  *
146  *  @title AccountMap
147  *  @dev Map of unique indexed accounts.
148  *
149  *  **NOTE**
150  *    The internal collections are one-based.
151  *    This is simply because null values are expressed as zero,
152  *    which makes it hard to check for the existence of items within the array,
153  *    or grabbing the first item of an array for non-existent items.
154  *
155  *    This is only exposed internally, so callers still use zero-based indices.
156  *
157  */
158 library AccountMap {
159     address constant ZERO_ADDRESS = address(0);
160 
161     struct Account {
162         address addr;
163         uint8 kind;
164         bool frozen;
165         address parent;
166     }
167 
168     struct Data {
169         int256 count;
170         mapping(address => int256) indices;
171         mapping(int256 => Account) items;
172     }
173 
174     /**
175      *  Appends the address to the end of the map, if the addres is not
176      *  zero and the address doesn't currently exist.
177      *  @param addr The address to append.
178      *  @return true if the address was added.
179      */
180     function append(Data storage self, address addr, uint8 kind, bool isFrozen, address parent)
181     internal
182     returns (bool) {
183         if (addr == ZERO_ADDRESS) {
184             return false;
185         }
186 
187         int256 index = self.indices[addr] - 1;
188         if (index >= 0 && index < self.count) {
189             return false;
190         }
191 
192         self.count++;
193         self.indices[addr] = self.count;
194         self.items[self.count] = Account(addr, kind, isFrozen, parent);
195         return true;
196     }
197 
198     /**
199      *  Removes the given address from the map.
200      *  @param addr The address to remove from the map.
201      *  @return true if the address was removed.
202      */
203     function remove(Data storage self, address addr)
204     internal
205     returns (bool) {
206         int256 oneBasedIndex = self.indices[addr];
207         if (oneBasedIndex < 1 || oneBasedIndex > self.count) {
208             return false;  // address doesn't exist, or zero.
209         }
210 
211         // When the item being removed is not the last item in the collection,
212         // replace that item with the last one, otherwise zero it out.
213         //
214         //  If {2} is the item to be removed
215         //     [0, 1, 2, 3, 4]
216         //  The result would be:
217         //     [0, 1, 4, 3]
218         //
219         if (oneBasedIndex < self.count) {
220             // Replace with last item
221             Account storage last = self.items[self.count];  // Get the last item
222             self.indices[last.addr] = oneBasedIndex;        // Update last items index to current index
223             self.items[oneBasedIndex] = last;               // Update current index to last item
224             delete self.items[self.count];                  // Delete the last item, since it's moved
225         } else {
226             // Delete the account
227             delete self.items[oneBasedIndex];
228         }
229 
230         delete self.indices[addr];
231         self.count--;
232         return true;
233     }
234 
235     /**
236      *  Retrieves the address at the given index.
237      *  THROWS when the index is invalid.
238      *  @param index The index of the item to retrieve.
239      *  @return The address of the item at the given index.
240      */
241     function at(Data storage self, int256 index)
242     internal
243     view
244     returns (Account) {
245         require(index >= 0 && index < self.count, "Index outside of bounds.");
246         return self.items[index + 1];
247     }
248 
249     /**
250      *  Gets the index of the given address.
251      *  @param addr The address of the item to get the index for.
252      *  @return The index of the given address.
253      */
254     function indexOf(Data storage self, address addr)
255     internal
256     view
257     returns (int256) {
258         if (addr == ZERO_ADDRESS) {
259             return -1;
260         }
261 
262         int256 index = self.indices[addr] - 1;
263         if (index < 0 || index >= self.count) {
264             return -1;
265         }
266         return index;
267     }
268 
269     /**
270      *  Gets the Account for the given address.
271      *  THROWS when an account doesn't exist for the given address.
272      *  @param addr The address of the item to get.
273      *  @return The account of the given address.
274      */
275     function get(Data storage self, address addr)
276     internal
277     view
278     returns (Account) {
279         return at(self, indexOf(self, addr));
280     }
281 
282     /**
283      *  Returns whether or not the given address exists within the map.
284      *  @param addr The address to check for existence.
285      *  @return If the given address exists or not.
286      */
287     function exists(Data storage self, address addr)
288     internal
289     view
290     returns (bool) {
291         int256 index = self.indices[addr] - 1;
292         return index >= 0 && index < self.count;
293     }
294 
295     /**
296      * Clears all items within the map.
297      */
298     function clear(Data storage self)
299     internal {
300         self.count = 0;
301     }
302 
303 }
304 
305 /**
306  *  @title Ownable
307  *  @dev Provides a modifier that requires the caller to be the owner of the contract.
308  */
309 contract Ownable {
310     address public owner;
311 
312     event OwnerTransferred(
313         address indexed oldOwner,
314         address indexed newOwner
315     );
316 
317     constructor() public {
318         owner = msg.sender;
319     }
320 
321     modifier onlyOwner() {
322         require(msg.sender == owner, "Owner account is required");
323         _;
324     }
325 
326     /**
327      * @dev Allows the current owner to transfer control of the contract to newOwner.
328      * @param newOwner The address to transfer ownership to.
329      */
330     function transferOwner(address newOwner)
331     public
332     onlyOwner {
333         require(newOwner != owner, "New Owner cannot be the current owner");
334         require(newOwner != address(0), "New Owner cannot be zero address");
335         address prevOwner = owner;
336         owner = newOwner;
337         emit OwnerTransferred(prevOwner, newOwner);
338     }
339 }
340 
341 /**
342  *  @title Lockable
343  *  @dev The Lockable contract adds the ability for the contract owner to set the lock status
344  *  of the account. A modifier is provided that checks the throws when the contract is
345  *  in the locked state.
346  */
347 contract Lockable is Ownable {
348     bool public isLocked;
349 
350     constructor() public {
351         isLocked = false;
352     }
353 
354     modifier isUnlocked() {
355         require(!isLocked, "Contract is currently locked for modification");
356         _;
357     }
358 
359     /**
360      *  Set the contract to a read-only state.
361      *  @param locked The locked state to set the contract to.
362      */
363     function setLocked(bool locked)
364     onlyOwner
365     external {
366         require(isLocked != locked, "Contract already in requested lock state");
367 
368         isLocked = locked;
369     }
370 }
371 
372 /**
373  *  @title Destroyable
374  *  @dev The Destroyable contract alows the owner address to `selfdestruct` the contract.
375  */
376 contract Destroyable is Ownable {
377     /**
378      *  Allow the owner to destroy this contract.
379      */
380     function kill()
381     onlyOwner
382     external {
383         selfdestruct(owner);
384     }
385 }
386 
387 /**
388  *  Contract to facilitate locking and self destructing.
389  */
390 contract LockableDestroyable is Lockable, Destroyable { }
391 
392 /**
393  *  @title Registry Storage
394  */
395 contract Storage is Ownable, LockableDestroyable {
396     struct Mapping {
397         address key;
398         address value;
399     }
400 
401     using AccountMap for AccountMap.Data;
402     using AddressMap for AddressMap.Data;
403 
404     // ------------------------------- Variables -------------------------------
405     // Nmber of data slots available for accounts
406     uint8 MAX_DATA = 30;
407 
408     // Accounts
409     AccountMap.Data public accounts;
410 
411     // Account Data
412     //   - mapping of:
413     //     (address        => (index =>    data))
414     mapping(address => mapping(uint8 => bytes32)) public data;
415 
416     // Address write permissions
417     //     (kind  => address)
418     mapping(uint8 => AddressMap.Data) public permissions;
419 
420 
421     // ------------------------------- Modifiers -------------------------------
422     /**
423      *  Ensures the `msg.sender` has permission for the given kind/type of account.
424      *  
425      *    - The `owner` account is always allowed
426      *    - Addresses/Contracts must have a corresponding entry, for the given kind
427      */
428     modifier isAllowed(uint8 kind) {
429         require(kind > 0, "Invalid, or missing permission");
430         if (msg.sender != owner) {
431             require(permissions[kind].exists(msg.sender), "Missing permission");
432         }
433         _;
434     }
435 
436 
437     // ---------------------------- Address Getters ----------------------------
438     /**
439      *  Gets the account at the given index
440      *  THROWS when the index is out-of-bounds
441      *  @param index The index of the item to retrieve
442      *  @return The address, kind, frozen status, and parent of the account at the given index
443      */
444     function accountAt(int256 index)
445     external
446     view
447     returns(address, uint8, bool, address) {
448         AccountMap.Account memory acct = accounts.at(index);
449         return (acct.addr, acct.kind, acct.frozen, acct.parent);
450     }
451 
452     /**
453      *  Gets the account for the given address
454      *  THROWS when the account doesn't exist
455      *  @param addr The address of the item to retrieve
456      *  @return The address, kind, frozen status, and parent of the account at the given index
457      */
458     function accountGet(address addr)
459     external
460     view
461     returns(uint8, bool, address) {
462         AccountMap.Account memory acct = accounts.get(addr);
463         return (acct.kind, acct.frozen, acct.parent);
464     }
465 
466     /**
467      *  Gets the parent address for the given account address
468      *  THROWS when the account doesn't exist
469      *  @param addr The address of the account
470      *  @return The parent address
471      */
472     function accountParent(address addr)
473     external
474     view
475     returns(address) {
476         return accounts.get(addr).parent;
477     }
478 
479     /**
480      *  Gets the account kind, for the given account address
481      *  THROWS when the account doesn't exist
482      *  @param addr The address of the account
483      *  @return The kind of account
484      */
485     function accountKind(address addr)
486     external
487     view
488     returns(uint8) {
489         return accounts.get(addr).kind;
490     }
491 
492     /**
493      *  Gets the frozen status of the account
494      *  THROWS when the account doesn't exist
495      *  @param addr The address of the account
496      *  @return The frozen status of the account
497      */
498     function accountFrozen(address addr)
499     external
500     view
501     returns(bool) {
502         return accounts.get(addr).frozen;
503     }
504 
505     /**
506      *  Gets the index of the account
507      *  Returns -1 for missing accounts
508      *  @param addr The address of the account to get the index for
509      *  @return The index of the given account address
510      */
511     function accountIndexOf(address addr)
512     external
513     view
514     returns(int256) {
515         return accounts.indexOf(addr);
516     }
517 
518     /**
519      *  Returns wether or not the given address exists
520      *  @param addr The account address
521      *  @return If the given address exists
522      */
523     function accountExists(address addr)
524     external
525     view
526     returns(bool) {
527         return accounts.exists(addr);
528     }
529 
530     /**
531      *  Returns wether or not the given address exists for the given kind
532      *  @param addr The account address
533      *  @param kind The kind of address
534      *  @return If the given address exists with the given kind
535      */
536     function accountExists(address addr, uint8 kind)
537     external
538     view
539     returns(bool) {
540         int256 index = accounts.indexOf(addr);
541         if (index < 0) {
542             return false;
543         }
544         return accounts.at(index).kind == kind;
545     }
546 
547 
548     // -------------------------- Permission Getters ---------------------------
549     /**
550      *  Retrieves the permission address at the index for the given type
551      *  THROWS when the index is out-of-bounds
552      *  @param kind The kind of permission
553      *  @param index The index of the item to retrieve
554      *  @return The permission address of the item at the given index
555      */
556     function permissionAt(uint8 kind, int256 index)
557     external
558     view
559     returns(address) {
560         return permissions[kind].at(index);
561     }
562 
563     /**
564      *  Gets the index of the permission address for the given type
565      *  Returns -1 for missing permission
566      *  @param kind The kind of perission
567      *  @param addr The address of the permission to get the index for
568      *  @return The index of the given permission address
569      */
570     function permissionIndexOf(uint8 kind, address addr)
571     external
572     view
573     returns(int256) {
574         return permissions[kind].indexOf(addr);
575     }
576 
577     /**
578      *  Returns wether or not the given permission address exists for the given type
579      *  @param kind The kind of permission
580      *  @param addr The address to check for permission
581      *  @return If the given address has permission or not
582      */
583     function permissionExists(uint8 kind, address addr)
584     external
585     view
586     returns(bool) {
587         return permissions[kind].exists(addr);
588     }
589 
590     // -------------------------------------------------------------------------
591 
592     /**
593      *  Adds an account to storage
594      *  THROWS when `msg.sender` doesn't have permission
595      *  THROWS when the account already exists
596      *  @param addr The address of the account
597      *  @param kind The kind of account
598      *  @param isFrozen The frozen status of the account
599      *  @param parent The account parent/owner
600      */
601     function addAccount(address addr, uint8 kind, bool isFrozen, address parent)
602     isUnlocked
603     isAllowed(kind)
604     external {
605         require(accounts.append(addr, kind, isFrozen, parent), "Account already exists");
606     }
607 
608     /**
609      *  Sets an account's frozen status
610      *  THROWS when the account doesn't exist
611      *  @param addr The address of the account
612      *  @param frozen The frozen status of the account
613      */
614     function setAccountFrozen(address addr, bool frozen)
615     isUnlocked
616     isAllowed(accounts.get(addr).kind)
617     external {
618         // NOTE: Not bounds checking `index` here, as `isAllowed` ensures the address exists.
619         //       Indices are one-based internally, so we need to add one to compensate.
620         int256 index = accounts.indexOf(addr) + 1;
621         accounts.items[index].frozen = frozen;
622     }
623 
624     /**
625      *  Removes an account from storage
626      *  THROWS when the account doesn't exist
627      *  @param addr The address of the account
628      */
629     function removeAccount(address addr)
630     isUnlocked
631     isAllowed(accounts.get(addr).kind)
632     external {
633         bytes32 ZERO_BYTES = bytes32(0);
634         mapping(uint8 => bytes32) accountData = data[addr];
635 
636         // Remove data
637         for (uint8 i = 0; i < MAX_DATA; i++) {
638             if (accountData[i] != ZERO_BYTES) {
639                 delete accountData[i];
640             }
641         }
642 
643         // Remove account
644         accounts.remove(addr);
645     }
646 
647     /**
648      *  Sets data for an address/caller
649      *  THROWS when the account doesn't exist
650      *  @param addr The address
651      *  @param index The index of the data
652      *  @param customData The data store set
653      */
654     function setAccountData(address addr, uint8 index, bytes32 customData)
655     isUnlocked
656     isAllowed(accounts.get(addr).kind)
657     external {
658         require(index < MAX_DATA, "index outside of bounds");
659         data[addr][index] = customData;
660     }
661 
662     /**
663      *  Grants the address permission for the given kind
664      *  @param kind The kind of address
665      *  @param addr The address
666      */
667     function grantPermission(uint8 kind, address addr)
668     isUnlocked
669     isAllowed(kind)
670     external {
671         permissions[kind].append(addr);
672     }
673 
674     /**
675      *  Revokes the address permission for the given kind
676      *  @param kind The kind of address
677      *  @param addr The address
678      */
679     function revokePermission(uint8 kind, address addr)
680     isUnlocked
681     isAllowed(kind)
682     external {
683         permissions[kind].remove(addr);
684     }
685 
686 }
687 
688 interface ERC20 {
689     event Approval(address indexed owner, address indexed spender, uint256 value);
690     event Transfer(address indexed from, address indexed to, uint256 value);
691 
692     function allowance(address owner, address spender) external view returns (uint256);
693     function approve(address spender, uint256 value) external returns (bool);
694     function balanceOf(address who) external view returns (uint256);
695     function totalSupply() external view returns (uint256);
696     function transfer(address to, uint256 value) external returns (bool);
697     function transferFrom(address from, address to, uint256 value) external returns (bool);
698 }
699 
700 library AdditiveMath {
701     /**
702      *  Adds two numbers and returns the result
703      *  THROWS when the result overflows
704      *  @return The sum of the arguments
705      */
706     function add(uint256 x, uint256 y)
707     internal
708     pure
709     returns (uint256) {
710         uint256 sum = x + y;
711         require(sum >= x, "Results in overflow");
712         return sum;
713     }
714 
715     /**
716      *  Subtracts two numbers and returns the result
717      *  THROWS when the result underflows
718      *  @return The difference of the arguments
719      */
720     function subtract(uint256 x, uint256 y)
721     internal
722     pure
723     returns (uint256) {
724         require(y <= x, "Results in underflow");
725         return x - y;
726     }
727 }
728 
729 interface ComplianceRule {
730 
731     /**
732      * @param from The address of the sender
733      * @param to The address of the receiver
734      * @param toKind The kind of the to address
735      * @param store The Storage contract
736      * @return true if transfer is allowed
737      */
738     function canTransfer(address from, address to, uint8 toKind, Storage store)
739     external
740     view
741     returns(bool);
742 }
743 
744 interface Compliance {
745 
746     /**
747      * This event is emitted when an address's frozen status has changed.
748      * @param addr The address whose frozen status has been updated.
749      * @param isFrozen Whether the custodian is being frozen.
750      * @param owner The address that updated the frozen status.
751      */
752     event AddressFrozen(
753         address indexed addr,
754         bool indexed isFrozen,
755         address indexed owner
756     );
757 
758     /**
759      *  Sets an address frozen status for this token
760      *  @param addr The address to update frozen status.
761      *  @param freeze Frozen status of the address.
762      */
763     function setAddressFrozen(address addr, bool freeze)
764     external;
765 
766     /**
767      *  Returns all of the current compliance rules for this token
768      *  @param kind The bucket of rules to get.
769      *  @return List of all compliance rules.
770      */
771     function getRules(uint8 kind)
772     view
773     external
774     returns(ComplianceRule[]);
775 
776     /**
777      *  Replaces all of the existing rules with the given ones
778      *  @param kind The bucket of rules to set.
779      *  @param rules New compliance rules.
780      */
781     function setRules(uint8 kind, ComplianceRule[] rules)
782     external;
783 
784     /**
785      *  Checks if a transfer can occur between the from/to addresses.
786      *  Both addressses must be valid, unfrozen, and pass all compliance rule checks.
787      *  @param from The address of the sender.
788      *  @param to The address of the receiver.
789      *  @return If a transfer can occure between the from/to addresses.
790      */
791     function canTransfer(address from, address to)
792     view
793     external
794     returns(bool);
795 
796 }
797 
798 contract T0ken is ERC20, Ownable, LockableDestroyable {
799     // ------------------------------- Variables -------------------------------
800     using AdditiveMath for uint256;
801 
802     using AddressMap for AddressMap.Data;
803     AddressMap.Data public shareholders;
804 
805     mapping(address => address) public cancellations;
806     mapping(address => uint256) internal balances;
807     mapping (address => mapping (address => uint256)) private allowed;
808 
809     address public issuer;
810     bool public issuingFinished = false;
811     uint256 internal totalSupplyTokens;
812     address constant internal ZERO_ADDRESS = address(0);
813     Compliance public compliance;
814     Storage public store;
815 
816     // Possible 3rd party integration variables
817     string public constant name = "TZERO PREFERRED";
818     string public constant symbol = "TZROP";
819     uint8 public constant decimals = 0;
820 
821     // ------------------------------- Modifiers -------------------------------
822     modifier transferCheck(uint256 value, address fromAddr) {
823         require(value <= balances[fromAddr], "Balance is more than from address has");
824         _;
825     }
826 
827     modifier isNotCancelled(address addr) {
828         require(cancellations[addr] == ZERO_ADDRESS, "Address has been cancelled");
829         _;
830     }
831 
832     modifier onlyIssuer() {
833         require(msg.sender == issuer, "Only issuer allowed");
834         _;
835     }
836 
837     modifier canIssue() {
838         require(!issuingFinished, "Issuing is already finished");
839         _;
840     }
841 
842     modifier canTransfer(address fromAddress, address toAddress) {
843         if(fromAddress == issuer) {
844             require(store.accountExists(toAddress), "The to address does not exist");
845         }
846         else {
847             require(compliance.canTransfer(fromAddress, toAddress), "Address cannot transfer");
848         }
849         _;
850     }
851 
852     modifier canTransferFrom(address fromAddress, address toAddress) {
853         if(msg.sender == owner) {
854             require(store.accountExists(toAddress), "The to address does not exist");
855         }
856         else {
857             require(compliance.canTransfer(fromAddress, toAddress), "Address cannot transfer");
858         }
859         _;
860     }
861 
862     // -------------------------- Events -------------------------------
863 
864     /**
865      *  This event is emitted when an address is cancelled and replaced with
866      *  a new address.  This happens in the case where a shareholder has
867      *  lost access to their original address and needs to have their share
868      *  reissued to a new address.  This is the equivalent of issuing replacement
869      *  share certificates.
870      *  @param original The address being superseded.
871      *  @param replacement The new address.
872      *  @param sender The address that caused the address to be superseded.
873     */
874     event VerifiedAddressSuperseded(address indexed original, address indexed replacement, address indexed sender);
875     event IssuerSet(address indexed previousIssuer, address indexed newIssuer);
876     event Issue(address indexed to, uint256 amount);
877     event IssueFinished();
878 
879 
880     // ---------------------------- Getters ----------------------------
881 
882     /**
883     * @return total number of tokens in existence
884     */
885     function totalSupply()
886     external
887     view
888     returns (uint256) {
889         return totalSupplyTokens;
890     }
891 
892     /**
893     * @dev Gets the balance of the specified address.
894     * @param addr The address to query the the balance of.
895     * @return An uint256 representing the amount owned by the passed address.
896     */
897     function balanceOf(address addr)
898     external
899     view
900     returns (uint256) {
901         return balances[addr];
902     }
903 
904     /**
905      * @dev Function to check the amount of tokens that an owner allowed to a spender.
906      * @param addrOwner address The address which owns the funds.
907      * @param spender address The address which will spend the funds.
908      * @return A uint256 specifying the amount of tokens still available for the spender.
909      */
910     function allowance(address addrOwner, address spender)
911     isUnlocked
912     external
913     view
914     returns (uint256) {
915         return allowed[addrOwner][spender];
916     }
917 
918     /**
919      *  By counting the number of token holders using `holderCount`
920      *  you can retrieve the complete list of token holders, one at a time.
921      *  It MUST throw if `index >= holderCount()`.
922      *  @param index The zero-based index of the holder.
923      *  @return the address of the token holder with the given index.
924      */
925     function holderAt(int256 index)
926     external
927     view
928     returns (address){
929         return shareholders.at(index);
930     }
931 
932     /**
933      *  Checks to see if the supplied address is a share holder.
934      *  @param addr The address to check.
935      *  @return true if the supplied address owns a token.
936      */
937     function isHolder(address addr)
938     external
939     view
940     returns (bool) {
941         return shareholders.exists(addr);
942     }
943 
944     /**
945      *  Checks to see if the supplied address was superseded.
946      *  @param addr The address to check.
947      *  @return true if the supplied address was superseded by another address.
948      */
949     function isSuperseded(address addr)
950     onlyOwner
951     external
952     view
953     returns (bool) {
954         return cancellations[addr] != ZERO_ADDRESS;
955     }
956 
957     /**
958      *  Gets the most recent address, given a superseded one.
959      *  Addresses may be superseded multiple times, so this function needs to
960      *  follow the chain of addresses until it reaches the final, verified address.
961      *  @param addr The superseded address.
962      *  @return the verified address that ultimately holds the share.
963      */
964     function getSuperseded(address addr)
965     onlyOwner
966     public
967     view
968     returns (address) {
969         require(addr != ZERO_ADDRESS, "Non-zero address required");
970         address candidate = cancellations[addr];
971         if (candidate == ZERO_ADDRESS) {
972             return ZERO_ADDRESS;
973         }
974         return candidate;
975     }
976 
977     // -----------------------------------------------------------------
978 
979     function setCompliance(address newComplianceAddress)
980     isUnlocked
981     onlyOwner
982     external {
983         compliance = Compliance(newComplianceAddress);
984     }
985 
986     function setStorage(Storage s)
987     isUnlocked
988     onlyOwner
989     external {
990         store = s;
991     }
992 
993     /**
994     * @dev transfer token for a specified address
995     * @param to The address to transfer to.
996     * @param value The amount to be transferred.
997     *  The `transfer` function MUST NOT allow transfers to addresses that
998     *  have not been verified and added to the contract.
999     *  If the `to` address is not currently a shareholder then it MUST become one.
1000     *  If the transfer will reduce `msg.sender`'s balance to 0 then that address
1001     *  MUST be removed from the list of shareholders.
1002     */
1003     function transfer(address to, uint256 value)
1004     isUnlocked
1005     isNotCancelled(to)
1006     transferCheck(value, msg.sender)
1007     canTransfer(msg.sender, to)
1008     public
1009     returns (bool) {
1010         balances[msg.sender] = balances[msg.sender].subtract(value);
1011         balances[to] = balances[to].add(value);
1012 
1013         // Adds the shareholder, if they don't already exist.
1014         shareholders.append(to);
1015 
1016         // Remove the shareholder if they no longer hold tokens.
1017         if (balances[msg.sender] == 0) {
1018             shareholders.remove(msg.sender);
1019         }
1020 
1021         emit Transfer(msg.sender, to, value);
1022         return true;
1023     }
1024 
1025     /**
1026      * @dev Transfer tokens from one address to another
1027      * @param from address The address which you want to send tokens from
1028      * @param to address The address which you want to transfer to
1029      * @param value uint256 the amount of tokens to be transferred
1030      *  The `transferFrom` function MUST NOT allow transfers to addresses that
1031      *  have not been verified and added to the contract.
1032      *  If the `to` address is not currently a shareholder then it MUST become one.
1033      *  If the transfer will reduce `from`'s balance to 0 then that address
1034      *  MUST be removed from the list of shareholders.
1035      */
1036     function transferFrom(address from, address to, uint256 value)
1037     public
1038     transferCheck(value, from)
1039     isNotCancelled(to)
1040     canTransferFrom(from, to)
1041     isUnlocked
1042     returns (bool) {
1043         if(msg.sender != owner) {
1044             require(value <= allowed[from][msg.sender], "Value exceeds what is allowed to transfer");
1045             allowed[from][msg.sender] = allowed[from][msg.sender].subtract(value);
1046         }
1047 
1048         balances[from] = balances[from].subtract(value);
1049         balances[to] = balances[to].add(value);
1050 
1051         // Adds the shareholder, if they don't already exist.
1052         shareholders.append(to);
1053 
1054         // Remove the shareholder if they no longer hold tokens.
1055         if (balances[msg.sender] == 0) {
1056             shareholders.remove(from);
1057         }
1058 
1059         emit Transfer(from, to, value);
1060         return true;
1061     }
1062 
1063     /**
1064      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1065      *
1066      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1067      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1068      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1069      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1070      * @param spender The address which will spend the funds.
1071      * @param value The amount of tokens to be spent.
1072      */
1073     function approve(address spender, uint256 value)
1074     isUnlocked
1075     external
1076     returns (bool) {
1077         allowed[msg.sender][spender] = value;
1078         emit Approval(msg.sender, spender, value);
1079         return true;
1080     }
1081 
1082     function setIssuer(address newIssuer)
1083     isUnlocked
1084     onlyOwner
1085     external {
1086         issuer = newIssuer;
1087         emit IssuerSet(issuer, newIssuer);
1088     }
1089 
1090     /**
1091      * Tokens will be issued only to the issuer's address
1092      * @param quantity The amount of tokens to mint.
1093      * @return A boolean that indicates if the operation was successful.
1094      */
1095     function issueTokens(uint256 quantity)
1096     isUnlocked
1097     onlyIssuer
1098     canIssue
1099     public
1100     returns (bool) {
1101         address issuer = msg.sender;
1102         totalSupplyTokens = totalSupplyTokens.add(quantity);
1103         balances[issuer] = balances[issuer].add(quantity);
1104         shareholders.append(issuer);
1105         emit Issue(issuer, quantity);
1106         return true;
1107     }
1108 
1109     function finishIssuing()
1110     isUnlocked
1111     onlyIssuer
1112     canIssue
1113     public
1114     returns (bool) {
1115         issuingFinished = true;
1116         emit IssueFinished();
1117         return issuingFinished;
1118     }
1119 
1120     /**
1121      *  Cancel the original address and reissue the Tokens to the replacement address.
1122      *
1123      *  ***It's on the issuer to make sure the replacement address belongs to a verified investor.***
1124      *
1125      *  Access to this function MUST be strictly controlled.
1126      *  The `original` address MUST be removed from the set of verified addresses.
1127      *  Throw if the `original` address supplied is not a shareholder.
1128      *  Throw if the replacement address is not a verified address.
1129      *  This function MUST emit the `VerifiedAddressSuperseded` event.
1130      *  @param original The address to be superseded. This address MUST NOT be reused.
1131      *  @param replacement The address  that supersedes the original. This address MUST be verified.
1132      */
1133     function cancelAndReissue(address original, address replacement)
1134     isUnlocked
1135     onlyOwner
1136     isNotCancelled(replacement)
1137     external {
1138         // replace the original address in the shareholders mapping
1139         // and update all the associated mappings
1140         require(shareholders.exists(original) && !shareholders.exists(replacement), "Original doesn't exist or replacement does");
1141         shareholders.remove(original);
1142         shareholders.append(replacement);
1143         cancellations[original] = replacement;
1144         balances[replacement] = balances[original];
1145         balances[original] = 0;
1146         emit VerifiedAddressSuperseded(original, replacement, msg.sender);
1147     }
1148 
1149 }