1 // Copyright (c) 2018-2020 double jump.tokyo inc.
2 pragma solidity 0.7.4;
3 
4 interface IERC20Permit {
5     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
6 }
7 
8 interface IERC20WithPermit {
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17     
18     function name() external view returns (string memory);
19     function symbol() external view returns (string memory);
20     function decimals() external view returns (uint8);
21     
22     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
23 }
24 
25 interface ICompGovernance {
26     function delegate(address delegatee) external;
27     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
28     function getCurrentVotes(address account) external view returns (uint96);
29     function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
30 
31     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
32     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
33 }
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36     function balanceOf(address account) external view returns (uint256);
37     function transfer(address recipient, uint256 amount) external returns (bool);
38     function allowance(address owner, address spender) external view returns (uint256);
39     function approve(address spender, uint256 amount) external returns (bool);
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface IERC20Optionals {
46     function name() external view returns (string memory);
47     function symbol() external view returns (string memory);
48     function decimals() external view returns (uint8);
49 }
50 
51 library Uint96 {
52 
53     function cast(uint256 a) public pure returns (uint96) {
54         require(a < 2**96);
55         return uint96(a);
56     }
57 
58     function add(uint96 a, uint96 b) internal pure returns (uint96) {
59         uint96 c = a + b;
60         require(c >= a, "addition overflow");
61         return c;
62     }
63 
64     function sub(uint96 a, uint96 b) internal pure returns (uint96) {
65         require(a >= b, "subtraction overflow");
66         return a - b;
67     }
68 
69     function mul(uint96 a, uint96 b) internal pure returns (uint96) {
70         if (a == 0) {
71             return 0;
72         }
73         uint96 c = a * b;
74         require(c / a == b, "multiplication overflow");
75         return c;
76     }
77 
78     function div(uint96 a, uint96 b) internal pure returns (uint96) {
79         require(b != 0, "division by 0");
80         return a / b;
81     }
82 
83     function mod(uint96 a, uint96 b) internal pure returns (uint96) {
84         require(b != 0, "modulo by 0");
85         return a % b;
86     }
87 
88     function toString(uint96 a) internal pure returns (string memory) {
89         bytes32 retBytes32;
90         uint96 len = 0;
91         if (a == 0) {
92             retBytes32 = "0";
93             len++;
94         } else {
95             uint96 value = a;
96             while (value > 0) {
97                 retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
98                 retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
99                 value /= 10;
100                 len++;
101             }
102         }
103 
104         bytes memory ret = new bytes(len);
105         uint96 i;
106 
107         for (i = 0; i < len; i++) {
108             ret[i] = retBytes32[i];
109         }
110         return string(ret);
111     }
112 }
113 
114 contract EIP712 {
115      bytes32 private constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
116      bytes32 public DOMAIN_SEPARATOR;
117      mapping (address => uint) private _nonces;
118 
119      constructor(string memory name, string memory version) {
120         uint chainId = getChainId();
121         DOMAIN_SEPARATOR = keccak256(
122             abi.encode(
123                 DOMAIN_TYPEHASH,
124                 keccak256(bytes(name)),
125                 keccak256(bytes(version)),
126                 chainId,
127                 address(this)
128             )
129         );
130     }
131     
132     function getChainId() private pure returns (uint) {
133         uint chainId;
134         assembly {
135             chainId := chainid()
136         }
137         return chainId;
138     }
139     
140 
141     function nonces(address account) public view returns (uint) {
142         return _nonces[account];
143     }
144 
145     function incrementNonce(address account) public returns (uint) {
146         return _nonces[account]++;
147     }
148 
149     function getDigest(bytes32 structHash) public view returns (bytes32) {
150             return keccak256(
151             abi.encodePacked(
152                 '\x19\x01',
153                 DOMAIN_SEPARATOR,
154                 structHash
155             )
156         );
157     }
158     
159     function recover(bytes32 digest, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
160         address recoveredAddress = ecrecover(digest, v, r, s);
161         require(recoveredAddress != address(0), "ERC712: invalid signature");
162         return recoveredAddress;
163     }
164     
165 }
166 library Roles {
167     struct Role {
168         mapping (address => bool) bearer;
169     }
170 
171     function add(Role storage role, address account) internal {
172         require(!has(role, account), "role already has the account");
173         role.bearer[account] = true;
174     }
175 
176     function remove(Role storage role, address account) internal {
177         require(has(role, account), "role dosen't have the account");
178         role.bearer[account] = false;
179     }
180 
181     function has(Role storage role, address account) internal view returns (bool) {
182         return role.bearer[account];
183     }
184 }
185 
186 contract Mintable {
187     using Roles for Roles.Role;
188 
189     event MinterAdded(address indexed account);
190     event MinterRemoved(address indexed account);
191     Roles.Role private _minters;
192 
193     constructor() {
194         _minters.add(msg.sender);
195     }
196 
197     modifier onlyMinter() {
198         require(_minters.has(msg.sender), "Must be minter");
199         _;
200     }
201 
202     function isMinter(address account) public view returns (bool) {
203         return _minters.has(account);
204     }
205 
206     function addMinter(address account) public onlyMinter() {
207         _minters.add(account);
208         emit MinterAdded(account);
209     }
210 
211     function removeMinter(address account) public onlyMinter() {
212         _minters.remove(account);
213         emit MinterRemoved(account);
214     }
215 
216 }
217 
218 abstract contract ERC20Uint96 is IERC20, IERC20Optionals {
219     using Uint96 for uint96;
220 
221     mapping (address => uint96) private _balances;
222     mapping (address => mapping (address => uint96)) private _allowances;
223     uint96 private _totalSupply;
224     uint96 private _cap = 2**96-1;
225 
226     string private _name;
227     string private _symbol;
228     uint8 private _decimals;
229 
230     constructor (string memory tokenName, string memory tokenSymbol, uint96 tokenCap) {
231         require(tokenCap > 0, "ERC20Capped: cap is 0");
232         _name = tokenName;
233         _symbol = tokenSymbol;
234         _decimals = 18;
235         _cap = tokenCap;
236     }
237 
238     function cap() public view returns (uint256) {
239         return _cap;
240     }
241 
242     function totalSupply() public view override virtual returns (uint256) {
243         return _totalSupply;
244     }
245     
246     function balanceOf(address account) public view override returns (uint256) {
247         return _balances[account];
248     }
249 
250     function transfer(address recipient, uint256 amount) external override returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254     
255     function allowance(address owner, address spender) public view override returns (uint256) {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount) external override returns (bool) {
260         _approve(msg.sender, spender, amount);
261         return true;
262     }
263 
264     function _approve(address owner, address spender, uint256 amount) internal virtual {
265         require(owner != address(0), "ERC20: approve from the zero address");
266         require(spender != address(0), "ERC20: approve to the zero address");
267 
268         uint96 _amount = Uint96.cast(amount);
269         _allowances[owner][spender] = _amount;
270         emit Approval(owner, spender, amount);
271     }
272 
273     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(Uint96.cast(amount)));
276         return true;
277     }
278 
279     function _transfer(address sender, address recipient, uint amount) internal virtual {
280         require(sender != address(0), "ERC20: transfer from the zero address");
281         require(recipient != address(0), "ERC20: transfer to the zero address");
282         
283         _beforeTokenTransfer(sender, recipient, amount);
284 
285         uint96 _amount = Uint96.cast(amount);
286         _balances[sender] = _balances[sender].sub(_amount);
287         _balances[recipient] = _balances[recipient].add(_amount);
288         emit Transfer(sender, recipient, amount);
289     }
290     
291     function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal virtual {}
292 
293     function _mint(address account, uint amount) internal virtual {
294         require(account != address(0), "ERC20: mint to the zero address");
295 
296         _beforeTokenTransfer(address(0), account, amount);
297 
298         uint96 _amount = Uint96.cast(amount);
299         _totalSupply = _totalSupply.add(_amount);
300         require(_totalSupply <= _cap, "ERC20Capped: cap exceeded");
301         _balances[account] = _balances[account].add(_amount);
302         emit Transfer(address(0), account, _amount);
303     }
304     
305     function _burn(address account, uint amount) internal virtual {
306         require(account != address(0), "ERC20: burn from the zero address");
307         
308         _beforeTokenTransfer(account, address(0), amount);
309 
310         uint96 _amount = Uint96.cast(amount);
311         _totalSupply = _totalSupply.sub(_amount);
312         _balances[account] = _balances[account].sub(_amount);
313         emit Transfer(account, address(0), _amount);
314     }
315 
316     function name() public view override returns (string memory) {
317         return _name;
318     }
319 
320     function symbol() external view override returns (string memory) {
321         return _symbol;
322     }
323 
324     function decimals() external view override returns (uint8) {
325         return _decimals;
326     }
327 
328 }
329 
330 abstract contract ERC20Uint96Governance is EIP712, ERC20Uint96, ICompGovernance {
331     using Uint96 for uint96;
332     
333     struct Checkpoint {
334         uint32 fromBlock;
335         uint96 votes;
336     }
337     /// @notice The EIP-712 typehash for the delegation struct used by the contract
338     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
339 
340     mapping (address => address) public delegates;
341     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
342     mapping (address => uint32) public numCheckpoints;
343 
344     constructor() {
345     }
346     
347     function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal override {
348         _moveDelegates(delegates[sender], delegates[recipient], Uint96.cast(amount));
349         super._beforeTokenTransfer(sender, recipient, amount);
350     }
351 
352     function delegate(address delegatee) public override {
353         return _delegate(msg.sender, delegatee);
354     }
355 
356     function delegateBySig(address delegatee, uint nonce, uint deadline, uint8 v, bytes32 r, bytes32 s) public override {
357         require(block.timestamp <= deadline, "ERC20Governance: signature expired");
358         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, deadline));
359         bytes32 digest = getDigest(structHash);
360         address signatory = recover(digest, v, r, s);
361         require(nonce == incrementNonce(delegatee), "ERC20Governance: invalid nonce");
362         return _delegate(signatory, delegatee);
363     }
364 
365     function getCurrentVotes(address account) external view override returns (uint96)  {
366         uint32 nCheckpoints = numCheckpoints[account];
367         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
368     }
369 
370     function getPriorVotes(address account, uint blockNumber) public view override returns (uint96) {
371         require(blockNumber < block.number, "Comp::getPriorVotes: not yet determined");
372 
373         uint32 nCheckpoints = numCheckpoints[account];
374         if (nCheckpoints == 0) {
375             return 0;
376         }
377 
378         // First check most recent balance
379         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
380             return checkpoints[account][nCheckpoints - 1].votes;
381         }
382 
383         // Next check implicit zero balance
384         if (checkpoints[account][0].fromBlock > blockNumber) {
385             return 0;
386         }
387 
388         uint32 lower = 0;
389         uint32 upper = nCheckpoints - 1;
390         while (upper > lower) {
391             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
392             Checkpoint memory cp = checkpoints[account][center];
393             if (cp.fromBlock == blockNumber) {
394                 return cp.votes;
395             } else if (cp.fromBlock < blockNumber) {
396                 lower = center;
397             } else {
398                 upper = center - 1;
399             }
400         }
401         return checkpoints[account][lower].votes;
402     }
403 
404     function _delegate(address delegator, address delegatee) private {
405         address currentDelegate = delegates[delegator];
406         uint96 delegatorBalance = _balanceOf(delegator);
407         delegates[delegator] = delegatee;
408 
409         emit DelegateChanged(delegator, currentDelegate, delegatee);
410 
411         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
412     }
413 
414     function _moveDelegates(address srcRep, address dstRep, uint96 amount) private {
415         if (srcRep != dstRep && amount > 0) {
416             if (srcRep != address(0)) {
417                 uint32 srcRepNum = numCheckpoints[srcRep];
418                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
419                 uint96 srcRepNew = srcRepOld.sub(amount);
420                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
421             }
422 
423             if (dstRep != address(0)) {
424                 uint32 dstRepNum = numCheckpoints[dstRep];
425                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
426                 uint96 dstRepNew = dstRepOld.add(amount);
427                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
428             }
429         }
430     }
431 
432     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) private {
433         require(block.number < 2**32, "ERC20Governance: block number exceeds 32 bits");
434         uint32 blockNumber = uint32(block.number);
435 
436         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
437             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
438         } else {
439             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
440             numCheckpoints[delegatee] = nCheckpoints + 1;
441         }
442 
443         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
444     }
445     
446     function _balanceOf(address account) private view returns (uint96) {
447         return Uint96.cast(super.balanceOf(account));
448     }
449 }
450 
451 contract MCHCoin is ERC20Uint96Governance, IERC20Permit, Mintable {
452     using Uint96 for uint96;
453     
454     // 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
455     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
456 
457     constructor()
458         ERC20Uint96("MCHCoin","MCHC", 50000000 * 10**18)
459         EIP712("MCHCoin","1") {
460     }
461 
462     uint256 public offchainIssued;
463 
464     function setOffchainIssued(uint256 _new) external onlyMinter {
465         offchainIssued = _new;
466     }
467 
468     function onchainIssued() external view returns (uint256) {
469         return super.totalSupply();
470     }
471 
472     function totalSupply() public override view returns (uint256) {
473         if (offchainIssued != 0) {
474             return offchainIssued;
475         }
476         return super.totalSupply();
477     }
478 
479     function mintTo(address account, uint amount) external onlyMinter returns (bool)  {
480         _mint(account, amount);
481         return true;
482     }
483 
484     function burn(uint amount) external returns (bool) {
485         _burn(msg.sender, amount);
486         return true;
487     }
488 
489     function burnFrom(address account, uint amount) external returns (bool) {
490         uint96 allowance = Uint96.cast(allowance(account, msg.sender));
491         uint256 decreasedAllowance = allowance.sub(Uint96.cast(amount));
492         _approve(account, msg.sender, decreasedAllowance);
493         _burn(account, amount);
494         return true;
495     }
496 
497     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
498         require(deadline >= block.timestamp, 'ERC20Permit: EXPIRED');
499         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, incrementNonce(owner), deadline));
500         bytes32 digest = getDigest(structHash);
501         address recoveredAddress = recover(digest, v, r, s);
502         require(recoveredAddress == owner, 'ERC20Permit: INVALID_SIGNATURE');
503         _approve(owner, spender, value);
504     }
505 }