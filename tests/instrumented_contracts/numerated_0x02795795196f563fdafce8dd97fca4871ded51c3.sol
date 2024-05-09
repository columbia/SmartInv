1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this;
11         //silence state mutability warning without generating bytecode. https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     modifier onlyOwner() {
22         require(owner() == _msgSender(), "caller not owner");
23         _;
24     }
25 
26     constructor() {
27         address msgSender = _msgSender();
28         _owner = msgSender;
29         emit OwnershipTransferred(address(0), msgSender);
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         emit OwnershipTransferred(_owner, address(0));
34         _owner = address(0);
35     }
36 
37     function transferOwnership(address newOwner) public virtual onlyOwner {
38         require(newOwner != address(0), "newOwner is zero");
39         emit OwnershipTransferred(_owner, newOwner);
40         _owner = newOwner;
41     }
42 
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 }
47 
48 abstract contract Freezable is Context {
49     mapping(address => bool) private _frozenAccount;
50 
51     event Freeze(address indexed holder);
52     event Unfreeze(address indexed holder);
53 
54     modifier whenNotFrozen(address holder) {
55         require(!_frozenAccount[holder], "frozen");
56         _;
57     }
58 
59     function isFrozen(address holder) public view virtual returns (bool frozen) {
60         return _frozenAccount[holder];
61     }
62 
63     function _freezeAccount(address holder) internal virtual returns (bool success) {
64         require(!isFrozen(holder), "frozen");
65         _frozenAccount[holder] = true;
66         emit Freeze(holder);
67         success = true;
68     }
69 
70     function _unfreezeAccount(address holder) internal virtual returns (bool success) {
71         require(isFrozen(holder), "not frozen");
72         _frozenAccount[holder] = false;
73         emit Unfreeze(holder);
74         success = true;
75     }
76 }
77 
78 abstract contract Pausable is Context {
79     bool private _paused;
80 
81     event Paused(address account);
82     event Unpaused(address account);
83 
84     modifier whenNotPaused() {
85         require(!paused(), "Pausable: paused");
86         _;
87     }
88 
89     modifier whenPaused() {
90         require(paused(), "Pausable: not paused");
91         _;
92     }
93 
94     constructor() {
95         _paused = false;
96     }
97 
98     function paused() public view virtual returns (bool) {
99         return _paused;
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
114     event Transfer(address indexed from, address indexed to, uint256 value);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 
117     function transfer(address recipient, uint256 amount) external returns (bool);
118 
119     function approve(address spender, uint256 amount) external returns (bool);
120 
121     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
122 
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     function totalSupply() external view returns (uint256);
126 
127     function balanceOf(address account) external view returns (uint256);
128 }
129 
130 interface IERC20Metadata is IERC20 {
131     function name() external view returns (string memory);
132 
133     function symbol() external view returns (string memory);
134 
135     function decimals() external view returns (uint8);
136 }
137 
138 contract ERC20 is Context, IERC20, IERC20Metadata {
139     mapping(address => uint256) internal _balances;
140 
141     mapping(address => mapping(address => uint256)) private _allowances;
142 
143     uint256 private _totalSupply;
144 
145     string private _name;
146     string private _symbol;
147 
148     constructor(string memory name_, string memory symbol_) {
149         _name = name_;
150         _symbol = symbol_;
151     }
152 
153     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
154         return _transfer(_msgSender(), recipient, amount);
155     }
156 
157     function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
158         return _transferFrom(sender, recipient, amount);
159     }
160 
161     function approve(address spender, uint256 amount) external virtual override returns (bool) {
162         _approve(_msgSender(), spender, amount);
163         return true;
164     }
165 
166     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
167         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
168         return true;
169     }
170 
171     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
172         uint256 currentAllowance = _allowances[_msgSender()][spender];
173         require(currentAllowance >= subtractedValue, "decreased allowance below zero");
174         unchecked {
175             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
176         }
177 
178         return true;
179     }
180 
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public view virtual override returns (uint8) {
190         return 18;
191     }
192 
193     function totalSupply() public view virtual override returns (uint256) {
194         return _totalSupply;
195     }
196 
197     function balanceOf(address account) public view virtual override returns (uint256) {
198         return _balances[account];
199     }
200 
201     function allowance(address owner, address spender) public view virtual override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function _transfer(address sender, address recipient, uint256 amount) internal virtual returns (bool) {
206         require(sender != address(0), "transfer from the zero address");
207         require(recipient != address(0), "transfer to the zero address");
208 
209         _beforeTokenTransfer(sender, recipient, amount);
210 
211         uint256 senderBalance = _balances[sender];
212         require(senderBalance >= amount, "transfer amount exceeds balance");
213         unchecked {
214             _balances[sender] = senderBalance - amount;
215         }
216         _balances[recipient] += amount;
217 
218         emit Transfer(sender, recipient, amount);
219         return true;
220     }
221 
222     function _transferFrom(address sender, address recipient, uint256 amount) internal virtual returns (bool) {
223         _transfer(sender, recipient, amount);
224 
225         uint256 currentAllowance = _allowances[sender][_msgSender()];
226         require(currentAllowance >= amount, "amount exceeds allowance");
227         unchecked {
228             _approve(sender, _msgSender(), currentAllowance - amount);
229         }
230 
231         return true;
232     }
233 
234     function _mint(address account, uint256 amount) internal virtual {
235         require(account != address(0), "mint to the zero address");
236         _totalSupply += amount;
237         unchecked {
238             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
239             _balances[account] += amount;
240         }
241         emit Transfer(address(0), account, amount);
242     }
243 
244     function _burn(address account, uint256 amount) internal virtual {
245         require(account != address(0), "burn from the zero address");
246 
247         _beforeTokenTransfer(account, address(0), amount);
248 
249         uint256 accountBalance = _balances[account];
250         require(accountBalance >= amount, "burn amount exceeds balance");
251         unchecked {
252             _balances[account] = accountBalance - amount;
253         }
254         _totalSupply -= amount;
255 
256         emit Transfer(account, address(0), amount);
257     }
258 
259     function _approve(address owner, address spender, uint256 amount) internal virtual {
260         require(owner != address(0), "approve from the zero address");
261         require(spender != address(0), "approve to the zero address");
262 
263         _allowances[owner][spender] = amount;
264         emit Approval(owner, spender, amount);
265     }
266 
267     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
268 }
269 
270 abstract contract ERC20Burnable is Context, ERC20, Ownable {
271     function burn(uint256 amount) external virtual {
272         _burn(_msgSender(), amount);
273     }
274 
275     function burnFrom(address account, uint256 amount) external virtual {
276         uint256 currentAllowance = allowance(account, _msgSender());
277         require(currentAllowance >= amount, "burn amount exceeds allowance");
278         unchecked {
279             _approve(account, _msgSender(), currentAllowance - amount);
280         }
281         _burn(account, amount);
282     }
283 }
284 
285 abstract contract ERC20Lockable is ERC20, Ownable {
286     struct LockInfo {
287         uint256 _releaseTime;
288         uint256 _amount;
289     }
290 
291     mapping(address => LockInfo[]) internal _locks;
292     mapping(address => uint256) internal _totalLocked;
293 
294     event Lock(address indexed from, uint256 amount, uint256 releaseTime);
295     event Unlock(address indexed from, uint256 amount);
296 
297     modifier checkLock(address from, uint256 amount) {
298         uint256 length = _locks[from].length;
299         for (uint256 i = 0; i < _locks[from].length; i++) {
300             if (_locks[from][i]._releaseTime < block.timestamp) {
301                 _unlock(from, i);
302             }
303         }
304         require(_balances[from] >= _totalLocked[from] + amount, "balance exceed");
305         _;
306     }
307 
308     function lock(address recipient, uint256 amount, uint256 releaseTime) external onlyOwner returns (bool success) {
309         _lock(recipient, amount, releaseTime);
310         success = true;
311     }
312 
313     function unlock(address from, uint256 idx) external onlyOwner returns (bool success) {
314         require(_locks[from].length > idx, "There is not lock info.");
315         _unlock(from, idx);
316         success = true;
317     }
318 
319     function releaseLock(address from) external onlyOwner returns (bool success) {
320         require(_locks[from].length > 0, "There is not lock info.");
321         for (uint256 i = _locks[from].length; i > 0; i--) {
322             _unlock(from, i - 1);
323         }
324         success = true;
325     }
326 
327     function transferWithLock(
328         address recipient,
329         uint256 amount,
330         uint256 releaseTime
331     ) external onlyOwner returns (bool success) {
332         require(recipient != address(0), "recipient zero");
333         _transfer(_msgSender(), recipient, amount);
334         _lock(recipient, amount, releaseTime);
335         success = true;
336     }
337 
338     function lockInfo(address locked, uint256 index) public view returns (uint256 releaseTime, uint256 amount) {
339         LockInfo memory info = _locks[locked][index];
340         releaseTime = info._releaseTime;
341         amount = info._amount;
342     }
343 
344     function totalLocked(address locked) public view returns (uint256 amount, uint256 length) {
345         amount = _totalLocked[locked];
346         length = _locks[locked].length;
347     }
348 
349     function _lock(address from, uint256 amount, uint256 releaseTime) internal returns (bool success) {
350         require(_balances[from] >= amount + _totalLocked[from], "can only lock the balance");
351         _totalLocked[from] = _totalLocked[from] + amount;
352         _locks[from].push(LockInfo(releaseTime, amount));
353         emit Lock(from, amount, releaseTime);
354         success = true;
355     }
356 
357     function _unlock(address from, uint256 index) internal returns (bool success) {
358         LockInfo storage info = _locks[from][index];
359         _totalLocked[from] = _totalLocked[from] - info._amount;
360         emit Unlock(from, info._amount);
361         _locks[from][index] = _locks[from][_locks[from].length - 1];
362         _locks[from].pop();
363         success = true;
364     }
365 }
366 
367 contract Token is ERC20, Pausable, Freezable, ERC20Burnable, ERC20Lockable {
368     constructor(string memory __name, string memory __symbol, uint256 __totalSupply) ERC20(__name, __symbol) {
369         _mint(_msgSender(), __totalSupply * (10 ** decimals()));
370     }
371 
372     function pause() external onlyOwner {
373         _pause();
374     }
375 
376     function unpause() external onlyOwner {
377         _unpause();
378     }
379 
380     function freezeAccount(address holder) external onlyOwner {
381         _freezeAccount(holder);
382     }
383 
384     function unfreezeAccount(address holder) external onlyOwner {
385         _unfreezeAccount(holder);
386     }
387 
388     function availableBalanceOf(address holder) public view returns (uint256 balance) {
389         uint256 totalBalance = super.balanceOf(holder);
390         uint256 avaliableBalance = 0;
391         (uint256 lockedBalance, uint256 lockedLength) = totalLocked(holder);
392         require(totalBalance >= lockedBalance, "overflow lock balance");
393 
394         if (lockedLength > 0) {
395             for (uint i = 0; i < lockedLength; i++) {
396                 (uint256 releaseTime, uint256 amount) = lockInfo(holder, i);
397                 if (releaseTime <= block.timestamp) {
398                     avaliableBalance += amount;
399                 }
400             }
401         }
402 
403         balance = totalBalance - lockedBalance + avaliableBalance;
404     }
405 
406     function _beforeTokenTransfer(
407         address from,
408         address to,
409         uint256 amount
410     ) internal override whenNotPaused whenNotFrozen(from) checkLock(from, amount) {
411         super._beforeTokenTransfer(from, to, amount);
412     }
413 }
414 
415 contract Winnerz is Token {
416     constructor() Token("Winnerz", "WNZ", 10000000000) {}
417 }