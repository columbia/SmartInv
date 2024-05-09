1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event TransferSell(address indexed from, uint tokens, uint eth);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 //
47 // Borrowed from MiniMeToken
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59     address public newOwner;
60     
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     function Owned() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75         owner = newOwner;
76     }
77     // function acceptOwnership() public {
78     //     require(msg.sender == newOwner);
79     //     OwnershipTransferred(owner, newOwner);
80     //     owner = newOwner;
81     //     newOwner = address(0);
82     // }
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals
88 // Receives ETH and generates tokens
89 // ----------------------------------------------------------------------------
90 contract MyToken is ERC20Interface, Owned, SafeMath {
91     string public symbol;
92     string public name;
93     uint8 public decimals;
94     uint public totalSupply;
95     uint public sellRate;
96     uint public buyRate;
97     uint public startTime;
98     uint public endTime;
99     
100     address[] admins;
101     
102     struct lockPosition{
103         uint time;
104         uint count;
105         uint releaseRate;
106         uint lockTime;
107     }
108     
109     struct lockPosition1{
110         uint8 typ; // 1 2 3 4
111         uint count;
112         uint time1;
113         uint8 releaseRate1;
114         uint time2;
115         uint8 releaseRate2;
116         uint time3;
117         uint8 releaseRate3;
118         uint time4;
119         uint8 releaseRate4;
120     }
121     
122     
123     mapping(address => lockPosition) private lposition;
124     mapping(address => lockPosition1) public lposition1;
125     
126     // locked account dictionary that maps addresses to boolean
127     mapping (address => bool) public lockedAccounts;
128     mapping (address => bool) public isAdmin;
129 
130     mapping(address => uint) balances;
131     mapping(address => mapping(address => uint)) allowed;
132     
133     modifier is_not_locked(address _address) {
134         if (lockedAccounts[_address] == true) revert();
135         _;
136     }
137     
138     modifier validate_address(address _address) {
139         if (_address == address(0)) revert();
140         _;
141     }
142     
143     modifier is_admin {
144         if (isAdmin[msg.sender] != true && msg.sender != owner) revert();
145         _;
146     }
147     
148     modifier validate_position(address _address,uint count) {
149         if(count <= 0) revert();
150         if(balances[_address] < count) revert();
151         if(lposition[_address].count > 0 && safeSub(balances[_address],count) < lposition[_address].count && now < lposition[_address].time) revert();
152         if(lposition1[_address].count > 0 && safeSub(balances[_address],count) < lposition1[_address].count && now < lposition1[_address].time1) revert();
153         checkPosition1(_address,count);
154         checkPosition(_address,count);
155         _;
156     }
157     
158     function checkPosition(address _address,uint count) private view {
159         if(lposition[_address].releaseRate < 100 && lposition[_address].count > 0){
160             uint _rate = safeDiv(100,lposition[_address].releaseRate);
161             uint _time = lposition[_address].time;
162             uint _tmpRate = lposition[_address].releaseRate;
163             uint _tmpRateAll = 0;
164             uint _count = 0;
165             for(uint _a=1;_a<=_rate;_a++){
166                 if(now >= _time){
167                     _count = _a;
168                     _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);
169                     _time = safeAdd(_time,lposition[_address].lockTime);
170                 }
171             }
172             uint _tmp1 = safeSub(balances[_address],count);
173             uint _tmp2 = safeSub(lposition[_address].count,safeDiv(lposition[_address].count*_tmpRateAll,100));
174             if(_count < _rate && _tmp1 < _tmp2  && now >= lposition[_address].time) revert();
175         }
176     }
177     
178     function checkPosition1(address _address,uint count) private view {
179         if(lposition1[_address].releaseRate1 < 100 && lposition1[_address].count > 0){
180             uint _tmpRateAll = 0;
181             
182             if(lposition1[_address].typ == 2 && now < lposition1[_address].time2){
183                 if(now >= lposition1[_address].time1){
184                     _tmpRateAll = lposition1[_address].releaseRate1;
185                 }
186             }
187             
188             if(lposition1[_address].typ == 3 && now < lposition1[_address].time3){
189                 if(now >= lposition1[_address].time1){
190                     _tmpRateAll = lposition1[_address].releaseRate1;
191                 }
192                 if(now >= lposition1[_address].time2){
193                     _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
194                 }
195             }
196             
197             if(lposition1[_address].typ == 4 && now < lposition1[_address].time4){
198                 if(now >= lposition1[_address].time1){
199                     _tmpRateAll = lposition1[_address].releaseRate1;
200                 }
201                 if(now >= lposition1[_address].time2){
202                     _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
203                 }
204                 if(now >= lposition1[_address].time3){
205                     _tmpRateAll = safeAdd(lposition1[_address].releaseRate3,_tmpRateAll);
206                 }
207             }
208             
209             uint _tmp1 = safeSub(balances[_address],count);
210             uint _tmp2 = safeSub(lposition1[_address].count,safeDiv(lposition1[_address].count*_tmpRateAll,100));
211             
212             if(_tmpRateAll > 0){
213                 if(_tmp1 < _tmp2) revert();
214             }
215         }
216     }
217     
218     event _lockAccount(address _add);
219     event _unlockAccount(address _add);
220     
221     function () public payable{
222         uint tokens;
223         require(owner != msg.sender);
224         require(now >= startTime && now < endTime);
225         require(buyRate > 0);
226         require(msg.value >= 0.1 ether && msg.value <= 1000 ether);
227         
228         tokens = safeDiv(msg.value,(1 ether * 1 wei / buyRate));
229         require(balances[owner] >= tokens * 10**uint(decimals));
230         balances[msg.sender] = safeAdd(balances[msg.sender], tokens * 10**uint(decimals));
231         balances[owner] = safeSub(balances[owner], tokens * 10**uint(decimals));
232         Transfer(owner,msg.sender,tokens * 10**uint(decimals));
233     }
234 
235     // ------------------------------------------------------------------------
236     // Constructor
237     // ------------------------------------------------------------------------
238     function MyToken(uint _sellRate,uint _buyRate,string _symbo1,string _name,uint _startTime,uint _endTime) public payable {
239         require(_sellRate >0 && _buyRate > 0);
240         require(_startTime < _endTime);
241         symbol = _symbo1;
242         name = _name;
243         decimals = 8;
244         totalSupply = 2000000000 * 10**uint(decimals);
245         balances[owner] = totalSupply;
246         Transfer(address(0), owner, totalSupply);
247         sellRate = _sellRate;
248         buyRate = _buyRate;
249         endTime = _endTime;
250         startTime = _startTime;
251     }
252 
253 
254     // ------------------------------------------------------------------------
255     // Total supply
256     // ------------------------------------------------------------------------
257     function totalSupply() public constant returns (uint) {
258         return totalSupply  - balances[address(0)];
259     }
260 
261 
262     // ------------------------------------------------------------------------
263     // Get the token balance for account `tokenOwner`
264     // ------------------------------------------------------------------------
265     function balanceOf(address tokenOwner) public constant returns (uint balance) {
266         return balances[tokenOwner];
267     }
268 
269 
270     // ------------------------------------------------------------------------
271     // Transfer the balance from token owner's account to `to` account
272     // - Owner's account must have sufficient balance to transfer
273     // - 0 value transfers are allowed
274     // ------------------------------------------------------------------------
275     function transfer(address to, uint tokens) public is_not_locked(msg.sender) validate_position(msg.sender,tokens) returns (bool success) {
276         require(to != msg.sender);
277         require(tokens > 0);
278         require(balances[msg.sender] >= tokens);
279         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
280         balances[to] = safeAdd(balances[to], tokens);
281         Transfer(msg.sender, to, tokens);
282         return true;
283     }
284 
285 
286     // ------------------------------------------------------------------------
287     // Token owner can approve for `spender` to transferFrom(...) `tokens`
288     // from the token owner's account
289     //
290     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
291     // recommends that there are no checks for the approval double-spend attack
292     // as this should be implemented in user interfaces 
293     // ------------------------------------------------------------------------
294     function approve(address spender, uint tokens) public is_not_locked(msg.sender) is_not_locked(spender) validate_position(msg.sender,tokens) returns (bool success) {
295         require(spender != msg.sender);
296         require(tokens > 0);
297         require(balances[msg.sender] >= tokens);
298         allowed[msg.sender][spender] = tokens;
299         Approval(msg.sender, spender, tokens);
300         return true;
301     }
302 
303 
304     // ------------------------------------------------------------------------
305     // Transfer `tokens` from the `from` account to the `to` account
306     // 
307     // The calling account must already have sufficient tokens approve(...)-d
308     // for spending from the `from` account and
309     // - From account must have sufficient balance to transfer
310     // - Spender must have sufficient allowance to transfer
311     // - 0 value transfers are allowed
312     // ------------------------------------------------------------------------
313     function transferFrom(address from, address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(from) validate_position(from,tokens) returns (bool success) {
314         require(transferFromCheck(from,to,tokens));
315         return true;
316     }
317     
318     function transferFromCheck(address from,address to,uint tokens) private returns (bool success) {
319         require(tokens > 0);
320         require(from != msg.sender && msg.sender != to && from != to);
321         require(balances[from] >= tokens && allowed[from][msg.sender] >= tokens);
322         balances[from] = safeSub(balances[from], tokens);
323         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
324         balances[to] = safeAdd(balances[to], tokens);
325         Transfer(from, to, tokens);
326         return true;
327     }
328 
329 
330     // ------------------------------------------------------------------------
331     // Returns the amount of tokens approved by the owner that can be
332     // transferred to the spender's account
333     // ------------------------------------------------------------------------
334     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
335         return allowed[tokenOwner][spender];
336     }
337 
338 
339     // ------------------------------------------------------------------------
340     // Token owner can approve for `spender` to transferFrom(...) `tokens`
341     // from the token owner's account. The `spender` contract function
342     // `receiveApproval(...)` is then executed
343     // ------------------------------------------------------------------------
344     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
345         allowed[msg.sender][spender] = tokens;
346         Approval(msg.sender, spender, tokens);
347         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
348         return true;
349     }
350     
351 
352     // ------------------------------------------------------------------------
353     // Sall a token from a contract
354     // ------------------------------------------------------------------------
355     function sellCoin(address seller, uint amount) public onlyOwner is_not_locked(seller) validate_position(seller,amount* 10**uint(decimals)) {
356         require(balances[seller] >= safeMul(amount,10**uint(decimals)));
357         require(sellRate > 0);
358         require(seller != msg.sender);
359         uint tmpAmount = safeMul(amount,(1 ether * 1 wei / sellRate));
360         
361         balances[owner] = safeAdd(balances[owner],amount * 10**uint(decimals));
362         balances[seller] = safeSub(balances[seller],amount * 10**uint(decimals));
363         
364         seller.transfer(tmpAmount);
365         TransferSell(seller, amount * 10**uint(decimals), tmpAmount);
366     }
367     
368     // set rate
369     function setConfig(uint _buyRate,uint _sellRate,string _symbol,string _name,uint _startTime,uint _endTime) public onlyOwner {
370         require((_buyRate == 0 && _sellRate == 0) || (_buyRate < _sellRate && _buyRate > 0 && _sellRate > 0) || (_buyRate < sellRate && _buyRate > 0 && _sellRate == 0) || (buyRate < _sellRate && _buyRate == 0 && _sellRate > 0));
371         
372         if(_buyRate > 0){
373             buyRate = _buyRate;
374         }
375         if(sellRate > 0){
376             sellRate = _sellRate;
377         }
378         if(_startTime > 0){
379             startTime = _startTime;
380         }
381         if(_endTime > 0){
382             endTime = _endTime;
383         }
384         symbol = _symbol;
385         name = _name;
386     }
387     
388     // lockAccount
389     function lockStatus(address _add,bool _success) public validate_address(_add) is_admin {
390         lockedAccounts[_add] = _success;
391         _lockAccount(_add);
392     }
393     
394     // setIsAdmin
395     function setIsAdmin(address _add,bool _success) public validate_address(_add) onlyOwner {
396         isAdmin[_add] = _success;
397         if(_success == true){
398             admins[admins.length++] = _add;
399         }else{
400             for (uint256 i;i < admins.length;i++){
401                 if(admins[i] == _add){
402                     delete admins[i];
403                 }
404             }
405         }
406     }
407     
408     // ------------------------------------------------------------------------
409     // Owner can transfer out any accidentally sent ERC20 tokens
410     // ------------------------------------------------------------------------
411     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
412         return ERC20Interface(tokenAddress).transfer(owner, tokens);
413     }
414     
415     //set lock position
416     function setLockPostion(address _add,uint _count,uint _time,uint _releaseRate,uint _lockTime) public is_not_locked(_add) onlyOwner {
417         require(lposition1[_add].count == 0);
418         require(balances[_add] >= safeMul(_count,10**uint(decimals)));
419         require(_time > now);
420         require(_count > 0 && _lockTime > 0);
421         require(_releaseRate > 0 && _releaseRate < 100);
422         require(_releaseRate == 2 || _releaseRate == 4 || _releaseRate == 5 || _releaseRate == 10 || _releaseRate == 20 || _releaseRate == 25 || _releaseRate == 50);
423         lposition[_add].time = _time;
424         lposition[_add].count = _count * 10**uint(decimals);
425         lposition[_add].releaseRate = _releaseRate;
426         lposition[_add].lockTime = _lockTime;
427     }
428     
429     //get lockPosition info
430     function getLockPosition(address _add) public view returns(uint time,uint count,uint rate,uint scount,uint _lockTime) {
431         return (lposition[_add].time,lposition[_add].count,lposition[_add].releaseRate,positionScount(_add),lposition[_add].lockTime);
432     }
433     
434     function positionScount(address _add) private view returns (uint count){
435         uint _rate = safeDiv(100,lposition[_add].releaseRate);
436         uint _time = lposition[_add].time;
437         uint _tmpRate = lposition[_add].releaseRate;
438         uint _tmpRateAll = 0;
439         for(uint _a=1;_a<=_rate;_a++){
440             if(now >= _time){
441                 _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);
442                 _time = safeAdd(_time,lposition[_add].lockTime);
443             }
444         }
445         
446         return (lposition[_add].count - safeDiv(lposition[_add].count*_tmpRateAll,100));
447     }
448     
449     
450     //set lock position
451     function setLockPostion1(address _add,uint _count,uint8 _typ,uint _time1,uint8 _releaseRate1,uint _time2,uint8 _releaseRate2,uint _time3,uint8 _releaseRate3,uint _time4,uint8 _releaseRate4) public is_not_locked(_add) onlyOwner {
452         require(_count > 0);
453         require(_time1 > now);
454         require(_releaseRate1 > 0);
455         require(_typ >= 1 && _typ <= 4);
456         require(balances[_add] >= safeMul(_count,10**uint(decimals)));
457         require(safeAdd(safeAdd(_releaseRate1,_releaseRate2),safeAdd(_releaseRate3,_releaseRate4)) == 100);
458         require(lposition[_add].count == 0);
459         
460         if(_typ == 1){
461             require(_time2 == 0 && _releaseRate2 == 0 && _time3 == 0 && _releaseRate3 == 0 && _releaseRate4 == 0 && _time4 == 0);
462         }
463         if(_typ == 2){
464             require(_time2 > _time1 && _releaseRate2 > 0 && _time3 == 0 && _releaseRate3 == 0 && _releaseRate4 == 0 && _time4 == 0);
465         }
466         if(_typ == 3){
467             require(_time2 > _time1 && _releaseRate2 > 0 && _time3 > _time2 && _releaseRate3 > 0 && _releaseRate4 == 0 && _time4 == 0);
468         }
469         if(_typ == 4){
470             require(_time2 > _time1 && _releaseRate2 > 0 && _releaseRate3 > 0 && _time3 > _time2 && _time4 > _time3 && _releaseRate4 > 0);
471         }
472         lockPostion1Add(_typ,_add,_count,_time1,_releaseRate1,_time2,_releaseRate2,_time3,_releaseRate3,_time4,_releaseRate4);
473     }
474     
475     function lockPostion1Add(uint8 _typ,address _add,uint _count,uint _time1,uint8 _releaseRate1,uint _time2,uint8 _releaseRate2,uint _time3,uint8 _releaseRate3,uint _time4,uint8 _releaseRate4) private {
476         lposition1[_add].typ = _typ;
477         lposition1[_add].count = _count * 10**uint(decimals);
478         lposition1[_add].time1 = _time1;
479         lposition1[_add].releaseRate1 = _releaseRate1;
480         lposition1[_add].time2 = _time2;
481         lposition1[_add].releaseRate2 = _releaseRate2;
482         lposition1[_add].time3 = _time3;
483         lposition1[_add].releaseRate3 = _releaseRate3;
484         lposition1[_add].time4 = _time4;
485         lposition1[_add].releaseRate4 = _releaseRate4;
486     }
487     
488     //get lockPosition1 info
489     function getLockPosition1(address _add) public view returns(uint count,uint Scount,uint8 _typ,uint8 _rate1,uint8 _rate2,uint8 _rate3,uint8 _rate4) {
490         return (lposition1[_add].count,positionScount1(_add),lposition1[_add].typ,lposition1[_add].releaseRate1,lposition1[_add].releaseRate2,lposition1[_add].releaseRate3,lposition1[_add].releaseRate4);
491     }
492     
493     function positionScount1(address _address) private view returns (uint count){
494         uint _tmpRateAll = 0;
495         
496         if(lposition1[_address].typ == 2 && now < lposition1[_address].time2){
497             if(now >= lposition1[_address].time1){
498                 _tmpRateAll = lposition1[_address].releaseRate1;
499             }
500         }
501         
502         if(lposition1[_address].typ == 3 && now < lposition1[_address].time3){
503             if(now >= lposition1[_address].time1){
504                 _tmpRateAll = lposition1[_address].releaseRate1;
505             }
506             if(now >= lposition1[_address].time2){
507                 _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
508             }
509         }
510         
511         if(lposition1[_address].typ == 4 && now < lposition1[_address].time4){
512             if(now >= lposition1[_address].time1){
513                 _tmpRateAll = lposition1[_address].releaseRate1;
514             }
515             if(now >= lposition1[_address].time2){
516                 _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
517             }
518             if(now >= lposition1[_address].time3){
519                 _tmpRateAll = safeAdd(lposition1[_address].releaseRate3,_tmpRateAll);
520             }
521         }
522         
523         if((lposition1[_address].typ == 1 && now >= lposition1[_address].time1) || (lposition1[_address].typ == 2 && now >= lposition1[_address].time2) || (lposition1[_address].typ == 3 && now >= lposition1[_address].time3) || (lposition1[_address].typ == 4 && now >= lposition1[_address].time4)){
524             return 0;
525         }
526         
527         if(_tmpRateAll > 0){
528             return (safeSub(lposition1[_address].count,safeDiv(lposition1[_address].count*_tmpRateAll,100)));
529         }else{
530             return lposition1[_address].count;
531         }
532     }
533     
534     // batchTransfer
535     function batchTransfer(address[] _adds,uint256 _tokens) public is_admin returns(bool success) {
536         require(balances[msg.sender] >= safeMul(_adds.length,_tokens));
537         require(lposition[msg.sender].count == 0 && lposition1[msg.sender].count == 0);
538         
539         for (uint256 i = 0; i < _adds.length; i++) {
540             uint256 _tmpTokens = _tokens;
541             address _tmpAdds = _adds[i];
542             balances[msg.sender] = safeSub(balances[msg.sender], _tmpTokens);
543             balances[_tmpAdds] = safeAdd(balances[_tmpAdds], _tmpTokens);
544             Transfer(msg.sender,_tmpAdds,_tmpTokens);
545         }
546         
547         return true;
548     }
549 }