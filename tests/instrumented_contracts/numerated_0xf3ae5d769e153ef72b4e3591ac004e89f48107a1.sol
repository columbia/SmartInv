1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function totalSupply()
5         public
6         view
7         returns (uint256);
8 
9     function balanceOf(
10         address _address)
11         public
12         view
13         returns (uint256 balance);
14 
15     function allowance(
16         address _address,
17         address _to)
18         public
19         view
20         returns (uint256 remaining);
21 
22     function transfer(
23         address _to,
24         uint256 _value)
25         public
26         returns (bool success);
27 
28     function approve(
29         address _to,
30         uint256 _value)
31         public
32         returns (bool success);
33 
34     function transferFrom(
35         address _from,
36         address _to,
37         uint256 _value)
38         public
39         returns (bool success);
40 
41     event Transfer(
42         address indexed _from,
43         address indexed _to,
44         uint256 _value
45     );
46 
47     event Approval(
48         address indexed _owner,
49         address indexed _spender,
50         uint256 _value
51     );
52 }
53 
54 
55 contract Owned {
56     address owner;
57     address newOwner;
58     uint32 transferCount;
59 
60     event TransferOwnership(
61         address indexed _from,
62         address indexed _to
63     );
64 
65     constructor() public {
66         owner = msg.sender;
67         transferCount = 0;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(
76         address _newOwner)
77         public
78         onlyOwner
79     {
80         newOwner = _newOwner;
81     }
82 
83     function viewOwner()
84         public
85         view
86         returns (address)
87     {
88         return owner;
89     }
90 
91     function viewTransferCount()
92         public
93         view
94         onlyOwner
95         returns (uint32)
96     {
97         return transferCount;
98     }
99 
100     function isTransferPending()
101         public
102         view
103         returns (bool) {
104         require(
105             msg.sender == owner ||
106             msg.sender == newOwner);
107         return newOwner != address(0);
108     }
109 
110     function acceptOwnership()
111          public
112     {
113         require(msg.sender == newOwner);
114 
115         owner = newOwner;
116         newOwner = address(0);
117         transferCount++;
118 
119         emit TransferOwnership(
120             owner,
121             newOwner
122         );
123     }
124 }
125 
126 library SafeMath {
127     function add(
128         uint256 a,
129         uint256 b)
130         internal
131         pure
132         returns(uint256 c)
133     {
134         c = a + b;
135         require(c >= a);
136     }
137 
138     function sub(
139         uint256 a,
140         uint256 b)
141         internal
142         pure
143         returns(uint256 c)
144     {
145         require(b <= a);
146         c = a - b;
147     }
148 
149     function mul(
150         uint256 a,
151         uint256 b)
152         internal
153         pure
154         returns(uint256 c) {
155         c = a * b;
156         require(a == 0 || c / a == b);
157     }
158 
159     function div(
160         uint256 a,
161         uint256 b)
162         internal
163         pure
164         returns(uint256 c) {
165         require(b > 0);
166         c = a / b;
167     }
168 }
169 
170 contract ApproveAndCallFallBack {
171     function receiveApproval(
172         address _from,
173         uint256 _value,
174         address token,
175         bytes data)
176         public
177         returns (bool success);
178 }
179 
180 
181 contract Pausable is Owned {
182   event Pause();
183   event Unpause();
184 
185   bool public paused = false;
186 
187   modifier whenNotPaused() {
188     require(!paused);
189     _;
190   }
191 
192   modifier whenPaused() {
193     require(paused);
194     _;
195   }
196 
197   function pause() onlyOwner whenNotPaused public {
198     paused = true;
199     emit Pause();
200   }
201 
202   function unpause() onlyOwner whenPaused public {
203     paused = false;
204     emit Unpause();
205   }
206 }
207 
208 
209 /**
210  * @title ERC1132 interface
211  * @dev see https://github.com/ethereum/EIPs/issues/1132
212  */
213 contract ERC1132 {
214     /**
215      * @dev Reasons why a user's tokens have been locked
216      */
217     mapping(address => bytes32[]) public lockReason;
218 
219     /**
220      * @dev locked token structure
221      */
222     struct lockToken {
223         uint256 amount;
224         uint256 validity;
225         bool claimed;
226     }
227 
228     /**
229      * @dev Holds number & validity of tokens locked for a given reason for
230      *      a specified address
231      */
232     mapping(address => mapping(bytes32 => lockToken)) public locked;
233 
234     /**
235      * @dev Records data of all the tokens Locked
236      */
237     event Locked(
238         address indexed _of,
239         bytes32 indexed _reason,
240         uint256 _amount,
241         uint256 _validity
242     );
243 
244     /**
245      * @dev Records data of all the tokens unlocked
246      */
247     event Unlocked(
248         address indexed _of,
249         bytes32 indexed _reason,
250         uint256 _amount
251     );
252 
253     /**
254      * @dev Locks a specified amount of tokens against an address,
255      *      for a specified reason and time
256      * @param _reason The reason to lock tokens
257      * @param _amount Number of tokens to be locked
258      * @param _time Lock time in seconds
259      */
260     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
261         public returns (bool);
262 
263     /**
264      * @dev Returns tokens locked for a specified address for a
265      *      specified reason
266      *
267      * @param _of The address whose tokens are locked
268      * @param _reason The reason to query the lock tokens for
269      */
270     function tokensLocked(address _of, bytes32 _reason)
271         public view returns (uint256 amount);
272 
273     /**
274      * @dev Returns tokens locked for a specified address for a
275      *      specified reason at a specific time
276      *
277      * @param _of The address whose tokens are locked
278      * @param _reason The reason to query the lock tokens for
279      * @param _time The timestamp to query the lock tokens for
280      */
281     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
282         public view returns (uint256 amount);
283 
284     /**
285      * @dev Returns total tokens held by an address (locked + transferable)
286      * @param _of The address to query the total balance of
287      */
288     function totalBalanceOf(address _of)
289         public view returns (uint256 amount);
290 
291     /**
292      * @dev Extends lock for a specified reason and time
293      * @param _reason The reason to lock tokens
294      * @param _time Lock extension time in seconds
295      */
296     function extendLock(bytes32 _reason, uint256 _time)
297         public returns (bool);
298 
299     /**
300      * @dev Increase number of tokens locked for a specified reason
301      * @param _reason The reason to lock tokens
302      * @param _amount Number of tokens to be increased
303      */
304     function increaseLockAmount(bytes32 _reason, uint256 _amount)
305         public returns (bool);
306 
307     /**
308      * @dev Returns unlockable tokens for a specified address for a specified reason
309      * @param _of The address to query the the unlockable token count of
310      * @param _reason The reason to query the unlockable tokens for
311      */
312     function tokensUnlockable(address _of, bytes32 _reason)
313         public view returns (uint256 amount);
314 
315     /**
316      * @dev Unlocks the unlockable tokens of a specified address
317      * @param _of Address of user, claiming back unlockable tokens
318      */
319     function unlock(address _of)
320         public returns (uint256 unlockableTokens);
321 
322     /**
323      * @dev Gets the unlockable tokens of a specified address
324      * @param _of The address to query the the unlockable token count of
325      */
326     function getUnlockableTokens(address _of)
327         public view returns (uint256 unlockableTokens);
328 
329 }
330 
331 
332 contract Token is ERC20Interface, Owned, Pausable, ERC1132 {
333     using SafeMath for uint256;
334 
335     string public symbol;
336     string public name;
337     uint8 public decimals;
338     uint256 private _totalSupply;
339     
340     string internal constant ALREADY_LOCKED = 'Tokens already locked';
341     string internal constant NOT_LOCKED = 'No tokens locked';
342     string internal constant AMOUNT_ZERO = 'Amount can not be 0';
343 
344     /* always capped by 10B tokens */
345     uint256 internal constant MAX_TOTAL_SUPPLY = 10000000000;
346 
347     mapping(address => uint256) balances;
348     mapping(address => mapping(address => uint256)) allowed;
349     mapping(address => uint256) incomes;
350     mapping(address => uint256) expenses;
351     mapping(address => bool) frozenAccount;
352 
353     event FreezeAccount(address _address, bool frozen);
354 
355     constructor(
356         uint256 _totalSupply_,
357         string _name,
358         string _symbol,
359         uint8 _decimals)
360         public
361     {
362         symbol = _symbol;
363         name = _name;
364         decimals = _decimals;
365         _totalSupply = _totalSupply_ * 10**uint256(_decimals);
366         balances[owner] = _totalSupply;
367 
368         emit Transfer(address(0), owner, _totalSupply);
369     }
370 
371     function totalSupply()
372         public
373         view
374         returns (uint256)
375     {
376         return _totalSupply;
377     }
378 
379     function _transfer(
380         address _from,
381         address _to,
382         uint256 _value)
383         internal
384         returns (bool success)
385     {
386         require (_to != 0x0);
387         require (balances[_from] >= _value);
388         require(!frozenAccount[_from]);
389         require(!frozenAccount[_to]);
390 
391         balances[_from] = balances[_from].sub(_value);
392         balances[_to] = balances[_to].add(_value);
393 
394         incomes[_to] = incomes[_to].add(_value);
395         expenses[_from] = expenses[_from].add(_value);
396 
397         emit Transfer(_from, _to, _value);
398 
399         return true;
400     }
401 
402     function transfer(
403         address _to,
404         uint256 _value)
405         public
406         whenNotPaused
407         returns (bool success)
408     {
409         return _transfer(msg.sender, _to, _value);
410     }
411 
412     function approve(
413         address _spender,
414         uint256 _value)
415         public
416         whenNotPaused
417         returns (bool success)
418     {
419         require (_spender != 0x0);
420         require(!frozenAccount[msg.sender]);
421         require(!frozenAccount[_spender]);
422 
423         allowed[msg.sender][_spender] = _value;
424 
425         emit Approval(msg.sender, _spender, _value);
426 
427         return true;
428     }
429 
430     function transferFrom(
431         address _from,
432         address _to,
433         uint256 _value)
434         public
435         whenNotPaused
436         returns (bool success)
437     {
438         require(!frozenAccount[msg.sender]);
439         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
440         return _transfer(_from, _to, _value);
441     }
442 
443     function balanceOf(
444         address _address)
445         public
446         view
447         returns (uint256 remaining)
448     {
449         require(_address != 0x0);
450 
451         return balances[_address];
452     }
453 
454     function incomeOf(
455         address _address)
456         public
457         view
458         returns (uint256 income)
459     {
460         require(_address != 0x0);
461 
462         return incomes[_address];
463     }
464 
465     function expenseOf(
466         address _address)
467         public
468         view
469         returns (uint256 expense)
470     {
471         require(_address != 0x0);
472 
473         return expenses[_address];
474     }
475 
476     function allowance(
477         address _owner,
478         address _spender)
479         public
480         view
481         returns (uint256 remaining)
482     {
483         require(_owner != 0x0);
484         require(_spender != 0x0);
485         return allowed[_owner][_spender];
486     }
487 
488     function approveAndCall(
489         address _spender,
490         uint256 _value,
491         bytes _data)
492         public
493         whenNotPaused
494         returns (bool success)
495     {
496         if (approve(_spender, _value)) {
497             require(ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _data) == true);
498             return true;
499         }
500         return false;
501     }
502 
503     function freezeAccount(
504         address _address,
505         bool freeze)
506         public
507         onlyOwner
508         returns (bool success)
509     {
510         frozenAccount[_address] = freeze;
511         emit FreezeAccount(_address, freeze);
512         return true;
513     }
514 
515     function isFrozenAccount(
516         address _address)
517         public
518         view
519         returns (bool frozen)
520     {
521         require(_address != 0x0);
522         return frozenAccount[_address];
523     }
524 
525     function mint(
526         uint256 amount) 
527         public 
528         onlyOwner 
529         returns (bool success)
530     {
531         uint256 newSupply = _totalSupply + amount;
532         require(newSupply <= MAX_TOTAL_SUPPLY * 10 **uint256(decimals), "ERC20: exceed maximum total supply");
533 
534         _totalSupply = newSupply;
535         balances[owner] += amount;
536         emit Transfer(address(0), owner, amount);
537         return true;
538     }
539 
540     function burn(
541         uint256 amount) 
542         public 
543         whenNotPaused
544         returns (bool success)
545     {
546         require (balances[msg.sender] >= amount);
547         require(!frozenAccount[msg.sender]);
548         balances[msg.sender] = balances[msg.sender].sub(amount);
549         _totalSupply -= amount;
550 
551         emit Transfer(msg.sender, address(0), amount);
552         return true;
553     }
554 
555      function lock(
556          bytes32 _reason, 
557          uint256 _amount, 
558          uint256 _time)
559         public
560         whenNotPaused
561         returns (bool)
562     {
563         uint256 validUntil = now.add(_time); //solhint-disable-line
564 
565         // If tokens are already locked, then functions extendLock or
566         // increaseLockAmount should be used to make any changes
567         require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
568         require(_amount != 0, AMOUNT_ZERO);
569 
570         if (locked[msg.sender][_reason].amount == 0)
571             lockReason[msg.sender].push(_reason);
572 
573         transfer(address(this), _amount);
574 
575         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
576 
577         emit Locked(msg.sender, _reason, _amount, validUntil);
578         return true;
579     }
580 
581     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
582         public
583         whenNotPaused
584         returns (bool)
585     {
586         uint256 validUntil = now.add(_time); //solhint-disable-line
587 
588         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
589         require(_amount != 0, AMOUNT_ZERO);
590 
591         if (locked[_to][_reason].amount == 0)
592             lockReason[_to].push(_reason);
593 
594         transfer(address(this), _amount);
595 
596         locked[_to][_reason] = lockToken(_amount, validUntil, false);
597 
598         emit Locked(_to, _reason, _amount, validUntil);
599         return true;
600     }
601 
602     function tokensLocked(address _of, bytes32 _reason)
603         public
604         view
605         returns (uint256 amount)
606     {
607         if (!locked[_of][_reason].claimed)
608             amount = locked[_of][_reason].amount;
609     }
610 
611     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
612         public
613         view
614         returns (uint256 amount)
615     {
616         if (locked[_of][_reason].validity > _time)
617             amount = locked[_of][_reason].amount;
618     }
619 
620     function totalBalanceOf(address _of)
621         public
622         view
623         returns (uint256 amount)
624     {
625         amount = balanceOf(_of);
626 
627         for (uint256 i = 0; i < lockReason[_of].length; i++) {
628             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
629         }
630     }
631 
632      function extendLock(bytes32 _reason, uint256 _time)
633         public
634         whenNotPaused
635         returns (bool)
636     {
637         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
638 
639         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
640 
641         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
642         return true;
643     }
644 
645     function increaseLockAmount(bytes32 _reason, uint256 _amount)
646         public
647         whenNotPaused
648         returns (bool)
649     {
650         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
651         transfer(address(this), _amount);
652 
653         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
654 
655         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
656         return true;
657     }
658 
659     function tokensUnlockable(address _of, bytes32 _reason)
660         public
661         view
662         returns (uint256 amount)
663     {
664         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
665             amount = locked[_of][_reason].amount;
666     }
667 
668     function unlock(address _of)
669         public
670         whenNotPaused
671         returns (uint256 unlockableTokens)
672     {
673         uint256 lockedTokens;
674 
675         for (uint256 i = 0; i < lockReason[_of].length; i++) {
676             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
677             if (lockedTokens > 0) {
678                 unlockableTokens = unlockableTokens.add(lockedTokens);
679                 locked[_of][lockReason[_of][i]].claimed = true;
680                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
681             }
682         }
683 
684         if (unlockableTokens > 0)
685             this.transfer(_of, unlockableTokens);
686     }
687 
688     function getUnlockableTokens(address _of)
689         public
690         view
691         returns (uint256 unlockableTokens)
692     {
693         for (uint256 i = 0; i < lockReason[_of].length; i++) {
694             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
695         }
696     }
697 
698     function () public payable {
699         revert();
700     }
701 }