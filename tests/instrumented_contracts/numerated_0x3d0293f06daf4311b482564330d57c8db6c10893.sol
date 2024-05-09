1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IERC20 {
5     
6     function totalSupply() external view returns (uint256);
7 
8    
9     function balanceOf(address account) external view returns (uint256);
10 
11    
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14    
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17    
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 library SafeMath {
40     
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44 
45         return c;
46     }
47 
48    
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53    
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     
82     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b > 0, errorMessage);
84         uint256 c = a / b;
85         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86 
87         return c;
88     }
89 
90    
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         return mod(a, b, "SafeMath: modulo by zero");
93     }
94 
95     
96     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b != 0, errorMessage);
98         return a % b;
99     }
100 }
101 
102 contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     /**
108      * @dev Initializes the contract setting the deployer as the initial owner.
109      */
110     constructor () internal {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         emit OwnershipTransferred(address(0), msgSender);
114     }
115 
116     /**
117      * @dev Returns the address of the current owner.
118      */
119     function owner() public view returns (address) {
120         return _owner;
121     }
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         require(_owner == _msgSender(), "Ownable: caller is not the owner");
128         _;
129     }
130 
131     /**
132      * @dev Leaves the contract without owner. It will not be possible to call
133      * `onlyOwner` functions anymore. Can only be called by the current owner.
134      *
135      * NOTE: Renouncing ownership will leave the contract without an owner,
136      * thereby removing any functionality that is only available to the owner.
137      */
138     function renounceOwnership() public virtual onlyOwner {
139         emit OwnershipTransferred(_owner, address(0));
140         _owner = address(0);
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      * Can only be called by the current owner.
146      */
147     function transferOwnership(address newOwner) public virtual onlyOwner {
148         require(newOwner != address(0), "Ownable: new owner is the zero address");
149         emit OwnershipTransferred(_owner, newOwner);
150         _owner = newOwner;
151     }
152 }
153 
154 
155 
156 
157 contract YCoin is Context, IERC20, Ownable {
158     using SafeMath for uint256;
159 
160     mapping (address => uint256) private _balances;
161 
162     mapping (address => mapping (address => uint256)) private _allowances;
163 
164     uint256 private _totalSupply;
165 
166     string private _name;
167     string private _symbol;
168     uint8 private _decimals;
169 
170     
171     constructor () public {
172         _name = "Y Coin";
173         _symbol = "YCO";
174         _decimals = 8;
175         _totalSupply = 10000* 10**uint(_decimals);
176         _balances[msg.sender] = _totalSupply;
177 
178     }
179 
180    
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
205     
206     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211    
212     function allowance(address owner, address spender) public view virtual override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216    
217      
218     function approve(address spender, uint256 amount) public virtual override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222     
223     function mint (address account, uint256 amount) public onlyOwner {
224         _mint(account,amount);
225     }
226 
227     
228     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
229         _transfer(sender, recipient, amount);
230         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
231         return true;
232     }
233 
234     
235     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
236         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
237         return true;
238     }
239 
240     
241     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
242         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
243         return true;
244     }
245 
246    
247     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
248         require(sender != address(0), "ERC20: transfer from the zero address");
249         require(recipient != address(0), "ERC20: transfer to the zero address");
250 
251         _beforeTokenTransfer(sender, recipient, amount);
252 
253         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
254         _balances[recipient] = _balances[recipient].add(amount);
255         emit Transfer(sender, recipient, amount);
256     }
257     function _mint(address account, uint256 amount) internal virtual {
258         require(account != address(0), "ERC20: mint to the zero address");
259 
260         _beforeTokenTransfer(address(0), account, amount);
261 
262         _totalSupply = _totalSupply.add(amount);
263         _balances[account] = _balances[account].add(amount);
264         emit Transfer(address(0), account, amount);
265     }
266 
267    
268     function _burn(address account, uint256 amount) internal virtual {
269         require(account != address(0), "ERC20: burn from the zero address");
270 
271         _beforeTokenTransfer(account, address(0), amount);
272 
273         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
274         _totalSupply = _totalSupply.sub(amount);
275         emit Transfer(account, address(0), amount);
276     }
277     function burn (uint256 amount) public onlyOwner {
278         _burn(msg.sender,amount);
279     }
280 
281     
282     function _approve(address owner, address spender, uint256 amount) internal virtual {
283         require(owner != address(0), "ERC20: approve from the zero address");
284         require(spender != address(0), "ERC20: approve to the zero address");
285 
286         _allowances[owner][spender] = amount;
287         emit Approval(owner, spender, amount);
288     }
289 
290     
291     function _setupDecimals(uint8 decimals_) internal {
292         _decimals = decimals_;
293     }
294 
295         function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
296 }