1 pragma solidity ^0.4.24;
2 // King of the Crypto Hill contract by Spielley
3 // P3D contract designed by TEAM JUST and here integrated for dividend payout purpose, not active in testnet version.
4 // See P3D proof of concept at : https://divgarden.dvx.me/
5 // Or look at it's code at: https://etherscan.io/address/0xdaa282aba7f4aa757fac94024dfb89f8654582d3#code
6 // any derivative of KOTCH is allowed if:
7 // - 1% additional on payouts happen to original KOTCH contract creator's eth account: 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220
8 // - contracts are not designed or used to scam people or mallpractices
9 // This game is intended for fun, Spielley is not liable for any bugs the contract may contain. 
10 // Don't play with crypto you can't afford to lose
11 
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68     address public owner;
69     address public newOwner;
70 
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72 
73     constructor() public {
74         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public onlyOwner {
83         newOwner = _newOwner;
84     }
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and a
96 // fixed supply
97 // ----------------------------------------------------------------------------
98 contract FixedSupplyToken is ERC20Interface, Owned {
99     using SafeMath for uint;
100 
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     constructor() public {
114         symbol = "DOTCH";
115         name = "Diamond Of The Crypto Hill";
116         decimals = 0;
117         _totalSupply = 10000000000;
118         balances[this] = _totalSupply;
119         emit Transfer(address(0),this, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public view returns (uint) {
127         return _totalSupply.sub(balances[address(0)]);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public view returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to `to` account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = balances[msg.sender].sub(tokens);
146         balances[to] = balances[to].add(tokens);
147         emit Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for `spender` to transferFrom(...) `tokens`
154     // from the token owner's account
155     //
156     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
157     // recommends that there are no checks for the approval double-spend attack
158     // as this should be implemented in user interfaces 
159     // ------------------------------------------------------------------------
160     function approve(address spender, uint tokens) public returns (bool success) {
161         allowed[msg.sender][spender] = tokens;
162         emit Approval(msg.sender, spender, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer `tokens` from the `from` account to the `to` account
169     // 
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the `from` account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
177         balances[from] = balances[from].sub(tokens);
178         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
179         balances[to] = balances[to].add(tokens);
180         emit Transfer(from, to, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Returns the amount of tokens approved by the owner that can be
187     // transferred to the spender's account
188     // ------------------------------------------------------------------------
189     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
190         return allowed[tokenOwner][spender];
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Token owner can approve for `spender` to transferFrom(...) `tokens`
196     // from the token owner's account. The `spender` contract function
197     // `receiveApproval(...)` is then executed
198     // ------------------------------------------------------------------------
199     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
200         allowed[msg.sender][spender] = tokens;
201         emit Approval(msg.sender, spender, tokens);
202         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
203         return true;
204     }
205 
206 
207 
208 
209 
210     // ------------------------------------------------------------------------
211     // Owner can transfer out any accidentally sent ERC20 tokens
212     // ------------------------------------------------------------------------
213     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
214         return ERC20Interface(tokenAddress).transfer(owner, tokens);
215     }
216 }
217 interface HourglassInterface  {
218     function() payable external;
219     function buy(address _playerAddress) payable external returns(uint256);
220     function sell(uint256 _amountOfTokens) external;
221     function reinvest() external;
222     function withdraw() external;
223     function exit() external;
224     function dividendsOf(address _playerAddress) external view returns(uint256);
225     function balanceOf(address _playerAddress) external view returns(uint256);
226     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
227     function stakingRequirement() external view returns(uint256);
228 }
229 contract Game is FixedSupplyToken {
230     
231 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);    
232 struct Village {
233     address owner;
234     uint defending;
235     uint lastcollect;
236     uint beginnerprotection;
237 }
238 struct Variables {
239     uint nextVillageId;
240     uint bpamount;
241     
242     uint totalsupplyGOTCH;
243     uint GOTCHatcontract;
244     uint previousethamount;
245     uint solsforhire;
246     uint solslastupdate;
247     uint soldierreplenishrate;
248     uint soldierprice;
249     uint lastblockpayout;
250     uint blocksbeforenewpay;
251     uint ATPO;
252     uint nextpayamount;
253     uint nextowneramount;
254     
255     
256 }
257 struct Ownables {
258     address hillowner;
259     uint soldiersdefendinghill; 
260     mapping(address => uint256) soldiers;
261     mapping(uint256 => Village) villages;
262     mapping(address => uint256)  GOTCH;
263     mapping(address => uint256)  redeemedvils;
264     bool ERCtradeactive;
265     uint roundlength;
266     
267 }
268 struct Marketoffer{
269     address placedby;
270     uint256 amountdotch;
271     uint256 wantsthisamtweiperdotch;
272 }
273 
274 event villtakeover(address from, address to, uint villageint);
275 event hilltakeover(address from, address to);
276 event battle(address attacker, uint pointsattacker,  address defender, uint pointsdefender);
277 event dotchsale( address seller,uint price,  address taker , uint256 amount);
278 uint256 public ethforp3dbuy;
279 uint256 public round;
280 uint256 public nextmarketoffer;
281 uint256 public nextroundlength = 10000000000000000000000;
282 uint256 public nextroundtotalsupplyGOTCH = 10000;
283 uint256 public nextroundGOTCHatcontract = 10000;
284 uint256 public nextroundsolsforhire = 100;
285 uint256 public nextroundsoldierreplenishrate = 50;
286 uint256 public nextroundblocksbeforenewpay = 250;
287 bool public divsforall;
288 bool public nextroundERCtradeactive = true;
289 mapping(uint256 => Variables) public roundvars;
290 mapping(uint256 => Ownables) public roundownables; 
291  mapping(address => uint256) public Redeemable;
292  mapping(uint256 => Marketoffer) public marketplace;
293 
294 function harvestabledivs()
295         view
296         public
297         returns(uint256)
298     {
299         return ( P3Dcontract_.dividendsOf(address(this)))  ;
300     }
301 
302 function villageinfo(uint256 lookup)
303         view
304         public
305         returns(address owner, uint256 soldiersdefending,uint256 lastcollect,uint256 beginnersprotection)
306     {
307         return ( roundownables[round].villages[lookup].owner,roundownables[round].villages[lookup].defending,roundownables[round].villages[lookup].lastcollect,roundownables[round].villages[lookup].beginnerprotection)  ;
308     }
309 function gotchinfo(address lookup)
310         view
311         public
312         returns(uint256 Gold)
313     {
314         return ( roundownables[round].GOTCH[lookup])  ;
315     }
316 function soldiersinfo(address lookup)
317         view
318         public
319         returns(uint256 soldiers)
320     {
321         return ( roundownables[round].soldiers[lookup])  ;
322     } 
323 function redeemablevilsinfo(address lookup)
324         view
325         public
326         returns(uint256 redeemedvils)
327     {
328         return ( roundownables[round].redeemedvils[lookup])  ;
329     }
330 function playerinfo(address lookup)
331         view
332         public
333         returns(uint256 redeemedvils,uint256 redeemablevils , uint256 soldiers, uint256 GOTCH)
334     {
335         return ( 
336             roundownables[round].redeemedvils[lookup],
337             Redeemable[lookup],
338             roundownables[round].soldiers[lookup],
339             roundownables[round].GOTCH[lookup]
340             )  ;
341     } 
342 uint256 private div;
343 uint256 private ethtosend; 
344  
345 function () external payable{} // needed to receive p3d divs
346 
347 constructor () public {
348     round++;
349     roundvars[round].totalsupplyGOTCH = 10000;
350        roundvars[round].GOTCHatcontract = 10000;
351        roundvars[round].solsforhire = 100;
352        roundvars[round].soldierreplenishrate = 50;
353        roundvars[round].solslastupdate = block.number;
354        updatesolbuyrate();
355        roundvars[round].lastblockpayout = block.number;
356        roundownables[round].hillowner = msg.sender;
357        roundvars[round].nextpayamount = 0;
358        roundvars[round].nextowneramount = 0;
359        roundvars[round].previousethamount = 0;
360        roundvars[round].blocksbeforenewpay = 250;
361        roundvars[round].bpamount = 30000;
362        roundownables[round].ERCtradeactive = true;
363        roundownables[round].roundlength = 10000000000000000000000;
364        divsforall = false;
365     }
366 function hillpayout() internal  {
367     require(block.number > roundvars[round].lastblockpayout.add(roundvars[round].blocksbeforenewpay));
368     // new payout method
369     roundvars[round].lastblockpayout = roundvars[round].lastblockpayout.add(roundvars[round].blocksbeforenewpay);
370     ethforp3dbuy = ethforp3dbuy.add((address(this).balance.sub(ethforp3dbuy)).div(100));
371     owner.transfer((address(this).balance.sub(ethforp3dbuy)).div(100));
372     roundvars[round].ATPO = roundvars[round].ATPO.add((address(this).balance.sub(ethforp3dbuy)).div(2));
373     roundownables[round].hillowner.transfer((address(this).balance.sub(ethforp3dbuy)).div(2));
374 
375 }
376 function attackhill(uint256 amtsoldiers) public payable returns(bool, uint){
377     require(msg.value >= 1 finney);
378     if(block.number > roundvars[round].lastblockpayout.add(roundvars[round].blocksbeforenewpay))
379     {
380     hillpayout();
381     }
382     
383     require(amtsoldiers <= roundownables[round].soldiers[msg.sender]);
384     require(amtsoldiers >= 1);
385     if(msg.sender == roundownables[round].hillowner)
386 {
387    roundownables[round].soldiersdefendinghill = roundownables[round].soldiersdefendinghill.add(amtsoldiers);
388     roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);
389     return (false, 0);
390 }
391 if(msg.sender != roundownables[round].hillowner)
392 {
393    if(roundownables[round].soldiersdefendinghill < amtsoldiers)
394     {
395         emit hilltakeover(roundownables[round].hillowner,msg.sender);
396         emit battle(msg.sender,roundownables[round].soldiersdefendinghill,roundownables[round].hillowner,roundownables[round].soldiersdefendinghill);
397         roundownables[round].hillowner = msg.sender;
398         roundownables[round].soldiersdefendinghill = amtsoldiers.sub(roundownables[round].soldiersdefendinghill);
399         roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);
400         return (true, roundownables[round].soldiersdefendinghill);
401     }
402     if(roundownables[round].soldiersdefendinghill >= amtsoldiers)
403     {
404         roundownables[round].soldiersdefendinghill = roundownables[round].soldiersdefendinghill.sub(amtsoldiers);
405         roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);
406         emit battle(msg.sender,amtsoldiers,roundownables[round].hillowner,amtsoldiers);
407         return (false, amtsoldiers);
408     }
409 }
410 
411 }
412 function supporthill(uint256 amtsoldiers) public payable {
413     require(msg.value >= 1 finney);
414     require(roundownables[round].hillowner == msg.sender);
415     require(amtsoldiers <= roundownables[round].soldiers[msg.sender]);
416     require(amtsoldiers >= 1);
417    roundownables[round].soldiersdefendinghill = roundownables[round].soldiersdefendinghill.add(amtsoldiers);
418    roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);  
419 }
420 
421 function changetradestatus(bool active) public onlyOwner  {
422    //move all eth from contract to owners address
423    roundownables[round].ERCtradeactive = active;
424    
425 }
426 function setdivsforall(bool active) public onlyOwner  {
427    //move all eth from contract to owners address
428    divsforall = active;
429    
430 }
431 function changebeginnerprotection(uint256 blockcount) public onlyOwner  {
432    roundvars[round].bpamount = blockcount;
433 }
434 function changesoldierreplenishrate(uint256 rate) public onlyOwner  {
435    roundvars[round].soldierreplenishrate = rate;
436 }
437 function updatesolsforhire() internal  {
438    roundvars[round].solsforhire = roundvars[round].solsforhire.add((block.number.sub(roundvars[round].solslastupdate)).mul(roundvars[round].nextVillageId).mul(roundvars[round].soldierreplenishrate));
439    roundvars[round].solslastupdate = block.number;
440 }
441 function updatesolbuyrate() internal  {
442 if(roundvars[round].solsforhire > roundvars[round].totalsupplyGOTCH)
443    {
444         roundvars[round].solsforhire = roundvars[round].totalsupplyGOTCH;
445    }
446    roundvars[round].soldierprice = roundvars[round].totalsupplyGOTCH.div(roundvars[round].solsforhire);
447    if(roundvars[round].soldierprice < 1)
448    {
449        roundvars[round].soldierprice = 1;
450    }
451 }
452 function buysoldiers(uint256 amount) public payable {
453     require(msg.value >= 1 finney);
454    updatesolsforhire();
455    updatesolbuyrate() ;
456    require(amount <= roundvars[round].solsforhire);
457    
458    roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].add(amount);
459    roundvars[round].solsforhire = roundvars[round].solsforhire.sub(amount);
460    roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].sub( amount.mul(roundvars[round].soldierprice));
461    roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.add(amount.mul(roundvars[round].soldierprice));
462    
463 }
464 // found new villgage 
465 function createvillage() public  payable  {
466     require(msg.value >= 10 finney);
467     if(block.number > roundvars[round].lastblockpayout.add(roundvars[round].blocksbeforenewpay))
468     {
469     hillpayout();
470     }
471     
472     roundownables[round].villages[roundvars[round].nextVillageId].owner = msg.sender;
473     
474    roundownables[round].villages[roundvars[round].nextVillageId].lastcollect = block.number;
475     roundownables[round].villages[roundvars[round].nextVillageId].beginnerprotection = block.number;
476     roundvars[round].nextVillageId ++;
477    
478     roundownables[round].villages[roundvars[round].nextVillageId].defending = roundvars[round].nextVillageId;
479     Redeemable[msg.sender]++;
480     roundownables[round].redeemedvils[msg.sender]++;
481 }
482 function batchcreatevillage(uint256 amt) public  payable  {
483     require(msg.value >= 10 finney * amt);
484     require(amt >= 1);
485     require(amt <= 40);
486     if(block.number > roundvars[round].lastblockpayout.add(roundvars[round].blocksbeforenewpay))
487     {
488     hillpayout();
489     }
490     for(uint i=0; i< amt; i++)
491         {
492     roundownables[round].villages[roundvars[round].nextVillageId].owner = msg.sender;
493    roundownables[round].villages[roundvars[round].nextVillageId].lastcollect = block.number;
494     roundownables[round].villages[roundvars[round].nextVillageId].beginnerprotection = block.number;
495     roundvars[round].nextVillageId ++;
496    
497     roundownables[round].villages[roundvars[round].nextVillageId].defending = roundvars[round].nextVillageId;
498         } 
499         Redeemable[msg.sender] = Redeemable[msg.sender].add(amt);
500         roundownables[round].redeemedvils[msg.sender] = roundownables[round].redeemedvils[msg.sender].add(amt);
501 }
502 function cheapredeemvillage() public  payable  {
503     require(msg.value >= 1 finney);
504     require(roundownables[round].redeemedvils[msg.sender] < Redeemable[msg.sender]);
505     roundownables[round].villages[roundvars[round].nextVillageId].owner = msg.sender;
506     roundownables[round].villages[roundvars[round].nextVillageId].lastcollect = block.number;
507     roundownables[round].villages[roundvars[round].nextVillageId].beginnerprotection = block.number;
508     roundvars[round].nextVillageId ++;
509     roundownables[round].villages[roundvars[round].nextVillageId].defending = roundvars[round].nextVillageId;
510     roundownables[round].redeemedvils[msg.sender]++;
511 }
512 function preregvills(address reg) public onlyOwner  {
513 
514     roundownables[round].villages[roundvars[round].nextVillageId].owner = reg;
515     roundownables[round].villages[roundvars[round].nextVillageId].lastcollect = block.number;
516     roundownables[round].villages[roundvars[round].nextVillageId].beginnerprotection = block.number;
517     roundvars[round].nextVillageId ++;
518     roundownables[round].villages[roundvars[round].nextVillageId].defending = roundvars[round].nextVillageId;
519 }
520 function attack(uint256 village, uint256 amtsoldiers) public payable returns(bool, uint){
521     require(msg.value >= 1 finney);
522     if(block.number > roundvars[round].lastblockpayout + roundvars[round].blocksbeforenewpay)
523     {
524     hillpayout();
525     }
526    
527     uint bpcheck = roundownables[round].villages[village].beginnerprotection.add(roundvars[round].bpamount);
528     require(block.number > bpcheck);
529     require(roundownables[round].villages[village].owner != 0);// prevent from attacking a non-created village to create a village
530     require(amtsoldiers <= roundownables[round].soldiers[msg.sender]);
531     require(amtsoldiers >= 1);
532     
533 if(msg.sender == roundownables[round].villages[village].owner)
534 {
535     roundownables[round].villages[village].defending = roundownables[round].villages[village].defending.add(amtsoldiers);
536     roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);
537     return (false, 0);
538 }
539 if(msg.sender != roundownables[round].villages[village].owner)
540 {
541    if(roundownables[round].villages[village].defending < amtsoldiers)
542     {
543         emit battle(msg.sender,roundownables[round].villages[village].defending,roundownables[round].villages[village].owner,roundownables[round].villages[village].defending);
544         emit villtakeover(roundownables[round].villages[village].owner,msg.sender,village);
545         roundownables[round].villages[village].owner = msg.sender;
546         roundownables[round].villages[village].defending = amtsoldiers.sub(roundownables[round].villages[village].defending);
547         roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);
548         collecttaxes(village);
549         return (true, roundownables[round].villages[village].defending);
550         
551     }
552     if(roundownables[round].villages[village].defending >= amtsoldiers)
553     {
554         emit battle(msg.sender,amtsoldiers,roundownables[round].villages[village].owner,amtsoldiers);
555         roundownables[round].villages[village].defending = roundownables[round].villages[village].defending.sub(amtsoldiers);
556         roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);
557         return (false, amtsoldiers);
558     }
559 }
560 
561 }
562 function support(uint256 village, uint256 amtsoldiers) public payable {
563     require(msg.value >= 1 finney);
564     require(roundownables[round].villages[village].owner == msg.sender);
565     require(roundownables[round].villages[village].owner != 0);// prevent from supporting a non-created village to create a village
566     require(amtsoldiers <= roundownables[round].soldiers[msg.sender]);
567     require(amtsoldiers >= 1);
568     roundownables[round].villages[village].defending = roundownables[round].villages[village].defending.add(amtsoldiers);
569     roundownables[round].soldiers[msg.sender] = roundownables[round].soldiers[msg.sender].sub(amtsoldiers);  
570 }
571 function renewbeginnerprotection(uint256 village) public payable {
572     require(msg.value >= (roundvars[round].nextVillageId.sub(village)).mul(1 finney) );//
573     roundownables[round].villages[village].beginnerprotection = block.number;
574    
575 }
576 function batchcollecttaxes(uint256 a, uint256 b , uint256 c , uint256 d , uint256 e , uint256 f , uint256 g, uint256 h, uint256 i, uint256 j) public payable {// payed transaction
577     // a
578    require(msg.value >= 10 finney);
579    require(roundownables[round].villages[a].owner == msg.sender);
580    require(roundownables[round].villages[b].owner == msg.sender);
581    require(roundownables[round].villages[c].owner == msg.sender);
582    require(roundownables[round].villages[d].owner == msg.sender);
583    require(roundownables[round].villages[e].owner == msg.sender);
584    require(roundownables[round].villages[f].owner == msg.sender);
585    require(roundownables[round].villages[g].owner == msg.sender);
586    require(roundownables[round].villages[h].owner == msg.sender);
587    require(roundownables[round].villages[i].owner == msg.sender);
588    require(roundownables[round].villages[j].owner == msg.sender);
589     require(block.number >  roundownables[round].villages[a].lastcollect);
590     require(block.number >  roundownables[round].villages[b].lastcollect);
591     require(block.number >  roundownables[round].villages[c].lastcollect);
592     require(block.number >  roundownables[round].villages[d].lastcollect);
593     require(block.number >  roundownables[round].villages[e].lastcollect);
594     require(block.number >  roundownables[round].villages[f].lastcollect);
595     require(block.number >  roundownables[round].villages[g].lastcollect);
596     require(block.number >  roundownables[round].villages[h].lastcollect);
597     require(block.number >  roundownables[round].villages[i].lastcollect);
598     require(block.number >  roundownables[round].villages[j].lastcollect);
599     
600     uint256 test = (block.number.sub(roundownables[round].villages[a].lastcollect)).mul((roundvars[round].nextVillageId.sub(a)));
601     if(roundvars[round].GOTCHatcontract < test ) 
602     {
603      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
604      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
605     }   
606    roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
607     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
608     
609     roundownables[round].villages[a].lastcollect = block.number;
610     //b
611    
612     test = (block.number.sub(roundownables[round].villages[b].lastcollect)).mul((roundvars[round].nextVillageId.sub(b)));
613     if(roundvars[round].GOTCHatcontract < test ) 
614     {
615      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
616      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
617     }   
618     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
619     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
620     
621     roundownables[round].villages[b].lastcollect = block.number;
622     //c
623    
624     test = (block.number.sub(roundownables[round].villages[c].lastcollect)).mul((roundvars[round].nextVillageId.sub(c)));
625     if(roundvars[round].GOTCHatcontract < test ) 
626     {
627      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
628      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
629     }   
630     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
631     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
632     
633     roundownables[round].villages[c].lastcollect = block.number;
634     //j
635     
636     test = (block.number.sub(roundownables[round].villages[j].lastcollect)).mul((roundvars[round].nextVillageId.sub(j)));
637     if(roundvars[round].GOTCHatcontract < test ) 
638     {
639      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
640      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
641     }   
642     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
643     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
644     
645     roundownables[round].villages[j].lastcollect = block.number;
646     //d
647     
648     test = (block.number.sub(roundownables[round].villages[d].lastcollect)).mul((roundvars[round].nextVillageId.sub(d)));
649     if(roundvars[round].GOTCHatcontract < test ) 
650     {
651      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
652      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
653     }   
654     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
655     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
656     
657     roundownables[round].villages[d].lastcollect = block.number;
658     //e
659    
660     test = (block.number.sub(roundownables[round].villages[e].lastcollect)).mul((roundvars[round].nextVillageId.sub(e)));
661     if(roundvars[round].GOTCHatcontract < test ) 
662     {
663      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
664      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
665     }   
666     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
667     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
668     
669     roundownables[round].villages[e].lastcollect = block.number;
670     //f
671     
672     test = (block.number.sub(roundownables[round].villages[f].lastcollect)).mul((roundvars[round].nextVillageId.sub(f)));
673     if(roundvars[round].GOTCHatcontract < test ) 
674     {
675      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
676      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
677     }   
678     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
679     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
680     
681     roundownables[round].villages[f].lastcollect = block.number;
682     //g
683    
684     test = (block.number.sub(roundownables[round].villages[g].lastcollect)).mul((roundvars[round].nextVillageId.sub(g)));
685     if(roundvars[round].GOTCHatcontract < test ) 
686     {
687      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
688      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
689     }   
690     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
691     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
692     
693     roundownables[round].villages[g].lastcollect = block.number;
694     //h
695     
696     test = (block.number.sub(roundownables[round].villages[h].lastcollect)).mul((roundvars[round].nextVillageId.sub(h)));
697     if(roundvars[round].GOTCHatcontract < test ) 
698     {
699      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
700      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
701     }   
702     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
703     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
704     
705     roundownables[round].villages[h].lastcollect = block.number;
706     //i
707     
708     test = (block.number.sub(roundownables[round].villages[i].lastcollect)).mul((roundvars[round].nextVillageId.sub(i)));
709     if(roundvars[round].GOTCHatcontract < test ) 
710     {
711      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
712      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
713     }   
714     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
715     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
716     
717     roundownables[round].villages[i].lastcollect = block.number;
718 
719         
720 }
721 function collecttaxes(uint256 village) public payable returns (uint){// payed transaction
722     // 
723    require(msg.value >= 1 finney);
724     if(block.number > roundvars[round].lastblockpayout.add(roundvars[round].blocksbeforenewpay))
725     {
726     hillpayout();
727     }
728     
729     require(roundownables[round].villages[village].owner == msg.sender);
730     require(block.number >  roundownables[round].villages[village].lastcollect);
731     uint256 test = (block.number.sub(roundownables[round].villages[village].lastcollect)).mul((roundvars[round].nextVillageId.sub(village)));
732     if(roundvars[round].GOTCHatcontract < test ) 
733     {
734      roundvars[round].GOTCHatcontract =  roundvars[round].GOTCHatcontract.add(test);
735      roundvars[round].totalsupplyGOTCH = roundvars[round].totalsupplyGOTCH.add(test);
736     }   
737     roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].add(test);
738     roundvars[round].GOTCHatcontract = roundvars[round].GOTCHatcontract.sub(test);
739     
740     roundownables[round].villages[village].lastcollect = block.number;
741     // if contract doesnt have the amount, create new
742     return test;
743 }
744 function sellDOTCH(uint amt) payable public {
745     require(msg.value >= 1 finney);
746     require(roundownables[round].ERCtradeactive == true);
747     require(roundownables[round].GOTCH[this]>= amt.mul(10000));
748     require(balances[msg.sender] >=  amt);
749     require(amt >= 1);
750     balances[this] = balances[this].add(amt);
751     balances[msg.sender] = balances[msg.sender].sub(amt);
752     emit Transfer(msg.sender,this, amt);
753     roundownables[round].GOTCH[this] =  roundownables[round].GOTCH[this].sub(amt.mul(10000));
754     roundownables[round].GOTCH[msg.sender] =  roundownables[round].GOTCH[msg.sender].add(amt.mul(10000));
755 }
756 function buyDOTCH(uint amt) payable public {
757     require(msg.value >= 1 finney);
758     require(roundownables[round].ERCtradeactive == true);
759     require(balances[this]>= amt);
760     require(roundownables[round].GOTCH[msg.sender] >= amt.mul(10000));
761     require(amt >= 1);
762     balances[this] = balances[this].sub(amt);
763     balances[msg.sender] = balances[msg.sender].add(amt);
764     emit Transfer(this,msg.sender, amt);
765    roundownables[round].GOTCH[msg.sender] = roundownables[round].GOTCH[msg.sender].sub(amt.mul(10000));
766   roundownables[round].GOTCH[this] = roundownables[round].GOTCH[this].add(amt.mul(10000));
767 }
768 //p3d 
769 
770 function buyp3d(uint256 amt) internal{
771 P3Dcontract_.buy.value(amt)(this);
772 }
773 function claimdivs() internal{
774 P3Dcontract_.withdraw();
775 }
776 event onHarvest(
777         address customerAddress,
778         uint256 amount
779     );
780 
781 function Divs() public payable{
782     
783     require(msg.sender == roundownables[round].hillowner);
784     claimdivs();
785     msg.sender.transfer(div);
786     emit onHarvest(msg.sender,div);
787 }
788 function Divsforall() public payable{
789     
790     require(divsforall = true);
791     require(msg.value >= 1 finney);
792     div = harvestabledivs();
793     require(div > 0);
794     claimdivs();
795     msg.sender.transfer(div);
796     emit onHarvest(msg.sender,div);
797 }
798 function Expand() public {
799     buyp3d(ethforp3dbuy);
800     ethforp3dbuy = 0;
801 }
802 
803 //marketplace functions
804 function placeoffer(uint256 dotchamount, uint256 askingpriceinwei) payable public{
805     require(dotchamount > 0);
806     require(askingpriceinwei > 0);
807     require(balances[msg.sender] >=  dotchamount);
808     require(msg.value >= 1 finney);
809     balances[msg.sender] = balances[msg.sender].sub(dotchamount);
810     balances[this] = balances[this].add(dotchamount);
811     emit Transfer(msg.sender,this, dotchamount);
812     marketplace[nextmarketoffer].placedby = msg.sender;
813      marketplace[nextmarketoffer].amountdotch = dotchamount;
814       marketplace[nextmarketoffer].wantsthisamtweiperdotch = askingpriceinwei;
815       nextmarketoffer++;
816 }
817 function adddotchtooffer(uint256 ordernumber , uint256 dotchamount) public
818 {
819     require(dotchamount > 0);
820     require(msg.sender == marketplace[ordernumber].placedby);
821     require(balances[msg.sender] >=  dotchamount);
822  
823     balances[msg.sender] = balances[msg.sender].sub(dotchamount);
824     balances[this] = balances[this].add(dotchamount);
825     emit Transfer(msg.sender,this, dotchamount);
826      marketplace[ordernumber].amountdotch = marketplace[ordernumber].amountdotch.add(dotchamount);
827 }
828 function removedotchtooffer(uint256 ordernumber , uint256 dotchamount) public
829 {
830     require(dotchamount > 0);
831     require(msg.sender == marketplace[ordernumber].placedby);
832     require(balances[this] >=  dotchamount);
833  
834     balances[msg.sender] = balances[msg.sender].add(dotchamount);
835     balances[this] = balances[this].sub(dotchamount);
836     emit Transfer(this,msg.sender, dotchamount);
837      marketplace[ordernumber].amountdotch = marketplace[ordernumber].amountdotch.sub(dotchamount);
838 }
839 function offerchangeprice(uint256 ordernumber ,uint256 price ) public
840 {
841     require(price > 0);
842     require(msg.sender == marketplace[ordernumber].placedby);
843      marketplace[ordernumber].wantsthisamtweiperdotch = price;
844 }
845 function takeoffer(uint256 ordernumber ,uint256 amtdotch ) public payable
846 {
847     require(msg.value >= marketplace[ordernumber].wantsthisamtweiperdotch.mul(amtdotch));
848     require(amtdotch > 0);
849     require(marketplace[ordernumber].amountdotch >= amtdotch);
850     require(msg.sender != marketplace[ordernumber].placedby);
851     require(balances[this] >=  amtdotch);
852      marketplace[ordernumber].amountdotch = marketplace[ordernumber].amountdotch.sub(amtdotch);
853      balances[msg.sender] = balances[msg.sender].add(amtdotch);
854     balances[this] = balances[this].sub(amtdotch);
855     emit Transfer(this,msg.sender, amtdotch);
856     emit dotchsale(marketplace[ordernumber].placedby,marketplace[ordernumber].wantsthisamtweiperdotch, msg.sender, amtdotch);
857     marketplace[ordernumber].placedby.transfer(marketplace[ordernumber].wantsthisamtweiperdotch.mul(amtdotch));
858 }
859 // new round function
860 function startnewround() public {
861     require(roundvars[round].ATPO > roundownables[round].roundlength);
862     round++;
863     roundvars[round].totalsupplyGOTCH = nextroundtotalsupplyGOTCH;
864        roundvars[round].GOTCHatcontract = nextroundtotalsupplyGOTCH;
865        roundvars[round].solsforhire = nextroundsolsforhire;
866        roundvars[round].soldierreplenishrate = nextroundsoldierreplenishrate;
867        roundvars[round].solslastupdate = block.number;
868        updatesolbuyrate();
869        roundvars[round].lastblockpayout = block.number;
870        roundownables[round].hillowner = msg.sender;
871        roundvars[round].nextpayamount = roundvars[round-1].nextpayamount;
872        roundvars[round].nextowneramount = roundvars[round-1].nextowneramount;
873        roundvars[round].previousethamount = roundvars[round-1].previousethamount;
874        roundvars[round].blocksbeforenewpay = nextroundblocksbeforenewpay;
875        roundownables[round].ERCtradeactive = nextroundERCtradeactive;
876        roundvars[round].bpamount = 30000;
877     
878 }
879 
880 }