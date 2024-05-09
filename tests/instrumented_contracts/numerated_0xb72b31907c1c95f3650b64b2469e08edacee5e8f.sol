1 /**
2  * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.17;
7 
8 
9 contract IERC20 {
10     string public name;
11     uint8 public decimals;
12     string public symbol;
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address _who) public view returns (uint256);
15     function allowance(address _owner, address _spender) public view returns (uint256);
16     function approve(address _spender, uint256 _value) public returns (bool);
17     function transfer(address _to, uint256 _value) public returns (bool);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 contract Context {
34     // Empty internal constructor, to prevent people from mistakenly deploying
35     // an instance of this contract, which should be used via inheritance.
36     constructor () internal { }
37     // solhint-disable-previous-line no-empty-blocks
38 
39     function _msgSender() internal view returns (address payable) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view returns (bytes memory) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor () internal {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(isOwner(), "unauthorized");
84         _;
85     }
86 
87     /**
88      * @dev Returns true if the caller is the current owner.
89      */
90     function isOwner() public view returns (bool) {
91         return _msgSender() == _owner;
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      */
105     function _transferOwnership(address newOwner) internal {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 /**
113  * Copyright (C) 2019 Aragon One <https://aragon.one/>
114  *
115  *  This program is free software: you can redistribute it and/or modify
116  *  it under the terms of the GNU General Public License as published by
117  *  the Free Software Foundation, either version 3 of the License, or
118  *  (at your option) any later version.
119  *
120  *  This program is distributed in the hope that it will be useful,
121  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
122  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
123  *  GNU General Public License for more details.
124  *
125  *  You should have received a copy of the GNU General Public License
126  *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
127  */
128 /**
129  * @title Checkpointing
130  * @notice Checkpointing library for keeping track of historical values based on an arbitrary time
131  *         unit (e.g. seconds or block numbers).
132  * @dev Adapted from:
133  *   - Checkpointing  (https://github.com/aragonone/voting-connectors/blob/master/shared/contract-utils/contracts/Checkpointing.sol)
134  */
135 library Checkpointing {
136 
137     struct Checkpoint {
138         uint256 time;
139         uint256 value;
140     }
141 
142     struct History {
143         Checkpoint[] history;
144     }
145 
146     function addCheckpoint(
147         History storage _self,
148         uint256 _time,
149         uint256 _value)
150         internal
151     {
152         uint256 length = _self.history.length;
153         if (length == 0) {
154             _self.history.push(Checkpoint(_time, _value));
155         } else {
156             Checkpoint storage currentCheckpoint = _self.history[length - 1];
157             uint256 currentCheckpointTime = currentCheckpoint.time;
158 
159             if (_time > currentCheckpointTime) {
160                 _self.history.push(Checkpoint(_time, _value));
161             } else if (_time == currentCheckpointTime) {
162                 currentCheckpoint.value = _value;
163             } else { // ensure list ordering
164                 revert("past-checkpoint");
165             }
166         }
167     }
168 
169     function getValueAt(
170         History storage _self,
171         uint256 _time)
172         internal
173         view
174         returns (uint256)
175     {
176         return _getValueAt(_self, _time);
177     }
178 
179     function lastUpdated(
180         History storage _self)
181         internal
182         view
183         returns (uint256)
184     {
185         uint256 length = _self.history.length;
186         if (length != 0) {
187             return _self.history[length - 1].time;
188         }
189     }
190 
191     function latestValue(
192         History storage _self)
193         internal
194         view
195         returns (uint256)
196     {
197         uint256 length = _self.history.length;
198         if (length != 0) {
199             return _self.history[length - 1].value;
200         }
201     }
202 
203     function _getValueAt(
204         History storage _self,
205         uint256 _time)
206         private
207         view
208         returns (uint256)
209     {
210         uint256 length = _self.history.length;
211 
212         // Short circuit if there's no checkpoints yet
213         // Note that this also lets us avoid using SafeMath later on, as we've established that
214         // there must be at least one checkpoint
215         if (length == 0) {
216             return 0;
217         }
218 
219         // Check last checkpoint
220         uint256 lastIndex = length - 1;
221         Checkpoint storage lastCheckpoint = _self.history[lastIndex];
222         if (_time >= lastCheckpoint.time) {
223             return lastCheckpoint.value;
224         }
225 
226         // Check first checkpoint (if not already checked with the above check on last)
227         if (length == 1 || _time < _self.history[0].time) {
228             return 0;
229         }
230 
231         // Do binary search
232         // As we've already checked both ends, we don't need to check the last checkpoint again
233         uint256 low = 0;
234         uint256 high = lastIndex - 1;
235 
236         while (high != low) {
237             uint256 mid = (high + low + 1) / 2; // average, ceil round
238             Checkpoint storage checkpoint = _self.history[mid];
239             uint256 midTime = checkpoint.time;
240 
241             if (_time > midTime) {
242                 low = mid;
243             } else if (_time < midTime) {
244                 // Note that we don't need SafeMath here because mid must always be greater than 0
245                 // from the while condition
246                 high = mid - 1;
247             } else {
248                 // _time == midTime
249                 return checkpoint.value;
250             }
251         }
252 
253         return _self.history[low].value;
254     }
255 }
256 
257 contract CheckpointingToken is IERC20 {
258     using Checkpointing for Checkpointing.History;
259 
260     mapping (address => mapping (address => uint256)) internal allowances_;
261 
262     mapping (address => Checkpointing.History) internal balancesHistory_;
263 
264     struct Checkpoint {
265         uint256 time;
266         uint256 value;
267     }
268 
269     struct History {
270         Checkpoint[] history;
271     }
272 
273     // override this function if a totalSupply should be tracked
274     function totalSupply()
275         public
276         view
277         returns (uint256)
278     {
279         return 0;
280     }
281 
282     function balanceOf(
283         address _owner)
284         public
285         view
286         returns (uint256)
287     {
288         return balanceOfAt(_owner, block.number);
289     }
290 
291     function balanceOfAt(
292         address _owner,
293         uint256 _blockNumber)
294         public
295         view
296         returns (uint256)
297     {
298         return balancesHistory_[_owner].getValueAt(_blockNumber);
299     }
300 
301     function allowance(
302         address _owner,
303         address _spender)
304         public
305         view
306         returns (uint256)
307     {
308         return allowances_[_owner][_spender];
309     }
310 
311     function approve(
312         address _spender,
313         uint256 _value)
314         public
315         returns (bool)
316     {
317         allowances_[msg.sender][_spender] = _value;
318         emit Approval(msg.sender, _spender, _value);
319         return true;
320     }
321 
322     function transfer(
323         address _to,
324         uint256 _value)
325         public
326         returns (bool)
327     {
328         return transferFrom(
329             msg.sender,
330             _to,
331             _value
332         );
333     }
334 
335     function transferFrom(
336         address _from,
337         address _to,
338         uint256 _value)
339         public
340         returns (bool)
341     {
342         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
343         require(previousBalanceFrom >= _value, "insufficient-balance");
344 
345         if (_from != msg.sender && allowances_[_from][msg.sender] != uint(-1)) {
346             require(allowances_[_from][msg.sender] >= _value, "insufficient-allowance");
347             allowances_[_from][msg.sender] = allowances_[_from][msg.sender] - _value; // overflow not possible
348         }
349 
350         balancesHistory_[_from].addCheckpoint(
351             block.number,
352             previousBalanceFrom - _value // overflow not possible
353         );
354 
355         balancesHistory_[_to].addCheckpoint(
356             block.number,
357             add(
358                 balanceOfAt(_to, block.number),
359                 _value
360             )
361         );
362 
363         emit Transfer(_from, _to, _value);
364         return true;
365     }
366 
367     function _getBlockNumber()
368         internal
369         view
370         returns (uint256)
371     {
372         return block.number;
373     }
374 
375     function _getTimestamp()
376         internal
377         view
378         returns (uint256)
379     {
380         return block.timestamp;
381     }
382 
383     function add(
384         uint256 x,
385         uint256 y)
386         internal
387         pure
388         returns (uint256 c)
389     {
390         require((c = x + y) >= x, "addition-overflow");
391     }
392 
393     function sub(
394         uint256 x,
395         uint256 y)
396         internal
397         pure
398         returns (uint256 c)
399     {
400         require((c = x - y) <= x, "subtraction-overflow");
401     }
402 
403     function mul(
404         uint256 a,
405         uint256 b)
406         internal
407         pure
408         returns (uint256 c)
409     {
410         if (a == 0) {
411             return 0;
412         }
413         require((c = a * b) / a == b, "multiplication-overflow");
414     }
415 
416     function div(
417         uint256 a,
418         uint256 b)
419         internal
420         pure
421         returns (uint256 c)
422     {
423         require(b != 0, "division by zero");
424         c = a / b;
425     }
426 }
427 
428 contract BZRXVestingToken is CheckpointingToken, Ownable {
429 
430     event Claim(
431         address indexed owner,
432         uint256 value
433     );
434 
435     string public constant name = "bZx Vesting Token";
436     string public constant symbol = "vBZRX";
437     uint8 public constant decimals = 18;
438 
439     uint256 public constant cliffDuration =                  15768000; // 86400 * 365 * 0.5
440     uint256 public constant vestingDuration =               126144000; // 86400 * 365 * 4
441     uint256 internal constant vestingDurationAfterCliff_ =  110376000; // 86400 * 365 * 3.5
442 
443     uint256 public constant vestingStartTimestamp =         1594648800; // start_time
444     uint256 public constant vestingCliffTimestamp =         vestingStartTimestamp + cliffDuration;
445     uint256 public constant vestingEndTimestamp =           vestingStartTimestamp + vestingDuration;
446     uint256 public constant vestingLastClaimTimestamp =     vestingEndTimestamp + 86400 * 365;
447 
448     uint256 public totalClaimed; // total claimed since start
449 
450     IERC20 public constant BZRX = IERC20(0x56d811088235F11C8920698a204A5010a788f4b3);
451 
452     uint256 internal constant startingBalance_ = 889389933e18; // 889,389,933 BZRX
453 
454     Checkpointing.History internal totalSupplyHistory_;
455 
456     mapping (address => uint256) internal lastClaimTime_;
457     mapping (address => uint256) internal userTotalClaimed_;
458 
459     bool internal isInitialized_;
460 
461 
462     // sets up vesting and deposits BZRX
463     function initialize()
464         external
465     {
466         require(!isInitialized_, "already initialized");
467 
468         balancesHistory_[msg.sender].addCheckpoint(_getBlockNumber(), startingBalance_);
469         totalSupplyHistory_.addCheckpoint(_getBlockNumber(), startingBalance_);
470 
471         emit Transfer(
472             address(0),
473             msg.sender,
474             startingBalance_
475         );
476 
477         BZRX.transferFrom(
478             msg.sender,
479             address(this),
480             startingBalance_
481         );
482 
483         isInitialized_ = true;
484     }
485 
486     function transferFrom(
487         address _from,
488         address _to,
489         uint256 _value)
490         public
491         returns (bool)
492     {
493         _claim(_from);
494         if (_from != _to) {
495             _claim(_to);
496         }
497 
498         return super.transferFrom(
499             _from,
500             _to,
501             _value
502         );
503     }
504 
505     // user can claim vested BZRX
506     function claim()
507         public
508     {
509         _claim(msg.sender);
510     }
511 
512     // user can burn remaining vBZRX tokens once fully vested; unclaimed BZRX with be withdrawn
513     function burn()
514         external
515     {
516         require(_getTimestamp() >= vestingEndTimestamp, "not fully vested");
517 
518         _claim(msg.sender);
519 
520         uint256 _blockNumber = _getBlockNumber();
521         uint256 balanceBefore = balanceOfAt(msg.sender, _blockNumber);
522         balancesHistory_[msg.sender].addCheckpoint(_blockNumber, 0);
523         totalSupplyHistory_.addCheckpoint(_blockNumber, totalSupplyAt(_blockNumber) - balanceBefore); // overflow not possible
524 
525         emit Transfer(
526             msg.sender,
527             address(0),
528             balanceBefore
529         );
530     }
531 
532     // funds unclaimed one year after vesting ends (5 years) can be rescued
533     function rescue(
534         address _receiver,
535         uint256 _amount)
536         external
537         onlyOwner
538     {
539         require(_getTimestamp() > vestingLastClaimTimestamp, "unauthorized");
540 
541         BZRX.transfer(
542             _receiver,
543             _amount
544         );
545     }
546 
547     function totalSupply()
548         public
549         view
550         returns (uint256)
551     {
552         return totalSupplyAt(_getBlockNumber());
553     }
554 
555     function totalSupplyAt(
556         uint256 _blockNumber)
557         public
558         view
559         returns (uint256)
560     {
561         return totalSupplyHistory_.getValueAt(_blockNumber);
562     }
563 
564     // total that has vested, but has not yet been claimed by a user
565     function vestedBalanceOf(
566         address _owner)
567         public
568         view
569         returns (uint256)
570     {
571         uint256 lastClaim = lastClaimTime_[_owner];
572         if (lastClaim < _getTimestamp()) {
573             return _totalVested(
574                 balanceOfAt(_owner, _getBlockNumber()),
575                 lastClaim
576             );
577         }
578     }
579 
580     // total that has not yet vested
581     function vestingBalanceOf(
582         address _owner)
583         public
584         view
585         returns (uint256 balance)
586     {
587         balance = balanceOfAt(_owner, _getBlockNumber());
588         if (balance != 0) {
589             uint256 lastClaim = lastClaimTime_[_owner];
590             if (lastClaim < _getTimestamp()) {
591                 balance = sub(
592                     balance,
593                     _totalVested(
594                         balance,
595                         lastClaim
596                     )
597                 );
598             }
599         }
600     }
601 
602     // total that has been claimed by a user
603     function claimedBalanceOf(
604         address _owner)
605         public
606         view
607         returns (uint256)
608     {
609         return userTotalClaimed_[_owner];
610     }
611 
612     // total vested since start (claimed + unclaimed)
613     function totalVested()
614         external
615         view
616         returns (uint256)
617     {
618         return _totalVested(startingBalance_, 0);
619     }
620 
621     // total unclaimed since start
622     function totalUnclaimed()
623         external
624         view
625         returns (uint256)
626     {
627         return sub(
628             _totalVested(startingBalance_, 0),
629             totalClaimed
630         );
631     }
632 
633     function _claim(
634         address _owner)
635         internal
636     {
637         uint256 vested = vestedBalanceOf(_owner);
638         if (vested != 0) {
639             userTotalClaimed_[_owner] = add(userTotalClaimed_[_owner], vested);
640             totalClaimed = add(totalClaimed, vested);
641 
642             BZRX.transfer(
643                 _owner,
644                 vested
645             );
646 
647             emit Claim(
648                 _owner,
649                 vested
650             );
651         }
652 
653         lastClaimTime_[_owner] = _getTimestamp();
654     }
655 
656     function _totalVested(
657         uint256 _proportionalSupply,
658         uint256 _lastClaimTime)
659         internal
660         view
661         returns (uint256)
662     {
663         uint256 currentTimeForVesting = _getTimestamp();
664 
665         if (currentTimeForVesting <= vestingCliffTimestamp ||
666             _lastClaimTime >= vestingEndTimestamp ||
667             currentTimeForVesting > vestingLastClaimTimestamp) {
668             // time cannot be before vesting starts
669             // OR all vested token has already been claimed
670             // OR time cannot be after last claim date
671             return 0;
672         }
673         if (_lastClaimTime < vestingCliffTimestamp) {
674             // vesting starts at the cliff timestamp
675             _lastClaimTime = vestingCliffTimestamp;
676         }
677         if (currentTimeForVesting > vestingEndTimestamp) {
678             // vesting ends at the end timestamp
679             currentTimeForVesting = vestingEndTimestamp;
680         }
681 
682         uint256 timeSinceClaim = sub(currentTimeForVesting, _lastClaimTime);
683         return mul(_proportionalSupply, timeSinceClaim) / vestingDurationAfterCliff_; // will never divide by 0
684     }
685 }