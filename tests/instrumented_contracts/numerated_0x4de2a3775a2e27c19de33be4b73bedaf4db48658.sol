1 pragma solidity ^0.4.24;
2 
3 /**
4  * @dev SafeMath
5  * Math operations with safety checks that throw on error
6  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (b > a) return 0;
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 interface IERC165 {
40     function supportsInterface(bytes4 interfaceId) external view returns (bool);
41 }
42 
43 contract IERC20 is IERC165 {
44     function totalSupply() public view returns (uint256);
45     function balanceOf(address account) public view returns (uint256);
46     function decimals() public view returns (uint8);
47     function transfer(address recipient, uint256 amount) public returns (bool);
48     function allowance(address owner, address spender) public view returns (uint256);
49     function approve(address spender, uint256 amount) public returns (bool);
50     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool);
51     function safeTransfer(address recipient, uint256 amount, bytes memory data) public;
52     function safeTransfer(address recipient, uint256 amount) public;
53     function safeTransferFrom(address sender, address recipient, uint256 amount, bytes memory data) public;
54     function safeTransferFrom(address sender, address recipient, uint256 amount) public;
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 contract ERC165 is IERC165 {
61     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
62     mapping(bytes4 => bool) private _supportedInterfaces;
63 
64     constructor () internal {
65         _registerInterface(_INTERFACE_ID_ERC165);
66     }
67 
68     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
69         return _supportedInterfaces[interfaceId];
70     }
71 
72     function _registerInterface(bytes4 interfaceId) internal {
73         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
74         _supportedInterfaces[interfaceId] = true;
75     }
76 }
77 
78 contract IERC20Receiver {
79     function onERC20Received(address _operator, address _from, uint256 _amount, bytes memory _data) public returns (bytes4);
80 }
81 // ----------------------------------------------------------------------------
82 // @title Ownable
83 // ----------------------------------------------------------------------------
84 contract Ownable {
85     address public owner;
86 
87     event SetOwner(address owner);
88     event SetMinter(address minter);
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor() public {
92         owner    = msg.sender;
93 
94         emit SetOwner(msg.sender);
95         emit SetMinter(msg.sender);
96     }
97 
98     modifier onlyOwner() { require(msg.sender == owner); _; }
99 
100     function transferOwnership(address _newOwner) external onlyOwner {
101         require(_newOwner != address(0));
102         emit OwnershipTransferred(owner, _newOwner);
103         owner = _newOwner;
104     }
105 }
106 // ----------------------------------------------------------------------------
107 // @title ERC20
108 // ----------------------------------------------------------------------------
109 contract ERC20 is ERC165, IERC20, Ownable {
110     using SafeMath for uint256;
111     
112     event LockedInfo(address indexed from, address indexed to, uint256 value, uint8 tokenType, uint256 distributedTime, uint256 lockUpPeriodMonth, uint256 unlockAmountPerCount, uint256 remainUnLockCount, uint256 CONST_UNLOCKCOUNT);
113     event ChangeListingTime(uint256 oldTime, uint256 newTime);
114     event FinshedSetExchangeListingTime();
115 
116     struct LockInfo {
117         bool isLocked;
118         uint8 tokenType;
119         uint256 amount;
120         uint256 distributedTime;
121         uint256 lockUpPeriodMonth;
122         uint256 lastUnlockTimestamp;
123         uint256 unlockAmountPerCount;
124         uint256 remainUnLockCount;
125         uint256 CONST_UNLOCKCOUNT;
126         uint256 CONST_AMOUNT;
127     }
128     
129     uint256 internal _totalSupply;
130     uint8 private _decimals = 18;
131 
132     uint256 internal _tokenCreatedTime;
133     
134     mapping(address => uint256) internal _balances;
135     mapping(address => mapping (address => uint256)) internal _allowances;
136 
137     mapping(address => uint8) internal _cardioWallet;
138     mapping(address => mapping (uint8 => LockInfo)) internal _lockedInfo;
139 
140     bytes4 private constant _ERC20_RECEIVED = 0x9d188c22;
141     bytes4 private constant _INTERFACE_ID_ERC20 = 0x65787371;
142 
143     constructor() public {
144         _tokenCreatedTime = now;
145         // Crowd Sale Wallet
146         _cardioWallet[0x9FC9675d6d1d2E583EbC6fdF7b30F1d1144523Cd] = 1;
147         // Team & Advisors
148         _cardioWallet[0xe39c6A20A55e6f88aF1B331F0E8529dcD4A02c10] = 2;
149         // Ecosystem Activation
150         _cardioWallet[0x588eaB2Fd73e381efFA8E4F084bF5a686eC9eD68] = 3;
151         // Business Development
152         _cardioWallet[0x461030be06272623f7135ba9926Ea9Afba00d8E3] = 4;
153     }
154 
155     function totalSupply() public view returns (uint256) {
156         return _totalSupply;
157     }
158 
159     function balanceOf(address account) public view returns (uint256) {
160         uint256 totalBalances = _balances[account];
161         uint8 tokenType;
162 
163         for (tokenType = 1; tokenType <= 4; tokenType++) {
164             LockInfo memory lockInfo = _lockedInfo[account][tokenType];
165             totalBalances = totalBalances.add(lockInfo.amount);
166         }
167         
168         return totalBalances;
169     }
170 
171     function unLockBalanceOf(address account) public view returns (uint256) {
172         return _balances[account];
173     }
174 
175     function lockUpInfo(address account, uint8 tokenType) public view returns (bool, uint8, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
176         LockInfo memory lockInfo = _lockedInfo[account][tokenType];
177         return (lockInfo.isLocked, lockInfo.tokenType, lockInfo.amount, lockInfo.distributedTime, lockInfo.lockUpPeriodMonth, lockInfo.lastUnlockTimestamp, lockInfo.unlockAmountPerCount, lockInfo.remainUnLockCount, lockInfo.CONST_UNLOCKCOUNT, lockInfo.CONST_AMOUNT);
178     }
179 
180     function decimals() public view returns (uint8) {
181         return _decimals;
182     }
183 
184     function transfer(address recipient, uint256 amount) public returns (bool) {
185         _transfer(msg.sender, recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public returns (bool) {
194         _approve(msg.sender, spender, amount);
195         return true;
196     }
197 
198     function increaseApproval(address spender, uint256 amount) public returns (bool) {
199         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(amount));
200         return true;
201     }
202 
203     function decreaseApproval(address spender, uint256 amount) public returns (bool) {
204         if (amount >= _allowances[msg.sender][spender]) {
205             amount = 0;
206         } else {
207             amount = _allowances[msg.sender][spender].sub(amount);
208         }
209 
210         _approve(msg.sender, spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
217         return true;
218     }
219     
220     function safeTransfer(address recipient, uint256 amount) public {
221         safeTransfer(recipient, amount, "");
222     }
223 
224     function safeTransfer(address recipient, uint256 amount, bytes memory data) public {
225         transfer(recipient, amount);
226         require(_checkOnERC20Received(msg.sender, recipient, amount, data), "ERC20: transfer to non ERC20Receiver implementer");
227     }
228     
229     function safeTransferFrom(address sender, address recipient, uint256 amount) public {
230         safeTransferFrom(sender, recipient, amount, "");
231     }
232 
233     function safeTransferFrom(address sender, address recipient, uint256 amount, bytes memory data) public {
234         transferFrom(sender, recipient, amount);
235         require(_checkOnERC20Received(sender, recipient, amount, data), "ERC20: transfer to non ERC20Receiver implementer");
236     }
237 
238     function _approve(address owner, address spender, uint256 amount) internal {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241 
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _transfer(address sender, address recipient, uint256 amount) internal {
247         require(sender != address(0), "ERC20: transfer from the zero address");
248         require(recipient != address(0), "ERC20: transfer to the zero address");
249 
250         uint8 adminAccountType = _cardioWallet[sender];
251         // Crowd Sale Wallet, Team & Advisors from admin wallet Type 1, 2
252         if(adminAccountType >= 1 && adminAccountType <= 2) {
253             _addLocker(sender, recipient, adminAccountType, amount);
254         } else {
255             // Check "From" LockUp Balance
256             uint8 tokenType;
257             for (tokenType = 1; tokenType <= 4; tokenType++) {
258                 LockInfo storage lockInfo = _lockedInfo[sender][tokenType];
259                 if (lockInfo.isLocked) {
260                     _unLock(sender, tokenType);
261                 }
262             }
263             _balances[sender] = _balances[sender].sub(amount);
264             _balances[recipient] = _balances[recipient].add(amount);
265         }
266 
267         emit Transfer(sender, recipient, amount);
268     }
269 
270     function _addLocker(address sender, address recipient, uint8 adminAcountType, uint256 amount) internal {
271         require(_lockedInfo[recipient][adminAcountType].isLocked == false, "Already Locked User");
272         
273         uint256 distributedTime;
274         uint256 lockUpPeriodMonth;
275         uint256 unlockAmountPerCount;
276         uint256 remainUnLockCount;
277         uint256 CONST_UNLOCKCOUNT;
278         uint256 CONST_AMOUNT;
279         
280         if(adminAcountType == 1) { // Crowd Sale
281             distributedTime = now;
282             lockUpPeriodMonth = 0;
283             unlockAmountPerCount = amount.div(100);
284             remainUnLockCount = 6;
285             CONST_UNLOCKCOUNT = 5;
286             CONST_AMOUNT = amount;
287         } else { // Team & Advisors
288             distributedTime = now;
289             lockUpPeriodMonth = 6;
290             unlockAmountPerCount = amount.div(20);
291             remainUnLockCount = 20;
292             CONST_UNLOCKCOUNT = 20;
293             CONST_AMOUNT = amount;
294         }
295         
296         LockInfo memory newLockInfo = LockInfo({
297             isLocked: true,
298             tokenType : adminAcountType,
299             amount: amount,
300             distributedTime: distributedTime,
301             lockUpPeriodMonth: lockUpPeriodMonth,
302             lastUnlockTimestamp: 0,
303             unlockAmountPerCount: unlockAmountPerCount,
304             remainUnLockCount: remainUnLockCount,
305             CONST_UNLOCKCOUNT: CONST_UNLOCKCOUNT,
306             CONST_AMOUNT: CONST_AMOUNT
307         });
308         
309         _balances[sender] = _balances[sender].sub(amount);
310         _lockedInfo[recipient][adminAcountType] = newLockInfo;
311     }
312     
313     function _unLock(address sender, uint8 tokenType) internal {
314         LockInfo storage lockInfo = _lockedInfo[sender][tokenType];
315 
316         // Only Crowd Sale Type
317         // 864000 = 10 Days
318         if(tokenType == 1 && lockInfo.remainUnLockCount == 6 && lockInfo.distributedTime.add(864000) <= now) {
319             // lockInfo update
320             lockInfo.distributedTime = lockInfo.distributedTime.add(864000);
321             lockInfo.remainUnLockCount = 5;
322 
323             // Fisrt Distribute 5%
324             uint256 distributeAmount = lockInfo.unlockAmountPerCount.mul(5);
325             lockInfo.amount = lockInfo.amount.sub(distributeAmount);
326             _balances[sender] = _balances[sender].add(distributeAmount);
327         }
328 
329         if(_isOverLockUpPeriodMonth((now.safeSub(lockInfo.distributedTime)), lockInfo.lockUpPeriodMonth) == false) {
330             return;
331         }
332 
333         uint256 blockTime = now;
334         uint256 count = _getUnLockCount(blockTime, lockInfo);
335 
336         // None
337         if(count == 0) return;
338         uint256 unlockAmount;
339         if(tokenType == 1) {
340             uint256 remainCount = lockInfo.remainUnLockCount;
341             for(uint8 i = 0; i < count; i++) {
342                 if(remainCount == 5) {
343                     remainCount = remainCount - 1;
344                     unlockAmount = unlockAmount.add(lockInfo.unlockAmountPerCount.mul(10)); 
345                     continue;
346                 }
347 
348                 if(remainCount >= 2 && remainCount <= 4) {
349                     remainCount = remainCount - 1;
350                     unlockAmount = unlockAmount.add(lockInfo.unlockAmountPerCount.mul(20)); 
351                     continue;
352                 }
353 
354                 if(remainCount == 1) {
355                     remainCount = remainCount - 1;
356                     unlockAmount = unlockAmount.add(lockInfo.unlockAmountPerCount.mul(25)); 
357                     continue;
358                 }
359             }
360         } else {
361             unlockAmount = count.mul(lockInfo.unlockAmountPerCount);
362         }
363 
364         // Shortage due to burn token
365         // or the last distribution
366         uint256 remainUnLockCount = lockInfo.remainUnLockCount.safeSub(count);
367         if (lockInfo.amount.safeSub(unlockAmount) == 0 || remainUnLockCount == 0) {
368             unlockAmount = lockInfo.amount;
369             lockInfo.isLocked = false;
370         }
371         
372         // lockInfo update
373         lockInfo.lastUnlockTimestamp = now;
374         lockInfo.remainUnLockCount = remainUnLockCount;
375         lockInfo.amount = lockInfo.amount.sub(unlockAmount);
376         
377         _balances[sender] = _balances[sender].add(unlockAmount);
378     }
379     
380     function _getUnLockCount(uint256 curBlockTime, LockInfo lockInfo) internal pure returns (uint256) {
381         // 1 Month = 30 Days 
382         uint256 lockUpTime = lockInfo.lockUpPeriodMonth * 30 * 24 * 60 * 60;
383 
384         uint256 startTime = lockInfo.distributedTime.add(lockUpTime);
385         uint256 count = 0;
386 
387         if (lockInfo.lastUnlockTimestamp == 0) {
388             count = _convertMSToMonth(curBlockTime - startTime);
389         } else {
390             uint256 unLockedCount = _convertMSToMonth(curBlockTime - startTime);
391             uint256 alreadyUnLockCount = lockInfo.CONST_UNLOCKCOUNT - lockInfo.remainUnLockCount;
392             
393             count = unLockedCount.safeSub(alreadyUnLockCount);
394         }
395         return count;
396     }
397     
398     function _isOverLockUpPeriodMonth(uint256 time, uint256 period) internal pure returns (bool) {
399         return _convertMSToMonth(time) > period;
400     }
401     
402     function _convertMSToMonth(uint256 time) internal pure returns (uint256) {
403         return time.div(60).div(60).div(24).div(30);
404     }
405 
406     function isContract(address account) internal view returns (bool) {
407         uint256 size;
408         assembly { size := extcodesize(account) }
409         return size > 0;
410     }
411 
412     function _checkOnERC20Received(address sender, address recipient, uint256 amount, bytes memory _data) internal returns (bool) {
413         if (!isContract(recipient)) {
414             return true;
415         }
416         bytes4 retval = IERC20Receiver(recipient).onERC20Received(msg.sender, sender, amount, _data);
417         return (retval == _ERC20_RECEIVED);
418     }
419 }
420 // ----------------------------------------------------------------------------
421 // @title Burnable Token
422 // @dev Token that can be irreversibly burned (destroyed).
423 // ----------------------------------------------------------------------------
424 contract BurnableToken is ERC20 {
425     event BurnAdminAmount(address indexed burner, uint256 value);
426     event BurnLockedToken(address indexed burner, uint256 value, uint8 tokenType);
427 
428     modifier onlyCardioWallet() {
429       require(msg.sender == 0x588eaB2Fd73e381efFA8E4F084bF5a686eC9eD68
430       || msg.sender == 0x461030be06272623f7135ba9926Ea9Afba00d8E3
431     ); _; }
432 
433     function burnAdminAmount(uint256 _value) onlyOwner public {
434         require(_value <= _balances[msg.sender]);
435 
436         _balances[msg.sender] = _balances[msg.sender].sub(_value);
437         _totalSupply = _totalSupply.sub(_value);
438     
439         emit BurnAdminAmount(msg.sender, _value);
440         emit Transfer(msg.sender, address(0), _value);
441     }
442 
443     // Ecosystem Activation - 3
444     // 0x588eaB2Fd73e381efFA8E4F084bF5a686eC9eD68
445     // Business Development - 4
446     // 0x461030be06272623f7135ba9926Ea9Afba00d8E3
447     function burnTypeToken(uint256 _value) onlyCardioWallet public {
448         uint8 adminAccountType = _cardioWallet[msg.sender];
449         LockInfo storage lockInfo = _lockedInfo[msg.sender][adminAccountType];
450 
451         lockInfo.amount = lockInfo.amount.sub(_value);
452         _totalSupply = _totalSupply.sub(_value);
453 
454         if(lockInfo.amount == 0) {
455             lockInfo.isLocked = false;
456         }
457     
458         emit BurnLockedToken(msg.sender, _value, adminAccountType);
459         emit Transfer(msg.sender, address(0), _value);
460     }
461 }
462 // ----------------------------------------------------------------------------
463 // @title Mintable token
464 // @dev Simple ERC20 Token example, with mintable token creation
465 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
466 // ----------------------------------------------------------------------------
467 contract MintableToken is ERC20 {
468     event Mint(address indexed to, uint256 amount);
469     event MintFinished();
470 
471     uint256 ECOSYSTEM_AMOUNT = 7300000000 * (10**18);
472     uint256 BUSINESS_AMOUNT = 1150000000 * (10**18);
473 
474     bool private _mintingFinished = false;
475 
476     modifier canMint() { require(!_mintingFinished); _; }
477 
478     function mintingFinished() public view returns (bool) {
479         return _mintingFinished;
480     }
481 
482     function mint(address _to, uint256 _amount, uint8 _tokenType) onlyOwner canMint public returns (bool) {
483         require(_tokenType < 5, "Token Type NULL");
484         _totalSupply = _totalSupply.add(_amount);
485 
486         if(_tokenType >= 3) {
487             uint256 lockUpPeriodMonth;
488             uint256 unlockAmountPerCount;
489             uint256 remainUnLockCount;
490             uint256 CONST_UNLOCKCOUNT;
491             uint256 CONST_AMOUNT;
492             
493             if(_tokenType == 3) { // Ecosystem Activation
494                 lockUpPeriodMonth = 0;
495                 unlockAmountPerCount = ECOSYSTEM_AMOUNT.div(100);
496                 remainUnLockCount = 99;
497                 CONST_UNLOCKCOUNT = 99;
498                 CONST_AMOUNT = ECOSYSTEM_AMOUNT;
499             } else if(_tokenType == 4) { // Business Development
500                 lockUpPeriodMonth = 0;
501                 unlockAmountPerCount = BUSINESS_AMOUNT.div(100);
502                 remainUnLockCount = 85;
503                 CONST_UNLOCKCOUNT = 85;
504                 CONST_AMOUNT = BUSINESS_AMOUNT;
505             }
506             
507             LockInfo memory newLockInfo = LockInfo({
508                 isLocked: true,
509                 tokenType : _tokenType,
510                 amount: _amount,
511                 distributedTime: _tokenCreatedTime,
512                 lockUpPeriodMonth: lockUpPeriodMonth,
513                 lastUnlockTimestamp: 0,
514                 unlockAmountPerCount: unlockAmountPerCount,
515                 remainUnLockCount: remainUnLockCount,
516                 CONST_UNLOCKCOUNT: CONST_UNLOCKCOUNT,
517                 CONST_AMOUNT: CONST_AMOUNT
518             });
519             
520             _lockedInfo[_to][_tokenType] = newLockInfo;
521             
522             emit LockedInfo(address(0), _to, _amount, _tokenType, _tokenCreatedTime, lockUpPeriodMonth, unlockAmountPerCount, remainUnLockCount, CONST_UNLOCKCOUNT);
523         } else {
524             _balances[_to] = _balances[_to].add(_amount);
525         }
526 
527         emit Mint(_to, _amount);
528         emit Transfer(address(0), _to, _amount);
529 
530         return true;
531     }
532 
533     function finishMinting() onlyOwner canMint public returns (bool) {
534         _mintingFinished = true;
535         emit MintFinished();
536         return true;
537     }
538 }
539 // ----------------------------------------------------------------------------
540 // @Project CardioCoin
541 // ----------------------------------------------------------------------------
542 contract CardioCoin is MintableToken, BurnableToken {
543     event SetTokenInfo(string name, string symbol);
544     string private _name = "";
545     string private _symbol = "";
546 
547     constructor() public {
548         _name = "CardioCoin";
549         _symbol = "CRDC";
550 
551         emit SetTokenInfo(_name, _symbol);
552     }
553 
554     function name() public view returns (string memory) {
555         return _name;
556     }
557 
558     function symbol() public view returns (string memory) {
559         return _symbol;
560     }
561 }