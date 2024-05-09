1 pragma solidity =0.8.0;
2 
3 // ----------------------------------------------------------------------------
4 // NBU token main contract (2020)
5 //
6 // Symbol       : NBU
7 // Name         : Nimbus
8 // Total supply : 1.000.000.000 (burnable)
9 // Decimals     : 18
10 // ----------------------------------------------------------------------------
11 // SPDX-License-Identifier: MIT
12 // ----------------------------------------------------------------------------
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 contract Ownable {
28     address public owner;
29     address public newOwner;
30 
31     event OwnershipTransferred(address indexed from, address indexed to);
32 
33     constructor() {
34         owner = msg.sender;
35         emit OwnershipTransferred(address(0), owner);
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner, "Ownable: Caller is not the owner");
40         _;
41     }
42 
43     function transferOwnership(address transferOwner) public onlyOwner {
44         require(transferOwner != newOwner);
45         newOwner = transferOwner;
46     }
47 
48     function acceptOwnership() virtual public {
49         require(msg.sender == newOwner);
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 
56 contract Pausable is Ownable {
57     event Pause();
58     event Unpause();
59 
60     bool public paused = false;
61 
62 
63     modifier whenNotPaused() {
64         require(!paused);
65         _;
66     }
67 
68     modifier whenPaused() {
69         require(paused);
70         _;
71     }
72 
73     function pause() onlyOwner whenNotPaused public {
74         paused = true;
75         Pause();
76     }
77 
78     function unpause() onlyOwner whenPaused public {
79         paused = false;
80         Unpause();
81     }
82 }
83 
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         return add(a, b, "SafeMath: addition overflow");
87     }
88     
89     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, errorMessage);
92 
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103 
104         return c;
105     }
106 
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126         return c;
127     }
128 
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         return mod(a, b, "SafeMath: modulo by zero");
131     }
132 
133     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b != 0, errorMessage);
135         return a % b;
136     }
137 }
138 
139 contract NBU is IERC20, Ownable, Pausable {
140     using SafeMath for uint;
141 
142     mapping (address => mapping (address => uint)) private _allowances;
143     
144     mapping (address => uint) private _unfrozenBalances;
145 
146     mapping (address => uint) private _vestingNonces;
147     mapping (address => mapping (uint => uint)) private _vestingAmounts;
148     mapping (address => mapping (uint => uint)) private _unvestedAmounts;
149     mapping (address => mapping (uint => uint)) private _vestingTypes; //0 - multivest, 1 - single vest, > 2 give by vester id
150     mapping (address => mapping (uint => uint)) private _vestingReleaseStartDates;
151 
152     uint private _totalSupply = 1_000_000_000e18;
153     string private constant _name = "Nimbus";
154     string private constant _symbol = "NBU";
155     uint8 private constant _decimals = 18;
156 
157     uint private vestingFirstPeriod = 60 days;
158     uint private vestingSecondPeriod = 152 days;
159 
160     uint public giveAmount;
161     mapping (address => bool) public vesters;
162 
163     bytes32 public immutable DOMAIN_SEPARATOR;
164     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
165     mapping (address => uint) public nonces;
166 
167     event Unvest(address user, uint amount);
168 
169     constructor () {
170         _unfrozenBalances[owner] = _totalSupply;
171         emit Transfer(address(0), owner, _totalSupply); 
172 
173         uint chainId = block.chainid;
174 
175         DOMAIN_SEPARATOR = keccak256(
176             abi.encode(
177                 keccak256('EIP712Domain(string name,uint256 chainId,address verifyingContract)'),
178                 keccak256(bytes(_name)),
179                 chainId,
180                 address(this)
181             )
182         );
183         giveAmount = _totalSupply / 10;
184     }
185 
186     function approve(address spender, uint amount) external override whenNotPaused returns (bool) {
187         _approve(msg.sender, spender, amount);
188         return true;
189     }
190 
191     function transfer(address recipient, uint amount) external override whenNotPaused returns (bool) {
192         _transfer(msg.sender, recipient, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint amount) external override whenNotPaused returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "NBU::transferFrom: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external whenNotPaused {
203         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
204         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
205         address signatory = ecrecover(digest, v, r, s);
206         require(signatory != address(0), "NBU::permit: invalid signature");
207         require(signatory == owner, "NBU::permit: unauthorized");
208         require(block.timestamp <= deadline, "NBU::permit: signature expired");
209 
210         _allowances[owner][spender] = amount;
211 
212         emit Approval(owner, spender, amount);
213     }
214 
215     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
216         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
217         return true;
218     }
219 
220     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
221         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "NBU::decreaseAllowance: decreased allowance below zero"));
222         return true;
223     }
224 
225     function unvest() external whenNotPaused returns (uint unvested) {
226         require (_vestingNonces[msg.sender] > 0, "NBU::unvest:No vested amount");
227         for (uint i = 1; i <= _vestingNonces[msg.sender]; i++) {
228             if (_vestingAmounts[msg.sender][i] == _unvestedAmounts[msg.sender][i]) continue;
229             if (_vestingReleaseStartDates[msg.sender][i] > block.timestamp) break;
230             uint toUnvest = block.timestamp.sub(_vestingReleaseStartDates[msg.sender][i]).mul(_vestingAmounts[msg.sender][i]) / vestingSecondPeriod;
231             if (toUnvest > _vestingAmounts[msg.sender][i]) {
232                 toUnvest = _vestingAmounts[msg.sender][i];
233             } 
234             uint totalUnvestedForNonce = toUnvest;
235             toUnvest = toUnvest.sub(_unvestedAmounts[msg.sender][i]);
236             unvested = unvested.add(toUnvest);
237             _unvestedAmounts[msg.sender][i] = totalUnvestedForNonce;
238         }
239         _unfrozenBalances[msg.sender] = _unfrozenBalances[msg.sender].add(unvested);
240         emit Unvest(msg.sender, unvested);
241     }
242 
243     function give(address user, uint amount, uint vesterId) external {
244         require (giveAmount > amount, "NBU::give: give finished");
245         require (vesters[msg.sender], "NBU::give: not vester");
246         giveAmount = giveAmount.sub(amount);
247         _vest(user, amount, vesterId);
248      }
249 
250     function vest(address user, uint amount) external {
251         require (vesters[msg.sender], "NBU::vest: not vester");
252         _vest(user, amount, 1);
253     }
254 
255     function burnTokens(uint amount) external onlyOwner returns (bool success) {
256         require(amount <= _unfrozenBalances[owner], "NBU::burnTokens: exceeds available amount");
257         _unfrozenBalances[owner] = _unfrozenBalances[owner].sub(amount, "NBU::burnTokens: transfer amount exceeds balance");
258         _totalSupply = _totalSupply.sub(amount, "NBU::burnTokens: overflow");
259         emit Transfer(owner, address(0), amount);
260         return true;
261     }
262 
263 
264 
265     function allowance(address owner, address spender) external view override returns (uint) {
266         return _allowances[owner][spender];
267     }
268 
269     function decimals() external pure returns (uint8) {
270         return _decimals;
271     }
272 
273     function name() external pure returns (string memory) {
274         return _name;
275     }
276 
277     function symbol() external pure returns (string memory) {
278         return _symbol;
279     }
280 
281     function totalSupply() external view override returns (uint) {
282         return _totalSupply;
283     }
284 
285     function balanceOf(address account) external view override returns (uint) {
286         uint amount = _unfrozenBalances[account];
287         if (_vestingNonces[account] == 0) return amount;
288         for (uint i = 1; i <= _vestingNonces[account]; i++) {
289             amount = amount.add(_vestingAmounts[account][i]).sub(_unvestedAmounts[account][i]);
290         }
291         return amount;
292     }
293 
294     function availableForUnvesting(address user) external view returns (uint unvestAmount) {
295         if (_vestingNonces[user] == 0) return 0;
296         for (uint i = 1; i <= _vestingNonces[user]; i++) {
297             if (_vestingAmounts[user][i] == _unvestedAmounts[user][i]) continue;
298             if (_vestingReleaseStartDates[user][i] > block.timestamp) break;
299             uint toUnvest = block.timestamp.sub(_vestingReleaseStartDates[user][i]).mul(_vestingAmounts[user][i]) / vestingSecondPeriod;
300             if (toUnvest > _vestingAmounts[user][i]) {
301                 toUnvest = _vestingAmounts[user][i];
302             } 
303             toUnvest = toUnvest.sub(_unvestedAmounts[user][i]);
304             unvestAmount = unvestAmount.add(toUnvest);
305         }
306     }
307 
308     function availableForTransfer(address account) external view returns (uint) {
309         return _unfrozenBalances[account];
310     }
311 
312     function vestingInfo(address user, uint nonce) external view returns (uint vestingAmount, uint unvestedAmount, uint vestingReleaseStartDate, uint vestType) {
313         vestingAmount = _vestingAmounts[user][nonce];
314         unvestedAmount = _unvestedAmounts[user][nonce];
315         vestingReleaseStartDate = _vestingReleaseStartDates[user][nonce];
316         vestType = _vestingTypes[user][nonce];
317     }
318 
319     function vestingNonces(address user) external view returns (uint lastNonce) {
320         return _vestingNonces[user];
321     }
322 
323 
324 
325     function _approve(address owner, address spender, uint amount) private {
326         require(owner != address(0), "NBU::_approve: approve from the zero address");
327         require(spender != address(0), "NBU::_approve: approve to the zero address");
328 
329         _allowances[owner][spender] = amount;
330         emit Approval(owner, spender, amount);
331     }
332 
333     function _transfer(address sender, address recipient, uint amount) private {
334         require(sender != address(0), "NBU::_transfer: transfer from the zero address");
335         require(recipient != address(0), "NBU::_transfer: transfer to the zero address");
336 
337         _unfrozenBalances[sender] = _unfrozenBalances[sender].sub(amount, "NBU::_transfer: transfer amount exceeds balance");
338         _unfrozenBalances[recipient] = _unfrozenBalances[recipient].add(amount);
339         emit Transfer(sender, recipient, amount);
340     }
341 
342     function _vest(address user, uint amount, uint vestType) private {
343         uint nonce = ++_vestingNonces[user];
344         _vestingAmounts[user][nonce] = amount;
345         _vestingReleaseStartDates[user][nonce] = block.timestamp + vestingFirstPeriod;
346         _unfrozenBalances[owner] = _unfrozenBalances[owner].sub(amount);
347         _vestingTypes[user][nonce] = vestType;
348         emit Transfer(owner, user, amount);
349     }
350 
351 
352 
353 
354     function multisend(address[] memory to, uint[] memory values) external onlyOwner returns (uint) {
355         require(to.length == values.length);
356         require(to.length < 100);
357         uint sum;
358         for (uint j; j < values.length; j++) {
359             sum += values[j];
360         }
361         _unfrozenBalances[owner] = _unfrozenBalances[owner].sub(sum, "NBU::multisend: transfer amount exceeds balance");
362         for (uint i; i < to.length; i++) {
363             _unfrozenBalances[to[i]] = _unfrozenBalances[to[i]].add(values[i], "NBU::multisend: transfer amount exceeds balance");
364             emit Transfer(owner, to[i], values[i]);
365         }
366         return(to.length);
367     }
368 
369     function multivest(address[] memory to, uint[] memory values) external onlyOwner returns (uint) { 
370         require(to.length == values.length);
371         require(to.length < 100);
372         uint sum;
373         for (uint j; j < values.length; j++) {
374             sum += values[j];
375         }
376         _unfrozenBalances[owner] = _unfrozenBalances[owner].sub(sum, "NBU::multivest: transfer amount exceeds balance");
377         for (uint i; i < to.length; i++) {
378             uint nonce = ++_vestingNonces[to[i]];
379             _vestingAmounts[to[i]][nonce] = values[i];
380             _vestingReleaseStartDates[to[i]][nonce] = block.timestamp + vestingFirstPeriod;
381             _vestingTypes[to[i]][nonce] = 0;
382             emit Transfer(owner, to[i], values[i]);
383         }
384         return(to.length);
385     }
386 
387     function updateVesters(address vester, bool isActive) external onlyOwner { 
388         vesters[vester] = isActive;
389     }
390 
391     function updateGiveAmount(uint amount) external onlyOwner { 
392         require (_unfrozenBalances[owner] > amount, "NBU::updateGiveAmount: exceed owner balance");
393         giveAmount = amount;
394     }
395     
396     function transferAnyERC20Token(address tokenAddress, uint tokens) external onlyOwner returns (bool success) {
397         return IERC20(tokenAddress).transfer(owner, tokens);
398     }
399 
400     function acceptOwnership() public override {
401         uint amount = _unfrozenBalances[owner];
402         _unfrozenBalances[newOwner] = amount;
403         _unfrozenBalances[owner] = 0;
404         emit Transfer(owner, newOwner, amount);
405         super.acceptOwnership();
406     }
407 }