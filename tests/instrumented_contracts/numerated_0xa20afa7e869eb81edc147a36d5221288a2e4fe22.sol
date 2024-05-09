1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // PinMo contract
5 // 
6 // Symbol      : PMC
7 // Name        : PinMo Crown
8 // Total supply: 100,000
9 // Decimals    : 0
10 // 
11 // Symbol      : PMT
12 // Name        : PinMo Token
13 // Total supply: 273,000,000
14 // Decimals    : 18
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Admin contract
69 // ----------------------------------------------------------------------------
70 contract Administration {
71     event AdminTransferred(address indexed _from, address indexed _to);
72     event Pause();
73     event Unpause();
74     
75     address public adminAddress = 0x9d3177a1363702682EA8913Cb4A8a0FBDa00Ba75;
76 
77     bool public paused = false;
78 
79     modifier onlyAdmin() {
80         require(msg.sender == adminAddress);
81         _;
82     }
83 
84     function setAdmin(address _newAdmin) public onlyAdmin {
85         require(_newAdmin != address(0));
86         AdminTransferred(adminAddress, _newAdmin);
87         adminAddress = _newAdmin;
88         
89     }
90 
91     function withdrawBalance() external onlyAdmin {
92         adminAddress.transfer(this.balance);
93     }
94 
95     modifier whenNotPaused() {
96         require(!paused);
97         _;
98     }
99 
100     modifier whenPaused() {
101         require(paused);
102         _;
103     }
104 
105     function pause() public onlyAdmin whenNotPaused returns(bool) {
106         paused = true;
107         Pause();
108         return true;
109     }
110 
111     function unpause() public onlyAdmin whenPaused returns(bool) {
112         paused = false;
113         Unpause();
114         return true;
115     }
116 
117     uint oneEth = 1 ether;
118 }
119 
120 contract PinMoCrown is ERC20Interface, Administration, SafeMath {
121     event CrownTransfer(address indexed from, address indexed to, uint tokens);
122     
123     string public crownSymbol;
124     string public crownName;
125     uint8 public crownDecimals;
126     uint public _crownTotalSupply;
127 
128     mapping(address => uint) crownBalances;
129     mapping(address => bool) crownFreezed;
130     mapping(address => uint) crownFreezeAmount;
131     mapping(address => uint) crownUnlockTime;
132 
133 
134     // ------------------------------------------------------------------------
135     // Constructor
136     // ------------------------------------------------------------------------
137     function PinMoCrown() public {
138         crownSymbol = "PMC";
139         crownName = "PinMo Crown";
140         crownDecimals = 0;
141         _crownTotalSupply = 100000;
142         crownBalances[adminAddress] = _crownTotalSupply;
143         CrownTransfer(address(0), adminAddress, _crownTotalSupply);
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Total supply
149     // ------------------------------------------------------------------------
150     function crownTotalSupply() public constant returns (uint) {
151         return _crownTotalSupply  - crownBalances[address(0)];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Get the token balance for account tokenOwner
157     // ------------------------------------------------------------------------
158     function crownBalanceOf(address tokenOwner) public constant returns (uint balance) {
159         return crownBalances[tokenOwner];
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer the balance from token owner's account to to account
165     // - Owner's account must have sufficient balance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function crownTransfer(address to, uint tokens) public whenNotPaused returns (bool success) {
169         if(crownFreezed[msg.sender] == false){
170             crownBalances[msg.sender] = safeSub(crownBalances[msg.sender], tokens);
171             crownBalances[to] = safeAdd(crownBalances[to], tokens);
172             CrownTransfer(msg.sender, to, tokens);
173         } else {
174             if(crownBalances[msg.sender] > crownFreezeAmount[msg.sender]) {
175                 require(tokens <= safeSub(crownBalances[msg.sender], crownFreezeAmount[msg.sender]));
176                 crownBalances[msg.sender] = safeSub(crownBalances[msg.sender], tokens);
177                 crownBalances[to] = safeAdd(crownBalances[to], tokens);
178                 CrownTransfer(msg.sender, to, tokens);
179             }
180         }
181             
182         return true;
183     }
184 
185     // ------------------------------------------------------------------------
186     // Mint Tokens
187     // ------------------------------------------------------------------------
188     function mintCrown(uint amount) public onlyAdmin {
189         crownBalances[msg.sender] = safeAdd(crownBalances[msg.sender], amount);
190         _crownTotalSupply = safeAdd(_crownTotalSupply, amount);
191     }
192 
193     // ------------------------------------------------------------------------
194     // Burn Tokens
195     // ------------------------------------------------------------------------
196     function burnCrown(uint amount) public onlyAdmin {
197         crownBalances[msg.sender] = safeSub(crownBalances[msg.sender], amount);
198         _crownTotalSupply = safeSub(_crownTotalSupply, amount);
199     }
200     
201     // ------------------------------------------------------------------------
202     // Freeze Tokens
203     // ------------------------------------------------------------------------
204     function crownFreeze(address user, uint amount, uint period) public onlyAdmin {
205         require(crownBalances[user] >= amount);
206         crownFreezed[user] = true;
207         crownUnlockTime[user] = uint(now) + period;
208         crownFreezeAmount[user] = amount;
209     }
210     
211     function _crownFreeze(uint amount) internal {
212         require(crownFreezed[msg.sender] == false);
213         require(crownBalances[msg.sender] >= amount);
214         crownFreezed[msg.sender] = true;
215         crownUnlockTime[msg.sender] = uint(-1);
216         crownFreezeAmount[msg.sender] = amount;
217     }
218 
219     // ------------------------------------------------------------------------
220     // UnFreeze Tokens
221     // ------------------------------------------------------------------------
222     function crownUnFreeze() public whenNotPaused {
223         require(crownFreezed[msg.sender] == true);
224         require(crownUnlockTime[msg.sender] < uint(now));
225         crownFreezed[msg.sender] = false;
226         crownFreezeAmount[msg.sender] = 0;
227     }
228     
229     function _crownUnFreeze(uint _amount) internal {
230         require(crownFreezed[msg.sender] == true);
231         crownUnlockTime[msg.sender] = 0;
232         crownFreezed[msg.sender] = false;
233         crownFreezeAmount[msg.sender] = safeSub(crownFreezeAmount[msg.sender], _amount);
234     }
235     
236     function crownIfFreeze(address user) public view returns (
237         bool check, 
238         uint amount, 
239         uint timeLeft
240     ) {
241         check = crownFreezed[user];
242         amount = crownFreezeAmount[user];
243         timeLeft = crownUnlockTime[user] - uint(now);
244     }
245 
246 }
247 
248 //
249 contract PinMoToken is PinMoCrown {
250     event PartnerCreated(uint indexed partnerId, address indexed partner, uint indexed amount, uint singleTrans, uint durance);
251     event RewardDistribute(uint indexed postId, uint partnerId, address indexed user, uint indexed amount);
252     
253     event VipAgreementSign(uint indexed vipId, address indexed vip, uint durance, uint frequence, uint salar);
254     event SalaryReceived(uint indexed vipId, address indexed vip, uint salary, uint indexed timestamp);
255     
256     string public symbol;
257     string public  name;
258     uint8 public decimals;
259     uint public _totalSupply;
260     uint public minePool;
261 
262 //Advertising partner can construct their rewarding pool for each campaign
263     struct Partner {
264         address admin;
265         uint tokenPool;
266         uint singleTrans;
267         uint timestamp;
268         uint durance;
269     }
270 //regular users
271     struct Poster {
272         address poster;
273         bytes32 hashData;
274         uint reward;
275     }
276 //Influencers do have additional privileges such as salary
277     struct Vip {
278         address vip;
279         uint durance;
280         uint frequence;
281         uint salary;
282         uint timestamp;
283     }
284     
285     Partner[] partners;
286     Vip[] vips;
287 
288     modifier onlyPartner(uint _partnerId) {
289         require(partners[_partnerId].admin == msg.sender);
290         require(partners[_partnerId].tokenPool > uint(0));
291         uint deadline = safeAdd(partners[_partnerId].timestamp, partners[_partnerId].durance);
292         require(deadline > now);
293         _;
294     }
295     
296     modifier onlyVip(uint _vipId) {
297         require(vips[_vipId].vip == msg.sender);
298         require(vips[_vipId].durance > now);
299         require(vips[_vipId].timestamp < now);
300         _;
301     }
302 
303     mapping(address => uint) balances;
304     mapping(address => mapping(address => uint)) allowed;
305     mapping(address => bool) freezed;
306     mapping(address => uint) freezeAmount;
307     mapping(address => uint) unlockTime;
308     
309     mapping(uint => Poster[]) PartnerIdToPosterList;
310 
311 
312     // ------------------------------------------------------------------------
313     // Constructor
314     // ------------------------------------------------------------------------
315     function PinMoToken() public {
316         symbol = "pinmo";
317         name = "PinMo Token";
318         decimals = 18;
319         _totalSupply = 273000000000000000000000000;
320         
321     //rewarding pool
322         minePool = 136500000000000000000000000;
323         balances[adminAddress] = _totalSupply - minePool;
324         Transfer(address(0), adminAddress, _totalSupply);
325     }
326     
327     // ------------------------------------------------------------------------
328     // Total supply
329     // ------------------------------------------------------------------------
330     function totalSupply() public constant returns (uint) {
331         return _totalSupply  - balances[address(0)];
332     }
333 
334 
335     // ------------------------------------------------------------------------
336     // Get the token balance for account tokenOwner
337     // ------------------------------------------------------------------------
338     function balanceOf(address tokenOwner) public constant returns (uint balance) {
339         return balances[tokenOwner];
340     }
341 
342 
343     // ------------------------------------------------------------------------
344     // Transfer the balance from token owner's account to to account
345     // - Owner's account must have sufficient balance to transfer
346     // - 0 value transfers are allowed
347     // ------------------------------------------------------------------------
348     function transfer(address to, uint tokens) public returns (bool success) {
349         if(freezed[msg.sender] == false){
350             balances[msg.sender] = safeSub(balances[msg.sender], tokens);
351             balances[to] = safeAdd(balances[to], tokens);
352             Transfer(msg.sender, to, tokens);
353         } else {
354             if(balances[msg.sender] > freezeAmount[msg.sender]) {
355                 require(tokens <= safeSub(balances[msg.sender], freezeAmount[msg.sender]));
356                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
357                 balances[to] = safeAdd(balances[to], tokens);
358                 Transfer(msg.sender, to, tokens);
359             }
360         }
361             
362         return true;
363     }
364 
365 
366     // ------------------------------------------------------------------------
367     // Token owner can approve for spender to transferFrom(...) tokens
368     // from the token owner's account
369     //
370     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
371     // recommends that there are no checks for the approval double-spend attack
372     // as this should be implemented in user interfaces 
373     // ------------------------------------------------------------------------
374     function approve(address spender, uint tokens) public returns (bool success) {
375         require(freezed[msg.sender] != true);
376         allowed[msg.sender][spender] = tokens;
377         Approval(msg.sender, spender, tokens);
378         return true;
379     }
380 
381 
382     // ------------------------------------------------------------------------
383     // Transfer tokens from the from account to the to account
384     // 
385     // The calling account must already have sufficient tokens approve(...)-d
386     // for spending from the from account and
387     // - From account must have sufficient balance to transfer
388     // - Spender must have sufficient allowance to transfer
389     // - 0 value transfers are allowed
390     // ------------------------------------------------------------------------
391     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
392         balances[from] = safeSub(balances[from], tokens);
393         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
394         balances[to] = safeAdd(balances[to], tokens);
395         Transfer(from, to, tokens);
396         return true;
397     }
398 
399 
400     // ------------------------------------------------------------------------
401     // Returns the amount of tokens approved by the owner that can be
402     // transferred to the spender's account
403     // ------------------------------------------------------------------------
404     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
405         require(freezed[msg.sender] != true);
406         return allowed[tokenOwner][spender];
407     }
408 
409 
410     // ------------------------------------------------------------------------
411     // Token owner can approve for spender to transferFrom(...) tokens
412     // from the token owner's account. The spender contract function
413     // receiveApproval(...) is then executed
414     // ------------------------------------------------------------------------
415     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
416         require(freezed[msg.sender] != true);
417         allowed[msg.sender][spender] = tokens;
418         Approval(msg.sender, spender, tokens);
419         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
420         return true;
421     }
422 
423     // ------------------------------------------------------------------------
424     // Mint Tokens
425     // ------------------------------------------------------------------------
426     function _mint(uint amount, address receiver) internal {
427         require(minePool >= amount);
428         minePool = safeSub(minePool, amount);
429         balances[receiver] = safeAdd(balances[receiver], amount);
430         Transfer(address(0), receiver, amount);
431     }
432     
433     function mint(uint amount) public onlyAdmin {
434         require(minePool >= amount);
435         minePool = safeSub(minePool, amount);
436         balances[msg.sender] = safeAdd(balances[msg.sender], amount);
437         Transfer(address(0), msg.sender, amount);
438     }
439     
440     // ------------------------------------------------------------------------
441     // Freeze Tokens
442     // ------------------------------------------------------------------------
443     function freeze(address user, uint amount, uint period) public onlyAdmin {
444         require(balances[user] >= amount);
445         freezed[user] = true;
446         unlockTime[user] = uint(now) + period;
447         freezeAmount[user] = amount;
448     }
449 
450     // ------------------------------------------------------------------------
451     // UnFreeze Tokens
452     // ------------------------------------------------------------------------
453     function unFreeze() public {
454         require(freezed[msg.sender] == true);
455         require(unlockTime[msg.sender] < uint(now));
456         freezed[msg.sender] = false;
457         freezeAmount[msg.sender] = 0;
458     }
459     
460     function ifFreeze(address user) public view returns (
461         bool check, 
462         uint amount, 
463         uint timeLeft
464     ) {
465         check = freezed[user];
466         amount = freezeAmount[user];
467         timeLeft = unlockTime[user] - uint(now);
468     }
469     
470     // ------------------------------------------------------------------------
471     // Partner Authorization
472     // ------------------------------------------------------------------------
473     function createPartner(address _partner, uint _amount, uint _singleTrans, uint _durance) public onlyAdmin returns (uint) {
474         Partner memory _Partner = Partner({
475             admin: _partner,
476             tokenPool: _amount,
477             singleTrans: _singleTrans,
478             timestamp: uint(now),
479             durance: _durance
480         });
481         uint newPartnerId = partners.push(_Partner) - 1;
482         PartnerCreated(newPartnerId, _partner, _amount, _singleTrans, _durance);
483         
484         return newPartnerId;
485     }
486     
487     function partnerTransfer(uint _partnerId, bytes32 _data, address _to, uint _amount) public onlyPartner(_partnerId) whenNotPaused returns (bool) {
488         require(_amount <= partners[_partnerId].singleTrans);
489         partners[_partnerId].tokenPool = safeSub(partners[_partnerId].tokenPool, _amount);
490         Poster memory _Poster = Poster ({
491            poster: _to,
492             hashData: _data,
493            reward: _amount
494         });
495         uint newPostId = PartnerIdToPosterList[_partnerId].push(_Poster) - 1;
496         _mint(_amount, _to);
497         RewardDistribute(newPostId, _partnerId, _to, _amount);
498         return true;
499     }
500     
501     function setPartnerPool(uint _partnerId, uint _amount) public onlyAdmin {
502         partners[_partnerId].tokenPool = _amount;
503     }
504     
505     function setPartnerDurance(uint _partnerId, uint _durance) public onlyAdmin {
506         partners[_partnerId].durance = uint(now) + _durance;
507     }
508     
509     function getPartnerInfo(uint _partnerId) public view returns (
510         address admin,
511         uint tokenPool,
512         uint timeLeft
513     ) {
514         Partner memory _Partner = partners[_partnerId];
515         admin = _Partner.admin;
516         tokenPool = _Partner.tokenPool;
517         if (_Partner.timestamp + _Partner.durance > uint(now)) {
518             timeLeft = _Partner.timestamp + _Partner.durance - uint(now);
519         } else {
520             timeLeft = 0;
521         }
522         
523     }
524 
525     function getPosterInfo(uint _partnerId, uint _posterId) public view returns (
526         address poster,
527         bytes32 hashData,
528         uint reward
529     ) {
530         Poster memory _Poster = PartnerIdToPosterList[_partnerId][_posterId];
531         poster = _Poster.poster;
532         hashData = _Poster.hashData;
533         reward = _Poster.reward;
534     }
535 
536     // ------------------------------------------------------------------------
537     // Vip Agreement
538     // ------------------------------------------------------------------------
539     function createVip(address _vip, uint _durance, uint _frequence, uint _salary) public onlyAdmin returns (uint) {
540         Vip memory _Vip = Vip ({
541            vip: _vip,
542            durance: uint(now) + _durance,
543            frequence: _frequence,
544            salary: _salary,
545            timestamp: now + _frequence
546         });
547         uint newVipId = vips.push(_Vip) - 1;
548         VipAgreementSign(newVipId, _vip, _durance, _frequence, _salary);
549         
550         return newVipId;
551     }
552     
553     function mineSalary(uint _vipId) public onlyVip(_vipId) whenNotPaused returns (bool) {
554         Vip storage _Vip = vips[_vipId];
555         _mint(_Vip.salary, _Vip.vip);
556         _Vip.timestamp = safeAdd(_Vip.timestamp, _Vip.frequence);
557         
558         SalaryReceived(_vipId, _Vip.vip, _Vip.salary, _Vip.timestamp);
559         return true;
560     }
561     
562     function deleteVip(uint _vipId) public onlyAdmin {
563         delete vips[_vipId];
564     }
565     
566     function getVipInfo(uint _vipId) public view returns (
567         address vip,
568         uint durance,
569         uint frequence,
570         uint salary,
571         uint nextSalary,
572         string log
573     ) {
574         Vip memory _Vip = vips[_vipId];
575         vip = _Vip.vip;
576         durance = _Vip.durance;
577         frequence = _Vip.frequence;
578         salary = _Vip.salary;
579         if(_Vip.timestamp >= uint(now)) {
580             nextSalary = safeSub(_Vip.timestamp, uint(now));
581             log = "Please Wait";
582         } else {
583             nextSalary = 0;
584             log = "Pick Up Your Salary Now";
585         }
586     }
587 
588     // ------------------------------------------------------------------------
589     // Accept ETH
590     // ------------------------------------------------------------------------
591     function () public payable {
592     }
593 
594     // ------------------------------------------------------------------------
595     // Owner can transfer out any accidentally sent ERC20 tokens
596     // ------------------------------------------------------------------------
597     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
598         return ERC20Interface(tokenAddress).transfer(adminAddress, tokens);
599     }
600 }
601 
602 contract PinMo is PinMoToken {
603     event MembershipUpdate(address indexed member, uint indexed level);
604     event MembershipCancel(address indexed member);
605     event PinMoTradeCreated(uint indexed tradeId, bool indexed ifCrown, uint crown, uint token);
606     event TradeCancel(uint indexed tradeId);
607     event TradeComplete(uint indexed tradeId, address indexed buyer, address indexed seller, uint crown, uint token);
608     event Mine(address indexed miner, uint indexed salary);
609     
610     mapping (address => uint) MemberToLevel;
611     mapping (address => uint) MemberToCrown;
612     mapping (address => uint) MemberToToken;
613     mapping (address => uint) MemberToTime;
614     
615     uint public period = 30 days;
616     
617     uint[4] public boardMember =[
618         0,
619         5,
620         25,
621         100
622     ];
623 
624     uint[4] public salary = [
625         0,
626         2000000000000000000000,
627         6000000000000000000000,
628         12000000000000000000000
629     ];
630     
631     struct PinMoTrade {
632         address seller;
633         bool ifCrown;
634         uint crown;
635         uint token;
636     }
637     
638     PinMoTrade[] pinMoTrades;
639     
640     function boardMemberApply(uint _level) public whenNotPaused {
641         require(_level > 0 && _level <= 3);
642         require(crownBalances[msg.sender] >= boardMember[_level]);
643         _crownFreeze(boardMember[_level]);
644         MemberToLevel[msg.sender] = _level;
645         if(MemberToTime[msg.sender] == 0) {
646             MemberToTime[msg.sender] = uint(now);
647         }
648         
649         MembershipUpdate(msg.sender, _level);
650     }
651     
652     function getBoardMember(address _member) public view returns (
653         uint level,
654         uint timeLeft
655     ) {
656         level = MemberToLevel[_member];
657         if(MemberToTime[_member] > uint(now)) {
658             timeLeft = safeSub(MemberToTime[_member], uint(now));
659         } else {
660             timeLeft = 0;
661         }
662     }
663     
664     function boardMemberCancel() public whenNotPaused {
665         require(MemberToLevel[msg.sender] > 0);
666         _crownUnFreeze(boardMember[MemberToLevel[msg.sender]]);
667         
668         MemberToLevel[msg.sender] = 0;
669         MembershipCancel(msg.sender);
670     }
671     
672     function createPinMoTrade(bool _ifCrown, uint _crown, uint _token) public whenNotPaused returns (uint) {
673         if(_ifCrown) {
674             require(crownBalances[msg.sender] >= _crown);
675             crownBalances[msg.sender] = safeSub(crownBalances[msg.sender], _crown);
676             MemberToCrown[msg.sender] = _crown;
677             PinMoTrade memory pinMo = PinMoTrade({
678                seller: msg.sender,
679                ifCrown:_ifCrown,
680                crown: _crown,
681                token: _token
682             });
683             uint newCrownTradeId = pinMoTrades.push(pinMo) - 1;
684             PinMoTradeCreated(newCrownTradeId, _ifCrown, _crown, _token);
685             
686             return newCrownTradeId;
687         } else {
688             require(balances[msg.sender] >= _token);
689             balances[msg.sender] = safeSub(balances[msg.sender], _token);
690             MemberToToken[msg.sender] = _token;
691             PinMoTrade memory _pinMo = PinMoTrade({
692                seller: msg.sender,
693                ifCrown:_ifCrown,
694                crown: _crown,
695                token: _token
696             });
697             uint newTokenTradeId = pinMoTrades.push(_pinMo) - 1;
698             PinMoTradeCreated(newTokenTradeId, _ifCrown, _crown, _token);
699             
700             return newTokenTradeId;
701         }
702     }
703     
704     function cancelTrade(uint _tradeId) public whenNotPaused {
705         PinMoTrade memory pinMo = pinMoTrades[_tradeId];
706         require(pinMo.seller == msg.sender);
707         if(pinMo.ifCrown){
708             crownBalances[msg.sender] = safeAdd(crownBalances[msg.sender], pinMo.crown);
709             MemberToCrown[msg.sender] = 0;
710         } else {
711             balances[msg.sender] = safeAdd(balances[msg.sender], pinMo.token);
712             MemberToToken[msg.sender] = 0;
713         }
714         delete pinMoTrades[_tradeId];
715         TradeCancel(_tradeId);
716     }
717     
718     function trade(uint _tradeId) public whenNotPaused {
719         PinMoTrade memory pinMo = pinMoTrades[_tradeId];
720         if(pinMo.ifCrown){
721             crownBalances[msg.sender] = safeAdd(crownBalances[msg.sender], pinMo.crown);
722             MemberToCrown[pinMo.seller] = 0;
723             transfer(pinMo.seller, pinMo.token);
724             delete pinMoTrades[_tradeId];
725             TradeComplete(_tradeId, msg.sender, pinMo.seller, pinMo.crown, pinMo.token);
726         } else {
727             balances[msg.sender] = safeAdd(balances[msg.sender], pinMo.token);
728             MemberToToken[pinMo.seller] = 0;
729             crownTransfer(pinMo.seller, pinMo.crown);
730             delete pinMoTrades[_tradeId];
731             TradeComplete(_tradeId, msg.sender, pinMo.seller, pinMo.crown, pinMo.token);
732         }
733     }
734     
735     function mine() public whenNotPaused {
736         uint level = MemberToLevel[msg.sender];
737         require(MemberToTime[msg.sender] < uint(now)); 
738         require(level > 0);
739         _mint(salary[level], msg.sender);
740         MemberToTime[msg.sender] = safeAdd(MemberToTime[msg.sender], period);
741         Mine(msg.sender, salary[level]);
742     }
743     
744     function setBoardMember(uint one, uint two, uint three) public onlyAdmin {
745         boardMember[1] = one;
746         boardMember[2] = two;
747         boardMember[3] = three;
748     }
749     
750     function setSalary(uint one, uint two, uint three) public onlyAdmin {
751         salary[1] = one;
752         salary[2] = two;
753         salary[3] = three;
754     }
755     
756     function setPeriod(uint time) public onlyAdmin {
757         period = time;
758     }
759     
760     function getTrade(uint _tradeId) public view returns (
761         address seller,
762         bool ifCrown,
763         uint crown,
764         uint token 
765     ) {
766         PinMoTrade memory _pinMo = pinMoTrades[_tradeId];
767         seller = _pinMo.seller;
768         ifCrown = _pinMo.ifCrown;
769         crown = _pinMo.crown;
770         token = _pinMo.token;
771     }
772     
773     function WhoIsTheContractMaster() public pure returns (string) {
774         return "Alexander The Exlosion";
775     }
776 }