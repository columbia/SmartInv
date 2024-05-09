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
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 interface IERC20Metadata is IERC20 {
61     function name() external view returns (string memory);
62     function symbol() external view returns (string memory);
63     function decimals() external view returns (uint8);
64 }
65 
66 contract ERC20 is Context, IERC20, IERC20Metadata {
67     mapping(address => uint256) internal _balances;
68 
69     mapping(address => mapping(address => uint256)) private _allowances;
70 
71     uint256 private _totalSupply;
72 
73     string private _name;
74     string private _symbol;
75 
76     constructor(string memory name_, string memory symbol_) {
77         _name = name_;
78         _symbol = symbol_;
79     }
80 
81     function name() public view virtual override returns (string memory) {
82         return _name;
83     }
84 
85     function symbol() public view virtual override returns (string memory) {
86         return _symbol;
87     }
88 
89     function decimals() public view virtual override returns (uint8) {
90         return 18;
91     }
92 
93     function totalSupply() public view virtual override returns (uint256) {
94         return _totalSupply;
95     }
96 
97     function balanceOf(address account) public view virtual override returns (uint256) {
98         return _balances[account];
99     }
100 
101     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
102         _transfer(_msgSender(), recipient, amount);
103         return true;
104     }
105 
106     function allowance(address owner, address spender) public view virtual override returns (uint256) {
107         return _allowances[owner][spender];
108     }
109 
110     function approve(address spender, uint256 amount) public virtual override returns (bool) {
111         _approve(_msgSender(), spender, amount);
112         return true;
113     }
114 
115     function transferFrom(
116         address sender,
117         address recipient,
118         uint256 amount
119     ) public virtual override returns (bool) {
120         _transfer(sender, recipient, amount);
121 
122         uint256 currentAllowance = _allowances[sender][_msgSender()];
123         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
124     unchecked {
125         _approve(sender, _msgSender(), currentAllowance - amount);
126     }
127 
128         return true;
129     }
130 
131     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
132         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
133         return true;
134     }
135 
136     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
137         uint256 currentAllowance = _allowances[_msgSender()][spender];
138         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
139     unchecked {
140         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
141     }
142 
143         return true;
144     }
145 
146     function _transfer(
147         address sender,
148         address recipient,
149         uint256 amount
150     ) internal virtual {
151         require(sender != address(0), "ERC20: transfer from the zero address");
152         require(recipient != address(0), "ERC20: transfer to the zero address");
153 
154         _beforeTokenTransfer(sender, recipient, amount);
155 
156         uint256 senderBalance = _balances[sender];
157         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
158     unchecked {
159         _balances[sender] = senderBalance - amount;
160     }
161         _balances[recipient] += amount;
162 
163         emit Transfer(sender, recipient, amount);
164     }
165 
166     function _mint(address account, uint256 amount) internal virtual {
167         require(account != address(0), "ERC20: mint to the zero address");
168 
169         _beforeTokenTransfer(address(0), account, amount);
170 
171         _totalSupply += amount;
172         _balances[account] += amount;
173         emit Transfer(address(0), account, amount);
174     }
175 
176     function _burn(address account, uint256 amount) internal virtual {
177         require(account != address(0), "ERC20: burn from the zero address");
178 
179         _beforeTokenTransfer(account, address(0), amount);
180 
181         uint256 accountBalance = _balances[account];
182         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
183     unchecked {
184         _balances[account] = accountBalance - amount;
185     }
186         _totalSupply -= amount;
187 
188         emit Transfer(account, address(0), amount);
189     }
190 
191     function _approve(
192         address owner,
193         address spender,
194         uint256 amount
195     ) internal virtual {
196         require(owner != address(0), "ERC20: approve from the zero address");
197         require(spender != address(0), "ERC20: approve to the zero address");
198 
199         _allowances[owner][spender] = amount;
200         emit Approval(owner, spender, amount);
201     }
202 
203     function _beforeTokenTransfer(
204         address from,
205         address to,
206         uint256 amount
207     ) internal virtual {}
208 }
209 
210 abstract contract ERC20Burnable is Context, ERC20, Ownable {
211     function burn(uint256 amount) public virtual {
212         _burn(_msgSender(), amount);
213     }
214 
215     function burnFrom(address account, uint256 amount) public virtual {
216         uint256 currentAllowance = allowance(account, _msgSender());
217         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
218     unchecked {
219         _approve(account, _msgSender(), currentAllowance - amount);
220     }
221         _burn(account, amount);
222     }
223 }
224 
225 abstract contract ERC20Lockable is ERC20, Ownable {
226     struct LockInfo {
227         uint256 _releaseTime;
228         uint256 _amount;
229     }
230 
231     mapping(address => LockInfo[]) internal _locks;
232     mapping(address => uint256) internal _totalLocked;
233 
234     event Lock(address indexed from, uint256 amount, uint256 releaseTime);
235     event Unlock(address indexed from, uint256 amount);
236 
237     modifier checkLock(address from, uint256 amount) {
238         uint256 length = _locks[from].length;
239         if (length > 0) {
240             autoUnlock(from);
241         }
242         require(_balances[from] >= _totalLocked[from] + amount, "checkLock : balance exceed");
243         _;
244     }
245 
246     function _lock(address from, uint256 amount, uint256 releaseTime) internal returns (bool success)
247     {
248         require(
249             _balances[from] >= amount + _totalLocked[from],
250             "lock : locked total should be smaller than balance"
251         );
252         _totalLocked[from] = _totalLocked[from] + amount;
253         _locks[from].push(LockInfo(releaseTime, amount));
254         emit Lock(from, amount, releaseTime);
255         success = true;
256     }
257 
258     function _unlock(address from, uint256 index) internal returns (bool success) {
259         LockInfo storage lock = _locks[from][index];
260         _totalLocked[from] = _totalLocked[from] - lock._amount;
261         emit Unlock(from, lock._amount);
262         _locks[from][index] = _locks[from][_locks[from].length - 1];
263         _locks[from].pop();
264         success = true;
265     }
266 
267     function lock(address recipient, uint256 amount, uint256 releaseTime) public onlyOwner returns (bool) {
268         require(_balances[recipient] >= amount, "There is not enough balance of holder.");
269         _lock(recipient, amount, releaseTime);
270 
271         return true;
272     }
273 
274     function autoUnlock(address from) public returns (bool success) {
275         for (uint256 i = 0; i < _locks[from].length; i++) {
276             if (_locks[from][i]._releaseTime < block.timestamp) {
277                 _unlock(from, i);
278             }
279         }
280         success = true;
281     }
282 
283     function unlock(address from, uint256 idx) public onlyOwner returns (bool success) {
284         require(_locks[from].length > idx, "There is not lock info.");
285         _unlock(from, idx);
286         success = true;
287     }
288 
289     function releaseLock(address from) external onlyOwner returns (bool success){
290         require(_locks[from].length > 0, "There is not lock info.");
291         //        uint256 i = _locks[from].length - 1;
292         //        _unlock(from, i);
293         for (uint256 i = _locks[from].length; i > 0; i--) {
294             _unlock(from, i - 1);
295         }
296         success = true;
297     }
298 
299     function transferWithLock(address recipient, uint256 amount, uint256 releaseTime) external onlyOwner returns (bool success)
300     {
301         require(recipient != address(0));
302         _transfer(msg.sender, recipient, amount);
303         _lock(recipient, amount, releaseTime);
304         success = true;
305     }
306 
307     function lockInfo(address locked, uint256 index) public view returns (uint256 releaseTime, uint256 amount)
308     {
309         LockInfo memory lock = _locks[locked][index];
310         releaseTime = lock._releaseTime;
311         amount = lock._amount;
312     }
313 
314     function totalLocked(address locked) public view returns (uint256 amount, uint256 length){
315         amount = _totalLocked[locked];
316         length = _locks[locked].length;
317     }
318 }
319 
320 contract VIX is ERC20, ERC20Burnable, ERC20Lockable {
321 
322     constructor() ERC20("VIXCO", "VIX") {
323         _mint(msg.sender, 2000000000 * (10 ** decimals()));
324     }
325 
326     function transfer(address to, uint256 amount) public checkLock(msg.sender, amount) override returns (bool) {
327         return super.transfer(to, amount);
328     }
329 
330     function transferFrom(address from, address to, uint256 amount) public checkLock(from, amount) override returns (bool) {
331         return super.transferFrom(from, to, amount);
332     }
333 
334     function balanceOf(address holder) public view override returns (uint256 balance) {
335         uint256 totalBalance = super.balanceOf(holder);
336         uint256 avaliableBalance = 0;
337         (uint256 lockedBalance, uint256 lockedLength) = totalLocked(holder);
338         require(totalBalance >= lockedBalance);
339 
340         if (lockedLength > 0) {
341             for (uint i = 0; i < lockedLength; i++) {
342                 (uint256 releaseTime, uint256 amount) = lockInfo(holder, i);
343                 if (releaseTime <= block.timestamp) {
344                     avaliableBalance += amount;
345                 }
346             }
347         }
348 
349         balance = totalBalance - lockedBalance + avaliableBalance;
350     }
351 
352     function balanceOfTotal(address holder) public view returns (uint256 balance) {
353         balance = super.balanceOf(holder);
354     }
355 
356     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
357         super._beforeTokenTransfer(from, to, amount);
358     }
359 }