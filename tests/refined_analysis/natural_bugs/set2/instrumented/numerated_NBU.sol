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
14 interface IBEP20 {
15     function totalSupply() external view returns (uint256);
16     function decimals() external view returns (uint8);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     function getOwner() external view returns (address);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 contract Ownable {
30     address public owner;
31     address public newOwner;
32 
33     event OwnershipTransferred(address indexed from, address indexed to);
34 
35     constructor() {
36         owner = msg.sender;
37         emit OwnershipTransferred(address(0), owner);
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner, "Ownable: Caller is not the owner");
42         _;
43     }
44 
45     function transferOwnership(address transferOwner) external onlyOwner {
46         require(transferOwner != newOwner);
47         newOwner = transferOwner;
48     }
49 
50     function acceptOwnership() virtual public {
51         require(msg.sender == newOwner);
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54         newOwner = address(0);
55     }
56 }
57 
58 contract Pausable is Ownable {
59     event Pause();
60     event Unpause();
61 
62     bool public paused = false;
63 
64 
65     modifier whenNotPaused() {
66         require(!paused);
67         _;
68     }
69 
70     modifier whenPaused() {
71         require(paused);
72         _;
73     }
74 
75     function pause() onlyOwner whenNotPaused public {
76         paused = true;
77         Pause();
78     }
79 
80     function unpause() onlyOwner whenPaused public {
81         paused = false;
82         Unpause();
83     }
84 }
85 
86 contract NBU is IBEP20, Ownable, Pausable {
87     mapping (address => mapping (address => uint)) private _allowances;
88     
89     mapping (address => uint) private _unfrozenBalances;
90 
91     mapping (address => uint) private _vestingNonces;
92     mapping (address => mapping (uint => uint)) private _vestingAmounts;
93     mapping (address => mapping (uint => uint)) private _unvestedAmounts;
94     mapping (address => mapping (uint => uint)) private _vestingTypes; //0 - multivest, 1 - single vest, > 2 give by vester id
95     mapping (address => mapping (uint => uint)) private _vestingReleaseStartDates;
96 
97     uint private _totalSupply = 1_000_000_000e18;
98     string private constant _name = "Nimbus";
99     string private constant _symbol = "NBU";
100     uint8 private constant _decimals = 18;
101 
102     uint private constant vestingFirstPeriod = 60 days;
103     uint private constant vestingSecondPeriod = 152 days;
104 
105     uint public giveAmount;
106     mapping (address => bool) public vesters;
107 
108     bytes32 public immutable DOMAIN_SEPARATOR;
109     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
110     mapping (address => uint) public nonces;
111 
112     event Unvest(address indexed user, uint amount);
113 
114     constructor () {
115         _unfrozenBalances[owner] = _totalSupply;
116         emit Transfer(address(0), owner, _totalSupply); 
117 
118         uint chainId = block.chainid;
119 
120         DOMAIN_SEPARATOR = keccak256(
121             abi.encode(
122                 keccak256('EIP712Domain(string name,uint256 chainId,address verifyingContract)'),
123                 keccak256(bytes(_name)),
124                 chainId,
125                 address(this)
126             )
127         );
128         giveAmount = _totalSupply / 10;
129     }
130 
131     receive() payable external {
132         revert();
133     }
134 
135     function getOwner() public override view returns (address) {
136         return owner;
137     }
138 
139     function approve(address spender, uint amount) external override whenNotPaused returns (bool) {
140         _approve(msg.sender, spender, amount);
141         return true;
142     }
143 
144     function transfer(address recipient, uint amount) external override whenNotPaused returns (bool) {
145         _transfer(msg.sender, recipient, amount);
146         return true;
147     }
148 
149     function transferFrom(address sender, address recipient, uint amount) external override whenNotPaused returns (bool) {
150         _transfer(sender, recipient, amount);
151         
152         uint256 currentAllowance = _allowances[sender][msg.sender];
153         require(currentAllowance >= amount, "NBU::transferFrom: transfer amount exceeds allowance");
154         _approve(sender, msg.sender, currentAllowance - amount);
155 
156         return true;
157     }
158 
159     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external whenNotPaused {
160         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
161         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
162         address signatory = ecrecover(digest, v, r, s);
163         require(signatory != address(0), "NBU::permit: invalid signature");
164         require(signatory == owner, "NBU::permit: unauthorized");
165         require(block.timestamp <= deadline, "NBU::permit: signature expired");
166 
167         _allowances[owner][spender] = amount;
168 
169         emit Approval(owner, spender, amount);
170     }
171 
172     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
173         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
174         return true;
175     }
176 
177     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
178         uint256 currentAllowance = _allowances[msg.sender][spender];
179         require(currentAllowance >= subtractedValue, "NBU::decreaseAllowance: decreased allowance below zero");
180         _approve(msg.sender, spender, currentAllowance - subtractedValue);
181 
182         return true;
183     }
184 
185     function unvest() external whenNotPaused returns (uint unvested) {
186         require (_vestingNonces[msg.sender] > 0, "NBU::unvest:No vested amount");
187         for (uint i = 1; i <= _vestingNonces[msg.sender]; i++) {
188             if (_vestingAmounts[msg.sender][i] == _unvestedAmounts[msg.sender][i]) continue;
189             if (_vestingReleaseStartDates[msg.sender][i] > block.timestamp) break;
190             uint toUnvest = (block.timestamp - _vestingReleaseStartDates[msg.sender][i]) * _vestingAmounts[msg.sender][i] / vestingSecondPeriod;
191             if (toUnvest > _vestingAmounts[msg.sender][i]) {
192                 toUnvest = _vestingAmounts[msg.sender][i];
193             } 
194             uint totalUnvestedForNonce = toUnvest;
195             toUnvest -= _unvestedAmounts[msg.sender][i];
196             unvested += toUnvest;
197             _unvestedAmounts[msg.sender][i] = totalUnvestedForNonce;
198         }
199         _unfrozenBalances[msg.sender] += unvested;
200         emit Unvest(msg.sender, unvested);
201     }
202 
203     function give(address user, uint amount, uint vesterId) external {
204         require (giveAmount > amount, "NBU::give: give finished");
205         require (vesters[msg.sender], "NBU::give: not vester");
206         giveAmount -= amount;
207         _vest(user, amount, vesterId);
208      }
209 
210     function vest(address user, uint amount) external {
211         require (vesters[msg.sender], "NBU::vest: not vester");
212         _vest(user, amount, 1);
213     }
214 
215     function burnTokens(uint amount) external onlyOwner returns (bool success) {
216         require(amount <= _unfrozenBalances[owner], "NBU::burnTokens: exceeds available amount");
217 
218         uint256 ownerBalance = _unfrozenBalances[owner];
219         require(ownerBalance >= amount, "NBU::burnTokens: burn amount exceeds owner balance");
220 
221         _unfrozenBalances[owner] = ownerBalance - amount;
222         _totalSupply -= amount;
223         emit Transfer(owner, address(0), amount);
224         return true;
225     }
226 
227 
228 
229     function allowance(address owner, address spender) external view override returns (uint) {
230         return _allowances[owner][spender];
231     }
232 
233     function decimals() external override pure returns (uint8) {
234         return _decimals;
235     }
236 
237     function name() external pure returns (string memory) {
238         return _name;
239     }
240 
241     function symbol() external pure returns (string memory) {
242         return _symbol;
243     }
244 
245     function totalSupply() external view override returns (uint) {
246         return _totalSupply;
247     }
248 
249     function balanceOf(address account) external view override returns (uint) {
250         uint amount = _unfrozenBalances[account];
251         if (_vestingNonces[account] == 0) return amount;
252         for (uint i = 1; i <= _vestingNonces[account]; i++) {
253             amount = amount + _vestingAmounts[account][i] - _unvestedAmounts[account][i];
254         }
255         return amount;
256     }
257 
258     function availableForUnvesting(address user) external view returns (uint unvestAmount) {
259         if (_vestingNonces[user] == 0) return 0;
260         for (uint i = 1; i <= _vestingNonces[user]; i++) {
261             if (_vestingAmounts[user][i] == _unvestedAmounts[user][i]) continue;
262             if (_vestingReleaseStartDates[user][i] > block.timestamp) break;
263             uint toUnvest = (block.timestamp - _vestingReleaseStartDates[user][i]) * _vestingAmounts[user][i] / vestingSecondPeriod;
264             if (toUnvest > _vestingAmounts[user][i]) {
265                 toUnvest = _vestingAmounts[user][i];
266             } 
267             toUnvest -= _unvestedAmounts[user][i];
268             unvestAmount += toUnvest;
269         }
270     }
271 
272     function availableForTransfer(address account) external view returns (uint) {
273         return _unfrozenBalances[account];
274     }
275 
276     function vestingInfo(address user, uint nonce) external view returns (uint vestingAmount, uint unvestedAmount, uint vestingReleaseStartDate, uint vestType) {
277         vestingAmount = _vestingAmounts[user][nonce];
278         unvestedAmount = _unvestedAmounts[user][nonce];
279         vestingReleaseStartDate = _vestingReleaseStartDates[user][nonce];
280         vestType = _vestingTypes[user][nonce];
281     }
282 
283     function vestingNonces(address user) external view returns (uint lastNonce) {
284         return _vestingNonces[user];
285     }
286 
287 
288 
289     function _approve(address owner, address spender, uint amount) private {
290         require(owner != address(0), "NBU::_approve: approve from the zero address");
291         require(spender != address(0), "NBU::_approve: approve to the zero address");
292 
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296 
297     function _transfer(address sender, address recipient, uint amount) private {
298         require(sender != address(0), "NBU::_transfer: transfer from the zero address");
299         require(recipient != address(0), "NBU::_transfer: transfer to the zero address");
300 
301         uint256 senderAvailableBalance = _unfrozenBalances[sender];
302         require(senderAvailableBalance >= amount, "NBU::_transfer: amount exceeds available for transfer balance");
303         _unfrozenBalances[sender] = senderAvailableBalance - amount;
304         _unfrozenBalances[recipient] += amount;
305 
306         emit Transfer(sender, recipient, amount);
307     }
308 
309     function _vest(address user, uint amount, uint vestType) private {
310         require(user != address(0), "NBU::_vest: vest to the zero address");
311         uint nonce = ++_vestingNonces[user];
312         _vestingAmounts[user][nonce] = amount;
313         _vestingReleaseStartDates[user][nonce] = block.timestamp + vestingFirstPeriod;
314         _unfrozenBalances[owner] -= amount;
315         _vestingTypes[user][nonce] = vestType;
316         emit Transfer(owner, user, amount);
317     }
318 
319 
320 
321 
322     function multisend(address[] memory to, uint[] memory values) external onlyOwner returns (uint) {
323         require(to.length == values.length);
324         require(to.length < 100);
325         uint sum;
326         for (uint j; j < values.length; j++) {
327             sum += values[j];
328         }
329         _unfrozenBalances[owner] -= sum;
330         for (uint i; i < to.length; i++) {
331             _unfrozenBalances[to[i]] += values[i];
332             emit Transfer(owner, to[i], values[i]);
333         }
334         return(to.length);
335     }
336 
337     function multivest(address[] memory to, uint[] memory values) external onlyOwner returns (uint) { 
338         require(to.length == values.length);
339         require(to.length < 100);
340         uint sum;
341         for (uint j; j < values.length; j++) {
342             sum += values[j];
343         }
344         _unfrozenBalances[owner] -= sum;
345         for (uint i; i < to.length; i++) {
346             uint nonce = ++_vestingNonces[to[i]];
347             _vestingAmounts[to[i]][nonce] = values[i];
348             _vestingReleaseStartDates[to[i]][nonce] = block.timestamp + vestingFirstPeriod;
349             _vestingTypes[to[i]][nonce] = 0;
350             emit Transfer(owner, to[i], values[i]);
351         }
352         return(to.length);
353     }
354 
355     function updateVesters(address vester, bool isActive) external onlyOwner { 
356         vesters[vester] = isActive;
357     }
358 
359     function updateGiveAmount(uint amount) external onlyOwner { 
360         require (_unfrozenBalances[owner] > amount, "NBU::updateGiveAmount: exceed owner balance");
361         giveAmount = amount;
362     }
363     
364     function transferAnyBEP20Token(address tokenAddress, uint tokens) external onlyOwner returns (bool success) {
365         return IBEP20(tokenAddress).transfer(owner, tokens);
366     }
367 
368     function acceptOwnership() public override {
369         uint amount = _unfrozenBalances[owner];
370         _unfrozenBalances[newOwner] = amount;
371         _unfrozenBalances[owner] = 0;
372         emit Transfer(owner, newOwner, amount);
373         super.acceptOwnership();
374     }
375 }