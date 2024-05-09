1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
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
47 abstract contract Freezable is Context {
48     event Freeze(address indexed holder);
49     event Unfreeze(address indexed holder);
50 
51     mapping(address => bool) private _frozenAccount;
52 
53     modifier whenNotFrozen(address holder) {
54         require(!_frozenAccount[holder]);
55         _;
56     }
57 
58     function isFrozen(address holder) public view virtual returns (bool frozen) {
59         return _frozenAccount[holder];
60     }
61 
62     function _freezeAccount(address holder) internal virtual returns (bool success) {
63         require(!isFrozen(holder));
64         _frozenAccount[holder] = true;
65         emit Freeze(holder);
66         success = true;
67     }
68 
69     function _unfreezeAccount(address holder) internal virtual returns (bool success) {
70         require(isFrozen(holder));
71         _frozenAccount[holder] = false;
72         emit Unfreeze(holder);
73         success = true;
74     }
75 }
76 
77 abstract contract Pausable is Context {
78     event Paused(address account);
79     event Unpaused(address account);
80 
81     bool private _paused;
82 
83     constructor() {
84         _paused = false;
85     }
86 
87     function paused() public view virtual returns (bool) {
88         return _paused;
89     }
90 
91     modifier whenNotPaused() {
92         require(!paused(), "Paused");
93         _;
94     }
95 
96     modifier whenPaused() {
97         require(paused(), "Not paused");
98         _;
99     }
100 
101     function _pause() internal virtual whenNotPaused {
102         _paused = true;
103         emit Paused(_msgSender());
104     }
105 
106     function _unpause() internal virtual whenPaused {
107         _paused = false;
108         emit Unpaused(_msgSender());
109     }
110 }
111 
112 interface IERC20 {
113     function totalSupply() external view returns (uint256);
114     function balanceOf(address account) external view returns (uint256);
115     function transfer(address recipient, uint256 amount) external returns (bool);
116     function allowance(address owner, address spender) external view returns (uint256);
117     function approve(address spender, uint256 amount) external returns (bool);
118     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119 
120     event Transfer(address indexed from, address indexed to, uint256 value);
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 interface IERC20Metadata is IERC20 {
125     function name() external view returns (string memory);
126     function symbol() external view returns (string memory);
127     function decimals() external view returns (uint8);
128 }
129 
130 contract ERC20 is Context, IERC20, IERC20Metadata {
131     mapping(address => uint256) internal _balances;
132 
133     mapping(address => mapping(address => uint256)) private _allowances;
134 
135     uint256 private _totalSupply;
136 
137     string private _name;
138     string private _symbol;
139 
140     constructor(string memory name_, string memory symbol_) {
141         _name = name_;
142         _symbol = symbol_;
143     }
144 
145     function name() public view virtual override returns (string memory) {
146         return _name;
147     }
148 
149     function symbol() public view virtual override returns (string memory) {
150         return _symbol;
151     }
152 
153     function decimals() public view virtual override returns (uint8) {
154         return 9;
155     }
156 
157     function totalSupply() public view virtual override returns (uint256) {
158         return _totalSupply;
159     }
160 
161     function balanceOf(address account) public view virtual override returns (uint256) {
162         return _balances[account];
163     }
164 
165     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     function allowance(address owner, address spender) public view virtual override returns (uint256) {
171         return _allowances[owner][spender];
172     }
173 
174     function approve(address spender, uint256 amount) public virtual override returns (bool) {
175         _approve(_msgSender(), spender, amount);
176         return true;
177     }
178 
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) public virtual override returns (bool) {
184         _transfer(sender, recipient, amount);
185 
186         uint256 currentAllowance = _allowances[sender][_msgSender()];
187         require(currentAllowance >= amount, "Transfer amount exceeds allowance");
188     unchecked {
189         _approve(sender, _msgSender(), currentAllowance - amount);
190     }
191 
192         return true;
193     }
194 
195     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
196         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
197         return true;
198     }
199 
200     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
201         uint256 currentAllowance = _allowances[_msgSender()][spender];
202         require(currentAllowance >= subtractedValue, "Decreased allowance below zero");
203     unchecked {
204         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
205     }
206 
207         return true;
208     }
209 
210     function _transfer(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) internal virtual {
215         require(sender != address(0), "Transfer from the zero address");
216         require(recipient != address(0), "Transfer to the zero address");
217 
218         _beforeTokenTransfer(sender, recipient, amount);
219 
220         uint256 senderBalance = _balances[sender];
221         require(senderBalance >= amount, "Transfer amount exceeds balance");
222     unchecked {
223         _balances[sender] = senderBalance - amount;
224     }
225         _balances[recipient] += amount;
226 
227         emit Transfer(sender, recipient, amount);
228     }
229 
230     function _mint(address account, uint256 amount) internal virtual {
231         require(account != address(0), "Mint to the zero address");
232 
233         _beforeTokenTransfer(address(0), account, amount);
234 
235         _totalSupply += amount;
236         _balances[account] += amount;
237         emit Transfer(address(0), account, amount);
238     }
239 
240     function _burn(address account, uint256 amount) internal virtual {
241         require(account != address(0), "Burn from the zero address");
242 
243         _beforeTokenTransfer(account, address(0), amount);
244 
245         uint256 accountBalance = _balances[account];
246         require(accountBalance >= amount, "Burn amount exceeds balance");
247     unchecked {
248         _balances[account] = accountBalance - amount;
249     }
250         _totalSupply -= amount;
251 
252         emit Transfer(account, address(0), amount);
253     }
254 
255     function _approve(
256         address owner,
257         address spender,
258         uint256 amount
259     ) internal virtual {
260         require(owner != address(0), "Approve from the zero address");
261         require(spender != address(0), "Approve to the zero address");
262 
263         _allowances[owner][spender] = amount;
264         emit Approval(owner, spender, amount);
265     }
266 
267     function _beforeTokenTransfer(
268         address from,
269         address to,
270         uint256 amount
271     ) internal virtual {}
272 }
273 
274 abstract contract ERC20Burnable is Context, ERC20, Ownable {
275     function burn(uint256 amount) public virtual {
276         _burn(_msgSender(), amount);
277     }
278 
279     function burnFrom(address account, uint256 amount) public virtual {
280         _burn(account, amount);
281     }
282 }
283 
284 abstract contract ERC20Lockable is ERC20, Ownable {
285     struct LockInfo {
286         uint256 _releaseTime;
287         uint256 _amount;
288     }
289 
290     mapping(address => LockInfo[]) internal _locks;
291     mapping(address => uint256) internal _totalLocked;
292 
293     event Lock(address indexed from, uint256 amount, uint256 releaseTime);
294     event Unlock(address indexed from, uint256 amount);
295 
296     modifier checkLock(address from, uint256 amount) {
297         uint256 length = _locks[from].length;
298         if (length > 0) {
299             autoUnlock(from);
300         }
301         require(_balances[from] >= _totalLocked[from] + amount, "Balance exceed");
302         _;
303     }
304 
305     function _lock(address from, uint256 amount, uint256 releaseTime) internal returns (bool success)
306     {
307         require(
308             _balances[from] >= amount + _totalLocked[from],
309             "Locked total should be smaller than balance"
310         );
311         _totalLocked[from] = _totalLocked[from] + amount;
312         _locks[from].push(LockInfo(releaseTime, amount));
313         emit Lock(from, amount, releaseTime);
314         success = true;
315     }
316 
317     function _unlock(address from, uint256 index) internal returns (bool success) {
318         LockInfo storage info = _locks[from][index];
319         _totalLocked[from] = _totalLocked[from] - info._amount;
320         emit Unlock(from, info._amount);
321         _locks[from][index] = _locks[from][_locks[from].length - 1];
322         _locks[from].pop();
323         success = true;
324     }
325 
326     function lock(address recipient, uint256 amount, uint256 releaseTime) public onlyOwner returns (bool success) {
327         require(_balances[recipient] >= amount, "There is not enough balance of holder.");
328         _lock(recipient, amount, releaseTime);
329 
330         success = true;
331     }
332 
333     function autoUnlock(address from) public returns (bool success) {
334         for (uint256 i = 0; i < _locks[from].length; i++) {
335             if (_locks[from][i]._releaseTime < block.timestamp) {
336                 _unlock(from, i);
337             }
338         }
339         success = true;
340     }
341 
342     function unlock(address from, uint256 idx) public onlyOwner returns (bool success) {
343         require(_locks[from].length > idx, "There is not lock info.");
344         _unlock(from, idx);
345         success = true;
346     }
347 
348     function releaseLock(address from) external onlyOwner returns (bool success){
349         require(_locks[from].length > 0, "There is not lock info.");
350 
351         for (uint256 i = _locks[from].length; i > 0; i--) {
352             _unlock(from, i - 1);
353         }
354         success = true;
355     }
356 
357     function transferWithLock(address recipient, uint256 amount, uint256 releaseTime) external onlyOwner returns (bool success)
358     {
359         require(recipient != address(0));
360         _transfer(msg.sender, recipient, amount);
361         _lock(recipient, amount, releaseTime);
362         success = true;
363     }
364 
365     function lockInfo(address locked, uint256 index) public view returns (uint256 releaseTime, uint256 amount)
366     {
367         LockInfo memory info = _locks[locked][index];
368         releaseTime = info._releaseTime;
369         amount = info._amount;
370     }
371 
372     function totalLocked(address locked) public view returns (uint256 amount, uint256 length){
373         amount = _totalLocked[locked];
374         length = _locks[locked].length;
375     }
376 }
377 
378 contract RIWA is ERC20, Pausable, Freezable, ERC20Burnable, ERC20Lockable {
379 
380     constructor() ERC20("Recycle Impact World Association", "RIWA") {
381         _mint(msg.sender, 300000000000000 * (10 ** decimals()));
382     }
383 
384     function pause() public onlyOwner {
385         _pause();
386     }
387 
388     function unpause() public onlyOwner {
389         _unpause();
390     }
391 
392     function freezeAccount(address holder) public onlyOwner {
393         _freezeAccount(holder);
394     }
395 
396     function unfreezeAccount(address holder) public onlyOwner {
397         _unfreezeAccount(holder);
398     }
399 
400     function transfer(address to, uint256 amount) public checkLock(msg.sender, amount) override returns (bool) {
401         return super.transfer(to, amount);
402     }
403 
404     function transferFrom(address from, address to, uint256 amount) public checkLock(from, amount) override returns (bool) {
405         return super.transferFrom(from, to, amount);
406     }
407 
408     function balanceOf(address holder) public view override returns (uint256 balance) {
409         balance = super.balanceOf(holder);
410     }
411 
412     function balanceOftransfer(address holder) public view returns (uint256 balance) {
413         uint256 totalBalance = super.balanceOf(holder);
414         uint256 avaliableBalance = 0;
415         (uint256 lockedBalance, uint256 lockedLength) = totalLocked(holder);
416         require(totalBalance >= lockedBalance);
417 
418         if (lockedLength > 0) {
419             for (uint i = 0; i < lockedLength; i++) {
420                 (uint256 releaseTime, uint256 amount) = lockInfo(holder, i);
421                 if (releaseTime <= block.timestamp) {
422                     avaliableBalance += amount;
423                 }
424             }
425         }
426 
427         balance = totalBalance - lockedBalance + avaliableBalance;
428     }
429 
430     function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused whenNotFrozen(from) override {
431         super._beforeTokenTransfer(from, to, amount);
432     }
433 }