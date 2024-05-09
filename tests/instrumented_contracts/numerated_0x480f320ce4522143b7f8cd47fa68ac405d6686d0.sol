1 pragma solidity ^0.4.6;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 /// @title MilestoneTracker Contract
21 /// @author Jordi Baylina
22 /// @dev This contract tracks the
23 
24 
25 /// is rules the relation betwen a donor and a recipient
26 ///  in order to guaranty to the donor that the job will be done and to guaranty
27 ///  to the recipient that he will be paid
28 
29 
30 /// @dev We use the RLP library to decode RLP so that the donor can approve one
31 ///  set of milestone changes at a time.
32 ///  https://github.com/androlo/standard-contracts/blob/master/contracts/src/codec/RLP.sol
33 
34 
35 /**
36 * @title RLPReader
37 *
38 * RLPReader is used to read and parse RLP encoded data in memory.
39 *
40 * @author Andreas Olofsson (androlo1980@gmail.com)
41 */
42 library RLP {
43 
44  uint constant DATA_SHORT_START = 0x80;
45  uint constant DATA_LONG_START = 0xB8;
46  uint constant LIST_SHORT_START = 0xC0;
47  uint constant LIST_LONG_START = 0xF8;
48 
49  uint constant DATA_LONG_OFFSET = 0xB7;
50  uint constant LIST_LONG_OFFSET = 0xF7;
51 
52 
53  struct RLPItem {
54      uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
55      uint _unsafe_length;    // Number of bytes. This is the full length of the string.
56  }
57 
58  struct Iterator {
59      RLPItem _unsafe_item;   // Item that's being iterated over.
60      uint _unsafe_nextPtr;   // Position of the next item in the list.
61  }
62 
63  /* Iterator */
64 
65  function next(Iterator memory self) internal constant returns (RLPItem memory subItem) {
66      if(hasNext(self)) {
67          var ptr = self._unsafe_nextPtr;
68          var itemLength = _itemLength(ptr);
69          subItem._unsafe_memPtr = ptr;
70          subItem._unsafe_length = itemLength;
71          self._unsafe_nextPtr = ptr + itemLength;
72      }
73      else
74          throw;
75  }
76 
77  function next(Iterator memory self, bool strict) internal constant returns (RLPItem memory subItem) {
78      subItem = next(self);
79      if(strict && !_validate(subItem))
80          throw;
81      return;
82  }
83 
84  function hasNext(Iterator memory self) internal constant returns (bool) {
85      var item = self._unsafe_item;
86      return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
87  }
88 
89  /* RLPItem */
90 
91  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
92  /// @param self The RLP encoded bytes.
93  /// @return An RLPItem
94  function toRLPItem(bytes memory self) internal constant returns (RLPItem memory) {
95      uint len = self.length;
96      if (len == 0) {
97          return RLPItem(0, 0);
98      }
99      uint memPtr;
100      assembly {
101          memPtr := add(self, 0x20)
102      }
103      return RLPItem(memPtr, len);
104  }
105 
106  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
107  /// @param self The RLP encoded bytes.
108  /// @param strict Will throw if the data is not RLP encoded.
109  /// @return An RLPItem
110  function toRLPItem(bytes memory self, bool strict) internal constant returns (RLPItem memory) {
111      var item = toRLPItem(self);
112      if(strict) {
113          uint len = self.length;
114          if(_payloadOffset(item) > len)
115              throw;
116          if(_itemLength(item._unsafe_memPtr) != len)
117              throw;
118          if(!_validate(item))
119              throw;
120      }
121      return item;
122  }
123 
124  /// @dev Check if the RLP item is null.
125  /// @param self The RLP item.
126  /// @return 'true' if the item is null.
127  function isNull(RLPItem memory self) internal constant returns (bool ret) {
128      return self._unsafe_length == 0;
129  }
130 
131  /// @dev Check if the RLP item is a list.
132  /// @param self The RLP item.
133  /// @return 'true' if the item is a list.
134  function isList(RLPItem memory self) internal constant returns (bool ret) {
135      if (self._unsafe_length == 0)
136          return false;
137      uint memPtr = self._unsafe_memPtr;
138      assembly {
139          ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
140      }
141  }
142 
143  /// @dev Check if the RLP item is data.
144  /// @param self The RLP item.
145  /// @return 'true' if the item is data.
146  function isData(RLPItem memory self) internal constant returns (bool ret) {
147      if (self._unsafe_length == 0)
148          return false;
149      uint memPtr = self._unsafe_memPtr;
150      assembly {
151          ret := lt(byte(0, mload(memPtr)), 0xC0)
152      }
153  }
154 
155  /// @dev Check if the RLP item is empty (string or list).
156  /// @param self The RLP item.
157  /// @return 'true' if the item is null.
158  function isEmpty(RLPItem memory self) internal constant returns (bool ret) {
159      if(isNull(self))
160          return false;
161      uint b0;
162      uint memPtr = self._unsafe_memPtr;
163      assembly {
164          b0 := byte(0, mload(memPtr))
165      }
166      return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
167  }
168 
169  /// @dev Get the number of items in an RLP encoded list.
170  /// @param self The RLP item.
171  /// @return The number of items.
172  function items(RLPItem memory self) internal constant returns (uint) {
173      if (!isList(self))
174          return 0;
175      uint b0;
176      uint memPtr = self._unsafe_memPtr;
177      assembly {
178          b0 := byte(0, mload(memPtr))
179      }
180      uint pos = memPtr + _payloadOffset(self);
181      uint last = memPtr + self._unsafe_length - 1;
182      uint itms;
183      while(pos <= last) {
184          pos += _itemLength(pos);
185          itms++;
186      }
187      return itms;
188  }
189 
190  /// @dev Create an iterator.
191  /// @param self The RLP item.
192  /// @return An 'Iterator' over the item.
193  function iterator(RLPItem memory self) internal constant returns (Iterator memory it) {
194      if (!isList(self))
195          throw;
196      uint ptr = self._unsafe_memPtr + _payloadOffset(self);
197      it._unsafe_item = self;
198      it._unsafe_nextPtr = ptr;
199  }
200 
201  /// @dev Return the RLP encoded bytes.
202  /// @param self The RLPItem.
203  /// @return The bytes.
204  function toBytes(RLPItem memory self) internal constant returns (bytes memory bts) {
205      var len = self._unsafe_length;
206      if (len == 0)
207          return;
208      bts = new bytes(len);
209      _copyToBytes(self._unsafe_memPtr, bts, len);
210  }
211 
212  /// @dev Decode an RLPItem into bytes. This will not work if the
213  /// RLPItem is a list.
214  /// @param self The RLPItem.
215  /// @return The decoded string.
216  function toData(RLPItem memory self) internal constant returns (bytes memory bts) {
217      if(!isData(self))
218          throw;
219      var (rStartPos, len) = _decode(self);
220      bts = new bytes(len);
221      _copyToBytes(rStartPos, bts, len);
222  }
223 
224  /// @dev Get the list of sub-items from an RLP encoded list.
225  /// Warning: This is inefficient, as it requires that the list is read twice.
226  /// @param self The RLP item.
227  /// @return Array of RLPItems.
228  function toList(RLPItem memory self) internal constant returns (RLPItem[] memory list) {
229      if(!isList(self))
230          throw;
231      var numItems = items(self);
232      list = new RLPItem[](numItems);
233      var it = iterator(self);
234      uint idx;
235      while(hasNext(it)) {
236          list[idx] = next(it);
237          idx++;
238      }
239  }
240 
241  /// @dev Decode an RLPItem into an ascii string. This will not work if the
242  /// RLPItem is a list.
243  /// @param self The RLPItem.
244  /// @return The decoded string.
245  function toAscii(RLPItem memory self) internal constant returns (string memory str) {
246      if(!isData(self))
247          throw;
248      var (rStartPos, len) = _decode(self);
249      bytes memory bts = new bytes(len);
250      _copyToBytes(rStartPos, bts, len);
251      str = string(bts);
252  }
253 
254  /// @dev Decode an RLPItem into a uint. This will not work if the
255  /// RLPItem is a list.
256  /// @param self The RLPItem.
257  /// @return The decoded string.
258  function toUint(RLPItem memory self) internal constant returns (uint data) {
259      if(!isData(self))
260          throw;
261      var (rStartPos, len) = _decode(self);
262      if (len > 32 || len == 0)
263          throw;
264      assembly {
265          data := div(mload(rStartPos), exp(256, sub(32, len)))
266      }
267  }
268 
269  /// @dev Decode an RLPItem into a boolean. This will not work if the
270  /// RLPItem is a list.
271  /// @param self The RLPItem.
272  /// @return The decoded string.
273  function toBool(RLPItem memory self) internal constant returns (bool data) {
274      if(!isData(self))
275          throw;
276      var (rStartPos, len) = _decode(self);
277      if (len != 1)
278          throw;
279      uint temp;
280      assembly {
281          temp := byte(0, mload(rStartPos))
282      }
283      if (temp > 1)
284          throw;
285      return temp == 1 ? true : false;
286  }
287 
288  /// @dev Decode an RLPItem into a byte. This will not work if the
289  /// RLPItem is a list.
290  /// @param self The RLPItem.
291  /// @return The decoded string.
292  function toByte(RLPItem memory self) internal constant returns (byte data) {
293      if(!isData(self))
294          throw;
295      var (rStartPos, len) = _decode(self);
296      if (len != 1)
297          throw;
298      uint temp;
299      assembly {
300          temp := byte(0, mload(rStartPos))
301      }
302      return byte(temp);
303  }
304 
305  /// @dev Decode an RLPItem into an int. This will not work if the
306  /// RLPItem is a list.
307  /// @param self The RLPItem.
308  /// @return The decoded string.
309  function toInt(RLPItem memory self) internal constant returns (int data) {
310      return int(toUint(self));
311  }
312 
313  /// @dev Decode an RLPItem into a bytes32. This will not work if the
314  /// RLPItem is a list.
315  /// @param self The RLPItem.
316  /// @return The decoded string.
317  function toBytes32(RLPItem memory self) internal constant returns (bytes32 data) {
318      return bytes32(toUint(self));
319  }
320 
321  /// @dev Decode an RLPItem into an address. This will not work if the
322  /// RLPItem is a list.
323  /// @param self The RLPItem.
324  /// @return The decoded string.
325  function toAddress(RLPItem memory self) internal constant returns (address data) {
326      if(!isData(self))
327          throw;
328      var (rStartPos, len) = _decode(self);
329      if (len != 20)
330          throw;
331      assembly {
332          data := div(mload(rStartPos), exp(256, 12))
333      }
334  }
335 
336  // Get the payload offset.
337  function _payloadOffset(RLPItem memory self) private constant returns (uint) {
338      if(self._unsafe_length == 0)
339          return 0;
340      uint b0;
341      uint memPtr = self._unsafe_memPtr;
342      assembly {
343          b0 := byte(0, mload(memPtr))
344      }
345      if(b0 < DATA_SHORT_START)
346          return 0;
347      if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
348          return 1;
349      if(b0 < LIST_SHORT_START)
350          return b0 - DATA_LONG_OFFSET + 1;
351      return b0 - LIST_LONG_OFFSET + 1;
352  }
353 
354  // Get the full length of an RLP item.
355  function _itemLength(uint memPtr) private constant returns (uint len) {
356      uint b0;
357      assembly {
358          b0 := byte(0, mload(memPtr))
359      }
360      if (b0 < DATA_SHORT_START)
361          len = 1;
362      else if (b0 < DATA_LONG_START)
363          len = b0 - DATA_SHORT_START + 1;
364      else if (b0 < LIST_SHORT_START) {
365          assembly {
366              let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
367              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
368              len := add(1, add(bLen, dLen)) // total length
369          }
370      }
371      else if (b0 < LIST_LONG_START)
372          len = b0 - LIST_SHORT_START + 1;
373      else {
374          assembly {
375              let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
376              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
377              len := add(1, add(bLen, dLen)) // total length
378          }
379      }
380  }
381 
382  // Get start position and length of the data.
383  function _decode(RLPItem memory self) private constant returns (uint memPtr, uint len) {
384      if(!isData(self))
385          throw;
386      uint b0;
387      uint start = self._unsafe_memPtr;
388      assembly {
389          b0 := byte(0, mload(start))
390      }
391      if (b0 < DATA_SHORT_START) {
392          memPtr = start;
393          len = 1;
394          return;
395      }
396      if (b0 < DATA_LONG_START) {
397          len = self._unsafe_length - 1;
398          memPtr = start + 1;
399      } else {
400          uint bLen;
401          assembly {
402              bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
403          }
404          len = self._unsafe_length - 1 - bLen;
405          memPtr = start + bLen + 1;
406      }
407      return;
408  }
409 
410  // Assumes that enough memory has been allocated to store in target.
411  function _copyToBytes(uint btsPtr, bytes memory tgt, uint btsLen) private constant {
412      // Exploiting the fact that 'tgt' was the last thing to be allocated,
413      // we can write entire words, and just overwrite any excess.
414      assembly {
415          {
416                  let i := 0 // Start at arr + 0x20
417                  let words := div(add(btsLen, 31), 32)
418                  let rOffset := btsPtr
419                  let wOffset := add(tgt, 0x20)
420              tag_loop:
421                  jumpi(end, eq(i, words))
422                  {
423                      let offset := mul(i, 0x20)
424                      mstore(add(wOffset, offset), mload(add(rOffset, offset)))
425                      i := add(i, 1)
426                  }
427                  jump(tag_loop)
428              end:
429                  mstore(add(tgt, add(0x20, mload(tgt))), 0)
430          }
431      }
432  }
433 
434  // Check that an RLP item is valid.
435      function _validate(RLPItem memory self) private constant returns (bool ret) {
436          // Check that RLP is well-formed.
437          uint b0;
438          uint b1;
439          uint memPtr = self._unsafe_memPtr;
440          assembly {
441              b0 := byte(0, mload(memPtr))
442              b1 := byte(1, mload(memPtr))
443          }
444          if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
445              return false;
446          return true;
447      }
448 }
449 
450 
451 
452 /// @dev This contract allows for `recipient` to set and modify milestones
453 contract MilestoneTracker {
454     using RLP for RLP.RLPItem;
455     using RLP for RLP.Iterator;
456     using RLP for bytes;
457 
458     struct Milestone {
459         string description;     // Description of this milestone
460         string url;             // A link to more information (swarm gateway)
461         uint minCompletionDate; // Earliest UNIX time the milestone can be paid
462         uint maxCompletionDate; // Latest UNIX time the milestone can be paid
463         address milestoneLeadLink;
464                                 // Similar to `recipient`but for this milestone
465         address reviewer;       // Can reject the completion of this milestone
466         uint reviewTime;        // How many seconds the reviewer has to review
467         address paymentSource;  // Where the milestone payment is sent from
468         bytes payData;          // Data defining how much ether is sent where
469 
470         MilestoneStatus status; // Current status of the milestone
471                                 // (Completed, AuthorizedForPayment...)
472         uint doneTime;          // UNIX time when the milestone was marked DONE
473     }
474 
475     // The list of all the milestones.
476     Milestone[] public milestones;
477 
478     address public recipient;   // Calls functions in the name of the recipient
479     address public donor;       // Calls functions in the name of the donor
480     address public arbitrator;  // Calls functions in the name of the arbitrator
481 
482     enum MilestoneStatus {
483         AcceptedAndInProgress,
484         Completed,
485         AuthorizedForPayment,
486         Canceled
487     }
488 
489     // True if the campaign has been canceled
490     bool public campaignCanceled;
491 
492     // True if an approval on a change to `milestones` is a pending
493     bool public changingMilestones;
494 
495     // The pending change to `milestones` encoded in RLP
496     bytes public proposedMilestones;
497 
498 
499     /// @dev The following modifiers only allow specific roles to call functions
500     /// with these modifiers
501     modifier onlyRecipient { if (msg.sender !=  recipient) throw; _; }
502     modifier onlyArbitrator { if (msg.sender != arbitrator) throw; _; }
503     modifier onlyDonor { if (msg.sender != donor) throw; _; }
504 
505     /// @dev The following modifiers prevent functions from being called if the
506     /// campaign has been canceled or if new milestones are being proposed
507     modifier campaignNotCanceled { if (campaignCanceled) throw; _; }
508     modifier notChanging { if (changingMilestones) throw; _; }
509 
510  // @dev Events to make the payment movements easy to find on the blockchain
511     event NewMilestoneListProposed();
512     event NewMilestoneListUnproposed();
513     event NewMilestoneListAccepted();
514     event ProposalStatusChanged(uint idProposal, MilestoneStatus newProposal);
515     event CampaignCanceled();
516 
517 
518 ///////////
519 // Constructor
520 ///////////
521 
522     /// @notice The Constructor creates the Milestone contract on the blockchain
523     /// @param _arbitrator Address assigned to be the arbitrator
524     /// @param _donor Address assigned to be the donor
525     /// @param _recipient Address assigned to be the recipient
526     function MilestoneTracker (
527         address _arbitrator,
528         address _donor,
529         address _recipient
530     ) {
531         arbitrator = _arbitrator;
532         donor = _donor;
533         recipient = _recipient;
534     }
535 
536 
537 /////////
538 // Helper functions
539 /////////
540 
541     /// @return The number of milestones ever created even if they were canceled
542     function numberOfMilestones() constant returns (uint) {
543         return milestones.length;
544     }
545 
546 
547 ////////
548 // Change players
549 ////////
550 
551     /// @notice `onlyArbitrator` Reassigns the arbitrator to a new address
552     /// @param _newArbitrator The new arbitrator
553     function changeArbitrator(address _newArbitrator) onlyArbitrator {
554         arbitrator = _newArbitrator;
555     }
556 
557     /// @notice `onlyDonor` Reassigns the `donor` to a new address
558     /// @param _newDonor The new donor
559     function changeDonor(address _newDonor) onlyDonor {
560         donor = _newDonor;
561     }
562 
563     /// @notice `onlyRecipient` Reassigns the `recipient` to a new address
564     /// @param _newRecipient The new recipient
565     function changeRecipient(address _newRecipient) onlyRecipient {
566         recipient = _newRecipient;
567     }
568 
569 
570 ////////////
571 // Creation and modification of Milestones
572 ////////////
573 
574     /// @notice `onlyRecipient` Proposes new milestones or changes old
575     ///  milestones, this will require a user interface to be built up to
576     ///  support this functionality as asks for RLP encoded bytecode to be
577     ///  generated, until this interface is built you can use this script:
578     ///  https://github.com/Giveth/milestonetracker/blob/master/js/milestonetracker_helper.js
579     ///  the functions milestones2bytes and bytes2milestones will enable the
580     ///  recipient to encode and decode a list of milestones, also see
581     ///  https://github.com/Giveth/milestonetracker/blob/master/README.md
582     /// @param _newMilestones The RLP encoded list of milestones; each milestone
583     ///  has these fields:
584     ///       string description,
585     ///       string url,
586     ///       uint minCompletionDate,  // seconds since 1/1/1970 (UNIX time)
587     ///       uint maxCompletionDate,  // seconds since 1/1/1970 (UNIX time)
588     ///       address milestoneLeadLink,
589     ///       address reviewer,
590     ///       uint reviewTime
591     ///       address paymentSource,
592     ///       bytes payData,
593     function proposeMilestones(bytes _newMilestones
594     ) onlyRecipient campaignNotCanceled {
595         proposedMilestones = _newMilestones;
596         changingMilestones = true;
597         NewMilestoneListProposed();
598     }
599 
600 
601 ////////////
602 // Normal actions that will change the state of the milestones
603 ////////////
604 
605     /// @notice `onlyRecipient` Cancels the proposed milestones and reactivates
606     ///  the previous set of milestones
607     function unproposeMilestones() onlyRecipient campaignNotCanceled {
608         delete proposedMilestones;
609         changingMilestones = false;
610         NewMilestoneListUnproposed();
611     }
612 
613     /// @notice `onlyDonor` Approves the proposed milestone list
614     /// @param _hashProposals The sha3() of the proposed milestone list's
615     ///  bytecode; this confirms that the `donor` knows the set of milestones
616     ///  they are approving
617     function acceptProposedMilestones(bytes32 _hashProposals
618     ) onlyDonor campaignNotCanceled {
619 
620         uint i;
621 
622         if (!changingMilestones) throw;
623         if (sha3(proposedMilestones) != _hashProposals) throw;
624 
625         // Cancel all the unfinished milestones
626         for (i=0; i<milestones.length; i++) {
627             if (milestones[i].status != MilestoneStatus.AuthorizedForPayment) {
628                 milestones[i].status = MilestoneStatus.Canceled;
629             }
630         }
631         // Decode the RLP encoded milestones and add them to the milestones list
632         bytes memory mProposedMilestones = proposedMilestones;
633 
634         var itmProposals = mProposedMilestones.toRLPItem(true);
635 
636         if (!itmProposals.isList()) throw;
637 
638         var itrProposals = itmProposals.iterator();
639 
640         while(itrProposals.hasNext()) {
641 
642 
643             var itmProposal = itrProposals.next();
644 
645             Milestone milestone = milestones[milestones.length ++];
646 
647             if (!itmProposal.isList()) throw;
648 
649             var itrProposal = itmProposal.iterator();
650 
651             milestone.description = itrProposal.next().toAscii();
652             milestone.url = itrProposal.next().toAscii();
653             milestone.minCompletionDate = itrProposal.next().toUint();
654             milestone.maxCompletionDate = itrProposal.next().toUint();
655             milestone.milestoneLeadLink = itrProposal.next().toAddress();
656             milestone.reviewer = itrProposal.next().toAddress();
657             milestone.reviewTime = itrProposal.next().toUint();
658             milestone.paymentSource = itrProposal.next().toAddress();
659             milestone.payData = itrProposal.next().toData();
660 
661             milestone.status = MilestoneStatus.AcceptedAndInProgress;
662 
663         }
664 
665         delete proposedMilestones;
666         changingMilestones = false;
667         NewMilestoneListAccepted();
668     }
669 
670     /// @notice `onlyRecipientOrLeadLink`Marks a milestone as DONE and
671     ///  ready for review
672     /// @param _idMilestone ID of the milestone that has been completed
673     function markMilestoneComplete(uint _idMilestone)
674         campaignNotCanceled notChanging
675     {
676         if (_idMilestone >= milestones.length) throw;
677         Milestone milestone = milestones[_idMilestone];
678         if (  (msg.sender != milestone.milestoneLeadLink)
679             &&(msg.sender != recipient))
680             throw;
681         if (milestone.status != MilestoneStatus.AcceptedAndInProgress) throw;
682         if (now < milestone.minCompletionDate) throw;
683         if (now > milestone.maxCompletionDate) throw;
684         milestone.status = MilestoneStatus.Completed;
685         milestone.doneTime = now;
686         ProposalStatusChanged(_idMilestone, milestone.status);
687     }
688 
689     /// @notice `onlyReviewer` Approves a specific milestone
690     /// @param _idMilestone ID of the milestone that is approved
691     function approveCompletedMilestone(uint _idMilestone)
692         campaignNotCanceled notChanging
693     {
694         if (_idMilestone >= milestones.length) throw;
695         Milestone milestone = milestones[_idMilestone];
696         if ((msg.sender != milestone.reviewer) ||
697             (milestone.status != MilestoneStatus.Completed)) throw;
698 
699         authorizePayment(_idMilestone);
700     }
701 
702     /// @notice `onlyReviewer` Rejects a specific milestone's completion and
703     ///  reverts the `milestone.status` back to the `AcceptedAndInProgress`
704     ///  state
705     /// @param _idMilestone ID of the milestone that is being rejected
706     function rejectMilestone(uint _idMilestone)
707         campaignNotCanceled notChanging
708     {
709         if (_idMilestone >= milestones.length) throw;
710         Milestone milestone = milestones[_idMilestone];
711         if ((msg.sender != milestone.reviewer) ||
712             (milestone.status != MilestoneStatus.Completed)) throw;
713 
714         milestone.status = MilestoneStatus.AcceptedAndInProgress;
715         ProposalStatusChanged(_idMilestone, milestone.status);
716     }
717 
718     /// @notice `onlyRecipientOrLeadLink` Sends the milestone payment as
719     ///  specified in `payData`; the recipient can only call this after the
720     ///  `reviewTime` has elapsed
721     /// @param _idMilestone ID of the milestone to be paid out
722     function requestMilestonePayment(uint _idMilestone
723         ) campaignNotCanceled notChanging {
724         if (_idMilestone >= milestones.length) throw;
725         Milestone milestone = milestones[_idMilestone];
726         if (  (msg.sender != milestone.milestoneLeadLink)
727             &&(msg.sender != recipient))
728             throw;
729         if  ((milestone.status != MilestoneStatus.Completed) ||
730              (now < milestone.doneTime + milestone.reviewTime))
731             throw;
732 
733         authorizePayment(_idMilestone);
734     }
735 
736     /// @notice `onlyRecipient` Cancels a previously accepted milestone
737     /// @param _idMilestone ID of the milestone to be canceled
738     function cancelMilestone(uint _idMilestone)
739         onlyRecipient campaignNotCanceled notChanging
740     {
741         if (_idMilestone >= milestones.length) throw;
742         Milestone milestone = milestones[_idMilestone];
743         if  ((milestone.status != MilestoneStatus.AcceptedAndInProgress) &&
744              (milestone.status != MilestoneStatus.Completed))
745             throw;
746 
747         milestone.status = MilestoneStatus.Canceled;
748         ProposalStatusChanged(_idMilestone, milestone.status);
749     }
750 
751     /// @notice `onlyArbitrator` Forces a milestone to be paid out as long as it
752     /// has not been paid or canceled
753     /// @param _idMilestone ID of the milestone to be paid out
754     function arbitrateApproveMilestone(uint _idMilestone
755     ) onlyArbitrator campaignNotCanceled notChanging {
756         if (_idMilestone >= milestones.length) throw;
757         Milestone milestone = milestones[_idMilestone];
758         if  ((milestone.status != MilestoneStatus.AcceptedAndInProgress) &&
759              (milestone.status != MilestoneStatus.Completed))
760            throw;
761         authorizePayment(_idMilestone);
762     }
763 
764     /// @notice `onlyArbitrator` Cancels the entire campaign voiding all
765     ///  milestones vo
766     function arbitrateCancelCampaign() onlyArbitrator campaignNotCanceled {
767         campaignCanceled = true;
768         CampaignCanceled();
769     }
770 
771     // @dev This internal function is executed when the milestone is paid out
772     function authorizePayment(uint _idMilestone) internal {
773         if (_idMilestone >= milestones.length) throw;
774         Milestone milestone = milestones[_idMilestone];
775         // Recheck again to not pay twice
776         if (milestone.status == MilestoneStatus.AuthorizedForPayment) throw;
777         milestone.status = MilestoneStatus.AuthorizedForPayment;
778         if (!milestone.paymentSource.call.value(0)(milestone.payData))
779             throw;
780         ProposalStatusChanged(_idMilestone, milestone.status);
781     }
782 }