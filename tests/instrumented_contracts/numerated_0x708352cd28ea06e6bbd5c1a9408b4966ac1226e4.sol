1 pragma solidity ^0.4.18;
2 
3 /**
4  * A referral tree is a diffusion graph of all nodes representing campaign participants.
5  * Each invitee is assigned a referral tree after accepting an invitation. Following is
6  * an example difussion graph.
7  *
8  *                                                                  +---+
9  *                                                             +--> | 9 |
10  *                                                             |    +---+
11  *                                                             |
12  *                                                             |    +---+
13  *                                                 +---+       +--> |10 |
14  *                                            +--> | 4 |       |    +---+
15  *                                            |    +---+    +--+
16  *                                            |  (inactive) |  |    +---+
17  *                                            |             |  +--> |11 |
18  *                                            |    +---+    |  |    +---+
19  *                                       +-------> | 5 +----+  |
20  *                                       |    |    +---+       |    +---+
21  *                              +----    |    |                +--> |12 |
22  *                        +-->  | 1 +----+    |                     +---+
23  *                        |     +---+         |    +---+
24  *                        |                   +--> | 6 | +------------------>
25  *                        |                        +---+
26  *               +---+    |     +---+
27  *               | 0 | +----->  | 2 |
28  *               +---+    |     +---+
29  *                        |   (inactive)
30  *                        |                        +---+
31  *                        |     +---+         +--> | 7 |
32  *                        +-->  | 3 +---------+    +---+
33  *                              +---+         |
34  *                                            |    +---+
35  *                                            +--> | 8 |
36  *                                                 +---+
37  *
38  */
39 library Referral {
40 
41     /**
42      * @dev A user in a referral graph
43      */
44     struct Node {
45         /// This node was referred by...
46         address referrer;
47         /// Invitees (and their shares) of this node
48         mapping (address => uint) invitees;
49         /// Store keys separately
50         address[] inviteeIndex;
51         /// Reward accumulated
52         uint shares;
53         /// Used for membership check
54         bool exists;
55     }
56 
57     /**
58      * @dev A referral tree is a collection of Nodes.
59      */
60     struct Tree {
61         /// Nodes
62         mapping (address => Referral.Node) nodes;
63         /// stores keys separately
64         address[] treeIndex;
65     }
66 
67     /**
68      * @dev Find referrer of the given invitee.
69      */
70     function getReferrer (
71         Tree storage self,
72         address _invitee
73     )
74         public
75         constant
76         returns (address _referrer)
77     {
78         _referrer = self.nodes[_invitee].referrer;
79     }
80 
81     /**
82      * @dev Number of entries in referral tree.
83      */
84     function getTreeSize (
85         Tree storage self
86     )
87         public
88         constant
89         returns (uint _size)
90     {
91         _size = self.treeIndex.length;
92     }
93 
94     /**
95      * @dev Creates a new node representing an invitee and adds to a node's list of invitees.
96      */
97     function addInvitee (
98         Tree storage self,
99         address _referrer,
100         address _invitee,
101         uint _shares
102     )
103         internal
104     {
105         Node memory inviteeNode;
106         inviteeNode.referrer = _referrer;
107         inviteeNode.shares = _shares;
108         inviteeNode.exists = true;
109         self.nodes[_invitee] = inviteeNode;
110         self.treeIndex.push(_invitee);
111 
112         if (self.nodes[_referrer].exists == true) {
113             self.nodes[_referrer].invitees[_invitee] = _shares;
114             self.nodes[_referrer].inviteeIndex.push(_invitee);
115         }
116     }
117 }
118 
119 pragma solidity ^0.4.18;
120 
121 /**
122  * Bonus tiers
123  *  1 Vyral Referral - 7% bonus
124  *  2 Vyral Referrals - 8% bonus
125  *  3 Vyral Referrals - 9% bonus
126  *  4 Vyral Referrals - 10% bonus
127  *  5 Vyral Referrals - 11% bonus
128  *  6 Vyral Referrals - 12% bonus
129  *  7 Vyral Referrals - 13% bonus
130  *  8 Vyral Referrals - 14% bonus
131  *  9 Vyral Referrals - 15% bonus
132  * 10 Vyral Referrals - 16% bonus
133  * 11 Vyral Referrals - 17% bonus
134  * 12 Vyral Referrals - 18% bonus
135  * 13 Vyral Referrals - 19% bonus
136  * 14 Vyral Referrals - 20% bonus
137  * 15 Vyral Referrals - 21% bonus
138  * 16 Vyral Referrals - 22% bonus
139  * 17 Vyral Referrals - 23% bonus
140  * 18 Vyral Referrals - 24% bonus
141  * 19 Vyral Referrals - 25% bonus
142  * 20 Vyral Referrals - 26% bonus
143  * 21 Vyral Referrals - 27% bonus
144  * 22 Vyral Referrals - 28% bonus
145  * 23 Vyral Referrals - 29% bonus
146  * 24 Vyral Referrals - 30% bonus
147  * 25 Vyral Referrals - 31% bonus
148  * 26 Vyral Referrals - 32% bonus
149  * 27 Vyral Referrals - 33% bonus
150  */
151 library TieredPayoff {
152     using SafeMath for uint;
153 
154     /**
155      * Tiered payoff computes reward based on number of invitees a referrer has brought in.
156      * Returns the reward or the number of tokens referrer should be awarded.
157      *
158      * For degree == 1:
159      * tier% of shares of newly joined node
160      *
161      * For 2 <= degree < 27:
162      *   k-1
163      * (  ∑  1% of shares(node_i) )  + tier% of shares of node_k
164      *   i=1
165      *
166      * For degree > 27:
167      * tier% of shares of newly joined node
168      */
169     function payoff(
170         Referral.Tree storage self,
171         address _referrer
172     )
173         public
174         view
175         returns (uint)
176     {
177         Referral.Node node = self.nodes[_referrer];
178 
179         if(!node.exists) {
180             return 0;
181         }
182 
183         uint reward = 0;
184         uint shares = 0;
185         uint degree = node.inviteeIndex.length;
186         uint tierPercentage = getBonusPercentage(node.inviteeIndex.length);
187 
188         // No bonus if there are no invitees
189         if(degree == 0) {
190             return 0;
191         }
192 
193         assert(tierPercentage > 0);
194 
195         if(degree == 1) {
196             shares = node.invitees[node.inviteeIndex[0]];
197             reward = reward.add(shares.mul(tierPercentage).div(100));
198             return reward;
199         }
200 
201 
202         // For 2 <= degree <= 27
203         //    add 1% from the first k-1 nodes
204         //    add tier% from the last node
205         if(degree >= 2 && degree <= 27) {
206             for (uint i = 0; i < (degree - 1); i++) {
207                 shares = node.invitees[node.inviteeIndex[i]];
208                 reward = reward.add(shares.mul(1).div(100));
209             }
210         }
211 
212         // For degree > 27, referrer bonus remains constant at tier%
213         shares = node.invitees[node.inviteeIndex[degree - 1]];
214         reward = reward.add(shares.mul(tierPercentage).div(100));
215 
216         return reward;
217     }
218 
219     /**
220      * Returns bonus percentage for a given number of referrals
221      * based on comments above.
222      */
223     function getBonusPercentage(
224         uint _referrals
225     )
226         public
227         pure
228         returns (uint)
229     {
230         if (_referrals == 0) {
231             return 0;
232         }
233         if (_referrals >= 27) {
234             return 33;
235         }
236         return _referrals + 6;
237     }
238 }
239 
240 
241 contract DateTimeAPI {
242         /*
243          *  Abstract contract for interfacing with the DateTime contract.
244          *
245          */
246         function isLeapYear(uint16 year) constant returns (bool);
247         function getYear(uint timestamp) constant returns (uint16);
248         function getMonth(uint timestamp) constant returns (uint8);
249         function getDay(uint timestamp) constant returns (uint8);
250         function getHour(uint timestamp) constant returns (uint8);
251         function getMinute(uint timestamp) constant returns (uint8);
252         function getSecond(uint timestamp) constant returns (uint8);
253         function getWeekday(uint timestamp) constant returns (uint8);
254         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp);
255         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp);
256         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp);
257         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp);
258 }
259 
260 pragma solidity ^0.4.16;
261 
262 contract DateTime {
263         /*
264          *  Date and Time utilities for ethereum contracts
265          *
266          */
267         struct _DateTime {
268                 uint16 year;
269                 uint8 month;
270                 uint8 day;
271                 uint8 hour;
272                 uint8 minute;
273                 uint8 second;
274                 uint8 weekday;
275         }
276 
277         uint constant DAY_IN_SECONDS = 86400;
278         uint constant YEAR_IN_SECONDS = 31536000;
279         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
280 
281         uint constant HOUR_IN_SECONDS = 3600;
282         uint constant MINUTE_IN_SECONDS = 60;
283 
284         uint16 constant ORIGIN_YEAR = 1970;
285 
286         function isLeapYear(uint16 year) public pure returns (bool) {
287                 if (year % 4 != 0) {
288                         return false;
289                 }
290                 if (year % 100 != 0) {
291                         return true;
292                 }
293                 if (year % 400 != 0) {
294                         return false;
295                 }
296                 return true;
297         }
298 
299         function leapYearsBefore(uint year) public pure returns (uint) {
300                 year -= 1;
301                 return year / 4 - year / 100 + year / 400;
302         }
303 
304         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
305                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
306                         return 31;
307                 }
308                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
309                         return 30;
310                 }
311                 else if (isLeapYear(year)) {
312                         return 29;
313                 }
314                 else {
315                         return 28;
316                 }
317         }
318 
319         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
320                 uint secondsAccountedFor = 0;
321                 uint buf;
322                 uint8 i;
323 
324                 // Year
325                 dt.year = getYear(timestamp);
326                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
327 
328                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
329                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
330 
331                 // Month
332                 uint secondsInMonth;
333                 for (i = 1; i <= 12; i++) {
334                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
335                         if (secondsInMonth + secondsAccountedFor > timestamp) {
336                                 dt.month = i;
337                                 break;
338                         }
339                         secondsAccountedFor += secondsInMonth;
340                 }
341 
342                 // Day
343                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
344                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
345                                 dt.day = i;
346                                 break;
347                         }
348                         secondsAccountedFor += DAY_IN_SECONDS;
349                 }
350 
351                 // Hour
352                 dt.hour = getHour(timestamp);
353 
354                 // Minute
355                 dt.minute = getMinute(timestamp);
356 
357                 // Second
358                 dt.second = getSecond(timestamp);
359 
360                 // Day of week.
361                 dt.weekday = getWeekday(timestamp);
362         }
363 
364         function getYear(uint timestamp) public pure returns (uint16) {
365                 uint secondsAccountedFor = 0;
366                 uint16 year;
367                 uint numLeapYears;
368 
369                 // Year
370                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
371                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
372 
373                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
374                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
375 
376                 while (secondsAccountedFor > timestamp) {
377                         if (isLeapYear(uint16(year - 1))) {
378                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
379                         }
380                         else {
381                                 secondsAccountedFor -= YEAR_IN_SECONDS;
382                         }
383                         year -= 1;
384                 }
385                 return year;
386         }
387 
388         function getMonth(uint timestamp) public pure returns (uint8) {
389                 return parseTimestamp(timestamp).month;
390         }
391 
392         function getDay(uint timestamp) public pure returns (uint8) {
393                 return parseTimestamp(timestamp).day;
394         }
395 
396         function getHour(uint timestamp) public pure returns (uint8) {
397                 return uint8((timestamp / 60 / 60) % 24);
398         }
399 
400         function getMinute(uint timestamp) public pure returns (uint8) {
401                 return uint8((timestamp / 60) % 60);
402         }
403 
404         function getSecond(uint timestamp) public pure returns (uint8) {
405                 return uint8(timestamp % 60);
406         }
407 
408         function getWeekday(uint timestamp) public pure returns (uint8) {
409                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
410         }
411 
412         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
413                 return toTimestamp(year, month, day, 0, 0, 0);
414         }
415 
416         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
417                 return toTimestamp(year, month, day, hour, 0, 0);
418         }
419 
420         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
421                 return toTimestamp(year, month, day, hour, minute, 0);
422         }
423 
424         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
425                 uint16 i;
426 
427                 // Year
428                 for (i = ORIGIN_YEAR; i < year; i++) {
429                         if (isLeapYear(i)) {
430                                 timestamp += LEAP_YEAR_IN_SECONDS;
431                         }
432                         else {
433                                 timestamp += YEAR_IN_SECONDS;
434                         }
435                 }
436 
437                 // Month
438                 uint8[12] memory monthDayCounts;
439                 monthDayCounts[0] = 31;
440                 if (isLeapYear(year)) {
441                         monthDayCounts[1] = 29;
442                 }
443                 else {
444                         monthDayCounts[1] = 28;
445                 }
446                 monthDayCounts[2] = 31;
447                 monthDayCounts[3] = 30;
448                 monthDayCounts[4] = 31;
449                 monthDayCounts[5] = 30;
450                 monthDayCounts[6] = 31;
451                 monthDayCounts[7] = 31;
452                 monthDayCounts[8] = 30;
453                 monthDayCounts[9] = 31;
454                 monthDayCounts[10] = 30;
455                 monthDayCounts[11] = 31;
456 
457                 for (i = 1; i < month; i++) {
458                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
459                 }
460 
461                 // Day
462                 timestamp += DAY_IN_SECONDS * (day - 1);
463 
464                 // Hour
465                 timestamp += HOUR_IN_SECONDS * (hour);
466 
467                 // Minute
468                 timestamp += MINUTE_IN_SECONDS * (minute);
469 
470                 // Second
471                 timestamp += second;
472 
473                 return timestamp;
474         }
475 }
476 
477 
478 pragma solidity ^0.4.18;
479 
480 /**
481  * @author OpenZeppelin
482  * @title SafeMath
483  * @dev Math operations with safety checks that throw on error
484  */
485 library SafeMath {
486     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
487         uint256 c = a * b;
488         assert(a == 0 || c / a == b);
489         return c;
490     }
491 
492     function div(uint256 a, uint256 b) internal pure returns (uint256) {
493         // assert(b > 0); // Solidity automatically throws when dividing by 0
494         uint256 c = a / b;
495         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
496         return c;
497     }
498 
499     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
500         assert(b <= a);
501         return a - b;
502     }
503 
504     function add(uint256 a, uint256 b) internal pure returns (uint256) {
505         uint256 c = a + b;
506         assert(c >= a);
507         return c;
508     }
509 }
510 
511 pragma solidity ^0.4.18;
512 library PresaleBonuses {
513     using SafeMath for uint;
514 
515     function presaleBonusApplicator(uint _purchased, address _dateTimeLib)
516         internal view returns (uint reward)
517     {
518         DateTimeAPI dateTime = DateTimeAPI(_dateTimeLib);
519         uint hour = dateTime.getHour(block.timestamp);
520         uint day = dateTime.getDay(block.timestamp);
521 
522         /// First 4 hours bonus
523         if (day == 2 && hour >= 16 && hour < 20) {
524             return applyPercentage(_purchased, 70);
525         }
526 
527         /// First day bonus
528         if ((day == 2 && hour >= 20) || (day == 3 && hour < 5)) {
529             return applyPercentage(_purchased, 50);
530         }
531 
532         /// Second day bonus
533         if ((day == 3 && hour >= 5) || (day == 4 && hour < 5)) {
534             return applyPercentage(_purchased, 45);
535         } 
536 
537         /// Days 3 - 20 bonus
538         if (day < 22) {
539             uint numDays = day - 3;
540             if (hour < 5) {
541                 numDays--;
542             }
543 
544             return applyPercentage(_purchased, (45 - numDays));
545         }
546 
547         /// Fill the gap
548         if (day == 22 && hour < 5) {
549             return applyPercentage(_purchased, 27);
550         }
551 
552         /// Day 21 bonus
553         if ((day == 22 && hour >= 5) || (day == 23 && hour < 5)) {
554             return applyPercentage(_purchased, 25);
555         }
556 
557         /// Day 22 bonus
558         if ((day == 23 && hour >= 5) || (day == 24 && hour < 5)) {
559             return applyPercentage(_purchased, 20);
560         }
561 
562         /// Day 23 bonus
563         if ((day == 24 && hour >= 5) || (day == 25 && hour < 5)) {
564             return applyPercentage(_purchased, 15);
565         }
566 
567         //else
568         revert();
569     }
570 
571     /// Internal function to apply a specified percentage amount to an integer.
572     function applyPercentage(uint _base, uint _percentage)
573         internal pure returns (uint num)
574     {
575         num = _base.mul(_percentage).div(100);
576     }
577     
578 }
579 
580 pragma solidity ^0.4.11;
581 
582 /**
583  * @title Ownable
584  * @dev The Ownable contract has an owner address, and provides basic authorization control
585  * functions, this simplifies the implementation of "user permissions".
586  */
587 contract Ownable {
588     address public owner;
589 
590 
591     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
592 
593 
594     /**
595      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
596      * account.
597      */
598     function Ownable()
599         public
600     {
601         owner = msg.sender;
602     }
603 
604 
605     /**
606      * @dev Throws if called by any account other than the owner.
607      */
608     modifier onlyOwner() {
609         require(msg.sender == owner);
610         _;
611     }
612 
613 
614     /**
615      * @dev Allows the current owner to transfer control of the contract to a newOwner.
616      * @param newOwner The address to transfer ownership to.
617      */
618     function transferOwnership(
619         address newOwner
620     )
621         onlyOwner
622         public
623     {
624         require(newOwner != address(0));
625         OwnershipTransferred(owner, newOwner);
626         owner = newOwner;
627     }
628 
629 }
630 
631 pragma solidity ^0.4.8;
632 contract Token {
633     /* This is a slight change to the ERC20 base standard.
634     function totalSupply() constant returns (uint256 supply);
635     is replaced with:
636     uint256 public totalSupply;
637     This automatically creates a getter function for the totalSupply.
638     This is moved to the base contract since public getter functions are not
639     currently recognised as an implementation of the matching abstract
640     function by the compiler.
641     */
642     /// total amount of tokens
643     uint256 public totalSupply;
644 
645     /// @param _owner The address from which the balance will be retrieved
646     /// @return The balance
647     function balanceOf(address _owner) constant returns (uint256 balance);
648 
649     /// @notice send `_value` token to `_to` from `msg.sender`
650     /// @param _to The address of the recipient
651     /// @param _value The amount of token to be transferred
652     /// @return Whether the transfer was successful or not
653     function transfer(address _to, uint256 _value) returns (bool success);
654 
655     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
656     /// @param _from The address of the sender
657     /// @param _to The address of the recipient
658     /// @param _value The amount of token to be transferred
659     /// @return Whether the transfer was successful or not
660     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
661 
662     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
663     /// @param _spender The address of the account able to transfer the tokens
664     /// @param _value The amount of tokens to be approved for transfer
665     /// @return Whether the approval was successful or not
666     function approve(address _spender, uint256 _value) returns (bool success);
667 
668     /// @param _owner The address of the account owning tokens
669     /// @param _spender The address of the account able to transfer the tokens
670     /// @return Amount of remaining tokens allowed to spent
671     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
672 
673     event Transfer(address indexed _from, address indexed _to, uint256 _value);
674     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
675 }
676 
677 pragma solidity ^0.4.8;
678 contract StandardToken is Token {
679 
680     function transfer(address _to, uint256 _value) returns (bool success) {
681         //Default assumes totalSupply can't be over max (2^256 - 1).
682         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
683         //Replace the if with this one instead.
684         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
685         require(balances[msg.sender] >= _value);
686         balances[msg.sender] -= _value;
687         balances[_to] += _value;
688         Transfer(msg.sender, _to, _value);
689         return true;
690     }
691 
692     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
693         //same as above. Replace this line with the following if you want to protect against wrapping uints.
694         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
695         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
696         balances[_to] += _value;
697         balances[_from] -= _value;
698         allowed[_from][msg.sender] -= _value;
699         Transfer(_from, _to, _value);
700         return true;
701     }
702 
703     function balanceOf(address _owner) constant returns (uint256 balance) {
704         return balances[_owner];
705     }
706 
707     function approve(address _spender, uint256 _value) returns (bool success) {
708         allowed[msg.sender][_spender] = _value;
709         Approval(msg.sender, _spender, _value);
710         return true;
711     }
712 
713     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
714       return allowed[_owner][_spender];
715     }
716 
717     mapping (address => uint256) balances;
718     mapping (address => mapping (address => uint256)) allowed;
719 }
720 
721 pragma solidity ^0.4.8;
722 contract HumanStandardToken is StandardToken {
723 
724     /* Public variables of the token */
725 
726     /*
727     NOTE:
728     The following variables are OPTIONAL vanities. One does not have to include them.
729     They allow one to customise the token contract & in no way influences the core functionality.
730     Some wallets/interfaces might not even bother to look at this information.
731     */
732     string public name;                   //fancy name: eg Simon Bucks
733     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
734     string public symbol;                 //An identifier: eg SBX
735     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
736 
737     function HumanStandardToken(
738         uint256 _initialAmount,
739         string _tokenName,
740         uint8 _decimalUnits,
741         string _tokenSymbol
742         ) {
743         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
744         totalSupply = _initialAmount;                        // Update total supply
745         name = _tokenName;                                   // Set the name for display purposes
746         decimals = _decimalUnits;                            // Amount of decimals for display purposes
747         symbol = _tokenSymbol;                               // Set the symbol for display purposes
748     }
749 
750     /* Approves and then calls the receiving contract */
751     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
752         allowed[msg.sender][_spender] = _value;
753         Approval(msg.sender, _spender, _value);
754 
755         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
756         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
757         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
758         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
759         return true;
760     }
761 }
762 
763 pragma solidity ^0.4.17;
764 /**
765  * SHARE token is an ERC20 token.
766  */
767 contract Share is HumanStandardToken, Ownable {
768     using SafeMath for uint;
769 
770     string public constant TOKEN_NAME = "Vyral Token";
771 
772     string public constant TOKEN_SYMBOL = "SHARE";
773 
774     uint8 public constant TOKEN_DECIMALS = 18;
775 
776     uint public constant TOTAL_SUPPLY = 777777777 * (10 ** uint(TOKEN_DECIMALS));
777 
778     mapping (address => uint256) lockedBalances;
779 
780     mapping (address => bool) public transferrers;
781 
782     /**
783      * Init this contract with the same params as a HST.
784      */
785     function Share() HumanStandardToken(TOTAL_SUPPLY, TOKEN_NAME, TOKEN_DECIMALS, TOKEN_SYMBOL)
786         public
787     {
788         transferrers[msg.sender] = true;
789     }
790 
791     ///-----------------
792     /// Overrides
793     ///-----------------
794 
795     /// Off on deployment.
796     bool isTransferable = false;
797 
798     /// Bonus tokens are locked on deployment
799     bool isBonusLocked = true;
800 
801     /// Allows the owner to transfer tokens whenever, but others to only transfer after owner says so.
802     modifier canBeTransferred {
803         require(transferrers[msg.sender] || isTransferable);
804         _;
805     }
806 
807     function transferReward(
808         address _to,
809         uint _value
810     )
811         canBeTransferred
812         public
813         returns (bool)
814     {
815         require(balances[msg.sender] >= _value);
816 
817         balances[msg.sender] = balances[msg.sender].sub(_value);
818         balances[_to] = balances[_to].add(_value);
819 
820         lockedBalances[_to] = lockedBalances[_to].add(_value);
821 
822         Transfer(msg.sender, _to, _value);
823         return true;
824     }
825 
826     function transfer(
827         address _to,
828         uint _value
829     )
830         canBeTransferred
831         public
832         returns (bool)
833     {
834         require(balances[msg.sender] >= _value);
835 
836         /// Only transfer unlocked balance
837         if(isBonusLocked) {
838             require(balances[msg.sender].sub(lockedBalances[msg.sender]) >= _value);
839         }
840 
841         balances[msg.sender] = balances[msg.sender].sub(_value);
842         balances[_to] = balances[_to].add(_value);
843         Transfer(msg.sender, _to, _value);
844         return true;
845     }
846 
847     function transferFrom(
848         address _from,
849         address _to,
850         uint _value
851     )
852         canBeTransferred
853         public
854         returns (bool)
855     {
856         require(balances[_from] >= _value);
857         require(allowed[_from][msg.sender] >= _value);
858 
859         /// Only transfer unlocked balance
860         if(isBonusLocked) {
861             require(balances[_from].sub(lockedBalances[_from]) >= _value);
862         }
863 
864         allowed[_from][msg.sender] = allowed[_from][_to].sub(_value);
865         balances[_from] = balances[_from].sub(_value);
866         balances[_to] = balances[_to].add(_value);
867         Transfer(_from, _to, _value);
868         return true;
869     }
870 
871     function lockedBalanceOf(
872         address _owner
873     )
874         constant
875         returns (uint)
876     {
877         return lockedBalances[_owner];
878     }
879 
880     ///-----------------
881     /// Admin
882     ///-----------------
883 
884     function enableTransfers()
885         onlyOwner
886         external
887         returns (bool)
888     {
889         isTransferable = true;
890 
891         return isTransferable;
892     }
893 
894     function addTransferrer(
895         address _transferrer
896     )
897         public
898         onlyOwner
899     {
900         transferrers[_transferrer] = true;
901     }
902 
903 
904     /**
905      * @dev Allow bonus tokens to be withdrawn
906      */
907     function releaseBonus()
908         public
909         onlyOwner
910     {
911         isBonusLocked = false;
912     }
913 
914 }
915 
916 pragma solidity ^0.4.18;
917 
918 /**
919  * A {Campaign} represents an advertising campaign.
920  */
921 contract Campaign is Ownable {
922     using SafeMath for uint;
923     using Referral for Referral.Tree;
924     using TieredPayoff for Referral.Tree;
925 
926     /// The referral tree (k-ary tree)
927     Referral.Tree vyralTree;
928 
929     /// Token in use
930     Share public token;
931 
932     /// Budget of the campaign
933     uint public budget;
934 
935     /// Tokens spent
936     uint public cost;
937 
938     /*
939      * Modifiers
940      */
941 
942     modifier onlyNonZeroAddress(address _a) {
943         require(_a != 0);
944         _;
945     }
946 
947     modifier onlyNonSelfReferral(address _referrer, address _invitee) {
948         require(_referrer != _invitee);
949         _;
950     }
951 
952     modifier onlyOnReferral(address _invitee) {
953         require(getReferrer(_invitee) != 0x0);
954         _;
955     }
956 
957     modifier onlyIfFundsAvailable() {
958         require(getAvailableBalance() >= 0);
959         _;
960     }
961 
962 
963     /*
964      * Events
965      */
966 
967     /// A new campaign was created
968     event LogCampaignCreated(address campaign);
969 
970     /// Reward allocated
971     event LogRewardAllocated(address referrer, uint inviteeShares, uint referralReward);
972 
973 
974     /**
975      * Create a new campaign.
976      */
977     function Campaign(
978         address _token,
979         uint256 _budgetAmount
980     )
981         public
982     {
983         token = Share(_token);
984         budget = _budgetAmount;
985     }
986 
987     /**
988      * @dev Accept invitation and join contract. If referrer address is non-zero,
989      * calculate reward and transfer tokens to referrer. Referrer address will be
990      * zero if referrer is not found in the referral tree. Don't throw in such a
991      * scenario.
992      */
993     function join(
994         address _referrer,
995         address _invitee,
996         uint _shares
997     )
998         public
999         onlyOwner
1000         onlyNonZeroAddress(_invitee)
1001         onlyNonSelfReferral(_referrer, _invitee)
1002         onlyIfFundsAvailable()
1003         returns(uint reward)
1004     {
1005         Referral.Node memory referrerNode = vyralTree.nodes[_referrer];
1006 
1007         // Referrer was not found, add referrer as a new node
1008         if(referrerNode.exists == false) {
1009             vyralTree.addInvitee(owner, _referrer, 0);
1010         }
1011 
1012         // Add invitee to the tree
1013         vyralTree.addInvitee(_referrer, _invitee, _shares);
1014 
1015         // Calculate referrer's reward
1016         reward = vyralTree.payoff(_referrer);
1017 
1018         // Log event
1019         LogRewardAllocated(_referrer, _shares, reward);
1020     }
1021 
1022     /**
1023      * VyralSale (owner) transfers rewards on behalf of this contract.
1024      */
1025     function sendReward(address _who, uint _amount)
1026         onlyOwner //(ie, VyralSale)
1027         external returns (bool)
1028     {
1029         if(getAvailableBalance() >= _amount) {
1030             token.transferReward(_who, _amount);
1031             cost = cost.add(_amount);
1032             return true;
1033         } else {
1034             return false;
1035         }
1036     }
1037 
1038     /**
1039      * Return referral key of caller.
1040      */
1041     function getReferrer(
1042         address _invitee
1043     )
1044         public
1045         constant
1046         returns (address _referrer)
1047     {
1048         _referrer = vyralTree.getReferrer(_invitee);
1049     }
1050 
1051     /**
1052      * @dev Returns the size of the Referral Tree.
1053      */
1054     function getTreeSize()
1055         public
1056         constant
1057         returns (uint _size)
1058     {
1059         _size = vyralTree.getTreeSize();
1060     }
1061 
1062     /**
1063      * @dev Returns the budget as a tuple, (token address, amount)
1064      */
1065     function getBudget()
1066         public
1067         constant
1068         returns (address _token, uint _amount)
1069     {
1070         _token = token;
1071         _amount = budget;
1072     }
1073 
1074     /**
1075      * @dev Return (budget - cost)
1076      */
1077     function getAvailableBalance()
1078         public
1079         constant
1080         returns (uint _balance)
1081     {
1082         _balance = (budget - cost);
1083     }
1084 
1085     /**
1086      * Fallback. Don't send ETH to a campaign.
1087      */
1088     function() public {
1089         revert();
1090     }
1091 }
1092 
1093 pragma solidity ^0.4.17;
1094 contract Vesting is Ownable {
1095     using SafeMath for uint;
1096 
1097     Token public vestingToken;          // The address of the vesting token.
1098 
1099     struct VestingSchedule {
1100         uint startTimestamp;            // Timestamp of when vesting begins.
1101         uint cliffTimestamp;            // Timestamp of when the cliff begins.
1102         uint lockPeriod;                // Amount of time in seconds between withdrawal periods. (EG. 6 months or 1 month)
1103         uint endTimestamp;              // Timestamp of when vesting ends and tokens are completely available.
1104         uint totalAmount;               // Total amount of tokens to be vested.
1105         uint amountWithdrawn;           // The amount that has been withdrawn.
1106         address depositor;              // Address of the depositor of the tokens to be vested. (Crowdsale contract)
1107         bool isConfirmed;               // True if the registered address has confirmed the vesting schedule.
1108     }
1109 
1110     // The vesting schedule attached to a specific address.
1111     mapping (address => VestingSchedule) vestingSchedules;
1112 
1113     /// @dev Assigns a token to be vested in this contract.
1114     /// @param _token Address of the token to be vested.
1115     function Vesting(address _token) public {
1116         vestingToken = Token(_token);
1117     }
1118 
1119     function registerVestingSchedule(address _newAddress,
1120                                     address _depositor,
1121                                     uint _startTimestamp,
1122                                     uint _cliffTimestamp,
1123                                     uint _lockPeriod,
1124                                     uint _endTimestamp,
1125                                     uint _totalAmount)
1126         public onlyOwner
1127     {
1128         // Check that we are registering a depositor and the address we register to vest to 
1129         //  does not already have a depositor.
1130         require( _depositor != 0x0 );
1131         require( vestingSchedules[_newAddress].depositor == 0x0 );
1132 
1133         // Validate that the times make sense.
1134         require( _cliffTimestamp >= _startTimestamp );
1135         require( _endTimestamp > _cliffTimestamp );
1136 
1137         // Some lock period sanity checks.
1138         require( _lockPeriod != 0 ); 
1139         require( _endTimestamp.sub(_startTimestamp) > _lockPeriod );
1140 
1141         // Register the new address.
1142         vestingSchedules[_newAddress] = VestingSchedule({
1143             startTimestamp: _startTimestamp,
1144             cliffTimestamp: _cliffTimestamp,
1145             lockPeriod: _lockPeriod,
1146             endTimestamp: _endTimestamp,
1147             totalAmount: _totalAmount,
1148             amountWithdrawn: 0,
1149             depositor: _depositor,
1150             isConfirmed: false
1151         });
1152 
1153         // Log that we registered a new address.
1154         VestingScheduleRegistered(
1155             _newAddress,
1156             _depositor,
1157             _startTimestamp,
1158             _lockPeriod,
1159             _cliffTimestamp,
1160             _endTimestamp,
1161             _totalAmount
1162         );
1163     }
1164 
1165     function confirmVestingSchedule(uint _startTimestamp,
1166                                     uint _cliffTimestamp,
1167                                     uint _lockPeriod,
1168                                     uint _endTimestamp,
1169                                     uint _totalAmount)
1170         public
1171     {
1172         VestingSchedule storage vestingSchedule = vestingSchedules[msg.sender];
1173 
1174         // Check that the msg.sender has been registered but not confirmed yet.
1175         require( vestingSchedule.depositor != 0x0 );
1176         require( vestingSchedule.isConfirmed == false );
1177 
1178         // Validate the same information was registered that is being confirmed.
1179         require( vestingSchedule.startTimestamp == _startTimestamp );
1180         require( vestingSchedule.cliffTimestamp == _cliffTimestamp );
1181         require( vestingSchedule.lockPeriod == _lockPeriod );
1182         require( vestingSchedule.endTimestamp == _endTimestamp );
1183         require( vestingSchedule.totalAmount == _totalAmount );
1184 
1185         // Confirm the schedule and move the tokens here.
1186         vestingSchedule.isConfirmed = true;
1187         require(vestingToken.transferFrom(vestingSchedule.depositor, address(this), _totalAmount));
1188 
1189         // Log that the vesting schedule was confirmed.
1190         VestingScheduleConfirmed(
1191             msg.sender,
1192             vestingSchedule.depositor,
1193             vestingSchedule.startTimestamp,
1194             vestingSchedule.cliffTimestamp,
1195             vestingSchedule.lockPeriod,
1196             vestingSchedule.endTimestamp,
1197             vestingSchedule.totalAmount
1198         );
1199     }
1200 
1201     function withdrawVestedTokens()
1202         public 
1203     {
1204         VestingSchedule storage vestingSchedule = vestingSchedules[msg.sender];
1205 
1206         // Check that the vesting schedule was registered and it's after cliff time.
1207         require( vestingSchedule.isConfirmed == true );
1208         require( vestingSchedule.cliffTimestamp <= now );
1209 
1210         uint totalAmountVested = calculateTotalAmountVested(vestingSchedule);
1211         uint amountWithdrawable = totalAmountVested.sub(vestingSchedule.amountWithdrawn);
1212         vestingSchedule.amountWithdrawn = totalAmountVested;
1213 
1214         if (amountWithdrawable > 0) {
1215             canWithdraw(vestingSchedule, amountWithdrawable);
1216             require( vestingToken.transfer(msg.sender, amountWithdrawable) );
1217             Withdraw(msg.sender, amountWithdrawable);
1218         }
1219     }
1220 
1221     function calculateTotalAmountVested(VestingSchedule _vestingSchedule)
1222         internal view returns (uint _amountVested)
1223     {
1224         // If it's past the end time, the whole amount is available.
1225         if (now >= _vestingSchedule.endTimestamp) {
1226             return _vestingSchedule.totalAmount;
1227         }
1228 
1229         // Otherwise, math
1230         uint durationSinceStart = now.sub(_vestingSchedule.startTimestamp);
1231         uint totalVestingTime = SafeMath.sub(_vestingSchedule.endTimestamp, _vestingSchedule.startTimestamp);
1232         uint vestedAmount = SafeMath.div(
1233             SafeMath.mul(durationSinceStart, _vestingSchedule.totalAmount),
1234             totalVestingTime
1235         );
1236 
1237         return vestedAmount;
1238     }
1239 
1240     /// @dev Checks to see if the amount is greater than the total amount divided by the lock periods.
1241     function canWithdraw(VestingSchedule _vestingSchedule, uint _amountWithdrawable)
1242         internal view
1243     {
1244         uint lockPeriods = (_vestingSchedule.endTimestamp.sub(_vestingSchedule.startTimestamp))
1245                                                          .div(_vestingSchedule.lockPeriod);
1246 
1247         if (now < _vestingSchedule.endTimestamp) {
1248             require( _amountWithdrawable >= _vestingSchedule.totalAmount.div(lockPeriods) );
1249         }
1250     }
1251 
1252     /** ADMIN FUNCTIONS */
1253 
1254     function revokeSchedule(address _addressToRevoke, address _addressToRefund)
1255         public onlyOwner
1256     {
1257         VestingSchedule storage vestingSchedule = vestingSchedules[_addressToRevoke];
1258 
1259         require( vestingSchedule.isConfirmed == true );
1260         require( _addressToRefund != 0x0 );
1261 
1262         uint amountWithdrawable;
1263         uint amountRefundable;
1264 
1265         if (now < vestingSchedule.cliffTimestamp) {
1266             // Vesting hasn't started yet, return the whole amount
1267             amountRefundable = vestingSchedule.totalAmount;
1268 
1269             delete vestingSchedules[_addressToRevoke];
1270             require( vestingToken.transfer(_addressToRefund, amountRefundable) );
1271         } else {
1272             // Vesting has started, need to figure out how much hasn't been vested yet
1273             uint totalAmountVested = calculateTotalAmountVested(vestingSchedule);
1274             amountWithdrawable = totalAmountVested.sub(vestingSchedule.amountWithdrawn);
1275             amountRefundable = totalAmountVested.sub(vestingSchedule.amountWithdrawn);
1276 
1277             delete vestingSchedules[_addressToRevoke];
1278             require( vestingToken.transfer(_addressToRevoke, amountWithdrawable) );
1279             require( vestingToken.transfer(_addressToRefund, amountRefundable) );
1280         }
1281 
1282         VestingRevoked(_addressToRevoke, amountWithdrawable, amountRefundable);
1283     }
1284 
1285     /// @dev Changes the address for a schedule in the case of lost keys or other emergency events.
1286     function changeVestingAddress(address _oldAddress, address _newAddress)
1287         public onlyOwner
1288     {
1289         VestingSchedule storage vestingSchedule = vestingSchedules[_oldAddress];
1290 
1291         require( vestingSchedule.isConfirmed == true );
1292         require( _newAddress != 0x0 );
1293         require( vestingSchedules[_newAddress].depositor == 0x0 );
1294 
1295         VestingSchedule memory newVestingSchedule = vestingSchedule;
1296         delete vestingSchedules[_oldAddress];
1297         vestingSchedules[_newAddress] = newVestingSchedule;
1298 
1299         VestingAddressChanged(_oldAddress, _newAddress);
1300     }
1301 
1302     event VestingScheduleRegistered(
1303         address registeredAddress,
1304         address depositor,
1305         uint startTimestamp,
1306         uint cliffTimestamp,
1307         uint lockPeriod,
1308         uint endTimestamp,
1309         uint totalAmount
1310     );
1311     event VestingScheduleConfirmed(
1312         address registeredAddress,
1313         address depositor,
1314         uint startTimestamp,
1315         uint cliffTimestamp,
1316         uint lockPeriod,
1317         uint endTimestamp,
1318         uint totalAmount
1319     );
1320     event Withdraw(address registeredAddress, uint amountWithdrawn);
1321     event VestingRevoked(address revokedAddress, uint amountWithdrawn, uint amountRefunded);
1322     event VestingAddressChanged(address oldAddress, address newAddress);
1323 }
1324 
1325 
1326 // Vesting Schedules
1327 // ...................
1328 // Team tokens will be vested over 18 months with a 1/3 vested after 6 months, 1/3 vested after 12 months and 1/3 vested 
1329 // after 18 months. 
1330 // Partnership and Development + Sharing Bounties + Reserves tokens will be vested over two years with 1/24 
1331 // available upfront and 1/24 available each month after
1332 
1333 pragma solidity ^0.4.18;
1334 contract VyralSale is Ownable {
1335     using SafeMath for uint;
1336 
1337     uint public constant MIN_CONTRIBUTION = 1 ether;
1338 
1339     enum Phase {
1340         Deployed,       //0
1341         Initialized,    //1
1342         Presale,        //2
1343         Freeze,         //3
1344         Ready,          //4
1345         Crowdsale,      //5
1346         Finalized,      //6
1347         Decomissioned   //7
1348     }
1349 
1350     Phase public phase;
1351 
1352     /**
1353      * PRESALE PARAMS
1354      */
1355 
1356     uint public presaleStartTimestamp;
1357 
1358     uint public presaleEndTimestamp;
1359 
1360     uint public presaleRate;
1361 
1362     uint public presaleCap;
1363 
1364     bool public presaleCapReached;
1365 
1366     uint public soldPresale;
1367 
1368     /**
1369      * CROWDSALE PARAMS
1370      */
1371 
1372     uint public saleStartTimestamp;
1373 
1374     uint public saleEndTimestamp;
1375 
1376     uint public saleRate;
1377 
1378     uint public saleCap;
1379 
1380     bool public saleCapReached;
1381 
1382     uint public soldSale;
1383 
1384     /**
1385      * GLOBAL PARAMS
1386      */
1387     address public wallet;
1388 
1389     address public vestingWallet;
1390 
1391     Share public shareToken;
1392 
1393     Campaign public campaign;
1394 
1395     DateTime public dateTime;
1396 
1397     bool public vestingRegistered;
1398 
1399     /**
1400      * Token and budget allocation constants
1401      */
1402     uint public constant TOTAL_SUPPLY = 777777777 * (10 ** uint(18));
1403 
1404     uint public constant TEAM = TOTAL_SUPPLY.div(7);
1405 
1406     uint public constant PARTNERS = TOTAL_SUPPLY.div(7);
1407 
1408     uint public constant VYRAL_REWARDS = TOTAL_SUPPLY.div(7).mul(2);
1409 
1410     uint public constant SALE_ALLOCATION = TOTAL_SUPPLY.div(7).mul(3);
1411 
1412     /**
1413      * MODIFIERS
1414      */
1415 
1416     modifier inPhase(Phase _phase) {
1417         require(phase == _phase);
1418         _;
1419     }
1420 
1421     modifier canBuy(Phase _phase) {
1422         require(phase == Phase.Presale || phase == Phase.Crowdsale);
1423 
1424         if (_phase == Phase.Presale) {
1425             require(block.timestamp >= presaleStartTimestamp);
1426         }
1427         if (_phase == Phase.Crowdsale) {
1428             require(block.timestamp >= saleStartTimestamp);
1429         }
1430         _;
1431     }
1432 
1433     modifier stopInEmergency {
1434         require(!HALT);
1435         _;
1436     }
1437 
1438     /**
1439      * PHASES
1440      */
1441 
1442     /**
1443      * Initialize Vyral sales.
1444      */
1445     function VyralSale(
1446         address _share,
1447         address _datetime
1448     )
1449         public
1450     {
1451         phase = Phase.Deployed;
1452 
1453         shareToken = Share(_share);
1454         dateTime = DateTime(_datetime);
1455     }
1456 
1457     function initPresale(
1458         address _wallet,
1459         uint _presaleStartTimestamp,
1460         uint _presaleEndTimestamp,
1461         uint _presaleCap,
1462         uint _presaleRate
1463     )
1464         inPhase(Phase.Deployed)
1465         onlyOwner
1466         external returns (bool)
1467     {
1468         require(_wallet != 0x0);
1469         require(_presaleStartTimestamp >= block.timestamp);
1470         require(_presaleEndTimestamp > _presaleStartTimestamp);
1471         require(_presaleCap < SALE_ALLOCATION.div(_presaleRate));
1472 
1473         /// Campaign must be set first.
1474         require(address(campaign) != 0x0);
1475 
1476         wallet = _wallet;
1477         presaleStartTimestamp = _presaleStartTimestamp;
1478         presaleEndTimestamp = _presaleEndTimestamp;
1479         presaleCap = _presaleCap;
1480         presaleRate = _presaleRate;
1481 
1482         shareToken.transfer(address(campaign), VYRAL_REWARDS);
1483 
1484         phase = Phase.Initialized;
1485         return true;
1486     }
1487 
1488     /// Step 1.5 - Register Vesting Schedules
1489 
1490     function startPresale()
1491         inPhase(Phase.Initialized)
1492         onlyOwner
1493         external returns (bool)
1494     {
1495         phase = Phase.Presale;
1496         return true;
1497     }
1498 
1499     function endPresale()
1500         inPhase(Phase.Presale)
1501         onlyOwner
1502         external returns (bool)
1503     {
1504         phase = Phase.Freeze;
1505         return true;
1506     }
1507 
1508     function initSale(
1509         uint _saleStartTimestamp,
1510         uint _saleEndTimestamp,
1511         uint _saleRate
1512     )
1513         inPhase(Phase.Freeze)
1514         onlyOwner
1515         external returns (bool)
1516     {
1517         require(_saleStartTimestamp >= block.timestamp);
1518         require(_saleEndTimestamp > _saleStartTimestamp);
1519 
1520         saleStartTimestamp = _saleStartTimestamp;
1521         saleEndTimestamp = _saleEndTimestamp;
1522         saleRate = _saleRate;
1523         saleCap = (SALE_ALLOCATION.div(_saleRate)).sub(presaleCap);
1524         phase = Phase.Ready;
1525         return true;
1526     }
1527 
1528     function startSale()
1529         inPhase(Phase.Ready)
1530         onlyOwner
1531         external returns (bool)
1532     {
1533         phase = Phase.Crowdsale;
1534         return true;
1535     }
1536 
1537     function finalizeSale()
1538         inPhase(Phase.Crowdsale)
1539         onlyOwner
1540         external returns (bool)
1541     {
1542         phase = Phase.Finalized;
1543         return true;
1544     }
1545 
1546     function decomission()
1547         onlyOwner
1548         external returns (bool)
1549     {
1550         phase = Phase.Decomissioned;
1551         return true;
1552     }
1553 
1554     /** BUY TOKENS */
1555 
1556     function()
1557         stopInEmergency
1558         public payable
1559     {
1560         if (phase == Phase.Presale) {
1561             buyPresale(0x0);
1562         } else if (phase == Phase.Crowdsale) {
1563             buySale(0x0);
1564         } else {
1565             revert();
1566         }
1567     }
1568 
1569     function buyPresale(address _referrer)
1570         inPhase(Phase.Presale)
1571         canBuy(Phase.Presale)
1572         stopInEmergency
1573         public payable
1574     {
1575         require(msg.value >= MIN_CONTRIBUTION);
1576         require(!presaleCapReached);
1577 
1578         uint contribution = msg.value;
1579         uint purchased = contribution.mul(presaleRate);
1580         uint totalSold = soldPresale.add(contribution);
1581 
1582         uint excess;
1583 
1584         // extra ether sent
1585         if (totalSold >= presaleCap) {
1586             excess = totalSold.sub(presaleCap);
1587             if (excess > 0) {
1588                 purchased = purchased.sub(excess.mul(presaleRate));
1589                 contribution = contribution.sub(excess);
1590                 msg.sender.transfer(excess);
1591             }
1592             presaleCapReached = true;
1593         }
1594 
1595         soldPresale = totalSold;
1596         wallet.transfer(contribution);
1597         shareToken.transfer(msg.sender, purchased);
1598 
1599         /// Calculate reward and send it from campaign.
1600         uint reward = PresaleBonuses.presaleBonusApplicator(purchased, address(dateTime));
1601         campaign.sendReward(msg.sender, reward);
1602 
1603         if (_referrer != address(0x0)) {
1604             uint referralReward = campaign.join(_referrer, msg.sender, purchased);
1605             campaign.sendReward(_referrer, referralReward);
1606             LogReferral(_referrer, msg.sender, referralReward);
1607         }
1608 
1609         LogContribution(phase, msg.sender, contribution);
1610     }
1611 
1612     function buySale(address _referrer)
1613         inPhase(Phase.Crowdsale)
1614         canBuy(Phase.Crowdsale)
1615         stopInEmergency
1616         public payable
1617     {
1618         require(msg.value >= MIN_CONTRIBUTION);
1619         require(!saleCapReached);
1620 
1621         uint contribution = msg.value;
1622         uint purchased = contribution.mul(saleRate);
1623         uint totalSold = soldSale.add(contribution);
1624 
1625         uint excess;
1626 
1627         // extra ether sent
1628         if (totalSold >= saleCap) {
1629             excess = totalSold.sub(saleCap);
1630             if (excess > 0) {
1631                 purchased = purchased.sub(excess.mul(saleRate));
1632                 contribution = contribution.sub(excess);
1633                 msg.sender.transfer(excess);
1634             }
1635             saleCapReached = true;
1636         }
1637 
1638         soldSale = totalSold;
1639         wallet.transfer(contribution);
1640         shareToken.transfer(msg.sender, purchased);
1641 
1642         if (_referrer != address(0x0)) {
1643             uint referralReward = campaign.join(_referrer, msg.sender, purchased);
1644             campaign.sendReward(_referrer, referralReward);
1645             LogReferral(_referrer, msg.sender, referralReward);
1646         }
1647 
1648         LogContribution(phase, msg.sender, contribution);
1649     }
1650 
1651     /**
1652      * ADMIN SETTERS
1653      */
1654 
1655     function setPresaleParams(
1656         uint _presaleStartTimestamp,
1657         uint _presaleEndTimestamp,
1658         uint _presaleRate,
1659         uint _presaleCap
1660     )
1661         onlyOwner
1662         inPhase(Phase.Initialized)
1663         external returns (bool)
1664     {
1665         require(_presaleStartTimestamp >= block.timestamp);
1666         require(_presaleEndTimestamp > _presaleStartTimestamp);
1667         require(_presaleCap < SALE_ALLOCATION.div(_presaleRate));
1668 
1669         presaleStartTimestamp = _presaleStartTimestamp;
1670         presaleEndTimestamp = _presaleEndTimestamp;
1671         presaleRate = _presaleRate;
1672         presaleCap = _presaleCap;
1673     }
1674 
1675     function setCrowdsaleParams(
1676         uint _saleStartTimestamp,
1677         uint _saleEndTimestamp,
1678         uint _saleRate
1679     )
1680         onlyOwner
1681         inPhase(Phase.Ready)
1682         external returns (bool)
1683     {
1684         require(_saleStartTimestamp >= block.timestamp);
1685         require(_saleEndTimestamp > _saleStartTimestamp);
1686 
1687         saleStartTimestamp = _saleStartTimestamp;
1688         saleEndTimestamp = _saleEndTimestamp;
1689         saleRate = _saleRate;
1690         saleCap = (SALE_ALLOCATION.div(_saleRate)).sub(presaleCap);
1691     }
1692 
1693     function rewardBeneficiary(
1694         address _beneficiary,
1695         uint _tokens
1696     )
1697         onlyOwner
1698         external returns (bool)
1699     {
1700         return campaign.sendReward(_beneficiary, _tokens);
1701     }
1702 
1703     function distributeTimelockedTokens(
1704         address _beneficiary,
1705         uint _tokens
1706     )
1707         onlyOwner
1708         external returns (bool)
1709     {
1710         return shareToken.transfer(_beneficiary, _tokens);
1711     }
1712 
1713     function replaceDecomissioned(address _newAddress)
1714         onlyOwner
1715         inPhase(Phase.Decomissioned)
1716         external returns (bool)
1717     {
1718         uint allTokens = shareToken.balanceOf(address(this));
1719         shareToken.transfer(_newAddress, allTokens);
1720         campaign.transferOwnership(_newAddress);
1721 
1722         return true;
1723     }
1724 
1725     function setCampaign(
1726         address _newCampaign
1727     )
1728         onlyOwner
1729         external returns (bool)
1730     {
1731         require(address(campaign) != _newCampaign && _newCampaign != 0x0);
1732         campaign = Campaign(_newCampaign);
1733 
1734         return true;
1735     }
1736 
1737     function setVesting(
1738         address _newVesting
1739     )
1740         onlyOwner
1741         external returns (bool)
1742     {
1743         require(address(vestingWallet) != _newVesting && _newVesting != 0x0);
1744         vestingWallet = Vesting(_newVesting);
1745         shareToken.approve(address(vestingWallet), TEAM.add(PARTNERS));
1746 
1747         return true;
1748     }
1749 
1750     /**
1751      * EMERGENCY SWITCH
1752      */
1753     bool public HALT = false;
1754 
1755     function toggleHALT(bool _on)
1756         onlyOwner
1757         external returns (bool)
1758     {
1759         HALT = _on;
1760         return HALT;
1761     }
1762 
1763     /**
1764      * LOGS
1765      */
1766     event LogContribution(Phase phase, address buyer, uint contribution);
1767 
1768     event LogReferral(address referrer, address invitee, uint referralReward);
1769 }