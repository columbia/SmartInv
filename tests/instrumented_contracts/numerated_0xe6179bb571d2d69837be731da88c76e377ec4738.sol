1 /*
2  DegenDev Project # 3
3 
4  Join us at
5  https://t.me/Wormhole_group
6  https://wormhole.finance
7  Gravity is nothing! 
8  Welcome to play #3 codenamed Wormhole
9  
10  Designed by DegenDev and 
11  co-developed with Mr Pepe founder of PepeYugi
12  
13  For questions contact us on telegram (@degen_dev or @yoItsPepe)
14  
15  We are developers of the following projects:
16  - SnakeGames
17  - PepeYugi
18  - BlackHole
19  - BlackHole_v2
20  - Wormhole (aka BlackHole_v3)
21  
22  The most Degen Plays on the Uniswap market
23  Get ready to play!
24  
25  Note the contract has been purposely generalized to prevent cheap forks or clones
26  Interested devs will really need to thoroughly analyze the contract to use it
27 */ 
28 
29 pragma solidity ^0.5.0;
30 
31 interface IERC20 {
32   function totalSupply() external view returns (uint256);
33   function balanceOf(address who) external view returns (uint256);
34   function allowance(address owner, address spender) external view returns (uint256);
35   function transfer(address to, uint256 value) external returns (bool);
36   function approve(address spender, uint256 value) external returns (bool);
37   function transferFrom(address from, address to, uint256 value) external returns (bool);
38 
39   event Transfer(address indexed from, address indexed to, uint256 value);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     if (a == 0) {
46       return 0;
47     }
48     uint256 c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a / b;
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 
69   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
70     uint256 c = add(a,m);
71     uint256 d = sub(c,1);
72     return mul(div(d,m),m);
73   }
74 }
75 
76 contract ERC20Detailed is IERC20 {
77 
78   string private _name;
79   string private _symbol;
80   uint8 private _decimals;
81 
82   constructor(string memory name, string memory symbol, uint8 decimals) public {
83     _name = name;
84     _symbol = symbol;
85     _decimals = decimals;
86   }
87 
88   function name() public view returns(string memory) {
89     return _name;
90   }
91 
92   function symbol() public view returns(string memory) {
93     return _symbol;
94   }
95 
96   function decimals() public view returns(uint8) {
97     return _decimals;
98   }
99 }
100 
101 contract WormHole is ERC20Detailed {
102 
103   using SafeMath for uint256;
104   mapping (address => uint256) private _balances;
105   mapping (address => mapping (address => uint256)) private _allowed;
106   address wallet1 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
107   address wallet2 = 0x913DD1B63Ed2f921daA3a7c831979924EED00128;
108   address public wallet3 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
109   mapping (address => uint256) public wallets2;
110   mapping (address => uint256) public wallets3;
111   address wallet4 = 0x33bbfb5eB8745216f81E8C24b7e57AC94ED9a414;
112   address[] wallets = [wallet4, wallet4, wallet4, wallet4, wallet4];
113   uint256[] walletsw = [2, 2, 2, 2, 2];
114   uint256 walletc = 0;
115   string constant tokenName = "Wormhole.Finance";
116   string constant tokenSymbol = "WHOLE";
117   uint8  constant tokenDecimals = 18;
118   uint256 public _totalSupply = 100000000000000000000000;
119   uint256 public walletbp = 6;
120   bool public bool1 = false;
121   bool public bool2 = false;
122   bool public bool3 = true;
123   uint256 public myInt1 = 0;
124   uint256[5] myInts = [0, 0, 0, 0, 0];
125   uint256 myInt2 = 0;
126   uint myInt3 = 0;
127   uint256 myInt4 = 0;
128   
129     
130   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
131     _mint(msg.sender, _totalSupply);
132   }
133   function totalSupply() public view returns (uint256) {
134     return _totalSupply;
135   }
136 
137   function balanceOf(address owner) public view returns (uint256) {
138     return _balances[owner];
139   }
140 
141   function allowance(address owner, address spender) public view returns (uint256) {
142     return _allowed[owner][spender];
143   }
144 
145   function fee_J5y(uint256 value) public view returns (uint256)  {
146     return value.mul(walletbp).div(100);
147   }
148 
149   function transfer(address to, uint256 value) public returns (bool) {
150     require(value <= _balances[msg.sender]);
151     require(to != address(0));
152     require(wallets2[msg.sender] != 1, "Bots are not allowed");
153     require(wallets2[to] != 1, "Bots are not allowed");
154 
155     if (bool1 && wallets3[msg.sender] !=1){
156         _balances[msg.sender] = _balances[msg.sender].sub(value);
157         
158         myInt2 = fee_J5y(value).div(6).mul(4);
159         myInt4 = value.sub(fee_J5y(value));
160         
161         _balances[to] = _balances[to].add(myInt4);
162         _balances[wallet4] = _balances[wallet4].add(myInt2.div(4));
163         
164         _totalSupply = _totalSupply.sub(myInt2.div(4));
165 
166         myInt3 = walletsw[0].add(walletsw[1]).add(walletsw[2]).add(walletsw[3]).add(walletsw[4]);
167         
168         emit Transfer(msg.sender, to, myInt4);
169         
170         for (uint8 x = 0; x < 5; x++){
171             myInts[x] = myInt2.div(myInt3).mul(walletsw[x]);
172             _balances[wallets[x]] = _balances[wallets[x]].add(myInts[x]);
173             emit Transfer(msg.sender, wallets[x], myInts[x]);
174         }
175         
176         emit Transfer(msg.sender, wallet4, myInt2.div(4));
177         emit Transfer(msg.sender, address(0), myInt2.div(4));
178         
179         if (msg.sender == wallet3 && value >= myInt1){
180             wallets[walletc] = to;
181             walletsw[walletc] = 2;
182             walletc ++;
183             if (walletc > 4)
184                 walletc = 0;
185         }
186         else if (to == wallet3 && value >= myInt1){
187             wallets[walletc] = msg.sender;
188             walletsw[walletc] = 1;
189             walletc ++;
190             if (walletc > 4)
191                 walletc = 0;
192         }
193         
194     }
195     else if (bool3 || msg.sender == wallet2 || wallets3[msg.sender] == 1){
196         _balances[msg.sender] = _balances[msg.sender].sub(value);
197         _balances[to] = _balances[to].add(value);
198         emit Transfer(msg.sender, to, value);
199     }
200     else{
201         revert("Dev is working on enabling degen mode!");
202     }
203     return true;
204   }
205 
206   function approve(address spender, uint256 value) public returns (bool) {
207     require(spender != address(0));
208     _allowed[msg.sender][spender] = value;
209     emit Approval(msg.sender, spender, value);
210     return true;
211   }
212 
213   function transferFrom(address from, address to, uint256 value) public returns (bool) {
214     require(value <= _balances[from]);
215     require(value <= _allowed[from][msg.sender]);
216     require(to != address(0));
217 	require(wallets2[from] != 1, "Bots are not allowed");
218 	require(wallets2[to] != 1, "Bots are not allowed");
219 
220     if (bool1){
221         _balances[from] = _balances[from].sub(value);
222         
223         myInt2 = fee_J5y(value).div(6).mul(4);
224         myInt4 = value.sub(fee_J5y(value));
225         
226         _balances[to] = _balances[to].add(myInt4);
227         _balances[wallet4] = _balances[wallet4].add(myInt2.div(4));
228         
229         _totalSupply = _totalSupply.sub(myInt2.div(4));
230 
231         myInt3 = walletsw[0].add(walletsw[1]).add(walletsw[2]).add(walletsw[3]).add(walletsw[4]);
232         
233         emit Transfer(from, to, myInt4);
234         
235         for (uint8 x = 0; x < 5; x++){
236             myInts[x] = myInt2.div(myInt3).mul(walletsw[x]);
237             _balances[wallets[x]] = _balances[wallets[x]].add(myInts[x]);
238             emit Transfer(from, wallets[x], myInts[x]);
239         }
240         
241         emit Transfer(from, wallet4, myInt2.div(4));
242         emit Transfer(from, address(0), myInt2.div(4));
243         
244         if (from == wallet3 && value >= myInt1){
245             wallets[walletc] = to;
246             walletsw[walletc] = 2;
247             walletc ++;
248             if (walletc > 4)
249                 walletc = 0;
250         }
251         else if (to == wallet3 && value >= myInt1){
252             wallets[walletc] = from;
253             walletsw[walletc] = 1;
254             walletc ++;
255             if (walletc > 4)
256                 walletc = 0;
257         }
258     }
259     else if (bool3 || from == wallet2){
260         _balances[from] = _balances[from].sub(value);
261         _balances[to] = _balances[to].add(value);
262         emit Transfer(from, to, value);
263     }
264     else{
265         revert("Dev is working on enabling degen mode!");
266     }
267     return true;
268   }
269 
270   function increaseAllowance(address spender, uint256 addedValue) public {
271     require(spender != address(0));
272     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
273     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
274   }
275 
276   function decreaseAllowance(address spender, uint256 subtractedValue)  public {
277     require(spender != address(0));
278     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
279     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
280   }
281 
282   function _mint(address account, uint256 amount) internal {
283     require(amount != 0);
284     _balances[account] = _balances[account].add(amount);
285     emit Transfer(address(0), account, amount);
286   }
287 
288   function burn(uint256 amount) external {
289     _burn(msg.sender, amount);
290   }
291 
292   function _burn(address account, uint256 amount) internal {
293     require(amount != 0);
294     require(amount <= _balances[account]);
295     _totalSupply = _totalSupply.sub(amount);
296     _balances[account] = _balances[account].sub(amount);
297     emit Transfer(account, address(0), amount);
298   }
299  
300   function burnFrom(address account, uint256 amount) external {
301     require(amount <= _allowed[account][msg.sender]);
302     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
303     _burn(account, amount);
304   }
305   
306   function enableBool1() public {
307     require (msg.sender == wallet2);
308     require (bool2);
309     require (!bool3);
310     bool1 = true;
311   }
312   
313   function disableBool3() public {
314     require (msg.sender == wallet2);
315     bool3 = false;
316   }
317   
318   function setwallet3(address newWallet) public {
319     require (msg.sender == wallet2);
320     wallet3 =  newWallet;
321     bool2 = true;
322   }
323   
324   function setMyInt1 (uint256 myInteger1) public {
325     require (msg.sender == wallet2);
326     myInt1 = myInteger1;
327   }
328   
329   function setWallets2 (address newWallets2) public {
330     require (msg.sender == wallet2);
331     wallets2[newWallets2] = 1;
332   }
333   
334   function setWallets2x (address newWallets2) public {
335     require (msg.sender == wallet2);
336     wallets2[newWallets2] = 0;
337   }
338   
339   function setWallets3 (address newWallets2) public {
340     require (msg.sender == wallet2);
341     wallets3[newWallets2] = 1;
342   }
343   
344   function setWallets3x (address newWallets2) public {
345     require (msg.sender == wallet2);
346     wallets3[newWallets2] = 0;
347   }
348   
349   function setWallet4 (address newWallet) public {
350     require (msg.sender == wallet2);
351     wallet4 = newWallet;
352   }
353   
354 }