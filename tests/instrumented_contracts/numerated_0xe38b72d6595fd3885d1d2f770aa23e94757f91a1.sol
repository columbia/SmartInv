1 // SPDX-License-Identifier: Unlicense
2 pragma solidity 0.8.2;
3 
4 // interface need to claim rouge tokens from contract and handle upgraded functions
5 abstract contract IERC20 {
6     function balanceOf(address owner) public view virtual returns (uint256);
7 
8     function transfer(address to, uint256 amount) public virtual;
9 
10     function allowance(address owner, address spender)
11         public
12         view
13         virtual
14         returns (uint256);
15 
16     function totalSupply() public view virtual returns (uint256);
17 }
18 
19 // interface to potential future upgraded contract,
20 // only essential write functions that need check that this contract is caller
21 abstract contract IUpgradedToken {
22     function transferByLegacy(
23         address sender,
24         address to,
25         uint256 amount
26     ) public virtual returns (bool);
27 
28     function transferFromByLegacy(
29         address sender,
30         address from,
31         address to,
32         uint256 amount
33     ) public virtual returns (bool);
34 
35     function approveByLegacy(
36         address sender,
37         address spender,
38         uint256 amount
39     ) public virtual;
40 }
41 
42 //
43 // The ultimate ERC20 token contract for TecraCoin project
44 //
45 contract TcrToken {
46     //
47     // ERC20 basic information
48     //
49     uint8 public constant decimals = 8;
50     string public constant name = "TecraCoin";
51     string public constant symbol = "TCR";
52     uint256 private _totalSupply;
53     uint256 public constant maxSupply = 21000000000000000;
54 
55     string public constant version = "1";
56     uint256 public immutable getChainId;
57 
58     //
59     // other flags, data and constants
60     //
61     address public owner;
62     address public newOwner;
63 
64     bool public paused;
65 
66     bool public deprecated;
67     address public upgradedAddress;
68 
69     bytes32 public immutable DOMAIN_SEPARATOR;
70 
71     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
72     bytes32 public constant PERMIT_TYPEHASH =
73         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
74 
75     string private constant ERROR_DAS = "Different array sizes";
76     string private constant ERROR_BTL = "Balance too low";
77     string private constant ERROR_ATL = "Allowance too low";
78     string private constant ERROR_OO = "Only Owner";
79 
80     //
81     // events
82     //
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     event Paused();
86     event Unpaused();
87 
88     event Approval(
89         address indexed owner,
90         address indexed spender,
91         uint256 value
92     );
93 
94     event AddedToBlacklist(address indexed account);
95     event RemovedFromBlacklist(address indexed account);
96 
97     //
98     // data stores
99     //
100     mapping(address => mapping(address => uint256)) private _allowances;
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => bool) public isBlacklisted;
104 
105     mapping(address => bool) public isBlacklistAdmin;
106     mapping(address => bool) public isMinter;
107     mapping(address => bool) public isPauser;
108 
109     mapping(address => uint256) public nonces;
110 
111     //
112     // contract constructor
113     //
114     constructor() {
115         owner = msg.sender;
116         getChainId = block.chainid;
117         // EIP712 Domain
118         DOMAIN_SEPARATOR = keccak256(
119             abi.encode(
120                 keccak256(
121                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
122                 ),
123                 keccak256(bytes(name)),
124                 keccak256(bytes(version)),
125                 block.chainid,
126                 address(this)
127             )
128         );
129     }
130 
131     //
132     // "approve"
133     //
134     function approve(address spender, uint256 amount) external {
135         if (deprecated) {
136             return
137                 IUpgradedToken(upgradedAddress).approveByLegacy(
138                     msg.sender,
139                     spender,
140                     amount
141                 );
142         }
143         _approve(msg.sender, spender, amount);
144     }
145 
146     //
147     // "burnable"
148     //
149     function burn(uint256 amount) external {
150         require(_balances[msg.sender] >= amount, ERROR_BTL);
151         _burn(msg.sender, amount);
152     }
153 
154     function burnFrom(address from, uint256 amount) external {
155         require(_allowances[msg.sender][from] >= amount, ERROR_ATL);
156         require(_balances[from] >= amount, ERROR_BTL);
157         _approve(msg.sender, from, _allowances[msg.sender][from] - amount);
158         _burn(from, amount);
159     }
160 
161     //
162     // "transfer"
163     //
164     function transfer(address to, uint256 amount) external returns (bool) {
165         if (deprecated) {
166             return
167                 IUpgradedToken(upgradedAddress).transferByLegacy(
168                     msg.sender,
169                     to,
170                     amount
171                 );
172         }
173         require(_balances[msg.sender] >= amount, ERROR_BTL);
174         _transfer(msg.sender, to, amount);
175         return true;
176     }
177 
178     function transferFrom(
179         address from,
180         address to,
181         uint256 amount
182     ) external returns (bool) {
183         if (deprecated) {
184             return
185                 IUpgradedToken(upgradedAddress).transferFromByLegacy(
186                     msg.sender,
187                     from,
188                     to,
189                     amount
190                 );
191         }
192         _allowanceTransfer(msg.sender, from, to, amount);
193         return true;
194     }
195 
196     //
197     // non-ERC20 functionality
198     //
199     // Rouge tokens and ETH withdrawal
200     function acquire(address token) external onlyOwner {
201         if (token == address(0)) {
202             payable(owner).transfer(address(this).balance);
203         } else {
204             uint256 amount = IERC20(token).balanceOf(address(this));
205             require(amount > 0, ERROR_BTL);
206             IERC20(token).transfer(owner, amount);
207         }
208     }
209 
210     //
211     // "blacklist"
212     //
213     function addBlacklister(address user) external onlyOwner {
214         isBlacklistAdmin[user] = true;
215     }
216 
217     function removeBlacklister(address user) external onlyOwner {
218         isBlacklistAdmin[user] = false;
219     }
220 
221     modifier onlyBlacklister {
222         require(isBlacklistAdmin[msg.sender], "Not a Blacklister");
223         _;
224     }
225 
226     modifier notOnBlacklist(address user) {
227         require(!isBlacklisted[user], "Address on blacklist");
228         _;
229     }
230 
231     function addBlacklist(address user) external onlyBlacklister {
232         isBlacklisted[user] = true;
233         emit AddedToBlacklist(user);
234     }
235 
236     function removeBlacklist(address user) external onlyBlacklister {
237         isBlacklisted[user] = false;
238         emit RemovedFromBlacklist(user);
239     }
240 
241     function burnBlackFunds(address user) external onlyOwner {
242         require(isBlacklisted[user], "Address not on blacklist");
243         _burn(user, _balances[user]);
244     }
245 
246     //
247     // "bulk transfer"
248     //
249     // transfer to list of address-amount
250     function bulkTransfer(address[] calldata to, uint256[] calldata amount)
251         external
252         returns (bool)
253     {
254         require(to.length == amount.length, ERROR_DAS);
255         for (uint256 i = 0; i < to.length; i++) {
256             require(_balances[msg.sender] >= amount[i], ERROR_BTL);
257             _transfer(msg.sender, to[i], amount[i]);
258         }
259         return true;
260     }
261 
262     // transferFrom to list of address-amount
263     function bulkTransferFrom(
264         address from,
265         address[] calldata to,
266         uint256[] calldata amount
267     ) external returns (bool) {
268         require(to.length == amount.length, ERROR_DAS);
269         for (uint256 i = 0; i < to.length; i++) {
270             _allowanceTransfer(msg.sender, from, to[i], amount[i]);
271         }
272         return true;
273     }
274 
275     // send same amount to multiple addresses
276     function bulkTransfer(address[] calldata to, uint256 amount)
277         external
278         returns (bool)
279     {
280         require(_balances[msg.sender] >= amount * to.length, ERROR_BTL);
281         for (uint256 i = 0; i < to.length; i++) {
282             _transfer(msg.sender, to[i], amount);
283         }
284         return true;
285     }
286 
287     // send same amount to multiple addresses by allowance
288     function bulkTransferFrom(
289         address from,
290         address[] calldata to,
291         uint256 amount
292     ) external returns (bool) {
293         require(_balances[from] >= amount * to.length, ERROR_BTL);
294         for (uint256 i = 0; i < to.length; i++) {
295             _allowanceTransfer(msg.sender, from, to[i], amount);
296         }
297         return true;
298     }
299 
300     //
301     // "mint"
302     //
303     modifier onlyMinter {
304         require(isMinter[msg.sender], "Not a Minter");
305         _;
306     }
307 
308     function addMinter(address user) external onlyOwner {
309         isMinter[user] = true;
310     }
311 
312     function removeMinter(address user) external onlyOwner {
313         isMinter[user] = false;
314     }
315 
316     function mint(address to, uint256 amount) external onlyMinter {
317         _balances[to] += amount;
318         _totalSupply += amount;
319         require(_totalSupply < maxSupply, "You can not mine that much");
320         emit Transfer(address(0), to, amount);
321     }
322 
323     //
324     // "ownable"
325     //
326     modifier onlyOwner {
327         require(msg.sender == owner, ERROR_OO);
328         _;
329     }
330 
331     function giveOwnership(address _newOwner) external onlyOwner {
332         newOwner = _newOwner;
333     }
334 
335     function acceptOwnership() external {
336         require(msg.sender == newOwner, ERROR_OO);
337         newOwner = address(0);
338         owner = msg.sender;
339     }
340 
341     //
342     // "pausable"
343     //
344     function addPauser(address user) external onlyOwner {
345         isPauser[user] = true;
346     }
347 
348     function removePauser(address user) external onlyOwner {
349         isPauser[user] = false;
350     }
351 
352     modifier onlyPauser {
353         require(isPauser[msg.sender], "Not a Pauser");
354         _;
355     }
356 
357     modifier notPaused {
358         require(!paused, "Contract is paused");
359         _;
360     }
361 
362     function pause() external onlyPauser notPaused {
363         paused = true;
364         emit Paused();
365     }
366 
367     function unpause() external onlyPauser {
368         require(paused, "Contract not paused");
369         paused = false;
370         emit Unpaused();
371     }
372 
373     //
374     // "permit"
375     // Uniswap integration EIP-2612
376     //
377     function permit(
378         address user,
379         address spender,
380         uint256 value,
381         uint256 deadline,
382         uint8 v,
383         bytes32 r,
384         bytes32 s
385     ) external {
386         require(deadline >= block.timestamp, "permit: EXPIRED");
387         bytes32 digest =
388             keccak256(
389                 abi.encodePacked(
390                     "\x19\x01",
391                     DOMAIN_SEPARATOR,
392                     keccak256(
393                         abi.encode(
394                             PERMIT_TYPEHASH,
395                             user,
396                             spender,
397                             value,
398                             nonces[user]++,
399                             deadline
400                         )
401                     )
402                 )
403             );
404         address recoveredAddress = ecrecover(digest, v, r, s);
405         require(
406             recoveredAddress != address(0) && recoveredAddress == user,
407             "permit: INVALID_SIGNATURE"
408         );
409         _approve(user, spender, value);
410     }
411 
412     //
413     // upgrade contract
414     //
415     function upgrade(address token) external onlyOwner {
416         deprecated = true;
417         upgradedAddress = token;
418     }
419 
420     //
421     // ERC20 view functions
422     //
423     function balanceOf(address account) external view returns (uint256) {
424         if (deprecated) {
425             return IERC20(upgradedAddress).balanceOf(account);
426         }
427         return _balances[account];
428     }
429 
430     function allowance(address account, address spender)
431         external
432         view
433         returns (uint256)
434     {
435         if (deprecated) {
436             return IERC20(upgradedAddress).allowance(account, spender);
437         }
438         return _allowances[account][spender];
439     }
440 
441     function totalSupply() external view returns (uint256) {
442         if (deprecated) {
443             return IERC20(upgradedAddress).totalSupply();
444         }
445         return _totalSupply;
446     }
447 
448     //
449     // internal functions
450     //
451     function _approve(
452         address account,
453         address spender,
454         uint256 amount
455     ) private notOnBlacklist(account) notOnBlacklist(spender) notPaused {
456         _allowances[account][spender] = amount;
457         emit Approval(account, spender, amount);
458     }
459 
460     function _allowanceTransfer(
461         address spender,
462         address from,
463         address to,
464         uint256 amount
465     ) private {
466         require(_allowances[from][spender] >= amount, ERROR_ATL);
467         require(_balances[from] >= amount, ERROR_BTL);
468 
469         // exception for Uniswap "approve forever"
470         if (_allowances[from][spender] != type(uint256).max) {
471             _approve(from, spender, _allowances[from][spender] - amount);
472         }
473 
474         _transfer(from, to, amount);
475     }
476 
477     function _burn(address from, uint256 amount) private notPaused {
478         _balances[from] -= amount;
479         _totalSupply -= amount;
480         emit Transfer(from, address(0), amount);
481     }
482 
483     function _transfer(
484         address from,
485         address to,
486         uint256 amount
487     ) private notOnBlacklist(from) notOnBlacklist(to) notPaused {
488         require(to != address(0), "Use burn instead");
489         require(from != address(0), "What a Terrible Failure");
490         _balances[from] -= amount;
491         _balances[to] += amount;
492         emit Transfer(from, to, amount);
493     }
494 }
495 
496 // rav3n_pl was here