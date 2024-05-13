1 pragma solidity =0.8.0;
2 
3 // ----------------------------------------------------------------------------
4 // GNBU token main contract (2021)
5 //
6 // Symbol       : GNBU
7 // Name         : Nimbus Governance Token
8 // Total supply : 100.000.000 (burnable)
9 // Decimals     : 18
10 // ----------------------------------------------------------------------------
11 // SPDX-License-Identifier: MIT
12 // ----------------------------------------------------------------------------
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint);
16     function balanceOf(address tokenOwner) external view returns (uint balance);
17     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
18     function transfer(address to, uint tokens) external returns (bool success);
19     function approve(address spender, uint tokens) external returns (bool success);
20     function transferFrom(address from, address to, uint tokens) external returns (bool success);
21 
22     event Transfer(address indexed from, address indexed to, uint tokens);
23     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
24 }
25 
26 contract Ownable {
27     address public owner;
28     address public newOwner;
29 
30     event OwnershipTransferred(address indexed from, address indexed to);
31 
32     constructor() {
33         owner = msg.sender;
34         emit OwnershipTransferred(address(0), owner);
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner, "Ownable: Caller is not the owner");
39         _;
40     }
41 
42     function transferOwnership(address transferOwner) external onlyOwner {
43         require(transferOwner != newOwner);
44         newOwner = transferOwner;
45     }
46 
47     function acceptOwnership() virtual external {
48         require(msg.sender == newOwner);
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51         newOwner = address(0);
52     }
53 }
54 
55 contract Pausable is Ownable {
56     event Pause();
57     event Unpause();
58 
59     bool public paused = false;
60 
61 
62     modifier whenNotPaused() {
63         require(!paused);
64         _;
65     }
66 
67     modifier whenPaused() {
68         require(paused);
69         _;
70     }
71 
72     function pause() onlyOwner whenNotPaused public {
73         paused = true;
74         Pause();
75     }
76 
77     function unpause() onlyOwner whenPaused public {
78         paused = false;
79         Unpause();
80     }
81 }
82 
83 contract GNBU is Ownable, Pausable {
84     string public constant name = "Nimbus Governance Token";
85     string public constant symbol = "GNBU";
86     uint8 public constant decimals = 18;
87     uint96 public totalSupply = 100_000_000e18; // 100 million GNBU
88     mapping (address => mapping (address => uint96)) internal allowances;
89 
90     mapping (address => uint96) private _unfrozenBalances;
91     mapping (address => uint32) private _vestingNonces;
92     mapping (address => mapping (uint32 => uint96)) private _vestingAmounts;
93     mapping (address => mapping (uint32 => uint96)) private _unvestedAmounts;
94     mapping (address => mapping (uint32 => uint)) private _vestingReleaseStartDates;
95     mapping (address => bool) public vesters;
96 
97     uint96 private vestingFirstPeriod = 60 days;
98     uint96 private vestingSecondPeriod = 152 days;
99 
100     address[] public supportUnits;
101     uint public supportUnitsCnt;
102 
103     mapping (address => address) public delegates;
104     struct Checkpoint {
105         uint32 fromBlock;
106         uint96 votes;
107     }
108     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
109     mapping (address => uint32) public numCheckpoints;
110 
111     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
112     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
113     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
114     mapping (address => uint) public nonces;
115     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
116     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
117     event Transfer(address indexed from, address indexed to, uint256 amount);
118     event Approval(address indexed owner, address indexed spender, uint256 amount);
119     event Unvest(address indexed user, uint amount);
120 
121     constructor() {
122         _unfrozenBalances[owner] = uint96(totalSupply);
123         emit Transfer(address(0), owner, totalSupply);
124     }
125 
126     receive() payable external {
127         revert();
128     }
129 
130     function freeCirculation() external view returns (uint) {
131         uint96 systemAmount = _unfrozenBalances[owner];
132         for (uint i; i < supportUnits.length; i++) {
133             systemAmount = add96(systemAmount, _unfrozenBalances[supportUnits[i]], "GNBU::freeCirculation: adding overflow");
134         }
135         return sub96(totalSupply, systemAmount, "GNBU::freeCirculation: amount exceed totalSupply");
136     }
137     
138     function allowance(address account, address spender) external view returns (uint) {
139         return allowances[account][spender];
140     }
141 
142     function approve(address spender, uint rawAmount) external whenNotPaused returns (bool) {
143         require(spender != address(0), "GNBU::approve: approve to the zero address");
144 
145         uint96 amount;
146         if (rawAmount == type(uint256).max) {
147             amount = type(uint96).max;
148         } else {
149             amount = safe96(rawAmount, "GNBU::approve: amount exceeds 96 bits");
150         }
151 
152         allowances[msg.sender][spender] = amount;
153 
154         emit Approval(msg.sender, spender, amount);
155         return true;
156     }
157     
158     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external whenNotPaused {
159         uint96 amount;
160         if (rawAmount == type(uint256).max) {
161             amount = type(uint96).max;
162         } else {
163             amount = safe96(rawAmount, "GNBU::permit: amount exceeds 96 bits");
164         }
165 
166         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
167         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
168         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
169         address signatory = ecrecover(digest, v, r, s);
170         require(signatory != address(0), "GNBU::permit: invalid signature");
171         require(signatory == owner, "GNBU::permit: unauthorized");
172         require(block.timestamp <= deadline, "GNBU::permit: signature expired");
173 
174         allowances[owner][spender] = amount;
175 
176         emit Approval(owner, spender, amount);
177     }
178        
179     function balanceOf(address account) public view returns (uint) {
180         uint96 amount = _unfrozenBalances[account];
181         if (_vestingNonces[account] == 0) return amount;
182         for (uint32 i = 1; i <= _vestingNonces[account]; i++) {
183             uint96 unvested = sub96(_vestingAmounts[account][i], _unvestedAmounts[account][i], "GNBU::balanceOf: unvested exceed vested amount");
184             amount = add96(amount, unvested, "GNBU::balanceOf: overflow");
185         }
186         return amount;
187     }
188 
189     function availableForUnvesting(address user) external view returns (uint unvestAmount) {
190         if (_vestingNonces[user] == 0) return 0;
191         for (uint32 i = 1; i <= _vestingNonces[user]; i++) {
192             if (_vestingAmounts[user][i] == _unvestedAmounts[user][i]) continue;
193             if (_vestingReleaseStartDates[user][i] > block.timestamp) break;
194             uint toUnvest = (block.timestamp - _vestingReleaseStartDates[user][i]) * _vestingAmounts[user][i] / vestingSecondPeriod;
195             if (toUnvest > _vestingAmounts[user][i]) {
196                 toUnvest = _vestingAmounts[user][i];
197             } 
198             toUnvest -= _unvestedAmounts[user][i];
199             unvestAmount += toUnvest;
200         }
201     }
202 
203     function availableForTransfer(address account) external view returns (uint) {
204         return _unfrozenBalances[account];
205     }
206 
207     function vestingInfo(address user, uint32 nonce) external view returns (uint vestingAmount, uint unvestedAmount, uint vestingReleaseStartDate) {
208         vestingAmount = _vestingAmounts[user][nonce];
209         unvestedAmount = _unvestedAmounts[user][nonce];
210         vestingReleaseStartDate = _vestingReleaseStartDates[user][nonce];
211     }
212 
213     function vestingNonces(address user) external view returns (uint lastNonce) {
214         return _vestingNonces[user];
215     }
216     
217     function transfer(address dst, uint rawAmount) external whenNotPaused returns (bool) {
218         uint96 amount = safe96(rawAmount, "GNBU::transfer: amount exceeds 96 bits");
219         _transferTokens(msg.sender, dst, amount);
220         return true;
221     }
222     
223     function transferFrom(address src, address dst, uint rawAmount) external whenNotPaused returns (bool) {
224         address spender = msg.sender;
225         uint96 spenderAllowance = allowances[src][spender];
226         uint96 amount = safe96(rawAmount, "GNBU::approve: amount exceeds 96 bits");
227 
228         if (spender != src && spenderAllowance != type(uint96).max) {
229             uint96 newAllowance = sub96(spenderAllowance, amount, "GNBU::transferFrom: transfer amount exceeds spender allowance");
230             allowances[src][spender] = newAllowance;
231 
232             emit Approval(src, spender, newAllowance);
233         }
234 
235         _transferTokens(src, dst, amount);
236         return true;
237     }
238     
239     function delegate(address delegatee) public whenNotPaused {
240         return _delegate(msg.sender, delegatee);
241     }
242     
243     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public whenNotPaused {
244         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
245         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
246         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
247         address signatory = ecrecover(digest, v, r, s);
248         require(signatory != address(0), "GNBU::delegateBySig: invalid signature");
249         require(nonce == nonces[signatory]++, "GNBU::delegateBySig: invalid nonce");
250         require(block.timestamp <= expiry, "GNBU::delegateBySig: signature expired");
251         return _delegate(signatory, delegatee);
252     }
253 
254     function unvest() external whenNotPaused returns (uint unvested) {
255         require (_vestingNonces[msg.sender] > 0, "GNBU::unvest:No vested amount");
256         for (uint32 i = 1; i <= _vestingNonces[msg.sender]; i++) {
257             if (_vestingAmounts[msg.sender][i] == _unvestedAmounts[msg.sender][i]) continue;
258             if (_vestingReleaseStartDates[msg.sender][i] > block.timestamp) break;
259             uint toUnvest = (block.timestamp - _vestingReleaseStartDates[msg.sender][i]) * _vestingAmounts[msg.sender][i] / vestingSecondPeriod;
260             if (toUnvest > _vestingAmounts[msg.sender][i]) {
261                 toUnvest = _vestingAmounts[msg.sender][i];
262             } 
263             uint totalUnvestedForNonce = toUnvest;
264             require(toUnvest >= _unvestedAmounts[msg.sender][i], "GNBU::unvest: already unvested amount exceeds toUnvest");
265             toUnvest -= _unvestedAmounts[msg.sender][i];
266             unvested += toUnvest;
267             _unvestedAmounts[msg.sender][i] = safe96(totalUnvestedForNonce, "GNBU::unvest: amount exceeds 96 bits");
268         }
269         _unfrozenBalances[msg.sender] = add96(_unfrozenBalances[msg.sender], safe96(unvested, "GNBU::unvest: amount exceeds 96 bits"), "GNBU::unvest: adding overflow");
270         emit Unvest(msg.sender, unvested);
271     }
272     
273     function getCurrentVotes(address account) external view returns (uint96) {
274         uint32 nCheckpoints = numCheckpoints[account];
275         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
276     }
277     
278     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
279         require(blockNumber < block.number, "GNBU::getPriorVotes: not yet determined");
280 
281         uint32 nCheckpoints = numCheckpoints[account];
282         if (nCheckpoints == 0) {
283             return 0;
284         }
285 
286         // First check most recent balance
287         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
288             return checkpoints[account][nCheckpoints - 1].votes;
289         }
290 
291         // Next check implicit zero balance
292         if (checkpoints[account][0].fromBlock > blockNumber) {
293             return 0;
294         }
295 
296         uint32 lower = 0;
297         uint32 upper = nCheckpoints - 1;
298         while (upper > lower) {
299             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
300             Checkpoint memory cp = checkpoints[account][center];
301             if (cp.fromBlock == blockNumber) {
302                 return cp.votes;
303             } else if (cp.fromBlock < blockNumber) {
304                 lower = center;
305             } else {
306                 upper = center - 1;
307             }
308         }
309         return checkpoints[account][lower].votes;
310     }
311     
312     function _delegate(address delegator, address delegatee) internal {
313         address currentDelegate = delegates[delegator];
314         uint96 delegatorBalance = _unfrozenBalances[delegator];
315         delegates[delegator] = delegatee;
316 
317         emit DelegateChanged(delegator, currentDelegate, delegatee);
318 
319         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
320     }
321 
322     function _transferTokens(address src, address dst, uint96 amount) internal {
323         require(src != address(0), "GNBU::_transferTokens: cannot transfer from the zero address");
324         require(dst != address(0), "GNBU::_transferTokens: cannot transfer to the zero address");
325 
326         _unfrozenBalances[src] = sub96(_unfrozenBalances[src], amount, "GNBU::_transferTokens: transfer amount exceeds balance");
327         _unfrozenBalances[dst] = add96(_unfrozenBalances[dst], amount, "GNBU::_transferTokens: transfer amount overflows");
328         emit Transfer(src, dst, amount);
329 
330         _moveDelegates(delegates[src], delegates[dst], amount);
331     }
332     
333     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
334         if (srcRep != dstRep && amount > 0) {
335             if (srcRep != address(0)) {
336                 uint32 srcRepNum = numCheckpoints[srcRep];
337                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
338                 uint96 srcRepNew = sub96(srcRepOld, amount, "GNBU::_moveVotes: vote amount underflows");
339                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
340             }
341 
342             if (dstRep != address(0)) {
343                 uint32 dstRepNum = numCheckpoints[dstRep];
344                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
345                 uint96 dstRepNew = add96(dstRepOld, amount, "GNBU::_moveVotes: vote amount overflows");
346                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
347             }
348         }
349     }
350     
351     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
352       uint32 blockNumber = safe32(block.number, "GNBU::_writeCheckpoint: block number exceeds 32 bits");
353 
354       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
355           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
356       } else {
357           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
358           numCheckpoints[delegatee] = nCheckpoints + 1;
359       }
360 
361       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
362     }
363 
364     function _vest(address user, uint96 amount) private {
365         require(user != address(0), "GNBU::_vest: vest to the zero address");
366         uint32 nonce = ++_vestingNonces[user];
367         _vestingAmounts[user][nonce] = amount;
368         _vestingReleaseStartDates[user][nonce] = block.timestamp + vestingFirstPeriod;
369         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], amount, "GNBU::_vest: exceeds owner balance");
370         emit Transfer(owner, user, amount);
371     }
372 
373 
374     
375     function burnTokens(uint rawAmount) public onlyOwner returns (bool success) {
376         uint96 amount = safe96(rawAmount, "GNBU::burnTokens: amount exceeds 96 bits");
377         require(amount <= _unfrozenBalances[owner]);
378         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], amount, "GNBU::burnTokens: transfer amount exceeds balance");
379         totalSupply = sub96(totalSupply, amount, "GNBU::burnTokens: transfer amount exceeds total supply");
380         emit Transfer(owner, address(0), amount);
381         return true;
382     }
383 
384     function vest(address user, uint rawAmount) external {
385         require (vesters[msg.sender], "GNBU::vest: not vester");
386         uint96 amount = safe96(rawAmount, "GNBU::vest: amount exceeds 96 bits");
387         _vest(user, amount);
388     }
389     
390    
391     function multisend(address[] memory to, uint[] memory values) public onlyOwner returns (uint) {
392         require(to.length == values.length);
393         require(to.length < 100);
394         uint sum;
395         for (uint j; j < values.length; j++) {
396             sum += values[j];
397         }
398         uint96 _sum = safe96(sum, "GNBU::transfer: amount exceeds 96 bits");
399         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], _sum, "GNBU::_transferTokens: transfer amount exceeds balance");
400         for (uint i; i < to.length; i++) {
401             _unfrozenBalances[to[i]] = add96(_unfrozenBalances[to[i]], uint96(values[i]), "GNBU::_transferTokens: transfer amount exceeds balance");
402             emit Transfer(owner, to[i], values[i]);
403         }
404         return(to.length);
405     }
406 
407     function multivest(address[] memory to, uint[] memory values) external onlyOwner returns (uint) {
408         require(to.length == values.length);
409         require(to.length < 100);
410         uint sum;
411         for (uint j; j < values.length; j++) {
412             sum += values[j];
413         }
414         uint96 _sum = safe96(sum, "GNBU::multivest: amount exceeds 96 bits");
415         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], _sum, "GNBU::multivest: transfer amount exceeds balance");
416         for (uint i; i < to.length; i++) {
417             uint32 nonce = ++_vestingNonces[to[i]];
418             _vestingAmounts[to[i]][nonce] = uint96(values[i]);
419             _vestingReleaseStartDates[to[i]][nonce] = block.timestamp + vestingFirstPeriod;
420             emit Transfer(owner, to[i], values[i]);
421         }
422         return(to.length);
423     }
424     
425     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
426         return IERC20(tokenAddress).transfer(owner, tokens);
427     }
428 
429     function updateVesters(address vester, bool isActive) external onlyOwner { 
430         vesters[vester] = isActive;
431     }
432 
433     function acceptOwnership() public override {
434         require(msg.sender == newOwner);
435         uint96 amount = _unfrozenBalances[owner];
436         _transferTokens(owner, newOwner, amount);
437         emit OwnershipTransferred(owner, newOwner);
438         owner = newOwner;
439         newOwner = address(0);
440     }
441 
442     function updateSupportUnitAdd(address newSupportUnit) external onlyOwner {
443         for (uint i; i < supportUnits.length; i++) {
444             require (supportUnits[i] != newSupportUnit, "GNBU::updateSupportUnitAdd: support unit exists");
445         }
446         supportUnits.push(newSupportUnit);
447         supportUnitsCnt++;
448     }
449 
450     function updateSupportUnitRemove(uint supportUnitIndex) external onlyOwner {
451         supportUnits[supportUnitIndex] = supportUnits[supportUnits.length - 1];
452         supportUnits.pop();
453         supportUnitsCnt--;
454     }
455     
456 
457 
458 
459     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
460         require(n < 2**32, errorMessage);
461         return uint32(n);
462     }
463 
464     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
465         require(n < 2**96, errorMessage);
466         return uint96(n);
467     }
468 
469     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
470         uint96 c = a + b;
471         require(c >= a, errorMessage);
472         return c;
473     }
474 
475     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
476         require(b <= a, errorMessage);
477         return a - b;
478     }
479 
480     function getChainId() internal view returns (uint) {
481         return block.chainid;
482     }
483 
484         
485     function mul96(uint96 a, uint96 b) internal pure returns (uint96) {
486         if (a == 0) {
487             return 0;
488         }
489         uint96 c = a * b;
490         require(c / a == b, "GNBU:mul96: multiplication overflow");
491         return c;
492     }
493 
494     function mul96(uint256 a, uint96 b) internal pure returns (uint96) {
495         uint96 _a = safe96(a, "GNBU:mul96: amount exceeds uint96");
496         if (_a == 0) {
497             return 0;
498         }
499         uint96 c = _a * b;
500         require(c / _a == b, "GNBU:mul96: multiplication overflow");
501         return c;
502     }
503 }