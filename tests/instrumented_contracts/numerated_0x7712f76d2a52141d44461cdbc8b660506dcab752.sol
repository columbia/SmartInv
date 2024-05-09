1 pragma solidity ^0.5.11;
2 
3 // Voken Shareholders Contract for Voken2.0
4 //
5 // More info:
6 //   https://vision.network
7 //   https://voken.io
8 //
9 // Contact us:
10 //   support@vision.network
11 //   support@voken.io
12 
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations with added overflow checks.
16  */
17 library SafeMath256 {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on overflow.
20      */
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24 
25         return c;
26     }
27 
28     /**
29      * @dev Returns the subtraction of two unsigned integers, reverting on
30      * overflow (when the result is negative).
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      */
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
49      */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the integer division of two unsigned integers. Reverts on
63      * division by zero. The result is rounded towards zero.
64      */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     /**
70      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
71      * division by zero. The result is rounded towards zero.
72      */
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         // Solidity only automatically asserts when dividing by 0
75         require(b > 0, errorMessage);
76         return a / b;
77     }
78 
79     /**
80      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
81      * Reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86 
87     /**
88      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
89      * Reverts with custom message when dividing by zero.
90      */
91     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b != 0, errorMessage);
93         return a % b;
94     }
95 }
96 
97 
98 /**
99  * @title Roles
100  * @dev Library for managing addresses assigned to a Role.
101  */
102 library Roles {
103     struct Role {
104         mapping (address => bool) bearer;
105     }
106 
107     /**
108      * @dev Give an account access to this role.
109      */
110     function add(Role storage role, address account) internal {
111         require(!has(role, account), "Roles: account already has role");
112         role.bearer[account] = true;
113     }
114 
115     /**
116      * @dev Remove an account's access to this role.
117      */
118     function remove(Role storage role, address account) internal {
119         require(has(role, account), "Roles: account does not have role");
120         role.bearer[account] = false;
121     }
122 
123     /**
124      * @dev Check if an account has this role.
125      * @return bool
126      */
127     function has(Role storage role, address account) internal view returns (bool) {
128         require(account != address(0), "Roles: account is the zero address");
129         return role.bearer[account];
130     }
131 }
132 
133 
134 /**
135  * @dev Interface of the ERC20 standard
136  */
137 interface IERC20 {
138     function name() external view returns (string memory);
139     function symbol() external view returns (string memory);
140     function decimals() external view returns (uint8);
141 
142     function totalSupply() external view returns (uint256);
143     function balanceOf(address account) external view returns (uint256);
144     function transfer(address recipient, uint256 amount) external returns (bool);
145     function allowance(address owner, address spender) external view returns (uint256);
146     function approve(address spender, uint256 amount) external returns (bool);
147     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
148 
149     event Transfer(address indexed from, address indexed to, uint256 value);
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 
154 /**
155  * @dev Interface of an allocation contract
156  */
157 interface IAllocation {
158     function reservedOf(address account) external view returns (uint256);
159 }
160 
161 
162 /**
163  * @dev Interface of Voken2.0
164  */
165 interface IVoken2 {
166     function balanceOf(address account) external view returns (uint256);
167     function transfer(address recipient, uint256 amount) external returns (bool);
168     function mintWithAllocation(address account, uint256 amount, address allocationContract) external returns (bool);
169 }
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  */
177 contract Ownable {
178     address internal _owner;
179     address internal _newOwner;
180 
181     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182     event OwnershipAccepted(address indexed previousOwner, address indexed newOwner);
183 
184 
185     /**
186      * @dev Initializes the contract setting the deployer as the initial owner.
187      */
188     constructor () internal {
189         _owner = msg.sender;
190         emit OwnershipTransferred(address(0), _owner);
191     }
192 
193     /**
194      * @dev Returns the addresses of the current and new owner.
195      */
196     function owner() public view returns (address currentOwner, address newOwner) {
197         currentOwner = _owner;
198         newOwner = _newOwner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(isOwner(msg.sender), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Returns true if the caller is the current owner.
211      */
212     function isOwner(address account) public view returns (bool) {
213         return account == _owner;
214     }
215 
216     /**
217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
218      *
219      * IMPORTANT: Need to run {acceptOwnership} by the new owner.
220      */
221     function _transferOwnership(address newOwner) internal {
222         require(newOwner != address(0), "Ownable: new owner is the zero address");
223 
224         emit OwnershipTransferred(_owner, newOwner);
225         _newOwner = newOwner;
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      *
231      * Can only be called by the current owner.
232      */
233     function transferOwnership(address newOwner) public onlyOwner {
234         _transferOwnership(newOwner);
235     }
236 
237     /**
238      * @dev Accept ownership of the contract.
239      *
240      * Can only be called by the new owner.
241      */
242     function acceptOwnership() public {
243         require(msg.sender == _newOwner, "Ownable: caller is not the new owner address");
244         require(msg.sender != address(0), "Ownable: caller is the zero address");
245 
246         emit OwnershipAccepted(_owner, msg.sender);
247         _owner = msg.sender;
248         _newOwner = address(0);
249     }
250 
251     /**
252      * @dev Rescue compatible ERC20 Token
253      *
254      * Can only be called by the current owner.
255      */
256     function rescueTokens(address tokenAddr, address recipient, uint256 amount) external onlyOwner {
257         IERC20 _token = IERC20(tokenAddr);
258         require(recipient != address(0), "Rescue: recipient is the zero address");
259         uint256 balance = _token.balanceOf(address(this));
260 
261         require(balance >= amount, "Rescue: amount exceeds balance");
262         _token.transfer(recipient, amount);
263     }
264 
265     /**
266      * @dev Withdraw Ether
267      *
268      * Can only be called by the current owner.
269      */
270     function withdrawEther(address payable recipient, uint256 amount) external onlyOwner {
271         require(recipient != address(0), "Withdraw: recipient is the zero address");
272 
273         uint256 balance = address(this).balance;
274 
275         require(balance >= amount, "Withdraw: amount exceeds balance");
276         recipient.transfer(amount);
277     }
278 }
279 
280 
281 /**
282  * @title Voken Shareholders
283  */
284 contract VokenShareholders is Ownable, IAllocation {
285     using SafeMath256 for uint256;
286     using Roles for Roles.Role;
287 
288     IVoken2 private _VOKEN = IVoken2(0xFfFAb974088Bd5bF3d7E6F522e93Dd7861264cDB);
289     Roles.Role private _proxies;
290 
291     uint256 private _ALLOCATION_TIMESTAMP = 1598918399; // Sun, 30 Aug 2020 23:59:59 +0000
292     uint256 private _ALLOCATION_INTERVAL = 1 days;
293     uint256 private _ALLOCATION_STEPS = 60;
294 
295     uint256 private _page;
296     uint256 private _weis;
297     uint256 private _vokens;
298 
299     address[] private _shareholders;
300     mapping (address => bool) private _isShareholder;
301 
302     mapping (address => uint256) private _withdrawPos;
303     mapping (uint256 => address[]) private _pageShareholders;
304     mapping (uint256 => mapping (address => bool)) private _isPageShareholder;
305 
306     mapping (uint256 => uint256) private _pageEndingBlock;
307     mapping (uint256 => uint256) private _pageEthers;
308     mapping (uint256 => uint256) private _pageVokens;
309     mapping (uint256 => uint256) private _pageVokenSum;
310     mapping (uint256 => mapping (address => uint256)) private _pageVokenHoldings;
311     mapping (uint256 => mapping (address => uint256)) private _pageEtherDividends;
312 
313     mapping (address => uint256) private _allocations;
314 
315     event ProxyAdded(address indexed account);
316     event ProxyRemoved(address indexed account);
317     event Dividend(address indexed account, uint256 amount, uint256 page);
318 
319 
320     /**
321      * @dev Throws if called by account which is not a proxy.
322      */
323     modifier onlyProxy() {
324         require(isProxy(msg.sender), "ProxyRole: caller does not have the Proxy role");
325         _;
326     }
327 
328     /**
329      * @dev Returns true if the `account` has the Proxy role.
330      */
331     function isProxy(address account) public view returns (bool) {
332         return _proxies.has(account);
333     }
334 
335     /**
336      * @dev Give an `account` access to the Proxy role.
337      *
338      * Can only be called by the current owner.
339      */
340     function addProxy(address account) public onlyOwner {
341         _proxies.add(account);
342         emit ProxyAdded(account);
343     }
344 
345     /**
346      * @dev Remove an `account` access from the Proxy role.
347      *
348      * Can only be called by the current owner.
349      */
350     function removeProxy(address account) public onlyOwner {
351         _proxies.remove(account);
352         emit ProxyRemoved(account);
353     }
354 
355     /**
356      * @dev Returns the VOKEN main contract address.
357      */
358     function VOKEN() public view returns (IVoken2) {
359         return _VOKEN;
360     }
361 
362     /**
363      * @dev Returns the max page number.
364      */
365     function page() public view returns (uint256) {
366         return _page;
367     }
368 
369     /**
370      * @dev Returns the amount of deposited Ether.
371      */
372     function weis() public view returns (uint256) {
373         return _weis;
374     }
375 
376     /**
377      * @dev Returns the amount of VOKEN holding by all shareholders.
378      */
379     function vokens() public view returns (uint256) {
380         return _vokens;
381     }
382 
383     /**
384      * @dev Returns the shareholders list on `pageNumber`.
385      */
386     function shareholders(uint256 pageNumber) public view returns (address[] memory) {
387         if (pageNumber > 0) {
388             return _pageShareholders[pageNumber];
389         }
390 
391         return _shareholders;
392     }
393 
394     /**
395      * @dev Returns the shareholders counter on `pageNumber`.
396      */
397     function shareholdersCounter(uint256 pageNumber) public view returns (uint256) {
398         if (pageNumber > 0) {
399             return _pageShareholders[pageNumber].length;
400         }
401 
402         return _shareholders.length;
403     }
404 
405     /**
406      * @dev Returns the amount of deposited Ether at `pageNumber`.
407      */
408     function pageEther(uint256 pageNumber) public view returns (uint256) {
409         return _pageEthers[pageNumber];
410     }
411 
412     /**
413      * @dev Returns the amount of deposited Ether till `pageNumber`.
414      */
415     function pageEtherSum(uint256 pageNumber) public view returns (uint256) {
416         uint256 __page = _pageNumber(pageNumber);
417         uint256 __amount;
418 
419         for (uint256 i = 1; i <= __page; i++) {
420             __amount = __amount.add(_pageEthers[i]);
421         }
422 
423         return __amount;
424     }
425 
426     /**
427      * @dev Returns the amount of VOKEN holding by all shareholders at `pageNumber`.
428      */
429     function pageVoken(uint256 pageNumber) public view returns (uint256) {
430         return _pageVokens[pageNumber];
431     }
432 
433     /**
434      * @dev Returns the amount of VOKEN holding by all shareholders till `pageNumber`.
435      */
436     function pageVokenSum(uint256 pageNumber) public view returns (uint256) {
437         return _pageVokenSum[_pageNumber(pageNumber)];
438     }
439 
440     /**
441      * Returns the ending block number of `pageNumber`.
442      */
443     function pageEndingBlock(uint256 pageNumber) public view returns (uint256) {
444         return _pageEndingBlock[pageNumber];
445     }
446 
447     /**
448      * Returns the page number greater than 0 by `pageNmber`.
449      */
450     function _pageNumber(uint256 pageNumber) internal view returns (uint256) {
451         if (pageNumber > 0) {
452             return pageNumber;
453         }
454 
455         else {
456             return _page;
457         }
458     }
459 
460     /**
461      * @dev Returns the amount of VOKEN holding by `account` and `pageNumber`.
462      */
463     function vokenHolding(address account, uint256 pageNumber) public view returns (uint256) {
464         uint256 __page;
465         uint256 __amount;
466 
467         if (pageNumber > 0) {
468             __page = pageNumber;
469         }
470 
471         else {
472             __page = _page;
473         }
474 
475         for (uint256 i = 1; i <= __page; i++) {
476             __amount = __amount.add(_pageVokenHoldings[i][account]);
477         }
478 
479         return __amount;
480     }
481 
482     /**
483      * @dev Returns the ether dividend of `account` on `pageNumber`.
484      */
485     function etherDividend(address account, uint256 pageNumber) public view returns (uint256 amount,
486                                                                                      uint256 dividend,
487                                                                                      uint256 remain) {
488         if (pageNumber > 0) {
489             amount = pageEther(pageNumber).mul(vokenHolding(account, pageNumber)).div(pageVokenSum(pageNumber));
490             dividend = _pageEtherDividends[pageNumber][account];
491         }
492 
493         else {
494             for (uint256 i = 1; i <= _page; i++) {
495                 uint256 __pageEtherDividend = pageEther(i).mul(vokenHolding(account, i)).div(pageVokenSum(i));
496                 amount = amount.add(__pageEtherDividend);
497                 dividend = dividend.add(_pageEtherDividends[i][account]);
498             }
499         }
500 
501         remain = amount.sub(dividend);
502     }
503 
504     /**
505      * @dev Returns the allocation of `account`.
506      */
507     function allocation(address account) public view returns (uint256) {
508         return _allocations[account];
509     }
510 
511     /**
512      * @dev Returns the reserved amount of VOKENs by `account`.
513      */
514     function reservedOf(address account) public view returns (uint256 reserved) {
515         reserved = _allocations[account];
516 
517         if (now > _ALLOCATION_TIMESTAMP && reserved > 0) {
518             uint256 __passed = now.sub(_ALLOCATION_TIMESTAMP).div(_ALLOCATION_INTERVAL).add(1);
519 
520             if (__passed > _ALLOCATION_STEPS) {
521                 reserved = 0;
522             }
523             else {
524                 reserved = reserved.sub(reserved.mul(__passed).div(_ALLOCATION_STEPS));
525             }
526         }
527     }
528 
529 
530     /**
531      * @dev Constructor
532      */
533     constructor () public {
534         _page = 1;
535 
536         addProxy(msg.sender);
537     }
538 
539     /**
540      * @dev {Deposit} or {Withdraw}
541      */
542     function () external payable {
543         // deposit
544         if (msg.value > 0) {
545             _weis = _weis.add(msg.value);
546             _pageEthers[_page] = _pageEthers[_page].add(msg.value);
547         }
548 
549         // withdraw
550         else if (_isShareholder[msg.sender]) {
551             uint256 __vokenHolding;
552 
553             for (uint256 i = 1; i <= _page.sub(1); i++) {
554                 __vokenHolding = __vokenHolding.add(_pageVokenHoldings[i][msg.sender]);
555 
556                 if (_withdrawPos[msg.sender] < i) {
557                     uint256 __etherAmount = _pageEthers[i].mul(__vokenHolding).div(_pageVokenSum[i]);
558 
559                     _withdrawPos[msg.sender] = i;
560                     _pageEtherDividends[i][msg.sender] = __etherAmount;
561 
562                     msg.sender.transfer(__etherAmount);
563                     emit Dividend(msg.sender, __etherAmount, i);
564                 }
565             }
566         }
567 
568         assert(true);
569     }
570 
571     /**
572      * @dev End the current page.
573      */
574     function endPage() public onlyProxy {
575         require(_pageEthers[_page] > 0, "Ethers on current page is zero.");
576 
577         _pageEndingBlock[_page] = block.number;
578 
579         _page = _page.add(1);
580         _pageVokenSum[_page] = _vokens;
581 
582         assert(true);
583     }
584 
585     /**
586      * @dev Push shareholders.
587      *
588      * Can only be called by a proxy.
589      */
590     function pushShareholders(address[] memory accounts, uint256[] memory values) public onlyProxy {
591         require(accounts.length == values.length, "Shareholders: batch length is not match");
592 
593         for (uint256 i = 0; i < accounts.length; i++) {
594             address __account = accounts[i];
595             uint256 __value = values[i];
596 
597             if (!_isShareholder[__account]) {
598                 _shareholders.push(__account);
599                 _isShareholder[__account] = true;
600             }
601 
602             if (!_isPageShareholder[_page][__account]) {
603                 _pageShareholders[_page].push(__account);
604                 _isPageShareholder[_page][__account] = true;
605             }
606 
607             _vokens = _vokens.add(__value);
608             _pageVokens[_page] = _pageVokens[_page].add(__value);
609             _pageVokenSum[_page] = _vokens;
610             _pageVokenHoldings[_page][__account] = _pageVokenHoldings[_page][__account].add(__value);
611 
612             _allocations[__account] = _allocations[__account].add(__value);
613             assert(_VOKEN.mintWithAllocation(__account, __value, address(this)));
614         }
615 
616         assert(true);
617     }
618 }