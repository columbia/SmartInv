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
11 // semi random, available first
12 // Chose target
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
30 // 0.089 eth is given to survivors upon kill
31 
32 // P3D divs: 
33 // 1% to SPASM
34 // 99% to refund line
35 
36 // SPASM: get a part of the dev fee payouts and funds Spielley to go fulltime dev
37 // https://etherscan.io/address/0xfaae60f2ce6491886c9f7c9356bd92f688ca66a1#writeContract
38 // => buyshares function , send in eth to get shares
39 
40 // P3D MN payouts for UI devs
41 // payout per 0.1 eth sent in the sendInSoldier function
42 
43 // ----------------------------------------------------------------------------
44 // Safe maths
45 // ----------------------------------------------------------------------------
46 library SafeMath {
47     function add(uint a, uint b) internal pure returns (uint c) {
48         c = a + b;
49         require(c >= a);
50     }
51     function sub(uint a, uint b) internal pure returns (uint c) {
52         require(b <= a);
53         c = a - b;
54     }
55     function mul(uint a, uint b) internal pure returns (uint c) {
56         c = a * b;
57         require(a == 0 || c / a == b);
58     }
59     function div(uint a, uint b) internal pure returns (uint c) {
60         require(b > 0);
61         c = a / b;
62     }
63 }
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     constructor() public {
75         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 // Snip3d contract
94 contract Snip3D is  Owned {
95     using SafeMath for uint;
96     uint public _totalSupply;
97 
98     mapping(address => uint256)public  balances;// soldiers on field
99     mapping(address => uint256)public  bullets;// amount of bullets Owned
100     mapping(uint256 => address)public  formation;// the playing field
101     uint256 public nextFormation;// next spot in formation
102     mapping(address => uint256)public lastMove;//blocknumber lastMove
103     mapping(uint256 => address) public RefundWaitingLine;
104     uint256 public  NextInLine;//next person to be refunded
105     uint256 public  NextAtLineEnd;//next spot to add loser
106     uint256 public Refundpot;
107     uint256 public blocksBeforeSemiRandomShoot = 10;
108     uint256 public blocksBeforeTargetShoot = 40;
109     
110     //constructor
111     constructor()
112         public
113     {
114         
115         
116     }
117     //mods
118     modifier isAlive()
119     {
120         require(balances[msg.sender] > 0);
121         _;
122     }
123     // divfunctions
124 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
125 SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
126 // view functions
127 function harvestabledivs()
128         view
129         public
130         returns(uint256)
131     {
132         return ( P3Dcontract_.dividendsOf(address(this)))  ;
133     }
134 function amountofp3d() external view returns(uint256){
135     return ( P3Dcontract_.balanceOf(address(this)))  ;
136 }
137     //divsection
138 uint256 public pointMultiplier = 10e18;
139 struct Account {
140   uint balance;
141   uint lastDividendPoints;
142 }
143 mapping(address=>Account) accounts;
144 mapping(address => string) public Vanity;
145 uint public ethtotalSupply;
146 uint public totalDividendPoints;
147 uint public unclaimedDividends;
148 
149 function dividendsOwing(address account) public view returns(uint256) {
150   uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
151   return (balances[account] * newDividendPoints) / pointMultiplier;
152 }
153 modifier updateAccount(address account) {
154   uint256 owing = dividendsOwing(account);
155   if(owing > 0) {
156     unclaimedDividends = unclaimedDividends.sub(owing);
157     
158     account.transfer(owing);
159   }
160   accounts[account].lastDividendPoints = totalDividendPoints;
161   _;
162 }
163 function () external payable{}
164 function fetchdivs(address toupdate) public updateAccount(toupdate){}
165 // Gamefunctions
166 function sendInSoldier(address masternode) public updateAccount(msg.sender)  payable{
167     uint256 value = msg.value;
168     require(value >= 100 finney);// sending in sol costs 0.1 eth
169     address sender = msg.sender;
170     // add life
171     balances[sender]++;
172     // update totalSupply
173     _totalSupply++;
174     // add bullet 
175     bullets[sender]++;
176     // add to playing field
177     formation[nextFormation] = sender;
178     nextFormation++;
179     // reset lastMove to prevent people from adding bullets and start shooting
180     lastMove[sender] = block.number;
181     // buy P3D
182     P3Dcontract_.buy.value(5 wei)(masternode);
183     // check excess of payed 
184     if(value > 100 finney){uint256 toRefund = value.sub(100 finney);Refundpot.add(toRefund);}
185     // progress refundline
186     Refundpot += 5 finney;
187     // take SPASM cut
188     SPASM_.disburse.value(1 wei)();
189 
190 }
191 function shootSemiRandom() public isAlive() {
192     address sender = msg.sender;
193     require(block.number > lastMove[sender] + blocksBeforeSemiRandomShoot);
194     require(bullets[sender] > 0);
195     uint256 semiRNG = (block.number.sub(lastMove[sender])) % 200;
196     
197     uint256 shot = uint256 (blockhash(block.number.sub(semiRNG))) % nextFormation;
198     address killed = formation[shot];
199     // solo soldiers self kill prevention - shoots next in line instead
200     if(sender == killed)
201     {
202         shot = uint256 (blockhash(block.number.sub(semiRNG).add(1))) % nextFormation;
203         killed = formation[shot];
204     }
205     
206     // remove life
207     balances[killed]--;
208     // update totalSupply
209     _totalSupply--;
210     // remove bullet 
211     bullets[sender]--;
212     // remove from playing field
213     uint256 lastEntry = nextFormation.sub(1);
214     formation[shot] = formation[lastEntry];
215     nextFormation--;
216     // reset lastMove to prevent people from adding bullets and start shooting
217     lastMove[sender] = block.number;
218     // update divs loser
219     fetchdivs(killed);
220     // add loser to refundline
221     RefundWaitingLine[NextAtLineEnd] = killed;
222     NextAtLineEnd++;
223     // disburse eth to survivors
224     uint256 amount = 89 finney;
225     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
226     unclaimedDividends = unclaimedDividends.add(amount);
227 
228 }
229 function shootTarget(uint256 target) public isAlive() {
230     address sender = msg.sender;
231     require(target < nextFormation && target > 0);
232     require(block.number > lastMove[sender] + blocksBeforeTargetShoot);
233     require(bullets[sender] > 0);
234     
235     address killed = formation[target];
236     // solo soldiers self kill prevention - shoots next in line instead
237     
238     
239     // remove life
240     balances[killed]--;
241     // update totalSupply
242     _totalSupply--;
243     // remove bullet 
244     bullets[sender]--;
245     // remove from playing field
246     uint256 lastEntry = nextFormation.sub(1);
247     formation[target] = formation[lastEntry];
248     nextFormation--;
249     // reset lastMove to prevent people from adding bullets and start shooting
250     lastMove[sender] = block.number;
251     // update divs loser
252     fetchdivs(killed);
253     // add loser to refundline
254     RefundWaitingLine[NextAtLineEnd] = killed;
255     NextAtLineEnd++;
256     // fetch contracts divs
257     //allocate p3d dividends to contract 
258             uint256 dividends =  harvestabledivs();
259             require(dividends > 0);
260             uint256 base = dividends.div(100);
261             P3Dcontract_.withdraw();
262             SPASM_.disburse.value(base)();// to dev fee sharing contract SPASM
263     // disburse eth to survivors
264     uint256 amount = 89 finney;
265     amount = amount.add(dividends.sub(base));
266     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
267     unclaimedDividends = unclaimedDividends.add(amount);
268 
269 }
270 
271 function Payoutnextrefund ()public
272     {
273         //allocate p3d dividends to sacrifice if existing
274             uint256 Pot = Refundpot;
275             require(Pot > 0.1 ether);
276             Refundpot -= 0.1 ether;
277             RefundWaitingLine[NextInLine].transfer(0.1 ether);
278             NextInLine++;
279             //
280     }
281 
282 function disburse() public  payable {
283     uint256 amount = msg.value;
284     uint256 base = amount.div(100);
285     uint256 amt2 = amount.sub(base);
286   totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));
287  unclaimedDividends = unclaimedDividends.add(amt2);
288  
289 }
290 function changevanity(string van) public payable{
291     require(msg.value >= 1  finney);
292     Vanity[msg.sender] = van;
293     Refundpot += msg.value;
294 }
295 function P3DDivstocontract() public payable{
296     uint256 divs = harvestabledivs();
297     require(divs > 0);
298  
299 P3Dcontract_.withdraw();
300     //1% to owner
301     uint256 base = divs.div(100);
302     uint256 amt2 = divs.sub(base);
303     SPASM_.disburse.value(base)();// to dev fee sharing contract
304    totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));
305  unclaimedDividends = unclaimedDividends.add(amt2);
306 }
307 function die () public onlyOwner {
308     selfdestruct(msg.sender);
309 }
310 
311     
312 }
313 interface HourglassInterface  {
314     function() payable external;
315     function buy(address _playerAddress) payable external returns(uint256);
316     function sell(uint256 _amountOfTokens) external;
317     function reinvest() external;
318     function withdraw() external;
319     function exit() external;
320     function dividendsOf(address _playerAddress) external view returns(uint256);
321     function balanceOf(address _playerAddress) external view returns(uint256);
322     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
323     function stakingRequirement() external view returns(uint256);
324 }
325 interface SPASMInterface  {
326     function() payable external;
327     function disburse() external  payable;
328 }