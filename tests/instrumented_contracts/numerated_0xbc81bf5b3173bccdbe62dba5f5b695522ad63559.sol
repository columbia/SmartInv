1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 interface IERC20_transmute {
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     
13     function burn(uint256 amount) external;
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     
21     function burnFrom(address account, uint256 amount) external;
22     
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26     
27     function viewTimeExceed(address account) external view returns (uint32);
28 }
29 
30 
31 library SafeMath {
32     
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61 
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74         return c;
75     }
76 
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         return mod(a, b, "SafeMath: modulo by zero");
79     }
80 
81     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b != 0, errorMessage);
83         return a % b;
84     }
85 }
86 
87 
88 contract XPb_token is IERC20_transmute {
89     using SafeMath for uint256;
90     
91     mapping (address => uint256) private _balances;
92 
93     mapping (address => mapping (address => uint256)) private _allowances;
94     
95     mapping (address => uint32) private _timeExceeded;    // array of timestamps when specific accts balances exceede minBalReq
96 
97     uint256 private _totalSupply;
98     
99     uint256 private _initialSupply = 2000000e18;  // 2M
100 
101     uint256 private _minBalReq = 1000e18;  // 1k
102 
103     string private _name = "Lead Token";
104     
105     string private _symbol = "XPb";
106     
107     uint8 private _decimals = 18;
108     
109     address private _owner = 0xA91B501e356a60deE0f1927B377C423Cfeda4d1E;
110     
111     bool public allowUniswap = false;
112     
113     address public UniswapPair;
114 
115     event OwnershipTransferred( address indexed previousOwner, address indexed newOwner);
116     
117     event UniPairSetup( address indexed previousPair, address indexed newPair);
118     
119     event UniToggled( bool toggle);
120   
121     constructor ()  {
122         
123         _mint(_owner, _initialSupply);
124         
125     }
126 
127     modifier onlyOwner() {
128         require(isOwner(msg.sender));
129         _;
130     }
131 
132     function isOwner(address account) public view returns(bool) {
133         return account == _owner;
134     }
135     
136     function viewOwner() public view returns(address) {
137     return _owner;
138     }
139     
140     function transferOwnership(address newOwner) public onlyOwner  {
141         
142     _transferOwnership(newOwner);
143     }
144 
145   function _transferOwnership(address newOwner)  internal {
146       emit OwnershipTransferred(_owner, newOwner);
147     _owner = newOwner;
148     
149   }
150   
151   function setUniPair(address pair) public onlyOwner  {
152         
153     _setUniPair(pair);
154     }
155 
156   function _setUniPair(address pair)  internal {
157       emit UniPairSetup(UniswapPair, pair);
158     UniswapPair = pair;
159     
160   }
161   
162   function toggleUniswap() public onlyOwner  {
163         
164     _toggleUniswap();
165     }
166 
167   function _toggleUniswap()  internal {
168       
169       if(allowUniswap == true){
170           allowUniswap = false;
171       } else {
172           allowUniswap = true;
173       }
174     emit UniToggled(allowUniswap);
175     
176   }
177     
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view returns (string memory) {
182         return _name;
183     }
184 
185 
186     function symbol() public view returns (string memory) {
187         return _symbol;
188     }
189 
190 
191     function decimals() public view returns (uint8) {
192         return _decimals;
193     }
194 
195 
196     function totalSupply() public view override returns (uint256) {
197         return _totalSupply;
198     }
199 
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return _balances[account];
203     }
204 
205     function viewTimeExceed(address account) public view override returns (uint32) {
206         return _timeExceeded[account];
207     }
208 
209     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
210         _transfer(msg.sender, recipient, amount);
211         return true;
212     }
213 
214 
215     function allowance(address owner, address spender) public view virtual override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219 
220     function approve(address spender, uint256 amount) public virtual override returns (bool) {
221         _approve(msg.sender, spender, amount);
222         return true;
223     }
224 
225 
226     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
227         _transfer(sender, recipient, amount);
228         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
229         return true;
230     }
231 
232     function burn(uint256 amount) public virtual override {
233         _burn(msg.sender, amount);
234     }
235 
236     function burnFrom(address account, uint256 amount) public virtual override {
237         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "ERC20: burn amount exceeds allowance");
238 
239         _approve(account, msg.sender, decreasedAllowance);
240         _burn(account, amount);
241     }
242     
243     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
244         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
245         return true;
246     }
247 
248 
249     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
250         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
251         return true;
252     }
253 
254 
255 
256     // modified Transfer Function to log times @ accts balances exceed minReqBal, for Sublimation Pool
257     // modified Transfer Function to safeguard Uniswap liquidity during token sale
258 
259     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
260         
261         if(allowUniswap == false && sender != _owner && recipient == UniswapPair ){
262             revert("UNI_LIQ_PLAY_NOT_YET");
263         } else {
264             
265         require(sender != address(0), "ERC20: transfer from the zero address");
266         require(recipient != address(0), "ERC20: transfer to the zero address");
267 
268         _beforeTokenTransfer(sender, recipient, amount);
269         
270         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
271         
272         bool isOverReq = false;
273 
274         if(_balances[recipient] >= _minBalReq){
275 
276             isOverReq = true;
277         }
278         
279         _balances[recipient] = _balances[recipient].add(amount);
280         
281         if(_balances[recipient] >= _minBalReq && isOverReq == false){
282             
283                 _timeExceeded[recipient] = uint32(block.timestamp);
284             }
285         
286         emit Transfer(sender, recipient, amount);
287         }
288     }
289 
290 
291     function _mint(address account, uint256 amount) internal virtual {
292         require(account != address(0), "ERC20: mint to the zero address");
293 
294         _beforeTokenTransfer(address(0), account, amount);
295 
296         _totalSupply = _totalSupply.add(amount);
297         _balances[account] = _balances[account].add(amount);
298         emit Transfer(address(0), account, amount);
299     }
300 
301 
302     function _burn(address account, uint256 amount) internal virtual {
303         require(account != address(0), "ERC20: burn from the zero address");
304 
305         _beforeTokenTransfer(account, address(0), amount);
306 
307         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
308         _totalSupply = _totalSupply.sub(amount);
309         emit Transfer(account, address(0), amount);
310     }
311 
312 
313     function _approve(address owner, address spender, uint256 amount) internal virtual {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316 
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320     
321     function _setupDecimals(uint8 decimals_) internal {
322         _decimals = decimals_;
323     }
324 
325     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
326 }