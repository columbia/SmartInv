1 /**
2  *Submitted for verification at polygonscan.com on 2022-07-12
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 library SafeMath {
9     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
10         unchecked {
11             uint256 c = a + b;
12             if (c < a) return (false, 0);
13             return (true, c);
14         }
15     }
16 
17     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             if (b > a) return (false, 0);
20             return (true, a - b);
21         }
22     }
23 
24     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27             // benefit is lost if 'b' is also tested.
28             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
29             if (a == 0) return (true, 0);
30             uint256 c = a * b;
31             if (c / a != b) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b == 0) return (false, 0);
39             return (true, a / b);
40         }
41     }
42 
43     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b == 0) return (false, 0);
46             return (true, a % b);
47         }
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a + b;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a - b;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a * b;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a / b;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a % b;
68     }
69 
70     function sub(
71         uint256 a,
72         uint256 b,
73         string memory errorMessage
74     ) internal pure returns (uint256) {
75         unchecked {
76             require(b <= a, errorMessage);
77             return a - b;
78         }
79     }
80 
81     function div(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         unchecked {
87             require(b > 0, errorMessage);
88             return a / b;
89         }
90     }
91 
92     function mod(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         unchecked {
98             require(b > 0, errorMessage);
99             return a % b;
100         }
101     }
102 }
103 
104 library Address {
105     function isContract(address account) internal view returns (bool) {
106         return account.code.length > 0;
107     }
108 
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         (bool success, ) = recipient.call{value: amount}("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 
116     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
117         return functionCall(target, data, "Address: low-level call failed");
118     }
119 
120     function functionCall(
121         address target,
122         bytes memory data,
123         string memory errorMessage
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, 0, errorMessage);
126     }
127 
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value
132     ) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
134     }
135 
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value,
140         string memory errorMessage
141     ) internal returns (bytes memory) {
142         require(address(this).balance >= value, "Address: insufficient balance for call");
143         require(isContract(target), "Address: call to non-contract");
144 
145         (bool success, bytes memory returndata) = target.call{value: value}(data);
146         return verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     function functionStaticCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal view returns (bytes memory) {
158         require(isContract(target), "Address: static call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.staticcall(data);
161         return verifyCallResult(success, returndata, errorMessage);
162     }
163 
164     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
166     }
167 
168     function functionDelegateCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         require(isContract(target), "Address: delegate call to non-contract");
174 
175         (bool success, bytes memory returndata) = target.delegatecall(data);
176         return verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     function verifyCallResult(
180         bool success,
181         bytes memory returndata,
182         string memory errorMessage
183     ) internal pure returns (bytes memory) {
184         if (success) {
185             return returndata;
186         } else {
187             // Look for revert reason and bubble it up if present
188             if (returndata.length > 0) {
189                 // The easiest way to bubble the revert reason is using memory via assembly
190 
191                 assembly {
192                     let returndata_size := mload(returndata)
193                     revert(add(32, returndata), returndata_size)
194                 }
195             } else {
196                 revert(errorMessage);
197             }
198         }
199     }
200 }
201 
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         return msg.data;
209     }
210 }
211 
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     constructor() {
218         _transferOwnership(_msgSender());
219     }
220 
221     function owner() public view virtual returns (address) {
222         return _owner;
223     }
224 
225     modifier onlyOwner() {
226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(newOwner != address(0), "Ownable: new owner is the zero address");
236         _transferOwnership(newOwner);
237     }
238 
239     function _transferOwnership(address newOwner) internal virtual {
240         address oldOwner = _owner;
241         _owner = newOwner;
242         emit OwnershipTransferred(oldOwner, newOwner);
243     }
244 }
245 
246 interface IERC20 {
247 
248     event Transfer(address indexed from, address indexed to, uint256 value);
249     event Approval(address indexed owner, address indexed spender, uint256 value);
250 
251     function totalSupply() external view returns (uint256);
252     function balanceOf(address account) external view returns (uint256);
253     function transfer(address to, uint256 amount) external returns (bool);
254     function allowance(address owner, address spender) external view returns (uint256);
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     function transferFrom(
258         address from,
259         address to,
260         uint256 amount
261     ) external returns (bool);
262 }
263 
264 interface IERC20Metadata is IERC20 {
265     /**
266      * @dev Returns the name of the token.
267      */
268     function name() external view returns (string memory);
269 
270     /**
271      * @dev Returns the symbol of the token.
272      */
273     function symbol() external view returns (string memory);
274 
275     /**
276      * @dev Returns the decimals places of the token.
277      */
278     function decimals() external view returns (uint8);
279 }
280 
281 contract ERC20 is Context, IERC20, IERC20Metadata {
282     using SafeMath for uint256;
283     using Address for address;
284 
285     mapping(address => uint256) private _balances;
286 
287     mapping(address => mapping(address => uint256)) private _allowances;
288 
289     uint256 private _totalSupply;
290 
291     string private _name;
292     string private _symbol;
293 
294     constructor(string memory name_, string memory symbol_) {
295         _name = name_;
296         _symbol = symbol_;
297     }
298 
299     function name() public view virtual override returns (string memory) {
300         return _name;
301     }
302 
303     function symbol() public view virtual override returns (string memory) {
304         return _symbol;
305     }
306 
307     function decimals() public view virtual override returns (uint8) {
308         return 18;
309     }
310 
311     function totalSupply() public view virtual override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     function balanceOf(address account) public view virtual override returns (uint256) {
316         return _balances[account];
317     }
318 
319     function transfer(address to, uint256 amount) public virtual override returns (bool) {
320         address owner = _msgSender();
321         _transfer(owner, to, amount);
322         return true;
323     }
324 
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     function approve(address spender, uint256 amount) public virtual override returns (bool) {
330         address owner = _msgSender();
331         _approve(owner, spender, amount);
332         return true;
333     }
334 
335     function transferFrom(
336         address from,
337         address to,
338         uint256 amount
339     ) public virtual override returns (bool) {
340         address spender = _msgSender();
341         _spendAllowance(from, spender, amount);
342         _transfer(from, to, amount);
343         return true;
344     }
345 
346     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
347         address owner = _msgSender();
348         _approve(owner, spender, allowance(owner, spender) + addedValue);
349         return true;
350     }
351 
352     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
353         address owner = _msgSender();
354         uint256 currentAllowance = allowance(owner, spender);
355         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
356         unchecked {
357             _approve(owner, spender, currentAllowance - subtractedValue);
358         }
359 
360         return true;
361     }
362 
363     function _transfer(
364         address from,
365         address to,
366         uint256 amount
367     ) internal virtual {
368         require(from != address(0), "ERC20: transfer from the zero address");
369         require(to != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(from, to, amount);
372 
373         uint256 fromBalance = _balances[from];
374         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[from] = fromBalance - amount;
377         }
378         _balances[to] += amount;
379 
380         emit Transfer(from, to, amount);
381 
382         _afterTokenTransfer(from, to, amount);
383     }
384 
385     function _mint(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: mint to the zero address");
387 
388         _beforeTokenTransfer(address(0), account, amount);
389 
390         _totalSupply += amount;
391         _balances[account] += amount;
392         emit Transfer(address(0), account, amount);
393 
394         _afterTokenTransfer(address(0), account, amount);
395     }
396 
397     function _burn(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _beforeTokenTransfer(account, address(0), amount);
401 
402         uint256 accountBalance = _balances[account];
403         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
404         unchecked {
405             _balances[account] = accountBalance - amount;
406         }
407         _totalSupply -= amount;
408 
409         emit Transfer(account, address(0), amount);
410 
411         _afterTokenTransfer(account, address(0), amount);
412     }
413 
414     function _approve(
415         address owner,
416         address spender,
417         uint256 amount
418     ) internal virtual {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     function _spendAllowance(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         uint256 currentAllowance = allowance(owner, spender);
432         if (currentAllowance != type(uint256).max) {
433             require(currentAllowance >= amount, "ERC20: insufficient allowance");
434             unchecked {
435                 _approve(owner, spender, currentAllowance - amount);
436             }
437         }
438     }
439 
440     function _beforeTokenTransfer(
441         address from,
442         address to,
443         uint256 amount
444     ) internal virtual {}
445 
446     function _afterTokenTransfer(
447         address from,
448         address to,
449         uint256 amount
450     ) internal virtual {}
451 }
452 
453 contract Lockable is Context {
454     event Locked(address account);
455     event Unlocked(address account);
456 
457     event Freezed();
458     event UnFreezed();
459 
460     bool public _freezed; // 전체 토큰 락에 대한 기능   
461     mapping(address => bool) private _locked; // 개별적인 주소에 대한 토큰 락에 대한 기능
462 
463     modifier validFreeze {
464         require(_freezed == false, "ERC20: all token is freezed");
465         _;
466     }
467 
468     function _freeze() internal virtual {
469         _freezed = true;
470         emit Freezed();
471     }
472 
473     function _unfreeze() internal virtual {
474         _freezed = false;
475         emit UnFreezed();
476     }
477 
478     function locked(address _to) public view returns (bool) {
479         return _locked[_to];
480     }
481 
482     function _lock(address to) internal virtual {
483         require(to != address(0), "ERC20: lock to the zero address");
484 
485         _locked[to] = true;
486         emit Locked(to);
487     }
488 
489     function _unlock(address to) internal virtual {
490         require(to != address(0), "ERC20: lock to the zero address");
491 
492         _locked[to] = false;
493         emit Unlocked(to);
494     }
495 }
496 
497 contract ERC20Base is Context, ERC20, Ownable, Lockable {
498     uint constant SECONDS_PER_DAY = 24 * 60 * 60;
499     uint constant SECONDS_PER_HOUR = 60 * 60;
500     uint constant SECONDS_PER_MINUTE = 60;
501 
502      // Info of each pool.
503     struct LockInfo {
504         uint256 total;
505         uint256 freezeTime;
506         uint256 freezeRatio;
507         uint256 releaseRatio;
508         uint256 duration;
509         uint256 nextTime;
510     }
511 
512     mapping (address => LockInfo) private _lockInfos;
513     mapping (address => bool) public _manualEntity;
514 
515     string internal constant TOKEN_LOCKED = 'ERC20: Tokens is locked';
516 
517     constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){}
518 
519     function mint(address account, uint256 amount) internal virtual onlyOwner {
520         _mint(account, amount);
521     }
522 
523     function allFreeze() public onlyOwner {
524         _freeze();
525     }
526 
527     function allUnFreeze() public onlyOwner {
528         _unfreeze();
529     }
530 
531     function lock(address to) public onlyOwner {
532         _lock(to);
533     }
534 
535     function unlock(address to) public onlyOwner {
536         _unlock(to);
537     }
538 
539     function _addDays(uint256 timestamp, uint256 _days) internal pure returns(uint256 newTimestamp) {
540         newTimestamp = timestamp + _days * SECONDS_PER_DAY;
541         require(newTimestamp >= timestamp);
542     }
543 
544     function _addHours(uint256 timestamp, uint256 _hours) internal pure returns (uint newTimestamp) {
545         newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
546         require(newTimestamp >= timestamp);
547     }
548 
549     function _addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
550         newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
551         require(newTimestamp >= timestamp);
552     }
553     function _addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
554         newTimestamp = timestamp + _seconds;
555         require(newTimestamp >= timestamp);
556     }
557 
558     function updateTokenLockInfo() public returns(LockInfo memory) {
559         bool isEntity = _manualEntity[msg.sender];
560         require(isEntity == true, "ERC20: There is not lockinfo");
561 
562         LockInfo storage li = _lockInfos[msg.sender];
563         if(li.nextTime < block.timestamp && li.releaseRatio < 10000) {
564             li.nextTime = _addMinutes(li.nextTime, li.duration);
565             li.releaseRatio += li.freezeRatio;
566 
567             if(li.releaseRatio > 10000)
568                 li.releaseRatio = 10000;
569         }
570 
571         return _lockInfos[msg.sender];
572     }
573 
574     // warining!!! ratio 100% = 10000, 50% = 5000,  1% = 100;
575     function tokensLockedAtTime(address to, uint256 amount, uint256 time, uint256 ratio, uint256 duration) public onlyOwner {
576         require(to != address(0), "ERC20: lock to the zero address");
577         require(amount > 0, "ERC20: amount is over zero");
578         require(time > block.timestamp, "TimeLock: lock time is over current time");
579 
580         bool isEntity = _manualEntity[to];
581         if(!isEntity) {
582             _manualEntity[to] = true;
583             _lockInfos[to] = LockInfo(amount, time, ratio, 0, duration, _addMinutes(time, duration));
584         }
585     }
586 
587     function getTokensLockedInfo(address to) public view returns(LockInfo memory) {
588         require(to != address(0), "ERC20: lock to the zero address");
589         bool isEntity = _manualEntity[to];
590         require(isEntity == true, "TimeLock: There is not lockinfo");
591         
592         return _lockInfos[to];
593     }
594 
595     function transferFrom(address from,
596         address to,
597         uint256 amount
598     ) public 
599     validFreeze 
600     virtual override returns (bool) { 
601         require(locked(from) == false, TOKEN_LOCKED);
602         return super.transferFrom(from, to, amount);
603     }
604 
605     function transfer(address to, uint256 amount) 
606     public
607     validFreeze 
608     virtual override returns (bool) {
609         bool isEntity = _manualEntity[msg.sender];
610         if(isEntity) {
611             LockInfo storage li = _lockInfos[msg.sender];
612             require(li.releaseRatio > 0, "TimeLock : Please wait to release");
613             require(li.total >= amount, "TimeLock : Please check release amount");
614             
615             uint256 pAmount = 0;
616             if(li.releaseRatio >= 10000)
617                 pAmount = li.total;
618             else
619                 pAmount = (li.total * li.releaseRatio) / 100;
620         }
621 
622         require(locked(msg.sender) == false, TOKEN_LOCKED);
623         return super.transfer(to, amount);
624     }
625 }
626 
627 contract Create_Token is ERC20Base {
628     constructor() ERC20Base("EBTC", "EBTC") {
629         mint(msg.sender, 50*(10**8)*(10**uint256(decimals())));
630     }
631 }