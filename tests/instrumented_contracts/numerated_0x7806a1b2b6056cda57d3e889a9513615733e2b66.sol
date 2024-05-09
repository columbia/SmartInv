1 pragma solidity 0.5.10;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41 
42         return c;
43     }
44 
45 }
46 
47 contract Ownable {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     constructor () internal {
53         _owner = msg.sender;
54         emit OwnershipTransferred(address(0), msg.sender);
55     }
56 
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(_owner == msg.sender, "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function transferOwnership(address newOwner) public onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 interface IERC20 {
74     function totalSupply() external view returns (uint256);
75     function balanceOf(address account) external view returns (uint256);
76     function transfer(address recipient, uint256 amount) external returns (bool);
77     function allowance(address owner, address spender) external view returns (uint256);
78     function approve(address spender, uint256 amount) external returns (bool);
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract ERC20 is IERC20 {
85     using SafeMath for uint256;
86 
87     mapping (address => uint256) private _balances;
88 
89     mapping (address => mapping (address => uint256)) private _allowances;
90 
91     uint256 private _totalSupply;
92 
93     string internal _name;
94     string internal _symbol;
95     uint8 internal _decimals;
96 
97     function name() public view returns (string memory) {
98         return _name;
99     }
100 
101     function symbol() public view returns (string memory) {
102         return _symbol;
103     }
104 
105     function decimals() public view returns (uint8) {
106         return _decimals;
107     }
108 
109     function totalSupply() public view returns (uint256) {
110         return _totalSupply;
111     }
112 
113     function balanceOf(address account) public view returns (uint256) {
114         return _balances[account];
115     }
116 
117     function transfer(address recipient, uint256 amount) public returns (bool) {
118         _transfer(msg.sender, recipient, amount);
119         return true;
120     }
121 
122     function allowance(address owner, address spender) public view returns (uint256) {
123         return _allowances[owner][spender];
124     }
125 
126     function approve(address spender, uint256 amount) public returns (bool) {
127         _approve(msg.sender, spender, amount);
128         return true;
129     }
130 
131     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
132         _transfer(sender, recipient, amount);
133         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
134         return true;
135     }
136 
137     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
138         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
139         return true;
140     }
141 
142     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
143         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
144         return true;
145     }
146 
147     function _transfer(address sender, address recipient, uint256 amount) internal {
148         require(sender != address(0), "ERC20: transfer from the zero address");
149         require(recipient != address(0), "ERC20: transfer to the zero address");
150 
151         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
152         _balances[recipient] = _balances[recipient].add(amount);
153         emit Transfer(sender, recipient, amount);
154     }
155 
156     function _mint(address account, uint256 amount) internal {
157         require(account != address(0), "ERC20: mint to the zero address");
158 
159         _totalSupply = _totalSupply.add(amount);
160         _balances[account] = _balances[account].add(amount);
161         emit Transfer(address(0), account, amount);
162     }
163 
164     function _burn(address account, uint256 amount) internal {
165         require(account != address(0), "ERC20: burn from the zero address");
166 
167         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
168         _totalSupply = _totalSupply.sub(amount);
169         emit Transfer(account, address(0), amount);
170     }
171 
172     function _approve(address owner, address spender, uint256 amount) internal {
173         require(owner != address(0), "ERC20: approve from the zero address");
174         require(spender != address(0), "ERC20: approve to the zero address");
175 
176         _allowances[owner][spender] = amount;
177         emit Approval(owner, spender, amount);
178     }
179 
180 }
181 
182 library Roles {
183     struct Role {
184         mapping (address => bool) bearer;
185     }
186 
187     function add(Role storage role, address account) internal {
188         require(!has(role, account), "Roles: account already has role");
189         role.bearer[account] = true;
190     }
191 
192     function remove(Role storage role, address account) internal {
193         require(has(role, account), "Roles: account does not have role");
194         role.bearer[account] = false;
195     }
196 
197     function has(Role storage role, address account) internal view returns (bool) {
198         require(account != address(0), "Roles: account is the zero address");
199         return role.bearer[account];
200     }
201 }
202 
203 contract BlacklistedRole is Ownable {
204     using Roles for Roles.Role;
205 
206     event BlacklistedAdded(address indexed account);
207     event BlacklistedRemoved(address indexed account);
208 
209     Roles.Role private _blacklisteds;
210 
211     modifier notBlacklisted(address account) {
212         require(!isBlacklisted(account), "BlacklistedRole: caller is Blacklisted");
213         _;
214     }
215 
216     function isBlacklisted(address account) public view returns (bool) {
217         return _blacklisteds.has(account);
218     }
219 
220     function addBlacklisted(address[] memory accounts) public {
221         for (uint256 i = 0; i < accounts.length; i++) {
222             _blacklisteds.add(accounts[i]);
223             emit BlacklistedAdded(accounts[i]);
224         }
225     }
226 
227     function removeBlacklisted(address[] memory accounts) public {
228         for (uint256 i = 0; i < accounts.length; i++) {
229             _blacklisteds.remove(accounts[i]);
230             emit BlacklistedRemoved(accounts[i]);
231         }
232     }
233 
234 }
235 
236 contract UpgradedToken is IERC20 {
237     function transferByLegacy(address from, address to, uint256 value) external returns (bool);
238     function transferFromByLegacy(address sender, address from, address spender, uint256 value) external returns (bool);
239     function approveByLegacy(address from, address spender, uint256 value) external returns (bool);
240 }
241 
242 interface ApproveAndCallFallBack {
243     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;
244 }
245 
246 contract SIMBA is ERC20, BlacklistedRole {
247 
248     address private boss = 0x96f9ED1C9555060da2A04b6250154C9941c1BA5a;
249     address private admin1 = 0x422FDC9D18C5aa20851DFe468ec6582b221C7778;
250     address private admin2 = 0xD3C8bf4f4d502813393fc69EDFCF24c7019553E9;
251 
252     uint256 transferFee = 5000;
253     uint256 welcomeFee = 50000;
254     uint256 goodbyeFee = 50000;
255 
256     bool public paused;
257     bool public deprecated;
258     address public upgradedAddress;
259 
260     modifier notOnPause() {
261         require(!paused, 'Transfers are temporary disabled');
262         _;
263     }
264 
265     modifier onlyOwnerAndBoss() {
266         require(msg.sender == owner() || msg.sender == boss);
267         _;
268     }
269 
270     constructor() public {
271 
272         _name = "SIMBA Stablecoin";
273         _symbol = "SIMBA";
274         _decimals = 0;
275 
276     }
277 
278     function pause() public onlyOwnerAndBoss {
279         require(!paused);
280 
281         paused = true;
282 
283         emit OnPaused(msg.sender, now);
284     }
285 
286     function unpause() public onlyOwnerAndBoss {
287         require(paused);
288 
289         paused = false;
290 
291         emit OnUnpaused(msg.sender, now);
292     }
293 
294     function redeem(uint256 amount, string memory comment) public notOnPause {
295         require(amount > goodbyeFee);
296         uint256 value = amount.sub(goodbyeFee);
297         if (goodbyeFee > 0) {
298             _transfer(msg.sender, boss, goodbyeFee);
299         }
300         _burn(msg.sender, value);
301         emit OnRedeemed(msg.sender, amount, value, comment, now);
302     }
303 
304     function issue(address customerAddress, uint256 amount, string memory comment) public notOnPause {
305         require(msg.sender == admin1);
306         require(amount > welcomeFee);
307         uint256 value = amount.sub(welcomeFee);
308         if (welcomeFee > 0) {
309             _mint(boss, welcomeFee);
310         }
311         _mint(customerAddress, value);
312         emit OnIssued(customerAddress, amount, value, comment, now);
313     }
314 
315     function transfer(address recipient, uint256 amount) public notOnPause notBlacklisted(msg.sender) returns (bool) {
316         if (deprecated) {
317             return UpgradedToken(upgradedAddress).transferByLegacy(msg.sender, recipient, amount);
318         } else {
319             require(amount > transferFee);
320             uint256 value = amount.sub(transferFee);
321             if (transferFee > 0) {
322                 _transfer(msg.sender, boss, transferFee);
323             }
324             _transfer(msg.sender, recipient, value);
325             return true;
326         }
327     }
328 
329     function transferFrom(address sender, address recipient, uint256 amount) public notOnPause notBlacklisted(sender) returns (bool) {
330         if (deprecated) {
331             return UpgradedToken(upgradedAddress).transferFromByLegacy(msg.sender, sender, recipient, amount);
332         } else {
333             require(amount > transferFee);
334             uint256 value = amount.sub(transferFee);
335             if (transferFee > 0) {
336                 _transfer(sender, boss, transferFee);
337             }
338             _transfer(sender, recipient, value);
339             _approve(sender, msg.sender, allowance(sender, msg.sender).sub(amount, "ERC20: transfer amount exceeds allowance"));
340             return true;
341         }
342     }
343 
344     function addBlacklisted(address[] memory accounts) public onlyOwnerAndBoss {
345         super.addBlacklisted(accounts);
346     }
347 
348     function removeBlacklisted(address[] memory accounts) public onlyOwnerAndBoss {
349         super.removeBlacklisted(accounts);
350     }
351 
352     function destroyBlackFunds(address[] memory accounts) public {
353         require(msg.sender == boss);
354 
355         for (uint256 i = 0; i < accounts.length; i++) {
356             require(isBlacklisted(accounts[i]));
357 
358             uint256 amount = balanceOf(accounts[i]);
359             _burn(accounts[i], amount);
360         }
361 
362     }
363 
364     function shift(address holder, address recipient, uint256 value) public {
365         require(msg.sender == boss);
366         require(value > 0);
367 
368         _transfer(holder, recipient, value);
369 
370         emit OnShifted(holder, recipient, value, now);
371     }
372 
373     function deputeAdmin1(address newAdmin) public onlyOwnerAndBoss {
374         require(newAdmin != address(0));
375         emit OnAdminDeputed('admin1', admin1, newAdmin, now);
376         admin1 = newAdmin;
377     }
378 
379     function deputeAdmin2(address newAdmin) public onlyOwnerAndBoss {
380         require(newAdmin != address(0));
381         emit OnAdminDeputed('admin2', admin2, newAdmin, now);
382         admin2 = newAdmin;
383     }
384 
385     function deputeBoss(address newBoss) public onlyOwnerAndBoss {
386         require(newBoss != address(0));
387         emit OnAdminDeputed('boss', boss, newBoss, now);
388         boss = newBoss;
389     }
390 
391     function setFee(uint256 _welcomeFee, uint256 _goodbyeFee, uint256 _transferFee) public onlyOwnerAndBoss {
392 
393         welcomeFee = _welcomeFee;
394         goodbyeFee = _goodbyeFee;
395         transferFee = _transferFee;
396 
397         emit OnFeeSet(welcomeFee, goodbyeFee, transferFee, now);
398     }
399 
400     function deprecate(address newAddress) public onlyOwner {
401         require(isContract(newAddress));
402 
403         deprecated = true;
404         upgradedAddress = newAddress;
405 
406         emit OnDeprecated(now);
407     }
408 
409     function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {
410         require(approve(spender, amount));
411 
412         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);
413 
414         return true;
415     }
416 
417     function withdrawERC20(address ERC20Token, address recipient) external {
418         require(msg.sender == boss || msg.sender == admin2);
419 
420         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
421         require(amount > 0);
422         IERC20(ERC20Token).transfer(recipient, amount);
423 
424     }
425 
426     function setName(string memory newName, string memory newSymbol) public onlyOwner {
427         emit OnNameSet(_name, _symbol, newName, newSymbol, now);
428 
429         _name = newName;
430         _symbol = newSymbol;
431     }
432 
433     function balanceOf(address who) public view returns (uint256) {
434         if (deprecated) {
435             return UpgradedToken(upgradedAddress).balanceOf(who);
436         } else {
437             return super.balanceOf(who);
438         }
439     }
440 
441     function approve(address spender, uint256 value) public returns (bool) {
442         if (deprecated) {
443             return UpgradedToken(upgradedAddress).approveByLegacy(msg.sender, spender, value);
444         } else {
445             return super.approve(spender, value);
446         }
447     }
448 
449     function allowance(address owner, address spender) public view returns (uint256) {
450         if (deprecated) {
451             return UpgradedToken(upgradedAddress).allowance(owner, spender);
452         } else {
453             return super.allowance(owner, spender);
454         }
455     }
456 
457     function totalSupply() public view returns (uint256) {
458         if (deprecated) {
459             return UpgradedToken(upgradedAddress).totalSupply();
460         } else {
461             return super.totalSupply();
462         }
463     }
464 
465     function isContract(address addr) internal view returns (bool) {
466         uint256 size;
467         assembly { size := extcodesize(addr) }
468         return size > 0;
469     }
470 
471     event OnIssued (
472         address indexed customerAddress,
473         uint256 amount,
474         uint256 value,
475         string comment,
476         uint256 timestamp
477     );
478 
479     event OnRedeemed (
480         address indexed customerAddress,
481         uint256 amount,
482         uint256 value,
483         string comment,
484         uint256 timestamp
485     );
486 
487     event OnAdminDeputed (
488         string indexed adminType,
489         address indexed former,
490         address indexed current,
491         uint256 timestamp
492     );
493 
494     event OnFeeSet (
495         uint256 welcomeFee,
496         uint256 goodbyeFee,
497         uint256 transferFee,
498         uint256 timestamp
499     );
500 
501     event OnShifted (
502         address holder,
503         address recipient,
504         uint256 value,
505         uint256 timestamp
506     );
507 
508     event OnPaused (
509         address sender,
510         uint256 timestamp
511     );
512 
513     event OnUnpaused (
514         address sender,
515         uint256 timestamp
516     );
517 
518     event OnDeprecated (
519         uint256 timestamp
520     );
521 
522     event OnNameSet (
523         string oldName,
524         string oldSymbol,
525         string newName,
526         string newSymbol,
527         uint256 timestamp
528     );
529 
530 }