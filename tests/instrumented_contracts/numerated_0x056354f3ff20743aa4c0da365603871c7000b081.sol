1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-26
3  */
4 
5 pragma solidity >0.4.99 <0.6.0;
6 
7 contract ERC20Basic {
8     function totalSupply() public view returns (uint256);
9 
10     function balanceOf(address who) public view returns (uint256);
11 
12     function transfer(address to, uint256 value) public returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address owner, address spender)
23         public
24         view
25         returns (uint256);
26 
27     function transferFrom(
28         address from,
29         address to,
30         uint256 value
31     ) public returns (bool);
32 
33     function approve(address spender, uint256 value) public returns (bool);
34 
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 library SafeERC20 {
43     function safeTransfer(
44         ERC20Basic _token,
45         address _to,
46         uint256 _value
47     ) internal {
48         require(_token.transfer(_to, _value));
49     }
50 
51     function safeTransferFrom(
52         ERC20 _token,
53         address _from,
54         address _to,
55         uint256 _value
56     ) internal {
57         require(_token.transferFrom(_from, _to, _value));
58     }
59 
60     function safeApprove(
61         ERC20 _token,
62         address _spender,
63         uint256 _value
64     ) internal {
65         require(_token.approve(_spender, _value));
66     }
67 }
68 
69 library SafeMath {
70     /**
71      * @dev Multiplies two numbers, throws on overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77         if (a == 0) {
78             return 0;
79         }
80         c = a * b;
81         assert(c / a == b);
82         return c;
83     }
84 
85     /**
86      * @dev Integer division of two numbers, truncating the quotient.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         // assert(b > 0); // Solidity automatically throws when dividing by 0
90         // uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92         return a / b;
93     }
94 
95     /**
96      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97      */
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         assert(b <= a);
100         return a - b;
101     }
102 
103     /**
104      * @dev Adds two numbers, throws on overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107         c = a + b;
108         assert(c >= a);
109         return c;
110     }
111 }
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118     using SafeMath for uint256;
119 
120     mapping(address => uint256) balances;
121 
122     uint256 totalSupply_;
123 
124     /**
125      * @dev Total number of tokens in existence
126      */
127     function totalSupply() public view returns (uint256) {
128         return totalSupply_;
129     }
130 
131     /**
132      * @dev Transfer token for a specified address
133      * @param _to The address to transfer to.
134      * @param _value The amount to be transferred.
135      */
136     function transfer(address _to, uint256 _value) public returns (bool) {
137         require(_to != address(0));
138         require(_value <= balances[msg.sender]);
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141 
142         emit Transfer(msg.sender, _to, _value);
143 
144         return true;
145     }
146 
147     /**
148      * @dev Gets the balance of the specified address.
149      * @param _owner The address to query the the balance of.
150      * @return An uint256 representing the amount owned by the passed address.
151      */
152     function balanceOf(address _owner) public view returns (uint256) {
153         return balances[_owner];
154     }
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * https://github.com/ethereum/EIPs/issues/20
162  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165     mapping(address => mapping(address => uint256)) internal allowed;
166 
167     /**
168      * @dev Transfer tokens from one address to another
169      * @param _from address The address which you want to send tokens from
170      * @param _to address The address which you want to transfer to
171      * @param _value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(
174         address _from,
175         address _to,
176         uint256 _value
177     ) public returns (bool) {
178         require(_to != address(0));
179         require(_value <= balances[_from]);
180         require(_value <= allowed[_from][msg.sender]);
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184 
185         emit Transfer(_from, _to, _value);
186 
187         return true;
188     }
189 
190     /**
191      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192      * Beware that changing an allowance with this method brings the risk that someone may use both the old
193      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      * @param _spender The address which will spend the funds.
197      * @param _value The amount of tokens to be spent.
198      */
199     function approve(address _spender, uint256 _value) public returns (bool) {
200         allowed[msg.sender][_spender] = _value;
201 
202         emit Approval(msg.sender, _spender, _value);
203 
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      */
213     function allowance(address _owner, address _spender)
214         public
215         view
216         returns (uint256)
217     {
218         return allowed[_owner][_spender];
219     }
220 
221     /**
222      * @dev Increase the amount of tokens that an owner allowed to a spender.
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseApproval(address _spender, uint256 _addedValue)
231         public
232         returns (bool)
233     {
234         allowed[msg.sender][_spender] = (
235             allowed[msg.sender][_spender].add(_addedValue)
236         );
237 
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239 
240         return true;
241     }
242 
243     /**
244      * @dev Decrease the amount of tokens that an owner allowed to a spender.
245      * approve should be called when allowed[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * @param _spender The address which will spend the funds.
250      * @param _subtractedValue The amount of tokens to decrease the allowance by.
251      */
252     function decreaseApproval(address _spender, uint256 _subtractedValue)
253         public
254         returns (bool)
255     {
256         uint256 oldValue = allowed[msg.sender][_spender];
257         if (_subtractedValue > oldValue) {
258             allowed[msg.sender][_spender] = 0;
259         } else {
260             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261         }
262 
263         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264 
265         return true;
266     }
267 }
268 
269 /**
270  * @title MultiOwnable
271  *
272  * @dev TRIX의 MultiOwnable은 히든오너, 수퍼오너, 버너, 오너, 리클레이머를 설정한다. 권한을 여러명에게 부여할 수 있는 경우
273  * 리스트에 그 값을 넣어 불특정 다수가 확인 할 수 있게 한다.
274  *
275  * TRIX的MultiOwnable可设置HIDDENOWNER，SUPEROWNER，BURNER，OWNER及RECLAIMER。
276  * 其权限可同时赋予多人的情况，在列表中放入该值后可确认其非特定的多人名单。
277  *
278  * MulitOwnable of TRIX sets HIDDENOWNER, SUPEROWNER, BURNER, OWNER, and RECLAIMER.
279  * If many can be authorized, the value is entered to the list so that it is accessible to unspecified many.
280  *
281  */
282 contract MultiOwnable {
283     uint8 constant MAX_BURN = 3;
284     uint8 constant MAX_OWNER = 15;
285     address payable public hiddenOwner;
286     address payable public superOwner;
287     address payable public reclaimer;
288 
289     address[MAX_BURN] public chkBurnerList;
290     address[MAX_OWNER] public chkOwnerList;
291 
292     mapping(address => bool) public burners;
293     mapping(address => bool) public owners;
294 
295     event AddedBurner(address indexed newBurner);
296     event AddedOwner(address indexed newOwner);
297     event DeletedOwner(address indexed toDeleteOwner);
298     event DeletedBurner(address indexed toDeleteBurner);
299     event ChangedReclaimer(address indexed newReclaimer);
300     event ChangedSuperOwner(address indexed newSuperOwner);
301     event ChangedHiddenOwner(address indexed newHiddenOwner);
302 
303     constructor() public {
304         hiddenOwner = msg.sender;
305         superOwner = msg.sender;
306         reclaimer = msg.sender;
307         owners[msg.sender] = true;
308         chkOwnerList[0] = msg.sender;
309     }
310 
311     modifier onlySuperOwner() {
312         require(superOwner == msg.sender);
313         _;
314     }
315     modifier onlyReclaimer() {
316         require(reclaimer == msg.sender);
317         _;
318     }
319     modifier onlyHiddenOwner() {
320         require(hiddenOwner == msg.sender);
321         _;
322     }
323     modifier onlyOwner() {
324         require(owners[msg.sender]);
325         _;
326     }
327     modifier onlyBurner() {
328         require(burners[msg.sender]);
329         _;
330     }
331 
332     function changeSuperOwnership(address payable newSuperOwner)
333         public
334         onlyHiddenOwner
335         returns (bool)
336     {
337         require(newSuperOwner != address(0));
338         superOwner = newSuperOwner;
339 
340         emit ChangedSuperOwner(superOwner);
341 
342         return true;
343     }
344 
345     function changeHiddenOwnership(address payable newHiddenOwner)
346         public
347         onlyHiddenOwner
348         returns (bool)
349     {
350         require(newHiddenOwner != address(0));
351         hiddenOwner = newHiddenOwner;
352 
353         emit ChangedHiddenOwner(hiddenOwner);
354 
355         return true;
356     }
357 
358     function changeReclaimer(address payable newReclaimer)
359         public
360         onlySuperOwner
361         returns (bool)
362     {
363         require(newReclaimer != address(0));
364         reclaimer = newReclaimer;
365 
366         emit ChangedReclaimer(reclaimer);
367 
368         return true;
369     }
370 
371     function addBurner(address burner, uint8 num)
372         public
373         onlySuperOwner
374         returns (bool)
375     {
376         require(num < MAX_BURN);
377         require(burner != address(0));
378         require(chkBurnerList[num] == address(0));
379         require(burners[burner] == false);
380 
381         burners[burner] = true;
382         chkBurnerList[num] = burner;
383 
384         emit AddedBurner(burner);
385 
386         return true;
387     }
388 
389     function deleteBurner(address burner, uint8 num)
390         public
391         onlySuperOwner
392         returns (bool)
393     {
394         require(num < MAX_BURN);
395         require(burner != address(0));
396         require(chkBurnerList[num] == burner);
397 
398         burners[burner] = false;
399 
400         chkBurnerList[num] = address(0);
401 
402         emit DeletedBurner(burner);
403 
404         return true;
405     }
406 
407     function addOwner(address owner, uint8 num)
408         public
409         onlySuperOwner
410         returns (bool)
411     {
412         require(num < MAX_OWNER);
413         require(owner != address(0));
414         require(chkOwnerList[num] == address(0));
415         require(owners[owner] == false);
416 
417         owners[owner] = true;
418         chkOwnerList[num] = owner;
419 
420         emit AddedOwner(owner);
421 
422         return true;
423     }
424 
425     function deleteOwner(address owner, uint8 num)
426         public
427         onlySuperOwner
428         returns (bool)
429     {
430         require(num < MAX_OWNER);
431         require(owner != address(0));
432         require(chkOwnerList[num] == owner);
433         owners[owner] = false;
434         chkOwnerList[num] = address(0);
435 
436         emit DeletedOwner(owner);
437 
438         return true;
439     }
440 }
441 
442 /**
443  * @title HasNoEther
444  */
445 contract HasNoEther is MultiOwnable {
446     using SafeERC20 for ERC20Basic;
447 
448     event ReclaimToken(address _token);
449 
450     /**
451      * @dev Constructor that rejects incoming Ether
452      * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
453      * leave out payable, then Solidity will allow inheriting contracts to implement a payable
454      * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
455      * we could use assembly to access msg.value.
456      */
457     constructor() public payable {
458         require(msg.value == 0);
459     }
460 
461     /**
462      * @dev Disallows direct send by settings a default function without the `payable` flag.
463      */
464     function() external {}
465 
466     function reclaimToken(ERC20Basic _token)
467         external
468         onlyReclaimer
469         returns (bool)
470     {
471         uint256 balance = _token.balanceOf(address(this));
472 
473         _token.safeTransfer(superOwner, balance);
474 
475         emit ReclaimToken(address(_token));
476 
477         return true;
478     }
479 }
480 
481 contract Blacklist is MultiOwnable {
482     mapping(address => bool) blacklisted;
483 
484     event Blacklisted(address indexed blacklist);
485     event Whitelisted(address indexed whitelist);
486 
487     modifier whenPermitted(address node) {
488         require(!blacklisted[node]);
489         _;
490     }
491 
492     function isPermitted(address node) public view returns (bool) {
493         return !blacklisted[node];
494     }
495 
496     function blacklist(address node) public onlyOwner returns (bool) {
497         require(!blacklisted[node]);
498         blacklisted[node] = true;
499         emit Blacklisted(node);
500 
501         return blacklisted[node];
502     }
503 
504     function unblacklist(address node) public onlySuperOwner returns (bool) {
505         require(blacklisted[node]);
506         blacklisted[node] = false;
507         emit Whitelisted(node);
508 
509         return blacklisted[node];
510     }
511 }
512 
513 contract Burnlist is Blacklist {
514     mapping(address => bool) public isburnlist;
515 
516     event Burnlisted(address indexed burnlist, bool signal);
517 
518     modifier isBurnlisted(address who) {
519         require(isburnlist[who]);
520         _;
521     }
522 
523     function addBurnlist(address node) public onlyOwner returns (bool) {
524         require(!isburnlist[node]);
525 
526         isburnlist[node] = true;
527 
528         emit Burnlisted(node, true);
529 
530         return isburnlist[node];
531     }
532 
533     function delBurnlist(address node) public onlyOwner returns (bool) {
534         require(isburnlist[node]);
535 
536         isburnlist[node] = false;
537 
538         emit Burnlisted(node, false);
539 
540         return isburnlist[node];
541     }
542 }
543 
544 contract PausableToken is StandardToken, HasNoEther, Burnlist {
545     uint8 constant MAX_BLACKTRANSFER = 10;
546     bool public paused = false;
547     address[MAX_BLACKTRANSFER] public chkBlackTransfer;
548     mapping(address => bool) public blackTransferAddrs;
549 
550     event Paused(address addr);
551     event Unpaused(address addr);
552     event AddBlackTransfer(address addr);
553     event DelBlackTransfer(address addr);
554 
555     constructor() public {}
556 
557     modifier whenNotPaused() {
558         require(!paused || owners[msg.sender]);
559         _;
560     }
561 
562     function addBlackTransfer(address blackTransfer, uint8 num)
563         public
564         onlySuperOwner
565         returns (bool)
566     {
567         require(num < MAX_BLACKTRANSFER);
568         require(blackTransfer != address(0));
569         require(!blackTransferAddrs[blackTransfer]);
570         require(chkBlackTransfer[num] == address(0));
571 
572         chkBlackTransfer[num] = blackTransfer;
573         blackTransferAddrs[blackTransfer] = true;
574 
575         emit AddBlackTransfer(blackTransfer);
576 
577         return blackTransferAddrs[blackTransfer];
578     }
579 
580     function delBlackTransfer(address blackTransfer, uint8 num)
581         public
582         onlySuperOwner
583         returns (bool)
584     {
585         require(num < MAX_BLACKTRANSFER);
586         require(blackTransfer != address(0));
587         require(blackTransferAddrs[blackTransfer]);
588         require(chkBlackTransfer[num] == blackTransfer);
589 
590         chkBlackTransfer[num] = address(0);
591         blackTransferAddrs[blackTransfer] = false;
592 
593         emit DelBlackTransfer(blackTransfer);
594 
595         return blackTransferAddrs[blackTransfer];
596     }
597 
598     function pause() public onlySuperOwner returns (bool) {
599         require(!paused);
600 
601         paused = true;
602 
603         emit Paused(msg.sender);
604 
605         return paused;
606     }
607 
608     function unpause() public onlySuperOwner returns (bool) {
609         require(paused);
610 
611         paused = false;
612 
613         emit Unpaused(msg.sender);
614 
615         return paused;
616     }
617 
618     function transfer(address to, uint256 value)
619         public
620         whenNotPaused
621         whenPermitted(msg.sender)
622         returns (bool)
623     {
624         if (blackTransferAddrs[msg.sender]) {
625             if (blacklisted[to] == false) {
626                 blacklisted[to] = true;
627                 emit Blacklisted(to);
628             }
629         }
630 
631         return super.transfer(to, value);
632     }
633 
634     function transferFrom(
635         address from,
636         address to,
637         uint256 value
638     )
639         public
640         whenNotPaused
641         whenPermitted(from)
642         whenPermitted(msg.sender)
643         returns (bool)
644     {
645         require(!blackTransferAddrs[from]);
646 
647         return super.transferFrom(from, to, value);
648     }
649 }
650 
651 /**
652  * @title TRIX
653  *
654  */
655 contract TRIX is PausableToken {
656     event Burn(address indexed burner, uint256 value);
657     event Mint(address indexed minter, uint256 value);
658 
659     string public constant name = "TriumphX";
660     uint8 public constant decimals = 18;
661     string public constant symbol = "TRIX";
662     uint256 public constant INITIAL_SUPPLY = 1e10 * (10**uint256(decimals)); // 100억개
663 
664     constructor() public {
665         totalSupply_ = INITIAL_SUPPLY;
666         balances[msg.sender] = INITIAL_SUPPLY;
667 
668         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
669     }
670 
671     function destory() public onlyHiddenOwner returns (bool) {
672         selfdestruct(superOwner);
673 
674         return true;
675     }
676 
677     /**
678      * @dev TRIX의 민트는 오직 히든오너만 실행 가능하며, 수퍼오너에게 귀속된다.
679      * 추가로 발행하려는 토큰과 기존 totalSupply_의 합이 최초 발행된 토큰의 양(INITIAL_SUPPLY)보다 클 수 없다.
680      *
681      * TRIX的MINT只能由HIDDENOWNER进行执行，其所有权归SUPEROWNER所有。
682      * 追加进行发行的数字货币与totalSupply_的和不可大于最初发行的数字货币(INITIAL_SUPPLY)数量。
683      *
684      * Only the Hiddenowner can mint TRIX, and the minted is reverted to SUPEROWNER.
685      * The sum of additional tokens to be issued and
686      * the existing totalSupply_ cannot be greater than the initially issued token supply(INITIAL_SUPPLY).
687      */
688     function mint(uint256 _amount) public onlyHiddenOwner returns (bool) {
689         require(INITIAL_SUPPLY >= totalSupply_.add(_amount));
690 
691         totalSupply_ = totalSupply_.add(_amount);
692 
693         balances[superOwner] = balances[superOwner].add(_amount);
694 
695         emit Mint(superOwner, _amount);
696 
697         emit Transfer(address(0), superOwner, _amount);
698 
699         return true;
700     }
701 
702     /**
703      * @dev TRIX의 번은 오직 버너만 실행 가능하며, Owner가 등록할 수 있는 Burnlist에 등록된 계정만 토큰 번 할 수 있다.
704      *
705      * TRIX的BURN只能由BURNER进行执行，OWNER只有登记在Burnlist的账户才能对数字货币执行BURN。
706      *
707      * Only the BURNER can burn TRIX,
708      * and only the tokens that can be burned are those on Burnlist account that Owner can register.
709      */
710     function burn(address _to, uint256 _value)
711         public
712         onlyBurner
713         isBurnlisted(_to)
714         returns (bool)
715     {
716         _burn(_to, _value);
717 
718         return true;
719     }
720 
721     function _burn(address _who, uint256 _value) internal returns (bool) {
722         require(_value <= balances[_who]);
723 
724         balances[_who] = balances[_who].sub(_value);
725         totalSupply_ = totalSupply_.sub(_value);
726 
727         emit Burn(_who, _value);
728         emit Transfer(_who, address(0), _value);
729 
730         return true;
731     }
732 }