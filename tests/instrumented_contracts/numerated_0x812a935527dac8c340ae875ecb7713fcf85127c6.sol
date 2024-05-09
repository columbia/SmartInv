1 pragma solidity ^0.4.25;
2 // Original gameplay and contract by Spielley
3 // Spielley is not liable for any bugs or exploits the contract may contain
4 // This game is purely intended for fun purposes
5 
6 // Gameplay:
7 // Send in 0.1 eth to get a soldier in the field and 1 bullet
8 // Wait till you reach the waiting time needed to shoot
9 // Each time someone is killed divs are given to the survivors
10 // 2 ways to shoot: 
11 // semi random, available first (after 200 blocks)
12 // Chose target                 (after 800 blocks)
13 
14 // there is only a 1 time self kill prevention when semi is used
15 // if you send in multiple soldiers friendly kills are possible
16 // => use target instead
17 
18 // Social gameplay: Chat with people and Coordinate your shots 
19 // if you want to risk not getting shot by semi bullets first
20 
21 // you keep your bullets when you send in new soldiers
22 
23 // if your soldier dies your address is added to the back of the refund line
24 // to get back your initial eth
25 
26 // payout structure per 0.1 eth:
27 // 0.005 eth buy P3D
28 // 0.005 eth goes to the refund line
29 // 0.001 eth goes dev cut shared across SPASM(Spielleys profit share aloocation module)
30 // 0.001 eth goes to referal
31 // 0.088 eth is given to survivors upon kill
32 
33 // P3D divs: 
34 // 1% to SPASM
35 // 99% to refund line
36 
37 // SPASM: get a part of the dev fee payouts and funds Spielley to go fulltime dev
38 // https://etherscan.io/address/0xfaae60f2ce6491886c9f7c9356bd92f688ca66a1#writeContract
39 // => buyshares function , send in eth to get shares
40 
41 // P3D MN payouts for UI devs
42 // payout per 0.1 eth sent in the sendInSoldier function
43 
44 // **to prevent exploit spot 0 can be targeted by chosing nextFormation number**
45 
46 // ----------------------------------------------------------------------------
47 // Safe maths
48 // ----------------------------------------------------------------------------
49 library SafeMath {
50     function add(uint a, uint b) internal pure returns (uint c) {
51         c = a + b;
52         require(c >= a);
53     }
54     function sub(uint a, uint b) internal pure returns (uint c) {
55         require(b <= a);
56         c = a - b;
57     }
58     function mul(uint a, uint b) internal pure returns (uint c) {
59         c = a * b;
60         require(a == 0 || c / a == b);
61     }
62     function div(uint a, uint b) internal pure returns (uint c) {
63         require(b > 0);
64         c = a / b;
65     }
66 }
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     constructor() public {
78         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
79        
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 // Snip3d contract
98 contract Snip3D is  Owned {
99     using SafeMath for uint;
100     uint public _totalSupply;
101 
102     mapping(address => uint256)public  balances;// soldiers on field
103     mapping(address => uint256)public  bullets;// amount of bullets Owned
104     mapping(address => uint256)public  playerVault;// amount of bullets Owned
105     mapping(uint256 => address)public  formation;// the playing field
106     uint256 public nextFormation;// next spot in formation
107     mapping(address => uint256)public lastMove;//blocknumber lastMove
108     mapping(uint256 => address) public RefundWaitingLine;
109     uint256 public  NextInLine;//next person to be refunded
110     uint256 public  NextAtLineEnd;//next spot to add loser
111     uint256 public Refundpot;
112     uint256 public blocksBeforeSemiRandomShoot = 200;
113     uint256 public blocksBeforeTargetShoot = 800;
114     uint256 public NextInLineOld;
115     uint256 public lastToPayOld;
116     
117     // events
118     event death(address indexed player , uint256 indexed formation);
119     event semiShot(address indexed player);
120     event targetShot(address indexed player);
121     event newSoldiers(address indexed player , uint256 indexed amount, uint256 indexed formation);
122     //constructor
123     constructor()
124         public
125     {
126         NextInLineOld = old.NextInLine();
127         lastToPayOld = 2784;
128         
129     }
130     //mods
131     modifier isAlive()
132     {
133         require(balances[msg.sender] > 0);
134         _;
135     }
136     // divfunctions
137     // interface setup
138 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
139 SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
140 Snip3dInterface public old = Snip3dInterface(0x6D534b48835701312ebc904d4b37e54D4f7D039f);
141 // view functions
142 function harvestabledivs()
143         view
144         public
145         returns(uint256)
146     {
147         return (P3Dcontract_.myDividends(true))  ;
148     }
149     function nextonetogetpaid()
150         public
151         view
152         returns(address)
153     {
154         
155         return (RefundWaitingLine[NextInLine]);
156     }
157     function playervanity(address theplayer)
158         public
159         view
160         returns( string )
161     {
162         return (Vanity[theplayer]);
163     }
164     function blocksTillSemiShoot(address theplayer)
165         public
166         view
167         returns( uint256 )
168     {
169         uint256 number;
170         if(block.number - lastMove[theplayer] < blocksBeforeSemiRandomShoot)
171         {number = blocksBeforeSemiRandomShoot -(block.number - lastMove[theplayer]);}
172         return (number);
173     }
174     function blocksTillTargetShoot(address theplayer)
175         public
176         view
177         returns( uint256 )
178     {
179         uint256 number;
180         if(block.number - lastMove[theplayer] < blocksBeforeTargetShoot)
181         {number = blocksBeforeTargetShoot -(block.number - lastMove[theplayer]);}
182         return (number);
183     }
184 function amountofp3d() external view returns(uint256){
185     return ( P3Dcontract_.balanceOf(address(this)))  ;
186 }
187     //divsection
188 uint256 public pointMultiplier = 10e18;
189 struct Account {
190   uint balance;
191   uint lastDividendPoints;
192 }
193 mapping(address=>Account) accounts;
194 mapping(address => string) public Vanity;
195 uint public ethtotalSupply;
196 uint public totalDividendPoints;
197 uint public unclaimedDividends;
198 
199 function dividendsOwing(address account) public view returns(uint256) {
200   uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
201   return (balances[account] * newDividendPoints) / pointMultiplier;
202 }
203 modifier updateAccount(address account) {
204   uint256 owing = dividendsOwing(account);
205   if(owing > 0) {
206     unclaimedDividends = unclaimedDividends.sub(owing);
207     
208     playerVault[account] = playerVault[account].add(owing);
209   }
210   accounts[account].lastDividendPoints = totalDividendPoints;
211   _;
212 }
213 function () external payable{}
214 function fetchdivs(address toupdate) public updateAccount(toupdate){}
215 // Gamefunctions
216 function sendInSoldier(address masternode, uint256 amount) public updateAccount(msg.sender)  payable{
217     uint256 value = msg.value;
218     require(value >=  amount.mul(100 finney));// sending in sol costs 0.1 eth
219     address sender = msg.sender;
220     // add life
221     balances[sender]=  balances[sender].add(amount);
222     // update totalSupply
223     _totalSupply= _totalSupply.add(amount);
224     // add 2 bullet per soldier
225     bullets[sender] = bullets[sender].add(amount).add(amount);
226     // add to playing field
227     for(uint i=0; i< amount; i++)
228         {
229             uint256 spot = nextFormation.add(i);
230             formation[spot] = sender;
231         }
232     nextFormation += i;
233     // reset lastMove to prevent people from adding bullets and start shooting
234     lastMove[sender] = block.number;
235     // buy P3D
236     uint256 buyamount = amount.mul( 5 finney);
237     P3Dcontract_.buy.value(buyamount)(masternode);
238     // check excess of payed 
239      if(value > amount.mul(100 finney)){Refundpot += value.sub(amount.mul(100 finney)) ;}
240     // progress refundline
241     Refundpot += amount.mul(5 finney);
242     // send SPASM cut
243     uint256 spasmamount = amount.mul(2 finney);
244     SPASM_.disburse.value(spasmamount)();
245     emit newSoldiers(sender, amount, nextFormation);
246 
247 }
248 function sendInSoldierReferal(address masternode, address referal, uint256 amount) public updateAccount(msg.sender)  payable{
249     uint256 value = msg.value;
250     require(value >=  amount.mul(100 finney));// sending in sol costs 0.1 eth
251     address sender = msg.sender;
252    // add life
253     balances[sender]=  balances[sender].add(amount);
254     // update totalSupply
255     _totalSupply= _totalSupply.add(amount);
256     // add 2 bullet per soldier
257     bullets[sender] = bullets[sender].add(amount).add(amount);
258     // add to playing field
259     for(uint i=0; i< amount; i++)
260         {
261             uint256 spot = nextFormation.add(i);
262             formation[spot] = sender;
263         }
264     nextFormation += i;
265     // reset lastMove to prevent people from adding bullets and start shooting
266     lastMove[sender] = block.number;
267     // buy P3D
268     uint256 buyamount = amount.mul( 5 finney);
269     P3Dcontract_.buy.value(buyamount)(masternode);
270     // check excess of payed 
271      if(value > amount.mul(100 finney)){Refundpot += value.sub(amount.mul(100 finney)) ;}
272     // progress refundline
273     Refundpot += amount.mul(5 finney);
274     // send SPASM cut
275     uint256 spasmamount = amount.mul(1 finney);
276     SPASM_.disburse.value(spasmamount)();
277     // send referal cut
278     playerVault[referal] = playerVault[referal].add(amount.mul(1 finney));
279     emit newSoldiers(sender, amount, nextFormation);
280 
281 }
282 function shootSemiRandom() public isAlive() {
283     address sender = msg.sender;
284     require(block.number > lastMove[sender] + blocksBeforeSemiRandomShoot);
285     require(bullets[sender] > 0);
286     uint256 semiRNG = (block.number.sub(lastMove[sender])) % 200;
287     
288     uint256 shot = uint256 (blockhash(block.number.sub(semiRNG))) % nextFormation;
289     address killed = formation[shot];
290     // solo soldiers self kill prevention - shoots next in line instead
291     if(sender == killed)
292     {
293         shot = uint256 (blockhash(block.number.sub(semiRNG).add(1))) % nextFormation;
294         killed = formation[shot];
295     }
296     // update divs loser
297     fetchdivs(killed);
298     // remove life
299     balances[killed]--;
300     // update totalSupply
301     _totalSupply--;
302     // remove bullet 
303     bullets[sender]--;
304     // remove from playing field
305     uint256 lastEntry = nextFormation.sub(1);
306     formation[shot] = formation[lastEntry];
307     nextFormation--;
308     // reset lastMove to prevent people from adding bullets and start shooting
309     lastMove[sender] = block.number;
310     
311     
312     // add loser to refundline
313     fetchdivsRefund(killed);
314     balancesRefund[killed] += 0.1 ether;
315    
316     // disburse eth to survivors
317     uint256 amount = 88 finney;
318     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
319     unclaimedDividends = unclaimedDividends.add(amount);
320     emit semiShot(sender);
321     emit death(killed, shot);
322 
323 }
324 function shootTarget(uint256 target) public isAlive() {
325     address sender = msg.sender;
326     require(target <= nextFormation && target > 0);
327     require(block.number > lastMove[sender] + blocksBeforeTargetShoot);
328     require(bullets[sender] > 0);
329     if(target == nextFormation){target = 0;}
330     address killed = formation[target];
331     
332     // update divs loser
333     fetchdivs(killed);
334     
335     // remove life
336     balances[killed]--;
337     // update totalSupply
338     _totalSupply--;
339     // remove bullet 
340     bullets[sender]--;
341     // remove from playing field
342     uint256 lastEntry = nextFormation.sub(1);
343     formation[target] = formation[lastEntry];
344     nextFormation--;
345     // reset lastMove to prevent people from adding bullets and start shooting
346     lastMove[sender] = block.number;
347     
348     // add loser to refundline
349     fetchdivsRefund(killed);
350     balancesRefund[killed] += 0.1 ether;
351     // fetch contracts divs
352     
353     // disburse eth to survivors
354     uint256 amount = 88 finney;
355     
356     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
357     unclaimedDividends = unclaimedDividends.add(amount);
358     emit targetShot(sender);
359     emit death(killed, target);
360 }
361 function Payoutnextrefund ()public
362     {
363          
364         require(Refundpot > 0.00001 ether);
365         uint256 amount = Refundpot;
366     Refundpot = 0;
367     totalDividendPointsRefund = totalDividendPointsRefund.add(amount.mul(pointMultiplier).div(_totalSupplyRefund));
368     unclaimedDividendsRefund = unclaimedDividendsRefund.add(amount);
369     }
370 
371 function disburse() public  payable {
372     uint256 amount = msg.value;
373     uint256 base = amount.div(100);
374     uint256 amt2 = amount.sub(base);
375   totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));
376  unclaimedDividends = unclaimedDividends.add(amt2);
377  
378 }
379 function vaultToWallet(address toPay) public {
380         require(playerVault[toPay] > 0);
381         uint256 value = playerVault[toPay];
382         playerVault[toPay] = 0;
383         toPay.transfer(value);
384     }
385 function changevanity(string van) public payable{
386     require(msg.value >= 1  finney);
387     Vanity[msg.sender] = van;
388     Refundpot += msg.value;
389 }
390 function P3DDivstocontract() public{
391     uint256 divs = harvestabledivs();
392     require(divs > 0);
393  
394 P3Dcontract_.withdraw();
395     //1% to owner
396     uint256 base = divs.div(100);
397     uint256 amt2 = divs.sub(base);
398     SPASM_.disburse.value(base)();// to dev fee sharing contract
399    Refundpot = Refundpot.add(amt2);// add divs to refund line
400    
401 }
402 
403 // bugtest selfdestruct function - deactivate on live
404  function die () public onlyOwner {
405      selfdestruct(msg.sender);
406  }
407 // 2nd div setup for refunds
408 
409 // legacystarting refunds from old contract
410     function legacyStart(uint256 amountProgress) onlyOwner public{
411         uint256 nextUp = NextInLineOld;
412         for(uint i=0; i< amountProgress; i++)
413         {
414         address torefund = old.RefundWaitingLine(nextUp + i);
415         i++;
416         balancesRefund[torefund] = balancesRefund[torefund].add(0.1 ether);
417         }
418         NextInLineOld += i;
419         _totalSupplyRefund = _totalSupplyRefund.add(i.mul(0.1 ether));
420     }
421 
422 mapping(address => uint256) public balancesRefund;
423 uint256 public _totalSupplyRefund;
424 mapping(address=>Account) public accountsRefund;
425 uint public ethtotalSupplyRefund;
426 uint public totalDividendPointsRefund;
427 uint public unclaimedDividendsRefund;
428 
429 function dividendsOwingRefund(address account) public view returns(uint256) {
430   uint256 newDividendPointsRefund = totalDividendPointsRefund.sub(accountsRefund[account].lastDividendPoints);
431   return (balancesRefund[account] * newDividendPointsRefund) / pointMultiplier;
432 }
433 modifier updateAccountRefund(address account) {
434   uint256 owing = dividendsOwingRefund(account);
435   if(owing > balancesRefund[account]){balancesRefund[account] = owing;}
436   if(owing > 0 ) {
437     unclaimedDividendsRefund = unclaimedDividendsRefund.sub(owing);
438     
439     playerVault[account] = playerVault[account].add(owing);
440     balancesRefund[account] = balancesRefund[account].sub(owing);
441     _totalSupplyRefund = _totalSupplyRefund.sub(owing);
442   }
443   accountsRefund[account].lastDividendPoints = totalDividendPointsRefund;
444   _;
445 }
446 //function () external payable{}
447 function fetchdivsRefund(address toUpdate) public updateAccountRefund(toUpdate){}
448 
449 function disburseRefund() public  payable {
450     uint256 amount = msg.value;
451     
452   totalDividendPointsRefund = totalDividendPointsRefund.add(amount.mul(pointMultiplier).div(_totalSupplyRefund));
453   //ethtotalSupply = ethtotalSupply.add(amount);
454  unclaimedDividendsRefund = unclaimedDividendsRefund.add(amount);
455 }
456 
457     //fetch P3D divs
458     function DivsToRefundpot ()public
459     {
460         //allocate p3d dividends to contract 
461             uint256 dividends = P3Dcontract_.myDividends(true);
462             require(dividends > 0);
463             uint256 base = dividends.div(100);
464             P3Dcontract_.withdraw();
465             SPASM_.disburse.value(base.mul(5))();// to dev fee sharing contract SPASM
466             Refundpot = Refundpot.add(base.mul(95));
467     }
468     
469 }
470 interface HourglassInterface  {
471     function() payable external;
472     function buy(address _playerAddress) payable external returns(uint256);
473     function sell(uint256 _amountOfTokens) external;
474     function reinvest() external;
475     function withdraw() external;
476     function exit() external;
477     function myDividends(bool _includeReferralBonus) external view returns(uint256);
478     function dividendsOf(address _playerAddress) external view returns(uint256);
479     function balanceOf(address _playerAddress) external view returns(uint256);
480     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
481     function stakingRequirement() external view returns(uint256);
482 }
483 
484 interface Snip3dInterface {
485     function RefundWaitingLine(uint256 index) external view returns(address);
486     function NextInLine() external view returns(uint256);
487     function NextAtLineEnd() external view returns(uint256);
488 }
489 interface SPASMInterface  {
490     function() payable external;
491     function disburse() external  payable;
492 }