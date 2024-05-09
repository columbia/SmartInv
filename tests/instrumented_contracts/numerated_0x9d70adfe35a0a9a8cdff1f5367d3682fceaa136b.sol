1 pragma solidity ^0.5.7;
2 
3 
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         c = a + b;
8         assert(c >= a);
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         if (a == 0) {
19             return 0;
20         }
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b > 0);
28         uint256 c = a / b;
29         assert(a == b * c + a % b);
30         return a / b;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b != 0);
35         return a % b;
36     }
37 }
38 
39 
40 
41 interface IERC20{
42     function name() external view returns (string memory);
43     function symbol() external view returns (string memory);
44     function decimals() external view returns (uint8);
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address owner) external view returns (uint256);
47     function transfer(address to, uint256 value) external returns (bool);
48     function transferFrom(address from, address to, uint256 value) external returns (bool);
49     function approve(address spender, uint256 value) external returns (bool);
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 
57 contract Ownable {
58     address internal _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     constructor () internal {
63         _owner = msg.sender;
64         emit OwnershipTransferred(address(0), _owner);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(msg.sender == _owner);
73         _;
74     }
75 
76     function transferOwnership(address newOwner) external onlyOwner {
77         require(newOwner != address(0));
78         _owner = newOwner;
79         emit OwnershipTransferred(_owner, newOwner);
80     }
81 
82     function rescueTokens(address tokenAddress, address receiver, uint256 amount) external onlyOwner {
83         IERC20 _token = IERC20(tokenAddress);
84         require(receiver != address(0));
85         uint256 balance = _token.balanceOf(address(this));
86 
87         require(balance >= amount);
88         assert(_token.transfer(receiver, amount));
89     }
90 
91     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
92         require(to != address(0));
93 
94         uint256 balance = address(this).balance;
95 
96         require(balance >= amount);
97         to.transfer(amount);
98     }
99 }
100 
101 
102 contract Pausable is Ownable {
103     bool private _paused;
104 
105     event Paused(address account);
106     event Unpaused(address account);
107 
108     constructor () internal {
109         _paused = false;
110     }
111 
112     function paused() public view returns (bool) {
113         return _paused;
114     }
115 
116     modifier whenNotPaused() {
117         require(!_paused);
118         _;
119     }
120 
121     modifier whenPaused() {
122         require(_paused);
123         _;
124     }
125 
126     function pause() external onlyOwner whenNotPaused {
127         _paused = true;
128         emit Paused(msg.sender);
129     }
130 
131     function unpause() external onlyOwner whenPaused {
132         _paused = false;
133         emit Unpaused(msg.sender);
134     }
135 }
136 
137 
138 contract TmToken is Ownable, Pausable, IERC20 {
139     using SafeMath for uint256;
140 
141     string private  _name     = "TM Token";
142     string private  _symbol   = "TM";
143     uint8 private   _decimals = 6;                   // 6 decimals
144     uint256 private _cap      = 10000000000000000;   // 10 billion cap, that is 10000000000.000000
145     uint256 private _totalSupply;
146 
147     mapping (address => bool) private _minter;
148     event Mint(address indexed to, uint256 value);
149     event MinterChanged(address account, bool state);
150 
151     mapping (address => uint256) private _balances;
152     mapping (address => mapping (address => uint256)) private _allowed;
153 
154     bool private _allowWhitelistRegistration;
155     mapping(address => address) private _referrer;
156     mapping(address => uint256) private _refCount;
157 
158     event TokenSaleWhitelistRegistered(address indexed addr, address indexed refAddr);
159     event TokenSaleWhitelistTransferred(address indexed previousAddr, address indexed _newAddr);
160     event TokenSaleWhitelistRegistrationEnabled();
161     event TokenSaleWhitelistRegistrationDisabled();
162 
163     uint256 private _whitelistRegistrationValue = 101000000;   // 101 Token, 101.000000
164     uint256[15] private _whitelistRefRewards = [                // 100% Reward
165     31000000,  // 31 Token for Level.1
166     20000000,  // 20 Token for Level.2
167     10000000,  // 10 Token for Level.3
168     10000000,  // 10 Token for Level.4
169     10000000,  // 10 Token for Level.5
170     5000000,   //  5 Token for Level.6
171     4000000,   //  4 Token for Level.7
172     3000000,   //  3 Token for Level.8
173     2000000,   //  2 Token for Level.9
174     1000000,   //  1 Token for Level.10
175     1000000,   //  1 Token for Level.11
176     1000000,   //  1 Token for Level.12
177     1000000,   //  1 Token for Level.13
178     1000000,   //  1 Token for Level.14
179     1000000    //  1 Token for Level.15
180     ];
181 
182     event Donate(address indexed account, uint256 amount);
183 
184     constructor() public {
185         _minter[msg.sender] = true;
186         _allowWhitelistRegistration = true;
187 
188         emit TokenSaleWhitelistRegistrationEnabled();
189 
190         _referrer[msg.sender] = msg.sender;
191         emit TokenSaleWhitelistRegistered(msg.sender, msg.sender);
192     }
193 
194 
195     function () external payable {
196         emit Donate(msg.sender, msg.value);
197     }
198 
199 
200     function name() public view returns (string memory) {
201         return _name;
202     }
203 
204     function symbol() public view returns (string memory) {
205         return _symbol;
206     }
207 
208 
209     function decimals() public view returns (uint8) {
210         return _decimals;
211     }
212 
213     function cap() public view returns (uint256) {
214         return _cap;
215     }
216 
217     function totalSupply() public view returns (uint256) {
218         return _totalSupply;
219     }
220 
221     function balanceOf(address owner) public view returns (uint256) {
222         return _balances[owner];
223     }
224 
225     function allowance(address owner, address spender) public view returns (uint256) {
226         return _allowed[owner][spender];
227     }
228 
229     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
230         if (_allowWhitelistRegistration && value == _whitelistRegistrationValue
231         && inWhitelist(to) && !inWhitelist(msg.sender) && isNotContract(msg.sender)) {
232             // Register whitelist for TM Token-Sale
233             _regWhitelist(msg.sender, to);
234             return true;
235         } else {
236             // Normal Transfer
237             _transfer(msg.sender, to, value);
238             return true;
239         }
240     }
241 
242     function approve(address spender, uint256 value) public returns (bool) {
243         _approve(msg.sender, spender, value);
244         return true;
245     }
246 
247     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
248         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
249         return true;
250     }
251 
252     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
253         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
254         return true;
255     }
256 
257     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
258         require(_allowed[from][msg.sender] >= value);
259         _transfer(from, to, value);
260         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
261         return true;
262     }
263 
264     function _transfer(address from, address to, uint256 value) internal {
265         require(to != address(0));
266 
267         _balances[from] = _balances[from].sub(value);
268         _balances[to] = _balances[to].add(value);
269         emit Transfer(from, to, value);
270     }
271 
272     function _approve(address owner, address spender, uint256 value) internal {
273         require(owner != address(0));
274         require(spender != address(0));
275 
276         _allowed[owner][spender] = value;
277         emit Approval(owner, spender, value);
278     }
279 
280     modifier onlyMinter() {
281         require(_minter[msg.sender]);
282         _;
283     }
284 
285     function isMinter(address account) public view returns (bool) {
286         return _minter[account];
287     }
288 
289     function setMinterState(address account, bool state) external onlyOwner {
290         _minter[account] = state;
291         emit MinterChanged(account, state);
292     }
293 
294     function mint(address to, uint256 value) public onlyMinter returns (bool) {
295         _mint(to, value);
296         return true;
297     }
298 
299     function _mint(address account, uint256 value) internal {
300         require(_totalSupply.add(value) <= _cap);
301         require(account != address(0));
302 
303         _totalSupply = _totalSupply.add(value);
304         _balances[account] = _balances[account].add(value);
305         emit Mint(account, value);
306         emit Transfer(address(0), account, value);
307     }
308 
309     modifier onlyInWhitelist() {
310         require(_referrer[msg.sender] != address(0));
311         _;
312     }
313 
314     function allowWhitelistRegistration() public view returns (bool) {
315         return _allowWhitelistRegistration;
316     }
317 
318     function inWhitelist(address account) public view returns (bool) {
319         return _referrer[account] != address(0);
320     }
321 
322 
323     function referrer(address account) public view returns (address) {
324         return _referrer[account];
325     }
326 
327     function refCount(address account) public view returns (uint256) {
328         return _refCount[account];
329     }
330 
331 
332     function disableTokenSaleWhitelistRegistration() external onlyOwner {
333         _allowWhitelistRegistration = false;
334         emit TokenSaleWhitelistRegistrationDisabled();
335     }
336 
337 
338     function _regWhitelist(address account, address refAccount) internal {
339         _refCount[refAccount] = _refCount[refAccount].add(1);
340         _referrer[account] = refAccount;
341 
342         emit TokenSaleWhitelistRegistered(account, refAccount);
343 
344         // Whitelist Registration Referral Reward
345         _transfer(msg.sender, address(this), _whitelistRegistrationValue);
346         address cursor = account;
347         uint256 remain = _whitelistRegistrationValue;
348         for(uint i = 0; i < _whitelistRefRewards.length; i++) {
349             address receiver = _referrer[cursor];
350 
351             if (cursor != receiver) {
352                 if (_refCount[receiver] > i) {
353                     _transfer(address(this), receiver, _whitelistRefRewards[i]);
354                     remain = remain.sub(_whitelistRefRewards[i]);
355                 }
356             } else {
357                // _transfer(address(this), refAccount, remain);
358                 break;
359             }
360 
361             cursor = _referrer[cursor];
362         }
363     }
364 
365     function transferWhitelist(address account) external onlyInWhitelist {
366         require(isNotContract(account));
367 
368         _refCount[account]    = _refCount[msg.sender];
369         _refCount[msg.sender] = 0;
370         _referrer[account]    = _referrer[msg.sender];
371         _referrer[msg.sender] = address(0);
372 
373         emit TokenSaleWhitelistTransferred(msg.sender, account);
374     }
375 
376 
377     function isNotContract(address addr) internal view returns (bool) {
378         uint size;
379         assembly {
380             size := extcodesize(addr)
381         }
382         return size == 0;
383     }
384 
385     function calculateTheRewardOfDirectWhitelistRegistration(address whitelistedAccount) external view returns (uint256 reward) {
386         if (!inWhitelist(whitelistedAccount)) {
387             return 0;
388         }
389 
390         address cursor = whitelistedAccount;
391         uint256 remain = _whitelistRegistrationValue;
392         for(uint i = 1; i < _whitelistRefRewards.length; i++) {
393             address receiver = _referrer[cursor];
394 
395             if (cursor != receiver) {
396                 if (_refCount[receiver] > i) {
397                     remain = remain.sub(_whitelistRefRewards[i]);
398                 }
399             } else {
400                 reward = reward.add(remain);
401                 break;
402             }
403 
404             cursor = _referrer[cursor];
405         }
406 
407         return reward;
408     }
409 }