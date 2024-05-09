1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 library Address {
5     function isContract(address account) internal view returns (bool) {
6         uint256 size;
7         assembly { size := extcodesize(account) }
8         return size > 0;
9     }
10 
11     function sendValue(address payable recipient, uint256 amount) internal {
12         require(address(this).balance >= amount, "Address: insufficient balance");
13 
14         (bool success, ) = recipient.call{ value: amount }("");
15         require(success, "Address: unable to send value, recipient may have reverted");
16     }
17 
18     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
19       return functionCall(target, data, "Address: low-level call failed");
20     }
21 
22     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
23         return _functionCallWithValue(target, data, 0, errorMessage);
24     }
25 
26     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
27         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
28     }
29 
30     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
31         require(address(this).balance >= value, "Address: insufficient balance for call");
32         return _functionCallWithValue(target, data, value, errorMessage);
33     }
34 
35     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
36         require(isContract(target), "Address: call to non-contract");
37 
38         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
39         if (success) {
40             return returndata;
41         } else {
42             if (returndata.length > 0) {
43                 assembly {
44                     let returndata_size := mload(returndata)
45                     revert(add(32, returndata), returndata_size)
46                 }
47             } else {
48                 revert(errorMessage);
49             }
50         }
51     }
52 }
53 
54 contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes calldata) {
60         return msg.data;
61     }
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84 
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b > 0, errorMessage);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         return mod(a, b, "SafeMath: modulo by zero");
109     }
110 
111     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b != 0, errorMessage);
113         return a % b;
114     }
115 }
116 
117 contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     function owner() public view virtual returns (address) {
127         return _owner;
128     }
129 
130     modifier onlyOwner() {
131         require(owner() == _msgSender(), "Ownable: caller is not the owner");
132         _;
133     }
134 
135     function _transferOwnership(address newOwner) internal virtual {
136         address oldOwner = _owner;
137         _owner = newOwner;
138         emit OwnershipTransferred(oldOwner, newOwner);
139     }
140 }
141 
142 contract Lockable is Context {
143     event Locked(address account);
144     event Unlocked(address account);
145 
146     mapping(address => bool) private _locked;
147 
148     function locked(address _to) internal view returns (bool) {
149         return _locked[_to];
150     }
151 
152     function _lock(address to) internal virtual {
153         require(to != address(0), "ERC20: lock to the zero address");
154 
155         _locked[to] = true;
156         emit Locked(to);
157     }
158 
159     function _unlock(address to) internal virtual {
160         require(to != address(0), "ERC20: lock to the zero address");
161 
162         _locked[to] = false;
163         emit Unlocked(to);
164     }
165 }
166 
167 contract TimeLock {
168     using SafeMath for uint256;
169     using Address for address;
170 
171     event SetTimeLock(address account, uint timestamp);
172     event RemoveTimeLock(address account);
173 
174     mapping(address => uint) private _endTimestamp;
175 
176     function getEndTime(address to) public view virtual returns(uint) {
177         return _endTimestamp[to];
178     }
179 
180     function _setTimeLock(address to, uint256 timestamp) internal virtual {
181         require(to != address(0), "Timelock: account is the zero address");
182         require(timestamp != uint256(0), "Timelock: is the zero day");
183 
184         _endTimestamp[to] = timestamp;
185 
186         emit SetTimeLock(to, timestamp);
187     }
188 
189     function _removeTimeLock(address to) internal virtual {
190         require(to != address(0), "Timelock: account is the zero address");
191 
192         _endTimestamp[to] = 0;
193 
194         emit RemoveTimeLock(to);
195     }
196 }
197 
198 interface IERC20 {
199     function totalSupply() external view returns (uint256);
200     function balanceOf(address account) external view returns (uint256);
201     function transfer(address to, uint256 amount) external returns (bool);
202     function allowance(address owner, address spender) external view returns (uint256);
203     function approve(address spender, uint256 amount) external returns (bool);
204     function transferFrom(address from, address to, uint256 amount) external returns (bool);
205 
206     event Transfer(address indexed from, address indexed to, uint256 value);
207     event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 interface IERC20Metadata is IERC20 {
211     function name() external view returns (string memory);
212     function symbol() external view returns (string memory);
213     function decimals() external view returns (uint8);
214 }
215 
216 contract ERC20 is Context, IERC20, IERC20Metadata, Lockable, TimeLock {
217     using SafeMath for uint256;
218     using Address for address;
219 
220     mapping(address => uint256) private _balances;
221     mapping(address => mapping(address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224     string private _name;
225     string private _symbol;
226     uint8 private _decimals;
227 
228     constructor(string memory name_, string memory symbol_) {
229         _name = name_;
230         _symbol = symbol_;
231     }
232 
233     function name() public view virtual override returns (string memory) {
234         return _name;
235     }
236 
237     function symbol() public view virtual override returns (string memory) {
238         return _symbol;
239     }
240 
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244 
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252 
253     function transfer(address to, uint256 amount) public virtual override returns (bool) {
254         address owner = _msgSender();
255         _transfer(owner, to, amount);
256         return true;
257     }
258 
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     function approve(address spender, uint256 amount) public virtual override returns (bool) {
264         address owner = _msgSender();
265         _approve(owner, spender, amount);
266         return true;
267     }
268 
269     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
270         address spender = _msgSender();
271         _spendAllowance(from, spender, amount);
272         _transfer(from, to, amount);
273         return true;
274     }
275 
276     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
277         address owner = _msgSender();
278         _approve(owner, spender, allowance(owner, spender) + addedValue);
279         return true;
280     }
281 
282     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
283         address owner = _msgSender();
284         uint256 currentAllowance = allowance(owner, spender);
285         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
286         unchecked {
287             _approve(owner, spender, currentAllowance - subtractedValue);
288         }
289 
290         return true;
291     }
292 
293     function _transfer(address from, address to, uint256 amount) internal virtual {
294         require(from != address(0), "ERC20: transfer from the zero address");
295         require(to != address(0), "ERC20: transfer to the zero address");
296         require(locked(from) != true, "ERC20: sender is locked");
297         require((getEndTime(from) <= block.timestamp) != false, "ERC20: sender is Time locked");
298 
299         uint256 fromBalance = _balances[from];
300         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
301         unchecked {
302             _balances[from] = fromBalance - amount;
303         }
304         _balances[to] += amount;
305 
306         emit Transfer(from, to, amount);
307     }
308 
309     function _mint(address account, uint256 amount) internal virtual {
310         require(account != address(0), "ERC20: mint to the zero address");
311 
312         _beforeTokenTransfer(address(0), account, amount);
313 
314         _totalSupply = _totalSupply.add(amount);
315         _balances[account] = _balances[account].add(amount);
316         emit Transfer(address(0), account, amount);
317     }
318 
319     function _burn(address account, uint256 amount) internal virtual {
320         require(account != address(0), "ERC20: burn from the zero address");
321 
322         _beforeTokenTransfer(account, address(0), amount);
323 
324         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
325         _totalSupply = _totalSupply.sub(amount);
326         emit Transfer(account, address(0), amount);
327     }
328 
329     function _approve(address owner, address spender, uint256 amount) internal virtual {
330         require(owner != address(0), "ERC20: approve from the zero address");
331         require(spender != address(0), "ERC20: approve to the zero address");
332 
333         _allowances[owner][spender] = amount;
334         emit Approval(owner, spender, amount);
335     }
336 
337     function _spendAllowance(
338         address owner,
339         address spender,
340         uint256 amount
341     ) internal virtual {
342         uint256 currentAllowance = allowance(owner, spender);
343         if (currentAllowance != type(uint256).max) {
344             require(currentAllowance >= amount, "ERC20: insufficient allowance");
345             unchecked {
346                 _approve(owner, spender, currentAllowance - amount);
347             }
348         }
349     }
350 
351     function _beforeTokenTransfer(
352         address from,
353         address to,
354         uint256 amount
355     ) internal virtual {}
356 
357     function _afterTokenTransfer(
358         address from,
359         address to,
360         uint256 amount
361     ) internal virtual {}
362 }
363 
364 contract ERC20Pauser is Context, ERC20, Ownable {
365     constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){}
366 
367     function mint(address account, uint256 amount) internal virtual onlyOwner {
368         _mint(account, amount);
369     }
370 
371     function lock(address account) public virtual onlyOwner {
372         _lock(account);
373     }
374 
375     function unlock(address account) public virtual onlyOwner {
376         _unlock(account);
377     }
378     
379     function burn(uint256 amount) public virtual onlyOwner {
380         _burn(_msgSender(), amount*(10**uint256(decimals())));
381     }
382 
383     function renounceOwnership() public virtual onlyOwner {
384         _transferOwnership(address(0));
385     }
386 
387     function transferOwnership(address newOwner) public virtual onlyOwner {
388         require(newOwner != address(0), "Ownable: new owner is the zero address");
389         _transferOwnership(newOwner);
390     }
391 
392     function setTimeLock(address account, uint256 timestamp) public virtual onlyOwner {
393         _setTimeLock(account, timestamp);
394     }
395 
396     function removeTimeLock(address account) public virtual onlyOwner {
397         _removeTimeLock(account);
398     }
399 }
400 
401 contract CreateToken is ERC20Pauser {
402     constructor () ERC20Pauser("MDI", "MDI") {
403         mint(msg.sender, 10*(10**8)*(10**uint256(decimals())));
404     }
405 }