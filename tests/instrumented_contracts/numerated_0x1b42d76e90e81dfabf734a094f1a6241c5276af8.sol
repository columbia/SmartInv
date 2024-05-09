1 // File: contracts/pike/BaseBank.sol
2 
3 pragma solidity >=0.5.0 <0.6.0;
4 
5 contract BaseBank {
6 
7 }
8 
9 
10 // File: contracts/library/ERC20Not.sol
11 
12 pragma solidity >=0.5.0 <0.6.0;
13 
14 interface ERC20Not {
15     function decimals() external view returns (uint8);
16 
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address _owner) external view returns (uint256);
20 
21     function allowance(address _owner, address _spender)
22         external
23         view
24         returns (uint256);
25 
26     function transfer(address _to, uint256 _value) external ;
27 
28     function transferFrom(
29         address _from,
30         address _to,
31         uint256 _value
32     ) external;
33 
34     function approve(address _spender, uint256 _value) external returns (bool);
35 
36     function decreaseApproval(address _spender, uint256 _subtractedValue)
37         external
38         returns (bool);
39 
40     function increaseApproval(address _spender, uint256 _addedValue)
41         external
42         returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 // File: contracts/library/ERC20Yes.sol
53 
54 pragma solidity >=0.5.0 <0.6.0;
55 
56 // ERC Token Standard #20 Interface
57 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
58 interface ERC20Yes {
59     function totalSupply() external view returns (uint256);
60 
61     function balanceOf(address tokenOwner)
62         external
63         view
64         returns (uint256 balance);
65 
66     function allowance(address tokenOwner, address spender)
67         external
68         view
69         returns (uint256 remaining);
70 
71     function transfer(address to, uint256 tokens)
72         external
73         returns (bool success);
74 
75     function approve(address spender, uint256 tokens)
76         external
77         returns (bool success);
78 
79     function transferFrom(
80         address from,
81         address to,
82         uint256 tokens
83     ) external returns (bool success);
84 
85     event Transfer(address indexed from, address indexed to, uint256 tokens);
86     event Approval(
87         address indexed tokenOwner,
88         address indexed spender,
89         uint256 tokens
90     );
91 }
92 
93 // File: contracts/user/BaseUsers.sol
94 
95 pragma solidity >=0.5.0 <0.6.0;
96 
97 contract BaseUsers {
98     //
99     function register(address _pid, address _who) external returns (bool);
100 
101     function setActive(address _who) external returns (bool);
102     
103     function setMiner(address _who) external returns (bool);
104 
105     function isActive(address _who) external view returns (bool);
106 
107     // Determine if the address has been registered
108     function isRegister(address _who) external view returns (bool);
109 
110     // Get invitees
111     function inviteUser(address _who) external view returns (address);
112 
113     function isBlackList(address _who) external view returns (bool);
114 
115     function getUser(address _who)
116         external
117         view
118         returns (
119             address id,
120             address pid,
121             bool miner,
122             bool active,
123             uint256 created_at
124         );
125 
126 }
127 
128 // File: contracts/funds/BaseFunds.sol
129 
130 pragma solidity >=0.5.0 <0.6.0;
131 
132 contract BaseFunds {
133     function activeUser(
134         address _who,
135         uint256 _tokens
136     ) external returns (bool);
137 
138     function upgradeUser(
139         address _who,
140         uint256 _tokens
141     ) external returns (bool);
142 
143     function buyMiner(
144         address _who,
145         uint256 _tokens
146     ) external returns (bool);
147 
148     function deposit(
149         address _tokenAddress,
150         address _who,
151         uint256 _tokens
152     ) external returns (bool);
153 
154     function withdraw(
155         address _tokenAddress,
156         address _who,
157         uint256 _tokens
158     ) external returns (bool);
159 
160     function loan(
161         address _tokenAddress,
162         address _who,
163         uint256 _tokens
164     ) external returns (bool);
165 
166     function repay(
167         address _tokenAddress,
168         address _who,
169         uint256 _tokens
170     ) external returns (bool);
171 
172     function liquidate(
173         address _tokenAddress,
174         address _who,
175         address _owner,
176         uint256 _tokens
177     ) external returns (bool);
178 
179     function isToken(address _tokenAddress) external view returns (bool);
180 
181     function isErc20(address _tokenAddress) external view returns (bool);
182 }
183 
184 // File: contracts/net/BaseNet.sol
185 
186 pragma solidity >=0.5.0 <0.6.0;
187 
188 contract BaseNet {
189     address payable internal _gasAddress;
190     function register(address _who, address _pid) external returns (bool);
191 
192     function activeUser(address _pid, address _who, uint256 _tokens) external returns (bool);
193 
194     function upgradeUser(address _who, uint256 _tokens) external returns (bool);
195 
196     function buyMiner(address _who, uint256 _tokens) external returns (bool);
197 
198     function deposit(
199         address _tokenAddress,
200         address _who,
201         uint256 _amount
202     ) external returns (bool);
203 
204     function repay(
205         address _tokenAddress,
206         address _who,
207         uint256 _amount
208     ) external returns (bool);
209 
210     function liquidate(
211         address _tokenAddress,
212         address _payer,
213         uint256 _amount,
214         uint256 _oid
215     ) external returns (bool);
216 }
217 
218 // File: contracts/pause/BasePause.sol
219 
220 pragma solidity >=0.5.0 <0.6.0;
221 
222 contract BasePause {
223     function isPaused() external view returns (bool);
224 }
225 
226 // File: contracts/receipt/BaseReceipt.sol
227 
228 pragma solidity >=0.5.0 <0.6.0;
229 
230 contract BaseReceipt {
231     function active(address _to, uint256 _tokens)
232         external
233         payable
234         returns (bool);
235 
236     function upgrade(address _to, uint256 _tokens)
237         external
238         payable
239         returns (bool);
240 
241     function buyMiner(address _to, uint256 _tokens)
242         external
243         payable
244         returns (bool);
245 
246     function getActive(address _who) external view returns (uint256);
247     function getUpgrade(address _who) external view returns (uint256);
248     function getMiner(address _who) external view returns (uint256);
249 }
250 
251 
252 // File: contracts/library/Ownable.sol
253 
254 pragma solidity >=0.5.0 <0.6.0;
255 
256 /**
257  * @title Ownable
258  * @dev The Ownable contract has an owner address, and provides basic authorization control
259  * functions, this simplifies the implementation of "user permissions".
260  */
261 contract Ownable {
262     address[3] internal owner;
263 
264     /**
265      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
266      * account.
267      */
268     constructor() public {
269         owner[0] = msg.sender;
270         owner[1] = msg.sender;
271         owner[2] = msg.sender;
272     }
273 
274     /**
275      * @dev Throws if called by any account other than the owner.
276      */
277     modifier onlySafe() {
278         require(
279             msg.sender == owner[0] ||
280                 msg.sender == owner[1] ||
281                 msg.sender == owner[2]
282         );
283         _;
284     }
285 
286     /**
287      * @dev Allows the current owner to transfer control of the contract to a newOwner.
288      * @param newOwner The address to transfer ownership to.
289      */
290     function transferOwnership(address newOwner, uint256 k) public onlySafe {
291         if (newOwner != address(0)) {
292             owner[k] = newOwner;
293         }
294     }
295 }
296 
297 // File: contracts/library/Interfaces.sol
298 
299 pragma solidity >=0.5.0 <0.6.0;
300 
301 contract Interfaces is Ownable {
302     BaseNet internal NetContract;
303     BaseBank internal BankContract;
304     BaseUsers internal UserContract;
305     BaseFunds internal FundsContract;
306     BasePause internal PauseContract;
307     BaseReceipt internal ReceiptContract;
308 
309     function setBankContract(BaseBank _address) public onlySafe {
310         BankContract = _address;
311     }
312 
313     function setUserContract(BaseUsers _address) public onlySafe {
314         UserContract = _address;
315     }
316 
317     function setFundsContract(BaseFunds _address) public onlySafe {
318         FundsContract = _address;
319     }
320 
321     function setNetContract(BaseNet _address) public onlySafe {
322         NetContract = _address;
323     }
324 
325     function setPauseContract(BasePause _address) public onlySafe {
326         PauseContract = _address;
327     }
328 
329     function setReceiptContract(BaseReceipt _address) public onlySafe {
330         ReceiptContract = _address;
331     }
332 }
333 
334 // File: contracts/Bank.sol
335 
336 pragma solidity >=0.5.0 <0.6.0;
337 
338 
339 
340 contract Bank is BaseBank, Interfaces {
341     bool internal open_deposit = true;
342     bool internal open_loan = true;
343 
344     modifier isNotBlackList(address _who) {
345         require(
346             !UserContract.isBlackList(_who),
347             "You are already on the blacklist"
348         );
349         _;
350     }
351 
352     modifier whenNotPaused() {
353         require(!PauseContract.isPaused(), "Data is being maintained");
354         _;
355     }
356 
357     function() external payable {
358         revert();
359     }
360 
361     function isRegister(address _who) public view returns (bool is_register) {
362         return UserContract.isRegister(_who);
363     }
364 
365     function isActive(address _who) public view returns (bool is_active) {
366         return UserContract.isActive(_who);
367     }
368 
369     // register
370     function register(address _pid) public returns (bool) {
371         if (UserContract.register(_pid, msg.sender)) {
372             if (!NetContract.register(_pid, msg.sender)) {
373                 revert("register failed");
374             }
375             return true;
376         }
377         return false;
378     }
379 
380     // active user
381     function activeUser(address _pid)
382         public
383         payable
384         whenNotPaused
385         isNotBlackList(msg.sender)
386     {
387         require(msg.sender != _pid);
388         if (!isRegister(msg.sender)) {
389             UserContract.register(_pid, msg.sender);
390         }
391         if (address(uint160(address(FundsContract))).send(msg.value)) {
392             require(FundsContract.activeUser(msg.sender, msg.value));
393             UserContract.setActive(msg.sender);
394             if (!NetContract.activeUser(_pid, msg.sender, msg.value)) {
395                 revert("upgrade failed");
396             }
397         }
398     }
399 
400     // 升级矿工
401     function upgradeUser()
402         public
403         payable
404         whenNotPaused
405         isNotBlackList(msg.sender)
406     {
407         require(isActive(msg.sender));
408         if (address(uint160(address(FundsContract))).send(msg.value)) {
409             require(FundsContract.upgradeUser(msg.sender, msg.value));
410             if (!NetContract.upgradeUser(msg.sender, msg.value)) {
411                 revert("upgrade failed");
412             }
413         }
414     }
415 
416     // buy mining
417     function buyMiner()
418         public
419         payable
420         whenNotPaused
421         isNotBlackList(msg.sender)
422     {
423         require(isActive(msg.sender));
424         if (address(uint160(address(FundsContract))).send(msg.value)) {
425             require(FundsContract.buyMiner(msg.sender, msg.value));
426             UserContract.setMiner(msg.sender);
427             if (!NetContract.buyMiner(msg.sender, msg.value)) {
428                 revert("buy mining failed");
429             }
430         }
431     }
432 
433     // deposit
434     function deposit(address _tokenAddress, uint256 _tokens)
435         public
436         payable
437         whenNotPaused
438         isNotBlackList(msg.sender)
439     {
440         require(open_deposit == true);
441         require(isActive(msg.sender));
442 
443         if (address(FundsContract) == _tokenAddress) {
444             if (address(uint160(address(FundsContract))).send(msg.value)) {
445                 require(
446                     FundsContract.deposit(_tokenAddress, msg.sender, msg.value)
447                 );
448                 if (
449                     !NetContract.deposit(_tokenAddress, msg.sender, msg.value)
450                 ) {
451                     revert("deposit failed");
452                 }
453             }
454         } else {
455             require(FundsContract.deposit(_tokenAddress, msg.sender, _tokens));
456             if (!NetContract.deposit(_tokenAddress, msg.sender, _tokens)) {
457                 revert("deposit failed");
458             }
459         }
460     }
461 
462     // Tokens withdraw
463     function withdraw(
464         address _tokenAddress,
465         address _who,
466         uint256 _tokens
467     )
468         public
469         whenNotPaused
470         isNotBlackList(_who)
471         onlySafe
472         returns (bool success)
473     {
474         require(isActive(_who));
475         return FundsContract.withdraw(_tokenAddress, _who, _tokens);
476     }
477 
478     // loan
479     function loan(
480         address _tokenAddress,
481         address _who,
482         uint256 _tokens
483     )
484         public
485         whenNotPaused
486         isNotBlackList(_who)
487         onlySafe
488         returns (bool success)
489     {
490         require(open_loan == true);
491         require(isActive(_who));
492         return FundsContract.loan(_tokenAddress, _who, _tokens);
493     }
494 
495     // repay
496     function repay(address _tokenAddress, uint256 _tokens)
497         public
498         payable
499         whenNotPaused
500         isNotBlackList(msg.sender)
501     {
502         if (address(FundsContract) == _tokenAddress) {
503             if (address(uint160(address(FundsContract))).send(msg.value)) {
504                 require(
505                     FundsContract.repay(_tokenAddress, msg.sender, msg.value)
506                 );
507                 if (!NetContract.repay(_tokenAddress, msg.sender, msg.value)) {
508                     revert("repay failed");
509                 }
510             }
511         } else {
512             require(FundsContract.repay(_tokenAddress, msg.sender, _tokens));
513             if (!NetContract.repay(_tokenAddress, msg.sender, _tokens)) {
514                 revert("repay failed");
515             }
516         }
517     }
518 
519     // liquidate
520     function liquidate(
521         address _tokenAddress,
522         address _owner,
523         uint256 _tokens,
524         uint256 _oid
525     ) public payable whenNotPaused isNotBlackList(msg.sender) {
526         require(isActive(_owner));
527         require(isActive(msg.sender));
528         if (address(FundsContract) == _tokenAddress) {
529             if (address(uint160(address(FundsContract))).send(msg.value)) {
530                 require(
531                     FundsContract.liquidate(
532                         _tokenAddress,
533                         msg.sender,
534                         _owner,
535                         msg.value
536                     )
537                 );
538                 if (
539                     !NetContract.liquidate(
540                         _tokenAddress,
541                         msg.sender,
542                         msg.value,
543                         _oid
544                     )
545                 ) {
546                     revert("liquidate failed");
547                 }
548             }
549         } else {
550             require(
551                 FundsContract.liquidate(
552                     _tokenAddress,
553                     msg.sender,
554                     _owner,
555                     _tokens
556                 )
557             );
558             if (
559                 !NetContract.liquidate(_tokenAddress, msg.sender, _tokens, _oid)
560             ) {
561                 revert("liquidate failed");
562             }
563         }
564     }
565 
566     function setOpenDeposit(bool _status) public onlySafe {
567         open_deposit = _status;
568     }
569 
570     function setOpenLoan(bool _status) public onlySafe {
571         open_loan = _status;
572     }
573 
574     function getOpenDeposit() public view returns (bool deposit_status) {
575         return open_deposit;
576     }
577 
578     function getOpenLoan() public view returns (bool loan_status) {
579         return open_loan;
580     }
581 
582     // 获取存款余额
583     function balanceOf(address _tokenAddress, address _who)
584         public
585         view
586         returns (uint256 balance)
587     {
588         return ERC20Yes(_tokenAddress).balanceOf(_who);
589     }
590 
591     function balanceEth(address _tokenAddress)
592         public
593         view
594         returns (uint256 balance)
595     {
596         return address(uint160(address(_tokenAddress))).balance;
597     }
598 
599     function isPaused() public view returns (bool paused) {
600         return PauseContract.isPaused();
601     }
602 
603     function getUser(address _who)
604         public
605         view
606         returns (
607             address id,
608             address pid,
609             bool miner,
610             bool active,
611             uint256 created_at
612         )
613     {
614         return UserContract.getUser(_who);
615     }
616 
617     function getActive(address _who) public view returns (uint256 amount) {
618         return ReceiptContract.getActive(_who);
619     }
620 
621     function getUpgrade(address _who) public view returns (uint256 amount) {
622         return ReceiptContract.getUpgrade(_who);
623     }
624 
625     function getMiner(address _who) public view returns (uint256 amount) {
626         return ReceiptContract.getMiner(_who);
627     }
628 }