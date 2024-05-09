1 // File: contracts/pike/BaseBank.sol
2 
3 pragma solidity >=0.5.0 <0.6.0;
4 
5 contract BaseBank {
6 
7 }
8 
9 // File: contracts/library/Ownable.sol
10 
11 pragma solidity >=0.5.0 <0.6.0;
12 
13 contract Ownable {
14     address public owner;
15 
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlySafe() {
21         require(msg.sender == owner);
22         _;
23     }
24     
25     function transferOwnership(address newOwner) public onlySafe {
26         if (newOwner != address(0)) {
27             owner = newOwner;
28         }
29     }
30 }
31 
32 // File: contracts/library/ERC20Not.sol
33 
34 pragma solidity >=0.5.0 <0.6.0;
35 
36 interface ERC20Not {
37     function decimals() external view returns (uint8);
38 
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address _owner) external view returns (uint256);
42 
43     function allowance(address _owner, address _spender)
44         external
45         view
46         returns (uint256);
47 
48     function transfer(address _to, uint256 _value) external ;
49 
50     function transferFrom(
51         address _from,
52         address _to,
53         uint256 _value
54     ) external;
55 
56     function approve(address _spender, uint256 _value) external returns (bool);
57 
58     function decreaseApproval(address _spender, uint256 _subtractedValue)
59         external
60         returns (bool);
61 
62     function increaseApproval(address _spender, uint256 _addedValue)
63         external
64         returns (bool);
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(
68         address indexed owner,
69         address indexed spender,
70         uint256 value
71     );
72 }
73 
74 // File: contracts/library/ERC20Yes.sol
75 
76 pragma solidity >=0.5.0 <0.6.0;
77 
78 // ERC Token Standard #20 Interface
79 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
80 interface ERC20Yes {
81     function totalSupply() external view returns (uint256);
82 
83     function balanceOf(address tokenOwner)
84         external
85         view
86         returns (uint256 balance);
87 
88     function allowance(address tokenOwner, address spender)
89         external
90         view
91         returns (uint256 remaining);
92 
93     function transfer(address to, uint256 tokens)
94         external
95         returns (bool success);
96 
97     function approve(address spender, uint256 tokens)
98         external
99         returns (bool success);
100 
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokens
105     ) external returns (bool success);
106 
107     event Transfer(address indexed from, address indexed to, uint256 tokens);
108     event Approval(
109         address indexed tokenOwner,
110         address indexed spender,
111         uint256 tokens
112     );
113 }
114 
115 // File: contracts/user/BaseUsers.sol
116 
117 pragma solidity >=0.5.0 <0.6.0;
118 
119 contract BaseUsers {
120     //
121     function register(address _pid, address _who) external returns (bool);
122 
123     function setActive(address _who) external returns (bool);
124     
125     function setMiner(address _who) external returns (bool);
126 
127     function isActive(address _who) external view returns (bool);
128 
129     // Determine if the address has been registered
130     function isRegister(address _who) external view returns (bool);
131 
132     // Get invitees
133     function inviteUser(address _who) external view returns (address);
134 
135     function isBlackList(address _who) external view returns (bool);
136 
137     function getUser(address _who)
138         external
139         view
140         returns (
141             address id,
142             address pid,
143             bool miner,
144             bool active,
145             uint256 created_at
146         );
147 
148 }
149 
150 // File: contracts/funds/BaseFunds.sol
151 
152 pragma solidity >=0.5.0 <0.6.0;
153 
154 contract BaseFunds {
155     function activeUser(
156         address _tokenAddress,
157         address _who,
158         uint256 _tokens
159     ) external returns (bool);
160 
161     function upgradeUser(
162         address _tokenAddress,
163         address _who,
164         uint256 _tokens
165     ) external returns (bool);
166 
167     function buyMiner(
168         address _tokenAddress,
169         address _who,
170         uint256 _tokens
171     ) external returns (bool);
172 
173     function deposit(
174         address _tokenAddress,
175         address _who,
176         uint256 _tokens
177     ) external returns (bool);
178 
179     function withdraw(
180         address _tokenAddress,
181         address _who,
182         uint256 _tokens
183     ) external returns (bool);
184 
185     function loan(
186         address _tokenAddress,
187         address _who,
188         uint256 _tokens
189     ) external returns (bool);
190 
191     function repay(
192         address _tokenAddress,
193         address _who,
194         uint256 _tokens
195     ) external returns (bool);
196 
197     function liquidate(
198         address _tokenAddress,
199         address _who,
200         address _owner,
201         uint256 _tokens
202     ) external returns (bool);
203 
204     function isToken(address _tokenAddress) external view returns (bool);
205 
206     function isErc20(address _tokenAddress) external view returns (bool);
207 }
208 
209 // File: contracts/net/BaseNet.sol
210 
211 pragma solidity >=0.5.0 <0.6.0;
212 
213 contract BaseNet {
214     address payable internal _gasAddress;
215     function register(address _who, address _pid) external returns (bool);
216 
217     function activeUser(address _tokenAddress, address _pid, address _who, uint256 _tokens) external returns (bool);
218 
219     function upgradeUser(address _tokenAddress, address _who, uint256 _tokens) external returns (bool);
220 
221     function buyMiner(address _tokenAddress, address _who, uint256 _tokens) external returns (bool);
222 
223     function repay(
224         address _tokenAddress,
225         address _who,
226         uint256 _amount
227     ) external returns (bool);
228 
229     function liquidate(
230         address _tokenAddress,
231         address _payer,
232         uint256 _amount,
233         uint256 _oid
234     ) external returns (bool);
235 
236     function loan(
237         address _tokenAddress,
238         address _who,
239         uint256 _amount,
240         uint256 _type
241     ) external returns (bool);
242 
243     function withdraw(
244         address _tokenAddress,
245         address _who,
246         uint256 _amount
247     ) external returns (bool);
248 
249     function withdrawMine(
250         address _who,
251         uint256 _amount
252     ) external returns (bool);
253 
254     function withdrawBonus(
255         address _who,
256         uint256 _amount
257     ) external returns (bool);
258 
259     function deposit(
260         address _tokenAddress,
261         address _who,
262         uint256 _amount
263     ) external returns (bool);
264 
265     function depositMine(
266         address _who,
267         uint256 _amount
268     ) external returns (bool);
269 
270     function depositBonus(
271         address _who,
272         uint256 _amount
273     ) external returns (bool);
274 
275 }
276 
277 // File: contracts/pause/BasePause.sol
278 
279 pragma solidity >=0.5.0 <0.6.0;
280 
281 contract BasePause {
282     function isPaused() external view returns (bool);
283 }
284 
285 // File: contracts/receipt/BaseReceipt.sol
286 
287 pragma solidity >=0.5.0 <0.6.0;
288 
289 contract BaseReceipt {
290     function active(uint256 _tokens)
291         external
292         payable
293         returns (bool);
294 
295     function upgrade(uint256 _tokens)
296         external
297         payable
298         returns (bool);
299 
300     function buyMiner(uint256 _tokens)
301         external
302         payable
303         returns (bool);
304 }
305 
306 // File: contracts/library/Interfaces.sol
307 
308 pragma solidity >=0.5.0 <0.6.0;
309 
310 
311 
312 
313 
314 
315 
316 
317 
318 
319 contract Interfaces is Ownable {
320     BaseNet internal NetContract;
321     BaseBank internal BankContract;
322     BaseUsers internal UserContract;
323     BaseFunds internal FundsContract;
324     BasePause internal PauseContract;
325     BaseReceipt internal ReceiptContract;
326 
327     function setBankContract(BaseBank _address) public onlySafe {
328         BankContract = _address;
329     }
330 
331     function setUserContract(BaseUsers _address) public onlySafe {
332         UserContract = _address;
333     }
334 
335     function setFundsContract(BaseFunds _address) public onlySafe {
336         FundsContract = _address;
337     }
338 
339     function setNetContract(BaseNet _address) public onlySafe {
340         NetContract = _address;
341     }
342 
343     function setPauseContract(BasePause _address) public onlySafe {
344         PauseContract = _address;
345     }
346 
347     function setReceiptContract(BaseReceipt _address) public onlySafe {
348         ReceiptContract = _address;
349     }
350 }
351 
352 // File: contracts/Bank.sol
353 
354 pragma solidity >=0.5.0 <0.6.0;
355 
356 
357 
358 contract Bank is BaseBank, Interfaces {
359     bool internal open_deposit = true;
360     bool internal open_loan = true;
361 
362     modifier isNotBlackList(address _who) {
363         require(
364             !UserContract.isBlackList(_who),
365             "You are already on the blacklist"
366         );
367         _;
368     }
369 
370     modifier whenNotPaused() {
371         require(!PauseContract.isPaused(), "Data is being maintained");
372         _;
373     }
374 
375     function() external payable {
376         revert();
377     }
378 
379     function isRegister(address _who) public view returns (bool is_register) {
380         return UserContract.isRegister(_who);
381     }
382 
383     function isActive(address _who) public view returns (bool is_active) {
384         return UserContract.isActive(_who);
385     }
386 
387     // register
388     function register(address _pid) public returns (bool) {
389         if (UserContract.register(_pid, msg.sender)) {
390             if (!NetContract.register(_pid, msg.sender)) {
391                 revert("register failed");
392             }
393             return true;
394         }
395         return false;
396     }
397 
398     // active user
399     function activeUser(
400         address _tokenAddress,
401         address _pid,
402         uint256 _tokens
403     ) public payable whenNotPaused isNotBlackList(msg.sender) {
404         require(msg.sender != _pid);
405         if (!isRegister(msg.sender)) {
406             UserContract.register(_pid, msg.sender);
407         }
408         if (address(FundsContract) == _tokenAddress) {
409             if (address(uint160(address(FundsContract))).send(msg.value)) {
410                 _tokens = msg.value;
411             } else {
412                 revert("active failed");
413             }
414         }
415         require(FundsContract.activeUser(_tokenAddress, msg.sender, _tokens));
416         require(UserContract.setActive(msg.sender));
417         if (!NetContract.activeUser(_tokenAddress, _pid, msg.sender, _tokens)) {
418             revert("active failed");
419         }
420     }
421 
422     // 升级矿工
423     function upgradeUser(address _tokenAddress, uint256 _tokens)
424         public
425         payable
426         whenNotPaused
427         isNotBlackList(msg.sender)
428     {
429         require(isActive(msg.sender));
430         if (address(FundsContract) == _tokenAddress) {
431             if (address(uint160(address(FundsContract))).send(msg.value)) {
432                 _tokens = msg.value;
433             } else {
434                 revert("upgrade failed");
435             }
436         }
437         require(FundsContract.upgradeUser(_tokenAddress, msg.sender, _tokens));
438         if (!NetContract.upgradeUser(_tokenAddress, msg.sender, _tokens)) {
439             revert("upgrade failed");
440         }
441     }
442 
443     // buy mining
444     function buyMiner(address _tokenAddress, uint256 _tokens)
445         public
446         payable
447         whenNotPaused
448         isNotBlackList(msg.sender)
449     {
450         require(isActive(msg.sender));
451         if (address(FundsContract) == _tokenAddress) {
452             if (address(uint160(address(FundsContract))).send(msg.value)) {
453                 _tokens = msg.value;
454             } else {
455                 revert("buy mining failed");
456             }
457         }
458         require(FundsContract.buyMiner(_tokenAddress, msg.sender, _tokens));
459         require(UserContract.setMiner(msg.sender));
460         if (!NetContract.buyMiner(_tokenAddress, msg.sender, _tokens)) {
461             revert("buy mining failed");
462         }
463     }
464 
465     // deposit
466     function deposit(address _tokenAddress, uint256 _tokens)
467         public
468         payable
469         whenNotPaused
470         isNotBlackList(msg.sender)
471     {
472         require(open_deposit == true);
473         require(isActive(msg.sender));
474 
475         if (address(FundsContract) == _tokenAddress) {
476             if (address(uint160(address(FundsContract))).send(msg.value)) {
477                 require(
478                     FundsContract.deposit(_tokenAddress, msg.sender, msg.value)
479                 );
480                 if (
481                     !NetContract.deposit(_tokenAddress, msg.sender, msg.value)
482                 ) {
483                     revert("deposit failed");
484                 }
485             }
486         } else {
487             require(FundsContract.deposit(_tokenAddress, msg.sender, _tokens));
488             if (!NetContract.deposit(_tokenAddress, msg.sender, _tokens)) {
489                 revert("deposit failed");
490             }
491         }
492     }
493 
494     // Tokens withdraw
495     function _withdraw(
496         address _tokenAddress,
497         address _who,
498         uint256 _tokens
499     )
500         public
501         whenNotPaused
502         isNotBlackList(_who)
503         onlySafe
504         returns (bool success)
505     {
506         require(isActive(_who));
507         return FundsContract.withdraw(_tokenAddress, _who, _tokens);
508     }
509 
510     // loan
511     function _loan(
512         address _tokenAddress,
513         address _who,
514         uint256 _tokens
515     )
516         public
517         whenNotPaused
518         isNotBlackList(_who)
519         onlySafe
520         returns (bool success)
521     {
522         require(open_loan == true);
523         require(isActive(_who));
524         return FundsContract.loan(_tokenAddress, _who, _tokens);
525     }
526 
527     // repay
528     function repay(address _tokenAddress, uint256 _tokens)
529         public
530         payable
531         whenNotPaused
532         isNotBlackList(msg.sender)
533     {
534         if (address(FundsContract) == _tokenAddress) {
535             if (address(uint160(address(FundsContract))).send(msg.value)) {
536                 require(
537                     FundsContract.repay(_tokenAddress, msg.sender, msg.value)
538                 );
539                 if (!NetContract.repay(_tokenAddress, msg.sender, msg.value)) {
540                     revert("repay failed");
541                 }
542             }
543         } else {
544             require(FundsContract.repay(_tokenAddress, msg.sender, _tokens));
545             if (!NetContract.repay(_tokenAddress, msg.sender, _tokens)) {
546                 revert("repay failed");
547             }
548         }
549     }
550 
551     // liquidate
552     function liquidate(
553         address _tokenAddress,
554         address _owner,
555         uint256 _tokens,
556         uint256 _oid
557     ) public payable whenNotPaused isNotBlackList(msg.sender) {
558         require(isActive(_owner));
559         require(isActive(msg.sender));
560         if (address(FundsContract) == _tokenAddress) {
561             if (address(uint160(address(FundsContract))).send(msg.value)) {
562                 require(
563                     FundsContract.liquidate(
564                         _tokenAddress,
565                         msg.sender,
566                         _owner,
567                         msg.value
568                     )
569                 );
570                 if (
571                     !NetContract.liquidate(
572                         _tokenAddress,
573                         msg.sender,
574                         msg.value,
575                         _oid
576                     )
577                 ) {
578                     revert("liquidate failed");
579                 }
580             }
581         } else {
582             require(
583                 FundsContract.liquidate(
584                     _tokenAddress,
585                     msg.sender,
586                     _owner,
587                     _tokens
588                 )
589             );
590             if (
591                 !NetContract.liquidate(_tokenAddress, msg.sender, _tokens, _oid)
592             ) {
593                 revert("liquidate failed");
594             }
595         }
596     }
597 
598     function loan(
599         address _tokenAddress,
600         uint256 _tokens,
601         uint256 _type
602     ) public whenNotPaused isNotBlackList(msg.sender) returns (bool) {
603         require(isActive(msg.sender));
604         if (!NetContract.loan(_tokenAddress, msg.sender, _tokens, _type)) {
605             revert("withdraw failed");
606         }
607         return true;
608     }
609 
610     function withdraw(address _tokenAddress, uint256 _tokens)
611         public
612         whenNotPaused
613         isNotBlackList(msg.sender)
614         returns (bool)
615     {
616         require(isActive(msg.sender));
617         if (!NetContract.withdraw(_tokenAddress, msg.sender, _tokens)) {
618             revert("withdraw failed");
619         }
620         return true;
621     }
622 
623     function withdrawMine(uint256 _tokens)
624         public
625         whenNotPaused
626         isNotBlackList(msg.sender)
627         returns (bool)
628     {
629         require(isActive(msg.sender));
630         if (!NetContract.withdrawMine(msg.sender, _tokens)) {
631             revert("withdraw mine failed");
632         }
633         return true;
634     }
635 
636     function withdrawBonus(uint256 _tokens)
637         public
638         whenNotPaused
639         isNotBlackList(msg.sender)
640         returns (bool)
641     {
642         require(isActive(msg.sender));
643         if (!NetContract.withdrawBonus(msg.sender, _tokens)) {
644             revert("withdraw bonus failed");
645         }
646         return true;
647     }
648 
649     function depositMine(uint256 _tokens)
650         public
651         whenNotPaused
652         isNotBlackList(msg.sender)
653         returns (bool)
654     {
655         require(isActive(msg.sender));
656         if (!NetContract.depositMine(msg.sender, _tokens)) {
657             revert("deposit mine failed");
658         }
659         return true;
660     }
661 
662     function depositBonus(uint256 _tokens)
663         public
664         whenNotPaused
665         isNotBlackList(msg.sender)
666         returns (bool)
667     {
668         require(isActive(msg.sender));
669         if (!NetContract.depositBonus(msg.sender, _tokens)) {
670             revert("deposit bonus failed");
671         }
672         return true;
673     }
674 
675     function setOpenDeposit(bool _status) public onlySafe {
676         open_deposit = _status;
677     }
678 
679     function setOpenLoan(bool _status) public onlySafe {
680         open_loan = _status;
681     }
682 
683     function getOpenDeposit() public view returns (bool deposit_status) {
684         return open_deposit;
685     }
686 
687     function getOpenLoan() public view returns (bool loan_status) {
688         return open_loan;
689     }
690 
691     // 获取存款余额
692     function balanceOf(address _tokenAddress, address _who)
693         public
694         view
695         returns (uint256 balance)
696     {
697         return ERC20Yes(_tokenAddress).balanceOf(_who);
698     }
699 
700     function balanceEth(address _tokenAddress)
701         public
702         view
703         returns (uint256 balance)
704     {
705         return address(uint160(address(_tokenAddress))).balance;
706     }
707 
708     function isPaused() public view returns (bool paused) {
709         return PauseContract.isPaused();
710     }
711 
712     function getUser(address _who)
713         public
714         view
715         returns (
716             address id,
717             address pid,
718             bool miner,
719             bool active,
720             uint256 created_at
721         )
722     {
723         return UserContract.getUser(_who);
724     }
725 }