1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount) external returns (bool);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function approve(address spender, uint256 amount) external returns (bool);
15 
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         return mod(a, b, "SafeMath: modulo by zero");
69     }
70 
71     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b != 0, errorMessage);
73         return a % b;
74     }
75 }
76 
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address payable) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes memory) {
83         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
84         return msg.data;
85     }
86 }
87 
88 abstract contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor () {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         emit OwnershipTransferred(_owner, newOwner);
116         _owner = newOwner;
117     }
118 }
119 
120 contract Gasgains is Ownable, IERC20 {
121     using SafeMath for uint256;
122 
123     mapping (address => uint256) private _balances;
124 
125     mapping (address => mapping (address => uint256)) private _allowances;
126 
127     mapping (address => Lock[]) _locks;
128 
129     uint256 private _totalSupply = 1000000 ether;
130 
131     string private _name = "Gasgains";
132     string private _symbol = "GASG";
133     uint8 private _decimals = 18;
134 
135     uint256 private _percentFees = 5;
136 
137     event Deposit(address indexed depositor, uint256 depositAmount, uint256 timestamp, uint256 unlockTimestamp);
138 
139     struct Lock {
140         uint256 lockAmount;
141         uint256 unlockTime;
142     }
143 
144     constructor() {
145         _balances[owner()] = _totalSupply;
146     }
147 
148     function name() public view returns (string memory) {
149         return _name;
150     }
151 
152     function symbol() public view returns (string memory) {
153         return _symbol;
154     }
155 
156     function decimals() public view returns (uint8) {
157         return _decimals;
158     }
159 
160     function totalSupply() public view override returns (uint256) {
161         return _totalSupply;
162     }
163 
164     function balanceOf(address account) public view override returns (uint256) {
165         return _balances[account];
166     }
167 
168     function getContractBalance() public view returns (uint256) {
169         return _balances[address(this)];
170     }
171 
172     function getFeeAmount(uint256 amount) public view returns (uint256) {
173         return amount.mul(_percentFees).div(100);
174     }
175 
176     function getUnlockableAmount(address account) public view returns (uint256) {
177         Lock[] memory locks = _locks[account];
178         uint256 unlockableAmount = 0;
179 
180         for (uint i=0; i<locks.length; i++) {
181             if (block.timestamp >= locks[i].unlockTime) {
182                 unlockableAmount = unlockableAmount.add(locks[i].lockAmount);
183             }
184         }
185         
186         return unlockableAmount;
187     }
188 
189     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view virtual override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public virtual override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
210         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
211         return true;
212     }
213 
214     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
215         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
216         return true;
217     }
218 
219     function lock(uint256 amount) public virtual {
220         address user = _msgSender();
221         uint256 lockAmount = amount;
222         uint256 timestamp = block.timestamp;
223         uint256 unlockTimestamp = timestamp.add(30 days);
224 
225         _depositForLock(user, lockAmount);
226 
227         Lock memory currentLock = Lock(
228             {
229                 lockAmount: amount,
230                 unlockTime: unlockTimestamp
231             }
232         );
233 
234         _locks[user].push(currentLock);
235 
236         emit Deposit(user, lockAmount, timestamp, unlockTimestamp);
237     }
238 
239     function unlock() public virtual {
240         uint256 unlockableAmount = getUnlockableAmount(_msgSender());
241         require(unlockableAmount > 0, "No unlockable Tokens");
242                 
243         Lock[] storage locks = _locks[_msgSender()];
244         uint256 withdrawAmount = 0;
245 
246         // loop just in case somehow the order gets messed up, would be possible with single assignment from index 0 too
247         for (uint i=0; i<locks.length; i++) {
248             if (block.timestamp >= locks[i].unlockTime) {
249                 withdrawAmount = withdrawAmount.add(locks[i].lockAmount);
250                 locks = _removeIndex(i, locks);
251                 break;
252             }
253         }
254 
255         _locks[_msgSender()] = locks;
256 
257         _withdrawFromLock(_msgSender(), withdrawAmount);
258     }
259 
260     function _removeIndex(uint256 index, Lock[] storage array) internal virtual returns(Lock[] storage) {
261         if (index >= array.length) {
262             return array;
263         }
264 
265         for (uint i=index; i<array.length-1; i++) {
266             array[i] = array[i+1];
267         }
268 
269         array.pop();
270 
271         return array;
272     }
273 
274     function _depositForLock(address sender, uint256 amount) internal virtual {
275         _balances[sender] = _balances[sender].sub(amount, "ERC20: lock amount exceeds balance");
276         _balances[address(this)] = _balances[address(this)].add(amount);
277     }
278 
279     function _withdrawFromLock(address withdrawer, uint256 amount) internal virtual {
280         _balances[address(this)] = _balances[address(this)].sub(amount);
281         _balances[withdrawer] = _balances[withdrawer].add(amount);
282     }
283 
284     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
285         require(sender != address(0), "ERC20: transfer from the zero address");
286         require(recipient != address(0), "ERC20: transfer to the zero address");
287 
288         _beforeTokenTransfer(sender, recipient, amount);
289 
290         uint256 transferFee = getFeeAmount(amount);
291         uint256 amountAfterFee = amount.sub(transferFee);
292 
293         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
294         _balances[recipient] = _balances[recipient].add(amountAfterFee);
295 
296         _balances[owner()] = _balances[owner()].add(transferFee);
297 
298         emit Transfer(sender, recipient, amount);
299     }
300 
301     function _mint(address account, uint256 amount) internal virtual {
302         require(account != address(0), "ERC20: mint to the zero address");
303 
304         _beforeTokenTransfer(address(0), account, amount);
305 
306         _totalSupply = _totalSupply.add(amount);
307         _balances[account] = _balances[account].add(amount);
308         emit Transfer(address(0), account, amount);
309     }
310 
311     function _burn(address account, uint256 amount) internal virtual {
312         require(account != address(0), "ERC20: burn from the zero address");
313 
314         _beforeTokenTransfer(account, address(0), amount);
315 
316         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
317         _totalSupply = _totalSupply.sub(amount);
318         emit Transfer(account, address(0), amount);
319     }
320 
321     function _approve(address owner, address spender, uint256 amount) internal virtual {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324 
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328 
329     function _setupDecimals(uint8 decimals_) internal virtual {
330         _decimals = decimals_;
331     }
332 
333     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
334 }