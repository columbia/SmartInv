1 // String Utils v0.1
2 
3 /// @title String Utils - String utility functions
4 /// @author Piper Merriam - 
5 library StringLib {
6     /*
7      *  Address: 0x443b53559d337277373171280ec57029718203fb
8      */
9 
10     /// @dev Converts an unsigned integert to its string representation.
11     /// @param v The number to be converted.
12     function uintToBytes(uint v) constant returns (bytes32 ret) {
13         if (v == 0) {
14             ret = '0';
15         }
16         else {
17             while (v > 0) {
18                 ret = bytes32(uint(ret) / (2 ** 8));
19                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
20                 v /= 10;
21             }
22         }
23         return ret;
24     }
25 
26     /// @dev Converts a numeric string to it's unsigned integer representation.
27     /// @param v The string to be converted.
28     function bytesToUInt(bytes32 v) constant returns (uint ret) {
29         if (v == 0x0) {
30             throw;
31         }
32 
33         uint digit;
34 
35         for (uint i = 0; i < 32; i++) {
36             digit = uint((uint(v) / (2 ** (8 * (31 - i)))) & 0xff);
37             if (digit == 0) {
38                 break;
39             }
40             else if (digit < 48 || digit > 57) {
41                 throw;
42             }
43             ret *= 10;
44             ret += (digit - 48);
45         }
46         return ret;
47     }
48 }
49 
50 
51 // Accounting v0.1 (not the same as the 0.1 release of this library)
52 
53 /// @title Accounting Lib - Accounting utilities
54 /// @author Piper Merriam - 
55 library AccountingLib {
56         /*
57          *  Address: 0x7de615d8a51746a9f10f72a593fb5b3718dc3d52
58          */
59         struct Bank {
60             mapping (address => uint) accountBalances;
61         }
62 
63         /// @dev Low level method for adding funds to an account.  Protects against overflow.
64         /// @param self The Bank instance to operate on.
65         /// @param accountAddress The address of the account the funds should be added to.
66         /// @param value The amount that should be added to the account.
67         function addFunds(Bank storage self, address accountAddress, uint value) public {
68                 if (self.accountBalances[accountAddress] + value < self.accountBalances[accountAddress]) {
69                         // Prevent Overflow.
70                         throw;
71                 }
72                 self.accountBalances[accountAddress] += value;
73         }
74 
75         event _Deposit(address indexed _from, address indexed accountAddress, uint value);
76         /// @dev Function wrapper around the _Deposit event so that it can be used by contracts.  Can be used to log a deposit to an account.
77         /// @param _from The address that deposited the funds.
78         /// @param accountAddress The address of the account the funds were added to.
79         /// @param value The amount that was added to the account.
80         function Deposit(address _from, address accountAddress, uint value) public {
81             _Deposit(_from, accountAddress, value);
82         }
83 
84 
85         /// @dev Safe function for depositing funds.  Returns boolean for whether the deposit was successful
86         /// @param self The Bank instance to operate on.
87         /// @param accountAddress The address of the account the funds should be added to.
88         /// @param value The amount that should be added to the account.
89         function deposit(Bank storage self, address accountAddress, uint value) public returns (bool) {
90                 addFunds(self, accountAddress, value);
91                 return true;
92         }
93 
94         event _Withdrawal(address indexed accountAddress, uint value);
95 
96         /// @dev Function wrapper around the _Withdrawal event so that it can be used by contracts.  Can be used to log a withdrawl from an account.
97         /// @param accountAddress The address of the account the funds were withdrawn from.
98         /// @param value The amount that was withdrawn to the account.
99         function Withdrawal(address accountAddress, uint value) public {
100             _Withdrawal(accountAddress, value);
101         }
102 
103         event _InsufficientFunds(address indexed accountAddress, uint value, uint balance);
104 
105         /// @dev Function wrapper around the _InsufficientFunds event so that it can be used by contracts.  Can be used to log a failed withdrawl from an account.
106         /// @param accountAddress The address of the account the funds were to be withdrawn from.
107         /// @param value The amount that was attempted to be withdrawn from the account.
108         /// @param balance The current balance of the account.
109         function InsufficientFunds(address accountAddress, uint value, uint balance) public {
110             _InsufficientFunds(accountAddress, value, balance);
111         }
112 
113         /// @dev Low level method for removing funds from an account.  Protects against underflow.
114         /// @param self The Bank instance to operate on.
115         /// @param accountAddress The address of the account the funds should be deducted from.
116         /// @param value The amount that should be deducted from the account.
117         function deductFunds(Bank storage self, address accountAddress, uint value) public {
118                 /*
119                  *  Helper function that should be used for any reduction of
120                  *  account funds.  It has error checking to prevent
121                  *  underflowing the account balance which would be REALLY bad.
122                  */
123                 if (value > self.accountBalances[accountAddress]) {
124                         // Prevent Underflow.
125                         throw;
126                 }
127                 self.accountBalances[accountAddress] -= value;
128         }
129 
130         /// @dev Safe function for withdrawing funds.  Returns boolean for whether the deposit was successful as well as sending the amount in ether to the account address.
131         /// @param self The Bank instance to operate on.
132         /// @param accountAddress The address of the account the funds should be withdrawn from.
133         /// @param value The amount that should be withdrawn from the account.
134         function withdraw(Bank storage self, address accountAddress, uint value) public returns (bool) {
135                 /*
136                  *  Public API for withdrawing funds.
137                  */
138                 if (self.accountBalances[accountAddress] >= value) {
139                         deductFunds(self, accountAddress, value);
140                         if (!accountAddress.send(value)) {
141                                 // Potentially sending money to a contract that
142                                 // has a fallback function.  So instead, try
143                                 // tranferring the funds with the call api.
144                                 if (!accountAddress.call.value(value)()) {
145                                         // Revert the entire transaction.  No
146                                         // need to destroy the funds.
147                                         throw;
148                                 }
149                         }
150                         return true;
151                 }
152                 return false;
153         }
154 }
155 
156 // Grove v0.3 (not the same as the 0.3 release of this library)
157 
158 
159 /// @title GroveLib - Library for queriable indexed ordered data.
160 /// @author PiperMerriam - 
161 library GroveLib {
162         /*
163          *  Indexes for ordered data
164          *
165          *  Address: 0x920c890a90db8fba7604864b0cf38ee667331323
166          */
167         struct Index {
168                 bytes32 root;
169                 mapping (bytes32 => Node) nodes;
170         }
171 
172         struct Node {
173                 bytes32 id;
174                 int value;
175                 bytes32 parent;
176                 bytes32 left;
177                 bytes32 right;
178                 uint height;
179         }
180 
181         function max(uint a, uint b) internal returns (uint) {
182             if (a >= b) {
183                 return a;
184             }
185             return b;
186         }
187 
188         /*
189          *  Node getters
190          */
191         /// @dev Retrieve the unique identifier for the node.
192         /// @param index The index that the node is part of.
193         /// @param id The id for the node to be looked up.
194         function getNodeId(Index storage index, bytes32 id) constant returns (bytes32) {
195             return index.nodes[id].id;
196         }
197 
198         /// @dev Retrieve the value for the node.
199         /// @param index The index that the node is part of.
200         /// @param id The id for the node to be looked up.
201         function getNodeValue(Index storage index, bytes32 id) constant returns (int) {
202             return index.nodes[id].value;
203         }
204 
205         /// @dev Retrieve the height of the node.
206         /// @param index The index that the node is part of.
207         /// @param id The id for the node to be looked up.
208         function getNodeHeight(Index storage index, bytes32 id) constant returns (uint) {
209             return index.nodes[id].height;
210         }
211 
212         /// @dev Retrieve the parent id of the node.
213         /// @param index The index that the node is part of.
214         /// @param id The id for the node to be looked up.
215         function getNodeParent(Index storage index, bytes32 id) constant returns (bytes32) {
216             return index.nodes[id].parent;
217         }
218 
219         /// @dev Retrieve the left child id of the node.
220         /// @param index The index that the node is part of.
221         /// @param id The id for the node to be looked up.
222         function getNodeLeftChild(Index storage index, bytes32 id) constant returns (bytes32) {
223             return index.nodes[id].left;
224         }
225 
226         /// @dev Retrieve the right child id of the node.
227         /// @param index The index that the node is part of.
228         /// @param id The id for the node to be looked up.
229         function getNodeRightChild(Index storage index, bytes32 id) constant returns (bytes32) {
230             return index.nodes[id].right;
231         }
232 
233         /// @dev Retrieve the node id of the next node in the tree.
234         /// @param index The index that the node is part of.
235         /// @param id The id for the node to be looked up.
236         function getPreviousNode(Index storage index, bytes32 id) constant returns (bytes32) {
237             Node storage currentNode = index.nodes[id];
238 
239             if (currentNode.id == 0x0) {
240                 // Unknown node, just return 0x0;
241                 return 0x0;
242             }
243 
244             Node memory child;
245 
246             if (currentNode.left != 0x0) {
247                 // Trace left to latest child in left tree.
248                 child = index.nodes[currentNode.left];
249 
250                 while (child.right != 0) {
251                     child = index.nodes[child.right];
252                 }
253                 return child.id;
254             }
255 
256             if (currentNode.parent != 0x0) {
257                 // Now we trace back up through parent relationships, looking
258                 // for a link where the child is the right child of it's
259                 // parent.
260                 Node storage parent = index.nodes[currentNode.parent];
261                 child = currentNode;
262 
263                 while (true) {
264                     if (parent.right == child.id) {
265                         return parent.id;
266                     }
267 
268                     if (parent.parent == 0x0) {
269                         break;
270                     }
271                     child = parent;
272                     parent = index.nodes[parent.parent];
273                 }
274             }
275 
276             // This is the first node, and has no previous node.
277             return 0x0;
278         }
279 
280         /// @dev Retrieve the node id of the previous node in the tree.
281         /// @param index The index that the node is part of.
282         /// @param id The id for the node to be looked up.
283         function getNextNode(Index storage index, bytes32 id) constant returns (bytes32) {
284             Node storage currentNode = index.nodes[id];
285 
286             if (currentNode.id == 0x0) {
287                 // Unknown node, just return 0x0;
288                 return 0x0;
289             }
290 
291             Node memory child;
292 
293             if (currentNode.right != 0x0) {
294                 // Trace right to earliest child in right tree.
295                 child = index.nodes[currentNode.right];
296 
297                 while (child.left != 0) {
298                     child = index.nodes[child.left];
299                 }
300                 return child.id;
301             }
302 
303             if (currentNode.parent != 0x0) {
304                 // if the node is the left child of it's parent, then the
305                 // parent is the next one.
306                 Node storage parent = index.nodes[currentNode.parent];
307                 child = currentNode;
308 
309                 while (true) {
310                     if (parent.left == child.id) {
311                         return parent.id;
312                     }
313 
314                     if (parent.parent == 0x0) {
315                         break;
316                     }
317                     child = parent;
318                     parent = index.nodes[parent.parent];
319                 }
320 
321                 // Now we need to trace all the way up checking to see if any parent is the 
322             }
323 
324             // This is the final node.
325             return 0x0;
326         }
327 
328 
329         /// @dev Updates or Inserts the id into the index at its appropriate location based on the value provided.
330         /// @param index The index that the node is part of.
331         /// @param id The unique identifier of the data element the index node will represent.
332         /// @param value The value of the data element that represents it's total ordering with respect to other elementes.
333         function insert(Index storage index, bytes32 id, int value) public {
334                 if (index.nodes[id].id == id) {
335                     // A node with this id already exists.  If the value is
336                     // the same, then just return early, otherwise, remove it
337                     // and reinsert it.
338                     if (index.nodes[id].value == value) {
339                         return;
340                     }
341                     remove(index, id);
342                 }
343 
344                 uint leftHeight;
345                 uint rightHeight;
346 
347                 bytes32 previousNodeId = 0x0;
348 
349                 if (index.root == 0x0) {
350                     index.root = id;
351                 }
352                 Node storage currentNode = index.nodes[index.root];
353 
354                 // Do insertion
355                 while (true) {
356                     if (currentNode.id == 0x0) {
357                         // This is a new unpopulated node.
358                         currentNode.id = id;
359                         currentNode.parent = previousNodeId;
360                         currentNode.value = value;
361                         break;
362                     }
363 
364                     // Set the previous node id.
365                     previousNodeId = currentNode.id;
366 
367                     // The new node belongs in the right subtree
368                     if (value >= currentNode.value) {
369                         if (currentNode.right == 0x0) {
370                             currentNode.right = id;
371                         }
372                         currentNode = index.nodes[currentNode.right];
373                         continue;
374                     }
375 
376                     // The new node belongs in the left subtree.
377                     if (currentNode.left == 0x0) {
378                         currentNode.left = id;
379                     }
380                     currentNode = index.nodes[currentNode.left];
381                 }
382 
383                 // Rebalance the tree
384                 _rebalanceTree(index, currentNode.id);
385         }
386 
387         /// @dev Checks whether a node for the given unique identifier exists within the given index.
388         /// @param index The index that should be searched
389         /// @param id The unique identifier of the data element to check for.
390         function exists(Index storage index, bytes32 id) constant returns (bool) {
391             return (index.nodes[id].id == id);
392         }
393 
394         /// @dev Remove the node for the given unique identifier from the index.
395         /// @param index The index that should be removed
396         /// @param id The unique identifier of the data element to remove.
397         function remove(Index storage index, bytes32 id) public {
398             Node storage replacementNode;
399             Node storage parent;
400             Node storage child;
401             bytes32 rebalanceOrigin;
402 
403             Node storage nodeToDelete = index.nodes[id];
404 
405             if (nodeToDelete.id != id) {
406                 // The id does not exist in the tree.
407                 return;
408             }
409 
410             if (nodeToDelete.left != 0x0 || nodeToDelete.right != 0x0) {
411                 // This node is not a leaf node and thus must replace itself in
412                 // it's tree by either the previous or next node.
413                 if (nodeToDelete.left != 0x0) {
414                     // This node is guaranteed to not have a right child.
415                     replacementNode = index.nodes[getPreviousNode(index, nodeToDelete.id)];
416                 }
417                 else {
418                     // This node is guaranteed to not have a left child.
419                     replacementNode = index.nodes[getNextNode(index, nodeToDelete.id)];
420                 }
421                 // The replacementNode is guaranteed to have a parent.
422                 parent = index.nodes[replacementNode.parent];
423 
424                 // Keep note of the location that our tree rebalancing should
425                 // start at.
426                 rebalanceOrigin = replacementNode.id;
427 
428                 // Join the parent of the replacement node with any subtree of
429                 // the replacement node.  We can guarantee that the replacement
430                 // node has at most one subtree because of how getNextNode and
431                 // getPreviousNode are used.
432                 if (parent.left == replacementNode.id) {
433                     parent.left = replacementNode.right;
434                     if (replacementNode.right != 0x0) {
435                         child = index.nodes[replacementNode.right];
436                         child.parent = parent.id;
437                     }
438                 }
439                 if (parent.right == replacementNode.id) {
440                     parent.right = replacementNode.left;
441                     if (replacementNode.left != 0x0) {
442                         child = index.nodes[replacementNode.left];
443                         child.parent = parent.id;
444                     }
445                 }
446 
447                 // Now we replace the nodeToDelete with the replacementNode.
448                 // This includes parent/child relationships for all of the
449                 // parent, the left child, and the right child.
450                 replacementNode.parent = nodeToDelete.parent;
451                 if (nodeToDelete.parent != 0x0) {
452                     parent = index.nodes[nodeToDelete.parent];
453                     if (parent.left == nodeToDelete.id) {
454                         parent.left = replacementNode.id;
455                     }
456                     if (parent.right == nodeToDelete.id) {
457                         parent.right = replacementNode.id;
458                     }
459                 }
460                 else {
461                     // If the node we are deleting is the root node update the
462                     // index root node pointer.
463                     index.root = replacementNode.id;
464                 }
465 
466                 replacementNode.left = nodeToDelete.left;
467                 if (nodeToDelete.left != 0x0) {
468                     child = index.nodes[nodeToDelete.left];
469                     child.parent = replacementNode.id;
470                 }
471 
472                 replacementNode.right = nodeToDelete.right;
473                 if (nodeToDelete.right != 0x0) {
474                     child = index.nodes[nodeToDelete.right];
475                     child.parent = replacementNode.id;
476                 }
477             }
478             else if (nodeToDelete.parent != 0x0) {
479                 // The node being deleted is a leaf node so we only erase it's
480                 // parent linkage.
481                 parent = index.nodes[nodeToDelete.parent];
482 
483                 if (parent.left == nodeToDelete.id) {
484                     parent.left = 0x0;
485                 }
486                 if (parent.right == nodeToDelete.id) {
487                     parent.right = 0x0;
488                 }
489 
490                 // keep note of where the rebalancing should begin.
491                 rebalanceOrigin = parent.id;
492             }
493             else {
494                 // This is both a leaf node and the root node, so we need to
495                 // unset the root node pointer.
496                 index.root = 0x0;
497             }
498 
499             // Now we zero out all of the fields on the nodeToDelete.
500             nodeToDelete.id = 0x0;
501             nodeToDelete.value = 0;
502             nodeToDelete.parent = 0x0;
503             nodeToDelete.left = 0x0;
504             nodeToDelete.right = 0x0;
505 
506             // Walk back up the tree rebalancing
507             if (rebalanceOrigin != 0x0) {
508                 _rebalanceTree(index, rebalanceOrigin);
509             }
510         }
511 
512         bytes2 constant GT = ">";
513         bytes2 constant LT = "<";
514         bytes2 constant GTE = ">=";
515         bytes2 constant LTE = "<=";
516         bytes2 constant EQ = "==";
517 
518         function _compare(int left, bytes2 operator, int right) internal returns (bool) {
519             if (operator == GT) {
520                 return (left > right);
521             }
522             if (operator == LT) {
523                 return (left < right);
524             }
525             if (operator == GTE) {
526                 return (left >= right);
527             }
528             if (operator == LTE) {
529                 return (left <= right);
530             }
531             if (operator == EQ) {
532                 return (left == right);
533             }
534 
535             // Invalid operator.
536             throw;
537         }
538 
539         function _getMaximum(Index storage index, bytes32 id) internal returns (int) {
540                 Node storage currentNode = index.nodes[id];
541 
542                 while (true) {
543                     if (currentNode.right == 0x0) {
544                         return currentNode.value;
545                     }
546                     currentNode = index.nodes[currentNode.right];
547                 }
548         }
549 
550         function _getMinimum(Index storage index, bytes32 id) internal returns (int) {
551                 Node storage currentNode = index.nodes[id];
552 
553                 while (true) {
554                     if (currentNode.left == 0x0) {
555                         return currentNode.value;
556                     }
557                     currentNode = index.nodes[currentNode.left];
558                 }
559         }
560 
561 
562         /** @dev Query the index for the edge-most node that satisfies the
563          *  given query.  For >, >=, and ==, this will be the left-most node
564          *  that satisfies the comparison.  For < and <= this will be the
565          *  right-most node that satisfies the comparison.
566          */
567         /// @param index The index that should be queried
568         /** @param operator One of '>', '>=', '<', '<=', '==' to specify what
569          *  type of comparison operator should be used.
570          */
571         function query(Index storage index, bytes2 operator, int value) public returns (bytes32) {
572                 bytes32 rootNodeId = index.root;
573                 
574                 if (rootNodeId == 0x0) {
575                     // Empty tree.
576                     return 0x0;
577                 }
578 
579                 Node storage currentNode = index.nodes[rootNodeId];
580 
581                 while (true) {
582                     if (_compare(currentNode.value, operator, value)) {
583                         // We have found a match but it might not be the
584                         // *correct* match.
585                         if ((operator == LT) || (operator == LTE)) {
586                             // Need to keep traversing right until this is no
587                             // longer true.
588                             if (currentNode.right == 0x0) {
589                                 return currentNode.id;
590                             }
591                             if (_compare(_getMinimum(index, currentNode.right), operator, value)) {
592                                 // There are still nodes to the right that
593                                 // match.
594                                 currentNode = index.nodes[currentNode.right];
595                                 continue;
596                             }
597                             return currentNode.id;
598                         }
599 
600                         if ((operator == GT) || (operator == GTE) || (operator == EQ)) {
601                             // Need to keep traversing left until this is no
602                             // longer true.
603                             if (currentNode.left == 0x0) {
604                                 return currentNode.id;
605                             }
606                             if (_compare(_getMaximum(index, currentNode.left), operator, value)) {
607                                 currentNode = index.nodes[currentNode.left];
608                                 continue;
609                             }
610                             return currentNode.id;
611                         }
612                     }
613 
614                     if ((operator == LT) || (operator == LTE)) {
615                         if (currentNode.left == 0x0) {
616                             // There are no nodes that are less than the value
617                             // so return null.
618                             return 0x0;
619                         }
620                         currentNode = index.nodes[currentNode.left];
621                         continue;
622                     }
623 
624                     if ((operator == GT) || (operator == GTE)) {
625                         if (currentNode.right == 0x0) {
626                             // There are no nodes that are greater than the value
627                             // so return null.
628                             return 0x0;
629                         }
630                         currentNode = index.nodes[currentNode.right];
631                         continue;
632                     }
633 
634                     if (operator == EQ) {
635                         if (currentNode.value < value) {
636                             if (currentNode.right == 0x0) {
637                                 return 0x0;
638                             }
639                             currentNode = index.nodes[currentNode.right];
640                             continue;
641                         }
642 
643                         if (currentNode.value > value) {
644                             if (currentNode.left == 0x0) {
645                                 return 0x0;
646                             }
647                             currentNode = index.nodes[currentNode.left];
648                             continue;
649                         }
650                     }
651                 }
652         }
653 
654         function _rebalanceTree(Index storage index, bytes32 id) internal {
655             // Trace back up rebalancing the tree and updating heights as
656             // needed..
657             Node storage currentNode = index.nodes[id];
658 
659             while (true) {
660                 int balanceFactor = _getBalanceFactor(index, currentNode.id);
661 
662                 if (balanceFactor == 2) {
663                     // Right rotation (tree is heavy on the left)
664                     if (_getBalanceFactor(index, currentNode.left) == -1) {
665                         // The subtree is leaning right so it need to be
666                         // rotated left before the current node is rotated
667                         // right.
668                         _rotateLeft(index, currentNode.left);
669                     }
670                     _rotateRight(index, currentNode.id);
671                 }
672 
673                 if (balanceFactor == -2) {
674                     // Left rotation (tree is heavy on the right)
675                     if (_getBalanceFactor(index, currentNode.right) == 1) {
676                         // The subtree is leaning left so it need to be
677                         // rotated right before the current node is rotated
678                         // left.
679                         _rotateRight(index, currentNode.right);
680                     }
681                     _rotateLeft(index, currentNode.id);
682                 }
683 
684                 if ((-1 <= balanceFactor) && (balanceFactor <= 1)) {
685                     _updateNodeHeight(index, currentNode.id);
686                 }
687 
688                 if (currentNode.parent == 0x0) {
689                     // Reached the root which may be new due to tree
690                     // rotation, so set it as the root and then break.
691                     break;
692                 }
693 
694                 currentNode = index.nodes[currentNode.parent];
695             }
696         }
697 
698         function _getBalanceFactor(Index storage index, bytes32 id) internal returns (int) {
699                 Node storage node = index.nodes[id];
700 
701                 return int(index.nodes[node.left].height) - int(index.nodes[node.right].height);
702         }
703 
704         function _updateNodeHeight(Index storage index, bytes32 id) internal {
705                 Node storage node = index.nodes[id];
706 
707                 node.height = max(index.nodes[node.left].height, index.nodes[node.right].height) + 1;
708         }
709 
710         function _rotateLeft(Index storage index, bytes32 id) internal {
711             Node storage originalRoot = index.nodes[id];
712 
713             if (originalRoot.right == 0x0) {
714                 // Cannot rotate left if there is no right originalRoot to rotate into
715                 // place.
716                 throw;
717             }
718 
719             // The right child is the new root, so it gets the original
720             // `originalRoot.parent` as it's parent.
721             Node storage newRoot = index.nodes[originalRoot.right];
722             newRoot.parent = originalRoot.parent;
723 
724             // The original root needs to have it's right child nulled out.
725             originalRoot.right = 0x0;
726 
727             if (originalRoot.parent != 0x0) {
728                 // If there is a parent node, it needs to now point downward at
729                 // the newRoot which is rotating into the place where `node` was.
730                 Node storage parent = index.nodes[originalRoot.parent];
731 
732                 // figure out if we're a left or right child and have the
733                 // parent point to the new node.
734                 if (parent.left == originalRoot.id) {
735                     parent.left = newRoot.id;
736                 }
737                 if (parent.right == originalRoot.id) {
738                     parent.right = newRoot.id;
739                 }
740             }
741 
742 
743             if (newRoot.left != 0) {
744                 // If the new root had a left child, that moves to be the
745                 // new right child of the original root node
746                 Node storage leftChild = index.nodes[newRoot.left];
747                 originalRoot.right = leftChild.id;
748                 leftChild.parent = originalRoot.id;
749             }
750 
751             // Update the newRoot's left node to point at the original node.
752             originalRoot.parent = newRoot.id;
753             newRoot.left = originalRoot.id;
754 
755             if (newRoot.parent == 0x0) {
756                 index.root = newRoot.id;
757             }
758 
759             // TODO: are both of these updates necessary?
760             _updateNodeHeight(index, originalRoot.id);
761             _updateNodeHeight(index, newRoot.id);
762         }
763 
764         function _rotateRight(Index storage index, bytes32 id) internal {
765             Node storage originalRoot = index.nodes[id];
766 
767             if (originalRoot.left == 0x0) {
768                 // Cannot rotate right if there is no left node to rotate into
769                 // place.
770                 throw;
771             }
772 
773             // The left child is taking the place of node, so we update it's
774             // parent to be the original parent of the node.
775             Node storage newRoot = index.nodes[originalRoot.left];
776             newRoot.parent = originalRoot.parent;
777 
778             // Null out the originalRoot.left
779             originalRoot.left = 0x0;
780 
781             if (originalRoot.parent != 0x0) {
782                 // If the node has a parent, update the correct child to point
783                 // at the newRoot now.
784                 Node storage parent = index.nodes[originalRoot.parent];
785 
786                 if (parent.left == originalRoot.id) {
787                     parent.left = newRoot.id;
788                 }
789                 if (parent.right == originalRoot.id) {
790                     parent.right = newRoot.id;
791                 }
792             }
793 
794             if (newRoot.right != 0x0) {
795                 Node storage rightChild = index.nodes[newRoot.right];
796                 originalRoot.left = newRoot.right;
797                 rightChild.parent = originalRoot.id;
798             }
799 
800             // Update the new root's right node to point to the original node.
801             originalRoot.parent = newRoot.id;
802             newRoot.right = originalRoot.id;
803 
804             if (newRoot.parent == 0x0) {
805                 index.root = newRoot.id;
806             }
807 
808             // Recompute heights.
809             _updateNodeHeight(index, originalRoot.id);
810             _updateNodeHeight(index, newRoot.id);
811         }
812 }
813 
814 
815 // Resource Pool v0.1.0 (has been modified from the main released version of this library)
816 
817 
818 // @title ResourcePoolLib - Library for a set of resources that are ready for use.
819 // @author Piper Merriam 
820 library ResourcePoolLib {
821         /*
822          *  Address: 0xd6bbd16eaa6ea3f71a458bffc64c0ca24fc8c58e
823          */
824         struct Pool {
825                 uint rotationDelay;
826                 uint overlapSize;
827                 uint freezePeriod;
828 
829                 uint _id;
830 
831                 GroveLib.Index generationStart;
832                 GroveLib.Index generationEnd;
833 
834                 mapping (uint => Generation) generations;
835                 mapping (address => uint) bonds;
836         }
837 
838         /*
839          * Generations have the following properties.
840          *
841          * 1. Must always overlap by a minimum amount specified by MIN_OVERLAP.
842          *
843          *    1   2   3   4   5   6   7   8   9   10  11  12  13
844          *    [1:-----------------]
845          *                [4:--------------------->
846          */
847         struct Generation {
848                 uint id;
849                 uint startAt;
850                 uint endAt;
851                 address[] members;
852         }
853 
854         /// @dev Creates the next generation for the given pool.  All members from the current generation are carried over (with their order randomized).  The current generation will have it's endAt block set.
855         /// @param self The pool to operate on.
856         function createNextGeneration(Pool storage self) public returns (uint) {
857                 /*
858                  *  Creat a new pool generation with all of the current
859                  *  generation's members copied over in random order.
860                  */
861                 Generation storage previousGeneration = self.generations[self._id];
862 
863                 self._id += 1;
864                 Generation storage nextGeneration = self.generations[self._id];
865                 nextGeneration.id = self._id;
866                 nextGeneration.startAt = block.number + self.freezePeriod + self.rotationDelay;
867                 GroveLib.insert(self.generationStart, StringLib.uintToBytes(nextGeneration.id), int(nextGeneration.startAt));
868 
869                 if (previousGeneration.id == 0) {
870                         // This is the first generation so we just need to set
871                         // it's `id` and `startAt`.
872                         return nextGeneration.id;
873                 }
874 
875                 // Set the end date for the current generation.
876                 previousGeneration.endAt = block.number + self.freezePeriod + self.rotationDelay + self.overlapSize;
877                 GroveLib.insert(self.generationEnd, StringLib.uintToBytes(previousGeneration.id), int(previousGeneration.endAt));
878 
879                 // Now we copy the members of the previous generation over to
880                 // the next generation as well as randomizing their order.
881                 address[] memory members = previousGeneration.members;
882 
883                 for (uint i = 0; i < members.length; i++) {
884                     // Pick a *random* index and push it onto the next
885                     // generation's members.
886                     uint index = uint(sha3(block.blockhash(block.number))) % (members.length - nextGeneration.members.length);
887                     nextGeneration.members.length += 1;
888                     nextGeneration.members[nextGeneration.members.length - 1] = members[index];
889 
890                     // Then move the member at the last index into the picked
891                     // index's location.
892                     members[index] = members[members.length - 1];
893                 }
894 
895                 return nextGeneration.id;
896         }
897 
898         /// @dev Returns the first generation id that fully contains the block window provided.
899         /// @param self The pool to operate on.
900         /// @param leftBound The left bound for the block window (inclusive)
901         /// @param rightBound The right bound for the block window (inclusive)
902         function getGenerationForWindow(Pool storage self, uint leftBound, uint rightBound) constant returns (uint) {
903             // TODO: tests
904                 var left = GroveLib.query(self.generationStart, "<=", int(leftBound));
905 
906                 if (left != 0x0) {
907                     Generation memory leftCandidate = self.generations[StringLib.bytesToUInt(left)];
908                     if (leftCandidate.startAt <= leftBound && (leftCandidate.endAt >= rightBound || leftCandidate.endAt == 0)) {
909                         return leftCandidate.id;
910                     }
911                 }
912 
913                 var right = GroveLib.query(self.generationEnd, ">=", int(rightBound));
914                 if (right != 0x0) {
915                     Generation memory rightCandidate = self.generations[StringLib.bytesToUInt(right)];
916                     if (rightCandidate.startAt <= leftBound && (rightCandidate.endAt >= rightBound || rightCandidate.endAt == 0)) {
917                         return rightCandidate.id;
918                     }
919                 }
920 
921                 return 0;
922         }
923 
924         /// @dev Returns the first generation in the future that has not yet started.
925         /// @param self The pool to operate on.
926         function getNextGenerationId(Pool storage self) constant returns (uint) {
927             // TODO: tests
928                 var next = GroveLib.query(self.generationStart, ">", int(block.number));
929                 if (next == 0x0) {
930                     return 0;
931                 }
932                 return StringLib.bytesToUInt(next);
933         }
934 
935         /// @dev Returns the first generation that is currently active.
936         /// @param self The pool to operate on.
937         function getCurrentGenerationId(Pool storage self) constant returns (uint) {
938             // TODO: tests
939                 var next = GroveLib.query(self.generationEnd, ">", int(block.number));
940                 if (next != 0x0) {
941                     return StringLib.bytesToUInt(next);
942                 }
943 
944                 next = GroveLib.query(self.generationStart, "<=", int(block.number));
945                 if (next != 0x0) {
946                     return StringLib.bytesToUInt(next);
947                 }
948                 return 0;
949         }
950 
951         /*
952          *  Pool membership API
953          */
954         /// @dev Returns a boolean for whether the given address is in the given generation.
955         /// @param self The pool to operate on.
956         /// @param resourceAddress The address to check membership of
957         /// @param generationId The id of the generation to check.
958         function isInGeneration(Pool storage self, address resourceAddress, uint generationId) constant returns (bool) {
959             // TODO: tests
960             if (generationId == 0) {
961                 return false;
962             }
963             Generation memory generation = self.generations[generationId];
964             for (uint i = 0; i < generation.members.length; i++) {
965                 if (generation.members[i] == resourceAddress) {
966                     return true;
967                 }
968             }
969             return false;
970         }
971 
972         /// @dev Returns a boolean for whether the given address is in the current generation.
973         /// @param self The pool to operate on.
974         /// @param resourceAddress The address to check membership of
975         function isInCurrentGeneration(Pool storage self, address resourceAddress) constant returns (bool) {
976             // TODO: tests
977             return isInGeneration(self, resourceAddress, getCurrentGenerationId(self));
978         }
979 
980         /// @dev Returns a boolean for whether the given address is in the next queued generation.
981         /// @param self The pool to operate on.
982         /// @param resourceAddress The address to check membership of
983         function isInNextGeneration(Pool storage self, address resourceAddress) constant returns (bool) {
984             // TODO: tests
985             return isInGeneration(self, resourceAddress, getNextGenerationId(self));
986         }
987 
988         /// @dev Returns a boolean for whether the given address is in either the current generation or the next queued generation.
989         /// @param self The pool to operate on.
990         /// @param resourceAddress The address to check membership of
991         function isInPool(Pool storage self, address resourceAddress) constant returns (bool) {
992             // TODO: tests
993             return (isInCurrentGeneration(self, resourceAddress) || isInNextGeneration(self, resourceAddress));
994         }
995 
996         event _AddedToGeneration(address indexed resourceAddress, uint indexed generationId);
997         /// @dev Function to expose the _AddedToGeneration event to contracts.
998         /// @param resourceAddress The address that was added
999         /// @param generationId The id of the generation.
1000         function AddedToGeneration(address resourceAddress, uint generationId) public {
1001                 _AddedToGeneration(resourceAddress, generationId);
1002         }
1003 
1004         event _RemovedFromGeneration(address indexed resourceAddress, uint indexed generationId);
1005         /// @dev Function to expose the _AddedToGeneration event to contracts.
1006         /// @param resourceAddress The address that was removed.
1007         /// @param generationId The id of the generation.
1008         function RemovedFromGeneration(address resourceAddress, uint generationId) public {
1009                 _RemovedFromGeneration(resourceAddress, generationId);
1010         }
1011 
1012         /// @dev Returns a boolean as to whether the provided address is allowed to enter the pool at this time.
1013         /// @param self The pool to operate on.
1014         /// @param resourceAddress The address in question
1015         /// @param minimumBond The minimum bond amount that should be required for entry.
1016         function canEnterPool(Pool storage self, address resourceAddress, uint minimumBond) constant returns (bool) {
1017             /*
1018              *  - bond
1019              *  - pool is open
1020              *  - not already in it.
1021              *  - not already left it.
1022              */
1023             // TODO: tests
1024             if (self.bonds[resourceAddress] < minimumBond) {
1025                 // Insufficient bond balance;
1026                 return false;
1027             }
1028 
1029             if (isInPool(self, resourceAddress)) {
1030                 // Already in the pool either in the next upcoming generation
1031                 // or the currently active generation.
1032                 return false;
1033             }
1034 
1035             var nextGenerationId = getNextGenerationId(self);
1036             if (nextGenerationId != 0) {
1037                 var nextGeneration = self.generations[nextGenerationId];
1038                 if (block.number + self.freezePeriod >= nextGeneration.startAt) {
1039                     // Next generation starts too soon.
1040                     return false;
1041                 }
1042             }
1043 
1044             return true;
1045         }
1046 
1047         /// @dev Adds the address to pool by adding them to the next generation (as well as creating it if it doesn't exist).
1048         /// @param self The pool to operate on.
1049         /// @param resourceAddress The address to be added to the pool
1050         /// @param minimumBond The minimum bond amount that should be required for entry.
1051         function enterPool(Pool storage self, address resourceAddress, uint minimumBond) public returns (uint) {
1052             if (!canEnterPool(self, resourceAddress, minimumBond)) {
1053                 throw;
1054             }
1055             uint nextGenerationId = getNextGenerationId(self);
1056             if (nextGenerationId == 0) {
1057                 // No next generation has formed yet so create it.
1058                 nextGenerationId = createNextGeneration(self);
1059             }
1060             Generation storage nextGeneration = self.generations[nextGenerationId];
1061             // now add the new address.
1062             nextGeneration.members.length += 1;
1063             nextGeneration.members[nextGeneration.members.length - 1] = resourceAddress;
1064             return nextGenerationId;
1065         }
1066 
1067         /// @dev Returns a boolean as to whether the provided address is allowed to exit the pool at this time.
1068         /// @param self The pool to operate on.
1069         /// @param resourceAddress The address in question
1070         function canExitPool(Pool storage self, address resourceAddress) constant returns (bool) {
1071             if (!isInCurrentGeneration(self, resourceAddress)) {
1072                 // Not in the pool.
1073                 return false;
1074             }
1075 
1076             uint nextGenerationId = getNextGenerationId(self);
1077             if (nextGenerationId == 0) {
1078                 // Next generation hasn't been generated yet.
1079                 return true;
1080             }
1081 
1082             if (self.generations[nextGenerationId].startAt - self.freezePeriod <= block.number) {
1083                 // Next generation starts too soon.
1084                 return false;
1085             }
1086 
1087             // They can leave if they are still in the next generation.
1088             // otherwise they have already left it.
1089             return isInNextGeneration(self, resourceAddress);
1090         }
1091 
1092 
1093         /// @dev Removes the address from the pool by removing them from the next generation (as well as creating it if it doesn't exist)
1094         /// @param self The pool to operate on.
1095         /// @param resourceAddress The address in question
1096         function exitPool(Pool storage self, address resourceAddress) public returns (uint) {
1097             if (!canExitPool(self, resourceAddress)) {
1098                 throw;
1099             }
1100             uint nextGenerationId = getNextGenerationId(self);
1101             if (nextGenerationId == 0) {
1102                 // No next generation has formed yet so create it.
1103                 nextGenerationId = createNextGeneration(self);
1104             }
1105             // Remove them from the generation
1106             removeFromGeneration(self, nextGenerationId, resourceAddress);
1107             return nextGenerationId;
1108         }
1109 
1110         /// @dev Removes the address from a generation's members array. Returns boolean as to whether removal was successful.
1111         /// @param self The pool to operate on.
1112         /// @param generationId The id of the generation to operate on.
1113         /// @param resourceAddress The address to be removed.
1114         function removeFromGeneration(Pool storage self, uint generationId, address resourceAddress) public returns (bool){
1115             Generation storage generation = self.generations[generationId];
1116             // now remove the address
1117             for (uint i = 0; i < generation.members.length; i++) {
1118                 if (generation.members[i] == resourceAddress) {
1119                     generation.members[i] = generation.members[generation.members.length - 1];
1120                     generation.members.length -= 1;
1121                     return true;
1122                 }
1123             }
1124             return false;
1125         }
1126 
1127         /*
1128          *  Bonding
1129          */
1130 
1131         /// @dev Subtracts the amount from an account's bond balance.
1132         /// @param self The pool to operate on.
1133         /// @param resourceAddress The address of the account
1134         /// @param value The value to subtract.
1135         function deductFromBond(Pool storage self, address resourceAddress, uint value) public {
1136                 /*
1137                  *  deduct funds from a bond value without risk of an
1138                  *  underflow.
1139                  */
1140                 if (value > self.bonds[resourceAddress]) {
1141                         // Prevent Underflow.
1142                         throw;
1143                 }
1144                 self.bonds[resourceAddress] -= value;
1145         }
1146 
1147         /// @dev Adds the amount to an account's bond balance.
1148         /// @param self The pool to operate on.
1149         /// @param resourceAddress The address of the account
1150         /// @param value The value to add.
1151         function addToBond(Pool storage self, address resourceAddress, uint value) public {
1152                 /*
1153                  *  Add funds to a bond value without risk of an
1154                  *  overflow.
1155                  */
1156                 if (self.bonds[resourceAddress] + value < self.bonds[resourceAddress]) {
1157                         // Prevent Overflow
1158                         throw;
1159                 }
1160                 self.bonds[resourceAddress] += value;
1161         }
1162 
1163         /// @dev Withdraws a bond amount from an address's bond account, sending them the corresponding amount in ether.
1164         /// @param self The pool to operate on.
1165         /// @param resourceAddress The address of the account
1166         /// @param value The value to withdraw.
1167         function withdrawBond(Pool storage self, address resourceAddress, uint value, uint minimumBond) public {
1168                 /*
1169                  *  Only if you are not in either of the current call pools.
1170                  */
1171                 // Prevent underflow
1172                 if (value > self.bonds[resourceAddress]) {
1173                         throw;
1174                 }
1175 
1176                 // Do a permissions check to be sure they can withdraw the
1177                 // funds.
1178                 if (isInPool(self, resourceAddress)) {
1179                         if (self.bonds[resourceAddress] - value < minimumBond) {
1180                             return;
1181                         }
1182                 }
1183 
1184                 deductFromBond(self, resourceAddress, value);
1185                 if (!resourceAddress.send(value)) {
1186                         // Potentially sending money to a contract that
1187                         // has a fallback function.  So instead, try
1188                         // tranferring the funds with the call api.
1189                         if (!resourceAddress.call.gas(msg.gas).value(value)()) {
1190                                 // Revert the entire transaction.  No
1191                                 // need to destroy the funds.
1192                                 throw;
1193                         }
1194                 }
1195         }
1196 }
1197 
1198 
1199 contract Relay {
1200         address operator;
1201 
1202         function Relay() {
1203                 operator = msg.sender;
1204         }
1205 
1206         function relayCall(address contractAddress, bytes4 abiSignature, bytes data) public returns (bool) {
1207                 if (msg.sender != operator) {
1208                         throw;
1209                 }
1210                 return contractAddress.call(abiSignature, data);
1211         }
1212 }
1213 
1214 
1215 
1216 
1217 library ScheduledCallLib {
1218     /*
1219      *  Address: 0x5c3623dcef2d5168dbe3e8cc538788cd8912d898
1220      */
1221     struct CallDatabase {
1222         Relay unauthorizedRelay;
1223         Relay authorizedRelay;
1224 
1225         bytes32 lastCallKey;
1226         bytes lastData;
1227         uint lastDataLength;
1228         bytes32 lastDataHash;
1229 
1230         ResourcePoolLib.Pool callerPool;
1231         GroveLib.Index callIndex;
1232 
1233         AccountingLib.Bank gasBank;
1234 
1235         mapping (bytes32 => Call) calls;
1236         mapping (bytes32 => bytes) data_registry;
1237 
1238         mapping (bytes32 => bool) accountAuthorizations;
1239     }
1240 
1241     struct Call {
1242             address contractAddress;
1243             address scheduledBy;
1244             uint calledAtBlock;
1245             uint targetBlock;
1246             uint8 gracePeriod;
1247             uint nonce;
1248             uint baseGasPrice;
1249             uint gasPrice;
1250             uint gasUsed;
1251             uint gasCost;
1252             uint payout;
1253             uint fee;
1254             address executedBy;
1255             bytes4 abiSignature;
1256             bool isCancelled;
1257             bool wasCalled;
1258             bool wasSuccessful;
1259             bytes32 dataHash;
1260     }
1261 
1262     // The author (Piper Merriam) address.
1263     address constant owner = 0xd3cda913deb6f67967b99d67acdfa1712c293601;
1264 
1265     /*
1266      *  Getter methods for `Call` information
1267      */
1268     function getCallContractAddress(CallDatabase storage self, bytes32 callKey) constant returns (address) {
1269             return self.calls[callKey].contractAddress;
1270     }
1271 
1272     function getCallScheduledBy(CallDatabase storage self, bytes32 callKey) constant returns (address) {
1273             return self.calls[callKey].scheduledBy;
1274     }
1275 
1276     function getCallCalledAtBlock(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1277             return self.calls[callKey].calledAtBlock;
1278     }
1279 
1280     function getCallGracePeriod(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1281             return self.calls[callKey].gracePeriod;
1282     }
1283 
1284     function getCallTargetBlock(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1285             return self.calls[callKey].targetBlock;
1286     }
1287 
1288     function getCallBaseGasPrice(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1289             return self.calls[callKey].baseGasPrice;
1290     }
1291 
1292     function getCallGasPrice(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1293             return self.calls[callKey].gasPrice;
1294     }
1295 
1296     function getCallGasUsed(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1297             return self.calls[callKey].gasUsed;
1298     }
1299 
1300     function getCallABISignature(CallDatabase storage self, bytes32 callKey) constant returns (bytes4) {
1301             return self.calls[callKey].abiSignature;
1302     }
1303 
1304     function checkIfCalled(CallDatabase storage self, bytes32 callKey) constant returns (bool) {
1305             return self.calls[callKey].wasCalled;
1306     }
1307 
1308     function checkIfSuccess(CallDatabase storage self, bytes32 callKey) constant returns (bool) {
1309             return self.calls[callKey].wasSuccessful;
1310     }
1311 
1312     function checkIfCancelled(CallDatabase storage self, bytes32 callKey) constant returns (bool) {
1313             return self.calls[callKey].isCancelled;
1314     }
1315 
1316     function getCallDataHash(CallDatabase storage self, bytes32 callKey) constant returns (bytes32) {
1317             return self.calls[callKey].dataHash;
1318     }
1319 
1320     function getCallPayout(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1321             return self.calls[callKey].payout;
1322     }
1323 
1324     function getCallFee(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1325             return self.calls[callKey].fee;
1326     }
1327 
1328     /*
1329      *  Scheduling Authorization API
1330      */
1331 
1332     function addAuthorization(CallDatabase storage self, address schedulerAddress, address contractAddress) public {
1333             self.accountAuthorizations[sha3(schedulerAddress, contractAddress)] = true;
1334     }
1335 
1336     function removeAuthorization(CallDatabase storage self, address schedulerAddress, address contractAddress) public {
1337             self.accountAuthorizations[sha3(schedulerAddress, contractAddress)] = false;
1338     }
1339 
1340     function checkAuthorization(CallDatabase storage self, address schedulerAddress, address contractAddress) constant returns (bool) {
1341             return self.accountAuthorizations[sha3(schedulerAddress, contractAddress)];
1342     }
1343 
1344     /*
1345      *  Data Registry API
1346      */
1347     function getCallData(CallDatabase storage self, bytes32 callKey) constant returns (bytes) {
1348             return self.data_registry[self.calls[callKey].dataHash];
1349     }
1350 
1351     /*
1352      *  API used by Alarm service
1353      */
1354     // The number of blocks that each caller in the pool has to complete their
1355     // call.
1356     uint constant CALL_WINDOW_SIZE = 16;
1357 
1358     function getGenerationIdForCall(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1359             Call call = self.calls[callKey];
1360             return ResourcePoolLib.getGenerationForWindow(self.callerPool, call.targetBlock, call.targetBlock + call.gracePeriod);
1361     }
1362 
1363     function getDesignatedCaller(CallDatabase storage self, bytes32 callKey, uint blockNumber) constant returns (address) {
1364             /*
1365              *  Returns the caller from the current call pool who is
1366              *  designated as the executor of this call.
1367              */
1368             Call call = self.calls[callKey];
1369             if (blockNumber < call.targetBlock || blockNumber > call.targetBlock + call.gracePeriod) {
1370                     // blockNumber not within call window.
1371                     return 0x0;
1372             }
1373 
1374             // Check if we are in free-for-all window.
1375             uint numWindows = call.gracePeriod / CALL_WINDOW_SIZE;
1376             uint blockWindow = (blockNumber - call.targetBlock) / CALL_WINDOW_SIZE;
1377 
1378             if (blockWindow + 2 > numWindows) {
1379                     // We are within the free-for-all period.
1380                     return 0x0;
1381             }
1382 
1383             // Lookup the pool that full contains the call window for this
1384             // call.
1385             uint generationId = ResourcePoolLib.getGenerationForWindow(self.callerPool, call.targetBlock, call.targetBlock + call.gracePeriod);
1386             if (generationId == 0) {
1387                     // No pool currently in operation.
1388                     return 0x0;
1389             }
1390             var generation = self.callerPool.generations[generationId];
1391 
1392             uint offset = uint(callKey) % generation.members.length;
1393             return generation.members[(offset + blockWindow) % generation.members.length];
1394     }
1395 
1396     event _AwardedMissedBlockBonus(address indexed fromCaller, address indexed toCaller, uint indexed generationId, bytes32 callKey, uint blockNumber, uint bonusAmount);
1397     function AwardedMissedBlockBonus(address fromCaller, address toCaller, uint generationId, bytes32 callKey, uint blockNumber, uint bonusAmount) public {
1398         _AwardedMissedBlockBonus(fromCaller, toCaller, generationId, callKey, blockNumber, bonusAmount);
1399     }
1400 
1401     function getMinimumBond() constant returns (uint) {
1402             return tx.gasprice * block.gaslimit;
1403     }
1404 
1405     function doBondBonusTransfer(CallDatabase storage self, address fromCaller, address toCaller) internal returns (uint) {
1406             uint bonusAmount = getMinimumBond();
1407             uint bondBalance = self.callerPool.bonds[fromCaller];
1408 
1409             // If the bond balance is lower than the award
1410             // balance, then adjust the reward amount to
1411             // match the bond balance.
1412             if (bonusAmount > bondBalance) {
1413                     bonusAmount = bondBalance;
1414             }
1415 
1416             // Transfer the funds fromCaller => toCaller
1417             ResourcePoolLib.deductFromBond(self.callerPool, fromCaller, bonusAmount);
1418             ResourcePoolLib.addToBond(self.callerPool, toCaller, bonusAmount);
1419 
1420             return bonusAmount;
1421     }
1422 
1423     function awardMissedBlockBonus(CallDatabase storage self, address toCaller, bytes32 callKey) public {
1424             var call = self.calls[callKey];
1425 
1426             var generation = self.callerPool.generations[ResourcePoolLib.getGenerationForWindow(self.callerPool, call.targetBlock, call.targetBlock + call.gracePeriod)];
1427             uint i;
1428             uint bonusAmount;
1429             address fromCaller;
1430 
1431             uint numWindows = call.gracePeriod / CALL_WINDOW_SIZE;
1432             uint blockWindow = (block.number - call.targetBlock) / CALL_WINDOW_SIZE;
1433 
1434             // Check if we are within the free-for-all period.  If so, we
1435             // award from all pool members.
1436             if (blockWindow + 2 > numWindows) {
1437                     address firstCaller = getDesignatedCaller(self, callKey, call.targetBlock);
1438                     for (i = call.targetBlock; i <= call.targetBlock + call.gracePeriod; i += CALL_WINDOW_SIZE) {
1439                             fromCaller = getDesignatedCaller(self, callKey, i);
1440                             if (fromCaller == firstCaller && i != call.targetBlock) {
1441                                     // We have already gone through all of
1442                                     // the pool callers so we should break
1443                                     // out of the loop.
1444                                     break;
1445                             }
1446                             if (fromCaller == toCaller) {
1447                                     continue;
1448                             }
1449                             bonusAmount = doBondBonusTransfer(self, fromCaller, toCaller);
1450 
1451                             // Log the bonus was awarded.
1452                             AwardedMissedBlockBonus(fromCaller, toCaller, generation.id, callKey, block.number, bonusAmount);
1453                     }
1454                     return;
1455             }
1456 
1457             // Special case for single member and empty pools
1458             if (generation.members.length < 2) {
1459                     return;
1460             }
1461 
1462             // Otherwise the award comes from the previous caller.
1463             for (i = 0; i < generation.members.length; i++) {
1464                     // Find where the member is in the pool and
1465                     // award from the previous pool members bond.
1466                     if (generation.members[i] == toCaller) {
1467                             fromCaller = generation.members[(i + generation.members.length - 1) % generation.members.length];
1468 
1469                             bonusAmount = doBondBonusTransfer(self, fromCaller, toCaller);
1470 
1471                             // Log the bonus was awarded.
1472                             AwardedMissedBlockBonus(fromCaller, toCaller, generation.id, callKey, block.number, bonusAmount);
1473 
1474                             // Remove the caller from the next pool.
1475                             if (ResourcePoolLib.getNextGenerationId(self.callerPool) == 0) {
1476                                     // This is the first address to modify the
1477                                     // current pool so we need to setup the next
1478                                     // pool.
1479                                     ResourcePoolLib.createNextGeneration(self.callerPool);
1480                             }
1481                             ResourcePoolLib.removeFromGeneration(self.callerPool, ResourcePoolLib.getNextGenerationId(self.callerPool), fromCaller);
1482                             return;
1483                     }
1484             }
1485     }
1486 
1487     /*
1488      *  Data registration API
1489      */
1490     event _DataRegistered(bytes32 indexed dataHash);
1491     function DataRegistered(bytes32 dataHash) constant {
1492         _DataRegistered(dataHash);
1493     }
1494 
1495     function registerData(CallDatabase storage self, bytes data) public {
1496             self.lastData.length = data.length - 4;
1497             if (data.length > 4) {
1498                     for (uint i = 0; i < self.lastData.length; i++) {
1499                             self.lastData[i] = data[i + 4];
1500                     }
1501             }
1502             self.data_registry[sha3(self.lastData)] = self.lastData;
1503             self.lastDataHash = sha3(self.lastData);
1504             self.lastDataLength = self.lastData.length;
1505     }
1506 
1507     /*
1508      *  Call execution API
1509      */
1510     // This number represents the constant gas cost of the addition
1511     // operations that occur in `doCall` that cannot be tracked with
1512     // msg.gas.
1513     uint constant EXTRA_CALL_GAS = 153321;
1514 
1515     // This number represents the overall overhead involved in executing a
1516     // scheduled call.
1517     uint constant CALL_OVERHEAD = 120104;
1518 
1519     event _CallExecuted(address indexed executedBy, bytes32 indexed callKey);
1520     function CallExecuted(address executedBy, bytes32 callKey) public {
1521         _CallExecuted(executedBy, callKey);
1522     }
1523     event _CallAborted(address indexed executedBy, bytes32 indexed callKey, bytes18 reason);
1524     function CallAborted(address executedBy, bytes32 callKey, bytes18 reason) public {
1525         _CallAborted(executedBy, callKey, reason);
1526     }
1527 
1528     function doCall(CallDatabase storage self, bytes32 callKey, address msgSender) public {
1529             uint gasBefore = msg.gas;
1530 
1531             Call storage call = self.calls[callKey];
1532 
1533             if (call.wasCalled) {
1534                     // The call has already been executed so don't do it again.
1535                     _CallAborted(msg.sender, callKey, "ALREADY CALLED");
1536                     return;
1537             }
1538 
1539             if (call.isCancelled) {
1540                     // The call was cancelled so don't execute it.
1541                     _CallAborted(msg.sender, callKey, "CANCELLED");
1542                     return;
1543             }
1544 
1545             if (call.contractAddress == 0x0) {
1546                     // This call key doesnt map to a registered call.
1547                     _CallAborted(msg.sender, callKey, "UNKNOWN");
1548                     return;
1549             }
1550 
1551             if (block.number < call.targetBlock) {
1552                     // Target block hasnt happened yet.
1553                     _CallAborted(msg.sender, callKey, "TOO EARLY");
1554                     return;
1555             }
1556 
1557             if (block.number > call.targetBlock + call.gracePeriod) {
1558                     // The blockchain has advanced passed the period where
1559                     // it was allowed to be called.
1560                     _CallAborted(msg.sender, callKey, "TOO LATE");
1561                     return;
1562             }
1563 
1564             uint heldBalance = getCallMaxCost(self, callKey);
1565 
1566             if (self.gasBank.accountBalances[call.scheduledBy] < heldBalance) {
1567                     // The scheduledBy's account balance is less than the
1568                     // current gasLimit and thus potentiall can't pay for
1569                     // the call.
1570 
1571                     // Mark it as called since it was.
1572                     call.wasCalled = true;
1573                     
1574                     // Log it.
1575                     _CallAborted(msg.sender, callKey, "INSUFFICIENT_FUNDS");
1576                     return;
1577             }
1578 
1579             // Check if this caller is allowed to execute the call.
1580             if (self.callerPool.generations[ResourcePoolLib.getCurrentGenerationId(self.callerPool)].members.length > 0) {
1581                     address designatedCaller = getDesignatedCaller(self, callKey, block.number);
1582                     if (designatedCaller != 0x0 && designatedCaller != msgSender) {
1583                             // This call was reserved for someone from the
1584                             // bonded pool of callers and can only be
1585                             // called by them during this block window.
1586                             _CallAborted(msg.sender, callKey, "WRONG_CALLER");
1587                             return;
1588                     }
1589 
1590                     uint blockWindow = (block.number - call.targetBlock) / CALL_WINDOW_SIZE;
1591                     if (blockWindow > 0) {
1592                             // Someone missed their call so this caller
1593                             // gets to claim their bond for picking up
1594                             // their slack.
1595                             awardMissedBlockBonus(self, msgSender, callKey);
1596                     }
1597             }
1598 
1599             // Log metadata about the call.
1600             call.gasPrice = tx.gasprice;
1601             call.executedBy = msgSender;
1602             call.calledAtBlock = block.number;
1603 
1604             // Fetch the call data
1605             var data = self.data_registry[call.dataHash];
1606 
1607             // During the call, we need to put enough funds to pay for the
1608             // call on hold to ensure they are available to pay the caller.
1609             AccountingLib.withdraw(self.gasBank, call.scheduledBy, heldBalance);
1610 
1611             // Mark whether the function call was successful.
1612             if (checkAuthorization(self, call.scheduledBy, call.contractAddress)) {
1613                     call.wasSuccessful = self.authorizedRelay.relayCall.gas(msg.gas - CALL_OVERHEAD)(call.contractAddress, call.abiSignature, data);
1614             }
1615             else {
1616                     call.wasSuccessful = self.unauthorizedRelay.relayCall.gas(msg.gas - CALL_OVERHEAD)(call.contractAddress, call.abiSignature, data);
1617             }
1618 
1619             // Add the held funds back into the scheduler's account.
1620             AccountingLib.deposit(self.gasBank, call.scheduledBy, heldBalance);
1621 
1622             // Mark the call as having been executed.
1623             call.wasCalled = true;
1624 
1625             // Compute the scalar (0 - 200) for the fee.
1626             uint feeScalar = getCallFeeScalar(call.baseGasPrice, call.gasPrice);
1627 
1628             // Log how much gas this call used.  EXTRA_CALL_GAS is a fixed
1629             // amount that represents the gas usage of the commands that
1630             // happen after this line.
1631             call.gasUsed = (gasBefore - msg.gas + EXTRA_CALL_GAS);
1632             call.gasCost = call.gasUsed * call.gasPrice;
1633 
1634             // Now we need to pay the caller as well as keep fee.
1635             // callerPayout -> call cost + 1%
1636             // fee -> 1% of callerPayout
1637             call.payout = call.gasCost * feeScalar * 101 / 10000;
1638             call.fee = call.gasCost * feeScalar / 10000;
1639 
1640             AccountingLib.deductFunds(self.gasBank, call.scheduledBy, call.payout + call.fee);
1641 
1642             AccountingLib.addFunds(self.gasBank, msgSender, call.payout);
1643             AccountingLib.addFunds(self.gasBank, owner, call.fee);
1644     }
1645 
1646     function getCallMaxCost(CallDatabase storage self, bytes32 callKey) constant returns (uint) {
1647             /*
1648              *  tx.gasprice * block.gaslimit
1649              *  
1650              */
1651             // call cost + 2%
1652             var call = self.calls[callKey];
1653 
1654             uint gasCost = tx.gasprice * block.gaslimit;
1655             uint feeScalar = getCallFeeScalar(call.baseGasPrice, tx.gasprice);
1656 
1657             return gasCost * feeScalar * 102 / 10000;
1658     }
1659 
1660     function getCallFeeScalar(uint baseGasPrice, uint gasPrice) constant returns (uint) {
1661             /*
1662              *  Return a number between 0 - 200 to scale the fee based on
1663              *  the gas price set for the calling transaction as compared
1664              *  to the gas price of the scheduling transaction.
1665              *
1666              *  - number approaches zero as the transaction gas price goes
1667              *  above the gas price recorded when the call was scheduled.
1668              *
1669              *  - the number approaches 200 as the transaction gas price
1670              *  drops under the price recorded when the call was scheduled.
1671              *
1672              *  This encourages lower gas costs as the lower the gas price
1673              *  for the executing transaction, the higher the payout to the
1674              *  caller.
1675              */
1676             if (gasPrice > baseGasPrice) {
1677                     return 100 * baseGasPrice / gasPrice;
1678             }
1679             else {
1680                     return 200 - 100 * baseGasPrice / (2 * baseGasPrice - gasPrice);
1681             }
1682     }
1683 
1684     /*
1685      *  Call Scheduling API
1686      */
1687 
1688     // The result of `sha()` so that we can validate that people aren't
1689     // looking up call data that failed to register.
1690     bytes32 constant emptyDataHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1691 
1692     function computeCallKey(address scheduledBy, address contractAddress, bytes4 abiSignature, bytes32 dataHash, uint targetBlock, uint8 gracePeriod, uint nonce) constant returns (bytes32) {
1693             return sha3(scheduledBy, contractAddress, abiSignature, dataHash, targetBlock, gracePeriod, nonce);
1694     }
1695 
1696     // Ten minutes into the future.
1697     uint constant MAX_BLOCKS_IN_FUTURE = 40;
1698 
1699     event _CallScheduled(bytes32 indexed callKey);
1700     function CallScheduled(bytes32 callKey) public {
1701         _CallScheduled(callKey);
1702     }
1703     event _CallRejected(bytes32 indexed callKey, bytes15 reason);
1704     function CallRejected(bytes32 callKey, bytes15 reason) public {
1705         _CallRejected(callKey, reason);
1706     }
1707 
1708     function getCallWindowSize() public returns (uint) {
1709         return CALL_WINDOW_SIZE;
1710     }
1711 
1712     function getMinimumGracePeriod() public returns (uint) {
1713         return 4 * CALL_WINDOW_SIZE;
1714     }
1715 
1716     function scheduleCall(CallDatabase storage self, address schedulerAddress, address contractAddress, bytes4 abiSignature, bytes32 dataHash, uint targetBlock, uint8 gracePeriod, uint nonce) public returns (bytes15) {
1717             /*
1718              * Primary API for scheduling a call.  Prior to calling this
1719              * the data should already have been registered through the
1720              * `registerData` API.
1721              */
1722             bytes32 callKey = computeCallKey(schedulerAddress, contractAddress, abiSignature, dataHash, targetBlock, gracePeriod, nonce);
1723 
1724             if (dataHash != emptyDataHash && self.data_registry[dataHash].length == 0) {
1725                     // Don't allow registering calls if the data hash has
1726                     // not actually been registered.  The only exception is
1727                     // the *emptyDataHash*.
1728                     return "NO_DATA";
1729             }
1730 
1731             if (targetBlock < block.number + MAX_BLOCKS_IN_FUTURE) {
1732                     // Don't allow scheduling further than
1733                     // MAX_BLOCKS_IN_FUTURE
1734                     return "TOO_SOON";
1735             }
1736             Call storage call = self.calls[callKey];
1737 
1738             if (call.contractAddress != 0x0) {
1739                     return "DUPLICATE";
1740             }
1741 
1742             if (gracePeriod < getMinimumGracePeriod()) {
1743                     return "GRACE_TOO_SHORT";
1744             }
1745 
1746             self.lastCallKey = callKey;
1747 
1748             call.contractAddress = contractAddress;
1749             call.scheduledBy = schedulerAddress;
1750             call.nonce = nonce;
1751             call.abiSignature = abiSignature;
1752             call.dataHash = dataHash;
1753             call.targetBlock = targetBlock;
1754             call.gracePeriod = gracePeriod;
1755             call.baseGasPrice = tx.gasprice;
1756 
1757             // Put the call into the grove index.
1758             GroveLib.insert(self.callIndex, callKey, int(call.targetBlock));
1759 
1760             return 0x0;
1761     }
1762 
1763     event _CallCancelled(bytes32 indexed callKey);
1764     function CallCancelled(bytes32 callKey) public {
1765         _CallCancelled(callKey);
1766     }
1767 
1768     // Two minutes
1769     uint constant MIN_CANCEL_WINDOW = 8;
1770 
1771     function cancelCall(CallDatabase storage self, bytes32 callKey, address msgSender) public returns (bool) {
1772             Call storage call = self.calls[callKey];
1773             if (call.scheduledBy != msgSender) {
1774                     // Nobody but the scheduler can cancel a call.
1775                     return false;
1776             }
1777             if (call.wasCalled) {
1778                     // No need to cancel a call that already was executed.
1779                     return false;
1780             }
1781             if (call.targetBlock - MIN_CANCEL_WINDOW <= block.number) {
1782                     // Call cannot be cancelled this close to execution.
1783                     return false;
1784             }
1785             call.isCancelled = true;
1786             return true;
1787     }
1788 }
1789 
1790 
1791 /*
1792  *  Ethereum Alarm Service
1793  *  Version 0.4.0
1794  *
1795  *  address: 0x07307d0b136a79bac718f43388aed706389c4588
1796  */
1797 contract Alarm {
1798         /*
1799          *  Constructor
1800          *
1801          *  - sets up relays
1802          *  - configures the caller pool.
1803          */
1804         function Alarm() {
1805                 callDatabase.unauthorizedRelay = new Relay();
1806                 callDatabase.authorizedRelay = new Relay();
1807 
1808                 callDatabase.callerPool.freezePeriod = 80;
1809                 callDatabase.callerPool.rotationDelay = 80;
1810                 callDatabase.callerPool.overlapSize = 256;
1811         }
1812 
1813         ScheduledCallLib.CallDatabase callDatabase;
1814 
1815         // The author (Piper Merriam) address.
1816         address constant owner = 0xd3cda913deb6f67967b99d67acdfa1712c293601;
1817 
1818         /*
1819          *  Account Management API
1820          */
1821         function getAccountBalance(address accountAddress) constant public returns (uint) {
1822                 return callDatabase.gasBank.accountBalances[accountAddress];
1823         }
1824 
1825         function deposit() public {
1826                 deposit(msg.sender);
1827         }
1828 
1829         function deposit(address accountAddress) public {
1830                 /*
1831                  *  Public API for depositing funds in a specified account.
1832                  */
1833                 AccountingLib.deposit(callDatabase.gasBank, accountAddress, msg.value);
1834                 AccountingLib.Deposit(msg.sender, accountAddress, msg.value);
1835         }
1836 
1837         function withdraw(uint value) public {
1838                 /*
1839                  *  Public API for withdrawing funds.
1840                  */
1841                 if (AccountingLib.withdraw(callDatabase.gasBank, msg.sender, value)) {
1842                         AccountingLib.Withdrawal(msg.sender, value);
1843                 }
1844                 else {
1845                         AccountingLib.InsufficientFunds(msg.sender, value, callDatabase.gasBank.accountBalances[msg.sender]);
1846                 }
1847         }
1848 
1849         function() {
1850                 /*
1851                  *  Fallback function that allows depositing funds just by
1852                  *  sending a transaction.
1853                  */
1854                 deposit(msg.sender);
1855         }
1856 
1857         /*
1858          *  Scheduling Authorization API
1859          */
1860         function unauthorizedAddress() constant returns (address) {
1861                 return address(callDatabase.unauthorizedRelay);
1862         }
1863 
1864         function authorizedAddress() constant returns (address) {
1865                 return address(callDatabase.authorizedRelay);
1866         }
1867 
1868         function addAuthorization(address schedulerAddress) public {
1869                 ScheduledCallLib.addAuthorization(callDatabase, schedulerAddress, msg.sender);
1870         }
1871 
1872         function removeAuthorization(address schedulerAddress) public {
1873                 callDatabase.accountAuthorizations[sha3(schedulerAddress, msg.sender)] = false;
1874         }
1875 
1876         function checkAuthorization(address schedulerAddress, address contractAddress) constant returns (bool) {
1877                 return callDatabase.accountAuthorizations[sha3(schedulerAddress, contractAddress)];
1878         }
1879 
1880         /*
1881          *  Caller bonding
1882          */
1883         function getMinimumBond() constant returns (uint) {
1884                 return ScheduledCallLib.getMinimumBond();
1885         }
1886 
1887         function depositBond() public {
1888                 ResourcePoolLib.addToBond(callDatabase.callerPool, msg.sender, msg.value);
1889         }
1890 
1891         function withdrawBond(uint value) public {
1892                 ResourcePoolLib.withdrawBond(callDatabase.callerPool, msg.sender, value, getMinimumBond());
1893         }
1894 
1895         function getBondBalance() constant returns (uint) {
1896                 return getBondBalance(msg.sender);
1897         }
1898 
1899         function getBondBalance(address callerAddress) constant returns (uint) {
1900                 return callDatabase.callerPool.bonds[callerAddress];
1901         }
1902 
1903 
1904         /*
1905          *  Pool Management
1906          */
1907         function getGenerationForCall(bytes32 callKey) constant returns (uint) {
1908                 var call = callDatabase.calls[callKey];
1909                 return ResourcePoolLib.getGenerationForWindow(callDatabase.callerPool, call.targetBlock, call.targetBlock + call.gracePeriod);
1910         }
1911 
1912         function getGenerationSize(uint generationId) constant returns (uint) {
1913                 return callDatabase.callerPool.generations[generationId].members.length;
1914         }
1915 
1916         function getGenerationStartAt(uint generationId) constant returns (uint) {
1917                 return callDatabase.callerPool.generations[generationId].startAt;
1918         }
1919 
1920         function getGenerationEndAt(uint generationId) constant returns (uint) {
1921                 return callDatabase.callerPool.generations[generationId].endAt;
1922         }
1923 
1924         function getCurrentGenerationId() constant returns (uint) {
1925                 return ResourcePoolLib.getCurrentGenerationId(callDatabase.callerPool);
1926         }
1927 
1928         function getNextGenerationId() constant returns (uint) {
1929                 return ResourcePoolLib.getNextGenerationId(callDatabase.callerPool);
1930         }
1931 
1932         function isInPool() constant returns (bool) {
1933                 return ResourcePoolLib.isInPool(callDatabase.callerPool, msg.sender);
1934         }
1935 
1936         function isInPool(address callerAddress) constant returns (bool) {
1937                 return ResourcePoolLib.isInPool(callDatabase.callerPool, callerAddress);
1938         }
1939 
1940         function isInGeneration(uint generationId) constant returns (bool) {
1941                 return isInGeneration(msg.sender, generationId);
1942         }
1943 
1944         function isInGeneration(address callerAddress, uint generationId) constant returns (bool) {
1945                 return ResourcePoolLib.isInGeneration(callDatabase.callerPool, callerAddress, generationId);
1946         }
1947 
1948         /*
1949          *  Pool Meta information
1950          */
1951         function getPoolFreezePeriod() constant returns (uint) {
1952                 return callDatabase.callerPool.freezePeriod;
1953         }
1954 
1955         function getPoolOverlapSize() constant returns (uint) {
1956                 return callDatabase.callerPool.overlapSize;
1957         }
1958 
1959         function getPoolRotationDelay() constant returns (uint) {
1960                 return callDatabase.callerPool.rotationDelay;
1961         }
1962 
1963         /*
1964          *  Pool Membership
1965          */
1966         function canEnterPool() constant returns (bool) {
1967                 return ResourcePoolLib.canEnterPool(callDatabase.callerPool, msg.sender, getMinimumBond());
1968         }
1969 
1970         function canEnterPool(address callerAddress) constant returns (bool) {
1971                 return ResourcePoolLib.canEnterPool(callDatabase.callerPool, callerAddress, getMinimumBond());
1972         }
1973 
1974         function canExitPool() constant returns (bool) {
1975                 return ResourcePoolLib.canExitPool(callDatabase.callerPool, msg.sender);
1976         }
1977 
1978         function canExitPool(address callerAddress) constant returns (bool) {
1979                 return ResourcePoolLib.canExitPool(callDatabase.callerPool, callerAddress);
1980         }
1981 
1982         function enterPool() public {
1983                 uint generationId = ResourcePoolLib.enterPool(callDatabase.callerPool, msg.sender, getMinimumBond());
1984                 ResourcePoolLib.AddedToGeneration(msg.sender, generationId);
1985         }
1986 
1987         function exitPool() public {
1988                 uint generationId = ResourcePoolLib.exitPool(callDatabase.callerPool, msg.sender);
1989                 ResourcePoolLib.RemovedFromGeneration(msg.sender, generationId);
1990         }
1991 
1992         /*
1993          *  Call Information API
1994          */
1995 
1996         function getLastCallKey() constant returns (bytes32) {
1997                 return callDatabase.lastCallKey;
1998         }
1999 
2000         /*
2001          *  Getter methods for `Call` information
2002          */
2003         function getCallContractAddress(bytes32 callKey) constant returns (address) {
2004                 return ScheduledCallLib.getCallContractAddress(callDatabase, callKey);
2005         }
2006 
2007         function getCallScheduledBy(bytes32 callKey) constant returns (address) {
2008                 return ScheduledCallLib.getCallScheduledBy(callDatabase, callKey);
2009         }
2010 
2011         function getCallCalledAtBlock(bytes32 callKey) constant returns (uint) {
2012                 return ScheduledCallLib.getCallCalledAtBlock(callDatabase, callKey);
2013         }
2014 
2015         function getCallGracePeriod(bytes32 callKey) constant returns (uint) {
2016                 return ScheduledCallLib.getCallGracePeriod(callDatabase, callKey);
2017         }
2018 
2019         function getCallTargetBlock(bytes32 callKey) constant returns (uint) {
2020                 return ScheduledCallLib.getCallTargetBlock(callDatabase, callKey);
2021         }
2022 
2023         function getCallBaseGasPrice(bytes32 callKey) constant returns (uint) {
2024                 return ScheduledCallLib.getCallBaseGasPrice(callDatabase, callKey);
2025         }
2026 
2027         function getCallGasPrice(bytes32 callKey) constant returns (uint) {
2028                 return ScheduledCallLib.getCallGasPrice(callDatabase, callKey);
2029         }
2030 
2031         function getCallGasUsed(bytes32 callKey) constant returns (uint) {
2032                 return ScheduledCallLib.getCallGasUsed(callDatabase, callKey);
2033         }
2034 
2035         function getCallABISignature(bytes32 callKey) constant returns (bytes4) {
2036                 return ScheduledCallLib.getCallABISignature(callDatabase, callKey);
2037         }
2038 
2039         function checkIfCalled(bytes32 callKey) constant returns (bool) {
2040                 return ScheduledCallLib.checkIfCalled(callDatabase, callKey);
2041         }
2042 
2043         function checkIfSuccess(bytes32 callKey) constant returns (bool) {
2044                 return ScheduledCallLib.checkIfSuccess(callDatabase, callKey);
2045         }
2046 
2047         function checkIfCancelled(bytes32 callKey) constant returns (bool) {
2048                 return ScheduledCallLib.checkIfCancelled(callDatabase, callKey);
2049         }
2050 
2051         function getCallDataHash(bytes32 callKey) constant returns (bytes32) {
2052                 return ScheduledCallLib.getCallDataHash(callDatabase, callKey);
2053         }
2054 
2055         function getCallPayout(bytes32 callKey) constant returns (uint) {
2056                 return ScheduledCallLib.getCallPayout(callDatabase, callKey);
2057         }
2058 
2059         function getCallFee(bytes32 callKey) constant returns (uint) {
2060                 return ScheduledCallLib.getCallFee(callDatabase, callKey);
2061         }
2062 
2063         function getCallMaxCost(bytes32 callKey) constant returns (uint) {
2064                 return ScheduledCallLib.getCallMaxCost(callDatabase, callKey);
2065         }
2066 
2067         function getCallData(bytes32 callKey) constant returns (bytes) {
2068                 return callDatabase.data_registry[callDatabase.calls[callKey].dataHash];
2069         }
2070 
2071         /*
2072          *  Data registration API
2073          */
2074         function registerData() public {
2075                 ScheduledCallLib.registerData(callDatabase, msg.data);
2076                 ScheduledCallLib.DataRegistered(callDatabase.lastDataHash);
2077         }
2078 
2079         function getLastDataHash() constant returns (bytes32) {
2080                 return callDatabase.lastDataHash;
2081         }
2082 
2083         function getLastDataLength() constant returns (uint) {
2084                 return callDatabase.lastDataLength;
2085         }
2086 
2087         function getLastData() constant returns (bytes) {
2088                 return callDatabase.lastData;
2089         }
2090 
2091         /*
2092          *  Call execution API
2093          */
2094         function doCall(bytes32 callKey) public {
2095                 ScheduledCallLib.doCall(callDatabase, callKey, msg.sender);
2096         }
2097 
2098         /*
2099          *  Call Scheduling API
2100          */
2101         function getMinimumGracePeriod() constant returns (uint) {
2102                 return ScheduledCallLib.getMinimumGracePeriod();
2103         }
2104 
2105         function scheduleCall(address contractAddress, bytes4 abiSignature, bytes32 dataHash, uint targetBlock) public {
2106                 /*
2107                  *  Schedule call with gracePeriod defaulted to 255 and nonce
2108                  *  defaulted to 0.
2109                  */
2110                 scheduleCall(contractAddress, abiSignature, dataHash, targetBlock, 255, 0);
2111         }
2112 
2113         function scheduleCall(address contractAddress, bytes4 abiSignature, bytes32 dataHash, uint targetBlock, uint8 gracePeriod) public {
2114                 /*
2115                  *  Schedule call with nonce defaulted to 0.
2116                  */
2117                 scheduleCall(contractAddress, abiSignature, dataHash, targetBlock, gracePeriod, 0);
2118         }
2119 
2120         function scheduleCall(address contractAddress, bytes4 abiSignature, bytes32 dataHash, uint targetBlock, uint8 gracePeriod, uint nonce) public {
2121                 /*
2122                  * Primary API for scheduling a call.  Prior to calling this
2123                  * the data should already have been registered through the
2124                  * `registerData` API.
2125                  */
2126                 bytes15 reason = ScheduledCallLib.scheduleCall(callDatabase, msg.sender, contractAddress, abiSignature, dataHash, targetBlock, gracePeriod, nonce);
2127                 bytes32 callKey = ScheduledCallLib.computeCallKey(msg.sender, contractAddress, abiSignature, dataHash, targetBlock, gracePeriod, nonce);
2128 
2129                 if (reason != 0x0) {
2130                         ScheduledCallLib.CallRejected(callKey, reason);
2131                 }
2132                 else {
2133                         ScheduledCallLib.CallScheduled(callKey);
2134                 }
2135         }
2136 
2137         function cancelCall(bytes32 callKey) public {
2138                 if (ScheduledCallLib.cancelCall(callDatabase, callKey, address(msg.sender))) {
2139                         ScheduledCallLib.CallCancelled(callKey);
2140                 }
2141         }
2142 
2143         /*
2144          *  Next Call API
2145          */
2146         function getCallWindowSize() constant returns (uint) {
2147                 return ScheduledCallLib.getCallWindowSize();
2148         }
2149 
2150         function getGenerationIdForCall(bytes32 callKey) constant returns (uint) {
2151                 return ScheduledCallLib.getGenerationIdForCall(callDatabase, callKey);
2152         }
2153 
2154         function getDesignatedCaller(bytes32 callKey, uint blockNumber) constant returns (address) {
2155                 return ScheduledCallLib.getDesignatedCaller(callDatabase, callKey, blockNumber);
2156         }
2157 
2158         function getNextCall(uint blockNumber) constant returns (bytes32) {
2159                 return GroveLib.query(callDatabase.callIndex, ">=", int(blockNumber));
2160         }
2161 
2162         function getNextCallSibling(bytes32 callKey) constant returns (bytes32) {
2163                 return GroveLib.getNextNode(callDatabase.callIndex, callKey);
2164         }
2165 }