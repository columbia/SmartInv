1 // This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 pragma solidity ^0.6.7;
15 
16 abstract contract StructLike {
17     function val(uint256 _id) virtual public view returns (uint256);
18 }
19 
20 /**
21  * @title LinkedList (Structured Link List)
22  * @author Vittorio Minacori (https://github.com/vittominacori)
23  * @dev An utility library for using sorted linked list data structures in your Solidity project.
24  */
25 library LinkedList {
26 
27     uint256 private constant NULL = 0;
28     uint256 private constant HEAD = 0;
29 
30     bool private constant PREV = false;
31     bool private constant NEXT = true;
32 
33     struct List {
34         mapping(uint256 => mapping(bool => uint256)) list;
35     }
36 
37     /**
38      * @dev Checks if the list exists
39      * @param self stored linked list from contract
40      * @return bool true if list exists, false otherwise
41      */
42     function isList(List storage self) internal view returns (bool) {
43         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
44         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
45             return true;
46         } else {
47             return false;
48         }
49     }
50 
51     /**
52      * @dev Checks if the node exists
53      * @param self stored linked list from contract
54      * @param _node a node to search for
55      * @return bool true if node exists, false otherwise
56      */
57     function isNode(List storage self, uint256 _node) internal view returns (bool) {
58         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
59             if (self.list[HEAD][NEXT] == _node) {
60                 return true;
61             } else {
62                 return false;
63             }
64         } else {
65             return true;
66         }
67     }
68 
69     /**
70      * @dev Returns the number of elements in the list
71      * @param self stored linked list from contract
72      * @return uint256
73      */
74     function range(List storage self) internal view returns (uint256) {
75         uint256 i;
76         uint256 num;
77         (, i) = adj(self, HEAD, NEXT);
78         while (i != HEAD) {
79             (, i) = adj(self, i, NEXT);
80             num++;
81         }
82         return num;
83     }
84 
85     /**
86      * @dev Returns the links of a node as a tuple
87      * @param self stored linked list from contract
88      * @param _node id of the node to get
89      * @return bool, uint256, uint256 true if node exists or false otherwise, previous node, next node
90      */
91     function node(List storage self, uint256 _node) internal view returns (bool, uint256, uint256) {
92         if (!isNode(self, _node)) {
93             return (false, 0, 0);
94         } else {
95             return (true, self.list[_node][PREV], self.list[_node][NEXT]);
96         }
97     }
98 
99     /**
100      * @dev Returns the link of a node `_node` in direction `_direction`.
101      * @param self stored linked list from contract
102      * @param _node id of the node to step from
103      * @param _direction direction to step in
104      * @return bool, uint256 true if node exists or false otherwise, node in _direction
105      */
106     function adj(List storage self, uint256 _node, bool _direction) internal view returns (bool, uint256) {
107         if (!isNode(self, _node)) {
108             return (false, 0);
109         } else {
110             return (true, self.list[_node][_direction]);
111         }
112     }
113 
114     /**
115      * @dev Returns the link of a node `_node` in direction `NEXT`.
116      * @param self stored linked list from contract
117      * @param _node id of the node to step from
118      * @return bool, uint256 true if node exists or false otherwise, next node
119      */
120     function next(List storage self, uint256 _node) internal view returns (bool, uint256) {
121         return adj(self, _node, NEXT);
122     }
123 
124     /**
125      * @dev Returns the link of a node `_node` in direction `PREV`.
126      * @param self stored linked list from contract
127      * @param _node id of the node to step from
128      * @return bool, uint256 true if node exists or false otherwise, previous node
129      */
130     function prev(List storage self, uint256 _node) internal view returns (bool, uint256) {
131         return adj(self, _node, PREV);
132     }
133 
134     /**
135      * @dev Can be used before `insert` to build an ordered list.
136      * @dev Get the node and then `back` or `face` basing on your list order.
137      * @dev If you want to order basing on other than `structure.val()` override this function
138      * @param self stored linked list from contract
139      * @param _struct the structure instance
140      * @param _val value to seek
141      * @return uint256 next node with a value less than _value
142      */
143     function sort(List storage self, address _struct, uint256 _val) internal view returns (uint256) {
144         if (range(self) == 0) {
145             return 0;
146         }
147         bool exists;
148         uint256 next_;
149         (exists, next_) = adj(self, HEAD, NEXT);
150         while ((next_ != 0) && ((_val < StructLike(_struct).val(next_)) != NEXT)) {
151             next_ = self.list[next_][NEXT];
152         }
153         return next_;
154     }
155 
156     /**
157      * @dev Creates a bidirectional link between two nodes on direction `_direction`
158      * @param self stored linked list from contract
159      * @param _node first node for linking
160      * @param _link  node to link to in the _direction
161      */
162     function form(List storage self, uint256 _node, uint256 _link, bool _dir) internal {
163         self.list[_link][!_dir] = _node;
164         self.list[_node][_dir] = _link;
165     }
166 
167     /**
168      * @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
169      * @param self stored linked list from contract
170      * @param _node existing node
171      * @param _new  new node to insert
172      * @param _direction direction to insert node in
173      * @return bool true if success, false otherwise
174      */
175     function insert(List storage self, uint256 _node, uint256 _new, bool _direction) internal returns (bool) {
176         if (!isNode(self, _new) && isNode(self, _node)) {
177             uint256 c = self.list[_node][_direction];
178             form(self, _node, _new, _direction);
179             form(self, _new, c, _direction);
180             return true;
181         } else {
182             return false;
183         }
184     }
185 
186     /**
187      * @dev Insert node `_new` beside existing node `_node` in direction `NEXT`.
188      * @param self stored linked list from contract
189      * @param _node existing node
190      * @param _new  new node to insert
191      * @return bool true if success, false otherwise
192      */
193     function face(List storage self, uint256 _node, uint256 _new) internal returns (bool) {
194         return insert(self, _node, _new, NEXT);
195     }
196 
197     /**
198      * @dev Insert node `_new` beside existing node `_node` in direction `PREV`.
199      * @param self stored linked list from contract
200      * @param _node existing node
201      * @param _new  new node to insert
202      * @return bool true if success, false otherwise
203      */
204     function back(List storage self, uint256 _node, uint256 _new) internal returns (bool) {
205         return insert(self, _node, _new, PREV);
206     }
207 
208     /**
209      * @dev Removes an entry from the linked list
210      * @param self stored linked list from contract
211      * @param _node node to remove from the list
212      * @return uint256 the removed node
213      */
214     function del(List storage self, uint256 _node) internal returns (uint256) {
215         if ((_node == NULL) || (!isNode(self, _node))) {
216             return 0;
217         }
218         form(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
219         delete self.list[_node][PREV];
220         delete self.list[_node][NEXT];
221         return _node;
222     }
223 
224     /**
225      * @dev Pushes an entry to the head of the linked list
226      * @param self stored linked list from contract
227      * @param _node new entry to push to the head
228      * @param _direction push to the head (NEXT) or tail (PREV)
229      * @return bool true if success, false otherwise
230      */
231     function push(List storage self, uint256 _node, bool _direction) internal returns (bool) {
232         return insert(self, HEAD, _node, _direction);
233     }
234 
235     /**
236      * @dev Pops the first entry from the linked list
237      * @param self stored linked list from contract
238      * @param _direction pop from the head (NEXT) or the tail (PREV)
239      * @return uint256 the removed node
240      */
241     function pop(List storage self, bool _direction) internal returns (uint256) {
242         bool exists;
243         uint256 adj_;
244         (exists, adj_) = adj(self, HEAD, _direction);
245         return del(self, adj_);
246     }
247 }
248 
249 abstract contract SAFEEngineLike {
250     function collateralTypes(bytes32) virtual public view returns (
251         uint256 debtAmount,       // [wad]
252         uint256 accumulatedRate   // [ray]
253     );
254     function updateAccumulatedRate(bytes32,address,int) virtual external;
255     function coinBalance(address) virtual public view returns (uint);
256 }
257 
258 contract TaxCollector {
259     using LinkedList for LinkedList.List;
260 
261     // --- Auth ---
262     mapping (address => uint) public authorizedAccounts;
263     /**
264      * @notice Add auth to an account
265      * @param account Account to add auth to
266      */
267     function addAuthorization(address account) external isAuthorized {
268         authorizedAccounts[account] = 1;
269         emit AddAuthorization(account);
270     }
271     /**
272      * @notice Remove auth from an account
273      * @param account Account to remove auth from
274      */
275     function removeAuthorization(address account) external isAuthorized {
276         authorizedAccounts[account] = 0;
277         emit RemoveAuthorization(account);
278     }
279     /**
280     * @notice Checks whether msg.sender can call an authed function
281     **/
282     modifier isAuthorized {
283         require(authorizedAccounts[msg.sender] == 1, "TaxCollector/account-not-authorized");
284         _;
285     }
286 
287     // --- Events ---
288     event AddAuthorization(address account);
289     event RemoveAuthorization(address account);
290     event InitializeCollateralType(bytes32 collateralType);
291     event ModifyParameters(
292       bytes32 collateralType,
293       bytes32 parameter,
294       uint data
295     );
296     event ModifyParameters(bytes32 parameter, uint data);
297     event ModifyParameters(bytes32 parameter, address data);
298     event ModifyParameters(
299       bytes32 collateralType,
300       uint256 position,
301       uint256 val
302     );
303     event ModifyParameters(
304       bytes32 collateralType,
305       uint256 position,
306       uint256 taxPercentage,
307       address receiverAccount
308     );
309     event AddSecondaryReceiver(
310       bytes32 collateralType,
311       uint secondaryReceiverNonce,
312       uint latestSecondaryReceiver,
313       uint secondaryReceiverAllotedTax,
314       uint secondaryReceiverRevenueSources
315     );
316     event ModifySecondaryReceiver(
317       bytes32 collateralType,
318       uint secondaryReceiverNonce,
319       uint latestSecondaryReceiver,
320       uint secondaryReceiverAllotedTax,
321       uint secondaryReceiverRevenueSources
322     );
323     event CollectTax(bytes32 collateralType, uint latestAccumulatedRate, int deltaRate);
324     event DistributeTax(bytes32 collateralType, address target, int taxCut);
325 
326     // --- Data ---
327     struct CollateralType {
328         // Per second borrow rate for this specific collateral type
329         uint256 stabilityFee;
330         // When SF was last collected for this collateral type
331         uint256 updateTime;
332     }
333     // SF receiver
334     struct TaxReceiver {
335         // Whether this receiver can accept a negative rate (taking SF from it)
336         uint256 canTakeBackTax;                                                 // [bool]
337         // Percentage of SF allocated to this receiver
338         uint256 taxPercentage;                                                  // [ray%]
339     }
340 
341     // Data about each collateral type
342     mapping (bytes32 => CollateralType)                  public collateralTypes;
343     // Percentage of each collateral's SF that goes to other addresses apart from the primary receiver
344     mapping (bytes32 => uint)                            public secondaryReceiverAllotedTax;              // [%ray]
345     // Whether an address is already used for a tax receiver
346     mapping (address => uint256)                         public usedSecondaryReceiver;                    // [bool]
347     // Address associated to each tax receiver index
348     mapping (uint256 => address)                         public secondaryReceiverAccounts;
349     // How many collateral types send SF to a specific tax receiver
350     mapping (address => uint256)                         public secondaryReceiverRevenueSources;
351     // Tax receiver data
352     mapping (bytes32 => mapping(uint256 => TaxReceiver)) public secondaryTaxReceivers;
353 
354     address    public primaryTaxReceiver;
355     // Base stability fee charged to all collateral types
356     uint256    public globalStabilityFee;                                                                 // [ray%]
357     // Number of secondary tax receivers ever added
358     uint256    public secondaryReceiverNonce;
359     // Max number of secondarytax receivers a collateral type can have
360     uint256    public maxSecondaryReceivers;
361     // Latest secondary tax receiver that still has at least one revenue source
362     uint256    public latestSecondaryReceiver;
363 
364     // All collateral types
365     bytes32[]        public   collateralList;
366     // Linked list with tax receiver data
367     LinkedList.List  internal secondaryReceiverList;
368 
369     SAFEEngineLike public safeEngine;
370 
371     // --- Init ---
372     constructor(address safeEngine_) public {
373         authorizedAccounts[msg.sender] = 1;
374         safeEngine = SAFEEngineLike(safeEngine_);
375         emit AddAuthorization(msg.sender);
376     }
377 
378     // --- Math ---
379     function rpow(uint x, uint n, uint b) internal pure returns (uint z) {
380       assembly {
381         switch x case 0 {switch n case 0 {z := b} default {z := 0}}
382         default {
383           switch mod(n, 2) case 0 { z := b } default { z := x }
384           let half := div(b, 2)  // for rounding.
385           for { n := div(n, 2) } n { n := div(n,2) } {
386             let xx := mul(x, x)
387             if iszero(eq(div(xx, x), x)) { revert(0,0) }
388             let xxRound := add(xx, half)
389             if lt(xxRound, xx) { revert(0,0) }
390             x := div(xxRound, b)
391             if mod(n,2) {
392               let zx := mul(z, x)
393               if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
394               let zxRound := add(zx, half)
395               if lt(zxRound, zx) { revert(0,0) }
396               z := div(zxRound, b)
397             }
398           }
399         }
400       }
401     }
402     uint256 constant RAY     = 10 ** 27;
403     uint256 constant HUNDRED = 10 ** 29;
404     uint256 constant ONE     = 1;
405 
406     function addition(uint x, uint y) internal pure returns (uint z) {
407         z = x + y;
408         require(z >= x);
409     }
410     function addition(int x, int y) internal pure returns (int z) {
411         z = x + y;
412         if (y <= 0) require(z <= x);
413         if (y  > 0) require(z > x);
414     }
415     function subtract(uint x, uint y) internal pure returns (uint z) {
416         require((z = x - y) <= x);
417     }
418     function subtract(int x, int y) internal pure returns (int z) {
419         z = x - y;
420         require(y <= 0 || z <= x);
421         require(y >= 0 || z >= x);
422     }
423     function deduct(uint x, uint y) internal pure returns (int z) {
424         z = int(x) - int(y);
425         require(int(x) >= 0 && int(y) >= 0);
426     }
427     function multiply(uint x, int y) internal pure returns (int z) {
428         z = int(x) * y;
429         require(int(x) >= 0);
430         require(y == 0 || z / y == int(x));
431     }
432     function multiply(int x, int y) internal pure returns (int z) {
433         require(y == 0 || (z = x * y) / y == x);
434     }
435     function rmultiply(uint x, uint y) internal pure returns (uint z) {
436         z = x * y;
437         require(y == 0 || z / y == x);
438         z = z / RAY;
439     }
440 
441     function both(bool x, bool y) internal pure returns (bool z) {
442         assembly{ z := and(x, y)}
443     }
444     function either(bool x, bool y) internal pure returns (bool z) {
445         assembly{ z := or(x, y)}
446     }
447 
448     // --- Administration ---
449     /**
450      * @notice Initialize a brand new collateral type
451      * @param collateralType Collateral type name (e.g ETH-A, TBTC-B)
452      */
453     function initializeCollateralType(bytes32 collateralType) external isAuthorized {
454         CollateralType storage collateralType_ = collateralTypes[collateralType];
455         require(collateralType_.stabilityFee == 0, "TaxCollector/collateral-type-already-init");
456         collateralType_.stabilityFee = RAY;
457         collateralType_.updateTime   = now;
458         collateralList.push(collateralType);
459         emit InitializeCollateralType(collateralType);
460     }
461     /**
462      * @notice Modify collateral specific uint params
463      * @param collateralType Collateral type who's parameter is modified
464      * @param parameter The name of the parameter modified
465      * @param data New value for the parameter
466      */
467     function modifyParameters(
468         bytes32 collateralType,
469         bytes32 parameter,
470         uint data
471     ) external isAuthorized {
472         require(now == collateralTypes[collateralType].updateTime, "TaxCollector/update-time-not-now");
473         if (parameter == "stabilityFee") collateralTypes[collateralType].stabilityFee = data;
474         else revert("TaxCollector/modify-unrecognized-param");
475         emit ModifyParameters(
476           collateralType,
477           parameter,
478           data
479         );
480     }
481     /**
482      * @notice Modify general uint params
483      * @param parameter The name of the parameter modified
484      * @param data New value for the parameter
485      */
486     function modifyParameters(bytes32 parameter, uint data) external isAuthorized {
487         if (parameter == "globalStabilityFee") globalStabilityFee = data;
488         else if (parameter == "maxSecondaryReceivers") maxSecondaryReceivers = data;
489         else revert("TaxCollector/modify-unrecognized-param");
490         emit ModifyParameters(parameter, data);
491     }
492     /**
493      * @notice Modify general address params
494      * @param parameter The name of the parameter modified
495      * @param data New value for the parameter
496      */
497     function modifyParameters(bytes32 parameter, address data) external isAuthorized {
498         require(data != address(0), "TaxCollector/null-data");
499         if (parameter == "primaryTaxReceiver") primaryTaxReceiver = data;
500         else revert("TaxCollector/modify-unrecognized-param");
501         emit ModifyParameters(parameter, data);
502     }
503     /**
504      * @notice Set whether a tax receiver can incur negative fees
505      * @param collateralType Collateral type giving fees to the tax receiver
506      * @param position Receiver position in the list
507      * @param val Value that specifies whether a tax receiver can incur negative rates
508      */
509     function modifyParameters(
510         bytes32 collateralType,
511         uint256 position,
512         uint256 val
513     ) external isAuthorized {
514         if (both(secondaryReceiverList.isNode(position), secondaryTaxReceivers[collateralType][position].taxPercentage > 0)) {
515             secondaryTaxReceivers[collateralType][position].canTakeBackTax = val;
516         }
517         else revert("TaxCollector/unknown-tax-receiver");
518         emit ModifyParameters(
519           collateralType,
520           position,
521           val
522         );
523     }
524     /**
525      * @notice Create or modify a secondary tax receiver's data
526      * @param collateralType Collateral type that will give SF to the tax receiver
527      * @param position Receiver position in the list. Used to determine whether a new tax receiver is
528               created or an existing one is edited
529      * @param taxPercentage Percentage of SF offered to the tax receiver
530      * @param receiverAccount Receiver address
531      */
532     function modifyParameters(
533       bytes32 collateralType,
534       uint256 position,
535       uint256 taxPercentage,
536       address receiverAccount
537     ) external isAuthorized {
538         (!secondaryReceiverList.isNode(position)) ?
539           addSecondaryReceiver(collateralType, taxPercentage, receiverAccount) :
540           modifySecondaryReceiver(collateralType, position, taxPercentage);
541         emit ModifyParameters(
542           collateralType,
543           position,
544           taxPercentage,
545           receiverAccount
546         );
547     }
548 
549     // --- Tax Receiver Utils ---
550     /**
551      * @notice Add a new secondary tax receiver
552      * @param collateralType Collateral type that will give SF to the tax receiver
553      * @param taxPercentage Percentage of SF offered to the tax receiver
554      * @param receiverAccount Tax receiver address
555      */
556     function addSecondaryReceiver(bytes32 collateralType, uint256 taxPercentage, address receiverAccount) internal {
557         require(receiverAccount != address(0), "TaxCollector/null-account");
558         require(receiverAccount != primaryTaxReceiver, "TaxCollector/primary-receiver-cannot-be-secondary");
559         require(taxPercentage > 0, "TaxCollector/null-sf");
560         require(usedSecondaryReceiver[receiverAccount] == 0, "TaxCollector/account-already-used");
561         require(addition(secondaryReceiversAmount(), ONE) <= maxSecondaryReceivers, "TaxCollector/exceeds-max-receiver-limit");
562         require(addition(secondaryReceiverAllotedTax[collateralType], taxPercentage) < HUNDRED, "TaxCollector/tax-cut-exceeds-hundred");
563         secondaryReceiverNonce                                                       = addition(secondaryReceiverNonce, 1);
564         latestSecondaryReceiver                                                      = secondaryReceiverNonce;
565         usedSecondaryReceiver[receiverAccount]                                       = ONE;
566         secondaryReceiverAllotedTax[collateralType]                                  = addition(secondaryReceiverAllotedTax[collateralType], taxPercentage);
567         secondaryTaxReceivers[collateralType][latestSecondaryReceiver].taxPercentage = taxPercentage;
568         secondaryReceiverAccounts[latestSecondaryReceiver]                           = receiverAccount;
569         secondaryReceiverRevenueSources[receiverAccount]                             = ONE;
570         secondaryReceiverList.push(latestSecondaryReceiver, false);
571         emit AddSecondaryReceiver(
572           collateralType,
573           secondaryReceiverNonce,
574           latestSecondaryReceiver,
575           secondaryReceiverAllotedTax[collateralType],
576           secondaryReceiverRevenueSources[receiverAccount]
577         );
578     }
579     /**
580      * @notice Update a secondary tax receiver's data (add a new SF source or modify % of SF taken from a collateral type)
581      * @param collateralType Collateral type that will give SF to the tax receiver
582      * @param position Receiver's position in the tax receiver list
583      * @param taxPercentage Percentage of SF offered to the tax receiver (ray%)
584      */
585     function modifySecondaryReceiver(bytes32 collateralType, uint256 position, uint256 taxPercentage) internal {
586         if (taxPercentage == 0) {
587           secondaryReceiverAllotedTax[collateralType] = subtract(
588             secondaryReceiverAllotedTax[collateralType],
589             secondaryTaxReceivers[collateralType][position].taxPercentage
590           );
591 
592           if (secondaryReceiverRevenueSources[secondaryReceiverAccounts[position]] == 1) {
593             if (position == latestSecondaryReceiver) {
594               (, uint256 prevReceiver) = secondaryReceiverList.prev(latestSecondaryReceiver);
595               latestSecondaryReceiver = prevReceiver;
596             }
597             secondaryReceiverList.del(position);
598             delete(usedSecondaryReceiver[secondaryReceiverAccounts[position]]);
599             delete(secondaryTaxReceivers[collateralType][position]);
600             delete(secondaryReceiverRevenueSources[secondaryReceiverAccounts[position]]);
601             delete(secondaryReceiverAccounts[position]);
602           } else if (secondaryTaxReceivers[collateralType][position].taxPercentage > 0) {
603             secondaryReceiverRevenueSources[secondaryReceiverAccounts[position]] = subtract(secondaryReceiverRevenueSources[secondaryReceiverAccounts[position]], 1);
604             delete(secondaryTaxReceivers[collateralType][position]);
605           }
606         } else {
607           uint256 secondaryReceiverAllotedTax_ = addition(
608             subtract(secondaryReceiverAllotedTax[collateralType], secondaryTaxReceivers[collateralType][position].taxPercentage),
609             taxPercentage
610           );
611           require(secondaryReceiverAllotedTax_ < HUNDRED, "TaxCollector/tax-cut-too-big");
612           if (secondaryTaxReceivers[collateralType][position].taxPercentage == 0) {
613             secondaryReceiverRevenueSources[secondaryReceiverAccounts[position]] = addition(
614               secondaryReceiverRevenueSources[secondaryReceiverAccounts[position]],
615               1
616             );
617           }
618           secondaryReceiverAllotedTax[collateralType]                   = secondaryReceiverAllotedTax_;
619           secondaryTaxReceivers[collateralType][position].taxPercentage = taxPercentage;
620         }
621         emit ModifySecondaryReceiver(
622           collateralType,
623           secondaryReceiverNonce,
624           latestSecondaryReceiver,
625           secondaryReceiverAllotedTax[collateralType],
626           secondaryReceiverRevenueSources[secondaryReceiverAccounts[position]]
627         );
628     }
629 
630     // --- Tax Collection Utils ---
631     /**
632      * @notice Check if multiple collateral types are up to date with taxation
633      */
634     function collectedManyTax(uint start, uint end) public view returns (bool ok) {
635         require(both(start <= end, end < collateralList.length), "TaxCollector/invalid-indexes");
636         for (uint i = start; i <= end; i++) {
637           if (now > collateralTypes[collateralList[i]].updateTime) {
638             ok = false;
639             return ok;
640           }
641         }
642         ok = true;
643     }
644     /**
645      * @notice Check how much SF will be charged (to collateral types between indexes 'start' and 'end'
646      *         in the collateralList) during the next taxation
647      * @param start Index in collateralList from which to start looping and calculating the tax outcome
648      * @param end Index in collateralList at which we stop looping and calculating the tax outcome
649      */
650     function taxManyOutcome(uint start, uint end) public view returns (bool ok, int rad) {
651         require(both(start <= end, end < collateralList.length), "TaxCollector/invalid-indexes");
652         int  primaryReceiverBalance = -int(safeEngine.coinBalance(primaryTaxReceiver));
653         int  deltaRate;
654         uint debtAmount;
655         for (uint i = start; i <= end; i++) {
656           if (now > collateralTypes[collateralList[i]].updateTime) {
657             (debtAmount, ) = safeEngine.collateralTypes(collateralList[i]);
658             (, deltaRate)  = taxSingleOutcome(collateralList[i]);
659             rad = addition(rad, multiply(debtAmount, deltaRate));
660           }
661         }
662         if (rad < 0) {
663           ok = (rad < primaryReceiverBalance) ? false : true;
664         } else {
665           ok = true;
666         }
667     }
668     /**
669      * @notice Get how much SF will be distributed after taxing a specific collateral type
670      * @param collateralType Collateral type to compute the taxation outcome for
671      */
672     function taxSingleOutcome(bytes32 collateralType) public view returns (uint, int) {
673         (, uint lastAccumulatedRate) = safeEngine.collateralTypes(collateralType);
674         uint newlyAccumulatedRate =
675           rmultiply(
676             rpow(
677               addition(
678                 globalStabilityFee,
679                 collateralTypes[collateralType].stabilityFee
680               ),
681               subtract(
682                 now,
683                 collateralTypes[collateralType].updateTime
684               ),
685             RAY),
686           lastAccumulatedRate);
687         return (newlyAccumulatedRate, deduct(newlyAccumulatedRate, lastAccumulatedRate));
688     }
689 
690     // --- Tax Receiver Utils ---
691     /**
692      * @notice Get the secondary tax receiver list length
693      */
694     function secondaryReceiversAmount() public view returns (uint) {
695         return secondaryReceiverList.range();
696     }
697     /**
698      * @notice Get the collateralList length
699      */
700     function collateralListLength() public view returns (uint) {
701         return collateralList.length;
702     }
703     /**
704      * @notice Check if a tax receiver is at a certain position in the list
705      */
706     function isSecondaryReceiver(uint256 _receiver) public view returns (bool) {
707         if (_receiver == 0) return false;
708         return secondaryReceiverList.isNode(_receiver);
709     }
710 
711     // --- Tax (Stability Fee) Collection ---
712     /**
713      * @notice Collect tax from multiple collateral types at once
714      * @param start Index in collateralList from which to start looping and calculating the tax outcome
715      * @param end Index in collateralList at which we stop looping and calculating the tax outcome
716      */
717     function taxMany(uint start, uint end) external {
718         require(both(start <= end, end < collateralList.length), "TaxCollector/invalid-indexes");
719         for (uint i = start; i <= end; i++) {
720             taxSingle(collateralList[i]);
721         }
722     }
723     /**
724      * @notice Collect tax from a single collateral type
725      * @param collateralType Collateral type to tax
726      */
727     function taxSingle(bytes32 collateralType) public returns (uint) {
728         uint latestAccumulatedRate;
729         if (now <= collateralTypes[collateralType].updateTime) {
730           (, latestAccumulatedRate) = safeEngine.collateralTypes(collateralType);
731           return latestAccumulatedRate;
732         }
733         (, int deltaRate) = taxSingleOutcome(collateralType);
734         // Check how much debt has been generated for collateralType
735         (uint debtAmount, ) = safeEngine.collateralTypes(collateralType);
736         splitTaxIncome(collateralType, debtAmount, deltaRate);
737         (, latestAccumulatedRate) = safeEngine.collateralTypes(collateralType);
738         collateralTypes[collateralType].updateTime = now;
739         emit CollectTax(collateralType, latestAccumulatedRate, deltaRate);
740         return latestAccumulatedRate;
741     }
742     /**
743      * @notice Split SF between all tax receivers
744      * @param collateralType Collateral type to distribute SF for
745      * @param deltaRate Difference between the last and the latest accumulate rates for the collateralType
746      */
747     function splitTaxIncome(bytes32 collateralType, uint debtAmount, int deltaRate) internal {
748         // Start looping from the latest tax receiver
749         uint256 currentSecondaryReceiver = latestSecondaryReceiver;
750         // While we still haven't gone through the entire tax receiver list
751         while (currentSecondaryReceiver > 0) {
752           // If the current tax receiver should receive SF from collateralType
753           if (secondaryTaxReceivers[collateralType][currentSecondaryReceiver].taxPercentage > 0) {
754             distributeTax(
755               collateralType,
756               secondaryReceiverAccounts[currentSecondaryReceiver],
757               currentSecondaryReceiver,
758               debtAmount,
759               deltaRate
760             );
761           }
762           // Continue looping
763           (, currentSecondaryReceiver) = secondaryReceiverList.prev(currentSecondaryReceiver);
764         }
765         // Distribute to primary receiver
766         distributeTax(collateralType, primaryTaxReceiver, uint(-1), debtAmount, deltaRate);
767     }
768 
769     /**
770      * @notice Give/withdraw SF from a tax receiver
771      * @param collateralType Collateral type to distribute SF for
772      * @param receiver Tax receiver address
773      * @param receiverListPosition Position of receiver in the secondaryReceiverList (if the receiver is secondary)
774      * @param debtAmount Total debt currently issued
775      * @param deltaRate Difference between the latest and the last accumulated rates for the collateralType
776      */
777     function distributeTax(
778         bytes32 collateralType,
779         address receiver,
780         uint256 receiverListPosition,
781         uint256 debtAmount,
782         int256 deltaRate
783     ) internal {
784         // Check how many coins the receiver has and negate the value
785         int256 coinBalance   = -int(safeEngine.coinBalance(receiver));
786         // Compute the % out of SF that should be allocated to the receiver
787         int256 currentTaxCut = (receiver == primaryTaxReceiver) ?
788           multiply(subtract(HUNDRED, secondaryReceiverAllotedTax[collateralType]), deltaRate) / int(HUNDRED) :
789           multiply(int(secondaryTaxReceivers[collateralType][receiverListPosition].taxPercentage), deltaRate) / int(HUNDRED);
790         /**
791             If SF is negative and a tax receiver doesn't have enough coins to absorb the loss,
792             compute a new tax cut that can be absorbed
793         **/
794         currentTaxCut  = (
795           both(multiply(debtAmount, currentTaxCut) < 0, coinBalance > multiply(debtAmount, currentTaxCut))
796         ) ? coinBalance / int(debtAmount) : currentTaxCut;
797         /**
798           If the tax receiver's tax cut is not null and if the receiver accepts negative SF
799           offer/take SF to/from them
800         **/
801         if (currentTaxCut != 0) {
802           if (
803             either(
804               receiver == primaryTaxReceiver,
805               either(
806                 deltaRate >= 0,
807                 both(currentTaxCut < 0, secondaryTaxReceivers[collateralType][receiverListPosition].canTakeBackTax > 0)
808               )
809             )
810           ) {
811             safeEngine.updateAccumulatedRate(collateralType, receiver, currentTaxCut);
812             emit DistributeTax(collateralType, receiver, currentTaxCut);
813           }
814        }
815     }
816 }