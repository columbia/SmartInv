1 /**
2  * Licensed to the Apache Software Foundation (ASF) under one
3  * or more contributor license agreements.  See the NOTICE file
4  * distributed with this work for additional information
5  * regarding copyright ownership.  The ASF licenses this file
6  * to you under the Apache License, Version 2.0 (the
7  * "License"); you may not use this file except in compliance
8  * with the License.  You may obtain a copy of the License at
9  * 
10  *   http://www.apache.org/licenses/LICENSE-2.0
11  * 
12  * Unless required by applicable law or agreed to in writing,
13  * software distributed under the License is distributed on an
14  * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
15  * KIND, either express or implied.  See the License for the
16  * specific language governing permissions and limitations
17  * under the License.
18  */
19 
20 
21 pragma solidity ^0.5.2;
22 
23 
24 /**
25  *  @title Ownable
26  *  @dev Provides a modifier that requires the caller to be the owner of the contract.
27  */
28 contract Ownable {
29     address payable public owner;
30 
31     event OwnerTransferred(
32         address indexed oldOwner,
33         address indexed newOwner
34     );
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner, "Owner account is required");
42         _;
43     }
44 
45     /**
46      * @dev Allows the current owner to transfer control of the contract to newOwner.
47      * @param newOwner The address to transfer ownership to.
48      */
49     function transferOwner(address payable newOwner)
50     public
51     onlyOwner {
52         require(newOwner != owner, "New Owner cannot be the current owner");
53         require(newOwner != address(0), "New Owner cannot be zero address");
54         address payable prevOwner = owner;
55         owner = newOwner;
56         emit OwnerTransferred(prevOwner, newOwner);
57     }
58 }
59 
60 /**
61  *  @title Lockable
62  *  @dev The Lockable contract adds the ability for the contract owner to set the lock status
63  *  of the account. A modifier is provided that checks the throws when the contract is
64  *  in the locked state.
65  */
66 contract Lockable is Ownable {
67     bool public isLocked;
68 
69     constructor() public {
70         isLocked = false;
71     }
72 
73     modifier isUnlocked() {
74         require(!isLocked, "Contract is currently locked for modification");
75         _;
76     }
77 
78     /**
79      *  Set the contract to a read-only state.
80      *  @param locked The locked state to set the contract to.
81      */
82     function setLocked(bool locked)
83     onlyOwner
84     external {
85         require(isLocked != locked, "Contract already in requested lock state");
86 
87         isLocked = locked;
88     }
89 }
90 
91 /**
92  *  @title Destroyable
93  *  @dev The Destroyable contract alows the owner address to `selfdestruct` the contract.
94  */
95 contract Destroyable is Ownable {
96     /**
97      *  Allow the owner to destroy this contract.
98      */
99     function kill()
100     onlyOwner
101     external {
102         selfdestruct(owner);
103     }
104 }
105 
106 /**
107  *  Contract to facilitate locking and self destructing.
108  */
109 contract LockableDestroyable is Lockable, Destroyable { }
110 
111 library AdditiveMath {
112     /**
113      *  Adds two numbers and returns the result
114      *  THROWS when the result overflows
115      *  @return The sum of the arguments
116      */
117     function add(uint256 x, uint256 y)
118     internal
119     pure
120     returns (uint256) {
121         uint256 sum = x + y;
122         require(sum >= x, "Results in overflow");
123         return sum;
124     }
125 
126     /**
127      *  Subtracts two numbers and returns the result
128      *  THROWS when the result underflows
129      *  @return The difference of the arguments
130      */
131     function subtract(uint256 x, uint256 y)
132     internal
133     pure
134     returns (uint256) {
135         require(y <= x, "Results in underflow");
136         return x - y;
137     }
138 }
139 
140 /**
141  *
142  *  @title AddressMap
143  *  @dev Map of unique indexed addresseses.
144  *
145  *  **NOTE**
146  *    The internal collections are one-based.
147  *    This is simply because null values are expressed as zero,
148  *    which makes it hard to check for the existence of items within the array,
149  *    or grabbing the first item of an array for non-existent items.
150  *
151  *    This is only exposed internally, so callers still use zero-based indices.
152  *
153  */
154 library AddressMap {
155     struct Data {
156         int256 count;
157         mapping(address => int256) indices;
158         mapping(int256 => address) items;
159     }
160 
161     address constant ZERO_ADDRESS = address(0);
162 
163     /**
164      *  Appends the address to the end of the map, if the address is not
165      *  zero and the address doesn't currently exist.
166      *  @param addr The address to append.
167      *  @return true if the address was added.
168      */
169     function append(Data storage self, address addr)
170     internal
171     returns (bool) {
172         if (addr == ZERO_ADDRESS) {
173             return false;
174         }
175 
176         int256 index = self.indices[addr] - 1;
177         if (index >= 0 && index < self.count) {
178             return false;
179         }
180 
181         self.count++;
182         self.indices[addr] = self.count;
183         self.items[self.count] = addr;
184         return true;
185     }
186 
187     /**
188      *  Removes the given address from the map.
189      *  @param addr The address to remove from the map.
190      *  @return true if the address was removed.
191      */
192     function remove(Data storage self, address addr)
193     internal
194     returns (bool) {
195         int256 oneBasedIndex = self.indices[addr];
196         if (oneBasedIndex < 1 || oneBasedIndex > self.count) {
197             return false;  // address doesn't exist, or zero.
198         }
199 
200         // When the item being removed is not the last item in the collection,
201         // replace that item with the last one, otherwise zero it out.
202         //
203         //  If {2} is the item to be removed
204         //     [0, 1, 2, 3, 4]
205         //  The result would be:
206         //     [0, 1, 4, 3]
207         //
208         if (oneBasedIndex < self.count) {
209             // Replace with last item
210             address last = self.items[self.count];  // Get the last item
211             self.indices[last] = oneBasedIndex;     // Update last items index to current index
212             self.items[oneBasedIndex] = last;       // Update current index to last item
213             delete self.items[self.count];          // Delete the last item, since it's moved
214         } else {
215             // Delete the address
216             delete self.items[oneBasedIndex];
217         }
218 
219         delete self.indices[addr];
220         self.count--;
221         return true;
222     }
223 
224     /**
225      * Clears all items within the map.
226      */
227     function clear(Data storage self)
228     internal {
229         self.count = 0;
230     }
231 
232     /**
233      *  Retrieves the address at the given index.
234      *  THROWS when the index is invalid.
235      *  @param index The index of the item to retrieve.
236      *  @return The address of the item at the given index.
237      */
238     function at(Data storage self, int256 index)
239     internal
240     view
241     returns (address) {
242         require(index >= 0 && index < self.count, "Index outside of bounds.");
243         return self.items[index + 1];
244     }
245 
246     /**
247      *  Gets the index of the given address.
248      *  @param addr The address of the item to get the index for.
249      *  @return The index of the given address.
250      */
251     function indexOf(Data storage self, address addr)
252     internal
253     view
254     returns (int256) {
255         if (addr == ZERO_ADDRESS) {
256             return -1;
257         }
258 
259         int256 index = self.indices[addr] - 1;
260         if (index < 0 || index >= self.count) {
261             return -1;
262         }
263         return index;
264     }
265 
266     /**
267      *  Returns whether or not the given address exists within the map.
268      *  @param addr The address to check for existence.
269      *  @return If the given address exists or not.
270      */
271     function exists(Data storage self, address addr)
272     internal
273     view
274     returns (bool) {
275         int256 index = self.indices[addr] - 1;
276         return index >= 0 && index < self.count;
277     }
278 
279 }
280 
281 /**
282  *
283  *  @title AccountMap
284  *  @dev Map of unique indexed accounts.
285  *
286  *  **NOTE**
287  *    The internal collections are one-based.
288  *    This is simply because null values are expressed as zero,
289  *    which makes it hard to check for the existence of items within the array,
290  *    or grabbing the first item of an array for non-existent items.
291  *
292  *    This is only exposed internally, so callers still use zero-based indices.
293  *
294  */
295 library AccountMap {
296     struct Account {
297         address addr;
298         uint8 kind;
299         bool frozen;
300         address parent;
301     }
302 
303     struct Data {
304         int256 count;
305         mapping(address => int256) indices;
306         mapping(int256 => Account) items;
307     }
308 
309     address constant ZERO_ADDRESS = address(0);
310 
311     /**
312      *  Appends the address to the end of the map, if the addres is not
313      *  zero and the address doesn't currently exist.
314      *  @param addr The address to append.
315      *  @return true if the address was added.
316      */
317     function append(Data storage self, address addr, uint8 kind, bool isFrozen, address parent)
318     internal
319     returns (bool) {
320         if (addr == ZERO_ADDRESS) {
321             return false;
322         }
323 
324         int256 index = self.indices[addr] - 1;
325         if (index >= 0 && index < self.count) {
326             return false;
327         }
328 
329         self.count++;
330         self.indices[addr] = self.count;
331         self.items[self.count] = Account(addr, kind, isFrozen, parent);
332         return true;
333     }
334 
335     /**
336      *  Removes the given address from the map.
337      *  @param addr The address to remove from the map.
338      *  @return true if the address was removed.
339      */
340     function remove(Data storage self, address addr)
341     internal
342     returns (bool) {
343         int256 oneBasedIndex = self.indices[addr];
344         if (oneBasedIndex < 1 || oneBasedIndex > self.count) {
345             return false;  // address doesn't exist, or zero.
346         }
347 
348         // When the item being removed is not the last item in the collection,
349         // replace that item with the last one, otherwise zero it out.
350         //
351         //  If {2} is the item to be removed
352         //     [0, 1, 2, 3, 4]
353         //  The result would be:
354         //     [0, 1, 4, 3]
355         //
356         if (oneBasedIndex < self.count) {
357             // Replace with last item
358             Account storage last = self.items[self.count];  // Get the last item
359             self.indices[last.addr] = oneBasedIndex;        // Update last items index to current index
360             self.items[oneBasedIndex] = last;               // Update current index to last item
361             delete self.items[self.count];                  // Delete the last item, since it's moved
362         } else {
363             // Delete the account
364             delete self.items[oneBasedIndex];
365         }
366 
367         delete self.indices[addr];
368         self.count--;
369         return true;
370     }
371 
372     /**
373      * Clears all items within the map.
374      */
375     function clear(Data storage self)
376     internal {
377         self.count = 0;
378     }
379 
380     /**
381      *  Retrieves the address at the given index.
382      *  THROWS when the index is invalid.
383      *  @param index The index of the item to retrieve.
384      *  @return The address of the item at the given index.
385      */
386     function at(Data storage self, int256 index)
387     internal
388     view
389     returns (Account memory) {
390         require(index >= 0 && index < self.count, "Index outside of bounds.");
391         return self.items[index + 1];
392     }
393 
394     /**
395      *  Gets the index of the given address.
396      *  @param addr The address of the item to get the index for.
397      *  @return The index of the given address.
398      */
399     function indexOf(Data storage self, address addr)
400     internal
401     view
402     returns (int256) {
403         if (addr == ZERO_ADDRESS) {
404             return -1;
405         }
406 
407         int256 index = self.indices[addr] - 1;
408         if (index < 0 || index >= self.count) {
409             return -1;
410         }
411         return index;
412     }
413 
414     /**
415      *  Gets the Account for the given address.
416      *  THROWS when an account doesn't exist for the given address.
417      *  @param addr The address of the item to get.
418      *  @return The account of the given address.
419      */
420     function get(Data storage self, address addr)
421     internal
422     view
423     returns (Account memory) {
424         return at(self, indexOf(self, addr));
425     }
426 
427     /**
428      *  Returns whether or not the given address exists within the map.
429      *  @param addr The address to check for existence.
430      *  @return If the given address exists or not.
431      */
432     function exists(Data storage self, address addr)
433     internal
434     view
435     returns (bool) {
436         int256 index = self.indices[addr] - 1;
437         return index >= 0 && index < self.count;
438     }
439 
440 }
441 
442 /**
443  *  @title Registry Storage
444  */
445 contract Storage is Ownable, LockableDestroyable {
446   
447     using AccountMap for AccountMap.Data;
448     using AddressMap for AddressMap.Data;
449 
450     // ------------------------------- Variables -------------------------------
451     // Number of data slots available for accounts
452     uint8 constant MAX_DATA = 30;
453 
454     // Accounts
455     AccountMap.Data public accounts;
456 
457     // Account Data
458     //   - mapping of:
459     //     (address        => (index =>    data))
460     mapping(address => mapping(uint8 => bytes32)) public data;
461 
462     // Address write permissions
463     //     (kind  => address)
464     mapping(uint8 => AddressMap.Data) public permissions;
465 
466 
467     // ------------------------------- Modifiers -------------------------------
468     /**
469      *  Ensures the `msg.sender` has permission for the given kind/type of account.
470      *
471      *    - The `owner` account is always allowed
472      *    - Addresses/Contracts must have a corresponding entry, for the given kind
473      */
474     modifier isAllowed(uint8 kind) {
475         require(kind > 0, "Invalid, or missing permission");
476         if (msg.sender != owner) {
477             require(permissions[kind].exists(msg.sender), "Missing permission");
478         }
479         _;
480     }
481 
482     // -------------------------------------------------------------------------
483 
484     /**
485      *  Adds an account to storage
486      *  THROWS when `msg.sender` doesn't have permission
487      *  THROWS when the account already exists
488      *  @param addr The address of the account
489      *  @param kind The kind of account
490      *  @param isFrozen The frozen status of the account
491      *  @param parent The account parent/owner
492      */
493     function addAccount(address addr, uint8 kind, bool isFrozen, address parent)
494     isUnlocked
495     isAllowed(kind)
496     external {
497         require(accounts.append(addr, kind, isFrozen, parent), "Account already exists");
498     }
499 
500     /**
501      *  Sets an account's frozen status
502      *  THROWS when the account doesn't exist
503      *  @param addr The address of the account
504      *  @param frozen The frozen status of the account
505      */
506     function setAccountFrozen(address addr, bool frozen)
507     isUnlocked
508     isAllowed(accounts.get(addr).kind)
509     external {
510         // NOTE: Not bounds checking `index` here, as `isAllowed` ensures the address exists.
511         //       Indices are one-based internally, so we need to add one to compensate.
512         int256 index = accounts.indexOf(addr) + 1;
513         accounts.items[index].frozen = frozen;
514     }
515 
516     /**
517      *  Removes an account from storage
518      *  THROWS when the account doesn't exist
519      *  @param addr The address of the account
520      */
521     function removeAccount(address addr)
522     isUnlocked
523     isAllowed(accounts.get(addr).kind)
524     external {
525         bytes32 ZERO_BYTES = bytes32(0);
526         mapping(uint8 => bytes32) storage accountData = data[addr];
527 
528         // Remove data
529         for (uint8 i = 0; i < MAX_DATA; i++) {
530             if (accountData[i] != ZERO_BYTES) {
531                 delete accountData[i];
532             }
533         }
534 
535         // Remove account
536         accounts.remove(addr);
537     }
538 
539     /**
540      *  Sets data for an address/caller
541      *  THROWS when the account doesn't exist
542      *  @param addr The address
543      *  @param index The index of the data
544      *  @param customData The data store set
545      */
546     function setAccountData(address addr, uint8 index, bytes32 customData)
547     isUnlocked
548     isAllowed(accounts.get(addr).kind)
549     external {
550         require(index < MAX_DATA, "index outside of bounds");
551         data[addr][index] = customData;
552     }
553 
554     /**
555      *  Grants the address permission for the given kind
556      *  @param kind The kind of address
557      *  @param addr The address
558      */
559     function grantPermission(uint8 kind, address addr)
560     isUnlocked
561     isAllowed(kind)
562     external {
563         permissions[kind].append(addr);
564     }
565 
566     /**
567      *  Revokes the address permission for the given kind
568      *  @param kind The kind of address
569      *  @param addr The address
570      */
571     function revokePermission(uint8 kind, address addr)
572     isUnlocked
573     isAllowed(kind)
574     external {
575         permissions[kind].remove(addr);
576     }
577 
578     // ---------------------------- Address Getters ----------------------------
579     /**
580      *  Gets the account at the given index
581      *  THROWS when the index is out-of-bounds
582      *  @param index The index of the item to retrieve
583      *  @return The address, kind, frozen status, and parent of the account at the given index
584      */
585     function accountAt(int256 index)
586     external
587     view
588     returns(address, uint8, bool, address) {
589         AccountMap.Account memory acct = accounts.at(index);
590         return (acct.addr, acct.kind, acct.frozen, acct.parent);
591     }
592 
593     /**
594      *  Gets the account for the given address
595      *  THROWS when the account doesn't exist
596      *  @param addr The address of the item to retrieve
597      *  @return The address, kind, frozen status, and parent of the account at the given index
598      */
599     function accountGet(address addr)
600     external
601     view
602     returns(uint8, bool, address) {
603         AccountMap.Account memory acct = accounts.get(addr);
604         return (acct.kind, acct.frozen, acct.parent);
605     }
606 
607     /**
608      *  Gets the parent address for the given account address
609      *  THROWS when the account doesn't exist
610      *  @param addr The address of the account
611      *  @return The parent address
612      */
613     function accountParent(address addr)
614     external
615     view
616     returns(address) {
617         return accounts.get(addr).parent;
618     }
619 
620     /**
621      *  Gets the account kind, for the given account address
622      *  THROWS when the account doesn't exist
623      *  @param addr The address of the account
624      *  @return The kind of account
625      */
626     function accountKind(address addr)
627     external
628     view
629     returns(uint8) {
630         return accounts.get(addr).kind;
631     }
632 
633     /**
634      *  Gets the frozen status of the account
635      *  THROWS when the account doesn't exist
636      *  @param addr The address of the account
637      *  @return The frozen status of the account
638      */
639     function accountFrozen(address addr)
640     external
641     view
642     returns(bool) {
643         return accounts.get(addr).frozen;
644     }
645 
646     /**
647      *  Gets the index of the account
648      *  Returns -1 for missing accounts
649      *  @param addr The address of the account to get the index for
650      *  @return The index of the given account address
651      */
652     function accountIndexOf(address addr)
653     external
654     view
655     returns(int256) {
656         return accounts.indexOf(addr);
657     }
658 
659     /**
660      *  Returns wether or not the given address exists
661      *  @param addr The account address
662      *  @return If the given address exists
663      */
664     function accountExists(address addr)
665     external
666     view
667     returns(bool) {
668         return accounts.exists(addr);
669     }
670 
671     /**
672      *  Returns wether or not the given address exists for the given kind
673      *  @param addr The account address
674      *  @param kind The kind of address
675      *  @return If the given address exists with the given kind
676      */
677     function accountExists(address addr, uint8 kind)
678     external
679     view
680     returns(bool) {
681         int256 index = accounts.indexOf(addr);
682         if (index < 0) {
683             return false;
684         }
685         return accounts.at(index).kind == kind;
686     }
687 
688 
689     // -------------------------- Permission Getters ---------------------------
690     /**
691      *  Retrieves the permission address at the index for the given type
692      *  THROWS when the index is out-of-bounds
693      *  @param kind The kind of permission
694      *  @param index The index of the item to retrieve
695      *  @return The permission address of the item at the given index
696      */
697     function permissionAt(uint8 kind, int256 index)
698     external
699     view
700     returns(address) {
701         return permissions[kind].at(index);
702     }
703 
704     /**
705      *  Gets the index of the permission address for the given type
706      *  Returns -1 for missing permission
707      *  @param kind The kind of perission
708      *  @param addr The address of the permission to get the index for
709      *  @return The index of the given permission address
710      */
711     function permissionIndexOf(uint8 kind, address addr)
712     external
713     view
714     returns(int256) {
715         return permissions[kind].indexOf(addr);
716     }
717 
718     /**
719      *  Returns wether or not the given permission address exists for the given type
720      *  @param kind The kind of permission
721      *  @param addr The address to check for permission
722      *  @return If the given address has permission or not
723      */
724     function permissionExists(uint8 kind, address addr)
725     external
726     view
727     returns(bool) {
728         return permissions[kind].exists(addr);
729     }
730 
731 }
732 
733 
734 interface ComplianceRule {
735 
736     /**
737      *  @dev Checks if a transfer can occur between the from/to addresses and MUST throw when the check fails.
738      *  @param initiator The address initiating the transfer.
739      *  @param from The address of the sender
740      *  @param to The address of the receiver
741      *  @param toKind The kind of the to address
742      *  @param tokens The number of tokens being transferred.
743      *  @param store The Storage contract
744      */
745     function check(address initiator, address from, address to, uint8 toKind, uint256 tokens, Storage store)
746     external;
747 }
748 
749 interface Compliance {
750 
751     /**
752      *  This event is emitted when an address's frozen status has changed.
753      *  @param addr The address whose frozen status has been updated.
754      *  @param isFrozen Whether the custodian is being frozen.
755      *  @param owner The address that updated the frozen status.
756      */
757     event AddressFrozen(
758         address indexed addr,
759         bool indexed isFrozen,
760         address indexed owner
761     );
762 
763     /**
764      *  Sets an address frozen status for this token
765      *  @param addr The address to update frozen status.
766      *  @param freeze Frozen status of the address.
767      */
768     function setFrozen(address addr, bool freeze)
769     external;
770 
771     /**
772      *  Replaces all of the existing rules with the given ones
773      *  @param kind The bucket of rules to set.
774      *  @param rules New compliance rules.
775      */
776     function setRules(uint8 kind, ComplianceRule[] calldata rules)
777     external;
778 
779     /**
780      *  Returns all of the current compliance rules for this token
781      *  @param kind The bucket of rules to get.
782      *  @return List of all compliance rules.
783      */
784     function getRules(uint8 kind)
785     external
786     view
787     returns (ComplianceRule[] memory);
788 
789     /**
790      *  @dev Checks if issuance can occur between the from/to addresses.
791      *
792      *  Both addresses must be whitelisted and unfrozen
793      *  THROWS when the transfer should fail.
794      *  @param issuer The address initiating the issuance.
795      *  @param from The address of the sender.
796      *  @param to The address of the receiver.
797      *  @param tokens The number of tokens being transferred.
798      *  @return If a issuance can occur between the from/to addresses.
799      */
800     function canIssue(address issuer, address from, address to, uint256 tokens)
801     external
802     returns (bool);
803 
804     /**
805      *  @dev Checks if a transfer can occur between the from/to addresses.
806      *
807      *  Both addresses must be whitelisted, unfrozen, and pass all compliance rule checks.
808      *  THROWS when the transfer should fail.
809      *  @param initiator The address initiating the transfer.
810      *  @param from The address of the sender.
811      *  @param to The address of the receiver.
812      *  @param tokens The number of tokens being transferred.
813      *  @return If a transfer can occur between the from/to addresses.
814      */
815     function canTransfer(address initiator, address from, address to, uint256 tokens)
816     external
817     returns (bool);
818 
819     /**
820      *  @dev Checks if an override by the sender can occur between the from/to addresses.
821      *
822      *  Both addresses must be whitelisted and unfrozen.
823      *  THROWS when the sender is not allowed to override.
824      *  @param admin The address initiating the transfer.
825      *  @param from The address of the sender.
826      *  @param to The address of the receiver.
827      *  @param tokens The number of tokens being transferred.
828      *  @return If an override can occur between the from/to addresses.
829      */
830     function canOverride(address admin, address from, address to, uint256 tokens)
831     external
832     returns (bool);
833 }
834 
835 
836 interface ERC20 {
837     event Approval(address indexed owner, address indexed spender, uint256 value);
838     event Transfer(address indexed from, address indexed to, uint256 value);
839 
840     function allowance(address owner, address spender) external view returns (uint256);
841     function approve(address spender, uint256 value) external returns (bool);
842     function balanceOf(address who) external view returns (uint256);
843     function totalSupply() external view returns (uint256);
844     function transfer(address to, uint256 value) external returns (bool);
845     function transferFrom(address from, address to, uint256 value) external returns (bool);
846 }
847 
848 contract T0ken is ERC20, Ownable, LockableDestroyable {
849 
850     // ------------------------------- Variables -------------------------------
851 
852     using AdditiveMath for uint256;
853     using AddressMap for AddressMap.Data;
854 
855     address constant internal ZERO_ADDRESS = address(0);
856     string public constant name = "TZERO PREFERRED";
857     string public constant symbol = "TZROP";
858     uint8 public constant decimals = 0;
859 
860     AddressMap.Data public shareholders;
861     Compliance public compliance;
862     address public issuer;
863     bool public issuingFinished = false;
864     mapping(address => address) public cancellations;
865 
866     mapping(address => uint256) internal balances;
867     uint256 internal totalSupplyTokens;
868 
869     mapping (address => mapping (address => uint256)) private allowed;
870 
871     // ------------------------------- Modifiers -------------------------------
872 
873     modifier onlyIssuer() {
874         require(msg.sender == issuer, "Only issuer allowed");
875         _;
876     }
877 
878     modifier canIssue() {
879         require(!issuingFinished, "Issuing is already finished");
880         _;
881     }
882 
883     modifier isNotCancelled(address addr) {
884         require(cancellations[addr] == ZERO_ADDRESS, "Address has been cancelled");
885         _;
886     }
887 
888     modifier hasFunds(address addr, uint256 tokens) {
889         require(tokens <= balances[addr], "Insufficient funds");
890         _;
891     }
892 
893     // -------------------------------- Events ---------------------------------
894 
895     /**
896      *  This event is emitted when an address is cancelled and replaced with
897      *  a new address.  This happens in the case where a shareholder has
898      *  lost access to their original address and needs to have their share
899      *  reissued to a new address.  This is the equivalent of issuing replacement
900      *  share certificates.
901      *  @param original The address being superseded.
902      *  @param replacement The new address.
903      *  @param sender The address that caused the address to be superseded.
904     */
905     event VerifiedAddressSuperseded(address indexed original, address indexed replacement, address indexed sender);
906     event IssuerSet(address indexed previousIssuer, address indexed newIssuer);
907     event Issue(address indexed to, uint256 tokens);
908     event IssueFinished();
909     event ShareholderAdded(address shareholder);
910     event ShareholderRemoved(address shareholder);
911 
912     // -------------------------------------------------------------------------
913 
914     /**
915      *  @dev Transfers tokens to the whitelisted account.
916      *
917      *  If the 'to' address is not currently a shareholder then it MUST become one.
918      *  If the transfer will reduce 'msg.sender' balance to 0, then that address MUST be removed
919      *  from the list of shareholders.
920      *  MUST be removed from the list of shareholders.
921      *  @param to The address to transfer to.
922      *  @param tokens The number of tokens to be transferred.
923      */
924     function transfer(address to, uint256 tokens)
925     external
926     isUnlocked
927     isNotCancelled(to)
928     hasFunds(msg.sender, tokens)
929     returns (bool) {
930         bool transferAllowed;
931 
932         // Issuance
933         if (msg.sender == issuer) {
934             transferAllowed = address(compliance) == ZERO_ADDRESS;
935             if (!transferAllowed) {
936                 transferAllowed = compliance.canIssue(issuer, issuer, to, tokens);
937             }
938         }
939         // Transfer
940         else {
941             transferAllowed = canTransfer(msg.sender, to, tokens, false);
942         }
943 
944         // Ensure the transfer is allowed.
945         if (transferAllowed) {
946             transferTokens(msg.sender, to, tokens);
947         }
948         return transferAllowed;
949     }
950 
951     /**
952      *  @dev Transfers tokens between whitelisted accounts.
953      *
954      *  If the 'to' address is not currently a shareholder then it MUST become one.
955      *  If the transfer will reduce 'from' balance to 0 then that address MUST be removed from the list of shareholders.
956      *  @param from The address to transfer from
957      *  @param to The address to transfer to.
958      *  @param tokens uint256 the number of tokens to be transferred
959      */
960     function transferFrom(address from, address to, uint256 tokens)
961     external
962     isUnlocked
963     isNotCancelled(to)
964     hasFunds(from, tokens)
965     returns (bool) {
966         require(tokens <= allowed[from][msg.sender], "Transfer exceeds allowance");
967 
968         // Transfer the tokens
969         bool transferAllowed = canTransfer(from, to, tokens, false);
970         if (transferAllowed) {
971             // Update the allowance to reflect the transfer
972             allowed[from][msg.sender] = allowed[from][msg.sender].subtract(tokens);
973             // Transfer the tokens
974             transferTokens(from, to, tokens);
975         }
976         return transferAllowed;
977     }
978 
979     /**
980      *  @dev Overrides a transfer of tokens to the whitelisted account.
981      *
982      *  If the 'to' address is not currently a shareholder then it MUST become one.
983      *  If the transfer will reduce 'msg.sender' balance to 0, then that address MUST be removed
984      *  from the list of shareholders.
985      *  MUST be removed from the list of shareholders.
986      *  @param from The address to transfer from
987      *  @param to The address to transfer to.
988      *  @param tokens The number of tokens to be transferred.
989      */
990     function transferOverride(address from, address to, uint256 tokens)
991     external
992     isUnlocked
993     isNotCancelled(to)
994     hasFunds(from, tokens)
995     returns (bool) {
996         // Ensure the sender can perform the override.
997         bool transferAllowed = canTransfer(from, to, tokens, true);
998         // Ensure the transfer is allowed.
999         if (transferAllowed) {
1000             transferTokens(from, to, tokens);
1001         }
1002         return transferAllowed;
1003     }
1004 
1005     /**
1006      *  @dev Tokens will be issued to the issuer's address only.
1007      *  @param quantity The number of tokens to mint.
1008      *  @return A boolean that indicates if the operation was successful.
1009      */
1010     function issueTokens(uint256 quantity)
1011     external
1012     isUnlocked
1013     onlyIssuer
1014     canIssue
1015     returns (bool) {
1016         // Avoid doing any state changes for zero quantities
1017         if (quantity > 0) {
1018             totalSupplyTokens = totalSupplyTokens.add(quantity);
1019             balances[issuer] = balances[issuer].add(quantity);
1020             shareholders.append(issuer);
1021         }
1022         emit Issue(issuer, quantity);
1023         emit Transfer(ZERO_ADDRESS, issuer, quantity);
1024         return true;
1025     }
1026 
1027     /**
1028      *  @dev Finishes token issuance.
1029      *  This is a single use function, once invoked it cannot be undone.
1030      */
1031     function finishIssuing()
1032     external
1033     isUnlocked
1034     onlyIssuer
1035     canIssue
1036     returns (bool) {
1037         issuingFinished = true;
1038         emit IssueFinished();
1039         return issuingFinished;
1040     }
1041 
1042     /**
1043      *  @dev Cancel the original address and reissue the Tokens to the replacement address.
1044      *
1045      *  Access to this function is restricted to the Issuer only.
1046      *  The 'original' address MUST be removed from the set of whitelisted addresses.
1047      *  Throw if the 'original' address supplied is not a shareholder.
1048      *  Throw if the 'replacement' address is not a whitelisted address.
1049      *  This function MUST emit the 'VerifiedAddressSuperseded' event.
1050      *  @param original The address to be superseded. This address MUST NOT be reused and must be whitelisted.
1051      *  @param replacement The address  that supersedes the original. This address MUST be whitelisted.
1052      */
1053     function cancelAndReissue(address original, address replacement)
1054     external
1055     isUnlocked
1056     onlyIssuer
1057     isNotCancelled(replacement) {
1058         // Ensure the reissue can take place
1059         require(shareholders.exists(original) && !shareholders.exists(replacement), "Original doesn't exist or replacement does");
1060         if (address(compliance) != ZERO_ADDRESS) {
1061             require(compliance.canIssue(msg.sender, original, replacement, balances[original]), "Failed 'canIssue' check.");
1062         }
1063 
1064         // Replace the original shareholder with the replacement
1065         shareholders.remove(original);
1066         shareholders.append(replacement);
1067         // Add the original as a cancelled address (preventing it from future trading)
1068         cancellations[original] = replacement;
1069         // Transfer the balance to the replacement
1070         balances[replacement] = balances[original];
1071         balances[original] = 0;
1072         emit VerifiedAddressSuperseded(original, replacement, msg.sender);
1073     }
1074 
1075     /**
1076      * @dev Approve the passed address to spend the specified number of tokens on behalf of msg.sender.
1077      *
1078      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1079      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1080      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1081      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1082      * @param spender The address which will spend the funds.
1083      * @param tokens The number of tokens of tokens to be spent.
1084      */
1085     function approve(address spender, uint256 tokens)
1086     external
1087     isUnlocked
1088     isNotCancelled(msg.sender)
1089     returns (bool) {
1090         require(shareholders.exists(msg.sender), "Must be a shareholder to approve token transfer");
1091         allowed[msg.sender][spender] = tokens;
1092         emit Approval(msg.sender, spender, tokens);
1093         return true;
1094     }
1095 
1096     /**
1097      *  @dev Set the issuer address.
1098      *  @param newIssuer The address of the issuer.
1099      */
1100     function setIssuer(address newIssuer)
1101     external
1102     isUnlocked
1103     onlyOwner {
1104         issuer = newIssuer;
1105         emit IssuerSet(issuer, newIssuer);
1106     }
1107 
1108     /**
1109      *  @dev Sets the compliance contract address to use during transfers.
1110      *  @param newComplianceAddress The address of the compliance contract.
1111      */
1112     function setCompliance(address newComplianceAddress)
1113     external
1114     isUnlocked
1115     onlyOwner {
1116         compliance = Compliance(newComplianceAddress);
1117     }
1118 
1119     // -------------------------------- Getters --------------------------------
1120 
1121     /**
1122      *  @dev Returns the total token supply
1123      *  @return total number of tokens in existence
1124      */
1125     function totalSupply()
1126     external
1127     view
1128     returns (uint256) {
1129         return totalSupplyTokens;
1130     }
1131 
1132     /**
1133      *  @dev Gets the balance of the specified address.
1134      *  @param addr The address to query the the balance of.
1135      *  @return An uint256 representing the tokens owned by the passed address.
1136      */
1137     function balanceOf(address addr)
1138     external
1139     view
1140     returns (uint256) {
1141         return balances[addr];
1142     }
1143 
1144     /**
1145      *  @dev Gets the number of tokens that an owner has allowed the spender to transfer.
1146      *  @param addrOwner address The address which owns the funds.
1147      *  @param spender address The address which will spend the funds.
1148      *  @return A uint256 specifying the number of tokens still available for the spender.
1149      */
1150     function allowance(address addrOwner, address spender)
1151     external
1152     view
1153     returns (uint256) {
1154         return allowed[addrOwner][spender];
1155     }
1156 
1157     /**
1158      *  By counting the number of token holders using 'holderCount'
1159      *  you can retrieve the complete list of token holders, one at a time.
1160      *  It MUST throw if 'index >= holderCount()'.
1161      *  @dev Returns the holder at the given index.
1162      *  @param index The zero-based index of the holder.
1163      *  @return the address of the token holder with the given index.
1164      */
1165     function holderAt(int256 index)
1166     external
1167     view
1168     returns (address){
1169         return shareholders.at(index);
1170     }
1171 
1172     /**
1173      *  @dev Checks to see if the supplied address is a share holder.
1174      *  @param addr The address to check.
1175      *  @return true if the supplied address owns a token.
1176      */
1177     function isHolder(address addr)
1178     external
1179     view
1180     returns (bool) {
1181         return shareholders.exists(addr);
1182     }
1183 
1184     /**
1185      *  @dev Checks to see if the supplied address was superseded.
1186      *  @param addr The address to check.
1187      *  @return true if the supplied address was superseded by another address.
1188      */
1189     function isSuperseded(address addr)
1190     external
1191     view
1192     returns (bool) {
1193         return cancellations[addr] != ZERO_ADDRESS;
1194     }
1195 
1196     /**
1197      *  Gets the most recent address, given a superseded one.
1198      *  Addresses may be superseded multiple times, so this function needs to
1199      *  follow the chain of addresses until it reaches the final, verified address.
1200      *  @param addr The superseded address.
1201      *  @return the verified address that ultimately holds the share.
1202      */
1203     function getSuperseded(address addr)
1204     external
1205     view
1206     returns (address) {
1207         require(addr != ZERO_ADDRESS, "Non-zero address required");
1208 
1209         address candidate = cancellations[addr];
1210         if (candidate == ZERO_ADDRESS) {
1211             return ZERO_ADDRESS;
1212         }
1213         return candidate;
1214     }
1215 
1216 
1217     // -------------------------------- Private --------------------------------
1218 
1219     /**
1220      *  @dev Checks if a transfer/override may take place between the two accounts.
1221      *
1222      *   Validates that the transfer can take place.
1223      *     - Ensure the 'to' address is not cancelled
1224      *     - Ensure the transfer is compliant
1225      *  @param from The sender address.
1226      *  @param to The recipient address.
1227      *  @param tokens The number of tokens being transferred.
1228      *  @param isOverride If this is a transfer override
1229      *  @return If the transfer can take place.
1230      */
1231     function canTransfer(address from, address to, uint256 tokens, bool isOverride)
1232     private
1233     isNotCancelled(to)
1234     returns (bool) {
1235         // Don't allow overrides and ignore compliance rules when compliance not set.
1236         if (address(compliance) == ZERO_ADDRESS) {
1237             return !isOverride;
1238         }
1239 
1240         // Ensure the override is valid, or that the transfer is compliant.
1241         if (isOverride) {
1242             return compliance.canOverride(msg.sender, from, to, tokens);
1243         } else {
1244             return compliance.canTransfer(msg.sender, from, to, tokens);
1245         }
1246     }
1247 
1248     /**
1249      *  @dev Transfers tokens from one address to another
1250      *  @param from The sender address.
1251      *  @param to The recipient address.
1252      *  @param tokens The number of tokens being transferred.
1253      */
1254     function transferTokens(address from, address to, uint256 tokens)
1255     private {
1256         // Update balances
1257         balances[from] = balances[from].subtract(tokens);
1258         balances[to] = balances[to].add(tokens);
1259         emit Transfer(from, to, tokens);
1260 
1261         // Adds the shareholder if they don't already exist.
1262         if (balances[to] > 0 && shareholders.append(to)) {
1263             emit ShareholderAdded(to);
1264         }
1265         // Remove the shareholder if they no longer hold tokens.
1266         if (balances[from] == 0 && shareholders.remove(from)) {
1267             emit ShareholderRemoved(from);
1268         }
1269     }
1270 
1271 }