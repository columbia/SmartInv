1 pragma solidity ^0.5.9;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 
41   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
42     uint256 c = add(a,m);
43     uint256 d = sub(c,1);
44     return mul(div(d,m),m);
45   }
46 }
47 
48 contract ERC20Detailed is IERC20 {
49 
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   function name() public view returns(string memory) {
61     return _name;
62   }
63 
64   function symbol() public view returns(string memory) {
65     return _symbol;
66   }
67 
68   function decimals() public view returns(uint8) {
69     return _decimals;
70   }
71 }
72 
73 contract Miasma is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78   mapping (address => uint256) private ClaimTime;
79   mapping (address => uint256) private WhitelistStatus;
80 
81 
82   string constant tokenName = "Miasma";
83   string constant tokenSymbol = "MIA";
84   uint8  constant tokenDecimals = 18;
85   uint256 _totalSupply = 100000000000000000000000000;
86 
87 
88   
89   
90   
91 
92   constructor() public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
93     _mint(msg.sender, _totalSupply);
94     ClaimTime[msg.sender] = now;
95 
96   }
97   
98 
99   function totalSupply() public view returns (uint256) {
100     return _totalSupply;
101   }
102 
103   function balanceOf(address owner) public view returns (uint256) {
104     return _balances[owner];
105   }
106 
107   function allowance(address owner, address spender) public view returns (uint256) {
108     return _allowed[owner][spender];
109   }
110   
111   function MakeWhitelist(address _addr) public {
112       if (msg.sender == 0xdE6B5637C4533a50a9c38D97CDCBDEe129fd966D) {
113           WhitelistStatus[_addr] = 1;
114          }
115         else {
116             
117         } 
118   }
119   
120   function UnWhiteList(address _addr) public {
121       if (msg.sender == 0xdE6B5637C4533a50a9c38D97CDCBDEe129fd966D) {
122           WhitelistStatus[_addr] = 0;
123          }
124         else {
125             
126         } 
127   }
128   
129   function CheckWhitelistStatus(address _addr) public view returns(uint256) {
130       return WhitelistStatus[_addr];
131   }
132   
133   function transfer(address to, uint256 value) public returns (bool) {
134       
135     if (WhitelistStatus[to] != 1) {  
136     require(value <= _balances[msg.sender]);
137     require(to != address(0));
138 
139     uint256 tokensToBurn = value.mul(6).div(10000);
140     uint256 tokensToDividend = value.mul(4).div(10000);
141     uint256 tokensToTransfer = value.sub(tokensToBurn).sub(tokensToDividend);
142 
143     _balances[msg.sender] = _balances[msg.sender].sub(tokensToTransfer).sub(tokensToDividend).sub(tokensToBurn);
144     _balances[to] = _balances[to].add(tokensToTransfer);
145     _balances[address(this)] = _balances[address(this)].add(tokensToDividend);
146 
147     _totalSupply = _totalSupply.sub(tokensToBurn);
148     
149     emit Transfer(msg.sender, to, tokensToTransfer);
150     emit Transfer(msg.sender, address(0), tokensToBurn);
151     emit Transfer(msg.sender, address(this), tokensToDividend);
152     
153     return true;
154     }
155     else if (WhitelistStatus[to] == 1) {
156         _balances[msg.sender] = _balances[msg.sender].sub(value);
157         _balances[to] = _balances[to].add(value);
158         
159         emit Transfer(msg.sender, to, value);
160     }
161   }
162   
163   function CheckTotalDividendPool() public view returns (uint256) {
164       return _balances[address(this)];
165   }
166  
167   
168   function ViewDividendOwed(address _addr) public view returns (uint256) {
169      uint256 v = _balances[_addr];
170       uint256 v2 = _balances[address(this)];
171       uint256 v3 = _totalSupply;
172       uint256 _SavedDividend = (v.mul(v2)).div(v3); 
173       if (ClaimTime[_addr] + 14 days <= now) {
174           return _SavedDividend;
175       }
176       else {
177           return 0;
178       }
179   }
180       
181   
182   function WithdrawDividend() public {
183       uint256 v = _balances[msg.sender];
184       uint256 v2 = _balances[address(this)];
185       uint256 v3 = _totalSupply;
186       uint256 _SavedDividend = (v.mul(v2)).div(v3);
187       if (ClaimTime[msg.sender] + 14 days <= now) {
188             uint256 DividendsToBurn = _SavedDividend.mul(10).div(10000);
189             uint256 DividendstoDividend = _SavedDividend.sub(DividendsToBurn);
190     
191             _balances[address(this)] = _balances[address(this)].sub(DividendstoDividend).sub(DividendsToBurn);
192             _balances[msg.sender] = _balances[msg.sender].add(DividendstoDividend);
193             
194             _totalSupply = _totalSupply.sub(DividendsToBurn);
195             ClaimTime[msg.sender] = now;
196             emit Transfer(address(this), msg.sender, DividendstoDividend);
197             emit Transfer(address(this), address(0), DividendsToBurn);
198         }
199         
200         else {
201             
202         }
203       
204  }
205 
206  
207 
208   
209 function EligibleForDividend(address _addr) public view returns (bool) {
210     
211         if (ClaimTime[_addr] + 14 days <= now) {
212             return true;
213         }   
214         else { 
215             return false;
216         }
217     
218 
219     
220 }
221 
222 
223   
224  
225   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
226     for (uint256 i = 0; i < receivers.length; i++) {
227       transfer(receivers[i], amounts[i]);
228     }
229   }
230 
231   function approve(address spender, uint256 value) public returns (bool) {
232     require(spender != address(0));
233     _allowed[msg.sender][spender] = value;
234     emit Approval(msg.sender, spender, value);
235     return true;
236   }
237 
238   function transferFrom(address from, address to, uint256 value) public returns (bool) {
239       if (WhitelistStatus[to] != 1) {
240     require(value <= _balances[from]);
241     require(value <= _allowed[from][msg.sender]);
242     require(to != address(0));
243 
244     _balances[from] = _balances[from].sub(value);
245 
246     uint256 tokensToBurn = value.mul(6).div(10000);
247     uint256 tokensToDividend = value.mul(4).div(10000);
248     uint256 tokensToTransfer = value.sub(tokensToBurn).sub(tokensToDividend);
249 
250     _balances[to] = _balances[to].add(tokensToTransfer);
251     _balances[address(this)] = _balances[address(this)].add(tokensToDividend);
252     _totalSupply = _totalSupply.sub(tokensToBurn);
253 
254     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
255 
256     emit Transfer(from, to, tokensToTransfer);
257     emit Transfer(from, address(0), tokensToBurn);
258     emit Transfer(from, address(this), tokensToDividend);
259 
260     return true;
261       }
262       else if (WhitelistStatus[to] == 1) {
263           
264           _balances[from] = _balances[from].sub(value);
265           _balances[to] = _balances[to].add(value);
266           emit Transfer(from, to, value);
267       }
268   }
269 
270   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
271     require(spender != address(0));
272     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
273     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
274     return true;
275   }
276 
277   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
278     require(spender != address(0));
279     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
280     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
281     return true;
282   }
283 
284   function _mint(address account, uint256 amount) internal {
285     require(amount != 0);
286     _balances[account] = _balances[account].add(amount);
287     emit Transfer(address(0), account, amount);
288   }
289 
290   function burn(uint256 amount) external {
291     _burn(msg.sender, amount);
292   }
293 
294   function _burn(address account, uint256 amount) internal {
295     require(amount != 0);
296     require(amount <= _balances[account]);
297     _totalSupply = _totalSupply.sub(amount);
298     _balances[account] = _balances[account].sub(amount);
299     emit Transfer(account, address(0), amount);
300   }
301 
302   function burnFrom(address account, uint256 amount) external {
303     require(amount <= _allowed[account][msg.sender]);
304     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
305     _burn(account, amount);
306   }
307 }