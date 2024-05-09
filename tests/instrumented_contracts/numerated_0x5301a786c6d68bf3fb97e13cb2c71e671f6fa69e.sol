1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //Inke直播 contract
5 //
6 //Inke黄金
7 // Symbol      : IKG
8 // Name        : Inke Gold
9 // Total supply: 45000
10 // Decimals    : 0
11 // 
12 //Inke币
13 // Symbol      : Inke
14 // Name        : Inke Token
15 // Total supply: 100000000000
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
77     address public CEOAddress = 0xDc08d076b65c3d876Bb2369b167Dc304De4b9677;
78     address public CFOAddress = 0x4Ea72110C00f416963D34A7FECbF0FCDd306D15A;
79 
80     bool public paused = false;
81 
82     modifier onlyCEO() {
83         require(msg.sender == CEOAddress);
84         _;
85     }
86 
87     modifier onlyAdmin() {
88         require(msg.sender == CEOAddress || msg.sender == CFOAddress);
89         _;
90     }
91 
92     function setCFO(address _newAdmin) public onlyCEO {
93         require(_newAdmin != address(0));
94         emit AdminTransferred(CFOAddress, _newAdmin);
95         CFOAddress = _newAdmin;
96         
97     }
98 
99     function withdrawBalance() external onlyAdmin {
100         CEOAddress.transfer(address(this).balance);
101     }
102 
103     modifier whenNotPaused() {
104         require(!paused);
105         _;
106     }
107 
108     modifier whenPaused() {
109         require(paused);
110         _;
111     }
112 
113     function pause() public onlyAdmin whenNotPaused returns(bool) {
114         paused = true;
115         emit Pause();
116         return true;
117     }
118 
119     function unpause() public onlyAdmin whenPaused returns(bool) {
120         paused = false;
121         emit Unpause();
122         return true;
123     }
124 
125     uint oneEth = 1 ether;
126 }
127 
128 contract InkeGold is ERC20Interface, Administration, SafeMath {
129     event GoldTransfer(address indexed from, address indexed to, uint tokens);
130     
131     string public goldSymbol;
132     string public goldName;
133     uint8 public goldDecimals;
134     uint public _goldTotalSupply;
135 
136     mapping(address => uint) goldBalances;
137     mapping(address => bool) goldFreezed;
138     mapping(address => uint) goldFreezeAmount;
139     mapping(address => uint) goldUnlockTime;
140 
141 
142     // ------------------------------------------------------------------------
143     // Constructor
144     // ------------------------------------------------------------------------
145     constructor() public {
146         goldSymbol = "IKG";
147         goldName = "Inke Gold";
148         goldDecimals = 0;
149         _goldTotalSupply = 45000;
150         goldBalances[CEOAddress] = _goldTotalSupply;
151         emit GoldTransfer(address(0), CEOAddress, _goldTotalSupply);
152     }
153 
154     // ------------------------------------------------------------------------
155     // Total supply
156     // ------------------------------------------------------------------------
157     function goldTotalSupply() public constant returns (uint) {
158         return _goldTotalSupply  - goldBalances[address(0)];
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Get the token balance for account tokenOwner
164     // ------------------------------------------------------------------------
165     function goldBalanceOf(address tokenOwner) public constant returns (uint balance) {
166         return goldBalances[tokenOwner];
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Transfer the balance from token owner's account to to account
172     // - Owner's account must have sufficient balance to transfer
173     // - 0 value transfers are allowed
174     // ------------------------------------------------------------------------
175     function goldTransfer(address to, uint tokens) public whenNotPaused returns (bool success) {
176         if(goldFreezed[msg.sender] == false){
177             goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], tokens);
178             goldBalances[to] = safeAdd(goldBalances[to], tokens);
179             emit GoldTransfer(msg.sender, to, tokens);
180         } else {
181             if(goldBalances[msg.sender] > goldFreezeAmount[msg.sender]) {
182                 require(tokens <= safeSub(goldBalances[msg.sender], goldFreezeAmount[msg.sender]));
183                 goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], tokens);
184                 goldBalances[to] = safeAdd(goldBalances[to], tokens);
185                 emit GoldTransfer(msg.sender, to, tokens);
186             }
187         }
188             
189         return true;
190     }
191 
192     // ------------------------------------------------------------------------
193     // Mint Tokens
194     // ------------------------------------------------------------------------
195     function mintGold(uint amount) public onlyCEO {
196         goldBalances[msg.sender] = safeAdd(goldBalances[msg.sender], amount);
197         _goldTotalSupply = safeAdd(_goldTotalSupply, amount);
198     }
199 
200     // ------------------------------------------------------------------------
201     // Burn Tokens
202     // ------------------------------------------------------------------------
203     function burnGold(uint amount) public onlyCEO {
204         goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], amount);
205         _goldTotalSupply = safeSub(_goldTotalSupply, amount);
206     }
207     
208     // ------------------------------------------------------------------------
209     // Freeze Tokens
210     // ------------------------------------------------------------------------
211     function goldFreeze(address user, uint amount, uint period) public onlyAdmin {
212         require(goldBalances[user] >= amount);
213         goldFreezed[user] = true;
214         goldUnlockTime[user] = uint(now) + period;
215         goldFreezeAmount[user] = amount;
216     }
217     
218     function _goldFreeze(uint amount) internal {
219         require(goldFreezed[msg.sender] == false);
220         require(goldBalances[msg.sender] >= amount);
221         goldFreezed[msg.sender] = true;
222         goldUnlockTime[msg.sender] = uint(-1);
223         goldFreezeAmount[msg.sender] = amount;
224     }
225 
226     // ------------------------------------------------------------------------
227     // UnFreeze Tokens
228     // ------------------------------------------------------------------------
229     function goldUnFreeze() public whenNotPaused {
230         require(goldFreezed[msg.sender] == true);
231         require(goldUnlockTime[msg.sender] < uint(now));
232         goldFreezed[msg.sender] = false;
233         goldFreezeAmount[msg.sender] = 0;
234     }
235     
236     function _goldUnFreeze(uint _amount) internal {
237         require(goldFreezed[msg.sender] == true);
238         goldUnlockTime[msg.sender] = 0;
239         goldFreezed[msg.sender] = false;
240         goldFreezeAmount[msg.sender] = safeSub(goldFreezeAmount[msg.sender], _amount);
241     }
242     
243     function goldIfFreeze(address user) public view returns (
244         bool check, 
245         uint amount, 
246         uint timeLeft
247     ) {
248         check = goldFreezed[user];
249         amount = goldFreezeAmount[user];
250         timeLeft = goldUnlockTime[user] - uint(now);
251     }
252 
253 }
254 
255 contract InkeToken is InkeGold {
256     event PartnerCreated(uint indexed partnerId, address indexed partner, uint indexed amount, uint singleTrans, uint durance);
257     event RewardDistribute(uint indexed postId, uint partnerId, address indexed user, uint indexed amount);
258     
259     event VipAgreementSign(uint indexed vipId, address indexed vip, uint durance, uint frequence, uint salar);
260     event SalaryReceived(uint indexed vipId, address indexed vip, uint salary, uint indexed timestamp);
261     
262     string public symbol;
263     string public  name;
264     uint8 public decimals;
265     uint public _totalSupply;
266     uint public minePool; // 60%
267     uint public fundPool; // 30%
268 
269     struct Partner {
270         address admin;
271         uint tokenPool;
272         uint singleTrans;
273         uint timestamp;
274         uint durance;
275     }
276     
277     struct Poster {
278         address poster;
279         bytes32 hashData;
280         uint reward;
281     }
282     
283     struct Vip {
284         address vip;
285         uint durance;
286         uint frequence;
287         uint salary;
288         uint timestamp;
289     }
290     
291     Partner[] partners;
292     Vip[] vips;
293 
294     modifier onlyPartner(uint _partnerId) {
295         require(partners[_partnerId].admin == msg.sender);
296         require(partners[_partnerId].tokenPool > uint(0));
297         uint deadline = safeAdd(partners[_partnerId].timestamp, partners[_partnerId].durance);
298         require(deadline > now);
299         _;
300     }
301     
302     modifier onlyVip(uint _vipId) {
303         require(vips[_vipId].vip == msg.sender);
304         require(vips[_vipId].durance > now);
305         require(vips[_vipId].timestamp < now);
306         _;
307     }
308 
309     mapping(address => uint) balances;
310     mapping(address => mapping(address => uint)) allowed;
311     mapping(address => bool) freezed;
312     mapping(address => uint) freezeAmount;
313     mapping(address => uint) unlockTime;
314     
315     mapping(uint => Poster[]) PartnerIdToPosterList;
316 
317 
318     // ------------------------------------------------------------------------
319     // Constructor
320     // ------------------------------------------------------------------------
321     constructor() public {
322         symbol = "Inke";
323         name = "Inke Token";
324         decimals = 18;
325         _totalSupply = 10000000000000000000000000000;
326         minePool = 60000000000000000000000000000;
327         fundPool = 30000000000000000000000000000;
328         
329         balances[CEOAddress] = _totalSupply;
330         emit Transfer(address(0), CEOAddress, _totalSupply);
331     }
332     
333     // ------------------------------------------------------------------------
334     // Total supply
335     // ------------------------------------------------------------------------
336     function totalSupply() public constant returns (uint) {
337         return _totalSupply  - balances[address(0)];
338     }
339 
340 
341     // ------------------------------------------------------------------------
342     // Get the token balance for account tokenOwner
343     // ------------------------------------------------------------------------
344     function balanceOf(address tokenOwner) public constant returns (uint balance) {
345         return balances[tokenOwner];
346     }
347 
348 
349     // ------------------------------------------------------------------------
350     // Transfer the balance from token owner's account to to account
351     // - Owner's account must have sufficient balance to transfer
352     // - 0 value transfers are allowed
353     // ------------------------------------------------------------------------
354     function transfer(address to, uint tokens) public returns (bool success) {
355         if(freezed[msg.sender] == false){
356             balances[msg.sender] = safeSub(balances[msg.sender], tokens);
357             balances[to] = safeAdd(balances[to], tokens);
358             emit Transfer(msg.sender, to, tokens);
359         } else {
360             if(balances[msg.sender] > freezeAmount[msg.sender]) {
361                 require(tokens <= safeSub(balances[msg.sender], freezeAmount[msg.sender]));
362                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
363                 balances[to] = safeAdd(balances[to], tokens);
364                 emit Transfer(msg.sender, to, tokens);
365             }
366         }
367             
368         return true;
369     }
370 
371 
372     // ------------------------------------------------------------------------
373     // Token owner can approve for spender to transferFrom(...) tokens
374     // from the token owner's account
375     //
376     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
377     // recommends that there are no checks for the approval double-spend attack
378     // as this should be implemented in user interfaces 
379     // ------------------------------------------------------------------------
380     function approve(address spender, uint tokens) public returns (bool success) {
381         require(freezed[msg.sender] != true);
382         allowed[msg.sender][spender] = tokens;
383         emit Approval(msg.sender, spender, tokens);
384         return true;
385     }
386 
387 
388     // ------------------------------------------------------------------------
389     // Transfer tokens from the from account to the to account
390     // 
391     // The calling account must already have sufficient tokens approve(...)-d
392     // for spending from the from account and
393     // - From account must have sufficient balance to transfer
394     // - Spender must have sufficient allowance to transfer
395     // - 0 value transfers are allowed
396     // ------------------------------------------------------------------------
397     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
398         balances[from] = safeSub(balances[from], tokens);
399         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
400         balances[to] = safeAdd(balances[to], tokens);
401         emit Transfer(from, to, tokens);
402         return true;
403     }
404 
405 
406     // ------------------------------------------------------------------------
407     // Returns the amount of tokens approved by the owner that can be
408     // transferred to the spender's account
409     // ------------------------------------------------------------------------
410     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
411         require(freezed[msg.sender] != true);
412         return allowed[tokenOwner][spender];
413     }
414 
415 
416     // ------------------------------------------------------------------------
417     // Token owner can approve for spender to transferFrom(...) tokens
418     // from the token owner's account. The spender contract function
419     // receiveApproval(...) is then executed
420     // ------------------------------------------------------------------------
421     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
422         require(freezed[msg.sender] != true);
423         allowed[msg.sender][spender] = tokens;
424         emit Approval(msg.sender, spender, tokens);
425         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
426         return true;
427     }
428 
429     // ------------------------------------------------------------------------
430     // Mint Tokens
431     // ------------------------------------------------------------------------
432     function _mine(uint amount, address receiver) internal {
433         require(minePool >= amount);
434         minePool = safeSub(minePool, amount);
435         _totalSupply = safeAdd(_totalSupply, amount);
436         balances[receiver] = safeAdd(balances[receiver], amount);
437         emit Transfer(address(0), receiver, amount);
438     }
439     
440     function _fund(uint amount, address receiver) internal {
441         require(fundPool >= amount);
442         fundPool = safeSub(fundPool, amount);
443         _totalSupply = safeAdd(_totalSupply, amount);
444         balances[receiver] = safeAdd(balances[receiver], amount);
445         emit Transfer(address(0), receiver, amount);
446     }
447     
448     function mint(uint amount) public onlyAdmin {
449         _fund(amount, msg.sender);
450     }
451     
452     function burn(uint amount) public onlyAdmin {
453         require(_totalSupply >= amount);
454         balances[msg.sender] = safeSub(balances[msg.sender], amount);
455         _totalSupply = safeSub(_totalSupply, amount);
456     }
457     
458     // ------------------------------------------------------------------------
459     // Freeze Tokens
460     // ------------------------------------------------------------------------
461     function freeze(address user, uint amount, uint period) public onlyAdmin {
462         require(balances[user] >= amount);
463         freezed[user] = true;
464         unlockTime[user] = uint(now) + period;
465         freezeAmount[user] = amount;
466     }
467 
468     // ------------------------------------------------------------------------
469     // UnFreeze Tokens
470     // ------------------------------------------------------------------------
471     function unFreeze() public whenNotPaused {
472         require(freezed[msg.sender] == true);
473         require(unlockTime[msg.sender] < uint(now));
474         freezed[msg.sender] = false;
475         freezeAmount[msg.sender] = 0;
476     }
477     
478     function ifFreeze(address user) public view returns (
479         bool check, 
480         uint amount, 
481         uint timeLeft
482     ) {
483         check = freezed[user];
484         amount = freezeAmount[user];
485         timeLeft = unlockTime[user] - uint(now);
486     }
487     
488     // ------------------------------------------------------------------------
489     // Partner Authorization
490     // ------------------------------------------------------------------------
491     function createPartner(address _partner, uint _amount, uint _singleTrans, uint _durance) public onlyAdmin returns (uint) {
492         Partner memory _Partner = Partner({
493             admin: _partner,
494             tokenPool: _amount,
495             singleTrans: _singleTrans,
496             timestamp: uint(now),
497             durance: _durance
498         });
499         uint newPartnerId = partners.push(_Partner) - 1;
500         emit PartnerCreated(newPartnerId, _partner, _amount, _singleTrans, _durance);
501         
502         return newPartnerId;
503     }
504     
505     function partnerTransfer(uint _partnerId, bytes32 _data, address _to, uint _amount) public onlyPartner(_partnerId) whenNotPaused returns (bool) {
506         require(_amount <= partners[_partnerId].singleTrans);
507         partners[_partnerId].tokenPool = safeSub(partners[_partnerId].tokenPool, _amount);
508         Poster memory _Poster = Poster ({
509            poster: _to,
510            hashData: _data,
511            reward: _amount
512         });
513         uint newPostId = PartnerIdToPosterList[_partnerId].push(_Poster) - 1;
514         _fund(_amount, _to);
515         emit RewardDistribute(newPostId, _partnerId, _to, _amount);
516         return true;
517     }
518     
519     function setPartnerPool(uint _partnerId, uint _amount) public onlyAdmin {
520         partners[_partnerId].tokenPool = _amount;
521     }
522     
523     function setPartnerDurance(uint _partnerId, uint _durance) public onlyAdmin {
524         partners[_partnerId].durance = uint(now) + _durance;
525     }
526     
527     function getPartnerInfo(uint _partnerId) public view returns (
528         address admin,
529         uint tokenPool,
530         uint timeLeft
531     ) {
532         Partner memory _Partner = partners[_partnerId];
533         admin = _Partner.admin;
534         tokenPool = _Partner.tokenPool;
535         if (_Partner.timestamp + _Partner.durance > uint(now)) {
536             timeLeft = _Partner.timestamp + _Partner.durance - uint(now);
537         } else {
538             timeLeft = 0;
539         }
540         
541     }
542 
543     function getPosterInfo(uint _partnerId, uint _posterId) public view returns (
544         address poster,
545         bytes32 hashData,
546         uint reward
547     ) {
548         Poster memory _Poster = PartnerIdToPosterList[_partnerId][_posterId];
549         poster = _Poster.poster;
550         hashData = _Poster.hashData;
551         reward = _Poster.reward;
552     }
553 
554     // ------------------------------------------------------------------------
555     // Vip Agreement
556     // ------------------------------------------------------------------------
557     function createVip(address _vip, uint _durance, uint _frequence, uint _salary) public onlyAdmin returns (uint) {
558         Vip memory _Vip = Vip ({
559            vip: _vip,
560            durance: uint(now) + _durance,
561            frequence: _frequence,
562            salary: _salary,
563            timestamp: now + _frequence
564         });
565         uint newVipId = vips.push(_Vip) - 1;
566         emit VipAgreementSign(newVipId, _vip, _durance, _frequence, _salary);
567         
568         return newVipId;
569     }
570     
571     function mineSalary(uint _vipId) public onlyVip(_vipId) whenNotPaused returns (bool) {
572         Vip storage _Vip = vips[_vipId];
573         _fund(_Vip.salary, _Vip.vip);
574         _Vip.timestamp = safeAdd(_Vip.timestamp, _Vip.frequence);
575         
576         emit SalaryReceived(_vipId, _Vip.vip, _Vip.salary, _Vip.timestamp);
577         return true;
578     }
579     
580     function deleteVip(uint _vipId) public onlyAdmin {
581         delete vips[_vipId];
582     }
583     
584     function getVipInfo(uint _vipId) public view returns (
585         address vip,
586         uint durance,
587         uint frequence,
588         uint salary,
589         uint nextSalary,
590         string log
591     ) {
592         Vip memory _Vip = vips[_vipId];
593         vip = _Vip.vip;
594         durance = _Vip.durance;
595         frequence = _Vip.frequence;
596         salary = _Vip.salary;
597         if(_Vip.timestamp >= uint(now)) {
598             nextSalary = safeSub(_Vip.timestamp, uint(now));
599             log = "Please Wait";
600         } else {
601             nextSalary = 0;
602             log = "Pick Up Your Salary Now";
603         }
604     }
605 
606     // ------------------------------------------------------------------------
607     // Accept ETH
608     // ------------------------------------------------------------------------
609     function () public payable {
610     }
611 
612     // ------------------------------------------------------------------------
613     // Owner can transfer out any accidentally sent ERC20 tokens
614     // ------------------------------------------------------------------------
615     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
616         return ERC20Interface(tokenAddress).transfer(CEOAddress, tokens);
617     }
618 }
619 
620 contract Inke is InkeToken {
621     event MembershipUpdate(address indexed member, uint indexed level);
622     event MemberAllowance(address indexed member, uint indexed amount);
623     event MembershipCancel(address indexed member);
624     event InkeTradeCreated(uint indexed tradeId, bool indexed ifGold, uint gold, uint token);
625     event TradeCancel(uint indexed tradeId);
626     event TradeComplete(uint indexed tradeId, address indexed buyer, address indexed seller, uint gold, uint token);
627     event Mine(address indexed miner, uint indexed salary);
628     
629     mapping (address => uint) MemberToLevel;
630     mapping (address => uint) MemberToGold;
631     mapping (address => uint) MemberToToken;
632     mapping (address => uint) MemberToTime;
633     mapping (address => address) MemberToBoss;
634     mapping (address => uint) MemberToAllowance;
635     
636     uint public period = 30 days;
637     uint leaseTimeI = uint(now) + 388 days;
638     uint leaseTimeII = uint(now) + 99 days;
639     
640     uint[4] public boardSpot = [
641         0,
642         20000,
643         1000,
644         100
645     ];
646     
647     uint[4] public boardMember =[
648         0,
649         1,
650         10,
651         100
652     ];
653     
654     uint[4] public salary = [
655         0,
656         27397000000000000000000,
657         273970000000000000000000,
658         2739700000000000000000000
659     ];
660     
661     struct InkeTrade {
662         address seller;
663         bool ifGold;
664         uint gold;
665         uint token;
666     }
667     
668     InkeTrade[] inkeTrades;
669     
670     function boardMemberApply(uint _level) public whenNotPaused {
671         require(_level > 0 && _level <= 3);
672         require(boardSpot[_level] > 0);
673         require(goldBalances[msg.sender] >= boardMember[_level]);
674         _goldFreeze(boardMember[_level]);
675         MemberToLevel[msg.sender] = _level;
676         if(MemberToTime[msg.sender] == 0) {
677             MemberToTime[msg.sender] = uint(now);
678         }
679         boardSpot[_level]--;
680         emit MembershipUpdate(msg.sender, _level);
681     }
682     
683     function giveMemberAllowance(address _member, uint _amount) public onlyAdmin {
684         MemberToAllowance[_member] = safeAdd(MemberToAllowance[_member], _amount);
685         emit MemberAllowance(_member, _amount);
686     }
687     
688     function assignSubMember(address _subMember, uint _level) public whenNotPaused {
689         require(_level > 0 && _level < 3);
690         require(MemberToAllowance[msg.sender] >= boardMember[_level]);
691         MemberToAllowance[msg.sender] = MemberToAllowance[msg.sender] - boardMember[_level];
692         MemberToLevel[_subMember] = _level;
693         if(MemberToTime[_subMember] == 0) {
694             MemberToTime[_subMember] = uint(now);
695         }
696         MemberToBoss[_subMember] = msg.sender;
697         boardSpot[_level]--;
698         
699         emit MembershipUpdate(_subMember, _level);
700     }
701     
702     function getBoardMember(address _member) public view returns (
703         uint level,
704         uint allowance,
705         uint timeLeft
706     ) {
707         level = MemberToLevel[_member];
708         allowance = MemberToAllowance[_member];
709         if(MemberToTime[_member] > uint(now)) {
710             timeLeft = safeSub(MemberToTime[_member], uint(now));
711         } else {
712             timeLeft = 0;
713         }
714     }
715     
716     function getMemberBoss(address _member) public view returns (address) {
717         return MemberToBoss[_member];
718     }
719     
720     function boardMemberCancel() public whenNotPaused {
721         uint level = MemberToLevel[msg.sender];
722         require(level > 0);
723         if(level == 1) {
724             require(leaseTimeII < uint(now));
725         } else {
726             require(leaseTimeI < uint(now));
727         }
728         _goldUnFreeze(boardMember[MemberToLevel[msg.sender]]);
729         
730         boardSpot[level]++;
731         MemberToLevel[msg.sender] = 0;
732         emit MembershipCancel(msg.sender);
733     }
734     
735     function createInkeTrade(bool _ifGold, uint _gold, uint _token) public whenNotPaused returns (uint) {
736         if(_ifGold) {
737             require(goldBalances[msg.sender] >= _gold);
738             goldBalances[msg.sender] = safeSub(goldBalances[msg.sender], _gold);
739             MemberToGold[msg.sender] = _gold;
740             InkeTrade memory inke = InkeTrade({
741                seller: msg.sender,
742                ifGold:_ifGold,
743                gold: _gold,
744                token: _token
745             });
746             uint newGoldTradeId = inkeTrades.push(inke) - 1;
747             emit InkeTradeCreated(newGoldTradeId, _ifGold, _gold, _token);
748             
749             return newGoldTradeId;
750         } else {
751             require(balances[msg.sender] >= _token);
752             balances[msg.sender] = safeSub(balances[msg.sender], _token);
753             MemberToToken[msg.sender] = _token;
754             InkeTrade memory _inke = InkeTrade({
755                seller: msg.sender,
756                ifGold:_ifGold,
757                gold: _gold,
758                token: _token
759             });
760             uint newTokenTradeId = inkeTrades.push(_inke) - 1;
761             emit InkeTradeCreated(newTokenTradeId, _ifGold, _gold, _token);
762             
763             return newTokenTradeId;
764         }
765     }
766     
767     function cancelTrade(uint _tradeId) public whenNotPaused {
768         InkeTrade memory inke = inkeTrades[_tradeId];
769         require(inke.seller == msg.sender);
770         if(inke.ifGold){
771             goldBalances[msg.sender] = safeAdd(goldBalances[msg.sender], inke.gold);
772             MemberToGold[msg.sender] = 0;
773         } else {
774             balances[msg.sender] = safeAdd(balances[msg.sender], inke.token);
775             MemberToToken[msg.sender] = 0;
776         }
777         delete inkeTrades[_tradeId];
778         emit TradeCancel(_tradeId);
779     }
780     
781     function trade(uint _tradeId) public whenNotPaused {
782         InkeTrade memory inke = inkeTrades[_tradeId];
783         if(inke.ifGold){
784             goldBalances[msg.sender] = safeAdd(goldBalances[msg.sender], inke.gold);
785             MemberToGold[inke.seller] = 0;
786             transfer(inke.seller, inke.token);
787             delete inkeTrades[_tradeId];
788             emit TradeComplete(_tradeId, msg.sender, inke.seller, inke.gold, inke.token);
789         } else {
790             balances[msg.sender] = safeAdd(balances[msg.sender], inke.token);
791             MemberToToken[inke.seller] = 0;
792             goldTransfer(inke.seller, inke.gold);
793             delete inkeTrades[_tradeId];
794             emit TradeComplete(_tradeId, msg.sender, inke.seller, inke.gold, inke.token);
795         }
796     }
797     
798     function mine() public whenNotPaused {
799         uint level = MemberToLevel[msg.sender];
800         require(MemberToTime[msg.sender] < uint(now)); 
801         require(level > 0);
802         _mine(salary[level], msg.sender);
803         MemberToTime[msg.sender] = safeAdd(MemberToTime[msg.sender], period);
804         emit Mine(msg.sender, salary[level]);
805     }
806     
807     function setBoardMember(uint one, uint two, uint three) public onlyAdmin {
808         boardMember[1] = one;
809         boardMember[2] = two;
810         boardMember[3] = three;
811     }
812     
813     function setSalary(uint one, uint two, uint three) public onlyAdmin {
814         salary[1] = one;
815         salary[2] = two;
816         salary[3] = three;
817     }
818     
819     function setPeriod(uint time) public onlyAdmin {
820         period = time;
821     }
822     
823     function getTrade(uint _tradeId) public view returns (
824         address seller,
825         bool ifGold,
826         uint gold,
827         uint token 
828     ) {
829         InkeTrade memory _inke = inkeTrades[_tradeId];
830         seller = _inke.seller;
831         ifGold = _inke.ifGold;
832         gold = _inke.gold;
833         token = _inke.token;
834     }
835     
836     function WhoIsTheContractMaster() public pure returns (string) {
837         return "Alexander The Exlosion";
838     }
839 }