1 pragma solidity ^0.8.0;
2 
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module which provides a basic access control mechanism, where
19  * there is an account (an owner) that can be granted exclusive access to
20  * specific functions.
21  *
22  * By default, the owner account will be the one that deploys the contract. This
23  * can later be changed with {transferOwnership}.
24  *
25  * This module is used through inheritance. It will make available the modifier
26  * `onlyOwner`, which can be applied to your functions to restrict their use to
27  * the owner.
28  */
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev Initializes the contract setting the deployer as the initial owner.
36      */
37     constructor() {
38         _transferOwnership(_msgSender());
39     }
40 
41     /**
42      * @dev Returns the address of the current owner.
43      */
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     /**
57      * @dev Leaves the contract without owner. It will not be possible to call
58      * `onlyOwner` functions anymore. Can only be called by the current owner.
59      *
60      * NOTE: Renouncing ownership will leave the contract without an owner,
61      * thereby removing any functionality that is only available to the owner.
62      */
63     function renounceOwnership() public virtual onlyOwner {
64         _transferOwnership(address(0));
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         _transferOwnership(newOwner);
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Internal function without access restriction.
79      */
80     function _transferOwnership(address newOwner) internal virtual {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 pragma solidity ^0.8.0;
88 
89 
90 interface IERC20 {
91     
92     function totalSupply() external view returns (uint256);
93 
94     
95     function balanceOf(address account) external view returns (uint256);
96 
97     
98     function transfer(address recipient, uint256 amount) external returns (bool);
99 
100     
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) external returns (bool);
111 
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 pragma solidity ^0.8.0;
118 
119 interface IERC20Metadata is IERC20 {
120    
121     function name() external view returns (string memory);
122 
123     function symbol() external view returns (string memory);
124 
125     function decimals() external view returns (uint8);
126 }
127 
128 pragma solidity ^0.8.0;
129 
130 contract ERC20 is Context, IERC20, IERC20Metadata {
131     mapping(address => uint256) private _balances;
132 
133     mapping(address => mapping(address => uint256)) private _allowances;
134 
135     uint256 private _totalSupply;
136 
137     string private _name;
138     string private _symbol;
139 
140     
141     constructor(string memory name_, string memory symbol_) {
142         _name = name_;
143         _symbol = symbol_;
144     }
145 
146     function name() public view virtual override returns (string memory) {
147         return _name;
148     }
149 
150     function symbol() public view virtual override returns (string memory) {
151         return _symbol;
152     }
153 
154     function decimals() public view virtual override returns (uint8) {
155         return 18;
156     }
157 
158     function totalSupply() public view virtual override returns (uint256) {
159         return _totalSupply;
160     }
161 
162     function balanceOf(address account) public view virtual override returns (uint256) {
163         return _balances[account];
164     }
165 
166     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
167         _transfer(_msgSender(), recipient, amount);
168         return true;
169     }
170 
171     function allowance(address owner, address spender) public view virtual override returns (uint256) {
172         return _allowances[owner][spender];
173     }
174 
175     function approve(address spender, uint256 amount) public virtual override returns (bool) {
176         _approve(_msgSender(), spender, amount);
177         return true;
178     }
179 
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) public virtual override returns (bool) {
185         _transfer(sender, recipient, amount);
186 
187         uint256 currentAllowance = _allowances[sender][_msgSender()];
188         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
189         unchecked {
190             _approve(sender, _msgSender(), currentAllowance - amount);
191         }
192 
193         return true;
194     }
195 
196     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
197         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
198         return true;
199     }
200 
201     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
202         uint256 currentAllowance = _allowances[_msgSender()][spender];
203         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
204         unchecked {
205             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
206         }
207 
208         return true;
209     }
210 
211     function _transfer(
212         address sender,
213         address recipient,
214         uint256 amount
215     ) internal virtual {
216         require(sender != address(0), "ERC20: transfer from the zero address");
217         require(recipient != address(0), "ERC20: transfer to the zero address");
218 
219         _beforeTokenTransfer(sender, recipient, amount);
220 
221         uint256 senderBalance = _balances[sender];
222         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
223         unchecked {
224             _balances[sender] = senderBalance - amount;
225         }
226         _balances[recipient] += amount;
227 
228         emit Transfer(sender, recipient, amount);
229 
230         _afterTokenTransfer(sender, recipient, amount);
231     }
232 
233     function _mint(address account, uint256 amount) internal virtual {
234         require(account != address(0), "ERC20: mint to the zero address");
235 
236         _beforeTokenTransfer(address(0), account, amount);
237 
238         _totalSupply += amount;
239         _balances[account] += amount;
240         emit Transfer(address(0), account, amount);
241 
242         _afterTokenTransfer(address(0), account, amount);
243     }
244 
245     function _burn(address account, uint256 amount) internal virtual {
246         require(account != address(0), "ERC20: burn from the zero address");
247 
248         _beforeTokenTransfer(account, address(0), amount);
249 
250         uint256 accountBalance = _balances[account];
251         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
252         unchecked {
253             _balances[account] = accountBalance - amount;
254         }
255         _totalSupply -= amount;
256 
257         emit Transfer(account, address(0), amount);
258 
259         _afterTokenTransfer(account, address(0), amount);
260     }
261 
262     function _approve(
263         address owner,
264         address spender,
265         uint256 amount
266     ) internal virtual {
267         require(owner != address(0), "ERC20: approve from the zero address");
268         require(spender != address(0), "ERC20: approve to the zero address");
269 
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     function _beforeTokenTransfer(
275         address from,
276         address to,
277         uint256 amount
278     ) internal virtual {}
279 
280     function _afterTokenTransfer(
281         address from,
282         address to,
283         uint256 amount
284     ) internal virtual {}
285 }
286 
287 
288 // File contracts/HasbullaToken.sol
289 
290 
291 
292 pragma solidity ^0.8.0;
293 
294 
295 contract HasbullaToken is Ownable, ERC20 {
296     bool public limited;
297     uint256 public maxHoldingAmount;
298     uint256 public minHoldingAmount;
299     address public uniswapV2Pair;
300     mapping(address => bool) public blacklists;
301 
302     constructor(uint256 _totalSupply) ERC20("Hasbulla", "HASBULLA") {
303         _mint(msg.sender, _totalSupply);
304     }
305 
306     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
307         blacklists[_address] = _isBlacklisting;
308     }
309 
310     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
311         limited = _limited;
312         uniswapV2Pair = _uniswapV2Pair;
313         maxHoldingAmount = _maxHoldingAmount;
314         minHoldingAmount = _minHoldingAmount;
315     }
316 
317     function _beforeTokenTransfer(
318         address from,
319         address to,
320         uint256 amount
321     ) override internal virtual {
322         require(!blacklists[to] && !blacklists[from], "Blacklisted");
323 
324         if (uniswapV2Pair == address(0)) {
325             require(from == owner() || to == owner(), "trading is not started");
326             return;
327         }
328 
329         if (limited && from == uniswapV2Pair) {
330             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
331         }
332     }
333 
334     function burn(uint256 value) external {
335         _burn(msg.sender, value);
336     }
337 }