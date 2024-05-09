1 pragma solidity 0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
45 
46 contract PauserRole {
47     using Roles for Roles.Role;
48 
49     event PauserAdded(address indexed account);
50     event PauserRemoved(address indexed account);
51 
52     Roles.Role private _pausers;
53 
54     constructor () internal {
55         _addPauser(msg.sender);
56     }
57 
58     modifier onlyPauser() {
59         require(isPauser(msg.sender));
60         _;
61     }
62 
63     function isPauser(address account) public view returns (bool) {
64         return _pausers.has(account);
65     }
66 
67     function addPauser(address account) public onlyPauser {
68         _addPauser(account);
69     }
70 
71     function renouncePauser() public {
72         _removePauser(msg.sender);
73     }
74 
75     function _addPauser(address account) internal {
76         _pausers.add(account);
77         emit PauserAdded(account);
78     }
79 
80     function _removePauser(address account) internal {
81         _pausers.remove(account);
82         emit PauserRemoved(account);
83     }
84 }
85 
86 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
87 
88 /**
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is PauserRole {
93     event Paused(address account);
94     event Unpaused(address account);
95 
96     bool private _paused;
97 
98     constructor () internal {
99         _paused = false;
100     }
101 
102     /**
103      * @return true if the contract is paused, false otherwise.
104      */
105     function paused() public view returns (bool) {
106         return _paused;
107     }
108 
109     /**
110      * @dev Modifier to make a function callable only when the contract is not paused.
111      */
112     modifier whenNotPaused() {
113         require(!_paused);
114         _;
115     }
116 
117     /**
118      * @dev Modifier to make a function callable only when the contract is paused.
119      */
120     modifier whenPaused() {
121         require(_paused);
122         _;
123     }
124 
125     /**
126      * @dev called by the owner to pause, triggers stopped state
127      */
128     function pause() public onlyPauser whenNotPaused {
129         _paused = true;
130         emit Paused(msg.sender);
131     }
132 
133     /**
134      * @dev called by the owner to unpause, returns to normal state
135      */
136     function unpause() public onlyPauser whenPaused {
137         _paused = false;
138         emit Unpaused(msg.sender);
139     }
140 }
141 
142 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 interface IERC20 {
149     function transfer(address to, uint256 value) external returns (bool);
150 
151     function approve(address spender, uint256 value) external returns (bool);
152 
153     function transferFrom(address from, address to, uint256 value) external returns (bool);
154 
155     function totalSupply() external view returns (uint256);
156 
157     function balanceOf(address who) external view returns (uint256);
158 
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: lib/ds-math/src/math.sol
167 
168 /// math.sol -- mixin for inline numerical wizardry
169 
170 // This program is free software: you can redistribute it and/or modify
171 // it under the terms of the GNU General Public License as published by
172 // the Free Software Foundation, either version 3 of the License, or
173 // (at your option) any later version.
174 
175 // This program is distributed in the hope that it will be useful,
176 // but WITHOUT ANY WARRANTY; without even the implied warranty of
177 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
178 // GNU General Public License for more details.
179 
180 // You should have received a copy of the GNU General Public License
181 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
182 
183 pragma solidity >0.4.13;
184 
185 contract DSMath {
186     function add(uint x, uint y) internal pure returns (uint z) {
187         require((z = x + y) >= x, "ds-math-add-overflow");
188     }
189     function sub(uint x, uint y) internal pure returns (uint z) {
190         require((z = x - y) <= x, "ds-math-sub-underflow");
191     }
192     function mul(uint x, uint y) internal pure returns (uint z) {
193         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
194     }
195 
196     function min(uint x, uint y) internal pure returns (uint z) {
197         return x <= y ? x : y;
198     }
199     function max(uint x, uint y) internal pure returns (uint z) {
200         return x >= y ? x : y;
201     }
202     function imin(int x, int y) internal pure returns (int z) {
203         return x <= y ? x : y;
204     }
205     function imax(int x, int y) internal pure returns (int z) {
206         return x >= y ? x : y;
207     }
208 
209     uint constant WAD = 10 ** 18;
210     uint constant RAY = 10 ** 27;
211 
212     function wmul(uint x, uint y) internal pure returns (uint z) {
213         z = add(mul(x, y), WAD / 2) / WAD;
214     }
215     function rmul(uint x, uint y) internal pure returns (uint z) {
216         z = add(mul(x, y), RAY / 2) / RAY;
217     }
218     function wdiv(uint x, uint y) internal pure returns (uint z) {
219         z = add(mul(x, WAD), y / 2) / y;
220     }
221     function rdiv(uint x, uint y) internal pure returns (uint z) {
222         z = add(mul(x, RAY), y / 2) / y;
223     }
224 
225     // This famous algorithm is called "exponentiation by squaring"
226     // and calculates x^n with x as fixed-point and n as regular unsigned.
227     //
228     // It's O(log n), instead of O(n) for naive repeated multiplication.
229     //
230     // These facts are why it works:
231     //
232     //  If n is even, then x^n = (x^2)^(n/2).
233     //  If n is odd,  then x^n = x * x^(n-1),
234     //   and applying the equation for even x gives
235     //    x^n = x * (x^2)^((n-1) / 2).
236     //
237     //  Also, EVM division is flooring and
238     //    floor[(n-1) / 2] = floor[n / 2].
239     //
240     function rpow(uint x, uint n) internal pure returns (uint z) {
241         z = n % 2 != 0 ? x : RAY;
242 
243         for (n /= 2; n != 0; n /= 2) {
244             x = rmul(x, x);
245 
246             if (n % 2 != 0) {
247                 z = rmul(z, x);
248             }
249         }
250     }
251 }
252 
253 // File: contracts/interfaces/IWrappedEther.sol
254 
255 contract IWrappedEther is IERC20 {
256     function deposit() external payable;
257     function withdraw(uint amount) external;
258 }
259 
260 // File: contracts/interfaces/ISaiTub.sol
261 
262 interface DSValue {
263     function peek() external view returns (bytes32, bool);
264 }
265 
266 interface ISaiTub {
267     function sai() external view returns (IERC20);  // Stablecoin
268     function sin() external view returns (IERC20);  // Debt (negative sai)
269     function skr() external view returns (IERC20);  // Abstracted collateral
270     function gem() external view returns (IWrappedEther);  // Underlying collateral
271     function gov() external view returns (IERC20);  // Governance token
272 
273     function open() external returns (bytes32 cup);
274     function join(uint wad) external;
275     function exit(uint wad) external;
276     function give(bytes32 cup, address guy) external;
277     function lock(bytes32 cup, uint wad) external;
278     function free(bytes32 cup, uint wad) external;
279     function draw(bytes32 cup, uint wad) external;
280     function wipe(bytes32 cup, uint wad) external;
281     function shut(bytes32 cup) external;
282     function per() external view returns (uint ray);
283     function lad(bytes32 cup) external view returns (address);
284     
285     function tab(bytes32 cup) external returns (uint);
286     function rap(bytes32 cup) external returns (uint);
287     function ink(bytes32 cup) external view returns (uint);
288     function mat() external view returns (uint);    // Liquidation ratio
289     function fee() external view returns (uint);    // Governance fee
290     function pep() external view returns (DSValue); // Governance price feed
291     function cap() external view returns (uint); // Debt ceiling
292     
293 
294     function cups(bytes32) external view returns (address, uint, uint, uint);
295 }
296 
297 // File: contracts/interfaces/IDex.sol
298 
299 interface IDex {
300     function getPayAmount(IERC20 pay_gem, IERC20 buy_gem, uint buy_amt) external view returns (uint);
301     function buyAllAmount(IERC20 buy_gem, uint buy_amt, IERC20 pay_gem, uint max_fill_amount) external returns (uint);
302     function offer(
303         uint pay_amt,    //maker (ask) sell how much
304         IERC20 pay_gem,   //maker (ask) sell which token
305         uint buy_amt,    //maker (ask) buy how much
306         IERC20 buy_gem,   //maker (ask) buy which token
307         uint pos         //position to insert offer, 0 should be used if unknown
308     )
309     external
310     returns (uint);
311 }
312 
313 // File: contracts/ArrayUtils.sol
314 
315 library ArrayUtils {
316     function removeElement(bytes32[] storage array, uint index) internal {
317         if (index >= array.length) return;
318 
319         for (uint i = index; i < array.length - 1; i++) {
320             array[i] = array[i + 1];
321         }
322         delete array[array.length - 1];
323         array.length--;
324     }
325 
326     function findElement(bytes32[] storage array, bytes32 element) internal view returns (uint index, bool ok) {
327         for (uint i = 0; i < array.length; i++) {
328             if (array[i] == element) {
329                 return (i, true);
330             }
331         }
332 
333         return (0, false);
334     }
335 }
336 
337 // File: contracts/MakerDaoGateway.sol
338 
339 contract MakerDaoGateway is Pausable, DSMath {
340     using ArrayUtils for bytes32[];
341 
342     ISaiTub public saiTub;
343     IDex public dex;
344     IWrappedEther public weth;
345     IERC20 public peth;
346     IERC20 public dai;
347     IERC20 public mkr;
348 
349     mapping(bytes32 => address) public cdpOwner;
350     mapping(address => bytes32[]) public cdpsByOwner;
351 
352     event CdpOpened(address indexed owner, bytes32 cdpId);
353     event CdpClosed(address indexed owner, bytes32 cdpId);
354     event CollateralSupplied(address indexed owner, bytes32 cdpId, uint wethAmount, uint pethAmount);
355     event DaiBorrowed(address indexed owner, bytes32 cdpId, uint amount);
356     event DaiRepaid(address indexed owner, bytes32 cdpId, uint amount);
357     event CollateralReturned(address indexed owner, bytes32 cdpId, uint wethAmount, uint pethAmount);
358     event CdpTransferred(address indexed oldOwner, address indexed newOwner, bytes32 cdpId);
359     event CdpEjected(address indexed newOwner, bytes32 cdpId);
360     event CdpRegistered(address indexed newOwner, bytes32 cdpId);
361 
362     modifier isCdpOwner(bytes32 cdpId) {
363         require(cdpOwner[cdpId] == msg.sender || cdpId == 0, "CDP belongs to a different address");
364         _;
365     }
366 
367     constructor(ISaiTub _saiTub, IDex _dex) public {
368         saiTub = _saiTub;
369         dex = _dex;
370         weth = saiTub.gem();
371         peth = saiTub.skr();
372         dai = saiTub.sai();
373         mkr = saiTub.gov();
374     }
375 
376     function cdpsByOwnerLength(address _owner) external view returns (uint) {
377         return cdpsByOwner[_owner].length;
378     }
379 
380     function systemParameters() external view returns (uint liquidationRatio, uint annualStabilityFee, uint daiAvailable) {
381         liquidationRatio = saiTub.mat();
382         annualStabilityFee = rpow(saiTub.fee(), 365 days);
383         daiAvailable = sub(saiTub.cap(), dai.totalSupply());
384     }
385     
386     function cdpInfo(bytes32 cdpId) external returns (uint borrowedDai, uint outstandingDai, uint suppliedPeth) {
387         (, uint ink, uint art, ) = saiTub.cups(cdpId);
388         borrowedDai = art;
389         suppliedPeth = ink;
390         outstandingDai = add(saiTub.rap(cdpId), saiTub.tab(cdpId));
391     }
392     
393     function pethForWeth(uint wethAmount) public view returns (uint) {
394         return rdiv(wethAmount, saiTub.per());
395     }
396 
397     function wethForPeth(uint pethAmount) public view returns (uint) {
398         return rmul(pethAmount, saiTub.per());
399     }
400 
401     function() external payable {
402         // For unwrapping WETH
403     }
404 
405     // SUPPLY AND BORROW
406     
407     // specify cdpId if you want to use existing CDP, or pass 0 if you need to create a new one
408     // for new and active CDPs collateral amount should be > 0.005 PETH
409     function supplyEthAndBorrowDai(bytes32 cdpId, uint daiAmount) whenNotPaused isCdpOwner(cdpId) external payable {
410         bytes32 id = supplyEth(cdpId);
411         borrowDai(id, daiAmount);
412     }
413 
414     // specify cdpId if you want to use existing CDP, or pass 0 if you need to create a new one 
415     function supplyWethAndBorrowDai(bytes32 cdpId, uint wethAmount, uint daiAmount) whenNotPaused isCdpOwner(cdpId) external {
416         bytes32 id = supplyWeth(cdpId, wethAmount);
417         borrowDai(id, daiAmount);
418     }
419 
420     // returns id of actual CDP (existing or a new one)
421     // for new and active CDPs collateral amount should be > 0.005 PETH
422     function supplyEth(bytes32 cdpId) whenNotPaused isCdpOwner(cdpId) public payable returns (bytes32 _cdpId) {
423         if (msg.value > 0) {
424             weth.deposit.value(msg.value)();
425             return _supply(cdpId, msg.value);
426         }
427 
428         return cdpId;
429     }
430 
431     // for new and active CDPs collateral amount should be > 0.005 PETH
432     // don't forget to approve WETH before supplying
433     // returns id of actual CDP (existing or a new one)
434     function supplyWeth(bytes32 cdpId, uint wethAmount) whenNotPaused isCdpOwner(cdpId) public returns (bytes32 _cdpId) {
435         if (wethAmount > 0) {
436             require(weth.transferFrom(msg.sender, address(this), wethAmount));
437             return _supply(cdpId, wethAmount);
438         }
439 
440         return cdpId;
441     }
442 
443     function borrowDai(bytes32 cdpId, uint daiAmount) whenNotPaused isCdpOwner(cdpId) public {
444         if (daiAmount > 0) {
445             saiTub.draw(cdpId, daiAmount);
446 
447             require(dai.transfer(msg.sender, daiAmount));
448 
449             emit DaiBorrowed(msg.sender, cdpId, daiAmount);
450         }
451     }
452 
453     // REPAY AND RETURN
454 
455     // don't forget to approve DAI before repaying
456     function repayDaiAndReturnEth(bytes32 cdpId, uint daiAmount, uint ethAmount, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) external {
457         repayDai(cdpId, daiAmount, payFeeInDai);
458         returnEth(cdpId, ethAmount);
459     }
460 
461     // don't forget to approve DAI before repaying
462     // pass -1 to daiAmount to repay all outstanding debt
463     // pass -1 to wethAmount to return all collateral
464     function repayDaiAndReturnWeth(bytes32 cdpId, uint daiAmount, uint wethAmount, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) public {
465         repayDai(cdpId, daiAmount, payFeeInDai);
466         returnWeth(cdpId, wethAmount);
467     }
468 
469     // don't forget to approve DAI before repaying
470     // pass -1 to daiAmount to repay all outstanding debt
471     function repayDai(bytes32 cdpId, uint daiAmount, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) public {
472         if (daiAmount > 0) {
473             uint _daiAmount = daiAmount;
474             if (_daiAmount == uint(- 1)) {
475                 // repay all outstanding debt
476                 _daiAmount = saiTub.tab(cdpId);
477             }
478 
479             _ensureApproval(dai, address(saiTub));
480             _ensureApproval(mkr, address(saiTub));
481 
482             uint govFeeAmount = _calcGovernanceFee(cdpId, _daiAmount);
483             _handleGovFee(govFeeAmount, payFeeInDai);
484 
485             require(dai.transferFrom(msg.sender, address(this), _daiAmount));
486 
487             saiTub.wipe(cdpId, _daiAmount);
488 
489             emit DaiRepaid(msg.sender, cdpId, _daiAmount);
490         }
491     }
492 
493     function returnEth(bytes32 cdpId, uint ethAmount) whenNotPaused isCdpOwner(cdpId) public {
494         if (ethAmount > 0) {
495             uint effectiveWethAmount = _return(cdpId, ethAmount);
496             weth.withdraw(effectiveWethAmount);
497             msg.sender.transfer(effectiveWethAmount);
498         }
499     }
500 
501     function returnWeth(bytes32 cdpId, uint wethAmount) whenNotPaused isCdpOwner(cdpId) public {
502         if (wethAmount > 0) {
503             uint effectiveWethAmount = _return(cdpId, wethAmount);
504             require(weth.transfer(msg.sender, effectiveWethAmount));
505         }
506     }
507 
508     function closeCdp(bytes32 cdpId, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) external {
509         repayDaiAndReturnWeth(cdpId, uint(-1), uint(-1), payFeeInDai);
510         _removeCdp(cdpId, msg.sender);
511         saiTub.shut(cdpId);
512         
513         emit CdpClosed(msg.sender, cdpId);
514     }
515 
516     // TRANSFER AND ADOPT
517 
518     // You can migrate your CDP from MakerDaoGateway contract to another owner
519     function transferCdp(bytes32 cdpId, address nextOwner) isCdpOwner(cdpId) external {
520         address _owner = nextOwner;
521         if (_owner == address(0x0)) {
522             _owner = msg.sender;
523         }
524         
525         saiTub.give(cdpId, _owner);
526 
527         _removeCdp(cdpId, msg.sender);
528 
529         emit CdpTransferred(msg.sender, _owner, cdpId);
530     }
531     
532     function ejectCdp(bytes32 cdpId) onlyPauser external {
533         address owner = cdpOwner[cdpId];
534         saiTub.give(cdpId, owner);
535 
536         _removeCdp(cdpId, owner);
537 
538         emit CdpEjected(owner, cdpId);
539     }
540 
541     // If you want to migrate existing CDP to MakerDaoGateway contract,
542     // you need to register your cdp first with this function, and then execute `give` operation,
543     // transferring CDP to the MakerDaoGateway contract
544     function registerCdp(bytes32 cdpId, address owner) whenNotPaused external {
545         require(saiTub.lad(cdpId) == msg.sender, "Can't register other's CDP");
546         require(cdpOwner[cdpId] == address(0x0), "Can't register CDP twice");
547 
548         address _owner = owner;
549         if (_owner == address(0x0)) {
550             _owner = msg.sender;
551         }
552 
553         cdpOwner[cdpId] = _owner;
554         cdpsByOwner[_owner].push(cdpId);
555 
556         emit CdpRegistered(_owner, cdpId);
557     }
558 
559     // INTERNAL FUNCTIONS
560 
561     function _supply(bytes32 cdpId, uint wethAmount) internal returns (bytes32 _cdpId) {
562         _cdpId = cdpId;
563         if (_cdpId == 0) {
564             _cdpId = _createCdp();
565         }
566 
567         _ensureApproval(weth, address(saiTub));
568 
569         uint pethAmount = pethForWeth(wethAmount);
570 
571         saiTub.join(pethAmount);
572 
573         _ensureApproval(peth, address(saiTub));
574 
575         saiTub.lock(_cdpId, pethAmount);
576         emit CollateralSupplied(msg.sender, _cdpId, wethAmount, pethAmount);
577     }
578 
579     function _return(bytes32 cdpId, uint wethAmount) internal returns (uint _wethAmount) {
580         uint pethAmount;
581 
582         if (wethAmount == uint(- 1)) {
583             // return all collateral
584             pethAmount = saiTub.ink(cdpId);
585         } else {
586             pethAmount = pethForWeth(wethAmount);
587         }
588 
589         saiTub.free(cdpId, pethAmount);
590 
591         _ensureApproval(peth, address(saiTub));
592 
593         saiTub.exit(pethAmount);
594 
595         _wethAmount = wethForPeth(pethAmount);
596 
597         emit CollateralReturned(msg.sender, cdpId, _wethAmount, pethAmount);
598     }
599 
600     function _calcGovernanceFee(bytes32 cdpId, uint daiAmount) internal returns (uint mkrFeeAmount) {
601         uint daiFeeAmount = rmul(daiAmount, rdiv(saiTub.rap(cdpId), saiTub.tab(cdpId)));
602         (bytes32 val, bool ok) = saiTub.pep().peek();
603         require(ok && val != 0, 'Unable to get mkr rate');
604 
605         return wdiv(daiFeeAmount, uint(val));
606     }
607 
608     function _handleGovFee(uint mkrGovAmount, bool payWithDai) internal {
609         if (mkrGovAmount > 0) {
610             if (payWithDai) {
611                 uint daiAmount = dex.getPayAmount(dai, mkr, mkrGovAmount);
612 
613                 _ensureApproval(dai, address(dex));
614 
615                 require(dai.transferFrom(msg.sender, address(this), daiAmount));
616                 dex.buyAllAmount(mkr, mkrGovAmount, dai, daiAmount);
617             } else {
618                 require(mkr.transferFrom(msg.sender, address(this), mkrGovAmount));
619             }
620         }
621     }
622 
623     function _ensureApproval(IERC20 token, address spender) internal {
624         if (token.allowance(address(this), spender) != uint(- 1)) {
625             require(token.approve(spender, uint(- 1)));
626         }
627     }
628 
629     function _createCdp() internal returns (bytes32 cdpId) {
630         cdpId = saiTub.open();
631 
632         cdpOwner[cdpId] = msg.sender;
633         cdpsByOwner[msg.sender].push(cdpId);
634 
635         emit CdpOpened(msg.sender, cdpId);
636     }
637     
638     function _removeCdp(bytes32 cdpId, address owner) internal {
639         (uint i, bool ok) = cdpsByOwner[owner].findElement(cdpId);
640         require(ok, "Can't find cdp in owner's list");
641         
642         cdpsByOwner[owner].removeElement(i);
643         delete cdpOwner[cdpId];
644     }
645 }