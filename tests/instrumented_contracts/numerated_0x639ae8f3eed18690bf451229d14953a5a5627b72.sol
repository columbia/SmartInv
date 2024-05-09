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
42     function transferOwnership(address transferOwner) public onlyOwner {
43         require(transferOwner != newOwner);
44         newOwner = transferOwner;
45     }
46 
47     function acceptOwnership() virtual public {
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
119     event Unvest(address user, uint amount);
120 
121     constructor() {
122         _unfrozenBalances[owner] = uint96(totalSupply);
123         emit Transfer(address(0), owner, totalSupply);
124     }
125 
126     function freeCirculation() external view returns (uint) {
127         uint96 systemAmount = _unfrozenBalances[owner];
128         for (uint i; i < supportUnits.length; i++) {
129             systemAmount = add96(systemAmount, _unfrozenBalances[supportUnits[i]], "GNBU::freeCirculation: adding overflow");
130         }
131         return sub96(totalSupply, systemAmount, "GNBU::freeCirculation: amount exceed totalSupply");
132     }
133     
134     function allowance(address account, address spender) external view returns (uint) {
135         return allowances[account][spender];
136     }
137 
138     function approve(address spender, uint rawAmount) external whenNotPaused returns (bool) {
139         uint96 amount;
140         if (rawAmount == uint(2 ** 256 - 1)) {
141             amount = uint96(2 ** 96 - 1);
142         } else {
143             amount = safe96(rawAmount, "GNBU::approve: amount exceeds 96 bits");
144         }
145 
146         allowances[msg.sender][spender] = amount;
147 
148         emit Approval(msg.sender, spender, amount);
149         return true;
150     }
151     
152     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external whenNotPaused {
153         uint96 amount;
154         if (rawAmount == uint(2 ** 256 - 1)) {
155             amount = uint96(2 ** 96 - 1);
156         } else {
157             amount = safe96(rawAmount, "GNBU::permit: amount exceeds 96 bits");
158         }
159 
160         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
161         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
162         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
163         address signatory = ecrecover(digest, v, r, s);
164         require(signatory != address(0), "GNBU::permit: invalid signature");
165         require(signatory == owner, "GNBU::permit: unauthorized");
166         require(block.timestamp <= deadline, "GNBU::permit: signature expired");
167 
168         allowances[owner][spender] = amount;
169 
170         emit Approval(owner, spender, amount);
171     }
172        
173     function balanceOf(address account) public view returns (uint) {
174         uint96 amount = _unfrozenBalances[account];
175         if (_vestingNonces[account] == 0) return amount;
176         for (uint32 i = 1; i <= _vestingNonces[account]; i++) {
177             uint96 unvested = sub96(_vestingAmounts[account][i], _unvestedAmounts[account][i], "GNBU::balanceOf: unvested exceed vested amount");
178             amount = add96(amount, unvested, "GNBU::balanceOf: overflow");
179         }
180         return amount;
181     }
182 
183     function availableForUnvesting(address user) external view returns (uint unvestAmount) {
184         if (_vestingNonces[user] == 0) return 0;
185         for (uint32 i = 1; i <= _vestingNonces[user]; i++) {
186             if (_vestingAmounts[user][i] == _unvestedAmounts[user][i]) continue;
187             if (_vestingReleaseStartDates[user][i] > block.timestamp) break;
188             uint toUnvest = mul96((block.timestamp - _vestingReleaseStartDates[user][i]), (_vestingAmounts[user][i])) / vestingSecondPeriod;
189             if (toUnvest > _vestingAmounts[user][i]) {
190                 toUnvest = _vestingAmounts[user][i];
191             } 
192             toUnvest -= _unvestedAmounts[user][i];
193             unvestAmount += toUnvest;
194         }
195     }
196 
197     function availableForTransfer(address account) external view returns (uint) {
198         return _unfrozenBalances[account];
199     }
200 
201     function vestingInfo(address user, uint32 nonce) external view returns (uint vestingAmount, uint unvestedAmount, uint vestingReleaseStartDate) {
202         vestingAmount = _vestingAmounts[user][nonce];
203         unvestedAmount = _unvestedAmounts[user][nonce];
204         vestingReleaseStartDate = _vestingReleaseStartDates[user][nonce];
205     }
206 
207     function vestingNonces(address user) external view returns (uint lastNonce) {
208         return _vestingNonces[user];
209     }
210     
211     function transfer(address dst, uint rawAmount) external whenNotPaused returns (bool) {
212         uint96 amount = safe96(rawAmount, "GNBU::transfer: amount exceeds 96 bits");
213         _transferTokens(msg.sender, dst, amount);
214         return true;
215     }
216     
217     function transferFrom(address src, address dst, uint rawAmount) external whenNotPaused returns (bool) {
218         address spender = msg.sender;
219         uint96 spenderAllowance = allowances[src][spender];
220         uint96 amount = safe96(rawAmount, "GNBU::approve: amount exceeds 96 bits");
221 
222         if (spender != src && spenderAllowance != uint96(2 ** 96 - 1)) {
223             uint96 newAllowance = sub96(spenderAllowance, amount, "GNBU::transferFrom: transfer amount exceeds spender allowance");
224             allowances[src][spender] = newAllowance;
225 
226             emit Approval(src, spender, newAllowance);
227         }
228 
229         _transferTokens(src, dst, amount);
230         return true;
231     }
232     
233     function delegate(address delegatee) public whenNotPaused {
234         return _delegate(msg.sender, delegatee);
235     }
236     
237     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public whenNotPaused {
238         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
239         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
240         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
241         address signatory = ecrecover(digest, v, r, s);
242         require(signatory != address(0), "GNBU::delegateBySig: invalid signature");
243         require(nonce == nonces[signatory]++, "GNBU::delegateBySig: invalid nonce");
244         require(block.timestamp <= expiry, "GNBU::delegateBySig: signature expired");
245         return _delegate(signatory, delegatee);
246     }
247 
248     function unvest() external whenNotPaused returns (uint96 unvested) {
249         require (_vestingNonces[msg.sender] > 0, "GNBU::unvest:No vested amount");
250         for (uint32 i = 1; i <= _vestingNonces[msg.sender]; i++) {
251             if (_vestingAmounts[msg.sender][i] == _unvestedAmounts[msg.sender][i]) continue;
252             if (_vestingReleaseStartDates[msg.sender][i] > block.timestamp) break;
253             uint96 toUnvest = mul96((block.timestamp - _vestingReleaseStartDates[msg.sender][i]), _vestingAmounts[msg.sender][i]) / vestingSecondPeriod;
254             if (toUnvest > _vestingAmounts[msg.sender][i]) {
255                 toUnvest = _vestingAmounts[msg.sender][i];
256             } 
257             uint96 totalUnvestedForNonce = toUnvest;
258             toUnvest = sub96(toUnvest, _unvestedAmounts[msg.sender][i], "GNBU::unvest: already unvested amount exceeds toUnvest");
259             unvested = add96(unvested, toUnvest, "GNBU::unvest: adding overflow");
260             _unvestedAmounts[msg.sender][i] = totalUnvestedForNonce;
261         }
262         _unfrozenBalances[msg.sender] = add96(_unfrozenBalances[msg.sender], unvested, "GNBU::unvest: adding overflow");
263         emit Unvest(msg.sender, unvested);
264     }
265     
266     function getCurrentVotes(address account) external view returns (uint96) {
267         uint32 nCheckpoints = numCheckpoints[account];
268         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
269     }
270     
271     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
272         require(blockNumber < block.number, "GNBU::getPriorVotes: not yet determined");
273 
274         uint32 nCheckpoints = numCheckpoints[account];
275         if (nCheckpoints == 0) {
276             return 0;
277         }
278 
279         // First check most recent balance
280         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
281             return checkpoints[account][nCheckpoints - 1].votes;
282         }
283 
284         // Next check implicit zero balance
285         if (checkpoints[account][0].fromBlock > blockNumber) {
286             return 0;
287         }
288 
289         uint32 lower = 0;
290         uint32 upper = nCheckpoints - 1;
291         while (upper > lower) {
292             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
293             Checkpoint memory cp = checkpoints[account][center];
294             if (cp.fromBlock == blockNumber) {
295                 return cp.votes;
296             } else if (cp.fromBlock < blockNumber) {
297                 lower = center;
298             } else {
299                 upper = center - 1;
300             }
301         }
302         return checkpoints[account][lower].votes;
303     }
304     
305     function _delegate(address delegator, address delegatee) internal {
306         address currentDelegate = delegates[delegator];
307         uint96 delegatorBalance = _unfrozenBalances[delegator];
308         delegates[delegator] = delegatee;
309 
310         emit DelegateChanged(delegator, currentDelegate, delegatee);
311 
312         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
313     }
314 
315     function _transferTokens(address src, address dst, uint96 amount) internal {
316         require(src != address(0), "GNBU::_transferTokens: cannot transfer from the zero address");
317         require(dst != address(0), "GNBU::_transferTokens: cannot transfer to the zero address");
318 
319         _unfrozenBalances[src] = sub96(_unfrozenBalances[src], amount, "GNBU::_transferTokens: transfer amount exceeds balance");
320         _unfrozenBalances[dst] = add96(_unfrozenBalances[dst], amount, "GNBU::_transferTokens: transfer amount overflows");
321         emit Transfer(src, dst, amount);
322 
323         _moveDelegates(delegates[src], delegates[dst], amount);
324     }
325     
326     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
327         if (srcRep != dstRep && amount > 0) {
328             if (srcRep != address(0)) {
329                 uint32 srcRepNum = numCheckpoints[srcRep];
330                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
331                 uint96 srcRepNew = sub96(srcRepOld, amount, "GNBU::_moveVotes: vote amount underflows");
332                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
333             }
334 
335             if (dstRep != address(0)) {
336                 uint32 dstRepNum = numCheckpoints[dstRep];
337                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
338                 uint96 dstRepNew = add96(dstRepOld, amount, "GNBU::_moveVotes: vote amount overflows");
339                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
340             }
341         }
342     }
343     
344     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
345       uint32 blockNumber = safe32(block.number, "GNBU::_writeCheckpoint: block number exceeds 32 bits");
346 
347       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
348           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
349       } else {
350           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
351           numCheckpoints[delegatee] = nCheckpoints + 1;
352       }
353 
354       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
355     }
356 
357     function _vest(address user, uint96 amount) private {
358         uint32 nonce = ++_vestingNonces[user];
359         _vestingAmounts[user][nonce] = amount;
360         _vestingReleaseStartDates[user][nonce] = block.timestamp + vestingFirstPeriod;
361         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], amount, "GNBU::_vest: exceeds owner balance");
362         emit Transfer(owner, user, amount);
363     }
364 
365 
366     
367     function burnTokens(uint rawAmount) public onlyOwner returns (bool success) {
368         uint96 amount = safe96(rawAmount, "GNBU::burnTokens: amount exceeds 96 bits");
369         require(amount <= _unfrozenBalances[owner]);
370         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], amount, "GNBU::burnTokens: transfer amount exceeds balance");
371         totalSupply = sub96(totalSupply, amount, "GNBU::burnTokens: transfer amount exceeds total supply");
372         emit Transfer(owner, address(0), amount);
373         return true;
374     }
375 
376     function vest(address user, uint rawAmount) external {
377         require (vesters[msg.sender], "GNBU::vest: not vester");
378         uint96 amount = safe96(rawAmount, "GNBU::vest: amount exceeds 96 bits");
379         _vest(user, amount);
380     }
381     
382    
383     function multisend(address[] memory to, uint[] memory values) public onlyOwner returns (uint) {
384         require(to.length == values.length);
385         require(to.length < 100);
386         uint sum;
387         for (uint j; j < values.length; j++) {
388             sum += values[j];
389         }
390         uint96 _sum = safe96(sum, "GNBU::transfer: amount exceeds 96 bits");
391         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], _sum, "GNBU::_transferTokens: transfer amount exceeds balance");
392         for (uint i; i < to.length; i++) {
393             _unfrozenBalances[to[i]] = add96(_unfrozenBalances[to[i]], uint96(values[i]), "GNBU::_transferTokens: transfer amount exceeds balance");
394             emit Transfer(owner, to[i], values[i]);
395         }
396         return(to.length);
397     }
398 
399     function multivest(address[] memory to, uint[] memory values) external onlyOwner returns (uint) {
400         require(to.length == values.length);
401         require(to.length < 100);
402         uint sum;
403         for (uint j; j < values.length; j++) {
404             sum += values[j];
405         }
406         uint96 _sum = safe96(sum, "GNBU::multivest: amount exceeds 96 bits");
407         _unfrozenBalances[owner] = sub96(_unfrozenBalances[owner], _sum, "GNBU::multivest: transfer amount exceeds balance");
408         for (uint i; i < to.length; i++) {
409             uint32 nonce = ++_vestingNonces[to[i]];
410             _vestingAmounts[to[i]][nonce] = uint96(values[i]);
411             _vestingReleaseStartDates[to[i]][nonce] = block.timestamp + vestingFirstPeriod;
412             emit Transfer(owner, to[i], values[i]);
413         }
414         return(to.length);
415     }
416     
417     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
418         return IERC20(tokenAddress).transfer(owner, tokens);
419     }
420 
421     function updateVesters(address vester, bool isActive) external onlyOwner { 
422         vesters[vester] = isActive;
423     }
424 
425     function acceptOwnership() public override {
426         require(msg.sender == newOwner);
427         uint96 amount = _unfrozenBalances[owner];
428         _transferTokens(owner, newOwner, amount);
429         emit OwnershipTransferred(owner, newOwner);
430         owner = newOwner;
431         newOwner = address(0);
432     }
433 
434     function updateSupportUnitAdd(address newSupportUnit) external onlyOwner {
435         for (uint i; i < supportUnits.length; i++) {
436             require (supportUnits[i] != newSupportUnit, "GNBU::updateSupportUnitAdd: support unit exists");
437         }
438         supportUnits.push(newSupportUnit);
439         supportUnitsCnt++;
440     }
441 
442     function updateSupportUnitRemove(uint supportUnitIndex) external onlyOwner {
443         supportUnits[supportUnitIndex] = supportUnits[supportUnits.length - 1];
444         supportUnits.pop();
445         supportUnitsCnt--;
446     }
447     
448 
449 
450 
451     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
452         require(n < 2**32, errorMessage);
453         return uint32(n);
454     }
455 
456     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
457         require(n < 2**96, errorMessage);
458         return uint96(n);
459     }
460 
461     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
462         uint96 c = a + b;
463         require(c >= a, errorMessage);
464         return c;
465     }
466 
467     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
468         require(b <= a, errorMessage);
469         return a - b;
470     }
471 
472     function getChainId() internal view returns (uint) {
473         return block.chainid;
474     }
475 
476         
477     function mul96(uint96 a, uint96 b) internal pure returns (uint96) {
478         if (a == 0) {
479             return 0;
480         }
481         uint96 c = a * b;
482         require(c / a == b, "GNBU:mul96: multiplication overflow");
483         return c;
484     }
485 
486     function mul96(uint256 a, uint96 b) internal pure returns (uint96) {
487         uint96 _a = safe96(a, "GNBU:mul96: amount exceeds uint96");
488         if (_a == 0) {
489             return 0;
490         }
491         uint96 c = _a * b;
492         require(c / _a == b, "GNBU:mul96: multiplication overflow");
493         return c;
494     }
495 }