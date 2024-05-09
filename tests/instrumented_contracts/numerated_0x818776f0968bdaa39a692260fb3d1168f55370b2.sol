1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //喜马拉雅交易所 contract
5 //
6 //喜马拉雅荣耀
7 // Symbol      : XMH
8 // Name        : XiMaLaYa Honor
9 // Total supply: 1000
10 // Decimals    : 0
11 // 
12 //喜马拉雅币
13 // Symbol      : XMLY
14 // Name        : XiMaLaYa Token
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
77     address public CEOAddress = 0x5B807E379170d42f3B099C01A5399a2e1e58963B;
78     address public CFOAddress = 0x92cFfCD79E6Ab6B16C7AFb96fbC0a2373bE516A4;
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
94         AdminTransferred(CFOAddress, _newAdmin);
95         CFOAddress = _newAdmin;
96         
97     }
98 
99     function withdrawBalance() external onlyAdmin {
100         CEOAddress.transfer(this.balance);
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
115         Pause();
116         return true;
117     }
118 
119     function unpause() public onlyAdmin whenPaused returns(bool) {
120         paused = false;
121         Unpause();
122         return true;
123     }
124 
125     uint oneEth = 1 ether;
126 }
127 
128 contract XMLYBadge is ERC20Interface, Administration, SafeMath {
129     event BadgeTransfer(address indexed from, address indexed to, uint tokens);
130     
131     string public badgeSymbol;
132     string public badgeName;
133     uint8 public badgeDecimals;
134     uint public _badgeTotalSupply;
135 
136     mapping(address => uint) badgeBalances;
137     mapping(address => bool) badgeFreezed;
138     mapping(address => uint) badgeFreezeAmount;
139     mapping(address => uint) badgeUnlockTime;
140 
141 
142     // ------------------------------------------------------------------------
143     // Constructor
144     // ------------------------------------------------------------------------
145     function XMLYBadge() public {
146         badgeSymbol = "XMH";
147         badgeName = "XMLY Honor";
148         badgeDecimals = 0;
149         _badgeTotalSupply = 1000;
150         badgeBalances[CFOAddress] = _badgeTotalSupply;
151         BadgeTransfer(address(0), CFOAddress, _badgeTotalSupply);
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Total supply
157     // ------------------------------------------------------------------------
158     function badgeTotalSupply() public constant returns (uint) {
159         return _badgeTotalSupply  - badgeBalances[address(0)];
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Get the token balance for account tokenOwner
165     // ------------------------------------------------------------------------
166     function badgeBalanceOf(address tokenOwner) public constant returns (uint balance) {
167         return badgeBalances[tokenOwner];
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Transfer the balance from token owner's account to to account
173     // - Owner's account must have sufficient balance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function badgeTransfer(address to, uint tokens) public whenNotPaused returns (bool success) {
177         if(badgeFreezed[msg.sender] == false){
178             badgeBalances[msg.sender] = safeSub(badgeBalances[msg.sender], tokens);
179             badgeBalances[to] = safeAdd(badgeBalances[to], tokens);
180             BadgeTransfer(msg.sender, to, tokens);
181         } else {
182             if(badgeBalances[msg.sender] > badgeFreezeAmount[msg.sender]) {
183                 require(tokens <= safeSub(badgeBalances[msg.sender], badgeFreezeAmount[msg.sender]));
184                 badgeBalances[msg.sender] = safeSub(badgeBalances[msg.sender], tokens);
185                 badgeBalances[to] = safeAdd(badgeBalances[to], tokens);
186                 BadgeTransfer(msg.sender, to, tokens);
187             }
188         }
189             
190         return true;
191     }
192 
193     // ------------------------------------------------------------------------
194     // Mint Tokens
195     // ------------------------------------------------------------------------
196     function mintBadge(uint amount) public onlyAdmin {
197         badgeBalances[msg.sender] = safeAdd(badgeBalances[msg.sender], amount);
198         _badgeTotalSupply = safeAdd(_badgeTotalSupply, amount);
199     }
200 
201     // ------------------------------------------------------------------------
202     // Burn Tokens
203     // ------------------------------------------------------------------------
204     function burnBadge(uint amount) public onlyAdmin {
205         badgeBalances[msg.sender] = safeSub(badgeBalances[msg.sender], amount);
206         _badgeTotalSupply = safeSub(_badgeTotalSupply, amount);
207     }
208     
209     // ------------------------------------------------------------------------
210     // Freeze Tokens
211     // ------------------------------------------------------------------------
212     function badgeFreeze(address user, uint amount, uint period) public onlyAdmin {
213         require(badgeBalances[user] >= amount);
214         badgeFreezed[user] = true;
215         badgeUnlockTime[user] = uint(now) + period;
216         badgeFreezeAmount[user] = amount;
217     }
218     
219     function _badgeFreeze(uint amount) internal {
220         require(badgeFreezed[msg.sender] == false);
221         require(badgeBalances[msg.sender] >= amount);
222         badgeFreezed[msg.sender] = true;
223         badgeUnlockTime[msg.sender] = uint(-1);
224         badgeFreezeAmount[msg.sender] = amount;
225     }
226 
227     // ------------------------------------------------------------------------
228     // UnFreeze Tokens
229     // ------------------------------------------------------------------------
230     function badgeUnFreeze() public whenNotPaused {
231         require(badgeFreezed[msg.sender] == true);
232         require(badgeUnlockTime[msg.sender] < uint(now));
233         badgeFreezed[msg.sender] = false;
234         badgeFreezeAmount[msg.sender] = 0;
235     }
236     
237     function _badgeUnFreeze(uint _amount) internal {
238         require(badgeFreezed[msg.sender] == true);
239         badgeUnlockTime[msg.sender] = 0;
240         badgeFreezed[msg.sender] = false;
241         badgeFreezeAmount[msg.sender] = safeSub(badgeFreezeAmount[msg.sender], _amount);
242     }
243     
244     function badgeIfFreeze(address user) public view returns (
245         bool check, 
246         uint amount, 
247         uint timeLeft
248     ) {
249         check = badgeFreezed[user];
250         amount = badgeFreezeAmount[user];
251         timeLeft = badgeUnlockTime[user] - uint(now);
252     }
253 
254 }
255 
256 contract XMLYToken is XMLYBadge {
257     event PartnerCreated(uint indexed partnerId, address indexed partner, uint indexed amount, uint singleTrans, uint durance);
258     event RewardDistribute(uint indexed postId, uint partnerId, address indexed user, uint indexed amount);
259     
260     event VipAgreementSign(uint indexed vipId, address indexed vip, uint durance, uint frequence, uint salar);
261     event SalaryReceived(uint indexed vipId, address indexed vip, uint salary, uint indexed timestamp);
262     
263     string public symbol;
264     string public  name;
265     uint8 public decimals;
266     uint public _totalSupply;
267     uint public minePool;
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
321     function XMLYToken() public {
322         symbol = "XMLY";
323         name = "XMLY Token";
324         decimals = 18;
325         _totalSupply = 5000000000000000000000000000;
326         minePool = 95000000000000000000000000000;
327         balances[CFOAddress] = _totalSupply;
328         Transfer(address(0), CFOAddress, _totalSupply);
329     }
330     
331     // ------------------------------------------------------------------------
332     // Total supply
333     // ------------------------------------------------------------------------
334     function totalSupply() public constant returns (uint) {
335         return _totalSupply  - balances[address(0)];
336     }
337 
338 
339     // ------------------------------------------------------------------------
340     // Get the token balance for account tokenOwner
341     // ------------------------------------------------------------------------
342     function balanceOf(address tokenOwner) public constant returns (uint balance) {
343         return balances[tokenOwner];
344     }
345 
346 
347     // ------------------------------------------------------------------------
348     // Transfer the balance from token owner's account to to account
349     // - Owner's account must have sufficient balance to transfer
350     // - 0 value transfers are allowed
351     // ------------------------------------------------------------------------
352     function transfer(address to, uint tokens) public returns (bool success) {
353         if(freezed[msg.sender] == false){
354             balances[msg.sender] = safeSub(balances[msg.sender], tokens);
355             balances[to] = safeAdd(balances[to], tokens);
356             Transfer(msg.sender, to, tokens);
357         } else {
358             if(balances[msg.sender] > freezeAmount[msg.sender]) {
359                 require(tokens <= safeSub(balances[msg.sender], freezeAmount[msg.sender]));
360                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
361                 balances[to] = safeAdd(balances[to], tokens);
362                 Transfer(msg.sender, to, tokens);
363             }
364         }
365             
366         return true;
367     }
368 
369 
370     // ------------------------------------------------------------------------
371     // Token owner can approve for spender to transferFrom(...) tokens
372     // from the token owner's account
373     //
374     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
375     // recommends that there are no checks for the approval double-spend attack
376     // as this should be implemented in user interfaces 
377     // ------------------------------------------------------------------------
378     function approve(address spender, uint tokens) public returns (bool success) {
379         require(freezed[msg.sender] != true);
380         allowed[msg.sender][spender] = tokens;
381         Approval(msg.sender, spender, tokens);
382         return true;
383     }
384 
385 
386     // ------------------------------------------------------------------------
387     // Transfer tokens from the from account to the to account
388     // 
389     // The calling account must already have sufficient tokens approve(...)-d
390     // for spending from the from account and
391     // - From account must have sufficient balance to transfer
392     // - Spender must have sufficient allowance to transfer
393     // - 0 value transfers are allowed
394     // ------------------------------------------------------------------------
395     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
396         balances[from] = safeSub(balances[from], tokens);
397         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
398         balances[to] = safeAdd(balances[to], tokens);
399         Transfer(from, to, tokens);
400         return true;
401     }
402 
403 
404     // ------------------------------------------------------------------------
405     // Returns the amount of tokens approved by the owner that can be
406     // transferred to the spender's account
407     // ------------------------------------------------------------------------
408     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
409         require(freezed[msg.sender] != true);
410         return allowed[tokenOwner][spender];
411     }
412 
413 
414     // ------------------------------------------------------------------------
415     // Token owner can approve for spender to transferFrom(...) tokens
416     // from the token owner's account. The spender contract function
417     // receiveApproval(...) is then executed
418     // ------------------------------------------------------------------------
419     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
420         require(freezed[msg.sender] != true);
421         allowed[msg.sender][spender] = tokens;
422         Approval(msg.sender, spender, tokens);
423         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
424         return true;
425     }
426 
427     // ------------------------------------------------------------------------
428     // Mint Tokens
429     // ------------------------------------------------------------------------
430     function _mint(uint amount, address receiver) internal {
431         require(minePool >= amount);
432         minePool = safeSub(minePool, amount);
433         _totalSupply = safeAdd(_totalSupply, amount);
434         balances[receiver] = safeAdd(balances[receiver], amount);
435         Transfer(address(0), receiver, amount);
436     }
437     
438     function mint(uint amount) public onlyAdmin {
439         require(minePool >= amount);
440         minePool = safeSub(minePool, amount);
441         balances[msg.sender] = safeAdd(balances[msg.sender], amount);
442         _totalSupply = safeAdd(_totalSupply, amount);
443     }
444     
445     function burn(uint amount) public onlyAdmin {
446         require(_totalSupply >= amount);
447         balances[msg.sender] = safeSub(balances[msg.sender], amount);
448         _totalSupply = safeSub(_totalSupply, amount);
449     }
450     
451     // ------------------------------------------------------------------------
452     // Freeze Tokens
453     // ------------------------------------------------------------------------
454     function freeze(address user, uint amount, uint period) public onlyAdmin {
455         require(balances[user] >= amount);
456         freezed[user] = true;
457         unlockTime[user] = uint(now) + period;
458         freezeAmount[user] = amount;
459     }
460 
461     // ------------------------------------------------------------------------
462     // UnFreeze Tokens
463     // ------------------------------------------------------------------------
464     function unFreeze() public whenNotPaused {
465         require(freezed[msg.sender] == true);
466         require(unlockTime[msg.sender] < uint(now));
467         freezed[msg.sender] = false;
468         freezeAmount[msg.sender] = 0;
469     }
470     
471     function ifFreeze(address user) public view returns (
472         bool check, 
473         uint amount, 
474         uint timeLeft
475     ) {
476         check = freezed[user];
477         amount = freezeAmount[user];
478         timeLeft = unlockTime[user] - uint(now);
479     }
480     
481     // ------------------------------------------------------------------------
482     // Partner Authorization
483     // ------------------------------------------------------------------------
484     function createPartner(address _partner, uint _amount, uint _singleTrans, uint _durance) public onlyAdmin returns (uint) {
485         Partner memory _Partner = Partner({
486             admin: _partner,
487             tokenPool: _amount,
488             singleTrans: _singleTrans,
489             timestamp: uint(now),
490             durance: _durance
491         });
492         uint newPartnerId = partners.push(_Partner) - 1;
493         PartnerCreated(newPartnerId, _partner, _amount, _singleTrans, _durance);
494         
495         return newPartnerId;
496     }
497     
498     function partnerTransfer(uint _partnerId, bytes32 _data, address _to, uint _amount) public onlyPartner(_partnerId) whenNotPaused returns (bool) {
499         require(_amount <= partners[_partnerId].singleTrans);
500         partners[_partnerId].tokenPool = safeSub(partners[_partnerId].tokenPool, _amount);
501         Poster memory _Poster = Poster ({
502            poster: _to,
503            hashData: _data,
504            reward: _amount
505         });
506         uint newPostId = PartnerIdToPosterList[_partnerId].push(_Poster) - 1;
507         _mint(_amount, _to);
508         RewardDistribute(newPostId, _partnerId, _to, _amount);
509         return true;
510     }
511     
512     function setPartnerPool(uint _partnerId, uint _amount) public onlyAdmin {
513         partners[_partnerId].tokenPool = _amount;
514     }
515     
516     function setPartnerDurance(uint _partnerId, uint _durance) public onlyAdmin {
517         partners[_partnerId].durance = uint(now) + _durance;
518     }
519     
520     function getPartnerInfo(uint _partnerId) public view returns (
521         address admin,
522         uint tokenPool,
523         uint timeLeft
524     ) {
525         Partner memory _Partner = partners[_partnerId];
526         admin = _Partner.admin;
527         tokenPool = _Partner.tokenPool;
528         if (_Partner.timestamp + _Partner.durance > uint(now)) {
529             timeLeft = _Partner.timestamp + _Partner.durance - uint(now);
530         } else {
531             timeLeft = 0;
532         }
533         
534     }
535 
536     function getPosterInfo(uint _partnerId, uint _posterId) public view returns (
537         address poster,
538         bytes32 hashData,
539         uint reward
540     ) {
541         Poster memory _Poster = PartnerIdToPosterList[_partnerId][_posterId];
542         poster = _Poster.poster;
543         hashData = _Poster.hashData;
544         reward = _Poster.reward;
545     }
546 
547     // ------------------------------------------------------------------------
548     // Vip Agreement
549     // ------------------------------------------------------------------------
550     function createVip(address _vip, uint _durance, uint _frequence, uint _salary) public onlyAdmin returns (uint) {
551         Vip memory _Vip = Vip ({
552            vip: _vip,
553            durance: uint(now) + _durance,
554            frequence: _frequence,
555            salary: _salary,
556            timestamp: now + _frequence
557         });
558         uint newVipId = vips.push(_Vip) - 1;
559         VipAgreementSign(newVipId, _vip, _durance, _frequence, _salary);
560         
561         return newVipId;
562     }
563     
564     function mineSalary(uint _vipId) public onlyVip(_vipId) whenNotPaused returns (bool) {
565         Vip storage _Vip = vips[_vipId];
566         _mint(_Vip.salary, _Vip.vip);
567         _Vip.timestamp = safeAdd(_Vip.timestamp, _Vip.frequence);
568         
569         SalaryReceived(_vipId, _Vip.vip, _Vip.salary, _Vip.timestamp);
570         return true;
571     }
572     
573     function deleteVip(uint _vipId) public onlyAdmin {
574         delete vips[_vipId];
575     }
576     
577     function getVipInfo(uint _vipId) public view returns (
578         address vip,
579         uint durance,
580         uint frequence,
581         uint salary,
582         uint nextSalary,
583         string log
584     ) {
585         Vip memory _Vip = vips[_vipId];
586         vip = _Vip.vip;
587         durance = _Vip.durance;
588         frequence = _Vip.frequence;
589         salary = _Vip.salary;
590         if(_Vip.timestamp >= uint(now)) {
591             nextSalary = safeSub(_Vip.timestamp, uint(now));
592             log = "Please Wait";
593         } else {
594             nextSalary = 0;
595             log = "Pick Up Your Salary Now";
596         }
597     }
598 
599     // ------------------------------------------------------------------------
600     // Accept ETH
601     // ------------------------------------------------------------------------
602     function () public payable {
603     }
604 
605     // ------------------------------------------------------------------------
606     // Owner can transfer out any accidentally sent ERC20 tokens
607     // ------------------------------------------------------------------------
608     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
609         return ERC20Interface(tokenAddress).transfer(CEOAddress, tokens);
610     }
611 }
612 
613 contract XMLY is XMLYToken {
614     event MembershipUpdate(address indexed member, uint indexed level);
615     event MembershipCancel(address indexed member);
616     event XMLYTradeCreated(uint indexed tradeId, bool indexed ifBadge, uint badge, uint token);
617     event TradeCancel(uint indexed tradeId);
618     event TradeComplete(uint indexed tradeId, address indexed buyer, address indexed seller, uint badge, uint token);
619     event Mine(address indexed miner, uint indexed salary);
620     
621     mapping (address => uint) MemberToLevel;
622     mapping (address => uint) MemberToBadge;
623     mapping (address => uint) MemberToToken;
624     mapping (address => uint) MemberToTime;
625     
626     uint public period = 30 days;
627     
628     uint[5] public boardMember =[
629         0,
630         1,
631         10
632     ];
633     
634     uint[5] public salary = [
635         0,
636         10000000000000000000000,
637         100000000000000000000000
638     ];
639     
640     struct XMLYTrade {
641         address seller;
642         bool ifBadge;
643         uint badge;
644         uint token;
645     }
646     
647     XMLYTrade[] xmlyTrades;
648     
649     function boardMemberApply(uint _level) public whenNotPaused {
650         require(_level > 0 && _level <= 4);
651         require(badgeBalances[msg.sender] >= boardMember[_level]);
652         _badgeFreeze(boardMember[_level]);
653         MemberToLevel[msg.sender] = _level;
654         if(MemberToTime[msg.sender] == 0) {
655             MemberToTime[msg.sender] = uint(now);
656         }
657         
658         MembershipUpdate(msg.sender, _level);
659     }
660     
661     function getBoardMember(address _member) public view returns (
662         uint level,
663         uint timeLeft
664     ) {
665         level = MemberToLevel[_member];
666         if(MemberToTime[_member] > uint(now)) {
667             timeLeft = safeSub(MemberToTime[_member], uint(now));
668         } else {
669             timeLeft = 0;
670         }
671     }
672     
673     function boardMemberCancel() public whenNotPaused {
674         require(MemberToLevel[msg.sender] > 0);
675         _badgeUnFreeze(boardMember[MemberToLevel[msg.sender]]);
676         
677         MemberToLevel[msg.sender] = 0;
678         MembershipCancel(msg.sender);
679     }
680     
681     function createXMLYTrade(bool _ifBadge, uint _badge, uint _token) public whenNotPaused returns (uint) {
682         if(_ifBadge) {
683             require(badgeBalances[msg.sender] >= _badge);
684             badgeBalances[msg.sender] = safeSub(badgeBalances[msg.sender], _badge);
685             MemberToBadge[msg.sender] = _badge;
686             XMLYTrade memory xmly = XMLYTrade({
687                seller: msg.sender,
688                ifBadge:_ifBadge,
689                badge: _badge,
690                token: _token
691             });
692             uint newBadgeTradeId = xmlyTrades.push(xmly) - 1;
693             XMLYTradeCreated(newBadgeTradeId, _ifBadge, _badge, _token);
694             
695             return newBadgeTradeId;
696         } else {
697             require(balances[msg.sender] >= _token);
698             balances[msg.sender] = safeSub(balances[msg.sender], _token);
699             MemberToToken[msg.sender] = _token;
700             XMLYTrade memory _xmly = XMLYTrade({
701                seller: msg.sender,
702                ifBadge:_ifBadge,
703                badge: _badge,
704                token: _token
705             });
706             uint newTokenTradeId = xmlyTrades.push(_xmly) - 1;
707             XMLYTradeCreated(newTokenTradeId, _ifBadge, _badge, _token);
708             
709             return newTokenTradeId;
710         }
711     }
712     
713     function cancelTrade(uint _tradeId) public whenNotPaused {
714         XMLYTrade memory xmly = xmlyTrades[_tradeId];
715         require(xmly.seller == msg.sender);
716         if(xmly.ifBadge){
717             badgeBalances[msg.sender] = safeAdd(badgeBalances[msg.sender], xmly.badge);
718             MemberToBadge[msg.sender] = 0;
719         } else {
720             balances[msg.sender] = safeAdd(balances[msg.sender], xmly.token);
721             MemberToToken[msg.sender] = 0;
722         }
723         delete xmlyTrades[_tradeId];
724         TradeCancel(_tradeId);
725     }
726     
727     function trade(uint _tradeId) public whenNotPaused {
728         XMLYTrade memory xmly = xmlyTrades[_tradeId];
729         if(xmly.ifBadge){
730             badgeBalances[msg.sender] = safeAdd(badgeBalances[msg.sender], xmly.badge);
731             MemberToBadge[xmly.seller] = 0;
732             transfer(xmly.seller, xmly.token);
733             delete xmlyTrades[_tradeId];
734             TradeComplete(_tradeId, msg.sender, xmly.seller, xmly.badge, xmly.token);
735         } else {
736             balances[msg.sender] = safeAdd(balances[msg.sender], xmly.token);
737             MemberToToken[xmly.seller] = 0;
738             badgeTransfer(xmly.seller, xmly.badge);
739             delete xmlyTrades[_tradeId];
740             TradeComplete(_tradeId, msg.sender, xmly.seller, xmly.badge, xmly.token);
741         }
742     }
743     
744     function mine() public whenNotPaused {
745         uint level = MemberToLevel[msg.sender];
746         require(MemberToTime[msg.sender] < uint(now)); 
747         require(level > 0);
748         _mint(salary[level], msg.sender);
749         MemberToTime[msg.sender] = safeAdd(MemberToTime[msg.sender], period);
750         Mine(msg.sender, salary[level]);
751     }
752     
753     function setBoardMember(uint one, uint two) public onlyAdmin {
754         boardMember[1] = one;
755         boardMember[2] = two;
756     }
757     
758     function setSalary(uint one, uint two) public onlyAdmin {
759         salary[1] = one;
760         salary[2] = two;
761     }
762     
763     function setPeriod(uint time) public onlyAdmin {
764         period = time;
765     }
766     
767     function getTrade(uint _tradeId) public view returns (
768         address seller,
769         bool ifBadge,
770         uint badge,
771         uint token 
772     ) {
773         XMLYTrade memory _xmly = xmlyTrades[_tradeId];
774         seller = _xmly.seller;
775         ifBadge = _xmly.ifBadge;
776         badge = _xmly.badge;
777         token = _xmly.token;
778     }
779     
780     function WhoIsTheContractMaster() public pure returns (string) {
781         return "Alexander The Exlosion";
782     }
783 }