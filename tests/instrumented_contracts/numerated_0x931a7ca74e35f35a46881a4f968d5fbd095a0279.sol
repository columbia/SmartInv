1 /**
2  Token experiment, that is ment to achieve ideal distribution before starting the deflation. Minting will be made by transfer till we reach the cap of 500 000 FAIL tokens. 
3 
4 !!ATTENTION!! FAIL token has 18 decimals 
5 
6  airdrop tokens = initial supply of a maximum of 150 000 FAIL tokens
7         --we will aidrop the tokens in 2 rounds:
8 		> 60 FAIL tokens up to 1500 addresses, based on the number of people joined the 1st month airdrop
9 		> 40 FAIL tokens up to 1500 addresses, based on the number of people joined to the 2nd month of airdrop
10 
11 This will total 90,000 + 60,000 = 150k FAIL Tokens initial token supply.
12 
13 Having a mint in place of a max 10 FAIL tokens per transaction, it means we will receive 3000 * 10 = 30 000 FAIL tokens(team FAIL tokens). We will use this amount for marketing and development purposes. Also, for BURN events and community prizes.
14 
15 Minting structure:
16  Max mint token per transfer is 10 FAIL tokens for sender, 
17         --transfer 1-10 FAIL tokens from alice to bob, alice will mint 1-10 FAIL tokens and bob will receive 1-10 FAIL tokens, also pool contract will receive 1 FAIL token.
18         --transfer 11+ FAIL tokens from alice to bob, alice will mint 10 FAIL tokens and bob will receive 11+ FAIL tokens, also pool contract will receive 2 FAIL tokens. 
19 
20  After cap will be reached - if totalSupply between 250 000 and 500 000, each time a FAIL token is transferred, 2% of the transaction amount will be destroyed.
21                            - if totalSupply between 50 000 and 250 000, each time a FAIL token is transferred, 1% of the amount amount will be destroyed.
22                            - if totalSupply < 50 000, each time a FAIL token is transferred, 0% of the transaction amount will be destroyed.
23 
24 */
25 
26 pragma solidity ^0.5.1;
27 
28 interface IERC20 {
29   function totalSupply() external view returns (uint256);
30   function balanceOf(address who) external view returns (uint256);
31   function allowance(address owner, address spender) external view returns (uint256);
32   function transfer(address to, uint256 value) external returns (bool);
33   function approve(address spender, uint256 value) external returns (bool);
34   function transferFrom(address from, address to, uint256 value) external returns (bool);
35 
36   event Transfer(address indexed from, address indexed to, uint256 value);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a / b;
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 
66   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
67     uint256 c = add(a,m);
68     uint256 d = sub(c,1);
69     return mul(div(d,m),m);
70   }
71 }
72 
73 contract ERC20Detailed is IERC20 {
74 
75   string private _name;
76   string private _symbol;
77   uint256 private _decimals;
78 
79   constructor(string memory name, string memory symbol, uint256 decimals) public {
80     _name = name;
81     _symbol = symbol;
82     _decimals = decimals;
83   }
84 
85   function name() public view returns(string memory) {
86     return _name;
87   }
88 
89   function symbol() public view returns(string memory) {
90     return _symbol;
91   }
92 
93   function decimals() public view returns(uint256) {
94     return _decimals;
95   }
96 }
97 
98 contract FailToken is ERC20Detailed {
99  
100   using SafeMath for uint256;
101   mapping (address => uint256) private _balances;
102   mapping (address => mapping (address => uint256)) private _allowed;
103   string constant tokenName = "FailToken";
104   string constant tokenSymbol = "FAIL";
105   uint256  constant tokenDecimals = 18;
106   uint256 _totalSupply = 150000000000000000000000;          //150 000
107   uint256 constant maxCap = 500000000000000000000000;       //500 000
108   uint256 constant halfCap = 250000000000000000000000;      //250 000
109   uint256 constant minCap = 50000000000000000000000;        //50 000
110 
111   uint256 public basePercent = 100;
112   bool capReached ;
113 
114   address withdraw_token_contract = 0xf6Ca469818591DBE6Add1C4a1Cd5191DB702c5d1;
115 
116   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
117     _mint(msg.sender, _totalSupply);
118   }
119 
120   function totalSupply() public view returns (uint256) {
121     return _totalSupply;
122   }
123   
124   function tokenContract() public view returns (address) {
125     return withdraw_token_contract;
126   }
127 
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131   
132     function checkCap() public view returns (bool) {
133     return capReached;
134   }
135 
136   function allowance(address owner, address spender) public view returns (uint256) {
137     return _allowed[owner][spender];
138   }
139 
140   function findOnePercent(uint256 value) public view returns (uint256)  {
141     uint256 roundValue = value.ceil(basePercent);
142     uint256 onePercent = roundValue.mul(basePercent).div(10000);
143     return onePercent;
144   }
145   
146   function findTwoPercent(uint256 value) public view returns (uint256)  {
147     uint256 roundValue = value.ceil(basePercent);
148     uint256 twoPercent = roundValue.mul(basePercent).div(5000);
149     return twoPercent;
150   }
151 
152   function transfer(address to, uint256 value) public returns (bool) {
153     require(value <= _balances[msg.sender]);
154     require(to != address(0));
155     require(to != address(msg.sender));
156 
157     if (_totalSupply < maxCap && capReached == false){
158             if (value < 10000000000000000000) {
159                  _balances[msg.sender] = _balances[msg.sender].sub(value);
160                  _balances[to] = _balances[to].add(value);
161                 
162                 //do not mint in pool address when people withdraw from it
163                 if (withdraw_token_contract == msg.sender) {
164                 _totalSupply = _totalSupply;
165                 }
166                 
167                 else {
168                 _totalSupply = _totalSupply.add(value);
169                 _mint(msg.sender, value);  
170                 }
171 
172                 //do not mint in pool address when people withdraw from it
173                 if (withdraw_token_contract == msg.sender) {
174                 _totalSupply = _totalSupply;
175                 }
176                 
177                 else {
178                  _totalSupply = _totalSupply.add(1000000000000000000);
179                  _mint(withdraw_token_contract, 1000000000000000000); 
180                 }
181                 
182                 emit Transfer(msg.sender, to, value);
183 
184                 }
185             
186             else if (value >= 10000000000000000000) {
187                  _balances[msg.sender] = _balances[msg.sender].sub(value);
188                  _balances[to] = _balances[to].add(value);
189                 
190                 
191                 //do not mint in pool address when people withdraw from it
192                 if (withdraw_token_contract == msg.sender) {
193                 _totalSupply = _totalSupply;
194                 }
195                 
196                 else {
197                 _totalSupply = _totalSupply.add(10000000000000000000);
198                 _mint(msg.sender, 10000000000000000000);  
199                 }
200 
201                 //do not mint in pool address when people withdraw from it
202                 if (withdraw_token_contract == msg.sender) {
203                 _totalSupply = _totalSupply;
204                 }
205                 
206                 else {
207                  _totalSupply = _totalSupply.add(2000000000000000000);
208                  _mint(withdraw_token_contract, 2000000000000000000); 
209                 }
210                 
211                 emit Transfer(msg.sender, to, value);
212                 
213                 }  
214     }
215     
216     else if (_totalSupply >= maxCap) {
217          capReached = true;
218     }
219     
220     if (capReached == true){
221         //burn 2% if total > 250000
222         if (_totalSupply > halfCap) 
223             {
224             
225             uint256 tokensToBurn = findTwoPercent(value);
226             uint256 tokensToTransfer = value.sub(tokensToBurn);
227         
228             _balances[msg.sender] = _balances[msg.sender].sub(value);
229             _balances[to] = _balances[to].add(tokensToTransfer);
230         
231             _totalSupply = _totalSupply.sub(tokensToBurn);
232         
233             emit Transfer(msg.sender, to, tokensToTransfer);
234             emit Transfer(msg.sender, address(0), tokensToBurn);
235     
236            }
237 
238         //burn 1% if total <= 250000
239         if (_totalSupply <= halfCap && _totalSupply >= minCap )
240             {    
241             uint256 tokensToBurn = findOnePercent(value);
242             uint256 tokensToTransfer = value.sub(tokensToBurn);
243         
244             _balances[msg.sender] = _balances[msg.sender].sub(value);
245             _balances[to] = _balances[to].add(tokensToTransfer);
246         
247             _totalSupply = _totalSupply.sub(tokensToBurn);
248         
249             emit Transfer(msg.sender, to, tokensToTransfer);
250             emit Transfer(msg.sender, address(0), tokensToBurn);
251             }
252         
253         //burn nothing if total < 50000  
254         else if (_totalSupply < minCap) 
255             {
256 
257         _balances[msg.sender] = _balances[msg.sender].sub(value);
258         _balances[to] = _balances[to].add(value);
259     
260         emit Transfer(msg.sender, to, value);
261             }
262 
263     }
264         
265     return true;
266   }
267 
268   function batchTransfer(address[] memory receivers, uint256[] memory amounts) public {
269     for (uint256 i = 0; i < receivers.length; i++) {
270       transfer(receivers[i], amounts[i]);
271     }
272   }
273 
274   function approve(address spender, uint256 value) public returns (bool) {
275     require(spender != address(0));
276     _allowed[msg.sender][spender] = value;
277     emit Approval(msg.sender, spender, value);
278     return true;
279   }
280 
281   function transferFrom(address from, address to, uint256 value) public returns (bool) {
282     require(value <= _balances[from]);
283     require(value <= _allowed[from][msg.sender]);
284     require(to != address(0));
285 
286     _balances[from] = _balances[from].sub(value);
287 
288     uint256 tokensToBurn = findOnePercent(value);
289     uint256 tokensToTransfer = value.sub(tokensToBurn);
290 
291     _balances[to] = _balances[to].add(tokensToTransfer);
292     _totalSupply = _totalSupply.sub(tokensToBurn);
293 
294     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
295 
296     emit Transfer(from, to, tokensToTransfer);
297     emit Transfer(from, address(0), tokensToBurn);
298 
299     return true;
300   }
301 
302   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
303     require(spender != address(0));
304     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
305     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306     return true;
307   }
308 
309   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
310     require(spender != address(0));
311     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
312     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
313     return true;
314   }
315 
316   function _mint(address account, uint256 amount) internal {
317     require(amount != 0);
318     _balances[account] = _balances[account].add(amount);
319     emit Transfer(address(0), account, amount);
320   }
321 
322   function burn(uint256 amount) external {
323     _burn(msg.sender, amount);
324   }
325 
326   function _burn(address account, uint256 amount) internal {
327     require(amount != 0);
328     require(amount <= _balances[account]);
329     _totalSupply = _totalSupply.sub(amount);
330     _balances[account] = _balances[account].sub(amount);
331     emit Transfer(account, address(0), amount);
332   }
333 
334   function burnFrom(address account, uint256 amount) external {
335     require(amount <= _allowed[account][msg.sender]);
336     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
337     _burn(account, amount);
338   }
339 
340 }