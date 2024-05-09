1 /*
2 
3 STAYK.ME
4 
5 (STAYK)
6 
7 website:  https://stayk.me
8 
9 discord:  https://discord.gg/bpt8Paj
10 
11 twitter:  https://twitter.com/STAYK_TOKEN
12 
13 Maximum Supply:  Ethereum Block.number * 10
14 
15 1% Token Burn on Every Transfer
16 
17 Each Token Holder Can request payout in STAYK tokens
18 once per day
19 
20 STAYK payouts are in proportion to your holdings
21 
22 ETH can be sent directly to the contract to purchase tokens
23 when a sale is open
24 
25 *DO NOT SEND ETH from an exchange wallet.   Only send ETH from a wallet
26 you control directly.  Otherwise you will lose your tokens.
27 
28 */
29 
30 pragma solidity ^0.5.0;
31 
32 
33 interface IERC20 {
34   function totalSupply() external view returns (uint256);
35   function balanceOf(address who) external view returns (uint256);
36   function allowance(address owner, address spender) external view returns (uint256);
37   function transfer(address to, uint256 value) external returns (bool);
38   function approve(address spender, uint256 value) external returns (bool);
39   function transferFrom(address from, address to, uint256 value) external returns (bool);
40 
41   event Transfer(address indexed from, address indexed to, uint256 value);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50     uint256 c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a / b;
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 
71   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
72     uint256 c = add(a,m);
73     uint256 d = sub(c,1);
74     return mul(div(d,m),m);
75   }
76 }
77 
78 contract ERC20Detailed is IERC20 {
79 
80   uint8 private _Tokendecimals;
81   string private _Tokenname;
82   string private _Tokensymbol;
83 
84   constructor(string memory name, string memory symbol, uint8 decimals) public {
85    
86    _Tokendecimals = decimals;
87     _Tokenname = name;
88     _Tokensymbol = symbol;
89     
90   }
91 
92   function name() public view returns(string memory) {
93     return _Tokenname;
94   }
95 
96   function symbol() public view returns(string memory) {
97     return _Tokensymbol;
98   }
99 
100   function decimals() public view returns(uint8) {
101     return _Tokendecimals;
102   }
103 }
104 
105 /**end here**/
106 
107 contract STAYK is ERC20Detailed {
108 
109   using SafeMath for uint256;
110   bool public allowSale = true;
111   uint256 public minPurchase = 0.01 ether;
112   uint256 public salePrice = 0.0001 ether;
113   uint256 public currentSaleAmount = 0;
114   uint256 public saleHardCap = 3000000e18;
115   uint256 public payFreq = 5900;
116   uint256 public burnFactor = 100;  //1%
117   uint256 tokenFactor = 10;    
118   mapping(address => uint256) public lastPay;
119   mapping (address => uint256) public _STAYKTokenBalances;
120   mapping (address => mapping (address => uint256)) private _allowed;
121   string constant tokenName = "STAYK.ME";
122   string constant tokenSymbol = "STAYK";
123   uint8  constant tokenDecimals = 18;
124   uint256 _totalSupply = block.number * tokenFactor * 1e18;
125   address public admin;
126   uint256 public _STAYKFund = _totalSupply;    
127 
128   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
129     
130     admin = msg.sender;
131   }
132 
133   
134   function totalSupply() public view returns (uint256) {
135     return _totalSupply;
136   }
137 
138   function myTokens() public view returns (uint256) {
139     return _STAYKTokenBalances[msg.sender];
140   }
141 
142   function balanceOf(address owner) public view returns (uint256) {
143     return _STAYKTokenBalances[owner];
144   }
145 
146   function allowance(address owner, address spender) public view returns (uint256) {
147     return _allowed[owner][spender];
148   }
149 
150   function setPayFrequency(uint256 _input) public {
151     require(msg.sender == admin);
152     payFreq = _input;
153   }
154 
155   function setBurnFactor(uint256 _input) public {
156     require(msg.sender == admin);
157     burnFactor = _input;
158   }
159 
160   function() payable external {
161 
162     if (msg.value == 0){
163 
164       getPaid();
165 
166     } else {
167 
168       _buyTokens(msg.value);
169 
170     }
171   }
172 
173   function resetSale(uint256 _hardCap) public {
174      require(msg.sender == admin);
175      require(_hardCap <= _STAYKFund);
176      currentSaleAmount = 0;
177      saleHardCap = _hardCap;
178   }
179 
180   function setAllowSale(bool _allow) public {
181      require(msg.sender == admin);
182      allowSale = _allow;
183   }
184 
185   function setMinPurcchae(uint256 _amount) public {
186      require(msg.sender == admin);
187      minPurchase = _amount;
188   }
189 
190   function setSalePrice(uint256 _amount) public {
191      require(msg.sender == admin);
192      salePrice = _amount;
193   }
194 
195   function buyTokens() public payable{
196       _buyTokens(msg.value);
197   }
198 
199   function _buyTokens(uint256 _incomingEthereum) internal {
200      require(allowSale);
201      require(_incomingEthereum >= minPurchase);
202      uint256 tokensToBuy = _incomingEthereum.div(salePrice).mul(1e18);
203      require(tokensToBuy <= block.number * tokenFactor - _totalSupply);
204      require(tokensToBuy <= saleHardCap.sub(currentSaleAmount));
205      require(tokensToBuy <= _STAYKFund);
206      _STAYKTokenBalances[msg.sender] = _STAYKTokenBalances[msg.sender].add(tokensToBuy);
207      _STAYKFund = _STAYKFund.sub(tokensToBuy);
208      lastPay[msg.sender] = block.number;
209      currentSaleAmount = currentSaleAmount.add(tokensToBuy);
210      emit Transfer(address(this), msg.sender, tokensToBuy);
211   }
212 
213 
214   function getPaid() public {
215 
216      require(_STAYKTokenBalances[msg.sender] > 0);
217      require(lastPay[msg.sender] + payFreq <= block.number);
218      uint256 availableTokens = ((block.number).mul(tokenFactor * 1e18)).sub(_totalSupply);
219      uint256 payAmountSender = (_STAYKTokenBalances[msg.sender].mul(availableTokens)).div(_totalSupply);
220      _totalSupply = _totalSupply.add(payAmountSender);
221      _STAYKTokenBalances[msg.sender] = _STAYKTokenBalances[msg.sender].add(payAmountSender);
222      lastPay[msg.sender] = block.number;
223      emit Transfer(address(this), msg.sender, payAmountSender);
224   }
225 
226   function withdraw() public {
227     require(msg.sender == admin);
228     msg.sender.transfer(address(this).balance);
229   }
230 
231   function withdrawPartial(uint256 _amount) public {
232     require(msg.sender == admin);
233     require(_amount <= address(this).balance);
234     msg.sender.transfer(_amount);
235   }
236 
237   function distributeETH(address payable _to, uint256 _amount) public {
238      require(msg.sender == admin);
239      require(_amount <= address(this).balance);
240      require(_to != address(0));
241      _to.transfer(_amount);
242   }
243 
244 
245   function transfer(address to, uint256 value) public returns (bool) {
246     require(value <= _STAYKTokenBalances[msg.sender]);
247     require(to != address(0));
248 
249     uint256 STAYKTokenDecay = 0;
250     if (burnFactor != 0) {
251        STAYKTokenDecay = value.div(burnFactor); 
252     }
253     uint256 tokensToTransfer = value.sub(STAYKTokenDecay);
254 
255     _STAYKTokenBalances[msg.sender] = _STAYKTokenBalances[msg.sender].sub(value);
256     _STAYKTokenBalances[to] = _STAYKTokenBalances[to].add(tokensToTransfer);
257 
258     _totalSupply = _totalSupply.sub(STAYKTokenDecay);
259 
260     emit Transfer(msg.sender, to, tokensToTransfer);
261     if (burnFactor != 0) {
262        emit Transfer(msg.sender, address(0), STAYKTokenDecay);
263     }
264     
265     return true;
266   }
267 
268   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
269     for (uint256 i = 0; i < receivers.length; i++) {
270       transfer(receivers[i], amounts[i]);
271     }
272   }
273 
274  function multiSend(address[] memory receivers, uint256[] memory amounts) public {  
275     require(msg.sender == admin);
276     for (uint256 i = 0; i < receivers.length; i++) {
277       _STAYKTokenBalances[receivers[i]] = _STAYKTokenBalances[receivers[i]].add(amounts[i]);
278       _STAYKFund = _STAYKFund.sub(amounts[i]);
279       emit Transfer(address(this), receivers[i], amounts[i]);
280     }
281   }
282 
283   function approve(address spender, uint256 value) public returns (bool) {
284     require(spender != address(0));
285     _allowed[msg.sender][spender] = value;
286     emit Approval(msg.sender, spender, value);
287     return true;
288   }
289 
290   function transferFrom(address from, address to, uint256 value) public returns (bool) {
291     require(value <= _STAYKTokenBalances[from]);
292     require(value <= _allowed[from][msg.sender]);
293     require(to != address(0));
294 
295     _STAYKTokenBalances[from] = _STAYKTokenBalances[from].sub(value);
296 
297     uint256 STAYKTokenDecay =0;
298     if (burnFactor != 0) {
299        STAYKTokenDecay = value.div(burnFactor); 
300     } else {
301       STAYKTokenDecay = 0;
302     }
303     uint256 tokensToTransfer = value.sub(STAYKTokenDecay);
304 
305     _STAYKTokenBalances[to] = _STAYKTokenBalances[to].add(tokensToTransfer);
306     _totalSupply = _totalSupply.sub(STAYKTokenDecay);
307 
308     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
309 
310     //lastPay[to] = block.number;
311 
312     emit Transfer(from, to, tokensToTransfer);
313     if (burnFactor != 0) {
314        emit Transfer(from, address(0), STAYKTokenDecay);
315     }
316     
317 
318     return true;
319   }
320 
321   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
322     require(spender != address(0));
323     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
324     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
325     return true;
326   }
327 
328   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
329     require(spender != address(0));
330     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
331     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
332     return true;
333   }
334 
335   function burn(uint256 amount) public {
336     _burn(msg.sender, amount);
337   }
338 
339   function _burn(address account, uint256 amount) internal {
340     require(amount != 0);
341     require(amount <= _STAYKTokenBalances[account]);
342     _totalSupply = _totalSupply.sub(amount);
343     _STAYKTokenBalances[account] = _STAYKTokenBalances[account].sub(amount);
344     emit Transfer(account, address(0), amount);
345   }
346 
347   function burnFrom(address account, uint256 amount) external {
348     require(amount <= _allowed[account][msg.sender]);
349     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
350     _burn(account, amount);
351   }
352 
353   function distributeFund(address _to, uint256 _amount) public {
354       require(msg.sender == admin);
355       require(_amount <= _STAYKFund);
356       _STAYKFund = _STAYKFund.sub(_amount);
357       lastPay[_to] = block.number;
358       _STAYKTokenBalances[_to] = _STAYKTokenBalances[_to].add(_amount);
359       emit Transfer(address(this), _to, _amount);
360   }
361 
362 }