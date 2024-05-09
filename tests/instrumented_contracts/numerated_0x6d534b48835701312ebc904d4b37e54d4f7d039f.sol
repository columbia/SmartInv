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
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 // Snip3d contract
97 contract Snip3D is  Owned {
98     using SafeMath for uint;
99     uint public _totalSupply;
100 
101     mapping(address => uint256)public  balances;// soldiers on field
102     mapping(address => uint256)public  bullets;// amount of bullets Owned
103     mapping(uint256 => address)public  formation;// the playing field
104     uint256 public nextFormation;// next spot in formation
105     mapping(address => uint256)public lastMove;//blocknumber lastMove
106     mapping(uint256 => address) public RefundWaitingLine;
107     uint256 public  NextInLine;//next person to be refunded
108     uint256 public  NextAtLineEnd;//next spot to add loser
109     uint256 public Refundpot;
110     uint256 public blocksBeforeSemiRandomShoot = 200;
111     uint256 public blocksBeforeTargetShoot = 800;
112     
113     // events
114     event death(address indexed player);
115     event semiShot(address indexed player);
116     event targetShot(address indexed player);
117     
118     //constructor
119     constructor()
120         public
121     {
122         
123         
124     }
125     //mods
126     modifier isAlive()
127     {
128         require(balances[msg.sender] > 0);
129         _;
130     }
131     // divfunctions
132 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
133 SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
134 // view functions
135 function harvestabledivs()
136         view
137         public
138         returns(uint256)
139     {
140         return ( P3Dcontract_.dividendsOf(address(this)))  ;
141     }
142     function nextonetogetpaid()
143         public
144         view
145         returns(address)
146     {
147         
148         return (RefundWaitingLine[NextInLine]);
149     }
150     function playervanity(address theplayer)
151         public
152         view
153         returns( string )
154     {
155         return (Vanity[theplayer]);
156     }
157     function blocksTillSemiShoot(address theplayer)
158         public
159         view
160         returns( uint256 )
161     {
162         uint256 number;
163         if(block.number - lastMove[theplayer] < blocksBeforeSemiRandomShoot)
164         {number = blocksBeforeSemiRandomShoot -(block.number - lastMove[theplayer]);}
165         return (number);
166     }
167     function blocksTillTargetShoot(address theplayer)
168         public
169         view
170         returns( uint256 )
171     {
172         uint256 number;
173         if(block.number - lastMove[theplayer] < blocksBeforeTargetShoot)
174         {number = blocksBeforeTargetShoot -(block.number - lastMove[theplayer]);}
175         return (number);
176     }
177 function amountofp3d() external view returns(uint256){
178     return ( P3Dcontract_.balanceOf(address(this)))  ;
179 }
180     //divsection
181 uint256 public pointMultiplier = 10e18;
182 struct Account {
183   uint balance;
184   uint lastDividendPoints;
185 }
186 mapping(address=>Account) accounts;
187 mapping(address => string) public Vanity;
188 uint public ethtotalSupply;
189 uint public totalDividendPoints;
190 uint public unclaimedDividends;
191 
192 function dividendsOwing(address account) public view returns(uint256) {
193   uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
194   return (balances[account] * newDividendPoints) / pointMultiplier;
195 }
196 modifier updateAccount(address account) {
197   uint256 owing = dividendsOwing(account);
198   if(owing > 0) {
199     unclaimedDividends = unclaimedDividends.sub(owing);
200     
201     account.transfer(owing);
202   }
203   accounts[account].lastDividendPoints = totalDividendPoints;
204   _;
205 }
206 function () external payable{}
207 function fetchdivs(address toupdate) public updateAccount(toupdate){}
208 // Gamefunctions
209 function sendInSoldier(address masternode) public updateAccount(msg.sender)  payable{
210     uint256 value = msg.value;
211     require(value >= 100 finney);// sending in sol costs 0.1 eth
212     address sender = msg.sender;
213     // add life
214     balances[sender]++;
215     // update totalSupply
216     _totalSupply++;
217     // add bullet 
218     bullets[sender]++;
219     // add to playing field
220     formation[nextFormation] = sender;
221     nextFormation++;
222     // reset lastMove to prevent people from adding bullets and start shooting
223     lastMove[sender] = block.number;
224     // buy P3D
225     P3Dcontract_.buy.value(5 finney)(masternode);
226     // check excess of payed 
227      if(value > 100 finney){Refundpot += value - 100 finney;}
228     // progress refundline
229     Refundpot += 5 finney;
230     // send SPASM cut
231     SPASM_.disburse.value(2 finney)();
232 
233 }
234 function sendInSoldierReferal(address masternode, address referal) public updateAccount(msg.sender)  payable{
235     uint256 value = msg.value;
236     require(value >= 100 finney);// sending in sol costs 0.1 eth
237     address sender = msg.sender;
238     // add life
239     balances[sender]++;
240     // update totalSupply
241     _totalSupply++;
242     // add bullet 
243     bullets[sender]++;
244     // add to playing field
245     formation[nextFormation] = sender;
246     nextFormation++;
247     // reset lastMove to prevent people from adding bullets and start shooting
248     lastMove[sender] = block.number;
249     // buy P3D
250     P3Dcontract_.buy.value(5 finney)(masternode);
251     // check excess of payed 
252     if(value > 100 finney){Refundpot += value - 100 finney;}
253     // progress refundline
254     Refundpot += 5 finney;
255     // send SPASM cut
256     SPASM_.disburse.value(1 finney)();
257     // send referal cut
258     referal.transfer(1 finney);
259 
260 }
261 function shootSemiRandom() public isAlive() {
262     address sender = msg.sender;
263     require(block.number > lastMove[sender] + blocksBeforeSemiRandomShoot);
264     require(bullets[sender] > 0);
265     uint256 semiRNG = (block.number.sub(lastMove[sender])) % 200;
266     
267     uint256 shot = uint256 (blockhash(block.number.sub(semiRNG))) % nextFormation;
268     address killed = formation[shot];
269     // solo soldiers self kill prevention - shoots next in line instead
270     if(sender == killed)
271     {
272         shot = uint256 (blockhash(block.number.sub(semiRNG).add(1))) % nextFormation;
273         killed = formation[shot];
274     }
275     // update divs loser
276     fetchdivs(killed);
277     // remove life
278     balances[killed]--;
279     // update totalSupply
280     _totalSupply--;
281     // remove bullet 
282     bullets[sender]--;
283     // remove from playing field
284     uint256 lastEntry = nextFormation.sub(1);
285     formation[shot] = formation[lastEntry];
286     nextFormation--;
287     // reset lastMove to prevent people from adding bullets and start shooting
288     lastMove[sender] = block.number;
289     
290     
291     // add loser to refundline
292     RefundWaitingLine[NextAtLineEnd] = killed;
293     NextAtLineEnd++;
294     // disburse eth to survivors
295     uint256 amount = 88 finney;
296     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
297     unclaimedDividends = unclaimedDividends.add(amount);
298     emit semiShot(sender);
299     emit death(killed);
300 
301 }
302 function shootTarget(uint256 target) public isAlive() {
303     address sender = msg.sender;
304     require(target <= nextFormation && target > 0);
305     require(block.number > lastMove[sender] + blocksBeforeTargetShoot);
306     require(bullets[sender] > 0);
307     if(target == nextFormation){target = 0;}
308     address killed = formation[target];
309     
310     // update divs loser
311     fetchdivs(killed);
312     
313     // remove life
314     balances[killed]--;
315     // update totalSupply
316     _totalSupply--;
317     // remove bullet 
318     bullets[sender]--;
319     // remove from playing field
320     uint256 lastEntry = nextFormation.sub(1);
321     formation[target] = formation[lastEntry];
322     nextFormation--;
323     // reset lastMove to prevent people from adding bullets and start shooting
324     lastMove[sender] = block.number;
325     
326     // add loser to refundline
327     RefundWaitingLine[NextAtLineEnd] = killed;
328     NextAtLineEnd++;
329     // fetch contracts divs
330     //allocate p3d dividends to contract 
331             uint256 dividends =  harvestabledivs();
332             require(dividends > 0);
333             uint256 base = dividends.div(100);
334             P3Dcontract_.withdraw();
335             SPASM_.disburse.value(base)();// to dev fee sharing contract SPASM
336     // disburse eth to survivors
337     uint256 amount = 88 finney;
338     uint256 amt2 = dividends.sub(base);
339     Refundpot = Refundpot.add(amt2);
340     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
341     unclaimedDividends = unclaimedDividends.add(amount);
342     emit targetShot(sender);
343     emit death(killed);
344 }
345 
346 function Payoutnextrefund ()public
347     {
348         //allocate p3d dividends to sacrifice if existing
349             uint256 Pot = Refundpot;
350             require(Pot > 0.1 ether);
351             Refundpot -= 0.1 ether;
352             RefundWaitingLine[NextInLine].transfer(0.1 ether);
353             NextInLine++;
354             //
355     }
356 
357 function disburse() public  payable {
358     uint256 amount = msg.value;
359     uint256 base = amount.div(100);
360     uint256 amt2 = amount.sub(base);
361   totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));
362  unclaimedDividends = unclaimedDividends.add(amt2);
363  
364 }
365 function changevanity(string van) public payable{
366     require(msg.value >= 1  finney);
367     Vanity[msg.sender] = van;
368     Refundpot += msg.value;
369 }
370 function P3DDivstocontract() public{
371     uint256 divs = harvestabledivs();
372     require(divs > 0);
373  
374 P3Dcontract_.withdraw();
375     //1% to owner
376     uint256 base = divs.div(100);
377     uint256 amt2 = divs.sub(base);
378     SPASM_.disburse.value(base)();// to dev fee sharing contract
379    Refundpot = Refundpot.add(amt2);// add divs to refund line
380 }
381 
382 // bugtest selfdestruct function - deactivate on live
383 //  function die () public onlyOwner {
384 //      selfdestruct(msg.sender);
385 //  }
386 
387     
388 }
389 interface HourglassInterface  {
390     function() payable external;
391     function buy(address _playerAddress) payable external returns(uint256);
392     function sell(uint256 _amountOfTokens) external;
393     function reinvest() external;
394     function withdraw() external;
395     function exit() external;
396     function dividendsOf(address _playerAddress) external view returns(uint256);
397     function balanceOf(address _playerAddress) external view returns(uint256);
398     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
399     function stakingRequirement() external view returns(uint256);
400 }
401 interface SPASMInterface  {
402     function() payable external;
403     function disburse() external  payable;
404 }