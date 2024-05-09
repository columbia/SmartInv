1 // pragma solidity ^0.5.2;
2 pragma 
3 solidity ^0.4.24;
4 
5 
6 
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10 
11         if (a == 0) {
12 
13             return 0;
14 
15         }
16 
17         uint256 c = a * b;
18 
19         assert(c / a == b);
20 
21         return c;
22 
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a / b;
27 
28         return c;
29 
30     }
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32 
33         assert(b <= a);
34 
35         return a - b;
36 
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40 
41         uint256 c = a + b;
42 
43         assert(c >= a);
44 
45         return c;
46 
47     }
48 
49 }
50 
51 
52 contract Ownable {
53 
54     address public owner;
55 
56 
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     
62     constructor() public {
63 
64         owner = msg.sender;
65 
66     }
67 
68     modifier onlyOwner() {
69 
70         require(msg.sender == owner);
71 
72         _;
73     }
74     function transferOwnership(address newOwner) public onlyOwner {
75 
76         require(newOwner != address(0));
77 
78         emit OwnershipTransferred(owner, newOwner);
79 
80         owner = newOwner;
81 
82     }
83 
84 
85 
86 
87 
88 }
89 
90 
91 
92 contract Pausable is Ownable {
93 
94     event Pause();
95 
96     event Unpause();
97 
98 
99 
100     bool public paused = false;
101 
102 
103 
104     modifier whenNotPaused() {
105 
106         require(!paused);
107 
108         _;
109 
110     }
111 
112 
113 
114     modifier whenPaused() {
115 
116         require(paused);
117 
118         _;
119 
120     }
121 
122 
123 
124     function pause() onlyOwner whenNotPaused public {
125 
126         paused = true;
127 
128         emit Pause();
129 
130     }
131 
132 
133 
134     function unpause() onlyOwner whenPaused public {
135 
136         paused = false;
137 
138         emit Unpause();
139 
140     }
141 
142 
143 }
144 
145 
146 
147 contract ERC20 {
148 
149     function balanceOf(address who) public view returns (uint256);
150 
151     function allowance(address owner, address spender) public view returns (uint256);
152 
153     function transfer(address to, uint256 value) public returns (bool);
154 
155     function approve(address spender, uint256 value) public returns (bool);
156 
157     function transferFrom(address from, address to, uint256 value) public returns (bool);
158 
159 
160 
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165 }
166 
167 
168 
169 contract Token is ERC20, Pausable {
170 
171 
172 
173     struct sUserInfo {
174 
175         uint256 balance;
176  
177         bool lock;
178 
179         mapping(address => uint256) allowed;
180 
181     }
182 
183 
184    
185     using SafeMath for uint256;
186 
187 
188 
189     string public name;
190 
191     string public symbol;
192 
193     uint256 public decimals;
194 
195     uint256 public totalSupply;
196 
197 
198 
199     bool public restoreFinished = false;
200 
201 
202 
203     mapping(address => sUserInfo) user;
204 
205 
206 
207     event Mint(uint256 value);
208 
209     event Burn(uint256 value);
210 
211     event RestoreFinished();
212 
213 
214     
215     modifier canRestore() {
216 
217         require(!restoreFinished);
218 
219         _;
220 
221     }
222 
223 
224     
225     function () external payable {
226 
227         revert();
228 
229     }
230 
231 
232     
233     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal {
234 
235         require(_to != address(this));
236 
237         require(_to != address(0));
238 
239         require(user[_from].balance >= _value);
240 
241         if(_lockCheck) {
242 
243               require(user[_from].lock == false);
244 
245         }
246 
247     }
248 
249 
250     function lock(address _owner) public onlyOwner returns (bool) {
251 
252         require(user[_owner].lock == false);
253 
254         user[_owner].lock = true;
255 
256         return true;
257 
258     }
259 
260     function unlock(address _owner) public onlyOwner returns (bool) {
261 
262         require(user[_owner].lock == true);
263 
264         user[_owner].lock = false;
265 
266        return true;
267 
268     }
269 
270 
271  
272     function burn(address _to, uint256 _value) public onlyOwner returns (bool) {
273 
274         require(_value <= user[_to].balance);
275 
276         user[_to].balance = user[_to].balance.sub(_value);
277 
278         totalSupply = totalSupply.sub(_value);
279 
280         emit Burn(_value);
281 
282         return true;
283 
284     }
285 
286 
287    
288     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
289 
290              validTransfer(msg.sender, _to, _value, false);
291 
292 
293        
294       user[msg.sender].balance = user[msg.sender].balance.sub(_value);
295 
296              user[_to].balance = user[_to].balance.add(_value);
297 
298        
299         
300              emit Transfer(msg.sender, _to, _value);
301 
302              return true;
303 
304     }
305 
306 
307 
308     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
309 
310         require(_value > 0);
311 
312         user[msg.sender].allowed[_spender] = _value;
313  
314         emit Approval(msg.sender, _spender, _value);
315         return true;
316 
317     }
318 
319 
320     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
321 
322         validTransfer(_from, _to, _value, true);
323 
324         require(_value <=  user[_from].allowed[msg.sender]);
325 
326 
327 
328 
329 
330         user[_from].balance = user[_from].balance.sub(_value);
331 
332         user[_to].balance = user[_to].balance.add(_value);
333 
334 
335 
336         user[_from].allowed[msg.sender] = user[_from].allowed[msg.sender].sub(_value);
337 
338         emit Transfer(_from, _to, _value);
339 
340         return true;
341 
342     }
343 
344 
345     
346     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
347 
348         validTransfer(msg.sender, _to, _value, true);
349 
350 
351         
352         user[msg.sender].balance = user[msg.sender].balance.sub(_value);
353 
354         user[_to].balance = user[_to].balance.add(_value);
355 
356 
357 
358         emit Transfer(msg.sender, _to, _value);
359 
360         return true;
361 
362     }
363  
364 
365     
366     function transferRestore(address _from, address _to, uint256 _value) public onlyOwner canRestore returns (bool) {
367 
368                validTransfer(_from, _to, _value, false);
369 
370 
371 
372 
373        
374         user[_from].balance = user[_from].balance.sub(_value);
375 
376                user[_to].balance = user[_to].balance.add(_value);
377 
378 
379        
380         emit Transfer(_from, _to, _value);
381 
382                return true;
383 
384     }
385 
386 
387     
388     function finishRestore() public onlyOwner returns (bool) {
389 
390         restoreFinished = true;
391 
392         emit RestoreFinished();
393 
394         return true;
395 
396     }
397 
398 
399     
400     
401     function balanceOf(address _owner) public view returns (uint256) {
402 
403         return user[_owner].balance;
404 
405     }
406 
407     function lockState(address _owner) public view returns (bool) {
408 
409         return user[_owner].lock;
410 
411     }
412 
413     function allowance(address _owner, address _spender) public view returns (uint256) {
414 
415         return user[_owner].allowed[_spender];
416 
417     }
418 
419 
420 
421     
422 }
423 
424 contract LockBalance is Ownable {
425 
426     
427     enum eLockType {None, Individual, GroupA, GroupB, GroupC, GroupD, GroupE, GroupF, GroupG, GroupH, GroupI, GroupJ}
428 
429     struct sGroupLockDate {
430         uint256[] lockTime;
431         uint256[] lockPercent;
432 
433     }
434 
435     struct sLockInfo {
436 
437         uint256[] lockType;
438         uint256[] lockBalanceStandard;
439 
440         uint256[] startTime;
441 
442         uint256[] endTime;
443 
444     }
445 
446     
447     using SafeMath for uint256;
448 
449 
450 
451         mapping(uint => sGroupLockDate) groupLockDate;
452 
453 
454     
455     mapping(address => sLockInfo) lockUser;
456 
457 
458 
459         event Lock(address indexed from, uint256 value, uint256 endTime);
460 
461     
462     function setLockUser(address _to, eLockType _lockType, uint256 _value, uint256 _endTime) internal {
463 
464         lockUser[_to].lockType.push(uint256(_lockType));
465 
466         lockUser[_to].lockBalanceStandard.push(_value);
467 
468         lockUser[_to].startTime.push(now);
469 
470         lockUser[_to].endTime.push(_endTime);
471 
472 
473 
474         emit Lock(_to, _value, _endTime);
475 
476     }
477 
478 
479 
480     function lockBalanceGroup(address _owner, uint _index) internal view returns (uint256) {
481 
482         uint256 percent = 0;
483 
484         uint256 key = uint256(lockUser[_owner].lockType[_index]);
485 
486 
487 
488 
489 
490         uint256 time = 99999999999;
491 
492         for(uint256 i = 0 ; i < groupLockDate[key].lockTime.length; i++) {
493 
494             if(now < groupLockDate[key].lockTime[i]) {
495 
496                 if(groupLockDate[key].lockTime[i] < time) {
497 
498                     time = groupLockDate[key].lockTime[i];
499 
500                     percent = groupLockDate[key].lockPercent[i];
501     
502                 }
503 
504             }
505 
506         }
507 
508 
509         
510         if(percent == 0){
511 
512             return 0;
513 
514         } else {
515 
516             return lockUser[_owner].lockBalanceStandard[_index].mul(uint256(percent)).div(100);
517 
518         }
519 
520     }
521 
522 
523 
524     function lockBalanceIndividual(address _owner, uint _index) internal view returns (uint256) {
525 
526 
527         if(now < lockUser[_owner].endTime[_index]) {
528 
529             return lockUser[_owner].lockBalanceStandard[_index];
530 
531         } else {
532 
533             return 0;
534 
535         }
536 
537     }
538 
539 
540     
541     function clearLockUser(address _owner, uint _index) onlyOwner public {
542 
543         require(lockUser[_owner].endTime.length >_index);
544 
545         lockUser[_owner].endTime[_index] = 0;
546 
547     }
548 
549 
550         
551     function addLockDate(eLockType _lockType, uint256 _second, uint256 _percent) onlyOwner public {
552 
553         require(_percent > 0 && _percent <= 100);
554 
555         sGroupLockDate storage lockInfo = groupLockDate[uint256(_lockType)];
556         bool isExists = false;
557 
558         for(uint256 i = 0; i < lockInfo.lockTime.length; i++) {
559 
560             if(lockInfo.lockTime[i] == _second) {
561 
562                 revert();
563 
564                 break;
565 
566             }
567 
568         }
569 
570 
571         
572         if(isExists) {
573 
574            revert();
575 
576         } else {
577 
578             lockInfo.lockTime.push(_second);
579 
580             lockInfo.lockPercent.push(_percent);
581 
582         }
583 
584     }
585 
586 
587     
588     function deleteLockDate(eLockType _lockType, uint256 _lockTime) onlyOwner public {
589 
590         sGroupLockDate storage lockDate = groupLockDate[uint256(_lockType)];
591 
592         
593         bool isExists = false;
594 
595         uint256 index = 0;
596 
597         for(uint256 i = 0; i < lockDate.lockTime.length; i++) {
598 
599             if(lockDate.lockTime[i] == _lockTime) {
600 
601                 isExists = true;
602 
603                 index = i;
604 
605                 break;
606 
607             }
608 
609         }
610 
611 
612         
613         if(isExists) {
614             for(uint256 k = index; k < lockDate.lockTime.length - 1; k++){
615 
616                 lockDate.lockTime[k] = lockDate.lockTime[k + 1];
617 
618                 lockDate.lockPercent[k] = lockDate.lockPercent[k + 1];
619 
620             }
621 
622             delete lockDate.lockTime[lockDate.lockTime.length - 1];
623 
624             lockDate.lockTime.length--;
625 
626             delete lockDate.lockPercent[lockDate.lockPercent.length - 1];
627 
628             lockDate.lockPercent.length--;
629 
630         } else {
631 
632             revert();
633 
634         }
635 
636         
637     }
638 
639 
640 
641 
642     function lockTypeInfoGroup(eLockType _type) public view returns (uint256[] memory , uint256[] memory ) {
643 
644  
645        uint256 key = uint256(_type);
646 
647         return (groupLockDate[key].lockTime, groupLockDate[key].lockPercent);
648 
649     }
650 
651     function lockUserInfo(address _owner) public view returns (uint256[] memory , uint256[] memory , uint256[] memory , uint256[] memory , uint256[] memory ) {
652 
653         
654         uint256[] memory balance = new uint256[](lockUser[_owner].lockType.length);
655 
656         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
657 
658             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
659 
660                 balance[i] = balance[i].add(lockBalanceIndividual(_owner, i));
661 
662             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
663 
664                 balance[i] = balance[i].add(lockBalanceGroup(_owner, i));
665 
666             }
667 
668         }
669 
670 
671         
672         return (lockUser[_owner].lockType,
673 
674         lockUser[_owner].lockBalanceStandard,
675 
676         balance,
677 
678         lockUser[_owner].startTime,
679 
680         lockUser[_owner].endTime);
681 
682     }
683 
684     function lockBalanceAll(address _owner) public view returns (uint256) {
685 
686         uint256 lockBalance = 0;
687 
688         for(uint256 i = 0; i < lockUser[_owner].lockType.length; i++){
689 
690             if(lockUser[_owner].lockType[i] == uint256(eLockType.Individual)) {
691 
692                 lockBalance = lockBalance.add(lockBalanceIndividual(_owner, i));
693 
694             } else if(lockUser[_owner].lockType[i] != uint256(eLockType.None)) {
695 
696                 lockBalance = lockBalance.add(lockBalanceGroup(_owner, i));
697 
698             }
699 
700         }
701 
702         return lockBalance;
703     }
704     
705 }
706 
707 contract SHUNYANGcoin is Token, LockBalance {
708 
709 
710 
711 
712 
713     constructor() public {
714 
715         name = "SHUNYANG";
716         symbol = "SY";
717 
718         decimals = 18;
719 
720         uint256 initialSupply = 300000000;
721         totalSupply = initialSupply * 10 ** uint(decimals);
722 
723         user[owner].balance = totalSupply;
724 
725         emit Transfer(address(0), owner, totalSupply);
726 
727     }
728 
729 
730     function validTransfer(address _from, address _to, uint256 _value, bool _lockCheck) internal {
731 
732         super.validTransfer(_from, _to, _value, _lockCheck);
733 
734         if(_lockCheck) {
735 
736             require(_value <= useBalanceOf(_from));
737 
738         }
739 
740     }
741 
742 
743     function setLockUsers(eLockType _type, address[] memory _to, uint256[] memory _value, uint256[] memory  _endTime) onlyOwner public {
744   
745         require(_to.length > 0);
746 
747         require(_to.length == _value.length);
748 
749         require(_to.length == _endTime.length);
750 
751         require(_type != eLockType.None);
752 
753         
754         for(uint256 i = 0; i < _to.length; i++){
755 
756             require(_value[i] <= useBalanceOf(_to[i]));
757 
758             setLockUser(_to[i], _type, _value[i], _endTime[i]);
759 
760         }
761 
762     }
763 
764     
765     function useBalanceOf(address _owner) public view returns (uint256) {
766 
767         return balanceOf(_owner).sub(lockBalanceAll(_owner));
768 
769     }
770 
771 
772 
773 }