1 // Grove v0.2
2 
3 
4 /// @title GroveLib - Library for queriable indexed ordered data.
5 /// @author PiperMerriam - <pipermerriam@gmail.com>
6 library GroveLib {
7         /*
8          *  Indexes for ordered data
9          *
10          *  Address: 0xd07ce4329b27eb8896c51458468d98a0e4c0394c
11          */
12         struct Index {
13                 bytes32 id;
14                 bytes32 name;
15                 bytes32 root;
16                 mapping (bytes32 => Node) nodes;
17         }
18 
19         struct Node {
20                 bytes32 nodeId;
21                 bytes32 indexId;
22                 bytes32 id;
23                 int value;
24                 bytes32 parent;
25                 bytes32 left;
26                 bytes32 right;
27                 uint height;
28         }
29 
30         /// @dev This is merely a shortcut for `sha3(owner, indexName)`
31         /// @param owner The address of the owner of this index.
32         /// @param indexName The human readable name for this index.
33         function computeIndexId(address owner, bytes32 indexName) constant returns (bytes32) {
34                 return sha3(owner, indexName);
35         }
36 
37         /// @dev This is merely a shortcut for `sha3(indexId, id)`
38         /// @param indexId The id for the index the node belongs to.
39         /// @param id The unique identifier for the data this node represents.
40         function computeNodeId(bytes32 indexId, bytes32 id) constant returns (bytes32) {
41                 return sha3(indexId, id);
42         }
43 
44         function max(uint a, uint b) internal returns (uint) {
45             if (a >= b) {
46                 return a;
47             }
48             return b;
49         }
50 
51         /*
52          *  Node getters
53          */
54         /// @dev Retrieve the unique identifier for the node.
55         /// @param index The index that the node is part of.
56         /// @param nodeId The id for the node to be looked up.
57         function getNodeId(Index storage index, bytes32 nodeId) constant returns (bytes32) {
58             return index.nodes[nodeId].id;
59         }
60 
61         /// @dev Retrieve the index id for the node.
62         /// @param index The index that the node is part of.
63         /// @param nodeId The id for the node to be looked up.
64         function getNodeIndexId(Index storage index, bytes32 nodeId) constant returns (bytes32) {
65             return index.nodes[nodeId].indexId;
66         }
67 
68         /// @dev Retrieve the value for the node.
69         /// @param index The index that the node is part of.
70         /// @param nodeId The id for the node to be looked up.
71         function getNodeValue(Index storage index, bytes32 nodeId) constant returns (int) {
72             return index.nodes[nodeId].value;
73         }
74 
75         /// @dev Retrieve the height of the node.
76         /// @param index The index that the node is part of.
77         /// @param nodeId The id for the node to be looked up.
78         function getNodeHeight(Index storage index, bytes32 nodeId) constant returns (uint) {
79             return index.nodes[nodeId].height;
80         }
81 
82         /// @dev Retrieve the parent id of the node.
83         /// @param index The index that the node is part of.
84         /// @param nodeId The id for the node to be looked up.
85         function getNodeParent(Index storage index, bytes32 nodeId) constant returns (bytes32) {
86             return index.nodes[nodeId].parent;
87         }
88 
89         /// @dev Retrieve the left child id of the node.
90         /// @param index The index that the node is part of.
91         /// @param nodeId The id for the node to be looked up.
92         function getNodeLeftChild(Index storage index, bytes32 nodeId) constant returns (bytes32) {
93             return index.nodes[nodeId].left;
94         }
95 
96         /// @dev Retrieve the right child id of the node.
97         /// @param index The index that the node is part of.
98         /// @param nodeId The id for the node to be looked up.
99         function getNodeRightChild(Index storage index, bytes32 nodeId) constant returns (bytes32) {
100             return index.nodes[nodeId].right;
101         }
102 
103         /// @dev Retrieve the node id of the next node in the tree.
104         /// @param index The index that the node is part of.
105         /// @param nodeId The id for the node to be looked up.
106         function getPreviousNode(Index storage index, bytes32 nodeId) constant returns (bytes32) {
107             Node storage currentNode = index.nodes[nodeId];
108 
109             if (currentNode.nodeId == 0x0) {
110                 // Unknown node, just return 0x0;
111                 return 0x0;
112             }
113 
114             Node memory child;
115 
116             if (currentNode.left != 0x0) {
117                 // Trace left to latest child in left tree.
118                 child = index.nodes[currentNode.left];
119 
120                 while (child.right != 0) {
121                     child = index.nodes[child.right];
122                 }
123                 return child.nodeId;
124             }
125 
126             if (currentNode.parent != 0x0) {
127                 // Now we trace back up through parent relationships, looking
128                 // for a link where the child is the right child of it's
129                 // parent.
130                 Node storage parent = index.nodes[currentNode.parent];
131                 child = currentNode;
132 
133                 while (true) {
134                     if (parent.right == child.nodeId) {
135                         return parent.nodeId;
136                     }
137 
138                     if (parent.parent == 0x0) {
139                         break;
140                     }
141                     child = parent;
142                     parent = index.nodes[parent.parent];
143                 }
144             }
145 
146             // This is the first node, and has no previous node.
147             return 0x0;
148         }
149 
150         /// @dev Retrieve the node id of the previous node in the tree.
151         /// @param index The index that the node is part of.
152         /// @param nodeId The id for the node to be looked up.
153         function getNextNode(Index storage index, bytes32 nodeId) constant returns (bytes32) {
154             Node storage currentNode = index.nodes[nodeId];
155 
156             if (currentNode.nodeId == 0x0) {
157                 // Unknown node, just return 0x0;
158                 return 0x0;
159             }
160 
161             Node memory child;
162 
163             if (currentNode.right != 0x0) {
164                 // Trace right to earliest child in right tree.
165                 child = index.nodes[currentNode.right];
166 
167                 while (child.left != 0) {
168                     child = index.nodes[child.left];
169                 }
170                 return child.nodeId;
171             }
172 
173             if (currentNode.parent != 0x0) {
174                 // if the node is the left child of it's parent, then the
175                 // parent is the next one.
176                 Node storage parent = index.nodes[currentNode.parent];
177                 child = currentNode;
178 
179                 while (true) {
180                     if (parent.left == child.nodeId) {
181                         return parent.nodeId;
182                     }
183 
184                     if (parent.parent == 0x0) {
185                         break;
186                     }
187                     child = parent;
188                     parent = index.nodes[parent.parent];
189                 }
190 
191                 // Now we need to trace all the way up checking to see if any parent is the 
192             }
193 
194             // This is the final node.
195             return 0x0;
196         }
197 
198 
199         /// @dev Updates or Inserts the id into the index at its appropriate location based on the value provided.
200         /// @param index The index that the node is part of.
201         /// @param id The unique identifier of the data element the index node will represent.
202         /// @param value The value of the data element that represents it's total ordering with respect to other elementes.
203         function insert(Index storage index, bytes32 id, int value) public {
204                 bytes32 nodeId = computeNodeId(index.id, id);
205 
206                 if (index.nodes[nodeId].nodeId == nodeId) {
207                     // A node with this id already exists.  If the value is
208                     // the same, then just return early, otherwise, remove it
209                     // and reinsert it.
210                     if (index.nodes[nodeId].value == value) {
211                         return;
212                     }
213                     remove(index, id);
214                 }
215 
216                 uint leftHeight;
217                 uint rightHeight;
218 
219                 bytes32 previousNodeId = 0x0;
220 
221                 bytes32 rootNodeId = index.root;
222 
223                 if (rootNodeId == 0x0) {
224                     rootNodeId = nodeId;
225                     index.root = nodeId;
226                 }
227                 Node storage currentNode = index.nodes[rootNodeId];
228 
229                 // Do insertion
230                 while (true) {
231                     if (currentNode.indexId == 0x0) {
232                         // This is a new unpopulated node.
233                         currentNode.nodeId = nodeId;
234                         currentNode.parent = previousNodeId;
235                         currentNode.indexId = index.id;
236                         currentNode.id = id;
237                         currentNode.value = value;
238                         break;
239                     }
240 
241                     // Set the previous node id.
242                     previousNodeId = currentNode.nodeId;
243 
244                     // The new node belongs in the right subtree
245                     if (value >= currentNode.value) {
246                         if (currentNode.right == 0x0) {
247                             currentNode.right = nodeId;
248                         }
249                         currentNode = index.nodes[currentNode.right];
250                         continue;
251                     }
252 
253                     // The new node belongs in the left subtree.
254                     if (currentNode.left == 0x0) {
255                         currentNode.left = nodeId;
256                     }
257                     currentNode = index.nodes[currentNode.left];
258                 }
259 
260                 // Rebalance the tree
261                 _rebalanceTree(index, currentNode.nodeId);
262         }
263 
264         /// @dev Checks whether a node for the given unique identifier exists within the given index.
265         /// @param index The index that should be searched
266         /// @param id The unique identifier of the data element to check for.
267         function exists(Index storage index, bytes32 id) constant returns (bool) {
268             bytes32 nodeId = computeNodeId(index.id, id);
269             return (index.nodes[nodeId].nodeId == nodeId);
270         }
271 
272         /// @dev Remove the node for the given unique identifier from the index.
273         /// @param index The index that should be removed
274         /// @param id The unique identifier of the data element to remove.
275         function remove(Index storage index, bytes32 id) public {
276             bytes32 nodeId = computeNodeId(index.id, id);
277             
278             Node storage replacementNode;
279             Node storage parent;
280             Node storage child;
281             bytes32 rebalanceOrigin;
282 
283             Node storage nodeToDelete = index.nodes[nodeId];
284 
285             if (nodeToDelete.id != id) {
286                 // The id does not exist in the tree.
287                 return;
288             }
289 
290             if (nodeToDelete.left != 0x0 || nodeToDelete.right != 0x0) {
291                 // This node is not a leaf node and thus must replace itself in
292                 // it's tree by either the previous or next node.
293                 if (nodeToDelete.left != 0x0) {
294                     // This node is guaranteed to not have a right child.
295                     replacementNode = index.nodes[getPreviousNode(index, nodeToDelete.nodeId)];
296                 }
297                 else {
298                     // This node is guaranteed to not have a left child.
299                     replacementNode = index.nodes[getNextNode(index, nodeToDelete.nodeId)];
300                 }
301                 // The replacementNode is guaranteed to have a parent.
302                 parent = index.nodes[replacementNode.parent];
303 
304                 // Keep note of the location that our tree rebalancing should
305                 // start at.
306                 rebalanceOrigin = replacementNode.nodeId;
307 
308                 // Join the parent of the replacement node with any subtree of
309                 // the replacement node.  We can guarantee that the replacement
310                 // node has at most one subtree because of how getNextNode and
311                 // getPreviousNode are used.
312                 if (parent.left == replacementNode.nodeId) {
313                     parent.left = replacementNode.right;
314                     if (replacementNode.right != 0x0) {
315                         child = index.nodes[replacementNode.right];
316                         child.parent = parent.nodeId;
317                     }
318                 }
319                 if (parent.right == replacementNode.nodeId) {
320                     parent.right = replacementNode.left;
321                     if (replacementNode.left != 0x0) {
322                         child = index.nodes[replacementNode.left];
323                         child.parent = parent.nodeId;
324                     }
325                 }
326 
327                 // Now we replace the nodeToDelete with the replacementNode.
328                 // This includes parent/child relationships for all of the
329                 // parent, the left child, and the right child.
330                 replacementNode.parent = nodeToDelete.parent;
331                 if (nodeToDelete.parent != 0x0) {
332                     parent = index.nodes[nodeToDelete.parent];
333                     if (parent.left == nodeToDelete.nodeId) {
334                         parent.left = replacementNode.nodeId;
335                     }
336                     if (parent.right == nodeToDelete.nodeId) {
337                         parent.right = replacementNode.nodeId;
338                     }
339                 }
340                 else {
341                     // If the node we are deleting is the root node so update
342                     // the indexId to root node mapping.
343                     index.root = replacementNode.nodeId;
344                 }
345 
346                 replacementNode.left = nodeToDelete.left;
347                 if (nodeToDelete.left != 0x0) {
348                     child = index.nodes[nodeToDelete.left];
349                     child.parent = replacementNode.nodeId;
350                 }
351 
352                 replacementNode.right = nodeToDelete.right;
353                 if (nodeToDelete.right != 0x0) {
354                     child = index.nodes[nodeToDelete.right];
355                     child.parent = replacementNode.nodeId;
356                 }
357             }
358             else if (nodeToDelete.parent != 0x0) {
359                 // The node being deleted is a leaf node so we only erase it's
360                 // parent linkage.
361                 parent = index.nodes[nodeToDelete.parent];
362 
363                 if (parent.left == nodeToDelete.nodeId) {
364                     parent.left = 0x0;
365                 }
366                 if (parent.right == nodeToDelete.nodeId) {
367                     parent.right = 0x0;
368                 }
369 
370                 // keep note of where the rebalancing should begin.
371                 rebalanceOrigin = parent.nodeId;
372             }
373             else {
374                 // This is both a leaf node and the root node, so we need to
375                 // unset the root node pointer.
376                 index.root = 0x0;
377             }
378 
379             // Now we zero out all of the fields on the nodeToDelete.
380             nodeToDelete.id = 0x0;
381             nodeToDelete.nodeId = 0x0;
382             nodeToDelete.indexId = 0x0;
383             nodeToDelete.value = 0;
384             nodeToDelete.parent = 0x0;
385             nodeToDelete.left = 0x0;
386             nodeToDelete.right = 0x0;
387 
388             // Walk back up the tree rebalancing
389             if (rebalanceOrigin != 0x0) {
390                 _rebalanceTree(index, rebalanceOrigin);
391             }
392         }
393 
394         bytes2 constant GT = ">";
395         bytes2 constant LT = "<";
396         bytes2 constant GTE = ">=";
397         bytes2 constant LTE = "<=";
398         bytes2 constant EQ = "==";
399 
400         function _compare(int left, bytes2 operator, int right) internal returns (bool) {
401             if (operator == GT) {
402                 return (left > right);
403             }
404             if (operator == LT) {
405                 return (left < right);
406             }
407             if (operator == GTE) {
408                 return (left >= right);
409             }
410             if (operator == LTE) {
411                 return (left <= right);
412             }
413             if (operator == EQ) {
414                 return (left == right);
415             }
416 
417             // Invalid operator.
418             throw;
419         }
420 
421         function _getMaximum(Index storage index, bytes32 nodeId) internal returns (int) {
422                 Node storage currentNode = index.nodes[nodeId];
423 
424                 while (true) {
425                     if (currentNode.right == 0x0) {
426                         return currentNode.value;
427                     }
428                     currentNode = index.nodes[currentNode.right];
429                 }
430         }
431 
432         function _getMinimum(Index storage index, bytes32 nodeId) internal returns (int) {
433                 Node storage currentNode = index.nodes[nodeId];
434 
435                 while (true) {
436                     if (currentNode.left == 0x0) {
437                         return currentNode.value;
438                     }
439                     currentNode = index.nodes[currentNode.left];
440                 }
441         }
442 
443 
444         /** @dev Query the index for the edge-most node that satisfies the
445          *  given query.  For >, >=, and ==, this will be the left-most node
446          *  that satisfies the comparison.  For < and <= this will be the
447          *  right-most node that satisfies the comparison.
448          */
449         /// @param index The index that should be queried
450         /** @param operator One of '>', '>=', '<', '<=', '==' to specify what
451          *  type of comparison operator should be used.
452          */
453         function query(Index storage index, bytes2 operator, int value) public returns (bytes32) {
454                 bytes32 rootNodeId = index.root;
455                 
456                 if (rootNodeId == 0x0) {
457                     // Empty tree.
458                     return 0x0;
459                 }
460 
461                 Node storage currentNode = index.nodes[rootNodeId];
462 
463                 while (true) {
464                     if (_compare(currentNode.value, operator, value)) {
465                         // We have found a match but it might not be the
466                         // *correct* match.
467                         if ((operator == LT) || (operator == LTE)) {
468                             // Need to keep traversing right until this is no
469                             // longer true.
470                             if (currentNode.right == 0x0) {
471                                 return currentNode.nodeId;
472                             }
473                             if (_compare(_getMinimum(index, currentNode.right), operator, value)) {
474                                 // There are still nodes to the right that
475                                 // match.
476                                 currentNode = index.nodes[currentNode.right];
477                                 continue;
478                             }
479                             return currentNode.nodeId;
480                         }
481 
482                         if ((operator == GT) || (operator == GTE) || (operator == EQ)) {
483                             // Need to keep traversing left until this is no
484                             // longer true.
485                             if (currentNode.left == 0x0) {
486                                 return currentNode.nodeId;
487                             }
488                             if (_compare(_getMaximum(index, currentNode.left), operator, value)) {
489                                 currentNode = index.nodes[currentNode.left];
490                                 continue;
491                             }
492                             return currentNode.nodeId;
493                         }
494                     }
495 
496                     if ((operator == LT) || (operator == LTE)) {
497                         if (currentNode.left == 0x0) {
498                             // There are no nodes that are less than the value
499                             // so return null.
500                             return 0x0;
501                         }
502                         currentNode = index.nodes[currentNode.left];
503                         continue;
504                     }
505 
506                     if ((operator == GT) || (operator == GTE)) {
507                         if (currentNode.right == 0x0) {
508                             // There are no nodes that are greater than the value
509                             // so return null.
510                             return 0x0;
511                         }
512                         currentNode = index.nodes[currentNode.right];
513                         continue;
514                     }
515 
516                     if (operator == EQ) {
517                         if (currentNode.value < value) {
518                             if (currentNode.right == 0x0) {
519                                 return 0x0;
520                             }
521                             currentNode = index.nodes[currentNode.right];
522                             continue;
523                         }
524 
525                         if (currentNode.value > value) {
526                             if (currentNode.left == 0x0) {
527                                 return 0x0;
528                             }
529                             currentNode = index.nodes[currentNode.left];
530                             continue;
531                         }
532                     }
533                 }
534         }
535 
536         function _rebalanceTree(Index storage index, bytes32 nodeId) internal {
537             // Trace back up rebalancing the tree and updating heights as
538             // needed..
539             Node storage currentNode = index.nodes[nodeId];
540 
541             while (true) {
542                 int balanceFactor = _getBalanceFactor(index, currentNode.nodeId);
543 
544                 if (balanceFactor == 2) {
545                     // Right rotation (tree is heavy on the left)
546                     if (_getBalanceFactor(index, currentNode.left) == -1) {
547                         // The subtree is leaning right so it need to be
548                         // rotated left before the current node is rotated
549                         // right.
550                         _rotateLeft(index, currentNode.left);
551                     }
552                     _rotateRight(index, currentNode.nodeId);
553                 }
554 
555                 if (balanceFactor == -2) {
556                     // Left rotation (tree is heavy on the right)
557                     if (_getBalanceFactor(index, currentNode.right) == 1) {
558                         // The subtree is leaning left so it need to be
559                         // rotated right before the current node is rotated
560                         // left.
561                         _rotateRight(index, currentNode.right);
562                     }
563                     _rotateLeft(index, currentNode.nodeId);
564                 }
565 
566                 if ((-1 <= balanceFactor) && (balanceFactor <= 1)) {
567                     _updateNodeHeight(index, currentNode.nodeId);
568                 }
569 
570                 if (currentNode.parent == 0x0) {
571                     // Reached the root which may be new due to tree
572                     // rotation, so set it as the root and then break.
573                     break;
574                 }
575 
576                 currentNode = index.nodes[currentNode.parent];
577             }
578         }
579 
580         function _getBalanceFactor(Index storage index, bytes32 nodeId) internal returns (int) {
581                 Node storage node = index.nodes[nodeId];
582 
583                 return int(index.nodes[node.left].height) - int(index.nodes[node.right].height);
584         }
585 
586         function _updateNodeHeight(Index storage index, bytes32 nodeId) internal {
587                 Node storage node = index.nodes[nodeId];
588 
589                 node.height = max(index.nodes[node.left].height, index.nodes[node.right].height) + 1;
590         }
591 
592         function _rotateLeft(Index storage index, bytes32 nodeId) internal {
593             Node storage originalRoot = index.nodes[nodeId];
594 
595             if (originalRoot.right == 0x0) {
596                 // Cannot rotate left if there is no right originalRoot to rotate into
597                 // place.
598                 throw;
599             }
600 
601             // The right child is the new root, so it gets the original
602             // `originalRoot.parent` as it's parent.
603             Node storage newRoot = index.nodes[originalRoot.right];
604             newRoot.parent = originalRoot.parent;
605 
606             // The original root needs to have it's right child nulled out.
607             originalRoot.right = 0x0;
608 
609             if (originalRoot.parent != 0x0) {
610                 // If there is a parent node, it needs to now point downward at
611                 // the newRoot which is rotating into the place where `node` was.
612                 Node storage parent = index.nodes[originalRoot.parent];
613 
614                 // figure out if we're a left or right child and have the
615                 // parent point to the new node.
616                 if (parent.left == originalRoot.nodeId) {
617                     parent.left = newRoot.nodeId;
618                 }
619                 if (parent.right == originalRoot.nodeId) {
620                     parent.right = newRoot.nodeId;
621                 }
622             }
623 
624 
625             if (newRoot.left != 0) {
626                 // If the new root had a left child, that moves to be the
627                 // new right child of the original root node
628                 Node storage leftChild = index.nodes[newRoot.left];
629                 originalRoot.right = leftChild.nodeId;
630                 leftChild.parent = originalRoot.nodeId;
631             }
632 
633             // Update the newRoot's left node to point at the original node.
634             originalRoot.parent = newRoot.nodeId;
635             newRoot.left = originalRoot.nodeId;
636 
637             if (newRoot.parent == 0x0) {
638                 index.root = newRoot.nodeId;
639             }
640 
641             // TODO: are both of these updates necessary?
642             _updateNodeHeight(index, originalRoot.nodeId);
643             _updateNodeHeight(index, newRoot.nodeId);
644         }
645 
646         function _rotateRight(Index storage index, bytes32 nodeId) internal {
647             Node storage originalRoot = index.nodes[nodeId];
648 
649             if (originalRoot.left == 0x0) {
650                 // Cannot rotate right if there is no left node to rotate into
651                 // place.
652                 throw;
653             }
654 
655             // The left child is taking the place of node, so we update it's
656             // parent to be the original parent of the node.
657             Node storage newRoot = index.nodes[originalRoot.left];
658             newRoot.parent = originalRoot.parent;
659 
660             // Null out the originalRoot.left
661             originalRoot.left = 0x0;
662 
663             if (originalRoot.parent != 0x0) {
664                 // If the node has a parent, update the correct child to point
665                 // at the newRoot now.
666                 Node storage parent = index.nodes[originalRoot.parent];
667 
668                 if (parent.left == originalRoot.nodeId) {
669                     parent.left = newRoot.nodeId;
670                 }
671                 if (parent.right == originalRoot.nodeId) {
672                     parent.right = newRoot.nodeId;
673                 }
674             }
675 
676             if (newRoot.right != 0x0) {
677                 Node storage rightChild = index.nodes[newRoot.right];
678                 originalRoot.left = newRoot.right;
679                 rightChild.parent = originalRoot.nodeId;
680             }
681 
682             // Update the new root's right node to point to the original node.
683             originalRoot.parent = newRoot.nodeId;
684             newRoot.right = originalRoot.nodeId;
685 
686             if (newRoot.parent == 0x0) {
687                 index.root = newRoot.nodeId;
688             }
689 
690             // Recompute heights.
691             _updateNodeHeight(index, originalRoot.nodeId);
692             _updateNodeHeight(index, newRoot.nodeId);
693         }
694 }
695 
696 
697 /// @title Grove - queryable indexes for ordered data.
698 /// @author Piper Merriam <pipermerriam@gmail.com>
699 contract Grove {
700         /*
701          *  Indexes for ordered data
702          *
703          *  Address: 0x8017f24a47c889b1ee80501ff84beb3c017edf0b
704          */
705         // Map index_id to index
706         mapping (bytes32 => GroveLib.Index) index_lookup;
707 
708         // Map node_id to index_id.
709         mapping (bytes32 => bytes32) node_to_index;
710 
711         /// @notice Computes the id for a Grove index which is sha3(owner, indexName)
712         /// @param owner The address of the index owner.
713         /// @param indexName The name of the index.
714         function computeIndexId(address owner, bytes32 indexName) constant returns (bytes32) {
715                 return GroveLib.computeIndexId(owner, indexName);
716         }
717 
718         /// @notice Computes the id for a node in a given Grove index which is sha3(indexId, id)
719         /// @param indexId The id for the index the node belongs to.
720         /// @param id The unique identifier for the data this node represents.
721         function computeNodeId(bytes32 indexId, bytes32 id) constant returns (bytes32) {
722                 return GroveLib.computeNodeId(indexId, id);
723         }
724 
725         /*
726          *  Node getters
727          */
728         /// @notice Retrieves the name of an index.
729         /// @param indexId The id of the index.
730         function getIndexName(bytes32 indexId) constant returns (bytes32) {
731             return index_lookup[indexId].name;
732         }
733 
734         /// @notice Retrieves the id of the root node for this index.
735         /// @param indexId The id of the index.
736         function getIndexRoot(bytes32 indexId) constant returns (bytes32) {
737             return index_lookup[indexId].root;
738         }
739 
740 
741         /// @dev Retrieve the unique identifier this node represents.
742         /// @param nodeId The id for the node
743         function getNodeId(bytes32 nodeId) constant returns (bytes32) {
744             return GroveLib.getNodeId(index_lookup[node_to_index[nodeId]], nodeId);
745         }
746 
747         /// @dev Retrieve the index id for the node.
748         /// @param nodeId The id for the node
749         function getNodeIndexId(bytes32 nodeId) constant returns (bytes32) {
750             return GroveLib.getNodeIndexId(index_lookup[node_to_index[nodeId]], nodeId);
751         }
752 
753         /// @dev Retrieve the value of the node.
754         /// @param nodeId The id for the node
755         function getNodeValue(bytes32 nodeId) constant returns (int) {
756             return GroveLib.getNodeValue(index_lookup[node_to_index[nodeId]], nodeId);
757         }
758 
759         /// @dev Retrieve the height of the node.
760         /// @param nodeId The id for the node
761         function getNodeHeight(bytes32 nodeId) constant returns (uint) {
762             return GroveLib.getNodeHeight(index_lookup[node_to_index[nodeId]], nodeId);
763         }
764 
765         /// @dev Retrieve the parent id of the node.
766         /// @param nodeId The id for the node
767         function getNodeParent(bytes32 nodeId) constant returns (bytes32) {
768             return GroveLib.getNodeParent(index_lookup[node_to_index[nodeId]], nodeId);
769         }
770 
771         /// @dev Retrieve the left child id of the node.
772         /// @param nodeId The id for the node
773         function getNodeLeftChild(bytes32 nodeId) constant returns (bytes32) {
774             return GroveLib.getNodeLeftChild(index_lookup[node_to_index[nodeId]], nodeId);
775         }
776 
777         /// @dev Retrieve the right child id of the node.
778         /// @param nodeId The id for the node
779         function getNodeRightChild(bytes32 nodeId) constant returns (bytes32) {
780             return GroveLib.getNodeRightChild(index_lookup[node_to_index[nodeId]], nodeId);
781         }
782 
783         /** @dev Retrieve the id of the node that comes immediately before this
784          *  one.  Returns 0x0 if there is no previous node.
785          */
786         /// @param nodeId The id for the node
787         function getPreviousNode(bytes32 nodeId) constant returns (bytes32) {
788             return GroveLib.getPreviousNode(index_lookup[node_to_index[nodeId]], nodeId);
789         }
790 
791         /** @dev Retrieve the id of the node that comes immediately after this
792          *  one.  Returns 0x0 if there is no previous node.
793          */
794         /// @param nodeId The id for the node
795         function getNextNode(bytes32 nodeId) constant returns (bytes32) {
796             return GroveLib.getNextNode(index_lookup[node_to_index[nodeId]], nodeId);
797         }
798 
799         /** @dev Update or Insert a data element represented by the unique
800          *  identifier `id` into the index.
801          */
802         /// @param indexName The human readable name for the index that the node should be upserted into.
803         /// @param id The unique identifier that the index node represents.
804         /// @param value The number which represents this data elements total ordering.
805         function insert(bytes32 indexName, bytes32 id, int value) public {
806                 bytes32 indexId = computeIndexId(msg.sender, indexName);
807                 var index = index_lookup[indexId];
808 
809                 if (index.name != indexName) {
810                         // If this is a new index, store it's name and id
811                         index.name = indexName;
812                         index.id = indexId;
813                 }
814 
815                 // Store the mapping from nodeId to the indexId
816                 node_to_index[computeNodeId(indexId, id)] = indexId;
817 
818                 GroveLib.insert(index, id, value);
819         }
820 
821         /// @dev Query whether a node exists within the specified index for the unique identifier.
822         /// @param indexId The id for the index.
823         /// @param id The unique identifier of the data element.
824         function exists(bytes32 indexId, bytes32 id) constant returns (bool) {
825             return GroveLib.exists(index_lookup[indexId], id);
826         }
827 
828         /// @dev Remove the index node for the given unique identifier.
829         /// @param indexName The name of the index.
830         /// @param id The unique identifier of the data element.
831         function remove(bytes32 indexName, bytes32 id) public {
832             GroveLib.remove(index_lookup[computeIndexId(msg.sender, indexName)], id);
833         }
834 
835         /** @dev Query the index for the edge-most node that satisfies the
836          * given query.  For >, >=, and ==, this will be the left-most node
837          * that satisfies the comparison.  For < and <= this will be the
838          * right-most node that satisfies the comparison.
839          */
840         /// @param indexId The id of the index that should be queried
841         /** @param operator One of '>', '>=', '<', '<=', '==' to specify what
842          *  type of comparison operator should be used.
843          */
844         function query(bytes32 indexId, bytes2 operator, int value) public returns (bytes32) {
845                 return GroveLib.query(index_lookup[indexId], operator, value);
846         }
847 }