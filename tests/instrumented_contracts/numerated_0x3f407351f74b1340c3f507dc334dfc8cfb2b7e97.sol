1 pragma solidity ^0.4.19;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal pure returns ( uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSub(uint256 x, uint256 y) internal pure returns ( uint256) {
12         assert(x >= y);
13         uint256 z = x - y;
14         return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal pure returns ( uint256) {
18         uint256 z = x * y;
19         assert((x == 0)||(z/x == y));
20         return z;
21     }
22 
23 }
24 
25 contract ERC20 {
26     function totalSupply() constant public returns ( uint supply);
27 
28     function balanceOf( address who ) constant public returns ( uint value);
29     function allowance( address owner, address spender ) constant public returns (uint _allowance);
30     function transfer( address to, uint value) public returns (bool ok);
31     function transferFrom( address from, address to, uint value) public returns (bool ok);
32     function approve( address spender, uint value ) public returns (bool ok);
33 
34     event Transfer( address indexed from, address indexed to, uint value);
35     event Approval( address indexed owner, address indexed spender, uint value);
36 }
37 
38 //implement 
39 contract StandardToken is SafeMath,ERC20 {
40     uint256     _totalSupply;
41     
42     function totalSupply() constant public returns ( uint256) {
43         return _totalSupply;
44     }
45 
46     function transfer(address dst, uint wad) public returns (bool) {
47         assert(balances[msg.sender] >= wad);
48         
49         balances[msg.sender] = safeSub(balances[msg.sender], wad);
50         balances[dst] = safeAdd(balances[dst], wad);
51         
52         Transfer(msg.sender, dst, wad);
53         
54         return true;
55     }
56     
57     function transferFrom(address src, address dst, uint wad) public returns (bool) {
58         assert(wad > 0 );
59         assert(balances[src] >= wad);
60         
61         balances[src] = safeSub(balances[src], wad);
62         balances[dst] = safeAdd(balances[dst], wad);
63         
64         Transfer(src, dst, wad);
65         
66         return true;
67     }
68 
69     function balanceOf(address _owner) constant public returns ( uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) public returns ( bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant public returns ( uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82     
83     function freezeOf(address _owner) constant public returns ( uint256 balance) {
84         return freezes[_owner];
85     }
86     
87 
88     mapping (address => uint256) balances;
89     mapping (address => uint256) freezes;
90     mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 contract DSAuth {
94     address public authority;
95     address public owner;
96 
97     function DSAuth() public {
98         owner = msg.sender;
99         authority = msg.sender;
100     }
101 
102     function setOwner(address owner_) Owner public
103     {
104         owner = owner_;
105     }
106 
107     modifier Auth {
108         assert(isAuthorized(msg.sender));
109         _;
110     }
111     
112     modifier Owner {
113         assert(msg.sender == owner);
114         _;
115     }
116 
117     function isAuthorized(address src) internal view returns ( bool) {
118         if (src == address(this)) {
119             return true;
120         } else if (src == authority) {
121             return true;
122         }
123         else if (src == owner) {
124             return true;
125         }
126         return false;
127     }
128 
129 }
130 
131 contract DRCToken is StandardToken,DSAuth {
132 
133     string public name = "Digit RedWine Coin";
134     uint8 public decimals = 18;
135     string public symbol = "DRC";
136     
137     /* This notifies clients about the amount frozen */
138     event Freeze(address indexed from, uint256 value);
139     
140     /* This notifies clients about the amount unfrozen */
141     event Unfreeze(address indexed from, uint256 value);
142     
143     /* This notifies clients about the amount burnt */
144     event Burn(address indexed from, uint256 value);
145 
146     function DRCToken() public {
147         
148     }
149 
150     function mint(uint256 wad) Owner public {
151         balances[msg.sender] = safeAdd(balances[msg.sender], wad);
152         _totalSupply = safeAdd(_totalSupply, wad);
153     }
154 
155     function burn(uint256 wad) Owner public {
156         balances[msg.sender] = safeSub(balances[msg.sender], wad);
157         _totalSupply = safeSub(_totalSupply, wad);
158         Burn(msg.sender, wad);
159     }
160 
161     function push(address dst, uint256 wad) public returns ( bool) {
162         return transfer(dst, wad);
163     }
164 
165     function pull(address src, uint256 wad) public returns ( bool) {
166         return transferFrom(src, msg.sender, wad);
167     }
168 
169     function transfer(address dst, uint wad) public returns (bool) {
170         return super.transfer(dst, wad);
171     }
172     
173     function freeze(address dst,uint256 _value) Auth public returns (bool success) {
174         assert(balances[dst] >= _value); // Check if the sender has enough
175         assert(_value > 0) ; 
176         balances[dst] = SafeMath.safeSub(balances[dst], _value);                      // Subtract from the sender
177         freezes[dst] = SafeMath.safeAdd(freezes[dst], _value);                                // Updates totalSupply
178         Freeze(dst, _value);
179         return true;
180     }
181     
182     function unfreeze(address dst,uint256 _value) Auth public returns (bool success) {
183         assert(freezes[dst] >= _value);            // Check if the sender has enough
184         assert(_value > 0) ; 
185         freezes[dst] = SafeMath.safeSub(freezes[dst], _value);                      // Subtract from the sender
186         balances[dst] = SafeMath.safeAdd(balances[dst], _value);
187         Unfreeze(dst, _value);
188         return true;
189     }
190 }
191 
192 contract DRCCrowSale is SafeMath,DSAuth {
193     DRCToken public DRC;
194 
195     // Constants
196     uint256 public constant tokensPerEth = 10000;// DRC per ETH 
197     uint256 public presalePerEth;// DRC per ETH 
198     
199     uint256 public constant totalSupply = 1 * 1e9 * 1e18; // Total DRC amount created
200 
201     uint256 public tokensForTeam     = totalSupply * 15 / 100;
202     uint256 public tokensForParnter  = totalSupply * 15 / 100;
203     uint256 public tokensForPlatform = totalSupply * 45 / 100;
204 
205     uint256 public tokensForPresale1 = totalSupply * 5 / 100;
206     uint256 public tokensForPresale2 = totalSupply * 10 / 100;
207     uint256 public tokensForSale     = totalSupply * 10 / 100;
208     
209     address public team;
210     address public parnter;
211     address public platform;
212     address public presale1;
213     
214     uint256 public Presale1Sold = 0;
215     uint256 public Presale2Sold = 0;
216     uint256 public PublicSold = 0;
217 
218     enum IcoState {Init,Presale1, Presale2, Running, Paused, Finished}
219     IcoState public icoState = IcoState.Init;
220     IcoState public preIcoState = IcoState.Init;
221     
222     function setPresalePerEth(uint256 discount) external Auth{
223         presalePerEth = discount;
224     }
225 
226     function startPreSale1() external Auth {
227         require(icoState == IcoState.Init);
228         icoState = IcoState.Presale1;
229     }
230 
231     function startPreSale2() external Auth {
232         require(icoState == IcoState.Presale1);
233         icoState = IcoState.Presale2;
234     }
235 
236     function startIco() external Auth {
237         require(icoState == IcoState.Presale2);
238         icoState = IcoState.Running;
239     }
240 
241     function pauseIco() external Auth {
242         require(icoState != IcoState.Paused);
243         preIcoState = icoState ;
244         icoState = IcoState.Paused;
245     }
246 
247     function continueIco() external Auth {
248         require(icoState == IcoState.Paused);
249         icoState = preIcoState;
250     }
251     
252     uint public finishTime = 0;
253     function finishIco() external Auth {
254         require(icoState == IcoState.Running);
255         icoState = IcoState.Finished;
256         finishTime = block.timestamp;
257     }
258     
259     uint public unfreezeStartTime = 0;
260     function setUnfreezeStartTime(uint timestamp) external Auth{
261         unfreezeStartTime = timestamp;
262     }
263     
264     mapping (uint => mapping (address => bool))  public  unfroze;
265     mapping (address => uint256)                 public  userBuys;
266     mapping (uint => bool)  public  burned;
267     
268     // anyone can burn
269     function burn(IcoState state) external Auth{
270         uint256 burnAmount = 0;
271         //only burn once
272         assert(burned[uint(state)] == false);
273         if(state == IcoState.Presale1 && (icoState == IcoState.Presale2 || icoState == IcoState.Finished)){
274             assert(Presale1Sold < tokensForPresale1);
275             burnAmount = safeSub(tokensForPresale1,Presale1Sold);
276         } 
277         else if(state == IcoState.Presale2 && icoState == IcoState.Finished){ 
278             assert(Presale2Sold < tokensForPresale2);
279             burnAmount = safeSub(tokensForPresale2,Presale2Sold);
280         } 
281         else if(state == IcoState.Finished && icoState == IcoState.Finished){
282             assert(PublicSold < tokensForSale);
283             burnAmount = safeSub(tokensForSale,PublicSold);
284         } 
285         else {
286             throw;
287         }
288 
289         DRC.burn(burnAmount);
290         burned[uint(state)] = true;
291     }
292         
293     function presaleUnfreeze(uint step) external{
294         
295         assert(unfroze[step][msg.sender] == false);
296         assert(DRC.freezeOf(msg.sender) > 0 );
297         assert(unfreezeStartTime > 0);
298         assert(msg.sender != platform);
299         
300         uint256 freeze  = DRC.freezeOf(msg.sender);
301         uint256 unfreezeAmount = 0;
302 
303         if(step == 1){
304             require( block.timestamp > (unfreezeStartTime + 30 days));
305             unfreezeAmount = freeze / 3;
306         }
307         else if(step == 2){
308             require( block.timestamp > (unfreezeStartTime + 60 days));
309             unfreezeAmount = freeze / 2;
310         }
311         else if(step == 3){
312             require( block.timestamp > (unfreezeStartTime + 90 days));
313             unfreezeAmount = freeze;
314         }
315         else{
316             throw ;
317         }
318         
319         require(unfreezeAmount > 0 );
320         
321         DRC.unfreeze(msg.sender,unfreezeAmount);
322         unfroze[step][msg.sender] = true;
323     }
324     
325     //team unfreeze
326     function teamUnfreeze() external{
327         uint month = 6;
328         
329         assert(DRC.freezeOf(msg.sender) > 0 );
330         assert(finishTime > 0);
331         assert(msg.sender == team);
332         uint step = safeSub(block.timestamp, finishTime) / (3600*24*30);
333         
334         uint256 freeze  = DRC.freezeOf(msg.sender);
335         uint256 unfreezeAmount = 0;
336         
337         uint256 per = tokensForTeam / month;
338         
339         for(uint i = 0 ;i <= step && i < month;i++){
340             if(unfroze[i][msg.sender] == false){
341                 unfreezeAmount += per;
342             }
343         }
344         
345         require(unfreezeAmount > 0 );
346         require(unfreezeAmount <= freeze);
347 
348         DRC.unfreeze(msg.sender,unfreezeAmount);
349         for(uint j = 0; j <= step && i < month; j++){
350             unfroze[j][msg.sender] = true;
351         }
352     }
353     
354     //platform unfreeze
355      function platformUnfreeze() external{
356         uint month = 12;
357         
358         assert(DRC.freezeOf(msg.sender) > 0 );
359         assert(finishTime > 0);
360         assert(msg.sender == platform);
361         uint step = safeSub(block.timestamp, finishTime) / (3600*24*30);
362         
363         uint256 freeze  = DRC.freezeOf(msg.sender);
364         uint256 unfreezeAmount = 0;
365         
366         uint256 per = tokensForPlatform / month;
367         
368         for(uint i = 0 ;i <= step && i < month;i++){
369             if(unfroze[i][msg.sender] == false){
370                 unfreezeAmount += per;
371             }
372         }
373         
374         require(unfreezeAmount > 0 );
375         require(unfreezeAmount <= freeze);
376 
377         DRC.unfreeze(msg.sender,unfreezeAmount);
378         for(uint j = 0; j <= step && i < month; j++){
379             unfroze[j][msg.sender] = true;
380         }
381     }
382     
383     // Constructor
384     function DRCCrowSale() public {
385 
386     }
387 
388     function initialize(DRCToken drc,address _team,address _parnter,address _platform,address _presale1) Auth public {
389         assert(address(DRC) == address(0));
390         assert(drc.owner() == address(this));
391         assert(drc.totalSupply() == 0);
392         assert(_team != _parnter && _parnter != _platform && _team != _platform);
393         
394         team =_team;
395         parnter=_parnter;
396         platform=_platform;
397         presale1 = _presale1;
398 
399         DRC = drc;
400         DRC.mint(totalSupply);
401         
402         // transfer to team partner platform 
403         DRC.push(team, tokensForTeam);
404         DRC.freeze(team,tokensForTeam);
405         
406         DRC.push(parnter, tokensForParnter);
407         
408         // freeze
409         DRC.push(platform, tokensForPlatform);
410         DRC.freeze(platform,tokensForPlatform);
411         
412         DRC.push(presale1, tokensForPresale1);
413         
414     }
415 
416     function() payable public {
417         buy();
418     }
419 
420     function buy()  payable public{
421         require( (icoState == IcoState.Running)  ||
422                  (icoState == IcoState.Presale1) || 
423                  (icoState == IcoState.Presale2) );
424         // require          
425         if((icoState == IcoState.Presale1) || (icoState == IcoState.Presale2)){
426             require(msg.value >= 10 ether);
427         } 
428         else {
429             require(msg.value >= 0.01 ether);
430             //limit peer user less than 10 eth
431             require(userBuys[msg.sender] + msg.value <= 10 ether);
432         }
433  
434 
435         uint256 amount = getDRCTotal(msg.value);
436         uint256 sold = 0;
437         uint256 canbuy = 0;
438         (sold,canbuy) = getSold();
439 
440         // refund eth for last buy
441         if (sold + amount > canbuy){
442             uint256 delta = sold + amount - canbuy;
443             uint256 refundMoney = msg.value * delta / amount;
444             amount = canbuy-sold;
445             require(refundMoney > 0);
446             msg.sender.transfer(refundMoney);
447         }
448         
449         require(amount > 0);
450     
451         DRC.push(msg.sender, amount);
452         
453         //presale auto freeze
454         if((icoState == IcoState.Presale1)  || (icoState == IcoState.Presale2)){
455             DRC.freeze(msg.sender,amount);
456         }
457         else{
458             //for limit amount peer user 
459             userBuys[msg.sender] += amount;
460         }
461         
462        addSold(amount);
463     }
464     
465     function getSold() private view returns ( uint256,uint256){
466         if(icoState == IcoState.Presale1){
467             return(Presale1Sold,tokensForPresale1);
468         } 
469         else if(icoState == IcoState.Presale2){
470             return(Presale2Sold,tokensForPresale2);
471         } 
472         else if(icoState == IcoState.Running){
473             return(PublicSold,tokensForSale);
474         }else{
475             throw;
476         }
477     }
478 
479     function addSold(uint256 amount) private{
480         if(icoState == IcoState.Presale1){
481             Presale1Sold += amount;
482         } 
483         else if(icoState == IcoState.Presale2){
484             Presale2Sold += amount;
485         } 
486         else if(icoState == IcoState.Running){
487             PublicSold += amount;
488         }
489         else{
490             throw;
491         }
492     }
493     
494     //discount
495     function getDRCTotal(uint256 _eth) public view returns ( uint256)
496     {
497         if(icoState == IcoState.Presale1)
498         {
499             return safeMult(_eth , presalePerEth);
500         }
501         else if(icoState == IcoState.Presale2)
502         {
503            return safeMult(_eth , presalePerEth);
504         }
505 
506         return safeMult(_eth , tokensPerEth);
507     }
508 
509     function finalize() external Owner payable {
510         require(this.balance > 0 );
511 
512         require(owner.send(this.balance));
513     }
514 
515 }