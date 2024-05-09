1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.5;
3 
4 abstract contract Context {
5   function _msgSender() internal view virtual returns (address) {
6     return msg.sender;
7   }
8 
9   function _msgData() internal view virtual returns (bytes calldata) {
10     this;
11     // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12     return msg.data;
13   }
14 }
15 
16 abstract contract Ownable is Context {
17   address internal _owner;
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21   function owner() public view virtual returns (address) {
22     return _owner;
23   }
24 
25   modifier onlyOwner() {
26     require(owner() == _msgSender(), "Ownable: caller is not the owner");
27     _;
28   }
29 
30   function renounceOwnership() public virtual onlyOwner {
31     emit OwnershipTransferred(_owner, address(0));
32     _owner = address(0);
33   }
34 
35   function transferOwnership(address newOwner) public virtual onlyOwner {
36     require(newOwner != address(0), "Ownable: new owner is the zero address");
37     emit OwnershipTransferred(_owner, newOwner);
38     _owner = newOwner;
39   }
40 }
41 
42 abstract contract Freezable is Context {
43   event Freeze(address indexed holder);
44   event Unfreeze(address indexed holder);
45 
46   mapping(address => bool) private _frozenAccount;
47 
48   modifier whenNotFrozen(address holder) {
49     require(!_frozenAccount[holder]);
50     _;
51   }
52 
53   function isFrozen(address holder) public view virtual returns (bool frozen) {
54     return _frozenAccount[holder];
55   }
56 
57   function _freezeAccount(address holder) internal virtual returns (bool success) {
58     require(!isFrozen(holder));
59     _frozenAccount[holder] = true;
60     emit Freeze(holder);
61     success = true;
62   }
63 
64   function _unfreezeAccount(address holder) internal virtual returns (bool success) {
65     require(isFrozen(holder));
66     _frozenAccount[holder] = false;
67     emit Unfreeze(holder);
68     success = true;
69   }
70 }
71 
72 abstract contract Pausable is Context {
73   event Paused(address account);
74   event Unpaused(address account);
75 
76   bool private _paused;
77 
78   constructor() {
79     _paused = false;
80   }
81 
82   function paused() public view virtual returns (bool) {
83     return _paused;
84   }
85 
86   modifier whenNotPaused() {
87     require(!paused(), "Pausable: paused");
88     _;
89   }
90 
91   modifier whenPaused() {
92     require(paused(), "Pausable: not paused");
93     _;
94   }
95 
96   function _pause() internal virtual whenNotPaused {
97     _paused = true;
98     emit Paused(_msgSender());
99   }
100 
101   function _unpause() internal virtual whenPaused {
102     _paused = false;
103     emit Unpaused(_msgSender());
104   }
105 }
106 
107 interface IERC20 {
108   function totalSupply() external view returns (uint256);
109 
110   function balanceOf(address account) external view returns (uint256);
111 
112   function transfer(address recipient, uint256 amount) external returns (bool);
113 
114   function allowance(address owner, address spender) external view returns (uint256);
115 
116   function approve(address spender, uint256 amount) external returns (bool);
117 
118   function transferFrom(
119     address sender,
120     address recipient,
121     uint256 amount
122   ) external returns (bool);
123 
124   event Transfer(address indexed from, address indexed to, uint256 value);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 interface IERC20Metadata is IERC20 {
129   function name() external view returns (string memory);
130 
131   function symbol() external view returns (string memory);
132 
133   function decimals() external view returns (uint8);
134 }
135 
136 contract ERC20 is Context, IERC20, IERC20Metadata {
137   mapping(address => uint256) private _balances;
138 
139   mapping(address => mapping(address => uint256)) private _allowances;
140 
141   uint256 private _totalSupply;
142 
143   string internal _name;
144   string internal _symbol;
145   uint8 internal _decimals;
146 
147   function name() public view virtual override returns (string memory) {
148     return _name;
149   }
150 
151   function symbol() public view virtual override returns (string memory) {
152     return _symbol;
153   }
154 
155   function decimals() public view virtual override returns (uint8) {
156     return _decimals;
157   }
158 
159   function totalSupply() public view virtual override returns (uint256) {
160     return _totalSupply;
161   }
162 
163   function balanceOf(address account) public view virtual override returns (uint256) {
164     return _balances[account];
165   }
166 
167   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
168     _transfer(_msgSender(), recipient, amount);
169     return true;
170   }
171 
172   function allowance(address owner, address spender) public view virtual override returns (uint256) {
173     return _allowances[owner][spender];
174   }
175 
176   function approve(address spender, uint256 amount) public virtual override returns (bool) {
177     _approve(_msgSender(), spender, amount);
178     return true;
179   }
180 
181   function transferFrom(
182     address sender,
183     address recipient,
184     uint256 amount
185   ) public virtual override returns (bool) {
186     _transfer(sender, recipient, amount);
187 
188     uint256 currentAllowance = _allowances[sender][_msgSender()];
189     require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
190     unchecked {
191       _approve(sender, _msgSender(), currentAllowance - amount);
192     }
193 
194     return true;
195   }
196 
197   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
198     _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
199     return true;
200   }
201 
202   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
203     uint256 currentAllowance = _allowances[_msgSender()][spender];
204     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
205     unchecked {
206       _approve(_msgSender(), spender, currentAllowance - subtractedValue);
207     }
208 
209     return true;
210   }
211 
212   function _transfer(
213     address sender,
214     address recipient,
215     uint256 amount
216   ) internal virtual {
217     require(sender != address(0), "ERC20: transfer from the zero address");
218     require(recipient != address(0), "ERC20: transfer to the zero address");
219 
220     _beforeTokenTransfer(sender, recipient, amount);
221 
222     uint256 senderBalance = _balances[sender];
223     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
224     unchecked {
225       _balances[sender] = senderBalance - amount;
226     }
227     _balances[recipient] += amount;
228 
229     emit Transfer(sender, recipient, amount);
230   }
231 
232   function _mint(address account, uint256 amount) internal virtual {
233     require(account != address(0), "ERC20: mint to the zero address");
234 
235     _beforeTokenTransfer(address(0), account, amount);
236 
237     _totalSupply += amount;
238     _balances[account] += amount;
239     emit Transfer(address(0), account, amount);
240   }
241 
242   function _burn(address account, uint256 amount) internal virtual {
243     require(account != address(0), "ERC20: burn from the zero address");
244 
245     _beforeTokenTransfer(account, address(0), amount);
246 
247     uint256 accountBalance = _balances[account];
248     require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
249     unchecked {
250       _balances[account] = accountBalance - amount;
251     }
252     _totalSupply -= amount;
253 
254     emit Transfer(account, address(0), amount);
255   }
256 
257   function _approve(
258     address owner,
259     address spender,
260     uint256 amount
261   ) internal virtual {
262     require(owner != address(0), "ERC20: approve from the zero address");
263     require(spender != address(0), "ERC20: approve to the zero address");
264 
265     _allowances[owner][spender] = amount;
266     emit Approval(owner, spender, amount);
267   }
268 
269   function _beforeTokenTransfer(
270     address from,
271     address to,
272     uint256 amount
273   ) internal virtual {}
274 }
275 
276 abstract contract ERC20Burnable is Context, ERC20, Ownable {
277   function burn(uint256 amount) public virtual {
278     _burn(_msgSender(), amount);
279   }
280 
281   function burnFrom(address account, uint256 amount) public virtual {
282     uint256 currentAllowance = allowance(account, _msgSender());
283     require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
284     unchecked {
285       _approve(account, _msgSender(), currentAllowance - amount);
286     }
287     _burn(account, amount);
288   }
289 }
290 
291 contract Token is ERC20, Pausable, Freezable, ERC20Burnable {
292   bool private initialized = false;
293 
294   function initialize(
295     address initalizeOwner,
296     string memory initalizeName,
297     string memory initalizeSymbol,
298     uint8 initalizeDecimals,
299     uint256 initalizeSupply
300   ) external {
301     require(!initialized, "Token: already initialized");
302 
303     _owner = initalizeOwner;
304     _name = initalizeName;
305     _symbol = initalizeSymbol;
306     _decimals = initalizeDecimals;
307     _mint(initalizeOwner, initalizeSupply * (10**initalizeDecimals));
308 
309     initialized = true;
310   }
311 
312   function pause() public onlyOwner {
313     _pause();
314   }
315 
316   function unpause() public onlyOwner {
317     _unpause();
318   }
319 
320   function freezeAccount(address holder) public onlyOwner {
321     _freezeAccount(holder);
322   }
323 
324   function unfreezeAccount(address holder) public onlyOwner {
325     _unfreezeAccount(holder);
326   }
327 
328   function _beforeTokenTransfer(
329     address from,
330     address to,
331     uint256 amount
332   ) internal override whenNotPaused whenNotFrozen(from) {
333     super._beforeTokenTransfer(from, to, amount);
334   }
335 }