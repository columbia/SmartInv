1 /**
2  *TILWIKI Global Ecosystem project by Anaida Schneider. All rights reserved.
3 */
4 
5 pragma solidity ^0.6.0;
6 
7 contract Context {
8     constructor () internal { }
9 
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode
16         return msg.data;
17     }
18 }
19 
20 
21 
22 interface IERC20 {
23     /**
24      * Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * Emitted when `value` tokens are moved from one account (`from`) to
50      * another (`to`).
51       */
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     /**
55      * Emitted when the allowance of a `spender` for an `owner` is set by
56      * a call to {approve}. `value` is the new allowance.
57      */
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 
63  
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * Returns the multiplication of two unsigned integers, reverting on
85      * overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104             require(b > 0, errorMessage);
105         uint256 c = a / b;
106 
107         return c;
108     }
109 
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         return mod(a, b, "SafeMath: modulo by zero");
112     }
113 
114      
115     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b != 0, errorMessage);
117         return a % b;
118     }
119 }
120 
121 
122 
123 contract ERC20 is Context, IERC20 {
124     using SafeMath for uint256;
125 
126     mapping (address => uint256) private _balances;
127 
128     mapping (address => mapping (address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     /**
133      * See {IERC20-totalSupply}.
134      */
135     function totalSupply() public view override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     /**
140      * See {IERC20-balanceOf}.
141      */
142     function balanceOf(address account) public view override returns (uint256) {
143         return _balances[account];
144     }
145 
146     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     /**
152      * See {IERC20-allowance}.
153      */
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) public virtual override returns (bool) {
159         _approve(_msgSender(), spender, amount);
160         return true;
161     }
162 
163     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
164         _transfer(sender, recipient, amount);
165         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
166         return true;
167     }
168 
169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
171         return true;
172     }
173 
174 
175      
176     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
177         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
178         return true;
179     }
180 
181 
182     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
183         require(sender != address(0), "ERC20: transfer from the zero address");
184         require(recipient != address(0), "ERC20: transfer to the zero address");
185 
186         _beforeTokenTransfer(sender, recipient, amount);
187 
188         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
189         _balances[recipient] = _balances[recipient].add(amount);
190         emit Transfer(sender, recipient, amount);
191     }
192 
193 
194     function _mint(address account, uint256 amount) internal virtual {
195         require(account != address(0), "ERC20: mint to the zero address");
196 
197         _beforeTokenTransfer(address(0), account, amount);
198 
199         _totalSupply = _totalSupply.add(amount);
200         _balances[account] = _balances[account].add(amount);
201         emit Transfer(address(0), account, amount);
202     }
203 
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206 
207         _beforeTokenTransfer(account, address(0), amount);
208 
209         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
210         _totalSupply = _totalSupply.sub(amount);
211         emit Transfer(account, address(0), amount);
212     }
213 
214 
215     function _approve(address owner, address spender, uint256 amount) internal virtual {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218 
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223 
224     function _burnFrom(address account, uint256 amount) internal virtual {
225         _burn(account, amount);
226         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
227     }
228 
229 
230     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
231 }
232 
233 
234 
235 
236 contract TLWToken is ERC20 {
237     string public constant name = "TILWIKI - Faces of Art";
238     string public constant symbol = "TLW";
239     uint8 public constant decimals = 8;
240     uint256 public INITIAL_SUPPLY = 0;
241     address public CrowdsaleAddress;
242     bool public lockMint = false;
243     uint256 public MaxSupply = 79797979 * 10**8 ; //max supply
244 
245     constructor(address _CrowdsaleAddress) public {
246         CrowdsaleAddress = _CrowdsaleAddress;
247     }
248 
249     modifier onlyOwner() {
250         // only Crowdsale contract
251         require(_msgSender() == CrowdsaleAddress, "Only from Crowdsale contract");
252         _;
253     }
254 
255     function lockMintForever() public onlyOwner {
256         lockMint = true;
257     }
258 
259     /** 
260      * Override
261      */
262     function mint(address _to, uint256 _value) public onlyOwner returns (bool){
263         require(!lockMint, "Mint is locked forever.");
264         uint256 result = totalSupply() + _value;
265         require(result <= MaxSupply,"Result Above Limit");
266         _mint(_to, _value);
267         return true;
268     }
269     
270         /** 
271      * Override
272      */
273     function burn(uint256 _value) public returns (bool){
274         _burn(_msgSender(), _value);
275         return true;
276     }
277 
278     fallback() external payable {
279         revert("The token contract don`t receive ether");
280     }  
281     receive() external payable {
282         revert("The token contract don`t receive ether");
283     }
284 }