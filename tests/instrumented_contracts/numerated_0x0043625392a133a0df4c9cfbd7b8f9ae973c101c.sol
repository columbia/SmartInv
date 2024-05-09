1 pragma solidity ^0.5.0;
2 
3 library Address {
4     function isContract(address account) internal view returns (bool) {
5         uint256 size;
6         assembly { size := extcodesize(account) }
7         return size > 0;
8     }
9     function toPayable(address account) internal pure returns (address payable) {
10         return address(uint160(account));
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract Ownable {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29     constructor () internal {
30         _owner = msg.sender;
31         emit OwnershipTransferred(address(0), _owner);
32     }
33     function owner() public view returns (address) {
34         return _owner;
35     }
36     modifier onlyOwner() {
37         require(isOwner(), "Ownable: caller is not the owner");
38         _;
39     }
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43     function renounceOwnership() public onlyOwner {
44         emit OwnershipTransferred(_owner, address(0));
45         _owner = address(0);
46     }
47     function transferOwnership(address newOwner) public onlyOwner {
48         //_transferOwnership(newOwner);
49         _pendingowner = newOwner;
50         emit OwnershipTransferPending(_owner, newOwner);
51     }
52 
53     function _transferOwnership(address newOwner) internal {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58     address private _pendingowner;
59     event OwnershipTransferPending(address indexed previousOwner, address indexed newOwner);
60     function pendingowner() public view returns (address) {
61         return _pendingowner;
62     }
63 
64     modifier onlyPendingOwner() {
65         require(msg.sender == _pendingowner, "Ownable: caller is not the pending owner");
66         _;
67     }
68     function claimOwnership() public onlyPendingOwner {
69         _transferOwnership(msg.sender);
70     }
71 
72 }
73 
74 contract Pausable is Ownable {
75     event Pause();
76     event Unpause();
77 
78     bool public paused = false;
79     modifier whenNotPaused() {
80         require(!paused, "Pausable: paused");
81         _;
82     }
83     modifier whenPaused() {
84         require(paused, "Pausable: not paused");
85         _;
86     }
87     function pause() public onlyOwner whenNotPaused {
88         paused = true;
89         emit Pause();
90     }
91     function unpause() public onlyOwner whenPaused {
92         paused = false;
93         emit Unpause();
94     }
95 }
96 
97 
98 contract ERC20Token is IERC20, Pausable {
99     using SafeMath for uint256;
100     using Address for address;
101 
102     string internal _name;
103     string internal _symbol;
104     uint8 internal _decimals;
105     uint256 internal _totalSupply;
106 
107     mapping (address => uint256) internal _balances;
108     mapping (address => mapping (address => uint256)) internal _allowances;
109 
110     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public {
111         _name = name;
112         _symbol = symbol;
113         _decimals = decimals;
114         _totalSupply = totalSupply;
115         _balances[msg.sender] = totalSupply;
116         emit Transfer(address(0), msg.sender, totalSupply);
117     }
118 
119     function name() public view returns (string memory) {
120         return _name;
121     }
122 
123     function symbol() public view returns (string memory) {
124         return _symbol;
125     }
126 
127     function decimals() public view returns (uint8) {
128         return _decimals;
129     }
130 
131     function totalSupply() public view returns (uint256) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address account) public view returns (uint256 balance) {
136         return _balances[account];
137     }
138 
139 
140     // Function that is called when a user or another contract wants to transfer funds .
141     function transfer(address recipient, uint256 amount)
142     public
143     whenNotPaused
144     returns (bool success)
145     {
146         _transfer(msg.sender, recipient, amount);
147         return true;
148     }
149 
150     function allowance(address owner, address spender)
151     public
152     view
153     returns (uint256)
154     {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 value)
159     public
160     whenNotPaused
161     returns (bool)
162     {
163         _approve(msg.sender, spender, value);
164         return true;
165     }
166 
167 
168     function transferFrom(address sender, address recipient, uint256 amount)
169     public
170     whenNotPaused
171     returns (bool)
172     {
173         _transfer(sender, recipient, amount);
174         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
175         return true;
176     }
177 
178 
179 
180     function increaseAllowance(address spender, uint256 addedValue)
181     public
182     whenNotPaused
183     returns (bool)
184     {
185         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue)
190     public
191     whenNotPaused
192     returns (bool)
193     {
194         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
195         return true;
196     }
197 
198     function _transfer(address sender, address recipient, uint256 amount) internal {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201 
202         _balances[sender] = _balances[sender].sub(amount);
203         _balances[recipient] = _balances[recipient].add(amount);
204         emit Transfer(sender, recipient, amount);
205     }
206 
207     function _approve(address owner, address spender, uint256 value) internal {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210 
211         _allowances[owner][spender] = value;
212         emit Approval(owner, spender, value);
213     }
214 
215 	
216    // function mint(address account,uint256 amount) public onlyOwner returns (bool) {
217     //    _mint(account, amount);
218     //    return true;
219    // }
220     
221     function _mint(address account, uint256 amount) internal {
222         require(account != address(0), "ERC20: mint to the zero address");
223 
224         _totalSupply = _totalSupply.add(amount);
225         _balances[account] = _balances[account].add(amount);
226         emit Transfer(address(0), account, amount);
227     }    
228 
229     function burn(address account,uint256 amount) public onlyOwner returns (bool) {
230         _burn(account, amount);
231         return true;
232     }
233     
234     function _burn(address account, uint256 amount) internal {
235         require(account != address(0), "ERC20: burn to the zero address");
236 
237 	 _balances[account] = _balances[account].sub(amount);
238         _totalSupply = _totalSupply.sub(amount);
239         emit Transfer(account, address(0), amount);
240     }    
241     
242 }
243 
244 contract ArtEdu is ERC20Token {
245     constructor() public
246     ERC20Token("ArtEdu", "ATED", 18, 1000000000 * (10 ** 18)) {
247     }
248     mapping (address => uint256) internal _locked_balances;
249 
250     event TokenLocked(address indexed owner, uint256 value);
251     event TokenUnlocked(address indexed beneficiary, uint256 value);
252 
253     function balanceOfLocked(address account) public view returns (uint256 balance)
254     {
255         return _locked_balances[account];
256     }
257 
258     function lockToken(address[] memory addresses, uint256[] memory amounts)
259     public
260     onlyOwner
261     returns (bool) {
262         require(addresses.length > 0, "LockToken: address is empty");
263         require(addresses.length == amounts.length, "LockToken: invalid array size");
264 
265         for (uint i = 0; i < addresses.length; i++) {
266             _lock_token(addresses[i], amounts[i]);
267         }
268         return true;
269     }
270 
271     function lockTokenWhole(address[] memory addresses)
272     public
273     onlyOwner
274     returns (bool) {
275         require(addresses.length > 0, "LockToken: address is empty");
276 
277         for (uint i = 0; i < addresses.length; i++) {
278             _lock_token(addresses[i], _balances[addresses[i]]);
279         }
280         return true;
281     }
282 
283     function unlockToken(address[] memory addresses, uint256[] memory amounts)
284     public
285     onlyOwner
286     returns (bool) {
287         require(addresses.length > 0, "LockToken: unlock address is empty");
288         require(addresses.length == amounts.length, "LockToken: invalid array size");
289 
290         for (uint i = 0; i < addresses.length; i++) {
291             _unlock_token(addresses[i], amounts[i]);
292         }
293         return true;
294     }
295 
296     function _lock_token(address owner, uint256 amount) internal {
297         require(owner != address(0), "LockToken: lock from the zero address");
298         require(amount > 0, "LockToken: the amount is empty");
299 
300         _balances[owner] = _balances[owner].sub(amount);
301         _locked_balances[owner] = _locked_balances[owner].add(amount);
302         emit TokenLocked(owner, amount);
303     }
304 
305     function _unlock_token(address owner, uint256 amount) internal {
306         require(owner != address(0), "LockToken: lock from the zero address");
307         require(amount > 0, "LockToken: the amount is empty");
308 
309         _locked_balances[owner] = _locked_balances[owner].sub(amount);
310         _balances[owner] = _balances[owner].add(amount);
311         emit TokenUnlocked(owner, amount);
312     }
313 
314     event Collect(address indexed from, address indexed to, uint256 value);
315     event CollectLocked(address indexed from, address indexed to, uint256 value); //Lock이 해지 되었다.
316 
317     function collectFrom(address[] memory addresses, uint256[] memory amounts, address recipient)
318     public
319     onlyOwner
320     returns (bool) {
321         require(addresses.length > 0, "Collect: collect address is empty");
322         require(addresses.length == amounts.length, "Collect: invalid array size");
323 
324         for (uint i = 0; i < addresses.length; i++) {
325             _transfer(addresses[i], recipient, amounts[i]);
326             emit Collect(addresses[i], recipient, amounts[i]);
327         }
328         return true;
329     }
330 
331     function collectFromLocked(address[] memory addresses, uint256[] memory amounts, address recipient)
332     public
333     onlyOwner
334     returns (bool) {
335         require(addresses.length > 0, "Collect: collect address is empty");
336         require(addresses.length == amounts.length, "Collect: invalid array size");
337 
338         for (uint i = 0; i < addresses.length; i++) {
339             _unlock_token(addresses[i], amounts[i]);
340             _transfer(addresses[i], recipient, amounts[i]);
341             emit CollectLocked(addresses[i], recipient, amounts[i]);
342         }
343         return true;
344     }
345 }
346 
347 library SafeMath {
348     function add(uint256 a, uint256 b) internal pure returns (uint256) {
349         uint256 c = a + b;
350         require(c >= a, "SafeMath: addition overflow");
351 
352         return c;
353     }
354     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
355         require(b <= a, "SafeMath: subtraction overflow");
356         uint256 c = a - b;
357 
358         return c;
359     }
360     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
361         if (a == 0) {
362             return 0;
363         }
364 
365         uint256 c = a * b;
366         require(c / a == b, "SafeMath: multiplication overflow");
367 
368         return c;
369     }
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         require(b > 0, "SafeMath: division by zero");
372         uint256 c = a / b;
373         return c;
374     }
375 
376     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
377         require(b != 0, "SafeMath: modulo by zero");
378         return a % b;
379     }
380 }