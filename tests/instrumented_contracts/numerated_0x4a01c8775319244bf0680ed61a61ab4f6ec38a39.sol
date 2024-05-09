1 /**
2  * 
3  * Long Live Satoshi.
4  * 
5  * https://gaspay.io
6  * 
7  * https://t.me/GasPayDeFi
8  * https://t.me/GasPayAnnouncements
9  *
10  * 
11 */ 
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity >=0.6.0 <0.8.0;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         // Solidity only automatically asserts when dividing by 0
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return mod(a, b, "SafeMath: modulo by zero");
81     }
82 
83     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b != 0, errorMessage);
85         return a % b;
86     }
87 }
88 
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address payable) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes memory) {
95         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
96         return msg.data;
97     }
98 }
99 
100 abstract contract Ownable is Context {
101     address private _owner;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     constructor () {
106         address msgSender = _msgSender();
107         _owner = msgSender;
108         emit OwnershipTransferred(address(0), msgSender);
109     }
110 
111     function owner() public view returns (address) {
112         return _owner;
113     }
114 
115     modifier onlyOwner() {
116         require(_owner == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     function renounceOwnership() public virtual onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         emit OwnershipTransferred(_owner, newOwner);
128         _owner = newOwner;
129     }
130 }
131 
132 contract GasPay is Ownable, IERC20 {
133     using SafeMath for uint256;
134 
135     mapping (address => uint256) private _balances;
136 
137     mapping (address => mapping (address => uint256)) private _allowances;
138 
139     mapping (address => Lock[]) _locks;
140 
141     uint256 private _totalSupply = 100000 ether;
142 
143     string private _name = "GasPay";
144     string private _symbol = "$GASPAY";
145     uint8 private _decimals = 18;
146 
147     uint256 private _percentFees = 6;
148 
149     event Deposit(address indexed depositor, uint256 depositAmount, uint256 timestamp, uint256 unlockTimestamp);
150 
151     struct Lock {
152         uint256 lockAmount;
153         uint256 unlockTime;
154     }
155 
156     constructor() {
157         _balances[owner()] = _totalSupply;
158     }
159 
160     function name() public view returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public view returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public view returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public view override returns (uint256) {
173         return _totalSupply;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function getContractBalance() public view returns (uint256) {
181         return _balances[address(this)];
182     }
183 
184     function getFeeAmount(uint256 amount) public view returns (uint256) {
185         return amount.mul(_percentFees).div(100);
186     }
187 
188     function getUnlockableAmount(address account) public view returns (uint256) {
189         Lock[] memory locks = _locks[account];
190         uint256 unlockableAmount = 0;
191 
192         for (uint i=0; i<locks.length; i++) {
193             if (block.timestamp >= locks[i].unlockTime) {
194                 unlockableAmount = unlockableAmount.add(locks[i].lockAmount);
195             }
196         }
197         
198         return unlockableAmount;
199     }
200 
201     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view virtual override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public virtual override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
222         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
223         return true;
224     }
225 
226     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
227         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
228         return true;
229     }
230 
231     function lock(uint256 amount) public virtual {
232         address user = _msgSender();
233         uint256 lockAmount = amount;
234         uint256 timestamp = block.timestamp;
235         uint256 unlockTimestamp = timestamp.add(5 days);
236 
237         _depositForLock(user, lockAmount);
238 
239         Lock memory currentLock = Lock(
240             {
241                 lockAmount: amount,
242                 unlockTime: unlockTimestamp
243             }
244         );
245 
246         _locks[user].push(currentLock);
247 
248         emit Deposit(user, lockAmount, timestamp, unlockTimestamp);
249     }
250 
251     function unlock() public virtual {
252         uint256 unlockableAmount = getUnlockableAmount(_msgSender());
253         require(unlockableAmount > 0, "No unlockable Tokens");
254                 
255         Lock[] storage locks = _locks[_msgSender()];
256         uint256 withdrawAmount = 0;
257 
258         // loop just in case somehow the order gets messed up, would be possible with single assignment from index 0 too
259         for (uint i=0; i<locks.length; i++) {
260             if (block.timestamp >= locks[i].unlockTime) {
261                 withdrawAmount = withdrawAmount.add(locks[i].lockAmount);
262                 locks = _removeIndex(i, locks);
263                 break;
264             }
265         }
266 
267         _locks[_msgSender()] = locks;
268 
269         _withdrawFromLock(_msgSender(), withdrawAmount);
270     }
271 
272     function _removeIndex(uint256 index, Lock[] storage array) internal virtual returns(Lock[] storage) {
273         if (index >= array.length) {
274             return array;
275         }
276 
277         for (uint i=index; i<array.length-1; i++) {
278             array[i] = array[i+1];
279         }
280 
281         array.pop();
282 
283         return array;
284     }
285 
286     function _depositForLock(address sender, uint256 amount) internal virtual {
287         _balances[sender] = _balances[sender].sub(amount, "ERC20: lock amount exceeds balance");
288         _balances[address(this)] = _balances[address(this)].add(amount);
289         
290         emit Transfer(sender, address(this), amount);
291     }
292 
293     function _withdrawFromLock(address withdrawer, uint256 amount) internal virtual {
294         _balances[address(this)] = _balances[address(this)].sub(amount);
295         _balances[withdrawer] = _balances[withdrawer].add(amount);
296         
297         emit Transfer(address(this), withdrawer, amount);
298     }
299 
300     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
301         require(sender != address(0), "ERC20: transfer from the zero address");
302         require(recipient != address(0), "ERC20: transfer to the zero address");
303 
304         _beforeTokenTransfer(sender, recipient, amount);
305 
306         uint256 transferFee = getFeeAmount(amount);
307         uint256 amountAfterFee = amount.sub(transferFee);
308 
309         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
310         _balances[recipient] = _balances[recipient].add(amountAfterFee);
311 
312         _balances[owner()] = _balances[owner()].add(transferFee);
313 
314         emit Transfer(sender, recipient, amount);
315         emit Transfer(sender, owner(), transferFee);
316     }
317 
318     function _mint(address account, uint256 amount) internal virtual {
319         require(account != address(0), "ERC20: mint to the zero address");
320 
321         _beforeTokenTransfer(address(0), account, amount);
322 
323         _totalSupply = _totalSupply.add(amount);
324         _balances[account] = _balances[account].add(amount);
325         emit Transfer(address(0), account, amount);
326     }
327 
328     function _burn(address account, uint256 amount) internal virtual {
329         require(account != address(0), "ERC20: burn from the zero address");
330 
331         _beforeTokenTransfer(account, address(0), amount);
332 
333         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
334         _totalSupply = _totalSupply.sub(amount);
335         emit Transfer(account, address(0), amount);
336     }
337 
338     function _approve(address owner, address spender, uint256 amount) internal virtual {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341 
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346     function _setupDecimals(uint8 decimals_) internal virtual {
347         _decimals = decimals_;
348     }
349 
350     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
351 }