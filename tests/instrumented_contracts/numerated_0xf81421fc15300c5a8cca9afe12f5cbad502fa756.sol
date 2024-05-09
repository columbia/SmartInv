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
146         _cardioWallet[0x93f53B4C8ED2C0Cc84BdE1166B290998bAA0d005] = 1;
147         // Team & Advisors
148         _cardioWallet[0x0787bb893334FE0E6254a575B7D11E1009CBD2a3] = 2;
149         // Ecosystem Activation
150         _cardioWallet[0x3E5553619440A990f9227AB4557433e6AFCb1267] = 3;
151         // Business Development
152         _cardioWallet[0x0f1b039128d04891BC15137271F61c259B4f239D] = 4;
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
282             lockUpPeriodMonth = 12;
283             unlockAmountPerCount = amount.div(100);
284             remainUnLockCount = 6;
285             CONST_UNLOCKCOUNT = 5;
286             CONST_AMOUNT = amount;
287         } else { // Team & Advisors
288             distributedTime = now;
289             lockUpPeriodMonth = 20;
290             unlockAmountPerCount = amount.div(40);
291             remainUnLockCount = 40;
292             CONST_UNLOCKCOUNT = 40;
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
317         // 518400 = 6 Days
318         if(tokenType == 1 && lockInfo.remainUnLockCount == 6 && lockInfo.distributedTime.add(518400) <= now) {
319             // lockInfo update
320             lockInfo.remainUnLockCount = 5;
321 
322             // Fisrt Distribute 5%
323             uint256 distributeAmount = lockInfo.unlockAmountPerCount.mul(50);
324             lockInfo.amount = lockInfo.amount.sub(distributeAmount);
325             _balances[sender] = _balances[sender].add(distributeAmount);
326         }
327 
328         if(_isOverLockUpPeriodMonth((now.safeSub(lockInfo.distributedTime)), lockInfo.lockUpPeriodMonth) == false) {
329             return;
330         }
331 
332         uint256 blockTime = now;
333         uint256 count = _getUnLockCount(blockTime, lockInfo);
334 
335         // None
336         if(count == 0) return;
337         uint256 unlockAmount;
338         if(tokenType == 1) {
339             unlockAmount = count.mul(lockInfo.unlockAmountPerCount.mul(10));
340         } else {
341             unlockAmount = count.mul(lockInfo.unlockAmountPerCount);
342         }
343 
344         // Shortage due to burn token
345         // or the last distribution
346         uint256 remainUnLockCount = lockInfo.remainUnLockCount.safeSub(count);
347         if (lockInfo.amount.safeSub(unlockAmount) == 0 || remainUnLockCount == 0) {
348             unlockAmount = lockInfo.amount;
349             lockInfo.isLocked = false;
350         }
351         
352         // lockInfo update
353         lockInfo.lastUnlockTimestamp = now;
354         lockInfo.remainUnLockCount = remainUnLockCount;
355         lockInfo.amount = lockInfo.amount.sub(unlockAmount);
356         
357         _balances[sender] = _balances[sender].add(unlockAmount);
358     }
359     
360     function _getUnLockCount(uint256 curBlockTime, LockInfo lockInfo) internal pure returns (uint256) {
361         // 1 Month = 30 Days 
362         uint256 lockUpTime = lockInfo.lockUpPeriodMonth * 30 * 24 * 60 * 60;
363 
364         uint256 startTime = lockInfo.distributedTime.add(lockUpTime);
365         uint256 count = 0;
366 
367         if (lockInfo.lastUnlockTimestamp == 0) {
368             count = _convertMSToMonth(curBlockTime - startTime);
369         } else {
370             uint256 unLockedCount = _convertMSToMonth(curBlockTime - startTime);
371             uint256 alreadyUnLockCount = lockInfo.CONST_UNLOCKCOUNT - lockInfo.remainUnLockCount;
372             
373             count = unLockedCount.safeSub(alreadyUnLockCount);
374         }
375         return count;
376     }
377     
378     function _isOverLockUpPeriodMonth(uint256 time, uint256 period) internal pure returns (bool) {
379         return _convertMSToMonth(time) > period;
380     }
381     
382     function _convertMSToMonth(uint256 time) internal pure returns (uint256) {
383         return time.div(60).div(60).div(24).div(30);
384     }
385 
386     function isContract(address account) internal view returns (bool) {
387         uint256 size;
388         assembly { size := extcodesize(account) }
389         return size > 0;
390     }
391 
392     function _checkOnERC20Received(address sender, address recipient, uint256 amount, bytes memory _data) internal returns (bool) {
393         if (!isContract(recipient)) {
394             return true;
395         }
396         bytes4 retval = IERC20Receiver(recipient).onERC20Received(msg.sender, sender, amount, _data);
397         return (retval == _ERC20_RECEIVED);
398     }
399 }
400 // ----------------------------------------------------------------------------
401 // @title Burnable Token
402 // @dev Token that can be irreversibly burned (destroyed).
403 // ----------------------------------------------------------------------------
404 contract BurnableToken is ERC20 {
405     event BurnAdminAmount(address indexed burner, uint256 value);
406     event BurnLockedToken(address indexed burner, uint256 value, uint8 tokenType);
407 
408     function burnAdminAmount(uint256 _value) onlyOwner public {
409         require(_value <= _balances[msg.sender]);
410 
411         _balances[msg.sender] = _balances[msg.sender].sub(_value);
412         _totalSupply = _totalSupply.sub(_value);
413     
414         emit BurnAdminAmount(msg.sender, _value);
415         emit Transfer(msg.sender, address(0), _value);
416     }
417 }
418 // ----------------------------------------------------------------------------
419 // @title Mintable token
420 // @dev Simple ERC20 Token example, with mintable token creation
421 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
422 // ----------------------------------------------------------------------------
423 contract MintableToken is ERC20 {
424     event Mint(address indexed to, uint256 amount);
425     event MintFinished();
426 
427     uint256 ECOSYSTEM_AMOUNT = 5400000000 * (10**18);
428     uint256 BUSINESSDEVELOPMENT_AMOUNT = 3000000000 * (10**18);
429     bool private _mintingFinished = false;
430 
431     modifier canMint() { require(!_mintingFinished); _; }
432 
433     function mintingFinished() public view returns (bool) {
434         return _mintingFinished;
435     }
436 
437     // Token Type - 1 : Crowd Sale
438     // Token Type - 2 : Team & Advisors
439     // Token Type - 3 : Ecosystem Activation
440     // Token Type - 4 : Business Development
441     function mint(address _to, uint256 _amount, uint8 _tokenType) onlyOwner canMint public returns (bool) {
442         require(_tokenType < 5, "Token Type NULL");
443         _totalSupply = _totalSupply.add(_amount);
444 
445         uint256 lockUpPeriodMonth;
446         uint256 unlockAmountPerCount;
447         uint256 remainUnLockCount;
448         uint256 CONST_UNLOCKCOUNT;
449         uint256 CONST_AMOUNT;
450 
451         // Ecosystem Activation
452         if(_tokenType == 3) {
453             lockUpPeriodMonth = 12;
454             unlockAmountPerCount = ECOSYSTEM_AMOUNT.div(50);
455             remainUnLockCount = 50;
456             CONST_UNLOCKCOUNT = 50;
457             CONST_AMOUNT = ECOSYSTEM_AMOUNT;
458             
459             LockInfo memory newLockInfoEA = LockInfo({
460                 isLocked: true,
461                 tokenType : _tokenType,
462                 amount: _amount,
463                 distributedTime: _tokenCreatedTime,
464                 lockUpPeriodMonth: lockUpPeriodMonth,
465                 lastUnlockTimestamp: 0,
466                 unlockAmountPerCount: unlockAmountPerCount,
467                 remainUnLockCount: remainUnLockCount,
468                 CONST_UNLOCKCOUNT: CONST_UNLOCKCOUNT,
469                 CONST_AMOUNT: CONST_AMOUNT
470             });
471             
472             _lockedInfo[_to][_tokenType] = newLockInfoEA;
473             
474             emit LockedInfo(address(0), _to, _amount, _tokenType, _tokenCreatedTime, lockUpPeriodMonth, unlockAmountPerCount, remainUnLockCount, CONST_UNLOCKCOUNT);
475         } else if(_tokenType == 4) {
476             // Business Development
477             lockUpPeriodMonth = 24;
478             unlockAmountPerCount = BUSINESSDEVELOPMENT_AMOUNT.div(40);
479             remainUnLockCount = 36;
480             CONST_UNLOCKCOUNT = 36;
481             CONST_AMOUNT = BUSINESSDEVELOPMENT_AMOUNT;
482             
483             LockInfo memory newLockInfoBD = LockInfo({
484                 isLocked: true,
485                 tokenType : _tokenType,
486                 amount: _amount,
487                 distributedTime: _tokenCreatedTime,
488                 lockUpPeriodMonth: lockUpPeriodMonth,
489                 lastUnlockTimestamp: 0,
490                 unlockAmountPerCount: unlockAmountPerCount,
491                 remainUnLockCount: remainUnLockCount,
492                 CONST_UNLOCKCOUNT: CONST_UNLOCKCOUNT,
493                 CONST_AMOUNT: CONST_AMOUNT
494             });
495             
496             _lockedInfo[_to][_tokenType] = newLockInfoBD;
497             
498             emit LockedInfo(address(0), _to, _amount, _tokenType, _tokenCreatedTime, lockUpPeriodMonth, unlockAmountPerCount, remainUnLockCount, CONST_UNLOCKCOUNT);
499         } else {
500             _balances[_to] = _balances[_to].add(_amount);
501         }
502 
503         emit Mint(_to, _amount);
504         emit Transfer(address(0), _to, _amount);
505 
506         return true;
507     }
508 
509     function finishMinting() onlyOwner canMint public returns (bool) {
510         _mintingFinished = true;
511         emit MintFinished();
512         return true;
513     }
514 }
515 // ----------------------------------------------------------------------------
516 // @Project CardioCoin
517 // ----------------------------------------------------------------------------
518 contract CardioCoin is MintableToken, BurnableToken {
519     event SetTokenInfo(string name, string symbol);
520     string private _name = "";
521     string private _symbol = "";
522 
523     constructor() public {
524         _name = "CardioCoin";
525         _symbol = "CRDC";
526 
527         emit SetTokenInfo(_name, _symbol);
528     }
529 
530     function name() public view returns (string memory) {
531         return _name;
532     }
533 
534     function symbol() public view returns (string memory) {
535         return _symbol;
536     }
537 }