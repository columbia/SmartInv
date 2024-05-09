1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //共识会 contract
5 //
6 //共识勋章：象征着你在共识会的地位和权利
7 //Anno Consensus Medal: Veni, Vidi, Vici
8 // 
9 // Symbol      : GSU
10 // Name        : Anno Consensus
11 // Total supply: 1000000
12 // Decimals    : 0
13 // 
14 // 共识币：维护共识新纪元的基石
15 //Anno Consensus Coin: Caput, Anguli, Seclorum
16 // Symbol      : ANNO
17 // Name        : Anno Consensus Token
18 // Total supply: 1000000000
19 // Decimals    : 18
20 // ----------------------------------------------------------------------------
21 
22 
23 // ----------------------------------------------------------------------------
24 // Safe maths
25 // ----------------------------------------------------------------------------
26 contract SafeMath {
27     function safeAdd(uint a, uint b) public pure returns (uint c) {
28         c = a + b;
29         require(c >= a);
30     }
31     function safeSub(uint a, uint b) public pure returns (uint c) {
32         require(b <= a);
33         c = a - b;
34     }
35     function safeMul(uint a, uint b) public pure returns (uint c) {
36         c = a * b;
37         require(a == 0 || c / a == b);
38     }
39     function safeDiv(uint a, uint b) public pure returns (uint c) {
40         require(b > 0);
41         c = a / b;
42     }
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // ----------------------------------------------------------------------------
49 contract ERC20Interface {
50     function totalSupply() public constant returns (uint);
51     function balanceOf(address tokenOwner) public constant returns (uint balance);
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Contract function to receive approval and execute function in one call
64 //
65 // Borrowed from MiniMeToken
66 // ----------------------------------------------------------------------------
67 contract ApproveAndCallFallBack {
68     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Owned contract
74 // ----------------------------------------------------------------------------
75 contract Owned {
76     address public owner;
77     address public newOwner;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80 
81     function Owned() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99     
100     function withdrawBalance() external onlyOwner {
101         owner.transfer(this.balance);
102     }
103     
104     // ------------------------------------------------------------------------
105     // Accept ETH
106     // ------------------------------------------------------------------------
107     function () public payable {
108     }
109 }
110 
111 
112 // ----------------------------------------------------------------------------
113 // ERC20 Token, with the addition of symbol, name and decimals and assisted
114 // token transfers
115 // ----------------------------------------------------------------------------
116 contract GSUMedal is ERC20Interface, Owned, SafeMath {
117     event MedalTransfer(address indexed from, address indexed to, uint tokens);
118     
119     string public medalSymbol;
120     string public medalName;
121     uint8 public medalDecimals;
122     uint public _medalTotalSupply;
123 
124     mapping(address => uint) medalBalances;
125     mapping(address => bool) medalFreezed;
126     mapping(address => uint) medalFreezeAmount;
127     mapping(address => uint) medalUnlockTime;
128 
129 
130     // ------------------------------------------------------------------------
131     // Constructor
132     // ------------------------------------------------------------------------
133     function GSUMedal() public {
134         medalSymbol = "GSU";
135         medalName = "Anno Consensus";
136         medalDecimals = 0;
137         _medalTotalSupply = 1000000;
138         medalBalances[msg.sender] = _medalTotalSupply;
139         MedalTransfer(address(0), msg.sender, _medalTotalSupply);
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Total supply
145     // ------------------------------------------------------------------------
146     function medalTotalSupply() public constant returns (uint) {
147         return _medalTotalSupply  - medalBalances[address(0)];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Get the token balance for account tokenOwner
153     // ------------------------------------------------------------------------
154     function mentalBalanceOf(address tokenOwner) public constant returns (uint balance) {
155         return medalBalances[tokenOwner];
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer the balance from token owner's account to to account
161     // - Owner's account must have sufficient balance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function medalTransfer(address to, uint tokens) public returns (bool success) {
165         if(medalFreezed[msg.sender] == false){
166             medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], tokens);
167             medalBalances[to] = safeAdd(medalBalances[to], tokens);
168             MedalTransfer(msg.sender, to, tokens);
169         } else {
170             if(medalBalances[msg.sender] > medalFreezeAmount[msg.sender]) {
171                 require(tokens <= safeSub(medalBalances[msg.sender], medalFreezeAmount[msg.sender]));
172                 medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], tokens);
173                 medalBalances[to] = safeAdd(medalBalances[to], tokens);
174                 MedalTransfer(msg.sender, to, tokens);
175             }
176         }
177             
178         return true;
179     }
180 
181     // ------------------------------------------------------------------------
182     // Mint Tokens
183     // ------------------------------------------------------------------------
184     function mintMedal(uint amount) public onlyOwner {
185         medalBalances[msg.sender] = safeAdd(medalBalances[msg.sender], amount);
186         _medalTotalSupply = safeAdd(_medalTotalSupply, amount);
187     }
188 
189     // ------------------------------------------------------------------------
190     // Burn Tokens
191     // ------------------------------------------------------------------------
192     function burnMedal(uint amount) public onlyOwner {
193         medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], amount);
194         _medalTotalSupply = safeSub(_medalTotalSupply, amount);
195     }
196     
197     // ------------------------------------------------------------------------
198     // Freeze Tokens
199     // ------------------------------------------------------------------------
200     function medalFreeze(address user, uint amount, uint period) public onlyOwner {
201         require(medalBalances[user] >= amount);
202         medalFreezed[user] = true;
203         medalUnlockTime[user] = uint(now) + period;
204         medalFreezeAmount[user] = amount;
205     }
206     
207     function _medalFreeze(uint amount) internal {
208         require(medalBalances[msg.sender] >= amount);
209         medalFreezed[msg.sender] = true;
210         medalUnlockTime[msg.sender] = uint(-1);
211         medalFreezeAmount[msg.sender] = amount;
212     }
213 
214     // ------------------------------------------------------------------------
215     // UnFreeze Tokens
216     // ------------------------------------------------------------------------
217     function medalUnFreeze() public {
218         require(medalFreezed[msg.sender] == true);
219         require(medalUnlockTime[msg.sender] < uint(now));
220         medalFreezed[msg.sender] = false;
221         medalFreezeAmount[msg.sender] = 0;
222     }
223     
224     function _medalUnFreeze() internal {
225         require(medalFreezed[msg.sender] == true);
226         medalUnlockTime[msg.sender] = 0;
227         medalFreezed[msg.sender] = false;
228         medalFreezeAmount[msg.sender] = 0;
229     }
230     
231     function medalIfFreeze(address user) public view returns (
232         bool check, 
233         uint amount, 
234         uint timeLeft
235     ) {
236         check = medalFreezed[user];
237         amount = medalFreezeAmount[user];
238         timeLeft = medalUnlockTime[user] - uint(now);
239     }
240 
241 }
242 
243 // ----------------------------------------------------------------------------
244 // ERC20 Token, with the addition of symbol, name and decimals and assisted
245 // token transfers
246 // ----------------------------------------------------------------------------
247 contract AnnoToken is GSUMedal {
248     string public symbol;
249     string public  name;
250     uint8 public decimals;
251     uint public _totalSupply;
252     uint public minePool;
253 
254     mapping(address => uint) balances;
255     mapping(address => mapping(address => uint)) allowed;
256     mapping(address => bool) freezed;
257     mapping(address => uint) freezeAmount;
258     mapping(address => uint) unlockTime;
259 
260 
261     // ------------------------------------------------------------------------
262     // Constructor
263     // ------------------------------------------------------------------------
264     function AnnoToken() public {
265         symbol = "ANNO";
266         name = "Anno Consensus Token";
267         decimals = 18;
268         _totalSupply = 1000000000000000000000000000;
269         minePool = 600000000000000000000000000;
270         balances[msg.sender] = _totalSupply - minePool;
271         Transfer(address(0), msg.sender, _totalSupply - minePool);
272     }
273 
274 
275     // ------------------------------------------------------------------------
276     // Total supply
277     // ------------------------------------------------------------------------
278     function totalSupply() public constant returns (uint) {
279         return _totalSupply  - balances[address(0)];
280     }
281 
282 
283     // ------------------------------------------------------------------------
284     // Get the token balance for account tokenOwner
285     // ------------------------------------------------------------------------
286     function balanceOf(address tokenOwner) public constant returns (uint balance) {
287         return balances[tokenOwner];
288     }
289 
290 
291     // ------------------------------------------------------------------------
292     // Transfer the balance from token owner's account to to account
293     // - Owner's account must have sufficient balance to transfer
294     // - 0 value transfers are allowed
295     // ------------------------------------------------------------------------
296     function transfer(address to, uint tokens) public returns (bool success) {
297         if(freezed[msg.sender] == false){
298             balances[msg.sender] = safeSub(balances[msg.sender], tokens);
299             balances[to] = safeAdd(balances[to], tokens);
300             Transfer(msg.sender, to, tokens);
301         } else {
302             if(balances[msg.sender] > freezeAmount[msg.sender]) {
303                 require(tokens <= safeSub(balances[msg.sender], freezeAmount[msg.sender]));
304                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
305                 balances[to] = safeAdd(balances[to], tokens);
306                 Transfer(msg.sender, to, tokens);
307             }
308         }
309             
310         return true;
311     }
312 
313 
314     // ------------------------------------------------------------------------
315     // Token owner can approve for spender to transferFrom(...) tokens
316     // from the token owner's account
317     //
318     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
319     // recommends that there are no checks for the approval double-spend attack
320     // as this should be implemented in user interfaces 
321     // ------------------------------------------------------------------------
322     function approve(address spender, uint tokens) public returns (bool success) {
323         require(freezed[msg.sender] != true);
324         allowed[msg.sender][spender] = tokens;
325         Approval(msg.sender, spender, tokens);
326         return true;
327     }
328 
329 
330     // ------------------------------------------------------------------------
331     // Transfer tokens from the from account to the to account
332     // 
333     // The calling account must already have sufficient tokens approve(...)-d
334     // for spending from the from account and
335     // - From account must have sufficient balance to transfer
336     // - Spender must have sufficient allowance to transfer
337     // - 0 value transfers are allowed
338     // ------------------------------------------------------------------------
339     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
340         balances[from] = safeSub(balances[from], tokens);
341         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
342         balances[to] = safeAdd(balances[to], tokens);
343         Transfer(from, to, tokens);
344         return true;
345     }
346 
347 
348     // ------------------------------------------------------------------------
349     // Returns the amount of tokens approved by the owner that can be
350     // transferred to the spender's account
351     // ------------------------------------------------------------------------
352     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
353         require(freezed[msg.sender] != true);
354         return allowed[tokenOwner][spender];
355     }
356 
357 
358     // ------------------------------------------------------------------------
359     // Token owner can approve for spender to transferFrom(...) tokens
360     // from the token owner's account. The spender contract function
361     // receiveApproval(...) is then executed
362     // ------------------------------------------------------------------------
363     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
364         require(freezed[msg.sender] != true);
365         allowed[msg.sender][spender] = tokens;
366         Approval(msg.sender, spender, tokens);
367         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
368         return true;
369     }
370     
371     // ------------------------------------------------------------------------
372     // Freeze Tokens
373     // ------------------------------------------------------------------------
374     function freeze(address user, uint amount, uint period) public onlyOwner {
375         require(balances[user] >= amount);
376         freezed[user] = true;
377         unlockTime[user] = uint(now) + period;
378         freezeAmount[user] = amount;
379     }
380 
381     // ------------------------------------------------------------------------
382     // UnFreeze Tokens
383     // ------------------------------------------------------------------------
384     function unFreeze() public {
385         require(freezed[msg.sender] == true);
386         require(unlockTime[msg.sender] < uint(now));
387         freezed[msg.sender] = false;
388         freezeAmount[msg.sender] = 0;
389     }
390     
391     function ifFreeze(address user) public view returns (
392         bool check, 
393         uint amount, 
394         uint timeLeft
395     ) {
396         check = freezed[user];
397         amount = freezeAmount[user];
398         timeLeft = unlockTime[user] - uint(now);
399     }
400     
401     function _mine(uint _amount) internal {
402         balances[msg.sender] = safeAdd(balances[msg.sender], _amount);
403         minePool = safeSub(minePool, _amount);
404     }
405 
406     // ------------------------------------------------------------------------
407     // Owner can transfer out any accidentally sent ERC20 tokens
408     // ------------------------------------------------------------------------
409     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
410         return ERC20Interface(tokenAddress).transfer(owner, tokens);
411     }
412 }
413 
414 contract AnnoConsensus is AnnoToken {
415     event MembershipUpdate(address indexed member, uint indexed level);
416     event MembershipCancel(address indexed member);
417     event AnnoTradeCreated(uint indexed tradeId, bool indexed ifMedal, uint medal, uint token);
418     event TradeCancel(uint indexed tradeId);
419     event TradeComplete(uint indexed tradeId, address indexed buyer, address indexed seller, uint medal, uint token);
420     event Mine(address indexed miner, uint indexed salary);
421     
422     mapping (address => uint) MemberToLevel;
423     mapping (address => uint) MemberToMedal;
424     mapping (address => uint) MemberToToken;
425     mapping (address => uint) MemberToTime;
426     
427     uint public period = 14 days;
428     
429     uint[5] public boardMember =[
430         0,
431         500,
432         2500,
433         25000,
434         50000
435     ];
436     
437     uint[5] public salary = [
438         0,
439         1151000000000000000000,
440         5753000000000000000000,
441         57534000000000000000000,
442         115068000000000000000000
443     ];
444     
445     struct AnnoTrade {
446         address seller;
447         bool ifMedal;
448         uint medal;
449         uint token;
450     }
451     
452     AnnoTrade[] annoTrades;
453     
454     function boardMemberApply(uint _level) public {
455         require(medalBalances[msg.sender] >= boardMember[_level]);
456         _medalFreeze(boardMember[_level]);
457         MemberToLevel[msg.sender] = _level;
458         
459         MembershipUpdate(msg.sender, _level);
460     }
461     
462     function getBoardMember(address _member) public view returns (uint) {
463         return MemberToLevel[_member];
464     }
465     
466     function boardMemberCancel() public {
467         require(medalBalances[msg.sender] > 0);
468         _medalUnFreeze();
469         
470         MemberToLevel[msg.sender] = 0;
471         MembershipCancel(msg.sender);
472     }
473     
474     function createAnnoTrade(bool _ifMedal, uint _medal, uint _token) public returns (uint) {
475         if(_ifMedal) {
476             require(medalBalances[msg.sender] >= _medal);
477             medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], _medal);
478             MemberToMedal[msg.sender] = _medal;
479             AnnoTrade memory anno = AnnoTrade({
480                seller: msg.sender,
481                ifMedal:_ifMedal,
482                medal: _medal,
483                token: _token
484             });
485             uint newMedalTradeId = annoTrades.push(anno) - 1;
486             AnnoTradeCreated(newMedalTradeId, _ifMedal, _medal, _token);
487             
488             return newMedalTradeId;
489         } else {
490             require(balances[msg.sender] >= _token);
491             balances[msg.sender] = safeSub(balances[msg.sender], _token);
492             MemberToToken[msg.sender] = _token;
493             AnnoTrade memory _anno = AnnoTrade({
494                seller: msg.sender,
495                ifMedal:_ifMedal,
496                medal: _medal,
497                token: _token
498             });
499             uint newTokenTradeId = annoTrades.push(_anno) - 1;
500             AnnoTradeCreated(newTokenTradeId, _ifMedal, _medal, _token);
501             
502             return newTokenTradeId;
503         }
504     }
505     
506     function cancelTrade(uint _tradeId) public {
507         AnnoTrade memory anno = annoTrades[_tradeId];
508         require(anno.seller == msg.sender);
509         if(anno.ifMedal){
510             medalBalances[msg.sender] = safeAdd(medalBalances[msg.sender], anno.medal);
511             MemberToMedal[msg.sender] = 0;
512         } else {
513             balances[msg.sender] = safeAdd(balances[msg.sender], anno.token);
514             MemberToToken[msg.sender] = 0;
515         }
516         delete annoTrades[_tradeId];
517         TradeCancel(_tradeId);
518     }
519     
520     function trade(uint _tradeId) public {
521         AnnoTrade memory anno = annoTrades[_tradeId];
522         if(anno.ifMedal){
523             medalBalances[msg.sender] = safeAdd(medalBalances[msg.sender], anno.medal);
524             MemberToMedal[anno.seller] = 0;
525             transfer(anno.seller, anno.token);
526             delete annoTrades[_tradeId];
527             TradeComplete(_tradeId, msg.sender, anno.seller, anno.medal, anno.token);
528         } else {
529             balances[msg.sender] = safeAdd(balances[msg.sender], anno.token);
530             MemberToToken[anno.seller] = 0;
531             medalTransfer(anno.seller, anno.medal);
532             delete annoTrades[_tradeId];
533             TradeComplete(_tradeId, msg.sender, anno.seller, anno.medal, anno.token);
534         }
535     }
536     
537     function mine() public {
538         uint level = MemberToLevel[msg.sender];
539         require(MemberToTime[msg.sender] < uint(now)); 
540         require(minePool >= salary[level]);
541         require(level > 0);
542         _mine(salary[level]);
543         minePool = safeSub(minePool, salary[level]);
544         MemberToTime[msg.sender] = safeAdd(MemberToTime[msg.sender], period);
545         Mine(msg.sender, salary[level]);
546     }
547     
548     function setSalary(uint one, uint two, uint three, uint four) public onlyOwner {
549         salary[1] = one;
550         salary[2] = two;
551         salary[3] = three;
552         salary[4] = four;
553     }
554     
555     function getTrade(uint _tradeId) public view returns (
556         address seller,
557         bool ifMedal,
558         uint medal,
559         uint token 
560     ) {
561         AnnoTrade memory _anno = annoTrades[_tradeId];
562         seller = _anno.seller;
563         ifMedal = _anno.ifMedal;
564         medal = _anno.medal;
565         token = _anno.token;
566     }
567     
568 }