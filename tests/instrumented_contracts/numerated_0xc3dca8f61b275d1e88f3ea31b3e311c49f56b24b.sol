1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.5;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this;
11         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(owner() == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function renounceOwnership() public virtual onlyOwner {
37         emit OwnershipTransferred(_owner, address(0));
38         _owner = address(0);
39     }
40 
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         emit OwnershipTransferred(_owner, newOwner);
44         _owner = newOwner;
45     }
46 }
47 
48 abstract contract Freezable is Context {
49     event Freeze(address indexed holder);
50     event Unfreeze(address indexed holder);
51 
52     mapping(address => bool) private _frozenAccount;
53 
54     modifier whenNotFrozen(address holder) {
55         require(!_frozenAccount[holder]);
56         _;
57     }
58 
59     function isFrozen(address holder) public view virtual returns (bool frozen) {
60         return _frozenAccount[holder];
61     }
62 
63     function _freezeAccount(address holder) internal virtual returns (bool success) {
64         require(!isFrozen(holder));
65         _frozenAccount[holder] = true;
66         emit Freeze(holder);
67         success = true;
68     }
69 
70     function _unfreezeAccount(address holder) internal virtual returns (bool success) {
71         require(isFrozen(holder));
72         _frozenAccount[holder] = false;
73         emit Unfreeze(holder);
74         success = true;
75     }
76 }
77 
78 abstract contract Pausable is Context {
79     event Paused(address account);
80     event Unpaused(address account);
81 
82     bool private _paused;
83 
84     constructor() {
85         _paused = false;
86     }
87 
88     function paused() public view virtual returns (bool) {
89         return _paused;
90     }
91 
92     modifier whenNotPaused() {
93         require(!paused(), "Pausable: paused");
94         _;
95     }
96 
97     modifier whenPaused() {
98         require(paused(), "Pausable: not paused");
99         _;
100     }
101 
102     function _pause() internal virtual whenNotPaused {
103         _paused = true;
104         emit Paused(_msgSender());
105     }
106 
107     function _unpause() internal virtual whenPaused {
108         _paused = false;
109         emit Unpaused(_msgSender());
110     }
111 }
112 
113 interface IERC20 {
114     function totalSupply() external view returns (uint256);
115     function balanceOf(address account) external view returns (uint256);
116     function transfer(address recipient, uint256 amount) external returns (bool);
117     function allowance(address owner, address spender) external view returns (uint256);
118     function approve(address spender, uint256 amount) external returns (bool);
119     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
120 
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 interface IERC20Metadata is IERC20 {
126     function name() external view returns (string memory);
127     function symbol() external view returns (string memory);
128     function decimals() external view returns (uint8);
129 }
130 
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132     mapping(address => uint256) private _balances;
133 
134     mapping(address => mapping(address => uint256)) private _allowances;
135 
136     uint256 private _totalSupply;
137 
138     string private _name;
139     string private _symbol;
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
189     unchecked {
190         _approve(sender, _msgSender(), currentAllowance - amount);
191     }
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
204     unchecked {
205         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
206     }
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
223     unchecked {
224         _balances[sender] = senderBalance - amount;
225     }
226         _balances[recipient] += amount;
227 
228         emit Transfer(sender, recipient, amount);
229     }
230 
231     function _mint(address account, uint256 amount) internal virtual {
232         require(account != address(0), "ERC20: mint to the zero address");
233 
234         _beforeTokenTransfer(address(0), account, amount);
235 
236         _totalSupply += amount;
237         _balances[account] += amount;
238         emit Transfer(address(0), account, amount);
239     }
240 
241     function _burn(address account, uint256 amount) internal virtual {
242         require(account != address(0), "ERC20: burn from the zero address");
243 
244         _beforeTokenTransfer(account, address(0), amount);
245 
246         uint256 accountBalance = _balances[account];
247         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
248     unchecked {
249         _balances[account] = accountBalance - amount;
250     }
251         _totalSupply -= amount;
252 
253         emit Transfer(account, address(0), amount);
254     }
255 
256     function _approve(
257         address owner,
258         address spender,
259         uint256 amount
260     ) internal virtual {
261         require(owner != address(0), "ERC20: approve from the zero address");
262         require(spender != address(0), "ERC20: approve to the zero address");
263 
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268     function _beforeTokenTransfer(
269         address from,
270         address to,
271         uint256 amount
272     ) internal virtual {}
273 }
274 
275 abstract contract ERC20Burnable is Context, ERC20, Ownable {
276     function burn(uint256 amount) public virtual {
277         _burn(_msgSender(), amount);
278     }
279 
280     function burnFrom(address account, uint256 amount) public virtual {
281         uint256 currentAllowance = allowance(account, _msgSender());
282         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
283     unchecked {
284         _approve(account, _msgSender(), currentAllowance - amount);
285     }
286         _burn(account, amount);
287     }
288 }
289 
290 contract NPICK is ERC20, Pausable, Freezable, ERC20Burnable {
291 
292     constructor() ERC20("NPICK BLOCK", "NPICK") {
293         _mint(msg.sender, 10000000000 * (10 ** decimals()));
294     }
295 
296     function pause() public onlyOwner {
297         _pause();
298     }
299 
300     function unpause() public onlyOwner {
301         _unpause();
302     }
303 
304     function freezeAccount(address holder) public onlyOwner {
305         _freezeAccount(holder);
306     }
307 
308     function unfreezeAccount(address holder) public onlyOwner {
309         _unfreezeAccount(holder);
310     }
311 
312     function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused whenNotFrozen(from) override {
313         super._beforeTokenTransfer(from, to, amount);
314     }
315 }