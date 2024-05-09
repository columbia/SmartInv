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
97 contract ERC20Token is IERC20, Pausable {
98     using SafeMath for uint256;
99     using Address for address;
100 
101     string internal _name;
102     string internal _symbol;
103     uint8 internal _decimals;
104     uint256 internal _totalSupply;
105 
106     mapping (address => uint256) internal _balances;
107     mapping (address => mapping (address => uint256)) internal _allowances;
108 
109     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public {
110         _name = name;
111         _symbol = symbol;
112         _decimals = decimals;
113         _totalSupply = totalSupply;
114         _balances[msg.sender] = totalSupply;
115         emit Transfer(address(0), msg.sender, totalSupply);
116     }
117 
118     function name() public view returns (string memory) {
119         return _name;
120     }
121 
122     function symbol() public view returns (string memory) {
123         return _symbol;
124     }
125 
126     function decimals() public view returns (uint8) {
127         return _decimals;
128     }
129 
130     function totalSupply() public view returns (uint256) {
131         return _totalSupply;
132     }
133 
134     function balanceOf(address account) public view returns (uint256 balance) {
135         return _balances[account];
136     }
137 
138 
139     // Function that is called when a user or another contract wants to transfer funds .
140     function transfer(address recipient, uint256 amount)
141     public
142     whenNotPaused
143     returns (bool success)
144     {
145         _transfer(msg.sender, recipient, amount);
146         return true;
147     }
148 
149     function allowance(address owner, address spender)
150     public
151     view
152     returns (uint256)
153     {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 value)
158     public
159     whenNotPaused
160     returns (bool)
161     {
162         _approve(msg.sender, spender, value);
163         return true;
164     }
165 
166 
167     function transferFrom(address sender, address recipient, uint256 amount)
168     public
169     whenNotPaused
170     returns (bool)
171     {
172         _transfer(sender, recipient, amount);
173         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
174         return true;
175     }
176 
177 
178 
179     function increaseAllowance(address spender, uint256 addedValue)
180     public
181     whenNotPaused
182     returns (bool)
183     {
184         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
185         return true;
186     }
187 
188     function decreaseAllowance(address spender, uint256 subtractedValue)
189     public
190     whenNotPaused
191     returns (bool)
192     {
193         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
194         return true;
195     }
196 
197     function _transfer(address sender, address recipient, uint256 amount) internal {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200 
201         _balances[sender] = _balances[sender].sub(amount);
202         _balances[recipient] = _balances[recipient].add(amount);
203         emit Transfer(sender, recipient, amount);
204     }
205 
206     function _approve(address owner, address spender, uint256 value) internal {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209 
210         _allowances[owner][spender] = value;
211         emit Approval(owner, spender, value);
212     }
213 }
214 
215 contract FINToken is ERC20Token {
216     constructor() public
217     ERC20Token("Finple Token", "FPT", 18, 50000000000 * (10 ** 18)) {
218     }
219     mapping (address => uint256) internal _locked_balances;
220 
221     event TokenLocked(address indexed owner, uint256 value);
222     event TokenUnlocked(address indexed beneficiary, uint256 value);
223 
224     function balanceOfLocked(address account) public view returns (uint256 balance)
225     {
226         return _locked_balances[account];
227     }
228 
229     function lockToken(address[] memory addresses, uint256[] memory amounts)
230     public
231     onlyOwner
232     returns (bool) {
233         require(addresses.length > 0, "LockToken: address is empty");
234         require(addresses.length == amounts.length, "LockToken: invalid array size");
235 
236         for (uint i = 0; i < addresses.length; i++) {
237             _lock_token(addresses[i], amounts[i]);
238         }
239         return true;
240     }
241 
242     function lockTokenWhole(address[] memory addresses)
243     public
244     onlyOwner
245     returns (bool) {
246         require(addresses.length > 0, "LockToken: address is empty");
247 
248         for (uint i = 0; i < addresses.length; i++) {
249             _lock_token(addresses[i], _balances[addresses[i]]);
250         }
251         return true;
252     }
253 
254     function unlockToken(address[] memory addresses, uint256[] memory amounts)
255     public
256     onlyOwner
257     returns (bool) {
258         require(addresses.length > 0, "LockToken: unlock address is empty");
259         require(addresses.length == amounts.length, "LockToken: invalid array size");
260 
261         for (uint i = 0; i < addresses.length; i++) {
262             _unlock_token(addresses[i], amounts[i]);
263         }
264         return true;
265     }
266 
267     function _lock_token(address owner, uint256 amount) internal {
268         require(owner != address(0), "LockToken: lock from the zero address");
269         require(amount > 0, "LockToken: the amount is empty");
270 
271         _balances[owner] = _balances[owner].sub(amount);
272         _locked_balances[owner] = _locked_balances[owner].add(amount);
273         emit TokenLocked(owner, amount);
274     }
275 
276     function _unlock_token(address owner, uint256 amount) internal {
277         require(owner != address(0), "LockToken: lock from the zero address");
278         require(amount > 0, "LockToken: the amount is empty");
279 
280         _locked_balances[owner] = _locked_balances[owner].sub(amount);
281         _balances[owner] = _balances[owner].add(amount);
282         emit TokenUnlocked(owner, amount);
283     }
284 
285     function distributeAirdrop(address[] memory addresses, uint256 amount, bool immediatelyRelease)
286     public
287     whenNotPaused
288     returns (bool) {
289         require(amount > 0, "Airdrop: airdrop the zero amount");
290         require(addresses.length > 0, "Airdrop: airdrop to empty addresses");
291 
292         for (uint i = 0; i < addresses.length; i++) {
293             _transfer(msg.sender, addresses[i], amount);
294             if (!immediatelyRelease){
295                 _lock_token(addresses[i], amount);
296             }
297         }
298 
299         return true;
300     }
301 
302     event Collect(address indexed from, address indexed to, uint256 value);
303     event CollectLocked(address indexed from, address indexed to, uint256 value); //Lock이 해지 되었다.
304 
305     function collectFrom(address[] memory addresses, uint256[] memory amounts, address recipient)
306     public
307     onlyOwner
308     returns (bool) {
309         require(addresses.length > 0, "Collect: collect address is empty");
310         require(addresses.length == amounts.length, "Collect: invalid array size");
311 
312         for (uint i = 0; i < addresses.length; i++) {
313             _transfer(addresses[i], recipient, amounts[i]);
314             emit Collect(addresses[i], recipient, amounts[i]);
315         }
316         return true;
317     }
318 
319     function collectFromLocked(address[] memory addresses, uint256[] memory amounts, address recipient)
320     public
321     onlyOwner
322     returns (bool) {
323         require(addresses.length > 0, "Collect: collect address is empty");
324         require(addresses.length == amounts.length, "Collect: invalid array size");
325 
326         for (uint i = 0; i < addresses.length; i++) {
327             _unlock_token(addresses[i], amounts[i]);
328             _transfer(addresses[i], recipient, amounts[i]);
329             emit CollectLocked(addresses[i], recipient, amounts[i]);
330         }
331         return true;
332     }
333 }
334 
335 library SafeMath {
336     function add(uint256 a, uint256 b) internal pure returns (uint256) {
337         uint256 c = a + b;
338         require(c >= a, "SafeMath: addition overflow");
339 
340         return c;
341     }
342     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
343         require(b <= a, "SafeMath: subtraction overflow");
344         uint256 c = a - b;
345 
346         return c;
347     }
348     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
349         if (a == 0) {
350             return 0;
351         }
352 
353         uint256 c = a * b;
354         require(c / a == b, "SafeMath: multiplication overflow");
355 
356         return c;
357     }
358     function div(uint256 a, uint256 b) internal pure returns (uint256) {
359         require(b > 0, "SafeMath: division by zero");
360         uint256 c = a / b;
361         return c;
362     }
363 
364     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
365         require(b != 0, "SafeMath: modulo by zero");
366         return a % b;
367     }
368 }