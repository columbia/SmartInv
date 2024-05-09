1 pragma solidity ^0.5.16;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function transfer(address recipient, uint256 amount)
9         external
10         returns (bool);
11 
12     function allowance(address owner, address spender)
13         external
14         view
15         returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31 }
32 
33 contract Context {
34     constructor() internal {}
35 
36     // solhint-disable-previous-line no-empty-blocks
37 
38     function _msgSender() internal view returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() internal {
57         _owner = _msgSender();
58         emit OwnershipTransferred(address(0), _owner);
59     }
60 
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     modifier onlyOwner() {
66         require(isOwner(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     function isOwner() public view returns (bool) {
71         return _msgSender() == _owner;
72     }
73 
74     function renounceOwnership() public onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     function transferOwnership(address newOwner) public onlyOwner {
80         _transferOwnership(newOwner);
81     }
82 
83     function _transferOwnership(address newOwner) internal {
84         require(
85             newOwner != address(0),
86             "Ownable: new owner is the zero address"
87         );
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 contract ERC20 is Context, IERC20 {
94     using SafeMath for uint256;
95 
96     mapping(address => uint256) private _balances;
97 
98     mapping(address => mapping(address => uint256)) private _allowances;
99 
100     uint256 private _totalSupply;
101 
102     function totalSupply() public view returns (uint256) {
103         return _totalSupply;
104     }
105 
106     function balanceOf(address account) public view returns (uint256) {
107         return _balances[account];
108     }
109 
110     function transfer(address recipient, uint256 amount) public returns (bool) {
111         _transfer(_msgSender(), recipient, amount);
112         return true;
113     }
114 
115     function allowance(address owner, address spender)
116         public
117         view
118         returns (uint256)
119     {
120         return _allowances[owner][spender];
121     }
122 
123     function approve(address spender, uint256 amount) public returns (bool) {
124         _approve(_msgSender(), spender, amount);
125         return true;
126     }
127 
128     function transferFrom(
129         address sender,
130         address recipient,
131         uint256 amount
132     ) public returns (bool) {
133         _transfer(sender, recipient, amount);
134         _approve(
135             sender,
136             _msgSender(),
137             _allowances[sender][_msgSender()].sub(
138                 amount,
139                 "ERC20: transfer amount exceeds allowance"
140             )
141         );
142         return true;
143     }
144 
145     function increaseAllowance(address spender, uint256 addedValue)
146         public
147         returns (bool)
148     {
149         _approve(
150             _msgSender(),
151             spender,
152             _allowances[_msgSender()][spender].add(addedValue)
153         );
154         return true;
155     }
156 
157     function decreaseAllowance(address spender, uint256 subtractedValue)
158         public
159         returns (bool)
160     {
161         _approve(
162             _msgSender(),
163             spender,
164             _allowances[_msgSender()][spender].sub(
165                 subtractedValue,
166                 "ERC20: decreased allowance below zero"
167             )
168         );
169         return true;
170     }
171 
172     function _transfer(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) internal {
177         require(sender != address(0), "ERC20: transfer from the zero address");
178         require(recipient != address(0), "ERC20: transfer to the zero address");
179 
180         _balances[sender] = _balances[sender].sub(
181             amount,
182             "ERC20: transfer amount exceeds balance"
183         );
184         _balances[recipient] = _balances[recipient].add(amount);
185         emit Transfer(sender, recipient, amount);
186     }
187 
188     function _mint(address account, uint256 amount) internal {
189         require(account != address(0), "ERC20: mint to the zero address");
190 
191         _totalSupply = _totalSupply.add(amount);
192         _balances[account] = _balances[account].add(amount);
193         emit Transfer(address(0), account, amount);
194     }
195 
196     function _burn(address account, uint256 amount) internal {
197         require(account != address(0), "ERC20: burn from the zero address");
198 
199         _balances[account] = _balances[account].sub(
200             amount,
201             "ERC20: burn amount exceeds balance"
202         );
203         _totalSupply = _totalSupply.sub(amount);
204         emit Transfer(account, address(0), amount);
205     }
206 
207     function _approve(
208         address owner,
209         address spender,
210         uint256 amount
211     ) internal {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214 
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _burnFrom(address account, uint256 amount) internal {
220         _burn(account, amount);
221         _approve(
222             account,
223             _msgSender(),
224             _allowances[account][_msgSender()].sub(
225                 amount,
226                 "ERC20: burn amount exceeds allowance"
227             )
228         );
229     }
230 }
231 
232 contract ERC20Detailed is IERC20 {
233     string private _name;
234     string private _symbol;
235     uint8 private _decimals;
236 
237     constructor(
238         string memory name,
239         string memory symbol,
240         uint8 decimals
241     ) public {
242         _name = name;
243         _symbol = symbol;
244         _decimals = decimals;
245     }
246 
247     function name() public view returns (string memory) {
248         return _name;
249     }
250 
251     function symbol() public view returns (string memory) {
252         return _symbol;
253     }
254 
255     function decimals() public view returns (uint8) {
256         return _decimals;
257     }
258 }
259 
260 library SafeMath {
261     function add(uint256 a, uint256 b) internal pure returns (uint256) {
262         uint256 c = a + b;
263         require(c >= a, "SafeMath: addition overflow");
264 
265         return c;
266     }
267 
268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269         return sub(a, b, "SafeMath: subtraction overflow");
270     }
271 
272     function sub(
273         uint256 a,
274         uint256 b,
275         string memory errorMessage
276     ) internal pure returns (uint256) {
277         require(b <= a, errorMessage);
278         uint256 c = a - b;
279 
280         return c;
281     }
282 
283     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
284         if (a == 0) {
285             return 0;
286         }
287 
288         uint256 c = a * b;
289         require(c / a == b, "SafeMath: multiplication overflow");
290 
291         return c;
292     }
293 
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         return div(a, b, "SafeMath: division by zero");
296     }
297 
298     function div(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         // Solidity only automatically asserts when dividing by 0
304         require(b > 0, errorMessage);
305         uint256 c = a / b;
306 
307         return c;
308     }
309 
310     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
311         return mod(a, b, "SafeMath: modulo by zero");
312     }
313 
314     function mod(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         require(b != 0, errorMessage);
320         return a % b;
321     }
322 }
323 
324 library Address {
325     function isContract(address account) internal view returns (bool) {
326         bytes32 codehash;
327 
328 
329             bytes32 accountHash
330          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
331         // solhint-disable-next-line no-inline-assembly
332         assembly {
333             codehash := extcodehash(account)
334         }
335         return (codehash != 0x0 && codehash != accountHash);
336     }
337 
338     function toPayable(address account)
339         internal
340         pure
341         returns (address payable)
342     {
343         return address(uint160(account));
344     }
345 
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(
348             address(this).balance >= amount,
349             "Address: insufficient balance"
350         );
351 
352         // solhint-disable-next-line avoid-call-value
353         (bool success, ) = recipient.call.value(amount)("");
354         require(
355             success,
356             "Address: unable to send value, recipient may have reverted"
357         );
358     }
359 }
360 
361 library SafeERC20 {
362     using SafeMath for uint256;
363     using Address for address;
364 
365     function safeTransfer(
366         IERC20 token,
367         address to,
368         uint256 value
369     ) internal {
370         callOptionalReturn(
371             token,
372             abi.encodeWithSelector(token.transfer.selector, to, value)
373         );
374     }
375 
376     function safeTransferFrom(
377         IERC20 token,
378         address from,
379         address to,
380         uint256 value
381     ) internal {
382         callOptionalReturn(
383             token,
384             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
385         );
386     }
387 
388     function safeApprove(
389         IERC20 token,
390         address spender,
391         uint256 value
392     ) internal {
393         require(
394             (value == 0) || (token.allowance(address(this), spender) == 0),
395             "SafeERC20: approve from non-zero to non-zero allowance"
396         );
397         callOptionalReturn(
398             token,
399             abi.encodeWithSelector(token.approve.selector, spender, value)
400         );
401     }
402 
403     function safeIncreaseAllowance(
404         IERC20 token,
405         address spender,
406         uint256 value
407     ) internal {
408         uint256 newAllowance = token.allowance(address(this), spender).add(
409             value
410         );
411         callOptionalReturn(
412             token,
413             abi.encodeWithSelector(
414                 token.approve.selector,
415                 spender,
416                 newAllowance
417             )
418         );
419     }
420 
421     function safeDecreaseAllowance(
422         IERC20 token,
423         address spender,
424         uint256 value
425     ) internal {
426         uint256 newAllowance = token.allowance(address(this), spender).sub(
427             value,
428             "SafeERC20: decreased allowance below zero"
429         );
430         callOptionalReturn(
431             token,
432             abi.encodeWithSelector(
433                 token.approve.selector,
434                 spender,
435                 newAllowance
436             )
437         );
438     }
439 
440     function callOptionalReturn(IERC20 token, bytes memory data) private {
441         require(address(token).isContract(), "SafeERC20: call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = address(token).call(data);
445         require(success, "SafeERC20: low-level call failed");
446 
447         if (returndata.length > 0) {
448             // Return data is optional
449             // solhint-disable-next-line max-line-length
450             require(
451                 abi.decode(returndata, (bool)),
452                 "SafeERC20: ERC20 operation did not succeed"
453             );
454         }
455     }
456 }
457 
458 interface Controller {
459     function withdraw(address, uint256) external;
460 
461     function balanceOf(address) external view returns (uint256);
462 
463     function earn(address, uint256) external;
464 }
465 
466 contract aiORAI is ERC20, ERC20Detailed {
467     using SafeERC20 for IERC20;
468     using Address for address;
469     using SafeMath for uint256;
470 
471     IERC20 public token;
472     address public rewardAddress = 0x4c11249814f11b9346808179Cf06e71ac328c1b5;
473     uint256 public rewardAmount = 1075;
474     uint256 public min = 9500;
475     uint256 public constant max = 10000;
476 
477     address public governance;
478     address public controller;
479 
480     constructor(address _token, address _controller)
481         public
482         ERC20Detailed(
483             string(abi.encodePacked("yAI ", ERC20Detailed(_token).name())),
484             string(abi.encodePacked("ai", ERC20Detailed(_token).symbol())),
485             ERC20Detailed(_token).decimals()
486         )
487     {
488         token = IERC20(_token);
489         governance = msg.sender;
490         controller = _controller;
491     }
492 
493     function balance() public view returns (uint256) {
494         return
495             token.balanceOf(address(this)).add(
496                 Controller(controller).balanceOf(address(token))
497             );
498     }
499 
500     function setMin(uint256 _min) external {
501         require(msg.sender == governance, "!governance");
502         min = _min;
503     }
504 
505     function setRewardAmount(uint256 _amount) external {
506         require(msg.sender == governance, "!governance");
507         rewardAmount = _amount;
508     }
509 
510     function setRewardAddress(address _address) external {
511         require(msg.sender == governance, "!governance");
512         rewardAddress = address(_address);
513     }
514 
515     function setGovernance(address _governance) public {
516         require(msg.sender == governance, "!governance");
517         governance = _governance;
518     }
519 
520     function setController(address _controller) public {
521         require(msg.sender == governance, "!governance");
522         controller = _controller;
523     }
524 
525     // Custom logic in here for how much the vault allows to be borrowed
526     // Sets minimum required on-hand to keep small withdrawals cheap
527     function available() public view returns (uint256) {
528         return token.balanceOf(address(this)).mul(min).div(max);
529     }
530 
531     function earn() public {
532         uint256 _bal = available();
533         token.safeTransfer(controller, _bal);
534         Controller(controller).earn(address(token), _bal);
535     }
536 
537     function depositAll() external {
538         deposit(token.balanceOf(msg.sender));
539     }
540 
541     function deposit(uint256 _amount) public {
542         uint256 _pool = balance();
543         uint256 _before = token.balanceOf(address(this));
544         token.safeTransferFrom(msg.sender, address(this), _amount);
545         uint256 _after = token.balanceOf(address(this));
546         _amount = _after.sub(_before); // Additional check for deflationary tokens
547         uint256 shares = 0;
548         if (totalSupply() == 0) {
549             shares = _amount;
550         } else {
551             shares = (_amount.mul(totalSupply())).div(_pool);
552         }
553         _mint(msg.sender, shares);
554     }
555 
556     function withdrawAll() external {
557         withdraw(balanceOf(msg.sender));
558     }
559 
560     function checkReward(address _reciver) public view returns (uint256) {
561         uint256 _balance = balanceOf(_reciver);
562         uint256 amount = (_balance.mul(rewardAmount)).div(totalSupply()).mul(
563             10**18
564         );
565         return amount;
566     }
567 
568     function checkRewardBalance() public view returns (uint256) {
569         uint256 _balance = ERC20(rewardAddress).balanceOf(msg.sender);
570         return _balance;
571     }
572 
573     function reward(address[] memory _addressList) public {
574         // require(msg.sender == governance, "!governance");
575         for (uint256 i = 0; i < _addressList.length; i++) {
576             address _address = _addressList[i];
577             uint256 _balance = balanceOf(_address);
578             if (_balance > 0) {
579                 uint256 amount = (_balance.mul(10**18).mul(rewardAmount)).div(
580                     totalSupply()
581                 );
582                 ERC20(rewardAddress).transferFrom(msg.sender, _address, amount);
583             }
584         }
585     }
586 
587     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
588     function harvest(address reserve, uint256 amount) external {
589         require(msg.sender == controller, "!controller");
590         require(reserve != address(token), "token");
591         //IERC20(reserve).safeTransfer(0x3e0cb4b0c6F81f8dd28e517c5C7B6dcF9d9bDb08, amount);
592         IERC20(reserve).safeTransfer(controller, amount);
593     }
594 
595     // No rebalance implementation for lower fees and faster swaps
596     function withdraw(uint256 _shares) public {
597         uint256 r = (balance().mul(_shares)).div(totalSupply());
598         _burn(msg.sender, _shares);
599 
600         // Check balance
601         uint256 b = token.balanceOf(address(this));
602         if (b < r) {
603             uint256 _withdraw = r.sub(b);
604             Controller(controller).withdraw(address(token), _withdraw);
605             uint256 _after = token.balanceOf(address(this));
606             uint256 _diff = _after.sub(b);
607             if (_diff < _withdraw) {
608                 r = b.add(_diff);
609             }
610         }
611 
612         token.safeTransfer(msg.sender, r);
613     }
614 
615     function getPricePerFullShare() public view returns (uint256) {
616         return balance().mul(1e18).div(totalSupply());
617     }
618 }