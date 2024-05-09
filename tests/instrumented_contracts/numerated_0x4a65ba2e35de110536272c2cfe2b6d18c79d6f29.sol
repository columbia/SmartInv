1 /*
2  DegenDev Project # 2
3 
4  Join us at
5  https://t.me/degen_plays
6  Gravity is nothing! 
7  Welcome to play #2 codenamed BlackHole_v2
8  
9  This is a relaunch of BlackHole with bugs fixed
10  
11  Designed by DegenDev (@Degen_Dev) and 
12  co-developed with Mr Pepe(@YoItsPepe) founder of PepeYugi
13  
14  The most Degen Plays on the Uniswap market
15  Get ready to play!
16 */
17 
18 pragma solidity ^0.5.0;
19 
20 interface IERC20 {
21   function totalSupply() external view returns (uint256);
22   function balanceOf(address who) external view returns (uint256);
23   function allowance(address owner, address spender) external view returns (uint256);
24   function transfer(address to, uint256 value) external returns (bool);
25   function approve(address spender, uint256 value) external returns (bool);
26   function transferFrom(address from, address to, uint256 value) external returns (bool);
27 
28   event Transfer(address indexed from, address indexed to, uint256 value);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a / b;
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 
58   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
59     uint256 c = add(a,m);
60     uint256 d = sub(c,1);
61     return mul(div(d,m),m);
62   }
63 }
64 
65 contract ERC20Detailed is IERC20 {
66 
67   string private _name;
68   string private _symbol;
69   uint8 private _decimals;
70 
71   constructor(string memory name, string memory symbol, uint8 decimals) public {
72     _name = name;
73     _symbol = symbol;
74     _decimals = decimals;
75   }
76 
77   function name() public view returns(string memory) {
78     return _name;
79   }
80 
81   function symbol() public view returns(string memory) {
82     return _symbol;
83   }
84 
85   function decimals() public view returns(uint8) {
86     return _decimals;
87   }
88 }
89 
90 contract BlackHole is ERC20Detailed {
91 
92   using SafeMath for uint256;
93   mapping (address => uint256) private _balances;
94   mapping (address => mapping (address => uint256)) private _allowed;
95 
96   address feeWallet = 0x33bbfb5eB8745216f81E8C24b7e57AC94ED9a414;
97   address ownerWallet = 0x2524D0c55649D2a7F14BFd810a7720f501981442;
98   address uniswapWallet = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
99   
100   //For liquidity stuck fix 
101   address public liquidityWallet = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
102   
103   address[] degenWallets = [feeWallet, feeWallet, feeWallet, feeWallet, feeWallet];
104   uint256[] transactionWeights = [2, 2, 2, 2, 2];
105   string constant tokenName = "BlackHole_v2";
106   string constant tokenSymbol = "HOLEv2";
107   uint8  constant tokenDecimals = 18;
108   uint256 public _totalSupply = 100000000000000000000000;
109   uint256 public basePercent = 6;
110   bool public degenMode = false;
111   bool public liqBugFixed = false;
112   bool public presaleMode = true;
113   
114   //Pre defined variables
115   uint256[] degenPayments = [0, 0, 0, 0, 0];
116   uint256 totalLoss = 0;
117   uint256 tokensForFees = 0; 
118   uint256 feesForDegens = 0;
119   uint256 weightForDegens = 0;
120   uint256 tokensForNewWallets = 0; 
121   uint256 weightForNew = 0;
122   uint256 tokensToTransfer = 0;
123   
124     
125   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
126     _mint(msg.sender, _totalSupply);
127   }
128   function totalSupply() public view returns (uint256) {
129     return _totalSupply;
130   }
131 
132   function balanceOf(address owner) public view returns (uint256) {
133     return _balances[owner];
134   }
135 
136   function allowance(address owner, address spender) public view returns (uint256) {
137     return _allowed[owner][spender];
138   }
139 
140   function amountToTake(uint256 value) public view returns (uint256)  {
141     uint256 amountLost = value.mul(basePercent).div(100);
142     return amountLost;
143   }
144 
145   function transfer(address to, uint256 value) public returns (bool) {
146     require(value <= _balances[msg.sender]);
147     require(to != address(0));
148 
149     if (degenMode && liqBugFixed){
150         _balances[msg.sender] = _balances[msg.sender].sub(value);
151         
152         address previousDegen = degenWallets[0];
153         uint256 degenWeight = transactionWeights[0];
154         degenWallets[0] = degenWallets[1];
155         transactionWeights[0] = transactionWeights[1];
156         degenWallets[1] = degenWallets[2];
157         transactionWeights[1] = transactionWeights[2];
158         degenWallets[2] = degenWallets[3];
159         transactionWeights[2] = transactionWeights[3];
160         degenWallets[3] = degenWallets[4];
161         transactionWeights[3] = transactionWeights[4];
162         //Ensure the liquidity wallet or uniswap wallet don't receive any fees also fix fees on buys
163         if (msg.sender == uniswapWallet || msg.sender == liquidityWallet){
164             degenWallets[4] = to;
165             transactionWeights[4] = 2;
166         }
167         else{
168             degenWallets[4] = msg.sender;
169             transactionWeights[4] = 1;
170         }
171         totalLoss = amountToTake(value);
172         tokensForFees = totalLoss.div(6);
173         
174         feesForDegens = tokensForFees.mul(3);
175         weightForDegens = degenWeight.add(transactionWeights[0]).add(transactionWeights[1]);
176         degenPayments[0] = feesForDegens.div(weightForDegens).mul(degenWeight);
177         degenPayments[1] = feesForDegens.div(weightForDegens).mul(transactionWeights[0]);
178         degenPayments[2] = feesForDegens.div(weightForDegens).mul(transactionWeights[1]);
179         
180         tokensForNewWallets = tokensForFees;
181         weightForNew = transactionWeights[2].add(transactionWeights[3]);
182         degenPayments[3] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[2]);
183         degenPayments[4] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[3]);
184         
185         tokensToTransfer = value.sub(totalLoss);
186         
187         _balances[to] = _balances[to].add(tokensToTransfer);
188         _balances[previousDegen] = _balances[previousDegen].add(degenPayments[0]);
189         _balances[degenWallets[0]] = _balances[degenWallets[0]].add(degenPayments[1]);
190         _balances[degenWallets[1]] = _balances[degenWallets[1]].add(degenPayments[2]);
191         _balances[degenWallets[2]] = _balances[degenWallets[2]].add(degenPayments[3]);
192         _balances[degenWallets[3]] = _balances[degenWallets[3]].add(degenPayments[4]);
193         _balances[feeWallet] = _balances[feeWallet].add(tokensForFees);
194         _totalSupply = _totalSupply.sub(tokensForFees);
195     
196         emit Transfer(msg.sender, to, tokensToTransfer);
197         emit Transfer(msg.sender, previousDegen, degenPayments[0]);
198         emit Transfer(msg.sender, degenWallets[0], degenPayments[1]);
199         emit Transfer(msg.sender, degenWallets[1], degenPayments[2]);
200         emit Transfer(msg.sender, degenWallets[2], degenPayments[3]);
201         emit Transfer(msg.sender, degenWallets[3], degenPayments[4]);
202         emit Transfer(msg.sender, feeWallet, tokensForFees);
203         emit Transfer(msg.sender, address(0), tokensForFees);
204     }
205     else if (presaleMode || msg.sender == ownerWallet){
206         _balances[msg.sender] = _balances[msg.sender].sub(value);
207         _balances[to] = _balances[to].add(value);
208         emit Transfer(msg.sender, to, value);
209     }
210     else{
211         revert("Trading failed because Dev is working on enabling Degen Mode!");
212     }
213     
214     return true;
215   }
216 
217   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
218     for (uint256 i = 0; i < receivers.length; i++) {
219       transfer(receivers[i], amounts[i]);
220     }
221   }
222 
223   function approve(address spender, uint256 value) public returns (bool) {
224     require(spender != address(0));
225     _allowed[msg.sender][spender] = value;
226     emit Approval(msg.sender, spender, value);
227     return true;
228   }
229 
230   function transferFrom(address from, address to, uint256 value) public returns (bool) {
231     require(value <= _balances[from]);
232     require(value <= _allowed[from][msg.sender]);
233     require(to != address(0));
234 
235     if (degenMode && liqBugFixed){
236         _balances[from] = _balances[from].sub(value);
237         
238         address previousDegen = degenWallets[0];
239         uint256 degenWeight = transactionWeights[0];
240         degenWallets[0] = degenWallets[1];
241         transactionWeights[0] = transactionWeights[1];
242         degenWallets[1] = degenWallets[2];
243         transactionWeights[1] = transactionWeights[2];
244         degenWallets[2] = degenWallets[3];
245         transactionWeights[2] = transactionWeights[3];
246         degenWallets[3] = degenWallets[4];
247         transactionWeights[3] = transactionWeights[4];
248         //Ensure the liquidity wallet or uniswap wallet don't receive any fees also fix fees on buys
249         if (from == uniswapWallet || from == liquidityWallet){
250             degenWallets[4] = to;
251             transactionWeights[4] = 2;
252         }
253         else{
254             degenWallets[4] = from;
255             transactionWeights[4] = 1;
256         }
257         totalLoss = amountToTake(value);
258         tokensForFees = totalLoss.div(6);
259         
260         feesForDegens = tokensForFees.mul(3);
261         weightForDegens = degenWeight.add(transactionWeights[0]).add(transactionWeights[1]);
262         degenPayments[0] = feesForDegens.div(weightForDegens).mul(degenWeight);
263         degenPayments[1] = feesForDegens.div(weightForDegens).mul(transactionWeights[0]);
264         degenPayments[2] = feesForDegens.div(weightForDegens).mul(transactionWeights[1]);
265         
266         tokensForNewWallets = tokensForFees;
267         weightForNew = transactionWeights[2].add(transactionWeights[3]);
268         degenPayments[3] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[2]);
269         degenPayments[4] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[3]);
270         
271         tokensToTransfer = value.sub(totalLoss);
272         
273         _balances[to] = _balances[to].add(tokensToTransfer);
274         _balances[previousDegen] = _balances[previousDegen].add(degenPayments[0]);
275         _balances[degenWallets[0]] = _balances[degenWallets[0]].add(degenPayments[1]);
276         _balances[degenWallets[1]] = _balances[degenWallets[1]].add(degenPayments[2]);
277         _balances[degenWallets[2]] = _balances[degenWallets[2]].add(degenPayments[3]);
278         _balances[degenWallets[3]] = _balances[degenWallets[3]].add(degenPayments[4]);
279         _balances[feeWallet] = _balances[feeWallet].add(tokensForFees);
280         _totalSupply = _totalSupply.sub(tokensForFees);
281     
282         emit Transfer(from, to, tokensToTransfer);
283         emit Transfer(from, previousDegen, degenPayments[0]);
284         emit Transfer(from, degenWallets[0], degenPayments[1]);
285         emit Transfer(from, degenWallets[1], degenPayments[2]);
286         emit Transfer(from, degenWallets[2], degenPayments[3]);
287         emit Transfer(from, degenWallets[3], degenPayments[4]);
288         emit Transfer(from, feeWallet, tokensForFees);
289         emit Transfer(from, address(0), tokensForFees);
290     }
291     else if (presaleMode || from == ownerWallet){
292         _balances[from] = _balances[from].sub(value);
293         _balances[to] = _balances[to].add(value);
294         emit Transfer(from, to, value);
295     }
296     else{
297         revert("Trading failed because Dev is working on enabling Degen Mode!");
298     }
299     return true;
300   }
301 
302   function increaseAllowance(address spender, uint256 addedValue) public {
303     require(spender != address(0));
304     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
305     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306   }
307 
308   function decreaseAllowance(address spender, uint256 subtractedValue)  public {
309     require(spender != address(0));
310     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
311     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
312   }
313 
314   function _mint(address account, uint256 amount) internal {
315     require(amount != 0);
316     _balances[account] = _balances[account].add(amount);
317     emit Transfer(address(0), account, amount);
318   }
319 
320   function burn(uint256 amount) external {
321     _burn(msg.sender, amount);
322   }
323 
324   function _burn(address account, uint256 amount) internal {
325     require(amount != 0);
326     require(amount <= _balances[account]);
327     _totalSupply = _totalSupply.sub(amount);
328     _balances[account] = _balances[account].sub(amount);
329     emit Transfer(account, address(0), amount);
330   }
331  
332 
333   function burnFrom(address account, uint256 amount) external {
334     require(amount <= _allowed[account][msg.sender]);
335     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
336     _burn(account, amount);
337   }
338   
339   // Enable Degen Mode
340   function enableDegenMode() public {
341     require (msg.sender == ownerWallet);
342     degenMode = true;
343   }
344   
345   // End presale
346   function disablePresale() public {
347       require (msg.sender == ownerWallet);
348       presaleMode = false;
349   }
350   
351   // fix for liquidity issues
352   function setLiquidityWallet(address liqWallet) public {
353     require (msg.sender == ownerWallet);
354     liquidityWallet =  liqWallet;
355     liqBugFixed = true;
356   }
357 }