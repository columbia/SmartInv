1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         address msgSender = _msgSender();
22         _owner = msgSender;
23         emit OwnershipTransferred(address(0), msgSender);
24     }
25 
26     function owner() public view virtual returns (address) {
27         return _owner;
28     }
29 
30     modifier onlyOwner() {
31         require(owner() == _msgSender(), "Caller is not the owner");
32         _;
33     }
34 
35     function renounceOwnership() public virtual onlyOwner {
36         emit OwnershipTransferred(_owner, address(0));
37         _owner = address(0);
38     }
39 
40     function transferOwnership(address newOwner) public virtual onlyOwner {
41         require(newOwner != address(0), "New owner is the zero address");
42         emit OwnershipTransferred(_owner, newOwner);
43         _owner = newOwner;
44     }
45 }
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 interface IERC20Metadata is IERC20 {
60     function name() external view returns (string memory);
61     function symbol() external view returns (string memory);
62     function decimals() external view returns (uint8);
63 }
64 
65 contract ERC20 is Context, IERC20, IERC20Metadata {
66     mapping(address => uint256) internal _balances;
67     mapping(address => mapping(address => uint256)) private _allowances;
68 
69     uint256 private _totalSupply;
70     string private _name;
71     string private _symbol;
72 
73     constructor(string memory name_, string memory symbol_) {
74         _name = name_;
75         _symbol = symbol_;
76     }
77 
78     function name() public view virtual override returns (string memory) {
79         return _name;
80     }
81 
82     function symbol() public view virtual override returns (string memory) {
83         return _symbol;
84     }
85 
86     function decimals() public view virtual override returns (uint8) {
87         return 18;
88     }
89 
90     function totalSupply() public view virtual override returns (uint256) {
91         return _totalSupply;
92     }
93 
94     function balanceOf(address account) public view virtual override returns (uint256) {
95         return _balances[account];
96     }
97 
98     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
99         _transfer(_msgSender(), recipient, amount);
100         return true;
101     }
102 
103     function allowance(address owner, address spender) public view virtual override returns (uint256) {
104         return _allowances[owner][spender];
105     }
106 
107     function approve(address spender, uint256 amount) public virtual override returns (bool) {
108         _approve(_msgSender(), spender, amount);
109         return true;
110     }
111 
112     function transferFrom(
113         address sender,
114         address recipient,
115         uint256 amount
116     ) public virtual override returns (bool) {
117         _transfer(sender, recipient, amount);
118 
119         uint256 currentAllowance = _allowances[sender][_msgSender()];
120         require(currentAllowance >= amount, "Transfer amount exceeds allowance");
121     unchecked {
122         _approve(sender, _msgSender(), currentAllowance - amount);
123     }
124 
125         return true;
126     }
127 
128     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
129         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
130         return true;
131     }
132 
133     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
134         uint256 currentAllowance = _allowances[_msgSender()][spender];
135         require(currentAllowance >= subtractedValue, "Decreased allowance below zero");
136     unchecked {
137         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
138     }
139 
140         return true;
141     }
142 
143     function _transfer(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) internal virtual {
148         require(sender != address(0), "Transfer from the zero address");
149         require(recipient != address(0), "Transfer to the zero address");
150 
151         _beforeTokenTransfer(sender, recipient, amount);
152 
153         uint256 senderBalance = _balances[sender];
154         require(senderBalance >= amount, "Transfer amount exceeds balance");
155     unchecked {
156         _balances[sender] = senderBalance - amount;
157     }
158         _balances[recipient] += amount;
159 
160         emit Transfer(sender, recipient, amount);
161     }
162 
163     function _mint(address account, uint256 amount) internal virtual {
164         require(account != address(0), "Mint to the zero address");
165 
166         _beforeTokenTransfer(address(0), account, amount);
167 
168         _totalSupply += amount;
169         _balances[account] += amount;
170         emit Transfer(address(0), account, amount);
171     }
172 
173     function _burn(address account, uint256 amount) internal virtual {
174         require(account != address(0), "Burn from the zero address");
175 
176         _beforeTokenTransfer(account, address(0), amount);
177 
178         uint256 accountBalance = _balances[account];
179         require(accountBalance >= amount, "Burn amount exceeds balance");
180     unchecked {
181         _balances[account] = accountBalance - amount;
182     }
183         _totalSupply -= amount;
184 
185         emit Transfer(account, address(0), amount);
186     }
187 
188     function _approve(
189         address owner,
190         address spender,
191         uint256 amount
192     ) internal virtual {
193         require(owner != address(0), "Approve from the zero address");
194         require(spender != address(0), "Approve to the zero address");
195 
196         _allowances[owner][spender] = amount;
197         emit Approval(owner, spender, amount);
198     }
199 
200     function _beforeTokenTransfer(
201         address from,
202         address to,
203         uint256 amount
204     ) internal virtual {}
205 }
206 
207 abstract contract ERC20Burnable is Context, ERC20, Ownable {
208     function burn(uint256 amount) public virtual {
209         _burn(_msgSender(), amount);
210     }
211 }
212 
213 abstract contract ERC20Lockable is ERC20, Ownable {
214     struct LockInfo {
215         uint256 _releaseTime;
216         uint256 _amount;
217     }
218 
219     mapping(address => LockInfo[]) internal _locks;
220     mapping(address => uint256) internal _totalLocked;
221 
222     event Lock(address indexed from, uint256 amount, uint256 releaseTime);
223     event Unlock(address indexed from, uint256 amount);
224 
225     modifier checkLock(address from, uint256 amount) {
226         uint256 length = _locks[from].length;
227         if (length > 0) {
228             autoUnlock(from);
229         }
230         require(_balances[from] >= _totalLocked[from] + amount, "Cannot send more than unlocked amount");
231         _;
232     }
233 
234     function _lock(address from, uint256 amount, uint256 releaseTime) internal returns (bool success)
235     {
236         require(
237             _balances[from] >= amount + _totalLocked[from],
238             "Locked total should be smaller than balance"
239         );
240         _totalLocked[from] = _totalLocked[from] + amount;
241         _locks[from].push(LockInfo(releaseTime, amount));
242         emit Lock(from, amount, releaseTime);
243         success = true;
244     }
245 
246     function _unlock(address from, uint256 index) internal returns (bool success) {
247         LockInfo storage info = _locks[from][index];
248         _totalLocked[from] = _totalLocked[from] - info._amount;
249         emit Unlock(from, info._amount);
250         _locks[from][index] = _locks[from][_locks[from].length - 1];
251         _locks[from].pop();
252         success = true;
253     }
254 
255     function autoUnlock(address from) public returns (bool success) {
256         for (uint256 i = 0; i < _locks[from].length; i++) {
257             if (_locks[from][i]._releaseTime < block.timestamp) {
258                 _unlock(from, i);
259             }
260         }
261         success = true;
262     }
263 
264     function unlock(address from, uint256 idx) public onlyOwner returns (bool success) {
265         require(_locks[from].length > idx, "There is no lock information.");
266         _unlock(from, idx);
267         success = true;
268     }
269 
270     function releaseLock(address from) external onlyOwner returns (bool success){
271         require(_locks[from].length > 0, "There is no lock information.");
272         for (uint256 i = _locks[from].length; i > 0; i--) {
273             _unlock(from, i - 1);
274         }
275         success = true;
276     }
277 
278     function transferWithLock(address recipient, uint256 amount, uint256 releaseTime) external onlyOwner returns (bool success)
279     {
280         require(recipient != address(0));
281         _transfer(msg.sender, recipient, amount);
282         _lock(recipient, amount, releaseTime);
283         success = true;
284     }
285 
286     function lockInfo(address locked, uint256 index) public view returns (uint256 releaseTime, uint256 amount)
287     {
288         LockInfo memory info = _locks[locked][index];
289         releaseTime = info._releaseTime;
290         amount = info._amount;
291     }
292 
293     function totalLocked(address locked) public view returns (uint256 amount, uint256 length){
294         amount = _totalLocked[locked];
295         length = _locks[locked].length;
296     }
297 }
298 
299 contract PLUS is ERC20, ERC20Burnable, ERC20Lockable {
300 
301     constructor() ERC20("PLUS", "PLUS") {
302         _mint(msg.sender, 10000000000 * (10 ** decimals()));
303     }
304 
305     function transfer(address to, uint256 amount) public checkLock(msg.sender, amount) override returns (bool) {
306         return super.transfer(to, amount);
307     }
308 
309     function transferFrom(address from, address to, uint256 amount) public checkLock(from, amount) override returns (bool) {
310         return super.transferFrom(from, to, amount);
311     }
312 
313     function balanceOf(address holder) public view override returns (uint256 balance) {
314         uint256 totalBalance = super.balanceOf(holder);
315         uint256 avaliableBalance = 0;
316         (uint256 lockedBalance, uint256 lockedLength) = totalLocked(holder);
317         require(totalBalance >= lockedBalance);
318 
319         if (lockedLength > 0) {
320             for (uint i = 0; i < lockedLength; i++) {
321                 (uint256 releaseTime, uint256 amount) = lockInfo(holder, i);
322                 if (releaseTime <= block.timestamp) {
323                     avaliableBalance += amount;
324                 }
325             }
326         }
327 
328         balance = totalBalance - lockedBalance + avaliableBalance;
329     }
330 
331     function balanceOfTotal(address holder) public view returns (uint256 balance) {
332         balance = super.balanceOf(holder);
333     }
334 
335     function _beforeTokenTransfer(
336         address from,
337         address to,
338         uint256 amount
339     )
340         internal override {
341         super._beforeTokenTransfer(from, to, amount);
342     }
343 
344 }