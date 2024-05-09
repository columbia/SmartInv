1 pragma solidity ^0.4.6;
2 
3 /**
4 * @title RLPReader
5 *
6 * RLPReader is used to read and parse RLP encoded data in memory.
7 *
8 * @author Andreas Olofsson (androlo1980@gmail.com)
9 */
10 library RLP {
11 
12  uint constant DATA_SHORT_START = 0x80;
13  uint constant DATA_LONG_START = 0xB8;
14  uint constant LIST_SHORT_START = 0xC0;
15  uint constant LIST_LONG_START = 0xF8;
16 
17  uint constant DATA_LONG_OFFSET = 0xB7;
18  uint constant LIST_LONG_OFFSET = 0xF7;
19 
20 
21  struct RLPItem {
22      uint _unsafe_memPtr;    // Pointer to the RLP-encoded bytes.
23      uint _unsafe_length;    // Number of bytes. This is the full length of the string.
24  }
25 
26  struct Iterator {
27      RLPItem _unsafe_item;   // Item that's being iterated over.
28      uint _unsafe_nextPtr;   // Position of the next item in the list.
29  }
30 
31  /* Iterator */
32 
33  function next(Iterator memory self) internal constant returns (RLPItem memory subItem) {
34      if(hasNext(self)) {
35          var ptr = self._unsafe_nextPtr;
36          var itemLength = _itemLength(ptr);
37          subItem._unsafe_memPtr = ptr;
38          subItem._unsafe_length = itemLength;
39          self._unsafe_nextPtr = ptr + itemLength;
40      }
41      else
42          throw;
43  }
44 
45  function next(Iterator memory self, bool strict) internal constant returns (RLPItem memory subItem) {
46      subItem = next(self);
47      if(strict && !_validate(subItem))
48          throw;
49      return;
50  }
51 
52  function hasNext(Iterator memory self) internal constant returns (bool) {
53      var item = self._unsafe_item;
54      return self._unsafe_nextPtr < item._unsafe_memPtr + item._unsafe_length;
55  }
56 
57  /* RLPItem */
58 
59  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
60  /// @param self The RLP encoded bytes.
61  /// @return An RLPItem
62  function toRLPItem(bytes memory self) internal constant returns (RLPItem memory) {
63      uint len = self.length;
64      if (len == 0) {
65          return RLPItem(0, 0);
66      }
67      uint memPtr;
68      assembly {
69          memPtr := add(self, 0x20)
70      }
71      return RLPItem(memPtr, len);
72  }
73 
74  /// @dev Creates an RLPItem from an array of RLP encoded bytes.
75  /// @param self The RLP encoded bytes.
76  /// @param strict Will throw if the data is not RLP encoded.
77  /// @return An RLPItem
78  function toRLPItem(bytes memory self, bool strict) internal constant returns (RLPItem memory) {
79      var item = toRLPItem(self);
80      if(strict) {
81          uint len = self.length;
82          if(_payloadOffset(item) > len)
83              throw;
84          if(_itemLength(item._unsafe_memPtr) != len)
85              throw;
86          if(!_validate(item))
87              throw;
88      }
89      return item;
90  }
91 
92  /// @dev Check if the RLP item is null.
93  /// @param self The RLP item.
94  /// @return 'true' if the item is null.
95  function isNull(RLPItem memory self) internal constant returns (bool ret) {
96      return self._unsafe_length == 0;
97  }
98 
99  /// @dev Check if the RLP item is a list.
100  /// @param self The RLP item.
101  /// @return 'true' if the item is a list.
102  function isList(RLPItem memory self) internal constant returns (bool ret) {
103      if (self._unsafe_length == 0)
104          return false;
105      uint memPtr = self._unsafe_memPtr;
106      assembly {
107          ret := iszero(lt(byte(0, mload(memPtr)), 0xC0))
108      }
109  }
110 
111  /// @dev Check if the RLP item is data.
112  /// @param self The RLP item.
113  /// @return 'true' if the item is data.
114  function isData(RLPItem memory self) internal constant returns (bool ret) {
115      if (self._unsafe_length == 0)
116          return false;
117      uint memPtr = self._unsafe_memPtr;
118      assembly {
119          ret := lt(byte(0, mload(memPtr)), 0xC0)
120      }
121  }
122 
123  /// @dev Check if the RLP item is empty (string or list).
124  /// @param self The RLP item.
125  /// @return 'true' if the item is null.
126  function isEmpty(RLPItem memory self) internal constant returns (bool ret) {
127      if(isNull(self))
128          return false;
129      uint b0;
130      uint memPtr = self._unsafe_memPtr;
131      assembly {
132          b0 := byte(0, mload(memPtr))
133      }
134      return (b0 == DATA_SHORT_START || b0 == LIST_SHORT_START);
135  }
136 
137  /// @dev Get the number of items in an RLP encoded list.
138  /// @param self The RLP item.
139  /// @return The number of items.
140  function items(RLPItem memory self) internal constant returns (uint) {
141      if (!isList(self))
142          return 0;
143      uint b0;
144      uint memPtr = self._unsafe_memPtr;
145      assembly {
146          b0 := byte(0, mload(memPtr))
147      }
148      uint pos = memPtr + _payloadOffset(self);
149      uint last = memPtr + self._unsafe_length - 1;
150      uint itms;
151      while(pos <= last) {
152          pos += _itemLength(pos);
153          itms++;
154      }
155      return itms;
156  }
157 
158  /// @dev Create an iterator.
159  /// @param self The RLP item.
160  /// @return An 'Iterator' over the item.
161  function iterator(RLPItem memory self) internal constant returns (Iterator memory it) {
162      if (!isList(self))
163          throw;
164      uint ptr = self._unsafe_memPtr + _payloadOffset(self);
165      it._unsafe_item = self;
166      it._unsafe_nextPtr = ptr;
167  }
168 
169  /// @dev Return the RLP encoded bytes.
170  /// @param self The RLPItem.
171  /// @return The bytes.
172  function toBytes(RLPItem memory self) internal constant returns (bytes memory bts) {
173      var len = self._unsafe_length;
174      if (len == 0)
175          return;
176      bts = new bytes(len);
177      _copyToBytes(self._unsafe_memPtr, bts, len);
178  }
179 
180  /// @dev Decode an RLPItem into bytes. This will not work if the
181  /// RLPItem is a list.
182  /// @param self The RLPItem.
183  /// @return The decoded string.
184  function toData(RLPItem memory self) internal constant returns (bytes memory bts) {
185      if(!isData(self))
186          throw;
187      var (rStartPos, len) = _decode(self);
188      bts = new bytes(len);
189      _copyToBytes(rStartPos, bts, len);
190  }
191 
192  /// @dev Get the list of sub-items from an RLP encoded list.
193  /// Warning: This is inefficient, as it requires that the list is read twice.
194  /// @param self The RLP item.
195  /// @return Array of RLPItems.
196  function toList(RLPItem memory self) internal constant returns (RLPItem[] memory list) {
197      if(!isList(self))
198          throw;
199      var numItems = items(self);
200      list = new RLPItem[](numItems);
201      var it = iterator(self);
202      uint idx;
203      while(hasNext(it)) {
204          list[idx] = next(it);
205          idx++;
206      }
207  }
208 
209  /// @dev Decode an RLPItem into an ascii string. This will not work if the
210  /// RLPItem is a list.
211  /// @param self The RLPItem.
212  /// @return The decoded string.
213  function toAscii(RLPItem memory self) internal constant returns (string memory str) {
214      if(!isData(self))
215          throw;
216      var (rStartPos, len) = _decode(self);
217      bytes memory bts = new bytes(len);
218      _copyToBytes(rStartPos, bts, len);
219      str = string(bts);
220  }
221 
222  /// @dev Decode an RLPItem into a uint. This will not work if the
223  /// RLPItem is a list.
224  /// @param self The RLPItem.
225  /// @return The decoded string.
226  function toUint(RLPItem memory self) internal constant returns (uint data) {
227      if(!isData(self))
228          throw;
229      var (rStartPos, len) = _decode(self);
230      if (len > 32 || len == 0)
231          throw;
232      assembly {
233          data := div(mload(rStartPos), exp(256, sub(32, len)))
234      }
235  }
236 
237  /// @dev Decode an RLPItem into a boolean. This will not work if the
238  /// RLPItem is a list.
239  /// @param self The RLPItem.
240  /// @return The decoded string.
241  function toBool(RLPItem memory self) internal constant returns (bool data) {
242      if(!isData(self))
243          throw;
244      var (rStartPos, len) = _decode(self);
245      if (len != 1)
246          throw;
247      uint temp;
248      assembly {
249          temp := byte(0, mload(rStartPos))
250      }
251      if (temp > 1)
252          throw;
253      return temp == 1 ? true : false;
254  }
255 
256  /// @dev Decode an RLPItem into a byte. This will not work if the
257  /// RLPItem is a list.
258  /// @param self The RLPItem.
259  /// @return The decoded string.
260  function toByte(RLPItem memory self) internal constant returns (byte data) {
261      if(!isData(self))
262          throw;
263      var (rStartPos, len) = _decode(self);
264      if (len != 1)
265          throw;
266      uint temp;
267      assembly {
268          temp := byte(0, mload(rStartPos))
269      }
270      return byte(temp);
271  }
272 
273  /// @dev Decode an RLPItem into an int. This will not work if the
274  /// RLPItem is a list.
275  /// @param self The RLPItem.
276  /// @return The decoded string.
277  function toInt(RLPItem memory self) internal constant returns (int data) {
278      return int(toUint(self));
279  }
280 
281  /// @dev Decode an RLPItem into a bytes32. This will not work if the
282  /// RLPItem is a list.
283  /// @param self The RLPItem.
284  /// @return The decoded string.
285  function toBytes32(RLPItem memory self) internal constant returns (bytes32 data) {
286      return bytes32(toUint(self));
287  }
288 
289  /// @dev Decode an RLPItem into an address. This will not work if the
290  /// RLPItem is a list.
291  /// @param self The RLPItem.
292  /// @return The decoded string.
293  function toAddress(RLPItem memory self) internal constant returns (address data) {
294      if(!isData(self))
295          throw;
296      var (rStartPos, len) = _decode(self);
297      if (len != 20)
298          throw;
299      assembly {
300          data := div(mload(rStartPos), exp(256, 12))
301      }
302  }
303 
304  // Get the payload offset.
305  function _payloadOffset(RLPItem memory self) private constant returns (uint) {
306      if(self._unsafe_length == 0)
307          return 0;
308      uint b0;
309      uint memPtr = self._unsafe_memPtr;
310      assembly {
311          b0 := byte(0, mload(memPtr))
312      }
313      if(b0 < DATA_SHORT_START)
314          return 0;
315      if(b0 < DATA_LONG_START || (b0 >= LIST_SHORT_START && b0 < LIST_LONG_START))
316          return 1;
317      if(b0 < LIST_SHORT_START)
318          return b0 - DATA_LONG_OFFSET + 1;
319      return b0 - LIST_LONG_OFFSET + 1;
320  }
321 
322  // Get the full length of an RLP item.
323  function _itemLength(uint memPtr) private constant returns (uint len) {
324      uint b0;
325      assembly {
326          b0 := byte(0, mload(memPtr))
327      }
328      if (b0 < DATA_SHORT_START)
329          len = 1;
330      else if (b0 < DATA_LONG_START)
331          len = b0 - DATA_SHORT_START + 1;
332      else if (b0 < LIST_SHORT_START) {
333          assembly {
334              let bLen := sub(b0, 0xB7) // bytes length (DATA_LONG_OFFSET)
335              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
336              len := add(1, add(bLen, dLen)) // total length
337          }
338      }
339      else if (b0 < LIST_LONG_START)
340          len = b0 - LIST_SHORT_START + 1;
341      else {
342          assembly {
343              let bLen := sub(b0, 0xF7) // bytes length (LIST_LONG_OFFSET)
344              let dLen := div(mload(add(memPtr, 1)), exp(256, sub(32, bLen))) // data length
345              len := add(1, add(bLen, dLen)) // total length
346          }
347      }
348  }
349 
350  // Get start position and length of the data.
351  function _decode(RLPItem memory self) private constant returns (uint memPtr, uint len) {
352      if(!isData(self))
353          throw;
354      uint b0;
355      uint start = self._unsafe_memPtr;
356      assembly {
357          b0 := byte(0, mload(start))
358      }
359      if (b0 < DATA_SHORT_START) {
360          memPtr = start;
361          len = 1;
362          return;
363      }
364      if (b0 < DATA_LONG_START) {
365          len = self._unsafe_length - 1;
366          memPtr = start + 1;
367      } else {
368          uint bLen;
369          assembly {
370              bLen := sub(b0, 0xB7) // DATA_LONG_OFFSET
371          }
372          len = self._unsafe_length - 1 - bLen;
373          memPtr = start + bLen + 1;
374      }
375      return;
376  }
377 
378  // Assumes that enough memory has been allocated to store in target.
379  function _copyToBytes(uint btsPtr, bytes memory tgt, uint btsLen) private constant {
380      // Exploiting the fact that 'tgt' was the last thing to be allocated,
381      // we can write entire words, and just overwrite any excess.
382      assembly {
383          {
384                  let i := 0 // Start at arr + 0x20
385                  let words := div(add(btsLen, 31), 32)
386                  let rOffset := btsPtr
387                  let wOffset := add(tgt, 0x20)
388              tag_loop:
389                  jumpi(end, eq(i, words))
390                  {
391                      let offset := mul(i, 0x20)
392                      mstore(add(wOffset, offset), mload(add(rOffset, offset)))
393                      i := add(i, 1)
394                  }
395                  jump(tag_loop)
396              end:
397                  mstore(add(tgt, add(0x20, mload(tgt))), 0)
398          }
399      }
400  }
401 
402  // Check that an RLP item is valid.
403      function _validate(RLPItem memory self) private constant returns (bool ret) {
404          // Check that RLP is well-formed.
405          uint b0;
406          uint b1;
407          uint memPtr = self._unsafe_memPtr;
408          assembly {
409              b0 := byte(0, mload(memPtr))
410              b1 := byte(1, mload(memPtr))
411          }
412          if(b0 == DATA_SHORT_START + 1 && b1 < DATA_SHORT_START)
413              return false;
414          return true;
415      }
416 }
417 
418 pragma solidity ^0.4.6;
419 
420 /*
421     Copyright 2016, Jordi Baylina
422 
423     This program is free software: you can redistribute it and/or modify
424     it under the terms of the GNU General Public License as published by
425     the Free Software Foundation, either version 3 of the License, or
426     (at your option) any later version.
427 
428     This program is distributed in the hope that it will be useful,
429     but WITHOUT ANY WARRANTY; without even the implied warranty of
430     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
431     GNU General Public License for more details.
432 
433     You should have received a copy of the GNU General Public License
434     along with this program.  If not, see <http://www.gnu.org/licenses/>.
435  */
436 
437 /// @title MilestoneTracker Contract
438 /// @author Jordi Baylina
439 /// @dev This contract tracks the
440 
441 
442 /// is rules the relation betwen a donor and a recipient
443 ///  in order to guaranty to the donor that the job will be done and to guaranty
444 ///  to the recipient that he will be paid
445 
446 
447 /// @dev We use the RLP library to decode RLP so that the donor can approve one
448 ///  set of milestone changes at a time.
449 ///  https://github.com/androlo/standard-contracts/blob/master/contracts/src/codec/RLP.sol
450 
451 
452 
453 
454 /// @dev This contract allows for `recipient` to set and modify milestones
455 contract MilestoneTracker {
456     using RLP for RLP.RLPItem;
457     using RLP for RLP.Iterator;
458     using RLP for bytes;
459 
460     struct Milestone {
461         string description;     // Description of this milestone
462         string url;             // A link to more information (swarm gateway)
463         uint minCompletionDate; // Earliest UNIX time the milestone can be paid
464         uint maxCompletionDate; // Latest UNIX time the milestone can be paid
465         address milestoneLeadLink;
466                                 // Similar to `recipient`but for this milestone
467         address reviewer;       // Can reject the completion of this milestone
468         uint reviewTime;        // How many seconds the reviewer has to review
469         address paymentSource;  // Where the milestone payment is sent from
470         bytes payData;          // Data defining how much ether is sent where
471 
472         MilestoneStatus status; // Current status of the milestone
473                                 // (Completed, AuthorizedForPayment...)
474         uint doneTime;          // UNIX time when the milestone was marked DONE
475     }
476 
477     // The list of all the milestones.
478     Milestone[] public milestones;
479 
480     address public recipient;   // Calls functions in the name of the recipient
481     address public donor;       // Calls functions in the name of the donor
482     address public arbitrator;  // Calls functions in the name of the arbitrator
483 
484     enum MilestoneStatus {
485         AcceptedAndInProgress,
486         Completed,
487         AuthorizedForPayment,
488         Canceled
489     }
490 
491     // True if the campaign has been canceled
492     bool public campaignCanceled;
493 
494     // True if an approval on a change to `milestones` is a pending
495     bool public changingMilestones;
496 
497     // The pending change to `milestones` encoded in RLP
498     bytes public proposedMilestones;
499 
500 
501     /// @dev The following modifiers only allow specific roles to call functions
502     /// with these modifiers
503     modifier onlyRecipient { if (msg.sender !=  recipient) throw; _; }
504     modifier onlyArbitrator { if (msg.sender != arbitrator) throw; _; }
505     modifier onlyDonor { if (msg.sender != donor) throw; _; }
506 
507     /// @dev The following modifiers prevent functions from being called if the
508     /// campaign has been canceled or if new milestones are being proposed
509     modifier campaignNotCanceled { if (campaignCanceled) throw; _; }
510     modifier notChanging { if (changingMilestones) throw; _; }
511 
512  // @dev Events to make the payment movements easy to find on the blockchain
513     event NewMilestoneListProposed();
514     event NewMilestoneListUnproposed();
515     event NewMilestoneListAccepted();
516     event ProposalStatusChanged(uint idProposal, MilestoneStatus newProposal);
517     event CampaignCanceled();
518 
519 
520 ///////////
521 // Constructor
522 ///////////
523 
524     /// @notice The Constructor creates the Milestone contract on the blockchain
525     /// @param _arbitrator Address assigned to be the arbitrator
526     /// @param _donor Address assigned to be the donor
527     /// @param _recipient Address assigned to be the recipient
528     function MilestoneTracker (
529         address _arbitrator,
530         address _donor,
531         address _recipient
532     ) {
533         arbitrator = _arbitrator;
534         donor = _donor;
535         recipient = _recipient;
536     }
537 
538 
539 /////////
540 // Helper functions
541 /////////
542 
543     /// @return The number of milestones ever created even if they were canceled
544     function numberOfMilestones() constant returns (uint) {
545         return milestones.length;
546     }
547 
548 
549 ////////
550 // Change players
551 ////////
552 
553     /// @notice `onlyArbitrator` Reassigns the arbitrator to a new address
554     /// @param _newArbitrator The new arbitrator
555     function changeArbitrator(address _newArbitrator) onlyArbitrator {
556         arbitrator = _newArbitrator;
557     }
558 
559     /// @notice `onlyDonor` Reassigns the `donor` to a new address
560     /// @param _newDonor The new donor
561     function changeDonor(address _newDonor) onlyDonor {
562         donor = _newDonor;
563     }
564 
565     /// @notice `onlyRecipient` Reassigns the `recipient` to a new address
566     /// @param _newRecipient The new recipient
567     function changeRecipient(address _newRecipient) onlyRecipient {
568         recipient = _newRecipient;
569     }
570 
571 
572 ////////////
573 // Creation and modification of Milestones
574 ////////////
575 
576     /// @notice `onlyRecipient` Proposes new milestones or changes old
577     ///  milestones, this will require a user interface to be built up to
578     ///  support this functionality as asks for RLP encoded bytecode to be
579     ///  generated, until this interface is built you can use this script:
580     ///  https://github.com/Giveth/milestonetracker/blob/master/js/milestonetracker_helper.js
581     ///  the functions milestones2bytes and bytes2milestones will enable the
582     ///  recipient to encode and decode a list of milestones, also see
583     ///  https://github.com/Giveth/milestonetracker/blob/master/README.md
584     /// @param _newMilestones The RLP encoded list of milestones; each milestone
585     ///  has these fields:
586     ///       string description,
587     ///       string url,
588     ///       uint minCompletionDate,  // seconds since 1/1/1970 (UNIX time)
589     ///       uint maxCompletionDate,  // seconds since 1/1/1970 (UNIX time)
590     ///       address milestoneLeadLink,
591     ///       address reviewer,
592     ///       uint reviewTime
593     ///       address paymentSource,
594     ///       bytes payData,
595     function proposeMilestones(bytes _newMilestones
596     ) onlyRecipient campaignNotCanceled {
597         proposedMilestones = _newMilestones;
598         changingMilestones = true;
599         NewMilestoneListProposed();
600     }
601 
602 
603 ////////////
604 // Normal actions that will change the state of the milestones
605 ////////////
606 
607     /// @notice `onlyRecipient` Cancels the proposed milestones and reactivates
608     ///  the previous set of milestones
609     function unproposeMilestones() onlyRecipient campaignNotCanceled {
610         delete proposedMilestones;
611         changingMilestones = false;
612         NewMilestoneListUnproposed();
613     }
614 
615     /// @notice `onlyDonor` Approves the proposed milestone list
616     /// @param _hashProposals The sha3() of the proposed milestone list's
617     ///  bytecode; this confirms that the `donor` knows the set of milestones
618     ///  they are approving
619     function acceptProposedMilestones(bytes32 _hashProposals
620     ) onlyDonor campaignNotCanceled {
621 
622         uint i;
623 
624         if (!changingMilestones) throw;
625         if (sha3(proposedMilestones) != _hashProposals) throw;
626 
627         // Cancel all the unfinished milestones
628         for (i=0; i<milestones.length; i++) {
629             if (milestones[i].status != MilestoneStatus.AuthorizedForPayment) {
630                 milestones[i].status = MilestoneStatus.Canceled;
631             }
632         }
633         // Decode the RLP encoded milestones and add them to the milestones list
634         bytes memory mProposedMilestones = proposedMilestones;
635 
636         var itmProposals = mProposedMilestones.toRLPItem(true);
637 
638         if (!itmProposals.isList()) throw;
639 
640         var itrProposals = itmProposals.iterator();
641 
642         while(itrProposals.hasNext()) {
643 
644 
645             var itmProposal = itrProposals.next();
646 
647             Milestone milestone = milestones[milestones.length ++];
648 
649             if (!itmProposal.isList()) throw;
650 
651             var itrProposal = itmProposal.iterator();
652 
653             milestone.description = itrProposal.next().toAscii();
654             milestone.url = itrProposal.next().toAscii();
655             milestone.minCompletionDate = itrProposal.next().toUint();
656             milestone.maxCompletionDate = itrProposal.next().toUint();
657             milestone.milestoneLeadLink = itrProposal.next().toAddress();
658             milestone.reviewer = itrProposal.next().toAddress();
659             milestone.reviewTime = itrProposal.next().toUint();
660             milestone.paymentSource = itrProposal.next().toAddress();
661             milestone.payData = itrProposal.next().toData();
662 
663             milestone.status = MilestoneStatus.AcceptedAndInProgress;
664 
665         }
666 
667         delete proposedMilestones;
668         changingMilestones = false;
669         NewMilestoneListAccepted();
670     }
671 
672     /// @notice `onlyRecipientOrLeadLink`Marks a milestone as DONE and
673     ///  ready for review
674     /// @param _idMilestone ID of the milestone that has been completed
675     function markMilestoneComplete(uint _idMilestone)
676         campaignNotCanceled notChanging
677     {
678         if (_idMilestone >= milestones.length) throw;
679         Milestone milestone = milestones[_idMilestone];
680         if (  (msg.sender != milestone.milestoneLeadLink)
681             &&(msg.sender != recipient))
682             throw;
683         if (milestone.status != MilestoneStatus.AcceptedAndInProgress) throw;
684         if (now < milestone.minCompletionDate) throw;
685         if (now > milestone.maxCompletionDate) throw;
686         milestone.status = MilestoneStatus.Completed;
687         milestone.doneTime = now;
688         ProposalStatusChanged(_idMilestone, milestone.status);
689     }
690 
691     /// @notice `onlyReviewer` Approves a specific milestone
692     /// @param _idMilestone ID of the milestone that is approved
693     function approveCompletedMilestone(uint _idMilestone)
694         campaignNotCanceled notChanging
695     {
696         if (_idMilestone >= milestones.length) throw;
697         Milestone milestone = milestones[_idMilestone];
698         if ((msg.sender != milestone.reviewer) ||
699             (milestone.status != MilestoneStatus.Completed)) throw;
700 
701         authorizePayment(_idMilestone);
702     }
703 
704     /// @notice `onlyReviewer` Rejects a specific milestone's completion and
705     ///  reverts the `milestone.status` back to the `AcceptedAndInProgress`
706     ///  state
707     /// @param _idMilestone ID of the milestone that is being rejected
708     function rejectMilestone(uint _idMilestone)
709         campaignNotCanceled notChanging
710     {
711         if (_idMilestone >= milestones.length) throw;
712         Milestone milestone = milestones[_idMilestone];
713         if ((msg.sender != milestone.reviewer) ||
714             (milestone.status != MilestoneStatus.Completed)) throw;
715 
716         milestone.status = MilestoneStatus.AcceptedAndInProgress;
717         ProposalStatusChanged(_idMilestone, milestone.status);
718     }
719 
720     /// @notice `onlyRecipientOrLeadLink` Sends the milestone payment as
721     ///  specified in `payData`; the recipient can only call this after the
722     ///  `reviewTime` has elapsed
723     /// @param _idMilestone ID of the milestone to be paid out
724     function requestMilestonePayment(uint _idMilestone
725         ) campaignNotCanceled notChanging {
726         if (_idMilestone >= milestones.length) throw;
727         Milestone milestone = milestones[_idMilestone];
728         if (  (msg.sender != milestone.milestoneLeadLink)
729             &&(msg.sender != recipient))
730             throw;
731         if  ((milestone.status != MilestoneStatus.Completed) ||
732              (now < milestone.doneTime + milestone.reviewTime))
733             throw;
734 
735         authorizePayment(_idMilestone);
736     }
737 
738     /// @notice `onlyRecipient` Cancels a previously accepted milestone
739     /// @param _idMilestone ID of the milestone to be canceled
740     function cancelMilestone(uint _idMilestone)
741         onlyRecipient campaignNotCanceled notChanging
742     {
743         if (_idMilestone >= milestones.length) throw;
744         Milestone milestone = milestones[_idMilestone];
745         if  ((milestone.status != MilestoneStatus.AcceptedAndInProgress) &&
746              (milestone.status != MilestoneStatus.Completed))
747             throw;
748 
749         milestone.status = MilestoneStatus.Canceled;
750         ProposalStatusChanged(_idMilestone, milestone.status);
751     }
752 
753     /// @notice `onlyArbitrator` Forces a milestone to be paid out as long as it
754     /// has not been paid or canceled
755     /// @param _idMilestone ID of the milestone to be paid out
756     function arbitrateApproveMilestone(uint _idMilestone
757     ) onlyArbitrator campaignNotCanceled notChanging {
758         if (_idMilestone >= milestones.length) throw;
759         Milestone milestone = milestones[_idMilestone];
760         if  ((milestone.status != MilestoneStatus.AcceptedAndInProgress) &&
761              (milestone.status != MilestoneStatus.Completed))
762            throw;
763         authorizePayment(_idMilestone);
764     }
765 
766     /// @notice `onlyArbitrator` Cancels the entire campaign voiding all
767     ///  milestones vo
768     function arbitrateCancelCampaign() onlyArbitrator campaignNotCanceled {
769         campaignCanceled = true;
770         CampaignCanceled();
771     }
772 
773     // @dev This internal function is executed when the milestone is paid out
774     function authorizePayment(uint _idMilestone) internal {
775         if (_idMilestone >= milestones.length) throw;
776         Milestone milestone = milestones[_idMilestone];
777         // Recheck again to not pay twice
778         if (milestone.status == MilestoneStatus.AuthorizedForPayment) throw;
779         milestone.status = MilestoneStatus.AuthorizedForPayment;
780         if (!milestone.paymentSource.call.value(0)(milestone.payData))
781             throw;
782         ProposalStatusChanged(_idMilestone, milestone.status);
783     }
784 }