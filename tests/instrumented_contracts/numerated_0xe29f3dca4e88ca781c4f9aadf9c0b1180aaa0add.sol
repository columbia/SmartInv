1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //MoInke直播 contract
5 //
6 //MoInke黄金
7 // Symbol      : MIG
8 // Name        : MoInke Gold
9 // Total supply: 180,000
10 // Decimals    : 0
11 // 
12 //MoInke币
13 // Symbol      : MoInke
14 // Name        : MoInke Token
15 // Total supply: 100,000,000,000
16 // Decimals    : 18
17 // ----------------------------------------------------------------------------
18 
19 
20 // ----------------------------------------------------------------------------
21 // Safe maths
22 // ----------------------------------------------------------------------------
23 contract SafeMath {
24     function safeAdd(uint a, uint b) public pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function safeSub(uint a, uint b) public pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32     function safeMul(uint a, uint b) public pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36     function safeDiv(uint a, uint b) public pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39     }
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // ERC Token Standard #20 Interface
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Contract function to receive approval and execute function in one call
61 //
62 // Borrowed from MiniMeToken
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Admin contract
71 // ----------------------------------------------------------------------------
72 contract Administration {
73     event AdminTransferred(address indexed _from, address indexed _to);
74     event Pause();
75     event Unpause();
76 
77     address public CEOAddress = 0x8153b50F7e7b23460E1d2652243bF93d0d1b614E;
78     address public CFOAddress = 0x0BCB75C80101b88e1AC692b7FA0ED2Dd0c03d1DB;
79 
80     bool public paused = false;
81     bool public allowed = false;
82 
83     modifier onlyCEO() {
84         require(msg.sender == CEOAddress);
85         _;
86     }
87 
88     modifier onlyAdmin() {
89         require(msg.sender == CEOAddress || msg.sender == CFOAddress);
90         _;
91     }
92 
93     function setCFO(address _newAdmin) public onlyCEO {
94         require(_newAdmin != address(0));
95         emit AdminTransferred(CFOAddress, _newAdmin);
96         CFOAddress = _newAdmin;
97         
98     }
99 
100     function withdrawBalance() external onlyAdmin {
101         CEOAddress.transfer(address(this).balance);
102     }
103 
104     modifier whenNotPaused() {
105         require(!paused);
106         _;
107     }
108 
109     modifier whenPaused() {
110         require(paused);
111         _;
112     }
113     
114     modifier whenAllowed() {
115         require(allowed);
116         _;
117     }
118     
119     modifier ifGoldTrans() {
120         require(allowed || msg.sender == CEOAddress || msg.sender == CFOAddress);
121         _;
122     }
123 
124     function pause() public onlyAdmin whenNotPaused returns(bool) {
125         paused = true;
126         emit Pause();
127         return true;
128     }
129 
130     function unpause() public onlyAdmin whenPaused returns(bool) {
131         paused = false;
132         emit Unpause();
133         return true;
134     }
135     
136     function allow() public onlyAdmin {
137         if(allowed == false) {
138             allowed = true;
139         } else {
140             allowed = false;
141         }
142     }
143 
144     uint oneEth = 1 ether;
145 }
146 
147 contract MoInkeGold is ERC20Interface, Administration, SafeMath {
148     event GoldTransfer(address indexed from, address indexed to, uint tokens);
149     
150     string public goldSymbol;
151     string public goldName;
152     uint8 public goldDecimals;
153     uint public _goldTotalSupply;
154 
155     mapping(address => uint) goldBalances;
156     mapping(address => bool) goldFreezed;
157     mapping(address => uint) goldFreezeAmount;
158     mapping(address => uint) goldUnlockTime;
159 
160 
161     // ------------------------------------------------------------------------
162     // Constructor
163     // ------------------------------------------------------------------------
164     constructor() public {
165         goldSymbol = "MIG";
166         goldName = "MoInke Gold";
167         goldDecimals = 0;
168         _goldTotalSupply = 180000;
169         goldBalances[CEOAddress] = _goldTotalSupply;
170         emit GoldTransfer(address(0), CEOAddress, _goldTotalSupply);
171     }
172 
173     // ------------------------------------------------------------------------
174     // Total supply
175     // ------------------------------------------------------------------------
176     function goldTotalSupply() public constant returns (uint) {
177         return _goldTotalSupply  - goldBalances[address(0)];
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Get the token balance for account tokenOwner
183     // ------------------------------------------------------------------------
184     function goldBalanceOf(address tokenOwner) public constant returns (uint balance) {
185         return goldBalances[tokenOwner];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Transfer the balance from token owner's account to to account
191     // - Owner's account must have sufficient balance to transfer
192     // - 0 value transfers are allowed
193     // ------------------------------------------------------------------------
194     function goldTransfer(address to, uint tokens) public ifGoldTrans returns (bool success) {
195         if(goldFreezed[msg.sender] == false){
196             goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], tokens);
197             goldBalances[to] = safeAdd(goldBalances[to], tokens);
198             emit GoldTransfer(msg.sender, to, tokens);
199         } else {
200             if(goldBalances[msg.sender] > goldFreezeAmount[msg.sender]) {
201                 require(tokens <= safeSub(goldBalances[msg.sender], goldFreezeAmount[msg.sender]));
202                 goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], tokens);
203                 goldBalances[to] = safeAdd(goldBalances[to], tokens);
204                 emit GoldTransfer(msg.sender, to, tokens);
205             }
206         }
207             
208         return true;
209     }
210 
211     // ------------------------------------------------------------------------
212     // Mint Tokens
213     // ------------------------------------------------------------------------
214     function mintGold(uint amount) public onlyCEO {
215         goldBalances[msg.sender] = safeAdd(goldBalances[msg.sender], amount);
216         _goldTotalSupply = safeAdd(_goldTotalSupply, amount);
217     }
218 
219     // ------------------------------------------------------------------------
220     // Burn Tokens
221     // ------------------------------------------------------------------------
222     function burnGold(uint amount) public onlyCEO {
223         goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], amount);
224         _goldTotalSupply = safeSub(_goldTotalSupply, amount);
225     }
226     
227     // ------------------------------------------------------------------------
228     // Freeze Tokens
229     // ------------------------------------------------------------------------
230     function goldFreeze(address user, uint amount, uint period) public onlyAdmin {
231         require(goldBalances[user] >= amount);
232         goldFreezed[user] = true;
233         goldUnlockTime[user] = uint(now) + period;
234         goldFreezeAmount[user] = amount;
235     }
236     
237     function _goldFreeze(uint amount) internal {
238         require(goldFreezed[msg.sender] == false);
239         require(goldBalances[msg.sender] >= amount);
240         goldFreezed[msg.sender] = true;
241         goldUnlockTime[msg.sender] = uint(-1);
242         goldFreezeAmount[msg.sender] = amount;
243     }
244 
245     // ------------------------------------------------------------------------
246     // UnFreeze Tokens
247     // ------------------------------------------------------------------------
248     function goldUnFreeze() public whenNotPaused {
249         require(goldFreezed[msg.sender] == true);
250         require(goldUnlockTime[msg.sender] < uint(now));
251         goldFreezed[msg.sender] = false;
252         goldFreezeAmount[msg.sender] = 0;
253     }
254     
255     function _goldUnFreeze(uint _amount) internal {
256         require(goldFreezed[msg.sender] == true);
257         goldUnlockTime[msg.sender] = 0;
258         goldFreezed[msg.sender] = false;
259         goldFreezeAmount[msg.sender] = safeSub(goldFreezeAmount[msg.sender], _amount);
260     }
261     
262     function goldIfFreeze(address user) public view returns (
263         bool check, 
264         uint amount, 
265         uint timeLeft
266     ) {
267         check = goldFreezed[user];
268         amount = goldFreezeAmount[user];
269         timeLeft = goldUnlockTime[user] - uint(now);
270     }
271 
272 }
273 
274 contract MoInkeToken is MoInkeGold {
275     event PartnerCreated(uint indexed partnerId, address indexed partner, uint indexed amount, uint singleTrans, uint durance);
276     event RewardDistribute(uint indexed postId, uint partnerId, address indexed user, uint indexed amount);
277     
278     event VipAgreementSign(uint indexed vipId, address indexed vip, uint durance, uint frequence, uint salar);
279     event SalaryReceived(uint indexed vipId, address indexed vip, uint salary, uint indexed timestamp);
280     
281     string public symbol;
282     string public  name;
283     uint8 public decimals;
284     uint public _totalSupply;
285     uint public minePool; // 90%
286 
287     struct Partner {
288         address admin;
289         uint tokenPool;
290         uint singleTrans;
291         uint timestamp;
292         uint durance;
293     }
294     
295     struct Poster {
296         address poster;
297         bytes32 hashData;
298         uint reward;
299     }
300     
301     struct Vip {
302         address vip;
303         uint durance;
304         uint frequence;
305         uint salary;
306         uint timestamp;
307     }
308     
309     Partner[] partners;
310     Vip[] vips;
311 
312     modifier onlyPartner(uint _partnerId) {
313         require(partners[_partnerId].admin == msg.sender);
314         require(partners[_partnerId].tokenPool > uint(0));
315         uint deadline = safeAdd(partners[_partnerId].timestamp, partners[_partnerId].durance);
316         require(deadline > now);
317         _;
318     }
319     
320     modifier onlyVip(uint _vipId) {
321         require(vips[_vipId].vip == msg.sender);
322         require(vips[_vipId].durance > now);
323         require(vips[_vipId].timestamp < now);
324         _;
325     }
326 
327     mapping(address => uint) balances;
328     mapping(address => mapping(address => uint)) allowed;
329     mapping(address => bool) freezed;
330     mapping(address => uint) freezeAmount;
331     mapping(address => uint) unlockTime;
332     
333     mapping(uint => Poster[]) PartnerIdToPosterList;
334 
335 
336     // ------------------------------------------------------------------------
337     // Constructor
338     // ------------------------------------------------------------------------
339     constructor() public {
340         symbol = "MINK";
341         name = "MoInke Token";
342         decimals = 18;
343         _totalSupply = 10000000000000000000000000000;
344         minePool = 90000000000000000000000000000;
345         
346         balances[CEOAddress] = _totalSupply;
347         emit Transfer(address(0), CEOAddress, _totalSupply);
348     }
349     
350     // ------------------------------------------------------------------------
351     // Total supply
352     // ------------------------------------------------------------------------
353     function totalSupply() public constant returns (uint) {
354         return _totalSupply  - balances[address(0)];
355     }
356 
357 
358     // ------------------------------------------------------------------------
359     // Get the token balance for account tokenOwner
360     // ------------------------------------------------------------------------
361     function balanceOf(address tokenOwner) public constant returns (uint balance) {
362         return balances[tokenOwner];
363     }
364 
365 
366     // ------------------------------------------------------------------------
367     // Transfer the balance from token owner's account to to account
368     // - Owner's account must have sufficient balance to transfer
369     // - 0 value transfers are allowed
370     // ------------------------------------------------------------------------
371     function transfer(address to, uint tokens) public returns (bool success) {
372         if(freezed[msg.sender] == false){
373             balances[msg.sender] = safeSub(balances[msg.sender], tokens);
374             balances[to] = safeAdd(balances[to], tokens);
375             emit Transfer(msg.sender, to, tokens);
376         } else {
377             if(balances[msg.sender] > freezeAmount[msg.sender]) {
378                 require(tokens <= safeSub(balances[msg.sender], freezeAmount[msg.sender]));
379                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
380                 balances[to] = safeAdd(balances[to], tokens);
381                 emit Transfer(msg.sender, to, tokens);
382             }
383         }
384             
385         return true;
386     }
387 
388 
389     // ------------------------------------------------------------------------
390     // Token owner can approve for spender to transferFrom(...) tokens
391     // from the token owner's account
392     //
393     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
394     // recommends that there are no checks for the approval double-spend attack
395     // as this should be implemented in user interfaces 
396     // ------------------------------------------------------------------------
397     function approve(address spender, uint tokens) public returns (bool success) {
398         require(freezed[msg.sender] != true);
399         allowed[msg.sender][spender] = tokens;
400         emit Approval(msg.sender, spender, tokens);
401         return true;
402     }
403 
404 
405     // ------------------------------------------------------------------------
406     // Transfer tokens from the from account to the to account
407     // 
408     // The calling account must already have sufficient tokens approve(...)-d
409     // for spending from the from account and
410     // - From account must have sufficient balance to transfer
411     // - Spender must have sufficient allowance to transfer
412     // - 0 value transfers are allowed
413     // ------------------------------------------------------------------------
414     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
415         balances[from] = safeSub(balances[from], tokens);
416         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
417         balances[to] = safeAdd(balances[to], tokens);
418         emit Transfer(from, to, tokens);
419         return true;
420     }
421 
422 
423     // ------------------------------------------------------------------------
424     // Returns the amount of tokens approved by the owner that can be
425     // transferred to the spender's account
426     // ------------------------------------------------------------------------
427     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
428         require(freezed[msg.sender] != true);
429         return allowed[tokenOwner][spender];
430     }
431 
432 
433     // ------------------------------------------------------------------------
434     // Token owner can approve for spender to transferFrom(...) tokens
435     // from the token owner's account. The spender contract function
436     // receiveApproval(...) is then executed
437     // ------------------------------------------------------------------------
438     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
439         require(freezed[msg.sender] != true);
440         allowed[msg.sender][spender] = tokens;
441         emit Approval(msg.sender, spender, tokens);
442         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
443         return true;
444     }
445 
446     // ------------------------------------------------------------------------
447     // Mint Tokens
448     // ------------------------------------------------------------------------
449     function _mine(uint amount, address receiver) internal {
450         require(minePool >= amount);
451         minePool = safeSub(minePool, amount);
452         _totalSupply = safeAdd(_totalSupply, amount);
453         balances[receiver] = safeAdd(balances[receiver], amount);
454         emit Transfer(address(0), receiver, amount);
455     }
456     
457     function mint(uint amount) public onlyAdmin {
458         _mine(amount, msg.sender);
459     }
460     
461     function burn(uint amount) public onlyAdmin {
462         require(_totalSupply >= amount);
463         balances[msg.sender] = safeSub(balances[msg.sender], amount);
464         _totalSupply = safeSub(_totalSupply, amount);
465     }
466     
467     // ------------------------------------------------------------------------
468     // Freeze Tokens
469     // ------------------------------------------------------------------------
470     function freeze(address user, uint amount, uint period) public onlyAdmin {
471         require(balances[user] >= amount);
472         freezed[user] = true;
473         unlockTime[user] = uint(now) + period;
474         freezeAmount[user] = amount;
475     }
476 
477     // ------------------------------------------------------------------------
478     // UnFreeze Tokens
479     // ------------------------------------------------------------------------
480     function unFreeze() public whenNotPaused {
481         require(freezed[msg.sender] == true);
482         require(unlockTime[msg.sender] < uint(now));
483         freezed[msg.sender] = false;
484         freezeAmount[msg.sender] = 0;
485     }
486     
487     function ifFreeze(address user) public view returns (
488         bool check, 
489         uint amount, 
490         uint timeLeft
491     ) {
492         check = freezed[user];
493         amount = freezeAmount[user];
494         timeLeft = unlockTime[user] - uint(now);
495     }
496     
497     // ------------------------------------------------------------------------
498     // Partner Authorization
499     // ------------------------------------------------------------------------
500     function createPartner(address _partner, uint _amount, uint _singleTrans, uint _durance) public onlyAdmin returns (uint) {
501         Partner memory _Partner = Partner({
502             admin: _partner,
503             tokenPool: _amount,
504             singleTrans: _singleTrans,
505             timestamp: uint(now),
506             durance: _durance
507         });
508         uint newPartnerId = partners.push(_Partner) - 1;
509         emit PartnerCreated(newPartnerId, _partner, _amount, _singleTrans, _durance);
510         
511         return newPartnerId;
512     }
513     
514     function partnerTransfer(uint _partnerId, bytes32 _data, address _to, uint _amount) public onlyPartner(_partnerId) whenNotPaused returns (bool) {
515         require(_amount <= partners[_partnerId].singleTrans);
516         partners[_partnerId].tokenPool = safeSub(partners[_partnerId].tokenPool, _amount);
517         Poster memory _Poster = Poster ({
518            poster: _to,
519            hashData: _data,
520            reward: _amount
521         });
522         uint newPostId = PartnerIdToPosterList[_partnerId].push(_Poster) - 1;
523         _mine(_amount, _to);
524         emit RewardDistribute(newPostId, _partnerId, _to, _amount);
525         return true;
526     }
527     
528     function setPartnerPool(uint _partnerId, uint _amount) public onlyAdmin {
529         partners[_partnerId].tokenPool = _amount;
530     }
531     
532     function setPartnerDurance(uint _partnerId, uint _durance) public onlyAdmin {
533         partners[_partnerId].durance = uint(now) + _durance;
534     }
535     
536     function getPartnerInfo(uint _partnerId) public view returns (
537         address admin,
538         uint tokenPool,
539         uint timeLeft
540     ) {
541         Partner memory _Partner = partners[_partnerId];
542         admin = _Partner.admin;
543         tokenPool = _Partner.tokenPool;
544         if (_Partner.timestamp + _Partner.durance > uint(now)) {
545             timeLeft = _Partner.timestamp + _Partner.durance - uint(now);
546         } else {
547             timeLeft = 0;
548         }
549         
550     }
551 
552     function getPosterInfo(uint _partnerId, uint _posterId) public view returns (
553         address poster,
554         bytes32 hashData,
555         uint reward
556     ) {
557         Poster memory _Poster = PartnerIdToPosterList[_partnerId][_posterId];
558         poster = _Poster.poster;
559         hashData = _Poster.hashData;
560         reward = _Poster.reward;
561     }
562 
563     // ------------------------------------------------------------------------
564     // Vip Agreement
565     // ------------------------------------------------------------------------
566     function createVip(address _vip, uint _durance, uint _frequence, uint _salary) public onlyAdmin returns (uint) {
567         Vip memory _Vip = Vip ({
568            vip: _vip,
569            durance: uint(now) + _durance,
570            frequence: _frequence,
571            salary: _salary,
572            timestamp: now + _frequence
573         });
574         uint newVipId = vips.push(_Vip) - 1;
575         emit VipAgreementSign(newVipId, _vip, _durance, _frequence, _salary);
576         
577         return newVipId;
578     }
579     
580     function mineSalary(uint _vipId) public onlyVip(_vipId) whenNotPaused returns (bool) {
581         Vip storage _Vip = vips[_vipId];
582         _mine(_Vip.salary, _Vip.vip);
583         _Vip.timestamp = safeAdd(_Vip.timestamp, _Vip.frequence);
584         
585         emit SalaryReceived(_vipId, _Vip.vip, _Vip.salary, _Vip.timestamp);
586         return true;
587     }
588     
589     function deleteVip(uint _vipId) public onlyAdmin {
590         delete vips[_vipId];
591     }
592     
593     function getVipInfo(uint _vipId) public view returns (
594         address vip,
595         uint durance,
596         uint frequence,
597         uint salary,
598         uint nextSalary,
599         string log
600     ) {
601         Vip memory _Vip = vips[_vipId];
602         vip = _Vip.vip;
603         durance = _Vip.durance;
604         frequence = _Vip.frequence;
605         salary = _Vip.salary;
606         if(_Vip.timestamp >= uint(now)) {
607             nextSalary = safeSub(_Vip.timestamp, uint(now));
608             log = "Please Wait";
609         } else {
610             nextSalary = 0;
611             log = "Pick Up Your Salary Now";
612         }
613     }
614 
615     // ------------------------------------------------------------------------
616     // Accept ETH
617     // ------------------------------------------------------------------------
618     function () public payable {
619     }
620 
621     // ------------------------------------------------------------------------
622     // Owner can transfer out any accidentally sent ERC20 tokens
623     // ------------------------------------------------------------------------
624     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
625         return ERC20Interface(tokenAddress).transfer(CEOAddress, tokens);
626     }
627 }
628 
629 contract MoInke is MoInkeToken {
630     event MembershipUpdate(address indexed member, uint indexed level);
631     event MemberAllowance(address indexed member, uint indexed amount);
632     event MembershipCancel(address indexed member);
633     event InkeTradeCreated(uint indexed tradeId, bool indexed ifGold, uint gold, uint token);
634     event TradeCancel(uint indexed tradeId);
635     event TradeComplete(uint indexed tradeId, address indexed buyer, address indexed seller, uint gold, uint token);
636     event Mine(address indexed miner, uint indexed salary);
637     
638     mapping (address => uint) MemberToLevel;
639     mapping (address => uint) MemberToGold;
640     mapping (address => uint) MemberToToken;
641     mapping (address => uint) MemberToTime;
642     mapping (address => uint) MemberToAllowance;
643     
644     uint public period = 15 days;
645     
646     uint public salary = 10000000000000000000000;
647     
648     struct InkeTrade {
649         address seller;
650         bool ifGold;
651         uint gold;
652         uint token;
653     }
654     
655     function mine() public whenNotPaused {
656         require(MemberToTime[msg.sender] < uint(now)); 
657         uint amount = goldBalances[msg.sender];
658         require(amount > 0);
659         amount = salary*amount;
660         _mine(amount, msg.sender);
661         if (MemberToTime[msg.sender] == 0) {
662             MemberToTime[msg.sender] = uint(now);
663         }
664         MemberToTime[msg.sender] = safeAdd(MemberToTime[msg.sender], period);
665         emit Mine(msg.sender, amount);
666     }
667     
668     InkeTrade[] inkeTrades;
669     
670     function createInkeTrade(bool _ifGold, uint _gold, uint _token) public whenAllowed returns (uint) {
671         if(_ifGold) {
672             require(goldBalances[msg.sender] >= _gold);
673             goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], _gold);
674             MemberToGold[msg.sender] = _gold;
675             InkeTrade memory Moinke = InkeTrade({
676                seller: msg.sender,
677                ifGold:_ifGold,
678                gold: _gold,
679                token: _token
680             });
681             uint newGoldTradeId = inkeTrades.push(Moinke) - 1;
682             emit InkeTradeCreated(newGoldTradeId, _ifGold, _gold, _token);
683             
684             return newGoldTradeId;
685         } else {
686             require(balances[msg.sender] >= _token);
687             balances[msg.sender] = safeSub(balances[msg.sender], _token);
688             MemberToToken[msg.sender] = _token;
689             InkeTrade memory _inke = InkeTrade({
690                seller: msg.sender,
691                ifGold:_ifGold,
692                gold: _gold,
693                token: _token
694             });
695             uint newTokenTradeId = inkeTrades.push(_inke) - 1;
696             emit InkeTradeCreated(newTokenTradeId, _ifGold, _gold, _token);
697             
698             return newTokenTradeId;
699         }
700     }
701     
702     function cancelTrade(uint _tradeId) public whenAllowed {
703         InkeTrade memory Moinke = inkeTrades[_tradeId];
704         require(Moinke.seller == msg.sender);
705         if(Moinke.ifGold){
706             goldBalances[msg.sender] = safeAdd(goldBalances[msg.sender], Moinke.gold);
707             MemberToGold[msg.sender] = 0;
708         } else {
709             balances[msg.sender] = safeAdd(balances[msg.sender], Moinke.token);
710             MemberToToken[msg.sender] = 0;
711         }
712         delete inkeTrades[_tradeId];
713         emit TradeCancel(_tradeId);
714     }
715     
716     function trade(uint _tradeId) public whenAllowed {
717         InkeTrade memory Moinke = inkeTrades[_tradeId];
718         if(Moinke.ifGold){
719             goldBalances[msg.sender] = safeAdd(goldBalances[msg.sender], Moinke.gold);
720             MemberToGold[Moinke.seller] = 0;
721             transfer(Moinke.seller, Moinke.token);
722             delete inkeTrades[_tradeId];
723             emit TradeComplete(_tradeId, msg.sender, Moinke.seller, Moinke.gold, Moinke.token);
724         } else {
725             balances[msg.sender] = safeAdd(balances[msg.sender], Moinke.token);
726             MemberToToken[Moinke.seller] = 0;
727             goldTransfer(Moinke.seller, Moinke.gold);
728             delete inkeTrades[_tradeId];
729             emit TradeComplete(_tradeId, msg.sender, Moinke.seller, Moinke.gold, Moinke.token);
730         }
731     }
732     
733     function setSalary(uint _salary) public onlyAdmin {
734         salary = _salary;
735     }
736     
737     function setPeriod(uint time) public onlyAdmin {
738         period = time;
739     }
740     
741     function getTrade(uint _tradeId) public view returns (
742         address seller,
743         bool ifGold,
744         uint gold,
745         uint token 
746     ) {
747         InkeTrade memory _inke = inkeTrades[_tradeId];
748         seller = _inke.seller;
749         ifGold = _inke.ifGold;
750         gold = _inke.gold;
751         token = _inke.token;
752     }
753     
754     function WhoIsTheContractMaster() public pure returns (string) {
755         return "Alexander The Exlosion";
756     }
757 }