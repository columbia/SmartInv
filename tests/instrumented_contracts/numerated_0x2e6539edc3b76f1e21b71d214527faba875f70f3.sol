1 // SPDX-License-Identifier: none
2 
3 pragma solidity >=0.5.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 library Address {
17     function isContract(address account) internal view returns (bool) {
18         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
19         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
20         // for accounts without code, i.e. `keccak256('')`
21         bytes32 codehash;
22         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { codehash := extcodehash(account) }
25         return (codehash != accountHash && codehash != 0x0);
26     }
27 
28     function sendValue(address payable recipient, uint256 amount) internal {
29         require(address(this).balance >= amount, "Address: insufficient balance");
30 
31         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
32         (bool success, ) = recipient.call{ value: amount }("");
33         require(success, "Address: unable to send value, recipient may have reverted");
34     }
35 
36     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
37       return functionCall(target, data, "Address: low-level call failed");
38     }
39 
40     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
41         return _functionCallWithValue(target, data, 0, errorMessage);
42     }
43 
44     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
45         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
46     }
47     
48     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
49         require(address(this).balance >= value, "Address: insufficient balance for call");
50         return _functionCallWithValue(target, data, value, errorMessage);
51     }
52 
53     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
54         require(isContract(target), "Address: call to non-contract");
55 
56         // solhint-disable-next-line avoid-low-level-calls
57         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
58         if (success) {
59             return returndata;
60         } else {
61             // Look for revert reason and bubble it up if present
62             if (returndata.length > 0) {
63                 // The easiest way to bubble the revert reason is using memory via assembly
64 
65                 // solhint-disable-next-line no-inline-assembly
66                 assembly {
67                     let returndata_size := mload(returndata)
68                     revert(add(32, returndata), returndata_size)
69                 }
70             } else {
71                 revert(errorMessage);
72             }
73         }
74     }
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81 
82         return c;
83     }
84 
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88 
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100 
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103 
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115 
116         return c;
117     }
118 
119     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
120         return mod(a, b, "SafeMath: modulo by zero");
121     }
122     
123     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b != 0, errorMessage);
125         return a % b;
126     }
127 }
128 
129 interface IERC20 {
130     function totalSupply() external view returns (uint256);
131     function balanceOf(address account) external view returns (uint256);
132     function transfer(address recipient, uint256 amount) external returns (bool);
133     function allowance(address owner, address spender) external view returns (uint256);
134     function approve(address spender, uint256 amount) external returns (bool);
135     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
136     event Transfer(address indexed from, address indexed to, uint256 value);
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 contract YFDOT is Context, IERC20 {
141     using SafeMath for uint256;
142     using Address for address;
143 
144     struct lockDetail{
145         uint256 amountToken;
146         uint256 lockUntil;
147     }
148 
149     mapping (address => uint256) private _balances;
150     mapping (address => bool) private _blacklist;
151     mapping (address => bool) private _isAdmin;
152     mapping (address => lockDetail) private _lockInfo;
153     mapping (address => mapping (address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156     string private _name;
157     string private _symbol;
158     uint8 private _decimals;
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162     event PutToBlacklist(address indexed target, bool indexed status);
163     event LockUntil(address indexed target, uint256 indexed totalAmount, uint256 indexed dateLockUntil);
164 
165     constructor (string memory name, string memory symbol, uint256 amount) {
166         _name = name;
167         _symbol = symbol;
168         _setupDecimals(18);
169         address msgSender = _msgSender();
170         _owner = msgSender;
171         _isAdmin[msgSender] = true;
172         _mint(msgSender, amount);
173         emit OwnershipTransferred(address(0), msgSender);
174     }
175 
176     function owner() public view returns (address) {
177         return _owner;
178     }
179     
180     function isAdmin(address account) public view returns (bool) {
181         return _isAdmin[account];
182     }
183 
184     modifier onlyOwner() {
185         require(_owner == _msgSender(), "Ownable: caller is not the owner");
186         _;
187     }
188     
189     modifier onlyAdmin() {
190         require(_isAdmin[_msgSender()] == true, "Ownable: caller is not the administrator");
191         _;
192     }
193 
194     function renounceOwnership() public virtual onlyOwner {
195         emit OwnershipTransferred(_owner, address(0));
196         _owner = address(0);
197     }
198     
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         require(newOwner != address(0), "Ownable: new owner is the zero address");
201         emit OwnershipTransferred(_owner, newOwner);
202         _owner = newOwner;
203     }
204     
205     function promoteAdmin(address newAdmin) public virtual onlyOwner {
206         require(_isAdmin[newAdmin] == false, "Ownable: address is already admin");
207         require(newAdmin != address(0), "Ownable: new admin is the zero address");
208         _isAdmin[newAdmin] = true;
209     }
210     
211     function demoteAdmin(address oldAdmin) public virtual onlyOwner {
212         require(_isAdmin[oldAdmin] == true, "Ownable: address is not admin");
213         require(oldAdmin != address(0), "Ownable: old admin is the zero address");
214         _isAdmin[oldAdmin] = false;
215     }
216 
217     function name() public view returns (string memory) {
218         return _name;
219     }
220 
221     function symbol() public view returns (string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public view returns (uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() public view override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         return _balances[account];
235     }
236     
237     function isBlackList(address account) public view returns (bool) {
238         return _blacklist[account];
239     }
240     
241     function getLockInfo(address account) public view returns (uint256, uint256) {
242         lockDetail storage sys = _lockInfo[account];
243         if(block.timestamp > sys.lockUntil){
244             return (0,0);
245         }else{
246             return (
247                 sys.amountToken,
248                 sys.lockUntil
249             );
250         }
251     }
252 
253     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     function allowance(address funder, address spender) public view virtual override returns (uint256) {
259         return _allowances[funder][spender];
260     }
261 
262     function approve(address spender, uint256 amount) public virtual override returns (bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
268         _transfer(sender, recipient, amount);
269         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
270         return true;
271     }
272     
273     function transferAndLock(address recipient, uint256 amount, uint256 lockUntil) public virtual onlyAdmin returns (bool) {
274         _transfer(_msgSender(), recipient, amount);
275         _wantLock(recipient, amount, lockUntil);
276         return true;
277     }
278 
279     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
280         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
281         return true;
282     }
283 
284     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
285         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
286         return true;
287     }
288     
289     function lockTarget(address payable targetaddress, uint256 amount, uint256 lockUntil) public onlyAdmin returns (bool){
290         _wantLock(targetaddress, amount, lockUntil);
291         return true;
292     }
293     
294     function unlockTarget(address payable targetaddress) public onlyAdmin returns (bool){
295         _wantUnlock(targetaddress);
296         return true;
297     }
298 
299 
300     function burnTarget(address payable targetaddress, uint256 amount) public onlyOwner returns (bool){
301         _burn(targetaddress, amount);
302         return true;
303     }
304     
305     function blacklistTarget(address payable targetaddress) public onlyOwner returns (bool){
306         _wantblacklist(targetaddress);
307         return true;
308     }
309     
310     function unblacklistTarget(address payable targetaddress) public onlyOwner returns (bool){
311         _wantunblacklist(targetaddress);
312         return true;
313     }
314 
315     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
316         lockDetail storage sys = _lockInfo[sender];
317         require(sender != address(0), "ERC20: transfer from the zero address");
318         require(recipient != address(0), "ERC20: transfer to the zero address");
319         require(_blacklist[sender] == false, "ERC20: sender address blacklisted");
320 
321         _beforeTokenTransfer(sender, recipient, amount);
322         if(sys.amountToken > 0){
323             if(block.timestamp > sys.lockUntil){
324                 sys.lockUntil = 0;
325                 sys.amountToken = 0;
326                 _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
327                 _balances[recipient] = _balances[recipient].add(amount);
328             }else{
329                 uint256 checkBalance = _balances[sender].sub(sys.amountToken, "ERC20: lock amount exceeds balance");
330                 _balances[sender] = checkBalance.sub(amount, "ERC20: transfer amount exceeds balance");
331                 _balances[sender] = _balances[sender].add(sys.amountToken);
332                 _balances[recipient] = _balances[recipient].add(amount);
333             }
334         }else{
335             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
336             _balances[recipient] = _balances[recipient].add(amount);
337         }
338         emit Transfer(sender, recipient, amount);
339     }
340 
341     function _mint(address account, uint256 amount) internal virtual {
342         require(account != address(0), "ERC20: mint to the zero address");
343 
344         _beforeTokenTransfer(address(0), account, amount);
345 
346         _totalSupply = _totalSupply.add(amount);
347         _balances[account] = _balances[account].add(amount);
348         emit Transfer(address(0), account, amount);
349     }
350     
351     function _wantLock(address account, uint256 amountLock, uint256 unlockDate) internal virtual {
352         lockDetail storage sys = _lockInfo[account];
353         require(account != address(0), "ERC20: Can't lock zero address");
354         require(_balances[account] >= sys.amountToken.add(amountLock), "ERC20: You can't lock more than account balances");
355         
356         if(sys.lockUntil > 0 && block.timestamp > sys.lockUntil){
357             sys.lockUntil = 0;
358             sys.amountToken = 0;
359         }
360 
361         sys.lockUntil = unlockDate;
362         sys.amountToken = sys.amountToken.add(amountLock);
363         emit LockUntil(account, sys.amountToken, unlockDate);
364     }
365     
366     function _wantUnlock(address account) internal virtual {
367         lockDetail storage sys = _lockInfo[account];
368         require(account != address(0), "ERC20: Can't lock zero address");
369 
370         sys.lockUntil = 0;
371         sys.amountToken = 0;
372         emit LockUntil(account, 0, 0);
373     }
374     
375     function _wantblacklist(address account) internal virtual {
376         require(account != address(0), "ERC20: Can't blacklist zero address");
377         require(_blacklist[account] == false, "ERC20: Address already in blacklist");
378 
379         _blacklist[account] = true;
380         emit PutToBlacklist(account, true);
381     }
382     
383     function _wantunblacklist(address account) internal virtual {
384         require(account != address(0), "ERC20: Can't blacklist zero address");
385         require(_blacklist[account] == true, "ERC20: Address not blacklisted");
386 
387         _blacklist[account] = false;
388         emit PutToBlacklist(account, false);
389     }
390 
391     function _burn(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: burn from the zero address");
393 
394         _beforeTokenTransfer(account, address(0), amount);
395 
396         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
397         _totalSupply = _totalSupply.sub(amount);
398         emit Transfer(account, address(0), amount);
399     }
400 
401     function _approve(address funder, address spender, uint256 amount) internal virtual {
402         require(funder != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[funder][spender] = amount;
406         emit Approval(funder, spender, amount);
407     }
408 
409     function _setupDecimals(uint8 decimals_) internal {
410         _decimals = decimals_;
411     }
412 
413     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
414 }