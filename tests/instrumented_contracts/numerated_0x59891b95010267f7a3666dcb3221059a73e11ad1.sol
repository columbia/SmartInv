1 pragma solidity 0.5.6;
2 
3 contract P3XRoll {
4     using SafeMath for uint256;
5     
6     struct Bet {
7         uint256 amount;
8         uint256 chance;
9         uint256 blocknumber;
10         bool isOpen;
11     }
12     
13     mapping(address => Bet) public bets;
14     uint256 public numberOfBets;
15     
16     mapping(address => uint256) private playerVault;
17     uint256 public pot;
18     
19     uint256 constant public MIN_BET = 1e18; // 1 P3X
20     uint256 constant private MAX_PROFIT_DIVISOR = 100;
21     
22     event Win(address indexed player, uint256 indexed roll, uint256 indexed amount);
23     event Loss(address indexed player, uint256 indexed roll, uint256 indexed amount);
24     event Expiration(address indexed player, uint256 indexed amount);
25     
26     address constant private P3X_ADDRESS = address(0x058a144951e062FC14f310057D2Fd9ef0Cf5095b);
27     IP3X constant private p3xContract = IP3X(P3X_ADDRESS);
28     
29     address constant private DEV = address(0x1EB2acB92624DA2e601EEb77e2508b32E49012ef);
30     
31     //shareholder setup
32     struct Shareholder {
33         uint256 tokens;
34         uint256 outstandingDividends;
35         uint256 lastDividendPoints;
36     }
37 
38     uint256 constant private MAX_SUPPLY = 20000e18;
39     uint256 public totalSupply;
40     mapping(address => Shareholder) public shareholders;
41     bool public minting = true;
42     
43     uint256 constant private POINT_MULTIPLIER = 10e18;
44     uint256 private totalDividendPoints;
45     uint256 public totalOutstandingDividends;
46     
47     uint256 constant private DIVIDEND_FETCH_TIME = 1 hours;
48     uint256 private lastDividendsFetched;
49     
50     event Mint(address indexed player, uint256 indexed amount);
51     
52     modifier updateDividends()
53     {
54         if(now - lastDividendsFetched > DIVIDEND_FETCH_TIME && totalSupply > 0) {
55             fetchDividendsFromP3X();
56         }
57         _;
58     }
59     
60     function() external payable {}
61     
62     function tokenFallback(address player, uint256 amount, bytes calldata data)
63 	    external
64 	    updateDividends
65 	{
66 	    require(msg.sender == P3X_ADDRESS);
67 	    
68 	    if(data[0] == 0) {
69 	        fundPot(player, amount);
70 	    } else {
71 	        placeBet(player, amount, uint8(data[0]));
72 	    }
73 	}
74         
75     function playFromVault(uint256 amount, uint256 chance)
76         external
77         updateDividends
78     {
79         playerVault[msg.sender] = playerVault[msg.sender].sub(amount);
80         
81         placeBet(msg.sender, amount, chance);
82     }
83     
84     function placeBet(address player, uint256 amount, uint256 chance)
85         private
86     {
87         require(chance >= 1 && chance <= 98);
88         require(amount >= MIN_BET);
89         
90         if(hasActiveBet(player)) {
91             fetch(player);
92         }
93         
94         uint256 potentialProfit = potentialProfit(amount, chance);
95         require(potentialProfit <= maximumProfit());
96         
97         bets[player] = Bet(amount, chance, block.number + 1, true);
98         numberOfBets++;
99         
100         pot = pot.add(amount);
101         
102         if(minting) {
103             mint(player, potentialProfit < amount ? potentialProfit : amount);
104         }
105     }
106     
107     function fetchResult()
108         external
109         updateDividends
110     {
111         require(hasActiveBet(msg.sender));
112         
113         fetch(msg.sender);
114     }
115     
116     function fetch(address player)
117         private
118     {
119         Bet storage bet = bets[player];
120         
121         require(bet.blocknumber < block.number);
122         
123         bet.isOpen = false;
124         
125         if(block.number - 256 > bet.blocknumber) {
126             emit Expiration(player, bet.amount);
127             return;
128         }
129         
130         uint256 roll = (uint256(blockhash(bet.blocknumber)) % 100) + 1;
131         
132         if(roll <= bet.chance) {
133             uint256 totalReturn = bet.amount.mul(99) / bet.chance;
134             playerVault[player] = playerVault[player].add(totalReturn);
135             pot = pot.sub(totalReturn);
136             emit Win(player, roll, totalReturn - bet.amount);
137         } else {
138             emit Loss(player, roll, bet.amount);
139         }
140     }
141     
142     function withdrawEarnings()
143         external
144         updateDividends
145     {
146         uint256 amount = playerVault[msg.sender];
147         
148         require(amount > 0);
149         
150         playerVault[msg.sender] = 0;
151         
152         p3xContract.transfer(msg.sender, amount);
153     }
154     
155     function withdrawDividends()
156         external
157     {
158         Shareholder storage shareholder = shareholders[msg.sender];
159         
160         updateOutstandingDividends(shareholder);
161         
162         uint256 amount = shareholder.outstandingDividends;
163         
164         require(amount > 0);
165         
166         shareholder.outstandingDividends = 0;
167         totalOutstandingDividends = totalOutstandingDividends.sub(amount);
168 		
169 	    msg.sender.transfer(amount);
170     }
171     
172     function fundPot(address player, uint256 amount)
173         private
174     {
175         require(minting);
176         
177         pot = pot.add(amount);
178         
179         mint(player, amount);
180     }
181     
182     function mint(address player, uint256 amount)
183         private
184     {
185         uint256 amountToMint;
186         if(totalSupply.add(amount) < MAX_SUPPLY) {
187             amountToMint = amount;
188         } else {
189             amountToMint = MAX_SUPPLY.sub(totalSupply);
190             minting = false;
191         }
192         
193         Shareholder storage minter = shareholders[player];
194         Shareholder storage dev = shareholders[DEV];
195         
196         updateOutstandingDividends(minter);
197         updateOutstandingDividends(dev);
198         
199         totalSupply = totalSupply.add(amountToMint);
200         minter.tokens = minter.tokens.add(amountToMint.mul(19) / 20);
201         dev.tokens = dev.tokens.add(amountToMint / 20);
202         
203         emit Mint(player, amountToMint);
204     }
205     
206     function updateOutstandingDividends(Shareholder storage shareholder)
207         private
208     {
209         uint256 dividendPointsDifference = totalDividendPoints.sub(shareholder.lastDividendPoints);
210         
211         shareholder.lastDividendPoints = totalDividendPoints;
212         shareholder.outstandingDividends = shareholder.outstandingDividends
213                                             .add(dividendPointsDifference.mul(shareholder.tokens) / POINT_MULTIPLIER);
214     }
215     
216     function fetchDividendsFromP3X()
217         public
218     {
219         lastDividendsFetched = now;
220         
221         uint256 dividends = p3xContract.dividendsOf(address(this), true);
222         if(dividends > 0) {
223               p3xContract.withdraw();
224               totalDividendPoints = totalDividendPoints.add(dividends.mul(POINT_MULTIPLIER) / totalSupply);
225               totalOutstandingDividends = totalOutstandingDividends.add(dividends);
226         }
227     }
228     
229     //
230     // VIEW FUNCTIONS
231     //
232     function maximumProfit()
233         public
234         view
235         returns(uint256)
236     {
237         return pot / MAX_PROFIT_DIVISOR;
238     }
239     
240     function potentialProfit(uint256 amount, uint256 chance)
241         public
242         view
243         returns(uint256)
244     {
245        return (amount.mul(99) / chance).sub(amount);
246     }
247     
248     function hasActiveBet(address player)
249         public
250         view
251         returns(bool)
252     {
253         return bets[player].isOpen;
254     }
255     
256     function myEarnings()
257         external
258         view
259         returns(uint256)
260     {
261         return playerVault[msg.sender];
262     }
263     
264     function myDividends()
265         external
266         view
267         returns(uint256)
268     {
269         address shareholder = msg.sender;
270         
271         uint256 dividendPointsDifference = totalDividendPoints.sub(shareholders[shareholder].lastDividendPoints);
272         return shareholders[shareholder].outstandingDividends
273                 .add(dividendPointsDifference.mul(shareholders[shareholder].tokens) / POINT_MULTIPLIER);
274     }
275     
276     function myTokens()
277         external
278         view
279         returns(uint256)
280     {
281         return shareholders[msg.sender].tokens;
282     }
283     
284     function myTokenShare()
285         external
286         view
287         returns(uint256)
288     {
289         return totalSupply > 0 ? shareholders[msg.sender].tokens.mul(100) / totalSupply : 0;
290     }
291     
292     function myP3XBalance()
293         external
294         view
295         returns(uint256)
296     {
297         return p3xContract.balanceOf(msg.sender);
298     }
299     
300     function fetchableDividendsFromP3X()
301         external
302         view
303         returns(uint256)
304     {
305         return p3xContract.dividendsOf(address(this), true);
306     }
307     
308     function mintableTokens()
309         external
310         view
311         returns(uint256)
312     {
313         return MAX_SUPPLY.sub(totalSupply);
314     }
315     
316     function timeUntilNextDividendFetching()
317         external
318         view
319         returns(uint256)
320     {
321         uint256 difference = now.sub(lastDividendsFetched);
322         return difference > DIVIDEND_FETCH_TIME ? 0 : DIVIDEND_FETCH_TIME.sub(difference);
323     }
324 }
325 
326 interface IP3X {
327     function transfer(address to, uint256 value) external returns(bool);
328 	function transfer(address to, uint value, bytes calldata data) external returns(bool ok);
329     function buy(address referrerAddress) payable external returns(uint256);
330     function balanceOf(address tokenOwner) external view returns(uint);
331 	function dividendsOf(address customerAddress, bool includeReferralBonus) external view returns(uint256);
332     function withdraw() external;
333 }
334 
335 library SafeMath {
336     
337     function mul(uint256 a, uint256 b) 
338         internal 
339         pure 
340         returns (uint256 c) 
341     {
342         if (a == 0) {
343             return 0;
344         }
345         c = a * b;
346         require(c / a == b, "SafeMath mul failed");
347         return c;
348     }
349 
350     function sub(uint256 a, uint256 b)
351         internal
352         pure
353         returns (uint256) 
354     {
355         require(b <= a, "SafeMath sub failed");
356         return a - b;
357     }
358     
359     function add(uint256 a, uint256 b)
360         internal
361         pure
362         returns (uint256 c) 
363     {
364         c = a + b;
365         require(c >= a, "SafeMath add failed");
366         return c;
367     }
368 }