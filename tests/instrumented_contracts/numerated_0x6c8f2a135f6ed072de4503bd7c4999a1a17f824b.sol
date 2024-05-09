1 // Grove v0.2
2 
3 
4 /// @title GroveLib - Library for queriable indexed ordered data.
5 /// @author PiperMerriam -
6 library GroveLib {
7         /*
8          *  Indexes for ordered data
9          *
10          *  Address: 0x7c1eb207c07e7ab13cf245585bd03d0fa478d034
11          */
12         struct Index {
13                 bytes32 root;
14                 mapping (bytes32 => Node) nodes;
15         }
16 
17         struct Node {
18                 bytes32 id;
19                 int value;
20                 bytes32 parent;
21                 bytes32 left;
22                 bytes32 right;
23                 uint height;
24         }
25 
26         function max(uint a, uint b) internal returns (uint) {
27             if (a >= b) {
28                 return a;
29             }
30             return b;
31         }
32 
33         /*
34          *  Node getters
35          */
36         /// @dev Retrieve the unique identifier for the node.
37         /// @param index The index that the node is part of.
38         /// @param id The id for the node to be looked up.
39         function getNodeId(Index storage index, bytes32 id) constant returns (bytes32) {
40             return index.nodes[id].id;
41         }
42 
43         /// @dev Retrieve the value for the node.
44         /// @param index The index that the node is part of.
45         /// @param id The id for the node to be looked up.
46         function getNodeValue(Index storage index, bytes32 id) constant returns (int) {
47             return index.nodes[id].value;
48         }
49 
50         /// @dev Retrieve the height of the node.
51         /// @param index The index that the node is part of.
52         /// @param id The id for the node to be looked up.
53         function getNodeHeight(Index storage index, bytes32 id) constant returns (uint) {
54             return index.nodes[id].height;
55         }
56 
57         /// @dev Retrieve the parent id of the node.
58         /// @param index The index that the node is part of.
59         /// @param id The id for the node to be looked up.
60         function getNodeParent(Index storage index, bytes32 id) constant returns (bytes32) {
61             return index.nodes[id].parent;
62         }
63 
64         /// @dev Retrieve the left child id of the node.
65         /// @param index The index that the node is part of.
66         /// @param id The id for the node to be looked up.
67         function getNodeLeftChild(Index storage index, bytes32 id) constant returns (bytes32) {
68             return index.nodes[id].left;
69         }
70 
71         /// @dev Retrieve the right child id of the node.
72         /// @param index The index that the node is part of.
73         /// @param id The id for the node to be looked up.
74         function getNodeRightChild(Index storage index, bytes32 id) constant returns (bytes32) {
75             return index.nodes[id].right;
76         }
77 
78         /// @dev Retrieve the node id of the next node in the tree.
79         /// @param index The index that the node is part of.
80         /// @param id The id for the node to be looked up.
81         function getPreviousNode(Index storage index, bytes32 id) constant returns (bytes32) {
82             Node storage currentNode = index.nodes[id];
83 
84             if (currentNode.id == 0x0) {
85                 // Unknown node, just return 0x0;
86                 return 0x0;
87             }
88 
89             Node memory child;
90 
91             if (currentNode.left != 0x0) {
92                 // Trace left to latest child in left tree.
93                 child = index.nodes[currentNode.left];
94 
95                 while (child.right != 0) {
96                     child = index.nodes[child.right];
97                 }
98                 return child.id;
99             }
100 
101             if (currentNode.parent != 0x0) {
102                 // Now we trace back up through parent relationships, looking
103                 // for a link where the child is the right child of it's
104                 // parent.
105                 Node storage parent = index.nodes[currentNode.parent];
106                 child = currentNode;
107 
108                 while (true) {
109                     if (parent.right == child.id) {
110                         return parent.id;
111                     }
112 
113                     if (parent.parent == 0x0) {
114                         break;
115                     }
116                     child = parent;
117                     parent = index.nodes[parent.parent];
118                 }
119             }
120 
121             // This is the first node, and has no previous node.
122             return 0x0;
123         }
124 
125         /// @dev Retrieve the node id of the previous node in the tree.
126         /// @param index The index that the node is part of.
127         /// @param id The id for the node to be looked up.
128         function getNextNode(Index storage index, bytes32 id) constant returns (bytes32) {
129             Node storage currentNode = index.nodes[id];
130 
131             if (currentNode.id == 0x0) {
132                 // Unknown node, just return 0x0;
133                 return 0x0;
134             }
135 
136             Node memory child;
137 
138             if (currentNode.right != 0x0) {
139                 // Trace right to earliest child in right tree.
140                 child = index.nodes[currentNode.right];
141 
142                 while (child.left != 0) {
143                     child = index.nodes[child.left];
144                 }
145                 return child.id;
146             }
147 
148             if (currentNode.parent != 0x0) {
149                 // if the node is the left child of it's parent, then the
150                 // parent is the next one.
151                 Node storage parent = index.nodes[currentNode.parent];
152                 child = currentNode;
153 
154                 while (true) {
155                     if (parent.left == child.id) {
156                         return parent.id;
157                     }
158 
159                     if (parent.parent == 0x0) {
160                         break;
161                     }
162                     child = parent;
163                     parent = index.nodes[parent.parent];
164                 }
165 
166                 // Now we need to trace all the way up checking to see if any parent is the
167             }
168 
169             // This is the final node.
170             return 0x0;
171         }
172 
173 
174         /// @dev Updates or Inserts the id into the index at its appropriate location based on the value provided.
175         /// @param index The index that the node is part of.
176         /// @param id The unique identifier of the data element the index node will represent.
177         /// @param value The value of the data element that represents it's total ordering with respect to other elementes.
178         function insert(Index storage index, bytes32 id, int value) public {
179                 if (index.nodes[id].id == id) {
180                     // A node with this id already exists.  If the value is
181                     // the same, then just return early, otherwise, remove it
182                     // and reinsert it.
183                     if (index.nodes[id].value == value) {
184                         return;
185                     }
186                     remove(index, id);
187                 }
188 
189                 uint leftHeight;
190                 uint rightHeight;
191 
192                 bytes32 previousNodeId = 0x0;
193 
194                 if (index.root == 0x0) {
195                     index.root = id;
196                 }
197                 Node storage currentNode = index.nodes[index.root];
198 
199                 // Do insertion
200                 while (true) {
201                     if (currentNode.id == 0x0) {
202                         // This is a new unpopulated node.
203                         currentNode.id = id;
204                         currentNode.parent = previousNodeId;
205                         currentNode.value = value;
206                         break;
207                     }
208 
209                     // Set the previous node id.
210                     previousNodeId = currentNode.id;
211 
212                     // The new node belongs in the right subtree
213                     if (value >= currentNode.value) {
214                         if (currentNode.right == 0x0) {
215                             currentNode.right = id;
216                         }
217                         currentNode = index.nodes[currentNode.right];
218                         continue;
219                     }
220 
221                     // The new node belongs in the left subtree.
222                     if (currentNode.left == 0x0) {
223                         currentNode.left = id;
224                     }
225                     currentNode = index.nodes[currentNode.left];
226                 }
227 
228                 // Rebalance the tree
229                 _rebalanceTree(index, currentNode.id);
230         }
231 
232         /// @dev Checks whether a node for the given unique identifier exists within the given index.
233         /// @param index The index that should be searched
234         /// @param id The unique identifier of the data element to check for.
235         function exists(Index storage index, bytes32 id) constant returns (bool) {
236             return (index.nodes[id].height > 0);
237         }
238 
239         /// @dev Remove the node for the given unique identifier from the index.
240         /// @param index The index that should be removed
241         /// @param id The unique identifier of the data element to remove.
242         function remove(Index storage index, bytes32 id) public {
243             Node storage replacementNode;
244             Node storage parent;
245             Node storage child;
246             bytes32 rebalanceOrigin;
247 
248             Node storage nodeToDelete = index.nodes[id];
249 
250             if (nodeToDelete.id != id) {
251                 // The id does not exist in the tree.
252                 return;
253             }
254 
255             if (nodeToDelete.left != 0x0 || nodeToDelete.right != 0x0) {
256                 // This node is not a leaf node and thus must replace itself in
257                 // it's tree by either the previous or next node.
258                 if (nodeToDelete.left != 0x0) {
259                     // This node is guaranteed to not have a right child.
260                     replacementNode = index.nodes[getPreviousNode(index, nodeToDelete.id)];
261                 }
262                 else {
263                     // This node is guaranteed to not have a left child.
264                     replacementNode = index.nodes[getNextNode(index, nodeToDelete.id)];
265                 }
266                 // The replacementNode is guaranteed to have a parent.
267                 parent = index.nodes[replacementNode.parent];
268 
269                 // Keep note of the location that our tree rebalancing should
270                 // start at.
271                 rebalanceOrigin = replacementNode.id;
272 
273                 // Join the parent of the replacement node with any subtree of
274                 // the replacement node.  We can guarantee that the replacement
275                 // node has at most one subtree because of how getNextNode and
276                 // getPreviousNode are used.
277                 if (parent.left == replacementNode.id) {
278                     parent.left = replacementNode.right;
279                     if (replacementNode.right != 0x0) {
280                         child = index.nodes[replacementNode.right];
281                         child.parent = parent.id;
282                     }
283                 }
284                 if (parent.right == replacementNode.id) {
285                     parent.right = replacementNode.left;
286                     if (replacementNode.left != 0x0) {
287                         child = index.nodes[replacementNode.left];
288                         child.parent = parent.id;
289                     }
290                 }
291 
292                 // Now we replace the nodeToDelete with the replacementNode.
293                 // This includes parent/child relationships for all of the
294                 // parent, the left child, and the right child.
295                 replacementNode.parent = nodeToDelete.parent;
296                 if (nodeToDelete.parent != 0x0) {
297                     parent = index.nodes[nodeToDelete.parent];
298                     if (parent.left == nodeToDelete.id) {
299                         parent.left = replacementNode.id;
300                     }
301                     if (parent.right == nodeToDelete.id) {
302                         parent.right = replacementNode.id;
303                     }
304                 }
305                 else {
306                     // If the node we are deleting is the root node update the
307                     // index root node pointer.
308                     index.root = replacementNode.id;
309                 }
310 
311                 replacementNode.left = nodeToDelete.left;
312                 if (nodeToDelete.left != 0x0) {
313                     child = index.nodes[nodeToDelete.left];
314                     child.parent = replacementNode.id;
315                 }
316 
317                 replacementNode.right = nodeToDelete.right;
318                 if (nodeToDelete.right != 0x0) {
319                     child = index.nodes[nodeToDelete.right];
320                     child.parent = replacementNode.id;
321                 }
322             }
323             else if (nodeToDelete.parent != 0x0) {
324                 // The node being deleted is a leaf node so we only erase it's
325                 // parent linkage.
326                 parent = index.nodes[nodeToDelete.parent];
327 
328                 if (parent.left == nodeToDelete.id) {
329                     parent.left = 0x0;
330                 }
331                 if (parent.right == nodeToDelete.id) {
332                     parent.right = 0x0;
333                 }
334 
335                 // keep note of where the rebalancing should begin.
336                 rebalanceOrigin = parent.id;
337             }
338             else {
339                 // This is both a leaf node and the root node, so we need to
340                 // unset the root node pointer.
341                 index.root = 0x0;
342             }
343 
344             // Now we zero out all of the fields on the nodeToDelete.
345             nodeToDelete.id = 0x0;
346             nodeToDelete.value = 0;
347             nodeToDelete.parent = 0x0;
348             nodeToDelete.left = 0x0;
349             nodeToDelete.right = 0x0;
350             nodeToDelete.height = 0;
351 
352             // Walk back up the tree rebalancing
353             if (rebalanceOrigin != 0x0) {
354                 _rebalanceTree(index, rebalanceOrigin);
355             }
356         }
357 
358         bytes2 constant GT = ">";
359         bytes2 constant LT = "<";
360         bytes2 constant GTE = ">=";
361         bytes2 constant LTE = "<=";
362         bytes2 constant EQ = "==";
363 
364         function _compare(int left, bytes2 operator, int right) internal returns (bool) {
365             if (operator == GT) {
366                 return (left > right);
367             }
368             if (operator == LT) {
369                 return (left < right);
370             }
371             if (operator == GTE) {
372                 return (left >= right);
373             }
374             if (operator == LTE) {
375                 return (left <= right);
376             }
377             if (operator == EQ) {
378                 return (left == right);
379             }
380 
381             // Invalid operator.
382             throw;
383         }
384 
385         function _getMaximum(Index storage index, bytes32 id) internal returns (int) {
386                 Node storage currentNode = index.nodes[id];
387 
388                 while (true) {
389                     if (currentNode.right == 0x0) {
390                         return currentNode.value;
391                     }
392                     currentNode = index.nodes[currentNode.right];
393                 }
394         }
395 
396         function _getMinimum(Index storage index, bytes32 id) internal returns (int) {
397                 Node storage currentNode = index.nodes[id];
398 
399                 while (true) {
400                     if (currentNode.left == 0x0) {
401                         return currentNode.value;
402                     }
403                     currentNode = index.nodes[currentNode.left];
404                 }
405         }
406 
407 
408         /** @dev Query the index for the edge-most node that satisfies the
409          *  given query.  For >, >=, and ==, this will be the left-most node
410          *  that satisfies the comparison.  For < and <= this will be the
411          *  right-most node that satisfies the comparison.
412          */
413         /// @param index The index that should be queried
414         /** @param operator One of '>', '>=', '<', '<=', '==' to specify what
415          *  type of comparison operator should be used.
416          */
417         function query(Index storage index, bytes2 operator, int value) public returns (bytes32) {
418                 bytes32 rootNodeId = index.root;
419 
420                 if (rootNodeId == 0x0) {
421                     // Empty tree.
422                     return 0x0;
423                 }
424 
425                 Node storage currentNode = index.nodes[rootNodeId];
426 
427                 while (true) {
428                     if (_compare(currentNode.value, operator, value)) {
429                         // We have found a match but it might not be the
430                         // *correct* match.
431                         if ((operator == LT) || (operator == LTE)) {
432                             // Need to keep traversing right until this is no
433                             // longer true.
434                             if (currentNode.right == 0x0) {
435                                 return currentNode.id;
436                             }
437                             if (_compare(_getMinimum(index, currentNode.right), operator, value)) {
438                                 // There are still nodes to the right that
439                                 // match.
440                                 currentNode = index.nodes[currentNode.right];
441                                 continue;
442                             }
443                             return currentNode.id;
444                         }
445 
446                         if ((operator == GT) || (operator == GTE) || (operator == EQ)) {
447                             // Need to keep traversing left until this is no
448                             // longer true.
449                             if (currentNode.left == 0x0) {
450                                 return currentNode.id;
451                             }
452                             if (_compare(_getMaximum(index, currentNode.left), operator, value)) {
453                                 currentNode = index.nodes[currentNode.left];
454                                 continue;
455                             }
456                             return currentNode.id;
457                         }
458                     }
459 
460                     if ((operator == LT) || (operator == LTE)) {
461                         if (currentNode.left == 0x0) {
462                             // There are no nodes that are less than the value
463                             // so return null.
464                             return 0x0;
465                         }
466                         currentNode = index.nodes[currentNode.left];
467                         continue;
468                     }
469 
470                     if ((operator == GT) || (operator == GTE)) {
471                         if (currentNode.right == 0x0) {
472                             // There are no nodes that are greater than the value
473                             // so return null.
474                             return 0x0;
475                         }
476                         currentNode = index.nodes[currentNode.right];
477                         continue;
478                     }
479 
480                     if (operator == EQ) {
481                         if (currentNode.value < value) {
482                             if (currentNode.right == 0x0) {
483                                 return 0x0;
484                             }
485                             currentNode = index.nodes[currentNode.right];
486                             continue;
487                         }
488 
489                         if (currentNode.value > value) {
490                             if (currentNode.left == 0x0) {
491                                 return 0x0;
492                             }
493                             currentNode = index.nodes[currentNode.left];
494                             continue;
495                         }
496                     }
497                 }
498         }
499 
500         function _rebalanceTree(Index storage index, bytes32 id) internal {
501             // Trace back up rebalancing the tree and updating heights as
502             // needed..
503             Node storage currentNode = index.nodes[id];
504 
505             while (true) {
506                 int balanceFactor = _getBalanceFactor(index, currentNode.id);
507 
508                 if (balanceFactor == 2) {
509                     // Right rotation (tree is heavy on the left)
510                     if (_getBalanceFactor(index, currentNode.left) == -1) {
511                         // The subtree is leaning right so it need to be
512                         // rotated left before the current node is rotated
513                         // right.
514                         _rotateLeft(index, currentNode.left);
515                     }
516                     _rotateRight(index, currentNode.id);
517                 }
518 
519                 if (balanceFactor == -2) {
520                     // Left rotation (tree is heavy on the right)
521                     if (_getBalanceFactor(index, currentNode.right) == 1) {
522                         // The subtree is leaning left so it need to be
523                         // rotated right before the current node is rotated
524                         // left.
525                         _rotateRight(index, currentNode.right);
526                     }
527                     _rotateLeft(index, currentNode.id);
528                 }
529 
530                 if ((-1 <= balanceFactor) && (balanceFactor <= 1)) {
531                     _updateNodeHeight(index, currentNode.id);
532                 }
533 
534                 if (currentNode.parent == 0x0) {
535                     // Reached the root which may be new due to tree
536                     // rotation, so set it as the root and then break.
537                     break;
538                 }
539 
540                 currentNode = index.nodes[currentNode.parent];
541             }
542         }
543 
544         function _getBalanceFactor(Index storage index, bytes32 id) internal returns (int) {
545                 Node storage node = index.nodes[id];
546 
547                 return int(index.nodes[node.left].height) - int(index.nodes[node.right].height);
548         }
549 
550         function _updateNodeHeight(Index storage index, bytes32 id) internal {
551                 Node storage node = index.nodes[id];
552 
553                 node.height = max(index.nodes[node.left].height, index.nodes[node.right].height) + 1;
554         }
555 
556         function _rotateLeft(Index storage index, bytes32 id) internal {
557             Node storage originalRoot = index.nodes[id];
558 
559             if (originalRoot.right == 0x0) {
560                 // Cannot rotate left if there is no right originalRoot to rotate into
561                 // place.
562                 throw;
563             }
564 
565             // The right child is the new root, so it gets the original
566             // `originalRoot.parent` as it's parent.
567             Node storage newRoot = index.nodes[originalRoot.right];
568             newRoot.parent = originalRoot.parent;
569 
570             // The original root needs to have it's right child nulled out.
571             originalRoot.right = 0x0;
572 
573             if (originalRoot.parent != 0x0) {
574                 // If there is a parent node, it needs to now point downward at
575                 // the newRoot which is rotating into the place where `node` was.
576                 Node storage parent = index.nodes[originalRoot.parent];
577 
578                 // figure out if we're a left or right child and have the
579                 // parent point to the new node.
580                 if (parent.left == originalRoot.id) {
581                     parent.left = newRoot.id;
582                 }
583                 if (parent.right == originalRoot.id) {
584                     parent.right = newRoot.id;
585                 }
586             }
587 
588 
589             if (newRoot.left != 0) {
590                 // If the new root had a left child, that moves to be the
591                 // new right child of the original root node
592                 Node storage leftChild = index.nodes[newRoot.left];
593                 originalRoot.right = leftChild.id;
594                 leftChild.parent = originalRoot.id;
595             }
596 
597             // Update the newRoot's left node to point at the original node.
598             originalRoot.parent = newRoot.id;
599             newRoot.left = originalRoot.id;
600 
601             if (newRoot.parent == 0x0) {
602                 index.root = newRoot.id;
603             }
604 
605             // TODO: are both of these updates necessary?
606             _updateNodeHeight(index, originalRoot.id);
607             _updateNodeHeight(index, newRoot.id);
608         }
609 
610         function _rotateRight(Index storage index, bytes32 id) internal {
611             Node storage originalRoot = index.nodes[id];
612 
613             if (originalRoot.left == 0x0) {
614                 // Cannot rotate right if there is no left node to rotate into
615                 // place.
616                 throw;
617             }
618 
619             // The left child is taking the place of node, so we update it's
620             // parent to be the original parent of the node.
621             Node storage newRoot = index.nodes[originalRoot.left];
622             newRoot.parent = originalRoot.parent;
623 
624             // Null out the originalRoot.left
625             originalRoot.left = 0x0;
626 
627             if (originalRoot.parent != 0x0) {
628                 // If the node has a parent, update the correct child to point
629                 // at the newRoot now.
630                 Node storage parent = index.nodes[originalRoot.parent];
631 
632                 if (parent.left == originalRoot.id) {
633                     parent.left = newRoot.id;
634                 }
635                 if (parent.right == originalRoot.id) {
636                     parent.right = newRoot.id;
637                 }
638             }
639 
640             if (newRoot.right != 0x0) {
641                 Node storage rightChild = index.nodes[newRoot.right];
642                 originalRoot.left = newRoot.right;
643                 rightChild.parent = originalRoot.id;
644             }
645 
646             // Update the new root's right node to point to the original node.
647             originalRoot.parent = newRoot.id;
648             newRoot.right = originalRoot.id;
649 
650             if (newRoot.parent == 0x0) {
651                 index.root = newRoot.id;
652             }
653 
654             // Recompute heights.
655             _updateNodeHeight(index, originalRoot.id);
656             _updateNodeHeight(index, newRoot.id);
657         }
658 }
659 
660 
661 // Accounting v0.1 (not the same as the 0.1 release of this library)
662 
663 /// @title Accounting Lib - Accounting utilities
664 /// @author Piper Merriam -
665 library AccountingLib {
666         /*
667          *  Address: 0x89efe605e9ecbe22849cd85d5449cc946c26f8f3
668          */
669         struct Bank {
670             mapping (address => uint) accountBalances;
671         }
672 
673         /// @dev Low level method for adding funds to an account.  Protects against overflow.
674         /// @param self The Bank instance to operate on.
675         /// @param accountAddress The address of the account the funds should be added to.
676         /// @param value The amount that should be added to the account.
677         function addFunds(Bank storage self, address accountAddress, uint value) public {
678                 if (self.accountBalances[accountAddress] + value < self.accountBalances[accountAddress]) {
679                         // Prevent Overflow.
680                         throw;
681                 }
682                 self.accountBalances[accountAddress] += value;
683         }
684 
685         event _Deposit(address indexed _from, address indexed accountAddress, uint value);
686         /// @dev Function wrapper around the _Deposit event so that it can be used by contracts.  Can be used to log a deposit to an account.
687         /// @param _from The address that deposited the funds.
688         /// @param accountAddress The address of the account the funds were added to.
689         /// @param value The amount that was added to the account.
690         function Deposit(address _from, address accountAddress, uint value) public {
691             _Deposit(_from, accountAddress, value);
692         }
693 
694 
695         /// @dev Safe function for depositing funds.  Returns boolean for whether the deposit was successful
696         /// @param self The Bank instance to operate on.
697         /// @param accountAddress The address of the account the funds should be added to.
698         /// @param value The amount that should be added to the account.
699         function deposit(Bank storage self, address accountAddress, uint value) public returns (bool) {
700                 addFunds(self, accountAddress, value);
701                 return true;
702         }
703 
704         event _Withdrawal(address indexed accountAddress, uint value);
705 
706         /// @dev Function wrapper around the _Withdrawal event so that it can be used by contracts.  Can be used to log a withdrawl from an account.
707         /// @param accountAddress The address of the account the funds were withdrawn from.
708         /// @param value The amount that was withdrawn to the account.
709         function Withdrawal(address accountAddress, uint value) public {
710             _Withdrawal(accountAddress, value);
711         }
712 
713         event _InsufficientFunds(address indexed accountAddress, uint value, uint balance);
714 
715         /// @dev Function wrapper around the _InsufficientFunds event so that it can be used by contracts.  Can be used to log a failed withdrawl from an account.
716         /// @param accountAddress The address of the account the funds were to be withdrawn from.
717         /// @param value The amount that was attempted to be withdrawn from the account.
718         /// @param balance The current balance of the account.
719         function InsufficientFunds(address accountAddress, uint value, uint balance) public {
720             _InsufficientFunds(accountAddress, value, balance);
721         }
722 
723         /// @dev Low level method for removing funds from an account.  Protects against underflow.
724         /// @param self The Bank instance to operate on.
725         /// @param accountAddress The address of the account the funds should be deducted from.
726         /// @param value The amount that should be deducted from the account.
727         function deductFunds(Bank storage self, address accountAddress, uint value) public {
728                 /*
729                  *  Helper function that should be used for any reduction of
730                  *  account funds.  It has error checking to prevent
731                  *  underflowing the account balance which would be REALLY bad.
732                  */
733                 if (value > self.accountBalances[accountAddress]) {
734                         // Prevent Underflow.
735                         throw;
736                 }
737                 self.accountBalances[accountAddress] -= value;
738         }
739 
740         /// @dev Safe function for withdrawing funds.  Returns boolean for whether the deposit was successful as well as sending the amount in ether to the account address.
741         /// @param self The Bank instance to operate on.
742         /// @param accountAddress The address of the account the funds should be withdrawn from.
743         /// @param value The amount that should be withdrawn from the account.
744         function withdraw(Bank storage self, address accountAddress, uint value) public returns (bool) {
745                 /*
746                  *  Public API for withdrawing funds.
747                  */
748                 if (self.accountBalances[accountAddress] >= value) {
749                         deductFunds(self, accountAddress, value);
750                         if (!accountAddress.send(value)) {
751                                 // Potentially sending money to a contract that
752                                 // has a fallback function.  So instead, try
753                                 // tranferring the funds with the call api.
754                                 if (!accountAddress.call.value(value)()) {
755                                         // Revert the entire transaction.  No
756                                         // need to destroy the funds.
757                                         throw;
758                                 }
759                         }
760                         return true;
761                 }
762                 return false;
763         }
764 
765         uint constant DEFAULT_SEND_GAS = 100000;
766 
767         function sendRobust(address toAddress, uint value) public returns (bool) {
768                 if (msg.gas < DEFAULT_SEND_GAS) {
769                     return sendRobust(toAddress, value, msg.gas);
770                 }
771                 return sendRobust(toAddress, value, DEFAULT_SEND_GAS);
772         }
773 
774         function sendRobust(address toAddress, uint value, uint maxGas) public returns (bool) {
775                 if (value > 0 && !toAddress.send(value)) {
776                         // Potentially sending money to a contract that
777                         // has a fallback function.  So instead, try
778                         // tranferring the funds with the call api.
779                         if (!toAddress.call.gas(maxGas).value(value)()) {
780                                 return false;
781                         }
782                 }
783                 return true;
784         }
785 }
786 
787 
788 library CallLib {
789     /*
790      *  Address: 0x1deeda36e15ec9e80f3d7414d67a4803ae45fc80
791      */
792     struct Call {
793         address contractAddress;
794         bytes4 abiSignature;
795         bytes callData;
796         uint callValue;
797         uint anchorGasPrice;
798         uint requiredGas;
799         uint16 requiredStackDepth;
800 
801         address claimer;
802         uint claimAmount;
803         uint claimerDeposit;
804 
805         bool wasSuccessful;
806         bool wasCalled;
807         bool isCancelled;
808     }
809 
810     enum State {
811         Pending,
812         Unclaimed,
813         Claimed,
814         Frozen,
815         Callable,
816         Executed,
817         Cancelled,
818         Missed
819     }
820 
821     function state(Call storage self) constant returns (State) {
822         if (self.isCancelled) return State.Cancelled;
823         if (self.wasCalled) return State.Executed;
824 
825         var call = FutureBlockCall(this);
826 
827         if (block.number + CLAIM_GROWTH_WINDOW + MAXIMUM_CLAIM_WINDOW + BEFORE_CALL_FREEZE_WINDOW < call.targetBlock()) return State.Pending;
828         if (block.number + BEFORE_CALL_FREEZE_WINDOW < call.targetBlock()) {
829             if (self.claimer == 0x0) {
830                 return State.Unclaimed;
831             }
832             else {
833                 return State.Claimed;
834             }
835         }
836         if (block.number < call.targetBlock()) return State.Frozen;
837         if (block.number < call.targetBlock() + call.gracePeriod()) return State.Callable;
838         return State.Missed;
839     }
840 
841     // The number of blocks that each caller in the pool has to complete their
842     // call.
843     uint constant CALL_WINDOW_SIZE = 16;
844 
845     address constant creator = 0xd3cda913deb6f67967b99d67acdfa1712c293601;
846 
847     function extractCallData(Call storage call, bytes data) public {
848         call.callData.length = data.length - 4;
849         if (data.length > 4) {
850                 for (uint i = 0; i < call.callData.length; i++) {
851                         call.callData[i] = data[i + 4];
852                 }
853         }
854     }
855 
856     uint constant GAS_PER_DEPTH = 700;
857 
858     function checkDepth(uint n) constant returns (bool) {
859         if (n == 0) return true;
860         return address(this).call.gas(GAS_PER_DEPTH * n)(bytes4(sha3("__dig(uint256)")), n - 1);
861     }
862 
863     function sendSafe(address to_address, uint value) public returns (uint) {
864         if (value > address(this).balance) {
865             value = address(this).balance;
866         }
867         if (value > 0) {
868             AccountingLib.sendRobust(to_address, value);
869             return value;
870         }
871         return 0;
872     }
873 
874     function getGasScalar(uint base_gas_price, uint gas_price) constant returns (uint) {
875         /*
876         *  Return a number between 0 - 200 to scale the donation based on the
877         *  gas price set for the calling transaction as compared to the gas
878         *  price of the scheduling transaction.
879         *
880         *  - number approaches zero as the transaction gas price goes
881         *  above the gas price recorded when the call was scheduled.
882         *
883         *  - the number approaches 200 as the transaction gas price
884         *  drops under the price recorded when the call was scheduled.
885         *
886         *  This encourages lower gas costs as the lower the gas price
887         *  for the executing transaction, the higher the payout to the
888         *  caller.
889         */
890         if (gas_price > base_gas_price) {
891             return 100 * base_gas_price / gas_price;
892         }
893         else {
894             return 200 - 100 * base_gas_price / (2 * base_gas_price - gas_price);
895         }
896     }
897 
898     event CallExecuted(address indexed executor, uint gasCost, uint payment, uint donation, bool success);
899 
900     bytes4 constant EMPTY_SIGNATURE = 0x0000;
901 
902     event CallAborted(address executor, bytes32 reason);
903 
904     function execute(Call storage self,
905                      uint start_gas,
906                      address executor,
907                      uint overhead,
908                      uint extraGas) public {
909         FutureCall call = FutureCall(this);
910 
911         // Mark the call has having been executed.
912         self.wasCalled = true;
913 
914         // Make the call
915         if (self.abiSignature == EMPTY_SIGNATURE && self.callData.length == 0) {
916             self.wasSuccessful = self.contractAddress.call.value(self.callValue).gas(msg.gas - overhead)();
917         }
918         else if (self.abiSignature == EMPTY_SIGNATURE) {
919             self.wasSuccessful = self.contractAddress.call.value(self.callValue).gas(msg.gas - overhead)(self.callData);
920         }
921         else if (self.callData.length == 0) {
922             self.wasSuccessful = self.contractAddress.call.value(self.callValue).gas(msg.gas - overhead)(self.abiSignature);
923         }
924         else {
925             self.wasSuccessful = self.contractAddress.call.value(self.callValue).gas(msg.gas - overhead)(self.abiSignature, self.callData);
926         }
927 
928         call.origin().call(bytes4(sha3("updateDefaultPayment()")));
929 
930         // Compute the scalar (0 - 200) for the donation.
931         uint gasScalar = getGasScalar(self.anchorGasPrice, tx.gasprice);
932 
933         uint basePayment;
934         if (self.claimer == executor) {
935             basePayment = self.claimAmount;
936         }
937         else {
938             basePayment = call.basePayment();
939         }
940         uint payment = self.claimerDeposit + basePayment * gasScalar / 100;
941         uint donation = call.baseDonation() * gasScalar / 100;
942 
943         // zero out the deposit
944         self.claimerDeposit = 0;
945 
946         // Log how much gas this call used.  EXTRA_CALL_GAS is a fixed
947         // amount that represents the gas usage of the commands that
948         // happen after this line.
949         uint gasCost = tx.gasprice * (start_gas - msg.gas + extraGas);
950 
951         // Now we need to pay the executor as well as keep donation.
952         payment = sendSafe(executor, payment + gasCost);
953         donation = sendSafe(creator, donation);
954 
955         // Log execution
956         CallExecuted(executor, gasCost, payment, donation, self.wasSuccessful);
957     }
958 
959     event Cancelled(address indexed cancelled_by);
960 
961     function cancel(Call storage self, address sender) public {
962         Cancelled(sender);
963         if (self.claimerDeposit >= 0) {
964             sendSafe(self.claimer, self.claimerDeposit);
965         }
966         var call = FutureCall(this);
967         sendSafe(call.schedulerAddress(), address(this).balance);
968         self.isCancelled = true;
969     }
970 
971     /*
972      *  Bid API
973      *  - Gas costs for this transaction are not covered so it
974      *    must be up to the call executors to ensure that their actions
975      *    remain profitable.  Any form of bidding war is likely to eat into
976      *    profits.
977      */
978     event Claimed(address executor, uint claimAmount);
979 
980     // The duration (in blocks) during which the maximum claim will slowly rise
981     // towards the basePayment amount.
982     uint constant CLAIM_GROWTH_WINDOW = 240;
983 
984     // The duration (in blocks) after the CLAIM_WINDOW that claiming will
985     // remain open.
986     uint constant MAXIMUM_CLAIM_WINDOW = 15;
987 
988     // The duration (in blocks) before the call's target block during which
989     // all actions are frozen.  This includes claiming, cancellation,
990     // registering call data.
991     uint constant BEFORE_CALL_FREEZE_WINDOW = 10;
992 
993     /*
994      *  The maximum allowed claim amount slowly rises across a window of
995      *  blocks CLAIM_GROWTH_WINDOW prior to the call.  No claimer is
996      *  allowed to claim above this value.  This is intended to prevent
997      *  bidding wars in that each caller should know how much they are
998      *  willing to execute a call for.
999      */
1000     function getClaimAmountForBlock(uint block_number) constant returns (uint) {
1001         /*
1002          *   [--growth-window--][--max-window--][--freeze-window--]
1003          *
1004          *
1005          */
1006         var call = FutureBlockCall(this);
1007 
1008         uint cutoff = call.targetBlock() - BEFORE_CALL_FREEZE_WINDOW;
1009 
1010         // claim window has closed
1011         if (block_number > cutoff) return call.basePayment();
1012 
1013         cutoff -= MAXIMUM_CLAIM_WINDOW;
1014 
1015         // in the maximum claim window.
1016         if (block_number > cutoff) return call.basePayment();
1017 
1018         cutoff -= CLAIM_GROWTH_WINDOW;
1019 
1020         if (block_number > cutoff) {
1021             uint x = block_number - cutoff;
1022 
1023             return call.basePayment() * x / CLAIM_GROWTH_WINDOW;
1024         }
1025 
1026         return 0;
1027     }
1028 
1029     function lastClaimBlock() constant returns (uint) {
1030         var call = FutureBlockCall(this);
1031         return call.targetBlock() - BEFORE_CALL_FREEZE_WINDOW;
1032     }
1033 
1034     function maxClaimBlock() constant returns (uint) {
1035         return lastClaimBlock() - MAXIMUM_CLAIM_WINDOW;
1036     }
1037 
1038     function firstClaimBlock() constant returns (uint) {
1039         return maxClaimBlock() - CLAIM_GROWTH_WINDOW;
1040     }
1041 
1042     function claim(Call storage self, address executor, uint deposit_amount, uint basePayment) public returns (bool) {
1043         /*
1044          *  Warning! this does not check whether the function is already
1045          *  claimed or whether we are within the claim window.  This must be
1046          *  done at the contract level.
1047          */
1048         // Insufficient Deposit
1049         if (deposit_amount < 2 * basePayment) return false;
1050 
1051         self.claimAmount = getClaimAmountForBlock(block.number);
1052         self.claimer = executor;
1053         self.claimerDeposit = deposit_amount;
1054 
1055         // Log the claim.
1056         Claimed(executor, self.claimAmount);
1057     }
1058 
1059     function checkExecutionAuthorization(Call storage self, address executor, uint block_number) returns (bool) {
1060         /*
1061         *  Check whether the given `executor` is authorized.
1062         */
1063         var call = FutureBlockCall(this);
1064 
1065         uint targetBlock = call.targetBlock();
1066 
1067         // Invalid, not in call window.
1068         if (block_number < targetBlock || block_number > targetBlock + call.gracePeriod()) throw;
1069 
1070         // Within the reserved call window so if there is a claimer, the
1071         // executor must be the claimdor.
1072         if (block_number - targetBlock < CALL_WINDOW_SIZE) {
1073         return (self.claimer == 0x0 || self.claimer == executor);
1074         }
1075 
1076         // Must be in the free-for-all period.
1077         return true;
1078     }
1079 
1080     function isCancellable(Call storage self, address caller) returns (bool) {
1081         var _state = state(self);
1082         var call = FutureBlockCall(this);
1083 
1084         if (_state == State.Pending && caller == call.schedulerAddress()) {
1085             return true;
1086         }
1087 
1088         if (_state == State.Missed) return true;
1089 
1090         return false;
1091     }
1092 
1093     function beforeExecuteForFutureBlockCall(Call storage self, address executor, uint startGas) returns (bool) {
1094         bytes32 reason;
1095 
1096         var call = FutureBlockCall(this);
1097 
1098         if (startGas < self.requiredGas) {
1099             // The executor has not provided sufficient gas
1100             reason = "NOT_ENOUGH_GAS";
1101         }
1102         else if (self.wasCalled) {
1103             // Not being called within call window.
1104             reason = "ALREADY_CALLED";
1105         }
1106         else if (block.number < call.targetBlock() || block.number > call.targetBlock() + call.gracePeriod()) {
1107             // Not being called within call window.
1108             reason = "NOT_IN_CALL_WINDOW";
1109         }
1110         else if (!checkExecutionAuthorization(self, executor, block.number)) {
1111             // Someone has claimed this call and they currently have exclusive
1112             // rights to execute it.
1113             reason = "NOT_AUTHORIZED";
1114         }
1115         else if (self.requiredStackDepth > 0 && executor != tx.origin && !checkDepth(self.requiredStackDepth)) {
1116             reason = "STACK_TOO_DEEP";
1117         }
1118 
1119         if (reason != 0x0) {
1120             CallAborted(executor, reason);
1121             return false;
1122         }
1123 
1124         return true;
1125     }
1126 }
1127 
1128 
1129 contract FutureCall {
1130     // The author (Piper Merriam) address.
1131     address constant creator = 0xd3cda913deb6f67967b99d67acdfa1712c293601;
1132 
1133     address public schedulerAddress;
1134 
1135     uint public basePayment;
1136     uint public baseDonation;
1137 
1138     CallLib.Call call;
1139 
1140     address public origin;
1141 
1142     function FutureCall(address _schedulerAddress,
1143                         uint _requiredGas,
1144                         uint16 _requiredStackDepth,
1145                         address _contractAddress,
1146                         bytes4 _abiSignature,
1147                         bytes _callData,
1148                         uint _callValue,
1149                         uint _basePayment,
1150                         uint _baseDonation)
1151     {
1152         origin = msg.sender;
1153         schedulerAddress = _schedulerAddress;
1154 
1155         basePayment = _basePayment;
1156         baseDonation = _baseDonation;
1157 
1158         call.requiredGas = _requiredGas;
1159         call.requiredStackDepth = _requiredStackDepth;
1160         call.anchorGasPrice = tx.gasprice;
1161         call.contractAddress = _contractAddress;
1162         call.abiSignature = _abiSignature;
1163         call.callData = _callData;
1164         call.callValue = _callValue;
1165     }
1166 
1167     enum State {
1168         Pending,
1169         Unclaimed,
1170         Claimed,
1171         Frozen,
1172         Callable,
1173         Executed,
1174         Cancelled,
1175         Missed
1176     }
1177 
1178     modifier in_state(State _state) { if (state() == _state) _ }
1179 
1180     function state() constant returns (State) {
1181         return State(CallLib.state(call));
1182     }
1183 
1184     /*
1185      *  API for FutureXXXXCalls to implement.
1186      */
1187     function beforeExecute(address executor, uint startGas) public returns (bool);
1188     function afterExecute(address executor) internal;
1189     function getOverhead() constant returns (uint);
1190     function getExtraGas() constant returns (uint);
1191 
1192     /*
1193      *  Data accessor functions.
1194      */
1195     function contractAddress() constant returns (address) {
1196         return call.contractAddress;
1197     }
1198 
1199     function abiSignature() constant returns (bytes4) {
1200         return call.abiSignature;
1201     }
1202 
1203     function callData() constant returns (bytes) {
1204         return call.callData;
1205     }
1206 
1207     function callValue() constant returns (uint) {
1208         return call.callValue;
1209     }
1210 
1211     function anchorGasPrice() constant returns (uint) {
1212         return call.anchorGasPrice;
1213     }
1214 
1215     function requiredGas() constant returns (uint) {
1216         return call.requiredGas;
1217     }
1218 
1219     function requiredStackDepth() constant returns (uint16) {
1220         return call.requiredStackDepth;
1221     }
1222 
1223     function claimer() constant returns (address) {
1224         return call.claimer;
1225     }
1226 
1227     function claimAmount() constant returns (uint) {
1228         return call.claimAmount;
1229     }
1230 
1231     function claimerDeposit() constant returns (uint) {
1232         return call.claimerDeposit;
1233     }
1234 
1235     function wasSuccessful() constant returns (bool) {
1236         return call.wasSuccessful;
1237     }
1238 
1239     function wasCalled() constant returns (bool) {
1240         return call.wasCalled;
1241     }
1242 
1243     function isCancelled() constant returns (bool) {
1244         return call.isCancelled;
1245     }
1246 
1247     /*
1248      *  Claim API helpers
1249      */
1250     function getClaimAmountForBlock() constant returns (uint) {
1251         return CallLib.getClaimAmountForBlock(block.number);
1252     }
1253 
1254     function getClaimAmountForBlock(uint block_number) constant returns (uint) {
1255         return CallLib.getClaimAmountForBlock(block_number);
1256     }
1257 
1258     /*
1259      *  Call Data registration
1260      */
1261     function () returns (bool) {
1262         /*
1263          * Fallback to allow sending funds to this contract.
1264          * (also allows registering raw call data)
1265          */
1266         // only scheduler can register call data.
1267         if (msg.sender != schedulerAddress) return false;
1268         // cannot write over call data
1269         if (call.callData.length > 0) return false;
1270 
1271         var _state = state();
1272         if (_state != State.Pending && _state != State.Unclaimed && _state != State.Claimed) return false;
1273 
1274         call.callData = msg.data;
1275         return true;
1276     }
1277 
1278     function registerData() public returns (bool) {
1279         // only scheduler can register call data.
1280         if (msg.sender != schedulerAddress) return false;
1281         // cannot write over call data
1282         if (call.callData.length > 0) return false;
1283 
1284         var _state = state();
1285         if (_state != State.Pending && _state != State.Unclaimed && _state != State.Claimed) return false;
1286 
1287         CallLib.extractCallData(call, msg.data);
1288     }
1289 
1290     function firstClaimBlock() constant returns (uint) {
1291         return CallLib.firstClaimBlock();
1292     }
1293 
1294     function maxClaimBlock() constant returns (uint) {
1295         return CallLib.maxClaimBlock();
1296     }
1297 
1298     function lastClaimBlock() constant returns (uint) {
1299         return CallLib.lastClaimBlock();
1300     }
1301 
1302     function claim() public in_state(State.Unclaimed) returns (bool) {
1303         bool success = CallLib.claim(call, msg.sender, msg.value, basePayment);
1304         if (!success) {
1305             if (!AccountingLib.sendRobust(msg.sender, msg.value)) throw;
1306         }
1307         return success;
1308     }
1309 
1310     function checkExecutionAuthorization(address executor, uint block_number) constant returns (bool) {
1311         return CallLib.checkExecutionAuthorization(call, executor, block_number);
1312     }
1313 
1314     function sendSafe(address to_address, uint value) internal {
1315         CallLib.sendSafe(to_address, value);
1316     }
1317 
1318     function execute() public in_state(State.Callable) {
1319         uint start_gas = msg.gas;
1320 
1321         // Check that the call should be executed now.
1322         if (!beforeExecute(msg.sender, start_gas)) return;
1323 
1324         // Execute the call
1325         CallLib.execute(call, start_gas, msg.sender, getOverhead(), getExtraGas());
1326 
1327         // Any logic that needs to occur after the call has executed should
1328         // go in afterExecute
1329         afterExecute(msg.sender);
1330     }
1331 }
1332 
1333 
1334 contract FutureBlockCall is FutureCall {
1335     uint public targetBlock;
1336     uint8 public gracePeriod;
1337 
1338     uint constant CALL_API_VERSION = 2;
1339 
1340     function callAPIVersion() constant returns (uint) {
1341         return CALL_API_VERSION;
1342     }
1343 
1344     function FutureBlockCall(address _schedulerAddress,
1345                              uint _targetBlock,
1346                              uint8 _gracePeriod,
1347                              address _contractAddress,
1348                              bytes4 _abiSignature,
1349                              bytes _callData,
1350                              uint _callValue,
1351                              uint _requiredGas,
1352                              uint16 _requiredStackDepth,
1353                              uint _basePayment,
1354                              uint _baseDonation)
1355         FutureCall(_schedulerAddress, _requiredGas, _requiredStackDepth, _contractAddress, _abiSignature, _callData, _callValue, _basePayment, _baseDonation)
1356     {
1357         // parent contract FutureCall
1358         schedulerAddress = _schedulerAddress;
1359 
1360         targetBlock = _targetBlock;
1361         gracePeriod = _gracePeriod;
1362     }
1363 
1364     uint constant GAS_PER_DEPTH = 700;
1365 
1366     function __dig(uint n) constant returns (bool) {
1367         if (n == 0) return true;
1368         if (!address(this).callcode(bytes4(sha3("__dig(uint256)")), n - 1)) throw;
1369     }
1370 
1371 
1372     function beforeExecute(address executor, uint startGas) public returns (bool) {
1373         return CallLib.beforeExecuteForFutureBlockCall(call, executor, startGas);
1374     }
1375 
1376     function afterExecute(address executor) internal {
1377         // Refund any leftover funds.
1378         CallLib.sendSafe(schedulerAddress, address(this).balance);
1379     }
1380 
1381     uint constant GAS_OVERHEAD = 100000;
1382 
1383     function getOverhead() constant returns (uint) {
1384             return GAS_OVERHEAD;
1385     }
1386 
1387     uint constant EXTRA_GAS = 77000;
1388 
1389     function getExtraGas() constant returns (uint) {
1390             return EXTRA_GAS;
1391     }
1392 
1393     uint constant CLAIM_GROWTH_WINDOW = 240;
1394     uint constant MAXIMUM_CLAIM_WINDOW = 15;
1395     uint constant BEFORE_CALL_FREEZE_WINDOW = 10;
1396 
1397     function isCancellable() constant public returns (bool) {
1398         return CallLib.isCancellable(call, msg.sender);
1399     }
1400 
1401     function cancel() public {
1402         if (CallLib.isCancellable(call, msg.sender)) {
1403             CallLib.cancel(call, msg.sender);
1404         }
1405     }
1406 }
1407 
1408 
1409 library SchedulerLib {
1410     /*
1411      *  Address: 0xe54d323f9ef17c1f0dede47ecc86a9718fe5ea34
1412      */
1413     /*
1414      *  Call Scheduling API
1415      */
1416     function version() constant returns (uint16, uint16, uint16) {
1417         return (0, 7, 0);
1418     }
1419 
1420     // Ten minutes into the future.
1421     uint constant MIN_BLOCKS_IN_FUTURE = 10;
1422 
1423     // max of uint8
1424     uint8 constant DEFAULT_GRACE_PERIOD = 255;
1425 
1426     // The minimum gas required to execute a scheduled call on a function that
1427     // does almost nothing.  This is an approximation and assumes the worst
1428     // case scenario for gas consumption.
1429     //
1430     // Measured Minimum is closer to 80,000
1431     uint constant MINIMUM_CALL_GAS = 200000;
1432 
1433     // The minimum depth required to execute a call.
1434     uint16 constant MINIMUM_STACK_CHECK = 10;
1435 
1436     // The maximum possible depth that stack depth checking can achieve.
1437     // Actual check limit is 1021.  Actual call limit is 1021
1438     uint16 constant MAXIMUM_STACK_CHECK = 1000;
1439 
1440     event CallScheduled(address call_address);
1441 
1442     event CallRejected(address indexed schedulerAddress, bytes32 reason);
1443 
1444     uint constant CALL_WINDOW_SIZE = 16;
1445 
1446     function getMinimumStackCheck() constant returns (uint16) {
1447         return MINIMUM_STACK_CHECK;
1448     }
1449 
1450     function getMaximumStackCheck() constant returns (uint16) {
1451         return MAXIMUM_STACK_CHECK;
1452     }
1453 
1454     function getCallWindowSize() constant returns (uint) {
1455         return CALL_WINDOW_SIZE;
1456     }
1457 
1458     function getMinimumGracePeriod() constant returns (uint) {
1459         return 2 * CALL_WINDOW_SIZE;
1460     }
1461 
1462     function getDefaultGracePeriod() constant returns (uint8) {
1463         return DEFAULT_GRACE_PERIOD;
1464     }
1465 
1466     function getMinimumCallGas() constant returns (uint) {
1467         return MINIMUM_CALL_GAS;
1468     }
1469 
1470     function getMaximumCallGas() constant returns (uint) {
1471         return block.gaslimit - getMinimumCallGas();
1472     }
1473 
1474     function getMinimumCallCost(uint basePayment, uint baseDonation) constant returns (uint) {
1475         return 2 * (baseDonation + basePayment) + MINIMUM_CALL_GAS * tx.gasprice;
1476     }
1477 
1478     function getFirstSchedulableBlock() constant returns (uint) {
1479         return block.number + MIN_BLOCKS_IN_FUTURE;
1480     }
1481 
1482     function getMinimumEndowment(uint basePayment,
1483                                  uint baseDonation,
1484                                  uint callValue,
1485                                  uint requiredGas) constant returns (uint endowment) {
1486             endowment += tx.gasprice * requiredGas;
1487             endowment += 2 * (basePayment + baseDonation);
1488             endowment += callValue;
1489 
1490             return endowment;
1491     }
1492 
1493     struct CallConfig {
1494         address schedulerAddress;
1495         address contractAddress;
1496         bytes4 abiSignature;
1497         bytes callData;
1498         uint callValue;
1499         uint8 gracePeriod;
1500         uint16 requiredStackDepth;
1501         uint targetBlock;
1502         uint requiredGas;
1503         uint basePayment;
1504         uint baseDonation;
1505         uint endowment;
1506     }
1507 
1508     function scheduleCall(GroveLib.Index storage callIndex,
1509                           address schedulerAddress,
1510                           address contractAddress,
1511                           bytes4 abiSignature,
1512                           bytes callData,
1513                           uint8 gracePeriod,
1514                           uint16 requiredStackDepth,
1515                           uint callValue,
1516                           uint targetBlock,
1517                           uint requiredGas,
1518                           uint basePayment,
1519                           uint baseDonation,
1520                           uint endowment) public returns (address) {
1521         CallConfig memory callConfig = CallConfig({
1522             schedulerAddress: schedulerAddress,
1523             contractAddress: contractAddress,
1524             abiSignature: abiSignature,
1525             callData: callData,
1526             gracePeriod: gracePeriod,
1527             requiredStackDepth: requiredStackDepth,
1528             callValue: callValue,
1529             targetBlock: targetBlock,
1530             requiredGas: requiredGas,
1531             basePayment: basePayment,
1532             baseDonation: baseDonation,
1533             endowment: endowment,
1534         });
1535         return _scheduleCall(callIndex, callConfig);
1536     }
1537 
1538     function scheduleCall(GroveLib.Index storage callIndex,
1539                           address[2] addresses,
1540                           bytes4 abiSignature,
1541                           bytes callData,
1542                           uint8 gracePeriod,
1543                           uint16 requiredStackDepth,
1544                           uint[6] uints) public returns (address) {
1545         CallConfig memory callConfig = CallConfig({
1546             schedulerAddress: addresses[0],
1547             contractAddress: addresses[1],
1548             abiSignature: abiSignature,
1549             callData: callData,
1550             gracePeriod: gracePeriod,
1551             requiredStackDepth: requiredStackDepth,
1552             callValue: uints[0],
1553             targetBlock: uints[1],
1554             requiredGas: uints[2],
1555             basePayment: uints[3],
1556             baseDonation: uints[4],
1557             endowment: uints[5],
1558         });
1559         return _scheduleCall(callIndex, callConfig);
1560 
1561     }
1562 
1563     function _scheduleCall(GroveLib.Index storage callIndex, CallConfig memory callConfig) internal returns (address) {
1564         /*
1565         * Primary API for scheduling a call.
1566         *
1567         * - No sooner than MIN_BLOCKS_IN_FUTURE
1568         * - Grace Period must be longer than the minimum grace period.
1569         * - msg.value must be >= MIN_GAS * tx.gasprice + 2 * (baseDonation + basePayment)
1570         */
1571         bytes32 reason;
1572 
1573         if (callConfig.targetBlock < block.number + MIN_BLOCKS_IN_FUTURE) {
1574             // Don't allow scheduling further than
1575             // MIN_BLOCKS_IN_FUTURE
1576             reason = "TOO_SOON";
1577         }
1578         else if (getMinimumStackCheck() > callConfig.requiredStackDepth || callConfig.requiredStackDepth > getMaximumStackCheck()) {
1579             // Cannot require stack depth greater than MAXIMUM_STACK_CHECK or
1580             // less than MINIMUM_STACK_CHECK
1581             reason = "STACK_CHECK_OUT_OF_RANGE";
1582         }
1583         else if (callConfig.gracePeriod < getMinimumGracePeriod()) {
1584             reason = "GRACE_TOO_SHORT";
1585         }
1586         else if (callConfig.requiredGas < getMinimumCallGas() || callConfig.requiredGas > getMaximumCallGas()) {
1587             reason = "REQUIRED_GAS_OUT_OF_RANGE";
1588         }
1589         else if (callConfig.endowment < getMinimumEndowment(callConfig.basePayment, callConfig.baseDonation, callConfig.callValue, callConfig.requiredGas)) {
1590             reason = "INSUFFICIENT_FUNDS";
1591         }
1592 
1593         if (reason != 0x0) {
1594             CallRejected(callConfig.schedulerAddress, reason);
1595             AccountingLib.sendRobust(callConfig.schedulerAddress, callConfig.endowment);
1596             return;
1597         }
1598 
1599         var call = (new FutureBlockCall).value(callConfig.endowment)(
1600                 callConfig.schedulerAddress,
1601                 callConfig.targetBlock,
1602                 callConfig.gracePeriod,
1603                 callConfig.contractAddress,
1604                 callConfig.abiSignature,
1605                 callConfig.callData,
1606                 callConfig.callValue,
1607                 callConfig.requiredGas,
1608                 callConfig.requiredStackDepth,
1609                 callConfig.basePayment,
1610                 callConfig.baseDonation
1611         );
1612 
1613         // Put the call into the grove index.
1614         GroveLib.insert(callIndex, bytes32(address(call)), int(call.targetBlock()));
1615 
1616         CallScheduled(address(call));
1617 
1618         return address(call);
1619     }
1620 }
1621 
1622 
1623 contract Scheduler {
1624     /*
1625      *  Address: 0x6c8f2a135f6ed072de4503bd7c4999a1a17f824b
1626      */
1627 
1628     // The starting value (0.01 USD at 1eth:$2 exchange rate)
1629     uint constant INITIAL_DEFAUlT_PAYMENT = 5 finney;
1630 
1631     uint public defaultPayment;
1632 
1633     function Scheduler() {
1634         defaultPayment = INITIAL_DEFAUlT_PAYMENT;
1635     }
1636 
1637     // callIndex tracks the ordering of scheduled calls based on their block numbers.
1638     GroveLib.Index callIndex;
1639 
1640     uint constant CALL_API_VERSION = 7;
1641 
1642     function callAPIVersion() constant returns (uint) {
1643         return CALL_API_VERSION;
1644     }
1645 
1646     /*
1647      *  Call Scheduling
1648      */
1649     function getMinimumGracePeriod() constant returns (uint) {
1650         return SchedulerLib.getMinimumGracePeriod();
1651     }
1652 
1653     // Default payment and donation values
1654     modifier only_known_call { if (isKnownCall(msg.sender)) _ }
1655 
1656     function updateDefaultPayment() public only_known_call {
1657         var call = FutureBlockCall(msg.sender);
1658         var basePayment = call.basePayment();
1659 
1660         if (call.wasCalled() && call.claimer() != 0x0 && basePayment > 0 && defaultPayment > 1) {
1661             var index = call.claimAmount() * 100 / basePayment;
1662 
1663             if (index > 66 && defaultPayment <= basePayment) {
1664                 // increase by 0.01%
1665                 defaultPayment = defaultPayment * 10001 / 10000;
1666             }
1667             else if (index < 33 && defaultPayment >= basePayment) {
1668                 // decrease by 0.01%
1669                 defaultPayment = defaultPayment * 9999 / 10000;
1670             }
1671         }
1672     }
1673 
1674     function getDefaultDonation() constant returns (uint) {
1675         return defaultPayment / 100;
1676     }
1677 
1678     function getMinimumCallGas() constant returns (uint) {
1679         return SchedulerLib.getMinimumCallGas();
1680     }
1681 
1682     function getMaximumCallGas() constant returns (uint) {
1683         return SchedulerLib.getMaximumCallGas();
1684     }
1685 
1686     function getMinimumEndowment() constant returns (uint) {
1687         return SchedulerLib.getMinimumEndowment(defaultPayment, getDefaultDonation(), 0, getDefaultRequiredGas());
1688     }
1689 
1690     function getMinimumEndowment(uint basePayment) constant returns (uint) {
1691         return SchedulerLib.getMinimumEndowment(basePayment, getDefaultDonation(), 0, getDefaultRequiredGas());
1692     }
1693 
1694     function getMinimumEndowment(uint basePayment, uint baseDonation) constant returns (uint) {
1695         return SchedulerLib.getMinimumEndowment(basePayment, baseDonation, 0, getDefaultRequiredGas());
1696     }
1697 
1698     function getMinimumEndowment(uint basePayment, uint baseDonation, uint callValue) constant returns (uint) {
1699         return SchedulerLib.getMinimumEndowment(basePayment, baseDonation, callValue, getDefaultRequiredGas());
1700     }
1701 
1702     function getMinimumEndowment(uint basePayment, uint baseDonation, uint callValue, uint requiredGas) constant returns (uint) {
1703         return SchedulerLib.getMinimumEndowment(basePayment, baseDonation, callValue, requiredGas);
1704     }
1705 
1706     function isKnownCall(address callAddress) constant returns (bool) {
1707         return GroveLib.exists(callIndex, bytes32(callAddress));
1708     }
1709 
1710     function getFirstSchedulableBlock() constant returns (uint) {
1711         return SchedulerLib.getFirstSchedulableBlock();
1712     }
1713 
1714     function getMinimumStackCheck() constant returns (uint16) {
1715         return SchedulerLib.getMinimumStackCheck();
1716     }
1717 
1718     function getMaximumStackCheck() constant returns (uint16) {
1719         return SchedulerLib.getMaximumStackCheck();
1720     }
1721 
1722     function getDefaultStackCheck() constant returns (uint16) {
1723         return getMinimumStackCheck();
1724     }
1725 
1726     function getDefaultRequiredGas() constant returns (uint) {
1727         return SchedulerLib.getMinimumCallGas();
1728     }
1729 
1730     function getDefaultGracePeriod() constant returns (uint8) {
1731         return SchedulerLib.getDefaultGracePeriod();
1732     }
1733 
1734     bytes constant EMPTY_CALL_DATA = "";
1735     uint constant DEFAULT_CALL_VALUE = 0;
1736     bytes4 constant DEFAULT_FN_SIGNATURE = 0x0000;
1737 
1738     function scheduleCall() public returns (address) {
1739         return SchedulerLib.scheduleCall(
1740             callIndex,
1741             msg.sender, msg.sender,
1742             DEFAULT_FN_SIGNATURE, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1743             DEFAULT_CALL_VALUE, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1744         );
1745     }
1746 
1747     function scheduleCall(uint targetBlock) public returns (address) {
1748         return SchedulerLib.scheduleCall(
1749             callIndex,
1750             msg.sender, msg.sender,
1751             DEFAULT_FN_SIGNATURE, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1752             DEFAULT_CALL_VALUE, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1753         );
1754     }
1755 
1756     function scheduleCall(bytes callData) public returns (address) {
1757         return SchedulerLib.scheduleCall(
1758             callIndex,
1759             msg.sender, msg.sender,
1760             DEFAULT_FN_SIGNATURE, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1761             DEFAULT_CALL_VALUE, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1762         );
1763     }
1764 
1765     function scheduleCall(bytes4 abiSignature,
1766                           bytes callData) public returns (address) {
1767         return SchedulerLib.scheduleCall(
1768             callIndex,
1769             msg.sender, msg.sender,
1770             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1771             DEFAULT_CALL_VALUE, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1772         );
1773     }
1774 
1775     function scheduleCall(bytes4 abiSignature) public returns (address) {
1776         return SchedulerLib.scheduleCall(
1777             callIndex,
1778             msg.sender, msg.sender,
1779             abiSignature, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1780             DEFAULT_CALL_VALUE, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1781         );
1782     }
1783 
1784     function scheduleCall(address contractAddress) public returns (address) {
1785         return SchedulerLib.scheduleCall(
1786             callIndex,
1787             msg.sender, contractAddress,
1788             DEFAULT_FN_SIGNATURE, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1789             DEFAULT_CALL_VALUE, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1790         );
1791     }
1792 
1793     function scheduleCall(address contractAddress,
1794                           bytes4 abiSignature) public returns (address) {
1795         return SchedulerLib.scheduleCall(
1796             callIndex,
1797             msg.sender, contractAddress,
1798             abiSignature, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1799             DEFAULT_CALL_VALUE, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1800         );
1801     }
1802 
1803     function scheduleCall(address contractAddress,
1804                           uint callValue,
1805                           bytes4 abiSignature) public returns (address) {
1806         return SchedulerLib.scheduleCall(
1807             callIndex,
1808             msg.sender, contractAddress,
1809             abiSignature, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1810             callValue, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1811         );
1812     }
1813 
1814     function scheduleCall(address contractAddress,
1815                           bytes4 abiSignature,
1816                           bytes callData) public returns (address) {
1817         return SchedulerLib.scheduleCall(
1818             callIndex,
1819             msg.sender, contractAddress,
1820             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1821             DEFAULT_CALL_VALUE, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1822         );
1823     }
1824 
1825     function scheduleCall(address contractAddress,
1826                           bytes4 abiSignature,
1827                           uint callValue,
1828                           bytes callData) public returns (address) {
1829         return SchedulerLib.scheduleCall(
1830             callIndex,
1831             msg.sender, contractAddress,
1832             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1833             callValue, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1834         );
1835     }
1836 
1837     function scheduleCall(uint callValue,
1838                           address contractAddress) public returns (address) {
1839         return SchedulerLib.scheduleCall(
1840             callIndex,
1841             msg.sender, contractAddress,
1842             DEFAULT_FN_SIGNATURE, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1843             callValue, getFirstSchedulableBlock(), getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1844         );
1845     }
1846 
1847     function scheduleCall(address contractAddress,
1848                           uint targetBlock) public returns (address) {
1849         return SchedulerLib.scheduleCall(
1850             callIndex,
1851             msg.sender, contractAddress,
1852             DEFAULT_FN_SIGNATURE, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1853             DEFAULT_CALL_VALUE, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1854         );
1855     }
1856 
1857     function scheduleCall(address contractAddress,
1858                           uint targetBlock,
1859                           uint callValue) public returns (address) {
1860         return SchedulerLib.scheduleCall(
1861             callIndex,
1862             msg.sender, contractAddress,
1863             DEFAULT_FN_SIGNATURE, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1864             callValue, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1865         );
1866     }
1867 
1868     function scheduleCall(bytes4 abiSignature,
1869                           uint targetBlock) public returns (address) {
1870         return SchedulerLib.scheduleCall(
1871             callIndex,
1872             msg.sender, msg.sender,
1873             abiSignature, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1874             DEFAULT_CALL_VALUE, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1875         );
1876     }
1877 
1878     function scheduleCall(address contractAddress,
1879                           bytes4 abiSignature,
1880                           uint targetBlock) public returns (address) {
1881         return SchedulerLib.scheduleCall(
1882             callIndex,
1883             msg.sender, contractAddress,
1884             abiSignature, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1885             DEFAULT_CALL_VALUE, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1886         );
1887     }
1888 
1889     function scheduleCall(bytes4 abiSignature,
1890                           bytes callData,
1891                           uint targetBlock) public returns (address) {
1892         return SchedulerLib.scheduleCall(
1893             callIndex,
1894             msg.sender, msg.sender,
1895             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1896             DEFAULT_CALL_VALUE, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1897         );
1898     }
1899 
1900     function scheduleCall(address contractAddress,
1901                           bytes4 abiSignature,
1902                           bytes callData,
1903                           uint targetBlock) public returns (address) {
1904         return SchedulerLib.scheduleCall(
1905             callIndex,
1906             msg.sender, contractAddress,
1907             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1908             DEFAULT_CALL_VALUE, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1909         );
1910     }
1911 
1912     function scheduleCall(address contractAddress,
1913                           bytes4 abiSignature,
1914                           uint callValue,
1915                           bytes callData,
1916                           uint targetBlock) public returns (address) {
1917         return SchedulerLib.scheduleCall(
1918             callIndex,
1919             msg.sender, contractAddress,
1920             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1921             callValue, targetBlock, getDefaultRequiredGas(), defaultPayment, getDefaultDonation(), msg.value
1922         );
1923     }
1924 
1925     function scheduleCall(bytes4 abiSignature,
1926                           uint targetBlock,
1927                           uint requiredGas) public returns (address) {
1928         return SchedulerLib.scheduleCall(
1929             callIndex,
1930             msg.sender, msg.sender,
1931             abiSignature, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1932             DEFAULT_CALL_VALUE, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
1933         );
1934     }
1935 
1936     function scheduleCall(address contractAddress,
1937                           bytes4 abiSignature,
1938                           uint targetBlock,
1939                           uint requiredGas) public returns (address) {
1940         return SchedulerLib.scheduleCall(
1941             callIndex,
1942             msg.sender, contractAddress,
1943             abiSignature, EMPTY_CALL_DATA, getDefaultGracePeriod(), getDefaultStackCheck(),
1944             DEFAULT_CALL_VALUE, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
1945         );
1946     }
1947 
1948     function scheduleCall(bytes4 abiSignature,
1949                           bytes callData,
1950                           uint targetBlock,
1951                           uint requiredGas) public returns (address) {
1952         return SchedulerLib.scheduleCall(
1953             callIndex,
1954             msg.sender, msg.sender,
1955             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1956             DEFAULT_CALL_VALUE, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
1957         );
1958     }
1959 
1960     function scheduleCall(address contractAddress,
1961                           bytes4 abiSignature,
1962                           bytes callData,
1963                           uint targetBlock,
1964                           uint requiredGas) public returns (address) {
1965         return SchedulerLib.scheduleCall(
1966             callIndex,
1967             msg.sender, contractAddress,
1968             abiSignature, callData, getDefaultGracePeriod(), getDefaultStackCheck(),
1969             DEFAULT_CALL_VALUE, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
1970         );
1971     }
1972 
1973     function scheduleCall(bytes4 abiSignature,
1974                           uint targetBlock,
1975                           uint requiredGas,
1976                           uint8 gracePeriod) public returns (address) {
1977         return SchedulerLib.scheduleCall(
1978             callIndex,
1979             msg.sender, msg.sender,
1980             abiSignature, EMPTY_CALL_DATA, gracePeriod, getDefaultStackCheck(),
1981             DEFAULT_CALL_VALUE, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
1982         );
1983     }
1984 
1985     function scheduleCall(address contractAddress,
1986                           uint callValue,
1987                           bytes4 abiSignature,
1988                           uint targetBlock,
1989                           uint requiredGas,
1990                           uint8 gracePeriod) public returns (address) {
1991         return SchedulerLib.scheduleCall(
1992             callIndex,
1993             msg.sender, contractAddress,
1994             abiSignature, EMPTY_CALL_DATA, gracePeriod, getDefaultStackCheck(),
1995             callValue, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
1996         );
1997     }
1998 
1999     function scheduleCall(address contractAddress,
2000                           bytes4 abiSignature,
2001                           uint targetBlock,
2002                           uint requiredGas,
2003                           uint8 gracePeriod) public returns (address) {
2004         return SchedulerLib.scheduleCall(
2005             callIndex,
2006             msg.sender, contractAddress,
2007             abiSignature, EMPTY_CALL_DATA, gracePeriod, getDefaultStackCheck(),
2008             DEFAULT_CALL_VALUE, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
2009         );
2010     }
2011 
2012     function scheduleCall(address contractAddress,
2013                           bytes4 abiSignature,
2014                           bytes callData,
2015                           uint targetBlock,
2016                           uint requiredGas,
2017                           uint8 gracePeriod) public returns (address) {
2018         return SchedulerLib.scheduleCall(
2019             callIndex,
2020             msg.sender, contractAddress,
2021             abiSignature, callData, gracePeriod, getDefaultStackCheck(),
2022             DEFAULT_CALL_VALUE, targetBlock, requiredGas, defaultPayment, getDefaultDonation(), msg.value
2023         );
2024     }
2025 
2026     function scheduleCall(bytes4 abiSignature,
2027                           uint targetBlock,
2028                           uint requiredGas,
2029                           uint8 gracePeriod,
2030                           uint basePayment) public returns (address) {
2031         return SchedulerLib.scheduleCall(
2032             callIndex,
2033             msg.sender, msg.sender,
2034             abiSignature, EMPTY_CALL_DATA, gracePeriod, getDefaultStackCheck(),
2035             DEFAULT_CALL_VALUE, targetBlock, requiredGas, basePayment, getDefaultDonation(), msg.value
2036         );
2037     }
2038 
2039     function scheduleCall(address contractAddress,
2040                           uint callValue,
2041                           bytes4 abiSignature,
2042                           uint targetBlock,
2043                           uint requiredGas,
2044                           uint8 gracePeriod,
2045                           uint basePayment) public returns (address) {
2046         return SchedulerLib.scheduleCall(
2047             callIndex,
2048             msg.sender, contractAddress,
2049             abiSignature, EMPTY_CALL_DATA, gracePeriod, getDefaultStackCheck(),
2050             callValue, targetBlock, requiredGas, basePayment, getDefaultDonation(), msg.value
2051         );
2052     }
2053 
2054     function scheduleCall(address contractAddress,
2055                           bytes4 abiSignature,
2056                           uint targetBlock,
2057                           uint requiredGas,
2058                           uint8 gracePeriod,
2059                           uint basePayment) public returns (address) {
2060         return SchedulerLib.scheduleCall(
2061             callIndex,
2062             msg.sender, contractAddress,
2063             abiSignature, EMPTY_CALL_DATA, gracePeriod, getDefaultStackCheck(),
2064             DEFAULT_CALL_VALUE, targetBlock, requiredGas, basePayment, getDefaultDonation(), msg.value
2065         );
2066     }
2067 
2068     function scheduleCall(bytes4 abiSignature,
2069                           bytes callData,
2070                           uint targetBlock,
2071                           uint requiredGas,
2072                           uint8 gracePeriod,
2073                           uint basePayment) public returns (address) {
2074         return SchedulerLib.scheduleCall(
2075             callIndex,
2076             msg.sender, msg.sender,
2077             abiSignature, callData, gracePeriod, getDefaultStackCheck(),
2078             DEFAULT_CALL_VALUE, targetBlock, requiredGas, basePayment, getDefaultDonation(), msg.value
2079         );
2080     }
2081 
2082     function scheduleCall(address contractAddress,
2083                           bytes4 abiSignature,
2084                           bytes callData,
2085                           uint8 gracePeriod,
2086                           uint[4] args) public returns (address) {
2087         return SchedulerLib.scheduleCall(
2088             callIndex,
2089             msg.sender, contractAddress,
2090             abiSignature, callData, gracePeriod, getDefaultStackCheck(),
2091             // callValue, targetBlock, requiredGas, basePayment
2092             args[0], args[1], args[2], args[3], getDefaultDonation(), msg.value
2093         );
2094     }
2095 
2096     function scheduleCall(address contractAddress,
2097                           bytes4 abiSignature,
2098                           bytes callData,
2099                           uint targetBlock,
2100                           uint requiredGas,
2101                           uint8 gracePeriod,
2102                           uint basePayment) public returns (address) {
2103         return SchedulerLib.scheduleCall(
2104             callIndex,
2105             msg.sender, contractAddress,
2106             abiSignature, callData, gracePeriod, getDefaultStackCheck(),
2107             DEFAULT_CALL_VALUE, targetBlock, requiredGas, basePayment, getDefaultDonation(), msg.value
2108         );
2109     }
2110 
2111     function scheduleCall(bytes4 abiSignature,
2112                           bytes callData,
2113                           uint16 requiredStackDepth,
2114                           uint8 gracePeriod,
2115                           uint callValue,
2116                           uint targetBlock,
2117                           uint requiredGas,
2118                           uint basePayment,
2119                           uint baseDonation) public returns (address) {
2120         return SchedulerLib.scheduleCall(
2121             callIndex,
2122             msg.sender, msg.sender,
2123             abiSignature, callData, gracePeriod, requiredStackDepth,
2124             callValue, targetBlock, requiredGas, basePayment, baseDonation, msg.value
2125         );
2126     }
2127 
2128     function scheduleCall(address contractAddress,
2129                           bytes4 abiSignature,
2130                           bytes callData,
2131                           uint16 requiredStackDepth,
2132                           uint8 gracePeriod,
2133                           uint[5] args) public returns (address) {
2134         return SchedulerLib.scheduleCall(
2135             callIndex,
2136             [msg.sender, contractAddress],
2137             abiSignature, callData, gracePeriod, requiredStackDepth,
2138             // callValue, targetBlock, requiredGas, basePayment, baseDonation
2139             [args[0], args[1], args[2], args[3], args[4], msg.value]
2140         );
2141     }
2142 
2143     /*
2144      *  Next Call API
2145      */
2146     function getCallWindowSize() constant returns (uint) {
2147             return SchedulerLib.getCallWindowSize();
2148     }
2149 
2150     function getNextCall(uint blockNumber) constant returns (address) {
2151             return address(GroveLib.query(callIndex, ">=", int(blockNumber)));
2152     }
2153 
2154     function getNextCallSibling(address callAddress) constant returns (address) {
2155             return address(GroveLib.getNextNode(callIndex, bytes32(callAddress)));
2156     }
2157 }